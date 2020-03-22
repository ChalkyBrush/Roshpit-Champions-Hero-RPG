require('heroes/nightstalker/chernobog_constants')
require('heroes/base_ability')
--require('heroes/nightstalker/chernobog_common')
chernobog_shadow_hunt = class(base_ability)

function chernobog_shadow_hunt:GetBaseManaCost(level)
    return 0
end

function chernobog_shadow_hunt:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_TOGGLE + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL + DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT + DOTA_ABILITY_BEHAVIOR_AOE
end

function chernobog_shadow_hunt:GetAbilitySlot()
    return DOTA_E_SLOT
end

function chernobog_shadow_hunt:GetCastPoint()
    return 0
end

function chernobog_shadow_hunt:GetBaseCooldown(level)
    if level == -1 then
        level = self:GetLevel() - 1
    end
    return CHERNOBOG_E_COOLDOWN[level + 1]
end

function chernobog_shadow_hunt:GetIntrinsicModifierName()
    return "modifier_chernobog_shadow_hunt"
end

function chernobog_shadow_hunt:OnToggle()
    if IsServer() then
        local ability = self
        local hero = self:GetCaster()
        if self:GetToggleState() then
            hero:AddNewModifier(hero, ability, "modifier_chernobog_shadow_hunt_buff", {})
        else
            hero:RemoveModifierByName("modifier_chernobog_shadow_hunt_buff")
        end
    end
end 
function chernobog_shadow_hunt:GetAbilityTextureName()
    return 'night_stalker_hunter_in_the_night'
end

modifier_chernobog_shadow_hunt_buff = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_shadow_hunt_buff", "heroes/nightstalker/chernobog_shadow_hunt", LUA_MODIFIER_MOTION_NONE)

function modifier_chernobog_shadow_hunt_buff:OnCreated()
    if IsServer() then
        local hero = self:GetParent()
        local ability = self:GetAbility()
        local e_1_level = hero:GetRuneValue("e", 1)
        if e_1_level > 0 then
            hero:AddNewModifier(hero, ability, "modifier_chernobog_e_1", {})
            hero:SetModifierStackCount("modifier_chernobog_e_1", hero, e_1_level)
        end
        local e_2_level = hero:GetRuneValue("e", 2)
        if e_2_level > 0 then
            hero:AddNewModifier(hero, ability, "modifier_chernobog_e_2", {})
        end
        local e_3_level = hero:GetRuneValue("e", 3)
        if e_3_level > 0 then
            hero:AddNewModifier(hero, ability, "modifier_chernobog_e_3", {})
        end
        local e_4_level = hero:GetRuneValue("e", 4)
        if e_4_level > 0 then
            hero:AddNewModifier(hero, ability, "modifier_chernobog_e_4", {})
        end
    end
    self:StartIntervalThink(CHERNOBOG_E_DRAIN_INTERVAL)
end
function modifier_chernobog_shadow_hunt_buff:OnRemoved()
    if IsServer() then
        local hero = self:GetParent()
        local ability = self:GetAbility()
        hero:RemoveModifierByName("modifier_chernobog_e_1")
        hero:RemoveModifierByName("modifier_chernobog_e_2")
        hero:RemoveModifierByName("modifier_chernobog_e_3")
        local e_4_level = hero:GetRuneValue("e", 4)
        if e_4_level > 0 then
            local buffDuration = Filters:GetAdjustedBuffDuration(hero, CHERNOBOG_E4_BASE_DUR + CHERNOBOG_E4_DUR * e_4_level, false)
            hero:AddNewModifier(hero, ability, "modifier_chernobog_e_4", { duration = buffDuration })
        end
    end
