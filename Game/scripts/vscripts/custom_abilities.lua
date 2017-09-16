if CustomAbilities == nil then
  CustomAbilities = class({})
end

function CustomAbilities:UpdateAuriunCursorPosition(msg)
	local auriun = EntIndexToHScript(msg.auriun)
	auriun.cursorPos = Vector(msg.xPos, msg.yPos)
end

function CustomAbilities:GetAllAlliedHeroes(caster)
  local allyTable = {}
  for i = 1, #MAIN_HERO_TABLE, 1 do
  	if caster:GetTeamNumber() == MAIN_HERO_TABLE[i]:GetTeamNumber() then
  		table.insert(allyTable, MAIN_HERO_TABLE[i])
  	end
  end
  return allyTable
end

function CustomAbilities:AxeSunder(caster, ability, damage, damageAmp, particleName)
	local slamPoint = caster:GetAbsOrigin() + caster:GetForwardVector()*250
	CustomAbilities:AxeSunderB_D(ability, caster, slamPoint)
	EmitSoundOn("RedGeneral.Sunder", caster)
      -- particleName = "particles/units/heroes/hero_earthshaker/earthshaker_echoslam_start.vpcf"
      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
      ParticleManager:SetParticleControl( particle1, 0, slamPoint )
      Timers:CreateTimer(4, 
      function()
        ParticleManager:DestroyParticle( particle1, false )
      end)

    local d_d_level = Runes:GetTotalRuneLevel(caster, 4, "d_d", "axe")


	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), slamPoint, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage*damageAmp, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
			if d_d_level > 0 then
				local runeAbility = caster.runeUnit4:FindAbilityByName("axe_rune_d_d")
				runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, enemy, "modifier_axe_rune_d_d_visible", {duration = 7})
				local current_stacks = enemy:GetModifierStackCount( "modifier_axe_rune_d_d_visible", runeAbility )
				local newStacks = current_stacks + 1
				print(newStacks)
				enemy:SetModifierStackCount( "modifier_axe_rune_d_d_visible", runeAbility, newStacks )

				runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, enemy, "modifier_axe_rune_d_d_invisible", {duration = 7})
				enemy:SetModifierStackCount( "modifier_axe_rune_d_d_invisible", runeAbility, newStacks*d_d_level )
			end
		end
	end       
	
end

