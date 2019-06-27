function razorfish_captain_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 0
	end
	caster.interval = caster.interval + 1
	if caster.interval % 6 == 0 then
		if caster:GetUnitName() == "swamp_razorfish_captain" then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_razorfish_poison_enchant", {duration = 3})
		elseif caster:GetUnitName() == "swamp_razorfish_irritable" then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_razorfish_berserk", {duration = 3})
		end
	end
	if caster.interval >= 12 then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local unit = enemies[1]
			local fv = (unit:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
			WallPhysics:Jump(caster, fv, 17 + RandomInt(0, 5), 22, 22, 1.4)
			StartAnimation(caster, {duration = 0.86, activity = ACT_DOTA_SLARK_POUNCE, rate = 0.9})
		end
		caster.interval = 0
	end
end

function swamp_cultist_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.aggro then
		local deathward = caster:FindAbilityByName("tribal_death_ward")
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		if deathward:IsFullyCastable() and #enemies > 0 then
			local targetPoint = enemies[1]:GetOrigin() + RandomVector(260)
			local order =
			{
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = deathward:entindex(),
				Position = targetPoint
			}
			ExecuteOrderFromTable(order)
		end
	end
end

function bog_monster_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 0
	end
	caster.interval = caster.interval + 1
	if caster.interval % 5 == 0 then
		for i = 1, #MAIN_HERO_TABLE, 1 do
			local position = MAIN_HERO_TABLE[i]:GetAbsOrigin() + RandomVector(110)
			--ability:ApplyDataDrivenThinker(caster, position, "modifier_poison_cloud_thinker", {})
			CustomAbilities:QuickAttachThinker(ability, caster, position, "modifier_poison_cloud_thinker", {})
		end
	end
	if caster.interval >= 11 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_bog_intro", {duration = 0.9})
		StartAnimation(caster, {duration = 0.9, activity = ACT_DOTA_CAST_ABILITY_1, rate = 0.4})
		EmitGlobalSound("RoshanDT.Scream")
		EmitGlobalSound("RoshanDT.Scream")

		local particleName = "particles/items2_fx/smoke_of_deceit.vpcf"
		local casterPos = caster:GetAbsOrigin()
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, bogMonster)
		ParticleManager:SetParticleControl(particle1, 0, casterPos)
		ParticleManager:SetParticleControl(particle1, 1, Vector(1800, 1000, 300))
		Timers:CreateTimer(0.5, function()
			local distance = RandomInt(200, 700)
			local gasCount = math.floor(distance / 60)
			for i = -gasCount, gasCount, 1 do
				local fv = caster:GetForwardVector()
				local rotatedFv = WallPhysics:rotateVector(fv, math.pi * 2 / gasCount * i)
				local gasPosition = caster:GetAbsOrigin() + rotatedFv * distance
				--ability:ApplyDataDrivenThinker(caster, gasPosition, "modifier_poison_cloud_thinker", {})
				CustomAbilities:QuickAttachThinker(ability, caster, gasPosition, "modifier_poison_cloud_thinker", {})
			end
			Timers:CreateTimer(0.5, function()
				distance = distance + 200
				gasCount = math.floor(distance / 60)
				for i = -gasCount, gasCount, 1 do
					local fv = caster:GetForwardVector()
					local rotatedFv = WallPhysics:rotateVector(fv, math.pi * 2 / gasCount * i)
					local gasPosition = caster:GetAbsOrigin() + rotatedFv * distance
					--ability:ApplyDataDrivenThinker(caster, gasPosition, "modifier_poison_cloud_thinker", {})
					CustomAbilities:QuickAttachThinker(ability, caster, gasPosition, "modifier_poison_cloud_thinker", {})
				end
				Timers:CreateTimer(0.5, function()
					distance = distance + 200
					gasCount = math.floor(distance / 60)
					for i = -gasCount, gasCount, 1 do
						local fv = caster:GetForwardVector()
						local rotatedFv = WallPhysics:rotateVector(fv, math.pi * 2 / gasCount * i)
						local gasPosition = caster:GetAbsOrigin() + rotatedFv * distance
						--ability:ApplyDataDrivenThinker(caster, gasPosition, "modifier_poison_cloud_thinker", {})
						CustomAbilities:QuickAttachThinker(ability, caster, gasPosition, "modifier_poison_cloud_thinker", {})
					end
				end)
			end)
		end)
		ScreenShake(casterPos, 200, 0.9, 0.4, 9000, 0, true)
		Timers:CreateTimer(4, function()
			ParticleManager:DestroyParticle(particle1, false)
		end)

		caster.interval = 0

	end
