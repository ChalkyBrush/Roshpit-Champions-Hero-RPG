--[[
Pudge AI
]]


behaviorSystem = {} -- create the global so we can assign to it

function Spawn( entityKeyValues )
	local thinkInterval = (math.random(270) + 70)/100
	thisEntity:SetContextThink( "AIThink", AIThink, thinkInterval )
    behaviorSystem = AICore:CreateBehaviorSystem( { BehaviorNone, BehaviorThrowWave, BehaviorFlee} ) 
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

----------------------------------------------------


----------------------------------------------------

BehaviorFlee = {}

function BehaviorFlee:Evaluate()
	local desire = 0
	local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
	if #enemies > 0 then
		desire = 5
	end
	return desire
end

function BehaviorFlee:Begin()
	self.vortexAbility = thisEntity:FindAbilityByName( "ancient_apparition_ice_vortex" )
	if self.vortexAbility and self.vortexAbility:IsFullyCastable() then
		vortexPoint = thisEntity:GetAbsOrigin()
		self.order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = self.vortexAbility:entindex(),
			Position = vortexPoint
		}
		self.endTime = GameRules:GetGameTime() + 1
	else
		self.endTime = GameRules:GetGameTime() + 3
	end
	
	
	local targetPoint = thisEntity:GetOrigin() + RandomVector(400)
	thisEntity:MoveToPosition( targetPoint )
end

BehaviorFlee.Continue = BehaviorFlee.Begin

----------------------------------------------------


----------------------------------------------------

BehaviorThrowWave = {}

function BehaviorThrowWave:Evaluate()
	local desire = 0

	-- let's not choose this twice in a row
	if currentBehavior == self then return desire end

	self.hookAbility = thisEntity:FindAbilityByName( "vengefulspirit_wave_of_terror" )
	
	if self.hookAbility and self.hookAbility:IsFullyCastable() then
		self.target = AICore:RandomEnemyHeroInRange( thisEntity, self.hookAbility:GetCastRange() )
		if self.target then
			desire = 4

		end
	end
	


	return desire
end

function BehaviorThrowWave:Begin()
	self.endTime = GameRules:GetGameTime() + 1
	if self.target then
		self.target = AICore:RandomEnemyHeroInRange( thisEntity, self.hookAbility:GetCastRange() )
		local targetPoint = self.target:GetOrigin() + RandomVector( 100 )
		
		self.order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = self.hookAbility:entindex(),
			Position = targetPoint
		}
	end

end

BehaviorThrowWave.Continue = BehaviorThrowWave.Begin

----------------------------------------------------


----------------------------------------------------

AICore.possibleBehaviors = { BehaviorNone, BehaviorThrowWave, BehaviorFlee}
