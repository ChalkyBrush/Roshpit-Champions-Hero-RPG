require("heroes/crystal_maiden/fireball")

function start_channel(event)
	local caster = event.caster
	local ability = event.ability
	StartSoundEvent("Hero_Batrider.Firefly.loop", caster)
	if caster:HasModifier("modifier_clear_cast") then
		event.noAnim = true
		begin_pyro(event)
		local pyroblast = caster:FindAbilityByName("pyroblast")
		caster:Stop()
		StartAnimation(caster, {duration = 0.3, activity = ACT_DOTA_CAST_ABILITY_1, rate = 2.4})
		EmitSoundOn("Hero_Jakiro.LiquidFire", caster)
		ability:EndCooldown()
		local cooldown = Filters:GetCDNoHood(caster, 0.7)
		ability:StartCooldown(cooldown)
	end
	if not caster:HasModifier("modifier_sorceress_immortal_fire_avatar") then
		rune_r_1(caster, ability)
	end
	ability.rune_r_2_level = rune_r_2(caster, ability)
	caster.r_4_level = caster:GetRuneValue("r", 4)
	local c_d_level = caster:GetRuneValue("r", 3)
	local point = event.target_points[1]
	if c_d_level > 0 then
		ability.r_3_particle = ParticleManager:CreateParticle("particles/roshpit/sorceress/flamestrike_indicator_portrait.vpcf", PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(ability.r_3_particle, 0, point)
		ParticleManager:SetParticleControl(ability.r_3_particle, 1, point)
		ParticleManager:SetParticleControl(ability.r_3_particle, 2, point)
	end
end

function begin_pyro(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	local fv = ((target - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	local casterOrigin = caster:GetAbsOrigin()
	StartSoundEvent("hero_jakiro.macropyre", caster)
	Timers:CreateTimer(1.5, function()
		StopSoundEvent("hero_jakiro.macropyre", caster)
	end)
	if event.noAnim then
		local luck = RandomInt(1, 3)
		if luck == 1 then
			EmitSoundOn("Sorceress.PyroCastVO", caster)
		end
	else
		EmitSoundOn("Sorceress.PyroCastVO", caster)
		StartAnimation(caster, {duration = 0.5, activity = ACT_DOTA_CAST_ABILITY_1, rate = 1})
	end
	if caster:HasModifier("modifier_sorceress_immortal_fire_avatar") then
		caster = caster.origCaster
	end
	local start_radius = 200
	local end_radius = 200
	local range = event.range
	local speed = 650
	local damage = 500
	local projectileParticle = "particles/econ/items/puck/puck_alliance_set/pyroblast_aproset.vpcf"
	if caster:HasModifier("modifier_sorceress_glyph_7_1") then
		projectileParticle = "particles/econ/items/puck/puck_alliance_set/chaos_blast_aproset.vpcf"
	end
	local info =
	{
		Ability = ability,
		EffectName = projectileParticle,
		vSpawnOrigin = casterOrigin,
		fDistance = range,
		fStartRadius = start_radius,
		fEndRadius = end_radius,
		Source = caster,
		StartPosition = "attach_origin",
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
	Filters:CastSkillArguments(4, caster)

	local c_d_level = Runes:GetTotalRuneLevel(caster, 3, "r_3", "sorceress")
	if c_d_level > 0 then
		-- local d_d_level = Runes:GetTotalRuneLevel(caster, 4, "r_4", "sorceress")
		local runesCount = c_d_level
		-- damage = damage + 0.0001*(caster:GetStrength()+caster:GetAgility()+caster:GetIntellect())/10*d_d_level*damage
		sorceress_c_d(caster, target, 560, runesCount)
	end
end

function channel_end(event)
	local caster = event.caster
	StopSoundEvent("Hero_Batrider.Firefly.loop", caster)
	if caster.avatar then
		StopSoundEvent("Hero_Batrider.Firefly.loop", caster.avatar)
	end
	local ability = event.ability
	if ability.r_3_particle then
		ParticleManager:DestroyParticle(ability.r_3_particle, false)
		ability.r_3_particle = false
	end
end

function rune_r_1(caster, ability)
	local runeUnit = caster.runeUnit
	local runeAbility = runeUnit:FindAbilityByName("sorceress_rune_r_1")
	local abilityLevel = runeAbility:GetLevel()
	local bonusLevel = Runes:GetTotalBonus(runeUnit, "r_1")
	local totalLevel = caster:GetRuneValue("r", 1)
	if totalLevel > 0 and not caster:HasModifier("modifier_clear_cast") then
		local fireball = caster:FindAbilityByName("fireball")
		if not fireball then
			fireball = caster:AddAbility("fireball")
		end
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_pyro_cooldown", {duration = 17})
		fireball:SetLevel(ability:GetLevel())
		fireball:SetAbilityIndex(DOTA_R_SLOT)
		fireball.rune_r_1_level = totalLevel
		caster:SwapAbilities("pyroblast", "fireball", false, true)
		-- Timers:CreateTimer(17, function()
		-- ability:SetLevel(iceLance:GetLevel())
		-- caster:SwapAbilities("pyroblast", "fireball", true, false)
		-- end)
	end
end

function cooldownEnd(event)
	local ability = event.ability
	local caster = event.caster
	if caster:HasAbility("fireball") then
		local level = caster:FindAbilityByName("fireball"):GetLevel()
		ability:SetLevel(level)
		caster:SwapAbilities("pyroblast", "fireball", true, false)
	end
end

function rune_r_2(caster, ability)
	local totalLevel = caster:GetRuneValue("r", 2)
	return totalLevel
end

function pyroblast_impact(event)
	local ability = event.ability
	local caster = event.caster
	local stun_duration = event.stun_duration
	local target = event.target
	local damage = event.damage
	if caster:HasModifier("modifier_clear_cast") then
		if ability.e_3_amp then
			damage = damage * ability.e_3_amp
		end
	end
	if caster:HasModifier("modifier_sorceress_glyph_7_1") then
		damage = damage * SORCERESS_GLYPH_7_1_R_DAMAGE_MULTIPLIER
	end
	-- damage = damage + 0.0001*(caster:GetStrength()+caster:GetAgility()+caster:GetIntellect())/10*ability.r_4_level*damage
	local filterDamage = Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_R, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
	if ability.rune_r_2_level > 0 and filterDamage then
		applyIgnite(caster, ability, filterDamage, target, ability.rune_r_2_level, 6)
	end
	Filters:ApplyStun(caster, stun_duration, target)

end

function ignite_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = target.igniteDPS
	Filters:ApplyDotDamage(caster, ability, target, damage, DAMAGE_TYPE_MAGICAL, -2, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
end

function applyIgnite(caster, ability, damage, target, b_d_level, duration)
	local igniteDPS = damage * 0.033 * b_d_level
	if caster:HasModifier("modifier_clear_cast") then
		if ability.e_3_amp then
			igniteDPS = igniteDPS * ability.e_3_amp
		end
	end
	if target:HasModifier("modifier_pyroblast_ignite") and target.igniteDPS then
		target.igniteDPS = math.max(target.igniteDPS, igniteDPS)
	else
		target.igniteDPS = igniteDPS
	end
	ability:ApplyDataDrivenModifier(caster, target, "modifier_pyroblast_ignite", {duration = duration})
end

function pyroblast_impact_main(event)
	local target = event.target
	local caster = event.caster
	local particleName = "particles/units/heroes/hero_warlock/warlock_rain_of_chaos.vpcf"
	if caster:HasModifier("modifier_sorceress_glyph_7_1") then
		particleName = "particles/units/heroes/hero_warlock/chaos_blast_impact.vpcf"
	end
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(pfx, 1, Vector(300, 300, 300))
	Timers:CreateTimer(2.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
end
