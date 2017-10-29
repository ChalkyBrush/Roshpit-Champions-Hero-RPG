function whirling_flail_start(event)
	local caster = event.caster
	local ability = event.ability
	StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_TELEPORT, rate=1.8})
	ability.a_a_level = Runes:GetTotalRuneLevel(caster, 1, "a_a", "duskbringer")
	ability.d_a_level = Runes:GetTotalRuneLevel(caster, 4, "d_a", "duskbringer")

	  if ability.a_a_level > 0 then
		local particleName = "particles/units/heroes/hero_spirit_breaker/spirit_breaker_charge_wave.vpcf"
		ability.pfx = ParticleManager:CreateParticle( particleName, PATTACH_POINT_FOLLOW, caster )
		ParticleManager:SetParticleControlEnt(ability.pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
	  end
	  ability.b_a_level = Runes:GetTotalRuneLevel(caster, 2, "b_a", "duskbringer")
	  if ability.b_a_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_whirling_flail_ghastly_wind", {duration = 3.5})
		local particleName = "particles/units/heroes/hero_bloodseeker/duskbringer_b_d_vertical_spell_bloodbath_bubbles_.vpcf"
	    ability.b_a_particle = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	      ParticleManager:SetParticleControl( ability.b_a_particle, 0, caster:GetAbsOrigin()+Vector(0,0,80) )
	  end
	  ability.c_a_level = Runes:GetTotalRuneLevel(caster, 3, "c_a", "duskbringer")
	  caster:RemoveModifierByName("modifier_whirling_flail_imbue_shade_armor")
	  if ability.c_a_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_whirling_flail_imbue_shade", {duration = 3.5})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_whirling_flail_imbue_shade_armor", {duration = 3.5})
		caster:SetModifierStackCount( "modifier_whirling_flail_imbue_shade_armor", ability, ability.c_a_level )
	  end
	  spectral_blade_init(caster, ability)
	  if caster:HasModifier("modifier_duskbringer_glyph_6_1") then
	  	ability:EndCooldown()
	  	ability:StartCooldown(4)
	  end
	  caster.d_d_level = Runes:GetTotalRuneLevel(caster, 4, "d_d", "duskbringer")
  	Filters:CastSkillArguments(1, caster)
end

