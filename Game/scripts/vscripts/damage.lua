Damage = Damage or class({})
require('/util')
require('/global_constants')

-- ATTENTION: There shouldn't be lots events like GetMultAfter -> they all change the mult and can work unpredictable together
--  one possible solution for this - add priority for modifier and sort by this, but better just use it rarely

-- Attention before full move to new way for calculate damage some events forbidden because they can't be calculated at the same time with standard
function Damage:checkForbiddenEventUntilFinish(eventPreffix, eventType)
    local data = {
        default = {
            GetMultAfter = true
        },
        ExtraPostmitigation = {},
        LethalCheck = {},
        Lethal = {},
    }
end

-- data{ attacker, isFake, victim, damage, damageType, elements, sourceType, source, ignoreSteadfast, augmented }
function Damage:Calculate(data)
    local attackerBuffs, attackerDebuffs = Util.Creature:GetBuffsAndDebuffs(data.attacker, npc_base_modifier)
    local victimBuffs, victimDebuffs = Util.Creature:GetBuffsAndDebuffs(data.victim, npc_base_modifier)

    data.dot = data.dot or false
    data.ignoreSteadfast = data.ignoreSteadfast or false
    data.augmented = data.augmented or false
    data.repeated = data.repeated or false

    if data.damage <= 0 then
        return 0
    end

    if data.isDot then
        data.damage = self:GetWithDot('Increase', attackerBuffs, victimDebuffs, data)
        data.damage = self:GetWithDot('Decrease', attackerDebuffs, victimBuffs, data)
        data.damage = self:GetWithDot('Amplify', attackerBuffs, victimDebuffs, data)
        data.damage = self:GetWithDot('Reduce', attackerDebuffs, victimBuffs, data)
        if data.damage <= 0 then
            return 0
        end
    end

    data.damage = self:GetWithSource('Increase', attackerBuffs, victimDebuffs, data)
    data.damage = self:GetWithSource('Decrease', attackerDebuffs, victimBuffs, data)
    data.damage = self:GetWithSource('Amplify', attackerBuffs, victimDebuffs, data)
    data.damage = self:GetWithSource('Reduce', attackerDebuffs, victimBuffs, data)

    if data.damage <= 0 then
        return 0
    end

    data.damage = self:GetWithElement('Increase', attackerBuffs, victimDebuffs, data)
    data.damage = self:GetWithElement('Decrease', attackerDebuffs, victimBuffs, data)
    data.damage = self:GetWithElement('Amplify', attackerBuffs, victimDebuffs, data)
    data.damage = self:GetWithElement('Reduce', attackerDebuffs, victimBuffs, data)

    if data.damage <= 0 then
        return 0
    end

    if not data.augmented then
        data.damage = self:GetWithAugmented(attackerBuffs, victimDebuffs, data)
    end

    if data.damage <= 0 then
        return 0
    end

    data.damage = self:GetWithPremitigation('Increase', attackerBuffs, victimDebuffs, data)
    data.damage = self:GetWithPremitigation('Decrease', attackerDebuffs, victimBuffs, data)
    data.damage = self:GetWithPremitigation('Amplify', attackerBuffs, victimDebuffs, data)
    data.damage = self:GetWithPremitigation('Reduce', attackerDebuffs, victimBuffs, data)

    if data.damage <= 0 then
        return 0
    end

    if not data.ignoreSteadfast then
        data.damage = self:GetWithSteadfastReduce(attackerDebuffs, victimBuffs, data)
    end

    if data.damage <= 0 then
        return 0
    end

    data.damage = self:GetWithPostmitigation('Amplify', attackerBuffs, victimDebuffs, data)
    data.damage = self:GetWithPostmitigation('Reduce', attackerDebuffs, victimBuffs, data)

    if data.damage <= 0 then
        return 0
    end

    data.damage = self:GetWithExtraPostmitigation('Amplify', attackerBuffs, victimDebuffs, data)
    data.damage = self:GetWithExtraPostmitigation('Reduce', attackerDebuffs, victimBuffs, data)

    if data.damage <= 0 then
        return 0
    end

    if data.damage > data.victim:GetHealth() then
        data.damage = self:GetWithLethalCheck(attackerDebuffs, victimBuffs, data)
    end

    if data.damage > data.victim:GetHealth() then
        self:OnLethal(attackerDebuffs, victimBuffs, data)
    end

    return data.damage
