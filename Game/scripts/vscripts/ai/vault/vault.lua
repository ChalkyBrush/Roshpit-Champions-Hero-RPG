function vaultGuardDeath(event)
	local antimage = Dungeons.antiMage
	local caster = event.caster
	local ability = event.ability
	local blinkAbility = antimage:FindAbilityByName("antimage_blink_custom")
	--print("VAULT GUARD DEATH")
	local order =
	{
		UnitIndex = antimage:GetEntityIndex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = blinkAbility:GetEntityIndex(),
		Position = caster:GetAbsOrigin(),
		Queue = true
	}
	Timers:CreateTimer(1, function()
		ExecuteOrderFromTable(order)
		local speechSlot = findEmptyDialogSlot()
		local time = 6
		antimage:AddSpeechBubble(speechSlot, "#vault_antimage_dialogue_one", time, 0, 0)
		disableSpeech(antimage, time, speechSlot)
		Timers:CreateTimer(0.5, function()
			local playerPosition = MAIN_HERO_TABLE[1]:GetAbsOrigin()
			Timers:CreateTimer(0.5, function()
				antimage:MoveToPosition(playerPosition)
				Timers:CreateTimer(0.05, function()
					antimage:Stop()
				end)
			end)
			Timers:CreateTimer(time, function()
				SpawnAlarmUnits()
				order =
				{
					UnitIndex = antimage:GetEntityIndex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = blinkAbility:GetEntityIndex(),
					Position = Vector(8942, 1664),
					Queue = true
				}
				ExecuteOrderFromTable(order)
			end)
		end)
	end)
	Timers:CreateTimer(4, function()
		CustomGameEventManager:Send_ServerToAllClients("vaultAlarmEvent", {})
	end)
end

function SpawnAlarmUnits()
	local vector1 = Vector(15774, -2624)
	local vector2 = Vector(15751, -437)
	local vector3 = Vector(14800, -437)
	local vector4 = Vector(14800, -2624)
	local soundTable = {"silencer_silen_laugh_03", "silencer_silen_laugh_13", "silencer_silen_lasthit_02"}
	for i = 0, 6, 1 do
		Timers:CreateTimer(i*2, function()
			Dungeons:SpawnDungeonUnit("vault_pleb", vector1, 2, 0, 0, soundTable[RandomInt(1, 3)], Vector(-1, 0), true, nil)
			Dungeons:SpawnDungeonUnit("vault_pleb", vector2, 2, 0, 0, soundTable[RandomInt(1, 3)], Vector(-1, 0), true, nil)
			Dungeons:SpawnDungeonUnit("vault_pleb", vector3, 2, 0, 0, soundTable[RandomInt(1, 3)], Vector(1, 0), true, nil)
			Dungeons:SpawnDungeonUnit("vault_pleb", vector4, 2, 0, 0, soundTable[RandomInt(1, 3)], Vector(1, 0), true, nil)
		end)
	end

	local wardDispenser = CreateUnitByName("npc_dummy_unit", Vector(15808,-384), false, nil, nil, DOTA_TEAM_NEUTRALS)
	table.insert(Dungeons.entityTable, wardDispenser)
	wardDispenser:SetOriginalModel("models/items/wards/esl_wardchest_ward_of_foresight/esl_wardchest_ward_of_foresight.vmdl")
	wardDispenser:SetModel("models/items/wards/esl_wardchest_ward_of_foresight/esl_wardchest_ward_of_foresight.vmdl")
	wardDispenser:SetModelScale(2.5)
	wardDispenser:SetForwardVector(Vector(-1,-1))
	wardDispenser:FindAbilityByName("dummy_unit"):SetLevel(1)
	thinker = Dungeons:CreateDungeonThinker(Vector(15808,-384), "wardDispenser", 400, "vault")
	thinker.wardDispenser = wardDispenser
	table.insert(Dungeons.entityTable, thinker)

	local baseVector = Vector(14800, -2624)
	local increaseX = RandomInt(1, 974)
	local increaseY = RandomInt(1, 1913)
	local spawnVector = baseVector+Vector(increaseX, increaseY, 0)

	local keyholder = Dungeons:SpawnDungeonUnit("vault_invisible_keyholder", Vector(8942, 1664), 1, 4, 6, "riki_riki_anger_01", RandomVector(1), false, nil)
	table.insert(Dungeons.entityTable, keyholder)
	keyholder.aggroRadius = 0
	keyholder:FindAbilityByName("riki_permanent_invisibility"):SetLevel(4)
	keyholder:FindAbilityByName("invis_dungeon_creep"):SetLevel(1)
	keyholder.specialAggro = "keyholder"
	local gem = RPCItems:CreateItem("item_gem", nil, nil)
	keyholder.gem = gem
	RPCItems:GiveItemToHero(keyholder, gem)
	Timers:CreateTimer(5, function()
		FindClearSpaceForUnit(keyholder, spawnVector, false)
	end)
