
behaviorSystem = {} -- create the global so we can assign to it

function Spawn( entityKeyValues )
	local thinkInterval = (math.random(20) + 40)/100
	thisEntity:SetContextThink( "AIThink", AIThink, thinkInterval )
	thisEntity.owner = "desert_boss"
	
	local name = thisEntity:GetUnitName()
	print(name)
	if name == "experimenter_jonuous_boss" then
		thisEntity.phase = 0
	elseif name == "experimenter_jonuous_boss_phase_two" then
		thisEntity.phase = 1
	elseif name == "experimenter_jonuous_boss_phase_three" then
		thisEntity.phase = 2
	elseif name == "experimenter_jonuous_boss_phase_four" then
		thisEntity.phase = 3
	end
    behaviorSystem = AICore:CreateBehaviorSystem( { BehaviorNone, DiveSkill, Die, PhaseChange, Army, Missle} ) 

end

function AIThink() -- For some reason AddThinkToEnt doesn't accept member functions
       return behaviorSystem:Think()
end

function CollectRetreatMarkers()

end
POSITIONS_retreat = CollectRetreatMarkers()

--------------------------------------------------------------------------------------------------------


BehaviorNone = {}



function BehaviorNone:Evaluate()
	return 1 -- must return a value > 0, so we have a default
end

function BehaviorNone:Begin()
	self.endTime = GameRules:GetGameTime() + 1

	local enemy =  AICore:RandomEnemyHeroInRange( thisEntity, 10000 )
	
	if enemy and not thisEntity.dead then
		print("order_attack_move")
		self.order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
			Position = enemy:GetOrigin()
		}
	else
		self.order =
		{
			UnitIndex = thisEntity:entindex(),
		}
	end
end

function BehaviorNone:Continue()
	self.endTime = GameRules:GetGameTime() + 0.4
end

--------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------

BasicSkill = {}

function BasicSkill:Evaluate()
	local desire = 0
	print("evaluate basic skill")
	-- let's not choose this twice in a row
	if currentBehavior == self then return desire end

	self.baseAbility = thisEntity:FindAbilityByName( "forest_boss_skill" )
	
	if self.baseAbility and self.baseAbility:IsFullyCastable() and not thisEntity.dead then
		desire = 4
	end
	


	return desire
end

function BasicSkill:Begin()
	print("fire basic")
	self.endTime = GameRules:GetGameTime() + 1
		self.order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.baseAbility:entindex(),
		}
		ExecuteOrderFromTable(self.order)

end

BasicSkill.Continue = BasicSkill.Begin

--------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------

DiveSkill = {}

function DiveSkill:Evaluate()
	local desire = 0
	print("evaluate dive skill")
	-- let's not choose this twice in a row
	if currentBehavior == self then return desire end

	self.diveAbility = thisEntity:FindAbilityByName( "jonuous_teleport" )
	
	if self.diveAbility and self.diveAbility:IsFullyCastable() and not thisEntity.dead then
		desire = 3
	end
	


	return desire
end

function DiveSkill:Begin()
	print("fire teleport")
	self.endTime = GameRules:GetGameTime() + 1
		self.order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.diveAbility:entindex(),
		}
		ExecuteOrderFromTable(self.order)
end

DiveSkill.Continue = DiveSkill.Begin

--------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------

Army = {}

function Army:Evaluate()
	local desire = 0
	print("evaluate Splitter skill")
	-- let's not choose this twice in a row
	if currentBehavior == self then return desire end

	self.SplitterAbility = thisEntity:FindAbilityByName( "desert_boss_army" )
	
	if self.SplitterAbility and self.SplitterAbility:IsFullyCastable() and not thisEntity.dead then
		desire = 8
	end
	


	return desire
end

function Army:Begin()
	print("fire Splitter")
	self.endTime = GameRules:GetGameTime() + 1
		self.order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.SplitterAbility:entindex(),
		}
		ExecuteOrderFromTable(self.order)
end

Army.Continue = Army.Begin

--------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------

Missle = {}

function Missle:Evaluate()
	local desire = 0
	print("evaluate Splitter skill")
	-- let's not choose this twice in a row
	if currentBehavior == self then return desire end

	self.MissleAbility = thisEntity:FindAbilityByName( "desert_boss_missle" )
	
	if self.MissleAbility and self.MissleAbility:IsFullyCastable() and not thisEntity.dead then
		desire = 5
	end
	


	return desire
end

function Missle:Begin()
	local soundTable = {"tinker_tink_ability_heatseekingmissile_02", "tinker_tink_ability_heatseekingmissile_03", "tinker_tink_laugh_04"}
	self.endTime = GameRules:GetGameTime() + 1
		self.order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.MissleAbility:entindex(),
		}
		ExecuteOrderFromTable(self.order)
		EmitSoundOn(soundTable[RandomInt(1, 3)], thisEntity)
