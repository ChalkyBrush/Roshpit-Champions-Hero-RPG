require('items/lua/gloves/base_glove')
require('npc_abilities/base_modifier')

item_rpc_stonebreaker_gauntlet = class(BaseGloves, nil, BaseGloves)
local itemClass = item_rpc_stonebreaker_gauntlet
local itemClassName = 'item_rpc_stonebreaker_gauntlet'

modifier_stonebreaker_gauntlet = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_stonebreaker_gauntlet
local modifierName = 'modifier_stonebreaker_gauntlet'
LinkLuaModifier(modifierName, "items/lua/gloves/stonebreaker_gauntlet", LUA_MODIFIER_MOTION_NONE)

modifier_stonebreaker_ruby = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_stonebreaker_ruby", "items/lua/gloves/stonebreaker_gauntlet", LUA_MODIFIER_MOTION_NONE)

modifier_stonebreaker_amethyst = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_stonebreaker_amethyst", "items/lua/gloves/stonebreaker_gauntlet", LUA_MODIFIER_MOTION_NONE)

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
    self.newItemTable.property1name = "!immortal!_modifier_stonebreaker_gauntlet"
    self:SetSpecialValue("stonebreaker_gauntlet", "#a8403d")
end

function itemClass:RollProperty2(item_level)
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "strength", 2.5)
end

function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 2)
end

function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 1.5)
end

-- DUMMY ABILITY -- 
stonebreaker_dummy_ability = class({})

function stonebreaker_dummy_ability:OnProjectileHit_ExtraData(target, vLocation, extraData)
	self.stonebreaker:StonebreakerProjectileHit(target, extraData)
end

------------
--MODIFIER--
------------

function modifierClass:DeclareFunctions()
    local funcs = {
    	MODIFIER_EVENT_ON_ATTACK_LANDED
    }
    return funcs
end

function modifierClass:IsHidden()
	return true
end

function modifierClass:RemoveOnDeath()
	return false
end

function modifierClass:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_SPECIAL_TYPE_ORDER_FILTER,
        MODIFIER_ROSHPIT_MASTER_GREEN_DMG,
    	MODIFIER_SPECIAL_TYPE_R_CHANNEL_START,
    	MODIFIER_SPECIAL_TYPE_R_CHANNEL_END
    })
    local hero = self:GetParent()
    local ability = self:GetAbility()
    if not hero.InventoryUnit:HasAbility("stonebreaker_dummy_ability") then
    	ability.dummyAbility = hero.InventoryUnit:AddAbility("stonebreaker_dummy_ability")
    else
    	ability.dummyAbility = hero.InventoryUnit:FindAbilityByName("stonebreaker_dummy_ability")
    end
    ability.dummyAbility:SetLevel(1)
    ability.dummyAbility.stonebreaker = ability
end

function modifierClass:OnDestroy()
    if not IsServer() then return end

    local hero = self:GetParent()
    local ability = self:GetAbility()
    hero:RemoveModifierByName("modifier_stonebreaker_amethyst")
   	hero.InventoryUnit:RemoveAbility("stonebreaker_dummy_ability")
end

function modifierClass:OnOrderFilter(data)
    local ability = self:GetAbility()
    local hero = self:GetParent()
    local allowedOrderTypes = {
        [DOTA_UNIT_ORDER_ATTACK_TARGET] = true
    }
    if not allowedOrderTypes[data.order_type] then
        return
    end
    if ability:GetCooldownTimeRemaining() > 0 then
        return false
    end
    local enemy = EntIndexToHScript(data.entindex_target)

    local distance = WallPhysics:GetDistance2d(enemy:GetAbsOrigin(), hero:GetAbsOrigin())
    if distance <= ITEM_RPC_STONEBREAKER_GAUNTLET_RANGE then
    	local fractures = ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_STONEBREAKER_GAUNTLET_GEM_EMERALD1)
	    ability:ThrowStonebreakerRock(hero, enemy, fractures)
	    StartAnimation(hero, {duration = 0.8, activity = ACT_DOTA_ATTACK, rate = 1.5})
	    local cooldown = ITEM_RPC_STONEBREAKER_GAUNTLET_COOLDOWN
	    ability:StartCooldown(cooldown)
	end
end

function itemClass:ThrowStonebreakerRock(source, enemy, fractures)
	local ability = self
	local hero = self:GetCaster()
	EmitSoundOn("RPCItems.Stonebreaker.Throw", source)
	local travel_speed = ITEM_RPC_STONEBREAKER_GAUNTLET_TRAVEL_SPEED
	local info =
	{
		Target = enemy,
		Source = source,
		Ability = ability.dummyAbility,
		EffectName = "particles/neutral_fx/mud_golem_hurl_boulder.vpcf",
		StartPosition = "attach_attack1",
		bDrawsOnMinimap = false,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		bProvidesVision = false,
		iMoveSpeed = travel_speed,
		iVisionTeamNumber = hero:GetTeamNumber(),
		ExtraData = {fractures = fractures}
	}
	ProjectileManager:CreateTrackingProjectile(info)	
