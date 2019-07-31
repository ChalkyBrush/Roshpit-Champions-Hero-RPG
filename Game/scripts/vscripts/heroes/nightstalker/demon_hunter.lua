function demon_hunter_start(event)
	local caster = event.caster
	local ability = event.ability
	local healthPercent = caster:GetHealth() / caster:GetMaxHealth()
	-- caster:SetModel("models/heroes/nightstalker/nightstalker_night.vmdl")
	-- caster:SetOriginalModel("models/heroes/nightstalker/nightstalker_night.vmdl")
	EmitSoundOn("Chernobog.DemonHunterStart", caster)
	CustomAbilities:QuickAttachParticle("particles/roshpit/chernobog/demon_hunter.vpcf", caster, 4)
	if not caster:HasModifier("modifier_chernobog_demon_form") then
		StartAnimation(caster, {duration = 0.9, activity = ACT_DOTA_NIGHTSTALKER_TRANSITION, rate = 1})
	else
		StartAnimation(caster, {duration = 0.9, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1})
	end
	if caster.w2_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_demon_hunter_w_2_inner_beast_active", {})
		caster:SetModifierStackCount("modifier_demon_hunter_w_2_inner_beast_active", caster, caster.w2_level)

		if not caster:HasModifier("modifier_chernobog_glyph_5_a") then
			caster:RemoveModifierByName("modifier_demon_hunter_w_2_inner_beast_inactive")
		end
	end
	if caster.w4_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_chernobog_rune_w_4_active", {})
		caster:SetModifierStackCount("modifier_chernobog_rune_w_4_active", caster, caster.w4_level)

		if not caster:HasModifier("modifier_chernobog_glyph_5_a") then
			caster:RemoveModifierByName("modifier_chernobog_rune_w_4_inactive")
		end
	end
	Timers:CreateTimer(0.03, function()
		caster:SetHealth(caster:GetMaxHealth() * healthPercent)
	end)
	caster:SetRangedProjectileName("particles/units/heroes/hero_nevermore/nevermore_base_attack.vpcf")
	Filters:CastSkillArguments(2, caster)
end

function demon_hunter_end(event)
	local caster = event.caster
	local ability = event.ability
	local healthPercent = caster:GetHealth() / caster:GetMaxHealth()
	-- caster:SetModel("models/heroes/nightstalker/nightstalker.vmdl")
	-- caster:SetOriginalModel("models/heroes/nightstalker/nightstalker.vmdl")
	if caster.w2_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_demon_hunter_w_2_inner_beast_inactive", {})
		caster:SetModifierStackCount("modifier_demon_hunter_w_2_inner_beast_inactive", caster, caster.w2_level)

		if not caster:HasModifier("modifier_chernobog_glyph_5_a") then
			caster:RemoveModifierByName("modifier_demon_hunter_w_2_inner_beast_active")
		end

	end
	if caster.w4_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_chernobog_rune_w_4_inactive", {})
		caster:SetModifierStackCount("modifier_chernobog_rune_w_4_inactive", caster, caster.w4_level)

		if not caster:HasModifier("modifier_chernobog_glyph_5_a") then
			caster:RemoveModifierByName("modifier_chernobog_rune_w_4_active")
		end
	end
	if not caster:HasModifier("modifier_chernobog_demon_form") then
		StartAnimation(caster, {duration = 0.3, activity = ACT_DOTA_SPAWN, rate = 1.5})
	else
		StartAnimation(caster, {duration = 0.3, activity = ACT_DOTA_ATTACK, rate = 1.5})
	end
	caster:SetRangedProjectileName("particles/roshpit/chernobog/demon_form_attack.vpcf")
	EmitSoundOn("Chernobog.Untoggle", caster)
	CustomAbilities:QuickAttachParticle("particles/roshpit/chernobog/demon_hunter.vpcf", caster, 4)
	Timers:CreateTimer(0.03, function()
		caster:SetHealth(caster:GetMaxHealth() * healthPercent)
	end)
end

function demon_hunter_attack(event)
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	local mana_drain_per_attack = event.mana_drain_per_attack
	attacker:ReduceMana(mana_drain_per_attack)
	local magic_damage_bonus = event.magic_damage_bonus
	local damage_dealt = event.damage_dealt
	local demonHunterDamage = damage_dealt * (magic_damage_bonus / 100)
	local healthdrain = (event.health_cost_percent / 100) * attacker:GetMaxHealth()
	local newHealth = math.max(attacker:GetHealth() - healthdrain, 1)
	attacker:SetHealth(newHealth)

	CustomAbilities:QuickAttachParticle("particles/chernobog/demon_hunter_timedialate.vpcf", target, 2)
	CustomAbilities:ChernobogDemonHunterManaReduced(attacker)
	local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, CHERNOBOG_W_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		Damage:Apply({
			attacker = attacker,
			victim = enemy,
			source = ability,
			sourceType = BASE_ABILITY_W,
			damage = demonHunterDamage,
			damageType = DAMAGE_TYPE_MAGICAL,
			elements = {
				RPC_ELEMENT_DEMON,
			},
		})
	end