function CustomAbilities:AxeSunderB_D(sunderAbility, caster, slamPoint)
	local runeUnit = caster.runeUnit2
	local ability = runeUnit:FindAbilityByName("axe_rune_b_d")
	local abilityLevel = ability:GetLevel()
	local bonusLevel = Runes:GetTotalBonus(runeUnit, "b_d")
	local totalLevel = abilityLevel + bonusLevel
	ability.b_d_level = totalLevel
		local start_radius = 200
		local end_radius = 200
		local range = totalLevel*30+500
		local speed = 800
		local damage = totalLevel*50
		sunderAbility.damage = damage
		local fv = caster:GetForwardVector()
	if totalLevel > 0 then
		-- EmitSoundOn("Hero_Magnataur.ShockWave.Particle", caster)
		for i = 0, 8, 1 do
			fv = WallPhysics:rotateVector(fv, i*math.pi/4)
			local info = 
			{
					Ability = sunderAbility,
			    	EffectName = "particles/units/heroes/hero_magnataur/red_general_shockwave.vpcf",
			    	vSpawnOrigin = slamPoint,
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
	end
end

function CustomAbilities:HeroicLeapThink(target)
    local skullBasher = target:FindAbilityByName("stun_attack")
    skullBasher:ApplyDataDrivenModifier(target, target, "modifier_stun_attack", {duration = skullBasher:GetDuration()})
    if target:HasModifier("modifier_axe_rune_c_b_visible") then
        local runeUnit = target.runeUnit3
        local runeAbility = runeUnit:FindAbilityByName("axe_rune_c_b")
        local duration = Filters:GetAdjustedBuffDuration(caster, 4, false)
        runeAbility:ApplyDataDrivenModifier(runeUnit, target, "modifier_axe_rune_c_b_visible", {duration = duration})
        runeAbility:ApplyDataDrivenModifier(runeUnit, target, "modifier_axe_rune_c_b_invisible", {duration = duration})
    end
    if target:HasModifier("modifier_axe_rune_b_a_stacker") then
        local runeUnit = target.runeUnit2
        local runeAbility = runeUnit:FindAbilityByName("axe_rune_b_a")
        local duration = Filters:GetAdjustedBuffDuration(caster, 3, false)
        runeAbility:ApplyDataDrivenModifier(runeUnit, target, "modifier_axe_rune_b_a_stacker", {duration = duration})
    end
end

function CustomAbilities:IceQuill(event)

	local ability = event.ability
	if ability then
		local target = ability.hero
		if target then
			if target:HasModifier("modifier_ice_quill_carapace") then
				local executedAbility = event.event_ability
				if not ability.manaSpent then
					ability.manaSpent = 0
				end
				local bonusManaSpent = 0
				if target:HasModifier("modifier_iron_colossus") then
					if executedAbility:GetManaCost(executedAbility:GetLevel()-1) > 0 then
						bonusManaSpent = bonusManaSpent+1000
					end
				end
				ability.manaSpent = ability.manaSpent + executedAbility:GetManaCost(executedAbility:GetLevel()-1) + bonusManaSpent
				if ability.manaSpent > 600 then
					ability.manaSpent = 0
					local spikeParticle = "particles/units/heroes/hero_bristleback/ice_quills.vpcf"
					local position = target:GetAbsOrigin()
					local pfx = ParticleManager:CreateParticle( spikeParticle, PATTACH_OVERHEAD_FOLLOW, target )
					ParticleManager:SetParticleControl( pfx, 0, position+Vector(0,0,-100) )
					Timers:CreateTimer(2, function()
						ParticleManager:DestroyParticle(pfx, false)
					end)
					local radius = 405
					local damage = target:GetAverageTrueAttackDamage(target)*3
					local enemies = FindUnitsInRadius( target:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
					if #enemies > 0 then
						for _,enemy in pairs(enemies) do
							Filters:ApplyItemDamage(enemy,target,damage,DAMAGE_TYPE_MAGICAL,ability,RPC_ELEMENT_ICE,RPC_ELEMENT_NORMAL)
						end
					end 
					EmitSoundOn("Hero_Ancient_Apparition.IceBlastRelease.Tick", target)
				end
			end
		end
	end
end

function CustomAbilities:Flamewaker_3_1_glyph(caster)
	local radius = 440
	local splitEarthParticle = "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf"
	local position = caster:GetAbsOrigin()
	local pfx = ParticleManager:CreateParticle( splitEarthParticle, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, position )
	ParticleManager:SetParticleControl( pfx, 1, Vector(radius, radius, radius) )
	Timers:CreateTimer(4, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	EmitSoundOn("Hero_Leshrac.Split_Earth", caster)
	local damage = caster:GetStrength()*30
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })	
		end
	end 
end

function CustomAbilities:QuickAttachParticle(particleName, target, destroyTime)
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	Timers:CreateTimer(destroyTime, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	  ParticleManager:ReleaseParticleIndex(pfx)
	end) 	
	return pfx
end

function CustomAbilities:QuickAttachParticleWithPoint(particleName, target, destroyTime, point)
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT, point, target:GetAbsOrigin(), true)
	Timers:CreateTimer(destroyTime, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	  ParticleManager:ReleaseParticleIndex(pfx)
	end) 	
	return pfx
end

function CustomAbilities:QuickAttachParticleWithPointFollow(particleName, target, destroyTime, point)
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_POINT_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, point, target:GetAbsOrigin(), true)
	Timers:CreateTimer(destroyTime, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	  ParticleManager:ReleaseParticleIndex(pfx)
	end) 	
end

function CustomAbilities:QuickParticleAtPoint(particleName, position, destroyTime)
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, Events.GameMaster )
	ParticleManager:SetParticleControl(pfx, 0, position)
	Timers:CreateTimer(destroyTime, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	  ParticleManager:ReleaseParticleIndex(pfx)
	end)
	return pfx
end

