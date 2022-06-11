#!mainFile "../main.opy"

rule "Mei Freezed Headshot":
    @Event playerDealtDamage
    @Hero mei
    @Condition victim.hasStatusEffect(Status.FROZEN) == true
    @Condition eventWasCriticalHit == true
    
    kill(victim, eventPlayer)
