require('heroes/moon_ranger/init')
function attackLand(event)
    local caster = event.attacker
    local target = event.target
    local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)
    local q_2_level = 0
    local procChance = 0
    local damageMultiply = 0
    local baseAbilityFor = 0

    if target.dummy then
        return false
    end

    if caster:HasModifier("modifier_astral_arcana1") then
        q_2_level = caster:GetRuneValue("q", 2)
        if caster:HasModifier("modifier_astral_immortal_weapon_2") then
            procChance = WEAPON2_ARCANA1_Q2_PROC_CHANCE
        else
            procChance = ARCANA1_Q2_PROC_CHANCE
        end
        damageMultiply = ASTRAL_ARCANA1_Q2_DMG_PER_ATT
        baseAbilityFor = 1
    else
        q_2_level = caster:GetRuneValue("q", 2)
        if caster:HasModifier("modifier_astral_immortal_weapon_2") then
            procChance = WEAPON2_Q2_PROC_CHANCE
        else
            procChance = Q2_PROC_CHANCE
        end
        damageMultiply = ASTRAL_Q2_DMG_PER_ATT
    end

    if q_2_level == nil or q_2_level <= 0 then
        return false
    end

    procChance = getProcChance(caster, procChance)

    local luck = RandomInt(1, 100)
    if luck <= procChance then
        local ability = event.ability
        local pureDamage = damage * (q_2_level * damageMultiply)
        local particleName = "particles/units/heroes/hero_mirana/mirana_starfall_attack.vpcf"
        local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
        ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
        Timers:CreateTimer(0.6, function()
            ParticleManager:DestroyParticle(pfx, false)
        end)
        Timers:CreateTimer(0.45, function()
            if target:IsAlive() then
                if caster:HasModifier("modifier_astral_arcana1") then
                    baseAbilityFor = 1
                end
                --print(baseAbilityFor)
                Filters:TakeArgumentsAndApplyDamage(target, caster, pureDamage, DAMAGE_TYPE_PURE, baseAbilityFor, RPC_ELEMENT_COSMOS, RPC_ELEMENT_NONE)
                EmitSoundOn("Ability.StarfallImpact", target)
                if caster:HasModifier("modifier_astral_arcana1") then
                    ability = caster:FindAbilityByName("astral_arcana_ability")
                    ability:ApplyDataDrivenModifier(caster, target, "modifier_astral_b_a_arcana_armor_loss", {duration = 6})
                    target:SetModifierStackCount("modifier_astral_b_a_arcana_armor_loss", ability, q_2_level)
                else
                    ability:ApplyDataDrivenModifier(caster, target, "modifier_astral_b_a_armor_loss", {duration = 6})
                    target:SetModifierStackCount("modifier_astral_b_a_armor_loss", ability, q_2_level)
                end
            end
        end)
    end
end
return {
    attackLand = attackLand
}
