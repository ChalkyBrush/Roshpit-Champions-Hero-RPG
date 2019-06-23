require('/heroes/dark_seer/zhonik_constants')

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

	ability.e_1_level = caster:GetRuneValue("e", 1)
	ability.e_2_level = caster:GetRuneValue("e", 2)
	ability.e_3_level = caster:GetRuneValue("e", 3)
	ability.e_4_level = caster:GetRuneValue("e", 4)

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
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ParticleManager:ReleaseParticleIndex(ability.pfx)
	end
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, point)
	ParticleManager:SetParticleControl(pfx, 1, Vector(550,550,550))
	EmitSoundOnLocationWithCaster(point, "Zonik.TemporalField.Start", caster)
	ability.pfx = pfx

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_temporal_field_sliding", {duration = 1})
	ability.slideSpeed = 20
	if not ability.auraDummy then
		local dummy = CreateUnitByName("npc_dummy_unit", point, false, nil, nil, caster:GetTeamNumber())
		ability:ApplyDataDrivenModifier(caster, dummy, "modifier_temporal_dummy_aura", {duration = 10})
		dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
		ability.auraDummy = dummy
	else
		ability.auraDummy:SetAbsOrigin(point)
		if not ability.auraDummy:HasModifier("modifier_temporal_dummy_aura") then
			ability:ApplyDataDrivenModifier(caster, ability.auraDummy, "modifier_temporal_dummy_aura", {duration = 10})
		else
			local modifier = ability.auraDummy:FindModifierByName("modifier_temporal_dummy_aura")
			modifier:SetDuration(10,false)
		end
	end
	
end

function field_end(event)
	local ability = event.ability
	local caster = event.caster
	if ability.auraDummy then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ParticleManager:ReleaseParticleIndex(ability.pfx)
		-- ParticleManager:DestroyParticle(ability.auraDummy.pfx, false)
		-- ParticleManager:ReleaseParticleIndex(ability.auraDummy.pfx)
		EmitSoundOnLocationWithCaster(ability.auraDummy:GetAbsOrigin(), "Zonik.TemporalField.End", caster)
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
	--print("DID THIS TRIGGER?")

	if target:GetEntityIndex() == caster:GetEntityIndex() then
		target:RemoveModifierByName("modifier_dummy_aura1_effect_zhonik")
		target:RemoveModifierByName("modifier_zonik_temporal_field_cap")
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

	if not target:HasModifier("modifier_temporal_field_dashing") then
			target:RemoveModifierByName("modifier_dummy_aura1_effect_zhonik")
			target:RemoveModifierByName("modifier_zonik_temporal_field_cap")
	end
	target:RemoveModifierByName("modifier_dummy_aura_effect_enemy")
	target:RemoveModifierByName("modifier_dummy_aura_effect_enemy_a_c_visible")
	target:RemoveModifierByName("modifier_dummy_aura_effect_enemy_a_c_invisible")
	if ability.e_4_level > 0 then
		local duration = Filters:GetAdjustedBuffDuration(caster, ZHONIK_E4_ARCANA_MS_STICKY_DURATION*ability.e_4_level, false)
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

		if ability.e_3_level > 0 then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_zhonic_arcana_c_c_visible", {})
			local newStacks = math.min(target:GetModifierStackCount("modifier_zhonic_arcana_c_c_visible", caster) + 1, 1000)
			target:SetModifierStackCount("modifier_zhonic_arcana_c_c_visible", caster, newStacks)

			ability:ApplyDataDrivenModifier(caster, target, "modifier_zhonic_arcana_c_c_invisible", {})
			target:SetModifierStackCount("modifier_zhonic_arcana_c_c_invisible", caster, newStacks*ability.e_3_level)
		end
	end
end

function enemy_in_field_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if ability.e_1_level > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_dummy_aura_effect_enemy_a_c_visible", {})
		local newStacks = math.min(target:GetModifierStackCount("modifier_dummy_aura_effect_enemy_a_c_visible", caster) + 1, 20)
		target:SetModifierStackCount("modifier_dummy_aura_effect_enemy_a_c_visible", caster, newStacks)

		ability:ApplyDataDrivenModifier(caster, target, "modifier_dummy_aura_effect_enemy_a_c_invisible", {})
		target:SetModifierStackCount("modifier_dummy_aura_effect_enemy_a_c_invisible", caster, newStacks*ability.e_1_level)
	end
	if ability.e_2_level > 0 then
		local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)*ability.e_2_level*ZHONIK_E2_ARCANA_DMG_PCT/100
		CustomAbilities:QuickParticleAtPoint("particles/econ/items/dazzle/dazzle_darkclaw/dazzle_darkclaw_poison_touch_launch_flash.vpcf", target:GetAbsOrigin()+Vector(0,0,80), 1)
		Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_E, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)
	end
end

function c_c_think(event)
	local caster = event.caster
	local ability = event.ability
	local loseRate = ability:GetSpecialValueFor("lose_rate")
	if not caster:HasModifier("modifier_temporal_dummy_aura_effect") and not caster:HasModifier("modifier_temporal_field_dashing") then
		for i=1,loseRate,1 do
			local newStacks = caster:GetModifierStackCount("modifier_zhonic_arcana_c_c_visible", caster)-1
			local newStacks_inv = newStacks*ability.e_3_level
			if newStacks > 0 then
				caster:SetModifierStackCount("modifier_zhonic_arcana_c_c_visible", caster, newStacks)
				caster:SetModifierStackCount("modifier_zhonic_arcana_c_c_invisible", caster, newStacks_inv)
			else
				caster:RemoveModifierByName("modifier_zhonic_arcana_c_c_visible")
				caster:RemoveModifierByName("modifier_zhonic_arcana_c_c_invisible")
			end
		end
	end
end