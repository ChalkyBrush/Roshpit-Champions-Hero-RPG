SORCERESS_D_B_FACTOR = 0.01

function begin_explosion(event)
	local caster = event.caster
	local ability = event.ability
	ability.rune_b_b_level = rune_b_b(caster, ability)
	StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_CAST_ABILITY_1, rate=2.4})
	rune_b_a(caster, ability)
	rune_a_b(caster, ability, event.damage)
	-- rune_c_d(caster, ability)
	Filters:CastSkillArguments(2, caster)
	ability.damage = event.damage
	caster.d_a_level = Runes:GetTotalRuneLevel(caster, 4, "d_a", "sorceress")
	local d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "sorceress")
	if d_b_level > 0 then
		local currentStacks = caster:GetModifierStackCount("modifier_arcane_enchantment", caster)
		local addedStacks = 3-currentStacks
		local manaDrain = caster:GetMaxMana()*0.1*addedStacks
		local blinkAbility = caster:FindAbilityByName("sorceress_blink")
		blinkAbility.d_b_amp = ((caster:GetMaxMana()*0.1)/100)*SORCERESS_D_B_FACTOR*d_b_level
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_arcane_enchantment", {duration = 8})
		caster:ReduceMana(manaDrain)
		caster:SetModifierStackCount("modifier_arcane_enchantment", caster, 3)
	end

	local radius = event.radius
      local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
      local particle2 = ParticleManager:CreateParticle( particleNameS, PATTACH_WORLDORIGIN, caster )
      ParticleManager:SetParticleControl( particle2, 0, caster:GetAbsOrigin() )
      ParticleManager:SetParticleControl( particle2, 1, Vector(radius,radius,radius) )
      ParticleManager:SetParticleControl( particle2, 2, Vector(1.1, 1.1, 1.1) )
      if not caster:HasModifier("modifier_ice_avatar") then
      	ParticleManager:SetParticleControl( particle2, 4, Vector(255, 90, 255) )
      else
      	ParticleManager:SetParticleControl( particle2, 4, Vector(90, 130, 255) )
      end
      Timers:CreateTimer(1.5, 
      function()
        ParticleManager:DestroyParticle( particle2, false )
      end)
end

function explosion_apply_damage(event)
	print('apply_damage')
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = ability.damage
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_ARCANE, RPC_ELEMENT_NONE)
	if ability.rune_b_b_level > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_sorceress_rune_b_b_invisible", {duration = 9})
		ability:ApplyDataDrivenModifier(caster, target, "modifier_sorceress_rune_b_b", {duration = 9})
		local newStacks = math.min(target:GetModifierStackCount("modifier_sorceress_rune_b_b", caster) + 1, 10)
		target:SetModifierStackCount("modifier_sorceress_rune_b_b", ability, newStacks )
		target:SetModifierStackCount("modifier_sorceress_rune_b_b_invisible", ability, newStacks*ability.rune_b_b_level)
	end
end

function rune_b_a(caster, ability)
  local b_a_level = Runes:GetTotalRuneLevel(caster, 2, "b_a", "sorceress")
  local runeAbility = caster.runeUnit2:FindAbilityByName("sorceress_rune_b_a")
  if b_a_level > 0 and caster:HasModifier("modifier_frost_nova_ready") then
  	print("NOVA TIME!")
  	runeAbility:ApplyDataDrivenModifier(caster.runeUnit2, caster, "modifier_frost_nova_down", {duration = 10})
  	caster:RemoveModifierByName("modifier_frost_nova_ready")
  	frostNova(caster, ability, b_a_level)
  end
  if b_a_level > 0 and not caster:HasModifier("modifier_frost_nova_down") then
  	runeAbility:ApplyDataDrivenModifier(caster.runeUnit2, caster, "modifier_frost_nova_ready", {duration = 0.6})
  	print("APPLY READY")
  end

end

function rune_c_d(caster, ability)
  local runeUnit = caster.runeUnit3
  local runeAbility = runeUnit:FindAbilityByName("sorceress_rune_c_d")
  local abilityLevel = runeAbility:GetLevel()
  local bonusLevel = Runes:GetTotalBonus(runeUnit, "c_d")
  local totalLevel = abilityLevel + bonusLevel
  ability.rune_c_d_level = totalLevel
  if totalLevel > 0 and caster:HasModifier("modifier_ring_of_fire_up") then
  	caster:RemoveModifierByName("modifier_ring_of_fire_up")
  	ringOfFire(caster, ability, totalLevel)
  end
end

