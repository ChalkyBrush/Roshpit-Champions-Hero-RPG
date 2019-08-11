-- Base class for units

UnitMixin = class({})

local class = UnitMixin

local difficult = GameState:GetDifficultyFactor()

local getStandardScales = function()
    local result = {}
    for _,type in pairs({ ENEMY_TYPE_WEAK_CREEP, ENEMY_TYPE_NORMAL_CREEP, ENEMY_TYPE_MINI_BOSS, ENEMY_TYPE_BOSS, ENEMY_TYPE_MAJOR_BOSS }) do
        result[type] = {
            [ DIFFICULTY_NORMAL ] = {
                armor = 1,
                hp = 1,
                damage  = 1,
            },
            [ DIFFICULTY_ELITE ] = {
                armor = 10,
                hp = 30,
                damage = 20
            },
            [ DIFFICULTY_LEGEND ] = {
                armor = 40,
                hp = 500,
                damage = 100,
            },
        }
    end
    return result
end
local standardScales = getStandardScales()

function class:constructor(args)
    self.unit_special_type = NPC_LUA_UNIT
    self.damageReduction = 1
    self.isParagon = false

    local initData = self:GetInitData()

    self.type = initData.type or ENEMY_TYPE_NORMAL_CREEP

    local scales = initData.scales or standardScales[self.type]
    scales = scales[difficult]

    if initData.modifierName then
        self:AddNewModifier(self, nil, initData.modifierName, {})
    end
    if initData.armor then
        self:SetPhysicalArmorBaseValue(initData.armor * scales.armor)
    end
    if initData.effectiveHp then
        self:SetEffectiveHp(initData.effectiveHp * scales.hp)
    end
    if initData.abilities then
        for _,abilityName in pairs(initData.abilities) do
            self:AddAbility(abilityName)
        end
    end

    return self
end

function class:SetEffectiveHp(hp)
    local maxAllowedHp = 1500000000 --1.5b
    local reduction = 1 - (maxAllowedHp/hp)
    if reduction < 0 then
        reduction = 0
    end

    hp = hp * (1 - reduction)

    self.damageReduction = reduction

    self:SetMaxHealth(hp)
    self:SetBaseMaxHealth(hp)
    self:SetHealth(hp)

    return self
end

function class:ApplyEffectiveHeal(heal)
    heal = heal * (1 - self.damageReduction)
    Filters:ApplyHeal(self, self, heal, true)
end

function class:GetEffectiveHp()
    if self.reduction == nil then
        self.reduction = 0
    end
    if self.reduction == 1 then
        return -1
    end
    return self:GetHealth()/(1 - self.reduction)
end

function class:SetSummoner(summoner)
    self.summoner = summoner
end