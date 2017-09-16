
behaviorSystem = {} -- create the global so we can assign to it

function Spawn( entityKeyValues )
	local thinkInterval = (math.random(120) + 70)/100
	thisEntity:SetContextThink( "AIThink", AIThink, thinkInterval )
    behaviorSystem = AICore:CreateBehaviorSystem( { BehaviorNone, BasicSkill} ) 
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
	-- let's not choose this twice in a row
	if currentBehavior == self then return desire end

	self.baseAbility = thisEntity:FindAbilityByName( "naga_siren_mirror_image" )
	
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

AICore.possibleBehaviors = { BehaviorNone, BasicSkill}
