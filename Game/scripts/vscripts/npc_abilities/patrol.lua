function ChestPatrolThink1(event)
	caster = event.caster
	point = Vector(-6800, 4000)
	caster:MoveToPosition(point)
end

function ChestPatrolThink2(event)
	caster = event.caster
	ability = event.ability
	point = Vector(-5800, 4600)

	caster:MoveToPosition(point)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_chest_patrol_point_two", {})
end

function ChestPatrolThink3(event)
	caster = event.caster
	ability = event.ability
	point = Vector(-5800, 5400)

	caster:MoveToPosition(point)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_chest_patrol_point_three", {})
end

function ChestPatrolThink4(event)
	caster = event.caster
	ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_chest_patrol_point_one", {})
end

function OwlPatrolThink1(event)
	caster = event.caster
	point = Vector(-14462, 14314)
	caster:MoveToPosition(point)
end

function OwlPatrolThink2(event)
	ability = event.ability
	caster = event.caster
	point = Vector(-13504, 14528)
	caster:MoveToPosition(point)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_owl_patrol_point_two", {})
end

function OwlPatrolThink3(event)
	caster = event.caster
	ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_owl_patrol_point_one", {})
end

function patrol_think(event)
	local caster = event.caster
	local ability = event.ability
	local slowPercentage = caster.patrolSlow
	if caster.patrolLock then
		return false
	end
	if not caster.patrolImmunity then
		if caster.aggro then
			caster:RemoveModifierByName("modifier_patrol_slow")
			caster:Stop()
			caster:RemoveAbility("monster_patrol")
			caster:RemoveModifierByName("modifier_patrol_ai")
			return nil
		end
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_patrol_slow", {})
	caster:SetModifierStackCount("modifier_patrol_slow", caster, slowPercentage)
	if not caster.patrolPhase then
		caster.patrolPhase = 1
	end
	if caster.patrolPhase % caster.phaseIntervals == 0 then
		caster:MoveToPosition(caster.patrolPositionTable[caster.patrolPhase / caster.phaseIntervals] + RandomVector(RandomInt(1, caster.patrolPointRandom)))
	end
	caster.patrolPhase = caster.patrolPhase + 1
	if caster.patrolPhase > #caster.patrolPositionTable * caster.phaseIntervals then
		caster.patrolPhase = 1
	end
end

function patrol_take_damage(event)
	local caster = event.caster
	if not caster.patrolEnd then
		caster.patrolEnd = true
		caster:Stop()
	end
end
