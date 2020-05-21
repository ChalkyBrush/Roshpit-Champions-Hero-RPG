require('items/lua/helm/base_helm')
require('npc_abilities/base_modifier')

item_rpc_iron_tower_barbute = class(BaseHelm, nil, BaseHelm)
local itemClass = item_rpc_iron_tower_barbute
local itemClassName = 'item_rpc_iron_tower_barbute'

modifier_iron_tower_barbute = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_iron_tower_barbute
local modifierName = 'modifier_iron_tower_barbute'
LinkLuaModifier(modifierName, "items/lua/helm/iron_tower_barbute", LUA_MODIFIER_MOTION_NONE)

modifier_iron_tower_effect = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_iron_tower_effect", "items/lua/helm/iron_tower_barbute", LUA_MODIFIER_MOTION_NONE)

modifier_iron_tower_sapphire = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_iron_tower_sapphire", "items/lua/helm/iron_tower_barbute", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'Iron Tower Barbute'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:HasRuneSlots()
    return true
end
function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_iron_tower_barbute"
    self:SetSpecialValue("iron_tower_barbute", "#BBBBBB")
end
function itemClass:RollProperty2(item_level)
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "strength", 2.5)
end

function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 3.5)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 0)
end

------------
--MODIFIER--
------------

function modifierClass:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({
        MODIFIER_SPECIAL_TYPE_ORDER_FILTER
    })
    local ability = self:GetAbility()
    self:StartIntervalThink(0.1)
end

function modifierClass:DeclareFunctions()
    local funcs = {
    	MODIFIER_EVENT_ON_DEATH
    }

    return funcs
end


function modifierClass:IsHidden()
    return true
end

function modifierClass:RemoveOnDeath()
    return false
end

function modifierClass:IsBuff()
    return true
end

function modifierClass:OnOrderFilter(data)
    local ability = self:GetAbility()
    local allowedOrderTypes = {
        [DOTA_UNIT_ORDER_HOLD_POSITION] = true,
        [DOTA_UNIT_ORDER_STOP] = true
    }
    if not allowedOrderTypes[data.order_type] then
        return
    end
    local hero = self:GetParent()
    hero:AddNewModifier(hero, ability, "modifier_iron_tower_effect", {})
    ability.checkTicks = 0
end

function modifierClass:OnRemoved()
    if not IsServer() then
        return
    end
    local hero = self:GetParent()
    hero:RemoveModifierByName("modifier_iron_tower_effect")
    hero:RemoveModifierByName("modifier_iron_tower_sapphire")
end

function modifierClass:OnIntervalThink()
	local hero = self:GetParent()
	local ability = self:GetAbility()
	if not ability.lastPos then
		ability.lastPos = hero:GetAbsOrigin()
		ability.checkTicks = 0
	end
	local distance = WallPhysics:GetDistance2d(hero:GetAbsOrigin(), ability.lastPos)
	ability.lastPos = hero:GetAbsOrigin()
	if distance > 0 and ability.checkTicks > 1 then
		ability.checkTicks = 0
		if ability:GetGemValue("amethyst") > 0 then
			if hero:HasModifier("modifier_iron_tower_effect") then
				local duration_remaining = hero:FindModifierByName("modifier_iron_tower_effect"):GetRemainingTime()
				print(duration_remaining)
				if duration_remaining <= 0 then
					local duration = ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_IRON_TOWER_BARBUTE_AMETHYST)
					hero:AddNewModifier(hero, ability, "modifier_iron_tower_effect", {duration = duration})
				end
			end
		else
			hero:RemoveModifierByName("modifier_iron_tower_effect")
		end
	else
		ability.checkTicks = ability.checkTicks + 1
	end
	if ability:GetGemValue("sapphire") > 0 then
	    local enemies = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin(), nil, ITEM_RPC_IRON_TOWER_BARBUTE_SAPPHIRE_RANGE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	    local bApplySapphireBuff = false
	    if #enemies >= ITEM_RPC_IRON_TOWER_BARBUTE_SAPPHIRE_ENEMIES then
	    	bApplySapphireBuff = true
	    else
	        for _, enemy in pairs(enemies) do
	            if enemy:GetEnemyTier() >= ENEMY_TYPE_BOSS then
	            	bApplySapphireBuff = true
	            end
	        end
	    end
	    if bApplySapphireBuff then
	    	hero:AddNewModifier(hero, ability, "modifier_iron_tower_sapphire", {})
	    else
	    	hero:RemoveModifierByName("modifier_iron_tower_sapphire")
	    end
	end
