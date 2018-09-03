require('heroes/juggernaut/seinaru_4_r')
require('heroes/juggernaut/seinaru_2_w')
require('heroes/juggernaut/seinaru_constants')

function begin_slice(event)
	local caster = event.caster
	local ability = event.ability
	StartAnimation(caster, {duration=0.84, activity=ACT_DOTA_OVERRIDE_ABILITY_4, rate=0.8})
	ability.liftVelocity = 20
	ability.fallVelocity = 0
	ability.forwardVector = caster:GetForwardVector()
	
	caster.w_4_level = caster:GetRuneValue("w", 4)
	ability.e_1_level = caster:GetRuneValue("e", 1)
	ability.e_2_level = caster:GetRuneValue("e", 2)
	ability.e_3_level = caster:GetRuneValue("e", 3)
	ability.e_4_level = caster:GetRuneValue("e", 4)
	ability.r_1_level = caster:GetRuneValue("r", 1)
	caster.EFV = ability.forwardVector

	ability.repeatedZ = 0
	ability.lastZ = 0

	ability.e_1_unit_table = {}
	if ability.e_1_particleTable then
		if #ability.e_1_particleTable > 0 then
			for i = 1, #ability.e_1_particleTable, 1 do
				ParticleManager:DestroyParticle(ability.e_1_particleTable[i], false)
			end
		end
	end
	slice_think(event)
	Filters:CastSkillArguments(3, caster)


end

function getUniqueValuesInTable(table)
	local hash = {}
	local res = {}

	for _,v in ipairs(table) do
	   if (not hash[v]) then
	       res[#res+1] = v -- you could print here instead of saving to result table if you wanted
	       hash[v] = true
	   end

	end
	return res
end

function cooldownEnd(event)
	local ability = event.ability
	local caster = event.caster
	local level = caster:FindAbilityByName("odachi_rush"):GetLevel()
  	ability:SetLevel(level)
  	caster:SwapAbilities("seinaru_odachi_leap", "odachi_rush", true, false)	
end

function gust(caster, fv, ability, a_c_level)
	local start_radius = 200
	local end_radius = 200
	local range = a_c_level*15 + 470
	local casterOrigin = caster:GetAbsOrigin()
	local speed = 900
	local info = 
	{
			Ability = ability,
        	EffectName = "particles/units/heroes/hero_dragon_knight/monk_ulti.vpcf",
        	vSpawnOrigin = casterOrigin+fv*30+Vector(0,0,10),
        	fDistance = range,
        	fStartRadius = start_radius,
        	fEndRadius = end_radius,
        	Source = caster,
        	StartPosition = "attach_sword",
        	bHasFrontalCone = true,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 4.0,
		bDeleteOnHit = false,
		vVelocity = fv * speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)	
end

function gust_hit(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local damage = ability.e_1_damage
	if caster:HasModifier("modifier_seinaru_glyph_1_1") then
		damage = damage*1.4
	end
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })	
	ability:ApplyDataDrivenModifier(caster, target, "modifier_odachi_gust", {duration = 2})
end

function slice_think(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Hero_Juggernaut.PreAttack", caster)
	local casterOrigin = caster:GetAbsOrigin()
	-- caster:SetAbsOrigin(casterOrigin+Vector(0,0,30))
	local position = casterOrigin + caster:GetForwardVector()*160
	local radius = 180
	local damage = event.damage
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), GetGroundPosition(position, caster), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	local modifierKnockback =
	{
		center_x = casterOrigin.x,
		center_y = casterOrigin.y,
		center_z = casterOrigin.z,
		duration = 0.18,
		knockback_duration = 0.18,
		knockback_distance = 80,
		knockback_height = 15,
	}
      
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
			if ability.e_1_level > 0 then
				if #ability.e_1_unit_table < SEINARU_E1_TARGETS_BASE + SEINARU_E1_TARGETS * ability.e_1_level then
					table.insert(ability.e_1_unit_table, enemy:GetEntityIndex())
				end
			end
			DeepPrintTable(ability.e_1_unit_table)
			if damage then
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, 3, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)	
			end
		end
	end 	
