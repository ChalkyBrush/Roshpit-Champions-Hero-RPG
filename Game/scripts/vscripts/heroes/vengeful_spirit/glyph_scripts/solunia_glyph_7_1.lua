require('items/lua/glyph/base_glyph')
require('npc_abilities/base_modifier')
require('heroes/vengeful_spirit/solunia_constants')

item_rpc_solunia_glyph_7_1 = class(BaseGlyph, nil, BaseGlyph)
local itemClass = item_rpc_solunia_glyph_7_1
local itemClassName = 'item_rpc_solunia_glyph_7_1'

modifier_solunia_glyph_7_1 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_solunia_glyph_7_1
local modifierName = 'modifier_solunia_glyph_7_1'
LinkLuaModifier(modifierName, "heroes/vengeful_spirit/glyph_scripts/solunia_glyph_7_1", LUA_MODIFIER_MOTION_NONE)

modifier_solunia_glyph_7_1_freeze = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_solunia_glyph_7_1_freeze", "heroes/vengeful_spirit/glyph_scripts/solunia_glyph_7_1", LUA_MODIFIER_MOTION_NONE)

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

function modifierClass:Cryoshock(hero, target)
    local particleName = "particles/units/heroes/hero_lich/lich_frost_nova.vpcf"
    local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
    local origin = target:GetAbsOrigin()
    ParticleManager:SetParticleControl(particle1, 0, origin)
    ParticleManager:SetParticleControl(particle1, 1, origin)
    Timers:CreateTimer(1, function()
        ParticleManager:DestroyParticle(particle1, false)
    end)
    EmitSoundOn("Solunia.Cryoshock", target)
    local enemies = FindUnitsInRadius(hero:GetTeamNumber(), target:GetAbsOrigin(), nil, SOLUNIA_GLYPH_7_1_FREEZE_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    if #enemies > 0 then
        for _, enemy in pairs(enemies) do
            enemy:AddNewModifier(hero, self:GetAbility(), "modifier_solunia_glyph_7_1_freeze", {duration = SOLUNIA_GLYPH_7_1_FREEZE_DURATION})
        end
    end
end

-- FREEZE MODIFIER
function modifier_solunia_glyph_7_1_freeze:IsDebuff()
    return true
end

function modifier_solunia_glyph_7_1_freeze:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_FROZEN] = true
    }
    return state    
end

function modifier_solunia_glyph_7_1_freeze:GetStatusEffectName()
    return "particles/status_fx/status_effect_frost_lich.vpcf"
end

function modifier_solunia_glyph_7_1_freeze:StatusEffectPriority()
    return 30
end

function modifier_solunia_glyph_7_1_freeze:GetTexture()
    return "solunia/solunia_gravity_glyph"
end