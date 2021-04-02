settings {
    "main": {
        "description": "SINGLEPLAYER ONLY. by pluzorminuz. Last Update: 2021 Mar 22"
    },
    "lobby": {
        "team1Slots": 1,
        "team2Slots": 1
    },
    "gamemodes": {
        "skirmish": {},
        "general": {
            "heroLimit": "off",
            "enableKillFeed": false,
            "roleLimit": "2OfEachRolePerTeam",
            "respawnTime%": 50
        }
    },
    "heroes": {
        "allTeams": {
            "torbjorn": {
                "enableInfiniteUlt": true
            },
            "general": {
                "abilityCooldown%": 0
            }
        }
    }
}

#Global variables

globalvar data 0
globalvar loop_i 1
globalvar map_deathplane_y 2
globalvar _FX 100


#Player variables

playervar hero_index 0
playervar hero_proj_data 1
playervar hero_ability_icon 2
playervar proj_g 3
playervar proj_vel 4
playervar proj_del 5
playervar proj_simtime 6
playervar proj_r 7
playervar proj_castdelay 8
playervar proj_chasedelay 9
playervar proj_fx 10
playervar proj_warning 11
playervar proj_p0 12
playervar proj_p1 13
playervar proj_p2 14
playervar proj_apex_t 15
playervar trajectory_hidden 16
playervar proj_dir 17
playervar using_ability 18
playervar player_hero 19
playervar ray_cast_t 20
playervar ray_cast_start 21
playervar ray_cast_end 22
playervar ray_cast_hit_pos 23
playervar proj_predict_land_pos 24
playervar proj_predict_land_t 25
playervar pos_mem 26
playervar poslock_bool 27
playervar poslock_posfac 28
playervar proj_p0_hidden 29
playervar proj_dir_hidden 30
playervar chasecam_bool 31
playervar chasecam_t 32
playervar chasecam_chasing 33
playervar predictcam_bool 34
playervar predictcam_dist 35
playervar eye_height 36
playervar trajlock_bool 37
playervar proj_override 38
playervar trajectory_hidden_manual 39
playervar hudhide_bool 40
playervar chasecam_interrupt 41
playervar proj_dir_raw_hidden 42
playervar freecam_freeeye 100
playervar freecam_accel 101
playervar freecam_bool 102
playervar freecam_vel 104
playervar freecam_prevdir 105


#Subroutine names

subroutine load_proj_data 0
subroutine calc_proj 1
subroutine swap_proj_data 2
subroutine init_map_deathplane_y 3
subroutine create_trajectory 4
subroutine check_ability1 5
subroutine hud_final 6
subroutine save_trajectory_origin 7
subroutine chasecam_start 8
subroutine lockpos_only 9
subroutine lockdir_only 10
subroutine unlockpos_only 11
subroutine unlockdir_only 12


#Activated extensions

#!extension beamEffects
#!extension playMoreEffects


rule "init":
    disableInspector()
    #sphere,shaft 1.053046257,ringout 1.052807897,ringin 1.062128122
    _FX = [10155.377 / 10000, 10530.462 / 10000, 10528.079 / 10000, 10621.281 / 10000]
    data = [[Hero.ANA, Hero.JUNKRAT, Hero.BAPTISTE, Hero.ORISA, Hero.ZARYA, Hero.SOMBRA, Hero.ASHE, Hero.TRACER, Hero.MCCREE, Hero.MEI, Hero.TORBJORN, Hero.HANZO, Hero.SIGMA, Hero.WIDOWMAKER], [[[null, null, null, null, [-9.84, 30, 0, 7, 0, 0, 0.35, false]], 4, [4, 0, 0], false], [[[-12.35, 25, 0.075, 7, 0, 0, 0.1, false], null, null, [-20.3, 25, 0.09, 7, 0, 0.136, 0.25, false], [-20.2, 10, 0.095, 7, 0, 0, 0.25, false]], 0, [2, 3, 0], true], [[null, [-20.1, 60, 0.007, 7, 0, 0, 0.1, false], null, null, [-20.1, 60, 0.007, 7, 0, 0, 0.1, false]], 1, [3, 0, 6.5], true], [[null, null, null, null, [-9.84, 25, 0, 7, 0, 0.128, 0.4, false]], 4, [0, 0, 0], true], [[null, [-9.84, 25, 0.1, 7, 0, 0, 0.5, false], [-9.84, 25, 0.1, 7, 0, 0, 0.5, false], null, null], 1, [2.5, 6, 0], false], [[null, null, null, null, [-20.2, 25, 0.09, 5, 0, 0.096, 0.2, false]], 4, [15, 0, 0], true], [[null, null, null, null, [-8.03, 25, 0.07, 7, 0, 0.14, 0.4, false]], 4, [5, 0, 0], true], [[null, null, [-30.8, 15, 0.19, 2, 0, 0.144, 0.15, false], null, null], 2, [5, 0, 0], true], [[null, null, null, null, [-9.84, 30, 0, 7 / 30, 0, 0, 0.1, false]], 4, [3, 0, 0], false], [[null, null, [-9.9, 20, 0.09, 7, 0, 0.484, 0.6, false], null, null], 2, [10, 0, 0], true], [[[-9.81, 70, 0.015, 15, 0, 0, 0.1, true], null, [-30.05, 40, 0, 5, 0, 0, 0.1, true], [-20, 17, 0, 4, 0, 0.048, 0.1, true], null], 0, [2.5, 40, 0], true], [[[-9.815, 110, 0, 15, 0, 0, 0.032, true], null, null, null, [-9.815, 110, 0, 15, 0, 0, 0.032, true]], 0, [0, 9, 0], false], [[[-5.954, 49.7, 0, 3 / 7, 0, 0, 0.048, false], null, null, null, [-18.35, 37.4, 0.1, 6, 0, 0.64, 0.256, false]], 4, [2.5, 3, 0], true], [[null, null, null, null, [-9.84, 20, 0, 7, 0, 0.192, 0.16, false]], 4, [3, 0, 0], true]]]
    init_map_deathplane_y()
    hud_final()
    create_trajectory()


