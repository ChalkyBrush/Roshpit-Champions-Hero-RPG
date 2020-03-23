require('items/lua/foot/base')
require('npc_abilities/base_modifier')

item_rpc_swamp_waders = class(BaseFoot, nil, BaseFoot)
local itemClass = item_rpc_swamp_waders
local itemClassName = 'item_rpc_swamp_waders'

modifier_swamp_waders = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_swamp_waders
local modifierName = 'modifier_swamp_waders'
LinkLuaModifier(modifierName, "items/lua/foot/swamp_waders", LUA_MODIFIER_MOTION_NONE)

modifier_swamp_waders_emerald_poison_aura = class(npc_base_modifier, nil, npc_base_modifier)
local auraModifierClass = modifier_swamp_waders_emerald_poison_aura
local auraModifierName = 'modifier_swamp_waders_emerald_poison_aura'
LinkLuaModifier(auraModifierName, "items/lua/foot/swamp_waders", LUA_MODIFIER_MOTION_NONE)

modifier_swamp_waders_emerald_poison_cloud = class(npc_base_modifier, nil, npc_base_modifier)
local cloudModifierClass = modifier_swamp_waders_emerald_poison_cloud
local cloudModifierName = 'modifier_swamp_waders_emerald_poison_cloud'
LinkLuaModifier(cloudModifierName, "items/lua/foot/swamp_waders", LUA_MODIFIER_MOTION_NONE)

modifier_swamp_waders_emerald_poison_cloud_slow = class(npc_base_modifier, nil, npc_base_modifier)
local slowModifierClass = modifier_swamp_waders_emerald_poison_cloud_slow
local slowModifierName = 'modifier_swamp_waders_emerald_poison_cloud_slow'
LinkLuaModifier(slowModifierName, "items/lua/foot/swamp_waders", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'swamp_waders'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:HasRuneSlots()
    return true
end
function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_swamp_waders"
    self:SetSpecialValue("swamp_waders", "#658337")
end
function itemClass:RollProperty2(item_level)
    local luck = RandomInt(1, 2)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "armor", 2)
    else
        RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "magic_armor", 2)
    end
end
function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 1)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 1.25)
end
function modifierClass:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_ARMOR_BONUS,
        MODIFIER_ROSHPIT_MAGIC_ARMOR_BONUS,
        MODIFIER_ROSHPIT_ARMOR_PIERCE_BONUS,
        MODIFIER_ROSHPIT_SPELL_PIERCE_BONUS,
        MODIFIER_ROSHPIT_E_PCT_CD_MOD,
        MODIFIER_ROSHPIT_E_BASE_ABILITY_DMG_BONUS
    })
    self:StartIntervalThink(0.2)
end
function modifierClass:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }
    return funcs
end


function modifierClass:GetRoshpitArmorPierceBonus(params)
    local hero = self:GetParent()
    local pierceBonus = self:GetAbility():GetFinalGemPropertyValue("amethyst", ITEM_RPC_SWAMP_WADERS_GEM_AMETHYST1)
    local pierceMalus = hero:GetActualMovespeed() * self:GetAbility():GetFinalGemPropertyValue("amethyst", ITEM_RPC_SWAMP_WADERS_GEM_AMETHYST2)
    pierceMalus = math.min(pierceBonus, pierceMalus)
    return pierceBonus - pierceMalus
end
function modifierClass:GetRoshpitSpellPierceBonus(params)
    local hero = self:GetParent()
    local pierceBonus = self:GetAbility():GetFinalGemPropertyValue("amethyst", ITEM_RPC_SWAMP_WADERS_GEM_AMETHYST1)
    local pierceMalus = hero:GetActualMovespeed() * self:GetAbility():GetFinalGemPropertyValue("amethyst", ITEM_RPC_SWAMP_WADERS_GEM_AMETHYST2)
    pierceMalus = math.min(pierceBonus, pierceMalus)
    return pierceBonus - pierceMalus
end
function modifierClass:GetRoshpitArmorBonus()
    local hero = self:GetParent()
    local armorBonus = self:GetAbility():GetFinalGemPropertyValue("ruby", ITEM_RPC_SWAMP_WADERS_GEM_RUBY1)
    local armorMalus = hero:GetActualMovespeed() * self:GetAbility():GetFinalGemPropertyValue("ruby", ITEM_RPC_SWAMP_WADERS_GEM_RUBY2)
    armorMalus = math.min(armorBonus, armorMalus)
    return armorBonus - armorMalus
end
function modifierClass:GetRoshpitMagicArmorBonus()
    local hero = self:GetParent()
    local armorBonus = self:GetAbility():GetFinalGemPropertyValue("ruby", ITEM_RPC_SWAMP_WADERS_GEM_RUBY1)
    local armorMalus = hero:GetActualMovespeed() * self:GetAbility():GetFinalGemPropertyValue("ruby", ITEM_RPC_SWAMP_WADERS_GEM_RUBY2)
    armorMalus = math.min(armorBonus, armorMalus)
    return armorBonus - armorMalus
end

function modifierClass:GetModifierMoveSpeedBonus_Constant(params)
    if IsServer() then
        return - ITEM_RPC_SWAMP_WADERS_MOVESPEED_LOSS
    end
end
function modifierClass:GetRoshpitEPctCdModifier()
    if self:GetAbility():GetGemValue("sapphire") > 0 then
        return ITEM_RPC_SWAMP_WADERS_SAPPHIRE_CD_INCREASE / 100
    end
