require('items/lua/helm/base')
require('npc_abilities/base_modifier')

item_rpc_mask_of_the_phantom_sorcerer = class(BaseHelm, nil, BaseHelm)
local itemClass = item_rpc_mask_of_the_phantom_sorcerer
local itemClassName = 'item_rpc_mask_of_the_phantom_sorcerer'

modifier_mask_of_the_phantom_sorcerer = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_mask_of_the_phantom_sorcerer
local modifierName = 'modifier_mask_of_the_phantom_sorcerer'
LinkLuaModifier(modifierName, "items/lua/helm/mask_of_the_phantom_sorcerer", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'Mask of the Phantom Sorcerer'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:HasRuneSlots()
    return true
end
function itemClass:RollProperty1(maxFactor)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_mask_of_the_phantom_sorcerer"
    self:SetSpecialValue("mask_of_the_phantom_sorcerer", "#02F21E")
end
function itemClass:RollProperty2(item_level) 
    local luck = RandomInt(1, 7)
    if luck < 7 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, rune_type, 1.5)
    else
        RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "t3_rune", 1)
    end
end

function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 0)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 2.5)
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
        MODIFIER_ROSHPIT_W_FLAT_CD_MOD
    })
end

function modifierClass:GetRoshpitWFlatCdModifier()
    return PHANTOM_SORCERER_CD_INCREASE + self:GetAbility():GetFinalGemPropertyValue("ruby", PHANTOM_SORCERER_RUBY2)
end

function modifierClass:GetRoshpitWBaseAbilityDmgBonus(event)
    return (PHANTOM_SORCERER_BAD + self:GetAbility():GetFinalGemPropertyValue("ruby", PHANTOM_SORCERER_RUBY1)) / 100
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