rule "init_player":
    @Event eachPlayer
    @Hero all
    
    eventPlayer.setAllowedHeroes(data[0])
    eventPlayer.trajectory_hidden = false
    eventPlayer.disableGamemodeHud()


rule "player_calc_proj_loop":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.chasecam_chasing != true
    @Condition eventPlayer.trajlock_bool != true
    @Condition eventPlayer.freecam_bool != true
    
    save_trajectory_origin()
    calc_proj()
    wait(0.064, Wait.ABORT_WHEN_FALSE)
    if RULE_CONDITION:
        goto RULE_START


rule "player_changed_hero":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.getCurrentHero() != eventPlayer.player_hero
    
    eventPlayer.player_hero = eventPlayer.getCurrentHero()
    eventPlayer.eye_height = eventPlayer.getEyePosition() - eventPlayer.getPosition()
    load_proj_data()
    eventPlayer.hero_ability_icon = "{0}{1}{2}".format(abilityIconString(eventPlayer.getCurrentHero(), Button.PRIMARY_FIRE) if eventPlayer.hero_proj_data[0] != null else "", abilityIconString(eventPlayer.getCurrentHero(), Button.SECONDARY_FIRE) if eventPlayer.hero_proj_data[1] != null else "", "{0}{1}{2}".format(abilityIconString(eventPlayer.getCurrentHero(), Button.ULTIMATE) if eventPlayer.hero_proj_data[2] != null else "", abilityIconString(eventPlayer.getCurrentHero(), Button.ABILITY_1) if eventPlayer.hero_proj_data[3] != null else "", abilityIconString(eventPlayer.getCurrentHero(), Button.ABILITY_2) if eventPlayer.hero_proj_data[4] != null else ""))
    eventPlayer.setUltCharge(100)
    if eventPlayer.pos_mem != 0:
        eventPlayer.teleport(eventPlayer.pos_mem[0])
        eventPlayer.setFacing(eventPlayer.pos_mem[1], Relativity.TO_WORLD)
    eventPlayer.predictcam_dist = 0.8
    eventPlayer.predictcam_bool = false
    eventPlayer.trajectory_hidden = false
    if eventPlayer.chasecam_chasing == true:
        async(chasecam_start, AsyncBehavior.RESTART)


rule "player_action_change_hero (acknowledge)":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.isCommunicating(Comms.ACKNOWLEDGE) == true
    
    eventPlayer.pos_mem = [eventPlayer.getPosition(), eventPlayer.getFacingDirection()]
    eventPlayer.setAllowedHeroes([i for i in getAllHeroes() if i != eventPlayer.getCurrentHero()])
    eventPlayer.setAllowedHeroes(data[0])


rule "player_action_refill_ult":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    
    eventPlayer.setUltCharge(100)


rule "player_action_zoomout (jump)":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.poslock_bool == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    
    eventPlayer.predictcam_dist = max(eventPlayer.predictcam_dist + -0.003, 0)
    wait()
    if RULE_CONDITION:
        goto RULE_START


rule "player_action_zoomin (duck)":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.poslock_bool == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    
    eventPlayer.predictcam_dist = min(eventPlayer.predictcam_dist + 0.003, 1)
    wait()
    if RULE_CONDITION:
        goto RULE_START


rule "player_action_predictcam (melee)":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    @Condition eventPlayer.freecam_bool != true
    
    if eventPlayer.chasecam_chasing == false:
        eventPlayer.predictcam_bool = not eventPlayer.predictcam_bool
    else:
        eventPlayer.chasecam_interrupt = true
        async(chasecam_start, AsyncBehavior.RESTART)


rule "predictcam_toggle_on":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.predictcam_bool == true
    
    #?? cam
    #eventPlayer.startCamera(((min(1, 1 - eventPlayer.proj_predict_land_t + eventPlayer.predictcam_dist)) ** 2) * eventPlayer.proj_p0 + (((2 * (min(1, 1 - eventPlayer.proj_predict_land_t + eventPlayer.predictcam_dist))) * (max(0, eventPlayer.proj_predict_land_t - eventPlayer.predictcam_dist))) * eventPlayer.proj_p1) + (((max(0, eventPlayer.proj_predict_land_t - eventPlayer.predictcam_dist)) ** 2) * eventPlayer.proj_p2), eventPlayer.proj_predict_land_pos, 10)
    #final cam
    eventPlayer.startCamera(((1 - eventPlayer.proj_predict_land_t * eventPlayer.predictcam_dist) ** 2) * eventPlayer.proj_p0 + ((((2 * (1 - eventPlayer.proj_predict_land_t * eventPlayer.predictcam_dist)) * eventPlayer.proj_predict_land_t) * eventPlayer.predictcam_dist) * eventPlayer.proj_p1) + (eventPlayer.proj_predict_land_t * eventPlayer.predictcam_dist) ** 2 * eventPlayer.proj_p2, eventPlayer.proj_predict_land_pos, 10)
    #apex cam
    #eventPlayer.startCamera(((1 - eventPlayer.proj_apex_t) ** 2) * eventPlayer.proj_p0 + (((2 * (1 - eventPlayer.proj_apex_t)) * eventPlayer.proj_apex_t) * eventPlayer.proj_p1) + eventPlayer.proj_apex_t ** 2 * eventPlayer.proj_p2 + vect(0.8, 0, 0), ((1 - eventPlayer.proj_apex_t) ** 2) * eventPlayer.proj_p0 + (((2 * (1 - eventPlayer.proj_apex_t)) * eventPlayer.proj_apex_t) * eventPlayer.proj_p1) + eventPlayer.proj_apex_t ** 2 * eventPlayer.proj_p2, 0)
    #setSlowMotion(10)


