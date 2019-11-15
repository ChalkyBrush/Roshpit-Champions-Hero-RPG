require('heroes/slardar/water_blade')
require('heroes/slardar/arcana_ability')
require('heroes/slardar/arcana/flood_basin')

function slippery_tail_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	if caster:HasModifier("modifier_hydroxis_arcana2") then
		if caster:HasModifier("modifier_flood_basin_aura_effect") then
			if slippery_tail_arcana(caster, target, ability) then
				return false
			end
		end
	end
	ability.fv = ((target - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	ability.targetPoint = target
	local warpDuration = 2.0
	ability.fallVelocity = 1
	ability.forwardVelocity = 12
	ability.forwardVelocity = Filters:GetAdjustedESpeed(caster, ability.forwardVelocity, false)
	caster.e_4_Level = Runes:GetTotalRuneLevel(caster, 4, "e_4", "hydroxis")
	ability.distance = WallPhysics:GetDistance2d(ability.targetPoint, caster:GetAbsOrigin())
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_slippery_tail_flying", {duration = warpDuration})
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, true)
		ability.pfx = false
	end
	ability.e_1_level = Runes:GetTotalRuneLevel(caster, 1, "e_1", "hydroxis")
	ability.e_2_level = Runes:GetTotalRuneLevel(caster, 2, "e_2", "hydroxis")
	ability.e_2_damage = ability.e_2_level * OverflowProtectedGetAverageTrueAttackDamage(caster) * HYDROXIS_E2_ATTACK_TO_DMG_PCT/100
	if caster:HasModifier("modifier_hydroxis_glyph_4_1") then
		ability.e_2_damage = ability.e_2_damage * 3
	end
	-- StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_FLAIL, rate=0.8, translate="forcestaff_friendly"})
	-- ability.pfx = ParticleManager:CreateParticle("particles/econ/courier/courier_hyeonmu_ambient/courier_hyeonmu_ambient_trail_steam_red.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	-- ParticleManager:SetParticleControlEnt(ability.pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	-- ParticleManager:SetParticleControl(ability.pfx, 15, Vector(100, 220, 100))
	ability.radians = 0
	EmitSoundOn("Hydroxis.SlipStream.Start", caster)
	StartAnimation(caster, {duration = 2.0, activity = ACT_DOTA_RUN, rate = 1, translate = "sprint"})
	Filters:CastSkillArguments(3, caster)
	-- caster:SetForwardVector(Vector(1,0))
end

function slippery_tail_think(event)
	local caster = event.caster
	local ability = event.ability

	ability.forwardVelocity = math.max(ability.forwardVelocity - 0.05, 5)
	local distanceDivisor = (ability.distance / 25 + 5) / 2
	if ability.distance < 500 then
		distanceDivisor = distanceDivisor * 2
	end
	local sinOffset = math.sin(ability.radians * 2 * math.pi / distanceDivisor)
	ability.radians = ability.radians + 1
	local blockSearch = caster:GetAbsOrigin() * Vector(1, 1, 0) + Vector(0, 0, GetGroundHeight(caster:GetAbsOrigin(), caster))
	local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch + ability.fv * 25), caster)
	local forwardSpeed = ability.forwardVelocity
	if blockUnit then
		forwardSpeed = 0
		slippery_tail_jump_end(caster, ability)
	end

	local fv = ability.fv
	local cyclicalFV = WallPhysics:rotateVector(fv, sinOffset)
	local newPosition = caster:GetAbsOrigin() + ability.fv * forwardSpeed + cyclicalFV * 17
	local faceAngle = (ability.fv * forwardSpeed + cyclicalFV * 17):Normalized()
	faceAngle = WallPhysics:vectorToAngle(faceAngle)
	caster:SetAngles(0, faceAngle, 0)
	local heightDiff = newPosition.z - GetGroundHeight(newPosition, caster)
	if heightDiff > 40 then
		newPosition = newPosition - Vector(0, 0, 8)
	elseif heightDiff < -50 then
		newPosition = GetGroundPosition(newPosition, caster)
	end
	caster:SetAbsOrigin(newPosition)
	local distance = WallPhysics:GetDistance2d(ability.targetPoint, caster:GetAbsOrigin())
	if distance < 100 then
		slippery_tail_jump_end(caster, ability)
	end

	if ability.radians % 4 == 0 then
		local particleName = "particles/roshpit/hydroxis/slipstream_puddle.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
		Timers:CreateTimer(5, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	end
	if ability.e_1_level > 0 then
		local modulos = 8
		if caster:HasModifier("modifier_hydroxis_glyph_2_1") then
			modulos = 6
		end
		if ability.radians % modulos == 0 then
			local target = caster:GetAbsOrigin() + RandomVector(RandomInt(80, 500))
			local waterBombAbility = caster:FindAbilityByName("hydroxis_water_blade")
			if waterBombAbility then
				local damage = waterBombAbility:GetSpecialValueFor("damage")
				water_bomb_throw(caster, waterBombAbility, target, damage, ability.e_1_level * HYDROXIS_E1_PCT_OF_W/100)
			elseif caster:HasAbility("hydroxis_arcana_ability_1") then
				arcana1_b_b_spin(caster, caster:FindAbilityByName("hydroxis_arcana_ability_1"), ability.e_1_level * HYDROXIS_E1_PCT_OF_W/100)
			end
		end
	end
	if ability.e_2_level > 0 then
		if ability.radians % 5 == 0 then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				EmitSoundOn("Hydroxis.BCGush", caster)
				local loops = 1
				for i = 1, loops, 1 do
					local info =
					{
						Target = enemies[i],
						Source = caster,
						Ability = ability,
						EffectName = "particles/units/heroes/hero_tidehunter/tidehunter_gush.vpcf",
						StartPosition = "attach_attack1",
						bDrawsOnMinimap = false,
						bDodgeable = true,
						bIsAttack = false,
						bVisibleToEnemies = true,
						bReplaceExisting = false,
						flExpireTime = GameRules:GetGameTime() + 5,
						bProvidesVision = false,
						iVisionRadius = 0,
						iMoveSpeed = 1500,
					iVisionTeamNumber = caster:GetTeamNumber()}
					projectile = ProjectileManager:CreateTrackingProjectile(info)
				end
				-- ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
			end
		end
	end
	if caster:HasModifier("modifier_hydroxis_immortal_weapon_2") then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for i = 1, #enemies, 1 do
				local enemy = enemies[i]
				if not enemy:HasModifier("modifier_hydroxis_immortal_push") then
					Filters:ApplyStun(caster, HYDROXIS_IMMORTAL_WEAPON_2_STUN_DURATION, enemy)
					EmitSoundOn("Hydroxis.Immo2Impact", enemy)
				end
				if enemy.pushLock or enemy.jumpLock then
				else
					caster.equipped_gear[RPC_GEAR_SLOT_WEAPON]:ApplyDataDrivenModifier(caster.InventoryUnit, enemy, "modifier_hydroxis_immortal_push", {duration = 0.1})
					enemy.pushFV = ability.fv
				end
			end
		end
	end
end

function immortal_2_push(event)
	local target = event.target
	local newPos = GetGroundPosition(target:GetAbsOrigin() + target.pushFV * 30, target)
	target:SetAbsOrigin(newPos)
end

function immortal_2_push_end(event)
	local target = event.target
	FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
end

function slippery_tail_jump_end(caster, ability)
	EndAnimation(caster)
	caster:RemoveModifierByName("modifier_slippery_tail_flying")
	WallPhysics:ClearSpaceForUnit(caster, caster:GetAbsOrigin())
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_slippery_tail_sliding", {duration = 1.2})
	ability.slideVelocity = 10
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ability.pfx = false
	end
	local c_c_level = Runes:GetTotalRuneLevel(caster, 3, "e_3", "hydroxis")
	if c_c_level > 0 then
		local c_c_duration = Filters:GetAdjustedBuffDuration(caster, 8, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_hydroxis_c_c", {duration = c_c_duration})
		caster:SetModifierStackCount("modifier_hydroxis_c_c", caster, c_c_level)
	end
end

function after_warp_falling(event)
	local caster = event.caster
	local ability = event.ability
	caster:SetAbsOrigin(caster:GetAbsOrigin() - Vector(0, 0, ability.fallVelocity))
	ability.fallVelocity = ability.fallVelocity + 2
	local groundHeight = GetGroundHeight(caster:GetAbsOrigin(), caster)
	if caster:GetAbsOrigin().z - groundHeight < ability.fallVelocity / 2 then
		caster:RemoveModifierByName("modifier_end_slippery_tail_falling")

		-- StartAnimation(caster, {duration=0.4, activity=ACT_DOTA_FORCESTAFF_END, rate=1})
	end
end

function slippery_tail_sliding(event)
	local caster = event.caster
	local ability = event.ability
	local blockSearch = caster:GetAbsOrigin() * Vector(1, 1, 0) + Vector(0, 0, GetGroundHeight(caster:GetAbsOrigin(), caster))
	local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch + caster:GetForwardVector() * 15), caster)
	local forwardSpeed = ability.slideVelocity
	ability.slideVelocity = math.max(ability.slideVelocity - 0.4, 1)
	if blockUnit then
		forwardSpeed = 0
	end
	caster:SetAbsOrigin(caster:GetAbsOrigin() + caster:GetForwardVector() * forwardSpeed)
end

function sliding_end(event)
	local caster = event.caster
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
end

function hydroxis_b_c_hit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	Filters:TakeArgumentsAndApplyDamage(target, caster, ability.e_2_damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_E, RPC_ELEMENT_WATER, RPC_ELEMENT_NONE)
end
