require('heroes/hero_necrolyte/gale_nova')

function a_b(event)
	local caster = event.attacker
    local runeUnit = caster.runeUnit
    local ability = runeUnit:FindAbilityByName("venomort_rune_a_b")
    local abilityLevel = ability:GetLevel()
    local bonusLevel = Runes:GetTotalBonus(runeUnit, "a_b")
    local totalLevel = abilityLevel + bonusLevel
    if totalLevel > 0 then
    	local amount = totalLevel*14
    	caster:GiveMana(amount)
		PopupMana(caster, amount)
    end
end

function a_d_think(event)
	-- local caster = event.caster
	-- local runeUnit = caster.runeUnit
	-- local ability = runeUnit:FindAbilityByName("venomort_rune_a_d")
	-- local abilityLevel = ability:GetLevel()
	-- local bonusLevel = Runes:GetTotalBonus(runeUnit, "a_d")
	-- local totalLevel = abilityLevel + bonusLevel
	-- local origin = caster:GetAbsOrigin()
	-- local baseAbility = caster:GetAbilityByIndex(0)
	-- local baseAbilityLevel = baseAbility:GetLevel()
	-- if totalLevel > 0 then
	-- 	local galeData = {}
	-- 	galeData.caster = caster
	-- 	galeData.ability = caster:FindAbilityByName("gale_nova")
	-- 	galeData.a_d_amp = totalLevel*0.025
	-- 	begin_gale_nova(galeData)
	-- end
end

function a_d_create_nova(location, caster, abilityLevel, runeUnit, ability, totalLevel)
	print('launch a_a_nova')
    local dummy = CreateUnitByName("npc_dummy_unit", location, true, caster, caster, caster:GetTeamNumber())
    dummy.owner = caster:GetPlayerOwnerID()
    dummy:AddAbility("gale_nova")
    dummy:NoHealthBar()
    dummy:AddAbility("dummy_unit")
    dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
    dummy.caster = caster
    local proc = dummy:FindAbilityByName("gale_nova")
    proc:SetLevel(abilityLevel)
    proc.a_d_level = totalLevel
	local order =
	{
		UnitIndex = dummy:GetEntityIndex(),
		OrderType =	DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = proc:GetEntityIndex(),
		Queue = true
	}
    ExecuteOrderFromTable(order)
      Timers:CreateTimer(10,
      function()
        UTIL_Remove(dummy)
      end)
end

function b_c(event)
	local caster = event.attacker
	local runeUnit = caster.runeUnit2
	local ability = runeUnit:FindAbilityByName("venomort_rune_b_c")
	local abilityLevel = ability:GetLevel()
	local bonusLevel = Runes:GetTotalBonus(runeUnit, "b_c")
	local totalLevel = abilityLevel + bonusLevel
	local target = event.target

	caster.d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "venomort")

	local damage = 435*totalLevel + 105
	EmitSoundOn("hero_viper.projectileImpact", target)

	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_POISON, RPC_ELEMENT_NONE)


		
end

function b_a_apply(event)
	local caster = event.caster
	local attacker = event.attacker
	if not attacker:HasModifier("modifier_venomort_rune_b_a_immune") then
		local b_a_level = Runes:GetTotalRuneLevel(caster, 2, "b_a", "venomort")
		if b_a_level > 0 then
			local ability = event.ability

			local totalLevel = b_a_level
			local duration = 0.5 + totalLevel*0.1
			ability:ApplyDataDrivenModifier(caster, attacker, "modifier_venomort_rune_b_a_confuse", {duration = duration})
			ability:ApplyDataDrivenModifier(caster, attacker, "modifier_venomort_rune_b_a_immune", {duration = duration + 6})
		end
	end
end

function b_a_confuse(event)
	local caster = event.target
	local position = caster:GetAbsOrigin()
	local fv = caster:GetForwardVector()
	local randomPosition = position+RandomVector(1000)
	caster:MoveToPosition( randomPosition )
end

function b_a_confuse_end(event)
	local caster = event.target
	caster:Stop()
end

function venomort_attack_land(event)
	local caster = event.attacker
	local d_c_level = Runes:GetTotalRuneLevel(caster, 4, "d_c", "venomort")
	if d_c_level > 0 then
		local d_c_ability = caster.runeUnit4:FindAbilityByName("venomort_rune_d_c")
		local d_c_duration = Filters:GetAdjustedBuffDuration(caster, 1.5, false)
		d_c_ability:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_venomort_rune_d_c_visible", {duration = d_c_duration})
		local new_stack = caster:GetModifierStackCount( "modifier_venomort_rune_d_c_visible", d_c_ability ) + 1
		new_stack = math.min(50, new_stack)
		caster:SetModifierStackCount( "modifier_venomort_rune_d_c_visible",  d_c_ability, new_stack )

		d_c_ability:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_venomort_rune_d_c_invisible", {duration = d_c_duration + 1})
		caster:SetModifierStackCount( "modifier_venomort_rune_d_c_invisible",  d_c_ability, new_stack*d_c_level )

		d_c_ability.last_stack = new_stack
		d_c_ability.d_c_level = d_c_level
	end
end

function d_c_duration_end(event)
	local ability = event.ability
	local target = event.target
	local caster = event.caster
	local new_stack = ability.last_stack - 1
	ability.last_stack = new_stack
	if new_stack > 0 then
		local d_c_duration = Filters:GetAdjustedBuffDuration(caster, 1.5, false)

		ability:ApplyDataDrivenModifier(caster, target, "modifier_venomort_rune_d_c_visible", {duration = d_c_duration})
		target:SetModifierStackCount( "modifier_venomort_rune_d_c_visible",  ability, new_stack )

		ability:ApplyDataDrivenModifier(caster, target, "modifier_venomort_rune_d_c_invisible", {duration = d_c_duration + 1})
		target:SetModifierStackCount( "modifier_venomort_rune_d_c_invisible",  ability, new_stack*ability.d_c_level )
	else
		target:RemoveModifierByName("modifier_venomort_rune_d_c_invisible")	
	end	
end