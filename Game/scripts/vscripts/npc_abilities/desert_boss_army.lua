function begin_army(event)
	local caster = event.caster
	local ability = event.ability
	--ability.locationVectors = {}
	local particles = {}
	for i = 0, 9, 1 do
		local randomLoc = RandomVector(RandomInt(300, 800)) + caster:GetAbsOrigin()
		--table.insert(ability.locationVectors,randomLoc)
	    local particleName = "particles/econ/items/tinker/tinker_motm_rollermaw/tinker_rollermaw_motm.vpcf"
	    -- local particle = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
	    -- ParticleManager:SetParticleControl(particle,0,Vector(randomLoc.x,randomLoc.y,randomLoc.z))
	    -- ParticleManager:SetParticleControl(particle,1,Vector(500,1,1))
      local particle = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
      ParticleManager:SetParticleControl( particle, 0, randomLoc+Vector(0,0,100) )
      -- ParticleManager:SetParticleControl( particle, 1, Vector(400, 400, 1) )
      ParticleManager:SetParticleControl( particle, 2, Vector(900, 1, 1) )
      ParticleManager:SetParticleControl( particle, 3, Vector(-900, 1, 1) )
      ParticleManager:SetParticleControl( particle, 9, Vector(700, 1, 1) )
	    table.insert(particles,particle)
	    EmitSoundOn("Hero_Tinker.GridEffect", caster)
        Timers:CreateTimer(1.5, 
	        function()
	        	rocketDummy(randomLoc, caster, 2, 3, i)
	        end)
	end
	Timers:CreateTimer(5,
		function()
			for _,army_particle in pairs(particles) do
				ParticleManager:DestroyParticle( army_particle, false )
			end			
		end)
	Timers:CreateTimer(3.1,
		function()
			if not event.secondShot then
				event.secondShot = true
				begin_army(event)
			end
		end)
end

function rocketDummy(location, caster, abilityLevel, blasts, loopcount)
  	local dummy = CreateUnitByName("npc_dummy_unit", location, true, caster, caster, caster:GetTeamNumber())
  	dummy.owner = "desert_boss"

  	dummy:AddAbility("army_flare")
  	dummy:NoHealthBar()
  	dummy:AddAbility("dummy_unit")
  	dummy:FindAbilityByName("dummy_unit"):SetLevel(1)

  	local blast = dummy:FindAbilityByName("army_flare")
  	blast:SetLevel(abilityLevel)
  	for i = 0, blasts, 1 do
         Timers:CreateTimer(0.4*i, 
	        function()
			local order =
			{
				UnitIndex = dummy:GetEntityIndex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = blast:GetEntityIndex(),
				Position = location,
				Queue = true
			}
			if loopcount < 2 then
				EmitSoundOn("Hero_Rattletrap.Rocket_Flare.Explode", caster)
			end
			ExecuteOrderFromTable(order)
			local particleName = "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf"
     		local particle = ParticleManager:CreateParticle( particleName, PATTACH_WORLDORIGIN, caster )
     		ParticleManager:SetParticleControl( particle, 0, location )
			  Timers:CreateTimer(2,
			  function()
				ParticleManager:DestroyParticle( particle, false )
			  end)	
		end)
	end
    Timers:CreateTimer(3, 
	function()
		UTIL_Remove(dummy)
	end)
end