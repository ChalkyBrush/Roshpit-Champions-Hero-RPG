require('heroes/grimstroke/rubilash_w_ability')

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
		CustomAbilities:QuickAttachParticle("particles/roshpit/rubilash/self_portrait_buff_"..ability.illusion.color..".vpcf", ability.illusion, event.duration)
		StartSoundEvent("Rubilash.SelfPortrait.Summoned", ability.illusion)
		local illusion = ability.illusion
		Timers:CreateTimer(8, function()
			if illusion and IsValidEntity(illusion) then
				StopSoundEvent("Rubilash.SelfPortrait.Summoned", illusion)
			end
		end)
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

function get_rubilash_portrait_delay_time(rubilash)
	return 0.5
end