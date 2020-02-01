require('heroes/grimstroke/rubilash_w_ability')
require('heroes/grimstroke/rubilash_root')
require('heroes/grimstroke/rubilash_root')

function rubilash_dark_portrait_channel_start(event)
	local caster = event.caster
	local ability = event.ability

	StartAnimation(caster, {duration = 2.8, activity = ACT_DOTA_CAST_ABILITY_3, rate = 0.42})

	if ability.illusion and IsValidEntity(ability.illusion) then
		ability.illusion:ForceKill(false)
	end
	ability.illusion = rubilash_illusion(caster, ability, event.duration)
	StartSoundEvent("Rubilash.SelfPortraitStart", caster)
end

function rubilash_dark_portrait_channel_think(event)
	local caster = event.caster
	local ability = event.ability

end

function rubilash_dark_portrait_channel_end(event)
	local caster = event.caster
	local ability = event.ability
	ability.fallSpeed = 20

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_rubilash_dark_portrait_channel_end", {duration = 4})
	caster:RemoveModifierByName("modifier_rubilash_illusion_spawning")
end
function remove_modifier_channel_start(event)
	local caster = event.caster
	local ability = event.ability
	caster:RemoveModifierByName("modifier_channel_start")
end

function rubilash_self_portrait_fail(event)
	local caster = event.caster
	local ability = event.ability
	EndAnimation(caster)
	StopSoundEvent("Rubilash.SelfPortraitStart", caster)
	UTIL_Remove(ability.illusion)
end

function rubilash_illusion(caster, ability, duration)
    local modifierKeys = {}
    modifierKeys.outgoing_damage = 0
    modifierKeys.incoming_damage = 1 - (30/100)
    modifierKeys.duration = duration

    local illusions = CreateIllusions( caster, caster, modifierKeys, 1, duration, false, false)
    local illusion = illusions[1]
    illusion.owner = caster
    illusion.hero = caster
    illusion.illusion = true

    StartAnimation(illusion, {duration = 2, activity = ACT_DOTA_VERSUS, rate = 5})
    local newPos = caster:GetAbsOrigin()+caster:GetForwardVector()*320
    newPos = GetGroundPosition(newPos, illusion)
    illusion:SetAbsOrigin(newPos)

    illusion:SetForwardVector(caster:GetForwardVector()*-1)

    illusion.strength_custom = caster.strength_custom
    illusion.agility_custom = caster.agility_custom
    illusion.intellect_custom = caster.intellect_custom
    illusion.spirit_custom = caster.spirit_custom
    illusion.str_bonus = caster.str_bonus
    illusion.agi_bonus = caster.agi_bonus
    illusion.int_bonus = caster.int_bonus
    illusion.spirit_bonus = caster.spirit_bonus
    illusion.r_3_level = caster:GetRuneValue("r", 3)
    illusion.r_3_cast_interval = math.ceil(math.max(RUBILASH_RUNE_R3_MIN_INTERVAL/0.03, (RUBILASH_RUNE_R3_INTERVAL_BASE + RUBILASH_RUNE_R3_INTERVAL_REDUCTION*illusion.r_3_level)/0.03))

    local r_4_level = caster:GetRuneValue("r", 4)
    if r_4_level > 0 then
    	ability:ApplyDataDrivenModifier(caster, illusion, "modifier_rubilash_r_4_ms", {})
    	illusion:SetModifierStackCount("modifier_rubilash_r_4_ms", caster, r_4_level)
    end
    ability:ApplyDataDrivenModifier(caster, illusion, "modifier_rubilash_illusion_spawning", {})
    ability:ApplyDataDrivenModifier(caster, illusion, "modifier_rubilash_illusion_base", {})
    
    illusion:SetRenderColor(0, 0, 0)
	for k, v in pairs(illusion:GetChildren()) do
		if v:GetClassname() == "dota_item_wearable" then
			if not string.match(v:GetModelName(), "weapon") then
				v:AddEffects(EF_NODRAW)
			end
		end
	end
	illusion.color = caster.color
	illusion.block_forward_facing = true
	local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/rubilash/self_portrait_buff_"..illusion.color..".vpcf", illusion, 2)
	set_rubilash_color_visual(illusion)
    return illusion
end


function rubilash_dark_portrait_end(event)
	local caster = event.caster
	local ability = event.ability
	if ability.aoePFX then
		ParticleManager:DestroyParticle(ability.aoePFX, false)
		ability.aoePFX = false
	end
end

