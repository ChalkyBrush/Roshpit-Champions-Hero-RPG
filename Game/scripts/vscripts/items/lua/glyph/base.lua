require('items/equipment')
BaseGlyph = class({})
local itemClass = BaseGlyph

function itemClass:GetItemName()
    error('Define item name')
end

function itemClass:GetModifierName()
    error('Define modifier name')
end

function itemClass:GetGlyphTier()
    local nameLength = string.len(self:GetItemName())
    return tonumber(string.sub(self:GetItemName(), nameLength - 2, nameLength - 2))
end

function itemClass:GetGlyphIndex()
    local nameLength = string.len(self:GetItemName())
    return string.sub(self:GetItemName(), nameLength, nameLength)
end

function itemClass:GetStackCount()
    return 1
end

function itemClass:GetGlyphRarity()
    local nameLength = string.len(self:GetItemName())
	local index = string.sub(self:GetItemName(), nameLength, nameLength)
    return Glyphs:GetRarityFromGlyphTier(self:GetGlyphTier(), index)
end

function itemClass:GetSlotText()
    return "Glyph"
end

function itemClass:GetDescriptionKey()
    return self:GetItemName().."_description"
end

function itemClass:GetTooltipKey()
	local rpcName = self:GetItemName():gsub("item_rpc_", "")
	rpcName = rpcName:gsub(string.sub(rpcName, string.len(rpcName) - 9), "")
    return HerosCustom:ConvertRPCNameToStringHeroName(rpcName)
end

function itemClass:CreateLuaItem()
	self = Glyphs:CreateGlyphItem(self:GetItemName(), self:GetGlyphRarity(), nil, self:GetSlotText(), self:GetDescriptionKey(), Vector(0, 0), self:GetTooltipKey(), self:GetGlyphTier() * 15, self:GetModifierName(), -1)
	RPCItems:ItemUpdateCustomNetTables(self)
    return self
end

function itemClass:AddSpecialModifiers(caster)
    local modifier = caster:AddNewModifier(caster, self, self:GetModifierName(), {})
    modifier:SetStackCount(self:GetStackCount())
end
function itemClass:RemoveSpecialModifiers(caster)
    caster:RemoveModifierByName(self:GetModifierName())
end