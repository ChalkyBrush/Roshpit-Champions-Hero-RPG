require('heroes/faceless_void/omniro_constants')

function dimension_stalker_channel_start(event)
	local caster = event.caster
	local ability = event.ability

	StartAnimation(caster, {duration=2.0, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.6})

	ability.liftspeed = 14.5
	ability.anim = 0
	ability.arrow_spawn = true
	caster:RemoveModifierByName("modifier_dimension_stalker_channel_end")
	if ability.aoePFX then
		ParticleManager:DestroyParticle(ability.aoePFX, false)
		ability.aoePFX = false
	end
	local radius = event.radius
	local aoePFX = ParticleManager:CreateParticle("particles/roshpit/omniro/omniro_ult_indicator_ring.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(aoePFX, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(aoePFX, 1, Vector(radius, 1, radius))
	ParticleManager:SetParticleControl(aoePFX, 2, Vector(6, 6, 6))
	ParticleManager:SetParticleControl(aoePFX, 15, Vector(200, 200, 240))
	ParticleManager:SetParticleControl(aoePFX, 16, Vector(200, 200, 240))
	ability.aoePFX = aoePFX
	EmitSoundOn("Omniro.DimensionStalk.Start.VO", caster)
	EmitSoundOn("Omniro.Ulti.Charge", caster)
end



function dimension_stalker_channel_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster) < 600 then
		caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,ability.liftspeed))
	end
	ability.anim = ability.anim + 1
	ability.liftspeed = math.max(ability.liftspeed - 0.5, 0)
	if ability.anim == 37 then
		-- StartAnimation(caster, {duration=1.5, activity=ACT_DOTA_ATTACK, rate=1.5})
	end
end

function dimension_stalker_channel_end(event)
	local caster = event.caster
	local ability = event.ability
	ability.fallSpeed = 20

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_dimension_stalker_channel_end", {duration = 4})


end

function dimension_stalker_channel_end_think(event)
	local caster = event.caster
	local ability = event.ability
	ability.fallSpeed = ability.fallSpeed + 2
	-- caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,ability.fallSpeed))
	local landPoint = GetGroundPosition(caster:GetAbsOrigin(), caster)
	if landPoint.z + 10 < caster:GetAbsOrigin().z then
		
		caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,ability.fallSpeed))
	end
	
	if caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster) < 10 then
		caster:RemoveModifierByName("modifier_dimension_stalker_channel_end")
		Timers:CreateTimer(0.03, function()
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
			StartAnimation(caster, {duration=0.4, activity=ACT_DOTA_CAST_ABILITY_1_END, rate=1.1})
		end)
	end
end

function remove_modifier_channel_start(event)
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_dimension_stalker_channel_end", {duration = 4})
	Timers:CreateTimer(0.03, function()
		if not caster:HasModifier("modifier_dimension_stalker_active") then
			if ability.aoePFX then
				ParticleManager:DestroyParticle(ability.aoePFX, false)
				ability.aoePFX = false
			end
		end
	end)
end

function fire_dimension_stalker(event)
	local caster = event.caster
	local ability = event.ability
	local max_targets = event.max_targets
	if caster:HasModifier("modifier_omniro_glyph_3_1") then
		max_targets = max_targets + OMNIRO_GLYPH_3_1_INCREASED_ATTACKS
	end

	local interval_between_strikes = 0.06
    local duration = max_targets*interval_between_strikes + interval_between_strikes
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_dimension_stalker_active", {duration = duration})
   EmitSoundOn("Omniro.DimensionStalk.Success.VO", caster)
	
	
	

end

function dimension_stalker_active_think(event)
	local caster = event.caster
	local ability = event.ability
	local radius = event.radius
    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )

    if #enemies > 0 then    
    	local target = enemies[1]
   		if target and IsValidEntity(target) then
   			if not target.dummy then
   				CustomAbilities:QuickAttachParticle("particles/roshpit/omniro/dimension_stalk_attack.vpcf", target, 3)
   				Timers:CreateTimer(0.1, function()
   					Filters:PerformAttackSpecial(caster, target, true, true, true, false, true, false, false)
   				end)
   			end
   		end
    end	
	if ability.aoePFX then
		ParticleManager:SetParticleControl(ability.aoePFX, 0, caster:GetAbsOrigin())
	end
end

function dimension_stalker_end(event)
	local caster = event.caster
	local ability = event.ability
	if ability.aoePFX then
		ParticleManager:DestroyParticle(ability.aoePFX, false)
		ability.aoePFX = false
	end
end