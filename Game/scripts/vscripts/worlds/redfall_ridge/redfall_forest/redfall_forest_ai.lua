function redfall_shroomling_think(event)
	local caster = event.caster
	if caster.aggro then
		local particleName = "particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf"
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, event.caster)
		ParticleManager:SetParticleControl(particle1, 0, caster:GetAbsOrigin())
		Timers:CreateTimer(1, function()
			ParticleManager:DestroyParticle(particle1, false)
		end)
		Timers:CreateTimer(0.03, function()
			EmitSoundOn("Redfall.Shroom.Aggro", caster)
		end)
		caster:RemoveModifierByName("modifier_redfall_shroomling_ai")
		StartAnimation(caster, {duration = 0.84, activity = ACT_DOTA_SPAWN, rate = 1})
		local ability = event.ability
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_shroom_jumping", {duration = 0.84})
		local position = caster:GetAbsOrigin()
		caster.liftVelocity = 21
		for i = 1, 28, 1 do
			Timers:CreateTimer(0.03 * i, function()
				caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, caster.liftVelocity))
				caster.liftVelocity = caster.liftVelocity - 1.5
			end)
		end
		Timers:CreateTimer(0.84, function()
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		end)
	end
end

function autumn_spawner_think(event)
	local caster = event.caster
	if not caster.summonTable then
		caster.summonTable = {}
		caster.totalSummons = 0
	end
	local newTable = {}
	for i = 1, #caster.summonTable, 1 do
		if IsValidEntity(caster.summonTable[i]) then
			table.insert(newTable, caster.summonTable[i])
		end
	end
	caster.summonTable = newTable
	local maxSummons = 5
	local loops = 1
	if GameState:GetDifficultyFactor() == 2 then
		maxSummons = 8
	elseif GameState:GetDifficultyFactor() == 3 then
		maxSummons = 12
		loops = 2
	end
	if #caster.summonTable > maxSummons then
		return
	end
	caster.totalSummons = caster.totalSummons + 1
	local itemRoll = 1
	if caster.totalSummons > 12 then
		itemRoll = 0
	end
	local bAggro = false
	if caster.aggro then
		bAggro = true
	end
	for i = 1, loops, 1 do
		local position = caster.summonCenter + RandomVector(RandomInt(1, 240))
		local callback = function(unit)
			if caster.totalSummons > 12 then
				unit:SetDeathXP(0)
				unit:SetMaximumGoldBounty(0)
				unit:SetMinimumGoldBounty(0)
			end
			EmitSoundOn("Redfall.Flower.Spawn", unit)
			CustomAbilities:QuickAttachParticle("particles/roshpit/redfall/autumn_spawn.vpcf", unit, 3)
			FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), false)
			table.insert(caster.summonTable, unit)
		end
		Redfall:SpawnAutumnSpawnerUnit(position, RandomVector(1), itemRoll, bAggro, callback)
	end
end

function redfall_summoner_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	if ability:IsFullyCastable() then
		local newOrder = {
			UnitIndex = caster:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = ability:entindex(),
		}
		ExecuteOrderFromTable(newOrder)
		return
	end
end

function redfall_summon_ability(event)
	local caster = event.caster
	local ability = event.ability
	local loops = GameState:GetDifficultyFactor() * 2

	for i = 1, loops, 1 do
		local spider = Redfall:SpawnRedfallTreant(caster:GetAbsOrigin() + RandomVector(RandomInt(100, 260)), caster:GetForwardVector())
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_burrow_dustcloud.vpcf", spider, 2)
		createSummonParticle(caster:GetAbsOrigin(), caster, spider)
	end
	EmitSoundOn("Redfall.ForestSummoner.Summon", caster)
end

