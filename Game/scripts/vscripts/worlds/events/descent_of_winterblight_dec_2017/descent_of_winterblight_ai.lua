function aertega_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.aggro then
		if not caster.interval then
			caster.interval = 0
		end
		if not caster:HasModifier("modifier_disable_player") then
			caster.interval = caster.interval + 1
		end
		local nova = caster:FindAbilityByName("aertega_frost_nova")
		if nova:IsFullyCastable() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				local order =
				{
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = nova:entindex(),
				}
				ExecuteOrderFromTable(order)
				return false
			end
		end
		if caster.interval >= 50 + RandomInt(1, 50) then
			caster.interval = 0
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Aertega.IceShield", caster)
			EmitSoundOn("Aertega.IceShield.VO", caster)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_disable_player", {duration = 8})
			local particleName = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_snow_arcana1.vpcf"
			local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
			local origin = caster:GetAbsOrigin()
			ParticleManager:SetParticleControl(particle1, 0, origin + Vector(0, 0, 20))
			ParticleManager:SetParticleControl(particle1, 1, Vector(550, 2, 1000))
			ParticleManager:SetParticleControl(particle1, 3, Vector(550, 550, 550))
			Timers:CreateTimer(8, function()
				ParticleManager:DestroyParticle(particle1, false)
			end)
		end
	else
		local nova = caster:FindAbilityByName("aertega_frost_nova")
		nova:StartCooldown(8)
	end
end

function archon_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if WallPhysics:GetDistance2d(caster:GetAbsOrigin(), target:GetAbsOrigin()) >= 750 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_archon_pushback", {duration = 1})
		local pushFV = ((caster:GetAbsOrigin() - target:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized() *- 1
		ability.pushFV = pushFV
		ability.pushVelocity = 30
	end
end

function archon_slide_think(event)
	local caster = event.caster
	local ability = event.ability
	local newPosition = GetGroundPosition(caster:GetAbsOrigin() + ability.pushFV * ability.pushVelocity, caster)
	local afterWallPosition = WallPhysics:WallSearch(GetGroundPosition(caster:GetAbsOrigin(), caster), newPosition, caster)
	if afterWallPosition == newPosition then
		caster:SetAbsOrigin(newPosition)
	end
	ability.pushVelocity = ability.pushVelocity - 1
	if ability.pushVelocity <= 0 then
		caster:RemoveModifierByName("modifier_archon_pushback")
	end
end

function aertega_frost_nova_start(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Aertega.FrostNova.Channel", caster)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Aertega.FrostNovaChannelSound", caster)
	CustomAbilities:QuickAttachParticle("particles/act_2/ice_boss_channel.vpcf", caster, 3)
	CustomAbilities:QuickAttachParticle("particles/econ/items/winter_wyvern/winter_wyvern_ti7/wyvern_cold_embrace_ti7ground_ice.vpcf", caster, 4)
end

function aertega_frost_nova(event)
	local caster = event.caster
	local ability = event.ability
	local radius = 2000
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = caster, damage = event.damage, damage_type = DAMAGE_TYPE_MAGICAL})
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_aertega_frost_nova", {duration = event.duration})
			EmitSoundOn("Aertega.FrostNova.Freeze", enemy)
		end
	end
	EmitSoundOn("Aertega.FrostNovaBlast", caster)
	local particleName = "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	local origin = caster:GetAbsOrigin()
	ParticleManager:SetParticleControl(particle1, 0, origin + Vector(0, 0, 20))
	ParticleManager:SetParticleControl(particle1, 1, Vector(2100, 2.5, 550))
	ParticleManager:SetParticleControl(particle1, 3, Vector(2000, 2000, 2000))
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
end

function torturok_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	local attacker = event.attacker

	if not caster.projectiles then
		caster.projectiles = 0
	end
	if caster.projectiles < 25 then
		local info =
		{
			Target = attacker,
			Source = caster,
			Ability = ability,
			EffectName = "particles/roshpit/winterblight/torturok_projectile_base_attack.vpcf",
			StartPosition = "attach_attack2",
			bDrawsOnMinimap = false,
			bDodgeable = true,
			bIsAttack = false,
			bVisibleToEnemies = true,
			bReplaceExisting = false,
			flExpireTime = GameRules:GetGameTime() + 5,
			bProvidesVision = false,
			iVisionRadius = 0,
			iMoveSpeed = 600,
		iVisionTeamNumber = caster:GetTeamNumber()}
		local projectile = ProjectileManager:CreateTrackingProjectile(info)
	end
