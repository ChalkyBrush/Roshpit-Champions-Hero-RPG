require('items/lua/foot/base_boot')
require('npc_abilities/base_modifier')

item_rpc_emerald_speed_runners = class(BaseFoot, nil, BaseFoot)
modifier_emerald_speed_runners = class(npc_base_modifier, nil, npc_base_modifier)
local itemClass = item_rpc_emerald_speed_runners
local itemClassName = 'item_rpc_emerald_speed_runners'

local modifierClass = modifier_emerald_speed_runners
local modifierName = 'modifier_emerald_speed_runners'
LinkLuaModifier(modifierName, "items/lua/foot/emerald_speed_runners", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'emerald_speed_runners'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:HasRuneSlots()
    return true
end
function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_emerald_speed_runners"
    self:SetSpecialValue("emerald_speed_runners", "#3EC18A")
end
function itemClass:RollProperty2(item_level)
    local luck = RandomInt(1, 4)
    if luck == 1 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, rune_type, 1.5)
    elseif luck == 2 then
        RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "element_wind", 1.5)
    else
        RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, nil, 1.25)
    end
end
function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 1)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 1.5)
end
function modifierClass:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_SPECIAL_TYPE_ORDER_FILTER,
        MODIFIER_ROSHPIT_E_MAX_CD_MOD
    })
end
function modifierClass:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN
    }
    return funcs
end

function modifierClass:OnOrderFilter(data)
    local allowedOrderTypes = {
        [DOTA_UNIT_ORDER_MOVE_TO_POSITION] = true,
    }
    if not allowedOrderTypes[data.order_type] then
        return
    end
    local hero = self:GetParent()
    if not hero:HasModifier("modifier_emerald_speedrunner_sapphire_cd") then
        if hero:IsRooted() then
            if hero:IsStunned() or hero:IsFrozen() then
            else
                local ability = self:GetAbility()
                if IsValidEntity(ability) and ability:GetGemValue("sapphire") > 0 then
                    ability:ApplyDataDrivenModifier(hero.InventoryUnit, hero, "modifier_emerald_speedrunner_sapphire_cd", {duration = ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_EMERALD_SPEED_RUNNERS_GEM_SAPPHIRE2)})
                    CustomAbilities:QuickAttachParticle("particles/econ/events/ti8/blink_dagger_ti8_start.vpcf", hero, 3)
                    local clampDistance = ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_EMERALD_SPEED_RUNNERS_GEM_SAPPHIRE1)
                    local distance = math.min(WallPhysics:GetDistance2d(Vector(orderTable.position_x, orderTable.position_y), hero:GetAbsOrigin()), clampDistance)
                    local teleportDirection = ((Vector(orderTable.position_x, orderTable.position_y) - hero:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
                    local position2 = WallPhysics:WallSearch(hero:GetAbsOrigin(), hero:GetAbsOrigin() + teleportDirection * distance, hero)
                    FindClearSpaceForUnit(hero, position2, false)
                    ProjectileManager:ProjectileDodge(hero)
                    EmitSoundOn("RPCItems.EmeraldSpeedRunners.Sapphire", hero)
                    Timers:CreateTimer(0.1, function()
                        CustomAbilities:QuickAttachParticle("particles/econ/events/ti8/blink_dagger_ti8_end.vpcf", hero, 3)
                    end)
                end
            end
        end
    end
end

function modifierClass:GetModifierMoveSpeed_AbsoluteMin()
    if IsServer() then
        return ITEM_RPC_EMERALD_SPEED_RUNNERS_SPEED_MS_LOW_CAP + self:GetAbility():GetFinalGemPropertyValue("ruby", ITEM_RPC_EMERALD_SPEED_RUNNERS_GEM_RUBY)
    end
end

function modifierClass:GetRoshpitEMaxCdModifier()
    if self:GetAbility():GetGemValue("amethyst") > 0 then
        return self:GetAbility():GetFinalGemPropertyValue("amethyst", ITEM_RPC_EMERALD_SPEED_RUNNERS_GEM_AMETHYST)
    else
        return nil
    end
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