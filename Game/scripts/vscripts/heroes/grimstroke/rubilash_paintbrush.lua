function paintbrush_phase_start(event)
	local caster = event.caster
	local ability = event.ability
	StartSoundEvent("Rubilash.Paintbrush.Pre", caster)
end

function paintbrush_phase_interrupt(event)
	local caster = event.caster
	local ability = event.ability
	StopSoundEvent("Rubilash.Paintbrush.Pre", caster)
end

function start_paintbrush(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Rubilash.Paintbrush.Cast.Highlight", caster)
	EmitSoundOn("Rubilash.Paintbrush.Cast.Inky", caster)
    local fv = ((event.target_points[1] - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
    local spellOrigin = caster:GetAbsOrigin()
    local range = 1500
    local speed = 3000
    local info =
    {
        Ability = ability,
        EffectName = "particles/roshpit/rubilash/paintbrush_proj_"..caster.color..".vpcf",
        vSpawnOrigin = spellOrigin,
        fDistance = range,
        fStartRadius = 220,
        fEndRadius = 220,
        Source = caster,
        StartPosition = "attach_brush_end",
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 6,
        bDeleteOnHit = true,
        vVelocity = fv * speed,
		bProvidesVision = true,
		iVisionRadius = 200,
		iVisionTeamNumber = caster:GetTeamNumber()
    }
    ProjectileManager:CreateLinearProjectile(info)

    CustomAbilities:QuickAttachParticle("particles/roshpit/rubilash/rubilash_cast_"..caster.color.."_blur.vpcf", caster, 3)
    Timers:CreateTimer((range/speed)/2, function()
    	AddFOWViewer(caster:GetTeamNumber(), spellOrigin+fv*range, 300, 1.5, false)
    end)
end