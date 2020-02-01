require('heroes/grimstroke/rubilash_w_ability')
require('heroes/grimstroke/rubilash_self_portrait')
require('heroes/grimstroke/rubilash_root')

function ink_splatter_start(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]

	local actual_event_caster = caster
	if event.illusion then
		local illusion_ability = caster:FindAbilityByName("rubilash_self_portrait")
		actual_event_caster = illusion_ability.illusion
	end
	local casterOrigin = actual_event_caster:GetAbsOrigin()
	local newPosition  = WallPhysics:WallSearch(casterOrigin, point, actual_event_caster)

	local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/rubilash/e_start_"..actual_event_caster.color..".vpcf", actual_event_caster, 4)
	ParticleManager:SetParticleControl(pfx, 2, newPosition)

	actual_event_caster:SetAbsOrigin(newPosition - Vector(0,0,300))
	toggle_rubilash_color(actual_event_caster)
	local particlePos = GetGroundPosition(newPosition, actual_event_caster)
	CustomAbilities:QuickParticleAtPoint("particles/roshpit/rubilash/ink_splatter_"..actual_event_caster.color..".vpcf", particlePos, 3)
	EmitSoundOn("Rubilash.InkSplatter.Highlight", actual_event_caster)
	EmitSoundOn("Rubilash.InkSplatter.Splatter", actual_event_caster)
	EmitSoundOn("Rubilash.VO.Grunt", actual_event_caster)
	ability:ApplyDataDrivenModifier(actual_event_caster, actual_event_caster, "modifier_ink_splatter_emerging", {duration = 0.24})
	StartAnimation(actual_event_caster, {duration = 2, activity = ACT_DOTA_TELEPORT_END, rate = 1})
	ProjectileManager:ProjectileDodge(caster)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), particlePos, nil, event.damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do  
			local damage, damagetype = rubilash_apply_paint_and_get_damage(caster, ability, event.damage, enemy)  
			Timers:CreateTimer(0.03, function()
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, damagetype, BASE_ABILITY_E, RPC_ELEMENT_DEMON, RPC_ELEMENT_GHOST)
			end)
		end
	end	

	local e_1_level = caster:GetRuneValue("e", 1)
	if e_1_level > 0 then
		if caster:HasModifier("modifier_rubilash_arcana1") then
			local health_restore = caster:GetMaxHealth()*(RUBILASH_ARCANA1_RUNE_E1_HEALTH_RESTORE_PCT/100)
			Filters:ApplyHeal(caster, caster, health_restore, true, true, ability)
		else
			local mana_restore = RUBILASH_RUNE_E1_MANA_RESTORE*e_1_level
			caster:GiveMana(mana_restore)
			Timers:CreateTimer(0.24, function()
				PopupMana(caster, mana_restore)
			end)
		end
	end
	if not actual_event_caster:HasModifier("modifier_rubilash_illusion_base") then
		local illusion_cast_table = event
		illusion_cast_table.illusion = true
		illusion_cast_table.target_points[1] = newPosition + RandomVector(RandomInt(180, 260))
		local delay = get_rubilash_portrait_delay_time(caster)
		Timers:CreateTimer(delay, function()
			local illusion_ability = actual_event_caster:FindAbilityByName("rubilash_self_portrait")
			if illusion_ability.illusion and IsValidEntity(illusion_ability.illusion) and illusion_ability.illusion:IsAlive() and not illusion_ability.illusion:IsStunned() then
				ink_splatter_start(illusion_cast_table)
			end
		end)
	end
	Filters:CastSkillArguments(BASE_ABILITY_E, caster)
end

function ink_splatter_emerging_think(event)
	local caster = event.caster
	caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0,0,37.5))
end

function ink_splatter_emerging_end(event)
	local caster = event.caster
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
end

function rubilash_glyph_3_1_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local illusion = event.target
	local illusion_cast_table = event
	illusion_cast_table.ability = caster:FindAbilityByName("rubilash_paint_splatter_"..illusion.color)
	if not illusion_cast_table.ability then
		illusion_cast_table.ability = caster:FindAbilityByName("rubilash_paint_splatter_red")
	end
	illusion_cast_table.illusion = true
	illusion_cast_table.damage_radius = illusion_cast_table.ability:GetSpecialValueFor("damage_radius")
	illusion_cast_table.target_points = {}
	illusion_cast_table.target_points[1] = illusion:GetAbsOrigin() + RandomVector(RandomInt(100, RUBILASH_GLYPH_3_1_RANGE))
	local delay = get_rubilash_portrait_delay_time(caster)
	Timers:CreateTimer(delay, function()
		if illusion and IsValidEntity(illusion) and illusion:IsAlive() and not illusion:IsStunned() then
			ink_splatter_start(illusion_cast_table)
		end
	end)
end