end
function modifier_chernobog_shadow_hunt_buff:OnIntervalThink()
    if IsServer() then
        local hero = self:GetParent()
        local currentHealth = hero:GetHealth()
        local currentMana = hero:GetMana()
        local minHealth = 1
        local minMana = 0
        if hero:HasModifier("modifier_chernobog_glyph_5_1") then
            minHealth = hero:GetMaxHealth() * CHERNOBOG_T51_DRAIN_HP_CAP_PCT
            minMana = hero:GetMaxMana() * CHERNOBOG_T51_DRAIN_MP_CAP_PCT
        end
        if currentHealth > minHealth then
            hero:SetHealth(math.max(currentHealth - hero:GetMaxHealth() * CHERNOBOG_E_DRAIN_INTERVAL * CHERNOBOG_E_HP_DRAIN[self:GetAbility():GetLevel()] / 100, minHealth))
        end
        if currentMana > minMana then
            hero:ReduceMana(math.min(hero:GetMaxMana() * CHERNOBOG_E_DRAIN_INTERVAL * CHERNOBOG_E_MP_DRAIN[self:GetAbility():GetLevel()] / 100, currentMana - minMana))
        end
    end
end
function modifier_chernobog_shadow_hunt_buff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS 
    }

    return funcs
end

function modifier_chernobog_shadow_hunt_buff:GetModifierMoveSpeed_Max_Increase(params)
    if not IsServer() then
        return
    end
    return CHERNOBOG_E_MS_CAP_INCR[self:GetAbility():GetLevel()]
end

function modifier_chernobog_shadow_hunt_buff:GetModifierMoveSpeedBonus_Constant(params)
    if not IsServer() then
        return
    end
    return CHERNOBOG_E_MS_INCR[self:GetAbility():GetLevel()]
end
function modifier_chernobog_shadow_hunt_buff:GetActivityTranslationModifiers()
    return "haste"
end
function modifier_chernobog_shadow_hunt_buff:GetTexture()
    return 'night_stalker_hunter_in_the_night'
end


modifier_chernobog_shadow_hunt = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_shadow_hunt", "heroes/nightstalker/chernobog_shadow_hunt", LUA_MODIFIER_MOTION_NONE)

function modifier_chernobog_shadow_hunt:OnCreated()
    if IsServer() then
        local hero = self:GetParent()
        local ability = self:GetAbility()
    end
    self:StartIntervalThink(0.2)
end
function modifier_chernobog_shadow_hunt:OnIntervalThink()
    if IsServer() then
        local hero = self:GetParent()
        local ability = self:GetAbility()
        local e_1_level = hero:GetRuneValue("e", 1)
        if e_1_level > 0 then
            hero:SetModifierStackCount("modifier_chernobog_e_1", hero, e_1_level)
        else
            hero:RemoveModifierByName("modifier_chernobog_e_1")
        end
        local e_2_level = hero:GetRuneValue("e", 2)
        if e_2_level > 0 and ability:GetToggleState() then
            hero:AddNewModifier(hero, ability, "modifier_chernobog_e_2", {})
        else
            hero:RemoveModifierByName("modifier_chernobog_e_2")
        end
        local e_3_level = hero:GetRuneValue("e", 3)
        if e_3_level > 0 and ability:GetToggleState() then
            hero:AddNewModifier(hero, ability, "modifier_chernobog_e_3", {})
        else
            hero:RemoveModifierByName("modifier_chernobog_e_3")
        end
        local e_4_level = hero:GetRuneValue("e", 4)
        if e_4_level > 0 and ability:GetToggleState() then
            hero:AddNewModifier(hero, ability, "modifier_chernobog_e_4", {})
        elseif e_4_level <= 0 and ability:GetToggleState() then
            hero:RemoveModifierByName("modifier_chernobog_e_4")
        end
    end
end
function modifier_chernobog_shadow_hunt:IsHidden()
    return true
end
function modifier_chernobog_shadow_hunt:IsBuff()
    return true
end
function modifier_chernobog_shadow_hunt:OnRemoved()
    if IsServer() then
    end
end

modifier_chernobog_e_1 = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_e_1", "heroes/nightstalker/chernobog_shadow_hunt", LUA_MODIFIER_MOTION_NONE)

function modifier_chernobog_e_1:IsHidden()
    return false
end
function modifier_chernobog_e_1:IsBuff()
    return true
end
function modifier_chernobog_e_1:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }
    return funcs
end
function modifier_chernobog_e_1:GetModifierBaseDamageOutgoing_Percentage()
    return self:GetStackCount() * CHERNOBOG_E1_ATT_PCT
end