end

function slice_lifting(event)
	local caster = event.caster
	local ability = event.ability
	ability.liftVelocity = ability.liftVelocity-2
	local position = caster:GetAbsOrigin() + Vector(0,0,ability.liftVelocity)
	
	
	newPosition = position+ability.forwardVector*34
	local obstruction = WallPhysics:FindNearestObstruction(newPosition)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (newPosition+ability.forwardVector*24), caster)
	if not blockUnit and not caster:HasModifier("modifier_tornado_slashing") then
		caster:SetOrigin(newPosition)
	end
end

function slice_falling(event)
	local caster = event.caster
	local ability = event.ability
	ability.fallVelocity = ability.fallVelocity + 2
	local position = caster:GetAbsOrigin() - Vector(0,0,ability.fallVelocity)

	newPosition = position+ability.forwardVector*34
	local obstruction = WallPhysics:FindNearestObstruction(newPosition)
	
	
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (newPosition+ability.forwardVector*24), caster)
	if not blockUnit then
		caster:SetOrigin(newPosition)
	else
		caster:SetOrigin(position)
	end
	if ability.lastZ == position.z then
		ability.repeatedZ = ability.repeatedZ + 1
	else
		ability.repeatedZ = 0
	end
	ability.lastZ = position.z
	if position.z - GetGroundPosition(position, caster).z < 26 then
		caster:RemoveModifierByName("modifier_odachi_falling")
	end
	if ability.repeatedZ >= 3 then
		caster:RemoveModifierByName("modifier_odachi_falling")
	end
end

function falling_end(event)
	local caster = event.caster
	local ability = event.ability
	WallPhysics:ClearSpaceForUnit(caster, caster:GetAbsOrigin())
	if ability.e_3_level > 0 then
		switchToSpiral(caster, ability)	
	end
	if caster:HasModifier("modifier_falcon_boots") then
		if caster.foot.liftedTargetsTable then
			ability.e_1_unit_table = {"length"}
		end
	end
	if #ability.e_1_unit_table > 0 then
		ability.e_1_particleTable = {}
		ability.movespeed = 50
		ability.particle = true
		-- "modifier_falcon_boots"
		if caster:HasModifier("modifier_falcon_boots") then

			caster.foot:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_falcon_freeze_self", {duration = 2.5})
			Timers:CreateTimer(2.5, function()
				ability.e_1_unit_table = {}
				for i = 1, #caster.foot.liftedTargetsTable, 1 do
					if #ability.e_1_unit_table < (1 + ability.e_1_level) then
						table.insert(ability.e_1_unit_table, caster.foot.liftedTargetsTable[i]:GetEntityIndex())
					end
				end
				if #ability.e_1_unit_table > 0 then
					ability.startPosition = caster.foot.transportLocation
					ability:ApplyDataDrivenModifier(caster, caster, "modifier_seinaru_a_c_dbz", {duration = 0.1})
					ability:ApplyDataDrivenModifier(caster, caster, "modifier_seinaru_a_c_dbz_attack_power", {duration = 10})
					caster:SetModifierStackCount("modifier_seinaru_a_c_dbz_attack_power", caster, ability.e_1_level)
				end
			end)
		else
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_seinaru_a_c_dbz", {duration = 0.1})
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_seinaru_a_c_dbz_attack_power", {duration = 8})
			ability.startPosition = caster:GetAbsOrigin()
			caster:SetModifierStackCount("modifier_seinaru_a_c_dbz_attack_power", caster, ability.e_1_level)
		end
	else
		if ability.e_2_level > 0 then
			local b_c_duration = Filters:GetAdjustedBuffDuration(caster, 2.5, false)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_seinaru_b_c_wakizashi", {duration = b_c_duration})
		end
	end
	caster.EFV = nil
	-- Timers:CreateTimer(0.7, function()
	-- 	caster:RemoveModifierByName("modifier_rune_e_3")
	-- end)
