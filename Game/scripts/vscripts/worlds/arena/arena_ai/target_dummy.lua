function target_dummy_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	local bInit = false
	if not caster.angle then
		caster.angle = -45
	end
	if event.attacker:IsHero() then
		bInit = true
	end
	if event.attacker == Events.GameMaster then
		return
	end
	local attacker = CustomAbilities:getHeroFromUnit(event.attacker)
	if attacker:HasModifier("modifier_attacking_dummy") then
		if caster.attackerIndex == attacker:GetEntityIndex() then
		else
			return false
		end
	else
		if bInit then
			initTargetDummy(caster, ability, attacker)
		end
	end
	if ability.moveMomentum then
		ability.moveMomentum = math.min(ability.moveMomentum + 10, 60)
		ability.sway = ability.sway + ability.moveMomentum
		local actualSway = math.sin(math.pi*(ability.sway/60))*45
		caster:SetAngles(actualSway, caster.angle, 0)
	end
end

function initTargetDummy(caster, ability, attacker)
	ability.moveMomentum = 0
	ability.sway = 0
	ability:ApplyDataDrivenModifier(caster, attacker, "modifier_attacking_dummy", {})
	caster.attackerIndex = attacker:GetEntityIndex()
	attacker.targetDummy = caster
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_dummy_active", {})
	CustomGameEventManager:Send_ServerToPlayer(attacker:GetPlayerOwner(), "updateTargetDummy", {})
end

function target_dummy_rapid_think(event)
	local caster = event.caster
	local ability = event.ability
	if not ability.interval then
		ability.interval = 0
	end
	ability.interval = ability.interval + 1
	local targetPosition = caster.targetPosition
	local distance = WallPhysics:GetDistance(targetPosition, caster:GetAbsOrigin())
	if distance > 5 then
		local moveVector = (targetPosition - caster:GetAbsOrigin())/30
		caster:SetAbsOrigin(caster:GetAbsOrigin()+moveVector)
	end
	moveDummyTowardCenter(caster, ability)
end

function moveDummyTowardCenter(caster, ability)
	local angleVector = caster:GetAnglesAsVector()
	local baseMaxSway = 45
	if ability.moveMomentum < 20 then
		baseMaxSway = 30
	elseif ability.moveMomentum < 10 then
		baseMaxSway = 15
	end
	baseMaxSway = math.ceil((ability.moveMomentum/60)*40)+15
	ability.moveMomentum = ability.moveMomentum*0.98
	ability.sway = ability.sway + ability.moveMomentum

	if ability.moveMomentum < 1.2 then
		if angleVector.x > 0 or angleVector.x < 0 then
			if math.abs(angleVector.x) > 4 then
				if angleVector.x > 0 then
					ability.sway = ability.sway - 1.8
				else
					ability.sway = ability.sway + 1.8
				end
				local actualSway = math.sin(math.pi*(ability.sway/90))*baseMaxSway
				caster:SetAngles(actualSway, caster.angle, 0)
			end
		end
		return
	end
	-- local intervalChecker = math.max(math.floor(30-ability.moveMomentum*2), 1)
	if angleVector.x > baseMaxSway*0.7 then
		if not ability.soundLock then
			local soundIndex = ability.moveMomentum/15
			soundIndex = math.max(soundIndex, 1)
			soundIndex = math.min(soundIndex, 3)
			ability.soundLock = true
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Arena.DummyWobble"..soundIndex, caster)
			Timers:CreateTimer(0.3, function()
				ability.soundLock = false
			end)
		end
	end
	if angleVector.x > 0 or angleVector.x < 0 then
		local actualSway = math.sin(math.pi*(ability.sway/90))*baseMaxSway
		caster:SetAngles(actualSway, caster.angle, 0)
	end
end

function endTargetDummy(event)
	local caster = event.caster
	local attacker = EntIndexToHScript(caster.attackerIndex)
	attacker:RemoveModifierByName("modifier_attacking_dummy")
	caster:SetAngles(0, caster.angle, 0)
	caster.attackerIndex = -1
	caster:RemoveModifierByName("modifier_dummy_timer")
	caster:SetPhysicalArmorBaseValue(0)
end