require('heroes/arc_warden/abilities/onibi')

function jex_grenade_throw_start(event)
	local caster = event.caster
	local ability = event.ability
    local target = event.target_points[1]
    Filters:CastSkillArguments(2, caster)
    local fv = (target*Vector(1,1,0)-caster:GetAbsOrigin()*Vector(1,1,0)):Normalized()
    local bomb = CreateUnitByName("lanaya_explosive_bomb", caster:GetAbsOrigin(), false, caster, nil, caster:GetTeamNumber())
    local modelName = "models/items/lanaya/epitaphicbonds_rocks/epitaphicbonds_psionic_trap_rock_0"..RandomInt(1, 3)..".vmdl"
    modelName = "models/items/enigma/eidolon/geodesic/geodesic.vmdl"

    bomb:SetModel(modelName)
    bomb:SetOriginalModel(modelName)
    local spawnPos = caster:GetAttachmentOrigin(3)
    bomb:SetAbsOrigin(spawnPos)
    -- bomb:SetRenderColor(0, 0, 0)
    bomb:SetModelScale(0.1)
    bomb.phase = 1
    bomb.stun_duration = event.stun_duration
    bomb.colorPhase = 0
    bomb.fv = fv
    bomb:AddAbility("jex_grenade_subability"):SetLevel(1)
    local bombAbility = bomb:FindAbilityByName("jex_grenade_subability")
    bombAbility:ApplyDataDrivenModifier(bomb, bomb, "modifier_bomb_motion", {})
    bomb.origCaster = caster
    bomb.origAbility = ability
    bomb.damage = event.damage
    bomb.target = target
    bomb.random_rotation = Vector(RandomInt(20, 60), RandomInt(20, 60), RandomInt(20, 60))
    local w_4_level = Runes:GetTotalRuneLevel(caster, 4, "w_4", "trapper")
    if ability.total_bombs == nil then
        ability.total_bombs = 0
        ability.bombs = {}
    end
    ability.total_bombs = ability.total_bombs + 1
    table.insert(ability.bombs, bomb)

    EmitSoundOn("Jex.GrenadeSwoosh", caster)
    EmitSoundOn("Jex.GrenadeThrow", caster)
    CustomAbilities:QuickAttachParticle("particles/items3_fx/glimmer_cape_initial_flash.vpcf", bomb, 3)
    --INIT BOMB
    local bombOrigin = bomb:GetAbsOrigin()
    local targetOrigin = target
    local fv = (targetOrigin*Vector(1,1,0)-bombOrigin*Vector(1,1,0)):Normalized()
    local distance = WallPhysics:GetDistance(bombOrigin*Vector(1,1,0), targetOrigin*Vector(1,1,0))
    bomb.interval = 0
    -- bomb:SetModelScale(0.1)
    local velocity = ((fv*3.5 + Vector(0,0,25))*1)
    local speed = (distance/(WallPhysics:GetDistance(velocity, Vector(0,0,0))))/8
    bomb.velocity = velocity
    bomb.speed = math.max(speed, 0.5)
    bomb:SetForwardVector(fv)
    bomb.particle = 2

    local tech_level = caster.onibi.stats_table["cosmic"]["cosmic"]["W"]["level"]
    ability.tech_level = tech_level
    local damage = event.damage + (event.attack_power_added_per_tech/100)*tech_level*OverflowProtectedGetAverageTrueAttackDamage(caster) + event.intelligence_added_to_damage*caster:GetIntellect()
    local e_4_level = caster:GetRuneValue("e", 4)
    if e_4_level > 0 then
        damage = damage + damage*(event.e_4_damage_increase_pct/100)*e_4_level
    end
    local aoe = event.aoe_base + tech_level*event.aoe_per_tech_level
    bomb.aoe = aoe
    bomb.damage = damage
    bomb.tech_level = tech_level
end

        		-- "damage"		"%damage"
        		-- "aoe_base"		"%aoe_base"
        		-- "aoe_per_tech_level"	"%aoe_per_tech_level"
        		-- "attack_power_added_per_tech"	"%attack_power_added_per_tech"
        		-- "intelligence_added_to_damage"	"%intelligence_added_to_damage"

