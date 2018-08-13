function EnterLava(trigger)
	local hero = trigger.activator
	local caster = Events.GameMaster
	local ability = caster:FindAbilityByName("npc_abilities")
	if not hero:IsAlive() or hero:HasModifier("modifier_heavens_charge_falling") then
		return false
	end
	if hero:HasFlyMovementCapability() or Filters:HasFlyingModifier(hero) then
		return false
	end
	if hero:HasModifier("modifier_rpc_terrasic_lava_boots") then
		hero.foot:ApplyDataDrivenModifier(hero.InventoryUnit, hero, "modifier_rpc_terrasic_lava_boot_effect", {duration = 7})
		return false
	end
	EmitSoundOn("Env.LavaHit", hero)
	StartAnimation(hero, {duration=4, activity=ACT_DOTA_FLAIL, rate=1.4})
		hero:RemoveModifierByName("modifier_lava_jumping")
		Timers:CreateTimer(0.03, function()
			LavaJump(hero, hero:GetForwardVector(), RandomInt(10, 13), 27, 25, 1)
			ability:ApplyDataDrivenModifier(caster, hero, "modifier_lava_flailing", {duration = 4})
		end)
	print("LaVA TOUCH!------------")
	ability:ApplyDataDrivenModifier(caster, hero, "modifier_lava_hit", {duration = 4})
	print("TOUCHING LAVA!!")
end

function Lava3(trigger)
	local hero = trigger.activator
	local caster = Events.GameMaster
	local ability = caster:FindAbilityByName("npc_abilities")
	if not hero:IsAlive() or hero:HasModifier("modifier_heavens_charge_falling") then
		return false
	end
	if hero:HasFlyMovementCapability() or Filters:HasFlyingModifier(hero) then
		return false
	end
	if hero:HasModifier("modifier_rpc_terrasic_lava_boots") then
		hero.foot:ApplyDataDrivenModifier(hero.InventoryUnit, hero, "modifier_rpc_terrasic_lava_boot_effect", {duration = 7})
		return false
	end
	EmitSoundOn("Env.LavaHit", hero)
	StartAnimation(hero, {duration=4, activity=ACT_DOTA_FLAIL, rate=1.4})
		hero:RemoveModifierByName("modifier_lava_jumping")
		Timers:CreateTimer(0.03, function()
			LavaJump(hero, hero:GetForwardVector(), RandomInt(10, 13), 27, 25, 1)
			ability:ApplyDataDrivenModifier(caster, hero, "modifier_lava_flailing", {duration = 4})
		end)
	print("LaVA TOUCH!------------")
	ability:ApplyDataDrivenModifier(caster, hero, "modifier_lava_hit", {duration = 4})
	print("TOUCHING LAVA!!")
end

function Lava4(trigger)
	local hero = trigger.activator
	if hero:HasFlyMovementCapability() or Filters:HasFlyingModifier(hero) then
		return false
	end
	local caster = Events.GameMaster
	local ability = caster:FindAbilityByName("npc_abilities")
	if not hero:IsAlive() or hero:HasModifier("modifier_heaevns_charge_falling") then
		return false
	end
	if hero:HasFlyMovementCapability() or Filters:HasFlyingModifier(hero) then
		return false
	end
	if hero:HasModifier("modifier_rpc_terrasic_lava_boots") then
		hero.foot:ApplyDataDrivenModifier(hero.InventoryUnit, hero, "modifier_rpc_terrasic_lava_boot_effect", {duration = 7})
		return false
	end
	EmitSoundOn("Env.LavaHit", hero)
	StartAnimation(hero, {duration=4, activity=ACT_DOTA_FLAIL, rate=1.4})
		hero:RemoveModifierByName("modifier_lava_jumping")
		Timers:CreateTimer(0.03, function()
			LavaJump(hero, hero:GetForwardVector(), RandomInt(10, 13), 27, 25, 1)
			ability:ApplyDataDrivenModifier(caster, hero, "modifier_lava_flailing", {duration = 4})
		end)
	print("LaVA TOUCH!------------")
	ability:ApplyDataDrivenModifier(caster, hero, "modifier_lava_hit", {duration = 4})
	print("TOUCHING LAVA!!")
end

function Lava5(trigger)
	local hero = trigger.activator
	if hero:HasFlyMovementCapability() or Filters:HasFlyingModifier(hero) then
		return false
	end
	Timers:CreateTimer(0.2, function()
		local hero = trigger.activator
		if not hero:HasModifier("modifier_moving_platform_active") then
			local caster = Events.GameMaster
			local ability = caster:FindAbilityByName("npc_abilities")
			if not hero:IsAlive() or hero:HasModifier("modifier_heaevns_charge_falling") then
				return false
			end
			if hero:HasModifier("modifier_rpc_terrasic_lava_boots") then
				hero.foot:ApplyDataDrivenModifier(hero.InventoryUnit, hero, "modifier_rpc_terrasic_lava_boot_effect", {duration = 7})
				return false
			end
			EmitSoundOn("Env.LavaHit", hero)
			StartAnimation(hero, {duration=4, activity=ACT_DOTA_FLAIL, rate=1.4})
				hero:RemoveModifierByName("modifier_lava_jumping")
				Timers:CreateTimer(0.03, function()
					LavaJump(hero, hero:GetForwardVector(), RandomInt(10, 13), 27, 25, 1)
					ability:ApplyDataDrivenModifier(caster, hero, "modifier_lava_flailing", {duration = 4})
				end)
			print("LaVA TOUCH!------------")
			ability:ApplyDataDrivenModifier(caster, hero, "modifier_lava_hit", {duration = 4})
			print("TOUCHING LAVA!!")
		end
	end)

