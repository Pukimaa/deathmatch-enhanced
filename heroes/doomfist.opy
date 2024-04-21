#!mainFile "../main.opy"

rule "Melee charges 10% (Doomfist)":
    @Event playerDealtFinalBlow
    @Hero doomfist
    @Condition eventPlayer.isMeleeing() == true
    
    eventPlayer.setUltCharge(eventPlayer.getUltCharge() + 10)


rule "Doomfist HUD":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.LastHUDHero != Hero.DOOMFIST
    
    hudText(eventPlayer, null, "Melee ({0})".format(buttonString(Button.MELEE)), "A final blow with your melee gives you 10% extra Ult Charge", HudPosition.RIGHT, 4, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.PlayerHUD = getLastCreatedText()
    eventPlayer.LastHUDHero = Hero.DOOMFIST


rule "Destroy Doomfist HUD":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getCurrentHero() != Hero.DOOMFIST
    @Condition eventPlayer.LastHUDHero == Hero.DOOMFIST
    
    destroyHudText(eventPlayer.PlayerHUD)
    eventPlayer.PlayerHUD = null
    eventPlayer.LastHUDHero = eventPlayer.getCurrentHero()
