require('heroes/zuus/auriun_constants')

function channel_succeed(event)
	local caster = event.caster
	local ability = event.ability
	StartAnimation(caster, {duration = 0.8, activity = ACT_DOTA_CAST_ABILITY_4, rate = 1})
	local allAllies = CustomAbilities:GetAllAlliedHeroes(caster)
	local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, event.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
	local r_4_level = caster:GetRuneValue("r", 4)
	local ultEffectDuration = Filters:GetAdjustedBuffDuration(caster, 3.1, false)
	if not caster:HasModifier("modifier_auriun_immortal_weapon_4") then
		for i = 1, #allAllies, 1 do
			if not allAllies[i]:IsAlive() then
				allAllies[i].revive = true
				local rezPosition = allAllies[i]:GetAbsOrigin()
				allAllies[i]:RespawnHero(false, false)
				allAllies[i]:SetAbsOrigin(rezPosition)

				allAllies[i]:SetHealth(allAllies[i]:GetMaxHealth() * 0.4)
				ability:ApplyDataDrivenModifier(caster, allAllies[i], "modifier_auriun_ult_effect", {duration = ultEffectDuration})
				if r_4_level > 0 then
					local shieldStacks = Runes:Procs(r_4_level, AURIUN_R4_SHIELD_CHANCE, 1)
					if shieldStacks > 0 then
						local shieldAbility = nil
						if caster:HasAbility("heavens_shield") then
							shieldAbility = caster:FindAbilityByName("heavens_shield")
						elseif caster:HasAbility("auriun_shadow_trap") then
							shieldAbility = caster:FindAbilityByName("auriun_shadow_trap")
						elseif caster:HasAbility("auriun_aoe_shield") then
							shieldAbility = caster:FindAbilityByName("auriun_aoe_shield")
						end
						Auriun_R4_Apply_Shield(caster, shieldAbility, allAllies[i], shieldStacks)
					end
				end
				if caster:HasModifier("modifier_auriun_glyph_1_1") then
					local glyph_duration = Filters:GetAdjustedBuffDuration(caster, AURIUN_GLYPH_1_1_DURATION, false)
					ability:ApplyDataDrivenModifier(caster, allAllies[i], "modifier_auriun_glyph_1_1_effect", {duration = glyph_duration})
				end
			end
		end
	end
	if #allies > 0 then
		for _, ally in pairs(allies) do
			if not caster:HasModifier("modifier_auriun_immortal_weapon_4") then
				ability:ApplyDataDrivenModifier(caster, ally, "modifier_auriun_ult_effect", {duration = ultEffectDuration})
			end
			if r_4_level > 0 then
				local shieldStacks = Runes:Procs(r_4_level, AURIUN_R4_SHIELD_CHANCE, 1)
				if shieldStacks > 0 then
					local shieldAbility = nil
					if caster:HasAbility("heavens_shield") then
						shieldAbility = caster:FindAbilityByName("heavens_shield")
					elseif caster:HasAbility("auriun_shadow_trap") then
						shieldAbility = caster:FindAbilityByName("auriun_shadow_trap")
					elseif caster:HasAbility("auriun_aoe_shield") then
						shieldAbility = caster:FindAbilityByName("auriun_aoe_shield")
					end
					Auriun_R4_Apply_Shield(caster, shieldAbility, ally, shieldStacks)
				end
			end
			if caster:HasModifier("modifier_auriun_glyph_1_1") then
				local glyph_duration = Filters:GetAdjustedBuffDuration(caster, AURIUN_GLYPH_1_1_DURATION, false)
				ability:ApplyDataDrivenModifier(caster, ally, "modifier_auriun_glyph_1_1_effect", {duration = glyph_duration})
			end
		end
	end
	Filters:CastSkillArguments(BASE_ABILITY_R, caster)
	if caster:HasModifier("modifier_auriun_immortal_weapon_4") then
		local r_4_level = caster:GetRuneValue("r", 4)
		for i = 1, AURIUN_IMMO_WEAPON_4_BASE_FLARES+r_4_level, 1 do
			Timers:CreateTimer(i*AURIUN_IMMO_WEAPON_4_INTERVAL, function()
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, event.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			local position = enemies[1]:GetAbsOrigin()
			weapon_4_flash_heal(caster, ability, position)
			end)
		end
	end
end

function channel_initialize(event)
	local caster = event.caster
	local ability = event.ability
	ability.initialized = 1
end

function auriun_channel_think(event)
	local caster = event.caster
	local ability = event.ability
	--print("CHANNEL THINK??")
	if ability.initialized == 1 then
		--print("SOUND?")
		ability.initialized = 0
		StartSoundEvent("Auriun.UltFinish", caster)
	end
end

function channel_interrupt(event)
	local caster = event.caster
	StopSoundEvent("Auriun.UltFinish", caster)