end

function Lava6(trigger)
	local hero = trigger.activator
	if hero:HasFlyMovementCapability() or Filters:HasFlyingModifier(hero) then
		return false
	end
	local caster = Events.GameMaster
	local ability = caster:FindAbilityByName("npc_abilities")
	if not hero:IsAlive() or hero:HasModifier("modifier_heavens_charge_falling") then
		return false
	end
	if hero:HasModifier("modifier_rpc_terrasic_lava_boots") then
		hero.foot:ApplyDataDrivenModifier(hero.InventoryUnit, hero, "modifier_rpc_terrasic_lava_boot_effect", {duration = 7})
		return false
	end
	EmitSoundOn("Env.LavaHit", hero)
	StartAnimation(hero, {duration=4, activity=ACT_DOTA_FLAIL, rate=1.4})
		hero:RemoveModifierByName("modifier_lava_jumping")
		Timers:CreateTimer(0.03, function()
			LavaJump(hero, hero:GetForwardVector(), RandomInt(10, 13), 27, 25, 1)
			ability:ApplyDataDrivenModifier(caster, hero, "modifier_lava_flailing", {duration = 4})
		end)
	print("LaVA TOUCH!------------")
	ability:ApplyDataDrivenModifier(caster, hero, "modifier_lava_hit", {duration = 4})
	print("TOUCHING LAVA!!")
end

function lava_damage_think(event)
	local target = event.target
	local attacker = Events.GameMaster
	local damagePercentage = 0.03
	if GameState:GetDifficultyFactor() == 2 then
		damagePercentage = 0.04
	elseif GameState:GetDifficultyFactor() == 3 then
		damagePercentage = 0.05
	end
	local damage = target:GetMaxHealth()*damagePercentage
	-- local damage = Events:GetDifficultyScaledDamage(300, 3000, 10000)
	ApplyDamage({ victim = target, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
end

function LavaJump(unit, forwardVector, propulsion, liftForce, liftDuration, gravity)
	local gameMaster = Events.GameMaster
	local gameMasterAbil = gameMaster:FindAbilityByName("npc_abilities")
	local jumpingModifier = "modifier_lava_jumping"
	if unit:HasModifier(jumpingModifier) then
		return false
	end
	gameMasterAbil:ApplyDataDrivenModifier(gameMaster, unit, jumpingModifier, {duration = 5})
	print("----LAVA JUMP----")

	for i = 1, liftDuration, 1 do
		Timers:CreateTimer(0.03*i, function()
			if IsValidEntity(unit) then
				local currentPosition = unit:GetAbsOrigin()
				local newPosition = currentPosition+forwardVector*propulsion+Vector(0,0,liftForce-i*gravity)
				local obstruction = WallPhysics:FindNearestObstruction(newPosition*Vector(1,1,0))
				local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (newPosition)*Vector(1,1,0), unit)
				if not blockUnit then
					if GetGroundPosition(newPosition, unit).z > currentPosition.z + 180 then
						newPosition = newPosition-(forwardVector*propulsion)
					end
				else
					newPosition = newPosition-(forwardVector*propulsion)
				end
				unit:SetOrigin(newPosition)
			end
		end)
	end
	local fallLoop = 0
	Timers:CreateTimer(0.03*liftDuration+0.03, function()
		Timers:CreateTimer(0.03*fallLoop, function()
			if IsValidEntity(unit) then
				fallLoop = fallLoop + 1
				local currentPosition = unit:GetAbsOrigin()
				local newPosition = currentPosition+forwardVector*propulsion-Vector(0,0,fallLoop*gravity)

				local obstruction = WallPhysics:FindNearestObstruction(newPosition*Vector(1,1,0))
				local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (newPosition)*Vector(1,1,0), unit)
				if not blockUnit then
					if GetGroundPosition(newPosition, unit).z > currentPosition.z + 180 then
						newPosition = newPosition-(forwardVector*propulsion)
					end
				else
					newPosition = newPosition-(forwardVector*propulsion)
				end
				unit:SetOrigin(newPosition)
				-- print("NEWPOSITION.Z:")
				-- print(newPosition.z)

				if newPosition.z - GetGroundPosition(newPosition, unit).z < 10 then
					print("z1")
					unit:RemoveModifierByName(jumpingModifier)
					FindClearSpaceForUnit(unit, newPosition, false)
					WallPhysics:UnitLand(unit)
					unit:RemoveModifierByName("modifier_lava_jumping")
					print (currentPosition.z)
					if (currentPosition.z <= 252) then
						local triggerTable = {}
						triggerTable.activator = unit
						EnterLava(triggerTable)
					end
				elseif newPosition.z <= 252 then
					print("z2")
					unit:RemoveModifierByName(jumpingModifier)
					-- FindClearSpaceForUnit(unit, newPosition, false)
					WallPhysics:UnitLand(unit)
					local triggerTable = {}
					triggerTable.activator = unit
					EnterLava(triggerTable)
				else
					return 0.03
				end
			end
		end)
	end)