function rune_b_b(caster, ability)
  local runeUnit = caster.runeUnit2
  local runeAbility = runeUnit:FindAbilityByName("sorceress_rune_b_b")
  local abilityLevel = runeAbility:GetLevel()
  local bonusLevel = Runes:GetTotalBonus(runeUnit, "b_b")
  local totalLevel = abilityLevel + bonusLevel
  return totalLevel
end

function frostNova(caster, ability, totalLevel)
	local particleName = "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf"
      	local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
      	local origin = caster:GetAbsOrigin()
      	ParticleManager:SetParticleControl( particle1, 0, origin+Vector(0,0,20) )
      	ParticleManager:SetParticleControl( particle1, 1, Vector(550, 2, 1000) )
      	ParticleManager:SetParticleControl( particle1, 3, Vector(550, 550, 550) )
      	Timers:CreateTimer(3, function()
      		ParticleManager:DestroyParticle(particle1, false)
      	end)
      	EmitSoundOn("Sorceress.FrostNova", caster)
      	print("FROST NOVA!")
      	local radius = 550
      	local damage = totalLevel*3800 + 1000
	    -- local d_a_level = Runes:GetTotalRuneLevel(caster, 4, "d_a", "sorceress")
	    -- damage = damage + 0.0002*(caster:GetStrength()+caster:GetAgility()+caster:GetIntellect())/10*d_a_level*damage
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), origin, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		local freezeDuration = 3 + totalLevel*0.1
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_ICE, RPC_ELEMENT_NONE)
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_frost_nova", {duration = freezeDuration})
				print('Applied frost nova')
			end
		end 
		if caster.waterElemental then
			local elementalOrigin = caster.waterElemental:GetAbsOrigin()
			local heroDistance = WallPhysics:GetDistance(elementalOrigin, origin)
			local enemies2 = FindUnitsInRadius( caster:GetTeamNumber(), elementalOrigin, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			if #enemies2 > 0 then
				for _,enemy in pairs(enemies2) do
					Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_ICE, RPC_ELEMENT_NONE)
					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_frost_nova", {duration = freezeDuration})
				end
			end 
	      	local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	      	local origin = caster:GetAbsOrigin()
	      	ParticleManager:SetParticleControl( particle2, 0, elementalOrigin+Vector(0,0,20) )
	      	ParticleManager:SetParticleControl( particle2, 1, Vector(550, 2, 1000) )
	      	ParticleManager:SetParticleControl( particle2, 3, Vector(550, 550, 550) )
	      	Timers:CreateTimer(3, function()
	      		ParticleManager:DestroyParticle(particle2, false)
	      	end)
	      	if heroDistance > 1500 then
	      		EmitSoundOn("Sorceress.FrostNova", caster.waterElemental)
	      	end
		end
end

function ringOfFire(caster, ability, totalLevel)
	local particleName = "particles/units/heroes/hero_elder_titan/ring_of_fire.vpcf"
      	local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
      	local origin = caster:GetAbsOrigin()
      	ParticleManager:SetParticleControl( particle1, 0, origin+Vector(0,0,200) )
      	ParticleManager:SetParticleControl( particle1, 1, Vector(300,300,300) )
      	ParticleManager:SetParticleControl( particle1, 2, Vector(300,300,300) )
      	ParticleManager:SetParticleControl( particle1, 3, Vector(300,300,300) )
      	ParticleManager:SetParticleControl( particle1, 4, Vector(300,300,300) )
      	ParticleManager:SetParticleControl( particle1, 5, Vector(300,300,300) )
      	ParticleManager:SetParticleControl( particle1, 6, Vector(300,300,300) )
      	ParticleManager:SetParticleControl( particle1, 7, Vector(300,300,300) )
      	ParticleManager:SetParticleControl( particle1, 8, Vector(300,300,300) )
      	ParticleManager:SetParticleControl( particle1, 9, Vector(300,300,300) )
      	EmitSoundOn("Ability.LightStrikeArray", caster)
      	print("Ring of Fire")
      	local radius = 600
      	local damage = totalLevel*200 + 300

	    local d_d_level = Runes:GetTotalRuneLevel(caster, 4, "d_d", "sorceress")
	    damage = damage + 0.0001*(caster:GetStrength()+caster:GetAgility()+caster:GetIntellect())/10*d_d_level*damage

		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), origin, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_ring_of_fire_ignite", {duration = 4})
			end
		end 
end

function ring_of_fire_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = 40*ability.rune_c_d_level
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
end