end

function torturok_projectile_hit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	caster.projectiles = caster.projectiles - 1
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
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_frostburn_gauntlets_slow", {duration = 3})
			ApplyDamage({victim = victim, attacker = caster, damage = event.damage, damage_type = DAMAGE_TYPE_PURE})
		end
	end
end

function torturok_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.aggro then
		if not caster.interval then
			caster.interval = 0
		end
		if not caster:HasModifier("modifier_disable_player") then
			caster.interval = caster.interval + 1
		end

		local nova = caster:FindAbilityByName("torturok_comet")
		if nova:IsFullyCastable() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 2500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				local fv = ((enemies[1]:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
				local order =
				{
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = nova:entindex(),
				Position = enemies[1]:GetAbsOrigin() + fv * RandomInt(-500, 500)}
				ExecuteOrderFromTable(order)
				return false
			end
		end
		if caster:GetHealth() < caster:GetMaxHealth() * 0.5 then
			local bloodlust = caster:FindAbilityByName('ogre_magi_bloodlust')
			if bloodlust:IsFullyCastable() then
				local order =
				{
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = bloodlust:entindex(),
				}
				ExecuteOrderFromTable(order)
				return false
			end
		end
		if caster.interval >= 50 + RandomInt(1, 50) then
			caster.interval = 0
		end
	else
		local nova = caster:FindAbilityByName("torturok_comet")
		nova:StartCooldown(4)
	end
end

function begin_crusader_comet(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	StartAnimation(caster, {duration = 1.6, activity = ACT_DOTA_SPAWN, rate = 1.9})
	ability.point = WallPhysics:WallSearch(caster:GetAbsOrigin(), point, caster)
	ability.jumpVelocity = 60
	ability.forwardMovement = 2
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_comet_jumping", {duration = 1})
	ability.fv = ((ability.point - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	ability.landAnimated = false
	EmitSoundOn("Torturok.Jump.VO", caster)

	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Torturok.Jump.Start", caster)
	caster:RemoveModifierByName("modifier_comet_storming")

end

function jumping_think(event)
	local caster = event.caster
	local ability = event.ability
	ability.jumpVelocity = math.max(ability.jumpVelocity - 3, 20)
	ability.forwardMovement = ability.forwardMovement + 8

	local newPosition = caster:GetAbsOrigin() + Vector(0, 0, ability.jumpVelocity) + ability.fv * ability.forwardMovement
	local afterWallPosition = WallPhysics:WallSearch(caster:GetAbsOrigin(), newPosition, caster)

	if afterWallPosition == newPosition then
		caster:SetAbsOrigin(newPosition)
	else
		caster:SetAbsOrigin(newPosition - ability.fv * ability.forwardMovement)
	end

	if caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster) > 500 then
		caster:RemoveModifierByName("modifier_comet_jumping")
		-- ability.fv = ((ability.point - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_comet_storming", {duration = 2})
		local distanceToDash = WallPhysics:GetDistance2d(ability.point, caster:GetAbsOrigin())
		local dashTicks = (caster:GetAbsOrigin().z - GetGroundHeight(ability.point, caster)) / 20
		ability.dashSpeed = math.max(distanceToDash / dashTicks, ability.forwardMovement)
	end
end

function comet_think(event)
	local caster = event.caster
	local ability = event.ability
	local moveVelocity = ability.dashSpeed

	local newPosition = caster:GetAbsOrigin() + ability.fv * moveVelocity - Vector(0, 0, 40)
	local afterWallPosition = WallPhysics:WallSearch(caster:GetAbsOrigin(), newPosition, caster)

	if afterWallPosition == newPosition then
		caster:SetAbsOrigin(newPosition)
	else
		caster:SetAbsOrigin(newPosition - ability.fv * moveVelocity)
	end

	-- caster:SetAbsOrigin(caster:GetAbsOrigin()+ability.fv*moveVelocity-Vector(0,0,40))
	if caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster) < 80 then
		caster:RemoveModifierByName("modifier_comet_storming")
	elseif caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster) < 340 then
		if not ability.landAnimated then
			--print("ANIMATE")
			-- EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Paladin.CometLand", caster)
			-- ability.landAnimated = true
			-- StartAnimation(caster, {duration=0.7, activity=ACT_DOTA_ATTACK, rate=1.3})
		end
	end
end

function comet_storm_end(event)
	local caster = event.caster
	local ability = event.ability
	local landPoint = GetGroundPosition(caster:GetAbsOrigin() + ability.fv * ability.forwardMovement, caster)
	FindClearSpaceForUnit(caster, landPoint, false)
	local landPoint = GetGroundPosition(caster:GetAbsOrigin(), caster)
	local pfx2 = ParticleManager:CreateParticle("particles/roshpit/winterblight/torturok_land_magical.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx2, 0, landPoint)
	ParticleManager:SetParticleControl(pfx2, 2, Vector(90, 100, 255))
	Timers:CreateTimer(3.5, function()
		ParticleManager:DestroyParticle(pfx2, false)
	end)
	EmitSoundOn("Torturok.Jump.Land", caster)
	AddFOWViewer(DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), 300, 3, false)
	local damage = event.damage + 100
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), landPoint, nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE})
		end
	end
	ScreenShake(caster:GetAbsOrigin(), 3900, 0.5, 0.5, 3900, 0, true)
	local radius = 700
	local splitEarthParticle = "particles/roshpit/winterblight/torturok_landquake.vpcf"
	local pfx = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, landPoint + Vector(0, 0, 20))
	ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
	-- FindClearSpaceForUnit(caster, landPoint, false)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), landPoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			enemy:AddNewModifier(caster, event.ability, "modifier_stunned", {duration = 2})
		end
	end
	EmitSoundOn("Torturok.JumpEnd.Roar", caster)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_quick_root", {duration = 0.9})
	StartAnimation(caster, {duration = 1.1, activity = ACT_DOTA_CAST_ABILITY_4, rate = 0.8})
