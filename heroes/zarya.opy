#!mainFile "../main.opy"

rule "Initial Zarya Pick":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.hasSpawned() == true
    
    eventPlayer.ZaryaBubbles = 2
    eventPlayer.setAbility2Enabled(false)


rule "Remove Bubble CD if Dies":
    @Event playerDied
    @Hero zarya
    
    eventPlayer.ZaryaBubbles = 2


rule "Bubbles CD":
    @Event eachPlayer
    @Hero zarya
    
    chase(eventPlayer.ZaryaBubbles, 2, rate=0.1, ChaseReeval.DESTINATION_AND_RATE)


rule "Remove Bubbles":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.ZaryaBubbles -= 1


rule "Remove Zarya CD":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.ZaryaBubbles >= 1
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 0
    @Condition eventPlayer.isUsingAbility1() == false
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)


rule "Zarya CD = Real CD":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.ZaryaBubbles < 1
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 0
    @Condition eventPlayer.isUsingAbility1() == false
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, (1 - eventPlayer.ZaryaBubbles) * 10)


rule "Zarya Hud":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.LastHUDHero != Hero.ZARYA

    eventPlayer.PlayerHUD = []
    hudText(eventPlayer, null, "Ability 1 ({0})".format(buttonString(Button.ABILITY_1)), "You have 2 self-bubbles", HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.PlayerHUD.append(getLastCreatedText())
    eventPlayer.LastHUDHero = eventPlayer.getCurrentHero()


rule "Bubble HUD":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.LastHUDHero != Hero.ZARYA
    
    createInWorldText(eventPlayer, "{0}TEST".format(eventPlayer.ZaryaBubbles), updateEveryTick(eventPlayer.getEyePosition() + (vect(0, 0, 0) * (vect(0, 0, 0) * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION) + ((-101 - 0.2) * (angleToDirection(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90))) + 3 * eventPlayer.getFacingDirection()))), 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.WHITE, SpecVisibility.DEFAULT)
    eventPlayer.PlayerHUD.append(getLastCreatedText())
    eventPlayer.LastHUDHero = eventPlayer.getCurrentHero()

rule "Destroy HUD":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getCurrentHero() != Hero.ZARYA
    @Condition eventPlayer.LastHUDHero == Hero.ZARYA

    for eventPlayer.LoopVar in range(len(eventPlayer.PlayerHUD)):
        destroyHudText(eventPlayer.PlayerHUD[eventPlayer.LoopVar])
    eventPlayer.PlayerHUD = null
    eventPlayer.LastHUDHero = eventPlayer.getCurrentHero()
