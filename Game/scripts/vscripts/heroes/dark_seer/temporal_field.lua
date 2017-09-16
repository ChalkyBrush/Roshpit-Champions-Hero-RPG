LinkLuaModifier("modifier_zonik_temporal_field_cap", "modifiers/zonik/modifier_zonik_temporal_field_cap", LUA_MODIFIER_MOTION_NONE)

function field_phase_start(event)
	local caster = event.caster
	-- StartAnimation(caster, {duration=0.2, activity=ACT_DOTA_VERSUS, rate=3.2})
end

function field_start(event)
	local caster = event.caster
	local point = event.target_points[1]
	local ability = event.ability
	EmitSoundOn("Zonik.TemporalField.DashVO", caster)

	ability.point = point
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_temporal_field_dashing", {duration = 1})
	if ability.auraDummy then
		field_end(event)
		if ability.auraDummy then
			ability.auraDummy:RemoveModifierByName("modifier_temporal_dummy_aura")
		end
	end
	ability.a_c_level = Runes:GetTotalRuneLevelGeneric(caster, 1, 2)
	ability.b_c_level = Runes:GetTotalRuneLevelGeneric(caster, 2, 2)
	ability.c_c_level = Runes:GetTotalRuneLevelGeneric(caster, 3, 2)
	ability.d_c_level = Runes:GetTotalRuneLevelGeneric(caster, 4, 2)

	Filters:CastSkillArguments(3, caster)
end

function zhonik_dashing(event)
	local caster = event.caster
	local ability = event.ability
	
	ability.moveDirection = (ability.point-caster:GetAbsOrigin()):Normalized()

	local blockSearch = caster:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,GetGroundHeight(caster:GetAbsOrigin(), caster))
    local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch+ability.moveDirection*35), caster)

    local forwardSpeed = 70
	if blockUnit then
		forwardSpeed = 0
		caster:RemoveModifierByName("modifier_temporal_field_dashing")
		zhonik_dash_end(caster, ability)
	end
	local newPosition = caster:GetAbsOrigin() + ability.moveDirection*forwardSpeed
	caster:SetAbsOrigin(Vector(newPosition.x, newPosition.y, 0) + Vector(0,0,GetGroundHeight(newPosition, caster)))
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.point)

	if distance < forwardSpeed*1.5 then
		caster:RemoveModifierByName("modifier_temporal_field_dashing")
		zhonik_dash_end(caster, ability)
	end
end

function zhonik_dash_end(caster, ability)
	Timers:CreateTimer(0.03, function()
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_CAST_ABILITY_3, rate=1.7})
	end)
	local point = ability.point
	local particleName = "particles/roshpit/zhonik/temporal_field.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, point)
	ParticleManager:SetParticleControl(pfx, 1, Vector(550,550,550))
	EmitSoundOnLocationWithCaster(point, "Zonik.TemporalField.Start", caster)
	ability.pfx = pfx

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_temporal_field_sliding", {duration = 1})
	ability.slideSpeed = 20
	if ability.auraDummy then
		ParticleManager:DestroyParticle(ability.auraDummy.pfx, false)
	end
	local dummy = CreateUnitByName("npc_dummy_unit", point, false, nil, nil, caster:GetTeamNumber())
	ability:ApplyDataDrivenModifier(caster, dummy, "modifier_temporal_dummy_aura", {duration = 10})
	dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
	dummy.pfx = pfx
	ability.auraDummy = dummy
	
end

function field_end(event)
	local ability = event.ability
	local caster = event.caster
	if ability.auraDummy then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ParticleManager:DestroyParticle(ability.auraDummy.pfx, false)
		EmitSoundOnLocationWithCaster(ability.auraDummy:GetAbsOrigin(), "Zonik.TemporalField.End", caster)
		UTIL_Remove(ability.auraDummy)
		ability.auraDummy = false

	end
end