end

function key_holder_think(event)
	--print("key_think")
	local caster = event.caster
	local ability = event.ability
	local point = caster:GetAbsOrigin()
	-- local enemies = FindUnitsInRadius( caster:GetTeamNumber(), point, nil, 900, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if not caster.event then
		local enemies = Entities:FindAllInSphere(point, 900)
		--print(#enemies)
		if caster:GetHealth() < 50000 then
			local speechSlot = findEmptyDialogSlot()
			local time = 6
			caster:AddSpeechBubble(speechSlot, "#vault_keyholder_dialogue", time, 0, 0)
			disableSpeech(caster, time, speechSlot)
			caster.event = true
			Timers:CreateTimer(1, function()
				caster:RemoveModifierByName("modifier_key_holder_ability")
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_key_holder_done_with_fighting", {duration = 99999})
				caster:MoveToPosition(Vector(14738, -1280))
			end)
			Timers:CreateTimer(3, function()
				lowerWall(Dungeons.wall1)
				lowerWall(Dungeons.wall2)
			end)
			Timers:CreateTimer(5, function()
				UTIL_Remove(Dungeons.blocker1)
				UTIL_Remove(Dungeons.blocker2)
				UTIL_Remove(Dungeons.blocker3)
				initializeRoom2()
			end)	
			Timers:CreateTimer(8, function()
				caster:MoveToPosition(Vector(15769, -2508))	
			end)	
		end 	
	end
end

function initializeRoom2()
	Dungeons.blocker1 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(14272,-960), Name ="wallObstruction"})
	Dungeons.blocker2 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(14400,-960), Name ="wallObstruction"})
	Dungeons.blocker3 = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(14528,-960), Name ="wallObstruction"})
	AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(14381,-877), 300, 99999, false)
	Dungeons.wall1 = CreateUnitByName("npc_dummy_unit", Vector(14381,-877), false, nil, nil, DOTA_TEAM_NEUTRALS)
	Dungeons.wall1:SetOriginalModel("models/props_garden/good_stonewall001c.vmdl")
	Dungeons.wall1:SetModel("models/props_garden/good_stonewall001c.vmdl")
	Dungeons.wall1:SetModelScale(2.8)
	Dungeons.wall1:SetForwardVector(Vector(1,0))
	Dungeons.wall1:SetAbsOrigin(Dungeons.wall1:GetAbsOrigin()+Vector(0,0,236))
	Dungeons.wall1:FindAbilityByName("dummy_unit"):SetLevel(1)	
	table.insert(Dungeons.entityTable, Dungeons.wall1)

	Dungeons:SpawnDungeonUnit("vault_executioner", Vector(13752, -1088), 1, 2, 3, "silencer_silen_ability_glaive_03", Vector(1,0), false, nil)
	Dungeons:SpawnDungeonUnit("vault_executioner", Vector(13752, -1292), 1, 2, 3, "silencer_silen_ability_glaive_03", Vector(1,0), false, nil)
	Dungeons:SpawnDungeonUnit("vault_executioner", Vector(13985, -1202), 1, 2, 3, "silencer_silen_ability_glaive_03", Vector(1,0), false, nil)
	for i = 0, 2, 1 do
		Dungeons:SpawnDungeonUnit("vault_henchman", Vector(13304, -833+i*200), 1, 1, 1, "silencer_silen_anger_06", Vector(0,-1), false, nil)
		Dungeons:SpawnDungeonUnit("vault_henchman", Vector(13404, -833+i*200), 1, 1, 1, "silencer_silen_anger_06", Vector(0,-1), false, nil)
		Dungeons:SpawnDungeonUnit("vault_henchman", Vector(13504, -833+i*200), 1, 1, 1, "silencer_silen_anger_06", Vector(0,-1), false, nil)
	end
	Dungeons:SpawnDungeonUnit("vault_treasurer", Vector(13888, -128), 1, 4, 8, "silencer_silen_anger_06", Vector(0,1), false, nil)
	switch = CreateUnitByName("npc_dummy_unit", Vector(13794,-532), false, nil, nil, DOTA_TEAM_NEUTRALS)
	switch:SetOriginalModel("models/props_stone/stoneblock009a.vmdl")
	switch:SetModel("models/props_stone/stoneblock009a.vmdl")
	switch:SetModelScale(3.0)
	switch:SetForwardVector(Vector(1,0))
	switch:SetAbsOrigin(switch:GetAbsOrigin()+Vector(0,0,-105))
	switch:FindAbilityByName("dummy_unit"):SetLevel(1)
	table.insert(Dungeons.entityTable, switch)
	local thinker = Dungeons:CreateDungeonThinker(Vector(13794,-532), "vaultSwitch1", 200, "vault")
	thinker.switch = switch

	
