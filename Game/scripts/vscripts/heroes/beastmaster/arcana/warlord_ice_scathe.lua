function ice_scathe_pre(event)
	local caster = event.caster
	local ability = event.ability
	StartAnimation(caster, {duration = 1.0, activity = ACT_DOTA_CAST_ABILITY_1, rate = 1.5})
	EmitSoundOn("Warlord.IceScathe.Pre", caster)
end

function ice_scathe_start(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	local particleName = "particles/econ/items/ancient_apparition/ancient_apparation_ti8/ancient_ice_vortex_ti8.vpcf"
	local radius = event.radius

	local duration = event.main_aoe_duration
	local dummy = CreateUnitByName("npc_dummy_unit", point, false, nil, nil, caster:GetTeamNumber())
	dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
	ability:ApplyDataDrivenModifier(caster, dummy, "modifier_ice_scathe_thinker", {duration = duration})
	dummy.pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(dummy.pfx, 0, dummy:GetAbsOrigin()+Vector(0,0,35))
	ParticleManager:SetParticleControl(dummy.pfx, 5, Vector(radius, radius, radius))

	EmitSoundOnLocationWithCaster(point, "Warlord.IceScathe.Start", caster)

	
	Filters:CastSkillArguments(1, caster)
	if caster:HasModifier("modifier_ice_scathe_freecast") then
		ability:EndCooldown()
		local stacks = caster:GetModifierStackCount("modifier_ice_scathe_freecast", caster)
		local new_stacks = stacks -1
		if new_stacks > 0 then
			caster:SetModifierStackCount("modifier_ice_scathe_freecast", caster, new_stacks)
		else
			caster:RemoveModifierByName("modifier_ice_scathe_freecast")
		end
	end
end

function ice_scathe_thinker_end(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	ParticleManager:DestroyParticle(target.pfx, false)
	ParticleManager:ReleaseParticleIndex(target.pfx)
	UTIL_Remove(target)
end

function walk_into_ice_scathe(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	if target:GetTeamNumber() == caster:GetTeamNumber() then
		-- hero effect
	else
		local delay = event.freeze_delay
		ability:ApplyDataDrivenModifier(caster, target, "modifier_ice_scathe_countdown", {duration = delay})
		ability:ApplyDataDrivenModifier(caster, target, "modifier_in_ice_scathe_enemy", {})
	end
end

function walk_out_of_ice_scathe(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	target:RemoveModifierByName("modifier_in_ice_scathe_enemy")
	if target:GetTeamNumber() == caster:GetTeamNumber() then
		-- hero effect
	else
		-- ability:ApplyDataDrivenModifier(handle source, handle target, string modifier_name, handle modifierArgs)
	end
end

function ice_scathe_countdown_end(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	Timers:CreateTimer(0.03, function()
		if target:HasModifier("modifier_ice_scathe_effect_application") then
			ice_scathe_pop(event)			
		end
	end)
end

function ice_scathe_pop(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local particleName = "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf"
	local radius = event.freeze_pop_aoe
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, nil)
	local origin = target:GetAbsOrigin()
	ParticleManager:SetParticleControl(particle1, 0, origin + Vector(0, 0, 20))
	ParticleManager:SetParticleControl(particle1, 1, Vector(radius, 1, 1000))
	ParticleManager:SetParticleControl(particle1, 3, Vector(500, 500, 500))
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)

	local damage = event.base_damage
	damage = damage + event.int_mult*caster:GetIntellect()
	local freeze_duration = event.freeze_duration
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_Q, RPC_ELEMENT_ICE, RPC_ELEMENT_DRAGON)
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_ice_scathe_freeze", {duration = freeze_duration})
		end
	end
	EmitSoundOnLocationWithCaster(origin, "Warlord.IceScathe.Pop", caster)
end

function ice_scathe_passive_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	caster:ApplyAndIncrementStack(ability, caster, "modifier_ice_scathe_freecast", 1, 2, 0)
	
end