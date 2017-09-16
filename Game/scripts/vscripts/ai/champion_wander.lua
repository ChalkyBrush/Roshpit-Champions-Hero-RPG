--[[
Pudge AI
]]


behaviorSystem = {} -- create the global so we can assign to it

function Spawn( entityKeyValues )
	local thinkInterval = (math.random(270) + 70)/100
	thisEntity:SetContextThink( "AIThink", AIThink, thinkInterval )
    behaviorSystem = AICore:CreateBehaviorSystem( { BehaviorNone, BehaviorWander} ) 
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
	
	local ancient =  Entities:FindByName( nil, "dota_goodguys_fort" )
	
	if ancient then
		self.order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
			Position = ancient:GetOrigin()
		}
	else
		self.order =
		{
			UnitIndex = thisEntity:entindex(),
		}
	end
end

function BehaviorNone:Continue()
	self.endTime = GameRules:GetGameTime() + 1
end

--------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------

BehaviorWander = {}

function BehaviorWander:Evaluate()
	print("Evaluating Wander")
	local desire = 0
	local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
	if #enemies == 0 then
		desire = 5
	end
	return desire
end

function BehaviorWander:Begin()

	self.endTime = GameRules:GetGameTime() + 3
	
	
	local targetPoint = thisEntity:GetOrigin() + RandomVector( 600 )
	thisEntity:MoveToPosition( targetPoint )
end

BehaviorWander.Continue = BehaviorWander.Begin

--------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------

AICore.possibleBehaviors = { BehaviorNone, BehaviorWander}