function CustomAbilities:Warlord_Ambush(caster, warlord_ambush_target)
	if IsValidEntity(warlord_ambush_target) then
		if warlord_ambush_target:IsAlive() then
			print("blockMAIN")
			EmitSoundOn("Hero_Beastmaster.Attack", warlord_ambush_target)
			local target = warlord_ambush_target

			local particleName =  "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/flamewaker_crit.vpcf"
			local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
     	 	ParticleManager:SetParticleControl( pfx, 0, target:GetAbsOrigin()+Vector(0,0,40) )
			local pfx2 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
     	 	ParticleManager:SetParticleControl( pfx2, 0, target:GetAbsOrigin()+Vector(0,0,10) )
			Timers:CreateTimer(0.4, function() 
			  ParticleManager:DestroyParticle( pfx, false )
			  ParticleManager:DestroyParticle( pfx2, false )
			end) 	

			Timers:CreateTimer(0.06, function()
				EmitSoundOn("Hero_Beastmaster.Attack", target)
				Filters:PerformAttackSpecial(caster, target, true, true, false, true, false, false, false)
				local damageApprox = math.ceil(caster:GetAverageTrueAttackDamage(caster))
				PopupDamage(target, damageApprox)
				Timers:CreateTimer(0.03, function()
					caster:RemoveModifierByName("modifier_beastmaster_glyph_4_1_attack_up")
				end)
			end)
		end
	end
end

function CustomAbilities:TargetedAbilityAI(caster, searchRadius, heroOnly, ability)
	if ability:IsFullyCastable() then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, searchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			local newOrder = {
			 		UnitIndex = caster:entindex(), 
			 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			 		TargetIndex = enemies[1]:entindex(),
			 		AbilityIndex = ability:entindex(),
			 	}
			 
			ExecuteOrderFromTable(newOrder)
		end
	end
end

function CustomAbilities:IsWithinRegion(region, unit, tolerance)
	-- local caster = event.caster
	-- local ability = event.ability
	-- local casterOrigin = unit:GetAbsOrigin()

	-- if casterOrigin.x > region.x-tolerance and casterOrigin.y > 7791 and casterOrigin.x < 7716 and casterOrigin.y < 8151 then
	-- 	return true
	-- else
	-- 	return false
	-- end
end

function CustomAbilities:Steadfast(damage, victim)
	local thresh = 0.05
	if GameState:GetDifficultyFactor() == 2 then
		thresh = 0.04
	elseif GameState:GetDifficultyFactor() == 3 then
		thresh = 0.03
	end
	if damage > victim:GetMaxHealth()*thresh then
		damage = victim:GetMaxHealth()*thresh
	end
	return damage
end

function CustomAbilities:AncientSteadfast(damage, victim)
	local thresh = 0.003
	if GameState:GetDifficultyFactor() == 2 then
		thresh = 0.002
	elseif GameState:GetDifficultyFactor() == 3 then
		thresh = 0.001
	end
	if damage > victim:GetMaxHealth()*thresh then
		damage = victim:GetMaxHealth()*thresh
	end
	return damage
end

function CustomAbilities:MegaSteadfast(damage, victim)
	local thresh = 0.02
	if GameState:GetDifficultyFactor() == 2 then
		thresh = 0.01
	elseif GameState:GetDifficultyFactor() == 3 then
		thresh = 0.005
		if victim:GetUnitName() == "redfall_crimsyth_castle_boss" then
			thresh = 0.003
		end
	end
	if damage > victim:GetMaxHealth()*thresh then
		damage = victim:GetMaxHealth()*thresh
	end
	if Events.SpiritRealm then
		damage = math.floor(damage/2)
	end
	return damage
end

function CustomAbilities:ChernobogDemonHunter(victim, damage)
	local ability = victim:FindAbilityByName("chernobog_demon_hunter")
	local threshold = ability:GetSpecialValueFor("max_damage_taken_percent_of_health")
	print("THRESHOLD!!")
	print(threshold)
	if victim:HasModifier("modifier_chernobog_immortal_weapon_1") then
		threshold = threshold - 2
	end
	threshold = threshold/100
	if damage > victim:GetMaxHealth()*threshold then
		damage = victim:GetMaxHealth()*threshold
		local manaDrain = ability:GetSpecialValueFor("mana_drain_when_threshold_used")
		victim:ReduceMana(manaDrain)
		CustomAbilities:ChernobogDemonHunterManaReduced(victim)
		CustomAbilities:QuickAttachParticle("particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void_hit_body_flash.vpcf", victim, 2)
	end

	return damage
