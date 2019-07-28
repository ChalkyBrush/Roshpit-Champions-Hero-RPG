require('heroes/nightstalker/chernobog_constants')

LinkLuaModifier("modifier_chernobog_demon_flight_attack", "modifiers/chernobog_1_e/modifier_chernobog_demon_flight_attack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chernobog_d_c_arcana2", "modifiers/chernobog_1_e/modifier_chernobog_d_c_arcana2", LUA_MODIFIER_MOTION_NONE)

function demon_flight_start(event)
	local caster = event.caster
	local ability = event.ability
	local duration = Filters:GetAdjustedBuffDuration(caster, event.duration, false)
	caster:RemoveModifierByName("modifier_demon_flight_landing")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_chernobog_demon_flight", {duration = duration})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_demonflight_z", {duration = duration + 5})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_demon_flight_flying", {duration = duration + 5})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_demonflight_attacks", {duration = duration + 5})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_chernobog_night_vision", {duration = duration + 5})

	caster:AddNewModifier(caster, ability, "modifier_chernobog_demon_flight_attack", {duration = duration + 5})
	caster:AddNewModifier(caster, nil, "modifier_animation_translate", {translate = "hunter_night"})
	caster.flight_target = nil
	if not caster:HasModifier("modifier_chernobog_demon_form") then
		caster:SetModel("models/heroes/nightstalker/nightstalker_night.vmdl")
		caster:SetOriginalModel("models/heroes/nightstalker/nightstalker_night.vmdl")
		Timers:CreateTimer(0.03, function()
			StartAnimation(caster, {duration = 0.9, activity = ACT_DOTA_CAST_ABILITY_3, rate = 1, translate = "hunter_night"})
		end)
	end
	EmitSoundOn("Chernobog.DemonFlight.Start", caster)
	EmitSoundOn("Chernobog.DemonFlight.StartVO", caster)
	caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)

	Filters:CastSkillArguments(3, caster)
	swap_to_demon_warp(caster, ability, "chernobog_demon_flight")
end

function swap_to_demon_warp(caster, ability, base_name)
	local a_c_level = caster:GetRuneValue("e", 1)
	if a_c_level > 0 then
		CustomAbilities:AddAndOrSwapSkill(caster, base_name, "chernobog_demon_warp", 2)
		local procs = Runes:Procs(a_c_level, CHERNOBOG_ARCANA_E1_STACKS_CHANCE, 1)
		if procs > 0 then
			local warp_ability = caster:FindAbilityByName("chernobog_demon_warp")
			warp_ability:ApplyDataDrivenModifier(caster, caster, "modifier_demon_warp_freecast", {})
			caster:SetModifierStackCount("modifier_demon_warp_freecast", caster, procs)
		end
	end
end

function demon_flight_think(event)
	local caster = event.caster
	local ability = event.ability
	local current_height_stacks = caster:GetModifierStackCount("modifier_demonflight_z", caster)
	local newStacks = math.min(current_height_stacks + 6, 380)
	if not caster:HasModifier("modifier_nights_procession_caster_lifting") then
		caster:SetModifierStackCount("modifier_demonflight_z", caster, newStacks)
	end
	caster:AddNewModifier(caster, nil, "modifier_animation_translate", {translate = "hunter_night"})

end

function flying_portion_think(event)
	local caster = event.caster
	local ability = event.ability
	local newPos = caster:GetAbsOrigin() + caster:GetForwardVector() * 70
	local obstruction = WallPhysics:FindNearestObstruction(caster:GetAbsOrigin())
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPos, caster)

	if blockUnit then
		caster:SetAbsOrigin(caster:GetAbsOrigin() - caster:GetForwardVector() * 50)
	end
end

function demon_flight_end(event)
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_demon_flight_landing", {duration = 3})
end

