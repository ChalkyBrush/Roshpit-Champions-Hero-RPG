function WindCircle1(trigger)
	local hero = trigger.activator
	if not hero:HasModifier("modifier_wind_temple_flailing") then
		WallPhysics:Jump(hero, Vector(0,1), 20, 30, 32, 0.8)
		add_flail_effect(hero)
	end
end

function WindCircle2(trigger)
	local hero = trigger.activator
	if not hero:HasModifier("modifier_wind_temple_flailing") then
		WallPhysics:Jump(hero, Vector(0,-1), 20, 30, 32, 0.8)
		add_flail_effect(hero)
	end
end

function WindCircle3(trigger)
	local hero = trigger.activator
	if not hero:HasModifier("modifier_wind_temple_flailing") then
		local fv = ((Vector(9344, 7360) - Vector(8932, 8948))*Vector(1,1,0)):Normalized()
		WallPhysics:Jump(hero, fv, 20, 37, 36, 0.8)
		add_flail_effect(hero)
	end	
end

function WindCircle4(trigger)
	local hero = trigger.activator
	if not hero:HasModifier("modifier_wind_temple_flailing") then
		local fv = Vector(-1,0.2)
		WallPhysics:Jump(hero, fv, 26, 24, 31, 0.8)
		add_flail_effect(hero)
	end
end

function WindCircle5(trigger)
	local hero = trigger.activator
	if not hero:HasModifier("modifier_wind_temple_flailing") then
		local fv = ((Vector(9408, 11136) - Vector(8311, 10771))*Vector(1,1,0)):Normalized()
		WallPhysics:Jump(hero, fv, 20, 29, 34, 0.8)
		add_flail_effect(hero)
	end
end

function WindCircle6(trigger)
	local hero = trigger.activator
	if not hero:HasModifier("modifier_wind_temple_flailing") then
		local fv = ((Vector(8008, 10616) - Vector(8977, 11109))*Vector(1,1,0)):Normalized()
		WallPhysics:Jump(hero, fv, 20, 29, 34, 0.8)
		add_flail_effect(hero)
	end
end

function WindCircle7(trigger)
	local hero = trigger.activator
	if not hero:HasModifier("modifier_wind_temple_flailing") then
		local fv = ((Vector(9700, 9669) - Vector(9315, 10714))*Vector(1,1,0)):Normalized()
		WallPhysics:Jump(hero, fv, 20, 29, 34, 0.8)
		add_flail_effect(hero)
	end
end

function WindCircle8(trigger)
	local hero = trigger.activator
	if not hero:HasModifier("modifier_wind_temple_flailing") then
		local fv = ((Vector(9344, 11136) - Vector(9714, 10045))*Vector(1,1,0)):Normalized()
		WallPhysics:Jump(hero, fv, 20, 29, 34, 0.8)
		add_flail_effect(hero)
	end
end

function WindCircle9(trigger)
	local hero = trigger.activator
	if not hero:HasModifier("modifier_wind_temple_flailing") then
		local fv = ((Vector(7705, 12155) - Vector(9195, 11477))*Vector(1,1,0)):Normalized()
		WallPhysics:Jump(hero, fv, 20, 34, 38, 0.8)
		add_flail_effect(hero)
	end
end

function WindCircle10(trigger)
	local hero = trigger.activator
	if not hero:HasModifier("modifier_wind_temple_flailing") then
		local fv = ((Vector(9408, 11136) - Vector(8161, 12045))*Vector(1,1,0)):Normalized()
		WallPhysics:Jump(hero, fv, 20, 34, 38, 0.8)
		add_flail_effect(hero)
	end
end

function WindCircle11(trigger)
	local hero = trigger.activator
	if Tanari.WindTemple.windDrakeSlain then
		if not hero:HasModifier("modifier_wind_temple_flailing") then
			local fv = ((Vector(6488, 10164) - Vector(9439, 9728))*Vector(1,1,0)):Normalized()
			WallPhysics:Jump(hero, fv, 27, 42, 65, 0.8)
			add_flail_effect(hero)
		end
	end
end

function WindCircle12(trigger)
	local hero = trigger.activator
	if Tanari.WindTemple.staffSequenceComplete then
		if not hero:HasModifier("modifier_wind_temple_flailing") then
			local fv = ((Vector(7881, 9088) - Vector(7896, 15816))*Vector(1,1,0)):Normalized()
			WallPhysics:Jump(hero, fv, 51, 42, 90, 0.8)
			add_flail_effect(hero)
		end
	end
end

function WindCircle13(trigger)
	local hero = trigger.activator
	if Tanari.WindTemple.masterOfStormsClear then
		if not hero:HasModifier("modifier_wind_temple_flailing") then
			local fv = ((Vector(7744, 14272) - Vector(4655, 15968))*Vector(1,1,0)):Normalized()
			WallPhysics:Jump(hero, fv, 38, 30, 38, 0.8)
			add_flail_effect(hero)
		end
	end
end

function WindCircle14(trigger)
	local hero = trigger.activator
	if Tanari.WindTemple.masterOfStormsClear then
		if not hero:HasModifier("modifier_wind_temple_flailing") then
			local fv = ((Vector(9536, 13440) - Vector(9218, 14123))*Vector(1,1,0)):Normalized()
			WallPhysics:Jump(hero, fv, 20, 30, 37, 0.8)
			add_flail_effect(hero)
		end
	end
end

function WindCircle15(trigger)
	local hero = trigger.activator
	if Tanari.WindTemple.BossBattleBegun then
		if not hero:HasModifier("modifier_wind_temple_flailing") then
			local fv = ((Vector(7936, 12224) - Vector(9087, 12931))*Vector(1,1,0)):Normalized()
			WallPhysics:Jump(hero, fv, 28, 26, 34, 0.8)
			add_flail_effect(hero)
		end
	end
end

function WindCircle16(trigger)
	local hero = trigger.activator
	if Tanari.WindTemple.BossBattleBegun then
		if not hero:HasModifier("modifier_wind_temple_flailing") then
			local fv = ((Vector(9344, 11136) - Vector(9449, 12686))*Vector(1,1,0)):Normalized()
			WallPhysics:Jump(hero, fv, 28, 26, 24, 0.8)
			add_flail_effect(hero)
		end
	end
end

function WindCircle17(trigger)
	local hero = trigger.activator
	if not hero:HasModifier("modifier_wind_temple_flailing") then
		local fv = ((Vector(13864, 15643) - Vector(12556, 15718))*Vector(1,1,0)):Normalized()
		WallPhysics:Jump(hero, fv, 28, 23, 32, 0.8)
		add_flail_effect(hero)
	end
end

function WindCircle18(trigger)
	local hero = trigger.activator
	if not hero:HasModifier("modifier_wind_temple_flailing") then
		local fv = Vector(-1,0)
		WallPhysics:Jump(hero, fv, 28, 23, 32, 0.8)
		add_flail_effect(hero)
	end
end


function add_flail_effect(hero)
	hero.jumpEnd = "stop_flail"
	local gameMaster = Events.GameMaster
	local gameMasterAbil = gameMaster:FindAbilityByName("npc_abilities")
	local jumpingModifier = "modifier_wind_temple_flailing"
	EmitSoundOn("Tanari.WindTemple.Burst", hero)
	gameMasterAbil:ApplyDataDrivenModifier(gameMaster, hero, jumpingModifier, {duration = 5})
	hero:Stop()
end

function WindTempleSpawn1()
	local centerPoint = Vector(8038, 10624)
	local radius = 490
	for i = -8, 8, 1 do
		Timers:CreateTimer(0.3*(i+8), function()
			local displacement = WallPhysics:rotateVector(Vector(1,0), math.pi/8*i)
			Tanari:SpawnWindGuardian(centerPoint+displacement*radius, displacement*-1)
		end)
	end
end

function WindTempleSpawn2()
	local centerPoint = Vector(9408, 11072)
	local radius = 615
	for i = -5, 5, 1 do
		Timers:CreateTimer(0.5*(i+5), function()
			local displacement = WallPhysics:rotateVector(Vector(1,0), math.pi/5*i)
			Tanari:SpawnWindGuardian(centerPoint+displacement*radius, displacement*-1)
		end)
	end
end

function wind_guardian_pathing_think(event)
	local caster = event.caster
	local target_teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY
	local target_types = DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC
	local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
	local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 95, target_teams, target_types, target_flags, FIND_ANY_ORDER, false)
	EmitSoundOn("Tanari.WindTemple.WingFlap", caster)
	if #allies > 1 then	
		caster:MoveToPosition(caster:GetAbsOrigin()+RandomVector(150))
	end
end

function WindTemplePit(trigger)
	local hero = trigger.activator
	local gameMaster = Events.GameMaster
	local gameMasterAbil = gameMaster:FindAbilityByName("npc_abilities")
	local jumpingModifier = "modifier_wind_temple_falling"
	gameMasterAbil:ApplyDataDrivenModifier(gameMaster, hero, jumpingModifier, {duration = 5})
	for i = 1, 50, 1 do
		Timers:CreateTiemr(0.03*i, function()
			hero:SetAbsOrigin(hero:GetAbsOrigin()-Vector(0,0,i))
		end)
	end
	Timers:CreateTimer(1.55, function()
		hero:SetAbsOrigin(Vector(7490, 7972))
		ApplyDamage({ victim = hero, attacker = gameMaster, damage = hero:GetMaxHealth()*0.3, damage_type = DAMAGE_TYPE_PURE})
		Events:LockCamera(hero)
	end)
end

function wind_mage_think(event)
	local caster = event.caster
	local ability = event.ability
	local windHaste = caster:FindAbilityByName("wind_temple_wind_haste")
	if windHaste:IsFullyCastable() and caster.aggro then
		local target_teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY
		local target_types = DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC
		local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
		local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 700, target_teams, target_types, target_flags, FIND_ANY_ORDER, false)
		if #allies > 0 then
			local newOrder = {
		 		UnitIndex = caster:entindex(), 
		 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		 		TargetIndex = allies[1]:entindex(),
		 		AbilityIndex = windHaste:entindex(),
		 	}
			ExecuteOrderFromTable(newOrder)						
		end
	end
	if caster.aggro then
		-- local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 240, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
		-- if #enemies > 0 then
		-- 	local casterForward = caster:GetForwardVector()
		-- 	EmitSoundOn("Tanari.KeyHolder.WindBreath", caster)
		-- 	for i = -2, 2, 1 do
		-- 		local fv = WallPhysics:rotateVector(casterForward, math.pi/3*i)
		-- 		local spellOrigin = caster:GetAbsOrigin()+Vector(0,0,160)+fv*50
		-- 		local forward = caster:GetForwardVector()	
		-- 		local info = 
		-- 		{
		-- 			Ability = ability,
		-- 	        	EffectName = "particles/items/cannon/breath_of_wind.vpcf",
		-- 	        	vSpawnOrigin = spellOrigin,
		-- 	        	fDistance = 200,
		-- 	        	fStartRadius = 80,
		-- 	        	fEndRadius = 150,
		-- 	        	Source = caster,
		-- 	        	StartPosition = "attach_hitloc",
		-- 	        	bHasFrontalCone = true,
		-- 	        	bReplaceExisting = false,
		-- 	        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		-- 	        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		-- 	        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		-- 	        	fExpireTime = GameRules:GetGameTime() + 7.0,
		-- 			bDeleteOnHit = false,
		-- 			vVelocity = fv * 420,
		-- 			bProvidesVision = false,
		-- 		}
		-- 		projectile = ProjectileManager:CreateLinearProjectile(info)	
		-- 	end
		-- end
	end
end

function wind_drake_die(event)

	local caster = event.caster
	if not caster:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		return false
	end
	Tanari.WindTemple.windDrakeSlain = true
	particleName = "particles/econ/items/windrunner/windrunner_cape_sparrowhawk/windrunner_windrun_sparrowhawk.vpcf"
	local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, Events.GameMaster )
	ParticleManager:SetParticleControl( particle1, 0, Vector(9439, 9728, 640) )	
	Tanari:SpawnWindTemplePart2()
	for i = 1, 40, 1 do
		Timers:CreateTimer(i*0.03, function()
			caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,4))
		end)
	end
end

function TanariSpiderSpawn()
	for i = 1, 8, 1 do
		Timers:CreateTimer(i*0.5, function()
			local spider1 = Tanari:SpawnEmeraldSpider(Vector(5632, 13184), Vector(0,-1))
			local spider2 = Tanari:SpawnWindTempleSpider(Vector(5632, 13184), Vector(0,-1))
			Timers:CreateTimer(0.05, function()
				spider1:MoveToPositionAggressive(Vector(6528, 11008))
				spider2:MoveToPositionAggressive(Vector(6528, 11008))
			end)
		end)
	end
end

function wind_gardiner_think(event)
	local caster = event.caster
	if caster.aggro then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 480, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
		if #enemies > 0 then
			local sumVector = Vector(0,0)
			for i = 1, #enemies, 1 do
				sumVector = sumVector + enemies[i]:GetAbsOrigin()
			end
			local avgVector = sumVector/#enemies
			local runDirection = ((caster:GetAbsOrigin() - avgVector)*Vector(1,1,0)):Normalized()
			caster:MoveToPosition(caster:GetAbsOrigin()+runDirection*300)
		end
	end
end

