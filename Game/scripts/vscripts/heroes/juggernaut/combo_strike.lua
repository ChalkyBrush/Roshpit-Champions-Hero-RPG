function begin_combo_strike(event)
	local ability = event.ability
	local caster = event.caster

	local a_a_level = Runes:GetTotalRuneLevel(caster, 1, "a_a", "monk")


	if not ability.phase then
		ability.phase = 0
	end
	if ability.phase == 0 then
		Filters:CastSkillArguments(1, caster)
	end
	ability.phase = ability.phase+1

	local d_a_level = Runes:GetTotalRuneLevel(caster, 4, "d_a", "monk")
	local animationRate = math.min(1+d_a_level*0.07, 2)
	local durationReduce = math.min(d_a_level*0.005, 0.16)
	local cdReduce = math.min(d_a_level*0.01, 0.25)
	if ability.phase == 1 then
		StartAnimation(caster, {duration=0.36-durationReduce, activity=ACT_DOTA_ATTACK, rate=animationRate})
		EmitSoundOn("juggernaut_jug_ability_omnislash_15", caster)
	elseif ability.phase == 2 then
		StartAnimation(caster, {duration=0.36-durationReduce, activity=ACT_DOTA_ATTACK, rate=animationRate, translate="odachi"})
		EmitSoundOn("juggernaut_jug_ability_omnislash_16", caster)
	elseif ability.phase == 3 then
		StartAnimation(caster, {duration=0.6-durationReduce, activity=ACT_DOTA_ATTACK_EVENT, rate=animationRate-0.2})
		EmitSoundOn("juggernaut_jug_ability_omnislash_28", caster)
		EmitSoundOn("Hero_Juggernaut.BladeDance", caster)
		Timers:CreateTimer(0.2, function()
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_final_slice", {})
			if a_a_level > 0 then
				a_a_cloud_burst(caster, a_a_level, ability, d_a_level)
			end
		end)
		if caster:HasModifier("modifier_monk_glyph_3_1") then
			local ultimaBlade = caster:FindAbilityByName("monk_ultima_blade")
			ultimaBlade:EndCooldown()
		end
	end
	EmitSoundOn("Hero_Juggernaut.PreAttack", caster)
	EmitSoundOn("Hero_Juggernaut.PreAttack", caster)
	local b_a_level = Runes:GetTotalRuneLevel(caster, 2, "b_a", "monk")
	if ability.phase <= 2 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_combo_no_cooldown", {duration = 1.5})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_combo_slicing", {duration = 0.38-cdReduce})
		ability:StartCooldown(0.38-cdReduce)
		slice(caster, 200, event.damage, 0.15)
	elseif b_a_level > 0 and ability.phase <= 3 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_combo_no_cooldown", {duration = 1.5})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_combo_slicing", {duration = 0.38-cdReduce})
		ability:StartCooldown(0.38-cdReduce)
		if caster:HasModifier("modifier_monk_glyph_3_1") then
			event.damage = event.damage*3
		end
		slice(caster, 240, event.damage*2, 0.35)
	elseif b_a_level > 0 then
		ability.phase = 0
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_combo_slicing", {duration = 0.63-cdReduce})
		caster:RemoveModifierByName("modifier_combo_no_cooldown")
		tornado(caster, event.damage*2, ability, b_a_level)		
	else
		ability.phase = 0
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_combo_slicing", {duration = 0.63-cdReduce})
		caster:RemoveModifierByName("modifier_combo_no_cooldown")
		slice(caster, 240, event.damage*2, 0.35)
	end
end

function slice(caster, radius, damage, delay)
	Timers:CreateTimer(delay, function()
		local casterOrigin = caster:GetAbsOrigin()
		local position = casterOrigin + caster:GetForwardVector()*(radius-60)
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		local modifierKnockback =
		{
			center_x = casterOrigin.x,
			center_y = casterOrigin.y,
			center_z = casterOrigin.z,
			duration = 0.28,
			knockback_duration = 0.26,
			knockback_distance = 140,
			knockback_height = 20,
		}
	      
		if #enemies > 0 then
			local c_a_level = Runes:GetTotalRuneLevel(caster, 3, "c_a", "monk")
			local c_a_damage = caster:GetAverageTrueAttackDamage(caster)*c_a_level*0.1
			local c_b_ability = caster.runeUnit3:FindAbilityByName("monk_rune_c_b")
			local c_b_level = Runes:GetTotalRuneLevel(caster, 3, "c_b", "monk")
			local healPercent = c_b_level*0.025

			damage = damage+c_a_damage
			EmitSoundOn("Hero_Juggernaut.Attack", caster)
			if #enemies > 6 then
				EmitSoundOn("Hero_Juggernaut.Attack", caster)
			end
			if #enemies > 10 then
				EmitSoundOn("Hero_Juggernaut.Attack", caster)
			end
			for _,enemy in pairs(enemies) do
				enemy:AddNewModifier( caster, nil, "modifier_knockback", modifierKnockback )
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, 1, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
				if c_b_level > 0 then
					caster:Heal(damage*healPercent, caster)
					caster:RemoveModifierByName("modifier_monk_rune_c_b_heal_effect")
					c_b_ability:ApplyDataDrivenModifier(caster.runeUnit3, caster, "modifier_monk_rune_c_b_heal_effect", {duration = 0.5})
				end
			end
		end
	end) 		
end