end

function terrasicSpawnRegion1()
	Tanari:SpawnLavaLegions1()
	Tanari:SpawnTerrasicCraterZone1()
end

function StatueSpawnOne()
	Tanari:StatueSpawnFlowers()
end

function SpawnPathAmbushers()
	Tanari:SpawnAmbushers()
end

function SpawnHeroTrail2()
	if not Tanari.HeroTrail2 then
		Tanari:SpawnHeroTrail2()
	end
end

function ChampionRemnant(trigger)
	local hero = trigger.activator
	local baseY = -3648
	local remnantSpawnY = baseY + RandomInt(0, 500)
	if not Tanari.unibi.champRemnantPhase then
		Tanari.unibi.champRemnantPhase = 0
		local remnant = CreateUnitByName("tanari_hero_remnant", Vector(hero:GetAbsOrigin().x - 500, remnantSpawnY), false, nil, nil, DOTA_TEAM_NEUTRALS)
		CustomAbilities:QuickAttachParticle("particles/econ/items/outworld_devourer/od_shards_exile/od_shards_exile_prison_end_mana_flash.vpcf", remnant, 1)
		Timers:CreateTimer(0.05, function()
			remnant:MoveToPosition(remnant:GetAbsOrigin()+Vector(1600, 0))
			Tanari.unibi.champRemnantPhase = 2
		end)
		EmitSoundOn("Tanari.RemnantAppear", remnant)
		Timers:CreateTimer(5, function()
			EmitSoundOnLocationWithCaster(remnant:GetAbsOrigin(), "Tanari.RemnantDisappear", hero)
			
			local pfx = ParticleManager:CreateParticle( "particles/generic_gameplay/illusion_killed.vpcf", PATTACH_CUSTOMORIGIN, hero )
			ParticleManager:SetParticleControl( pfx, 0, remnant:GetAbsOrigin()+Vector(0,0,100) )
			Timers:CreateTimer(2.5, function() 
			  ParticleManager:DestroyParticle( pfx, false )
			end) 
			
			UTIL_Remove(remnant)
		end)
	elseif Tanari.unibi.champRemnantPhase == 2 then
		Tanari.unibi.champRemnantPhase = 3
		local remnant = CreateUnitByName("tanari_hero_remnant", Vector(hero:GetAbsOrigin().x - 500, remnantSpawnY), false, nil, nil, DOTA_TEAM_NEUTRALS)
		CustomAbilities:QuickAttachParticle("particles/econ/items/outworld_devourer/od_shards_exile/od_shards_exile_prison_end_mana_flash.vpcf", remnant, 1)
		Timers:CreateTimer(0.05, function()
			remnant:MoveToPosition(remnant:GetAbsOrigin()+Vector(1600, 0))
			Tanari.unibi.champRemnantPhase = 4
		end)
		EmitSoundOn("Tanari.RemnantAppear", remnant)
		StartAnimation(remnant, {duration=5, activity=ACT_DOTA_RUN, rate=0.8, translate="injured"})
		Timers:CreateTimer(5, function()
			EmitSoundOnLocationWithCaster(remnant:GetAbsOrigin(), "Tanari.RemnantDisappear", hero)
			
			local pfx = ParticleManager:CreateParticle( "particles/generic_gameplay/illusion_killed.vpcf", PATTACH_CUSTOMORIGIN, hero )
			ParticleManager:SetParticleControl( pfx, 0, remnant:GetAbsOrigin()+Vector(0,0,100) )
			Timers:CreateTimer(2.5, function() 
			  ParticleManager:DestroyParticle( pfx, false )
			end) 
			UTIL_Remove(remnant)
		end)
	elseif Tanari.unibi.champRemnantPhase == 4 then
		Tanari.unibi.champRemnantPhase = 5
		local remnant = CreateUnitByName("tanari_hero_remnant", Vector(hero:GetAbsOrigin().x - 500, hero:GetAbsOrigin().y), false, nil, nil, DOTA_TEAM_NEUTRALS)
		CustomAbilities:QuickAttachParticle("particles/econ/items/outworld_devourer/od_shards_exile/od_shards_exile_prison_end_mana_flash.vpcf", remnant, 1)
		Timers:CreateTimer(0.05, function()
			remnant:MoveToPosition(remnant:GetAbsOrigin()+Vector(1600, 0))
		end)
		EmitSoundOn("Tanari.RemnantAppear", remnant)
		StartAnimation(remnant, {duration=3, activity=ACT_DOTA_RUN, rate=0.8, translate="injured"})
		Timers:CreateTimer(3.05, function()
			remnant:Stop()
			StartAnimation(remnant, {duration=4, activity=ACT_DOTA_DIE, rate=0.5})
		end)
		Timers:CreateTimer(7, function()
			EmitSoundOnLocationWithCaster(remnant:GetAbsOrigin(), "Tanari.RemnantDisappear", hero)
			
			local pfx = ParticleManager:CreateParticle( "particles/generic_gameplay/illusion_killed.vpcf", PATTACH_CUSTOMORIGIN, hero )
			ParticleManager:SetParticleControl( pfx, 0, remnant:GetAbsOrigin()+Vector(70,0,100) )
			Timers:CreateTimer(2.5, function() 
			  ParticleManager:DestroyParticle( pfx, false )
			end) 
			Tanari.unibi.champRemnantPhase = 6
			UTIL_Remove(remnant)
		end)
	end