end
-- data{ attacker, isFake, victim, damage, damageType, elements, sourceType, source, ignoreSteadfast }
function Damage:Apply(data)
    -- check data
    if not data.victim or not data.attacker then
        error('victim or attacker missed')
    end
    if not data.damage or not data.damageType then
        error('damage or damage type missed')
    end

    if data.sourceType == nil then
        error('source type missed')
    end
    if data.elements == nil then
        data.elements = {}
    end
    if data.ignoreSteadfast then
        data.attacker.ignore_steadfast = true
    end

    local element1 = data.elements[1] or RPC_ELEMENT_NONE
    local element2 = data.elements[2] or RPC_ELEMENT_NONE

    if data.sourceType == BASE_ITEM then
        Filters:ApplyItemDamage(data.victim, data.attacker, data.damage, data.damageType, data.source, element1, element2)
    elseif data.isDot then
        if not data.source then
            error('dot damage can be applied only with source')
        end

        Filters:ApplyDotDamage(data.attacker, data.source, data.victim, data.damage, data.damageType, data.sourceType, element1, element2)
    else
        Filters:TakeArgumentsAndApplyDamage(data.victim, data.attacker, data.damage, data.damageType, data.sourceType, element1, element2)
    end

end

local sourceTypeBaseAbility = {
    [BASE_ABILITY_Q] = true,
    [BASE_ABILITY_W] = true,
    [BASE_ABILITY_E] = true,
    [BASE_ABILITY_R] = true,
}
local elementsList = {
    [RPC_ELEMENT_NORMAL] = 'Normal',
    [RPC_ELEMENT_FIRE] = 'Fire',
    [RPC_ELEMENT_EARTH] = 'Earth',
    [RPC_ELEMENT_LIGHTNING] = 'Lightning',
    [RPC_ELEMENT_POISON] = 'Poison',
    [RPC_ELEMENT_TIME] = 'Time',
    [RPC_ELEMENT_HOLY] = 'Holy',
    [RPC_ELEMENT_COSMOS] = 'Cosmos',
    [RPC_ELEMENT_ICE] = 'Ice',
    [RPC_ELEMENT_ARCANE] = 'Arcane',
    [RPC_ELEMENT_SHADOW] = 'Shadow',
    [RPC_ELEMENT_WIND] = 'Wind',
    [RPC_ELEMENT_GHOST] = 'Ghost',
    [RPC_ELEMENT_WATER] = 'Water',
    [RPC_ELEMENT_DEMON] = 'Demon',
    [RPC_ELEMENT_NATURE] = 'Nature',
    [RPC_ELEMENT_UNDEAD] = 'Undead',
    [RPC_ELEMENT_DRAGON] = 'Dragon',
}

local filter = function(modifiers, specialTypes)
    return Util.Common.Filter(function(modifier)
        return modifier:HasSpecialTypes(specialTypes)
    end, modifiers)
