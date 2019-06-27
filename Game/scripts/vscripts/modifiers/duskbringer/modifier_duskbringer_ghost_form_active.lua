modifier_duskbringer_ghost_form_active = class({})

function modifier_duskbringer_ghost_form_active:GetStatusEffectName()
    return 'particles/status_fx/status_effect_wraithking_ghosts.vpcf'
end

function modifier_duskbringer_ghost_form_active:GetHeroEffectName(params)
    return 'particles/units/heroes/hero_skeletonking/wraith_king_ghosts_ambient.vpcf'
end

function modifier_duskbringer_ghost_form_active:OnDestroy(params)
    local caster = self:GetCaster()
    local target = self:GetParent()

    if not caster:HasModifier('modifier_duskbringer_glyph_5_a') or target == caster or target:HasModifier('modifier_duskbringer_ghost_form_immune') then
        if IsValidEntity(target) then
            CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash_flash.vpcf", target:GetAbsOrigin() + Vector(0, 0, 50), 0.4)
            --print(target:GetClassname())
            target:ForceKill(false)
        end
    else
        local ability = self:GetAbility()
        ability:ApplyDataDrivenModifier(caster, target, "modifier_duskbringer_ghost_form_immune", {duration = DUSKBRINGER_GLYPH_5_a_CD})

    end
end

function modifier_duskbringer_ghost_form_active:DeclareFunctions()
    return {}
end

function modifier_duskbringer_ghost_form_active:IsHidden()
    return false
end