end

function SpawnMountainBullies()
	Tanari:SpawnMountainBullies()
end

function SpecialWall1(trigger)
	local hero = trigger.activator
	if hero:IsHero() then
		FindClearSpaceForUnit(hero, hero:GetAbsOrigin()+Vector(0,100,0), false)
	end
end

function SpecialWall2(trigger)
	local hero = trigger.activator
	if not Tanari.secretWaterHutOpen then
		if hero:IsHero() then
			FindClearSpaceForUnit(hero, hero:GetAbsOrigin()+Vector(-100,0,0), false)
		end
	end
end

function RiverFlow(trigger)
	print("RIVER FLOW")
	local hero = trigger.activator
	local gameMaster = Events.GameMaster
	local gameMasterAbil = gameMaster:FindAbilityByName("npc_abilities")
	gameMasterAbil:ApplyDataDrivenModifier(gameMaster, hero, "modifier_river_push", {})
end

function RiverFlowLeave(trigger)
	local hero = trigger.activator
	hero:RemoveModifierByName("modifier_river_push")
end

function river_flow_think(event)
	local target = event.target
	local newPos = target:GetAbsOrigin()+Vector(-5, 0)
	local groundPos = GetGroundPosition(newPos, target)
	if groundPos.z > target:GetAbsOrigin().z then
	else
		target:SetAbsOrigin(newPos)
	end
end

function WaterfallFlow(trigger)
	print("RIVER FLOW")
	local hero = trigger.activator
	local gameMaster = Events.GameMaster
	local gameMasterAbil = gameMaster:FindAbilityByName("npc_abilities")
	gameMasterAbil:ApplyDataDrivenModifier(gameMaster, hero, "modifier_waterfall_push", {})
end

function WaterfallFlowLeave(trigger)
	local hero = trigger.activator
	hero:RemoveModifierByName("modifier_waterfall_push")
end

function waterfall_flow_think(event)
	local target = event.target
	local newPos = GetGroundPosition(target:GetAbsOrigin()+Vector(-10, 0, -20), target)
	target:SetOrigin(newPos)

end

function flow_end(event)
	local target = event.target
	FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
end

function MountainTroggSpawn(trigger)
	Tanari:SpawnMountainTroggs()
end

function WindTempleKeyholderStart(trigger)
	if not Tanari.unibi.mountainSpecterDead then
		return false
	end
	local particlePosition = Vector(3561, 2176, 400)
	local pfx = ParticleManager:CreateParticle( "particles/customgames/capturepoints/cp_allied_wood.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
	ParticleManager:SetParticleControl( pfx, 10, particlePosition )
	ParticleManager:SetParticleControl( pfx, 0, particlePosition )
	ParticleManager:SetParticleControl( pfx, 1, particlePosition )
	ParticleManager:SetParticleControl( pfx, 2, particlePosition )
	ParticleManager:SetParticleControl( pfx, 3, particlePosition )
	EmitGlobalSound("Tanari.WindTempleKeyHolderStart")

	Dungeons.respawnPoint = Vector(2432, 2176)
	Tanari:CreateSideTempleDynamicBlockers()
	Timers:CreateTimer(2, function()
		Tanari:WindTempleKeyWalls(false)
	end)
	Timers:CreateTimer(6, function()
		local walls = Entities:FindAllByNameWithin("WindKeyHolderStatue", Vector(3908, 2175, 0), 900)
		Timers:CreateTimer(0.2, function()
			EmitSoundOnLocationWithCaster(walls[1]:GetAbsOrigin(), "Hero_Undying.Tombstone", Events.GameMaster)
		end)
		for j = 1, #walls, 1 do
			for i = 1, 60, 1 do
				Timers:CreateTimer(i*0.03, function()
					if i%2 == 0 then
						walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin()+Vector(7,15,0))
					else
						walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin()+Vector(-7,-15,0))
					end
					if j == 1 then
						ScreenShake(walls[1]:GetAbsOrigin(), 200, 0.1, 0.1, 9000, 0, true)
					end
					
				end)
			end
		end

		Timers:CreateTimer(2.0, function()
			local position = walls[1]:GetAbsOrigin()
			UTIL_Remove(walls[1])
			UTIL_Remove(walls[2])
			local boss = Tanari:SpawnWindTempleKeyHolder(position, Vector(-1,0))
			EmitGlobalSound("lone_druid_lone_druid_bearform_level_05")
			CustomAbilities:QuickAttachParticle("particles/radiant_fx/good_barracks_ranged002_destroy.vpcf", boss, 3)
			Events:AdjustBossPower(boss, 4, 4, false)
			local bossAbility = boss:FindAbilityByName("tanari_wind_temple_keyholder_ai")
			bossAbility.flowerTable = {}
			boss.bossStatus = true
			bossAbility:ApplyDataDrivenModifier(boss, boss, "modifier_wind_temple_key_unkillable", {})
			boss.regensRemaining = GameState:GetDifficultyFactor()
			StartSoundEvent("Tanari.KeyHolderBattle", boss)
		end)
	end)
end

