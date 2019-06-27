Helper = require('heroes/util/helper')
require('heroes/lanaya/constants')

function channel_initialize(event)
	local caster = event.caster
	StartAnimation(caster, {duration = 2.0, activity = ACT_DOTA_IDLE, rate = 1, translate = "meld"})
end

function channel_succeed(event)
	local caster = event.caster
	local ability = event.ability
	local duration = 20
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_trapper_stealth", {duration = duration})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_invisibility_datadriven", {duration = duration})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_invisible", {duration = duration})
	switchIntoStealth(caster)
end

function channel_interrupt(event)
	local caster = event.caster
	EndAnimation(caster)
end

function ability_cast_in_stealth(event)
	local caster = event.caster
	local ability = event.ability
	local executedAbility = event.event_ability
	if executedAbility:GetAbilityName() == "trapper_backstab" or executedAbility:GetAbilityName() == "trapper_action_leap" or executedAbility:GetAbilityName() == "net_trap" or executedAbility:GetAbilityName() == "smoke_bomb" or executedAbility:GetAbilityName() == "torrent_trap" or executedAbility:GetAbilityName() == "flash_grenade" or executedAbility:GetAbilityName() == "trapper_arcana_lasso" then
		Timers:CreateTimer(0.03, function()
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_trapper_stealth", {duration = duration})
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_invisibility_datadriven", {duration = duration})
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_invisible", {duration = duration})
		end)
	end
end

