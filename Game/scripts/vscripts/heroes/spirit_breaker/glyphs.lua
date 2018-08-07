Helper = require('heroes/util/helper')
function t12_think(event)
    local target = event.target
    local ability = event.ability
    if target:IsSilenced() then
        ability:ApplyDataDrivenModifier(target, target, 'modifier_duskbringet_t12_heal_regen', {duration = DUSK_T12_DURATION})
    end
end
function t42_think(event)
    local target = event.target
    local ability = event.ability
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
    local duration = 1
    if target:HasModifier('modifier_duskbringer_glyph_3_1') then
        duration = duration + DUSK_T31_DURATION
    end
    print("distance moved " .. ability.distanceMoved )
    if ability.distanceMoved > 300 then
        Helper.updateStackModifier(target, target, ability, 'duskbringer_t42', duration, T42_MAX_STACKS_COUNT, nil)
        ability.lastPos = ability.newPos
        ability.distanceMoved = ability.distanceMoved % 300
    end
end
function t62_think(event)
    local target = event.target
    Filters:CleanseStuns(target)
    Filters:CleanseSilences(target)
end