end

function demon_hunter_a_b_attack(event)
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	local caster = attacker
	local mana_drain_per_attack = event.mana_drain_per_attack
	if caster.w1_level > 0 then
		if attacker:HasModifier("modifier_demon_hunter") or attacker:HasModifier("modifier_chernobog_glyph_5_a") then
			CustomAbilities:QuickAttachParticle("particles/chernobog/chernobog_a_b_timedialate.vpcf", target, 2)
			local extraDamage = caster.w1_level * CHERNOBOG_W1_DMG_PER_MISSING_MP * (caster:GetMaxMana() - caster:GetMana())
			local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, CHERNOBOG_W_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			for _,enemy in pairs(enemies) do
				Damage:Apply({
					attacker = attacker,
					victim = enemy,
					source = ability,
					sourceType = BASE_ABILITY_W,
					damage = extraDamage,
					damageType = DAMAGE_TYPE_MAGICAL,
					elements = {
						RPC_ELEMENT_DEMON,
					},
				})
			end
		end
		if not attacker:HasModifier("modifier_demon_hunter") or attacker:HasModifier("modifier_chernobog_glyph_5_a") then
			CustomAbilities:QuickAttachParticle("particles/chernobog/chernobog_a_b_timedialate.vpcf", attacker, 2)
			Filters:ApplyHeal(attacker, attacker, CHERNOBOG_W1_HEAL * caster.w1_level, true, false)
		end
	end
	if caster.w3_level > 0 then
		if ability.fervorTarget then
			if IsValidEntity(ability.fervorTarget) then
				if target:GetEntityIndex() == ability.fervorTarget:GetEntityIndex() then
				else
					local stackCount = caster:GetModifierStackCount("modifier_chernobog_rune_w_3_fervor_self_visible", caster)
					stackCount = stackCount * (1 - CHERNOBOG_W3_STACK_LOSE_PCT/100)
					caster:SetModifierStackCount("modifier_chernobog_rune_w_3_fervor_self_visible", caster, stackCount)
					caster:SetModifierStackCount("modifier_chernobog_rune_w_3_fervor_self_invisible", caster, stackCount * caster.w3_level)
				end
			end
		end
		ability.fervorTarget = target

		local stackGain = 1
		local fervorSelfDuration = Filters:GetAdjustedBuffDuration(caster, 9, false)
		if attacker:HasModifier("modifier_demon_hunter") or attacker:HasModifier("modifier_chernobog_glyph_5_a") then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_chernobog_rune_w_3_fervor_self_visible", {duration = fervorSelfDuration})
			local stackCount = caster:GetModifierStackCount("modifier_chernobog_rune_w_3_fervor_self_visible", caster) + stackGain
			caster:SetModifierStackCount("modifier_chernobog_rune_w_3_fervor_self_visible", caster, stackCount)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_chernobog_rune_w_3_fervor_self_invisible", {duration = fervorSelfDuration})
			caster:SetModifierStackCount("modifier_chernobog_rune_w_3_fervor_self_invisible", caster, stackCount * caster.w3_level)
		end
		if not attacker:HasModifier("modifier_demon_hunter") or attacker:HasModifier("modifier_chernobog_glyph_5_a") then
			local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, CHERNOBOG_W3_ARMOR_REDUCE_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			for _,enemy in pairs(enemies) do
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_chernobog_rune_w_3_fervor_enemy_visible", {duration = 90})
				local stackCount = enemy:GetModifierStackCount("modifier_chernobog_rune_w_3_fervor_enemy_visible", caster) + stackGain
				enemy:SetModifierStackCount("modifier_chernobog_rune_w_3_fervor_enemy_visible", caster, stackCount)
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_chernobog_rune_w_3_fervor_enemy_invisible", {duration = 90})
				enemy:SetModifierStackCount("modifier_chernobog_rune_w_3_fervor_enemy_invisible", caster, stackCount * caster.w3_level)
			end
		end
	end
end

function chernobog_always_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster:IsAlive() then
		if caster:GetTimeUntilRespawn() == 0 then
			caster:SetHealth(10)
			caster:ForceKill(true)
		end
	end
end
