function rune_r_3(caster, ability)
	local runeUnit = caster.runeUnit3
	local runeAbility = runeUnit:FindAbilityByName("sorceress_rune_r_3")
	local abilityLevel = runeAbility:GetLevel()
	local bonusLevel = Runes:GetTotalBonus(runeUnit, "r_3")
	local totalLevel = abilityLevel + bonusLevel
	ability.rune_r_3_level = totalLevel
	if totalLevel > 0 and caster:HasModifier("modifier_ring_of_fire_up") then
		caster:RemoveModifierByName("modifier_ring_of_fire_up")
		ringOfFire(caster, ability, totalLevel)
	end
end

function ringOfFire(caster, ability, totalLevel)
	local particleName = "particles/units/heroes/hero_elder_titan/ring_of_fire.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	local origin = caster:GetAbsOrigin()
	ParticleManager:SetParticleControl(particle1, 0, origin + Vector(0, 0, 200))
	ParticleManager:SetParticleControl(particle1, 1, Vector(300, 300, 300))
	ParticleManager:SetParticleControl(particle1, 2, Vector(300, 300, 300))
	ParticleManager:SetParticleControl(particle1, 3, Vector(300, 300, 300))
	ParticleManager:SetParticleControl(particle1, 4, Vector(300, 300, 300))
	ParticleManager:SetParticleControl(particle1, 5, Vector(300, 300, 300))
	ParticleManager:SetParticleControl(particle1, 6, Vector(300, 300, 300))
	ParticleManager:SetParticleControl(particle1, 7, Vector(300, 300, 300))
	ParticleManager:SetParticleControl(particle1, 8, Vector(300, 300, 300))
	ParticleManager:SetParticleControl(particle1, 9, Vector(300, 300, 300))
	EmitSoundOn("Ability.LightStrikeArray", caster)
	--print("Ring of Fire")
	local radius = 600
	local damage = totalLevel * 200 + 300

	local d_d_level = Runes:GetTotalRuneLevel(caster, 4, "r_4", "sorceress")
	damage = damage + 0.0001 * (caster:GetStrength() + caster:GetAgility() + caster:GetIntellect()) / 10 * d_d_level * damage

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), origin, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_ring_of_fire_ignite", {duration = 4})
		end
	end
end

function ring_of_fire_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = 40 * ability.rune_r_3_level
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
end

function arcaneMissles(caster, ability, totalLevel, damage)
	local centerPoint = caster:GetAbsOrigin() + caster:GetForwardVector() * 440
	local radius = 480
	local numMissles = 1
	ability.damage = (damage * totalLevel * 0.05 + 60 + 14 * totalLevel) / numMissles
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), centerPoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			local info =
			{
				Target = enemy,
				Source = caster,
				Ability = ability,
				EffectName = "particles/units/heroes/hero_leshrac/leshrac_base_attack.vpcf",
				StartPosition = "attach_staff_tip",
				bDrawsOnMinimap = false,
				bDodgeable = true,
				bIsAttack = false,
				bVisibleToEnemies = true,
				bReplaceExisting = false,
				flExpireTime = GameRules:GetGameTime() + 4,
				bProvidesVision = false,
				iVisionRadius = 0,
				iMoveSpeed = 800,
			iVisionTeamNumber = caster:GetTeamNumber()}
			for i = 1, numMissles, 1 do
				projectile = ProjectileManager:CreateTrackingProjectile(info)
				Timers:CreateTimer(0.15 * i, function()
					projectile = ProjectileManager:CreateTrackingProjectile(info)
				end)
			end
			-- ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
		end
	end
end

