function jex_lightning_lightning_e_start(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]

	local tech_level = caster.onibi.stats_table["lightning"]["lightning"]["E"]["level"]
	ability.tech_level = tech_level

	EmitSoundOn("Winterblight.AzaleanZealot.Strafe", caster)
    local directon = ((point - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
    ability.strafe_direction = directon
    ability.strafe_speed = event.travel_speed_base + event.travel_speed_per_tech*tech_level
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_jex_lightning_lightning_e_movement", {duration = 1})
    StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_SPAWN, rate=1.5})
    ability.point = point
    EmitSoundOn("Jex.Grunt", caster)
    EmitSoundOn("Jex.Jolt.Start", caster)
    Filters:CastSkillArguments(3, caster)

	local aoePFX = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zeus_cloud.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(aoePFX, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(aoePFX, 1, Vector(120, 10, 120))
	ParticleManager:SetParticleControl(aoePFX, 2, caster:GetAbsOrigin()+Vector(0,0,160))
	ParticleManager:SetParticleControl(aoePFX, 5, caster:GetAbsOrigin())
	Timers:CreateTimer(0.3, function()
		ParticleManager:DestroyParticle(aoePFX, false)
	end)
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ability.pfx = false
	end
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_electric_vortex.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()+Vector(0,0,30))
	ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin()+Vector(0,0,30))
	Timers:CreateTimer(2.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	ability.pfx = pfx
end

function jex_lightning_lightning_e_think(event)
	local caster = event.caster
	local ability = event.ability
	ability.strafe_speed = math.max(ability.strafe_speed - 0.2, 30)
	local speed = ability.strafe_speed
	local blockSearch = caster:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,GetGroundHeight(caster:GetAbsOrigin(), caster))
    local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch+speed*ability.strafe_direction), caster)
	if blockUnit then
		speed = 0
	end
	caster:SetAbsOrigin(caster:GetAbsOrigin()+speed*ability.strafe_direction)
	local groundHeight = GetGroundHeight(caster:GetAbsOrigin(), caster) 
	if groundHeight > caster:GetAbsOrigin().z then
		local newPos = Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, GetGroundHeight(caster:GetAbsOrigin(), caster) + 20)
		caster:SetAbsOrigin(newPos)
	elseif groundHeight < caster:GetAbsOrigin().z - 120 then
		local newPos = Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, GetGroundHeight(caster:GetAbsOrigin(), caster) - 20)
		caster:SetAbsOrigin(newPos)
	end
	if ability.pfx then
		ParticleManager:SetParticleControl(ability.pfx, 1, caster:GetAbsOrigin()+Vector(0,0,30))
	end
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.point)
	if distance < ability.strafe_speed then
		caster:RemoveModifierByName("modifier_jex_lightning_lightning_e_movement")
	end
end

function jex_lightning_lightning_e_end(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Jex.Jolt.End", caster)
	Timers:CreateTimer(0.03, function()
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
	end)
	local aoePFX = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zeus_cloud.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(aoePFX, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(aoePFX, 1, Vector(120, 10, 120))
	ParticleManager:SetParticleControl(aoePFX, 2, caster:GetAbsOrigin()+Vector(0,0,160))
	ParticleManager:SetParticleControl(aoePFX, 5, caster:GetAbsOrigin())
	Timers:CreateTimer(0.3, function()
		ParticleManager:DestroyParticle(aoePFX, false)
		if ability.pfx then
			ParticleManager:DestroyParticle(ability.pfx, false)
			ability.pfx = false
		end
	end)
	local w_4_level = caster:GetRuneValue("w", 4)
	local total_duration = event.duration+(event.w_4_duration_increase*w_4_level)
	local duration = Filters:GetAdjustedBuffDuration(caster, total_duration, false)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_jex_lightning_lightning_e_buff", {duration = duration})
	caster:SetModifierStackCount("modifier_jex_lightning_lightning_e_buff", caster, ability.tech_level)
end