rule "predictcam_toggle_off":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.predictcam_bool == false
    
    eventPlayer.stopCamera()
    #setSlowMotion(100)


rule "player_action_chasecam (ult status)":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.isCommunicating(Comms.ULTIMATE_STATUS) == true
    
    eventPlayer.chasecam_bool = not eventPlayer.chasecam_bool


rule "player_action_trajlock (interact)":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    
    eventPlayer.trajlock_bool = not eventPlayer.trajlock_bool


rule "player_action_trajhide (group up)":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.isCommunicating(Comms.GROUP_UP) == true
    
    eventPlayer.trajectory_hidden_manual = not eventPlayer.trajectory_hidden_manual


rule "player_action_lockpos (reload)":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    
    eventPlayer.poslock_bool = not eventPlayer.poslock_bool


rule "lockpos_only_toggle_on":
    @Event eachPlayer
    @Hero all
    @Condition (not eventPlayer.poslock_bool and eventPlayer.freecam_bool or eventPlayer.poslock_bool and not eventPlayer.freecam_bool) == true
    
    lockpos_only()


rule "lockpos_only_toggle_off":
    @Event eachPlayer
    @Hero all
    @Condition (not (not eventPlayer.poslock_bool and eventPlayer.freecam_bool or eventPlayer.poslock_bool and not eventPlayer.freecam_bool)) == true
    
    unlockpos_only()


rule "lockdir_only_toggle_on":
    @Event eachPlayer
    @Hero all
    @Condition (eventPlayer.poslock_bool and not eventPlayer.freecam_bool) == true
    
    lockdir_only()


rule "lockdir_only_toggle_off":
    @Event eachPlayer
    @Hero all
    @Condition (not (eventPlayer.poslock_bool and not eventPlayer.freecam_bool)) == true
    
    unlockdir_only()


def lockpos_only():
    @Name "[sub] lockpos_only"
    
    eventPlayer.disableEnvironmentCollision(true)
    eventPlayer.poslock_posfac[0] = eventPlayer.getEyePosition() - eventPlayer.eye_height
    eventPlayer.startForcingPosition(eventPlayer.poslock_posfac[0], false)


def unlockpos_only():
    @Name "[sub] unlockpos_only"
    
    eventPlayer.enableEnvironmentCollision()
    eventPlayer.stopForcingPosition()


def lockdir_only():
    @Name "[sub] lockdir_only"
    
    eventPlayer.poslock_posfac[1] = eventPlayer.getFacingDirection()
    eventPlayer.startFacing(eventPlayer.poslock_posfac[1], 10000, Relativity.TO_WORLD, FacingReeval.NONE)


def unlockdir_only():
    @Name "[sub] unlockdir_only"
    
    if eventPlayer.freecam_bool:
        eventPlayer.stopFacing()
        eventPlayer.setFacing(eventPlayer.poslock_posfac[1], Relativity.TO_WORLD)
    else:
        eventPlayer.stopFacing()


rule "check_using_primary":
    @Event eachPlayer
    @Hero all
    #@Condition eventPlayer.isFiringPrimaryFire() == true
    @Condition eventPlayer.proj_override == false
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    
    #immediately snap the starting pos and fac
    save_trajectory_origin()
    eventPlayer.using_ability = 0
    if eventPlayer.hero_proj_data[eventPlayer.using_ability] != null:
        swap_proj_data()
        if (eventPlayer.chasecam_bool or eventPlayer.trajlock_bool) and not eventPlayer.chasecam_chasing:
            async(chasecam_start, AsyncBehavior.RESTART)


rule "check_using_secondary":
    @Event eachPlayer
    @Hero all
    #@Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.proj_override == false
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    
    #immediately snap the starting pos and fac
    save_trajectory_origin()
    eventPlayer.using_ability = 1
    if eventPlayer.hero_proj_data[eventPlayer.using_ability] != null:
        swap_proj_data()
        if (eventPlayer.chasecam_bool or eventPlayer.trajlock_bool) and not eventPlayer.chasecam_chasing:
            async(chasecam_start, AsyncBehavior.RESTART)


rule "check_using_ultimate":
    @Event eachPlayer
    @Hero all
    #@Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.proj_override == false
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    
    #immediately snap the starting pos and fac
    save_trajectory_origin()
    eventPlayer.using_ability = 2
    if eventPlayer.hero_proj_data[eventPlayer.using_ability] != null:
        swap_proj_data()
        if (eventPlayer.chasecam_bool or eventPlayer.trajlock_bool) and not eventPlayer.chasecam_chasing:
            async(chasecam_start, AsyncBehavior.RESTART)


rule "check_using_ability_1":
    @Event eachPlayer
    @Hero all
    #@Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.proj_override == false
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    
    #immediately snap the starting pos and fac
    save_trajectory_origin()
    eventPlayer.using_ability = 3
    if eventPlayer.hero_proj_data[eventPlayer.using_ability] != null:
        swap_proj_data()
        if (eventPlayer.chasecam_bool or eventPlayer.trajlock_bool) and not eventPlayer.chasecam_chasing:
            async(chasecam_start, AsyncBehavior.RESTART)


rule "check_using_ability_2":
    @Event eachPlayer
    @Hero all
    #@Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.proj_override == false
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    
    #immediately snap the starting pos and fac
    save_trajectory_origin()
    eventPlayer.using_ability = 4
    if eventPlayer.hero_proj_data[eventPlayer.using_ability] != null:
        swap_proj_data()
        if (eventPlayer.chasecam_bool or eventPlayer.trajlock_bool) and not eventPlayer.chasecam_chasing:
            async(chasecam_start, AsyncBehavior.RESTART)