function modifier_chernobog_e_1:GetModifierMoveSpeed_Max_Increase(params)
    if IsServer() then
        return CHERNOBOG_E1_MOVESPEED * self:GetParent():GetRuneValue("e", 1)
    end
end

function modifier_chernobog_e_1:GetModifierMoveSpeedBonus_Constant(params)
    if IsServer() then
        return CHERNOBOG_E1_MOVESPEED * self:GetParent():GetRuneValue("e", 1)
    end
end
function modifier_chernobog_e_1:GetTexture()
    return 'chernobog/chernobog_rune_e_1'
end

modifier_chernobog_e_2 = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_e_2", "heroes/nightstalker/chernobog_shadow_hunt", LUA_MODIFIER_MOTION_NONE)

function modifier_chernobog_e_2:OnCreated()
    if IsServer() then
        local hero = self:GetParent()
        local ability = self:GetAbility()
        local e_4_level = hero:GetRuneValue("e", 4)
        self:StartIntervalThink(CHERNOBOG_E2_INTERVAL / (1 + e_4_level * CHERNOBOG_E4_SHADOWS_INTERVAL_SCALE))
    end
end
function modifier_chernobog_e_2:OnIntervalThink()
    if IsServer() then
        local hero = self:GetParent()
        local ability = self:GetAbility()
        local e_2_level = hero:GetRuneValue("e", 2)
        local e_4_level = hero:GetRuneValue("e", 4)
        local damage = CHERNOBOG_E2_DMG_PCT * OverflowProtectedGetAverageTrueAttackDamage(hero) * e_2_level
        local interval = CHERNOBOG_E2_INTERVAL / (1 + e_4_level * CHERNOBOG_E4_SHADOWS_INTERVAL_SCALE)
        local radius = CHERNOBOG_E2_RADIUS
        if hero:HasModifier('modifier_chernobog_glyph_2_1') then
            radius = radius * CHERNOBOG_T21_RADIUS_AMP
        end
        self:StartIntervalThink(interval)
        local enemies = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
        for _, enemy in ipairs(enemies) do
            local damageDelay =  0.9 * interval
            local animationRate = 1 + 0.3 * (0.5/interval - 1)
            local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/chernobog/nights_procession_illusion.vpcf", enemy, interval)
            ParticleManager:SetParticleControl(pfx, 1, Vector(animationRate, 0, 0))
            Timers:CreateTimer(damageDelay, function()
                EmitSoundOn("Chernobog.BC.Hit", enemy)
                Damage:Apply({
                    attacker = hero,
                    victim = enemy,
                    source = self:GetAbility(),
                    sourceType = BASE_ABILITY_E,
                    damage = damage,
                    damageType = DAMAGE_TYPE_MAGICAL,
                    elements = {
                        RPC_ELEMENT_DEMON,
                        RPC_ELEMENT_SHADOW,
                    },
                })
                ParticleManager:DestroyParticle(pfx, false)
                ParticleManager:ReleaseParticleIndex(pfx)
            end)
        end
    end
end
function modifier_chernobog_e_2:IsHidden()
    return false
end
function modifier_chernobog_e_2:IsBuff()
    return true
end
function modifier_chernobog_e_2:GetTexture()
    return 'chernobog/chernobog_rune_e_2'
end

modifier_chernobog_e_3 = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_e_3", "heroes/nightstalker/chernobog_shadow_hunt", LUA_MODIFIER_MOTION_NONE)

function modifier_chernobog_e_3:IsHidden()
    return true
end

function modifier_chernobog_e_3:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_SPECIAL_TYPE_ORDER_FILTER
    })
