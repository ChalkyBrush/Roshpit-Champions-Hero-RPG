require('heroes/antimage/arkimus_constants')
require('heroes/base_ability')
require('heroes/antimage/arkimus_common')
arkimus_orbital_leap = class(base_ability)

function arkimus_orbital_leap:GetBaseManaCost(level)
    return 0
end

function arkimus_orbital_leap:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end

function arkimus_orbital_leap:GetAbilitySlot()
    return DOTA_E_SLOT
end

function arkimus_orbital_leap:GetCastPoint()
    return 0
end

function arkimus_orbital_leap:GetBaseCooldown(level)
    if level == -1 then
        level = self:GetLevel() - 1
    end
    return ARKIMUS_E_COOLDOWN[level + 1]
end

function arkimus_orbital_leap:GetCastRange()
    return ARKIMUS_E_CAST_RANGE[self:GetLevel()]
end

function arkimus_orbital_leap:GetIntrinsicModifierName()
    return "modifier_arkimus_orbital_leap"
end

function arkimus_orbital_leap:OnSpellStart()
	local caster = self:GetCaster()
    local ability = self
    local target = nil
    if not self.CustomTarget then
        target = self:GetCursorPosition()
    else
        target = self.CustomTarget
        self.CustomTarget = nil
    end
    caster:AddNewModifier(caster, ability, "modifier_arkimus_leaping", {duration = 4})
    local distance = WallPhysics:GetDistance2d(target, caster:GetAbsOrigin())
    ability.targetPoint = target
	ability.jumpVelocity = distance / 20
	ability.jumpVelocity = Filters:GetAdjustedESpeed(caster, ability.jumpVelocity, false)
	ability.liftVelocity = 20
	ability.liftVelocity = Filters:GetAdjustedESpeed(caster, ability.liftVelocity, true)
	local heightDiff = caster:GetAbsOrigin().z - target.z
	if heightDiff > 300 then
		heightDiff = 200
	elseif heightDiff < -300 then
		heightDiff = -200
	end
	ability.liftVelocity = ability.liftVelocity - heightDiff / 20
	ability.rising = true
	ability.jumpFV = ((target - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	ability.interval = 0
    if not self.CastByUltimate then
        StartAnimation(caster, {duration = 1.5, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1})
        EmitSoundOn("Akrimus.Jump.VO", caster)
        Filters:CastSkillArguments(BASE_ABILITY_E, caster)
        if caster:HasModifier("modifier_arkimus_e_free_cast") then
            ability:EndCooldown()
            local newStacks = caster:GetModifierStackCount("modifier_arkimus_e_free_cast", caster) - 1
            if newStacks > 0 then
                caster:SetModifierStackCount("modifier_arkimus_e_free_cast", caster, newStacks)
            else
                caster:RemoveModifierByName("modifier_arkimus_e_free_cast")
            end
        end
        if caster:HasAbility("arkimus_energy_field") then
            local energyField = caster:FindAbilityByName("arkimus_energy_field")
            if energyField.rotationDelta then
                energyField.rotationDelta = math.max(14, energyField.rotationDelta - 4)
            end
        end
    else
        self.CastByUltimate = false
    end
end

modifier_arkimus_orbital_leap = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_arkimus_orbital_leap", "heroes/antimage/arkimus_orbital_leap", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_orbital_leap:OnCreated()
    if IsServer() then
        local hero = self:GetParent()
        local ability = self:GetAbility()
        hero:AddNewModifier(hero, ability, "modifier_arkimus_e_free_cast_thinker", {})
        hero:AddNewModifier(hero, ability, "modifier_arkimus_e_4", {})
        hero:AddNewModifier(hero, ability, "modifier_arkimus_e_2", {})
    end
end
function modifier_arkimus_orbital_leap:IsHidden()
    return true
end
function modifier_arkimus_orbital_leap:IsBuff()
    return true
end
function modifier_arkimus_orbital_leap:OnRemoved()
    if IsServer() then
        local hero = self:GetParent()
        local ability = self:GetAbility()
        hero:RemoveModifierByName("modifier_arkimus_e_free_cast_thinker")
        hero:RemoveModifierByName("modifier_arkimus_e_4")
        hero:RemoveModifierByName("modifier_arkimus_e_2")
    end
end


modifier_arkimus_leaping = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_arkimus_leaping", "heroes/antimage/arkimus_orbital_leap", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_leaping:IsPassive()
    return false
end
function modifier_arkimus_leaping:IsHidden()
    return false
end
function modifier_arkimus_leaping:OnCreated()
    self:StartIntervalThink(0.03)
end
function modifier_arkimus_leaping:OnIntervalThink()
    if IsServer() then
        local caster = self:GetParent()
        local ability = self:GetAbility()

        local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.targetPoint)

        local fv = ability.jumpFV
        -- if distance < 60 then
        -- fv = Vector(0,0)
        -- end
        local height = (caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster))
        if height < math.abs(ability.liftVelocity) then
            --print(height)
            if not ability.rising then
                caster:RemoveModifierByName("modifier_arkimus_leaping")
            end
        end

        local blockSearch = caster:GetAbsOrigin() * Vector(1, 1, 0) + Vector(0, 0, GetGroundHeight(caster:GetAbsOrigin(), caster))
        local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
        local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch + ability.jumpFV * 30), caster)
        if blockUnit then
            fv = Vector(0, 0)
        end
        caster:SetAbsOrigin(caster:GetAbsOrigin() + fv * ability.jumpVelocity + Vector(0, 0, ability.liftVelocity))
        local acceleration = 2
        Filters:GetAdjustedESpeed(caster, acceleration, false)
        ability.liftVelocity = ability.liftVelocity - acceleration
        if ability.liftVelocity <= 0 then
            ability.rising = false
        end
        ability.interval = ability.interval + 1
        if ability.interval % 3 == 0 then
            local pfx = ParticleManager:CreateParticle("particles/roshpit/arkimus/jump_fade.vpcf", PATTACH_CUSTOMORIGIN, caster)
            ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
            Timers:CreateTimer(0.4, function()
                ParticleManager:DestroyParticle(pfx, false)
            end)
        end
    end
