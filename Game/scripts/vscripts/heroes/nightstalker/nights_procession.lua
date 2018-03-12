-- LinkLuaModifier("modifier_chernobog_ult_aura", "modifiers/chernobog_shadow_walk/modifier_chernobog_ult_aura", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_chernobog_ult_freeze_special", "modifiers/chernobog_shadow_walk/modifier_chernobog_ult_aura", LUA_MODIFIER_MOTION_NONE)  

require('heroes/nightstalker/charons_claw')

function start_channel(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Chernobog.NightsProcessionChannelStart", caster)
	ability.targetPoint = event.target_points[1]

	local d_d_level = Runes:GetTotalRuneLevel(caster, 4, "d_d", "chernobog")
	if d_d_level > 0 then
		print("D_D_INTO")
		local particleName = "particles/roshpit/chernobog/d_d_intro.vpcf"
		ability.channelPFX = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(ability.channelPFX, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(ability.channelPFX, 1, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(ability.channelPFX, 2, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(ability.channelPFX, 3, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(ability.channelPFX, 4, caster:GetAbsOrigin())
		-- ParticleManager:SetParticleControlEnt(ability.channelPFX, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	end

end

function night_ulti_channel_fail(event)
	local caster = event.caster
	local ability = event.ability
	caster:RemoveModifierByName("modifier_channel_animation")
	if ability.channelPFX then
		ParticleManager:DestroyParticle(ability.channelPFX, false)
	end
	ability.channelPFX = false
end

function begin_nights_procession(event)
	local caster = event.caster
	local ability = event.ability
	local radius = event.radius
	local originalPosition = caster:GetAbsOrigin()
	ability.a_d_level = Runes:GetTotalRuneLevel(caster, 1, "a_d", "chernobog")
	ability.b_d_level = Runes:GetTotalRuneLevel(caster, 2, "b_d", "chernobog")
	ability.c_d_level = Runes:GetTotalRuneLevel(caster, 3, "c_d", "chernobog")
	local d_d_level = Runes:GetTotalRuneLevel(caster, 4, "d_d", "chernobog")
	caster:RemoveModifierByName("modifier_chernobog_demon_flight")
	if d_d_level > 0 then
		local clawEvent = {}
		clawEvent.caster = caster
		clawEvent.ability = caster:FindAbilityByName("chernobog_charons_claw")
		clawEvent.target_points = {}
		clawEvent.target_points[1] = ability.targetPoint
		clawEvent.range = 500 + d_d_level*50
		clawEvent.damage = clawEvent.ability:GetAbilityDamage()
		charons_claw_cast(clawEvent)
	end
	if ability.channelPFX then
		ParticleManager:DestroyParticle(ability.channelPFX, false)
	end
	ability.channelPFX = false
	-- ability.d_d_level = d_d_level
	-- radius = radius + d_d_level*6
	ability.trappedUnitTable = {}
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_antimage/antimage_manavoid.vpcf", caster, 4)
	EmitSoundOn("Chernobog.NightsProcessionChannelEnd", caster)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_nights_procession_caster_lifting", {duration = 3.64})
	local sumheight = 0
	for i = 1, 60, 1 do
		sumheight = sumheight + i*0.8
		Timers:CreateTimer(0.03*i, function()
			caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,i*0.8))
		end)
	end
	Timers:CreateTimer(1.8, function()
		-- caster:AddNoDraw()
	end)
	Timers:CreateTimer(1.86, function()

		
		-- caster:RemoveNoDraw()
		local casterOrigin = caster:GetAbsOrigin()
		print(casterOrigin)
		local blockedTarget = WallPhysics:WallSearch(originalPosition, ability.targetPoint, caster)
		ability.targetPoint = blockedTarget
		caster:SetAbsOrigin(Vector(blockedTarget.x, blockedTarget.y, GetGroundHeight(blockedTarget, caster)+sumheight))
		local dropspeed = 0
		local dropDif = 0
		local startDropPoint = caster:GetAbsOrigin()
		for i = 1, 60, 1 do		
			Timers:CreateTimer(0.03*i, function()
				caster:SetAbsOrigin(startDropPoint-Vector(0,0,dropDif))
				dropDif = dropDif + i*0.8
			end)
		end		
	end)
	Timers:CreateTimer(3.3, function()
		caster:RemoveModifierByName("modifier_channel_animation")
		Filters:CastSkillArguments(4, caster)
	end)
	Timers:CreateTimer(3.4, function()

		EmitSoundOnLocationWithCaster(ability.targetPoint, "Chernobog.NightsProcession.Orb", caster)
		local particleName = "particles/roshpit/chernobog/nights_procession_aoe.vpcf"

		ability.pfx = ParticleManager:CreateParticle("particles/roshpit/chernobog/nights_procession_aoe.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(ability.pfx, 0, ability.targetPoint)
		ParticleManager:SetParticleControl(ability.pfx, 1, Vector(radius, radius, radius))
		StartAnimation(caster, {duration=1, activity=ACT_DOTA_TELEPORT_END, rate=0.8})
		local ultDuration = Filters:GetAdjustedBuffDuration(caster, 6.0, false)
		ability:ApplyDataDrivenThinker(caster, ability.targetPoint, "modifier_nights_procession_aura_thinker", {duration = ultDuration+0.5, radius = radius, Aura_Radius = radius})
	end)
	Timers:CreateTimer(3.69, function()
		ScreenShake(caster:GetAbsOrigin(), 260, 0.3, 0.3, 9000, 0, true)
		FindClearSpaceForUnit(caster, ability.targetPoint, false)
		EmitSoundOn("Chernobog.NightsProcession.Land", caster)
		local pfx = ParticleManager:CreateParticle( "particles/econ/events/ti4/teleport_end_dust_ti4.vpcf", PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( pfx, 0, caster:GetAbsOrigin() )
		ParticleManager:SetParticleControl( pfx, 1, Vector(200, 200, 200) )
		Timers:CreateTimer(2, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	end)
	Timers:CreateTimer(10, function()
		ParticleManager:DestroyParticle(ability.pfx, false)
	end)
end

function freeze_start(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	-- CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf", event.target, 2)
	if ability.a_d_level > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_nights_procession_a_d_rune", {duration = 6})
		target:SetModifierStackCount("modifier_nights_procession_a_d_rune",caster, ability.a_d_level)
	end
	if ability.b_d_level > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_nights_procession_illusion", {duration = 8})
	end
	table.insert(ability.trappedUnitTable, target)
end

function freeze_end(event)
	local target = event.target
	target:RemoveModifierByName("modifier_nights_procession_a_d_rune")
	target:RemoveModifierByName("modifier_nights_procession_illusion")
end

function rune_b_d_illusion(event)
	local timerRand = RandomInt(1,48)
	Timers:CreateTimer(timerRand/100, function()
		local caster = event.caster
		local target = event.target
		local ability = event.ability
		local damage = caster:GetAverageTrueAttackDamage(caster)*ability.b_d_level*0.03
		CustomAbilities:QuickAttachParticle("particles/roshpit/chernobog/nights_procession_illusion.vpcf", target, 1.4)
		Timers:CreateTimer(0.5, function()
			EmitSoundOn("Chernobog.BC.Hit", target)
			Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_DEMON, RPC_ELEMENT_NONE)
		end)	
	end)
end

function locked_unit_attack(event)
	local attacker = event.attacker
	local ability = event.ability
	local target = event.target
	local caster = event.caster
	if attacker:GetEntityIndex() == caster:GetEntityIndex() then
		local caster = attacker
		print("HELLO?")
		if ability.c_d_level > 0 then
			-- for i = 1, #ability.trappedUnitTable, 1 do
			-- 	local damage = event.attack_damage*0.03*ability.c_d_level
			-- 	ApplyDamage({ victim = ability.trappedUnitTable[i], attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_PURE })
			-- end
			local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
			local particle2 = ParticleManager:CreateParticle( particleNameS, PATTACH_WORLDORIGIN, caster )
			local radius = 360
			ParticleManager:SetParticleControl( particle2, 0, target:GetAbsOrigin() )
			ParticleManager:SetParticleControl( particle2, 1, Vector(radius,radius,radius) )
			ParticleManager:SetParticleControl( particle2, 2, Vector(2.0, 2.0, 2.0) )
			ParticleManager:SetParticleControl( particle2, 4, Vector(22, 56, 148) )
			Timers:CreateTimer(1.5, 
			function()
			ParticleManager:DestroyParticle( particle2, false )
			end)
			local damage = event.attack_damage*0.05*ability.c_d_level
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			if #enemies > 0 then
				for _,enemy in pairs(enemies) do
					Filters:TakeArgumentsAndApplyDamage(enemy, attacker, damage, DAMAGE_TYPE_PURE, 0, RPC_ELEMENT_DEMON, RPC_ELEMENT_NONE)
				end
			end 
		end
	end
end