function temple_key_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 0
	end
	if caster.falling then
		caster.fallVelocity = caster.fallVelocity - 1
	  	caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,caster.fallVelocity))
		if caster.fallVelocity <= 0 then
			caster.falling = false
			caster.dispersion = true
		end
	end
	local newFV = WallPhysics:rotateVector(caster:GetForwardVector(), math.pi/100)
	caster:SetForwardVector(newFV)
	caster.interval = caster.interval + 1
	if caster.leaving then
		caster.fallVelocity = caster.fallVelocity + 1
		caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,caster.fallVelocity))
		if caster.fallVelocity >= 45 then
			caster.leaving = false
			UTIL_Remove(caster)
		end
	end
end

function use_wind_temple_key(event)
	local caster = event.caster
	local ability = event.ability
	local casterOrigin = caster:GetAbsOrigin()

	if casterOrigin.x > 7300 and casterOrigin.y > 7791 and casterOrigin.x < 7716 and casterOrigin.y < 8151 then
		if not Tanari.WindTemple then
			UTIL_Remove(ability)
			local particlePosition = Vector(7490, 7973, 670)
			local pfx = ParticleManager:CreateParticle( "particles/customgames/capturepoints/cp_allied_wood.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
			ParticleManager:SetParticleControl( pfx, 10, particlePosition )
			ParticleManager:SetParticleControl( pfx, 0, particlePosition )
			ParticleManager:SetParticleControl( pfx, 1, particlePosition )
			ParticleManager:SetParticleControl( pfx, 2, particlePosition )
			ParticleManager:SetParticleControl( pfx, 3, particlePosition )
			EmitGlobalSound("Tanari.WindTempleKeyHolderStart")
			Tanari:InitializeWindTemple()
		else
			EmitSoundOnClient("General.Cancel", caster:GetPlayerOwner())
		end
	else
		EmitSoundOnClient("General.Cancel", caster:GetPlayerOwner())
	end

end

function use_water_temple_key(event)
	local caster = event.caster
	local ability = event.ability
	local casterOrigin = caster:GetAbsOrigin()

	if casterOrigin.x > -1300 and casterOrigin.y > 10800 and casterOrigin.x < -1150 and casterOrigin.y < 10980 then
		if not Tanari.WaterTemple then
			UTIL_Remove(ability)
			local particlePosition = Vector(-1221, 10893, 615)
			local pfx = ParticleManager:CreateParticle( "particles/customgames/capturepoints/cp_wind.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
			ParticleManager:SetParticleControl( pfx, 10, particlePosition )
			ParticleManager:SetParticleControl( pfx, 0, particlePosition )
			ParticleManager:SetParticleControl( pfx, 1, particlePosition )
			ParticleManager:SetParticleControl( pfx, 2, particlePosition )
			ParticleManager:SetParticleControl( pfx, 3, particlePosition )
			EmitGlobalSound("Tanari.WindTempleKeyHolderStart")
			Tanari:InitializeWaterTemple()
		else
			EmitSoundOnClient("General.Cancel", caster:GetPlayerOwner())
		end
	else
		EmitSoundOnClient("General.Cancel", caster:GetPlayerOwner())
	end

end

function use_fire_temple_key(event)
	local caster = event.caster
	local ability = event.ability
	local casterOrigin = caster:GetAbsOrigin()

	if WallPhysics:GetDistance(casterOrigin*Vector(1,1,0), Vector(-1376, -9483)) <= 200 then
		if not Tanari.FireTemple then
			UTIL_Remove(ability)
			local particlePosition = Vector(-1376, -9483, 400)
			local pfx = ParticleManager:CreateParticle( "particles/customgames/capturepoints/cp_fire_captured.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
			ParticleManager:SetParticleControl( pfx, 10, particlePosition )
			ParticleManager:SetParticleControl( pfx, 0, particlePosition )
			ParticleManager:SetParticleControl( pfx, 1, particlePosition )
			ParticleManager:SetParticleControl( pfx, 2, particlePosition )
			ParticleManager:SetParticleControl( pfx, 3, particlePosition )

			EmitGlobalSound("Tanari.WindTempleKeyHolderStart")
			Tanari:InitializeFireTemple()
		else
			EmitSoundOnClient("General.Cancel", caster:GetPlayerOwner())
		end
	else
		EmitSoundOnClient("General.Cancel", caster:GetPlayerOwner())
	end

end

function lake_cheep1(trigger)
	local hero = trigger.activator
	local yLoc = 3060
	local xLoc = hero:GetAbsOrigin().x
	for j = 1, GameState:GetDifficultyFactor(), 1 do
		Timers:CreateTimer((j-1)*1.5, function()
			for i = 0, 3, 1 do
				Timers:CreateTimer(i*0.2, function()
					Tanari:SpawnLakeCheep(Vector(xLoc, yLoc), Vector(0,1))
				end)
			end
		end)
	end
end

function lake_cheep2(trigger)
	local hero = trigger.activator
	local yLoc = 3060
	local xLoc = hero:GetAbsOrigin().x
	for j = 1, GameState:GetDifficultyFactor(), 1 do
		Timers:CreateTimer((j-1)*1.5, function()
			for i = 0, 3, 1 do
				Timers:CreateTimer(i*0.2, function()
					Tanari:SpawnLakeCheep(Vector(xLoc, yLoc), Vector(0,1))
				end)
			end
		end)
	end
end

function lake_cheep3(trigger)
	local hero = trigger.activator
	local yLoc = 3060
	local xLoc = hero:GetAbsOrigin().x
	for j = 1, GameState:GetDifficultyFactor(), 1 do
		Timers:CreateTimer((j-1)*1.5, function()
			for i = 0, 3, 1 do
				Timers:CreateTimer(i*0.2, function()
					Tanari:SpawnLakeCheep(Vector(xLoc, yLoc), Vector(0,1))
				end)
			end
		end)
	end
end

function ThicketAmbush(trigger)
	local activationPosition = trigger.activator:GetAbsOrigin()
	local ambushers = 6
	if GameState:GetDifficultyFactor() == 2 then
		ambushers = 8
	elseif GameState:GetDifficultyFactor() == 3 then
		ambushers = 10
	end
	for i = 1, ambushers, 1 do
		Timers:CreateTimer(i*0.24, function()
			local positionX = 6208
			local positionY = 2176+RandomInt(0, 600)
			local hunter = Tanari:SpawnPrimitiveAmbusher(Vector(positionX, positionY), Vector(-1, 0))
			hunter:MoveToPositionAggressive(activationPosition)
		end)
	end
	for j = 1, ambushers, 1 do
		Timers:CreateTimer(j*0.24, function()
			local positionX = 4756+RandomInt(0, 720)
			local positionY = 3231
			local hunter = Tanari:SpawnPrimitiveAmbusher(Vector(positionX, positionY), Vector(0, -1))
			hunter:MoveToPositionAggressive(activationPosition)
		end)
	end
end

function SpawnThicket()
	Tanari:SpawnThicket()
end

function SpawnCaveTechies()
	local techies = CreateUnitByName("gazbin_explosives_expert_friendly", Vector(-2514, 4510), false, nil, nil, DOTA_TEAM_GOODGUYS)
	techies.phase = 1
	techies.vectorMoveTable = {Vector(-2304, 2496), Vector(-1154, 2496), Vector(601, 3603), Vector(1720, 4136)}
	techies:FindAbilityByName("techies_friend_ai"):SetLevel(1)
	techies:SetForwardVector(Vector(0.2, -1))
end

function SpawnSideThicket()
	Tanari:SpawnSideThicket()
end

function SpawnCave()
	Tanari:InitializeCave()
end

function PortalBoulderspine(trigger)
	local hero = trigger.activator
	if Tanari.BoulderSpine.PrincessShattered and not hero:HasModifier("modifier_recently_teleported_portal") then
		local portToVector = Vector(3519, -4791)
		Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
		if not Tanari.HeroTrail2 then
			Tanari:SpawnHeroTrail2()
		end
	end
end

function PortalWaterfall(trigger)
	local hero = trigger.activator
	if not Tanari.BoulderSpine then
		Tanari.BoulderSpine = {}
	end
	if Tanari.BoulderSpine.PrincessShattered and not hero:HasModifier("modifier_recently_teleported_portal") then
		local portToVector = Vector(2595, 14912)
		Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
	end
end

function WaterTempleKeyInitiate()
	if not Tanari.BoulderSpine.PrincessShattered then
		return
	end
	Dungeons.respawnPoint = Vector(9408, -5760)
	Tanari:CreateWaterKeyWall()

	local particlePosition = Vector(9459, -4008, 620)
	local pfx = ParticleManager:CreateParticle( "particles/customgames/capturepoints/cp_wind.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
	ParticleManager:SetParticleControl( pfx, 10, particlePosition )
	ParticleManager:SetParticleControl( pfx, 0, particlePosition )
	ParticleManager:SetParticleControl( pfx, 1, particlePosition )
	ParticleManager:SetParticleControl( pfx, 2, particlePosition )
	ParticleManager:SetParticleControl( pfx, 3, particlePosition )
	EmitGlobalSound("Tanari.WindTempleKeyHolderStart")
	Timers:CreateTimer(3, function()
		EmitSoundOnLocationWithCaster(Vector(9408, -5760), "Tanari.WaterTemple.KeyBattleMusic", Events.GameMaster)
		if not Tanari.WaterTempleKeyAcquired then
			return 60
		end
	end)
	Timers:CreateTimer(7.5, function()
		for i = 1, 15, 1 do
			Timers:CreateTimer(1.5*i, function()
				local basePostion = Vector(8768, -5720)
				local randomX = RandomInt(0, 1300)
				local randomY = RandomInt(0, 1000)
				local spawnPosition = basePostion+Vector(randomX, randomY)
				local naga = false
				if i%5 == 0 then
					naga = Tanari:SpawnSlithereenRoyalGuard(spawnPosition, RandomVector(1), true)
				elseif i%2 == 0 then
					naga = Tanari:SpawnSlithereenGuard(spawnPosition, RandomVector(1), true)
				else
					naga = Tanari:SpawnSlithereenFeatherguard(spawnPosition, RandomVector(1), true)
				end
				naga:SetAbsOrigin(naga:GetAbsOrigin()-Vector(0,0,240))
				naga:AddAbility("water_key_engage_ability"):SetLevel(1)
				StartAnimation(naga, {duration=0.7, activity=ACT_DOTA_SPAWN, rate=1.0})
				local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
				
				gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, naga, "modifier_disable_player", {duration = 0.5})
				local particleName = "particles/units/heroes/hero_slark/slark_pounce_splash.vpcf"
			    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, naga)
			    for k = 0, 4, 1 do
			    	ParticleManager:SetParticleControl(pfx,k,naga:GetAbsOrigin()+Vector(0,0,240) )
				end
			    Timers:CreateTimer(1, function()
			    	ParticleManager:DestroyParticle(pfx, false)
			    end)
				for j = 1, 15, 1 do
					Timers:CreateTimer(j*0.03, function()
						naga:SetAbsOrigin(naga:GetAbsOrigin()+Vector(0,0,16))
					end)
				end
			end)
		end
	end)
end

function WaterTempleEntranceVision()
	AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-2048, 9408, 300), 1000, 30, false)
