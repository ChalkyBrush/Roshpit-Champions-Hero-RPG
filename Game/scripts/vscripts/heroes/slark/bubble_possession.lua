require('heroes/slark/jump')
require('heroes/slark/constants')

LinkLuaModifier("slipfinn_possessed_lua", "modifiers/slipfinn/slipfinn_possessed_lua", LUA_MODIFIER_MOTION_NONE)

CHANNEL_INTERVALS = 50

function start_channel(event)
	local caster = event.caster
	local ability = event.ability
	ability.interval = 0
	ability.target = event.target
	if ability.lockedTarget then
		release(event)
	end
	ability.lifting = true
	ability.fv = caster:GetForwardVector()
	StartSoundEvent("Slipfinn.Possess.Channel.LP", caster)
	EmitSoundOn("Slipfinn.PossessStartChannel.VO", caster)
	ability.r_2_level = Runes:GetTotalRuneLevelGeneric(caster, 2, 3)
	if caster:HasModifier("modifier_slipfinn_glyph_6_1") then
		ability:ApplyDataDrivenModifier(caster, ability.target, "modifier_bubble_possess_6_1_glyph", {duration = 3.0})
	end
end

function bubble_possession_channel_thinking(event)
	local caster = event.caster
	local ability = event.ability

	if ability.target then
		local directionToTarget = ((ability.target:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		caster:SetForwardVector(directionToTarget)
		ability.interval = ability.interval + 1
		-- local cosValue = math.cos(2*math.pi*ability.interval/30)*10
		-- local cosValue2 = math.sin(2*math.pi*ability.interval/60)*15
		-- local cosVector = Vector(cosValue, cosValue, 0)
		local intensity = math.min(ability.interval, CHANNEL_INTERVALS)/CHANNEL_INTERVALS
		local cosVector = WallPhysics:rotateVector(ability.fv, 2*math.pi*ability.interval/25)*25*intensity
		local movementVector = caster:GetAbsOrigin()-directionToTarget*7+Vector(0,0,4)+Vector(0,0,math.sin(10*ability.interval*2*math.pi/CHANNEL_INTERVALS)+1) + cosVector
		local movementVector2 = WallPhysics:WallSearch(caster:GetAbsOrigin(), movementVector, caster)
		caster:SetAbsOrigin(movementVector2)
	end

end


function channel_interrupt(event)
	local caster = event.caster
	local ability = event.ability
	StopSoundEvent("Slipfinn.Possess.Channel.LP", caster)
	if ability.target then
		ability.target:RemoveModifierByName("modifier_bubble_possess_6_1_glyph")
		if caster:HasModifier("modifier_slipfinn_glyph_6_1") then
			ability.fallFromHeight = ability.target:GetAbsOrigin().z
			ability.target:RemoveModifierByName("modifier_possession_enemy_lock")
			ability.target:RemoveModifierByName("slipfinn_possessed_lua")
			ability:ApplyDataDrivenModifier(caster, ability.target, "modifier_release_falling", {duration = 1})
			ability.target.possessionFallSpeed = 3
		end
	end
end

function bubble_possess_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	-- StopSoundEvent("Slipfinn.Possess.Channel.LP", caster)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_possession_moving_toward_target", {duration = 10})
	CustomAbilities:QuickParticleAtPoint("particles/roshpit/possession_begin_flight_tart.vpcf", caster:GetAbsOrigin(), 1)
	ability.moveInterval = 0
	print(caster:GetAbsOrigin())
	ability.speed = WallPhysics:GetDistance(caster:GetAbsOrigin(), target:GetAbsOrigin())/12
	Timers:CreateTimer(0.03, function()
		StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_SLARK_POUNCE, rate=2})
	end)
	local luck = RandomInt(1, 3)
	if luck == 1 then
	else
		EmitSoundOn("Slipfinn.PossessStartMove.VO", caster)
	end
	EmitSoundOn("Slipfinn.Possess.MoveStart", caster)
	Filters:CastSkillArguments(4, caster)
end