function zhonik_sliding(event)
	local caster = event.caster
	local ability = event.ability
	ability.slideSpeed = math.max(ability.slideSpeed - 1, 0)
	local blockSearch = caster:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,GetGroundHeight(caster:GetAbsOrigin(), caster))
    local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch+ability.moveDirection*35), caster)

    local forwardSpeed = ability.slideSpeed 
	if blockUnit then
		forwardSpeed = 0
	end
	local newPosition = caster:GetAbsOrigin() + ability.moveDirection*forwardSpeed
	caster:SetAbsOrigin(Vector(newPosition.x, newPosition.y, 0) + Vector(0,0,GetGroundHeight(newPosition, caster)))
end

function sliding_end(event)
	local caster = event.caster
	Timers:CreateTimer(0.03, function()
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
	end)
end

function temporal_field_enter(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	print("DID THIS TRIGGER?")

	if target:GetEntityIndex() == caster:GetEntityIndex() then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_dummy_aura1_effect_zhonik", {})
		caster:AddNewModifier( caster, ability, "modifier_zonik_temporal_field_cap", {duration = duration} )
	end
	if event.create == 1 then
		if target:GetTeamNumber() == caster:GetTeamNumber() then
		else
			ability:ApplyDataDrivenModifier(caster, target, "modifier_dummy_aura_effect_enemy", {})
			enemy_in_field_think(event)
		end
	end
end

function temporal_field_leave(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	target:RemoveModifierByName("modifier_dummy_aura1_effect_zhonik")
	target:RemoveModifierByName("modifier_zonik_temporal_field_cap")
	target:RemoveModifierByName("modifier_dummy_aura_effect_enemy")
	target:RemoveModifierByName("modifier_dummy_aura_effect_enemy_a_c_visible")
	target:RemoveModifierByName("modifier_dummy_aura_effect_enemy_a_c_invisible")
	target:RemoveModifierByName("modifier_zhonic_arcana_c_c_visible")
	target:RemoveModifierByName("modifier_zhonic_arcana_c_c_invisible")
	if ability.d_c_level > 0 then
		local duration = Filters:GetAdjustedBuffDuration(caster, 0.1*ability.d_c_level, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_zonik_temporal_field_cap", {duration = duration})	
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_dummy_aura1_effect_zhonik", {duration = duration})	
	end
end

function zhonik_aura_thinker(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	if caster:HasModifier("modifier_temporal_dummy_aura_effect") then
		Filters:CleanseStuns(target)
		Filters:CleanseSilences(target)

		if ability.c_c_level > 0 then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_zhonic_arcana_c_c_visible", {})
			local newStacks = math.min(target:GetModifierStackCount("modifier_zhonic_arcana_c_c_visible", caster) + 1, 1000)
			target:SetModifierStackCount("modifier_zhonic_arcana_c_c_visible", caster, newStacks)

			ability:ApplyDataDrivenModifier(caster, target, "modifier_zhonic_arcana_c_c_invisible", {})
			target:SetModifierStackCount("modifier_zhonic_arcana_c_c_invisible", caster, newStacks*ability.c_c_level)
		end
	end
end

function enemy_in_field_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if ability.a_c_level > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_dummy_aura_effect_enemy_a_c_visible", {})
		local newStacks = math.min(target:GetModifierStackCount("modifier_dummy_aura_effect_enemy_a_c_visible", caster) + 1, 20)
		target:SetModifierStackCount("modifier_dummy_aura_effect_enemy_a_c_visible", caster, newStacks)

		ability:ApplyDataDrivenModifier(caster, target, "modifier_dummy_aura_effect_enemy_a_c_invisible", {})
		target:SetModifierStackCount("modifier_dummy_aura_effect_enemy_a_c_invisible", caster, newStacks*ability.a_c_level)
	end
	if ability.b_c_level > 0 then
		local damage = caster:GetAverageTrueAttackDamage(caster)*0.1*ability.b_c_level
		CustomAbilities:QuickParticleAtPoint("particles/econ/items/dazzle/dazzle_darkclaw/dazzle_darkclaw_poison_touch_launch_flash.vpcf", target:GetAbsOrigin()+Vector(0,0,80), 1)
		Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 3, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)
	end
end