end

function bog_monster_die(event)
	local caster = event.caster
	Timers:CreateTimer(2.82, function()
		ScreenShake(caster:GetAbsOrigin(), 200, 0.5, 1, 9000, 0, true)
		EmitSoundOn("Hero_Treant.LeechSeed.Cast", caster)
		EmitSoundOn("Hero_Treant.LeechSeed.Cast", caster)
		local luck = RandomInt(1, 2)
		if luck == 2 then
			RPCItems:RollSwampWaders(caster:GetAbsOrigin())
		end
	end)
	

end

function bog_monster_poison_cloud(event)
	local caster = event.caster
	if not caster:IsNull() then
		local target = event.target
		local damage = event.poison_damage
		ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
	end
end

function swamp_tribal_invoker_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.aggro then
		local telekinesis = caster:FindAbilityByName("cultist_invoker_telekinesis")
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		if telekinesis:IsFullyCastable() and #enemies > 0 then
			local order =
			{
				UnitIndex = caster:GetEntityIndex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				AbilityIndex = telekinesis:GetEntityIndex(),
				TargetIndex = enemies[1]:GetEntityIndex(),
			}
			ExecuteOrderFromTable(order)
		end
	end
end

function swamp_tribal_invoker_die(event)
	local caster = event.caster
	EmitSoundOn("witchdoctor_wdoc_death_09", caster)
	local luck = RandomInt(1, 6)
	if luck == 1 then
		RPCItems:RollSwampDoctorMask(caster:GetAbsOrigin())
	end
end

function swamp_bear_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.aggro then
		EmitSoundOn("LoneDruid_SpiritBear.PreAttack", caster)
	else
		caster:MoveToPosition(Vector(14272, 6464) + RandomVector(RandomInt(50, 900)))
	end
end

function swamp_bear_die(event)
	updateGroveKills(1)
end