function createSummonParticle(position, caster, target)
	local particleName = "particles/roshpit/redfall/red_beam.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin() + Vector(0, 0, 200))
	ParticleManager:SetParticleControl(pfx, 1, target:GetAbsOrigin() + Vector(0, 0, 422))
	Timers:CreateTimer(3.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
end

function autumn_spawner_die(event)
	local caster = event.caster
	CustomAbilities:QuickAttachParticle("particles/world_destruction_fx/dire_tree004b_destruction.vpcf", caster, 4)
	Timers:CreateTimer(0.2, function()
		EmitSoundOn("Redfall.AutumnSpawner.Death", caster)
	end)
	for i = 1, 140, 1 do
		Timers:CreateTimer(i * 0.03, function()
			if IsValidEntity(caster) then
				caster:SetAbsOrigin(caster:GetAbsOrigin() - Vector(0, 0, 1.5))
			end
		end)
	end
end


function fury_swipes_attack(keys)
	-- Variables
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifierName = "modifier_fury_swipes_target_datadriven"
	local damageType = ability:GetAbilityDamageType()
	local exceptionName = "put_your_exception_unit_here"

	-- Necessary value from KV
	local duration = ability:GetLevelSpecialValueFor("bonus_reset_time", ability:GetLevel() - 1)
	local damage_per_stack = ability:GetLevelSpecialValueFor("damage_per_stack", ability:GetLevel() - 1)

	-- Check if unit already have stack
	if target:HasModifier(modifierName) then
		local current_stack = target:GetModifierStackCount(modifierName, ability)
		local max_stacks = 30

		-- Deal damage
		local damage_table = {
			victim = target,
			attacker = caster,
			damage = damage_per_stack * current_stack,
			damage_type = damageType,
			ability = ability
		}
		ApplyDamage(damage_table)

		ability:ApplyDataDrivenModifier(caster, target, modifierName, {Duration = duration})
		
		target:SetModifierStackCount(modifierName, ability, math.min(current_stack + 1, max_stacks))
	else
		ability:ApplyDataDrivenModifier(caster, target, modifierName, {Duration = duration})
		target:SetModifierStackCount(modifierName, ability, 1)

		-- Deal damage
		local damage_table = {
			victim = target,
			attacker = caster,
			damage = damage_per_stack,
			damage_type = damageType,
			ability = ability
		}
		ApplyDamage(damage_table)
	end
end

function redfall_disciple_of_maru_die(event)
	if not Redfall.DisciplesSlain then
		Redfall.DisciplesSlain = 0
	end
	Redfall.DisciplesSlain = Redfall.DisciplesSlain + 1
	for i = 1, #MAIN_HERO_TABLE, 1 do
		MAIN_HERO_TABLE[i].RedfallQuests[2].state = Redfall.DisciplesSlain
	end
	if Redfall.DisciplesSlain == 12 then
		CustomGameEventManager:Send_ServerToAllClients("newQuest", {})
		EmitSoundOnLocationWithCaster(Vector(-6916, -8042), "Redfall.JuggStatue.End", Redfall.RedfallMaster)
		for i = 1, 240, 1 do
			Timers:CreateTimer(0.03 * i, function()
				Redfall.JuggStatue:SetAbsOrigin(Redfall.JuggStatue:GetAbsOrigin() - Vector(0, 0, 1))
			end)
		end
	end
end

function big_tree_die(event)
	local caster = event.unit
	local position = caster:GetAbsOrigin()
	local fv = caster:GetForwardVector()

	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_remnant_dash.vpcf", caster, 2)

	CustomAbilities:QuickAttachParticle("particles/world_destruction_fx/dire_tree004b_destruction.vpcf", caster, 2)
	EmitSoundOn("Redfall.BigFlower.Death", caster)
	Timers:CreateTimer(0.5, function()
		local spawns = RandomInt(4, 6)
		for i = 1, spawns, 1 do
			local dummy = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
			dummy:AddAbility("ability_red_effect"):SetLevel(1)
			dummy:SetAbsOrigin(dummy:GetAbsOrigin() + Vector(0, 0, 200))
			local dummyFV = WallPhysics:rotateVector(fv, (2 * math.pi / spawns) * i)
			WallPhysics:Jump(dummy, dummyFV, 5 + RandomInt(1, 4), 5 + RandomInt(1, 4), 16, 0.45)

			local pfx = CustomAbilities:QuickAttachParticle("particles/econ/generic/generic_buff_1/generic_buff_1.vpcf", dummy, 10)
			ParticleManager:SetParticleControl(pfx, 14, Vector(1.4,1.4,1.4))
			ParticleManager:SetParticleControl(pfx, 15, Vector(250,120,0))

			Timers:CreateTimer(4, function()
				local callback = function(unit)
					CustomAbilities:QuickAttachParticle("particles/roshpit/redfall/autumn_spawn.vpcf", unit, 3)
				end
				Redfall:SpawnAutumnSpawnerUnit(dummy:GetAbsOrigin(), RandomVector(1), 1, true, callback)
				UTIL_Remove(dummy)
			end)
		end

	end)
	Timers:CreateTimer(2.1, function()
		UTIL_Remove(caster)
	end)
end

function redfall_roar_start(event)
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_forest_roar_preparing", {duration = 1.6})
	EmitSoundOn("Redfall.CliffWeed.RoarUp", caster)
	StartAnimation(caster, {duration = 1.6, activity = ACT_DOTA_IDLE_RARE, rate = 0.8})
	local scaleIncrease = 0.02
	for i = 1, 53, 1 do
		Timers:CreateTimer(i * 0.03, function()
			caster:SetModelScale(caster:GetModelScale() + 0.02)
		end)
	end
	Timers:CreateTimer(1.6, function()
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_forest_roar_buff", {duration = 30})
	end)
end


function redfall_roar_end(event)
	local caster = event.caster
	local ability = event.ability
	for i = 1, 53, 1 do
		Timers:CreateTimer(i * 0.03, function()
			caster:SetModelScale(caster:GetModelScale() - 0.02)
		end)
	end
end

function otaru_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.lock then
		return
	end
	if not Redfall.InvadersKilled then
        Redfall.InvadersKilled = {}
        Redfall.InvadersKilled[1] = 0
        Redfall.InvadersKilled[2] = 0
        Redfall.InvadersKilled[3] = 0
        Redfall.InvadersKilled[4] = 0
        caster.wave = 1
	end
	if caster.state == 1 then
		local goalPosition = Vector(-5989, -14545)
		caster:MoveToPosition(goalPosition)
		local distance = WallPhysics:GetDistance(caster:GetAbsOrigin() * Vector(1, 1, 0), goalPosition)
		if distance < 50 then
			caster.state = 2
			caster:Stop()
			caster:SetForwardVector(Vector(0, -1))
		end
	elseif caster.state == 2 then
		caster.lock = true
		Timers:CreateTimer(2, function()
			caster.lock = false
			caster.state = 3
			caster.music = true
			caster.ritualPFX = ParticleManager:CreateParticle("particles/radiant_fx/good_barracks_ranged001_amb.vpcf", PATTACH_WORLDORIGIN, caster)
			ParticleManager:SetParticleControl(caster.ritualPFX, 0, caster:GetAbsOrigin())
			Timers:CreateTimer(0, function()
				if caster.music then
					EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Redfall.Otaru.RitualMusic", Redfall.RedfallMaster)
					return 60
				end
			end)

		end)
	elseif caster.state == 3 then
		EndAnimation(caster)
		caster.state = 0

		caster:RemoveModifierByName("modifier_otaru_remnant")
		Timers:CreateTimer(0.3, function()
			StartAnimation(caster, {duration = 1, activity = ACT_DOTA_CAST_ABILITY_1, rate = 1.0})
			Timers:CreateTimer(1.5, function()
				StartAnimation(caster, {duration = 9000, activity = ACT_DOTA_OVERRIDE_ABILITY_4, rate = 1.0})
			end)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_otaru_remnant", {})
		end)
		StartSoundEvent("Redfall.Otaru.Ritual", caster)
		Timers:CreateTimer(1, function()
			EmitSoundOn("Redfall.Otaru.Ritual2", caster)
			Timers:CreateTimer(10, function()
				StopSoundEvent("Redfall.Otaru.Ritual", caster)
			end)
		end)

		CustomAbilities:QuickAttachParticle("particles/roshpit/redfall/otaru_ritual_start.vpcf", caster, 5)
		local delay = 0.3
		if GameState:GetDifficultyFactor() == 2 then
			delay = 0.27
		elseif GameState:GetDifficultyFactor() == 3 then
			delay = 0.21
		end
		Timers:CreateTimer(3.5, function()
			for i = 1, 50, 1 do
				Timers:CreateTimer(delay * i, function()
					local position = Vector(-7653 + RandomInt(1, 3200), -14960, Redfall.ZFLOAT)
					local ghoul = false
					if caster.altSummon == 1 then
						local luck = RandomInt(1, 3)
						if luck == 1 then
							ghoul = Redfall:SpawnCliffInvaderRanged(position, Vector(0, 1), caster.wave)
						else
							ghoul = Redfall:SpawnCliffInvader(position, Vector(0, 1), caster.wave)
						end
					elseif caster.altSummon == 2 then
						local luck = RandomInt(1, 2)
						if luck == 1 then
							ghoul = Redfall:SpawnCliffInvaderRanged(position, Vector(0, 1), caster.wave)
						else
							ghoul = Redfall:SpawnCliffInvader(position, Vector(0, 1), caster.wave)
						end
					else
						ghoul = Redfall:SpawnCliffInvader(position, Vector(0, 1), caster.wave)
					end
					local angles = Vector(-90, 90, 0)
					ghoul:SetAngles(angles.x, angles.y, angles.z)
					Timers:CreateTimer(0.2, function()
						local particleName = "particles/roshpit/redfall/cliff_splash.vpcf"
						local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
						ParticleManager:SetParticleControl(pfx, 0, position - Vector(0, 0, 750))
						Timers:CreateTimer(2, function()
							ParticleManager:DestroyParticle(pfx, false)
						end)
					end)
				end)
			end
		end)
	elseif caster.state == 5 then
		local goalPosition = Vector(-5992, -14926)
		caster:MoveToPosition(goalPosition)
		local distance = WallPhysics:GetDistance(caster:GetAbsOrigin() * Vector(1, 1, 0), goalPosition)
		if distance < 50 then
			caster.state = 6
			caster:Stop()
			caster:SetForwardVector(Vector(0, -1))
			caster:RemoveAbility("redfall_otaru_ability")
			caster:RemoveModifierByName("modifier_otaru_think")
			caster:RemoveModifierByName("modifier_otaru_remnant")
			StartAnimation(caster, {duration = 3.4, activity = ACT_DOTA_VICTORY_START, rate = 1.0})
			Timers:CreateTimer(3.5, function()
				StartAnimation(caster, {duration = 99999, activity = ACT_DOTA_VICTORY, rate = 1.0})
			end)
		end

	end
end


function RedfallCliffInvaderOnDeath(event)
	if not event.unit:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		return false
	end
	Redfall.InvadersKilled[event.unit.wave] = Redfall.InvadersKilled[event.unit.wave] + 1
	if Redfall.InvadersKilled[event.unit.wave] == 45 then
        Quests:IncrementQuestObjective("cleansing_the_coast_objective")
        if event.unit.wave == 1 then
		    Redfall.Otaru.state = 3
		    Redfall.Otaru.wave = 2
	    elseif event.unit.wave == 2 then
            Redfall.Otaru.altSummon = 1
            Redfall.Otaru.state = 3
		    Redfall.Otaru.wave = 3
	    elseif event.unit.wave == 3 then
            Redfall.Otaru.state = 3
            Redfall.Otaru.altSummon = 2
		    Redfall.Otaru.wave = 4
        elseif event.unit.wave == 4 then
            Quests:IncrementQuestObjective("cleansing_the_coast_objective")
            EmitGlobalSound("Tutorial.Quest.complete_01")
            ParticleManager:DestroyParticle(Redfall.Otaru.ritualPFX, false)
            Redfall.Otaru.music = false
            Redfall.Otaru.state = 4
            EndAnimation(Redfall.Otaru)
            local units = FindUnitsInRadius(Redfall.Otaru:GetTeamNumber(), Redfall.Otaru:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
            Redfall:Dialogue(Redfall.Otaru, units, "redfall_otaru_dialogue_3", 6, 5, -40, true)
            Timers:CreateTimer(2, function()
                Redfall.Otaru.state = 5
            end)
        end
	end
end

function otaru_idle_think(event)
	local caster = event.caster
	StartAnimation(caster, {duration = 4.0, activity = ACT_DOTA_CAST_ABILITY_4, rate = 1.0})
end


function preserver_end(event)
	Events.PreserverXP = false
end

function redfall_dodge(event)
	local caster = event.caster
	local ability = event.ability
	--print("REDFALL DODGE!!")
	if caster:GetUnitName() == "redfall_forest_ranger" then
		local casterOrigin = caster:GetAbsOrigin()
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), casterOrigin, nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 and not caster:HasModifier("modifier_jumping") then
			ability:StartCooldown(4)
			local sumVector = Vector(0, 0, 0)
			for i = 1, #enemies, 1 do
				sumVector = sumVector + enemies[i]:GetAbsOrigin()
			end
			local avgVector = sumVector / #enemies
			local forceDirection = ((casterOrigin - avgVector) * Vector(1, 1, 0)):Normalized()

			EmitSoundOn("Redfall.DodgeJump", caster)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_trickster_dashing", {duration = 0.66})
			StartAnimation(caster, {duration = 0.8, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1, translate = "ti6"})
			for i = 1, 22, 1 do
				Timers:CreateTimer(i * 0.03, function()
					caster:SetAbsOrigin(caster:GetAbsOrigin() + forceDirection * 24)
				end)
			end
			Timers:CreateTimer(0.69, function()
				FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
			end)
		end
	elseif caster:GetUnitName() == "redfall_red_raven" or caster:GetUnitName() == "redfall_ashara" then
		local casterOrigin = caster:GetAbsOrigin()
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), casterOrigin, nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 and not caster:HasModifier("modifier_jumping") then
			ability:StartCooldown(3)
			local sumVector = Vector(0, 0, 0)
			for i = 1, #enemies, 1 do
				sumVector = sumVector + enemies[i]:GetAbsOrigin()
			end
			local avgVector = sumVector / #enemies
			local forceDirection = ((casterOrigin - avgVector) * Vector(1, 1, 0)):Normalized()

			EmitSoundOn("Redfall.DodgeJump", caster)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_trickster_dashing", {duration = 0.66})
			StartAnimation(caster, {duration = 0.8, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1, translate = "ti6"})
			for i = 1, 22, 1 do
				Timers:CreateTimer(i * 0.03, function()
					WallPhysics:MoveWithBlocking(caster:GetAbsOrigin(), caster:GetAbsOrigin() + forceDirection * 30, caster)
				end)
			end
			Timers:CreateTimer(0.69, function()
				FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
			end)
		end
	elseif caster:GetUnitName() == "redfall_farmlands_bandit" then
		local casterOrigin = caster:GetAbsOrigin()
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), casterOrigin, nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 and not caster:HasModifier("modifier_jumping") then
			ability:StartCooldown(4)
			local sumVector = Vector(0, 0, 0)
			for i = 1, #enemies, 1 do
				sumVector = sumVector + enemies[i]:GetAbsOrigin()
			end
			local avgVector = sumVector / #enemies
			local forceDirection = ((casterOrigin - avgVector) * Vector(1, 1, 0)):Normalized()

			EmitSoundOn("Redfall.FarmlandsBandit.Jump", caster)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_trickster_dashing", {duration = 0.66})
			StartAnimation(caster, {duration = 0.8, activity = ACT_DOTA_ATTACK, rate = 1})
			for i = 1, 22, 1 do
				Timers:CreateTimer(i * 0.03, function()
					WallPhysics:MoveWithBlocking(caster:GetAbsOrigin(), caster:GetAbsOrigin() + forceDirection * 14, caster)
				end)
			end
			Timers:CreateTimer(0.69, function()
				FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
			end)
		end
	end
