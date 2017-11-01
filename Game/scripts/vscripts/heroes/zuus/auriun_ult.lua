function channel_succeed(event)
	local caster = event.caster
	local ability = event.ability
	StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_CAST_ABILITY_4, rate=1})
	local allAllies = CustomAbilities:GetAllAlliedHeroes(caster)
	local b_d_level = Runes:GetTotalRuneLevel(caster, 2, "b_d", "auriun")
	local c_d_level = Runes:GetTotalRuneLevel(caster, 3, "c_d", "auriun")
	local d_d_level = Runes:GetTotalRuneLevel(caster, 4, "d_d", "auriun")

	local ultEffectDuration = Filters:GetAdjustedBuffDuration(caster, 3.1, false)
	for i = 1, #allAllies, 1 do
		if not allAllies[i]:IsAlive() then
			allAllies[i].revive = true
			local rezPosition = allAllies[i]:GetAbsOrigin()
			allAllies[i]:RespawnHero(false, false)
			allAllies[i]:SetAbsOrigin(rezPosition)
			
			allAllies[i]:SetHealth(allAllies[i]:GetMaxHealth()*0.4)
			ability:ApplyDataDrivenModifier(caster, allAllies[i], "modifier_auriun_ult_effect", {duration = ultEffectDuration})
			-- if b_d_level > 0 then
			-- 	b_d_effect(caster, allAllies[i], b_d_level)
			-- end
			-- if c_d_level > 0 then
			-- 	c_d_effect(caster, allAllies[i], c_d_level)
			-- end
			if caster:HasModifier("modifier_auriun_glyph_1_1") then
				local glyph_duration = Filters:GetAdjustedBuffDuration(caster, 4, false)
				ability:ApplyDataDrivenModifier(caster, allAllies[i], "modifier_auriun_glyph_1_1_effect", {duration = glyph_duration})
			end
		end
	end
	local allies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, event.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
	if #allies > 0 then
		for _,ally in pairs(allies) do
			if ally:GetUnitName() == "phoenix_nest_egg" then
				ability:ApplyDataDrivenModifier(caster, ally, "modifier_auriun_ult_effect_phoenix", {duration = ultEffectDuration})	
			else
				ability:ApplyDataDrivenModifier(caster, ally, "modifier_auriun_ult_effect", {duration = ultEffectDuration})	
			end
			-- if b_d_level > 0 then
			-- 	b_d_effect(caster, ally, b_d_level)
			-- end
			-- if c_d_level > 0 then
			-- 	c_d_effect(caster, ally, c_d_level)
			-- end
			if d_d_level > 0 then
				local shieldStacks = Runes:Procs(d_d_level, 25, 1)
				if shieldStacks > 0 then
					local shieldAbility = nil
					if caster:HasAbility("heavens_shield") then
						shieldAbility = caster:FindAbilityByName("heavens_shield")
					elseif caster:HasAbility("auriun_shadow_trap") then
						shieldAbility = caster:FindAbilityByName("auriun_shadow_trap")
					elseif caster:HasAbility("auriun_aoe_shield") then
						shieldAbility = caster:FindAbilityByName("auriun_aoe_shield")
					end
					d_d_apply_shield(caster, shieldAbility, ally, shieldStacks)
				end
			end
			if caster:HasModifier("modifier_auriun_glyph_1_1") then
				local glyph_duration = Filters:GetAdjustedBuffDuration(caster, 4, false)
				ability:ApplyDataDrivenModifier(caster, ally, "modifier_auriun_glyph_1_1_effect", {duration = glyph_duration})
			end
		end
	end
	Filters:CastSkillArguments(4, caster)
end

function channel_initialize(event)
	local caster = event.caster
	local ability = event.ability
	ability.initialized = 1
end


function auriun_channel_think(event)
	local caster = event.caster
	local ability = event.ability
	print("CHANNEL THINK??")
	if ability.initialized == 1 then
		print("SOUND?")
		ability.initialized = 0
		StartSoundEvent("Auriun.UltFinish", caster)
	end
end

