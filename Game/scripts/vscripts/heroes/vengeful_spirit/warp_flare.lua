require('heroes/vengeful_spirit/supernova')
require('heroes/vengeful_spirit/alpha_spark')

function warp_flare_phase_start(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Selethas.Throw.VO", caster)
end

function warp_flare_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	caster:RemoveModifierByName("modifier_solunia_flare_flying")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_solunia_flare_flying", {duration = 3.0})
	caster:RemoveModifierByName("modifier_solunia_in_between_flare")
	flareParticle(caster:GetAbsOrigin(), caster, ability)
	-- StartAnimation(caster, {duration=0.4, activity=ACT_DOTA_CAST_ABILITY_2, rate=1.5})
	ability.targetPoint = target
	ability.fv = ((target - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	caster:RemoveModifierByName("modifier_lava_jumping")
	if not ability.bandTable then
		ability.bandTable = {}
	end
	if not ability.flareCount then
		ability.flareCount = 0
		Filters:CastSkillArguments(3, caster)
	end
	local pfx = nil
	local particleName = "particles/roshpit/solunia/warp_flare_beam_beam_blade_golden.vpcf"
	if ability:GetAbilityName() == "solunia_lunar_warp_flare" then
		particleName = "particles/roshpit/solunia/lunar_warp_beam_blade_golden.vpcf"
	end
	pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ability.particle = false
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()+Vector(0,0,30) - ability.fv*30)
	table.insert(ability.bandTable, pfx)
	ability.currentBand = #ability.bandTable
	EmitSoundOn("Solunia.WarpFlare", caster)
	rune_e_2_galaxy_nitro(caster, ability)
	c_c_pit(caster, ability, target)

	caster:FindAbilityByName("solunia_solarang"):SetActivated(false)
	if caster:HasAbility("solunia_lunarang") then
		caster:FindAbilityByName("solunia_lunarang"):SetActivated(false)
	end
	if caster:HasAbility("solunia_solar_glow") then
		caster:FindAbilityByName("solunia_solar_glow"):SetActivated(false)
	end
	if caster:HasAbility("solunia_lunar_glow") then
		caster:FindAbilityByName("solunia_lunar_glow"):SetActivated(false)
	end
end

function reactivateBoomerangAbility(abilityName, caster)
	if caster:HasAbility(abilityName) then
		local ability = caster:FindAbilityByName(abilityName)
		local maxBoomerangs = ability:GetSpecialValueFor("max_boomerangs")
	    if caster:HasModifier("modifier_solunia_glyph_1_1") then
	    	maxBoomerangs = maxBoomerangs + 2
	    end
		if ability.boomerangTable then
			if #ability.boomerangTable < maxBoomerangs then
				ability:SetActivated(true)
			end
		else
			ability:SetActivated(true)
		end
	end
end

function warp_flare_flying_think(event)
	local caster = event.caster
	local ability = event.ability
	local blockSearch = caster:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,GetGroundHeight(caster:GetAbsOrigin(), caster))
    local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch+ability.fv*45), caster)
    local forwardSpeed = 80
	if blockUnit then
		forwardSpeed = 0
		end_warp_phase(caster, ability)
		return
	end
	
	caster:SetAbsOrigin(caster:GetAbsOrigin()+ability.fv*forwardSpeed)
	local groundHeight = GetGroundHeight(caster:GetAbsOrigin(), caster)
	local liftVector = Vector(0,0,0)
	if caster:GetAbsOrigin().z - groundHeight < 300 then
		liftVector = Vector(0,0,15)
	end
	caster:SetAbsOrigin(caster:GetAbsOrigin()+liftVector)
	if ability.bandTable[ability.currentBand] then
		ParticleManager:SetParticleControl(ability.bandTable[ability.currentBand], 1, caster:GetAbsOrigin()+Vector(0,0,30)+ability.fv*60)
	end
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.targetPoint)
	if distance < 85 then
		if not ability.lock then
			end_warp_phase(caster, ability)
		end
	end
	if distance > 2300 then
		end_warp_phase(caster, ability)
	end
end