end

function forest_ranger_think(event)
	local caster = event.caster
	local jumpDetectRadius = 640
	if caster.lock then
		return
	end
	if caster.aggro then
		if caster:HasAbility("redfall_massive_arrow") then
			jumpDetectRadius = 600 + GameState:GetDifficultyFactor() * 120
			local arrowAbility = caster:FindAbilityByName("redfall_massive_arrow")
			if arrowAbility:IsFullyCastable() then
				local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1240, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
				if #enemies > 0 then
					--print("HEAVY ARROW")
					local castPoint = enemies[1]:GetAbsOrigin()
					local newOrder = {
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
						AbilityIndex = arrowAbility:entindex(),
						Position = castPoint
					}

					ExecuteOrderFromTable(newOrder)
					caster.lock = true
					Timers:CreateTimer(2.1, function()
						caster.lock = false
					end)
				end
			end
		end
		local ability = event.ability
		local castAbility = caster:FindAbilityByName("redfall_dodge_ability")
		if castAbility and castAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, jumpDetectRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				local castPoint = enemies[1]:GetAbsOrigin()
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = castAbility:entindex(),
				}

				ExecuteOrderFromTable(newOrder)
			end
		end
	end
end

function forest_ranger_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	local luck = RandomInt(1, 4)
	if luck == 1 then
		local key = 'forest_ranger_attack_land_pfx'
			Util.Common:LimitPerTimeAndPlace(1, 1, target:GetAbsOrigin(), 400, key, function()
			local particleName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
			local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
			ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_CUSTOMORIGIN, "attach_origin", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_CUSTOMORIGIN, "attach_origin", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx, 2, target, PATTACH_CUSTOMORIGIN, "attach_origin", target:GetAbsOrigin(), true)
			EmitSoundOn("Hero_PhantomAssassin.CoupDeGrace", target)
			ability:ApplyDataDrivenModifier(caster, target, "modifier_forest_ranger_bleed", {duration = 6})
			Timers:CreateTimer(4, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
		end)
	end
