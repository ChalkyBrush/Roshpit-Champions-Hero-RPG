CAST_SOUND_TABLE = {"nevermore_nev_anger_04", "nevermore_nev_anger_06", "nevermore_nev_anger_07", "nevermore_nev_arc_laugh_04", "nevermore_nev_arc_laugh_05", "nevermore_nev_arc_laugh_02"}

function begin_splitter(event)
	local caster = event.caster
	local ability = event.ability
	abilityLevel = ability:GetLevel()
	location = caster:GetOrigin()
	forwardVector = caster:GetForwardVector()
	local randInt = RandomInt(0, 2)
	for i = 0, 16, 1 do
		Timers:CreateTimer(i*0.2, -- Start this timer 10 game-time seconds later
	          function()
	    location = caster:GetOrigin()
		targetPoint = location + RandomVector(300)
		create_individual_explosion(abilityLevel, caster, targetPoint, location)
		end)
	end
	EmitSoundOn(CAST_SOUND_TABLE[RandomInt(1,6)], caster)
	--StartAnimation(caster, {duration=.5, activity=ACT_DOTA_CAST_ABILITY_3, rate=.8, translate="blood_chaser"}) 
	
end

function animation(keys)
	print('animating')
	caster = keys.caster
	StartAnimation(caster, {duration=2, activity=ACT_DOTA_CAST_ABILITY_6, rate=1, translate="arcana"})
end

function create_individual_explosion(abilityLevel, caster, targetPoint, casterOrigin)
		local casterOrigin = caster:GetAbsOrigin()

		local projectileParticle = "particles/econ/items/shadow_fiend/sf_desolation/forest_boss_splitter.vpcf"

		local start_radius = 220
		local end_radius = 220
		local range = 1800
		local speed = 500

		local info = 
		{
				Ability = ability,
	        	EffectName = projectileParticle,
	        	vSpawnOrigin = casterOrigin+Vector(0,0,150),
	        	fDistance = range,
	        	fStartRadius = start_radius,
	        	fEndRadius = end_radius,
	        	Source = caster,
	        	StartPosition = "attach_attack2",
	        	bHasFrontalCone = true,
	        	bReplaceExisting = false,
	        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	        	fExpireTime = GameRules:GetGameTime() + 5.0,
			bDeleteOnHit = false,
			vVelocity = RandomVector(1) * speed,
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

function projectileHit(event)
	local caster = event.caster
	local target = event.target
	local point = target:GetAbsOrigin() + RandomVector(100)
	local ability = event.ability
	EmitSoundOn("Hero_Techies.LandMine.Detonate", target)
      --target:AddNewModifier( target, nil, "modifier_knockback", modifierKnockback )
end
