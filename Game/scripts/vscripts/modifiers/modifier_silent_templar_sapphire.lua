require('/items/constants/helm')

modifier_silent_templar_sapphire = class({})

function modifier_silent_templar_sapphire:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
        MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS
    }

    return funcs
end

function modifier_silent_templar_sapphire:GetModifierAttackRangeBonus(params)
	local bonus = 0
	if IsServer() then
		local hero = self:GetParent()
		bonus = hero.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("sapphire", SILENT_TEMPLAR_SAPPHIRE)
	end
    return bonus
end

function modifier_silent_templar_sapphire:GetModifierProjectileSpeedBonus(params)
	local bonus = 0
	if IsServer() then
		local hero = self:GetParent()
		bonus = hero.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("sapphire", SILENT_TEMPLAR_SAPPHIRE)
	end
    return bonus
end

function modifier_silent_templar_sapphire:OnDestroy()
	if IsServer() then
		local hero = self:GetParent()
		local modifiers = Filters:GetSpecialAttackRangeModifiers()
		local return_to_base = true
		for i = 1, #modifiers, 1 do
			if hero:HasModifier(modifiers[i]) then
				return_to_base = false
			end
		end
		if return_to_base then
			hero:SetAttackCapability(hero.baseAttackCapability)
		end
	end
end

function modifier_silent_templar_sapphire:GetAttackSound(params)
    return "RPC.SilentTemplar.SapphireTranslate"
end

function modifier_silent_templar_sapphire:IsHidden()
    return true
end