end

function torturok_aura_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local damage_per_distance = event.damage_per_distance
	if not target.torturokPos then
		target.torturokPos = target:GetAbsOrigin()
		return false
	else
		local distanceMoved = WallPhysics:GetDistance2d(target:GetAbsOrigin(), target.torturokPos)
		target.torturokPos = target:GetAbsOrigin()
		if distanceMoved > 10 and distanceMoved < 400 then
			if not target.torturokParticleLock then
				-- target.torturokParticleLock = true
				CustomAbilities:QuickAttachParticle("particles/econ/items/crystal_maiden/ti7_immortal_shoulder/cm_ti7_immortal_frostbite_snow_explode.vpcf", target, 3)
				-- Timers:CreateTimer(0.5, function()
				-- target.torturokParticleLock = false
				-- end)
			end
			EmitSoundOn("Torturok.IceAura.Move", target)
			ApplyDamage({victim = target, attacker = caster, damage = damage_per_distance * distanceMoved, damage_type = DAMAGE_TYPE_PURE})
		end
	end
end

function torturok_aura_end(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	target.torturokPos = nil
end

function ozubu_think(event)
	local caster = event.caster
	local ability = event.ability
	local iceLoops = (1 - (caster:GetHealth() / caster:GetMaxHealth())) * 6 + 1
	if caster.total_lock then
		return false
	end
	if caster.aggro then
		caster.maxSummons = (1 - (caster:GetHealth() / caster:GetMaxHealth())) * 23 + 2
		if not caster.interval then
			caster.interval = 0
		end
		if not caster:HasModifier("modifier_disable_player") then
			caster.interval = caster.interval + 1
		end
		local ice_venom = caster:FindAbilityByName("winterblight_ozubu_ice_venom")
		if ice_venom:IsFullyCastable() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				local order = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					TargetIndex = enemies[1]:entindex(),
					AbilityIndex = ice_venom:entindex(),
				}
				ExecuteOrderFromTable(order)
				return false
			end
		end
		local summon_ability = caster:FindAbilityByName("winterblight_generic_summon")
		if summon_ability:IsFullyCastable() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				local order =
				{
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = summon_ability:entindex(),
				}
				ExecuteOrderFromTable(order)
				return false
			end
		end
		if caster.interval >= 50 + RandomInt(1, 50) then
			caster.interval = 0
		end
	else
		local ice_venom = caster:FindAbilityByName("winterblight_ozubu_ice_venom")
		ice_venom:StartCooldown(2.5)
		local summon_ability = caster:FindAbilityByName("winterblight_generic_summon")
		summon_ability:StartCooldown(4.0)
	end
	if not caster.lock then
		for i = 1, iceLoops, 1 do
			local icePos = caster:GetAbsOrigin() + RandomVector(RandomInt(0, 800))
			if i == 1 then
				EmitSoundOnLocationWithCaster(icePos, "Winterblight.Ozubu.Passive", caster)
			end
			local particle = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
			local pfx = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
			local radius = 200
			ParticleManager:SetParticleControl(pfx, 0, icePos)
			ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 2, radius * 2))
			Timers:CreateTimer(2.5, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), icePos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				for _, enemy in pairs(enemies) do
					ApplyDamage({victim = enemy, attacker = caster, damage = event.damage, damage_type = DAMAGE_TYPE_MAGICAL})
					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_chilled", {duration = 4})
				end
			end
		end
	end
