LinkLuaModifier("modifier_space_shark_size", "modifiers/neutrals/modifier_space_shark_size", LUA_MODIFIER_MOTION_NONE)

function gang_up_think(event)
	local caster = event.caster
	local ability = event.ability
	local radius = 650
	local allies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false )	
	local stacks = 0
	for i = 1, #allies, 1 do
		local ally = allies[i]
		if ally:HasAbility(ability:GetAbilityName()) then
			stacks = stacks + 1
		end
	end
	if stacks > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_gangup_stack", {})
		caster:SetModifierStackCount("modifier_gangup_stack", caster, stacks)
	else
		caster:RemoveModifierByName("modifier_gangup_stack")
	end
end

function damage_sap_attack(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	caster:ApplyAndIncrementStack(ability, caster, "modifier_damage_sap_stack_owner", 1, 0, 8)
	target:ApplyAndIncrementStack(ability, caster, "modifier_damage_sap_stack_enemy", 1, 0, 8)	
end

function relict_jump_pre_start(event)
	local caster = event.caster

	local distance = WallPhysics:GetDistance2d(event.target_points[1], caster:GetAbsOrigin())
	if caster:GetUnitName() == "winterblight_relict" then
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.Relict.Jump", caster)
		EndAnimation(caster)
		StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_3_END, rate=1})
	elseif caster:GetUnitName() == "winterblight_skull_hunter" then
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.SkullHunter.Pain", caster)
		EndAnimation(caster)
		StartAnimation(caster, {duration=1, activity=ACT_DOTA_TELEPORT_END, rate=1})
	else
		EndAnimation(caster)
		StartAnimation(caster, {duration=1, activity=ACT_DOTA_TELEPORT_END, rate=1})
	end
	CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_monkey_king/monkey_king_spring_channel_rings.vpcf", caster:GetAbsOrigin()+Vector(0,0,20), 0.6)
	-- StartAnimation(caster, {duration=0.44, activity=ACT_DOTA_MK_SPRING_CAST, rate=1.2})
end

function relict_monkey_jump_start(event)
	local caster = event.caster
	local ability = event.ability
	ability.targetPoint = event.target_points[1] + caster:GetForwardVector()*240
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
end

function relict_jump_think(event)
	local caster = event.caster
	local ability = event.ability

	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.targetPoint)

	local fv = ability.jumpFV
	-- if distance < 60 then
	-- 	fv = Vector(0,0)
	-- end
	local height = (caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster))
	if height < math.abs(ability.liftVelocity) then
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
	if blockUnit then
	else
		caster:SetAbsOrigin(caster:GetAbsOrigin() + fv*ability.jumpVelocity + Vector(0,0,ability.liftVelocity))
	end
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

function relict_jump_end(event)
	local caster = event.caster
	local ability = event.ability
	EndAnimation(caster)
	CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_monkey_king/monkey_king_spring_channel_rings.vpcf", caster:GetAbsOrigin()+Vector(0,0,20), 0.6)
	Timers:CreateTimer(0.03, function()
		StartAnimation(caster, {duration=1, activity=ACT_DOTA_TELEPORT_END, rate=1})
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
	end)
end

function aoe_ice_vortex_cast(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Winterblight.IceVortexAoe", caster)
	local particleName = "particles/units/heroes/hero_ancient_apparition/ancient_ice_vortex.vpcf"
	local duration = event.duration
	local radius = 300
	StartAnimation(caster, {duration=0.6, activity=ACT_DOTA_RAZE_2, rate=1})
	for i = 1, 3, 1 do
		local position = caster:GetAbsOrigin()+RandomVector(RandomInt(100, 1000))
		local modifierName = "aoe_ice_vortex_thinker"
		position = GetGroundPosition(position, caster) + Vector(0,0,20)
		local pfx = CustomAbilities:QuickParticleAtPoint(particleName, position, duration)
		ParticleManager:SetParticleControl(pfx, 5, Vector(radius*2, radius, radius))
		CustomAbilities:QuickAttachThinker(ability, caster, position, modifierName, {duration = duration})
	end
end

function rock_guardian_attack_start(event)
	local caster = event.caster
	StartAnimation(caster, {duration=1, activity=ACT_DOTA_CUSTOM_TOWER_ATTACK, rate=1.7})
	EmitSoundOn("Winterblight.StoneGuardian.Attack", caster)
end

function rock_guardian_attack_land(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	if not ability then
		return false
	end
	EmitSoundOn("Winterblight.StoneGuardian.AttackLand", target)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_winterblight_rock_tower_stack", {duratio = 5})
	target:ApplyAndIncrementStack(ability, nil, "modifier_winterblight_rock_tower_stack", 1, 5, 5)

	if target:GetModifierStackCount("modifier_winterblight_rock_tower_stack", nil) >= event.stacks then
		target:RemoveModifierByName("modifier_winterblight_rock_tower_stack")
		ability.pushVector = false
		ability.pushVelocity = 30
		ability.tossPosition = caster:GetAbsOrigin()
		ability:ApplyDataDrivenModifier(caster, target, "modifier_heavy_boulder_pushback", {duration = 0.6})
	end
end

function rock_guardian_die(event)
	local caster = event.caster
	EndAnimation(caster)
	Timers:CreateTimer(0.09, function()
		StartAnimation(caster, {duration=8, activity=ACT_DOTA_CUSTOM_TOWER_DIE, rate=1})
		EmitSoundOn("Winterblight.StoneGuardian.Die", caster)
	end)
	CustomAbilities:QuickParticleAtPoint("particles/radiant_fx/tower_good3_destroy_lvl3.vpcf", caster:GetAbsOrigin(), 3)
	caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,300))
	caster:AddNoDraw()
	Winterblight.StoneGuardiansSlain = Winterblight.StoneGuardiansSlain + 1
	if Winterblight.StoneGuardiansSlain == 3 and Winterblight.OutsideCaveSequence == 0 then
		Winterblight:SpawnMerkurio(Vector(-7252, 4283), Vector(0,-1))
	end
end

function rock_guardian_rising_think(event)
	local caster = event.caster
	local ability = event.ability
	if not ability.interval then
		ability.interval = 0
	end
	ability.interval = ability.interval + 1
	if ability.interval%4 == 0 then
		local groundPos = GetGroundPosition(caster:GetAbsOrigin(), caster)
		local pfx2 = ParticleManager:CreateParticle( "particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
		ParticleManager:SetParticleControl( pfx2, 0, groundPos+Vector(0,0,60))
		ParticleManager:SetParticleControl( pfx2, 1, Vector(200, 200, 200) )
		Timers:CreateTimer(2, function()
			ParticleManager:DestroyParticle(pfx2, false)
			ParticleManager:ReleaseParticleIndex(pfx2)
		end)
	end
	if ability.interval%15 == 0 then
		EmitSoundOn("Winterblight.StoneGuardian.Rising", caster)
	end
	caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,2.2))

end

function winter_heavy_boulder_pushback(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if not ability then
		return false
	end
	if not ability.pushVector then
		local impactPoint = target:GetAbsOrigin()
		local pushVector = ((impactPoint - ability.tossPosition)*Vector(1,1,0)):Normalized()
		ability.pushVector = pushVector
		EmitSoundOn("Winterblight.StoneAttack", target)
	end
	local obstruction = WallPhysics:FindNearestObstruction(target:GetAbsOrigin()+ability.pushVector*30)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, target:GetAbsOrigin()+ability.pushVector*30, target)
	local fv = ability.pushVector

	if blockUnit then
		fv = 0
	end
	target:SetAbsOrigin(target:GetAbsOrigin() + fv*ability.pushVelocity)
	ability.pushVelocity = math.max(ability.pushVelocity - 1, 0)
end

function merkurio_attack_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	StartAnimation(caster, {duration=1, activity=ACT_DOTA_ATTACK, rate=1, translate="attack_normal_range"})
end

function winter_heavy_boulder_push_end(event)
	local caster = event.target
	caster.pushVector = false
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
end

function merkurio_think(event)
	local caster = event.caster
	local ability = event.ability
	local boundless = caster:FindAbilityByName("monkey_king_boundless_strike")
	boundless:EndCooldown()
	caster:AddNewModifier(caster, nil, "modifier_animation_translate", {translate="walk"})
	if caster.state == 0 and caster:GetHealth() < 1000 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_disable_player", {duration = 5.1})
		StartAnimation(caster, {duration=5.1, activity=ACT_DOTA_MK_SPRING_CAST, rate=0.33})
		caster.state = 1
		EmitSoundOn("Winterblight.Merkurio.State2", caster)
		Timers:CreateTimer(1, function()
			Winterblight:SpawnStoneGuardian(Vector(-7680, 4608), Vector(0,-1))
			Winterblight:SpawnStoneGuardian(Vector(-7415, 4985), Vector(0,-1))
			Winterblight:SpawnStoneGuardian(Vector(-6985, 4928), Vector(0,-1))
			Winterblight.StoneGuardiansSlain = 0
			Winterblight.OutsideCaveSequence = 1
		end)
		Timers:CreateTimer(5.1, function()
			caster.state = 2
			EmitSoundOn("Winterblight.Merkurio.State3", caster)
		end)
		EmitSoundOn("Winterblight.Merkurio.Gust", caster)
		for i = 1, 5, 1 do
			local fv = WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi*i/5)
			local pfx = CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_drow/drow_silence_wave.vpcf", caster:GetAbsOrigin(), 4)
			ParticleManager:SetParticleControl(pfx, 1, fv*1000)
			ParticleManager:SetParticleControl(pfx, 3, caster:GetAbsOrigin()+fv*1000)
		end
	elseif caster.state == 1 then
		caster:SetHealth(caster:GetHealth() + caster:GetMaxHealth()*0.1)
	elseif caster.state == 2 and caster:GetHealth() < 1000 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_disable_player", {duration = 5.1})
		StartAnimation(caster, {duration=5.1, activity=ACT_DOTA_MK_SPRING_CAST, rate=0.33})
		caster.state = 1
		EmitSoundOn("Winterblight.Merkurio.Aggro", caster)

		Timers:CreateTimer(1, function()
			local positionTable = {Vector(-7680, 3686), Vector(-7680, 4224), Vector(-7313, 4586), Vector(-6912, 4736), Vector(-6651, 4352)}
			positionTable = WallPhysics:ShuffleTable(positionTable)
			for i = 1, #positionTable, 1 do
				Timers:CreateTimer(i*0.3, function()
					local direction = (Vector(-6839, 3925) - positionTable[i]):Normalized()
					Winterblight:SpawnStoneGuardian(positionTable[i], direction)
				end)
			end
			Winterblight.StoneGuardiansSlain = 0
			Winterblight.OutsideCaveSequence = 2
			Timers:CreateTimer(2, function()
				EmitSoundOn("Winterblight.Merkurio.State5", caster)
				local positionTable = {Vector(-8192, 3200), Vector(-8192,3584), Vector(-8192, 3968), Vector(-6784, 5376), Vector(-6400, 5376)}
				positionTable = WallPhysics:ShuffleTable(positionTable)
				for i = 1, #positionTable, 1 do
					Timers:CreateTimer(i*0.3, function()
						local direction = (Vector(-6839, 3925) - positionTable[i]):Normalized()
						local monkey = Winterblight:SpawnRelict(positionTable[i], direction)
						Dungeons:AggroUnit(monkey)
						local eventTable = {}
						eventTable.caster = monkey
						eventTable.ability = monkey:FindAbilityByName("relict_monkey_leap")
						eventTable.target_points = {}
						eventTable.target_points[1] = Vector(-6839, 3925) + RandomVector(240)
						relict_monkey_jump_start(eventTable)
					end)
				end
			end)
		end)
		Timers:CreateTimer(5.1, function()
			caster.state = 3
			EmitSoundOn("Winterblight.Merkurio.State3", caster)
		end)
	elseif caster.state == 3 and caster:GetHealth() < 1000 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_disable_player", {})
		EmitSoundOn("Winterblight.Merkurio.State6", caster)
		StartAnimation(caster, {duration=3, activity=ACT_DOTA_DISABLED, rate=1})
		caster.state = 1
		EmitSoundOn("Winterblight.Merkurio.Gust", caster)
		for i = 1, 5, 1 do
			local fv = WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi*i/5)
			local pfx = CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_drow/drow_silence_wave.vpcf", caster:GetAbsOrigin(), 4)
			ParticleManager:SetParticleControl(pfx, 1, fv*1000)
			ParticleManager:SetParticleControl(pfx, 3, caster:GetAbsOrigin()+fv*1000)
		end
		Timers:CreateTimer(3, function()
			caster.state = 4
		end)
	elseif caster.state == 4 then
		caster:MoveToPosition(Vector(-7506, 5504))
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), Vector(-7506, 5504))
		if distance < 120 then
			caster.state = 5
		end
	elseif caster.state == 5 then
		caster.state = 6
		local rocks = Entities:FindAllByNameWithin("OutsideCaveRocks", Vector(-7620, 5992, 145+Winterblight.ZFLOAT), 2400)
		for i = 1, 6, 1 do
			Timers:CreateTimer(i, function()
				StartAnimation(caster, {duration=0.9, activity=ACT_DOTA_ATTACK, rate=1, translate="attack_normal_range"})
				Timers:CreateTimer(0.4, function()
					EmitSoundOn("Winterblight.Merkurio.AttackRock", caster)
					if i < 6 then
						for i = 1, #rocks, 1 do
							Events:objectShake(rocks[i], 4, 8, true, true, true, nil, 1)
						end
					end
				end)
			end)
		end
		Timers:CreateTimer(6.4, function()
			local rocks = Entities:FindAllByNameWithin("OutsideCaveRocks", Vector(-7620, 5992, 145+Winterblight.ZFLOAT), 2400)
			for i = 1, #rocks, 1 do
				UTIL_Remove(rocks[i])
			end
		    Winterblight:RemoveBlockers(0.1, "AzaleaCaveMainBlocker", Vector(-7620, 5992, 300+Winterblight.ZFLOAT), 2800)
		    local explosionPosTable = {Vector(-7808, 5601, 239+Winterblight.ZFLOAT), Vector(-7711, 5837, 239+Winterblight.ZFLOAT), Vector(-7594, 6057, 239+Winterblight.ZFLOAT)}
		    for i = 1, #explosionPosTable, 1 do
				CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/rock_statue_destroy_acks_melee002_destroy_lvl3.vpcf", explosionPosTable[i], 3)
				EmitSoundOnLocationWithCaster(explosionPosTable[i], "Winterblight.StoneGuardian.Die", caster)
			end
		    caster.state = 7
		    Timers:CreateTimer(0.5, function()
		    	EmitSoundOnLocationWithCaster(Vector(-7711, 5837), "Winterblight.CaveIntro", caster)
		    end)
		end)
	elseif caster.state == 7 then
		caster:MoveToPosition(Vector(-4905, 7595))
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), Vector(-4905, 7595))
		AddFOWViewer(DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), 500, 2, false)
		if distance < 120 then
			caster.state = 8
		end
	elseif caster.state == 8 then
		caster:MoveToPosition(Vector(-5082, 7595))
		caster.state = 9
		Winterblight.CaveGuideReady = true
		caster.moveAdjust = true
	elseif caster.state == 9 then
		if Winterblight.CavernData and Winterblight.CavernData.Chambers[1] and Winterblight.CavernData.Chambers[1]["event"] == 4 and Winterblight.CavernData.Chambers[1]["status"] == 1 then
			Winterblight:MerkurioEventThink(caster)
		else
			caster.event_phase = nil
			caster.summon_phase = nil
			local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), Vector(-5082, 7595))
			if distance > 300 then
				caster.state = 8
			elseif caster.moveAdjust then
				caster.moveAdjust = false
				caster:MoveToPosition(caster:GetAbsOrigin()+Vector(-1,0))
			end
		end
	end
	if not caster:HasModifier("modifier_disable_player") then
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), Vector(-7252, 4283))
		if distance > 800 then
			local jump_ability = caster:FindAbilityByName("draghor_monkey_leap")
			if jump_ability:GetLevel() < 4 then
				jump_ability:SetLevel(4)
			end
			jump_ability:EndCooldown()
			if jump_ability:IsFullyCastable() then
				local targetPoint = Vector(-7252, 4283) + RandomVector(RandomInt(20, 120))			
				local order =
				{
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = jump_ability:entindex(),
					Position = targetPoint
				}
				ExecuteOrderFromTable(order)
				Timers:CreateTimer(1.2, function()
					caster:AddNewModifier(caster, nil, "modifier_animation_translate", {translate="walk"})
					Dungeons:DeaggroUnit(caster)
					caster:Stop()
				end)
				caster:AddNewModifier(caster, nil, "modifier_animation_translate", {translate="walk"})
				local luck = RandomInt(1, 2)
				if luck < 3 then
					if not caster.soundLock then
						EmitSoundOn("Winterblight.Merkurio.JumpBack", caster)
						caster.soundLock = true
						Timers:CreateTimer(2, function()
							caster.soundLock = false
						end)
					end
				end
				return false
			end
		end
	end
