function rubble_passive_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.phase and caster.phase < 3 then
		if caster:GetHealth() < 100 then
			-- if not caster:HasModifier("modifier_mountain_rubble_in_between") then
				if not caster:HasModifier("modifier_mountain_rubble_in_between") then
					StartAnimation(caster, {duration = 600, activity = ACT_DOTA_DISABLED, rate = 0.8})
				end
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_mountain_rubble_in_between", {})
				if not caster.mountain_bro_to_join then
					for i = 1, #caster.mountain_bro_table, 1 do
						if caster.mountain_bro_table[i].phase == caster.phase and caster.mountain_bro_table[i]:HasModifier("modifier_mountain_rubble_in_between") then
							if caster == caster.mountain_bro_table[i] then
							elseif caster.mountain_bro_to_join or caster.mountain_bro_table[i].mountain_bro_to_join then
							else
								caster.mountain_bro_to_join = caster.mountain_bro_table[i]
								caster.mountain_bro_table[i].mountain_bro_to_join = caster
								break
							end
						end
					end
				end
			-- end
		end
	end
end

function mountain_rubble_start_channel(event)
	local caster = event.caster
	local ability = event.ability
	if caster:GetUnitName() == "winterblight_composed_rubble" then
		EmitSoundOn("Winterblight.Rubble.Cast", caster)
	end
	StartSoundEvent("Winterblight.Rubble.Channel", caster)
end

function mountain_rubble_channel_complete(event)
	local caster = event.caster
	local ability = event.ability
	-- CustomAbilities:QuickAttachParticle("particles/econ/items/monkey_king/arcana/water/monkey_king_spring_arcana_water.vpcf", caster, 7)
	local castLoops = 0
	local radius = 320 + caster.phase*100
	for i = 0, castLoops, 1 do
		Timers:CreateTimer(i * 2, function()
			EmitSoundOn("Winterblight.Rubble.Ability", caster)
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()+Vector(0,0,5))
			ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 2, radius))
			if caster.phase == 0 then
				StartAnimation(caster, {duration = 1.0, activity = ACT_DOTA_TELEPORT_END, rate = 0.8})
			else
				StartAnimation(caster, {duration = 1.0, activity = ACT_DOTA_CAST_ABILITY_3, rate = 0.8})
			end
			local stunDuration = event.stun_duration

			StopSoundEvent("Winterblight.Rubble.Channel", caster)
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius-50, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			local damage = event.damage * (caster.phase + 1)
			if #enemies > 0 then
				for _, enemy in pairs(enemies) do
					ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
					Filters:ApplyStun(caster, stunDuration, enemy)
					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_mountain_rubble_slow", {duration = 6})
				end
			end
			Timers:CreateTimer(6, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
		end)
	end
end

function mountain_rubble_channel_interrupt(event)
	local caster = event.caster
	StopSoundEvent("Winterblight.Rubble.Channel", caster)
end

