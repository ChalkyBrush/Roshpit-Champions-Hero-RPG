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
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "t1_rune", 2)
end
function class:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 1)
end
function class:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 1)
end

function modifierClass:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_Q_BASE_ABILITY_DMG_BONUS,
        MODIFIER_ROSHPIT_W_BASE_ABILITY_DMG_BONUS,
        MODIFIER_ROSHPIT_E_BASE_ABILITY_DMG_BONUS,
        MODIFIER_ROSHPIT_R_BASE_ABILITY_DMG_BONUS,
        MODIFIER_ROSHPIT_ARMOR_PIERCE_BONUS,
        MODIFIER_ROSHPIT_SPELL_PIERCE_BONUS 
    })
end
function modifierClass:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }

    return funcs
end

function modifierClass:GetRoshpitQBaseAbilityDmgBonus()
    if not IsServer() then
        return
    end
    local boots = self:GetAbility()
    if boots:GetGemValue("emerald") > 0 then
        return boots:GetFinalGemPropertyValue("emerald", ITEM_RPC_REDFALL_RUNNERS_GEM_EMERALD) / 100 * self:GetParent():GetActualMovespeed()
    else
        return 0
    end
end
function modifierClass:GetRoshpitWBaseAbilityDmgBonus()
    if not IsServer() then
        return
    end
    local boots = self:GetAbility()
    if boots:GetGemValue("emerald") > 0 then
        return boots:GetFinalGemPropertyValue("emerald", ITEM_RPC_REDFALL_RUNNERS_GEM_EMERALD) / 100 * self:GetParent():GetActualMovespeed()
    else
        return 0
    end
end
function modifierClass:GetRoshpitEBaseAbilityDmgBonus()
    if not IsServer() then
        return
    end
    local boots = self:GetAbility()
    if boots:GetGemValue("emerald") > 0 then
        return boots:GetFinalGemPropertyValue("emerald", ITEM_RPC_REDFALL_RUNNERS_GEM_EMERALD) / 100 * self:GetParent():GetActualMovespeed()
    else
        return 0
    end
end
function modifierClass:GetRoshpitRBaseAbilityDmgBonus()
    if not IsServer() then
        return
    end
    local boots = self:GetAbility()
    if boots:GetGemValue("emerald") > 0 then
        return boots:GetFinalGemPropertyValue("emerald", ITEM_RPC_REDFALL_RUNNERS_GEM_EMERALD) / 100 * self:GetParent():GetActualMovespeed()
    else
        return 0
    end
end

function modifierClass:GetRoshpitArmorPierceBonus(params)
    if not IsServer() then
        return
    end
    local boots = self:GetAbility()
    if boots:GetGemValue("sapphire") > 0 then
        return boots:GetFinalGemPropertyValue("sapphire", ITEM_RPC_REDFALL_RUNNERS_GEM_SAPPHIRE)*self:GetParent():GetActualMovespeed()
    else
        return 0
    end
end

function modifierClass:GetRoshpitSpellPierceBonus(params)
    if not IsServer() then
        return
    end
    local boots = self:GetAbility()
    if boots:GetGemValue("sapphire") > 0 then
        return boots:GetFinalGemPropertyValue("sapphire", ITEM_RPC_REDFALL_RUNNERS_GEM_SAPPHIRE)*self:GetParent():GetActualMovespeed()
    else
        return 0
    end
end

function modifierClass:GetModifierMoveSpeed_Max_Increase(params)
    if not IsServer() then
        return
    end
    local caster = self:GetParent()
    local movespeed_max = ITEM_RPC_REDFALL_RUNNERS_MAX_MS_PER_AGI_AND_SPR*(caster:GetAgility() + caster:GetSpirit())
    if caster:GetHealth() == caster:GetMaxHealth() then
        movespeed_max = movespeed_max + self:GetAbility():GetFinalGemPropertyValue("ruby", ITEM_RPC_REDFALL_RUNNERS_GEM_RUBY)
    end
    return movespeed_max
end

function modifierClass:GetModifierMoveSpeedBonus_Constant(params)
    if not IsServer() then
        return
    end
    local caster = self:GetParent()
    local movespeed = ITEM_RPC_REDFALL_RUNNERS_MS_PER_AGI_AND_SPR*(caster:GetAgility() + caster:GetSpirit())
    if caster:GetHealth() == caster:GetMaxHealth() then
        movespeed = movespeed + self:GetAbility():GetFinalGemPropertyValue("ruby", ITEM_RPC_REDFALL_RUNNERS_GEM_RUBY)
    end
    return movespeed
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