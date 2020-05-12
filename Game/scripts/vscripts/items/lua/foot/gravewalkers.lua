require('items/lua/foot/base_boot')
require('npc_abilities/base_modifier')

item_rpc_gravewalkers = class(BaseFoot, nil, BaseFoot)

local itemClass = item_rpc_gravewalkers
local itemClassName = 'item_rpc_gravewalkers'

modifier_gravewalkers = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_gravewalkers
local modifierName = 'modifier_gravewalkers'
LinkLuaModifier(modifierName, "items/lua/foot/gravewalkers", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'Gravewalkers'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:HasRuneSlots()
    return true
end
function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_gravewalkers"
    self:SetSpecialValue("gravewalkers", "#61fcff")
end
function itemClass:RollProperty2(item_level)
    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 40, tier2 = 80, tier3 = 100})
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, rune_type, 1.5)
end
function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 1.75)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 1.75)
end

-- MODIFIER

function modifierClass:IsHidden()
	return true
end

function modifierClass:RemoveOnDeath()
	return false
end

function modifierClass:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({ 

    })	

end

