function GhostBlastThink(event)
	local caster = event.caster
	local point = caster:GetAbsOrigin()
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), point, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			local ghostBlast = caster:FindAbilityByName("ghost_blast")
			local order =
			{
				UnitIndex = caster:GetEntityIndex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = ghostBlast:GetEntityIndex(),
				Position = enemy:GetAbsOrigin(),
				Queue = false
			}
		    ExecuteOrderFromTable(order)
		end
	end 	
end

function GhostDie(event)
	local caster = event.caster
	local randomInt = RandomInt(1, 15)
	if randomInt == 7 then
		RPCItems:RollGhostSlippers(caster:GetAbsOrigin())
	end
end