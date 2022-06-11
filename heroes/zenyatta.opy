#!mainFile "../main.opy"

rule "Zen Kick":
    @Event playerDealtDamage
    @Hero zenyatta
    @Condition eventPlayer.isMeleeing() == true
    
    getClosestPlayer(eventPlayer, Team.ALL).applyImpulse(vectorTowards(eventPlayer, eventPlayer.getPlayerClosestToReticle(Team.ALL)), 15, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    damage(getClosestPlayer(eventPlayer, Team.ALL), null, eventDamage * 0.5)
    eventPlayer.setUltCharge(eventPlayer.getUltCharge() + 1)


rule "Zen Ult":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 7)


rule "Zen HUD":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.LastHUDHero != Hero.ZENYATTA
    
    hudText(eventPlayer, null, "Melee ({0})".format(buttonString(Button.MELEE)), "Knocks back enemies and deals more damage", HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.PlayerHUD = getLastCreatedText()
    eventPlayer.LastHUDHero = Hero.ZENYATTA


rule "Destroy Zen HUD":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getCurrentHero() != Hero.ZENYATTA
    @Condition eventPlayer.LastHUDHero == Hero.ZENYATTA
    
    destroyHudText(eventPlayer.PlayerHUD)
    eventPlayer.PlayerHUD = null
    eventPlayer.LastHUDHero = eventPlayer.getCurrentHero()