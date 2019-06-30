function getProcChance(caster, baseChance)
    local runeCount = Runes:GetTotalRuneLevel(caster, 4, "r_4", "astral")
    return baseChance * (1 + R4_PROC_CHANCE_INCREASE * runeCount)
end

function astral_immortal_1_attack_land(event)
    local caster = event.attacker
    local healAmount = caster:GetMaxHealth() * 0.01
    Filters:ApplyHeal(caster, caster, healAmount, true)
    EmitSoundOnLocationWithCaster(caster:GetAbsOrigin() + RandomVector(RandomInt(60, 300)), "Astral.Celestia.Heal", caster)
    local particleName = "particles/roshpit/astral/astral_immo1_heal.vpcf"
    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
    Timers:CreateTimer(1, function()
        ParticleManager:DestroyParticle(pfx, false)
    end)
end
