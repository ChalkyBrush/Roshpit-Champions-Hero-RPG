function ancient_god_water_take_damage(event)
	local caster = event.caster
	if caster:GetHealth() < 120000 then
		event.element = 2
		ancient_god_think(event)
	end
end

function ancient_god_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 0
	end
	local element = event.element
	AddFOWViewer(DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), 500, 2, true)
	if caster.aggro then
	else
		return false
	end
	if caster.dying then
		return
	end
	local thresh = 15000
	if element == 2 then
		thresh = 120000
	end
	if caster:GetHealth() < thresh then
		caster:SetHealth(1)
		caster.dying = true
		local steadfastAbility = caster:FindAbilityByName("ancient_god_steadfast")
		steadfastAbility:ApplyDataDrivenModifier(caster, caster, "modifier_steadfast_boss_dying", {})
	end
	if element == 1 then
		local wind_dodge = caster:FindAbilityByName("ancient_god_wind_dodge_ability")
		if wind_dodge:IsFullyCastable() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 2500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = wind_dodge:entindex(),
				}

				ExecuteOrderFromTable(newOrder)
				return
			end
		end
		if caster:HasAbility("ancient_god_wind_blink_ability") then
			local wind_blink = caster:FindAbilityByName("ancient_god_wind_blink_ability")
			if wind_blink:IsFullyCastable() then
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = wind_blink:entindex(),
				}

				ExecuteOrderFromTable(newOrder)
				return
			end
		end
	elseif element == 2 then
		local water_vortex = caster:FindAbilityByName("ancient_god_water_vortex")
		if water_vortex:IsFullyCastable() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 3500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = water_vortex:entindex(),
				}

				ExecuteOrderFromTable(newOrder)
				return
			end
		end
		-- local waveAbility = caster:FindAbilityByName("faceless_waveform")

		-- local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
		-- if #enemies > 0 then
		-- if waveAbility:IsFullyCastable() then
		-- local fv = ((enemies[1]:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		-- local castPoint = caster:GetAbsOrigin()+(fv*1200)
		-- local newOrder = {
		-- UnitIndex = caster:entindex(),
		-- OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		-- AbilityIndex = waveAbility:entindex(),
		-- Position = castPoint
		--  }

		-- ExecuteOrderFromTable(newOrder)
		-- return
		-- end
		-- end
		

	elseif element == 3 then
		local rotatedVector = WallPhysics:rotateVector(Vector(0, 1), (2 * math.pi * caster.interval) / 20)
		if caster.interval % 2 == 0 then
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Tanari.AncientHero.FireVortex", caster)
		end

		create_vortex_flame(caster, ability, rotatedVector)
		local dragonAbility = caster:FindAbilityByName("kolthun_dragon_slave")
		if caster.interval % 15 == 0 then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				if dragonAbility:IsFullyCastable() then
					local fv = ((enemies[1]:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
					local castPoint = caster:GetAbsOrigin() + (fv * 1200)
					local newOrder = {
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
						AbilityIndex = dragonAbility:entindex(),
						Position = castPoint
					}

					ExecuteOrderFromTable(newOrder)
					return
				end
			end
		end
	end
	caster.interval = caster.interval + 1
	local currentPercent = caster:GetHealth() / caster:GetMaxHealth()
	if caster.startingPercent - currentPercent > 0.1 then
		caster.interval = 0
		ancient_god_change_element(event)
	end
	if caster.interval == 80 then
		caster.interval = 0
		ancient_god_change_element(event)
	end
end

function ancient_god_change_element(event)
	local caster = event.caster
	local ability = event.ability
	local element = event.element
	if element == 1 then
		caster:RemoveAbility("tanari_ancient_hero_wind_god")
		caster:RemoveModifierByName("modifier_ancient_hero_wind_god")
		caster:RemoveAbility("ancient_god_wind_dodge_ability")
		caster:RemoveAbility("ancient_god_wind_blink_ability")
		Tanari:ColorWearables(caster, Vector(150, 150, 255))
		caster:SetRenderColor(150, 150, 255)
		caster:AddAbility("tanari_ancient_hero_water_god"):SetLevel(3)
		caster:AddAbility("creature_pure_strike"):SetLevel(3)
		caster:AddAbility("ancient_god_water_vortex"):SetLevel(3)
		caster:AddAbility("ancient_water_god_passive"):SetLevel(3)
		caster:SetRangedProjectileName("particles/units/heroes/hero_morphling/morphling_base_attack.vpcf")
		caster.element = 2
		-- caster:AddAbility("faceless_waveform"):SetLevel(3)
	elseif element == 2 then
		caster:RemoveAbility("tanari_ancient_hero_water_god")
		caster:RemoveAbility("ancient_god_water_vortex")
		caster:RemoveAbility("ancient_water_god_passive")
		caster:RemoveModifierByName("modifier_water_temple_rare_water_construct_ai")
		-- caster:RemoveAbility("faceless_waveform")
		caster:RemoveModifierByName("modifier_ancient_hero_water_god")
		caster:RemoveAbility("creature_pure_strike")
		caster:RemoveModifierByName("modifier_pure_strike")
		Tanari:ColorWearables(caster, Vector(255, 60, 60))
		caster:SetRenderColor(255, 60, 60)
		caster:AddAbility("kolthun_dragon_slave"):SetLevel(3)
		caster:AddAbility("tanari_ancient_hero_fire_god"):SetLevel(3)
		caster:AddAbility("tanari_ancient_hero_fire_vortex"):SetLevel(3)
		caster:SetRangedProjectileName("particles/units/heroes/hero_lina/lina_base_attack.vpcf")
		caster.element = 3
	elseif element == 3 then
		caster:RemoveAbility("tanari_ancient_hero_fire_god")
		caster:RemoveAbility("kolthun_dragon_slave")
		caster:RemoveAbility("tanari_ancient_hero_fire_vortex")
		caster:RemoveModifierByName("modifier_ancient_hero_fire_god")
		Tanari:ColorWearables(caster, Vector(150, 255, 150))
		caster:SetRenderColor(150, 255, 150)
		caster:AddAbility("tanari_ancient_hero_wind_god"):SetLevel(3)
		caster:AddAbility("ancient_god_wind_dodge_ability"):SetLevel(3)
		caster:AddAbility("ancient_god_wind_blink_ability"):SetLevel(3)
		caster:SetRangedProjectileName("particles/units/heroes/hero_zuus/zuus_base_attack.vpcf")
		caster.element = 1
	end
	StartAnimation(caster, {duration = 1, activity = ACT_DOTA_CAST_ABILITY_4, rate = 1})
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Tanari.AncientHero.Spawn", Events.GameMaster)
	EmitSoundOn("Tanari.AncientHero.ElementSwapVoice", caster)
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_arc_warden/arc_warden_loadout.vpcf", caster, 3)
	caster.startingPercent = caster:GetHealth() / caster:GetMaxHealth()
end

function create_vortex_flame(caster, ability, fv)
	local vortexAbility = caster:FindAbilityByName("tanari_ancient_hero_fire_vortex")
	local start_radius = 120
	local end_radius = 200
	local range = 1640
	local speed = 1100
	local info =
	{
		Ability = vortexAbility,
		EffectName = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf",
		vSpawnOrigin = caster:GetAbsOrigin() + Vector(0, 0, 140),
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

function god_water_vortex(event)
	local caster = event.caster
	local ability = event.ability

	local particleName = "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/water_temple_boss_whirlpool_fxset.vpcf"
	local particle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin() + Vector(0, 0, 70))
	Timers:CreateTimer(2.2, function()
		ParticleManager:DestroyParticle(particle, false)
	end)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 4500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for i = 1, #enemies, 1 do
			local target = enemies[i]
			EmitSoundOn("Tanari.AncientGod.PullAbilityEffect", target)
			CustomAbilities:QuickAttachParticle("particles/econ/items/lich/frozen_chains_ti6/lich_frozenchains_frostnova_g.vpcf", caster, 3)
			local particleName = "particles/units/heroes/hero_lich/lich_dark_ritual.vpcf"
			local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ability:ApplyDataDrivenModifier(caster, target, "modifier_crimsith_cult_pull", {duration = 1.5})
			local jumpDirection = ((caster:GetAbsOrigin() - target:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
			local distance = WallPhysics:GetDistance(target:GetAbsOrigin() * Vector(1, 1, 0), caster:GetAbsOrigin() * Vector(1, 1, 0))
			local propulsion = math.floor(distance / 32)
			WallPhysics:Jump(target, jumpDirection, propulsion, 20, 36, 1.2)
		end
	end
end

function wind_god_dodge(event)
	local caster = event.caster
	local ability = event.ability

	local casterOrigin = caster:GetAbsOrigin()
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), casterOrigin, nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 and not caster:HasModifier("modifier_trickster_dashing") then
		ability:StartCooldown(4)
		local sumVector = Vector(0, 0, 0)
		for i = 1, #enemies, 1 do
			sumVector = sumVector + enemies[i]:GetAbsOrigin()
		end
		local avgVector = sumVector / #enemies
		local forceDirection = ((avgVector - casterOrigin) * Vector(1, 1, 0)):Normalized()

		EmitSoundOn("Tanari.DodgeJump", caster)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_trickster_dashing", {duration = 0.66})
		StartAnimation(caster, {duration = 0.65, activity = ACT_DOTA_FLAIL, rate = 0.8, translate = "forcestaff_friendly"})
		for i = 1, 22, 1 do
			Timers:CreateTimer(i * 0.03, function()
				caster:SetAbsOrigin(caster:GetAbsOrigin() + forceDirection * 38)
			end)
		end
		Timers:CreateTimer(0.71, function()
			StartAnimation(caster, {duration = 0.65, activity = ACT_DOTA_FORCESTAFF_END, rate = 0.8})
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		end)
	end

end

function wind_god_blink(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Tanari.AncientGod.Blink", caster)

	StartAnimation(caster, {duration = 1, activity = ACT_DOTA_TELEPORT_END, rate = 1.0})
	local particleName = "particles/econ/events/fall_major_2016/blink_dagger_start_fm06.vpcf"
	local pfx1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx1, 0, caster:GetAbsOrigin())
	-- local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_undying/undying_loadout.vpcf", PATTACH_ABSORIGIN, event.caster )
	--     ParticleManager:SetParticleControl( pfx, 0, position )
	local newPosition = MAIN_HERO_TABLE[RandomInt(1, #MAIN_HERO_TABLE)]:GetAbsOrigin() + RandomVector(RandomInt(400, 900))
	FindClearSpaceForUnit(caster, newPosition, false)
	local pfx2 = ParticleManager:CreateParticle("particles/econ/events/fall_major_2016/blink_dagger_end_fm06.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx2, 0, newPosition)
	Timers:CreateTimer(4, function()
		ParticleManager:DestroyParticle(pfx1, false)
		ParticleManager:DestroyParticle(pfx2, false)
	end)
end

function ancient_water_passive_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.aggro then
		local start_radius = 400
		local end_radius = 400
		local range = 2000
		local speed = 350
		local fv = RandomVector(1)
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
			fExpireTime = GameRules:GetGameTime() + 10.0,
			bDeleteOnHit = false,
			vVelocity = fv * speed,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
	end

end

function ancient_boss_die_begin(event)
	Statistics.dispatch("tanari_jungle:kill:ancient_god");
	local ability = event.ability
	local caster = event.caster
	local startingItemLevel = Dungeons.itemLevel
	Dungeons.itemLevel = 300
	Timers:CreateTimer(0.5, function()
		EmitSoundOn("Tanari.AncientHero.DeathVO1", caster)
	end)
	local casterOrigin = caster:GetAbsOrigin()
	Tanari.GodDefeated = true
	for i = 1, #MAIN_HERO_TABLE, 1 do
		Stars:StarEventSolo("weapon", MAIN_HERO_TABLE[i])
	end
	Timers:CreateTimer(1.5, function()
		local bSpirit = false
		local paragonBonus = 0
		if Tanari.BossesSlainSpirit == 3 then
			bSpirit = true
		end
		if caster.paragon then
			paragonBonus = 4
		end
		if caster.element == 1 then
			RPCItems:RollWindDeityCrown(casterOrigin, bSpirit, paragonBonus)
		elseif caster.element == 2 then
			RPCItems:RollWaterDeityCrown(casterOrigin, bSpirit, paragonBonus)
		elseif caster.element == 3 then
			RPCItems:RollFireDeityCrown(casterOrigin, bSpirit, paragonBonus)
		end
	end)
	local itemDropCount = 12
	caster:BossDrops(itemDropCount)

	local bossOrigin = caster:GetAbsOrigin()
	Timers:CreateTimer(8, function()
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_steadfast_boss_dying_effect", {})
		CustomGameEventManager:Send_ServerToAllClients("hide_boss_health", {bossId = tostring(caster)})
		caster:RemoveModifierByName("modifier_steadfast_boss_dying")
		Timers:CreateTimer(0.1, function()
			StartAnimation(caster, {duration = 8, activity = ACT_DOTA_DIE, rate = 0.25})
			EmitSoundOn("Tanari.AncientHero.DeathVO2", caster)
			for i = 1, 90, 1 do
				Timers:CreateTimer(i * 0.05, function()
					if IsValidEntity(caster) then
						caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, -5))
					end
				end)
			end
			Timers:CreateTimer(6, function()
				local crystals = TANARI_MITHRIL_ANCIENT_GOD
				if caster.paragon then
					crystals = TANARI_MITHRIL_ANCIENT_GOD * TANARI_MITHRIL_ANCIENT_GOD_PARAGON_MULT
				end
				Tanari:GenericCrystal(crystals, casterOrigin)
				UTIL_Remove(caster)

			end)
		end)
	end)
	Timers:CreateTimer(30, function()
		Dungeons.itemLevel = startingItemLevel
	end)
end

function ancient_boss_dying_think(event)
	local caster = event.caster
	if not caster.flailEffect then
		caster.flailEffect = true
		StartAnimation(caster, {duration = 5.5, activity = ACT_DOTA_FLAIL, rate = 1.0})
	end
	CustomAbilities:QuickAttachParticleWithPoint("particles/radiant_fx2/good_ancient001_dest_gobjglow.vpcf", caster, 4, "attach_hitloc")
	EmitSoundOn("Tanari.WindTemple.BossDying", caster)
end
