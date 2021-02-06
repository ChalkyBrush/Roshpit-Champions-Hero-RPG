require('items/lua/gloves/base_glove')
require('npc_abilities/base_modifier')

item_rpc_world_commander_gloves = class(BaseGloves, nil, BaseGloves)
local itemClass = item_rpc_world_commander_gloves
local itemClassName = 'item_rpc_world_commander_gloves'

modifier_world_commander_gloves = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_world_commander_gloves
local modifierName = 'modifier_world_commander_gloves'
LinkLuaModifier(modifierName, "items/lua/gloves/world_commander_gloves", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end

function itemClass:GetName()
    return 'World Commander Gloves'
end

function itemClass:GetModifierName()
    return modifierName
end

function itemClass:HasRuneSlots()
    return true
end

function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_world_commander_gloves"
    self:SetSpecialValue("world_commander_gloves", "#999999")
end

function itemClass:RollProperty2(item_level)
    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 40, tier2 = 80, tier3 = 100})
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, rune_type, 1.5)
end

function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 2)
end

function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 1.5)
end


------------
--MODIFIER--
------------

function modifierClass:DeclareFunctions()
    local funcs = {

    }
    return funcs
end

function modifierClass:IsHidden()
	return true
end

function modifierClass:RemoveOnDeath()
	return false
end

function modifierClass:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
    	MODIFIER_ROSHPIT_MASTER_GREEN_DMG
    })

end

function modifierClass:GetRoshpitMasterGreenDMG()
	local hero = self:GetParent()
	local pierce = hero:GetRoshpitArmorPierce() + hero:GetRoshpitSpellPierce()
	local bonus = math.min(ITEM_RPC_WORLD_COMMANDER_GLOVES_DMG_PCT * pierce, ITEM_RPC_WORLD_COMMANDER_GLOVES_CAP)
	return bonus
end
