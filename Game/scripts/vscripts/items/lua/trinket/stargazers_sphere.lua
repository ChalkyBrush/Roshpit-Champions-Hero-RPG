require('/items/lua/trinket/base')
require('/npc_abilities/base_modifier')

local modifierName = 'modifier_stargazers_sphere'
local modifierCircleAuraName = 'modifier_stargazers_sphere_circle_aura'
local modifierCircleEffectName = 'modifier_stargazers_sphere_circle_effect'

LinkLuaModifier(modifierName, "/items/lua/trinket/stargazers_sphere", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier(modifierCircleEffectName, "/items/lua/trinket/stargazers_sphere", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier(modifierCircleAuraName, "/items/lua/trinket/stargazers_sphere", LUA_MODIFIER_MOTION_NONE)

item_rpc_stargazers_sphere = class(BaseTrinket, nil, BaseTrinket)
modifier_stargazers_sphere = class(npc_base_modifier, nil, npc_base_modifier)
modifier_stargazers_sphere_circle_aura = class(npc_base_modifier, nil, npc_base_modifier)
modifier_stargazers_sphere_circle_effect = class(npc_base_modifier, nil, npc_base_modifier)
local class = item_rpc_stargazers_sphere
local className = 'item_rpc_stargazers_sphere'
local modifierCircleAuraClass = modifier_stargazers_sphere_circle_aura
local modifierClass = modifier_stargazers_sphere
local modifierCircleEffectClass = modifier_stargazers_sphere_circle_effect

function class:GetClassName()
    return className
end
function class:GetName()
    return 'Stargazers sphere'
end
function class:GetModifierName()
    return modifierName
end
function class:RollProperty1()
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "stargazer"
    self:SetSpecialValue(self.newItemTable.property1name, "#7A5C8E")
end
function class:RollProperty2()
    local visionBonus = RPCItems:GetLogarithmicVarianceValue(RandomInt(500, 700), 0, 0, 0, 0)
    self.newItemTable.property2 = visionBonus
    self.newItemTable.property2name = "vision"
    self:SetNormalValue(2)
end
function class:RollProperty3()
    local luck = RandomInt(1, 2)
    if luck == 1 then
        Elements:RollElementAttribute(self, RPC_ELEMENT_COSMOS, 2.6, 1, 30, 3)
    else
        getbase(self).RollProperty3(self)
    end
end
function modifierClass:OnCreated()
    self:SetSpecialTypes({
        MODIFIER_SPECIAL_TYPE_ORDER_FILTER,
    })
    self.apertures = {}
    self.cdUntil = 0
end
function modifierClass:OnOrderFilter(data)
    local allowedOrderTypes = {
        [DOTA_UNIT_ORDER_ATTACK_MOVE] = true,
        [DOTA_UNIT_ORDER_ATTACK_TARGET] = true,
    }
    if not allowedOrderTypes[data.order_type] then
        return
    end
    if data.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET and EntIndexToHScript(data.entindex_target):GetClassname() == "dota_item_drop" then
        return
    end

    local targetVector
    if data.order_type == DOTA_UNIT_ORDER_ATTACK_MOVE then
        targetVector = Vector(data.position_x, data.position_y)
    else
        local targetOrigin = EntIndexToHScript(data.entindex_target):GetAbsOrigin()
        targetVector = Vector(targetOrigin.x, targetOrigin.y)
    end

    targetVector = GetGroundPosition(targetVector, self:GetCaster())

    if self.cdUntil < GameRules:GetGameTime() then
        self.cdUntil = GameRules:GetGameTime() + 1

        for _,aperture in pairs(self.apertures) do
            local distance = WallPhysics:GetDistance2d(targetVector, aperture.position)
            if distance < 300 then
                self:CreateMeteor(aperture, targetVector)
                return
            end
        end

        self:CreateCircle(targetVector)
    end
end
function modifierClass:CreateCircle(targetVector)
    local caster = self:GetCaster()
    local ability = self:GetAbility()
    local aperture = {
        position = targetVector,
        active = true,
    }

    self:PlayEffectsCircle(aperture)

    local dummy = CreateUnitByName("npc_flying_dummy_vision",aperture.position, false, nil, nil, caster:GetTeamNumber())
    aperture.dummy = dummy

    dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
    dummy:AddNewModifier(caster, self:GetAbility(), modifierCircleAuraName, {})
    if ability.newItemTable.property2name == 'vision' then
        dummy:SetNightTimeVisionRange(ability.newItemTable.property2)
        dummy:SetDayTimeVisionRange(ability.newItemTable.property2)
    end
    self.apertures[aperture] = aperture

    Timers:CreateTimer(10, function()
        self:DestroyCircle(aperture)
    end)
end
function modifierClass:DestroyCircle(aperture)
    if not aperture.dummy or not IsValidEntity(aperture.dummy) then
        return
    end
    self.apertures[aperture] = nil
    aperture.active = false

    ParticleManager:DestroyParticle(aperture.pfx, false)
    ParticleManager:ReleaseParticleIndex(aperture.pfx)

    UTIL_Remove(aperture.dummy)
end
function modifierClass:PlayEffectsCircle(aperture)
    EmitSoundOn("RPCItems.Stargazer.Start", dummy)
    local pfx = ParticleManager:CreateParticle("particles/roshpit/items/stargazer_ring_ring.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(pfx, 0, aperture.position)
    aperture.pfx = pfx
end
function modifierClass:CreateMeteor(aperture, targetVector)
    self:PlayEffectsMeteor(aperture, targetVector)
    Timers:CreateTimer(0.5, function()
        self:PlayEffectsMeteorImpact(aperture, targetVector)
        self:DestroyCircle(aperture)

        local caster = self:GetCaster()
        local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * 5
        local enemies = FindUnitsInRadius(caster:GetTeamNumber(), targetVector, nil, 320, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
        if #enemies > 0 then
            for _, enemy in pairs(enemies) do
                Filters:ApplyStun(self:GetCaster(), 1.0, enemy)
                Damage:Apply({
                    attacker =  caster,
                    victim = enemy,
                    damage = damage,
                    damageType = DAMAGE_TYPE_PURE,
                    source = self:GetAbility(),
                    sourceType = BASE_ITEM,
                    elements = {
                        RPC_ELEMENT_COSMOS
                    }
                })
            end
        end
    end)
end
function modifierClass:PlayEffectsMeteor(aperture, targetVector)

    EmitSoundOnLocationWithCaster(targetVector, "RPCItems.Stargazer.MeteorStart", self:GetCaster())
    local pfx = ParticleManager:CreateParticle("particles/roshpit/items/stargazer_comet.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(pfx, 0, targetVector + Vector(0, 0, 700))
    ParticleManager:SetParticleControl(pfx, 1, targetVector)
    ParticleManager:SetParticleControl(pfx, 2, Vector(0.5, 0.5, 0.5))
    Timers:CreateTimer(2, function()
        ParticleManager:DestroyParticle(pfx, false)
        ParticleManager:ReleaseParticleIndex(pfx)
    end)
end
function modifierClass:PlayEffectsMeteorImpact(aperture, targetVector)
    EmitSoundOnLocationWithCaster(targetVector, "RPCItems.Stargazer.MeteorImpact", self:GetCaster())
end
function modifierCircleAuraClass:IsAura()
    return true
end
function modifierCircleAuraClass:GetModifierAura()
    return modifierCircleEffectName
end
function modifierCircleAuraClass:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifierCircleAuraClass:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end
function modifierCircleAuraClass:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end
function modifierCircleAuraClass:GetAuraRadius()
    return self:GetRadius(300)
end
function modifierCircleEffectClass:OnCreated()
    self.damage = 500
    self:SetSpecialTypes({
        MODIFIER_SPECIAL_TYPE_PREMITIGATION,
    })
    self:StartIntervalThink(0.5)
end
function modifierCircleEffectClass:OnAfterPremitigationReduce(data)
    if self:GetParent() ~= data.victim then
        return
    end
    if data.source ~= self:GetAbility() and not data.isAugmented then
        self.damage = self.damage or 0
        self.damage = math.max(data.damage, self.damage)
    end
end
function modifierCircleEffectClass:PlayEffectsStarfall()
    local target = self:GetParent()
    local particleName = "particles/units/heroes/hero_mirana/mirana_starfall_attack.vpcf"
    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
    ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    Timers:CreateTimer(0.6, function()
        ParticleManager:DestroyParticle(pfx, false)
    end)
end
function modifierCircleEffectClass:OnIntervalThink()
    if not self.damage then
        return
    end
    self:PlayEffectsStarfall()
    Timers:CreateTimer(0.45, function()
        Damage:Apply({
            attacker = self:GetCaster(),
            victim = self:GetParent(),
            damage = self.damage,
            damageType = DAMAGE_TYPE_PURE,
            maxPremitigationDamage = self.damage * 160,
            source = self:GetAbility(),
            sourceType = BASE_ITEM,
            elements = { RPC_ELEMENT_COSMOS },
            skipItemDamageEffectsApply = true,
            ignorePostmitigation = true,
            ignoreExtraPostmitigation = true,
            steadfastThresholdMult = 10,
            megaSteadfastThresholdMult = 30,
        })
    end)
end