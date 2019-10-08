require('items/lua/helm/base')
require('npc_abilities/base_modifier')

item_rpc_wraith_crown = class(BaseHelm, nil, BaseHelm)
local itemClass = item_rpc_wraith_crown
local itemClassName = 'item_rpc_wraith_crown'

modifier_wraith_crown = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_wraith_crown
local modifierName = 'modifier_wraith_crown'
LinkLuaModifier(modifierName, "items/lua/helm/wraith_crown", LUA_MODIFIER_MOTION_NONE)

modifier_wraith_crown_magic_res_buff = class(npc_base_modifier, nil, npc_base_modifier)
local magicResBuffModifierClass = modifier_wraith_crown_magic_res_buff
local magicResBuffModifierName = 'modifier_wraith_crown_magic_res_buff'
LinkLuaModifier(magicResBuffModifierName, "items/lua/helm/wraith_crown", LUA_MODIFIER_MOTION_NONE)

modifier_wraith_crown_evasion_buff = class(npc_base_modifier, nil, npc_base_modifier)
local evasionBuffModifierClass = modifier_wraith_crown_evasion_buff
local evasionBuffModifierName = 'modifier_wraith_crown_evasion_buff'
LinkLuaModifier(evasionBuffModifierName, "items/lua/helm/wraith_crown", LUA_MODIFIER_MOTION_NONE)

modifier_wraith_crown_disjoint_cooldown_debuff = class(npc_base_modifier, nil, npc_base_modifier)
local disjointCooldownModifierClass = modifier_wraith_crown_disjoint_cooldown_debuff
local disjointCooldownModifierName = 'modifier_wraith_crown_disjoint_cooldown_debuff'
LinkLuaModifier(disjointCooldownModifierName, "items/lua/helm/wraith_crown", LUA_MODIFIER_MOTION_NONE)

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
function itemClass:RollProperty1(maxFactor)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "wraith_crown"
    self:SetSpecialValue(self.newItemTable.property1name, "#5671E8")
end
function itemClass:RollProperty2(maxFactor)
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    self.newItemTable.property2 = math.floor(value * 2)
    self.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(self, self.newItemTable.property2, "rune", "#7DFF12", 2)
end

function modifierClass:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({
        MODIFIER_SPECIAL_TYPE_CAST_Q_ABILITY,
        MODIFIER_SPECIAL_TYPE_CAST_W_ABILITY,
        MODIFIER_SPECIAL_TYPE_CAST_E_ABILITY
    })
end

function modifierClass:OnCastQAbility()
    local hero = self:GetCaster()
    if hero:GetHealth() / hero:GetMaxHealth() <= WRAITH_CROWN_HP_THRESHOLD_PCT / 100 then
        hero:AddNewModifier(hero, self, magicResBuffModifierName, { duration = WRAITH_CROWN_MAG_RES_DUR })
    end
end

function modifierClass:OnCastWAbility()
    local hero = self:GetCaster()
    if hero:HasModifier(disjointCooldownModifierName) then
        return
    end
    if hero:GetHealth() / hero:GetMaxHealth() <= WRAITH_CROWN_HP_THRESHOLD_PCT / 100 then
        hero:AddNewModifier(hero, self, disjointCooldownModifierName, { duration = WRAITH_CROWN_DISJOINT_CD })
        ProjectileManager:ProjectileDodge(self:GetCaster())
    end
end

function modifierClass:OnCastEAbility()
    local hero = self:GetCaster()
    if hero:GetHealth() / hero:GetMaxHealth() <= WRAITH_CROWN_HP_THRESHOLD_PCT / 100 then
        hero:AddNewModifier(hero, self, evasionBuffModifierName, { duration = WRAITH_CROWN_EVASION_DUR })
    end
end

function modifierClass:IsHidden()
    return true
end

function modifierClass:RemoveOnDeath()
    return false
end

----------------
--EVASION BUFF--
----------------
function evasionBuffModifierClass:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_EVASION_CONSTANT
    }
    return funcs
end

function evasionBuffModifierClass:GetModifierEvasion_Constant()
    return WRAITH_CROWN_EVASION_PCT
end

function evasionBuffModifierClass:IsHidden()
    return false
end

function evasionBuffModifierClass:IsBuff()
    return true
end

function evasionBuffModifierClass:RemoveOnDeath()
    return false
end

function evasionBuffModifierClass:GetTexture()
    return "rpc/wraith_crown_evasion_buff"
end

------------------
--MAGIC RES BUFF--
------------------
function magicResBuffModifierClass:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
    }
    return funcs
end

function magicResBuffModifierClass:GetModifierMagicalResistanceBonus()
    return WRAITH_CROWN_MAG_RES_PCT
end

function magicResBuffModifierClass:IsHidden()
    return false
end

function magicResBuffModifierClass:IsBuff()
    return true
end

function magicResBuffModifierClass:RemoveOnDeath()
    return false
end

function magicResBuffModifierClass:GetTexture()
    return "rpc/wraith_crown_magic_res_buff"
end

--------------------------
--DISJOINT COOLDOWN BUFF--
--------------------------
function disjointCooldownModifierClass:IsHidden()
    return false
end

function disjointCooldownModifierClass:IsDebuff()
    return true
end

function disjointCooldownModifierClass:RemoveOnDeath()
    return false
end

function disjointCooldownModifierClass:GetTexture()
    return "rpc/wraith_crown_disjoint_cooldown"
end
