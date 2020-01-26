require('items/lua/body/base')
require('npc_abilities/base_modifier')

item_rpc_enchanted_solar_cape = class(BaseBody, nil, BaseBody)
local itemClass = item_rpc_enchanted_solar_cape
local itemClassName = 'item_rpc_enchanted_solar_cape'

modifier_enchanted_solar_cape = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_enchanted_solar_cape
local modifierName = 'modifier_enchanted_solar_cape'
LinkLuaModifier(modifierName, "items/lua/body/enchanted_solar_cape", LUA_MODIFIER_MOTION_NONE)

modifier_enchanted_solar_cape_buff = class(npc_base_modifier, nil, npc_base_modifier)
local buffModifierClass = modifier_enchanted_solar_cape_buff
local buffModifierName = 'modifier_enchanted_solar_cape_buff'
LinkLuaModifier(buffModifierName, "items/lua/body/enchanted_solar_cape", LUA_MODIFIER_MOTION_NONE)

modifier_enchanted_solar_cape_stacks = class(npc_base_modifier, nil, npc_base_modifier)
local stacksModifierClass = modifier_enchanted_solar_cape_stacks
local stacksModifierName = 'modifier_enchanted_solar_cape_stacks'
LinkLuaModifier(stacksModifierName, "items/lua/body/enchanted_solar_cape", LUA_MODIFIER_MOTION_NONE)

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
    self.newItemTable.property1name = "!immortal!_modifier_enchanted_solar_cape"
    self:SetSpecialValue("enchanted_solar_cape", "#EBB523")
end
function itemClass:RollProperty2(item_level)
     local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
     RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, rune_type, 1.5)
end

function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 0)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 3)
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
        MODIFIER_SPECIAL_TYPE_CAST_R_ABILITY
    })
    self:StartIntervalThink(ITEM_RPC_ENCHANTED_SOLAR_CAPE_INTERVAL)
end

function modifierClass:OnIntervalThink()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local hero = self:GetParent()
	AddSolarCapeStacks(hero, caster, ability, 1)
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
    return "item/seafortress/enchanted_solar_cape"
end
function modifierClass:OnCastRAbility()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local hero = self:GetParent()
    AddSolarCapeStacks(hero, caster, ability, ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_ENCHANTED_SOLAR_CAPE_GEM_RUBY))
end

function AddSolarCapeStacks(hero, caster, ability, stacks_count)
    if not hero:HasModifier("modifier_enchanted_solar_cape_buff") then
        local new_stacks = hero:GetModifierStackCount("modifier_enchanted_solar_cape_stacks", caster) + stacks_count
        hero:AddNewModifier(caster, ability, "modifier_enchanted_solar_cape_stacks", {})
        hero:SetModifierStackCount("modifier_enchanted_solar_cape_stacks", caster, new_stacks)
        local stacks_for_flare = math.max(ITEM_RPC_ENCHANTED_SOLAR_CAPE_STACKS - ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_ENCHANTED_SOLAR_CAPE_GEM_EMERALD), 1)
        if new_stacks >= stacks_for_flare then
            hero:AddNewModifier(caster, ability, "modifier_enchanted_solar_cape_buff", {duration = ITEM_RPC_ENCHANTED_SOLAR_CAPE_SOLAR_FLARE_DURATION})
            hero:RemoveModifierByName("modifier_enchanted_solar_cape_stacks")
        end
    end
end

function stacksModifierClass:GetTexture()
    return "earthshaker_aftershock"
end
function buffModifierClass:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_CASTTIME_PERCENTAGE
    }
    return funcs
end

function buffModifierClass:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_Q_PCT_CD_MOD,
        MODIFIER_ROSHPIT_W_PCT_CD_MOD,
        MODIFIER_ROSHPIT_E_PCT_CD_MOD,
        MODIFIER_ROSHPIT_R_PCT_CD_MOD,
        MODIFIER_ROSHPIT_MAGIC_ARMOR_BONUS,
        MODIFIER_ROSHPIT_SPELL_PIERCE_BONUS,
        MODIFIER_ROSHPIT_ITEM_DMG_BONUS,
        MODIFIER_ROSHPIT_Q_BASE_ABILITY_DMG_BONUS,
        MODIFIER_ROSHPIT_W_BASE_ABILITY_DMG_BONUS,
        MODIFIER_ROSHPIT_E_BASE_ABILITY_DMG_BONUS,
        MODIFIER_ROSHPIT_R_BASE_ABILITY_DMG_BONUS,
    })
end
function buffModifierClass:GetModifierPercentageCasttime()
    return ITEM_RPC_ENCHANTED_SOLAR_CAPE_CAST_RATE
end
function buffModifierClass:GetRoshpitQPctCdModifier()
    return - ITEM_RPC_ENCHANTED_SOLAR_CAPE_COOLDOWN_PCT
end
function buffModifierClass:GetRoshpitWPctCdModifier()
    return - ITEM_RPC_ENCHANTED_SOLAR_CAPE_COOLDOWN_PCT
end
function buffModifierClass:GetRoshpitEPctCdModifier()
    return - ITEM_RPC_ENCHANTED_SOLAR_CAPE_COOLDOWN_PCT
end
function buffModifierClass:GetRoshpitRPctCdModifier()
    return - ITEM_RPC_ENCHANTED_SOLAR_CAPE_COOLDOWN_PCT
end
function buffModifierClass:GetRoshpitQBaseAbilityDmgBonus()
    return self:GetAbility():GetFinalGemPropertyValue("sapphire", ITEM_RPC_ENCHANTED_SOLAR_CAPE_GEM_SAPPHIRE)/100
end
function buffModifierClass:GetRoshpitWBaseAbilityDmgBonus()
    return self:GetAbility():GetFinalGemPropertyValue("sapphire", ITEM_RPC_ENCHANTED_SOLAR_CAPE_GEM_SAPPHIRE)/100
end
function buffModifierClass:GetRoshpitEBaseAbilityDmgBonus()
    return self:GetAbility():GetFinalGemPropertyValue("sapphire", ITEM_RPC_ENCHANTED_SOLAR_CAPE_GEM_SAPPHIRE)/100
end
function buffModifierClass:GetRoshpitRBaseAbilityDmgBonus()
    return self:GetAbility():GetFinalGemPropertyValue("sapphire", ITEM_RPC_ENCHANTED_SOLAR_CAPE_GEM_SAPPHIRE)/100
end
function buffModifierClass:GetRoshpitItemDmgBonus()
    return self:GetAbility():GetFinalGemPropertyValue("sapphire", ITEM_RPC_ENCHANTED_SOLAR_CAPE_GEM_SAPPHIRE)/100
end
function buffModifierClass:GetRoshpitMagicArmorBonus()
    return self:GetAbility():GetFinalGemPropertyValue("amethyst", ITEM_RPC_ENCHANTED_SOLAR_CAPE_GEM_AMETHYST)
end
function buffModifierClass:GetRoshpitSpellPierceBonus()
    return self:GetAbility():GetFinalGemPropertyValue("amethyst", ITEM_RPC_ENCHANTED_SOLAR_CAPE_GEM_AMETHYST)
end
function buffModifierClass:GetTexture()
    return "itemicons/enchanted_solar_cape"
end