require('items/lua/foot/base')
require('npc_abilities/base_modifier')

item_rpc_dunetreads = class(BaseFoot, nil, BaseFoot)
modifier_dunetreads = class(npc_base_modifier, nil, npc_base_modifier)
local itemClass = item_rpc_dunetreads
local itemClassName = 'item_rpc_dunetreads'

local modifierClass = modifier_dunetreads
local modifierName = 'modifier_dunetreads'
LinkLuaModifier(modifierName, "items/lua/foot/dunetreads", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'Dunetreads'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:HasRuneSlots()
    return true
end
function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_dunetreads"
    self:SetSpecialValue("dunetreads", ITEM_RPC_DUNETREADS_COLOR)
end
function itemClass:RollProperty2(item_level)
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, nil, 1.25)
end
function itemClass:RollProperty3(item_level)
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 3, item_level, nil, 1.25)
end
function itemClass:RollProperty4(item_level)
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 4, item_level, nil, 1.25)
end
function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 1.5)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 1.5)
end
function modifierClass:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_E_FLAT_CD_MOD,
        MODIFIER_ROSHPIT_ARMOR_PIERCE_BONUS,
        MODIFIER_ROSHPIT_ARMOR_BONUS,
        MODIFIER_ROSHPIT_MAGIC_ARMOR_BONUS,
        MODIFIER_SPECIAL_TYPE_CAST_E_ABILITY,
        MODIFIER_ROSHPIT_TOOLTIP_E
    })
end
function modifierClass:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }
    return funcs
end


function modifierClass:GetRoshpitArmorPierceBonus(params)
    local hero = self:GetParent()
    if hero:GetAbilityByIndex(DOTA_E_SLOT):IsCooldownReady() then
        return hero.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetFinalGemPropertyValue("emerald", ITEM_RPC_DUNETREADS_GEM_EMERALD)
    end
    return 0
end
function modifierClass:OnCastEAbility()
    local hero = self:GetParent()
    local dunetreads = self:GetAbility()
    if dunetreads:GetGemValue("ruby") > 0 then
        local proc = Filters:GetProc(hero, dunetreads:GetFinalGemPropertyValue("ruby", ITEM_RPC_DUNETREADS_GEM_RUBY))
        if proc then
            hero:GetAbilityByIndex(DOTA_E_SLOT):EndCooldown()
            CustomAbilities:QuickAttachParticle("particles/econ/items/monkey_king/arcana/water/monkey_king_spring_cast_water_spiral.vpcf", hero, 3)
        end
    end
end

function modifierClass:GetRoshpitArmorBonus()
    local hero = self:GetParent()
    return self:GetAbility():GetFinalGemPropertyValue("amethyst", ITEM_RPC_DUNETREADS_GEM_AMETHYST) * hero:GetAgility()
end

function modifierClass:GetRoshpitMagicArmorBonus()
    local hero = self:GetParent()
    return self:GetAbility():GetFinalGemPropertyValue("amethyst", ITEM_RPC_DUNETREADS_GEM_AMETHYST) * hero:GetAgility()
end

function modifierClass:GetModifierMoveSpeedBonus_Constant(params)
    if IsServer() then
        local hero = self:GetParent()
        if hero:GetAbilityByIndex(DOTA_E_SLOT):IsCooldownReady() then
            return self:GetAbility():GetFinalGemPropertyValue("sapphire", ITEM_RPC_DUNETREADS_GEM_SAPPHIRE)
        end
        return 0
    end
end

function modifierClass:GetModifierMoveSpeed_Max_Increase(params)
    if IsServer() then
        local hero = self:GetParent()
        if hero:GetAbilityByIndex(DOTA_E_SLOT):IsCooldownReady() then
            return self:GetAbility():GetFinalGemPropertyValue("sapphire", ITEM_RPC_DUNETREADS_GEM_SAPPHIRE)
        end
        return 0
    end
end
function modifierClass:GetRoshpitEFlatCdModifier()
    return - ITEM_RPC_DUNETREADS_CD_RED
end
function modifierClass:GetRoshpitTooltipE()
    return { 
        itemIndex = self:GetAbility():GetEntityIndex(), 
        color = ITEM_RPC_DUNETREADS_COLOR, 
        immortal = false, 
        ruby = self:GetAbility():GetGemValue("ruby"), 
        amethyst = 0, --self:GetAbility():GetGemValue("amethyst"), 
        sapphire = 0, --self:GetAbility():GetGemValue("sapphire"), 
        emerald = 0, --self:GetAbility():GetGemValue("emerald") 
    }
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