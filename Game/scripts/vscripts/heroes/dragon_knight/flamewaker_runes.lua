function a_a_think(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	if hero:GetHealth() <= hero:GetMaxHealth()*1.1 then
		if hero.runeUnit:HasAbility("flamewaker_rune_a_a") then
			local a_a_level = Runes:GetTotalRuneLevel(hero, 1, "a_a", "flamewaker")
			if a_a_level > 0 then
				ability:ApplyDataDrivenModifier(caster, hero, "modifier_flamewaker_rune_a_a", {})
				hero:SetModifierStackCount("modifier_flamewaker_rune_a_a", ability, a_a_level )
			else
				hero:RemoveModifierByName("modifier_flamewaker_rune_a_a")
			end
		else
			hero:RemoveModifierByName("modifier_flamewaker_rune_a_a")
		end
	else
		hero:RemoveModifierByName("modifier_flamewaker_rune_a_a")
	end
end

function a_b_set_attacker(event)
	local ability = event.ability
	ability.attacker = event.attacker
end
function a_b(event)
	local caster = event.caster
	local ability = event.ability
	local damage = event.damage
	local target = event.target
	target:RemoveModifierByName("modifier_flamewaker_rune_a_b_burn")
	local abilityLevel = ability:GetLevel()
	local bonusLevels = Runes:GetTotalBonus(caster, "a_b")
	local totalLevel = bonusLevels + abilityLevel
	damage = damage * totalLevel + 50

	local damageTable = {
		victim = target,
		attacker = ability.attacker,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
	}
	 
	ApplyDamage(damageTable)	
end

function rune_b_a(event)
	local caster = event.caster
	local runeUnit = caster.runeUnit2
	local ability = runeUnit:FindAbilityByName("flamewaker_rune_b_a")
	if ability.b_a_level > 0 then
		local duration = Filters:GetAdjustedBuffDuration(caster, 5, false)
		ability.heal = ability.heal + ability.b_a_level*40
		ability:ApplyDataDrivenModifier(runeUnit, caster, "flamewaker_rune_b_a_heal_effect", {duration = duration})
	end

end

function b_a_modifier_think(event)
	local caster = event.target
	local ability = event.ability
	local amount = ability.heal
	Filters:ApplyHeal(caster, caster, amount, true)
	local seismicFlare = caster:FindAbilityByName("fire_blast")
	if seismicFlare.d_a_level > 0 then
		local duration = Filters:GetAdjustedBuffDuration(caster, 4, false)
		seismicFlare.d_a_ability:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_flamewaker_rune_d_a", {duration = duration})
	    local current_stack = caster:GetModifierStackCount( "modifier_flamewaker_rune_d_a", seismicFlare.d_a_ability )
	    local stackBonus = math.floor(amount*0.05*seismicFlare.d_a_level/10)
	    caster:SetModifierStackCount("modifier_flamewaker_rune_d_a", seismicFlare.d_a_ability, current_stack+stackBonus )
	end
end

function b_d(event)

	local caster = event.caster
	local ability = event.ability
	local heroName = caster:GetName()
	if heroName == "npc_dota_hero_dragon_knight" then
		local runeUnit = caster.runeUnit2
		local runeAbility = runeUnit:FindAbilityByName("flamewaker_rune_b_d")
		local abilityLevel = runeAbility:GetLevel()
		local bonusLevel = Runes:GetTotalBonus(runeUnit, "b_d")
		local totalLevel = abilityLevel + bonusLevel
		local fv = caster:GetForwardVector()
		ability.b_d_level = totalLevel
		ability.b_d_damage = ability.b_d_level*2000 + 2000
		if totalLevel > 0 then
			EmitSoundOn("Flamewaker.SecondHeartbeat", caster)
			for i = -24, 24, 1 do
				Timers:CreateTimer(0.05*(i+24), function()
					if (i+24)%6 == 0 then
						EmitSoundOn("Hero_Batrider.Firefly.Cast", caster)
					end
					local rotatedVector = WallPhysics:rotateVector(fv, math.pi/6*i)
					create_b_d_flame(caster:GetAbsOrigin(), caster, rotatedVector, totalLevel, ability)
				end)
			end
		end
	end
end

function create_b_d_flame(origin, caster, fv, totalLevel, ability)
	local start_radius = 120
	local end_radius = 200
	local range = 540
	local speed = 800
	local info = 
	{
			Ability = ability,
        	EffectName = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf",
        	vSpawnOrigin = origin,
        	fDistance = range,
        	fStartRadius = start_radius,
        	fEndRadius = end_radius,
        	Source = caster,
        	StartPosition = "attach_origin",
        	bHasFrontalCone = true,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
		vVelocity = fv * speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
end

function b_d_impact(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local damage = ability.b_d_damage
    if caster:HasModifier("modifier_flamewaker_glyph_5_1") then
    	damage = damage*2.5
    end
    Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
end

-- function b_d_create_replica(origin, caster, cataclysmLevel, runeUnit, ability)
-- 	local randomVector = origin + RandomVector(RandomInt(500, 700))
--   	local dummy = CreateUnitByName("flamewaker_copy", randomVector, true, caster, caster, caster:GetTeamNumber())
--     dummy.owner = caster:GetPlayerOwnerID()

--   	dummy:AddAbility("example_ability_two")
--   	dummy:AddAbility("replica")
--   	dummy:FindAbilityByName("replica"):SetLevel(1)
--   	ability:ApplyDataDrivenModifier(runeUnit, dummy, "modifier_flamewaker_rune_b_d_effect", {})
  	

--   	local blast = dummy:FindAbilityByName("example_ability_two")
--   	blast:SetLevel(cataclysmLevel)
-- 	local order =
-- 	{
-- 		UnitIndex = dummy:GetEntityIndex(),
-- 		OrderType =	DOTA_UNIT_ORDER_CAST_NO_TARGET,
-- 		AbilityIndex = blast:GetEntityIndex(),
-- 		Queue = true
-- 	}
-- 	ExecuteOrderFromTable(order)
-- 	  Timers:CreateTimer(3, -- Start this timer 10 game-time seconds later
-- 	  function()
--       UTIL_Remove(dummy)
-- 	  end)	
-- end

function a_d(event)
	local caster = event.caster
	local heroName = caster:GetName()
	if heroName == "npc_dota_hero_dragon_knight" then
		local runeUnit = caster.runeUnit
		local ability = runeUnit:FindAbilityByName("flamewaker_rune_a_d")
		local abilityLevel = ability:GetLevel()
		local bonusLevel = Runes:GetTotalBonus(runeUnit, "a_d")
		local totalLevel = abilityLevel + bonusLevel
		if totalLevel > 0 then
			local origin = caster:GetAbsOrigin()
		  	local dummy = CreateUnitByName("npc_dummy_unit", origin, true, caster, caster, caster:GetTeamNumber())
		  	dummy.owner = caster:GetPlayerOwnerID()
		  	dummy:NoHealthBar()
		  	dummy:AddAbility("dummy_unit")
		  	dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
		  	local blast = nil
		  	if totalLevel <= 20 then
		  		dummy:AddAbility("flamewaker_rune_a_d_meteor")
			  	blast = dummy:FindAbilityByName("flamewaker_rune_a_d_meteor")
			  	blast:SetLevel(abilityLevel)
		  	else
		  		dummy:AddAbility("flamewaker_rune_a_d_meteor_two")
			  	blast = dummy:FindAbilityByName("flamewaker_rune_a_d_meteor_two")
			  	blast:SetLevel(abilityLevel%20)	
		  	end
		  	local targetPoint = origin+caster:GetForwardVector()*200

		  	
			local order =
			{
				UnitIndex = dummy:GetEntityIndex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = blast:GetEntityIndex(),
				Position = targetPoint,
				Queue = true
			}
			ExecuteOrderFromTable(order)
			  Timers:CreateTimer(7, -- Start this timer 10 game-time seconds later
			  function()
				UTIL_Remove(dummy)
			  end)
		end

	end
	-- local caster = event.caster
	-- local ability = event.ability
	-- local projectileParticle = "particles/units/heroes/hero_invoker/invoker_chaos_meteor.vpcf"
	-- local fv = caster:GetForwardVector()
	-- local casterOrigin = caster:GetAbsOrigin()
	-- local range = 700
	-- local speed = 400
	-- local info = 
	-- {
	-- 		Ability = ability,
 --        	EffectName = projectileParticle,
 --        	vSpawnOrigin = casterOrigin,
 --        	fDistance = range,
 --        	fStartRadius = start_radius,
 --        	fEndRadius = end_radius,
 --        	Source = caster,
 --        	StartPosition = "attach_origin",
 --        	bHasFrontalCone = true,
 --        	bReplaceExisting = false,
 --        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
 --        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
 --        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
 --        	fExpireTime = GameRules:GetGameTime() + 5.0,
	-- 	bDeleteOnHit = false,
	-- 	vVelocity = fv * speed,
	-- 	bProvidesVision = false,
	-- }
	-- projectile = ProjectileManager:CreateLinearProjectile(info)
end

function rune_c_a_start(event)
	local caster = event.caster
	local ability = event.ability
	local delay = event.duration
	local runeUnit = caster.runeUnit3
	local runeAbility = runeUnit:FindAbilityByName("flamewaker_rune_c_a")
	local abilityLevel = runeAbility:GetLevel()
	local bonusLevel = Runes:GetTotalBonus(runeUnit, "c_a")
	ability.c_a_totalLevel = abilityLevel + bonusLevel
	if ability.c_a_totalLevel > 0 then
		ability.tauntDuration = ability.c_a_totalLevel*0.15 + 2.0
		print(ability.tauntDuration)
		ability.runeAbility = runeAbility
		ability.runeUnit = runeUnit
		runeAbility:ApplyDataDrivenModifier(runeUnit, caster, "flamewaker_rune_c_a_buff", {duration = ability.tauntDuration})
		caster:SetModifierStackCount( "flamewaker_rune_c_a_buff", runeAbility, ability.c_a_totalLevel )

	  	local particleName = "particles/units/heroes/hero_axe/axe_beserkers_call_owner.vpcf"
		local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, attacker)
		ParticleManager:SetParticleControl(lightningBolt,0,caster:GetAbsOrigin())	
	  	EmitSoundOn("dragon_knight_drag_anger_03", caster)
	  	EmitSoundOn("dragon_knight_drag_anger_03", caster)
		  Timers:CreateTimer(2.0, -- Start this timer 10 game-time seconds later
		  function()
		  	ParticleManager:DestroyParticle(lightningBolt, false)
		  end)
	 end

end

function rune_c_a(event)
	local ability = event.ability
	if ability.c_a_totalLevel then
		if ability.c_a_totalLevel > 0 then
			local caster = event.caster
			local stunDuration = event.duration
			local tauntDuration = ability.tauntDuration
			local target = event.target
			  Timers:CreateTimer(stunDuration, -- Start this timer 10 game-time seconds later
			  function()

			ability.runeAbility:ApplyDataDrivenModifier(runeUnit, target, "flamewaker_rune_c_a_taunt", {duration = tauntDuration})
			target:SetForceAttackTarget(caster)
			end)
		end
	end
end

function TauntEnd(event)
	local target = event.target
	target:Stop()
end

function c_d(event)

	local caster = event.caster
	local heroName = caster:GetName()
	local ability = event.ability
	if heroName == "npc_dota_hero_dragon_knight" then
		-- local runeUnit = caster.runeUnit3
		-- local ability = runeUnit:FindAbilityByName("flamewaker_rune_c_d")
		-- local abilityLevel = ability:GetLevel()
		-- local bonusLevel = Runes:GetTotalBonus(runeUnit, "c_d")
		-- local totalLevel = abilityLevel + bonusLevel

		-- if totalLevel > 0 then
		-- 	ability:ApplyDataDrivenModifier(runeUnit, caster, "modifier_flamewaker_rune_c_d", {duration = 6.0})
		-- 	caster:SetModifierStackCount( "modifier_flamewaker_rune_c_d", ability, totalLevel )		
		-- end
		local c_d_level = Runes:GetTotalRuneLevel(caster, 3, "c_d", "flamewaker")
		if c_d_level > 0 then
			local pfx = ParticleManager:CreateParticle("particles/roshpit/flamewaker/flamewaker_r3.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
			Timers:CreateTimer(5, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
			local duration = Filters:GetAdjustedBuffDuration(caster, 12, false)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_flamewaker_rune_c_d", {duration = duration})
			caster:SetModifierStackCount("modifier_flamewaker_rune_c_d", caster, c_d_level)
		end
	end
end

function flamewaker_think(event)
	local caster = event.caster
	local ability = event.ability
	ability.a_b_level = Runes:GetTotalRuneLevel(caster, 1, "a_b", "flamewaker")
	if ability.a_b_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_flamewaker_rune_a_b", {})
		caster:SetModifierStackCount( "modifier_flamewaker_rune_a_b", ability, ability.a_b_level )	
	end
end

function a_b_attack(event)
	local caster = event.attacker
	local target = event.target
	local ability = event.ability
	local damage = caster:GetAverageTrueAttackDamage(caster)*ability.a_b_level*0.04
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 420, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
	if #enemies > 0 then	
		for _,enemy in pairs(enemies) do
			if not enemy.dummy then
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, 2, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
				-- ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL })
				local particleName =  "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_explosion.vpcf"
				local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, enemy )
				ParticleManager:SetParticleControlEnt(pfx, 0, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
				Timers:CreateTimer(0.4, function() 
				  ParticleManager:DestroyParticle( pfx, false )
				end) 	
			end
		end				
	end 	
end

function a_d_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local a_d_level = Runes:GetTotalRuneLevel(caster, 1, "a_d", "flamewaker")
	if a_d_level > 0 then
		local luck = RandomInt(1,100)
		if luck <= 15 then
			if not target:IsNull() and not caster:HasModifier("modifier_flamewaker_a_d_crit_damage") and not caster:HasModifier("modifier_flamewaker_rune_d_b") then
				StartAnimation(caster, {duration=0.1, activity=ACT_DOTA_TELEPORT_END, rate=2})
				EmitSoundOn("Flamewaker.QuietShield", target)

				target:AddNewModifier(caster, nil, "modifier_stunned", {duration = 0.3})
				WallPhysics:Jump(caster, caster:GetForwardVector(), 0, 50, 6, 1.5)
				if target:GetModelScale() < 1.6 then
					WallPhysics:Jump(target, target:GetForwardVector(), 0, 50, 6, 1.5)
				end
				local damageStacks = a_d_level
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_flamewaker_a_d_crit_damage", {duration = 0.21})
				caster:SetModifierStackCount( "modifier_flamewaker_a_d_crit_damage", ability, damageStacks )
				Timers:CreateTimer(0.12, function()
					local particleName =  "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/flamewaker_crit.vpcf"
					local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		     	 	ParticleManager:SetParticleControl( pfx, 0, target:GetAbsOrigin()+Vector(0,0,40) )
					local pfx2 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		     	 	ParticleManager:SetParticleControl( pfx2, 0, target:GetAbsOrigin()+Vector(0,0,10) )
					Timers:CreateTimer(0.4, function() 
					  ParticleManager:DestroyParticle( pfx, false )
					  ParticleManager:DestroyParticle( pfx2, false )
					end) 	
					StartAnimation(caster, {duration=0.1, activity=ACT_DOTA_ATTACK, rate=3})
				end)	
				Timers:CreateTimer(0.18, function()
					EmitSoundOn("Flamewaker.SpecialCrit", target)
					caster:PerformAttack(target, true, true, false, true, false, false, false)
					local damageApprox = math.ceil(caster:GetAverageTrueAttackDamage(caster))
					PopupDamage(target, damageApprox)
				end)
			end
		end
	end
	
end

function d_b_burn_think(event)
	local target = event.target
	local caster = event.caster.hero
	local damage = target.flamewaker_d_c_burn
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 0, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
	
end

function flamewaker_passive_think(event)
	local caster = event.caster
	local d_d_level = Runes:GetTotalRuneLevel(caster, 4, "d_d", "flamewaker")
	caster.d_d_level = d_d_level
end