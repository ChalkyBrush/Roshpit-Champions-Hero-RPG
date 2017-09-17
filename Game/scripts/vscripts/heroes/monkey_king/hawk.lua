require('/heroes/monkey_king/constants')

function hawk_screech_pre(event)
	local caster = event.caster
	EmitSoundOn("Draghor.Hawk.PreScreech", caster)

	local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/draghor/hawk_screen_preshoutmask.vpcf", caster, 3)
	ParticleManager:SetParticleControl(pfx, 2, Vector(200,200,200))
end

function hawk_screech(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Draghor.Hawk.Screech", caster)
	local fv = ((event.target_points[1]-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	local altitude = 190
	StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_SPAWN, rate=1.7})
	local info = 
	{
		Ability = ability,
        	EffectName = "particles/roshpit/draghor/hawk_screech.vpcf",
        	vSpawnOrigin = caster:GetAbsOrigin()+Vector(0,0,altitude)+fv*30,
        	fDistance = 900,
        	fStartRadius = 100,
        	fEndRadius = 340,
        	Source = caster,
        	StartPosition = "attach_hitloc",
        	bHasFrontalCone = true,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = false,
		vVelocity = fv * 1000,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
	local c_a_level = Runes:GetTotalRuneLevelGeneric(caster, 3, 0)
	if c_a_level > 0 then
		local modifiers = caster:FindAllModifiers()
		for i = 1, #modifiers, 1 do
			local modifier = modifiers[i]
			local modifierMaker = modifier:GetCaster()
			if modifierMaker:GetEntityIndex() == caster:GetEntityIndex() or modifierMaker:GetEntityIndex() == caster.InventoryUnit:GetEntityIndex() then
				local durationRemaining = modifier:GetRemainingTime()
				if durationRemaining > 0 then
					modifier:SetDuration(durationRemaining + DJANGHOR_Q3_BUFF_DURATION_INCREASE*c_a_level, true)
				end
			end
		end
	end
end

function hawk_screech_hit(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local debuff_duration = event.debuff_duration
	local damage = event.damage
	ability:ApplyDataDrivenModifier(caster, target, "modifier_draghor_hawk_screech", {duration = debuff_duration})

	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_PURE, 1, RPC_ELEMENT_TIME, RPC_ELEMENT_NATURE)
end

function tornado_phase(event)
	local caster = event.caster
	local ability = event.ability

	local stacks = caster:GetModifierStackCount("modifier_tornado_cast_stack", caster)
	EmitSoundOn("Draghor.Tornado.CastVO", caster)
	StartAnimation(caster, {duration=0.4, activity=ACT_DOTA_SPAWN, rate=1.7})
	if stacks < 2 then
		-- StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_ATTACK, rate=2.0, translate="attack_normal_range"})
		-- EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Draghor.JinBo.Swing", caster)
	else
		-- local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/dreghor/jinbo_precast.vpcf", caster, 3)
		-- ParticleManager:SetParticleControl(pfx, 8, colorVector)
		-- StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_MK_STRIKE, rate=1.4})
		-- EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Draghor.JinBo.HeavySwing", caster)
	end
	local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/draghor/hawk_precast_tornado.vpcf", caster, 3)
	ParticleManager:SetParticleControl(pfx, 2, Vector(260,260,260))
end

function tornado_start(event)
	local caster = event.caster
	local ability = event.ability

	-- ability:ApplyDataDrivenModifier(caster, caster, "modifier_tornado_cast_stack", {duration = 1})
	-- local newStacks = math.min(caster:GetModifierStackCount("modifier_tornado_cast_stack", caster) + 1, 2)
	-- caster:SetModifierStackCount("modifier_tornado_cast_stack", caster, newStacks)
	EmitSoundOn("Draghor.Tornado.Cast", caster)
	local projectileParticle = "particles/roshpit/draghor/hawk_tornado_big.vpcf"
	local fv = caster:GetForwardVector()
	local perpFV = WallPhysics:rotateVector(fv, 2*math.pi/4)
	local speed = 1000
	local projectileOrigin = caster:GetAbsOrigin()+perpFV*RandomInt(-160, 160)
	local range = 1200
	local tornadoRadius = 200
	-- if newStacks < 3 and not caster:HasModifier("modifier_monkey_jump") then

	-- else
	-- 	range = 1500
	-- 	tornadoRadius = 280
	-- end
	local projectileFV = (((caster:GetAbsOrigin()+fv*range) - projectileOrigin)*Vector(1,1,0)):Normalized()
	local info = 
	{
			Ability = ability,
	    	EffectName = projectileParticle,
	    	vSpawnOrigin = projectileOrigin,
	    	fDistance = range,
	    	fStartRadius = tornadoRadius,
	    	fEndRadius = tornadoRadius,
	    	Source = caster,
	    	StartPosition = "attach_origin",
	    	bHasFrontalCone = true,
	    	bReplaceExisting = false,
	    	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    	fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
		vVelocity = projectileFV*speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)

	ability.c_b_level = Runes:GetTotalRuneLevelGeneric(caster, 3, 1)
end

function tornado_hit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	local damage = event.damage
	damage = damage + event.int_mult*caster:GetIntellect()
	if ability.c_b_level > 0 then
		damage = damage + damage*DJANGHOR_W3_ATTACK_PERCENT_ADDED_TO_TORNADO_AND_STOMP*ability.c_b_level
	end
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_WIND, RPC_ELEMENT_NATURE)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_hawk_tornado_debuff", {duration = 7})
end

function soar_start(event)
	local caster = event.caster
	local ability = event.ability
	local duration = event.duration
	local d_c_level = Runes:GetTotalRuneLevelGeneric(caster, 4, 2)
	if d_c_level > 0 then
		duration = duration + d_c_level*DJANGHOR_E4_DURATION_INCREASE
	end
	StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_RUN, rate=1.5})
	duration = Filters:GetAdjustedBuffDuration(caster, duration, false)

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_hawk_soar", {duration = duration})
	EmitSoundOn("Draghor.Hawk.Soar", caster)
	for i = 0, 6, 1 do
		Timers:CreateTimer(i*0.6, function()
			EmitSoundOn("Draghor.WingFlap.Soar", caster)
		end)
	end
	for i = 1, 80, 1 do
		Timers:CreateTimer(i*0.03, function()
			if caster:HasModifier("modifier_draghor_shapeshift_hawk_lua") then
				if not caster:HasModifier("modifier_hawk_soar_visual_z") then
					ability:ApplyDataDrivenModifier(caster, caster, "modifier_hawk_soar_visual_z", {duration = duration})
				end
				caster:SetModifierStackCount("modifier_hawk_soar_visual_z", caster, 160 + i*2)
			end
		end)
	end
end

function soar_visual_end(event)
	local caster = event.caster
	local ability = event.ability
	for i = 1, 80, 1 do
		Timers:CreateTimer(i*0.03, function()
			if caster:HasModifier("modifier_draghor_shapeshift_hawk_lua") then
				if not caster:HasModifier("modifier_hawk_soar_visual_z_down") then
					ability:ApplyDataDrivenModifier(caster, caster, "modifier_hawk_soar_visual_z_down", {duration = duration})
				end
				caster:SetModifierStackCount("modifier_hawk_soar_visual_z_down", caster, 320 - i*2)
				if i == 80 then
					caster:RemoveModifierByName("modifier_hawk_soar_visual_z_down")
				end
			end
		end)
	end
end