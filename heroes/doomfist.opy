#!mainFile "../main.opy"

rule "Doomfist Empower Primary Fire":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    damage(victim, eventPlayer, eventDamage * 0.5)


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
    
    eventPlayer.PlayerHUD = []
    hudText(eventPlayer, null, "Primary Fire ({0})".format(buttonString(Button.PRIMARY_FIRE)), "Deals 50% more damage", HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.PlayerHUD.append(getLastCreatedText())
    hudText(eventPlayer, null, "Melee ({0})".format(buttonString(Button.MELEE)), "A final blow with your melee gives you 10% extra Ult Charge", HudPosition.LEFT, 2, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.PlayerHUD.append(getLastCreatedText())
    eventPlayer.LastHUDHero = Hero.DOOMFIST


rule "Destroy Doomfist HUD":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getCurrentHero() != Hero.DOOMFIST
    @Condition eventPlayer.LastHUDHero == Hero.DOOMFIST
    
    for eventPlayer.LoopVar in range(len(eventPlayer.PlayerHUD)):
        destroyHudText(eventPlayer.PlayerHUD[eventPlayer.LoopVar])
    eventPlayer.PlayerHUD = null
    eventPlayer.LastHUDHero = eventPlayer.getCurrentHero()
