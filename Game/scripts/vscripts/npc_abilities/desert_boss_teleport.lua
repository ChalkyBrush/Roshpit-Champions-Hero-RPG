function BeginTeleport(event)
  local soundTable = {"tinker_tink_deny_12", "tinker_tink_haste_02", "tinker_tink_kill_14"}
  local caster = event.caster
  local ability = event.ability
  if not caster.dead then
    StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_TINKER_REARM1, rate=1.5})
  end
  local randomSound = soundTable[RandomInt(1, 3)]
  EmitSoundOn(randomSound, caster)
  EmitSoundOn(randomSound, caster)
    Timers:CreateTimer(0.5,
    function()
      EmitSoundOn("Hero_StormSpirit.StaticRemnantPlant", caster)
      ability:ApplyDataDrivenModifier(caster, caster, "modifier_jonuous_teleport_datadriven", {})
    end)
  
end

function HideCaster( event )
    local ability = event.ability
    event.caster:AddNoDraw()
    position = event.caster:GetAbsOrigin()
    event.caster.newPosition =  position + event.caster:GetForwardVector()*1400

    local particleName = "particles/econ/items/tinker/boots_of_travel/teleport_end_bots.vpcf"
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
  EmitSoundOn("Hero_StormSpirit.StaticRemnantPlant", caster)
  local soundTable = {"tinker_tink_deny_12", "tinker_tink_kill_14"}
  local randomSound = soundTable[RandomInt(1, 2)]
  EmitSoundOn(randomSound, caster)
  EmitSoundOn(randomSound, caster)
    Timers:CreateTimer(1,
    function()
      ParticleManager:DestroyParticle( ability.particle2, false )
    end)
    caster:RemoveNoDraw()
end

function StopSound( event )
    StopSoundEvent( event.sound_name, event.target )
end

function LaserBeams(event)
  local caster = event.caster
  local ability = event.ability
  if not caster.dead then
    local targetPoint = caster:GetAbsOrigin()
    local radius = 700
    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), targetPoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
    if #enemies > 0 then
      for _,enemy in pairs(enemies) do
        dummyLaser(targetPoint, caster, enemy)
      end
    end 
  end
end

function dummyLaser(targetPoint, caster, targetUnit)

    local dummy = CreateUnitByName("npc_dummy_unit", targetPoint, true, caster, caster, caster:GetTeamNumber())
    dummy.owner = "desert_boss"

    dummy:AddAbility("jonuous_laser")
    dummy:NoHealthBar()
    dummy:AddAbility("dummy_unit")
    dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
    local proc = dummy:FindAbilityByName( "jonuous_laser" )
    proc:SetLevel(1)
    local order =
    {
        UnitIndex = dummy:GetEntityIndex(),
        OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
        AbilityIndex = proc:GetEntityIndex(),
        TargetIndex = targetUnit:GetEntityIndex(),
        Queue = true
    }
    ExecuteOrderFromTable(order)
      Timers:CreateTimer(1.5,
      function()
        UTIL_Remove(dummy)
      end)
end

function vision(event)
  local position = event.caster:GetAbsOrigin()
  AddFOWViewer(DOTA_TEAM_GOODGUYS, position, 650, 3, false)
end