end

function guide_entering_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.fallSpeed then
		caster.fallSpeed = 18
	end
	caster.fallSpeed = math.max(caster.fallSpeed - 0.08, 3)
	caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,caster.fallSpeed))
	local heightDistance = caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster)
	if heightDistance < 5 then
		if not caster.sequence then
			caster.sequence = true
			CustomAbilities:QuickParticleAtPoint("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_spawn.vpcf", caster:GetAbsOrigin(), 4)
			CustomAbilities:QuickAttachParticle("particles/econ/events/ti9/shovel/shovel_baby_roshan_spawn.vpcf", caster, 4)
			caster:RemoveModifierByName("modifier_guide_entering")
			EmitSoundOn("Winterblight.GuideCaveIntro", caster)
			
			Timers:CreateTimer(1.5, function()
				StartAnimation(caster, {duration=2, activity=ACT_DOTA_CAST_ABILITY_1, rate=1.0})
				EmitSoundOn("Winterblight.CaveGuide.Welcome", caster)
			end)
			Timers:CreateTimer(2.5, function()
				EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.GuideCaveIntro2", Events.GameMaster)
				CustomAbilities:QuickAttachParticle("particles/econ/events/ti9/shovel/shovel_baby_roshan_spawn.vpcf", caster, 4)
			end)
		end
	end
end

function winter_stampede_start(event)
	local caster = event.caster
	local ability = event.ability
	local allies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false )	
	for i = 1, #allies, 1 do
		local ally = allies[i]
		ability:ApplyDataDrivenModifier(caster, ally, "modifier_winter_centaur_stampede", {duration = event.duration})
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_spirit_breaker/spirit_breaker_haste_owner.vpcf", ally, 1)
	end
end

function winter_cavern_unit_think(event)
	local target = event.target
	if target.chamber == 0 then
		return false
	else
		if Winterblight:IsWithinChamber(target, target.chamber) then
		else
			EmitSoundOn("Winterblight.Cavern.PopBack", target)
			CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_lone_druid/lone_druid_loadout.vpcf", target:GetAbsOrigin(), 3)
			FindClearSpaceForUnit(target, target.original_position, false)
			if target.deaggro then
				Dungeons:DeaggroUnit(target)
			end
		end
	end
end

function winter_cavern_hero_die(event)
	local hero = event.unit
	for i = 1, #Winterblight.CavernData.Chambers, 1 do
		if Winterblight.CavernData.Chambers[i]["hero"] == hero:GetEntityIndex() then
			Winterblight:ResetChamber(hero, i)
		end
	end
end

function spirit_warp_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	target = WallPhysics:WallSearch(caster:GetAbsOrigin(), target, caster)
	local invisible_duration = 3
	ability.fv = ((target - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	ability.targetPoint = target
	local warpDuration = 3.0
	ability.fallVelocity = 1
	ability.forwardVelocity = 22
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_spirit_warp_flying", {duration = warpDuration})
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, true)
		ability.pfx = false
	end
	caster:RemoveModifierByName("modifier_end_spirit_warp_falling")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_spirit_warp_invisible", {duration = invisible_duration})

    EmitSoundOn("Winterblight.Cavern.ManaNull.Float", caster)
    local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/winterblight/mana_null_flare.vpcf", caster, 1)
    ability.pfx = ParticleManager:CreateParticle("particles/roshpit/winterblight/float_particle_.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt(ability.pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(ability.pfx, 15, Vector(100, 220, 100))
    Filters:CastSkillArguments(3, caster)
end

function spirit_warping_think(event)
	local caster = event.caster
	local ability = event.ability

	ability.forwardVelocity = ability.forwardVelocity + 0.5

	local blockSearch = caster:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,GetGroundHeight(caster:GetAbsOrigin(), caster))
    local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch+ability.fv*45), caster)
    local forwardSpeed = ability.forwardVelocity
	if blockUnit then
		forwardSpeed = 0
	end
	
	caster:SetAbsOrigin(caster:GetAbsOrigin() + ability.fv*forwardSpeed + Vector(0,0,3))
	local distance = WallPhysics:GetDistance2d(ability.targetPoint, caster:GetAbsOrigin())
	if distance < 100 then
		caster:RemoveModifierByName("modifier_spirit_warp_flying")
		caster:RemoveModifierByName("modifier_spirit_warp_invisible")
		if ability.pfx then
			ParticleManager:DestroyParticle(ability.pfx, false)
			ability.pfx = false
		end
	end
end

function mana_null_after_warp_falling(event)
	local caster = event.caster
	local ability = event.ability
	caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,ability.fallVelocity))
	ability.fallVelocity = ability.fallVelocity + 2
	local groundHeight = GetGroundHeight(caster:GetAbsOrigin(), caster)
	if caster:GetAbsOrigin().z - groundHeight < ability.fallVelocity/2 then
		caster:RemoveModifierByName("modifier_end_spirit_warp_falling")
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_SPAWN, rate=1})
	end
end

function mana_null_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local mana_burn = (event.mana_drain_percent/100)*target:GetMana()
	EmitSoundOn("Winterblight.Cavern.ManaNull.Atk", target)
	ability.particleLock = false
	if not ability.particleLock then
		ability.particleLock = true
		local particleName = "particles/units/heroes/hero_leshrac/leshrac_lightning_impact.vpcf"
		local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
		ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_CUSTOMORIGIN, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(pfx, 1, target:GetAbsOrigin())
		Timers:CreateTimer(0.5, function() 
		  ParticleManager:DestroyParticle( pfx, false )
		  ability.particleLock = false
		end) 	
	end
	local burnDamage = math.min(target:GetMana(), mana_burn)*10
	target:ReduceMana(mana_burn)
	ApplyDamage({ victim = target, attacker = caster, damage = burnDamage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })
end

function blood_might_think(event)
	local caster = event.caster
	local ability = event.ability
	local radius = event.radius
    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
    if #enemies > 0 then    
    	local highest_full_health_pct = 0
    	local total_missing_health = 0
        for _,enemy in pairs(enemies) do
        	local full_health_pct = (enemy:GetHealth()/enemy:GetMaxHealth())*100
        	highest_full_health_pct = math.max(full_health_pct, highest_full_health_pct)
        	total_missing_health = total_missing_health + (enemy:GetMaxHealth() - enemy:GetHealth())
        end
        if total_missing_health > 0 then
        	ability:ApplyDataDrivenModifier(caster, caster, "modifier_bloodmight_attack_dmg", {})
        	caster:SetModifierStackCount("modifier_bloodmight_attack_dmg", caster, total_missing_health)
        else
        	caster:RemoveModifierByName("modifier_bloodmight_attack_dmg")
        end
        if highest_full_health_pct > 0 then
        	ability:ApplyDataDrivenModifier(caster, caster, "modifier_blood_might_health_pct_bonus", {})
        	caster:SetModifierStackCount("modifier_blood_might_health_pct_bonus", caster, highest_full_health_pct)
        else
        	caster:RemoveModifierByName("modifier_blood_might_health_pct_bonus")
        end
    else
    	caster:RemoveModifierByName("modifier_blood_might_health_pct_bonus")
    	caster:RemoveModifierByName("modifier_bloodmight_attack_dmg")
    end
end

function curse_of_belial_start(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, target, "modifier_curse_of_belial", {duration = event.duration})
	EmitSoundOn("Winterblight.Cavern.CurseOfBelial", target)
	local damage_reduction_pct = event.base_attack_damage_reduction
	local damage_redcution = target:GetAttackDamage()*(damage_reduction_pct/100)
	ability:ApplyDataDrivenModifier(caster, target, "curse_of_belial_attack_damage_reduce", {duration = event.duration})
end

function curse_of_belial_cast(event)
	local caster = event.unit
	local pct_health_loss = event.pct_damage_on_spell_cast/100
	local beginningHealth = caster:GetHealth()
	local newHealth = math.max(caster:GetHealth() - caster:GetMaxHealth() * pct_health_loss, 1)
	caster:SetHealth(newHealth)
	CustomAbilities:QuickAttachParticle("particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodbath_eztzhok_ember.vpcf", caster, 0.7)
end

function cavern_unit_die(event)
	local unit = event.unit
	local chamber = unit.chamber
	if chamber > 0 then
		Winterblight.CavernData.Chambers[chamber]["progress"] = Winterblight.CavernData.Chambers[chamber]["progress"] + 1
		CustomGameEventManager:Send_ServerToAllClients("cavern_summary_update", {chamber_data = Winterblight.CavernData.Chambers, chamber = chamber})
		if Winterblight.CavernData.Chambers[chamber]["progress"] >= Winterblight.CavernData.Chambers[chamber]["goal"] then
			local position = unit:GetAbsOrigin()
			Winterblight:CompleteChamberEvent(chamber, position)
		end
		if chamber == 1 and Winterblight.CavernData.Chambers[chamber]["event"] == 3 then
			Winterblight.Foyer3Kills = Winterblight.Foyer3Kills + 1
			Winterblight:Foyer3WaveRedirect(Winterblight.Foyer3Kills)
		elseif chamber == 3 and Winterblight.CavernData.Chambers[chamber]["event"] == 2 then
			Winterblight.Crystarium2Kills = Winterblight.Crystarium2Kills + 1
			Winterblight:Crystarium2WaveRedirect(Winterblight.Crystarium2Kills)
		elseif chamber == 3 and Winterblight.CavernData.Chambers[chamber]["event"] == 4 then
			Winterblight:SpawnNextOceanOnslaughtUnit(unit.spawnphase)
		elseif chamber == 2 and Winterblight.CavernData.Chambers[chamber]["event"] == 2 then
			Winterblight.AuroraPassage2Kills = Winterblight.AuroraPassage2Kills + 1
			Winterblight:AuroraPassage2WaveRedirect(Winterblight.AuroraPassage2Kills)
		elseif chamber == 4 and Winterblight.CavernData.Chambers[chamber]["event"] == 2 then
			Winterblight.EdgeOfWinter2Kills = Winterblight.EdgeOfWinter2Kills + 1
			Winterblight:EdgeOfWinter2WaveRedirect(Winterblight.EdgeOfWinter2Kills)
		elseif chamber == 4 and Winterblight.CavernData.Chambers[chamber]["event"] == 3 then
			Winterblight:SpawnNextChrolonus(unit.spawnphase)
		elseif chamber == 4 and Winterblight.CavernData.Chambers[chamber]["event"] == 4 then
			Winterblight.BlackHolesKills = Winterblight.BlackHolesKills + 1
			Winterblight:GravityBlackHolesSpawns(Winterblight.BlackHolesKills)
		end
	end
end

function ultra_ice_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster:IsAlive() then
		return false
	end
    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
    if #enemies > 0 then    
    	EmitSoundOn("Winterblight.Cavern.UltraIce.PassiveThink", caster)
        for _,enemy in pairs(enemies) do
			local info =
			{
				Target = enemy,
				Source = caster,
				Ability = ability,
				EffectName = "particles/roshpit/winterblight/torturok_projectile_base_attack.vpcf",
				StartPosition = "attach_hitloc",
				bDrawsOnMinimap = false,
				bDodgeable = true,
				bIsAttack = false,
				bVisibleToEnemies = true,
				bReplaceExisting = false,
				flExpireTime = GameRules:GetGameTime() + 5,
				bProvidesVision = false,
				iVisionRadius = 0,
				iMoveSpeed = 600,
				iVisionTeamNumber = caster:GetTeamNumber()
			}
			local projectile = ProjectileManager:CreateTrackingProjectile(info)
		end
	end
	if not caster.spawnPhase then
		if caster:GetHealth() < 1000 then
			caster.spawnPhase = 0
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_disable_player", {})
			EmitSoundOn("Winterblight.Cavern.UltraIce.PhaseChange", caster)
			Timers:CreateTimer(1.5, function()
				local targetPoint = caster:GetAbsOrigin()*Vector(1,1,0) + Vector(0, 0, 700+Winterblight.ZFLOAT)
				caster.movementVector = (targetPoint - caster:GetAbsOrigin())/60
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_ultra_ice_quick_think", {})
				Events:smoothSizeChange(caster, caster:GetModelScale(), 1.0, 60)
			end)
		end
	end
	if caster.spawnPhase == 0 then
	elseif caster.spawnPhase == 1 then
		caster.spawnPhase = 2
		for k = 1, 2*caster.spawnMult, 1 do
			local luck1 = RandomInt(1, 4)
			Timers:CreateTimer((k-1)*1.5, function()
				if Winterblight.CavernData.Chambers[caster.chamber]["status"] == 1 then
					for i = 1, 4, 1 do
						local spawn = nil
						if luck1 == 1 then
							spawn = Winterblight:SpawnFrostiok(caster:GetAbsOrigin()+RandomVector(RandomInt(50, 1000)), Vector(0,-1))
						elseif luck1 == 2 then
							spawn = Winterblight:SpawnSourceRevenant(caster:GetAbsOrigin()+RandomVector(RandomInt(50, 1000)), Vector(0,-1))
						elseif luck1 == 3 then
							spawn = Winterblight:SpawnDashingSwordsman(caster:GetAbsOrigin()+RandomVector(RandomInt(50, 1000)), Vector(0,-1))
						elseif luck1 == 4 then
							spawn = Winterblight:SpawnFrostAvatar(caster:GetAbsOrigin()+RandomVector(RandomInt(50, 1000)), Vector(0,-1))
						end
						Winterblight:SetCavernUnit(spawn, spawn:GetAbsOrigin(), true, false, caster.chamber)
						Dungeons:AggroUnit(spawn)
						ultra_ice_spawn_effect(caster, spawn)
					end
				end
			end)
		end
	elseif caster.spawnPhase == 3 then
		caster.spawnPhase = 4
		local luck = RandomInt(1, 2)
		for k = 1, 2*caster.spawnMult, 1 do
			Timers:CreateTimer((k-1)*1.5, function()
				if Winterblight.CavernData.Chambers[caster.chamber]["status"] == 1 then
					for i = 1, 4, 1 do
						if luck == 1 then
							local spawn = nil
							if i%2 == 0 then
								spawn = Winterblight:SpawnMountainOgre(caster:GetAbsOrigin()+RandomVector(RandomInt(50, 1000)), Vector(0,-1))
							else
								spawn = Winterblight:Snowshaker(caster:GetAbsOrigin()+RandomVector(RandomInt(50, 1000)), Vector(0,-1))
							end
							Winterblight:SetCavernUnit(spawn, spawn:GetAbsOrigin(), true, false, caster.chamber)
							Dungeons:AggroUnit(spawn)
							ultra_ice_spawn_effect(caster, spawn)
						else
							local spawn = nil
							if i%2 == 0 then
								spawn = Winterblight:SpawnFrostElemental(caster:GetAbsOrigin()+RandomVector(RandomInt(50, 1000)), Vector(0,-1))
							else
								spawn = Winterblight:SpawnFrostHulk(caster:GetAbsOrigin()+RandomVector(RandomInt(50, 1000)), Vector(0,-1))
							end
							Winterblight:SetCavernUnit(spawn, spawn:GetAbsOrigin(), true, false, caster.chamber)
							Dungeons:AggroUnit(spawn)
							ultra_ice_spawn_effect(caster, spawn)
						end
					end
				end
			end)
		end
	elseif caster.spawnPhase == 5 then
		caster.spawnPhase = 6
		for k = 1, 2*caster.spawnMult, 1 do
			Timers:CreateTimer((k-1)*1.2, function()
				if Winterblight.CavernData.Chambers[caster.chamber]["status"] == 1 then
					for i = 1, 8, 1 do
						local spawn = Winterblight:SpawnLivingIce(caster:GetAbsOrigin()+RandomVector(RandomInt(50, 1000)), Vector(0,-1))
						Winterblight:SetCavernUnit(spawn, spawn:GetAbsOrigin(), true, false, caster.chamber)
						Dungeons:AggroUnit(spawn)
						ultra_ice_spawn_effect(caster, spawn)
					end
				end
			end)
		end
	elseif caster.spawnPhase == 7 then
		caster.spawnPhase = 8
		for k = 1, 2*caster.spawnMult, 1 do
			local luck = RandomInt(1, 2)
			Timers:CreateTimer((k-1)*1.5, function()
				if Winterblight.CavernData.Chambers[caster.chamber]["status"] == 1 then
					for i = 1, 3, 1 do
						if luck == 1 then
							local spawn = nil
							if i == 1 then
								spawn = Winterblight:SpawnWinterRunner(caster:GetAbsOrigin()+RandomVector(RandomInt(50, 1000)), Vector(0,-1))
							elseif i == 2 then
								spawn = Winterblight:SpawnManaNull(caster:GetAbsOrigin()+RandomVector(RandomInt(50, 1000)), Vector(0,-1))
							elseif i == 3 then
								spawn = Winterblight:SpawnBloodWraith(caster:GetAbsOrigin()+RandomVector(RandomInt(50, 1000)), Vector(0,-1))
							end
							Winterblight:SetCavernUnit(spawn, spawn:GetAbsOrigin(), true, false, caster.chamber)
							Dungeons:AggroUnit(spawn)
							ultra_ice_spawn_effect(caster, spawn)
						else
							local spawn = nil
							if i == 1 then
								spawn = Winterblight:SpawnDrillDigger(caster:GetAbsOrigin()+RandomVector(RandomInt(50, 1000)), Vector(0,-1))
							elseif i == 2 then
								spawn = Winterblight:SpawnBarbedHusker(caster:GetAbsOrigin()+RandomVector(RandomInt(50, 1000)), Vector(0,-1))
							elseif i == 3 then
								spawn = Winterblight:SpawnPantheonKnight(caster:GetAbsOrigin()+RandomVector(RandomInt(50, 1000)), Vector(0,-1))
							end
							Winterblight:SetCavernUnit(spawn, spawn:GetAbsOrigin(), true, false, caster.chamber)
							Dungeons:AggroUnit(spawn)
							ultra_ice_spawn_effect(caster, spawn)
						end
					end
				end
			end)
		end
	end