end
function modifier_chernobog_e_3:OnOrderFilter(data)
    local allowedOrderTypes = {
        [DOTA_UNIT_ORDER_ATTACK_TARGET] = true,
    }
    if not allowedOrderTypes[data.order_type] then
        return
    end
    if not data.entindex_target then
        return
    end
    local enemy = EntIndexToHScript(data.entindex_target)
    if not IsValidEntity(enemy) then
        return
    end
    local hero = self:GetParent()
    if data.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET and IsValidEntity(enemy) then
        if enemy.dummy or enemy:GetClassname() == "dota_item_drop" or enemy:GetTeamNumber() == hero:GetTeamNumber() then
            return
        end
        if not hero:IsRooted() and not hero:IsStunned() then
            local ability = self:GetAbility()
            local e_3_level = hero:GetRuneValue("e", 3)
            if e_3_level > 0 then
                if data.entindex_target == 0 then
                else
                    local distance = WallPhysics:GetDistance2d(enemy:GetAbsOrigin(), hero:GetAbsOrigin())
                    if distance <= CHERNOBOG_E3_RANGE_BASE + CHERNOBOG_E3_RANGE * e_3_level then
                        local afterWallPosition = WallPhysics:WallSearch(hero:GetAbsOrigin(), enemy:GetAbsOrigin(), hero)
                        if afterWallPosition ~= enemy:GetAbsOrigin() then
                            return
                        end

                        local particleName = "particles/roshpit/chernobog/chernobog_rune_c_c.vpcf"
                        local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, hero)
                        ParticleManager:SetParticleControl(particle1, 0, hero:GetAbsOrigin())
                    
                        FindClearSpaceForUnit(hero, afterWallPosition, false)
                    
                        EmitSoundOn("Chernobog.TeleportMove", hero)
                        local particle2 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, hero)
                        ParticleManager:SetParticleControl(particle2, 0, hero:GetAbsOrigin() + Vector(0, 0, 100))
                        Timers:CreateTimer(3, function()
                            ParticleManager:DestroyParticle(particle1, false)
                            ParticleManager:ReleaseParticleIndex(particle1)
                    
                            ParticleManager:DestroyParticle(particle2, false)
                            ParticleManager:ReleaseParticleIndex(particle2)
                        end)
                        Timers:CreateTimer(0.15, function()
                            local baseDuration = CHERNOBOG_E3_BUFF_DURATION_BASE
                            if hero:HasModifier("modifier_chernobog_glyph_6_1") then
                                baseDuration = baseDuration + CHERNOBOG_GLYPH_6_1_DURATION_INCREASE
                            end
                            local buffDuration = Filters:GetAdjustedBuffDuration(hero, baseDuration, false)
                            hero:AddNewModifier(hero, ability, "modifier_chernobog_e_3_buff", { duration = buffDuration })
                            StartAnimation(hero, {duration = 0.3, activity = ACT_DOTA_ATTACK, rate = 3})
                            Filters:PerformAttackSpecial(hero, enemy, true, true, true, true, false, false, false)
                        end)
                    end
                end
            end
        end
    end
end

modifier_chernobog_e_3_buff = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_e_3_buff", "heroes/nightstalker/chernobog_shadow_hunt", LUA_MODIFIER_MOTION_NONE)

function modifier_chernobog_e_3_buff:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_ARMOR_PIERCE_BONUS,
        MODIFIER_ROSHPIT_SPELL_PIERCE_BONUS
    })
end

function modifier_chernobog_e_3_buff:IsHidden()
    return false
end
function modifier_chernobog_e_3_buff:GetRoshpitArmorPierceBonus()
    return self:GetParent():GetRuneValue("e", 3) * CHERNOBOG_E3_ARMOR_PIERCE_AND_SPELL_PIERCE
end
function modifier_chernobog_e_3_buff:GetRoshpitSpellPierceBonus()
    return self:GetParent():GetRuneValue("e", 3) * CHERNOBOG_E3_ARMOR_PIERCE_AND_SPELL_PIERCE
end
function modifier_chernobog_e_3_buff:GetTexture()
    return "chernobog/chernobog_rune_e_3"
end


modifier_chernobog_e_4 = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_e_4", "heroes/nightstalker/chernobog_shadow_hunt", LUA_MODIFIER_MOTION_NONE)

function modifier_chernobog_e_4:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EVASION_CONSTANT,
	}

	return funcs
end
function modifier_chernobog_e_4:IsBuff()
    return true
end
function modifier_chernobog_e_4:GetModifierEvasion_Constant()
    return CHERNOBOG_E4_EVASION
end
function modifier_chernobog_e_4:GetTexture()
    return "chernobog/chernobog_rune_e_4"
end