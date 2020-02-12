require('heroes/grimstroke/rubilash_w_ability')
require('heroes/grimstroke/rubilash_self_portrait')
require('heroes/grimstroke/rubilash_root')

function paintbrush_phase_start(event)
	local caster = event.caster
	local ability = event.ability
	if event.illusion then
		local illusion_ability = caster:FindAbilityByName("rubilash_self_portrait")
		caster = illusion_ability.illusion
	end
	if not caster:HasModifier("modifier_rubilash_immortal_weapon_1") then
		StartSoundEvent("Rubilash.Paintbrush.Pre", caster)
	end
end

function paintbrush_phase_interrupt(event)
	local caster = event.caster
	local ability = event.ability
	StopSoundEvent("Rubilash.Paintbrush.Pre", caster)
end

function start_paintbrush(event)
	local caster = event.caster
	local ability = event.ability

	local actual_event_caster = caster
	if event.illusion then
		local illusion_ability = caster:FindAbilityByName("rubilash_self_portrait")
		actual_event_caster = illusion_ability.illusion
		local facing_vector = ((event.target_points[1] - actual_event_caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		actual_event_caster:MoveToPosition(actual_event_caster:GetAbsOrigin() + facing_vector)
	else
		ability.caster = caster
	end

	EmitSoundOn("Rubilash.Paintbrush.Cast.Highlight", actual_event_caster)
	EmitSoundOn("Rubilash.Paintbrush.Cast.Inky", actual_event_caster)
    local fv = ((event.target_points[1] - actual_event_caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
    local spellOrigin = actual_event_caster:GetAbsOrigin()
    local range = event.range
    range = range + Filters:CalculateTotalCastRangeBonus(caster)
    local speed = range*2
    local info =
    {
        Ability = ability,
        EffectName = "particles/roshpit/rubilash/paintbrush_proj_"..actual_event_caster.color..".vpcf",
        vSpawnOrigin = spellOrigin,
        fDistance = range,
        fStartRadius = 150,
        fEndRadius = 150,
        Source = actual_event_caster,
        StartPosition = "attach_brush_end",
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 6,
        bDeleteOnHit = true,
        vVelocity = fv * speed,
		bProvidesVision = true,
		iVisionRadius = 200,
		iVisionTeamNumber = caster:GetTeamNumber()
    }
    ProjectileManager:CreateLinearProjectile(info)

    CustomAbilities:QuickAttachParticle("particles/roshpit/rubilash/rubilash_cast_"..actual_event_caster.color.."_blur.vpcf", actual_event_caster, 3)
    Timers:CreateTimer((range/speed)/2, function()
    	AddFOWViewer(caster:GetTeamNumber(), spellOrigin+fv*range, 300, 1.5, false)
    end)
	if not actual_event_caster:HasModifier("modifier_rubilash_illusion_base") then
		local illusion_cast_table = event
		illusion_cast_table.illusion = true
		local delay = get_rubilash_portrait_delay_time(actual_event_caster)
		Timers:CreateTimer(delay, function()
			local illusion_ability = caster:FindAbilityByName("rubilash_self_portrait")
			if illusion_ability.illusion and IsValidEntity(illusion_ability.illusion) and illusion_ability.illusion:IsAlive() and not illusion_ability.illusion:IsStunned() then
				StartAnimation(illusion_ability.illusion, {duration = 1.5, activity = ACT_DOTA_CAST_ABILITY_3, rate = 1})
				paintbrush_phase_start(illusion_cast_table)
				Timers:CreateTimer(ability:GetCastPoint(), function()
					if illusion_ability.illusion and IsValidEntity(illusion_ability.illusion) and illusion_ability.illusion:IsAlive() and not illusion_ability.illusion:IsStunned() then
						start_paintbrush(illusion_cast_table)
					end
				end)
			end
		end)
	end
	if actual_event_caster == caster then
		Filters:CastSkillArguments(BASE_ABILITY_Q, caster)
	end
	if caster:HasModifier("modifier_rubilash_glyph_2_1") then
		toggle_rubilash_color(actual_event_caster)
	end
end

function paintbrush_impact(event)
	local caster = event.ability.caster
	local ability = event.ability
	local target = event.target

	local damage, damagetype = rubilash_apply_paint_and_get_damage(caster, ability, event.damage, target)
	Timers:CreateTimer(0.03, function()
		Filters:TakeArgumentsAndApplyDamage(target, caster, damage, damagetype, BASE_ABILITY_Q, RPC_ELEMENT_DEMON, RPC_ELEMENT_GHOST)
	end)
	local q_3_level = caster:GetRuneValue("q", 3)
	if q_3_level > 0 then
		local duration = RUBILASH_RUNE_Q3_FEAR_DURATION_BASE + RUBILASH_RUNE_Q3_FEAR_DURATION*q_3_level
		ability:ApplyDataDrivenModifier(caster, target, "modifier_rubilash_q_3_fear", {duration = duration})
	end
end

function rubilash_q_3_fear_init(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	local direction = ((target:GetAbsOrigin() - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	local directionModified = WallPhysics:rotateVector(direction, 2*math.pi*RandomInt(-5, 5)/90)
	target:MoveToPosition(target:GetAbsOrigin() + directionModified*400)
end

function rubilash_q_3_fear_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	local direction = ((target:GetAbsOrigin() - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	local directionModified = WallPhysics:rotateVector(direction, 2*math.pi*RandomInt(-5, 5)/90)
	target:MoveToPosition(target:GetAbsOrigin() + directionModified*400)
end

function rubilash_q_3_fear_end(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	target:Stop()
end