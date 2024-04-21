#!mainFile "main.opy"
settings {
    "main": {
        "description": "v1 | No Hero Changes | Code: DG4CW",
        "modeName": "Deathmatch Enhanced"
    },
    "lobby": {
        "allowPlayersInQueue": true,
        "enableMatchVoiceChat": true,
        "spectatorSlots": 12
    },
    "gamemodes": {
        "assault": {
            "enabled": false,
            "roleLimit": "2OfEachRolePerTeam"
        },
        "control": {
            "enabled": false,
            "roleLimit": "2OfEachRolePerTeam"
        },
        "ffa": {
            "gameLengthInMn": 15,
            "scoreToWin": 50,
            "enabledMaps": [
                "blizzWorld",
                "chateauGuillard",
                "dorado",
                "eichenwalde",
                "havana",
                "hollywood",
                "kanezaka",
                "kingsRow",
                "malevento",
                "paris",
                "petra",
                "route66"
            ]
        },
        "escort": {
            "enabled": false,
            "roleLimit": "2OfEachRolePerTeam"
        },
        "hybrid": {
            "enabled": false,
            "roleLimit": "2OfEachRolePerTeam"
        },
        "general": {
            "gamemodeStartTrigger": "immediately",
        }
    },
}

# Globar variables

globalvar AntiCrashState 0
globalvar MenuState 1
globalvar MenuSelection 2
globalvar MenuItems 3
globalvar CamState 4
globalvar MenuEffect 5

#Player variables

playervar LastHero 0
playervar PlayerHUD 1
playervar LoopVar 2
playervar LastHUDHero 3
playervar ZaryaBubbles 4
playervar EyePos 5
playervar LookingPos 6
playervar StatsState 7
playervar HealthPools 8
playervar AbilityReachedCap 9

rule "Player joined":
    @Event playerJoined
    @Condition eventPlayer.isDummy() == false

    bigMessage(getAllPlayers(), "{0} joined the match!".format(eventPlayer))

rule "HUD":
    hudText(getAllPlayers(), null, "Hold for 1s to switch heroes", "Interact ({0})".format(buttonString(Button.INTERACT)), HudPosition.LEFT, 1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudText(getAllPlayers(), null, "Press to toggle Server Stats", "Crouch ({0}) + Melee ({1})".format(buttonString(Button.CROUCH), buttonString(Button.MELEE)), HudPosition.LEFT, 2, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudText(hostPlayer, null, "Press to toggle Host-only Menu", "Crouch ({0}) + Interact ({1})".format(buttonString(Button.CROUCH), buttonString(Button.INTERACT)), HudPosition.LEFT, 3, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

rule "Player selected hero":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer.LastHero != eventPlayer.getCurrentHero()
    @Condition isMatchComplete() == false
    
    bigMessage(getAllPlayers(), "{0} {1} is now {2}!".format(heroIcon(eventPlayer.getCurrentHero()), eventPlayer, eventPlayer.getCurrentHero()))
    eventPlayer.LastHero = eventPlayer.getCurrentHero()


rule "Restart after POTG":
    @Condition isMatchComplete() == true
    
    wait(25)
    restartMatch()


rule "Heal Player":
    @Event playerDealtFinalBlow
    
    heal(eventPlayer, null, 2000)


rule "Hero Select = 0s":
    @Condition isAssemblingHeroes() == true
    
    setMatchTime(0)

rule "Interact to switch Heroes":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition true == (eventPlayer.getHealth() / eventPlayer.getMaxHealth() > 0.25) or eventPlayer.isDead() == true
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setAllowedHeroes(eventPlayer.getAllowedHeroes().exclude(eventPlayer.getCurrentHero()))
    wait(0.25)
    eventPlayer.resetHeroAvailability()
    MenuState = false
    CamState = false


rule "Too low text":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isAlive() == true
    @Condition true == (eventPlayer.getHealth() / eventPlayer.getMaxHealth() <= 0.25)
    
    smallMessage(eventPlayer, "Health is too low to change hero (25% minimum)")


rule "Instantly respawn":
    @Event playerDied
    
    wait(1)
    eventPlayer.respawn()


rule "Spawn Dummy Bot":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    createDummy(Hero.SOLDIER, Team.ALL, -1, eventPlayer, eventPlayer)


rule "Respawn Dummy":
    @Event playerDied
    @Condition eventPlayer.isDummy() == true
    
    destroyDummy(Team.ALL, eventPlayer.getSlot())
    createDummy(Hero.SOLDIER, Team.ALL, -1, eventPlayer, eventPlayer)


rule "Destroy Dummy":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    @Condition any([player.isDummy() for player in getAllPlayers()]) == true
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    destroyAllDummies()

rule "Anti Crash":
    @Condition AntiCrashState != true
    @Condition getServerLoad() > 230

    wait(1, Wait.ABORT_WHEN_FALSE)
    smallMessage(getAllPlayers(), "Activated anti-crash system! (This will be disabled once the serverload lowers)")
    setSlowMotion(10)
    AntiCrashState = true

rule "Disable Anti Crash":
    @Condition AntiCrashState == true
    @Condition getServerLoad() < 200

    setSlowMotion(100)
    AntiCrashState = false

# Include Heroes (DG4CW doesn't use this)
# Include Others
#!include "host.opy"
