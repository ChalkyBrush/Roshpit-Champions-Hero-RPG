function unibi_think(event)
	local caster = event.caster
	if not caster.waterTrollCount then
		caster.waterTrollCount = 0
	end
	if not caster.angryFishCount then
		caster.angryFishCount = 0
	end
	local ability = event.ability
	local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1260, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
	if #allies > 0 and caster.wayPointEnabled then
		if caster.phase == 0 then
			caster.wayPointEnabled = false
			unibi_move(caster, Vector(-4800, 23))
			caster.phase = 1
			Timers:CreateTimer(3.5, function()
				caster.wayPointEnabled = true
			end)
		elseif caster.phase == 5 and caster.wayPointEnabled then
			caster.wayPointEnabled = false
			caster.phase = 6
			caster:MoveToPosition(caster:GetAbsOrigin() + Vector(-10, 0, 0))
			unibi_move(caster, Vector(3555, -3392))
			Timers:CreateTimer(0.8, function()
				caster:Stop()
			end)
			caster.targetZ = 400
			Timers:CreateTimer(6, function()
				caster.wayPointEnabled = true
			end)
		elseif caster.phase == 6 and caster.wayPointEnabled then
			caster.wayPointEnabled = false
			caster.phase = 7
			caster:MoveToPosition(caster:GetAbsOrigin() + Vector(-10, 0, 0))
			unibi_move(caster, Vector(5824, -3319))
			Timers:CreateTimer(0.8, function()
				caster:Stop()
			end)
			Timers:CreateTimer(6, function()
				caster.wayPointEnabled = true
			end)
		elseif caster.phase == 7 and caster.wayPointEnabled then
			caster.wayPointEnabled = false
			caster.phase = 8
			caster:MoveToPosition(caster:GetAbsOrigin() + Vector(-10, 0, 0))
			unibi_move(caster, Vector(8463, -3020))
			Timers:CreateTimer(0.8, function()
				caster:Stop()
			end)
			Timers:CreateTimer(6, function()
				caster.wayPointEnabled = true
			end)
		elseif caster.phase == 9 and caster.wayPointEnabled then
			caster.wayPointEnabled = false
			caster.phase = 10
			caster:MoveToPosition(caster:GetAbsOrigin() + Vector(10, -5, 0))
			unibi_move(caster, Vector(6976, -1728))
			Timers:CreateTimer(0.8, function()
				caster:Stop()
			end)
			Timers:CreateTimer(6, function()
				caster.wayPointEnabled = true
			end)
		elseif caster.phase == 11 and caster.wayPointEnabled then
			caster.wayPointEnabled = false
			caster.phase = 12
			caster:MoveToPosition(caster:GetAbsOrigin() - Vector(100, 0, 0))

			local particleDummy = Tanari:CreateDummyUnit(Vector(3814, 432, 1252), nil, 1)
			local particleName = "particles/units/heroes/hero_pugna/epoch_life_give.vpcf"
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_pugna/epoch_life_give.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx, 1, particleDummy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", particleDummy:GetAbsOrigin(), true)
			for i = 1, 40, 1 do
				Timers:CreateTimer(i * 0.1, function()
					EmitSoundOn("Tanari.UnibiEvent", caster)
				end)
			end
			Timers:CreateTimer(4, function()
				ParticleManager:DestroyParticle(pfx, false)
				Tanari:SpawnMountainSpecter(Vector(3840, 384), Vector(0, -1))
				UTIL_Remove(particleDummy)
				Timers:CreateTimer(0.3, function()
					EmitGlobalSound("Tanari.MountainSpecterIntro")
				end)
			end)
			Timers:CreateTimer(6, function()
				caster.wayPointEnabled = true
				caster:MoveToPosition(caster:GetAbsOrigin() - Vector(0, 20, 0))
			end)
		elseif caster.phase == 13 and caster.wayPointEnabled then
			caster.wayPointEnabled = false
			caster.phase = 14
			caster:MoveToPosition(caster:GetAbsOrigin() + Vector(-10, 0, 0))
			unibi_move(caster, Vector(5632, 1984))
			Timers:CreateTimer(0.8, function()
				caster:Stop()
			end)
			Timers:CreateTimer(6, function()
				caster.wayPointEnabled = true
			end)
		elseif caster.phase == 14 and caster.wayPointEnabled then
			caster.wayPointEnabled = false
			caster.phase = 15
			caster:MoveToPosition(caster:GetAbsOrigin() + Vector(0, -10, 0))
			unibi_move(caster, Vector(7465, 5138))
			Timers:CreateTimer(0.8, function()
				caster:Stop()
			end)
			Timers:CreateTimer(6, function()
				caster.wayPointEnabled = true
			end)
		elseif caster.phase == 15 and caster.wayPointEnabled then
			caster.wayPointEnabled = false
			caster.phase = 16
			caster:MoveToPosition(caster:GetAbsOrigin() + Vector(0, -10, 0))
			unibi_move(caster, Vector(7465, 7723))
			Timers:CreateTimer(0.8, function()
				caster:Stop()
			end)
			Timers:CreateTimer(6, function()
				caster.wayPointEnabled = true
			end)
		end
	end
	if caster.phase == 1 and caster.objectiveCount >= 5 and caster.wayPointEnabled then
		caster.wayPointEnabled = false
		caster.phase = 2
		caster.objectiveCount = 0
		caster:MoveToPosition(caster:GetAbsOrigin() - Vector(10, 0, 0))
		unibi_move(caster, Vector(-2921, -384))
		Timers:CreateTimer(0.5, function()
			caster:Stop()
		end)
		Timers:CreateTimer(6, function()
			caster.wayPointEnabled = true
		end)
	elseif caster.phase == 2 and caster.waterTrollCount >= 9 and caster.wayPointEnabled then
		caster.wayPointEnabled = false
		caster.phase = 3
		caster.waterTrollCount = 0
		caster:MoveToPosition(caster:GetAbsOrigin() - Vector(0, 10, 0))
		unibi_move(caster, Vector(-512, -192))
		Timers:CreateTimer(0.5, function()
			caster:Stop()
		end)
		Timers:CreateTimer(6, function()
			caster.wayPointEnabled = true
		end)
	elseif caster.phase == 3 and caster.angryFishCount >= 5 and caster.wayPointEnabled then
		caster.wayPointEnabled = false
		Timers:CreateTimer(6, function()
			caster.phase = 4
			unibi_move(caster, Vector(1088, -512))
			Timers:CreateTimer(0.5, function()
				caster:Stop()
			end)
			Timers:CreateTimer(6, function()
				caster.wayPointEnabled = true
			end)
		end)
	elseif caster.phase == 4 and Tanari.unibi.krakenKingDead and caster.wayPointEnabled then
		caster.wayPointEnabled = false
		Timers:CreateTimer(3, function()
			caster.phase = 5
			caster.targetZ = 280
			caster:MoveToPosition(caster:GetAbsOrigin() + Vector(-10, 10, 0))
			unibi_move(caster, Vector(1854, -1913))
			Timers:CreateTimer(0.8, function()
				caster:Stop()
			end)
			Timers:CreateTimer(6, function()
				caster.wayPointEnabled = true
			end)
		end)
	elseif caster.phase == 8 and caster.passGuardianDead and caster.wayPointEnabled then
		caster.wayPointEnabled = false
		Timers:CreateTimer(3, function()
			caster.phase = 9
			caster:MoveToPosition(caster:GetAbsOrigin() + Vector(-10, -10, 0))
			unibi_move(caster, Vector(9492, -2048))
			Timers:CreateTimer(0.8, function()
				caster:Stop()
			end)
			Timers:CreateTimer(6, function()
				caster.wayPointEnabled = true
			end)
		end)
	elseif caster.phase == 10 and caster.mountainNomadDead and caster.wayPointEnabled then
		caster.wayPointEnabled = false
		Timers:CreateTimer(3, function()
			caster.phase = 11
			caster:MoveToPosition(caster:GetAbsOrigin() + Vector(10, 0, 0))
			unibi_move(caster, Vector(4288, 448))
			Timers:CreateTimer(0.8, function()
				caster:Stop()
			end)
			Timers:CreateTimer(6, function()
				caster.wayPointEnabled = true
			end)
		end)
	elseif caster.phase == 12 and caster.windTempleKeyVictory and caster.wayPointEnabled then
		caster.wayPointEnabled = false
		caster.phase = 13
		caster:MoveToPosition(caster:GetAbsOrigin() + Vector(0, -5, 0))
		unibi_move(caster, Vector(2432, 3328))
		Timers:CreateTimer(0.8, function()
			caster:Stop()
		end)
		Timers:CreateTimer(2, function()
			caster:MoveToPosition(caster:GetAbsOrigin() + Vector(0, -5, 0))
			Timers:CreateTimer(0.3, function()
				caster:Stop()
			end)
		end)
		Timers:CreateTimer(12, function()
			caster.wayPointEnabled = true
		end)
	end
	if caster.angryFishCount >= 5 and not caster.krakenStarted then
		caster.krakenStarted = true
		Timers:CreateTimer(1, function()
			Tanari:InitiateKrakenKing()
		end)
	end
