LinkLuaModifier("modifier_ekkan_black_dominion_summon", "modifiers/ekkan/modifier_ekkan_black_dominion_summon", LUA_MODIFIER_MOTION_NONE)

require("/heroes/visage/ekkan_helpers")
require("/heroes/visage/ekkan_constants")

function dominion_bolt_fire(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local info =
	{
		Target = target,
		Source = caster,
		Ability = ability,
		EffectName = "particles/ekkan/black_dominion_projectile_bolt6.vpcf",
		StartPosition = "attach_hitloc",
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 8,
		bProvidesVision = true,
		iVisionRadius = 0,
		iMoveSpeed = 750,
	iVisionTeamNumber = caster:GetTeamNumber()}
	caster.q_1_level = caster:GetRuneValue("q", 1)
	caster.q_2_level = caster:GetRuneValue("q", 2)
	caster.q_4_level = caster:GetRuneValue("q", 4)
	projectile = ProjectileManager:CreateTrackingProjectile(info)
	EmitSoundOn("Ekkan.Dominion.Launch", caster)
	Filters:CastSkillArguments(1, caster)
end

function dominion_bolt_impact(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local debuff_duration = event.duration
	if dominion_allowed_selfcasted_units(target:GetUnitName()) then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_ekkan_dominion_debuff", {duration = debuff_duration})
		ability:ApplyDataDrivenModifier(caster, target, "modifier_ekkan_dominion_overhead_effect", {duration = debuff_duration})
		target:ForceKill(false)
	elseif target:GetTeamNumber() == caster:GetTeamNumber() then
		target:ForceKill(false)
	else
		EmitSoundOn("Ekkan.Dominion.Impact", target)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_ekkan_dominion_debuff", {duration = debuff_duration})
		ability:ApplyDataDrivenModifier(caster, target, "modifier_ekkan_dominion_overhead_effect", {duration = debuff_duration})
	end
end

function reindexDominionTable(ability)
	local newTable = {}
	for i = 1, #ability.dominionTable, 1 do
		if IsValidEntity(ability.dominionTable[i]) then
			if ability.dominionTable[i]:IsAlive() then
				table.insert(newTable, ability.dominionTable[i])
			end
		end
	end
	ability.dominionTable = newTable
end

function dominion_debuff_death(event)
	local unit = event.unit
	local caster = event.caster
	local ability = event.ability
	if not ability.dominionTable then
		ability.dominionTable = {}
	end
	if unit.dominion then
		local fv = unit:GetForwardVector()
		local summonPosition = unit:GetAbsOrigin()
		unit:SetAbsOrigin(summonPosition - Vector(0, 0, 800))
		local summon = CreateUnitByName(unit:GetUnitName(), summonPosition, false, nil, nil, caster:GetTeamNumber())
		Enemies:InitializeEnemy(summon)
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_visage/visage_stone_form.vpcf", summon, 3)
		ability:ApplyDataDrivenModifier(caster, summon, "modifier_ekkan_dominion_unit", {})
		summon:SetAcquisitionRange(1600)
		summon:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
		summon:SetForwardVector(fv)
		local hp = unit:GetMaxHealth()
		local armor = unit:GetPhysicalArmorBaseValue()
		local movespeed = unit:GetBaseMoveSpeed()
		local attackDamage = unit:GetAttackDamage()
		summon:SetMaxHealth(hp)
		summon:SetHealth(hp)
		summon:SetBaseMaxHealth(hp)

		summon:SetPhysicalArmorBaseValue(armor)
		summon:SetBaseMoveSpeed(movespeed)
		summon:SetBaseDamageMin(attackDamage)
		summon:SetBaseDamageMax(attackDamage)
		summon.attackDamage = attackDamage
		summon.armor = armor
		summon.aggro = true
		summon.ekkan_unit = true
		summon.ekkan_dominion = true
		summon:SetDayTimeVisionRange(90)
		summon:SetNightTimeVisionRange(90)
		summon.hero = caster
		summon:SetHullRadius(8)
		if caster.q_1_level > 0 then
			summon:AddAbility("black_dominion_lifesteal"):SetLevel(1)
		end
		if caster.q_2_level > 0 then
			--print("ADD CORPSE PICKUP ABILITY")
			summon:AddAbility("black_dominion_corpse_pickup"):SetLevel(1)
		end
		if caster.q_4_level > 0 then
			ability:ApplyDataDrivenModifier(caster, summon, "modifier_black_dominion_d_a_aura", {})
		end

		if not summon:HasAbility("normal_steadfast") then
			summon:AddAbility("normal_steadfast"):SetLevel(GameState:GetDifficultyFactor())
		end
		table.insert(ability.dominionTable, summon)
		local max_summons = event.max_summons
		-- if caster:HasModifier("modifier_ekkan_glyph_5_1") then
		-- max_summons = max_summons + 2
		-- end
		if #ability.dominionTable > max_summons then
			ability.dominionTable[1]:ForceKill(false)
		end
		EmitSoundOn("Ekkan.Dominion.SummonStart", summon)
		reindexDominionTable(ability)
		summon:SetAcquisitionRange(1200)
		summon.targetRadius = 1000
		summon:AddNewModifier(caster, ability, "modifier_ekkan_black_dominion_summon", {})
		summon.minRadius = 0
		summon.targetAbilityCD = 2
		summon.targetFindOrder = FIND_ANY_ORDER
		summon.autoAbilityCD = 2
		summon.owner = caster:GetPlayerOwnerID()
		local q_4_level = 0
		if q_4_level > 0 then
			ability:ApplyDataDrivenModifier(caster, summon, "modifier_ekkan_d_a_alacrity", {})
			summon:SetModifierStackCount("modifier_ekkan_d_a_alacrity", caster, q_4_level)
		end
		if summon.aggroSound then
			EmitSoundOn(summon.aggroSound, summon)
		end
		summon.stance = "aggressive"
		summon:AddAbility("ekkan_creep_aggressive"):SetLevel(1)
		summon:SetOwner(caster)
		for i = 0, 6, 1 do
			local ability = summon:GetAbilityByIndex(i)
			if ability then
				ability:SetLevel(GameState:GetDifficultyFactor())
			end
		end
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_dominion_counter", {})
		caster:SetModifierStackCount("modifier_dominion_counter", caster, #ability.dominionTable)

		if caster:HasModifier("modifier_ekkan_glyph_5_a") and dominion_allowed_selfcasted_units(summon:GetUnitName()) then
			event.attacker = summon
			for i = 1, EKKAN_GLYPH_5_a_STACKS do
				dominion_unit_kill(event)
				if event.unit.dominionLock then
					event.unit.dominionLock = false
				end
			end
		end
	end
end

function dominionUnitDie(event)
	local unit = event.unit
	local caster = event.caster
	local ability = event.ability
	reindexDominionTable(ability)
	if #ability.dominionTable > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_dominion_counter", {})
		caster:SetModifierStackCount("modifier_dominion_counter", caster, #ability.dominionTable)
	else
		caster:RemoveModifierByName("modifier_dominion_counter")
	end
end

function dominion_debuff_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local burnPercent = event.burn_damage / 100
	local damage = OverflowProtectedGetAverageTrueAttackDamage(target) * burnPercent
	Filters:ApplyDotDamage(caster, ability, target, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_DEMON)
end

function dominion_unit_think(event)
	local caster = event.caster
	local target = event.target
	if caster:GetEntityIndex() == target:GetEntityIndex() then
		caster = target.hero
	end
	if target:IsAlive() then
		local leashDistance = 2000
		local distanceModification = 0
		if caster:HasModifier("modifier_ekkan_glyph_5_a") then
			distanceModification = EKKAN_GLYPH_5_A_LEASH_RANGE_INCREASE
		end
		leashDistance = leashDistance + distanceModification
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), target:GetAbsOrigin())
		if distance > leashDistance then
			FindClearSpaceForUnit(target, caster:GetAbsOrigin() + RandomVector(180), false)
			Timers:CreateTimer(0.1, function()
				CustomAbilities:QuickAttachParticle("particles/roshpit/ekkan/unit_teleport_loadout.vpcf", target, 3)
			end)
			return false
		end
		if target.stance == "passive" then
			return false
		elseif target.stance == "follow" then
			target:MoveToPosition(caster:GetAbsOrigin() + RandomVector(180))
			return false
		else
			if distance > 800 + distanceModification then
				local enemies = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, 600 + distanceModification, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
				if #enemies == 0 then
					target:MoveToPosition(caster:GetAbsOrigin() + RandomVector(180))
				end
			end
			if target:HasAbility("ekkan_mage_blast") then
				local enemies = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, 750, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false)
				if #enemies > 0 then
					local castPoint = enemies[1]:GetAbsOrigin()
					local castAbility = target:FindAbilityByName("ekkan_mage_blast")
					if castAbility:IsFullyCastable() then
						local newOrder = {
							UnitIndex = target:entindex(),
							OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
							AbilityIndex = castAbility:entindex(),
							Position = castPoint
						}

						ExecuteOrderFromTable(newOrder)
					end
				end
			end
			if target:HasAbility("ekkan_familiar_stoneform") then
				if target:GetHealth() <= target:GetMaxHealth() * 0.7 then
					local enemies = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false)
					if #enemies > 0 then
						target:MoveToPosition(enemies[1]:GetAbsOrigin())
						Timers:CreateTimer(0.8, function()
							local castAbility = target:FindAbilityByName("ekkan_familiar_stoneform")
							if castAbility:IsFullyCastable() then
								local newOrder = {
									UnitIndex = target:entindex(),
									OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
									AbilityIndex = castAbility:entindex(),
								}

								ExecuteOrderFromTable(newOrder)
							end
						end)
					end
				end
			end
		end
	end
