require('heroes/antimage/arkimus_constants')
require('heroes/base_ability')
require('heroes/antimage/arkimus_common')
arkimus_dimension_coil = class(base_ability)

function arkimus_dimension_coil:GetBaseManaCost(level)
    return 0
end

function arkimus_dimension_coil:GetCastRange()
    return ARKIMUS_Q_CAST_RANGE[self:GetLevel()]
end

function arkimus_dimension_coil:GetAbilitySlot()
    return DOTA_Q_SLOT
end

function arkimus_dimension_coil:GetBaseCooldown(level)
    if level == -1 then
        level = self:GetLevel() - 1
    end
    return ARKIMUS_Q_COOLDOWN[level + 1]
end


function arkimus_dimension_coil:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end

function arkimus_dimension_coil:GetCastPoint()
    return 0.4
end

function arkimus_dimension_coil:GetIntrinsicModifierName()
    return "modifier_arkimus_dimension_coil"
end

function arkimus_dimension_coil:OnAbilityPhaseStart()
    if IsServer() then
        local caster = self:GetCaster()
        local ability = self
        EmitSoundOn("Arkimus.ZonisStart", caster)
        local target = self:GetCursorPosition()
        local moveDirection = ((target - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
        local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), target)
        for i = 1, 7, 1 do
            Timers:CreateTimer(i * 0.06, function()
                local pfx = ParticleManager:CreateParticle("particles/roshpit/arkimus/jump_fade.vpcf", PATTACH_CUSTOMORIGIN, caster)
                ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin() + moveDirection * (distance / 7) * i)
                Timers:CreateTimer(0.4, function()
                    ParticleManager:DestroyParticle(pfx, false)
                end)
            end)
        end
        return true
    end
end

function arkimus_dimension_coil:OnSpellStart()
    if IsServer() then
        local caster = self:GetCaster()
        local ability = self
        local target = self:GetCursorPosition()
        local origPosition = caster:GetAbsOrigin()
        CustomAbilities:QuickAttachParticle("particles/arkimus/zonis_start.vpcf", caster, 3)
        target = WallPhysics:WallSearch(caster:GetAbsOrigin(), target, caster)
        FindClearSpaceForUnit(caster, target, false)
        ProjectileManager:ProjectileDodge(caster)
        local casterOrigin = caster:GetAbsOrigin()

        local damage = ARKIMUS_Q_DAMAGE[self:GetLevel()]
        local q_2_level = caster:GetRuneValue("q", 2)
        local q_4_level = caster:GetRuneValue("q", 4)
        local duration = ARKIMUS_Q_COIL_BASE_DURATION + ARKIMUS_Q_COIL_BASE_DURATION * q_4_level * ARKIMUS_Q4_COIL_ADD_DURATION_PCT
        local zonal_net_duration = 1 + 1 * ARKIMUS_Q4_COIL_ADD_DURATION_PCT * q_4_level
        local loops = math.floor(duration * 10)
        Timers:CreateTimer(0.1, function()
            CustomAbilities:QuickAttachParticle("particles/roshpit/arkimus/zonis_end.vpcf", caster, 3)
            if q_2_level > 0 then
                caster:AddNewModifier(caster, ability, "modifier_arkimus_q_2_buff", {duration = zonal_net_duration})
            end
            for i = 1, loops, 1 do
                Timers:CreateTimer(i * 0.1, function()
                    CreateZonisBeam(origPosition + Vector(0, 0, 60), target + Vector(0, 0, 60))
                    local enemies = FindUnitsInLine(caster:GetTeamNumber(), origPosition, target, nil, 80, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0)
                    if #enemies > 0 then
                        local index = 1
                        if i % 2 == 0 then
                            EmitSoundOnLocationWithCaster(enemies[1]:GetAbsOrigin(), "Arkimus.ZonisLightning", caster)
                        end
                        for _, enemy in pairs(enemies) do
                            zonis_damage(enemy, caster, damage, ability)
                        end
                    end
                end)
            end
        end)
        EmitSoundOn("Arkimus.ZonisEnd", caster)
        if caster:HasModifier("modifier_arkimus_q_free_cast") then
            ability:EndCooldown()
            local newStacks = caster:GetModifierStackCount("modifier_arkimus_q_free_cast", caster) - 1
            if newStacks > 0 then
                caster:SetModifierStackCount("modifier_arkimus_q_free_cast", caster, newStacks)
            else
                caster:RemoveModifierByName("modifier_arkimus_q_free_cast")
            end
        end
        if caster:HasAbility("arkimus_energy_field") then
            local energyField = caster:FindAbilityByName("arkimus_energy_field")
            if energyField.rotationDelta then
                energyField.rotationDelta = math.min(50, energyField.rotationDelta + 6)
            end
        end
        Filters:CastSkillArguments(BASE_ABILITY_Q, caster)
    end