function wind_temple_staff_think(event)
	local caster = event.caster
	-- local fv = caster:GetForwardVector()
	-- local newForward = WallPhysics:rotateVector(fv, math.pi/380)
	-- caster:SetForwardVector(newForward)
end

function wind_temple_staff_take_damage(event)
	local caster = event.caster
	local attacker = event.attacker
	if not attacker:IsHero() or attacker:GetUnitName() == "tanari_thicket_bat" then
		return
	end
	if caster:HasModifier("modifier_wind_temple_staff_red") then
		Tanari:StaffChangeColor(caster, "green")
	elseif caster:HasModifier("modifier_wind_temple_staff_green") then
		Tanari:StaffChangeColor(caster, "blue")
	elseif caster:HasModifier("modifier_wind_temple_staff_blue") then
		Tanari:StaffChangeColor(caster, "red")
	end
	EmitSoundOn("Tanari.WindTemple.StaffChange", caster)
	link_wind_temple_staffs()
end

function link_wind_temple_staffs()
	print(Tanari.WindTemple.staff1)
	print(Tanari.WindTemple.staff1.color)
	if Tanari.WindTemple.staff1.pfx then
		ParticleManager:DestroyParticle(Tanari.WindTemple.staff1.pfx, false)
		Tanari.WindTemple.staff1.pfx = false
	end
	if Tanari.WindTemple.staff2.pfx then
		ParticleManager:DestroyParticle(Tanari.WindTemple.staff2.pfx, false)
		Tanari.WindTemple.staff2.pfx = false
	end
	if Tanari.WindTemple.staff3.pfx then
		ParticleManager:DestroyParticle(Tanari.WindTemple.staff3.pfx, false)
		Tanari.WindTemple.staff3.pfx = false
	end
	if Tanari.WindTemple.staff1.color == Tanari.WindTemple.staff2.color then
		attachParticle(Tanari.WindTemple.staff1.color, Tanari.WindTemple.staff1, Tanari.WindTemple.staff2)
	end
	if Tanari.WindTemple.staff1.color == Tanari.WindTemple.staff3.color then
		attachParticle(Tanari.WindTemple.staff1.color, Tanari.WindTemple.staff3, Tanari.WindTemple.staff1)
	end
	if Tanari.WindTemple.staff2.color == Tanari.WindTemple.staff3.color then
		attachParticle(Tanari.WindTemple.staff2.color, Tanari.WindTemple.staff2, Tanari.WindTemple.staff3)
	end
	Tanari:CheckStaffCondition()

end

function attachParticle(color, staff1, staff2)
	local blueParticle = "particles/units/heroes/hero_wisp/wisp_tether.vpcf"
	local redParticle = "particles/units/heroes/hero_wisp/epoch_rune_b_a.vpcf"
	local greenParticle = "particles/units/heroes/hero_wisp/tether_green.vpcf"
	local particleName = ""
	if color == "red" then
		particleName = redParticle
	elseif color == "green" then
		particleName = greenParticle
	elseif color == "blue" then
		particleName = blueParticle
	end
	print(particleName)
	local eonPfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, staff1 )
	ParticleManager:SetParticleControl(eonPfx, 0, staff1:GetAbsOrigin()+Vector(0,0,300))
	ParticleManager:SetParticleControl(eonPfx, 1, staff2:GetAbsOrigin()+Vector(0,0,300))
	-- ParticleManager:SetParticleControlEnt(eonPfx, 0, staff1, PATTACH_WORLDORIGIN, "start_at_customorigin", staff1:GetAbsOrigin()+Vector(0,0,500), true)
	-- ParticleManager:SetParticleControlEnt(eonPfx, 1, staff2, PATTACH_WORLDORIGIN, "start_at_customorigin", staff2:GetAbsOrigin()+Vector(0,0,500), true)
	staff1.pfx = eonPfx
end

function zeus_descendant_think(event)
	local caster = event.caster
	if caster.aggro then
		local ability = caster:FindAbilityByName("zuus_descendant_bolt")
		CustomAbilities:TargetedAbilityAI(caster, 1000, true, ability)
	end

end

function staff_guardian_die(event)
	local caster = event.caster
	if not caster:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		return false
	end
	local ability = Tanari.WindTemple.staff1:FindAbilityByName("wind_temple_staff_dummy")
	local redPosition = Vector(7694, 12544, 448)
	local bluePosition = Vector(7567, 12361, 448)
	local greenPosition = Vector(7829, 12361, 448)
	local spawnPosition = redPosition
	if caster.color == "blue" then
		spawnPosition = bluePosition
		Tanari.WindTemple.blueStaffBossDead = true
		Tanari.WindTemple.staffGuardianBlue = false
	elseif caster.color == "green" then
		spawnPosition = greenPosition
		Tanari.WindTemple.greenStaffBossDead = true
		Tanari.WindTemple.staffGuardianGreen = false
	else
		Tanari.WindTemple.redStaffBossDead = true
		Tanari.WindTemple.staffGuardianRed = false
	end
	local color = caster.color
	local visionTracer = CreateUnitByName("npc_flying_dummy_vision", spawnPosition, true, nil, nil, DOTA_TEAM_GOODGUYS)
	-- visionTracer:AddAbility("dummy_unit"):SetLevel(1)
	-- visionTracer:AddNewModifier( visionTracer, nil, 'modifier_movespeed_cap', nil )
	visionTracer:AddAbility("dummy_unit_vulnerable_cant_be_attacked"):SetLevel(1)
	visionTracer:SetModel("models/props_gameplay/rune_doubledamage01.vmdl")
	visionTracer:SetModelScale(0.05)
	visionTracer:SetAbsOrigin(visionTracer:GetAbsOrigin()-Vector(0,0,420))
	for i = 1, 60, 1 do
		Timers:CreateTimer(0.03*i, function()
			visionTracer:SetAbsOrigin(visionTracer:GetAbsOrigin()+Vector(0,0,7))
		end)
	end
	local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
	ability:ApplyDataDrivenModifier(Tanari.WindTemple.staff1, visionTracer, "modifier_wind_temple_staff_"..color, {})

	local allies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1260, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
	
	Timers:CreateTimer(0.6, function()
		Dungeons:LockCameraToUnitForPlayers(visionTracer, 3.2, allies)
		-- for i = 1, #MAIN_HERO_TABLE, 1 do
		-- 	local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
		-- 	if playerID then
		-- 		gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, MAIN_HERO_TABLE[i], "modifier_disable_player", {duration = 3.1})
		-- 		MAIN_HERO_TABLE[i]:Stop()
		-- 		PlayerResource:SetCameraTarget(playerID, visionTracer)
		-- 	end
		-- end
		EmitSoundOn("Hero_Chen.HandOfGodHealCreep", visionTracer)
		EmitSoundOn("Hero_Chen.HandOfGodHealCreep", visionTracer)
	end)
	Timers:CreateTimer(3.2, function()
		if Tanari.WindTemple.blueStaffBossDead and Tanari.WindTemple.redStaffBossDead and Tanari.WindTemple.greenStaffBossDead then 
			EmitSoundOn("Items.BlueDragonGreaves", visionTracer)
			Tanari.WindTemple.staffSequenceComplete = true
			-- particleName = "particles/econ/items/windrunner/windrunner_cape_sparrowhawk/windrunner_windrun_sparrowhawk.vpcf"
			-- local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, Tanari.WindTemple.staff1 )
			-- ParticleManager:SetParticleControl( particle1, 0, Vector(7680, 12453, 580) )	
			particleName = "particles/econ/events/ti6/wind_temple_light_beam.vpcf"
			local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, Tanari.WindTemple.staff1 )
			ParticleManager:SetParticleControl( particle1, 0, Vector(7692, 12450, 516) )	

			local visionTracer2 = CreateUnitByName("npc_flying_dummy_vision", Vector(4160, 15871, 744), false, nil, nil, DOTA_TEAM_GOODGUYS)
			visionTracer2:SetAbsOrigin(visionTracer2:GetAbsOrigin()+Vector(0,0,310))
			-- visionTracer:AddAbility("dummy_unit"):SetLevel(1)
			-- visionTracer:AddNewModifier( visionTracer, nil, 'modifier_movespeed_cap', nil )
			visionTracer2:AddAbility("dummy_unit_vulnerable_cant_be_attacked"):SetLevel(1)
			visionTracer2:SetModel("models/props_gameplay/rune_doubledamage01.vmdl")
			ability:ApplyDataDrivenModifier(Tanari.WindTemple.staff1, visionTracer2, "modifier_wind_temple_staff_green", {})
			visionTracer2:SetModelScale(0.05)

			local particlePosition = Vector(7712, 12419, 756)
			local pfx = ParticleManager:CreateParticle( "particles/customgames/capturepoints/cp_allied_wood.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
			ParticleManager:SetParticleControl( pfx, 0, particlePosition )
			ParticleManager:SetParticleControl( pfx, 1, particlePosition )
			ParticleManager:SetParticleControl( pfx, 2, particlePosition )
			ParticleManager:SetParticleControl( pfx, 3, particlePosition )
	  		EmitGlobalSound("ui.set_applied")
	  		EmitGlobalSound("ui.set_applied")

			local particleName = "particles/econ/items/windrunner/windrunner_cape_sparrowhawk/windrunner_windrun_sparrowhawk.vpcf"
			local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, Events.GameMaster )
			ParticleManager:SetParticleControl( particle2, 0, Vector(7896, 15816, 790) )	
			Timers:CreateTimer(3.2, function()
				EmitGlobalSound("Tanari.HarpMystery")
			end)
			Timers:CreateTimer(6.5, function()
				Dungeons:UnlockCamerasAndReturnToHeroForUnits(allies)
			end)
		else
			Dungeons:UnlockCamerasAndReturnToHeroForUnits(allies)
		end
	end)
	Timers:CreateTimer(2, function()
		Tanari:StaffCheckBossBuffs(Tanari.WindTemple.staff1)
		Tanari:StaffCheckBossBuffs(Tanari.WindTemple.staff2)
		Tanari:StaffCheckBossBuffs(Tanari.WindTemple.staff3)
	end)
end

function WindTempleLightBeam(trigger)
	if Tanari.WindTemple.staffSequenceComplete then
		local hero = trigger.activator
		Events:LockCameraWithDuration(hero, 4.2)
		hero:SetAbsOrigin(hero:GetAbsOrigin()+Vector(0,0,200))
		local gameMaster = Events.GameMaster
		local gameMasterAbil = gameMaster:FindAbilityByName("npc_abilities")
		local jumpingModifier = "modifier_wind_temple_light_beam_effect"
		gameMasterAbil:ApplyDataDrivenModifier(gameMaster, hero, jumpingModifier, {duration = 3.6})
		local startPoint = hero:GetAbsOrigin()
		local endPoint = Vector(4160, 15872, 1000)
		local movementVector = (endPoint - startPoint):Normalized()
		local distanceToTravel = WallPhysics:GetDistance(startPoint, endPoint)
		local distancePerTick = distanceToTravel/120
		for i = 1, 120, 1 do
			Timers:CreateTimer(i*0.03, function()
				local pullFactor = distancePerTick*(math.sin(math.pi/60) +1)
				hero:SetAbsOrigin(hero:GetAbsOrigin()+movementVector*pullFactor)
			end)
		end
		Timers:CreateTimer(3.6, function()
			WallPhysics:Jump(hero, Vector(1,0), 0, 10, 10, 0.8)
		end)
	end
end

function MasterOfStormsSpawn(trigger)
	Tanari:SpawnMasterOfStorms()
end

function master_of_storms_think(event)
	local caster = event.caster
	local radius = 580
	local castPoint = caster.centerPoint+RandomVector(RandomInt(1, radius))
	local ability = caster:FindAbilityByName("master_of_storms_flare")
	if ability:IsFullyCastable() then
			local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = ability:entindex(),
					Position = castPoint
			 	}
			 
			ExecuteOrderFromTable(newOrder)
	end
end

function master_of_storms_die(event)
	Tanari.WindTemple.masterOfStormsClear = true
	particleName = "particles/econ/items/windrunner/windrunner_cape_sparrowhawk/windrunner_windrun_sparrowhawk.vpcf"
	local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, Tanari.WindTemple.staff1 )
	ParticleManager:SetParticleControl( particle1, 0, Vector(4655, 15968, 950) ) 	
	local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, Tanari.WindTemple.staff1 )
	ParticleManager:SetParticleControl( particle2, 0, Vector(9218, 14123, 520) ) 	
	Tanari:BeginBattleTacticsRoom()
	Tanari:SpawnWindBossStaff()
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_master_of_storms_dead", {})

end

function master_of_storms_death_thinking(event)
	local caster = event.caster
	if IsValidEntity(caster) then
		if caster:GetAbsOrigin().z > GetGroundHeight(caster:GetAbsOrigin(), caster) then
			caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,5))
		end
	end
end

