function beginBlast(event)
	local caster = event.caster
	local ability = event.ability
	local radius = event.radius
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
	local abilityLevel = ability:GetLevel()
	local casterOrigin = caster:GetOrigin()
	local forwardVector = caster:GetForwardVector()
	local damage = event.damage
	--perpVector = perpendicularVector(forwardVector)
	d_b(caster,ability)
	rune_a_b(caster, ability)	
	local rune_b_b_level = rune_b_b_level(caster)
	if caster:HasModifier("modifier_epoch_glyph_3_1") then
		local centerLocation = casterOrigin + forwardVector*Vector(radius*(1),radius*(1),0)
		launchBlast(abilityLevel, caster, centerLocation, casterOrigin, damage, ability)
		local fortyFive = WallPhysics:rotateVector(forwardVector, math.pi/4)
		local otherFortyFive = WallPhysics:rotateVector(forwardVector, -math.pi/4)
		Timers:CreateTimer(0.1, function()
			local blastLoc = centerLocation+fortyFive*120
			launchBlast(abilityLevel, caster, blastLoc, casterOrigin, damage, ability)
			blastLoc = centerLocation+otherFortyFive*120
			launchBlast(abilityLevel, caster, blastLoc, casterOrigin, damage, ability)
		end)
		Timers:CreateTimer(0.2, function()
			if rune_b_b_level > 0 then
				local damage = damage + rune_b_b_level*200 + 300
				local blastLoc = centerLocation+fortyFive*240
				launch_b_b_blast(caster, blastLoc, casterOrigin, damage, ability)
				blastLoc = centerLocation+otherFortyFive*240
				launch_b_b_blast(caster, blastLoc, casterOrigin, damage, ability)
				blastLoc = centerLocation+forwardVector*240
				launch_b_b_blast(caster, blastLoc, casterOrigin, damage, ability)
			else
				local blastLoc = centerLocation+fortyFive*240
				launchBlast(abilityLevel, caster, blastLoc, casterOrigin, damage, ability)
				blastLoc = centerLocation+otherFortyFive*240
				launchBlast(abilityLevel, caster, blastLoc, casterOrigin, damage, ability)
				blastLoc = centerLocation+forwardVector*240
				launchBlast(abilityLevel, caster, blastLoc, casterOrigin, damage, ability)
			end
		end)
	else
		--phase1
		local centerLocation = casterOrigin + forwardVector*Vector(radius*(1),radius*(1),0)
		launchBlast(abilityLevel, caster, centerLocation, casterOrigin, damage, ability)

		--phase2
		  Timers:CreateTimer(0.25,
		  function()
		  	for i = 1, 2, 1 do
				local centerLocation = casterOrigin + forwardVector*Vector(radius*(i),radius*(i),0)
				launchBlast(abilityLevel, caster, centerLocation, casterOrigin, damage, ability)
			end
		  end)

		--phase3
		  Timers:CreateTimer(0.5,
		  function()
		  	for i = 1, 2, 1 do
		  		for j = -1, 1, 1 do
		  			local displacementVector = WallPhysics:rotateVector(forwardVector, math.pi/2*j)
		  			if displacementVector == forwardVector then
		  				displacementVector = Vector(0,0)
		  			end
					local centerLocation = casterOrigin + forwardVector*Vector(radius*(i),radius*(i),0) + displacementVector*radius
					launchBlast(abilityLevel, caster, centerLocation, casterOrigin, damage, ability)
				end
			end
			if rune_b_b_level > 0 then
				local centerLocation = casterOrigin + forwardVector*radius*3
				launch_b_b_blast(caster, centerLocation, casterOrigin, rune_b_b_level*200 + 300+damage, ability)
			end
		  end)	
	end
	Timers:CreateTimer(0.5,
	  function() 
		rune_c_b(caster, casterOrigin+forwardVector*400)
	end)
	Filters:CastSkillArguments(2, caster)
end

function d_b(caster, ability)
	local d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "epoch")
	if d_b_level > 0 then
		local manaDrain = caster:GetMaxMana()*0.05
		if caster:GetMana() < manaDrain then
			manaDrain = caster:GetMana()
		end
		caster:ReduceMana(manaDrain)
		ability.damageAmp = (manaDrain/100)*0.003*d_b_level + 1
	else
		ability.damageAmp = 1
	end
end

function rune_c_b(caster, blastLocation)
	local runeUnit = caster.runeUnit3
	local runeAbility = runeUnit:FindAbilityByName("epoch_rune_c_b")
	local abilityLevel = runeAbility:GetLevel()
	local bonusLevel = Runes:GetTotalBonus(runeUnit, "c_b")
	local totalLevel = abilityLevel + bonusLevel
	local radius = 380
	if totalLevel > 0 then
		local particleName =  "particles/radiant_fx/epoch_rune_c_b_ranged002_destroy.vpcf"
		local particleVector = blastLocation

		local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( pfx, 0, particleVector )
			Timers:CreateTimer(1, function() 
			  ParticleManager:DestroyParticle( pfx, false )
			  
			end)
		local damageBase = totalLevel*560  
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), blastLocation, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false )
		for _,unit in pairs(enemies) do
			local damage = damageBase
			if caster:HasModifier("modifier_time_blast_buff") then
				damage = damage * 2
			end
			damage = damage*ability.damageAmp
			Filters:TakeArgumentsAndApplyDamage(unit, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)
		end
	end
