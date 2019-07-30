-- Base class for units

npc_base_unit = class({})

local className = npc_base_unit

function className:_create(args)
    self.unit_special_type = NPC_LUA_UNIT
    self.damageReduction = 1
    local unit = CreateUnitByName(args.name, args.position, true, nil, nil, args.team)
    if (args.modifierName) then
        unit:AddNewModifier(unit, nil, args.modifierName, {})
    end

    FindClearSpaceForUnit(unit, args.position, true)
    return unit
end

function className:SetEffectiveHp(hp)
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

function className:ApplyEffectiveHeal(heal)
    heal = heal * (1 - self.damageReduction)
    Filters:ApplyHeal(self, self, heal, true)
end

function className:GetEffectiveHp()
    if self.reduction == nil then
        self.reduction = 0
    end
    if self.reduction == 1 then
        return -1
    end
    return self:GetHealth()/(1 - self.reduction)
end

function className:SetSummoner(summoner)
    self.summoner = summoner
end

function className:_init(unit)
    local metaTable = getmetatable(unit)
    local selfMetaTable = getmetatable(self)
    for key,value in pairs(selfMetaTable.__index) do
        if type(value) == 'function' and not key:find('^__') then
            metaTable.__index[key] = value
        end
    end
    for key,value in pairs(self) do
        if not key:find('^__') then
            metaTable.__index[key] = value
        end
    end
    setmetatable(unit, metaTable)
    return unit
end