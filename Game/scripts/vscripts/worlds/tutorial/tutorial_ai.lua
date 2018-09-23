function tutorial_master_think(event)
	local caster = event.caster
	local allies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 240, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
	if #allies > 0 then
		for i = 1, #allies, 1 do
			Tutorial:OpenTutorial(allies[i])
		end
	end
end

function tutorial_assistant_think(event)
	local caster = event.target
	if caster.state == 0 then
		if caster.hero and caster.hero:IsAlive() then
			local targetPoint = caster.hero:GetAbsOrigin() + caster.hero:GetForwardVector()*150
			caster:MoveToPosition(targetPoint)
		end
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), caster.hero:GetAbsOrigin())
		if distance < 200 then
			caster.state = 1
			local fv = ((caster.hero:GetAbsOrigin() - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
			caster:MoveToPosition(caster:GetAbsOrigin()+fv)
			Quests:ShowDialogueText({caster.hero}, caster, "tutorial_assistant_1", 5, false)
			EmitSoundOn("Tutorial.Assistant.Voice2", caster)
			StartAnimation(caster, {duration=2, activity=ACT_DOTA_ATTACK, rate=1.0})
			Timers:CreateTimer(5.5, function()
				caster.state = 2
				EmitSoundOn("Tutorial.Assistant.Voice6", caster)
				Quests:ShowDialogueText({caster.hero}, caster, "tutorial_assistant_2", 7, false)
			end)
		end
	elseif caster.state == 2 then
		caster:MoveToPosition(Vector(154, -1856) + RandomVector(150))
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), Vector(154, -1856))
		if distance < 200 then
			caster.state = 3 
		end
	elseif caster.state == 3 then
		local fv = ((caster.hero:GetAbsOrigin() - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		caster:MoveToPosition(caster:GetAbsOrigin()+fv)
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), caster.hero:GetAbsOrigin())
		if distance < 200 then
			StartAnimation(caster, {duration=2, activity=ACT_DOTA_ATTACK, rate=1.0})
			EmitSoundOn("Tutorial.Assistant.Voice1", caster)
			caster.state = 1
			Timers:CreateTimer(1.5, function()
				caster.state = 4
			end)
		end
	elseif caster.state == 4 then
		caster:MoveToPosition(Vector(1357, 577) + RandomVector(150))
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), Vector(1357, 577))
		if distance < 200 then
			caster.state = 5
		end
	elseif caster.state == 5 then
		local fv = ((caster.hero:GetAbsOrigin() - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		caster:MoveToPosition(caster:GetAbsOrigin()+fv)
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), caster.hero:GetAbsOrigin())
		if distance < 200 then
			StartAnimation(caster, {duration=2, activity=ACT_DOTA_ATTACK, rate=1.0})
			EmitSoundOn("Tutorial.Assistant.Voice2", caster)
			caster.state = 1
			Quests:ShowDialogueText({caster.hero}, caster, "tutorial_assistant_3", 5, false)
			Timers:CreateTimer(1.5, function()
				caster.state = 6
			end)
		end
	elseif caster.state == 6 then
		caster:MoveToPosition(Tutorial.Master:GetAbsOrigin() + RandomVector(150))
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), Tutorial.Master:GetAbsOrigin())
		if distance < 200 then
			caster.state = 7
		end
	end
end

function tutorial_super_kill_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	if target.tutorialhasBeenSlain then
		if target:IsAlive() then
			target:RemoveModifierByName("modifier_tutorial_super_kill")
			Timers:CreateTimer(3, function()
				Tutorial:UpdateChallengeSummaryProgress(target, 1, 2, 2, true)
				Quests:ShowDialogueText({target}, Tutorial.Master,"tutorial_master_dialogue_1_2m", 4, false)
				Tutorial:ProgressUpdateOrNot(target, 1, 2)
			end)
		end
	else
		ApplyDamage({ victim = target, attacker = caster, damage = 10000000, damage_type = DAMAGE_TYPE_PURE, ability = ability })	
		if not target:IsAlive() then
			target.tutorialhasBeenSlain = true
		end
	end
end

function portal1enter(trigger)
	local hero = trigger.activator
	if hero:HasModifier("modifier_recently_teleported_portal") then
		return false
	end
	if Tutorial.PortalActive then
		Events:TeleportUnit(hero, Vector(620, 1588), Events.GameMaster.portal, Events.GameMaster, 1.2)
	end
end

function portal2enter(trigger)
	local hero = trigger.activator
	if hero:HasModifier("modifier_recently_teleported_portal") then
		return false
	end
	if Tutorial.PortalActive then
		Events:TeleportUnit(hero, Vector(-3720, -2535), Events.GameMaster.portal, Events.GameMaster, 1.2)
	end
end