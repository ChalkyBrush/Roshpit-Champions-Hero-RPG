function feather_think(event)
	local ability = event.ability
	local caster = event.caster
	if not ability.interval then
		ability.interval = 0
	end
	if ability.interval == 0 then
		caster:MoveToPositionAggressive(caster.movePos)
		ability.interval = ability.interval + 1
	elseif ability.interval == 1 then
		caster:MoveToPositionAggressive(caster.startPos)
		ability.interval = 0
	end

end

function nomadic_hunter_think(event)
	local ability = event.ability
	local caster = event.caster
	if caster.aggro and caster:IsAlive() then
		local targetsTable = RPCItems:GetConnectedPlayerTable()
		for i = 1, #targetsTable, 1 do
			Timers:CreateTimer(0.5*(i-1), function()
					local axeAbility = caster:FindAbilityByName("nomadic_hunter_axe_throw")
					local targetPoint = targetsTable[i]:GetOrigin()		
					local order =
					{
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
						AbilityIndex = axeAbility:entindex(),
						Position = targetPoint
					}
					ExecuteOrderFromTable(order)
					-- local soundTable = {"pudge_pud_ability_hook_06", "pudge_pud_ability_hook_08", "pudge_pud_anger_03", "pudge_pud_anger_04"}
					-- local soundIndex = RandomInt(1, #soundTable)
					-- EmitSoundOn(soundTable[soundIndex], caster)
			end)
		end
	end
end

function blood_worshipper_think(event)
	local caster = event.caster
	if not caster.interval then
		caster.interval = 0
	end
    local particleName = "particles/items_fx/castle_boss_wall_beam.vpcf"
    local casterPos = caster:GetAbsOrigin()  
    local origin = caster.bloodPillarLoc + Vector(0,0,RandomInt(100, 800))
    for i = 1, 4, 1 do
    	Timers:CreateTimer(0.1*(i-1), function()
		    local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
		    ParticleManager:SetParticleControl(lightningBolt,0,Vector(casterPos.x,casterPos.y,casterPos.z+140))   
		    ParticleManager:SetParticleControl(lightningBolt,1,Vector(origin.x,origin.y,origin.z+500))
		    Timers:CreateTimer(0.5, function()
		    	ParticleManager:DestroyParticle( lightningBolt, false )
		    end)
    	end)
    end
	if caster.interval > 12 then
		if not caster.aggro then
			StartAnimation(caster, {duration=1, activity=ACT_DOTA_SHALLOW_GRAVE, rate=0.9})
		end
		caster.interval = 0
	end
	local distance = WallPhysics:GetDistance(casterPos,caster.bloodPillarLoc)
	if distance > 1200 then
		local particleName = "particles/econ/courier/courier_dolfrat_and_roshinante/arcanys_poof.vpcf"
	    local pfx = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, caster )
			ParticleManager:SetParticleControlEnt( pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
			Timers:CreateTimer(1.2, function() 
			  ParticleManager:DestroyParticle( pfx, false )
			end)	

		EmitSoundOn("Hero_Meepo.Poof.End01", caster)
		Timers:CreateTimer(0.3, function()
			local movePos = GetGroundPosition(caster.bloodPillarLoc+RandomVector(240), caster)
			FindClearSpaceForUnit(caster, movePos, false)
		end)
	end
end

function wandering_mage_think(event)
	local caster = event.caster
	local radius = 300
	if caster.aggro then
		radius = 1100
	end
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )

	local patrolPoint1 = Vector(7165, 9865)
	local patrolPoint2 = Vector(10268, 11660)
	local patrolPoint3 = Vector(8640, 15744)
	local i = 0
	local manaLeak = caster:FindAbilityByName("wandering_mage_mana_leak")
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			Timers:CreateTimer(i*0.3, function()
				local newOrder = {
				 		UnitIndex = caster:entindex(), 
				 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				 		TargetIndex = enemy:entindex(),
				 		AbilityIndex = manaLeak:entindex(),
				 	}
				 
				ExecuteOrderFromTable(newOrder)
			end)
			i = i+1
		end
	end
	if not caster.aggro then
		local casterPos = caster:GetAbsOrigin()
		if casterPos.x > patrolPoint1.x-150 and casterPos.x < patrolPoint1.x+150 and casterPos.y > patrolPoint1.y-150 and casterPos.y < patrolPoint1.y+150 then
			caster:MoveToPosition(patrolPoint2)
		elseif casterPos.x > patrolPoint2.x-150 and casterPos.x < patrolPoint2.x+150 and casterPos.y > patrolPoint2.y-150 and casterPos.y < patrolPoint2.y+150 then
			caster:MoveToPosition(patrolPoint3)
		elseif casterPos.x > patrolPoint3.x-150 and casterPos.x < patrolPoint3.x+150 and casterPos.y > patrolPoint3.y-150 and casterPos.y < patrolPoint3.y+150 then
			caster:MoveToPosition(patrolPoint1)
		end
	end
end

