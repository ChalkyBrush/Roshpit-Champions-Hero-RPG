function icy_venge_think(event)
	local caster = event.caster
	local castAbility = caster:FindAbilityByName("serengaard_wave_of_terror")
	if castAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 940, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local castPoint = enemies[1]:GetAbsOrigin()
			local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = castAbility:entindex(),
				Position = castPoint
			}

			ExecuteOrderFromTable(newOrder)
			return true
		end
	end
	local castAbility2 = caster:FindAbilityByName("serengaard_ice_vortex")
	if castAbility2:IsFullyCastable() then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 940, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local castPoint = enemies[1]:GetAbsOrigin()
			local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = castAbility2:entindex(),
				Position = castPoint
			}

			ExecuteOrderFromTable(newOrder)
			return true
		end
	end
end

function flying_unit_think(event)
	local caster = event.caster
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 180, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
	local bMove = false
	if #enemies > 0 then
		for i = 1, #enemies, 1 do
			if enemies[i]:HasFlyMovementCapability() then
				bMove = enemies[i]
				break
			end
		end
		if bMove then
			local moveDirection = (caster:GetAbsOrigin() - bMove:GetAbsOrigin()):Normalized()
			caster:MoveToPosition(caster:GetAbsOrigin() + moveDirection * 190)
			Timers:CreateTimer(1, function()
				caster:MoveToPositionAggressive(Vector(0, 0))
			end)
		end
	end
end

