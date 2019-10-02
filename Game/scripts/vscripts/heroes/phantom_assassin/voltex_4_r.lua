require('/heroes/phantom_assassin/voltex_constants')
LinkLuaModifier("modifier_voltex_avatar_lua", "modifiers/voltex/modifier_voltex_avatar_lua", LUA_MODIFIER_MOTION_NONE)

function voltex_static_field_onspellstart(event)
	local caster = event.caster
	local ability = event.ability
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_stormspirit/stormspirit_static_remnant.vpcf", caster, 0.03)
	StartAnimation(caster, {duration = 2.0, activity = ACT_DOTA_ATTACK_EVENT, rate = 0.38})
	if caster:HasModifier("modifier_magnet_q_4") then
		Timers:CreateTimer(0.03, function()
			ability:EndChannel(false)
		end)
	end
end

function voltex_static_field_onchannelsucceeded(event)
	local caster = event.caster
	local ability = event.ability
	local numSparks = event.num_sparks
	StartAnimation(caster, {duration = 0.8, activity = ACT_DOTA_ATTACK, rate = 1.0, translate = "loda"})
	EmitSoundOn("lina_lina_pain_06", caster)
	EmitSoundOn("lina_lina_pain_06", caster)
	EmitSoundOn("lina_lina_pain_06", caster)
	local fv = caster:GetForwardVector()
	for i = -(numSparks / 2), numSparks / 2, 1 do
		local randomNegative = RandomInt(0, 1)
		local mult = 1
		if randomNegative == 1 then
			mult = -1
		end
		local randomRadian = math.pi / RandomInt(7, 50) * mult
		local rotatedVector = WallPhysics:rotateVector(fv, randomRadian)
		voltex_static_field_create_spark(rotatedVector, event)
	end
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_stormspirit/stormspirit_static_remnant.vpcf", caster, 0.03)
	caster.e_4_level = Runes:GetTotalRuneLevel(caster, 4, "e_4", "voltex")
	Filters:CastSkillArguments(4, caster)
	voltex_rune_r_1(caster, ability)
	voltex_rune_r_3(caster)
end

