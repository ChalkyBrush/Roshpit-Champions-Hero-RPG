function charge_wind_up(event)
	local caster = event.caster
	-- caster:Stop()
	local ability = event.ability
	local duration = event.duration
	StartAnimation(caster, {duration=duration+0.3, activity=ACT_DOTA_RUN, rate=1.4, translate="charge"})
	ability.fv = caster:GetForwardVector()
	ability.e_3_level = Runes:GetTotalRuneLevel(caster, 3, "e_3", "duskbringer")
	ability.e_4_level = Runes:GetTotalRuneLevel(caster, 4, "e_4", "duskbringer")
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
	caster:RemoveModifierByName("modifier_duskbringer_rune_e_4_visible")
	caster:RemoveModifierByName("modifier_duskbringer_rune_e_4_invisible")
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

	if ability.interval%9==0 and ability.e_3_level > 0 then
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
			local damage = ability.e_3_level*1000
			for _,enemy in pairs(enemies) do
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 0, RPC_ELEMENT_GHOST, RPC_ELEMENT_NONE)
				enemy:AddNewModifier( caster, nil, "modifier_knockback", modifierKnockback )
				local particleName = "particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf"
				local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, enemy )
				ParticleManager:SetParticleControlEnt(pfx, 0, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
				Timers:CreateTimer(0.8, function() 
				  ParticleManager:DestroyParticle( pfx, false )
				end) 	
				if ability.e_4_level > 0 then
					d_c_up(caster, ability.e_4_level, damage)
				end

			end
		end 			
	end

end

function d_c_up(caster, d_c_level, damage)
    local runeAbility = caster.runeUnit4:FindAbilityByName("duskbringer_rune_e_4")
    local d_c_duration = Filters:GetAdjustedBuffDuration(caster, 15, false)
    runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_duskbringer_rune_e_4_visible", {duration = d_c_duration})
    local current_stacks = caster:GetModifierStackCount( "modifier_duskbringer_rune_e_4_visible", runeAbility )
    newStacks = current_stacks + 1
    caster:SetModifierStackCount( "modifier_duskbringer_rune_e_4_visible", runeAbility, newStacks )

    runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_duskbringer_rune_e_4_invisible", {duration = d_c_duration})
    local current_stacks_true = caster:GetModifierStackCount( "modifier_duskbringer_rune_e_4_invisible", runeAbility )
    local new_stacks_true = current_stacks_true + (damage/100) * 0.5 * d_c_level
    caster:SetModifierStackCount( "modifier_duskbringer_rune_e_4_invisible", runeAbility, new_stacks_true)
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

function rune_unit_2_think(event)
	local caster = event.caster
	local ability = event.ability
	local hero = caster.hero
	local totalLevel = Runes:GetTotalRuneLevel(hero, 2, "e_2", "duskbringer")
	if totalLevel > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_duskbringer_rune_e_2_effect", {})
		hero:SetModifierStackCount( "modifier_duskbringer_rune_e_2_effect", ability, totalLevel )
	end
end

function rune_unit_4_think(event)
	local caster = event.caster
	local ability = event.ability
	local hero = caster.hero
	local q_4_level = Runes:GetTotalRuneLevel(hero, 4, "q_4", "duskbringer")
	if q_4_level > 0 then
		local d_a_ability = hero.runeUnit4:FindAbilityByName("duskbringer_rune_q_4")
		d_a_ability:ApplyDataDrivenModifier(hero.runeUnit4, hero, "modifier_duskbringer_rune_q_4", {})
		hero:SetModifierStackCount( "modifier_duskbringer_rune_q_4", d_a_ability, q_4_level )
		d_a_ability.q_1_level = Runes:GetTotalRuneLevel(hero, 1, "q_1", "duskbringer")
	else
		hero:RemoveModifierByName("modifier_duskbringer_rune_q_4")
	end
end