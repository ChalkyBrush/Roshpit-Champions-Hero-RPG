require('items/lua/gloves/base')
require('npc_abilities/base_modifier')

item_rpc_spellfire_gloves = class(BaseGloves, nil, BaseGloves)
local itemClass = item_rpc_spellfire_gloves
local itemClassName = 'item_rpc_spellfire_gloves'

modifier_spellfire_gloves = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_spellfire_gloves
local modifierName = 'modifier_spellfire_gloves'
LinkLuaModifier(modifierName, "items/lua/gloves/spellfire_gloves", LUA_MODIFIER_MOTION_NONE)

modifier_spellfire_ruby_block = class(npc_base_modifier, nil, npc_base_modifier)
local blockModifierClass = modifier_spellfire_ruby_block
local blockModifierName = 'modifier_spellfire_ruby_block'
LinkLuaModifier(blockModifierName, "items/lua/gloves/spellfire_gloves", LUA_MODIFIER_MOTION_NONE)

modifier_spellfire_gloves_channeling_think = class(npc_base_modifier, nil, npc_base_modifier)
local channelModifierClass = modifier_spellfire_gloves_channeling_think
local channelModifierName = 'modifier_spellfire_gloves_channeling_think'
LinkLuaModifier(channelModifierName, "items/lua/gloves/spellfire_gloves", LUA_MODIFIER_MOTION_NONE)


function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'Spellfire Gloves'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:HasRuneSlots()
    return true
end
function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_spellfire_gloves"
    self:SetSpecialValue("spellfire_gloves", "#FFA62B")
end
function itemClass:RollProperty2(item_level)
    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier3 = 80, tier4 = 100})
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, rune_type, 1.5)
end
function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 0.5)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 2.5)
end
function modifierClass:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_SPECIAL_TYPE_CAST_Q_ABILITY,
        MODIFIER_SPECIAL_TYPE_CAST_W_ABILITY,
        MODIFIER_SPECIAL_TYPE_CAST_E_ABILITY,
        MODIFIER_SPECIAL_TYPE_CAST_R_ABILITY,
        MODIFIER_ROSHPIT_Q_PCT_CD_MOD,
        MODIFIER_ROSHPIT_W_PCT_CD_MOD,
        MODIFIER_ROSHPIT_E_PCT_CD_MOD,
        MODIFIER_ROSHPIT_R_PCT_CD_MOD,
        MODIFIER_ROSHPIT_R_FLAT_CHANNELTIME_MOD
    })
end
function modifierClass:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_CASTTIME_PERCENTAGE
    }
    return funcs
end


function modifierClass:GetRoshpitArmorPierceBonus(params)
    local hero = self:GetParent()
    if hero:GetAbilityByIndex(DOTA_E_SLOT):IsCooldownReady() then
        return hero.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetFinalGemPropertyValue("emerald", ITEM_RPC_spellfire_gloves_GEM_EMERALD)
    end
    return 0
end
function modifierClass:OnCastQAbility()
    local hero = self:GetParent()
    local q_ability = hero:GetAbilityByIndex(DOTA_Q_SLOT)
    local ruby_proc = Filters:GetProc(hero, self:GetAbility():GetFinalGemPropertyValue("ruby", ITEM_RPC_SPELLFIRE_GLOVES_GEM_RUBY))
    if ruby_proc then
        modifierClass:SpellfireProc(q_ability, hero, self:GetAbility())
    end
end
function modifierClass:OnCastWAbility()
    local hero = self:GetParent()
    local w_ability = hero:GetAbilityByIndex(DOTA_W_SLOT)
    local ruby_proc = Filters:GetProc(hero, self:GetAbility():GetFinalGemPropertyValue("ruby", ITEM_RPC_SPELLFIRE_GLOVES_GEM_RUBY))
    if ruby_proc then
        modifierClass:SpellfireProc(w_ability, hero, self:GetAbility())
    end
end
function modifierClass:OnCastEAbility()
    local hero = self:GetParent()
    local e_ability = hero:GetAbilityByIndex(DOTA_E_SLOT)
    local ruby_proc = Filters:GetProc(hero, self:GetAbility():GetFinalGemPropertyValue("ruby", ITEM_RPC_SPELLFIRE_GLOVES_GEM_RUBY))
    if ruby_proc then
        modifierClass:SpellfireProc(e_ability, hero, self:GetAbility())
    end
end

