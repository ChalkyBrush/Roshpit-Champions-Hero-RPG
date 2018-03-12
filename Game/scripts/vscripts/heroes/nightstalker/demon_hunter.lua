function demon_hunter_start(event)
	local caster = event.caster
	local ability = event.ability
	local healthPercent = caster:GetHealth()/caster:GetMaxHealth()
	-- caster:SetModel("models/heroes/nightstalker/nightstalker_night.vmdl")
	-- caster:SetOriginalModel("models/heroes/nightstalker/nightstalker_night.vmdl")
	EmitSoundOn("Chernobog.DemonHunterStart", caster)
	CustomAbilities:QuickAttachParticle("particles/roshpit/chernobog/demon_hunter.vpcf", caster, 4)
	if not caster:HasModifier("modifier_chernobog_demon_form") then
		StartAnimation(caster, {duration=0.9, activity=ACT_DOTA_NIGHTSTALKER_TRANSITION, rate=1})
	else
		StartAnimation(caster, {duration=0.9, activity=ACT_DOTA_CAST_ABILITY_2, rate=1})
	end
	local rune_b_b_level = Runes:GetTotalRuneLevel(caster, 2, "b_b", "chernobog")
	local rune_d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "chernobog")
	if rune_b_b_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_demon_hunter_b_b_inner_beast_active", {})
		caster:SetModifierStackCount("modifier_demon_hunter_b_b_inner_beast_active", caster, rune_b_b_level)

		if not caster:HasModifier("modifier_chernobog_glyph_5_a") then
			caster:RemoveModifierByName("modifier_demon_hunter_b_b_inner_beast_inactive")
		end
	end
	if rune_d_b_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_chernobog_rune_d_b_active", {})
		caster:SetModifierStackCount("modifier_chernobog_rune_d_b_active", caster, rune_d_b_level)

		if not caster:HasModifier("modifier_chernobog_glyph_5_a") then
			caster:RemoveModifierByName("modifier_chernobog_rune_d_b_inactive")
		end
	end
	Timers:CreateTimer(0.03, function()
		caster:SetHealth(caster:GetMaxHealth()*healthPercent)
	end)
	caster:SetRangedProjectileName("particles/units/heroes/hero_nevermore/nevermore_base_attack.vpcf")
	Filters:CastSkillArguments(2, caster)
end

function demon_hunter_end(event)
	local caster = event.caster
	local ability = event.ability
	local healthPercent = caster:GetHealth()/caster:GetMaxHealth()
	-- caster:SetModel("models/heroes/nightstalker/nightstalker.vmdl")
	-- caster:SetOriginalModel("models/heroes/nightstalker/nightstalker.vmdl")
	local rune_b_b_level = Runes:GetTotalRuneLevel(caster, 2, "b_b", "chernobog")
	local rune_d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "chernobog")
	if rune_b_b_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_demon_hunter_b_b_inner_beast_inactive", {})
		caster:SetModifierStackCount("modifier_demon_hunter_b_b_inner_beast_inactive", caster, rune_b_b_level)

		if not caster:HasModifier("modifier_chernobog_glyph_5_a") then
			caster:RemoveModifierByName("modifier_demon_hunter_b_b_inner_beast_active")
		end

	end
	if rune_d_b_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_chernobog_rune_d_b_inactive", {})
		caster:SetModifierStackCount("modifier_chernobog_rune_d_b_inactive", caster, rune_d_b_level)

		if not caster:HasModifier("modifier_chernobog_glyph_5_a") then
			caster:RemoveModifierByName("modifier_chernobog_rune_d_b_active")
		end
	end
	if not caster:HasModifier("modifier_chernobog_demon_form") then
		StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_SPAWN, rate=1.5})
	else
		StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_ATTACK, rate=1.5})
	end
	caster:SetRangedProjectileName("particles/roshpit/chernobog/demon_form_attack.vpcf")
	EmitSoundOn("Chernobog.Untoggle", caster)
	CustomAbilities:QuickAttachParticle("particles/roshpit/chernobog/demon_hunter.vpcf", caster, 4)
	Timers:CreateTimer(0.03, function()
		caster:SetHealth(caster:GetMaxHealth()*healthPercent)
	end)
end