function demon_flight_end_thinking(event)
	local caster = event.caster
	local ability = event.ability
	local current_height_stacks = caster:GetModifierStackCount("modifier_demonflight_z", caster)
	local newStacks = current_height_stacks - 9
	if not caster:HasModifier("modifier_nights_procession_caster_lifting") then
		caster:SetModifierStackCount("modifier_demonflight_z", caster, newStacks)
	end
	if newStacks <= 8 or caster:HasModifier("modifier_nights_procession_caster_lifting") then
		caster:RemoveModifierByName("modifier_demonflight_z")
		caster:RemoveModifierByName("modifier_demon_flight_landing")
		caster:RemoveModifierByName("modifier_animation_translate")
		caster:RemoveModifierByName("modifier_demon_flight_flying")
		caster:RemoveModifierByName("modifier_animation")
		caster:RemoveModifierByName("modifier_chernobog_demon_flight_attack")
		caster:RemoveModifierByName("modifier_demonflight_attacks")
		caster:RemoveModifierByName("modifier_chernobog_night_vision")
		if not caster:HasModifier("modifier_nights_procession_caster_lifting") then
			WallPhysics:ClearSpaceForUnit(caster, caster:GetAbsOrigin())
		end
		if not caster:HasModifier("modifier_chernobog_demon_form") then
			caster:SetModel("models/heroes/nightstalker/nightstalker.vmdl")
			caster:SetOriginalModel("models/heroes/nightstalker/nightstalker.vmdl")
			if not caster:HasModifier("modifier_super_ascendency_trigger") then
				caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
			end
			--print("MODEL BACK!!")
			--print("#$#@$#$#")
			Timers:CreateTimer(0.06, function()
				if not caster:HasModifier("modifier_nights_procession_caster_lifting") then
					StartAnimation(caster, {duration = 0.5, activity = ACT_DOTA_CAST_ABILITY_1, rate = 1.3, translate = "wraith_spin"})
				else
					StartAnimation(caster, {duration = 1.3, activity = ACT_DOTA_TELEPORT, rate = 1})
				end
			end)
		end
		if caster:GetAbilityByIndex(DOTA_E_SLOT):GetAbilityName() == "chernobog_demon_warp" then
			CustomAbilities:AddAndOrSwapSkill(caster, "chernobog_demon_warp", "chernobog_demon_flight", 2)
		end
		caster:RemoveModifierByName("modifier_demon_warp_freecast")
	end
end

function flight_attacks_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.flight_target then
		if not IsValidEntity(caster.flight_target) then
			caster.flight_target = nil
			return false
		end
		if caster.flight_target:GetTeamNumber() == caster:GetTeamNumber() then
			return false
		end
		if not caster.flight_target:IsAlive() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster.flight_target:GetAbsOrigin(), nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
			local count = 0
			if #enemies > 0 then
				caster.flight_target = enemies[1]
			else
				caster.flight_target = nil
				return false
			end
		end
		if WallPhysics:GetDistance2d(caster.flight_target:GetAbsOrigin(), caster:GetAbsOrigin()) > 900 then
			return false
		end
		if caster:HasModifier("modifier_super_ascendency_trigger") then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster.flight_target:GetAbsOrigin(), nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
			local count = 0
			if #enemies > 0 then
				for _, enemy in pairs(enemies) do
					Filters:PerformAttackSpecial(caster, enemy, true, true, true, false, true, false, false)
					count = count + 1
					if count == 3 then
						break
					end
				end
			end
		else
			Filters:PerformAttackSpecial(caster, caster.flight_target, true, true, true, false, true, false, false)
		end
	end
end

function warp_phase_start(event)
	local caster = event.caster
	EmitSoundOn("Chernobog.DemonWarp", caster)
end

function demon_warp_start(event)
	local caster = event.caster
	local target = event.target_points[1]
	local casterOrigin = caster:GetAbsOrigin()
	local heightStacks = caster:GetModifierStackCount("modifier_demonflight_z", caster)
	local a_c_level = caster:GetRuneValue("e", 1)
	CustomAbilities:QuickParticleAtPoint("particles/items_fx/blink_dagger_start.vpcf", caster:GetAbsOrigin() + Vector(0, 0, heightStacks), 3)
	CustomAbilities:QuickAttachParticle("particles/econ/items/spectre/spectre_transversant_soul/spectre_transversant_spectral_dagger_path_owner_impact.vpcf", caster, 3)
	target = WallPhysics:WallSearch(casterOrigin, target, caster)
	local newPosition = target
	local direction = ((newPosition - casterOrigin) * Vector(1, 1, 0)):Normalized()
	local distance = WallPhysics:GetDistance2d(casterOrigin, newPosition)
	local maxDistance = CHERNOBOG_ARCANA_E1_CLAMP_BASE + a_c_level * CHERNOBOG_ARCANA_E1_CLAMP
	if distance > maxDistance then
		newPosition = WallPhysics:WallSearch(casterOrigin, casterOrigin + direction * maxDistance, caster)
	end
	FindClearSpaceForUnit(caster, newPosition, false)
	Filters:CastSkillArguments(3, caster)
	ProjectileManager:ProjectileDodge(caster)
	CustomAbilities:QuickParticleAtPoint("particles/econ/items/spectre/spectre_transversant_soul/spectre_transversant_spectral_dagger_path_owner_impact.vpcf", caster:GetAbsOrigin(), 3)
	CustomAbilities:QuickParticleAtPoint("particles/items_fx/blink_dagger_start.vpcf", caster:GetAbsOrigin() + Vector(0, 0, heightStacks), 3)

	StartAnimation(caster, {duration = 0.9, activity = ACT_DOTA_CAST_ABILITY_3, rate = 1, translate = "hunter_night"})

	if caster:HasModifier("modifier_demon_warp_freecast") then
		local newStacks = caster:GetModifierStackCount("modifier_demon_warp_freecast", caster) - 1
		if newStacks > 0 then
			caster:SetModifierStackCount("modifier_demon_warp_freecast", caster, newStacks)
		else
			caster:RemoveModifierByName("modifier_demon_warp_freecast")
		end
	else
		if caster:HasModifier("modifier_chernobog_arcana2") then
			if caster:HasModifier("modifier_chernobog_demon_form") then
				CustomAbilities:AddAndOrSwapSkill(caster, "chernobog_demon_warp", "chernobog_demon_walk", 2)
			else
				CustomAbilities:AddAndOrSwapSkill(caster, "chernobog_demon_warp", "chernobog_demon_flight", 2)
			end
		end
	end

