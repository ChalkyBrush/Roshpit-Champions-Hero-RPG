require('items/lua/foot/base')
require('npc_abilities/base_modifier')

item_rpc_storm_pacer_sabatons = class(BaseFoot, nil, BaseFoot)
modifier_storm_pacer_sabatons = class(npc_base_modifier, nil, npc_base_modifier)
local class = item_rpc_storm_pacer_sabatons
local className = 'item_rpc_storm_pacer_sabatons'

local modifierClass = modifier_storm_pacer_sabatons
local modifierName = 'modifier_storm_pacer_sabatons'
LinkLuaModifier(modifierName, "items/lua/foot/storm_pacer_sabatons", LUA_MODIFIER_MOTION_NONE)

function class:GetClassName()
    return className
end
function class:GetName()
    return 'Pace of storm'
end
function class:GetModifierName()
    return modifierName
end
function class:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 2)
end
function class:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 1.5)
end

function class:RollProperty1()
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_storm_pacer_sabatons"
    self:SetSpecialValue("storm_pacer_sabatons", "#8fd8f7")
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
    self.elements = {}

    self.currentRadius = 0
    self.maxRadius = ITEM_RPC_STORM_PACER_SABATONS_RADIUS + self:GetAbility():GetFinalGemPropertyValue("ruby", ITEM_RPC_STORM_PACER_SABATONS_GEM_RUBY1)
    self.radiusStep = ITEM_RPC_STORM_PACER_SABATONS_RADIUS/5
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
    local cooldown = math.max(ITEM_RPC_STORM_PACER_SABATONS_COOLDOWN - ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_STORM_PACER_SABATONS_GEM_AMETHYST), 0.1)
    self.cooldownUntil = GameRules:GetGameTime() + cooldown
    self.retracing = false
    self.currentRadius = 0
    self.localKey = 'item_storm_pacer_sabatons_' .. ability:GetEntityIndex() .. '_' .. ability.uid
    self:PlayEffectsCast()
    self:StartIntervalThink(self.thinkInterval)
end
function modifierClass:PlayEffectsCast()
    local caster = self:GetCaster()

    EmitSoundOn("Items.Stormpace.Activate", caster)

    local pfx = ParticleManager:CreateParticle("particles/roshpit/items/storm_pace_reduced_flash.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
    self.pfx = pfx
    ParticleManager:SetParticleControl(self.pfx, 0, caster:GetAbsOrigin())
    local speed = self.radiusStep/self.thinkInterval
    ParticleManager:SetParticleControl(self.pfx, 1, Vector(speed, self.maxRadius, 600))
    local colorVector = Vector(150, 150, 150)
    if #self.elements > 0 then
        local elementName, elementColor = Elements:GetElementNameAndColorByCode(self.elements[1])
        local r, g, b = Elements:hex2rgb(elementColor)
        colorVector = Vector(r,g,b)
    end
    colorVector = colorVector/255
    ParticleManager:SetParticleControl(self.pfx, 12, colorVector)
    Timers:CreateTimer(2 * self.maxRadius/speed, function ()
        ParticleManager:DestroyParticle(pfx, false)
        ParticleManager:ReleaseParticleIndex(pfx)
    end)
end
function modifierClass:OnIntervalThink()
    local caster = self:GetCaster()
    local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)*ITEM_RPC_STORM_PACER_SABATONS_DMG_ATK_POWER_PCT/100  + self:GetAbility():GetFinalGemPropertyValue("ruby", ITEM_RPC_STORM_PACER_SABATONS_GEM_RUBY2)
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
    local element1 = self.elements[1]
    local element2 = self.elements[2]
    if not element1 then
        element1 = RPC_ELEMENT_NORMAL
    end
    if not element2 then
        element2 = RPC_ELEMENT_NONE
    end
    enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.currentRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    for _,enemy in pairs(enemies) do
        if enemy[self.localKey] or excluded_enemies[enemy:GetEntityIndex()] then
        else
            enemy[self.localKey] = true
            local max_amp = 1
            if self:GetAbility():GetGemValue("emerald") > 0 then
                max_amp = self:GetAbility():GetFinalGemPropertyValue("emerald", ITEM_RPC_STORM_PACER_SABATONS_GEM_EMERALD)
            end
            local distanceMult = (max_amp - 1) * WallPhysics:GetDistance2d(caster:GetAbsOrigin(), enemy:GetAbsOrigin())/self.maxRadius
            local mult = 1 + distanceMult
            damage = damage * mult
            Filters:ApplyItemDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, ability, element1, element2)
        end
    end
end
function modifierClass:OnAfterPreMitigationReduce(data)
    if data.source ~= self:GetAbility() then
        self.damage = data.damage
        self.elements = data.elements
    end
end