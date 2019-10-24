require('heroes/leshrac/leshrac_runes')
require("heroes/leshrac/bahamut_constants")

function startChannel(event)
	local caster = event.caster
	local ability = event.ability
	ability.r_3_level = Runes:GetTotalRuneLevel(caster, 3, "r_3", "bahamut")
	ability.r_1_level = Runes:GetTotalRuneLevel(caster, 1, "r_1", "bahamut")
	caster.e_4_level = Runes:GetTotalRuneLevel(caster, 4, "e_4", "bahamut")
	local wallAbility = caster:FindAbilityByName("leshrac_wall")
	wallAbility.r_1_level = Runes:GetTotalRuneLevel(caster, 1, "r_1", "bahamut")
	--print(ability.r_3_level)
end

function set_c_d_level(event)
	local caster = event.caster
	local ability = event.ability
	ability.r_3_level = Runes:GetTotalRuneLevel(caster, 3, "r_3", "bahamut")
end

function break_channel(event)
	local caster = event.caster
end

function beginCharge(event)
	local ability = event.ability
	local caster = event.caster
	caster:RemoveModifierByName("modifier_pulse_slow")
	ability.fv = caster:GetForwardVector()
	ability.slideSpeed = 25
	ability.interval = 0
	ability.point = caster:GetAbsOrigin() + caster:GetForwardVector() * 900
	Timers:CreateTimer(0.05, function()
		StartAnimation(caster, {duration = 0.9, activity = ACT_DOTA_RUN, rate = 1.5})
	end)
	EmitSoundOn("Hero_Terrorblade.Metamorphosis", caster)
	Filters:CastSkillArguments(4, caster)

	if caster:HasModifier("modifier_bahamut_glyph_2_1") then
		ability.wallPoint = caster:GetAbsOrigin() + ability.fv * 360
		ability.ninetyDegrees = WallPhysics:rotateVector(ability.fv, math.pi / 2)
		createWallParticle(caster, 500, true, ability)
	end
	caster:RemoveModifierByName("modifier_bahamut_rune_r_4_buff_visible")
	caster:RemoveModifierByName("modifier_bahamut_rune_r_4_buff_invisible")
end

function charge_think(event)
	local caster = event.caster
	local ability = event.ability
	local position = caster:GetAbsOrigin()
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.point)
	local orb = caster:FindAbilityByName("bahamut_arcana_orb")

	ability.interval = ability.interval + 1
	position = GetGroundPosition(position, caster)

	local speed = 30
	if caster:HasModifier("modifier_bahamut_sphere_of_divinity") then
		speed = 0
		orb.lockPoint = true
		ability.point = orb.point
	end
	local newPosition = caster:GetAbsOrigin() + (ability.point - caster:GetAbsOrigin()):Normalized() * speed

	local obstruction = WallPhysics:FindNearestObstruction(newPosition)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition, caster)
	-- if ability.interval%3 == 0 then
	-- iceSprintBlast(caster, newPosition, event.radius, event.damage, ability)
	-- end
	if not blockUnit then
		caster:SetOrigin(newPosition)
	else
		caster:RemoveModifierByName("modifier_light_charging")
	end
	if distance < 50 then caster:RemoveModifierByName("modifier_light_charging") end
	if caster:HasModifier("modifier_bahamut_glyph_2_1") then
		ability.wallPoint = caster:GetAbsOrigin() + ability.fv * 40
		createWallParticle(caster, 500, false, ability)
	end
end

function slide_think(event)
	local caster = event.caster
	local ability = event.ability
	local position = caster:GetAbsOrigin()

	position = GetGroundPosition(position, caster)

	local newPosition = position + ability.fv * ability.slideSpeed
	local obstruction = WallPhysics:FindNearestObstruction(newPosition)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition, caster)
	ability.slideSpeed = ability.slideSpeed - 1
	-- if ability.interval%3 == 0 then
	-- iceSprintBlast(caster, newPosition, event.radius, event.damage, ability)
	-- end
	if not blockUnit then
		caster:SetOrigin(newPosition)
	end
end

function slide_end(event)
	local caster = event.caster
	local position = caster:GetAbsOrigin()
	local ability = event.ability
	FindClearSpaceForUnit(caster, position, false)
end

