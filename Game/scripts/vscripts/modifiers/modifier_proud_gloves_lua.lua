modifier_proud_gloves_lua = class({})

function modifier_proud_gloves_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
    }

    return funcs
end

function modifier_proud_gloves_lua:GetAttackSound(params)
    return "RPCItems.KappaPride.Attack"
end

function modifier_proud_gloves_lua:IsHidden()
    return true
end