function end_no_cooldown(event)
	local ability = event.ability
	local caster = event.caster
	ability.phase = 0
	caster:RemoveModifierByName("modifier_monk_glyph_2_1_effect")
	-- local b_a_level = Runes:GetTotalRuneLevel(caster, 2, "b_a", "monk")
	-- if b_a_level > 40 then
	-- 	b_a_level = 40
	-- end
	ability:StartCooldown(4)

end

function start_no_cooldown(event)
	local ability = event.ability
	local caster = event.caster
	if caster:HasModifier("modifier_monk_glyph_2_1") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_monk_glyph_2_1_effect", {duration = 6})
	end
end

function tornado(caster, damage, ability, b_a_level)	
	ability.liftVelocity = 30
	ability.fallVelocity = 0
	ability.forwardVector = caster:GetForwardVector()
	ability.sliceDamage = b_a_level*300
	ability.c_a_level = Runes:GetTotalRuneLevel(caster, 3, "c_a", "monk")
	local duration = 0.5 + b_a_level*0.02
	if duration > 1 then
		duration = 1
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_tornado_lifting", {duration = duration/2})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_tornado_slashing", {duration = duration})
	caster:SetForwardVector(Vector(ability.forwardVector.x, ability.forwardVector.y, -math.pi))
	StartAnimation(caster, {duration=duration, activity=ACT_DOTA_OVERRIDE_ABILITY_1, rate=1.0})
	EmitSoundOn("juggernaut_jug_ability_omnislash_05", caster)
end

function tornado_think(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Hero_Juggernaut.PreAttack", caster)
	local casterOrigin = caster:GetAbsOrigin()
	-- caster:SetAbsOrigin(casterOrigin+Vector(0,0,30))
	local position = casterOrigin
	local radius = 280
	local damage = ability.sliceDamage
	local slice_think_position = casterOrigin+ability.forwardVector*-90
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), GetGroundPosition(slice_think_position, caster), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	local modifierKnockback =
	{
		center_x = slice_think_position.x,
		center_y = slice_think_position.y,
		center_z = slice_think_position.z,
		duration = 0.38,
		knockback_duration = 0.38,
		knockback_distance = 140,
		knockback_height = 35,
	}
	local c_a_damage = caster:GetAverageTrueAttackDamage(caster)*ability.c_a_level*0.05/3
	damage = damage+c_a_damage     
	if #enemies > 0 then
		EmitSoundOn("Hero_Juggernaut.Attack", caster)
		if #enemies > 6 then
			EmitSoundOn("Hero_Juggernaut.Attack", caster)
		end
		if #enemies > 10 then
			EmitSoundOn("Hero_Juggernaut.Attack", caster)
		end
		for _,enemy in pairs(enemies) do
			enemy:AddNewModifier( caster, nil, "modifier_knockback", modifierKnockback )
			ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL })		
		end
	end 	
end

function tornado_lifting(event)
	local caster = event.caster
	local ability = event.ability
	ability.liftVelocity = ability.liftVelocity-3
	local position = caster:GetAbsOrigin() + Vector(0,0,ability.liftVelocity)
	local newPosition = position+ability.forwardVector*34
	local obstruction = WallPhysics:FindNearestObstruction(newPosition)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition, caster)
	
	if not blockUnit then
		caster:SetOrigin(newPosition)
	end
end

function tornado_falling(event)

	local caster = event.caster
	local ability = event.ability
	if ability.fallVelocity == 0 then
		caster:SetForwardVector(Vector(ability.forwardVector.x, ability.forwardVector.y, -math.pi*3/2))
	end
	ability.fallVelocity = ability.fallVelocity + 3
	local position = caster:GetAbsOrigin() - Vector(0,0,ability.fallVelocity)
	local newPosition = position+ability.forwardVector*34
	local obstruction = WallPhysics:FindNearestObstruction(newPosition)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition, caster)
	
	if not blockUnit then
		caster:SetOrigin(newPosition)
	end
	if position.z - GetGroundPosition(position, caster).z < 10 then
		caster:RemoveModifierByName("modifier_tornado_falling")
	end
end

function falling_end(event)
	local caster = event.caster
	local ability = event.ability
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
	caster:SetForwardVector(Vector(ability.forwardVector.x, ability.forwardVector.y, ability.forwardVector.z))
end

function a_a_cloud_burst(caster, totalLevel, ability, d_a_level)
	local damage = totalLevel*140
	damage = damage + 0.0005*(caster:GetStrength()+caster:GetAgility()+caster:GetIntellect())/10*d_a_level*damage
	if caster:HasModifier("modifier_monk_glyph_1_1") then
		damage = damage*1.4
	end
	local position =  caster:GetAbsOrigin()+caster:GetForwardVector()*190
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, 450, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )

	
	
	if #enemies > 0 then	
		for _,enemy in pairs(enemies) do
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_cloud_burst", {duration = 3})
			enemy:SetModifierStackCount( "modifier_cloud_burst", ability, totalLevel )
			ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })	
		end
	end
		local particleName =  "particles/units/heroes/hero_elder_titan/monk_cloud_burst.vpcf"
		local particleVector = position

		local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( pfx, 0, particleVector )
		ParticleManager:SetParticleControl( pfx, 1, particleVector )
		ParticleManager:SetParticleControl( pfx, 2, particleVector )
		Timers:CreateTimer(1, function() 
		  ParticleManager:DestroyParticle( pfx, false )
		end)  
end