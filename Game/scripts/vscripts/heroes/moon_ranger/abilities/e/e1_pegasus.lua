require('heroes/moon_ranger/init')

function createPegasus(caster, ability, startPoint, endPoint, delay)
    local runesCount = caster.e_1_level
    if runesCount == nil or runesCount <= 0 then
        return
    end
    local travelsCount = E1_TRAVELS_COUNT

    ability.runesCount = runesCount
    ability.duration = E1_START_DURATION + runesCount * E1_ADD_DURATION

    for travelIndex = 1, travelsCount, 1 do
        local projectileDelay = delay * (travelIndex - 1)
        Timers:CreateTimer(projectileDelay, function()
            if travelIndex%2 == 1 then
                createPegasusProjectile(caster, ability, startPoint, endPoint)
            else
                createPegasusProjectile(caster, ability, endPoint, startPoint)
            end
        end)
        -- if (travelIndex + 1 <= travelsCount) then
        --     Timers:CreateTimer(delay * travelIndex, function()
        --         createProjectile(caster, ability, endPoint, startPoint)
        --     end)
        -- end
    end
end

function createPegasusProjectile(caster, ability, startPoint, endPoint)
    local range = WallPhysics:GetDistance2d(startPoint, endPoint)
    local forwardVector = getForwardVector(startPoint, endPoint)
    if forwardVector == Vector(0,0) then
        forwardVector = caster:GetForwardVector()
    end
    local speed = math.max(range * E1_SPEED_FROM_RANGE, 300)
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
        iVisionTeamNumber = caster:GetTeamNumber(),
        bProvidesVision = true
    }
    ProjectileManager:CreateLinearProjectile(info)

  local pegasusVisual = ParticleManager:CreateParticle("particles/roshpit/astral/pegasus.vpcf", PATTACH_WORLDORIGIN, nil)
  ParticleManager:SetParticleControl(pegasusVisual, 0, startPoint)
  ParticleManager:SetParticleControl(pegasusVisual, 1, forwardVector*speed)
  ParticleManager:SetParticleControl(pegasusVisual, 3, startPoint)
  ParticleManager:SetParticleControl(pegasusVisual, 8, Vector(1,1,1))
  ParticleManager:SetParticleControl(pegasusVisual, 10, Vector(range/speed,range/speed,range/speed))
  Timers:CreateTimer(range/speed, function()
    ParticleManager:DestroyParticle(pegasusVisual, false)
  end)
end

function projectileHit(event)
    local target = event.target
    local caster = event.caster
    local ability = event.ability
    local runesCount = ability.runesCount

    local duration = ability.duration
    print(duration)
    ability:ApplyDataDrivenModifier(caster, target, "modifier_star_blink_root", {duration = duration})
    if duration > 0 then
        Helper.updateStackModifier(target, caster, ability, 'astral_rune_e_1', duration, E1_MAX_STACKS_COUNT, runesCount)
    end
end

function getForwardVector(startPoint, endPoint)
    local netVector = endPoint - startPoint
    return (netVector*Vector(1,1,0)):Normalized()
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