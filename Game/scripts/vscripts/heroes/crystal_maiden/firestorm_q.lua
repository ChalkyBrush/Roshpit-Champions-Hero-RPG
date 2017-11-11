require('heroes/crystal_maiden/init')

function firestorm_precast(event)
	local caster = event.caster
	local ability = event.ability
	-- caster:AddNewModifier(caster, nil, "modifier_animation", {translate="freeze", duration=0.2})
	-- caster:AddNewModifier(caster, nil, "modifier_animation_translate", {translate="wardstaff", duration=0.2})
	StartAnimation(caster, {duration=1.5, activity=ACT_DOTA_CAST_ABILITY_2, rate=1.0, translate="wardstaff"})
	CustomAbilities:QuickAttachParticle("particles/roshpit/sorceress/firestorm_precast.vpcf", caster, 2.5)
    Helper.initializeAbilityRunes(caster, 'sorceress', 'a')
    Helper.initializeAbilityRunes(caster, 'sorceress', 'b')
    Helper.initializeAbilityRunes(caster, 'sorceress', 'c')
    Helper.initializeAbilityRunes(caster, 'sorceress', 'd')
    caster.c_a_level = Runes:GetTotalRuneLevelGeneric(caster, 3, 0)
end

function begin_firestorm(event)
	local caster = event.caster
	local ability = event.ability
	local radius = event.radius
	local position = event.target_points[1]

	EmitSoundOnLocationWithCaster(position, "Sorceress.Firestorm.Cast", caster)
	local pfx2 = ParticleManager:CreateParticle("particles/roshpit/sorceress/firestorm_aoe_circle.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx2, 0, position)
	ParticleManager:SetParticleControl(pfx2, 1, Vector(1,1,1)*radius)
	ParticleManager:SetParticleControl(pfx2, 2, Vector(1,1,1)*(radius*1.2))
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(pfx2, false)
	end)
	local pfx = ParticleManager:CreateParticle("particles/roshpit/sorceress/firestorm_indicator_2_immortal1.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, position)
	ParticleManager:SetParticleControl(pfx, 1, Vector(1,1,1)*radius)
	ParticleManager:SetParticleControl(pfx, 2, Vector(1,1,1)*radius)
	ParticleManager:SetParticleControl(pfx, 3, position)
	ParticleManager:SetParticleControl(pfx, 7, Vector(radius,radius,radius))
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	for i = 0, 5, 1 do
		Timers:CreateTimer(i*0.5, function()
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			if #enemies > 0 then
				for _,enemy in pairs(enemies) do
					if enemy:HasModifier("modifier_sorceress_firestorm") then
					else
						CustomAbilities:QuickAttachParticle("particles/roshpit/sorceress/firestorm_precast.vpcf", enemy, 2.5)
					end
					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_sorceress_firestorm", {duration = 10})
				end
			end 
		end)
	end
	local a_a_level = Runes:GetTotalRuneLevelGeneric(caster, 1, 0)
	if a_a_level > 0 then
		caster.sunlance = true
		CustomAbilities:AddAndOrSwapSkill(caster, "sorceress_fire_arcana_q", "sorceress_sun_lance", 0)
	end
	ability.d_d_level = Runes:GetTotalRuneLevelGeneric(caster, 4, 0)
	if ability.d_d_level > 0 then
		local avatarDuration = Filters:GetAdjustedBuffDuration(caster, 7 + 0.2*ability.d_d_level, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_fire_avatar", {duration = avatarDuration})
		caster:SetModifierStackCount("modifier_fire_avatar", caster, ability.d_d_level)
	end
	Filters:CastSkillArguments(1, caster)
end

function sorceress_firestorm_debuff_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local luck = RandomInt(1, 6)
	if luck == 1 then
		local damage = event.damage
		sorceress_firestorm_impact(caster, target, ability, damage, false, 1)
	end
end

function sorceress_firestorm_impact(caster, target, ability, damage, bBurn, amp)
	CustomAbilities:QuickAttachParticle("particles/roshpit/sorceress/firestorm_impact.vpcf", target, 3)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 160, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		EmitSoundOn("Sorceress.Firestorm.Impact", target)
		for _,enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage*amp, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
			if bBurn then
				local burnDuration = Q3_BASE_DURATION + (caster.c_a_level * Q3_ADD_DURATION)
				local sunLance = caster:FindAbilityByName("sorceress_sun_lance")
				sunLance:ApplyDataDrivenModifier(caster, target, "modifier_sun_lance_burn", {duration = burnDuration})
			end
		end
	end 
end

function fire_avatar_start(event)
	-- local caster = event.caster
	-- local ability = event.ability
	-- if not ability.wingsPFX then
	-- 	local avatarDuration = Filters:GetAdjustedBuffDuration(caster, 7 + 0.2*ability.d_d_level, false)
	-- 	ability.wingsPFX = ParticleManager:CreateParticle("particles/roshpit/sorceress/fire_avatar_wings_omni_omni.vpcf", PATTACH_POINT_FOLLOW, caster)
	-- 	for i = 0, 4, 1 do
	-- 		ParticleManager:SetParticleControlEnt(ability.wingsPFX, i, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	-- 	end
	-- 	ParticleManager:SetParticleControlEnt(ability.wingsPFX, 5, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	-- 	ParticleManager:SetParticleControl(ability.wingsPFX, 7, Vector(avatarDuration, avatarDuration, avatarDuration))
	-- end
end

function fire_avatar_end(event)
	-- local caster = event.caster
	-- local ability = event.ability
	-- if ability.wingsPFX then
	-- 	ParticleManager:DestroyParticle(ability.wingsPFX, false)
	-- 	ParticleManager:ReleaseParticleIndex(ability.wingsPFX)
	-- 	ability.wingsPFX = false
	-- end
end