end
function modifier_arkimus_leaping:GetEffectName()
    return "particles/roshpit/arkimus/jump_fade.vpcf"
end
function modifier_arkimus_leaping:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN
end
function modifier_arkimus_leaping:CheckState()
    local state = {
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_DISARMED] = true
    }

    return state
end
function modifier_arkimus_leaping:OnDestroy()
    if IsServer() then
        local caster = self:GetParent()
        local ability = self:GetAbility()
        Timers:CreateTimer(0.03, function()
            WallPhysics:ClearSpaceForUnit(caster, caster:GetAbsOrigin())
        end)
        local e_1_level = caster:GetRuneValue("e", 1)
        if e_1_level > 0 then
            local searchRadius = ARKIMUS_E1_RADIUS_BASE + e_1_level * ARKIMUS_E1_RADIUS
            local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * ARKIMUS_E1_DMG_OF_ATTACK_POWER_PCT/100 * e_1_level

            local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, searchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
            if #enemies > 0 then
                for _, enemy in pairs(enemies) do
                    CreateZonisBeam(caster:GetAbsOrigin(), enemy:GetAbsOrigin() + Vector(0, 0, 50))
                    enemy:AddNewModifier(caster, ability, "modifier_arkimus_stun", {duration = ARKIMUS_E1_STUN})
                    Filters:ApplyStun(caster, ARKIMUS_E1_STUN, enemy)
                    Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_E, RPC_ELEMENT_ARCANE, RPC_ELEMENT_LIGHTNING)
                end
            else
                for i = 1, 3, 1 do
                    local fv = WallPhysics:rotateVector(caster:GetForwardVector(), 2 * math.pi * i / 3)
                    CreateZonisBeam(caster:GetAbsOrigin(), caster:GetAbsOrigin() + fv * 120 + Vector(0, 0, 60))
                end
            end
            EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Arkimus.JumpLightning", caster)
        end
        local e_3_level = caster:GetRuneValue("e", 3)
        if e_3_level > 0 then
            local duration = Filters:GetAdjustedBuffDuration(caster, ARKIMUS_E3_DURATION, false)
            caster:AddNewModifier(caster, ability, "modifier_arkimus_e_3_buff", {duration = duration})
            caster:SetModifierStackCount("modifier_arkimus_e_3_buff", caster, e_3_level)
        end
    end
end