end

function CustomAbilities:ChernobogDemonHunterManaReduced(victim)
	local ability = victim:FindAbilityByName("chernobog_demon_hunter")
	if victim:GetMana() <= 1 then
		ability:ToggleAbility()
	end
end

function CustomAbilities:ChernobogSuddenStrike(unit, enemy, ability)
	local shadowStrikeCD = 1
	if unit:HasModifier("modifier_chernobog_glyph_6_1") then
		shadowStrikeCD = 0.5
	end
	ability:ApplyDataDrivenModifier(unit, unit, "modifier_chernobog_c_c_cooldown", {duration = shadowStrikeCD})
	ability:ApplyDataDrivenModifier(unit, unit, "modifier_chernobog_rune_c_c_damage", {duration = 0.3})
	unit:SetModifierStackCount("modifier_chernobog_rune_c_c_damage", unit, ability.c_c_level)

	local particleName = "particles/roshpit/chernobog/chernobog_rune_c_c.vpcf"
   	local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( particle1, 0, unit:GetAbsOrigin()+Vector(0,0,40) )

	Timers:CreateTimer(0.15, function()
		StartAnimation(unit, {duration=0.3, activity=ACT_DOTA_ATTACK, rate=3})
		Filters:PerformAttackSpecial(unit, enemy, true, true, true, true, false, false, false)
	end)
	FindClearSpaceForUnit(unit, enemy:GetAbsOrigin()-enemy:GetForwardVector()*90, false)
   	local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( particle2, 0, unit:GetAbsOrigin()+Vector(0,0,40) )
	Timers:CreateTimer(3, 
	function()
		ParticleManager:DestroyParticle( particle1, false )
		ParticleManager:DestroyParticle( particle2, false )
	end)
end

function CustomAbilities:HitTaskShield(victim, attacker)
    local currentStacks = victim:GetModifierStackCount("modifier_task_armor", victim)
    if currentStacks > 1 then
        victim:SetModifierStackCount("modifier_task_armor", victim, currentStacks-1)
    else
        victim:RemoveModifierByName("modifier_task_armor")
        CustomAbilities:QuickAttachParticle("particles/roshpit/sorceress/shield_shatter.vpcf", victim, 1.2)
    end   
end

function CustomAbilities:HitVolcanoShield(victim, attacker)
    local currentStacks = victim:GetModifierStackCount("modifier_volcano_shield", victim.InventoryUnit)
    if currentStacks > 1 then
        victim:SetModifierStackCount("modifier_volcano_shield", victim.InventoryUnit, currentStacks-1)
    else
        victim:RemoveModifierByName("modifier_volcano_shield")
        -- CustomAbilities:QuickAttachParticle("particles/roshpit/sorceress/shield_shatter.vpcf", victim, 1.2)
    end   
end

function CustomAbilities:HitShieldGeneric(victim, attacker, caster, modifierName)
    local currentStacks = victim:GetModifierStackCount(modifierName, caster)
    if currentStacks > 1 then
        victim:SetModifierStackCount(modifierName, caster, currentStacks-1)
    else
        victim:RemoveModifierByName(modifierName)
    end   
end

