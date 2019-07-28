require('npc_abilities/base_modifier')
Util = Util or class({})

Util.Creature = Util.Creature or class({})
function Util.Creature:GetBuffsAndDebuffs(creature, modifierClass)
    local buffs = {}
    local debuffs = {}
    local modifiers = creature:FindAllModifiers()
    for _,modifier in pairs(modifiers) do
        if instanceof(modifier, modifierClass) and modifier['IsDebuff'] then
            if modifier:IsDebuff() then
                table.insert(debuffs, modifier)
            else
                table.insert(buffs, modifier)

            end
        end
    end
    return buffs, debuffs
end
function Util.Creature:GetModifiersWithClassAndTypes(creature, modifierClass, specialTypes)
    local result = {}
    local modifiers = creature:FindAllModifiers()
    for _,modifier in pairs(modifiers) do
        if modifierClass == nil or instanceof(modifier, modifierClass) then
            if (specialTypes ~= nil and modifier:HasSpecialTypes(specialTypes)) or specialTypes == nil then
                table.insert(result, modifier)
            end
        end
    end
    return result
end

Util.Ability = Util.Ability or class({})

function Util.Ability:MakeRightCooldownRemainingTime(caster, ability, data)
    local cooldownIncrease = data.cooldownIncrease or 0
    local cooldownAmplify = data.cooldownAmplify or 1

    local currentCooldown = ability:GetCooldownTimeRemaining()
    local newCooldown = currentCooldown

    newCooldown = math.max((newCooldown + cooldownIncrease) * cooldownAmplify, 0)
    ability:EndCooldown()
    ability:StartCooldown(newCooldown)
end
function Util.Ability:MakeRightCooldown(caster, ability, data)
    local cooldownIncrease = data.cooldownIncrease or 0
    local cooldownAmplify = data.cooldownAmplify or 1

    local currentCooldown = ability:GetCooldownTimeRemaining()
    local newCooldown = currentCooldown

    newCooldown = math.max((newCooldown + cooldownIncrease) * cooldownAmplify, 0)
    ability:EndCooldown()
    ability:StartCooldown(newCooldown)
end
function Util.Ability:GetEffectRadius(radius)
    return radius
end
function Util.Ability:MakeThinker(caster, ability, modifierName, position, duration)
    if not duration then
        error('duration should be more than 0')
    end
    local dummy = CreateUnitByName("dummy_unit_vulnerable", position, false, caster, caster, caster:GetTeam())
    dummy:AddAbility("dummy_unit"):SetLevel(1)
    dummy:AddNewModifier(caster, ability,  modifierName, { duration = duration})
    Timers:CreateTimer(duration, function()
        UTIL_Remove(dummy)
    end)
end
Util.Modifier = Util.Modifier or {}
function Util.Modifier:SimpleEvent(creature, eventName, specialTypes, data, aggregateFunc)
    local modifiers = Util.Creature:GetModifiersWithClassAndTypes(creature, npc_base_modifier, specialTypes)
    for _,modifier in pairs(modifiers) do
        if modifier[eventName] then
            local result = modifier[eventName](modifier, data)
            if aggregateFunc ~= nil then
                aggregateFunc(result)
            end
        end
    end
end
Util.Common = Util.Common or class({})
function Util.Common.Filter(func, tbl)
    local newtbl= {}
    for i,v in pairs(tbl) do
        if func(v) then
            newtbl[i]=v
        end
    end
    return newtbl
end