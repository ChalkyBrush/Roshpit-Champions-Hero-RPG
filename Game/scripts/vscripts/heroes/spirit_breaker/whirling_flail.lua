require('/heroes/spirit_breaker/constants')
require('/heroes/spirit_breaker/helpers')
function whirling_flail_start(event)
	local caster = event.caster
	local ability = event.ability
	StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_TELEPORT, rate=1.8})
	ability.q_1_level = Runes:GetTotalRuneLevel(caster, 1, "q_1", "duskbringer")
	ability.q_3_level = Runes:GetTotalRuneLevel(caster, 3, "q_3", "duskbringer")
	ability.q_4_level = Runes:GetTotalRuneLevel(caster, 4, "q_4", "duskbringer")
	ability.radius = 280 + ability.q_4_level * Q4_ADD_RADIUS
	ability.ticks = 0

	  if ability.q_1_level > 0 then
		local particleName = "particles/units/heroes/hero_spirit_breaker/spirit_breaker_charge_wave.vpcf"
		ability.pfx = ParticleManager:CreateParticle( particleName, PATTACH_POINT_FOLLOW, caster )
		ParticleManager:SetParticleControlEnt(ability.pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
	  end
	  if ability.q_1_level > 0 then
		  ability.pfxB = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/duskbringer_b_d_vertical_spell_bloodbath_bubbles_.vpcf", PATTACH_CUSTOMORIGIN, nil)
		  ParticleManager:SetParticleControlEnt(ability.pfxB, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		  ParticleManager:SetParticleControl(ability.pfxB, 1, Vector(ability.radius/3, 1, 1))
	  end
	  
--	  ability.q_2_level = Runes:GetTotalRuneLevel(caster, 2, "q_2", "duskbringer")
--	  if ability.q_2_level > 0 then
--		ability:ApplyDataDrivenModifier(caster, caster, "modifier_whirling_flail_ghastly_wind", {duration = 3.5})
--		local particleName = "particles/units/heroes/hero_bloodseeker/duskbringer_b_d_vertical_spell_bloodbath_bubbles_.vpcf"
--	    ability.q_2_particle = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
--	      ParticleManager:SetParticleControl( ability.q_2_particle, 0, caster:GetAbsOrigin()+Vector(0,0,80) )
--	  end
--	  ability.q_3_level = Runes:GetTotalRuneLevel(caster, 3, "q_3", "duskbringer")
--	  caster:RemoveModifierByName("modifier_whirling_flail_imbue_shade_armor")
--	  if ability.q_3_level > 0 then
--		ability:ApplyDataDrivenModifier(caster, caster, "modifier_whirling_flail_imbue_shade", {duration = 3.5})
--		ability:ApplyDataDrivenModifier(caster, caster, "modifier_whirling_flail_imbue_shade_armor", {duration = 3.5})
--		caster:SetModifierStackCount( "modifier_whirling_flail_imbue_shade_armor", ability, ability.q_3_level )
--	  end
	  spectral_blade_init(caster, ability)
	  if caster:HasModifier("modifier_duskbringer_glyph_6_1") then
	  	ability:EndCooldown()
	  	ability:StartCooldown(4)
	  end
	  caster.r_4_level = Runes:GetTotalRuneLevel(caster, 4, "r_4", "duskbringer")
  	Filters:CastSkillArguments(1, caster)
end

function whirling_flail_particle(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.whirling_flail_particle_main then
		caster.whirling_flail_particle_main = ParticleManager:CreateParticle("particles/roshpit/duskbringer/whirling_flail_base.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(caster.whirling_flail_particle_main, 0, caster:GetAbsOrigin() + WallPhysics:rotateVector(caster:GetForwardVector(), -math.pi/2)*120)
		ParticleManager:SetParticleControl(caster.whirling_flail_particle_main, 1, Vector(ability.radius, ability.radius, ability.radius))
	else
		ParticleManager:SetParticleControl(caster.whirling_flail_particle_main, 0, caster:GetAbsOrigin() + WallPhysics:rotateVector(caster:GetForwardVector(), -math.pi/2)*120)
	end
end

function whirling_flail_particle_end(event)
	local caster = event.caster
	if caster.whirling_flail_particle_main then
		ParticleManager:DestroyParticle(caster.whirling_flail_particle_main, false)
		caster.whirling_flail_particle_main = nil
	end
end

function spectral_blade_init(caster, ability)
		ability.r_2_level = Runes:GetTotalRuneLevel(caster, 2, "r_2", "duskbringer")
		ability.r_4_level = Runes:GetTotalRuneLevel(caster, 4, "r_4", "duskbringer")
		local runeAbility = caster.runeUnit2:FindAbilityByName("duskbringer_rune_r_2")
		local current_stack = caster:GetModifierStackCount("modifier_duskbringer_rune_r_2", runeAbility)
		if current_stack > 0 then
			local particleName = "particles/units/heroes/hero_bloodseeker/duskbringer_b_a_spell_bloodbath_bubbles_.vpcf"
		    ability.r_2_particle = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		     ParticleManager:SetParticleControlEnt(ability.r_2_particle, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		     local yaw = math.atan2(caster:GetForwardVector().x, caster:GetForwardVector().y)*180/math.pi
		     -- ParticleManager:SetParticleControl( ability.r_2_particle, 1, Vector(90, 90, 90) )
		end

end

function spectral_blade_think(caster, ability)
		local runeAbility = caster.runeUnit2:FindAbilityByName("duskbringer_rune_r_2")
		local current_stack = caster:GetModifierStackCount("modifier_duskbringer_rune_r_2", runeAbility)
 
		if current_stack > 0 then
			if ability.r_2_particle then
				ParticleManager:DestroyParticle(ability.r_2_particle, false)
			end
			ability.r_2_particle = false
			local particleName = "particles/units/heroes/hero_bloodseeker/duskbringer_b_a_spell_bloodbath_bubbles_.vpcf"
		    ability.r_2_particle = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		    -- ParticleManager:SetParticleControl( ability.r_2_particle, 0, caster:GetAbsOrigin() )
		    ParticleManager:SetParticleControlEnt(ability.r_2_particle, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		     local yaw = math.atan2(caster:GetForwardVector().x, caster:GetForwardVector().y)*180/math.pi
		     print(yaw)
		     -- ParticleManager:SetParticleControl( ability.r_2_particle, 1, Vector(90, 90, 90) )			
			if current_stack > 1 then
				caster:SetModifierStackCount( "modifier_duskbringer_rune_r_2", runeAbility, current_stack-1 )
				local startPoint = caster:GetAbsOrigin() - caster:GetForwardVector()*600
				local endPoint = caster:GetAbsOrigin() + caster:GetForwardVector()*600
				local damage = ability.r_2_level*600
				damage = damage + 0.0005*caster:GetStrength()/10*ability.r_4_level*damage
				if caster:HasModifier('modifier_duskbringer_glyph_3_2') then
					damage = damage * T32_AMPLIFY
				end
				local enemies = FindUnitsInLine( caster:GetTeamNumber(), startPoint, endPoint, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, FIND_ANY_ORDER  )
				if #enemies > 0 then
					for _,enemy in pairs(enemies) do
						ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
					end
				end
			else
				caster:RemoveModifierByName("modifier_duskbringer_rune_r_2")
				if ability.r_2_particle then
					ParticleManager:DestroyParticle(ability.r_2_particle, false)
					ability.r_2_particle = false		
				end
			end
		end
end

function whirling_flail_think(event)
	local caster = event.caster
	local ability = event.ability
	ability.ticks = ability.ticks + 1
	if ability.ticks % 2 == 1 and not caster:HasModifier('modifier_duskbringer_glyph_3_2') then
		return
	end
	phantomRaceRefresh(caster)
	EmitSoundOn("Hero_Spirit_Breaker.PreAttack", caster)
	local searchArea = caster:GetAbsOrigin() + WallPhysics:rotateVector(caster:GetForwardVector(), -math.pi/2)*120
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), searchArea, nil, ability.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	local damage = event.damage * OverflowProtectedGetAverageTrueAttackDamage(caster) / 100
	damage = damage * (1 + Q4_AMPLIFY_PERCENT * ability.q_4_level / 100)

	EndAnimation(caster)
	Timers:CreateTimer(0.03, function()
		StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_TELEPORT, rate=1.8})
	end)
	if ability.q_2_particle then
		ParticleManager:DestroyParticle( ability.q_2_particle, false )
		local particleName = "particles/units/heroes/hero_bloodseeker/duskbringer_b_d_vertical_spell_bloodbath_bubbles_.vpcf"
	    ability.q_2_particle = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	     ParticleManager:SetParticleControl( ability.q_2_particle, 0, caster:GetAbsOrigin()+Vector(0,0,80) )
	end
	spectral_blade_think(caster, ability)

	local knockback_distance = event.knockback_distance
	local modifierKnockback =
	{
		center_x = searchArea.x,
		center_y = searchArea.y,
		center_z = searchArea.z,
		duration = 0.5,
		knockback_duration = 0.3,
		knockback_distance = knockback_distance,
		knockback_height = 40
	}
	if #enemies > 0 then
		EmitSoundOn("Hero_Spirit_Breaker.Attack", caster)
		for _,enemy in pairs(enemies) do
			local distance = WallPhysics:GetDistance(enemy:GetAbsOrigin(), caster:GetAbsOrigin())
			local damageBonusMult = math.max(1 - (distance/(ability.radius)),0)--for some reason it hist further than it should
			local distanceDamage = damage * (1 + ability.q_3_level * DUSK_Q3_AMPLIFY_PERCENT/100 * damageBonusMult)
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, distanceDamage, DAMAGE_TYPE_PHYSICAL, 1, RPC_ELEMENT_NORMAL, RPC_ELEMENT_GHOST)

			enemy:AddNewModifier( caster, nil, "modifier_knockback", modifierKnockback )
			local particleName = "particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf"
			local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, enemy )
			ParticleManager:SetParticleControlEnt(pfx, 0, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			Timers:CreateTimer(0.8, function() 
			  ParticleManager:DestroyParticle( pfx, false )
			end) 	
			if ability.q_1_level > 0 then
				local eventTable = {}
				eventTable.attacker = caster
				eventTable.target = enemy
				eventTable.ability = ability
				flail_a_a_hit(eventTable)
			end
		end
	end 	
	  
end

function flail_a_a_hit(event)
	local caster = event.attacker
	local enemy = event.target
	local ability = event.ability
	local stack_increment = 1
	if caster:HasModifier("modifier_duskbringer_glyph_2_2") then
		stack_increment = T22_STACKS
	end
	if not ability.q_1_level then
		ability.q_1_level = Runes:GetTotalRuneLevel(caster, 1, "q_1", "duskbringer")
	end
	if ability.q_1_level > 0 then

		if caster:HasModifier("modifier_duskbringer_glyph_5_2") then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), enemy:GetAbsOrigin(), nil, T52_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			if #enemies > 0 then
				for _,_enemy in pairs(enemies) do
					increment_duskfire_stacks(caster, _enemy, ability, stack_increment)
				end
			end
		else
			increment_duskfire_stacks(caster, enemy, ability, stack_increment)
		end

		local particleName = "particles/units/heroes/hero_spirit_breaker/spirit_breaker_nether_strike_begin_flash.vpcf"
		local pfx2 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, enemy )
		ParticleManager:SetParticleControlEnt(pfx2, 0, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
		local damage = ability.q_1_level * (DUSK_Q1_DAMAGE + Q1_AGI_DAMAGE * caster:GetAgility())
		Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_GHOST, RPC_ELEMENT_FIRE)
		Timers:CreateTimer(0.4, function() 
		  ParticleManager:DestroyParticle( pfx2, false )
		end) 
	end	