function stealth_think(event)
	local caster = event.caster
	if not caster:HasModifier("modifier_trapper_vanish") then
		local ability = event.ability
		local position = caster:GetAbsOrigin()
		local radius = 500
		local detectionRadius = 120
		if caster:HasModifier("modifier_trapper_glyph_1_1") then
			detectionRadius = 60
		end
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				if not enemy:HasModifier("modifier_smoke_bomb_effect") and not enemy:HasModifier("modifier_flash_grenade_blind") and not enemy:HasModifier("modifier_lasso_pull") and not enemy:IsStunned() then
					local fv = enemy:GetForwardVector()
					local detectionPoint = enemy:GetAbsOrigin() + fv * detectionRadius
					local stealthDetection = FindUnitsInRadius(enemy:GetTeamNumber(), detectionPoint, nil, detectionRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
					for _, stealthCandidate in pairs(stealthDetection) do
						if stealthCandidate:GetEntityIndex() == caster:GetEntityIndex() then
							caster:RemoveModifierByName("modifier_trapper_stealth")
						end
					end
				end
			end
		end
	end
end

function stealth_break(caster)

	caster:RemoveModifierByName("modifier_invisibility_datadriven")
	caster:RemoveModifierByName("modifier_invisible")
	caster:Stop()
	

	switchOutOfStealth(caster)
end

function switchIntoStealth(caster)
	if caster:IsAlive() then
		--  local net_trap = caster:FindAbilityByName("net_trap")
		-- if not net_trap then
		-- net_trap = caster:AddAbility("net_trap")
		-- end
		-- local torrent_trap = caster:FindAbilityByName("torrent_trap")
		if caster.poison then
			if caster.torrent then
				-- local poison_trap = caster:FindAbilityByName("poison_trap")
				-- torrent_trap:SetLevel(poison_trap:GetLevel())

				-- poison_trap:SetAbilityIndex(0)
				-- torrent_trap:SetAbilityIndex(0)
				-- caster:SwapAbilities("poison_trap", "torrent_trap", false, true)
				CustomAbilities:AddAndOrSwapSkill(caster, "poison_trap", "torrent_trap", 0)
			else
				-- local poison_trap = caster:FindAbilityByName("poison_trap")
				-- net_trap:SetLevel(poison_trap:GetLevel())

				-- poison_trap:SetAbilityIndex(0)
				-- net_trap:SetAbilityIndex(0)
				-- caster:SwapAbilities("poison_trap", "net_trap", false, true)
				CustomAbilities:AddAndOrSwapSkill(caster, "poison_trap", "net_trap", 0)
			end
		else
			if caster.torrent then
				-- local fulminating_trap = caster:FindAbilityByName("fulminating_trap")
				-- torrent_trap:SetLevel(fulminating_trap:GetLevel())

				-- fulminating_trap:SetAbilityIndex(0)
				-- torrent_trap:SetAbilityIndex(0)
				-- caster:SwapAbilities("fulminating_trap", "torrent_trap", false, true)
				CustomAbilities:AddAndOrSwapSkill(caster, "fulminating_trap", "torrent_trap", 0)
			else
				-- local fulminating_trap = caster:FindAbilityByName("fulminating_trap")
				-- net_trap:SetLevel(fulminating_trap:GetLevel())

				-- fulminating_trap:SetAbilityIndex(0)
				-- net_trap:SetAbilityIndex(0)
				-- caster:SwapAbilities("fulminating_trap", "net_trap", false, true)
				CustomAbilities:AddAndOrSwapSkill(caster, "fulminating_trap", "net_trap", 0)
			end
		end

		if caster:HasModifier("modifier_trapper_arcana1") then
			--  local lasso = caster:FindAbilityByName("trapper_arcana_lasso")
			-- if not lasso then
			-- lasso = caster:AddAbility("trapper_arcana_lasso")
			-- end
			-- local venom_whip = caster:FindAbilityByName("trapper_arcana_venom_whip")
			-- lasso:SetLevel(venom_whip:GetLevel())
			-- lasso:SetAbilityIndex(1)
			-- venom_whip:SetAbilityIndex(1)
			-- caster:SwapAbilities("trapper_arcana_venom_whip", "trapper_arcana_lasso", false, true)
			CustomAbilities:AddAndOrSwapSkill(caster, "trapper_arcana_venom_whip", "trapper_arcana_lasso", 1)
		else
			local smoke_bomb = caster:FindAbilityByName("smoke_bomb")
			if not smoke_bomb then
				smoke_bomb = caster:AddAbility("smoke_bomb")
			end
			local flash_grenade = caster:FindAbilityByName("flash_grenade")
			if caster.flash then
				-- local explosive_bomb = caster:FindAbilityByName("explosive_bomb")
				-- flash_grenade:SetLevel(explosive_bomb:GetLevel())
				-- flash_grenade:SetAbilityIndex(1)
				-- explosive_bomb:SetAbilityIndex(1)
				-- caster:SwapAbilities("explosive_bomb", "flash_grenade", false, true)
				CustomAbilities:AddAndOrSwapSkill(caster, "explosive_bomb", "flash_grenade", 1)
			else
				-- local explosive_bomb = caster:FindAbilityByName("explosive_bomb")
				-- smoke_bomb:SetLevel(explosive_bomb:GetLevel())
				-- smoke_bomb:SetAbilityIndex(1)
				-- explosive_bomb:SetAbilityIndex(1)
				-- caster:SwapAbilities("explosive_bomb", "smoke_bomb", false, true)
				CustomAbilities:AddAndOrSwapSkill(caster, "explosive_bomb", "smoke_bomb", 1)
			end
		end

		--  local action_leap = caster:FindAbilityByName("trapper_action_leap")
		-- if not action_leap then
		-- action_leap = caster:AddAbility("trapper_action_leap")
		-- end
		-- local vanish = caster:FindAbilityByName("trapper_vanish")
		-- action_leap:SetLevel(vanish:GetLevel())
		-- action_leap:SetAbilityIndex(2)
		-- vanish:SetAbilityIndex(2)
		-- caster:SwapAbilities("trapper_vanish", "trapper_action_leap", false, true)
		CustomAbilities:AddAndOrSwapSkill(caster, "trapper_vanish", "trapper_action_leap", 2)

		-- local backstab = caster:FindAbilityByName("trapper_backstab")
		-- if not backstab then
		-- backstab = caster:AddAbility("trapper_backstab")
		-- end
		-- local stealth = caster:FindAbilityByName("trapper_stealth")
		-- backstab:SetLevel(stealth:GetLevel())
		-- backstab:SetAbilityIndex(DOTA_R_SLOT)
		-- stealth:SetAbilityIndex(DOTA_R_SLOT)
		-- caster:SwapAbilities("trapper_stealth", "trapper_backstab", false, true)
		CustomAbilities:AddAndOrSwapSkill(caster, "trapper_stealth", "trapper_backstab", DOTA_R_SLOT)

		if caster:HasModifier("modifier_trapper_arcana1") then
			caster.w_4_arcana_level = caster:GetRuneValue("w", 4)
		end
	end
end

function switchOutOfStealth(caster)

	if caster.poison then
		if caster.torrent then
			-- local level = caster:FindAbilityByName("torrent_trap"):GetLevel()
			--  caster:FindAbilityByName("poison_trap"):SetLevel(level)
			--  caster:FindAbilityByName("poison_trap"):SetAbilityIndex(0)
			--  caster:SwapAbilities("poison_trap", "torrent_trap", true, false)
			CustomAbilities:AddAndOrSwapSkill(caster, "torrent_trap", "poison_trap", 0)
		else
			-- local level = caster:FindAbilityByName("net_trap"):GetLevel()
			--  caster:FindAbilityByName("poison_trap"):SetLevel(level)
			--  caster:FindAbilityByName("poison_trap"):SetAbilityIndex(0)
			--  caster:SwapAbilities("poison_trap", "net_trap", true, false)
			CustomAbilities:AddAndOrSwapSkill(caster, "net_trap", "poison_trap", 0)
		end
	else
		if caster.torrent then
			-- local level = caster:FindAbilityByName("torrent_trap"):GetLevel()
			--  caster:FindAbilityByName("fulminating_trap"):SetLevel(level)
			--  caster:FindAbilityByName("fulminating_trap"):SetAbilityIndex(0)
			--  caster:SwapAbilities("fulminating_trap", "torrent_trap", true, false)
			CustomAbilities:AddAndOrSwapSkill(caster, "torrent_trap", "fulminating_trap", 0)
		else
			-- local level = caster:FindAbilityByName("net_trap"):GetLevel()
			--  caster:FindAbilityByName("fulminating_trap"):SetLevel(level)
			--  caster:FindAbilityByName("fulminating_trap"):SetAbilityIndex(0)
			--  caster:SwapAbilities("fulminating_trap", "net_trap", true, false)
			CustomAbilities:AddAndOrSwapSkill(caster, "net_trap", "fulminating_trap", 0)
		end
	end
	if caster:HasModifier("modifier_trapper_arcana1") then
		-- local level = caster:FindAbilityByName("trapper_arcana_lasso"):GetLevel()
		-- local venom_whip = caster:FindAbilityByName("trapper_arcana_venom_whip")
		--  if not venom_whip then
		--  venom_whip = caster:AddAbility("trapper_arcana_venom_whip")
		--  end
		--  caster:FindAbilityByName("trapper_arcana_venom_whip"):SetLevel(level)
		--  caster:FindAbilityByName("trapper_arcana_venom_whip"):SetAbilityIndex(1)
		--  caster:SwapAbilities("trapper_arcana_venom_whip", "trapper_arcana_lasso", true, false)
		CustomAbilities:AddAndOrSwapSkill(caster, "trapper_arcana_lasso", "trapper_arcana_venom_whip", 1)
	else
		if caster.flash then
			-- local level = caster:FindAbilityByName("flash_grenade"):GetLevel()
			--  caster:FindAbilityByName("explosive_bomb"):SetLevel(level)
			--  caster:FindAbilityByName("explosive_bomb"):SetAbilityIndex(1)
			--  caster:SwapAbilities("explosive_bomb", "flash_grenade", true, false)
			CustomAbilities:AddAndOrSwapSkill(caster, "flash_grenade", "explosive_bomb", 1)
		else
			if caster:HasAbility("smoke_bomb") then
				-- local level = caster:FindAbilityByName("smoke_bomb"):GetLevel()
				--  caster:FindAbilityByName("explosive_bomb"):SetLevel(level)
				--  caster:FindAbilityByName("explosive_bomb"):SetAbilityIndex(1)
				--  caster:SwapAbilities("explosive_bomb", "smoke_bomb", true, false)
				CustomAbilities:AddAndOrSwapSkill(caster, "smoke_bomb", "explosive_bomb", 1)
			end
		end
	end

	-- local level = caster:FindAbilityByName("trapper_action_leap"):GetLevel()
	--  caster:FindAbilityByName("trapper_vanish"):SetLevel(level)
	--  caster:FindAbilityByName("trapper_vanish"):SetAbilityIndex(2)
	--  caster:SwapAbilities("trapper_vanish", "trapper_action_leap", true, false)
	CustomAbilities:AddAndOrSwapSkill(caster, "trapper_action_leap", "trapper_vanish", 2)

	-- local level = caster:FindAbilityByName("trapper_backstab"):GetLevel()
	--  caster:FindAbilityByName("trapper_stealth"):SetLevel(level)
	--  caster:FindAbilityByName("trapper_stealth"):SetAbilityIndex(DOTA_R_SLOT)
	--  caster:SwapAbilities("trapper_stealth", "trapper_backstab", true, false)
	CustomAbilities:AddAndOrSwapSkill(caster, "trapper_backstab", "trapper_stealth", DOTA_R_SLOT)
	CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "ability_tree_upgrade", {})

	if caster:HasModifier("modifier_trapper_arcana1") then
		caster.w_4_arcana_level = caster:GetRuneValue("w", 4)
	end