function demon_hunter_attack(event)
	local attacker = event.attacker
	local target = event.target
	local mana_drain_per_attack = event.mana_drain_per_attack
	attacker:ReduceMana(mana_drain_per_attack)
	local magic_damage_bonus = event.magic_damage_bonus
	local damage_dealt = event.damage_dealt
	local demonHunterDamage = damage_dealt*(magic_damage_bonus/100)
	local healthdrain = (event.health_cost_percent/100)*attacker:GetMaxHealth()
	local newHealth = math.max(attacker:GetHealth()-healthdrain, 1)
	attacker:SetHealth(newHealth)
	Filters:TakeArgumentsAndApplyDamage(target, attacker, demonHunterDamage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_DEMON, RPC_ELEMENT_NONE)
	CustomAbilities:QuickAttachParticle("particles/chernobog/demon_hunter_timedialate.vpcf", target, 2)
	CustomAbilities:ChernobogDemonHunterManaReduced(attacker)
end

function demon_hunter_a_b_attack(event)
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	local caster = attacker
	local rune_a_b_level = Runes:GetTotalRuneLevel(attacker, 1, "a_b", "chernobog")
	local rune_c_b_level = Runes:GetTotalRuneLevel(attacker, 3, "c_b", "chernobog")
	local mana_drain_per_attack = event.mana_drain_per_attack
	if rune_a_b_level > 0 then
		if attacker:HasModifier("modifier_demon_hunter") or attacker:HasModifier("modifier_chernobog_glyph_5_a") then
			CustomAbilities:QuickAttachParticle("particles/chernobog/chernobog_a_b_timedialate.vpcf", target, 2)
			local extraDamage = rune_a_b_level*500*mana_drain_per_attack
			print(extraDamage)
			Filters:TakeArgumentsAndApplyDamage(target, attacker, extraDamage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_DEMON, RPC_ELEMENT_NONE)
		end
		if not attacker:HasModifier("modifier_demon_hunter") or attacker:HasModifier("modifier_chernobog_glyph_5_a") then
			CustomAbilities:QuickAttachParticle("particles/chernobog/chernobog_a_b_timedialate.vpcf", attacker, 2)
			attacker:Heal(500*rune_a_b_level, attacker)
		end
	end
	if rune_c_b_level > 0 then
		if ability.fervorTarget then
			if IsValidEntity(ability.fervorTarget) then
				if target:GetEntityIndex() == ability.fervorTarget:GetEntityIndex() then
				else
					attacker:RemoveModifierByName("modifier_chernobog_rune_c_b_fervor_self_visible")
					attacker:RemoveModifierByName("modifier_chernobog_rune_c_b_fervor_self_invisible")
					local existingTarget =ability.fervorTarget
					if IsValidEntity(existingTarget) then
						existingTarget:RemoveModifierByName("modifier_chernobog_rune_c_b_fervor_enemy_visible")
						existingTarget:RemoveModifierByName("modifier_chernobog_rune_c_b_fervor_enemy_invisible")
					end
				end
			end
		end
		ability.fervorTarget = target
		local stackGain = 1
		local fervorSelfDuration = Filters:GetAdjustedBuffDuration(caster, 9, false)
		if attacker:HasModifier("modifier_demon_hunter") or  attacker:HasModifier("modifier_chernobog_glyph_5_a") then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_chernobog_rune_c_b_fervor_self_visible", {duration = fervorSelfDuration})
			local stackCount = caster:GetModifierStackCount("modifier_chernobog_rune_c_b_fervor_self_visible", caster) + stackGain
			caster:SetModifierStackCount("modifier_chernobog_rune_c_b_fervor_self_visible", caster, stackCount)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_chernobog_rune_c_b_fervor_self_invisible", {duration = fervorSelfDuration})
			caster:SetModifierStackCount("modifier_chernobog_rune_c_b_fervor_self_invisible", caster, stackCount*rune_c_b_level)
		end
		if not attacker:HasModifier("modifier_demon_hunter") or  attacker:HasModifier("modifier_chernobog_glyph_5_a") then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_chernobog_rune_c_b_fervor_enemy_visible", {duration = 90})
			local stackCount = target:GetModifierStackCount("modifier_chernobog_rune_c_b_fervor_enemy_visible", caster) + stackGain
			target:SetModifierStackCount("modifier_chernobog_rune_c_b_fervor_enemy_visible", caster, stackCount)
			ability:ApplyDataDrivenModifier(caster, target, "modifier_chernobog_rune_c_b_fervor_enemy_invisible", {duration = 90})
			target:SetModifierStackCount("modifier_chernobog_rune_c_b_fervor_enemy_invisible", caster, stackCount*rune_c_b_level)
		end
	end
end

function chernobog_always_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster:IsAlive() then
		if caster:GetTimeUntilRespawn() == 0 then
			print("KILL!")
			caster:SetHealth(10)
			caster:ForceKill(true)
		end
	end
end