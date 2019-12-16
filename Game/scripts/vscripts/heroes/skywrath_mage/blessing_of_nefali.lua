require("/heroes/skywrath_mage/sephyr_constants")

function start_channel(event)
	local caster = event.caster
	local ability = event.ability
	StartSoundEvent("Sephyr.Blessing", caster)
	if not ability.castIndex then
		ability.castIndex = 0
	end
	EndAnimation(caster)
	StartSoundEvent("Sephyr.Blessing.Channel", caster)
	ability.castIndex = ability.castIndex + 1
	local castIndex = ability.castIndex
	local radius = event.radius
	if caster:HasModifier("modifier_sephyr_glyph_3_1") then
		radius = radius + SEPHYR_GLYPH_3_1_R_BONUS_RADIUS
	end
	Timers:CreateTimer(0.45, function()
		if castIndex == ability.castIndex and caster:HasModifier("modifier_nefali_channel") then
			if caster:HasModifier("modifier_strafe_sprinting") then
				caster:RemoveModifierByName("modifier_strafe_sprinting")
			end
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
			ability.pfx = ParticleManager:CreateParticle("particles/roshpit/sephyr/blessing/blessing_sphere.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(ability.pfx, 0, caster:GetAbsOrigin())
			ParticleManager:SetParticleControl(ability.pfx, 1, Vector(radius, radius, radius))
			local allyAura = "modifier_nefali_aura_ally"
			local enemyAura = "modifier_nefali_aura_enemy"
			if caster:HasModifier("modifier_sephyr_glyph_3_1") then
				allyAura = "modifier_nefali_aura_ally_glyphed"
				enemyAura = "modifier_nefali_aura_enemy_glyphed"
			end
			ability:ApplyDataDrivenModifier(caster, caster, allyAura, {duration = 8})
			local b_d_level = caster:GetRuneValue("r", 2)
			if b_d_level > 0 then
				ability:ApplyDataDrivenModifier(caster, caster, enemyAura, {duration = 8})
			end

			Filters:CastSkillArguments(4, caster)
		end
	end)
end

function channel_interrupt(event)
	local caster = event.caster
	local ability = event.ability
	StopSoundEvent("Sephyr.Blessing", caster)
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ParticleManager:ReleaseParticleIndex(ability.pfx)
		ability.pfx = false
	end
	StopSoundEvent("Sephyr.Blessing.Channel", caster)
end

function channel_end(event)
	local caster = event.caster
	local ability = event.ability
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ParticleManager:ReleaseParticleIndex(ability.pfx)
		ability.pfx = false
	end
	if caster:IsStunned() then
		Filters:CleanseStuns(caster)
		Filters:CleanseSilences(caster)
	end
	caster:RemoveModifierByName("modifier_nefali_aura_ally")
	caster:RemoveModifierByName("modifier_nefali_aura_enemy")
end

function channeling_think(event)
end

function nefali_aura_start_ally(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local a_d_level = caster:GetRuneValue("r", 1)
	if a_d_level > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_nefali_aura_health_regen", {})
		target:SetModifierStackCount("modifier_nefali_aura_health_regen", caster, a_d_level)
	end
end

function nefali_aura_end_ally(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	target:RemoveModifierByName("modifier_nefali_aura_health_regen")
end

function nefali_aura_start_enemy(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local b_d_level = caster:GetRuneValue("r", 2)
	target:SetModifierStackCount("modifier_nefali_aura_effect_enemy", caster, b_d_level)
end

function two_seconds_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local c_d_level = caster:GetRuneValue("r", 3)
	if c_d_level > 0 then
		local duration = Filters:GetAdjustedBuffDuration(caster, 10, false)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_nefali_c_d_speed", {duration = duration})
		target:SetModifierStackCount("modifier_nefali_c_d_speed", caster, c_d_level)
	end
end

function nefali_passive_think(event)
	local caster = event.caster
	local ability = event.ability
	local d_d_level = caster:GetRuneValue("r", 4)
	if d_d_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_nefali_d_d", {})
		caster:SetModifierStackCount("modifier_nefali_d_d", caster, d_d_level)
	else
		caster:RemoveModifierByName("modifier_nefali_d_d")
	end
end
