require('items/lua/foot/base')
require('npc_abilities/base_modifier')

item_rpc_iron_treads_of_destruction = class(BaseFoot, nil, BaseFoot)
modifier_iron_treads_of_destruction = class(npc_base_modifier, nil, npc_base_modifier)
local itemClass = item_rpc_iron_treads_of_destruction
local itemClassName = 'item_rpc_iron_treads_of_destruction'

local modifierClass = modifier_iron_treads_of_destruction
local modifierName = 'modifier_iron_treads_of_destruction'
LinkLuaModifier(modifierName, "items/lua/foot/iron_treads_of_destruction", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'Iron Treads of Destruction'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:HasRuneSlots()
    return true
end
function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_iron_treads_of_destruction"
    self:SetSpecialValue("iron_treads_of_destruction", "#4259F4")
end
function itemClass:RollProperty2(item_level)
    local rune_type = RPCItems:RollRuneType({"r"}, {tier1 = 35, tier2 = 70, tier3 = 90, tier4 = 100})
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, rune_type, 1.5)
end
function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 2.75)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 0.75)
end
function modifierClass:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_R_PCT_CD_MOD,
        MODIFIER_ROSHPIT_R_BASE_ABILITY_DMG_BONUS,
        MODIFIER_ROSHPIT_STRENGTH_BONUS,
        MODIFIER_ROSHPIT_AGILITY_BONUS,
        MODIFIER_ROSHPIT_INTELLIGENCE_BONUS,
        MODIFIER_ROSHPIT_SPIRIT_BONUS,
        MODIFIER_ROSHPIT_R_PCT_CHANNELTIME_MOD
    })
end
function modifierClass:DeclareFunctions()
    local funcs = {
    }
    return funcs
end

function modifierClass:GetRoshpitRPctCdModifier()
    return - self:GetAbility():GetFinalGemPropertyValue("amethyst", ITEM_RPC_IRON_TREADS_OF_DESTRUCTION_GEM_AMETHYST) / 100
end
function modifierClass:GetRoshpitRBaseAbilityDmgBonus()
    return self:GetAbility():GetFinalGemPropertyValue("ruby", ITEM_RPC_IRON_TREADS_OF_DESTRUCTION_GEM_RUBY) / 100
end
function modifierClass:GetRoshpitStrengthBonus()
    return self:GetAbility():GetFinalGemPropertyValue("sapphire", ITEM_RPC_IRON_TREADS_OF_DESTRUCTION_GEM_SAPPHIRE)
end
function modifierClass:GetRoshpitAgilityBonus()
    return self:GetAbility():GetFinalGemPropertyValue("sapphire", ITEM_RPC_IRON_TREADS_OF_DESTRUCTION_GEM_SAPPHIRE)
end
function modifierClass:GetRoshpitIntelligenceBonus()
    return self:GetAbility():GetFinalGemPropertyValue("sapphire", ITEM_RPC_IRON_TREADS_OF_DESTRUCTION_GEM_SAPPHIRE)
end
function modifierClass:GetRoshpitSpiritBonus()
    return self:GetAbility():GetFinalGemPropertyValue("sapphire", ITEM_RPC_IRON_TREADS_OF_DESTRUCTION_GEM_SAPPHIRE)
end
function modifierClass:GetRoshpitRPctChanneltimeModifier()
    return - ITEM_RPC_IRON_TREADS_OF_DESTRUCTION_PCT_CHANNELTIME_MOD
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
    return "itemicons/iron_treads_of_destruction"
end