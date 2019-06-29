modifier_paladin_q4_shield = class({})
local class = modifier_paladin_q4_shield

function class:DeclareFunctions()
	local funcs = {
	}
end

function class:OnCreated()
	local target = self:GetParent()
	if not target.paladin_q3_shield_particle then
		target.paladin_q3_shield_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/divine_aegis_oval_highlight.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(target.paladin_q3_shield_particle, 0, target, PATTACH_ABSORIGIN_FOLLOW, "follow_origin", target:GetAbsOrigin(), true)
	end
end

function class:OnDestroy()
	local target = self:GetParent()
	if target.paladin_q3_shield_particle then
		ParticleManager:DestroyParticle(target.paladin_q3_shield_particle, false)
		target.paladin_q3_shield_particle = nil
	end
end

function class:IsDebuff()
	return false
end

function class:IsHidden()
	return false
end

function class:GetTexture()
	return "rpc/paladin_q_4"
end
