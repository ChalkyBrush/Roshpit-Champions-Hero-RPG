require('heroes/arc_warden/jex_constants')
require('heroes/base_ability')
jex_cosmic_nature_w = class(base_ability)

function jex_cosmic_nature_w:GetManaCostBase(level)
    return 0
end

function jex_cosmic_nature_w:GetBehaviorBase()
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL + DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_TOGGLE
end

function jex_cosmic_nature_w:GetAbilitySlot()
    return DOTA_W_SLOT
end

function jex_cosmic_nature_w:GetCastPoint()
    return 0
end

function jex_cosmic_nature_w:GetCooldownBase(level)
    return 0
end

function jex_cosmic_nature_w:IsToggle()
    return true
end

function jex_cosmic_nature_w:OnToggle()
    if IsServer() then
        local ability = self
        local caster = self:GetCaster()
        if self:GetToggleState() then

            caster:AddNewModifier(caster, ability, "modifier_jex_cosmic_nature_w", {})
            caster:SetModifierStackCount("modifier_jex_cosmic_nature_w", caster, GetOnibiTotalTechLevel(caster, "nature", "cosmic", "W"))
        
            EmitSoundOn("Jex.Equilibrium.Activate", caster)
            StartAnimation(caster, {duration = 0.3, activity = ACT_DOTA_OVERRIDE_ABILITY_4, rate = 1.5})
        else
            caster:RemoveModifierByName("modifier_jex_cosmic_nature_w")
        end
    end
end

modifier_jex_cosmic_nature_w = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_jex_cosmic_nature_w", "heroes/arc_warden/jex_cosmic_nature_w", LUA_MODIFIER_MOTION_NONE)

function modifier_jex_cosmic_nature_w:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MANA_BONUS
	}

	return funcs
end
function modifier_jex_cosmic_nature_w:OnCreated()
    if not IsServer() then
        return
    end
    self:StartIntervalThink(JEX_COSMIC_NATURE_W_MANA_DRAIN_RATE)
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_Q_FLAT_MANA_COST,
        MODIFIER_ROSHPIT_W_FLAT_MANA_COST,
        MODIFIER_ROSHPIT_E_FLAT_MANA_COST,
        MODIFIER_ROSHPIT_R_FLAT_MANA_COST,
        MODIFIER_ROSHPIT_ARMOR_PIERCE_BONUS,
        MODIFIER_ROSHPIT_SPELL_PIERCE_BONUS
    })
end

function modifier_jex_cosmic_nature_w:GetModifierBaseAttack_BonusDamage()
    return JEX_COSMIC_NATURE_W_BONUS_BASE_ATTACK_DAMAGE[self:GetAbility():GetLevel()]
end

function modifier_jex_cosmic_nature_w:GetRoshpitQFlatManaCostModifier()
    return JEX_COSMIC_NATURE_W_MANA_COST_INCREASE[self:GetAbility():GetLevel()]
end
function modifier_jex_cosmic_nature_w:GetRoshpitWFlatManaCostModifier()
    return JEX_COSMIC_NATURE_W_MANA_COST_INCREASE[self:GetAbility():GetLevel()]
end
function modifier_jex_cosmic_nature_w:GetRoshpitEFlatManaCostModifier()
    return JEX_COSMIC_NATURE_W_MANA_COST_INCREASE[self:GetAbility():GetLevel()]
end
function modifier_jex_cosmic_nature_w:GetRoshpitRFlatManaCostModifier()
    return JEX_COSMIC_NATURE_W_MANA_COST_INCREASE[self:GetAbility():GetLevel()]
end
function modifier_jex_cosmic_nature_w:GetRoshpitArmorPierceBonus()
    return JEX_COSMIC_NATURE_W_PIERCES_PER_TECH * self:GetStackCount()
end
function modifier_jex_cosmic_nature_w:GetRoshpitSpellPierceBonus()
    return JEX_COSMIC_NATURE_W_PIERCES_PER_TECH * self:GetStackCount()
end
function modifier_jex_cosmic_nature_w:GetModifierMoveSpeedBonus_Constant(params)
    return JEX_COSMIC_NATURE_W_MOVESPEED_PER_TECH * self:GetStackCount()
end
function modifier_jex_cosmic_nature_w:GetModifierManaBonus()
    return JEX_COSMIC_NATURE_W_MAX_MANA_PER_Q4 * self:GetParent():GetRuneValue("q", 4)
end

function modifier_jex_cosmic_nature_w:OnIntervalThink()
	local caster = self:GetParent()
	local ability = self:GetAbility()
    local e_4_level = caster:GetRuneValue("e", 4)
	local mana_usage = math.max(JEX_COSMIC_NATURE_W_MANA_DRAIN[ability:GetLevel()] - JEX_COSMIC_NATURE_W_RED_MANA_DRAIN_PER_E4 * e_4_level, 0)
	if mana_usage > caster:GetMana() then
		ability:ToggleAbility()
	end
	caster:ReduceMana(mana_usage)
end