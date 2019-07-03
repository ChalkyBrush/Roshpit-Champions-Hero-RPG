require('heroes/invoker/aspects')
LinkLuaModifier("modifier_conjuror_dark_horizon_lua", "modifiers/conjuror/modifier_conjuror_dark_horizon_lua", LUA_MODIFIER_MOTION_NONE)

function shadow_deity(event)
	local caster = event.caster
	local ability = event.ability
	local summonPosition = caster:GetAbsOrigin() + caster:GetForwardVector() * 340
	caster.shadowAspect = CreateUnitByName("shadow_deity", summonPosition, true, caster, caster, caster:GetTeamNumber())
	ability:ApplyDataDrivenModifier(caster, caster.shadowAspect, "modifier_aspect_invulnerable", {duration = 1})
	caster.shadowAspect.conjuror = caster
	caster.shadowAspect.owner = caster:GetPlayerOwnerID()
	caster.shadowAspect:SetOwner(caster)
	caster.shadowAspect:SetControllableByPlayer(caster:GetPlayerID(), true)
	caster.shadowAspect.aspect = true
	local aspectAbility = caster.shadowAspect:FindAbilityByName("aspect_abilities")
	aspectAbility:SetLevel(1)
	if caster.bIsAIonSHADOW == true or caster.bIsAIonSHADOW == nil then
		aspectAbility:ToggleAbility()
	end
	-- aspectAbility:ApplyDataDrivenModifier(caster.shadowAspect, caster.shadowAspect, "modifier_aspect_main", {})

	local shadowParticle = "particles/units/heroes/hero_enigma/enigma_ambient_body.vpcf"
	local pfx = ParticleManager:CreateParticle(shadowParticle, PATTACH_CUSTOMORIGIN, caster.shadowAspect)
	ParticleManager:SetParticleControl(pfx, 0, summonPosition)
	ParticleManager:SetParticleControl(pfx, 1, summonPosition)
	ParticleManager:SetParticleControl(pfx, 2, summonPosition)
	ParticleManager:SetParticleControl(pfx, 3, summonPosition)
	Timers:CreateTimer(1.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	EmitSoundOn("Conjuror.SummonShadowDeity", caster.shadowAspect)
	if caster:HasModifier("modifier_conjuror_glyph_4_1") then
		ability:ApplyDataDrivenModifier(caster, caster.shadowAspect, "modifier_conjuror_glyph_4_1_effect", {})
	end
	local shadowGate = caster:FindAbilityByName("dark_horizon")
	if not shadowGate then
		shadowGate = caster:AddAbility("dark_horizon")
		shadowGate:SetAbilityIndex(2)
	end
	if caster:HasModifier("modifier_conjuror_immortal_weapon_3") then
		caster.shadowAspect:AddAbility("normal_steadfast"):SetLevel(1)
	end
	caster.shadowAspect:FindAbilityByName("shadow_deity_cloak_of_shadows"):SetLevel(ability:GetLevel())
	shadowGate:SetLevel(ability:GetLevel())
	caster:SwapAbilities("summon_shadow_deity", "dark_horizon", false, true)
	ability:ApplyDataDrivenModifier(caster, caster.shadowAspect, "modifier_shadow_aspect", {})
	local aspectHealth = event.aspect_health
	if caster.aspectHealthAbility then
		aspectHealth = aspectHealth + caster:GetModifierStackCount("modifier_weapon_aspect_health", caster.aspectHealthAbility)
	end
	if caster:HasModifier("modifier_conjuror_glyph_2_1") then
		aspectHealth = aspectHealth * 1.8
	end
	local q_1_level = Runes:GetTotalRuneLevel(caster, 1, "q_1", "conjuror")
	aspectHealth = aspectHealth * (1 + q_1_level * 0.05)
	Timers:CreateTimer(0.05, function()
		caster.shadowAspect:SetMaxHealth(aspectHealth)
		caster.shadowAspect:SetBaseMaxHealth(aspectHealth)
		caster.shadowAspect:SetHealth(aspectHealth)
		caster.shadowAspect:Heal(aspectHealth, caster.shadowAspect)
		common_aspect_effects(caster, ability, caster.shadowAspect)
	end)
	local d_c_level = caster:GetRuneValue("e", 4)
	caster.shadowAspect.e_4_level = d_c_level
	if d_c_level > 0 then
		caster.shadowAspect:SetRangedProjectileName("particles/econ/items/enigma/enigma_geodesic/conjuror_d_c_aspect_eidolon_geodesic.vpcf")
	end
	glyph_5_a(caster, ability, caster.shadowAspect)
	caster.shadowAspect.shadowDeity = true
	local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/conjuror/shadow_deity_cloak_of_shadows.vpcf", caster.shadowAspect, 3)
	ParticleManager:SetParticleControl(pfx, 1, Vector(200, 200, 200))
	caster.shadowAspect:SetRenderColor(200, 60, 200)
	local e_1_level = caster:GetRuneValue("e", 1)
	if e_1_level > 0 then
		caster.shadowAspect:AddAbility("shadow_deity_black_razor"):SetLevel(1)
		local black_razor = caster.shadowAspect:FindAbilityByName("shadow_deity_black_razor")
		black_razor:ToggleAutoCast()
	end
	local e_4_level = caster:GetRuneValue("e", 4)
	if e_4_level > 0 then
		caster.shadowAspect:AddAbility("shadow_deity_shadow_essence"):SetLevel(1)
		local shadow_essence = caster.shadowAspect:FindAbilityByName("shadow_deity_shadow_essence")
		shadow_essence:ToggleAutoCast()
	end
end

function cloak_of_shadows_cast(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	local radius = event.radius
	local duration = Filters:GetAdjustedBuffDuration(caster.conjuror, event.duration, false)

	local pfx = ParticleManager:CreateParticle("particles/roshpit/conjuror/shadow_deity_cloak_of_shadows.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, point)
	ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
	Timers:CreateTimer(4, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	local targets = {}
	local allies = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
	for i = 1, #allies, 1 do
		if allies[i]:GetUnitName() == "npc_dota_hero_invoker" or allies[i].aspect or allies[i].elemental_deity then
			table.insert(targets, allies[i])
		end
	end
	for i = 1, #targets, 1 do
		local target = targets[i]
		local pfx2 = CustomAbilities:QuickAttachParticle("particles/roshpit/conjuror/shadow_deity_cloak_of_shadows.vpcf", target, 3)
		ParticleManager:SetParticleControl(pfx2, 1, Vector(200, 200, 200))
		ability:ApplyDataDrivenModifier(caster, target, "modifier_invisibility_datadriven", {duration = duration})
		target:AddNewModifier(caster, ability, "modifier_persistent_invisibility", {duration = duration})
	end
	EmitSoundOnLocationWithCaster(point, "Conjuror.CloakOfShadows", caster)
end

function black_razor_cast(event)
	local caster = event.caster
	local ability = event.ability
	local radius = event.radius
	local duration = Filters:GetAdjustedBuffDuration(caster.conjuror, event.duration, false)
	local allies = {}
	if caster.conjuror.earthAspect then
		table.insert(allies, caster.conjuror.earthAspect)
	end
	if caster.conjuror.fireAspect then
		table.insert(allies, caster.conjuror.fireAspect)
	end
	if caster.conjuror.shadowAspect then
		table.insert(allies, caster.conjuror.shadowAspect)
	end
	table.insert(allies, caster.conjuror)
	if caster.conjuror.deity then
		table.insert(allies, caster.conjuror.deity)
	end
	ability.e_1_level = caster.conjuror:GetRuneValue("e", 1)
	for i = 1, #allies, 1 do
		local ally = allies[i]
		if IsValidEntity(ally) then
			if ally:IsAlive() then
				ability:ApplyDataDrivenModifier(caster, ally, "modifier_black_razor", {duration = duration})
				ability:ApplyDataDrivenModifier(caster, ally, "modifier_black_razor_attack_power", {duration = duration})
				ally:SetModifierStackCount("modifier_black_razor_attack_power", caster, ability.e_1_level)
				EmitSoundOn("Conjuror.BlackRazor.Start", ally)
			end
		end
	end
end

function black_razor_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local conjuror = caster.conjuror
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, event.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	local damage = OverflowProtectedGetAverageTrueAttackDamage(target) * (CONJUROR_ARCANA_E1_ATTACK_POWER_BLACK_RAZOR / 100) * ability.e_1_level
	for _, enemy in pairs(enemies) do
		Filters:TakeArgumentsAndApplyDamage(enemy, conjuror, damage, DAMAGE_TYPE_PURE, BASE_ABILITY_E, RPC_ELEMENT_SHADOW, RPC_ELEMENT_NONE)
	end
end

function black_razor_start(event)
	local target = event.target
	StartSoundEvent("Conjuror.BlackRazor.LP", target)
end

function black_razor_end(event)
	local target = event.target
	StopSoundEvent("Conjuror.BlackRazor.LP", target)
	EmitSoundOn("Conjuror.BlackRazor.End", target)
end

function dark_horizon_start(event)
	local caster = event.caster
	local ability = event.ability
	local radius = event.radius
	local point = event.target_points[1]
	local allies = {}
	if caster.earthAspect then
		table.insert(allies, caster.earthAspect)
	end
	if caster.fireAspect then
		table.insert(allies, caster.fireAspect)
	end
	if caster.shadowAspect then
		table.insert(allies, caster.shadowAspect)
	end
	table.insert(allies, caster)
	if caster.deity then
		table.insert(allies, caster.deity)
	end
	point = WallPhysics:WallSearch(caster:GetAbsOrigin(), point, caster)
	EmitSoundOn("Conjuror.DarkHorizon.Start", caster)
	Filters:CastSkillArguments(3, caster)
	for i = 1, #allies, 1 do
		local ally = allies[i]
		if IsValidEntity(ally) then
			if ally:IsAlive() then
				local pfx = ParticleManager:CreateParticle("particles/roshpit/conjuror/dark_horizon.vpcf", PATTACH_CUSTOMORIGIN, nil)
				local startPoint = ally:GetAbsOrigin() + Vector(0, 0, 100)
				ParticleManager:SetParticleControl(pfx, 1, point)
				ParticleManager:SetParticleControl(pfx, 0, startPoint)
				ability:ApplyDataDrivenModifier(caster, ally, "modifier_dark_horizon_transport", {duration = 1.5})
				ally:AddNewModifier(caster, ability, "modifier_conjuror_dark_horizon_lua", {duration = 1.5})
				Timers:CreateTimer(1.5, function()
					ParticleManager:DestroyParticle(pfx, false)
					FindClearSpaceForUnit(ally, point, false)
					local pfx2 = ParticleManager:CreateParticle("particles/roshpit/conjuror/dark_horizon.vpcf", PATTACH_CUSTOMORIGIN, nil)
					local startPoint = ally:GetAbsOrigin() + Vector(0, 0, 100)
					ParticleManager:SetParticleControl(pfx2, 1, ally:GetAbsOrigin())
					ParticleManager:SetParticleControl(pfx2, 0, ally:GetAbsOrigin())
					Timers:CreateTimer(0.5, function()
						ParticleManager:DestroyParticle(pfx2, false)
					end)
					EmitSoundOn("Conjuror.DarkHorizon.End", caster)
				end)
			end
		end
	end
end

function dark_horizon_transporting_think(event)
	local target = event.target
	if target:HasModifier("modifier_black_razor") then
		local modifier = target:FindModifierByName("modifier_black_razor")
		modifier:SetDuration(modifier:GetRemainingTime() + 0.1, true)
	end
end

function shadow_deity_passive_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster:HasModifier("modifier_recently_respawned") then
		return false
	end
	if caster:IsAlive() then
		local e_3_level = caster:GetRuneValue("e", 3)
		local agility_from_gear = caster:GetModifierStackCount("modifier_trinket_agility", caster.InventoryUnit) + caster:GetModifierStackCount("modifier_body_agility", caster.InventoryUnit) + caster:GetModifierStackCount("modifier_hand_agility", caster.InventoryUnit) + caster:GetModifierStackCount("modifier_helm_agility", caster.InventoryUnit) + caster:GetModifierStackCount("modifier_weapon_agility", caster.InventoryUnit) + caster:GetModifierStackCount("modifier_hand_agility", caster.InventoryUnit) + caster:GetModifierStackCount("modifier_foot_agility", caster.InventoryUnit)
		local bonus_agility = agility_from_gear * (CONJUROR_ARCANA_E3_AGILITY_GEAR_AMP / 100) * e_3_level
		if bonus_agility > 0 then
			ability:ApplyDataDrivenModifier(caster, caster, "shadow_deity_agility_from_gear", {})
			caster:SetModifierStackCount("shadow_deity_agility_from_gear", caster, bonus_agility)
		else
			caster:RemoveModifierByName("shadow_deity_agility_from_gear")
		end
	end
end

function shadow_essence_cast(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local duration = Filters:GetAdjustedBuffDuration(caster.conjuror, event.duration, false)

	local pfx = ParticleManager:CreateParticle("particles/roshpit/conjuror/shadow_essence_start.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin() + Vector(0, 0, 100))
	ParticleManager:SetParticleControl(pfx, 1, target:GetAbsOrigin() + Vector(0, 0, 100))
	ParticleManager:SetParticleControl(pfx, 15, Vector(90, 0, 160))
	local pfx2 = ParticleManager:CreateParticle("particles/roshpit/conjuror/shadow_essence_start.vpcf", PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControl(pfx2, 1, caster:GetAbsOrigin() + Vector(0, 0, 100))
	ParticleManager:SetParticleControl(pfx2, 0, target:GetAbsOrigin() + Vector(0, 0, 100))
	ParticleManager:SetParticleControl(pfx2, 15, Vector(90, 0, 160))
	Timers:CreateTimer(4, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:DestroyParticle(pfx2, false)
	end)
	EmitSoundOn("Conjuror.ShadowEssence.Start", caster)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_shadow_essence_split_attack", {duration = duration})
	ability:ApplyDataDrivenModifier(caster, target, "modifier_shadow_essence_split_attack", {duration = duration})
	ability.e_4_level = caster.conjuror:GetRuneValue("e", 4)
end

function shadow_essence_attack_start(event)
	local caster = event.caster
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 580, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	local procs = Runes:Procs(ability.e_4_level, CONJUROR_ARCANA_E4_SPLIT_CHANCE, 1)
	local shots = 0
	if not attacker.shadowEssenceLock then
		attacker.shadowEssenceLock = true
		for _, enemy in pairs(enemies) do
			if shots < procs then
				if enemy:GetEntityIndex() == target:GetEntityIndex() or enemy.dummy then
				else
					if shots < procs then
						Filters:PerformAttackSpecial(attacker, enemy, true, true, true, false, true, false, false)
						shots = shots + 1
					end
				end
			end
		end
		Timers:CreateTimer(0.1, function()
			attacker.shadowEssenceLock = false
		end)
	end
end
