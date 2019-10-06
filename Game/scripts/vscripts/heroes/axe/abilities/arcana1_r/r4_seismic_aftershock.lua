local function getTremorsCount(caster)
    local runesCount = caster:GetRuneValue("r", 4)
    if runesCount <= 0 then
        return 1
    else
        return 1 + Runes:Procs(runesCount, RED_GENERAL_ARCANA1_R4_ADD_TREMOR_CHANCE, 1)
    end
end

local function getAdditionalRadius(caster)
    local runesCount = caster:GetRuneValue("r", 4)
    if runesCount <= 0 then
        return 0
    else
        return runesCount * RED_GENERAL_ARCANA1_R4_INCREASE_RADIUS
    end
end

local module = {}
module.getTremorsCount = getTremorsCount
module.getAdditionalRadius = getAdditionalRadius
return module