end

function dominion_unit_kill(event)
	local caster = event.caster
	local unit = event.unit
	local attacker = event.ability.dominionTable[1]
	if not IsValidEntity(attacker) then
		return false
	end
	local ability = event.ability
	if not unit.dominionLock then
		unit.dominionLock = true
		local q_3_level = caster:GetRuneValue("q", 3)
		if unit:GetDeathXP() > 10 then
			if q_3_level > 0 then
				attacker.armor = attacker.armor + q_3_level * EKKAN_ARCANA_Q3_ARMOR
				local damageGainMult = EKKAN_ARCANA_Q3_BASE_ATTACK_DAMAGE
				attacker.attackDamage = attacker.attackDamage + q_3_level * damageGainMult
				attacker:SetPhysicalArmorBaseValue(attacker.armor)
				attacker:SetBaseDamageMin(attacker.attackDamage)
				attacker:SetBaseDamageMax(attacker.attackDamage)
				EmitSoundOn("Ekkan.DarkJourney", attacker)
				CustomAbilities:QuickAttachParticle("particles/roshpit/ekkan_super_charge_buff_circle_flash.vpcf", attacker, 2)
				local beamPFX = ParticleManager:CreateParticle("particles/roshpit/ekkan/cast_beams_beams.vpcf", PATTACH_CUSTOMORIGIN, attacker)
				ParticleManager:SetParticleControl(beamPFX, 0, unit:GetAbsOrigin())
				ParticleManager:SetParticleControl(beamPFX, 1, attacker:GetAbsOrigin())
				Timers:CreateTimer(3, function()
					ParticleManager:DestroyParticle(beamPFX, false)
					ParticleManager:ReleaseParticleIndex(beamPFX)
				end)
				ability:ApplyDataDrivenModifier(caster, attacker, "modifier_ekkan_dominion_stacks_black", {})
				local newStacks = attacker:GetModifierStackCount("modifier_ekkan_dominion_stacks_black", caster) + 1
				attacker:SetModifierStackCount("modifier_ekkan_dominion_stacks_black", caster, newStacks)
			end
		end
	end
