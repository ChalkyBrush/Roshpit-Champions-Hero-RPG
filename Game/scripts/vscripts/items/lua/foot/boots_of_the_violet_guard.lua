require('items/lua/foot/base')
require('npc_abilities/base_modifier')

item_rpc_boots_of_the_violet_guard = class(BaseFoot, nil, BaseFoot)
modifier_boots_of_the_violet_guard = class(npc_base_modifier, nil, npc_base_modifier)
local class = item_rpc_boots_of_the_violet_guard
local className = 'item_rpc_boots_of_the_violet_guard'

local modifierClass = modifier_boots_of_the_violet_guard
local modifierName = 'modifier_boots_of_the_violet_guard'
LinkLuaModifier(modifierName, "items/lua/foot/boots_of_the_violet_guard", LUA_MODIFIER_MOTION_NONE)

function class:GetClassName()
    return className
end
function class:GetName()
    return 'boots_of_the_violet_guard'
end
function class:GetModifierName()
    return modifierName
end
function class:HasRuneSlots()
    return true
end
function class:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_boots_of_the_violet_guard"
    self:SetSpecialValue("boots_of_the_violet_guard", "#A337E6")
end
function class:RollProperty2(item_level)
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "agility", 2.0)
end
function class:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 1.25)
end
function class:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 2.25)
end
function modifierClass:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_R_PCT_CD_MOD,
        MODIFIER_ROSHPIT_ARMOR_PIERCE_BONUS,
        MODIFIER_ROSHPIT_AGILITY_BONUS,
        MODIFIER_ROSHPIT_R_BASE_ABILITY_DMG_BONUS
    })
end
function modifierClass:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        --MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
    return funcs
end


function modifierClass:GetRoshpitArmorPierceBonus(params)
    return self:GetAbility():GetFinalGemPropertyValue("sapphire", ITEM_RPC_BOOTS_OF_THE_VIOLET_GUARD_GEM_SAPPHIRE)
end

function modifierClass:GetRoshpitRBaseAbilityDmgBonus()
    return self:GetAbility():GetFinalGemPropertyValue("amethyst", ITEM_RPC_BOOTS_OF_THE_VIOLET_GUARD_GEM_AMETHYST) / 100
end

function modifierClass:GetRoshpitAgilityBonus()
    return self:GetAbility():GetFinalGemPropertyValue("emerald", ITEM_RPC_BOOTS_OF_THE_VIOLET_GUARD_GEM_EMERALD)
end

--Done in equip_gear.lua else it wouldnt show in UI
-- function modifierClass:GetModifierAttackSpeedBonus_Constant(params)
--     if IsServer() then
--         return self:GetAbility():GetFinalGemPropertyValue("ruby", ITEM_RPC_BOOTS_OF_THE_VIOLET_GUARD_GEM_RUBY2)
--     end
-- end
function modifierClass:GetModifierMoveSpeedBonus_Constant(params)
    if IsServer() then
        return self:GetAbility():GetFinalGemPropertyValue("ruby", ITEM_RPC_BOOTS_OF_THE_VIOLET_GUARD_GEM_RUBY1)
    end
end

function modifierClass:GetRoshpitRPctCdModifier()
    return - ITEM_RPC_BOOTS_OF_THE_VIOLET_GUARD_R_CD_REDUCE_PCT
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
    return "itemicons/boots_of_the_violet_guard"
end