function WindTempleChest(event)
	local chest = Tanari.WindTemple.TempleChest1
	EmitSoundOn("ui.treasure_unlock.wav", chest)
	EmitSoundOn("ui.treasure_unlock.wav", chest)
	EmitSoundOn("ui.treasure_unlock.wav", chest)
	StartAnimation(chest, {duration=7, activity=ACT_DOTA_DIE, rate=0.28})
	Dungeons.lootLaunch = chest:GetAbsOrigin()+Vector(0, 300)
	Timers:CreateTimer(2.0, function()
		for i = 0, RandomInt(5, 6+GameState:GetPlayerPremiumStatusCount()), 1 do
			EmitSoundOn("General.FemaleLevelUp", chest)
			RPCItems:RollItemtype(300, chest:GetAbsOrigin(), 1, 0)
		end
		local particleName = "particles/econ/items/sven/sven_warcry_ti5/sven_spell_warcry_ti_5.vpcf"
      	local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, chest )
      	local origin = chest:GetAbsOrigin()
      	ParticleManager:SetParticleControl( particle1, 0, origin )
      	ParticleManager:SetParticleControl( particle1, 1, origin )
      	ParticleManager:SetParticleControl( particle1, 2, origin )
      	ParticleManager:SetParticleControl( particle1, 3, origin )
	end)
	Timers:CreateTimer(6.5, function()
		Dungeons.lootLaunch = false
		UTIL_Remove(chest)
	end)
end

function cast_revitalizing_winds(event)
	local caster = event.caster
	local ability = event.ability
	local newTable = {}
	local newParallelTable = {}
	local allyTable = Tanari.WindTemple.finalEncounter 
	local parallelTable = Tanari.WindTemple.parallelTable
	for i = 1, #allyTable, 1 do 
		if i == ability.allyIndex then
			local unitName = parallelTable[i]
			local unit = false
			if unitName == "wind_temple_descendant_of_zeus" then
				 unit = Tanari:SpawnDescendantOfZeus(caster:GetAbsOrigin()+RandomVector(50), caster:GetForwardVector())
			elseif unitName == "wind_temple_wind_maiden" then
				unit = Tanari:SpawnWindMaiden(caster:GetAbsOrigin()+RandomVector(50), caster:GetForwardVector())
			elseif unitName == "wind_temple_wind_mage" then
				unit = Tanari:SpawnWindMage(caster:GetAbsOrigin()+RandomVector(50), caster:GetForwardVector())
			elseif unitName == "wind_temple_wind_high_priest" then
				unit = Tanari:SpawnWindHighPriest(caster:GetAbsOrigin()+RandomVector(50), caster:GetForwardVector())
			end
			if IsValidEntity(unit) then
			 unit:SetDeathXP(0)
			 unit.minDrops = false
			 unit.maxDrops = false
			 unit.minDungeonDrops = 0
			 unit.maxDungeonDrops = 0
			 EmitSoundOn("Tanari.WindTemple.PriestRevive", unit)
			 CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_green_smoke02.vpcf", unit, 1)
			 table.insert(newTable, unit)
			 table.insert(newParallelTable, unit:GetUnitName())
			end
		else
			 table.insert(newTable, allyTable[i])
			 table.insert(newParallelTable, parallelTable[i])
		end
	end
	Tanari.WindTemple.finalEncounter = newTable
	Tanari.WindTemple.parallelTable = newParallelTable
end

function revitalizing_winds_think(event)
	local caster = event.caster
	local ability = event.ability

	if caster.aggro and ability:IsFullyCastable() then
		local allyTable = Tanari.WindTemple.finalEncounter 
		local parallelTable = Tanari.WindTemple.parallelTable
		for i = 1, #allyTable, 1 do
			print(allyTable[i])
			if not IsValidEntity(allyTable[i]) then
				ability.allyIndex = i
				local newOrder = {
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
						AbilityIndex = ability:entindex(),
				 	}
				 
				ExecuteOrderFromTable(newOrder)
				break
			end
		end
	end
end

function wind_temple_dragon_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.stopThink then
		local displacement = caster.displacement
		local centerPoint = Vector(9492, 13120, 500)
		local radius = 580
		local zAdd = 0
		if caster.moveIn then
			radius = radius - caster.moveIn
			caster.moveIn = caster.moveIn + 4
			zAdd = caster.zAdd
			caster.zAdd = caster.zAdd + 1
		end
		local newDisplacement = WallPhysics:rotateVector(displacement, -math.pi/160)
		caster.displacement = newDisplacement
		caster:SetAbsOrigin(centerPoint+newDisplacement*radius+Vector(0,0,zAdd))
		caster:SetForwardVector(WallPhysics:rotateVector(newDisplacement, -math.pi/2))
		if radius <= 20 then
			EmitSoundOn("Tanari.WindTemple.StaffEnlighten2", Tanari.WindTemple.windBossStaff)
			Timers:CreateTimer(0.05, function()
				StartAnimation(caster, {duration=7, activity=ACT_DOTA_DIE, rate=0.8})
				-- ability:ApplyDataDrivenModifier(caster, caster, "modifier_wind_temple_dragon_die", {})
			end)
			for j = 1, 30, 1 do
				Timers:CreateTimer(j*0.03, function()
					caster:SetModelScale(2.5-j*0.03)
				end)
			end
			caster.stopThink = true
			caster:RemoveModifierByName("modifier_wind_temple_dragon_idle")
			CustomAbilities:QuickAttachParticle("particles/econ/items/outworld_devourer/od_shards_exile/od_shards_exile_prison_end_mana_flash.vpcf", Tanari.WindTemple.windBossStaff, 1)
			Timers:CreateTimer(1, function()
				for i = 1, 50, 1 do
					Timers:CreateTimer(i*0.03, function()
						Tanari.WindTemple.windBossStaff:SetRenderColor(50+i*1, 50+i*4, 50+i*1)
					end)
				end
				Timers:CreateTimer(0.1, function()
					CustomAbilities:QuickAttachParticle("particles/econ/items/outworld_devourer/od_shards_exile/od_shards_exile_prison_end_mana_flash.vpcf", Tanari.WindTemple.windBossStaff, 1)
				end)
				Timers:CreateTimer(1.5, function()
					Tanari.WindTemple.windBossStaff:RemoveModifierByName("modifier_wind_temple_boss_staff_starting")
					local staffAbility = Tanari.WindTemple.windBossStaff:FindAbilityByName("wind_temple_boss_staff_ability")
					staffAbility:ApplyDataDrivenModifier(Tanari.WindTemple.windBossStaff, Tanari.WindTemple.windBossStaff, "modifier_wind_temple_boss_staff_battle", {})
					Tanari.WindTemple.windBossStaff:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
					EmitSoundOn("Tanari.KeyHolder.WindBreath", Tanari.WindTemple.windBossStaff)
					local health = Tanari.WindTemple.windBossStaff:GetMaxHealth()
					Tanari.WindTemple.windBossStaff:SetHealth(health)
					Tanari.WindTemple.windBossStaff:Heal(health, Tanari.WindTemple.windBossStaff)
				end)
				EmitSoundOn("Tanari.WindTemple.StaffEnlighten", Tanari.WindTemple.windBossStaff)
				UTIL_Remove(caster)
			end)
			
		end
	end
end

function check_dragon_condition()
	local dragonTable = {Tanari.WindTemple.dragon1, Tanari.WindTemple.dragon2, Tanari.WindTemple.dragon3, Tanari.WindTemple.dragon4}
	if dragonTable[1]:HasModifier("modifier_wind_temple_dragon_dummy_active") and dragonTable[2]:HasModifier("modifier_wind_temple_dragon_dummy_active") and dragonTable[3]:HasModifier("modifier_wind_temple_dragon_dummy_active") and dragonTable[4]:HasModifier("modifier_wind_temple_dragon_dummy_active") then
		for i = 1, 4, 1 do
			local ability = dragonTable[i]:FindAbilityByName("wind_temple_dragon_dummy")
			ability:ApplyDataDrivenModifier(dragonTable[i], dragonTable[i], "modifier_wind_temple_dragon_dummy_active", {duration = 500})
			dragonTable[i].moveIn = 0
			dragonTable[i].zAdd = 3
		end
	end
end

function wind_temple_dragon_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	if caster:HasModifier("modifier_wind_temple_dragon_dummy_active") then
	else
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_wind_temple_dragon_dummy_active", {duration = 8.5-RPCItems:GetConnectedPlayerCount()})
		EmitSoundOn("Tanari.WindTemple.DragonHighlight", caster)
		wind_temple_dragon_color_change(caster, true)
		check_dragon_condition()
	end
end

function wind_dragon_deactivate(event)
	wind_temple_dragon_color_change(event.caster, false)
end

function wind_temple_dragon_color_change(dragon, bOn)
	if bOn then
		for i = 1, 25, 1 do
			Timers:CreateTimer(i*0.03, function()
				dragon:SetRenderColor(50+i*8, 50+i*8, 50+i*8)
			end)
		end
	else
		for i = 1, 25, 1 do
			Timers:CreateTimer(i*0.03, function()
				dragon:SetRenderColor(250-i*8, 250-i*8, 250-i*8)
			end)
		end
	end
end



function bossStaffBattleThink(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 1
	end
	if not caster:HasModifier("modifier_staff_boss_z_delta") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_staff_boss_z_delta", {})
		caster.zInterval = 0
	end
	local height = (math.sin(caster.zInterval)+1)
	caster:SetModifierStackCount("modifier_staff_boss_z_delta", caster, (caster.zDelta)+300+height*100-(GetGroundPosition(caster:GetAbsOrigin(), caster).z))
	if GetGroundHeight(caster:GetAbsOrigin(), caster) > caster.zDelta then
		caster.zDelta = caster.zDelta + 1
	else
		caster.zDelta = caster.zDelta - 1
	end
	caster.zInterval = caster.zInterval + 0.05
	caster.interval = caster.interval + 1
	if caster.interval % 30 == 0 then
			-- local casterForward = caster:GetForwardVector()
			-- -- EmitSoundOn("Tanari.KeyHolder.WindBreath", caster)
			-- for i = -2, 2, 1 do
			-- 	local fv = WallPhysics:rotateVector(casterForward, math.pi/3*i)
			-- 	local spellOrigin = caster:GetAbsOrigin()+Vector(0,0,40)+fv*50
			-- 	local forward = caster:GetForwardVector()	
			-- 	local info = 
			-- 	{
			-- 		Ability = ability,
			--         	EffectName = "particles/items/cannon/breath_of_wind.vpcf",
			--         	vSpawnOrigin = spellOrigin,
			--         	fDistance = 200,
			--         	fStartRadius = 80,
			--         	fEndRadius = 150,
			--         	Source = caster,
			--         	StartPosition = "attach_hitloc",
			--         	bHasFrontalCone = true,
			--         	bReplaceExisting = false,
			--         	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			--         	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			--         	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			--         	fExpireTime = GameRules:GetGameTime() + 7.0,
			-- 		bDeleteOnHit = false,
			-- 		vVelocity = fv * 420,
			-- 		bProvidesVision = false,
			-- 	}
			-- 	projectile = ProjectileManager:CreateLinearProjectile(info)	
			-- end
	end
	if caster.interval > 30 then
		caster.interval = 1
	end
	if caster.zInterval > math.pi*2 then
		caster.zInterval = 0
	end
	if caster:GetHealth() < 3000 and not caster.moveTrigger then
		caster.moveTrigger = true
		EmitSoundOn("Tanari.KeyCollect", caster)
		-- caster:RemoveModifierByName("modifier_wind_temple_boss_staff_battle")
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_wind_temple_boss_staff_boss_initiate", {})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_property_wind_staff_disarmed", {})
		
	end
end

