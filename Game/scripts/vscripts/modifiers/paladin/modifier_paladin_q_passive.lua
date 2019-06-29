modifier_paladin_q_passive = class({})
local class = modifier_paladin_q_passive

local lua_modifiers = {
	"modifier_paladin_q3_shield"
}
for _, modifier in pairs(lua_modifiers) do
	LinkLuaModifier(modifier, "modifiers/paladin/"..modifier, LUA_MODIFIER_MOTION_NONE)
end

function class:DeclareFunctions()
	local funcs = {MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function class:OnAttackLanded(event)
	--print("HERE modifier_paladin_q_passive")
	local caster = self:GetParent()
	if event.attacker ~= caster then return end
	if caster.q3_level and caster.q3_level > 0 then
		local duration = 0.8 + caster.q3_level * 0.1
		local max_stacks = 1
		if not caster.weapon then
			--print("[modifier_paladin_q_passive] error caster.weapon is null")
			return
		else
			if caster:HasModifier("modifier_paladin_immortal_weapon_1") then
				max_stacks = caster.weapon:GetSpecialValueFor("property_three")
			end
		end
		local stacks = caster:GetModifierStackCount("modifier_paladin_q3_shield", caster)
		caster:AddNewModifier(caster, self:GetAbility(), "modifier_paladin_q3_shield", {duration = duration})
		caster:SetModifierStackCount("modifier_paladin_q3_shield", caster, math.min(stacks + 1, max_stacks))
	end
end

function class:IsDebuff()
	return false
end

function class:IsHidden()
	return true
end