end

function dominion_zombie_strike_attack(event)
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	local luck = RandomInt(1, 10)
	if luck == 1 then
		ability.attack_damage = event.attack_damage
		EmitSoundOn("Ekkan.ZombieStrike", attacker)
		local fv = ((target:GetAbsOrigin() - attacker:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
		local distance = WallPhysics:GetDistance2d(target:GetAbsOrigin(), attacker:GetAbsOrigin())
		local speed = distance * 2
		local info =
		{
			Ability = ability,
			EffectName = "particles/units/heroes/hero_vengeful/vengeful_wave_of_terror.vpcf",
			vSpawnOrigin = attacker:GetAbsOrigin(),
			fDistance = distance + 120,
			fStartRadius = 210,
			fEndRadius = 210,
			Source = attacker,
			StartPosition = "attach_origin",
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			iVisionRadius = 500,
			fExpireTime = GameRules:GetGameTime() + 5.0,
			bDeleteOnHit = false,
			vVelocity = fv * speed,
			bProvidesVision = true,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
	end
end

function dominion_zombie_strike_hit(event)
	local caster = event.caster.hero
	local target = event.target
	local ability = event.ability
	local damage = caster.q_1_level * EKKAN_Q1_DAMAGE * ability.attack_damage
	ability:ApplyDataDrivenModifier(event.caster, target, "modifier_hit_by_zombie_strike", {duration = 0.3})
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_Q, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_NONE)
end

function zombie_strike_enemy_die(event)
	local eventTable = {}
	eventTable.unit = event.unit
	eventTable.attacker = event.caster
	eventTable.caster = event.caster.hero
	eventTable.ability = event.caster.hero:FindAbilityByName("ekkan_dominion")
	dominion_unit_kill(eventTable)
end

function black_dominion_lifesteal_think(event)
	local caster = event.caster
	local ability = event.ability
	local origCaster = caster.hero
	local target = event.target
	local q_1_level = origCaster:GetRuneValue("q", 1)
	if q_1_level == 0 then
		return
	end
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * EKKAN_ARCANA_Q1_DAMAGE * q_1_level
	Filters:TakeArgumentsAndApplyDamage(target, origCaster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_Q, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_NONE)
	local heal = math.min(damage * 0.1, caster:GetMaxHealth() - caster:GetHealth())
	if heal > 0 then
		Filters:ApplyHeal(origCaster, caster, heal, true)
	end
end

function corpse_pickup_aura_start(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	if target:GetUnitName() == "ekkan_corpse" then
		if not caster.immortalSouls then
			caster.immortalSouls = 0
		end
		if caster.immortalSouls < 6 then
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Ekkan.CorpsePickup", caster)
			caster.immortalSouls = caster.immortalSouls + 1
			ability:ApplyDataDrivenModifier(event.caster, caster, "modifier_corpse_picked_up_visible", {duration = 10})
			ability:ApplyDataDrivenModifier(event.caster, caster, "modifier_corpse_picked_up_invisible", {duration = 10})
			caster:SetModifierStackCount("modifier_corpse_picked_up_visible", caster, caster.immortalSouls)
			caster:SetModifierStackCount("modifier_corpse_picked_up_invisible", caster, caster.immortalSouls * caster.hero.q_2_level)
			UTIL_Remove(target)
			if not caster.immortalSoulsPFX then
				caster.immortalSoulsPFX = ParticleManager:CreateParticle("particles/units/heroes/hero_visage/visage_soul_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
				ParticleManager:SetParticleControlEnt(caster.immortalSoulsPFX, 0, caster, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", caster:GetAbsOrigin() + Vector(0, 0, 200), true)
			end
			for i = 1, 6, 1 do
				if caster.immortalSouls >= i then
					ParticleManager:SetParticleControl(caster.immortalSoulsPFX, i, Vector(caster.immortalSouls, caster.immortalSouls, caster.immortalSouls))
				end
			end
		end
	end
end

function dominion_corpse_pickup_end(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local origCaster = caster.hero
	local q_2_level = origCaster:GetRuneValue("q", 2)
	--print(q_2_level)
	if q_2_level == 0 then
		caster.immortalSouls = 0
		dominion_corpse_remove_modifier(caster)
		return
	end
	local startingSouls = caster.immortalSouls * 2
	caster.immortalSouls = 0
	for i = 1, 6, 1 do
		if caster.immortalSouls >= i then
			ParticleManager:SetParticleControl(caster.immortalSoulsPFX, i, Vector(caster.immortalSouls, caster.immortalSouls, caster.immortalSouls))--?
		else
			ParticleManager:SetParticleControl(caster.immortalSoulsPFX, i, Vector(0, 0, 0))
		end
	end
	local particleName = "particles/units/heroes/hero_weaver/weaver_swarm_projectile.vpcf"
	local fv = RandomVector(1)
	EmitSoundOn("Ekkan.ArcanaSwarm", caster)
	for i = 1, startingSouls, 1 do
		local rotatedFV = WallPhysics:rotateVector(fv, 2 * math.pi * i / startingSouls)
		local info =
		{
			Ability = ability,
			EffectName = particleName,
			vSpawnOrigin = caster:GetAbsOrigin() + Vector(0, 0, 50),
			fDistance = 1800,
			fStartRadius = 240,
			fEndRadius = 240,
			Source = caster,
			StartPosition = "attach_attack1",
			bHasFrontalCone = true,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 5.0,
			bDeleteOnHit = false,
			vVelocity = rotatedFV * 550,
			bProvidesVision = true,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
	end
	if caster.immortalSouls == 0 then
		dominion_corpse_remove_modifier(caster)
	end
end

function dominion_corpse_remove_modifier(caster)
	caster:RemoveModifierByName("modifier_corpse_picked_up_visible")
	caster:RemoveModifierByName("modifier_corpse_picked_up_invisible")
	ParticleManager:DestroyParticle(caster.immortalSoulsPFX, true)
	caster.immortalSoulsPFX = false
end

function swarm_hit(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, target, "modifier_swarm_effect", {duration = 12})
	local q_2_level = caster.hero:GetRuneValue("q", 2)
	target:SetModifierStackCount("modifier_swarm_effect", caster, q_2_level)
end

function swarm_poison_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	if IsValidEntity(caster) then
		local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)
		Filters:ApplyDotDamage(caster.hero, ability, target, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_POISON, RPC_ELEMENT_UNDEAD)
	end
end

function aura_starter_start(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local q_4_level = caster:GetRuneValue("q", 4)
	if q_4_level > 0 then
		if target.ekkan_unit or (target:GetEntityIndex() == caster:GetEntityIndex()) then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_black_dominion_d_a_aura_effect", {})
			target:SetModifierStackCount("modifier_black_dominion_d_a_aura_effect", caster, q_4_level)
		end
	end

end

function aura_starter_end(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	target:RemoveModifierByName("modifier_black_dominion_d_a_aura_effect")
end

function black_aura_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local particleName = "particles/units/heroes/hero_slark/slark_dark_pact_pulses.vpcf"
	-- CustomAbilities:QuickAttachParticle(particleName, target, 4)
	local beamPFX = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(beamPFX, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(beamPFX, 1, target:GetAbsOrigin())
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(beamPFX, false)
		ParticleManager:ReleaseParticleIndex(beamPFX)
	end)
	EmitSoundOn("Ekkan.ArcanaShieldPulse", target)
	local allies = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false)
	if #allies > 0 then
		for _, ally in pairs(allies) do
			if ally.ekkan_unit or (ally:GetEntityIndex() == caster:GetEntityIndex()) then
				ability:ApplyDataDrivenModifier(caster, ally, "modifier_black_dominion_shield", {duration = 5})
				ally:SetModifierStackCount("modifier_black_dominion_shield", caster, 2)
			end
		end
	end
end