function jex_grenade_think(event)
	local caster = event.caster
	if not IsValidEntity(caster) then
		return false
	end
	local ability = event.ability
	local angles = caster:GetAngles()
	if not caster.random_rotation then
		return false
	end
	if caster:GetModelScale() < 0.55 then
		caster:SetModelScale(caster:GetModelScale()+0.03)
	end
	local new_angles = Vector(angles.x, angles.y, angles.z) + caster.random_rotation/5
	-- caster:SetAngles(new_angles.x, new_angles.y, new_angles.z)
	local newPos = caster:GetAbsOrigin() + caster.velocity*caster.speed
	caster:SetAbsOrigin(newPos)
	caster.velocity = caster.velocity 
	caster.velocity = caster.velocity - Vector(0,0,0.9)
	local velocity_2d = caster.velocity*Vector(1,1,0)
	local fv = (caster.velocity*1 + velocity_2d*3):Normalized()
	caster:SetForwardVector(fv)
	if caster.particle == 2 and caster.velocity.z < 0 then
		caster.particle = 1
		CustomAbilities:QuickAttachParticle("particles/items3_fx/glimmer_cape_initial_flash.vpcf", caster, 3)
	end
	local distance_from_ground = caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster)
	-- if distance_from_ground < 400 and caster.particle == 1 and caster.velocity.z < -5 then
	-- 	CustomAbilities:QuickAttachParticle("particles/items3_fx/glimmer_cape_initial_flash.vpcf", caster, 3)
	-- 	caster.particle = 0
	-- end
	if distance_from_ground < 30 and caster.velocity.z < 0 then
		caster:RemoveModifierByName("modifier_bomb_motion")
	end
end

function jex_cosmic_cosmic_w_explode(event)
	local caster = event.caster
	local ability = event.ability
	local explosionRadius = 500
	explosionRadius = caster.aoe
	local particleName = "particles/roshpit/jex/generic_aoe_no_sphere.vpcf"
	local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_WORLDORIGIN, caster )
	ParticleManager:SetParticleControl( particle2, 0, caster:GetAbsOrigin()+Vector(0,0,20) )
	ParticleManager:SetParticleControl( particle2, 1, Vector(explosionRadius,explosionRadius,explosionRadius/20) )
	ParticleManager:SetParticleControl( particle2, 2, Vector(1.8, 1.8, 1.8) )
	ParticleManager:SetParticleControl( particle2, 4, Vector(60, 20, 150) )

	Timers:CreateTimer(1.9, 
	function()
	ParticleManager:DestroyParticle( particle2, false )
	end)
	caster.explosionPoint = GetGroundPosition(caster:GetAbsOrigin(), caster)
  -- particleName = "particles/econ/items/mirana/mirana_ti8_immortal_mount/mirana_ti8_immortal_leap_start.vpcf"
  -- local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
  -- ParticleManager:SetParticleControl( particle1, 0, caster:GetAbsOrigin()+Vector(0,0,20) )
  -- Timers:CreateTimer(2, 
  -- function()
  --   ParticleManager:DestroyParticle( particle1, false )
  -- end)
    local root_duration = event.root_per_tech_level*caster.tech_level
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, explosionRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			if not enemy.dummy then
				local towardCenter = ((caster.explosionPoint - enemy:GetAbsOrigin())*Vector(1,1,0)):Normalized()
				local distance = WallPhysics:GetDistance2d(caster.explosionPoint, enemy:GetAbsOrigin())
				local newPos = enemy:GetAbsOrigin() + towardCenter*distance*0.5
				FindClearSpaceForUnit(enemy, newPos, false)
				Filters:TakeArgumentsAndApplyDamage(enemy, caster.origCaster, caster.damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_COSMOS, RPC_ELEMENT_NONE)
                if not enemy:HasModifier("jex_grenade_root_immunity") then
                    ability:ApplyDataDrivenModifier(caster, enemy, "jex_grenade_root", {duration = root_duration})
                    ability:ApplyDataDrivenModifier(caster, enemy, "jex_grenade_root_immunity", {duration = root_duration+1})
                end
			end
			-- Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
		end
	end 	

  EmitSoundOn("Jex.GrenadeExplode", caster)
	jex_reindexBombs(caster.origAbility)
	Timers:CreateTimer(0.03, function()
		UTIL_Remove(caster)
	end)
end

function jex_reindexBombs(ability)
    local tempTable = {}
    for i = 1, #ability.bombs, 1 do
        if IsValidEntity(ability.bombs[i]) then
            table.insert(tempTable, ability.bombs[i])
        end
    end 
    return tempTable
end