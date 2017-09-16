function start_electricity(event)
	local caster = event.caster
	StartAnimation(caster, {duration=4, activity=ACT_DOTA_TELEPORT, rate=0.5})
end

function electricity_think(event)
	local caster = event.caster

    local particleName = "particles/items_fx/chain_lightning.vpcf"
    local radius = 580
    local damage = event.damage
    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false )
    local targets_shocked = 1 --Is targets=extra targets or total?
    for _,unit in pairs(enemies) do
            if unit ~= target then
                -- Particle
                --EmitSoundOn("Hero_Zuus.ArcLightning.Cast", caster)
                local origin = unit:GetAbsOrigin()
                local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
                ParticleManager:SetParticleControl(lightningBolt,0,Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))   
                ParticleManager:SetParticleControl(lightningBolt,1,Vector(origin.x,origin.y,origin.z + unit:GetBoundingMaxs().z ))
            
                -- Damage
                ApplyDamage({ victim = unit, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

                -- Increment counter
                --targets_shocked = targets_shocked + 1
            end
    end
end