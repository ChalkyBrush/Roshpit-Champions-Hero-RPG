require('/util')
require('heroes/nightstalker/chernobog_constants')
require('heroes/nightstalker/common')
require('/npc_abilities/base_ability')

local STATUSES = {
    INACTIVE = 0,
    ACTIVE_ATTACK = 1,
    ACTIVE_MOVE = 2,
}
local prefix = '3_e_'
local modifiers = {
    teleportation = 'modifier_chernobog_3_e_teleportation',
    teleportation_cooldown = 'modifier_chernobog_3_e_teleportation_cooldown',
    teleportation_enemy_effect_e3 = 'modifier_chernobog_3_e_teleportation_enemy_effect_e3',
    movespeed = 'modifier_chernobog_3_e_movespeed',
    evasion_e4 = 'modifier_chernobog_3_e_evasion_e4',
    bonus_damage_e1 = 'modifier_chernobog_3_e_bonus_damage_e1',
    passive = "modifier_chernobog_3_e_passive",
    teleportation_buff = "modifier_3_e_teleportation_buff"
}
local shadowsModifiers = {
    aura = 'modifier_chernobog_shadows_aura',
    enemy_effect = 'modifier_chernobog_shadows_enemy_effect'
}
for modifierPath, modifier in pairs(modifiers) do
    LinkLuaModifier(modifier, "heroes/nightstalker/modifiers/"..prefix..modifierPath, LUA_MODIFIER_MOTION_NONE)
end
for modifierPath, modifier in pairs(shadowsModifiers) do
    LinkLuaModifier(modifier, "heroes/nightstalker/modifiers/shadows_"..modifierPath, LUA_MODIFIER_MOTION_NONE)
end

chernobog_3_e = class(npc_base_ability, nil, npc_base_ability)
local class = chernobog_3_e

function class:GetIntrinsicModifierName()
    return modifiers.passive
end

function class:InitValues()
    self.status = self.status or 0

end
function class:SwapStatus()
    self:SetStatus((self.status + 1) % 3)
    self:StartCooldown(self:GetCooldown(self:GetLevel()))

end
function class:SetStatus(newStatus)
    self.status = newStatus
    local toggled = self:GetToggleState()
    if (toggled and self.status == STATUSES.INACTIVE)
        or (not toggled and self.status ~= STATUSES.INACTIVE)
        then
        self.toggledSpecial = true
        self:ToggleAbility()
    end
    local playerId = self:GetCaster():GetPlayerOwnerID()
    CustomNetTables:SetTableValue("hero_values", tostring(playerId) .. "-chernobog-3-e", {status = self.status})
end

function class:GetAbilityTextureName()
    local playerId = self:GetCaster():GetPlayerOwnerID()
    local abilityState = CustomNetTables:GetTableValue("hero_values", tostring(playerId) .. "-chernobog-3-e")
    local status = 0
    if abilityState then
        status = abilityState.status
    end
    if status == STATUSES.INACTIVE then
        return 'night_stalker_hunter_in_the_night'
    elseif status == STATUSES.ACTIVE_ATTACK then
        return 'night_stalker_hunter_in_the_night' -- just make recolored to red e3
    else
        return 'chernobog/chernobog_rune_e_3'
    end
end

function class:OnToggle()
    self:InitValues()
    if not self.toggledSpecial then
        local caster = self:GetCaster()
        if not caster:IsAlive() then
            self:SetStatus(STATUSES.INACTIVE)
            return
        end
            self:SwapStatus()
            self:DoStatusThings()

            Filters:CastSkillArguments(3, self:GetCaster())
    else
        self.toggledSpecial = false
    end
end
function class:DoActiveVisualThings()
    local caster = self:GetCaster()
    if not caster:HasModifier("modifier_chernobog_demon_form") then
        -- caster:SetModel("models/heroes/nightstalker/nightstalker_night.vmdl")
        -- caster:SetOriginalModel("models/heroes/nightstalker/nightstalker_night.vmdl")   
        StartAnimation(caster, {duration = 0.9, activity = ACT_DOTA_NIGHTSTALKER_TRANSITION, rate = 1})
    else
        StartAnimation(caster, {duration = 0.9, activity = ACT_DOTA_ATTACK, rate = 2})
    end
    EmitSoundOn("Chernobog.ShadowWalkStart", caster)
    CustomAbilities:QuickAttachParticle("particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void_hit.vpcf", caster, 4)
end
function class:DoInactiveVisualThings()
    local caster = self:GetCaster()
    if not caster:HasModifier("modifier_chernobog_demon_form") then
        -- caster:SetModel("models/heroes/nightstalker/nightstalker.vmdl")
        -- caster:SetOriginalModel("models/heroes/nightstalker/nightstalker.vmdl")
    end
    StartAnimation(caster, {duration = 0.3, activity = ACT_DOTA_SPAWN, rate = 1.5})
    EmitSoundOn("Chernobog.Untoggle", caster)
    CustomAbilities:QuickAttachParticle("particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void_hit.vpcf", caster, 4)
end
function class:DoStatusThings()
    local caster = self:GetCaster()
    if self.status == STATUSES.ACTIVE_ATTACK or self.status == STATUSES.ACTIVE_MOVE then
        self:DoActiveVisualThings()
        if IsServer() then
            local orderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION
            local cooldown = CHERNOBOG_E_MOVE_TELEPORTATION_CD
            if self.status == STATUSES.ACTIVE_ATTACK then
                orderType = DOTA_UNIT_ORDER_ATTACK_TARGET
                cooldown = CHERNOBOG_E_ATTACK_TELEPORTATION_CD
            end
            caster:RemoveModifierByName(modifiers.teleportation)
            caster:RemoveModifierByName(modifiers.movespeed)
            if caster.e2_level > 0 then
                init_shadows_values_for_ability({
                    ability = self,
                    radius = CHERNOBOG_E2_RADIUS,
                    damagePercent = caster.e2_level * CHERNOBOG_E2_DMG_PCT,
                    thinkInterval = CHERNOBOG_E2_INTERVAL / (1 + caster.e4_level * CHERNOBOG_E4_SHADOWS_INTERVAL_SCALE),
                })
                caster:AddNewModifier(caster, self, shadowsModifiers.aura, {})
            end
            if caster.e4_level > 0 then
                caster:RemoveModifierByName(modifiers.evasion_e4)
                caster:AddNewModifier(caster, self, modifiers.evasion_e4, {})
            end
            caster:AddNewModifier(caster, self, modifiers.teleportation, {})
            local modifier = caster:AddNewModifier(caster, self, modifiers.teleportation, {})
            modifier
                :SetOrderType(orderType)
                :SetCooldown(cooldown)
        end

    else
        self:DoInactiveVisualThings()
        if IsServer() then
            caster:RemoveModifierByName(shadowsModifiers.aura)
            caster:RemoveModifierByName(modifiers.teleportation)
            caster:RemoveModifierByName(modifiers.movespeed)
            caster:AddNewModifier(caster, self, modifiers.movespeed, {})
            if caster.e4_level > 0 then
                local duration = self:GetDuration('buff', CHERNOBOG_E4_BASE_DUR + caster.e4_level * CHERNOBOG_E4_DUR)
                caster:AddNewModifier(caster, self, modifiers.evasion_e4, { duration = duration })
            end
        end
    end

end