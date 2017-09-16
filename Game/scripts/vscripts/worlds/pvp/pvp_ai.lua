function vision_node_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.takeOver then
		caster.takeOver = 0
	end
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
	local allies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
	if #enemies > #allies then
		caster.takeOver = caster.takeOver + #enemies - #allies
	else
		caster.takeOver = math.max(caster.takeOver - 0.5, 0)
	end	
	caster:SetRenderColor(255, 255-caster.takeOver*10, 255-caster.takeOver*10)
	if caster.takeOver > 22 then
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "PVP.NodeSwap", Events.GameMaster)
		caster.takeOver = 0
		caster:SetRenderColor(255, 255, 255)
		local position = caster:GetAbsOrigin()
		local teamNumber = caster:GetTeamNumber()
		UTIL_Remove(caster)
		local visionNode = nil
		if teamNumber == DOTA_TEAM_GOODGUYS then
			visionNode = PVP:SpawnVisionNode(DOTA_TEAM_BADGUYS, position)
		else
			visionNode = PVP:SpawnVisionNode(DOTA_TEAM_GOODGUYS, position)
		end
		CustomAbilities:QuickAttachParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_loadout.vpcf", visionNode, 4)
	end
end

function line_tower_die(event)
	local caster = event.caster
	local particleName = "particles/dire_fx/tower_bad_destroy.vpcf"
	if caster:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		particleName = "particles/radiant_fx/tower_good3_destroy_lvl3.vpcf"
		PVP.GoodTowersAlive = PVP.GoodTowersAlive - 1
	else
		PVP.BadTowersAlive = PVP.BadTowersAlive - 1
	end
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())

	-- CustomAbilities:QuickAttachParticle("particles/dire_fx/tower_bad_destroy.vpcf", caster, 4)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "PVP.BadTowerDie", Events.GameMaster)

	Timers:CreateTimer(0.3, function()
		UTIL_Remove(caster)
	end)
	Timers:CreateTimer(5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	if PVP.GoodTowersAlive == 0 then
		PVP:GameEnd(DOTA_TEAM_GOODGUYS)
	elseif PVP.BadTowersAlive == 0 then
		PVP:GameEnd(DOTA_TEAM_BADGUYS)
	end
end

function line_unit_think(event)
	local caster = event.caster
	caster:MoveToPositionAggressive(caster.targetPoint)
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), caster.targetPoint)
	if distance < 150 then
		if caster.aiState == 0 then
			if GameState:IsPVPLineWarWork() then
				caster.aiState = 1
				if caster:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
					caster.targetPoint = Vector(2560, 3008)
				else
					caster.targetPoint = Vector(2374, 2442)
				end
			else
				caster.aiState = 1
				if caster:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
					caster.targetPoint = Vector(2374, 2442)
				else
					caster.targetPoint = Vector(-256, -192)
				end
			end
		elseif caster.aiState == 1 then
			if GameState:IsPVPLineWarWork() then
				caster.aiState = 2
				if caster:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
					caster.targetPoint = Vector(4407, 4792)
				else
					caster.targetPoint = Vector(-1284, -1392)
				end
			end
		end
	end
end

function line_unit_die(event)
	local caster = event.caster
	local playerID = caster.builderID
	PopupExperience(caster, caster:GetDeathXP())
	local foodInfo = CustomNetTables:GetTableValue("premium_pass", "line_war_food_cap_"..playerID)
	local newFood = tonumber(foodInfo.currentFood) - 1
	CustomNetTables:SetTableValue("premium_pass", "line_war_food_cap_"..playerID, {currentFood = tostring(newFood), maxFood = foodInfo.maxFood})
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "updateLineWarFoodCap", {})
	local allyXP = caster:GetDeathXP()*0.25

	local allies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )	
	if #allies > 0 then
		for i = 1, #allies, 1 do
			allies[i]:AddExperience(allyXP, 0, false, true)
		end
	end	
	if GameState:NoOracle() then
		local luck = RandomInt(1,28)
		if luck == 1 then
			PVP:RollRandomGlyph(caster:GetAbsOrigin())
		end
	end
end

function pvp_line_tower_attack_hit(event)
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	if target:IsHero() then
		EmitSoundOn("Redfall.Stone.HurlBoulder.Impact", target)
		EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Redfall.StoneAttack", attacker)
		target:AddNewModifier(attacker, nil, "modifier_stunned", {duration = 1.0})
		target.pushVector = ((target:GetAbsOrigin() - attacker:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		target.pushVelocity = 30
		ability:ApplyDataDrivenModifier(attacker, target, "modifier_heavy_boulder_pushback", {duration = 1.5})
	else
		ApplyDamage({ victim = target, attacker = attacker, damage = target:GetMaxHealth()*0.2, damage_type = DAMAGE_TYPE_PURE })
		if target:HasModifier("modifier_line_unit_passive") then
			target:MoveToTargetToAttack(attacker)
		end
	end
end

function heavy_boulder_pushback(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	local obstruction = WallPhysics:FindNearestObstruction(target:GetAbsOrigin())
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, target:GetAbsOrigin(), target)
	local fv = target.pushVector
	if blockUnit then
		fv = 0
	end
	local groundPosition = GetGroundPosition(target:GetAbsOrigin() + fv*target.pushVelocity, target)
	target:SetAbsOrigin(groundPosition)
	target.pushVelocity = math.max(target.pushVelocity - 1, 0)

end

function heavy_boulder_push_end(event)
	local caster = event.target
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
end

function open_tanari_builder_menu(event)
end