end

function whirling_flail_end(event)
	local caster = event.caster
	local ability = event.ability
	if ability.pfx then
		ParticleManager:DestroyParticle( ability.pfx, false )
		ParticleManager:ReleaseParticleIndex(ability.pfx)
		ability.pfx = false
	end
	if ability.pfxB then
		ParticleManager:DestroyParticle( ability.pfxB, false )
		ParticleManager:ReleaseParticleIndex(ability.pfxB)
		ability.pfxB = false
	end
	if ability.q_2_particle then
		ParticleManager:DestroyParticle( ability.q_2_particle, false )
		ability.q_2_particle = false		
	end
	caster:RemoveModifierByName("modifier_whirling_flail_ghastly_wind")
	caster:RemoveModifierByName("modifier_whirling_flail_imbue_shade")
	if ability.r_2_particle then
		ParticleManager:DestroyParticle(ability.r_2_particle, false)
		ability.r_2_particle = false		
	end
end

function a_a_fire_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	if not ability.q_1_level then
		return
	end
	if target.dummy then
		return false
	end
	local fireStacks = target:GetModifierStackCount("modifier_dusk_fire_flail", caster)
	local damage = ability.q_1_level*(DUSK_Q1_DAMAGE + Q1_AGI_DAMAGE * caster:GetAgility())*fireStacks
	Filters:ApplyDotDamage(caster, ability, target, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_GHOST, RPC_ELEMENT_FIRE)
