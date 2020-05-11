require('/items/lua/trinket/base_trinket')
require('/npc_abilities/base_modifier')

item_rpc_horn_of_the_triumphant = class(BaseTrinket, nil, BaseTrinket)
local itemClass = item_rpc_horn_of_the_triumphant
local itemClassName = 'item_rpc_horn_of_the_triumphant'

modifier_horn_of_the_triumphant = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_horn_of_the_triumphant
local modifierName = 'modifier_horn_of_the_triumphant'
LinkLuaModifier(modifierName, "/items/lua/trinket/horn_of_the_triumphant", LUA_MODIFIER_MOTION_NONE)

modifier_horn_of_triumphant_dummy = class(npc_base_modifier, nil, npc_base_modifier)
local bastion_dummy_modifier = modifier_horn_of_triumphant_dummy
LinkLuaModifier("modifier_horn_of_triumphant_dummy", "/items/lua/trinket/horn_of_the_triumphant", LUA_MODIFIER_MOTION_NONE)

modifier_horn_of_triumphant_inside_bastion_friendly = class(npc_base_modifier, nil, npc_base_modifier)
local inside_bastion_modifier_friendly = modifier_horn_of_triumphant_inside_bastion_friendly
LinkLuaModifier("modifier_horn_of_triumphant_inside_bastion_friendly", "/items/lua/trinket/horn_of_the_triumphant", LUA_MODIFIER_MOTION_NONE)

modifier_horn_of_triumphant_inside_bastion_enemy = class(npc_base_modifier, nil, npc_base_modifier)
local inside_bastion_modifier_enemy = modifier_horn_of_triumphant_inside_bastion_enemy
LinkLuaModifier("modifier_horn_of_triumphant_inside_bastion_enemy", "/items/lua/trinket/horn_of_the_triumphant", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'Moon Shard'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_horn_of_the_triumphant"
    self:SetSpecialValue("horn_of_the_triumphant", "#e3c574")
end
function itemClass:RollProperty2(item_level) 
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, nil, 2)  
end
function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 2)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 2)
end

-- BASE MODIFIER

function modifierClass:DeclareFunctions()
    local funcs = {

    }

    return funcs
end

function modifierClass:OnCreated()
    self:SetSpecialTypes({
        MODIFIER_SPECIAL_TYPE_ORDER_FILTER
    })
    local ability = self:GetAbility()
    if not ability.bastion_table then
        ability.bastion_table = {}
    end
    -- self:StartIntervalThink(0.1)
end

function modifierClass:IsHidden()
    return true
end

function modifierClass:OnRemoved()
	if not IsServer() then
		return false
	end
    local ability = self:GetAbility()
    if ability.bastion_table then
        for i = 1, #ability.bastion_table, 1 do
            local bastion = ability.bastion_table[i]
            if bastion:EntityExistsAndIsAlive() then
                self:DeleteBastion(bastion)
            end
        end
    end
    ability.bastion_table = nil
end

function modifierClass:DeleteBastion(bastion)
    ParticleManager:DestroyParticle(bastion.pfx, false)
    if bastion.lock_target then
        bastion.lock_target:RemoveModifierByName("modifier_horn_of_triumphant_inside_bastion_friendly")
        bastion.lock_target:RemoveModifierByName("modifier_horn_of_triumphant_inside_bastion_enemy")
    end
    UTIL_Remove(bastion)
end

function modifierClass:RemoveOnDeath()
    return false
end

function modifierClass:OnOrderFilter(data)
    local ability = self:GetAbility()
    local allowedOrderTypes = {
        [DOTA_UNIT_ORDER_HOLD_POSITION] = true
    }
    if not allowedOrderTypes[data.order_type] then
        return
    end
    if ability:GetCooldownTimeRemaining() > 0 then
        return false
    end
    local position = GetGroundPosition(self:GetParent():GetAbsOrigin(), self:GetParent())
    local positionCondition = true
    for i = 1, #ability.bastion_table, 1 do
        local distance = WallPhysics:GetDistance2d(position, ability.bastion_table[i]:GetAbsOrigin())
        if distance < ITEM_RPC_HORN_OF_THE_TRIUMPHANT_RADIUS*2 then
            positionCondition = false
            break
        end
    end
    if positionCondition then
        self:CreateBastion(position)

        local cooldown = 0.5
        ability:StartCooldown(cooldown)
    end