function wandering_mage_mana_leak_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if not target.manaLeakPos then
		target.manaLeakPos = target:GetAbsOrigin()
	end
	if not target.manaLeakdistanceMoved then
		target.manaLeakdistanceMoved = 0
	end
	target.newManaLeakPos = target:GetAbsOrigin()
	local distance = WallPhysics:GetDistance(target.newManaLeakPos,target.manaLeakPos)
	target.manaLeakdistanceMoved = target.manaLeakdistanceMoved + distance
	if target.manaLeakdistanceMoved > 80 then
		for i = 1, target.manaLeakdistanceMoved/80, 1 do
			target:ReduceMana(target:GetMaxMana()*0.03)
			local particleName = "particles/units/heroes/hero_keeper_of_the_light/keeper_mana_leak_impact_bits.vpcf"
			local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
			ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			Timers:CreateTimer(0.5, function() 
			  ParticleManager:DestroyParticle( pfx, false )
			end) 	
			if target:GetMana() < 5 then
				target:AddNewModifier(caster, nil, "modifier_stunned", {duration = event.stun_duration})
				EmitSoundOn("Hero_KeeperOfTheLight.ManaLeak.Stun", target)
			end
			if i > 2 then
				break
			end
		end
		target.manaLeakdistanceMoved =target.manaLeakdistanceMoved%80
	end
	target.manaLeakPos = target:GetAbsOrigin()
end

function desert_necro_think(event)
	local caster = event.caster
	if not caster.summonCount then
		caster.summonCount = 0
	end
	if not caster.aggro then
		StartAnimation(caster, {duration=1.5, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.7})
		 local particleName = "particles/econ/items/lanaya/lanaya_epit_trap/templar_assassin_epit_trap_explode.vpcf"
		 local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_RENDERORIGIN_FOLLOW, caster.visionTracer)
		 ParticleManager:SetParticleControl(particle1,0,Vector(7144, 12480, 170))

		Timers:CreateTimer(2, function()
			ParticleManager:DestroyParticle(particle1, false)
		end)
	else
		if caster.summonCount < 10 and caster:IsAlive() then
			StartAnimation(caster, {duration=1.5, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.7})
			caster.summonCount = caster.summonCount + 1
			local summon = Dungeons:SpawnDungeonUnit("enslaved_corpse", Vector(7144, 12480, 120), 1, 0, 0, "life_stealer_lifest_anger_04", Vector(0,1), true, nil)
			StartAnimation(caster, {duration=1.5, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.7})
			 local particleName = "particles/econ/items/lanaya/lanaya_epit_trap/templar_assassin_epit_trap_explode.vpcf"
			 local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_RENDERORIGIN_FOLLOW, caster.visionTracer)
			 ParticleManager:SetParticleControl(particle1,0,Vector(7144, 12480, 170))

			Timers:CreateTimer(2, function()
				ParticleManager:DestroyParticle(particle1, false)
			end)
		end
	end
end

function desert_necro_die(event)
	local caster = event.caster
	local position = caster:GetAbsOrigin()
	local fv = caster:GetForwardVector()
	UTIL_Remove(caster.visionTracer)
	Timers:CreateTimer(1.5, function()
		local necromancer = Dungeons:SpawnDungeonUnit("desert_ruins_necromancer", position, 1, 2, 3, "necrolyte_necr_deny_10", fv, false, nil)
		local necroAbility = necromancer:FindAbilityByName("desert_ruins_necromancer_ai")
		necromancer:RemoveModifierByName("modifier_desert_ruins_necromancer_ai")
		necroAbility:ApplyDataDrivenModifier(necromancer, necromancer, "modifier_desert_ruins_necromancer_ghost", {})
	end)
end

