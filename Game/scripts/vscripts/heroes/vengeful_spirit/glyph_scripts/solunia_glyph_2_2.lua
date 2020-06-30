require('items/lua/glyph/base_glyph')
require('npc_abilities/base_modifier')
require('heroes/vengeful_spirit/solunia_constants')

item_rpc_solunia_glyph_2_2 = class(BaseGlyph, nil, BaseGlyph)
local itemClass = item_rpc_solunia_glyph_2_2
local itemClassName = 'item_rpc_solunia_glyph_2_2'

modifier_solunia_glyph_2_2 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_solunia_glyph_2_2
local modifierName = 'modifier_solunia_glyph_2_2'
LinkLuaModifier(modifierName, "heroes/vengeful_spirit/glyph_scripts/solunia_glyph_2_2", LUA_MODIFIER_MOTION_NONE)

modifier_solunia_glyph_2_2_pull = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_solunia_glyph_2_2_pull", "heroes/vengeful_spirit/glyph_scripts/solunia_glyph_2_2", LUA_MODIFIER_MOTION_NONE)

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

function modifierClass:GlyphChannelThink(ability)
    local hero = self:GetParent()
    local position = hero:GetAbsOrigin()

    for i = 1, 12, 1 do
        local rotatedFV = WallPhysics:rotateVector(Vector(0,1), 2*math.pi*i/12)
        local startPosition = position + SOLUNIA_GLYPH_2_2_RADIUS*rotatedFV
        self:VacuumWave(startPosition, rotatedFV*-1, ability:GetWaveProjectileName(), position)
    end
    local glyph_ability = nil
    for key, glyph in pairs(hero.glyphs_table) do
        if glyph and IsValidEntity(glyph) and glyph:GetAbilityName() == itemClassName then
            glyph_ability = glyph
        end
    end
    if glyph_ability then
        if not glyph_ability.vacuum_table then
            glyph_ability.vacuum_table = {}
        end
        local enemies = FindUnitsInRadius(hero:GetTeamNumber(), position, nil, SOLUNIA_GLYPH_2_2_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
        if #enemies > 0 then
            for _, enemy in pairs(enemies) do
                local speed = 800
                local duration = SOLUNIA_GLYPH_2_2_RADIUS/speed
                enemy:AddNewModifier(hero, glyph_ability, "modifier_solunia_glyph_2_2_pull", {duration = duration})
                glyph_ability.vacuum_table[enemy:GetEntityIndex()] = position
            end
        end
    end
end


function modifierClass:VacuumWave(startPosition, direction, projectileParticle, endPoint)
    local hero = self:GetParent()
    local start_radius = 160
    local end_radius = 160
    local range = SOLUNIA_GLYPH_2_2_RADIUS
    local speed = 800

    local info =
    {
        Ability = glyph_ability,
        EffectName = projectileParticle,
        vSpawnOrigin = startPosition,
        fDistance = range,
        fStartRadius = start_radius,
        fEndRadius = end_radius,
        Source = hero,
        StartPosition = "attach_origin",
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 5.0,
        bDeleteOnHit = false,
        vVelocity = direction * speed,
        bProvidesVision = false,
        iVisionRadius = 0,
        iMoveSpeed = speed,
        iVisionTeamNumber = hero:GetTeamNumber()
    }
    Filters:LinearProjectile(info)
end

function item_rpc_solunia_glyph_2_2:OnProjectileHit(target, VLoc)
    return true
end


-- vacuum modifier
function modifier_solunia_glyph_2_2_pull:CheckState()
    local state = {
        [MODIFIER_STATE_ROOTED] = true,
    }
    return state    
end

function modifier_solunia_glyph_2_2_pull:OnCreated()
    if not IsServer() then
        return false
    end
    self:StartIntervalThink(0.03)
end

function modifier_solunia_glyph_2_2_pull:OnIntervalThink()
    if not IsServer() then
        return false
    end
    local target = self:GetParent()
    if target.pushLock then
        return false
    end
    local ability = self:GetAbility()
    local start_position = target:GetAbsOrigin()
    local target_point = ability.vacuum_table[target:GetEntityIndex()]
    local direction = ((target_point - start_position)*Vector(1,1,0)):Normalized()
    local distance = WallPhysics:GetDistance2d(target_point, start_position)
    local speed = distance/35
    local newPos = GetGroundPosition(start_position + direction*speed, target)
    print(newPos)
    target:SetAbsOrigin(newPos)
end

function modifier_solunia_glyph_2_2_pull:OnRemoved()
    local target = self:GetParent()
    local ability = self:GetAbility()
    if not IsServer() then
        return false
    end
    FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
    ability.vacuum_table[target:GetEntityIndex()] = nil
end

function modifier_solunia_glyph_2_2_pull:GetTexture()
    return "solunia/solunia_gravity_glyph"
end