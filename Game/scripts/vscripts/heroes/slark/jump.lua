require("/heroes/slark/slipfinn_constants")

GROUND_FRICTION = 1.0
TURN_RATE = 1
SLIP_SPEED = 5
MAX_SLIP_SPEED = 11
LONG_JUMP_MULT = 2
LONG_JUMP_HEIGHT_MULT = 0.66

HIGH_JUMP_MULT = 0.9
HIGH_JUMP_HEIGHT_MULT = 1.6

JUMP_ON_HEAD_RADIUS = 130

--SCALING - HEIGHT FOR WHICH ENEMIES CANNOT ATTACK

function slipfinn_main_thinker(event)
	local caster = event.caster
	local ability = event.ability

	if not caster.prevPosition then
		ability.interval = 0
		caster.prevPosition = caster:GetAbsOrigin()
		caster.direction = caster:GetForwardVector()
		caster.speed = 0
		caster.possessedTable = {}
		caster.jumpPhase = 0
		caster.max_slip_speed = MAX_SLIP_SPEED
		return false
	end
	if caster:HasModifier("modifier_channel_start") or Filters:HasMovementModifier(caster) then
		caster.jumpLock = false
		return false
	end
	local onGround = math.abs(caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster)) < 25
	local differential = (caster:GetAbsOrigin() - caster.prevPosition) * Vector(1, 1, 0)
	local direction = differential:Normalized()
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), caster.prevPosition)
	local speedGain = distance * 0.02 * SLIP_SPEED
	caster.differential = differential
	if onGround then
		if not caster:HasModifier("modifier_slipfinn_basic_jump") then
			caster.max_slip_speed = MAX_SLIP_SPEED
			if caster:HasModifier("slipfinn_shadow_rush_lua") then
				local modifier = caster:FindModifierByName("slipfinn_shadow_rush_lua")
				local decay = modifier:GetRemainingTime() / caster.baseShadowRushDuration
				local bonus = math.max(20 * decay, 0)
				caster.max_slip_speed = caster.max_slip_speed + bonus
			end
		end
		caster.direction = direction
	else
	end
	if caster:HasModifier("slipfinn_shadow_rush_lua") or caster:HasModifier("modifier_jumping") or caster:HasModifier("modifier_slipfinn_basic_jump") or caster:HasModifier("modifier_slipfinn_bog_roller") then
		if caster:HasModifier("modifier_slipfinn_glyph_7_1") then
			Filters:CleanseStuns(caster)
		end
	end
	local distanceFromGround = caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster)
	if distanceFromGround > event.height_immune then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_jump_not_attackable", {})
	else
		caster:RemoveModifierByName("modifier_jump_not_attackable")
	end
	caster.speed = math.min(caster.speed + speedGain, caster.max_slip_speed)
	--print(caster.speed)
	if distance > 300 then
		caster.speed = 0
	end
	local blockSearch = caster:GetAbsOrigin() * Vector(1, 1, 0) + Vector(0, 0, GetGroundHeight(caster:GetAbsOrigin(), caster))
	local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch + caster.direction * caster.speed), caster)
	if blockUnit then
		caster:RemoveModifierByName("modifier_slipfinn_shadow_rush_flying_portion")
		caster.speed = 0
	end
	if caster.speed > 0.5 then
		local friction = GROUND_FRICTION
		-- if caster:HasModifier("modifier_slipfinn_jump_phase") then
		-- friction = friction/1.5
		-- end
		if caster:HasModifier("modifier_slipfinn_glyph_1_1") then
			friction = friction * (1-SLIPFINN_GLYPH_1_1_FRICTION_MULT)
		end
		if caster:HasModifier("modifier_slipfinn_prone") then
			friction = friction / 7
		end
		if onGround then
			caster.speed = math.max(caster.speed - friction, 0)
			caster.direction = (caster.direction + caster:GetForwardVector() * TURN_RATE):Normalized()
			if caster.speed == 0 then
				FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
			end
		end
		--print(caster.direction*caster.speed)
		local angleDiff = math.abs(AngleDiff(WallPhysics:vectorToAngle(caster.direction), WallPhysics:vectorToAngle(caster:GetForwardVector())))
		--print(angleDiff)
		if AngleDiff(WallPhysics:vectorToAngle(caster.direction), WallPhysics:vectorToAngle(caster:GetForwardVector())) > 15 and onGround then
		else
			local newPos = caster:GetAbsOrigin() + caster.direction * caster.speed
			if onGround then
				newPos = GetGroundPosition(newPos, caster)
			end
			if caster:HasModifier("modifier_slipfinn_basic_jump") then
				caster:SetOrigin(caster:GetAbsOrigin() + caster.direction * caster.speed)
			else
				if caster:HasModifier("slipfinn_bog_roller_lua") then
				else
					if math.abs(caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster)) < 60 then
						caster:SetOrigin(caster:GetAbsOrigin() + caster.direction * caster.speed)
					else
						caster.speed = 0
						FindClearSpaceForUnit(caster, caster:GetAbsOrigin() - caster.direction * 30, false)
					end
				end
			end
		end
	else
		caster.speed = 0
		if onGround and math.abs(caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster)) < 10 then
			if caster:HasModifier("modifier_slipfinn_basic_jump") then
			else
				FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
			end
		end
	end
	if caster.speed + 3 >= MAX_SLIP_SPEED then
		caster:AddNewModifier(caster, nil, "modifier_animation_translate", {translate = "shadow_dance"})
	else
		caster:RemoveModifierByName("modifier_animation_translate")
	end
	caster.prevPosition = caster:GetAbsOrigin()
	if caster.rightClickPos then
		if WallPhysics:GetDistance2d(caster:GetAbsOrigin(), caster.rightClickPos) < 20 + caster.speed then
			caster.rightClickPos = nil
			caster:Stop()
		end
	end
	ability.interval = ability.interval + 1
	if not caster:HasModifier("modifier_slipfinn_arcana1") then
		if ability.interval == 10 then
			ability.interval = 0
			ability.e_2_level = caster:GetRuneValue("e", 2)
			if ability.e_2_level > 0 then
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_slipfinn_b_c_health_regen", {})
				local healthRegenMult = 1
				if caster:HasModifier("modifier_slipfinn_prone") then
					healthRegenMult = 2
				end
				caster:SetModifierStackCount("modifier_slipfinn_b_c_health_regen", caster, ability.e_2_level * healthRegenMult * SLIPFINN_E2_HEALTH_REGEN * caster:GetAgility())
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_slipfinn_b_c_health", {})
				caster:SetModifierStackCount("modifier_slipfinn_b_c_health", caster, ability.e_2_level * SLIPFINN_E2_HEALTH * caster:GetAgility())
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_slipfinn_e_2_armor", {})
				caster:SetModifierStackCount("modifier_slipfinn_e_2_armor", caster, ability.e_2_level * SLIPFINN_E2_ARMOR * caster:GetAgility())		
			else
				caster:RemoveModifierByName("modifier_slipfinn_b_c_health_regen")
				caster:RemoveModifierByName("modifier_slipfinn_b_c_health")
				caster:RemoveModifierByName("modifier_slipfinn_e_2_armor")
			end
		end
	end
	if caster:HasModifier("modifier_slipfinn_basic_jump") then
		caster:RemoveModifierByName("modifier_knockback")
	end