end

function zonis_damage(enemy, caster, damage, ability)
    enemy:AddNewModifier(caster, ability, "modifier_arkimus_stun", {duration = 0.2})
    Filters:ApplyStun(caster, ARKIMUS_Q_STUN, enemy)
    Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, ARKIMUS_Q_DAMAGE_TYPE, BASE_ABILITY_Q, ARKIMUS_Q_ELEMENT1, ARKIMUS_Q_ELEMENT2)
    local q_1_level = caster:GetRuneValue("q", 1)
	if q_1_level > 0 then
		if enemy.dummy then
        else
            enemy:AddNewModifier(caster, ability, "modifier_arkimus_q_1_armor_loss", {duration = ARKIMUS_Q1_DURATION})
			enemy:SetModifierStackCount("modifier_arkimus_q_1_armor_loss", caster, q_1_level)
		end
	end
    local q_3_level = caster:GetRuneValue("q", 3)
	if q_3_level > 0 then
        enemy:AddNewModifier(caster, ability, "modifier_arkimus_q_3_magic_armor_loss", {duration = ARKIMUS_Q3_DURATION})
        enemy:SetModifierStackCount("modifier_arkimus_q_3_magic_armor_loss", caster, q_3_level)
	end
end

-------------
--MODIFIERS--
-------------
modifier_arkimus_dimension_coil = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_arkimus_dimension_coil", "heroes/antimage/arkimus_dimension_coil", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_dimension_coil:OnCreated()
    if IsServer() then
        local hero = self:GetParent()
        local ability = self:GetAbility()
        hero:AddNewModifier(hero, ability, "modifier_arkimus_q_free_cast_thinker", {})
        hero:AddNewModifier(hero, ability, "modifier_arkimus_q_4_buff", {})
    end
end
function modifier_arkimus_dimension_coil:IsHidden()
    return true
end
function modifier_arkimus_dimension_coil:IsBuff()
    return true
end
function modifier_arkimus_dimension_coil:OnRemoved()
    if IsServer() then
        local hero = self:GetParent()
        local ability = self:GetAbility()
        hero:RemoveModifierByName("modifier_arkimus_q_free_cast_thinker")
        hero:RemoveModifierByName("modifier_arkimus_q_4_buff")
    end
end

modifier_arkimus_q_free_cast = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_arkimus_q_free_cast", "heroes/antimage/arkimus_dimension_coil", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_q_free_cast:IsHidden()
    return false
end
function modifier_arkimus_q_free_cast:IsBuff()
    return true
end

modifier_arkimus_q_free_cast_thinker = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_arkimus_q_free_cast_thinker", "heroes/antimage/arkimus_dimension_coil", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_q_free_cast_thinker:IsHidden()
    return true
end
function modifier_arkimus_q_free_cast_thinker:OnCreated()
    if IsServer() then
        self:StartIntervalThink(ARKIMUS_Q_FREE_CAST_REFRESH)
    end
end

