require('heroes/spirit_breaker/specter_rush')

function begin_manifestation(event)
	local caster = event.caster
	local ability = event.ability
    local target = event.target_points[1]
    local casterOrigin = caster:GetAbsOrigin()
	caster:RemoveModifierByName("modifier_duskbringer_rune_d_c_visible")
	caster:RemoveModifierByName("modifier_duskbringer_rune_d_c_invisible")
    EmitSoundOn("Duskbringer.Manifestation", caster)
    target = WallPhysics:WallSearch(casterOrigin, target, caster)
    caster.d_d_level = Runes:GetTotalRuneLevel(caster, 4, "d_d", "duskbringer")
	local b_c_level = Runes:GetTotalRuneLevel(caster, 2, "b_c", "duskbringer")
	if b_c_level > 0 then
		local specterAbility = caster:FindAbilityByName("specter_rush_two")
		local b_c_duration = 0.7 + 0.2*b_c_level
		b_c_duration = Filters:GetAdjustedBuffDuration(caster, b_c_duration, false)
		specterAbility:ApplyDataDrivenModifier(caster, caster, "modifier_duskbringer_ghost_armor", {duration = b_c_duration})
		caster:SetModifierStackCount("modifier_duskbringer_ghost_armor", caster, 6)
	end
    local c_c_level = Runes:GetTotalRuneLevel(caster, 3, "c_c", "duskbringer")
    local d_c_level = Runes:GetTotalRuneLevel(caster, 4, "d_c", "duskbringer")
    manifestParticle(casterOrigin, caster)
	FindClearSpaceForUnit(caster, target, true)
	manifestParticle(target, caster)
	if c_c_level > 0 then
		local casterOrigin = caster:GetAbsOrigin()
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), casterOrigin, nil, 360, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		local modifierKnockback =
		{
			center_x = casterOrigin.x,
			center_y = casterOrigin.y,
			center_z = casterOrigin.z,
			duration = 0.7,
			knockback_duration = 0.5,
			knockback_distance = knockback_distance,
			knockback_height = 70
		}
		if #enemies > 0 then
			EmitSoundOn("Hero_Spirit_Breaker.GreaterBash", caster)
			local damage = c_c_level*1000 + caster:GetAgility()*8*c_c_level
			for _,enemy in pairs(enemies) do
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 3, RPC_ELEMENT_GHOST, RPC_ELEMENT_NONE)
				if not enemy.jumpLock then
					enemy:AddNewModifier( caster, nil, "modifier_knockback", modifierKnockback )
				end
				local particleName = "particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf"
				local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, enemy )
				ParticleManager:SetParticleControlEnt(pfx, 0, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
				Timers:CreateTimer(0.8, function() 
				  ParticleManager:DestroyParticle( pfx, false )
				end) 	
				if d_c_level > 0 then
					d_c_up(caster, d_c_level, damage)
				end

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
--     local runeAbility = caster.runeUnit4:FindAbilityByName("duskbringer_rune_d_c")
--     runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_duskbringer_rune_d_c_visible", {duration = 15})
--     local current_stacks = caster:GetModifierStackCount( "modifier_duskbringer_rune_d_c_visible", runeAbility )
--     newStacks = current_stacks + 1
--     caster:SetModifierStackCount( "modifier_duskbringer_rune_d_c_visible", runeAbility, newStacks )


--     runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_duskbringer_rune_d_c_invisible", {duration = 7})
--     local current_stacks_true = caster:GetModifierStackCount( "modifier_duskbringer_rune_d_c_invisible", runeAbility )
--     local new_stacks_true = current_stacks_true + (damage/100) * 0.5 * d_c_level
--     caster:SetModifierStackCount( "modifier_duskbringer_rune_d_c_invisible", runeAbility, new_stacks_true)
-- end