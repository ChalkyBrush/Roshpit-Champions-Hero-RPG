function rubble_passive_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.phase and caster.phase < 3 then
		if caster:GetHealth() < 100 then
			-- if not caster:HasModifier("modifier_mountain_rubble_in_between") then
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
	print("STUCK")
	if caster.lock then
		return false
	end
	if IsValidEntity(caster) then
		if caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster) < 240 then
			print("GREETS")
			caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0,0,8))
		elseif caster.mountain_bro_to_join and WallPhysics:GetDistance2d(caster.mountain_bro_to_join:GetAbsOrigin(), caster:GetAbsOrigin()) > 20 and caster.mountain_bro_to_join:GetDistanceFromGround() > 235 and caster:GetDistanceFromGround() > 235 then
			local direction = ((caster.mountain_bro_to_join:GetAbsOrigin() - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
			caster:SetAbsOrigin(caster:GetAbsOrigin()+direction*30)
		elseif caster.mountain_bro_to_join and caster.mountain_bro_to_join:GetDistanceFromGround() > 235 and caster:GetDistanceFromGround() > 235 then
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
			local luck = RandomInt(1, 2)
			if luck == 2 then
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
	if caster:GetHealth()/caster:GetMaxHealth() < 0.3 then
		caster.color_change = true
		Events:smoothColorTransition(caster, Vector(134, 158, 255), Vector(226, 36, 36), 45)
	end
	if caster:GetHealth()%(35 + (GameState:GetDifficultyFactor()*10)) == 0 then
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

	-- caster:SetAbsOrigin(caster:GetAbsOrigin() - Vector(0,0,-800))
	CustomAbilities:QuickParticleAtPoint("particles/econ/items/templar_assassin/templar_assassin_butterfly/templar_assassin_trap_explode_butterfly.vpcf", particlePos, 5)
	Timers:CreateTimer(1, function()
		CustomAbilities:QuickParticleAtPoint("particles/econ/items/templar_assassin/templar_assassin_butterfly/templar_assassin_trap_explode_butterfly.vpcf", particlePos, 5)
	end)
	EmitSoundOn("Winterblight.Tombstone.Explode", caster)
end