function serengaard_pudge_hook_throw(event)
	local caster = event.caster
	local ability = event.ability
	ability.hookPFX = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_meathook.vpcf", PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControl(ability.hookPFX, 3, Vector(3, 2, 2))
	ParticleManager:SetParticleControl(ability.hookPFX, 2, Vector(1200, 1200, 1200))
	ParticleManager:SetParticleControlEnt(ability.hookPFX, 0, caster, PATTACH_POINT_FOLLOW, "attach_hook", caster:GetAbsOrigin(), true)

	ParticleManager:SetParticleControlEnt(ability.hookPFX, 7, caster, PATTACH_POINT_FOLLOW, "attach_hook", caster:GetAbsOrigin(), true)

	ability.point = event.target_points[1]
	print("POINT?")
	print(ability.point)
	ParticleManager:SetParticleControl(ability.hookPFX, 1, ability.point)
	-- ParticleManager:SetParticleControl(ability.hookPFX, 6, ability.point)

	-- for i = 4, 12, 1 do
	-- ParticleManager:SetParticleControl(ability.hookPFX, i, ability.point)
	-- end
	ParticleManager:SetParticleControl(ability.hookPFX, 6, ability.point)
	ability.movementVector = ((ability.point - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	ability.hookPos = caster:GetAbsOrigin() + Vector(0, 0, 80)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_pudge_root", {duration = 1.2})
	EmitSoundOn("Serengaard.HookThrow", caster)
	local start_radius = 90
	local end_radius = 90
	local casterOrigin = caster:GetAbsOrigin()

	local info =
	{
		Ability = ability,
		EffectName = "particles/units/heroes/hero_pudge/pudge_meathook.vpcf",
		vSpawnOrigin = ability.hookPos,
		fDistance = 1200,
		fStartRadius = start_radius,
		fEndRadius = end_radius,
		Source = caster,
		StartPosition = "attach_hitloc",
		bHasFrontalCone = true,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO,
		fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = true,
		vVelocity = ability.movementVector * 1000,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)

	StartAnimation(caster, {duration = 1.0, activity = ACT_DOTA_OVERRIDE_ABILITY_1, rate = 1.0})
	ability.impact = false
	ability.retract = false
	ability.target = false
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_pudge_hook_movement", {duration = 1.2})

end

function hook_moving_think(event)
	local caster = event.caster
	local ability = event.ability
	if ability.retract then
		local moveVector = ((caster:GetAbsOrigin() - ability.hookPos) * Vector(1, 1, 0)):Normalized()
		ability.hookPos = ability.hookPos + moveVector * 30
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.hookPos)
		if distance < 50 then
			caster:RemoveModifierByName("modifier_pudge_hook_movement")
		end
	else
		ability.hookPos = ability.hookPos + ability.movementVector * 30
	end
	ParticleManager:SetParticleControl(ability.hookPFX, 6, ability.hookPos)
	ParticleManager:SetParticleControl(ability.hookPFX, 4, ability.hookPos)
	-- ParticleManager:SetParticleControl(ability.hookPFX, 1, ability.hookPos)

end

function hook_reach_end(event)
	local caster = event.caster
	local ability = event.ability
	if ability.retract then
		if ability.target then
			local target = ability.target
			ability.target:RemoveModifierByName("modifier_hook_stunned")
			FindClearSpaceForUnit(ability.target, target:GetAbsOrigin(), false)
		end
		EmitSoundOn("Serengaard.HookRetract", caster)
		StartAnimation(caster, {duration = 1.0, activity = ACT_DOTA_CHANNEL_ABILITY_1, rate = 1.0})
		ParticleManager:DestroyParticle(ability.hookPFX, false)
	else
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_pudge_hook_movement", {duration = 1.2})
		ability.retract = true
	end
end

function hook_impact(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if target:GetUnitName() == "serengaard_ancient_guardian" or target:GetUnitName() == "rpc_serengaard_ancient" then
		return false
	end
	if target:HasModifier("modifier_hook_stunned") then
		target.hookAbility.target = false
	end
	target.hookAbility = ability
	print("HOOK IMPACT!")
	EmitSoundOn("Serengaard.HookImpact", target)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_pudge_hook_movement", {duration = 1.5})
	ability.retract = true
	ability.target = target
	ability:ApplyDataDrivenModifier(caster, target, "modifier_hook_stunned", {duration = 1.5})
	ParticleManager:SetParticleControl(ability.hookPFX, 1, caster:GetAbsOrigin())
end

function hook_stunned_think(event)
	local ability = event.ability
	local target = ability.target
	target:SetAbsOrigin(GetGroundPosition(ability.hookPos - ability.movementVector * 30, caster))
end

function serengaard_sandking_ai(event)
	local caster = event.caster
	local castAbility = caster:FindAbilityByName("serengaard_burrowstrike")
	if castAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 640, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local castPoint = enemies[1]:GetAbsOrigin() + RandomVector(200)
			local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = castAbility:entindex(),
				Position = castPoint
			}

			ExecuteOrderFromTable(newOrder)
			return true
		end
	end
	if caster:GetHealth() < caster:GetMaxHealth() * 0.5 then
		if not caster:HasModifier("modifier_sandstorm_cooldown") then
			event.ability:ApplyDataDrivenModifier(event.caster, caster, "modifier_serengaard_sand_storm", {duration = 5})
			event.ability:ApplyDataDrivenModifier(event.caster, caster, "modifier_sandstorm_cooldown", {duration = 25})
			StartSoundEvent("Ability.SandKing_SandStorm.loop", caster)
		end
	end
end

function sandstorm_heal_think(event)
	local target = event.caster
	local healAmount = math.floor(target:GetMaxHealth() * 0.05)
	Filters:ApplyHeal(target, target, healAmount, true)
end

function sandstorm_end(event)
	local target = event.caster

	StopSoundEvent("Ability.SandKing_SandStorm.loop", target)
	target:RemoveModifierByName("modifier_invisible")
end

function experimental_minion_ai(event)
	local caster = event.caster
	local castAbility = caster:FindAbilityByName("experimental_chronosphere")
	if castAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 540, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local castPoint = enemies[1]:GetAbsOrigin() + RandomVector(260)
			local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = castAbility:entindex(),
				Position = castPoint
			}

			ExecuteOrderFromTable(newOrder)
			return true
		end
	end
end