end

function modifierClass:OnDeath()
	local ability = self:GetAbility()
	local caster = self:GetParent()
	if ability:GetCooldownTimeRemaining() == 0 and ability:GetGemValue("emerald") > 0 then
		if caster.respawnFlag then
			UTIL_Remove(caster.respawnFlag)
		end
		local flag = CreateUnitByName("npc_dummy_unit", caster:GetAbsOrigin(), false, nil, nil, caster:GetTeamNumber())
		flag:SetOriginalModel("models/props_teams/banner_radiant.vmdl")
		flag:SetModel("models/props_teams/banner_radiant.vmdl")
		flag:SetForwardVector(Vector(0, -1))
		flag:SetModelScale(0.9)
		if caster:GetPlayerOwnerID() == 0 then
			flag:SetRenderColor(130, 130, 255)
		elseif caster:GetPlayerOwnerID() == 1 then
			flag:SetRenderColor(130, 255, 255)
		elseif caster:GetPlayerOwnerID() == 2 then
			flag:SetRenderColor(255, 130, 255)
		elseif caster:GetPlayerOwnerID() == 3 then
			flag:SetRenderColor(255, 255, 130)
		end
		flag:FindAbilityByName("dummy_unit"):SetLevel(1)
		caster.respawnFlag = flag
		CustomAbilities:QuickAttachParticle("particles/econ/items/meepo/meepo_colossal_crystal_chorus/meepo_divining_rod_poof_end.vpcf", flag, 3)
		CustomAbilities:QuickAttachParticle("particles/econ/items/monkey_king/arcana/water/mk_spring_arcana_water_channel_powertrails.vpcf", flag, 4)	

	    local cooldown = ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_IRON_TOWER_BARBUTE_EMERALD)
	    cooldown = Filters:AdjustCooldownForDotaCooldownRate(cooldown)
	    ability:StartCooldown(cooldown)
	end
end

-- EFFECT

function modifier_iron_tower_effect:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({
        MODIFIER_ROSHPIT_STRENGTH_BONUS,
        MODIFIER_ROSHPIT_ARMOR_PIERCE_BONUS,
        MODIFIER_ROSHPIT_ARMOR_BONUS
    })
    local hero = self:GetParent()
    EmitSoundOn("RPCItems.IronTower.Activate", hero)
end

function modifier_iron_tower_effect:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MODEL_SCALE
    }

    return funcs
end


function modifier_iron_tower_effect:GetRoshpitStrengthBonus()
	return ITEM_RPC_IRON_TOWER_BARBUTE_STRENGTH * self:GetParent():GetLevel()
end

function modifier_iron_tower_effect:GetModifierModelScale()
	return 75
end

function modifier_iron_tower_effect:GetEffectName()
	return "particles/roshpit/items/iron_tower_buff.vpcf"
end

function modifier_iron_tower_effect:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end

function modifier_iron_tower_effect:GetRoshpitArmorPierceBonus()
	local ability = self:GetAbility()
	local hero = self:GetParent()
	return ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_IRON_TOWER_BARBUTE_RUBY)*hero:GetStrength()
end

function modifier_iron_tower_effect:GetRoshpitArmorBonus()
	local ability = self:GetAbility()
	local hero = self:GetParent()
	return ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_IRON_TOWER_BARBUTE_RUBY)*hero:GetStrength()
end

-- sapphire buff

function modifier_iron_tower_sapphire:IsHidden()
	return true
end

function modifier_iron_tower_sapphire:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({
        MODIFIER_ROSHPIT_MASTER_GREEN_DMG
    })
end

function modifier_iron_tower_sapphire:GetRoshpitMasterGreenDMG()
	local ability = self:GetAbility()
	return ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_IRON_TOWER_BARBUTE_SAPPHIRE)
end