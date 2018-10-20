LinkLuaModifier("modifier_conjuror_attack_sound_translate", "modifiers/conjuror/modifier_conjuror_attack_sound_translate", LUA_MODIFIER_MOTION_NONE)

function channel_start(event)
	local caster = event.caster
	local ability = event.ability
	if caster:GetUnitName() == "npc_dota_hero_invoker" then
		EmitSoundOn("invoker_invo_laugh_03", caster)
	elseif caster:GetUnitName() == "conjuror_elemental_deity_summon" then
		EmitSoundOn("Conjuror.ElementalDeity.Cast", caster)
		StartAnimation(caster, {duration=2.5, activity=ACT_DOTA_FLAIL, rate=2.0})
	end
	caster.q_4_level = Runes:GetTotalRuneLevel(caster, 4, "q_4", "conjuror")
end

function begin_call(event)
	local caster = event.caster
	local ability = event.ability
	if caster:GetUnitName() == "npc_dota_hero_invoker" then
		local earth = false
		local fire = false
		local shadow = false
		EmitSoundOn("invoker_invo_win_01", caster)
		EmitSoundOn("invoker_invo_win_01", caster)
		ability.r_4_level = Runes:GetTotalRuneLevel(caster, 4, "r_4", "conjuror")
		local growCount = 0
	    if caster.earthAspect then
	    	earth = true
	    	growCount = growCount + 1
	    end
	    if caster.fireAspect then
	    	fire = true
	    	growCount = growCount + 1
	    end
	    if caster.shadowAspect then
	 		shadow = true
	 		growCount = growCount + 1
	    end
	    local a_d_level = Runes:GetTotalRuneLevel(caster, 1, "r_1", "conjuror")
	    if caster.earthAspect then
	    	applyCalls(ability, caster.earthAspect, earth, fire, shadow, caster, 0.95, growCount)
	    	if a_d_level > 0 then
	    		if not caster.earthAspect:HasAbility("earth_aspect_quake_leap") then
	    			caster.earthAspect:AddAbility("earth_aspect_quake_leap"):SetLevel(1)
	    		end
	    	end
	    end
	    if caster.fireAspect then
	    	applyCalls(ability, caster.fireAspect, earth, fire, shadow, caster, 0.82, growCount)
	    	local b_d_level =  Runes:GetTotalRuneLevel(caster, 2, "r_2", "conjuror")
	    	ability.r_2_level = b_d_level
	    	if b_d_level > 0 then
	    		ability:ApplyDataDrivenModifier(caster, caster.fireAspect, "modifier_fire_aspect_b_d_effect", {})
	    		caster.fireAspect:SetModifierStackCount("modifier_fire_aspect_b_d_effect", caster, b_d_level)
	    		ability:ApplyDataDrivenModifier(caster, caster.fireAspect, "modifier_fire_aspect_b_d_range", {})
	    		if not caster.fireAspect.fireDeity then
	    			caster.fireAspect:SetModel(	"models/items/invoker/forge_spirit/grievous_ingots/grievous_ingots.vmdl")
	    			caster.fireAspect:SetRangedProjectileName("particles/units/heroes/hero_lina/lina_base_attack.vpcf")
	    		else
	    			caster.fireAspect:AddNewModifier(caster.fireAspect, nil, "modifier_conjuror_attack_sound_translate", {})
	    			caster.fireAspect:SetRangedProjectileName("particles/units/heroes/hero_lina/big_tracking_fireball.vpcf")
	    		end
	    		caster.fireAspect:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
	    	end
	    end
	    local c_d_level = Runes:GetTotalRuneLevel(caster, 3, "r_3", "conjuror")
	    caster:FindAbilityByName("summon_shadow_aspect").r_3_level = c_d_level
	    if caster.shadowAspect then
	    	applyCalls(ability, caster.shadowAspect, earth, fire, shadow, caster, 1.1, growCount)
	    	if c_d_level > 0 then
	    		ability:ApplyDataDrivenModifier(caster, caster.shadowAspect, "modifier_shadow_aspect_c_d_slow_attack", {})
	    	end
	    end
	    

	    applyCalls(ability, caster, earth, fire, shadow, caster, 0.8, growCount)
	    StartAnimation(caster, {duration=0.75, activity=ACT_DOTA_CAST_TORNADO, rate=1.0})
	    ability.growCount = growCount
	    Filters:CastSkillArguments(4, caster)
	elseif caster:GetUnitName() == "conjuror_elemental_deity_summon" then
		deity_call(event)
    end


end


