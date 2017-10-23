local function applyShield(caster, ability)
    if caster.d_c_level > 0 then
        local duration = Filters:GetAdjustedBuffDuration(caster, E4_DURATION, false)
        local procChance = E4_PROC_CHANCE
        if caster:HasModifier("modifier_axe_glyph_6_2") then
            procChance = T62_SHIELD_CHANCE_PERCENT
        end
        local shieldsCount = Runes:Procs(caster.d_c_level, procChance, 1)
        print("runes count " .. caster.d_c_level)
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_axe_rune_c_d_shield", {duration = duration})
        caster:SetModifierStackCount("modifier_axe_rune_c_d_shield", caster, shieldsCount)
    end
end

local function amplifyShieldsCount(caster, ability, amplify)
    local shieldsCount = caster:GetModifierStackCount( "modifier_axe_rune_c_d_shield", ability )
    shieldsCount = shieldsCount * amplify
    caster:SetModifierStackCount("modifier_axe_rune_c_d_shield", caster, shieldsCount)
end

local module = {}
module.applyShield = applyShield
module.amplifyShieldsCount = amplifyShieldsCount
return module