function begin_strike(keys)
    caster = keys.caster
    ability = keys.ability
    
    caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
    caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)


    for i = 0, 19, 1 do
		  delay = i*0.05
	      Timers:CreateTimer(delay,
	      function()
	    	  if (i<10) then
	    	  	newPosition = caster:GetOrigin() + Vector(0,0,300-i*10)
	    	  else
	    	  	newPosition = caster:GetOrigin() + Vector(0,0,-210-(i-10)*10)
	    	  end
	        caster:SetOrigin(newPosition)
	        if i == 18 then
	        	caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
	        	create_rings(ability, caster)
	        	caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
	        	rune_r_3(caster)
	        end
	      end)
	end
end

function create_rings(ability, caster)
	abilityLevel = ability:GetLevel()
	point = caster:GetAbsOrigin()
	for i =0, abilityLevel + 3, 1 do
		Timers:CreateTimer(i*0.2,
		function()
			create_individual_ring(ability, caster, point)
		end)
	end

end

function create_individual_ring(ability, caster, point)

  	local dummy = CreateUnitByName("npc_dummy_unit", point, true, caster, caster, caster:GetTeamNumber())
  	dummy.owner = caster:GetPlayerOwnerID()
  	dummy:AddAbility("strike_rings")
  	dummy:NoHealthBar()
  	dummy:AddAbility("dummy_unit")
  	dummy:FindAbilityByName("dummy_unit"):SetLevel(1)

  	local blast = dummy:FindAbilityByName("strike_rings")
  	blast:SetLevel(ability:GetLevel())
	local order =
	{
		UnitIndex = dummy:GetEntityIndex(),
		OrderType =	DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = blast:GetEntityIndex(),
		Queue = true
	}
	ExecuteOrderFromTable(order)
	  Timers:CreateTimer(5, -- Start this timer 10 game-time seconds later
	  function()
		UTIL_Remove(dummy)
	  end)
end


function rune_r_3(caster)
    local runeUnit = caster.runeUnit3
    local ability = runeUnit:FindAbilityByName("voltex_rune_r_3")
    local abilityLevel = ability:GetLevel()
    local bonusLevel = Runes:GetTotalBonus(runeUnit, "r_3")
    local totalLevel = abilityLevel + bonusLevel
    	if totalLevel > 0 then
    		EmitSoundOn("DOTA_Item.BlackKingBar.Activate", caster)
    		local immune_duration = 1 + totalLevel*0.35
    		immune_duration = Filters:GetAdjustedBuffDuration(caster, immune_duration, false)
    		ability:ApplyDataDrivenModifier(runeUnit, caster, "modifier_voltex_rune_r_3_immunity", {duration = immune_duration})
    	end
end