end

function itemClass:StonebreakerProjectileHit(target, extraData)
	local hero = self:GetCaster()
	local ability = self
	local damage = (hero:GetStrength()*ITEM_RPC_STONEBREAKER_GAUNTLET_DMG_STRENGTH) + (OverflowProtectedGetAverageTrueAttackDamage(hero) * (ITEM_RPC_STONEBREAKER_GAUNTLET_DMG_ATK_PWR/100))
	Filters:ApplyItemDamage(target, hero, damage, DAMAGE_TYPE_PHYSICAL, ability, RPC_ELEMENT_EARTH, RPC_ELEMENT_NORMAL)
	local stun_duration = ITEM_RPC_STONEBREAKER_GAUNTLET_STUN_DURATION + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_STONEBREAKER_GAUNTLET_GEM_EMERALD2)
	Filters:ApplyStun(hero, stun_duration, target)
	EmitSoundOn("RPCItems.Stonebreaker.Impact", target)
	if extraData.fractures > 0 then
		local limit = extraData.fractures
		local enemies = FindUnitsInRadius(hero:GetTeamNumber(), target:GetAbsOrigin(), nil, ITEM_RPC_STONEBREAKER_GAUNTLET_EMERALD_FRACTURE_RANGE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				if enemy ~= target then
					ability:ThrowStonebreakerRock(target, enemy, 0)
					limit = limit - 1
					if limit == 0 then
						break
					end
				end
			end
		end
	end
    if ability:GetGemValue("ruby") > 0 then
    	hero:AddNewModifier(hero, ability, "modifier_stonebreaker_ruby", {duration = ITEM_RPC_STONEBREAKER_GAUNTLET_RUBY_DURATION})
    end
end

function modifierClass:OnAttackLanded(event)
	if not IsServer() then
		return false
	end
    local attacker = event.attacker
    if not self:ParentIsAttacker(event) then
        return
    end
    local target = event.target
    local ability = self:GetAbility()
    if ability:GetGemValue("ruby") > 0 then
    	attacker:AddNewModifier(attacker, ability, "modifier_stonebreaker_ruby", {duration = ITEM_RPC_STONEBREAKER_GAUNTLET_RUBY_DURATION})
    end
end

function modifierClass:GetRoshpitMasterGreenDMG()
	local ability = self:GetAbility()
	local hero = self:GetParent()
	if ability:GetGemValue("sapphire") > 0 then
		return hero:GetStrength()*ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_STONEBREAKER_GAUNTLET_GEM_SAPPHIRE)
	else
		return 0
	end
end

-- RUBY
function modifier_stonebreaker_ruby:GetEffectName()
	return "particles/roshpit/winterblight/red_buff.vpcf"
end

function modifier_stonebreaker_ruby:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end

function modifier_stonebreaker_ruby:RemoveOnDeath()
	return true
end

function modifier_stonebreaker_ruby:OnCreated()
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_STRENGTH_BONUS
    })
end

function modifier_stonebreaker_ruby:GetRoshpitStrengthBonus()
	local ability = self:GetAbility()
	return ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_STONEBREAKER_GAUNTLET_GEM_RUBY)
end

-- AMETHYST

function modifierClass:OnRChannelStart()
	local ability = self:GetAbility()
	local hero = self:GetParent()
	if ability:GetGemValue("amethyst") > 0 then
		hero:AddNewModifier(hero, ability, "modifier_stonebreaker_amethyst", {duration = 4})
	end
end

function modifierClass:OnRChannelEnd()
	local ability = self:GetAbility()
	local hero = self:GetParent()
	hero:RemoveModifierByName("modifier_stonebreaker_amethyst")
end

function modifier_stonebreaker_amethyst:IsHidden()
	return true
end

function modifier_stonebreaker_amethyst:OnCreated()
	local ability = self:GetAbility()
	self:StartIntervalThink(ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_STONEBREAKER_GAUNTLET_GEM_AMETHYST))
end

function modifier_stonebreaker_amethyst:OnIntervalThink()
	local ability = self:GetAbility()
	local hero = self:GetParent()
	local searchPoint = hero:GetAbsOrigin() + hero:GetForwardVector()*300
	local enemies = FindUnitsInRadius(hero:GetTeamNumber(), searchPoint, nil, ITEM_RPC_STONEBREAKER_GAUNTLET_AMETHYST_RANGE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
    	local fractures = ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_STONEBREAKER_GAUNTLET_GEM_EMERALD1)
	    ability:ThrowStonebreakerRock(hero, enemies[1], fractures)		
	end
end