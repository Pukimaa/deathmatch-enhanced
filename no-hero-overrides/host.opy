#!mainFile "main.opy"

rule "Stats HUD":
    @Event eachPlayer

    hudSubtext(eventPlayer if eventPlayer.StatsState == true else [], "Server Load: {0}".format(getServerLoad()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

rule "Toggle Stats":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true

    if eventPlayer.StatsState != true:
        eventPlayer.StatsState = true
    else:
        eventPlayer.StatsState = false


rule "Toggle Menu":
    @Event eachPlayer
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition CamState != true
    
    if MenuState != true:
        MenuState = true
    else:
        MenuState = false


rule "Menu HUD":
    @Event eachPlayer
    @Condition eventPlayer == hostPlayer
    
    MenuItems = 1
    hudSubtext(eventPlayer if MenuState and MenuSelection != 0 and CamState != true else [], "Restart Game", HudPosition.TOP, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(eventPlayer if MenuState and MenuSelection == 0 and CamState != true else [], "-> Restart Game", HudPosition.TOP, 1, Color.AQUA, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(eventPlayer if MenuState and MenuSelection != 1 and CamState != true else [], "Debug Cam", HudPosition.TOP, 2, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(eventPlayer if MenuState and MenuSelection == 1 and CamState != true else [], "-> Debug Cam", HudPosition.TOP, 2, Color.AQUA, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(eventPlayer if CamState == true else [], "-> Stop Debug Cam (Press {0})".format(buttonString(Button.INTERACT)), HudPosition.TOP, 2, Color.AQUA, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

rule "Joined Menu":
    @Event eachPlayer
    @Condition eventPlayer == hostPlayer
    @Condition MenuState == true
    
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.JUMP)
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.CROUCH)
    eventPlayer.disallowButton(Button.ULTIMATE)
    eventPlayer.disallowButton(Button.MELEE)
    eventPlayer.setStatusEffect(null, Status.ROOTED, 99999)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 99999)
    createEffect(getAllPlayers(), Effect.SPARKLES, Color.AQUA, eventPlayer, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    MenuEffect = getLastCreatedEntity()


rule "Left Menu":
    @Event eachPlayer
    @Condition eventPlayer == hostPlayer
    @Condition MenuState != true
    
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.allowButton(Button.JUMP)
    eventPlayer.allowButton(Button.ABILITY_1)
    if eventPlayer.getCurrentHero() != Hero.ZARYA:
        eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.allowButton(Button.CROUCH)
    eventPlayer.allowButton(Button.ULTIMATE)
    eventPlayer.allowButton(Button.MELEE)
    eventPlayer.clearStatusEffect(Status.ROOTED)
    eventPlayer.clearStatusEffect(Status.INVINCIBLE)
    destroyEffect(MenuEffect)


rule "Selection Up":
    @Event eachPlayer
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition CamState != true
    @Condition MenuState == true
    
    if MenuSelection != 0:
        MenuSelection -= 1
    else:
        MenuSelection = MenuItems


rule "Selection Down":
    @Event eachPlayer
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition CamState != true
    @Condition MenuState == true
    
    if MenuSelection < MenuItems:
        MenuSelection += 1
    else:
        MenuSelection = 0


rule "Execute Restart":
    @Event eachPlayer
    @Condition eventPlayer == hostPlayer
    @Condition MenuState == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition MenuSelection == 0
    @Condition CamState != true
    
    restartMatch()

rule "Debug Mode On":
    @Event eachPlayer
    @Condition eventPlayer == hostPlayer
    @Condition MenuState == true
    @Condition MenuSelection == 1
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition CamState != true
    
    eventPlayer.disableHeroHUD()
    smallMessage(eventPlayer, "Debug Mode On")
    #initialize as eye position of player
    eventPlayer.EyePos = eventPlayer.getEyePosition()
    #reevaluate eyepos repeatedly
    chase(eventPlayer.EyePos, updateEveryTick(eventPlayer.EyePos + (1000 * (eventPlayer.getFacingDirection() * eventPlayer.getThrottle().z + eventPlayer.getThrottle().x * worldVector(Vector.LEFT, eventPlayer, Transform.ROTATION) + (Vector.UP if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) else Vector.DOWN if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) else vect(0, 0, 0))))), rate=15, ChaseReeval.DESTINATION_AND_RATE)
    #initialize the looking pos as a vector
    eventPlayer.LookingPos = Vector.UP
    #reevaluate lookingpos repeatedly
    chase(eventPlayer.LookingPos, updateEveryTick(eventPlayer.EyePos + eventPlayer.getFacingDirection()), rate=9999, ChaseReeval.DESTINATION_AND_RATE)
    eventPlayer.startCamera(updateEveryTick(eventPlayer.EyePos), updateEveryTick(eventPlayer.LookingPos), 0)
    eventPlayer.clearStatusEffect(Status.ROOTED)
    eventPlayer.setMoveSpeed(0)
    CamState = true


rule "Debug Mode Off":
    @Event eachPlayer
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition CamState == true
    
    eventPlayer.stopCamera()
    smallMessage(eventPlayer, "Debug Mode Off")
    eventPlayer.setStatusEffect(null, Status.ROOTED, 99999)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.enableHeroHud()
    CamState = false