end

function switchToSpiral(caster, ability)
  	local spiral = caster:FindAbilityByName("seinaru_spiral_leap")
  	if not spiral then
  		spiral = caster:AddAbility("seinaru_spiral_leap")
  	end
  	spiral:SetLevel(ability:GetLevel())
  	spiral:SetAbilityIndex(2)
  	spiral.e_3_level = ability.e_3_level
  	caster:SwapAbilities("seinaru_odachi_leap", "seinaru_spiral_leap", false, true)	
end

function c_c_think(event)
	local ability = event.ability
	local caster = event.target
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 280, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	local damage = ability.e_3_level*400 + 400
	damage = damage + 0.0003*caster:GetAgility()/10*ability.e_4_level*damage
	for _,enemy in pairs(enemies) do
		Filters:ApplyDamageBasic(enemy,caster,damage,DAMAGE_TYPE_PHYSICAL)
		-- ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL })
	end
	if #enemies > 0 then
		EmitSoundOn("Hero_Juggernaut.Attack", caster)
	else
		EmitSoundOn("Hero_Juggernaut.PreAttack", caster)
	end
end

function hikari_heal_c_c(event)
	local ability = event.ability
	local caster = event.caster
	local position = caster:GetAbsOrigin()
	local ampFactor = 0.5*ability.e_3_level
	EmitSoundOn("Hero_Warlock.ShadowWordCastGood", caster)
	local hikariAbility = caster:FindAbilityByName("seinaru_hands_of_hikari")
	local radius = hikariAbility:GetSpecialValueFor("radius")
	local heal = hikariAbility:GetSpecialValueFor("heal")
	local allies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #allies > 0 then
		for _,ally in pairs(allies) do
			ally:RemoveModifierByName("modifier_seinaru_hands_of_hikari_effect")
			hikariAbility:ApplyDataDrivenModifier(caster, ally, "modifier_seinaru_hands_of_hikari_effect", {})
			local healAmount = heal*ampFactor
			Filters:ApplyHeal(caster, ally, healAmount, true)
		end
	end  

end

