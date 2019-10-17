function tanari_ancient_think(event)
	local caster = event.caster
	local ability = event.ability
	local baseDamage = event.damage
	if caster.aggro then
		if ability:IsFullyCastable() then
			ability:StartCooldown(10)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_ancient_quaking", {duration = 3})
			for i = 1, 30, 1 do
				Timers:CreateTimer(i * 0.03, function()
					local offsetFactor = (math.cos(math.pi * i / 30) + 1)
					caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, offsetFactor * 4))
				end)
			end
			local radius = 2200
			if GameState:GetDifficultyFactor() == 1 then
				radius = 1000
			end
			for j = 1, 3, 1 do
				Timers:CreateTimer(1 * j, function()
					if IsValidEntity(caster) then
						if caster:IsAlive() then
							local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
							for _, enemy in pairs(enemies) do
								local distance = WallPhysics:GetDistance(caster:GetAbsOrigin(), enemy:GetAbsOrigin())
								local damage = baseDamage * distance / 10
								ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
								enemy:AddNewModifier(caster, nil, "modifier_stunned", {duration = 0.7})
								EmitSoundOn("Tanari.Ancient.Quake", enemy)
								local splitEarthParticle = "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf"
								local pfx = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, enemy)
								ParticleManager:SetParticleControl(pfx, 0, enemy:GetAbsOrigin())
								ParticleManager:SetParticleControl(pfx, 1, Vector(90, 90, 90))
								Timers:CreateTimer(2, function()
									ParticleManager:DestroyParticle(pfx, false)
								end)
							end
						end
					end
				end)
			end
			Timers:CreateTimer(2.1, function()
				for i = 1, 30, 1 do
					Timers:CreateTimer(i * 0.03, function()
						local offsetFactor = (math.cos(math.pi * i / 30) + 1)
						caster:SetAbsOrigin(caster:GetAbsOrigin() - Vector(0, 0, offsetFactor * 4))
					end)
				end
			end)
		end
	end
end

function water_shield_attack(event)
	--print("ATTACKED SHIELD")
	local caster = event.caster
	local ability = event.ability
	if not caster.attackCount then
		caster.attackCount = 0
	end
	caster.attackCount = caster.attackCount + 1
	caster:SetRenderColor(255 - (caster.attackCount * 80), 255 - (caster.attackCount * 80), 255)
	if caster.attackCount == 3 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_water_shield_no_more_attack", {})
		Tanari:OpenShieldWall(caster)
	end
end

function summon_water_elemental_voice(event)
	local ability = event.ability
	local caster = event.caster
	EmitSoundOn("furion_furi_ability_wrath_0"..RandomInt(1, 5), caster)
end

function summon_water_elemental_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.summons then
		caster.summons = 0
	end

	if caster.aggro and caster.summons <= 20 then
		if ability:IsFullyCastable() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = ability:entindex(),
				}

				ExecuteOrderFromTable(newOrder)
			end
		end
	end
end

function cast_summon_water_elemental(event)
	local ability = event.ability
	local caster = event.caster

	if not caster.summons then
		caster.summons = 0
	end
	if caster.summons < 5 then
		caster.summons = caster.summons + 1

		local elemental = CreateUnitByName("aqua_mage_water_elemental", caster:GetAbsOrigin() + RandomVector(240), true, caster, caster, caster:GetTeamNumber())
		Events:AdjustDeathXP(elemental)
		elemental:SetDeathXP(0)
		elemental:SetMaximumGoldBounty(0)
		elemental:SetMinimumGoldBounty(0)
		elemental.summoner = caster
		EmitSoundOn("Tanari.WaterTemple.SummonWaterElemental", elemental)

		local particleName = "particles/units/heroes/hero_slark/slark_pounce_splash.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, elemental)
		for k = 0, 4, 1 do
			ParticleManager:SetParticleControl(pfx, k, elemental:GetAbsOrigin() + Vector(0, 0, 250))
		end
		Timers:CreateTimer(1.25, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)

		StartAnimation(elemental, {duration = 1, activity = ACT_DOTA_SPAWN, rate = 1})
	end
end

function water_elemental_attack(event)
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	local particleName = "particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_explode_ti5.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	local origin = target:GetAbsOrigin()
	ParticleManager:SetParticleControl(particle1, 0, origin)
	ParticleManager:SetParticleControl(particle1, 1, origin)
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
	-- EmitSoundOn("Hero_Ancient_Apparition.IceBlast.Target", caster)
	local radius = 390
	local damage = event.damage * 0.01
	local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
			ability:ApplyDataDrivenModifier(attacker, enemy, "modifier_water_temple_elemental_slow", {duration = 2})
		end
	end
end

function water_elemental_die(event)
	local caster = event.caster
	local summoner = caster.summoner
	if summoner then
		if IsValidEntity(summoner) then
			summoner.summons = summoner.summons - 1
		else
			summoner = false
		end
	end
end

function jellyfish_boss_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 1
	end
	if caster.interval % 6 == 0 then
		EmitSoundOn("Tanari.WaterTemple.Electricity", caster)
		EmitSoundOnLocationWithCaster(Vector(-3456, 14400), "Tanari.WaterTemple.Electricity", caster)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_lightning_active", {duration = 2.6})
		StartAnimation(caster, {duration = 3, activity = ACT_DOTA_RUN, rate = 1.6, translate = "haste"})
		Timers:CreateTimer(2.65, function()
			StartAnimation(caster, {duration = 3.9, activity = ACT_DOTA_IDLE, rate = 1})
		end)
	end
	caster.interval = caster.interval + 1

	if caster.interval > 100 then
		caster.interval = 1
	end
end

function jellyfish_lightning_rods(event)
	local caster = event.caster
	local ability = event.ability
	local beamTable = {{Vector(-3870, 14976), Vector(-3256, 14976)}, {Vector(-3866, 14784), Vector(-3256, 14784)}, {Vector(-3857, 14592), Vector(-3256, 14592)}, {Vector(-3008, 14511), Vector(-2710, 14271)}, {Vector(-2710, 14271), Vector(-2368, 14511)}, {Vector(-2368, 14511), Vector(-2048, 14271)}, {Vector(-2048, 14271), Vector(-1728, 14511)}, {Vector(-1728, 14511), Vector(-1408, 14272)}, {Vector(-1408, 14272), Vector(-1088, 14511)}, {Vector(-1088, 14511), Vector(-768, 14272)}, {Vector(-768, 14272), Vector(-448, 14511)}, {Vector(-1088, 15872), Vector(-192, 15296)}, {Vector(-1119, 15296), Vector(-192, 15872)}}
	for i = 1, #beamTable, 1 do
		Events:CreateLightningBeam(beamTable[i][1] + Vector(0, 0, 860), beamTable[i][2] + Vector(0, 0, 860))
		local fv = (beamTable[i][2] - beamTable[i][1]):Normalized()
		local distance = WallPhysics:GetDistance(beamTable[i][1], beamTable[i][2])
		jellyfish_lightning_projectile(fv, distance, beamTable[i][1], caster, ability, 1500)
	end
	local baseFv = WallPhysics:rotateVector(caster:GetForwardVector(), math.pi / 9)
	for i = 1, 4, 1 do
		Timers:CreateTimer(i * 0.05, function()
			local fv = WallPhysics:rotateVector(baseFv, -math.pi / ((RandomInt(200, 1500) / 100)))
			local distance = 1500
			jellyfish_lightning_projectile(fv, distance, Vector(-664, 15616), caster, ability, 600)
		end)
	end
	-- Events:CreateLightningBeam(positionBase, positionBase+RandomVector(RandomInt(200,800))+Vector(0,0,RandomInt(1600,2000)))
end

