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