function odachi_rush(event)
	local caster = event.caster
	local ability = event.ability
	local searchPosition = event.caster:GetAbsOrigin() + event.caster:GetForwardVector()*330
	local searchRadius = 350
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), searchPosition, nil, searchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_FARTHEST, false )
	if #enemies > 0 then
		local enemy = enemies[1]
		FindClearSpaceForUnit(caster, enemy:GetAbsOrigin()+RandomVector(20), false)
		local newFV = (caster:GetAbsOrigin() - enemy:GetAbsOrigin()):Normalized()
		caster:SetForwardVector(Vector(newFV.x, newFV.y))
		StartAnimation(caster, {duration=0.2, activity=ACT_DOTA_ATTACK, rate=2, translate="odachi"})
		EmitSoundOn("Hero_Juggernaut.Attack", caster)
		ability:ApplyDataDrivenModifier(caster, enemy, "modifier_odachi_rush", {duration = 0.4})
		local damage = ability.e_2_level*0.1*caster:GetAverageTrueAttackDamage()
		Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, 3, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)

		local playerID = caster:GetPlayerOwnerID()
		local particleName = "particles/frostivus_herofx/juggernaut_fs_omnislash_tgt.vpcf"
		local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, enemy )
		ParticleManager:SetParticleControlEnt(pfx, 0, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
		PlayerResource:SetCameraTarget(playerID, caster)
		Timers:CreateTimer(0.1, function()
			PlayerResource:SetCameraTarget(playerID, nil)
		end)
		Timers:CreateTimer(0.7, function() 
		  ParticleManager:DestroyParticle( pfx, false )
		end) 	

		
	end
end

function odachi_a_c_think(event)
	local caster = event.caster
	local ability = event.ability
	local buff = caster:FindModifierByName("modifier_seinaru_a_c_dbz")
	if not buff then
		return false
	end
	buff:SetDuration(0.1, false)
	if #ability.e_1_unit_table > 0 then
		local target = EntIndexToHScript(ability.e_1_unit_table[1])
		local distance = 0
		if IsValidEntity(target) then
			distance = WallPhysics:GetDistance(caster:GetAbsOrigin(), target:GetAbsOrigin())
			if not target:IsAlive() then
				local newTable = {}
				for i = 2, #ability.e_1_unit_table, 1 do
					table.insert(newTable, ability.e_1_unit_table[i])
				end
				ability.e_1_unit_table = newTable
				-- caster:SetAbsOrigin(caster:GetAbsOrigin()+RandomVector(RandomInt(80, 200))+Vector(0,0,RandomInt(140, 380)))
				if #ability.e_1_unit_table <= 1 then
					end_eagle_strike(ability, caster)
				end
				return
			end
		else
			local newTable = {}
			for i = 2, #ability.e_1_unit_table, 1 do
				table.insert(newTable, ability.e_1_unit_table[i])
			end
			ability.e_1_unit_table = newTable
			-- caster:SetAbsOrigin(caster:GetAbsOrigin()+RandomVector(RandomInt(80, 200))+Vector(0,0,RandomInt(140, 380)))
			if #ability.e_1_unit_table <= 1 then
				end_eagle_strike(ability, caster)
			end
			return
		end
		if distance <= ability.movespeed + 5 then
			ability.particle = true
			DeepPrintTable(ability.e_1_unit_table)
			-- CustomAbilities:QuickAttachParticle("particles/econ/items/riki/riki_immortal_ti6/riki_immortal_ti6_blinkstrike_gold.vpcf", target, 1.5)	
			local particleName = "particles/econ/items/riki/riki_immortal_ti6/riki_immortal_ti6_blinkstrike_gold.vpcf"
			local pfx = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, target )
			ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx, 2, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			-- for i = 3, 9, 1 do
			-- 	ParticleManager:SetParticleControl(pfx, i, Vector(200,200,200))
			-- end
			Timers:CreateTimer(1.5, function() 
			  ParticleManager:DestroyParticle( pfx, false )
			end)
			if ability.r_1_level > 0 then
				if caster:HasAbility("gorudo") then
					apply_a_d(caster, target, caster:FindAbilityByName("gorudo"), ability.r_1_level, ability.e_4_level) 
				end
			end	
			caster:PerformAttack(target, true, true, true, true, false, false, false)
			if caster:HasModifier("modifier_seinaru_glyph_3_1") then
				local glyphDamage = caster:GetAverageTrueAttackDamage(caster) * SEINARU_GLYPH3_DMG_PER_ATT
				ApplyDamage({ victim = target, attacker = caster, damage = glyphDamage, damage_type = DAMAGE_TYPE_MAGICAL })	
			end
			EmitSoundOn("Seinaru.AChit", target)	
			if #ability.e_1_unit_table >= 2 then
				local newTable = {}
				for i = 2, #ability.e_1_unit_table, 1 do
					table.insert(newTable, ability.e_1_unit_table[i])
				end
				ability.e_1_unit_table = newTable
				caster:SetAbsOrigin(caster:GetAbsOrigin()+RandomVector(RandomInt(340, 500))+Vector(0,0,RandomInt(20, 280)))
				EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Seinaru.ACStartDash", caster)
				StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_OVERRIDE_ABILITY_4, rate=1.2})
				ability.movespeed = 65
			else
				end_eagle_strike(ability, caster)
			end
			if #ability.e_1_particleTable >= 5 then
				ParticleManager:DestroyParticle(ability.e_1_particleTable[1], false)
				local newTable = {}
				for i = 2, #ability.e_1_particleTable, 1 do
					table.insert(newTable, ability.e_1_particleTable[i])
				end
				ability.e_1_particleTable = newTable
			end
		else
			local pfx = nil
			if ability.particle then
				local particleName = "particles/roshpit/seinaru/seinaru_e1_bands_beam_blade_golden.vpcf"
				pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
				ability.particle = false
				ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()+Vector(0,0,100))
				table.insert(ability.e_1_particleTable, pfx)
			else
				pfx = ability.e_1_particleTable[#ability.e_1_particleTable]
			end
			if pfx then
				ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin()+Vector(0,0,100)+caster:GetForwardVector()*ability.movespeed*2)
			end
			local fv = (target:GetAbsOrigin()-caster:GetAbsOrigin()):Normalized()
			caster:SetForwardVector(fv)
			caster:SetAbsOrigin(caster:GetAbsOrigin()+fv*ability.movespeed)
			ability.movespeed = ability.movespeed + 5
		end
	else
		caster:RemoveModifierByName("modifier_seinaru_a_c_dbz")
	end