function boss_staff_take_damage(event)
	local target = event.target
	local attacker = event.attacker
	local damage = event.damage
	if IsValidEntity(Tanari.WindTemple.bossEntity) and IsValidEntity(target) then
		if target:GetHealth() > 5000 then
			ApplyDamage({ victim = Tanari.WindTemple.bossEntity, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
		end
	end
end

function tanari_staff_projectile_hit(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = Events:GetDifficultyScaledDamage(100, 500, 4000)
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
end

function bossStaffThinkStartBattle(event)
	local position = Vector(7968, 13376, 700)
	local caster = event.caster
	local ability = event.ability
	if Tanari.WindTemple.BossBattleEnd then
		return false
	end
	if not caster.battleStart then
		caster:MoveToPosition(position)
	end
	local casterPos = caster:GetAbsOrigin()
	AddFOWViewer(DOTA_TEAM_GOODGUYS, casterPos, 600, 600, false)
	if not caster.descending then
		if casterPos.x > position.x-30 and casterPos.x < position.x+30 and casterPos.y > position.y-30 and casterPos.y < position.y + 30 then
			
			EmitGlobalSound("Tanari.WindTemple.BossMusicStart")

			caster.descending = true
			for i = 1, 60, 1 do
				Timers:CreateTimer(i*0.03, function()
					caster:SetAngles(i*-3.1, i*-0.2, 3.1*i)
				end)
			end
			Timers:CreateTimer(2.4, function()
				for j = 1, 30, 1 do
					Timers:CreateTimer(j*0.03, function()
						caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,50))
					end)
				end
			end)
			Timers:CreateTimer(3, function()
				local positionBase = caster:GetAbsOrigin()+Vector(0,0,200)
				EmitSoundOnLocationWithCaster(positionBase, "Tanari.WallOpen", Events.GameMaster)
				for j = 1, 9, 1 do
					Timers:CreateTimer(j*0.4, function()
						EmitSoundOnLocationWithCaster(positionBase, "Item.Maelstrom.Chain_Lightning", Events.GameMaster)
						ScreenShake(positionBase+Vector(0,0,600), 500, 0.4, 0.4, 9000, 0, true)
						for i = 1, 4, 1 do
							Events:CreateLightningBeam(positionBase, positionBase+RandomVector(RandomInt(200,800))+Vector(0,0,RandomInt(1600,2000)))
						end
					end)
				end
			end)

			Timers:CreateTimer(0.5, function()
				Tanari.WindTemple.BossBattleBegun = true
				Tanari:WindTempleLast2Tornados()
				Tanari:WindTempleBossMusic()
			end)
			Timers:CreateTimer(2.8, function()
				Tanari:SpawnWindTempleBoss(casterPos)
				Timers:CreateTimer(6.5, function()
					caster.battleStart = true
					caster:SetAngles(90, 0, 90)
					caster.zAdd = 0
					caster:RemoveModifierByName("modifier_property_wind_staff_disarmed")
					-- ability:ApplyDataDrivenModifier(caster, caster, "modifier_wind_staff_rotation_think", {})
				end)
			end)
		end
	end
	if caster.battleStart then
		if caster:GetHealth() < 5000 then
			if not caster.moveToRecharge then
				Events:CreateLightningBeam(caster:GetAbsOrigin()+Vector(0,0,50), Tanari.WindTemple.bossEntity:GetAbsOrigin()+Vector(0,0,220))
				EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Item.Maelstrom.Chain_Lightning", Events.GameMaster)
				ApplyDamage({ victim = Tanari.WindTemple.bossEntity, attacker = caster, damage = Tanari.WindTemple.bossEntity:GetMaxHealth()*0.05, damage_type = DAMAGE_TYPE_PURE})
			end
			caster.moveToRecharge = true
		end
		if caster.moveToRecharge then
			local bossPos = Tanari.WindTemple.bossEntity:GetAbsOrigin() + RandomVector(250)
			caster:MoveToPosition(bossPos)
			local distance = WallPhysics:GetDistance(bossPos, casterPos)
			if distance < 900 then
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_staff_boss_recharging", {})
			else
				caster:RemoveModifierByName("modifier_staff_boss_recharging")
			end
			if caster:HasModifier("modifier_staff_boss_recharging") and caster:GetHealth() > caster:GetMaxHealth()*0.98 then
				caster.moveToRecharge = false
				caster:RemoveModifierByName("modifier_staff_boss_recharging")
			end
		end
	end
end

function wind_temple_boss_think(event)
	
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 1
	end
	if caster.dying then
		return false
	end
	if caster:GetAbsOrigin().z > 1500 then
		caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,20))
	end
	if caster:GetHealth() <= 1000 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_wind_temple_boss_dying", {})
		caster.dying = true
	end
	if caster:GetHealth() < caster:GetMaxHealth()*0.5 and not caster.summonTime then
		caster.summonTime = true
		local positionTable = {Vector(6720, 14144), Vector(6184, 13408), Vector(7475, 13408), Vector(8447, 13408), Vector(6602, 12293), Vector(8665, 12095), Vector(9384, 12095), Vector(9180, 10344), Vector(9759, 10278), Vector(8873, 9286), Vector(8001, 9878)}
		for i = 1, #positionTable, 1 do
			Tanari:SpawnWindGuardian(positionTable[i], Vector(0,-1))
			Tanari:SpawnWindGuardian(positionTable[i], Vector(0,-1))
		end
	end
	print("THINKING?"..caster.interval)
	if caster.interval%4 == 0 then
		local enemyTable = Dungeons:GetTargetTable()
		for i = 1, #enemyTable, 1 do
			ability:ApplyDataDrivenModifier(caster, enemyTable[i], "modifier_wind_boss_slow", {duration = 5})
			local newStack = enemyTable[i]:GetModifierStackCount("modifier_wind_boss_slow", caster) + 1
			enemyTable[i]:SetModifierStackCount("modifier_wind_boss_slow", caster, newStack)
		end
	end
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )	
	if #enemies > 0 then
		for i = 1, #enemies, 1 do
			enemies[i]:RemoveModifierByName("modifier_wind_boss_slow")
		end
	end
	wind_temple_boss_trap_action(caster, ability)
	if caster.interval%6 == 0 then
		local casterForward = caster:GetForwardVector()
		EmitSoundOn("Tanari.KeyHolder.WindBreath", caster)
		for i = -3, 3, 1 do
			local fv = WallPhysics:rotateVector(casterForward, math.pi/5*i)
			wind_temple_boss_projectile(caster, ability, fv)
		end
	end
	local modAdd = 0
	if GameState:GetDifficultyFactor() == 1 then
		modAdd = 7
	end
	if caster.interval%20 == 9 then
		print("MOVE!!")
		local positionTable = {Vector(6720, 14144), Vector(6184, 13408), Vector(7475, 13408), Vector(8447, 13408), Vector(6602, 12293), Vector(8665, 12095), Vector(9384, 12095), Vector(9180, 10344), Vector(9759, 10278), Vector(8873, 9286), Vector(8001, 9878)}
		Timers:CreateTimer(1, function()
			wind_temple_boss_create_traps(caster, ability)
		end)
		wind_temple_boss_descend_and_reascend(caster, ability, positionTable[RandomInt(1,#positionTable)])
	end
	caster.interval = caster.interval + 1
	if caster.interval > 39 then
		caster.interval = 1
	end
end

function wind_temple_boss_descend_and_reascend(caster, ability, position)
	ability:ApplyDataDrivenModifier(caster,caster, "modifier_wind_temple_boss_intro", {duration = 4})
	EmitSoundOn("medusa_medus_anger_11", caster)
	AddFOWViewer(DOTA_TEAM_GOODGUYS, position, 900, 900, false)
	StartAnimation(caster, {duration=1.5, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.7, translate="moth"})
	for i = 1, 50, 1 do
		Timers:CreateTimer(i*0.03, function()
			caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,25))
		end)
	end
	Timers:CreateTimer(2.4, function()
		caster:RemoveModifierByName("modifier_wind_temple_boss_shield")
		ability.damageTaken = 0
		MinimapEvent(DOTA_TEAM_GOODGUYS, caster, position.x, position.y, 1, 4)
		caster:SetAbsOrigin(Vector(position.x, position.y, caster:GetAbsOrigin().z))
		StartAnimation(caster, {duration=1.5, activity=ACT_DOTA_TELEPORT_END, rate=0.7})
		for i = 1, 50, 1 do
			Timers:CreateTimer(i*0.03, function()
				caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,25))
			end)
		end
	end)
end

function temple_boss_take_damage(event)
	local damageTaken = event.damage
	local caster = event.caster
	local ability = event.ability
	if not ability.damageTaken then
		ability.damageTaken = 0
	end
	-- ability.damageTaken = ability.damageTaken + damageTaken
	-- if ability.damageTaken >= caster:GetMaxHealth()*0.16 then
	-- 	ability:ApplyDataDrivenModifier(caster, caster, "modifier_wind_temple_boss_shield", {})
	-- 	ability.damageTaken = 0
	-- end
end

function wind_temple_boss_projectile(caster, ability, fv)
		-- local spellOrigin = caster:GetAbsOrigin()+Vector(0,0,750)
		-- local forward = caster:GetForwardVector()	
		-- local info = 
		-- {
		-- 	Ability = ability,
	 --        	EffectName = "particles/items/cannon/breath_of_wind.vpcf",
	 --        	vSpawnOrigin = spellOrigin,
	 --        	fDistance = 5000,
	 --        	fStartRadius = 80,
	 --        	fEndRadius = 1500,
	 --        	Source = caster,
	 --        	StartPosition = "attach_hitloc",
	 --        	bHasFrontalCone = true,
	 --        	bReplaceExisting = false,
	 --        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	 --        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	 --        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	 --        	fExpireTime = GameRules:GetGameTime() + 7.0,
		-- 	bDeleteOnHit = false,
		-- 	vVelocity = fv * 320,
		-- 	bProvidesVision = false,
		-- }
		-- projectile = ProjectileManager:CreateLinearProjectile(info)	
end

function boss_staff_recharge_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = Tanari.WindTemple.bossEntity
	local particleName = "particles/units/heroes/hero_pugna/epoch_life_give.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_attack1", target:GetAbsOrigin(), true)
	ability.pfx = pfx
	local pfx2 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControlEnt(pfx2, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx2, 1, target, PATTACH_POINT_FOLLOW, "attach_attack2", target:GetAbsOrigin(), true)
	ability.pfx2 = pfx2
end

function boss_staff_recharge_end(event)
	local caster = event.caster
	local ability = event.ability
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ability.pfx = false
	end
	if ability.pfx2 then
		ParticleManager:DestroyParticle(ability.pfx2, false)
		ability.pfx2 = false
	end
end

function wind_staff_rotation_think(event)
	local caster = event.caster
	local ability = event.ability
	caster.zAdd = caster.zAdd + 1
	if caster.battleStart then
		caster:SetAngles(90, 0, 90+caster.zAdd)
		if caster.zAdd >= 270 then
			caster.zAdd = -90
		end
	end
end

function wind_temple_boss_create_traps(caster, ability)
		if ability.trapParticleTable then
			for i = 1, #ability.trapParticleTable, 1 do
				ParticleManager:DestroyParticle(ability.trapParticleTable[i], false)
			end
		end
		ability.trapParticleTable = {}
		ability.trapPositionTable = {}
		local potentialPointsTable = {Vector(9770, 9681), Vector(9387, 11126), Vector(8035, 10624), Vector(7708, 12133), Vector(9472, 13120), Vector(8994, 14280), Vector(7953, 14280), Vector(5824, 14336)}
		local trapA = 0
		local trapB = 0
		local trapC = 0
		while trapA == trapB or trapB == trapC do
			trapA = RandomInt(1, #potentialPointsTable)
			trapB = RandomInt(1, #potentialPointsTable)
			trapC = RandomInt(1, #potentialPointsTable)
		end	
		wind_temple_boss_make_trap(caster, ability, potentialPointsTable[trapA])
		-- wind_temple_boss_make_trap(caster, ability, potentialPointsTable[trapB])
		-- wind_temple_boss_make_trap(caster, ability, potentialPointsTable[trapC])
		if GameState:GetDifficultyFactor() >= 2 then
			wind_temple_boss_make_trap(caster, ability, potentialPointsTable[trapB])
		end
		if GameState:GetDifficultyFactor() >= 3 then
			wind_temple_boss_make_trap(caster, ability, potentialPointsTable[trapC])
		end
end

function wind_temple_boss_make_trap(caster, ability, point)

		local particleName = "particles/units/wind_temple_boss/cloud_trap_portrait.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
		local heightZ = GetGroundHeight(point, caster)+80
		ParticleManager:SetParticleControl(pfx, 0, point+Vector(0,0,heightZ))
		ParticleManager:SetParticleControl(pfx, 1, point+Vector(0,0,heightZ))
		ParticleManager:SetParticleControl(pfx, 2, point+Vector(0,0,heightZ))
		table.insert(ability.trapParticleTable, pfx)
		table.insert(ability.trapPositionTable, point)
end

function wind_temple_boss_trap_action(caster, ability)
	local damage = Events:GetDifficultyScaledDamage(100, 2000, 8000)
	if ability.trapPositionTable then
		for i = 1, #ability.trapPositionTable, 1 do
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), ability.trapPositionTable[i], nil, 380, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
			if #enemies > 0 then
				for i = 1, #enemies, 1 do
					ApplyDamage({ victim = enemies[i], attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
					ability:ApplyDataDrivenModifier(caster, enemies[i], "modifier_wind_boss_trap", {duration = 1})
					CustomAbilities:QuickAttachParticle("particles/units/wind_temple_boss/wind_trap_hit.vpcf", enemies[i], 0.7)
				end
			end
		end
	end
end

function wind_temple_boss_die_begin(event)
	local ability = event.ability
	local caster = event.caster
	if ability.trapParticleTable then
		for i = 1, #ability.trapParticleTable, 1 do
			ParticleManager:DestroyParticle(ability.trapParticleTable[i], false)
		end
	end

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_staff_dying", {})
	Tanari.WindTemple.BossBattleEnd = true
	Timers:CreateTimer(0.5, function()
		EmitSoundOn("Tanari.WindTemple.BossDie1", caster)
	end)
	Timers:CreateTimer(1.5, function()
		EmitGlobalSound("Loot_Drop_Stinger_Arcana")
		Notifications:TopToAll({text="Dungeon Clear!", duration=8.0})
		local luck = RandomInt(1,4)
		if luck == 1 then
			RPCItems:RollGlovesOfSweepingWind(caster:GetAbsOrigin())
		end
	end)
	local bossOrigin = caster:GetAbsOrigin()
	for i = 1, 12, 1 do
		Timers:CreateTimer(0.5*i, function()
			RPCItems:RollItemtype(300, caster:GetAbsOrigin(), 1, 0)
		end)
	end
	for i = 1, #MAIN_HERO_TABLE, 1 do
		MAIN_HERO_TABLE[i]:RemoveModifierByName("modifier_wind_temple_boss_wind_blessing")
	end
	Timers:CreateTimer(8, function()
		CustomGameEventManager:Send_ServerToAllClients("hide_boss_health", {})
		caster:RemoveModifierByName("modifier_wind_temple_boss_dying")
		Timers:CreateTimer(0.1, function()
			StartAnimation(caster, {duration=8, activity=ACT_DOTA_DIE, rate=1})
			EmitSoundOn("Tanari.WindTemple.BossDie2", caster)
			for i = 1, 120, 1 do
				Timers:CreateTimer(i*0.05, function()
					if IsValidEntity(caster) then
						caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,-5))
					end
				end)
			end
			Timers:CreateTimer(6, function()
				UTIL_Remove(caster)
				Tanari:DefeatDungeonBoss("wind", bossOrigin)
			end)
		end)
	end)
	Timers:CreateTimer(10, function()
		UTIL_Remove(Tanari.WindTemple.windBossStaff)
	end)
end

function wind_temple_boss_dying_think(event)
	local caster = event.caster
	CustomAbilities:QuickAttachParticleWithPoint("particles/radiant_fx2/good_ancient001_dest_gobjglow.vpcf", caster, 4, "attach_head")
	EmitSoundOn("Tanari.WindTemple.BossDying", caster)
end

function staff_dying_think(event)
	local caster = Tanari.WindTemple.windBossStaff
	if IsValidEntity(caster) then
		if not caster.moveInterval then
			caster.moveInterval = 1
		end
		if caster.moveInterval%2 == 0 then
			caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(20,20,0))
		else
			caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(20,20,0))
		end
	end
