require('heroes/dragon_knight/flamewaker_constants')
function a_a_think(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	if hero:GetHealth() <= hero:GetMaxHealth()*1.1 then
		if hero.runeUnit:HasAbility("flamewaker_rune_q_1") then
			local q_1_level = Runes:GetTotalRuneLevel(hero, 1, "q_1", "flamewaker")
			if q_1_level > 0 then
				ability:ApplyDataDrivenModifier(caster, hero, "modifier_flamewaker_rune_q_1", {})
				hero:SetModifierStackCount("modifier_flamewaker_rune_q_1", ability, q_1_level )
			else
				hero:RemoveModifierByName("modifier_flamewaker_rune_q_1")
			end
		else
			hero:RemoveModifierByName("modifier_flamewaker_rune_q_1")
		end
	else
		hero:RemoveModifierByName("modifier_flamewaker_rune_q_1")
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
	target:RemoveModifierByName("modifier_flamewaker_rune_w_1_burn")
	local abilityLevel = ability:GetLevel()
	local bonusLevels = Runes:GetTotalBonus(caster, "w_1")
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

function rune_q_2(event)
	local caster = event.caster
	local runeUnit = caster.runeUnit2
	local ability = runeUnit:FindAbilityByName("flamewaker_rune_q_2")
	if ability.q_2_level > 0 then
		local duration = Filters:GetAdjustedBuffDuration(caster, 5, false)
		ability.heal = ability.heal + ability.q_2_level*40
		ability:ApplyDataDrivenModifier(runeUnit, caster, "flamewaker_rune_q_2_heal_effect", {duration = duration})
	end

end

function b_a_modifier_think(event)
	local caster = event.target
	local ability = event.ability
	local amount = ability.heal
	Filters:ApplyHeal(caster, caster, amount, true)
	local seismicFlare = caster:FindAbilityByName("seismic_flare")
	if seismicFlare.q_4_level > 0 then
		local duration = Filters:GetAdjustedBuffDuration(caster, 4, false)
		seismicFlare.q_4_ability:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_flamewaker_rune_q_4", {duration = duration})
	    local current_stack = caster:GetModifierStackCount( "modifier_flamewaker_rune_q_4", seismicFlare.q_4_ability )
	    local stackBonus = math.floor(amount*0.05*seismicFlare.q_4_level/10)
	    caster:SetModifierStackCount("modifier_flamewaker_rune_q_4", seismicFlare.q_4_ability, current_stack+stackBonus )
	end
end

function getCasterItemsTotalLevel(caster, lvl_100_as_lvl)
	if not lvl_100_as_lvl then
		lvl_100_as_lvl = 100
	end
	local total_level = 0
	--[evil laugh]
	local level = 0
	if caster.headItem and caster.headItem.newItemTable and caster.headItem.newItemTable.minLevel and type(caster.headItem.newItemTable.minLevel) == "number" then
		level = caster.headItem.newItemTable.minLevel
	end
	if level == 100 then
		level = lvl_100_as_lvl
	end
	total_level = total_level + level
	level = 0
	if caster.handItem and caster.handItem.newItemTable and caster.handItem.newItemTable.minLevel and type(caster.handItem.newItemTable.minLevel) == "number" then
		level = caster.handItem.newItemTable.minLevel
	end
	if level == 100 then
		level = lvl_100_as_lvl
	end
	total_level = total_level + level
	level = 0
	if caster.foot and caster.foot.newItemTable and caster.foot.newItemTable.minLevel and type(caster.foot.newItemTable.minLevel) == "number" then
		level = caster.foot.newItemTable.minLevel
	end
	if level == 100 then
		level = lvl_100_as_lvl
	end
	total_level = total_level + level
	level = 0
	if caster.weapon and caster.weapon.newItemTable and caster.weapon.newItemTable.minLevel and type(caster.weapon.newItemTable.minLevel) == "number" then
		level = caster.weapon.newItemTable.minLevel
	end
	if level == 100 then
		level = lvl_100_as_lvl
	end
	total_level = total_level + level
	level = 0
	if caster.amulet and caster.amulet.newItemTable and caster.amulet.newItemTable.minLevel and type(caster.amulet.newItemTable.minLevel) == "number" then
		level = caster.amulet.newItemTable.minLevel
	end
	if level == 100 then
		level = lvl_100_as_lvl
	end
	total_level = total_level + level
	level = 0
	if caster.body and caster.body.newItemTable and caster.body.newItemTable.minLevel and type(caster.body.newItemTable.minLevel) == "number" then
		level = caster.body.newItemTable.minLevel
	end
	if level == 100 then
		level = lvl_100_as_lvl
	end
	total_level = total_level + level
	print("[getCasterItemsTotalLevel] total_level:"..tostring(total_level))
	return total_level
end

function flamewaker_r_2(event)

	local caster = event.caster
	local ability = event.ability
	local heroName = caster:GetName()

	if not ability.cast_number then
		ability.cast_number = 0
	end

	ability.cast_number = ability.cast_number + 1

	if heroName == "npc_dota_hero_dragon_knight" then
		local r_2_level = caster:GetRuneValue("r",2)
		local fv = caster:GetForwardVector()
		ability.r_2_level = r_2_level
		ability.r_2_damage = ability.r_2_level * FLAMEWAKER_R2_SCALE * (FLAMEWAKER_R2_INNER_SCALE_BASE * getCasterItemsTotalLevel(caster, 110)) ^ FLAMEWAKER_R2_DMG_EXP_SCALE_BASE
		if r_2_level > 0 then
			EmitSoundOn("Flamewaker.SecondHeartbeat", caster)
			local count = 50

			if caster:HasModifier("modifier_flamewaker_glyph_5_1") then
				count = count*FLAMEWAKER_T51_R2_DUR_MULTIPLY
			end
			local cast_number = ability.cast_number
			for i = 0, count, 1 do
				Timers:CreateTimer(0.08*i, function()
					if caster:IsAlive() and ability.cast_number == cast_number then
						if i%2 == 0 then
							EmitSoundOn("Flamewaker.R2FlameSpiral", caster)
						end
						local rotatedVector = WallPhysics:rotateVector(fv, math.pi/5*i)
						flamewaker_r_2_create_flame(caster:GetAbsOrigin(), caster, rotatedVector, ability)
					end
				end)
			end
		end
	end
end

function flamewaker_r_2_create_flame(origin, caster, fv, ability)
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

function flamewaker_r_2_impact(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local damage = math.max(ability.r_2_damage, 10)
	for i = 1, FLAMEWAKER_R2_INSTANCE_OF_DAMAGE_COUNT, 1 do
		print(damage)
    	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
    end
end

function a_d(event)
	local caster = event.caster
	local heroName = caster:GetName()
	if heroName == "npc_dota_hero_dragon_knight" then
		local runeUnit = caster.runeUnit
		local ability = runeUnit:FindAbilityByName("flamewaker_rune_r_1")
		local abilityLevel = ability:GetLevel()
		local bonusLevel = Runes:GetTotalBonus(runeUnit, "r_1")
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
		  		dummy:AddAbility("flamewaker_rune_r_1_meteor")
			  	blast = dummy:FindAbilityByName("flamewaker_rune_r_1_meteor")
			  	blast:SetLevel(abilityLevel)
		  	else
		  		dummy:AddAbility("flamewaker_rune_r_1_meteor_two")
			  	blast = dummy:FindAbilityByName("flamewaker_rune_r_1_meteor_two")
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
			  Timers:CreateTimer(7, 			  function()
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

function rune_q_3_start(event)
	local caster = event.caster
	local ability = event.ability
	local delay = event.duration
	local runeUnit = caster.runeUnit3
	local runeAbility = runeUnit:FindAbilityByName("flamewaker_rune_q_3")
	local abilityLevel = runeAbility:GetLevel()
	ability.q_3_level = caster:GetRuneValue("q",3)
	if ability.q_3_level > 0 then
		ability.tauntDuration = ability.q_3_level*0.15 + 2.0
		print(ability.tauntDuration)
		ability.runeAbility = runeAbility
		ability.runeUnit = runeUnit
		runeAbility:ApplyDataDrivenModifier(runeUnit, caster, "flamewaker_rune_q_3_buff", {duration = ability.tauntDuration})
		caster:SetModifierStackCount( "flamewaker_rune_q_3_buff", runeAbility, ability.q_3_totalLevel )

	  	local particleName = "particles/units/heroes/hero_axe/axe_beserkers_call_owner.vpcf"
		local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, attacker)
		ParticleManager:SetParticleControl(lightningBolt,0,caster:GetAbsOrigin())	
	  	EmitSoundOn("dragon_knight_drag_anger_03", caster)
	  	EmitSoundOn("dragon_knight_drag_anger_03", caster)
		  Timers:CreateTimer(2.0, 		  function()
		  	ParticleManager:DestroyParticle(lightningBolt, false)
		  end)
	 end

end

function rune_q_3(event)
	local ability = event.ability
	if ability.q_3_totalLevel then
		if ability.q_3_totalLevel > 0 then
			local caster = event.caster
			local stunDuration = event.duration
			local tauntDuration = ability.tauntDuration
			local target = event.target
			  Timers:CreateTimer(stunDuration, 			  function()

			ability.runeAbility:ApplyDataDrivenModifier(runeUnit, target, "flamewaker_rune_q_3_taunt", {duration = tauntDuration})
			target:SetForceAttackTarget(caster)
			end)
		end
	end
end

function TauntEnd(event)
	local target = event.target
	target:Stop()
end

function flamewaker_r_3(event)

	local caster = event.caster
	local heroName = caster:GetName()
	local ability = event.ability
	if heroName == "npc_dota_hero_dragon_knight" then
		-- local runeUnit = caster.runeUnit3
		-- local ability = runeUnit:FindAbilityByName("flamewaker_rune_r_3")
		-- local abilityLevel = ability:GetLevel()
		-- local bonusLevel = Runes:GetTotalBonus(runeUnit, "r_3")
		-- local totalLevel = abilityLevel + bonusLevel

		-- if totalLevel > 0 then
		-- 	ability:ApplyDataDrivenModifier(runeUnit, caster, "modifier_flamewaker_rune_r_3", {duration = 6.0})
		-- 	caster:SetModifierStackCount( "modifier_flamewaker_rune_r_3", ability, totalLevel )		
		-- end
		local c_d_level = Runes:GetTotalRuneLevel(caster, 3, "r_3", "flamewaker")
		if c_d_level > 0 then
			local pfx = ParticleManager:CreateParticle("particles/roshpit/flamewaker/flamewaker_r3.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
			Timers:CreateTimer(5, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
			local duration = Filters:GetAdjustedBuffDuration(caster, 12, false)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_flamewaker_rune_r_3", {duration = duration})
			caster:SetModifierStackCount("modifier_flamewaker_rune_r_3", caster, c_d_level)
		end
	end
end

function flamewaker_think(event)
	local caster = event.caster
	local ability = event.ability
	ability.w_1_level = caster:GetRuneValue("w", 1)
	if ability.w_1_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_flamewaker_rune_w_1", {})
		caster:SetModifierStackCount( "modifier_flamewaker_rune_w_1", ability, ability.w_1_level )
	else
		caster:RemoveModifierByName("modifier_flamewaker_rune_w_1")
	end
end

function a_b_attack(event)
	local caster = event.attacker
	local target = event.target
	local ability = event.ability
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)*ability.w_1_level*FLAMEWAKER_W1_DMG_PER_ATT

	local w_3_level = caster:GetRuneValue("w", 3)
	local w_ability = caster:FindAbilityByName("second_heartbeat")

	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 420, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
	if #enemies > 0 then	
		for _,enemy in pairs(enemies) do
			if not enemy.dummy then
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, 2, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
				if caster:HasModifier('modifier_flamewaker_glyph_3_1') and w_ability then
					if w_3_level > 0 then
						local additional_armorLoss = math.ceil(1.0*w_3_level)
						w_ability:ApplyDataDrivenModifier(caster, enemy, "modifier_searing_heat", {duration = 6})
						local current_stack = enemy:GetModifierStackCount( "modifier_searing_heat", w_ability )
						local stacks = math.min(current_stack+additional_armorLoss, 10000)
						enemy:SetModifierStackCount( "modifier_searing_heat", w_ability, stacks )
					end
				end
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
	local a_d_level = Runes:GetTotalRuneLevel(caster, 1, "r_1", "flamewaker")
	if a_d_level > 0 then
		local luck = RandomInt(1,100)
		if luck <= 25 then
			if not target:IsNull() and not caster:HasModifier("modifier_flamewaker_a_d_crit_damage") and not caster:HasModifier("modifier_flamewaker_rune_w_4") then
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
					local damageApprox = math.ceil(OverflowProtectedGetAverageTrueAttackDamage(caster))
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
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_PHYSICAL, 0, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
	
end

function flamewaker_passive_think(event)
	local caster = event.caster
	local d_d_level = Runes:GetTotalRuneLevel(caster, 4, "r_4", "flamewaker")
	caster.r_4_level = d_d_level
end