function CustomAbilities:HitShipyardShield(victim, attacker)
    local currentStacks = victim:GetModifierStackCount("modifier_shipyard_veil_shield", victim.InventoryUnit)
    if currentStacks > 1 then
        victim:SetModifierStackCount("modifier_shipyard_veil_shield", victim.InventoryUnit, currentStacks-1)
    else
        victim:RemoveModifierByName("modifier_shipyard_veil_shield")
    end
    if victim.headItem then
    	local ability = victim.headItem
    	if victim.headItem:GetAbilityName() == "item_rpc_shipyard_veil_lv1" then
    		local upgradeThreshold = victim.headItem:GetLevelSpecialValueFor("property_three", 1)
			local nextValue = ability.property1 + 1
			if nextValue == upgradeThreshold then
				ability.lock = true
				RPCItems:RollShipyardVeil2(victim, ability)
				-- Notifications:Top(attacker.summoner:GetPlayerOwnerID(), {text="Robe of Flooding Upgraded", duration=5, style={color="white"}, continue=true})
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_jakiro/viper_explosion_liquid_fire_explosion.vpcf", victim, 2)
			else
				ability.property1 = nextValue
				RPCItems:SetPropertyValuesSpecial(ability, ability.property1, "#item_property_shipyard_veil_1", "#91F2F1",  1, "#property_shipyard_veil_1_description")
			end
    	elseif victim.headItem:GetAbilityName() == "item_rpc_shipyard_veil_lv2" then
    		local upgradeThreshold = victim.headItem:GetSpecialValueFor("property_three")
			local nextValue = ability.property1 + 1
			if nextValue == upgradeThreshold then
				ability.lock = true
				RPCItems:RollShipyardVeil3(victim, ability)
				-- Notifications:Top(attacker.summoner:GetPlayerOwnerID(), {text="Robe of Flooding Upgraded", duration=5, style={color="white"}, continue=true})
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_jakiro/viper_explosion_liquid_fire_explosion.vpcf", victim, 2)
			else
				ability.property1 = nextValue
				RPCItems:SetPropertyValuesSpecial(ability, ability.property1, "#item_property_shipyard_veil_2", "#91F2F1",  1, "#property_shipyard_veil_2_description")
			end
    	end
    end 
end

function CustomAbilities:HitCrimsythElite(victim, attacker, damage)
    if victim.foot then
    	local ability = victim.foot
    	if victim.foot:GetAbilityName() == "item_rpc_crimsyth_elite_greaves_lv1" then
    		if damage < victim:GetMaxHealth() and damage >= victim:GetMaxHealth()*0.5 then
	    		local upgradeThreshold = victim.foot:GetLevelSpecialValueFor("property_four", 1)
				local nextValue = ability.property1 + 1
				if nextValue == upgradeThreshold then
					ability.lock = true
					RPCItems:RollCrimsythEliteGreavesLV2(victim, ability)
					-- Notifications:Top(attacker.summoner:GetPlayerOwnerID(), {text="Robe of Flooding Upgraded", duration=5, style={color="white"}, continue=true})
				else
					ability.property1 = nextValue
					RPCItems:SetPropertyValuesSpecial(ability, ability.property1, "#item_property_crimsyth_elite_1", "#DD2727",  1, "#property_crimsyth_elite_1_description")
				end
			end
    	elseif victim.foot:GetAbilityName() == "item_rpc_crimsyth_elite_greaves_lv2" then
    		if damage < victim:GetMaxHealth() and damage >= victim:GetMaxHealth()*0.75 then
	    		local upgradeThreshold = victim.foot:GetLevelSpecialValueFor("property_four", 1)
				local nextValue = ability.property1 + 1
				if nextValue == upgradeThreshold then
					ability.lock = true
					RPCItems:RollCrimsythEliteGreavesLV3(victim, ability)
					-- Notifications:Top(attacker.summoner:GetPlayerOwnerID(), {text="Robe of Flooding Upgraded", duration=5, style={color="white"}, continue=true})
				else
					ability.property1 = nextValue
					RPCItems:SetPropertyValuesSpecial(ability, ability.property1, "#item_property_crimsyth_elite_2", "#DD2727",  1, "#property_crimsyth_elite_2_description")
				end
			end
    	end
    end 
end

function CustomAbilities:CastNoTargetIfCastable(unit, castAbility, enemyRadius)
	if castAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( unit:GetTeamNumber(), unit:GetAbsOrigin(), nil, enemyRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )	
		if #enemies > 0 then
			local castPoint = enemies[1]:GetAbsOrigin()
			local newOrder = {
			 		UnitIndex = unit:entindex(), 
			 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			 		AbilityIndex = castAbility:entindex(),
		 	}
			 
			ExecuteOrderFromTable(newOrder)			
		end
	end
end

function CustomAbilities:getHeroFromUnit(unit)
	if unit:IsHero() then
		return unit
	else
		local unitOwner = unit:GetPlayerOwnerID()
		local hero = GameState:GetHeroByPlayerID(unitOwner)
		return hero
	end
end

function CustomAbilities:CastleSorceressDamage(victim, damage)
	-- if damage > victim:GetMaxHealth()*0.05 then
	-- 	local ability = victim:FindAbilityByName("redfall_sorceress_fire_spray")
	-- 	ability:ApplyDataDrivenModifier(victim, victim, "modifier_castle_sorceress_shell", {duration = 4})
	-- end
	-- return victim:GetMaxHealth()*0.01
	return damage
