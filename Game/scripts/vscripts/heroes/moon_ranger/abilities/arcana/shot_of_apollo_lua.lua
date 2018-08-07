shot_of_apollo = class({})

LinkLuaModifier("modifier_apollo_channel", "modifiers/astral/modifier_apollo_channel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_apollo_strikes", "modifiers/astral/modifier_apollo_strikes", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_apollo_outgoing_shots", "modifiers/astral/modifier_apollo_outgoing_shots", LUA_MODIFIER_MOTION_NONE)

function shot_of_apollo:CastFilterResultTarget(hTarget)
	if self.active == false then
		return UF_FAIL_CUSTOM
	end
	if hTarget:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		return UF_FAIL_FRIENDLY
	end

	return UF_SUCCESS
end

function shot_of_apollo:GetCustomCastErrorTarget(hTarget)
	if self.active == false then
		return "#dota_hud_error_rpc_ability_is_inactive"
	end

	return ""
end

function shot_of_apollo:OnSpellStart()
	local particleName = "particles/roshpit/astral/apollo_beam.vpcf"
	local particleName2 = "particles/econ/items/lion/lion_demon_drain/lion_spell_mana_drain_demon.vpcf"
	local ability = self
	local caster = self:GetCaster()
	local target = ability:GetCursorTarget()
	ability.target = target
	caster:AddNewModifier(caster, ability, "modifier_apollo_channel", {duration = ability:GetChannelTime()})
	StartAnimation(caster, {duration=2.0, activity=ACT_DOTA_GENERIC_CHANNEL_1, rate=0.8})
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_bow_eyes", caster:GetAbsOrigin(), true)
	for i = 0, 60, 1 do
		Timers:CreateTimer(i*0.03, function()
				local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), target:GetAbsOrigin())/2
				local direction = ((target:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
			ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin()+direction*distance+Vector(0,0,(1250/40)*i))
		end)
	end
	if caster:HasModifier("modifier_apollo_channel") then
		local pfx2 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
		ParticleManager:SetParticleControlEnt(pfx2, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		for i = 0, 60, 1 do
			Timers:CreateTimer(i*0.03, function()
				local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), target:GetAbsOrigin())/2
				local direction = ((caster:GetAbsOrigin()-target:GetAbsOrigin())*Vector(1,1,0)):Normalized()
				ParticleManager:SetParticleControl(pfx2, 1, target:GetAbsOrigin()+direction*distance+Vector(0,0,(1250/40)*i))
			end)
		end
		ability.pfx2 = pfx2
	end
	ability.pfx = pfx
	StartSoundEvent("Astral.ApolloStart", caster)
	ability.a_b_level = Runes:GetTotalRuneLevelGeneric(caster, 1, 1)
	ability.c_b_level = Runes:GetTotalRuneLevelGeneric(caster, 3, 1)
	ability.d_b_level = Runes:GetTotalRuneLevelGeneric(caster, 4, 1)
end

function shot_of_apollo:GetBehavior()
	return self.BaseClass.GetBehavior(self)
end

function shot_of_apollo:GetCastRange(vector, target)
	return math.max(2000, self:GetCaster():GetAttackRange())
end

function shot_of_apollo:OnChannelFinish(bInterrupted)
	local ability = self
	local caster = self:GetCaster()
	caster:RemoveModifierByName("modifier_apollo_channel")
	if bInterrupted then
		EndAnimation(caster)
		if ability.pfx then
			ParticleManager:DestroyParticle(ability.pfx, false)
			ability.pfx = false
		end
		if ability.pfx2 then
			ParticleManager:DestroyParticle(ability.pfx2, false)
			ability.pfx2 = false
		end
		StopSoundEvent("Astral.ApolloStart", caster)
		ability.target = nil
	else
		local target = ability.target
		local shots = ability:GetSpecialValueFor("shots")
		if caster:HasModifier("modifier_astral_glyph_3_1") then
			shots = 9
		end
		local b_b_level = 400 --Runes:GetTotalRuneLevelGeneric(caster, 2, 1)
		shots = shots + Runes:Procs(b_b_level, 2*ability:GetLevel(), 1)
		ability.shots = shots
		if ability.pfx then
			ParticleManager:DestroyParticle(ability.pfx, false)
			ability.pfx = false
		end
		if ability.pfx2 then
			ParticleManager:DestroyParticle(ability.pfx2, false)
			ability.pfx2 = false
		end
		local pfx = ParticleManager:CreateParticle("particles/roshpit/astral/apollo_beam.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_bow_eyes", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		local pfx2 = ParticleManager:CreateParticle("particles/roshpit/astral/apollo_beam.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(pfx2, 1, caster, PATTACH_POINT_FOLLOW, "attach_bow_eyes", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx2, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		Timers:CreateTimer(0.4, function()
			ParticleManager:DestroyParticle(pfx, false)
			ParticleManager:DestroyParticle(pfx2, false)
		end)
		EmitSoundOn("Astral.ApolloLink", target)
		if target:IsAlive() then
			caster:AddNewModifier(caster, ability, "modifier_apollo_outgoing_shots", {})
			caster:SetModifierStackCount("modifier_apollo_outgoing_shots", caster, shots)
			target:AddNewModifier(caster, ability, "modifier_apollo_strikes", {})
			target:SetModifierStackCount("modifier_apollo_strikes", caster, shots)
			ability.active = false
		end
		Filters:CastSkillArguments(2, caster)
	end
end