function rubilash_self_portrait_success(event)
	local caster = event.caster
	local ability = event.ability
	CustomAbilities:QuickAttachParticle("particles/roshpit/rubilash/rubilash_cast_"..caster.color.."_blur.vpcf", caster, 3)
	if ability.illusion and IsValidEntity(ability.illusion) then
		ability.illusion:RemoveModifierByName("modifier_rubilash_illusion_spawning")
		ability.illusion:SetRenderColor(255, 255, 255)
		for k, v in pairs(ability.illusion:GetChildren()) do
			if v:GetClassname() == "dota_item_wearable" then
				if not string.match(v:GetModelName(), "weapon") then
					v:RemoveEffects(EF_NODRAW)
				end
			end
		end
		
		ability.illusion.color = caster.color
		print(caster.color)
		Events:ColorWearablesAndBase(ability.illusion, RUBILASH_COLORS_DATA[caster.color])
		set_rubilash_color_visual(ability.illusion)
		ability.illusion.effectPFX = CustomAbilities:QuickAttachParticle("particles/roshpit/rubilash/self_portrait_buff_"..ability.illusion.color..".vpcf", ability.illusion, event.duration)
		StartSoundEvent("Rubilash.SelfPortrait.Summoned", ability.illusion)
		local illusion = ability.illusion
		Timers:CreateTimer(8, function()
			if illusion and IsValidEntity(illusion) then
				StopSoundEvent("Rubilash.SelfPortrait.Summoned", illusion)
			end
		end)
		if ability.illusion.r_3_level > 0 then
			ability:ApplyDataDrivenModifier(caster, ability.illusion, "modifier_rubilash_r_3_thinker", {})
		end
	end
	local r_2_level = caster:GetRuneValue("r", 2)
	if r_2_level > 0 then
        local r_2_duration = RUBILASH_RUNE_R2_INVIS_DURATION_BASE + RUBILASH_RUNE_R2_INVIS_DURATION_SCALE*r_2_level
        local invis_duration = Filters:GetAdjustedBuffDuration(caster, r_2_duration, false)

        local pfx2 = CustomAbilities:QuickAttachParticle("particles/roshpit/conjuror/shadow_deity_cloak_of_shadows.vpcf", caster, 2)
        ParticleManager:SetParticleControl(pfx2, 1, Vector(200, 200, 200))
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_invisibility_datadriven", {duration = invis_duration})
        caster:AddNewModifier(caster, ability, "modifier_persistent_invisibility", {duration = invis_duration})
        Timers:CreateTimer(2, function()
        	ParticleManager:DestroyParticle(pfx2, false)
        end)

        -- local pfx3 = CustomAbilities:QuickAttachParticle("particles/roshpit/conjuror/shadow_deity_cloak_of_shadows.vpcf", ability.illusion, 2)
        -- ParticleManager:SetParticleControl(pfx3, 1, Vector(200, 200, 200))
        -- ability:ApplyDataDrivenModifier(caster, ability.illusion, "modifier_invisibility_datadriven", {duration = invis_duration})
        -- ability.illusion:AddNewModifier(ability.illusion, ability, "modifier_persistent_invisibility", {duration = invis_duration})
        -- Timers:CreateTimer(2, function()
        -- 	ParticleManager:DestroyParticle(pfx3, false)
        -- end)
	end
	if caster:HasModifier("modifier_rubilash_glyph_3_1") then
		ability:ApplyDataDrivenModifier(caster, ability.illusion, "modifier_rubilash_self_portrait_glyph_3_1", {})
	end
	Filters:CastSkillArguments(BASE_ABILITY_R, caster)
end

function self_portrait_die(event)
	local illusion = event.unit
	if illusion.effectPFX then
		ParticleManager:DestroyParticle(illusion.effectPFX, false)
		illusion.effectPFX = nil
	end
end

function self_portrait_illusion_think(event)
	local caster = event.caster
	local ability = event.ability
	local illusion = event.target
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), illusion:GetAbsOrigin())
	if distance > 2500 then
		local perpVector = WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi*2/4)
		local randomPerp = WallPhysics:rotateVector(perpVector, 2*math.pi*RandomInt(-5, 5)/80)
		local targetPosition = caster:GetAbsOrigin() + randomPerp*300
		illusion:SetAbsOrigin(targetPosition)
		CustomAbilities:QuickAttachParticle("particles/roshpit/rubilash/self_portrait_buff_"..illusion.color..".vpcf", illusion, 1)
	elseif distance > 400 then
		local perpVector = WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi/4)
		local randomPerp = WallPhysics:rotateVector(perpVector, 2*math.pi*RandomInt(-5, 5)/80)
		local targetPosition = caster:GetAbsOrigin() + randomPerp*300
		illusion:MoveToPosition(targetPosition)
		ability.illusion.block_forward_facing = false
	else
		if not ability.illusion.block_forward_facing then
			if WallPhysics:angle_between_vectors(illusion:GetForwardVector(), caster:GetForwardVector()) > 45 then
				illusion:MoveToPosition(illusion:GetAbsOrigin() + caster:GetForwardVector())
			end
		end
	end
end

function self_portrait_r_3_thinker(event)
	local illusion = event.target
	if not illusion.r_3_interval then
		illusion.r_3_interval = 0
	end
	
	illusion.r_3_interval = illusion.r_3_interval + 1
	if illusion.r_3_interval >= illusion.r_3_cast_interval then
		illusion.r_3_interval = 0
		local radius = RUBILASH_RUNE_R3_RANGE_BASE + RUBILASH_RUNE_R3_RANGE_SCALE*illusion.r_3_level
		local enemies = FindUnitsInRadius(event.caster:GetTeamNumber(), illusion:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false)
		if #enemies > 0 then
			local illusion_cast_table = {}
			illusion_cast_table.caster = event.caster
			illusion_cast_table.ability = event.caster:FindAbilityByName("rubilash_ink_blot_"..illusion.color)
			-- illusion_cast_table.ability = event.caster:FindAbilityByName("rubilash_ink_blot_"..event.caster.color)
			illusion_cast_table.target_points = {}
			illusion_cast_table.target_points[1] = enemies[1]:GetAbsOrigin()
			illusion_cast_table.damage = illusion_cast_table.ability:GetSpecialValueFor("damage")
			illusion_cast_table.damage_radius = illusion_cast_table.ability:GetSpecialValueFor("damage_radius")
			illusion_cast_table.illusion = true

			if illusion and IsValidEntity(illusion) and illusion:IsAlive() and not illusion:IsStunned() then
				rubilash_ink_blot_phase(illusion_cast_table)
				Timers:CreateTimer(illusion_cast_table.ability:GetCastPoint(), function()
					if illusion and IsValidEntity(illusion) and illusion:IsAlive() and not illusion:IsStunned() then
						rubilash_ink_blot(illusion_cast_table)
					end
				end)
			end			
		end	
	end
end