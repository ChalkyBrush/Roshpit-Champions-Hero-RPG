function BeginBurrow(keys)
	local caster = keys.caster
	local ability = keys.ability

	local forwardVector = caster:GetForwardVector()
	local move_position = caster:GetAbsOrigin() + forwardVector*700
      local particleName = "particles/units/heroes/hero_earth_spirit/espirit_stoneremnant_groundrise.vpcf"
      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
      move_position = GetGroundPosition(move_position, caster)
      ParticleManager:SetParticleControl( particle1, 0, move_position )

      Timers:CreateTimer(1, 
      function()
      	caster:SetAbsOrigin(move_position)
        ParticleManager:DestroyParticle( particle1, false )
        StartAnimation(caster, {duration=1.3, activity=ACT_DOTA_SPAWN, rate=0.3})
      end)	
end