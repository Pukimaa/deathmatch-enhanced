#!mainFile "../main.opy"

rule "High Noon Instakills":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setStatusEffect(null, Status.STUNNED, 0.001)
    kill(getClosestPlayer(eventPlayer, Team.ALL), eventPlayer)


rule "Cassidy HUD":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.LastHUDHero != Hero.MCCREE
    
    hudText(eventPlayer, null, "Ultimate ({0})".format(buttonString(Button.ULTIMATE)), "Kills the nearest player", HudPosition.RIGHT, 3, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.PlayerHUD = getLastCreatedText()
    eventPlayer.LastHUDHero = Hero.MCCREE


rule "Destroy Cassidy HUD":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getCurrentHero() != Hero.MCCREE
    @Condition eventPlayer.LastHUDHero == Hero.MCCREE
    
    destroyHudText(eventPlayer.PlayerHUD)
    eventPlayer.PlayerHUD = null
    eventPlayer.LastHUDHero = eventPlayer.getCurrentHero()
