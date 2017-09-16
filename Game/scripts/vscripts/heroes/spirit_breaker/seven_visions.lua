require('heroes/spirit_breaker/whirling_flail')

function seven_visions_start(event)
	local ability = event.ability
	local attacks = event.attack_count
	local caster = event.caster
	local damage = event.damage
	if caster:HasModifier("modifier_duskbringer_glyph_5_1") then
		attacks = attacks + 2
	end
	if caster:HasModifier("modifier_duskbringer_glyph_5_a") then
		ability:EndCooldown()
		ability:StartCooldown(ability:GetCooldown(ability:GetLevel())/2)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_seven_visions_striking_glyphed", {duration = (attacks-1)*0.25})
	else
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_seven_visions_striking", {duration = (attacks-1)*0.5})
	end
	ability.a_d_level = Runes:GetTotalRuneLevel(caster, 1, "a_d", "duskbringer")
	ability.b_d_level = Runes:GetTotalRuneLevel(caster, 2, "b_d", "duskbringer")
	ability.c_d_level = Runes:GetTotalRuneLevel(caster, 3, "c_d", "duskbringer")
	caster.d_d_level = Runes:GetTotalRuneLevel(caster, 4, "d_d", "duskbringer")
	caster:RemoveModifierByName("modifier_duskbringer_rune_c_d")
	seven_visions_strike(caster, caster:GetAbsOrigin(), damage, ability)

	Filters:CastSkillArguments(4, caster)
end

function seven_visions_think(event)
	local ability = event.ability
	local caster = event.caster
	local damage = event.damage
	seven_visions_strike(caster, caster:GetAbsOrigin(), damage, ability)
end

function seven_visions_strike(caster, position, damage, ability)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	local enemy = enemies[RandomInt(1, #enemies)]
	if #enemies > 0 then
		caster:SetAbsOrigin(enemy:GetAbsOrigin()+RandomVector(120))
		local fv = (enemy:GetAbsOrigin()-caster:GetAbsOrigin()):Normalized()
		local casterPos = caster:GetAbsOrigin()
		caster:SetForwardVector(fv)
		EmitSoundOn("Hero_Spirit_Breaker.NetherStrike.End", caster)
		StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_ATTACK, rate=2.0})
			Timers:CreateTimer(0.2, function()
				local modifierKnockback =
				{
					center_x = casterPos.x,
					center_y = casterPos.y,
					center_z = casterPos.z,
					duration = 1.0,
					knockback_duration = 0.6,
					knockback_distance = 220,
					knockback_height = 50
				}
				if ability.b_d_level > 0 then
					local flailAbility = caster:FindAbilityByName("whirling_flail")
					increment_duskfire_stacks(caster, enemy, flailAbility, ability.b_d_level)
				end
				if ability.c_d_level > 0 then
					local runeAbility = caster.runeUnit3:FindAbilityByName("duskbringer_rune_c_d")
					local c_d_duration = Filters:GetAdjustedBuffDuration(caster, 6, false)
					runeAbility:ApplyDataDrivenModifier(caster.runeUnit2, caster, "modifier_duskbringer_rune_c_d", {duration = c_d_duration})
					local current_stack = caster:GetModifierStackCount("modifier_duskbringer_rune_c_d", runeAbility)
					caster:SetModifierStackCount( "modifier_duskbringer_rune_c_d", runeAbility, current_stack + ability.c_d_level )
				end
				damage = damage
				caster:PerformAttack(enemy, true, true, true, true, false, false, false)
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, 4, RPC_ELEMENT_GHOST, RPC_ELEMENT_NORMAL)
				EmitSoundOn("Hero_Spirit_Breaker.GreaterBash", enemy)
				enemy:AddNewModifier( caster, nil, "modifier_knockback", modifierKnockback )
				local particleName = "particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf"
				EmitSoundOn("Hero_Spirit_Breaker.Attack", caster)
				EmitSoundOn("Hero_Spirit_Breaker.Attack", caster)
				local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, enemy )
				ParticleManager:SetParticleControlEnt(pfx, 0, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
				Timers:CreateTimer(0.8, function() 
				  ParticleManager:DestroyParticle( pfx, false )
				end) 
				if ability.a_d_level > 0 then
				local particleName = "particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_explosion.vpcf"
					local pfx2 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, enemy )
					ParticleManager:SetParticleControlEnt(pfx2, 0, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
					Timers:CreateTimer(0.8, function() 
					  ParticleManager:DestroyParticle( pfx2, false )
					end) 
					local enemies_a_d = FindUnitsInRadius( caster:GetTeamNumber(), enemy:GetAbsOrigin(), nil, 480, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
					local a_d_damage = ability.a_d_level*470
					for _,enemy_a_d in pairs(enemies_a_d) do
						Filters:TakeArgumentsAndApplyDamage(enemy_a_d, caster, a_d_damage, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_GHOST, RPC_ELEMENT_NONE)
					end
				end	
		end)
	end
end

function seven_visions_end(event)
 local caster = event.caster
 FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
end