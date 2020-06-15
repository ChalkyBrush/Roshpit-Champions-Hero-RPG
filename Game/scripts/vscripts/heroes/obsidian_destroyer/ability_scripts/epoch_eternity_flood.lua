require('heroes/obsidian_destroyer/epoch_constants')
require('heroes/base_ability')
epoch_eternity_flood = class(base_ability)

modifier_epoch_r_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_epoch_r_passive", "heroes/obsidian_destroyer/ability_scripts/epoch_eternity_flood.lua", LUA_MODIFIER_MOTION_NONE)

function epoch_eternity_flood:GetManaCostBase(level)
    return 0
end

function epoch_eternity_flood:GetBehaviorBase()
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_AOE
end

function epoch_eternity_flood:GetAbilitySlot()
    return DOTA_R_SLOT
end

function epoch_eternity_flood:GetCastPoint()
    return 0
end

function epoch_eternity_flood:GetCooldownBase(level)
    return FLAMEWAKER_R_COOLDOWN
end

function epoch_eternity_flood:GetCastRange()
	local range = 1000
end

function epoch_eternity_flood:GetChannelTimeBase()
    return 2.0
end

function epoch_eternity_flood:GetCastAnimation()
    return ACT_DOTA_VICTORY
end

function epoch_eternity_flood:GetIntrinsicModifierName()
	return "modifier_epoch_r_passive"
end

function epoch_eternity_flood:OnSpellStartBase()
    local caster = self:GetCaster()
    local ability = self
    -- if ability.channel_pfx then
    -- 	ParticleManager:DestroyParticle(ability.channel_pfx, false)
    -- 	ability.channel_pfx = nil
    -- end
    -- ability.channel_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_icarus_dive_char_glow.vpcf", PATTACH_CUSTOMORIGIN, caster)
    -- ParticleManager:SetParticleControl(ability.channel_pfx, 0, caster:GetAbsOrigin())
    -- StartSoundEvent("Flamewaker.Cataclysm.Start", caster)
end

function epoch_eternity_flood:OnChannelFinish(interrupted)
    if IsServer() then
    	local caster = self:GetCaster()
    	local ability = self
    	caster:RemoveModifierByName("modifier_channel_start")
		Filters:CastSkillArguments(BASE_ABILITY_R, caster)

    end
end

-- PASSIVE

function modifier_epoch_r_passive:IsHidden()
	return true
end

function modifier_epoch_r_passive:RemoveOnDeath()
	return false
end

function modifier_epoch_r_passive:IsPassive()
	return true
end

function modifier_epoch_r_passive:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({ 
        RPC_ELEMENT_TIME
    })
end


function modifier_epoch_r_passive:DeclareFunctions()
	local funcs = {
		
	}
	return funcs
end