end

function ultra_ice_spawn_effect(caster, unit)
	local particleName = "particles/roshpit/winterblight/blue_beam_attack_light_ti_5.vpcf"
	EmitSoundOn("Winterblight.Cavern.UltraIce.Spawn", unit)
    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(pfx,0,caster:GetAbsOrigin()+Vector(0,0,200))   
    ParticleManager:SetParticleControl(pfx,1,unit:GetAbsOrigin()+Vector(0,0,322))
	Timers:CreateTimer(3.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	local ability = caster:FindAbilityByName("winterblight_ultra_ice_passive")
	ability:ApplyDataDrivenModifier(caster, unit, "modifier_ultra_ice_spawned_unit", {})
end

function ultra_ice_projectile_hit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	ApplyDamage({victim = target, attacker = caster, damage = event.damage, damage_type = DAMAGE_TYPE_PURE})
	ability:ApplyDataDrivenModifier(caster, target, "modifier_chilled", {duration = 3})
	EmitSoundOn("Torturok.ProjectileHit", target)

	local icePoint = target:GetAbsOrigin()
	local radius = 240
	EmitSoundOnLocationWithCaster(icePoint, "hero_Crystal.freezingField.explosion", caster)
	local particle = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
	local pfx = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, icePoint)
	ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 2, radius * 2))
	Timers:CreateTimer(2.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), icePoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_chilled", {duration = 3})
			ApplyDamage({victim = victim, attacker = caster, damage = event.damage, damage_type = DAMAGE_TYPE_PURE})
		end
	end
end

function ultra_ice_quick_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.spawnPhase == 0 then
		if not caster.move_ticks then
			caster.move_ticks = 0
		end
		caster:SetAbsOrigin(caster:GetAbsOrigin()+caster.movementVector)
		caster.move_ticks = caster.move_ticks + 1
		if caster.move_ticks >= 60 then
			caster:RemoveModifierByName("modifier_ultra_ice_quick_think")
			caster.spawnPhase = 1
			caster:SetForwardVector(Vector(0,-1))
		end
	elseif caster.spawnPhase == 9 then
		caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,10))
		if caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster) < 20 then
			caster:RemoveModifierByName("modifier_ultra_ice_quick_think")
			caster.spawnPhase = 10
			EmitSoundOn("Winterblight.Cavern.UltraIce.Aggro", caster)
			caster:RemoveModifierByName("modifier_disable_player")
			caster:RemoveModifierByName("modifier_ultra_ice_invulnerable")
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_ultra_ice_enraged", {})
		end
	end
end

function ultra_ice_spawn_unit_die(event)
	local unit = event.unit
	local caster = event.caster
	local ability = event.ability
	if not caster.spawnUnitsSlain then
		caster.spawnUnitsSlain = 0
	end
	caster.spawnUnitsSlain = caster.spawnUnitsSlain + 1
	print(caster.spawnUnitsSlain)
	if caster.spawnPhase == 2 and caster.spawnUnitsSlain == 16 then
		caster.spawnPhase = 3
		caster.spawnUnitsSlain = 0
	elseif caster.spawnPhase == 4 and caster.spawnUnitsSlain == 16 then
		caster.spawnPhase = 5
		caster.spawnUnitsSlain = 0
	elseif caster.spawnPhase == 6 and caster.spawnUnitsSlain == 32 then
		caster.spawnPhase = 7
		caster.spawnUnitsSlain = 0
	elseif caster.spawnPhase == 8 and caster.spawnUnitsSlain == 12 then
		caster.spawnPhase = 9
		EmitSoundOn("Winterblight.Cavern.UltraIce.PhaseChange", caster)
		Events:smoothSizeChange(caster, 1.0, 1.8, 40)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_ultra_ice_quick_think", {})
	end
end

function ultra_ice_die(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Winterblight.Cavern.UltraIce.Death", caster)

	local icePoint = caster:GetAbsOrigin()
	local radius = 800
	EmitSoundOnLocationWithCaster(icePoint, "hero_Crystal.freezingField.explosion", caster)
	local particle = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
	local pfx = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, icePoint)
	ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 2, radius * 2))
	Timers:CreateTimer(2.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), icePoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_chilled", {duration = 6})
			ApplyDamage({victim = victim, attacker = caster, damage = event.damage, damage_type = DAMAGE_TYPE_PURE})
		end
	end
end

function drill_digger_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if caster:GetUnitName() == "drill_digger" then
		EmitSoundOn("DrillDigger.Attacker", target)
	end
	if caster:GetModifierStackCount("modifier_drill_digger_stack", caster) == 3 then
		caster:RemoveModifierByName("modifier_drill_digger_stack")
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, event.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false)
		if #enemies > 0 then
			for i = 1, #enemies, 1 do
				if i <= event.max_quakes then
					drill_digger_quake(caster, ability, enemies[i], event.quake_radius, event.damage_pct_attack_power)
				else
					break
				end
			end
		end
		if caster.counter_pfx then
			ParticleManager:DestroyParticle(caster.counter_pfx, false)
			caster.counter_pfx = nil
		end
		return false
	end
	if not target:IsStunned() then
		caster:ApplyAndIncrementStack(ability, caster, "modifier_drill_digger_stack", 1, 3, 6)
		local stacks = caster:GetModifierStackCount("modifier_drill_digger_stack", caster)
		if not caster.counter_pfx then
			caster.counter_pfx = ParticleManager:CreateParticle("particles/roshpit/winterblight/drill_digger_counter.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
			ParticleManager:SetParticleControlEnt(caster.counter_pfx, 0, caster, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", caster:GetAbsOrigin(), true)
		end
		ParticleManager:SetParticleControl(caster.counter_pfx, 1, Vector(0, stacks % 10, stacks))
	end
end

function drill_digger_buff_end(event)
	local caster = event.caster
	if caster.counter_pfx then
		ParticleManager:DestroyParticle(caster.counter_pfx, false)
		caster.counter_pfx = nil
	end
end

function drill_digger_quake(caster, ability, target, radius, damage_pct_attack_power)
	local position = target:GetAbsOrigin()
	local splitEarthParticle = "particles/units/heroes/hero_leshrac/astral_rune_b_d.vpcf"
	local pfx = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, position)
	ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
	EmitSoundOn("DrillDigger.Quake", target)
	-- FindClearSpaceForUnit(caster, position, false)
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)*(damage_pct_attack_power/100)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
			enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = 2})
		end
	end
end

function pantheon_strike(event)
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	local particle_name = "particles/units/heroes/hero_phantom_lancer/phantom_lancer_death.vpcf"
	local luck = RandomInt(1, 5)
	if luck == 1 then
		EmitSoundOn("PantheonKnight.Proc", target)
		local duration = event.disarm_duration
		local damage = OverflowProtectedGetAverageTrueAttackDamage(attacker)*(event.damage_atk_pwr_pct/100)
		CustomAbilities:QuickAttachParticle(particle_name, target, 4)
		ability:ApplyDataDrivenModifier(attacker, target, "modifier_deceptive_light", {duration = duration})
	end
end

function cavern_dig_start(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	local particleName = "particles/econ/events/ti9/shovel_revealed_nothing.vpcf"
	local ground_pos = GetGroundPosition(caster:GetAbsOrigin(), caster)
	CustomAbilities:QuickParticleAtPoint("particles/econ/events/ti9/shovel_revealed_nothing.vpcf", ground_pos, 4)
	EmitSoundOn("Cavern.Husker.Dig", caster)
	ability.digging = true
	ability.targetPoint = WallPhysics:WallSearch(caster:GetAbsOrigin(), point, caster)
	local duration = RandomInt(35, 45)/10
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_husker_dig_thinker", {duration = duration})
	StartAnimation(caster, {duration=1.5, activity=ACT_DOTA_CAST_ABILITY_1, rate=1})
end

function husker_thinker(event)
	local caster = event.caster
	local ability = event.ability
	if ability.digging then
		caster:SetAbsOrigin(caster:GetAbsOrigin() - Vector(0,0,20))
	else
		caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0,0,20))
		StartAnimation(caster, {duration=1.5, activity=ACT_DOTA_TELEPORT_END, rate=1})
		if GetGroundHeight(caster:GetAbsOrigin(), caster) < caster:GetAbsOrigin().z then
			caster:RemoveModifierByName("modifier_husker_dig_thinker")
		end
	end
end

function husker_digger_end(event)
	local caster = event.caster
	local ability = event.ability
	if ability.digging then
		ability.digging = false
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_husker_dig_thinker", {})
		local groundTarget = GetGroundPosition(ability.targetPoint, caster)
		caster:SetAbsOrigin(groundTarget-Vector(0,0,200))
		EmitSoundOn("Cavern.Husker.Dig", caster)
		CustomAbilities:QuickParticleAtPoint("particles/econ/events/ti9/shovel_revealed_nothing.vpcf", ability.targetPoint, 4)
	else
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
	end
end

function cavern_relic_fragment_think(event)
	local target = event.target
	if target.phase == 0 then
		target:SetAbsOrigin(target:GetAbsOrigin()+target.direction*target.pushForce+Vector(0,0,target.liftForce))
		target.liftForce = target.liftForce - 1.5
		if (GetGroundPosition(target:GetAbsOrigin(),target).z + 30 > target:GetAbsOrigin().z) and target.liftForce < -1 then
			target.phase = 1
			Timers:CreateTimer(3, function()
				target.phase = 2
			end)
		end
	elseif target.phase == 2 then
		if not target.tiamat_sequence then
			local targetPosition = target.hero:GetAbsOrigin()
			local direction = (targetPosition - target:GetAbsOrigin()):Normalized()
			target:SetAbsOrigin(target:GetAbsOrigin() + direction*60)
			if WallPhysics:GetDistance2d(target:GetAbsOrigin(), targetPosition) < 50 then
				local relics_gain = target.relics
				EmitSoundOn("Winterblight.Cavern.RelicCollect", target)
				CustomAbilities:QuickParticleAtPoint("particles/econ/courier/courier_wyvern_hatchling/courier_wyvern_anim_goldbreath.vpcf", target:GetAbsOrigin()+Vector(0,0,150), 4)

				Winterblight.CavernData.Chambers[target.chamber]["events"][target.event_index]["relic_fragments_rewarded"] = Winterblight.CavernData.Chambers[target.chamber]["events"][target.event_index]["relic_fragments_rewarded"] + relics_gain
				Winterblight.CavernData.RelicsFragments = Winterblight.CavernData.RelicsFragments + relics_gain
				CustomGameEventManager:Send_ServerToAllClients("cavern_summary_update", {fragments = Winterblight.CavernData.RelicsFragments})
				UTIL_Remove(target)
			end
		end
	end
		-- crystal.phase = 0
		-- crystal.direction = targetDirection
		-- crystal.pushForce = 18
		-- crystal.liftForce = 10
end

function cavern_spark_phase(event)
	local caster = event.caster
	StartAnimation(caster, {duration = 0.4, activity = ACT_DOTA_CAST_ABILITY_1, rate = 1.8})
	EmitSoundOn("Winterblight.Cavern.WraithSpark.Pre", caster)
end

function cavern_spark_throw(event)
	local caster = event.caster
	local ability = event.ability
	local spark_count = 3

	local base_damage = event.base_damage
	ability.damage = base_damage * OverflowProtectedGetAverageTrueAttackDamage(caster)

	ability.paralyze_duration = event.paralyze_duration
	local particle = "particles/roshpit/winterblight/ghost_arcanist_projectile_concoction_projectile_linear.vpcf"
	local range = 1000
	local divisor = 15
	if spark_count == 3 then
		divisor = 17
	elseif spark_count == 4 then
		divisor = 18
	elseif spark_count == 5 then
		divisor = 22
	end
	EmitSoundOn("Winterblight.Cavern.WraithSpark.Throw", caster)
	for i = 1, spark_count, 1 do
		local rotation_adjustment = spark_count / 2
		local fv = WallPhysics:rotateVector(caster:GetForwardVector(), 2 * math.pi * (i - rotation_adjustment) / divisor)
		local speed = 1500
		local info =
		{
			Ability = ability,
			EffectName = particle,
			vSpawnOrigin = caster:GetAbsOrigin() + Vector(0, 0, 20),
			fDistance = range,
			fStartRadius = 170,
			fEndRadius = 170,
			Source = caster,
			StartPosition = "attach_attack1",
			bHasFrontalCone = true,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 5.0,
			bDeleteOnHit = false,
			vVelocity = fv * speed,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
	end

	Filters:CastSkillArguments(2, caster)
end

function cavern_spark_impact(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local paralyze_duration = ability.paralyze_duration

	local current_stacks = target:GetModifierStackCount("modifier_cavern_spark_paralyze_immunity", target)
	local paralyze_immunity = 1
	if current_stacks <= 5 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_cavern_spark_paralyze_immunity", {duration = paralyze_immunity})
		ability:ApplyDataDrivenModifier(caster, target, "modifier_cavern_spark_paralyze", {duration = paralyze_duration})
		target:SetModifierStackCount("modifier_cavern_spark_paralyze_immunity", caster, current_stacks + 1)
	end
	StartAnimation(target, {duration = paralyze_duration, activity = ACT_DOTA_FLAIL, rate = 2.2})
	EmitSoundOn("Winterblight.Cavern.WraithSpark.Hit", target)
	local particleName = "particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf"
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin() + Vector(0, 0, target:GetBoundingMaxs().z + 40))
	ParticleManager:SetParticleControl(pfx, 1, target:GetAbsOrigin() + Vector(0, 0, target:GetBoundingMaxs().z + 60))
	Timers:CreateTimer(0.3, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	Filters:TakeArgumentsAndApplyDamage(target, caster, ability.damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_NATURE, RPC_ELEMENT_LIGHTNING)
end

function merkurio_crystal_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 0
	end
	if not caster.apply_interval then
		caster.apply_interval = 0
	end
	caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, 2) * math.cos(2 * math.pi * caster.interval / 180))
	caster.interval = caster.interval + 1
	local rotatedFV = WallPhysics:rotateVector(caster:GetForwardVector(), 2 * math.pi / 180)
	caster:SetForwardVector(rotatedFV)
	if caster.interval == 180 then
		caster.interval = 0
	end

	local crystal = caster
	crystal:SetAbsOrigin(crystal:GetAbsOrigin() + Vector(0, 0, 0.8) * math.cos(2 * math.pi * caster.interval / 180))
	local rotatedFV = WallPhysics:rotateVector(crystal:GetForwardVector(), 2 * math.pi / 180)
	crystal:SetForwardVector(rotatedFV)
	caster.apply_interval = caster.apply_interval + 1
	if caster.apply_interval == 30 then
		caster.apply_interval = 0
		if not caster:HasModifier("modifier_merkurio_crystal_disabled") then
			apply_merkurio_crystal_buffs(caster, ability)
		end
	end
end

