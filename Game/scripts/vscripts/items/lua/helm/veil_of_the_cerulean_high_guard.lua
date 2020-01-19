require('items/lua/helm/base')
require('npc_abilities/base_modifier')

item_rpc_veil_of_the_cerulean_high_guard = class(BaseHelm, nil, BaseHelm)
local itemClass = item_rpc_veil_of_the_cerulean_high_guard
local itemClassName = 'item_rpc_veil_of_the_cerulean_high_guard'

modifier_veil_of_the_cerulean_high_guard = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_veil_of_the_cerulean_high_guard
local modifierName = 'modifier_veil_of_the_cerulean_high_guard'
LinkLuaModifier(modifierName, "items/lua/helm/veil_of_the_cerulean_high_guard", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'Helm of the Iron Colossus'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:HasRuneSlots()
    return true
end
function itemClass:RollProperty1(maxFactor)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_veil_of_the_cerulean_high_guard"
    self:SetSpecialValue("veil_of_the_cerulean_high_guard", "#1D35D1")
end
function itemClass:RollProperty2(item_level)
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "all_attributes", 1.5)    
end

function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 0)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 2)
end

------------
--MODIFIER--
------------

function modifierClass:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_W_BASE_ABILITY_DMG_BONUS,
        MODIFIER_ROSHPIT_W_PCT_MANA_COST
    })
end

function modifierClass:GetRoshpitWPctManaCostModifier()
    return (CERULEAN_HIGHGUARD_MANA_INCREASE + self:GetAbility():GetFinalGemPropertyValue("amethyst", CERULEAN_HIGHGUARD_AMETHYST2)) / 100
end

function modifierClass:GetRoshpitWBaseAbilityDmgBonus(event)
    return (CERULEAN_HIGHGUARD_BAD + self:GetAbility():GetFinalGemPropertyValue("amethyst", CERULEAN_HIGHGUARD_AMETHYST1)) / 100
end

function modifierClass:IsHidden()
    return true
end

function modifierClass:RemoveOnDeath()
    return false
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