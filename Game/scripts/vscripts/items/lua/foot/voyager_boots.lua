require('items/lua/foot/base')
require('npc_abilities/base_modifier')

item_rpc_voyager_boots = class(BaseFoot, nil, BaseFoot)
local itemClass = item_rpc_voyager_boots
local itemClassName = 'item_rpc_voyager_boots'

modifier_voyager_boots = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_voyager_boots
local modifierName = 'modifier_voyager_boots'
LinkLuaModifier(modifierName, "items/lua/foot/voyager_boots", LUA_MODIFIER_MOTION_NONE)

modifier_voyager_boots_sapphire = class(npc_base_modifier, nil, npc_base_modifier)
local sapphireModifierClass = modifier_voyager_boots_sapphire
local sapphireModifierName = 'modifier_voyager_boots_sapphire'
LinkLuaModifier(sapphireModifierName, "items/lua/foot/voyager_boots", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'voyager_boots'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:HasRuneSlots()
    return true
end
function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_voyager_boots"
    self:SetSpecialValue("voyager_boots", "#AB9091")
end
function itemClass:RollProperty2(item_level)  
    local luck = RandomInt(1, 5)
    if luck == 1 then
        RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "attack_speed", 1.5)
    elseif luck == 2 or luck == 3 then
        RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, nil, 1)
    elseif luck == 4 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, rune_type, 1.5)
    elseif luck == 5 then
        RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "movespeed", 1.5)
    end
end
function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 1)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 1)
end
function modifierClass:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_Q_PCT_CD_MOD,
        MODIFIER_ROSHPIT_W_PCT_CD_MOD,
        MODIFIER_ROSHPIT_E_PCT_CD_MOD,
        MODIFIER_ROSHPIT_R_PCT_CD_MOD,
        MODIFIER_SPECIAL_TYPE_CAST_E_ABILITY,
        MODIFIER_ROSHPIT_Q_BASE_ABILITY_DMG_BONUS,
        MODIFIER_ROSHPIT_W_BASE_ABILITY_DMG_BONUS,
        MODIFIER_ROSHPIT_E_BASE_ABILITY_DMG_BONUS,
        MODIFIER_ROSHPIT_R_BASE_ABILITY_DMG_BONUS
    })
    self:StartIntervalThink(ITEM_RPC_VOYAGER_BOOTS_THINK_INTERVAL)
end
function modifierClass:DeclareFunctions()
    local funcs = {
    	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_MAX
    }
    return funcs
end
function modifierClass:OnCastEAbility()
    local hero = self:GetParent()
    local ability = self:GetAbility()
    if ability:GetGemValue("ruby") > 0 then
        local cd_reduce_percentage = ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_VOYAGER_BOOTS_GEM_RUBY)/100
        local ability1 = hero:GetAbilityByIndex(DOTA_Q_SLOT)
        Filters:ReduceCDByPercentage(hero, ability1, cd_reduce_percentage)
        local ability2 = hero:GetAbilityByIndex(DOTA_W_SLOT)
        Filters:ReduceCDByPercentage(hero, ability2, cd_reduce_percentage)
        local ability4 = hero:GetAbilityByIndex(DOTA_R_SLOT)
        Filters:ReduceCDByPercentage(hero, ability4, cd_reduce_percentage)
    end
end
function modifierClass:GetRoshpitQPctCdModifier()
    return self:GetAbility():GetFinalGemPropertyValue("amethyst", ITEM_RPC_VOYAGER_BOOTS_GEM_AMETHYST1)/100
end
function modifierClass:GetRoshpitWPctCdModifier()
    return self:GetAbility():GetFinalGemPropertyValue("amethyst", ITEM_RPC_VOYAGER_BOOTS_GEM_AMETHYST1)/100
end
function modifierClass:GetRoshpitEPctCdModifier()
    return self:GetAbility():GetFinalGemPropertyValue("amethyst", ITEM_RPC_VOYAGER_BOOTS_GEM_AMETHYST1)/100
end
function modifierClass:GetRoshpitRPctCdModifier()
    return self:GetAbility():GetFinalGemPropertyValue("amethyst", ITEM_RPC_VOYAGER_BOOTS_GEM_AMETHYST1)/100