end

function unibi_floating_think(event)
	-- local caster = event.caster
	-- local ability = event.ability
	-- local stacks = math.ceil(caster.zPhase*2+caster.bonusZSpeed)
	-- if caster.floatUp then
	-- else
	-- stacks = math.ceil(caster.zPhase*2-caster.bonusZSpeed)
	-- end
	-- Tanari.unibi:SetModifierStackCount("modifier_unibi_z_delta", caster, stacks)

	-- if caster.floatUp then
	-- caster.zPhase = caster.zPhase + 1
	-- else
	-- caster.zPhase = caster.zPhase - 1
	-- end


	-- if caster.zPhase >= 100 then
	-- caster.floatUp = false
	-- caster.bonusZSpeed = 0
	-- elseif caster.zPhase <= 60 then
	-- caster.floatUp = true
	-- caster.bonusZSpeed = 0
	-- end
	-- if caster.zPhase <= 80 then
	-- caster.bonusZSpeed = caster.bonusZSpeed + 0.6
	-- else
	-- caster.bonusZSpeed = caster.bonusZSpeed - 0.6
	-- end

end

function unibi_move(caster, newPosition)
	local currentPosition = caster:GetAbsOrigin()
	local ability = caster:FindAbilityByName("unibi_ai")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_unibi_moving", {duration = 10})
	local distance = WallPhysics:GetDistance(currentPosition, newPosition)
	local loopCount = math.ceil(distance / 10)
	local forwardVector = ((newPosition - currentPosition) * Vector(1, 1, 0)):Normalized()

	local pfx = ParticleManager:CreateParticle("particles/econ/courier/courier_trail_orbit/courier_trail_orbit.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	Timers:CreateTimer(loopCount * 0.03 + 0.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	for i = 1, loopCount, 1 do
		Timers:CreateTimer(i * 0.03, function()
			local helixOffsetX = math.cos(i / 10)
			local helixOffsetY = math.sin(i / 10)
			local helixPower = math.min(i * 3, 80)
			if i % 4 == 0 then
				EmitSoundOn("Tanari.UnibiMove", caster)
			end
			caster:SetAbsOrigin(currentPosition + (forwardVector * (10) * i) + (Vector(helixOffsetX, helixOffsetY) * helixPower))
		end)
	end
	Timers:CreateTimer(loopCount * 0.03 + 0.05, function()
		caster:MoveToPosition(caster:GetAbsOrigin() + caster:GetForwardVector() * 5)
	end)
end

function techies_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.explode then
		return false
	end
	local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 290, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
	if #allies > 0 then
		caster:MoveToPosition(caster.vectorMoveTable[caster.phase])
		if not caster.intro then
			-- EmitSoundOn("Tanari.Techies.Intro", caster)
			EmitSoundOn("techies_tech_happy_0"..RandomInt(1, 5), caster)
			caster.intro = true
		end
		if WallPhysics:GetDistance(caster.vectorMoveTable[caster.phase] * Vector(1, 1, 0), caster:GetAbsOrigin() * Vector(1, 1, 0)) < 240 then
			caster.phase = caster.phase + 1
			if caster.phase > #caster.vectorMoveTable then
				caster.explode = true
				EmitSoundOn("techies_tech_suicidesquad_03", caster)
				Timers:CreateTimer(1.65, function()
					EmitSoundOn("Hero_Techies.Suicide.Arcana", caster)
					CustomAbilities:QuickAttachParticle("particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf", caster, 3)

					local particleName = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
					local particle2 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
					ParticleManager:SetParticleControl(particle2, 0, caster:GetAbsOrigin() + Vector(0, 0, 100))
					ParticleManager:SetParticleControl(particle2, 1, Vector(800, 800, 800))
					ParticleManager:SetParticleControl(particle2, 2, Vector(2.0, 2.0, 2.0))
					ParticleManager:SetParticleControl(particle2, 4, Vector(255, 90, 20))
					Timers:CreateTimer(1.5, function()
						ParticleManager:DestroyParticle(particle2, false)
					end)

					local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY + DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
					if #enemies > 0 then
						for _, enemy in pairs(enemies) do
							enemy:AddNewModifier(Events.GameMaster, nil, "modifier_stunned", {duration = 2.5})
							ApplyDamage({victim = enemy, attacker = caster, damage = enemy:GetMaxHealth() * 0.35, damage_type = DAMAGE_TYPE_PURE})
						end
					end
					Timers:CreateTimer(0.15, function()
						local particle1 = ParticleManager:CreateParticle("particles/units/heroes/hero_alchemist/fire_ground_effect_cinside.vpcf", PATTACH_WORLDORIGIN, caster)
						ParticleManager:SetParticleControl(particle1, 0, Vector(1506, 4431, 510))
						ParticleManager:SetParticleControl(particle1, 1, Vector(1506, 4431, 510))
						ParticleManager:SetParticleControl(particle1, 2, Vector(1506, 4431, 510))
						ParticleManager:SetParticleControl(particle1, 3, Vector(1506, 4431, 510))
						Timers:CreateTimer(10, function()
							ParticleManager:DestroyParticle(particle1, false)
						end)
					end)

					StartAnimation(caster, {duration = 4, activity = ACT_DOTA_DIE, rate = 0.55})
					Timers:CreateTimer(0.3, function()
						Tanari:RemoveCaveBlockers()
						local rockEnt = Entities:FindByNameNearest("BoulderspineRock", Vector(1706, 4431, 5), 500)
						EmitSoundOnLocationWithCaster(Vector(1706, 4431, 5), "Building_DireTower.Destruction", Events.GameMaster)
						UTIL_Remove(rockEnt)

						local particle1 = ParticleManager:CreateParticle("particles/dire_fx/bad_ancient002_destroy.vpcf", PATTACH_WORLDORIGIN, caster)
						ParticleManager:SetParticleControl(particle1, 0, Vector(1506, 4431, 510))
						ParticleManager:SetParticleControl(particle1, 1, Vector(1506, 4431, 510))
						ParticleManager:SetParticleControl(particle1, 2, Vector(1506, 4431, 510))
						-- Timers:CreateTimer(120, function()
						-- ParticleManager:DestroyParticle(particle1, false)
						-- end)
					end)

					Timers:CreateTimer(2.2, function()
						UTIL_Remove(caster)

					end)
					-- Timers:CreateTimer(3.2, function()
					-- EmitGlobalSound("Tanari.HarpMystery")
					-- end)
				end)
			else
				EmitSoundOn("techies_tech_happy_0"..RandomInt(1, 5), caster)
			end
		end
	end
end

function princess_think(event)
	local caster = event.caster
	local ability = event.ability
	local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 460, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
	if #allies > 0 and caster.wayPointEnabled then
		if caster.phase == 0 then
			caster.wayPointEnabled = false
			caster.phase = 1
			caster:MoveToPosition(Vector(2396, 14913))
			Timers:CreateTimer(2, function()
				StartAnimation(caster, {duration = 2, activity = ACT_DOTA_CAST_ABILITY_1, rate = 1})
				Timers:CreateTimer(0.2, function()
					Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(2595, 14912, 660), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
					Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(3519, -4791, 660), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
				end)
				Timers:CreateTimer(1.5, function()
					EmitGlobalSound("Tanari.HarpMystery")
					Timers:CreateTimer(1, function()
						caster:MoveToPosition(Vector(2595, 14912))
						Timers:CreateTimer(0.6, function()
							local portToVector = Vector(3519, -4791)
							Events:TeleportUnit(caster, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
							Timers:CreateTimer(2.4, function()
								caster:MoveToPosition(Vector(3969, -4600))
								Tanari:InitializeWaterKeyArea()
							end)
						end)
					end)
				end)
			end)
			Timers:CreateTimer(6, function()
				caster.wayPointEnabled = true
			end)
		elseif caster.phase == 1 and caster.wayPointEnabled then
			caster.wayPointEnabled = false
			caster.phase = 2
			caster:MoveToPositionAggressive(Vector(5824, -4672))
			Timers:CreateTimer(7, function()
				caster.wayPointEnabled = true
			end)
		end
	end
	local objective = false
	if caster.phase == 2 and Tanari.royalGuardsSlain >= 2 and caster.wayPointEnabled then
		caster:MoveToPosition(Vector(8320, -5248))
	end
	local casterOrigin = caster:GetAbsOrigin()
	if caster.phase == 2 and Tanari.royalGuardsSlain >= 2 and caster.wayPointEnabled and casterOrigin.x > 8200 and casterOrigin.x < 8400 and casterOrigin.y > -5300 and casterOrigin.y < -5200 then
		caster.phase = 3
		caster.wayPointEnabled = false
		Timers:CreateTimer(0.6, function()
			EmitSoundOn("Tanari.PrincessOpenGate", caster)
			StartAnimation(caster, {duration = 1.6, activity = ACT_DOTA_CAST_ABILITY_3, rate = 1})
			Tanari.secretWaterHutOpen = true
			ParticleManager:DestroyParticle(Tanari.WaterKeyWallParticle, false)
			UTIL_Remove(Tanari.waterKeyBlock1)
			UTIL_Remove(Tanari.waterKeyBlock2)
			UTIL_Remove(Tanari.waterKeyBlock3)
			Timers:CreateTimer(0.3, function()
				EmitSoundOn("Tanari.WaterGateOpenSound", caster)
			end)
			Timers:CreateTimer(2.2, function()
				caster:MoveToPosition(Vector(8256, -4864))
				EmitGlobalSound("Tanari.HarpMystery")
				Timers:CreateTimer(3, function()
					caster:MoveToPosition(caster:GetAbsOrigin() - Vector(0, 20, 0))
				end)
			end)
		end)
	end
end

function rascal_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.phase == 1 then
		caster:MoveToPositionAggressive(Vector(-5376, 15168))
		local bSearch = WallPhysics:IsWithinRegion(caster, Vector(-5376, 15168), 320)
		if bSearch then
			local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 460, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
			if #allies > 0 then
				for i = 1, #Tanari.WaterTemple.rascalTable, 1 do
					Tanari.WaterTemple.rascalTable[i].phase = 2
				end
			end
		end
	elseif caster.phase == 2 then
		caster:MoveToPositionAggressive(Vector(-6080, 11427) + RandomVector(RandomInt(40, 180)))
		local bSearch = WallPhysics:IsWithinRegion(caster, Vector(-6080, 11427), 320)
		if bSearch then
			local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 380, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
			if #allies > 0 then
				local cutscene = true
				for i = 1, #Tanari.WaterTemple.rascalTable, 1 do
					if WallPhysics:GetDistance(Tanari.WaterTemple.rascalTable[i]:GetAbsOrigin() * Vector(1, 1, 0), Vector(-6080, 11427)) > 400 then
						cutscene = false
					end
				end
				if cutscene then
					for i = 1, #Tanari.WaterTemple.rascalTable, 1 do
						Tanari.WaterTemple.rascalTable[i].phase = 3
					end
					Tanari:RascalCutscene(allies)
				end
			end
		end
	end
	local casterOrigin = caster:GetAbsOrigin()

	if caster:GetHealth() < caster:GetMaxHealth() * 0.1 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_rascal_healing", {duration = 20})
	end
end