end

function forest_ranger_die(event)
	local unit = event.unit
	if not unit:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		return false
	end
	if not Redfall then
		return
	end
	if not Redfall.ForestRangersDied then
		Redfall.ForestRangersDied = 0
	end
	Redfall.ForestRangersDied = Redfall.ForestRangersDied + 1
	--print("Forest Ranger Died!")
	if Redfall.ForestRangersDied == 7 then
		Redfall:SpawnRedRaven(Vector(-3456, -8057), Vector(0, 1, 0))
	end
end


function heavy_boulder_toss_start(event)
	local caster = event.caster
	local ability = event.ability
	ability.pushVector = false
	ability.pushVelocity = 30
	ability.tossPosition = caster:GetAbsOrigin()
end

function heavy_boulder_pushback(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if not ability.pushVector then
		local impactPoint = target:GetAbsOrigin()
		local pushVector = ((impactPoint - ability.tossPosition) * Vector(1, 1, 0)):Normalized()
		ability.pushVector = pushVector
		EmitSoundOn("Redfall.StoneAttack", target)
	end
	local obstruction = WallPhysics:FindNearestObstruction(target:GetAbsOrigin())
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, target:GetAbsOrigin(), target)
	local fv = ability.pushVector

	if blockUnit then
		fv = 0
	end

	target:SetAbsOrigin(target:GetAbsOrigin() + fv * ability.pushVelocity)
	ability.pushVelocity = ability.pushVelocity - 1
end


function heavy_boulder_push_end(event)
	local caster = event.target
	caster.pushVector = false
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
end

function redfall_massive_arrow_phase(event)
	local caster = event.caster
	if caster:GetUnitName() == "redfall_farmlands_bandit" then
		StartAnimation(caster, {duration = 0.87, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1.2})
	elseif caster:GetUnitName() == "shipyard_skeleton_archer_boss" then
		StartAnimation(caster, {duration = 0.67, activity = ACT_DOTA_ATTACK, rate = 0.5})
		Timers:CreateTimer(0.7, function()
			StartAnimation(caster, {duration = 0.57, activity = ACT_DOTA_ATTACK, rate = 2.5})
		end)
	else
		StartAnimation(caster, {duration = 0.87, activity = ACT_DOTA_ATTACK, rate = 1.2})
	end
end
function redfall_massive_arrow_start(event)
	local caster = event.caster
	-- StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_ATTACK, rate=1.5})
end