function jellyfish_lightning_projectile(fv, maxDistance, projectileOrigin, caster, ability, speed)
	local projectileParticle = "particles/econ/items/zeus/lightning_weapon_fx/linear_electric_immortal_lightning.vpcf"
	local start_radius = 55
	local end_radius = 55
	local range = maxDistance
	local info =
	{
		Ability = ability,
		EffectName = projectileParticle,
		vSpawnOrigin = projectileOrigin + Vector(0, 0, 840),
		fDistance = range,
		fStartRadius = start_radius,
		fEndRadius = end_radius,
		Source = caster,
		StartPosition = "attach_origin",
		bHasFrontalCone = true,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 4.0,
		bDeleteOnHit = false,
		vVelocity = fv * speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
end

function jellyfish_electrocute(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	if not target:HasModifier("modifier_water_temple_lightning_immune") and not target:HasModifier("modifier_lightning_stun") then
		Tanari:ElectrocuteUnit(caster, ability, target, false)
	end
end

function jellyfish_boss_die(event)
	local caster = event.caster
	Timers:CreateTimer(1.6, function()
		local blockers = Entities:FindAllByNameWithin("WaterWallBlockerElec", Vector(-4864, 15168, 119), 900)
		for i = 1, #blockers, 1 do
			UTIL_Remove(blockers[i])
		end
		local generator = Entities:FindByNameNearest("WaterTempleGenerator", Vector(-610, 16322), 600)
		for i = 1, 60, 1 do
			Timers:CreateTimer(i * 0.03, function()
				generator:SetRenderColor(255 - (i * 3.2), 255 - (i * 3.2), 255 - (i * 3.2))
			end)
		end
		EmitGlobalSound("Tanari.WaterTemple.GeneratorDown")
	end)
	Tanari.WaterTemple.jellyfishSlain = true
	Tanari:WaterTemplePrisonRoom()
	Timers:CreateTimer(0.1, function()
		StartAnimation(caster, {duration = 3, activity = ACT_DOTA_DIE, rate = 1})
	end)
end

function ElectricWallTouch(trigger)
	if not Tanari.WaterTemple.jellyfishSlain then
		local hero = trigger.activator
		local caster = Tanari.WaterTemple.jellyfish
		local ability = Tanari.WaterTemple.jellyfish:FindAbilityByName("water_temple_boss_jellyfish_ai")
		Tanari:ElectrocuteUnit(caster, ability, hero, Vector(1, 0))
	end
end

function jellyfish_lightning_wall(event)
	Events:CreateLightningBeam(Vector(-4889, 14858, 560), Vector(-4889, 15571, 560))
end

function WaterTempleBlockTrigger(trigger)
	local block = Entities:FindByNameNearest("WaterTempleElecBlock", Vector(-1563, 16040, 133), 600)
	block:SetRenderColor(255, 123, 125)
	EmitSoundOn("Tanari.WaterTemple.SwitchActivate", trigger.activator)
	Tanari:LowerWaterTempleWall(-6, "WaterTempleWallTreasure", Vector(-1837, 12503), "WaterTempleTreasureBlocker", Vector(-1792, 12416, 119), 900, true, false)

	local chest = CreateUnitByName("chest", Vector(-3136, 11995), true, nil, nil, DOTA_TEAM_GOODGUYS)
	chest:SetForwardVector(Vector(1, 0))
	chest:FindAbilityByName("town_unit"):SetLevel(1)
	Tanari.WaterTemple.TempleChest1 = chest
end

function WaterTempleChest1(trigger)
	local chest = Tanari.WaterTemple.TempleChest1
	EmitSoundOn("ui.treasure_unlock.wav", chest)
	EmitSoundOn("ui.treasure_unlock.wav", chest)
	EmitSoundOn("ui.treasure_unlock.wav", chest)
	StartAnimation(chest, {duration = 7, activity = ACT_DOTA_DIE, rate = 0.28})
	Dungeons.lootLaunch = chest:GetAbsOrigin() + Vector(200, 0)
	Timers:CreateTimer(2.0, function()
		for i = 0, RandomInt(7, 8 + GameState:GetPlayerPremiumStatusCount()), 1 do
			EmitSoundOn("General.FemaleLevelUp", chest)
			RPCItems:RollItemtype(300, chest:GetAbsOrigin(), 1, 0)
		end
		local particleName = "particles/econ/items/sven/sven_warcry_ti5/sven_spell_warcry_ti_5.vpcf"
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, chest)
		local origin = chest:GetAbsOrigin()
		ParticleManager:SetParticleControl(particle1, 0, origin)
		ParticleManager:SetParticleControl(particle1, 1, origin)
		ParticleManager:SetParticleControl(particle1, 2, origin)
		ParticleManager:SetParticleControl(particle1, 3, origin)
	end)
	Timers:CreateTimer(6.5, function()
		Dungeons.lootLaunch = false
		UTIL_Remove(chest)
	end)
end

function jellyfish_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster:IsAlive() then
		if not caster:HasModifier("modifier_jellyfish_short_speed_boost") then

			local enemies1 = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
			for _, enemy in pairs(enemies1) do
				caster:MoveToPosition(enemy:GetAbsOrigin())
			end
			local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 95, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
			if #allies > 1 then
				caster:MoveToPosition(caster:GetAbsOrigin() + RandomVector(150))
			end
		end
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 120, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		for _, target in pairs(enemies) do
			if not target:HasModifier("modifier_water_temple_lightning_immune") and not target:HasModifier("modifier_lightning_stun") then
				Tanari:ElectrocuteUnit(caster, ability, target, false)
				for i = 1, 6, 1 do
					Timers:CreateTimer(i * 0.2, function()
						Events:CreateLightningBeam(caster:GetAbsOrigin() + Vector(0, 0, 160), target:GetAbsOrigin() + Vector(0, 0, 100))
					end)
				end
			end


			Timers:CreateTimer(1.3, function()
				local moveDirection = ((caster:GetAbsOrigin() - target:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_jellyfish_short_speed_boost", {duration = 0.7})
				caster:MoveToPosition(target:GetAbsOrigin() + moveDirection * 290)
			end)
		end
	end
end

function ElectricRoomSpawn()
	Tanari:SpawnElectricRoomMobs()
end

function prison_shank_attack(event)
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	if target:IsHero() then
		local damage = event.target:GetAgility() * event.agility_mult
		ApplyDamage({victim = target, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_slark/slark_essence_shift.vpcf", target, 1)
	end
end

function WaterMazeTrigger1()

	if not Tanari.WaterTemple.wallDropping then
		local wallPosition, buttonPosition1, buttonPosition2 = GetPositionsByIndex(1)
		pressButtonAndLowerWall(wallPosition, buttonPosition1, buttonPosition2, 1)
	end
end

function WaterMazeTrigger2()
	if not Tanari.WaterTemple.wallDropping then
		local wallPosition, buttonPosition1, buttonPosition2 = GetPositionsByIndex(2)
		pressButtonAndLowerWall(wallPosition, buttonPosition1, buttonPosition2, 2)
	end
end

function WaterMazeTrigger3()
	if not Tanari.WaterTemple.wallDropping then
		local wallPosition, buttonPosition1, buttonPosition2 = GetPositionsByIndex(3)
		pressButtonAndLowerWall(wallPosition, buttonPosition1, buttonPosition2, 3)
	end
end

function GetPositionsByIndex(index)
	if index == 1 then
		return Vector(-6352, 14495, 40), Vector(-6741, 14540, 236), Vector(-6064, 14540, 236)
	elseif index == 2 then
		return Vector(-6352, 15296, 40), Vector(-6741, 15296, 236), Vector(-6071, 15296, 236)
	elseif index == 3 then
		return Vector(-6352, 16064, 40), Vector(-6741, 16064, 236), Vector(-6071, 16064, 236)
	end
end

function pressButtonAndLowerWall(wallPosition, buttonPosition1, buttonPosition2, wallIndex)
	--print(Tanari.WaterTemple.wallDown)
	--print("-^^_WALLDOWN_^^-")
	Tanari.WaterTemple.wallDropping = true
	Timers:CreateTimer(2.65, function()
		Tanari.WaterTemple.wallDropping = false
	end)
	if not Tanari.WaterTemple.wallDown then
		Tanari:LowerWaterTempleWall(-6, "WaterTempleMazeDoor", wallPosition, "MazeBlocker", wallPosition + Vector(0, 0, 96 + 228), 380, true, true)
		moveButtons(buttonPosition1, buttonPosition2, true)
	elseif Tanari.WaterTemple.wallDown == wallIndex then
	else
		Tanari:LowerWaterTempleWall(-6, "WaterTempleMazeDoor", wallPosition, "MazeBlocker", wallPosition + Vector(0, 0, 96 + 228), 380, true, true)
		moveButtons(buttonPosition1, buttonPosition2, true)
		local wallPositionA, buttonPosition1A, buttonPosition2A = GetPositionsByIndex(Tanari.WaterTemple.wallDown)
		Tanari:LowerWaterTempleWall(6, "WaterTempleMazeDoor", wallPositionA, "MazeBlocker", wallPositionA + Vector(0, 0, 96 + 1228), 380, false, true)
		moveButtons(buttonPosition1A, buttonPosition2A, false)
	end
	--print("NOW DO WALLDOWN")
	Tanari.WaterTemple.wallDown = wallIndex
	--print(Tanari.WaterTemple.wallDown)

end

function moveButtons(buttonPosition1, buttonPosition2, bDown)
	local movementZ = 0.5
	if bDown then
		movementZ = -0.5
	end
	local switch = Entities:FindByNameNearest("WaterTempleMazeSwitch", buttonPosition1, 400)
	local switch2 = Entities:FindByNameNearest("WaterTempleMazeSwitch", buttonPosition2, 400)
	local walls = {switch, switch2}
	Timers:CreateTimer(0.1, function()
		EmitSoundOnLocationWithCaster(walls[1]:GetAbsOrigin(), "Tanari.WaterTemple.SwitchStart", Events.GameMaster)
	end)
	for i = 1, 60, 1 do
		for j = 1, #walls, 1 do
			Timers:CreateTimer(i * 0.03, function()
				walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin() + Vector(0, 0, movementZ))
			end)
		end
	end
	Timers:CreateTimer(1.7, function()
		EmitSoundOnLocationWithCaster(walls[1]:GetAbsOrigin(), "Tanari.WaterTemple.SwitchEnd", Events.GameMaster)
	end)
end

function culling_blade_phase(event)
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_axe/axe_culling_blade_boost.vpcf", event.caster, 1)
end

function culling_blade_cast(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local threshold = event.threshold / 100
	if target:GetHealth() <= target:GetMaxHealth() * threshold then

		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_bloody.vpcf", target, 3)
		-- CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_axe/axe_culling_blade_hit_sparks.vpcf", target, 1)
		EmitSoundOn("Tanari.WaterTemple.Cull", target)
		ApplyDamage({victim = target, attacker = caster, damage = target:GetMaxHealth() * 10, damage_type = DAMAGE_TYPE_PURE, ability = ability})
	end
end

function executioner_think(event)
	local caster = event.caster
	local ability = event.ability
	local executioner_ability = caster:FindAbilityByName("executioner_culling_blade")
	local threshold = executioner_ability:GetSpecialValueFor("health_threshold_percent") / 100
	if caster.aggro then
		if caster:GetHealth() < caster:GetMaxHealth() * 0.25 then
			ability:ApplyDataDrivenModifier(ability, ability, "modifier_executioner_buff", {})
			CustomAbilities:QuickAttachParticle("particles/econ/items/axe/axe_helm_shoutmask/axe_beserkers_call_owner_shoutmask.vpcf", caster, 1)
		else
			caster:RemoveModifierByName("modifier_executioner_buff")
		end
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_FARTHEST, false)
		for _, enemy in pairs(enemies) do
			if enemy:GetHealth() < enemy:GetMaxHealth() * threshold then
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_executioner_sprint", {duration = 2.2})
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					TargetIndex = enemy:entindex(),
					AbilityIndex = executioner_ability:entindex(),
				}

				ExecuteOrderFromTable(newOrder)
				return true
			end
		end
	end

end

function jailer_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster:IsAlive() then
		return false
	end
	if caster.aggro then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local hookAbility = caster:FindAbilityByName("chef_meat_hook")
			if hookAbility:IsFullyCastable() then
				local targetPoint = enemies[1]:GetOrigin() + enemies[1]:GetForwardVector() * 100
				local order =
				{
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = hookAbility:entindex(),
					Position = targetPoint
				}
				ExecuteOrderFromTable(order)
				local soundTable = {"pudge_pud_ability_hook_06", "pudge_pud_ability_hook_08", "pudge_pud_anger_03", "pudge_pud_anger_04"}
				local soundIndex = RandomInt(1, #soundTable)
				EmitSoundOn(soundTable[soundIndex], caster)
			end
		end
	end
end

function jailer_die(event)
	Timers:CreateTimer(1.5, function()
		Tanari:OpenPrisonGate()
	end)
	EmitSoundOn("pudge_pud_death_11", event.caster)
end

function water_temple_tentacle_take_damage(event)
	if not Tanari.WaterTemple.OctopusStatueClear then
		local caster = event.caster
		local attacker = event.attacker
		if attacker:IsHero() then
			Tanari:TentacleChangeColor(caster, caster.color)
		end
	end
end

function WaterTempleSpineTrigger(event)
	Tanari:ActivateSwitchGeneric(Vector(-6867, 12144, 100), "WaterTempleSpineDoorSwitch", true)
	Timers:CreateTimer(0.5, function()
		Tanari:LowerWaterTempleWall(-6, "WaterTempleWall3", Vector(-7952, 12920, 0), "WaterTempleBlockers3", Vector(-7936, 12864, 119), 1000, true, false)
	end)
	Tanari:SpineRoomSpawn()
end

function faceless_elemental_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 1
	end
	local castAbility = caster:GetAbilityByIndex(DOTA_Q_SLOT)

	local radius = caster.targetRadius
	local minRadius = caster.minRadius
	local cooldown = caster.targetAbilityCD * 2
	local targetFindOrder = caster.targetFindOrder
	if caster.interval % cooldown == 0 and caster.aggro then
		if castAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, targetFindOrder, false)
			if #enemies > 0 then
				local directionVector = ((enemies[1]:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
				local castPoint = enemies[1]:GetAbsOrigin() + directionVector * 300
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = castAbility:entindex(),
					Position = castPoint
				}

				ExecuteOrderFromTable(newOrder)
			end
		end
	end
	caster.interval = caster.interval + 1
	if caster.interval > 100 then
		caster.interval = 1
	end
end

function vault_lord_mana_spill_attack(event)
	local manaDrainPercent = event.mana_drain_percent / 100
	local target = event.target
	local attacker = event.attacker
	local ability = event.ability
	if target:GetMana() < target:GetMaxMana() * 0.05 then
		if not target:HasModifier("modifier_vault_lord_mana_spill_immunity") then
			target:AddNewModifier(attacker, nil, "modifier_stunned", {duration = 0.35})
			ability:ApplyDataDrivenModifier(attacker, target, "modifier_vault_lord_mana_spill_immunity_count", {duration = 3})
			local newStacks = target:GetModifierStackCount("modifier_vault_lord_mana_spill_immunity_count", attacker) + 1
			target:SetModifierStackCount("modifier_vault_lord_mana_spill_immunity_count", attacker, newStacks)
			if newStacks >= 6 then
				ability:ApplyDataDrivenModifier(attacker, target, "modifier_vault_lord_mana_spill_immunity", {duration = 4})
				target:RemoveModifierByName("modifier_vault_lord_mana_spill_immunity_count")
			end
		end
	end
	target:ReduceMana(target:GetMaxMana() * manaDrainPercent)
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_mana_leak.vpcf", target, 1.2)
	EmitSoundOn("Tanari.WaterTemple.ManaSpill", target)
end

function boss_statue_attack(event)
	local ability = event.ability
	local statue = event.target
	local attacker = event.attacker
	statue.timesRotated = statue.timesRotated + 1
	EmitSoundOn("Tanari.WaterTemple.SwitchStartQuiet", statue)
	if statue.type == "completion" then
		boss_statue_hit_final(event)
		return
	end
	if statue.timesRotated <= 6 then
		for i = 1, 15, 1 do
			Timers:CreateTimer(i * 0.03, function()
				statue.startingAngle = statue.startingAngle + 1
				statue:SetAngles(0, statue.startingAngle, 0)
				statue:SetAbsOrigin(statue:GetAbsOrigin() - Vector(0, 0, 1))
			end)
		end
	end
	if statue.timesRotated == 6 then
		if not Tanari.WaterTemple then
			Tanari.WaterTemple = {}
		end
		Timers:CreateTimer(0.35, function()
			EmitSoundOn("Tanari.WaterTemple.SwitchEnd", statue)
		end)
		if statue.type == "spine" then
			Timers:CreateTimer(1.5, function()
				Dungeons:CreateBasicCameraLockForHeroes(Vector(-4943, 10831, 300), 6.4, {attacker})
				local spinePos = Vector(-4904, 10659.3, -78)
				local heightDiff = 672
				local spine = Entities:FindByNameNearest("WaterTempleBossSpine", Vector(-4904, 10659, -750), 600)
				for i = 1, 120, 1 do
					Timers:CreateTimer(i * 0.03, function()
						spine:SetAbsOrigin(spine:GetAbsOrigin() + Vector(0, 0, heightDiff / 120))
					end)
				end
				Timers:CreateTimer(2, function()
					EmitSoundOnLocationWithCaster(Vector(-4943, 10671, 300), "Tanari.WaterTemple.BossStatueMenace", Events.GameMaster)
				end)
			end)
			ability:ApplyDataDrivenModifier(statue, statue, "modifier_water_boss_statue_no_more_attack", {})
			Timers:CreateTimer(3, function()
				statue:RemoveModifierByName("modifier_statue_glowing")
			end)
			Tanari.WaterTemple.bossStatueSpines = true
		elseif statue.type == "trident" then
			Timers:CreateTimer(1.5, function()
				Dungeons:CreateBasicCameraLockForHeroes(Vector(-4943, 10831, 300), 6.4, {attacker})
				local finalTridentPos = Vector(-5160.92, 10624, 483)
				local heightDiff = 713
				local trident = Entities:FindByNameNearest("WaterTempleBossTrident", Vector(-5160, 10624, -250), 600)
				for i = 1, 120, 1 do
					Timers:CreateTimer(i * 0.03, function()
						trident:SetAbsOrigin(trident:GetAbsOrigin() + Vector(0, 0, heightDiff / 120))
					end)
				end
				Timers:CreateTimer(2, function()
					EmitSoundOnLocationWithCaster(Vector(-4943, 10671, 300), "Tanari.WaterTemple.BossStatueMenace", Events.GameMaster)
				end)
			end)
			ability:ApplyDataDrivenModifier(statue, statue, "modifier_water_boss_statue_no_more_attack", {})
			Timers:CreateTimer(3, function()
				statue:RemoveModifierByName("modifier_statue_glowing")
			end)
			Tanari.WaterTemple.bossStatueTrident = true
		elseif statue.type == "mask" then
			Timers:CreateTimer(1.5, function()
				Dungeons:CreateBasicCameraLockForHeroes(Vector(-4943, 10831, 300), 6.4, {attacker})
				local finalHelmPos = Vector(-4888.75, 10624, -102)
				local heightDiff = 900
				local mask = Entities:FindByNameNearest("WaterTempleBossMask", Vector(-4888, 10624, -1000), 600)
				for i = 1, 120, 1 do
					Timers:CreateTimer(i * 0.03, function()
						mask:SetAbsOrigin(mask:GetAbsOrigin() + Vector(0, 0, heightDiff / 120))
					end)
				end
				Timers:CreateTimer(2, function()
					EmitSoundOnLocationWithCaster(Vector(-4943, 10671, 300), "Tanari.WaterTemple.BossStatueMenace", Events.GameMaster)
				end)
			end)
			ability:ApplyDataDrivenModifier(statue, statue, "modifier_water_boss_statue_no_more_attack", {})
			Timers:CreateTimer(3, function()
				statue:RemoveModifierByName("modifier_statue_glowing")
			end)
			Tanari.WaterTemple.bossStatueHelm = true
		end
		Tanari:CheckWaterBossCondition(attacker)
	end

end

function blue_warlock_think(event)
	local caster = event.caster
	if caster.aggro then
		local castAbility = caster:FindAbilityByName("water_temple_warlock_mana_drain")
		if castAbility:IsFullyCastable() and caster:GetMana() < caster:GetMaxMana() * 0.5 then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				if enemies[1]:GetMana() > enemies[1]:GetMaxMana() * 0.2 then
					local newOrder = {
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
						TargetIndex = enemies[1]:entindex(),
						AbilityIndex = castAbility:entindex(),
					}

					ExecuteOrderFromTable(newOrder)
				end
			end
		end
	end
end

function blue_warlock_attack_land(event)
	local attacker = event.attacker
	local caster = event.caster
	local target = event.target
	local damage_per_mana = event.damage_per_mana
	local ability = event.ability
	local manaDrain = math.min(attacker:GetMana(), attacker:GetMaxMana() * 0.2)
	if manaDrain > attacker:GetMaxMana() * 0.07 then
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_dazzle/dazzle_shadow_wave_impact_damage.vpcf", target, 1)
		EmitSoundOn("Tanari.WaterTemple.BlueWarlockAttack", target)
	end
	caster:ReduceMana(manaDrain)
	local magicDamage = manaDrain * damage_per_mana
	ApplyDamage({victim = target, attacker = attacker, damage = magicDamage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
end

function water_emperor_think(event)
	local caster = event.caster
	local ability = event.ability
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 980, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		if caster:HasModifier("modifier_water_emperor_submerged") then
			caster:RemoveModifierByName("modifier_water_emperor_submerged")
			--print("RISE!")
			local animationDuration = 1
			if caster:GetUnitName() == "seafortress_swamp_lady" then
				animationDuration = 2
			end
			StartAnimation(caster, {duration = animationDuration, activity = ACT_DOTA_SPAWN, rate = 1})
			for i = 1, 17, 1 do
				Timers:CreateTimer(0.03 * i, function()
					caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, 34))
				end)
			end
			Timers:CreateTimer(0.18, function()
				particleName = "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash.vpcf"
				local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(particle1, 0, caster:GetAbsOrigin() * Vector(1, 1, 0) + Vector(0, 0, 140))
				EmitSoundOn("Tanari.WaterSplash", caster)
				Timers:CreateTimer(4, function()
					ParticleManager:DestroyParticle(particle1, false)
				end)
			end)
		end
		if caster:GetUnitName() == "water_temple_emperor_elemental" then
			if not caster:HasModifier("modifier_water_emperor_submerged") then
				local castAbility = caster:FindAbilityByName("water_temple_water_emperor_jet")
				if castAbility:IsFullyCastable() then
					local castPoint = enemies[1]:GetAbsOrigin()
					local newOrder = {
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
						AbilityIndex = castAbility:entindex(),
						Position = castPoint
					}

					ExecuteOrderFromTable(newOrder)
					return false
				end
				local castAbility2 = caster:FindAbilityByName("water_temple_water_emperor_jet_2")
				if castAbility2:IsFullyCastable() then
					local newOrder = {
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
						AbilityIndex = castAbility2:entindex(),
					}

					ExecuteOrderFromTable(newOrder)
				end
			end
		end
	else
		if not caster:HasModifier("modifier_water_emperor_submerged") then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_water_emperor_submerged", {})
			--print("FALL!")
			StartAnimation(caster, {duration = 1, activity = ACT_DOTA_CAST_ABILITY_6, rate = 1})
			for i = 1, 17, 1 do
				Timers:CreateTimer(0.03 * i, function()
					caster:SetAbsOrigin(caster:GetAbsOrigin() - Vector(0, 0, 34))
				end)
			end
			Timers:CreateTimer(0.18, function()
				particleName = "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash.vpcf"
				local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(particle1, 0, caster:GetAbsOrigin() * Vector(1, 1, 0) + Vector(0, 0, 140))
				EmitSoundOn("Tanari.WaterSplash", caster)
				Timers:CreateTimer(4, function()
					ParticleManager:DestroyParticle(particle1, false)
				end)
			end)
		end
	end
end

function water_jet_cast(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	local start_radius = 400
	local end_radius = 400
	local range = 1200
	local speed = 750
	local fv = ((target - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	EmitSoundOn("morphling_mrph_anger_0"..RandomInt(1, 7), caster)
	Timers:CreateTimer(0.2, function()
		EmitSoundOn("Tanari.WaterTemple.WaterJet", caster)
	end)
	local projectileParticle = "particles/units/heroes/hero_tidehunter/tidehunter_gush_upgrade.vpcf"
	local info =
	{
		Ability = ability,
		EffectName = projectileParticle,
		vSpawnOrigin = caster:GetAbsOrigin(),
		fDistance = range,
		fStartRadius = start_radius,
		fEndRadius = end_radius,
		Source = caster,
		StartPosition = "attach_origin",
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

function water_jet_cast_2(event)
	local caster = event.caster
	local ability = event.ability
	local start_radius = 400
	local end_radius = 400
	local range = 1200
	local speed = 750
	EmitSoundOn("morphling_mrph_anger_0"..RandomInt(1, 7), caster)
	Timers:CreateTimer(0.2, function()
		EmitSoundOn("Tanari.WaterTemple.WaterJet", caster)
	end)
	local baseFv = caster:GetForwardVector()
	for i = -2, 2, 1 do
		local fv = WallPhysics:rotateVector(baseFv, 2 * i * math.pi / 5)
		local projectileParticle = "particles/units/heroes/hero_tidehunter/tidehunter_gush_upgrade.vpcf"
		local info =
		{
			Ability = ability,
			EffectName = projectileParticle,
			vSpawnOrigin = caster:GetAbsOrigin(),
			fDistance = range,
			fStartRadius = start_radius,
			fEndRadius = end_radius,
			Source = caster,
			StartPosition = "attach_origin",
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

function water_emperor_die(event)
	local caster = event.caster
	if not caster:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		return false
	end
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "morphling_mrph_death_01", caster)
	Timers:CreateTimer(1.5, function()
		Tanari:LowerWaterTempleWall(-6, "WaterTempleWall4", Vector(-8719, 9080), "WaterTempleBlockers4", Vector(-8704, 9088, 219), 900, true, false)
	end)
	Timers:CreateTimer(1, function()
		Tanari:SpawnBackVaultMasterRoom()
	end)
	Timers:CreateTimer(0.5, function()
		particleName = "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash.vpcf"
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(particle1, 0, caster:GetAbsOrigin() * Vector(1, 1, 0) + Vector(0, 0, 140))
		EmitSoundOn("Tanari.WaterSplash", caster)
		Timers:CreateTimer(4, function()
			ParticleManager:DestroyParticle(particle1, false)
		end)
	end)
	local luck = RandomInt(1, 5)
	if luck == 1 then
		RPCItems:RollBootsOfPureWaters(caster:GetAbsOrigin())
	end
end

function vault_master_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster:HasModifier("modifier_vault_master_charging") then
		local castAbility = caster:FindAbilityByName("water_temple_vault_master_storm_bolt")
		if castAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_CLOSEST, false)
			if #enemies > 0 then
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					TargetIndex = enemies[1]:entindex(),
					AbilityIndex = castAbility:entindex(),
				}

				ExecuteOrderFromTable(newOrder)
			end
		end
	end
end

function vault_master_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	if not caster:HasModifier("modifier_vault_master_charging") then
		local attacker = event.attacker
		local distance = WallPhysics:GetDistance(attacker:GetAbsOrigin(), caster:GetAbsOrigin())
		if distance > 650 then
			local soundName = ""
			if caster:GetUnitName() == "water_temple_vault_master" then
				soundName = "Tanari.WaterTemple.VaultMasterCharge"
			elseif caster:GetUnitName() == "arena_descent_passage_keeper" then
				soundName = "Arena.DescentPassageKeeper.SpellAnger"
			end
			EmitSoundOn(soundName, caster)
			caster.chargeTarget = attacker
			CustomAbilities:QuickAttachParticle("particles/econ/items/sven/sven_cyclopean_marauder/sven_cyclopean_warcry.vpcf", caster, 2)
			StartAnimation(caster, {duration = 1, activity = ACT_DOTA_OVERRIDE_ABILITY_3, rate = 1})
			caster:AddNewModifier(caster, nil, 'modifier_movespeed_cap', nil)
			Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, caster, "modifier_ms_thinker", {})
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_vault_master_charging", {})
			local castAbility = caster:FindAbilityByName("water_temple_vault_master_storm_bolt")
			castAbility:EndCooldown()
			caster:MoveToPosition(attacker:GetAbsOrigin())
		end
	end
end

function vault_master_charge_think(event)
	local caster = event.caster
	local target = caster.chargeTarget
	local ability = event.ability
	if not caster:HasModifier("modifier_vault_master_double_attack") then
		local distance = WallPhysics:GetDistance(target:GetAbsOrigin(), caster:GetAbsOrigin())
		caster:MoveToPosition(target:GetAbsOrigin())
		if distance <= 360 then
			local castAbility = caster:FindAbilityByName("water_temple_vault_master_storm_bolt")
			local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				TargetIndex = target:entindex(),
				AbilityIndex = castAbility:entindex(),
			}

			ExecuteOrderFromTable(newOrder)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_vault_master_double_attack", {})
			caster.doubleAttacks = 0
		end
	else
		caster:MoveToTargetToAttack(target)
	end
end

function vault_master_attack(event)
	local caster = event.attacker
	caster.doubleAttacks = caster.doubleAttacks + 1
	if caster.doubleAttacks >= 3 then
		caster:RemoveModifierByName("modifier_vault_master_double_attack")
		caster:RemoveModifierByName("modifier_vault_master_charging")
		caster:RemoveModifierByName('modifier_movespeed_cap')
	end
end

function WaterTempleWaveTrigger(event)
	Tanari:WaterTempleWaveTrigger()
end

function mark_for_death_hit(event)
	local attacker = event.attacker
	local ability = event.ability
	local target = event.target
	local healthPercentage = event.health_damage_multiplier / 100
	local damage = target:GetMaxHealth() * healthPercentage
	ApplyDamage({victim = target, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
end

function vault_wave_room_unit_die(event)
	Tanari.WaterTemple.waveDeaths = Tanari.WaterTemple.waveDeaths + 1
	local roomPos1 = Vector(-9792, 6784)
	local roomPos2 = Vector(-9042, 6784)
	local roomPos3 = Vector(-7616, 8320)
	local roomPos4 = Vector(-7616, 7520)
	local aggressionPoint = Vector(-9408, 9060)
	if Tanari.WaterTemple.waveDeaths >= 26 and Tanari.WaterTemple.doorPhase == 0 then
		Tanari.WaterTemple.doorPhase = 1
		Timers:CreateTimer(0.5, function()
			Tanari:LowerWaterTempleWall(-6, "WaterTempleWaveWall2", Vector(-9078, 7194, 137), "WaterTempleWaveBlocker2", Vector(-9088, 7168, 222), 900, true, false)
			Timers:CreateTimer(1.2, function()
				Tanari:SpawnWaterTempleWaveUnit("water_temple_armored_water_beetle", roomPos2, 10, 58, 0.3)
				Tanari:SpawnWaterTempleWaveUnit("water_temple_serpent_sleeper", roomPos2, 20, 58, 0.3)
				Timers:CreateTimer(3.8, function()
					local lord = Tanari:SpawnBlueWarlock(roomPos2, Vector(0, 1))
					Dungeons:AggroUnit(lord)
					lord = Tanari:SpawnBlueWarlock(roomPos2, Vector(0, 1))
					Dungeons:AggroUnit(lord)
				end)
				Timers:CreateTimer(7.6, function()
					local luck = RandomInt(1, 2)
					if luck == 1 then
						local lord = Tanari:SpawnShark(roomPos2, Vector(0, 1))
						Dungeons:AggroUnit(lord)
						lord = Tanari:SpawnShark(roomPos2, Vector(0, 1))
						Dungeons:AggroUnit(lord)
					else
						local lord = Tanari:SpawnFacelessElemental(roomPos2, Vector(0, 1))
						Dungeons:AggroUnit(lord)
						lord = Tanari:SpawnFacelessElemental(roomPos2, Vector(0, 1))
						Dungeons:AggroUnit(lord)
					end
				end)
			end)
		end)
	elseif Tanari.WaterTemple.waveDeaths >= 55 and Tanari.WaterTemple.doorPhase == 1 then
		Tanari.WaterTemple.doorPhase = 2
		Timers:CreateTimer(0.5, function()
			Tanari:LowerWaterTempleWall(-6, "WaterTempleWaveWall3", Vector(-7911, 8315, 140), "WaterTempleWaveBlocker3", Vector(-7911, 8315, 140), 900, true, false)
			Timers:CreateTimer(1.2, function()
				Tanari:SpawnWaterTempleWaveUnit("water_temple_armored_water_beetle", roomPos3, 10, 58, 0.4)
				Tanari:SpawnWaterTempleWaveUnit("water_temple_blinded_serpent_warrior", roomPos3, 18, 58, 0.4)
				Timers:CreateTimer(3.8, function()
					local lord = Tanari:SpawnSlithereenGuard(roomPos3, Vector(-1, 0), true)
					lord:MoveToPositionAggressive(aggressionPoint + RandomVector(240))
					lord = Tanari:SpawnSlithereenGuard(roomPos3, Vector(-1, 0), true)
					lord:MoveToPositionAggressive(aggressionPoint + RandomVector(240))
				end)
				Timers:CreateTimer(7.6, function()
					local luck = RandomInt(1, 2)
					if luck == 1 then
						local lord = Tanari:SpawnWaterVaultLord2(roomPos3, Vector(-1, 0))
						Dungeons:AggroUnit(lord)
						lord = Tanari:SpawnWaterVaultLord(roomPos3, Vector(-1, 0))
						Dungeons:AggroUnit(lord)
					else
						local lord = Tanari:SpawnWaterVaultLord2(roomPos3, Vector(-1, 0))
						Dungeons:AggroUnit(lord)
						lord = Tanari:SpawnVaultMaster(roomPos3, Vector(-1, 0))
						Dungeons:AggroUnit(lord)
					end
				end)
			end)
		end)
	elseif Tanari.WaterTemple.waveDeaths >= 84 and Tanari.WaterTemple.doorPhase == 2 then
		Tanari.WaterTemple.doorPhase = 3
		Timers:CreateTimer(0.5, function()
			Tanari:LowerWaterTempleWall(-6, "WaterTempleWaveWall4", Vector(-7905, 7555, 140), "WaterTempleWaveBlocker4", Vector(-7885, 7552, 140), 900, true, false)
			Timers:CreateTimer(1.2, function()
				Tanari:SpawnWaterTempleWaveUnit("water_temple_armored_water_beetle", roomPos4, 14, 58, 0.6)
				Tanari:SpawnWaterTempleWaveUnit("water_temple_blinded_serpent_warrior", roomPos4, 18, 58, 0.6)
				Tanari:SpawnWaterTempleWaveUnit("water_temple_serpent_sleeper", roomPos4, 18, 58, 0.6)
				Timers:CreateTimer(3.8, function()
					local lord = Tanari:SpawnFacelessElemental(roomPos4, Vector(-1, 0))
					Dungeons:AggroUnit(lord)
					lord = Tanari:SpawnFacelessElemental(roomPos4, Vector(-1, 0))
					Dungeons:AggroUnit(lord)
				end)
				Timers:CreateTimer(7.6, function()
					local luck = RandomInt(1, 4)
					if luck == 1 then
						local lord = Tanari:SpawnWaterVaultLord2(roomPos4, Vector(-1, 0))
						Dungeons:AggroUnit(lord)
						lord = Tanari:SpawnWaterVaultLord2(roomPos4, Vector(-1, 0))
						Dungeons:AggroUnit(lord)
					elseif luck == 2 then
						local lord = Tanari:SpawnFacelessElemental(roomPos4, Vector(-1, 0))
						Dungeons:AggroUnit(lord)
						lord = Tanari:SpawnFacelessElemental(roomPos4, Vector(-1, 0))
						Dungeons:AggroUnit(lord)
					elseif luck == 3 then
						local lord = Tanari:SpawnBlueWarlock(roomPos4, Vector(-1, 0))
						Dungeons:AggroUnit(lord)
						lord = Tanari:SpawnBlueWarlock(roomPos4, Vector(-1, 0))
						Dungeons:AggroUnit(lord)
					else
						local lord = Tanari:SpawnWaterVaultLord2(roomPos4, Vector(-1, 0))
						Dungeons:AggroUnit(lord)
						lord = Tanari:SpawnVaultMaster(roomPos4, Vector(-1, 0))
						Dungeons:AggroUnit(lord)
					end
				end)
				Timers:CreateTimer(11.6, function()
					local luck = RandomInt(1, 4)
					if luck == 1 then
						local lord = Tanari:SpawnWaterVaultLord2(roomPos4, Vector(-1, 0))
						Dungeons:AggroUnit(lord)
						lord = Tanari:SpawnWaterVaultLord(roomPos4, Vector(-1, 0))
						Dungeons:AggroUnit(lord)
					elseif luck == 2 then
						local lord = Tanari:SpawnFacelessElemental(roomPos4, Vector(-1, 0))
						Dungeons:AggroUnit(lord)
						lord = Tanari:SpawnFacelessElemental(roomPos4, Vector(-1, 0))
						Dungeons:AggroUnit(lord)
					elseif luck == 3 then
						local lord = Tanari:SpawnBlueWarlock(roomPos4, Vector(-1, 0))
						Dungeons:AggroUnit(lord)
						lord = Tanari:SpawnBlueWarlock(roomPos4, Vector(-1, 0))
						Dungeons:AggroUnit(lord)
					else
						local lord = Tanari:SpawnVaultMaster(roomPos4, Vector(-1, 0))
						Dungeons:AggroUnit(lord)
						lord = Tanari:SpawnVaultMaster(roomPos4, Vector(-1, 0))
						Dungeons:AggroUnit(lord)
					end
				end)
			end)
		end)
	elseif Tanari.WaterTemple.waveDeaths >= 128 and Tanari.WaterTemple.doorPhase == 3 then
		Tanari.WaterTemple.doorPhase = 4
		Timers:CreateTimer(0.5, function()
			Tanari:LowerWaterTempleWall(-6, "WaterTempleWaveWall5", Vector(-7905, 6767, 200), "WaterTempleWaveBlocker5", Vector(-7885, 6848, 140), 900, true, false)
			Timers:CreateTimer(1.5, function()
				Tanari:SpawnBossStatue(Vector(-7478, 6784, 237), Vector(-1, 0), 180, "trident")
			end)
		end)
	end
end

function WaterTempleWhirlpool(trigger)
	Tanari:WhirlpoolUnit(trigger.activator)
end

function fairy_dragon_take_damage(event)
	local caster = event.caster
	local phaseShift = caster:FindAbilityByName("puck_phase_shift")
	if phaseShift:IsFullyCastable() then
		local newOrder = {
			UnitIndex = caster:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = phaseShift:entindex(),
		}

		ExecuteOrderFromTable(newOrder)
	end
end

function fairy_dragon_feedback_init(event)
	local target = event.target
	target.feedbackMana = target:GetMana()
end

function fairy_dragon_feedback_target_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local damagePerMana = event.damage_per_mana
	if target:HasModifier("item_rpc_shadowflame_fist") then
		return false
	end
	if target:GetMana() >= target.feedbackMana then
	else
		EmitSoundOn("Tanari.WaterTemple.FairyDragonFeedback", target)
		local manaDifferential = target.feedbackMana - target:GetMana()
		local damage = damagePerMana * manaDifferential
		ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})

		local particleName = "particles/econ/items/pugna/pugna_ward_ti5/feedback.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_POINT, target)
		ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
		Timers:CreateTimer(0.5, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	end
	target.feedbackMana = target:GetMana()

end

function WaterTempleBackroomTrigger(trigger)
	if not Tanari.WaterTemple then
		Tanari.WaterTemple = {}
	end
	local activator = trigger.activator
	Dungeons:CreateBasicCameraLockForHeroes(Vector(-6009, 8885, -15), 4.8, {activator})
	Tanari:ActivateSwitchGeneric(Vector(-9926, 10580, 300), "WaterTempleBackRoomSwitch", true)
	Timers:CreateTimer(0.8, function()
		Tanari:LowerWaterTempleWall(-6, "WaterTempleWall5", Vector(-6009, 8685, 85), "WaterTempleBlockers5", Vector(-5934, 8704, 219), 1000, true, false)
	end)
	Tanari.WaterTemple.GardenOpen = true
	Tanari.WaterTemple.GardenSpawn = false
end

function GardenSpawnTrigger()
	if Tanari.WaterTemple then
		if Tanari.WaterTemple.GardenOpen and not Tanari.WaterTemple.GardenSpawn then
			Tanari.WaterTemple.GardenSpawn = true
			Tanari:SpawnGardenArea()
		end
	end
end

function GardenSpawnTrigger2()
	if not Tanari.WaterTemple then
		return false
	end
	if not Tanari.WaterTemple.GardenArea2Spawn then
		Tanari.WaterTemple.GardenArea2Spawn = true
		Tanari:SpawnGardenArea2()
	end
end

function boss_statue_hit_final(event)
	local ability = event.ability
	local statue = event.target
	if statue.timesRotated <= 18 then
		for i = 1, 15, 1 do
			Timers:CreateTimer(i * 0.03, function()
				statue.startingAngle = statue.startingAngle + 1
				statue:SetAngles(0, statue.startingAngle, 0)
				statue:SetAbsOrigin(statue:GetAbsOrigin() - Vector(0, 0, 2))
				--print("STATUE POSITION:")
				--print(statue:GetAbsOrigin())
			end)
		end
	end
	if statue.timesRotated == 18 then
		ability:ApplyDataDrivenModifier(statue, statue, "modifier_water_boss_statue_no_more_attack", {})
		Tanari.WaterTemple.BossBattleBegun = true
		Timers:CreateTimer(0.5, function()
			local particleName = "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_bubbles_fxset.vpcf"
			local particle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, statue)
			ParticleManager:SetParticleControl(particle, 0, statue:GetAbsOrigin() * Vector(1, 1, 0) + Vector(0, 0, 460))
			Timers:CreateTimer(2.2, function()
				ParticleManager:DestroyParticle(particle, false)
			end)
		end)
		Timers:CreateTimer(0.1, function()
			EmitSoundOnLocationWithCaster(statue:GetAbsOrigin(), "Tanari.WallOpen", statue)
		end)
		for i = 1, 120, 1 do
			Timers:CreateTimer(i * 0.03, function()
				statue:SetAbsOrigin(statue:GetAbsOrigin() + Vector(0, 0, -7))
				ScreenShake(statue:GetAbsOrigin(), 160, 0.1, 0.1, 9000, 0, true)
			end)
		end
		Timers:CreateTimer(4.2, function()
			Tanari:BeginBossSpawnSequence()
			UTIL_Remove(statue)
		end)
	end

end

function water_temple_boss_ability_execute(event)
	local caster = event.caster
	local executedAbility = event.event_ability
	if executedAbility:GetAbilityName() == "water_temple_boss_world_crush" then
		ScreenShake(caster:GetAbsOrigin(), 360, 1.2, 1.2, 9000, 0, true)
		EmitSoundOn("Tanari.WaterTemple.BossCrush", caster)
		local particleName = "particles/units/heroes/hero_slardar/water_temple_boss_crush.vpcf"
		local particle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, statue)
		ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin() + Vector(0, 0, 220))
		ParticleManager:SetParticleControl(particle, 1, Vector(550, 550, 550))
		Timers:CreateTimer(2.2, function()
			ParticleManager:DestroyParticle(particle, false)
		end)
	end
end

function water_temple_boss_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 1
	end
	if caster.dying then
		return false
	end
	if caster:GetHealth() <= caster:GetMaxHealth() * 0.5 and not caster.guardsSpawn then
		caster.guardsSpawn = true
		water_temple_boss_mob_spawn(caster)
	end
	if caster:GetHealth() <= 1000 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_water_temple_boss_dying", {})
		caster.dying = true
	end
	if caster:IsChanneling() then
		return false
	end
	if caster:HasModifier("modifier_whirlpooling") then
		--print("WHIRLPOOL STAAAHP!")
		return false
	end
	if Tanari.FloodRobeBattle then
		if not caster.elementalsSummoned then
			caster.elementalsSummoned = 0
			caster:SetRenderColor(60, 60, 255)
			Tanari:ColorWearables(caster, Vector(60, 60, 255))
		end
		if caster.elementalsSummoned < 13 then
			if caster.interval % 4 == 0 then
				caster.elementalsSummoned = caster.elementalsSummoned + 1
				local elemental = CreateUnitByName("water_elemental_flood_2", caster:GetAbsOrigin() + RandomVector(380), false, nil, nil, caster:GetTeamNumber())
				elemental:AddAbility("water_flood_nuke"):SetLevel(1)
				Events:AdjustDeathXP(elemental)
				elemental:SetPhysicalArmorBaseValue(7000)
				local luck = RandomInt(1, 10)
				if luck == 1 then
					Paragon:AddParagonUnit(elemental)
				end
				elemental.summoner = caster
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_morphling/morphling_replicate.vpcf", elemental, 2)
				EmitSoundOn("Tanari.WaterBossSummon", elemental)

			end
		end
	end
	local sprintAbility = caster:FindAbilityByName("slardar_sprint")
	if sprintAbility:IsFullyCastable() then
		local newOrder = {
			UnitIndex = caster:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = sprintAbility:entindex(),
		}

		ExecuteOrderFromTable(newOrder)
		return
	end
	local crushAbility = caster:FindAbilityByName("water_temple_boss_world_crush")
	if crushAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = crushAbility:entindex(),
			}

			ExecuteOrderFromTable(newOrder)
			return
		end
	end
	local whirlpoolAbility = caster:FindAbilityByName("water_temple_boss_whirlpool")
	if whirlpoolAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = whirlpoolAbility:entindex(),
			}

			ExecuteOrderFromTable(newOrder)
			return
		end
	end
	if caster:GetHealth() < caster:GetMaxHealth() * 0.5 and not caster.summonTime then
		-- caster.summonTime = true
		-- local positionTable = {Vector(6720, 14144), Vector(6184, 13408), Vector(7475, 13408), Vector(8447, 13408), Vector(6602, 12293), Vector(8665, 12095), Vector(9384, 12095), Vector(9180, 10344), Vector(9759, 10278), Vector(8873, 9286), Vector(8001, 9878)}
		-- for i = 1, #positionTable, 1 do
		-- Tanari:SpawnWindGuardian(positionTable[i], Vector(0,-1))
		-- Tanari:SpawnWindGuardian(positionTable[i], Vector(0,-1))
		-- end
	end
	caster.interval = caster.interval + 1
	if caster.interval > 28 then
		caster.interval = 1
	end