end

Missle.Continue = Missle.Begin

--------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------

Die = {}
DEATH_SOUND_TABLE = {"tinker_tink_lose_01", "tinker_tink_lose_04", "tinker_tink_death_12"}
function Die:Evaluate()
	local desire = 0
	print("evaluate Splitter skill")
	-- let's not choose this twice in a row
	if thisEntity:GetHealth() < 30 and not thisEntity.dead and thisEntity.phase == 3 then
   		desire = 15
	end

	return desire
end

function Die:Begin()
	print("Dying")
	self.endTime = GameRules:GetGameTime() + 20
		--ParticleCity(thisEntity)
		thisEntity.dead = true
		Events:updateKillQuest(thisEntity)
		GameState:JonuousDefeat()
		local ability = thisEntity:FindAbilityByName( "cant_die" )
		ability:ApplyDataDrivenModifier(thisEntity, thisEntity, "modifier_dying", {duration = 16})
      	thisEntity:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
      	thisEntity:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
		Events:DesertBossKill(thisEntity)
      	StartAnimation(thisEntity, {duration=6.5, activity=ACT_DOTA_FLAIL, rate=0.8})
      	local sound = DEATH_SOUND_TABLE[RandomInt(1, 3)]
      	EmitGlobalSound(sound)
      	EmitGlobalSound(sound)
      	EmitGlobalSound(sound)
      	Events:EarnKey("desert")
      	CustomGameEventManager:Send_ServerToAllClients("hide_boss_health", {})
      	for i = 1, 5, 1 do
	        Timers:CreateTimer(i+0.5, 
	        function()
	        	StartAnimation(thisEntity, {duration=6-i, activity=ACT_DOTA_FLAIL, rate=0.8})
	        end)
      	end
		Timers:CreateTimer(1.5, function()
			EmitGlobalSound("Loot_Drop_Stinger_Arcana")
			Notifications:TopToAll({text="Act 2 Clear!", duration=8.0})
		end)

        Timers:CreateTimer(6.5, 
        function()
          EmitGlobalSound("tinker_tink_death_05")
          EmitGlobalSound("tinker_tink_death_05")
          StartAnimation(thisEntity, {duration=8.4, activity=ACT_DOTA_DIE, rate=0.25})
         		Timers:CreateTimer(8.3, 
        		function()
        			
        			thisEntity:RemoveSelf()
        		end)
        end)   
end

Die.Continue = Die.Begin

--------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------

PhaseChange = {}
function PhaseChange:Evaluate()
	local desire = 0
	print("evaluate Splitter skill")
	-- let's not choose this twice in a row
	if thisEntity:GetHealth() < 200000 and thisEntity.phase == 0 and not thisEntity.phaseChanging and not thisEntity.dead then
   		desire = 15
   	elseif thisEntity:GetHealth() < 150000 and thisEntity.phase == 1 and not thisEntity.phaseChanging and not thisEntity.dead then
   		desire = 15
   	elseif thisEntity:GetHealth() < 100000 and thisEntity.phase == 2 and not thisEntity.phaseChanging and not thisEntity.dead then
   		desire = 15
	end

	return desire
end

