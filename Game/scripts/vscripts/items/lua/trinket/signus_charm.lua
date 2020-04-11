require('/items/lua/trinket/base')
require('/npc_abilities/base_modifier')

item_rpc_signus_charm = class(BaseTrinket, nil, BaseTrinket)
local itemClass = item_rpc_signus_charm
local itemClassName = 'item_rpc_signus_charm'

modifier_signus_charm = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_signus_charm
local modifierName = 'modifier_signus_charm'
LinkLuaModifier(modifierName, "/items/lua/trinket/signus_charm", LUA_MODIFIER_MOTION_NONE)

modifier_signus_charm_amethyst_buff = class(npc_base_modifier, nil, npc_base_modifier)
local buffModifierClass = modifier_signus_charm_amethyst_buff
local buffModifierName = 'modifier_signus_charm_amethyst_buff'
LinkLuaModifier(buffModifierName, "/items/lua/trinket/signus_charm", LUA_MODIFIER_MOTION_NONE)

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
    self.newItemTable.property1name = "!immortal!_modifier_signus_charm"
    self:SetSpecialValue("signus_charm", ITEM_RPC_SIGNUS_CHARM_COLOR)
end
function itemClass:RollProperty2(item_level) 
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "all_attributes", 1.5)  
end
function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 0)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 2.25)
end
function modifierClass:OnCreated()
    self:SetSpecialTypes({
        MODIFIER_ROSHPIT_Q_MIN_CD_MOD,
        MODIFIER_ROSHPIT_Q_FLAT_CD_MOD,
        MODIFIER_ROSHPIT_W_FLAT_CD_MOD,
        MODIFIER_ROSHPIT_E_PCT_CD_MOD,
        MODIFIER_ROSHPIT_R_PCT_CD_MOD,
        MODIFIER_SPECIAL_TYPE_CAST_Q_ABILITY,
        MODIFIER_SPECIAL_TYPE_CAST_E_ABILITY,
        MODIFIER_ROSHPIT_Q_BASE_ABILITY_DMG_BONUS,
        MODIFIER_ROSHPIT_W_BASE_ABILITY_DMG_BONUS,
        MODIFIER_ROSHPIT_E_BASE_ABILITY_DMG_BONUS,
        MODIFIER_ROSHPIT_R_BASE_ABILITY_DMG_BONUS,
        MODIFIER_ROSHPIT_TOOLTIP_Q,
        MODIFIER_ROSHPIT_TOOLTIP_E
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

function modifierClass:GetRoshpitQFlatCdModifier()
    return - self:GetAbility():GetFinalGemPropertyValue("emerald", ITEM_RPC_SIGNUS_CHARM_GEM_EMERALD2)
end
function modifierClass:GetRoshpitQMinCdModifier()
    if self:GetAbility():GetGemValue("emerald") > 0 then
        return ITEM_RPC_SIGNUS_CHARM_EMERALD_MIN_Q_CD
    else
        return nil
    end
end
function modifierClass:GetRoshpitWFlatCdModifier()
    return self:GetAbility():GetFinalGemPropertyValue("emerald", ITEM_RPC_SIGNUS_CHARM_GEM_EMERALD1)
end
function modifierClass:GetRoshpitEPctCdModifier()
    return ITEM_RPC_SIGNUS_CHARM_E_CD_INCREASE
end
function modifierClass:GetRoshpitRPctCdModifier()
    return - ITEM_RPC_SIGNUS_CHARM_R_CD_REDUCTION
end

function modifierClass:OnCastQAbility()
    local hero = self:GetParent()
    if self:GetAbility():GetGemValue("ruby") > 0 then
        local cd_reduce = self:GetAbility():GetFinalGemPropertyValue("ruby", ITEM_RPC_SIGNUS_CHARM_GEM_RUBY)
        local e_ability = hero:GetAbilityByIndex(DOTA_E_SLOT)
        Filters:ReduceCooldownGeneric(hero, e_ability, cd_reduce)
    end
end
function modifierClass:OnCastEAbility()
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_signus_charm_amethyst_buff", {duration = ITEM_RPC_SIGNUS_CHARM_AMETHYST_DURATION})
end

function modifierClass:GetRoshpitQBaseAbilityDmgBonus()
    return self:GetAbility():GetFinalGemPropertyValue("sapphire", ITEM_RPC_SIGNUS_CHARM_GEM_SAPPHIRE) / 100
end
function modifierClass:GetRoshpitWBaseAbilityDmgBonus()
    return self:GetAbility():GetFinalGemPropertyValue("sapphire", ITEM_RPC_SIGNUS_CHARM_GEM_SAPPHIRE) / 100
end
function modifierClass:GetRoshpitEBaseAbilityDmgBonus()
    return self:GetAbility():GetFinalGemPropertyValue("sapphire", ITEM_RPC_SIGNUS_CHARM_GEM_SAPPHIRE) / 100
end
function modifierClass:GetRoshpitRBaseAbilityDmgBonus()
    return self:GetAbility():GetFinalGemPropertyValue("sapphire", ITEM_RPC_SIGNUS_CHARM_GEM_SAPPHIRE) / 100
end

function modifier_signus_charm_amethyst_buff:OnCreated()
    self:SetSpecialTypes({
        MODIFIER_ROSHPIT_ARMOR_PIERCE_BONUS,
        MODIFIER_ROSHPIT_SPELL_PIERCE_BONUS
    })
end
function modifierClass:GetRoshpitTooltipQ()
    return { 
        itemIndex = self:GetAbility():GetEntityIndex(), 
        color = ITEM_RPC_SIGNUS_CHARM_COLOR, 
        immortal = false, 
        ruby = self:GetAbility():GetGemValue("ruby"), 
        amethyst = 0, --self:GetAbility():GetGemValue("amethyst"), 
        sapphire = 0, --self:GetAbility():GetGemValue("sapphire"), 
        emerald = 0 --self:GetAbility():GetGemValue("emerald") 
    }
end
function modifierClass:GetRoshpitTooltipE()
    return { 
        itemIndex = self:GetAbility():GetEntityIndex(), 
        color = ITEM_RPC_SIGNUS_CHARM_COLOR, 
        immortal = false, 
        ruby = 0, --self:GetAbility():GetGemValue("ruby"), 
        amethyst = self:GetAbility():GetGemValue("amethyst"), 
        sapphire = 0, --self:GetAbility():GetGemValue("sapphire"), 
        emerald = 0 --self:GetAbility():GetGemValue("emerald") 
    }
end
function modifier_signus_charm_amethyst_buff:GetRoshpitArmorPierceBonus(params)
    return self:GetAbility():GetFinalGemPropertyValue("amethyst", ITEM_RPC_SIGNUS_CHARM_GEM_AMETHYST)
end
function modifier_signus_charm_amethyst_buff:GetRoshpitSpellPierceBonus(params)
    return self:GetAbility():GetFinalGemPropertyValue("amethyst", ITEM_RPC_SIGNUS_CHARM_GEM_AMETHYST)
end