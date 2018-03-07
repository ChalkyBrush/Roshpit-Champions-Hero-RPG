function jump_pre_start(event)
	local caster = event.caster

	local distance = WallPhysics:GetDistance2d(event.target_points[1], caster:GetAbsOrigin())
	if distance > 700 then
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Draghor.JumpPre.VO.Big", caster)
	else
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Draghor.JumpPre.VO.Small", caster)
	end

	EndAnimation(caster)
	CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_monkey_king/monkey_king_spring_channel_rings.vpcf", caster:GetAbsOrigin()+Vector(0,0,20), 0.6)
	-- StartAnimation(caster, {duration=0.44, activity=ACT_DOTA_MK_SPRING_CAST, rate=1.2})
end

function jump_start(event)
	local caster = event.caster
	local ability = event.ability
	ability.targetPoint = event.target_points[1]
	ability:ApplyDataDrivenModifier(caster, caster,"modifier_monkey_jump", {duration = 4})
	local distance = WallPhysics:GetDistance2d(ability.targetPoint, caster:GetAbsOrigin())
	ability.jumpVelocity = distance/20
	ability.liftVelocity = 20
	local heightDiff = caster:GetAbsOrigin().z - ability.targetPoint.z
	if heightDiff > 300 then
		heightDiff = 300
	elseif heightDiff < -300 then
		heightDiff = -300
	end
	ability.liftVelocity = ability.liftVelocity - heightDiff/20
	ability.rising = true
	ability.jumpFV = ((ability.targetPoint - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()

	ability.interval = 0

	local c_c_level = Runes:GetTotalRuneLevelGeneric(caster, 3, 2)
	if c_c_level > 0 then
		local procs = Runes:Procs(c_c_level, 5, 1)
		if procs > 0 then
			local particle = false
			for i = 1, procs, 1 do
				local modifiers = caster:FindAllModifiers()
				for j = 1, #modifiers, 1 do
					local modifier = modifiers[j]
					local modifierMaker = modifier:GetCaster()
					if modifierMaker.regularEnemy then
						caster:RemoveModifierByName(modifier:GetName())
						particle = true
						break
					end
				end				
			end
			if particle then
				EmitSoundOn("Draghor.Cleanse", caster)
				local pfx = CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_morphling/morphling_morph_agi.vpcf", caster, 1.2)
			end
		end
	end
	-- StartAnimation(caster, {duration=2.0, ACT_DOTA_MK_SPRING_SOAR, rate=1.0})
	-- StartAnimation(caster, {duration=1.5, activity=ACT_DOTA_CAST_ABILITY_2, rate=1})
	-- EmitSoundOn("Akrimus.Jump.VO", caster)
	Filters:CastSkillArguments(3, caster)

end

function jump_think(event)
	local caster = event.caster
	local ability = event.ability

	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.targetPoint)

	local fv = ability.jumpFV
	-- if distance < 60 then
	-- 	fv = Vector(0,0)
	-- end
	local height = (caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster))
	if height < math.abs(ability.liftVelocity) then
		print(height)
		if not ability.rising then
			caster:RemoveModifierByName("modifier_monkey_jump")
		end
	end

	local blockSearch = caster:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,GetGroundHeight(caster:GetAbsOrigin(), caster))
    local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch+ability.jumpFV*30), caster)
	if blockUnit then
		fv = Vector(0,0)
	end
	caster:SetAbsOrigin(caster:GetAbsOrigin() + fv*ability.jumpVelocity + Vector(0,0,ability.liftVelocity))
	ability.liftVelocity = ability.liftVelocity - 2
	if ability.liftVelocity <= 0 then
		ability.rising = false
	end
	ability.interval = ability.interval + 1
	if ability.interval%3 == 0 then
		-- local pfx = ParticleManager:CreateParticle("particles/roshpit/arkimus/jump_fade.vpcf", PATTACH_CUSTOMORIGIN, caster)
		-- ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
		-- Timers:CreateTimer(0.4, function()
		-- 	ParticleManager:DestroyParticle(pfx, false)
		-- end)
	end
end

function jump_end(event)
	local caster = event.caster
	local ability = event.ability
	EndAnimation(caster)
	CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_monkey_king/monkey_king_spring_channel_rings.vpcf", caster:GetAbsOrigin()+Vector(0,0,20), 0.6)
	Timers:CreateTimer(0.03, function()
		StartAnimation(caster, {duration=1, activity=ACT_DOTA_MK_SPRING_END, rate=1})
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
	end)
	ability.a_c_level = Runes:GetTotalRuneLevelGeneric(caster, 1, 2)
	if ability.a_c_level > 0 then
		ability:ApplyDataDrivenThinker(caster, caster:GetAbsOrigin(), "modifier_monkey_a_c_thinker", {duration = 20})
	end
end