function rubble_inbetween_thinker(event)
	local caster = event.caster
	local ability = event.ability
	if caster.lock then
		return false
	end
	if IsValidEntity(caster) then
		if caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster) < 240 then
			caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0,0,8))
		elseif caster.mountain_bro_to_join and WallPhysics:GetDistance2d(caster.mountain_bro_to_join:GetAbsOrigin(), caster:GetAbsOrigin()) > 20 and caster.mountain_bro_to_join:GetDistanceFromGround() > 235 and caster:GetDistanceFromGround() > 235 then
			local direction = ((caster.mountain_bro_to_join:GetAbsOrigin() - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
			caster:SetAbsOrigin(caster:GetAbsOrigin()+direction*30)
		elseif caster.mountain_bro_to_join and caster.mountain_bro_to_join:GetDistanceFromGround() > 235 and caster:GetDistanceFromGround() > 235 then
			EndAnimation(caster)
			local new_rubble = Enemies:SpawnEnemyUnit("winterblight_composed_rubble", caster:GetAbsOrigin(), RandomVector(1), false)
			caster.mountain_bro_to_join.lock = true
			caster.lock = true
			new_rubble.phase = caster.phase + 1
			local model_name = "models/items/tiny/frozen_stonehenge/frozen_stonehenge_lvl_0"..(new_rubble.phase+1)..".vmdl"
			new_rubble:SetOriginalModel(model_name)
			new_rubble:SetModel(model_name)
			EmitSoundOn("Winterblight.Megmus.Ability", new_rubble)
			local pfx = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf", PATTACH_CUSTOMORIGIN, new_rubble)
			ParticleManager:SetParticleControl(pfx, 0, new_rubble:GetAbsOrigin())
			ParticleManager:SetParticleControl(pfx, 1, Vector(200, 2, 200))

			
	
			new_rubble:SetAbsOrigin(caster:GetAbsOrigin())
			Timers:CreateTimer(2, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
			local mountain_bro_table = caster.mountain_bro_table
			Dungeons:AggroUnit(new_rubble)
			local new_rubble_passive_ability = new_rubble:FindAbilityByName("winterblight_rubble_passive")
			new_rubble_passive_ability:ApplyDataDrivenModifier(new_rubble, new_rubble, "modifier_mountain_rubble_entering", {})
			new_rubble:AdjustSummon(caster, true, 2, 2, 2, 2, 2, 2)
			UTIL_Remove(caster)
			UTIL_Remove(caster.mountain_bro_to_join)
			local new_mountain_bro_table = {}
			for i = 1, #mountain_bro_table, 1 do
				if mountain_bro_table[i] and IsValidEntity(mountain_bro_table[i]) and mountain_bro_table[i]:IsAlive() then
					table.insert(new_mountain_bro_table, mountain_bro_table[i])
				end
			end
			table.insert(new_mountain_bro_table, new_rubble)
			for i = 1, #new_mountain_bro_table, 1 do
				new_mountain_bro_table[i].mountain_bro_table = new_mountain_bro_table
			end
			if new_rubble.phase == 3 then
				new_rubble:RemoveModifierByName("modifier_rubble_min_health")
			end
		end
	end
end

function rubble_entering_thinker(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.fallSpeed then
		caster.fallSpeed = 12
		StartAnimation(caster, {duration = 0.6, activity = ACT_DOTA_FLAIL, rate = 0.9})
	end
	if IsValidEntity(caster) then
		if caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster) > 10 then
			caster.fallSpeed = math.min(caster.fallSpeed + 0.5, 25)
			caster:SetAbsOrigin(caster:GetAbsOrigin() - Vector(0,0,caster.fallSpeed))
		else
			caster:RemoveModifierByName("modifier_mountain_rubble_entering")
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		end
	end
end

function mountain_rubble_die(event)
	EmitSoundOn("Winterblight.Rubble.Death", event.caster)
end

function owl_sentry_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.locked_target then
		return false
	else
		local target_pos = caster.patrol_point_table[caster.patrol_index]
		caster:MoveToPosition(target_pos)
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), target_pos)
		if distance < 120 then
			caster.patrol_index = caster.patrol_index + 1
			if caster.patrol_index > #caster.patrol_point_table then
				caster.patrol_index = 1
			end
		end
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 320, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
		if #enemies > 0 then
			caster:Stop()
			caster.locked_target = enemies[1]
			CustomAbilities:QuickAttachParticle("particles/msg_fx/big_excalamation.vpcf", caster, 3)	
			EmitSoundOn("Winterblight.CrowSentry.Spotted", caster)
			StartAnimation(caster, {duration = 1.75, activity = ACT_DOTA_FLAIL, rate = 0.5})
			caster:AddAbility("ability_mega_haste"):SetLevel(3)
			Timers:CreateTimer(1.8, function()
				local flee_position = Vector(12416, -1024)
				caster:MoveToPosition(flee_position)
			end)
			local delay = (WallPhysics:GetDistance2d(Vector(12416, -1024), caster:GetAbsOrigin())/750)
			Timers:CreateTimer(delay, function()
					local ghost = CreateUnitByName("npc_dummy_unit", caster.locked_target:GetAbsOrigin()+Vector(0,200,0), false, nil, nil, DOTA_TEAM_NEUTRALS)
					ghost:SetForwardVector(Vector(0,-1))
					ghost:SetOriginalModel("models/items/necrolyte/necro_ti9_immortal_skirt/necro_ti9_immortal_ghost.vmdl")
					ghost:SetModel("models/items/necrolyte/necro_ti9_immortal_skirt/necro_ti9_immortal_ghost.vmdl")
					ghost.target = caster.locked_target
					Events:smoothSizeChange(ghost, 0.1, 3.5, 40)
					EmitSoundOn("Winterblight.CrowSentry.HauntStart", ghost)
					local pfx = ParticleManager:CreateParticle("particles/roshpit/seafortress/big_dust.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
					ParticleManager:SetParticleControl(pfx, 0, ghost:GetAbsOrigin()+Vector(0,0,200))
					local blueFactor = RandomInt(50, 90)/100
					ParticleManager:SetParticleControl(pfx, 5, Vector(0.4, 0.5, blueFactor))
					ParticleManager:SetParticleControl(pfx, 2, Vector(0.2, 0.2, 0.2))
					Timers:CreateTimer(6, function()
						ParticleManager:DestroyParticle(pfx, false)
						ParticleManager:ReleaseParticleIndex(pfx)
					end)
				    ability:ApplyDataDrivenModifier(caster, ghost, "modifier_owl_sentry_ghost", {})
					Timers:CreateTimer(5, function()
						EmitSoundOn("Winterblight.CrowSentry.HauntEnd", ghost)
						Events:smoothSizeChange(ghost, 3.5, 0.01, 15)
					end)
					Timers:CreateTimer(5.5, function()
						UTIL_Remove(ghost)
					end)
			end)
			local luck = RandomInt(1, 4)
			if luck == 4 then
				Timers:CreateTimer(delay+6.5, function()
					EmitSoundOnLocationWithCaster(caster.locked_target:GetAbsOrigin(), "Winterblight.CrowSentry.HauntLaugh", caster)
				end)
			end
			Timers:CreateTimer(delay+8, function()
				EmitSoundOnLocationWithCaster(caster.locked_target:GetAbsOrigin(), "Winterblight.CrowSentry.HauntSpawn", caster)
				for i = 1, 6 + GameState:GetDifficultyFactor()*2, 1 do
					local spawn_pos = caster.locked_target:GetAbsOrigin() + RandomVector(RandomInt(180, 900))
					local fv = ((caster.locked_target:GetAbsOrigin() - spawn_pos)*Vector(1,1,0)):Normalized()
					local haunter = Winterblight:SpawnHaunter(spawn_pos, fv)
					Dungeons:AggroUnit(haunter)
				end
			end)
			Timers:CreateTimer(delay+23, function()
				EmitSoundOnLocationWithCaster(caster.locked_target:GetAbsOrigin(), "Winterblight.CrowSentry.HauntSpawn", caster)
				for i = 1, 6 + GameState:GetDifficultyFactor()*2, 1 do
					local spawn_pos = caster.locked_target:GetAbsOrigin() + RandomVector(RandomInt(180, 900))
					local fv = ((caster.locked_target:GetAbsOrigin() - spawn_pos)*Vector(1,1,0)):Normalized()
					local haunter = Winterblight:SpawnHaunter(spawn_pos, fv)
					Dungeons:AggroUnit(haunter)
				end
			end)
			Timers:CreateTimer(delay+38, function()
				EmitSoundOnLocationWithCaster(caster.locked_target:GetAbsOrigin(), "Winterblight.CrowSentry.HauntSpawn", caster)
				for i = 1, 6 + GameState:GetDifficultyFactor()*2, 1 do
					local spawn_pos = caster.locked_target:GetAbsOrigin() + RandomVector(RandomInt(180, 900))
					local fv = ((caster.locked_target:GetAbsOrigin() - spawn_pos)*Vector(1,1,0)):Normalized()
					local haunter = Winterblight:SpawnHaunter(spawn_pos, fv)
					Dungeons:AggroUnit(haunter)
				end
			end)
			Timers:CreateTimer(delay+58, function()
				UTIL_Remove(caster)
			end)
		end
	end
end

function owl_sentry_ghost_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	-- target:SetAbsOrigin(target.target:GetAbsOrigin()+Vector(0,200,0))
end

function winter_cast_ice_lance(event)
    local caster = event.caster
    local ability = event.ability
    --Timers:CreateTimer(0.3, function()
    local target = event.target_points[1]
    EmitSoundOn("Winterblight.IceLance", caster)
    local fv = ((target - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
    local casterOrigin = caster:GetAbsOrigin()
    winter_ice_lance_projectile(caster, fv, ability, "particles/econ/items/mirana/mirana_crescent_arrow/sorceress_ice_lance.vpcf", casterOrigin, 120)
end

function winter_ice_lance_projectile(caster, fv, ability, projectileParticle, casterOrigin, impactRadius)

    local start_radius = impactRadius
    local end_radius = impactRadius
    local range = 1800
    local speed = 1200

    local info =
    {
        Ability = ability,
        EffectName = projectileParticle,
        vSpawnOrigin = casterOrigin,
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
        vVelocity = fv * speed,
        bProvidesVision = false,
    }
    ProjectileManager:CreateLinearProjectile(info)
end

function winter_ice_lance_projectileHit(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability
    EmitSoundOn("hero_Crystal.projectileImpact", target)
    local damage = event.damage

    ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})

    local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_winter_wyvern/winter_wyvern_base_attack.vpcf", PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin() + Vector(0, 0, 70))
    ParticleManager:SetParticleControl(pfx, 1, target:GetAbsOrigin() + Vector(0, 0, 70))
    Timers:CreateTimer(0.1, function()
        ParticleManager:DestroyParticle(pfx, false)
    end)
end

function hinterlands_guardian_think(event)
	local caster = event.caster
	if not caster:IsAlive() then
		return false
	end
	if caster.aggro and caster:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local hookAbility = caster:FindAbilityByName("azalea_crystal_nova")
			if hookAbility:IsFullyCastable() then
				local targetPoint = enemies[1]:GetOrigin() + RandomVector(RandomInt(80, 320))
				local order =
				{
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = hookAbility:entindex(),
					Position = targetPoint
				}
				ExecuteOrderFromTable(order)
				return false
			end
		end
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local hookAbility = caster:FindAbilityByName("azalea_maiden_frostbite")
			if hookAbility:IsFullyCastable() then
				local order = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					TargetIndex = enemies[1]:entindex(),
					AbilityIndex = hookAbility:entindex(),
				}
				ExecuteOrderFromTable(order)
				return false
			end
		end

		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local hookAbility = caster:FindAbilityByName("winterblight_crystal_charge")
			if hookAbility:IsFullyCastable() then
				local targetPoint = enemies[1]:GetOrigin() + RandomVector(RandomInt(80, 320))
				local order =
				{
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = hookAbility:entindex()
				}
				ExecuteOrderFromTable(order)
				return false
			end
		end
	end
end

function winterblight_onu_attack_land(event)
	local target = event.target
	local attacker = event.attacker
	local ability = event.ability
	local caster = event.caster
	if target.dummy then
		return false
	end
	local proc_chance = event.proc_chance
	local proc = Filters:GetProc(attacker, proc_chance)
	if target:HasModifier("modifier_glint_no_proc") then
		local newNoProcStacks = target:GetModifierStackCount("modifier_glint_no_proc", caster) - 1
		if newNoProcStacks > 0 then
			target:SetModifierStackCount("modifier_glint_no_proc", caster, newNoProcStacks)
		else
			target:RemoveModifierByName("modifier_glint_no_proc")
		end

		return false
	end
	if proc then
		if attacker:IsAlive() then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_glint_no_proc", {duration = 1})
			target:SetModifierStackCount("modifier_glint_no_proc", caster, 2)
			local newPosition = target:GetAbsOrigin() + target:GetForwardVector() *- 120
			local position = attacker:GetAbsOrigin()
			local newPosition = WallPhysics:WallSearch(position, newPosition, target)
			FindClearSpaceForUnit(attacker, newPosition, false)
			attacker:SetForwardVector(target:GetForwardVector() * Vector(1, 1, 0))
			event.ability:ApplyDataDrivenModifier(event.caster, attacker, "modifier_blinded_glint_buff", {duration = 1.2})
			ProjectileManager:ProjectileDodge(attacker)

			local particleName = "particles/econ/items/meepo/meepo_diggers_divining_rod/meepo_divining_rod_poof_end_rays_burst.vpcf"
			local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, attacker)
			ParticleManager:SetParticleControlEnt(pfx, 0, attacker, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", position, true)
			local pfx2 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, attacker)
			ParticleManager:SetParticleControlEnt(pfx2, 0, attacker, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", newPosition, true)
			Timers:CreateTimer(1, function()
				ParticleManager:DestroyParticle(pfx, false)
				ParticleManager:DestroyParticle(pfx2, false)
			end)
			EmitSoundOnLocationWithCaster(newPosition, "RPCItem.GlintOfOnu", attacker)
		end
	end

end

function winter_mountain_tombstone_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	if caster.color_change then
		return false
	end
	if caster:GetHealth()/caster:GetMaxHealth() < 0.35 then
		caster.color_change = true
		Events:smoothColorTransition(caster, Vector(134, 158, 255), Vector(226, 36, 36), 45)
		winter_mountain_tombstone_sonic_call(event)
	end
	if caster:GetHealth()%(25 + (GameState:GetDifficultyFactor()*10)) == 0 then
		local screamMinion = nil
		local luck = RandomInt(1, 3)
		if luck == 1 then
			screamMinion = "winterblight_haunter"
		elseif luck == 2 then
			screamMinion = "winterblight_yozario"
		elseif luck == 3 then
			screamMinion = "winterblight_haunter"
		end
		caster.screamMinion = screamMinion
		tombstone_scream(event)
	end
end

function tombstone_scream(event)
	local caster = event.caster
	local ability = event.ability
	if not caster:HasModifier("modifier_tombstone_screaming") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_tombstone_screaming", {duration = 10})
		StartSoundEvent("Winterblight.Tombstone.StoneGazeScream", caster)
		Timers:CreateTimer(10, function()
			if caster and IsValidEntity(caster) and caster:IsAlive() then
				StopSoundEvent("Winterblight.Tombstone.StoneGazeScream", caster)
			end
		end)
	end
end

function winter_mountain_tombstone_screaming_think(event)
	local caster = event.caster
	local ability = event.ability
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_beastmaster/beastmaster_primal_roar.vpcf", caster, 1)
	local luck = RandomInt(1, 5)
	if luck <= 2 then
		local unit = Enemies:SpawnEnemyUnit(caster.screamMinion, caster:GetAbsOrigin()+RandomVector(RandomInt(210, 280)), RandomVector(1), false)
		CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/blue_raze.vpcf", unit:GetAbsOrigin(), 3)
	end
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			local v1 = ((caster:GetAbsOrigin() - enemy:GetAbsOrigin())*Vector(1,1,0)):Normalized()
			local v2 = enemy:GetForwardVector()
			local angle = WallPhysics:angle_between_vectors(v1, v2)
			if angle < 70 then
				if enemy:HasModifier("modifier_tombstone_petrify") then
				else
					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_looking_at_tombstone_effect", {duration = 0.5})
					enemy:ApplyAndIncrementStack(ability, caster, "modifier_looking_at_tombstone_stacks", 1, 7, 7)
					if enemy:GetModifierStackCount("modifier_looking_at_tombstone_stacks", caster) == 7 then
						enemy:RemoveModifierByName("modifier_looking_at_tombstone_stacks")
						ability:ApplyDataDrivenModifier(caster, enemy, "modifier_tombstone_petrify", {duration = event.petrify_duration})
						EmitSoundOn("Winterblight.Tombstone.StoneGazeStun", enemy)
						CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_earth_spirit/earthspirit_petrify_shockwave.vpcf", enemy, 2)
					end
				end
			end
		end
	end
end

function winter_mountain_tombstone_die(event)
	local caster = event.caster
	local ability = event.ability
	local particlePos = caster:GetAbsOrigin()
	local tombstone_index = caster.index
	-- caster:SetAbsOrigin(caster:GetAbsOrigin() - Vector(0,0,-800))
	CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_warlock/chaos_blast_impact.vpcf", particlePos, 5)
	EmitSoundOn("Winterblight.Tombstone.Explode", caster)
	event.new_sound = true
	winter_mountain_tombstone_sonic_call(event)

	Timers:CreateTimer(1, function()
			local ghost = CreateUnitByName("npc_dummy_unit", caster:GetAbsOrigin()+Vector(0,200,0), false, nil, nil, DOTA_TEAM_NEUTRALS)
			ghost:SetForwardVector(Vector(0,-1))
			ghost:SetOriginalModel("models/creeps/neutral_creeps/n_creep_ghost_b/n_creep_ghost_b.vmdl")
			ghost:SetModel("models/creeps/neutral_creeps/n_creep_ghost_b/n_creep_ghost_b.vmdl")
			Events:smoothSizeChange(ghost, 0.1, 3.5, 40)
			EmitSoundOn("Winterblight.Tombstone.GhostScare", ghost)
			Timers:CreateTimer(1, function()
				CustomAbilities:QuickParticleAtPoint("particles/econ/items/templar_assassin/templar_assassin_butterfly/templar_assassin_trap_explode_butterfly.vpcf", particlePos, 5)
			end)
			Timers:CreateTimer(3.2, function()
				EmitSoundOn("Winterblight.Tombstone.GhostScareEnd", ghost)
				Events:smoothSizeChange(ghost, 3.5, 2, 90)
				for i = 1, 90, 1 do
					Timers:CreateTimer(i*0.03, function()
						ghost:SetAbsOrigin(ghost:GetAbsOrigin() + Vector(0,0,15))
					end)
				end
			end)
			Timers:CreateTimer(7.2, function()
				UTIL_Remove(ghost)
				Winterblight:InitGraveGhost(tombstone_index)
			end)
	end)
end

function winter_mountain_tombstone_sonic_call(event)
	local caster = event.caster
	local ability = event.ability
	if caster.color_change then
		if event.new_sound then
			EmitSoundOn("Winterblight.Tombstone.SonicScreamDeep", caster)
		else
			EmitSoundOn("Winterblight.Tombstone.SonicScream", caster)
		end
		local baseFV = RandomVector(1)
		for i = 1, 4, 1 do
		    local start_radius = 120
		    local end_radius = 360
		    local range = 800
		    local speed = 1200
		    local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/4)
		    local info =
		    {
		        Ability = ability,
		        EffectName = "particles/units/heroes/hero_queenofpain/queen_sonic_wave.vpcf",
		        vSpawnOrigin = caster:GetAbsOrigin()+Vector(0,0,40),
		        fDistance = range,
		        fStartRadius = start_radius,
		        fEndRadius = end_radius,
		        Source = caster,
		        StartPosition = "attach_origin",
		        bHasFrontalCone = true,
		        bReplaceExisting = false,
		        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		        fExpireTime = GameRules:GetGameTime() + 5.0,
		        bDeleteOnHit = false,
		        vVelocity = fv * speed,
		        bProvidesVision = false,
		    }
		    ProjectileManager:CreateLinearProjectile(info)
		end	
	end
end

function winter_mountain_tombstone_sonic_hit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	ability:ApplyDataDrivenModifier(caster, target, "modifier_tombstone_pushback", {duration = 1.75})
	ApplyDamage({victim = target, attacker = caster, damage = event.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
end

function winter_mountain_scream_pushback(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	local direction = ((target:GetAbsOrigin() - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	target:SetAbsOrigin(target:GetAbsOrigin() + direction*7)
end

function winter_mountain_scream_pushback_end(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
end

function wraithfire_linear_start(event)
	local caster = event.caster
	local ability = event.ability
	local fv = caster:GetForwardVector()
	EmitSoundOn("Hero_SkeletonKing.Hellfire_Blast", caster)
	for i = -1, 1, 1 do
		local forward = WallPhysics:rotateVector(fv, math.pi/9*i)
		local spellOrigin = caster:GetAbsOrigin()+Vector(0,0,80)
		local info = 
		{
			Ability = ability,
	        	EffectName = "particles/units/heroes/hero_skeletonking/hellfireblast_linear.vpcf",
	        	vSpawnOrigin = spellOrigin,
	        	fDistance = 1450,
	        	fStartRadius = 140,
	        	fEndRadius = 140,
	        	Source = caster,
	        	StartPosition = "attach_attack2",
	        	bHasFrontalCone = true,
	        	bReplaceExisting = false,
	        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	        	fExpireTime = GameRules:GetGameTime() + 7.0,
			bDeleteOnHit = false,
			vVelocity = forward * 800,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
	end
end 

function wraithguard_hellfire_impact(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	EmitSoundOn("Hero_SkeletonKing.Hellfire_BlastImpact", target)
	local damage = event.damage
	local stun_duration = event.stun_duration
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
	PopupDamage(target, damage)
	Filters:ApplyStun(caster, stun_duration, target)
end

function grave_ghost_thinking(event)
	local caster = event.caster
	local ability = event.ability
	if caster:HasModifier("modifier_grave_ghost_think_lock") then
		return false
	end
	if caster.sequence == 0 then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster.search_position, nil, 480, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			caster:RemoveModifierByName("modifier_grave_ghost_animation_wait")
			caster.sequence = 1
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_grave_ghost_think_lock", {duration = 3})
			StartAnimation(caster, {duration = 2.0, activity = ACT_DOTA_ATTACK, rate = 0.7})
			EmitSoundOn("Winterblight.Tombstone.GhostScareEnd", caster)
		end
	elseif caster.sequence == 1 then
		StartAnimation(caster, {duration = 9999, activity = ACT_DOTA_RUN, rate = 1})
		EmitSoundOn("Winterblight.Tombstone.GhostScare", caster)
		caster.sequence = 2
	elseif caster.sequence == 2 then
		if not caster.sequence_2_spawns then
			caster.sequence_2_spawns = 0
		end
		if caster.sequence_2_spawns < 15 then
			caster.sequence_2_spawns = caster.sequence_2_spawns + 1
			local position = caster.search_position + RandomVector(RandomInt(0, 480))
			local spawnTable = {"winterblight_frozen_phantom", "winterblight_frozen_soul", "winterblight_frozen_mage"}
			local haunter =  Enemies:SpawnEnemyUnit(spawnTable[RandomInt(1, #spawnTable)], position, fv, false)
			CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/blue_raze.vpcf", haunter:GetAbsOrigin(), 3)
			EmitSoundOn("Winterblight.GraveGhostSpawn", haunter)		
			Dungeons:AggroUnit(haunter)	
			ability:ApplyDataDrivenModifier(caster, haunter, "modifier_grave_ghost_summoned_unit", {})
		end
	elseif caster.sequence == 3 then
		caster.sequence = 4
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_grave_ghost_think_lock", {duration = 1.25})
		StartAnimation(caster, {duration = 2.0, activity = ACT_DOTA_ATTACK, rate = 0.7})
		-- EmitSoundOn("Winterblight.EvilExplosion.Ghost", caster)
	elseif caster.sequence == 4 then
		Dungeons:AggroUnit(caster)
		caster:RemoveModifierByName("modifier_grave_ghost_starting_passive")
		caster.sequence = 5
	end
end

function grave_ghost_summon_death(event)
	local caster = event.caster
	if not caster.sequence_2_kills then
		caster.sequence_2_kills = 0
	end
	caster.sequence_2_kills = caster.sequence_2_kills + 1
	if caster.sequence_2_kills == 15 then
		caster.sequence = 3
	end
end

function winter_ghost_blink_activate(event)
	local caster = event.caster
	local ability = event.ability

	EmitSoundOn("Winterblight.GhostBlink", caster)

	local particleName = "particles/econ/events/nexon_hero_compendium_2014/blink_dagger_end_nexon_hero_cp_2014.vpcf"
	local pfx1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx1, 0, caster:GetAbsOrigin())
	local target = event.target_points[1]
	local casterOrigin = caster:GetAbsOrigin()
	target = WallPhysics:WallSearch(casterOrigin, target, caster)
	-- local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_undying/undying_loadout.vpcf", PATTACH_ABSORIGIN, event.caster )
	--     ParticleManager:SetParticleControl( pfx, 0, position )
	local newPosition = target
	FindClearSpaceForUnit(caster, newPosition, false)
	local pfx2 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx2, 0, newPosition)
	Timers:CreateTimer(4, function()
		ParticleManager:DestroyParticle(pfx1, false)
		ParticleManager:DestroyParticle(pfx2, false)
	end)
end

function winter_ghost_blink_ai_thinker(event)
	local caster = event.caster
	local ability = event.ability
	if caster:GetTeamNumber() == DOTA_TEAM_NEUTRALS and caster.aggro then
		if ability:IsFullyCastable() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				local castPoint = enemies[1]:GetAbsOrigin()+RandomVector(180)
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = ability:entindex(),
					Position = castPoint
				}

				ExecuteOrderFromTable(newOrder)
			end
		end
	end
end

function defiler_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	local currentStacks = target:GetModifierStackCount("modifier_defiler_attack_power_drain", caster)
	local increment = 1
	local new_stacks = math.min(currentStacks + increment, event.max_stacks)

	if target:HasModifier("modifier_defiler_attack_power_drain") then
		local buff = target:FindModifierByNameAndCaster("modifier_defiler_attack_power_drain", caster)
		if buff then
			buff:SetDuration(event.duration, true)
		else
			ability:ApplyDataDrivenModifier(caster, target, "modifier_defiler_attack_power_drain", {duration = event.duration})
		end
	else
		ability:ApplyDataDrivenModifier(caster, target, "modifier_defiler_attack_power_drain", {duration = event.duration})
	end
	target:SetModifierStackCount("modifier_defiler_attack_power_drain", caster, new_stacks)
	caster:ApplyAndIncrementStack(ability, caster, "modifier_defiler_attack_power_gain", 1, event.max_stacks, event.duration)
end

function grave_ghost_death(event)
	local caster = event.caster
	local ability = event.ability

	local skull = CreateUnitByName("npc_flying_dummy_vision", caster:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
	skull:SetDayTimeVisionRange(500)
	skull:SetNightTimeVisionRange(500)
	skull:RemoveModifierByName("dummy_unit")
	Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, skull, "modifier_wb_black_skull", {})
	local dummy_ability = skull:FindAbilityByName("dummy_unit")
	dummy_ability:ApplyDataDrivenModifier(skull, skull, "dummy_unit", {})
	skull:SetForwardVector(caster:GetForwardVector())
	skull:SetModelScale(3)
	skull:SetModel("models/heroes/silencer/silencer_curse_skull.vmdl")
	skull:SetOriginalModel("models/heroes/silencer/silencer_curse_skull.vmdl")
	
	skull.grave_index = caster.grave_index
	skull.phase = 0
	Winterblight:EvilExplosion(caster:GetAbsOrigin())
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.EvilExplosion.Ghost", Events.GameMaster)
	EmitSoundOn("Winterblight.Tombstone.GhostScare", skull)
	skull:SetAbsOrigin(skull:GetAbsOrigin() + Vector(0,0,230))
	if skull.grave_index == 1 then
		skull.targetPoint = Vector(2419, 14899, 502)
		skull.targetDirection = Vector(0,-1)
		skull.boss_spawn = "winterblight_baron_moredi"
		skull.introSound = "Winterblight.BaronMoredi.Intro"
		skull.extra_height = 200
	elseif skull.grave_index == 2 then
		skull.targetPoint = Vector(5506, 10892, 1100)
		skull.targetDirection = Vector(-0.2,1)
		skull.boss_spawn = "winterblight_lich_king_sonder"
		skull.introSound = "Winterblight.LichKingSonder.Intro"
		skull.extra_height = 880
	elseif skull.grave_index == 3 then
		skull.targetPoint = Vector(10370, 11106, 1448)
		skull.targetDirection = Vector(-1,0)
		skull.boss_spawn = "winterblight_wrath_queen_asyria"
		skull.introSound = "Winterblight.LadyAsyria.Intro"
		skull.extra_height = 1250
	end
	Timers:CreateTimer(3, function()
		skull.phase = 1
		-- skull:MoveToPosition(skull.targetPoint)
	end)
	skull.main_phase = 0
	StartSoundEvent("Winterblight.BlackSkull.LP", skull)
	skull.float_height = 280
	
end

function black_skull_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local skull = event.target

	if not skull.interval then
		skull.interval = RandomInt(0, 89)
	end
	-- skull:SetAbsOrigin(skull:GetAbsOrigin() + Vector(0, 0, 5) * math.cos(2 * math.pi * skull.interval / 90))
	local movement = Vector(0, 0, 8) * math.cos(2 * math.pi * skull.interval / 90)
	skull.interval = skull.interval + 1
	local rotatedFV = WallPhysics:rotateVector(skull:GetForwardVector(), 2 * math.pi / 360)
	skull:SetForwardVector(rotatedFV)
	if skull.interval == 90 then
		skull.interval = 0
	end

	if skull.phase == 0 then
		skull:SetAbsOrigin(skull:GetAbsOrigin() + movement)
		skull:SetVisualFlyHeight(skull.float_height)
	elseif skull.phase == 1 then
		local distance = WallPhysics:GetDistance2d(skull:GetAbsOrigin(), skull.targetPoint)
		if skull.float_height < (470 + skull.extra_height) then
			skull.float_height = skull.float_height + 10
			skull:SetVisualFlyHeight(skull.float_height)
		end
		local distance_from_ground = (skull.float_height + skull:GetAbsOrigin().z) - GetGroundHeight(skull:GetAbsOrigin(), skull)
		if distance_from_ground < 450 then
			skull.float_height = skull.float_height + 10
			skull:SetVisualFlyHeight(skull.float_height)
		elseif distance_from_ground > 475 then
			skull.float_height = skull.float_height - 10
			skull:SetVisualFlyHeight(skull.float_height)
		end
		if skull.main_phase == 2 then
			skull.float_height = 300
			skull:SetVisualFlyHeight(skull.float_height)
		end
		if distance < 100 then
			skull.phase = 2
			StopSoundEvent("Winterblight.BlackSkull.LP", skull)
			if skull.main_phase == 0 then
				EmitSoundOn("Winterblight.BlackSkull.StartDrop", skull)
			elseif skull.main_phase == 1 then
				EmitSoundOn("Winterblight.SkullReachEndPhase2", skull)
				CustomAbilities:QuickAttachParticle("particles/roshpit/items/ankh_of_ancients_respawn_timer.vpcf", skull, 32)
				if not Winterblight.MiniBossSkulls then
					Winterblight.MiniBossSkulls = {}
				end
				table.insert(Winterblight.MiniBossSkulls, skull)
				if #Winterblight.MiniBossSkulls == 3 then
					for i = 1, #Winterblight.MiniBossSkulls, 1 do
						Winterblight.MiniBossSkulls[i].phase = 4
					end
				end
			elseif skull.main_phase == 2 then
				local index = skull.grave_index
				EmitSoundOn("Winterblight.EvilExplosion.Highlight", skull)
				CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/blue_raze.vpcf", skull:GetAbsOrigin()+Vector(0,0,200), 3)
				Winterblight:EvilExplosion(skull:GetAbsOrigin())
				UTIL_Remove(skull)
				local key = Entities:FindByNameNearest("CastleDoorKey"..index, Vector(10699, 13819, 1215), 2000)
				key:SetAbsOrigin(key:GetAbsOrigin() + Vector(0,0,660))
				EmitSoundOnLocationWithCaster(key:GetAbsOrigin(), "Winterblight.KeyClick", Events.GameMaster)


				CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/blue_raze.vpcf", key:GetAbsOrigin(), 3)
		
				Timers:CreateTimer(1, function()
					if not Winterblight.CastleDoorKeyCount then
						Winterblight.CastleDoorKeyCount = 0
					end
					Winterblight.CastleDoorKeyCount = Winterblight.CastleDoorKeyCount + 1
					if Winterblight.CastleDoorKeyCount == 3 then
						
						local key1 = Entities:FindByNameNearest("CastleDoorKey1", Vector(10699, 13819, 1615), 1500)
						local key2 = Entities:FindByNameNearest("CastleDoorKey2", Vector(10699, 13606, 1615), 1500)
						local key3 = Entities:FindByNameNearest("CastleDoorKey3", Vector(10699, 13402, 1615), 1500)
						local keys = {key1, key2, key3}
						for i = 1, #keys, 1 do
							Events:objectShake(keys[i], 60, 30, false, true, true, "Winterblight.KeyShake", 5)
							Timers:CreateTimer(1.9, function()
								CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/blue_raze.vpcf", keys[i]:GetAbsOrigin(), 3)
								CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_medusa/ice_shatter.vpcf", keys[i]:GetAbsOrigin(), 4)
								EmitSoundOnLocationWithCaster(keys[i]:GetAbsOrigin(), "Winterblight.KeyExplode", Events.GameMaster)
								UTIL_Remove(keys[i])
							end)
						end
						Timers:CreateTimer(2, function()
							local walls = Entities:FindAllByNameWithin("MainCastleDoor", Vector(10757, 13568, 1319 + Winterblight.ZFLOAT), 2400)
							Events:smoothColorTransition(walls[1], Vector(41,43,46), Vector(141,43,46), 70)
						end)
						Timers:CreateTimer(5, function()
							Winterblight:OpenWinterblightCastle()
						end)
					end
				end)
			end
		else
			local direction = ((skull.targetPoint - skull:GetAbsOrigin())*Vector(1,1,0)):Normalized()
			skull:SetAbsOrigin(skull:GetAbsOrigin() + direction*20 + movement)
		end
	elseif skull.phase == 2 then
		local distanceFromGround = (skull:GetAbsOrigin().z + skull.float_height) - GetGroundHeight(skull:GetAbsOrigin(), skull)
		if skull.main_phase == 0 then
			if distanceFromGround > 180 then
				skull:SetAbsOrigin(skull:GetAbsOrigin() - Vector(0,0,60))
			else
				skull:SetAbsOrigin(skull:GetAbsOrigin() - Vector(0,0,60))
				AddFOWViewer(DOTA_TEAM_GOODGUYS, skull:GetAbsOrigin(), 750, 8, true)
				skull.phase = 3
				local miniboss = Enemies:SpawnEnemyUnit(skull.boss_spawn, skull.targetPoint, skull.targetDirection, false)
				Winterblight:EvilExplosion(miniboss:GetAbsOrigin())
				miniboss.grave_index = caster.grave_index
				EmitSoundOn("Winterblight.EvilExplosion.Main", miniboss)
				EmitSoundOn("Winterblight.EvilExplosion.Highlight", miniboss)
				local intro_sound = skull.introSound
				miniboss.grave_index = skull.grave_index
				UTIL_Remove(skull)
				miniboss.cantAggro = true
				Timers:CreateTimer(2, function()
					EmitSoundOn(intro_sound, miniboss)
				end)
				miniboss:AddAbility("winterblight_outside_castle_miniboss_ability"):SetLevel(1)
				miniboss.fight_phase = 1
				Timers:CreateTimer(5, function()
					if miniboss:GetUnitName() == "winterblight_baron_moredi" then
						miniboss.cantAggro = nil
						EmitSoundOn("Winterblight.BaronMoredi.SpawnArmy", miniboss)
						local basePosition = miniboss:GetAbsOrigin() - miniboss:GetForwardVector()*300
						StartAnimation(miniboss, {duration = 1, activity = ACT_DOTA_ATTACK, rate = 0.8})
						for i = 0, 2, 1 do
							for k = 0, 3, 1 do
								local spawnPosition = basePosition - miniboss:GetForwardVector()*(i*120) + Vector((k-1.5)*120)
								local wraith = Enemies:SpawnEnemyUnit("winterblight_wraithguard", spawnPosition, Vector(0,-1), false)
								CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/blue_raze.vpcf", wraith:GetAbsOrigin(), 3)
								EmitSoundOn("Winterblight.GraveGhostSpawn", wraith)
							end
						end
					elseif miniboss:GetUnitName() == "winterblight_wrath_queen_asyria" then
						miniboss.cantAggro = nil
						EmitSoundOn("Winterblight.LadyAsyria.SummonArmy", miniboss)
						StartAnimation(miniboss, {duration = 1, activity = ACT_DOTA_CAST_ABILITY_3, rate = 0.8})
						local positionTable = {Vector(10368, 11520), Vector(10368, 10752), Vector(10112, 11520), Vector(10112, 10752)}
						for i = 1, #positionTable, 1 do
							local fv = (Vector(8832, 11904) - positionTable[i]):Normalized()
							local wraith = Enemies:SpawnEnemyUnit("winterblight_soul_fletcher", positionTable[i], fv, false)
							CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/blue_raze.vpcf", wraith:GetAbsOrigin(), 3)
							EmitSoundOn("Winterblight.GraveGhostSpawn", wraith)
						end
					end
				end)
				if miniboss:GetUnitName() == "winterblight_lich_king_sonder" then
					local sonder_passive = miniboss:FindAbilityByName("winterblight_sonder_passive")
					sonder_passive:ApplyDataDrivenModifier(miniboss, miniboss, "modifier_sonder_temp_invul", {duration = 1})
					Timers:CreateTimer(1, function()
						sonder_passive:ApplyDataDrivenModifier(miniboss, miniboss, "modifier_winterblight_sonder_waiting", {})
					end)
					miniboss.cantAggro = true
				end
			end
		elseif skull.main_phase == 1 then
			skull:SetAbsOrigin(skull:GetAbsOrigin() + movement)
			skull:SetForwardVector(Vector(-1,0))
		end
	elseif skull.phase == 4 then
		local distanceFromGround = (skull:GetAbsOrigin().z + skull.float_height) - GetGroundHeight(skull:GetAbsOrigin(), skull)
		if skull.main_phase == 1 then
			if distanceFromGround > 180 then
				skull:SetAbsOrigin(skull:GetAbsOrigin() - Vector(0,0,60))
			else
				skull:SetAbsOrigin(skull:GetAbsOrigin() - Vector(0,0,60))
				AddFOWViewer(DOTA_TEAM_GOODGUYS, skull:GetAbsOrigin(), 750, 8, true)
				skull.phase = 4
				local miniboss = Enemies:SpawnEnemyUnit(skull.boss_spawn, skull.targetPoint, skull.targetDirection, false)
				Winterblight:EvilExplosion(miniboss:GetAbsOrigin())
				miniboss.grave_index = caster.grave_index
				EmitSoundOn("Winterblight.EvilExplosion.Main", miniboss)
				EmitSoundOn("Winterblight.EvilExplosion.Highlight", miniboss)
				local intro_sound = skull.introSound
				miniboss.grave_index = skull.grave_index
				UTIL_Remove(skull)
				Timers:CreateTimer(2, function()
					EmitSoundOn(intro_sound, miniboss)
				end)
				miniboss:AddAbility("winterblight_outside_castle_miniboss_ability"):SetLevel(1)
				miniboss.fight_phase = 2
				miniboss:RemoveModifierByName("modifier_miniboss_cant_die")
				Timers:CreateTimer(3, function()
					Dungeons:AggroUnit(miniboss)
				end)
			end
		end
	end
end

function winter_ghost_spark_throw(event)
	local caster = event.caster
	local ability = event.ability
	local spark_count = 12

	local base_damage = event.base_damage
	ability.damage = base_damage

	ability.paralyze_duration = event.paralyze_duration
	local particle = "particles/roshpit/winterblight/ghost_arcanist_projectile_concoction_projectile_linear.vpcf"
	local range = 1000
	EmitSoundOn("Winterblight.Cavern.WraithSpark.Throw", caster)
	for i = 1, spark_count, 1 do
		local rotation_adjustment = 0
		local fv = WallPhysics:rotateVector(caster:GetForwardVector(), 2 * math.pi * i/ spark_count)
		local speed = 1500
		local info =
		{
			Ability = ability,
			EffectName = particle,
			vSpawnOrigin = caster:GetAbsOrigin() + Vector(0, 0, 20),
			fDistance = range,
			fStartRadius = 170,
			fEndRadius = 170,
			Source = caster,
			StartPosition = "attach_attack1",
			bHasFrontalCone = true,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 5.0,
			bDeleteOnHit = false,
			vVelocity = fv * speed,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
	end
end

function winter_ghost_spark_impact(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local paralyze_duration = ability.paralyze_duration

	local current_stacks = target:GetModifierStackCount("modifier_cavern_spark_paralyze_immunity", target)
	local paralyze_immunity = 1
	if current_stacks <= 5 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_cavern_spark_paralyze_immunity", {duration = paralyze_immunity})
		ability:ApplyDataDrivenModifier(caster, target, "modifier_cavern_spark_paralyze", {duration = paralyze_duration})
		target:SetModifierStackCount("modifier_cavern_spark_paralyze_immunity", caster, current_stacks + 1)
	end
	StartAnimation(target, {duration = paralyze_duration, activity = ACT_DOTA_FLAIL, rate = 2.2})
	EmitSoundOn("Winterblight.GraveGuardGhost.Impact", target)
	local particleName = "particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf"
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin() + Vector(0, 0, target:GetBoundingMaxs().z + 40))
	ParticleManager:SetParticleControl(pfx, 1, target:GetAbsOrigin() + Vector(0, 0, target:GetBoundingMaxs().z + 60))
	Timers:CreateTimer(0.3, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	Filters:TakeArgumentsAndApplyDamage(target, caster, ability.damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_NATURE, RPC_ELEMENT_LIGHTNING)
end

function asyria_arrow_throw(event)
	local caster = event.caster
	local ability = event.ability
	Timers:CreateTimer(0.7, function()
		if caster and caster:IsAlive() then
			local spark_count = event.number_of_arrows

			local base_damage = event.base_damage
			ability.damage = base_damage + OverflowProtectedGetAverageTrueAttackDamage(caster)*(event.percent_attack_power/100)

			ability.duration = event.duration
			local particle = "particles/units/heroes/hero_drow/drow_multishot_proj_linear_proj.vpcf"
			local range = 1500
			local divisor = 15
			if spark_count == 3 then
				divisor = 17
			elseif spark_count == 4 then
				divisor = 18
			elseif spark_count == 5 then
				divisor = 22
			end
			EmitSoundOn("Winterblight.Asyria.FrostArrows", caster)
			for i = 1, spark_count, 1 do
				local rotation_adjustment = spark_count / 2
				local fv = WallPhysics:rotateVector(caster:GetForwardVector(), 2 * math.pi * (i - rotation_adjustment) / divisor)
				local speed = 1500
				local info =
				{
					Ability = ability,
					EffectName = particle,
					vSpawnOrigin = caster:GetAbsOrigin() + Vector(0, 0, 20),
					fDistance = range,
					fStartRadius = 170,
					fEndRadius = 170,
					Source = caster,
					StartPosition = "attach_attack1",
					bHasFrontalCone = true,
					bReplaceExisting = false,
					iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
					iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
					iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					fExpireTime = GameRules:GetGameTime() + 5.0,
					bDeleteOnHit = false,
					vVelocity = fv * speed,
					bProvidesVision = false,
				}
				projectile = ProjectileManager:CreateLinearProjectile(info)
			end
		end
	end)
end

function asyria_arrow_impact(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local duration = ability.duration

	

	EmitSoundOn("Winterblight.Asyria.FrostArrowImpact", target)
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_lich/lich_frost_nova.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin() + Vector(0, 0, target:GetBoundingMaxs().z + 40))
	ParticleManager:SetParticleControl(pfx, 1, target:GetAbsOrigin() + Vector(0, 0, target:GetBoundingMaxs().z + 60))
	Timers:CreateTimer(0.3, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 240, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_asyria_arrow_slow", {duration = duration})
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, ability.damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_ICE, RPC_ELEMENT_UNDEAD)
		end
	end
	
end

function sonder_frozen_thinking(event)
	local caster = event.caster
	local ability = event.ability
	if caster.search_lock then
		return false
	end
	if not caster.orig_pos then
		caster.orig_pos = caster:GetAbsOrigin()
	end
	local searchPosition = Vector(5363, 11426)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), searchPosition, nil, 280, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		if not caster.search_count then
			caster.search_count = 0
		end
		caster.search_count = caster.search_count + 1
		Events:objectShake(caster, 2, caster.search_count*3, true, false, false, "Winterblight.SonderShake", 2)
		if caster.search_count == 20 then
			caster.search_lock = true
			caster:RemoveModifierByName("modifier_winterblight_sonder_waiting")
			StartAnimation(caster, {duration = 3, activity = ACT_DOTA_SPAWN, rate = 1})
			Winterblight:EvilExplosion(caster:GetAbsOrigin())
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.EvilExplosion.Ghost", Events.GameMaster)
			caster.cantAggro = false
			Dungeons:AggroUnit(caster)
			Timers:CreateTimer(1.2, function()
				local positionTable = {Vector(4992, 11723), Vector(5681, 11850), Vector(5681, 11392), Vector(5060, 11354), Vector(5690, 11053), Vector(5140, 11053)}
				for i = 1, GameState:GetDifficultyFactor() + Winterblight.Stones, 1 do
					local fv = (searchPosition - positionTable[i]):Normalized()
					local wraithguard = Enemies:SpawnEnemyUnit("winterblight_wraithguard_elite", positionTable[i], fv, false)
					Dungeons:AggroUnit(wraithguard)
					CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/blue_raze.vpcf", wraithguard:GetAbsOrigin(), 3)
					EmitSoundOn("Winterblight.GraveGhostSpawn", wraithguard)	
				end
			end)
		end
	else
		caster.search_count = 0
		caster:SetAbsOrigin(caster.orig_pos)
	end	
end

function accursed_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	-- local pfx = ParticleManager:CreateParticle("particles/econ/items/shadow_shaman/shadow_shaman_ti8/shadow_shaman_crimson_ti8_ether_shock.vpcf", PATTACH_POINT, nil)
	-- ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT, "attach_attack1", caster:GetAbsOrigin(), true)
	-- ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
	-- ParticleManager:SetParticleControlEnt(pfx, 4, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
	-- Timers:CreateTimer(2.5, function()
	-- 	ParticleManager:DestroyParticle(pfx, false)
	-- end)

	ability:ApplyDataDrivenModifier(caster, target, "modifier_accursed_effect", {duration = event.root_duration})
	ApplyDamage({victim = target, attacker = caster, damage = event.damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
end

function winter_life_drain_target_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	ApplyDamage({victim = target, attacker = caster, damage = event.damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
	Filters:ApplyHeal(caster, caster, event.damage*event.life_drain_heal_mult, true, true, ability)
end

function wintermini_boss_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if not caster.aggro then
		return false
	end
	if caster.cantAggro then
		return false
	end
	if caster.lock then
		return false
	end
	if caster:GetHealth() < 10 then
		local skull = CreateUnitByName("npc_flying_dummy_vision", caster:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
		skull:SetDayTimeVisionRange(500)
		skull:SetNightTimeVisionRange(500)
		skull:RemoveModifierByName("dummy_unit")
		Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, skull, "modifier_wb_black_skull", {})
		local dummy_ability = skull:FindAbilityByName("dummy_unit")
		dummy_ability:ApplyDataDrivenModifier(skull, skull, "dummy_unit", {})
		skull:SetForwardVector(caster:GetForwardVector())
		skull:SetModelScale(3)
		skull:SetModel("models/heroes/silencer/silencer_curse_skull.vmdl")
		skull:SetOriginalModel("models/heroes/silencer/silencer_curse_skull.vmdl")
		
		skull.grave_index = caster.grave_index
		skull.phase = 0
		Winterblight:EvilExplosion(caster:GetAbsOrigin())
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.EvilExplosion.Ghost", Events.GameMaster)
		if caster:GetUnitName() == "winterblight_baron_moredi" then
			EmitSoundOn("Winterblight.BaronMoredi.Die", skull)
		elseif caster:GetUnitName() == "winterblight_lich_king_sonder" then
			EmitSoundOn("Winterblight.LichKingSonder.Pain", skull)
		elseif caster:GetUnitName() == "winterblight_wrath_queen_asyria" then
			EmitSoundOn("Winterblight.LadyAsyria.Pain", skull)
		end
		skull:SetAbsOrigin(skull:GetAbsOrigin() + Vector(0,0,100))
		if skull.grave_index == 1 then
			skull.targetPoint = Vector(9984, 13931, 1280)
			skull.targetDirection = Vector(-1,0)
			skull.boss_spawn = "winterblight_baron_moredi"
			skull.introSound = "Winterblight.BaronMoredi.Intro"
			skull.extra_height = 500
		elseif skull.grave_index == 2 then
			skull.targetPoint = Vector(9984, 13596, 1280)
			skull.targetDirection = Vector(-1,0)
			skull.boss_spawn = "winterblight_lich_king_sonder"
			skull.introSound = "Winterblight.LichKingSonder.Intro2"
			skull.extra_height = 500
		elseif skull.grave_index == 3 then
			skull.targetPoint = Vector(9984, 13257, 1280)
			skull.targetDirection = Vector(-1,0)
			skull.boss_spawn = "winterblight_wrath_queen_asyria"
			skull.introSound = "Winterblight.LadyAsyria.Intro2"
			skull.extra_height = 500
		end
		Timers:CreateTimer(3, function()
			skull.phase = 1
			-- skull:MoveToPosition(skull.targetPoint)
		end)
		skull.main_phase = 1
		StartSoundEvent("Winterblight.BlackSkull.LP", skull)
		skull.float_height = 280		
		caster:AddNoDraw()
		caster.lock = true
		Timers:CreateTimer(0.5, function()
			UTIL_Remove(caster)
		end)
	end
end

function wintermini_boss_death(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	local skull = CreateUnitByName("npc_flying_dummy_vision", caster:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
	skull:SetDayTimeVisionRange(500)
	skull:SetNightTimeVisionRange(500)
	skull:RemoveModifierByName("dummy_unit")
	Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, skull, "modifier_wb_black_skull", {})
	local dummy_ability = skull:FindAbilityByName("dummy_unit")
	dummy_ability:ApplyDataDrivenModifier(skull, skull, "dummy_unit", {})
	skull:SetForwardVector(caster:GetForwardVector())
	skull:SetModelScale(3)
	skull:SetModel("models/heroes/silencer/silencer_curse_skull.vmdl")
	skull:SetOriginalModel("models/heroes/silencer/silencer_curse_skull.vmdl")
	
	skull.grave_index = caster.grave_index
	skull.phase = 0
	Winterblight:EvilExplosion(caster:GetAbsOrigin())
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.EvilExplosion.Ghost", Events.GameMaster)
	if caster:GetUnitName() == "winterblight_baron_moredi" then
		EmitSoundOn("Winterblight.BaronMoredi.Die", skull)
	elseif caster:GetUnitName() == "winterblight_lich_king_sonder" then
		EmitSoundOn("Winterblight.LichKingSonder.Pain", skull)
	elseif caster:GetUnitName() == "winterblight_wrath_queen_asyria" then
		EmitSoundOn("Winterblight.LadyAsyria.Pain", skull)
	end
	skull:SetAbsOrigin(skull:GetAbsOrigin() + Vector(0,0,200))
	if skull.grave_index == 1 then
		skull.targetPoint = Vector(10699, 13819, 1615)
		skull.targetDirection = Vector(-1,0)
		skull.boss_spawn = "winterblight_baron_moredi"
		skull.introSound = "Winterblight.BaronMoredi.Intro"
		skull.extra_height = 500
	elseif skull.grave_index == 2 then
		skull.targetPoint = Vector(10699, 13610, 1615)
		skull.targetDirection = Vector(-1,0)
		skull.boss_spawn = "winterblight_lich_king_sonder"
		skull.introSound = "Winterblight.LichKingSonder.Intro2"
		skull.extra_height = 500
	elseif skull.grave_index == 3 then
		skull.targetPoint = Vector(10699, 13403, 1615)
		skull.targetDirection = Vector(-1,0)
		skull.boss_spawn = "winterblight_wrath_queen_asyria"
		skull.introSound = "Winterblight.LadyAsyria.Intro2"
		skull.extra_height = 500
	end
	Timers:CreateTimer(3, function()
		skull.phase = 1
		-- skull:MoveToPosition(skull.targetPoint)
	end)
	skull.main_phase = 2
	StartSoundEvent("Winterblight.BlackSkull.LP", skull)
	skull.float_height = 280		

end