rule "Hanzo: Primary Fire Charge":
    @Event eachPlayer
    @Hero hanzo
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition eventPlayer.isUsingAbility2() != true
    
    eventPlayer.proj_vel = 25
    chase(eventPlayer.proj_vel, 110, rate=120, ChaseReeval.NONE)
    waitUntil(eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == false, 99999)
    #immediately snap the starting pos and fac
    save_trajectory_origin()
    stopChasingVariable(eventPlayer.proj_vel)
    if (eventPlayer.chasecam_bool or eventPlayer.trajlock_bool) and not eventPlayer.chasecam_chasing:
        async(chasecam_start, AsyncBehavior.RESTART)


rule "Hanzo: Using Storm Arrow":
    @Event eachPlayer
    @Hero hanzo
    @Condition eventPlayer.isUsingAbility2() == true
    
    if eventPlayer.chasecam_chasing != true:
        eventPlayer.proj_vel = 110


rule "Hanzo: Fire Storm Arrow":
    @Event eachPlayer
    @Hero hanzo
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition eventPlayer.chasecam_bool == true
    @Condition eventPlayer.chasecam_chasing == false
    
    #immediately snap the starting pos and fac
    save_trajectory_origin()
    if (eventPlayer.chasecam_bool or eventPlayer.trajlock_bool) and not eventPlayer.chasecam_chasing:
        async(chasecam_start, AsyncBehavior.RESTART)


rule "Torbjorn: Using Ultimate":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.isUsingUltimate() == true
    
    if eventPlayer.chasecam_chasing != true:
        eventPlayer.using_ability = 2
        swap_proj_data()


rule "Torbjorn: Rivet":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition eventPlayer.isUsingUltimate() != true
    
    #immediately snap the starting pos and fac
    save_trajectory_origin()
    if eventPlayer.chasecam_chasing != true:
        eventPlayer.using_ability = 0
        swap_proj_data()
    if (eventPlayer.chasecam_bool or eventPlayer.trajlock_bool) and not eventPlayer.chasecam_chasing:
        async(chasecam_start, AsyncBehavior.RESTART)


rule "Torbjorn: Firing Goo":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    
    #immediately snap the starting pos and fac
    save_trajectory_origin()
    if (eventPlayer.chasecam_bool or eventPlayer.trajlock_bool) and not eventPlayer.chasecam_chasing:
        async(chasecam_start, AsyncBehavior.RESTART)


rule "Torbjorn: Deploy Turret":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.isUsingUltimate() != true
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    
    #immediately snap the starting pos and fac
    save_trajectory_origin()
    if eventPlayer.chasecam_chasing != true:
        eventPlayer.using_ability = 3
        swap_proj_data()
    if (eventPlayer.chasecam_bool or eventPlayer.trajlock_bool) and not eventPlayer.chasecam_chasing:
        async(chasecam_start, AsyncBehavior.RESTART)