function ghost_necro_think(event)
	local caster = event.caster
	local patrolPoint1 = Vector(9792, 15917)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 420, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		if not caster.stop then
			caster:MoveToPosition(patrolPoint1)
			caster.stop = true
			Timers:CreateTimer(4, function()
				caster:Stop()
				caster.stop = false
			end)
		end
	end
	local casterPos = caster:GetAbsOrigin()

	if casterPos.x > patrolPoint1.x-150 and casterPos.x < patrolPoint1.x+150 and casterPos.y > patrolPoint1.y-150 and casterPos.y < patrolPoint1.y+150 and not caster.sequence then
		caster.sequence = true
		caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
		caster:SetForwardVector(Vector(0,1))
		local gravePos = Vector(9600, 15424, 377)
		AddFOWViewer(DOTA_TEAM_GOODGUYS, gravePos, 700, 300, false)
		StartAnimation(caster, {duration=5, activity=ACT_DOTA_TELEPORT, rate=0.9})
		local motionVector = gravePos-casterPos+Vector(0,0,700)
		print(casterPos)
		print(gravePos)
		print("MOTION VECTOR")
		print(motionVector)
		Timers:CreateTimer(0.9, function()
			EmitGlobalSound("necrolyte_necr_deny_10")
			EmitGlobalSound("necrolyte_necr_deny_10")
		end)
		for i = 0, 85, 1 do
			Timers:CreateTimer(i*0.03, function()
				caster:SetAbsOrigin(casterPos+((motionVector)/85)*i)
			end)
		end
		Timers:CreateTimer(90*0.03, function()
			caster:SetForwardVector(Vector(0,1))
			 local particleName = "particles/econ/items/lanaya/lanaya_epit_trap/templar_assassin_epit_trap.vpcf"
			 local visionTracer = CreateUnitByName("npc_flying_dummy_vision", Vector(9600, 15616, 13), false, nil, nil, DOTA_TEAM_NEUTRALS)
			 visionTracer:AddAbility("dummy_unit"):SetLevel(1)
			 local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_RENDERORIGIN_FOLLOW, visionTracer)
			 ParticleManager:SetParticleControl(particle1,0,Vector(9600, 15616, 613))
			 -- table.insert(Dungeons.ruinsEntityTable, visionTracer)
			 EmitSoundOn("Hero_TemplarAssassin.Trap", visionTracer)
			 Timers:CreateTimer(1.3, function()
			 	caster:SetForwardVector(Vector(0,1))
			 	StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.7})
			 	EmitSoundOn("Hero_TemplarAssassin.Trap.Trigger", visionTracer)
			 	particleName = "particles/econ/items/lanaya/lanaya_epit_trap/templar_assassin_epit_trap_explode.vpcf"
				 local particle2 = ParticleManager:CreateParticle(particleName, PATTACH_RENDERORIGIN_FOLLOW, caster.visionTracer)
				 ParticleManager:SetParticleControl(particle2,0,Vector(9600, 15616, 613))
				 local thorok = Dungeons:SpawnDungeonUnit("thorok_reborn", Vector(9600, 15616, 13), 1, 5, 7, "life_stealer_lifest_immort_02", Vector(0,1), true, nil)
				 Events:AdjustBossPower(thorok, 8, 4, false)
				 EmitGlobalSound("life_stealer_lifest_immort_02")
				 EmitGlobalSound("life_stealer_lifest_immort_02")
				 thorok.necromancer = caster
				Timers:CreateTimer(2, function()
					ParticleManager:DestroyParticle(particle2, false)
				end)
			 end)

		end)
	end
end

function thorok_think(event)
	local caster = event.caster
	if not caster.buffed then
		caster.buffed = 0
	end
	if caster:GetHealth() < caster:GetMaxHealth() *0.45 and caster.buffed == 0 then
		caster.buffed = 1
		local necromancer = caster.necromancer
		local necroAbility = necromancer:FindAbilityByName("desert_ruins_necromancer_ai")
		caster.growScale = 0
		necroAbility:ApplyDataDrivenModifier(necromancer, caster, "modifier_thorok_buffing_up", {duration = 4.2})
	end
end

function thorok_buffing_up(event)
	local target = event.target
	target.growScale = target.growScale + 1
	local newScale = 1.4 + target.growScale/100
	target:SetModelScale(newScale)
	if target.growScale == 2 then
		EmitGlobalSound("necrolyte_necr_attack_05")
		EmitGlobalSound("necrolyte_necr_attack_05")
		EmitGlobalSound("necrolyte_necr_attack_05")
	end
	if target.growScale == 40 then
		EmitGlobalSound("life_stealer_lifest_ability_rage_03")
		EmitGlobalSound("life_stealer_lifest_ability_rage_03")
		EmitGlobalSound("life_stealer_lifest_ability_rage_03")
	end
	target:Heal(target:GetMaxHealth()*0.007, target)
end

function thorok_die(event)
	local caster = event.caster
	EmitGlobalSound("necrolyte_necr_death_01")
	EmitSoundOn("life_stealer_lifest_anger_03", caster)
	StartAnimation(caster.necromancer, {duration=4.0, activity=ACT_DOTA_DIE, rate=0.45})
	Timers:CreateTimer(3.5, function()
		UTIL_Remove(caster.necromancer)
	end)
	local luck = RandomInt(1, 3)
	if luck == 3 then
		RPCItems:RollNecromancerMask(caster.necromancer:GetAbsOrigin())
	end
end

function grave_watcher_think(event)
	local caster = event.caster
	local ability = event.ability
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 720, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_grave_watcher_soul_steal", {duration = 2.5})
		end
	end

end

function grave_watcher_soul_steal_think(event)
	local caster = event.caster
	local target = event.target
	local damage = math.floor(target:GetMaxHealth()*0.02)
	if caster:IsAlive() then
		ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE })
		caster:Heal(damage, caster)
		PopupHealing(caster, damage)
	else
		target:RemoveModifierByName("modifier_grave_watcher_soul_steal")
	end
end

