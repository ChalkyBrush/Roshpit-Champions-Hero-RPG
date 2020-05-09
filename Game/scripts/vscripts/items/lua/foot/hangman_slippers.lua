require('items/lua/foot/base_boot')
require('npc_abilities/base_modifier')

item_rpc_hangman_slippers = class(BaseFoot, nil, BaseFoot)

local itemClass = item_rpc_hangman_slippers
local itemClassName = 'item_rpc_hangman_slippers'

modifier_hangman_slippers = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_hangman_slippers
local modifierName = 'modifier_hangman_slippers'
LinkLuaModifier(modifierName, "items/lua/foot/hangman_slippers", LUA_MODIFIER_MOTION_NONE)

modifier_hangman_jumping = class(npc_base_modifier, nil, npc_base_modifier)
local jumping_modifier = modifier_hangman_jumping
LinkLuaModifier("modifier_hangman_jumping", "items/lua/foot/hangman_slippers", LUA_MODIFIER_MOTION_NONE)

modifier_hangman_disarm = class(npc_base_modifier, nil, npc_base_modifier)
local disarm_modifier = modifier_hangman_disarm
LinkLuaModifier("modifier_hangman_disarm", "items/lua/foot/hangman_slippers", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'Hangman Slippers'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:HasRuneSlots()
    return true
end
function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_hangman_slippers"
    self:SetSpecialValue("hangman_slippers", "#446e67")
end
function itemClass:RollProperty2(item_level)
    local luck = RandomInt(1, 3)
    if luck == 1 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, rune_type, 1.5)
    else
        RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "agility", 2)
    end
end
function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 1.5)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 1.5)
end
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
    local allowedOrderTypes = {
        [DOTA_UNIT_ORDER_ATTACK_TARGET] = true,
        [DOTA_UNIT_ORDER_ATTACK_MOVE] = true
    }
    if not allowedOrderTypes[data.order_type] then
        return
    end
    if ability:GetCooldownTimeRemaining() > 0 then
        return false
    end
    local position = Vector(data.position_x, data.position_y)
    if data.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
        local enemy = EntIndexToHScript(data.entindex_target)
        position = enemy:GetAbsOrigin()
    end

    self:HangmanJump(position)

    local cooldown = ITEM_RPC_HANGMAN_SLIPPERS_CD - ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_HANGMAN_SLIPPERS_GEM_SAPPHIRE)
    ability:StartCooldown(cooldown)
end

function modifierClass:HangmanJump(position)
    local ability = self:GetAbility()
    local hero = self:GetParent()
    EmitSoundOn("RPCItems.Hangman.Jump", hero)
    hero:AddNoDraw()
    
    local max_distance = ITEM_RPC_HANGMAN_SLIPPERS_MAX_DISTANCE + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_HANGMAN_SLIPPERS_GEM_RUBY1)
    local cast_distance = WallPhysics:GetDistance2d(position, hero:GetAbsOrigin())
    local fv = ((position - hero:GetAbsOrigin())*Vector(1,1,0)):Normalized()
    local actual_distance = cast_distance
    if cast_distance > max_distance then
        position = hero:GetAbsOrigin() + fv*max_distance
        actual_distance = max_distance
    end
    local position = GetGroundPosition(position, hero)
    local projectile_speed = ITEM_RPC_HANGMAN_SLIPPERS_TRAVEL_SPEED_BASE * (1 + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_HANGMAN_SLIPPERS_GEM_EMERALD)/100)
    local pfx = ParticleManager:CreateParticle("particles/roshpit/items/hangman_slippers.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(pfx, 0, hero:GetAbsOrigin())
    ParticleManager:SetParticleControl(pfx, 1, position)
    ParticleManager:SetParticleControl(pfx, 2, Vector(projectile_speed, projectile_speed, projectile_speed))

    CustomAbilities:QuickParticleAtPoint("particles/roshpit/items/hangman_slipper_depart.vpcf", hero:GetAbsOrigin(), 2)
    local delay = actual_distance/projectile_speed

    hero:AddNewModifier(hero, ability, "modifier_hangman_jumping", {duration = delay})
    Timers:CreateTimer(delay, function()
        self:HangmanLand(position, pfx)
    end)
end

function modifierClass:HangmanLand(position, pfx)
    local ability = self:GetAbility()
    local hero = self:GetParent()
    FindClearSpaceForUnit(hero, position, false)
    ParticleManager:DestroyParticle(pfx, false)
    Timers:CreateTimer(0.03, function()
        hero:RemoveNoDraw()
        hero:RemoveModifierByName("modifier_hangman_jumping")
    end)
    EmitSoundOn("RPCItems.Hangman.Impact", hero)
    -- CustomAbilities:QuickParticleAtPoint("particles/roshpit/items/hangman_land_bright.vpcf", hero:GetAbsOrigin(), 3)
    CustomAbilities:QuickParticleAtPoint("particles/roshpit/items/hangman_slipper_depart.vpcf", hero:GetAbsOrigin(), 2)

    local radius = ITEM_RPC_HANGMAN_SLIPPERS_AOE + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_HANGMAN_SLIPPERS_GEM_RUBY2)
    local disarm_duration = ITEM_RPC_HANGMAN_SLIPPERS_DISARM_DURATION + ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_HANGMAN_SLIPPERS_GEM_AMETHYST)
    local enemies = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    if #enemies > 0 then
        for _, enemy in pairs(enemies) do
            enemy:AddNewModifier(hero, ability, "modifier_hangman_disarm", {duration = disarm_duration})
        end
    end

    local aoe_pfx = CustomAbilities:QuickParticleAtPoint("particles/roshpit/items/hangman_aoe.vpcf", hero:GetAbsOrigin(), 3)
    ParticleManager:SetParticleControl(aoe_pfx, 1, Vector(radius, radius, radius))
end

-- JUMPING MODIFIER

function jumping_modifier:IsHidden()
    return true
end

function jumping_modifier:CheckState()
    local state = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_SILENCED] = true
    }

    return state
end

-- disarm_modifier

function disarm_modifier:CheckState()
    local state = {
        [MODIFIER_STATE_DISARMED] = true
    }

    return state
end

function disarm_modifier:OnCreated()
    EmitSoundOn("RPCItems.Hangman.Disarm", self:GetParent())
end

function disarm_modifier:GetEffectName()
    return "particles/items2_fx/heavens_halberd.vpcf"
end

function disarm_modifier:GetEffectAttachType()
    return PATTACH_CUSTOMORIGIN_FOLLOW
end