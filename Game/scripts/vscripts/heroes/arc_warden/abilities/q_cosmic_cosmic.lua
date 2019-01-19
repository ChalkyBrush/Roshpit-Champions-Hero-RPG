function jex_q_cosmic_cosmic_precast(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Jex.CosmicLaserCharge", caster)
	StartAnimation(caster, {duration=3, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.6})
	CustomAbilities:QuickAttachParticle("particles/roshpit/winterblight/torturok_charge.vpcf", caster, 1)
end

function jex_q_cosmic_cosmic_cast(event)
	local caster = event.caster
	local ability = event.ability
	EndAnimation(caster)
	Timers:CreateTimer(0.03, function()
		StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_ATTACK, rate=1.3})
	end)
	local beamLength = 1000
	local point = event.target_points[1] + Vector(0,0,90)
	local particle_name = "particles/econ/items/phoenix/phoenix_solar_forge/phoenix_sunray_solar_forge.vpcf"
	local pfx = ParticleManager:CreateParticle(particle_name, PATTACH_CUSTOMORIGIN, nil)
	-- ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_CUSTOMORIGIN, "attach_attack1", caster:GetAbsOrigin(), true)
	local particleVector = caster:GetAbsOrigin()+Vector(0,0,90) + (caster:GetForwardVector() * beamLength)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()+Vector(0,0,90))
	ParticleManager:SetParticleControl(pfx, 1, particleVector)
	ParticleManager:SetParticleControl(pfx, 3, particleVector)
	ParticleManager:SetParticleControl(pfx, 4, particleVector)
	-- Timers:CreateTimer(3, function()
	-- 	ParticleManager:DestroyParticle(pfx, false)
	-- end)
	ability.pfx = pfx
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_jex_q_cosmic_cosmic_casting", {})
	ability.interval = 0
	EmitSoundOn("Jex.CosmicLaserCharge", caster)
end

function q_cosomic_cosmic_casting_thinker(event)
	-- local caster = event.caster
	-- local ability = event.ability
	-- local beamLength = 1000
	-- if ability.pfx then
	-- 	local pfx = ability.pfx
	-- 	local particleVector = caster:GetAbsOrigin()+Vector(0,0,90) + (caster:GetForwardVector() * beamLength)
	-- 	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()+Vector(0,0,90))
	-- 	ParticleManager:SetParticleControl(pfx, 1, particleVector)
	-- 	ParticleManager:SetParticleControl(pfx, 3, particleVector)
	-- 	ParticleManager:SetParticleControl(pfx, 4, particleVector)		
	-- end
	-- ability.interval = ability.interval + 1
	-- if ability.interval%30 == 0 then
	-- 	StartAnimation(caster, {duration=0.85, activity=ACT_DOTA_ATTACK, rate=1})
	-- end
	-- caster:SetAbsOrigin(caster:GetAbsOrigin()+caster:GetForwardVector()*4)
end

function jex_q_cosmic_cosmic_off(event)
	local caster = event.caster
	local ability = event.ability
	caster:RemoveModifierByName("modifier_jex_q_cosmic_cosmic_casting")
	StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_ATTACK, rate=1.3})
end

function jex_q_cosmic_cosmic_casting_end(event)
	local caster = event.caster
	local ability = event.ability
	Timers:CreateTimer(0.03, function()
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		if ability.pfx then
			ParticleManager:DestroyParticle(ability.pfx, false)
			ability.pfx = false
		end
	end)
end

function jex_q_cosmic_cosmic_cast_targetted(event)
	local caster = event.caster
	local ability = event.ability
	-- StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_ATTACK, rate=1.3})
	local particleVector = caster:GetAbsOrigin()+Vector(0,0,90)
	if not ability.beamTable then
		ability.beamTable = {}
	end
	local beam = {}
	local particle_name = "particles/roshpit/jex/galaxy_laser.vpcf"
	local pfx = ParticleManager:CreateParticle(particle_name, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()+Vector(0,0,90))
	ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin()+Vector(0,0,90))
	ParticleManager:SetParticleControl(pfx, 3, caster:GetAbsOrigin()+Vector(0,0,90))
	ParticleManager:SetParticleControl(pfx, 4, caster:GetAbsOrigin()+Vector(0,0,90))
	beam.target = event.target_points[1]
	beam.pfx = pfx
	beam.position = caster:GetAbsOrigin()
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_jex_q_cosmic_cosmic_casting2", {})
	beam.interval = 0
	beam.active = true
	beam.length = WallPhysics:GetDistance2d(beam.position, beam.target)
	beam.startPoint = caster:GetAbsOrigin()
	table.insert(ability.beamTable, beam)
	Filters:CastSkillArguments(1, caster)
	-- StartAnimation(caster, {duration=0.85, activity=ACT_DOTA_ATTACK, rate=1})
	EmitSoundOn("Jex.CosmicLaser", caster)