function modifierClass:SpellfireProc(ability, hero, item)
    if not hero:HasModifier("modifier_spellfire_ruby_block") then
        Timers:CreateTimer(ITEM_RPC_SPELLFIRE_GLOVES_RUBY_DELAY, function()
            hero:AddNewModifier(hero.InventoryUnit, item, "modifier_spellfire_ruby_block", {duration = 0.3})
            ability:EndCooldown()
            if ability:IsFullyCastable() then
                local manaRestore = ability:GetManaCost(ability:GetLevel())
                hero:GiveMana(manaRestore)
                local castPointSave = ability:GetCastPoint()
                if slot == 1 then
                    ability.castPointSave = hero.castPointQ
                elseif slot == 2 then
                    ability.castPointSave = hero.castPointW
                elseif slot == 3 then
                    ability.castPointSave = hero.castPointE
                end
                ability:SetOverrideCastPoint(0)
                local behavior = ability:GetBehavior()
                --print(bit.band(behavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET))
                if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET) == DOTA_ABILITY_BEHAVIOR_NO_TARGET then
                    local order =
                    {
                        UnitIndex = hero:entindex(),
                        OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
                        AbilityIndex = ability:entindex(),
                        Queue = true
                    }
                    hero:Stop()
                    ExecuteOrderFromTable(order)
                elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
                    local enemies = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin(), nil, ability:GetCastRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
                    if #enemies > 0 then
                        local order = {
                            UnitIndex = hero:entindex(),
                            OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
                            TargetIndex = enemies[1]:entindex(),
                            AbilityIndex = ability:entindex(),
                            Queue = true
                        }
                        hero:Stop()
                        ExecuteOrderFromTable(order)
                    else
                        if ability.castPointSave then
                            ability:SetOverrideCastPoint(ability.castPointSave)
                            ability.castPointSave = nil
                            hero:RemoveModifierByName("modifier_spellfire_ruby_block")
                        end
                    end
                elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_POINT) == DOTA_ABILITY_BEHAVIOR_POINT then
                    local order =
                    {
                        UnitIndex = hero:entindex(),
                        OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
                        AbilityIndex = ability:entindex(),
                        Position = hero:GetAbsOrigin() + hero:GetForwardVector()*ability:GetCastRange(),
                        Queue = true
                    }
                    hero:Stop()
                    ExecuteOrderFromTable(order)
                end
            end
        end)
    end
end

function modifierClass:GetRoshpitQPctCdModifier()
    return - self:GetAbility():GetFinalGemPropertyValue("emerald", ITEM_RPC_SPELLFIRE_GLOVES_GEM_EMERALD) / 100
end
function modifierClass:GetRoshpitWPctCdModifier()
    return - self:GetAbility():GetFinalGemPropertyValue("emerald", ITEM_RPC_SPELLFIRE_GLOVES_GEM_EMERALD) / 100
end
function modifierClass:GetRoshpitEPctCdModifier()
    return - self:GetAbility():GetFinalGemPropertyValue("emerald", ITEM_RPC_SPELLFIRE_GLOVES_GEM_EMERALD) / 100
end
function modifierClass:GetRoshpitRPctCdModifier()
    return - self:GetAbility():GetFinalGemPropertyValue("emerald", ITEM_RPC_SPELLFIRE_GLOVES_GEM_EMERALD) / 100
end

function modifierClass:GetModifierPercentageCasttime(params)
    if IsServer() then
        return ITEM_RPC_SPELLFIRE_GLOVES_CAST_POINT_REDUCTION
    end
end

function modifierClass:GetRoshpitRFlatChanneltimeModifier()
    return - self:GetAbility():GetFinalGemPropertyValue("amethyst", ITEM_RPC_SPELLFIRE_GLOVES_GEM_AMETHYST)
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
    return "itemicons/spellfire_gloves"
end

function modifier_spellfire_ruby_block:IsHidden()
    return true
end
function modifier_spellfire_ruby_block:IsDebuff()
    return true
end

function channelModifierClass:OnCreated()
    self:StartIntervalThink(0.1)
end

function channelModifierClass:OnIntervalThink()
	local hero = self:GetParent()
	local ability = self:GetAbility()
	local ulti = hero:GetAbilityByIndex(DOTA_R_SLOT)
	local remaining_time_to_trigger = ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_SPELLFIRE_GLOVES_GEM_AMETHYST)
	local channel_time_remaining = (ulti:GetChannelTime() + (ulti:GetChannelStartTime() - GameRules:GetGameTime()))
	if (ulti:IsChanneling()) and (channel_time_remaining <= remaining_time_to_trigger + 0.03) then
        ulti:OnChannelFinish(false)
        Timers:CreateTimer(0.03, function()
            ulti:EndChannel(true)
            Filters:EndRChannel(hero)
        end)
        hero:RemoveModifierByName("modifier_spellfire_gloves_channeling_think")
	end
end