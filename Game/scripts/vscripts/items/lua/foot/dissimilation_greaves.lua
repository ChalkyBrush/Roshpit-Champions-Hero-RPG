require('items/lua/foot/base_boot')
require('npc_abilities/base_modifier')

item_rpc_dissimilation_greaves = class(BaseFoot, nil, BaseFoot)

local itemClass = item_rpc_dissimilation_greaves
local itemClassName = 'item_rpc_dissimilation_greaves'

modifier_dissimilation_greaves = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_dissimilation_greaves
local modifierName = 'modifier_dissimilation_greaves'
LinkLuaModifier(modifierName, "items/lua/foot/dissimilation_greaves", LUA_MODIFIER_MOTION_NONE)

modifier_grey_domain_waiting = class(npc_base_modifier, nil, npc_base_modifier)
local waiting_modifier = modifier_grey_domain_waiting
LinkLuaModifier('modifier_grey_domain_waiting', "items/lua/foot/dissimilation_greaves", LUA_MODIFIER_MOTION_NONE)

modifier_grey_domain_slow = class(npc_base_modifier, nil, npc_base_modifier)
local slow_modifier = modifier_grey_domain_slow
LinkLuaModifier('modifier_grey_domain_slow', "items/lua/foot/dissimilation_greaves", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'Greaves of the Grey Domain'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:HasRuneSlots()
    return true
end
function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_dissimilation_greaves"
    self:SetSpecialValue("dissimilation_greaves", "#999999")
end
function itemClass:RollProperty2(item_level)
    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 40, tier2 = 80, tier3 = 100})
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, rune_type, 1.5)
end
function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 3)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 1)
end

-- MODIFIER


function modifierClass:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_SPECIAL_TYPE_ORDER_FILTER
    })
end

function modifierClass:OnOrderFilter(data)
    local ability = self:GetAbility()
    local hero = self:GetParent()
    local allowedOrderTypes = {
        [DOTA_UNIT_ORDER_STOP] = true,
        [DOTA_UNIT_ORDER_HOLD_POSITION] = true
    }
    if not allowedOrderTypes[data.order_type] then
        return
    end
    if ability:GetCooldownTimeRemaining() > 0 then
        return false
    end
    if hero:IsStunned() then
        return false
    end
    self:DissimilatePhaseOne()

    local cooldown = ITEM_RPC_DISSIMILATION_GREAVES_COOLDOWN - ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_DISSIMILATION_GREAVES_GEM_SAPPHIRE)
    cooldown = Filters:AdjustCooldownForDotaCooldownRate(cooldown)
    ability:StartCooldown(cooldown)
end

function itemClass:GetRingRadius()
    local ability = self
    return 275 + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_DISSIMILATION_GREAVES_GEM_RUBY)
end

function modifierClass:DissimilatePhaseOne()
    local ability = self:GetAbility()
    local hero = self:GetParent()
    EmitSoundOn("RPCItems.GreyDomain.Activate", hero)
    local ring_radius = ability:GetRingRadius()
    ability.portals_table = {}
    for i = 1, 6, 1 do
        local portal = {}
        local offset = WallPhysics:rotateVector(hero:GetForwardVector(), 2*math.pi*i/6)*ring_radius*1.9
        local pfx = ParticleManager:CreateParticle("particles/roshpit/items/grey_domain.vpcf", PATTACH_CUSTOMORIGIN, nil)
        local portal_pos = GetGroundPosition(hero:GetAbsOrigin() + offset, hero)
        ParticleManager:SetParticleControl(pfx, 0, portal_pos)
        ParticleManager:SetParticleControl(pfx, 1, Vector(ring_radius, 1, 2))
        Timers:CreateTimer(2, function()
            ParticleManager:DestroyParticle(pfx, false)
        end)
        portal.position = portal_pos
        portal.selected = 0
        portal.pfx = pfx
        table.insert(ability.portals_table, portal)
    end
    local portal_base = {}
    local pfx = ParticleManager:CreateParticle("particles/roshpit/items/grey_domain.vpcf", PATTACH_CUSTOMORIGIN, nil)
    local portal_pos = GetGroundPosition(hero:GetAbsOrigin(), hero)
    ParticleManager:SetParticleControl(pfx, 0, portal_pos)
    ParticleManager:SetParticleControl(pfx, 1, Vector(ring_radius, 1, 2))
    ParticleManager:SetParticleControl(pfx, 2, Vector(255, 255, 255))
    Timers:CreateTimer(2, function()
        ParticleManager:DestroyParticle(pfx, false)
    end)
    portal_base.position = portal_pos
    portal_base.selected = 1
    portal_base.pfx = pfx
    table.insert(ability.portals_table, portal_base)
    SpecialFX:ColoredPop(hero:GetAbsOrigin()+Vector(0,0,20), Vector(100, 100, 100))
    hero:AddNoDraw()
    hero:AddNewModifier(hero, ability, "modifier_grey_domain_waiting", {duration = 2})
    for i = 1, #ability.portals_table, 1 do
        local portal = ability.portals_table[i]
        if portal.selected == 1 then
            ability.selected_portal = i
            break
        end
    end
    Timers:CreateTimer(2, function()
        hero:RemoveModifierByName("modifier_grey_domain_waiting")
    end)