end


    local getMethods = function(type, initialName)
        if type == 'Amplify' then
            return {
                Get = function(modifier, data, mult)
                    local method = 'Get' .. initialName
                    if  modifier[method] == nil then
                        return mult
                    end
                    local result = modifier[method](modifier, data)
                    if result ~= nil then
                        return mult + result
                    end
                end,
                GetMultAfter = function(modifier, data, mult)
                    local method = 'GetMultAfter' .. initialName
                    if  modifier[method] == nil then
                        return mult
                    end
                    local result = modifier[method](modifier, data, mult)
                    if result ~= nil then
                        return result
                    end
                end,
                OnTry = function(modifier, data, mult)
                    local method = 'OnTry' .. initialName
                    if mult == 1 then
                        return
                    end
                    if  modifier[method] == nil then
                        return
                    end
                    modifier[method](modifier, data, mult)
                end,

            }
        elseif type == 'Reduce' then
            return {
                Get = function(modifier, data, mult)
                    local method = 'Get' .. initialName
                    if  modifier[method] == nil then
                        return mult
                    end
                    local result = modifier[method](modifier, data)
                    if result ~= nil then
                        return (1 - result) * mult
                    end
                end,
                GetMultAfter = function(modifier, data, mult)
                    local method = 'GetMultAfter' .. initialName
                    if  modifier[method] == nil then
                        return mult
                    end
                    local result = modifier[method](modifier, data, mult)
                    if result ~= nil then
                        return result
                    end
                end,
                OnTry = function(modifier, data, mult)
                    local method = 'OnTry' .. initialName
                    if mult == 1 then
                        return
                    end
                    if  modifier[method] == nil then
                        return
                    end
                    modifier[method](modifier, data, mult)
                end,

            }
        elseif type == 'Increase' then
            return {
                Get = function(modifier, data, mult)
                    local method = 'Get' .. initialName
                    if  modifier[method] == nil then
                        return mult
                    end
                    local result = modifier[method](modifier, data)
                    if result ~= nil then
                        return mult + result
                    end
                end,
                GetMultAfter = function(modifier, data, mult)
                    local method = 'GetMultAfter' .. initialName
                    if  modifier[method] == nil then
                        return mult
                    end
                    local result = modifier[method](modifier, data, mult)
                    if result ~= nil then
                        return result
                    end
                end,
                OnTry = function(modifier, data, mult)
                    local method = 'OnTry' .. initialName
                    if mult == 0 then
                        return
                    end
                    if  modifier[method] == nil then
                        return
                    end
                    modifier[method](modifier, data, mult)
                end,
            }
        elseif type == 'Decrease' then
            return {
                Get = function(modifier, data, mult)
                    local method = 'Get' .. initialName
                    if  modifier[method] == nil then
                        return mult
                    end
                    local result = modifier[method](modifier, data)
                    if result ~= nil then
                        return -mult + result
                    end
                end,
                GetMultAfter = function(modifier, data, mult)
                    local method = 'GetMultAfter' .. initialName
                    if  modifier[method] == nil then
                        return -mult
                    end
                    local result = modifier[method](modifier, data, -mult)
                    if result ~= nil then
                        return result
                    end
                end,
                OnTry = function(modifier, data, mult)
                    local method = 'OnTry' .. initialName
                    if mult == 0 then
                        return
                    end
                    if  modifier[method] == nil then
                        return
                    end
                    modifier[method](modifier, data, mult)
                end,
            }
        end

    end
    local mergeStrategies
    local getMergeStrategy = function(type)
        mergeStrategies = mergeStrategies or {
            Add = function(mult, localMult)
                return mult + localMult - 1
            end,
            Multiply = function(mult, localMult)
                return mult * localMult
            end,
            DecreaseAndIncrease = function(mult, localMult)
                return mult + localMult - 1
            end,
            Min = function(mult, localMult)
                return math.min(mult, localMult)
            end
        }
        return mergeStrategies[type]
    end

    -- {modifiersPart1, modifiersPart2, template, type, specialTypes:nil, mult:nil, }
    local function calcTypeDamageFromTemplate(data)
        local getMethods = data.methodsFunc or getMethods
        local mergeStrategyType = data.mergeStrategyType or nil
        local type = data.type

        if mergeStrategyType == nil then
            if type == 'Amplify' then
                mergeStrategyType = 'Add'
            elseif type == 'Reduce' then
                mergeStrategyType = 'Multiply'
            elseif type == 'Decrease' or type == 'Increase' then
                mergeStrategyType = 'DecreaseAndIncrease'
            end

        end

        local mergeStrategy = data.mergeStrategy or getMergeStrategy(mergeStrategyType)
        local template = data.template
        local baseMult = data.mult
        return function (modifiersPart1, modifiersPart2, damageData)
            local mult = baseMult
            local childrenAfterMethod = data.childrenAfterMethod or 'Get'
            if mult == nil then
                mult = 1
                if (({Increase = true, Decrease = true})[type]) then
                    mult = 0
                end
            end
            local baseMult = mult
            mult = nil
            for _,damageTypeInfo in pairs(template) do
                if damageTypeInfo.isActive(damageData) then
                    local localMult = damageTypeInfo.mult or baseMult
                    local modifiersPart1,modifiersPart2 = modifiersPart1,modifiersPart2

                    if damageTypeInfo.specialTypes ~= nil then
                        modifiersPart1, modifiersPart2 = filter(modifiersPart1, damageTypeInfo.specialTypes), filter(modifiersPart2, damageTypeInfo.specialTypes)
                    end
                    local modifierGroups = { modifiersPart1, modifiersPart2 }
                    local allowedMethods = getMethods(type, damageTypeInfo.name)

                    for methodName,method in pairs(allowedMethods) do
                        for _,modifiers in pairs(modifierGroups) do
                            for _,modifier in pairs(modifiers) do
                                local result = method(modifier, damageData, localMult)
                                if result ~=nil then
                                    localMult = result
                                end
                            end
                        end
                        if damageTypeInfo.children ~= nil and methodName == childrenAfterMethod then
                            localMult = calcTypeDamageFromTemplate({
                                type = type,
                                mult = localMult,
                                template = damageTypeInfo.children,
                                getMethods = getMethods,
                                mergeStrategy = damageTypeInfo.mergeStrategy or mergeStrategy,
                                childrenAfterMethod = damageTypeInfo.childrenAfterMethod
                            })(modifiersPart1, modifiersPart2, damageData)/damageData.damage
                        end
                    end
                    if mult == nil then
                        mult = localMult
                    else
                        mult = mergeStrategy(mult, localMult)
                    end
                end
            end
            if mult == nil then
                mult = baseMult
            end

            return mult * damageData.damage
        end
    end



