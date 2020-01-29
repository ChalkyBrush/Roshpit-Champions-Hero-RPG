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
    Timers:CreateTimer(travel_time, function()
    	local explosionPosition = GetGroundPosition(spellOrigin + fv*range, actual_event_caster) 
    	AddFOWViewer(caster:GetTeamNumber(), explosionPosition, 220, 1.5, false)
    	CustomAbilities:QuickParticleAtPoint("particles/roshpit/rubilash/ink_blot_explosion_"..actual_event_caster.color..".vpcf", explosionPosition, 3)
    	local damage = event.damage
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), explosionPosition, nil, event.damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do    
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_DEMON, RPC_ELEMENT_GHOST)
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
	if caster:HasModifier("modifier_rubilash_illusion_base") then
		Events:ColorWearablesAndBase(caster, RUBILASH_COLORS_DATA[caster.color])
	end
end

function get_rubilash_portrait_delay_time(rubilash)
	return 0.5
end