require('items/lua/body/base')
require('npc_abilities/base_modifier')

item_rpc_armor_of_the_violet_guard = class(BaseBody, nil, BaseBody)
local itemClass = item_rpc_armor_of_the_violet_guard
local itemClassName = 'item_rpc_armor_of_the_violet_guard'

modifier_armor_of_the_violet_guard = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_armor_of_the_violet_guard
local modifierName = 'modifier_armor_of_the_violet_guard'
LinkLuaModifier(modifierName, "items/lua/body/armor_of_the_violet_guard", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'Whatever the fuck this is for'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:HasRuneSlots()
    return true
end
function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_armor_of_the_violet_guard"
    self:SetSpecialValue("armor_of_the_violet_guard", "#A337E6")
end
function itemClass:RollProperty2(item_level)
     local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
     RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, rune_type, 1.5)
end
function itemClass:RollProperty3(item_level)
     RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 3, item_level, "agility", 1.5)
end

function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 1.5)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 1.5)
end


function modifierClass:DeclareFunctions()
    local funcs = {
    }
    return funcs
end
function modifierClass:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_Q_PCT_CD_MOD,
        MODIFIER_ROSHPIT_AGILITY_BONUS,
        MODIFIER_ROSHPIT_Q_BASE_ABILITY_DMG_BONUS,
        MODIFIER_ROSHPIT_ARMOR_PIERCE_BONUS,
        MODIFIER_SPECIAL_TYPE_ON_HIT_Q_ABILITY
    })
end
function modifierClass:OnHitQAbility(data)
    if IsServer() then
        DeepPrintTable(data)
        local hero = data.attacker
        local violet_guard = self:GetAbility()
        local victim = data.victim
        if violet_guard:GetGemValue("ruby") > 0 then
            victim:AddNewModifier(hero.InventoryUnit, violet_guard, "modifier_armor_of_the_violet_guard_ruby_debuff", {duration = ITEM_RPC_ARMOR_OF_VIOLET_GUARD_ARMOR_LOSS_DURATION})
        end
    end
end

function modifierClass:GetRoshpitQPctCdModifier()
    return - ITEM_RPC_ARMOR_OF_VIOLET_GUARD_Q_CD_REDUCE
end

function modifierClass:GetRoshpitArmorPierceBonus(params)
    return self:GetAbility():GetFinalGemPropertyValue("sapphire", ITEM_RPC_ARMOR_OF_VIOLET_GUARD_GEM_SAPPHIRE)
end

function modifierClass:GetRoshpitQBaseAbilityDmgBonus()
    return self:GetAbility():GetFinalGemPropertyValue("amethyst", ITEM_RPC_ARMOR_OF_VIOLET_GUARD_GEM_AMETHYST) / 100
end

function modifierClass:GetRoshpitAgilityBonus()
    return self:GetAbility():GetFinalGemPropertyValue("emerald", ITEM_RPC_ARMOR_OF_VIOLET_GUARD_GEM_EMERALD)
end

modifier_armor_of_the_violet_guard_ruby_debuff = class(npc_base_modifier, nil, npc_base_modifier)
local debuffModifierClass = modifier_armor_of_the_violet_guard_ruby_debuff
local debuffModifierName = 'modifier_armor_of_the_violet_guard_ruby_debuff'
LinkLuaModifier(debuffModifierName, "items/lua/body/armor_of_the_violet_guard", LUA_MODIFIER_MOTION_NONE)

function debuffModifierClass:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_ARMOR_BONUS
    })
end
function debuffModifierClass:GetRoshpitArmorBonus()
    return self:GetAbility():GetFinalGemPropertyValue("ruby", ITEM_RPC_ARMOR_OF_VIOLET_GUARD_GEM_RUBY)
end
function debuffModifierClass:IsDebuff()
    return true
end
function debuffModifierClass:GetTexture()
    return "itemicons/violet_guard_armor_loss"
end