require('items/equipment')
BaseGlyph = class({})
local class = BaseGlyph

function class:GetItemName()
    error('Define item name')
end

function class:GetModifierName()
    error('Define modifier name')
end

function class:GetGlyphTier()
    local nameLength = string.len(self:GetItemName())
    return tonumber(string.sub(self:GetItemName(), nameLength - 2, nameLength - 2))
end

function class:GetGlyphIndex()
    local nameLength = string.len(self:GetItemName())
    return string.sub(self:GetItemName(), nameLength, nameLength)
end

function class:GetStackCount()
    return 1
end

function class:GetGlyphRarity()
    local nameLength = string.len(self:GetItemName())
	local index = string.sub(self:GetItemName(), nameLength, nameLength)
    return Glyphs:GetRarityFromGlyphTier(self:GetGlyphTier(), index)
end

function class:GetSlotText()
    return "Glyph"
end

function class:GetDescriptionKey()
    return self:GetItemName().."_description"
end

function class:GetTooltipKey()
	local rpcName = self:GetItemName():gsub("item_rpc_", "")
	rpcName = rpcName:gsub(string.sub(rpcName, string.len(rpcName) - 9), "")
    return HerosCustom:ConvertRPCNameToStringHeroName(rpcName)
end

function class:CreateLuaItem()
	self = Glyphs:CreateGlyphItem(self:GetItemName(), self:GetGlyphRarity(), nil, self:GetSlotText(), self:GetDescriptionKey(), Vector(0, 0), self:GetTooltipKey(), self:GetGlyphTier() * 15, self:GetModifierName(), -1)
	RPCItems:ItemUpdateCustomNetTables(self)
    return self
end

function class:AddSpecialModifiers(caster)
    local modifier = caster:AddNewModifier(caster, self, self:GetModifierName(), {})
    modifier:SetStackCount(self:GetStackCount())
end
function class:RemoveSpecialModifiers(caster)
    caster:RemoveModifierByName(self:GetModifierName())
end