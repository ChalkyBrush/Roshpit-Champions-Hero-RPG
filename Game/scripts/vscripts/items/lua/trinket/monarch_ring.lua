require('/items/lua/trinket/base_trinket')
require('/npc_abilities/base_modifier')

item_rpc_monarch_ring = class(BaseTrinket, nil, BaseTrinket)
local itemClass = item_rpc_monarch_ring
local itemClassName = 'item_rpc_monarch_ring'

modifier_monarch_ring = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_monarch_ring
local modifierName = 'modifier_monarch_ring'
LinkLuaModifier(modifierName, "/items/lua/trinket/monarch_ring", LUA_MODIFIER_MOTION_NONE)


function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'Neverlord Soul Ring'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_monarch_ring"
    self:SetSpecialValue("monarch_ring", "#36ff43")
end

function itemClass:RollProperty2(item_level) 
    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 25, tier2 = 50, tier3 = 75, tier4 = 100})
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, rune_type, 1.25) 
end

function itemClass:RollProperty3(item_level) 
    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 25, tier2 = 50, tier3 = 75, tier4 = 100})
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 3, item_level, rune_type, 1.25) 
end

function itemClass:RollProperty4(item_level) 
    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 25, tier2 = 50, tier3 = 75, tier4 = 100})
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 4, item_level, rune_type, 1.25) 
end

function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 0)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 3)
end

-- BASE MODIIFER 

function modifierClass:OnCreated()
    self:SetSpecialTypes({

    })
end
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
