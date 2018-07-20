function initialize_flash_heal(event)
	local caster = event.caster
	-- local player = caster:GetPlayerOwner()
	local ability = event.ability
	-- -- CustomGameEventManager:Send_ServerToPlayer(player, "flash_heal", {auriun = caster:GetEntityIndex()} )
	-- EmitSoundOn("Hero_Zuus.Attack", caster)
	-- local particleName = "particles/units/heroes/hero_oracle/holy_heal_heal_core.vpcf"
	-- local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	-- ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)

	-- Timers:CreateTimer(0.5, function() 
	--   ParticleManager:DestroyParticle( pfx, false )
	-- end) 
	-- --SHIELD SOUND: "Auriun.HeavensShield"
	-- --RUNE 1: SHADOW BOMB. MAKE SMALL AOE AT CURSOR POSITION
	-- --"Auriun.ShadowFlare"
	-- ability.a_b_level = Runes:GetTotalRuneLevel(caster, 1, "a_b", "auriun")
	-- ability.b_b_level = Runes:GetTotalRuneLevel(caster, 2, "b_b", "auriun")
	-- ability.d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "auriun")
	-- ability.d_b_ability = caster.runeUnit4:FindAbilityByName("auriun_rune_d_b")
	if ability.too_far_away then
		ability.too_far_away = false
		order = {
		UnitIndex = caster:GetEntityIndex(), 
 		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
 		AbilityIndex = ability:GetEntityIndex(),
 		Position = ability.pos,
	}
		caster:Stop()
		ExecuteOrderFromTable(order)
	end
end

function cast_flash_heal(event)
	local caster = event.caster
	local ability = event.ability
	ability.casted = true
end

function d_b_apply(caster, enemy, d_b_level, d_b_ability)
	if d_b_level > 0 then
	    d_b_ability:ApplyDataDrivenModifier(caster.runeUnit4, enemy, "modifier_auriun_rune_d_b_effect_visible", {duration = 7})
	    local current_stacks = enemy:GetModifierStackCount( "modifier_auriun_rune_d_b_effect_visible", d_b_ability )
	    local new_stacks = math.min(current_stacks + 1, 5)
	    enemy:SetModifierStackCount( "modifier_auriun_rune_d_b_effect_visible", d_b_ability, new_stacks )

	    d_b_ability:ApplyDataDrivenModifier(caster.runeUnit4, enemy, "modifier_auriun_rune_d_b_effect_invisible", {duration = 7})
	    enemy:SetModifierStackCount( "modifier_auriun_rune_d_b_effect_invisible", d_b_ability, new_stacks*d_b_level )
	end
	--"modifier_auriun_rune_d_b_effect_visible"
end

function b_b_amp(amount, caster, ability)
	local ampPerTenInt = 0.0006
	local adjustment = (caster:GetIntellect()/10)*ampPerTenInt*ability.b_b_level
	local adjustedAmount = amount*(1+adjustment)
	return math.ceil(adjustedAmount)
end

function c_b_effect(caster, ability, target, healAmount)
	local runeUnit = caster.runeUnit3
	local runeAbility = runeUnit:FindAbilityByName("auriun_rune_c_b")
	local c_b_level = Runes:GetTotalRuneLevel(caster, 3, "c_b", "auriun")
	if c_b_level > 0 then 
		ability.auriun_c_b_heal = c_b_level*0.005*healAmount
		local duration = Filters:GetAdjustedBuffDuration(caster, 3, false)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_auriun_c_b_heal", {duration = duration})
	end
	-- local manaSpent = ability:GetManaCost(ability:GetLevel())
	-- if caster:HasModifier("modifier_cerulean_high_guard") then
	-- 	manaSpent = manaSpent + ability:GetManaCost(ability:GetLevel())*4
	-- end
	-- if caster:HasModifier("modifier_iron_colossus") then
	-- 	manaSpent = manaSpent + 2000
	-- end
	-- local c_b_percentage = 0.02
	-- local damageBuff = manaSpent*c_b_percentage*c_b_level

	-- local currentStacks = target:GetModifierStackCount( "modifier_auriun_rune_c_b_visible", ability )
	-- currentStacks = math.min(currentStacks+1, 5)

	-- local c_b_duration = Filters:GetAdjustedBuffDuration(caster, 7, false)
	-- runeAbility:ApplyDataDrivenModifier(runeUnit, target, "modifier_auriun_rune_c_b_visible", {duration = c_b_duration})
	-- runeAbility:ApplyDataDrivenModifier(runeUnit, target, "modifier_auriun_rune_c_b_effect", {duration = c_b_duration})

	-- target:SetModifierStackCount( "modifier_auriun_rune_c_b_visible", runeAbility, currentStacks)
	-- target:SetModifierStackCount( "modifier_auriun_rune_c_b_effect", runeAbility, math.floor(currentStacks*damageBuff))

	--"modifier_auriun_rune_c_b_visible"
	--"modifier_auriun_rune_c_b_effect"
end

function c_b_heal_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local healAmount = ability.auriun_c_b_heal
	Filters:ApplyHeal(caster, target, healAmount, true)
end

function flash_heal_particle(caster,target)
	local particleName = "particles/units/heroes/hero_oracle/flash_healheal.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	Timers:CreateTimer(0.7, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	end) 

	
end