end

function SpawnOutsideWaterTemple()
	Tanari:SpawnOutsideWaterTemple()
end

function fountain_enter(trigger)
	local hero = trigger.activator
	Tanari.fountainAbility:ApplyDataDrivenModifier(Tanari.WitchDoctor, hero, "modifier_tanari_fountain", {duration = 30})
end

function use_spirit_stones(event)
	local hero = event.caster
	local item = event.ability
	local distance = WallPhysics:GetDistance(Vector(-4800, 2048, 128), hero:GetAbsOrigin())
	if Events.SpiritRealm then
		EmitSoundOnClient("General.Cancel", hero:GetPlayerOwner())
		return
	end
	if GameState:IsTanariJungle() then
		if distance < 1000 then

			UTIL_Remove(item)
			EmitGlobalSound("Tanari.EnterSpiritRealm")
			for i = 1, #MAIN_HERO_TABLE, 1 do
				Tanari.fountainAbility:ApplyDataDrivenModifier(Tanari.WitchDoctor, MAIN_HERO_TABLE[i], "modifier_tanari_entering_spirit_realm", {duration = 4})
			end
			Events.SpiritRealm = true
			CustomGameEventManager:Send_ServerToAllClients("enter_spirit_realm", {} )
			Timers:CreateTimer(3, function()
				EmitGlobalSound("Tanari.EnterSpiritRealm.Music")
				Tanari:CreateSpiritAmbience()
				CustomGameEventManager:Send_ServerToAllClients("update_spirit_zone_display", {tooltip='#tanari_spirit_realm'})
			end)
			if Tanari.WindTemple then
				if Tanari.WindTemple.BossBattleEnd then
					Tanari:SpawnWindSpirit(Vector(9727, 14272), Vector(-1,0))
				end
			end
			if Tanari.WaterTemple then
				if Tanari.WaterTemple.BossBattleEnd then
					Tanari:SpawnWaterSpirit(Vector(-9901, 16128), Vector(0,-1))
				end
			end
			if Tanari.FireTemple then
				if Tanari.FireTemple.KolthunBattleEnd then
					Tanari:SpawnFireSpirit(Vector(9664, -15104), Vector(-1,0))
				end
			end

		else
			Notifications:Top(hero:GetPlayerOwnerID(), {text="Must use in Tanari Encampment", duration=3, style={color="red"}, continue=true})
			EmitSoundOnClient("General.Cancel", hero:GetPlayerOwner())
		end
	end