end

function stealth_buff_end(event)
	local caster = event.caster
	stealth_break(caster)
end

function backstab_channel_succeed(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local damageMult = event.damage_mult
	local damage = math.floor(OverflowProtectedGetAverageTrueAttackDamage(caster) * damageMult)
	if caster:HasModifier("modifier_trapper_glyph_4_1") and target.paragon then
		damage = damage * 10
	end
	EmitSoundOn("templar_assassin_temp_pain_03", caster)
	StartAnimation(caster, {duration = 1.2, activity = ACT_DOTA_ATTACK, rate = 0.5})
	Filters:CastSkillArguments(4, caster)
	local moveToPosition = target:GetAbsOrigin() - target:GetForwardVector() * 110
	local casterFV = (target:GetAbsOrigin() * Vector(1, 1, 0) - moveToPosition * Vector(1, 1, 0)):Normalized() * Vector(1, 1, 0)
	--print(casterFV)
	caster:SetForwardVector(casterFV)
	caster:SetAbsOrigin(moveToPosition)
	WallPhysics:Jump(caster, caster:GetForwardVector(), 0, 40, 10, 0.3)
	WallPhysics:Jump(target, target:GetForwardVector(), 0, 40, 10, 0.3)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_backstab_flailing", {duration = 4})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_backstab_jumping", {duration = 0.7})
	local a_d_level = Runes:GetTotalRuneLevel(caster, 1, "r_1", "trapper")
	ability.r_1_damage = math.floor(a_d_level * 0.03 * damage)
	ability.bSound = true
	Timers:CreateTimer(0.5, function()
		EmitSoundOn("Hero_Pudge.Attack", caster)
		WallPhysics:Jump(target, casterFV, 20, 2, 2, 1.2)
		local particleName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
		ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_CUSTOMORIGIN, "follow_origin", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_CUSTOMORIGIN, "follow_origin", target:GetAbsOrigin(), true)
		Timers:CreateTimer(2, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		EmitSoundOn("Trapper.BackstabStrike", target)
		caster:RemoveModifierByName("modifier_trapper_stealth")
		Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_PURE, BASE_ABILITY_R, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
		PopupDamage(target, damage)
		if a_d_level > 0 then
			rune_r_1(caster, ability, target:GetAbsOrigin())
		end
	end)
	local c_d_level = Runes:GetTotalRuneLevel(caster, 3, "r_3", "trapper")
	caster.r_3_level = c_d_level
	if c_d_level > 0 then
		local duration = TRAPPER_R3_DURATION
		duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_trapper_c_d_buff", {duration = duration})
	end
