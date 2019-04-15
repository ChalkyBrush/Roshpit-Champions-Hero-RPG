require('heroes/spirit_breaker/duskbringer_3_e')
require('/heroes/spirit_breaker/duskbringer_constants')

function begin_manifestation(event)
	local caster = event.caster
	local ability = event.ability
    local target = event.target_points[1]
    local casterOrigin = caster:GetAbsOrigin()
    local zLock = casterOrigin.z
    EmitSoundOn("Duskbringer.Manifestation", caster)
    target = WallPhysics:WallSearch(casterOrigin, target, caster)
    local e_2_level = caster:GetRuneValue("e", 2)
	if e_2_level > 0 then
		local specterAbility = caster:FindAbilityByName("specter_rush_two")
		local b_c_duration = DUSKBRINGER_E2_BASE_DUR + DUSKBRINGER_E2_DUR * e_2_level
		b_c_duration = Filters:GetAdjustedBuffDuration(caster, b_c_duration, false)
		specterAbility:ApplyDataDrivenModifier(caster, caster, "modifier_duskbringer_rune_e_2_effect", {duration = b_c_duration})
		caster:SetModifierStackCount("modifier_duskbringer_rune_e_2_effect", caster, 6)
	end
    local e_3_level = caster:GetRuneValue("e", 3)
    manifestParticle(casterOrigin, caster)
    if caster:HasModifier("modifier_terrorize_thinking") then
    	caster:SetAbsOrigin(Vector(target.x, target.y, zLock))
    	manifestParticle(Vector(target.x, target.y, zLock), caster)
    else
		FindClearSpaceForUnit(caster, target, true)
		manifestParticle(target, caster)
	end
	
	if e_3_level > 0 then
		local casterOrigin = caster:GetAbsOrigin()
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), casterOrigin, nil, 360, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )

		if #enemies > 0 then
			EmitSoundOn("Hero_Spirit_Breaker.GreaterBash", caster)
			local stacksCount = DUSKBRINGER_GLYPH_7_1_MULT_STACKS * Runes:Procs(e_3_level, DUSKBRINGER_E3_PROC_CHANCE, 1)
			for _,enemy in pairs(enemies) do
				increment_duskfire_stacks(caster,enemy, stacksCount)
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