require('items/lua/foot/base')
require('npc_abilities/base_modifier')

------------------------------------------------
--------- NOT USED YET!!!!!!!!------------------
------------------------------------------------

item_rpc_bloodstone_boots = class(BaseFoot, nil, BaseFoot)
modifier_bloodstone_boots = class(npc_base_modifier, nil, npc_base_modifier)
local class = item_rpc_bloodstone_boots
local className = 'item_rpc_bloodstone_boots'

local modifierClass = modifier_bloodstone_boots
local modifierName = 'modifier_bloodstone_boots'
LinkLuaModifier(modifierName, "items/lua/foot/bloodstone_boots", LUA_MODIFIER_MOTION_NONE)

function class:GetClassName()
    return className
end
function class:GetName()
    return 'bloodstone_boots'
end
function class:GetModifierName()
    return modifierName
end
function class:HasRuneSlots()
    return true
end
function class:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_bloodstone_boots"
    self:SetSpecialValue("bloodstone_boots", "#E2371D")
end
function class:RollProperty2(item_level)
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "max_health", 2)
end
function class:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 1)
end
function class:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 1.75)
end
function modifierClass:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_E_FLAT_CD_MOD,
        MODIFIER_ROSHPIT_ARMOR_PIERCE_BONUS,
        MODIFIER_ROSHPIT_ARMOR_BONUS,
        MODIFIER_ROSHPIT_MAGIC_ARMOR_BONUS,
        MODIFIER_SPECIAL_TYPE_CAST_E_ABILITY
    })
end
function modifierClass:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }
    return funcs
end


function modifierClass:GetRoshpitArmorPierceBonus(params)
    local hero = self:GetParent()
    if hero:GetAbilityByIndex(DOTA_E_SLOT):IsCooldownReady() then
        return hero.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetFinalGemPropertyValue("emerald", ITEM_RPC_bloodstone_boots_GEM_EMERALD)
    end
    return 0
end
function modifierClass:OnCastEAbility()
    local hero = self:GetParent()
    local bloodstone_boots = self:GetAbility()
    if bloodstone_boots:GetGemValue("ruby") > 0 then
        local proc = Filters:GetProc(hero, bloodstone_boots:GetFinalGemPropertyValue("ruby", ITEM_RPC_bloodstone_boots_GEM_RUBY))
        if proc then
            hero:GetAbilityByIndex(DOTA_E_SLOT):EndCooldown()
            CustomAbilities:QuickAttachParticle("particles/econ/items/monkey_king/arcana/water/monkey_king_spring_cast_water_spiral.vpcf", hero, 3)
        end
    end
end

function modifierClass:GetRoshpitArmorBonus()
    local hero = self:GetParent()
    return self:GetAbility():GetFinalGemPropertyValue("amethyst", ITEM_RPC_bloodstone_boots_GEM_AMETHYST) * hero:GetAgility()
end

function modifierClass:GetRoshpitMagicArmorBonus()
    local hero = self:GetParent()
    return self:GetAbility():GetFinalGemPropertyValue("amethyst", ITEM_RPC_bloodstone_boots_GEM_AMETHYST) * hero:GetAgility()
end

function modifierClass:GetModifierMoveSpeedBonus_Constant(params)
    if IsServer() then
        local hero = self:GetParent()
        if hero:GetAbilityByIndex(DOTA_E_SLOT):IsCooldownReady() then
            return self:GetAbility():GetFinalGemPropertyValue("sapphire", ITEM_RPC_bloodstone_boots_GEM_SAPPHIRE)
        end
        return 0
    end
end

function modifierClass:GetModifierMoveSpeed_Max_Increase(params)
    if IsServer() then
        local hero = self:GetParent()
        if hero:GetAbilityByIndex(DOTA_E_SLOT):IsCooldownReady() then
            return self:GetAbility():GetFinalGemPropertyValue("sapphire", ITEM_RPC_bloodstone_boots_GEM_SAPPHIRE)
        end
        return 0
    end
end
function modifierClass:GetRoshpitEFlatCdModifier()
    return - ITEM_RPC_bloodstone_boots_CD_RED
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

function modifierClass:GetTexture()
    return "itemicons/bloodstone_boots"
end