function Damage:GetWithSource(type, attackerBuffs, victimDebuffs, data)
    self._getWithSource = self._getWithSource or {}
    if self._getWithSource[type] == nil then
        local abilitiesChildren = {}
        local abilities = {
            [BASE_ABILITY_Q] = 'AbilityQ',
            [BASE_ABILITY_W] = 'AbilityW',
            [BASE_ABILITY_E] = 'AbilityE',
            [BASE_ABILITY_R] = 'AbilityR',
        }
        for abilityIndex,ability in pairs(abilities) do
            table.insert(abilitiesChildren, {
                isActive = function(data)
                    return data.sourceType == abilityIndex
                end,
                name = ability .. type,
            })
        end
        local type = data.type
        local mult = data.mult
        local template = data.template
        local damageData = data.data
        local modifiersPart1 = data.modifiersPart1
        local modifiersPart2 = data.modifiersPart2
        self._getWithSource[type] = calcTypeDamageFromTemplate({
            type = type,
            template = {
                {
                    isActive = function(data)
                        return data.sourceType == BASE_ITEM
                    end,
                    name = 'Item' .. type,
                    specialTypes = { MODIFIER_SPECIAL_TYPE_ITEMS },
                },
                {
                    isActive = function(data)
                        return sourceTypeBaseAbility[data.sourceType]
                    end,
                    name = 'Abilities' .. type,
                    specialTypes = { MODIFIER_SPECIAL_TYPE_ABILITIES },
                    children = abilitiesChildren
                }
            }
        })
    end
    return self._getWithSource[type](attackerBuffs, victimDebuffs, data)
end

function Damage:GetWithElement(type, attackerBuffs, victimDebuffs, data)
    self._getWithElement = self._getWithElement or {}
    if true then
        local children = {}
        for elementId, elementName in pairs(elementsList) do
            table.insert(children, {
                isActive = function(data)
                    for _,element in pairs(data.elements) do -- TODO: flip array in future
                        if element == elementId then
                            return true
                        end
                    end
                    return false
                end,
                name = elementName .. 'Element' .. type
            })
        end

        self._getWithElement[type] = calcTypeDamageFromTemplate({
            type = type,
            template = {
                {
                    isActive = function(data)
                        return #data.elements == 0
                    end,
                    name = 'NoneElement' .. type,
                    specialTypes = { MODIFIER_SPECIAL_TYPE_ELEMENTS },
                },
                {
                    mult = 1,
                    isActive = function(data)
                        return #data.elements > 0
                    end,
                    name = 'Elements' .. type,
                    specialTypes = { MODIFIER_SPECIAL_TYPE_ELEMENTS },
                    children = children
                },
            }
        })
    end
    local result = self._getWithElement[type](attackerBuffs, victimDebuffs, data)
    return result