CAST_SOUND_TABLE = {"nevermore_nev_anger_04", "nevermore_nev_anger_06", "nevermore_nev_anger_07", "nevermore_nev_arc_laugh_04", "nevermore_nev_arc_laugh_05", "nevermore_nev_arc_laugh_02"}

function begin_explosion(event)
	local caster = event.caster
	local ability = event.ability
	local abilityLevel = ability:GetLevel()
	local location = caster:GetOrigin()
	local forwardVector = caster:GetForwardVector()
	StartAnimation(caster, {duration = 2, activity = ACT_DOTA_CAST_ABILITY_6, rate = 1})
	local randInt = RandomInt(0, 2)
	if randInt == 0 then
		pattern1(forwardVector, location, ability, caster, abilityLevel)
	elseif randInt == 1 then
		pattern2(forwardVector, location, ability, caster, abilityLevel)
	elseif randInt == 2 then
		pattern3(forwardVector, location, ability, caster, abilityLevel)
	end
	EmitSoundOn(CAST_SOUND_TABLE[RandomInt(1, 6)], caster)
	--StartAnimation(caster, {duration=.5, activity=ACT_DOTA_CAST_ABILITY_3, rate=.8, translate="blood_chaser"})

end

function pattern1(forwardVector, location, ability, caster, abilityLevel)
	local rotatedVector = forwardVector
	local targetPoint = nil
	for i = -3, 3, 1 do
		rotatedVector = rotateVector(forwardVector, i * 2 * math.pi / 7) * Vector(200, 200, 0)
		targetPoint = rotatedVector + location * Vector(1, 1, 0)
		create_individual_explosion(abilityLevel, caster, targetPoint, location)
	end
	Timers:CreateTimer(0.3, function()
		EmitSoundOn("Hero_Nevermore.Shadowraze", caster)
		for i = -3, 3, 1 do
			rotatedVector = rotateVector(forwardVector, i * 2 * math.pi / 7) * Vector(400, 400, 0)
			targetPoint = rotatedVector + location * Vector(1, 1, 0)
			create_individual_explosion(abilityLevel, caster, targetPoint, location)
		end
	end)
	Timers:CreateTimer(0.6, function()
		EmitSoundOn("Hero_Nevermore.Shadowraze", caster)
		for i = -6, 6, 1 do
			rotatedVector = rotateVector(forwardVector, i * 2 * math.pi / 13) * Vector(600, 600, 0)
			targetPoint = rotatedVector + location * Vector(1, 1, 0)
			create_individual_explosion(abilityLevel, caster, targetPoint, location)
		end
	end)
	Timers:CreateTimer(0.9, function()
		EmitSoundOn("Hero_Nevermore.Shadowraze", caster)
		for i = -9, 9, 1 do
			rotatedVector = rotateVector(forwardVector, i * 2 * math.pi / 19) * Vector(600, 600, 0)
			targetPoint = rotatedVector + location * Vector(1, 1, 0)
			create_individual_explosion(abilityLevel, caster, targetPoint, location)
		end
	end)

end

