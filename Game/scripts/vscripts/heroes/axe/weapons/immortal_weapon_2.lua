LinkLuaModifier("modifier_axe_immortal_weapon_2_cap", "modifiers/axe/modifier_axe_immortal_weapon_2_cap", LUA_MODIFIER_MOTION_NONE)

local function applyBuff(caster, duration)
    if caster:HasModifier("modifier_axe_immortal_weapon_2") then
        local ability = caster:FindModifierByName("modifier_axe_immortal_weapon_2"):GetAbility()
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_axe_immortal_weapon_2_bonus_movespeed", {duration = duration})
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_axe_immortal_weapon_2_cap", {duration = duration})
        caster:AddNewModifier(caster, ability, "modifier_axe_immortal_weapon_2_cap", {duration = duration})
    end
end
local function getAmp(caster, target)
    if caster:HasModifier("modifier_axe_immortal_weapon_2") then
        if target.mainBoss or target.bossStatus or target.paragon then
            return 1 + RED_GENERAL_IMMORTAL_WEAPON_2_AMPLIFY_PERCENT / 100
        else
            return 1
        end
    else
        return 1
    end
end

local module = {}
module.applyBuff = applyBuff
module.getAmp = getAmp
return module
