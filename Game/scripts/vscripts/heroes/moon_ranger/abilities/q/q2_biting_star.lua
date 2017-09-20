require('heroes/moon_ranger/init')
function attackLand(event)
    local caster = event.attacker
    local target = event.target
    local damage = caster:GetAverageTrueAttackDamage(caster)
    local b_a_level = 0
    local procChance = 0
    local damageMultiply = 0

    if target.dummy then
        return false
    end

    if caster:HasModifier("modifier_astral_arcana1") then
        b_a_level = Runes:GetTotalRuneLevel(caster, 2, "b_a_arcana1", "astral")
        if caster:HasModifier("modifier_astral_immortal_weapon_2") then
            procChance = WEAPON2_ARCANA1_Q2_PROC_CHANCE
        else
            procChance = ARCANA1_Q2_PROC_CHANCE
        end
        damageMultiply = ARCANA1_Q2_ATTACK_DAMAGE_PERCENT
    else
        b_a_level = Runes:GetTotalRuneLevel(caster, 2, "b_a", "astral")
        if caster:HasModifier("modifier_astral_immortal_weapon_2") then
            procChance = WEAPON2_Q2_PROC_CHANCE
        else
            procChance = Q2_PROC_CHANCE
        end
        damageMultiply = Q2_ATTACK_DAMAGE_PERCENT
    end

    if b_a_level == nil or b_a_level <= 0 then
        return false
    end
    
    procChance = getProcChance(caster, procChance)

    local luck = RandomInt(1, 100)
    if luck <= procChance then
        local ability = event.ability
        local pureDamage = damage*(b_a_level*damageMultiply)
        local particleName = "particles/units/heroes/hero_mirana/mirana_starfall_attack.vpcf"
        local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
        ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
        Timers:CreateTimer(0.6, function()
            ParticleManager:DestroyParticle( pfx, false )
        end)
        Timers:CreateTimer(0.45, -- Start this timer 10 game-time seconds later
            function()
                if target:IsAlive() then
                    Filters:TakeArgumentsAndApplyDamage(target, caster, pureDamage, DAMAGE_TYPE_PURE, 0, RPC_ELEMENT_COSMOS, RPC_ELEMENT_NONE)
                    EmitSoundOn("Ability.StarfallImpact", target)
                    if caster:HasModifier("modifier_astral_arcana1") then
                        ability = caster:FindAbilityByName("astral_arcana_ability")
                        ability:ApplyDataDrivenModifier(caster, target, "modifier_astral_b_a_arcana_armor_loss", {duration = 6})
                        target:SetModifierStackCount("modifier_astral_b_a_arcana_armor_loss", ability, b_a_level)
                    else
                        ability:ApplyDataDrivenModifier(caster, target, "modifier_astral_b_a_armor_loss", {duration = 6})
                        target:SetModifierStackCount("modifier_astral_b_a_armor_loss", ability, b_a_level)
                    end
                end
            end)
    end
end
return {
    attackLand = attackLand
}