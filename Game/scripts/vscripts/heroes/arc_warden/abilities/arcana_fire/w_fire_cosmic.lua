require('heroes/arc_warden/abilities/onibi')

function jex_fire_cosmic_w_start(event)
	local caster = event.caster
	local ability = event.ability
	local baseFV = caster:GetForwardVector()
	ability.velocity = 400
	ability.rotationDelta = 50
	StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_1, rate=1})
	EmitSoundOn("Arkimus.EnergyField.VO", caster)
	ability.tech_level = onibi_get_total_tech_level(caster, "fire", "cosmic", "W")
	ability.r_1_level = caster:GetRuneValue("r", 1)
	ability.r_2_level = caster:GetRuneValue("r", 2)
	local count = event.flames
	local duration = Filters:GetAdjustedBuffDuration(caster, event.duration, false)
	if not ability.flameTable then
		ability.flameTable = {}
	end
	local current_flames_count = #ability.flameTable
	local flames_to_create = count - current_flames_count
	if flames_to_create > 0 then
		for j = 1, flames_to_create, 1 do
			local dummy = CreateUnitByName("npc_dummy_unit", caster:GetAbsOrigin(), false, nil, nil, caster:GetTeamNumber())
			local projectileFV = WallPhysics:rotateVector(baseFV, 2*math.pi*j/count)
			local pfx = ParticleManager:CreateParticle("particles/roshpit/jex/orbital_flame.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()+Vector(0,0,80))
			ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin()+projectileFV*500+Vector(0,0,80))
			ParticleManager:SetParticleControl(pfx, 2, Vector(ability.velocity, ability.velocity, ability.velocity))
			dummy.pfx = pfx
			dummy.interval = 0
			dummy.dummy = true
			dummy.pullPoint = caster:GetAbsOrigin()+projectileFV*400+Vector(0,0,80)
			dummy.baseFV = projectileFV
			dummy.hardInterval = 0
			table.insert(ability.flameTable, dummy)
		end
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_jex_orbital_flame_effect", {duration = duration})
	caster:SetModifierStackCount("modifier_jex_orbital_flame_effect", caster, #ability.flameTable)
	local w_4_level = caster:GetRuneValue("w", 4)
	local e_4_level = caster:GetRuneValue("e", 4)
	ability.w_4_level = w_4_level
	ability.e_4_level = e_4_level
	if w_4_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_jex_orbital_flame_attack_damage", {duration = duration})
		caster:SetModifierStackCount("modifier_jex_orbital_flame_attack_damage", caster, #ability.flameTable*w_4_level)
	end
	if e_4_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_jex_orbital_flame_mana_regen", {duration = duration})
		caster:SetModifierStackCount("modifier_jex_orbital_flame_mana_regen", caster, #ability.flameTable*e_4_level)
	end
	for i = 1, #ability.flameTable, 1 do
		ability:ApplyDataDrivenModifier(caster, ability.flameTable[i], "modifier_orbital_flame_thinker", {duration = duration})
		local baseFV = caster:GetForwardVector()
		local projectileFV = WallPhysics:rotateVector(baseFV, 2*math.pi*i/5)
		local position = caster:GetAbsOrigin() 
		local pfx = ParticleManager:CreateParticle("particles/roshpit/jex/jex_tinker_tinker_laser.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAttachmentOrigin(3))
		ParticleManager:SetParticleControl(pfx, 1, ability.flameTable[i].pullPoint)
		ParticleManager:SetParticleControlEnt(pfx, 9, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAttachmentOrigin(3), true)
		Timers:CreateTimer(0.2, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	end
	EmitSoundOn("Jex.OrbitalFlame.Start", caster)
	Filters:CastSkillArguments(2, caster)
end

function orbital_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local dummy = target
	dummy.interval = dummy.interval + 1
	dummy.hardInterval = dummy.hardInterval + 1
	local movement = ((dummy.pullPoint - dummy:GetAbsOrigin()):Normalized()*0.03)*ability.velocity
	movement = movement*Vector(1,1,0)
	dummy:SetAbsOrigin(dummy:GetAbsOrigin()+movement)
	local damage = event.damage + ability.r_2_level*OverflowProtectedGetAverageTrueAttackDamage(caster)*0.02
	local distance = WallPhysics:GetDistance2d(dummy.pullPoint, dummy:GetAbsOrigin())
	local newSpeed = math.min(300+distance, 2400)
	ParticleManager:SetParticleControl(dummy.pfx, 2, Vector(newSpeed, newSpeed, newSpeed))
	if dummy.interval == 1 then
		dummy.interval = 0
		local newFV = WallPhysics:rotateVector(dummy.baseFV, 2*math.pi/ability.rotationDelta)
		dummy.baseFV = newFV
		local newPos = caster:GetAbsOrigin()+newFV*240+Vector(0,0,80)
		dummy.pullPoint = newPos
		ParticleManager:SetParticleControl(dummy.pfx, 1, newPos)
		-- ParticleManager:SetParticleControl(dummy.pfx, 2, Vector(ability.velocity, ability.velocity, ability.velocity))


	end
end



function orbital_thinker_end(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local pfx = target.pfx
	Timers:CreateTimer(0.03, function()
		ParticleManager:SetParticleControl(target.pfx, 2, Vector(700, 700, 700))
		ParticleManager:SetParticleControl(target.pfx, 1, target:GetAbsOrigin()+target.baseFV*2000)
		UTIL_Remove(target)
		reindex_flameTable(ability)
		if #ability.flameTable == 0 then
			caster:RemoveModifierByName("modifier_jex_orbital_flame_effect")
		end
		EmitSoundOn("Jex.OrbitalFlame.End", caster)
	end)
	Timers:CreateTimer(0.2, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:ReleaseParticleIndex(pfx)
	end)
end

function reindex_flameTable(ability)
	local newTable = {}
	for i = 1, #ability.flameTable, 1 do
		if IsValidEntity(ability.flameTable[i]) then
			table.insert(newTable, ability.flameTable[i])
		end
	end
	ability.flameTable = newTable
end