end

function passive_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local b_c_level = caster:GetRuneValue("e", 2)
	if b_c_level > 0 then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_demonflight_b_c_visible", {})
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_demonflight_b_c_invisible", {})
			caster:SetModifierStackCount("modifier_demonflight_b_c_visible", caster, #enemies)
			caster:SetModifierStackCount("modifier_demonflight_b_c_invisible", caster, #enemies * b_c_level)
		else
			caster:RemoveModifierByName("modifier_demonflight_b_c_visible")
			caster:RemoveModifierByName("modifier_demonflight_b_c_invisible")
		end
	else
		caster:RemoveModifierByName("modifier_demonflight_b_c_visible")
		caster:RemoveModifierByName("modifier_demonflight_b_c_invisible")
	end
	local c_c_level = caster:GetRuneValue("e", 3)
	if c_c_level > 0 then
		local damageDealt = 10000
		local damageDEMON = Filters:ElementalDamage(Events.GameMaster, caster, damageDealt * 100, DAMAGE_TYPE_PURE, 0, RPC_ELEMENT_DEMON, RPC_ELEMENT_NONE, false)
		local demonAmp = math.floor(damageDEMON / damageDealt)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_demonflight_c_c_attack", {})
		local attack_dmg = (demonAmp) * c_c_level * CHERNOBOG_ARCANA2_E3_ATT_PER_DEMON_PCT
		caster:SetModifierStackCount("modifier_demonflight_c_c_attack", caster, attack_dmg)
	else
		caster:RemoveModifierByName("modifier_demonflight_c_c_attack")
	end
	local d_c_level = caster:GetRuneValue("e", 4)
	ability.e_4_level = d_c_level
	if d_c_level > 0 then
		caster:AddNewModifier(caster, ability, "modifier_chernobog_d_c_arcana2", {})
		caster:SetModifierStackCount("modifier_chernobog_d_c_arcana2", caster, d_c_level)
	else
		caster:RemoveModifierByName("modifier_chernobog_d_c_arcana2")
	end
end

function initialize_demon_walk(event)
	local caster = event.caster
	local ability = event.ability
	local duration = Filters:GetAdjustedBuffDuration(caster, event.duration, false)
	caster:AddNewModifier(caster, nil, "modifier_persistent_invisibility", {duration = duration})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_demon_walk", {duration = duration})
	Filters:CastSkillArguments(3, caster)
	swap_to_demon_warp(caster, ability, "chernobog_demon_walk")
	EmitSoundOn("Chernobog.DemonWalkStart", caster)
	CustomAbilities:QuickAttachParticle("particles/roshpit/chernobog/shadow_walk.vpcf", caster, 1.5)
	StartAnimation(caster, {duration = 0.9, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_chernobog_night_vision", {duration = duration})
end

function demon_walk_apply_invis(event)
	local caster = event.caster
	local ability = event.ability
	CustomAbilities:QuickAttachParticle("particles/econ/items/spectre/spectre_transversant_soul/spectre_transversant_spectral_dagger_path_owner_impact.vpcf", caster, 0.4)
	-- local duration = caster:FindModifierByName("modifier_demon_walk"):GetRemainingTime()
	-- caster:AddNewModifier(caster, nil, "modifier_invisible", {duration = duration})
end

function demon_walk_end(event)
	local caster = event.caster
	local ability = event.ability
	if caster:HasModifier("modifier_chernobog_arcana2") then
		if caster:GetAbilityByIndex(DOTA_E_SLOT):GetAbilityName() == "chernobog_demon_warp" then
			if caster:HasModifier("modifier_chernobog_demon_form") then
				CustomAbilities:AddAndOrSwapSkill(caster, "chernobog_demon_warp", "chernobog_demon_walk", 2)
			else
				CustomAbilities:AddAndOrSwapSkill(caster, "chernobog_demon_warp", "chernobog_demon_flight", 2)
			end
		end
	end
	caster:RemoveModifierByName("modifier_demon_warp_freecast")
end