modifier_arkimus_e_free_cast = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_arkimus_e_free_cast", "heroes/antimage/arkimus_orbital_leap", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_e_free_cast:IsHidden()
    return false
end
function modifier_arkimus_e_free_cast:IsBuff()
    return true
end

modifier_arkimus_e_free_cast_thinker = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_arkimus_e_free_cast_thinker", "heroes/antimage/arkimus_orbital_leap", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_e_free_cast_thinker:IsHidden()
    return true
end
function modifier_arkimus_e_free_cast_thinker:IsPassive()
    return true
end
function modifier_arkimus_e_free_cast_thinker:OnCreated()
    if IsServer() then
        self:StartIntervalThink(ARKIMUS_E_FREE_CAST_REFRESH)
    end
end

function modifier_arkimus_e_free_cast_thinker:OnIntervalThink()
    if IsServer() then
        local caster = self:GetCaster()
        local ability = self:GetAbility()
        local stackCount = caster:GetModifierStackCount("modifier_arkimus_e_free_cast", caster)
        local maxStacks = ARKIMUS_E_FREE_CASTS
        if caster:HasModifier("modifier_arkimus_glyph_4_1") then
            maxStacks = maxStacks + ARKIMUS_GLYPH_4_1_E_FREE_CAST
        end
        if stackCount <= maxStacks then
            caster:AddNewModifier(caster, ability, "modifier_arkimus_e_free_cast", {})
            local newStacks = math.min(stackCount + 1, maxStacks)
            caster:SetModifierStackCount("modifier_arkimus_e_free_cast", caster, newStacks)
        end
    end
end

modifier_arkimus_e_2 = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_arkimus_e_2", "heroes/antimage/arkimus_orbital_leap", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_e_2:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_MANA_GAINED,
	}

	return funcs
end
function modifier_arkimus_e_2:IsPassive()
    return true
end
function modifier_arkimus_e_2:IsHidden()
    return true
end
function modifier_arkimus_e_2:IsBuff()
    return true
end
function modifier_arkimus_e_2:OnManaGained(event)
    if IsServer() then
        local hero = self:GetParent()
        local missingMana = hero:GetMaxMana() - hero:GetMana()
        if missingMana > 0 then
            local manaGained = math.min(missingMana, event.gain)
            local e_2_level = hero:GetRuneValue("e", 2)
            local healAmount = manaGained * ARKIMUS_E2_HEAL_PER_MANA_GAIN * e_2_level
            Filters:ApplyHeal(hero, hero, healAmount, true, true, nil)
        end
    end
end

modifier_arkimus_e_3_buff = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_arkimus_e_3_buff", "heroes/antimage/arkimus_orbital_leap", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_e_3_buff:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_ARMOR_PIERCE_BONUS,
        MODIFIER_ROSHPIT_SPELL_PIERCE_BONUS
    })
end

function modifier_arkimus_e_3_buff:IsPassive()
    return true
end
function modifier_arkimus_e_3_buff:IsHidden()
    return false
end
function modifier_arkimus_e_3_buff:GetRoshpitArmorPierceBonus()
    return self:GetParent():GetRuneValue("e", 3) * ARKIMUS_E3_PIERCES
end
function modifier_arkimus_e_3_buff:GetRoshpitSpellPierceBonus()
    return self:GetParent():GetRuneValue("e", 3) * ARKIMUS_E3_PIERCES
end
function modifier_arkimus_e_3_buff:GetTexture()
    return "arkimus/arkimus_rune_e_3"
end


modifier_arkimus_e_4 = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_arkimus_e_4", "heroes/antimage/arkimus_orbital_leap", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_e_4:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EVASION_CONSTANT,
	}

	return funcs
end
function modifier_arkimus_e_4:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_AGILITY_BONUS
    })
end

function modifier_arkimus_e_4:IsPassive()
    return true
end
function modifier_arkimus_e_4:IsHidden()
    return true
end
function modifier_arkimus_e_4:GetRoshpitAgilityBonus()
    return self:GetParent():GetRuneValue("e", 4) * ARKIMUS_E4_AGI
end
function modifier_arkimus_e_4:GetModifierEvasion_Constant()
    local evasion = self:GetParent():GetRuneValue("e", 4) * ARKIMUS_E4_EVASION
    return evasion
end