end

function statue_die(event)
	Dungeons.goldStatus = Dungeons.goldStatus + 1
	local pedestal = Dungeons.finalPedestal
	local pedestalOrigin = Dungeons.finalPedestal:GetAbsOrigin()
	if Dungeons.goldStatus == 6 then
		ScreenShake(pedestalOrigin, 300, 0.5, 1, 9000, 0, true)
		EmitSoundOn("Visage_Familar.StoneForm.Cast", pedestal)
		for i = 1, 90, 1 do
			Timers:CreateTimer(i*0.05, function()
				pedestal:SetAbsOrigin(pedestalOrigin+Vector(i*-3, 0, 0))
			end)
		end
		Timers:CreateTimer(4.5, function()
			ScreenShake(pedestalOrigin, 300, 0.5, 1, 9000, 0, true)
			EmitSoundOn("Visage_Familar.StoneForm.Cast", pedestal)
		end)
		switch = CreateUnitByName("npc_dummy_unit", pedestalOrigin, false, nil, nil, DOTA_TEAM_NEUTRALS)
		switch:SetOriginalModel("models/props_stone/stoneblock009a.vmdl")
		switch:SetModel("models/props_stone/stoneblock009a.vmdl")
		switch:SetModelScale(3.0)
		switch:SetForwardVector(Vector(1,0))
		switch:SetAbsOrigin(switch:GetAbsOrigin()+Vector(0,0,-105))
		switch:FindAbilityByName("dummy_unit"):SetLevel(1)
		table.insert(Dungeons.entityTable, switch)
		local thinker = Dungeons:CreateDungeonThinker(pedestalOrigin, "vaultSwitch2", 200, "vault")
		thinker.switch = switch
		for i = 1, #MAIN_HERO_TABLE, 1 do
			MAIN_HERO_TABLE[i]:RemoveModifierByName("modifier_vault_statue_activator")
		end
		if Dungeons.goldApplyThinker then
			if Dungeons.goldPfx then
				ParticleManager:DestroyParticle(Dungeons.goldPfx, false)
			end
			UTIL_Remove(Dungeons.goldApplyThinker)
			
		end
	end
end

function statue_think(event)
	local caster = event.caster
	if caster:HasModifier("modifier_vault_golden") then
	end
end

function arrowImpact(event)
	local target = event.target
	local ability = event.ability
	local caster = Dungeons.DungeonMaster
	EmitSoundOn("Hero_Mirana.ProjectileImpact", target)
	local damage = Events:GetAdjustedAbilityDamage(30000, 50000, 0)
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR })
	PopupDamage(target, damage)
end