end

function entering_spirit_realm_think(event)
	local target = event.target
	CustomAbilities:QuickAttachParticle("particles/econ/items/meepo/meepo_colossal_crystal_chorus/meepo_divining_rod_poof_start.vpcf", target, 3)
end

function ZoneEnterEncampment(trigger)
	
end

function town_portal_channel_end(event)
	-- local caster = event.caster
	-- caster:RemoveAbility("rpc_hero_town_portal")
end

function town_portal_succeed(event)
	local caster = event.caster
	local ability = event.ability
	
	for i = 1, 40, 1 do
		Timers:CreateTimer(i*0.03, function()
			caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,20)*math.sin(math.pi*i/40))
		end)
	end
	EmitSoundOn("Tanari.TeleportHeaven", caster)
	
	Timers:CreateTimer(0.1, function()
		StartAnimation(caster, {duration=1.1, activity=ACT_DOTA_ATTACK, rate=1.0, translate="loadout"})
	end)
	Timers:CreateTimer(1.1, function()
			local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_chen/chen_teleport_flash.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
			ParticleManager:SetParticleControl( pfx, 0, caster:GetAbsOrigin() )
			ParticleManager:SetParticleControl( pfx, 1, caster:GetAbsOrigin() )
			Timers:CreateTimer(2.5, function() 
			  ParticleManager:DestroyParticle( pfx, false )
			end) 
		caster:AddNoDraw()
		EmitSoundOn("Tanari.TeleportFlashOut", caster)
	end)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_town_portal_teleporting", {duration = 2.6})
	Timers:CreateTimer(2.3, function()
		EmitSoundOnLocationWithCaster(Events.TownPosition, "Tanari.TeleportFinalLand", caster)
	end)
	Timers:CreateTimer(2.6, function()
		EmitSoundOn("Tanari.TeleportExit", caster)
	end)
	Timers:CreateTimer(2.9, function()
		caster:Stop()
		EmitSoundOn("Tanari.TeleportBasic", caster)
		StartAnimation(caster, {duration=3, activity=ACT_DOTA_SPAWN, rate=1.0})
		caster:RemoveNoDraw()
		FindClearSpaceForUnit(caster, Events.TownPosition, false)
		caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,600))

			local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_chen/chen_teleport_flash.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
			ParticleManager:SetParticleControl( pfx, 0, caster:GetAbsOrigin() )
			ParticleManager:SetParticleControl( pfx, 1, caster:GetAbsOrigin() )
			Timers:CreateTimer(2.5, function() 
			  ParticleManager:DestroyParticle( pfx, false )
			end) 
			Timers:CreateTimer(0.8, function()
				local teleportEndParticle = "particles/econ/events/nexon_hero_compendium_2014/teleport_end_ground_flash_nexon_hero_cp_2014.vpcf"
				local pfx = ParticleManager:CreateParticle( "particles/econ/events/nexon_hero_compendium_2014/teleport_end_ground_flash_nexon_hero_cp_2014.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
				ParticleManager:SetParticleControl( pfx, 0, caster:GetAbsOrigin()+Vector(0,0,-50) )
				ParticleManager:SetParticleControl( pfx, 1, caster:GetAbsOrigin()+Vector(0,0,-50) )
				Timers:CreateTimer(2.5, function() 
				  ParticleManager:DestroyParticle( pfx, false )
				end) 
			end)
		for i = 1, 30, 1 do
			Timers:CreateTimer(i*0.03, function()
				caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,-30)*math.sin(math.pi*i/30))
			end)
		end

		Timers:CreateTimer(0.8, function()

			CustomAbilities:QuickAttachParticle("particles/econ/items/meepo/meepo_colossal_crystal_chorus/meepo_divining_rod_poof_end.vpcf", caster, 3)
			ScreenShake(caster:GetAbsOrigin(), 280, 1, 1, 9000, 0, true)
		end)
		Events:LockCamera(caster)
	end)
	caster:RemoveAbility("rpc_hero_town_portal")