end

function Damage:GetWithPremitigation(type, attackerBuffs, victimDebuffs, data)
    self._getWithPremitigation = self._getWithPremitigation or {}
    if self._getWithPremitigation[type] == nil then

        self._getWithPremitigation[type] = calcTypeDamageFromTemplate({
            type = type,
            template = {
                {
                    isActive = function(data)
                        return true
                    end,
                    name = 'Premitigation' .. type,
                    specialTypes = { MODIFIER_SPECIAL_TYPE_PREMITIGATION },
                },
            }
        })
    end
    return self._getWithPremitigation[type](attackerBuffs, victimDebuffs, data)
end

function Damage:GetWithSteadfastReduce(attackerDebuffs, victimBuffs, data)
    local modifiersPart1 = filter(attackerDebuffs, { MODIFIER_SPECIAL_TYPE_STEADFAST })
    local modifiersPart2 = filter(victimBuffs, { MODIFIER_SPECIAL_TYPE_STEADFAST })
    local initialName = 'SteadfastReduce'
    local mult = 100
    local methodsInfo = {
        Get = function(modifier, data, mult)
            local method = 'Get' .. initialName
            if  modifier[method] == nil then
                return mult
            end
            local result = modifier[method](modifier, data)
            if result ~= nil then
                return math.min(mult, result)
            end
        end,
        GetMultAfter = function(modifier, data, mult)
            local method = 'GetMultAfter' .. initialName
            if  modifier[method] == nil then
                return mult
            end
            local result = modifier[method](modifier, data, mult)
            if result ~= nil then
                return result
            end
        end,
        OnTry = function(modifier, data, mult)
            local method = 'OnTry' .. initialName
            if mult == 1 then
                return
            end
            if  modifier[method] == nil then
                return
            end
            modifier[method](modifier, data, mult)
        end,
    }
    for _, method in pairs(methodsInfo) do
        for _,modifiers in {modifiersPart1, modifiersPart2} do
            for _,modifier in modifiers do
                local result = method(modifier, data, mult)
                if result ~=nil then
                    mult = result
                end
            end
        end
    end
    return math.min(data.damage, mult/100 * data.victim:GetMaxHealth())
end

function Damage:GetWithPostmitigation(type, attackerBuffs, victimDebuffs, data)
    self._getWithPostmitigation = self._getWithPostmitigation or {}
    if true then

        self._getWithPostmitigation[type] = calcTypeDamageFromTemplate({
            type = type,
            template = {
                {
                    isActive = function(data)
                        return true
                    end,
                    name = 'Postmitigation' .. type,
                    specialTypes = { MODIFIER_SPECIAL_TYPE_POSTMITIGATION },
                    children = {
                        {
                            isActive = function(data)
                                return data.damageType == DAMAGE_TYPE_MAGIC
                            end,
                            name = 'PostmitigationMagic' .. type,
                        },
                        {
                            isActive = function(data)
                                return data.damageType == DAMAGE_TYPE_PURE
                            end,
                            name = 'PostmitigationPure' .. type,
                        },
                        {
                            isActive = function(data)
                                return data.damageType == DAMAGE_TYPE_PHYSICAL
                            end,
                            name = 'PostmitigationPhysical' .. type,
                        },
                    }
                },
            }
        })
    end
    return self._getWithPostmitigation[type](attackerBuffs, victimDebuffs, data)
