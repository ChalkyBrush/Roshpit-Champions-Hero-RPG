require('heroes/spirit_breaker/duskbringer_1_q')
require('heroes/spirit_breaker/duskbringer_3_e')
require('heroes/spirit_breaker/duskbringer_glyphs')

function seven_visions_channel(event)
	--print('channel function')
	duskbringer_rune_e_1_refresh(event.caster, 4)
	duskbringer_glyph_4_2_refresh(event.caster, 4)
end
function seven_visions_start(event)
	local ability = event.ability
	local attacks = event.attack_count
	local caster = event.caster
	local damage = event.damage
	if caster:HasModifier("modifier_duskbringer_glyph_5_1") then
		attacks = attacks + DUSKBRINGER_GLYPH_5_1_INCR_ATTS
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_seven_visions_striking_glyphed", {duration = (attacks - 1) * 0.3})
	caster:RemoveModifierByName("modifier_duskbringer_rune_r_3")
	seven_visions_strike(caster, caster:GetAbsOrigin(), damage, ability)
	caster:RemoveModifierByName("modifier_terrorize_animation")
	Filters:CastSkillArguments(4, caster)
end

function seven_visions_think(event)
	local ability = event.ability
	local caster = event.caster
	if caster:HasModifier("modifier_terrorize_thinking") or caster:HasModifier("modifier_name_after_terrorize_falling") then
		caster:RemoveModifierByName("modifier_terrorize_thinking")
		caster:RemoveModifierByName("modifier_terrorize_animation")
	end
	seven_visions_strike(caster, caster:GetAbsOrigin(), damage, ability)
end

function seven_visions_strike(caster, position, damage, ability)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	local enemy = enemies[RandomInt(1, #enemies)]
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)
	local r_1_level = caster:GetRuneValue("r", 1)
	local r_2_level = caster:GetRuneValue("r", 2)
	local r_3_level = caster:GetRuneValue("r", 3)
	if #enemies > 0 then
		caster:SetAbsOrigin(enemy:GetAbsOrigin() + RandomVector(120))
		local fv = (enemy:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
		local casterPos = caster:GetAbsOrigin()
		caster:SetForwardVector(fv)
		EmitSoundOn("Hero_Spirit_Breaker.NetherStrike.End", caster)
		StartAnimation(caster, {duration = 0.5, activity = ACT_DOTA_ATTACK, rate = 2.0})
		Timers:CreateTimer(0.2, function()
			if r_2_level > 0 then
				local runeAbility = caster.runeUnit2:FindAbilityByName("duskbringer_rune_r_2")
				local r_2_duration = Filters:GetAdjustedBuffDuration(caster, DUSKBRINGER_R2_BASE_DUR, false)
				runeAbility:ApplyDataDrivenModifier(caster.runeUnit2, enemy, "modifier_duskbringer_rune_r_2_visible", {duration = r_2_duration})
				local r_2_current_stacks_visible = enemy:GetModifierStackCount("modifier_duskbringer_rune_r_2_visible", runeAbility)
				enemy:SetModifierStackCount("modifier_duskbringer_rune_r_2_visible", runeAbility, math.min(r_2_current_stacks_visible + 1, DUSKBRINGER_R2_MAX_STACKS))
				runeAbility:ApplyDataDrivenModifier(caster.runeUnit2, enemy, "modifier_duskbringer_rune_r_2_invisible", {duration = r_2_duration})
				local r_2_current_stacks_invisible = enemy:GetModifierStackCount("modifier_duskbringer_rune_r_2_invisible", runeAbility)
				enemy:SetModifierStackCount("modifier_duskbringer_rune_r_2_invisible", runeAbility, math.min(r_2_current_stacks_invisible + r_2_level, DUSKBRINGER_R2_MAX_STACKS * r_2_level))
			end
			if r_3_level > 0 then
				local runeAbility = caster.runeUnit3:FindAbilityByName("duskbringer_rune_r_3")
				local r_3_duration = Filters:GetAdjustedBuffDuration(caster, DUSKBRINGER_R3_BASE_DUR, false)
				runeAbility:ApplyDataDrivenModifier(caster.runeUnit3, caster, "modifier_duskbringer_rune_r_3", {duration = r_3_duration})
				local r_3_current_stacks = caster:GetModifierStackCount("modifier_duskbringer_rune_r_3", runeAbility)
				caster:SetModifierStackCount("modifier_duskbringer_rune_r_3", runeAbility, r_3_current_stacks + r_3_level)
			end
			caster:PerformAttack(enemy, true, true, true, true, false, false, false)
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_R, RPC_ELEMENT_GHOST, RPC_ELEMENT_NORMAL)
			EmitSoundOn("Hero_Spirit_Breaker.GreaterBash", enemy)
			enemy:AddNewModifier(caster, nil, "modifier_knockback", modifierKnockback)
			local particleName = "particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf"
			EmitSoundOn("Hero_Spirit_Breaker.Attack", caster)
			EmitSoundOn("Hero_Spirit_Breaker.Attack", caster)
			local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, enemy)
			ParticleManager:SetParticleControlEnt(pfx, 0, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			Timers:CreateTimer(0.8, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
			if r_1_level > 0 then
				local particleName = "particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_explosion.vpcf"
				local pfx2 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, enemy)
				ParticleManager:SetParticleControlEnt(pfx2, 0, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
				Timers:CreateTimer(0.8, function()
					ParticleManager:DestroyParticle(pfx2, false)
				end)
				local r_1_enemies = FindUnitsInRadius(caster:GetTeamNumber(), enemy:GetAbsOrigin(), nil, DUSKBRINGER_R1_BASE_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
				local r_1_damage = r_1_level * DUSKBRINGER_R1_DMG_PER_DMG * damage
				for _, r_1_enemy in pairs(r_1_enemies) do
					Filters:TakeArgumentsAndApplyDamage(r_1_enemy, caster, r_1_damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_R, RPC_ELEMENT_GHOST, RPC_ELEMENT_NONE)
				end
			end
		end)
	end
end

function seven_visions_end(event)
	local caster = event.caster
	if caster:HasModifier("modifier_terrorize_thinking") or caster:HasModifier("modifier_name_after_terrorize_falling") then
		return false
	end
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
end