end

function teleport_start(event)
	local caster = event.caster
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_chen/chen_teleport_flash_sparks.vpcf", caster, 3)
	StartSoundEvent("Tanari.TeleportChannel", caster)
	event.ability:SetActivated(false)
end

function town_portal_take_damage(event)
	local unit = event.unit
	if event.damage > 10 then
		unit:Stop()
	end
end

function teleport_cancel(event)
	local caster = event.caster
	StopSoundEvent("Tanari.TeleportChannel", caster)
	event.ability:SetActivated(false)
	caster:RemoveAbility("rpc_hero_town_portal")
end

function WindTempleStuckZone(trigger)
	local hero = trigger.activator
	FindClearSpaceForUnit(hero, Vector(4096, 15680), false)
end

function UrsaSpawn(trigger)
	Tanari:SpawnThicketUrsa(Vector(3392, 3072), Vector(0,1))
	Tanari:SpawnThicketUrsa(Vector(3584, 3264), Vector(-1,0.2))
	Tanari:SpawnThicketUrsa(Vector(3264, 3328), Vector(1,-0.2))
end

function respawn_flag_start(event)
	local caster = event.caster
	CustomAbilities:QuickAttachParticle("particles/roshpit/solunia/eclipse_sparks.vpcf", caster, 3)
	StartSoundEvent("RPCItem.RespawnFlagLP", caster)
	event.ability:SetActivated(false)
end

function respawn_flag_cancel(event)
	local caster = event.caster
	StopSoundEvent("RPCItem.RespawnFlagLP", caster)
	event.ability:SetActivated(false)
	caster:RemoveAbility("rpc_respawn_flag")
end

function respawn_flag_succeed(event)
	local caster = event.caster
	local ability = event.ability
	print(ability.color)
	CustomAbilities:QuickAttachParticle("particles/roshpit/solunia/eclipse_sparks.vpcf", caster, 3)
	EmitSoundOn("RPCItem.RespawnFlagCast", caster)
	caster:RemoveAbility("rpc_respawn_flag")
	-- StopSoundEvent("RPCItem.RespawnFlagLP", caster)
	Timers:CreateTimer(0.05, function()
		StartAnimation(caster, {duration=1, activity=ACT_DOTA_ATTACK, rate=1})
	end)
	if caster.respawnFlag then
		UTIL_Remove(caster.respawnFlag)
	end
	local flag = CreateUnitByName("npc_dummy_unit", caster:GetAbsOrigin(), false, nil, nil, caster:GetTeamNumber())
	flag:SetOriginalModel("models/props_teams/banner_radiant.vmdl")
	flag:SetModel("models/props_teams/banner_radiant.vmdl")
	flag:SetForwardVector(Vector(0,-1))
	flag:SetModelScale(0.9)
	if caster:GetPlayerOwnerID() == 0 then
		flag:SetRenderColor(130, 130, 255)
	elseif caster:GetPlayerOwnerID() == 1 then
		flag:SetRenderColor(130, 255, 255)
	elseif caster:GetPlayerOwnerID() == 2 then
		flag:SetRenderColor(255, 130, 255)
	elseif caster:GetPlayerOwnerID() == 3 then
		flag:SetRenderColor(255, 255, 130)
	end
	flag:FindAbilityByName("dummy_unit"):SetLevel(1)
	caster.respawnFlag = flag
	CustomAbilities:QuickAttachParticle("particles/econ/items/meepo/meepo_colossal_crystal_chorus/meepo_divining_rod_poof_end.vpcf", flag, 3)
	CustomAbilities:QuickAttachParticle("particles/econ/items/monkey_king/arcana/water/mk_spring_arcana_water_channel_powertrails.vpcf", flag, 4)
end