end

function modifierClass:CreateBastion(position)
    local ability = self:GetAbility()
    local hero = self:GetParent()

    local bastion_dummy = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, hero:GetTeamNumber())
    bastion_dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
    bastion_dummy:SetAbsOrigin(position)

    local pfx = ParticleManager:CreateParticle("particles/roshpit/items/horn_of_triumphant/bastion_ally.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(pfx, 0, bastion_dummy:GetAbsOrigin())
    bastion_dummy.pfx = pfx
    bastion_dummy.lock_target = hero
    bastion_dummy.state = "ally"
    bastion_dummy.hero = hero
    bastion_dummy:AddNewModifier(hero, ability, "modifier_horn_of_triumphant_dummy", {})
    hero:AddNewModifier(bastion_dummy, ability, "modifier_horn_of_triumphant_inside_bastion_friendly", {})
    CustomAbilities:QuickParticleAtPoint("particles/econ/items/lich/frozen_chains_ti6/lich_frozenchains_frostnova.vpcf", bastion_dummy:GetAbsOrigin(), 3)
    table.insert(ability.bastion_table, bastion_dummy)
    if #ability.bastion_table > ITEM_RPC_HORN_OF_THE_TRIUMPHANT_MAX_CIRCLES then
        self:DeleteBastion(ability.bastion_table[1])
        self:ReindexBastionTable()
    end
    StartAnimation(hero, {duration = 0.7, activity = ACT_DOTA_TELEPORT_END, rate = 1.5})
    EmitSoundOn("RPCItems.Bastion.Create", bastion_dummy)
end

function modifierClass:ReindexBastionTable()
    local ability = self:GetAbility()
    local newTable = {}
    for i = 1, #ability.bastion_table, 1 do
        local bastion = ability.bastion_table[i]
        if bastion:EntityExistsAndIsAlive() then
            table.insert(newTable, bastion)
        end
    end
    ability.bastion_table = newTable
end

-- BASTION MODIFIER

function bastion_dummy_modifier:OnCreated()
    if not IsServer() then
        return false
    end
    self:StartIntervalThink(0.15)
end

function bastion_dummy_modifier:OnIntervalThink()
    if not IsServer() then
        return false
    end
    local dummy = self:GetParent()
    local ability = self:GetAbility()
    if dummy.lock_target then
        self:LockTargetThink()
    else
        self:NoLockTargetThink()
    end
end

function bastion_dummy_modifier:NoLockTargetThink()
    local caster = self:GetCaster()
    local ability = self:GetAbility()
    local dummy = self:GetParent()

    local allies = FindUnitsInRadius(caster:GetTeamNumber(), dummy:GetAbsOrigin(), nil, ITEM_RPC_HORN_OF_THE_TRIUMPHANT_RADIUS, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
    if #allies > 0 then
        if allies[1]:GetUnitName() ~= "npc_dota_hero_wisp" then
            dummy.lock_target = allies[1]
            self:StateChange(dummy)
            allies[1]:AddNewModifier(dummy, ability, "modifier_horn_of_triumphant_inside_bastion_friendly", {})
        end
    end 
    if not dummy.lock_target then
        local enemies = FindUnitsInRadius(caster:GetTeamNumber(), dummy:GetAbsOrigin(), nil, ITEM_RPC_HORN_OF_THE_TRIUMPHANT_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
        if #enemies > 0 then
            dummy.lock_target = enemies[1]
            self:StateChange(dummy)
            local rangeReduce = ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_HORN_OF_THE_TRIUMPHANT_GEM_RUBY2)
            local target_attack_range = math.max(enemies[1]:Script_GetAttackRange() + rangeReduce, 100)
            local stacks = math.max(enemies[1]:Script_GetAttackRange() - target_attack_range, 0)
            local enemyBuff = enemies[1]:AddNewModifier(dummy, ability, "modifier_horn_of_triumphant_inside_bastion_enemy", {})
            enemyBuff:SetStackCount(stacks)
        end 
    end
end

function bastion_dummy_modifier:LockTargetThink()
    local caster = self:GetCaster()
    local ability = self:GetAbility()
    local dummy = self:GetParent()
    local distance = WallPhysics:GetDistance2d(dummy:GetAbsOrigin(), dummy.lock_target:GetAbsOrigin())
    if not dummy.lock_target:IsAlive() then
        dummy.lock_target = nil
        self:StateChange(dummy)
    else
        if distance > ITEM_RPC_HORN_OF_THE_TRIUMPHANT_RADIUS then
            dummy.lock_target:RemoveModifierByName("modifier_horn_of_triumphant_inside_bastion_friendly")
            dummy.lock_target:RemoveModifierByName("modifier_horn_of_triumphant_inside_bastion_enemy")
            dummy.lock_target = nil
            self:StateChange(dummy)
        end
    end
end

function bastion_dummy_modifier:StateChange(dummy)
    local state = bastion_dummy_modifier:GetTrueState(dummy)
    if state ~= dummy.state then
        ParticleManager:DestroyParticle(dummy.pfx, false)
        if state == "ally" then
            local pfx = ParticleManager:CreateParticle("particles/roshpit/items/horn_of_triumphant/bastion_ally.vpcf", PATTACH_CUSTOMORIGIN, nil)
            ParticleManager:SetParticleControl(pfx, 0, dummy:GetAbsOrigin())
            dummy.pfx = pfx
            dummy.state = "ally"
            EmitSoundOn("RPCItems.Bastion.StateAlly", dummy)
        elseif state == "enemy" then
            local pfx = ParticleManager:CreateParticle("particles/roshpit/items/horn_of_triumphant/bastion_enemy.vpcf", PATTACH_CUSTOMORIGIN, nil)
            ParticleManager:SetParticleControl(pfx, 0, dummy:GetAbsOrigin())
            dummy.pfx = pfx
            dummy.state = "enemy"
            EmitSoundOn("RPCItems.Bastion.StateEnemy", dummy)
        else
            local pfx = ParticleManager:CreateParticle("particles/roshpit/items/horn_of_triumphant/bastion_base.vpcf", PATTACH_CUSTOMORIGIN, nil)
            ParticleManager:SetParticleControl(pfx, 0, dummy:GetAbsOrigin())
            dummy.pfx = pfx
            dummy.state = "none"
            EmitSoundOn("RPCItems.Bastion.StateNone", dummy)
        end
    end
end

function bastion_dummy_modifier:GetTrueState(dummy)
    if dummy.lock_target then
        if dummy.lock_target:GetTeamNumber() == dummy:GetTeamNumber() then
            return "ally"
        else
            return "enemy"
        end
    else
        return "none"
    end
end

-- FRIENDLY INSIDE BASTION

function inside_bastion_modifier_friendly:IsBuff()
    return true
end

function inside_bastion_modifier_friendly:OnCreated()
    if not IsServer() then
        return false
    end
    self:SetSpecialTypes({
        MODIFIER_ROSHPIT_PHYSICAL_DMG_REDUCTION,
        MODIFIER_ROSHPIT_MAGICAL_DMG_REDUCTION,
        MODIFIER_ROSHPIT_PURE_DMG_REDUCTION,
        MODIFIER_ROSHPIT_MASTER_GREEN_DMG,
        MODIFIER_ROSHPIT_PERCENT_HEALTH_BONUS,
        MODIFIER_ROSHPIT_ARMOR_BONUS,
        MODIFIER_ROSHPIT_MAGIC_ARMOR_BONUS
    })
    self:StartIntervalThink(ITEM_RPC_HORN_OF_THE_TRIUMPHANT_EMERALD_HEAL_INTERVAL)
end

function inside_bastion_modifier_friendly:OnIntervalThink()
    local ability = self:GetAbility()
    local caster = self:GetCaster()
    local hero = caster.hero
    local parent = self:GetParent()
    if ability:GetGemValue("emerald") > 0 then
        local heal = parent:GetMaxHealth()*(ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_HORN_OF_THE_TRIUMPHANT_GEM_EMERALD)/100)
        Filters:ApplyHeal(hero, parent, heal, true, true)
    end
end

function inside_bastion_modifier_friendly:GetPhysicalDamageReduction()
    return ITEM_RPC_HORN_OF_THE_TRIUMPHANT_DAMAGE_REDUCE/100
end


function inside_bastion_modifier_friendly:GetMagicalDamageReduction()
    return ITEM_RPC_HORN_OF_THE_TRIUMPHANT_DAMAGE_REDUCE/100
end

function inside_bastion_modifier_friendly:GetPureDamageReduction()
    return ITEM_RPC_HORN_OF_THE_TRIUMPHANT_DAMAGE_REDUCE/100
end

function inside_bastion_modifier_friendly:GetPureDamageReduction()
    return ITEM_RPC_HORN_OF_THE_TRIUMPHANT_DAMAGE_REDUCE/100
end

function inside_bastion_modifier_friendly:GetRoshpitMasterGreenDMG()
    return ITEM_RPC_HORN_OF_THE_TRIUMPHANT_ATK_DMG_PCT_ALLY
end

function inside_bastion_modifier_friendly:GetPercentHealthBonus()
    local ability = self:GetAbility()
    return ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_HORN_OF_THE_TRIUMPHANT_GEM_SAPPHIRE)/100
