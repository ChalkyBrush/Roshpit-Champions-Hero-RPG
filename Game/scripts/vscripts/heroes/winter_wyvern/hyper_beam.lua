function hyperbeam_start_channel(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	local position = caster:GetAbsOrigin() + caster:GetForwardVector()*120
	local hyperbeam = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, caster:GetTeamNumber())
	local flightStacks = caster:GetModifierStackCount("modifier_dinath_postflight_zheight", caster)
	hyperbeam:SetAbsOrigin(((caster:GetAbsOrigin() + caster:GetForwardVector()*120)*Vector(1,1,0))+Vector(0,0,caster:GetAbsOrigin().z+150+flightStacks))

	hyperbeam:FindAbilityByName("dummy_unit"):SetLevel(1)
	hyperbeam.interval = 0
	ability:ApplyDataDrivenModifier(caster, hyperbeam, "modifier_hyperbeam_orb", {})
	hyperbeam.fv = ((target - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	if not ability.hyperbeamTable then
		ability.hyperbeamTable = {}
	end
	local pfx = ParticleManager:CreateParticle("particles/roshpit/dinath/hyperbeam_orb_ball_lightning.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, hyperbeam:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 2, Vector(50, 50, 50))
	hyperbeam.pfx = pfx
	hyperbeam.size = 50
	if caster:HasModifier("modifier_dinath_immortal_weapon_1") then
		hyperbeam.size = hyperbeam.size + 100
	end
	hyperbeam.speed = 40
	hyperbeam:SetDayTimeVisionRange(200)
	hyperbeam:SetNightTimeVisionRange(200)
	hyperbeam.distanceTravelled = 0
	hyperbeam.r_1_level = caster:GetRuneValue("r", 1)
	hyperbeam.r_2_level = caster:GetRuneValue("r", 2)
	hyperbeam.r_3_level = caster:GetRuneValue("r", 3)
	ability.channeledBeam = hyperbeam
	table.insert(ability.hyperbeamTable, hyperbeam)
	StartSoundEvent("Dinath.HyperBeam.Start", caster)
	if not ability.dragonVOlock then
		ability.dragonVOlock = true
		EmitSoundOn("Dinath.HyperBeam.StartVO", caster)
		Timers:CreateTimer(1, function()
			ability.dragonVOlock = false
		end)
	end
	if caster:HasModifier("modifier_iron_treads_of_destruction") then
		local growth_rate = 2.5
		growth_rate = growth_rate + growth_rate*0.01*hyperbeam.r_3_level 
		hyperbeam.size = hyperbeam.size + growth_rate*40
		ParticleManager:SetParticleControl(hyperbeam.pfx, 2, Vector(hyperbeam.size, hyperbeam.size, hyperbeam.size))
	end
end

function hyperbeam_interrupt_channel(event)
	local caster = event.caster
	local ability = event.ability
	StopSoundEvent("Dinath.HyperBeam.Start", caster)
	fire_hyperbeam(caster, ability)
end

function hyper_beam_finish_channel(event)
	local caster = event.caster
	local ability = event.ability
	Filters:CastSkillArguments(4, caster)
	fire_hyperbeam(caster, ability)
end


function fire_hyperbeam(caster, ability)
	local hyperbeam = ability.channeledBeam
	hyperbeam.launched = true
	EmitSoundOn("Dinath.HyperBeam.FireStart", hyperbeam)
	if hyperbeam.size <= 100 then
		EmitSoundOn("Dinath.HyperBeam.Fire1", hyperbeam)
	elseif hyperbeam.size <= 200 then
		EmitSoundOn("Dinath.HyperBeam.Fire2", hyperbeam)
	else
		EmitSoundOn("Dinath.HyperBeam.Fire3", hyperbeam)
	end
	StartAnimation(caster, {duration=1.5, activity=ACT_DOTA_CAST_ABILITY_4, rate=1.0})
	Timers:CreateTimer(0.2, function()
		if not ability.dragonVOlock then
			ability.dragonVOlock = true
			EmitSoundOn("Dinath.HyperBeam.EndVO", caster)
			Timers:CreateTimer(1, function()
				ability.dragonVOlock = false
			end)
		end
	end)
end

function hyperbeam_orb_thinking(event)
	local hyperbeam = event.target
	local caster = event.caster
	local ability = event.ability
	ParticleManager:SetParticleControl(hyperbeam.pfx, 0, hyperbeam:GetAbsOrigin())
	if hyperbeam.launched then
		local downVector = Vector(0,0,0)
		if hyperbeam:GetAbsOrigin().z > GetGroundHeight(hyperbeam:GetAbsOrigin(), hyperbeam) + 150 then
			downVector = Vector(0,0,-20)
		end
		hyperbeam.speed = math.max(hyperbeam.speed - 0.7, 20)
		local forwardMovement = hyperbeam.speed
		hyperbeam:SetAbsOrigin(hyperbeam:GetAbsOrigin() + hyperbeam.fv*forwardMovement + downVector)
		hyperbeam.distanceTravelled = hyperbeam.distanceTravelled + forwardMovement
		local max_distance = 2000
		if caster:HasModifier("modifier_dinath_immortal_weapon_1") then
			max_distance = max_distance + 1000
		end
		if hyperbeam.distanceTravelled >= max_distance then
			hyperbeam:RemoveModifierByName("modifier_hyperbeam_orb")
			Timers:CreateTimer(0.03, function()
				UTIL_Remove(hyperbeam)
				reindex_hyperbeams(ability)
			end)
			ParticleManager:DestroyParticle(hyperbeam.pfx, false)
		end

		hyperbeam.interval = hyperbeam.interval + 1
		if hyperbeam.interval%5 == 0 then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), hyperbeam:GetAbsOrigin(), nil, hyperbeam.size, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			local freeze_duration = event.freeze_duration
			if caster:HasModifier("modifier_dinath_glyph_1_1") then
				freeze_duration = freeze_duration + 1.5
			end
			if #enemies > 0 then	
				for _,enemy in pairs(enemies) do
					-- Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_E, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
					local immunityStacks = enemy:GetModifierStackCount("modifier_hyperbeam_immunity", caster)
					if not enemy:HasModifier("modifier_hyperbeam_freeze") then
						EmitSoundOn("Dinath.HyperBeam.Freeze", enemy)
					end
					if immunityStacks < 5 then
						ability:ApplyDataDrivenModifier(caster, enemy, "modifier_hyperbeam_freeze", {duration = freeze_duration})
						ability:ApplyDataDrivenModifier(caster, enemy, "modifier_hyperbeam_immunity", {duration = 5})
						enemy:SetModifierStackCount("modifier_hyperbeam_immunity", caster, immunityStacks+1)
					end
					if hyperbeam.r_2_level > 0 then
						ability:ApplyDataDrivenModifier(caster, enemy, "modifier_hyperbeam_postmit", {duration = 7})
						enemy:SetModifierStackCount("modifier_hyperbeam_postmit", caster, hyperbeam.r_2_level)
					end
				end				
			end			
		end
		if hyperbeam.r_1_level > 0 then
			if hyperbeam.interval%6 == 0 then
				local enemies = FindUnitsInRadius( caster:GetTeamNumber(), hyperbeam:GetAbsOrigin(), nil, hyperbeam.size*2, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
				if #enemies > 0 then	
					for i = 1, #enemies, 1 do
						local enemy = enemies[i]
						Timers:CreateTimer(0.01*i, function()
							hyperbeam_jolt(caster, hyperbeam, enemy)
						end)
					end
				end
			end
		end
	else
		local flightStacks = caster:GetModifierStackCount("modifier_dinath_postflight_zheight", caster)
		hyperbeam:SetAbsOrigin(((caster:GetAbsOrigin() + caster:GetForwardVector()*120)*Vector(1,1,0))+Vector(0,0,caster:GetAbsOrigin().z+150+flightStacks))
		local growth_rate = 2.5
		growth_rate = growth_rate + growth_rate*0.01*hyperbeam.r_3_level 
		hyperbeam.size = hyperbeam.size + growth_rate
		ParticleManager:SetParticleControl(hyperbeam.pfx, 2, Vector(hyperbeam.size, hyperbeam.size, hyperbeam.size))
	end
end

function reindex_hyperbeams(ability)
	local newTable = {}
	for i = 1, #ability.hyperbeamTable, 1 do
		local beam = ability.hyperbeamTable[i]
		if IsValidEntity(beam) then
			table.insert(newTable, beam)
		end
	end
	ability.hyperbeamTable = newTable
end

function hyperbeam_jolt(caster, hyperbeam, enemy)
	if IsValidEntity(hyperbeam) then
	  local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)*0.05*hyperbeam.r_1_level
	  damage = damage*(hyperbeam.size/100)
      local particleName = "particles/roshpit/dinath/hyper_zap_beam.vpcf"
      local attachPointA = hyperbeam:GetAbsOrigin()
      local attachPointB = enemy:GetAbsOrigin() + Vector(0,0,enemy:GetBoundingMaxs().z)
      local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster) 
      ParticleManager:SetParticleControl(lightningBolt,0,Vector(attachPointA.x,attachPointA.y,attachPointA.z))   
      ParticleManager:SetParticleControl(lightningBolt,1,Vector(attachPointB.x,attachPointB.y,attachPointB.z))
      Timers:CreateTimer(2, function()
        ParticleManager:DestroyParticle(lightningBolt, false)
        ParticleManager:ReleaseParticleIndex(lightningBolt)
      end)
      Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_R, RPC_ELEMENT_DRAGON, RPC_ELEMENT_LIGHTNING)
    end
end

function dinath_glyph_5_a_init(event)
	local target = event.target
	target.immo_glyph_data = event
end