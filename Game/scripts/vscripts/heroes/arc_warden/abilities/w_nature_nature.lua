require('heroes/arc_warden/abilities/onibi')

function jex_root_weave_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	Filters:CastSkillArguments(2, caster)
	local radius = event.radius
	local base_root_duration = event.base_root_duration
	local root_per_tech_level = event.root_per_tech_level
	local all_attributes_added_to_damage = event.all_attributes_added_to_damage
	local damage_per_tick = event.damage_per_tick
	local attack_power_added_to_tick_per_tech = event.attack_power_added_to_tick_per_tech
	local tech_level = onibi_get_total_tech_level(caster, "nature", "nature", "W")

	ability.tick_damage = damage_per_tick + all_attributes_added_to_damage * (caster:GetStrength() + caster:GetAgility() + caster:GetIntellect() + caster:GetSpirit()) + OverflowProtectedGetAverageTrueAttackDamage(caster) * (attack_power_added_to_tick_per_tech / 100) * tech_level
	local q_4_level = caster:GetRuneValue("q", 4)
	if q_4_level > 0 then
		ability.tick_damage = ability.tick_damage + ability.tick_damage * (event.q_4_damage_increase_pct / 100) * q_4_level
	end
	local root_duration = base_root_duration + root_per_tech_level * tech_level
	Timers:CreateTimer(0.1, function()
		local sound = false
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				if enemy.dummy or enemy:HasModifier("modifier_jex_root_immunity") then
				else
					sound = true
					Timers:CreateTimer(0.4, function()
						ability:ApplyDataDrivenModifier(caster, enemy, "modifier_jex_root_weave_debuff", {duration = root_duration})
						ability:ApplyDataDrivenModifier(caster, enemy, "modifier_jex_root_immunity", {duration = root_duration + 3})
					end)
				end
				-- Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
			end
		end
		if sound then
			EmitSoundOnLocationWithCaster(target, "Jex.Roots", caster)
		end
	end)

	EmitSoundOnLocationWithCaster(target, "Jex.RootsCast", caster)
	local particleName = "particles/roshpit/jex/root_weave.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, target)
	ParticleManager:SetParticleControl(pfx, 2, target)
	ParticleManager:SetParticleControl(pfx, 6, Vector(radius, radius, radius))
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
end

function jex_root_damage_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local damage = ability.tick_damage
	Filters:ApplyDotDamage(caster, ability, target, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_NATURE, RPC_ELEMENT_NONE)
end