function fireImpact(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local damage = Events:GetAdjustedAbilityDamage(2000, 10000, 0)
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
	PopupDamage(target, damage)
end

function lowerWall(wall)
	EmitSoundOn("Visage_Familar.StoneForm.Cast", wall)
	local wallOrigin = wall:GetAbsOrigin()
	ScreenShake(wallOrigin, 200, 0.5, 1, 9000, 0, true)
	for i = 1, 60, 1 do
		Timers:CreateTimer(i*0.05, function()
			wall:SetAbsOrigin(wallOrigin - Vector(0,0,4)*i)
		end)
	end
	Timers:CreateTimer(3, function()
		ScreenShake(wallOrigin, 200, 0.5, 1, 9000, 0, true)
		EmitSoundOn("Visage_Familar.StoneForm.Cast", wall)
	end)
	-- Timers:CreateTimer(5, function()
	-- 	UTIL_Remove(wall)
	-- end)
end

function key_holder_die(event)
	local caster = event.caster
	Timers:CreateTimer(3, function()
		lowerWall(Dungeons.wall1)
		lowerWall(Dungeons.wall2)
	end)
	Timers:CreateTimer(5, function()
		UTIL_Remove(Dungeons.blocker1)
		UTIL_Remove(Dungeons.blocker2)
		UTIL_Remove(Dungeons.blocker3)
		initializeRoom2()
	end)	
	UTIL_Remove(caster.gem)
end

function vaultExecutionerSkill(event)
	local caster = event.caster
	local point = caster:GetAbsOrigin()
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_executioner_chargeup", {duration = 1.65})
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), point, nil, 450, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		StartAnimation(caster, {duration=1.2, activity=ACT_DOTA_CAST_ABILITY_4, rate=0.45})
		EmitSoundOn("silencer_silen_attack_14", caster)
		Timers:CreateTimer(1.2, function()
			Timers:CreateTimer(0.1, function()
				if caster:IsAlive() then
					EmitSoundOnLocationWithCaster(point, "Hero_Silencer.LastWord.Damage", caster)
					StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_CAST_ABILITY_4, rate=1.4})
					local point = point+caster:GetForwardVector()*90
			        local particleName = "particles/econ/items/abaddon/abaddon_alliance/abaddon_aphotic_shield_alliance_explosion.vpcf"
			        local particleVector = point
			      	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
			      	ParticleManager:SetParticleControl( pfx, 0, particleVector )
			      	ParticleManager:SetParticleControl( pfx, 1, particleVector )	
			      	EmitSoundOn("silencer_silen_deny_10", caster)
			      	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), point, nil, 280, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
					for _,enemy in pairs(enemies) do
						local damage = Events:GetAdjustedAbilityDamage(5000, 20000, 0)
						ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })	
					end
					Timers:CreateTimer(4, function()
						ParticleManager:DestroyParticle( pfx, false )
					end)
				end
			end)
		end)
	end 
end

function arcanist_think(event)
	local caster = event.caster
	local ability = event.ability
  	local position = caster:GetAbsOrigin()
  	local radius = 550
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		EmitSoundOn("Hero_ObsidianDestroyer.EssenceAura", caster)
		for _,enemy in pairs(enemies) do
			local info = 
			{
				Target = enemy,
				Source = caster,
				Ability = ability,	
				EffectName = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_arcane_orb.vpcf",
				StartPosition = "attach_hitloc",
				bDrawsOnMinimap = false, 
			        bDodgeable = true,
			        bIsAttack = false, 
			        bVisibleToEnemies = true,
			        bReplaceExisting = false,
			        flExpireTime = GameRules:GetGameTime() + 4,
				bProvidesVision = true,
				iVisionRadius = 0,
				iMoveSpeed = 600,
				iVisionTeamNumber = caster:GetTeamNumber()
			}
			projectile = ProjectileManager:CreateTrackingProjectile(info)
			
		end
	end  	
end

