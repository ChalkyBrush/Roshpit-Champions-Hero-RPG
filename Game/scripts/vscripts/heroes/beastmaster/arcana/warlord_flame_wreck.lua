LinkLuaModifier("modifier_warlord_in_flame_wreck", "modifiers/warlord/modifier_warlord_in_flame_wreck", LUA_MODIFIER_MOTION_NONE)

function flame_wreck_start(event)
	local caster = event.caster
	local ability = event.ability

	local particleName = "particles/roshpit/warlord/flame_wreck.vpcf"

	local range = event.range
	local fire_duration = event.wreck_duration
	local fv = caster:GetForwardVector()

	local dummy = CreateUnitByName("npc_dummy_unit", caster:GetAbsOrigin(), false, nil, nil, caster:GetTeamNumber())
	dummy:FindAbilityByName("dummy_unit"):SetLevel(1)

	StartSoundEvent("Warlord.FlameWreck.Start", dummy)
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin() + fv*range)
	ParticleManager:SetParticleControl(pfx, 2, Vector(fire_duration, fire_duration, fire_duration))
	dummy.pfx = pfx

	dummy.position = caster:GetAbsOrigin()
	dummy.endPoint = dummy.position + fv*range
	ability:ApplyDataDrivenModifier(caster, dummy, "modifier_flame_wreck_thinker", {duration = fire_duration})
	EmitSoundOn("Warlord.Cataclysm.VO", caster)
	StartAnimation(caster, {duration = 1.0, activity = ACT_DOTA_CAST_ABILITY_4, rate = 1.5})
	Filters:CastSkillArguments(1, caster)
end

function flame_wreck_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	local damage = event.base_damage
	damage = damage + event.agi_mult*caster:GetAgility()
	local units_in_fire = FindUnitsInLine(caster:GetTeamNumber(), target.position, target.endPoint, nil, 280, DOTA_UNIT_TARGET_TEAM_ENEMY+DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0)
	for _, unit in pairs(units_in_fire) do
		if unit:GetTeamNumber() ~= caster:GetTeamNumber() then
			Filters:TakeArgumentsAndApplyDamage(unit, caster, damage, DAMAGE_TYPE_MAGICAL, RPC_ELEMENT_FIRE, RPC_ELEMENT_DRAGON, 1)
		elseif unit == caster then
			caster:AddNewModifier(caster, ability, "modifier_warlord_in_flame_wreck", {duration = 0.56})
			local q_3_level = caster:GetRuneValue("q", 3)
			if q_3_level > 0 then
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_flame_wreck_q3_atk_power", {duration = 0.56})
				caster:SetModifierStackCount("modifier_flame_wreck_q3_atk_power", caster, q_3_level)
			end
		end
		Timers:CreateTimer(0.03, function()
			FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), false)
		end)
	end
end

function flame_wreck_dummy_end(event)
	local caster = event.caster
	local ability = event.ability
	local dummy = event.target
	StopSoundEvent("Warlord.FlameWreck.Start", dummy)
	ParticleManager:DestroyParticle(dummy.pfx, false)
	UTIL_Remove(dummy)
end