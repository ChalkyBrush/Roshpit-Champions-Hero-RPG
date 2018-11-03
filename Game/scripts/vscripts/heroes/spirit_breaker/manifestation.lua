require('heroes/spirit_breaker/specter_rush')
require('/heroes/spirit_breaker/constants')

function begin_manifestation(event)
	local caster = event.caster
	local ability = event.ability
    local target = event.target_points[1]
    local casterOrigin = caster:GetAbsOrigin()
	caster:RemoveModifierByName("modifier_duskbringer_rune_e_4_visible")
	caster:RemoveModifierByName("modifier_duskbringer_rune_e_4_invisible")
    EmitSoundOn("Duskbringer.Manifestation", caster)
    target = WallPhysics:WallSearch(casterOrigin, target, caster)
    caster.r_4_level = Runes:GetTotalRuneLevel(caster, 4, "r_4", "duskbringer")
	local b_c_level = Runes:GetTotalRuneLevel(caster, 2, "e_2", "duskbringer")
	if b_c_level > 0 then
		local specterAbility = caster:FindAbilityByName("specter_rush_two")
		local b_c_duration = 0.7 + 0.2*b_c_level
		b_c_duration = Filters:GetAdjustedBuffDuration(caster, b_c_duration, false)
		specterAbility:ApplyDataDrivenModifier(caster, caster, "modifier_duskbringer_rune_e_2_effect", {duration = b_c_duration})
		caster:SetModifierStackCount("modifier_duskbringer_rune_e_2_effect", caster, 6)
	end
    local c_c_level = Runes:GetTotalRuneLevel(caster, 3, "e_3", "duskbringer")
    local d_c_level = Runes:GetTotalRuneLevel(caster, 4, "e_4", "duskbringer")
    manifestParticle(casterOrigin, caster)
	FindClearSpaceForUnit(caster, target, true)
	manifestParticle(target, caster)
	if c_c_level > 0 then
		local casterOrigin = caster:GetAbsOrigin()
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), casterOrigin, nil, 360, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )

		local flailAbility = caster:FindAbilityByName("whirling_flail")
		if #enemies > 0 then
			EmitSoundOn("Hero_Spirit_Breaker.GreaterBash", caster)
			local stacksCount = T71_STACKS_INCREASE * Runes:Procs(c_c_level, E3_PROC_CHANCE, 1)
			for _,enemy in pairs(enemies) do
				increment_duskfire_stacks(caster,enemy, flailAbility, stacksCount)
			end
		end 			
	end

    Filters:CastSkillArguments(3, caster)
end

function manifestParticle(position, caster)
		local particleName = "particles/units/heroes/hero_faceless_void/duskbringer_glyph_7_1_manifest_timedialate.vpcf"
		local particle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
		local radius = 400
		ParticleManager:SetParticleControl(particle, 0, position)
		ParticleManager:SetParticleControl(particle, 1, Vector(radius,radius,radius))
		Timers:CreateTimer(1.5, function()
			ParticleManager:DestroyParticle(particle, false)
		end)
end

-- function d_c_up(caster, d_c_level, damage)
--     local runeAbility = caster.runeUnit4:FindAbilityByName("duskbringer_rune_e_4")
--     runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_duskbringer_rune_e_4_visible", {duration = 15})
--     local current_stacks = caster:GetModifierStackCount( "modifier_duskbringer_rune_e_4_visible", runeAbility )
--     newStacks = current_stacks + 1
--     caster:SetModifierStackCount( "modifier_duskbringer_rune_e_4_visible", runeAbility, newStacks )


--     runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_duskbringer_rune_e_4_invisible", {duration = 7})
--     local current_stacks_true = caster:GetModifierStackCount( "modifier_duskbringer_rune_e_4_invisible", runeAbility )
--     local new_stacks_true = current_stacks_true + (damage/100) * 0.5 * d_c_level
--     caster:SetModifierStackCount( "modifier_duskbringer_rune_e_4_invisible", runeAbility, new_stacks_true)
-- end