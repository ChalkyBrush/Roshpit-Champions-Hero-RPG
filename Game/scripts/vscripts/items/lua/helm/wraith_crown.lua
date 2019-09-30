require('items/lua/helm/base')
require('npc_abilities/base_modifier')

item_rpc_wraith_crown = class(BaseHelm, nil, BaseHlm)
local class = item_rpc_wraith_crown
local className = 'item_rpc_wraith_crown'

modifier_wraith_crown = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_wraith_crown
local modifierName = 'modifier_wraith_crown'
LinkLuaModifier(modifierName, "items/lua/helm/wraith_crown", LUA_MODIFIER_MOTION_NONE)

modifier_wraith_crown_buff = class(npc_base_modifier, nil, npc_base_modifier)
local buffModifierClass = modifier_wraith_crown_buff
local buffModifierName = 'modifier_wraith_crown_buff'
LinkLuaModifier(buffModifierName, "items/lua/helm/wraith_crown", LUA_MODIFIER_MOTION_NONE)

function class:GetClassName()
    return className
end
function class:GetName()
    return 'Whatever the fuck this is for'
end
function class:GetModifierName()
    return modifierName
end
function class:HasRuneSlots()
    return true
end
function class:RollProperty1(maxFactor)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "wraith_crown"
    self:SetSpecialValue(self.newItemTable.property1name, "#5671E8")
end
function class:RollProperty2(maxFactor)
    local tier, value, propertyName = RPCItems:RollMagebaneRuneProperty()
    self.newItemTable.property2 = math.floor(value * 2)
    self.newItemTable.property2name = propertyName
    RPCItems:SetPropertyValues(self, self.newItemTable.property2, "rune", "#7DFF12", 2)
end


function modifierClass:OnCreated()
    self.thinkInterval = 0.03
    self:StartIntervalThink(self.thinkInterval)
end

function modifierClass:OnIntervalThink()
    local hero = self:GetCaster()
    if not hero:IsAlive() then
        return
    end
    local currentHealthPercent = hero:GetHealth() / hero:GetMaxHealth()
    if currentHealthPercent <= WRAITH_CROWN_BUFF_HP_TRESHOLD_PCT / 100 then
        if not hero:HasModifier(buffModifierName) then
            hero:AddNewModifier(hero, self, buffModifierName, {})
        end
    else
        hero:RemoveModifierByName(buffModifierName)
    end
end

function modifierClass:IsHidden()
    return true
end

function modifierClass:RemoveOnDeath()
    return false
end

function buffModifierClass:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_EVASION_CONSTANT,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
    }

    return funcs
end

function buffModifierClass:GetModifierMagicalResistanceBonus()
    return WRAITH_CROWN_MAG_RES_PCT
end

function buffModifierClass:GetModifierEvasion_Constant()
    return WRAITH_CROWN_EVASION_PCT
end

function buffModifierClass:IsHidden()
    return false
end

function buffModifierClass:IsBuff()
    return true
end

function buffModifierClass:RemoveOnDeath()
    return false
end

function buffModifierClass:OnCreated()
    self.thinkInterval = WRAITH_CROWN_DISJOINT_INTERVAL_SEC
    self:StartIntervalThink(self.thinkInterval)
end

function buffModifierClass:OnIntervalThink()
    ProjectileManager:ProjectileDodge(self:GetCaster())
end

function buffModifierClass:GetTexture()
    return "itemicons/wraith_crown"
end