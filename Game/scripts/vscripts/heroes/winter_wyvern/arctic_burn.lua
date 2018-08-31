function arctic_burn_finish_channel(event)
	local caster = event.caster
	local ability = event.ability
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]

	local position = caster:GetAbsOrigin() + caster:GetForwardVector()*120
	local bomb = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, caster:GetTeamNumber())
	local flightStacks = caster:GetModifierStackCount("modifier_dinath_postflight_zheight", caster)
	bomb:SetAbsOrigin(((caster:GetAbsOrigin() + caster:GetForwardVector()*120)*Vector(1,1,0))+Vector(0,0,caster:GetAbsOrigin().z+70+flightStacks))

	local distanceToTarget = WallPhysics:GetDistance2d(target, bomb:GetAbsOrigin())

	bomb:FindAbilityByName("dummy_unit"):SetLevel(1)
	bomb.interval = 0
	ability:ApplyDataDrivenModifier(caster, bomb, "modifier_arctic_burn_bomb", {})
	bomb.fv = ((target - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	if not ability.bombTable then
		ability.bombTable = {}
	end
	local pfx = ParticleManager:CreateParticle("particles/roshpit/dinath/arctic_burn_bomb_ball_lightning.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, bomb:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 2, Vector(10, 10, 10))
	bomb.pfx = pfx
	bomb.speed = 30
	bomb.size = 10
	bomb.explosionSize = 1
	local heightFromGround = bomb:GetAbsOrigin().z - GetGroundHeight(target, bomb)
	if heightFromGround >= 200 then
		bomb.explosionSize = 2
	end
	if heightFromGround >= 400 then
		bomb.explosionSize = 3
	end
	local ticksToReachEnd = distanceToTarget/bomb.speed
	bomb:SetDayTimeVisionRange(200)
	bomb:SetNightTimeVisionRange(200)
	bomb.distanceTravelled = 0
	bomb.downSpeed = math.min((bomb:GetAbsOrigin().z- GetGroundHeight(target, bomb)) /ticksToReachEnd, 70)
	ability.channeledBeam = bomb
	table.insert(ability.bombTable, bomb)
	EmitSoundOn("Dinath.FireBomb.Launch", caster)
	Filters:CastSkillArguments(1, caster)
	Timers:CreateTimer(0.05, function()
		fire_arctic_burn_bomb(caster, ability, bomb)
	end)
	ability.q_1_level = caster:GetRuneValue("q", 1)
	ability.q_4_level = caster:GetRuneValue("q", 4)
	if caster:HasModifier("modifier_arctic_burn_freecast") then
		ability:EndCooldown()
		local stacks = caster:GetModifierStackCount("modifier_arctic_burn_freecast", caster) - 1
		if stacks > 0 then
			caster:SetModifierStackCount("modifier_arctic_burn_freecast", caster, stacks)
		else
			caster:RemoveModifierByName("modifier_arctic_burn_freecast")
		end
	end
end

function fire_arctic_burn_bomb(caster, ability, bomb)
	bomb.launched = true
	-- StartAnimation(caster, {duration=1.5, activity=ACT_DOTA_CAST_ABILITY_2, rate=1.0})
	Timers:CreateTimer(0.2, function()
		if not ability.dragonVOlock then
			ability.dragonVOlock = true
			EmitSoundOn("Dinath.bomb.EndVO", caster)
			Timers:CreateTimer(1, function()
				ability.dragonVOlock = false
			end)
		end
	end)
end

function arctic_burn_orb_thinking(event)
	local bomb = event.target
	local caster = event.caster
	local ability = event.ability
	ParticleManager:SetParticleControl(bomb.pfx, 0, bomb:GetAbsOrigin())
	bomb.size = math.min(bomb.size + 5, 120)
	ParticleManager:SetParticleControl(bomb.pfx, 2, Vector(bomb.size, bomb.size, bomb.size))
	if bomb.launched then
		local downVector = Vector(0,0,-bomb.downSpeed)
		-- bomb.speed = math.max(bomb.speed - 0.7, 20)
		local forwardMovement = bomb.speed
		if bomb:GetAbsOrigin().z > GetGroundHeight(bomb:GetAbsOrigin(), bomb) + 0 then
			bomb:SetAbsOrigin(bomb:GetAbsOrigin() + bomb.fv*forwardMovement + downVector)
		else
			bomb:RemoveModifierByName("modifier_arctic_burn_bomb")
			arctic_burn_bomb_explosion(bomb, caster, ability, bomb.explosionSize)
			Timers:CreateTimer(0.03, function()
				UTIL_Remove(bomb)
				reindex_arctic_bombs(ability)
			end)
			ParticleManager:DestroyParticle(bomb.pfx, false)			
		end


		bomb.interval = bomb.interval + 1
	end
end

function arctic_burn_bomb_explosion(bomb, caster, ability, aoeSize)

	local explosionPoint = GetGroundPosition(bomb:GetAbsOrigin(), bomb)

	local fireThinker = CreateUnitByName("npc_dummy_unit", explosionPoint, false, nil, nil, caster:GetTeamNumber())
	fireThinker:FindAbilityByName("dummy_unit"):SetLevel(1)
	local radius = 180
	if aoeSize == 2 then
		radius = 290
	elseif aoeSize == 3 then
		radius = 400
	end
	fireThinker.radius = radius

	fireThinker:SetDayTimeVisionRange(radius)
	fireThinker:SetNightTimeVisionRange(radius)
	EmitSoundOn("Dinath.FireBomb.ImpactSound"..aoeSize, bomb)
	local pfxTable = {}
	if aoeSize > 1 then
		local pfx = ParticleManager:CreateParticle("particles/roshpit/dinath/fire_bomb.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, explosionPoint)
		ParticleManager:SetParticleControl(pfx, 11, Vector(0.3,0.3,0.3))
		table.insert(pfxTable, pfx)
	else
		for i = 1, 4, 1 do
			local position = explosionPoint + WallPhysics:rotateVector(Vector(0,1), 2*math.pi*i/4)*60
			local pfx = ParticleManager:CreateParticle("particles/roshpit/dinath/fire_bomb.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx, 0, position)
			ParticleManager:SetParticleControl(pfx, 11, Vector(0.3,0.3,0.3))
			table.insert(pfxTable, pfx)
		end
	end
	if aoeSize >= 2 then
		for i = 1, 6, 1 do
			local position = explosionPoint + WallPhysics:rotateVector(Vector(0,1), 2*math.pi*i/6)*120
			local pfx = ParticleManager:CreateParticle("particles/roshpit/dinath/fire_bomb.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx, 0, position)
			ParticleManager:SetParticleControl(pfx, 11, Vector(0.3,0.3,0.3))
			table.insert(pfxTable, pfx)
		end
	end
	if aoeSize >= 3 then
		for i = 1, 12, 1 do
			local position = explosionPoint + WallPhysics:rotateVector(Vector(0,1), 2*math.pi*i/12)*240
			local pfx = ParticleManager:CreateParticle("particles/roshpit/dinath/fire_bomb.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx, 0, position)
			ParticleManager:SetParticleControl(pfx, 11, Vector(0.3,0.3,0.3))
			table.insert(pfxTable, pfx)
		end
	end
	if aoeSize >= 4 then
		for i = 1, 18, 1 do
			local position = explosionPoint + WallPhysics:rotateVector(Vector(0,1), 2*math.pi*i/18)*360
			local pfx = ParticleManager:CreateParticle("particles/roshpit/dinath/fire_bomb.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx, 0, position)
			ParticleManager:SetParticleControl(pfx, 11, Vector(0.3,0.3,0.3))
			table.insert(pfxTable, pfx)
		end
	end
	local fireDuration = get_arctic_burn_fire_duration(caster)
	ability:ApplyDataDrivenModifier(caster, fireThinker, "modifier_arctic_burn_fire_thinker", {duration = fireDuration})
	Timers:CreateTimer(fireDuration, function()
		for i = 1, #pfxTable, 1 do
			ParticleManager:DestroyParticle(pfxTable[i], false)
		end
		UTIL_Remove(fireThinker)
	end)
end

function get_arctic_burn_fire_duration(caster)
	local fireDuration = 6
	fireDuration = fireDuration + (caster:GetRuneValue("q", 2))*0.08
	return fireDuration
end

function reindex_arctic_bombs(ability)
	local newTable = {}
	for i = 1, #ability.bombTable, 1 do
		local beam = ability.bombTable[i]
		if IsValidEntity(beam) then
			table.insert(newTable, beam)
		end
	end
	ability.bombTable = newTable
end

function arctic_burn_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local damage = event.damage
	local fire_thinker = event.target
	damage = damage + caster:GetAverageTrueAttackDamage(caster)*(event.damage_mult/100)
	local enemies = nil
	if fire_thinker.line then
		enemies = FindUnitsInLine(caster:GetTeamNumber(), fire_thinker:GetAbsOrigin(), fire_thinker:GetAbsOrigin()+fire_thinker.fv*fire_thinker.distance, nil, 180, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0)
	else
		enemies = FindUnitsInRadius( caster:GetTeamNumber(), fire_thinker:GetAbsOrigin(), nil, fire_thinker.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	end
	if #enemies > 0 then	
		for i = 1, #enemies, 1 do
			local enemy = enemies[i]
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_DRAGON, RPC_ELEMENT_FIRE)
			if ability.q_1_level > 0 then
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_arctic_burn_slow", {duration = 0.5})
				enemy:SetModifierStackCount("modifier_arctic_burn_slow", caster, ability.q_1_level)
			end
			if ability.q_4_level > 0 then
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_arctic_burn_casttime", {duration = 0.5})
				enemy:SetModifierStackCount("modifier_arctic_burn_casttime", caster, ability.q_1_level)
			end
		end
	end
end

function arctic_burn_passive_thinker(event)
	local caster = event.caster
	local ability = event.ability
	if not ability.think_interval then
		ability.think_interval = 0
	end
	ability.think_interval = ability.think_interval + 1
	if ability.think_interval == 80 then
		ability.think_interval = 0
		local maxStacks = 2
		if caster:HasModifier("modifier_dinath_glyph_3_1") then
			maxStacks = maxStacks + 2
		end
		local newStacks = math.min(caster:GetModifierStackCount("modifier_arctic_burn_freecast", caster) + 1, maxStacks)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_arctic_burn_freecast", {})
		caster:SetModifierStackCount("modifier_arctic_burn_freecast", caster, newStacks)
	end
	if ability:GetCooldownTimeRemaining() > 0 then
		local indexSkill = caster:GetAbilityByIndex(0)
		local q_3_level = caster:GetRuneValue("q", 3)
		print("q_3_level")
		print(q_3_level)
		if q_3_level > 0 then
			if indexSkill:GetAbilityName() == "dinath_arctic_burn" then
				CustomAbilities:AddAndOrSwapSkill(caster, "dinath_arctic_burn", "dinath_scorch_charge", 0)
			end
		end
	else
		local indexSkill = caster:GetAbilityByIndex(0)
		if indexSkill:GetAbilityName() == "dinath_scorch_charge" then
			CustomAbilities:AddAndOrSwapSkill(caster, "dinath_scorch_charge", "dinath_arctic_burn", 0)
		end
	end
end