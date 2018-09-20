function paragon_created(event)
	local caster = event.caster
end

function paragon_die(event)
	local caster = event.caster
	local deathPosition = caster:GetAbsOrigin()
	Challenges:ParagonKilled(caster.affixes, deathPosition)
	if caster.buddiesTable then
		for i = 1, #caster.buddiesTable, 1 do
			local buddy = caster.buddiesTable[i]
			if IsValidEntity(buddy) then
				buddy.buddiesSlain = buddy.buddiesSlain + 1
			end
		end
	end
	if caster.solo then
		Glyphs:DropArcaneCrystals(deathPosition, 0.85)
		paragon_loot_drop(deathPosition)
	else
		if caster.buddiesSlain == caster.packSize then
			Glyphs:DropArcaneCrystals(deathPosition, 0.85)
			paragon_loot_drop(deathPosition)
		end
	end
end

function paragon_loot_drop(position)
	local drops = RandomInt(2, 5)
	for i = 1, drops, 1 do
		Timers:CreateTimer(i*0.3, function()
			RPCItems:RollItemtype(300, position, 1, 0)
		end)
	end
end

function fire_breathing_think(event)
	local caster = event.caster
	if caster:HasAbility("dungeon_creep") then
		if not caster.aggro then
			return false
		end
	end
	local ability = event.ability
	local start_radius = 120
	local end_radius = 400
	local range = 600
	local speed = 700
	local fv = caster:GetForwardVector()
	local info = 
	{
			Ability = ability,
        	EffectName = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf",
        	vSpawnOrigin = caster:GetAbsOrigin()+fv*20,
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
	EmitSoundOn("Hero_DragonKnight.BreathFire", caster)
end

function fire_breathing_strike(event)
	local target = event.target
	local caster = event.caster
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)
	if caster.solo then
		damage = damage*2
	end
	local divisor = 480
  	if GameState:GetDifficultyFactor() == 1 then
  		divisor = 60
  	elseif GameState:GetDifficultyFactor() == 2 then
  		divisor = 240
  	end
  	damage = damage/divisor
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
	PopupDamage(target, damage)
end

function activate_lightning_enchant(event)
	local caster = event.caster
	local ability = event.ability
	caster:AddAbility("paragon_electrified_ability"):SetLevel(1)
end

function lightning_enchant_think(event)
	local ability = event.ability
	ability.lightnings = 0
end

