LinkLuaModifier("modifier_super_ascendency_lua", "modifiers/modifier_super_ascendency", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_knight_hawk_lua", "modifiers/modifier_knight_hawk_lua", LUA_MODIFIER_MOTION_NONE)

require('items/constants/boots')
require('items/constants/chest')
require('items/constants/gloves')
require('items/constants/helm')
require('items/constants/trinket')
require('util')

function astral_glyph_4_1_apply(event)
	local target = event.target
	local ability = target:GetAbilityByIndex(DOTA_E_SLOT)
	if not ability then return end
	if not target.saveECastPoint then
		target.saveECastPoint = ability:GetCastPoint()
	end
	ability:SetOverrideCastPoint(0)
end

function astral_glyph_4_1_remove(event)
	local target = event.target
	local ability = target:GetAbilityByIndex(DOTA_E_SLOT)
	if not ability or not target.saveECastPoint then return end
	ability:SetOverrideCastPoint(target.saveECastPoint)
end

function paladin_2_1_destroy(event)
	local caster = event.target
	local ability = caster:FindAbilityByName("heroic_fury")
	local cd = ability:GetCooldownTimeRemaining()
	if ability:GetToggleState() then
		ability:ToggleAbility()
	end
	ability:EndCooldown()
	ability:StartCooldown(cd)
	caster:RemoveModifierByName("modifier_paladin_q")
	caster:RemoveModifierByName("modifier_paladin_q2_aura")
end

function steelbark_think(event)
	local caster = event.caster
	local target = event.target
	if target:GetHealth() / target:GetMaxHealth() <= 0.4 then
		local ability = caster:FindAbilityByName("body_slot")
		ability:ApplyDataDrivenModifier(caster, target, "modifier_body_steelbark_effect", {})
	else
		target:RemoveModifierByName("modifier_body_steelbark_effect")
	end
end

function berserker_attack_landed(event)
	local attacker = event.attacker
	local caster = event.caster
	local ability = event.ability
	local luck = RandomInt(1, 10)
	if luck == 1 then
		ability:ApplyDataDrivenModifier(caster, attacker, "modifier_hand_berserker_state", {duration = 5})
	end
end

function shadow_armlet_take_damage(event)
	local ability = event.ability
	local caster = event.caster
	local attack_damage = event.attack_damage
	local target = event.unit
	local proc = Filters:GetProc(target, 15)
	if proc then
		Filters:ApplyHeal(target, target, attack_damage, true)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_shadow_armlet_effect", {duration = 1})
	end
end

function boneguard_attack_land(event)
	local target = event.target
	local ability = event.ability
	local attacker = event.attacker
	local proc = Filters:GetProc(attacker, 15)
	if not ability.skeletonLimit then
		ability.skeletonLimit = 0
	end
	if proc then
		if ability.skeletonLimit <= 4 then
			ability.skeletonLimit = ability.skeletonLimit + 1
			local skeleton = CreateUnitByName("basic_skeleton", target:GetAbsOrigin(), true, nil, nil, attacker:GetTeamNumber())
			skeleton.summonAbility = ability
			skeleton.owner = attacker:GetPlayerOwnerID()
			skeleton:SetOwner(attacker)

			local skeleHealth = 8400
			skeleHealth = Filters:AdjustItemDamage(attacker, skeleHealth, nil)
			skeleton:SetMaxHealth(skeleHealth)
			skeleton:SetBaseMaxHealth(skeleHealth)
			skeleton:SetHealth(skeleHealth)
			skeleton:Heal(skeleHealth, skeleton)

			skeleton:SetControllableByPlayer(attacker:GetPlayerID(), true)
			skeleton:AddAbility("ability_die_after_time_raise_dead"):SetLevel(1)
			local summonAbil = skeleton:AddAbility("ability_summoned_unit")
			summonAbil:SetLevel(1)
			summonAbil:ApplyDataDrivenModifier(skeleton, skeleton, "modifier_summoned_unit_damage_increase", {duration = 30})
			skeleton:SetModifierStackCount("modifier_summoned_unit_damage_increase", summonAbil, 70)
		end
	end
end

function midas_attack_land(event)
	local caster = event.attacker
	local runeUnit = event.caster
	local target = event.target
	local ability = event.ability
	local proc = Filters:GetProc(caster, 20)
	if proc then
		local position = target:GetAbsOrigin()
		local radius = 340
		local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * 50
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				Filters:ApplyItemDamage(enemy, caster, damage, DAMAGE_TYPE_PURE, ability, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
				if not enemy:HasModifier("modifier_midas_freeze_immune") then
					ability:ApplyDataDrivenModifier(runeUnit, enemy, "modifier_midas_freeze", {duration = 2})
					ability:ApplyDataDrivenModifier(runeUnit, enemy, "modifier_midas_freeze_immune", {duration = 5})
				end
			end
		end
		local particleName = "particles/econ/items/luna/luna_lucent_ti5_gold/luna_lucent_beam_impact_ti_5_gold.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)
		ParticleManager:SetParticleControlEnt(pfx, 2, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)

		Timers:CreateTimer(3, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		EmitSoundOn("Items.RPCHandOfMidas", target)
	end
end

function scorch_attack_land(event)
	local target = event.target
	local ability = event.ability
	local attacker = event.attacker
	local caster = event.caster
	local proc = Filters:GetProc(caster, 20)
	if proc then
		EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "RPCItem.HighFlameStart", attacker)
		ability.attacker = attacker

		CustomAbilities:QuickAttachThinker(ability, caster, target:GetAbsOrigin(), "modifier_hand_scorched_earth_thinker", {})
		if ability:GetAbilityName() == "item_rpc_scorched_gauntlets_2" then
			HighFlameThrow(attacker, ability, target)
		end
	end
end

function scorched_earth_damage(event)
	local target = event.target
	local ability = event.ability
	local attacker = ability.attacker
	local damage = OverflowProtectedGetAverageTrueAttackDamage(ability.attacker) * event.attack_mult / 100 + ability.attacker:GetPhysicalArmorValue(false) * event.armor_mult
	Filters:ApplyItemDamage(target, attacker, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
end

function HighFlameThrow(caster, ability, victim)
	local target = victim:GetAbsOrigin() + RandomVector(RandomInt(80, 300))
	local zDifferential = target.z - victim:GetAbsOrigin().z
	local baseFV = (target * Vector(1, 1, 0) - victim:GetAbsOrigin() * Vector(1, 1, 0)):Normalized()
	local forwardVelocity = WallPhysics:GetDistance2d(target, victim:GetAbsOrigin()) / 32 + 1
	--print(caster:GetAttachmentOrigin(2))
	local startPosition = victim:GetAbsOrigin()
	local fvModifier = ((caster:GetAbsOrigin() - startPosition) * Vector(1, 1, 0)):Normalized()
	local fvModifierDivisor = 2.8 / forwardVelocity
	local adjustedFV = (baseFV + (fvModifier * fvModifierDivisor)):Normalized()
	local randomOffset = 0
	-- local flareAngle = WallPhysics:rotateVector(baseFV, math.pi*randomOffset/160)
	local flare = CreateUnitByName("selethas_boomerang", startPosition, false, caster, nil, caster:GetTeamNumber())
	flare:SetOriginalModel("models/props_gameplay/rune_arcane.vmdl")
	flare:SetModel("models/props_gameplay/rune_arcane.vmdl")
	flare:SetRenderColor(240, 110, 20)
	flare:SetModelScale(0.05)
	flare.fv = adjustedFV
	flare.stun_duration = 1.6
	flare.liftVelocity = 60 + zDifferential / 20
	flare.forwardVelocity = forwardVelocity
	flare.interval = 0
	flare.damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * 2
	flare.origCaster = caster
	flare.origAbility = ability

	flare:AddAbility("high_flame_bomb_ability"):SetLevel(1)
	local flareSubAbility = flare:FindAbilityByName("high_flame_bomb_ability")
	flareSubAbility:ApplyDataDrivenModifier(flare, flare, "modifier_water_bomb_motion", {})
end

function high_flame_bomb_thinking(event)
	local caster = event.caster
	local ability = event.ability
	caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, caster.liftVelocity) + caster.fv * caster.forwardVelocity)
	caster.liftVelocity = caster.liftVelocity - 3
	local maxScale = 0.35
	if caster.altMaxScale then
		maxScale = caster.altMaxScale
	end
	caster:SetModelScale(0.01)
	local newFV = WallPhysics:rotateVector(caster:GetForwardVector(), math.pi / 30)
	caster:SetForwardVector(newFV)
	caster:SetAngles(caster.interval * 7, caster.interval * 7, caster.interval * 7)
	caster.interval = caster.interval + 1
	local groundHeight = GetGroundHeight(caster:GetAbsOrigin(), caster)
	if caster:GetAbsOrigin().z - groundHeight < 10 then
		EmitSoundOn("RPCItem.HighFlameImpact", caster)
		caster:RemoveModifierByName("modifier_water_bomb_motion")
		highFlameImpact(caster, ability, caster:GetAbsOrigin(), caster.damage)
		caster:SetAbsOrigin(caster:GetAbsOrigin() - Vector(0, 0, 1000))
		Timers:CreateTimer(0.1, function()
			caster:SetModelScale(0.01)
			Timers:CreateTimer(1, function()
				UTIL_Remove(caster)
			end)
		end)
	end
end

function highFlameImpact(caster, ability, position, damage)
	local radius = 320
	local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
	local particle2 = ParticleManager:CreateParticle(particleNameS, PATTACH_WORLDORIGIN, target)
	ParticleManager:SetParticleControl(particle2, 0, position)
	ParticleManager:SetParticleControl(particle2, 1, Vector(radius, radius, radius))
	ParticleManager:SetParticleControl(particle2, 2, Vector(2.0, 2.0, 2.0))
	ParticleManager:SetParticleControl(particle2, 4, Vector(255, 140, 20))
	Timers:CreateTimer(1.5, function()
		ParticleManager:DestroyParticle(particle2, false)
	end)
	--caster.origAbility:ApplyDataDrivenThinker(caster.origCaster.InventoryUnit, position, "modifier_hand_scorched_earth_thinker", {})
	CustomAbilities:QuickAttachThinker(caster.origAbility, caster.origCaster.InventoryUnit, position, "modifier_hand_scorched_earth_thinker", {})

	local particleName = "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControl(particle1, 0, position)
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
	-- EmitSoundOn("Items.LavaforgeImpact", target)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:ApplyItemDamage(enemy, caster.origCaster, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
			Filters:ApplyStun(caster.origCaster, 1.6, enemy)
		end
	end

end

function pride_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local proc = Filters:GetProc(caster.hero, 3)
	if proc then
		for i = 1, #MAIN_HERO_TABLE, 1 do
			ability:ApplyDataDrivenModifier(caster, MAIN_HERO_TABLE[i], "modifier_hand_pride_effect", {duration = 5})
			EmitSoundOn("Hero_Gyrocopter.ART_Barrage.Launch", MAIN_HERO_TABLE[i])
		end
	end
end

function marauder_attack_land(event)
	local attacker = event.attacker
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, attacker, "modifier_hand_marauder_effect", {duration = 7})
	local current_stack = attacker:GetModifierStackCount("modifier_hand_marauder_effect", ability)
	if current_stack < 50 then
		attacker:SetModifierStackCount("modifier_hand_marauder_effect", ability, current_stack + 1)
	end
end

function flood_water_elemental_attack(event)
	--print("flood attack")
	local ability = event.ability
	local target = event.target
	local attacker = event.attacker
	if attacker.summoner then
		local caster = attacker.summoner
		if IsValidEntity(caster) then
			local particleName = "particles/items3_fx/mango_active.vpcf"
			local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
			Timers:CreateTimer(1, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
			local manaRestore = caster:GetMaxMana() * 0.05
			manaRestore = WallPhysics:round(manaRestore, 0)
			caster:GiveMana(manaRestore)
			PopupMana(caster, manaRestore)
		end
	end
	local radius = 340

	local particleName = "particles/units/heroes/hero_slardar/slardar_crush_water.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
	local origin = target:GetAbsOrigin()
	ParticleManager:SetParticleControl(particle1, 0, origin)
	ParticleManager:SetParticleControl(particle1, 1, Vector(radius, 2, 160))
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)

	local damage = OverflowProtectedGetAverageTrueAttackDamage(attacker)
	local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	local bElemental3 = false
	if attacker:GetUnitName() == "water_elemental_flood_3" then
		bElemental3 = true
	end
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			if bElemental3 then
				Filters:TakeArgumentsAndApplyDamage(enemy, attacker.summoner, damage, DAMAGE_TYPE_MAGICAL, 4)
			else
				ApplyDamage({victim = enemy, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
			end
		end
	end
end

function flood_water_elemental_think(event)
	local ability = event.ability
	local caster = event.caster
	--print("ELEMENTAL THINK?")
	--print(caster:HasAbility("water_flood_nuke"))
	if caster:HasAbility("water_flood_nuke") then
		--print("AER WE HERE??")
		local nukeAbility = caster:FindAbilityByName("water_flood_nuke")
		if nukeAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				local castPoint = enemies[1]:GetAbsOrigin()
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = nukeAbility:entindex(),
					Position = castPoint
				}
				ExecuteOrderFromTable(newOrder)
				return
			end
		end
	end
	local summoner = caster.summoner
	if IsValidEntity(summoner) then
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), summoner:GetAbsOrigin())
		if distance > 1500 then
			caster:MoveToPositionAggressive(summoner:GetAbsOrigin() + RandomVector(240))
		end
	end
end

