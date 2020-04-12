require('items/lua/helm/base_helm')
require('npc_abilities/base_modifier')

item_rpc_hood_of_lords = class(BaseHelm, nil, BaseHelm)
local itemClass = item_rpc_hood_of_lords
local itemClassName = 'item_rpc_hood_of_lords'

modifier_hood_of_lords = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_hood_of_lords
local modifierName = 'modifier_hood_of_lords'
LinkLuaModifier(modifierName, "items/lua/helm/hood_of_lords", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'Hood of Lords'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:HasRuneSlots()
    return true
end
function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_hood_of_lords"
    self:SetSpecialValue("hood_of_lords", "#FEFFC6")
end
function itemClass:RollProperty2(item_level)
    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier3 = 80, tier4 = 100})
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, rune_type, 1.2)
end

function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 1.25)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 1.25)
end

------------
--MODIFIER--
------------

function modifierClass:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_Q_FLAT_CD_MOD,
        MODIFIER_ROSHPIT_W_FLAT_CD_MOD,
        MODIFIER_ROSHPIT_E_FLAT_CD_MOD,
        MODIFIER_ROSHPIT_R_FLAT_CD_MOD
    })
end
function modifierClass:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
        MODIFIER_PROPERTY_CAST_RANGE_BONUS
    }

    return funcs
end

function modifierClass:GetModifierIgnoreCastAngle(params)
    return 100
end
function modifierClass:GetModifierCastRangeBonus()
    return HOOD_OF_LORDS_BONUS_RANGE
end
function modifierClass:GetRoshpitQFlatCdModifier()
    return - HOOD_OF_LORDS_CD_MOD
end
function modifierClass:GetRoshpitWFlatCdModifier()
    return - HOOD_OF_LORDS_CD_MOD
end
function modifierClass:GetRoshpitEFlatCdModifier()
    return - HOOD_OF_LORDS_CD_MOD
end
function modifierClass:GetRoshpitRFlatCdModifier()
    return - HOOD_OF_LORDS_CD_MOD
end
function modifierClass:IsHidden()
    return true
end
function modifierClass:RemoveOnDeath()
    return false
end
function modifierClass:IsBuff()
    return true
end
function modifierClass:RemoveOnDeath()
    return false
end