def chasecam_start():
    @Name "[sub] chasecam_start"
    
    if not (eventPlayer.chasecam_chasing or eventPlayer.chasecam_interrupt):
        stopChasingVariable(eventPlayer.chasecam_t)
        eventPlayer.chasecam_t = 0
        #then wait for the cast time if any
        if eventPlayer.proj_castdelay > 0:
            wait(eventPlayer.proj_castdelay)
            save_trajectory_origin()
        #do calc
        async(calc_proj, AsyncBehavior.RESTART)
        #start chasing immediately after casting
        chase(eventPlayer.chasecam_t, eventPlayer.proj_predict_land_t, rate=1 / eventPlayer.proj_simtime, ChaseReeval.DESTINATION_AND_RATE)
        if eventPlayer.chasecam_bool and not eventPlayer.freecam_bool:
            eventPlayer.predictcam_bool = false
            eventPlayer.chasecam_chasing = true
            eventPlayer.trajectory_hidden = true
            eventPlayer.setInvisibility(Invis.ALL)
            #ensures projectile correction
            wait()
            #start camera
            eventPlayer.startCamera(((min(1 - eventPlayer.chasecam_t + eventPlayer.proj_chasedelay / eventPlayer.proj_simtime, 1)) ** 2) * eventPlayer.proj_p0 + (((2 * (min(1 - eventPlayer.chasecam_t + eventPlayer.proj_chasedelay / eventPlayer.proj_simtime, 1))) * (max(eventPlayer.chasecam_t - eventPlayer.proj_chasedelay / eventPlayer.proj_simtime, 0))) * eventPlayer.proj_p1) + (((max(eventPlayer.chasecam_t - eventPlayer.proj_chasedelay / eventPlayer.proj_simtime, 0)) ** 2) * eventPlayer.proj_p2) - (((eventPlayer.proj_dir == Vector.UP or eventPlayer.proj_dir == Vector.DOWN) * 0.008) * angleToDirection(horizontalAngleOfDirection(eventPlayer.proj_dir_raw_hidden), 0)), ((1 - eventPlayer.chasecam_t) ** 2) * eventPlayer.proj_p0 + (((2 * (1 - eventPlayer.chasecam_t)) * eventPlayer.chasecam_t) * eventPlayer.proj_p1) + eventPlayer.chasecam_t ** 2 * eventPlayer.proj_p2, 0)
        #wait for proj to hit
        wait(eventPlayer.proj_predict_land_t * eventPlayer.proj_simtime + eventPlayer.proj_chasedelay + 1.5 - 0.016, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.chasecam_chasing:
        eventPlayer.stopCamera()
    eventPlayer.setInvisibility(Invis.NONE)
    eventPlayer.trajectory_hidden = false
    eventPlayer.chasecam_interrupt = false
    stopChasingVariable(eventPlayer.chasecam_t)
    eventPlayer.chasecam_t = 0
    eventPlayer.chasecam_chasing = false


def swap_proj_data():
    @Name "[sub] swap_projectile_data"
    
    eventPlayer.proj_g = eventPlayer.hero_proj_data[eventPlayer.using_ability][0]
    eventPlayer.proj_vel = eventPlayer.hero_proj_data[eventPlayer.using_ability][1]
    eventPlayer.proj_del = eventPlayer.hero_proj_data[eventPlayer.using_ability][2]
    eventPlayer.proj_simtime = eventPlayer.hero_proj_data[eventPlayer.using_ability][3]
    eventPlayer.proj_r = eventPlayer.hero_proj_data[eventPlayer.using_ability][4]
    eventPlayer.proj_castdelay = eventPlayer.hero_proj_data[eventPlayer.using_ability][5]
    eventPlayer.proj_chasedelay = eventPlayer.hero_proj_data[eventPlayer.using_ability][6]
    eventPlayer.proj_override = eventPlayer.hero_proj_data[eventPlayer.using_ability][7]


def check_ability1():
    @Name "[sub] obsolete"
    
    if eventPlayer.hero_proj_data[2] != null:
        while true:
            waitUntil(not eventPlayer.isUsingAbility1(), 99999)
            waitUntil(eventPlayer.isUsingAbility1(), 99999)
            smallMessage(getAllPlayers(), "This ability is open for chase")


def init_map_deathplane_y():
    @Name "[sub] map_deathplane"
    
    if getCurrentMap() == Map.BLIZZ_WORLD:
        map_deathplane_y = -6.49
    elif getCurrentMap() == Map.BLIZZ_WORLD_WINTER:
        map_deathplane_y = -6.49
    elif getCurrentMap() == Map.DORADO:
        map_deathplane_y = -9.51
    elif getCurrentMap() == Map.EICHENWALDE:
        map_deathplane_y = -7.72
    elif getCurrentMap() == Map.EICHENWALDE_HALLOWEEN:
        map_deathplane_y = -7.71
    elif getCurrentMap() == Map.HANAMURA:
        map_deathplane_y = -8.51
    elif getCurrentMap() == Map.HANAMURA_WINTER:
        map_deathplane_y = -8.5
    elif getCurrentMap() == Map.HAVANA:
        map_deathplane_y = -8.5
    elif getCurrentMap() == Map.HOLLYWOOD:
        map_deathplane_y = -30.51
    elif getCurrentMap() == Map.HOLLYWOOD_HALLOWEEN:
        map_deathplane_y = -30.5
    elif getCurrentMap() == Map.HORIZON_LUNAR_COLONY:
        map_deathplane_y = 0.41
    elif getCurrentMap() == Map.JUNKERTOWN:
        map_deathplane_y = -5.5
    elif getCurrentMap() == Map.KINGS_ROW:
        map_deathplane_y = -18.5
    elif getCurrentMap() == Map.KINGS_ROW_WINTER:
        map_deathplane_y = -18.5
    elif getCurrentMap() == Map.NUMBANI:
        map_deathplane_y = -10.5
    elif getCurrentMap() == Map.PARIS:
        map_deathplane_y = 6.15
    elif getCurrentMap() == Map.RIALTO:
        map_deathplane_y = -15.5
    elif getCurrentMap() == Map.ROUTE66:
        map_deathplane_y = -15.5
    elif getCurrentMap() == Map.TEMPLE_OF_ANUBIS:
        map_deathplane_y = -10.5
    elif getCurrentMap() == Map.VOLSKAYA:
        map_deathplane_y = -12.5
    elif getCurrentMap() == Map.WATCHPOINT_GIBRALTAR:
        map_deathplane_y = -18.5
    elif getCurrentMap() == Map.BUSAN:
        map_deathplane_y = [0.41, 2.02, -8.5]
        map_deathplane_y = map_deathplane_y[getCurrentObjective()]
    elif getCurrentMap() == Map.ILIOS:
        map_deathplane_y = [-37.45, -10.19, 49.36]
        map_deathplane_y = map_deathplane_y[getCurrentObjective()]
    elif getCurrentMap() == Map.NEPAL:
        map_deathplane_y = [-106.18, -0.84, 115.15]
        map_deathplane_y = map_deathplane_y[getCurrentObjective()]
    elif getCurrentMap() == Map.OASIS:
        map_deathplane_y = [-8.99, -0.51, 2.08]
        map_deathplane_y = map_deathplane_y[getCurrentObjective()]
    elif getCurrentMap() == Map.LIJIANG_TOWER or getCurrentMap() == Map.LIJIANG_CONTROL_CENTER_LNY:
        map_deathplane_y = [-12.51, 82.57, 250.2]
        map_deathplane_y = map_deathplane_y[getCurrentObjective()]
    elif getCurrentMap() == Map.WORKSHOP_CHAMBER:
        map_deathplane_y = -25.5
    elif getCurrentMap() == Map.WORKSHOP_EXPANSE:
        map_deathplane_y = -27
    elif getCurrentMap() == Map.WORKSHOP_EXPANSE_NIGHT:
        map_deathplane_y = -27
    elif getCurrentMap() == Map.WORKSHOP_GREEN_SCREEN:
        map_deathplane_y = -27
    elif getCurrentMap() == Map.WORKSHOP_ISLAND:
        map_deathplane_y = -27
    elif getCurrentMap() == Map.WORKSHOP_ISLAND_NIGHT:
        map_deathplane_y = -27


def create_trajectory():
    @Name "[sub] create trajectory"
    
    for loop_i in range(0, 1, 0.02):
        #main trajectory
        createBeam(localPlayer if localPlayer.trajectory_hidden != true and localPlayer.trajectory_hidden_manual != true else null, Beam.TORBJORN_TURRET_SIGHT, (evalOnce((0.98 - loop_i) * (0.98 - loop_i))) * localPlayer.proj_p0 + ((evalOnce((2 * (loop_i + 0.02)) * (0.98 - loop_i))) * localPlayer.proj_p1) + ((evalOnce((loop_i + 0.02) * (loop_i + 0.02))) * localPlayer.proj_p2), (evalOnce((1 - loop_i) * (1 - loop_i))) * localPlayer.proj_p0 + ((evalOnce(2 * loop_i * (1 - loop_i))) * localPlayer.proj_p1) + evalOnce(loop_i * loop_i) * localPlayer.proj_p2, Color.TEAM_1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        wait()
    #hit position marker
    createEffect(null if localPlayer.trajectory_hidden_manual else localPlayer, Effect.SPHERE, Color.RED, localPlayer.proj_predict_land_pos, 0.2 * evalOnce(_FX[0]), EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #apex
    createEffect(null if localPlayer.trajectory_hidden_manual else localPlayer, Effect.SPHERE, Color.GREEN, ((1 - localPlayer.proj_apex_t) * (1 - localPlayer.proj_apex_t)) * localPlayer.proj_p0 + (((2 * (1 - localPlayer.proj_apex_t)) * localPlayer.proj_apex_t) * localPlayer.proj_p1) + localPlayer.proj_apex_t * localPlayer.proj_apex_t * localPlayer.proj_p2, 0.2 * evalOnce(_FX[0]), EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #proj collision size
    #createEffect(getAllPlayers(), Effect.SPHERE, Color.YELLOW, localPlayer.proj_predict_land_pos, localPlayer.proj_r * evalOnce(_FX[0]), EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #spherecast progress size
    #createEffect(getAllPlayers(), Effect.SPHERE, Color.YELLOW, localPlayer.ray_cast_start, localPlayer.proj_r * evalOnce(_FX[0]), EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #primary range
    createEffect(null if localPlayer.trajectory_hidden_manual else localPlayer, Effect.SPHERE, Color.SKY_BLUE, localPlayer.proj_predict_land_pos, localPlayer.proj_fx[0] * evalOnce(_FX[0]), EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #secondary range
    createEffect(null if localPlayer.trajectory_hidden_manual else localPlayer, Effect.SPHERE, Color.BLUE, localPlayer.proj_predict_land_pos, localPlayer.proj_fx[1] * evalOnce(_FX[0]), EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #cylinder range
    createEffect(null if localPlayer.trajectory_hidden_manual else localPlayer, Effect.LIGHT_SHAFT, Color.BLUE, localPlayer.proj_predict_land_pos, localPlayer.proj_fx[2] * evalOnce(_FX[1]), EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #cylinder range (ring)
    createEffect(null if localPlayer.trajectory_hidden_manual else localPlayer, Effect.RING, Color.BLUE, localPlayer.proj_predict_land_pos, localPlayer.proj_fx[2] * evalOnce(_FX[2]), EffectReeval.VISIBILITY_POSITION_AND_RADIUS)


def hud_final():
    @Name "[sub] final hud"
    
    hudText(null if localPlayer.hudhide_bool else localPlayer, "Code: XWAGN", "Improved Nade Tool (v2.3.0.210322)", "by pluzorminuz", HudPosition.LEFT, -2, Color.YELLOW, Color.WHITE, Color.AQUA, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    hudSubtext(localPlayer if localPlayer.hudhide_bool else null, "XWAGN v2.3.0.210322", HudPosition.LEFT, -2, Color.YELLOW, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    hudText(getAllPlayers(), null, l"{0} - {1}".format(getNumberOfEntityIds(), getNumberOfTextIds()), l"{0} - {1} - {2}".format(getServerLoad(), getAverageServerLoad(), getPeakServerLoad()), HudPosition.RIGHT, -1, Color.WHITE, Color.GRAY, Color.GRAY, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudHeader(null if localPlayer.hudhide_bool else localPlayer, "Instructions", HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudText(null if localPlayer.hudhide_bool else localPlayer, null, "Ultimate Status", "- toggle chase camera", HudPosition.LEFT, 0.05, Color.WHITE, Color.BLUE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudText(null if localPlayer.hudhide_bool else localPlayer, null, l"{0} {1}".format(Button.MELEE, l"({0})".format(buttonString(Button.MELEE))), "- cancel chase cam in-progress" if localPlayer.chasecam_chasing else "- toggle landing spot view", HudPosition.LEFT, 0.1, Color.WHITE, Color.GREEN, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudText(null if localPlayer.hudhide_bool else localPlayer, null, l"{0} {1}".format(Button.RELOAD, l"({0})".format(buttonString(Button.RELOAD))), "- lock freecam" if localPlayer.freecam_bool else "- lock position and view", HudPosition.LEFT, 0.2, Color.WHITE, Color.RED, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudText(null if localPlayer.hudhide_bool else localPlayer, null, l"{0} and {1}".format(l"{0} {1}".format(Button.JUMP, l"({0})".format(buttonString(Button.JUMP))), l"{0} {1}".format(Button.CROUCH, l"({0})".format(buttonString(Button.CROUCH)))), "- zoom out or in while locked and in landing spot view", HudPosition.LEFT, 0.25, Color.WHITE, Color.YELLOW, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudText(null if localPlayer.hudhide_bool else localPlayer, null, l"{0} {1}".format(Button.INTERACT, l"({0})".format(buttonString(Button.INTERACT))), "- toggle trajectory auto-lock", HudPosition.LEFT, 0.3, Color.WHITE, Color.AQUA, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudText(null if localPlayer.hudhide_bool else localPlayer, null, "Acknowledge", "- change hero", HudPosition.LEFT, 0.4, Color.WHITE, Color.TURQUOISE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudText(null if localPlayer.hudhide_bool else localPlayer, null, "Group Up", "- [{0}] hide trajectory / effects".format("Hidden" if localPlayer.trajectory_hidden_manual else "Visible"), HudPosition.LEFT, 0.5, Color.WHITE, Color.LIME_GREEN, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudText(null if localPlayer.hudhide_bool else localPlayer, null, "Thanks", "- Toggle Freecam", HudPosition.LEFT, 0.6, Color.WHITE, Color.YELLOW, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudText(getAllPlayers(), null, "Need Healing", "- [{0}] Toggle HUD".format("Hidden" if localPlayer.hudhide_bool else "Visible"), HudPosition.LEFT, 0.7, Color.WHITE, Color.GRAY, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudHeader(null if localPlayer.hudhide_bool else localPlayer, "Stats", HudPosition.LEFT, 3, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudText(null if localPlayer.hudhide_bool else localPlayer, null, "Flight Time (Approx)", localPlayer.proj_simtime * localPlayer.proj_predict_land_t, HudPosition.LEFT, 3.05, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudText(null if localPlayer.hudhide_bool else localPlayer, null, "Position", localPlayer.getPosition(), HudPosition.LEFT, 3.1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudText(null if localPlayer.hudhide_bool else localPlayer, null, "Angles (Horz, Vert)", l"{0}, {1}".format(localPlayer.getHorizontalFacingAngle(), localPlayer.getVerticalFacingAngle()), HudPosition.LEFT, 3.2, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudText(null if localPlayer.hudhide_bool else localPlayer, null, "Proj Dir", normalize(vectorTowards((1 - localPlayer.chasecam_t) * localPlayer.proj_p0 + localPlayer.chasecam_t * localPlayer.proj_p1, (1 - localPlayer.chasecam_t) * localPlayer.proj_p1 + localPlayer.chasecam_t * localPlayer.proj_p2)), HudPosition.LEFT, 100, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #B'(t) definition
    hudText(null if localPlayer.hudhide_bool else localPlayer, null, "Proj Speed", (distance((2 * (1 - localPlayer.chasecam_t)) * (localPlayer.proj_p1 - localPlayer.proj_p0) + (2 * localPlayer.chasecam_t * (localPlayer.proj_p2 - localPlayer.proj_p1)), 0 * Vector.UP)) / localPlayer.proj_simtime, HudPosition.LEFT, 100.1, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudText(null if localPlayer.hudhide_bool else localPlayer, null, "land_pos_t / ray_cast_t", l"{0}, {1}".format(localPlayer.proj_predict_land_t, localPlayer.ray_cast_t), HudPosition.LEFT, 101, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudHeader(localPlayer if localPlayer.trajlock_bool else null, "Trajectory Auto-Lock ON", HudPosition.TOP, 1, Color.AQUA, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudHeader(localPlayer if localPlayer.poslock_bool else null, "Freecam View Locked. You can now activate your abilities." if localPlayer.freecam_bool else "LOCK ENGAGED! {0}: Zoom Out, {1}: Zoom In".format(buttonString(Button.JUMP), buttonString(Button.CROUCH)), HudPosition.TOP, 2, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudHeader(localPlayer if localPlayer.chasecam_bool else null, "Chase Camera On. Activate Ability ({0}) to start camera.".format(localPlayer.hero_ability_icon), HudPosition.TOP, 3, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudHeader(localPlayer if localPlayer.proj_warning else null, "NON-ZERO PROJECTILE RADIUS. TRAJECTORY MAY NOT MATCH", HudPosition.TOP, 4, Color.RED, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    #hudHeader(getAllPlayers(), localPlayer.proj_override, HudPosition.RIGHT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #hudHeader(getAllPlayers(), localPlayer.proj_override, HudPosition.RIGHT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)


def load_proj_data():
    @Name "[sub] load_proj_data"
    
    eventPlayer.hero_index = data[0].index(eventPlayer.getCurrentHero())
    eventPlayer.hero_proj_data = data[1][eventPlayer.hero_index][0]
    eventPlayer.proj_fx = data[1][eventPlayer.hero_index][2]
    eventPlayer.proj_warning = data[1][eventPlayer.hero_index][3]
    eventPlayer.using_ability = data[1][eventPlayer.hero_index][1]
    swap_proj_data()
    #eventPlayer.proj_g = eventPlayer.hero_proj_data[data[1][eventPlayer.hero_index][1]][0]
    #eventPlayer.proj_vel = eventPlayer.hero_proj_data[data[1][eventPlayer.hero_index][1]][1]
    #eventPlayer.proj_del = eventPlayer.hero_proj_data[data[1][eventPlayer.hero_index][1]][2]
    #eventPlayer.proj_simtime = eventPlayer.hero_proj_data[data[1][eventPlayer.hero_index][1]][3]
    #eventPlayer.proj_r = eventPlayer.hero_proj_data[data[1][eventPlayer.hero_index][1]][4]
    #eventPlayer.proj_castdelay = eventPlayer.hero_proj_data[data[1][eventPlayer.hero_index][1]][5]
    #eventPlayer.proj_chasedelay = eventPlayer.hero_proj_data[data[1][eventPlayer.hero_index][1]][6]


def save_trajectory_origin():
    @Name "[sub] save_eye_and_fac"
    
    eventPlayer.proj_p0_hidden = eventPlayer.getEyePosition()
    eventPlayer.proj_dir_raw_hidden = eventPlayer.getFacingDirection()
    eventPlayer.proj_dir_hidden = Vector.UP if eventPlayer.getVerticalFacingAngle() < -89 else Vector.DOWN if eventPlayer.getVerticalFacingAngle() > 89 else normalize(eventPlayer.getFacingDirection() + eventPlayer.proj_del * Vector.UP)


def calc_proj():
    @Name "[sub] calculate_projectile_parameters"
    
    eventPlayer.proj_p0 = eventPlayer.proj_p0_hidden
    eventPlayer.proj_dir = eventPlayer.proj_dir_hidden
    eventPlayer.proj_p1 = eventPlayer.proj_p0 + 0.5 * eventPlayer.proj_vel * eventPlayer.proj_simtime * eventPlayer.proj_dir
    eventPlayer.proj_p2 = eventPlayer.proj_p0 + eventPlayer.proj_vel * eventPlayer.proj_simtime * eventPlayer.proj_dir + 0.5 * eventPlayer.proj_simtime * eventPlayer.proj_simtime * eventPlayer.proj_g * Vector.UP
    eventPlayer.proj_apex_t = -1 * eventPlayer.proj_dir.y * eventPlayer.proj_vel / eventPlayer.proj_g / eventPlayer.proj_simtime
    if hostPlayer == eventPlayer:
        if eventPlayer.proj_r == 0:
            for eventPlayer.ray_cast_t in range(0, 1, 0.002):
                eventPlayer.ray_cast_start = (evalOnce((1 - eventPlayer.ray_cast_t) * (1 - eventPlayer.ray_cast_t))) * eventPlayer.proj_p0 + ((evalOnce((2 * (1 - eventPlayer.ray_cast_t)) * eventPlayer.ray_cast_t)) * eventPlayer.proj_p1) + evalOnce(eventPlayer.ray_cast_t * eventPlayer.ray_cast_t) * eventPlayer.proj_p2
                if eventPlayer.ray_cast_start.y < map_deathplane_y:
                    break
                eventPlayer.ray_cast_end = (evalOnce((0.998 - eventPlayer.ray_cast_t) * (0.998 - eventPlayer.ray_cast_t))) * eventPlayer.proj_p0 + ((evalOnce((2 * (0.998 - eventPlayer.ray_cast_t)) * (eventPlayer.ray_cast_t + 0.002))) * eventPlayer.proj_p1) + ((evalOnce((eventPlayer.ray_cast_t + 0.002) * (eventPlayer.ray_cast_t + 0.002))) * eventPlayer.proj_p2)
                eventPlayer.ray_cast_hit_pos = raycast(eventPlayer.ray_cast_start, eventPlayer.ray_cast_end, null, eventPlayer, true).getHitPosition()
                #hit something
                if eventPlayer.ray_cast_hit_pos != eventPlayer.ray_cast_end:
                    break
            #adjustment term
            eventPlayer.proj_predict_land_t = eventPlayer.ray_cast_t + 0.002 * (distance(eventPlayer.ray_cast_start, eventPlayer.ray_cast_hit_pos) / distance(eventPlayer.ray_cast_start, eventPlayer.ray_cast_end))
            eventPlayer.proj_predict_land_pos = eventPlayer.ray_cast_hit_pos
            wait(0.064)
        else:
            wait()


rule "hudhide (need healing)":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.isCommunicating(Comms.NEED_HEALING) == true
    
    eventPlayer.hudhide_bool = not eventPlayer.hudhide_bool


rule "freecam_toggle":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.isCommunicating(Comms.THANKS) == true
    
    eventPlayer.freecam_bool = not eventPlayer.freecam_bool


rule "freecam_movement_loop":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.freecam_bool == true
    
    if eventPlayer.poslock_bool:
        eventPlayer.freecam_accel = 0 * Vector.UP
    else:
        #get controls
        eventPlayer.freecam_accel = eventPlayer.getThrottle() + Vector.UP * eventPlayer.isHoldingButton(Button.JUMP) + Vector.DOWN * eventPlayer.isHoldingButton(Button.CROUCH)
    #normalize if non-zero vector
    if eventPlayer.freecam_accel != 0 * Vector.UP:
        eventPlayer.freecam_accel = normalize(eventPlayer.freecam_accel)
        #transform the accel to local space
        eventPlayer.freecam_accel = eventPlayer.freecam_accel.x * worldVector(Vector.LEFT, eventPlayer, Transform.ROTATION) + (eventPlayer.freecam_accel.y * (angleToDirection(eventPlayer.getHorizontalFacingAngle(), eventPlayer.getVerticalFacingAngle() - 90))) + eventPlayer.freecam_accel.z * eventPlayer.getFacingDirection()
        #add accel to vel
        eventPlayer.freecam_vel += 0.09 * eventPlayer.freecam_accel
        #if norm(vel) > 1
        if distance(0 * Vector.UP, eventPlayer.freecam_vel) > 1:
            eventPlayer.freecam_vel = normalize(eventPlayer.freecam_vel)
        #no accel, decel
    else:
        if distance(0 * Vector.UP, eventPlayer.freecam_vel) < 0.08:
            eventPlayer.freecam_vel = 0 * Vector.UP
        else:
            eventPlayer.freecam_vel -= 0.06 * eventPlayer.freecam_vel
    eventPlayer.freecam_freeeye += 0.25 * eventPlayer.freecam_vel
    wait()
    if RULE_CONDITION:
        goto RULE_START


rule "freecam locked":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.freecam_bool == true
    @Condition eventPlayer.poslock_bool == true
    
    eventPlayer.freecam_prevdir = eventPlayer.getFacingDirection()
    eventPlayer.setFacing(eventPlayer.proj_dir_raw_hidden, Relativity.TO_WORLD)


rule "freecam unlock":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.freecam_bool == true
    @Condition eventPlayer.poslock_bool != true
    
    eventPlayer.setFacing(eventPlayer.freecam_prevdir, Relativity.TO_WORLD)


rule "freecam on":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.freecam_bool == true
    
    eventPlayer.freecam_bool = true
    eventPlayer.freecam_prevdir = eventPlayer.getFacingDirection()
    eventPlayer.setFacing(eventPlayer.proj_dir_raw_hidden, Relativity.TO_WORLD)
    eventPlayer.freecam_freeeye = eventPlayer.getEyePosition()
    eventPlayer.startCamera(updateEveryTick(eventPlayer.freecam_freeeye), updateEveryTick(eventPlayer.freecam_freeeye + (50 * (eventPlayer.freecam_prevdir if eventPlayer.poslock_bool else eventPlayer.getFacingDirection()))), 1000)


rule "freecam off":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.freecam_bool == false
    
    eventPlayer.freecam_bool = false
    eventPlayer.stopCamera()


