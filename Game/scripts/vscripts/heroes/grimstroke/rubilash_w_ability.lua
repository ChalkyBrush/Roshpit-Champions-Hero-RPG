require('heroes/grimstroke/rubilash_constants')
require('heroes/grimstroke/rubilash_root')

RUBILASH_COLORS = {"red", "yellow", "blue"}
RUBILASH_COLORS_DATA = {}
RUBILASH_COLORS_DATA["red"] = Vector(255, 0, 0)
RUBILASH_COLORS_DATA["yellow"] = Vector(255, 255, 0)
RUBILASH_COLORS_DATA["blue"] = Vector(255, 255, 255)
RUBILASH_COLORS_DATA["white"] = Vector(0, 0, 0)

function rubilash_init(event)
	local caster = event.caster
	if not caster.color then
		caster.color = "red"
		for k, v in pairs(caster:GetChildren()) do
			if v:GetClassname() == "dota_item_wearable" then
				if string.match(v:GetModelName(), "weapon") then
					print(v:GetModelName())
					caster.weaponFX = v
					caster.origWeapon = v:GetModelName()
					break
				end
			end
		end

		local force_weapon_model = "models/items/grimstroke/grimstroke_ti9_immortal_weapon/grimstroke_ti9_immortal_weapon.vmdl"
		caster.weaponInit = true
		caster.weaponFX:SetModel(force_weapon_model)
		set_rubilash_color_visual(caster)

		if not caster:HasAbility("rubilash_hidden_passive") then
			caster:AddAbility("rubilash_hidden_passive"):SetLevel(1)
		end
	end
end

function rubilash_ink_blot_phase(event)
	local caster = event.caster
	if event.illusion then
		local illusion_ability = caster:FindAbilityByName("rubilash_self_portrait")
		caster = illusion_ability.illusion
	end
	StartAnimation(caster, {duration = 0.5, activity = ACT_DOTA_CAST_ABILITY_1, rate = 1.6})
	EmitSoundOn("Rubilash.InkBlot.Throw", caster)
end