function spectral_blade_init(caster, ability)
		ability.b_d_level = Runes:GetTotalRuneLevel(caster, 2, "b_d", "duskbringer")
		ability.d_d_level = Runes:GetTotalRuneLevel(caster, 4, "d_d", "duskbringer")
		local runeAbility = caster.runeUnit2:FindAbilityByName("duskbringer_rune_b_d")
		local current_stack = caster:GetModifierStackCount("modifier_duskbringer_rune_b_d", runeAbility)
		if current_stack > 0 then
			local particleName = "particles/units/heroes/hero_bloodseeker/duskbringer_b_a_spell_bloodbath_bubbles_.vpcf"
		    ability.b_d_particle = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		     ParticleManager:SetParticleControlEnt(ability.b_d_particle, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		     local yaw = math.atan2(caster:GetForwardVector().x, caster:GetForwardVector().y)*180/math.pi
		     -- ParticleManager:SetParticleControl( ability.b_d_particle, 1, Vector(90, 90, 90) )
		end

end

function spectral_blade_think(caster, ability)
		local runeAbility = caster.runeUnit2:FindAbilityByName("duskbringer_rune_b_d")
		local current_stack = caster:GetModifierStackCount("modifier_duskbringer_rune_b_d", runeAbility)
 
		if current_stack > 0 then
			if ability.b_d_particle then
				ParticleManager:DestroyParticle(ability.b_d_particle, false)
			end
			ability.b_d_particle = false
			local particleName = "particles/units/heroes/hero_bloodseeker/duskbringer_b_a_spell_bloodbath_bubbles_.vpcf"
		    ability.b_d_particle = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		    -- ParticleManager:SetParticleControl( ability.b_d_particle, 0, caster:GetAbsOrigin() )
		    ParticleManager:SetParticleControlEnt(ability.b_d_particle, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		     local yaw = math.atan2(caster:GetForwardVector().x, caster:GetForwardVector().y)*180/math.pi
		     print(yaw)
		     -- ParticleManager:SetParticleControl( ability.b_d_particle, 1, Vector(90, 90, 90) )			
			if current_stack > 1 then
				caster:SetModifierStackCount( "modifier_duskbringer_rune_b_d", runeAbility, current_stack-1 )
				local startPoint = caster:GetAbsOrigin() - caster:GetForwardVector()*600
				local endPoint = caster:GetAbsOrigin() + caster:GetForwardVector()*600
				local damage = ability.b_d_level*600
				damage = damage + 0.0005*caster:GetStrength()/10*ability.d_d_level*damage
				local enemies = FindUnitsInLine( caster:GetTeamNumber(), startPoint, endPoint, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, FIND_ANY_ORDER  )
				if #enemies > 0 then
					for _,enemy in pairs(enemies) do
						ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
					end
				end
			else
				caster:RemoveModifierByName("modifier_duskbringer_rune_b_d")
				if ability.b_d_particle then
					ParticleManager:DestroyParticle(ability.b_d_particle, false)
					ability.b_d_particle = false		
				end
			end
		end
end

function whirling_flail_think(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Hero_Spirit_Breaker.PreAttack", caster)
	local searchArea = caster:GetAbsOrigin() + WallPhysics:rotateVector(caster:GetForwardVector(), -math.pi/2)*120
	local radius = 280
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), searchArea, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	local damage = event.damage
	if ability.d_a_level > 0 then
		damage = damage + caster:GetAverageTrueAttackDamage(caster)*0.1*ability.d_a_level
	end
	EndAnimation(caster)
	Timers:CreateTimer(0.03, function()
		StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_TELEPORT, rate=1.8})
	end)
	if ability.b_a_particle then
		ParticleManager:DestroyParticle( ability.b_a_particle, false )
		local particleName = "particles/units/heroes/hero_bloodseeker/duskbringer_b_d_vertical_spell_bloodbath_bubbles_.vpcf"
	    ability.b_a_particle = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	     ParticleManager:SetParticleControl( ability.b_a_particle, 0, caster:GetAbsOrigin()+Vector(0,0,80) )
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
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, 1, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)

			enemy:AddNewModifier( caster, nil, "modifier_knockback", modifierKnockback )
			local particleName = "particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf"
			local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, enemy )
			ParticleManager:SetParticleControlEnt(pfx, 0, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			Timers:CreateTimer(0.8, function() 
			  ParticleManager:DestroyParticle( pfx, false )
			end) 	
			if ability.a_a_level > 0 then
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
	if not ability.a_a_level then
		ability.a_a_level = Runes:GetTotalRuneLevel(caster, 1, "a_a", "duskbringer")
	end
	if ability.a_a_level > 0 then
		increment_duskfire_stacks(caster, enemy, ability, 1)
		local particleName = "particles/units/heroes/hero_spirit_breaker/spirit_breaker_nether_strike_begin_flash.vpcf"
		local pfx2 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, enemy )
		ParticleManager:SetParticleControlEnt(pfx2, 0, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
		local damage = ability.a_a_level*860
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
		ability.pfx = false
	end
	if ability.b_a_particle then
		ParticleManager:DestroyParticle( ability.b_a_particle, false )
		ability.b_a_particle = false		
	end
	caster:RemoveModifierByName("modifier_whirling_flail_ghastly_wind")
	caster:RemoveModifierByName("modifier_whirling_flail_imbue_shade")
	if ability.b_d_particle then
		ParticleManager:DestroyParticle(ability.b_d_particle, false)
		ability.b_d_particle = false		
	end
end

function a_a_fire_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local fireStacks = target:GetModifierStackCount("modifier_dusk_fire_flail", caster)
	local damage = ability.a_a_level*340*fireStacks
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
			enemy:SetModifierStackCount( "modifier_whirling_flail_ghastly_wind_effect", ability, ability.b_a_level )
			if ability.a_a_level > 0 then
				increment_duskfire_stacks(caster, enemy, ability, 1)
			end
		end
	end
end

function increment_duskfire_stacks(caster, enemy, ability, amount)
	ability:ApplyDataDrivenModifier(caster, enemy, "modifier_dusk_fire_flail", {duration = 5})
	local stacks = enemy:GetModifierStackCount("modifier_dusk_fire_flail", caster)
	if caster:HasModifier("modifier_duskbringer_immortal_weapon_1") then
		amount = amount*2
	end
	local newStacks = stacks + amount
	enemy:SetModifierStackCount("modifier_dusk_fire_flail", caster, newStacks)
end

function imbue_shade_think(event)
	local ability = event.ability
	local caster = event.caster
	local heal = math.ceil(ability.c_a_level * 1200)
	Filters:ApplyHeal(caster, caster, heal, true)
end

function d_a_attack_land(event)
	local caster = event.attacker
	local ability = event.ability
	local a_a_level = ability.a_a_level
	local target = event.target
	if a_a_level > 0 then
		local d_a_level = caster:GetModifierStackCount("modifier_duskbringer_rune_d_a", ability)

				local particleName = "particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_explosion.vpcf"
					local pfx2 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN,target )
					ParticleManager:SetParticleControlEnt(pfx2, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
					Timers:CreateTimer(0.8, function() 
					  ParticleManager:DestroyParticle( pfx2, false )
					end) 
		local enemies= FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 360, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		local damage = (a_a_level*860)*0.15*d_a_level
		for _,enemy in pairs(enemies) do
			if enemy:GetUnitName() == "water_temple_tentacle_switch" or enemy.dummy then
			else
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_GHOST, RPC_ELEMENT_FIRE)
			end
		end 	
	end
end