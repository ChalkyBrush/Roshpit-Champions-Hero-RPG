arkimus_archon_form_lua = class({})

function arkimus_archon_form_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MODEL_SCALE,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
        MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
        MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT
        -- MODIFIER_PROPERTY_ATTACK_POINT_CONSTANT
    }

    return funcs
end

function arkimus_archon_form_lua:GetModifierModelScale( params )
    return 8
end

function arkimus_archon_form_lua:GetModifierAttackRangeBonus( params )
    local ability = self:GetParent():FindAbilityByName("arkimus_archon_form")
    local range = 500
    if IsValidEntity(ability) then
     range = ability:GetLevelSpecialValueFor("attack_range", ability:GetLevel())
    end
    return range
end

function arkimus_archon_form_lua:GetModifierProjectileSpeedBonus( params )
    return 800
end

function arkimus_archon_form_lua:GetModifierBaseAttackTimeConstant( params )
    local bat = 1.1
    if self:GetParent() then
        local d_d_level = self:GetParent():FindAbilityByName("arkimus_archon_form").d_d_level
        if d_d_level > 0 then
            bat = bat - 0.01*d_d_level
        end
    end
    return bat
end


function arkimus_archon_form_lua:GetAttackSound( params )
	return "Arkimus.ArchonForm.Attack"
end

function arkimus_archon_form_lua:IsHidden()
    return true
end

-- "particles/units/heroes/hero_dark_willow/dark_willow_base_attack.vpcf"