function swamp_bear_die_ancestral(event)
	local bear = event.caster
	local location = bear:GetAbsOrigin()
	Timers:CreateTimer(0.1, function()
		local splitEarthParticle = "particles/frostivus_herofx/hyper_state_intro_omnislash_ascension.vpcf"
		local pfx = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, bear)
		ParticleManager:SetParticleControlEnt(pfx, 0, bear, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", location, true)
		ParticleManager:SetParticleControlEnt(pfx, 1, bear, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", location, true)
		Timers:CreateTimer(0.9, function()
			ParticleManager:DestroyParticle(pfx, false)
			bear:SetAbsOrigin(Vector(-4864, 5760))
		end)
	end)
	updateGroveKills(1)
end

function swamp_grove_tender_die(event)
	updateGroveKills(1)
end

function updateGroveKills(count)
	Dungeons.groveKills = Dungeons.groveKills + count
	if Dungeons.groveKills >= 6 and Dungeons.groveState == 0 then
		Dungeons.groveState = 1
		for i = 0, 9, 1 do
			local spawnPoint = Vector(14080, 8448) + Vector(i * 84, 0)
			local moveToPoint = Vector(13989, 7017) + Vector(i * 90, i *- 85)
			local tender = Dungeons:SpawnDungeonUnit("swamp_grove_tender", spawnPoint, 1, 2, 2, nil, Vector(0, -1), false, nil)
			Timers:CreateTimer(0.5, function()
				tender:MoveToPositionAggressive(moveToPoint)
			end)
		end
	elseif Dungeons.groveKills >= 14 and Dungeons.groveState == 1 then
		Dungeons.groveState = 2
		local spawnTable = {Vector(13760, 6848), Vector(13870, 7162), Vector(13871, 7424), Vector(13870, 7616), Vector(13927, 7936), Vector(14208, 8454), Vector(14464, 8454), Vector(14720, 8454), Vector(15076, 8150), Vector(15104, 7882), Vector(14208, 8454), Vector(15322, 7808), Vector(15322, 7536), Vector(15477, 7360), Vector(15322, 7104), Vector(15168, 6865), Vector(15040, 6557), Vector(14976, 6272)}
		for i = 1, #spawnTable, 1 do
			Timers:CreateTimer(i * 5, function()
				local bear = Dungeons:SpawnDungeonUnit("swamp_grove_ancestral_bear", spawnTable[i], 1, 1, 2, "n_creep_Thunderlizard_Big.Roar", Vector(0, -1), true, nil)
				local splitEarthParticle = "particles/frostivus_herofx/hyper_state_intro_omnislash_ascension.vpcf"
				local pfx = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, bear)
				ParticleManager:SetParticleControlEnt(pfx, 0, bear, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", spawnTable[i], true)
				ParticleManager:SetParticleControlEnt(pfx, 1, bear, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", spawnTable[i], true)
				Timers:CreateTimer(1.5, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)
			end)
		end
	elseif Dungeons.groveKills >= 34 and Dungeons.groveState == 2 then
		Dungeons.groveState = 3
		Dungeons:InitiateSwampBoss()
	end
end

function swamp_grove_tender_think(event)
	local caster = event.caster
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		local movementVector = (caster:GetAbsOrigin() - enemies[1]:GetAbsOrigin()):Normalized()
		caster:MoveToPosition(caster:GetAbsOrigin() + movementVector * 380)
	end
end

function swamp_boss_think(event)
	local caster = event.caster
	if caster.begin and not caster.dying then
		local soundTable = {"earth_spirit_earthspi_anger_05", "earth_spirit_earthspi_anger_06", "earth_spirit_earthspi_anger_07", "earth_spirit_earthspi_anger_08"}
		local ability = event.ability
		local boulderAbility = caster:FindAbilityByName("swamp_boss_rolling_boulder")
		if not caster.interval then
			caster.interval = 0
		end
		local targets = Dungeons:GetTargetTable()
		if boulderAbility:IsFullyCastable() and #targets > 0 and not caster:HasModifier("modifier_swamp_boss_root") then
			local targetPoint = targets[RandomInt(1, #targets)]:GetAbsOrigin()
			local order =
			{
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = boulderAbility:entindex(),
				Position = targetPoint
			}
			ExecuteOrderFromTable(order)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_swamp_boss_invincible", {duration = 1.7})
		end
		if not caster:HasModifier("modifier_swamp_boss_root") then
			caster.interval = caster.interval + 1
		end
		if caster.interval % 8 == 0 and not caster:HasModifier("modifier_swamp_boss_invincible") and not caster:HasModifier("modifier_swamp_boss_root") then
			StartAnimation(caster, {duration = 0.4, activity = ACT_DOTA_CAST_ABILITY_4, rate = 1.0})
			EmitSoundOn(soundTable[RandomInt(1, #soundTable)], caster)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_swamp_boss_basic_kick", {duration = 0.8})
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_swamp_boss_root", {duration = 0.3})
			boss_stone_smash(caster, caster:GetAbsOrigin(), targets[RandomInt(1, #targets)])
			if caster:GetHealth() < caster:GetMaxHealth() * 0.66 then
				Timers:CreateTimer(0.4, function()
					boss_stone_smash(caster, caster:GetAbsOrigin(), targets[RandomInt(1, #targets)])
				end)
			end
			if caster:GetHealth() < caster:GetMaxHealth() * 0.33 then
				Timers:CreateTimer(0.8, function()
					boss_stone_smash(caster, caster:GetAbsOrigin(), targets[RandomInt(1, #targets)])
				end)
			end
		end
		if caster.interval >= 46 then
			caster.interval = 0
			if caster:GetHealth() < caster:GetMaxHealth() * 0.63 then
				boss_stone_smash_circle2(caster, ability)
			end
		end
	end
end

function boss_stone_smash_circle(boss, ability)
	StartAnimation(boss, {duration = 3.0, activity = ACT_DOTA_TELEPORT, rate = 1.5})
	ability:ApplyDataDrivenModifier(boss, boss, "modifier_swamp_boss_root", {duration = 3.3})
	ability:ApplyDataDrivenModifier(boss, boss, "modifier_swamp_boss_disarm", {duration = 3.3})
	ability:ApplyDataDrivenModifier(boss, boss, "modifier_swamp_boss_invincible", {duration = 2.5})
	EmitSoundOn("earth_spirit_earthspi_laugh_06", caster)
	local fv = boss:GetForwardVector()
	local bossPosition = boss:GetAbsOrigin()
	local dummyTable = {}
	local dummyAbilityTable = {}
	local dummyRemnantPosTable = {}
	for i = -5, 4, 1 do
		Timers:CreateTimer(0.27 * (i + 6), function()
			local shotVector = WallPhysics:rotateVector(fv, (math.pi / 5) * i)
			local dummy = CreateUnitByName("npc_rock_dummy", bossPosition + shotVector * 280, false, nil, nil, DOTA_TEAM_NEUTRALS)
			dummy:NoHealthBar()
			dummy:AddAbility("dummy_unit"):SetLevel(1)
			local stoneSummon = dummy:FindAbilityByName("swamp_boss_stone_caller")
			stoneSummon:SetLevel(1)
			local stoneSmash = dummy:FindAbilityByName("swamp_boss_boulder_smash")
			stoneSmash:SetLevel(1)
			table.insert(dummyTable, dummy)
			table.insert(dummyAbilityTable, stoneSmash)
			Timers:CreateTimer(0.05, function()

				local remnantPos = bossPosition + shotVector * 350
				dummy:SetForwardVector((remnantPos - dummy:GetAbsOrigin()):Normalized())
				table.insert(dummyRemnantPosTable, remnantPos)
				local order =
				{
					UnitIndex = dummy:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = stoneSummon:entindex(),
					Position = remnantPos
				}
				ExecuteOrderFromTable(order)
			end)
		end)
	end
	Timers:CreateTimer(3.6, function()
		StartAnimation(boss, {duration = 0.8, activity = ACT_DOTA_CAST_ABILITY_1, rate = 0.6})
		EmitSoundOn("earth_spirit_earthspi_pain_12", caster)
		for i = 1, #dummyTable, 1 do
			local order =
			{
				UnitIndex = dummyTable[i]:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = dummyAbilityTable[i]:entindex(),
				Position = dummyRemnantPosTable[i] + dummyTable[i]:GetForwardVector() * 50
			}
			ExecuteOrderFromTable(order)
		end
	end)
	Timers:CreateTimer(13, function()
		for i = 1, #dummyTable, 1 do
			UTIL_Remove(dummyTable[i])
		end
	end)
end

function boss_stone_smash(boss, position, target)

	local dummy = CreateUnitByName("npc_rock_dummy", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
	dummy:NoHealthBar()
	dummy:AddAbility("dummy_unit"):SetLevel(1)
	dummy:AddNoDraw()
	local stoneSummon = dummy:FindAbilityByName("swamp_boss_stone_caller")
	stoneSummon:SetLevel(1)
	local stoneSmash = dummy:FindAbilityByName("swamp_boss_boulder_smash")
	stoneSmash:SetLevel(1)
	local launchDirecton = (target:GetAbsOrigin() - boss:GetAbsOrigin()):Normalized()
	local targetPoint = position + launchDirecton * 130
	Timers:CreateTimer(0.05, function()
		local order =
		{
			UnitIndex = dummy:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = stoneSummon:entindex(),
			Position = targetPoint
		}
		ExecuteOrderFromTable(order)
	end)
	Timers:CreateTimer(0.7, function()
		-- local launchDirecton = (target:GetAbsOrigin() - dummy:GetAbsOrigin()):Normalized()
		local rockPoint = target:GetAbsOrigin() + target:GetForwardVector() * 190
		local displacement = (rockPoint - targetPoint):Normalized()
		dummy:SetAbsOrigin(targetPoint - displacement * 100)
		StartAnimation(boss, {duration = 0.7, activity = ACT_DOTA_CAST_ABILITY_1, rate = 0.6})
		local order =
		{
			UnitIndex = dummy:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = stoneSmash:entindex(),
			Position = rockPoint
		}
		ExecuteOrderFromTable(order)
	end)
	Timers:CreateTimer(8, function()
		UTIL_Remove(dummy)
	end)
end

function boss_stone_smash_circle2(boss, ability)
	StartAnimation(boss, {duration = 3.0, activity = ACT_DOTA_TELEPORT, rate = 1.5})
	ability:ApplyDataDrivenModifier(boss, boss, "modifier_swamp_boss_root", {duration = 3.8})
	ability:ApplyDataDrivenModifier(boss, boss, "modifier_swamp_boss_disarm", {duration = 3.8})
	ability:ApplyDataDrivenModifier(boss, boss, "modifier_swamp_boss_invincible", {duration = 3.0})
	EmitSoundOn("earth_spirit_earthspi_laugh_06", caster)
	local fv = boss:GetForwardVector()
	local bossPosition = boss:GetAbsOrigin()
	local shotVectorTable = {}
	local dummy = CreateUnitByName("npc_rock_dummy", bossPosition, false, nil, nil, DOTA_TEAM_NEUTRALS)
	dummy:NoHealthBar()
	dummy:AddAbility("dummy_unit"):SetLevel(1)
	dummy:AddNoDraw()
	local stoneSummon = dummy:FindAbilityByName("swamp_boss_stone_caller")
	stoneSummon:SetLevel(1)
	local stoneSmash = dummy:FindAbilityByName("swamp_boss_boulder_smash")
	stoneSmash:SetLevel(1)
	for i = -5, 5, 1 do
		Timers:CreateTimer(0.27 * (i + 5), function()
			local shotVector = WallPhysics:rotateVector(fv, (math.pi / 5) * i)
			table.insert(shotVectorTable, shotVector)
			local remnantPos = bossPosition + shotVector * 280
			local order =
			{
				UnitIndex = dummy:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = stoneSummon:entindex(),
				Position = remnantPos
			}
			ExecuteOrderFromTable(order)
		end)
	end
	Timers:CreateTimer(3.6, function()
		StartAnimation(boss, {duration = 0.8, activity = ACT_DOTA_CAST_ABILITY_1, rate = 0.6})
		EmitSoundOn("earth_spirit_earthspi_pain_12", boss)
		for j = 1, #shotVectorTable, 1 do
			Timers:CreateTimer(0.12 * j, function()
				dummy:SetAbsOrigin(bossPosition + shotVectorTable[j] * 245)
				local order =
				{
					UnitIndex = dummy:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = stoneSmash:entindex(),
					Position = bossPosition + shotVectorTable[j] * 270
				}
				Timers:CreateTimer(0.06, function()
					ExecuteOrderFromTable(order)
				end)
			end)
		end
	end)
	Timers:CreateTimer(9, function()
		UTIL_Remove(dummy)
	end)
end