function majinaqThink(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.fireTrapInterval then
		caster.fireTrapInterval = 0
	end
	caster.fireTrapInterval = caster.fireTrapInterval + 1
	if caster.fireTrapInterval == 10 and not caster.dying then
		caster.dogTrap1 = drop_barking_dog_trap(ability, 1)
		caster.dogTrap2 = drop_barking_dog_trap(ability, 2)
		caster.dogTrap3 = drop_barking_dog_trap(ability, 3)
		caster.dogTrap4 = drop_barking_dog_trap(ability, 4)
	end
	if caster.fireTrapInterval >= 12 and caster.fireTrapInterval < 20 and caster.fireTrapInterval%3 == 0 and not caster.dying then
		barkingDog_think(caster.dogTrap1, true)
		barkingDog_think(caster.dogTrap2, false)
		barkingDog_think(caster.dogTrap3, false)
		barkingDog_think(caster.dogTrap4, false)
	end
	if caster.fireTrapInterval == 20 then
		lift_barking_dog_trap_and_remove(caster.dogTrap1)
		lift_barking_dog_trap_and_remove(caster.dogTrap2)
		lift_barking_dog_trap_and_remove(caster.dogTrap3)
		lift_barking_dog_trap_and_remove(caster.dogTrap4)
		caster.fireTrapInterval = 0
	end
end

function lift_barking_dog_trap_and_remove(dogTrap)
	for i = 0, 90, 1 do
		Timers:CreateTimer(i*0.03, function()
			local currentPosition = dogTrap:GetAbsOrigin()
			dogTrap:SetAbsOrigin(currentPosition+Vector(0,0,15))
			if i == 90 then
				UTIL_Remove(dogTrap)
			end
		end)
	end	
end

function drop_barking_dog_trap(ability, quadrant)
	local fvTable = {Vector(0,1), Vector(1,0), Vector(0,-1), Vector(-1, 0)}
	local fv = fvTable[RandomInt(1,4)]
	local roomVector = Vector(0,0)
	local randomX = 0
	local randomY = 0
	if quadrant == 1 then
		roomVector = Vector(8960, 768)
		randomX = RandomInt(0, 395)
		randomY = RandomInt(0, 329)	
	elseif quadrant == 2 then
		roomVector = Vector(9152, 1283)
		randomX = RandomInt(0, 452)
		randomY = RandomInt(0, 460)	
	elseif quadrant == 3 then
		roomVector = Vector(9532, 792)
		randomX = RandomInt(0, 483)
		randomY = RandomInt(0, 450)	
	elseif quadrant == 4 then
		roomVector = Vector(9769, 1411)
		randomX = RandomInt(0, 430)
		randomY = RandomInt(0, 329)	
	end
	local dogTrap = CreateUnitByName("red_fox", roomVector+Vector(randomX, randomY), false, nil, nil, DOTA_TEAM_NEUTRALS)
	dogTrap:SetAbsOrigin(dogTrap:GetAbsOrigin()+Vector(0,0,950))
	dogTrap:SetForwardVector(fv)
	dogTrap.fv = fv
	dogTrap:SetOriginalModel("models/props/traps/barking_dog/barking_dog.vmdl")
	dogTrap:SetModel("models/props/traps/barking_dog/barking_dog.vmdl")
	dogTrap:SetModelScale(1.0)
	dogTrap:NoHealthBar()
	dogTrap:AddAbility("town_unit"):SetLevel(1)
	dogTrap.fallVelocity = 1
	for i = 0, 30, 1 do
		Timers:CreateTimer(i*0.03, function()
			local currentPosition = dogTrap:GetAbsOrigin()
			--print("current_position:")
			--print(currentPosition)
			--print("i = "..i)
			dogTrap:SetAbsOrigin(currentPosition-Vector(0,0,dogTrap.fallVelocity))
			dogTrap.fallVelocity = dogTrap.fallVelocity+2
			if i == 30 then
				EmitSoundOn("Visage_Familar.StoneForm.Cast", dogTrap)
				ScreenShake(currentPosition, 300, 0.5, 0.5, 9000, 0, true)
				local position = currentPosition
				local pfx = ParticleManager:CreateParticle( "particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, dogTrap )
				ParticleManager:SetParticleControl( pfx, 0, position )
				ParticleManager:SetParticleControl( pfx, 1, Vector(200, 200, 200) )
				Timers:CreateTimer(4, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)
				local enemies = FindUnitsInRadius( dogTrap:GetTeamNumber(), position, nil, 180, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
				for _,enemy in pairs(enemies) do
					local damage = Events:GetAdjustedAbilityDamage(4000, 15000, 0)
					ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
					FindClearSpaceForUnit(enemy, enemy:GetAbsOrigin(), false)
				end
			end
		end)
	end
	return dogTrap
end

function barkingDog_think(barkingDog, bSound)
	StartAnimation(barkingDog, {duration=2.5, activity=ACT_DOTA_ATTACK, rate=1})
	Timers:CreateTimer(0.3, function()
		if bSound then
			EmitSoundOn("Conquest.FireTrap", barkingDog)
		end
		createFireProjectile(Dungeons.DungeonMaster, barkingDog:GetAbsOrigin(), barkingDog.fv)
	end)
end

function createFireProjectile(caster, position, fv)
	local ability = Dungeons.DungeonMaster.fireAbility
	local speed = 400
	local info = 
	{
			Ability = ability,
        	EffectName = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf",
        	vSpawnOrigin = position,
        	fDistance = 280,
        	fStartRadius = 100,
        	fEndRadius = 200,
        	Source = caster,
        	StartPosition = "custom_origin",
        	bHasFrontalCone = true,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_FRIENDLY+DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
		vVelocity = fv * speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)	
end

function majinaq_blink_strike_begin(event)
	local soundTable = {"antimage_anti_laugh_04", "antimage_anti_laugh_05", "antimage_anti_laugh_06", "antimage_anti_laugh_09"}
	EmitGlobalSound(soundTable[RandomInt(1, 4)])
end

function blink_strike_think(event)
	local caster = event.caster
	if not caster.dying then
		local position = caster:GetAbsOrigin()
		local ability = event.ability
		local blinkAbility = caster:FindAbilityByName("antimage_blink_custom")
		local roomVector = Vector(8914, 1747)
		local randomY = -RandomInt(0, 1000)
		local randomX = RandomInt(0, 1120)
		StartAnimation(caster, {duration=0.45, activity=ACT_DOTA_CAST_ABILITY_2, rate=0.85})
		local order =
		{
			UnitIndex = caster:GetEntityIndex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = blinkAbility:GetEntityIndex(),
			Position = roomVector+Vector(randomX, randomY),
			Queue = false
		}
		ExecuteOrderFromTable(order)
		EmitSoundOn("Hero_Silencer.LastWord.Cast", caster)
		create_majinaq_projectile(caster, ability, position)
		create_majinaq_projectile(caster, ability, position)
	end
end

function create_majinaq_projectile(caster, ability, position)
	local projectileParticle = "particles/base_attacks/majinaq_linear.vpcf"
	local projectileOrigin = caster:GetAbsOrigin()
	local start_radius = 95
	local end_radius = 95
	local fv = RandomVector(1)
	local range = 1200
	local speed = 300 + RandomInt(0, 250)
		local info = 
		{
				Ability = ability,
	        	EffectName = projectileParticle,
	        	vSpawnOrigin = projectileOrigin+Vector(0,0,110),
	        	fDistance = range,
	        	fStartRadius = start_radius,
	        	fEndRadius = end_radius,
	        	Source = caster,
	        	StartPosition = "attach_attack1",
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

function majinaq_projectile_hit(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = Events:GetAdjustedAbilityDamage(3000, 30000, 0)
	EmitSoundOn("Hero_Silencer.LastWord.Damage", caster)
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
	target:ReduceMana(400)
end

function findEmptyDialogSlot()
    if not Events.Dialog1 then
        Events.Dialog1 = true
        return 1
    elseif not Events.Dialog2 then
        Events.Dialog2 = true
        return 2
    elseif not Events.Dialog3 then
        Events.Dialog3 = true
        return 3
    end
    return 4
end

function disableSpeech(caster, time, speechSlot)
	caster.hasSpeechBubble = true
	Timers:CreateTimer(time+1,
	    function()
	      	caster.hasSpeechBubble = false
	      	clearDialogSlot(speechSlot)
	    end)
end

function clearDialogSlot(slot)
	if slot == 1 then
		Events.Dialog1 = false
	elseif slot == 2 then
		Events.Dialog2 = false
	elseif slot == 3 then
		Events.Dialog3 = false
	end
end