function end_warp_phase(caster, ability)
	if not ability.flareCount then
		return false
	end
	ability.flareCount = ability.flareCount + 1
	caster:RemoveModifierByName("modifier_solunia_flare_flying")
	ability.lock = true
	Timers:CreateTimer(0.1, function()
		ability.lock = false
	end)
	ability.betweenFlareRotation = 1
	ability.startRotation = vectorToAngle(ability.fv)
	flareParticle(caster:GetAbsOrigin(), caster, ability)
	local maxFlares = 3
	if caster:HasModifier("modifier_solunia_glyph_7_1") then
		maxFlares = maxFlares + 2
	end
	if ability.flareCount >= maxFlares then
		end_warp_flare(ability,caster)
		max_flares_achieved(caster, ability)
	else
		ability:EndCooldown()
		local inBetweenTime = 2
		if caster:HasModifier("modifier_solunia_glyph_4_1") then
			inBetweenTime = inBetweenTime + 1.5
		end
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_solunia_in_between_flare", {duration = inBetweenTime})
	end
end

function flareParticle(position, caster, ability)
	local particleName = "particles/roshpit/solunia/solar_flare_no_ground.vpcf"
	if ability:GetAbilityName() == "solunia_lunar_warp_flare" then
		particleName = "particles/roshpit/solunia/lunar_flare_explosion_immortal1.vpcf"
	end
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, position)
	EmitSoundOn("Solunia.WarpExplosion", caster)
	Timers:CreateTimer(4, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:ReleaseParticleIndex(pfx)
	end)
end

function inbetween_flare_think(event)
	local caster = event.caster
	local ability = event.ability
	ability.betweenFlareRotation = ability.betweenFlareRotation + 1
	caster:SetAngles(0, ability.betweenFlareRotation*0.5+ability.startRotation, 0)
	caster:SetAbsOrigin(caster:GetAbsOrigin()+math.cos(ability.betweenFlareRotation*math.pi/50)*1.2)
	-- caster:SetForwardVector(newFV)
	-- Vector(1,0) = 0
	-- Vector(1,1) = 45
	-- Vector(0,1) = 90
	-- Vector(-1,1) = 135
	-- Vector(-1,0) = 180
end

function vectorToAngle(vector)
	return math.atan2(vector.y, vector.x)*180/math.pi
end

function inbetween_flare_start(event)
	local caster = event.caster
	local ability = event.ability
	if caster:HasModifier("modifier_solunia_immortal_weapon_1") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_solunia_warp_flare_immortal_weapon_effect", {})
	end
end

function inbetween_flare_end(event)
	local caster = event.caster
	local ability = event.ability
	if not ability.flareCount then
		return false
	end
	caster:RemoveModifierByName("modifier_solunia_warp_flare_immortal_weapon_effect")
	caster:SetAngles(0,0,0)
	if not caster:HasModifier("modifier_solunia_flare_flying") then
		end_warp_flare(ability,caster)
	end
end

function end_warp_flare(ability,caster)
	if not caster:HasModifier("modifier_channel_start") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_solunia_warp_flare_falling", {duration = 4})
	end
	reactivateBoomerangAbility("solunia_solarang", caster)
	reactivateBoomerangAbility("solunia_lunarang", caster)
	if caster:HasAbility("solunia_solar_glow") then
		caster:FindAbilityByName("solunia_solar_glow"):SetActivated(true)
	end
	if caster:HasAbility("solunia_lunar_glow") then
		caster:FindAbilityByName("solunia_lunar_glow"):SetActivated(true)
	end
	ability.fallVelocity = 3
	print(ability.flareCount)
	flareParticle(caster:GetAbsOrigin(), caster, ability)
	local maxFlares = 3
	if caster:HasModifier("modifier_solunia_glyph_7_1") then
		maxFlares = maxFlares + 2
	end
	-- if ability.flareCount < maxFlares then
		Filters:ReduceECooldown(caster, ability, ability:GetCooldown(ability:GetLevel()), true)
	-- end

	ability.flareCount = false
	Timers:CreateTimer(0.4, function()
		for i = 1, #ability.bandTable, 1 do
			ParticleManager:DestroyParticle(ability.bandTable[i], false)
			ParticleManager:ReleaseParticleIndex(ability.bandTable[i])
		end
		ability.bandTable = {}
	end)
	local a_c_level = Runes:GetTotalRuneLevel(caster, 1, "e_1", "solunia")
	if a_c_level > 0 then
		local warpAbility = caster:FindAbilityByName("solunia_warp_flare")
		local a_c_duration = Filters:GetAdjustedBuffDuration(caster, 18, false)
		warpAbility:ApplyDataDrivenModifier(caster, caster, "modifier_solunia_rune_e_1_ready", {duration = a_c_duration})
		caster:SetModifierStackCount("modifier_solunia_rune_e_1_ready", caster, 2)
	end
