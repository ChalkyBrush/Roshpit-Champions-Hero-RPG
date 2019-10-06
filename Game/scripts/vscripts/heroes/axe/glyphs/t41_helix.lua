local function cast(caster, ability)
    if not caster:HasModifier("modifier_axe_glyph_4_1") then
        return
    end

    StartAnimation(caster, {duration = 0.24, activity = ACT_DOTA_CAST_ABILITY_3, rate = 1.3, translate = "blood_chaser"})
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    local abilityLevel = ability:GetLevel()
    local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * RED_GENERAL_GLYPH_4_1_DAMAGE_PROCENT / 100 * abilityLevel
    if #enemies > 0 then
        for _, enemy in pairs(enemies) do
            Filters:ApplyDamageBasic(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL)
        end
    end
    EmitSoundOn("RedGeneral.Helix", caster)
    CustomAbilities:QuickAttachParticle("particles/econ/items/axe/axe_weapon_bloodchaser/axe_attack_blur_counterhelix_bloodchaser.vpcf", caster, 0.5)
end

local module = {}
module.cast = cast
return module