end

function end_eagle_strike(ability, caster)
	EndAnimation(caster)
	caster:RemoveModifierByName("modifier_seinaru_a_c_dbz")
	caster:RemoveModifierByName("modifier_seinaru_a_c_dbz_attack_power")
	Timers:CreateTimer(0.1, function()
		caster:SetForwardVector(ability.forwardVector*Vector(1,1,0))
		FindClearSpaceForUnit(caster, ability.startPosition, false)
	end)
	Timers:CreateTimer(1, function()
		for i = 1, #ability.e_1_particleTable, 1 do
			ParticleManager:DestroyParticle(ability.e_1_particleTable[i], false)
		end
		ability.e_1_particleTable = {}
	end)
	if ability.e_2_level > 0 then
		local b_c_duration = Filters:GetAdjustedBuffDuration(caster, 2, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_seinaru_b_c_wakizashi", {duration = b_c_duration})
	end
end

function wakizashi_think(event)
	local caster = event.caster
	local ability = event.ability
	local particleName = "particles/econ/items/juggernaut/jugg_sword_jade/juggernaut_blade_fury_jade.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(pfx, 5, Vector(200, 200, 200))
	Timers:CreateTimer(0.5, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	end) 
	StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_OVERRIDE_ABILITY_1, rate=1.0})
	caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	-- local modifierKnockback =
	-- {
	-- 	center_x = casterOrigin.x,
	-- 	center_y = casterOrigin.y,
	-- 	center_z = casterOrigin.z,
	-- 	duration = 0.18,
	-- 	knockback_duration = 0.18,
	-- 	knockback_distance = 80,
	-- 	knockback_height = 15,
	-- }
    local damage = caster:GetAverageTrueAttackDamage(caster) * (SEINARU_E2_DMG_PER_ATT_BASE + ability.e_2_level * SEINARU_E2_DMG_PER_ATT)
	if #enemies > 0 then
		EmitSoundOn("Hero_Juggernaut.Attack", caster)
		if #enemies > 6 then
			EmitSoundOn("Hero_Juggernaut.Attack", caster)
		end
		if #enemies > 10 then
			EmitSoundOn("Hero_Juggernaut.Attack", caster)
		end
		for _,enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, 3, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
		end
	end 
	hikari_heal(caster, caster:GetAbsOrigin(), caster:FindAbilityByName("seinaru_hands_of_hikari"), SEINARU_E2_W_MULT * ability.e_2_level)			
end

function wakizashi_end(event)
	local caster = event.caster
	local ability = event.ability
	caster:RemoveGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
	if caster:HasModifier("modifier_seinaru_glyph_7_1") then
		local glyph_duration = Filters:GetAdjustedBuffDuration(caster, SEINARU_GLYPH7_DUR, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_seinaru_glyph_7_1_effect", {duration = glyph_duration})
	end
end