function channel_interrupt(event)
	local caster = event.caster
	StopSoundEvent("Auriun.UltFinish", caster)
end

function passive_think(event)
	local caster = event.caster
	local ability = event.ability
	local a_d_level = Runes:GetTotalRuneLevel(caster, 1, "a_d", "auriun")
	if a_d_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_auriun_rune_a_d", {})
		local damageGain = math.floor(caster:GetIntellect()*0.05*a_d_level)
		caster:SetModifierStackCount( "modifier_auriun_rune_a_d", ability, damageGain)
	else
		caster:RemoveModifierByName("modifier_auriun_rune_a_d")
	end
end

function b_d_effect(caster, target, b_d_level)
	local runeUnit = caster.runeUnit2
	local runeAbility = runeUnit:FindAbilityByName("auriun_rune_b_d")
	local b_d_duration = Filters:GetAdjustedBuffDuration(caster, 12, false)
	runeAbility:ApplyDataDrivenModifier(runeUnit, target, "modifier_auriun_rune_b_d_visible", {duration = b_d_duration})
	local armorGain = 0.01*(target:GetMaxHealth()/100)*b_d_level
	local armorStacks = math.ceil(armorGain)
	runeAbility:ApplyDataDrivenModifier(runeUnit, target, "modifier_auriun_rune_b_d_effect", {duration = b_d_duration})
	target:SetModifierStackCount( "modifier_auriun_rune_b_d_effect", runeAbility, armorStacks)
end

function c_d_effect(caster, target, c_d_level)
	print("c_d_effect?")
	if caster:GetEntityIndex() == target:GetEntityIndex() then
	else
		print("IN BLOCK")
		local runeUnit = caster.runeUnit3
		local runeAbility = runeUnit:FindAbilityByName("auriun_rune_c_d")

		local c_d_duration = Filters:GetAdjustedBuffDuration(caster, 20, false)

		runeAbility:ApplyDataDrivenModifier(runeUnit, target, "modifier_auriun_rune_c_d_visible", {duration = c_d_duration})
		local agilityStacks = caster:GetAgility()*0.005*c_d_level
		local strengthStacks = caster:GetStrength()*0.005*c_d_level
		runeAbility:ApplyDataDrivenModifier(runeUnit, target, "modifier_auriun_rune_c_d_effect_agility", {duration = c_d_duration})
		target:SetModifierStackCount( "modifier_auriun_rune_c_d_effect_agility", runeAbility, agilityStacks)
		runeAbility:ApplyDataDrivenModifier(runeUnit, target, "modifier_auriun_rune_c_d_effect_strength", {duration = c_d_duration})
		target:SetModifierStackCount( "modifier_auriun_rune_c_d_effect_strength", runeAbility, strengthStacks)
	end
end

function d_d_apply_shield(caster, ability, target, shieldStacks)
	print("shield?"..shieldStacks)

	local b_a_level = Runes:GetTotalRuneLevel(caster, 2, "b_a", "auriun")
	local duration = 9+(b_a_level*0.3)
	duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_heavens_shield", {duration = duration})
	local currentStacks = target:GetModifierStackCount("modifier_heavens_shield", caster)
	if shieldStacks > currentStacks then
		target:SetModifierStackCount( "modifier_heavens_shield", ability, shieldStacks)
	end

	ability.a_a_level = Runes:GetTotalRuneLevel(caster, 1, "a_a", "auriun")

	local particleName = "particles/units/heroes/hero_oracle/white_mage_healheal_core.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	Timers:CreateTimer(0.5, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	end) 
	-- Filters:CastSkillArguments(1, caster)

	local d_a_level = Runes:GetTotalRuneLevel(caster, 4, "d_a", "auriun")
	if d_a_level > 0 then
		local runeAbility = caster.runeUnit4:FindAbilityByName("auriun_rune_d_a")
		runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, target, "modifier_auriun_rune_d_a_effect", {duration = duration})
		target:SetModifierStackCount( "modifier_auriun_rune_d_a_effect", runeAbility, d_a_level)
		target.auriun_d_a_ability = runeAbility
		
	end
end