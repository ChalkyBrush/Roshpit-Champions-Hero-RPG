
require('/heroes/legion_commander/mountain_protector_constants')
function begin_mystic_wave(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	local range = event.range
	Filters:CastSkillArguments(1, caster)
	if caster:HasModifier("modifier_mountain_protector_glyph_1_1") then
		local currentCD = ability:GetCooldownTimeRemaining()
		ability:EndCooldown()
		local newCD = currentCD - 1
		ability:StartCooldown(newCD)
	end
	EmitSoundOn("MysticAssasin.MysticWaveYell2", caster)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "MysticAssasin.MysticWave", caster)
	local fv = ((target - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	local startPoint = caster:GetAbsOrigin()
	local particle = "particles/roshpit/mystic_assassin/mystic_wave.vpcf"
	local start_radius = 340
	local end_radius = 340
	local range = range
	local q_4_level = Runes:GetTotalRuneLevel(caster, 4, "q_4", "mountain_protector")
	if q_4_level > 0 then
		range = range + MOUNTAIN_PROTECTOR_Q4_DIST * q_4_level
	end
	ability.q_4_level = q_4_level
	ability.e_3_amp = 0
	if caster:HasModifier("modifier_emberstone_wave") then
		local c_c_level = Runes:GetTotalRuneLevel(caster, 3, "e_3", "mountain_protector")
		caster:RemoveModifierByName("modifier_emberstone_wave")
		ability.e_3_amp = MOUNTAIN_PROTECTOR_E3_AMP_PCT/100 * c_c_level
		particle = "particles/roshpit/mystic_assassin/protector_shockwave_red.vpcf"
	end
	local speed = MOUNTAIN_PROTECTOR_Q_SPEED

	-- EmitSoundOn("Hero_TrollWarlord.PreAttack", caster)

	local casterOrigin = caster:GetAbsOrigin()

	local info =
	{
		Ability = ability,
		EffectName = particle,
		vSpawnOrigin = startPoint + Vector(0, 0, 80),
		fDistance = range,
		fStartRadius = start_radius,
		fEndRadius = end_radius,
		Source = caster,
		StartPosition = "attach_attack1",
		bHasFrontalCone = true,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
		vVelocity = fv * speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)

	if caster:HasModifier("modifier_mountain_protector_glyph_4_1") then
		local luck = RandomInt(1, 100/MOUNTAIN_PROTECTOR_GLYPH_4_1_Q_MULTICAST_CHANCE)
		if luck == 4 then
			Timers:CreateTimer(0.4, function()
				StartAnimation(caster, {duration = 0.8, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1.3})
				EmitSoundOn("MysticAssasin.MysticWaveYell2", caster)
				local fv = caster:GetForwardVector()
				local startPoint = caster:GetAbsOrigin()
				local info =
				{
					Ability = ability,
					EffectName = particle,
					vSpawnOrigin = startPoint + Vector(0, 0, 80),
					fDistance = range,
					fStartRadius = start_radius,
					fEndRadius = end_radius,
					Source = caster,
					StartPosition = "attach_attack1",
					bHasFrontalCone = true,
					bReplaceExisting = false,
					iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
					iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
					iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					fExpireTime = GameRules:GetGameTime() + 5.0,
					bDeleteOnHit = false,
					vVelocity = fv * speed,
					bProvidesVision = false,
				}
				projectile = ProjectileManager:CreateLinearProjectile(info)
			end)
		end
	end

	local q_1_level = Runes:GetTotalRuneLevel(caster, 1, "q_1", "mountain_protector")
	if q_1_level > 0 then
		local a_a_duration = Filters:GetAdjustedBuffDuration(caster, MOUNTAIN_PROTECTOR_Q1_MS_BUFF_DUR, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_mountain_protector_a_a_buff", {duration = a_a_duration})
		caster:SetModifierStackCount("modifier_mountain_protector_a_a_buff", caster, q_1_level)
	end
	ability.q_1_level = q_1_level
	ability.q_2_level = Runes:GetTotalRuneLevel(caster, 2, "q_2", "mountain_protector")
	ability.q_3_level = Runes:GetTotalRuneLevel(caster, 3, "q_3", "mountain_protector")
	if caster:HasModifier("modifier_energy_channel") then
		local manaCost = caster:GetMaxMana() * 0.01 * ability:GetLevel()
		caster:ReduceMana(manaCost)
	end
end

function mystic_wave_impact(event)
	local caster = event.caster
	local target = event.target
	local damage = event.damage
	local baseDamage = damage
	local ability = event.ability
	local stunDuration = 0.5
	local procs = Runes:Procs(ability.q_3_level, MOUNTAIN_PROTECTOR_Q3_MULTI_HIT_CHANCE, 1)
	for i = 0, procs, 1 do
		Timers:CreateTimer(i * 0.2, function()
			local damage = baseDamage
			if target:IsAlive() then
				local q_4_level = ability.q_4_level
				if q_4_level > 0 then
					local luck = RandomInt(1, 100)
					if luck <= q_4_level * MOUNTAIN_PROTECTOR_Q4_MAGIC_BREAK_CHANCE then
						Filters:MagicImmuneBreak(caster, target)
					end
				end
				if caster:HasModifier("modifier_mountain_protector_immortal_weapon_1") then
					stunDuration = stunDuration + MOUNTAIN_PROTECTOR_IMMORTAL_WEAPON_1_Q_STUN_DURATION_INCREASE
				end
				if target:HasModifier("modifier_mountain_protector_q_2_invisible") then
					local stacks = target:GetModifierStackCount("modifier_mountain_protector_q_2_invisible", caster)
					--print("---ORIG DAMAGE:---")
					--print(damage)
					damage = damage + damage * MOUNTAIN_PROTECTOR_Q2_DMG_PCT/100 * stacks
					--print("STACKS:")
					--print(stacks)
					--print("NEW DAMAGE:")
					--print(damage)
					--print("--------------")
				end
				if ability.e_3_amp > 0 then
					damage = damage + damage * ability.e_3_amp
				end
				ability:ApplyDataDrivenModifier(caster, target, "modifier_mystic_wave_flail", {duration = stunDuration})
				if target:IsMagicImmune() then
				else
					Filters:ApplyStun(caster, stunDuration, target)
					local particleName = "particles/econ/events/ti5/dagon_lvl2_ti5.vpcf"
					local pfx = ParticleManager:CreateParticle(particleName, PATTACH_POINT, target)
					ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
					Timers:CreateTimer(1.0, function()
						ParticleManager:DestroyParticle(pfx, false)
					end)
					EmitSoundOn("MysticAssasin.MysticWave.Impact", target)
					if ability.q_2_level > 0 then
						local q_2_duration = Filters:GetAdjustedBuffDuration(caster, MOUNTAIN_PROTECTOR_Q2_DUR, false)
						ability:ApplyDataDrivenModifier(caster, target, "modifier_mountain_protector_q_2_visible", {duration = q_2_duration})
						local currentStacks = target:GetModifierStackCount("modifier_mountain_protector_q_2_visible", caster)
						local newStacks = math.min(currentStacks + MOUNTAIN_PROTECTOR_Q2_STACKS_PER_HIT, MOUNTAIN_PROTECTOR_Q2_MAX_STACKS)
						target:SetModifierStackCount("modifier_mountain_protector_q_2_visible", caster, newStacks)
						ability:ApplyDataDrivenModifier(caster, target, "modifier_mountain_protector_q_2_invisible", {duration = q_2_duration})
						target:SetModifierStackCount("modifier_mountain_protector_q_2_invisible", caster, newStacks * ability.q_2_level)
					end
					if ability.q_1_level > 0 then
						ability:ApplyDataDrivenModifier(caster, target, "modifier_mountain_protector_q_1_daze", {duration = MOUNTAIN_PROTECTOR_Q1_MS_DEBUFF_DUR})
						target:SetModifierStackCount("modifier_mountain_protector_q_1_daze", caster, ability.q_1_level)
					end
				end
				Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_Q, RPC_ELEMENT_NORMAL, RPC_ELEMENT_EARTH)

			end
		end)
	end

end
