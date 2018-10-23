require('heroes/invoker/aspects')
LinkLuaModifier("modifier_conjuror_grand_earth_guardian_target_lua", "modifiers/conjuror/modifier_conjuror_grand_earth_guardian_target_lua", LUA_MODIFIER_MOTION_NONE)

function earth_deity(event)
	local caster = event.caster
	local ability = event.ability
	local summonPosition = caster:GetAbsOrigin() + caster:GetForwardVector()*340
	caster.earthAspect = CreateUnitByName("earth_deity", summonPosition, true, caster, caster, caster:GetTeamNumber())
	ability:ApplyDataDrivenModifier(caster, caster.earthAspect, "modifier_aspect_invulnerable", {duration = 1})
	caster.earthAspect.conjuror = caster
	caster.earthAspect.owner = caster:GetPlayerOwnerID()
	caster.earthAspect:SetOwner(caster)
    caster.earthAspect:SetControllableByPlayer(caster:GetPlayerID(), true)
	local aspectAbility = caster.earthAspect:FindAbilityByName("aspect_abilities")
	aspectAbility:SetLevel(1)
	if caster.bIsAIonEARTH == true or caster.bIsAIonEARTH == nil then
		aspectAbility:ToggleAbility()
    end
	caster.earthAspect:FindAbilityByName("earth_deity_grand_guardian"):SetLevel(ability:GetLevel())
	caster.earthAspect.aspect = true
	caster.earthAspect.earthDeity = true
	-- aspectAbility:ApplyDataDrivenModifier(caster.earthAspect, caster.earthAspect, "modifier_aspect_main", {})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_earth_guardian", {})
    local earthParticle = "particles/units/heroes/hero_earth_spirit/espirit_bouldersmash_caster.vpcf"
	local pfx = ParticleManager:CreateParticle( earthParticle, PATTACH_CUSTOMORIGIN, caster.earthAspect )
	ParticleManager:SetParticleControl( pfx, 0, summonPosition )
	ParticleManager:SetParticleControl( pfx, 1, summonPosition )
	ParticleManager:SetParticleControl( pfx, 2, summonPosition )
	ParticleManager:SetParticleControl( pfx, 3, summonPosition )
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	local pfx = CustomAbilities:QuickParticleAtPoint("particles/roshpit/conjuror/earth_shock.vpcf", caster.earthAspect:GetAbsOrigin(), 3)
	EmitSoundOn("Hero_EarthSpirit.RollingBoulder.Destroy", caster.earthAspect)
  	local earthquake = caster:FindAbilityByName("arcana_earth_shock")
  	if not earthquake then
  		earthquake = caster:AddAbility("arcana_earth_shock")
  		earthquake:SetAbilityIndex(0)
  	end
  	earthquake:SetLevel(ability:GetLevel())
  	if caster:HasModifier("modifier_conjuror_immortal_weapon_3") then
  		caster.earthAspect:AddAbility("fire_temple_steadfast"):SetLevel(1)
  	end
	caster:SwapAbilities("summon_earth_deity", "arcana_earth_shock", false, true)
	ability:ApplyDataDrivenModifier(caster, caster.earthAspect, "modifier_earth_aspect_health", {})
	local aspectHealth = event.aspect_health
	if caster.aspectHealthAbility then
		aspectHealth = aspectHealth + caster:GetModifierStackCount( "modifier_weapon_aspect_health", caster.aspectHealthAbility )
	end
	if caster:HasModifier("modifier_conjuror_glyph_2_1") then
		aspectHealth = aspectHealth*1.8
	end
	-- local q_1_level = Runes:GetTotalRuneLevel(caster, 1, "q_1", "conjuror")
	-- aspectHealth = aspectHealth*(1+q_1_level*0.05)
	Timers:CreateTimer(0.05, function()
		caster.earthAspect:SetBaseDamageMax(event.aspect_damage)
		caster.earthAspect:SetBaseDamageMin(event.aspect_damage)
		caster.earthAspect:SetMaxHealth(aspectHealth)
		caster.earthAspect:SetBaseMaxHealth(aspectHealth)
		caster.earthAspect:SetHealth(aspectHealth)
		caster.earthAspect:Heal(aspectHealth, caster.earthAspect)
		StartAnimation(caster.earthAspect, {duration=2.05, activity=ACT_DOTA_CAST_ABILITY_2, rate=1.8})
		common_aspect_effects(caster, ability, caster.earthAspect)
	end)
	glyph_5_a(caster, ability, caster.earthAspect)
	local q_1_level = caster:GetRuneValue("q", 1)
	if q_1_level > 0 then
		caster.earthAspect:AddAbility("earth_deity_sandstorm"):SetLevel(1)
	end
	Events:ColorWearablesAndBase(caster.earthAspect, Vector(200,255,120))