function blighted_sapling_think(event)
	local caster = event.caster
	local ability = event.ability
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 420, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		ability:ApplyDataDrivenModifier(caster, enemies[RandomInt(1, #enemies)], "modifier_blighted_sapling_photosynthesis", {duration = 2.5})
	end
end

function blighted_sapling_photosynthesis_think(event)
	local caster = event.caster
	local target = event.target
	local manaSteal = math.floor(target:GetMaxMana()*0.05)
	if caster:IsAlive() then
		local heal = math.floor(math.min(manaSteal, target:GetMana()))
		target:ReduceMana(manaSteal)
		caster:Heal(heal, caster)
		if heal > 0 then
			PopupHealing(caster, heal)
		end
	else
		target:RemoveModifierByName("modifier_blighted_sapling_photosynthesis")
	end
end

function temple_activator_think(event)
	local caster = event.caster
	local target = event.target
	local distance = WallPhysics:GetDistance(caster:GetAbsOrigin(), target:GetAbsOrigin())
	if distance > 500 then
		target:RemoveModifierByName("modifier_temple_ui_open")
		CustomGameEventManager:Send_ServerToPlayer(target:GetPlayerOwner(), "special_event_close", {} )
	else
	    local particleName = "particles/items_fx/leshrac_wall_beam.vpcf"
	    local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
	    local casterPos = target:GetAbsOrigin()
        local origin = Vector(6126, 15738, 1024)
        ParticleManager:SetParticleControl(lightningBolt,0,Vector(casterPos.x,casterPos.y,casterPos.z+110))   
        ParticleManager:SetParticleControl(lightningBolt,1,Vector(origin.x,origin.y,origin.z))
        Timers:CreateTimer(0.8, function()
        	ParticleManager:DestroyParticle(lightningBolt, false)
        end)
	end
end

function temple_activator_activated(event)
	local target = event.target
	if not Dungeons.highlightedStone then
		Dungeons.highlightedStone = -1
	end
	CustomGameEventManager:Send_ServerToPlayer(target:GetPlayerOwner(), "ruins_console_open", {stoneIndex = Dungeons.highlightedStone} )
end

function desert_ruins_mob_death(event)
	if not Dungeons or not Dungeons.ruinsKills then
		return
	end
	Dungeons.ruinsKills = Dungeons.ruinsKills + 1
	local caster = event.caster
	if Dungeons.ruinsKills >= Dungeons.ruinsKillsThreshold and Dungeons.ruinsRoomEnabled then
		if Dungeons.highlightedStone == 1 then
			Dungeons:RuinsSolarium(false)
		elseif Dungeons.highlightedStone == 2 then
			Dungeons:RuinsThroneRoom(false)
		elseif Dungeons.highlightedStone == 3 then
			Dungeons:RuinsFungalLab(false)
		elseif Dungeons.highlightedStone == 4 then
			Dungeons:RuinsChamberOfSuffering(false)
		elseif Dungeons.highlightedStone == 5 then
			Dungeons:RuinsGardenOfBlight(false)
		elseif Dungeons.highlightedStone == 6 then
			Dungeons:RuinsMausoleum(false)
		elseif Dungeons.highlightedStone == 7 then
			Dungeons:RuinsSandPit(false)
		elseif Dungeons.highlightedStone == 8 then
			Dungeons:RuinsWellOfSacrifice(false)
		end
		if Dungeons.roomKey1 == Dungeons.highlightedStone or Dungeons.roomKey2 == Dungeons.highlightedStone then
			local keyHolder = Dungeons:SpawnDungeonUnit("ruins_key_holder", caster:GetAbsOrigin(), 1, 4, 5, "life_stealer_lifest_anger_04", Vector(0,1), true, nil)
			keyHolder:SetAbsOrigin(caster:GetAbsOrigin() +Vector(0,0,1000))
			keyHolder.jumpEnd = "hermit"
			WallPhysics:Jump(keyHolder, Vector(0,0), 0, 30, 1, 1)
			Events:AdjustBossPower(keyHolder, 3, 3, false)
		end
		for i = 1, #MAIN_HERO_TABLE, 1 do
			MAIN_HERO_TABLE[i].ruinsPorted = false
		end
	end
	local luck = RandomInt(1+GameState:GetPlayerPremiumStatusCount(), 1000)
	if luck == 1000 then
		RPCItems:RollRuinfallSkullToken(caster:GetAbsOrigin())
	end

end

function solarium_enigma_think(event)
	local caster = event.caster
	local blackhole = caster:FindAbilityByName("enigma_black_hole")
	if not blackhole then
		blackhole = caster:FindAbilityByName("arena_lies_black_hole")
	end
	if not caster.interval then
		caster.interval = 0
	end
	caster.interval = caster.interval + 1
	if caster.interval > 5 then
		blackhole:EndCooldown()
		caster.interval = 0
	end
	if caster:IsStunned() then
		blackhole:EndCooldown()
	end
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_CLOSEST, false )

	if #enemies > 0 then
		local order =
		{
			UnitIndex = caster:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = blackhole:entindex(),
			Position = enemies[1]:GetAbsOrigin() +	RandomVector(400)
		}
		ExecuteOrderFromTable(order)
	end	
end

function rozan_think(event)
	local caster = event.caster
	if caster:IsAlive() then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )

		local stormBolt = caster:FindAbilityByName("rozan_storm_bolt")
		local i = 0
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				Timers:CreateTimer(i*0.9, function()
					local newOrder = {
					 		UnitIndex = caster:entindex(), 
					 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					 		TargetIndex = enemy:entindex(),
					 		AbilityIndex = stormBolt:entindex(),
					 	}
					if stormBolt:IsFullyCastable() then
						ExecuteOrderFromTable(newOrder)
					end
				end)
				i = i+1
			end
		end
	end
end

function fungal_overlord_think(event)
	local caster = event.caster
	if caster.aggro then
		local ability = event.ability
		for i = 1, #MAIN_HERO_TABLE, 1 do
			local position = MAIN_HERO_TABLE[i]:GetAbsOrigin() + RandomVector(310)
			--ability:ApplyDataDrivenThinker(caster, position, "modifier_poison_cloud_thinker", {})
			CustomAbilities:QuickAttachThinker(ability, caster, position, "modifier_poison_cloud_thinker", {})
		end
	end
end

function golden_skullbone_think(event)
	local caster = event.caster
	if caster:GetHealth() < caster:GetMaxHealth()*0.4 and not caster:HasModifier("modifier_golden_skullbone_injured") and caster:GetUnitName() == "ruins_golden_skullbone" then
		caster:SetOriginalModel("models/items/undying/idol_of_ruination/ruin_wight_minion_torso_gold.vmdl")
		caster:SetModel("models/items/undying/idol_of_ruination/ruin_wight_minion_torso_gold.vmdl")
		event.ability:ApplyDataDrivenModifier(caster, caster, "modifier_golden_skullbone_injured", {})
	end
end

function ruin_burrower_think(event)
	local caster = event.caster
	local ability = event.ability
	local vectorTable = {Vector(5201, 11027), Vector(4911, 11344), Vector(5219, 11390), Vector(5478, 11266), Vector(5104, 11590), Vector(4660, 11590), Vector(4525, 11402), Vector(4587, 11719), Vector(4766, 11856), Vector(4992, 11856), Vector(5156, 11908), Vector(5433, 11941), Vector(4763, 11990), Vector(4763, 10987), Vector(4763, 10764), Vector(4989, 10663), Vector(4990, 10469), Vector(5192, 10469), Vector(5340, 10469), Vector(5378, 10628)}
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_ruin_burrower_burrowing", {duration = 3})
	for i = 1, 30, 1 do
		Timers:CreateTimer(i*0.03, function()
			caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,20))
		end)
	end
	Timers:CreateTimer(2.8, function()
		caster:SetAbsOrigin(vectorTable[RandomInt(1,#vectorTable)])
		for i = 1, 30, 1 do
			Timers:CreateTimer(i*0.03, function()
				caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,25))
			end)
		end
		StartAnimation(caster, {duration=1, activity=ACT_DOTA_SPAWN, rate=0.8})
		Timers:CreateTimer(1.1, function()
			StartAnimation(caster, {duration=1.5, activity=ACT_DOTA_IDLE, rate=1})
		end)
		EmitSoundOn("Hero_VenomancerWard.ProjectileImpact", caster)
	end)
end

function ruin_burrower_unburrowed_think(event)
	local caster = event.caster
	local ability = event.ability
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1120, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		EmitSoundOn("Hero_Venomancer.VenomousGale", caster)
		local shotPosition = enemies[RandomInt(1, #enemies)]:GetAbsOrigin()
		local speed = 1100
		local shotVector = (shotPosition-caster:GetAbsOrigin()):Normalized()
		local info = 
		{
				Ability = ability,
		    	EffectName = "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf",
		    	vSpawnOrigin = caster:GetAbsOrigin(),
		    	fDistance = 1200,
		    	fStartRadius = 200,
		    	fEndRadius = 200,
		    	Source = caster,
		    	StartPosition = "attach_origin",
		    	bHasFrontalCone = true,
		    	bReplaceExisting = false,
		    	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		    	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		    	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		    	fExpireTime = GameRules:GetGameTime() + 5.0,
			bDeleteOnHit = false,
			vVelocity = shotVector*700,
			bProvidesVision = false,
		}
	
	projectile = ProjectileManager:CreateLinearProjectile(info)	
		caster:SetForwardVector(shotVector*Vector(1,1,0))
		Timers:CreateTimer(0.1, function()
			StartAnimation(caster, {duration=1, activity=ACT_DOTA_ATTACK, rate=0.8})
		end)
		Timers:CreateTimer(1.2, function()
			StartAnimation(caster, {duration=1.8, activity=ACT_DOTA_IDLE, rate=1})
		end)
	end	
end

function ruins_blood_arcanist_think(event)
	local caster = event.caster
	if caster.aggro then
		local bloodTowerLocation = Vector(8704, 10432)
		caster:MoveToPosition(bloodTowerLocation)
		if WallPhysics:GetDistance(bloodTowerLocation, caster:GetAbsOrigin()*Vector(1,1,0)) < 400 then
			local flyingGuy = Dungeons:SpawnDungeonUnit("ruins_blood_arcanist_flying", caster:GetAbsOrigin(), 1, 5, 8, "keeper_of_the_light_keep_incant_01", Vector(1, 1), true, nil)
			Events:AdjustBossPower(flyingGuy, 1, 1, false)
			EmitSoundOn("keeper_of_the_light_keep_laugh_01", flyingGuy)
			flyingGuy:SetRenderColor(200, 0, 0)
			UTIL_Remove(caster)
		end
	end
end

function ruins_blood_arcanist_flying_think(event)
	local caster = event.caster
	if caster:IsAlive() then
	    local particleName = "particles/items_fx/castle_boss_wall_beam.vpcf"
	    local casterPos = caster:GetAbsOrigin()  
	    local bloodTowerLocation = Vector(8704, 10432)
	    local origin = bloodTowerLocation + Vector(0,0,RandomInt(100, 800))
	    for i = 1, 4, 1 do
	    	Timers:CreateTimer(0.1*(i-1), function()
			    local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
			    ParticleManager:SetParticleControl(lightningBolt,0,Vector(casterPos.x,casterPos.y,casterPos.z+140))   
			    ParticleManager:SetParticleControl(lightningBolt,1,Vector(origin.x,origin.y,origin.z+500))
			    Timers:CreateTimer(0.5, function()
			    	ParticleManager:DestroyParticle( lightningBolt, false )
			    end)
	    	end)
	    end
	    if not caster.towerFV then
	    	caster.towerFV = (bloodTowerLocation-casterPos*Vector(1,1,0)):Normalized()
	    	AddFOWViewer(DOTA_TEAM_GOODGUYS, bloodTowerLocation, 700, 300, false)
	    end
	    if not caster.interval then
	    	caster.interval = 0

	    end
	    if caster.interval%180 == 0 then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
			local i = 0
			local rupture = caster:FindAbilityByName("blood_arcanist_rupture")
			if #enemies > 0 then
				for _,enemy in pairs(enemies) do
					Timers:CreateTimer(i*0.4, function()
						local newOrder = {
						 		UnitIndex = caster:entindex(), 
						 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
						 		TargetIndex = enemy:entindex(),
						 		AbilityIndex = rupture:entindex(),
						 	}
						 
						ExecuteOrderFromTable(newOrder)
					end)
					i = i+1
				end
			end
	    end
	    caster.towerFV = WallPhysics:rotateVector(caster.towerFV, math.pi/90)
	    caster:SetAbsOrigin(bloodTowerLocation + caster.towerFV*400 + Vector(0,0,950))
	    caster.interval = caster.interval + 1
	    if caster.interval >= 360 then
	    	caster.interval = 0
	    end
	end

end

function ruins_key_pickup(event)
	if not Dungeons.ruinsKeyCount then
		Dungeons.ruinsKeyCount = 0
	end
	print(Dungeons.delayFire)
	if not Dungeons.delayFire then
		Dungeons.delayFire = true
		print("RUINS KEY COUNT")
		print(Dungeons.ruinsKeyCount)
		local visionTracer = CreateUnitByName("npc_flying_dummy_vision", Vector(6218, 14450), true, nil, nil, DOTA_TEAM_GOODGUYS)
		visionTracer:AddAbility("dummy_unit"):SetLevel(1)
		visionTracer:AddNewModifier( visionTracer, nil, 'modifier_movespeed_cap', nil )
		local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
		Timers:CreateTimer(0.6, function()
			for i = 1, #MAIN_HERO_TABLE, 1 do
				local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
				if playerID then
					gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, MAIN_HERO_TABLE[i], "modifier_disable_player", {duration = 4})
					MAIN_HERO_TABLE[i]:Stop()
					PlayerResource:SetCameraTarget(playerID, visionTracer)
				end
			end
		end)
		Timers:CreateTimer(1.5, function()
			if Dungeons.ruinsKeyCount == 0 then
				local runeKey = CreateUnitByName("npc_flying_dummy_vision", Vector(5900, 14379, 800), true, nil, nil, DOTA_TEAM_GOODGUYS)
				Dungeons.ruinsKeyCount = 1
				Timers:CreateTimer(0.05, function()
					StartAnimation(runeKey, {duration=300, activity=ACT_DOTA_IDLE, rate=0.9})
				end)
				runeKey:AddAbility("dummy_unit"):SetLevel(1)	
				runeKey:SetModel("models/props_gameplay/rune_haste01.vmdl")
				runeKey:SetOriginalModel("models/props_gameplay/rune_haste01.vmdl")
				for i = 1, 4, 1 do
					EmitSoundOn("Hero_Chen.HandOfGodHealCreep", runeKey)
				end
			elseif Dungeons.ruinsKeyCount == 1 then
				local runeKey = CreateUnitByName("npc_flying_dummy_vision", Vector(6577, 14369, 800), true, nil, nil, DOTA_TEAM_GOODGUYS)
				Dungeons.ruinsKeyCount = 2
				Timers:CreateTimer(0.05, function()
					StartAnimation(runeKey, {duration=300, activity=ACT_DOTA_IDLE, rate=0.9})
				end)
				runeKey:AddAbility("dummy_unit"):SetLevel(1)	
				runeKey:SetModel("models/props_gameplay/rune_haste01.vmdl")
				runeKey:SetOriginalModel("models/props_gameplay/rune_haste01.vmdl")
				for i = 1, 4, 1 do
					EmitSoundOn("Hero_Chen.HandOfGodHealCreep", runeKey)
				end
				Timers:CreateTimer(1.5, function()
					local bossVector = Vector(1379, 14063)
					local portal = CreateUnitByName("beacon", Vector(6218, 14450), true, nil, nil, DOTA_TEAM_GOODGUYS)
					AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(6218, 14450), 300, 300, false)
					portal.active = active
			  		portal:NoHealthBar()
			  		portal:AddAbility("town_portal")
			  		portal:FindAbilityByName("town_portal"):SetLevel(1)	
			  		portal.teleportLocation = bossVector
			  		portal.ruinsBossSpecial = true
			  		-- Beacons:CreateParticle(particleName, portal:GetAbsOrigin()+Vector(0,0,10), portal, 0)
			  		Beacons:ActivatePortal(portal, "particles/portals/green_portal.vpcf", Vector(0.68,0.68,0.4))
			  		if Dungeons.ruinsEntityTable then
			  			table.insert(Dungeons.ruinsEntityTable, portal)
			  		end
			  		EmitGlobalSound("ui.set_applied")
			  		EmitGlobalSound("ui.set_applied")
			  		Dungeons:CreateDungeonThinker(Vector(1379, 14063), "boss_initiate", 500, "desert_ruins")
				end)
			end	
		end)
		Timers:CreateTimer(5, function()
			for i = 1, #MAIN_HERO_TABLE, 1 do
				local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
				if playerID then
					MAIN_HERO_TABLE[i]:Stop()
					PlayerResource:SetCameraTarget(playerID, MAIN_HERO_TABLE[i])
					Timers:CreateTimer(0.5, function()
						PlayerResource:SetCameraTarget(playerID, nil)
					end)
				end
			end
			Dungeons.delayFire = false
			UTIL_Remove(visionTracer)
		end)
	end
end

function ruins_key_holder_die(event)
	local caster = event.caster
	local item = CreateItem("item_ruins_key", nil, nil)
	local drop = CreateItemOnPositionSync( caster:GetAbsOrigin(), item )
	-- item:LaunchLoot(true, 0, 0, caster:GetAbsOrigin())
	print("key_holder_die")
end

function ruins_boss_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.dying then
		if not caster.interval then
			caster.interval = 0
		end
		if caster.interval %80 == 0 then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_ruins_boss_berserk", {duration = 4})
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_ruins_jumping", {duration = 4})
		end
		caster.interval = caster.interval + 1
		if caster.interval >= 150 then
			if not caster.dying then
				ruins_boss_throw_spear_attack(caster, ability)
				caster.stageTwo = false
			end
			caster.interval = 0
		end
	end
end

function ruins_boss_throw_spear_attack(caster, ability)
	print("THROW SPEAR BEGIN")
	local throwingSpearPoints = {Vector(1344, 13120), Vector(1344, 14973), Vector(2280, 14009), Vector(2280, 14409)}
	local soundTable = {"huskar_husk_ability_lifebrk_06", "huskar_husk_ability_lifebrk_07", "huskar_husk_ability_brnspear_01", "huskar_husk_ability_brnspear_06"}
	local campPoint = throwingSpearPoints[RandomInt(1,4)]
	StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_LIFE_BREAK_START, rate=0.9})
	Timers:CreateTimer(0.2, function()
		EmitSoundOn(WallPhysics:GetRandomItemFromTable(soundTable), caster)
	end)
	EmitSoundOn("Hero_Huskar.Life_Break", caster)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_ruins_boss_intro", {duration = 1})
	local movementVector = (campPoint-caster:GetAbsOrigin()*Vector(1,1,0))/30
	caster:SetForwardVector(movementVector:Normalized())
	for i = 1, 30, 1 do
		Timers:CreateTimer(0.03*i, function()
			caster:SetAbsOrigin(caster:GetAbsOrigin()+movementVector)
		end)
	end
	Timers:CreateTimer(0.92, function()
		StartAnimation(caster, {duration=0.2, activity=ACT_DOTA_CAST_LIFE_BREAK_END, rate=1})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_ruins_boss_spear_throwing", {duration = 4})
		Timers:CreateTimer(0.5, function()
			EmitGlobalSound("huskar_husk_laugh_03")
		end)
	end)

