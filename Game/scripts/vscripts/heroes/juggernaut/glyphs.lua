require('heroes/juggernaut/constants')
function lifesteal_glyph(event)
    local attacker = event.attacker
    local ability = attacker.InventoryUnit:FindAbilityByName("hand_slot")
    local damage = event.attack_damage
    local lifesteal = math.floor(damage*T1_LIFESTEAL_PERCENT/100)

    Filters:ApplyHeal(attacker, attacker, lifesteal, true)
    local particleName = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
    local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, attacker )
    ParticleManager:SetParticleControlEnt(pfx, 0, attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt( pfx, 1, attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin()+Vector(0,0,70), true )
    Timers:CreateTimer(1, function()
        ParticleManager:DestroyParticle( pfx, false )
    end)
end