function apply_merkurio_crystal_buffs(caster, ability)
	if caster.crystal_color == "red" then
		for i = 1, #Winterblight.CavernUnits[1], 1 do
			local unit = Winterblight.CavernUnits[1][i]
			if IsValidEntity(unit) and unit:GetUnitName() ~= "npc_dummy_unit" then
				print("apply modifier")
				ability:ApplyDataDrivenModifier(caster, unit, "modifier_merkurio_crystal_red", {})
			end
		end
	elseif caster.crystal_color == "blue" then
		for i = 1, #Winterblight.CavernUnits[1], 1 do
			local unit = Winterblight.CavernUnits[1][i]
			if IsValidEntity(unit) and unit:GetUnitName() ~= "npc_dummy_unit" then
				ability:ApplyDataDrivenModifier(caster, unit, "modifier_merkurio_crystal_blue", {})
			end
		end
	elseif caster.crystal_color == "yellow" then
		for i = 1, #Winterblight.CavernUnits[1], 1 do
			local unit = Winterblight.CavernUnits[1][i]
			if IsValidEntity(unit) and unit:GetUnitName() ~= "npc_dummy_unit" then
				ability:ApplyDataDrivenModifier(caster, unit, "modifier_merkurio_crystal_yellow", {})
			end
		end
	elseif caster.crystal_color == "green" then
		for i = 1, #Winterblight.CavernUnits[1], 1 do
			local unit = Winterblight.CavernUnits[1][i]
			if IsValidEntity(unit) and unit:GetUnitName() ~= "npc_dummy_unit" then
				ability:ApplyDataDrivenModifier(caster, unit, "modifier_merkurio_crystal_green", {})
			end
		end
	elseif caster.crystal_color == "purple" then
		for i = 1, #Winterblight.CavernUnits[1], 1 do
			local unit = Winterblight.CavernUnits[1][i]
			if IsValidEntity(unit) and unit:GetUnitName() ~= "npc_dummy_unit" then
				ability:ApplyDataDrivenModifier(caster, unit, "modifier_merkurio_crystal_purple", {})
				unit:SetModifierStackCount("modifier_merkurio_crystal_purple", caster, 3)
			end
		end
	end
end

function merkurio_crystal_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	if not caster:HasModifier("modifier_merkurio_crystal_disabled") then
		caster:SetRenderColor(50, 50, 50)
		EmitSoundOn("Winterblight.MerkurioCrystal.Deactivate", caster)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_merkurio_crystal_disabled", {duration = 15})
		local color = caster.crystal_color
		for i = 1, #Winterblight.CavernUnits[1], 1 do
			local unit = Winterblight.CavernUnits[1][i]
			if IsValidEntity(unit) then
				if unit:GetUnitName() ~= "npc_dummy_unit" then
					unit:RemoveModifierByName("modifier_merkurio_crystal_"..color)
				end
			end
		end
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_wisp/wisp_death.vpcf", caster, 3)
	end
end

function merkurio_crystal_reactivate(event)
	local caster = event.caster
	local ability = event.ability
	local crystal = caster
	if Winterblight.CavernData.Chambers[1]["status"] == 1 then
		apply_merkurio_crystal_buffs(caster, ability)
		local crystal_color = caster.crystal_color

		if crystal_color == "red" then
			crystal:SetRenderColor(220, 100, 100)
		elseif crystal_color == "blue" then
			crystal:SetRenderColor(100, 100, 220)
		elseif crystal_color == "yellow" then
			crystal:SetRenderColor(220, 220, 100)
		elseif crystal_color == "green" then
			crystal:SetRenderColor(100, 220, 100)
		elseif crystal_color == "purple" then
			crystal:SetRenderColor(220, 100, 220)
		end
		crystal.crystal_color = crystal_color
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_wisp/wisp_death.vpcf", crystal, 3)
		EmitSoundOn("Winterblight.MerkurioCrystal.Reactivate", crystal)
	end
end

function disappearing_act_cast(event)
	local caster = event.caster
	local ability = event.ability
	local duration = event.duration

	local pfx2 = CustomAbilities:QuickParticleAtPoint("particles/roshpit/conjuror/shadow_deity_cloak_of_shadows.vpcf", caster:GetAbsOrigin(), 3)
	ParticleManager:SetParticleControl(pfx2, 1, Vector(200, 200, 200))
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_invisibility_datadriven", {duration = duration})
	caster:AddNewModifier(caster, ability, "modifier_persistent_invisibility", {duration = duration})

	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.Beguiler.DisappearingAct", caster)
	if caster:GetUnitName() == "winterblight_cavern_beguiler" then
		Timers:CreateTimer(0.5, function()
			EmitSoundOn("Winterblight.Beguiler.DisappearingAct.Highlight", caster)
		end)
	end
end

function cast_confusional_spores(event)
	local caster = event.caster
	local ability = event.ability
	local duration = event.duration
	if caster:GetUnitName() == "winterblight_fungal_shaman" then
		EmitSoundOn("Winterblight.FungalShaman.Laugh", caster)
	end
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.FungalShaman.DropSpores", caster)
	local spellPoint = caster:GetAbsOrigin() + caster:GetForwardVector() * 200
	local particleName = "particles/roshpit/winterblight/confusional_spores.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(particle1, 0, spellPoint)
	ParticleManager:SetParticleControl(particle1, 1, Vector(400, 100, 1))
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), spellPoint, nil, 420, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	for i = 1, #enemies, 1 do
		ability:ApplyDataDrivenModifier(caster, enemies[i], "modifier_confusional_spores", {duration = duration})
	end
	Timers:CreateTimer(2.5, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)

end

function tweaking_arrow_hit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	local target_ability = target:GetAbilityByIndex(DOTA_E_SLOT)
	if target_ability and target_ability:IsFullyCastable() then
		local behavior = target_ability:GetBehavior()
		if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET) == DOTA_ABILITY_BEHAVIOR_NO_TARGET then
			local order =
			{
				UnitIndex = target:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = target_ability:entindex(),
				Queue = true
			}
			target:Stop()
			ExecuteOrderFromTable(order)
			--print("IN HERE")
		elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
			local order = {
				UnitIndex = target:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				TargetIndex = caster:entindex(),
				AbilityIndex = target_ability:entindex(),
				Queue = true
			}
			target:Stop()
			--print("HERE?")
			ExecuteOrderFromTable(order)
		elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_POINT) == DOTA_ABILITY_BEHAVIOR_POINT then
			local order =
			{
				UnitIndex = target:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = target_ability:entindex(),
				Position = caster:GetAbsOrigin(),
				Queue = true
			}
			target:Stop()
			ExecuteOrderFromTable(order)
		end		
	end
end

function fungal_minion_think(event)
	local caster = event.caster
	if caster.aggro then
		local ability = event.ability
		local position = caster:GetAbsOrigin()
		--ability:ApplyDataDrivenThinker(caster, position, "modifier_poison_cloud_thinker", {})
		CustomAbilities:QuickAttachThinker(ability, caster, position, "modifier_poison_cloud_thinker", {})
	end
end

function activate_spirit_ring(event)
	local caster = event.caster
	local ability = event.ability


	local damage = event.damage
	local radius = 1000
	ability.damage = damage

	if not ability.ring_table then
		ability.ring_table = {}

	end
	local new_ring = {}
	new_ring.active = true
	new_ring.pfx = ParticleManager:CreateParticle("particles/roshpit/winterblight/spirit_ring_reduced_flash.vpcf", PATTACH_CUSTOMORIGIN, nil)
	table.insert(ability.ring_table, new_ring)
	local ringDuration = 0
	local speed = radius * 1
	ability.speed = speed
	ability.radius = radius
	new_ring.distance_from_center = 0
	new_ring.interval = 0
	new_ring.attachmentUnit = caster
	ParticleManager:SetParticleControl(new_ring.pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(new_ring.pfx, 1, Vector(speed, radius, 600))
	Timers:CreateTimer(ringDuration + (radius / speed), function()
		new_ring.retracing = true
		ParticleManager:SetParticleControl(new_ring.pfx, 1, Vector(speed, -radius, 600))
		Timers:CreateTimer(radius / speed, function()
			new_ring.active = false
			ParticleManager:DestroyParticle(new_ring.pfx, false)
			ParticleManager:ReleaseParticleIndex(new_ring.pfx)
			reindex_spirit_ring_table(caster, ability)
		end)
	end)
	EmitSoundOn("Winterblight.Mundugu.SpiritRing", caster)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_spirit_ring_thinker", {})
end

function reindex_spirit_ring_table(caster, ability)
	local new_table = {}
	for i = 1, #ability.ring_table, 1 do
		if ability.ring_table[i].active then
			table.insert(new_table, ability.ring_table[i])
		end
	end
	ability.ring_table = new_table
	if #ability.ring_table == 0 then
		caster:RemoveModifierByName("modifier_spirit_ring_thinker")
	end
end

function spirit_ring_thinker(event)
	local caster = event.caster
	local ability = event.ability
	for i = 1, #ability.ring_table, 1 do
		local ring = ability.ring_table[i]
		if ring.active then
			ParticleManager:SetParticleControl(ring.pfx, 0, caster:GetAbsOrigin())
			if ring.retracing then
				ring.distance_from_center = ring.distance_from_center - ability.speed * 0.03
			else
				ring.distance_from_center = ring.distance_from_center + ability.speed * 0.03
			end
			ring.interval = ring.interval + 1
			if ring.interval % 3 == 0 then
				local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, ring.distance_from_center + 100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
				local enemies_exclude = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, ring.distance_from_center - 100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
				if #enemies > 0 then
					for _, enemy in pairs(enemies) do
						if WallPhysics:DoesTableHaveValue(enemies_exclude, enemy) then
						else
							local damage = ability.damage
							EmitSoundOn("Winterblight.Mundugu.SpiritRing.Hit", enemy)
							Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 0, RPC_ELEMENT_GHOST, RPC_ELEMENT_NONE)
							CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell_flash_light.vpcf", enemy, 2)
							ability:ApplyDataDrivenModifier(caster, enemy, "modifier_spirit_ring_slow", {duration = event.duration})
						end
					end
				end
			end
		end
	end
end

function aeon_shield_init(event)
	local caster = event.caster
	local ability = event.ability
	local initial_stacks = 5
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_aeon_shield_charges", {})
	caster:SetModifierStackCount("modifier_aeon_shield_charges", caster, initial_stacks)
end

function aeon_shield_stack_gain(event)
	local caster = event.caster
	local ability = event.ability
	caster:ApplyAndIncrementStack(ability, caster, "modifier_aeon_shield_charges", 1, 5, 0)
end

function aeon_sheild_activated(event)
	local caster = event.caster
	local ability = event.ability
	local pfx = CustomAbilities:QuickAttachParticle("particles/items4_fx/combo_breaker_buff.vpcf", caster, 2.6)
	for i = 1, 5, 1 do
		ParticleManager:SetParticleControlEnt(pfx, i, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin()+Vector(0,0,80), true)
	end
end

function zect_rider_think(event)
	local caster = event.caster
	if caster.aggro then
		local ability_to_cast = nil
		local ability1 = caster:FindAbilityByName("zect_rider_thunder_strike")
		local ability2 = caster:FindAbilityByName("zect_rider_lightning_bolt")
		local ability3 = caster:FindAbilityByName("zect_rider_arc_lightning")
		
		if ability1:IsFullyCastable() then
			ability_to_cast = ability1
		elseif ability2:IsFullyCastable() then
			ability_to_cast = ability2
		elseif ability3:IsFullyCastable() then
			ability_to_cast = ability3
		end
		if ability_to_cast then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					TargetIndex = enemies[1]:entindex(),
					AbilityIndex = ability_to_cast:entindex(),
				}

				ExecuteOrderFromTable(newOrder)
			end
		end
	end
end

function radium_spores_start(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, target, "modifier_radium_spores", {duration = event.duration})
	EmitSoundOn("Winterblight.RadiumSpores.Apply", target)
end

function icicle_barrage_start(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local stacks = target:GetModifierStackCount("modifier_icicle_barrage_stacks", caster)
	local projectile_count = stacks + 1
	for i = 1, projectile_count, 1 do
		Timers:CreateTimer((i-1)*0.2, function()
			EmitSoundOn("Winterblight.IcicleBarrage.Launch", caster)
			local info =
			{
				Target = target,
				Source = caster,
				Ability = ability,
				EffectName = "particles/units/heroes/hero_winter_wyvern/wyvern_splinter_blast.vpcf",
				StartPosition = "attach_hitloc",
				bDrawsOnMinimap = false,
				bDodgeable = true,
				bIsAttack = false,
				bVisibleToEnemies = true,
				bReplaceExisting = false,
				flExpireTime = GameRules:GetGameTime() + 8,
				bProvidesVision = true,
				iVisionRadius = 0,
				iMoveSpeed = 800,
			iVisionTeamNumber = caster:GetTeamNumber()}
			projectile = ProjectileManager:CreateTrackingProjectile(info)
		end)
	end
end

function icicle_barrage_impact(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	target:ApplyAndIncrementStack(ability, caster, "modifier_icicle_barrage_stacks", 1, 0, 5)	
	local damage = event.damage
	local icePoint = target:GetAbsOrigin()
	local radius = 240
	EmitSoundOnLocationWithCaster(icePoint, "hero_Crystal.freezingField.explosion", target)
	local particle = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
	local pfx = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, icePoint)
	ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 2, radius * 2))
	Timers:CreateTimer(2.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), icePoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_chilled", {duration = 3})
			ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
		end
	end
end

function shroom_procure_think(event)
	local caster = event.caster
	local ability = event.ability
	local position = caster:GetAbsOrigin() + RandomVector(RandomInt(200, 900))
	local shroom = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, caster:GetTeamNumber())
	shroom:SetModelScale(0.01)
	shroom:SetOriginalModel("maps/cavern_assets/models/spores/spores_cavern_01.vmdl")
	shroom:SetModel("maps/cavern_assets/models/spores/spores_cavern_01.vmdl")
	shroom:FindAbilityByName("dummy_unit"):SetLevel(1)	
	shroom.phase = 0
	shroom.state = 0
	EmitSoundOn("Winterblight.ShroomProcure.Spawn", shroom)
	ability:ApplyDataDrivenModifier(caster, shroom, "modifier_shroom_procurement_spawned", {duration = 30})
end

function procured_shroom_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	if target.state == 0 then
		target:SetModelScale(target:GetModelScale()+0.005)
		if target.phase == 100 then
			target.state = 1
			target.phase = 0
		end
	elseif target.state == 1 then
		local red_shading = 255 - target.phase*2
		target:SetRenderColor(255, red_shading, red_shading)
		if target.phase == 100 then
			target.state = 2
			target.phase = 0
		end
	elseif target.state == 2 then
		if target.phase == 15 then
			if IsValidEntity(caster) then
				procured_shroom_explode(caster, ability, target:GetAbsOrigin())
			end
			UTIL_Remove(target)
			return false
		end
	end
	target.phase = target.phase + 1
end

function procured_shroom_explode(caster, ability, position)
	local spellPoint = position
	local particleName = "particles/roshpit/winterblight/confusional_spores.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(particle1, 0, spellPoint)
	ParticleManager:SetParticleControl(particle1, 1, Vector(400, 100, 1))
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), spellPoint, nil, 420, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	Timers:CreateTimer(2.5, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)	
	EmitSoundOnLocationWithCaster(position, "Winterblight.ShroomProcure.Explode", caster)
	CustomAbilities:QuickAttachThinker(ability, caster, position, "modifier_shroom_procure_thinker", {duration = 5})
end

function in_procured_shroom_cloud_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	ApplyDamage({ victim = target, attacker = caster, damage = event.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })
end

function cavern_player_hero_think(event)
	local hero = event.target
	if Winterblight.CavernData.Chambers[3]["status"] == 1 and Winterblight.CavernData.Chambers[3]["event"] == 3 then
		if hero:HasModifier("modifier_confusional_spores") then
			if Winterblight:IsWithinChamber(hero, 3) then
			else
				hero:RemoveModifierByName("modifier_confusional_spores")
			end
		else
			if Winterblight:IsWithinChamber(hero, 3) then
				Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, hero, "modifier_confusional_spores", {})
			end
		end
	elseif Winterblight.CavernData.Chambers[4]["status"] == 1 and Winterblight.CavernData.Chambers[4]["event"] == 4 then
		if hero:HasModifier("modifier_wb_zero_g") then
			if Winterblight:IsWithinChamber(hero, 4) then
			else
				hero:RemoveModifierByName("modifier_wb_zero_g")
			end
		else
			if Winterblight:IsWithinChamber(hero, 4) then
				Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, hero, "modifier_wb_zero_g", {})
			end
		end
	end
end

function demented_mushroom_think(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Winterblight.DementedMushroom.VO.SpellBurst", caster)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.DementedMushroom.SpellProjectile", caster)
	local projectile_particle = "particles/roshpit/winterblight/demented_shroom_proj.vpcf"
	local projectile_count = 5
	local baseFV = caster:GetForwardVector()
	for i = 1, projectile_count, 1 do
		local fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/projectile_count)
		local speed = 1500
		local range = 900
		local info =
		{
			Ability = ability,
			EffectName = projectile_particle,
			vSpawnOrigin = caster:GetAbsOrigin() + Vector(0, 0, 20),
			fDistance = range,
			fStartRadius = 190,
			fEndRadius = 190,
			Source = caster,
			StartPosition = "attach_attack1",
			bHasFrontalCone = true,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 5.0,
			bDeleteOnHit = false,
			vVelocity = fv * speed,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
	end
end

function demented_mushroom_projectile_hit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local damage = event.damage
	ability:ApplyDataDrivenModifier(caster, target, "modifier_demented_mushroom_slow", {duration = 1})
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })
	EmitSoundOn("Winterblight.DementedMushroom.SpellProjectile.Hit", target)
end