function possession_moving_towards_think(event)
	local caster = event.caster
	local ability = event.ability
	local duration = Filters:GetAdjustedBuffDuration(caster, event.duration, false)
	local directionToTarget = ((ability.target:GetAbsOrigin()-caster:GetAbsOrigin())):Normalized()
	local facingTarget = ((ability.target:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	if not ability.speed then
		return false
	end
	if not caster:IsAlive() then
		return false
	end
	caster:SetForwardVector(facingTarget)
	local heightVsTargetHeight = math.max(caster:GetAbsOrigin().z - ability.target:GetAbsOrigin().z, 0)
	caster:SetAbsOrigin(caster:GetAbsOrigin()+directionToTarget*ability.speed)
	local distanceToTarget = WallPhysics:GetDistance(caster:GetAbsOrigin(), ability.target:GetAbsOrigin())
	if distanceToTarget < ability.speed*1.1 then
		if ability.target.dominion then
			ability.lockedTarget = ability.target
			CustomAbilities:AddAndOrSwapSkill(caster, "slipfinn_bubble_possession", "slipfinn_release_possess", DOTA_ULTIMATE_SLOT)
			ability.enemyMovementPhase = 0
			ability:ApplyDataDrivenModifier(caster, ability.target, "modifier_possession_enemy_lock", {duration = duration})
			ability.target:AddNewModifier( caster, ability, "slipfinn_possessed_lua", {duration = duration} )
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_slipfinn_enemy_locked", {duration = duration})
			local d_d_level = Runes:GetTotalRuneLevelGeneric(caster, 4, 3)
			if d_d_level > 0 then
				local attackPowerGain = ability.lockedTarget:GetAttackDamage()*SLIPFINN_R4_ATTACK_POWER_STEAL*d_d_level
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_possession_attack_power", {})
				caster:SetModifierStackCount("modifier_possession_attack_power", caster, attackPowerGain)
			end
			if ability.lockedTarget:IsAlive() then
				collect_abilities(caster, ability, ability.lockedTarget)	
			end		
		else
			Notifications:Top(caster:GetPlayerOwnerID(), {text="slipfinn_possession_warning", duration=5, style={color="#FF1111"}, continue=true})
			if caster:HasModifier("modifier_slipfinn_glyph_6_1") then
				ability.fallFromHeight = ability.target:GetAbsOrigin().z
				ability.target:RemoveModifierByName("modifier_possession_enemy_lock")
				ability.target:RemoveModifierByName("slipfinn_possessed_lua")
				ability:ApplyDataDrivenModifier(caster, ability.target, "modifier_release_falling", {duration = 1})
				ability.target.possessionFallSpeed = 3
			end
		end
		ability.TargetToAddToTable = ability.target
		EndAnimation(caster)
		caster:RemoveModifierByName("modifier_possession_moving_toward_target")
		EmitSoundOn("Slipfinn.Possess.EnemyStart", ability.target)
		event.guarantee = true
		event.ability = caster:FindAbilityByName("slipfinn_jump")
		if event.ability then
			EndAnimation(caster)
			Timers:CreateTimer(0.03, function()
				slipfinn_jump_start(event)
			end)
		end
		local pfx = ParticleManager:CreateParticle("particles/roshpit/slipfinn/possession_start_choslam_start.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl(pfx, 0,ability.target:GetAbsOrigin()+Vector(0,0,50))
		ParticleManager:SetParticleControl(pfx, 1,Vector(150, 2, 150))
		Timers:CreateTimer(2.5, function()
			ParticleManager:DestroyParticle(pfx, false)
			ParticleManager:ReleaseParticleIndex(pfx)
		end)
		if ability.r_2_level > 0 then
			local stun_duration = SLIPFINN_R2_STUN_DURATION*ability.r_2_level
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), ability.lockedTarget:GetAbsOrigin(), nil, 440, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			if #enemies > 0 then
				for _,enemy in pairs(enemies) do
					Filters:ApplyStun(caster, stun_duration, enemy)
				end
			end
		end
		ability.target:RemoveModifierByName("modifier_bubble_possess_6_1_glyph")
		if ability.TargetToAddToTable then
			if WallPhysics:DoesTableHaveValue(caster.possessedTable, ability.TargetToAddToTable:GetUnitName()) then
			else
				table.insert(caster.possessedTable, ability.TargetToAddToTable:GetUnitName())
			end
		end
	end
	ability.moveInterval = ability.moveInterval + 1
	if ability.moveInterval == 13 then
		ability.moveInterval = 0
		StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_SLARK_POUNCE, rate=2})
	end