function charge_end(event)
	local caster = event.caster
	local ability = event.ability
	local position = caster:GetAbsOrigin()
	local orb = caster:FindAbilityByName("bahamut_arcana_orb")
	if orb then
		orb.lockPoint = false
	end
	caster.e_4_level = Runes:GetTotalRuneLevel(caster, 4, "e_4", "bahamut")
	local fv = caster:GetForwardVector()

	if caster:HasModifier("modifier_bahamut_arcana_w4_amp") and caster:HasModifier("modifier_bahamut_sphere_of_divinity") then
		local orb = caster:FindAbilityByName("bahamut_arcana_orb")
		local stacks = caster:GetModifierStackCount("modifier_bahamut_arcana_w4_amp", caster)
		orb:ApplyDataDrivenModifier(caster, caster, "modifier_bahamut_arcana_w4_amp_linger", {duration = BAHAMUT_ARCANA_W_W4_AMP_LINGER_DURATION})
		caster:SetModifierStackCount("modifier_bahamut_arcana_w4_amp_linger", orb, stacks)
	end
	caster:RemoveModifierByName("modifier_bahamut_arcana_w4_amp")
	local particle = "particles/units/heroes/hero_warlock/charge_of_light.vpcf"
	local pfx = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, caster)
	WallPhysics:ClearSpaceForUnit(caster, position)
	ParticleManager:SetParticleControl(pfx, 0, position)
	ParticleManager:SetParticleControl(pfx, 1, position)
	ParticleManager:SetParticleControl(pfx, 2, fv)
	Timers:CreateTimer(2.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	--

	local particle = "particles/units/heroes/hero_chen/chen_teleport_flash.vpcf"
	local pfx2 = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx2, 0, position)
	Timers:CreateTimer(2.5, function()
		ParticleManager:DestroyParticle(pfx2, false)
	end)

	local particle = "particles/units/heroes/hero_silencer/silencer_last_word_trigger.vpcf"
	local pfx3 = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx3, 0, position)
	Timers:CreateTimer(2.5, function()
		ParticleManager:DestroyParticle(pfx3, false)
	end)
	local range = event.range
	EmitSoundOn("Hero_Terrorblade.Sunder.Target", caster)
	caster:RemoveModifierByName("modifier_bahamut_rune_r_4_buff_visible")
	caster:RemoveModifierByName("modifier_bahamut_rune_r_4_buff_invisible")
	for i = -16, 16, 1 do
		local rotatedVec = WallPhysics:rotateVector(fv, math.pi / 16 * i)
		fireProjectile(ability, caster, "particles/units/heroes/hero_alchemist/charge_of_light_linear_projectile_concoction_projectile_linear.vpcf", rotatedVec, position, range)
		-- Timers:CreateTimer(0.1, function()
		-- fireProjectile(ability, caster, "particles/units/heroes/hero_alchemist/charge_of_light_linear_projectile_concoction_projectile_linear.vpcf", rotatedVec, position)
		-- end)
		-- Timers:CreateTimer(0.2, function()
		-- fireProjectile(ability, caster, "particles/units/heroes/hero_alchemist/charge_of_light_linear_projectile_concoction_projectile_linear.vpcf", rotatedVec, position)
		-- end)
	end
	if caster:HasModifier("modifier_bahamut_glyph_2_1") then
		createWall(caster, 500, ability)
		local eventTable = {}
		eventTable.caster = caster
		eventTable.target = caster
		eventTable.ability = caster:FindAbilityByName("leshrac_wall")
		eventTable.guarantee = true
		WallAllyBuff(eventTable)
	end
	local d_d_level = Runes:GetTotalRuneLevel(caster, 4, "r_4", "bahamut")
	local shellDuration = 3
	if caster:HasModifier("modifier_bahamut_glyph_5_1") then
		shellDuration = shellDuration + BAHAMUT_GLYPH_5_1_R4_DURATION
	end
	shellDuration = Filters:GetAdjustedBuffDuration(caster, shellDuration, false)
	if d_d_level > 0 then
		local runeAbility = caster.runeUnit4:FindAbilityByName("bahamut_rune_r_4")
		runeAbility.r_4_level = d_d_level
		runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_bahamut_rune_r_4_shell", {duration = shellDuration})
		if caster:HasModifier("modifier_charge_of_light_hyper_state") then
			local hyperStateDuration = Filters:GetAdjustedBuffDuration(caster, 12, false)
			local wallAbility = caster:FindAbilityByName("leshrac_wall")
			wallAbility:ApplyDataDrivenModifier(caster, caster, "modifier_charge_of_light_hyper_state", {duration = hyperStateDuration})
		end
	end
end

function fireProjectile(ability, caster, particle, fv, startPoint, range)
	local start_radius = 120
	local end_radius = 120
	local speed = 1100

	local casterOrigin = caster:GetAbsOrigin()

	local info =
	{
		Ability = ability,
		EffectName = particle,
		vSpawnOrigin = startPoint + Vector(0, 0, 120),
		fDistance = range,
		fStartRadius = start_radius,
		fEndRadius = end_radius,
		Source = caster,
		StartPosition = "attach_hitloc",
		bHasFrontalCone = true,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
		vVelocity = fv * Vector(1, 1, 0) * speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
end

function projectileStrike(event)
	local caster = event.caster
	local target = event.target
	local damage = event.damage
	local ability = event.ability
	damage = damage
	local ability = event.ability
	Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, caster, "modifier_backstab_jumping", {duration = 0.2})
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_R, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
	caster:RemoveModifierByName("modifier_backstab_jumping")
	local point = target:GetAbsOrigin()
	local modifierKnockback =
	{
		center_x = point.x,
		center_y = point.y,
		center_z = point.z,
		duration = 1,
		knockback_duration = 1,
		knockback_distance = 0,
		knockback_height = 250
	}
	target:AddNewModifier(caster, nil, "modifier_knockback", modifierKnockback)
	local judgementAbility = caster:FindAbilityByName("leshrac_nuke")
	if judgementAbility then
		if judgementAbility.w_2_level then
			if judgementAbility.w_2_level > 0 then
				judgementAbility:ApplyDataDrivenModifier(caster, target, "modifier_leshrac_nuke_judged", {duration = 5})
			end
		end
	end