function demented_mushroom_die(event)
	local caster = event.caster
	local ability = event.ability

	Winterblight:SpawnNextShroom(caster.spawnphase)

	EmitSoundOn("Winterblight.DementedMushroom.VO.Die", caster)
	EndAnimation(caster)
	Timers:CreateTimer(0.03, function()
		StartAnimation(caster, {duration=1, activity=ACT_DOTA_SPAWN, rate=0.8})
	end)
	Events:smoothSizeChange(caster, 2.0, 0.1, 25)

	local position = caster:GetAbsOrigin()
	local fv = caster:GetForwardVector()

	local particleName = "particles/roshpit/winterblight/confusional_spores.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(particle1, 0, position)
	ParticleManager:SetParticleControl(particle1, 1, Vector(400, 100, 1))
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, 420, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	Timers:CreateTimer(2.5, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)	
	EmitSoundOnLocationWithCaster(position, "Winterblight.ShroomProcure.Explode", caster)
	local shroom_unit_spawn_index = RandomInt(1, 15)
	Timers:CreateTimer(0.2, function()
		local spawns = 8
		for i = 1, spawns, 1 do
			local dummy = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
			dummy:AddAbility("ability_blue_effect"):SetLevel(1)
			dummy:SetAbsOrigin(dummy:GetAbsOrigin() + Vector(0, 0, 200))
			local dummyFV = WallPhysics:rotateVector(fv, (2 * math.pi / spawns) * i)
			WallPhysics:Jump(dummy, dummyFV, 5 + RandomInt(1, 4), 5 + RandomInt(1, 4), 16, 0.45)
			Timers:CreateTimer(4, function()
				Winterblight:SpawnShroomUnit(caster, dummy:GetAbsOrigin(), shroom_unit_spawn_index)
				UTIL_Remove(dummy)
			end)
		end

	end)
end

function three_perceptions_start(event)
	local ability = event.ability
	local attacks = event.attack_count
	local caster = event.caster
	local damage = event.damage

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_three_perceptions_striking", {duration = (attacks - 1) * 0.5})
	three_perceptions_strike(caster, caster:GetAbsOrigin(), damage, ability)
end

function three_perceptions_think(event)
	local ability = event.ability
	local caster = event.caster
	three_perceptions_strike(caster, caster:GetAbsOrigin(), damage, ability)
end

function three_perceptions_strike(caster, position, damage, ability)
	local radius = 900
	if caster:GetUnitName() == "winterblight_aurora_boss_1" then
		radius = 1800
	end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	local enemy = enemies[RandomInt(1, #enemies)]
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)
	if #enemies > 0 then
		CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_lone_druid/lone_druid_loadout.vpcf", caster:GetAbsOrigin()+Vector(0,0,40), 3)
		caster:SetAbsOrigin(enemy:GetAbsOrigin() + RandomVector(120))
		CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_lone_druid/lone_druid_loadout.vpcf", caster:GetAbsOrigin()+Vector(0,0,40), 3)
		local fv = (enemy:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
		local casterPos = caster:GetAbsOrigin()
		caster:SetForwardVector(fv)
		EmitSoundOn("Winterblight.Bovaur.ThreePerceptions.Hit", caster)
		StartAnimation(caster, {duration = 0.5, activity = ACT_DOTA_ATTACK, rate = 2.0})
		Timers:CreateTimer(0.2, function()
			caster:PerformAttack(enemy, true, true, true, true, false, false, false)
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_R, RPC_ELEMENT_GHOST, RPC_ELEMENT_NORMAL)
			EmitSoundOn("Hero_Spirit_Breaker.GreaterBash", enemy)
			enemy:AddNewModifier(caster, nil, "modifier_knockback", modifierKnockback)
			local particleName = "particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf"
			EmitSoundOn("Hero_Spirit_Breaker.Attack", caster)
			EmitSoundOn("Hero_Spirit_Breaker.Attack", caster)
			local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, enemy)
			ParticleManager:SetParticleControlEnt(pfx, 0, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			Timers:CreateTimer(0.8, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
		end)
	end
end

function three_perceptions_end(event)
	local caster = event.caster
	EmitSoundOn("Winterblight.Bovaur.ThreePerceptions.End", caster)
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
end

function trigger_frost_overhwhelming(event)
	local caster = event.caster
	local ability = event.ability
	if caster:GetUnitName() == "winterblight_cavern_overwhelmer" then
		EmitSoundOn("Winterblight.FrostOverwhelm.Die", caster)
	end
	local particleName = "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf"
	local radius = event.radius
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, nil)
	local origin = caster:GetAbsOrigin()
	ParticleManager:SetParticleControl(particle1, 0, origin + Vector(0, 0, 20))
	ParticleManager:SetParticleControl(particle1, 1, Vector(radius, 1, 1000))
	ParticleManager:SetParticleControl(particle1, 3, Vector(500, 500, 500))
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
	local allies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false )	
	for i = 1, #allies, 1 do
		local ally = allies[i]
		ability:ApplyDataDrivenModifier(caster, ally, "modifier_colossus_restore", {duration = 7})
		EmitSoundOn("Winterblight.Restore", ally)
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_winter_wyvern/wyvern_cold_embrace_borealis.vpcf", ally, 6)
	end
	EmitSoundOn("Winterblight.Megmus.Ability", caster)
end

function giant_snow_crab_init(event)
	local caster = event.caster
	local ability = event.ability	
	Timers:CreateTimer(0.03, function()
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_giant_snow_crab_stacks", {})
		caster:SetModifierStackCount("modifier_giant_snow_crab_stacks", caster, 10)
	end)
end

function giant_snow_crab_think(event)
	local caster = event.caster
	local ability = event.ability	
	caster:ApplyAndIncrementStack(ability, caster, "modifier_giant_snow_crab_stacks", 1, 0, 10)
end

function giant_snow_crab_hit(event)
	local caster = event.caster
	local ability = event.ability	
	local current_stacks = caster:GetModifierStackCount("modifier_giant_snow_crab_stacks", caster)
	if (caster:GetHealth()/caster:GetMaxHealth())*10 < current_stacks then
		caster:SetModifierStackCount("modifier_giant_snow_crab_stacks", caster, current_stacks - 1)
		EmitSoundOn("Winterblight.SpawnerSquish", caster)
		Timers:CreateTimer(0.05, function()
			for i = 1, 3, 1 do
				local position = caster:GetAbsOrigin()
				local zombie = Winterblight:SpawnSpawnerUnit(caster:GetAbsOrigin(), RandomVector(1), false, true)
				zombie:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, 100))
				local fv = WallPhysics:rotateVector(caster:GetForwardVector(), 2 * math.pi * i / 3)
				WallPhysics:Jump(zombie, fv, RandomInt(4, 16), RandomInt(10, 16), RandomInt(16, 24), 1)
				zombie.jumpEnd = "crab_land"
				EmitSoundOn("Winterblight.Crab.Spawn", zombie)
			end
		end)
	end
end

function aquarius_dome_start(event)
	local ability = event.ability
	local caster = event.caster
	EmitSoundOn("Winterblight.AcquariusDome", caster)

	local particleName = "particles/roshpit/omniro/chrono_path_sphere.vpcf"
	local position = event.target_points[1]
	StartAnimation(caster, {duration = 1.0, activity = ACT_DOTA_CAST_ABILITY_4, rate = 1.6})

	local color = Vector(30, 140, 255) / 255
	position = GetGroundPosition(position, caster)
	local dummy = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, caster:GetTeamNumber())
	dummy:SetAbsOrigin(position)
	dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
	dummy.pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(dummy.pfx, 0, position)
	ParticleManager:SetParticleControl(dummy.pfx, 1, Vector(event.radius, event.radius, event.radius))
	ParticleManager:SetParticleControl(dummy.pfx, 3, color)
	ability:ApplyDataDrivenModifier(caster, dummy, "modifier_aquarius_dome_dummy", {duration = event.duration})
end

function aquarius_dome_dummy_end(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	ParticleManager:DestroyParticle(target.pfx, false)
	UTIL_Remove(target)
end

function thunderhide_egg_hit(event)
	local caster = event.unit
	if not caster.hatching then
		EmitSoundOn("Winterblight.Thunderhide.EggHit", caster)
		caster.hatching = true
		local baseColorVector = caster.colorVector
		for i = 1, 20, 1 do
			Timers:CreateTimer(i * 0.06, function()
				if i % 2 == 0 then
					caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(i, i, 0))
					CustomAbilities:QuickParticleAtPoint("particles/roshpit/draghor/shapeshift_effect_white_base.vpcf", caster:GetAbsOrigin(), 4)
				else
					caster:SetAbsOrigin(caster:GetAbsOrigin() - Vector(i, i, 0))
				end
				baseColorVector = baseColorVector - Vector(5,5,5)
				caster:SetRenderColor(math.max(baseColorVector.x, 0), math.max(baseColorVector.y, 0), math.max(baseColorVector.z, 0))
				
			end)
		end
		local position = caster:GetAbsOrigin()+Vector(0,0,50)
		local size = caster:GetModelScale()/3.3
		Timers:CreateTimer(1.25, function()
			if Winterblight:ShouldSpawnCaveUnit(caster.chamber, caster.spawnphase) then
				local lizard = Winterblight:SpawnThunderhide(caster:GetAbsOrigin(), RandomVector(1), caster.colorVector)
				local luck = RandomInt(1, 2)
				if luck == 1 then
					lizard:SetModel("models/creeps/neutral_creeps/n_creep_thunder_lizard/n_creep_thunder_lizard_small.vmdl")
					lizard:SetOriginalModel("models/creeps/neutral_creeps/n_creep_thunder_lizard/n_creep_thunder_lizard_small.vmdl")
				end
				local ability_list = {"winterblight_stun_regen", "creature_pure_strike", "ability_mega_haste", "ability_magic_immune_break", "fire_temple_frenzy", "winterblight_ogre_armor", "seafortress_ghost_seal_ability", "ability_stun_immunity", "ability_unshakable", "winterblight_frostiok_passive", "winterblight_frost_colossus_passive", "winterblight_snowshaker_passive", "armor_break_ultra", "luna_taskmaster_shield", "ice_hulk_passive", "winterblight_armor_softening", "normal_steadfast", "mega_steadfast"}
				lizard:SetModelScale(size)
				lizard:SetHullRadius(size*55)
				local ability_count = 1
				if Winterblight.CavernData.Chambers[2]["level"] >= 20 then
					ability_count = 2
				end
				if Winterblight.CavernData.Chambers[2]["level"] >= 30 then
					ability_count = 3
				end				
				for i = 1, ability_count, 1 do
					local ability_name_to_add = ability_list[RandomInt(1, #ability_list)]
					local new_ability = lizard:AddAbility(ability_name_to_add)
					new_ability:SetLevel(GameState:GetDifficultyFactor())
				end
				CustomAbilities:QuickParticleAtPoint("particles/roshpit/venomort/frostvenom_grasp.vpcf", position, 4)
				Dungeons:AggroUnit(lizard)
				Winterblight:SetCavernUnit(lizard, lizard:GetAbsOrigin(), true, false, caster.chamber)
				EmitSoundOn("Winterblight.ThunderhideEgg.Hatch", caster)
				local currentScale = caster:GetModelScale()
				local eggShell = SpawnEntityFromTableSynchronous("prop_dynamic", {origin = caster:GetAbsOrigin()})
				local randomIndex = RandomInt(1, 4)
				local modelName = "models/props_winter/egg_shatter_0"..randomIndex..".vmdl"
				eggShell:SetModel(modelName)
				eggShell:SetModelScale(currentScale)
				eggShell:SetRenderColor(caster.colorVector.x, caster.colorVector.y, caster.colorVector.z)
				UTIL_Remove(caster)
				Timers:CreateTimer(0.03, function()
					FindClearSpaceForUnit(lizard, lizard:GetAbsOrigin(), false)
				end)
				Timers:CreateTimer(60, function()
					UTIL_Remove(eggShell)
				end)
			end
		end)
	end
end

function aurora_boss_think(event)
	local caster = event.caster
	local ability = event.ability
	local ability_list = {}
	if caster:GetUnitName() == "winterblight_aurora_boss_1" then
		ability_list = {"three_perceptions", "winterblight_ice_vortex_aoe", "winterblight_spirit_ring"}
		if not caster.lastPos then
			caster.lastPos = caster:GetAbsOrigin()
		end
		if not caster.interval then
			caster.interval = 0
		end
		local interval_mod = 3
		if not caster.aggro then
			interval_mod = 4
		end
		if WallPhysics:GetDistance2d(caster.lastPos, caster:GetAbsOrigin()) > 30 and caster.interval%interval_mod == 0 then
            local pfx = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
            ParticleManager:SetParticleControl(pfx, 0, GetGroundPosition(caster:GetAbsOrigin(), caster))
            ParticleManager:SetParticleControl(pfx, 1, Vector(200, 200, 200))
            Timers:CreateTimer(2, function()
              ParticleManager:DestroyParticle(pfx, false)
            end)			
            EmitSoundOn("Winterblight.AuroraBosses.1.Moving", caster)
            ScreenShake(caster:GetAbsOrigin(), 160, 0.3, 0.3, 2000, 0, true)
		end
		caster.interval = caster.interval + 1
		caster.lastPos = caster:GetAbsOrigin()
	elseif caster:GetUnitName() == "winterblight_aurora_boss_2" then
		ability_list = {"curse_of_belial"}
	elseif caster:GetUnitName() == "winterblight_aurora_boss_3" then
		ability_list = {"winterblight_dome_of_aquarius", "icicle_barrage"}
	end
	if caster.castLock then
		return false
	end
	if caster:IsChanneling() then
		print("IS CHANNELING")
		return false
	end
	for i = 1, #ability_list, 1 do
		local cast_ability = caster:FindAbilityByName(ability_list[i])
		if cast_ability:GetAbilityName() == "winterblight_dome_of_aquarius" and cast_ability:GetCooldownTimeRemaining() > 4 then
			cast_ability:EndCooldown()
			cast_ability:StartCooldown(4)
		end
		if cast_ability and cast_ability:IsFullyCastable() and caster.aggro then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			local behavior = cast_ability:GetBehavior()
			if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET) == DOTA_ABILITY_BEHAVIOR_NO_TARGET then
				local order =
				{
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = cast_ability:entindex(),
					Queue = true
				}
				caster:Stop()
				ExecuteOrderFromTable(order)
				local delay = cast_ability:GetCastPoint() + 1
				if cast_ability:GetAbilityName() == "winterblight_spirit_ring" then
					delay = 1.0
				end
				if cast_ability:GetAbilityName() =="three_perceptions" then
					StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_2, rate=1})
					delay = 1.5
				end
				caster.castLock = true
				Timers:CreateTimer(delay, function()
					caster.castLock = false
				end)
				--print("IN HERE")
			elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET and #enemies > 0 then
				local order = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					TargetIndex = enemies[1]:entindex(),
					AbilityIndex = cast_ability:entindex(),
					Queue = true
				}
				caster:Stop()
				ExecuteOrderFromTable(order)

				local delay = cast_ability:GetCastPoint() + 0.3
				caster.castLock = true
				Timers:CreateTimer(delay, function()
					caster.castLock = false
				end)
			elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_POINT) == DOTA_ABILITY_BEHAVIOR_POINT then
				local point = caster:GetAbsOrigin()
				if #enemies > 0 then
					point = enemies[1]:GetAbsOrigin()
				end
				if cast_ability:GetAbilityName() == "winterblight_dome_of_aquarius" then
					point = caster:GetAbsOrigin()
				end
				local order =
				{
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = cast_ability:entindex(),
					Position = point,
					Queue = true
				}
				caster:Stop()
				ExecuteOrderFromTable(order)

				local delay = cast_ability:GetCastPoint() + 0.3
				caster.castLock = true
				Timers:CreateTimer(delay, function()
					caster.castLock = false
				end)
			end		
		end
	end
end

function space_shark_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	caster:ApplyAndIncrementStack(ability, caster, "modifier_space_shark_stacks", 1, 5, event.duration)
	local stacks = caster:GetModifierStackCount("modifier_space_shark_stacks", caster)
	if not caster.counter_pfx then
		caster.counter_pfx = ParticleManager:CreateParticle("particles/roshpit/winterblight/drill_digger_counter.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(caster.counter_pfx, 0, caster, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", caster:GetAbsOrigin(), true)
	end
	ParticleManager:SetParticleControl(caster.counter_pfx, 1, Vector(0, stacks % 10, stacks))
	if stacks == 5 then
		caster:RemoveModifierByName("modifier_space_shark_stacks")
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_space_shark_full", {duration = event.duration})
		caster:AddNewModifier(caster, ability, "modifier_space_shark_size", {duration = event.duration})
		EmitSoundOn("Winterblight.SpaceShark.PowerUp", caster)
	end
end

function space_shark_buff_end(event)
	local caster = event.caster
	if caster.counter_pfx then
		ParticleManager:DestroyParticle(caster.counter_pfx, false)
		caster.counter_pfx = nil
	end
