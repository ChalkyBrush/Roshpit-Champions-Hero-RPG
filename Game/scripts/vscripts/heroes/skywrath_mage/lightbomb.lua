function lightbomb_precast(event)
	local caster = event.caster
	local ability = event.ability
	-- if caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster) > 30 then
	-- caster:Stop()
	-- -- MOVE TO ORDER FILTER?
	-- end
	if ability.pfx then
		ParticleManager:SetParticleControl(ability.pfx, 1, ability.target_point)
		ParticleManager:SetParticleControl(ability.pfx, 2, Vector(1500, 1500, 1500))
		ability.pfx = false
	end
	local rate = 0.6 / math.max(ability:GetCastPoint(), 0.1)
	StartAnimation(caster, {duration = 1.6, activity = ACT_DOTA_CAST_ABILITY_4, rate = rate})
	ability.target_point = event.target_points[1]

	local pfx = ParticleManager:CreateParticle("particles/roshpit/sephyr/lightbomb_projectile.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ability.position = caster:GetAbsOrigin() + caster:GetForwardVector() * 110 + Vector(0, 0, caster:GetModifierStackCount("modifier_z_flight", caster)) + Vector(0, 0, 100)
	ParticleManager:SetParticleControl(pfx, 0, ability.position)
	ParticleManager:SetParticleControl(pfx, 1, ability.position)
	ParticleManager:SetParticleControl(pfx, 2, Vector(900, 900, 900))
	ability.pfx = pfx
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_lightbomb_start_cast", {duration = ability:GetCastPoint()})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_z_flight", {})

	local flash = CustomAbilities:QuickParticleAtPoint("particles/roshpit/sephyr/lb_flash.vpcf", ability.position - Vector(0, 0, 80), 1)
	-- ParticleManager:SetParticleControl(flash, 1, ability.position)
	if ability.ogFV and caster:HasModifier("modifier_strafe_toggle") then
		local strafe = caster:FindAbilityByName("sephyr_strafe")
		strafe.fvLock = ability.ogFV
		ability.ogFV = nil
	end
	ability.sound = true
	ability.sound2 = true
	local luck = 1
	if luck == 1 then
		EmitSoundOn("Sephyr.Lightbomb.VO.Start", caster)
	end
	EmitSoundOn("Sephyr.Lightbomb.Start", caster)
	EmitSoundOn("Sephyr.Lightbomb.Start2", caster)
end