function applyCalls(ability, unit, earth, fire, shadow, caster, origScale, growCount)
	local durationIncrease = ability.r_4_level*0.6
	local buffDuration = 20+durationIncrease
	buffDuration = Filters:GetAdjustedBuffDuration(caster, buffDuration, false)
	ability:ApplyDataDrivenModifier(caster, unit, "modifier_call_of_elements", {duration = buffDuration})
	if earth then
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_call_of_earth", {duration = buffDuration})
	end
	if fire then
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_call_of_fire", {duration = buffDuration})
	end
	if shadow then
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_call_of_shadow", {duration = buffDuration})
	end
	unit.origScale = origScale
	smoothModelChange(unit, origScale, origScale*1+(0.12*growCount))
end

function smoothModelChange(unit, origScale, newScale)
	local difference = newScale - origScale
	for i = 0, 15, 1 do
		Timers:CreateTimer(0.05*i, function()
			if not unit:IsNull() then
				unit:SetModelScale(origScale+i*difference/16) 
			end
		end)
	end
end

function call_end(event)
	local target = event.target
	local ability = event.ability
	target:SetModelScale(target.origScale)
	smoothModelChange(target, target.origScale*1+(0.12*ability.growCount), target.origScale)
	if target:HasAbility("earth_aspect_quake_leap") then
		if target:HasModifier("modfier_earth_aspect_jumping") then
			target.RemoveLeapAbility = true
		else
			target:RemoveAbility("earth_aspect_quake_leap")
		end
	end
	if target:HasModifier("modifier_fire_aspect_b_d_effect") then
		target:SetRangedProjectileName(nil)
		target:RemoveModifierByName("modifier_fire_aspect_b_d_effect")
		target:RemoveModifierByName("modifier_fire_aspect_b_d_range")
		if not target.fireDeity then
			target:SetModel("models/items/invoker/forge_spirit/infernus/infernus.vmdl")
		else
			target:RemoveModifierByName("modifier_conjuror_attack_sound_translate")
		end
		target:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
	end
	if target:HasModifier("modifier_shadow_aspect_c_d_slow_attack") then
		target:RemoveModifierByName("modifier_shadow_aspect_c_d_slow_attack")
	end
end

function deity_call(event)
	local caster = event.caster.conjuror
	local ability = event.ability
	local earth = false
	local fire = false
	local shadow = false
	EmitSoundOn("Conjuror.ElementalDeity.Cast", event.caster)
	local growCount = 0
    if caster.earthAspect then
    	earth = true
    	growCount = growCount + 1
    end
    if caster.fireAspect then
    	fire = true
    	growCount = growCount + 1
    end
    if caster.shadowAspect then
 		shadow = true
 		growCount = growCount + 1
    end

    if caster.earthAspect then
    	applyCallsArcana(ability, caster.earthAspect, earth, fire, shadow, caster, 0.95, growCount, event.caster.r_3_level, event.caster.r_4_level)
    end
    if caster.fireAspect then
    	applyCallsArcana(ability, caster.fireAspect, earth, fire, shadow, caster, 0.82, growCount, event.caster.r_3_level, event.caster.r_4_level)
    end
    if caster.shadowAspect then
    	applyCallsArcana(ability, caster.shadowAspect, earth, fire, shadow, caster, 1.1, growCount, event.caster.r_3_level, event.caster.r_4_level)
    end
    

    applyCallsArcana(ability, caster, earth, fire, shadow, caster, 0.8, growCount, event.caster.r_3_level, event.caster.r_4_level)

    applyCallsArcana(ability, event.caster, earth, fire, shadow, caster, 0.88, growCount, event.caster.r_3_level, event.caster.r_4_level)

    StartAnimation(caster, {duration=0.75, activity=ACT_DOTA_FLAIL, rate=2.0})
    ability.growCount = growCount
end

function applyCallsArcana(ability, unit, earth, fire, shadow, caster, origScale, growCount, c_d_level, d_d_level)
	local durationIncrease = 0
	if d_d_level then 
		durationIncrease = d_d_level*0.3
	end
	local buffDuration = 20+durationIncrease
	local procs = Runes:Procs(c_d_level, 5, 1) + 1
	buffDuration = Filters:GetAdjustedBuffDuration(caster, buffDuration, false)
	ability:ApplyDataDrivenModifier(caster, unit, "modifier_call_of_elements", {duration = buffDuration})
	unit:SetModifierStackCount("modifier_call_of_elements", caster, procs)
	if earth then
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_call_of_earth", {duration = buffDuration})
		unit:SetModifierStackCount("modifier_call_of_earth", caster, procs)
	end
	if fire then
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_call_of_fire", {duration = buffDuration})
		unit:SetModifierStackCount("modifier_call_of_fire", caster, procs)
	end
	if shadow then
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_call_of_shadow", {duration = buffDuration})
		unit:SetModifierStackCount("modifier_call_of_shadow", caster, procs)
	end
	unit.origScale = origScale
	smoothModelChange(unit, origScale, origScale*1+(0.12*growCount))
end