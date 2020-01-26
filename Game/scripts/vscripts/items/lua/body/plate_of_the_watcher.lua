require('items/lua/body/base')
require('npc_abilities/base_modifier')

item_rpc_plate_of_the_watcher = class(BaseBody, nil, BaseBody)
local itemClass = item_rpc_plate_of_the_watcher
local itemClassName = 'item_rpc_plate_of_the_watcher'

modifier_plate_of_the_watcher_one = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClassOne = modifier_plate_of_the_watcher_one
local modifierNameOne = 'modifier_plate_of_the_watcher_one'
LinkLuaModifier(modifierNameOne, "items/lua/body/plate_of_the_watcher", LUA_MODIFIER_MOTION_NONE)

modifier_plate_of_the_watcher_two = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClassTwo = modifier_plate_of_the_watcher_two
local modifierNameTwo = 'modifier_plate_of_the_watcher_two'
LinkLuaModifier(modifierNameTwo, "items/lua/body/plate_of_the_watcher", LUA_MODIFIER_MOTION_NONE)

modifier_plate_of_the_watcher_three = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClassThree = modifier_plate_of_the_watcher_three
local modifierNameThree = 'modifier_plate_of_the_watcher_three'
LinkLuaModifier(modifierNameThree, "items/lua/body/plate_of_the_watcher", LUA_MODIFIER_MOTION_NONE)

modifier_plate_of_the_watcher_four = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClassFour = modifier_plate_of_the_watcher_four
local modifierNameFour = 'modifier_plate_of_the_watcher_four'
LinkLuaModifier(modifierNameFour, "items/lua/body/plate_of_the_watcher", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'Whatever the fuck this is for'
end
function itemClass:GetModifierName()
    return ""
end
function itemClass:HasRuneSlots()
    return true
end
function itemClass:RollProperty1(item_level)
    local luck = RandomInt(1, 2)
    if luck == 1 then
        self.newItemTable.property1 = 1
        self.newItemTable.property1name = "!immortal!_modifier_plate_of_the_watcher_one"
        self:SetSpecialValue("plate_of_the_watcher_one", "#478EC1", 1)
    else
        RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 1, item_level, nil, 1.35)
    end
end
function itemClass:RollProperty2(item_level)
    local luck = RandomInt(1, 2)
    if luck == 1 then
        self.newItemTable.property2 = 1
        self.newItemTable.property2name = "!immortal!_modifier_plate_of_the_watcher_two"
        self:SetSpecialValue("plate_of_the_watcher_two", "#478EC1", 2)
    else
        RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, nil, 1.35)
    end
end
function itemClass:RollProperty3(item_level)
    local luck = RandomInt(1, 2)
    if luck == 1 then
        self.newItemTable.property3 = 1
        self.newItemTable.property3name = "!immortal!_modifier_plate_of_the_watcher_three"
        self:SetSpecialValue("plate_of_the_watcher_three", "#478EC1", 3)
    else
        RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 3, item_level, nil, 1.35)
    end
end
function itemClass:RollProperty4(item_level)
    local luck = RandomInt(1, 2)
    if luck == 1 then
        self.newItemTable.property4 = 1
        self.newItemTable.property4name = "!immortal!_modifier_plate_of_the_watcher_four"
        self:SetSpecialValue("plate_of_the_watcher_four", "#478EC1", 4)
    else
        RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 4, item_level, nil, 1.35)
    end
end

function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 3.5)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 0)
end

function modifierClassOne:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_Q_PCT_CD_MOD,
        MODIFIER_ROSHPIT_Q_BASE_ABILITY_DMG_BONUS
    })
end
function modifierClassOne:GetRoshpitQPctCdModifier()
    return (ITEM_RPC_PLATE_OF_THE_WATCHER_I_CD_INCREASE_Q + self:GetAbility():GetFinalGemPropertyValue("ruby", ITEM_RPC_PLATE_OF_THE_WATCHER_GEM_RUBY1)) / 100
end
function modifierClassOne:GetRoshpitQBaseAbilityDmgBonus()
    return (ITEM_RPC_PLATE_OF_THE_WATCHER_I_BAD_Q + self:GetAbility():GetFinalGemPropertyValue("ruby", ITEM_RPC_PLATE_OF_THE_WATCHER_GEM_RUBY2)) / 100
end
function modifierClassOne:IsHidden()
    return true
end
function modifierClassOne:IsBuff()
    return true
end
function modifierClassOne:RemoveOnDeath()
    return false
end

function modifierClassTwo:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_W_PCT_CD_MOD,
        MODIFIER_ROSHPIT_W_BASE_ABILITY_DMG_BONUS
    })
end
function modifierClassTwo:GetRoshpitWPctCdModifier()
    return (ITEM_RPC_PLATE_OF_THE_WATCHER_II_CD_INCREASE_W + self:GetAbility():GetFinalGemPropertyValue("sapphire", ITEM_RPC_PLATE_OF_THE_WATCHER_GEM_SAPPHIRE1)) / 100
end
function modifierClassTwo:GetRoshpitWBaseAbilityDmgBonus()
    return (ITEM_RPC_PLATE_OF_THE_WATCHER_II_BAD_W + self:GetAbility():GetFinalGemPropertyValue("sapphire", ITEM_RPC_PLATE_OF_THE_WATCHER_GEM_SAPPHIRE2)) / 100
end
function modifierClassTwo:IsHidden()
    return true
end
function modifierClassTwo:IsBuff()
    return true
end
function modifierClassTwo:RemoveOnDeath()
    return false
end

function modifierClassThree:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_E_PCT_CD_MOD,
        MODIFIER_ROSHPIT_E_BASE_ABILITY_DMG_BONUS
    })
end
function modifierClassThree:GetRoshpitEPctCdModifier()
    return (ITEM_RPC_PLATE_OF_THE_WATCHER_III_CD_INCREASE_E + self:GetAbility():GetFinalGemPropertyValue("emerald", ITEM_RPC_PLATE_OF_THE_WATCHER_GEM_EMERALD1)) / 100
end
function modifierClassThree:GetRoshpitEBaseAbilityDmgBonus()
    return (ITEM_RPC_PLATE_OF_THE_WATCHER_III_BAD_E + self:GetAbility():GetFinalGemPropertyValue("emerald", ITEM_RPC_PLATE_OF_THE_WATCHER_GEM_EMERALD2)) / 100
end
function modifierClassThree:IsHidden()
    return true
end
function modifierClassThree:IsBuff()
    return true
end
function modifierClassThree:RemoveOnDeath()
    return false
end

function modifierClassFour:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_R_PCT_CD_MOD,
        MODIFIER_ROSHPIT_R_BASE_ABILITY_DMG_BONUS
    })
end
function modifierClassFour:GetRoshpitRPctCdModifier()
    return (ITEM_RPC_PLATE_OF_THE_WATCHER_IV_CD_INCREASE_R + self:GetAbility():GetFinalGemPropertyValue("amethyst", ITEM_RPC_PLATE_OF_THE_WATCHER_GEM_AMETHYST1)) / 100
end
function modifierClassFour:GetRoshpitRBaseAbilityDmgBonus()
    return (ITEM_RPC_PLATE_OF_THE_WATCHER_IV_BAD_R + self:GetAbility():GetFinalGemPropertyValue("amethyst", ITEM_RPC_PLATE_OF_THE_WATCHER_GEM_AMETHYST2)) / 100
end
function modifierClassFour:IsHidden()
    return true
end
function modifierClassFour:IsBuff()
    return true
end
function modifierClassFour:RemoveOnDeath()
    return false
end