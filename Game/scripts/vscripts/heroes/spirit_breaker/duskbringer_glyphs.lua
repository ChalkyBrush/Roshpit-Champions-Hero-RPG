Helper = require('heroes/util/helper')

function duskbringer_glyph_1_2_think(event)
    local target = event.target
    local ability = event.ability
    if target:IsSilenced() then
        local glyph_1_2_duration = Filters:GetAdjustedBuffDuration(target, DUSKBRINGER_GLYPH_1_2_BASE_DUR, false)
        ability:ApplyDataDrivenModifier(target, target, 'modifier_duskbringer_glyph_1_2_effect', {duration = glyph_1_2_duration})
    end
end

function duskbringer_glyph_4_2_refresh(caster)
    if caster:HasModifier("modifier_duskbringer_glyph_4_2_visible") and caster:HasModifier("modifier_duskbringer_glyph_4_2") then
        local e_1_duration = DUSKBRINGER_E1_BASE_DUR
        if caster:HasModifier('modifier_duskbringer_glyph_3_1') then
            e_1_duration = e_1_duration + DUSKBRINGER_GLYPH_3_1_INCR_DUR
        end
        e_1_duration = Filters:GetAdjustedBuffDuration(caster, e_1_duration, false)
        local ability = caster:FindModifierByName("modifier_duskbringer_glyph_4_2_visible"):GetAbility()
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_duskbringer_glyph_4_2_visible", {duration = e_1_duration})
    end
end

function duskbringer_glyph_4_2_think(event)
    local target = event.target
    local ability = event.ability
    if not ability.ticks then
        ability.ticks = 0
    end
    if not ability.lastStackTime then
        ability.lastStackTime = -20
    end
    if not ability.lastPos then
        ability.lastPos = target:GetAbsOrigin()
    end
    if not ability.distanceMoved then
        ability.distanceMoved = 0
    end
    ability.newPos = target:GetAbsOrigin()
    local distance = WallPhysics:GetDistance(ability.newPos, ability.lastPos)
    ability.distanceMoved = ability.distanceMoved + distance
    local e_1_duration = DUSKBRINGER_E1_BASE_DUR
    if target:HasModifier('modifier_duskbringer_glyph_3_1') then
        e_1_duration = e_1_duration + DUSKBRINGER_GLYPH_3_1_INCR_DUR
    end
    e_1_duration = Filters:GetAdjustedBuffDuration(target, e_1_duration, false)
    if ability.distanceMoved > 300 and (ability.ticks - ability.lastStackTime) >= 20 then
        ability:ApplyDataDrivenModifier(target, target, "modifier_duskbringer_glyph_4_2_visible", {duration = e_1_duration})
        local glyph_4_2_current_stacks = target:GetModifierStackCount("modifier_duskbringer_glyph_4_2_visible", ability)
        target:SetModifierStackCount("modifier_duskbringer_glyph_4_2_visible", ability, math.min(glyph_4_2_current_stacks + 1, DUSKBRINGER_GLYPH_4_2_MAX_STACKS))
        ability.distanceMoved = ability.distanceMoved % 300
        ability.lastStackTime = ability.ticks
    end
    ability.ticks = ability.ticks + 1
    ability.lastPos = target:GetAbsOrigin()
end

function t62_think(event)
    local target = event.target
    Filters:CleanseStuns(target)
    Filters:CleanseSilences(target)
end