end

function whirlpool_think(event)
	local caster = event.caster
	local ability = event.ability
	EndAnimation(caster)
	Timers:CreateTimer(0.03, function()
		StartAnimation(caster, {duration = 0.27, activity = ACT_DOTA_CAST_ABILITY_2, rate = 0.7})
	end)
	--print("WHIRLPOOL THINK!")
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		--print("ENEMIES!!")
		for i = 1, #enemies, 1 do
			ability:ApplyDataDrivenModifier(caster, enemies[i], "modifier_whirlpool_effect", {duration = 0.33})
		end
	end
end

function whirlpool_end(event)
	local caster = event.caster
	local crushAbility = caster:FindAbilityByName("water_temple_boss_world_crush")
	crushAbility:EndCooldown()
	if crushAbility:IsFullyCastable() then
		local newOrder = {
			UnitIndex = caster:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = crushAbility:entindex(),
		}

		ExecuteOrderFromTable(newOrder)
		return
	end
end

function whirlpool_init(event)
	local caster = event.caster
	local particleName = "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/water_temple_boss_whirlpool_fxset.vpcf"
	local particle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin() + Vector(0, 0, 100))
	Timers:CreateTimer(2.2, function()
		ParticleManager:DestroyParticle(particle, false)
	end)
end

function whirlpool_target_think(event)
	local caster = event.caster
	local target = event.target
	local movementVector = ((caster:GetAbsOrigin() - target:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	local distance = WallPhysics:GetDistance(caster:GetAbsOrigin(), target:GetAbsOrigin())
	local pullfactor = math.max((2000 - distance) / 120, 0)
	target:SetAbsOrigin(target:GetAbsOrigin() + movementVector * pullfactor)
end

function water_temple_boss_take_damage(event)
	local caster = event.caster
	local attacker = event.attacker
	local ability = event.ability
	local currentStacks = attacker:GetModifierStackCount("modifier_rising_tides_stacking_effect", caster)
	ability:ApplyDataDrivenModifier(caster, attacker, "modifier_rising_tides_stacking_effect", {duration = 5})
	attacker:SetModifierStackCount("modifier_rising_tides_stacking_effect", caster, currentStacks + 1)
	if currentStacks + 1 >= 12 then
		attacker:RemoveModifierByName("modifier_rising_tides_stacking_effect")
		WallPhysics:Jump(attacker, Vector(1, 1), 0, 32, 32, 0.9)
		attacker:AddNewModifier(caster, nil, "modifier_stunned", {duration = 2.0})
		particleName = "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash.vpcf"
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, attacker)
		ParticleManager:SetParticleControl(particle1, 0, attacker:GetAbsOrigin() * Vector(1, 1, 0) + Vector(0, 0, 80))
		EmitSoundOn("Tanari.WaterSplash", attacker)
		Timers:CreateTimer(4, function()
			ParticleManager:DestroyParticle(particle1, false)
		end)
		ApplyDamage({victim = attacker, attacker = caster, damage = event.torrent_damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
	end
end

function water_temple_boss_mob_spawn(boss)
	local spawnCount = 4
	if GameState:GetDifficultyFactor() == 2 then
		spawnCount = 7
	elseif GameState:GetDifficultyFactor() == 3 then
		spawnCount = 10
	end
	for i = 1, spawnCount, 1 do
		Timers:CreateTimer(4.5 * i, function()
			local basePostion = Vector(-5248, 9600)
			local randomX = RandomInt(0, 900)
			local randomY = RandomInt(0, 1600)
			local spawnPosition = basePostion + Vector(randomX, randomY)
			local naga = false
			if i % 5 == 0 then
				naga = Tanari:SpawnSlithereenRoyalGuard(spawnPosition, RandomVector(1), true)
			elseif i % 2 == 0 then
				naga = Tanari:SpawnSlithereenGuard(spawnPosition, RandomVector(1), true)
			else
				naga = Tanari:SpawnSlithereenFeatherguard(spawnPosition, RandomVector(1), true)
			end
			naga:SetAbsOrigin(naga:GetAbsOrigin() - Vector(0, 0, 240))
			StartAnimation(naga, {duration = 0.7, activity = ACT_DOTA_SPAWN, rate = 1.0})
			local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")

			gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, naga, "modifier_disable_player", {duration = 0.5})
			local particleName = "particles/units/heroes/hero_slark/slark_pounce_splash.vpcf"
			local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, naga)
			for k = 0, 4, 1 do
				ParticleManager:SetParticleControl(pfx, k, naga:GetAbsOrigin() + Vector(0, 0, 240))
			end
			Timers:CreateTimer(1, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
			for j = 1, 15, 1 do
				Timers:CreateTimer(j * 0.03, function()
					naga:SetAbsOrigin(naga:GetAbsOrigin() + Vector(0, 0, 16))
				end)
			end
			Timers:CreateTimer(0.3, function()
				if IsValidEntity(boss) then
					naga:MoveToPositionAggressive(boss:GetAbsOrigin())
				end
			end)
		end)
	end
end

function water_temple_boss_die_begin(event)
	Statistics.dispatch("tanari_jungle:kill:king_kraethas");
	local ability = event.ability
	local caster = event.caster
	if Tanari.FloodRobeBattle then
		Tanari:UpgradeFloodRobes(caster:GetAbsOrigin())
	end
	if not Tanari.WaterTemple then
		Tanari.WaterTemple = {}
	end

	Tanari.WaterTemple.BossBattleEnd = true
	Timers:CreateTimer(0.5, function()
		EmitSoundOn("Tanari.WaterTemple.BossDie1", caster)
	end)
	Timers:CreateTimer(1.5, function()
		EmitGlobalSound("Loot_Drop_Stinger_Arcana")
		Notifications:TopToAll({text = "Dungeon Clear!", duration = 8.0})
		local luck = RandomInt(1, 3)
		if luck == 3 then
			RPCItems:RollDepthCrestArmor(caster:GetAbsOrigin())
		end
	end)
	for i = 1, 14, 1 do
		Timers:CreateTimer(0.5 * i, function()
			RPCItems:RollItemtype(300, caster:GetAbsOrigin(), 1, 0)
		end)
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_water_temple_boss_dying_effect", {})
	local bossOrigin = caster:GetAbsOrigin()
	Timers:CreateTimer(8, function()
		Enemies:EnemySlain(caster, nil)
		Events:MainBossSlain(caster:GetUnitName())
		CustomGameEventManager:Send_ServerToAllClients("hide_boss_health", {bossId = tostring(caster)})
		caster:RemoveModifierByName("modifier_water_temple_boss_dying")
		Timers:CreateTimer(0.1, function()
			StartAnimation(caster, {duration = 8, activity = ACT_DOTA_DIE, rate = 0.25})
			EmitSoundOn("Tanari.WaterTemple.BossDie2", caster)
			for i = 1, 120, 1 do
				Timers:CreateTimer(i * 0.05, function()
					if IsValidEntity(caster) then
						caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, -5))
					end
				end)
			end
			Timers:CreateTimer(6, function()
				UTIL_Remove(caster)
				Tanari:DefeatDungeonBoss("water", bossOrigin)
			end)
		end)
	end)

