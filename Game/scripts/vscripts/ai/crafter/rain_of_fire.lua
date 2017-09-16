function rain_think(event)
	local caster = event.caster
		local particleName =  "particles/units/heroes/hero_legion_commander/crawler_shaman_blizzard.vpcf"
		EmitSoundOn("Hero_Meepo.Poof.End05", caster)
		local position = caster:GetAbsOrigin()
		local target = event.target_points[1]
		local particleVector = target
		local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( pfx, 0, particleVector )
		ParticleManager:SetParticleControl( pfx, 1, particleVector )
		ParticleManager:SetParticleControl( pfx, 6, particleVector )
		Timers:CreateTimer(2, function() 
		  ParticleManager:DestroyParticle( pfx, false )
		end)  	
end

function betrayer_of_time_attack(event)
	local attacker = event.attacker
	local ability = event.ability
	local fv = attacker:GetForwardVector()
	for i = -1, 1, 1 do
		local rotatedFv = WallPhysics:rotateVector(fv, i*math.pi/6)
		betrayer_of_time_projectile(attacker, ability, attacker:GetAbsOrigin(), rotatedFv)
	end
end

function betrayer_of_time_projectile(caster, ability, position, fv)
    local start_radius = 130
    local end_radius = 130
    local speed = 500
       
    local info = 
    {
        Ability = ability,
          EffectName = "particles/units/heroes/hero_alchemist/betrayer_of_time_projectile_concoction_projectile.vpcf",
          vSpawnOrigin = position+Vector(0,0,100),
          fDistance = 1000,
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
      vVelocity = fv*speed,
      bProvidesVision = false,
    }
    projectile = ProjectileManager:CreateLinearProjectile(info) 

end