function pattern2(forwardVector, location, ability, caster, abilityLevel)
	local rotatedVector = forwardVector
	local targetPoint = nil
	local perp = perpendicularVector(forwardVector)
	for i = -2, 2, 1 do
		targetPoint = (location + forwardVector * Vector(200, 200, 0)) + forwardVector + perp * Vector(200, 200, 0) * i
		create_individual_explosion(abilityLevel, caster, targetPoint, location)
	end
	Timers:CreateTimer(.15, function()
		EmitSoundOn("Hero_Nevermore.Shadowraze", caster)
		for i = -2, 2, 1 do
			targetPoint = (location + forwardVector * Vector(400, 400, 0)) + forwardVector + perp * Vector(200, 200, 0) * i
			create_individual_explosion(abilityLevel, caster, targetPoint, location)
		end
	end)
	Timers:CreateTimer(.3, function()
		EmitSoundOn("Hero_Nevermore.Shadowraze", caster)
		for i = -2, 2, 1 do
			targetPoint = (location + forwardVector * Vector(600, 600, 0)) + forwardVector + perp * Vector(200, 200, 0) * i
			create_individual_explosion(abilityLevel, caster, targetPoint, location)
		end
	end)
	Timers:CreateTimer(.45, function()
		EmitSoundOn("Hero_Nevermore.Shadowraze", caster)
		for i = -2, 2, 1 do
			targetPoint = (location + forwardVector * Vector(800, 800, 0)) + forwardVector + perp * Vector(200, 200, 0) * i
			create_individual_explosion(abilityLevel, caster, targetPoint, location)
		end
	end)
	Timers:CreateTimer(.6, function()
		EmitSoundOn("Hero_Nevermore.Shadowraze", caster)
		for i = -2, 2, 1 do
			targetPoint = (location + forwardVector * Vector(1000, 1000, 0)) + forwardVector + perp * Vector(200, 200, 0) * i
			create_individual_explosion(abilityLevel, caster, targetPoint, location)
		end
	end)
	Timers:CreateTimer(0.75, function()
		EmitSoundOn("Hero_Nevermore.Shadowraze", caster)
		for i = -2, 2, 1 do
			targetPoint = (location + forwardVector * Vector(1200, 1200, 0)) + forwardVector + perp * Vector(200, 200, 0) * i
			create_individual_explosion(abilityLevel, caster, targetPoint, location)
		end
	end)
	Timers:CreateTimer(0.9, function()
		EmitSoundOn("Hero_Nevermore.Shadowraze", caster)
		for i = -2, 2, 1 do
			targetPoint = (location + forwardVector * Vector(1400, 1400, 0)) + forwardVector + perp * Vector(200, 200, 0) * i
			create_individual_explosion(abilityLevel, caster, targetPoint, location)
		end
	end)

end

function pattern3(forwardVector, location, ability, caster, abilityLevel)
	local rotatedVector = forwardVector
	local targetPoint = nil
	for i = -5, 5 do
		targetPoint = (location + forwardVector * Vector(200, 200, 0) * i)
		create_individual_explosion(abilityLevel, caster, targetPoint, location)
	end
	for i = -5, 5 do
		local perp = perpendicularVector(forwardVector)
		targetPoint = (location + perp * Vector(200, 200, 0) * i)
		create_individual_explosion(abilityLevel, caster, targetPoint, location)
	end
	forwardVector = rotateVector(forwardVector, math.pi / 6)
	location = caster:GetAbsOrigin()
	Timers:CreateTimer(.8, function()
		EmitSoundOn("Hero_Nevermore.Shadowraze", caster)
		for i = -5, 5 do
			targetPoint = (location + forwardVector * Vector(200, 200, 0) * i)
			create_individual_explosion(abilityLevel, caster, targetPoint, location)
		end
		for i = -5, 5 do
			local perp = perpendicularVector(forwardVector)
			targetPoint = (location + perp * Vector(200, 200, 0) * i)
			create_individual_explosion(abilityLevel, caster, targetPoint, location)
		end
	end)
	forwardVector = rotateVector(forwardVector, math.pi / 6)
	location = caster:GetAbsOrigin()
	Timers:CreateTimer(1.6, function()
		EmitSoundOn("Hero_Nevermore.Shadowraze", caster)
		for i = -5, 5 do
			targetPoint = (location + forwardVector * Vector(200, 200, 0) * i)
			create_individual_explosion(abilityLevel, caster, targetPoint, location)
		end
		for i = -5, 5 do
			local perp = perpendicularVector(forwardVector)
			targetPoint = (location + perp * Vector(200, 200, 0) * i)
			create_individual_explosion(abilityLevel, caster, targetPoint, location)
		end
	end)
end