end

function slipfinn_jump_start(event)
	local caster = event.caster
	local ability = event.ability

	local movespeed = caster:GetBaseMoveSpeed()
	local actualMS = caster:GetMoveSpeedModifier(movespeed, false)
	ability.w_1_level = caster:GetRuneValue("w", 1)
	ability.w_2_level = caster:GetRuneValue("w", 2)
	ability.w_3_level = caster:GetRuneValue("w", 3)
	ability.w_4_level = caster:GetRuneValue("w", 4)
	if ((caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster)) < 30) or event.guarantee then
		caster:RemoveModifierByName("modifier_slipfinn_agitated_visible")
		caster:RemoveModifierByName("modifier_slipfinn_agitated_invisible")
		if caster.speed then
			if caster.speed > 0 then
				caster.max_slip_speed = 200
				local msBooster = actualMS * 0.03 * (math.min(1, caster.speed / MAX_SLIP_SPEED))
				if caster:HasModifier("modifier_slipfinn_prone") or caster:IsRooted() then
					msBooster = 4
				end
				caster.speed = caster.speed + (actualMS * 0.03)
			end
			if caster:HasModifier("modifier_slipfinn_prone") then
				if caster.speed > 21 then
					caster.jumpPhase = 0
					caster.speed = caster.speed * LONG_JUMP_MULT
					caster.longJump = true
				else
					caster.jumpPhase = 0
					caster.speed = caster.speed * HIGH_JUMP_MULT
					caster.highJump = true
					--print("HIGH JUMP!")
					EmitSoundOn("Slipfinn.HighJump.VO", caster)
				end
			end
		end
		jump_force(caster, ability, event.bog_roll)
		ability.consecutive_bounces = 0
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_slipfinn_basic_jump", {duration = 6})
		--print("YO JUMPING DUDE")
		caster.jumpPhase = caster.jumpPhase + 1
		caster.jumpLock = true
		Filters:CastSkillArguments(2, caster)
	else
		ability:RefundManaCost()
	end