end

function passive_think(event)
	local caster = event.caster
	local ability = event.ability
	local r_1_level = caster:GetRuneValue("r", 1)
	if r_1_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_auriun_rune_r_1", {})
		local damageGain = math.floor(caster:GetIntellect() * AURIUN_R1_INT_TO_ATTACK_DMG * r_1_level)
		caster:SetModifierStackCount("modifier_auriun_rune_r_1", ability, damageGain)
	else
		caster:RemoveModifierByName("modifier_auriun_rune_r_1")
	end
end

function Auriun_R4_Apply_Shield(caster, ability, target, shieldStacks)
	local duration = 9
	duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_heavens_shield", {duration = duration})
	local currentStacks = target:GetModifierStackCount("modifier_heavens_shield", caster)
	if shieldStacks > currentStacks then
		target:SetModifierStackCount("modifier_heavens_shield", ability, shieldStacks)
	end

	local particleName = "particles/units/heroes/hero_oracle/white_mage_healheal_core.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	Timers:CreateTimer(0.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)

	local q_4_level = Runes:GetTotalRuneLevel(caster, 4, "q_4", "auriun")
	if ability:GetAbilityName() == "heavens_shield" and q_4_level > 0 then
		local runeAbility = caster.runeUnit4:FindAbilityByName("auriun_rune_q_4")
		runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, target, "modifier_auriun_rune_q_4_effect", {duration = duration})
		target:SetModifierStackCount("modifier_auriun_rune_q_4_effect", runeAbility, q_4_level)
		target.auriun_d_a_ability = runeAbility
	end
end

function auriun_ult_attack_land(event)
	local attacker = event.attacker
	local target = event.target
	local r_1_level = attacker:GetRuneValue("r", 1)
	if r_1_level > 0 then
		local damage = OverflowProtectedGetAverageTrueAttackDamage(attacker) * AURIUN_R1_MODIFIER_DMG_PER_ATTACK * r_1_level
		Filters:TakeArgumentsAndApplyDamage(target, attacker, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_R, RPC_ELEMENT_HOLY, RPC_ELEMENT_NORMAL)
		if attacker:HasModifier("modifier_auriun_glyph_7_1") then
			local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, AURIUN_GLYPH_7_1_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			CustomAbilities:QuickAttachParticle("particles/roshpit/auriun/auriun_glyph_7.vpcf", target, 0.5)
			if #enemies > 0 then
				for _, enemy in pairs(enemies) do
					Filters:TakeArgumentsAndApplyDamage(enemy, attacker, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_R, RPC_ELEMENT_HOLY, RPC_ELEMENT_NORMAL)
				end
			end
		end
	end
end

function weapon_4_flash_heal(caster, ability, position)
	local w_ability = caster:FindAbilityByName("flash_heal")
	local w_1_level = caster:GetRuneValue("w", 1)
	local w_4_level = caster:GetRuneValue("w", 4)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, 240, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	local damage = w_1_level * (AURIUN_W1_DMG + AURIUN_W1_DMG_PER_INT * caster:GetIntellect()) + AURIUN_W1_DMG_BASE
	local particleName = "particles/units/heroes/hero_nevermore/shadow_flare.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
	for _, enemy in pairs(enemies) do
		Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_SHADOW, RPC_ELEMENT_NONE)
		d_b_apply(caster, enemy, w_4_level, caster.runeUnit4:FindAbilityByName("auriun_rune_w_4"))
		ParticleManager:SetParticleControl(particle1, 0, position)
		Timers:CreateTimer(2, function()
			ParticleManager:DestroyParticle(particle1, false)
			ParticleManager:ReleaseParticleIndex(particle1)
		end)
		EmitSoundOnLocationWithCaster(position, "Auriun.ShadowFlare", caster)
	end
end

function d_b_apply(caster, enemy, w_4_level, d_b_ability)
	if w_4_level > 0 then
		d_b_ability:ApplyDataDrivenModifier(caster.runeUnit4, enemy, "modifier_auriun_rune_w_4_effect_visible", {duration = AURIUN_W4_DURATION})
		local current_stacks = enemy:GetModifierStackCount("modifier_auriun_rune_w_4_effect_visible", d_b_ability)
		local new_stacks = math.min(current_stacks + 1, AURIUN_W4_STACKS)
		enemy:SetModifierStackCount("modifier_auriun_rune_w_4_effect_visible", d_b_ability, new_stacks)

		d_b_ability:ApplyDataDrivenModifier(caster.runeUnit4, enemy, "modifier_auriun_rune_w_4_effect_invisible", {duration = AURIUN_W4_DURATION})
		enemy:SetModifierStackCount("modifier_auriun_rune_w_4_effect_invisible", d_b_ability, new_stacks * w_4_level)
	end
	--"modifier_auriun_rune_w_4_effect_visible"
end
