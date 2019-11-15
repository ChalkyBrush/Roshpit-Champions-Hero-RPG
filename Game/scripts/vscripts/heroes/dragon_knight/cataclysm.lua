function cataclysm_start(event)
    local caster = event.caster
    Filters:CastSkillArguments(4, caster)
    if caster:HasModifier("modifier_flamewaker_glyph_6_1") then
        local glyphDuration = Filters:GetAdjustedBuffDuration(caster, FLAMEWAKER_GLYPH_6_1_DURATION, false)
        event.ability:ApplyDataDrivenModifier(caster, caster, "modifier_flamewaker_glyph_6_1_buff", {duration = glyphDuration})
    end
    caster.r_4_level = Runes:GetTotalRuneLevel(caster, 4, "r_4", "flamewaker")
    if caster:HasModifier("modifier_flamewaker_immortal_weapon_1") then
        caster.equipped_gear[RPC_GEAR_SLOT_WEAPON]:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_volcano_shield", {duration = FLAMEWAKER_IMMORTAL_WEAPON_1_DURATION})
        caster:SetModifierStackCount("modifier_volcano_shield", caster.InventoryUnit, FLAMEWAKER_IMMORTAL_WEAPON_1_SHIELDS)
    end
    GridNav:DestroyTreesAroundPoint(caster:GetAbsOrigin(), 380, false)
end

function cataclysm_damage(event)
    local target = event.target
    local caster = event.caster
    local damage = event.damage

    Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_PURE, BASE_ABILITY_R, RPC_ELEMENT_FIRE, RPC_ELEMENT_EARTH)
    local stun_duration = event.stun_duration
    if caster:HasModifier("modifier_flamewaker_immortal_weapon_3") then
        stun_duration = stun_duration * FLAMEWAKER_IMMORTAL_WEAPON_3_STUN_DURATION_Q_R_MULT
    end
    Filters:ApplyStun(caster, stun_duration, target)
end
