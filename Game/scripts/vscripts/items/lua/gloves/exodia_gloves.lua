require('items/lua/gloves/base_glove')
require('npc_abilities/base_modifier')

item_rpc_exodia_gloves = class(BaseGloves, nil, BaseGloves)
local itemClass = item_rpc_exodia_gloves
local itemClassName = 'item_rpc_exodia_gloves'

modifier_exodia_gloves = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_exodia_gloves
local modifierName = 'modifier_exodia_gloves'
LinkLuaModifier(modifierName, "items/lua/gloves/exodia_gloves", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end

function itemClass:GetName()
    return 'Exodia Gloves'
end

function itemClass:GetModifierName()
    return modifierName
end

function itemClass:HasRuneSlots()
    return true
end

function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_exodia_gloves"
    self:SetSpecialValue("exodia_gloves", "#a8403d")
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
exodia_gloves_dummy_ability = class({})

function exodia_gloves_dummy_ability:OnProjectileHit_ExtraData(target, vLocation, extraData)
	self.exodia_gloves:ExodiaProjectileHit(target, extraData)
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
    	MODIFIER_ROSHPIT_MASTER_GREEN_DMG
    })
    local hero = self:GetParent()
    local ability = self:GetAbility()
    if not hero.InventoryUnit:HasAbility("exodia_gloves_dummy_ability") then
    	ability.dummyAbility = hero.InventoryUnit:AddAbility("exodia_gloves_dummy_ability")
    else
    	ability.dummyAbility = hero.InventoryUnit:FindAbilityByName("exodia_gloves_dummy_ability")
    end
    ability.dummyAbility:SetLevel(1)
    ability.dummyAbility.exodia_gloves = ability
end

function modifierClass:GetRoshpitMasterGreenDMG()
	local ability = self:GetAbility()
	local hero = self:GetParent()
	local manaMissingPercentage = math.ceil(((hero:GetMaxMana() - hero:GetMana())/hero:GetMaxMana())*100)
	return ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_EXODIA_GLOVES_GEM_EMERALD)*manaMissingPercentage
end

function modifierClass:OnDestroy()
    if not IsServer() then return end

    local hero = self:GetParent()
    local ability = self:GetAbility()
   	hero.InventoryUnit:RemoveAbility("exodia_gloves_dummy_ability")
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
    local hero = attacker
    local pfx = CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_void_spirit/void_spirit_wormhole_cast.vpcf", target, 3)
    ParticleManager:SetParticleControl(pfx, 1, hero:GetAbsOrigin()+Vector(0,0,60))
    local damage = OverflowProtectedGetAverageTrueAttackDamage(attacker) * (ITEM_RPC_EXODIA_GLOVES_DMG_PCT_ATK_POWER/100)
    damage = damage * (1 + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_EXODIA_GLOVES_GEM_SAPPHIRE)/100)
    Filters:ApplyItemDamage(target, attacker, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_COSMOS, RPC_ELEMENT_SHADOW)

    local search_range = ITEM_RPC_EXODIA_GLOVES_ENEMY_SEARCH_RANGE + ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_EXODIA_GLOVES_GEM_AMETHYST1)
	local limit = 2
	if ability:GetGemValue("ruby") > 0 then
		local proc_chance = ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_EXODIA_GLOVES_GEM_RUBY)
		local proc = Filters:GetProc(hero, proc_chance)
		if proc then
			limit = limit + 1
		end		
	end
	local enemies = FindUnitsInRadius(hero:GetTeamNumber(), target:GetAbsOrigin(), nil, search_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			if enemy ~= target then
				ability:ThrowExodiaProjectile(target, enemy, 0)
				limit = limit - 1
				if limit == 0 then
					break
				end
			end
		end
	end
end

function itemClass:ThrowExodiaProjectile(source, enemy, projectile_index)
	local ability = self
	local hero = self:GetCaster()
	local travel_speed = ITEM_RPC_EXODIA_GLOVES_PROJECTILE_SPEED * (1 + ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_EXODIA_GLOVES_GEM_AMETHYST2)/100)
	local info =
	{
		Target = enemy,
		Source = source,
		Ability = ability.dummyAbility,
		EffectName = "particles/roshpit/items/exodia_projectile.vpcf",
		StartPosition = "attach_hitloc",
		bDrawsOnMinimap = false,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		bProvidesVision = false,
		iMoveSpeed = travel_speed,
		iVisionTeamNumber = hero:GetTeamNumber(),
		ExtraData = {projectile_index = projectile_index}
	}
	ProjectileManager:CreateTrackingProjectile(info)		
end

function itemClass:ExodiaProjectileHit(target, extraData)
	EmitSoundOn("RPCItems.ExodiaGloves.Impact", target)
	local hero = self:GetCaster()
    local damage = OverflowProtectedGetAverageTrueAttackDamage(hero) * (ITEM_RPC_EXODIA_GLOVES_DMG_PCT_ATK_POWER/100)
    Filters:ApplyItemDamage(target, hero, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_COSMOS, RPC_ELEMENT_SHADOW)
    local ability = self
    if extraData.projectile_index == 0 then
    	local search_range = ITEM_RPC_EXODIA_GLOVES_ENEMY_SEARCH_RANGE + ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_EXODIA_GLOVES_GEM_AMETHYST1)	
		local limit = 2
		local enemies = FindUnitsInRadius(hero:GetTeamNumber(), target:GetAbsOrigin(), nil, search_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				if enemy ~= target then
					ability:ThrowExodiaProjectile(target, enemy, 1)
					limit = limit - 1
					if limit == 0 then
						break
					end
				end
			end
		end
	end
end