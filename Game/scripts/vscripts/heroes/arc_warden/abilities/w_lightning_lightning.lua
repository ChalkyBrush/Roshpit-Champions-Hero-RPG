require('heroes/arc_warden/abilities/onibi')

function jex_lightning_lightning_attack_land(event)
	local caster = event.caster
	local attacker = event.attacker
	local ability = event.ability
	local target = event.target
	local drain_mana = event.drain_mana
	local damage_mult = event.damage_mult
	local jumps_per_tech = event.jumps_per_tech
	if caster:GetMana() >= drain_mana then
	else
		ability:ToggleAbility()
	end
	caster:ReduceMana(drain_mana)
	local max_targets = ability.tech_level * jumps_per_tech
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false)
	local targets_to_hit = math.min(#enemies, max_targets)
	local damage = OverflowProtectedGetAverageTrueAttackDamage(attacker) * (damage_mult / 100)
	local w_4_level = caster:GetRuneValue("w", 4)
	if w_4_level > 0 then
		damage = damage + caster:GetAgility() * event.w_4_agility_added_to_lightning_damage
	end
	for i = 1, targets_to_hit, 1 do
		Timers:CreateTimer((i - 1) * 0.15, function()
			local enemy = enemies[i]
			if IsValidEntity(enemy) and enemy:IsAlive() then
				EmitSoundOn("Jex.Thundershroom.Lightning", enemy)
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
				local particleName = "particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf"
				local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_CUSTOMORIGIN, nil)
				local attach_unit_1 = target
				if i > 1 then
					attach_unit_1 = enemies[i - 1]
				end
				ParticleManager:SetParticleControl(pfx, 0, attach_unit_1:GetAbsOrigin() + Vector(0, 0, attach_unit_1:GetBoundingMaxs().z + 40))
				ParticleManager:SetParticleControl(pfx, 1, enemy:GetAbsOrigin() + Vector(0, 0, enemy:GetBoundingMaxs().z + 60))
				Timers:CreateTimer(0.3, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)
			end
		end)
	end
	Filters:CastSkillArguments(2, caster)
end

function jex_lightning_lightning_toggled_on(event)
	local caster = event.caster
	local ability = event.ability
	ability.tech_level = onibi_get_total_tech_level(caster, "lightning", "lightning", "W")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_jex_vortex_w_attack_dmg", {})
	caster:SetModifierStackCount("modifier_jex_vortex_w_attack_dmg", caster, ability.tech_level)
	EmitSoundOn("Jex.VortexWeaponActivate", caster)
	StartAnimation(caster, {duration = 0.3, activity = ACT_DOTA_OVERRIDE_ABILITY_4, rate = 1.5})
end

function jex_lightning_lightning_toggled_off(event)
	local caster = event.caster
	local ability = event.ability
	caster:RemoveModifierByName("modifier_jex_vortex_w_attack_dmg")
end
