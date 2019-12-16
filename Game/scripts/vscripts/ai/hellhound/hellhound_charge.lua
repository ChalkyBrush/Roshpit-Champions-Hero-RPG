function begin_prepare(event)
	EmitSoundOn("n_creep_Thunderlizard_Big.Roar", event.caster)
	local caster = event.caster
	StartAnimation(caster, {duration = 1.8, activity = ACT_DOTA_RUN, rate = 3})
end

function preparing_think(event)
	local caster = event.caster
	local ability = event.ability
	--StartAnimation(caster, {duration=1.5, activity=ACT_DOTA_RUN, rate=3})
end

function begin_charge(event)
	local caster = event.caster
	local ability = event.ability
	local fv = caster:GetForwardVector()
	ability.fv = fv
end

function charge_think(event)
	local caster = event.caster
	local ability = event.ability
	local origin = caster:GetAbsOrigin()
	local newPos = origin + ability.fv * 40
	local groundPos = GetGroundPosition(newPos, caster)
	if groundPos.z - origin.z > 100 or groundPos.z - origin.z < -100 then
		caster:SetAbsOrigin(groundPos - ability.fv * 80)
		caster:RemoveModifierByName("modifier_hellhound_charging")
	else
		caster:SetAbsOrigin(groundPos)
	end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), newPos, nil, 100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		local modifierKnockback =
		{
			center_x = origin.x,
			center_y = origin.y,
			center_z = origin.z,
			duration = 0.2,
			knockback_duration = 0.2,
			knockback_distance = 120,
			knockback_height = 90,
		}

		for _, enemy in pairs(enemies) do
			if not enemy:HasModifier("modifier_stunned") then
				local damage = event.damage
				ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR})
				enemy:AddNewModifier(caster, nil, "modifier_knockback", modifierKnockback)
				--enemy:AddNewModifier(caster, nil, "modifier_stunned", {duration = 0.5})
				EmitSoundOn("Roshan.Bash", enemy)
			end
		end
		local modifierKnockbackCaster =
		{
			center_x = newPos.x,
			center_y = newPos.y,
			center_z = newPos.z,
			duration = 0.6,
			knockback_duration = 0.6,
			knockback_distance = 300,
			knockback_height = 90,
		}
		caster:RemoveModifierByName("modifier_hellhound_charging")
		Timers:CreateTimer(0.05, function()
			caster:AddNewModifier(enemies[1], nil, "modifier_knockback", modifierKnockbackCaster)
		end)

	end
end

function charge_end(event)
	FindClearSpaceForUnit(event.caster, event.caster:GetAbsOrigin(), true)
	EmitSoundOn("Roshan.Grunt", event.caster)
end