function PhaseChange:Begin()
	self.endTime = GameRules:GetGameTime() + 2
	if thisEntity.phase == 0 then
		print("Phase2")
		StartAnimation(thisEntity, {duration=2, activity=ACT_DOTA_SPAWN, rate=1})
		local teleportAbility = thisEntity:FindAbilityByName( "jonuous_teleport" )
		teleportAbility:ApplyDataDrivenModifier(thisEntity, thisEntity, "modifier_jonuous_phase_shift", {duration = 2.0})
		EmitGlobalSound("tinker_tink_rare_05")
		EmitGlobalSound("tinker_tink_rare_05")
		thisEntity.phaseChanging = true
	    thisEntity.phase = 1
	    local fv = thisEntity:GetForwardVector()
	    local origin = thisEntity:GetAbsOrigin()
	        Timers:CreateTimer(1.8, 
	        function()
	        	UTIL_Remove(thisEntity)
			    local jonuous = CreateUnitByName("experimenter_jonuous_boss_phase_two", origin, true, nil, nil, DOTA_TEAM_NEUTRALS)
			    Events:AdjustBossPower(jonuous, 3, 3, true)
			    jonuous:SetForwardVector(fv)
			    jonuous.phase = 1
			    local ability = jonuous:FindAbilityByName("jonuous_teleport")
			    ability:StartCooldown(4)
	        end)
	elseif thisEntity.phase == 1 then
		print("Phase3")
		StartAnimation(thisEntity, {duration=3.5, activity=ACT_DOTA_SPAWN, rate=0.7})
		local teleportAbility = thisEntity:FindAbilityByName( "jonuous_teleport" )
		teleportAbility:ApplyDataDrivenModifier(thisEntity, thisEntity, "modifier_jonuous_phase_shift", {duration = 3.5})
		EmitGlobalSound("tinker_tink_levelup_12")
		EmitGlobalSound("tinker_tink_levelup_12")
		thisEntity.phaseChanging = true
	    thisEntity.phase = 2
	    local fv = thisEntity:GetForwardVector()
	    local origin = thisEntity:GetAbsOrigin()
	    PhaseChangeSummoning(origin, thisEntity)
	        Timers:CreateTimer(3.3, 
	        function()
	        	UTIL_Remove(thisEntity)
			    local jonuous = CreateUnitByName("experimenter_jonuous_boss_phase_three", origin, true, nil, nil, DOTA_TEAM_NEUTRALS)
			    Events:AdjustBossPower(jonuous, 3, 3, true)
			    jonuous:SetForwardVector(fv)
			    jonuous.phase = 2
			    local ability = jonuous:FindAbilityByName("jonuous_teleport")
			    ability:StartCooldown(4)
	        end)
	elseif thisEntity.phase == 2 then
		print("Phase4")
		StartAnimation(thisEntity, {duration=2, activity=ACT_DOTA_SPAWN, rate=1})
		local teleportAbility = thisEntity:FindAbilityByName( "jonuous_teleport" )
		teleportAbility:ApplyDataDrivenModifier(thisEntity, thisEntity, "modifier_jonuous_phase_shift", {duration = 3.0})
		EmitGlobalSound("tinker_tink_levelup_13")
		EmitGlobalSound("tinker_tink_levelup_13")
		thisEntity.phaseChanging = true
	    thisEntity.phase = 3
	    local fv = thisEntity:GetForwardVector()
	    local origin = thisEntity:GetAbsOrigin()
	        Timers:CreateTimer(2.8, 
	        function()
	        	UTIL_Remove(thisEntity)
			    local jonuous = CreateUnitByName("experimenter_jonuous_boss_phase_four", origin, true, nil, nil, DOTA_TEAM_NEUTRALS)
			    Events:AdjustBossPower(jonuous, 3, 3, true)
			    jonuous:SetForwardVector(fv)
			    jonuous.phase = 3
			    local ability = jonuous:FindAbilityByName("jonuous_teleport")
			    ability:StartCooldown(4)
			   	ability:ApplyDataDrivenModifier(jonuous, jonuous, "modifier_jonuous_final_form", {duration = 99999})
	        end)
    end
end

PhaseChange.Continue = PhaseChange.Begin

function PhaseChangeSummoning(position, jonuous)
	local particleName = "particles/econ/items/tinker/boots_of_travel/teleport_end_bots.vpcf"
	for i = 0, 7, 1 do
		local targetSpot = nil
		if i == 0 then
			targetSpot = position+Vector(500,0,0)
		elseif i == 1 then
			targetSpot = position+Vector(250,250,0)
		elseif i == 2 then
			targetSpot = position+Vector(0,500,0)
		elseif i == 3 then
			targetSpot = position+Vector(-250,250,0)
		elseif i == 4 then
			targetSpot = position+Vector(-500,0,0)
		elseif i == 5 then
			targetSpot = position+Vector(-250,-250,0)
		elseif i == 6 then
			targetSpot = position+Vector(0,-500,0)
		elseif i == 7 then
			targetSpot = position+Vector(250,-250,0)
		end
         local particle = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, jonuous)
         -- local targetSpot = position+RandomVector(500)
          ParticleManager:SetParticleControl(particle,0,targetSpot)
 	        Timers:CreateTimer(3.0+i*4, 
	        function()
		        local soldier = CreateUnitByName("twisted_soldier", targetSpot, true, nil, nil, DOTA_TEAM_NEUTRALS)
		        Events:AdjustDeathXP(soldier)
		        local unit = CreateUnitByName("abomination", targetSpot, true, nil, nil, DOTA_TEAM_NEUTRALS)
		        Events:AdjustDeathXP(unit)
		        local ability = unit:FindAbilityByName("abom_electricity")
		        ability:SetLevel(5)
		        ability:ApplyDataDrivenModifier(unit, unit, "modifier_electric_abom", {duration = 99999})  
		        unit = CreateUnitByName("experimental_minion", targetSpot, true, nil, nil, DOTA_TEAM_NEUTRALS)  
		        Events:AdjustDeathXP(unit)
		        unit = CreateUnitByName("tortured_beast", targetSpot, true, nil, nil, DOTA_TEAM_NEUTRALS)           
		        Events:AdjustDeathXP(unit)
          	end)
    end
end

--------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------




AICore.possibleBehaviors = { BehaviorNone, DiveSkill, Die, PhaseChange, Army, Missle}