function create_individual_explosion(abilityLevel, caster, targetPoint, casterOrigin)
	local pfx = ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, targetPoint)
	local damage = caster:FindAbilityByName("serengaard_boss_mega_raze"):GetSpecialValueFor("damage")
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), targetPoint, nil, 240, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		local modifierKnockback = {center_x = enemy:GetAbsOrigin().x, center_y = enemy:GetAbsOrigin().y, center_z = enemy:GetAbsOrigin().z, duration = 0.9, knockback_duration = 0.9, knockback_distance = 0, knockback_height = 150}
		for i = 1, #enemies, 1 do
			local enemy = enemies[i]
			ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

			enemy:AddNewModifier(caster, nil, "modifier_knockback", modifierKnockback)
		end
	end
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:ReleaseParticleIndex(pfx)
	end)
end

function rotateVector(vector, radians)
	local XX = vector.x
	local YY = vector.y

	local Xprime = math.cos(radians) * XX - math.sin(radians) * YY
	local Yprime = math.sin(radians) * XX + math.cos(radians) * YY

	local vectorX = Vector(1, 0, 0) * Xprime
	local vectorY = Vector(0, 1, 0) * Yprime
	local rotatedVector = vectorX + vectorY
	return rotatedVector

end

function perpendicularVector(vector)
	local x = vector.x
	local y = -vector.y

	return Vector(y, x)
end

function serengaard_never_die(event)
	local caster = event.caster
	EmitSoundOn("nevermore_nev_arc_death_12", caster)
	local luck = RandomInt(1, 5)
	if luck == 3 then
		RPCItems:RollNeverlordRing(caster:GetAbsOrigin())
	end
	Serengaard:Mithril("neverlord", Serengaard.mainAncient:GetAbsOrigin(), 60)
end

function begin_dive(event)
	local caster = event.caster
	local ability = event.ability
	local abilityLevel = ability:GetLevel()
	local location = caster:GetOrigin()
	local castSoundTable = {"nevermore_nev_anger_06", "nevermore_nev_anger_07", "nevermore_nev_anger_08", "nevermore_nev_arc_laugh_09", "nevermore_nev_arc_ability_shadow_10", "nevermore_nev_arc_ability_requiem_03"}
	StartAnimation(caster, {duration = 1, activity = ACT_DOTA_FLAIL, rate = 0.5, translate = "forcestaff_friendly"})
	EmitSoundOn(castSoundTable[RandomInt(1, 6)], caster)
end

function slide_think(keys)
	local ability = keys.ability
	local caster = keys.caster
	local modifier = caster:FindModifierByName("modifier_holy_blink_slide")
	local origin = caster:GetAbsOrigin()
	ability.forwardVector = caster:GetForwardVector()

	caster.holy_slide_velocity = 30
	local newPosition = origin + ability.forwardVector * caster.holy_slide_velocity
	caster.holy_slide_velocity = math.max(caster.holy_slide_velocity - 1, 0)
	local groundPosition = GetGroundPosition(newPosition, caster)
	caster:SetAbsOrigin(groundPosition)

end

function slide_end(keys)
	local caster = keys.caster
	local location = caster:GetAbsOrigin()
	local newLoc = GetGroundPosition(location, caster)
	caster:SetOrigin(newLoc)
	FindClearSpaceForUnit(caster, newLoc, true)
	StartAnimation(caster, {duration = 0.6, activity = ACT_DOTA_FORCESTAFF_END, rate = 0.5})
end

function serengaard_boss_ai(event)
	local caster = event.caster
	local castAbility = caster:FindAbilityByName("serengaard_boss_mega_raze")
	if castAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = castAbility:entindex(),
			}

			ExecuteOrderFromTable(newOrder)
			return true
		end
	end
	local castAbility2 = caster:FindAbilityByName("forest_boss_dive")
	if castAbility2:IsFullyCastable() then
		local newOrder = {
			UnitIndex = caster:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = castAbility2:entindex(),
		}

		ExecuteOrderFromTable(newOrder)
		return true
	end
end

