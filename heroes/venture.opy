#!mainFile "../main.opy"

rule "Venture: Max Shields reached":
    @Event eachPlayer
    @Hero venture
    @Condition eventPlayer.getHealthOfType(Health.SHIELDS) == 75
    @Condition eventPlayer.isUsingUltimate() == true or eventPlayer.isUsingAbility1() == true or eventPlayer.isUsingAbility2() == true

    eventPlayer.AbilityReachedCap = true

rule "Venture: Extra Shields":
    @Event eachPlayer
    @Hero venture
    @Condition eventPlayer.getHealth() >= 325
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true and eventPlayer.getAbilityCooldown(Button.ULTIMATE) == 0 or eventPlayer.isHoldingButton(Button.ABILITY_1) == true and eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0 or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true and eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) == 0

    if eventPlayer.AbilityReachedCap == true:
        eventPlayer.AbilityReachedCap = false
        return

    eventPlayer.addHealthPool(Health.NORMAL, 40, false, false)

    if eventPlayer.HealthPools == null:
        eventPlayer.HealthPools = []
    eventPlayer.HealthPools.append(getLastCreatedHealthPool())
    
rule "Venture: Remove Extra Shields":
    @Event eachPlayer
    @Hero venture
    @Condition eventPlayer.getHealthOfType(Health.SHIELDS) == 0

    eventPlayer.removeAllHealthPools()
    eventPlayer.HealthPools = []

rule "Venture HUD":
    @Event eachPlayer
    @Hero venture
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.LastHUDHero != Hero.VENTURE
    
    hudText(eventPlayer, null, null, "Venture's Passive now has a cap of 675", HudPosition.RIGHT, 3, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.PlayerHUD = getLastCreatedText()
    eventPlayer.LastHUDHero = Hero.VENTURE


rule "Destroy Venture HUD":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getCurrentHero() != Hero.VENTURE
    @Condition eventPlayer.LastHUDHero == Hero.VENTURE
    
    destroyHudText(eventPlayer.PlayerHUD)
    eventPlayer.HealthPools = []
    eventPlayer.PlayerHUD = null
    eventPlayer.LastHUDHero = eventPlayer.getCurrentHero()
