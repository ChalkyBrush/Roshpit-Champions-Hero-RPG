-- Name: Fireball
-- Description: Send fireball to nearest enemy.
--  Base values:
--      Count: 1(can be increase by imp amplify, maximum 36 fireballs)
--      Damage: 300, 1 000, 10 000(can be increase by imp amplify)
--      Damage type: Pure
--      Speed: 400 (increase with imp amplify/20, max 1200)

local particleName = 'particles/econ/items/wraith_king/wraith_king_ti6_bracer/wraith_king_ti6_ambient_fireball_fire.vpcf'

local abilityClass = "npc_fireball"
local passive = "modifier_npc_fireball_passive"


function abilityClass:OnLevelChanged()
    local ability = self:GetAbility()
    ability.fireballsCount = ability:getSpecialValueFor('count')
    ability.fireballsSpeed = ability:getSpecialValueFor('speed')
    ability.damage = ability:getSpecialValueFor('damage')
    ability.aoeRadius = ability:getSpecialValueFor('aoe_radius')
    self:StartThinkInterval(0.5)
end


function abilityClass:SetFireballsCount(count)
    self.fireballsCount = count
    return self
end
function abilityClass:SetSpeed(speed)
    self.fireballsSpeed = speed
    return self
end
function abilityClass:GetSpeed()
    return self.fireballsSpeed
end
function abilityClass:GetDamage()
    return self.damage
end
function abilityClass:SetDamage(damage)
    self.damage = damage
    return self

end
function abilityClass:GetAOERadius()
    return self:GetRadius(self.aoeRadius)
end

function abilityClass:GetMaxRotate()
    if self.fireballsCount <= 3 then
        return math.pi/3
    elseif self.fireballsCount <= 7 then
        return 2 * math.pi/3
    elseif self.fireballsCount <= 11 then
        return math.pi
    elseif self.fireballsCount <= 17 then
        return 1.5 * math.pi
    else
        return 2 * math.pi
    end
end


function abilityClass:OnSpellStart()
    local caster = self:GetCaster()
    local fireballsCount

    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
    if #enemies == 0 then
        return
    end

    local fv = ((enemies[1]:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()

    local maxRotate = self:GetMaxRotate()
    local startRotate =  -maxRotate/2 + (math.floor((self.fireballsCount - 1)/2) + (self.fireballsCount - 1) % 2)
    local rotateStep = maxRotate/self.fireballsCount

    for i = 1, self.fireballsCount do
        local fv = WallPhysics:rotateVector(fv, startRotate + i * rotateStep)
        self:CreateProjectile(fv, self.fireballsSpeed)
    end

end
function abilityClass:OnProjectileHit(target)
    Damage:Apply({
        attacker = self:GetCaster(),
        victim = target,
        sourceType = BASE_EMPTY,
        damageType = DAMAGE_TYPE_PURE,
        damage = self:GetDamage()
    })
end

function abilityClass:CreateProjectile(normalizedTargetVector, speed)
    local caster = self:GetOwner()
    local ability = self:GetAbility()
    local start_radius = 60
    local end_radius = 60
    local info =
    {
        Ability = ability,
        EffectName = particleName,
        vSpawnOrigin = caster:GetAbsOrigin(),
        fDistance = speed * 5,
        fStartRadius = start_radius,
        fEndRadius = end_radius,
        Source = caster,
        StartPosition = "attach_origin",
        bHasFrontalCone = true,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 5.0,
        bDeleteOnHit = false,
        vVelocity = normalizedTargetVector * speed,
        bProvidesVision = false,
    }
    ProjectileManager:CreateLinearProjectile(info)
end


function passive:CastAbility()
    local ability = self:GetAbility()
    local caster = self:GetOwner()
    local newOrder = {
        UnitIndex = caster:entindex(),
        OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
        AbilityIndex = ability:entindex(),
    }
    ExecuteOrderFromTable(newOrder)
end

function passive:OnIntervalThink()
    local ability = self:GetAbility()
    local caster = self:GetOwner()
    if ability:GetCooldownTimeRemaining() > 0 then
        return
    end
    if caster:IsStunned() or caster:IsFakeStunned() or caster:IsSilenced() then
        return
    end
    self:CastAbility()
end