end

function earth_deity_sandstorm_start(event)
	local caster = event.caster
	local ability = event.ability
	local particle_name = "particles/units/heroes/hero_sandking/sandking_sandstorm.vpcf"
	if ability.sandPFX then
		ParticleManager:DestroyParticle(ability.sandPFX, false)
	end
	ability.q_1_level = caster.conjuror:GetRuneValue("q", 1)
	ability.radius = ability.q_1_level * CONJUROR_ARCANA_Q1_RADIUS_SCALE + CONJUROR_ARCANA_Q1_RADIUS_BASE
	ability.sandPFX = ParticleManager:CreateParticle(particle_name, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(ability.sandPFX, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(ability.sandPFX, 1, Vector(ability.radius,ability.radius,ability.radius))
	EmitSoundOn("Conjuror.EarthDeity.SandstormStart", caster)
	StartSoundEvent("Conjuror.EarthDeity.SandstormLP", caster)
	ability.interval = 0
end

function earth_deity_sandstorm_end(event)
	local caster = event.caster
	local ability = event.ability
	StopSoundEvent("Conjuror.EarthDeity.SandstormLP", caster)
	Timers:CreateTimer(0.03, function()
		EndAnimation(caster)
		if ability.sandPFX then
			ParticleManager:DestroyParticle(ability.sandPFX, false)
			ability.sandPFX = false
		end
	end)
end

function earth_deity_sandstorm_thinking(event)
	local caster = event.caster
	local ability = event.ability
	local damage_mult = event.damage_mult
	local damage = caster:GetMaxHealth()*(CONJUROR_ARCANA_Q1_DMG_PERCENT_MAX_HEALTH/100)*ability.q_1_level
	local manaCost = 3
	if caster:GetMana() < manaCost then
		ability:ToggleAbility()
	else
		caster:ReduceMana(manaCost)
	end
	if ability.sandPFX then
		ParticleManager:SetParticleControl(ability.sandPFX, 0, caster:GetAbsOrigin())
	end
	if ability.interval%9 == 0 then
		if not caster:HasModifier("modifier_deity_grand_guardian") then
			StartAnimation(caster, {duration=2.05, activity=ACT_DOTA_CAST_ABILITY_3, rate=0.9})
		end
	end
	ability.interval = ability.interval + 1
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, ability.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_EARTH, RPC_ELEMENT_NONE)
		end
	end	
end

function earthshock_precast(event)
	local caster = event.caster
	if caster.earthAspect then
		if not caster:HasModifier("modifier_sandstorm_on") then
			StartAnimation(caster.earthAspect, {duration=1, activity=ACT_DOTA_CAST_ABILITY_2, rate=2.3})
		end
	end
end

function earthshock_cast(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	local radius = event.radius
	
	local duration = 3.0
    if caster:HasModifier("modifier_conjuror_glyph_5_1") then
    	duration = duration + 1.5
    end
    duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
    local damage = event.damage
	if not caster:HasModifier("modifier_free_quake") then
		if not caster:HasModifier("modifier_grand_guardian_in_deity") then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_free_quake", {duration = duration})
		end
	end
	if not ability.procCast then
		Filters:CastSkillArguments(1, caster)
		ability.procCast = true
	end
	fire_earth_shock(point, caster, radius, ability, damage)
	if caster.earthAspect then
		if caster.earthAspect:HasModifier("modifier_deity_grand_guardian") then
			radius = 600
		end
		fire_earth_shock(caster.earthAspect:GetAbsOrigin(), caster, radius, ability, damage, 0.9)
	end
end

function fire_earth_shock(position, caster, radius, ability, damage, slow_duration)
	local particleName = "particles/roshpit/conjuror/earth_shock.vpcf"
	if radius > 500 then
		particleName = "particles/roshpit/conjuror/big_earth_shock.vpcf"
	end
	local q_3_level = caster:GetRuneValue("q", 3)
	if q_3_level > 0 then
		damage = damage + OverflowProtectedGetAverageTrueAttackDamage(caster)*(CONJUROR_ARCANA_Q3_ATTACK_DMG_TO_EARTH_SHOCK_PCT/100)*q_3_level
	end
	local q_4_level = caster:GetRuneValue("q", 4)
	CustomAbilities:QuickParticleAtPoint(particleName, position, 3)
	EmitSoundOnLocationWithCaster(position, "Conjuror.EarthShockOverlay", caster)
	EmitSoundOnLocationWithCaster(position, "Conjuror.EarthShock", caster)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	local damageReduceDuration = 10
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_EARTH, RPC_ELEMENT_LIGHTNING)
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_earth_shock_slow", {duration = 0.9})
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_earth_shock_attack_reduce", {duration = damageReduceDuration})
			if q_4_level > 0 then
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_earthshock_damage_reduce", {duration = damageReduceDuration})
				enemy:SetModifierStackCount("modifier_earthshock_damage_reduce", caster, q_4_level)
			end
		end
	end	
end

function earth_deity_grand_guardian(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
	end
	if caster:GetEntityIndex() == target:GetEntityIndex() then
		ability:EndCooldown()
		return false
	end
	if ability.target then
		if IsValidEntity(ability.target) then
			if ability.target:HasModifier("modifier_grand_guardian_in_deity") or ability.target:HasModifier("modifier_deity_guardian_taxi_effect") then
				reset_target(ability.target)
				FindClearSpaceForUnit(ability.target, ability.target:GetAbsOrigin(), false)
			end
		end
	end
	local fv = ((target:GetAbsOrigin() - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	EmitSoundOn("Conjuror.GrandGuardianStart", caster)
	local particle_name = "particles/units/heroes/hero_earth_spirit/espirit_rollingboulder.vpcf"
	local pfx = ParticleManager:CreateParticle(particle_name, PATTACH_OVERHEAD_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false)
	ParticleManager:SetParticleControl(pfx, 10, Vector(2,2,2))
	ability.pfx = pfx
	StartAnimation(caster, {duration=1.05, activity=ACT_DOTA_CAST_ABILITY_3, rate=0.8})
	ability.target = target
	Timers:CreateTimer(0.3, function()
		caster:SetForwardVector(fv)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_deity_grand_guardian", {duration = 12})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_grand_guardian_regen", {duration = 12})
	end)
	target:AddNewModifier(caster, ability, "modifier_conjuror_grand_earth_guardian_target_lua", {duration = 24})
	caster:AddNewModifier(caster, ability, "modifier_conjuror_grand_earth_guardian_target_lua", {duration = 24})
	if not caster:HasAbility("earth_deity_bowl") then
		caster:AddAbility("earth_deity_bowl"):SetLevel(1)
	end
	ability.phase = 0
	CustomAbilities:QuickAttachParticle("particles/items_fx/infernal_summon_spawn_spotlight.vpcf", caster, 3)
	EmitSoundOn("Conjuror.RollingBoulderStart", target)
	StartSoundEvent("Conjuror.RollingBoulderLP", target)
end

function earth_deity_main_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local target = ability.target
	if ability.phase == 0 then
		if caster:IsAlive() then
			local move_direction = ((caster:GetAbsOrigin()+Vector(0,0,240))-target:GetAbsOrigin()):Normalized()
			target:SetAbsOrigin(target:GetAbsOrigin() + move_direction*80)
			local distance = WallPhysics:GetDistance(target:GetAbsOrigin(), caster:GetAbsOrigin()+Vector(0,0,240))
			if distance < 90 then
				target:SetAbsOrigin(target:GetAbsOrigin())
				ability.phase = 1
				target:RemoveModifierByName("modifier_deity_guardian_taxi_effect")		
				if ability.pfx then
					ParticleManager:DestroyParticle(ability.pfx, false)
					ability.pfx = false
				end
				ability:ApplyDataDrivenModifier(caster, target, "modifier_grand_guardian_in_deity", {duration = 12})
				ability:ApplyDataDrivenModifier(caster, target, "modifier_grand_guardian_regen", {duration = 12})
				for i = 0, math.min(target:GetAbilityCount(), 16), 1 do
					local check_ability = target:GetAbilityByIndex(i)
					if check_ability then
						if check_ability:GetAbilityName() == "arcana_earth_shock" then
						else
							check_ability:SetActivated(false)
						end
					end
				end
				EmitSoundOn("Conjuror.GrandGuardianEntered", target)
				StopSoundEvent("Conjuror.RollingBoulderLP", target)
			end
		else
			target:RemoveModifierByName("modifier_deity_guardian_taxi_effect")
			if ability.pfx then
				ParticleManager:DestroyParticle(ability.pfx, false)
				ability.pfx = false
			end
		end
	end
end

function taxi_effect_end(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ability.pfx = false
	end
	StopSoundEvent("Conjuror.RollingBoulderLP", target)
	target:RemoveModifierByName("modifier_deity_guardian_taxi_effect")
end

function grand_guardian_deity_end(event)
	local caster = event.caster
	local ability = event.ability
	local target = ability.target
	if not target:HasModifier("modifier_deity_guardian_taxi_bowling") then
		reset_target(target)
	end
	caster:RemoveModifierByName("modifier_grand_guardian_regen")
	caster:RemoveModifierByName("modifier_conjuror_grand_earth_guardian_target_lua")
	FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
	if caster:HasAbility("earth_deity_bowl") then
		caster:RemoveAbility("earth_deity_bowl")
	end
end

function reset_target(target)
	target:RemoveModifierByName("modifier_deity_guardian_taxi_effect")
	target:RemoveModifierByName("modifier_grand_guardian_in_deity")
	target:RemoveModifierByName("modifier_conjuror_grand_earth_guardian_target_lua")
	target:RemoveModifierByName("modifier_grand_guardian_regen")
	for i = 0, math.min(target:GetAbilityCount(), 16), 1 do
		local check_ability = target:GetAbilityByIndex(i)
		if check_ability then
			check_ability:SetActivated(true)
		end
	end
end

function earth_deity_bowl(event)
	local caster = event.caster
	local ability = caster:FindAbilityByName("earth_deity_grand_guardian")
	local target = ability.target
	local point = event.target_points[1]
	caster:RemoveModifierByName("modifier_deity_grand_guardian")
	ability.point = point
	ability.phase = 2
	local fv = ((point - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	caster:SetForwardVector(fv)
	local particle_name = "particles/units/heroes/hero_earth_spirit/espirit_rollingboulder.vpcf"
	local pfx = ParticleManager:CreateParticle(particle_name, PATTACH_OVERHEAD_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false)
	ParticleManager:SetParticleControl(pfx, 10, Vector(2,2,2))
	ability.pfx = pfx
	StartAnimation(caster, {duration=1.55, activity=ACT_DOTA_CAST_ABILITY_2, rate=1.2})
	local perpVector = WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi/4)
	target:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin()+perpVector*220+caster:GetForwardVector()*120, target))
	EmitSoundOn("Conjuror.RollingBoulderStart", target)
	StartSoundEvent("Conjuror.RollingBoulderLP", target)
	Timers:CreateTimer(0.6, function()
		EmitSoundOn("Conjuror.RollingBoulderThrow", target)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_deity_guardian_taxi_bowling", {duration = 4})
	end)
end

function bowling_think(event)
	local target = event.target
	local ability = event.ability
	local point = ability.point
	local move_direction = (point-target:GetAbsOrigin()):Normalized()

	local newPosition = target:GetAbsOrigin() + move_direction*80
	local obstruction = WallPhysics:FindNearestObstruction(newPosition)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition, target)
	if not blockUnit then
		target:SetAbsOrigin(newPosition)
	else
		target:RemoveModifierByName("modifier_deity_guardian_taxi_bowling")
	end
	local distance = WallPhysics:GetDistance(target:GetAbsOrigin(), point)
	if distance < 90 then
		target:RemoveModifierByName("modifier_deity_guardian_taxi_bowling")
	end
end

function bowling_end(event)
	local caster = event.caster
	local ability = event.ability
	local target = ability.target
	local shockAbility = caster.conjuror:FindAbilityByName("arcana_earth_shock")
	local damage = shockAbility:GetSpecialValueFor("damage")
	fire_earth_shock(target:GetAbsOrigin(), caster.conjuror, 320, shockAbility, damage, 0.9)
	reset_target(target)
	StopSoundEvent("Conjuror.RollingBoulderLP", target)
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ability.pfx = false
	end
	Timers:CreateTimer(0.03, function()
		FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
	end)
end

function conjuror_arcana3_passive_thinker(event)
	local caster = event.target
	local ability = caster:FindAbilityByName("summon_earth_deity")
	local q_2_level = caster:GetRuneValue("q", 2)
	if q_2_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_earth_deity_q_2", {})
		caster:SetModifierStackCount("modifier_earth_deity_q_2", caster, q_2_level)
	else
		caster:RemoveModifierByName("modifier_earth_deity_q_2")
	end
	caster.q_3_level = caster:GetRuneValue("q", 3)
end