end

function water_temple_boss_dying_think(event)
	local caster = event.caster
	if not caster.flailEffect then
		caster.flailEffect = true
		StartAnimation(caster, {duration = 5.5, activity = ACT_DOTA_FLAIL, rate = 1.0})
	end
	CustomAbilities:QuickAttachParticleWithPoint("particles/radiant_fx2/good_ancient001_dest_gobjglow.vpcf", caster, 4, "attach_hitloc")
	EmitSoundOn("Tanari.WindTemple.BossDying", caster)
end

function rare_wrath_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 1
	end
	local castAbility = caster:GetAbilityByIndex(DOTA_Q_SLOT)
	caster.interval = caster.interval + 1
	if caster.interval % 2 == 0 and caster.aggro then
		local start_radius = 400
		local end_radius = 400
		local range = 1000
		local speed = 550
		local fv = RandomVector(1)
		EmitSoundOn("morphling_mrph_anger_0"..RandomInt(1, 7), caster)
		Timers:CreateTimer(0.2, function()
			EmitSoundOn("Tanari.WaterTemple.RareWrathWater", caster)
		end)
		local projectileParticle = "particles/units/heroes/hero_tidehunter/tidehunter_gush_upgrade.vpcf"
		local info =
		{
			Ability = ability,
			EffectName = projectileParticle,
			vSpawnOrigin = caster:GetAbsOrigin(),
			fDistance = range,
			fStartRadius = start_radius,
			fEndRadius = end_radius,
			Source = caster,
			StartPosition = "attach_origin",
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
	if caster.interval % 6 == 0 and caster.aggro then
		if castAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_FARTHEST, false)
			if #enemies > 0 then
				local directionVector = ((enemies[1]:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
				local castPoint = enemies[1]:GetAbsOrigin() + directionVector * 300
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = castAbility:entindex(),
					Position = castPoint
				}

				ExecuteOrderFromTable(newOrder)
				return true
			end
		end
	end
	if caster.interval % 5 == 0 and caster.aggro then
		local blinkAbility = caster:FindAbilityByName("antimage_blink_custom")
		if blinkAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_FARTHEST, false)
			if #enemies > 0 then
				local directionVector = ((enemies[1]:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
				local castPoint = enemies[1]:GetAbsOrigin() + directionVector * 200
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = blinkAbility:entindex(),
					Position = castPoint
				}

				ExecuteOrderFromTable(newOrder)
				StartAnimation(caster, {duration = 1.5, activity = ACT_DOTA_CAST_ABILITY_6, rate = 0.6})
				return true
			end
		end
	end

	if caster.interval > 100 then
		caster.interval = 1
	end
end

function rare_wrath_die(event)
	local caster = event.caster
	EmitSoundOn("morphling_mrph_death_06", caster)
	RPCItems:RollAncientTanariWaterstone(caster:GetAbsOrigin())
end

function rare_construct_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 1
	end
	local castAbility = caster:GetAbilityByIndex(DOTA_Q_SLOT)
	caster.interval = caster.interval + 1
	if caster.interval % 2 == 0 and caster.aggro then
		local start_radius = 400
		local end_radius = 400
		local range = 1000
		local speed = 550
		local fv = RandomVector(1)
		EmitSoundOn("Tanari.RareWaterConstruct.Casting", caster)
		Timers:CreateTimer(0.2, function()
			EmitSoundOn("Tanari.WaterTemple.RareWrathWater", caster)
		end)
		local projectileParticle = "particles/units/heroes/hero_tidehunter/tidehunter_gush_upgrade.vpcf"
		local info =
		{
			Ability = ability,
			EffectName = projectileParticle,
			vSpawnOrigin = caster:GetAbsOrigin(),
			fDistance = range,
			fStartRadius = start_radius,
			fEndRadius = end_radius,
			Source = caster,
			StartPosition = "attach_origin",
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
	if caster.interval % 6 == 0 and caster.aggro then
		if castAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_FARTHEST, false)
			if #enemies > 0 then
				local directionVector = ((enemies[1]:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
				local castPoint = enemies[1]:GetAbsOrigin() + directionVector * 300
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = castAbility:entindex(),
					Position = castPoint
				}

				ExecuteOrderFromTable(newOrder)
				return true
			end
		end
	end
	if caster.interval % 5 == 0 and caster.aggro then
		local blinkAbility = caster:FindAbilityByName("antimage_blink_custom")
		if blinkAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_FARTHEST, false)
			if #enemies > 0 then
				local directionVector = ((enemies[1]:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
				local castPoint = enemies[1]:GetAbsOrigin() + directionVector * 200
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = blinkAbility:entindex(),
					Position = castPoint
				}

				ExecuteOrderFromTable(newOrder)
				StartAnimation(caster, {duration = 1.5, activity = ACT_DOTA_CAST_ABILITY_6, rate = 0.6})
				return true
			end
		end
	end

	if caster.interval > 100 then
		caster.interval = 1
	end
end

function rare_construct_die(event)
	local caster = event.caster
	EmitSoundOn("Tanari.RareWaterConstruct.Die", caster)
	RPCItems:RollWaterMageRobes(caster:GetAbsOrigin())
end

function flood_robe_upgrading_think(event)
	local target = event.target
	local position = target.upgradeRobePosition
	target.upgradeRobeZMove = target.upgradeRobeZMove + 0.1
	target:SetAbsOrigin(position + Vector(0, 0, 1000) + Vector(0, 0, math.cos(target.upgradeRobeZMove) * 30))
end

function water_spirit_die(event)
	local caster = event.caster
	Tanari:SpiritWaterTempleStart()
	EmitSoundOn("Tanari.WaterSpirit.Die", caster)
	local pfx = ParticleManager:CreateParticle("particles/radiant_fx/epoch_rune_c_b_ranged001_lvl3_disintegrate.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin() + Vector(0, 0, 60))
	ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin() + Vector(0, 0, 60))

	local pfx2 = ParticleManager:CreateParticle("particles/radiant_fx/good_barracks_melee002_lvl3_hit.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx2, 0, caster:GetAbsOrigin() + Vector(0, 0, 20))
	ParticleManager:SetParticleControl(pfx2, 1, caster:GetAbsOrigin() + Vector(0, 0, 20))
	-- Dungeons.respawnPoint = Vector(-9901, 16128)
	Timers:CreateTimer(8, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:DestroyParticle(pfx2, false)
	end)
	local luck = RandomInt(1, 4)
	if luck == 1 then
		RPCItems:RollAquaLily(caster:GetAbsOrigin())
	end
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Tanari.SpiritRealmEpic", caster)

	local walls = Entities:FindAllByNameWithin("WaterTempleSpiritWall", Vector(-10171, 15248, 45 + Tanari.ZFLOAT), 1200)
	if #walls > 0 then
		Timers:CreateTimer(0.1, function()
			for i = 1, #walls, 1 do
				EmitSoundOnLocationWithCaster(walls[i]:GetAbsOrigin(), "Tanari.WallOpen", Events.GameMaster)
			end
		end)
		for i = 1, 180, 1 do
			for j = 1, #walls, 1 do
				Timers:CreateTimer(i * 0.03, function()
					walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin() + Vector(0, 0, -5))
					if j == 1 then
						ScreenShake(walls[j]:GetAbsOrigin(), 160, 0.1, 0.1, 9000, 0, true)
					end
				end)
			end
		end
	end
	Timers:CreateTimer(3.5, function()
		local blockers = Entities:FindAllByNameWithin("WaterTempleSpiritBlocker", Vector(-10176, 15232, 60 + Tanari.ZFLOAT), 5400)
		for i = 1, #blockers, 1 do
			UTIL_Remove(blockers[i])
		end
	end)
end

function begin_hydro_pump(event)
	local caster = event.caster
	local ability = event.ability


	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_slardar/slardar_crush.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, Vector(200, 200, 200))
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)


	local hydroPosition = event.target_points[1]
	EmitSoundOn("Tanari.HydroMark.Start", caster)
	local loops = event.torrents
	local damage = event.damage

	local pfxX = ParticleManager:CreateParticle("particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_x_spot_fxset.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfxX, 0, hydroPosition + Vector(0, 0, 240))
	Timers:CreateTimer(3.0, function()
		ParticleManager:DestroyParticle(pfxX, false)
	end)
	Timers:CreateTimer(2, function()
		hydroPosition = GetGroundPosition(hydroPosition, caster)
		EmitSoundOnLocationWithCaster(hydroPosition, "Tanari.HydroPump.Pump", caster)
		local pfx = ParticleManager:CreateParticle("particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, hydroPosition)
		Timers:CreateTimer(2, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), hydroPosition, nil, 270, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				if enemy:GetAbsOrigin().z - GetGroundHeight(enemy:GetAbsOrigin(), enemy) < 500 then
					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_torrent_stun", {duration = 4})
					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_torrent_lifting", {duration = 2})
					enemy.torrentLiftVelocity = 16
				end
				ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
			end
		end
	end)
end

function torrent_stun_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	target:SetAbsOrigin(target:GetAbsOrigin() + Vector(0, 0, target.torrentLiftVelocity))
	target.torrentLiftVelocity = target.torrentLiftVelocity - 0.5
	if target.torrentLiftVelocity < 0 then
		target:RemoveModifierByName("modifier_torrent_lifting")
	end
	if not target:HasModifier("modifier_torrent_lifting") then
		if target:GetAbsOrigin().z - GetGroundHeight(target:GetAbsOrigin(), target) < 30 then
			target:RemoveModifierByName("modifier_torrent_stun")
		end
	end
end

function torrent_stun_end(event)
	local target = event.target
	local ability = event.ability
	Timers:CreateTimer(0.06, function()
		target.torrentLiftVelocity = nil
	end)

	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_slardar/slardar_crush.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, Vector(70, 70, 70))
	Timers:CreateTimer(3.0, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)

end

function WaterBombAcquireTrigger(trigger)
	local hero = trigger.activator
	if not hero:HasModifier("tanari_water_bomb_hero") then
		Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, hero, "tanari_water_bomb_hero", {duration = 15})
		water_bomb_start(hero)
	end
