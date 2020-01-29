RUBILASH_COLORS = {"red", "yellow", "blue"}
RUBILASH_COLORS_DATA = {}
RUBILASH_COLORS_DATA["red"] = Vector(255, 0, 0)
RUBILASH_COLORS_DATA["yellow"] = Vector(255, 255, 0)
RUBILASH_COLORS_DATA["blue"] = Vector(255, 255, 255)

function rubilash_init(event)
	local caster = event.caster
	if not caster.color then
		caster.color = "blue"
	end
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
	toggle_rubilash_color(caster)
end

function rubilash_ink_blot_phase(event)
	local caster = event.caster
	StartAnimation(caster, {duration = 0.5, activity = ACT_DOTA_CAST_ABILITY_1, rate = 1.6})
	EmitSoundOn("Rubilash.InkBlot.Throw", caster)
end

function rubilash_ink_blot(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
    local fv = ((point - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
    local spellOrigin = caster:GetAbsOrigin()
    local range = WallPhysics:GetDistance2d(spellOrigin, point)
    local speed = 1600
    print("IN HERE?")
    local info =
    {
        Ability = ability,
        EffectName = "particles/roshpit/rubilash/ink_blot_"..caster.color..".vpcf",
        vSpawnOrigin = spellOrigin + Vector(0,0,140),
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
        bProvidesVision = false,
    }
    ProjectileManager:CreateLinearProjectile(info)

    local travel_time = range/speed
    local soundDelay = math.max(travel_time - 0.21, 0.1)
    Timers:CreateTimer(soundDelay, function()
    	local explosionPosition = spellOrigin + fv*range
    	EmitSoundOnLocationWithCaster(explosionPosition, "Rubilash.InkBlot.Splash", caster)
    end)
    Timers:CreateTimer(travel_time, function()
    	local explosionPosition = spellOrigin + fv*range
    	AddFOWViewer(caster:GetTeamNumber(), explosionPosition, 220, 1.5, false)
    	CustomAbilities:QuickParticleAtPoint("particles/roshpit/rubilash/ink_blot_explosion_"..caster.color..".vpcf", explosionPosition, 3)
    	
    end)
end

function toggle_rubilash_color(caster)
	if caster.color == "red" then
		caster.color = "yellow"
	elseif caster.color == "yellow" then
		caster.color = "blue"
	elseif caster.color == "blue" then
		caster.color = "red"
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
end