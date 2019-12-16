require('heroes/crystal_maiden/init')

function firestorm_precast(event)
	local caster = event.caster
	local ability = event.ability
	-- caster:AddNewModifier(caster, nil, "modifier_animation", {translate="freeze", duration=0.2})
	-- caster:AddNewModifier(caster, nil, "modifier_animation_translate", {translate="wardstaff", duration=0.2})
	StartAnimation(caster, {duration = 1.5, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1.0, translate = "wardstaff"})
	CustomAbilities:QuickAttachParticle("particles/roshpit/sorceress/firestorm_precast.vpcf", caster, 2.5)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_firestorm_precast", {duration = 1})
	Helper.initializeAbilityRunes(caster, 'sorceress', 'q')
	Helper.initializeAbilityRunes(caster, 'sorceress', 'w')
	Helper.initializeAbilityRunes(caster, 'sorceress', 'e')
	Helper.initializeAbilityRunes(caster, 'sorceress', 'r')
	caster.q_3_level = caster:GetRuneValue("q", 3)
	EmitSoundOn("Sorceress.FirestormPrecast.VO", caster)
end

function begin_firestorm(event)
	local caster = event.caster
	local ability = event.ability
	local radius = event.radius
	local position = event.target_points[1]
	ability.soundInterval = 0
	ability.position = position
	-- EmitSoundOnLocationWithCaster(position, "Sorceress.Firestorm.Cast", caster)
	local particleName = "particles/items_fx/dagon.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_POINT, caster)
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(pfx, 1, position + Vector(0, 0, 40))
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	EmitSoundOn("Sorceress.Firestorm.CastHighlight", caster)
	if caster:HasModifier("modifier_sorceress_glyph_6_1") then
		local fire_thinker = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, caster:GetTeamNumber())
		fire_thinker.firestorm_position = position
		ability:ApplyDataDrivenModifier(caster, fire_thinker, "modifier_sorceress_firestorm_channel", {duration = 4.5})
		Timers:CreateTimer(0.03, function()
			ability:EndChannel(false)
			caster:Stop()
		end)
		fire_thinker:FindAbilityByName("dummy_unit"):SetLevel(1)
		fire_thinker.soundInterval = 0
	else
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_firestorm_precast", {duration = 4.5})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_sorceress_firestorm_channel", {duration = 4.5})
	end
	Filters:CastSkillArguments(1, caster)
	local q_1_level = caster:GetRuneValue("q", 1)
	if q_1_level > 0 then
		if ability:GetCooldownTimeRemaining() > 0 then
			caster.sunlance = true
			CustomAbilities:AddAndOrSwapSkill(caster, "sorceress_fire_arcana_q", "sorceress_sun_lance", 0)
			print(" REPLACE SUN LANCE?")
		end
	end
	ability.q_4_level = caster:GetRuneValue("q", 4)
	if ability.q_4_level > 0 then
		local avatarDuration = Filters:GetAdjustedBuffDuration(caster, 12, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_fire_avatar", {duration = avatarDuration})
		caster:SetModifierStackCount("modifier_fire_avatar", caster, ability.q_4_level)
	end
end

function channel_interrupt(event)
	local caster = event.caster
	EndAnimation(caster)
end

function firestorm_channel_end(event)
	local target = event.target
	if target.firestorm_position then
		UTIL_Remove(target)
	end
end

function firestorm_channel_think(event)
	local caster = event.caster
	local ability = event.ability
	local radius = event.radius
	local target = event.target
	local position = ability.position
	local soundInterval = 0
	if target.firestorm_position then
		position = target.firestorm_position
		target.soundInterval = target.soundInterval + 1
		soundInterval = target.soundInterval
	else
		ability.soundInterval = ability.soundInterval + 1
		soundInterval = ability.soundInterval
		if soundInterval == 1 then
			StartAnimation(caster, {duration = 3.5, activity = ACT_DOTA_CAST_ABILITY_4, rate = 1.0, translate = "wardstaff"})
		end
		if soundInterval % 3 == 1 then
			local particleName = "particles/items_fx/dagon.vpcf"
			local pfx = ParticleManager:CreateParticle(particleName, PATTACH_POINT, caster)
			ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(pfx, 1, position + Vector(0, 0, 40))
			Timers:CreateTimer(2, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
			-- EmitSoundOn("Sorceress.Firestorm.Cast2", caster)
		end
	end
	if soundInterval % 3 == 1 then
		EmitSoundOnLocationWithCaster(position, "Sorceress.Firestorm.Cast", target)
	end
	local pfx2 = ParticleManager:CreateParticle("particles/roshpit/sorceress/firestorm_aoe_circle.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx2, 0, position)
	ParticleManager:SetParticleControl(pfx2, 1, Vector(1, 1, 1) * radius)
	ParticleManager:SetParticleControl(pfx2, 2, Vector(1, 1, 1) * (radius * 1.2))
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(pfx2, false)
	end)
	local pfx = ParticleManager:CreateParticle("particles/roshpit/sorceress/firestorm_indicator_2_immortal1.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, position)
	ParticleManager:SetParticleControl(pfx, 1, Vector(1, 1, 1) * radius)
	ParticleManager:SetParticleControl(pfx, 2, Vector(1, 1, 1) * radius)
	ParticleManager:SetParticleControl(pfx, 3, position)
	ParticleManager:SetParticleControl(pfx, 7, Vector(radius, radius, radius))
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	for i = 0, 5, 1 do
		Timers:CreateTimer(i * 0.5, function()
			GridNav:DestroyTreesAroundPoint(position, radius, false)
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				for _, enemy in pairs(enemies) do
					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_sorceress_firestorm", {duration = 10})
					local damage = event.damage
					if caster:HasModifier("modifier_sorceress_glyph_1_1") then
						damage = damage * SORCERESS_GLYPH_1_1_Q_DAMAGE_MULT
					end
					if caster:HasModifier("modifier_sorceress_immortal_ice_avatar") then
						Filters:TakeArgumentsAndApplyDamage(enemy, caster.origCaster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_Q, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
					else
						Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_Q, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
					end
				end
			end
		end)
	end
end

function sorceress_firestorm_debuff_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local luck = RandomInt(1, 6)
	if luck == 1 then
		local damage = event.damage
		if caster:HasModifier("modifier_sorceress_glyph_1_1") then
			damage = damage * SORCERESS_GLYPH_1_1_Q_DAMAGE_MULT
		end
		sorceress_firestorm_impact(caster, target, ability, damage, false, 1)
	end
end

function sorceress_firestorm_impact(caster, target, ability, damage, bBurn, amp)
	if ability then
		if not ability.particle_count then
			ability.particle_count = 0
		end
		print(ability.particle_count)
		if ability.particle_count < 10 then
			CustomAbilities:QuickAttachParticle("particles/roshpit/sorceress/firestorm_impact.vpcf", target, 3)
			print("particle")
			ability.particle_count = ability.particle_count + 1
			Timers:CreateTimer(2, function()
				ability.particle_count = ability.particle_count - 1
			end)
		end
	end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 160, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		--EmitSoundOn("Sorceress.Firestorm.Impact", target)
		for _, enemy in pairs(enemies) do
			if caster:HasModifier("modifier_sorceress_immortal_ice_avatar") then
				Filters:TakeArgumentsAndApplyDamage(enemy, caster.origCaster, damage * amp, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_Q, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
			else
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage * amp, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_Q, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
			end
			if bBurn then
				local burnDuration = SORCERESS_Q3_BASE_DURATION + (caster.q_3_level * SORCERESS_Q3_ADD_DURATION)
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
	-- local avatarDuration = Filters:GetAdjustedBuffDuration(caster, 7 + 0.2*ability.r_4_level, false)
	-- ability.wingsPFX = ParticleManager:CreateParticle("particles/roshpit/sorceress/fire_avatar_wings_omni_omni.vpcf", PATTACH_POINT_FOLLOW, caster)
	-- for i = 0, 4, 1 do
	-- ParticleManager:SetParticleControlEnt(ability.wingsPFX, i, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	-- end
	-- ParticleManager:SetParticleControlEnt(ability.wingsPFX, 5, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	-- ParticleManager:SetParticleControl(ability.wingsPFX, 7, Vector(avatarDuration, avatarDuration, avatarDuration))
	-- end
end

function fire_avatar_end(event)
	-- local caster = event.caster
	-- local ability = event.ability
	-- if ability.wingsPFX then
	-- ParticleManager:DestroyParticle(ability.wingsPFX, false)
	-- ParticleManager:ReleaseParticleIndex(ability.wingsPFX)
	-- ability.wingsPFX = false
	-- end
end

function passive_think(event)
	local caster = event.caster
	caster.q_2_level = caster:GetRuneValue("q", 2)
end