function missleStrike(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	ApplyDamage({victim = target, attacker = caster, damage = ability.damage, damage_type = DAMAGE_TYPE_MAGICAL})
	if ability.rune_w_2_level > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_sorceress_rune_w_2_invisible", {duration = 9})
		ability:ApplyDataDrivenModifier(caster, target, "modifier_sorceress_rune_w_2", {duration = 9})
		local newStacks = math.min(target:GetModifierStackCount("modifier_sorceress_rune_w_2", caster) + 1, 10)
		target:SetModifierStackCount("modifier_sorceress_rune_w_2", ability, newStacks)
		target:SetModifierStackCount("modifier_sorceress_rune_w_2_invisible", ability, newStacks * ability.rune_w_2_level)
	end
end

function start_arcane_torrent_channel(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	ability.target = target
	ability.w_1_level = Runes:GetTotalRuneLevel(caster, 1, "w_1", "sorceress")
	ability.w_2_level = Runes:GetTotalRuneLevel(caster, 2, "w_2", "sorceress")
	ability.w_4_level = Runes:GetTotalRuneLevel(caster, 4, "w_4", "sorceress")
	rune_w_1(caster, ability, 0)
	local arcane_explosion_damage = caster:FindAbilityByName("arcane_explosion"):GetLevelSpecialValueFor("damage", ability:GetLevel())
	ability.base_damage = arcane_explosion_damage * 10
end

function arcane_torrent_channel_end(event)
end

function arcane_torrent_channel_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = ability.target
	rune_w_1(caster, ability, 0)
	EmitSoundOn("Sorceress.ArcaneTorrentLaunch", caster)
	local info =
	{
		Target = target,
		Source = caster,
		Ability = ability,
		EffectName = "particles/units/heroes/hero_leshrac/leshrac_base_attack.vpcf",
		StartPosition = "attach_staff_tip",
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 5,
		bProvidesVision = false,
		iVisionRadius = 0,
		iMoveSpeed = 800,
	iVisionTeamNumber = caster:GetTeamNumber()}

	local manaDrainPercent = 0.0033
	if ability.w_4_level > 0 then
		manaDrainPercent = 0.02
	end
	local manaDrain = math.min(caster:GetMaxMana() * manaDrainPercent, caster:GetMana())
	manaDrain = math.floor(manaDrain)
	caster:ReduceMana(manaDrain)
	ability.damage = ability.base_damage + (manaDrain / 100) * 0.003 * ability.w_4_level * ability.base_damage

	projectile = ProjectileManager:CreateTrackingProjectile(info)
	if WallPhysics:GetDistance(caster:GetAbsOrigin(), target:GetAbsOrigin()) > 1800 then
		caster:RemoveModifierByName("modifier_channel_arcane_torrent")
	end
	local w_4_level = Runes:GetTotalRuneLevel(caster, 4, "w_4", "sorceress")
	if w_4_level > 0 then
		local currentStacks = caster:GetModifierStackCount("modifier_arcane_enchantment", caster)
		local manaDrain = 0
		if currentStacks < 3 then
			manaDrain = caster:GetMaxMana() * 0.1 * addedStacks
			caster:ReduceMana(manaDrain)
		end
		local blinkAbility = caster:FindAbilityByName("sorceress_blink")
		blinkAbility.w_4_amp = ((caster:GetMaxMana() * 0.1) / 100) * SORCERESS_D_B_FACTOR * w_4_level
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_arcane_enchantment", {duration = 7})
		caster:SetModifierStackCount("modifier_arcane_enchantment", caster, math.min(3, currentStacks + 1))
	end
end

function arcane_torrent_projectile_hit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local damage = ability.damage
	if ability.w_2_level > 0 then
		-- local arcane_explosion = caster:FindAbilityByName("arcane_explosion")
		ability:ApplyDataDrivenModifier(caster, target, "modifier_sorceress_rune_w_2_invisible", {duration = 9})
		ability:ApplyDataDrivenModifier(caster, target, "modifier_sorceress_rune_w_2", {duration = 9})
		local newStacks = math.min(target:GetModifierStackCount("modifier_sorceress_rune_w_2", caster) + 1, 10)
		target:SetModifierStackCount("modifier_sorceress_rune_w_2", ability, newStacks)
		target:SetModifierStackCount("modifier_sorceress_rune_w_2_invisible", ability, newStacks * ability.w_2_level)
	end
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_ARCANE, RPC_ELEMENT_NONE)
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_oracle/duskbringer_c_a_heal_heal_core.vpcf", target, 0.5)

end

function arcane_enhancement_impact(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	EmitSoundOn("Hero_SkywrathMage.ArcaneBolt.Impact", target)
	if ability.w_4_damage then

		local radius = 280
		if ability.baseIndex == 4 then
			radius = 480
		end
		local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
		local particle2 = ParticleManager:CreateParticle(particleNameS, PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(particle2, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle2, 1, Vector(radius, radius, radius))
		ParticleManager:SetParticleControl(particle2, 2, Vector(2.0, 2.0, 2.0))
		ParticleManager:SetParticleControl(particle2, 4, Vector(255, 90, 255))
		Timers:CreateTimer(1.5, function()
			ParticleManager:DestroyParticle(particle2, false)
		end)
		local damage = ability.w_4_damage * ability.w_4_amp
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, ability.baseIndex, RPC_ELEMENT_ARCANE, RPC_ELEMENT_NONE)
			end
		end
	end
	--print("ARCANE ENHANCEMENT IMPACT")
end
