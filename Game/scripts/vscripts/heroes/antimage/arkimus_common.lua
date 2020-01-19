function CreateZonisBeam(attachPointA, attachPointB)
	local particleName = "particles/roshpit/arkimus/zonis_lightning.vpcf"
	local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(lightningBolt, 0, Vector(attachPointA.x, attachPointA.y, attachPointA.z))
	ParticleManager:SetParticleControl(lightningBolt, 1, Vector(attachPointB.x, attachPointB.y, attachPointB.z))
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(lightningBolt, false)
		ParticleManager:ReleaseParticleIndex(lightningBolt)
	end)
end

modifier_arkimus_stun = class ({})
LinkLuaModifier("modifier_arkimus_stun", "heroes/antimage/arkimus_common", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_stun:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end
function modifier_arkimus_stun:IsHidden()
    return false
end
function modifier_arkimus_stun:IsDebuff()
    return true
end
function modifier_arkimus_stun:IsStunDebuff()
    return true
end
function modifier_arkimus_stun:GetEffectName()
    return "particles/roshpit/items/violet_guard_2.vpcf"
end
function modifier_arkimus_stun:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end
function modifier_arkimus_stun:GetOverrideAnimation()
    return ACT_DOTA_FLAIL
end