function amber_spider_die(event)
	local caster = event.caster
	EmitSoundOn("Serengaard.AmberSpider.Death", caster)
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_undying/undying_loadout.vpcf", caster, 3)
	if caster:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		local fv = caster:GetForwardVector()
		local splitCount = GameState:GetDifficultyFactor() + 2
		for i = 1, splitCount, 1 do
			local unit = CreateUnitByName("amber_spiderling", caster:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS)
			unit:SetAbsOrigin(unit:GetAbsOrigin() + Vector(0, 0, 80))
			local jumpFV = WallPhysics:rotateVector(fv, (2 * math.pi / splitCount) * i)
			WallPhysics:Jump(unit, jumpFV, 25, 17, 18, 1)
			Events:AdjustDeathXP(unit)
		end
	end
end

function barrel_throw(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]

	EmitSoundOn("Serengaard.Snowball.Throw", caster)
	local fv = ((point - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()

	local flare = CreateUnitByName("redfall_thrown_barrel", caster:GetAbsOrigin() + fv * 10, false, caster, nil, caster:GetTeamNumber())
	flare:SetOriginalModel("models/particle/snowball.vmdl")
	flare:SetModel("models/particle/snowball.vmdl")
	flare:SetRenderColor(140, 210, 255)
	flare:SetModelScale(0.1)
	flare.fv = fv
	flare.roll = -180
	flare.stun_duration = 2
	flare.forwardVelocity = 21
	flare.interval = 0
	flare.damage = event.damage
	flare.origCaster = caster
	flare.origAbility = ability
	flare:SetForwardVector(fv)
	StartSoundEvent("Serengaard.Snowball.LP", flare)
	ability:ApplyDataDrivenModifier(caster, flare, "modifier_for_the_barrel", {})
	ability.barrel = flare
end

function barrel_rolling_think(event)
	local barrel = event.target
	if not IsValidEntity(barrel) then
		return false
	end
	local fv = barrel.fv
	local yaw = WallPhysics:vectorToAngle(WallPhysics:rotateVector(fv, math.pi / 2))
	-- barrel:SetForwardVector(WallPhysics:rotateVector(fv,math.pi/2))
	local currentRoll = barrel.roll
	local newRoll = barrel.roll + 10
	barrel.roll = newRoll
	if newRoll > 180 then
		barrel.roll = -180
	end

	barrel:SetModelScale(math.min((0.1 + barrel.interval / 70), 1.2))

	barrel:SetAngles(barrel.roll, yaw, barrel.roll)
	if barrel.forwardVelocity < 3 then
		local eventTable = {}
		eventTable.unit = barrel
		barrel_explode(eventTable)
	end
	local velocityChange = -0.12
	local newPosition = barrel:GetAbsOrigin() + barrel.fv * barrel.forwardVelocity

	barrel:SetAbsOrigin(GetGroundPosition(newPosition, barrel) + Vector(0, 0, 25))

	barrel.forwardVelocity = barrel.forwardVelocity + velocityChange
	barrel.interval = barrel.interval + 1
end

function barrel_impact(event)
	local eventTable = {}
	eventTable.unit = event.ability.barrel
	barrel_explode(eventTable)
end

function barrel_explode(event)
	local barrel = event.unit
	if not IsValidEntity(barrel.origCaster) or not IsValidEntity(barrel.origAbility) then
		barrel:RemoveModifierByName("modifier_for_the_barrel")
		Timers:CreateTimer(0.09, function()
			UTIL_Remove(barrel)
		end)
		return false
	end
	local enemies = FindUnitsInRadius(barrel.origCaster:GetTeamNumber(), barrel:GetAbsOrigin(), nil, 260, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	local damage = barrel.damage
	flareParticle(barrel:GetAbsOrigin())
	StopSoundEvent("Serengaard.Snowball.LP", barrel)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = barrel.origCaster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
			Filters:ApplyStun(barrel.origCaster, barrel.stun_duration, enemy)
		end
	end
	EmitSoundOn("Serengaard.Snowball.Explode", barrel)
	local cd = barrel.origAbility:GetCooldownTimeRemaining()
	if cd < 5.5 then
		barrel.origAbility:EndCooldown()
	else
		Timers:CreateTimer(2, function()
			barrel.origAbility:EndCooldown()
		end)
	end
	barrel:RemoveModifierByName("modifier_for_the_barrel")
	Timers:CreateTimer(0.09, function()
		UTIL_Remove(barrel)
	end)
end

function barrel_thrower_ai_think(event)
	local caster = event.caster
	local ability = event.ability

	if ability:IsFullyCastable() then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local castPoint = enemies[1]:GetAbsOrigin()
			local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = ability:entindex(),
				Position = castPoint
			}

			ExecuteOrderFromTable(newOrder)
		end
	end
end

function flareParticle(position, fv)
	local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
	local particle2 = ParticleManager:CreateParticle(particleNameS, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particle2, 0, position)
	ParticleManager:SetParticleControl(particle2, 1, Vector(260, 260, 260))
	ParticleManager:SetParticleControl(particle2, 2, Vector(2.0, 2.0, 2.0))
	ParticleManager:SetParticleControl(particle2, 4, Vector(0, 200, 255))
	Timers:CreateTimer(1.5, function()
		ParticleManager:DestroyParticle(particle2, false)
	end)

	local particleName = "particles/roshpit/serengaard/snowball_destroy.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(particle1, 0, position)
	ParticleManager:SetParticleControl(particle1, 4, position)
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
end

function begin_shredder_madness(event)
	local caster = event.caster
	local ability = event.ability
	local fv = caster:GetForwardVector()
	local soundTable = {"shredder_timb_whirlingdeath_01", "shredder_timb_whirlingdeath_02", "shredder_timb_whirlingdeath_03", "shredder_timb_whirlingdeath_04"}
	EmitSoundOn(soundTable[RandomInt(1, 4)], caster)
	fire_chakram(caster, ability, fv)
	fire_chakram(caster, ability, WallPhysics:rotateVector(fv, math.pi / 7))
	fire_chakram(caster, ability, WallPhysics:rotateVector(fv, -math.pi / 7))
	-- if caster:GetHealth() < caster:GetMaxHealth()/2 then
	-- fire_chakram(caster, ability, WallPhysics:rotateVector(fv, math.pi/4))
	-- fire_chakram(caster, ability, WallPhysics:rotateVector(fv, -math.pi/4))
	-- fire_chakram(caster, ability, WallPhysics:rotateVector(-fv, math.pi/7))
	-- fire_chakram(caster, ability, WallPhysics:rotateVector(-fv, -math.pi/7))
	-- end

end

function fire_chakram(caster, ability, fv)
	local spellOrigin = caster:GetAbsOrigin()
	local info =
	{
		Ability = ability,
		EffectName = "particles/units/heroes/hero_shredder/shredder_chakram.vpcf",
		vSpawnOrigin = spellOrigin,
		fDistance = 1400,
		fStartRadius = 240,
		fEndRadius = 240,
		Source = caster,
		StartPosition = "attach_attack1",
		bHasFrontalCone = true,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = false,
		vVelocity = fv * 700,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
	Timers:CreateTimer(2, function()
		local groundPosition = GetGroundPosition(spellOrigin + fv * 1400, caster)
		--ability:ApplyDataDrivenThinker(caster, groundPosition, "shredder_max_thinker", {duration = 6})
		CustomAbilities:QuickAttachThinker(ability, caster, groundPosition, "shredder_max_thinker", {duration = 6})
	end)
end

function shredder_madness_strike(event)
	local caster = event.caster
	local target = event.target
	local damage = event.damage * 2
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE})

end

function madnessDOT(event)
	local caster = event.caster
	local target = event.target
	local damage = event.damage
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE})
end

