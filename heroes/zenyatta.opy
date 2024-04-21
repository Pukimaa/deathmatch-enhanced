#!mainFile "../main.opy"

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
    
    hudText(eventPlayer, null, "Ultimate ({0})".format(buttonString(Button.ULTIMATE)), "Makes you phased out, similiar to Reaper's Wraith Form", HudPosition.RIGHT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
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