end

function wind_prophet_take_damage(event)
	local unit = event.unit
	local attacker = event.attacker
	local mana_drain_percent = event.mana_drain/100
	local mana_drain = math.max(mana_drain_percent*attacker:GetMaxMana(), 0)
	attacker:ReduceMana(mana_drain)
		local particleName = "particles/econ/items/pugna/pugna_ward_ti5/wind_prophet_shield.vpcf"
		local pfx = ParticleManager:CreateParticle( particleName, PATTACH_POINT, attacker )
		ParticleManager:SetParticleControlEnt(pfx, 0, unit, PATTACH_POINT, "attach_hitloc", unit:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, attacker, PATTACH_POINT, "attach_hitloc", attacker:GetAbsOrigin(), true)
		Timers:CreateTimer(0.5, function() 
		  ParticleManager:DestroyParticle( pfx, false )
		end) 	
		ApplyDamage({ victim = attacker, attacker = unit, damage = mana_drain, damage_type = DAMAGE_TYPE_PURE})
end

function wind_prophet_die(event)
	RPCItems:RollTwigOfEnlightened(event.caster:GetAbsOrigin())
end

function rare_wind_warder_die(event)
	local caster = event.caster
	EmitSoundOn("Tanari.RareWarden.Die", caster)
	RPCItems:RollTempestFalconRing(caster:GetAbsOrigin())
end

function wind_spirit_lightning_think(event)
	local caster = event.caster
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 740, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
	for i = 1, #enemies, 1 do
		local enemy = enemies[i]
		local damage = victim:GetMaxHealth()*0.02
		local name = "attach_attack1"
		Events:CreateLightningBeam(caster:GetAbsOrigin()+Vector(0,0,60), enemy:GetAbsOrigin()+Vector(0,0,70))
		ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
	end
end

function wind_temple_hurricane_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if caster:GetUnitName() == "tanari_wind_bear" then
		if not caster.interval then
			caster.interval = 0
		end
		caster.interval = caster.interval + 1
		if caster.interval%2 == 0 then
			return false
		end
	end
	local fv = target:GetForwardVector()
	ability.pushFV = fv
	local perpFv = WallPhysics:rotateVector(fv,math.pi/2)
	local hurricaneStartPosition = target:GetAbsOrigin() - fv*800 + perpFv*(RandomInt(-420, 420))
	if caster:GetUnitName() == "tanari_wind_bear" then
		hurricaneStartPosition = target:GetAbsOrigin() - fv*700
	end

	local range = 1000
	if caster:GetUnitName() == "tanari_ancient_wind_spirit" then
		range = 2500
	elseif caster:GetUnitName() == "tanari_wind_apparation" then
		range = 2500
	end
	local start_radius = 220
	local end_radius = 220
	local speed = range - 200
	local projectileParticle = "particles/items/hurricane_vest_projectile.vpcf"
	local info = 
	{
			Ability = ability,
        	EffectName = projectileParticle,
        	vSpawnOrigin = hurricaneStartPosition,
        	fDistance = range,
        	fStartRadius = start_radius,
        	fEndRadius = end_radius,
        	Source = target,
        	StartPosition = "attach_origin",
        	bHasFrontalCone = false,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 6.0,
		bDeleteOnHit = false,
		vVelocity = fv * speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info) 	
end

function wind_spirit_die(event)
	local caster = event.caster
	EmitSoundOn("Tanari.WindSpirit.Die", caster)
	local pfx = ParticleManager:CreateParticle("particles/radiant_fx/epoch_rune_c_b_ranged001_lvl3_disintegrate.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()+Vector(0,0,60))
	ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin()+Vector(0,0,60))

	local pfx2 = ParticleManager:CreateParticle("particles/radiant_fx/good_barracks_melee002_lvl3_hit.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx2, 0, caster:GetAbsOrigin()+Vector(0,0,20))
	ParticleManager:SetParticleControl(pfx2, 1, caster:GetAbsOrigin()+Vector(0,0,20))

	Timers:CreateTimer(8, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:DestroyParticle(pfx2, false)
	end)

	Dungeons.respawnPoint = Vector(9727, 14272)

	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Tanari.SpiritRealmEpic", caster)
	local luck = RandomInt(1, 4)
	if luck == 1 then
		RPCItems:RollWindOrchid(caster:GetAbsOrigin())
	end
	local walls = Entities:FindAllByNameWithin("WindTempleSpiritWall", Vector(10560, 14283, 45+Tanari.ZFLOAT), 1200)
	if #walls > 0 then
		Timers:CreateTimer(0.1, function()
			for i = 1, #walls, 1 do
				EmitSoundOnLocationWithCaster(walls[i]:GetAbsOrigin(), "Tanari.WallOpen", Events.GameMaster)
			end
		end)
		for i = 1, 180, 1 do
			for j = 1, #walls, 1 do
				Timers:CreateTimer(i*0.03, function()
					walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin()+Vector(0,0,-5))
					if j == 1 then
						ScreenShake(walls[j]:GetAbsOrigin(), 160, 0.1, 0.1, 9000, 0, true)
					end
				end)
			end
		end
	end
	Timers:CreateTimer(4, function()
		Tanari:SpiritWindTempleStart()
		for i = 1, 300, 1 do
			Timers:CreateTimer(i*0.03, function()
				Tanari.WindTemple.SpiritBridge:SetAbsOrigin(Tanari.WindTemple.SpiritBridge:GetAbsOrigin()+Vector(0,0,1000/300))
			end)
		end
		Timers:CreateTimer(8.9, function()
			EmitSoundOnLocationWithCaster(Tanari.WindTemple.SpiritBridge:GetAbsOrigin(), "Tanari.RockHit", Events.GameMaster)
			ScreenShake(Tanari.WindTemple.SpiritBridge:GetAbsOrigin(), 360, 0.3, 0.3, 9000, 0, true)
		end)
	end)
	Timers:CreateTimer(8.0, function()
        local blockers = Entities:FindAllByNameWithin("WindSpiritBridgeBlocker", Vector(10533, 14272, 83+Tanari.ZFLOAT), 5400)
        for i = 1, #blockers, 1 do
          UTIL_Remove(blockers[i])
        end
	end)
end

function WindSpiritRoom1()
	local positionTable = {Vector(11008, 14656)}
	for i = 1, 10, 1 do
		table.insert(positionTable, Vector(11008, 14656+i*128))
	end
	table.insert(positionTable, Vector(11328, 13568))
	table.insert(positionTable, Vector(11584, 13568))
	table.insert(positionTable, Vector(11718, 13568))
	table.insert(positionTable, Vector(12032, 14016))
	table.insert(positionTable, Vector(12290, 14205))
	table.insert(positionTable, Vector(12290, 14430))

	table.insert(positionTable, Vector(12416, 14656))
	table.insert(positionTable, Vector(12501, 14860))
	table.insert(positionTable, Vector(12558, 15114))

	table.insert(positionTable, Vector(12758, 15369))
	table.insert(positionTable, Vector(12758, 15640))
	table.insert(positionTable, Vector(12758, 15800))

	for i = 1, #positionTable, 1 do
		Timers:CreateTimer(i*0.25, function()
			local fv = (Vector(11840, 15104)-positionTable[i]):Normalized()
			Tanari:SpawnAvianWarderElite(positionTable[i], fv)
		end)
	end
end

function jade_elemental_die(event)
	water_bomb_throw(event)
end

function water_bomb_throw(event)
	local caster = event.caster
	local ability = event.ability
	local target = Vector(15092, 15212, 131)
	if caster:HasModifier("water_bomb_passive") then
		target = Vector(15092, 15212, 131) + RandomVector(1)*RandomInt(500,700)
	end
	
	local zDifferential = 0
	local baseFV = (target*Vector(1,1,0)-caster:GetAbsOrigin()*Vector(1,1,0)):Normalized()
	local forwardVelocity = WallPhysics:GetDistance2d(target, caster:GetAbsOrigin())/28 + 1
	print(caster:GetAttachmentOrigin(2))
	local startPosition = caster:GetAttachmentOrigin(2)
	local fvModifier = ((caster:GetAbsOrigin()-startPosition)*Vector(1,1,0)):Normalized()
	local fvModifierDivisor = 2.8/forwardVelocity
	local adjustedFV = (baseFV + (fvModifier*fvModifierDivisor)):Normalized()
	local randomOffset = 0
	-- local flareAngle = WallPhysics:rotateVector(baseFV, math.pi*randomOffset/160)
    local flare = CreateUnitByName("selethas_boomerang", startPosition, false, caster, nil, caster:GetTeamNumber())
    flare:SetOriginalModel(	"models/hydroxis/water_bomb.vmdl")
    flare:SetModel(	"models/hydroxis/water_bomb.vmdl")
    flare:SetRenderColor(20, 110, 240)
    flare:SetModelScale(0.05)
    flare.fv = adjustedFV
    flare.slow_duration = 5
    flare.liftVelocity = 40 + zDifferential/20
    flare.forwardVelocity = forwardVelocity
    flare.interval = 0

    flare.origCaster = caster
    flare.origAbility = ability
    ability:ApplyDataDrivenModifier(caster, flare, "water_bomb_passive", {})
    local flareSubAbility = ability
    flareSubAbility:ApplyDataDrivenModifier(flare, flare, "modifier_water_bomb_motion", {})
    EmitSoundOn("Tanari.WaterBomb.Start", flare)	

	local pfx2 = ParticleManager:CreateParticle("particles/roshpit/hydroxis/water_orb_throw.vpcf", PATTACH_POINT_FOLLOW, caster)
	Timers:CreateTimer(0.15, function()
		ParticleManager:SetParticleControlEnt(pfx2, 0, flare, PATTACH_POINT_FOLLOW, "attach_origin", flare:GetAbsOrigin(), true)
	end)
	Timers:CreateTimer(1.5, function()
		ParticleManager:DestroyParticle(pfx2, false)
	end)
end

function jade_water_bomb_thinking(event)
	local caster = event.caster
	local ability = event.ability
	caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,caster.liftVelocity) + caster.fv*caster.forwardVelocity)
	caster.liftVelocity = caster.liftVelocity - 3
	local maxScale = 0.35
	if caster.altMaxScale then
		maxScale = caster.altMaxScale
	end
	caster:SetModelScale(0.01)
	local newFV = WallPhysics:rotateVector(caster:GetForwardVector(), math.pi/30)
	caster:SetForwardVector(newFV)
	caster:SetAngles(caster.interval*7, caster.interval*7, caster.interval*7)
	caster.interval = caster.interval + 1
	local groundHeight = GetGroundHeight(caster:GetAbsOrigin(), caster)
	if caster:GetAbsOrigin().z - groundHeight < 10 then
		flareParticle(caster:GetAbsOrigin(), caster)
		EmitSoundOn("Tanari.WaterBomb.Explode", caster)
		caster:RemoveModifierByName("modifier_water_bomb_motion")
		bombImpact(caster, ability)
		caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,1000))
		Timers:CreateTimer(0.1, function()
			caster:SetModelScale(0.01)
			Timers:CreateTimer(1, function()
				UTIL_Remove(caster)
			end)
		end)
	end
end

function flareParticle(position)
      local particleNameS = "particles/roshpit/hydroxis/water_bomb_explode.vpcf"
      local particle2 = ParticleManager:CreateParticle( particleNameS, PATTACH_WORLDORIGIN, caster )
      ParticleManager:SetParticleControl( particle2, 0, position)
      ParticleManager:SetParticleControl( particle2, 1, Vector(260,260,260) )
      ParticleManager:SetParticleControl( particle2, 2, Vector(3.0, 3.0, 1) )
      ParticleManager:SetParticleControl( particle2, 4, Vector(100, 205, 255) )
      Timers:CreateTimer(1.5, 
      function()
        ParticleManager:DestroyParticle( particle2, false )
      end)

	local pfx = ParticleManager:CreateParticle("particles/roshpit/hydroxis/water_bomb_water_explosion_splash_fxset.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, position-Vector(0,0,200))
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)

	local particleName = "particles/roshpit/hydroxis/slipstream_puddle.vpcf"
	local pfx2 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx2, 0, position+Vector(0,0,100))
	Timers:CreateTimer(5, function()
		ParticleManager:DestroyParticle(pfx2, false)
	end)