function flying_think(event)
	local caster = event.caster
	local ability = event.ability
	local currentStacks = caster:GetModifierStackCount("modifier_z_flight", caster)
	local newStacks = 0
	if caster:HasModifier("modifier_lightbomb_start_cast") then
		newStacks = math.min(currentStacks + 25, 600)
		if newStacks == 125 then
			EmitSoundOn("Sephyr.Lightbomb.Spark", caster)
		end
		if newStacks > 200 then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_flying_cant_be_attacked", {duration = 0.5})
		end
		caster:SetModifierStackCount("modifier_z_flight", caster, newStacks)

		local position = caster:GetAbsOrigin() + caster:GetForwardVector() * 110 + Vector(0, 0, newStacks) + Vector(0, 0, 100)
		ParticleManager:SetParticleControl(ability.pfx, 1, position)

		if caster:HasModifier("modifier_strafe_toggle") then
			local strafe = caster:FindAbilityByName("sephyr_strafe")

			local towardPoint = ((ability.target_point - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
			local angDiff = AngleDiff(WallPhysics:vectorToAngle(caster:GetForwardVector()), WallPhysics:vectorToAngle(towardPoint))
			if angDiff > 2 or angDiff < -2 then
				strafe.fvLock = WallPhysics:rotateVector(strafe.fvLock, (2 * math.pi * ability.rotation / 10000))
			end
		end
	else
		if ability.sound2 then
			EmitSoundOn("Sephyr.Lightbomb.HitDown", caster)
			ability.sound2 = false
		end
		if ability.pfx then
			ParticleManager:SetParticleControl(ability.pfx, 1, ability.target_point)
		end
		newStacks = currentStacks - 35
		if newStacks <= 3 then
			caster:RemoveModifierByName("modifier_z_flight")
			caster:RemoveModifierByName("modifier_flying_cant_be_attacked")
		else
			if newStacks <= 200 then
				caster:RemoveModifierByName("modifier_flying_cant_be_attacked")
			end
			caster:SetModifierStackCount("modifier_z_flight", caster, newStacks)
		end
	end
end

function lightbomb_precancel(event)
	local caster = event.caster
	local ability = event.ability
	EndAnimation(caster)
	caster:RemoveModifierByName("modifier_lightbomb_start_cast")
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ParticleManager:ReleaseParticleIndex(ability.pfx)
		ability.pfx = false
	end
	if ability.ogFV and caster:HasModifier("modifier_strafe_toggle") then
		local strafe = caster:FindAbilityByName("sephyr_strafe")
		strafe.fvLock = ability.ogFV
		ability.ogFV = nil
	end
end

function lightbomb_cast(event)
	local caster = event.caster
	local ability = event.ability
	if ability.sound then
		ability.sound = false
		local luck = 1
		if luck == 1 then
			EmitSoundOn("Sephyr.Lightbomb.VO.Hit", caster)
		end
	end
	if ability.beamPFX then
		ParticleManager:DestroyParticle(ability.beamPFX, false)
		ParticleManager:ReleaseParticleIndex(ability.beamPFX)
		ability.beamPFX = false
	end
	if caster:HasModifier("modifier_strafe_toggle") then
		local strafe = caster:FindAbilityByName("sephyr_strafe")
		strafe.fvLock = ((ability.target_point - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	end
	ability.speed = 1500
	ParticleManager:SetParticleControl(ability.pfx, 1, ability.target_point)
	ParticleManager:SetParticleControl(ability.pfx, 2, Vector(ability.speed, ability.speed, ability.speed))
	local destPFX = ability.pfx
	local bombPos = ability.target_point
	local distance = WallPhysics:GetDistance(caster:GetAbsOrigin() + Vector(0, 0, caster:GetModifierStackCount("modifier_z_flight", caster)), ability.target_point)
	Timers:CreateTimer(distance / ability.speed - 0.5, function()
		EmitSoundOnLocationWithCaster(bombPos, "Sephyr.Lightbomb.Explosion", caster)
	end)

	local damage = event.base_damage + event.int_damage * caster:GetIntellect()
	local stun_duration = event.stun_duration
	local q_2_level = caster:GetRuneValue("q", 2)
	Timers:CreateTimer(distance / ability.speed - 0.03, function()
		EmitSoundOnLocationWithCaster(bombPos, "Sephyr.Lightbomb.ImpactFlare", caster)
		ParticleManager:DestroyParticle(destPFX, false)
		local expPFX = CustomAbilities:QuickParticleAtPoint("particles/roshpit/sephyr/lightbomb/lightbomb_explosion.vpcf", bombPos, 6)
		ParticleManager:SetParticleControl(expPFX, 1, Vector(500, 500, 500))
		ParticleManager:SetParticleControl(expPFX, 3, bombPos)

		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), bombPos, nil, 480, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PURE, BASE_ABILITY_Q, RPC_ELEMENT_HOLY, RPC_ELEMENT_WIND)
				if q_2_level > 0 then
					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_lightbomb_postmit", {duration = 7})
					enemy:SetModifierStackCount("modifier_lightbomb_postmit", caster, q_2_level)
				end
			end
		end
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), bombPos, nil, 480, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				if caster:HasModifier("modifier_sephyr_glyph_5_1") then
					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_lightbomb_freeze", {duration = 1.4})
					Timers:CreateTimer(1.4, function()
						Filters:ApplyStun(caster, stun_duration, enemy)
					end)
				else
					Filters:ApplyStun(caster, stun_duration, enemy)
				end
			end
		end
	end)

	local q_1_level = caster:GetRuneValue("q", 1)
	if q_1_level > 0 then
		local buffDuration = Filters:GetAdjustedBuffDuration(caster, 12, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_lightbomb_q_1", {duration = buffDuration})
		caster:SetModifierStackCount("modifier_lightbomb_q_1", caster, q_1_level)
	end
	local q_3_level = caster:GetRuneValue("q", 3)
	if q_3_level > 0 then
		local freeStacks = caster:GetModifierStackCount("modifier_lightbomb_freecast", caster)
		if freeStacks >= 10 then
			caster:SetModifierStackCount("modifier_lightbomb_freecast", caster, freeStacks - 10)
			ability:EndCooldown()
		else
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_lightbomb_freecast", {})
			caster:SetModifierStackCount("modifier_lightbomb_freecast", caster, freeStacks + q_3_level)
		end
	end
	Filters:CastSkillArguments(1, caster)
end

function sephyr_passive_think(event)
	local caster = event.caster
	local ability = event.ability
	local q_4_level = caster:GetRuneValue("q", 4)
	if q_4_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_sephyr_holy_amp", {})
		caster:SetModifierStackCount("modifier_sephyr_holy_amp", caster, q_4_level)

		local damageDealt = 10000
		local damageHOLY = Filters:ElementalDamage(Events.GameMaster, caster, damageDealt * 100, DAMAGE_TYPE_PURE, 0, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE, false)
		local holyAmp = math.floor(damageHOLY / damageDealt)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_sephyr_d_d_attack_damage", {})
		local attack_percent = (holyAmp / 200) * q_4_level
		caster:SetModifierStackCount("modifier_sephyr_d_d_attack_damage", caster, attack_percent)
	else
		caster:RemoveModifierByName("modifier_sephyr_d_d_attack_damage")
		caster:RemoveModifierByName("modifier_sephyr_holy_amp")
	end

end

function glyph_7_1_think(event)
	local caster = event.target
	local ability = event.ability
	local distance = caster:GetAbsOrigin().z + caster:GetModifierStackCount("modifier_z_flight", caster) - GetGroundHeight(caster:GetAbsOrigin(), caster)
	if distance >= 380 then
		ability:ApplyDataDrivenModifier(event.caster, caster, "modifier_black_King_bar_immunity", {duration = 1})
	else
		caster:RemoveModifierByName("modifier_black_King_bar_immunity")
	end
end
