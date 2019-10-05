require('heroes/lanaya/explosive_bomb')
require("/heroes/lanaya/trapper_constants")

local prefix = '3_e_'
local modifiers = {
    movespeed = 'modifier_trapper_3_e_movespeed'
}
for modifierPath, modifier in pairs(modifiers) do
    LinkLuaModifier(modifier, "heroes/lanaya/modifiers/"..prefix..modifierPath, LUA_MODIFIER_MOTION_NONE)
end
function vanish_cast(event)
    local caster = event.caster
    local ability = event.ability
    local duration = event.duration
    duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
    EmitSoundOn("Trapper.Vanish", caster)
    caster:AddNewModifier(caster, ability, modifiers.movespeed, { duration = duration})
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_trapper_vanish", {duration = duration})
    ProjectileManager:ProjectileDodge(caster)
    local a_c_level = Runes:GetTotalRuneLevel(caster, 1, "e_1", "trapper")
    if a_c_level > 0 then
        local runeAbility = caster.runeUnit:FindAbilityByName("trapper_rune_e_1")
        runeAbility:ApplyDataDrivenModifier(caster.runeUnit, caster, "modifier_trapper_rune_e_1_effect", {duration = duration})
        caster:SetModifierStackCount("modifier_trapper_rune_e_1_effect", runeAbility, a_c_level)
    end
    local b_c_level = Runes:GetTotalRuneLevel(caster, 2, "e_2", "trapper")
    if b_c_level > 0 then
        decoy(caster, ability, b_c_level)
    end
    local particleName = "particles/items2_fx/smoke_of_deceit.vpcf"
    local casterPos = caster:GetAbsOrigin()
    local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(particle1, 0, casterPos)
    ParticleManager:SetParticleControl(particle1, 1, Vector(400, 50, 20))
    Timers:CreateTimer(4, function()
        ParticleManager:DestroyParticle(particle1, false)
    end)
    Filters:CastSkillArguments(3, caster)
    --    if caster:HasModifier("modifier_trapper_glyph_6_1") then
    --        detonateBombs(caster)
    --    end
end

function vanish_apply(event)
    local target = event.target
    target:SetRenderMode(10)
end

function vanish_destroy(event)
    local target = event.target
    target:SetRenderMode(0)
end

function action_leap_cast(event)
    local caster = event.caster
    local ability = event.ability
    local target = event.target_points[1]
    local casterOrigin = caster:GetAbsOrigin()
    local max_distance = event.max_distance
    local targetOrigin = target
    local fv = (targetOrigin * Vector(1, 1, 0) - casterOrigin * Vector(1, 1, 0)):Normalized()
    local distance = WallPhysics:GetDistance(casterOrigin * Vector(1, 1, 0), targetOrigin * Vector(1, 1, 0))
    if caster:HasModifier("modifier_trapper_immo3_effect") then
        max_distance = max_distance + TRAPPER_IMMORTAL_WEAPON_3_RANGE
    end
    if caster:HasModifier('modifier_trapper_glyph_1_1') then
        decoy(caster, ability, caster.e2_level)
    end
    distance = math.min(distance, max_distance)
    caster:SetForwardVector(fv)
    local forwardSpeed = 40
    forwardSpeed = Filters:GetAdjustedESpeed(caster, forwardSpeed, false)
    action_leap_jump(caster, fv, distance, 35, forwardSpeed, 1, 1)
    local animationTime = math.min(500 / distance, 1)
    EmitSoundOn("Trapper.ActionLeap"..RandomInt(1, 2), caster)
    StartAnimation(caster, {duration = 1, activity = ACT_DOTA_ATTACK, rate = animationTime, translate = "meld"})
    Filters:CastSkillArguments(3, caster)
end

function action_leap_jump(unit, forwardVector, distance, liftForce, propulsion, gravity, fallGravity)
    local gameMaster = Events.GameMaster
    local gameMasterAbil = gameMaster:FindAbilityByName("npc_abilities")
    local jumpingModifier = "modifier_jumping"
    gameMasterAbil:ApplyDataDrivenModifier(gameMaster, unit, "modifier_jumping", {duration = 5})
    local liftDuration = distance / propulsion / 2
    local endLocation = unit:GetAbsOrigin() + forwardVector * distance
    for i = 1, liftDuration, 1 do
        Timers:CreateTimer(0.03 * i, function()
            local currentPosition = unit:GetAbsOrigin()

            local newPosition = currentPosition + forwardVector * propulsion + Vector(0, 0, liftForce - i * gravity)

            local obstruction = WallPhysics:FindNearestObstruction(newPosition)
            local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition, unit)
            if not blockUnit then
                unit:SetOrigin(newPosition)
            else
                unit:SetOrigin(newPosition - forwardVector * propulsion)
            end

        end)
    end
    local fallLoop = 0
    Timers:CreateTimer(0.03 * liftDuration + 0.03, function()
        Timers:CreateTimer(0.03 * fallLoop, function()
            fallLoop = fallLoop + 1
            local currentPosition = unit:GetAbsOrigin()
            local newPosition = currentPosition + forwardVector * propulsion - Vector(0, 0, fallLoop * gravity * fallGravity)

            local obstruction = WallPhysics:FindNearestObstruction(newPosition * Vector(1, 1, 0))
            local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition * Vector(1, 1, 0), unit)
            if unit:HasModifier("modifier_jumping") then
                if not blockUnit then
                    unit:SetOrigin(newPosition)
                else
                    unit:SetOrigin(newPosition - forwardVector * propulsion)
                end
            end
            if fallLoop > liftDuration then
                unit:RemoveModifierByName("modifier_jumping")
                FindClearSpaceForUnit(unit, newPosition, false)
            else
                if newPosition.x <= endLocation.x + 20 and newPosition.x >= endLocation.x - 20 and newPosition.y <= endLocation.y + 20 and newPosition.y >= endLocation.y - 20 then
                    unit:RemoveModifierByName("modifier_jumping")
                    FindClearSpaceForUnit(unit, newPosition, false)
                else
                    return 0.03
                end
            end
        end)
    end)