function heart_spike_attack_land(event)
	local attacker = event.attacker
	local target = event.target
	local damagePercent = event.damage_percent
	local damage = (damagePercent / 100) * target:GetMaxHealth()
	local ability = event.ability
	if target:IsHero() then
		ApplyDamage({victim = target, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
		CustomAbilities:QuickAttachParticle("particles/roshpit/heart_strike_manaburn_basher_ti_5.vpcf", target, 2)
	end
end

function ash_snake_think(event)
	local ability = event.ability
	local caster = event.caster
	if caster.aggro then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local sumVector = Vector(0, 0)
			for i = 1, #enemies, 1 do
				sumVector = sumVector + enemies[i]:GetAbsOrigin()
			end
			local avgVector = sumVector / #enemies
			local runDirection = ((caster:GetAbsOrigin() - avgVector) * Vector(1, 1, 0)):Normalized()
			caster:MoveToPosition(caster:GetAbsOrigin() + runDirection * 320)
		end
	end
end

function ash_knight_shield_start(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.aggro then
		ability:EndCooldown()
		ability:StartCooldown(1)
		return
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_ash_knight_shield", {duration = 2.63})
	StartAnimation(caster, {duration = 2.63, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1.0})
	EmitSoundOn("Redfall.AshKnight.ShieldStart", caster)
	StartSoundEvent("Redfall.AshKnight.ShieldLoop", caster)
	Timers:CreateTimer(2.63, function()
		StopSoundEvent("Redfall.AshKnight.ShieldLoop", caster)
	end)
end

function ash_knight_shield_take_damage(event)
	local attacker = event.attacker
	local ability = event.ability
	local caster = event.caster
	Events:CreateLightningBeam(caster:GetAbsOrigin() + Vector(0, 0, 90), attacker:GetAbsOrigin() + Vector(0, 0, 90))
	EmitSoundOn("Redfall.AshKnight.ShieldStrike", attacker)
	local silence_duration = event.silence_duration
	ability:ApplyDataDrivenModifier(caster, attacker, "modifier_shield_silence", {duration = silence_duration})
end

function autumn_slap(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	EmitSoundOn("Redfall.AutumnSatyr.Slap", target)
	target:AddNewModifier(caster, nil, "modifier_stunned", {duration = 1.0})
	WallPhysics:Jump(target, Vector(1, 1), 0, 25, 24, 1)
	local pfx = ParticleManager:CreateParticle("particles/roshpit/redfall/autumn_impactknightform_iron_dragon.vpcf", PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 2, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 3, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 4, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	-- CustomAbilities:QuickAttachParticle(, target, 3)
end

function redfall_autumn_tornado(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	EmitSoundOn("Redfall.AutumnVulture.TornadoStart", caster)
	ability.liftVelocity = 20
	ability.target = target
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_autumn_tornado_lifting", {duration = 4})
end

function tornado_ability_lifting_think(event)
	local caster = event.caster
	local ability = event.ability
	caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, ability.liftVelocity))
	ability.liftVelocity = ability.liftVelocity - 1
	if ability.liftVelocity == 0 then
		EmitSoundOn("Redfall.AutumnVulture.TornadoLaunch", caster)
		local fv = ((ability.target:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
		local projectileParticle = "particles/units/heroes/hero_invoker/invoker_tornado.vpcf"
		local start_radius = 180
		local end_radius = 180
		local range = 1500
		local speed = 1500
		local info =
		{
			Ability = ability,
			EffectName = projectileParticle,
			vSpawnOrigin = caster:GetAbsOrigin(),
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
			fExpireTime = GameRules:GetGameTime() + 4.0,
			bDeleteOnHit = false,
			vVelocity = fv * speed,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
	end
	if ability.liftVelocity <= 0 then
		if caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster) <= 10 then
			caster:RemoveModifierByName("modifier_autumn_tornado_lifting")
		end
	end
end

function tornado_impact(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	StartSoundEvent("Redfall.AutumnVulture.TornadoImpact", target)
	Timers:CreateTimer(2, function()
		StopSoundEvent("Redfall.AutumnVulture.TornadoImpact", target)
	end)
end

function mountain_crush_cast(event)
	local caster = event.caster
	local target = event.target
	CustomAbilities:QuickAttachParticle("particles/econ/items/earthshaker/earthshaker_gravelmaw/earthshaker_fissure_flash_b_gravelmaw.vpcf", caster, 1)
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_mountain_crush_jumping", {duration = 5})
	ability.acceleration = 30
	ability.directionVector = ((target:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	ability.distance = WallPhysics:GetDistance(target:GetAbsOrigin() * Vector(1, 1, 0), caster:GetAbsOrigin() * Vector(1, 1, 0))
	ability.target = target
	if caster.animation then
		StartAnimation(caster, {duration = 2, activity = ACT_DOTA_CAST_ABILITY_1, rate = 1.0})
	else
		StartAnimation(caster, {duration = 2, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1.0})
	end
end

function mountain_crush_thinking(event)
	local caster = event.caster
	local ability = event.ability
	local target = ability.target
	local acceleration = ability.acceleration
	ability.acceleration = ability.acceleration - 1.5
	local directionVector = ability.directionVector
	caster:SetAbsOrigin(caster:GetAbsOrigin() + directionVector * (ability.distance / 30) + Vector(0, 0, ability.acceleration))
	if ability.acceleration <= 0 then
		if GetGroundHeight(caster:GetAbsOrigin(), caster) > (caster:GetAbsOrigin().z - 10) then
			caster:RemoveModifierByName("modifier_mountain_crush_jumping")
		end
	end
end

function mountain_crush_end(event)
	local caster = event.caster
	local radius = 320
	local position = caster:GetAbsOrigin()
	local splitEarthParticle = "particles/units/heroes/hero_leshrac/astral_rune_b_d.vpcf"
	local damage = event.damage
	local ability = event.ability
	local pfx = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, position)
	ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
	EmitSoundOn("Redfall.MountainCrush", caster)
	FindClearSpaceForUnit(caster, position, false)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius + 5, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
			enemy:AddNewModifier(caster, event.ability, "modifier_stunned", {duration = 2})
		end
	end
end



function cultist_entering_think(event)
	local caster = event.caster
	local ability = event.ability
	local fv = Vector(0, 1)
	local treeOrigin = caster.treeOrigin

	local rotatedVector = WallPhysics:rotateVector(fv, caster.rotationIndex * 2 * math.pi / 360)

	caster:SetAbsOrigin(treeOrigin + rotatedVector * 320 + Vector(0, 0, 800 - caster.rotationIndex * 3))
	caster.rotationIndex = caster.rotationIndex + 1
end

function redfall_crimsyth_cultist_die(event)
	local unit = event.unit
	local ability = event.ability
	if not unit:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		return false
	end
	if unit.bossLock then
		return false
	end
	local treeDummy = unit.treeDummy
	if not treeDummy then
		return
	end
	treeDummy.cultistsSlain = treeDummy.cultistsSlain + 1
	--print("Cultists slain: "..treeDummy.cultistsSlain)
	if treeDummy.boss then
		if treeDummy.cultistsSlain == 20 then
			Redfall:SpawnCanyonBossParagonTest()
		end
		return false
	end
	if treeDummy.cultistsSlain == treeDummy.cultistsTarget then
		local position = treeDummy.tree:GetAbsOrigin()
		local pfx = ParticleManager:CreateParticle("particles/rain_fx/econ_weather_ash.vpcf", PATTACH_WORLDORIGIN, Redfall.RedfallMaster)
		ParticleManager:SetParticleControl(pfx, 0, position + Vector(0, 0, 150))
		local healedTree = Entities:FindByNameNearest("VermillionTreeHealed", treeDummy:GetAbsOrigin() - Vector(0, 0, 700), 1200)

		local pfx2 = ParticleManager:CreateParticle("particles/dire_fx/avernus_eye_smoke.vpcf", PATTACH_WORLDORIGIN, Redfall.RedfallMaster)
		ParticleManager:SetParticleControl(pfx2, 0, position)
		Timers:CreateTimer(4.5, function()
			ParticleManager:DestroyParticle(pfx2, false)
		end)
		Timers:CreateTimer(2.5, function()
			local moveVector = (position - healedTree:GetAbsOrigin()) / 180
			for j = 1, 180, 1 do
				Timers:CreateTimer(j * 0.03, function()

					healedTree:SetAbsOrigin(healedTree:GetAbsOrigin() + moveVector)
					if j % 30 == 0 then
						ScreenShake(position, 130, 0.9, 0.9, 9000, 0, true)
						EmitSoundOnLocationWithCaster(position, "Redfall.TreeRising", Redfall.RedfallMaster)
						local pfxX = ParticleManager:CreateParticle("particles/dire_fx/dire_lfr_smoke_19sec.vpcf", PATTACH_WORLDORIGIN, Redfall.RedfallMaster)
						ParticleManager:SetParticleControl(pfxX, 0, position)
						Timers:CreateTimer(10, function()
							ParticleManager:DestroyParticle(pfxX, false)
						end)
					end
					if j == 180 then
						EmitSoundOnLocationWithCaster(position, "Redfall.TreeHealedMain", Events.GameMaster)
						EmitSoundOnLocationWithCaster(position, "Redfall.TreeHealed", Redfall.RedfallMaster)
						local particle = "particles/roshpit/redfall/tree_healed.vpcf"
						local pfxA = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, unit)
						FindClearSpaceForUnit(unit, position, false)
						ParticleManager:SetParticleControl(pfxA, 0, position)
						ParticleManager:SetParticleControl(pfxA, 1, position)
						ParticleManager:SetParticleControl(pfxA, 2, Vector(0, 1))
						Timers:CreateTimer(7.5, function()
							ParticleManager:DestroyParticle(pfxA, false)
						end)

					end
				end)
			end
		end)
		for k = 1, 100, 1 do
			Timers:CreateTimer(k * 0.03, function()
				treeDummy.tree:SetModelScale(1 - (k / 100))
				if k == 100 then
					UTIL_Remove(treeDummy.tree)
				end
			end)
		end

		Quests:IncrementQuestObjective("heart_of_the_forest_objective1")
	end
end

function redfall_crimsyth_cultist_master_die(event)
	for i = 1, #MAIN_HERO_TABLE, 1 do
		if MAIN_HERO_TABLE[i].RedfallQuests[1].state >= 0 then
			MAIN_HERO_TABLE[i].RedfallQuests[1].state = 1
			CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "newQuest", {})
		end
	end
	Redfall.FirstQuestBoss = true
end

function crimsith_cult_master_pull(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	--print("PULL??")
	EmitSoundOn("Redfall.CultBoss.PullAbilityEffect", target)
	CustomAbilities:QuickAttachParticle("particles/econ/items/lich/frozen_chains_ti6/lich_frozenchains_frostnova_g.vpcf", caster, 3)
	local particleName = "particles/units/heroes/hero_lich/lich_dark_ritual.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_crimsith_cult_pull", {duration = 1.5})
	local jumpDirection = ((caster:GetAbsOrigin() - target:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	local distance = WallPhysics:GetDistance(target:GetAbsOrigin() * Vector(1, 1, 0), caster:GetAbsOrigin() * Vector(1, 1, 0))
	local propulsion = math.floor(distance / 32)
	WallPhysics:Jump(target, jumpDirection, propulsion, 20, 36, 1.2)
end


function crimsith_boss_attack_start(event)
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Timers:CreateTimer(0.35, function()
				if enemy:GetEntityIndex() == target:GetEntityIndex() then
				else
					attacker:PerformAttack(enemy, true, true, true, true, true, false, false)
				end
				-- create_extra_guardian_attack(attacker, enemy, target, ability, "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_base_attack.vpcf")
			end)
		end
	end
end

function redfall_unit_die(event)
	if not event.unit:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		return false
	end
	local unit = event.unit
    local luck = RandomInt(1, 2200 - GameState:GetPlayerPremiumStatusCount() * 100)
    luck = 1
	if luck == 1 then
		if not Redfall.TwigDropped then
            Redfall.TwigDropped = true
            local position = event.unit:GetAbsOrigin()
            local item_name = "item_redfall_ashen_twig"
            local key = RPCItems:CreateConsumable(item_name, "rare", "redfall_twig", "consumable", false, "Redfall Ridge Only", "DOTA_Tooltip_ability_"..item_name.."_Description")
            key.cantStash = true
            local drop = CreateItemOnPositionSync(position, key)
            RPCItems:DropItem(key, position)
		end
	end
	if luck == 2 then
		RPCItems:RollAndDropUniqueItem(event.unit, 'item_rpc_redfall_runners')
	end
	if luck == 3 then
		RPCItems:RollAndDropUniqueItem(event.unit, "item_rpc_fuchsia_ring")
	end
end


function ash_tree_think(event)
	local caster = event.caster
	local spawns = RandomInt(4, 6)
	local position = caster:GetAbsOrigin()
	local fv = caster:GetForwardVector()
	if not caster.spawnTicks then
		caster.spawnTicks = 0
	end
	if caster.spawnTicks > 6 then
		return false
	end
	for i = 1, spawns, 1 do
		local dummy = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
		dummy:AddAbility("ability_red_effect"):SetLevel(1)
		dummy:SetAbsOrigin(dummy:GetAbsOrigin() + Vector(0, 0, 200))
		local pfx = CustomAbilities:QuickAttachParticle("particles/econ/generic/generic_buff_1/generic_buff_1.vpcf", dummy, 4)
		ParticleManager:SetParticleControl(pfx, 14, Vector(1,1,1))
		ParticleManager:SetParticleControl(pfx, 15, Vector(255,120,0))

		local dummyFV = WallPhysics:rotateVector(fv, (2 * math.pi / spawns) * i)
		WallPhysics:Jump(dummy, dummyFV, 5 + RandomInt(1, 4), 5 + RandomInt(1, 4), 16, 0.45)
		Timers:CreateTimer(4, function()
			local unit = Redfall:SpawnAshSnake(dummy:GetAbsOrigin(), RandomVector(1), true)
			CustomAbilities:QuickAttachParticle("particles/roshpit/redfall/autumn_spawn.vpcf", unit, 3)
			UTIL_Remove(dummy)
		end)
	end
	caster.spawnTicks = caster.spawnTicks + 1
end

function redfall_red_raven_die(event)
	local unit = event.unit
	if unit:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		local position = unit:GetAbsOrigin()
        local item_name = "item_redfall_glowing_redfall_leaf"
        local key = RPCItems:CreateConsumable(item_name, "rare", "redfall_leaf", "consumable", false, "Redfall Ridge Only", "DOTA_Tooltip_ability_"..item_name.."_Description")
        key.cantStash = true
        local drop = CreateItemOnPositionSync(position, key)
        RPCItems:DropItem(key, position)
	end
end

function redfall_ashara_die(event)
	local unit = event.unit
	local position = unit:GetAbsOrigin()
	if unit:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		EmitGlobalSound("Tutorial.Quest.complete_01")
		Timers:CreateTimer(1.5, function()
			EmitSoundOn("Redfall.Ashara.Death", unit)
		end)
		Timers:CreateTimer(4, function()
			Redfall:DefeatDungeonBoss("ashara", position)
		end)
		for i = 1, #MAIN_HERO_TABLE, 1 do
			MAIN_HERO_TABLE[i].RedfallQuests[5].active = 2
			MAIN_HERO_TABLE[i].RedfallQuests[5].state = 1
		end
		local luck = RandomInt(1, GameState:GetDifficultyFactor())
		if luck == 1 then
			RPCItems:RollAndDropUniqueItem(unit, "item_rpc_boots_of_ashara")
		end
	end
end

function ashara_leap_cast(event)
	local caster = event.caster
	local target = event.target
	CustomAbilities:QuickAttachParticle("particles/econ/items/earthshaker/earthshaker_gravelmaw/earthshaker_fissure_flash_b_gravelmaw.vpcf", caster, 1)
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_mountain_crush_jumping", {duration = 5})
	ability.acceleration = 30
	ability.directionVector = ((target:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	ability.distance = WallPhysics:GetDistance(target:GetAbsOrigin() * Vector(1, 1, 0), caster:GetAbsOrigin() * Vector(1, 1, 0))
	ability.target = target
	StartAnimation(caster, {duration = 2, activity = ACT_DOTA_CAST_ABILITY_1, rate = 0.7, translate = "moonfall"})
end

function mountain_crush_thinking(event)
	local caster = event.caster
	local ability = event.ability
	local target = ability.target
	local acceleration = ability.acceleration
	ability.acceleration = ability.acceleration - 1.5
	local directionVector = ability.directionVector
	caster:SetAbsOrigin(caster:GetAbsOrigin() + directionVector * (ability.distance / 30) + Vector(0, 0, ability.acceleration))
	if ability.acceleration <= 0 then
		if GetGroundHeight(caster:GetAbsOrigin(), caster) > (caster:GetAbsOrigin().z - 10) then
			caster:RemoveModifierByName("modifier_mountain_crush_jumping")
		end
	end
end

function ashara_leap_end(event)
	local caster = event.caster
	local position = caster:GetAbsOrigin()
	FindClearSpaceForUnit(caster, position, false)
end


function raven_seeking_think(event)
	local caster = event.caster
	local targetHero = caster.hero
	local ability = event.ability
	ability.velocity = math.max(ability.velocity - 0.7, 15)

	local movementVector = (targetHero:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
	caster:SetAbsOrigin(caster:GetAbsOrigin() + movementVector * ability.velocity)
	local distance = WallPhysics:GetDistance(caster:GetAbsOrigin(), targetHero:GetAbsOrigin())
	caster:SetForwardVector(movementVector)
	if distance < 90 then
		caster:RemoveModifierByName("modifier_raven_seeking_hero")
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_raven_seeking_drop_point", {})
		ability:ApplyDataDrivenModifier(caster, targetHero, "modifier_raven_hero_picked_up", {})

	end
end

function raven_look_for_drop_think(event)
	local caster = event.caster
	local ability = event.ability
	local hero = caster.hero
	local targetPosition = Vector(693, -15193, 512)
	caster:MoveToPosition(targetPosition)
	local distance = WallPhysics:GetDistance(targetPosition * Vector(1, 1, 0), caster:GetAbsOrigin() * Vector(1, 1, 0))
	if distance < 100 and not caster.lock then
		caster.lock = true
		caster:RemoveModifierByName("modifier_raven_seeking_drop_point")
		hero:RemoveModifierByName("modifier_raven_hero_picked_up")
		FindClearSpaceForUnit(hero, hero:GetAbsOrigin(), false)
		hero:Stop()
		hero:SetForwardVector(Vector(0, 1))
		hero:RemoveModifierByName("modifier_raven_courier_active")
		local fv = caster:GetForwardVector() * Vector(1, 1, 0)
		for i = 1, 100, 1 do
			Timers:CreateTimer(i * 0.03, function()
				caster:SetForwardVector(fv)
				caster:SetAbsOrigin(caster:GetAbsOrigin() + (fv * 30) + Vector(0, 0, 15))
			end)
		end
		Timers:CreateTimer(3.5, function()
			UTIL_Remove(caster)
		end)
		local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
		local radius = 450
		local particle2 = ParticleManager:CreateParticle(particleNameS, PATTACH_WORLDORIGIN, hero)
		ParticleManager:SetParticleControl(particle2, 0, hero:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle2, 1, Vector(radius, radius, radius))
		ParticleManager:SetParticleControl(particle2, 2, Vector(2.0, 2.0, 2.0))
		ParticleManager:SetParticleControl(particle2, 4, Vector(255, 40, 0))
		Timers:CreateTimer(1.5, function()
			ParticleManager:DestroyParticle(particle2, false)
		end)
	end
	if not caster.lock then
		if not caster.zDelta then
			caster.zDelta = 0
		end
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_raven_fly_height", {})
		local zDelta = math.max(700 - GetGroundHeight(caster:GetAbsOrigin(), caster), 0)

		zDelta = math.min(caster.zDelta + 10, zDelta)

		caster.zDelta = zDelta
		caster:SetModifierStackCount("modifier_raven_fly_height", caster, zDelta)
	end
end

function held_by_raven_think(event)
	local caster = event.caster
	local target = event.target

	local zDeltaStacks = caster:GetModifierStackCount("modifier_raven_fly_height", caster)
	target:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, -40 + zDeltaStacks))
	target:SetForwardVector(caster:GetForwardVector())
end


function AsharaWaveUnitOnDeath(event)
	if not event.unit:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		return false
	end
	local caster = event.caster
	local currentWave = event.unit.wave
	Redfall.AsharaWavesCounters[currentWave]["killed"] = Redfall.AsharaWavesCounters[currentWave]["killed"] + 1
	local killedTreshold = 0.9
	local delay = 1.2
	if GameState:GetDifficultyFactor() == 2 then
		killedTreshold = 0.8
		delay = 1.0
	elseif GameState:GetDifficultyFactor() == 3 then
		killedTreshold = 0.7
		delay = 0.8
	end
	local spawnPositionTable = {
		Vector(240, -14423), --Northwest
		Vector(2075, -14340),  --Northeast
		Vector(1280, -16000) --South
	}
    if Redfall.AsharaWavesCounters[currentWave]["completed"] == false and Redfall.AsharaWavesCounters[currentWave]["killed"] == math.floor(Redfall.AsharaWavesCounters[currentWave]["total"] * killedTreshold) then
        Redfall.AsharaWavesCounters[currentWave]["completed"] = true
        Quests:IncrementQuestObjective("seeking_ashara_objective5")
		if currentWave == 1 then
            Redfall.AsharaWavesCounters[2] = { }
			Redfall.AsharaWavesCounters[2]["killed"] = 0
			Redfall.AsharaWavesCounters[2]["total"] = 9 + 9 + 3
			for i = 1, #spawnPositionTable, 1 do
				if i == 1 then
					Redfall:SpawnRedfallAsharaWaveUnit("redfall_autumn_enforcer", spawnPositionTable[i], 2, 9, delay, true)
				elseif i == 2 then
					Redfall:SpawnRedfallAsharaWaveUnit("redfall_forest_ranger", spawnPositionTable[i], 2, 9, delay, true)
				elseif i == 3 then
					Redfall:SpawnRedfallAsharaWaveUnit("redfall_canyon_breaker", spawnPositionTable[i], 2, 3, delay * 3, true)
				end
			end
		elseif currentWave == 2 then
            Redfall.AsharaWavesCounters[3] = { }
			Redfall.AsharaWavesCounters[3]["killed"] = 0
			Redfall.AsharaWavesCounters[3]["total"] = 9 + 9 + 4
			for i = 1, #spawnPositionTable, 1 do
				if i == 1 then
					Redfall:SpawnRedfallAsharaWaveUnit("redfall_forest_ranger", spawnPositionTable[i], 3, 9, delay, true)
				elseif i == 2 then
					Redfall:SpawnRedfallAsharaWaveUnit("redfall_follower_of_ashara", spawnPositionTable[i], 3, 9, delay, true)
				elseif i == 3 then
					Redfall:SpawnRedfallAsharaWaveUnit("redfall_armored_crab_beast", spawnPositionTable[i], 3, 4, delay * 2, true)
				end
			end
		elseif currentWave == 3 then
            Redfall.AsharaWavesCounters[4] = { }
			Redfall.AsharaWavesCounters[4]["killed"] = 0
			Redfall.AsharaWavesCounters[4]["total"] = 3 + 3 + 3 + 6
			for i = 1, #spawnPositionTable, 1 do
				if i == 1 then
					Redfall:SpawnRedfallAsharaWaveUnit("redfall_autumn_mage", spawnPositionTable[i], 4, 3, delay * 3, true)
				elseif i == 2 then
					Redfall:SpawnRedfallAsharaWaveUnit("redfall_canyon_alpha_beast", spawnPositionTable[i], 4, 3, delay * 3, true)
                elseif i == 3 then
                    Redfall:SpawnRedfallAsharaWaveUnit("redfall_canyon_breaker", spawnPositionTable[i], 4, 3, delay, true)
                    Timers:CreateTimer(delay * 3, function()
                        Redfall:SpawnRedfallAsharaWaveUnit("redfall_armored_crab_beast", spawnPositionTable[i], 4, 6, delay, true)
                    end)
				end
			end
		elseif currentWave == 4 then
			Redfall:SpawnAshara(Vector(1244, -14776), Vector(0, -1))
			for i = 1, #Redfall.spawnPortalTable2, 1 do
				ParticleManager:DestroyParticle(Redfall.spawnPortalTable2[i], false)
			end
		end
	end
end

function begin_splitshot(event)
	-- Dungeons:Debug()
	-- local cheats = Convars:GetBool("developer")
	----print(cheats)
	local caster = event.caster
	local ability = event.ability
	local abilityLevel = ability:GetLevel()
	local location = caster:GetOrigin() + caster:GetForwardVector() * Vector(80, 80, 0)
	local forwardVector = caster:GetForwardVector()
	local damage = event.damage
	local range = event.range
	local procs = RandomInt(2, 3)

	ability.damage = damage

	EmitSoundOn("Astral.AstralVolleyBig", caster)

	local minArrows = -4
	local maxArrows = 4


	for j = 0, procs, 1 do
		Timers:CreateTimer(j * 0.20, function()
			for i = minArrows, maxArrows, 1 do
				local rotatedVector = WallPhysics:rotateVector(forwardVector, math.pi / 40 * i)
				local arrowOrigin = caster:GetAbsOrigin() + caster:GetForwardVector() * Vector(80, 80, 0)
				create_shot2(ability, caster, rotatedVector, arrowOrigin)
				if j == 1 then
					StartAnimation(caster, {duration = 0.20, activity = ACT_DOTA_ATTACK, rate = 3.6})

					EmitSoundOn("Redfall.AstralVolleySmall", caster)
				end
			end
		end)
	end

end

function create_shot2(ability, caster, fv, arrowOrigin)
	local start_radius = 60
	local end_radius = 60
	local speed = 1100
	local projectileParticle = "particles/redfall/ashara_arrow.vpcf"
	--print(fv)
	--print(arrowOrigin)
	--print(caster:GetUnitName())
	--print(ability:GetAbilityName())
	--print("ASHARA ARROW")
	local info =
	{
		Ability = ability,
		EffectName = projectileParticle,
		vSpawnOrigin = arrowOrigin,
		fDistance = 1200,
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
	projectile = ProjectileManager:CreateLinearProjectile(info)

end

function fenrir_ghost_think(event)
	local caster = event.caster
	if caster.lock then
		return false
	end
	local distanceToTarget = WallPhysics:GetDistance(caster.targetPoint, caster:GetAbsOrigin() * Vector(1, 1, 0))
	caster:MoveToPosition(caster.targetPoint)
	if distanceToTarget < 150 then
		caster.targetPoint = caster.movementTable[RandomInt(1, #caster.movementTable)]
	end
	local position = caster:GetAbsOrigin()

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 360, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Redfall.RemnantDisappear", caster)

		local pfx = ParticleManager:CreateParticle("particles/generic_gameplay/illusion_killed.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, position + Vector(0, 0, 100))
		caster.lock = true
		caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
		Timers:CreateTimer(1.0, function()
			ParticleManager:DestroyParticle(pfx, false)
			UTIL_Remove(caster)
			local pfx2 = ParticleManager:CreateParticle("particles/generic_gameplay/illusion_killed.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(pfx2, 0, position + Vector(0, 0, 100))
			Timers:CreateTimer(2.5, function()
				ParticleManager:DestroyParticle(pfx2, false)

			end)
		end)
		Redfall:SpawnFenrir()
		RedfallQuests:NewQuest(ROSHPIT_QUEST_REDFALL_FALLEN_KING_OF_THE_WOLVES)
	end
end

function redfall_fenrir_die(event)
	if not event.unit:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		return false
	end
	local ability = event.ability
	for i = 1, #MAIN_HERO_TABLE, 1 do
		MAIN_HERO_TABLE[i].RedfallQuests[6].state = 1
		CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "newQuest", {})
	end
end

function redfall_fenrir_think(event)
	local target = event.target
	if target.buddiesTable then
		local aggro = false
		local gottaMove = false
		for i = 1, #target.buddiesTable, 1 do
			local buddy = target.buddiesTable[i]
			if IsValidEntity(buddy) then
				if buddy.aggro then
					aggro = true
					break
				end
			end
		end
		if aggro then
			for i = 1, #target.buddiesTable, 1 do
				local buddy = target.buddiesTable[i]
				if IsValidEntity(buddy) then
					if not buddy.lock then
						buddy:Stop()
						buddy.lock = true
						buddy.aggro = true
					end
					return false
				end
			end
		end
		for i = 1, #target.buddiesTable, 1 do
			local buddy = target.buddiesTable[i]
			if IsValidEntity(buddy) then
				local distanceToTarget = WallPhysics:GetDistance(buddy.targetPoint, buddy:GetAbsOrigin() * Vector(1, 1, 0))
				buddy:MoveToPosition(buddy.targetPoint)
				if distanceToTarget < 150 then
					gottaMove = true
					break
				end
			end
		end
		if gottaMove then
			local targetPoint = target.buddiesTable[1].movementTable[RandomInt(1, #target.buddiesTable[1].movementTable)]
			for i = 1, #target.buddiesTable, 1 do
				local buddy = target.buddiesTable[i]
				if IsValidEntity(buddy) then
					buddy.targetPoint = targetPoint
				end
			end
		end
	else
		if target.aggro then
			if not target.lock then
				target:Stop()
				target.lock = true
			end
			return false
		end
		local distanceToTarget = WallPhysics:GetDistance(target.targetPoint, target:GetAbsOrigin() * Vector(1, 1, 0))
		target:MoveToPosition(target.targetPoint)
		if distanceToTarget < 150 then
			target.targetPoint = target.movementTable[RandomInt(1, #target.movementTable)]
		end
	end
end
