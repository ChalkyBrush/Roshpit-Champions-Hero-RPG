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
function Util.Ability:WithCasterRunesOnClient(caster, func)
    if IsClient() then
        local playerId = caster:GetPlayerOwnerID()
        caster.lastTimeRunesChange = caster.lastTimeRunesChange or false
        local changeTable = CustomNetTables:GetTableValue("hero_values", playerId .. '_last_set_rune') or nil
        local isChanged = caster.lastTimeRunesChange == false or (changeTable ~= nil and caster.lastTimeRunesChange < changeTable.time)
        if isChanged then
            for _,letter in pairs({'q','w','e','r'}) do
                for tier = 1,4 do
                    if changeTable == nil then
                        caster[letter .. tier .. '_level'] = 0
                    else
                        local baseResult = CustomNetTables:GetTableValue("hero_values",  playerId .. '_rune_' .. letter .. tier .. '_level') or {}
                        caster[letter .. tier .. '_level'] = baseResult.count or 0
                    end
                end
            end
            if changeTable ~= nil then
                caster.lastTimeRunesChange = changeTable.time
            else
                caster.lastTimeRunesChange = 0
            end

        end
    end
    return func()
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
            if aggregateFunc ~= nil and result ~= nil then
                aggregateFunc(result, data)
            end
        end
    end
end
function Util.Modifier:SetIndependentlyStacks(caster, target, modifier, stacksCount, stacksDuration)
    target.independentStacksInfo = target.independentStacksInfo or {}
    local key = caster:GetEntityIndex() .. modifier:GetName()
    target.independentStacksInfo[key] = target.independentStacksInfo[key] or 0
    target.independentStacksInfo[key] = target.independentStacksInfo[key] + stacksCount
    modifier:SetStackCount(target.independentStacksInfo[key])
    Timers:CreateTimer(stacksDuration, function()
        if not target:IsAlive() or modifier:IsNull() then
            return
        end
        target.independentStacksInfo[key] = target.independentStacksInfo[key] - stacksCount
        modifier:SetStackCount(target.independentStacksInfo[key])
    end)
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
function Util.Common:LimitPerTime(limit, time, key, func)
    self.limitPerTimeStore = self.limitPerTimeStore or {}
    local currentLimitInfo = self.limitPerTimeStore[key]
    local currentTime = GameRules:GetGameTime()
    if not currentLimitInfo or currentLimitInfo.worksUntil <= currentTime or currentLimitInfo.runTimes < limit then
        if not currentLimitInfo or currentLimitInfo.worksUntil <= currentTime then
            currentLimitInfo = {
                worksUntil = currentTime + time,
                runTimes = 0
            }
        end
        currentLimitInfo.runTimes = currentLimitInfo.runTimes + 1
        self.limitPerTimeStore[key] = currentLimitInfo
        func()
    end
end

Util.BaseType = Util.BaseType or class({})
function Util.BaseType:IsAbilityBaseType(baseType)
    if baseType == BASE_ABILITY_Q 
    or baseType == BASE_ABILITY_W 
    or baseType == BASE_ABILITY_E 
    or baseType == BASE_ABILITY_R then
        return true
    else
        return false
    end
end