function charge_wind_up(event)
	local caster = event.caster
	-- caster:Stop()
	local ability = event.ability
	local duration = event.duration
	StartAnimation(caster, {duration=duration+0.3, activity=ACT_DOTA_RUN, rate=1.4, translate="charge"})
	ability.fv = caster:GetForwardVector()
	ability.c_c_level = Runes:GetTotalRuneLevel(caster, 3, "c_c", "duskbringer")
	ability.d_c_level = Runes:GetTotalRuneLevel(caster, 4, "d_c", "duskbringer")
	print("charge wind up")
	-- caster:MoveToPosition(caster:GetAbsOrigin() + ability.fv*800)
	local soundTable = {"spirit_breaker_spir_anger_05", "spirit_breaker_spir_laugh_07", "spirit_breaker_spir_move_03"}
	EmitSoundOn(soundTable[RandomInt(1,#soundTable)], caster)
	Filters:CastSkillArguments(3, caster)
end

function begin_rush(event)
	local caster = event.caster
	local ability = event.ability
	ability.interval = 0
	caster:RemoveModifierByName("modifier_duskbringer_rune_d_c_visible")
	caster:RemoveModifierByName("modifier_duskbringer_rune_d_c_invisible")
	print("begin rush")
end


function wind_up_think(event)
	local caster = event.caster
	local ability = event.ability
	caster.EFV = ability.fv
	local newPos = caster:GetAbsOrigin() + ability.fv *30
	local obstruction = WallPhysics:FindNearestObstruction(newPos)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (newPos+ability.fv*20), caster)
	if not blockUnit then
		caster:SetAbsOrigin(newPos)
	end
	print("wind up think")
end





function charge_think(event)

	local caster = event.caster
	local ability = event.ability
	if ability.interval == 0 then
		
	end
	ability.interval = ability.interval + 1
	ability.slideVelocity = 25
	ability.fv = ((ability.fv*4+caster:GetForwardVector())/5):Normalized()
	caster.EFV = ability.fv
	local newPos = GetGroundPosition(caster:GetAbsOrigin() + ability.fv*ability.slideVelocity, caster)
	local obstruction = WallPhysics:FindNearestObstruction(caster:GetAbsOrigin()*Vector(1,1,0))
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPos*Vector(1,1,0), caster)
	if not blockUnit then
		caster:SetAbsOrigin(newPos)
	end
	-- if ability.interval%15 == 0 then
	-- 	EndAnimation(caster)
	-- 	Timers:CreateTimer(0.03, function()
			
	-- 	end)
	-- end
	print("charge think")

	if ability.interval%9==0 and ability.c_c_level > 0 then
		local casterOrigin = caster:GetAbsOrigin()
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), casterOrigin, nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		local modifierKnockback =
		{
			center_x = casterOrigin.x,
			center_y = casterOrigin.y,
			center_z = casterOrigin.z,
			duration = 0.7,
			knockback_duration = 0.5,
			knockback_distance = knockback_distance,
			knockback_height = 70
		}
		if #enemies > 0 then
			EmitSoundOn("Hero_Spirit_Breaker.GreaterBash", caster)
			local damage = ability.c_c_level*1000
			for _,enemy in pairs(enemies) do
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 0, RPC_ELEMENT_GHOST, RPC_ELEMENT_NONE)
				enemy:AddNewModifier( caster, nil, "modifier_knockback", modifierKnockback )
				local particleName = "particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf"
				local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, enemy )
				ParticleManager:SetParticleControlEnt(pfx, 0, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
				Timers:CreateTimer(0.8, function() 
				  ParticleManager:DestroyParticle( pfx, false )
				end) 	
				if ability.d_c_level > 0 then
					d_c_up(caster, ability.d_c_level, damage)
				end

			end
		end 			
	end

end

function d_c_up(caster, d_c_level, damage)
    local runeAbility = caster.runeUnit4:FindAbilityByName("duskbringer_rune_d_c")
    local d_c_duration = Filters:GetAdjustedBuffDuration(caster, 15, false)
    runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_duskbringer_rune_d_c_visible", {duration = d_c_duration})
    local current_stacks = caster:GetModifierStackCount( "modifier_duskbringer_rune_d_c_visible", runeAbility )
    newStacks = current_stacks + 1
    caster:SetModifierStackCount( "modifier_duskbringer_rune_d_c_visible", runeAbility, newStacks )

    runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_duskbringer_rune_d_c_invisible", {duration = d_c_duration})
    local current_stacks_true = caster:GetModifierStackCount( "modifier_duskbringer_rune_d_c_invisible", runeAbility )
    local new_stacks_true = current_stacks_true + (damage/100) * 0.5 * d_c_level
    caster:SetModifierStackCount( "modifier_duskbringer_rune_d_c_invisible", runeAbility, new_stacks_true)
end

function charge_end(event)
	local caster = event.caster
	local ability = event.ability
	print("charge_end")
end

function charge_slide_think(event)
	local ability = event.ability
	local caster = event.caster
	local newPos = GetGroundPosition(caster:GetAbsOrigin() + ability.fv*ability.slideVelocity, caster)
	local obstruction = WallPhysics:FindNearestObstruction(caster:GetAbsOrigin()*Vector(1,1,0))
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPos*Vector(1,1,0), caster)
	if not blockUnit then
		FindClearSpaceForUnit(caster, newPos, false)
	else
		ability.slideVelocity = 0
	end	
	if ability.slideVelocity > 0 then
		ability.slideVelocity = ability.slideVelocity - 2
	end
	print("slide think")
