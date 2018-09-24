require('heroes/juggernaut/seinaru_constants')

LinkLuaModifier("modifier_seinaru_glyph_t21_movespeed_cap", "modifiers/seinaru/modifier_seinaru_glyph_t21_movespeed_cap.lua", LUA_MODIFIER_MOTION_NONE)
function lifesteal_glyph(event)
    local attacker = event.attacker
    local damage = event.attack_damage
    local lifesteal = math.floor(damage * SEINARU_GLYPH1_LIFESTEAL)
    local overheal = math.max(attacker:GetHealth() + lifesteal - attacker:GetMaxHealth(),0)

    Filters:ApplyHeal(attacker, attacker, lifesteal, true)
    local particleName = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
    local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, attacker )
    ParticleManager:SetParticleControlEnt(pfx, 0, attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt( pfx, 1, attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin()+Vector(0,0,70), true )
    Timers:CreateTimer(1, function()
        ParticleManager:DestroyParticle( pfx, false )
    end)

    local w_ability = attacker:FindAbilityByName('seinaru_hands_of_hikari')
    if overheal and w_ability then
        local w3_level = attacker:GetRuneValue("w", 3)
        if w3_level > 0 then
            if not  attacker.seinaru_c_b_absorb then
                attacker.seinaru_c_b_absorb = 0
            end
            attacker.seinaru_c_b_absorb = math.min( attacker.seinaru_c_b_absorb + overheal, attacker:GetAgility() * w3_level * SEINARU_W3_SHIELD_PER_AGI)
            w_ability:ApplyDataDrivenModifier(attacker, attacker, "modifier_seinaru_rune_w_3_shield", {duration = SEINARU_W3_DUR_BASE})
        end

    end
end
function t21_glyph_equip(event)
    local caster = event.caster.hero
    caster:AddNewModifier(caster, nil, "modifier_seinaru_glyph_t21_movespeed_cap", {})
end

function t21_glyph_unequip(event)
    local caster = event.caster.hero
    caster:RemoveModifierByName("modifier_seinaru_glyph_t21_movespeed_cap")
end
function t71_glyph_equip(event)
    local caster = event.caster.hero
    caster:SetPrimaryAttribute(0)
end

function t71_glyph_unequip(event)
    local caster = event.caster.hero
    caster:SetPrimaryAttribute(1)
end