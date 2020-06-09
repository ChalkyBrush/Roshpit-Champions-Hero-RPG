require('items/lua/glyph/base_glyph')
require('npc_abilities/base_modifier')

require('heroes/dragon_knight/flamewaker_constants')

item_rpc_flamewaker_glyph_1_1 = class(BaseGlyph, nil, BaseGlyph)
local itemClass = item_rpc_flamewaker_glyph_1_1
local itemClassName = 'item_rpc_flamewaker_glyph_1_1'

modifier_flamewaker_glyph_1_1 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_flamewaker_glyph_1_1
local modifierName = 'modifier_flamewaker_glyph_1_1'
LinkLuaModifier(modifierName, "heroes/dragon_knight/glyph_scripts/flamewaker_glyph_1_1", LUA_MODIFIER_MOTION_NONE)

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
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_EVENT_ATTACKED
    })
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

function modifierClass:RoshpitOnAttacked(event)
	local hero = event.victim
	local attacker = event.attacker
	local luck = RandomInt(1, 2)
	if luck == 100/FLAMEWAKER_GLYPH_1_1_RETURN_STUN_CHANCE then
		Filters:ApplyStun(hero, FLAMEWAKER_GLYPH_1_1_STUN_DURATION, attacker)
	end	
end