end

function space_shark_big_hit(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	EmitSoundOn("Winterblight.SpaceShark.BigHit", target)
	CustomAbilities:QuickAttachParticle("particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void_hit.vpcf", target, 4)
	if target:IsRealHero() then
		target:SetHealth(10)
		target:ForceKill(true)
	end
end

function bone_blister_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local position = caster:GetAbsOrigin()+RandomVector(RandomInt(120, 600))
	if not ability.interval then
		ability.interval = 0
	end
	ability.interval = ability.interval + 1
	local health_div = math.floor((caster:GetHealth()/caster:GetMaxHealth())*10)
	if ability.interval%health_div == 0 then
		CustomAbilities:QuickParticleAtPoint("particles/econ/items/lich/frozen_chains_ti6/lich_frozenchains_frostnova.vpcf", position, 4)
	    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, 210, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	    EmitSoundOnLocationWithCaster(position, "Winterblight.BoneBlister.Explode", caster)
	    if #enemies > 0 then    
	        for _,enemy in pairs(enemies) do
	        	ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })
	        	ability:ApplyDataDrivenModifier(caster, enemy, "modifier_chilled", {duration = 5})
	        end
	    end
	end
    if ability.interval == 100 then
    	ability.interval = 0
    end
end

function star_eat_passive_think(event)
	local caster = event.caster
	local ability = event.ability
	if not ability.distance then
		ability.distance = 200
	end
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	if #enemies > 0 then
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), enemies[1]:GetAbsOrigin())
		if distance > ability.distance then
			ability.distance = math.min(ability.distance + 20, 1500)
		elseif distance < ability.distance then
			ability.distance = math.max(ability.distance - 20, 150)
		end
	end
	if not ability.fv then
		ability.fv = caster:GetForwardVector()
	end
	ability.fv = WallPhysics:rotateVector(ability.fv, 2*math.pi/32)
	local spell_position = caster:GetAbsOrigin() + ability.fv*ability.distance
	CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/star_eater_passive_ambient_hit.vpcf", spell_position, 3)
    local spell_enemies = FindUnitsInRadius( caster:GetTeamNumber(), spell_position, nil, 130, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
    EmitSoundOnLocationWithCaster(spell_position, "Winterblight.StarEater.PassiveExplode", caster)
    if #spell_enemies > 0 then    
        for _,enemy in pairs(spell_enemies) do
        	ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability })
        end
    end
end

function astral_weapon_hit(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	local damage = target:GetMaxHealth()*(event.damage_pct_target_max_health/100)
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability })
	EmitSoundOn("Winterblight.StarEater.OrbHit", target)
end

function galaxy_knight_take_damage(event)
	local caster = event.caster
	local attacker = event.attacker
	local ability = event.ability
	local freeze_duration = event.freeze_duration
	print("NOT HAPPENMOING?")
	ability:ApplyDataDrivenModifier(caster, attacker, "modifier_galaxy_knight_freeze", {duration = freeze_duration})
	EmitSoundOn("Winterblight.GalaxyKnight.Freeze", attacker)
	ApplyDamage({ victim = attacker, attacker = caster, damage = event.damage, damage_type = DAMAGE_TYPE_PURE, ability = ability })
end

function ellipsis_wave_cast(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	EmitSoundOn("Winterblight.EllipsisWave", caster)
	local fv = (point - caster:GetAbsOrigin())*Vector(1,1,0)
	fv = fv:Normalized()
	print("WAVE")
	local info =
	{
		Ability = ability,
		EffectName = "particles/roshpit/winterblight/ellipsis_wave.vpcf",
		vSpawnOrigin = caster:GetAbsOrigin() + fv * 20,
		fDistance = 1300,
		fStartRadius = 250,
		fEndRadius = 380,
		Source = caster,
		StartPosition = "attach_origin",
		bHasFrontalCone = true,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = 0,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
		vVelocity = fv * 900,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
end

function ellipsis_wave_hit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local damage = event.damage
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })
	EmitSoundOn("Winterblight.EllipsisWave.Hit", target)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_ellipsis_wave_disarm", {duration = event.disarm_duration})
end