end

function bombImpact(caster, ability)
	if caster.origCaster:HasModifier("water_bomb_passive") then
		Timers:CreateTimer(0.1, function()
			caster.origCaster:RemoveModifierByName("water_bomb_passive")
			caster.origCaster:RemoveNoDraw()
			Dungeons:AggroUnit(caster.origCaster)
		end)
		caster.origCaster:SetAbsOrigin(caster:GetAbsOrigin())
	else
		local treeTarget = GameState:GetDifficultyFactor() + 2
		if not Tanari.WindTemple.TreeGrowth then
			Tanari.WindTemple.TreeGrowth = 0
		end
		local tree = Entities:FindByNameNearest("GardenTree", Vector(15092, 15213), 1200)
		Tanari.WindTemple.TreeGrowth = Tanari.WindTemple.TreeGrowth + 1
		-- local treeScale = 0.3 + (1.7/treeTarget)*(Tanari.WindTemple.TreeGrowth-1)
		for i = 1, 30, 1 do
			Timers:CreateTimer(i*0.03, function()
				local treeScale = tree:GetModelScale() + 0.5/treeTarget/30
				tree:SetModelScale(treeScale)
			end)
		end
		local delayTime = 7-GameState:GetDifficultyFactor()
		Timers:CreateTimer(delayTime, function()
			if Tanari.WindTemple.TreeGrowth < treeTarget then
				if not Tanari.WindTemple.TreeGrowLock then

					Tanari.WindTemple.TreeGrowth = Tanari.WindTemple.TreeGrowth - 1
					recreateJadeElemental()
					for i = 1, 30, 1 do
						Timers:CreateTimer(i*0.03, function()
							local treeScale = tree:GetModelScale() - 0.52/treeTarget/30
							tree:SetModelScale(treeScale)
						end)
					end
				end
			end
		end)
		if Tanari.WindTemple.TreeGrowth == treeTarget then
			EmitGlobalSound("Tanari.HarpMystery")
			Tanari.WindTemple.TreeGrowLock = true
			Timers:CreateTimer(1.4, function()
				Tanari:TreeComplete()
			end)
			-- puzzle success
		end
	end
end

function recreateJadeElemental()
	local elemental = Tanari:SpawnJadeElemental(Vector(15092, 15213), RandomVector(1), true)
	local ability = elemental:FindAbilityByName("tanari_jade_elemental_hydrosis")
	ability:ApplyDataDrivenModifier(elemental, elemental, "water_bomb_passive", {})
	elemental:AddNoDraw()
	local eventTable = {}
	eventTable.caster = elemental
	eventTable.ability = ability
	water_bomb_throw(eventTable)
end

function wind_temple_unit_die(event)
	local unit = event.unit
	if unit.code then
		if unit.code == 0 then
			local delay = 0.8
			Tanari.WindTemple.SpiritWaveUnitsSlain = Tanari.WindTemple.SpiritWaveUnitsSlain + 1
			if Tanari.WindTemple.SpiritWaveUnitsSlain == 38 then
				local spawnPositionTable = {Vector(15035, 15844), Vector(15707, 14865), Vector(14578, 14374), Vector(14297, 15239)}
				for i = 1, #spawnPositionTable, 1 do
					Tanari:SpawnSpiritWindWaveUnit("wind_temple_avian_warder_elite", spawnPositionTable[i], 12, 33, delay, true)
				end
			elseif Tanari.WindTemple.SpiritWaveUnitsSlain == 84 then
				Tanari:SpawnSpiritWindWaveUnit("wind_temple_avian_warder_elite", Vector(15035, 15844), 12, 33, delay, true)
				Tanari:SpawnSpiritWindWaveUnit("wind_temple_descendant_of_zeus", Vector(15707, 14865), 12, 33, delay, true)
				Tanari:SpawnSpiritWindWaveUnit("wind_temple_wind_maiden", Vector(14578, 14374), 12, 33, delay, true)
				Tanari:SpawnSpiritWindWaveUnit("wind_temple_wind_maiden", Vector(14297, 15239), 12, 33, delay, true)
			elseif Tanari.WindTemple.SpiritWaveUnitsSlain == 130 then
				Tanari:SpawnSpiritWindWaveUnit("wind_temple_avian_warder_elite", Vector(15035, 15844), 12, 33, delay, true)
				Tanari:SpawnSpiritWindWaveUnit("wind_temple_avian_warder_elite", Vector(15707, 14865), 12, 33, delay, true)
				Tanari:SpawnSpiritWindWaveUnit("wind_temple_gardener", Vector(14578, 14374), 8, 33, delay, true)
				Tanari:SpawnSpiritWindWaveUnit("wind_temple_wind_maiden", Vector(14297, 15239), 12, 33, delay, true)
			elseif Tanari.WindTemple.SpiritWaveUnitsSlain == 172 then
				Tanari:SpawnSpiritWindWaveUnit("tanari_thicket_bat", Vector(15035, 15844), 12, 33, delay, true)
				Tanari:SpawnSpiritWindWaveUnit("wind_temple_descendant_of_zeus", Vector(15707, 14865), 12, 33, delay, true)
				Tanari:SpawnSpiritWindWaveUnit("tanari_thicket_bat", Vector(14578, 14374), 12, 33, delay, true)
				Tanari:SpawnSpiritWindWaveUnit("tanari_thicket_bat", Vector(14297, 15239), 12, 33, delay, true)
			elseif Tanari.WindTemple.SpiritWaveUnitsSlain == 220 then
				for i = 1, #Tanari.windSpawnPortalTable, 1 do
					ParticleManager:DestroyParticle(Tanari.windSpawnPortalTable[i], false)
					ParticleManager:ReleaseParticleIndex(Tanari.windSpawnPortalTable[i])
				end
				local walls = Entities:FindAllByNameWithin("WindTempleSpiritWall", Vector(14985, 13529, 36+Tanari.ZFLOAT), 1200)
				if #walls > 0 then
					Timers:CreateTimer(0.1, function()
						for i = 1, #walls, 1 do
							EmitSoundOnLocationWithCaster(walls[i]:GetAbsOrigin(), "Tanari.WallOpen", Events.GameMaster)
						end
					end)
					for i = 1, 180, 1 do
						for j = 1, #walls, 1 do
							Timers:CreateTimer(i*0.03, function()
								walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin()+Vector(0,0,-5))
								if j == 1 then
									ScreenShake(walls[j]:GetAbsOrigin(), 160, 0.1, 0.1, 9000, 0, true)
								end
							end)
						end
					end
				end
				Timers:CreateTimer(4, function()
					Tanari:SpiritWindTempleRoom2()
					for i = 1, 300, 1 do
						Timers:CreateTimer(i*0.03, function()
							Tanari.WindTemple.SpiritBridge2:SetAbsOrigin(Tanari.WindTemple.SpiritBridge2:GetAbsOrigin()+Vector(0,0,1000/300))
						end)
					end
					Timers:CreateTimer(8.9, function()
						EmitSoundOnLocationWithCaster(Tanari.WindTemple.SpiritBridge2:GetAbsOrigin(), "Tanari.RockHit", Events.GameMaster)
						ScreenShake(Tanari.WindTemple.SpiritBridge2:GetAbsOrigin(), 360, 0.3, 0.3, 9000, 0, true)
					end)
				end)
				Timers:CreateTimer(8.0, function()
			        local blockers = Entities:FindAllByNameWithin("WindSpiritBlocker1", Vector(14912, 13568, 83+Tanari.ZFLOAT), 5400)
			        for i = 1, #blockers, 1 do
			          UTIL_Remove(blockers[i])
			        end
				end)
			end
		end
	end
end

function WindSpiritBridgeTrigger(event)
	local positionTable = {}
	for i = 0, 6, 1 do
		table.insert(positionTable, Vector(14720-RandomInt(0,200), 12544+i*128))
	end
	for j = 0, 6, 1 do
		table.insert(positionTable, Vector(15232+RandomInt(0,200), 12544+j*128))
	end
	for i = 1, #positionTable, 1 do
		Timers:CreateTimer(i*0.25, function()
			local fv = (Vector(11840, 15104)-positionTable[i]):Normalized()
			Tanari:SpawnAvianWarderElite(positionTable[i], fv)
		end)
	end
end