end

function  CustomAbilities:MolothTakeDamage(victim, damagetype, damage)
	local damageReducTable = {0.8, 0.2, 0}
	if victim:HasModifier("modifier_moloth_sphere_on_moloth_red") then
		if damagetype == DAMAGE_TYPE_MAGICAL then
			return damage
		else
			return damage*damageReducTable[GameState:GetDifficultyFactor()]
		end
	elseif victim:HasModifier("modifier_moloth_sphere_on_moloth_blue") then
		if damagetype == DAMAGE_TYPE_PURE then
			return damage
		else
			return damage*damageReducTable[GameState:GetDifficultyFactor()]
		end
	elseif victim:HasModifier("modifier_moloth_sphere_on_moloth_green") then
		if damagetype == DAMAGE_TYPE_PHYSICAL then
			return damage
		else
			return damage*damageReducTable[GameState:GetDifficultyFactor()]
		end
	end	
end

function CustomAbilities:Protostar(victim)
	local modifier = victim:FindModifierByName("modifier_solunia_glyph_5_a")
	local glyphUnit = modifier:GetCaster()
	local glyph = modifier:GetAbility()
	glyph.liftVelocity = 1
	glyph:ApplyDataDrivenModifier(glyphUnit, victim, "modifier_solunia_glyph_5_a_cooldown", {duration = 18})
	glyph:ApplyDataDrivenModifier(glyphUnit, victim, "modifier_soluna_protostar_lifting", {duration = 4})
end

function CustomAbilities:WaterTempleBubble(victim, attacker, damage)
	local threshold = 0.02
	if GameState:GetDifficultyFactor() == 2 then
		threshold = 0.01
	elseif GameState:GetDifficultyFactor() == 3 then
		threshold = 0.005
	end
	if damage > victim:GetMaxHealth()*threshold then
		damage = victim:GetMaxHealth()*threshold
	end
	return damage
end

function CustomAbilities:HeavyArmor(damage, attacker, victim)
	local distance = WallPhysics:GetDistance(attacker:GetAbsOrigin(), victim:GetAbsOrigin())
	if distance > 500 then
		local mult = 0.1
		if GameState:GetDifficultyFactor() == 2 then
			mult = 0.05
		elseif GameState:GetDifficultyFactor() == 3 then
			mult = 0
		end
		return damage*mult
	else
		return damage
	end
end

function CustomAbilities:WeaponMelt(damageType, damage)
	if damageType == DAMAGE_TYPE_PHYSICAL then
		local mult = 0.8
		if GameState:GetDifficultyFactor() == 2 then
			mult = 0.5
		elseif GameState:GetDifficultyFactor() == 3 then
			mult = 0.2
		end
		damage = damage*mult
	end
	return damage
end

LinkLuaModifier("modifier_arkimus_speed_dash", "modifiers/arkimus/modifier_arkimus_speed_dash", LUA_MODIFIER_MOTION_NONE)

function CustomAbilities:ArkimusSpeedDash(unit, enemy, ability, c_b_level)
	local duration = 3
	local caster = unit
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_arkimus_c_b_sprinting", {duration = duration})
	caster:AddNewModifier( caster, ability, "modifier_arkimus_speed_dash", {duration = duration} )
	caster:AddNewModifier(caster, nil, "modifier_animation_translate", {translate="haste"})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_arkimus_c_b_attack_power", {duration = duration})
	caster:SetModifierStackCount("modifier_arkimus_c_b_attack_power", caster, c_b_level)
end

function CustomAbilities:AddAndOrSwapSkill(caster, originalSkillName, newSkillName, index)
    local newAbility = caster:FindAbilityByName(newSkillName)
  	if not newAbility then
  		newAbility = caster:AddAbility(newSkillName)
  	end
  	local originalSkill = caster:FindAbilityByName(originalSkillName)
  	newAbility:SetLevel(originalSkill:GetLevel())
  	originalSkill:SetAbilityIndex(index)
  	newAbility:SetAbilityIndex(index)
  	caster:SwapAbilities(originalSkillName, newSkillName, false, true)
end