end

function ruins_boss_throwing_spears(event)

	local caster = event.caster
	local ability = event.ability
	if not caster.dying then
		local centerPoint = Vector(1379, 14063)
		StartAnimation(caster, {duration=0.22, activity=ACT_DOTA_ATTACK, rate=2.4})
		-- local medianShotVector = (centerPoint-caster:GetAbsOrigin()*Vector(1,1,0)):Normalized()
		-- local boundingMin = WallPhysics:rotateVector(medianShotVector, math.pi/2)
		-- local boundingMax = WallPhysics:rotateVector(medianShotVector, -math.pi/2)
		-- local randomShotVector = (boundingMin+(boundingMax/RandomInt(1, 180))):Normalized()
		-- local shotPosition = centerPoint+randomShotVector*300
		local shotPosition = centerPoint+RandomVector(800)
		local randomShotVector = ((shotPosition-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		caster:SetForwardVector(randomShotVector*Vector(1,1,0))
			local info = 
			{
				Ability = ability,
		        	EffectName = "particles/econ/items/mirana/mirana_crescent_arrow/ruins_boss_linear.vpcf",
		        	vSpawnOrigin = caster:GetAbsOrigin()+caster:GetForwardVector()+90,
		        	fDistance = 3200,
		        	fStartRadius = 190,
		        	fEndRadius = 190,
		        	Source = caster,
		        	StartPosition = "attach_attack1",
		        	bHasFrontalCone = true,
		        	bReplaceExisting = false,
		        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		        	fExpireTime = GameRules:GetGameTime() + 7.0,
				bDeleteOnHit = false,
				vVelocity = randomShotVector * 1200,
				bProvidesVision = false,
			}
			projectile = ProjectileManager:CreateLinearProjectile(info)	
			EmitSoundOn("Hero_Huskar.PreAttack", caster)
	end
end

function ruins_boss_projectile_hit(event)
	local target = event.target
	local caster = event.caster
	local damage = Events:GetAdjustedAbilityDamage(8000, 25000, 30000)
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE })
	EmitSoundOn("Hero_Invoker.SunStrike.Ignite", target)
      local particleName = "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf"
      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
      ParticleManager:SetParticleControl( particle1, 0, target:GetAbsOrigin() )
      Timers:CreateTimer(2, 
      function()
        ParticleManager:DestroyParticle( particle1, false )
      end)