function rune_a_b(caster, ability, damage)
  local runeUnit = caster.runeUnit
  local runeAbility = runeUnit:FindAbilityByName("sorceress_rune_a_b")
  local abilityLevel = runeAbility:GetLevel()
  local bonusLevel = Runes:GetTotalBonus(runeUnit, "a_b")
  local totalLevel = abilityLevel + bonusLevel
  if totalLevel > 0 then
  	local duration = 1.2 + 0.1*totalLevel
  	duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
  	runeAbility:ApplyDataDrivenModifier(runeUnit, caster, "modifier_arcane_shell", {duration = duration})
  	caster:SetModifierStackCount("modifier_arcane_shell", runeUnit, 2)
  	-- arcaneMissles(caster, ability, totalLevel, damage)
  end	
end

function arcaneMissles(caster, ability, totalLevel, damage)
	local centerPoint = caster:GetAbsOrigin() + caster:GetForwardVector()*440
	local radius = 480
	local numMissles = 1
	ability.damage = (damage*totalLevel*0.05 + 60 + 14*totalLevel)/numMissles
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), centerPoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			local info = 
			{
				Target = enemy,
				Source = caster,
				Ability = ability,	
				EffectName = "particles/units/heroes/hero_leshrac/leshrac_base_attack.vpcf",
				StartPosition = "attach_staff_tip",
				bDrawsOnMinimap = false, 
			        bDodgeable = true,
			        bIsAttack = false, 
			        bVisibleToEnemies = true,
			        bReplaceExisting = false,
			        flExpireTime = GameRules:GetGameTime() + 4,
				bProvidesVision = false,
				iVisionRadius = 0,
				iMoveSpeed = 800,
				iVisionTeamNumber = caster:GetTeamNumber()
			}
			for i = 1, numMissles, 1 do
				projectile = ProjectileManager:CreateTrackingProjectile(info)
				Timers:CreateTimer(0.15*i, function()
					projectile = ProjectileManager:CreateTrackingProjectile(info)
				end)
			end
			-- ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
		end
	end 
end

function missleStrike(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	ApplyDamage({ victim = target, attacker = caster, damage = ability.damage, damage_type = DAMAGE_TYPE_MAGICAL })
	if ability.rune_b_b_level > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_sorceress_rune_b_b_invisible", {duration = 9})
		ability:ApplyDataDrivenModifier(caster, target, "modifier_sorceress_rune_b_b", {duration = 9})
		local newStacks = math.min(target:GetModifierStackCount("modifier_sorceress_rune_b_b", caster) + 1, 10)
		target:SetModifierStackCount("modifier_sorceress_rune_b_b", ability, newStacks )
		target:SetModifierStackCount("modifier_sorceress_rune_b_b_invisible", ability, newStacks*ability.rune_b_b_level)
	end
end

function intellect_think(event)
	local caster = event.target
	local ability = event.ability
	  local runeUnit = caster.runeUnit3
	  local runeAbility = runeUnit:FindAbilityByName("sorceress_rune_c_b")
	  local abilityLevel = runeAbility:GetLevel()
	  local bonusLevel = Runes:GetTotalBonus(runeUnit, "c_b")
	  local totalLevel = abilityLevel + bonusLevel
	  print("are we thinking?")
	  if totalLevel > 0 then
		local allies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 750, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
		if #allies > 0 then
			for _,ally in pairs(allies) do
				if ally:GetUnitName() == "phoenix_nest_egg" then
				else
					print("ally does not = caster")
					runeAbility:ApplyDataDrivenModifier(runeUnit, ally, "modifier_arcane_intellect_effect", {duration = 2})
					ally:SetModifierStackCount( "modifier_arcane_intellect_effect", runeAbility, totalLevel )
				end
			end
		end  
	  end	
end

function start_arcane_torrent_channel(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	ability.target = target
	ability.a_b_level = Runes:GetTotalRuneLevel(caster, 1, "a_b", "sorceress")
	ability.b_b_level = Runes:GetTotalRuneLevel(caster, 2, "b_b", "sorceress")
	ability.d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "sorceress")
	rune_a_b(caster, ability, 0)
	local arcane_explosion_damage = caster:FindAbilityByName("arcane_explosion"):GetLevelSpecialValueFor("damage", ability:GetLevel())
	ability.base_damage = arcane_explosion_damage*10
end

function arcane_torrent_channel_end(event)
end

function arcane_torrent_channel_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = ability.target
	rune_a_b(caster, ability, 0)
	EmitSoundOn("Sorceress.ArcaneTorrentLaunch", caster)
	local info = 
	{
		Target = target,
		Source = caster,
		Ability = ability,	
		EffectName = "particles/units/heroes/hero_leshrac/leshrac_base_attack.vpcf",
		StartPosition = "attach_staff_tip",
		bDrawsOnMinimap = false, 
	        bDodgeable = true,
	        bIsAttack = false, 
	        bVisibleToEnemies = true,
	        bReplaceExisting = false,
	        flExpireTime = GameRules:GetGameTime() + 5,
		bProvidesVision = false,
		iVisionRadius = 0,
		iMoveSpeed = 800,
		iVisionTeamNumber = caster:GetTeamNumber()
	}

	local manaDrainPercent = 0.0033
	if ability.d_b_level > 0 then
		manaDrainPercent = 0.02
	end
	local manaDrain = math.min(caster:GetMaxMana()*manaDrainPercent, caster:GetMana())
	manaDrain = math.floor(manaDrain)
	caster:ReduceMana(manaDrain)
	ability.damage = ability.base_damage + (manaDrain/100)*0.003*ability.d_b_level*ability.base_damage

	projectile = ProjectileManager:CreateTrackingProjectile(info)
	if WallPhysics:GetDistance(caster:GetAbsOrigin(), target:GetAbsOrigin()) > 1800 then
		caster:RemoveModifierByName("modifier_channel_arcane_torrent")
	end
	local d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "sorceress")
	if d_b_level > 0 then
		local currentStacks = caster:GetModifierStackCount("modifier_arcane_enchantment", caster)
		local manaDrain = 0
		if currentStacks < 3 then
			manaDrain = caster:GetMaxMana()*0.1*addedStacks
			caster:ReduceMana(manaDrain)
		end
		local blinkAbility = caster:FindAbilityByName("sorceress_blink")
		blinkAbility.d_b_amp = ((caster:GetMaxMana()*0.1)/100)*SORCERESS_D_B_FACTOR*d_b_level
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_arcane_enchantment", {duration = 7})
		caster:SetModifierStackCount("modifier_arcane_enchantment", caster, math.min(3, currentStacks + 1))
	end