end

function rune_r_1(caster, ability, position)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			a_d_projectile_fire(caster, ability, enemy)
		end
	end
end

function a_d_projectile_fire(caster, ability, target)
	local info =
	{
		Target = target,
		Source = caster,
		Ability = ability,
		EffectName = "particles/units/heroes/hero_templar_assassin/templar_assassin_meld_attack.vpcf",
		StartPosition = "attach_attack1",
		SourceAttachment = "DOTA_PROJECTILE_ATTACHMENT_ATTACK_1",
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = true,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 5,
		bProvidesVision = false,
		iVisionRadius = 0,
		iMoveSpeed = 600,
	}
	projectile = ProjectileManager:CreateTrackingProjectile(info)
end

function trapper_a_d_projectile_strike(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = ability.r_1_damage
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_PURE, BASE_ABILITY_R, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)

	local particleName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_CUSTOMORIGIN, "follow_origin", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_CUSTOMORIGIN, "follow_origin", target:GetAbsOrigin(), true)
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	PopupDamage(target, damage)
	if ability.bSound then
		ability.bSound = false
		EmitSoundOn("Trapper.BackstabStrike", target)
	end
end

function stealth_animation(event)
	-- local caster = event.caster
	-- local ability = event.ability
	-- if not caster:HasModifier("modifier_dont_kneel") then
	-- StartAnimation(caster, {duration=30, activity=ACT_DOTA_IDLE, rate=1, translate="meld"})
	-- ability:ApplyDataDrivenModifier(caster, caster, "modifier_dont_kneel", {duration = 1})
	-- end