end

function ruins_boss_jumping_init(event)
	local caster = event.caster
	if not caster.stageTwo then
		caster.stageTwo = true
	else		
		local soundTable = {"huskar_husk_laugh_01", "huskar_husk_laugh_02", "huskar_husk_laugh_10"}
		EmitSoundOn(soundTable[RandomInt(1,#soundTable)], caster)
		caster.jumpsRemaining = 4
		caster.jumpEnd="ruins_boss"
		local targets = Dungeons:GetTargetTable()
		local target = targets[RandomInt(1, #targets)]
		local jumpVector = (target:GetAbsOrigin()-caster:GetAbsOrigin()):Normalized()
		WallPhysics:Jump(caster, jumpVector, 30, 60, 1.5, 1.5)
	end
end

function ruby_giant_think(event)
	local caster = event.caster
	if caster.aggro then
		local ability = event.ability
		local luck = RandomInt(1, 2)
		StartAnimation(caster, {duration=1.6, activity=ACT_TINY_TOSS, rate=0.8})
		local stunDuration = GameState:GetDifficultyFactor()*0.5 + 1.2
		local damage = event.damage
		if luck == 1 then
			for i = -5, 5, 1 do
				local fv = WallPhysics:rotateVector(caster:GetForwardVector(), (math.pi/5)*i)
				Timers:CreateTimer(0.2*(i+6), function()
					local quakePosition = caster:GetAbsOrigin() + fv*500
					ruby_giant_quake(quakePosition, caster, 260, stunDuration, damage, true, ability)
				end)
			end
		else
			local fv1 = caster:GetForwardVector()
			for i = -3, 3, 1 do
				Timers:CreateTimer(0.2*(i+4), function()
					local quakePosition = caster:GetAbsOrigin() + fv1*400*i
					ruby_giant_quake(quakePosition, caster, 260, stunDuration, damage, true, ability)
				end)
			end
			Timers:CreateTimer(1.5, function()
				local fv2 = WallPhysics:rotateVector(fv1, math.pi/2)
				for i = -3, 3, 1 do
					Timers:CreateTimer(0.2*(i+4), function()
						local quakePosition = caster:GetAbsOrigin() + fv2*400*i
						ruby_giant_quake(quakePosition, caster, 260, stunDuration, damage, true, ability)
					end)
				end			
			end)
		end
	end
end

function ruby_giant_quake(position, caster, radius, stun_duration, damage, bSound, ability)
	local splitEarthParticle = "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf"
	local pfx = ParticleManager:CreateParticle( splitEarthParticle, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, position )
	ParticleManager:SetParticleControl( pfx, 1, Vector(radius, radius, radius) )
	if bSound then
		EmitSoundOn("Hero_Leshrac.Split_Earth", caster)
	end
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius+5, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
			enemy:AddNewModifier(caster, nil, "modifier_stunned", {duration = stun_duration})		
		end
	end 	
end

function ruby_giant_die(event)
	local caster = event.caster
	Timers:CreateTimer(1.2, function()
		ScreenShake(caster:GetAbsOrigin(), 200, 0.5, 1, 9000, 0, true)
		EmitSoundOn("Hero_Leshrac.Split_Earth", caster)
		local luck = RandomInt(1, 3)
		if luck == 1 then
			RPCItems:RollOmegaRuby(caster:GetAbsOrigin())
		end
	end)	
end