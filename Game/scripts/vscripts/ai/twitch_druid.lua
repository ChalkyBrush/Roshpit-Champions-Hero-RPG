
behaviorSystem = {} -- create the global so we can assign to it

function Spawn( entityKeyValues )
	local thinkInterval = (math.random(120) + 70)/100
	thisEntity:SetContextThink( "AIThink", AIThink, thinkInterval )
    behaviorSystem = AICore:CreateBehaviorSystem( { BehaviorNone, BehaviorEarthbind} ) 
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

BehaviorEarthbind = {}

function BehaviorEarthbind:Evaluate()
	local desire = 0
	
	-- let's not choose this twice in a row
	if currentBehavior == self then return desire end

	self.earthbindAbility = thisEntity:FindAbilityByName( "meepo_earthbind" )
	
	if self.earthbindAbility and self.earthbindAbility:IsFullyCastable() then
		self.target = AICore:RandomEnemyHeroInRange( thisEntity, self.earthbindAbility:GetCastRange() )
		if self.target then
			desire = 3
		end
	end
	


	return desire
end

function BehaviorEarthbind:Begin()
	self.endTime = GameRules:GetGameTime() + 1
	if self.target then
		local forwardVector = self.target:GetForwardVector() * 450
		local targetPoint = self.target:GetOrigin() + forwardVector
		
		self.order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = self.earthbindAbility:entindex(),
			Position = targetPoint
		}
	end

end

BehaviorEarthbind.Continue = BehaviorEarthbind.Begin

--------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------

AICore.possibleBehaviors = { BehaviorNone, BehaviorEarthbind}