end

function water_bomb_start(hero)
	local visionTracer = CreateUnitByName("npc_flying_dummy_vision", hero:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
	visionTracer:SetAbsOrigin(hero:GetAbsOrigin() + Vector(0, 0, 1000))
	visionTracer:AddAbility("dummy_unit_vulnerable_cant_be_attacked"):SetLevel(1)
	visionTracer:SetModel("maps/reef_assets/models/props/chains/darkreef_chains_mine.vmdl")
	visionTracer:SetOriginalModel("maps/reef_assets/models/props/chains/darkreef_chains_mine.vmdl")
	visionTracer.hero = hero
	visionTracer.entering = true
	visionTracer.interval = 0
	visionTracer.tickSound = 80
	visionTracer.soundInterval = 0
	hero.waterBomb = visionTracer
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, visionTracer, "tanari_water_bomb_bomb", {duration = 15})
	EmitSoundOn("Tanari.WaterBomb.Start", hero)
end

function water_bomb_thinking(event)
	local target = event.target
	local hero = target.hero
	local bomb = target
	bomb.interval = bomb.interval + 1
	if bomb.thrown then
		bomb:SetAngles(0, (bomb.interval % 360), 0)
		local red = math.min(bomb.interval * 0.5, 255)
		bomb:SetRenderColor(255, 255 - red, 255 - red)
	else
		if bomb.entering then
			local newY = 1000 - math.sin(2 * math.pi / 16) * 360 * bomb.interval
			bomb:SetAbsOrigin(hero:GetAbsOrigin() + Vector(0, 0, newY))
			if newY <= 180 then
				bomb.entering = false
			end
		else
			bomb:SetAngles(0, (bomb.interval % 360), 0)
			local red = math.min(bomb.interval * 0.5, 255)
			bomb:SetRenderColor(255, 255 - red, 255 - red)
			bomb:SetAbsOrigin(hero:GetAbsOrigin() + Vector(0, 0, 180))
		end
	end
	bomb.soundInterval = bomb.soundInterval + 1
	if bomb.soundInterval >= bomb.tickSound then
		bomb.soundInterval = 0
		bomb.tickSound = math.max(bomb.tickSound - 10, 10)
		EmitSoundOn("Tanari.Bomb.Tick", bomb)
	end
end

function water_bomb_end(event)
	local target = event.target
	local bomb = target.waterBomb
	target.waterBomb = nil
	water_bomb_explode(bomb)
end