end

function jex_q_cosmic_cosmic_casting_thinker2(event)
	local caster = event.caster
	local ability = event.ability
	local beamLength = 1000
	local damage = event.damage

	local tech_level = caster.onibi.stats_table["cosmic"]["cosmic"]["Q"]["level"]
	if tech_level > 0 then
		damage = damage + OverflowProtectedGetAverageTrueAttackDamage(caster)*(event.postmitigation_per_tech/100)*tech_level
	end
	for i = 1, #ability.beamTable, 1 do
		local beam = ability.beamTable[i]
		if beam and beam.target then
			if not beam.distance_moved then
				beam.distance_moved = 0
			end
			local moveDirection = ((beam.target-beam.position)*Vector(1,1,0)):Normalized()
			beam.distance_moved = beam.distance_moved + 100
			beam.position = caster:GetAbsOrigin() + beam.distance_moved*caster:GetForwardVector()

			if beam.pfx then
				local pfx = beam.pfx
				local particleVector = beam.position
				ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()+Vector(0,0,90))
				ParticleManager:SetParticleControl(pfx, 1, particleVector+Vector(0,0,90))
				ParticleManager:SetParticleControl(pfx, 3, particleVector+Vector(0,0,90))
				ParticleManager:SetParticleControl(pfx, 4, particleVector+Vector(0,0,90))		
			end
			if beam.interval%1 == 0 then
				-- local enemies = FindUnitsInRadius( caster:GetTeamNumber(), beam.position, nil, 80, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
				local vStartPos = caster:GetAbsOrigin()
				local vEndPos = beam.position

				local width = 120
				local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
				local types = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
				local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
				local enemies = FindUnitsInLine(caster:GetTeamNumber(),vStartPos, vEndPos, nil, 120, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
				if #enemies > 0 then
					for _,enemy in pairs(enemies) do
						Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PURE, 1, RPC_ELEMENT_COSMOS, RPC_ELEMENT_NONE)
						ability:ApplyDataDrivenModifier(caster, enemy, "modifier_jex_q_cosmic_cosmic_postmitigation", {duration = event.debuff_duration})
						enemy:SetModifierStackCount("modifier_jex_q_cosmic_cosmic_postmitigation", caster, tech_level)

					end
				end	
				-- local allies = FindUnitsInRadius( caster:GetTeamNumber(), beam.position, nil, 80, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
				-- if #allies > 0 then
				-- 	for _,ally in pairs(allies) do
				-- 		ally_beam_hit(heal_pct, caster, ability, ally)
				-- 	end
				-- end	
			end
			local distance = WallPhysics:GetDistance2d(beam.position, caster:GetAbsOrigin())
			if beam.distance_moved >= beam.length then
				-- beam.position = beam.target
				beam.active = false
			end
			beam.interval = beam.interval + 1
		end
	end
	reindex_beam_table(caster, ability)
end

-- function ally_beam_hit(heal_pct, caster, ability, ally)

-- end

function reindex_beam_table(caster, ability)
	local newBeamTable = {}
	for i = 1, #ability.beamTable, 1 do
		local beam = ability.beamTable[i]
		if beam.active then
			table.insert(newBeamTable, beam)
		else
			Timers:CreateTimer(1, function()
				ParticleManager:DestroyParticle(beam.pfx, false)
			end)
		end
	end
	ability.beamTable = newBeamTable
	if #ability.beamTable == 0 then
		caster:RemoveModifierByName("modifier_jex_q_cosmic_cosmic_casting2")
	end
end

-- function jex_q_cosmic_cosmic_casting_end2(event)

-- end