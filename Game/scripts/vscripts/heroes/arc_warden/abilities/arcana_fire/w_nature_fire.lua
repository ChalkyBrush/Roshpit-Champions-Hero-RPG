require('heroes/arc_warden/abilities/onibi')

function jex_living_bomb_cast(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	ability:ApplyDataDrivenModifier(caster, target, "modifier_jex_living_bomb", {duration = 2})
	EmitSoundOn("Jex.LivingBomb.Apply", target)
	Filters:CastSkillArguments(2, caster)
end

function jex_living_bomb_explode(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local radius = 600
	local tech_level = onibi_get_total_tech_level(caster, "nature", "fire", "W")
	local pfx = CustomAbilities:QuickParticleAtPoint("particles/roshpit/jex/jex_explode_living_bomb.vpcf", target:GetAbsOrigin(), 3)
	for i = 1, 5, 1 do
		ParticleManager:SetParticleControl(pfx, i, Vector(radius, radius, radius))
	end
	local w_4_level = caster:GetRuneValue("w", 4)
	local q_4_level = caster:GetRuneValue("q", 4)
	local damage = event.base_damage + (event.attack_damage_of_target_per_tech*OverflowProtectedGetAverageTrueAttackDamage(target))/100*tech_level + w_4_level*(target:GetMaxHealth()/100)*event.w_4_damage_increase_from_target_max_health
	local base_stun_duration = event.q_4_stun_duration*q_4_level
	EmitSoundOn("Jex.LivingBomb.Explode", target)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
			local distance_portion = 1 - (WallPhysics:GetDistance2d(enemy:GetAbsOrigin(), target:GetAbsOrigin())/radius)
			local stun_duration = base_stun_duration*distance_portion
			Filters:ApplyStun(caster, stun_duration, enemy)
		end
	end 	
end