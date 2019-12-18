function target_dummy_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	local bInit = false
	if not caster.angle then
		caster.angle = -45
	end
	if event.attacker:IsHero() then
		bInit = true
		if GameState:IsTutorial() then
			if not event.attacker.dummy_lines_added then
				event.attacker.dummy_lines_added = 0
			end
			event.attacker.dummy_lines_added = event.attacker.dummy_lines_added + 1
			if event.attacker.dummy_lines_added == 8 then
				Events:TutorialServerEvent(event.attacker, "4_5", 1)
			elseif event.attacker.dummy_lines_added > 8 then
				event.attacker.dummy_lines_added = 0
			end
			if caster:GetRoshpitArmor() >= 1000 then
				if event.attacker:HasModifier("challen_postmit_buff") then
					Events:TutorialServerEvent(event.attacker, "4_6", 1)
				else
					Events:TutorialServerEvent(event.attacker, "4_6", 0)
				end
			end
		end
	end
	if event.attacker == Events.GameMaster then
		return
	end
	local attacker = CustomAbilities:getHeroFromUnit(event.attacker)

	if ability.moveMomentum then
		ability.moveMomentum = math.min(ability.moveMomentum + 10, 60)
		ability.sway = ability.sway + ability.moveMomentum
		local actualSway = math.sin(math.pi * (ability.sway / 60)) * 45
		caster:SetAngles(actualSway, caster.angle, 0)
	end
end

function target_dummy_attack_think(event)
	local dummy = event.target
	local hero = EntIndexToHScript(dummy.attackerIndex)
	if IsValidEntity(hero) then
		if not dummy.attackInterval then
			dummy.attackInterval = 0
		end
		local modulos = 1
		if dummy.attack_input / 0.03 % 1 > 0.5 then
			modulos = math.ceil(dummy.attack_input / 0.03)
		else
			modulos = math.floor(dummy.attack_input / 0.03)
		end
		dummy.attackInterval = dummy.attackInterval + 1
		local distance = WallPhysics:GetDistance2d(dummy:GetAbsOrigin(), hero:GetAbsOrigin())
		if dummy.attackInterval % modulos == 0 and distance <= 2000 then
			Filters:PerformAttackSpecial(dummy, hero, true, true, true, false, true, false, false)
		end
		if dummy.attackInterval >= 1000 then
			dummy.attackInterval = 0
		end
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
	Events:TutorialServerEvent(attacker, "4_5", 0)
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
		local moveVector = (targetPosition - caster:GetAbsOrigin()) / 30
		caster:SetAbsOrigin(caster:GetAbsOrigin() + moveVector)
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
	baseMaxSway = math.ceil((ability.moveMomentum / 60) * 40) + 15
	ability.moveMomentum = ability.moveMomentum * 0.98
	ability.sway = ability.sway + ability.moveMomentum

	if ability.moveMomentum < 1.2 then
		if angleVector.x > 0 or angleVector.x < 0 then
			if math.abs(angleVector.x) > 4 then
				if angleVector.x > 0 then
					ability.sway = ability.sway - 1.8
				else
					ability.sway = ability.sway + 1.8
				end
				local actualSway = math.sin(math.pi * (ability.sway / 90)) * baseMaxSway
				caster:SetAngles(actualSway, caster.angle, 0)
			end
		end
		return
	end
	-- local intervalChecker = math.max(math.floor(30-ability.moveMomentum*2), 1)
	if angleVector.x > baseMaxSway * 0.7 then
		if not ability.soundLock then
			local soundIndex = ability.moveMomentum / 15
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
		local actualSway = math.sin(math.pi * (ability.sway / 90)) * baseMaxSway
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
