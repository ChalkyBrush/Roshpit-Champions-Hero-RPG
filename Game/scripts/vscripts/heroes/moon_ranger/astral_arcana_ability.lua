function astral_arcana_start(event)
	local caster = event.caster
	local ability = event.ability
	if ability.platformPFX then
		ParticleManager:DestroyParticle(ability.platformPFX, false)
		ability.platformPFX = false
	end
	EmitSoundOn("Astral.ArcanaQCastVO", caster)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Astral.ArcanaQCast", caster)
	CustomAbilities:QuickAttachParticle("particles/roshpit/astral_ranger/arcana_q_cast.vpcf", caster, 2)
	local particleName = "particles/roshpit/astral_ranger/arcana_ability_platform.vpcf"
	local platformPFX = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	local platformPosition = caster:GetAbsOrigin()+Vector(0,0,280)
	caster:Stop()
	ability.zHeight = caster:GetAbsOrigin().z + 280
	ParticleManager:SetParticleControl(platformPFX, 0, platformPosition)
	ParticleManager:SetParticleControl(platformPFX, 1, Vector(5,5,5))
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_astral_arcana_lifting", {duration = 2})
	ability.platformPFX = platformPFX
	Filters:CastSkillArguments(1, caster)
end

function astral_arcana_passive_think(event)
	local caster = event.caster
	local ability = event.ability
	local d_a_level = Runes:GetTotalRuneLevel(caster, 4, "d_a_arcana1", "astral")
	if d_a_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_astral_rune_d_a", {})
		local damageStacks = (caster:GetStrength() + caster:GetAgility() + caster:GetIntellect())*0.5*d_a_level
		caster:SetModifierStackCount("modifier_astral_rune_d_a", caster, damageStacks)
	end
end

function astral_arcana_lifting_think(event)
	local caster = event.caster
	local ability = event.ability
	caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,15))
	if caster:GetAbsOrigin().z >= ability.zHeight then
		caster:RemoveModifierByName("modifier_astral_arcana_lifting")
		ability.heroZ = caster:GetAbsOrigin().z
		local duration = event.duration
		if caster:HasModifier("modifier_astral_glyph_5_1") then
			duration = duration+2.5
		end 
		local platformDuration = Filters:GetAdjustedBuffDuration(caster, duration, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_astral_arcana_on_platform", {duration = platformDuration})
		StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_SPAWN, rate=1.2, translate="loadout"})
		local a_a_level = Runes:GetTotalRuneLevel(caster, 1, "a_a_arcana1", "astral")
		if a_a_level > 0 then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_astral_arcana_a_a_effect", {})
			caster:SetModifierStackCount("modifier_astral_arcana_a_a_effect", caster, a_a_level)
		end
		local c_a_level = Runes:GetTotalRuneLevel(caster, 3, "c_a_arcana1", "astral")
		if c_a_level > 0 then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_astral_rune_c_a", {})
			caster:SetModifierStackCount("modifier_astral_rune_c_a", caster, c_a_level)
		end

		-- caster:SetModifierStackCount("modifier_astral_arcana_on_platform", caster, ability.heroZ)
	end
end

function arcana_platform_move(event)
	local caster = event.caster
	local ability = event.ability
	if caster:HasModifier("modifier_star_blink_moving") then
		return false
	end
	local platformStopPosition = Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, ability.heroZ)
	caster:SetAbsOrigin(platformStopPosition)
	caster:RemoveModifierByName("modifier_astral_arcana_on_platform")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_astral_arcana_falling", {duration = 2})
	ability.fallVelocity = 6
end

function astral_arcana_falling_think(event)
	local caster = event.caster
	local ability = event.ability
	ability.fallVelocity = ability.fallVelocity + 0.5
	caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,ability.fallVelocity))
	if caster:GetAbsOrigin().z < GetGroundHeight(caster:GetAbsOrigin(), caster) + 10 then
		ParticleManager:DestroyParticle(ability.platformPFX, false)
		ability.platformPFX = false
		caster:RemoveModifierByName("modifier_astral_arcana_falling")
		local position = caster:GetAbsOrigin()
		local pfx = ParticleManager:CreateParticle( "particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( pfx, 0, position )
		ParticleManager:SetParticleControl( pfx, 1, Vector(200, 200, 200) )
		Timers:CreateTimer(2, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_SPAWN, rate=1.2, translate="loadout"})
	end
end

function arcana_star_blink_move(caster, starAbility)
	local ability = caster:FindAbilityByName("astral_arcana_ability")
	caster:RemoveModifierByName("modifier_star_blink_moving")
	if ability.platformPFX then
		ParticleManager:DestroyParticle(ability.platformPFX, false)
		ability.platformPFX = false
	end
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Astral.ArcanaQCast", caster)
	CustomAbilities:QuickAttachParticle("particles/roshpit/astral_ranger/arcana_q_cast.vpcf", caster, 2)
	local particleName = "particles/roshpit/astral_ranger/arcana_ability_platform.vpcf"
	local platformPFX = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	local platformPosition = Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, GetGroundHeight(caster:GetAbsOrigin(), caster)+280)
	caster:SetAbsOrigin(platformPosition)
	if not caster:IsChanneling() then
		caster:Stop()
	end
	ability.zHeight = caster:GetAbsOrigin().z
	ParticleManager:SetParticleControl(platformPFX, 0, platformPosition)
	ParticleManager:SetParticleControl(platformPFX, 1, Vector(5,5,5))
	ability.platformPFX = platformPFX	
	ability.heroZ = caster:GetAbsOrigin().z
	local modifier = caster:FindModifierByName("modifier_astral_arcana_on_platform")
	local duration = modifier:GetRemainingTime() + 4
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_astral_arcana_on_platform", {duration = duration})
end

function on_cloud_think(event)
	local caster = event.caster
	local ability = event.ability
	local vision = caster:GetCurrentVisionRange()
	AddFOWViewer(caster:GetTeamNumber(), caster:GetAbsOrigin(), vision, 1.5, false)
end