end

function decoy(caster, casterAbility, runesCount)
    local decoyPosition = caster:GetAbsOrigin() - 25 * caster:GetForwardVector()
    local decoy = CreateUnitByName("lanaya_decoy", decoyPosition, true, nil, nil, caster:GetTeamNumber())

    local ability = decoy:FindAbilityByName("lanaya_decoy_passive")
    ability:SetLevel(1)
    decoy.owner = caster:GetPlayerOwnerID()
    decoy.summoner = caster
    decoy.ability = casterAbility
    decoy:SetOwner(caster)
    decoy:SetControllableByPlayer(caster:GetPlayerID(), true)
    decoy.dieTime = TRAPPER_E2_DECOY_DURATION
    decoy.dieDamage = TRAPPER_E2_STATS_DAMAGE * (caster:GetStrength() + caster:GetAgility() + caster:GetIntellect()) * runesCount
    decoy:AddAbility("ability_die_after_time_generic"):SetLevel(1)
    StartAnimation(decoy, {duration = 0.8, activity = ACT_DOTA_ATTACK, rate = 1.0})
    -- local summonAbil = decoy:AddAbility("ability_summoned_unit")
    -- summonAbil:SetLevel(1)

    local minionHealth = TRAPPER_E2_DECOY_HEALTH
    if caster:HasModifier('modifier_trapper_glyph_6_2') then
        minionHealth = T62_DECOY_HEALTH
        decoy.dieDamage = decoy.dieDamage * (1 + T62_DECOY_DAMAGE_AMPLIFY_PERCENT / 100)
    end

    decoy:SetMaxHealth(minionHealth)
    decoy:SetBaseMaxHealth(minionHealth)
    decoy:SetHealth(minionHealth)
    decoy:Heal(minionHealth, decoy)
    decoy:SetPhysicalArmorBaseValue(0)

    local runeAbility = caster.runeUnit2:FindAbilityByName("trapper_rune_r_2")
    local decoyDuration = Filters:GetAdjustedBuffDuration(caster, 15, false)
    runeAbility:ApplyDataDrivenModifier(caster.runeUnit2, decoy, "modifier_decoy_effect", {duration = TRAPPER_E2_DECOY_DURATION - 0.5})
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), decoy:GetAbsOrigin(), nil, TRAPPER_E2_EXPLODE_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    for _,enemy in pairs(enemies) do
        enemy:MoveToTargetToAttack(decoy)
    end
end

function decoy_die(event)
    local decoy = event.caster
    local damage = decoy.dieDamage
    local position = decoy:GetAbsOrigin()

    local particleName = "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf"
    local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, decoy)
    ParticleManager:SetParticleControl(particle1, 0, position)
    Timers:CreateTimer(0.5, function()
        ParticleManager:DestroyParticle(particle1, false)
    end)

    local enemies = FindUnitsInRadius(decoy:GetTeamNumber(), position, nil, TRAPPER_E2_EXPLODE_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    if #enemies > 0 then
        for _, enemy in pairs(enemies) do
            Damage:Apply({
                attacker = decoy.summoner,
                victim = enemy,
                damage = damage,
                damageType = DAMAGE_TYPE_PURE,
                source = decoy.ability,
                sourceType = BASE_ABILITY_E,
                elements = {
                    RPC_ELEMENT_NORMAL
                },
                ignoreSteadfast = true
            })
        end
    end
end

function invisible_think(event)
    local caster = event.caster
    local ability = event.ability
    if not caster:IsInvisible() then
        return
    end

    local runesCount = Runes:GetTotalRuneLevel(caster, 4, "e_4", "trapper")
    if runesCount <= 0 then
        return
    end
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_trapper_d_c_post_amp", {duration = 0.6})
    caster:SetModifierStackCount("modifier_trapper_d_c_post_amp", caster, runesCount)
end

function vanish_thinking(event)
    local caster = event.caster
    local ability = event.ability
    if caster:HasModifier("modifier_trapper_glyph_2_1") then
        local healAmount = caster:GetMaxHealth() * TRAPPER_GLYPH_2_1_HEAL_PCT/100
        Filters:ApplyHeal(caster, caster, healAmount, true, false)
        -- PopupHealing(caster, healAmount)
        PopupFirstAid(caster)
    end
end
