require('heroes/lanaya/constants')

function rune_unit_3_think(event)
	local caster = event.caster
	local ability = event.ability
	local hero = caster.hero
	local c_c_level = Runes:GetTotalRuneLevel(hero, 3, "e_3", "trapper")
	
	ability.e_3_level = c_c_level
	if c_c_level > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_psi_blades_c_c", {})
		hero:SetModifierStackCount( "modifier_psi_blades_c_c", ability, ability.e_3_level )
	else
		hero:RemoveModifierByName("modifier_psi_blades_c_c")
	end
end

function CheckAngles(keys)
	local caster = keys.attacker
	local target = keys.target
	local ability = keys.ability
	--print("ATTACK PSI!!!")
	-- Notes the origin of the first target to be the center of the findunits radius
	local first_target_origin = target:GetAbsOrigin()
	-- Notes the damage the first target takes to apply to the other targets
	local c_c_level = ability.e_3_level
	ability.line_damage = keys.damage*TRAPPER_E3_DAMAGE_PERCENT/100*c_c_level
	ability.origCaster = caster

	if caster:HasModifier("modifier_trapper_glyph_2_2") then
		Filters:TakeArgumentsAndApplyDamage(target, caster, ability.line_damage, DAMAGE_TYPE_PURE, BASE_ABILITY_E, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
	end
	-- Gets the caster's origin difference from the target
	local caster_origin_difference = caster:GetAbsOrigin() - first_target_origin 

	-- Get the radian of the origin difference between the attacker and TA. We use this to figure out at what angle the victim is at relative to the TA.
	local caster_origin_difference_radian = math.atan2(caster_origin_difference.y, caster_origin_difference.x)
	
	-- Convert the radian to degrees.
	caster_origin_difference_radian = caster_origin_difference_radian * 180
	local attacker_angle = caster_origin_difference_radian / math.pi
	-- Turns negative angles into positive ones and make the math simpler.
	attacker_angle = attacker_angle + 180.0
	
	local radius = 700
	local attack_spill_width = 50
	
	-- Units in radius
	local units = FindUnitsInRadius(caster:GetTeamNumber(), first_target_origin, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
	
	-- Calculates the position of each found unit in relation to the last target
	for i,unit in ipairs(units) do
		if unit ~= target then
			local target_origin_difference = target:GetAbsOrigin() - unit:GetAbsOrigin()
			
			-- Get the radian of the origin difference between the last target and the unit. We use this to figure out at what angle the unit is at relative to the the target.
			local target_origin_difference_radian = math.atan2(target_origin_difference.y, target_origin_difference.x)
	
			-- Convert the radian to degrees.
			target_origin_difference_radian = target_origin_difference_radian * 180
			local victim_angle = target_origin_difference_radian / math.pi
			-- Turns negative angles into positive ones and make the math simpler.
			victim_angle = victim_angle + 180.0
	
			-- The difference between the world angle of the caster-target vector and the target-unit vector
			local angle_difference = math.abs(victim_angle - attacker_angle)			
			
			local new_target = false
			
			-- Ensures the angle difference is less than the allowed width
			if angle_difference <= attack_spill_width then
				local info = {
				Target = unit,
				Source = target,
				Ability = ability,
				EffectName = keys.particle,
				bDodgeable = false,
				iMoveSpeed = 2000,
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
				}
				ProjectileManager:CreateTrackingProjectile( info )
				
				new_target = true
			end
		end
	end
end

--[[Author: YOLOSPAGHETTI
	Date: April 8, 2016
	Deals damage to the secondary targets]]
function DealDamage_c_c(keys)
	
	local target = keys.target
	local ability = keys.ability
	local caster = ability.origCaster
	-- Applies the damage to the attack target
	Filters:TakeArgumentsAndApplyDamage(target, caster, ability.line_damage, DAMAGE_TYPE_PURE, BASE_ABILITY_E, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
end