end

function charge_slide_end(event)
	print("slide END")
	local caster = event.caster
	caster.EFV = nil
end

function rune_unit_1_think(event)
	local caster = event.caster
	local ability = event.ability
	local hero = caster.hero
	local totalLevel = Runes:GetTotalRuneLevel(hero, 1, "a_c", "duskbringer")
	if totalLevel > 0 then
		local target = hero
		local ability = event.ability
		local caster = event.caster
		if not ability.lastPos then
			ability.lastPos = target:GetAbsOrigin()
		end
		if not ability.distanceMoved then
			ability.distanceMoved = 0
		end
		ability.newPos = target:GetAbsOrigin()
		ability.hero = target
		local distance = WallPhysics:GetDistance(ability.newPos,ability.lastPos)
		ability.distanceMoved = ability.distanceMoved + distance
		local a_c_duration = Filters:GetAdjustedBuffDuration(caster, 4.5, false)
		if ability.distanceMoved > 1000 then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_duskbringer_rune_a_c_effect", {duration = a_c_duration})
            local current_stack = target:GetModifierStackCount( "modifier_duskbringer_rune_a_c_effect", ability )
            local newStacks = math.min(current_stack + 1, totalLevel)
        	target:SetModifierStackCount( "modifier_duskbringer_rune_a_c_effect", ability, newStacks )
        	ability.phantomPaceStacks = newStacks
        	if target:HasModifier("modifier_duskbringer_glyph_3_1") then
        		ability:ApplyDataDrivenModifier(caster, target, "modifier_duskbringer_glyph_3_1_effect", {duration = a_c_duration})
        		target:SetModifierStackCount( "modifier_duskbringer_glyph_3_1_effect", ability, newStacks)
        	end
        	ability.distanceMoved = ability.distanceMoved%1000
		end

		ability.lastPos = target:GetAbsOrigin()
	end
end

function rune_unit_2_think(event)
	local caster = event.caster
	local ability = event.ability
	local hero = caster.hero
	local totalLevel = Runes:GetTotalRuneLevel(hero, 2, "b_c", "duskbringer")
	if totalLevel > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_duskbringer_rune_b_c_effect", {})
		hero:SetModifierStackCount( "modifier_duskbringer_rune_b_c_effect", ability, totalLevel )
	end
end

function rune_unit_4_think(event)
	local caster = event.caster
	local ability = event.ability
	local hero = caster.hero
	local d_a_level = Runes:GetTotalRuneLevel(hero, 4, "d_a", "duskbringer")
	if d_a_level > 0 then
		local d_a_ability = hero.runeUnit4:FindAbilityByName("duskbringer_rune_d_a")
		d_a_ability:ApplyDataDrivenModifier(hero.runeUnit4, hero, "modifier_duskbringer_rune_d_a", {})
		hero:SetModifierStackCount( "modifier_duskbringer_rune_d_a", d_a_ability, d_a_level )
		d_a_ability.a_a_level = Runes:GetTotalRuneLevel(hero, 1, "a_a", "duskbringer")
	else
		hero:RemoveModifierByName("modifier_duskbringer_rune_d_a")
	end
end

function phantom_pace_duration_end(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	ability.phantomPaceStacks = ability.phantomPaceStacks - 1
	local a_c_duration = Filters:GetAdjustedBuffDuration(caster, 4.5, false)
	if ability.phantomPaceStacks > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_duskbringer_rune_a_c_effect", {duration = a_c_duration})
		target:SetModifierStackCount( "modifier_duskbringer_rune_a_c_effect", ability, ability.phantomPaceStacks )
    	if target:HasModifier("modifier_duskbringer_glyph_3_1") then
    		ability:ApplyDataDrivenModifier(caster, target, "modifier_duskbringer_glyph_3_1_effect", {duration = a_c_duration})
    		target:SetModifierStackCount( "modifier_duskbringer_glyph_3_1_effect", ability, ability.phantomPaceStacks )
    	end
	end
end