end

function after_flare_falling(event)
	local caster = event.caster
	local ability = event.ability
	caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,ability.fallVelocity))
	ability.fallVelocity = ability.fallVelocity + 2
	local groundHeight = GetGroundHeight(caster:GetAbsOrigin(), caster)
	if caster:GetAbsOrigin().z - groundHeight < ability.fallVelocity/2 then
		caster:RemoveModifierByName("modifier_solunia_warp_flare_falling")
		WallPhysics:ClearSpaceForUnit(caster, caster:GetAbsOrigin())
		StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_SPAWN, rate=1.8})
	end
end

function rune_e_2_galaxy_nitro(caster, ability)
	local b_c_level =  Runes:GetTotalRuneLevel(caster, 2, "e_2", "solunia")
	if b_c_level > 0 then
		local solarangAbility = caster:FindAbilityByName("solunia_solarang")
		local lunarangAbility = caster:FindAbilityByName("solunia_lunarang")
		local totalBoomerangTable = {}
		if solarangAbility.boomerangTable then
			for i = 1, #solarangAbility.boomerangTable, 1 do
				table.insert(totalBoomerangTable, solarangAbility.boomerangTable[i])
			end
		end
		if lunarangAbility then
			if lunarangAbility.boomerangTable then
				for i = 1, #lunarangAbility.boomerangTable, 1 do
					table.insert(totalBoomerangTable, lunarangAbility.boomerangTable[i])
				end
			end
		end
		for i = 1, #totalBoomerangTable, 1 do
			local boomerang = totalBoomerangTable[i]
			AddFOWViewer(boomerang.origCaster:GetTeamNumber(), boomerang:GetAbsOrigin(), 200, 3, false)
			local particleName = "particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf"
			if boomerang:HasModifier("boomerang_passive_lunar") then
				particleName = "particles/roshpit/solunia/lunar_flare_explosion_immortal1.vpcf"
			end
		  	local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, boomerang.origCaster )
		  	local origin = boomerang:GetAbsOrigin()
		  	ParticleManager:SetParticleControl( particle1, 0, origin )
		  	Timers:CreateTimer(3, function()
		  		ParticleManager:DestroyParticle(particle1, false)
		  	end)
		  	EmitSoundOn("Solunia.SolarGlow.Impact", boomerang)
			local damageType = DAMAGE_TYPE_MAGICAL
			if caster:HasModifier("boomerang_passive_lunar") then
				damageType = DAMAGE_TYPE_PURE
			end
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), boomerang:GetAbsOrigin(), nil, 270, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			if #enemies > 0 then
				for _,enemy in pairs(enemies) do
					print(caster.damage)
					Filters:TakeArgumentsAndApplyDamage(enemy, caster, boomerang.damage*(1+(b_c_level*0.2)), damageType, 2, RPC_ELEMENT_COSMOS, RPC_ELEMENT_NONE)
					Filters:ApplyStun(caster, b_c_level*0.08, enemy)
				end
			end 
		end
	end
end

function c_c_pit(caster, ability, targetPoint)
	local c_c_level = Runes:GetTotalRuneLevel(caster, 3, "e_3", "solunia")
	ability.e_3_level = c_c_level
	if c_c_level > 0 then
		local duration = 1 + 0.3*c_c_level
		local modifierName = "modifier_solunia_warp_core_thinker"
		if caster:HasModifier("modifier_solunia_glyph_5_1") then
			modifierName = modifierName.."_glyphed"
			duration = duration/2
		end
		duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
		ability:ApplyDataDrivenThinker(caster, GetGroundPosition(targetPoint, caster), modifierName, {duration = duration})
	end
end

