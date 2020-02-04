require('/items/lua/trinket/base')
require('/npc_abilities/base_modifier')

item_rpc_neverlord_soul_ring = class(BaseTrinket, nil, BaseTrinket)
local itemClass = item_rpc_neverlord_soul_ring
local itemClassName = 'item_rpc_neverlord_soul_ring'

modifier_neverlord_soul_ring = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_neverlord_soul_ring
local modifierName = 'modifier_neverlord_soul_ring'
LinkLuaModifier(modifierName, "/items/lua/trinket/neverlord_soul_ring", LUA_MODIFIER_MOTION_NONE)

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
    self.newItemTable.property1name = "!immortal!_modifier_neverlord_soul_ring"
    self:SetSpecialValue("neverlord_soul_ring", "#EFD310")
end
function itemClass:RollProperty2(item_level) 
    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, rune_type, 1.5)  
end

function itemClass:RollProperty3(item_level)
    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 3, item_level, rune_type, 1.5) 
end
function itemClass:RollProperty4(item_level)
    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 4, item_level, rune_type, 1.5) 
end
function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 1.5)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 1.5)
end
function modifierClass:OnCreated()
    self:SetSpecialTypes({
        MODIFIER_ROSHPIT_PERCENT_HEALTH_BONUS,
        MODIFIER_ROSHPIT_FLAT_MANA_BONUS,
        MODIFIER_ROSHPIT_ARMOR_PIERCE_BONUS,
        MODIFIER_ROSHPIT_SPELL_PIERCE_BONUS,
        MODIFIER_SPECIAL_TYPE_CAST_W_ABILITY
    })
end
function modifierClass:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
    }

    return funcs
end
function modifierClass:IsHidden()
    return true
end
function modifierClass:GetPercentHealthBonus()
    return - (ITEM_RPC_NEVERLORD_SOUL_RING_HP_CONVERSION_PCT + self:GetAbility():GetFinalGemPropertyValue("ruby", ITEM_RPC_NEVERLORD_SOUL_RING_GEM_RUBY)) / 100
end
function modifierClass:GetFlatManaBonus()
    local hero = self:GetParent()
    local baseHealth = CustomAttributes:GetBaseHealth(hero, nil)
    local multiplier = (ITEM_RPC_NEVERLORD_SOUL_RING_HP_CONVERSION_PCT + self:GetAbility():GetFinalGemPropertyValue("ruby", ITEM_RPC_NEVERLORD_SOUL_RING_GEM_RUBY)) / 100
    local bonusMana = baseHealth * multiplier
    return bonusMana
end
function modifierClass:GetModifierBaseAttack_BonusDamage(params)
    local hero = self:GetParent()
    local baseHealth = CustomAttributes:GetBaseHealth(hero, nil)
    local multiplier = (ITEM_RPC_NEVERLORD_SOUL_RING_HP_CONVERSION_PCT + self:GetAbility():GetFinalGemPropertyValue("ruby", ITEM_RPC_NEVERLORD_SOUL_RING_GEM_RUBY)) / 100
    local bonusDamage = baseHealth * multiplier * self:GetAbility():GetFinalGemPropertyValue("sapphire", ITEM_RPC_NEVERLORD_SOUL_RING_GEM_SAPPHIRE)
    return bonusDamage
end
function modifierClass:GetRoshpitArmorPierceBonus()
    local hero = self:GetParent()
    local baseHealth = CustomAttributes:GetBaseHealth(hero, nil)
    local multiplier = (ITEM_RPC_NEVERLORD_SOUL_RING_HP_CONVERSION_PCT + self:GetAbility():GetFinalGemPropertyValue("ruby", ITEM_RPC_NEVERLORD_SOUL_RING_GEM_RUBY)) / 100
    local armorPierce = baseHealth * multiplier * self:GetAbility():GetFinalGemPropertyValue("emerald", ITEM_RPC_NEVERLORD_SOUL_RING_GEM_EMERALD)
    return armorPierce
end
function modifierClass:GetRoshpitSpellPierceBonus()
    local hero = self:GetParent()
    local baseHealth = CustomAttributes:GetBaseHealth(hero, nil)
    local multiplier = (ITEM_RPC_NEVERLORD_SOUL_RING_HP_CONVERSION_PCT + self:GetAbility():GetFinalGemPropertyValue("ruby", ITEM_RPC_NEVERLORD_SOUL_RING_GEM_RUBY)) / 100
    local spellPierce = baseHealth * multiplier * self:GetAbility():GetFinalGemPropertyValue("emerald", ITEM_RPC_NEVERLORD_SOUL_RING_GEM_EMERALD)
    return spellPierce
end
function modifierClass:OnCastWAbility()
    local hero = self:GetParent()
    if self:GetAbility():GetGemValue("amethyst") > 0 then
        local healthBurned = math.min(hero:GetMaxHealth() * ITEM_RPC_NEVERLORD_SOUL_RING_GEM_AMETHYST_HEALTH_BURN_PCT / 100, hero:GetHealth() - 1)
        local manaRestored = healthBurned * self:GetAbility():GetFinalGemPropertyValue("amethyst", ITEM_RPC_NEVERLORD_SOUL_RING_GEM_AMETHYST) / 100
        hero:GiveMana(manaRestored)
        hero:SetHealth(hero:GetHealth() - healthBurned)
        local pfx = CustomAbilities:QuickAttachParticle("particles/items2_fx/soul_ring.vpcf", hero, 1)
        ParticleManager:SetParticleControl(pfx, 1, Vector(1,1,1))
    end
end

function modifierClass:RemoveOnDeath()
    return false
end