end
function modifierClass:OnIntervalThink()
    if IsServer() then
        local hero = self:GetParent()
        local ability = self:GetAbility()
        local caster = self:GetCaster()
        if ability:GetGemValue("emerald") > 0 then
            if not ability.lastPos then
                ability.lastPos = hero:GetAbsOrigin()
            end
            if not ability.distanceMoved then
                ability.distanceMoved = 0
            end
            ability.newPos = hero:GetAbsOrigin()
            local distance = WallPhysics:GetDistance2d(ability.newPos, ability.lastPos)
            ability.distanceMoved = ability.distanceMoved + distance
            if ability.distanceMoved > ITEM_RPC_SWAMP_WADERS_EMERALD_TRAVEL_DISTANCE then
                swamp_waders_poison_cloud(caster, ability, hero)
                ability.distanceMoved = ability.distanceMoved % ITEM_RPC_SWAMP_WADERS_EMERALD_TRAVEL_DISTANCE
            end
            ability.lastPos = hero:GetAbsOrigin()
        end
    end
end

function swamp_waders_poison_cloud(caster, ability, hero)
	local radius = ITEM_RPC_SWAMP_WADERS_EMERALD_RADIUS
    local poison_thinker = CreateUnitByName("npc_dummy_unit", hero:GetAbsOrigin(), false, nil, nil, hero:GetTeamNumber())
    poison_thinker:FindAbilityByName("dummy_unit"):SetLevel(1)
    
    poison_thinker:SetDayTimeVisionRange(0)
    poison_thinker:SetNightTimeVisionRange(0)

    local pfx = ParticleManager:CreateParticle("particles/roshpit/items/swamp_waders_emerald.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(pfx, 0, poison_thinker:GetAbsOrigin())
    ParticleManager:SetParticleControl(pfx, 1, Vector(radius*1.5, 2, 2))
    ParticleManager:SetParticleControl(pfx, 15, Vector(255, 255, 255))
    ParticleManager:SetParticleControl(pfx, 16, Vector(1, 0, 0))
    poison_thinker.pfx = pfx
    poison_thinker:AddNewModifier(caster, ability, "modifier_swamp_waders_emerald_poison_aura", {duration = ITEM_RPC_SWAMP_WADERS_EMERALD_DURATION})	
end

function modifierClass:GetRoshpitEBaseAbilityDmgBonus()
    return self:GetAbility():GetFinalGemPropertyValue("sapphire", ITEM_RPC_SWAMP_WADERS_GEM_SAPPHIRE)/100
end

function modifierClass:IsHidden()
    return true
end
function modifierClass:IsBuff()
    return true
end

function modifierClass:RemoveOnDeath()
    return false
end


function modifier_swamp_waders_emerald_poison_aura:IsAura()
    return true
end
function modifier_swamp_waders_emerald_poison_aura:IsHidden()
    return true
end
function modifier_swamp_waders_emerald_poison_aura:GetModifierAura()
    return cloudModifierName
end
function modifier_swamp_waders_emerald_poison_aura:GetAuraRadius()
    return ITEM_RPC_SWAMP_WADERS_EMERALD_RADIUS
end
function modifier_swamp_waders_emerald_poison_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_swamp_waders_emerald_poison_aura:GetAuraSearchType()
    return (DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC)
end
function modifier_swamp_waders_emerald_poison_aura:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_swamp_waders_emerald_poison_aura:OnRemoved()
    if IsServer() then
        local target = self:GetParent()
        if target.pfx then
            ParticleManager:DestroyParticle(target.pfx, false)
            ParticleManager:ReleaseParticleIndex(target.pfx)
        end
        UTIL_Remove(target)
    end
end


function modifier_swamp_waders_emerald_poison_cloud:IsDebuff()
    return true
end
function modifier_swamp_waders_emerald_poison_cloud:OnCreated()
    if IsServer() then
        self:StartIntervalThink(ITEM_RPC_SWAMP_WADERS_EMERALD_THINK_INTERVAL)
        local caster = self:GetCaster()
        local ability = self:GetAbility()
        local hero = caster.hero
        local target = self:GetParent()
        local slow_amount = ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_SWAMP_WADERS_GEM_EMERALD1)
        target:AddNewModifier(caster, ability, "modifier_swamp_waders_emerald_poison_cloud_slow", {})
        target:SetModifierStackCount("modifier_swamp_waders_emerald_poison_cloud_slow", caster, slow_amount)
    end
end
function modifier_swamp_waders_emerald_poison_cloud:OnIntervalThink()
    if IsServer() then
        local caster = self:GetCaster()
        local ability = self:GetAbility()
        local hero = caster.hero
        local target = self:GetParent()
        local damage = OverflowProtectedGetAverageTrueAttackDamage(hero)*ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_SWAMP_WADERS_GEM_EMERALD2)/100
        Filters:ApplyItemDamage(target, hero, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_POISON, RPC_ELEMENT_NONE)
    end
end
function modifier_swamp_waders_emerald_poison_cloud:OnDestroy()
    if IsServer() then
        local target = self:GetParent()
        target:RemoveModifierByName("modifier_swamp_waders_emerald_poison_cloud_slow")
    end
end

function modifier_swamp_waders_emerald_poison_cloud_slow:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
    return funcs
end
function modifier_swamp_waders_emerald_poison_cloud_slow:GetModifierMoveSpeedBonus_Percentage()
    return - self:GetStackCount()
end
function modifier_swamp_waders_emerald_poison_cloud_slow:IsDebuff()
    return true
end
function modifier_swamp_waders_emerald_poison_cloud_slow:IsHidden()
    return true
end