function wind_defense_particle(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Tanari.WindKeyHolderStoneForm", caster)
	CustomAbilities:QuickAttachParticle("particles/econ/items/earth_spirit/earth_spirit_ti6_boulder/espirit_ti6_rollingboulder_gather.vpcf", caster, 3)
end

function wind_defense_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	local duration = event.duration
	if ability:GetCooldownTimeRemaining() <= 0 then
		ability:StartCooldown(3)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_wind_temple_key_stone_form", {duration = duration})
	end
end

function fish_detected_enemy(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn( "Tanari.WindLizard.Aggro", caster)
	WallPhysics:Jump(caster, Vector(1,0), 0, 34, 26, 1.2)
	Timers:CreateTimer(0.2, function()
		EmitSoundOn("Tanari.WaterSplashLight", caster)
	end)
	Timers:CreateTimer(0.5, function()
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_slardar/slardar_crush_puddle.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, GetGroundPosition(caster:GetAbsOrigin(), caster)+Vector(0,0,20))
		Timers:CreateTimer(5, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	end)
	StartAnimation(caster, {duration=1.6, activity=ACT_DOTA_SPAWN, rate=0.94})
	Timers:CreateTimer(1.6, function()

		caster:RemoveModifierByName("modifier_thicket_growth_waiting")
	end)
end

function wind_sprite_attack_land(event)
	local caster = event.caster
	local target = event.target
	local hero = target
	if not target.pushLock and not target.jumpLock then
		if not hero:HasModifier("modifier_wind_temple_flailing") then
			local fv = ((target:GetAbsOrigin() - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
			WallPhysics:Jump(hero, fv, 16, 15, 22, 1.0)
			add_flail_effect(hero)
		end	
	end
end

function wind_tree_take_damage(event)
	local caster = event.caster
	local attacker = event.attacker
	local damage = event.damage
	EmitSoundOn("Tanari.WindTreant.Return", attacker)
	CustomAbilities:QuickAttachParticle("particles/econ/items/storm_spirit/storm_spirit_orchid_hat/stormspirit_orchid_ball_end.vpcf", attacker, 3)
	ApplyDamage({ victim = attacker, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
end

function wind_tree_die(event)
	local caster = event.caster
	EmitSoundOn("Tanari.WindTreant.Death", caster)
end

function WindSpiritFinalArea(trigger)
	local positionTable = {Vector(15505, 4416), Vector(14208, 5056), Vector(13170, 5568), Vector(11648, 6464), Vector(11520, 5120)}
	local fvTable = {Vector(0,1), Vector(1,-1), Vector(1,0), Vector(1,-1), Vector(0,1)}
	for i = 1, #positionTable, 1 do
		Timers:CreateTimer(i*0.2, function()
			Tanari:SpawnWindApparition(positionTable[i], fvTable[i])
		end)
	end
	local positionTable = {Vector(15680, 5120), Vector(15104, 4544), Vector(14592, 4326), Vector(14062, 5383), Vector(12992, 5383), Vector(12314, 6016), Vector(11438, 6720)}
	for i = 1, #positionTable, 1 do
		Timers:CreateTimer(i*0.2, function()
			 Tanari:SpawnWindSpark(positionTable[i], RandomVector(1))
		end)
	end

	local positionTable = {Vector(11520, 5568), Vector(15552, 5056), Vector(11520, 6604), Vector(15168, 4608), Vector(12032, 6240), Vector(14464, 4944), Vector(12992, 5536), Vector(13888, 5405)}
	for i = 1, #positionTable, 1 do
		Timers:CreateTimer(i*0.8, function()
			local patrolPositionTable = {}
			for j = 1, #positionTable, 1 do
				local index = i + j
				if index > #positionTable then
					index = index - #positionTable
				end
				table.insert(patrolPositionTable, positionTable[index])
			end
			local elemental = Tanari:SpawnDescendantOfZeus(positionTable[i], RandomVector(1))
			Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, elemental, "tanari_mountain_specter_ai", {})
			Tanari:AddPatrolArguments(elemental, 20, 8, 30, patrolPositionTable)
		end)
	end
	Tanari:SpawnWindCrusher(Vector(12032, 6464), Vector(0.3,-1))
	Tanari:SpawnWindCrusher(Vector(11328, 6528), Vector(1,-1))

	Timers:CreateTimer(4, function()
		local positionTable = {Vector(15808, 4544), Vector(15168, 4800), Vector(14656, 4928), Vector(14528, 4288), Vector(14336, 4416), Vector(14336, 5312), Vector(13696, 5120), Vector(12544, 5568), Vector(12736, 5888), Vector(12224, 6208), Vector(11904, 6720), Vector(11328, 6144)}
		for i = 1, #positionTable, 1 do
			local flower = Tanari:SpawnPoisonFlower(RandomVector(1), positionTable[i])
			Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, flower, "tanari_mountain_specter_ai", {})
		end
	end)
	Tanari:SpawnWindBallSwitch(Vector(15524, 5431, 620))
	Tanari.WindTemple.SpiritBridge3 = Entities:FindByNameNearest("WindSpiritBridge", Vector(11516, 3594, 96+Tanari.ZFLOAT), 1200)
	Tanari.WindTemple.SpiritBridge3:SetAbsOrigin(Tanari.WindTemple.SpiritBridge3:GetAbsOrigin() - Vector(0,0,1000))

	Tanari.WindTemple.FrozenDemon = Tanari:SpawnWindDemon(Vector(11558, 4439), Vector(0,1))
end

function crimsyth_ball_prop_attacked(event)
	local caster = event.caster
	local attacker = event.attacker
	local ability = event.ability
	if not attacker:IsHero() then
		return false
	end
	local hitDirectionVector = ((caster:GetAbsOrigin() - attacker:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	if attacker:GetAttackCapability() == DOTA_UNIT_CAP_RANGED_ATTACK then
		caster.fv = hitDirectionVector
	else
		caster.fv = attacker:GetForwardVector()
	end
	caster.forwardVelocity = math.min(caster.moveVelocity + 15, 40)
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), attacker:GetAbsOrigin())
	caster.liftVelocity = math.min(caster.liftVelocity + distance/12, 14)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_ball_switch_moving", {})
	caster.noDust = false
end

function ball_prop_think(event)
	local caster = event.caster
	if caster:GetAbsOrigin().z > 1200 + Tanari.ZFLOAT then
		caster:SetAbsOrigin(GetGroundPosition(caster.startPosition, caster))
		caster:RemoveModifierByName("modifier_ball_switch_moving")
	end
	if (WallPhysics:IsWithinRegionA(caster:GetAbsOrigin(), Vector(10280,3559), Vector(16095, 6858)) or WallPhysics:IsWithinRegionA(caster:GetAbsOrigin(), Vector(10280,6000), Vector(12245, 7505))) then
	else
		caster:SetAbsOrigin(GetGroundPosition(caster.startPosition, caster))
		caster:RemoveModifierByName("modifier_ball_switch_moving")
	end
	FindClearSpaceForUnit(Events.SafeItemEntity, caster:GetAbsOrigin(), false)
	local safePosition = Events.SafeItemEntity:GetAbsOrigin()
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), safePosition)
	if distance > 130 then
		caster:SetAbsOrigin(GetGroundPosition(caster.startPosition, caster))
		caster:RemoveModifierByName("modifier_ball_switch_moving")
	end
	AddFOWViewer(DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), 340, 5, false)
end

function ball_switch_moving_think(event)
	local ball = event.target
	if not IsValidEntity(ball) then
		return false
	end
	local fv = ball.fv
	-- barrel:SetForwardVector(WallPhysics:rotateVector(fv,math.pi/2))
	local currentRoll = ball.roll
	local newRoll = ball.roll + ball.forwardVelocity/3
	if newRoll > 180 then
		newRoll = -180
	end
	ball.roll = newRoll
	ball.pitch = ball.pitch + ball.liftVelocity/3
	if ball.pitch > 180 then
		ball.pitch = -180
	end
	if ball.forwardVelocity <= 0 then
		if ball:GetAbsOrigin().z - GetGroundHeight(ball:GetAbsOrigin(), ball) < 40 then
			ball:RemoveModifierByName("modifier_ball_switch_moving")
		end
	end
	ball:SetAngles(0, 0, 0)

	local velocityChange = -0.3
	local newPosition = ball:GetAbsOrigin() + ball.fv*ball.forwardVelocity + Vector(0,0,ball.liftVelocity)
	local obstruction = WallPhysics:FindNearestObstruction(newPosition+ball.fv)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition+ball.fv, ball)
	ball.liftVelocity = ball.liftVelocity - 0.8
	if ball.liftVelocity < 0 then
		if ball:GetAbsOrigin().z - GetGroundHeight(ball:GetAbsOrigin(), ball) < 40 then
			if ball.liftVelocity < -10 then
				ball.liftVelocity = ball.liftVelocity/-1.5
			else
				ball.liftVelocity = 0
				ball.noDust = true
				if ball.forwardVelocity < 1 then
					ball:RemoveModifierByName("modifier_ball_switch_moving")
				end
			end
			if not ball.noDust then
				newPosition = GetGroundPosition(ball:GetAbsOrigin(), ball)
				EmitSoundOn("Tanari.WindBall.Hit", ball)
				local pfx = ParticleManager:CreateParticle( "particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, ball )
				ParticleManager:SetParticleControl( pfx, 0, ball:GetAbsOrigin() )
				ParticleManager:SetParticleControl( pfx, 1, Vector(200, 200, 200) )
				Timers:CreateTimer(2, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)
			end
		end
	end
	if blockUnit then
		ball.forwardVelocity = math.max(ball.forwardVelocity/1.6, 0)
		-- barrel.fv = WallPhysics:rotateVector(barrel.fv*-1, 2*math.pi*RandomInt(-5,5)/180)
		-- local normal = WallPhysics:rotateVector((obstruction:GetAbsOrigin() - barrel:GetAbsOrigin()):Normalized(), math.pi/2)
		local normal = ((obstruction:GetAbsOrigin() - ball:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		normal = WallPhysics:rotateVector(normal, math.pi/2)
		local reflectionVector = 2*(normal:Dot(ball.fv, normal))*normal - ball.fv
		ball.fv = reflectionVector:Normalized()
		newPosition = ball:GetAbsOrigin()+(ball.fv*ball.forwardVelocity*2)
		ball:SetAbsOrigin(newPosition)
		EmitSoundOn("Tanari.WindBall.Hit", ball)
		local pfx = ParticleManager:CreateParticle( "particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, ball )
		ParticleManager:SetParticleControl( pfx, 0, ball:GetAbsOrigin() )
		ParticleManager:SetParticleControl( pfx, 1, Vector(200, 200, 200) )
		Timers:CreateTimer(2, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	else
		local slopeEffect = GetGroundHeight(ball:GetAbsOrigin(), ball) - GetGroundHeight(newPosition, ball)
		velocityChange = velocityChange + slopeEffect/10
		ball:SetAbsOrigin(newPosition)
	end
	ball.forwardVelocity = math.max(ball.forwardVelocity + velocityChange, 0)
	ball.interval = ball.interval + 1
	if ball.interval%3 == 0 then
		local goalDistance = WallPhysics:GetDistance(Vector(11551, 4595, 670), ball:GetAbsOrigin())
		print("GOAL DISTANCE:")
		print(goalDistance)
		if goalDistance < 120 then
			ball:RemoveModifierByName("modifier_ball_switch_moving")
			ball:FindAbilityByName("tanari_wind_ball_prop"):ApplyDataDrivenModifier(ball, ball, "modifier_water_shield_no_more_attack", {})
			Timers:CreateTimer(6, function()
				UTIL_Remove(ball)
			end)
			checkBallSwitchGoal()
			local ballSwitchGoalProps = Entities:FindAllByNameWithin("WindSpiritSwitchGoal", ball:GetAbsOrigin(), 2000)
			ball:SetAbsOrigin(ballSwitchGoalProps[1]:GetAbsOrigin()+Vector(0,0,140))
			table.insert(ballSwitchGoalProps, ball)
			EmitSoundOnLocationWithCaster(ball:GetAbsOrigin(), "Tanari.WindBall.Goal", ball)
			Tanari:Walls(false, ballSwitchGoalProps, true, 1.18)
			Timers:CreateTimer(2, function()
				local pfx = ParticleManager:CreateParticle( "particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
				ParticleManager:SetParticleControl( pfx, 0, ballSwitchGoalProps[1]:GetAbsOrigin() )
				ParticleManager:SetParticleControl( pfx, 1, Vector(200, 200, 200) )
				Timers:CreateTimer(2, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)
			end)
			-- for j = 1, 100, 1 do
			-- 	Timers:CreateTimer(j*0.03, function()
			-- 		for k = 1, #ballSwitchGoalProps, 1 do
			-- 			ballSwitchGoalProps[k]:SetAbsOrigin(ballSwitchGoalProps[k]:GetAbsOrigin()-Vector(0,0,8))
			-- 		end
			-- 	end)
			-- end
		end
	end
end

function wind_demon_hurricane_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	for i = 1, 12, 1 do
		local fv = WallPhysics:rotateVector(target:GetForwardVector(), (2*math.pi/12)*i)
		local hurricaneStartPosition = target:GetAbsOrigin()+fv*800
		local range = 600
		local start_radius = 220
		local end_radius = 220
		local speed = 800
		local projectileParticle = "particles/items/hurricane_vest_projectile.vpcf"
		local info = 
		{
				Ability = ability,
	        	EffectName = projectileParticle,
	        	vSpawnOrigin = hurricaneStartPosition,
	        	fDistance = range,
	        	fStartRadius = start_radius,
	        	fEndRadius = end_radius,
	        	Source = target,
	        	StartPosition = "attach_origin",
	        	bHasFrontalCone = false,
	        	bReplaceExisting = false,
	        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	        	fExpireTime = GameRules:GetGameTime() + 6.0,
			bDeleteOnHit = false,
			vVelocity = -fv * speed,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info) 
	end	
end

function demon_hurricane_hit(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if target.jumpLock then
		return false
	end
	FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_hurricane_vest_pushing", {duration = 1.0})
	target.hurricanePushFV = ((target:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()*-1
end

function checkBallSwitchGoal()
	Timers:CreateTimer(1, function()
		EmitSoundOnLocationWithCaster(Tanari.WindTemple.FrozenDemon:GetAbsOrigin(), "Tanari.WindZuusStatue.ChargeUp", Tanari.WindTemple.FrozenDemon)
	end)
	Timers:CreateTimer(3, function()
		for i = 1, 80, 1 do
			Timers:CreateTimer(i*0.03, function()
				local moveVector = Vector(-10, 0)
				if i%2 == 0 then
					moveVector = Vector(10,0)
					ScreenShake(Tanari.WindTemple.FrozenDemon:GetAbsOrigin(), 160, 0.1, 0.1, 9000, 0, true)
				end
				if i%10 == 0 then
					local lightningPos = Vector(11547, 4595, 400) + RandomVector(RandomInt(0,240))
					Events:CreateLightningBeam(lightningPos, lightningPos+Vector(0,0,1200))
					EmitSoundOnLocationWithCaster(Tanari.WindTemple.FrozenDemon:GetAbsOrigin(), "Tanari.WindZuusStatue.Shaking", Tanari.WindTemple.FrozenDemon)
				end
				-- if i%35 == 0 then
				-- 	EmitSoundOnLocationWithCaster(Tanari.WindTemple.FrozenDemon:GetAbsOrigin(), "Tanari.WindZuusStatue.Shaking", Tanari.WindTemple.FrozenDemon)
				-- end
				Tanari.WindTemple.FrozenDemon:SetAbsOrigin(Tanari.WindTemple.FrozenDemon:GetAbsOrigin()+moveVector)
			end)
		end
		Timers:CreateTimer(2.35, function()
			Tanari.WindTemple.FrozenDemon:RemoveModifierByName("modifier_wind_demon_waiting")
			local demonAbility = Tanari.WindTemple.FrozenDemon:FindAbilityByName("tanari_wind_demon_passive")
			demonAbility:ApplyDataDrivenModifier(Tanari.WindTemple.FrozenDemon, Tanari.WindTemple.FrozenDemon, "modifier_hurricane_vest_hurricane", {})
			EmitSoundOn("Tanari.WindZuusStatue.Aggro", Tanari.WindTemple.FrozenDemon)
			EmitSoundOnLocationWithCaster(Tanari.WindTemple.FrozenDemon:GetAbsOrigin(), "Tanari.WindBall.Hit", Events.GameMaster)
		end)
	end)
end

function wind_demon_die(event)
	local walls = Entities:FindAllByNameWithin("WindTempleSpiritWall", Vector(11519, 3809, 36+Tanari.ZFLOAT), 1200)
	if #walls > 0 then
		Timers:CreateTimer(0.1, function()
			for i = 1, #walls, 1 do
				EmitSoundOnLocationWithCaster(walls[i]:GetAbsOrigin(), "Tanari.WallOpen", Events.GameMaster)
			end
		end)
		for i = 1, 180, 1 do
			for j = 1, #walls, 1 do
				Timers:CreateTimer(i*0.03, function()
					walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin()+Vector(0,0,-5))
					if j == 1 then
						ScreenShake(walls[j]:GetAbsOrigin(), 160, 0.1, 0.1, 9000, 0, true)
					end
				end)
			end
		end
	end
	local luck = RandomInt(1,3)
	if luck == 1 then
		RPCItems:RollAnkhOfAncients(event.caster:GetAbsOrigin())
	end
	Timers:CreateTimer(4, function()
		Tanari:SpiritWindTempleBossRoom()
		for i = 1, 300, 1 do
			Timers:CreateTimer(i*0.03, function()
				Tanari.WindTemple.SpiritBridge3:SetAbsOrigin(Tanari.WindTemple.SpiritBridge3:GetAbsOrigin()+Vector(0,0,1000/300))
			end)
		end
		Timers:CreateTimer(8.9, function()
			EmitSoundOnLocationWithCaster(Tanari.WindTemple.SpiritBridge3:GetAbsOrigin(), "Tanari.RockHit", Events.GameMaster)
			ScreenShake(Tanari.WindTemple.SpiritBridge3:GetAbsOrigin(), 360, 0.3, 0.3, 9000, 0, true)
		end)
	end)
	Timers:CreateTimer(8.0, function()
        local blockers = Entities:FindAllByNameWithin("WindSpiritBlocker1", Vector(11520, 3858, 83+Tanari.ZFLOAT), 5400)
        for i = 1, #blockers, 1 do
          UTIL_Remove(blockers[i])
        end
	end)
end

function WindSpiritTornado(trigger)
	local hero = trigger.activator
	EmitSoundOn("Tanari.WindPortalSpawn", hero)
	ParticleManager:DestroyParticle(Tanari.WindTemple.TornadoPFX, false)
	local pfx = ParticleManager:CreateParticle("particles/econ/events/fall_major_2016/cyclone_fm06.vpcf", PATTACH_WORLDORIGIN, guardian)
	ParticleManager:SetParticleControl(pfx, 0, Vector(13777, 2202, 428))
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, hero, "tanari_wind_tornado_jump", {})
	Tanari.TanariMasterAbility.liftVelocity = 50
	Tanari.TanariMasterAbility.liftPosition = hero:GetAbsOrigin()
end

function wind_tornado_jump(event)
	local target = event.target
	local ability = event.ability
	ability.liftVelocity = ability.liftVelocity - 0.7
	target:RemoveModifierByName("modifier_hurricane_vest_pushing")
	target.pushLock = true
	Tanari.TanariMasterAbility.liftPosition = Tanari.TanariMasterAbility.liftPosition + Vector(0,0,ability.liftVelocity)
	target:SetAbsOrigin(Tanari.TanariMasterAbility.liftPosition)

	if ability.liftVelocity < 0 then
		if target:GetAbsOrigin().z < GetGroundHeight(target:GetAbsOrigin(), target) + 50 then
			target:RemoveModifierByName("tanari_wind_tornado_jump")
			ScreenShake(target:GetAbsOrigin(), 800, 0.9, 0.9, 9000, 0, true)
			local pfx = ParticleManager:CreateParticle( "particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, target )
			ParticleManager:SetParticleControl( pfx, 0, target:GetAbsOrigin() )
			ParticleManager:SetParticleControl( pfx, 1, Vector(200, 200, 200) )
			Timers:CreateTimer(2, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
			for i = 1, #Tanari.WindTemple.GuardianTable, 1 do
				local guardian = Tanari.WindTemple.GuardianTable[i]
				guardian:RemoveModifierByName("modifier_valley_guardian_waiting")
				guardian.aggro = true
				EmitSoundOn("Tanari.WindKeyHolderStoneForm", guardian)
				CustomAbilities:QuickAttachParticle("particles/econ/items/earth_spirit/earth_spirit_ti6_boulder/espirit_ti6_rollingboulder_gather.vpcf", guardian, 3)

				CustomAbilities:QuickAttachParticle("particles/radiant_fx/good_barracks_ranged002_destroy.vpcf", guardian, 3)
				Timers:CreateTimer(0.5, function()
					EmitSoundOnLocationWithCaster(guardian:GetAbsOrigin(), "Tanari.WindGuardian.SpawnVO", guardian)
				end)
				guardian:SetAcquisitionRange(3000)
			end
			target.pushLock = false
		end
	end
end

function wind_guardian_quake(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local radius = 240
	local position = ability.position
	local splitEarthParticle = "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf"
	local damage = event.damage
	local pfx = ParticleManager:CreateParticle( splitEarthParticle, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, position )
	ParticleManager:SetParticleControl( pfx, 1, Vector(radius, radius, radius) )
	EmitSoundOn("Tanari.Ancient.Quake", caster)
	-- FindClearSpaceForUnit(caster, position, false)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius+5, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })	
			enemy:AddNewModifier(caster, event.ability, "modifier_stunned", {duration = 1.2})
		end
	end 		
end

function valley_guardian_think(event)
	local target = event.target
	if target.boss then
		target:MoveToPositionAggressive(target.boss:GetAbsOrigin()+RandomVector(300))
	end
end

function valley_guardian_die(event)
	local caster = event.caster
	if not Tanari.WindTemple.GuardianDeath then
		Tanari.WindTemple.GuardianDeath = 0
	end
	if Tanari.WindTemple.SpiritBossDead then
		return false
	end
	Tanari.WindTemple.GuardianDeath = Tanari.WindTemple.GuardianDeath + 1
	if Tanari.WindTemple.GuardianDeath == 4 then
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Ambient.Tanari.Windy", Events.GameMaster)
		Timers:CreateTimer(1, function()
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Tanari.WindPortalSpawn", Events.GameMaster)
		end)
		Timers:CreateTimer(4, function()
			Tanari.WindTemple.GuardianTable = {}
			Tanari:SpawnWindTempleSpiritBoss()
			local guardianPositionTable = {Vector(13787, 2631), Vector(14083, 2351), Vector(13786, 2031), Vector(13440, 2351)}
			local fvTable = {Vector(0,1), Vector(1,0), Vector(0,-1), Vector(-1,0)}
			for i = 1, #guardianPositionTable, 1 do
				Timers:CreateTimer(i*0.5, function()
					local guardian = Tanari:SpawnWindValleyGuardian(guardianPositionTable[i], fvTable[i], 0)
					Events:CreateLightningBeam(guardianPositionTable[i], guardianPositionTable[i]+Vector(0,0,RandomInt(1600,2000)))
					EmitSoundOnLocationWithCaster(guardianPositionTable[i], "Item.Maelstrom.Chain_Lightning", Events.GameMaster)
					ScreenShake(guardianPositionTable[i]+Vector(0,0,600), 500, 0.4, 0.4, 9000, 0, true)
					CustomAbilities:QuickAttachParticle("particles/econ/items/earth_spirit/earth_spirit_ti6_boulder/espirit_ti6_rollingboulder_gather.vpcf", guardian, 3)
					table.insert(Tanari.WindTemple.GuardianTable, guardian)
				end)
			end
		end)
	end
	if Tanari.WindTemple.GuardianDeath > 4 then
		if Tanari.WindTemple.GuardianDeath%4 == 0 then
			Tanari.WindTemple.GuardianTable = {}
			local fvTable = {Vector(0,1), Vector(1,0), Vector(0,-1), Vector(-1,0)}
			for i = 1, 4, 1 do
				Timers:CreateTimer(i*0.5, function()
					local spawnPos = Tanari.WindTemple.SpiritBoss:GetAbsOrigin()+fvTable[i]*240
					local guardian = Tanari:SpawnWindValleyGuardian(spawnPos, fvTable[i], 0)
					Events:CreateLightningBeam(spawnPos, spawnPos+Vector(0,0,RandomInt(1600,2000)))
					EmitSoundOnLocationWithCaster(spawnPos, "Item.Maelstrom.Chain_Lightning", Events.GameMaster)
					CustomAbilities:QuickAttachParticle("particles/econ/items/earth_spirit/earth_spirit_ti6_boulder/espirit_ti6_rollingboulder_gather.vpcf", guardian, 3)
					table.insert(Tanari.WindTemple.GuardianTable, guardian)
					guardian:SetDeathXP(0)
					guardian.boss = Tanari.WindTemple.SpiritBoss
				end)
			end			
			Timers:CreateTimer(4, function()
				for i = 1, #Tanari.WindTemple.GuardianTable, 1 do
					Tanari.WindTemple.GuardianTable[i]:RemoveModifierByName("modifier_valley_guardian_waiting")
					Tanari.WindTemple.GuardianTable[i]:RemoveModifierByName("modifier_valley_guardian_stone")
					EmitSoundOn("Tanari.WindKeyHolderStoneForm", Tanari.WindTemple.GuardianTable[i])
					CustomAbilities:QuickAttachParticle("particles/econ/items/earth_spirit/earth_spirit_ti6_boulder/espirit_ti6_rollingboulder_gather.vpcf", Tanari.WindTemple.GuardianTable[i], 3)

					CustomAbilities:QuickAttachParticle("particles/radiant_fx/good_barracks_ranged002_destroy.vpcf", Tanari.WindTemple.GuardianTable[i], 3)
					local ability = Tanari.WindTemple.GuardianTable[i]:FindAbilityByName("wind_valley_guardian")
					ability:ApplyDataDrivenModifier(Tanari.WindTemple.GuardianTable[i], Tanari.WindTemple.GuardianTable[i], "modifier_valley_guardian_final", {})

					Events:CreateLightningBeam(Tanari.WindTemple.GuardianTable[i]:GetAbsOrigin(), Tanari.WindTemple.GuardianTable[i]:GetAbsOrigin()+Vector(0,0,RandomInt(1600,2000)))
					EmitSoundOnLocationWithCaster(Tanari.WindTemple.GuardianTable[i]:GetAbsOrigin(), "Item.Maelstrom.Chain_Lightning", Events.GameMaster)
					Tanari.WindTemple.GuardianTable[i]:SetAcquisitionRange(2400)
					Tanari.WindTemple.GuardianTable[i].aggro = true
				end
			end)
		end
	end
end

function spirit_boss_fighting_think(event)
	local caster = event.caster
	if caster.dying then
		return false
	end
	local ability = event.ability
	local radians = (2*math.pi/40)*RandomInt(-5,5)
	local fv = WallPhysics:rotateVector(caster:GetForwardVector(), radians)
	local spellOrigin = caster:GetAbsOrigin()+Vector(0,0,220)+fv*30	
	local info = 
	{
		Ability = ability,
        	EffectName = "particles/econ/items/windrunner/windrunner_ti6/windrunner_spell_powershot_ti6.vpcf",
        	vSpawnOrigin = spellOrigin+Vector(0,0,100),
        	fDistance = 1200,
        	fStartRadius = 150,
        	fEndRadius = 150,
        	Source = caster,
        	StartPosition = "attach_staff_tip",
        	bHasFrontalCone = false,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 7.0,
		bDeleteOnHit = false,
		vVelocity = fv * 620,
		bProvidesVision = false,
	}
	local projectile = ProjectileManager:CreateLinearProjectile(info)		
	local castAbility = caster:FindAbilityByName("wind_spirit_tornado")
	if castAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false )	
		if #enemies > 0 then
			print("CAST TORNADO")
			local castPoint = enemies[1]:GetAbsOrigin()+RandomVector(240)
			local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = castAbility:entindex(),
					Position = castPoint
			 	}
			 
			ExecuteOrderFromTable(newOrder)			
		end
	end
	if caster:GetHealth() < 1000 then
		caster.dying = true
		Tanari.WindTemple.SpiritBossDead = true
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_wind_spirit_boss_dying", {})
		Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(15269, 2816, 490), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
	end
end

function wind_temple_spirit_boss_die_begin(event)
	local ability = event.ability
	local caster = event.caster

	Timers:CreateTimer(0.5, function()
		EmitSoundOn("Tanari.WindTemple.SpiritBossDie1", caster)
		Timers:CreateTimer(1.2, function()
			for i = 1, #Tanari.WindTemple.GuardianTable, 1 do
				Timers:CreateTimer(i*0.5, function()
					Tanari.WindTemple.GuardianTable[i]:ForceKill(false)
				end)
			end
		end)
	end)

	local bossOrigin = caster:GetAbsOrigin()
	for i = 1, 12, 1 do
		Timers:CreateTimer(0.5*i, function()
			RPCItems:RollItemtype(300, caster:GetAbsOrigin(), 1, 0)
		end)
	end
	Timers:CreateTimer(3, function()
	  	local itemName = "item_tanari_spirit_stones_"..Tanari:ConvertDifficultyNumberToName(GameState:GetDifficultyFactor())
	    local stones = RPCItems:CreateConsumable(itemName, "immortal", "tanari_spirit_stones", "consumable", false, "Consumable", itemName.."_desc")
	    CreateItemOnPositionSync(bossOrigin, stones)
	    stones:LaunchLoot(false, RandomInt(100,600), 0.75, bossOrigin)

	    local luck = RandomInt(1,2)
	    if luck == 1 then
	    	RPCItems:RollTanariWindArmor(bossOrigin)
	    elseif luck == 2 then
	    	RPCItems:RollEmeraldSpeedRunners(bossOrigin)
	    end
	end)
	Timers:CreateTimer(4, function()
		local maxRoll = 200
		if GameState:GetDifficultyFactor() == 3 then
			maxRoll = 130
		end
		local requirement = 2 + GameState:GetPlayerPremiumStatusCount()
		local luck = RandomInt(1, maxRoll)
		if luck <= requirement then
			RPCItems:RollSpiritWarriorArcana3(bossOrigin)
		end
	end)
	Timers:CreateTimer(8, function()
		CustomGameEventManager:Send_ServerToAllClients("hide_boss_health", {})
		caster:RemoveModifierByName("modifier_wind_temple_boss_dying")
		Timers:CreateTimer(0.1, function()
			StartAnimation(caster, {duration=8, activity=ACT_DOTA_DIE, rate=1})
			EmitSoundOn("Tanari.WindTemple.SpiritBossDie", caster)
			for i = 1, 120, 1 do
				Timers:CreateTimer(i*0.05, function()
					if IsValidEntity(caster) then
						caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,-5))
					end
				end)
			end
			Timers:CreateTimer(6, function()
				UTIL_Remove(caster)
				Tanari:DefeatSpiritBoss("wind", bossOrigin)
			end)
		end)
	end)
end

function SpiritPortalOut(trigger)
	local hero = trigger.activator
	if Tanari.WindTemple.SpiritBossDead and not hero:HasModifier("modifier_recently_teleported_portal") then
		local portToVector = Vector(7490, 7972)
		Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
	end
end