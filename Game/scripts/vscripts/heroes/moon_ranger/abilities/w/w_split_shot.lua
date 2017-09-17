require('heroes/moon_ranger/init')
local AstralSteal = require('heroes/moon_ranger/abilities/w/w1_astral_steal')
local AstralVolley = require('heroes/moon_ranger/abilities/w/w2_astral_volley')
local ClusterArrow = require('heroes/moon_ranger/abilities/w/w4_cluster_arrow')

function beginChannel(event)
    local caster = event.caster
    StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_ATTACK, rate=0.8})
end

function beginCast(event)
    local caster = event.caster
    local ability = event.ability
    local damage = event.damage
    local range = event.range
    local shotsCount = AstralVolley.getVolleysCount(caster)

    EmitSoundOn("Astral.AstralVolleyBig", caster)

    ability:SetActivated(false)
    ability.damage = damage

    local arrowCount = 0
    local empyralArrowsProcChance = 0

    if caster:HasModifier("modifier_astral_glyph_3_1") then
        empyralArrowsProcChance = getProcChance(caster, T31_PROC_CHANCE)
        arrowCount = T31_ARROWS_COUNT
        damage = damage * 2
    else
        empyralArrowsProcChance = getProcChance(caster, W3_PROC_CHANCE)
        arrowCount = W_ARROWS_COUNT
    end

    local maxArrow = math.floor(arrowCount/2)
    local minArrow = -maxArrow

    local w3ability = caster.runeUnit3:FindAbilityByName("astral_rune_c_b")
    w3ability.damage = damage
    w3ability.caster = caster

    local abilityLevel = ability:GetLevel()
    local manaCost = ability:GetManaCost(abilityLevel)

    for shotIndex = 0, shotsCount, 1 do
        Timers:CreateTimer(shotIndex * W_DELAY, function()
            makeShot(caster, ability, w3ability, manaCost, range, minArrow, maxArrow,empyralArrowsProcChance, shotIndex ~= 0)
            if (shotIndex == shotsCount) then
                ability:SetActivated(true)
            end
        end)
    end
end

function makeShot(caster, ability, w3ability, manaCost, range, minArrow, maxArrow,empyralArrowsProcChance, playSound)
    for arrowNumber = minArrow, maxArrow, 1 do
        local arrowOrigin = caster:GetOrigin() + caster:GetForwardVector()*Vector(80,80,0)
        local rotatedVector = rotateVector(caster:GetForwardVector(), math.pi/40*arrowNumber)

        local luck = RandomInt(1, 100)

        if (luck < empyralArrowsProcChance) then
            local forwardVector = caster:GetForwardVector()
            local empyralArrowOrigin = arrowOrigin + forwardVector*40
            createArrow(caster, w3ability, W3_PARTICLE, range, empyralArrowOrigin, rotatedVector)
        else
            createArrow(caster, ability, W_PARTICLE, range, arrowOrigin, rotatedVector)
        end

    end
    if playSound then
        StartAnimation(caster, {duration=delay, activity=ACT_DOTA_ATTACK, rate=3.6})
        EmitSoundOn("Astral.AstralVolleySmall", caster)
    end
    caster:ReduceMana(manaCost)
    local event = {}
    event.ability = caster.body
    event.event_ability = ability
    CustomAbilities:IceQuill(event)
end

function createArrow(caster, ability, particle, range,  arrowOrigin, rotatedVector)
    local start_radius = 60
    local end_radius = 60
    local speed = 1100
    local info =
    {
        Ability = ability,
        EffectName = particle,
        vSpawnOrigin = arrowOrigin,
        fDistance = range,
        fStartRadius = start_radius,
        fEndRadius = end_radius,
        Source = caster,
        StartPosition = "attach_origin",
        bHasFrontalCone = true,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 5.0,
        bDeleteOnHit = false,
        vVelocity = rotatedVector * speed,
        bProvidesVision = false,
    }
    ProjectileManager:CreateLinearProjectile(info)
end

function projectileHit(event)
    local target = event.target
    local caster = event.caster
    local damage = event.ability.damage
    Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_NORMAL, RPC_ELEMENT_COSMOS)

    AstralSteal.projectileHit(event)
    ClusterArrow.projectileHit(event)
end

function rotateVector(vector, radians)
    local XX = vector.x
    local YY = vector.y

    local Xprime = math.cos(radians)*XX -math.sin(radians)*YY
    local Yprime = math.sin(radians)*XX +math.cos(radians)*YY

    local vectorX = Vector(1,0,0)*Xprime
    local vectorY = Vector(0,1,0)*Yprime
    local rotatedVector = vectorX + vectorY
    return rotatedVector
end