function rubilash_ink_blot(event)
	local caster = event.caster
	local ability = event.ability

	local actual_event_caster = caster
	if event.illusion then
		local illusion_ability = caster:FindAbilityByName("rubilash_self_portrait")
		actual_event_caster = illusion_ability.illusion
		local facing_vector = ((event.target_points[1] - actual_event_caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		actual_event_caster:MoveToPosition(actual_event_caster:GetAbsOrigin() + facing_vector)
	end

	local point = event.target_points[1]
    local fv = ((point - actual_event_caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
    local spellOrigin = actual_event_caster:GetAbsOrigin()
    local range = WallPhysics:GetDistance2d(spellOrigin, point)
    local speed = 1600
    if caster:HasModifier("modifier_rubilash_glyph_1_1") then
    	speed = speed * (1 + RUBILASH_GLYPH_1_1_PROJECTILE_SPEED_PCT/100)
    end
    print("IN HERE?")
    local info =
    {
        Ability = ability,
        EffectName = "particles/roshpit/rubilash/ink_blot_"..actual_event_caster.color..".vpcf",
        vSpawnOrigin = spellOrigin + Vector(0,0,140),
        fDistance = range,
        fStartRadius = 220,
        fEndRadius = 220,
        Source = actual_event_caster,
        StartPosition = "attach_brush_end",
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 6,
        bDeleteOnHit = true,
        vVelocity = fv * speed,
        bProvidesVision = false,
    }
    ProjectileManager:CreateLinearProjectile(info)

    local travel_time = range/speed
    local soundDelay = math.max(travel_time - 0.21, 0.1)
    Timers:CreateTimer(soundDelay, function()
    	local explosionPosition = spellOrigin + fv*range
    	EmitSoundOnLocationWithCaster(explosionPosition, "Rubilash.InkBlot.Splash", actual_event_caster)
    end)
    local color = actual_event_caster.color
    Timers:CreateTimer(travel_time, function()
    	local explosionPosition = GetGroundPosition(spellOrigin + fv*range, actual_event_caster) 
    	AddFOWViewer(caster:GetTeamNumber(), explosionPosition, 220, 1.5, false)
    	CustomAbilities:QuickParticleAtPoint("particles/roshpit/rubilash/ink_blot_explosion_"..color..".vpcf", explosionPosition, 3)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), explosionPosition, nil, event.damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do    
				local damage, damagetype = rubilash_apply_paint_and_get_damage(caster, ability, event.damage, enemy)
				Timers:CreateTimer(0.03, function()
					Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, damagetype, BASE_ABILITY_W, RPC_ELEMENT_DEMON, RPC_ELEMENT_GHOST)
				end)
			end
		end	
    end)

	if not actual_event_caster:HasModifier("modifier_rubilash_illusion_base") then
		local illusion_cast_table = event
		illusion_cast_table.illusion = true
		local delay = get_rubilash_portrait_delay_time(actual_event_caster)
		Timers:CreateTimer(delay, function()
			local illusion_ability = caster:FindAbilityByName("rubilash_self_portrait")
			if illusion_ability.illusion and IsValidEntity(illusion_ability.illusion) and illusion_ability.illusion:IsAlive() and not illusion_ability.illusion:IsStunned() then
				rubilash_ink_blot_phase(illusion_cast_table)
				Timers:CreateTimer(ability:GetCastPoint(), function()
					if illusion_ability.illusion and IsValidEntity(illusion_ability.illusion) and illusion_ability.illusion:IsAlive() and not illusion_ability.illusion:IsStunned() then
						rubilash_ink_blot(illusion_cast_table)
					end
				end)
			end
		end)
	end
	Filters:CastSkillArguments(BASE_ABILITY_W, caster)
end

function toggle_rubilash_color(caster)
	local original_color = caster.color
	if caster.color == "red" then
		caster.color = "yellow"
	elseif caster.color == "yellow" then
		caster.color = "blue"
	elseif caster.color == "blue" then
		caster.color = "red"
	elseif caster.color == "white" then
		caster.color = "white"
	end

	if not caster.illusion then
		if original_color ~= caster.color then
			CustomAbilities:AddAndOrSwapSkill(caster, "rubilash_phantom_brush_"..original_color, "rubilash_phantom_brush_"..caster.color, DOTA_Q_SLOT)
			CustomAbilities:AddAndOrSwapSkill(caster, "rubilash_ink_blot_"..original_color, "rubilash_ink_blot_"..caster.color, DOTA_W_SLOT)
			CustomAbilities:AddAndOrSwapSkill(caster, "rubilash_paint_splatter_"..original_color, "rubilash_paint_splatter_"..caster.color, DOTA_E_SLOT)
		end
	end
	set_rubilash_color_visual(caster)
end

function set_rubilash_color_visual(caster)
	if caster.pfx then
		ParticleManager:DestroyParticle(caster.pfx, false)
		ParticleManager:ReleaseParticleIndex(caster.pfx)
	end
	caster.pfx = ParticleManager:CreateParticle("particles/roshpit/rubilash/paintbrush_"..caster.color..".vpcf", PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(caster.pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_brush_end", caster:GetAbsOrigin(), true)
	if caster:HasModifier("modifier_rubilash_illusion_base") then
		Events:ColorWearablesAndBase(caster, RUBILASH_COLORS_DATA[caster.color])
		if caster.effectPFX then
			ParticleManager:DestroyParticle(caster.effectPFX, false)
			caster.effectPFX = CustomAbilities:QuickAttachParticle("particles/roshpit/rubilash/self_portrait_buff_"..caster.color..".vpcf", caster, 180)
		end
	end
	caster:SetRangedProjectileName("particles/roshpit/rubilash/rubilash_base_attack_"..caster.color..".vpcf")
end

function get_rubilash_portrait_delay_time(rubilash)
	return RUBILASH_ILLUSION_CAST_DELAY + (rubilash:GetRuneValue("r", 4)*RUBILASH_RUNE_R4_PORTRAIT_DELAY_REDUCTION)
end

function rubilash_apply_paint_and_get_damage(caster, ability, damage, target)
	local mult = 1
	if target.dummy then
		return 1
	end
	-- TODO: USE ABILITY NAME TO GET ACTUAL PAINT COLOR
	local color = caster.color
	if string.match(ability:GetAbilityName(), "_red") then
		color = "red"
	elseif string.match(ability:GetAbilityName(), "_yellow") then
		color = "yellow"
	elseif string.match(ability:GetAbilityName(), "_blue") then
		color = "blue"
	elseif string.match(ability:GetAbilityName(), "white") then
		color = "white"
	end
	if target.rubilash_paint_total_color then
		if RUBILASH_MULTS[color][target.rubilash_paint_total_color] then
			mult = RUBILASH_MULTS[color][target.rubilash_paint_total_color]
		end
	end
	local damagetype = DAMAGE_TYPE_MAGICAL
	if not target.rubilash_paint then
		target.rubilash_paint = {}
		target.rubilash_paint["red"] = 0
		target.rubilash_paint["blue"] = 0
		target.rubilash_paint["yellow"] = 0
		target.rubilash_paint["white"] = 0
		target.rubilash_paint_total_color = "none"
	end
	target.rubilash_paint[color] = (get_rubilash_paint_duration(caster))*10
	DeepPrintTable(target.rubilash_paint)
	target.rubilash_paint_total_color = get_new_rubilash_paint_color(target)
	if caster:HasModifier("modifier_rubilash_immortal_weapon_3") then
		damage = damage + (caster:GetAgility() + caster:GetIntellect())*(RUBILASH_IMMORTAL_WEAPON_3_AGI_AND_INT_MULT_TO_PAINT) + OverflowProtectedGetAverageTrueAttackDamage(caster)*RUBILASH_IMMORTAL_WEAPON_3_ATK_DMG_PCT_TO_PAINT/100
	end
	if caster:HasModifier("modifier_rubilash_arcana1") then
		damage = damage + caster:GetRuneValue("e", 3)*RUBILASH_ARCANA1_RUNE_E3_FLAT_DMG
	end
	print("MY PAINT COLOR "..target.rubilash_paint_total_color)
	apply_actual_paint_buff(caster, target)
	-- damage = 0
	print("PAINT MULT: "..mult)
	local adjusted_damage = damage*mult
	rubilash_base_e_3(caster, adjusted_damage)
	local glyph_mult = 1
	local white_damage_types = nil
	if color == "white" then
		white_damage_types = {DAMAGE_TYPE_MAGICAL, DAMAGE_TYPE_MAGICAL, DAMAGE_TYPE_MAGICAL}
	end
	if caster:HasModifier("modifier_rubilash_glyph_5_1") then
		if color == "blue" or color == "white" then
			Filters:MagicImmuneBreak(caster, target)
		end
	end
	if caster:HasModifier("modifier_rubilash_glyph_6_1") then
		if color == "red" or color == "white" then
			glyph_mult = glyph_mult + RUBILASH_GLYPH_6_1_DAMAGE_INCREASE_PCT/100
			if color == "white" then
				white_damage_types[2] = DAMAGE_TYPE_PHYSICAL
			else
				damagetype = DAMAGE_TYPE_PHYSICAL
			end
		end
	end
	if caster:HasModifier("modifier_rubilash_glyph_7_1") then
		if color == "yellow" or color == "white" then
			glyph_mult = glyph_mult * (1 + RUBILASH_GLYPH_7_1_DAMAGE_REDUCE_PCT/100)
			if color == "white" then
				white_damage_types[3] = DAMAGE_TYPE_PURE
			else
				damagetype = DAMAGE_TYPE_PURE
			end
		end
	end
	if color == "white" then
		damagetype = white_damage_types[RandomInt(1, #white_damage_types)]
	end
	adjusted_damage = adjusted_damage*glyph_mult
	return adjusted_damage, damagetype
end

function get_rubilash_paint_duration(caster)
	return math.max(RUBILASH_PAINTED_DURATION_BASE + caster:GetRuneValue("w", 1)*RUBILASH_RUNE_W1_EXTRA_PAINT_DURATION, 0)
end

function get_remaining_paint_duration(target)
	local max = 1
	for key, value in pairs(target.rubilash_paint) do
		if target.rubilash_paint[key] >= max then
			max = value
		end
	end
	return max*0.1
end

function get_new_rubilash_paint_color(target)
	if target.rubilash_paint["red"] > 0 and target.rubilash_paint["yellow"] > 0 and target.rubilash_paint["blue"] > 0 then
		return "black"
	elseif target.rubilash_paint["red"] > 0 and target.rubilash_paint["yellow"] > 0 then
		return "orange"
	elseif target.rubilash_paint["red"] > 0 and target.rubilash_paint["blue"] > 0 then
		return "purple"	
	elseif target.rubilash_paint["yellow"] > 0 and target.rubilash_paint["blue"] > 0 then
		return "green"	
	elseif target.rubilash_paint["yellow"] > 0 then
		return "yellow"	
	elseif target.rubilash_paint["red"] > 0 then
		return "red"	
	elseif target.rubilash_paint["blue"] > 0 then
		return "blue"
	elseif target.rubilash_paint["white"] > 0 then
		return "white"
	else
		return "none"	
	end
end

function rubilash_painted_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if target:IsAlive() then
		for key, value in pairs(target.rubilash_paint) do
			target.rubilash_paint[key] = math.max(value - 1, 0)
		end
		target.rubilash_paint_total_color = get_new_rubilash_paint_color(target)
		apply_actual_paint_buff(caster, target)
	end
end

function apply_actual_paint_buff(caster, target)
	for i = 1, #RUBILASH_ALL_COLORS, 1 do
		if RUBILASH_ALL_COLORS[i] == target.rubilash_paint_total_color then
		else
			if target:HasModifier("modifier_rubilash_painted_"..RUBILASH_ALL_COLORS[i]) then
				target:RemoveModifierByName("modifier_rubilash_painted_"..RUBILASH_ALL_COLORS[i])
			end
		end
	end
	if target.rubilash_paint_total_color == "none" then
		target:RemoveModifierByName("modifier_rubilash_base_painted")
		target:RemoveModifierByName("modifier_rubilash_w_4_slow")
	else
		local painted_modifier = target:FindModifierByName("modifier_rubilash_painted_"..target.rubilash_paint_total_color)
		local paint_duration = get_remaining_paint_duration(target)
		if not target:HasModifier("modifier_rubilash_painted_"..target.rubilash_paint_total_color) or (paint_duration > painted_modifier:GetRemainingTime() + 0.1) then
			local painting_ability = caster:FindAbilityByName("rubilash_ink_blot_"..caster.color)
			painting_ability:ApplyDataDrivenModifier(caster, target, "modifier_rubilash_painted_"..target.rubilash_paint_total_color, {duration = paint_duration})
			painting_ability:ApplyDataDrivenModifier(caster, target, "modifier_rubilash_base_painted", {duration = paint_duration})
			target:CalculateAndSaveRoshpitAttributes()
			update_w_4_movespeed(caster, target, paint_duration)
			if caster:HasModifier("modifier_rubilash_glyph_5_a") then
				if target.rubilash_paint_total_color == "black" or target.rubilash_paint_total_color == "white" then
					local passive_ability = caster:FindAbilityByName("rubilash_hidden_passive")
					passive_ability:ApplyDataDrivenModifier(caster, caster, "modifier_rubilash_glyph_5_a_buff", {})
					if not passive_ability.paint_table then
						passive_ability.paint_table = {}
					end
					passive_ability.paint_table[target:GetEntityIndex()] = target
				end
			end
		end
	end
end

function rubilash_w_ability_attack_land(event)
	local caster = event.caster
	local ability = caster:GetAbilityByIndex(DOTA_W_SLOT)
	local target = event.target

	local w_3_level = caster:GetRuneValue("w", 3)
	if w_3_level > 0 then
    	local explosionPosition = target:GetAbsOrigin()
    	AddFOWViewer(caster:GetTeamNumber(), explosionPosition, 220, 1.5, false)
    	CustomAbilities:QuickParticleAtPoint("particles/roshpit/rubilash/ink_blot_explosion_"..caster.color..".vpcf", explosionPosition, 3)
    	local radius = ability:GetSpecialValueFor("damage_radius")
    	local base_ability_damage = ability:GetSpecialValueFor("damage")*(RUBILASH_RUNE_W3_W_AMP/100)*w_3_level
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), explosionPosition, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do    
				local damage, damagetype = rubilash_apply_paint_and_get_damage(caster, ability, base_ability_damage, enemy)
				print(damage)
				Timers:CreateTimer(0.03, function()
					Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, damagetype, BASE_ABILITY_W, RPC_ELEMENT_DEMON, RPC_ELEMENT_GHOST)
				end)
			end
		end
	end
end

function update_w_4_movespeed(caster, target, paint_duration)
	local w_4_level = caster:GetRuneValue("w", 4)
	if w_4_level > 0 then
		local master_ability = caster:FindAbilityByName("rubilash_hidden_passive")
		master_ability:ApplyDataDrivenModifier(caster, target, "modifier_rubilash_w_4_slow", {duration = paint_duration})
		local stacks = w_4_level
		local mult = 1
		if target:HasModifier("modifier_rubilash_painted_white") or target:HasModifier("modifier_rubilash_painted_black") then
			mult = 3
		elseif target:HasModifier("modifier_rubilash_painted_orange") or target:HasModifier("modifier_rubilash_painted_purple") or target:HasModifier("modifier_rubilash_painted_green") then
			mult = 2
		end
		target:SetModifierStackCount("modifier_rubilash_w_4_slow", caster, stacks*mult)
	end
end

function rubilash_base_e_3(caster, adjusted_damage)
	if not caster:HasModifier("modifier_rubilash_arcana1") then
		local e_3_level = caster:GetRuneValue("e", 3)
		if e_3_level > 0 then
			heal_amount = adjusted_damage*(RUBILASH_RUNE_E3_PAINT_HEAL_PCT/100)*e_3_level
			Filters:ApplyHeal(caster, caster, heal_amount, true, false, nil)
		end
	end
end

function glyph_5_a_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local keep_paint = false
	for key, value in pairs(ability.paint_table) do
		if value and IsValidEntity(value) and (value:HasModifier("modifier_rubilash_painted_black") or value:HasModifier("modifier_rubilash_painted_white")) then
			keep_paint = true
		else
			ability.paint_table[key] = nil
		end
	end
	if not keep_paint then
		caster:RemoveModifierByName("modifier_rubilash_glyph_5_a_buff")
		ability.paint_table = nil
	end
end

function rubilash_arcana1_init(event)
	local caster = event.target
	caster.color = "white"
	set_rubilash_color_visual(caster)
end

function rubilash_arcana1_end(event)
	local caster = event.target
	caster.color = "red"
	set_rubilash_color_visual(caster)
end