#!mainFile "../main.opy"

rule "Mei Freezed Headshot":
    @Event playerDealtDamage
    @Hero mei
    @Condition victim.hasStatusEffect(Status.FROZEN) == true
    @Condition eventWasCriticalHit == true
    
    kill(victim, eventPlayer)

rule "Mei HUD":
    @Event eachPlayer
    @Hero mei
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.LastHUDHero != Hero.MEI
    
    hudText(eventPlayer, null, "Secondary Fire ({0})".format(buttonString(Button.SECONDARY_FIRE)), "If a player is frozen, a headshot instantly kills them", HudPosition.RIGHT, 3, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.PlayerHUD = getLastCreatedText()
    eventPlayer.LastHUDHero = Hero.MEI


rule "Destroy Mei HUD":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getCurrentHero() != Hero.MEI
    @Condition eventPlayer.LastHUDHero == Hero.MEI
    
    destroyHudText(eventPlayer.PlayerHUD)
    eventPlayer.PlayerHUD = null
    eventPlayer.LastHUDHero = eventPlayer.getCurrentHero()