end

function createWallParticle(caster, wallLength, bInitial, ability)
	local casterOrigin = caster:GetAbsOrigin()
	local fv = ability.fv
	local point = ability.wallPoint
	local ninetyDegrees = ability.ninetyDegrees
	local wallPoint1 = point - ninetyDegrees * wallLength / 2
	local wallPoint2 = point + ninetyDegrees * wallLength / 2
	local particle = "particles/units/heroes/hero_dark_seer/leshrac_wallof_replica.vpcf"

	local pfx2 = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, caster)

	ParticleManager:SetParticleControl(pfx2, 0, wallPoint1)
	ParticleManager:SetParticleControl(pfx2, 1, wallPoint2)

	Timers:CreateTimer(0.5, function()
		ParticleManager:DestroyParticle(pfx2, false)
	end)

end

function createWall(caster, wallLength, ability)
	local casterOrigin = caster:GetAbsOrigin()
	local fv = ability.fv
	local point = ability.wallPoint - fv * 100
	local ninetyDegrees = ability.ninetyDegrees
	local wallPoint1 = point - ninetyDegrees * wallLength / 2
	local wallPoint2 = point + ninetyDegrees * wallLength / 2
	local particle = "particles/units/heroes/hero_dark_seer/leshrac_wallof_replica.vpcf"

	local pfx2 = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, caster)

	ParticleManager:SetParticleControl(pfx2, 0, wallPoint1)
	ParticleManager:SetParticleControl(pfx2, 1, wallPoint2)

	-- local obstructionTable = {}
	local loopCount = WallPhysics:round(-wallLength / 200, 0)
	local reduceLoop = 0

	if wallLength % 50 == 0 then
		reduceLoop = 1
	end

	EmitSoundOnLocationWithCaster(point, "Hero_Luna.Eclipse.NoTarget", caster)
	EmitSoundOnLocationWithCaster(point, "Hero_Luna.Eclipse.NoTarget", caster)

	local wallAbility = caster:FindAbilityByName("leshrac_wall")
	wallAbility.wallCenter = point
	wallAbility.wallLength = wallLength
	wallAbility.ninetyDegrees = ninetyDegrees
	for i = loopCount, -loopCount - reduceLoop, 1 do
		local obstructionPoint = point + ninetyDegrees * i * 100
		-- local obstruction = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = obstructionPoint, Name ="wallObstruction"})
		--wallAbility:ApplyDataDrivenThinker(caster, obstructionPoint, "modifier_leshrac_wall_thinker", {})
		CustomAbilities:QuickAttachThinker(wallAbility, caster, obstructionPoint, "modifier_leshrac_wall_thinker", {duration = 8})
		--wallAbility:ApplyDataDrivenThinker(caster, obstructionPoint, "modifier_leshrac_self_finder", {})
		CustomAbilities:QuickAttachThinker(wallAbility, caster, obstructionPoint, "modifier_leshrac_self_finder", {duration = 8})
		-- table.insert(obstructionTable, obstruction)
		AddFOWViewer(caster:GetTeamNumber(), obstructionPoint, 250, 8, false)
	end

	Timers:CreateTimer(8, function()
		ParticleManager:DestroyParticle(pfx2, false)
		-- for k,obstruction in pairs(obstructionTable) do
		-- UTIL_Remove(obstruction)
		-- end
	end)

end

function c_d_channel_think(event)
	local caster = event.caster
	local ability = event.ability
	if ability.r_3_level > 0 then
		local position = caster:GetAbsOrigin()
		local particleName = "particles/units/heroes/hero_faceless_void/bahamut_c_d_slow_timedialate.vpcf"
		local particle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
		local radius = 600
		ParticleManager:SetParticleControl(particle, 0, position)
		ParticleManager:SetParticleControl(particle, 1, Vector(radius, radius, radius))
		Timers:CreateTimer(1.5, function()
			ParticleManager:DestroyParticle(particle, false)
		end)

		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_bahamut_rune_r_3_effect", {duration = 3})
				enemy:SetModifierStackCount("modifier_bahamut_rune_r_3_effect", ability, ability.r_3_level)
			end
		end
	end
end