function modifier_arkimus_q_free_cast_thinker:OnIntervalThink()
    if IsServer() then
        local caster = self:GetCaster()
        local ability = self:GetAbility()
        local stackCount = caster:GetModifierStackCount("modifier_arkimus_q_free_cast", caster)
        local maxStacks = ARKIMUS_Q_FREE_CASTS
        if caster:HasModifier("modifier_arkimus_glyph_6_1") then
            maxStacks = maxStacks + ARKIMUS_GLYPH_6_1_Q_FREE_CAST
        end
        if stackCount <= maxStacks then
            caster:AddNewModifier(caster, ability, "modifier_arkimus_q_free_cast", {})
            local newStacks = math.min(stackCount + 1, maxStacks)
            caster:SetModifierStackCount("modifier_arkimus_q_free_cast", caster, newStacks)
        end
    end
end
function modifier_arkimus_q_free_cast_thinker:OnRemoved()
    if IsServer() then
        local hero = self:GetCaster()
        hero:RemoveModifierByName("modifier_arkimus_q_free_cast")
    end
end

modifier_arkimus_q_1_armor_loss = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_arkimus_q_1_armor_loss", "heroes/antimage/arkimus_dimension_coil", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_q_1_armor_loss:GetRoshpitArmorBonus()
    return self:GetStackCount() * ARKIMUS_Q1_ARMOR_REDUCTION
end
function modifier_arkimus_q_1_armor_loss:IsHidden()
    return false
end
function modifier_arkimus_q_1_armor_loss:IsDebuff()
    return true
end
function modifier_arkimus_q_1_armor_loss:IsStunDebuff()
    return true
end
function modifier_arkimus_q_1_armor_loss:GetTexture()
    return "arkimus/arkimus_rune_q_1"
end
function modifier_arkimus_q_1_armor_loss:OnCreated()
    if IsServer() then
        self:SetSpecialTypes({ 
            MODIFIER_ROSHPIT_ARMOR_BONUS
        })
        local target = self:GetParent()
        local location = target:GetAbsOrigin()
        if target.dummy then
            return false
        end
        local particleName = "particles/roshpit/heroes/arkimus/a_a_amp_damage.vpcf"
        if target.AmpDamageParticle then
            ParticleManager:DestroyParticle(target.AmpDamageParticle, false)
        end
        -- Particle. Need to wait one frame for the older particle to be destroyed
        Timers:CreateTimer(0.01, function()
            target.AmpDamageParticle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, target)
            ParticleManager:SetParticleControl(target.AmpDamageParticle, 0, target:GetAbsOrigin())
            ParticleManager:SetParticleControl(target.AmpDamageParticle, 1, target:GetAbsOrigin())
            ParticleManager:SetParticleControl(target.AmpDamageParticle, 2, target:GetAbsOrigin())

            ParticleManager:SetParticleControlEnt(target.AmpDamageParticle, 1, target, PATTACH_OVERHEAD_FOLLOW, "attach_overhead", target:GetAbsOrigin(), true)
            ParticleManager:SetParticleControlEnt(target.AmpDamageParticle, 2, target, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
        end)
        target:CalculateAndSaveRoshpitAttributes()
    end
end

function modifier_arkimus_q_1_armor_loss:OnDestroy()
    if IsServer() then
        local target = self:GetParent()
        if target.AmpDamageParticle then
            ParticleManager:DestroyParticle(target.AmpDamageParticle, false)
            target.AmpDamageParticle = nil
        end
        target:CalculateAndSaveRoshpitAttributes()
    end
end