end

function enemy_lock_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local liftVector = Vector(0,0,0)

	local floatHeight = target:GetBoundingMaxs().z + 120
	if ability.enemyMovementPhase >= 0 then
		liftVector = Vector(0,0,10)
		ability.enemyMovementPhase = ability.enemyMovementPhase + 1
		target:SetAbsOrigin(caster:GetAbsOrigin()+liftVector*ability.enemyMovementPhase)
	else
		liftVector = Vector(0,0,floatHeight)
		target:SetAbsOrigin(caster:GetAbsOrigin()+liftVector)
	end
	
	if target:GetAbsOrigin().z - caster:GetAbsOrigin().z > floatHeight then
		ability.enemyMovementPhase = -1
	end


end

function release(event)
	local caster = event.caster
	local ability = event.ability
	if ability:GetAbilityName() == "slipfinn_release_possess" then
		ability = caster:FindAbilityByName("slipfinn_bubble_possession")
	end
	caster:RemoveModifierByName("modifier_slipfinn_enemy_locked")
end

function enemy_locked_end(event)
	local caster = event.caster
	local ability = event.ability
	caster:RemoveModifierByName("modifier_possession_attack_power")
	if ability.abilitiesTable then
		local modifiers = caster:FindAllModifiers()
		for i = 1, #ability.abilitiesTable, 1 do
			ability.abilitiesTable[i]:SetHidden(true)
			ability.abilitiesTable[i]:SetActivated(false)
			for j = 1, #modifiers, 1 do
				local modifier = modifiers[j]
				if modifier:GetRemainingTime() < 5 then
					if modifier:GetAbility() == ability.abilitiesTable[i] then
						caster:RemoveModifierByName(modifier:GetName())
					end
				end
			end	
		end

		local abilitiesToRemove = ability.abilitiesTable
		ability.abilitiesTable = nil
		for i = 1, #abilitiesToRemove, 1 do
			caster:RemoveAbility(abilitiesToRemove[i]:GetName())
		end
	end
	if ability.lockedTarget then
		if IsValidEntity(ability.lockedTarget) then
			if ability.lockedTarget:IsAlive() then
				if ability.r_2_level > 0 then
					local stun_duration = SLIPFINN_R2_STUN_DURATION*ability.r_2_level
					if caster:HasModifier("modifier_slipfinn_glyph_6_1") then
						stun_duration = stun_duration*SLIPFINN_GLYPH_6_1_STUN_MULT
					end
					Filters:ApplyStun(caster, stun_duration, ability.lockedTarget)
				end
				ability.fallFromHeight = ability.lockedTarget:GetAbsOrigin().z
				EmitSoundOn("Slipfinn.Possess.EnemyEnd", ability.lockedTarget)
				ability.lockedTarget:RemoveModifierByName("modifier_possession_enemy_lock")
				ability.lockedTarget:RemoveModifierByName("slipfinn_possessed_lua")
				CustomAbilities:AddAndOrSwapSkill(caster, "slipfinn_release_possess", "slipfinn_bubble_possession", DOTA_ULTIMATE_SLOT)
				ability:ApplyDataDrivenModifier(caster, ability.lockedTarget, "modifier_release_falling", {duration = 1})
				ability.lockedTarget.possessionFallSpeed = 3

				local pfx = ParticleManager:CreateParticle("particles/roshpit/slipfinn/possession_release_choslam_start.vpcf", PATTACH_CUSTOMORIGIN, nil )
				ParticleManager:SetParticleControl(pfx, 0,ability.lockedTarget:GetAbsOrigin()+Vector(0,0,50))
				ParticleManager:SetParticleControl(pfx, 1,Vector(150, 2, 150))
				Timers:CreateTimer(2.5, function()
					ParticleManager:DestroyParticle(pfx, false)
					ParticleManager:ReleaseParticleIndex(pfx)
				end)
			end
		else
			CustomAbilities:AddAndOrSwapSkill(caster, "slipfinn_release_possess", "slipfinn_bubble_possession", DOTA_ULTIMATE_SLOT)
		end
		ability.lockedTarget = nil
	end