function rune_unit_4_think(event)
	local caster = event.caster
	local ability = event.ability
	local hero = caster.hero
	local totalLevel = Runes:GetTotalRuneLevel(hero, 4, "e_4", "solunia")
	if totalLevel > 0 then
		local stackCount = totalLevel
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_solunia_rune_e_4_effect", {})
		hero:SetModifierStackCount( "modifier_solunia_rune_e_4_effect", ability, stackCount )
	end
end

function max_flares_achieved(caster, ability)
	if caster:HasModifier("modifier_solunia_immortal_weapon_3") then
		local ability1name = "solunia_warp_flare"
		local ability2name = "solunia_lunar_warp_flare"
		if ability:GetAbilityName() == ability1name then
			if caster:HasModifier("modifier_solunia_arcana2") then
				local ultAbility = caster:FindAbilityByName("solunia_solar_alpha_spark")
				if ultAbility:GetCooldownTimeRemaining() == 0 then
					local eventTable = {}
					eventTable.caster = caster
					eventTable.ability = ultAbility
					eventTable.target_points = {}
					eventTable.target_points[1] = caster:GetAbsOrigin()
					eventTable.radius = 450
					eventTable.type = "sun"
					eventTable.damage = ultAbility:GetLevelSpecialValueFor("damage", ultAbility:GetLevel())
					eventTable.stun_duration = ultAbility:GetLevelSpecialValueFor("stun_duration", ultAbility:GetLevel())
					begin_alpha_spark(eventTable)
					ultAbility:StartCooldown(ultAbility:GetCooldown(ultAbility:GetLevel()))
				end
			else
				local ultAbility = caster:FindAbilityByName("solunia_supernova")
				ultAbility.rotationIndex = 0
				ultAbility.fallVelocity = 1
				ultAbility.startRotation = vectorToAngle(caster:GetForwardVector())
				if ultAbility:GetCooldownTimeRemaining() == 0 then
					local eventTable = {}
					eventTable.caster = caster
					eventTable.ability = ultAbility
					eventTable.radius = 450
					eventTable.damage = ultAbility:GetLevelSpecialValueFor("damage", ultAbility:GetLevel())
					eventTable.stun_duration = ultAbility:GetLevelSpecialValueFor("stun_duration", ultAbility:GetLevel())
					begin_supernova(eventTable)
					ultAbility:StartCooldown(ultAbility:GetCooldown(ultAbility:GetLevel()))
				end
			end
		elseif ability:GetAbilityName() == ability2name then
			if caster:HasModifier("modifier_solunia_arcana2") then
				local ultAbility = caster:FindAbilityByName("solunia_lunar_alpha_spark")
				if ultAbility:GetCooldownTimeRemaining() == 0 then
					local eventTable = {}
					eventTable.caster = caster
					eventTable.ability = ultAbility
					eventTable.target_points = {}
					eventTable.target_points[1] = caster:GetAbsOrigin()
					eventTable.radius = 450
					eventTable.type = "moon"
					eventTable.damage = ultAbility:GetLevelSpecialValueFor("damage", ultAbility:GetLevel())
					eventTable.stun_duration = ultAbility:GetLevelSpecialValueFor("stun_duration", ultAbility:GetLevel())
					begin_alpha_spark(eventTable)
					ultAbility:StartCooldown(ultAbility:GetCooldown(ultAbility:GetLevel()))
				end
			else
				local ultAbility = caster:FindAbilityByName("solunia_eclipse")
				ultAbility.rotationIndex = 0
				ultAbility.fallVelocity = 1
				ultAbility.startRotation = vectorToAngle(caster:GetForwardVector())
				if ultAbility:GetCooldownTimeRemaining() == 0 then
					local eventTable = {}
					eventTable.caster = caster
					eventTable.ability = ultAbility
					eventTable.radius = 450
					eventTable.damage = ultAbility:GetLevelSpecialValueFor("damage", ultAbility:GetLevel())
					eventTable.stun_duration = ultAbility:GetLevelSpecialValueFor("stun_duration", ultAbility:GetLevel())
					begin_eclipse(eventTable)
					ultAbility:StartCooldown(ultAbility:GetCooldown(ultAbility:GetLevel()))
				end
			end
		end
	end
end