end

function stealth_moving_again(event)
	-- local caster = event.caster
	-- EndAnimation(caster)
end

function backstab_target_check(event)
	local caster = event.caster
	local target = event.target
	if caster:GetTeamNumber() == target:GetTeamNumber() then
		--print(target:GetUnitName())
		if target:GetUnitName() == "lanaya_decoy" then
			Timers:CreateTimer(1.6, function()
				target:RemoveModifierByName("modifier_decoy_effect")
			end)
		else
			Timers:CreateTimer(0.1, function()
				caster:RemoveModifierByName("modifier_trapper_stealth")
				caster:RemoveModifierByName("modifier_backstab_channel")
			end)
			Timers:CreateTimer(0.2, function()
				CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "ability_tree_upgrade", {})
			end)
		end
	end
end

function invisible_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster:IsInvisible() then
		return
	end

	local runesCount = Runes:GetTotalRuneLevel(caster, 2, "r_2", "trapper")
	if runesCount > 0 then
		local duration = Filters:GetAdjustedBuffDuration(caster, TRAPPER_R2_DURATION, false)
		local maxStacksCount = TRAPPER_R2_MAX_STACKS_COUNT
		if caster:HasModifier("modifier_trapper_glyph_5_2") then
			maxStacksCount = maxStacksCount + T52_STACKS_COUNT
		end
		Helper.updateStackModifier(caster, caster, ability, 'trapper_rune_r_2', duration, maxStacksCount, runesCount)
	end

	if caster:HasModifier("modifier_trapper_glyph_7_2") then
		local backstab = caster:FindAbilityByName("trapper_backstab")
		if not backstab then
			backstab = caster:AddAbility("trapper_backstab")
		end
		backstab:ApplyDataDrivenModifier(caster, caster, "modifier_trapper_c_d_buff", {duration = 0.6})
	end
	runesCount = Runes:GetTotalRuneLevel(caster, 4, "r_4", "trapper")
	if runesCount > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_trapper_rune_r_4_bonus_agi", {duration = 0.6})
		caster:SetModifierStackCount("modifier_trapper_rune_r_4_bonus_agi", caster, runesCount)
	end
end

function crit_attack_start(event)
	local caster = event.caster
	local ability = event.ability
	local runesCount = Runes:GetTotalRuneLevel(caster, 3, "r_3", "trapper")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_trapper_c_d_crit", {})
	caster:SetModifierStackCount("modifier_trapper_c_d_crit", caster, runesCount)
end
