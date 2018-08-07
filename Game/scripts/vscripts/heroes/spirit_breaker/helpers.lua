function phantomRaceRefresh(caster, duration)
    local event = {}
    event.caster = caster.runeUnit
    event.duration = duration
    event.ability = caster.runeUnit:FindAbilityByName("duskbringer_rune_a_c")
    event.ability.distanceMoved = 350
    rune_unit_1_think(event)
end
function rune_unit_1_think(event)
    local caster = event.caster
    local ability = event.ability
    local hero = caster.hero

    local totalLevel = Runes:GetTotalRuneLevel(hero, 1, "a_c", "duskbringer")
    if totalLevel > 0 then
        local target = hero
        if not ability.lastPos then
            ability.lastPos = target:GetAbsOrigin()
        end
        if not ability.distanceMoved then
            ability.distanceMoved = 0
        end
        ability.newPos = target:GetAbsOrigin()
        ability.hero = target
        local distance = WallPhysics:GetDistance(ability.newPos,ability.lastPos)
        ability.distanceMoved = ability.distanceMoved + distance
        local a_c_duration = E1_DURATION
        if event.duration then
            a_c_duration = event.duration
        end
        if hero:HasModifier('modifier_duskbringer_glyph_3_1') then
            a_c_duration = a_c_duration + DUSK_T31_DURATION
        end

        a_c_duration = Filters:GetAdjustedBuffDuration(hero, a_c_duration, false)
        if ability.distanceMoved > 300 then
            ability:ApplyDataDrivenModifier(caster, target, "modifier_duskbringer_rune_a_c_effect", {duration = a_c_duration})
            target:SetModifierStackCount( "modifier_duskbringer_rune_a_c_effect", ability, totalLevel )
            ability.distanceMoved = ability.distanceMoved % 300
        end

        ability.lastPos = target:GetAbsOrigin()
    end
end