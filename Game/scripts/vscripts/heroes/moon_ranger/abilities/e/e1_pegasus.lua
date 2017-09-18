require('heroes/moon_ranger/init')
local function createPegasus(caster, ability, startPoint, endPoint, delay)
    local runesCount = caster.a_c_level
    if runesCount == nil or runesCount <= 0 then
        return
    end
    local travelsCount = 0

    if caster:HasModifier("modifier_astral_glyph_1_1") then
        travelsCount = T11_TRAVELS_COUNT
    else
        travelsCount = E1_TRAVELS_COUNT
    end

    ability.runesCount = runesCount
    ability.duration = E1_START_DURATION + runesCount * E1_ADD_DURATION

    for travelIndex = 1, travelsCount, 2 do
        Timers:CreateTimer(delay * (travelIndex - 1), function()
            createProjectile(caster, ability, startPoint, endPoint)
        end)
        if (travelIndex + 1 <= travelsCount) then
            Timers:CreateTimer(delay * travelIndex, function()
                createProjectile(caster, ability, endPoint, startPoint)
            end)
        end
    end
end

function createProjectile(caster, ability, startPoint, endPoint)
    local range = getDistance(startPoint, endPoint)
    local forwardVector = getForwardVector(startPoint, endPoint)
    local speed = range * E1_SPEED_FROM_RANGE
    local info =
    {
        Ability = ability,
        EffectName = E1_PARTICLE,
        vSpawnOrigin = startPoint,
        fDistance = range,
        fStartRadius = E1_RADIUS,
        fEndRadius = E1_RADIUS,
        Source = caster,
        StartPosition = "attach_origin",
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        iVisionRadius = 500,
        fExpireTime = GameRules:GetGameTime() + 5.0,
        bDeleteOnHit = false,
        vVelocity = forwardVector * speed,
        bProvidesVision = true,
    }
    ProjectileManager:CreateLinearProjectile(info)
end

function projectileHit(event)
    local target = event.target
    local caster = event.caster
    local ability = event.ability
    local runesCount = ability.runesCount

    local duration = ability.duration
    if duration > 0 then
        Helper.updateStackModifier(target, caster, ability, 'astral_rune_a_c', duration, E1_MAX_STACKS_COUNT, runesCount)
    end
end

function getForwardVector(startPoint, endPoint)
    local netVector = endPoint - startPoint
    return netVector:Normalized()*Vector(1,1,0)
end

function getDistance(a,b)
    local x, y, z = a.x-b.x, a.y-b.y, a.z-b.z
    return math.sqrt(x*x+y*y+z*z)
end

local module = {}
module.createProjectile = createProjectile
module.createPegasus = createPegasus
module.projectileHit = projectileHit
return module