function brain_freeze_cast(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	local unit = CreateUnitByName("npc_dummy_unit", target, false, caster, caster, caster:GetTeamNumber())
	EmitSoundOn("Winterblight.BrainFreeze.Cast", unit)
	unit:AddAbility("brain_freeze_ring_dummy_area"):SetLevel(1)
	unit:FindAbilityByName("dummy_unit"):SetLevel(1)
	unit.pfx = ParticleManager:CreateParticle("particles/roshpit/seafortress/ghost_tyrant_area_portrait.vpcf", PATTACH_CUSTOMORIGIN, unit)
	local colorVector = Vector(120, 190, 255)

	ParticleManager:SetParticleControl(unit.pfx, 0, unit:GetAbsOrigin() + Vector(0, 0, 30))
	ParticleManager:SetParticleControl(unit.pfx, 4, colorVector/255)
	EmitSoundOnLocationWithCaster(target, "Seafortress.TyrantGhost.ColorsAbility.Effect", caster)

	CustomAbilities:QuickParticleAtPoint("particles/roshpit/draghor/shapeshift_effect_white_base.vpcf", unit:GetAbsOrigin(), 2)
	Timers:CreateTimer(event.duration, function()
		ParticleManager:DestroyParticle(unit.pfx, false)
		UTIL_Remove(unit)
	end)
end

function wintertide_totem_cast(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	local unit = CreateUnitByName("npc_dummy_unit", target, false, caster, caster, caster:GetTeamNumber())
	EmitSoundOn("Winterblight.BrainFreeze.Cast", unit)
	local ward_health = 2+GameState:GetDifficultyFactor()
	unit:SetMaxHealth(ward_health)
	unit:SetBaseMaxHealth(ward_health)
	unit:SetHealth(ward_health)
	unit:AddAbility("winterblight_wintertide_totem"):SetLevel(ability:GetLevel())
	unit:SetModel("models/heroes/juggernaut/jugg_healing_ward.vmdl")
	unit:SetOriginalModel("models/heroes/juggernaut/jugg_healing_ward.vmdl")
	unit:SetForwardVector(caster:GetForwardVector())
	-- unit.pfx = ParticleManager:CreateParticle("particles/roshpit/seafortress/ghost_tyrant_area_portrait.vpcf", PATTACH_CUSTOMORIGIN, unit)
	-- local colorVector = Vector(120, 190, 255)

	-- ParticleManager:SetParticleControl(unit.pfx, 0, unit:GetAbsOrigin() + Vector(0, 0, 30))
	-- ParticleManager:SetParticleControl(unit.pfx, 4, colorVector/255)
	local life_duration = event.duration
	unit:SetOwner(caster)
	unit.dieTime = life_duration
	unit:AddAbility("ability_die_after_time_generic"):SetLevel(1)
	unit.heal_pct = event.heal_percent
	EmitSoundOnLocationWithCaster(target, "Winterblight.Wintertide.Cast", caster)
	unit:SetRenderColor(80, 140, 255)
	CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_arc_warden/arc_warden_death.vpcf", unit:GetAbsOrigin(), 2)
	Timers:CreateTimer(event.duration, function()
		-- ParticleManager:DestroyParticle(unit.pfx, false)
		UTIL_Remove(unit)
	end)
end

function wintertide_totem_think(event)
	local caster = event.caster
	local ability = event.ability
	local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #allies > 0 then
		for _, ally in pairs(allies) do
			local healAmount = math.floor(ally:GetMaxHealth() * (caster.heal_pct/100))
			Filters:ApplyHeal(caster, ally, healAmount, true)
		end
	end
end

function zero_g_init(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if target:IsRealHero() then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_wb_zero_g_hero", {})
		ability:ApplyDataDrivenModifier(caster, target, "modifier_wb_zero_g_flying", {})
		target.zero_g_target = 200
		target.zero_g_interval = 0
	else
		ability:ApplyDataDrivenModifier(caster, target, "modifier_wb_zero_g_flying", {})
		target:SetModifierStackCount("modifier_wb_zero_g_flying", caster, 200)
	end
end

function zero_g_end(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	target:RemoveModifierByName("modifier_wb_zero_g_hero")
	target:RemoveModifierByName("modifier_wb_zero_g_flying")
end

function zero_g_hero_think(event)
	local caster = event.caster
	local ability = event.ability
	local hero = event.target
	local current_stacks = hero:GetModifierStackCount("modifier_wb_zero_g_flying", caster)
	if not hero.zero_g_target then
		hero.zero_g_target = 200
		hero.zero_g_interval = 0
		
	end
	if not hero.black_hole_move_vector then
		hero.black_hole_move_vector = Vector(0,0)
	end
	hero:SetModifierStackCount("modifier_wb_zero_g_flying", caster, hero.zero_g_target)
	hero.zero_g_target = hero.zero_g_target + (2 * math.cos(2 * math.pi * hero.zero_g_interval / 180))
	hero.zero_g_interval = hero.zero_g_interval + 1
	if hero.zero_g_interval >= 180 then
		hero.zero_g_interval = 0
	end
	local black_holes = Winterblight.EdgeOfWinterBlackHoles
	local black_hole_count = 0
	local max_pull_speed = 5
	if GameState:GetDifficultyFactor() == 2 then
		max_pull_speed = 7
	elseif GameState:GetDifficultyFactor() == 3 then
		max_pull_speed = 8
	end
	if #black_holes > 0 then
		local total_move_vector = Vector(0,0)
		local total_pull_speed = 0
		for i = 1, #black_holes, 1 do
			local black_hole = black_holes[i]
			local distance = WallPhysics:GetDistance2d(hero:GetAbsOrigin(), black_hole:GetAbsOrigin())
			if distance < 1500 then
				black_hole_count = black_hole_count + 1
				local direction = WallPhysics:normalized_2d_vector(hero:GetAbsOrigin(), black_hole:GetAbsOrigin())
				hero.black_hole_move_vector = hero.black_hole_move_vector + (direction*(1500-distance))/2500
				total_pull_speed = math.max(total_pull_speed, (1500-distance/150))
			end
		end
		if hero.black_hole_move_vector:Length2D() > max_pull_speed then
			hero.black_hole_move_vector = (hero.black_hole_move_vector:Normalized())*max_pull_speed
		end
		total_pull_speed = math.min(total_pull_speed, 8)
		total_pull_speed = math.max(total_pull_speed, 1)
		hero:SetAbsOrigin(hero:GetAbsOrigin()+(hero.black_hole_move_vector))	
	end
	if black_hole_count == 0 then
		hero.black_hole_move_vector = Vector(0,0)
	end
end

function zero_g_spell_cast(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.unit
	local executedAbility = event.event_ability
	executedAbility:EndCooldown()
	local cd = 1
	if target:HasModifier("modifier_hood_of_lords_lua") then
		cd = cd + 1
	end
	executedAbility:StartCooldown(cd)
	if target:IsRealHero() then
		Timers:CreateTimer(0.03, function()
			if executedAbility:GetCooldownTimeRemaining() > 0.97 then
				executedAbility:EndCooldown()
				executedAbility:StartCooldown(cd)
			end
		end)
	end
end

function wb_black_hole_think(event)
	local ability = event.ability
	local caster = event.caster
	ParticleManager:SetParticleControl(caster.pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(caster.pfx, 1, caster:GetAbsOrigin())
	if not caster.interval then
		caster.interval = 0
	end
	caster.interval = caster.interval + 1
	if caster.interval >= 500 then
		local pos = Winterblight:RandomPointInEdgeOfWinter()
		caster:MoveToPosition(pos)
		caster.interval = 0
	end
end

function gigarraun_passive_think(event)
	local caster = event.caster
	local ability = event.ability
	local fissure_ability = caster:FindAbilityByName("gigarraun_fissure")
	local soulstorm = caster:FindAbilityByName("winterblight_soulfire_storm")
	soulstorm:SetOverrideCastPoint(0)
	if caster.total_lock then
		return false
	end
	if not caster.silence_counter then
		caster.silence_counter = 0
	end
	if caster:IsSilenced() then
		caster.silence_counter = caster.silence_counter + 1
	else
		caster.silence_counter = 0
	end
	if not caster.bkbs then
		caster.bkbs = 0
	end
	if caster.bkbs < 1 and caster:GetHealth() < caster:GetMaxHealth()*0.7 then
		local bkb = caster:FindAbilityByName("creature_black_king_bar")
		bkb:ApplyDataDrivenModifier(caster, caster, "modifier_black_King_bar_immunity", {duration = 7})
		caster.bkbs = 1
	elseif caster.bkbs < 2 and caster:GetHealth() < caster:GetMaxHealth()*0.3 then
		local bkb = caster:FindAbilityByName("creature_black_king_bar")
		bkb:ApplyDataDrivenModifier(caster, caster, "modifier_black_King_bar_immunity", {duration = 10})
		caster.bkbs = 2
	end
	if caster.silence_counter >= 6 then
		caster.silence_counter = 0
		caster.jumpBack = true
		EmitSoundOn("Winterblight.Gigarraun.Push", caster)
		StartAnimation(caster, {duration=1.8, activity=ACT_DOTA_CAST_ABILITY_2, rate=1.2})
		caster.moveDirection = caster:GetForwardVector()*-1
		caster.moveDirection = WallPhysics:rotateVector(caster.moveDirection, 2*math.pi*RandomInt(-3, 3)/20)
		caster.lift_force = 80

		ability:ApplyDataDrivenModifier(caster, caster, "modifier_gigarraun_jumping", {duration = 4})
		EmitSoundOn("Winterblight.Gigarraun.BackJump", caster)
	end
	if not caster.castLock then
		if fissure_ability:IsFullyCastable() then
		    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 3000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		    if #enemies > 0 then    
				local order =
				{
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = fissure_ability:entindex(),
					Position = enemies[1]:GetAbsOrigin(),
					Queue = true
				}
				caster:Stop()
				ExecuteOrderFromTable(order)
				caster.castLock = true
				caster.fissure_point = enemies[1]:GetAbsOrigin()
				Timers:CreateTimer(2, function()
					caster.castLock = false
				end)
		    end
		elseif soulstorm:IsFullyCastable() then
		    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		    if #enemies > 0 then    
				local order =
				{
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = soulstorm:entindex(),
					Position = enemies[1]:GetAbsOrigin(),
					Queue = true
				}
				caster:Stop()
				ExecuteOrderFromTable(order)
				caster.castLock = true
				Timers:CreateTimer(0.5, function()
					caster.castLock = false
				end)
		    end
		end
	end
end

function gigarraun_spell_cast(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.unit
	local executedAbility = event.event_ability
	if executedAbility:GetAbilityName() == "gigarraun_fissure" then
		caster.jumpBack = true
		EmitSoundOn("Winterblight.Gigarraun.Push", caster)
		StartAnimation(caster, {duration=1.8, activity=ACT_DOTA_CAST_ABILITY_2, rate=1.2})
		caster.moveDirection = caster:GetForwardVector()*-1
		caster.moveDirection = WallPhysics:rotateVector(caster.moveDirection, 2*math.pi*RandomInt(-3, 3)/20)
		caster.lift_force = 80

		ability:ApplyDataDrivenModifier(caster, caster, "modifier_gigarraun_jumping", {duration = 4})
		EmitSoundOn("Winterblight.Gigarraun.BackJump", caster)

		local particle = "particles/econ/items/earthshaker/earthshaker_ti9/earthshaker_fissure_ti9.vpcf"
		local fissure_fv = ((caster.fissure_point - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		local pfx = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin() + fissure_fv*1500)

		local pfx2 = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx2, 0, caster:GetAbsOrigin() + fissure_fv*3000)
		ParticleManager:SetParticleControl(pfx2, 1, caster:GetAbsOrigin() + fissure_fv*1500)
		Timers:CreateTimer(5, function()
			ParticleManager:DestroyParticle(pfx, false)
			ParticleManager:DestroyParticle(pfx2, false)
		end)
	elseif executedAbility:GetAbilityName() == "winterblight_soulfire_storm" then
		if not caster:HasModifier("modifier_gigarraun_jumping") then
			StartAnimation(caster, {duration=1, activity=ACT_DOTA_ATTACK, rate=1.2})
		end
		executedAbility:EndCooldown()
		executedAbility:StartCooldown(2.5)
	end
end

function gigarraun_jumping_think(event)
	local ability = event.ability
	local caster = event.caster
	local stun_duration = 1.5
	if caster.jumpBack then
		local push_force = 30
		caster.lift_force = caster.lift_force - 7
		caster:SetAbsOrigin(caster:GetAbsOrigin()+caster.moveDirection*push_force + Vector(0,0,caster.lift_force))
		local height_diff = caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster)
		CustomAbilities:QuickAttachParticle("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_echoslam_start_dust.vpcf", caster, 3)
		if caster.lift_force < 0 or height_diff < -50 then
			if height_diff < -50 then
				caster:RemoveModifierByName("modifier_gigarraun_jumping")
				CustomAbilities:QuickParticleAtPoint("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_echoslam_start.vpcf", caster:GetAbsOrigin(), 4)
				local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
				if #enemies > 0 then
					for _,enemy in pairs(enemies) do
						ApplyDamage({victim = enemy, attacker = caster, damage = event.back_damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
						Filters:ApplyStun(caster, stun_duration, enemy)
					end
				end
				EmitSoundOn("Winterblight.Gigarraun.SmallLand", caster)
				Timers:CreateTimer(0.06, function()
					FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
					caster.jumpBack = false
					local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 3000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
					if #enemies > 0 then
						Timers:CreateTimer(0.3, function()
							caster.jumpForward = true
							StartAnimation(caster, {duration=3, activity=ACT_DOTA_CAST_ABILITY_4, rate=0.2})
							caster.moveDirection = ((enemies[1]:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
							caster.lift_force = 50
							local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), enemies[1]:GetAbsOrigin())
							caster.push_force = math.max(distance/50, 10) + 10
							caster.push_force = math.min(caster.push_force, 70)
							ability:ApplyDataDrivenModifier(caster, caster, "modifier_gigarraun_jumping", {duration = 4})
							EmitSoundOn("Winterblight.Gigarraun.ForwardJump", caster)
						end)
					end
				end)
			end
		end
	elseif caster.jumpForward then
		local push_force = caster.push_force
		caster.lift_force = caster.lift_force - 3
		caster:SetAbsOrigin(caster:GetAbsOrigin()+caster.moveDirection*push_force + Vector(0,0,caster.lift_force))
		local height_diff = caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster)
		if caster.lift_force < 0 or height_diff < -50 then
			if height_diff < 0 then
				EmitSoundOn("Winterblight.Gigarraun.BigLand", caster)
				caster:RemoveModifierByName("modifier_gigarraun_jumping")
				StartAnimation(caster, {duration=2, activity=ACT_DOTA_CAST_ABILITY_4, rate=1.3})
				local damage_point = caster:GetAbsOrigin()+caster:GetForwardVector()*30
				CustomAbilities:QuickAttachParticle("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_echoslam_start_dust.vpcf", caster, 3)
				local pfx = CustomAbilities:QuickParticleAtPoint("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_echoslam_start.vpcf", damage_point, 4)
				ParticleManager:SetParticleControl(pfx, 11, Vector(100,100,100))
				local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
				if #enemies > 0 then
					for _,enemy in pairs(enemies) do
						ApplyDamage({victim = enemy, attacker = caster, damage = event.main_damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
						Filters:ApplyStun(caster, stun_duration, enemy)
					end
				end
				Timers:CreateTimer(0.06, function()
					FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
					caster.jumpForward = false
				end)
			end
		end
	end
end

function guide_tiamat_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.tiamat_interval then
		caster.tiamat_interval = 0
	end
	caster.tiamat_interval = caster.tiamat_interval + 1
	if caster.tiamat_interval%10 == 0 then
		AddFOWViewer(DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), 500, 2, false)
	end
	if caster.tiamat_phase == -1 then
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_ogre_magi/waterheart_weapon_buff_tornado.vpcf", caster, 2)
		caster.liftSpeed = caster.liftSpeed + 0.05
		caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,caster.liftSpeed))
		if caster.liftSpeed > 8 then
			EmitSoundOn("Winterblight.CavernGuide.Tornado", caster)
			EmitSoundOn("Winterblight.CaveGuide.StartTiamat.VO", caster)
			caster.tiamat_phase = 0
			StartAnimation(caster, {duration=7, activity=ACT_DOTA_RUN, rate=1.3, translate="surge"})
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_guide_travelling", {})
			caster:AddNoDraw()
		end
	elseif caster.tiamat_phase == 0 then
		if caster.tiamat_interval%30 == 0 then
			-- EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.GuideCaveIntro2", Events.GameMaster)
			-- CustomAbilities:QuickAttachParticle("particles/econ/events/ti9/shovel/shovel_baby_roshan_spawn.vpcf", caster, 4)
			-- CustomAbilities:QuickAttachParticle("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_spawn.vpcf", caster, 4)
		end
		caster.goSpeed = math.min(caster.goSpeed + 0.5, 60)
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_ogre_magi/waterheart_weapon_buff_tornado.vpcf", caster, 2)
		local divisor = math.max(100-caster.goSpeed, 10)
		local fv = WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi/divisor)
		caster:SetForwardVector(fv)
		local target_point = GetGroundPosition(Vector(-13056, 256), caster)
		local direction = ((target_point - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		local up_vector = Vector(0,0,0)
		if caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin()+direction*50, caster) < 300 then
			up_vector = Vector(0,0,15)
		end
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), target_point)
		if distance < 1500 then
			up_vector = Vector(0,0,25)
		end
		up_vector = up_vector + Vector(0,0,math.cos(2*math.pi*caster.tiamat_interval))*2
		caster:SetAbsOrigin(caster:GetAbsOrigin()+direction*caster.goSpeed+up_vector)
		if distance < 100 then
			StartAnimation(caster, {duration=1.2, activity=ACT_DOTA_RUN, rate=2.0})
			caster:RemoveNoDraw()
			caster:RemoveModifierByName("modifier_guide_travelling")
			caster.tiamat_phase = 1
			caster.fallSpeed = 5
			caster:SetForwardVector(Vector(0,1))
			EmitSoundOn("Winterblight.GuideCave.Magical", caster)
			caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,0))
		end
	elseif caster.tiamat_phase == 1 then
		caster.fallSpeed = caster.fallSpeed + 0.3
		caster:SetAbsOrigin(caster:GetAbsOrigin() - Vector(0,0,caster.fallSpeed))
		if caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster) < 30 then
			StartAnimation(caster, {duration=2, activity=ACT_DOTA_CAST_ABILITY_1, rate=1.0})
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.GuideCaveIntro", Events.GameMaster)
			CustomAbilities:QuickAttachParticle("particles/econ/events/ti9/shovel/shovel_baby_roshan_spawn.vpcf", caster, 4)
			CustomAbilities:QuickParticleAtPoint("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_spawn.vpcf", caster:GetAbsOrigin(), 4)
			caster.tiamat_phase = 2
			ScreenShake(caster:GetAbsOrigin(), 360, 0.5, 0.5, 2000, 0, true)
			Timers:CreateTimer(0.3, function()
				EmitSoundOn("Winterblight.CaveGuide.StartTiamat.Land.VO", caster)
			end)
			Timers:CreateTimer(2, function()
				caster.boss_table = {}
				local icePos = caster:GetAbsOrigin()
				EmitSoundOnLocationWithCaster(icePos, "Winterblight.Ozubu.Passive", caster)
				local particle = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
				local pfx2 = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
				local radius = 900
				ParticleManager:SetParticleControl(pfx2, 0, icePos)
				ParticleManager:SetParticleControl(pfx2, 1, Vector(radius, 2, radius * 2))
				Timers:CreateTimer(2.5, function()
					ParticleManager:DestroyParticle(pfx2, false)
				end)

				StartAnimation(caster, {duration=2, activity=ACT_DOTA_CAST_ABILITY_1, rate=1.0})
				EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.GuideCaveIntro2", Events.GameMaster)
				CustomAbilities:QuickAttachParticle("particles/econ/events/ti9/shovel/shovel_baby_roshan_spawn.vpcf", caster, 4)
				CustomAbilities:QuickParticleAtPoint("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_spawn.vpcf", caster:GetAbsOrigin(), 4)

				local unitTable = {"descent_of_winterblight_torturok", "descent_of_winterblight_aertega", "descent_of_winterblight_ozubu", "winterblight_cavern_gigarraun"}
				for i = 1, #unitTable, 1 do
					local fv = WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi*i/4)
					fv = WallPhysics:rotateVector(fv, 2*math.pi/8)
					local position = caster:GetAbsOrigin() + fv*300
					local boss = CreateUnitByName(unitTable[i], position, false, nil, nil, DOTA_TEAM_GOODGUYS)
					boss.castLock = true
					boss.total_lock = true
					ability:ApplyDataDrivenModifier(caster, boss, "modifier_boss_disable_effect", {})
					CustomAbilities:QuickParticleAtPoint("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_spawn.vpcf", boss:GetAbsOrigin(), 4)
					boss:SetModelScale(0.6)
					CustomAbilities:QuickParticleAtPoint("particles/roshpit/draghor/shapeshift_effect_blue_base.vpcf", boss:GetAbsOrigin(), 4)
					boss:SetForwardVector(Vector(0,-1))

					local icePos = caster:GetAbsOrigin()
					EmitSoundOnLocationWithCaster(icePos, "Winterblight.Ozubu.Passive", caster)
					local particle = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
					local pfx = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
					local radius = 400
					ParticleManager:SetParticleControl(pfx, 0, icePos)
					ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 2, radius * 2))
					Timers:CreateTimer(2.5, function()
						ParticleManager:DestroyParticle(pfx, false)
					end)

					table.insert(caster.boss_table, boss)
				end
				
			end)
			Timers:CreateTimer(3.5, function()
				local relic_dummy_count = 20
				caster.relic_table = {}
				StartAnimation(caster, {duration=2, activity=ACT_DOTA_CAST_ABILITY_4, rate=1.0})
				EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.Cavern.RelicPop", caster)
				CustomAbilities:QuickAttachParticle("particles/econ/events/ti9/shovel/shovel_baby_roshan_spawn.vpcf", caster, 4)
				CustomAbilities:QuickParticleAtPoint("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_spawn.vpcf", caster:GetAbsOrigin(), 4)
				for i = 1, relic_dummy_count, 1 do
					local crystal = CreateUnitByName("npc_dummy_unit", caster:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_NEUTRALS)
					crystal:SetModelScale(0.9)
					crystal:SetOriginalModel("models/props_gameplay/rune_illusion01.vmdl")
					crystal:SetModel("models/props_gameplay/rune_illusion01.vmdl")
					local displacementVector = WallPhysics:rotateVector(Vector(1,1), 2*math.pi*i/relic_dummy_count)
					crystal:SetAbsOrigin(caster:GetAbsOrigin()+displacementVector*20)

					Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, crystal, "modifier_relic_fragment_think", {})
					crystal:FindAbilityByName("dummy_unit"):SetLevel(1)	
					local targetDirection = ((crystal:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
					-- targetDirection = (targetDirection*24 + RandomVector(1)):Normalized()
					CustomAbilities:QuickParticleAtPoint("particles/econ/courier/courier_wyvern_hatchling/courier_wyvern_anim_goldbreath.vpcf", crystal:GetAbsOrigin()+Vector(0,0,30), 4)
					crystal.phase = 0
					crystal.direction = targetDirection
					crystal.pushForce = 9
					crystal.liftForce = 18
					crystal.hero = caster
					crystal.relics = 0
					crystal.chamber = 0
					crystal.event_index = 0
					crystal.tiamat_sequence = true
					StartAnimation(crystal, {duration=100, activity=ACT_DOTA_IDLE, rate=1})
					table.insert(caster.relic_table, crystal)
				end
				Timers:CreateTimer(2, function()
					caster.tiamat_phase = 3
					StartAnimation(caster, {duration=4.5, activity=ACT_DOTA_CAST_ABILITY_2, rate=0.24})
					EmitSoundOn("Winterblight.CaveGuide.PullingRelics", caster)
					Timers:CreateTimer(4, function()
						caster.tiamat_phase = 4
					end)
				end)
			end)
		end
	elseif caster.tiamat_phase == 3 then
		for i = 1, #caster.boss_table, 1 do
			local unit = caster.boss_table[i]
			local current_displacement = ((unit:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
			local new_displacement = WallPhysics:rotateVector(current_displacement, 2*math.pi/50)
			local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), unit:GetAbsOrigin())
			local new_distance = math.max(0, distance-1.5)
			unit:SetAbsOrigin(caster:GetAbsOrigin() + new_displacement*new_distance + Vector(0,0,2))
		end
		for i = 1, #caster.relic_table, 1 do
			local unit = caster.relic_table[i]
			local current_displacement = ((unit:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
			local new_displacement = WallPhysics:rotateVector(current_displacement, -2*math.pi/70)
			local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), unit:GetAbsOrigin())
			local new_distance = math.max(0, distance-1)
			unit:SetAbsOrigin(caster:GetAbsOrigin() + new_displacement*new_distance + Vector(0,0,2))
		end

	elseif caster.tiamat_phase == 4 then
		caster.tiamat_phase = 5
		for j = 0, 3, 1 do
			Timers:CreateTimer(j*0.3, function()
				local particleName = "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf"
				local radius = 600
				local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, nil)
				local origin = caster:GetAbsOrigin()
				ParticleManager:SetParticleControl(particle1, 0, origin + Vector(0, 0, 20))
				ParticleManager:SetParticleControl(particle1, 1, Vector(radius, 1, 1000))
				ParticleManager:SetParticleControl(particle1, 3, Vector(500, 500, 500))
				Timers:CreateTimer(3, function()
					ParticleManager:DestroyParticle(particle1, false)
				end)
			end)
		end
		for i = 1, #caster.boss_table, 1 do
			local unit = caster.boss_table[i]
			-- CustomAbilities:QuickParticleAtPoint("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_spawn.vpcf", unit:GetAbsOrigin(), 1)
			UTIL_Remove(unit)
		end
		for i = 1, #caster.relic_table, 1 do
			local unit = caster.relic_table[i]
			CustomAbilities:QuickParticleAtPoint("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_spawn.vpcf", unit:GetAbsOrigin(), 1)
			UTIL_Remove(unit)
		end
		caster.boss_table = nil
		caster.relic_table = nil
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.BossOut", caster)
		ScreenShake(caster:GetAbsOrigin(), 800, 1.0, 1.0, 9000, 0, true)
	elseif caster.tiamat_phase == 5 then
		caster.tiamat_phase = 6
		local particleName = "particles/roshpit/winterblight/azalea_orb.vpcf"
		local orbPos = caster:GetAbsOrigin()+Vector(0,0,400)
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, orbPos)
		ParticleManager:SetParticleControl(pfx, 1, orbPos)
		ParticleManager:SetParticleControl(pfx, 2, Vector(700, 700, 700))
		ParticleManager:SetParticleControl(pfx, 3, Vector(700, 700, 700))
		Winterblight.tiamat_sequence_orb = {}
		Winterblight.tiamat_sequence_orb.pfx = pfx
		Winterblight.tiamat_sequence_orb.final_pos = orbPos+Vector(0,5000,-800)
		Timers:CreateTimer(3, function()
			ParticleManager:SetParticleControl(Winterblight.tiamat_sequence_orb.pfx, 1, orbPos+Vector(0,5000,-800))
		end)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_guide_travelling", {})
		caster:AddNoDraw()
		caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,100))
		Timers:CreateTimer(2, function()
			caster.liftSpeed = 1
			caster.tiamat_phase = 7
			Timers:CreateTimer(4, function()
				local hero = caster.sequence_hero
				caster.tiamat_phase = 8
				caster:RemoveModifierByName("modifier_guide_travelling")
				caster:RemoveNoDraw()
				UTIL_Remove(caster)
				Timers:CreateTimer(5.5, function()
					Winterblight:MainTiamatSpawn(hero)
				end)
			end)
		end)
		-- UTIL_Remove(caster)
	elseif caster.tiamat_phase == 7 then
		caster.liftSpeed = caster.liftSpeed + 0.3
		caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,caster.liftSpeed))
	end
end

