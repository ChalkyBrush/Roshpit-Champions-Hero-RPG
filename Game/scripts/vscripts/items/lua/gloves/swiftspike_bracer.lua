require('items/lua/gloves/base')
require('npc_abilities/base_modifier')

item_rpc_swiftspike_bracer = class(BaseGloves, nil, BaseGloves)
local itemClass = item_rpc_swiftspike_bracer
local itemClassName = 'item_rpc_swiftspike_bracer'

modifier_swiftspike_bracer = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_swiftspike_bracer
local modifierName = 'modifier_swiftspike_bracer'
LinkLuaModifier(modifierName, "items/lua/gloves/swiftspike_bracer", LUA_MODIFIER_MOTION_NONE)


function itemClass:GetClassName()
    return itemClassName
end

function itemClass:GetName()
    return 'Swiftspike Bracer'
end

function itemClass:GetModifierName()
    return modifierName
end

function itemClass:HasRuneSlots()
    return true
end

function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_swiftspike_bracer"
    self:SetSpecialValue("swiftspike_bracer", "#3F74A8")
end

function itemClass:RollProperty2(item_level)
    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, rune_type, 1)
end

function itemClass:RollProperty3(item_level)
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 3, item_level, "movespeed", 1)
end

function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 1)
end

function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 1)
end

------------
--MODIFIER--
------------

function modifierClass:OnCreated()
    if not IsServer() then return end

    self:SetSpecialTypes({
        MODIFIER_ROSHPIT_AGILITY_BONUS,
        MODIFIER_ROSHPIT_Q_BASE_ABILITY_DMG_BONUS,
        MODIFIER_ROSHPIT_W_BASE_ABILITY_DMG_BONUS,
        MODIFIER_ROSHPIT_E_BASE_ABILITY_DMG_BONUS,
        MODIFIER_ROSHPIT_R_BASE_ABILITY_DMG_BONUS,
        MODIFIER_ROSHPIT_ITEM_DMG_BONUS
    })
end

function modifierClass:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
    }
    return funcs
end

-----------
--SPECIAL--
-----------

function modifierClass:GetHeroMoveSpeed()
    local hero = self:GetParent()
    local movespeed = hero:GetBaseMoveSpeed()
    local movespeedActual = hero:GetMoveSpeedModifier(movespeed, false)
    return movespeedActual
end

function modifierClass:GetRoshpitBaseAbilityDmgBonus()
    local hero = self:GetParent()
    local movespeed = self:GetHeroMoveSpeed()
    return movespeed * ITEM_RPC_SWIFTSPIKE_BRACER_BAD_PER_MS/100
end

function modifierClass:GetRoshpitQBaseAbilityDmgBonus()
    return self:GetRoshpitBaseAbilityDmgBonus()
end

function modifierClass:GetRoshpitWBaseAbilityDmgBonus()
    return self:GetRoshpitBaseAbilityDmgBonus()
end

function modifierClass:GetRoshpitEBaseAbilityDmgBonus()
    return self:GetRoshpitBaseAbilityDmgBonus()
end

function modifierClass:GetRoshpitRBaseAbilityDmgBonus()
    return self:GetRoshpitBaseAbilityDmgBonus()
end


--------
--RUBY--
--------

function modifierClass:GetModifierBaseAttack_BonusDamage()
    if not IsServer() then return end

    local movespeed = self:GetHeroMoveSpeed()
    local item = self:GetAbility()
    return movespeed * item:GetFinalGemPropertyValue("ruby", ITEM_RPC_SWIFTSPIKE_BRACER_GEM_RUBY)
end


------------
--SAPPHIRE--
------------

function modifierClass:GetModifierMoveSpeed_Max_Increase()
    if not IsServer() then return end

    local item = self:GetAbility()
    return item:GetFinalGemPropertyValue("sapphire", ITEM_RPC_SWIFTSPIKE_BRACER_GEM_SAPPHIRE)
end


-----------
--EMERALD--
-----------

function modifierClass:GetRoshpitAgilityBonus()
    if not IsServer() then return end

    local item = self:GetAbility()
    return item:GetFinalGemPropertyValue("emerald", ITEM_RPC_SWIFTSPIKE_BRACER_GEM_EMERALD1)
end

function modifierClass:GetRoshpitItemDmgBonus()
    if not IsServer() then return end

    local movespeed = self:GetHeroMoveSpeed()
    local item = self:GetAbility()
    return movespeed * item:GetFinalGemPropertyValue("emerald", ITEM_RPC_SWIFTSPIKE_BRACER_GEM_EMERALD2)/100
end


------------
--AMETHYST--
------------

function modifierClass:GetModifierMoveSpeedBonus_Percentage()
    if not IsServer() then return end

    local item = self:GetAbility()
    return item:GetFinalGemPropertyValue("amethyst", ITEM_RPC_SWIFTSPIKE_BRACER_GEM_AMETHYST)
end


--------------
--PROPERTIES--
--------------

function modifierClass:IsHidden()
    return true
end

function modifierClass:IsBuff()
    return true
end

function modifierClass:RemoveOnDeath()
    return false
end
