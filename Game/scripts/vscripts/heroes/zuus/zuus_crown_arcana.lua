require('heroes/zuus/heavens_shield')

function start_holy_arcana(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	if IsValidEntity(event.target) then
		point = event.target:GetAbsOrigin()
	end
	local modifierName = "modifier_holy_wrath_buff"
	local allies = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, AURIUN_ARCANA_1_Q_RADIUS, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
	if #allies == 0 then
		local nearbyAllies = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, 2000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_CLOSEST, false)
		if #nearbyAllies > 0 then
			allies = {nearbyAllies[1]}
		end
	end
	for i = 1, #allies, 1 do
		local eventTable = {}
		eventTable.caster = caster
		eventTable.ability = ability
		eventTable.target = allies[i]
		eventTable.stacks = event.stacks
		EmitSoundOn("Auriun.FlashHeal", allies[i])
		heavens_shield_cast(eventTable)
		-- ability:ApplyDataDrivenModifier(caster, allies[i], "modifier_holy_wrath_buff", {duration = 5})
	end
	local pfx = ParticleManager:CreateParticle("particles/roshpit/auriun/holy_wrath_aoe.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, point)
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	EmitSoundOn("Auriun.HolyWrath", caster)
	Filters:CastSkillArguments(1, caster)
	local q_4_level = caster:GetRuneValue("q", 4)
	ability.q_4_level = q_4_level
	if q_4_level > 0 then
		local duration = AURIUN_ARCANA_1_Q4_DURATION
		duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_holy_wrath_d_a_buff", {duration = duration})
		caster:SetModifierStackCount("modifier_holy_wrath_d_a_buff", caster, q_4_level)
	end
	immortal_weapon_3_effect(caster, ability)
end

function heavens_shield_take_damage(event)
	local caster = event.caster
	local damage = event.damage
	local target = event.unit
	local ability = event.ability
	if ability.q_1_level > 0 then

		shield_lightning(caster, ability, target:GetAbsOrigin())
	end
end

function shield_lightning(caster, ability, projectileOrigin)
	local loopCount = 3
	if not ability.lightnings then
		ability.lightnings = 0
	end
	if ability.lightnings < 16 then
		ability.lightnings = ability.lightnings + 1
		for i = 1, loopCount, 1 do
			local fv = WallPhysics:rotateVector(caster:GetForwardVector(), 2 * math.pi * RandomInt(-10, 10) / 60)
			local projectileParticle = "particles/roshpit/auriun/holy_spark_immortal_lightning.vpcf"
			local projectileOrigin = projectileOrigin + fv * 10
			local start_radius = 140
			local end_radius = 140
			local range = 900
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
		Timers:CreateTimer(1.2, function()
			ability.lightnings = ability.lightnings - 1
		end)
	end
end

function heavens_shield_spark_hit(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local damage = ability.q_1_level * AURIUN_ARCANA_1_Q1_DAMAGE + AURIUN_ARCANA_1_Q1_DAMAGE_BASE
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_Q, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
end

function start_shadow_arcana(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	Filters:CastSkillArguments(1, caster)
	--ability:ApplyDataDrivenThinker(caster, GetGroundPosition(point, caster), "shadow_trap", {duration = 7})
	CustomAbilities:QuickAttachThinker(ability, caster, GetGroundPosition(point, caster), "shadow_trap", {duration = AURIUN_ARCANA_2_Q_DURATION})

	EmitSoundOnLocationWithCaster(point, "Auriun.ShadowTrap", caster)

	ability.q_1_level = caster:GetRuneValue("q", 1)

	local q_2_level = caster:GetRuneValue("q", 2)
	if q_2_level > 0 then
		local eventTable = {}
		eventTable.caster = caster
		eventTable.ability = ability
		eventTable.target = caster
		eventTable.stacks = 1
		EmitSoundOn("Auriun.FlashHeal", caster)
		heavens_shield_cast(eventTable)
	end
	immortal_weapon_3_effect(caster, ability)
end

function shadow_trap_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if ability.q_1_level > 0 then
		local damage = AURIUN_ARCANA_2_Q1_DAMAGE_BASE + ability.q_1_level * AURIUN_ARCANA_2_Q1_DAMAGE
		CustomAbilities:QuickAttachParticle("particles/roshpit/auriun/shadow_rain_attack.vpcf", target, 3.5)
		Timers:CreateTimer(0.45, function()
			Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_Q, RPC_ELEMENT_SHADOW, RPC_ELEMENT_NONE)
			EmitSoundOn("Auriun.ShadowMeteor", target)
		end)
	end

end
