modifier_paladin_q2_aura = class({})
local class = modifier_paladin_q2_aura

function class:DeclareFunctions()
	local funcs = {
}
end

function class:OnCreated()
	self:StartIntervalThink(0.5)
end

function class:OnIntervalThink()
	local caster = self:GetCaster()
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	local q_2_level = caster:GetRuneValue("q", 2)
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * 0.8 * q_2_level / 2
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			CustomAbilities:QuickAttachParticle("particles/items2_fx/radiance.vpcf", enemy, 1)
			damage = Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
			if caster:HasModifier("modifier_paladin_glyph_3_2") then
				local heal = damage * (PALADIN_GLYPH_3_2_LIFESTEAL / 100)
				Filters:ApplyHeal(caster, caster, heal, true, true)
			end
		end
	end 
end

function class:IsDebuff()
	return false
end

function class:IsHidden()
	return true
end