function electrified_take_damage(event)

	local ability = event.ability
	local caster = event.caster
	local loopCount = 1
	if caster.solo then
		loopCount = 3
	end
	if not ability.lightnings then
		ability.lightnings = 0
	end
	if ability.lightnings < 16 then
		ability.lightnings = ability.lightnings + 1
		for i = 1, loopCount, 1 do
			local fv = RandomVector(1)
			local projectileParticle = "particles/econ/items/zeus/lightning_weapon_fx/linear_electric_immortal_lightning.vpcf"
			local projectileOrigin = caster:GetAbsOrigin() + fv*10
			local start_radius = 140
			local end_radius = 140
			local range = 800
			local speed = 400 + RandomInt(0, 250)
				local info = 
				{
						Ability = ability,
			        	EffectName = projectileParticle,
			        	vSpawnOrigin = projectileOrigin+Vector(0,0,60),
			        	fDistance = range,
			        	fStartRadius = start_radius,
			        	fEndRadius = end_radius,
			        	Source = caster,
			        	StartPosition = "attach_attack1",
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
	end
end

function electric_projectile_hit(event)
	local target = event.target
	local caster = event.caster
	local damage = caster:GetAttackDamage()/320
	local sound = "Hero_Zuus.ArcLightning.Target" 
    EmitSoundOn(sound, target)
	PopupDamage(target, damage)
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
end

function activate_great_wall(event)
	local caster = event.caster
	local baseArmor = caster:GetPhysicalArmorValue()

	local armorMult = 4
	if GameState:GetDifficultyFactor() == 2 then
		armorMult = 10
	elseif GameState:GetDifficultyFactor() == 3 then
		armorMult = 25
	end
	caster:SetPhysicalArmorBaseValue(baseArmor*armorMult)
end

function activate_gargantuan(event)
	local caster = event.caster
	caster:SetModelScale(caster:GetModelScale()*1.3)
	local mult = 7
	if GameState:GetDifficultyFactor() == 1 then
		mult = 4
	end
    local newHealth = math.min(caster:GetMaxHealth()*mult, (2^30)-10)
    caster:SetMaxHealth(newHealth)
    caster:SetBaseMaxHealth(newHealth)
    caster:SetHealth(newHealth)
    caster:Heal(newHealth, unit)	
end

function activate_regen_aura(event)
	local caster = event.caster
	caster:AddAbility("creature_regen_aura"):SetLevel(1)
end

function activate_endurance_aura(event)
	local caster = event.caster
	caster:AddAbility("creature_endurance_aura"):SetLevel(1)
end

function frost_nova_activate(event)
	local caster = event.caster
	if caster:HasAbility("dungeon_creep") then
		if not caster.aggro then
			return false
		end
	end
	local position = caster:GetAbsOrigin()
	local particle = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
	local pfx = ParticleManager:CreateParticle( particle, PATTACH_WORLDORIGIN, caster )
	local radius = 500
	ParticleManager:SetParticleControl( pfx, 0, position )
	ParticleManager:SetParticleControl( pfx, 1, Vector(radius, 2, radius*2) )
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
  	local ability = event.ability
  	EmitSoundOn("Ability.FrostNova", caster)
  	local divisor = 500
  	if GameState:GetDifficultyFactor() == 1 then
  		divisor = 50
  	elseif GameState:GetDifficultyFactor() == 2 then
  		divisor = 300
  	end
  	local damage = caster:GetAttackDamage()/divisor
	if caster.solo then
		damage = damage*2.5
	end
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	local freezeDuration = 2.5
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_paragon_frostbitten_effect", {duration = freezeDuration})
		end
	end 
end

function spring_attack(event)
	local attacker = event.attacker
	attacker.springEnabled = true
end
function springy_think(event)
	local caster = event.caster
	if not caster:HasModifier("modifier_jumping") and not caster:IsRooted() and not caster:IsStunned() and caster:IsAlive() and getUnitExceptionSpringy(caster:GetUnitName()) then
		if caster.springEnabled then
			StartAnimation(caster, {duration=1, activity=ACT_DOTA_TELEPORT_END, rate=0.65})
			WallPhysics:JumpWithBlocking(caster, caster:GetForwardVector(), 12, 22, 24, 1)
		end
	end
end

function getUnitExceptionSpringy(unitName)
	if unitName == "vault_invisible_keyholder" or unitName == "courtyard_summoner" or unitName == "spine_hermit" or unitName == "ruins_blood_arcanist_flying" or unitName == "ruins_blood_arcanist" then
		return false
	else
		return true
	end
end

function activate_crippling_aura(event)
	local caster = event.caster
	caster:AddAbility("creature_crippling_aura"):SetLevel(1)
end

function light_infused_activate(event)
	local caster = event.caster
	caster:AddAbility("grizzly_healer_flash_heal"):SetLevel(1)
end

function light_infused_think(event)
	local caster = event.caster
	local ability = event.ability
	local flashHeal = caster:FindAbilityByName("grizzly_healer_flash_heal")
	if flashHeal:IsFullyCastable() then
		local target_teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY
		local target_types = DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC
		local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
		local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, target_teams, target_types, target_flags, FIND_ANY_ORDER, false)
		if #allies > 0 then
			for i = 1, #allies, 1 do
				if allies[i]:GetHealth() < (allies[i]:GetMaxHealth()*0.7) then
					local newOrder = {
				 		UnitIndex = caster:entindex(), 
				 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				 		TargetIndex = allies[i]:entindex(),
				 		AbilityIndex = flashHeal:entindex(),
				 	}
					ExecuteOrderFromTable(newOrder)						
					break
				end
			end
		end
	else
	end
end

function blinking_think(event)
	local caster = event.caster
	if caster:HasAbility("dungeon_creep") then
		if not caster.aggro then
			return false
		end
	end
	print("blinkingthink2")
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 740, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		local enemy = enemies[1]
		EmitSoundOn("RoshpitParagon.Blink", caster)

		StartAnimation(caster, {duration=1, activity=ACT_DOTA_TELEPORT_END, rate=1.0})
		local particleName = "particles/econ/events/fall_major_2016/blink_dagger_start_fm06.vpcf"
		local pfx1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx1, 0, caster:GetAbsOrigin())
	    local newPosition = enemy:GetAbsOrigin()+RandomVector(RandomInt(200, 500))
	    FindClearSpaceForUnit(caster, newPosition, false)
		local pfx2 = ParticleManager:CreateParticle("particles/econ/events/fall_major_2016/blink_dagger_end_fm06.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx2, 0, newPosition)
		Timers:CreateTimer(3, function()
			ParticleManager:DestroyParticle(pfx1, false)
			ParticleManager:DestroyParticle(pfx2, false)
		end)			
	end 
end