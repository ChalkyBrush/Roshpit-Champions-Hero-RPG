LinkLuaModifier("modifier_dinath_passive_ms_cap", "modifiers/dinath/modifier_dinath_passive_ms_cap", LUA_MODIFIER_MOTION_NONE)

function spire_toggle_on(event)
	local caster = event.caster
	local ability = event.ability
	StartAnimation(caster, {duration = 1.2, activity = ACT_DOTA_CAST_ABILITY_3, rate = 1.0})
	EmitSoundOn("Dinath.Spire.ToggleVO", caster)
	local flight_stacks = math.max(caster:GetModifierStackCount("modifier_dinath_postflight_zheight", caster) + 50, 96)
	local w_3_level = caster:GetRuneValue("w", 3)
	if w_3_level > 0 then
		local pfx = ParticleManager:CreateParticle("particles/roshpit/dinath/w_inhale.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin() + caster:GetForwardVector() * 300 + Vector(0, 0, flight_stacks + 50))
		ParticleManager:SetParticleControl(pfx, 1, caster:GetForwardVector() *- 300)

		Timers:CreateTimer(1, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	end

	local speedStacks = w_3_level * 8
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_spire_breath_speed_burst", {duration = speedStacks * 0.03})
	caster:SetModifierStackCount("modifier_spire_breath_speed_burst", caster, speedStacks)
	Filters:CastSkillArguments(2, caster)
end

function spire_toggle_off(event)
	local caster = event.caster
	local ability = event.ability
	StartAnimation(caster, {duration = 1.0, activity = ACT_DOTA_CAST_ABILITY_1, rate = 1.2})
	EmitSoundOn("Dinath.Spire.ToggleOffVO", caster)
	local flight_stacks = math.max(caster:GetModifierStackCount("modifier_dinath_postflight_zheight", caster) + 50, 96)
	local w_3_level = caster:GetRuneValue("w", 3)
	if w_3_level > 0 then
		local pfx = ParticleManager:CreateParticle("particles/roshpit/dinath/w_inhale.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin() + caster:GetForwardVector() *- 50 + Vector(0, 0, flight_stacks))
		ParticleManager:SetParticleControl(pfx, 1, caster:GetForwardVector() * 300)
		Timers:CreateTimer(1, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	end
	ability:StartCooldown(1)

	local speedStacks = w_3_level * 8
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_spire_breath_speed_burst", {duration = speedStacks * 0.03})
	caster:SetModifierStackCount("modifier_spire_breath_speed_burst", caster, speedStacks)
	Filters:CastSkillArguments(2, caster)
end

function spire_on_mana_drain(event)
	local caster = event.caster
	local ability = event.ability
	local mana_spend = ability:GetManaCost(-1)
	if caster:GetMana() < mana_spend then
		ability:ToggleAbility()
	end
	caster:ReduceMana(mana_spend)
end

function spire_breath_attack_land(event)
	local attacker = event.attacker
	local target = event.target
	if target.dummy then
		return false
	end
	local damage = OverflowProtectedGetAverageTrueAttackDamage(attacker) * (event.damage_mult / 100)

	if attacker:HasModifier("modifier_dinath_glyph_7_1") then
		local mana_restore = attacker:GetMaxMana() * 0.01
		attacker:GiveMana(mana_restore)
		damage = damage + attacker:GetMana() * 1000
		PopupMana(caster, mana_restore)
	end
	local ability = event.ability
	EmitSoundOn("Dinath.DragonAttack", target)
	Filters:TakeArgumentsAndApplyDamage(target, attacker, damage, DAMAGE_TYPE_PURE, BASE_ABILITY_W, RPC_ELEMENT_DRAGON, RPC_ELEMENT_ICE)
	CustomAbilities:QuickAttachParticle("particles/roshpit/dinath/breath_impact_manaburn_basher_ti_5_gold.vpcf", target, 1)
	if attacker:HasModifier("modifier_dinath_immortal_weapon_2") then
		local weapon = attacker.weapon
		weapon:ApplyDataDrivenModifier(attacker.InventoryUnit, attacker, "modifier_vitali_shield", {duration = 10})
	end
	-- EmitSoundOn("Dinath.BreathImpact", target)
end

function spire_attack_start(event)
	local attacker = event.attacker
	local target = event.target
	local caster = event.caster
	local ability = event.ability

	if caster:HasModifier("modifier_breath_lock") then
		return false
	end
	EmitSoundOn("Dinath.BreathSound", caster)
	local lock_duration = 1 / attacker:GetAttacksPerSecond()
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_breath_lock", {duration = lock_duration})
	local radius = 800
	local w_4_level = caster:GetRuneValue("w", 4)
	radius = radius + w_4_level * 8
	local splits = event.splits
	splits = splits + Runes:Procs(w_4_level, 10, 1)
	local count = 0
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			if enemy.dummy or enemy == target then
			else
				if count < splits then
					count = count + 1
					Filters:PerformAttackSpecial(caster, enemy, true, true, true, false, true, false, false)
				else
					break
				end
			end
		end
	end
end

function spire_breath_speed_burst_think(event)
	local caster = event.caster
	local ability = event.ability
	local stacks = caster:GetModifierStackCount("modifier_spire_breath_speed_burst", caster)
	if stacks > 1 then
		caster:SetModifierStackCount("modifier_spire_breath_speed_burst", caster, stacks - 1)
	else
		caster:RemoveModifierByName("modifier_spire_breath_speed_burst")
	end
end

function spire_passive_think(event)
	local caster = event.caster
	local ability = event.ability
	local w_1_level = caster:GetRuneValue("w", 1)
	if w_1_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_spire_breath_a_b_buff", {})
		caster:SetModifierStackCount("modifier_spire_breath_a_b_buff", caster, w_1_level)
	else
		caster:RemoveModifierByName("modifier_spire_breath_a_b_buff")
	end
	ability.w_3_level = caster:GetRuneValue("w", 3)
	if ability.w_3_level > 0 then
		caster:AddNewModifier(caster, ability, "modifier_dinath_passive_ms_cap", {duration = duration})
	else
		caster:RemoveModifierByName("modifier_dinath_passive_ms_cap")
	end
end