end

function jump_force(caster, ability, bog_roll)
	--print(caster.jumpPhase)
	local jumpDelay = 0
	if caster:HasModifier("modifier_slipfinn_prone") then
		caster:RemoveModifierByName("modifier_slipfinn_prone")
		jumpDelay = 0.06
	end

	local animation_duration = 1.9
	local rate = 1.0
	local translate = nil
	local activity = ACT_DOTA_CAST_ABILITY_1
	if caster.jumpPhase == 0 then
		caster.jump_force = 30
		if caster.highJump then
			activity = ACT_DOTA_SLARK_POUNCE
			rate = 1.1
			translate = "silent_ripper"

		else
			if caster:HasModifier("slipfinn_bog_roller_lua") then
				EmitSoundOn("Slipfinn.Jump.InBogRoller1", caster)
			else
				EmitSoundOn("Slipfinn.BasicJump1", caster)
				EmitSoundOn("Slipfinn.JumpWoosh1", caster)
			end
			rate = 0.8
		end
	elseif caster.jumpPhase == 1 then
		caster.jump_force = 38
		if caster.highJump then
			activity = ACT_DOTA_SLARK_POUNCE
			rate = 1.1
			translate = "silent_ripper"
		else
			if caster:HasModifier("slipfinn_bog_roller_lua") then
				EmitSoundOn("Slipfinn.Jump.InBogRoller2", caster)
			else
				EmitSoundOn("Slipfinn.BasicJump2", caster)
				EmitSoundOn("Slipfinn.JumpWoosh2", caster)
			end
			rate = 0.8
		end
	elseif caster.jumpPhase == 2 then
		caster.jump_force = 46 + ability.w_4_level * SLIPFINN_W4_JUMP_FORCE
		caster:RemoveModifierByName("modifier_slipfinn_jump_phase")
		activity = ACT_DOTA_SLARK_POUNCE
		rate = 0.8
		caster.jumpPhase = -1
		if caster:HasModifier("slipfinn_bog_roller_lua") then
			EmitSoundOn("Slipfinn.Jump.InBogRoller3", caster)
		else
			EmitSoundOn("Slipfinn.BasicJump3", caster)
			EmitSoundOn("Slipfinn.JumpWoosh3", caster)
		end
	end
	if caster.longJump then
		caster.longJump = nil
		caster.jump_force = caster.jump_force * LONG_JUMP_HEIGHT_MULT
		if caster:HasModifier("modifier_slipfinn_glyph_2_1") then
			caster.jump_force = caster.jump_force + SLIPFINN_GLYPH_2_1_JUMP_FORCE
		end
		if caster:HasModifier("slipfinn_bog_roller_lua") then
			EmitSoundOn("Slipfinn.Jump.InBogRoller2", caster)
		else
			EmitSoundOn("Slipfinn.JumpWoosh2", caster)
		end
	elseif caster.highJump then
		if caster:HasModifier("slipfinn_bog_roller_lua") then
			EmitSoundOn("Slipfinn.Jump.InBogRoller2", caster)
		else
			EmitSoundOn("Slipfinn.JumpWoosh2", caster)
		end
		caster.highJump = nil
		caster.jump_force = caster.jump_force * HIGH_JUMP_HEIGHT_MULT + ability.w_4_level * SLIPFINN_W4_JUMP_FORCE
	end
	if caster:HasModifier("modifier_slipfinn_bog_roller") then
		activity = ACT_DOTA_OVERRIDE_ABILITY_2
	end
	if bog_roll then
		rate = 1
		activity = ACT_DOTA_SLARK_POUNCE
		caster.jumpPhase = caster.jumpPhase - 1
		caster.jump_force = 18
	end
	Timers:CreateTimer(jumpDelay, function()
		if translate then
			StartAnimation(caster, {duration = animation_duration, activity = activity, rate = rate, translate = translate})
		else
			StartAnimation(caster, {duration = animation_duration, activity = activity, rate = rate})
		end

	end)

	--print("JUMP FORCE")
	--print(caster.jump_force)
