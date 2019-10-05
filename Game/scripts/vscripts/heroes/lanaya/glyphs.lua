require("/heroes/lanaya/trapper_constants")
require('heroes/lanaya/explosive_bomb')
require('heroes/lanaya/lasso')
local modifiers  = {
    t31_shields = 'modifier_trapper_t31_shields',
    t31_main = 'modifier_trapper_t31_main',
    t32_main = 'modifier_trapper_t32_main',
    t32_damage_reduction = 'modifier_trapper_t32_damage_reduction',
}

for modifierPath, modifier in pairs(modifiers) do
    LinkLuaModifier(modifier, "heroes/lanaya/modifiers/"..modifierPath, LUA_MODIFIER_MOTION_NONE)
end
function t31_add_main(event)
    local caster = event.caster.hero
    local ability = event.ability
    caster:AddNewModifier(caster, ability, modifiers.t31_main, {})
end
function t31_remove_main(event)
    local caster = event.caster.hero
    caster:RemoveModifierByName(modifiers.t31_main)
end
function t32_add_main(event)
    local caster = event.caster.hero
    local ability = event.ability
    caster:AddNewModifier(caster, ability, modifiers.t31_main, {})
end
function t32_remove_main(event)
    local caster = event.caster.hero
    caster:RemoveModifierByName(modifiers.t31_main)
end
function t51_think(event)
    local caster = event.caster.hero
    local ability = event.ability
    ability.cdUntil = ability.cdUntil or 0
    ability.movedDistance = ability.movedDistance or 0
    local currentCasterPosition = caster:GetAbsOrigin()
    ability.lastCasterPosition = ability.lastCasterPosition or currentCasterPosition
    local distance = WallPhysics:GetDistance2d(ability.lastCasterPosition, currentCasterPosition)
    ability.lastCasterPosition = currentCasterPosition
    if distance > 1500 then
        return
    end
    ability.movedDistance = ability.movedDistance + distance
    if ability.cdUntil > GameRules:GetGameTime() then
        return
    end
    ability.cdUntil = GameRules:GetGameTime() + TRAPPER_GLYPH_5_1_COOLDOWN
    if ability.movedDistance > TRAPPER_GLYPH_5_1_DISTANCE then
        ability.movedDistance = 0
        local wAbility = caster:GetAbilityByIndex(DOTA_W_SLOT)
        local target_points = {}
        local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, TRAPPER_GLYPH_5_1_SEARCH_DISTANCE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
        if #enemies > 0 then
            target_points = { enemies[1]:GetAbsOrigin() }
        else
            target_points = { currentCasterPosition + RandomVector(RandomInt(0, TRAPPER_GLYPH_5_1_SEARCH_DISTANCE)) }
        end
        local data = {
            caster = caster,
            ability = wAbility,
            damage = wAbility:GetSpecialValueFor('damage'),
            stun_duration = wAbility:GetSpecialValueFor('stun_duration'),
            radius = wAbility:GetSpecialValueFor('radius'),
            target_points = target_points
        }
        if caster:HasModifier('modifier_trapper_arcana1') then
            if caster:HasModifier('modifier_trapper_stealth') then
                trapper_lasso_start(data)
            else
                trapper_poison_whip_start(data)
            end
        else
            if caster:HasModifier('modifier_trapper_stealth') then
                bomb_throw_start_smoke(data)
            else
                bomb_throw_start(data)
            end
        end
    end
end