function tiamat_charge_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	ability.fv = ((target - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	ability.perpFV = WallPhysics:rotateVector(ability.fv, 2 * math.pi / 4)
	ability.targetPoint = target
	local warpDuration = 3.0
	ability.fallVelocity = 1
	ability.forwardVelocity = 42

	local max_distance = 2000
	ability.max_distance = max_distance
	ability.distance_travelled = 0
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_dinath_scorch_charge_flying", {duration = warpDuration})

	local totalFlyDistance = math.min(WallPhysics:GetDistance2d(caster:GetAbsOrigin(), target), max_distance)
	EmitSoundOn("Tiamat.DiveStart", caster)
	EmitSoundOn("Tiamat.ChargeVO", caster)
	local charge_duration = totalFlyDistance / 30
	ability.fly_distance = totalFlyDistance
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_buff.vpcf", caster, charge_duration)
	StartAnimation(caster, {duration=2, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.4})
	local fireThinker = CreateUnitByName("npc_dummy_unit", caster:GetAbsOrigin(), false, nil, nil, caster:GetTeamNumber())
	fireThinker:FindAbilityByName("dummy_unit"):SetLevel(1)
	local fireDuration = get_tiamat_fire_fire_duration(caster)
	local arctic_burn = caster:FindAbilityByName("tiamat_fire_breath")
	fireThinker.line = true
	fireThinker.fv = ability.fv
	fireThinker.distance = max_distance
	fireThinker.distance_travelled = 0
	ability.interval = 0
	ability.current_fire_thinker = fireThinker
	arctic_burn:ApplyDataDrivenModifier(caster, fireThinker, "modifier_tiamat_fire_fire_thinker", {duration = fireDuration})
	ability.fireDuration = fireDuration
	Timers:CreateTimer(fireDuration, function()
		UTIL_Remove(fireThinker)
	end)
end

function tiamat_charge_think(event)
	local caster = event.caster
	local ability = event.ability

	ability.forwardVelocity = math.max(ability.forwardVelocity - 0.5, 32)

	local blockSearch = caster:GetAbsOrigin() * Vector(1, 1, 0) + Vector(0, 0, GetGroundHeight(caster:GetAbsOrigin(), caster))
	local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch + ability.fv * 45), caster)
	local forwardSpeed = ability.forwardVelocity
	if blockUnit then
		forwardSpeed = 0
	end
	ability.distance_travelled = ability.distance_travelled + ability.forwardVelocity
	-- ability.current_fire_thinker.distance = ability.current_fire_thinker.distance + ability.forwardVelocity
	caster:SetAbsOrigin(caster:GetAbsOrigin() + ability.fv * forwardSpeed)

	ability.interval = ability.interval + 1
	if ability.interval % 3 == 0 then
		for i = -2, 2, 1 do
			local perpMult = 90*i
			local position = caster:GetAbsOrigin() + ability.perpFV * perpMult
			local pfx = ParticleManager:CreateParticle("particles/roshpit/winterblight/tiamat_fire.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx, 0, position)
			ParticleManager:SetParticleControl(pfx, 11, Vector(0.3, 0.3, 0.3))
			Timers:CreateTimer(ability.fireDuration, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
		end
	end
	if ability.distance_travelled >= (ability.fly_distance - 5) then
		caster:RemoveModifierByName("modifier_dinath_scorch_charge_flying")
		local slideDuration = ability.forwardVelocity * 0.03
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_dinath_scorch_charge_slide", {duration = slideDuration})
	end
end

function tiamat_charge_sliding(event)
	local caster = event.caster
	local ability = event.ability

	ability.forwardVelocity = math.max(ability.forwardVelocity - 1, 0)

	local blockSearch = caster:GetAbsOrigin() * Vector(1, 1, 0) + Vector(0, 0, GetGroundHeight(caster:GetAbsOrigin(), caster))
	local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch + ability.fv * 45), caster)
	local forwardSpeed = ability.forwardVelocity
	if blockUnit then
		forwardSpeed = 0
	end
	ability.interval = ability.interval + 1
	if ability.interval % 3 == 0 then
		for i = -2, 2, 1 do
			local perpMult = 60*i
			local position = caster:GetAbsOrigin() + ability.perpFV * perpMult
			local pfx = ParticleManager:CreateParticle("particles/roshpit/winterblight/tiamat_fire.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx, 0, position)
			ParticleManager:SetParticleControl(pfx, 11, Vector(0.3, 0.3, 0.3))
			Timers:CreateTimer(3, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
		end
	end
	ability.distance_travelled = ability.distance_travelled + ability.forwardVelocity
	caster:SetAbsOrigin(caster:GetAbsOrigin() + ability.fv * forwardSpeed)
	if ability.forwardVelocity <= 3 then
		caster:RemoveModifierByName("modifier_dinath_scorch_charge_slide")
	end
end

function tiamat_fly_out_phase(event)
	local caster = event.caster
	local ability = event.ability
	ability.flyout_phase_interval = ability.flyout_phase_interval + 1
	caster:SetHealth(caster:GetHealth() + caster:GetMaxHealth()*0.001)
	if ability.flyout_main_phase == 0 then
		caster:SetAbsOrigin(caster:GetAbsOrigin() + caster:GetForwardVector()*20 + Vector(0,0,32))
		if ability.flyout_phase_interval >= 100 then
			ability.flyout_main_phase = 1
			caster:SetSkin(3)
		end
	elseif ability.flyout_main_phase == 1 then
		if ability.flyout_phase_interval%40 == 0 then
			for i = 1, #MAIN_HERO_TABLE, 1 do
				local eventTable = {}
				eventTable.caster = caster
				eventTable.ability = caster:FindAbilityByName("tiamat_fire_breath")
				eventTable.target_points = {}
				eventTable.target_points[1] = MAIN_HERO_TABLE[i]:GetAbsOrigin()
				tiamat_fire_finish_channel(eventTable)
			end
		end
		if ability.flyout_phase_interval >= 950 then
			ability.flyout_main_phase = 2
			caster.combat_phase = 2
			caster:AddAbility("winterblight_crystal_meditation"):SetLevel(1)
			caster:AddAbility("orthok_split_attack"):SetLevel(1)
		end
	elseif ability.flyout_main_phase == 2 then
		caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,32))
		if caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster) < 100 then
			caster:RemoveModifierByName("modifier_boss_between_phase")
			EmitSoundOn("Tiamat.PhaseRoar2", caster)
			AddFOWViewer(DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), 1500, 3, false)
		end
	end
end

function tiamat_boss_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.phase then
		caster.phase = 0
	end
	if not ability.interval then
		ability.interval = 0
	end
	if not caster.combat_phase then
		caster.combat_phase = 0
	end
	ability.interval = ability.interval + 1
	if caster.dying and ability.interval%10 == 0 then
		StartAnimation(caster, {duration=2, activity=ACT_DOTA_CAST_ABILITY_4, rate=0.4})
	end
	if caster.dying then
		return false
	end
	if caster:GetHealth() < 1000 and not caster.phaseLock then
		if caster.combat_phase == 0 then
			caster.combat_phase = 1
			ability.flyout_phase_interval = 0
			ability.flyout_main_phase = 0
			EmitSoundOn("Tiamat.PhaseRoar", caster)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_boss_between_phase", {})
		elseif caster.combat_phase == 2 then
			Winterblight:TiamatBossDie(caster)
		end
	end
	if not caster.castLock then
		if not caster:HasModifier("modifier_boss_between_phase") then
			local charge_ability = caster:FindAbilityByName("tiamat_scorch_charge")
			if charge_ability:IsFullyCastable() then
			    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			    if #enemies > 0 then
			    	local targetDirection = ((enemies[1]:GetAbsOrigin() - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
			    	local target_point = caster:GetAbsOrigin()+targetDirection*RandomInt(1200, 2200)
					local order =
					{
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
						AbilityIndex = charge_ability:entindex(),
						Position = target_point,
						Queue = true
					}
					caster:Stop()
					ExecuteOrderFromTable(order)
					caster.castLock = true
					Timers:CreateTimer(0.8, function()
						caster.castLock = false
					end)
			    end
			end
			local fire_ability = caster:FindAbilityByName("tiamat_fire_breath")
			if fire_ability:IsFullyCastable() then
			    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			    if #enemies > 0 then
			    	local target_point = enemies[1]:GetAbsOrigin()
					local order =
					{
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
						AbilityIndex = fire_ability:entindex(),
						Position = target_point,
						Queue = true
					}
					caster:Stop()
					ExecuteOrderFromTable(order)
					caster.castLock = true
					Timers:CreateTimer(0.8, function()
						caster.castLock = false
					end)
			    end
			end
		end
	end	
	if ability.interval >= 80 then
		ability.interval = 0
	end
end

function tiamat_fire_finish_channel(event)
	local caster = event.caster
	local ability = event.ability
	
	local cast_point = event.target_points[1]
	local position = caster:GetAbsOrigin() + caster:GetForwardVector() * 120
	local bomb_count = 3
	if caster.combat_phase == 2 then
		bomb_count = 5
	end
	for i = 1, bomb_count, 1 do
		local target = cast_point + RandomVector(RandomInt(0, 1500))
		local bomb = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, caster:GetTeamNumber())
		local flightStacks = 340
		bomb:SetAbsOrigin(((caster:GetAbsOrigin() + caster:GetForwardVector() * 190) * Vector(1, 1, 0)) + Vector(0, 0, caster:GetAbsOrigin().z + 70 + flightStacks))

		local distanceToTarget = WallPhysics:GetDistance2d(target, bomb:GetAbsOrigin())

		bomb:FindAbilityByName("dummy_unit"):SetLevel(1)
		bomb.interval = 0
		ability:ApplyDataDrivenModifier(caster, bomb, "modifier_tiamat_fire_bomb", {})
		bomb.fv = ((target - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
		if not ability.bombTable then
			ability.bombTable = {}
		end
		local pfx = ParticleManager:CreateParticle("particles/roshpit/dinath/arctic_burn_bomb_ball_lightning.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, bomb:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 2, Vector(10, 10, 10))
		bomb.pfx = pfx
		bomb.speed = 27
		bomb.size = 10

		bomb.explosionSize = 4

		local ticksToReachEnd = distanceToTarget / bomb.speed
		bomb:SetDayTimeVisionRange(200)
		bomb:SetNightTimeVisionRange(200)
		bomb.distanceTravelled = 0
		bomb.downSpeed = math.min((bomb:GetAbsOrigin().z - GetGroundHeight(target, bomb)) / ticksToReachEnd, 70)
		ability.channeledBeam = bomb
		table.insert(ability.bombTable, bomb)
		EmitSoundOn("Tiamat.FireBomb.Launch", caster)
		Filters:CastSkillArguments(1, caster)
		Timers:CreateTimer(0.05, function()
			fire_tiamat_fire_bomb(caster, ability, bomb)
		end)
		if caster:HasModifier("modifier_tiamat_fire_freecast") then
			ability:EndCooldown()
			local stacks = caster:GetModifierStackCount("modifier_tiamat_fire_freecast", caster) - 1
			if stacks > 0 then
				caster:SetModifierStackCount("modifier_tiamat_fire_freecast", caster, stacks)
			else
				caster:RemoveModifierByName("modifier_tiamat_fire_freecast")
			end
		end
	end
end

function fire_tiamat_fire_bomb(caster, ability, bomb)
	bomb.launched = true
	-- StartAnimation(caster, {duration=1.5, activity=ACT_DOTA_CAST_ABILITY_2, rate=1.0})
	Timers:CreateTimer(0.2, function()
		if not ability.dragonVOlock then
			ability.dragonVOlock = true
			EmitSoundOn("Tiamat.HyperBeam.EndVO", caster)
			Timers:CreateTimer(1, function()
				ability.dragonVOlock = false
			end)
		end
	end)
end

function tiamat_fire_orb_thinking(event)
	local bomb = event.target
	local caster = event.caster
	local ability = event.ability
	ParticleManager:SetParticleControl(bomb.pfx, 0, bomb:GetAbsOrigin())
	bomb.size = math.min(bomb.size + 5, 120)
	ParticleManager:SetParticleControl(bomb.pfx, 2, Vector(bomb.size, bomb.size, bomb.size))
	if bomb.launched then
		local downVector = Vector(0, 0, -bomb.downSpeed)
		-- bomb.speed = math.max(bomb.speed - 0.7, 20)
		local forwardMovement = bomb.speed
		if bomb:GetAbsOrigin().z > GetGroundHeight(bomb:GetAbsOrigin(), bomb) + 0 then
			bomb:SetAbsOrigin(bomb:GetAbsOrigin() + bomb.fv * forwardMovement + downVector)
		else
			bomb:RemoveModifierByName("modifier_tiamat_fire_bomb")
			tiamat_fire_bomb_explosion(bomb, caster, ability, bomb.explosionSize)
			Timers:CreateTimer(0.03, function()
				UTIL_Remove(bomb)
				reindex_tiamat_fire_bombs(ability)
			end)
			ParticleManager:DestroyParticle(bomb.pfx, false)
		end

		bomb.interval = bomb.interval + 1
	end
end

function tiamat_fire_bomb_explosion(bomb, caster, ability, aoeSize)

	local explosionPoint = GetGroundPosition(bomb:GetAbsOrigin(), bomb)

	local fireThinker = CreateUnitByName("npc_dummy_unit", explosionPoint, false, nil, nil, caster:GetTeamNumber())
	fireThinker:FindAbilityByName("dummy_unit"):SetLevel(1)
	local radius = 180
	if aoeSize == 2 then
		radius = 290
	elseif aoeSize == 3 then
		radius = 400
	elseif aoeSize == 4 then
		radius = 500
	end
	fireThinker.radius = radius

	fireThinker:SetDayTimeVisionRange(radius)
	fireThinker:SetNightTimeVisionRange(radius)
	EmitSoundOn("Timat.FireBomb.ImpactSound", bomb)
	local pfxTable = {}
	if aoeSize > 1 then
		local pfx = ParticleManager:CreateParticle("particles/roshpit/winterblight/tiamat_fire.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, explosionPoint)
		ParticleManager:SetParticleControl(pfx, 11, Vector(0.3, 0.3, 0.3))
		table.insert(pfxTable, pfx)
	else
		for i = 1, 4, 1 do
			local position = explosionPoint + WallPhysics:rotateVector(Vector(0, 1), 2 * math.pi * i / 4) * 60
			local pfx = ParticleManager:CreateParticle("particles/roshpit/winterblight/tiamat_fire.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx, 0, position)
			ParticleManager:SetParticleControl(pfx, 11, Vector(0.3, 0.3, 0.3))
			table.insert(pfxTable, pfx)
		end
	end
	if aoeSize >= 2 then
		for i = 1, 6, 1 do
			local position = explosionPoint + WallPhysics:rotateVector(Vector(0, 1), 2 * math.pi * i / 6) * 120
			local pfx = ParticleManager:CreateParticle("particles/roshpit/winterblight/tiamat_fire.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx, 0, position)
			ParticleManager:SetParticleControl(pfx, 11, Vector(0.3, 0.3, 0.3))
			table.insert(pfxTable, pfx)
		end
	end
	if aoeSize >= 3 then
		for i = 1, 12, 1 do
			local position = explosionPoint + WallPhysics:rotateVector(Vector(0, 1), 2 * math.pi * i / 12) * 240
			local pfx = ParticleManager:CreateParticle("particles/roshpit/winterblight/tiamat_fire.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx, 0, position)
			ParticleManager:SetParticleControl(pfx, 11, Vector(0.3, 0.3, 0.3))
			table.insert(pfxTable, pfx)
		end
	end
	if aoeSize >= 4 then
		for i = 1, 18, 1 do
			local position = explosionPoint + WallPhysics:rotateVector(Vector(0, 1), 2 * math.pi * i / 18) * 360
			local pfx = ParticleManager:CreateParticle("particles/roshpit/winterblight/tiamat_fire.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx, 0, position)
			ParticleManager:SetParticleControl(pfx, 11, Vector(0.3, 0.3, 0.3))
			table.insert(pfxTable, pfx)
		end
	end
	local fireDuration = get_tiamat_fire_fire_duration(caster)
	ability:ApplyDataDrivenModifier(caster, fireThinker, "modifier_tiamat_fire_fire_thinker", {duration = fireDuration})
	Timers:CreateTimer(fireDuration, function()
		for i = 1, #pfxTable, 1 do
			ParticleManager:DestroyParticle(pfxTable[i], false)
		end
		UTIL_Remove(fireThinker)
	end)
end

function get_tiamat_fire_fire_duration(caster)
	local fireDuration = 6
	return fireDuration
end

function reindex_tiamat_fire_bombs(ability)
	local newTable = {}
	for i = 1, #ability.bombTable, 1 do
		local beam = ability.bombTable[i]
		if IsValidEntity(beam) then
			table.insert(newTable, beam)
		end
	end
	ability.bombTable = newTable
end

function tiamat_fire_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local damage = event.damage
	local fire_thinker = event.target
	damage = event.damage
	local enemies = nil
	if fire_thinker.line then
		if fire_thinker.distance_travelled < fire_thinker.distance then
			fire_thinker.distance_travelled = fire_thinker.distance_travelled + 300
		end
		enemies = FindUnitsInLine(caster:GetTeamNumber(), fire_thinker:GetAbsOrigin(), fire_thinker:GetAbsOrigin() + fire_thinker.fv * fire_thinker.distance_travelled, nil, 380, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0)
	else
		enemies = FindUnitsInRadius(caster:GetTeamNumber(), fire_thinker:GetAbsOrigin(), nil, fire_thinker.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	end
	if #enemies > 0 then
		for i = 1, #enemies, 1 do
			local enemy = enemies[i]
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_Q, RPC_ELEMENT_DRAGON, RPC_ELEMENT_FIRE)
		end
	end
end

function tiamat_ice_attack_land(event)
	local caster = event.caster
	local victim = event.target
	local ability = event.ability
	local damage = event.damage
	local icePoint = victim:GetAbsOrigin()
	local radius = 600
	EmitSoundOnLocationWithCaster(icePoint, "hero_Crystal.freezingField.explosion", caster)
	local particle = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
	local pfx = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, icePoint)
	ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 2, radius * 2))
	Timers:CreateTimer(2.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), icePoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_frostburn_gauntlets_slow", {duration = 3})
			ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
		end
	end
end