modifier_chernobog_ult_aura = class({})

function modifier_chernobog_ult_aura:IsAura( params )
    return true
end

function modifier_chernobog_ult_aura:IsPurgable()
    return false
end

function modifier_chernobog_ult_aura:GetModifierAura( params )
    return "modifier_chernobog_ult_freeze_special"
end

function modifier_chernobog_ult_aura:GetAuraSearchFlags( params )
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_chernobog_ult_aura:GetAuraSearchTeam( params )
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_chernobog_ult_aura:GetAuraRadius( params )
	local radius = self:GetAbility():GetSpecialValueFor("radius")
	radius = radius + self:GetAbility().r_4_level * 6
    return radius
end

function modifier_chernobog_ult_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_chernobog_ult_aura:GetAuraDuration( params )
    return 0.5
end

modifier_chernobog_ult_freeze_special = class({})

function modifier_chernobog_ult_freeze_special:CheckState()
	local state = {
	[MODIFIER_STATE_FROZEN] = true,
	[MODIFIER_STATE_ROOTED] = true,
	[MODIFIER_STATE_STUNNED] = true,
	}
 
	return state
end

function modifier_chernobog_ult_freeze_special:OnCreated(params)
	local event = {}
	event.caster = self:GetCaster()
	event.ability = self:GetAbility()
	event.target = self:GetParent()
	modifier_chernobog_ult_freeze_special:freeze_start(self:GetCaster(), self:GetAbility(), self:GetParent())

end

function modifier_chernobog_ult_freeze_special:OnDestroy(params)
	local event = {}
	event.caster = self:GetCaster()
	event.ability = self:GetAbility()
	event.target = self:GetParent()
	modifier_chernobog_ult_freeze_special:freeze_end(self:GetCaster(), self:GetAbility(), self:GetParent())

end

function modifier_chernobog_ult_freeze_special:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACKED
	}
 
	return funcs
end

function modifier_chernobog_ult_freeze_special:freeze_start(caster, ability, target)
	-- local caster = event.caster
	-- local target = event.target
	-- local ability = event.ability
	-- CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf", event.target, 2)
	if not IsValidEntity(ability) then
		return false
	end
	if ability.r_1_level > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_nights_procession_a_d_rune", {duration = 6})
		target:SetModifierStackCount("modifier_nights_procession_a_d_rune",caster, ability.r_1_level)
	end
	if ability.r_2_level > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_nights_procession_illusion", {duration = 8})
	end
	table.insert(ability.trappedUnitTable, target)
end

function modifier_chernobog_ult_freeze_special:freeze_end(caster, ability, target)
	if not IsValidEntity(target) then
		return false
	end
	target:RemoveModifierByName("modifier_nights_procession_a_d_rune")
	target:RemoveModifierByName("modifier_nights_procession_illusion")
end

function modifier_chernobog_ult_freeze_special:locked_unit_attack(event)
	local attacker = event.attacker
	local ability = event.ability
	local target = event.target
	--print("HELLO?")
	if not IsValidEntity(ability) then
		return false
	end
	if ability.r_3_level > 0 then
		for i = 1, #ability.trappedUnitTable, 1 do
			local damage = event.attack_damage*0.03*ability.r_3_level
			ApplyDamage({ victim = ability.trappedUnitTable[i], attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_PURE })
		end
	end
end

function modifier_chernobog_ult_freeze_special:OnAttacked(params)
	modifier_chernobog_ult_freeze_special:locked_unit_attack(params)
	return 0
end

function modifier_chernobog_ult_freeze_special:IsPurgable()
    return false
end

function modifier_chernobog_ult_freeze_special:GetStatusEffectName()
	return "particles/status_fx/status_effect_faceless_chronosphere.vpcf"
end