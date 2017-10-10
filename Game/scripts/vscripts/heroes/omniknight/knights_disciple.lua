function knights_disciple_cast(event)
	local caster = event.caster
	local ability = event.ability
	local spawnPosition = caster:GetAbsOrigin()-caster:GetForwardVector()*200+RandomVector(150)
	local summon = CreateUnitByName("paladin_disciple", spawnPosition, false, caster, caster, caster:GetTeamNumber())
	summon:FindAbilityByName("paladin_disciple_ability"):SetLevel(1)
	local summonAbility = summon:FindAbilityByName("paladin_disciple_ability")
	summonAbility:SetLevel(1)
	local discipleDuration = Filters:GetAdjustedBuffDuration(caster, 30, false)
	summonAbility:ApplyDataDrivenModifier(summon, summon, "modifier_disciple_duration", {duration = discipleDuration})
	local healAbility = summon:FindAbilityByName("knights_disciple_heal")
	healAbility:SetLevel(ability:GetLevel())
	healAbility.paladin = caster
	local pfx = ParticleManager:CreateParticle( "particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_purification_ti6_immortal.vpcf", PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControlEnt(pfx, 0, summon, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", summon:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(pfx, 1, Vector(300,1,300))
	ParticleManager:SetParticleControl(pfx, 2, summon:GetForwardVector())
	summon.paladin = caster
	Timers:CreateTimer(4, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	end) 	
	healAbility.b_d_level = Runes:GetTotalRuneLevel(caster, 2, "b_d", "paladin")
	ability.a_d_level = Runes:GetTotalRuneLevel(caster, 1, "a_d", "paladin")
	if ability.a_d_level > 0 then
		ability:ApplyDataDrivenModifier(caster, summon, "modifier_paladin_a_d_aura", {})
	end
	summon.falling = true
	Timers:CreateTimer(0.5, function()
		EmitSoundOn("Paladin.DiscipleSummon", summon)
		EmitSoundOnLocationWithCaster(summon:GetAbsOrigin(), "Paladin.DiscipleLeaveSound", summon)
	end)
	local c_d_level = Runes:GetTotalRuneLevel(caster, 3, "c_d", "paladin")
	if c_d_level > 0 then
		summon:AddAbility("knights_disciple_bolt"):SetLevel(1)
	end
	caster.d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "paladin")
	local d_d_level = Runes:GetTotalRuneLevel(caster, 4, "d_d", "paladin")
	if d_d_level > 0 then
		summon:AddAbility("knights_disciple_purifying_spark"):SetLevel(1)
	end
	if caster:HasModifier("modifier_paladin_immortal_weapon_2") then
		caster.weapon:ApplyDataDrivenModifier(caster.InventoryUnit, summon, "modifier_disciple_cooldown_reduction", {})
	end
	Filters:CastSkillArguments(4, caster)
end

function disciple_think(event)
	local summon = event.caster
	local paladin = summon.paladin
	local distance = WallPhysics:GetDistance(paladin:GetAbsOrigin()*Vector(1,1,0), summon:GetAbsOrigin()*Vector(1,1,0))
	if summon.casting then
		summon.casting = false
		return
	end
	if distance > 2000 then
		local movePosition = paladin:GetAbsOrigin()-paladin:GetForwardVector()*400+RandomVector(150)
		FindClearSpaceForUnit(summon, movePosition, false)
		local pfx = ParticleManager:CreateParticle( "particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_purification_ti6_immortal.vpcf", PATTACH_CUSTOMORIGIN, target )
		ParticleManager:SetParticleControlEnt(pfx, 0, summon, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", summon:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(pfx, 1, Vector(300,1,300))
		ParticleManager:SetParticleControl(pfx, 2, summon:GetForwardVector())
		StartAnimation(summon, {duration=1, activity=ACT_DOTA_CAST_ABILITY_1, rate=1})
		local summonAbility = summon:FindAbilityByName("paladin_disciple_ability")
		summonAbility:ApplyDataDrivenModifier(summon, summon, "modifier_disple_leaving", {duration = 1})
		return true
	elseif distance > 600 then
		local movePosition = paladin:GetAbsOrigin()-paladin:GetForwardVector()*400+RandomVector(150)
		summon:MoveToPosition(movePosition)
	end
	if summon:HasAbility("knights_disciple_purifying_spark") then
		local boltAbility = summon:FindAbilityByName("knights_disciple_purifying_spark")
		if boltAbility:IsFullyCastable() then
			local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
			local target_types = DOTA_UNIT_TARGET_ALL
			local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
			local enemies = FindUnitsInRadius(summon:GetTeamNumber(), summon:GetAbsOrigin(), nil, 750, target_teams, target_types, target_flags, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				local newOrder = {
			 		UnitIndex = summon:entindex(), 
			 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			 		TargetIndex = enemies[1]:entindex(),
			 		AbilityIndex = boltAbility:entindex(),
			 	}
				ExecuteOrderFromTable(newOrder)	
				summon.casting = true
				Timers:CreateTimer(boltAbility:GetCastPoint()+0.1, function()
					summon.casting = false
				end)	

				return false	
			end		
		end		
	end
	if summon:HasAbility("knights_disciple_bolt") then
		local boltAbility = summon:FindAbilityByName("knights_disciple_bolt")
		if boltAbility:IsFullyCastable() then
			local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
			local target_types = DOTA_UNIT_TARGET_ALL
			local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
			local enemies = FindUnitsInRadius(summon:GetTeamNumber(), summon:GetAbsOrigin(), nil, 1000, target_teams, target_types, target_flags, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				local newOrder = {
			 		UnitIndex = summon:entindex(), 
			 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			 		TargetIndex = enemies[1]:entindex(),
			 		AbilityIndex = boltAbility:entindex(),
			 	}
				ExecuteOrderFromTable(newOrder)	
				summon.casting = true
				Timers:CreateTimer(boltAbility:GetCastPoint()+0.1, function()
					summon.casting = false
				end)	
				return false			
			end	
		end	
	end
	local healAbility = summon:FindAbilityByName("knights_disciple_heal")
	if healAbility:IsFullyCastable() then
		local target_teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY
		local target_types = DOTA_UNIT_TARGET_HERO
		local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
		local allies = FindUnitsInRadius(summon:GetTeamNumber(), summon:GetAbsOrigin(), nil, 900, target_teams, target_types, target_flags, FIND_ANY_ORDER, false)
		if #allies > 0 then
			local ally = allies[1]
			if #allies >= 2 then
				for i = 2, #allies, 1 do
					if (allies[i]:GetHealth()/allies[i]:GetMaxHealth()) < (ally:GetHealth()/ally:GetMaxHealth()) then
						if allies[i]:HasModifier("modifier_paladin_rune_b_d_effect_visible") or allies[i]:GetEntityIndex() == caster:GetEntityIndex() then
						else
							ally = allies[i]
						end
					end
				end
			end

			local buff = paladin:FindModifierByName("modifier_knights_disciple_heal")
			if buff then
				if buff:GetRemainingTime() < 7 then
					ally = paladin
				end
			else
				ally = paladin
			end
			local newOrder = {
		 		UnitIndex = summon:entindex(), 
		 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		 		TargetIndex = ally:entindex(),
		 		AbilityIndex = healAbility:entindex(),
		 	}
			ExecuteOrderFromTable(newOrder)	
			summon.casting = true
			Timers:CreateTimer(healAbility:GetCastPoint()+0.1, function()
				summon.casting = false
			end)	
			return				
		end
	end
end

function disciple_duration_end(event)
	local ability = event.ability
	local caster = event.caster
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_disple_leaving", {})
	caster.velocity = 10
	Timers:CreateTimer(1.2, function()
		for i = 1, 90, 1 do
			Timers:CreateTimer(0.03*i, function()
				caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,caster.velocity))
				caster.velocity = caster.velocity + 0.5
			end)
		end
	end)
	EmitSoundOn("Paladin.DiscipleLeave", caster)
	Timers:CreateTimer(1.3, function()
		EmitSoundOn("Paladin.DiscipleLeaveSound", caster)
		local pfx = ParticleManager:CreateParticle( "particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_purification_ti6_immortal.vpcf", PATTACH_CUSTOMORIGIN, target )
		ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(pfx, 1, Vector(300,1,300))
		ParticleManager:SetParticleControl(pfx, 2, caster:GetForwardVector())
		caster.paladin = caster
		Timers:CreateTimer(4, function() 
		  ParticleManager:DestroyParticle( pfx, false )
		end) 	
	end)
	Timers:CreateTimer(4, function()
		UTIL_Remove(caster)
	end)
end

function disciple_heal_start(event)
	local attacker = event.caster
	local victim = event.target
	local ability = event.ability
	-- CustomAbilities:QuickAttachParticle("particles/roshpit/paladin/disciple_heal_cast.vpcf", caster, 1)
	-- CustomAbilities:QuickAttachParticle("particles/roshpit/paladin/disciple_heal_cast.vpcf", target, 1)
	local particleName = "particles/roshpit/paladin_aegis_zap.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_POINT, victim )
	ParticleManager:SetParticleControlEnt(pfx, 0, victim, PATTACH_POINT, "attach_hitloc", victim:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, attacker, PATTACH_POINT, "attach_hitloc", attacker:GetAbsOrigin(), true)
	EmitSoundOn("Paladin.DiscipleHealCast", attacker)
	Timers:CreateTimer(1.0, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	end) 

	event.ability:ApplyDataDrivenModifier(attacker, victim, "modifier_paladin_rune_b_d_hidden_block", {duration = 16})
	if attacker:HasModifier("modifier_disciple_cooldown_reduction") then
		local cd = ability:GetCooldownTimeRemaining()
		local newCD = cd*0.75
		ability:EndCooldown()
		ability:StartCooldown(newCD)
	end
end

function disciple_heal_think(event)
	local caster = nil
	local ability = event.ability
	if not IsValidEntity(event.caster) then
		caster = event.target
	else
		caster = event.caster.paladin
		local healDuration = Filters:GetAdjustedBuffDuration(caster, 16, false)
		local b_d_level = ability.b_d_level
		local target = event.target
		if b_d_level > 0 then
			if not target:HasModifier("modifier_paladin_rune_b_d_effect_visible") then
				ability:ApplyDataDrivenModifier(caster, target, "modifier_paladin_rune_b_d_effect_visible", {duration = healDuration})
			end
			local stackCount = target:GetModifierStackCount("modifier_paladin_rune_b_d_effect_visible", caster)
			local newStacks = math.min(stackCount + 1, 30)
			target:SetModifierStackCount("modifier_paladin_rune_b_d_effect_visible", caster, newStacks)
			if not target:HasModifier("modifier_paladin_rune_b_d_invisible") then
				ability:ApplyDataDrivenModifier(caster, target, "modifier_paladin_rune_b_d_invisible", {duration = healDuration})
			end
			target:SetModifierStackCount("modifier_paladin_rune_b_d_invisible", caster, newStacks*b_d_level)
		end
	end

	local target = event.target
	local healPercent= event.heal_pct
	local healAmount = math.floor(target:GetMaxHealth()*(healPercent/100))	
	Filters:ApplyHeal(caster, target, healAmount, true)
end

function armor_aura_create(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if ability.a_d_level > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_paladin_a_d_aura_armor_stacks", {})
		target:SetModifierStackCount("modifier_paladin_a_d_aura_armor_stacks", caster, ability.a_d_level)
	end
end

function disciple_bolt_start(event)
	local caster = event.caster
	local ability = event.ability
	local paladin = caster.paladin
	local target = event.target
	local c_d_level = Runes:GetTotalRuneLevel(paladin, 3, "c_d", "paladin")
	local damage = paladin:GetAverageTrueAttackDamage(paladin)*1.1*c_d_level
	EmitSoundOn("Paladin.HolyBolt", target)
	Filters:TakeArgumentsAndApplyDamage(target, paladin, damage, DAMAGE_TYPE_PURE, 4, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
	Filters:ApplyStun(paladin, 0.1, target)
	local particle = ParticleManager:CreateParticle("particles/roshpit/paladin/crusader_bolt_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, target)
	ParticleManager:SetParticleControl(particle, 0, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
	ParticleManager:SetParticleControl(particle, 1, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z+1500))
	ParticleManager:SetParticleControl(particle, 2, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
	if paladin:HasModifier("modifier_paladin_glyph_5_a") then
		Timers:CreateTimer(0.3, function()
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 520, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				EmitSoundOn("Paladin.HolyBolt", enemies[1])
				for i = 1, #enemies, 1 do
					local enemy = enemies[i]
					Filters:TakeArgumentsAndApplyDamage(enemy, paladin, damage, DAMAGE_TYPE_PURE, 4, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
					Filters:ApplyStun(paladin, 0.1, enemy)
					local particle = ParticleManager:CreateParticle("particles/roshpit/paladin/crusader_bolt_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, enemy)
					ParticleManager:SetParticleControl(particle, 0, Vector(enemy:GetAbsOrigin().x,enemy:GetAbsOrigin().y,enemy:GetAbsOrigin().z))
					ParticleManager:SetParticleControl(particle, 1, Vector(enemy:GetAbsOrigin().x,enemy:GetAbsOrigin().y,enemy:GetAbsOrigin().z+1500))
					ParticleManager:SetParticleControl(particle, 2, Vector(enemy:GetAbsOrigin().x,enemy:GetAbsOrigin().y,enemy:GetAbsOrigin().z))
				end
			end
		end)
	end
	if caster:HasModifier("modifier_disciple_cooldown_reduction") then
		local cd = ability:GetCooldownTimeRemaining()
		local newCD = cd*0.75
		ability:EndCooldown()
		ability:StartCooldown(newCD)
	end
end

function purifying_spark_start(event)
	local caster = event.caster
	local ability = event.ability
	local paladin = caster.paladin
	local target = event.target
	EmitSoundOn("Paladin.PurifyingLaunch", caster)
	ability.split = true
	ability.sound = true
	local info = 
	{
		Target = target,
		Source = caster,
		Ability = ability,	
		EffectName = "particles/econ/items/keeper_of_the_light/kotl_weapon_arcane_staff/keeper_base_attack_arcane_staff.vpcf",
		vSourceLoc= caster:GetAbsOrigin(),
		bDrawsOnMinimap = false, 
	        bDodgeable = true,
	        bIsAttack = false, 
	        bVisibleToEnemies = true,
	        bReplaceExisting = false,
	        flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = true,
		iVisionRadius = 0,
		iMoveSpeed = 900,
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	projectile = ProjectileManager:CreateTrackingProjectile(info)
	if caster:HasModifier("modifier_disciple_cooldown_reduction") then
		local cd = ability:GetCooldownTimeRemaining()
		local newCD = cd*0.75
		ability:EndCooldown()
		ability:StartCooldown(newCD)
	end
end

function purifying_spark_hit(event)
	local caster = event.caster
	if IsValidEntity(caster) then
	else
		return true
	end

	
	local ability = event.ability
	local paladin = caster.paladin
	local target = event.target
	if ability.sound then
		EmitSoundOn("Paladin.PurifyingImpact", target)
	end
	ability.sound = false
	if ability.split then
		local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
		local target_types = DOTA_UNIT_TARGET_ALL
		local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
		ability.sound = true
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 520, target_teams, target_types, target_flags, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for i = 1, #enemies, 1 do
				local info = 
				{
					Target = enemies[i],
					Source = target,
					Ability = ability,	
					EffectName = "particles/econ/items/keeper_of_the_light/kotl_weapon_arcane_staff/keeper_base_attack_arcane_staff.vpcf",
					vSourceLoc= target:GetAbsOrigin(),
					bDrawsOnMinimap = false, 
				        bDodgeable = true,
				        bIsAttack = false, 
				        bVisibleToEnemies = true,
				        bReplaceExisting = false,
				        flExpireTime = GameRules:GetGameTime() + 10,
					bProvidesVision = true,
					iVisionRadius = 0,
					iMoveSpeed = 900,
					iVisionTeamNumber = caster:GetTeamNumber()
				}
				projectile = ProjectileManager:CreateTrackingProjectile(info)
			end
		end
	end
	local d_d_level = Runes:GetTotalRuneLevel(paladin, 4, "d_d", "paladin")
	local duration = d_d_level*0.1 + 0.5
	ability:ApplyDataDrivenModifier(caster, target, "modifier_disciple_purifying_spark", {duration = duration})
	ability.split = false
end