end

function ozubu_take_damage(event)
	local caster = event.caster
	if caster.deathLock then
		return false
	end
	local attacker = event.attacker
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), attacker:GetAbsOrigin())
	if distance > 1000 then
		CustomAbilities:QuickAttachParticle("particles/econ/events/nexon_hero_compendium_2014/blink_dagger_end_nexon_hero_cp_2014.vpcf", caster, 3)
		caster:SetAbsOrigin(attacker:GetAbsOrigin() + RandomVector(RandomInt(100, 400)))
		CustomAbilities:QuickAttachParticle("particles/econ/events/nexon_hero_compendium_2014/blink_dagger_end_nexon_hero_cp_2014.vpcf", caster, 3)
		EmitSoundOn("Winterblight.Ozubu.Teleport", caster)
	end
end

function ozubu_projectile_hit(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local particle = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
	local pfx = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
	local radius = 120
	ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 2, radius * 2))
	Timers:CreateTimer(2.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
end

function ozubu_transfer_debuff(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	local modifiers = caster:FindAllModifiers()
	for j = 1, #modifiers, 1 do
		local modifier = modifiers[j]
		local modifierMaker = modifier:GetCaster()
		local duration = modifier:GetDuration()
		local stacks = caster:GetModifierStackCount(modifier:GetName(), modifierMaker)
		if not WallPhysics:DoesTableHaveValue(Filters:GetUnpurgableDebuffNames(), modifier:GetName()) then
			if WallPhysics:DoesTableHaveValue(MAIN_HERO_TABLE, modifierMaker) then
				if duration > 0 then
					caster:RemoveModifierByName(modifier:GetName())
					if IsValidEntity(modifier:GetAbility()) then
						modifier:GetAbility():ApplyDataDrivenModifier(modifierMaker, target, modifier:GetName(), {duration = duration})
						target:SetModifierStackCount(modifier:GetName(), modifierMaker, stacks)
						particle = true
						break
					end
				end
			end
		end
	end

	if particle then
		local pfx = CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_morphling/morphling_morph_agi.vpcf", caster, 1.2)
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_morphling/morphling_morph_str.vpcf", target, 1.2)
	end
end

function winterblight_summon_ability(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.summonCount then
		caster.summonCount = 0
	end
	local loops = 1 + GameState:GetDifficultyFactor()
	local summoned = false
	--print(caster.maxSummons)
	--print("MAX SUMMONS")
	for i = 1, loops, 1 do
		if caster.summonCount < caster.maxSummons then
			summoned = true
			local spider = nil
			if caster:GetUnitName() == "descent_of_winterblight_ozubu" then
				spider = CreateUnitByName("ozubu_spiderling", caster:GetAbsOrigin() + RandomVector(RandomInt(100, 260)), false, nil, nil, caster:GetTeamNumber())
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_broodmother/broodmother_spiderlings_spawn_b_lv.vpcf", spider, 2)
				Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, spider, "modifier_sea_fortress_ai", {})
				if GameState:GetDifficultyFactor() == 3 then
					spider.reduc = 0.1
				end
				Winterblight:SetCavernUnit(spider, spider:GetAbsOrigin(), false, false, 0)
			end
			Events:CreateLightningBeamWithParticle(caster:GetAbsOrigin() + Vector(0, 0, 80), spider:GetAbsOrigin(), "particles/units/heroes/hero_wisp/tether_green.vpcf", 0.9)
			spider.origCaster = caster
			spider.boss_level = caster.boss_level
			caster.summonCount = caster.summonCount + 1
			spider:AddAbility("seafortress_enemy_summon"):SetLevel(1)
			StartAnimation(spider, {duration = 0.5, activity = ACT_DOTA_DISABLED, rate = 1.1})
		end
	end
	if summoned then
		EmitSoundOn("Ozubu.Summon.VO", caster)
		StartAnimation(caster, {duration = 0.9, activity = ACT_DOTA_CAST_ABILITY_4, rate = 1.0})
		if caster:GetUnitName() == "descent_of_winterblight_ozubu" then
			Timers:CreateTimer(0.2, function()
				EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.Ozubu.Summon.Spiderling", caster)
			end)
		end
	end
end

function winterblight_boss_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.lock then
		return false
	end
	if caster:GetHealth() < 1000 then
		caster.lock = true
		caster.aggro = false
		caster.soundInterval = 0
		caster.rewardMult = 0
		caster.skullRings = 0
		local bossName = "ozubu"
		if caster:GetUnitName() == "descent_of_winterblight_aertega" then
			bossName = "aertega"
		elseif caster:GetUnitName() == "descent_of_winterblight_torturok" then
			bossName = "torturok"
		elseif caster:GetUnitName() == "descent_of_winterblight_ozubu" then
			EmitSoundOn("Ozubu.Death", caster)
		elseif caster:GetUnitName() == "winterblight_cavern_gigarraun" then
			bossName = "gigarraun"
			EmitSoundOn("Winterblight.Gigarraun.Death1", caster)
		end
		Dungeons.itemLevel = math.max(Dungeons.itemLevel, 150)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_boss_dying", {})
		-- local url = ROSHPIT_URL.."/champions/winterblight_update?"
		-- url = url.."boss="..bossName
		-- url = url.."&key1="..GetDedicatedServerKeyV2(SaveLoad.KeyVersion)
		-- url = url.."&mapname="..GetMapName()
		-- CreateHTTPRequestScriptVM("POST", url):Send(function(result)
		-- 	if result.StatusCode == 200 then
		-- 		local resultTable = JSON:decode(result.Body)
		-- 		--DeepPrintTable(resultTable)
		-- 		caster.rewardMult = 1
		-- 		caster.rewardsGranted = 0
		-- 		if bossName == "ozubu" then
		-- 			Events.OzubuSlain = true
		-- 			if resultTable.ozubu_discovered == 1 then
		-- 				caster.rewardMult = 4
		-- 			elseif resultTable.ozubu_discovered < resultTable.torturok_discovered and resultTable.ozubu_discovered < resultTable.aertega_discovered then
		-- 				caster.rewardMult = 2
		-- 			end
		-- 		elseif bossName == "torturok" then
		-- 			Events.TorturokSlain = true
		-- 			if resultTable.torturok_discovered == 1 then
		-- 				caster.rewardMult = 4
		-- 			elseif resultTable.torturok_discovered < resultTable.ozubu_discovered and resultTable.torturok_discovered < resultTable.aertega_discovered then
		-- 				caster.rewardMult = 2
		-- 			end
		-- 		elseif bossName == "aertega" then
		-- 			Events.AertegaSlain = true
		-- 			if resultTable.aertega_discovered == 1 then
		-- 				caster.rewardMult = 4
		-- 			elseif resultTable.aertega_discovered < resultTable.ozubu_discovered and resultTable.aertega_discovered < resultTable.torturok_discovered then
		-- 				caster.rewardMult = 2
		-- 			end
		-- 		end
		-- 		if GameState:GetDifficultyFactor() == 2 then
		-- 			caster.rewardMult = caster.rewardMult / 2
		-- 		end
		-- 		local max = 58 - GameState:GetPlayerPremiumStatusCount() * 2 - 15 * (caster.rewardMult - 1)
		-- 		local luck = RandomInt(1, max)
		-- 		if luck <= 1 then
		-- 			RPCItems:RollVenomortArcana2(caster:GetAbsOrigin())
		-- 		end
		-- 	end
		-- end)
	end
end

function winterblight_boss_dying_particle(event)
	local caster = event.caster
	CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/boss_dying_tgt.vpcf", caster:GetAbsOrigin() + Vector(0, 0, 250), 3)
	if caster.soundInterval % 3 == 0 then
		EmitSoundOn("Winterblight.BossDying", caster)
	end
	caster.soundInterval = caster.soundInterval + 1
	if caster.deathLock then
		return false
	end
	-- if caster:GetUnitName() == "descent_of_winterblight_aertega" then
	-- 	if caster.rewardsGranted < 11 * caster.rewardMult then
	-- 		if caster.rewardMult > 0 then
	-- 			caster.rewardsGranted = caster.rewardsGranted + 1
	-- 			for i = 1, caster.rewardMult, 1 do
	-- 				RPCItems:RollItemtype(400, caster:GetAbsOrigin(), 5, 300)
	-- 			end
	-- 		end
	-- 	else
	-- 		caster.deathLock = true
	-- 		winterblight_boss_final_death_animation(caster)
	-- 	end
	-- elseif caster:GetUnitName() == "descent_of_winterblight_torturok" then
	-- 	if caster.rewardsGranted < 1 then
	-- 		if caster.rewardMult > 0 then
	-- 			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Torturok.Death", caster)
	-- 			-- caster.rewardsGranted = 1
	-- 			-- Events:MithrilReward(caster:GetAbsOrigin(), 12000 * caster.rewardMult)
	-- 			Timers:CreateTimer(8, function()
	-- 				caster.deathLock = true
	-- 				winterblight_boss_final_death_animation(caster)
	-- 			end)
	-- 		end
	-- 	end
	-- elseif caster:GetUnitName() == "descent_of_winterblight_ozubu" then
	-- 	if caster.rewardsGranted < 5 then
	-- 		if caster.rewardMult > 0 then
	-- 			caster.rewardsGranted = caster.rewardsGranted + 1
	-- 			Glyphs:DropArcaneCrystals(caster:GetAbsOrigin(), 11 * caster.rewardMult)
	-- 		end
	-- 	else
	-- 		caster.deathLock = true
	-- 		winterblight_boss_final_death_animation(caster)
	-- 	end
	-- end
	-- if caster.rewardMult > 0 then
	-- 	local skullReward = math.ceil(GameState:GetPlayerPremiumStatusCount() / 3) + 1
	-- 	if caster.skullRings < skullReward * caster.rewardMult then
	-- 		caster.skullRings = caster.skullRings + 1
	-- 		RPCItems:RollWinterblightSkullRing(caster:GetAbsOrigin())
	-- 	end
	-- end
	StartAnimation(caster, {duration = 3.4, activity = ACT_DOTA_FLAIL, rate = 0.4})
	caster.deathLock = true
	Timers:CreateTimer(3.5, function()
		winterblight_boss_final_death_animation(caster)		
	end)
end

function winterblight_boss_final_death_animation(caster)
	print("ANIMATION")
	Winterblight.CavernData.Chambers[caster.boss_chamber]["boss_status"] = 2
	Winterblight.CavernData.Chambers[caster.boss_chamber]["boss_level_defeated"] = caster.boss_level
	EndAnimation(caster)
	StartAnimation(caster, {duration = 1.9, activity = ACT_DOTA_DIE, rate = 1.9})
	Events:smoothSizeChange(caster, caster:GetModelScale(), 0.2, 60)
	for i = 1, 60, 1 do
		Timers:CreateTimer(0.03*i, function()
			caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, 10))
		end)
	end
	local gigarraun_death = false
	if caster:GetUnitName() == "winterblight_cavern_gigarraun" then
		gigarraun_death = true
	end
	Timers:CreateTimer(1.9, function()
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.BossOut", caster)
		local pfx = ParticleManager:CreateParticle("particles/roshpit/seafortress/alt_big_dust.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 5, Vector(0.4, 0.6, 0.9))
		ParticleManager:SetParticleControl(pfx, 2, Vector(0.6, 0.6, 0.6))

		local pfx2 = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx2, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx2, 1, Vector(600, 2, 2))
		Timers:CreateTimer(10, function()
			ParticleManager:DestroyParticle(pfx, false)
			ParticleManager:ReleaseParticleIndex(pfx)
			ParticleManager:DestroyParticle(pfx2, false)
			ParticleManager:ReleaseParticleIndex(pfx2)
		end)
		local position = caster:GetAbsOrigin()
		ScreenShake(caster:GetAbsOrigin(), 800, 1.0, 1.0, 9000, 0, true)
		UTIL_Remove(caster)
		if gigarraun_death then
			Timers:CreateTimer(1, function()
				EmitSoundOnLocationWithCaster(position, "Winterblight.Gigarraun.Death", Events.GameMaster)
			end)
		end
	end)
end