function night_invader_attack_land(event)
	local attacker = event.attacker
	local ability = event.ability
	local target = event.target
	for i = 0, 3, 1 do
		local CDability = target:GetAbilityByIndex(i)
		if CDability then
			local currentCD = CDability:GetCooldownTimeRemaining()
			local newCD = math.min(currentCD + 0.5, 60)
			CDability:StartCooldown(newCD)
		end
	end
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_night_stalker/nightstalker_void.vpcf", target, 3)
end

function final_boss_die(event)
	local caster = event.caster
	EmitSoundOn("Serengaard.Boss.Die", caster)
	if GameState:GetDifficultyFactor() == 3 then
		Timers:CreateTimer(2, function()
			for i = 1, #MAIN_HERO_TABLE, 1 do
				Serengaard:GiveSunstone(MAIN_HERO_TABLE[i], Serengaard.mainAncient:GetAbsOrigin())
			end
		end)
	end
	local luck = RandomInt(1, 4)
	Serengaard:Mithril("razormore", Serengaard.mainAncient:GetAbsOrigin(), 120)
	if luck == 1 then
		RPCItems:RollDemonMask(caster:GetAbsOrigin(), false, 15)
	end
end

function final_boss_think(event)
	local caster = event.caster
	if not caster.interval then
		caster.interval = 0
	end
	caster.interval = caster.interval + 1
	if caster.interval % 3 == 0 then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local castAbility = caster:FindAbilityByName("serengaard_boss_light_strike_array")
			for i = 1, #enemies, 1 do
				local castPoint = enemies[1]:GetAbsOrigin()
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = castAbility:entindex(),
					Position = castPoint
				}
				EmitSoundOn("Serengaard.Boss.ArrayCastVO", caster)
				ExecuteOrderFromTable(newOrder)
			end
		end
	end
	if caster.interval % 2 == 0 then
		local damage = event.damage
		local fv = caster:GetForwardVector()
		local flameRange = (caster.interval % 10) * 100 + 240
		for i = 1, 7, 1 do
			Timers:CreateTimer(i * 0.03, function()
				if IsValidEntity(caster) then
					local strikeAbility = caster:FindAbilityByName("serengaard_boss_light_strike_array")
					local rotatedVector = WallPhysics:rotateVector(fv, (2 * math.pi * i / 7))
					local point = caster:GetAbsOrigin() + rotatedVector * flameRange
					local radius = 400
					EmitSoundOnLocationWithCaster(point, "Serengaard.Boss.PreArray", caster)

					local particleName = "particles/units/heroes/hero_lina/lina_spell_light_strike_array_ray.vpcf"
					local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControl(particle1, 0, point)
					ParticleManager:SetParticleControl(particle1, 1, Vector(radius, 0, 0))
					ParticleManager:SetParticleControl(particle1, 3, Vector(700, 700, 700))
					Timers:CreateTimer(4, function()
						ParticleManager:DestroyParticle(particle1, false)
					end)

					Timers:CreateTimer(0.5, function()
						local enemies = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
						if #enemies > 0 then
							for i = 1, #enemies, 1 do
								Filters:TakeArgumentsAndApplyDamage(enemies[i], caster, damage, DAMAGE_TYPE_MAGICAL, 4)
								Filters:ApplyStun(caster, 1.0, enemies[i])
							end
						end
						EmitSoundOnLocationWithCaster(point, "Serengaard.Boss.Array", caster)
						local particleName = "particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf"
						local particle2 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
						ParticleManager:SetParticleControl(particle2, 0, point)
						ParticleManager:SetParticleControl(particle2, 1, Vector(radius, 0, 0))
						ParticleManager:SetParticleControl(particle2, 3, Vector(0, 0, 0))
						Timers:CreateTimer(4, function()
							ParticleManager:DestroyParticle(particle2, false)
						end)
					end)
				end
			end)
		end
	end
	if caster.interval == 100 then
		caster.interval = 0
	end
end

function razor_boss_die(event)
	local luck = RandomInt(1, 5)
	local caster = event.caster
	EmitSoundOn("Serengaard.RazorBoss.Die", caster)
	if luck == 1 then
		RPCItems:RollBaronsStormArmor(caster:GetAbsOrigin())
	end
	Serengaard:Mithril("baron", Serengaard.mainAncient:GetAbsOrigin(), 100)
end