function voltex_static_field_create_spark(fv, event)
	local ability = event.ability
	local caster = event.caster
	local projectileParticle = "particles/econ/items/zeus/lightning_weapon_fx/voltex_ultimmortal_lightning.vpcf"
	local projectileOrigin = caster:GetAbsOrigin() + fv * 10
	local start_radius = 140
	local end_radius = 140
	local range = 1200
	local speed = 400 + RandomInt(0, 250)
	local info =
	{
		Ability = ability,
		EffectName = projectileParticle,
		vSpawnOrigin = projectileOrigin + Vector(0, 0, 60),
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
		fExpireTime = GameRules:GetGameTime() + 4.0,
		bDeleteOnHit = false,
		vVelocity = fv * speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
end

function voltex_static_field_spark_hit(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = event.damage
	if ability.r_4_level then
		damage = damage + OverflowProtectedGetAverageTrueAttackDamage(caster) * 0.1 * ability.r_4_level
	end
	voltex_rune_r_4_increment(caster, ability)
	if caster:HasModifier("modifier_voltex_glyph_6_1") then
		damage = damage * VOLTEX_GLYPH_6_1_R_DAMAGE_AMP
	end
	ability:ApplyDataDrivenModifier(caster, target, "modifier_voltex_static_field_post_mitigation", {duration = 10})
	local stacks = target:GetModifierStackCount("modifier_voltex_static_field_post_mitigation", caster)
	local newStacks = math.min(stacks + 1, 50)
	target:SetModifierStackCount("modifier_voltex_static_field_post_mitigation", caster, newStacks)
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_PURE, BASE_ABILITY_R, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
	if caster:HasModifier("modifier_voltex_immortal_weapon_3") then
		caster.weapon:ApplyDataDrivenModifier(caster.InventoryUnit, target, "modifier_voltex_immortal_paralysis", {duration = VOLTEX_IMMORTAL_WEAPON_3_PARALYSIS_DURATION})
	end
end

function voltex_rune_r_1(caster, ability)
	local r_1_level = caster:GetRuneValue("r", 1)
	local point = caster:GetAbsOrigin() + caster:GetForwardVector() * 300
	if r_1_level > 0 then
		local damage = VOLTEX_R1_BASE_DMG + VOLTEX_R1_DMG * r_1_level
		local r_4_level = caster:GetRuneValue("r", 4)
		if r_4_level then
			damage = damage + OverflowProtectedGetAverageTrueAttackDamage(caster) * VOLTEX_R4_ADD_DMG_PER_ATT * r_4_level
		end
		if caster:HasModifier("modifier_voltex_glyph_6_1") then
			damage = damage * VOLTEX_GLYPH_6_1_R1_DAMAGE_AMP
		end
		local maxLightning = r_1_level + 3
		if maxLightning > 40 then
			damage = damage * (maxLightning / 40)
			maxLightning = 40
		end
		for i = 1, maxLightning, 1 do
			Timers:CreateTimer(0.1 * i, function()
				voltex_rune_r_1_bolt(caster, ability, damage, point)
			end)
		end
	end
end

function voltex_rune_r_1_bolt(caster, ability, damage, point)
	local particleName = "particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf"
	local particleVector = blastLocation
	point = GetGroundPosition(caster:GetAbsOrigin() + RandomVector(RandomInt(50, 600)), caster)

	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, point + Vector(0, 0, 5000))
	ParticleManager:SetParticleControl(pfx, 1, point + Vector(0, 0, 20))
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	-- CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_mars/debut_lightning.vpcf", point, 1)
	EmitSoundOnLocationWithCaster(point, "Voltex.R1.LightningBolts", caster)
	Timers:CreateTimer(0.1, function()
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, 280, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				voltex_rune_r_4_increment(caster, ability)
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_R, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
			end
		end
		CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_stormspirit/stormspirit_static_remnant.vpcf", point, 0.03)
	end)
end

function voltex_rune_r_2_onattacklanded(event)
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	local luck = RandomInt(1, 100)
	local r_2_level = attacker:GetRuneValue("r", 2)
	if r_2_level > 0 and luck <= VOLTEX_R2_CHANCE then
		local damage = OverflowProtectedGetAverageTrueAttackDamage(attacker) * (VOLTEX_R2_BASE_DMG_PER_ATT + VOLTEX_R2_DMG_PER_ATT * r_2_level)
		Filters:ApplyStun(attacker, 0.2, target)
		Filters:TakeArgumentsAndApplyDamage(target, attacker, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_R, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
		-- Renders the particle on the target
		local particle = ParticleManager:CreateParticle("particles/roshpit/voltex/voltex_bolt_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, target)
		-- Raise 1000 value if you increase the camera height above 1000
		ParticleManager:SetParticleControl(particle, 0, Vector(target:GetAbsOrigin().x, target:GetAbsOrigin().y, target:GetAbsOrigin().z + target:GetBoundingMaxs().z))
		ParticleManager:SetParticleControl(particle, 1, Vector(target:GetAbsOrigin().x, target:GetAbsOrigin().y, target:GetAbsOrigin().z + 1000))
		ParticleManager:SetParticleControl(particle, 2, Vector(target:GetAbsOrigin().x, target:GetAbsOrigin().y, target:GetAbsOrigin().z + target:GetBoundingMaxs().z))

		ability:ApplyDataDrivenModifier(attacker.runeUnit2, target, "modifier_voltex_rune_r_2_armor_loss", {duration = VOLTEX_R2_ARMOR_LOSS_DUR})
		target:SetModifierStackCount("modifier_voltex_rune_r_2_armor_loss", ability, r_2_level)
		EmitSoundOn("Voltex.LightningBolt", target)
		Timers:CreateTimer(2, function()
			ParticleManager:DestroyParticle(particle, false)
		end)
	end
end

function voltex_rune_r_3(caster)
	local runeUnit = caster.runeUnit3
	local ability = runeUnit:FindAbilityByName("voltex_rune_r_3")
	local r_3_level = caster:GetRuneValue("r", 3)
	if r_3_level > 0 then
		EmitSoundOn("DOTA_Item.BlackKingBar.Activate", caster)
		local duration = VOLTEX_R3_BASE_DUR
		if caster:HasModifier("modifier_voltex_glyph_5_1") then
			duration = duration + VOLTEX_GLYPH_5_1_DURATION_INCREASE
		end
		duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
		if caster:HasModifier("modifier_voltex_glyph_5_1") then
			ability:ApplyDataDrivenModifier(runeUnit, caster, "modifier_voltex_rune_r_3_buff_glyph_5_1", {duration = duration})
		end
		ability:ApplyDataDrivenModifier(runeUnit, caster, "modifier_voltex_rune_r_3_avatar", {duration = duration})
		ability:ApplyDataDrivenModifier(runeUnit, caster, "modifier_voltex_rune_r_3_buff", {duration = duration})
		caster:AddNewModifier(caster, ability, "modifier_voltex_avatar_lua", {duration = duration})
		caster:SetModifierStackCount("modifier_voltex_rune_r_3_buff", ability, r_3_level)

	end
end

function voltex_rune_r_3_apply(event)
	local caster = event.target
	caster:SetRangedProjectileName("particles/units/heroes/hero_arc_warden/arc_warden_base_attack.vpcf")
	caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
end

function voltex_rune_r_3_think(event)
	local target = event.target
	local ability = event.ability
	local particleName = "particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, target:GetAbsOrigin() + Vector(0, 0, 300))
	ParticleManager:SetParticleControl(pfx, 2, target:GetAbsOrigin() + Vector(0, 0, 300))
	ParticleManager:SetParticleControl(pfx, 3, target:GetAbsOrigin() + Vector(0, 0, 300))
	ParticleManager:SetParticleControl(pfx, 4, target:GetAbsOrigin() + Vector(0, 0, 300))
	ParticleManager:SetParticleControl(pfx, 5, target:GetAbsOrigin() + Vector(0, 0, 300))
	ParticleManager:SetParticleControl(pfx, 6, target:GetAbsOrigin() + Vector(0, 0, 300))
	ParticleManager:SetParticleControl(pfx, 9, target:GetAbsOrigin())
	Timers:CreateTimer(0.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
end

function voltex_rune_r_3_end(event)
	local caster = event.target
	caster:RemoveModifierByName("modifier_voltex_avatar_lua")
	caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
end

function voltex_rune_r_4_increment(caster, ability)
	local r_4_level = caster:GetRuneValue("r", 4)
	if r_4_level > 0 then
		local r_4_duration = Filters:GetAdjustedBuffDuration(caster, VOLTEX_R4_BASE_DUR, false)
		local d_d_ability = caster.runeUnit4:FindAbilityByName("voltex_rune_r_4")
		d_d_ability:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_voltex_rune_r_4_visible", {duration = r_4_duration})
		local newStacks = caster:GetModifierStackCount("modifier_voltex_rune_r_4_visible", d_d_ability) + 1
		caster:SetModifierStackCount("modifier_voltex_rune_r_4_visible", d_d_ability, newStacks)
		d_d_ability:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_voltex_rune_r_4_invisible", {duration = r_4_duration})
		caster:SetModifierStackCount("modifier_voltex_rune_r_4_invisible", d_d_ability, newStacks * r_4_level)
	end
end