end

function collect_abilities(caster, ability, target)
	local abilitiesTable = {}
	print(target:GetAbilityCount())
	for i = 0, 12, 1 do
		local abilityCheck = target:GetAbilityByIndex(i)
		if abilityCheck then
			if abilityCheck:IsHidden() then
			else
				table.insert(abilitiesTable, abilityCheck)
			end
		end
	end
	local slarkAbilitiesTable = {}
	for i = 1, #abilitiesTable, 1 do
		local level = abilitiesTable[i]:GetLevel()
		if caster:HasAbility(abilitiesTable[i]:GetAbilityName()) then
			UTIL_Remove(caster:FindAbilityByName(abilitiesTable[i]:GetAbilityName()))
		end
		local newAbil = caster:AddAbility(abilitiesTable[i]:GetAbilityName())
		newAbil:SetAbilityIndex(DOTA_ULTIMATE_SLOT+i)
		newAbil.possessionAbility = true
		newAbil:SetLevel(level)
		table.insert(slarkAbilitiesTable, newAbil)
	end
	ability.abilitiesTable = slarkAbilitiesTable
end

function release_falling_think(event)
	local target = event.target
	local ability = event.ability
	if target.possessionFallSpeed == 3 then
		target:SetAbsOrigin(Vector(target:GetAbsOrigin().x, target:GetAbsOrigin().y, ability.fallFromHeight))
	else
		target:SetAbsOrigin(target:GetAbsOrigin()-Vector(0,0,target.possessionFallSpeed))
	end
	target.possessionFallSpeed = target.possessionFallSpeed + 1
	print(target:GetAbsOrigin().z - GetGroundHeight(target:GetAbsOrigin(), target))
	if target:GetAbsOrigin().z - GetGroundHeight(target:GetAbsOrigin(), target) < target.possessionFallSpeed then
		print("LAND")
		target:RemoveModifierByName("modifier_release_falling")
	end
end

function release_fall_end(event)
	local target = event.target
	FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
	local pfx = ParticleManager:CreateParticle( "particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControl( pfx, 0, target:GetAbsOrigin() )
	ParticleManager:SetParticleControl( pfx, 1, Vector(200, 200, 200) )
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	if target.aggroSound then
		EmitSoundOn(target.aggroSound, target)
	end
end

function spell_precast(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.unit
	local executedAbility = event.event_ability
	if executedAbility.possessionAbility then
		local animationDuration = executedAbility:GetCastPoint() - 0.03
		StartAnimation(caster, {duration=animationDuration, activity=ACT_DOTA_SPAWN, rate=1.5})
	end
end

function spell_cast(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.unit
	local executedAbility = event.event_ability
	if executedAbility.possessionAbility then
		StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_CAST_ABILITY_1, rate=1.2})
	end
end

function enemy_6_1_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	if caster:GetAbsOrigin().z > target:GetAbsOrigin().z then
		target:SetAbsOrigin(target:GetAbsOrigin() + Vector(0,0,4))
	end
end

function enemy_6_1_start(event)
	local target = event.target
	local caster = event.caster
	EmitSoundOn("Slipfinn.Glyph61", target)
	local pfx = ParticleManager:CreateParticle("particles/roshpit/slipfinn/glyph_6_1_link_electric_vortex.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt( pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
	ParticleManager:SetParticleControlEnt( pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
	target.slipfinn_6_1_link_pfx = pfx
end

function enemy_6_1_end(event)
	local target = event.target
	local caster = event.caster
	if target.pushLock or target.jumpLock or target.dummy then
		return false
	end
	if target.slipfinn_6_1_link_pfx then
		ParticleManager:DestroyParticle(target.slipfinn_6_1_link_pfx, false)
		ParticleManager:ReleaseParticleIndex(target.slipfinn_6_1_link_pfx)
		target.slipfinn_6_1_link_pfx = false
	end
end