
behaviorSystem = {} -- create the global so we can assign to it

function Spawn( entityKeyValues )
	local thinkInterval = (math.random(20) + 40)/100
	thisEntity:SetContextThink( "AIThink", AIThink, thinkInterval )
	thisEntity.owner = "forest_boss"
    behaviorSystem = AICore:CreateBehaviorSystem( { BehaviorNone, BasicSkill, DiveSkill, SplitterSkill, Die} ) 
end

function AIThink() -- For some reason AddThinkToEnt doesn't accept member functions
       return behaviorSystem:Think()
end

function CollectRetreatMarkers()

end
POSITIONS_retreat = CollectRetreatMarkers()

----------------------------------------------------


BehaviorNone = {}



function BehaviorNone:Evaluate()
	return 1 -- must return a value > 0, so we have a default
end

function BehaviorNone:Begin()
	self.endTime = GameRules:GetGameTime() + 1

	local enemy =  AICore:RandomEnemyHeroInRange( thisEntity, 10000 )
	
	if enemy and not thisEntity.dead then
		--print("order_attack_move")
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

----------------------------------------------------


----------------------------------------------------

BasicSkill = {}

function BasicSkill:Evaluate()
	local desire = 0
	--print("evaluate basic skill")
	-- let's not choose this twice in a row
	if currentBehavior == self then return desire end

	self.baseAbility = thisEntity:FindAbilityByName( "forest_boss_skill" )
	
	if self.baseAbility and self.baseAbility:IsFullyCastable() and not thisEntity.dead then
		desire = 4
	end
	


	return desire
end

function BasicSkill:Begin()
	--print("fire basic")
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

----------------------------------------------------


----------------------------------------------------

DiveSkill = {}

function DiveSkill:Evaluate()
	local desire = 0
	--print("evaluate dive skill")
	-- let's not choose this twice in a row
	if currentBehavior == self then return desire end

	self.diveAbility = thisEntity:FindAbilityByName( "forest_boss_dive" )
	
	if self.diveAbility and self.diveAbility:IsFullyCastable() and not thisEntity.dead then
		desire = 3
	end
	


	return desire
end

function DiveSkill:Begin()
	--print("fire dive")
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

----------------------------------------------------


----------------------------------------------------

SplitterSkill = {}

function SplitterSkill:Evaluate()
	local desire = 0
	--print("evaluate Splitter skill")
	-- let's not choose this twice in a row
	if currentBehavior == self then return desire end

	self.SplitterAbility = thisEntity:FindAbilityByName( "forest_boss_splitter" )
	
	if self.SplitterAbility and self.SplitterAbility:IsFullyCastable() and not thisEntity.dead then
		desire = 8
	end
	


	return desire
end

function SplitterSkill:Begin()
	--print("fire Splitter")
	self.endTime = GameRules:GetGameTime() + 1
		self.order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.SplitterAbility:entindex(),
		}
		ExecuteOrderFromTable(self.order)
end

SplitterSkill.Continue = SplitterSkill.Begin

----------------------------------------------------


----------------------------------------------------

Die = {}
DEATH_SOUND_TABLE = {"nevermore_nev_arc_death_12"}
function Die:Evaluate()
	local desire = 0
	--print("evaluate Splitter skill")
	-- let's not choose this twice in a row
	if thisEntity:GetHealth() < 20 and not thisEntity.dead then
   		desire = 15
	end

	return desire
end

function Die:Begin()
	--print("Dying")
	self.endTime = GameRules:GetGameTime() + 13
		--ParticleCity(thisEntity)
		thisEntity.dead = true
		CustomGameEventManager:Send_ServerToAllClients("hide_boss_health", {bossId = tostring(thisEntity)})
		Events:updateKillQuest(thisEntity)
		local ability = thisEntity:FindAbilityByName( "cant_die" )
		ability:ApplyDataDrivenModifier(thisEntity, thisEntity, "modifier_dying", {duration = 13})
      	thisEntity:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
      	thisEntity:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
		Events:ForestBossKill(thisEntity)
      	StartAnimation(thisEntity, {duration=6.5, activity=ACT_DOTA_FLAIL, rate=0.8})
      	local sound = DEATH_SOUND_TABLE[1]
      	EmitGlobalSound(sound)
      	EmitGlobalSound(sound)
      	EmitGlobalSound(sound)
      	GameState:NeverlordDefeat()
      	Events:EarnKey("forest")
        Timers:CreateTimer(6.5, 
        function()
          EmitGlobalSound("nevermore_nev_ability_requiem_07")
          StartAnimation(thisEntity, {duration=6.1, activity=ACT_DOTA_DIE, rate=0.25})
         		Timers:CreateTimer(6.1, 
        		function()
        			
        			thisEntity:RemoveSelf()
        		end)
        end)
		Timers:CreateTimer(1.5, function()
			EmitGlobalSound("Loot_Drop_Stinger_Arcana")
			Notifications:TopToAll({text="Act 1 Clear!", duration=8.0})
		end)   
end

Die.Continue = Die.Begin

----------------------------------------------------


----------------------------------------------------




AICore.possibleBehaviors = { BehaviorNone, BasicSkill, DiveSkill, SplitterSkill, Die}
