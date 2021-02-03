require('items/lua/glyph/base_glyph')
require('npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')

item_rpc_chernobog_glyph_7_2 = class(BaseGlyph, nil, BaseGlyph)
local itemClass = item_rpc_chernobog_glyph_7_2
local itemClassName = 'item_rpc_chernobog_glyph_7_2'

modifier_chernobog_glyph_7_2 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_chernobog_glyph_7_2
local modifierName = 'modifier_chernobog_glyph_7_2'
LinkLuaModifier(modifierName, "heroes/nightstalker/glyph_scripts/chernobog_glyph_7_2", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetModifierName()
    return modifierName
end

function itemClass:GetItemName()
    return itemClassName
end

------------
--MODIFIER--
------------

function modifierClass:OnCreated()
    if not IsServer() then
        return
    end
	self:StartIntervalThink(CHERNOBOG_GLYPH_7_2_THINK_INTERVAL)
end

function modifierClass:IsHidden()
    return true
end
function modifierClass:IsBuff()
    return true
end
function modifierClass:RemoveOnDeath()
    return false
end

function modifierClass:OnIntervalThink()
	if not IsServer() then
		return
	end
	local caster = self:GetParent()
	local modifierTable = caster:FindAllModifiers()
	if not caster:HasModifier("modifier_demon_hunter") then
		return
	end
	for i = 1, #modifierTable, 1 do
		local modifier = modifierTable[i]
		local modifierMaker = modifier:GetCaster()
		if not WallPhysics:DoesTableHaveValue(Filters:GetUnpurgableDebuffNames(), modifier:GetName()) then
			if modifierMaker and modifierMaker:IsRegularEnemy(caster) then
				caster:RemoveModifierByName(modifier:GetName())
				break
			end
		end
	end
end
