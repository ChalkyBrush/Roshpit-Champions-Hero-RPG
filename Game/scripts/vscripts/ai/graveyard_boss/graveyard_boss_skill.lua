function start_attack(event)
	local soundTable = {"skeleton_king_wraith_level_10", "skeleton_king_wraith_level_11", "skeleton_king_wraith_level_12"}
	local ability = event.ability
	local caster = event.caster
	ability.sequence = 0
	ability.fv = caster:GetForwardVector()
	local randomSound = RandomInt(1, 3)
	EmitSoundOn(soundTable[randomSound], caster)
end

function graveyard_boss_think(event)
	local caster = event.caster
	local ability = event.ability
	ability.sequence = ability.sequence + 1
	local rotatedVector = rotateVector(ability.fv, math.pi / 30 * ability.sequence)
	caster:SetForwardVector(rotatedVector)
	if ability.sequence % 6 == 0 then
		EmitSoundOn("Hero_SkeletonKing.Hellfire_Blast", caster)
		StartAnimation(caster, {duration = 0.26, activity = ACT_DOTA_CAST_ABILITY_1, rate = 1.8})
		local spellOrigin = caster:GetAbsOrigin() + Vector(0, 0, 130)
		local fv = rotatedVector
		local info =
		{
			Ability = ability,
			EffectName = "particles/units/heroes/hero_skeletonking/hellfireblast_linear.vpcf",
			vSpawnOrigin = spellOrigin,
			fDistance = 1450,
			fStartRadius = 155,
			fEndRadius = 155,
			Source = caster,
			StartPosition = "attach_attack2",
			bHasFrontalCone = true,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 7.0,
			bDeleteOnHit = false,
			vVelocity = fv * 800,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
	end
end

function rotateVector(vector, radians)
	XX = vector.x
	YY = vector.y

	Xprime = math.cos(radians) * XX - math.sin(radians) * YY
	Yprime = math.sin(radians) * XX + math.cos(radians) * YY

	vectorX = Vector(1, 0, 0) * Xprime
	vectorY = Vector(0, 1, 0) * Yprime
	rotatedVector = vectorX + vectorY
	return rotatedVector
end

function hellfire_strike(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	EmitSoundOn("Hero_SkeletonKing.Hellfire_BlastImpact", target)
	local damage = 600 + (GameState:GetDifficultyFactor() - 1) * 50000
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
	target:AddNewModifier(caster, nil, "modifier_stunned", {duration = 2.3})
end

function graveyard_boss_die(event)
	local caster = event.caster
	for i = 0, 9, 1 do
		RPCItems:RollItemtype(300, caster:GetAbsOrigin(), 1, 0)
	end
	EmitSoundOn("skeleton_king_wraith_death_long_01", caster)
	EmitSoundOn("skeleton_king_wraith_death_long_01", caster)
	EmitSoundOn("skeleton_king_wraith_death_long_01", caster)
	StartAnimation(caster, {duration = 3, activity = ACT_DOTA_DIE, rate = 0.6})
	Timers:CreateTimer(1.5, function()
		EmitGlobalSound("Loot_Drop_Stinger_Arcana")
		Notifications:TopToAll({text = "Dungeon Clear!", duration = 8.0})
	end)
	Timers:CreateTimer(10, function()
		Beacons:CreatePortal(Vector(-6784, -12160), Vector(-5248, -7360), "graveyard", nil, true)
	end)
	Dungeons.entryPoint = nil
end
