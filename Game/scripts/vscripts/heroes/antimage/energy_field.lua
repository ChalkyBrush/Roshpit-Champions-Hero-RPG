require('heroes/antimage/machinal_jump')

function start_channel(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Akrimus.Channel.VO", caster)
	StartSoundEvent("Arkimus.EnergyField.Channel", caster)

	local c_d_level = caster:GetRuneValue("r", 3)
	if c_d_level > 0 then
		local duration = Filters:GetAdjustedBuffDuration(caster, ARKIMUS_R3_DURATION * c_d_level, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_energy_field_c_d_shield", {duration = duration})
	end
end

function channel_interrupt(event)
	local caster = event.caster
	StopSoundEvent("Arkimus.EnergyField.Channel", caster)
end

function channel_complete(event)
	local caster = event.caster
	local ability = event.ability
	local baseFV = caster:GetForwardVector()
	ability.velocity = 1000
	ability.rotationDelta = 30
	if caster:HasModifier("modifier_arkimus_glyph_1_1") then
		ability.rotationDelta = 14
	end
	StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_4, rate=1})
	EmitSoundOn("Arkimus.EnergyField.VO", caster)

	ability.r_1_level = caster:GetRuneValue("r", 1)
	ability.r_2_level = caster:GetRuneValue("r", 2)
	local count = event.spirits
	if caster:HasModifier("modifier_arkimus_glyph_3_1") then
		count = count + 2
	end
	if caster:HasAbility("ark_jump") then
		local jumpEventTable = {}
		jumpEventTable.caster = caster
		jumpEventTable.ability = caster:FindAbilityByName("ark_jump")
		jumpEventTable.target_points = {}
		jumpEventTable.target_points[1] = caster:GetAbsOrigin()
		jumpEventTable.special = true
		arkimus_jump_start(jumpEventTable)
	end
	if not ability.energyTable then
		ability.energyTable = {}
	end
	for j = 1, count, 1 do

		-- local projectileFV = WallPhysics:rotateVector(baseFV, 2*math.pi*j/8)
		-- local pfx = ParticleManager:CreateParticle("particles/base_attacks/astral_glyph_2_1_projectile.vpcf", PATTACH_CUSTOMORIGIN, caster)
		-- ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()+Vector(0,0,80))
		-- ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin()+projectileFV*1300+Vector(0,0,80))
		-- ParticleManager:SetParticleControl(pfx, 2, Vector(1000, 1000, 1000))
		-- Timers:CreateTimer(17, function()
		-- 	ParticleManager:DestroyParticle(pfx, false)
		-- end)
		-- for i = 1, 150, 1 do
		-- 	Timers:CreateTimer(i*0.1, function()
		-- 		local newFV = WallPhysics:rotateVector(projectileFV, 2*math.pi*i/35)
		-- 		local newPos = caster:GetAbsOrigin()+newFV*1800+Vector(0,0,80)
		-- 		-- if i%10 == 0 then
		-- 		-- 	if i%20 == 0 then
		-- 		-- 		ParticleManager:SetParticleControl(pfx, 2, Vector(1500, 1500, 1500))
		-- 		-- 	else
		-- 		-- 		ParticleManager:SetParticleControl(pfx, 2, Vector(1000, 1000, 1000))
		-- 		-- 	end
		-- 		-- end
		-- 		ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
		-- 		ParticleManager:SetParticleControl(pfx, 1, newPos)
		-- 	end)
		-- end

		local dummy = CreateUnitByName("npc_dummy_unit", caster:GetAbsOrigin(), false, nil, nil, caster:GetTeamNumber())
		ability:ApplyDataDrivenModifier(caster, dummy, "modifier_energy_field_thinker", {duration = 20})
		local projectileFV = WallPhysics:rotateVector(baseFV, 2*math.pi*j/count)
		local pfx = ParticleManager:CreateParticle("particles/base_attacks/astral_glyph_2_1_projectile.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()+Vector(0,0,80))
		ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin()+projectileFV*1300+Vector(0,0,80))
		ParticleManager:SetParticleControl(pfx, 2, Vector(ability.velocity, ability.velocity, ability.velocity))
		dummy.pfx = pfx
		dummy.interval = 0
		dummy.dummy = true
		dummy.pullPoint = caster:GetAbsOrigin()+projectileFV*1300+Vector(0,0,80)
		dummy.baseFV = projectileFV
		dummy.hardInterval = 0
		table.insert(ability.energyTable, dummy)
	end
	Filters:CastSkillArguments(4, caster)
	calculate_a_d(caster, ability)
end

function calculate_a_d(caster, ability)
	if ability.r_1_level > 0 then
		if #ability.energyTable > 0 then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_energy_shield_a_a_buff_visible", {})
			caster:SetModifierStackCount("modifier_energy_shield_a_a_buff_visible", caster, #ability.energyTable)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_energy_shield_a_a_buff_invisible", {})
			caster:SetModifierStackCount("modifier_energy_shield_a_a_buff_invisible", caster, #ability.energyTable*ability.r_1_level)
		else
			caster:RemoveModifierByName("modifier_energy_shield_a_a_buff_visible")
			caster:RemoveModifierByName("modifier_energy_shield_a_a_buff_invisible")
		end
	end
end

function energy_thinker(event)
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
	if dummy.interval == 3 then
		dummy.interval = 0
		local newFV = WallPhysics:rotateVector(dummy.baseFV, 2*math.pi/ability.rotationDelta)
		dummy.baseFV = newFV
		local newPos = caster:GetAbsOrigin()+newFV*1800+Vector(0,0,80)
		dummy.pullPoint = newPos
		ParticleManager:SetParticleControl(dummy.pfx, 1, newPos)
		-- ParticleManager:SetParticleControl(dummy.pfx, 2, Vector(ability.velocity, ability.velocity, ability.velocity))


	end
	if dummy.hardInterval%5 == 0 then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), dummy:GetAbsOrigin(), nil, 120, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	    if #enemies > 0 then
	    	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Arkimus.EnergyField.Hit", caster)
	        for _,enemy in pairs(enemies) do
	        	if not ability.particleCount then
	        		ability.particleCount = 0
	        	end
	        	if ability.particleCount < 15 then
		        	ability.particleCount = ability.particleCount + 1
		        	CustomAbilities:QuickAttachParticle("particles/econ/items/wisp/wisp_guardian_explosion_ti7.vpcf", enemy, 1)
		        	Timers:CreateTimer(1, function()
		        		ability.particleCount = ability.particleCount - 1
		        	end)
		        end
	        	Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_R, RPC_ELEMENT_ARCANE, RPC_ELEMENT_NONE)
	        	ability:ApplyDataDrivenModifier(caster, enemy, "modifier_energy_field_damage_reduce", {duration = 5})
	        end
	    end
	end
end

function energy_thinker_end(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local pfx = target.pfx
	Timers:CreateTimer(0.03, function()
		UTIL_Remove(target)
		reindexEnergyTable(ability)
		if #ability.energyTable == 0 then
			StopSoundEvent("Arkimus.EnergyField.Channel", caster)
		end
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Arkimus.EnergyField.End", caster)
		calculate_a_d(caster, ability)
	end)
	Timers:CreateTimer(1.5, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:ReleaseParticleIndex(pfx)
	end)
end

function reindexEnergyTable(ability)
	local newTable = {}
	for i = 1, #ability.energyTable, 1 do
		if IsValidEntity(ability.energyTable[i]) then
			table.insert(newTable, ability.energyTable[i])
		end
	end
	ability.energyTable = newTable
end