end

function launchBlast(abilityLevel, caster, targetPoint, casterOrigin, damage, ability)
    local particleName = "particles/units/heroes/hero_oracle/time_blast2hit.vpcf"
    local particleVector = targetPoint
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
  	ParticleManager:SetParticleControl( pfx, 0, targetPoint+Vector(0,0,50) )
  	EmitSoundOn("Hero_Leshrac.Diabolic_Edict", caster)
	  if caster:HasModifier("modifier_time_blast_buff") then
	  	caster:RemoveModifierByName("modifier_time_blast_buff")
	  	damage = damage*2
	  end
	damage = damage*ability.damageAmp
  	Timers:CreateTimer(0.2, function()
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), targetPoint, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)
				if ability.rune_a_b_level > 0 then
					caster:RemoveModifierByName("modifier_epoch_rune_a_b_effect")
					ability.rune_a_b_ability:ApplyDataDrivenModifier(ability.rune_a_b_unit, caster, "modifier_epoch_rune_a_b_effect", {duration = 0.5})
					caster:GiveMana(ability.rune_a_b_level*4)
					PopupMana(caster, ability.rune_a_b_level*4)
				end
			end
		end 
  	end)
	Timers:CreateTimer(2, function() 
		ParticleManager:DestroyParticle( pfx, false )
	end)	

end

function launch_b_b_blast(caster, targetPoint, casterOrigin, damage, ability)
    local particleName = "particles/units/heroes/hero_oracle/oracle_purifyingflames_hit.vpcf"
    local particleVector = targetPoint
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
  	ParticleManager:SetParticleControl( pfx, 0, targetPoint+Vector(0,0,50) )
  	EmitSoundOn("Hero_ObsidianDestroyer.AstralImprisonment.Cast", caster)
	  if caster:HasModifier("modifier_time_blast_buff") then
	  	caster:RemoveModifierByName("modifier_time_blast_buff")
	  	damage = damage*2
	  end
	damage = damage*ability.damageAmp
  	Timers:CreateTimer(0.2, function()
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), targetPoint, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)
			end
		end 
  	end)
	Timers:CreateTimer(2, function() 
		ParticleManager:DestroyParticle( pfx, false )
	end)	

end

function rune_a_b(caster, ability)
  local runeUnit = caster.runeUnit
  local runeAbility = runeUnit:FindAbilityByName("epoch_rune_a_b")
  local abilityLevel = runeAbility:GetLevel()
  local bonusLevel = Runes:GetTotalBonus(runeUnit, "a_b")
  local totalLevel = abilityLevel + bonusLevel
  ability.rune_a_b_ability = runeAbility
  ability.rune_a_b_level = totalLevel
  ability.rune_a_b_unit = runeUnit
  return totalLevel

end

function rune_b_b_level(caster)
  local runeUnit = caster.runeUnit2
  local runeAbility = runeUnit:FindAbilityByName("epoch_rune_b_b")
  local abilityLevel = runeAbility:GetLevel()
  local bonusLevel = Runes:GetTotalBonus(runeUnit, "b_b")
  local totalLevel = abilityLevel + bonusLevel
  return totalLevel
end

function applyBlastDamage(event)
	local caster = event.caster
	local ability = event.ability	

	local targetPoint = event.target_points[1]
	local radius = event.Radius
	local damage = event.Damage*caster.bonus

	damage = damage*ability.damageAmp

	EmitSoundOn("Hero_ObsidianDestroyer.EssenceAura", caster)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), targetPoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )

	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
		end
	end 
	if ability.rune_a_b_ability and (#enemies > 0) then
		  local abilityLevel = ability.rune_a_b_ability:GetLevel()
		  local bonusLevel = Runes:GetTotalBonus(ability.orig_caster.runeUnit, "a_b")
		  local totalLevel = abilityLevel + bonusLevel
		  if totalLevel > 0 then

	        ability.rune_a_b_ability:ApplyDataDrivenModifier(runeUnit, ability.orig_caster, "modifier_epoch_rune_a_b", {})
	        local current_stack = ability.orig_caster:GetModifierStackCount( "modifier_epoch_rune_a_b", ability )
	        ability.orig_caster:SetModifierStackCount( "modifier_epoch_rune_a_b", ability.rune_a_b, current_stack+#enemies )
	        if ((current_stack+#enemies) > (800-totalLevel*20)) then
	        	EmitSoundOn("DOTA_Item.Refresher.Activate", ability.orig_caster)
	        	ability.rune_a_b_ability:ApplyDataDrivenModifier(runeUnit, ability.orig_caster, "modifier_epoch_rune_a_b_effect", {})
	        	ability.orig_caster:RemoveModifierByName("modifier_epoch_rune_a_b")
	        	refresh_particle(ability.orig_caster)
	    	end
		  end
	end

end

function refresh_particle(caster)
	  for i = 0, 3, 1 do
	  	local ab = caster:GetAbilityByIndex(i)
	  	ab:EndCooldown()
	  end
end

function perpendicularVector(vector)
	x = vector.x
	y = -vector.y

	return Vector(y, x)
end