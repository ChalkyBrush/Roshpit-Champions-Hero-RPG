function begin_lightning_dash(event)
	local caster = event.caster
	local ability = event.ability
	caster:AddNoDraw()

	if ability.lockPoint then
	else
		ability.point = event.target_points[1]
	end
	local clamp_distance = 1000
	local moveDirection = ((ability.point - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()

	local distance = WallPhysics:GetDistance2d(ability.point, caster:GetAbsOrigin())
	if distance > clamp_distance then
		ability.point = caster:GetAbsOrigin()+moveDirection*clamp_distance
	end
	ability.moveDirection = (ability.point-caster:GetAbsOrigin()):Normalized()
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_bahamut_sphere_of_divinity", {duration = 7})
	StartSoundEvent("Jex.ShootingStar.LP", caster)
	EmitSoundOn("Jex.Cinderbark.Attack", caster)
	
	caster:RemoveModifierByName("modifier_leshrac_wall_self_aura")

	local arcanaUlti = caster:FindAbilityByName("bahamut_arcana_ulti")
	if arcanaUlti then
		arcanaUlti.r_1_level = caster:GetRuneValue("r", 1)
	end

	ability.pfx = pfx
	ability.interval = 0
	if not ability.particles then
		ability.particles = 0
	end
	local range = WallPhysics:GetDistance2d(ability.point, caster:GetAbsOrigin())

   	CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_phoenix/phoenix_fire_spirit_ground.vpcf", caster:GetAbsOrigin(), 3)
	Filters:CastSkillArguments(3, caster)

end

function dash_think(event)
	local caster = event.caster
	local ability = event.ability
	local w_4_level = 0
	if caster:IsHero() then w_4_level = caster:GetRuneValue("w",4) end
	
	ability.moveDirection = (ability.point-caster:GetAbsOrigin()):Normalized()

	local blockSearch = caster:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,GetGroundHeight(caster:GetAbsOrigin(), caster))
    local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch+ability.moveDirection*35), caster)
    local distance_for_slowing = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.point)
    local forwardSpeed = 2300/33

    if caster:HasModifier("modifier_light_charging") then
    	forwardSpeed = forwardSpeed*BAHAMUT_ARCANA_W4_R_SPEED_MULT
    else
	    if distance_for_slowing < 200 then
	    	forwardSpeed = 30
	    elseif distance_for_slowing < 400 then
	    	forwardSpeed = 34
	    elseif distance_for_slowing < 600 then
	    	forwardSpeed = 38
	    end
	end

	if blockUnit then
		forwardSpeed = 0
		caster:RemoveModifierByName("modifier_bahamut_sphere_of_divinity")
	end
	local newPosition = caster:GetAbsOrigin() + ability.moveDirection*forwardSpeed
	caster:SetAbsOrigin(Vector(newPosition.x, newPosition.y, 200) + Vector(0,0,GetGroundHeight(newPosition, caster)))
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.point)
	if distance < forwardSpeed*1.5 then
		caster:RemoveModifierByName("modifier_bahamut_sphere_of_divinity")
	end
	ability.interval = ability.interval + 1
	if caster:GetUnitName() == "npc_dota_hero_leshrac" then
		if ability.interval % 3 == 0 then
			local tickManaDrain = caster:GetMaxMana()*event.mana_drain_per_second*0.09/100

			if caster:GetMana() > tickManaDrain then
				caster:ReduceMana(tickManaDrain)
			else
				caster:RemoveModifierByName("modifier_bahamut_sphere_of_divinity")
			end
		end
	end
end

function dash_end(event)
	local caster = event.caster
	local ability = event.ability
	if caster:HasModifier("modifier_bahamut_arcana_w4_amp") and caster:HasModifier("modifier_light_charging") then
		local stacks = caster:GetModifierStackCount("modifier_bahamut_arcana_w4_amp", caster)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_bahamut_arcana_w4_amp_linger", {duration = BAHAMUT_ARCANA_W4_AMP_LINGER_DURATION})
		caster:SetModifierStackCount("modifier_bahamut_arcana_w4_amp_linger", ability, stacks)
	end
	caster:RemoveModifierByName("modifier_bahamut_arcana_w4_amp")
	Timers:CreateTimer(0.03, function()
		StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_TELEPORT_END, rate=1.1}) 
		WallPhysics:ClearSpaceForUnit(caster, caster:GetAbsOrigin())
		StopSoundEvent("Jex.ShootingStar.LP", caster)

	   	local particle = "particles/roshpit/jex/fire_cosmic_land.vpcf"
		local pfx2 = ParticleManager:CreateParticle( particle, PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( pfx2, 0, caster:GetAbsOrigin() )
		Timers:CreateTimer(3, function()
			ParticleManager:DestroyParticle(pfx2, false)
		end)
	end)
	EmitSoundOn("Jex.ShootingStar.Start", caster)
	if not caster:HasModifier("modifier_sorceress_blink_datadriven") then
		caster:RemoveNoDraw()
	end
	-- ParticleManager:DestroyParticle(ability.pfx, false)
	-- ability.pfx = false

end
