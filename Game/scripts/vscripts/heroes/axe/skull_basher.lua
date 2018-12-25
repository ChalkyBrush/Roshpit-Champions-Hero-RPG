require('heroes/axe/arcana_ability')

function skull_basher_start(event)
	local caster = event.caster
	local ability = event.ability
	abilityLevel = ability:GetLevel()
	--ability.location = caster:GetOrigin() + caster:GetForwardVector()*Vector(400,400)
	ability.jump_level = 0

	Filters:CastSkillArguments(1, caster)


        EmitSoundOn("Hero_Axe.BerserkersCall.Item.Shoutmask", caster)
        EmitSoundOn("Hero_Axe.BerserkersCall.Item.Shoutmask", caster)


    ability:ApplyDataDrivenModifier(caster, caster, "modfier_axe_jumping", {duration = 8})
    local targetPoint = event.target_points[1]
    local distance = WallPhysics:GetDistance(targetPoint*Vector(1,1,0), caster:GetAbsOrigin()*Vector(1,1,0))
    local jumpFV = ((targetPoint-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()

    local animationTime = math.min(500/distance, 1)
    StartAnimation(caster, {duration=jumpDuration, activity=ACT_DOTA_FLAIL, rate=animationTime, translate="forcestaff_friendly"})
    print(jumpFV)

    local extraHeight = math.max(GetGroundHeight(targetPoint, caster) - caster:GetAbsOrigin().z, 0)
    ability.jump_velocity = math.max(distance/30 + 5 + extraHeight/14, 15)
    if caster:HasModifier("modifier_whirlwind") then
        ability.jump_velocity = ability.jump_velocity + 5
    end
    ability.jumpFV = jumpFV
    ability.distance = distance
    ability.targetPoint = targetPoint
    ability.lifting = true
    ability.jumpAnimated = false
    Timers:CreateTimer(0.3, function()
    	ability.lifting = false
    end)
    ability.q_3_level = caster:GetRuneValue("q", 3)
end

function new_jumping_think(event)
	local caster = event.caster
	local ability = event.ability
	local forwardSpeed  = ability.distance/60 + 20
	local blockSearch = caster:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,GetGroundHeight(caster:GetAbsOrigin(), caster))
    local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch+ability.jumpFV*35), caster)
	if blockUnit then
		forwardSpeed = 0
	end
	if caster:HasModifier("modifier_axe_rune_q_2_invisible") then
		local modifierDuration = caster:FindModifierByName("modifier_axe_rune_q_2_visible"):GetRemainingTime()
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_axe_rune_q_2_visible", {duration = modifierDuration})
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_axe_rune_q_2_invisible", {duration = modifierDuration})
	end
	if caster:HasModifier("modifier_axe_rune_e_2_tornado") then
		local whirlwindAbility = caster:FindAbilityByName("whirlwind")
        local b_c_duration = Filters:GetAdjustedBuffDuration(caster, 5, false)
		whirlwindAbility:ApplyDataDrivenModifier(caster, caster, "modifier_axe_rune_e_2_tornado", {duration = b_c_duration})
	end
	caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,ability.jump_velocity)+ability.jumpFV*forwardSpeed)
	ability.jump_velocity = ability.jump_velocity - 3.3
	print(ability.jumpFV)
	if caster:GetAbsOrigin().z < GetGroundHeight(caster:GetAbsOrigin(), caster) + 14 and not ability.lifting then
		caster:RemoveModifierByName("modfier_axe_jumping")
	-- elseif caster:GetAbsOrigin().z < GetGroundHeight(caster:GetAbsOrigin(), caster) + 54 and not ability.lifting then
	-- 	if not ability.jumpAnimated then
	-- 		EndAnimation(caster)
	-- 		Timers:CreateTimer(0.03, function()
	-- 			StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_FORCESTAFF_END, rate=1.0})
	-- 		end)
	-- 		ability.jumpAnimated = true
	-- 	end
	end
end

