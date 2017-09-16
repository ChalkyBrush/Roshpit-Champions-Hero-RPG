function BeginTeleport(event)
	print("any skitter")
  local caster = event.caster
  local ability = event.ability
  if not caster.dead then
    StartAnimation(caster, {duration=0.47, activity=ACT_DOTA_CAST_ABILITY_4, rate=1.2})
  end
  EmitSoundOn("Hero_Weaver.Footsteps", caster)
    Timers:CreateTimer(0.5,
    function()
      EmitSoundOn("Hero_Weaver.Footsteps", caster)
      ability:ApplyDataDrivenModifier(caster, caster, "modifier_skitter_teleport_datadriven", {})
    end)
  
end

function HideCaster( event )
    local ability = event.ability
    event.caster:AddNoDraw()
    position = event.caster:GetAbsOrigin()
    event.caster.newPosition =  position + event.caster:GetForwardVector()*1400

    local particleName = "particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf"
    ability.particle = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, event.caster)
    ParticleManager:SetParticleControl(ability.particle,0,Vector(position.x,position.y,position.z))
    Timers:CreateTimer(1,
    function()
      ParticleManager:DestroyParticle( ability.particle, false )
      ability.particle2 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, event.caster)
      ParticleManager:SetParticleControl(ability.particle2,0,Vector(event.caster.newPosition.x,event.caster.newPosition.y,event.caster.newPosition.z))
    end)

    event.caster:SetOrigin(event.caster.newPosition)
    FindClearSpaceForUnit(event.caster, event.caster.newPosition, false)
end


function ShowCaster( event )
  local caster = event.caster
  local ability = event.ability
  if not caster.dead then
    StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_CAST_BURROW_END, rate=1.2})
  end
  EmitSoundOn("Hero_Weaver.Footsteps", caster)
    Timers:CreateTimer(1,
    function()
      ParticleManager:DestroyParticle( ability.particle2, false )
    end)
    caster:RemoveNoDraw()
end

function StopSound( event )
    StopSoundEvent( event.sound_name, event.target )
end

-- function BeginTeleport(event)
--   local caster = event.caster
--   local ability = event.ability
--   if not caster.dead then
--     StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_CAST_ABILITY_4, rate=1.2})
--   end
--   EmitSoundOn(randomSound, caster)
--   EmitSoundOn(randomSound, caster)
--     Timers:CreateTimer(0.5,
--     function()
--       EmitSoundOn("Hero_Weaver.Footsteps", caster)
--       ability:ApplyDataDrivenModifier(caster, caster, "modifier_skitter_teleport_datadriven", {})
--     end)
--     print("SKITTERING")
  
-- end

-- function HideCaster( event )
--     local ability = event.ability
--     event.caster:AddNoDraw()
--     position = event.caster:GetAbsOrigin()
--     event.caster.newPosition =  position + event.caster:GetForwardVector()*1400

--     local particleName = "particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf"
--     ability.particle = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, event.caster)
--     ParticleManager:SetParticleControl(ability.particle,0,Vector(position.x,position.y,position.z))
--     Timers:CreateTimer(1,
--     function()
--       ParticleManager:DestroyParticle( ability.particle, false )
--       ability.particle2 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, event.caster)
--       ParticleManager:SetParticleControl(ability.particle2,0,Vector(event.caster.newPosition.x,event.caster.newPosition.y,event.caster.newPosition.z))
--     end)

--     event.caster:SetOrigin(event.caster.newPosition)
--     FindClearSpaceForUnit(event.caster, event.caster.newPosition, false)
-- end


-- function ShowCaster( event )
--   local caster = event.caster
--   local ability = event.ability
--   EmitSoundOn("Hero_Weaver.Footsteps", caster)
--   EmitSoundOn(randomSound, caster)
--   EmitSoundOn(randomSound, caster)
--   StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_CAST_BURROW_END, rate=1.2})
--     Timers:CreateTimer(1,
--     function()
--       ParticleManager:DestroyParticle( ability.particle2, false )
--     end)
--     caster:RemoveNoDraw()
-- end

-- function StopSound( event )
--     StopSoundEvent( event.sound_name, event.target )
-- end