function water_bomb_explode(bomb)
	local position = bomb:GetAbsOrigin()
	flareParticle(position)
	local radius = 400
	local enemies = FindUnitsInRadius(bomb:GetTeamNumber(), bomb:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY + DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
	--print(#enemies)
	for _, enemy in pairs(enemies) do
		local damage = enemy:GetMaxHealth() * 0.1
		if enemy:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			damage = enemy:GetMaxHealth() * 0.5
		end
		Filters:ApplyStun(bomb, 1.5, enemy)
		ApplyDamage({victim = enemy, attacker = bomb, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
		--print(enemy:GetEntityIndex())
		if enemy:HasModifier("modifier_frozen_stone") then
			enemy:RemoveModifierByName("modifier_frozen_stone")
			EmitSoundOn("Tanari.WindKeyHolderStoneForm", enemy)
			CustomAbilities:QuickAttachParticle("particles/radiant_fx/good_barracks_ranged002_destroy.vpcf", enemy, 4)
			Dungeons:AggroUnit(enemy)
		end
	end
	local enemies2 = FindUnitsInRadius(bomb:GetTeamNumber(), bomb:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY + DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies2) do
		if enemy:HasModifier("modifier_frozen_stone") then
			enemy:RemoveModifierByName("modifier_frozen_stone")
			EmitSoundOn("Tanari.WindKeyHolderStoneForm", enemy)
			CustomAbilities:QuickAttachParticle("particles/radiant_fx/good_barracks_ranged002_destroy.vpcf", enemy, 4)
			Dungeons:AggroUnit(enemy)
			if enemy:GetUnitName() == "water_temple_duke_korlazeen" then
				EmitSoundOn("Tanari.BigSlardar.FreeFromRock", enemy)
			end
		end
	end
	EmitSoundOn("Tanari.Bombadier.BombExplose", bomb)
	local rocks = Entities:FindAllByNameWithin("WaterSpiritCage", bomb:GetAbsOrigin(), 540)
	if #rocks > 0 then
		-- EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Redfall.RockCrash", Redfall.RedfallMaster)
		for i = 1, #rocks, 1 do
			if not Tanari.WaterTemple.CagesUp then
				Tanari.WaterTemple.CagesUp = 25
			end
			local position = rocks[i]:GetAbsOrigin()
			local pfx = ParticleManager:CreateParticle("particles/dire_fx/bad_barracks001_melee_destroy.vpcf", PATTACH_CUSTOMORIGIN, Tanari.TanariMaster)
			ParticleManager:SetParticleControl(pfx, 0, position)
			Timers:CreateTimer(4, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
			local rockBlocker = Entities:FindByNameNearest("CrateBlocker", rocks[i]:GetAbsOrigin(), 600)

			if rockBlocker then
				UTIL_Remove(rockBlocker)
			end
			local position2 = rocks[i]:GetAbsOrigin()
			if Tanari.WaterTemple.CagesUp > 0 then
				local luck = RandomInt(1, Tanari.WaterTemple.CagesUp)
				if luck == 1 then
					Tanari.WaterTemple.CagesUp = 0
					local visionTracer = CreateUnitByName("npc_flying_dummy_vision", position2, true, nil, nil, DOTA_TEAM_GOODGUYS)
					visionTracer:AddAbility("dummy_unit_vulnerable_cant_be_attacked"):SetLevel(1)
					visionTracer:SetModel("models/items/monkey_king/monkey_king_immortal_weapon/immortal_weapon_tip_fx.vmdl")
					visionTracer:SetOriginalModel("models/items/monkey_king/monkey_king_immortal_weapon/immortal_weapon_tip_fx.vmdl")
					visionTracer:SetAbsOrigin(position2 - Vector(0, 0, 300))
					visionTracer:SetModelScale(1.6)
					local keyTargetPos = position2
					local key = visionTracer
					Timers:CreateTimer(2, function()
						ScreenShake(keyTargetPos, 130, 0.9, 0.9, 9000, 0, true)
						UTIL_Remove(rocks[i])
						for i = 1, 70, 1 do
							Timers:CreateTimer(i * 0.03, function()
								if i % 10 == 0 then
									ScreenShake(keyTargetPos, 130, 0.9, 0.9, 9000, 0, true)
								end
								if i == 20 then
									EmitSoundOnLocationWithCaster(key:GetAbsOrigin(), "Tanari.WaterSplash", Tanari.TanariMaster)
									local particleName = "particles/roshpit/redfall/cliff_splash.vpcf"
									local position = key:GetAbsOrigin()
									local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
									ParticleManager:SetParticleControl(pfx, 0, position)
									Timers:CreateTimer(2, function()
										ParticleManager:DestroyParticle(pfx, false)
									end)
								end
								key:SetAbsOrigin(key:GetAbsOrigin() + Vector(0, 0, 7))
							end)
						end
						Timers:CreateTimer(2.1, function()
							for i = 1, 80, 1 do
								Timers:CreateTimer(i * 0.03, function()
									key:SetAbsOrigin(key:GetAbsOrigin() + Vector(0, 0, math.cos((2 * math.pi * i) / 80)) * 5)
								end)
							end
						end)
						Timers:CreateTimer(4.6, function()
							local particleName = "particles/units/heroes/hero_silencer/silencer_global_silence.vpcf"
							local position = key:GetAbsOrigin()
							local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
							ParticleManager:SetParticleControl(pfx, 0, position)
							ParticleManager:SetParticleControl(pfx, 1, position)
							Timers:CreateTimer(3, function()
								ParticleManager:DestroyParticle(pfx, false)
							end)
							EmitSoundOnLocationWithCaster(key:GetAbsOrigin(), "Tanari.Farmlands.ChestDisappear", Tanari.TanariMaster)
							local wallPosition = Vector(-13248, 15258, 600)
							Tanari:CreateCollectionBeam(key:GetAbsOrigin() + Vector(0, 0, 100), wallPosition + Vector(0, 0, 140))
							--COLLECTION BEAM
							Timers:CreateTimer(0.5, function()
								Tanari:SpawnWaterSpiritRoom2()
								UTIL_Remove(key)
								local walls = Entities:FindAllByNameWithin("WaterTempleSpiritWall", wallPosition, 1200)
								if #walls > 0 then
									Timers:CreateTimer(0.1, function()
										for i = 1, #walls, 1 do
											EmitSoundOnLocationWithCaster(walls[i]:GetAbsOrigin(), "Tanari.WallOpen", Events.GameMaster)
										end
									end)
									for i = 1, 180, 1 do
										for j = 1, #walls, 1 do
											Timers:CreateTimer(i * 0.03, function()
												walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin() + Vector(0, 0, -5))
												if j == 1 then
													ScreenShake(walls[j]:GetAbsOrigin(), 160, 0.1, 0.1, 9000, 0, true)
												end
											end)
										end
									end
								end
								Timers:CreateTimer(3.5, function()
									local blockers = Entities:FindAllByNameWithin("WaterSpiritBlocker", wallPosition, 5400)
									for i = 1, #blockers, 1 do
										UTIL_Remove(blockers[i])
									end
								end)
							end)
						end)
					end)
				else
					local spawns = RandomInt(3, 5)
					for i = 1, spawns, 1 do
						local fv = WallPhysics:rotateVector(Vector(1, 1), 2 * i * math.pi / spawns)
						local wraith = Tanari:SpawnWaterWraith(position2, fv, true)
						WallPhysics:Jump(wraith, fv, 10, 18, 18, 1.0)
					end
					Tanari.WaterTemple.CagesUp = Tanari.WaterTemple.CagesUp - 1
					UTIL_Remove(rocks[i])
				end
			else
				local spawns = RandomInt(3, 5)
				for i = 1, spawns, 1 do
					local fv = WallPhysics:rotateVector(Vector(1, 1), 2 * i * math.pi / spawns)
					local wraith = Tanari:SpawnWaterWraith(position2, fv, true)
					WallPhysics:Jump(wraith, fv, 10, 18, 18, 1.0)
				end
				Tanari.WaterTemple.CagesUp = Tanari.WaterTemple.CagesUp - 1
				UTIL_Remove(rocks[i])
			end
		end
	end
	UTIL_Remove(bomb)
end

function flareParticle(position)
	local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
	local particle2 = ParticleManager:CreateParticle(particleNameS, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particle2, 0, position)
	ParticleManager:SetParticleControl(particle2, 1, Vector(490, 490, 490))
	ParticleManager:SetParticleControl(particle2, 2, Vector(2.0, 2.0, 2.0))
	ParticleManager:SetParticleControl(particle2, 4, Vector(255, 20, 0))
	Timers:CreateTimer(1.5, function()
		ParticleManager:DestroyParticle(particle2, false)
	end)

	local particleName = "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(particle1, 0, position)
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
end

function WaterSpiritTrigger(trigger)
	Tanari:ActivateSwitchGenericWithZ(Vector(-13498, 15873, 300), "WaterSwitch", true, 0.44)

	local statue = Entities:FindByNameNearest("SpiritBeamStatue", Vector(-13920, 15883, -500), 1000)
	for i = 1, 180, 1 do
		Timers:CreateTimer(i * 0.03, function()
			statue:SetAbsOrigin(statue:GetAbsOrigin() + Vector(0, 0, 850 / 180))
			if i % 30 == 0 then
				ScreenShake(statue:GetAbsOrigin(), 160, 0.1, 0.1, 9000, 0, true)
				local particleName = "particles/roshpit/redfall/cliff_splash.vpcf"
				local position = GetGroundPosition(statue:GetAbsOrigin(), Events.GameMaster) + Vector(0, 0, 10)
				local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
				EmitSoundOnLocationWithCaster(statue:GetAbsOrigin(), "Tanari.Shake", Events.GameMaster)
				ParticleManager:SetParticleControl(pfx, 0, position)
				Timers:CreateTimer(2, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)
			end
		end)
	end
	Timers:CreateTimer(6, function()
		EmitSoundOnLocationWithCaster(statue:GetAbsOrigin(), "WaterTemple.SpiritStatue", Events.GameMaster)
		local visionTracer = CreateUnitByName("npc_flying_dummy_vision", statue:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
		visionTracer:FindAbilityByName("dummy_unit"):SetLevel(1)
		local statueOrigin = statue:GetAbsOrigin() + Vector(0, 0, 560)
		visionTracer:SetAbsOrigin(statueOrigin)
		local particleName = "particles/units/heroes/hero_wisp/wisp_tether.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, Events.GameMaster)
		ParticleManager:SetParticleControl(pfx, 0, statueOrigin)
		ParticleManager:SetParticleControlEnt(pfx, 1, visionTracer, PATTACH_POINT_FOLLOW, "attach_hitloc", visionTracer:GetAbsOrigin() + Vector(0, 0, 90), true)
		local movementVector = (Vector(-15872, 13016, 820) - statueOrigin) / 60
		for i = 1, 60, 1 do
			Timers:CreateTimer(i * 0.05, function()
				visionTracer:SetAbsOrigin(statueOrigin + movementVector * i)
			end)
		end
	end)
	local beacon = Entities:FindByNameNearest("SpiritJailBeacon", Vector(-15875, 13056, 350), 1000)
	Timers:CreateTimer(8.8, function()
		for i = 1, 83, 1 do
			Timers:CreateTimer(i * 0.03, function()
				beacon:SetRenderColor(i * 1.5, i * 1.5, i * 3)
			end)
		end
	end)
	Timers:CreateTimer(11.6, function()
		EmitSoundOnLocationWithCaster(beacon:GetAbsOrigin(), "WaterTemple.SpiritBeacon", Events.GameMaster)
		AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-15296, 13056), 1000, 15, false)
		local slark = Tanari:SpawnWaterMetaSlark(Vector(-15296, 13056), Vector(1, 0))
		EmitSoundOn("Tanari.WaterTemple.FairyDragonFeedback", slark)
		Events:CreateLightningBeam(beacon:GetAbsOrigin() + Vector(0, 0, 700), slark:GetAbsOrigin() + Vector(0, 0, 40))
		Timers:CreateTimer(0.5, function()
			local spawns = GameState:GetDifficultyFactor() + 2
			for j = 1, spawns, 1 do
				Timers:CreateTimer(j * 0.8, function()
					StartAnimation(slark, {duration = 0.7, activity = ACT_DOTA_ATTACK, rate = 1.4})
					local spawnPosition = slark:GetAbsOrigin() + slark:GetForwardVector() * RandomInt(400, 640) + RandomVector(1) * RandomInt(1, 300)
					local jailer = Tanari:SpawnSlardarJailer(spawnPosition, slark:GetForwardVector())
					EmitSoundOn("Tanari.WaterTemple.FairyDragonFeedback", jailer)
					Events:CreateLightningBeam(slark:GetAbsOrigin() + Vector(0, 0, 120), jailer:GetAbsOrigin() + Vector(0, 0, 70))
				end)
			end
		end)
	end)
end

function prison_channel_think(event)
	local caster = event.caster
	local pfx2 = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/water/monkey_king_spring_arcana_water.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx2, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx2, 1, Vector(950, 4, 4))
	Timers:CreateTimer(1.5, function()
		ParticleManager:DestroyParticle(pfx2, false)
	end)
end

function in_water_torrent_area(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	EmitSoundOn("WaterTemple.Gush", caster)
	local info =
	{
		Target = target,
		Source = caster,
		Ability = ability,
		EffectName = "particles/units/heroes/hero_tidehunter/tidehunter_gush.vpcf",
		StartPosition = "attach_attack1",
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 5,
		bProvidesVision = false,
		iVisionRadius = 0,
		iMoveSpeed = 1500,
	iVisionTeamNumber = caster:GetTeamNumber()}
	projectile = ProjectileManager:CreateTrackingProjectile(info)
end

function meta_slark_attack_land(event)
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	ability:ApplyDataDrivenModifier(attacker, target, "modifier_meta_slark_debuff", {duration = 7})
	local stackCount = target:GetModifierStackCount("modifier_meta_slark_debuff", attacker)
	local newStacks = stackCount + 1
	target:SetModifierStackCount("modifier_meta_slark_debuff", attacker, newStacks)
	CustomAbilities:QuickAttachParticle("particles/econ/items/slark/slark_ti6_blade/slark_ti6_blade_essence_shift.vpcf", target, 2)
end

function meta_slark_death(event)
	local switch = Entities:FindByNameNearest("WaterSwitch2", Vector(-15154, 13245, 200), 1000)
	switch:SetAbsOrigin(switch:GetAbsOrigin() + Vector(0, 0, 1000))
	for i = 1, 14, 1 do
		Timers:CreateTimer(i * 0.03, function()
			switch:SetAbsOrigin(switch:GetAbsOrigin() - Vector(0, 0, 964 / 14))
		end)
	end
	Timers:CreateTimer(0.4, function()
		Tanari.WaterTemple.MetaSlarkDead = 0
		local particleName = "particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf"
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
		ParticleManager:SetParticleControl(particle1, 0, switch:GetAbsOrigin())
		Timers:CreateTimer(2, function()
			ParticleManager:DestroyParticle(particle1, false)
		end)
		EmitSoundOnLocationWithCaster(switch:GetAbsOrigin(), "Tanari.SwitchImpact", Events.GameMaster)
	end)
end

function WaterSpiritTrigger2(trigger)
	local hero = trigger.activator
	if Tanari.WaterTemple.MetaSlarkDead then
		if Tanari.WaterTemple.MetaSlarkDead == 0 then
			Tanari:SpiritWaterSection2()
			Tanari.WaterTemple.MetaSlarkDead = 1
			Tanari:ActivateSwitchGenericWithZ(Vector(-15154, 13244, 100), "WaterSwitch2", true, 0.35)
			Timers:CreateTimer(0.5, function()
				Tanari:LowerWaterTempleWall(-6, "WaterTempleSpiritWall", Vector(-10180, 9944, 0), "WaterSpiritBlocker", Vector(-10176, 9856, 119), 1000, true, false)
				Dungeons:CreateBasicCameraLockForHeroes(Vector(-10180, 9944, 0), 3, {hero})
			end)
		end
	end
end

function soul_arrow_hit(event)
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	local damage = (target:GetMaxHealth() - target:GetHealth()) * event.damage_creep
	if target:IsHero() then
		damage = (target:GetMaxHealth() - target:GetHealth()) * event.damage_hero
	end
	EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Tanari.SpiritStrike.Hit", target)
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_weaver/weaver_shukuchi_damage.vpcf", target, 3)
	ApplyDamage({victim = target, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
end

function WaterSpiritTrigger3(trigger)
	Tanari:ActivateSwitchGenericWithZ(Vector(-11779, 12753, 100), "WaterSwitch", true, 0.35)
	local water = Entities:FindByNameNearest("WaterTempleFlow", Vector(-12849, 12054, -700), 1000)
	water:SetAbsOrigin(water:GetAbsOrigin() + Vector(0, 0, 700))
	local water2 = Entities:FindByNameNearest("WaterTempleFlow", Vector(-12849, 13670, -700), 1000)
	water2:SetAbsOrigin(water2:GetAbsOrigin() + Vector(0, 0, 700))
	local water3 = Entities:FindByNameNearest("WaterTempleFlow", Vector(-10545, 12814, -700), 1000)
	water3:SetAbsOrigin(water3:GetAbsOrigin() + Vector(0, 0, 700))
	Timers:CreateTimer(10.5, function()
		Tanari:LowerWaterTempleWall(-6, "WaterTempleSpiritWall", Vector(-13270, 11354, 100), "WaterSpiritBlocker3", Vector(-13248, 11392, 119), 1200, true, false)
	end)
	local hero = trigger.activator
	EmitSoundOnLocationWithCaster(hero:GetAbsOrigin(), "Tanari.WaterTemple.Flow", hero)
	local waterRaise = Entities:FindAllByNameWithin("WaterTempleWaterRaise", Vector(-11666, 12416, -30), 1500)
	for j = 1, 300, 1 do
		Timers:CreateTimer(j * 0.03, function()
			for i = 1, #waterRaise, 1 do
				waterRaise[i]:SetAbsOrigin(waterRaise[i]:GetAbsOrigin() + Vector(0, 0, 0.4))
			end
		end)
	end
	Timers:CreateTimer(3, function()
		Tanari:SpawnWaterManifestation(Vector(-11328, 12736), Vector(-1, 0))
		Tanari:SpawnWaterManifestation(Vector(-10688, 12736), Vector(-1, 0))
		Tanari:SpawnWaterManifestation(Vector(-10688, 13248), Vector(0, -1))
		Tanari:SpawnWaterManifestation(Vector(-12900, 12736), Vector(0, -1))

		Tanari:SpawnWaterManifestation(Vector(-12854, 11392), Vector(0, 1))

		Tanari:SpawnWaterManifestation(Vector(-12096, 11392), Vector(-1, 0))
		Tanari:SpawnWaterManifestation(Vector(-11520, 11392), Vector(-1, 0))
	end)
	Timers:CreateTimer(4, function()
		Tanari:SpawnRadialWaterStatueBombRoom()
	end)
end

function WaterSpiritTrigger4(trigger)
	Tanari:ActivateSwitchGenericWithZ(Vector(-12765, 8147, 300), "WaterSwitch", true, 0.35)
	Timers:CreateTimer(0.5, function()
		local platform = Entities:FindByNameNearest("BombPlatform", Vector(-12779, 8832), 700)
		platform:SetAbsOrigin(platform:GetAbsOrigin() + Vector(0, 0, 1050))
		for i = 1, 21, 1 do
			Timers:CreateTimer(i * 0.03, function()
				platform:SetAbsOrigin(platform:GetAbsOrigin() - Vector(0, 0, 1000 / 21))
			end)
		end
		Timers:CreateTimer(0.7, function()
			local particleName = "particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf"
			local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
			ParticleManager:SetParticleControl(particle1, 0, platform:GetAbsOrigin())
			Timers:CreateTimer(2, function()
				ParticleManager:DestroyParticle(particle1, false)
			end)
			EmitSoundOnLocationWithCaster(platform:GetAbsOrigin(), "Tanari.SwitchImpact", Events.GameMaster)
			Tanari.WaterTemple.BombPlatformActive = true

			local particle = ParticleManager:CreateParticle("particles/econ/items/tinker/boots_of_travel/teleport_start_bots_ring.vpcf", PATTACH_WORLDORIGIN, Events.GameMaster)
			ParticleManager:SetParticleControl(particle, 0, platform:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle, 1, platform:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle, 2, platform:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle, 3, platform:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle, 4, platform:GetAbsOrigin())
		end)
	end)
end

function WaterBombAcquireTrigger2(trigger)
	if Tanari.WaterTemple.BombPlatformActive then
		local hero = trigger.activator
		if not hero:HasModifier("tanari_water_bomb_hero") then
			Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, hero, "tanari_water_bomb_hero", {duration = 15})
			water_bomb_start(hero)
		end
	end
end

function korlazeen_die(event)
	Tanari:SpawnWaterTempleWaveRoom()
	Tanari:LowerWaterTempleWall(-6, "WaterTempleSpiritWall", Vector(-15182, 7582, 0), "WaterSpiritBlocker", Vector(-15182, 7582, 0), 1000, true, false)
end

function big_water_archer_die(event)
	Tanari.WaterTemple.SpiritWaveUnitsSlain = 0
	Tanari.waterSpawnPortalTable = {}
	local spawnPositionTable = {Vector(-14208, 7360), Vector(-14920, 6784), Vector(-14208, 6144), Vector(-13539, 6784)}
	Timers:CreateTimer(2, function()
		for i = 1, #spawnPositionTable, 1 do
			local pfx = ParticleManager:CreateParticle("particles/econ/events/ti4/teleport_end_counter_ti4.vpcf", PATTACH_WORLDORIGIN, Tanari.TanariMaster)
			ParticleManager:SetParticleControl(pfx, 0, spawnPositionTable[i] + Vector(0, 0, 630 + Tanari.ZFLOAT))
			ParticleManager:SetParticleControl(pfx, 1, spawnPositionTable[i] + Vector(0, 0, 630 + Tanari.ZFLOAT))

			table.insert(Tanari.waterSpawnPortalTable, pfx)
			EmitSoundOnLocationWithCaster(spawnPositionTable[i], "WaterTemple.SpiritBeacon", Tanari.TanariMaster)
		end
	end)
	Timers:CreateTimer(7, function()
		for i = 1, #spawnPositionTable, 1 do
			local delay = 1
			if GameState:GetDifficultyFactor() == 2 then
				delay = 0.8
			elseif GameState:GetDifficultyFactor() == 3 then
				delay = 0.6
			end
			Tanari:SpawnSpiritWaterWaveUnit("boulderspine_slithereen_featherguard", spawnPositionTable[i], 5, 33, delay, true)
		end
	end)
end

function water_temple_unit_die(event)
	local unit = event.unit
	if unit.code then
		if unit.code == 0 then
			local delay = 0.8
			Tanari.WaterTemple.SpiritWaveUnitsSlain = Tanari.WaterTemple.SpiritWaveUnitsSlain + 1
			if Tanari.WaterTemple.SpiritWaveUnitsSlain == 18 then
				local spawnPositionTable = {Vector(-14208, 7360), Vector(-14920, 6784), Vector(-14208, 6144), Vector(-13539, 6784)}
				for i = 1, #spawnPositionTable, 1 do
					if i < 3 then
						Tanari:SpawnSpiritWaterWaveUnit("boulderspine_slithereen_guard", spawnPositionTable[i], 5, 33, delay, true)
					else
						Tanari:SpawnSpiritWaterWaveUnit("boulderspine_slithereen_featherguard", spawnPositionTable[i], 5, 33, delay, true)

					end
				end
			elseif Tanari.WaterTemple.SpiritWaveUnitsSlain == 36 then
				Tanari:SpawnSpiritWaterWaveUnit("water_temple_vault_lord_two", Vector(-14208, 7360), 6, 33, delay, true)
				Tanari:SpawnSpiritWaterWaveUnit("water_temple_vault_lord_two", Vector(-14920, 6784), 6, 33, delay, true)
				Tanari:SpawnSpiritWaterWaveUnit("water_temple_fairy_dragon", Vector(-14208, 6144), 6, 33, delay, true)
				Tanari:SpawnSpiritWaterWaveUnit("water_temple_fairy_dragon", Vector(-13539, 6784), 6, 33, delay, true)
			elseif Tanari.WaterTemple.SpiritWaveUnitsSlain == 60 then
				Tanari:SpawnSpiritWaterWaveUnit("water_temple_faceless_water_elemental", Vector(-14208, 7360), 6, 33, delay, true)
				Tanari:SpawnSpiritWaterWaveUnit("water_temple_faceless_water_elemental", Vector(-14920, 6784), 6, 33, delay, true)
				Tanari:SpawnSpiritWaterWaveUnit("water_temple_faceless_water_elemental", Vector(-14208, 6144), 6, 33, delay, true)
				Tanari:SpawnSpiritWaterWaveUnit("water_temple_faceless_water_elemental", Vector(-13539, 6784), 6, 33, delay, true)
			elseif Tanari.WaterTemple.SpiritWaveUnitsSlain == 82 then
				Tanari:SpawnSpiritWaterWaveUnit("water_temple_prison_guard", Vector(-14208, 7360), 8, 33, delay, true)
				Tanari:SpawnSpiritWaterWaveUnit("water_temple_prison_guard", Vector(-14920, 6784), 8, 33, delay, true)
				Tanari:SpawnSpiritWaterWaveUnit("water_temple_prison_guard", Vector(-14208, 6144), 8, 33, delay, true)
				Tanari:SpawnSpiritWaterWaveUnit("water_temple_prison_guard", Vector(-13539, 6784), 8, 33, delay, true)
			elseif Tanari.WaterTemple.SpiritWaveUnitsSlain == 114 then
				Tanari:SpawnSpiritWaterWaveUnit("water_temple_prison_guard", Vector(-14208, 7360), 8, 33, delay, true)
				Tanari:SpawnSpiritWaterWaveUnit("water_temple_faceless_water_elemental", Vector(-14920, 6784), 6, 33, delay, true)
				Tanari:SpawnSpiritWaterWaveUnit("water_temple_fairy_dragon", Vector(-14208, 6144), 6, 33, delay, true)
				Tanari:SpawnSpiritWaterWaveUnit("water_temple_vault_lord_two", Vector(-13539, 6784), 6, 33, delay, true)
			elseif Tanari.WaterTemple.SpiritWaveUnitsSlain == 140 then
				for i = 1, #Tanari.waterSpawnPortalTable, 1 do
					ParticleManager:DestroyParticle(Tanari.waterSpawnPortalTable[i], false)
					ParticleManager:ReleaseParticleIndex(Tanari.waterSpawnPortalTable[i])
				end
				EmitSoundOnLocationWithCaster(Vector(-14208, 6784), "WaterTemple.SpiritStatue", Events.GameMaster)
				Tanari:LowerWaterTempleWall(-6, "WaterTempleSpiritWall", Vector(-15182, 5952, 0), "WaterSpiritBlocker", Vector(-15182, 5952, 0), 1000, true, false)
				Tanari:BigDoorBeachRoom()
			end
		end
	end
end

function WaterTempleBigDoorTrigger(trigger)
	--print("HIT TRIGGER")
	if Tanari.WaterTemple.SwitchesActive then
		Tanari:ActivateSwitchGeneric(Vector(-15512, 3860, 280), "WaterSwitch", true)
		Tanari:ActivateSwitchGeneric(Vector(-11950, 4800, 380), "WaterSwitch", true)
		MoveBigWaterDoor()
		Tanari.WaterTemple.SwitchesActive = false
	end
end

function WaterTempleBigDoorTrigger2(trigger)
	if Tanari.WaterTemple.SwitchesActive then
		Tanari:ActivateSwitchGeneric(Vector(-15512, 3860, 280), "WaterSwitch", true)
		Tanari:ActivateSwitchGeneric(Vector(-11950, 4800, 380), "WaterSwitch", true)
		MoveBigWaterDoor()
		Tanari.WaterTemple.SwitchesActive = false
	end
end

function MoveBigWaterDoor()
	local totalDistance = 1200
	local blockerMovement = Vector(64, 0, 0)
	if Tanari.WaterTemple.BigDoorSide == "right" then
		totalDistance = -1200
		Tanari.WaterTemple.BigDoorSide = "left"
		blockerMovement = Vector(-64, 0, 0)
	else
		Tanari.WaterTemple.BigDoorSide = "right"
	end
	Tanari.WaterTemple.NewBlockerTable = {}
	for i = 1, 200, 1 do
		Timers:CreateTimer(i * 0.05, function()
			if i % 10 == 0 then
				local positionTable = {Tanari.WaterTemple.BigWaterDoor:GetAbsOrigin(), Tanari.WaterTemple.BigWaterDoor:GetAbsOrigin() + Vector(400, 0), Tanari.WaterTemple.BigWaterDoor:GetAbsOrigin() - Vector(400, 0)}
				ScreenShake(Tanari.WaterTemple.BigWaterDoor:GetAbsOrigin(), 260, 0.2, 0.2, 9000, 0, true)
				for j = 1, #positionTable, 1 do
					local pfx = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
					ParticleManager:SetParticleControl(pfx, 0, positionTable[j] + Vector(0, 0, 810))
					ParticleManager:SetParticleControl(pfx, 1, Vector(200, 200, 200))
					Timers:CreateTimer(2, function()
						ParticleManager:DestroyParticle(pfx, false)
						ParticleManager:ReleaseParticleIndex(pfx)
					end)
				end
			end
			if i % 15 == 0 then
				EmitSoundOnLocationWithCaster(Tanari.WaterTemple.BigWaterDoor:GetAbsOrigin(), "Tanari.Shake", Events.GameMaster)
			end
			Tanari.WaterTemple.BigWaterDoor:SetAbsOrigin(Tanari.WaterTemple.BigWaterDoor:GetAbsOrigin() + Vector(totalDistance / 200, 0))
			if i % 20 == 0 and i < 200 then
				local tableIndex = math.floor(i / 20)
				if Tanari.WaterTemple.BigDoorSide == "left" then
					tableIndex = 10 - tableIndex
				end
				local blocker = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Tanari.WaterTemple.BigDoorBlockers[tableIndex]:GetAbsOrigin() + Vector(totalDistance, 0, 0), Name = "wallObstruction"})
				table.insert(Tanari.WaterTemple.NewBlockerTable, blocker)
				UTIL_Remove(Tanari.WaterTemple.BigDoorBlockers[tableIndex])
				-- for j = 1, #Tanari.WaterTemple.BigDoorBlockers, 1 do
				-- Tanari.WaterTemple.BigDoorBlockers[j]:SetAbsOrigin(Tanari.WaterTemple.BigDoorBlockers[j]:GetAbsOrigin()+blockerMovement)
				-- end
			end
		end)
	end
	Timers:CreateTimer(10.05, function()
		Tanari.WaterTemple.BigDoorBlockers = Tanari.WaterTemple.NewBlockerTable
		Tanari:ActivateSwitchGeneric(Vector(-15512, 3860, 280), "WaterSwitch", false)
		Tanari:ActivateSwitchGeneric(Vector(-11950, 4800, 380), "WaterSwitch", false)
		Timers:CreateTimer(1, function()
			Tanari.WaterTemple.SwitchesActive = true
		end)
	end)
end

function defector_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster:GetHealth() < caster:GetMaxHealth() * 0.35 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_fleeing_haste", {})
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local runVector = ((caster:GetAbsOrigin() - enemies[1]:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
			caster:MoveToPosition(caster:GetAbsOrigin() + runVector * 600)
		end
	else
		caster:RemoveModifierByName("modifier_fleeing_haste")
	end
end

function WaterSpiritTrigger5(trigger)
	if Tanari.WaterTemple.RubicksComplete then
		if not Tanari.WaterTemple.LastSpiritAreaOpened then
			local hero = trigger.activator

			Tanari.WaterTemple.LastSpiritAreaOpened = true
			Tanari:ActivateSwitchGenericWithZ(Vector(-10509, 8432, 200), "WaterSwitch", true, 0.35)
			Timers:CreateTimer(0.5, function()
				Tanari:LowerWaterTempleWall(-6, "WaterTempleSpiritWall", Vector(-10300, 2570, -80), "WaterTempleSpiritBlocker", Vector(-10304, 2560, 270), 1000, true, false)
				Dungeons:CreateBasicCameraLockForHeroes(Vector(-10300, 2570, -80), 3, {hero})
			end)
			Timers:CreateTimer(1.0, function()
				Tanari:LowerWaterTempleWall(-6, "WaterTempleSpiritWall", Vector(-10189, 8481, 100), "WaterTempleSpiritBlocker", Vector(-10176, 8448, 100), 1200, true, false)
			end)
		end
	end
end

function FinalWaterSpiritTrigger(trigger)
	if Tanari.WaterTemple.LastSpiritAreaOpened then
		if not Tanari.WaterTemple.LastSpiritAreaSpawned then
			Tanari.WaterTemple.LastSpiritAreaSpawned = true
			Tanari:InitiateLastSpiritRoom()
		end
	end
end

function ice_queen_die(event)
	local caster = event.caster
	EmitSoundOn("Tanari.IceQueen.Death", caster)
	Timers:CreateTimer(1, function()
		EmitGlobalSound("ui.set_applied")
		Tanari.WaterTemple.IceQueenDead = true
		AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-15552, 2304, 1030), 400, 1200, false)
		Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(-15552, 2304, 1030), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
		Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(10496, -512, 1060), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
	end)
	local luck = RandomInt(1, 4)
	if luck == 1 then
		RPCItems:RollAlaranaIceBoot(caster:GetAbsOrigin())
	end
	Tanari:SpawnSpiritMountain()
end

function WaterTempleMountainPortal(trigger)
	if Tanari.WaterTemple then
		if Tanari.WaterTemple.IceQueenDead then
			local hero = trigger.activator
			local portToVector = Vector(10496, -512)
			if not hero:HasModifier("modifier_recently_teleported_portal") then
				Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
				if not Tanari.HeroTrail2 then
					Tanari:SpawnHeroTrail2()
				end
			end
		end
	end
end

function WaterTempleMountainPortal2(trigger)
	if Tanari.WaterTemple then
		if Tanari.WaterTemple.IceQueenDead then
			local hero = trigger.activator
			if not hero:HasModifier("modifier_recently_teleported_portal") then
				local portToVector = Vector(-15552, 2304, 1000)
				Events:TeleportUnit(hero, portToVector, Events.GameMaster.portal, Events.GameMaster, 1.2)
			end
		end
	end
end

function slithereen_elite_take_damage(event)
	local attacker = event.attacker
	local caster = event.caster
	local stun_chance = event.stun_chance
	local luck = RandomInt(1, 100)
	if luck <= stun_chance then
		Filters:ApplyStun(caster, 0.7, attacker)
		EmitSoundOn("Tanari.SlithElite.Stun", attacker)
	end
end

function WaterTempleSpiritBossTrigger(event)
	if Tanari.WaterTemple then
		if Tanari.WaterTemple.IceQueenDead then
			if not Tanari.WaterTemple.FinalSpiritBossSpawned then
				Tanari.WaterTemple.FinalSpiritBossSpawned = true
				Tanari:SpawnWaterSpiritFinalBoss()
			end
		end
	end
end

function spirit_boss_fighting_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 0
	end
	if caster.dying then
		return false
	end
	if caster:GetHealth() < 1000 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_water_spirit_boss_dying", {})
		caster.dying = true
		return false
	end
	if not caster.summonState then
		caster.summonState = 1.5
	end
	if not caster:HasModifier("modifier_water_spirit_charged") then
		local lightningAbility = caster:FindAbilityByName("water_spirit_main_boss_charged")
		if lightningAbility.pfx then
			ParticleManager:DestroyParticle(lightningAbility.pfx, false)
			lightningAbility.pfx = false
		end
	end
	if caster:HasModifier("modifier_main_boss_entering") then
		return false
	end
	caster.interval = caster.interval + 1
	if caster:GetHealth() < caster:GetMaxHealth() * 0.75 then
		local modulos = 5
		if GameState:GetDifficultyFactor() == 3 then
			modulos = modulos - 1
		end
		if caster:GetHealth() < caster:GetMaxHealth() * 0.5 then
			modulos = modulos - 1
		end
		if caster:GetHealth() < caster:GetMaxHealth() * 0.25 then
			modulos = modulos - 1
		end
		if caster.interval % modulos == 0 then
			local nukePosition = GetGroundPosition(caster:GetAbsOrigin() + RandomVector(RandomInt(160, 1400)), Events.GameMaster)
			Events:CreateLightningBeam(nukePosition, nukePosition + Vector(0, 0, RandomInt(1600, 2000)))
			EmitSoundOnLocationWithCaster(nukePosition, "Item.Maelstrom.Chain_Lightning", Events.GameMaster)
			Timers:CreateTimer(1.5, function()
				EmitSoundOnLocationWithCaster(nukePosition, "Tanari.WaterSpiritBoss.Quake", Events.GameMaster)
				local damage = event.quakeDamage

				local radius = 220
				local position = nukePosition
				local stun_duration = 1.2
				local splitEarthParticle = "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf"
				local pfx = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(pfx, 0, position)
				ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
				local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius + 5, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
				if #enemies > 0 then
					for _, enemy in pairs(enemies) do
						ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
						Filters:ApplyStun(caster, stun_duration, enemy)
					end
				end
				Timers:CreateTimer(3.5, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)
			end)
		end
	end
	if caster.summonState < math.ceil((1 - (caster:GetHealth() / caster:GetMaxHealth())) * 10) and not caster.summonLock then
		caster.summonLock = true
		caster.summonState = caster.summonState + 1.5
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_main_boss_entering", {duration = 8})
		for i = 1, 30, 1 do
			Timers:CreateTimer(i * 0.03, function()
				caster:SetAbsOrigin(caster:GetAbsOrigin() - Vector(0, 0, 1000 / 30))
			end)
		end
		local guardian = caster
		StartAnimation(caster, {duration = 1, activity = ACT_DOTA_SPAWN, rate = 1})
		Timers:CreateTimer(0.7, function()
			StartAnimation(guardian, {duration = 1, activity = ACT_DOTA_SPAWN, rate = 1})
			Timers:CreateTimer(0.18, function()
				particleName = "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash.vpcf"
				local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, guardian)
				ParticleManager:SetParticleControl(particle1, 0, Vector(12992, -1024, 1000))

				Timers:CreateTimer(4, function()
					ParticleManager:DestroyParticle(particle1, false)
				end)
			end)
		end)
		for i = 0, 2, 1 do
			Timers:CreateTimer(i * 2, function()
				local particleName = "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_bubbles_fxset.vpcf"
				local particle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, statue)
				ParticleManager:SetParticleControl(particle, 0, Vector(12992, -1024, 1100))
				Timers:CreateTimer(5.2, function()
					ParticleManager:DestroyParticle(particle, false)
				end)
			end)
		end
		for i = 1, 6, 1 do
			Timers:CreateTimer(i * 0.6, function()
				ScreenShake(guardian:GetAbsOrigin(), 3000, 0.9, 0.9, 9000, 1, true)
				EmitSoundOnLocationWithCaster(guardian:GetAbsOrigin(), "Tanari.Shake", Events.GameMaster)
			end)
		end
		EmitSoundOnLocationWithCaster(Vector(12992, -1024), "Tanari.WaterSpiritBoss.Music", Events.GameMaster)

		Timers:CreateTimer(4, function()
			EmitSoundOn("Tanari.WaterSplash", guardian)
			ScreenShake(guardian:GetAbsOrigin(), 3000, 1.5, 1.5, 9000, 1, true)
			StartAnimation(guardian, {duration = 1, activity = ACT_DOTA_SPAWN, rate = 1})
			Timers:CreateTimer(0.18, function()
				particleName = "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash.vpcf"
				local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, guardian)
				ParticleManager:SetParticleControl(particle1, 0, Vector(12992, -1024, 1000))

				Timers:CreateTimer(4, function()
					ParticleManager:DestroyParticle(particle1, false)
				end)
			end)
			for i = 1, GameState:GetDifficultyFactor() + 1, 1 do
				if caster.summonState == 6 or caster.summonState == 10.5 then
					for j = 1, 2, 1 do
						if j % 2 == 0 then
							local jailer = Tanari:SpawnSlardarJailer(caster:GetAbsOrigin() + RandomVector(RandomInt(450, 1200)), RandomVector(1))
							jailer:SetAbsOrigin(jailer:GetAbsOrigin() + Vector(0, 0, 1600))
							WallPhysics:Jump(jailer, Vector(1, 1), 0, 32, 1, 1.0)
							jailer.jumpEnd = "lava_legion"
							Timers:CreateTimer(1.5, function()
								Dungeons:AggroUnit(jailer)
							end)
						else
							local jailer = Tanari:SpawnSlithereenEliteWarrior(caster:GetAbsOrigin() + RandomVector(RandomInt(450, 1200)), RandomVector(1))
							jailer:SetAbsOrigin(jailer:GetAbsOrigin() + Vector(0, 0, 1600))
							WallPhysics:Jump(jailer, Vector(1, 1), 0, 32, 1, 1.0)
							jailer.jumpEnd = "lava_legion"
							Timers:CreateTimer(1.5, function()
								Dungeons:AggroUnit(jailer)
							end)
						end
					end
				else
					local sorrow = Tanari:SpawnDrownedSorrow(caster:GetAbsOrigin() + RandomVector(RandomInt(450, 1000)), RandomVector(1))
					Dungeons:AggroUnit(sorrow)
				end
			end
		end)
		Timers:CreateTimer(6, function()
			for i = 1, 50, 1 do
				Timers:CreateTimer(i * 0.03, function()
					guardian:SetAbsOrigin(guardian:GetAbsOrigin() + Vector(0, 0, 1000 / 50))
					ScreenShake(guardian:GetAbsOrigin(), 200, 0.1, 0.1, 9000, 0, true)
				end)
			end
			Timers:CreateTimer(0.8, function()
				StartAnimation(guardian, {duration = 1, activity = ACT_DOTA_SPAWN, rate = 1})
				Timers:CreateTimer(0.18, function()
					particleName = "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash.vpcf"
					local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, guardian)
					ParticleManager:SetParticleControl(particle1, 0, Vector(12992, -1024, 1000))
					EmitSoundOn("Tanari.WaterSplash", guardian)
					Timers:CreateTimer(4, function()
						ParticleManager:DestroyParticle(particle1, false)
					end)
				end)
			end)
			Timers:CreateTimer(2.5, function()
				guardian:RemoveModifierByName("modifier_main_boss_entering")
				ability:ApplyDataDrivenModifier(guardian, guardian, "modifier_spirit_boss_fighting", {})
				guardian:SetAbsOrigin(guardian:GetAbsOrigin() - Vector(0, 0, 400))
				Timers:CreateTimer(1, function()
					guardian.summonLock = false
				end)
			end)
		end)
		return false
	end
	if caster.interval % 4 == 0 and caster:IsAlive() then

		local projectileCount = math.ceil((1 - (caster:GetHealth() / caster:GetMaxHealth())) * 10)
		if projectileCount > 0 then
			EmitSoundOn("Items.PureWaters", caster)
			local fv = RandomVector(1)
			for i = 1, projectileCount, 1 do
				local fv = WallPhysics:rotateVector(fv, (2 * math.pi * i) / projectileCount)
				local particleName = "particles/units/heroes/hero_morphling/morphling_waveform.vpcf"
				local start_radius = 135
				local end_radius = 135
				local range = 2000
				local speed = 900
				local info =
				{
					Ability = ability,
					EffectName = particleName,
					vSpawnOrigin = caster:GetAbsOrigin() + Vector(0, 0, 440),
					fDistance = range,
					fStartRadius = start_radius,
					fEndRadius = end_radius,
					Source = caster,
					StartPosition = "attach_attack1",
					bHasFrontalCone = false,
					bReplaceExisting = false,
					iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
					iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
					iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					fExpireTime = GameRules:GetGameTime() + 4.0,
					bDeleteOnHit = false,
					vVelocity = fv * speed,
					bProvidesVision = false,
				}
				projectile = ProjectileManager:CreateLinearProjectile(info)
			end
		end
	end
	if caster.interval == 102 then
		caster.interval = 0
	end