end
function modifierClass:GetRoshpitQBaseAbilityDmgBonus()
    return self:GetAbility():GetFinalGemPropertyValue("amethyst", ITEM_RPC_VOYAGER_BOOTS_GEM_AMETHYST2)/100
end
function modifierClass:GetRoshpitWBaseAbilityDmgBonus()
    return self:GetAbility():GetFinalGemPropertyValue("amethyst", ITEM_RPC_VOYAGER_BOOTS_GEM_AMETHYST2)/100
end
function modifierClass:GetRoshpitEBaseAbilityDmgBonus()
    return self:GetAbility():GetFinalGemPropertyValue("amethyst", ITEM_RPC_VOYAGER_BOOTS_GEM_AMETHYST2)/100
end
function modifierClass:GetRoshpitRBaseAbilityDmgBonus()
    return self:GetAbility():GetFinalGemPropertyValue("amethyst", ITEM_RPC_VOYAGER_BOOTS_GEM_AMETHYST2)/100
end
function modifierClass:OnIntervalThink()
    if IsServer() then
        local hero = self:GetParent()
        local ability = self:GetAbility()

        if not ability.lastPos then
            ability.lastPos = hero:GetAbsOrigin()
        end
        if not ability.distanceMoved then
            ability.distanceMoved = 0
        end
        ability.newPos = hero:GetAbsOrigin()
        local distance = WallPhysics:GetDistance2d(ability.newPos, ability.lastPos)
        ability.distanceMoved = ability.distanceMoved + distance
        if ability.distanceMoved > ITEM_RPC_VOYAGER_BOOTS_TRAVEL_DISTANCE then
            voyager_boots_cd_reduce_base(hero, ability, hero)
            ability.distanceMoved = ability.distanceMoved % ITEM_RPC_VOYAGER_BOOTS_TRAVEL_DISTANCE
        end

        ability.lastPos = hero:GetAbsOrigin()

        if ability:GetGemValue("sapphire") > 0 then
            hero:AddNewModifier(hero, ability, "modifier_voyager_boots_sapphire", {})
            local atk_power_stacks = ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_VOYAGER_BOOTS_GEM_SAPPHIRE)*Filters:GetNumberOfSkillsNotOnCooldownVoyager(hero)
            if atk_power_stacks > 0 then
                hero:SetModifierStackCount("modifier_voyager_boots_sapphire", hero, atk_power_stacks)
            else
                hero:RemoveModifierByName("modifier_voyager_boots_sapphire")
            end
        end
    end
end

function voyager_boots_cd_reduce_base(caster, ability, hero)
	for i = 1, 4, 1 do
		local cd_ability = Filters:SkillArgumentSlotToHeroAbility(hero, i)
		if cd_ability:GetCooldownTimeRemaining() > 0 then
			Filters:ReduceCDByPercentage(caster, cd_ability, ITEM_RPC_VOYAGER_BOOTS_PCT_CD_REDUCTION_ON_TRIGGER/100)
		end
	end
end
function modifierClass:GetModifierMoveSpeedBonus_Constant(params)
    if IsServer() then
        local hero = self:GetParent()
        local abilitiesOnCd = Filters:GetNumberOfSkillsOnCooldownVoyager(hero)
        return self:GetAbility():GetFinalGemPropertyValue("emerald", ITEM_RPC_VOYAGER_BOOTS_GEM_EMERALD) * abilitiesOnCd
    end
end

function modifierClass:GetModifierMoveSpeed_Max_Increase(params)
    if IsServer() then
        local hero = self:GetParent()
        local abilitiesOnCd = Filters:GetNumberOfSkillsOnCooldownVoyager(hero)
        return self:GetAbility():GetFinalGemPropertyValue("emerald", ITEM_RPC_VOYAGER_BOOTS_GEM_EMERALD) * abilitiesOnCd
    end
end
function modifierClass:OnRemoved()
    if IsServer() then
        local hero = self:GetParent()
        hero:RemoveModifierByName("modifier_voyager_boots_sapphire")
    end
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



function sapphireModifierClass:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
    }
    return funcs
end
function sapphireModifierClass:GetModifierBaseDamageOutgoing_Percentage()
    return self:GetStackCount()
end