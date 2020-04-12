require('items/lua/body/base_chest')
require('npc_abilities/base_modifier')

item_rpc_dark_arts_vestments = class(BaseBody, nil, BaseBody)
modifier_dark_arts_vestments = class(npc_base_modifier, nil, npc_base_modifier)
local itemClass = item_rpc_dark_arts_vestments
local itemClassName = 'item_rpc_dark_arts_vestments'

local modifierClass = modifier_dark_arts_vestments
local modifierName = 'modifier_dark_arts_vestments'
LinkLuaModifier(modifierName, "items/lua/body/dark_arts_vestments", LUA_MODIFIER_MOTION_NONE)


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
    self.newItemTable.property1name = "!immortal!_modifier_dark_arts_vestments"
    self:SetSpecialValue("dark_arts", "#7A3B63")
end

function itemClass:RollProperty2(item_level)
    local luck = RandomInt(1, 2)
    if luck == 1 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, rune_type, 1.5)
    else
        RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "intelligence", 2)
    end
end

function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 1)
end

function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 2)
end


------------
--MODIFIER--
------------

function modifierClass:OnCreated()
    if not IsServer() then return end

    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_MAGIC_ARMOR_BONUS,
        MODIFIER_ROSHPIT_SPELL_PIERCE_BONUS,
        MODIFIER_ROSHPIT_AGILITY_BONUS,
    })

    -- TODO: replace thinker with OnTakeFilteredDamage event?
    -- but then it will ignore negative hp regen ¯\_(ツ)_/¯
    if self:GetAbility():GetGemValue("amethyst") > 0 then
        self.last_health = self:GetParent():GetHealth()
        self:StartIntervalThink(0.1)
    end 
end

function modifierClass:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
    }
    return funcs
end


-----------
--SPECIAL--
-----------

function modifierClass:GetRoshpitAgilityBonus()
    if not IsServer() then return end
    
    local hero = self:GetParent()
    local intellect = hero:GetBaseIntellect()
    local agility_bonus = math.floor(intellect * ITEM_RPC_DARK_ARTS_VESTMENTS_INT_TO_AGI)
    self.stat_bonus = agility_bonus -- required for CDOTA_BaseNPC_Hero:GetBaseAgility()
    return agility_bonus
end


--------
--RUBY--
--------

function modifierClass:GetModifierBaseAttack_BonusDamage()
    if not IsServer() then return end
    
    local hero = self:GetParent()
    local current_mana = hero:GetMana()
    return current_mana * self:GetAbility():GetFinalGemPropertyValue("ruby", ITEM_RPC_DARK_ARTS_VESTMENTS_GEM_RUBY)
end


------------
--SAPPHIRE--
------------

function modifierClass:GetRoshpitMagicArmorBonus()
    if not IsServer() then return end

    local hero = self:GetParent()
    local intellect = hero:GetIntellect()
    return intellect * self:GetAbility():GetFinalGemPropertyValue("sapphire", ITEM_RPC_DARK_ARTS_VESTMENTS_GEM_SAPPHIRE)
end


-----------
--EMERALD--
-----------

function modifierClass:GetRoshpitSpellPierceBonus()
    if not IsServer() then return end

    local hero = self:GetParent()
    local agility = hero:GetAgility()
    return agility * self:GetAbility():GetFinalGemPropertyValue("emerald", ITEM_RPC_DARK_ARTS_VESTMENTS_GEM_EMERALD)
end


------------
--AMETHYST--
------------

function modifierClass:OnIntervalThink()
    if not IsServer() then return end
    
    local hero = self:GetParent()
    local health_diff = self.last_health - hero:GetHealth()
    if health_diff > 0 then
        local mana_restore = math.ceil(health_diff * self:GetAbility():GetFinalGemPropertyValue("amethyst", ITEM_RPC_DARK_ARTS_VESTMENTS_GEM_AMETHYST)/100)
        if mana_restore > 0 then
            hero:GiveMana(mana_restore)
            PopupMana(hero, mana_restore)
        end
    end
    self.last_health = hero:GetHealth()
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
