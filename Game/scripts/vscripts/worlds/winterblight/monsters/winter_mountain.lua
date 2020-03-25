function rubble_passive_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.phase and caster.phase < 3 then
		if caster:GetHealth() < 100 then
			if not caster:HasModifier("modifier_mountain_rubble_in_between") then
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
			end
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
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 620, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
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
			Timers:CreateTimer(10, function()
				EmitSoundOnLocationWithCaster(caster.locked_target:GetAbsOrigin(), "Winterblight.CrowSentry.HauntSpawn", caster)
				for i = 1, 6 + GameState:GetDifficultyFactor()*2, 1 do
					local spawn_pos = caster.locked_target:GetAbsOrigin() + RandomVector(RandomInt(180, 900))
					local fv = ((caster.locked_target:GetAbsOrigin() - spawn_pos)*Vector(1,1,0)):Normalized()
					local haunter = Winterblight:SpawnHaunter(spawn_pos, fv)
					Dungeons:AggroUnit(haunter)
				end
			end)
			Timers:CreateTimer(30, function()
				EmitSoundOnLocationWithCaster(caster.locked_target:GetAbsOrigin():GetAbsOrigin(), "Winterblight.CrowSentry.HauntSpawn", caster)
				for i = 1, 6 + GameState:GetDifficultyFactor()*2, 1 do
					local spawn_pos = caster.locked_target:GetAbsOrigin() + RandomVector(RandomInt(180, 900))
					local fv = ((caster.locked_target:GetAbsOrigin() - spawn_pos)*Vector(1,1,0)):Normalized()
					local haunter = Winterblight:SpawnHaunter(spawn_pos, fv)
					Dungeons:AggroUnit(haunter)
				end
			end)
			Timers:CreateTimer(60, function()
				EmitSoundOnLocationWithCaster(caster.locked_target:GetAbsOrigin():GetAbsOrigin(), "Winterblight.CrowSentry.HauntSpawn", caster)
				for i = 1, 6 + GameState:GetDifficultyFactor()*2, 1 do
					local spawn_pos = caster.locked_target:GetAbsOrigin() + RandomVector(RandomInt(180, 900))
					local fv = ((caster.locked_target:GetAbsOrigin() - spawn_pos)*Vector(1,1,0)):Normalized()
					local haunter = Winterblight:SpawnHaunter(spawn_pos, fv)
					Dungeons:AggroUnit(haunter)
				end
			end)
			Timers:CreateTimer(65, function()
				UTIL_Remove(caster)
			end)
		end
	end
end