end

function arcane_torrent_projectile_hit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local damage = ability.damage
	if ability.b_b_level > 0 then
		-- local arcane_explosion = caster:FindAbilityByName("arcane_explosion")
		ability:ApplyDataDrivenModifier(caster, target, "modifier_sorceress_rune_b_b_invisible", {duration = 9})
		ability:ApplyDataDrivenModifier(caster, target, "modifier_sorceress_rune_b_b", {duration = 9})
		local newStacks = math.min(target:GetModifierStackCount("modifier_sorceress_rune_b_b", caster) + 1, 10)
		target:SetModifierStackCount("modifier_sorceress_rune_b_b", ability, newStacks )
		target:SetModifierStackCount("modifier_sorceress_rune_b_b_invisible", ability, newStacks*ability.b_b_level )
	end
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_ARCANE, RPC_ELEMENT_NONE)
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_oracle/duskbringer_c_a_heal_heal_core.vpcf", target, 0.5)
	
end

function arcane_intellect_apply(event)
	print(event.caster:GetUnitName())
	local hero = event.caster
	if event.caster:GetUnitName() == "rune_unit" then
		hero = event.caster.hero
	end
	

	local ability = event.ability
	  local runeUnit = hero.runeUnit3
	  local runeAbility = runeUnit:FindAbilityByName("sorceress_rune_c_b")
	  local abilityLevel = runeAbility:GetLevel()
	  local bonusLevel = Runes:GetTotalBonus(runeUnit, "c_b")
	  local totalLevel = abilityLevel + bonusLevel
	  runeAbility:ApplyDataDrivenModifier(hero, event.target, "modifier_arcane_intellect_visible", {})
	  event.target:SetModifierStackCount("modifier_arcane_intellect_visible", hero, totalLevel)
end

function arcane_enhancement_impact(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	EmitSoundOn("Hero_SkywrathMage.ArcaneBolt.Impact", target)
	if ability.d_b_damage then

	  local radius = 280
	  if ability.baseIndex == 4 then
	  	radius = 480
	  end
      local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
      local particle2 = ParticleManager:CreateParticle( particleNameS, PATTACH_WORLDORIGIN, caster )
      ParticleManager:SetParticleControl( particle2, 0, target:GetAbsOrigin() )
      ParticleManager:SetParticleControl( particle2, 1, Vector(radius,radius,radius) )
      ParticleManager:SetParticleControl( particle2, 2, Vector(2.0, 2.0, 2.0) )
      ParticleManager:SetParticleControl( particle2, 4, Vector(255, 90, 255) )
      Timers:CreateTimer(1.5, 
      function()
        ParticleManager:DestroyParticle( particle2, false )
      end)
      	local damage = ability.d_b_damage*ability.d_b_amp
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, ability.baseIndex, RPC_ELEMENT_ARCANE, RPC_ELEMENT_NONE)
			end
		end 
	end
	print("ARCANE ENHANCEMENT IMPACT")
end