end

function ghastly_wind_think(event)
	local caster = event.caster
	local ability = event.ability
	local radius = 660
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_whirling_flail_ghastly_wind_effect", {duration = 1})
--			enemy:SetModifierStackCount( "modifier_whirling_flail_ghastly_wind_effect", ability, ability.q_2_level )
			if ability.q_1_level > 0 then
				increment_duskfire_stacks(caster, enemy, ability, 1)
			end
		end
	end
end

function increment_duskfire_stacks(caster, enemy, ability, amount)
	ability:ApplyDataDrivenModifier(caster, enemy, "modifier_dusk_fire_flail", {duration = 5})
	ability.q_1_level = Runes:GetTotalRuneLevel(caster, 1, "q_1", "duskbringer")
	local stacks = enemy:GetModifierStackCount("modifier_dusk_fire_flail", caster)
	if caster:HasModifier("modifier_duskbringer_immortal_weapon_1") then
		amount = amount*2
	end
	local newStacks = stacks + amount
	enemy:SetModifierStackCount("modifier_dusk_fire_flail", caster, newStacks)
end
--
--function imbue_shade_think(event)
--	local ability = event.ability
--	local caster = event.caster
--	local heal = math.ceil(ability.q_3_level * 1200)
--	Filters:ApplyHeal(caster, caster, heal, true)
--end

function d_a_attack_land(event)
	local caster = event.attacker
	local ability = event.ability
	local q_1_level = ability.q_1_level
	local target = event.target
	if q_1_level > 0 then
		local q_4_level = caster:GetModifierStackCount("modifier_duskbringer_rune_q_4", ability)

				local particleName = "particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_explosion.vpcf"
					local pfx2 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN,target )
					ParticleManager:SetParticleControlEnt(pfx2, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
					Timers:CreateTimer(0.8, function() 
					  ParticleManager:DestroyParticle( pfx2, false )
					end) 
		local enemies= FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 360, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		local damage = (q_1_level*860)*0.15*q_4_level
		for _,enemy in pairs(enemies) do
			if enemy:GetUnitName() == "water_temple_tentacle_switch" or enemy.dummy then
			else
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_GHOST, RPC_ELEMENT_FIRE)
			end
		end 	
	end
end


function duskbringer_passive_think(event)
	local caster = event.caster
	caster.q_2_level = Runes:GetTotalRuneLevel(caster, 2, "q_2", "duskbringer")
end