end

function inside_bastion_modifier_friendly:GetRoshpitArmorBonus()
    local ability = self:GetAbility()
    return ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_HORN_OF_THE_TRIUMPHANT_GEM_AMETHYST1)   
end

function inside_bastion_modifier_friendly:GetRoshpitMagicArmorBonus()
    local ability = self:GetAbility()
    return ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_HORN_OF_THE_TRIUMPHANT_GEM_AMETHYST1)   
end
-- ENEMY INSIDE BASTION

function inside_bastion_modifier_enemy:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
    }

    return funcs
end

function inside_bastion_modifier_enemy:IsDebuff()
    return true
end

function inside_bastion_modifier_enemy:OnCreated()
    if not IsServer() then
        return false
    end
    self:SetSpecialTypes({
        MODIFIER_ROSHPIT_SPELL_PIERCE_BONUS,
        MODIFIER_ROSHPIT_ARMOR_PIERCE_BONUS,
        MODIFIER_ROSHPIT_ARMOR_BONUS,
        MODIFIER_ROSHPIT_MAGIC_ARMOR_BONUS
    })
    self:StartIntervalThink(0.03)
end

function inside_bastion_modifier_enemy:CheckState()
    local state = {
    [MODIFIER_STATE_ROOTED] = true,
    }

    return state
