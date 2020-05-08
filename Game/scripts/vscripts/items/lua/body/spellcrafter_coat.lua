require('items/lua/body/base_chest')
require('npc_abilities/base_modifier')

item_rpc_spellcrafter_coat = class(BaseBody, nil, BaseBody)
modifier_spellcrafter_coat = class(npc_base_modifier, nil, npc_base_modifier)
local itemClass = item_rpc_spellcrafter_coat
local itemClassName = 'item_rpc_spellcrafter_coat'

local modifierClass = modifier_spellcrafter_coat
local modifierName = 'modifier_spellcrafter_coat'
LinkLuaModifier(modifierName, "items/lua/body/spellcrafter_coat", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'Spellcrafter Coat'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:HasRuneSlots()
    return true
end
function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_spellcrafter_coat"
    self:SetSpecialValue("spellcrafter_coat", "#d66dbe")
end
function itemClass:RollProperty2(item_level)
    local attr_rolls = {"strength", "agility", "intelligence", "spirit"}
    local attr_roll = attr_rolls[RandomInt(1, #attr_rolls)]
    RPCItems:RollBasicItemProperty(self, item_slot, 2, item_level, attr_roll, 2)
end

function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 0)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 3.5)
end

-- DUMMY ABILITY -- 
spellcrafter_dummy_ability = class({})

function spellcrafter_dummy_ability:OnProjectileHit_ExtraData(target, vLocation, extraData)
	self.spellcrafter:SpellCrafterProjectileHit(target, extraData)
end

------------
--MODIFIER--
------------

function modifierClass:IsHidden()
    return true
end

function modifierClass:IsBuff()
    return true
end

function modifierClass:RemoveOnDeath()
    return false
end

function modifierClass:OnCreated()
    if not IsServer() then return end

    self:SetSpecialTypes({ 
        MODIFIER_SPECIAL_TYPE_CAST_W_ABILITY
    })
    local hero = self:GetParent()
    local ability = self:GetAbility()
    if not hero.InventoryUnit:HasAbility("spellcrafter_dummy_ability") then
    	ability.dummyAbility = hero.InventoryUnit:AddAbility("spellcrafter_dummy_ability")
    else
    	ability.dummyAbility = hero.InventoryUnit:FindAbilityByName("spellcrafter_dummy_ability")
    end
    ability.dummyAbility:SetLevel(1)
    ability.dummyAbility.spellcrafter = ability
end

function modifierClass:OnDestroy()
    if not IsServer() then return end

    self:SetSpecialTypes({ 
        MODIFIER_SPECIAL_TYPE_CAST_W_ABILITY
    })
    local hero = self:GetParent()
    local ability = self:GetAbility()
   	hero.InventoryUnit:RemoveAbility("spellcrafter_dummy_ability")
end

function modifierClass:DeclareFunctions()
    local funcs = {

    }
    return funcs
end

function modifierClass:OnCastWAbility()
	local hero = self:GetParent()
	local ability = self:GetAbility()
	local caster = self:GetCaster()

	ability:SetProjectileParticle()

	local aoe = ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_SPELLCRAFTER_COAT_GEM_RUBY1)
	local fractures = ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_SPELLCRAFTER_COAT_GEM_SAPPHIRE1)
	local bounces = ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_SPELLCRAFTER_COAT_GEM_AMETHYST1)

	local searchPosition = hero:GetAbsOrigin() + hero:GetForwardVector()*(ITEM_RPC_SPELLCRAFTER_COAT_RANGE/2 - 100)
	local searchRadius = ITEM_RPC_SPELLCRAFTER_COAT_RANGE
	local enemies = FindUnitsInRadius(hero:GetTeamNumber(), searchPosition, nil, searchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	if #enemies > 0 then
		local target = enemies[1]
		ability:ShootCrafterProjectile(hero, hero, target, bounces, fractures, aoe)
		EmitSoundOn("RPCItems.Spellcrafter.Fire", hero)
	end
end


function itemClass:SetProjectileParticle()
	local element1 = self:GetDamageElement1()
	local element2 = self:GetDamageElement2()
	local particleName = "particles/roshpit/items/spellcrafter_coat/projectile_white.vpcf"
	if (element1 == RPC_ELEMENT_FIRE and element2 == RPC_ELEMENT_ICE) or (element1 == RPC_ELEMENT_ICE and element2 == RPC_ELEMENT_FIRE) then
		particleName = "particles/roshpit/items/spellcrafter_coat/projectile_dual_rb.vpcf"
	elseif (element1 == RPC_ELEMENT_FIRE and element2 == RPC_ELEMENT_WIND) or (element1 == RPC_ELEMENT_WIND and element2 == RPC_ELEMENT_FIRE) then
		particleName = "particles/roshpit/items/spellcrafter_coat/projectile_dual_rg.vpcf"
	elseif (element1 == RPC_ELEMENT_FIRE and element2 == RPC_ELEMENT_ARCANE) or (element1 == RPC_ELEMENT_ARCANE and element2 == RPC_ELEMENT_FIRE) then
		particleName = "particles/roshpit/items/spellcrafter_coat/projectile_dual_rp.vpcf"
	elseif (element1 == RPC_ELEMENT_ICE and element2 == RPC_ELEMENT_WIND) or (element1 == RPC_ELEMENT_WIND and element2 == RPC_ELEMENT_ICE) then
		particleName = "particles/roshpit/items/spellcrafter_coat/projectile_dual_bg.vpcf"
	elseif (element1 == RPC_ELEMENT_ICE and element2 == RPC_ELEMENT_ARCANE) or (element1 == RPC_ELEMENT_ARCANE and element2 == RPC_ELEMENT_ICE) then
		particleName = "particles/roshpit/items/spellcrafter_coat/projectile_dual_bp.vpcf"
	elseif (element1 == RPC_ELEMENT_WIND and element2 == RPC_ELEMENT_ARCANE) or (element1 == RPC_ELEMENT_ARCANE and element2 == RPC_ELEMENT_WIND) then
		particleName = "particles/roshpit/items/spellcrafter_coat/projectile_dual_gp.vpcf"
	elseif (element1 == RPC_ELEMENT_FIRE and element2 == RPC_ELEMENT_NORMAL) or (element1 == RPC_ELEMENT_NORMAL and element2 == RPC_ELEMENT_FIRE) then
		particleName = "particles/roshpit/items/spellcrafter_coat/projectile_red.vpcf"
	elseif (element1 == RPC_ELEMENT_ICE and element2 == RPC_ELEMENT_NORMAL) or (element1 == RPC_ELEMENT_NORMAL and element2 == RPC_ELEMENT_ICE) then
		particleName = "particles/roshpit/items/spellcrafter_coat/projectile_blue.vpcf"
	elseif (element1 == RPC_ELEMENT_WIND and element2 == RPC_ELEMENT_NORMAL) or (element1 == RPC_ELEMENT_NORMAL and element2 == RPC_ELEMENT_WIND) then
		particleName = "particles/roshpit/items/spellcrafter_coat/projectile_green.vpcf"
	elseif (element1 == RPC_ELEMENT_ARCANE and element2 == RPC_ELEMENT_NORMAL) or (element1 == RPC_ELEMENT_NORMAL and element2 == RPC_ELEMENT_ARCANE) then
		particleName = "particles/roshpit/items/spellcrafter_coat/projectile_purple.vpcf"		
	end
	self.projectile_particle = particleName
end

function itemClass:GetProjectileParticle()
	return self.projectile_particle
end

function itemClass:ShootCrafterProjectile(hero, source, target, bounces, fractures, aoe)
	local travel_speed = ITEM_RPC_SPELLCRAFTER_COAT_PROJECTILE_SPEED_BASE + self:GetFinalGemPropertyValue("emerald", ITEM_RPC_SPELLCRAFTER_COAT_GEM_EMERALD1)
	local info =
	{
		Target = target,
		Source = source,
		Ability = self.dummyAbility,
		EffectName = self:GetProjectileParticle(),
		StartPosition = "attach_attack1",
		bDrawsOnMinimap = false,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		bProvidesVision = false,
		iMoveSpeed = travel_speed,
		iVisionTeamNumber = hero:GetTeamNumber(),
		ExtraData = {bounces = bounces, fractures = fractures, aoe = aoe}
	}
	ProjectileManager:CreateTrackingProjectile(info)
end

function itemClass:SpellCrafterProjectileHit(target, extraData)
	local hero = self:GetCaster()
	local ability = self
	local caster = self:GetCaster()
	-- EmitSoundOn("RPCItems.ShadowguardHelm.Impact", target)

	local damage = ability:GetAbilityImpactDamage()
	local element1 = ability:GetDamageElement1()
	local element2 = ability:GetDamageElement2()
	if not target:IsAlive() then
		return
	end
	EmitSoundOn("RPCItems.Spellcrafter.Impact", target)
	local damage_targets = {}
	if extraData.aoe > 0 then
		damage_targets = FindUnitsInRadius(hero:GetTeamNumber(), target:GetAbsOrigin(), nil, extraData.aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
        local pfx = CustomAbilities:QuickParticleAtPoint("particles/roshpit/items/spellcrafter_coat/fire_aoe.vpcf", target:GetAbsOrigin(), 1)
        ParticleManager:SetParticleControl(pfx, 1, Vector(extraData.aoe*1.1, 2, extraData.aoe/2))
	else
		table.insert(damage_targets, target)
	end
	for _, enemy in pairs(damage_targets) do
		Filters:ApplyItemDamage(enemy, hero, damage, DAMAGE_TYPE_MAGICAL, ability, element1, element2)
	end
	if extraData.bounces > 0 then
		local bounce_targets = FindUnitsInRadius(hero:GetTeamNumber(), target:GetAbsOrigin(), nil, ITEM_RPC_SPELLCRAFTER_COAT_GEM_AMETHYST_RANGE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local bounce_target = nil
		for _, search_enemy in pairs(bounce_targets) do
			if search_enemy ~= target then
				bounce_target = search_enemy break
			end
		end
		if bounce_target then
			self:ShootCrafterProjectile(hero, target, bounce_target, extraData.bounces - 1, extraData.fractures, extraData.aoe)
		end
	end
	if extraData.fractures > 0 then
		local possible_fracture_targets = FindUnitsInRadius(hero:GetTeamNumber(), target:GetAbsOrigin(), nil, ITEM_RPC_SPELLCRAFTER_COAT_GEM_AMETHYST_RANGE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local fracture_count = 0
		local fracture_targets = {}
		for _, search_enemy in pairs(possible_fracture_targets) do
			if search_enemy ~= target then
				fracture_count = fracture_count + 1
				table.insert(fracture_targets, search_enemy)
				if fracture_count >= extraData.fractures then
					break
				end
			end
		end
		-- maybe set bounces to 0
		for i = 1, #fracture_targets, 1 do
			self:ShootCrafterProjectile(hero, target, fracture_targets[i], extraData.bounces - 1, 0, extraData.aoe)
		end
	end	
end

-- bounces fracture, fractures dont bounce

function itemClass:GetAbilityImpactDamage()
	local ability = self
	local hero = self:GetCaster()
	local damage = OverflowProtectedGetAverageTrueAttackDamage(hero)*(ITEM_RPC_SPELLCRAFTER_COAT_BASE_DMG_ATK_POWER/100)
	damage = damage + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_SPELLCRAFTER_COAT_GEM_RUBY2)*hero:GetStrength()
	damage = damage + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_SPELLCRAFTER_COAT_GEM_EMERALD2)*hero:GetAgility()
	damage = damage + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_SPELLCRAFTER_COAT_GEM_SAPPHIRE2)*hero:GetIntellect()
	damage = damage + ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_SPELLCRAFTER_COAT_GEM_AMETHYST2)*hero:GetSpirit()
	return damage
end

function itemClass:GetDamageElement1()
	local ability = self
	if ability.newItemTable.socket1 == "ruby" then
		return RPC_ELEMENT_FIRE
	elseif ability.newItemTable.socket1 == "sapphire" then
		return RPC_ELEMENT_ICE
	elseif ability.newItemTable.socket1 == "emerald" then
		return RPC_ELEMENT_WIND
	elseif ability.newItemTable.socket1 == "amethyst" then
		return RPC_ELEMENT_ARCANE
	else
		return RPC_ELEMENT_NORMAL
	end
end

function itemClass:GetDamageElement2()
	local ability = self
	if ability.newItemTable.socket2 == "ruby" then
		return RPC_ELEMENT_FIRE
	elseif ability.newItemTable.socket2 == "sapphire" then
		return RPC_ELEMENT_ICE
	elseif ability.newItemTable.socket2 == "emerald" then
		return RPC_ELEMENT_WIND
	elseif ability.newItemTable.socket2 == "amethyst" then
		return RPC_ELEMENT_ARCANE
	else
		return RPC_ELEMENT_NORMAL
	end
end