require('items/lua/foot/base')
require('npc_abilities/base_modifier')

item_rpc_redfall_runners = class(BaseFoot, nil, BaseFoot)
modifier_redfall_runners = class(npc_base_modifier, nil, npc_base_modifier)
local class = item_rpc_redfall_runners
local className = 'item_rpc_redfall_runners'

local modifierClass = modifier_redfall_runners
local modifierName = 'modifier_redfall_runners'
LinkLuaModifier(modifierName, "items/lua/foot/redfall_runners", LUA_MODIFIER_MOTION_NONE)

function class:GetClassName()
    return className
end
function class:GetName()
    return 'Whatever the fuck this is for'
end
function class:GetModifierName()
    return modifierName
end
function class:HasRuneSlots()
    return true
end
function class:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_redfall_runners"
    self:SetSpecialValue("redfall_runners", "#E87B7B")
end
function class:RollProperty2(item_level)
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "t1_rune", 1.5)
end
function class:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 1)
end
function class:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 1)
end
function modifierClass:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }

    return funcs
end
function modifierClass:GetModifierMoveSpeed_Max_Increase(params)
    if not IsServer() then
        return
    end
    local caster = self:GetCaster()
    local missingHealthPercent = (1 - caster:GetHealth() / caster:GetMaxHealth()) * 100
    return missingHealthPercent * REDFALL_RUNNERS_MAX_MS_PER_HP_PCT_MISSING
end

function modifierClass:GetModifierMoveSpeedBonus_Constant(params)
    if not IsServer() then
        return
    end
    local caster = self:GetCaster()
    local missingHealthPercent = (1 - caster:GetHealth() / caster:GetMaxHealth()) * 100
    return missingHealthPercent * REDFALL_RUNNERS_MS_PER_HP_PCT_MISSING
end

function modifierClass:IsHidden()
    return false
end

function modifierClass:IsBuff()
    return true
end

function modifierClass:RemoveOnDeath()
    return false
end

function modifierClass:GetTexture()
    return "itemicons/redfall_runners"
end