end

function spirit_boss_charged_apply(event)
	local caster = event.caster
	StartAnimation(caster, {duration = 1, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1.15})
	local ability = event.ability
	StartSoundEvent("Tanari.WaterSpiritBoss.ElectricityStart", caster)
	ability.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_ball_lightning.vpcf", PATTACH_POINT_FOLLOW, caster)
	for i = 0, 12, 1 do
		ParticleManager:SetParticleControlEnt(ability.pfx, i, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	end
end

function spirit_boss_charge_hit(event)
	local caster = event.caster
	local ability = event.ability
	local attacker = event.attacker

	local pushVector = ((attacker:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	Tanari:ElectrocuteUnit(Tanari.TanariMaster, Tanari.TanariMasterAbility, attacker, pushVector)
end

function spirit_boss_charge_end(event)
	local caster = event.caster
	StopSoundEvent("Tanari.WaterSpiritBoss.ElectricityStart", caster)
	EmitSoundOn("Tanari.WaterSpiritBoss.ElectricityEnd", caster)
	local ability = event.ability
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ability.pfx = false
	end
end

function water_temple_spirit_boss_die_begin(event)
	Statistics.dispatch("tanari_jungle:kill:water_spirit");
	local ability = event.ability
	local caster = event.caster
	Tanari.WaterSpiritBossDead = true
	Timers:CreateTimer(0.5, function()
		EmitSoundOn("Tanari.WaterSpiritMainBoss.Death1", caster)
	end)

	local bossOrigin = caster:GetAbsOrigin()
	for i = 1, 12, 1 do
		Timers:CreateTimer(0.5 * i, function()
			RPCItems:RollItemtype(300, caster:GetAbsOrigin(), 1, 0)
		end)
	end
	Timers:CreateTimer(3, function()
		local itemName = "item_tanari_spirit_stones_"..Tanari:ConvertDifficultyNumberToName(GameState:GetDifficultyFactor())
		--print(itemName)
		local stones = RPCItems:CreateConsumable(itemName, "immortal", "tanari_spirit_stones", "consumable", false, "Consumable", itemName.."_desc")
		CreateItemOnPositionSync(bossOrigin, stones)
		--stones:LaunchLoot(false, RandomInt(100,600), 0.75, bossOrigin)
		RPCItems:LaunchLoot(stones, RandomInt(100, 600), 0.5, bossOrigin, bossOrigin)
		--print("STONES DROPPED")

		local luck = RandomInt(1, 3)
		if luck == 1 then
			RPCItems:RollBlueRainGauntlet(bossOrigin)
		elseif luck == 2 then
			RPCItems:RollAquastoneRing(bossOrigin)
		elseif luck == 3 then
			RPCItems:RollAquasteelBracers(bossOrigin)
		end
	end)
	Timers:CreateTimer(4, function()
		local maxRoll = 200
		if GameState:GetDifficultyFactor() == 3 then
			maxRoll = 130
		end
		local requirement = 2 + GameState:GetPlayerPremiumStatusCount()
		local luck = RandomInt(1, maxRoll)
		if luck <= requirement then
			RPCItems:RollSpiritWarriorArcana1(bossOrigin)
		end
	end)
	Timers:CreateTimer(8, function()
		Enemies:EnemySlain(caster, nil)
		Events:MainBossSlain(caster:GetUnitName())
		CustomGameEventManager:Send_ServerToAllClients("hide_boss_health", {bossId = tostring(caster)})
		caster:RemoveModifierByName("modifier_wind_temple_boss_dying")
		Timers:CreateTimer(0.1, function()
			StartAnimation(caster, {duration = 8, activity = ACT_DOTA_DIE, rate = 1})
			EmitSoundOn("Tanari.WaterSpiritMainBoss.Death2", caster)
			for i = 1, 120, 1 do
				Timers:CreateTimer(i * 0.05, function()
					if IsValidEntity(caster) then
						caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, -5))
					end
				end)
			end
			Timers:CreateTimer(6, function()
				UTIL_Remove(caster)
				Tanari:DefeatSpiritBoss("water", bossOrigin)
			end)
		end)
	end)
end