modifier_arkimus_q_2_buff = class ({})
LinkLuaModifier("modifier_arkimus_q_2_buff", "heroes/antimage/arkimus_dimension_coil", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_q_2_buff:IsHidden()
    return true
end

function modifier_arkimus_q_2_buff:OnCreated()
    if IsServer() then
        self:StartIntervalThink(ARKIMUS_Q2_THINK_INTERVAL)
    end
end

function modifier_arkimus_q_2_buff:OnIntervalThink()
    if IsServer() then
        local caster = self:GetCaster()
        local ability = self:GetAbility()
        local q_2_level = caster:GetRuneValue("q", 2)
        local radius = ARKIMUS_Q2_RADIUS_BASE + q_2_level * ARKIMUS_Q2_RADIUS
        local damage = q_2_level * ARKIMUS_Q2_DAMAGE
        local edges = 2 + math.ceil((q_2_level + 1) * 0.05)
        casterOrigin = caster:GetAbsOrigin()
        local endPointTable = {}
        local midPointTable = {}
        local baseFV = caster:GetForwardVector()
        for i = 1, edges, 1 do
            local rotatedVector = WallPhysics:rotateVector(baseFV, 2 * math.pi * i / edges)
            local endPoint = casterOrigin + rotatedVector * radius + Vector(0, 0, 60)
            CreateZonisBeam(casterOrigin + Vector(0, 0, 60), endPoint)
            table.insert(endPointTable, endPoint)
            table.insert(midPointTable, casterOrigin + rotatedVector * (radius / 2) + Vector(0, 0, 60))
        end
        for j = 1, #endPointTable, 1 do
            if j < #endPointTable then
                CreateZonisBeam(endPointTable[j], endPointTable[j + 1])
                CreateZonisBeam(midPointTable[j], midPointTable[j + 1])
            else
                CreateZonisBeam(endPointTable[j], endPointTable[1])
                CreateZonisBeam(midPointTable[j], midPointTable[1])
            end
        end
        local enemies = FindUnitsInRadius(caster:GetTeamNumber(), casterOrigin, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
        if #enemies > 0 then
            for _, enemy in pairs(enemies) do
                zonis_damage(enemy, caster, damage, ability)
            end
        end
        EmitSoundOnLocationWithCaster(casterOrigin, "Arkimus.ZonisLightning", caster)
    end
end

modifier_arkimus_q_3_magic_armor_loss = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_arkimus_q_3_magic_armor_loss", "heroes/antimage/arkimus_dimension_coil", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_q_3_magic_armor_loss:GetRoshpitMagicArmorBonus()
    return self:GetStackCount() * ARKIMUS_Q3_MAGIC_ARMOR_REDUCTION
end
function modifier_arkimus_q_3_magic_armor_loss:IsPassive()
    return false
end
function modifier_arkimus_q_3_magic_armor_loss:IsHidden()
    return false
end
function modifier_arkimus_q_3_magic_armor_loss:IsDebuff()
    return true
end
function modifier_arkimus_q_3_magic_armor_loss:IsStunDebuff()
    return true
end
function modifier_arkimus_q_3_magic_armor_loss:GetTexture()
    return "arkimus/arkimus_rune_q_3"
end
function modifier_arkimus_q_3_magic_armor_loss:GetEffectName()
    return "particles/items2_fx/veil_of_discord_debuff.vpcf"
end
function modifier_arkimus_q_3_magic_armor_loss:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN
end
function modifier_arkimus_q_3_magic_armor_loss:OnCreated(event)
    if not IsServer() then
        return
    end
    self:GetParent():CalculateAndSaveRoshpitAttributes()

    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_MAGIC_ARMOR_BONUS
    })
end
function modifier_arkimus_q_3_magic_armor_loss:OnDestroy(event)
    if IsServer() then
        self:GetParent():CalculateAndSaveRoshpitAttributes()
    end
end

modifier_arkimus_q_4_buff = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_arkimus_q_4_buff", "heroes/antimage/arkimus_dimension_coil", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_q_4_buff:IsHidden()
    return true
end

function modifier_arkimus_q_4_buff:IsBuff()
    return true
end

function modifier_arkimus_q_4_buff:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_Q_BASE_ABILITY_DMG_BONUS
    })
end
function modifier_arkimus_q_4_buff:GetRoshpitQBaseAbilityDmgBonus()
    local hero = self:GetParent()
    return hero:GetRuneValue("q", 4) * ARKIMUS_Q4_ADD_DMG_PCT
end