function drop_end(keys)
	local caster = keys.caster
	local ability = keys.ability
	local location = caster:GetAbsOrigin()
	
	Timers:CreateTimer(0.06, function()
		-- EndAnimation(caster)
		FindClearSpaceForUnit(caster, location, false)
	end)
    caster:RemoveModifierByName("modifier_whirlwind_flying_portion")
    if caster:HasModifier("modifier_axe_glyph_7_1") then
        ability:EndCooldown()
        ability:StartCooldown(1.5)
    else
        local skullBasherDuration = Filters:GetAdjustedBuffDuration(caster, keys.duration, false)
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_stun_attack", {duration = skullBasherDuration})
    end
	if ability.q_3_level > 0 then
        local damageAmp = ability.q_3_level*0.3
        if caster:HasAbility("sunder") then
    		StartAnimation(caster, {duration=jumpDuration, activity=ACT_DOTA_CAST_ABILITY_4, rate=2.5})
    		Timers:CreateTimer(0.2, function()
    			local sunderAbility = caster:FindAbilityByName("sunder")
    			local damage = sunderAbility:GetSpecialValueFor("main_damage")
    			
    			CustomAbilities:AxeSunder(caster, sunderAbility, damage, damageAmp, "particles/units/heroes/hero_earthshaker/earthshaker_echoslam_start.vpcf")	
    		end)
        elseif caster:HasAbility("axe_arcana_smash") then
            local eventTable = {}
            eventTable.caster = caster
            eventTable.ability = caster:FindAbilityByName("axe_arcana_smash")
            eventTable.target_points = {}
            eventTable.forks = 1
            eventTable.amp = damageAmp
            eventTable.attack_power_mult_percent = eventTable.ability:GetLevelSpecialValueFor("attack_power_mult_percent", eventTable.ability:GetLevel())
            eventTable.stun_duration = eventTable.ability:GetLevelSpecialValueFor("stun_duration", eventTable.ability:GetLevel())
            eventTable.target_points[1] = caster:GetAbsOrigin()+caster:GetForwardVector()*200
            begin_arcana_ult(eventTable)
        end
	else
		StartAnimation(caster, {duration=0.4, activity=ACT_DOTA_FORCESTAFF_END, rate=1})
	end

end

function StunAttack( keys )
    local caster = keys.attacker
    local ability = keys.ability
    local hero = caster
    local abilityLevel = ability:GetLevel()

    local targetUnit = keys.target
    local position = targetUnit:GetAbsOrigin()
    local stun_duration = keys.duration
    local aoe_damage = keys.aoe_damage
    local q_4_level = caster:GetRuneValue("q", 4)
    if q_4_level > 0 then
        aoe_damage = aoe_damage + OverflowProtectedGetAverageTrueAttackDamage(caster)*0.06*q_4_level
    end
    if caster:HasModifier("modifier_axe_glyph_5_1") then
        aoe_damage = aoe_damage*3
        stun_duration = 0.03
    end
    local base_radius = rune_q_1(caster, keys.base_radius)

    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), targetUnit:GetAbsOrigin(), nil, base_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
    if #enemies > 0 then
        for _,enemy in pairs(enemies) do
            Filters:TakeArgumentsAndApplyDamage(enemy, caster, aoe_damage, DAMAGE_TYPE_PHYSICAL, 1, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
            Filters:ApplyStun(caster, stun_duration, enemy)
            --ability:ApplyDataDrivenModifier(caster, targetUnit, "modifier_stun_explosion", {})
        end
    end 
    EmitSoundOn("Hero_ElderTitan.EchoStomp", targetUnit)
end


function rune_q_1(caster, base_radius)
    local runeUnit = caster.runeUnit
    local ability = runeUnit:FindAbilityByName("axe_rune_q_1")
    local abilityLevel = ability:GetLevel()
    local bonusLevel = Runes:GetTotalBonus(runeUnit, "q_1")
    local totalLevel = abilityLevel + bonusLevel
    return 300 + totalLevel*20
end

function skull_basher_attack_land(event)
	local attacker = event.attacker
	local caster = event.caster
	local ability = event.ability
	local q_2_level = caster:GetRuneValue("q", 2)
	if q_2_level > 0 then
        local b_a_duration = Filters:GetAdjustedBuffDuration(caster, 10, false)
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_axe_rune_q_2_visible", {duration = b_a_duration})
        local current_stack = caster:GetModifierStackCount("modifier_axe_rune_q_2_visible", ability )
        local newStack = math.min(current_stack + 1, 100)
        caster:SetModifierStackCount( "modifier_axe_rune_q_2_visible", ability, newStack )

        ability:ApplyDataDrivenModifier(caster, caster, "modifier_axe_rune_q_2_invisible", {duration = b_a_duration})
        caster:SetModifierStackCount( "modifier_axe_rune_q_2_invisible", ability, newStack*q_2_level )
	end
end

function general_take_damage(event)
	local attacker = event.attacker
	local caster = event.caster
	local ability = event.ability
	local e_4_level = caster:GetRuneValue("e", 4)
	if e_4_level > 0 then
		local whirlwind = caster:FindAbilityByName("whirlwind")
        whirlwind:ApplyDataDrivenModifier(caster, caster, "modifier_axe_rune_e_4_furnace", {})
        local current_stack = caster:GetModifierStackCount("modifier_axe_rune_e_4_furnace", caster)
        local newStack = math.min(current_stack + 1, e_4_level)
        caster:SetModifierStackCount( "modifier_axe_rune_e_4_furnace", whirlwind, newStack)
	end
end