end

-- WAITING MODIFIER

function waiting_modifier:CheckState()
    local state = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_SILENCED] = true
    }

    return state
end

function waiting_modifier:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_SPECIAL_TYPE_ORDER_FILTER
    })
end

function waiting_modifier:OnRemoved()
    if not IsServer() then
        return
    end
    local hero = self:GetParent()
    local ability = self:GetAbility()
    local teleport_position = WallPhysics:WallSearch(hero:GetAbsOrigin(), ability.portals_table[ability.selected_portal].position, hero)
    FindClearSpaceForUnit(hero, teleport_position, false)
    hero:RemoveNoDraw()
    -- SpecialFX:ColoredPop(hero:GetAbsOrigin()+Vector(0,0,20), Vector(100, 100, 100))
    ability.selected_portal = nil
    EmitSoundOn("RPCItems.GreyDomain.Appear", hero)
    CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_arc_warden/arc_warden_tempest_cast.vpcf", hero:GetAbsOrigin(), 3)

    local damage = OverflowProtectedGetAverageTrueAttackDamage(hero)*(1 + ((ITEM_RPC_DISSIMILATION_GREAVES_DAMAGE_PCT_ATK_POWER + ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_DISSIMILATION_GREAVES_GEM_AMETHYST1))/100))
    local radius = ability:GetRingRadius()
    local slow_duration = ITEM_RPC_DISSIMILATION_GREAVES_SLOW_DURATION + ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_DISSIMILATION_GREAVES_GEM_AMETHYST2)
    local enemies = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    if #enemies > 0 then
        for _, enemy in pairs(enemies) do
            enemy:AddNewModifier(hero, ability, "modifier_grey_domain_slow", {duration = slow_duration})
            Filters:ApplyItemDamage(enemy, hero, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_ICE)
        end
    end
end

function waiting_modifier:OnOrderFilter(data)
    local ability = self:GetAbility()
    local hero = self:GetParent()
    local allowedOrderTypes = {
        [DOTA_UNIT_ORDER_MOVE_TO_POSITION] = true,
        [DOTA_UNIT_ORDER_MOVE_TO_TARGET] = true,
        [DOTA_UNIT_ORDER_ATTACK_TARGET] = true
    }
    if not allowedOrderTypes[data.order_type] then
        return
    end
    local position = Vector(data.position_x, data.position_y)
    if data.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET or data.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
        local enemy = EntIndexToHScript(data.entindex_target)
        position = enemy:GetAbsOrigin()
    end
    ability.selected_portal = 7
    for i = 1, #ability.portals_table, 1 do
        local portal = ability.portals_table[i]
        local distance = WallPhysics:GetDistance2d(portal.position, position)
        if distance < ability:GetRingRadius()-20 then
            portal.selected = 1
            ParticleManager:SetParticleControl(portal.pfx, 2, Vector(255, 255, 255))
        else
            portal.selected = 0
            ParticleManager:SetParticleControl(portal.pfx, 2, Vector(0, 0, 0))
        end
    end
    local selected_count = 0
    for i = 1, #ability.portals_table, 1 do
        local portal = ability.portals_table[i]
        if portal.selected == 1 then
            selected_count = 1
            ability.selected_portal = i
            break
        end
    end
    if selected_count == 0 then
        ParticleManager:SetParticleControl(ability.portals_table[ability.selected_portal].pfx, 2, Vector(255, 255, 255))
    end
end

-- SLOW MODIFIER

function slow_modifier:IsDebuff()
    return true
end

function slow_modifier:GetStatusEffectName()
    return "particles/status_fx/status_effect_frost_lich.vpcf"
end

function slow_modifier:StatusEffectPriority()
    return MODIFIER_PRIORITY_NORMAL
end

function slow_modifier:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return funcs
end

function slow_modifier:GetModifierMoveSpeedBonus_Percentage()
    return ITEM_RPC_DISSIMILATION_GREAVES_MS_SLOW_PCT
end