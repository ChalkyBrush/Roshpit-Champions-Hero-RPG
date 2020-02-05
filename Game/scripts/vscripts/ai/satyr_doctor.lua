function Spawn(entityKeyValues)

	local ability = thisEntity:FindAbilityByName("satyr_restoration")
	ability:SetLevel(4)
	local order =
	{
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TOGGLE,
		AbilityIndex = ability:entindex(),
		Queue = true
	}
	ExecuteOrderFromTable(order)

end

