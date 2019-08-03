require('/npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')
modifier_chernobog_3_e_teleportation = class(npc_base_modifier, nil, npc_base_modifier)
local class = modifier_chernobog_3_e_teleportation

local modifiers = {
    cooldown = 'modifier_chernobog_3_e_teleportation_cooldown',
    enemyEffectE3 = 'modifier_chernobog_3_e_teleportation_enemy_effect_e3'
}

function class:IsDebuff()
    return false
end
function class:OnCreated()
    self:SetSpecialTypes({ MODIFIER_SPECIAL_TYPE_ORDER_FILTER })
    self.drain_per_second = self:GetAbility():GetSpecialValueFor('drain_per_second')
    if self:GetCaster()['GetMaxHealth'] then
        self.caster = self:GetCaster()
        self:StartIntervalThink(1)
    end
end
function class:SetOrderType(orderType)
    self.orderType = orderType
    return self
end
function class:SetCooldown(cooldown)
    self.cooldown = cooldown
    return self
end
function class:StartCooldown()
    local parent = self:GetParent()
    parent:AddNewModifier(parent, self:GetAbility(), modifiers.cooldown, { duration = self.cooldown })
end
function class:HasCooldown()
    return self:GetParent():HasModifier(modifiers.cooldown)
end
function class:GetMaxDistance()
    if not self.baseDistance then
        self.baseDistance = self:GetAbility():GetSpecialValueFor('range')
    end
    return self.baseDistance + CHERNOBOG_E3_DISTANCE * self:GetCaster().e3_level
end
function class:OnIntervalThink()
    local caster = self.caster
    if not caster:HasModifier("modifier_chernobog_glyph_5_1") or caster:GetHealth() / caster:GetMaxHealth() > CHERNOBOG_T51_DRAIN_HP_CAP_PCT then
        local healthDrain = caster:GetMaxHealth() * self.drain_per_second/100
        local newHealth = math.max(caster:GetHealth() - healthDrain, 1)
        caster:SetHealth(newHealth)
    end
    if not caster:HasModifier("modifier_chernobog_glyph_5_1") or caster:GetMana() / caster:GetMaxMana() > CHERNOBOG_T51_DRAIN_MP_CAP_PCT then
        local manaDrain = caster:GetMaxMana() * self.drain_per_second/100
        caster:ReduceMana(manaDrain)
    end
end
function class:OnOrderFilter(data)
    if not IsServer() then
        return
    end
    if not self.caster then
        return
    end
    if not self.orderType or not self.cooldown then
        error('Order type or cooldown not defined')
    end
    if data.order_type ~= self.orderType then
        return
    end

    local parent = self:GetParent()
    if not parent:IsAlive() then
        return
    end
    if parent:IsRooted()
            or parent:IsStunned()
            or parent:IsFakeStunned()
            or parent:IsSilenced()
            or parent:IsFrozen()
            or parent:IsRooted()
            or self:HasCooldown()
        then
        return
    end

    if self.orderType == DOTA_UNIT_ORDER_MOVE_TO_POSITION then
        self:OnOrderMove(data)
    elseif self.orderType == DOTA_UNIT_ORDER_ATTACK_TARGET then
        self:OnOrderAttack(data)
    end

end
function class:OnOrderAttack(data)
    local parent = self:GetCaster()

    if not data.entindex_target then
        return
    end

    local enemy = EntIndexToHScript(data.entindex_target)
    if not IsValidEntity(enemy) then
        return
    end
    if enemy.dummy or enemy:GetClassname() == "dota_item_drop" or enemy:GetTeamNumber() == parent:GetTeamNumber() then
        return
    end
    local distance = WallPhysics:GetDistance2d(enemy:GetAbsOrigin(), parent:GetAbsOrigin())
    if distance > self:GetMaxDistance() then
        return
    end
    local afterWallPosition = WallPhysics:WallSearch(parent:GetAbsOrigin(), enemy:GetAbsOrigin(), parent)
    if afterWallPosition ~= enemy:GetAbsOrigin() then
        return
    end

    onBlink(parent, self:GetAbility(), parent:GetAbsOrigin(), afterWallPosition)


    self:Teleport(afterWallPosition)
    self:StartCooldown()
    Filters:CastSkillArguments(3, self:GetCaster())

    Timers:CreateTimer(0.15, function()
        self:ApplyE3Debuff(enemy, nil)
        StartAnimation(parent, {duration = 0.3, activity = ACT_DOTA_ATTACK, rate = 3})
        Filters:PerformAttackSpecial(parent, enemy, true, true, true, true, false, false, false)
    end)
end
function class:OnOrderMove(data)
    local parent = self:GetParent()
    local newPosition = GetGroundPosition(Vector(data.position_x, data.position_y, 0), parent)
    local afterWallPosition = WallPhysics:WallSearch(parent:GetAbsOrigin(), newPosition, parent)
    local parentOrigin = parent:GetAbsOrigin()
    newPosition = afterWallPosition
    local distance = WallPhysics:GetDistance2d(parentOrigin, newPosition)
    local maxDistance = self:GetMaxDistance()
    if distance > maxDistance then
        local clampedVector = WallPhysics:ClampedVector(parentOrigin, newPosition, maxDistance)
        newPosition = GetGroundPosition(clampedVector, parent)
    end
    onBlink(parent, self:GetAbility(), parent:GetAbsOrigin(), newPosition)

    self:Teleport(newPosition)
    self:ApplyE3Debuff(nil, newPosition)
    self:StartCooldown()
    Filters:CastSkillArguments(3, self:GetCaster())

end
function class:Teleport(position)
    local parent = self:GetParent()

    local particleName = "particles/roshpit/chernobog/chernobog_rune_c_c.vpcf"
    local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(particle1, 0, parent:GetAbsOrigin())

    FindClearSpaceForUnit(parent, position, false)

    local particle2 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(particle2, 0, parent:GetAbsOrigin() + Vector(0, 0, 40))
    Timers:CreateTimer(3, function()
        ParticleManager:DestroyParticle(particle1, false)
        ParticleManager:ReleaseParticleIndex(particle1)

        ParticleManager:DestroyParticle(particle2, false)
        ParticleManager:ReleaseParticleIndex(particle2)
    end)
end

function class:ApplyE3Debuff(target, position)
    local parent = self.caster
    local ability = self:GetAbility()
    if parent.e3_level == nil
            or parent.e3_level == 0
            or not parent
            or not parent['AddNewModifier']
            or not parent['HasModifier']
    then
        return
    end
    if parent:HasModifier('modifier_chernobog_glyph_6_1') then
        local position = position
        if target ~= nil then
            position = target:GetAbsOrigin()
        end
        local targets = FindUnitsInRadius(parent:GetTeamNumber(),position, nil, CHERNOBOG_T61_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
        for _, target in pairs(targets) do
            target:AddNewModifier(parent, ability, modifiers.enemyEffectE3, { duration = CHERNOBOG_E3_POSTMIT_DUR_BASE })
        end
    else
        if target == nil or not target['AddNewModifier'] then
            return
        end
        target:AddNewModifier(parent, ability, modifiers.enemyEffectE3, { duration = CHERNOBOG_E3_POSTMIT_DUR_BASE })
    end
end