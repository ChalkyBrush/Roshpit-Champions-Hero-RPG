function BeginSpew(args)

	local caster = args.caster
	--local point = args.target_points[1]
	local fv = caster:GetForwardVector()
	local origin = caster:GetAbsOrigin()
	local spellOrigin = origin+fv*80
	--A Liner Projectile must have a table with projectile info
	local info = 
	{
		Ability = args.ability,
        	EffectName = "particles/units/heroes/hero_weaver/weaver_swarm_projectile.vpcf",
        	vSpawnOrigin = spellOrigin,
        	fDistance = 2000,
        	fStartRadius = 120,
        	fEndRadius = 120,
        	Source = caster,
        	StartPosition = "attach_attack2",
        	bHasFrontalCone = false,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 6,
		bDeleteOnHit = true,
		vVelocity = fv * 400,
		bProvidesVision = false,
	}
	fv = rotateVector(caster:GetForwardVector(), math.pi/6)
	spellOrigin = origin+fv*80
	info = 
	{
		Ability = args.ability,
        	EffectName = "particles/units/heroes/hero_weaver/weaver_swarm_projectile.vpcf",
        	vSpawnOrigin = spellOrigin,
        	fDistance = 2000,
        	fStartRadius = 120,
        	fEndRadius = 120,
        	Source = caster,
        	StartPosition = "attach_attack2",
        	bHasFrontalCone = false,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 6,
		bDeleteOnHit = true,
		vVelocity = fv * 400,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)

	fv = rotateVector(caster:GetForwardVector(), -math.pi/6)
	spellOrigin = origin+fv*80
	info = 
	{
		Ability = args.ability,
        	EffectName = "particles/units/heroes/hero_weaver/weaver_swarm_projectile.vpcf",
        	vSpawnOrigin = spellOrigin,
        	fDistance = 2000,
        	fStartRadius = 120,
        	fEndRadius = 120,
        	Source = caster,
        	StartPosition = "attach_attack2",
        	bHasFrontalCone = false,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 6,
		bDeleteOnHit = true,
		vVelocity = fv * 400,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)


end

function rotateVector(vector, radians)
   XX = vector.x	
   YY = vector.y
   
   Xprime = math.cos(radians)*XX -math.sin(radians)*YY
   Yprime = math.sin(radians)*XX +math.cos(radians)*YY

   vectorX = Vector(1,0,0)*Xprime
   vectorY = Vector(0,1,0)*Yprime
   rotatedVector = vectorX + vectorY
   return rotatedVector
   
end