end

function slipfinn_jump_think(event)
	local caster = event.caster
	local ability = event.ability
	if Filters:HasMovementModifier(caster) then
		return false
	end
	caster:SetOrigin(caster:GetAbsOrigin() + Vector(0, 0, caster.jump_force))
	caster.jump_force = caster.jump_force - 2
	caster.max_slip_speed = 200

	local jump_on_head_radius = JUMP_ON_HEAD_RADIUS
	if caster:HasModifier("modifier_slipfinn_glyph_5_a") then
		jump_on_head_radius = jump_on_head_radius + jump_on_head_radius * SLIPFINN_GLYPH_5_A_RADIUS_MULT
	end
	if caster.jump_force < -1 then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, jump_on_head_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
		if #enemies > 0 then
			local jumpEnemy = nil
			local height = caster:GetAbsOrigin().z
			for _, enemy in pairs(enemies) do
				if enemy:HasModifier("modifier_possession_enemy_lock") then
				else
					--print(enemy:GetBoundingMaxs().z)
					local headPos = enemy:GetAbsOrigin().z + enemy:GetBoundingMaxs().z
					if (height > (headPos - 50)) and (height < (headPos + 50)) then
						jumpEnemy = enemy
						--print("FOUND ENEMY")
						break
					end
				end
			end
			if jumpEnemy then
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_slipfinn_basic_jump", {duration = 6})
				local position = caster:GetAbsOrigin()
				local pfx = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(pfx, 0, position)
				ParticleManager:SetParticleControl(pfx, 1, Vector(200, 200, 200))
				Timers:CreateTimer(2, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)
				ability.consecutive_bounces = ability.consecutive_bounces + 1
				local glyphBonus = 0
				if caster:HasModifier("modifier_slipfinn_glyph_3_1") then
					glyphBonus = SLIPFINN_GLYPH_3_1_BOUNCE_FORCE
				end
				if caster:HasModifier("modifier_slipfinn_immortal_weapon_2") then
					Filters:PerformAttackSpecial(caster, jumpEnemy, true, true, true, false, true, false, false)
				end
				caster.jump_force = math.max(math.min(caster.jump_force + 40 + ability.consecutive_bounces * 4 + glyphBonus, 40 + ability.consecutive_bounces * 4 + glyphBonus), 10)
				caster.direction = caster:GetForwardVector()
				caster.speed = caster.speed + 0.5
				--print(caster.speed)
				caster.speed = math.max(1, caster.speed)
				EmitSoundOn("Slipfinn.Bounce", jumpEnemy)
				local animation_duration = 1.9
				local rate = 0.8
				local translate = nil
				local activity = ACT_DOTA_SLARK_POUNCE
				if translate then
					StartAnimation(caster, {duration = animation_duration, activity = activity, rate = rate, translate = translate})
				else
					StartAnimation(caster, {duration = animation_duration, activity = activity, rate = rate})
				end
				Filters:ApplyStun(caster, 0.15, jumpEnemy)
				if ability.w_1_level > 0 then
					EmitSoundOn("Slipfinn.BounceW1", jumpEnemy)
					local pfx = ParticleManager:CreateParticle("particles/roshpit/slipfinn/dark_bog_fallback_mid_egset.vpcf", PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControl(pfx, 0, jumpEnemy:GetAbsOrigin())
					local particleRadius = 92
					local particleRadius2 = 270
					local searchRadius = 310
					ParticleManager:SetParticleControl(pfx, 1, Vector(3, 3, 3))
					ParticleManager:SetParticleControl(pfx, 4, Vector(particleRadius, particleRadius, particleRadius))
					ParticleManager:SetParticleControl(pfx, 5, Vector(particleRadius2, particleRadius2, particleRadius2))
					Timers:CreateTimer(0.9, function()
						ParticleManager:DestroyParticle(pfx, false)
						ParticleManager:ReleaseParticleIndex(pfx)
					end)
					local a_b_damage = SLIPFINN_W1_BASE * ability.w_1_level + OverflowProtectedGetAverageTrueAttackDamage(caster) * SLIPFINN_W1_ATK * ability.w_1_level
					local enemies = FindUnitsInRadius(caster:GetTeamNumber(), jumpEnemy:GetAbsOrigin(), nil, searchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
					if #enemies > 0 then
						for _, enemy in pairs(enemies) do
							Filters:TakeArgumentsAndApplyDamage(enemy, caster, a_b_damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_SHADOW, RPC_ELEMENT_WATER)
							if ability.w_2_level > 0 then
								ability:ApplyDataDrivenModifier(caster, enemy, "modifier_slipfinn_gloomshade_visible", {duration = SLIPFINN_W2_DURATION})
								local newStacks = enemy:GetModifierStackCount("modifier_slipfinn_gloomshade_visible", caster) + 1
								enemy:SetModifierStackCount("modifier_slipfinn_gloomshade_visible", caster, newStacks)

								ability:ApplyDataDrivenModifier(caster, enemy, "modifier_slipfinn_gloomshade_invisible", {duration = SLIPFINN_W2_DURATION})
								enemy:SetModifierStackCount("modifier_slipfinn_gloomshade_invisible", caster, newStacks * ability.w_2_level)
							end
						end
					end
				end
				if ability.w_2_level > 0 then
					ability:ApplyDataDrivenModifier(caster, jumpEnemy, "modifier_slipfinn_gloomshade_visible", {duration = SLIPFINN_W2_DURATION})
					local newStacks = jumpEnemy:GetModifierStackCount("modifier_slipfinn_gloomshade_visible", caster) + 1
					jumpEnemy:SetModifierStackCount("modifier_slipfinn_gloomshade_visible", caster, newStacks)

					ability:ApplyDataDrivenModifier(caster, jumpEnemy, "modifier_slipfinn_gloomshade_invisible", {duration = SLIPFINN_W2_DURATION})
					jumpEnemy:SetModifierStackCount("modifier_slipfinn_gloomshade_invisible", caster, newStacks * ability.w_2_level)
				end
				if ability.w_3_level > 0 then
					local duration = Filters:GetAdjustedBuffDuration(caster, SLIPFINN_W3_DURATION, false)
					ability:ApplyDataDrivenModifier(caster, caster, "modifier_slipfinn_agitated_visible", {duration = duration})
					local newStacks = caster:GetModifierStackCount("modifier_slipfinn_agitated_visible", caster) + 1
					caster:SetModifierStackCount("modifier_slipfinn_agitated_visible", caster, newStacks)

					ability:ApplyDataDrivenModifier(caster, caster, "modifier_slipfinn_agitated_invisible", {duration = duration})
					caster:SetModifierStackCount("modifier_slipfinn_agitated_invisible", caster, newStacks * ability.w_3_level)
				end

			end
		end
	end

	if caster.jump_force <= 0 then
		if caster:GetAbsOrigin().z <= GetGroundHeight(caster:GetAbsOrigin(), caster) + math.abs(caster.jump_force / 2) then
			jump_land(caster, ability)
		end
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_slipfinn_jump_phase", {duration = 0.1})
end

function jump_land(caster, ability)
	--print("LAND")
	caster:RemoveModifierByName("modifier_slipfinn_basic_jump")
	WallPhysics:ClearSpaceForUnit(caster, caster:GetAbsOrigin())
	caster.max_slip_speed = MAX_SLIP_SPEED
	ability.consecutive_bounces = 0
	local shadow_rush_phase = caster:HasAbility("slipfinn_shadow_rush") and caster:FindAbilityByName("slipfinn_shadow_rush"):IsInAbilityPhase()
	if shadow_rush_phase or caster:IsChanneling() then
	else
		local orderPos = caster:GetAbsOrigin() + caster:GetForwardVector() * caster.speed * 10
		local order =
		{
			UnitIndex = caster:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = orderPos
		}
		if math.abs(caster:GetAbsOrigin().z - GetGroundHeight(orderPos, caster)) < 60 then
			ExecuteOrderFromTable(order)
		end
	end
	local position = caster:GetAbsOrigin()
	local pfx = ParticleManager:CreateParticle("particles/econ/items/lion/fish_stick/fish_stick_splash.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, position)
	ParticleManager:SetParticleControl(pfx, 1, Vector(200, 200, 200))
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	if caster.jump_force < -42 then
		if caster:HasModifier("slipfinn_bog_roller_lua") then
			EmitSoundOn("Slipfinn.BogRoller.CollisionLand3", caster)
		else
			EmitSoundOn("Slipfinn.Ground3", caster)
		end
		--print("HEAVY")
	elseif caster.jump_force < -35 then
		if caster:HasModifier("slipfinn_bog_roller_lua") then
			EmitSoundOn("Slipfinn.BogRoller.CollisionLand2", caster)
		else
			EmitSoundOn("Slipfinn.Ground2", caster)
		end
		--print("MED")
	else
		--print("LIGHT")
		if caster:HasModifier("slipfinn_bog_roller_lua") then
			EmitSoundOn("Slipfinn.BogRoller.CollisionLand1", caster)
		else
			EmitSoundOn("Slipfinn.Ground1", caster)
		end
	end
	if caster.jump_force < -1 and caster:HasModifier("slipfinn_bog_roller_lua") then
		local e_4_radius = (caster.jump_force *- 8) + 40
		bog_roller_e_4_explosion(caster, e_4_radius)
	end
	caster.jumpLock = false
	EndAnimation(caster)
	--print(caster.jumpPhase)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_slipfinn_jump_phase", {duration = 0.8})
	caster:RemoveModifierByName("modifier_jump_not_attackable")
end

function bog_roller_e_4_explosion(caster, radius)
	local e_4_level = caster:GetRuneValue("e", 4)
	if e_4_level > 0 then
		local pfx = CustomAbilities:QuickParticleAtPoint("particles/roshpit/slipfinn/bog_e_4_explosion.vpcf", caster:GetAbsOrigin(), 3)
		for i = 1, 5, 1 do
			ParticleManager:SetParticleControl(pfx, i, Vector(radius, radius, radius))
		end
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				local stun_duration = SLIPFINN_ARCANA_1_E4_STUN_DURATION * e_4_level
				local damage = (SLIPFINN_ARCANA_1_E4_LAND_DAMAGE_PER_ATTACK_PCT / 100) * OverflowProtectedGetAverageTrueAttackDamage(caster) * e_4_level
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_E, RPC_ELEMENT_WATER, RPC_ELEMENT_SHADOW)
				Filters:ApplyStun(caster, stun_duration, enemy)
			end
		end

	end
end

function jump_phase_reset(event)
	local caster = event.caster
	local ability = event.ability
	caster.jumpPhase = 0
end

