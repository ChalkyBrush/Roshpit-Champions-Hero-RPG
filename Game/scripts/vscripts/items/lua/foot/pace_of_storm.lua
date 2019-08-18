require('items/lua/foot/base')
require('npc_abilities/base_modifier')

item_rpc_pace_of_storm = class(BaseFoot, nil, BaseFoot)
modifier_pace_of_storm = class(npc_base_modifier, nil, npc_base_modifier)
local class = item_rpc_pace_of_storm
local className = 'item_rpc_pace_of_storm'

local modifierClass = modifier_pace_of_storm
local modifierName = 'modifier_pace_of_storm'
LinkLuaModifier(modifierName, "items/lua/foot/pace_of_storm", LUA_MODIFIER_MOTION_NONE)

function class:GetClassName()
    return className
end
function class:GetName()
    return 'Pace of storm'
end
function class:GetModifierName()
    return modifierName
end
function class:RollProperty1()
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "pace_of_storm"
    self:SetSpecialValue(self.newItemTable.property1name, "#CC1104")
end
function modifierClass:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({
        MODIFIER_SPECIAL_TYPE_CAST_E_ABILITY,
        MODIFIER_SPECIAL_TYPE_PREMITIGATION,
    })
    self.damage = 0
    self.cooldownUntil = 0

    self.currentRadius = 0
    self.maxRadius = PACE_OF_STORM_RADIUS
    self.radiusStep = PACE_OF_STORM_RADIUS/7
    self.thinkInterval = 0.1

    self.retracing = false
end
function modifierClass:OnCastEAbility()
    local ability = self:GetAbility()
    ability.uid = ability.uid or 0
    ability.uid = ability.uid + 1
    if self.cooldownUntil > GameRules:GetGameTime() then
        return
    end
    self.cooldownUntil = GameRules:GetGameTime() + PACE_OF_STORM_COOLDOWN
    self.retracing = false
    self.currentRadius = 0
    self.localKey = 'item_pace_of_storm_' .. ability:GetEntityIndex() .. '_' .. ability.uid
    self:PlayEffectsCast()
    self:StartIntervalThink(self.thinkInterval)
end
function modifierClass:PlayEffectsCast()
    local caster = self:GetCaster()

    EmitSoundOn("Jex.RingOfFire.Start", caster)

    self.pfx = ParticleManager:CreateParticle("particles/roshpit/jex/ring_of_fire_reduced_flash.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
    ParticleManager:SetParticleControl(self.pfx, 0, caster:GetAbsOrigin())
    local speed = self.radiusStep/self.thinkInterval
    ParticleManager:SetParticleControl(self.pfx, 1, Vector(speed, self.maxRadius, 600))

    Timers:CreateTimer(2 * self.maxRadius/speed, function ()
        ParticleManager:DestroyParticle(self.pfx, false)
        ParticleManager:ReleaseParticleIndex(self.pfx)
        self.pfx = nil
    end)
end
function modifierClass:OnIntervalThink()
    local caster = self:GetCaster()

    if self.retracing then
        self.currentRadius = math.max(self.currentRadius - self.radiusStep, 0)
        if self.currentRadius == 0 then
            self:StartIntervalThink( -1 )
        end
    else
        self.currentRadius = math.min(self.currentRadius + self.radiusStep, self.maxRadius)
        if self.currentRadius == self.maxRadius then
            self.retracing = true
            self.localKey = self.localKey .. '_retracing'
            ParticleManager:SetParticleControl(self.pfx, 1, Vector(self.radiusStep/self.thinkInterval, -self.maxRadius, 600))
        end
    end
    local lessRadius = math.max(self.currentRadius - 2 * self.radiusStep, 0)
    local excluded_enemies = {}
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, lessRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    for _,enemy in pairs(enemies) do
        excluded_enemies[enemy:GetEntityIndex()] = true
    end
    enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.currentRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    for _,enemy in pairs(enemies) do
        if enemy[self.localKey] or excluded_enemies[enemy:GetEntityIndex()] then
        else
            local distanceMult = (PACE_OF_STORM_MAX_AMP - PACE_OF_STORM_MIN_AMP) * WallPhysics:GetDistance2d(caster:GetAbsOrigin(), enemy:GetAbsOrigin())/self.maxRadius
            local mult = PACE_OF_STORM_MIN_AMP + distanceMult
            Damage:Apply({
                source = self:GetAbility(),
                sourceType = BASE_NONE,
                attacker = caster,
                victim = enemy,
                damage = mult * self.damage,
                damageType = DAMAGE_TYPE_MAGICAL,
                ignoreMultipliers = true,
                steadfastThresholdMult = PACE_OF_STORM_STEADFAST_THRESHOLD,
                megaSteadfastThresholdMult = PACE_OF_STORM_MEGASTEADFAST_THRESHOLD,
            })
        end
    end
end
function modifierClass:OnAfterPreMitigationReduce(data)
    if data.source ~= self:GetAbility() then
        self.damage = data.damage
    end
end