end
function Damage:GetWithExtraPostmitigation(type, attackerBuffs, victimDebuffs, data)
    self._getWithExtraPostmitigation = self._getWithExtraPostmitigation or {}
    if true then

        self._getWithExtraPostmitigation[type] = calcTypeDamageFromTemplate({
            type = type,
            template = {
                {
                    isActive = function(data)
                        return true
                    end,
                    name = 'ExtraPostmitigation' .. type,
                    specialTypes = { MODIFIER_SPECIAL_TYPE_EXTRA_POSTMITIGATION },
                },
            }
        })
    end
    return self._getWithExtraPostmitigation[type](attackerBuffs, victimDebuffs, data)
end
function Damage:GetWithDot(type, attackerBuffs, victimDebuffs, data)
    self._getWithGetWithDot = self._getWithGetWithDot or {}
    if self._getWithGetWithDot then

        self._getWithGetWithDot[type] = calcTypeDamageFromTemplate({
            type = type,
            template = {
                {
                    isActive = function(data)
                        return true
                    end,
                    name = 'Dot' .. type,
                    specialTypes = { MODIFIER_SPECIAL_TYPE_DOT },
                },
            }
        })
    end
    return self._getWithGetWithDot[type](attackerBuffs, victimDebuffs, data)
end

function Damage:GetWithLethalCheck(attackerDebuffs, victimBuffs, data)
    local modifiersPart1 = filter(attackerDebuffs, { MODIFIER_SPECIAL_TYPE_LETHAL_CHECK })
    local modifiersPart2 = filter(victimBuffs, { MODIFIER_SPECIAL_TYPE_LETHAL_CHECK })
    local mult = 1
    local initialName = 'LethalCheck'
    local methodsInfo = {
        Get = function(modifier, data, mult)
            local method = 'Get' .. initialName
            if  modifier[method] == nil then
                return mult
            end
            local result = modifier[method](modifier, data)
            if result ~= nil then
                return math.min(mult, result)
            end
        end,
        GetMultAfter = function(modifier, data, mult)
            local method = 'GetMultAfter' .. initialName
            if  modifier[method] == nil then
                return mult
            end
            local result = modifier[method](modifier, data, mult)
            if result ~= nil then
                return result
            end
        end,
        OnTry = function(modifier, data, mult)
            local method = 'OnTry' .. initialName
            if mult == 1 then
                return
            end
            if  modifier[method] == nil then
                return mult
            end
            modifier[method](modifier, data, mult)
        end,
    }
    for _, method in pairs(methodsInfo) do
        for _,modifiers in {modifiersPart1, modifiersPart2} do
            for _,modifier in modifiers do
                local result = method(modifier, data, mult)
                if result ~=nil then
                    mult = result
                end
                if result == 0 then
                    return 0
                end
            end
        end
    end
    return data.damage
end
function Damage:OnLethal(attackerDebuffs, victimBuffs, data)
    local modifiersPart1 = filter(attackerDebuffs, { MODIFIER_SPECIAL_TYPE_LETHAL })
    local modifiersPart2 = filter(victimBuffs, { MODIFIER_SPECIAL_TYPE_LETHAL })
    local modifierGroups = {modifiersPart1, modifiersPart2}
    local methodsInfo = {
        OnLethal = function(modifier, data)
            local method = 'OnLethal'
            if  modifier[method] == nil then
                return
            end
            modifier[method](modifier, data)
        end,
    }
    for _, method in pairs(methodsInfo) do
        for _,modifiers in pairs(modifierGroups)  do
            for _,modifier in pairs(modifiers) do
                method(modifier, data)
            end
        end
    end
end

function Damage:GetWithAugmented(attackerBuffs, victimDebuffs, data)
    self._getWithAugmented = self._getWithAugmented or {}
    if true then

        self._getWithAugmented =calcTypeDamageFromTemplate({
            type = 'Amplify',
            template = {
                {
                    isActive = function(data)
                        return true
                    end,
                    name = 'Augmented',
                    specialTypes = { MODIFIER_SPECIAL_TYPE_AUGMENTED },
                },
            }
        })
    end
    return self._getWithAugmented[type](attackerBuffs, victimDebuffs, data)
end