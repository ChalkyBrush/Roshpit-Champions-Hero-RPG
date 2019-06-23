heroic_fury = class({})
local class = heroic_fury

local lua_modifiers = {
"modifier_paladin_q_passive",
"modifier_paladin_q",
"modifier_paladin_q2_aura",
"modifier_paladin_q3_shield"
}
for _,modifier in pairs(lua_modifiers) do
	LinkLuaModifier(modifier, "modifiers/paladin/"..modifier, LUA_MODIFIER_MOTION_NONE)
end



function class:GetBehavior( table )
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_paladin_glyph_2_1") then return DOTA_ABILITY_BEHAVIOR_TOGGLE end
	return self.BaseClass.GetBehavior(self)
end

function class:GetIntrinsicModifierName()
	return "modifier_paladin_q_passive"
end

function class:GetCustomCastError()
	return ""
end

function class:CastFilterResult()
	return UF_SUCCESS
end

function class:GetCastRange(vector, target)
	return 0
end

function class:OnSpellStart()
	local ability = self
	if bit.band(ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_TOGGLE) == DOTA_ABILITY_BEHAVIOR_TOGGLE then return end
	local caster = self:GetCaster()
	--print("HAS?",caster:HasModifier("modifier_paladin_q_passive"))
	EmitSoundOn("Paladin.HeroicFuryActivate", caster)
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf", caster, 2)
	for i=1,4 do
		caster["q"..i.."_level"] = caster:GetRuneValue("q", i)
	end
	local duration = Filters:GetAdjustedBuffDuration(caster, ability:GetSpecialValueFor("duration"), false)
	caster:AddNewModifier(caster, ability, "modifier_paladin_q", {duration = duration})
	if caster.q2_level > 0 then
		caster:AddNewModifier(caster, ability, "modifier_paladin_q2_aura", {duration = duration})
	end
	if caster:HasModifier("modifier_paladin_immortal_weapon_1") then
		local immortalDuration = Filters:GetAdjustedBuffDuration(caster, caster.weapon:GetSpecialValueFor("property_two"), false)
		caster:AddNewModifier(caster, ability, "modifier_paladin_q3_shield", {duration = immortalDuration})
		caster:SetModifierStackCount("modifier_paladin_q3_shield", caster, 4)
	end
	Filters:CastSkillArguments(1, caster)
end

function class:OnToggle()
	local ability = self
	local caster = self:GetCaster()
	if bit.band(ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_TOGGLE) == DOTA_ABILITY_BEHAVIOR_TOGGLE then
		if ability:GetToggleState() then
			EmitSoundOn("Paladin.HeroicFuryActivate", caster)
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf", caster, 2)
			for i=1,4 do
				caster["q"..i.."_level"] = caster:GetRuneValue("q", i)
			end
			local duration = Filters:GetAdjustedBuffDuration(caster, ability:GetSpecialValueFor("duration"), false)
			caster:AddNewModifier(caster, ability, "modifier_paladin_q", {})
			if caster.q2_level > 0 then
				caster:AddNewModifier(caster, ability, "modifier_paladin_q2_aura", {})
			end
			if caster:HasModifier("modifier_paladin_immortal_weapon_1") then
				local immortalDuration = Filters:GetAdjustedBuffDuration(caster, caster.weapon:GetSpecialValueFor("property_two"), false)
				caster:AddNewModifier(caster, ability, "modifier_paladin_q3_shield", {duration = immortalDuration})
				caster:SetModifierStackCount("modifier_paladin_q3_shield", caster, 4)
			end
			Filters:CastSkillArguments(1, caster)
		else
			caster:RemoveModifierByName("modifier_paladin_q")
			caster:RemoveModifierByName("modifier_paladin_q2_aura")
		end
	end
end