function flood_elemental_wave_hit(event)
	local target = event.target
	local caster = event.caster
	local summoner = caster.summoner
	if IsValidEntity(summoner) then
		local ability = caster.summoner.body
		local damage = Filters:AdjustItemDamage(summoner, OverflowProtectedGetAverageTrueAttackDamage(summoner), nil)
		if caster:GetUnitName() == "water_elemental_flood_2" then
			ApplyDamage({victim = target, attacker = summoner, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
		elseif caster:GetUnitName() == "water_elemental_flood_3" then
			Filters:TakeArgumentsAndApplyDamage(target, summoner, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_R, RPC_ELEMENT_WATER, RPC_ELEMENT_ICE)
		end
	end
end

function BodyProjectileStrike(event)
	local ability = event.ability
	local caster = ability.caster
	local target = event.target
	local primeAttribute = caster:GetPrimaryAttribute()
	local damage = 0
	if primeAttribute == 0 then
		damage = caster:GetStrength() * 5
	elseif primeAttribute == 1 then
		damage = caster:GetAgility() * 5
	elseif primeAttribute == 2 then
		damage = caster:GetIntellect() * 5
	end
	Filters:ApplyItemDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
end

function doomplate_damage(event)
	local target = event.target
	local caster = target.doomplateCaster
	local primeAttribute = caster:GetPrimaryAttribute()
	local damage = 0
	if primeAttribute == 0 then
		damage = caster:GetStrength() * 15
	elseif primeAttribute == 1 then
		damage = caster:GetAgility() * 15
	elseif primeAttribute == 2 then
		damage = caster:GetIntellect() * 15
	end
	Filters:ApplyItemDamage(target, caster, damage, DAMAGE_TYPE_PURE, event.ability)
end

function hyper_visor_attack_land(event)
	local target = event.target
	local ability = event.ability
	local attacker = event.attacker
	local proc = Filters:GetProc(attacker, 20)
	local agilityMult = ability:GetSpecialValueFor("property_two")
	if proc then
		local damage = OverflowProtectedGetAverageTrueAttackDamage(attacker) * agilityMult
		local radius = 450
		local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				Filters:ApplyItemDamage(enemy, attacker, damage, DAMAGE_TYPE_MAGICAL, event.ability, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
			end
		end
		local pfx = ParticleManager:CreateParticle("particles/econ/items/sven/sven_warcry_ti5/hyper_visor.vpcf", PATTACH_CUSTOMORIGIN, target)
		ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 0, 0))
		ParticleManager:SetParticleControl(pfx, 3, Vector(0, 0, 0))
		Timers:CreateTimer(1.5, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		EmitSoundOn("Hero_StormSpirit.Orchid_BallLightning", target)
	else
		local damage = OverflowProtectedGetAverageTrueAttackDamage(attacker) * agilityMult
		Filters:ApplyItemDamage(target, attacker, damage, DAMAGE_TYPE_MAGICAL, event.ability, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
	end
end

function ruby_dragon_immolation_think(event)
	local caster = event.caster
	local ability = event.ability
	local burnDamage = caster.burnDamage
	local summoner = caster.summoner
	local radius = 180
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:ApplyItemDamage(enemy, summoner, burnDamage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_immolation_burn", {duration = 0.5})
		end
	end
end

function centaur_horn_think(event)
	local inv_unit = event.caster
	local caster = event.target
	local ability = event.ability
	if not ability.interval then
		ability.interval = 0
	end
	ability.interval = ability.interval + 1
	if ability.interval == 30 then
		ability.interval = 0
		CustomAbilities:QuickAttachParticle("particles/roshpit/centaur_horns_lifesteal.vpcf", caster, 0.9)
	end
	ApplyDamage({victim = caster, attacker = caster, damage = 1, damage_type = DAMAGE_TYPE_PURE, ability = ability})
	if caster:IsStunned() then
		Filters:CleanseStuns(caster)
	end
	if not caster:IsAlive() then
		if caster:GetTimeUntilRespawn() == 0 then
			if not caster:GetUnitName() == "npc_dota_hero_night_stalker" then
				--print("KILL!")
				caster:SetHealth(10)
				caster:ForceKill(true)
			end
		end
	end
end
function monkey_paw_think(event)
	local caster = event.target
	local ability = event.ability
	ApplyDamage({victim = caster, attacker = caster, damage = 1, damage_type = DAMAGE_TYPE_PURE})
end
function ankh_of_ancients_think(event)
	local caster = event.target
	local ability = event.ability
	local max_duration = event.max_duration
	if GameRules:GetGameTime() - caster.amulet.ankh_apply_time > max_duration then
		caster:RemoveModifierByName('modifier_ankh_of_the_ancients')
	end

	if caster:IsStunned() then
		Filters:CleanseStuns(caster)
	end
end
function ankh_of_ancients_end(event)
	local caster = event.target
	local ability = event.ability
	local cd_multiplier = event.cd_multiplier
	local ankh_duration = GameRules:GetGameTime() - caster.amulet.ankh_apply_time
	caster.amulet:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_ankh_of_ancients_cooldown", {duration = ankh_duration * cd_multiplier})
end

function wild_nature_struck(event)
	local attacker = event.attacker
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	local proc = Filters:GetProc(target, 30)
	if proc then
		attacker.entangler = target
		ability:ApplyDataDrivenModifier(caster, attacker, "modifier_wild_nature_entangle_effect", {duration = 3})
	end
end

function wild_nature_entangle_think(event)
	local target = event.target
	local caster = target.entangler
	local primeAttribute = caster:GetPrimaryAttribute()
	local damage = 0
	if primeAttribute == 0 then
		damage = caster:GetStrength() * 750
	elseif primeAttribute == 1 then
		damage = caster:GetAgility() * 750
	elseif primeAttribute == 2 then
		damage = caster:GetIntellect() * 750
	end
	Filters:ApplyItemDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, event.ability, RPC_ELEMENT_NATURE, RPC_ELEMENT_NONE)
end

function odin_attack(event)
	local target = event.target
	local attacker = event.attacker
	local attack_damage = event.attack_damage
	attack_damage = GameState:GetPostReductionPhysicalDamage(attack_damage, target:GetPhysicalArmorValue(false))
	local proc = Filters:GetProc(attacker, 5)
	if proc then
		ApplyDamage({victim = target, attacker = attacker, damage = attack_damage * 20, damage_type = DAMAGE_TYPE_PURE})
		PopupDamage(target, attack_damage * 20)
	end
end

function iron_colossus_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if not ability.attackSpeedGainStacks then
		ability.attackSpeedGainStacks = 0
	end
	if not ability.attackSpeedLossStacks then
		ability.attackSpeedLossStacks = 0
	end
	if not ability.attackRangeGainStacks then
		ability.attackRangeGainStacks = 0
	end
	if not ability.attackRangeLossStacks then
		ability.attackRangeLossStacks = 0
	end
	local attackSpeedGainIron = ability.attackSpeedGainStacks
	local attackSpeedLossIron = ability.attackSpeedLossStacks
	local attackRangeGainIron = ability.attackRangeGainStacks
	local attackRangeLossIron = ability.attackRangeLossStacks
	local attackSpeed = WallPhysics:round(target:GetAttackSpeed() * 100, 0) - attackSpeedGainIron + attackSpeedLossIron
	local attackRange = target:Script_GetAttackRange() - attackRangeGainIron + attackRangeLossIron

	if attackRange < IRON_COLOSSUS_ATT_RNG then
		if not target:HasModifier("modifier_colossus_attack_range_gain") then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_colossus_attack_range_gain", {})
		end
		target:SetModifierStackCount("modifier_colossus_attack_range_gain", ability, (IRON_COLOSSUS_ATT_RNG - attackRange))
		target:RemoveModifierByName("modifier_iron_colossus_attack_range_loss")
		ability.attackRangeGainStacks = IRON_COLOSSUS_ATT_RNG - attackRange
	else
		if not target:HasModifier("modifier_iron_colossus_attack_range_loss") then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_iron_colossus_attack_range_loss", {})
		end
		target:SetModifierStackCount("modifier_iron_colossus_attack_range_loss", ability, attackRange - IRON_COLOSSUS_ATT_RNG)
		target:RemoveModifierByName("modifier_iron_colossus_attack_range_gain")
		ability.attackRangeLossStacks = attackRange - IRON_COLOSSUS_ATT_RNG
	end
	if attackSpeed < IRON_COLOSSUS_ATT_SPD then
		if not target:HasModifier("modifier_colossus_attack_speed_gain") then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_colossus_attack_speed_gain", {})
		end
		target:SetModifierStackCount("modifier_colossus_attack_speed_gain", ability, (IRON_COLOSSUS_ATT_RNG - attackSpeed))
		target:RemoveModifierByName("modifier_iron_colossus_attack_speed_loss")
		ability.attackSpeedGainStacks = IRON_COLOSSUS_ATT_SPD - attackSpeed
	else
		if not target:HasModifier("modifier_iron_colossus_attack_speed_loss") then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_iron_colossus_attack_speed_loss", {})
		end
		target:SetModifierStackCount("modifier_iron_colossus_attack_speed_loss", ability, attackSpeed - IRON_COLOSSUS_ATT_SPD)
		target:RemoveModifierByName("modifier_iron_colossus_attack_speed_gain")
		ability.attackSpeedLossStacks = attackSpeed - IRON_COLOSSUS_ATT_SPD
	end
	if not target:HasModifier("modifier_iron_colossus_attack_damage_increase") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_iron_colossus_attack_damage_increase", {})
	end
	local damageIncrease = target:GetStrength()
	if not (target:GetModifierStackCount("modifier_iron_colossus_attack_damage_increase", ability) == damageIncrease) then
		target:SetModifierStackCount("modifier_iron_colossus_attack_damage_increase", ability, damageIncrease)
		ability.colossus_deltaDamage = damageIncrease
	end
end

function iron_colossus_attack(event)
	local attacker = event.attacker
	local target = event.target
	local damage = OverflowProtectedGetAverageTrueAttackDamage(attacker) * IRON_COLOSSUS_DMG_PER_ATT
	local ability = event.ability
	if not target.dummy then
		Filters:ApplyItemDamage(target, attacker, damage, DAMAGE_TYPE_PHYSICAL, ability, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
		Filters:ApplyStun(attacker, 0.5, target)
	end
end

function witch_hat_strike(event)
	local ability = event.ability
	local caster = ability.caster
	local target = event.target
	local damage = caster:GetIntellect() * event.int_mult
	ability:ApplyDataDrivenModifier(caster, target, "modifier_witch_hat_damage_amp", {duration = 8})
	local newStacks = math.min(target:GetModifierStackCount("modifier_witch_hat_damage_amp", caster) + 1, 10)
	target:SetModifierStackCount("modifier_witch_hat_damage_amp", caster, newStacks)

	Filters:ApplyItemDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, event.ability, RPC_ELEMENT_SHADOW, RPC_ELEMENT_NONE)
end

function emerald_douli_damage(event)
	local target = event.unit
	local damage = event.damage
	local manaDamage = math.floor(damage * 0.5)
	if target:GetMana() > manaDamage then
		target:Heal(manaDamage, target)
		target:ReduceMana(manaDamage / 3)
	end
end

function tyrius_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if not target:HasModifier("modifier_tyrius_buff") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_tyrius_buff", {})
	end
	target:SetModifierStackCount("modifier_tyrius_buff", ability, target:GetStrength())
end

function ice_quill_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster

	local threshold = 600
	if not target.ice_quill_mana_prev then
		target.ice_quill_mana_prev = target:GetMana()
		target.ice_quill_mana_loss = 0
		--print("HERE?")
	end
	local mana_lost = target.ice_quill_mana_prev - target:GetMana()
	--print(mana_lost)
	if mana_lost > 0 then
		target.ice_quill_mana_loss = target.ice_quill_mana_loss + mana_lost
		--print(target.ice_quill_mana_loss)
		if target.ice_quill_mana_loss > threshold then
			local addedStacks = math.floor(target.ice_quill_mana_loss / threshold)
			target.ice_quill_mana_loss = target.ice_quill_mana_loss % threshold
			ability:ApplyDataDrivenModifier(caster, target, "modifier_ice_quill_carapace_stack", {})
			local newstacks = target:GetModifierStackCount("modifier_ice_quill_carapace_stack", caster) + addedStacks
			target:SetModifierStackCount("modifier_ice_quill_carapace_stack", caster, newstacks)
		end
	end

	target.ice_quill_mana_prev = target:GetMana()
	--print("--------")
end

function ice_quill_spell_cast(event)
	local caster = event.caster
	local hero = event.unit
	local ability = event.ability
	if not hero:HasModifier("modifier_ice_quill_unloading") then
		if hero:HasModifier("modifier_ice_quill_carapace_stack") then
			local stacks = hero:GetModifierStackCount("modifier_ice_quill_carapace_stack", caster)
			local unload_duration = (stacks * 0.1) - 0.5
			ability:ApplyDataDrivenModifier(caster, hero, "modifier_ice_quill_unloading", {duration = unload_duration})
			hero:RemoveModifierByName("modifier_ice_quill_carapace_stack")
		end
	end

	-- CustomAbilities:IceQuill(event)
end

function ice_quill_unloading_think(event)
	local caster = event.caster
	local hero = event.target
	local ability = event.ability
	CustomAbilities:QuickAttachParticle("particles/roshpit/items/ice_quill_explosion.vpcf", hero, 3)
	EmitSoundOn("RPC.IceQuill", hero)
	local radius = 460
	local damage = OverflowProtectedGetAverageTrueAttackDamage(hero) * 4
	local enemies = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:ApplyItemDamage(enemy, hero, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_ICE, RPC_ELEMENT_NORMAL)
		end
	end
	local manaRestore = hero:GetMaxMana() * 0.01
	hero:GiveMana(manaRestore)
	PopupMana(hero, manaRestore)
end

function gryffin_think(event)
	local caster = event.caster
	local hero = caster.hero
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), hero:GetAbsOrigin())
	if distance > 3400 then
		caster:SetAbsOrigin(hero:GetAbsOrigin() + RandomVector(RandomInt(50, 200)))
	elseif distance > 320 then
		caster:MoveToPosition(hero:GetAbsOrigin() + RandomVector(RandomInt(50, 200)))
	end
	local allies = FindUnitsInRadius(hero:GetTeamNumber(), caster:GetAbsOrigin(), nil, 620, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #allies > 0 then
		for _, ally in pairs(allies) do
			local healAmount = math.floor(ally:GetMaxHealth() * 0.06)
			Filters:ApplyHeal(hero, ally, healAmount, true)
		end
	end
end

function ceremony_beast_think(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	caster:MoveToPosition(hero:GetAbsOrigin() + RandomVector(RandomInt(50, 200)))
	local position = caster:GetAbsOrigin()
	local radius = 820
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	local count = 0
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			local info =
			{
				Target = enemy,
				Source = caster,
				Ability = ability,
				EffectName = "particles/units/heroes/hero_lina/lina_base_attack.vpcf",
				StartPosition = "attach_hitloc",
				bDrawsOnMinimap = false,
				bDodgeable = true,
				bIsAttack = false,
				bVisibleToEnemies = true,
				bReplaceExisting = false,
				flExpireTime = GameRules:GetGameTime() + 4,
				bProvidesVision = true,
				iVisionRadius = 0,
				iMoveSpeed = 400,
			iVisionTeamNumber = caster:GetTeamNumber()}
			projectile = ProjectileManager:CreateTrackingProjectile(info)
			count = count + 1
			if count > 12 then
				break
			end
		end
	end
end

function ceremony_beast_projectile_strike(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
	local primeAttribute = hero:GetPrimaryAttribute()
	local damage = 0
	if primeAttribute == 0 then
		damage = hero:GetStrength() * 12
	elseif primeAttribute == 1 then
		damage = hero:GetAgility() * 12
	elseif primeAttribute == 2 then
		damage = hero:GetIntellect() * 12
	end
	--print(target)
	--print(hero)
	Filters:ApplyItemDamage(target, hero, damage, DAMAGE_TYPE_MAGICAL, event.ability, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
end

function midas_think(event)
	local target = event.target

	local ability = event.ability
	local caster = event.caster
	local gold = PlayerResource:GetGold(target:GetPlayerOwnerID())
	gold = target:GetGold()
	local stacks = gold / 200
	if not target:HasModifier("modifier_hand_of_midas_effect") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_hand_of_midas_effect", {})
	end
	target:SetModifierStackCount("modifier_hand_of_midas_effect", ability, stacks)
end

function weapon_critical_attack(event)
	local proc = Filters:GetProc(event.attacker, 20)
	if proc then
		local ability = event.ability
		local attacker = event.attacker
		local target = event.target
		local damage = event.attack_damage
		local stacks = attacker:GetModifierStackCount("modifier_weapon_critical_strike", ability)
		local critBonus = OverflowProtectedGetAverageTrueAttackDamage(attacker) * stacks / 100
		-- ApplyDamage({ victim = target, attacker = attacker, damage = critBonus, damage_type = DAMAGE_TYPE_PHYSICAL })
		Filters:ApplyDamageBasic(target, attacker, critBonus, DAMAGE_TYPE_PHYSICAL)
		PopupDamage(target, math.floor(damage + critBonus))
		EmitSoundOn("Hero_PhantomAssassin.CoupDeGrace", target)
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_chaos_knight/chaos_knight_weapon_blur_critical.vpcf", target, 0.5)
	end
end

function weapon_cleave_attack(event)
	local ability = event.ability
	local attacker = event.attacker
	local target = event.target
	local damage = OverflowProtectedGetAverageTrueAttackDamage(attacker)
	local stacks = attacker:GetModifierStackCount("modifier_weapon_splash_damage", ability)
	local radius = 240
	damage = damage * stacks / 100
	local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), target:GetAbsOrigin() + attacker:GetForwardVector() * 50, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:ApplyDamageBasic(enemy, attacker, damage, DAMAGE_TYPE_PHYSICAL)
			-- ApplyDamage({ victim = enemy, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL })
		end
	end
end

function dark_arts_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local stacks = math.floor(target:GetBaseIntellect() * 0.8)
	if not target:HasModifier("modifier_dark_arts_effect") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_dark_arts_effect", {})
	end
	target:SetModifierStackCount("modifier_dark_arts_effect", ability, stacks)
end

function blazing_fury_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local stacks = math.floor(target:GetBaseAgility() * 0.45, 0)
	if not target:HasModifier("modifier_blazing_fury_effect") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_blazing_fury_effect", {})
	end
	target:SetModifierStackCount("modifier_blazing_fury_effect", ability, stacks)
end

function scarecrow_gloves_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local stacks = math.floor(target:GetIntellect() * SCARECROW_GLOVES_MPREGEN_PER_INT)
	if not target:HasModifier("modifier_scarecrow_gloves_effect") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_scarecrow_gloves_effect", {})
	end
	target:SetModifierStackCount("modifier_scarecrow_gloves_effect", ability, stacks)
end

function legion_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local intStacks = math.floor(target:GetBaseIntellect() * 0.3)
	local agiStacks = math.floor(target:GetBaseAgility() * 0.3)
	local strStacks = math.floor(target:GetBaseStrength() * 0.3)
	if not target:HasModifier("modifier_legion_vestments_effect_str") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_legion_vestments_effect_str", {})
	end
	target:SetModifierStackCount("modifier_legion_vestments_effect_str", ability, strStacks)

	if not target:HasModifier("modifier_legion_vestments_effect_int") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_legion_vestments_effect_int", {})
	end
	target:SetModifierStackCount("modifier_legion_vestments_effect_int", ability, intStacks)

	if not target:HasModifier("modifier_legion_vestments_effect_agi") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_legion_vestments_effect_agi", {})
	end
	target:SetModifierStackCount("modifier_legion_vestments_effect_agi", ability, agiStacks)
end

function living_gauntlet_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if target:GetMana() <= target:GetMaxMana() * 0.25 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_living_gauntlet_effect", {})
	else
		target:RemoveModifierByName("modifier_living_gauntlet_effect")
	end
end

function phoenix_gloves_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local stacks = (target:GetMaxHealth() - target:GetHealth()) * PHOENIX_GLOVES_HP_REGEN_PER_MISSING_HP
	if not target:HasModifier("modifier_phoenix_gloves_effect") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_phoenix_gloves_effect", {})
	end
	ability:ApplyDataDrivenModifier(caster, target, "modifier_phoenix_gloves_attack_damage", {})
	local damageStacks = target:GetHealth() * PHOENIX_GLOVES_ATT_DMG_PER_HP
	target:SetModifierStackCount("modifier_phoenix_gloves_attack_damage", ability, damageStacks)
	target:SetModifierStackCount("modifier_phoenix_gloves_effect", ability, stacks)
end

function violet_boot_impact(event)
	local target = event.target
	local origCaster = event.ability.hero
	local damage = origCaster:GetAgility() * 20
	if target.paragon then
		damage = damage * 60
	end
	Filters:ApplyItemDamage(target, origCaster, damage, DAMAGE_TYPE_MAGICAL, event.ability, RPC_ELEMENT_SHADOW, RPC_ELEMENT_NONE)
end

function gunslinger_think(event)
	local target = event.target
	local ability = event.ability
	if not ability.lastPos then
		ability.lastPos = target:GetAbsOrigin()
	end
	if not ability.distanceMoved then
		ability.distanceMoved = 0
	end
	ability.newPos = target:GetAbsOrigin()
	ability.hero = target
	local distance = WallPhysics:GetDistance(ability.newPos, ability.lastPos)
	ability.distanceMoved = ability.distanceMoved + distance
	if ability.distanceMoved > 300 then
		for i = 1, ability.distanceMoved / 300, 1 do
			gunslingerProjectile(target, true, nil, nil, 0, nil)
			if i > 3 then
				break
			end
		end
		ability.distanceMoved = ability.distanceMoved % 300
	end

	ability.lastPos = target:GetAbsOrigin()
end

function gunslingerProjectile(caster, bInitial, slingerAbility, enemies, enemyIndex, dummy)
	if bInitial then
		dummy = CreateUnitByName("npc_dummy_unit", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
		dummy.owner = caster:GetPlayerOwnerID()

		slingerAbility = dummy:AddAbility("bladeslinger_boot_ability")
		slingerAbility:SetLevel(1)
		dummy:AddAbility("dummy_unit")
		dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
		slingerAbility.enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		enemies = slingerAbility.enemies
		slingerAbility.hero = caster
	end
	local source = enemies[enemyIndex]
	if bInitial then
		source = caster
	end
	if #enemies > enemyIndex then
		local info =
		{
			Target = enemies[enemyIndex + 1],
			Source = source,
			Ability = slingerAbility,
			EffectName = "particles/units/heroes/hero_bounty_hunter/bounty_hunter_suriken_toss.vpcf",
			StartPosition = "attach_hitloc",
			bDrawsOnMinimap = false,
			bDodgeable = true,
			bIsAttack = false,
			bVisibleToEnemies = true,
			bReplaceExisting = false,
			flExpireTime = GameRules:GetGameTime() + 4,
			bProvidesVision = true,
			iVisionRadius = 0,
			iMoveSpeed = 1100,
		iVisionTeamNumber = caster:GetTeamNumber()}
		projectile = ProjectileManager:CreateTrackingProjectile(info)
	end
	slingerAbility.enemyIndex = enemyIndex + 1
	if enemyIndex == #enemies then
		UTIL_Remove(dummy)
	end
end

function gunslinger_impact(event)
	local ability = event.ability
	local caster = event.caster
	local hero = ability.hero
	local target = event.target
	local damage = (hero:GetIntellect() + hero:GetStrength() + hero:GetAgility()) * 2
	EmitSoundOn("Hero_BountyHunter.Shuriken.Impact", caster)
	if ability.enemyIndex <= 4 then
		gunslingerProjectile(hero, false, ability, ability.enemies, ability.enemyIndex + 1, caster)
	else
		UTIL_Remove(caster)
	end
	Filters:ApplyItemDamage(target, hero, damage, DAMAGE_TYPE_PHYSICAL, event.ability)
end

function guardian_greaves_think(event)
	local target = event.target
	local ability = event.ability
	if not ability.lastPos then
		ability.lastPos = target:GetAbsOrigin()
	end
	if not ability.distanceMoved then
		ability.distanceMoved = 0
	end
	ability.newPos = target:GetAbsOrigin()
	ability.hero = target
	local distance = WallPhysics:GetDistance(ability.newPos, ability.lastPos)
	ability.distanceMoved = ability.distanceMoved + distance
	if ability.distanceMoved > 2500 then
		for i = 1, ability.distanceMoved / 2500, 1 do
			guardian_greaves_heal(target, ability)
			if i > 1 then
				break
			end
		end
		ability.distanceMoved = ability.distanceMoved % 2500
	end

	ability.lastPos = target:GetAbsOrigin()
end

function guardian_greaves_heal(hero, ability)
	local healthRestore = hero:GetStrength() * 5
	local manaRestore = hero:GetIntellect() * 5
	local armorStacks = hero:GetAgility() / 10
	local particleName = "particles/items3_fx/warmage.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, hero)
	ParticleManager:SetParticleControlEnt(pfx, 0, hero, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	EmitSoundOn("RoshpitItem.GuardianGreaves", hero)
	local allies = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
	if #allies > 0 then
		for _, ally in pairs(allies) do
			guardian_heal_ally(ally, healthRestore, manaRestore, armorStacks, ability, hero)
		end
	end

end

function guardian_heal_ally(ally, healthRestore, manaRestore, armorStacks, ability, hero)
	local particleName = "particles/items3_fx/warmage_recipient.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, ally)
	ParticleManager:SetParticleControlEnt(pfx, 0, ally, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", ally:GetAbsOrigin(), true)
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	-- EmitSoundOn("Item.GuardianGreaves", ally)
	Filters:ApplyHeal(hero, ally, healthRestore, true)
	Timers:CreateTimer(0.1, function()
		PopupMana(ally, manaRestore)
	end)
	ally:GiveMana(manaRestore)
	ability:ApplyDataDrivenModifier(hero.InventoryUnit, ally, "modifier_guardian_greaves_armor", {duration = 4})
	ally:SetModifierStackCount("modifier_guardian_greaves_armor", hero.InventoryUnit, armorStacks)
end

function tranquil_boots_think(event)
	local target = event.target
	local ability = event.ability
	if not ability.lastPos then
		ability.lastPos = target:GetAbsOrigin()
	end
	if not ability.distanceMoved then
		ability.distanceMoved = 0
	end
	ability.newPos = target:GetAbsOrigin()
	ability.hero = target
	local distance = WallPhysics:GetDistance(ability.newPos, ability.lastPos)
	ability.distanceMoved = ability.distanceMoved + distance
	if ability.distanceMoved > 200 then
		if not ability.active then
			StartSoundEvent("Hero_WitchDoctor.Voodoo_Restoration.Loop", target)
		end
		ability.active = true
		for i = 1, ability.distanceMoved / 200, 1 do
			tranquil_boots_heal(target)
			if i > 3 then
				break
			end
		end
		ability.distanceMoved = ability.distanceMoved % 200
	else
		if distance < 20 then
			ability.active = false
			StopSoundEvent("Hero_WitchDoctor.Voodoo_Restoration.Loop", target)
		end
	end

	ability.lastPos = target:GetAbsOrigin()
end

function tranquil_boots_heal(hero)
	local healthRestore = math.floor(hero:GetMaxHealth() * 0.1)
	local particleName = "particles/items2_fx/tranquil_boots.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, hero)
	ParticleManager:SetParticleControlEnt(pfx, 0, hero, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)
	Timers:CreateTimer(1, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	Filters:ApplyHeal(hero, hero, healthRestore, true)
end

function sange_boots_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if not target:HasModifier("modifier_rpc_sange_buff") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_rpc_sange_buff", {})
		ability:ApplyDataDrivenModifier(caster, target, "modifier_rpc_sange_buff_mana", {})
	end
	local sangeStacks = math.min(target:GetAgility(), math.floor(10000000 / SANGE_HP_PER_AGI))
	local sangeManaStacks = target:GetAgility() * SANGE_MP_PER_AGI
	target:SetModifierStackCount("modifier_rpc_sange_buff", ability, sangeStacks)
	target:SetModifierStackCount("modifier_rpc_sange_buff_mana", ability, sangeManaStacks)
end

function yasha_boots_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if not target:HasModifier("modifier_rpc_yasha_buff") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_rpc_yasha_buff", {})
	end
	target:SetModifierStackCount("modifier_rpc_yasha_buff", ability, target:GetStrength() / 20)
end

function mana_striders_think(event)
	local target = event.target
	local ability = event.ability
	if not ability.lastPos then
		ability.lastPos = target:GetAbsOrigin()
	end
	if not ability.distanceMoved then
		ability.distanceMoved = 0
	end
	ability.newPos = target:GetAbsOrigin()
	ability.hero = target
	local distance = WallPhysics:GetDistance(ability.newPos, ability.lastPos)
	ability.distanceMoved = ability.distanceMoved + distance
	if ability.distanceMoved > 240 then
		if not ability.active then
			-- StartSoundEvent("Hero_Leshrac.Diabolic_Edict_lp", target)
		end
		ability.active = true
		for i = 1, ability.distanceMoved / 240, 1 do
			mana_striders_heal(target)
			if i > 3 then
				break
			end
		end
		ability.distanceMoved = ability.distanceMoved % 240
	else
		if distance < 20 then
			ability.active = false
			-- StopSoundEvent("Hero_Leshrac.Diabolic_Edict_lp", target)
		end
	end

	ability.lastPos = target:GetAbsOrigin()
end

function mana_striders_heal(hero)
	local manaRestore = WallPhysics:round(hero:GetMaxMana() * 0.03, 0)
	local particleName = "particles/units/heroes/hero_obsidian_destroyer/obsidian_death_flash.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, hero)
	ParticleManager:SetParticleControlEnt(pfx, 0, hero, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)
	Timers:CreateTimer(1, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	hero:GiveMana(manaRestore)
	PopupMana(hero, manaRestore)
end

function fire_walkers_think(event)
	local caster = event.caster
	local ability = event.ability
	ability.hero = event.target
	ability.damage = ability.hero:GetIntellect() + ability.hero:GetAgility() + ability.hero:GetStrength()
	--ability:ApplyDataDrivenThinker(caster, ability.hero:GetAbsOrigin(), "modifier_fire_walker_thinker", {})
	CustomAbilities:QuickAttachThinker(ability, caster, ability.hero:GetAbsOrigin(), "modifier_fire_walker_thinker", {})
end

function fire_walker_damage(event)
	local target = event.target
	local caster = event.ability.hero
	local ability = event.ability
	if target.dummy then
		return false
	end
	local damage = ability.damage
	Filters:ApplyItemDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, event.ability, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
end

function moon_tech_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	--ability:ApplyDataDrivenThinker(caster, target:GetAbsOrigin(), "modifier_moon_tech_thinker", {})
	CustomAbilities:QuickAttachThinker(ability, caster, target:GetAbsOrigin(), "modifier_moon_tech_thinker", {})
end

function falcon_boot_impact(event)
	local target = event.target
	local ability = event.ability
	----print(event.target_entities[1]:GetUnitName())
	-- DeepPrintTable(event)
	if target:HasModifier("modifier_falcon_out") or target:HasModifier("modifier_falcon_lift_immune") then
		return false
	end
	if target.jumpLock then
		return false
	end
	local origCaster = event.ability.hero
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_beastmaster/beastmaster_call_bird_glow_base.vpcf", PATTACH_CUSTOMORIGIN, origCaster)
	ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin() + Vector(0, 0, 80))
	if not ability.liftedTargetsTable then
		ability.liftedTargetsTable = {}
	end
	ability:ApplyDataDrivenModifier(origCaster.InventoryUnit, target, "modifier_falcon_lift_immune", {duration = 3})
	table.insert(ability.liftedTargetsTable, target)
	Timers:CreateTimer(5.5, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:ReleaseParticleIndex(pfx)
	end)
	ability:ApplyDataDrivenModifier(origCaster.InventoryUnit, target, "modifier_falcon_out", {duration = 2.5})
	target:SetAbsOrigin(target:GetAbsOrigin() - Vector(0, 0, 2000))
end

function root_feet_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster

	ability:ApplyDataDrivenModifier(caster, target, "modifier_rooted_feet_health_regen", {})

end

function root_feet_move(event)
	local target = event.unit
	target:RemoveModifierByName("modifier_rooted_feet_health_regen")
end

function rooted_foot_created(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	Timers:CreateTimer(0.4, function()
		--print("AFTER TIMER?")
		if target:HasModifier("modifier_rooted_feet_applicator") then
			--print("attach particle")
			if not ability.pfx then
				ability.pfx = ParticleManager:CreateParticle("particles/roshpit/items/rooted_feet.vpcf", PATTACH_ABSORIGIN, target)
				ParticleManager:SetParticleControlEnt(ability.pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", target:GetAbsOrigin(), true)
			end
		end
	end)
end

function rooted_foot_regen_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, target, "modifier_rooted_feet_applicator", {})
	local currentStacks = target:GetModifierStackCount("modifier_rooted_feet_armor_portion", caster)
	local armor = Filters:GetBaseBaseArmor(target)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_rooted_feet_armor_portion", {})
	target:SetModifierStackCount("modifier_rooted_feet_armor_portion", caster, armor)
	local currentRegenStacks = target:GetModifierStackCount("modifier_rooted_feet_regen_portion", caster)
	local regen = (target:GetHealthRegen() - currentRegenStacks) * 2
	ability:ApplyDataDrivenModifier(caster, target, "modifier_rooted_feet_regen_portion", {})
	target:SetModifierStackCount("modifier_rooted_feet_regen_portion", caster, regen)
end

function rooted_foot_end(event)
	local ability = event.ability
	if ability.pfx then
		event.target:RemoveModifierByName("modifier_rooted_feet_applicator")
		ParticleManager:DestroyParticle(ability.pfx, false)
	end
	ability.pfx = false
end

function sapphire_lotus_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if not target:HasModifier("modifier_sapphire_lotus_buff") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_sapphire_lotus_buff", {})
		ability:ApplyDataDrivenModifier(caster, target, "modifier_sapphire_lotus_buff_mana", {})
	end
	target:SetModifierStackCount("modifier_sapphire_lotus_buff", ability, target:GetIntellect())
	target:SetModifierStackCount("modifier_sapphire_lotus_buff_mana", ability, SAPPHIRE_LOTUS_MP_PER_INT * target:GetIntellect())
end

function lifesource_vessel_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local stacks = math.floor(target:GetStrength() * 0.3)
	if not target:HasModifier("modifier_lifesource_vessel_buff") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_lifesource_vessel_buff", {})
	end
	target:SetModifierStackCount("modifier_lifesource_vessel_buff", ability, stacks)
end

function saytaru_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if target:GetHealth() <= target:GetMaxHealth() * SAYTARU_HP_THRESHOLD_PCT then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_hope_of_saytaru_effect", {})
	else
		target:RemoveModifierByName("modifier_hope_of_saytaru_effect")
	end
end

function galaxy_orb_channel_begin(event)
	local caster = event.target
	local ability = event.ability
	local particleName = "particles/units/heroes/hero_enigma/enigma_midnight_pulse.vpcf"
	ability.pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)

	local position = caster:GetAbsOrigin()
	local radius = 800
	ParticleManager:SetParticleControl(ability.pfx, 0, position)
	ParticleManager:SetParticleControl(ability.pfx, 1, Vector(radius, 2, radius * 2))

	ability.position = position
end

function galaxy_orb_suction(event)
	local caster = event.target
	local ability = event.ability
	local position = ability.position
	local radius = 800
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			if not enemy.jumpLock then
				local enemyPosition = enemy:GetAbsOrigin()
				local movementVector = (position - enemyPosition):Normalized()
				enemy:SetOrigin(enemyPosition + movementVector * 6)
			end
		end
	end
end

function galaxy_orb_channel_end(event)
	local target = event.target
	local ability = event.ability
	ParticleManager:DestroyParticle(ability.pfx, false)
end

function azure_empire_init(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	target.birdTable = {}
	for i = 1, 3, 1 do
		local bird = CreateUnitByName("tracer_unit", target:GetAbsOrigin(), true, nil, nil, target:GetTeamNumber())
		bird.hero = target
		bird.interval = 0
		bird.state = 0
		bird:SetModel("models/items/beastmaster/hawk/fotw_eagle/fotw_eagle.vmdl")
		bird:SetOriginalModel("models/items/beastmaster/hawk/fotw_eagle/fotw_eagle.vmdl")
		bird:SetModelScale(0.5)
		table.insert(target.birdTable, bird)
		ability:ApplyDataDrivenModifier(caster, bird, "modifier_azure_empire_buff", {})
		if ability.newItemTable.property2name == "azure_silver" then
			-- ability:ApplyDataDrivenModifier(caster, bird, "modifier_azure_hawk_silver", {})
			bird.pfx = ParticleManager:CreateParticle("particles/econ/generic/generic_buff_1/azure_empire.vpcf", PATTACH_ABSORIGIN_FOLLOW, bird)
			ParticleManager:SetParticleControlEnt(bird.pfx, 0, bird, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", bird:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(bird.pfx, 15, Vector(180, 190, 255))
		elseif ability.newItemTable.property2name == "azure_green" then
			bird.pfx = ParticleManager:CreateParticle("particles/econ/generic/generic_buff_1/azure_empire.vpcf", PATTACH_ABSORIGIN_FOLLOW, bird)
			ParticleManager:SetParticleControlEnt(bird.pfx, 0, bird, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", bird:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(bird.pfx, 15, Vector(80, 255, 80))
		elseif ability.newItemTable.property2name == "azure_blue" then
			bird.pfx = ParticleManager:CreateParticle("particles/econ/generic/generic_buff_1/azure_empire.vpcf", PATTACH_ABSORIGIN_FOLLOW, bird)
			ParticleManager:SetParticleControlEnt(bird.pfx, 0, bird, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", bird:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(bird.pfx, 15, Vector(80, 80, 255))
		elseif ability.newItemTable.property2name == "azure_red" then
			bird.pfx = ParticleManager:CreateParticle("particles/econ/generic/generic_buff_1/azure_empire.vpcf", PATTACH_ABSORIGIN_FOLLOW, bird)
			ParticleManager:SetParticleControlEnt(bird.pfx, 0, bird, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", bird:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(bird.pfx, 15, Vector(255, 80, 80))
		end
		bird.index = i
		StartAnimation(bird, {duration = 99999, activity = ACT_DOTA_IDLE, rate = 1.0})
	end
	ability:ApplyDataDrivenModifier(caster, target, "modifier_azure_empire_visible", {})
	target:SetModifierStackCount("modifier_azure_empire_visible", caster, 3)
end

function azure_hawk_think(event)
	local bird = event.target
	if bird:HasModifier("modifier_azure_hawk_dead") then
		return false
	end
	local hero = bird.hero
	local heroPosition = hero:GetAbsOrigin()
	local fv = hero:GetForwardVector()
	local perpFv = WallPhysics:rotateVector(fv, math.pi / 2)
	heroPosition = heroPosition - fv * 40
	if bird.state == 0 then
		if bird.index == 1 then
			bird:MoveToPosition(heroPosition + perpFv * 90)
		elseif bird.index == 2 then
			bird:MoveToPosition(heroPosition)
		elseif bird.index == 3 then
			bird:MoveToPosition(heroPosition - perpFv * 90)
		end
	end
end

function azure_empire_end(event)
	local target = event.target
	target:RemoveModifierByName("modifier_azure_empire_visible")
	target:RemoveModifierByName("modifier_azure_empire_base_ability")
	target:RemoveModifierByName("modifier_azure_empire_agility")
	target:RemoveModifierByName("modifier_azure_empire_strength")
	target:RemoveModifierByName("modifier_azure_empire_intelligence")
	for i = 1, #target.birdTable, 1 do
		UTIL_Remove(target.birdTable[i])
	end
	target.birdTable = nil
end

function azure_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local stacks = target:GetModifierStackCount("modifier_azure_empire_visible", caster)
	local heroLevel = target:GetLevel()
	if ability.newItemTable.property2name == "azure_silver" then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_azure_empire_base_ability", {})
		target:SetModifierStackCount("modifier_azure_empire_base_ability", caster, stacks)
	elseif ability.newItemTable.property2name == "azure_green" then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_azure_empire_agility", {})
		target:SetModifierStackCount("modifier_azure_empire_agility", caster, heroLevel * stacks)
	elseif ability.newItemTable.property2name == "azure_red" then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_azure_empire_strength", {})
		target:SetModifierStackCount("modifier_azure_empire_strength", caster, heroLevel * stacks)
	elseif ability.newItemTable.property2name == "azure_blue" then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_azure_empire_intelligence", {})
		target:SetModifierStackCount("modifier_azure_empire_intelligence", caster, heroLevel * stacks)
	end
end

function azure_hawk_dead_end(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local bird = target
	StartAnimation(target, {duration = 99999, activity = ACT_DOTA_IDLE, rate = 1.0})
	Timers:CreateTimer(0.05, function()
		bird:RemoveNoDraw()
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_puck/puck_base_attack_explosion.vpcf", bird, 1.5)
	end)
	local hero = bird.hero
	local heroPosition = hero:GetAbsOrigin()
	local fv = hero:GetForwardVector()

	local perpFv = WallPhysics:rotateVector(fv, math.pi / 2)
	if bird.index == 1 then
		bird:SetAbsOrigin(heroPosition + perpFv * 90)
	elseif bird.index == 2 then
		bird:SetAbsOrigin(heroPosition)
	elseif bird.index == 3 then
		bird:SetAbsOrigin(heroPosition - perpFv * 90)
	end
	if ability.property2name == "azure_silver" then
		bird.pfx = ParticleManager:CreateParticle("particles/econ/generic/generic_buff_1/azure_empire.vpcf", PATTACH_ABSORIGIN_FOLLOW, bird)
		ParticleManager:SetParticleControlEnt(bird.pfx, 0, bird, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", bird:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(bird.pfx, 15, Vector(180, 190, 255))
		-- ability:ApplyDataDrivenModifier(caster, bird, "modifier_azure_hawk_silver", {})
	elseif ability.property2name == "azure_green" then
		bird.pfx = ParticleManager:CreateParticle("particles/econ/generic/generic_buff_1/azure_empire.vpcf", PATTACH_ABSORIGIN_FOLLOW, bird)
		ParticleManager:SetParticleControlEnt(bird.pfx, 0, bird, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", bird:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(bird.pfx, 15, Vector(80, 255, 80))
		-- ability:ApplyDataDrivenModifier(caster, bird, "modifier_azure_hawk_green", {})
	elseif ability.property2name == "azure_blue" then
		bird.pfx = ParticleManager:CreateParticle("particles/econ/generic/generic_buff_1/azure_empire.vpcf", PATTACH_ABSORIGIN_FOLLOW, bird)
		ParticleManager:SetParticleControlEnt(bird.pfx, 0, bird, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", bird:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(bird.pfx, 15, Vector(80, 80, 255))
		-- ability:ApplyDataDrivenModifier(caster, bird, "modifier_azure_hawk_blue", {})
	elseif ability.property2name == "azure_red" then
		bird.pfx = ParticleManager:CreateParticle("particles/econ/generic/generic_buff_1/azure_empire.vpcf", PATTACH_ABSORIGIN_FOLLOW, bird)
		ParticleManager:SetParticleControlEnt(bird.pfx, 0, bird, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", bird:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(bird.pfx, 15, Vector(255, 80, 80))
		-- ability:ApplyDataDrivenModifier(caster, bird, "modifier_azure_hawk_red", {})
	end
	local birdStacks = 0
	for i = 1, #bird.hero.birdTable, 1 do
		local bird = bird.hero.birdTable[i]
		if not bird:HasModifier("modifier_azure_hawk_dead") then
			birdStacks = birdStacks + 1
		end
	end
	ability:ApplyDataDrivenModifier(caster, bird.hero, "modifier_azure_empire_visible", {})
	bird.hero:SetModifierStackCount("modifier_azure_empire_visible", caster, 3)
end

function super_ascension_init(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	target:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
	-- target:SetRangedProjectileName("particles/units/heroes/hero_phoenix/phoenix_base_attack.vpcf")

	-- local baseProjectileSpeed = target.baseProjectileSpeed
	-- ability:ApplyDataDrivenModifier(caster, target, "modifier_ascendency_projectile_speed_stacks", {duration = 10})
	-- local speedStacks = 1050-baseProjectileSpeed
	-- -- if baseProjectileSpeed == 0 then
	-- -- ability:ApplyDataDrivenModifier(caster, target, "modifier_ascendency_projectile_speed_stacks", {duration = 7})
	-- -- end
	-- if speedStacks > 0 then
	-- target:SetModifierStackCount( "modifier_ascendency_projectile_speed_stacks", ability, speedStacks)
	-- end

	-- caster:AddNewModifier( caster, ability, "modifier_super_ascendency_lua", {duration = 9} )

	local particleName = "particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	Timers:CreateTimer(1.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
end

function super_ascension_end(event)
	local caster = event.caster
	local target = event.target
	target:RemoveModifierByName("modifier_super_ascendency_lua")
	if not target:HasModifier("modifier_tomahawk_buffs") and not target:HasModifier("modifier_chernobog_demonform_lua") and not target:HasModifier("modifier_arkimus_archon_form") and not target:HasModifier("modifier_demon_flight_flying") then
		--print("SET TO MELEE")
		target:SetAttackCapability(target.baseAttackCapability)
	end
	-- target:SetRangedProjectileName(target.originalProjectile)
end

function super_ascension_attack(event)
	local caster = event.caster
	local target = event.attacker

	local ulti = target:GetAbilityByIndex(DOTA_R_SLOT)
	local currentCD = ulti:GetCooldownTimeRemaining()
	ulti:EndCooldown()
	ulti:StartCooldown(currentCD - SUPER_ASCENDENCY_CD_RED)
end

function super_ascension_attack_start(event)
	local caster = event.attacker
	local ability = event.ability
	local target = event.target
	if not caster:HasModifier("modifier_ascendency_dont_split") then
		local splitCount = 0
		local procs = SUPER_ASCENDENCY_TARGETS - 1
		if procs > 0 then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, SUPER_ASCENDENCY_SEARCH_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				for _, enemy in pairs(enemies) do
					if enemy:GetEntityIndex() == target:GetEntityIndex() or enemy.dummy then
					else
						if splitCount < procs then
							Filters:PerformAttackSpecial(caster, enemy, true, true, true, false, true, false, false)
							splitCount = splitCount + 1
						end
					end
				end
			end
			ability:ApplyDataDrivenModifier(event.caster, caster, "modifier_ascendency_dont_split", {duration = 0.15})
		end
	end
end

function cascade_projectile(ability, caster, fv)
	local projectileParticle = "particles/units/heroes/hero_dragon_knight/arcane_cascade.vpcf"
	local projectileOrigin = caster:GetAbsOrigin()
	local start_radius = 120
	local end_radius = 220
	local range = 300
	local speed = 850
	local info =
	{
		Ability = ability,
		EffectName = projectileParticle,
		vSpawnOrigin = projectileOrigin + Vector(0, 0, 60),
		fDistance = range,
		fStartRadius = start_radius,
		fEndRadius = end_radius,
		Source = caster,
		StartPosition = "attach_hitloc",
		bHasFrontalCone = true,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 4.0,
		bDeleteOnHit = false,
		vVelocity = fv * speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
end

function cascade_hat_impact(event)
	local ability = event.ability
	local caster = ability.caster
	local target = event.target
	local damage = ability.damage
	Filters:ApplyItemDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_ARCANE, RPC_ELEMENT_NONE)
end

function lifesteal_land(event)
	local attacker = event.attacker
	local ability = event.ability
	local damage = event.attack_damage
	local helmAbility = ability
	local current_stack = attacker:GetModifierStackCount("modifier_helm_lifesteal", helmAbility)
	local lifesteal = math.floor(damage * current_stack / 100)

	Filters:ApplyHeal(attacker, attacker, lifesteal, true)

	local particleName = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, attacker)
	ParticleManager:SetParticleControlEnt(pfx, 0, attacker, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin() + Vector(0, 0, 70), true)
	Timers:CreateTimer(1, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	--print("lifesteal land")
end

function nightmare_rider_initialize(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	target.orbTable = {}
	for i = 1, 3, 1 do
		local orb = CreateUnitByName("nightmare_rider_orb", target:GetAbsOrigin(), true, nil, nil, target:GetTeamNumber())
		orb.hero = target
		orb.owner = target:GetPlayerOwnerID()
		orb.interval = 0
		orb.state = 0
		orb:SetModel("models/props_gameplay/rune_arcane.vmdl")
		orb:SetOriginalModel("models/props_gameplay/rune_arcane.vmdl")
		orb:SetModelScale(0.5)
		table.insert(target.orbTable, orb)
		ability:ApplyDataDrivenModifier(caster, orb, "modifier_nightmare_rider_orb_buff", {})
		orb.index = i
		local offsetRadians = (2 * math.pi / 3) * (i - 1)
		orb.offsetVector = WallPhysics:rotateVector(Vector(1, 1), offsetRadians)
		orb:SetOwner(target)
		orb:SetControllableByPlayer(target:GetPlayerID(), true)
	end
end

function nightmare_rider_think(event)
end

function nightmare_rider_orb_think(event)
	local orb = event.target
	local hero = orb.hero
	orb.offsetVector = WallPhysics:rotateVector(orb.offsetVector, math.pi / 40)
	orb:SetAbsOrigin(hero:GetAbsOrigin() + orb.offsetVector * 120)
	local damage = (hero:GetStrength() + hero:GetAgility() + hero:GetIntellect()) * 4
	damage = Filters:AdjustItemDamage(hero, damage, nil)
	orb:SetBaseDamageMin(damage)
	orb:SetBaseDamageMax(damage)
end

function nightmare_rider_end(event)
	local target = event.target
	for i = 1, #target.orbTable, 1 do
		UTIL_Remove(target.orbTable[i])
	end
	target.orbTable = false
end

function space_tech_channel_think(event)
	local caster = event.target
	local ability = event.ability
	local position = caster:GetAbsOrigin()
	local particleName = "particles/units/heroes/hero_faceless_void/faceless_void_timedialate.vpcf"
	local particle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	local radius = 640
	ParticleManager:SetParticleControl(particle, 0, position)
	ParticleManager:SetParticleControl(particle, 1, Vector(radius, radius, radius))

	ability:ApplyDataDrivenModifier(event.caster, caster, "modifier_space_tech_buff", {duration = 10})
	local stackCount = caster:GetModifierStackCount("modifier_space_tech_buff", event.caster)
	caster:SetModifierStackCount("modifier_space_tech_buff", event.caster, stackCount + 1)

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ability:ApplyDataDrivenModifier(event.caster, enemy, "modifier_space_tech_slow", {duration = 7})
		end
	end
end

function stormshield_cloak_initialize(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	if target.shieldTable then
		return
	end
	target.shieldTable = {}
	for i = 1, 3, 1 do
		local shield = CreateUnitByName("tracer_unit", target:GetAbsOrigin(), true, nil, nil, target:GetTeamNumber())
		shield.hero = target
		shield.owner = target:GetPlayerOwnerID()
		shield.interval = 0
		shield.state = 0
		shield:SetModel("models/props_gameplay/status_shield.vmdl")
		shield:SetOriginalModel("models/props_gameplay/status_shield.vmdl")
		shield:SetModelScale(2.0)
		table.insert(target.shieldTable, shield)
		ability:ApplyDataDrivenModifier(caster, shield, "modifier_stormshield_cloak_shield_buff", {})
		shield.index = i
		local offsetRadians = (2 * math.pi / 3) * (i - 1)
		shield.offsetVector = WallPhysics:rotateVector(Vector(1, 1), offsetRadians)
		shield:SetOwner(target)
		-- if target:GetPlayerID() then
		--  shield:SetControllableByPlayer(target:GetPlayerID(), true)
		--  end
	end
end

function stormshield_main_think(event)

	local caster = event.target
	local position = caster:GetAbsOrigin()
	local radius = 200
	local damage = (caster:GetPhysicalArmorValue(false) * 20) / 3
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		EmitSoundOn("ui.inv_equip_metalblade", caster.shieldTable[1])
		if #enemies > 3 then
			EmitSoundOn("ui.inv_equip_metalblade", caster.shieldTable[2])
		end
		if #enemies > 6 then
			EmitSoundOn("ui.inv_equip_metalblade", caster.shieldTable[3])
		end
		for _, enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR})
		end
	end
end

function stormshield_cloak_shield_think(event)
	local shield = event.target
	if IsValidEntity(shield) then
		local hero = shield.hero
		shield.offsetVector = WallPhysics:rotateVector(shield.offsetVector, math.pi / 20)
		local heroOrigin = hero:GetAbsOrigin()
		local position = heroOrigin + shield.offsetVector * 60 - Vector(0, 0, 65)
		shield:SetAbsOrigin(position)
		local fv = (position - heroOrigin):Normalized() * Vector(1, 1, 0)
		shield:SetForwardVector(fv)
	end
end

function stormshield_cloak_shield_end(event)
	--print("SHIELD END")
	local target = event.target
	for i = 1, #target.shieldTable, 1 do
		UTIL_Remove(target.shieldTable[i])
	end
	target.shieldTable = false
end

function bladestorm_vest_initialize(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	target.bladeTable = {}
	target.bladeHits = 0
end

function bladestorm_vest_end(event)
	local target = event.target
	for i = 1, #target.bladeTable, 1 do
		UTIL_Remove(target.bladeTable[i])
	end
	target:RemoveModifierByName("modifier_bladestorm_vest_buff")
	target.bladeTable = false
end

function bladestorm_vest_attack_hit(event)
	local attacker = event.attacker
	local ability = event.ability
	local caster = event.caster
	if attacker.bladeHits then
		attacker.bladeHits = attacker.bladeHits + 1
		if attacker.bladeHits == 10 then
			ability:ApplyDataDrivenModifier(caster, attacker, "modifier_bladestorm_vest_buff", {})
			local currentStacks = #attacker.bladeTable
			local stacks = math.min(currentStacks + 1, 3)
			attacker:SetModifierStackCount("modifier_bladestorm_vest_buff", caster, stacks)
			attacker.bladeHits = 0

			if currentStacks < 3 then
				Filters:ModifyBladestormVestSwordCount(attacker, stacks, ability, caster)
			end
		end
	else
		attacker.bladeHits = 0
	end
end

function undertaker_attack(event)
	local attacker = event.attacker
	local ability = event.ability
	local target = event.target
	ability.caster = attacker
	local info =
	{
		Target = target,
		Source = attacker,
		Ability = ability,
		EffectName = "particles/econ/items/necrolyte/necrophos_sullen/necro_sullen_pulse_enemy.vpcf",
		StartPosition = "attach_attack1",
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = true,
		iVisionRadius = 100,
		iMoveSpeed = 400,
	iVisionTeamNumber = attacker:GetTeamNumber()}
	projectile = ProjectileManager:CreateTrackingProjectile(info)
end

function undertaker_projectile_strike(event)
	local target = event.target
	local caster = event.ability.caster
	local damage = caster:GetIntellect() * 30
	Filters:ApplyItemDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, event.ability, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_GHOST)
end

function mountain_vambrace_attack(event)
	local item = event.caster
	local caster = event.attacker
	local target = event.target
	local ability = event.ability
	local proc = Filters:GetProc(caster, 15)
	if caster:GetAttackCapability() == DOTA_UNIT_CAP_RANGED_ATTACK then
		proc = Filters:GetProc(caster, 10)
	end
	if proc then
		EmitSoundOn("Hero_Sven.StormBoltImpact", target)
		local radius = 290
		local damage = caster:GetStrength() * 1500
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				Filters:ApplyItemDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, event.ability, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
				Filters:ApplyStun(caster, 1, enemy)
			end
		end
		local particleName = "particles/units/heroes/hero_sven/mountain_vambraces_storm_bolt_projectile_explosion.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
		ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 2, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 3, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		Timers:CreateTimer(1.5, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)

	end
end

function wolfir_druid_init(event)
	event.ability.initial = true
	--print("WOLF WHAT")
end

function wolfir_druid_channel(event)
	local caster = event.target
	local ability = event.ability
	local inventoryUnit = event.caster

	local fv = caster:GetForwardVector() * Vector(1, 1, 0)
	local position = caster:GetAbsOrigin() - fv * 190 + RandomVector(RandomInt(50, 200))

	local wolf = CreateUnitByName("wolf_ally", position, false, nil, nil, caster:GetTeamNumber())
	wolf:SetAbsOrigin(wolf:GetAbsOrigin() + Vector(0, 0, 120))
	wolf.owner = caster:GetPlayerOwnerID()
	wolf.summoner = caster
	wolf:SetOwner(caster)
	wolf:SetControllableByPlayer(caster:GetPlayerID(), true)
	wolf.dieTime = 16
	wolf:AddAbility("ability_die_after_time_generic"):SetLevel(1)
	local summonAbil = wolf:AddAbility("ability_summoned_unit")
	summonAbil:SetLevel(1)
	local dmg = OverflowProtectedGetAverageTrueAttackDamage(caster) * 3.0
	dmg = Filters:AdjustItemDamage(caster, dmg, nil)
	dmg = Filters:ElementalDamage(wolf, caster, dmg, DAMAGE_TYPE_PHYSICAL, 0, RPC_ELEMENT_NATURE, RPC_ELEMENT_NONE)
	Filters:SetAttackDamage(wolf, dmg)
	wolf:SetPhysicalArmorBaseValue(Filters:AdjustItemDamage(caster, caster:GetPhysicalArmorValue(false), nil))
	local wolfHealth = math.floor(caster:GetMaxHealth() * 0.25)
	wolfHealth = Filters:AdjustItemDamage(caster, wolfHealth, nil)
	wolf:SetMaxHealth(wolfHealth)
	wolf:SetBaseMaxHealth(wolfHealth)
	wolf:SetHealth(wolfHealth)
	wolf:Heal(wolfHealth, wolf)
	wolf:AddAbility("ability_ghost_effect"):SetLevel(1)

	wolf:SetForwardVector(fv)
	wolf:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
	wolf:SetModelScale(0.6)
	wolf.fv = fv
	wolf:SetBaseMoveSpeed(400)
	ability:ApplyDataDrivenModifier(inventoryUnit, wolf, "modifier_wolf_enter", {duration = 1.1})
	if ability.initial then
		ability.initial = false
		EmitSoundOn("Hero_Lycan.Howl.Team", wolf)
	end

	local splitEarthParticle = "particles/frostivus_herofx/hyper_state_intro_omnislash_ascension.vpcf"
	local pfx = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, wolf)
	local wolfPosition = wolf:GetAbsOrigin()
	ParticleManager:SetParticleControlEnt(pfx, 0, wolf, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", wolfPosition, true)
	ParticleManager:SetParticleControlEnt(pfx, 1, wolf, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", wolfPosition, true)
	Timers:CreateTimer(1.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	wolf.interval = 0
	wolf:AddAbility("alpha_wolf_critical_strike"):SetLevel(1)
end

function wolfir_wolf_think(event)
	local wolf = event.caster
	local caster = wolf.summoner
	local distance = WallPhysics:GetDistance(wolf:GetAbsOrigin() * Vector(1, 1, 0), caster:GetAbsOrigin() * Vector(1, 1, 0))
	if distance > 1000 then
		wolf:MoveToPositionAggressive(caster:GetAbsOrigin() + RandomVector(240))
	end
	-- CustomAbilities:CastNoTargetIfCastable(wolf, wolf:FindAbilityByName("ursa_overpower_no_head_attachment"), 500)

end

function wolf_enter_think(event)
	local wolf = event.target
	local startPos = wolf:GetAbsOrigin()
	if wolf.interval <= 13 then
		wolf:SetAbsOrigin(startPos + wolf.fv * 17 - Vector(0, 0, 11))
	else
		startPos = GetGroundPosition(startPos, wolf)
		wolf:SetAbsOrigin(startPos + wolf.fv * 17)
	end
	wolf.interval = wolf.interval + 1
end

function wolf_enter_think_two(event)
	local wolf = event.target
	local startPos = wolf:GetAbsOrigin()
	wolf:SetAbsOrigin(startPos + wolf.fv * 15)
end

function wolf_enter_end(event)
	local wolf = event.target
	wolf:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
	FindClearSpaceForUnit(wolf, wolf:GetAbsOrigin(), false)
	wolf:MoveToPositionAggressive(wolf:GetAbsOrigin() + wolf.fv * 600)
end

function grand_arcanist_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local stacks = math.floor(target:GetIntellect() / 10)
	if not target:HasModifier("modifier_grand_arcanist_damage") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_grand_arcanist_damage", {})
	end
	target:SetModifierStackCount("modifier_grand_arcanist_damage", ability, stacks)
end

function devotion_think(event)
	local hero = event.target
	local caster = event.caster
	local ability = event.ability
	local stacks = math.floor(hero:GetStrength() / 10)
	local allies = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
	if #allies > 0 then
		for _, ally in pairs(allies) do
			ability:ApplyDataDrivenModifier(caster, ally, "modifier_devotion_aura_buff", {duration = 1.5})
			ally:SetModifierStackCount("modifier_devotion_aura_buff", ability, stacks)
		end
	end
end

function gilded_soul_kill(event)
	local dyingUnit = event.unit
	local hero = event.attacker
	local ability = event.ability
	local caster = event.caster
	local particlePos = dyingUnit:GetAbsOrigin()
	ability.caster = caster
	local info =
	{
		Target = hero,
		Source = dyingUnit,
		Ability = ability,
		EffectName = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_base_attack.vpcf",
		vSourceLoc = particlePos,
		bDrawsOnMinimap = false,
		bDodgeable = false,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 2,
		bProvidesVision = false,
		iVisionRadius = 0,
		iMoveSpeed = 1500,
	iVisionTeamNumber = hero:GetTeamNumber()}
	projectile = ProjectileManager:CreateTrackingProjectile(info)

	local particleName = "particles/units/heroes/hero_elder_titan/gilded_soul_cage.vpcf"
	local position = dyingUnit:GetAbsOrigin()

	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, particlePos)
	Timers:CreateTimer(1.5, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:ReleaseParticleIndex(pfx)
	end)
	local allies = FindUnitsInRadius(hero:GetTeamNumber(), particlePos, nil, 240, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
	if #allies > 0 then
		for _, ally in pairs(allies) do
			local heal = math.floor(ally:GetMaxHealth() * 0.15)
			Filters:ApplyHeal(hero, ally, heal, true)
		end
	end
end

function gilded_soul_projectile_hit(event)
	local target = event.target
	local ability = event.ability
	local caster = ability.caster
	ability:ApplyDataDrivenModifier(caster, target, "modifier_gilded_soul_buff", {duration = 8})
	local newStacks = math.min(target:GetModifierStackCount("modifier_gilded_soul_buff", ability) + 1, 100)
	target:SetModifierStackCount("modifier_gilded_soul_buff", ability, newStacks)
	ability.soulStacks = newStacks
	ability:ApplyDataDrivenModifier(caster, target, "modifier_gilded_soul_immunity", {duration = 4})
end

function gilded_soul_buff_duration_end(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	ability.soulStacks = ability.soulStacks - 1
	if target:IsAlive() then
		if ability.soulStacks > 0 then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_gilded_soul_buff", {duration = 8})
			target:SetModifierStackCount("modifier_gilded_soul_buff", ability, ability.soulStacks)
		end
	end
end

function arcanys_slipper_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local particleName = "particles/econ/courier/courier_dolfrat_and_roshinante/arcanys_poof.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	Timers:CreateTimer(1.2, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	local manaDrain = target:GetMaxMana() * 0.1
	if target:GetMana() <= manaDrain then
		manaDrain = target:GetMana()
	end
	local damageIncrease = manaDrain * 10
	target:ReduceMana(manaDrain)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_arcanys_slipper_buff", {duration = 10})
	local currentStacks = target:GetModifierStackCount("modifier_arcanys_slipper_buff", caster)
	target:SetModifierStackCount("modifier_arcanys_slipper_buff", caster, damageIncrease + currentStacks)
	EmitSoundOn("Item.ArcanysSlipper", target)

end

function onu_attack_land(event)
	local target = event.target
	local attacker = event.attacker
	local ability = event.ability
	local caster = event.caster
	if target.dummy then
		return false
	end
	local proc = Filters:GetProc(attacker, 35)
	if target:HasModifier("modifier_glint_no_proc") then
		local newNoProcStacks = target:GetModifierStackCount("modifier_glint_no_proc", caster) - 1
		if newNoProcStacks > 0 then
			target:SetModifierStackCount("modifier_glint_no_proc", caster, newNoProcStacks)
		else
			target:RemoveModifierByName("modifier_glint_no_proc")
		end

		return false
	end
	if proc then
		if attacker:IsAlive() then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_glint_no_proc", {duration = 1})
			target:SetModifierStackCount("modifier_glint_no_proc", caster, 2)
			local newPosition = target:GetAbsOrigin() + target:GetForwardVector() *- 120
			local position = attacker:GetAbsOrigin()
			local newPosition = WallPhysics:WallSearch(position, newPosition, target)
			FindClearSpaceForUnit(attacker, newPosition, false)
			attacker:SetForwardVector(target:GetForwardVector() * Vector(1, 1, 0))
			event.ability:ApplyDataDrivenModifier(event.caster, attacker, "modifier_blinded_glint_buff", {duration = 0.8})

			local particleName = "particles/econ/items/meepo/meepo_diggers_divining_rod/meepo_divining_rod_poof_end_rays_burst.vpcf"
			local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, attacker)
			ParticleManager:SetParticleControlEnt(pfx, 0, attacker, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", position, true)
			local pfx2 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, attacker)
			ParticleManager:SetParticleControlEnt(pfx2, 0, attacker, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", newPosition, true)
			Timers:CreateTimer(1, function()
				ParticleManager:DestroyParticle(pfx, false)
				ParticleManager:DestroyParticle(pfx2, false)
			end)
			Filters:PerformAttackSpecial(attacker, target, true, true, true, false, true, false, false)
			Timers:CreateTimer(0.1, function()
				if target:IsAlive() then
					Filters:PerformAttackSpecial(attacker, target, true, true, true, false, true, false, false)
				end
			end)
			EmitSoundOnLocationWithCaster(newPosition, "RPCItem.GlintOfOnu", attacker)
		end
	end

end

function roknar_think(event)
	local target = event.target
	if target:HasModifier("modifier_stunned") or target:HasModifier("modifier_knockback") or target:IsStunned() then
		local particleName = "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		Timers:CreateTimer(0.2, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		local heal = target:GetMaxHealth() * 0.12
		Filters:ApplyHeal(target, target, heal, true)
	end
end

function bluestar_spellcast(event)
	local target = event.ability.hero
	local executedAbility = event.event_ability
	local manaSpent = executedAbility:GetManaCost(executedAbility:GetLevel() - 1)
	if manaSpent > 0 then
		target.bluestarSlideVelocity = 25
		local heal = manaSpent
		Filters:ApplyHeal(target, target, heal, true)
		event.ability:ApplyDataDrivenModifier(event.caster, target, "modifier_bluestar_slide", {duration = 0.6})

		local particleName = "particles/items_fx/arcane_boots.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		Timers:CreateTimer(0.2, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)

	end
end

function bluestar_slide(event)
	local target = event.target
	local position = target:GetAbsOrigin()
	position = GetGroundPosition(position, target)

	local newPosition = position + target:GetForwardVector() * target.bluestarSlideVelocity
	local afterWallPosition = WallPhysics:WallSearch(target:GetAbsOrigin(), newPosition, target)

	if afterWallPosition == newPosition then
		target:SetOrigin(newPosition)
	end
	target.bluestarSlideVelocity = target.bluestarSlideVelocity - 1.25
end

function findClearSpace(event)
	local target = event.target
	FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
end

function lifesteal_land_hand(event)
	local attacker = event.attacker
	local ability = attacker.InventoryUnit:FindAbilityByName("hand_slot")
	local damage = event.attack_damage
	local current_stack = attacker:GetModifierStackCount("modifier_hand_lifesteal", ability)
	local lifesteal = math.floor(damage * current_stack / 100)

	Filters:ApplyHeal(attacker, attacker, lifesteal, true)
	local particleName = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, attacker)
	ParticleManager:SetParticleControlEnt(pfx, 0, attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin() + Vector(0, 0, 70), true)
	Timers:CreateTimer(1, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
end

function eternal_essence_kill(event)
	local dyingUnit = event.unit
	local hero = event.attacker
	local ability = event.ability
	local caster = event.caster
	local heal = dyingUnit:GetMaxHealth() * 0.04
	local particleName = "particles/units/heroes/hero_oracle/eternal_gauntlet_heal.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_POINT_FOLLOW, hero)
	ParticleManager:SetParticleControlEnt(pfx, 0, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)

	Timers:CreateTimer(1.0, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	Timers:CreateTimer(0.05, function()
		Filters:ApplyHeal(hero, hero, heal, true)
	end)
end

function eternal_essence_projectile_hit(event)
end

function swamp_doctor_think(event)
	local caster = event.target
	local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 420, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
	local healAmount = math.floor((caster:GetStrength() + caster:GetIntellect() + caster:GetAgility()) * 0.4)
	if #allies > 0 then
		for _, ally in pairs(allies) do
			Filters:ApplyHeal(caster, ally, healAmount, true)
		end
	end
end

function bladeforge_attack_land(event)
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	ability:ApplyDataDrivenModifier(caster, target, "modifier_bladeforge_debuff", {duration = 6})
	local current_stack = target:GetModifierStackCount("modifier_bladeforge_debuff", ability)
	if current_stack < 5000 then
		target:SetModifierStackCount("modifier_bladeforge_debuff", ability, current_stack + 1)
	end
	local proc = Filters:GetProc(attacker, 20)
	if proc then
		local particleName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "follow_origin", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "follow_origin", target:GetForwardVector(), true)
		target.bladeforgeBleedDPS = event.attack_damage * 1.0
		EmitSoundOn("Hero_PhantomAssassin.CoupDeGrace", target)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_bladeforge_bleed", {duration = 3})
		Timers:CreateTimer(3, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	end
end

function bladeforge_bleed_think(event)
	local target = event.target
	local damage = target.bladeforgeBleedDPS
	local ability = event.ability
	Filters:ApplyItemDamage(target, event.caster.hero, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
end

function bladeforge_bleed_end(event)
	local target = target
	target.bladeforgeBleedDPS = nil
end

function hermit_spike_damage_taken(event)
	local ability = event.ability
	local caster = event.caster
	local attack_damage = event.damage
	local target = event.unit
	if not ability.spineDamage then
		ability.spineDamage = 0
	end
	local spineThreshold = target:GetMaxHealth() * 0.15
	ability.spineDamage = ability.spineDamage + attack_damage
	if ability.spineDamage > spineThreshold then
		EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_Bristleback.QuillSpray.Cast", target)
		local spineShots = math.min(math.floor(ability.spineDamage / spineThreshold), 7)
		for i = 1, spineShots, 1 do
			Timers:CreateTimer((i - 1) * 0.2, function()
				local spikeParticle = "particles/units/heroes/hero_bristleback/bristleback_quill_spray_quills.vpcf"
				local position = target:GetAbsOrigin()
				local pfx = ParticleManager:CreateParticle(spikeParticle, PATTACH_OVERHEAD_FOLLOW, target)
				ParticleManager:SetParticleControl(pfx, 0, position + Vector(0, 0, -100))
				Timers:CreateTimer(2, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)
				local radius = 550
				local damage = spineThreshold * 30
				local enemies = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
				if #enemies > 0 then
					for _, enemy in pairs(enemies) do
						Filters:ApplyItemDamage(enemy, target, damage, DAMAGE_TYPE_PHYSICAL, event.ability, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
					end
				end
			end)
		end
		ability.spineDamage = 0
	end
end

function gengar_damage(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.unit
	local proc = Filters:GetProc(target, 15)
	if proc then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_torch_of_gengar_effect", {duration = 6})
	end
end

function redrock_end(event)
	local target = event.target
	target:Stop()
end

function pathfinder_think(event)
	local target = event.target
	local animation = false
	if not target:HasModifier("modifier_pathfinder_resonant_cooldown") then
		if target:GetHealth() < target:GetMaxHealth() then
			local heal = math.ceil(target:GetMaxHealth() * 0.08)
			Filters:ApplyHeal(target, target, heal, true)
			animation = true
		end
		if target:GetMana() < target:GetMaxMana() then
			local manaRestore = math.ceil(target:GetMaxMana() * 0.04)
			target:GiveMana(manaRestore)
			Timers:CreateTimer(0.1, function()
				PopupMana(target, manaRestore)
			end)
			animation = true
		end
		if animation then
			--print("PARTICLE???")
			local particleName = "particles/frostivus_gameplay/wraith_king_heal.vpcf"
			local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx, 3, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			Timers:CreateTimer(1.5, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
		end
	end
end

function neptune_think(event)
	local target = event.target
	local ability = event.ability
	if not ability.lastPos then
		ability.lastPos = target:GetAbsOrigin()
	end
	if Filters:HasMovementModifier(target) then
		return false
	end
	local onGround = math.abs(caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster)) < 10
	if onGround then
	else
		return false
	end
	if not ability.distanceMoved then
		ability.distanceMoved = 0
		ability.slideVelocity = 0
		ability.forward = target:GetForwardVector()
	end
	ability.newPos = target:GetAbsOrigin()
	ability.hero = target
	local distance = WallPhysics:GetDistance(ability.newPos * Vector(1, 1, 0), ability.lastPos * Vector(1, 1, 0))
	ability.distanceMoved = ability.distanceMoved + distance - ability.slideVelocity
	if ability.slideVelocity < 2 then
		-- ability.forward = Vector(0,0)
		target:RemoveModifierByName("modifier_neptune_gliding")
	end
	if ability.distanceMoved > 100 then
		ability.active = true
		ability:ApplyDataDrivenModifier(event.caster, target, "modifier_neptune_gliding", {duration = 5})
		if ability.distanceMoved < 2000 then
			for i = 1, ability.distanceMoved / 100, 1 do
				ability.foward = (ability.forward * (ability.slideVelocity / 1.5) + target:GetForwardVector()):Normalized()
				ability.slideVelocity = math.min(ability.slideVelocity + 2.5, 16)
			end
		end
		ability.distanceMoved = ability.distanceMoved % 100
		ability.forward = (target:GetAbsOrigin() - ability.lastPos):Normalized()
	else
		if distance < 20 then
			ability.active = false
			target:RemoveModifierByName("modifier_neptune_gliding")
			ability.slideVelocity = 0
			-- ability.forward = Vector(0,0)
		end
	end
	if ability.active then
		local particleName = "particles/econ/items/pets/pet_frondillo/pet_swim_puddle_frondillo.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_WORLDORIGIN, "attach_hitloc", target:GetAbsOrigin(), true)
		Timers:CreateTimer(2.0, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	end
	if ability.forward == Vector(0, 0) then
		ability.forward = target:GetForwardVector()
	else
		-- ability.forward = (ability.forward*ability.slideVelocity + target:GetForwardVector()):Normalized()
	end
	-- local dot = dot
	-- if angle > math.pi/2 then
	-- -- ability.slideVelocity = 0
	-- target:Stop()
	-- end
	ability.lastPos = target:GetAbsOrigin()
end

function neptune_gliding(event)
	local target = event.target
	local ability = event.ability
	local position = target:GetAbsOrigin()
	if target:IsStunned() or target:IsRooted() or target:IsFrozen() then
		return false
	end
	local obstruction = WallPhysics:FindNearestObstruction(position * Vector(1, 1, 0))

	local newPosition = target:GetAbsOrigin() + ability.forward * ability.slideVelocity
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition * Vector(1, 1, 0), target)
	newPosition = GetGroundPosition(newPosition, target)
	if not blockUnit and (math.abs(position.z - newPosition.z) < 3) then
		-- newPosition = GetGroundPosition(newPosition, target)
		target:SetAbsOrigin(newPosition)
	end
	ability.slideVelocity = math.max(ability.slideVelocity - 1.2, 0)
end

function neptune_gliding_think_new(event)
	local target = event.target
	local ability = event.ability
	local position = target:GetAbsOrigin()
	if target:HasModifier("modifier_jumping") then
		return false
	end
	if not ability.interval then
		ability.interval = 0
	end
	ability.interval = ability.interval + 1
	if ability.interval == 8 then
		--print("SHOW PARTICLE!")
		local particleName = "particles/roshpit/hydroxis/slipstream_puddle.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
		ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin())
		Timers:CreateTimer(3, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		ability.interval = 0
	end

	local obstruction = WallPhysics:FindNearestObstruction(position * Vector(1, 1, 0))

	local moveForward = target:GetForwardVector()
	if WallPhysics:GetDistance2d(ability.movementPosition, target:GetAbsOrigin()) < 150 then
		moveForward = ability.movementForward

	end
	local newPosition = target:GetAbsOrigin() + moveForward * ability.slideSpeed
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition * Vector(1, 1, 0), target)
	-- newPosition = GetGroundPosition(newPosition, target)

	-- newPosition = GetGroundPosition(newPosition, target)
	if math.abs(target:GetAbsOrigin().z - GetGroundHeight(newPosition, target)) < 0.01 then
		if math.abs(target:GetAbsOrigin().z - GetGroundHeight(target:GetAbsOrigin(), target)) < 0.01 then
			if not blockUnit then
				target:SetAbsOrigin(GetGroundPosition(newPosition, target))
			end
		else
			target:RemoveModifierByName("modifier_neptune_gliding_new")
		end
	else
		target:RemoveModifierByName("modifier_neptune_gliding_new")
	end

	ability.slideSpeed = math.max(ability.slideSpeed - 0.1, 0)
	if ability.slideSpeed < 1 then
		target:RemoveModifierByName("modifier_neptune_gliding_new")
	end
	if ability.lastPos then
		local distance2d = WallPhysics:GetDistance2d(ability.lastPos, target:GetAbsOrigin())
		if distance2d < (ability.slideSpeed - 0.5) then

			if not ability.blockCheck then
				ability.blockCheck = 0
			end
			ability.blockCheck = ability.blockCheck + 1
			--print(ability.blockCheck)
			if ability.blockCheck >= 3 then
				target:RemoveModifierByName("modifier_neptune_gliding_new")
				ability.blockCheck = 0
			end
		else
			ability.blockCheck = 0
		end
	end
	ability.lastPos = target:GetAbsOrigin()
	ability.lastForward = target:GetForwardVector()
	local distance2d = WallPhysics:GetDistance2d(ability.movementPosition, target:GetAbsOrigin())
	if distance2d < 70 then
		if not target:IsChanneling() then
			if target.lastOrder then
				if target.lastOrder == DOTA_UNIT_ORDER_MOVE_TO_POSITION then
					target:Stop()
				end
			end
		end
	end
end

function gliding_end(event)
	local target = event.target
	local ability = event.ability
	ability.lastPos = false
	ability.blockCheck = 0
	FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
end

function ruinfall_skull_think(event)
	local target = event.target
	if not target:HasModifier("modifier_ruinfall_skull_token_cooldown") and target:GetHealth() < target:GetMaxHealth() * 0.25 and target:IsAlive() then
		event.ability:ApplyDataDrivenModifier(event.caster, target, "modifier_skull_sand_storm", {duration = 5})
		event.ability:ApplyDataDrivenModifier(event.caster, target, "modifier_ruinfall_skull_token_cooldown", {duration = 40})
		StartSoundEvent("Ability.SandKing_SandStorm.loop", target)
	end
end

function ruinfall_skull_heal_think(event)
	local target = event.target
	local healAmount = math.floor(target:GetMaxHealth() * 0.2)
	Filters:ApplyHeal(target, target, healAmount, true)
end

function ruinfall_skull_sandstorm_end(event)
	local target = event.target

	StopSoundEvent("Ability.SandKing_SandStorm.loop", target)
	target:RemoveModifierByName("modifier_invisible")
end

function spirit_glove_think(event)
	local spiritGlove = event.ability
	local caster = event.caster
	local ally = event.target
	local healAmount = spiritGlove.healAmount

	local particleName = "particles/units/heroes/hero_oracle/white_mage_healheal.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, ally)
	ParticleManager:SetParticleControlEnt(pfx, 0, ally, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", ally:GetAbsOrigin(), true)
	Timers:CreateTimer(1.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)

	Filters:ApplyHeal(caster, ally, healAmount, true)
end

function ruby_attack(event)
	local damage = event.damage * 8
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	-- damage = GameState:GetPostReductionPhysicalDamage(damage, target:GetPhysicalArmorValue(false))
	--print("RUBY DAMAGE:"..damage)
	EmitSoundOn("Hero_Lina.ProjectileImpact", target)
	local radius = 360
	local particleName = "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControl(particle1, 0, target:GetAbsOrigin())
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)

	local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:ApplyItemDamage(enemy, attacker, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
		end
	end

end

function blue_dragon_greaves_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if not ability.lastPos then
		ability.lastPos = target:GetAbsOrigin()
	end
	if not ability.distanceMoved then
		ability.distanceMoved = 0
	end
	ability.newPos = target:GetAbsOrigin()
	ability.hero = target
	local distance = WallPhysics:GetDistance(ability.newPos, ability.lastPos)
	ability.distanceMoved = ability.distanceMoved + distance
	if ability.distanceMoved > 1200 then

		ability:ApplyDataDrivenModifier(caster, target, "modifier_blue_dragon_greaves_effect", {duration = 6})
		EmitSoundOn("Items.BlueDragonGreaves", target)
		ability.distanceMoved = ability.distanceMoved % 1200
	end

	ability.lastPos = target:GetAbsOrigin()
end

function ocean_tempest_initialize(event)
	local ability = event.ability
	ability.manaDrained = 0
	ability.interval = 0
end

function ocean_tempest_think(event)
	local target = event.target
	local ability = event.ability

	local manaDrain = target:GetMaxMana() * 0.04
	if manaDrain > target:GetMana() then
		manaDrain = target:GetMana()
	end
	manaDrain = math.floor(manaDrain)
	ability.manaDrained = ability.manaDrained + manaDrain
	target:ReduceMana(manaDrain)
	PopupLoseMana(target, manaDrain)
	ability.interval = ability.interval + 1
	if ability.interval % 3 == 0 then
		local particleName = "particles/units/heroes/hero_tidehunter/tidehunter_gush_splash.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
		ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 2, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 3, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		Timers:CreateTimer(0.5, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	end
end

function raven_idol_think(event)
	local target = event.target
	if target:GetHealth() > target:GetMaxHealth() * 0.5 then
		target:SetHealth(target:GetMaxHealth() * 0.5)
	end
end

function raven_idol_health_gained(event)
	local target = event.unit
	if target:GetHealth() > target:GetMaxHealth() * 0.5 then
		target:SetHealth(target:GetMaxHealth() * 0.5)
	end
end

function twilight_damage_taken(event)
	local target = event.unit
	local damageTaken = event.damage_taken
	if damageTaken > target:GetMaxHealth() * 0.20 then
		EmitSoundOn("Grizzly.AllyHeal", target)
		local healAmount = math.ceil(damageTaken * 0.75)
		Timers:CreateTimer(0.05, function()
			Filters:ApplyHeal(target, target, healAmount, true)
			local particleName = "particles/units/heroes/hero_oracle/white_mage_healheal.vpcf"
			local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			Timers:CreateTimer(1, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
		end)
	end
end

function blackfeather_think(event)
	local target = event.target
	local birdDamage = OverflowProtectedGetAverageTrueAttackDamage(target) * 5
	local summonPos = target:GetAbsOrigin() + RandomVector(RandomInt(50, 600))
	local crow = CreateUnitByName("twilight_crow_summon", summonPos, true, nil, nil, target:GetTeamNumber())
	crow.owner = target:GetPlayerOwnerID()
	crow:SetOwner(target)
	local crowAbility = crow:FindAbilityByName("twilight_crow_summon_ai")
	crowAbility:ApplyDataDrivenModifier(crow, crow, "modifier_twilight_crow_summon_ai", {duration = 10})
	crow:SetForwardVector(target:GetForwardVector())
	crow:SetBaseDamageMax(birdDamage)
	crow:SetBaseDamageMin(birdDamage)
end

function wraith_phase(event)
	local caster = event.target
	caster:AddNoDraw()
	ProjectileManager:ProjectileDodge(caster)
end

function wraith_phase_back(event)
	local caster = event.target
	caster:RemoveNoDraw()
end

function windsteel_take_damage(event)
	local target = event.unit
	--print("WINDSTEEL HIT")
	local stackCount = target:GetModifierStackCount("modifier_windsteel_effect", target.body)
	if stackCount > 1 then
		target:SetModifierStackCount("modifier_windsteel_effect", target.body, stackCount - 1)
	else
		target:RemoveModifierByName("modifier_windsteel_effect")
	end
	local damageTaken = event.damage
	target:Heal(damageTaken, target)
end

function april_fools_cast(event)
	local target = event.caster
	EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_Gyrocopter.ART_Barrage.Launch", target)
end

function phoenix_die(event)
	local caster = event.unit
	local ability = event.ability
	local inventoryUnit = event.caster
	if not caster:HasModifier("modifier_phoenix_emblem_cooldown") then
		local bRez = true
		if caster:GetUnitName() == "npc_dota_hero_omniknight" then
			local a_c_level = Runes:GetTotalRuneLevel(caster, 1, "e_1", "paladin")
			local runeUnit = caster.runeUnit
			local runeAbility = runeUnit:FindAbilityByName("paladin_rune_e_1")
			if a_c_level > 0 and caster:HasModifier("modifier_paladin_rune_e_1_revivable") then
				bRez = false
			end
		end
		if bRez then
			--print("BREZ!!")
			caster.revive = true
			local rezPosition = caster:GetAbsOrigin()
			ability.rezPosition = rezPosition
			caster:SetTimeUntilRespawn(0)
			caster:SetAbsOrigin(rezPosition)
			Timers:CreateTimer(0.3, function()
				caster:AddNoDraw()
				local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
				Timers:CreateTimer(5.01, function()
					ability:ApplyDataDrivenModifier(inventoryUnit, caster, "modifier_phoenix_emblem_cooldown", {duration = 55})
				end)
				ability:ApplyDataDrivenModifier(inventoryUnit, caster, "modifier_phoenix_rebirthing", {duration = 5})
				gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, caster, "modifier_disable_player", {duration = 5})
				caster:SetAbsOrigin(rezPosition)
				local playerID = caster:GetPlayerID()
				if playerID then
					--print("WE HERE?? BREZ!!")
					PlayerResource:SetCameraTarget(playerID, caster)
				end
				Timers:CreateTimer(2, function()
					caster:SetAbsOrigin(rezPosition)
					if playerID then
						PlayerResource:SetCameraTarget(playerID, nil)
					end
				end)
			end)

			local egg = CreateUnitByName("npc_dummy_unit", rezPosition, true, caster, caster, caster:GetTeamNumber())
			egg:FindAbilityByName("dummy_unit"):SetLevel(1)
			egg:SetModelScale(1.4)
			egg:SetOriginalModel("models/phoenix_egg_hitbox.vmdl")
			egg:SetModel("models/phoenix_egg_hitbox.vmdl")
			egg:SetAbsOrigin(egg:GetAbsOrigin() - Vector(0, 0, 80))
			egg.hero = caster
			ability:ApplyDataDrivenModifier(inventoryUnit, egg, "modifier_egg_reviving", {duration = 5})
			AddFOWViewer(caster:GetTeamNumber(), rezPosition, 800, 8, false)
		end
	end

end

function egg_start(event)
	local target = event.target
	EmitSoundOn("Hero_Phoenix.SuperNova.Cast", target)
	EmitSoundOn("Hero_Phoenix.SuperNova.Cast", target)
end

function egg_think(event)
	local target = event.target
	target:SetAbsOrigin(target:GetAbsOrigin() + Vector(0, 0, 4))
	local fv = target:GetForwardVector()
	target:SetForwardVector(WallPhysics:rotateVector(fv, math.pi / 56))
end

function egg_end(event)
	local target = event.target
	local hero = target.hero
	local ability = event.ability
	hero:RemoveNoDraw()
	hero:SetAbsOrigin(ability.rezPosition)
	EmitSoundOn("Hero_Phoenix.SuperNova.Explode", hero)
	local particleName = "particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf"
	local particleVector = hero:GetAbsOrigin()
	-- CustomGameEventManager:Send_ServerToAllClients("special_event_close", {} )
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, hero)
	ParticleManager:SetParticleControl(pfx, 0, particleVector)
	ParticleManager:SetParticleControl(pfx, 1, particleVector)
	ParticleManager:SetParticleControl(pfx, 2, particleVector)
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	ScreenShake(particleVector, 500, 0.4, 0.8, 9000, 0, true)
	local enemies = FindUnitsInRadius(hero:GetTeamNumber(), particleVector, nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:ApplyStun(hero, 5, enemy)
		end
	end
	UTIL_Remove(target)
end

function savage_ogthun_kill(event)
	local dyingUnit = event.unit
	local hero = event.attacker
	local ability = event.ability
	local caster = event.caster
	if not ability.ogthunStacks then
		ability.ogthunStacks = 0
	end
	ability:ApplyDataDrivenModifier(caster, hero, "modifier_ogthun_visible", {duration = 9})
	local current_stack = hero:GetModifierStackCount("modifier_ogthun_visible", ability)
	ability.ogthunStacks = math.min(ability.ogthunStacks + 1, 100)
	local newStack = math.min(ability.ogthunStacks, 100)

	hero:SetModifierStackCount("modifier_ogthun_visible", ability, newStack)

	local healthBonus = hero:GetStrength() * 0.4 * newStack
	local healthBonusStacks = healthBonus / 10

	ability:ApplyDataDrivenModifier(caster, hero, "modifier_ogthun_health", {duration = 9})
	hero:SetModifierStackCount("modifier_ogthun_health", ability, healthBonusStacks)
	hero:CalculateStatBonus()
	local particleName = "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_red_spotlight.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, hero)
	ParticleManager:SetParticleControlEnt(pfx, 0, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)

	Timers:CreateTimer(1, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
end

function ogthun_destroy(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	ability.ogthunStacks = ability.ogthunStacks - 1
	if ability.ogthunStacks > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_ogthun_visible", {duration = 9})
		target:SetModifierStackCount("modifier_ogthun_visible", ability, ability.ogthunStacks)

		local healthBonus = target:GetStrength() * ability.ogthunStacks * 0.4
		local healthBonusStacks = healthBonus / 10
		ability:ApplyDataDrivenModifier(caster, target, "modifier_ogthun_health", {duration = 9})
		target:SetModifierStackCount("modifier_ogthun_health", ability, healthBonusStacks)
		target:CalculateStatBonus()
	end
end

function eternal_night_take_damage(event)
	local target = event.unit
	if not target:HasModifier("modifier_eternal_night_sleep_unwakable") then
		target:RemoveModifierByName("modifier_eternal_night_sleep")
	end
end

function silverspring_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local currentStacks = target:GetModifierStackCount("modifier_silverspring_effect", ability)
	local stacks = math.min((500000000 - (target:GetBaseDamageMin() - currentStacks * SILVERSPRING_BASE_DMG_PER_REGEN)) / SILVERSPRING_BASE_DMG_PER_REGEN, math.max(0, math.floor(target:GetHealthRegen() * 1.0)))
	if not target:HasModifier("modifier_silverspring_effect") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_silverspring_effect", {})
	end
	target:SetModifierStackCount("modifier_silverspring_effect", ability, stacks)
end

function cascade_hat_think(event)
	local caster = event.target
	local ability = event.ability
	ability.caster = caster
	local manaDrain = caster:GetMaxMana() * 0.02
	if manaDrain > caster:GetMana() then
		manaDrain = caster:GetMana()
	end
	ability.damage = manaDrain * 8000 * (caster:GetLevel() / 120) ^ 2
	caster:ReduceMana(manaDrain)
	-- local fv = caster:GetForwardVector()
	-- if manaDrain < caster:GetMana() then
	--
	-- cascade_projectile(ability, caster, fv)
	-- cascade_projectile(ability, caster, WallPhysics:rotateVector(fv, math.pi))
	-- cascade_projectile(ability, caster, WallPhysics:rotateVector(fv, 3*math.pi/2))
	-- cascade_projectile(ability, caster, WallPhysics:rotateVector(fv, math.pi/2))

	-- cascade_projectile(ability, caster, WallPhysics:rotateVector(fv, math.pi/4))
	-- cascade_projectile(ability, caster, WallPhysics:rotateVector(fv, 3*math.pi/4))
	-- cascade_projectile(ability, caster, WallPhysics:rotateVector(fv, 5*math.pi/4))
	-- cascade_projectile(ability, caster, WallPhysics:rotateVector(fv, 7*math.pi/4))
	-- end
end

function cascade_aura(event)
	local target = event.target
	local ability = event.ability
	if ability.damage then
		local damage = event.ability.damage
		Filters:ApplyItemDamage(target, event.ability.caster, damage, DAMAGE_TYPE_MAGICAL, event.ability, RPC_ELEMENT_ARCANE, RPC_ELEMENT_NONE)
	end
end

function royal_wristguard_take_damage(event)
	local target = event.unit
	local ability = event.ability
	local caster = event.caster

	ability:ApplyDataDrivenModifier(caster, target, "modifier_royal_wristguards_stack_effect", {duration = ROYAL_WRISTGUARDS_STACK_DURATION})
	local current_stack = target:GetModifierStackCount("modifier_royal_wristguards_stack_effect", ability)
	local newStack = math.min(current_stack + 1, ROYAL_WRISTGUARDS_CHARGE_CAP)
	target:SetModifierStackCount("modifier_royal_wristguards_stack_effect", ability, newStack)
end

function old_wisdom_spell_cast(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.unit
	local executedAbility = event.event_ability
	--print(executedAbility:GetAbilityName())
	--print(ability.lastUsedAbilityName)
	if executedAbility:GetAbilityName() == ability.lastUsedAbilityName then
		--print("REMOVE??")
		ability:ApplyDataDrivenModifier(caster, target, "modifier_boots_of_old_wisdom_cooldown", {duration = 12})
		target:RemoveModifierByName("modifier_boots_of_old_wisdom_active")
	end
	ability.lastUsedAbilityName = executedAbility:GetAbilityName()
end

function old_wisdom_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if not target:HasModifier("modifier_boots_of_old_wisdom_cooldown") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_boots_of_old_wisdom_active", {})
	else
		target:RemoveModifierByName("modifier_boots_of_old_wisdom_active")
	end
end

function old_wisdom_active_particle(event)
	local target = event.target
	CustomAbilities:QuickAttachParticle("particles/econ/items/doom/doom_f2p_death_effect/boots_of_old_wisdom.vpcf", target, 0.9)
end

function mageplate_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local armorBonus = (target:GetIntellect() / 10) * 1
	ability:ApplyDataDrivenModifier(caster, target, "modifier_mageplate_armor", {})
	target:SetModifierStackCount("modifier_mageplate_armor", ability, armorBonus)
end

function mageplate_take_damage(event)
	local target = event.unit
	local ability = event.ability
	local caster = event.caster
	local damage = event.damage
	ability:ApplyDataDrivenModifier(caster, target, "modifier_infused_mageplate_stack", {duration = 15})
	local current_stack = target:GetModifierStackCount("modifier_infused_mageplate_stack", ability)
	local newStack = math.min(current_stack + 1, 100)
	target:SetModifierStackCount("modifier_infused_mageplate_stack", ability, newStack)
	local manaRestore = damage * 0.05
	target:GiveMana(manaRestore)
	if not ability.particles then
		ability.particles = 0
	end
	if ability.particles < 6 then
		CustomAbilities:QuickAttachParticle("particles/items3_fx/mango_active.vpcf", target, 1)
		ability.particles = ability.particles + 1
		Timers:CreateTimer(1, function()
			ability.particles = ability.particles - 1
		end)
	end

	ability:ApplyDataDrivenModifier(caster, target, "modifier_mageplate_intelligence", {duration = 15})
	local intBonus = target:GetLevel() * 1.2 * newStack
	target:SetModifierStackCount("modifier_mageplate_intelligence", caster, intBonus)
end

function mageplate_buff_end(event)
	local caster = event.caster
	local target = event.target
	local manaPercentage = target:GetMana() / target:GetMaxMana()
	local ability = event.ability
	ability.manaPercentage = manaPercentage
end

function mageplate_buff_end_int(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	Timers:CreateTimer(0.03, function()
		local manaSet = ability.manaPercentage * target:GetMaxMana()
		target:SetMana(manaSet)
	end)
end

function nobility_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, target, "modifier_ring_of_nobility_buff", {})
	target:SetModifierStackCount("modifier_ring_of_nobility_buff", ability, target:GetLevel())
end

function nobility_think_augmented(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, target, "modifier_ring_of_nobility_buff_augmented", {})
	target:SetModifierStackCount("modifier_ring_of_nobility_buff_augmented", ability, target:GetLevel())
end

function nobility_kill(event)
	local attacker = event.attacker
	local ability = event.ability
	if type(ability.newItemTable.property1) == "string" then
		ability.newItemTable.property1 = 0
	end
	local nextValue = ability.newItemTable.property1 + 1
	local upgradeThreshold = 10000
	if nextValue >= upgradeThreshold then
		RPCItems:CreateAugmentedRingOfNobility(attacker, ability)
		Notifications:Top(attacker:GetPlayerOwnerID(), {text = "Ring of Nobility Upgraded", duration = 5, style = {color = "white"}, continue = true})
		CustomAbilities:QuickAttachParticle("particles/econ/items/legion/legion_weapon_voth_domosh/legion_duel_start_endcap_arcana.vpcf", attacker, 3)
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_legion_commander/legion_commander_duel_winner_rays.vpcf", attacker, 3)

		EmitSoundOn("Items.NobilityUpgrade", attacker)
	else
		ability.newItemTable.property1 = nextValue
		RPCItems:SetPropertyValuesSpecial(ability, ability.newItemTable.property1, "#item_property_nobility", "#FFFFFF", 1, "#property_nobility_description")
		RPCItems:ItemUpdateCustomNetTables(ability)
	end
end

function ironbound_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, target, "modifier_ironbound_effect", {})
	target:SetModifierStackCount("modifier_ironbound_effect", ability, target:GetPhysicalArmorValue(false))
end

function mordiggus_attack(event)
	local attacker = event.attacker
	local beginningHealth = attacker:GetHealth()
	local newHealth = math.max(attacker:GetHealth() - attacker:GetMaxHealth() * 0.07, 1)
	attacker:SetHealth(newHealth)
	CustomAbilities:QuickAttachParticle("particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodbath_eztzhok_ember.vpcf", attacker, 0.7)
	if attacker:HasModifier("modifier_wraith_hunters_steel_helm") then
		local damageTaken = math.max(beginningHealth - newHealth, 1)
		local eventTable = {}
		eventTable.unit = attacker
		eventTable.attack_damage = damageTaken
		eventTable.ability = attacker.headItem
		wraith_hunter_take_damage(eventTable)
	end
end

function wraith_hunter_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	if not ability.wraith_mana then
		ability.wraith_mana = 0
	end
	if target:HasModifier("modifier_bahamut_sphere_of_divinity") then
		local divinityAbility = target:FindAbilityByName("bahamut_arcana_orb")
		local manaDrainPerSecond = divinityAbility:GetLevelSpecialValueFor("mana_drain_per_second", divinityAbility:GetLevel())
		ability.wraith_mana = math.max(ability.wraith_mana - target:GetMaxMana() * manaDrainPerSecond * 0.03 / 100, 0)
	end
	target:SetMana(ability.wraith_mana)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_wraith_hunter_attack_increase", {})
	target:SetModifierStackCount("modifier_wraith_hunter_attack_increase", ability, target:GetMana())
end

function wraith_hunter_take_damage(event)
	local target = event.unit
	local damage = event.attack_damage
	local ability = event.ability
	local manaRestore = math.max(math.floor(damage * 0.03), 1)
	ability.wraith_mana = math.min(ability.wraith_mana + manaRestore, target:GetMaxMana())
	CustomAbilities:QuickAttachParticle("particles/items3_fx/mango_active_bubbles.vpcf", target, 1)
end

function wraith_hunter_attack(event)
	local attacker = event.attacker
	local ability = event.ability
	local manaSpent = math.min(attacker:GetMaxMana() * 0.02, attacker:GetMana())
	ability.wraith_mana = math.max(ability.wraith_mana - manaSpent, 0)
	if attacker:HasModifier("modifier_bluestar_armor") then
		local target = attacker
		target.bluestarSlideVelocity = 25
		local heal = manaSpent
		Filters:ApplyHeal(target, target, heal, true)

		target.body:ApplyDataDrivenModifier(target.InventoryUnit, target, "modifier_bluestar_slide", {duration = 0.6})

		local particleName = "particles/items_fx/arcane_boots.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		Timers:CreateTimer(0.2, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	end
end

function wraith_hunter_spell_cast(event)
	local target = event.unit
	local ability = event.ability
	local executedAbility = event.event_ability
	local manaSpent = executedAbility:GetManaCost(executedAbility:GetLevel() - 1)
	ability.wraith_mana = math.max(ability.wraith_mana - manaSpent, 0)
end

function twig_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	if not target:IsAlive() then
		return false
	end
	if target:HasModifier("modifier_recently_respawned") then
		return false
	end
	if not ability.twigPFX then
		local particleName = "particles/items3_fx/twig_of_enlightened_shield.vpcf"
		ability.twigPFX = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(ability.twigPFX, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(ability.twigPFX, 1, Vector(1, 1, 1))
	end
	if not target.manaShellAbsorb then
		target.manaShellAbsorb = 0
		target.manaShellMana = target:GetMana()
	end
	if target:GetMana() > target.manaShellMana then
		local manaGained = target:GetMana() - target.manaShellMana
		target.manaShellAbsorb = math.min(target.manaShellAbsorb + manaGained * 5, target:GetMaxMana() * 5)
		CustomAbilities:QuickAttachParticle("particles/econ/items/luna/luna_lucent_ti5/luna_eclipse_cast_flash_ti_5.vpcf", target, 1)
	end
	if ability.twigPFX then
		local ratio = math.min((target.manaShellAbsorb / (target:GetMaxMana() * 5)) * 255, 255)
		ParticleManager:SetParticleControl(ability.twigPFX, 1, Vector(ratio, ratio, ratio))
	end
	if target.manaShellAbsorb > 0 then
		if not target:HasModifier("modifier_twig_of_the_enlightened_shield") then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_twig_of_the_enlightened_shield", {})
		end
	else
		target:RemoveModifierByName("modifier_twig_of_the_enlightened_shield")
	end
	target.manaShellMana = target:GetMana()

end

function twig_shield_create(event)
	local target = event.target
	local ability = event.ability
	-- local particleName = "particles/items3_fx/twig_of_enlightened_shield.vpcf"
	-- if not ability.twigPFX then
	-- ability.twigPFX = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target)
	-- ParticleManager:SetParticleControlEnt(ability.twigPFX, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	-- ParticleManager:SetParticleControl(ability.twigPFX, 1, Vector(1, 1, 1))
	-- end
end

function twig_shield_destroy(event)
	local target = event.target
	local ability = event.ability
	if ability.twigPFX then
		ParticleManager:DestroyParticle(ability.twigPFX, true)
		ability.twigPFX = false
	end
end

function twig_shield_death(event)
	local target = event.unit
	local ability = event.ability
	if ability.twigPFX then
		ParticleManager:DestroyParticle(ability.twigPFX, true)
		ability.twigPFX = false
	end
end

function pure_waters_impact(event)
	local caster = event.ability.caster
	local damage = math.max(OverflowProtectedGetAverageTrueAttackDamage(caster) * 10, caster:GetIntellect() * 80)
	Filters:ApplyItemDamage(event.target, caster, damage, DAMAGE_TYPE_PURE, event.ability, RPC_ELEMENT_WATER, RPC_ELEMENT_NONE)
end

function sweeping_winds_attack(event)
	local attacker = event.attacker
	local caster = event.caster
	local ability = event.ability
	local currentStacks = attacker:GetModifierStackCount("modifier_sweeping_wind_stackable", caster)
	local newStacks = currentStacks - 1
	if newStacks == 0 then
		attacker:RemoveModifierByName("modifier_sweeping_wind_stackable")
	else
		attacker:SetModifierStackCount("modifier_sweeping_wind_stackable", caster.InventoryUnit, newStacks)
		if not ability.windParticle then
			local particleName = "particles/items2_fx/sweeping_winds_2.vpcf"
			ability.windParticle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, attacker)
			ParticleManager:SetParticleControlEnt(ability.windParticle, 0, attacker, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin(), true)
		end
		ParticleManager:SetParticleControl(ability.windParticle, 3, Vector(newStacks * 50, newStacks * 50, newStacks * 50))
	end

end

function sweeping_winds_glove_end(event)
	local attacker = event.target
	local ability = event.ability
	StopSoundEvent("Items.SweepingWind", attacker)
	if ability then
		if ability.windParticle then
			ParticleManager:DestroyParticle(ability.windParticle, false)
		end
		ability.windParticle = false
	end
end

function sweeping_winds_think(event)
	local target = event.target
	local caster = event.caster
	local enemies = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, 360, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		local currentStacks = target:GetModifierStackCount("modifier_sweeping_wind_stackable", caster)
		local damage = OverflowProtectedGetAverageTrueAttackDamage(target) * 0.05 * currentStacks
		for _, enemy in pairs(enemies) do
			CustomAbilities:QuickAttachParticle("particles/econ/items/elder_titan/elder_titan_fissured_soul/elder_titan_fissured_soul_spirit_buff_endcap.vpcf", enemy, 0.8)
			Filters:ApplyItemDamage(enemy, target, damage, DAMAGE_TYPE_MAGICAL, event.ability, RPC_ELEMENT_WIND, RPC_ELEMENT_NONE)
		end
	end
end

function depth_crest_hit(event)
	local target = event.target
	local proc = Filters:GetProc(target, 30)
	if proc then
		EmitSoundOn("Items.DepthCrest", target)
		local particleName = "particles/units/heroes/hero_slardar/slardar_crush.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
		ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin() + Vector(0, 0, 20))
		ParticleManager:SetParticleControl(pfx, 1, Vector(300, 0, 0))
		local enemies = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local damage = target:GetStrength() * 120 + target:GetPhysicalArmorValue(false) * 8000
			for _, enemy in pairs(enemies) do
				Filters:ApplyItemDamage(enemy, target, damage, DAMAGE_TYPE_MAGICAL, event.ability, RPC_ELEMENT_WATER, RPC_ELEMENT_NORMAL)
				Filters:ApplyStun(target, 0.1, enemy)
			end
		end
	end
end

function lava_forge_take_damage(event)
	local ability = event.ability
	local target = event.unit
	local attacker = event.attacker
	if target == event.attacker then
		return false
	end
	if not ability.fireballs then
		ability.fireballs = 0
		ability.caster = target
	end
	if ability.fireballs >= 6 then
		return false
	end
	local proc = Filters:GetProc(target, 40)
	local fv = (attacker:GetAbsOrigin() * Vector(1, 1, 0) - target:GetAbsOrigin() * Vector(1, 1, 0)):Normalized()

	local projectileParticle = "particles/units/heroes/hero_jakiro/fireball.vpcf"
	EmitSoundOn("Items.LavaforgeFire", target)
	local start_radius = 150
	local end_radius = 150
	local range = 1300
	local speed = 1100
	local casterOrigin = target:GetAbsOrigin()
	local info =
	{
		Ability = ability,
		EffectName = projectileParticle,
		vSpawnOrigin = casterOrigin + Vector(0, 0, 50),
		fDistance = range,
		fStartRadius = start_radius,
		fEndRadius = end_radius,
		Source = target,
		StartPosition = "attach_hitloc",
		bHasFrontalCone = true,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = true,
		vVelocity = fv * speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
	Timers:CreateTimer(3, function()
		ability.fireballs = ability.fireballs - 1
	end)
end

function lava_forge_fireball_hit(event)
	local ability = event.ability
	local caster = ability.caster
	local target = event.target

	--print("IMPACT?")
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * LAVA_FORGE_DMG_PER_ATT + caster:GetAgility() * LAVA_FORGE_DMG_PER_AGI

	local radius = LAVA_FORGE_RADIUS
	local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
	local particle2 = ParticleManager:CreateParticle(particleNameS, PATTACH_WORLDORIGIN, target)
	ParticleManager:SetParticleControl(particle2, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle2, 1, Vector(radius, radius, radius))
	ParticleManager:SetParticleControl(particle2, 2, Vector(2.0, 2.0, 2.0))
	ParticleManager:SetParticleControl(particle2, 4, Vector(255, 90, 20))
	Timers:CreateTimer(1.5, function()
		ParticleManager:DestroyParticle(particle2, false)
	end)

	local particleName = "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControl(particle1, 0, target:GetAbsOrigin())
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
	EmitSoundOn("Items.LavaforgeImpact", target)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:ApplyItemDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, event.ability, RPC_ELEMENT_FIRE, RPC_ELEMENT_WIND)
		end
	end
end

function water_mage_robes_channel_think(event)
	local caster = event.target
	local ability = event.ability
	ability.hero = caster
	EmitSoundOn("Tanari.WaterTemple.RareWrathWater", caster)
	local range = 1200
	local start_radius = 320
	local end_radius = 320
	local baseFV = caster:GetForwardVector()
	local speed = 700
	local projectileParticle = "particles/units/heroes/hero_tidehunter/tidehunter_gush_upgrade.vpcf"
	for i = 1, 6, 1 do
		local fv = WallPhysics:rotateVector(baseFV, 2 * math.pi * i / 6)
		local info =
		{
			Ability = ability,
			EffectName = projectileParticle,
			vSpawnOrigin = caster:GetAbsOrigin() + Vector(0, 0, 30),
			fDistance = range,
			fStartRadius = start_radius,
			fEndRadius = end_radius,
			Source = caster,
			StartPosition = "attach_origin",
			bHasFrontalCone = true,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 6.0,
			bDeleteOnHit = false,
			vVelocity = fv * speed,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
	end
end

function water_mage_robes_projectile_hit(event)
	local hero = event.ability.hero
	local target = event.target
	local ability = event.ability
	local damage = OverflowProtectedGetAverageTrueAttackDamage(hero) * 7 + hero:GetIntellect() * 30
	Filters:ApplyItemDamage(target, hero, damage, DAMAGE_TYPE_MAGICAL, event.ability, RPC_ELEMENT_WATER, RPC_ELEMENT_NONE)
	ability:ApplyDataDrivenModifier(event.caster, target, "modifier_water_mage_slow", {duration = 4})
end

function halcyon_glove_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, target, "modifier_halcyon_soul_glove_effect", {})
	local stacks = target:GetStrength() + target:GetAgility() + target:GetIntellect()
	target:SetModifierStackCount("modifier_halcyon_soul_glove_effect", caster, stacks)
end

function defiler_end(event)
	local target = event.target
	target.defiler = false
end

function nightmare_rider_attackland(event)
	local caster = event.caster
	local attacker = event.attacker
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, attacker, "modifier_nightmare_rider_stacks", {})
	local newStacks = math.min(attacker:GetModifierStackCount("modifier_nightmare_rider_stacks", caster) + 1, 20)
	attacker:SetModifierStackCount("modifier_nightmare_rider_stacks", caster, newStacks)
end

function leon_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster

	local primeAttribute = target:GetPrimaryAttribute()
	if primeAttribute == 0 then
		local strStacks = math.floor(target:GetBaseStrength() * 0.5, 0)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_gold_plate_of_leon_str", {})
		target:SetModifierStackCount("modifier_gold_plate_of_leon_str", ability, strStacks)
		target:RemoveModifierByName("modifier_gold_plate_of_leon_agi")
		target:RemoveModifierByName("modifier_gold_plate_of_leon_int")
	elseif primeAttribute == 1 then
		local agiStacks = math.floor(target:GetBaseAgility() * 0.5, 0)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_gold_plate_of_leon_agi", {})
		target:SetModifierStackCount("modifier_gold_plate_of_leon_agi", ability, agiStacks)
		target:RemoveModifierByName("modifier_gold_plate_of_leon_str")
		target:RemoveModifierByName("modifier_gold_plate_of_leon_int")
	elseif primeAttribute == 2 then
		local intStacks = math.floor(target:GetBaseIntellect() * 0.5, 0)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_gold_plate_of_leon_int", {})
		target:SetModifierStackCount("modifier_gold_plate_of_leon_int", ability, intStacks)
		target:RemoveModifierByName("modifier_gold_plate_of_leon_agi")
		target:RemoveModifierByName("modifier_gold_plate_of_leon_str")
	end
end

function mana_relic_attack(event)
	local attacker = event.attacker
	CustomAbilities:QuickAttachParticle("particles/roshpit/items/antique_mana_relic_restore.vpcf", attacker, 1.5)
	local manaRestore = attacker:GetMaxMana() * 0.025
	attacker:GiveMana(manaRestore)
end

function mana_relic_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local damageBoost = target:GetMana()
	if damageBoost > 0 then
		if not target:HasModifier("modifier_mana_relic_attack_damage") then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_mana_relic_attack_damage", {})
		end
		target:SetModifierStackCount("modifier_mana_relic_attack_damage", caster, damageBoost)
	else
		target:RemoveModifierByName("modifier_mana_relic_attack_damage")
	end
end

function ablecore_greaves_think(event)
	local caster = event.target
	local movespeed = caster:GetBaseMoveSpeed()
	local movespeedModifier = caster:GetMoveSpeedModifier(movespeed, false)
	if movespeedModifier <= 300 then
		event.ability:ApplyDataDrivenModifier(event.caster, caster, "modifier_ablecore_greaves_effect", {})
	else
		if caster:HasModifier("modifier_ablecore_greaves_effect") then
			if caster:FindModifierByName("modifier_ablecore_greaves_effect"):GetDuration() == -1 then
				event.ability:ApplyDataDrivenModifier(event.caster, caster, "modifier_ablecore_greaves_effect", {duration = 6})
			end
		else
			caster:RemoveModifierByName("modifier_ablecore_greaves_effect")
		end
	end
end

function dragon_scale_armor_think(event)
	local target = event.target
	local gem = event.gem
	local stats = 0
	if gem == "sapphire" then
		stats = target:GetIntellect()
	elseif gem == "ruby" then
		stats = target:GetStrength()
	elseif gem == "topaz" then
		stats = target:GetAgility()
	end
	local ability = event.ability
	local caster = event.caster
	local modifier_name = "modifier_"..gem.."_dragon_scale_effect"
	ability:ApplyDataDrivenModifier(caster, target, modifier_name, {})
	target:SetModifierStackCount(modifier_name, caster, stats)
end

function giant_hunter_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	if target:IsStunned() or target:IsRooted() then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_giant_hunters_immunity", {duration = 3.5})
	end
end

function spiritual_empowerment_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, target, "modifier_spiritual_empowerment_stack", {})
	local newStack = target:GetModifierStackCount("modifier_spiritual_empowerment_stack", caster) + 1
	newStack = math.min(newStack, 10)
	target:SetModifierStackCount("modifier_spiritual_empowerment_stack", caster, newStack)
end

function trials_attack(event)
	local damage = event.damage
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	damage = GameState:GetPostReductionPhysicalDamage(damage, target:GetPhysicalArmorValue(false))
	EmitSoundOn("Item.SacredTrial", target)
	local radius = 320
	local particleName = "particles/roshpit/items/sacred_trial.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControl(particle1, 0, target:GetAbsOrigin())
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)

	local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:ApplyItemDamage(enemy, attacker, damage * 10, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
		end
	end

	local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
	local particle2 = ParticleManager:CreateParticle(particleNameS, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particle2, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle2, 1, Vector(radius, radius, radius))
	ParticleManager:SetParticleControl(particle2, 2, Vector(1.0, 1.0, 1.0))
	ParticleManager:SetParticleControl(particle2, 4, Vector(255, 160, 50))
	Timers:CreateTimer(1.5, function()
		ParticleManager:DestroyParticle(particle2, false)
	end)
	attacker:RemoveModifierByName("modifier_sacred_trials_attack_bonus")
end

function gravekeeper_attack(event)
	local caster = event.caster
	local ability = event.ability
	local attacker = event.attacker
	local target = event.target
	if not ability.targetIndex then
		ability.targetIndex = target:GetEntityIndex()
		EmitSoundOn("Item.GraveKeeper", target)
	end
	if ability.targetIndex == target:GetEntityIndex() then
		local limitKey = caster:GetPlayerOwnerID() .. '_gravekeeper_gauntlet'
		Util.Common:LimitPerTime(GRAVEKEEPER_MAX_STACKS_PER_SEC, 1, limitKey, function()
			ability:ApplyDataDrivenModifier(caster, target, "modifier_gravekeeper_gauntlet_target", {duration = 9})
			ability:ApplyDataDrivenModifier(caster, attacker, "modifier_gravekeeper_gauntlet_buff", {duration = 9})
			local newTargetStacks = target:GetModifierStackCount("modifier_gravekeeper_gauntlet_target", caster) + 1
			target:SetModifierStackCount("modifier_gravekeeper_gauntlet_target", caster, newTargetStacks)
			local newAttackerStacks = attacker:GetModifierStackCount("modifier_gravekeeper_gauntlet_buff", caster) + 1
			attacker:SetModifierStackCount("modifier_gravekeeper_gauntlet_buff", caster, newAttackerStacks)
		end)
	else
		attacker:RemoveModifierByName("modifier_gravekeeper_gauntlet_target")
		attacker:RemoveModifierByName("modifier_gravekeeper_gauntlet_buff")
		ability:ApplyDataDrivenModifier(caster, target, "modifier_gravekeeper_gauntlet_target", {duration = 9})
		ability:ApplyDataDrivenModifier(caster, attacker, "modifier_gravekeeper_gauntlet_buff", {duration = 9})
		target:SetModifierStackCount("modifier_gravekeeper_gauntlet_target", caster, 1)
		attacker:SetModifierStackCount("modifier_gravekeeper_gauntlet_buff", caster, 1)
		EmitSoundOn("Item.GraveKeeper", target)
		ability.targetIndex = target:GetEntityIndex()
	end
end

function eyeglass_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if target:GetAttackCapability() == DOTA_UNIT_CAP_RANGED_ATTACK then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_epsilons_eyeglass_range_effect", {})
	else
		target:RemoveModifierByName("modifier_epsilons_eyeglass_range_effect")
	end
end

function autumn_sleeper_root_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	if not target:HasModifier("modifier_autumn_sleeper_root_immunity") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_autumn_sleeper_root", {duration = 3})
		ability:ApplyDataDrivenModifier(caster, target, "modifier_autumn_sleeper_root_immunity", {duration = 10})
	end
end

function eye_of_seasons_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability

	local stats = math.floor(target:GetBaseIntellect() * 0.35)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_eye_of_seasons_stats", {})
	target:SetModifierStackCount("modifier_eye_of_seasons_stats", caster, stats)
end

function autumnrock_bracer_take_damage(event)
	local hero = event.unit
	local ability = event.ability
	if target == event.attacker then
		return false
	end
	local proc = Filters:GetProc(hero, 10)
	if proc then
		local attacker = event.attacker
		local length = math.max(WallPhysics:GetDistance(hero:GetAbsOrigin() * Vector(1, 1, 0), attacker:GetAbsOrigin() * Vector(1, 1, 0)) / 250, 1)
		local fv = (attacker:GetAbsOrigin() * Vector(1, 1, 0) - hero:GetAbsOrigin() * Vector(1, 1, 0)):Normalized()
		local startPosition = hero:GetAbsOrigin()
		for i = 1, math.floor(length), 1 do
			Timers:CreateTimer(0.8 * (i - 1), function()
				local position = startPosition + fv * i * 260
				autumn_mage_boss_explosion(hero, position, damage, 160, ability)
			end)
		end
	end
end

function autumn_mage_boss_explosion(caster, position, damage, explosionAOE, ability)
	local particleName = "particles/econ/items/centaur/centaur_ti6/centaur_ti6_warstomp.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(particle1, 0, position)
	ParticleManager:SetParticleControl(particle1, 1, Vector(explosionAOE, 5, explosionAOE * 2))
	Timers:CreateTimer(4, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
	local damage = caster:GetStrength() * 200
	EmitSoundOnLocationWithCaster(position, "Item.AutumnMage.Quake", caster)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, explosionAOE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:ApplyItemDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_EARTH, RPC_ELEMENT_NONE)
			Filters:ApplyStun(caster, 2, enemy)
		end
	end
end

function fuchsia_ring_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	if target:IsStunned() or target:IsSilenced() then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_fuchsia_damage_resistance", {})
	else
		target:RemoveModifierByName("modifier_fuchsia_damage_resistance")
	end
end

function silent_templar_attack_land(event)
	local target = event.target
	if not target.dummy then
		local ability = event.ability
		local attacker = event.attacker
		local damage = OverflowProtectedGetAverageTrueAttackDamage(attacker) * 60
		Filters:ApplyItemDamage(target, attacker, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_ARCANE, RPC_ELEMENT_DEMON)
		CustomAbilities:QuickAttachParticle("particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void_hit.vpcf", target, 2.5)
		EmitSoundOn("Item.SilentWatch.Hit", target)
	end
end

function mana_wall_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local currentmana = target:GetMana()
	if currentmana > 30 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_mystic_mana_wall_armor", {})
		target:SetModifierStackCount("modifier_mystic_mana_wall_armor", caster, currentmana / 30)
	else
		target:RemoveModifierByName("modifier_mystic_mana_wall_armor")
	end
end

function sandstream_stack_increase(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	if target:HasModifier("modifier_sandstream_slippers_stack") then
		local newStacks = math.min(target:GetModifierStackCount("modifier_sandstream_slippers_stack", caster) + 1, 2)
		target:SetModifierStackCount("modifier_sandstream_slippers_stack", caster, newStacks)
	else
		ability:ApplyDataDrivenModifier(caster, target, "modifier_sandstream_slippers_stack", {})
		target:SetModifierStackCount("modifier_sandstream_slippers_stack", caster, 1)
	end
end

function malachite_shade_bracer_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	local regenStacks = math.ceil(target:GetAgility() * 0.15)
	local damageStacks = target:GetHealthRegen() + target:GetBaseManaRegen() + target:GetBonusManaRegen ()
	ability:ApplyDataDrivenModifier(caster, target, "modifier_malachite_shade_regen", {})
	target:SetModifierStackCount("modifier_malachite_shade_regen", caster, regenStacks)

	ability:ApplyDataDrivenModifier(caster, target, "modifier_malachite_shade_damage", {})
	target:SetModifierStackCount("modifier_malachite_shade_damage", caster, damageStacks)
end

function wind_deity_think(event)
	local ability = event.ability
	ability.targetsHit = 0
end

function init_wind_deity(event)
	local ability = event.ability
	ability.targetsHit = 0
end

function infernal_prison_attacker_think(event)
	local ability = event.ability
	local target = event.target
	local caster = event.caster.hero
	local damage = caster:GetPhysicalArmorValue(false) * 50
	Filters:ApplyItemDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
end

function infernal_prison_nearby_think(event)
	local ability = event.ability
	local target = event.target
	local caster = event.caster.hero
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)
	Filters:ApplyItemDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
end

function skulldigger_think(event)
	local ability = event.ability
	local target = event.target
	local caster = event.caster
	local currentStacks = target:GetModifierStackCount("modifier_skulldigger_hellfire_stacks", caster)
	if currentStacks == 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_skulldigger_hellfire_stacks", {})
	end
	local maxStacks = event.max_stacks
	local newStacks = math.min(currentStacks + 1, maxStacks)
	target:SetModifierStackCount("modifier_skulldigger_hellfire_stacks", caster, newStacks)
end

function hellfire_stack_take_damage(event)
	local ability = event.ability
	local target = event.unit
	local caster = event.caster
	local attacker = event.attacker
	if target == attacker then
		return false
	end
	ability.caster = target
	local currentStacks = target:GetModifierStackCount("modifier_skulldigger_hellfire_stacks", caster)
	local newStacks = currentStacks - 1
	if newStacks == 0 then
		target:RemoveModifierByName("modifier_skulldigger_hellfire_stacks")
	else
		target:SetModifierStackCount("modifier_skulldigger_hellfire_stacks", caster, newStacks)
	end
	EmitSoundOn("RoshpitItem.SkulldiggerLaunch", target)
	local info =
	{
		Target = attacker,
		Source = target,
		Ability = ability,
		EffectName = "particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast.vpcf",
		StartPosition = "attach_hitloc",
		bDrawsOnMinimap = false,
		bDodgeable = false,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 4,
		bProvidesVision = true,
		iVisionRadius = 0,
		iMoveSpeed = 1000,
	iVisionTeamNumber = caster:GetTeamNumber()}
	projectile = ProjectileManager:CreateTrackingProjectile(info)
end

function skulldigger_hellfire_hit(event)
	local target = event.target

	local ability = event.ability
	local caster = ability.caster
	local stun_duration = event.stun_duration
	local attack_mult = event.attack_mult
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * attack_mult

	EmitSoundOn("RoshpitItem.SkulldiggerImpact", target)

	local radius = 240
	local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
	local particle2 = ParticleManager:CreateParticle(particleNameS, PATTACH_WORLDORIGIN, target)
	ParticleManager:SetParticleControl(particle2, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle2, 1, Vector(radius, radius, radius))
	ParticleManager:SetParticleControl(particle2, 2, Vector(2.0, 2.0, 2.0))
	ParticleManager:SetParticleControl(particle2, 4, Vector(0, 220, 100))
	Timers:CreateTimer(1.5, function()
		ParticleManager:DestroyParticle(particle2, false)
	end)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:ApplyStun(caster, stun_duration, enemy)
			Filters:ApplyItemDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_NONE)
		end
	end
end

function shipyard_shield_lvl3_take_damage(event)
	local unit = event.unit
	local attacker = event.attacker
	local ability = event.ability
	ability.hero = unit
	local info =
	{
		Target = attacker,
		Source = unit,
		Ability = ability,
		EffectName = "particles/roshpit/redfall/shipyard_tracking_skull_enemy.vpcf",
		StartPosition = "attach_hitloc",
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 8,
		bProvidesVision = true,
		iVisionRadius = 0,
		iMoveSpeed = 500,
	iVisionTeamNumber = unit:GetTeamNumber()}
	projectile = ProjectileManager:CreateTrackingProjectile(info)
end

function shipyard_veil_lvl_3_hit(event)
	local ability = event.ability
	local target = event.target
	local caster = ability.hero
	if not caster then
		return false
	end
	local damage = Filters:GetPrimaryAttributeMultiple(caster, ability:GetLevelSpecialValueFor("property_three", 1))
	Filters:ApplyItemDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_NONE)
end

function crimsyth_elite_greaves_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability

	if target:HasModifier("modifier_crimsyth_elite_greaves_magic_shield") then
		target:RemoveModifierByName("modifier_crimsyth_elite_greaves_armor")
	else
		ability:ApplyDataDrivenModifier(caster, target, "modifier_crimsyth_elite_greaves_armor", {})
		target:SetModifierStackCount("modifier_crimsyth_elite_greaves_armor", caster, target:GetLevel())
	end
end

function berserker_gloves_attack_land(event)

	local attacker = event.attacker
	local ability = event.ability
	local target = event.target
	local caster = event.caster
	if not ability.targetIndex then
		ability.targetIndex = target:GetEntityIndex()
	end
	local heroLevel = attacker:GetLevel()
	local multiplier = 1

	if target:GetEntityIndex() == ability.targetIndex then
	else
		multiplier = 0.75
	end

	ability:ApplyDataDrivenModifier(caster, attacker, "modifier_berserker_gloves_buff_visible", {duration = 12})
	local newStacks = math.floor((attacker:GetModifierStackCount("modifier_berserker_gloves_buff_visible", caster) + 1) * multiplier)
	attacker:SetModifierStackCount("modifier_berserker_gloves_buff_visible", caster, newStacks)

	ability:ApplyDataDrivenModifier(caster, attacker, "modifier_berserker_gloves_buff_invisible", {duration = 12})
	attacker:SetModifierStackCount("modifier_berserker_gloves_buff_invisible", caster, newStacks * heroLevel)

	ability.targetIndex = target:GetEntityIndex()

end

function basilisk_plague_petrify(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	if not target:HasModifier("modifier_basilisk_plague_petrify") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_basilisk_petrify_stacks", {duration = 1})
		local newStacks = target:GetModifierStackCount("modifier_basilisk_petrify_stacks", caster) + 1
		target:SetModifierStackCount("modifier_basilisk_petrify_stacks", caster, newStacks)
		if newStacks >= BASILISK_PLAGUE_TIME_BEFORE_STONE_FORM / BASILISK_PLAGUE_THINK_INTERVAL then
			target:RemoveModifierByName("modifier_basilisk_petrify_stacks")
			ability:ApplyDataDrivenModifier(caster, target, "modifier_basilisk_plague_petrify", {duration = BASILISK_PLAGUE_STONE_FORM_DUR})
		end
	end
end

function blade_slinger_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local hero = target
	if hero:IsAlive() then
		local lookupPoint = hero:GetAbsOrigin() - hero:GetForwardVector() * 120
		local enemies_initial = FindUnitsInRadius(hero:GetTeamNumber(), lookupPoint, nil, 280, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		local enemies = {}
		for i = 1, #enemies_initial, 1 do
			local check_enemy = enemies_initial[i]
			if not check_enemy:HasModifier("modifier_possession_enemy_lock") then
				if not check_enemy.dummy then
					table.insert(enemies, check_enemy)
				end
			end
		end
		if #enemies > 0 then
			local facingVector = ((enemies[1]:GetAbsOrigin() - hero:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
			local angle = WallPhysics:vectorToAngle(facingVector)
			hero:SetAngles(0, angle, 0)
			Timers:CreateTimer(0.42, function()
				hero:SetAngles(0, 0, 0)
			end)
			StartAnimation(hero, {duration = 0.5, activity = ACT_DOTA_ATTACK, rate = 3.2})
			if not hero:IsStunned() and not hero:IsDisarmed() then
				for _, enemy in pairs(enemies) do
					Filters:PerformAttackSpecial(hero, enemy, true, true, true, false, true, false, false)
				end
			end
		end
	end
end

function doom_summon_think(event)
	local caster = event.caster
	local doomAbility = caster:FindAbilityByName("doomplate_castable_doom")
	--print("IS DOOM THINKING?")
	-- if not caster.caster:HasModifier("modifier_doomplate_doom_debuff") then

	-- end
	if doomAbility:IsFullyCastable() then
		--print("IS FULLY CASTABLE?")
		local newOrder = {
			UnitIndex = caster:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			TargetIndex = caster.caster:entindex(),
			AbilityIndex = doomAbility:entindex(),
		}

		ExecuteOrderFromTable(newOrder)
	end

	if doomAbility:GetCooldownTimeRemaining() > 0 then
		local dmg = caster.OverflowProtectedGetAverageTrueAttackDamage(caster) * 2
		dmg = Filters:AdjustItemDamage(caster.caster, dmg, nil)
		Filters:SetAttackDamage(caster, dmg)
		caster:SetTeam(caster.caster:GetTeamNumber())
		caster:SetAcquisitionRange(0)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local fv = ((enemies[1]:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
			doomplate_pyroblast_fire(caster, event.ability, fv)
		else
			local blinkAbility = caster:FindAbilityByName("doomplate_blink_ability")
			if blinkAbility:IsFullyCastable() then
				local enemiesBlink = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 690, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
				if #enemiesBlink > 0 then
					local castPoint = enemiesBlink[1]:GetAbsOrigin() + RandomVector(200)
					local newOrder = {
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
						AbilityIndex = blinkAbility:entindex(),
						Position = castPoint
					}
					ExecuteOrderFromTable(newOrder)
					return
				end
			end
			caster:SetAcquisitionRange(2000)
			local enemies2 = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			if #enemies2 == 0 then
				caster:MoveToPosition(caster.caster:GetAbsOrigin() + RandomVector(400))
			else
			end
		end
	else
		caster:SetTeam(DOTA_TEAM_NEUTRALS)
		caster:SetAcquisitionRange(2000)
	end
end

function doomplate_pyroblast_fire(caster, ability, fv)
	local casterOrigin = caster:GetAbsOrigin()
	-- StartSoundEvent("RPCItem.Doomplate.PyroFrenzyLP", caster)
	--   Timers:CreateTimer(1.5,
	--   function()
	-- StopSoundEvent("RPCItem.Doomplate.PyroFrenzyLP", caster)
	--   end)
	local start_radius = 180
	local end_radius = 180
	local range = 2400
	local speed = 750
	local info =
	{
		Ability = ability,
		EffectName = "particles/econ/items/puck/puck_alliance_set/pyroblast_aproset.vpcf",
		vSpawnOrigin = casterOrigin,
		fDistance = range,
		fStartRadius = start_radius,
		fEndRadius = end_radius,
		Source = caster,
		StartPosition = "attach_origin",
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = true,
		vVelocity = fv * speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
end

function doomplate_pyroblast_impact(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)
	Filters:ApplyItemDamage(target, caster, damage, DAMAGE_TYPE_PURE, ability, RPC_ELEMENT_FIRE, RPC_ELEMENT_DEMON)
end

function doomplate_pyroblast_impact_main(event)
	local ability = event.ability
	local caster = event.caster.caster
	local target = event.target
	EmitSoundOn("RPCItem.Doomplate.PyroImpact", target)
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 280, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:ApplyItemDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_FIRE, RPC_ELEMENT_DEMON)
		end
	end
end

function doom_blink(event)
	local caster = event.caster
	local point = event.target_points[1]

	EmitSoundOn("RPCItem.Doomplate.Blink", caster)

	StartAnimation(caster, {duration = 1, activity = ACT_DOTA_TELEPORT_END, rate = 1.0})
	local particleName = "particles/econ/events/ti6/blink_dagger_start_ti6_lvl2.vpcf"
	local pfx1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx1, 0, caster:GetAbsOrigin())
	local newPosition = point
	FindClearSpaceForUnit(caster, newPosition, false)
	local pfx2 = ParticleManager:CreateParticle("particles/econ/events/ti6/blink_dagger_end_ti6.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx2, 0, newPosition)
	Timers:CreateTimer(4, function()
		ParticleManager:DestroyParticle(pfx1, false)
		ParticleManager:DestroyParticle(pfx2, false)
	end)
end

function doomplate_doom_die(event)
	local caster = event.caster
	local ability = event.ability
	local target = caster.caster
	target:RemoveModifierByName("modifier_doom_bringer_doom")
	target:RemoveModifierByName("modifier_doomplate_cooldown")
end

function cobalt_serenity_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	ability:ApplyDataDrivenModifier(caster, target, "modifier_cobalt_serenity_health_regen", {})
	local healthRegenStacks = Filters:GetHeroAttribute(target, "intellect") * 8
	target:SetModifierStackCount("modifier_cobalt_serenity_health_regen", caster, healthRegenStacks)
end

function ethereal_revenant_start(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
	EmitSoundOn("RPCItem.EtherealRevenant.Start", target)
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_static_link.vpcf", PATTACH_CUSTOMORIGIN, hero)
	ParticleManager:SetParticleControlEnt(pfx, 0, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	target.revenantData = {hero:GetEntityIndex(), pfx, target}
	if not ability.pfxTable then
		ability.pfxTable = {}
	end
	table.insert(ability.pfxTable, target.revenantData)
end

function ethereal_revenant_think(event)
	local target = event.target
	local ability = event.ability
	if not ability.pfxTable then
		return false
	end
	local caster = event.caster
	local hero = caster.hero
	local newpfxTable = {}
	for i = 1, #ability.pfxTable, 1 do
		if not IsValidEntity(ability.pfxTable[i][3]) then
			ParticleManager:DestroyParticle(ability.pfxTable[i][2], false)
		else
			if ability.pfxTable[i][3]:HasModifier("modifier_ethereal_revenant_link") then
				table.insert(newpfxTable, ability.pfxTable[i])
			else
				ParticleManager:DestroyParticle(ability.pfxTable[i][2], false)
			end
		end
	end
	ability.pfxTable = newpfxTable
end

function ethereal_revenant_end(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
	EmitSoundOn("RPCItem.EtherealRevenant.End", target)

	ParticleManager:DestroyParticle(target.revenantData[2], false)
	target.revenantData = nil
end

function crimson_skull_cap_kill(event)
	local caster = event.caster.hero
	local target = event.unit
	local damage = target:GetMaxHealth() * 0.5
	local particleName = "particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf"
	local shadowFlarePos = GetGroundPosition(target:GetAbsOrigin(), caster)
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particle1, 0, shadowFlarePos)
	Timers:CreateTimer(1.2, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
	particleName = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
	local particle2 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particle2, 0, shadowFlarePos)
	ParticleManager:SetParticleControl(particle2, 1, Vector(260, 260, 260))
	ParticleManager:SetParticleControl(particle2, 2, Vector(1.6, 1.6, 1.6))
	ParticleManager:SetParticleControl(particle2, 4, Vector(200, 20, 20))
	Timers:CreateTimer(1.5, function()
		ParticleManager:DestroyParticle(particle2, false)
	end)
	EmitSoundOn("RPCItem.CrimsonSkullCap.Explode", target)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 260, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:ApplyItemDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, event.ability, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_NONE)
		end
	end
end

function igneous_canine_damage(event)
	local target = event.target
	local caster = event.ability.hero
	local ability = event.ability
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * 2
	Filters:ApplyItemDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
end

function hurricane_vest_create(event)

	local caster = event.caster.hero
	local ability = event.ability
	local fv = caster:GetForwardVector()
	ability.pushFV = fv
	local hurricaneStartPosition = caster:GetAbsOrigin()
	local range = HURRICANE_VEST_MAX_DISTANCE
	local start_radius = 220
	local end_radius = 220
	local speed = HURRICANE_VEST_HURRICANE_SPEED
	local projectileParticle = "particles/roshpit/items/hurricane_vest.vpcf"
	EmitSoundOn("RPCItem.HurricaneVestNew", caster)
	if not ability.cast_number then
		ability.cast_number = 0
	end
	ability.cast_number = ability.cast_number + 1
	ability.caster = caster
	for i = 1, HURRICANE_VEST_HURRICANE_COUNT do
		local shotVector = WallPhysics:rotateVector(fv, (2 * math.pi / HURRICANE_VEST_HURRICANE_COUNT) * i)
		local info =
		{
			Ability = caster.body,
			EffectName = projectileParticle,
			vSpawnOrigin = hurricaneStartPosition,
			fDistance = range,
			fStartRadius = start_radius,
			fEndRadius = end_radius,
			Source = event.caster,
			StartPosition = "attach_origin",
			bHasFrontalCone = true,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 5.0,
			bDeleteOnHit = false,
			vVelocity = shotVector * speed,
			bProvidesVision = false,
		}
		ProjectileManager:CreateLinearProjectile(info)
	end
end

function hurricane_vest_hit(event)
	local target = event.target
	local ability = event.ability
	local caster = ability.caster
	if not caster then
	end
	if not target.hurricane_cast_number then
		target.hurricane_cast_number = 0
	end
	if ability.cast_number ~= target.hurricane_cast_number then
		target.hurricane_cast_number = ability.cast_number
		local damage = HURRICANE_VEST_DMG_AMP * (caster:GetLevel() / 120 * (HURRICANE_VEST_MAX_DISTANCE - WallPhysics:GetDistance2d(caster:GetAbsOrigin(), target:GetAbsOrigin()))) ^ HURRICANE_VEST_DMG_EXP_SCALE
		Filters:ApplyItemDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, caster.body, RPC_ELEMENT_WIND, RPC_ELEMENT_ICE)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_hurricane_vest_slow", {duration = HURRICANE_VEST_SLOW_DUR})

	end
end

function new_ruby_dragon_think(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	if not ability.interval then
		ability.interval = 0
	end
	ability.interval = ability.interval + 1
	if caster:HasModifier("ruby_dragon_cinematic") then
		return false
	end
	if ability.interval % 2 == 1 then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), hero:GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			caster:MoveToPosition(enemies[1]:GetAbsOrigin() + RandomVector(120))
		else
			caster:MoveToPosition(hero:GetAbsOrigin() + RandomVector(420))
		end
	end
	if ability.interval % 2 == 0 then
		local fv = caster:GetForwardVector()
		StartAnimation(caster, {duration = 1, activity = ACT_DOTA_ATTACK, rate = 1.2})
		local projectileParticle = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf"
		local info =
		{
			Ability = ability,
			EffectName = projectileParticle,
			vSpawnOrigin = caster:GetAbsOrigin() + Vector(0, 0, 120),
			fDistance = RUBY_DRAGON_DISTANCE,
			fStartRadius = 180,
			fEndRadius = 350,
			Source = caster,
			StartPosition = "attach_origin",
			bHasFrontalCone = true,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 5.0,
			bDeleteOnHit = false,
			vVelocity = fv * RUBY_DRAGON_DISTANCE,
			bProvidesVision = false,
		}
		EmitSoundOn("Creature.FireBreath.Cast", caster)
		projectile = ProjectileManager:CreateLinearProjectile(info)
	end
	if ability.interval == RUBY_DRAGON_DURATION then
		ability:ApplyDataDrivenModifier(caster, caster, "ruby_dragon_cinematic", {duration = 1.5})
		caster.entering = false
		Timers:CreateTimer(1.5, function()
			caster:RemoveModifierByName("ruby_dragon_cinematic")
			UTIL_Remove(caster)
		end)
	end
end

function ruby_dragon_flame_impact(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	local damage = hero:GetStrength() * RUBY_DRAGON_IMPACT_DMG_PER_STR
	local target = event.target
	Damage:Apply({
		attacker = hero,
		victim = target,
		source = ability,
		sourceType = BASE_ITEM,
		damage = damage,
		damageType = DAMAGE_TYPE_MAGICAL,
		elements = {
			RPC_ELEMENT_FIRE
		}
	})
	hero.headItem:ApplyDataDrivenModifier(hero.InventoryUnit, target, "ruby_dragon_burn", {duration = RUBY_DRAGON_TICK_DURATION})
	local modifier = target:FindModifierByName('ruby_dragon_burn')
	Util.Modifier:SetIndependentlyStacks(hero, target, modifier, 1, RUBY_DRAGON_TICK_DURATION)
end

function ruby_dragon_flame_think(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	local target = event.target
	local burnDamage = hero:GetStrength() * RUBY_DRAGON_TICK_DMG_PER_STR
	local stacksCount = target:FindModifierByName('ruby_dragon_burn'):GetStackCount()
	for i = 1, stacksCount do
		Damage:Apply({
			attacker = hero,
			victim = target,
			source = ability,
			sourceType = BASE_ITEM,
			damage = burnDamage,
			damageType = DAMAGE_TYPE_MAGICAL,
			elements = {
				RPC_ELEMENT_FIRE
			},
			dot = true
		})
	end
end

function ruby_dragon_entering_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.entering then
		caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, -16) + caster:GetForwardVector() * 20)
	else
		caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, 13) + caster:GetForwardVector() * 20)
	end
end

function tiny_avalanche_think(event)
	local target = event.target
	local ability = event.ability
	ParticleManager:SetParticleControl(ability.pfx, 0, target:GetAbsOrigin())
	local enemies = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, 420, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	local levelTwo = true
	if #enemies > 0 then
		local mult = 6
		if levelTwo then
			mult = 15
		end
		local damage = target:GetStrength() * mult
		for _, enemy in pairs(enemies) do
			Filters:ApplyItemDamage(enemy, target, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_EARTH, RPC_ELEMENT_NONE)
			Filters:ApplyStun(target, 0.1, enemy)
			if levelTwo then
				ability.strikeCount = ability.strikeCount + 1
				if ability.strikeCount % 20 == 0 then
					local radius = 800
					local caster = target
					local splitEarthParticle = "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf"
					local position = caster:GetAbsOrigin()
					local pfx = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControl(pfx, 0, position)
					ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
					Timers:CreateTimer(4, function()
						ParticleManager:DestroyParticle(pfx, false)
					end)
					EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "RPCItem.Avalanche2Quake", caster)
					local damage = caster:GetStrength() * 80
					local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
					if #enemies > 0 then
						for _, enemy in pairs(enemies) do
							Filters:ApplyItemDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, nil, RPC_ELEMENT_EARTH, RPC_ELEMENT_NONE)
							Filters:ApplyStun(caster, 1.5, enemy)
						end
					end
				end
			end
		end
	end
end

function eternal_frost_slowing(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if not target:HasModifier("modifier_eternal_frost_nova") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_eternal_frost_slowing_effect", {duration = 3})
		local newStacks = target:GetModifierStackCount("modifier_eternal_frost_slowing_effect", caster) + 1
		target:SetModifierStackCount("modifier_eternal_frost_slowing_effect", caster, newStacks)
		local movespeed = target:GetBaseMoveSpeed()
		local movespeedModifier = target:GetMoveSpeedModifier(movespeed, false)
		if movespeedModifier <= 150 then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_eternal_frost_nova", {duration = 4.5})
			target:RemoveModifierByName("modifier_eternal_frost_slowing_effect")
			EmitSoundOn("RPCItem.EternalFrostFreeze", target)
		else
		end
	end
end

function seraphic_soul_hit(event)
	local ability = event.ability

	local hero = ability.hero

	local target = event.target
	local abilityLevel = hero:GetAbilityByIndex(DOTA_W_SLOT):GetLevel()
	if target:IsAlive() then
		EmitSoundOn("RPCItem.SoulVestImpact", target)
		local damage = OverflowProtectedGetAverageTrueAttackDamage(hero) * 0.5 * abilityLevel
		Filters:ApplyItemDamage(target, hero, damage, DAMAGE_TYPE_PURE, ability, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
	end
end

function doomplate_doom_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	StartSoundEvent("RPCItem.DoomPlate.Doom", target)
end

function doomplate_doom_end(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	StopSoundEvent("RPCItem.DoomPlate.Doom", target)
end

function baron_storm_take_damage(event)
	local caster = event.caster.hero
	local ability = event.ability
	local attacker = event.attacker
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * BARON_STORM_DMG_PER_ATT
	if not caster:HasModifier('modifier_baron_storm_cooldown') then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_baron_storm_cooldown", {duration = BARON_STORM_COOLDOWN})
		baron_storm_arc(attacker, caster, ability, damage, 0, BARON_STORM_MAX_TARGETS)
	end
end

function baron_storm_arc(target, caster, ability, damage, targetNumber, maxTargets)
	if IsValidEntity(target) then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, BARON_STORM_SEARCH_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false)
		if #enemies > 0 then
			local newTarget = enemies[1]
			if targetNumber ~= 0 then
				if newTarget == target then
					newTarget = enemies[2]
				end
			else
				newTarget = target
				target = caster
			end
			if newTarget then
				ability:ApplyDataDrivenModifier(caster, newTarget, "modifier_baron_storm_link", {duration = BARON_STORM_DUR})
				Filters:ApplyItemDamage(newTarget, caster, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_WIND)
				EmitSoundOn("Hero_Zuus.ArcLightning.Target", target)
				local particleName = "particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf"
				local targetPos = target:GetAbsOrigin()
				local newTargetPos = newTarget:GetAbsOrigin()
				local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, target)
				ParticleManager:SetParticleControl(lightningBolt, 0, Vector(targetPos.x, targetPos.y, targetPos.z + target:GetBoundingMaxs().z))
				ParticleManager:SetParticleControl(lightningBolt, 1, Vector(newTargetPos.x, newTargetPos.y, newTargetPos.z + newTarget:GetBoundingMaxs().z))
				targetNumber = targetNumber + 1
				if targetNumber <= maxTargets then
					Timers:CreateTimer(0.2, function()
						baron_storm_arc(newTarget, caster, ability, damage, targetNumber, maxTargets)
					end)
				end
			end
		end
	end
end

function samurai_helmet_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, target, "modifier_samurai_damage", {})
	target:SetModifierStackCount("modifier_samurai_damage", caster, target:GetLevel())
end

function temporal_warp_boots_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	if not ability.interval then
		ability.interval = 0
		ability.dataTable = {}
	end
	ability.interval = ability.interval + 1
	local timeData = {target:GetMana(), target:GetHealth(), target:GetAbsOrigin(), target:GetAbilityByIndex(DOTA_Q_SLOT):GetCooldownTimeRemaining(), target:GetAbilityByIndex(DOTA_W_SLOT):GetCooldownTimeRemaining(), target:GetAbilityByIndex(DOTA_R_SLOT):GetCooldownTimeRemaining()}
	if #ability.dataTable <= 40 then
		table.insert(ability.dataTable, timeData)
	else
		ability.dataTable[ability.interval] = timeData
	end
	-- ability.mana = target:GetMana()
	-- ability.health = target:GetHealth()
	-- ability.position = target:GetAbsOrigin()
	-- ability.cooldownA = target:GetAbilityByIndex(DOTA_Q_SLOT):GetCooldownTimeRemaining()
	-- ability.cooldownB = target:GetAbilityByIndex(DOTA_W_SLOT):GetCooldownTimeRemaining()
	-- ability.cooldownD = target:GetAbilityByIndex(DOTA_D_SLOT):GetCooldownTimeRemaining()
	if ability.interval == 40 then
		ability.interval = 0
	end
end

function wind_orchid_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local e_4_level = target:GetRuneValue("e", 4)
	if e_4_level > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_wind_orchid_agility_bonus", {})
		target:SetModifierStackCount("modifier_wind_orchid_agility_bonus", caster, e_4_level)
	else
		target:RemoveModifierByName("modifier_wind_orchid_agility_bonus")
	end
end

function aqua_lily_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local r_4_level = target:GetRuneValue("r", 4)
	if r_4_level > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_aqua_lily_intelligence_bonus", {})
		target:SetModifierStackCount("modifier_aqua_lily_intelligence_bonus", caster, r_4_level)
	else
		target:RemoveModifierByName("modifier_aqua_lily_intelligence_bonuss")
	end
end

function fire_blossom_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local w_4_level = target:GetRuneValue("w", 4)
	if w_4_level > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_fire_blossom_strength_bonus", {})
		target:SetModifierStackCount("modifier_fire_blossom_strength_bonus", caster, w_4_level)
	else
		target:RemoveModifierByName("modifier_fire_blossom_strength_bonus")
	end
end

function blue_rain_attack_land(event)
	local attacker = event.attacker
	local ability = event.ability
	local caster = attacker
	local target = event.target

	local proc = Filters:GetProc(caster, BLUE_RAIN_CHANCE)
	if proc then
		local position = target:GetAbsOrigin()
		local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * BLUE_RAIN_DMG_PER_ATT
		local endFV = ((target:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
		local range = 1000
		--print(caster:GetAbsOrigin())
		--print(caster:GetAbsOrigin()+endFV*range)
		local enemies = FindUnitsInLine(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster:GetAbsOrigin() + endFV * range, caster, 240, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
		if #enemies > 0 then
			--print("ENEMIES??")
			for _, enemy in pairs(enemies) do
				if not enemy.dummy then
					Filters:ApplyItemDamage(enemy, caster, damage, DAMAGE_TYPE_PURE, ability, RPC_ELEMENT_WATER, RPC_ELEMENT_ICE)
				end
			end
		end
		local particleName = "particles/econ/items/monkey_king/ti7_weapon/mk_ti7_immortal_strike.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(0, pfx, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(1, pfx, caster:GetAbsOrigin() + endFV * range)
		ParticleManager:SetParticleControl(2, pfx, caster:GetAbsOrigin() + endFV * range)
		Timers:CreateTimer(4, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		EmitSoundOn("RPCItem.BlueRain", target)
	end
end

function shadowflame_fist_think(event)
	local target = event.target
	if target:GetMana() > target:GetMaxMana() * 0.1 then
		target:SetMana(target:GetMaxMana() * 0.1)
	end
end

function flamethrower_init(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	ability.interval = -4
	ability.rising = true
	ability.damage = OverflowProtectedGetAverageTrueAttackDamage(target) * 2.00
	ability.origCaster = target
	flamethrower_thinking(event)
end

function flamethrower_thinking(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local fv = target:GetForwardVector()
	local rotatedFV = WallPhysics:rotateVector(fv, 2 * math.pi * ability.interval / 40)
	if ability.rising then
		ability.interval = ability.interval + 1
		if ability.interval == 4 then
			ability.rising = false
		end
	else
		ability.interval = ability.interval - 1
		if ability.interval == -4 then
			ability.rising = true
		end
	end

	local start_radius = 120
	local end_radius = 200
	local range = 900
	local speed = 1000

	local projectileParticle = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf"

	local info =
	{
		Ability = ability,
		EffectName = projectileParticle,
		vSpawnOrigin = target:GetAbsOrigin() + rotatedFV * 30 + Vector(0, 0, 80),
		fDistance = range,
		fStartRadius = start_radius,
		fEndRadius = end_radius,
		Source = caster,
		StartPosition = "attach_origin",
		bHasFrontalCone = true,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
		vVelocity = rotatedFV * speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)

end

function flamethrower_impact(event)
	local target = event.target
	local ability = event.ability
	Filters:ApplyItemDamage(target, ability.origCaster, ability.damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
	local ulti = ability.origCaster:GetAbilityByIndex(DOTA_R_SLOT)
	local currentCD = ulti:GetCooldownTimeRemaining()
	ulti:EndCooldown()
	ulti:StartCooldown(currentCD - 0.5)
end

function aquasteel_take_damage(event)
	local unit = event.unit
	local attacker = event.attacker
	local caster = event.unit
	local proc_chance = event.proc_chance
	local damage_mult = event.damage_mult
	local armor_mult = event.armor_mult
	local stun_duration = event.stun_duration
	local ability = event.ability
	local proc = Filters:GetProc(caster, proc_chance)
	if unit:GetEntityIndex() == attacker:GetEntityIndex() then
	else
		if proc then
			local dagon_particle = ParticleManager:CreateParticle("particles/econ/events/ti7/dagon_ti7.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControlEnt(dagon_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)
			ParticleManager:SetParticleControlEnt(dagon_particle, 1, attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin(), false)
			local particle_effect_intensity = 700
			ParticleManager:SetParticleControl(dagon_particle, 2, Vector(particle_effect_intensity, particle_effect_intensity, particle_effect_intensity))
			Timers:CreateTimer(2.0, function()
				ParticleManager:DestroyParticle(dagon_particle, false)
				ParticleManager:ReleaseParticleIndex(dagon_particle)
			end)
			local damage = damage_mult * OverflowProtectedGetAverageTrueAttackDamage(caster) + caster:GetPhysicalArmorValue(false) * armor_mult
			EmitSoundOn("RPCItem.Aquasteel", attacker)
			Timers:CreateTimer(0.1, function()
				Filters:ApplyItemDamage(attacker, caster, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_WATER, RPC_ELEMENT_NONE)
				Filters:ApplyStun(caster, stun_duration, attacker)
			end)
		end
	end
end

function demonfire_attack_land(event)
	local caster = event.caster
	local target = event.attacker
	local ability = event.ability

	ability:ApplyDataDrivenModifier(caster, target, "modifier_demonfire_stack", {duration = 6})
	local newStacks = math.min(target:GetModifierStackCount("modifier_demonfire_stack", caster) + 1, 25)
	target:SetModifierStackCount("modifier_demonfire_stack", caster, newStacks)
	ability.stacks = newStacks
end

function demonfire_end(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local enemies = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false)
	local maxTargets = 4
	local currentTargets = 0
	local damage = ability.stacks * OverflowProtectedGetAverageTrueAttackDamage(target)
	if #enemies > 0 then
		EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "RPCItem.Demonfire", target)
		for _, enemy in pairs(enemies) do
			Filters:ApplyItemDamage(enemy, target, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_DEMON, RPC_ELEMENT_FIRE)

			local dagon_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lion/lion_spell_finger_of_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:SetParticleControlEnt(dagon_particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false)
			ParticleManager:SetParticleControlEnt(dagon_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), false)
			local particle_effect_intensity = 700
			ParticleManager:SetParticleControl(dagon_particle, 2, Vector(particle_effect_intensity, particle_effect_intensity, particle_effect_intensity))
			Timers:CreateTimer(2.0, function()
				ParticleManager:DestroyParticle(dagon_particle, false)
				ParticleManager:ReleaseParticleIndex(dagon_particle)
			end)

			currentTargets = currentTargets + 1
			if currentTargets == maxTargets then
				break
			end
		end
	end
end

function lobster_claw_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	ability:ApplyDataDrivenModifier(caster, target, "modifier_chitinous_skin_stack", {})
	local newStacks = math.min(target:GetModifierStackCount("modifier_chitinous_skin_stack", caster) + 1, event.max_stacks)
	target:SetModifierStackCount("modifier_chitinous_skin_stack", caster, newStacks)
end

function shark_helmet_attack_land(event)
	local caster = event.caster
	local attacker = event.attacker
	local ability = event.ability

	if not attacker:HasModifier("modifier_dark_reef_shark_effect") then
		ability:ApplyDataDrivenModifier(caster, attacker, "modifier_dark_reef_shark_stacks", {duration = 20})
	end
	local newStacks = attacker:GetModifierStackCount("modifier_dark_reef_shark_stacks", caster) + 1
	if newStacks >= 7 then
		attacker:RemoveModifierByName("modifier_dark_reef_shark_stacks")
		ability:ApplyDataDrivenModifier(caster, attacker, "modifier_dark_reef_shark_effect", {duration = 1.5})
		CustomAbilities:QuickAttachParticle("particles/roshpit/items/shark_helmet.vpcf", attacker, 1)
		EmitSoundOn("RPCItem.SharkHelmet.Activate", attacker)
	else
		attacker:SetModifierStackCount("modifier_dark_reef_shark_stacks", caster, newStacks)
	end
end

function sunrise_robe_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	local heroStr = target:GetBaseStrength()
	local heroAgi = target:GetBaseAgility()
	local heroInt = target:GetBaseIntellect()

	if heroStr <= heroAgi and heroStr <= heroInt then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_empyreal_str", {})
		target:SetModifierStackCount("modifier_empyreal_str", caster, heroStr * 1.6)
		target:RemoveModifierByName("modifier_empyreal_agi")
		target:RemoveModifierByName("modifier_empyreal_int")
	elseif heroAgi <= heroStr and heroAgi <= heroInt then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_empyreal_agi", {})
		target:SetModifierStackCount("modifier_empyreal_agi", caster, heroAgi * 1.6)
		target:RemoveModifierByName("modifier_empyreal_str")
		target:RemoveModifierByName("modifier_empyreal_int")
	elseif heroInt <= heroStr and heroInt <= heroAgi then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_empyreal_int", {})
		target:SetModifierStackCount("modifier_empyreal_int", caster, heroInt * 1.6)
		target:RemoveModifierByName("modifier_empyreal_str")
		target:RemoveModifierByName("modifier_empyreal_agi")
	end
end

function sea_oracle_attack_land(event)
	local caster = event.caster
	local attacker = event.attacker
	local ability = event.ability
	local target = event.target

	ability:ApplyDataDrivenModifier(caster, target, "modifier_sea_oracle_stacker", {duration = 8})
	local currentMainStacks = target:GetModifierStackCount("modifier_sea_oracle_stacker", caster)
	local newStacks = math.min(target:GetModifierStackCount("modifier_sea_oracle_stacker", caster) + 1, 15)
	target:SetModifierStackCount("modifier_sea_oracle_stacker", caster, newStacks)

	ability:ApplyDataDrivenModifier(caster, target, "modifier_sea_oracle_health_loss", {duration = 8})
	ability:ApplyDataDrivenModifier(caster, target, "modifier_sea_oracle_armor_loss", {duration = 8})
	if currentMainStacks < 15 then
		local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/seafortress/sea_oracle_impact_d.vpcf", target, 2)
		ParticleManager:SetParticleControl(pfx, 1, target:GetAbsOrigin())
		local attackerReduce = target:GetAttackDamage() * 0.05
		local currentStacks = target:GetModifierStackCount("modifier_sea_oracle_health_loss", caster)
		local newStacks = currentStacks + attackerReduce
		target:SetModifierStackCount("modifier_sea_oracle_health_loss", caster, newStacks)

		local armorReduce = target:GetPhysicalArmorValue(false) * 0.05
		local currentStacks = target:GetModifierStackCount("modifier_sea_oracle_armor_loss", caster)
		local newStacks = currentStacks + armorReduce
		target:SetModifierStackCount("modifier_sea_oracle_armor_loss", caster, newStacks)

	end
end

function light_seer_channeling(event)
	local caster = event.caster
	local attacker = event.attacker
	local ability = event.ability
	local target = event.target

	local healAmount = target:GetMaxHealth() * 0.2
	Filters:ApplyHeal(target, target, healAmount, true)
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_oracle/flash_healheal.vpcf", target, 1)

	ability:ApplyDataDrivenModifier(caster, target, "modifier_light_seer_shield", {duration = 60})

	local stacks = target:GetModifierStackCount("modifier_light_seer_shield", caster) + 1
	stacks = math.min(stacks, TEMPLAR_LIGHT_SEER_MAX_STACKS)
	target:SetModifierStackCount("modifier_light_seer_shield", caster, stacks)
end

function main_light_seer_think(event)
	local caster = event.caster
	local attacker = event.attacker
	local ability = event.ability
	local target = event.target

	if not target:HasModifier("modifier_templar_channeling") then
		local stacks = target:GetModifierStackCount("modifier_light_seer_shield", caster) - 1
		if stacks > 0 then
			target:SetModifierStackCount("modifier_light_seer_shield", caster, stacks)
		else
			target:RemoveModifierByName("modifier_light_seer_shield")
		end

	end
end

function ahnqhir_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	local index = event.index
	local pointAbility = target:GetAbilityByIndex(index)
	if pointAbility then
		if pointAbility.ahnqhirPoint then
		else
			pointAbility.ahnqhirPoint = pointAbility:GetCastPoint()
			pointAbility:SetOverrideCastPoint(0.05)
		end
	end
end

function ahnqhir_mask_off_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	local index = event.index
	local pointAbility = target:GetAbilityByIndex(index)
	local pointAbility = target:GetAbilityByIndex(index)
	if pointAbility then
		if pointAbility.ahnqhirPoint then
			pointAbility:SetOverrideCastPoint(pointAbility.ahnqhirPoint)
			pointAbility.ahnqhirPoint = nil
		else
		end
	end
end

function direwolf_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	local stacks = Filters:GetPrimaryAttributeMultiple(target, 0.1)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_direwolf_bulwark_effect", {})
	target:SetModifierStackCount("modifier_direwolf_bulwark_effect", caster, math.ceil(stacks))
end

function eyeglass_attack(event)
	local attacker = event.attacker
	local target = event.target
	if target.dummy then
		return false
	end
	local distance = math.min(WallPhysics:GetDistance(attacker:GetAbsOrigin(), target:GetAbsOrigin()), 5000)
	local damage = 0.001 * attacker:GetLevel() * distance ^ 3

	Filters:ApplyItemDamage(target, attacker, damage, DAMAGE_TYPE_PHYSICAL, event.ability, RPC_ELEMENT_HOLY, RPC_ELEMENT_COSMOS)
	CustomAbilities:QuickAttachParticle("particles/roshpit/items/epsilon_impact.vpcf", target, 0.5)
end

function eyeglass_equip(event)
	local target = event.target
	local ability = event.ability
	target:AddNewModifier(target, ability, "modifier_epsilon", {})
	if event.target:GetUnitName() == "npc_dota_hero_drow_ranger" then
		event.target:SetRangedProjectileName("particles/units/heroes/hero_drow/astral_c_a_particle_attackfrost_arrow.vpcf")
	end
end

function monkey_paw_unit_die(event)
	local unit = event.unit
	local caster = event.caster
	local hero = caster.hero
	local victim = unit
	if unit.paragon then
		local gold = hero:GetGold();
		local bossLocation = victim:GetAbsOrigin()
		local divisor = 3500 * GameState:GetDifficultyFactor()
		local itemsCount = math.floor(gold / divisor)
		if itemsCount >= 1 then
			hero:SpendGold(gold / 2, DOTA_ModifyGold_PurchaseItem)
			for i = 1, itemsCount, 1 do
				Timers:CreateTimer((i - 1) * 0.3, function()
					RPCItems.LevelRoll = 30 * GameState:GetDifficultyFactor()
					EmitSoundOnLocationWithCaster(bossLocation, "RPC.MonkeyPaw.Bounty", caster)
					CustomAbilities:QuickParticleAtPoint("particles/roshpit/items/monkey_paw_bounty.vpcf", GetGroundPosition(bossLocation, Events.GameMaster), 1.2)
					CustomAbilities:QuickAttachParticle("particles/roshpit/items/monkey_paw_bounty.vpcf", hero, 0.5)
					local luck = RandomInt(200, 500)
					if luck >= 200 and luck < 265 then
						RPCItems:RollHood(0, bossLocation, "immortal", false, 0, nil, 0)
					elseif luck >= 265 and luck < 330 then
						RPCItems:RollHand(0, bossLocation, "immortal", false, 0, nil, 0)
					elseif luck >= 330 and luck < 395 then
						RPCItems:RollFoot(0, bossLocation, "immortal", false, 0, nil, 0)
					elseif luck >= 395 and luck < 460 then
						RPCItems:RollBody(0, bossLocation, "immortal", false, 0, nil, 0)
					elseif luck <= 500 then
						RPCItems:RollAmulet(0, bossLocation, "immortal", false, 0, nil, 0)
					end
					RPCItems.LevelRoll = nil
				end)
			end
		end
	end
end

function arcane_charm_start(event)
	local heroEntity = event.target
	heroEntity:RemoveModifierByName("modifier_hero_thinker")
end

function arcane_charm_end(event)
	local heroEntity = event.target
	Events:GetGameMasterAbility():ApplyDataDrivenModifier(Events.GameMaster, heroEntity, "modifier_hero_thinker", {})
end

function skull_ring_init(event)
	--print("[skull_ring_init]")
	local heroEntity = event.target
	local item = event.ability
	local caster = event.caster
	local propertyTable = CustomNetTables:GetTableValue("item_basics", tostring(item:GetEntityIndex()))
	local tooltipGlyph = propertyTable.property1tooltip
	local glyphName = string.gsub(tooltipGlyph, "#DOTA_Tooltip_ability_item_rpc_", "")
	local glyphNameWithItem = string.gsub(tooltipGlyph, "#DOTA_Tooltip_ability_", "")
	--print("skull_ring_init:"..glyphNameWithItem)
	caster.skullGlyph = Glyphs:RollGlyphAll(glyphNameWithItem, Vector(0, 0), 0)
	UTIL_Remove(caster.skullGlyph:GetContainer())
	local modifierName = "modifier_"..glyphName
	caster.skyllGlyphModifier = modifierName
	caster.skullGlyph:ApplyDataDrivenModifier(caster, heroEntity, modifierName, {})
end

function skull_ring_end(event)
	local heroEntity = event.target
	local item = event.ability
	local caster = event.caster
	heroEntity:RemoveModifierByName(caster.skyllGlyphModifier)
	UTIL_Remove(caster.skullGlyph)
end

function init_blacksmith_tablet(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	RPCItems:RecalculateStatsBasic(target)
end

function end_blacksmith_tablet(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local playerID = target:GetPlayerOwnerID()
	Timers:CreateTimer(0.1, function()
		local itemEntity = CustomNetTables:GetTableValue("equipment", tostring(playerID) .. "-"..tostring(1))
		if itemEntity then
			local item = EntIndexToHScript(itemEntity.itemIndex)
			if IsValidEntity(item) then
				RPCItems:EquipItem(1, hero, hero.InventoryUnit, item)
			end
		end
	end)
end

function frostmaw_kill(event)
	local unit = event.unit
	local caster = event.attacker
	local ability = event.ability
	if not unit.dominion then
		return
	end
	if not ability.frostmaw_minion_table then
		ability.frostmaw_minion_table = {}
	end
	local max_minions = 1
	if #ability.frostmaw_minion_table < max_minions then
		local fv = unit:GetForwardVector()
		local summonPosition = unit:GetAbsOrigin()
		unit:SetAbsOrigin(summonPosition - Vector(0, 0, 800))
		local summon = CreateUnitByName(unit:GetUnitName(), summonPosition, false, nil, nil, caster:GetTeamNumber())
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_savage_roar.vpcf", summon, 3)
		ability:ApplyDataDrivenModifier(caster, summon, "modifier_frostmaw_dominated_unit", {})
		summon:SetAcquisitionRange(1600)
		summon:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
		summon:SetForwardVector(fv)
		local hp = unit:GetMaxHealth()
		local armor = unit:GetPhysicalArmorBaseValue()
		local movespeed = unit:GetBaseMoveSpeed()
		local attackDamage = unit:GetAttackDamage()
		summon:SetMaxHealth(hp)
		summon:SetHealth(hp)
		summon:SetBaseMaxHealth(hp)

		summon:SetPhysicalArmorBaseValue(armor)
		summon:SetBaseMoveSpeed(movespeed)
		summon:SetBaseDamageMin(attackDamage)
		summon:SetBaseDamageMax(attackDamage)
		summon.attackDamage = attackDamage
		summon.armor = armor
		summon.aggro = true
		summon.frostmaw = true
		summon:SetDayTimeVisionRange(90)
		summon:SetNightTimeVisionRange(90)
		summon.hero = caster

		table.insert(ability.frostmaw_minion_table, summon)

		EmitSoundOn("RPCItem.FrostmawDominate", summon)

		local newTable = {}
		for i = 1, #ability.frostmaw_minion_table, 1 do
			if IsValidEntity(ability.frostmaw_minion_table[i]) then
				if ability.frostmaw_minion_table[i]:IsAlive() then
					table.insert(newTable, ability.frostmaw_minion_table[i])
				end
			end
		end
		ability.frostmaw_minion_table = newTable
		summon:SetAcquisitionRange(1200)
		summon.targetRadius = 1000
		summon.minRadius = 0
		summon.targetAbilityCD = 2
		summon.targetFindOrder = FIND_ANY_ORDER
		summon.autoAbilityCD = 2
		summon.owner = caster:GetPlayerOwnerID()
		if summon.aggroSound then
			EmitSoundOn(summon.aggroSound, summon)
		end
		summon.stance = "aggressive"
		summon:AddAbility("ekkan_creep_aggressive"):SetLevel(1)
		summon:SetOwner(caster)
		for i = 0, 6, 1 do
			local ability = summon:GetAbilityByIndex(i)
			if ability then
				ability:SetLevel(GameState:GetDifficultyFactor())
			end
		end
	end
	caster.frostmaw_minion_table = ability.frostmaw_minion_table
end

function frostmaw_unequip(event)
	local ability = event.ability
	local caster = event.target
	if caster.frostmaw_minion_table then
		for i = 1, #caster.frostmaw_minion_table, 1 do
			if IsValidEntity(caster.frostmaw_minion_table[i]) then
				caster.frostmaw_minion_table[i]:SetHealth(1)
				caster.frostmaw_minion_table[i]:ForceKill(false)
			end
		end
	end
end

function frostmaw_dominated_think(event)
	local caster = event.caster
	local target = event.target
	if caster:GetEntityIndex() == target:GetEntityIndex() then
		caster = target.hero
	end
	if target:IsAlive() then
		local leashDistance = 2000
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), target:GetAbsOrigin())
		if distance > leashDistance then
			FindClearSpaceForUnit(target, caster:GetAbsOrigin() + RandomVector(180), false)
			Timers:CreateTimer(0.1, function()
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_savage_roar.vpcf", target, 3)
			end)
			return false
		end
		if target.stance == "passive" then
			return false
		elseif target.stance == "follow" then
			target:MoveToPosition(caster:GetAbsOrigin() + RandomVector(180))
			return false
		else
			if distance > 800 then
				local enemies = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
				if #enemies == 0 then
					target:MoveToPosition(caster:GetAbsOrigin() + RandomVector(180))
				end
			end
		end
	end
end

function frostmaw_dominated_die(event)
	local unit = event.unit
	local caster = event.caster
	local ability = event.ability
	local newTable = {}
	if IsValidEntity(ability) then
		for i = 1, #ability.frostmaw_minion_table, 1 do
			if IsValidEntity(ability.frostmaw_minion_table[i]) then
				if ability.frostmaw_minion_table[i]:IsAlive() then
					table.insert(newTable, ability.frostmaw_minion_table[i])
				end
			end
		end
		ability.frostmaw_minion_table = newTable
	end
end

function frozen_heart_think(event)
	local unit = event.unit
	local caster = event.caster
	local ability = event.ability
	local hero = event.target
	-- local maxHealth = math.floor(hero:GetMaxHealth() + hero:GetModifierStackCount("modifier_frozen_heart_negative_health", caster))
	----print("MAXHEALTH----")
	----print(maxHealth)
	----print("-----")
	-- if hero:GetMaxHealth() > 101 or hero:GetMaxHealth() < 99 then
	-- local stacksToBeApplied = hero:GetMaxHealth() - 99
	-- if not hero:HasModifier("modifier_frozen_heart_negative_health") then
	-- ability:ApplyDataDrivenModifier(caster, hero, "modifier_frozen_heart_negative_health", {})
	-- end
	-- if hero:GetMaxHealth() - stacksToBeApplied > 10 then
	-- Timers:CreateTimer(0.03, function()
	-- hero:SetModifierStackCount("modifier_frozen_heart_negative_health", caster, stacksToBeApplied)
	-- end)
	-- end
	-- end
	-- if not ability.interval then
	-- ability.interval = 0
	-- end
	-- if ability.interval == 75 then
	-- ability:ApplyDataDrivenModifier(caster, hero, "modifier_frozen_heart_regen", {})
	-- else
	-- ability.interval = ability.interval + 1
	-- end
	ability:ApplyDataDrivenModifier(caster, hero, "modifier_frozen_heart_negative_health", {})
	hero:SetModifierStackCount("modifier_frozen_heart_negative_health", caster, 900)
	if not hero:HasModifier("modifier_frozen_heart_regen") then
		if not hero:HasModifier("modifier_frozen_heart_regen_prep") then
			ability:ApplyDataDrivenModifier(caster, hero, "modifier_frozen_heart_regen_prep", {duration = 2.5})
		end
	end
	-- if hero:GetHealth() <= 0 then
	-- caster:SetHealth(10)
	-- hero:RemoveModifierByName("modifier_frozen_heart_negative_health")
	-- hero:ForceKill(false)
	-- end
end

function frozen_heart_die(event)
	local hero = event.unit
	local caster = event.caster
	local ability = event.ability
	AddFOWViewer(hero:GetTeamNumber(), hero:GetAbsOrigin(), 500, 6, false)
	ability:ApplyDataDrivenModifier(caster, hero, "modifier_frozen_heart_dead", {})
	Timers:CreateTimer(3, function()
		hero:RemoveModifierByName("modifier_frozen_heart_dead")
		local position = hero:GetAbsOrigin()
		for i = 0, 3, 1 do
			Timers:CreateTimer(0.1 * i, function()
				local particleName = "particles/roshpit/winterblight/snow_impact.vpcf"
				local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, nil)
				ParticleManager:SetParticleControl(particle1, 0, caster:GetAbsOrigin())
				Timers:CreateTimer(1, function()
					ParticleManager:DestroyParticle(particle1, false)
				end)
			end)
		end
		EmitSoundOn("RPCItems.FrozenHeart.Shatter", hero)
		local particleName = "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf"
		local radius = 500
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(particle1, 0, position)
		ParticleManager:SetParticleControl(particle1, 1, Vector(radius, 1, 800))
		ParticleManager:SetParticleControl(particle1, 3, Vector(radius, radius, radius))
		Timers:CreateTimer(3, function()
			ParticleManager:DestroyParticle(particle1, false)
		end)
		hero:SetAbsOrigin(hero:GetAbsOrigin() - Vector(0, 0, 500))
	end)
end

function frozen_heart_regen_thinker(event)
	local caster = event.caster
	local hero = event.target
	local ability = event.ability
	local newHealth = math.min(hero:GetHealth() + 1, 100)
	hero:SetHealth(newHealth)
end

function frozen_heart_take_damage(event)
	local unit = event.unit
	local ability = event.ability
	local caster = event.caster
	ability.interval = 0
	--print("take damage")
	ability:ApplyDataDrivenModifier(caster, hero, "modifier_frozen_heart_regen_prep", {duration = 2.5})
	local modifier = unit:FindModifierByName("modifier_frozen_heart_regen_prep")
	if modifier then
		modifier:SetDuration(2.5, true)
	end
	Timers:CreateTimer(0.03, function()
		ability.interval = 0
		unit:RemoveModifierByName("modifier_frozen_heart_regen")
	end)
end

function energy_whip_glove_attack_land(event)
	local attacker = event.attacker
	local target = event.target
	local ability = attacker:GetAbilityByIndex(DOTA_W_SLOT)
	if attacker.Attacking_a_Cup then
		return
	end
	if ability:GetCooldownTimeRemaining() <= 0 then
		--print("B2")
		local manaRestore = ability:GetManaCost(ability:GetLevel())
		attacker:GiveMana(manaRestore)
		local castPointSave = ability:GetCastPoint()
		ability.castPointSave = attacker.castPointW
		ability:SetOverrideCastPoint(0)
		local behavior = ability:GetBehavior()
		--print(bit.band(behavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET))
		if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET) == DOTA_ABILITY_BEHAVIOR_NO_TARGET then
			local order =
			{
				UnitIndex = attacker:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = ability:entindex(),
				Queue = true
			}
			attacker:Stop()
			ExecuteOrderFromTable(order)
			--print("IN HERE")
		elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
			local order = {
				UnitIndex = attacker:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				TargetIndex = target:entindex(),
				AbilityIndex = ability:entindex(),
				Queue = true
			}
			attacker:Stop()
			--print("HERE?")
			ExecuteOrderFromTable(order)
		elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_POINT) == DOTA_ABILITY_BEHAVIOR_POINT then
			local order =
			{
				UnitIndex = attacker:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = ability:entindex(),
				Position = target:GetAbsOrigin(),
				Queue = true
			}
			attacker:Stop()
			ExecuteOrderFromTable(order)
		end
		-- ability:StartCooldown(0)
	end
end

function boreal_granite_vest_take_damage(event)
	local target = event.attacker
	local hero = event.unit
	if hero:GetEntityIndex() == target:GetEntityIndex() then
		return false
	end
	local ability = hero:GetAbilityByIndex(DOTA_Q_SLOT)
	local proc = Filters:GetProc(hero, 10)
	local cd = ability:GetCooldownTimeRemaining()
	local distance = WallPhysics:GetDistance(hero:GetAbsOrigin(), target:GetAbsOrigin())
	local behavior = ability:GetBehavior()
	if proc then
		if distance <= ability:GetCastRange() or (bit.band(behavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET) == DOTA_ABILITY_BEHAVIOR_NO_TARGET and distance < 2000) then
			ability:EndCooldown()
			local manaRestore = ability:GetManaCost(ability:GetLevel())
			if manaRestore > 0 then
				attacker:GiveMana(manaRestore)
			end
			local castPointSave = hero.castPointQ
			ability.boreal_cast_point = castPointSave
			ability:SetOverrideCastPoint(0)
			if ability:GetAbilityName() == "warlord_cataclysm_shaker" then
				ability:OnSpellStart()
			elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET) == DOTA_ABILITY_BEHAVIOR_NO_TARGET then
				local order =
				{
					UnitIndex = hero:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = ability:entindex(),
					Queue = true
				}
				hero:Stop()
				ExecuteOrderFromTable(order)
			elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_POINT) == DOTA_ABILITY_BEHAVIOR_POINT then
				local order =
				{
					UnitIndex = hero:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = ability:entindex(),
					Position = target:GetAbsOrigin(),
					Queue = true
				}
				hero:Stop()
				ExecuteOrderFromTable(order)
			elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
				local order = {
					UnitIndex = hero:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					TargetIndex = target:entindex(),
					AbilityIndex = ability:entindex(),
					Queue = true
				}
				hero:Stop()
				ExecuteOrderFromTable(order)
			end
		end
	end
end

function captains_vest_think(event)
	local hero = event.target
	local caster = event.caster
	local ability = event.ability
	local q_1_level = hero:GetRuneValue("q", 1)
	local q_2_level = hero:GetRuneValue("q", 2)
	local q_3_level = hero:GetRuneValue("q", 3)
	local q_4_level = hero:GetRuneValue("q", 4)
	local w_1_level = hero:GetRuneValue("w", 1)
	local w_2_level = hero:GetRuneValue("w", 2)
	local w_3_level = hero:GetRuneValue("w", 3)
	local w_4_level = hero:GetRuneValue("w", 4)
	local e_1_level = hero:GetRuneValue("e", 1)
	local e_2_level = hero:GetRuneValue("e", 2)
	local e_3_level = hero:GetRuneValue("e", 3)
	local e_4_level = hero:GetRuneValue("e", 4)
	local r_1_level = hero:GetRuneValue("r", 1)
	local r_2_level = hero:GetRuneValue("r", 2)
	local r_3_level = hero:GetRuneValue("r", 3)
	local r_4_level = hero:GetRuneValue("r", 4)
	local strength = q_1_level * 3 + q_2_level * 6 + q_3_level * 15 + q_4_level * 30 + r_1_level * 1 + r_2_level * 2 + r_3_level * 5 + r_4_level * 10
	local agility = e_1_level * 3 + e_2_level * 6 + e_3_level * 15 + e_4_level * 30 + r_1_level * 1 + r_2_level * 2 + r_3_level * 5 + r_4_level * 10
	local intelligence = w_1_level * 3 + w_2_level * 6 + w_3_level * 15 + w_4_level * 30 + r_1_level * 1 + r_2_level * 2 + r_3_level * 5 + r_4_level * 10
	if strength > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_captains_vest_str", {})
		hero:SetModifierStackCount("modifier_captains_vest_str", caster, strength)
	else
		hero:RemoveModifierByName("modifier_captains_vest_str")
	end
	if agility > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_captains_vest_agi", {})
		hero:SetModifierStackCount("modifier_captains_vest_agi", caster, agility)
	else
		hero:RemoveModifierByName("modifier_captains_vest_agi")
	end
	if intelligence > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_captains_vest_int", {})
		hero:SetModifierStackCount("modifier_captains_vest_int", caster, intelligence)
	else
		hero:RemoveModifierByName("modifier_captains_vest_int")
	end
end

function gravelfoot_think(event)
	local hero = event.target
	local caster = event.caster
	local ability = event.ability
	-- "RPCItems.Gravelfoot.Dispel"
	-- "RPCItems.Gravelfoot.Activate"
	local caster = event.target
	local procced = false
	local modifiers = hero:FindAllModifiers()
	for j = 1, #modifiers, 1 do
		local modifier = modifiers[j]
		local modifierMaker = modifier:GetCaster()
		if WallPhysics:DoesTableHaveValue(Filters:GetUnpurgableDebuffNames(), modifier:GetName()) then
		else
			if modifierMaker and modifierMaker.regularEnemy then
				hero:RemoveModifierByName(modifier:GetName())
				procced = true
				break
			elseif not modifierMaker then
				hero:RemoveModifierByName(modifier:GetName())
				procced = true
				break
			end
		end
	end

	if procced then
		EmitSoundOn("RPCItems.Gravelfoot.Dispel", caster)
		local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/winterblight/gravelfoot_dispel.vpcf", caster, 1.2)
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_gravelfoot_buff", {duration = event.duration})
	end
end

function gravelfoot_start(event)
	local hero = event.target
	local caster = event.caster
	local ability = event.ability
	EmitSoundOnLocationWithCaster(hero:GetAbsOrigin(), "RPCItems.Gravelfoot.Activate", caster)
	local earthParticle = "particles/units/heroes/hero_earth_spirit/espirit_bouldersmash_caster.vpcf"
	local pfx = ParticleManager:CreateParticle(earthParticle, PATTACH_CUSTOMORIGIN, hero)
	ParticleManager:SetParticleControl(pfx, 0, hero:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, hero:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 2, hero:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 3, hero:GetAbsOrigin())
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
end

function ice_floe_think(event)
	local caster = event.caster
	local hero = event.target
	local ability = event.ability
	local targetPoint = hero.ice_floe_table.last_position
	local fv = (targetPoint - hero:GetAbsOrigin()):Normalized()
	hero.ice_floe_table.speed = math.max(hero.ice_floe_table.speed - 0.3, 25)
	local newPosition = hero:GetAbsOrigin() + fv * hero.ice_floe_table.speed
	local obstruction = WallPhysics:FindNearestObstruction(newPosition)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition * Vector(1, 1, 0), hero)
	newPosition = GetGroundPosition(newPosition, hero)
	if blockUnit then
	else
		hero:SetAbsOrigin(newPosition)
	end
	local distance = WallPhysics:GetDistance2d(hero:GetAbsOrigin(), targetPoint)
	if distance < 50 then
		hero:RemoveModifierByName("modifier_ice_floe_sliding")
	end
end

function tattered_novice_stack_increase(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	if target:HasModifier("modifier_tattered_novice_stack") then
		local newStacks = math.min(target:GetModifierStackCount("modifier_tattered_novice_stack", caster) + 1, 2)
		target:SetModifierStackCount("modifier_tattered_novice_stack", caster, newStacks)
	else
		ability:ApplyDataDrivenModifier(caster, target, "modifier_tattered_novice_stack", {})
		target:SetModifierStackCount("modifier_tattered_novice_stack", caster, 1)
	end
end

function buzuki_buff_attack_land(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local hero = caster.hero
	EmitSoundOn("RPCItems.BuzukiFinger.BeamHit", target)
	local damage = OverflowProtectedGetAverageTrueAttackDamage(event.attacker)
	Filters:ApplyItemDamage(target, hero, damage, DAMAGE_TYPE_PURE, ability, RPC_ELEMENT_ICE, RPC_ELEMENT_DEMON)

	local particle1 = ParticleManager:CreateParticle("particles/roshpit/winterblight/blue_finger.vpcf", PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControlEnt(particle1, 0, event.attacker, PATTACH_POINT, "attach_attack1", event.attacker:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle1, 1, target:GetAbsOrigin() + Vector(0, 0, 80))
	Timers:CreateTimer(1, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
end

function swiftspike_think(event)
	local caster = event.caster
	local hero = event.target
	local ability = event.ability
	local movespeed = hero:GetBaseMoveSpeed()
	local movespeedActual = hero:GetMoveSpeedModifier(movespeed, false)
	if not hero:HasModifier("modifier_swiftspike_bad") then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_swiftspike_bad", {})
	end
	hero:SetModifierStackCount("modifier_swiftspike_bad", caster, movespeedActual)
end

function orthok_attack_land(event)
	local attacker = event.attacker
	Filters:OrthokStack(attacker, 1)
end

function orthok_think(event)
	local hero = event.target
	local chains = event.ability
	Filters:RecalculateOrthokStacks(hero, chains)
end

function mugato_attack(event)
	local attacker = event.attacker

	attacker:AddNewModifier(caster, nil, "modifier_silence", {duration = 0.6})
end

function stormcloth_think(event)
	local hero = event.target
	local ability = event.ability
	if not ability.fall_speed then
		ability.sound = false
		ability.fall_speed = 50
		Timers:CreateTimer(0.1, function()
			local pfx = ParticleManager:CreateParticle("particles/roshpit/items/stormcloth_bolt.vpcf", PATTACH_CUSTOMORIGIN, hero)
			ParticleManager:SetParticleControl(pfx, 0, GetGroundPosition(hero:GetAbsOrigin(), hero))
			ParticleManager:SetParticleControl(pfx, 1, Vector(200, 200, 200))
			Timers:CreateTimer(2, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
		end)
	end
	ability.fall_speed = math.min(ability.fall_speed + 0.5, 60)
	hero:SetAbsOrigin(hero:GetAbsOrigin() - Vector(0, 0, ability.fall_speed))
	if not ability.sound then
		if hero:GetAbsOrigin().z < GetGroundHeight(hero:GetAbsOrigin(), hero) + 330 then
			EmitSoundOn("RPCItems.Stormcloth.Impact", hero)
			ability.sound = true
		end
	end
	if hero:GetAbsOrigin().z < GetGroundHeight(hero:GetAbsOrigin(), hero) + ability.fall_speed then
		hero:RemoveModifierByName("modifier_stormcloth_falling")
		StartAnimation(hero, {duration = 1, activity = ACT_DOTA_TELEPORT_END, rate = 1.2})
		Timers:CreateTimer(0.06, function()
			ability.fall_speed = nil
			for i = 1, 6, 1 do
				CustomAbilities:QuickAttachParticle("particles/roshpit/stormbolt_aoe.vpcf", hero, 4)
			end
			FindClearSpaceForUnit(hero, hero:GetAbsOrigin(), false)
			CustomAbilities:QuickParticleAtPoint("particles/roshpit/items/stormcloth_start.vpcf", hero:GetAbsOrigin(), 3)
			local enemies = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin(), nil, STORMCLOTH_STUN_AOE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				for _, enemy in pairs(enemies) do
					Filters:ApplyStun(hero, STORMCLOTH_STUN_DUR, enemy)
				end
			end
		end)
	end
end

function elder_shield_particle_init(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if not target.elderShieldParticle then
		target.elderShieldParticle = ParticleManager:CreateParticle("particles/roshpit/items/elders_shield.vpcf", PATTACH_CUSTOMORIGIN, target)
		ParticleManager:SetParticleControlEnt(target.elderShieldParticle, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(target.elderShieldParticle, 1, Vector(255, 255, 255))
	end
end

function puzzlers_locket_recalculate(event)
	local ability = event.ability
	if not ability.recalculated then
		ability.recalculated = true
		Timers:CreateTimer(5, function()
			local hero = event.target
			RPCItems:RecalculateStatsBasic(hero)
			Timers:CreateTimer(12, function()
				ability.recalculated = false
			end)
		end)
	end
end

function tiamat_claw_initialize(event)
end

function tiamat_claw_initialize(event)
end

function razor_band_take_damage(event)
	local target = event.unit
	local ability = event.ability
	local caster = event.caster
	local attacker = event.attacker
	if target == attacker then
		return false
	end
	if not ability.buff_table then
		ability.buff_table = {}
	end
	local new_buff = GameRules:GetGameTime()
	if #ability.buff_table < 100 then
		table.insert(ability.buff_table, new_buff)
	end
	ability:ApplyDataDrivenModifier(caster, target, "modfier_razor_band_stacks", {duration = RAZOR_BAND_STACK_DURATION})
	local stacks = #ability.buff_table
	target:SetModifierStackCount("modfier_razor_band_stacks", caster, stacks)
	local self_damage = target:GetMaxHealth()*(RAZOR_BAND_MAX_HEALTH_DAMAGE/100)
	ApplyDamage({victim = target, attacker = target, damage = self_damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
end

function razor_band_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster

	local new_buff_table = {}
	for i = 1, #ability.buff_table, 1 do
		if GameRules:GetGameTime() - ability.buff_table[i] > RAZOR_BAND_STACK_DURATION then
		else
			table.insert(new_buff_table, ability.buff_table[i])
		end
	end
	ability.buff_table = new_buff_table

	local stacks = #ability.buff_table
	target:SetModifierStackCount("modfier_razor_band_stacks", caster, stacks)

	razor_band_update_pfx(ability, target)
	if not ability.particles then
		ability.particles = 0
	end
	if #ability.buff_table > 0 then
		local stacks = #ability.buff_table
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 340, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				local damage = OverflowProtectedGetAverageTrueAttackDamage(target)*(stacks*RAZOR_BAND_DAMAGE_PCT_OF_ATTACK_POWER/100)
				Filters:ApplyItemDamage(enemy, target, damage, DAMAGE_TYPE_PHYSICAL, ability, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NORMAL)
				if ability.particles < 10 then
					ability.particles = ability.particles + 1
					local particleName = "particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf"
					local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_CUSTOMORIGIN, nil)
					local attach_unit_1 = target
					ParticleManager:SetParticleControl(pfx, 0, attach_unit_1:GetAbsOrigin() + Vector(0, 0, attach_unit_1:GetBoundingMaxs().z + 80))
					ParticleManager:SetParticleControl(pfx, 1, enemy:GetAbsOrigin() + Vector(0, 0, enemy:GetBoundingMaxs().z + 100))
					Timers:CreateTimer(0.3, function()
						ParticleManager:DestroyParticle(pfx, false)
					end)
				end
			end
			if #enemies > 5 then
				EmitSoundOn("Items.RazorBandHit", enemies[1])
				EmitSoundOn("Items.RazorBandHit", enemies[2])
				EmitSoundOn("Items.RazorBandHit", enemies[3])
			elseif #enemies > 3 then
				EmitSoundOn("Items.RazorBandHit", enemies[1])
				EmitSoundOn("Items.RazorBandHit", enemies[2])
			else
				EmitSoundOn("Items.RazorBandHit", enemies[1])
			end
		end
	end
	ability.particles = math.max(ability.particles - 1, 0)
end

function razor_band_update_pfx(ability, hero)
	if not ability.razor_pfx and #ability.buff_table > 0 then
		ability.razor_pfx = ParticleManager:CreateParticle("particles/roshpit/items/galvanized_razor_band.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
		ParticleManager:SetParticleControlEnt(ability.razor_pfx, 0, hero, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)
	end
	if #ability.buff_table == 0 then
		if ability.razor_pfx then
			ParticleManager:DestroyParticle(ability.razor_pfx, false)
			ParticleManager:ReleaseParticleIndex(ability.razor_pfx)
			ability.razor_pfx = nil
		end
	end
	if ability.razor_pfx then
		local stacks = #ability.buff_table
		ParticleManager:SetParticleControl(ability.razor_pfx, 1, Vector(stacks/100, stacks/100, stacks/100))
		ParticleManager:SetParticleControl(ability.razor_pfx, 9, Vector(stacks/100, stacks/100, stacks/100))
	end
end

function razor_band_start(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if not ability.buff_table then
		ability.buff_table = {}
	end
	razor_band_update_pfx(ability, target)
end

function razor_band_end(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	ability.buff_table = {}
	EmitSoundOn("Items.RazorBandEnd", target)
	target:RemoveModifierByName("modfier_razor_band_stacks")
	razor_band_update_pfx(ability, target)
end

function goldbreaker_attack_land(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	local attacker = event.attacker
	Filters:MagicImmuneBreak(attacker, target)
	ability:ApplyDataDrivenModifier(attacker, target, "modifier_goldbreaker_effect", {duration = GOLDBREAKER_DEBUFF_DURATION})
end

function knight_hawk_think(event)
	local ability = event.ability
	local caster = event.caster
	local hero = event.target
	local movespeed = hero:GetBaseMoveSpeed()
	local movespeedModifier = hero:GetMoveSpeedModifier(movespeed, false)
	if movespeedModifier <= 300 then
		event.ability:ApplyDataDrivenModifier(event.caster, hero, "modifier_knight_hawk_helm_speed", {duration = KNIGHT_HAWK_MS_BUFF_DURATION})
	end	
end

function knight_hawk_bonus_speed_init(event)
	local target = event.target
	local pfx = CustomAbilities:QuickAttachParticle("particles/econ/items/rubick/rubick_arcana/rbck_arc_skywrath_mage_mystic_flare_ambient_hit.vpcf", target, 3)
	ParticleManager:SetParticleControl(pfx, 1, Vector(140, 140, 140))
end

function knight_hawk_base_init(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	-- target:AddNewModifier( caster, ability, "modifier_knight_hawk_lua", {} )
end

function knight_hawk_base_end(event)
	local target = event.target
	target:RemoveModifierByName("modifier_knight_hawk_lua")
end

function erudite_teacher_start(event)
	local ability = event.ability
	local caster = event.caster
	local hero = event.target
	if not ability.rubick_apprentice then
		local spawnPos = hero:GetAbsOrigin() + RandomVector(160)
		ability.rubick_apprentice = CreateUnitByName("rubick_apprentice", spawnPos, true, nil, nil, hero:GetTeamNumber())
		ability.rubick_apprentice.summoner = hero
		ability.rubick_apprentice:SetOwner(hero)
		ability.rubick_apprentice:SetControllableByPlayer(hero:GetPlayerID(), true)
	    ability.rubick_apprentice.hero = hero

		local apprentice_hp = Filters:AdjustItemDamage(hero, hero:GetMaxHealth()*ERUDITE_TEACHER_HEALTH_MULT, nil)
		local attack_damage = OverflowProtectedGetAverageTrueAttackDamage(hero)
		local apprentice_damage = Filters:AdjustItemDamage(hero, attack_damage*ERUDITE_TEACHER_ATTACK_MULT, nil)
		local apprentice_armor = Filters:AdjustItemDamage(hero, hero:GetPhysicalArmorValue(false)*ERUDITE_TEACHER_ARMOR_MULT, nil)
		ability.rubick_apprentice:SetMaxHealth(apprentice_hp)
		ability.rubick_apprentice:SetBaseMaxHealth(apprentice_hp)
		ability.rubick_apprentice:SetHealth(apprentice_hp)
		ability.rubick_apprentice.robes = ability
		ability.rubick_apprentice:SetPhysicalArmorBaseValue(apprentice_armor)
		Filters:SetAttackDamage(ability.rubick_apprentice, apprentice_damage)

		ability:ApplyDataDrivenModifier(caster, ability.rubick_apprentice, "modifier_apprentice_ai", {})
		local pfx = CustomAbilities:QuickAttachParticle("particles/econ/items/rubick/rubick_force_ambient/rubick_telekinesis_force.vpcf", ability.rubick_apprentice, 3)
		ParticleManager:SetParticleControl(pfx, 1, ability.rubick_apprentice:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 2, Vector(3,3,3))
		ParticleManager:SetParticleControl(pfx, 3, ability.rubick_apprentice:GetAbsOrigin())
		EmitSoundOn("Items.RubickApprentice.Spawn", ability.rubick_apprentice)

		local apprentice = ability.rubick_apprentice

		Timers:CreateTimer(0.5, function()
			EmitSoundOn("Items.RubickApprentice.Spawn.VO", apprentice)
		end)
		Timers:CreateTimer(0.03, function()
			Events:smoothSizeChange(apprentice, 0.1, 1, 33)
			StartAnimation(apprentice, {duration = 1.3, activity = ACT_DOTA_ATTACK, rate = 1.0})
		end)
		if ability.apprentice_abilities_table then
			Timers:CreateTimer(0.03, function()
				DeepPrintTable(ability.apprentice_abilities_table)
				for i = 1, #ability.apprentice_abilities_table, 1 do
					local ability_check_name = ability.apprentice_abilities_table[i]
					local steal_index = i - 1
					if not string.match(ability_check_name, "apprentice_spell_steal_") then
						CustomAbilities:AddAndOrSwapSkill(apprentice, "apprentice_spell_steal_"..i, ability_check_name, steal_index)
						local new_ability = apprentice:FindAbilityByName(ability_check_name)
						new_ability:SetLevel(GameState:GetDifficultyFactor())
					end
				end
			end)
		end
		apprentice:FindAbilityByName("hero_summon_ai"):ToggleAbility()
	end
end

function erudite_teacher_end(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	if ability.rubick_apprentice and IsValidEntity(ability.rubick_apprentice) then
		ability.rubick_apprentice:ForceKill(false)
		local rubick = ability.rubick_apprentice
		ability.rubick_apprentice = false
		Timers:CreateTimer(5, function()
			if IsValidEntity(rubick) then
				UTIL_Remove(rubick)
			end
		end)
	end
end

function apprentice_spell_steal_phase(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	EmitSoundOn("Items.RubickApprentice.Spellsteal.Phase", caster)
	local pfx = CustomAbilities:QuickAttachParticle("particles/econ/items/rubick/rubick_force_ambient/rubick_telekinesis_force.vpcf", caster, 1)
	ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 2, Vector(3,3,3))
	ParticleManager:SetParticleControl(pfx, 3, caster:GetAbsOrigin())
	CustomAbilities:QuickAttachParticle("particles/econ/items/rubick/rubick_force_ambient/rubick_telekinesis_land_force.vpcf", caster, 3)
end

function apprentice_spell_steal_cast(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	local index = event.index
	local steal_index = index - 1
	local success = true
	if not target.dominion then
		Notifications:Top(caster:GetPlayerOwnerID(), {text = "notification_no_dominion", duration = 5, style = {color = "#FF1111"}, continue = true})
		success = false
	end
	local abilitiesTable = {}
	--print(target:GetAbilityCount())
	for i = 0, 12, 1 do
		local abilityCheck = target:GetAbilityByIndex(i)
		if abilityCheck then
			if abilityCheck:IsHidden() then
			else
				table.insert(abilitiesTable, abilityCheck)
			end
		end
	end
	local new_ability = nil
	local new_ability_name = nil
	if #abilitiesTable > 0 then
		new_ability = abilitiesTable[RandomInt(1, #abilitiesTable)]
		new_ability_name = new_ability:GetAbilityName()
		if caster:HasAbility(new_ability_name) then
			success = false
		end
	else
		success = false
	end
	if success then
		CustomAbilities:AddAndOrSwapSkill(caster, ability:GetAbilityName(), new_ability_name, steal_index)
		local new_ability = caster:FindAbilityByName(new_ability_name)
		new_ability:SetLevel(GameState:GetDifficultyFactor())
		local pfx = CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_rubick/rubick_spell_steal.vpcf", target, 3)
		ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin()+Vector(0,0,60))
		EmitSoundOn("Items.RubickApprentice.Spellsteal.Success", caster)
		local apprentice_abilities_table = {}
		for i = 0, 2, 1 do
			local ability_check = caster:GetAbilityByIndex(i)
			local ability_name = ability_check:GetAbilityName()
			table.insert(apprentice_abilities_table, ability_name)
		end
		local robe = caster.summoner.body
		robe.apprentice_abilities_table = apprentice_abilities_table
	else
		CustomAbilities:QuickParticleAtPoint("particles/roshpit/axe/red_general_ulti_cast_assassin_trap_explode_beam.vpcf", caster:GetAbsOrigin(), 1.5)
		EmitSoundOn("Items.RubickApprentice.Spellsteal.Fail", caster)
	end
end

function rubick_apprentice_reset_phase(event)
	local caster = event.caster
	CustomAbilities:QuickParticleAtPoint("particles/roshpit/axe/red_general_ulti_cast_assassin_trap_explode_beam.vpcf", caster:GetAbsOrigin(), 1.5)
	EmitSoundOn("Items.RubickApprentice.Reset.VO", caster)
end


function rubick_apprentice_reset(event)
	local caster = event.caster

	local modifiers = caster:FindAllModifiers()
	for i = 0, 2, 1 do
		for j = 1, #modifiers, 1 do
			local modifier = modifiers[j]
			if modifier:GetRemainingTime() < 5 then
				if modifier:GetAbility() == caster:GetAbilityByIndex(i) then
					caster:RemoveModifierByName(modifier:GetName())
				end
			end
		end
	end


	for i = 0, 2, 1 do
		local stolen_ability = caster:GetAbilityByIndex(i)
		local spell_steal_index = i + 1
		local stolen_ability_name = stolen_ability:GetAbilityName()
		print(stolen_ability_name)
		if not string.match(stolen_ability_name, "apprentice_spell_steal_") then
			CustomAbilities:AddAndOrSwapSkill(caster, stolen_ability:GetAbilityName(), "apprentice_spell_steal_"..spell_steal_index, i)
			if IsValidEntity(stolen_ability) then
				UTIL_Remove(stolen_ability)
			end
		end
	end
	CustomAbilities:QuickParticleAtPoint("particles/roshpit/axe/red_general_ulti_cast_assassin_trap_explode_beam.vpcf", caster:GetAbsOrigin(), 1.5)
	EmitSoundOn("Items.RubickApprentice.Die.VO", caster)
	EmitSoundOn("Items.RubickApprentice.Spellsteal.Reset", caster)
	CustomAbilities:QuickAttachParticle("particles/econ/items/rubick/rubick_force_ambient/rubick_telekinesis_land_force.vpcf", caster, 3)
	StartAnimation(caster, {duration = 1.3, activity = ACT_DOTA_ATTACK, rate = 1.3})
end

function dead_apprentice(event)
	local apprentice = event.unit
	local hero = apprentice.hero
	local ability = event.ability
	local apprentice_abilities_table = {}
	for i = 0, 2, 1 do
		local ability_check = apprentice:GetAbilityByIndex(i)
		local ability_name = ability_check:GetAbilityName()
		table.insert(apprentice_abilities_table, ability_name)
	end
	CustomAbilities:QuickParticleAtPoint("particles/econ/items/rubick/rubick_force_ambient/rubick_telekinesis_land_force.vpcf", apprentice:GetAbsOrigin(), 3)
	EmitSoundOn("Items.RubickApprentice.Die.VO", apprentice)
	ability.rubick_apprentice = nil
	ability.apprentice_abilities_table = apprentice_abilities_table
	ability.apprentice_death_time = GameRules:GetGameTime()
	-- Timers:CreateTimer(10, function()
	-- 	if hero:HasModifier("modifier_erudite_teacher") then
	-- 		print("IN TIMER :)")
	-- 		if IsValidEntity(ability) then
	-- 			print("SUMMON ANOTHER")
	-- 			local eventTable = {}
	-- 			eventTable.ability = ability
	-- 			eventTable.caster = hero.InventoryUnit
	-- 			eventTable.target = hero
	-- 			eventTable.abilities_table = apprentice_abilities_table
	-- 			erudite_teacher_start(eventTable)

	-- 		end
	-- 	end
	-- end)
end

function erudite_teacher_robes_think(event)
	local ability = event.ability
	local caster = event.caster
	local hero = event.target
	if ability.apprentice_abilities_table and ability.apprentice_death_time then
		if GameRules:GetGameTime() - ability.apprentice_death_time > 10 then
			local abilities_table = ability.apprentice_abilities_table

			local eventTable = {}
			eventTable.ability = ability
			eventTable.caster = caster
			eventTable.target = hero
			eventTable.abilities_table = ability.apprentice_abilities_table
			erudite_teacher_start(eventTable)

			-- ability.apprentice_abilities_table = nil
		end
	end
end

function pivotal_swift_think(event)
	local ability = event.ability
	local caster = event.caster
	local hero = event.target

	if hero:HasModifier("modifier_pivotal_swiftboots_speed_decay") then
		local current_stacks = hero:GetModifierStackCount("modifier_pivotal_swiftboots_speed_decay", caster)
		local new_stacks = current_stacks - (PIVOT_BOOT_MS/(PIVOT_BURST_DURATION*10))
		hero:SetModifierStackCount("modifier_pivotal_swiftboots_speed_decay", caster, new_stacks)
		print(current_stacks)
	end
		
end

function magistrates_hood_init(event)
	local ability = event.ability
	local caster = event.caster
	local hero = event.target

	ability:ApplyDataDrivenModifier(caster, hero, "modifier_magistrates_hood_charges", {})
	hero:SetModifierStackCount("modifier_magistrates_hood_charges", caster, MAGISTRATE_HOOD_MAX_CHARGES)
end

function nethergrasp_thinker(event)
	local ability = event.ability
	local caster = event.caster
	local hero = event.target

	if not ability.nethergrasp_table then
		ability.nethergrasp_table = {}
		ability.pfx_table = {}
	end
	if not ability.interval then
		ability.interval = 0
	end
	local grasp_break_table = {}
	local new_grasp_table = {}
	if #ability.nethergrasp_table > 0 then
	    for i = 1, #ability.nethergrasp_table, 1 do
	        local nether = ability.nethergrasp_table[i]
	        if nether then
		        local target = EntIndexToHScript(nether.entindex)
		        if IsValidEntity(target) and target:IsAlive() and nether.active then
			        local distance = WallPhysics:GetDistance2d(target:GetAbsOrigin(), hero:GetAbsOrigin())
			        nether.distance = distance
			       	if i%#ability.nethergrasp_table == ability.interval then
			       		if hero:Script_GetAttackRange() + 100 >= distance then
			       			Filters:PerformAttackSpecial(hero, target, true, true, true, false, true, false, false)
			       			StartAnimation(hero, {duration = 0.2, activity = ACT_DOTA_ATTACK, rate = 2.0})
			       		end
			       	end
			        if distance > NETHERGRASP_BREAK_DISTANCE then
			        	table.insert(grasp_break_table, nether.entindex)
			        end
			        if not target:IsAlive() then
			        	table.insert(grasp_break_table, nether.entindex)
			        end
			        table.insert(new_grasp_table, nether)
			    else	
		            ParticleManager:DestroyParticle(nether.pfx, false)
		            ParticleManager:ReleaseParticleIndex(nether.pfx)	    	
			    end
		    end
	    end
	end
	ability.nethergrasp_table = new_grasp_table
    for i = 1, #grasp_break_table, 1 do
    	local target = EntIndexToHScript(grasp_break_table[i])
    	target:RemoveModifierByName("modifier_nethergrasp_linked")
    end
	ability.interval = ability.interval + 1
	if ability.interval >= #ability.nethergrasp_table then
		ability.interval = 0
	end
end

function nethergrasp_owner_die(event)
	local ability = event.ability
	local caster = event.caster
	local hero = event.unit
	for i = 1, #ability.pfx_table, 1 do
		ParticleManager:DestroyParticle(ability.pfx_table[i], false)
	end
	ability.nethergrasp_table = {}	
end

function nethergrasp_grip_end(event)
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
	local target = event.target

    -- local new_nethergrasp_table = {}
    for i = 1, #ability.nethergrasp_table, 1 do
        local nether = ability.nethergrasp_table[i]
        if nether.entindex == target:GetEntityIndex() then
            nether.active = false
        else
            -- table.insert(new_nethergrasp_table, nether)
        end
    end

    -- ability.nethergrasp_table = new_nethergrasp_table
    Timers:CreateTimer(0.03, function()
    	FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
    end)
end

function nethergrasp_owner_end2(event)
	event.target = event.unit
	-- nethergrasp_grip_end(event)
end

function nethergrasp_grip_thinker(event)
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
	local target = event.target
	local nether = nil
    for i = 1, #ability.nethergrasp_table, 1 do
        if ability.nethergrasp_table[i].entindex == target:GetEntityIndex() then
            nether = ability.nethergrasp_table[i]
            break
        end
    end
	if nether and nether.distance then
		if target.pushLock then
			return false
		end
		if target.jumpLock then
			return false
		end
		local range = hero:Script_GetAttackRange()

		if nether.distance > range then
			local pullSpeed = math.min(15, GameRules:GetGameTime() - nether.create_time + 5)
			pullSpeed = math.max(pullSpeed, 5)
			if target.type and target.type == ENEMY_TYPE_MINI_BOSS then
				pullSpeed = pullSpeed*0.6
			elseif target.type and target.type == ENEMY_TYPE_BOSS then
				pullSpeed = pullSpeed*0.3
			end
			local pullDirection = (hero:GetAbsOrigin() - target:GetAbsOrigin()):Normalized()
			target:SetAbsOrigin(target:GetAbsOrigin()+pullDirection*pullSpeed)
			print(pullSpeed)
		end
	end
end

function unequip_inspiration_ring(event)
	local target = event.target
	local ability = event.ability
	CustomGameEventManager:Send_ServerToPlayer(target:GetPlayerOwner(), "inspiration_ring", {abilities_cast = {false, false, false, false}, ring_name = ability:GetAbilityName(), clear = 1, color = "none"})
end

function alien_armor_die(event)
	local hero = event.unit
	local caster = event.caster
	local ability = event.ability
	local particle = "particles/econ/items/enigma/enigma_absolute_armour/enigma_absolute_armour_body_ambient.vpcf"

    if not ability.illusion_table then
        ability.illusion_table = {}
    end
    local new_body_illusion_table = {}
    for i = 1, #ability.illusion_table, 1 do
        if IsValidEntity(ability.illusion_table[i]) and ability.illusion_table[i]:IsAlive() then
        	local modifier = ability.illusion_table[i]:FindModifierByName("modifier_illusion")
        	-- if modifier:GetRemainingTime() > 3 then
            	table.insert(new_body_illusion_table, ability.illusion_table[i])
            -- end
        end
    end
    table.insert(new_body_illusion_table, illusion)
    ability.illusion_table = new_body_illusion_table

    local randomIllusion = ability.illusion_table[RandomInt(1, #ability.illusion_table)]
    if IsValidEntity(randomIllusion) then
    	ability:ApplyDataDrivenModifier(caster, randomIllusion, "modifier_alien_illusion_respawning_effect", {})
	    local modifier = randomIllusion:FindModifierByName("modifier_illusion")
	    modifier:SetDuration(ALIEN_ARMOR_RESPAWN_DELAY+0.1, true)
	    CustomAbilities:QuickAttachParticle("particles/econ/items/enigma/enigma_absolute_armour/enigma_absolute_armour_body_ambient.vpcf", randomIllusion, ALIEN_ARMOR_RESPAWN_DELAY)
	    Timers:CreateTimer(ALIEN_ARMOR_RESPAWN_DELAY, function()
	    	if not hero:IsAlive() and randomIllusion:IsAlive() then
	    		local respawnPoint = randomIllusion:GetAbsOrigin()
	    		local fv = randomIllusion:GetForwardVector()
				hero:RespawnHero(false, false)
				hero:SetAbsOrigin(respawnPoint)
				hero:SetForwardVector(fv)
				local pfx = CustomAbilities:QuickAttachParticle("particles/econ/items/riki/riki_immortal_ti6/riki_immortal_ti6_blinkstrike.vpcf", hero, 3)
				ParticleManager:SetParticleControl(pfx, 1, hero:GetAbsOrigin())
				EmitSoundOn("Items.AlienArmor.Respawn", hero)
	    	end
	    end)
	end
end