end

function inside_bastion_modifier_enemy:OnIntervalThink()
    local dummy = self:GetCaster()
    local enemy = self:GetParent()
    local distance = WallPhysics:GetDistance2d(dummy:GetAbsOrigin(), enemy:GetAbsOrigin())
    if distance > 8 then
        local fv = ((dummy:GetAbsOrigin() - enemy:GetAbsOrigin())*Vector(1,1,0)):Normalized()
        enemy:SetAbsOrigin(enemy:GetAbsOrigin() + fv*8)
    end
end

function inside_bastion_modifier_enemy:GetModifierAttackRangeBonus()
    return self:GetStackCount()*-1
end

function inside_bastion_modifier_enemy:GetRoshpitSpellPierceBonus()
    local ability = self:GetAbility()
    return ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_HORN_OF_THE_TRIUMPHANT_GEM_RUBY1)
end

function inside_bastion_modifier_enemy:GetRoshpitArmorPierceBonus()
    local ability = self:GetAbility()
    return ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_HORN_OF_THE_TRIUMPHANT_GEM_RUBY1)
end

function inside_bastion_modifier_enemy:GetRoshpitArmorBonus()
    local ability = self:GetAbility()
    return ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_HORN_OF_THE_TRIUMPHANT_GEM_AMETHYST2)   
end

function inside_bastion_modifier_enemy:GetRoshpitMagicArmorBonus()
    local ability = self:GetAbility()
    return ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_HORN_OF_THE_TRIUMPHANT_GEM_AMETHYST2)   
end