require('heroes/antimage/arkimus_orbital_leap')
arkimus_energy_field = class(base_ability)

function arkimus_energy_field:GetBaseManaCost(level)
    return 0
end

function arkimus_energy_field:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_AOE
end

function arkimus_energy_field:GetAbilitySlot()
    return DOTA_R_SLOT
end

function arkimus_energy_field:GetCastPoint()
    return 0
end

function arkimus_energy_field:GetBaseCooldown(level)
    if level == -1 then
        level = self:GetLevel() - 1
    end
    return ARKIMUS_R_COOLDOWN[level + 1]
end

function arkimus_energy_field:GetCastRange()
    return 0
end

function arkimus_energy_field:GetTexture()
    return "arkimus/arkimus_energy_field"
end

function arkimus_energy_field:GetBaseChannelTime()
    return ARKIMUS_R_CHANNEL_TIME
end

function arkimus_energy_field:GetCastAnimation()
    return ACT_DOTA_TELEPORT
end

function arkimus_energy_field:OnSpellStart()
    local hero = self:GetCaster()
    local ability = self
    hero:AddNewModifier(hero, ability, "modifier_arkimus_channeling", {})
	EmitSoundOn("Akrimus.Channel.VO", hero)
	StartSoundEvent("Arkimus.EnergyField.Channel", hero)

	local r_3_level = hero:GetRuneValue("r", 3)
	if r_3_level > 0 then
        local duration = Filters:GetAdjustedBuffDuration(hero, ARKIMUS_R3_DURATION * r_3_level, false)
        hero:AddNewModifier(hero, ability, "modifier_arkimus_r_3_shield", {duration = duration})
	end
end

function arkimus_energy_field:OnChannelFinish(interrupted)
    if IsServer() then
        local hero = self:GetCaster()
        hero:RemoveModifierByName("modifier_arkimus_channeling")
        if interrupted then
            StopSoundEvent("Arkimus.EnergyField.Channel", hero)
        else
            local ability = self
            local baseFV = hero:GetForwardVector()
            ability.velocity = 1000
            ability.rotationDelta = 30
            if hero:HasModifier("modifier_arkimus_glyph_1_1") then
                ability.rotationDelta = 14
            end
            StartAnimation(hero, {duration = 1, activity = ACT_DOTA_CAST_ABILITY_4, rate = 1})
            EmitSoundOn("Arkimus.EnergyField.VO", hero)
        
            ability.r_1_level = hero:GetRuneValue("r", 1)
            ability.r_2_level = hero:GetRuneValue("r", 2)
            local count = ability:GetSpecialValueFor("spirits")
            if hero:HasModifier("modifier_arkimus_glyph_3_1") then
                count = count + ARKIMUS_GLYPH_3_1_R_EXTRA_CELLS
            end
            if hero:HasAbility("arkimus_orbital_leap") then
                local jumpAbility = hero:FindAbilityByName("arkimus_orbital_leap")
                jumpAbility.CastByUltimate = true
                jumpAbility.CustomTarget = hero:GetAbsOrigin()
                jumpAbility:OnSpellStart()
            end
            if not ability.energyTable then
                ability.energyTable = {}
            end
            for j = 1, count, 1 do
                local dummy = CreateUnitByName("npc_dummy_unit", hero:GetAbsOrigin(), false, nil, nil, hero:GetTeamNumber())
                dummy:AddNewModifier(hero, ability, "modifier_arkimus_energy_field_thinker", {duration = 20})
                local projectileFV = WallPhysics:rotateVector(baseFV, 2 * math.pi * j / count)
                local pfx = ParticleManager:CreateParticle("particles/base_attacks/astral_glyph_2_1_projectile.vpcf", PATTACH_CUSTOMORIGIN, hero)
                ParticleManager:SetParticleControl(pfx, 0, hero:GetAbsOrigin() + Vector(0, 0, 80))
                ParticleManager:SetParticleControl(pfx, 1, hero:GetAbsOrigin() + projectileFV * 1300 + Vector(0, 0, 80))
                ParticleManager:SetParticleControl(pfx, 2, Vector(ability.velocity, ability.velocity, ability.velocity))
                dummy.pfx = pfx
                dummy.interval = 0
                dummy.dummy = true
                dummy.pullPoint = hero:GetAbsOrigin() + projectileFV * 1300 + Vector(0, 0, 80)
                dummy.baseFV = projectileFV
                dummy.hardInterval = 0
                table.insert(ability.energyTable, dummy)
            end
            Filters:CastSkillArguments(BASE_ABILITY_R, hero)
            calculate_r_1(hero, ability)
        end
    end
end

require('modifiers/modifier_channel_start')
modifier_arkimus_channeling = class(modifier_channel_start, nil, modifier_channel_start)
LinkLuaModifier("modifier_arkimus_channeling", "heroes/antimage/arkimus_energy_field", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_channeling:GetEffectName()
    return "particles/roshpit/arkimus/channel_energy.vpcf"
end
function modifier_arkimus_channeling:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

modifier_arkimus_energy_field_thinker = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_arkimus_energy_field_thinker", "heroes/antimage/arkimus_energy_field", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_energy_field_thinker:IsHidden()
    return true
end
function modifier_arkimus_energy_field_thinker:CheckState()
    local state = {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true
    }

    return state
end
function modifier_arkimus_energy_field_thinker:OnCreated()
    if IsServer() then
        self:StartIntervalThink(0.03)
    end
end
function modifier_arkimus_energy_field_thinker:OnIntervalThink()
    local caster = self:GetCaster()
	local ability = self:GetAbility()
	local target = self:GetParent()
	local dummy = target
	dummy.interval = dummy.interval + 1
	dummy.hardInterval = dummy.hardInterval + 1
	local movement = ((dummy.pullPoint - dummy:GetAbsOrigin()):Normalized() * 0.03) * ability.velocity
	movement = movement * Vector(1, 1, 0)
    dummy:SetAbsOrigin(dummy:GetAbsOrigin() + movement)
    local r_2_level = caster:GetRuneValue("r", 2)
    local damage = ARKIMUS_R_DAMAGE[self:GetAbility():GetLevel()]
	damage = damage + r_2_level * OverflowProtectedGetAverageTrueAttackDamage(caster) * ARKIMUS_R2_ATTACK_POWER_TO_R_PCT / 100
	if dummy.interval == 3 then
		dummy.interval = 0
		local newFV = WallPhysics:rotateVector(dummy.baseFV, 2 * math.pi / ability.rotationDelta)
		dummy.baseFV = newFV
		local newPos = caster:GetAbsOrigin() + newFV * 1800 + Vector(0, 0, 80)
		dummy.pullPoint = newPos
		ParticleManager:SetParticleControl(dummy.pfx, 1, newPos)
		-- ParticleManager:SetParticleControl(dummy.pfx, 2, Vector(ability.velocity, ability.velocity, ability.velocity))

	end
    if dummy.hardInterval == 5 then
        dummy.hardInterval = 0
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), dummy:GetAbsOrigin(), nil, 120, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Arkimus.EnergyField.Hit", caster)
			for _, enemy in pairs(enemies) do
				if not ability.particleCount then
					ability.particleCount = 0
				end
				if ability.particleCount < 15 then
					ability.particleCount = ability.particleCount + 1
					CustomAbilities:QuickAttachParticle("particles/econ/items/wisp/wisp_guardian_explosion_ti7.vpcf", enemy, 1)
					Timers:CreateTimer(1, function()
						ability.particleCount = ability.particleCount - 1
					end)
				end
                Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, ARKIMUS_R_DAMAGE_TYPE, BASE_ABILITY_R, RPC_ELEMENT_ARCANE, RPC_ELEMENT_NONE)
                enemy:AddNewModifier(caster, ability, "modifier_arkimus_energy_field_debuff", {duration = 5})
                local stackCount = ability:GetSpecialValueFor("damage_reduce")
                enemy:SetModifierStackCount("modifier_arkimus_energy_field_debuff", caster, stackCount)
			end
		end
    end
end
function modifier_arkimus_energy_field_thinker:OnDestroy()
    if IsServer() then
        local caster = self:GetCaster()
        local ability = self:GetAbility()
        local target = self:GetParent()
        local pfx = target.pfx
        Timers:CreateTimer(0.03, function()
            UTIL_Remove(target)
            reindexEnergyTable(ability)
            if #ability.energyTable == 0 then
                StopSoundEvent("Arkimus.EnergyField.Channel", caster)
            end
            EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Arkimus.EnergyField.End", caster)
            calculate_r_1(caster, ability)
        end)
        Timers:CreateTimer(1.5, function()
            ParticleManager:DestroyParticle(pfx, false)
            ParticleManager:ReleaseParticleIndex(pfx)
        end)
    end
end

modifier_arkimus_energy_field_debuff = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_arkimus_energy_field_debuff", "heroes/antimage/arkimus_energy_field", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_energy_field_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
    }
    return funcs
end
function modifier_arkimus_energy_field_debuff:GetModifierBaseDamageOutgoing_Percentage()
    return - self:GetStackCount()
end
function modifier_arkimus_energy_field_debuff:IsDebuff()
    return true
end
function modifier_arkimus_energy_field_debuff:GetEffectName()
    return "particles/roshpit/items/violet_guard_2.vpcf"
end
function modifier_arkimus_energy_field_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function calculate_r_1(caster, ability)
    local r_1_level = caster:GetRuneValue("r", 1)
    if r_1_level > 0 and #ability.energyTable > 0 then
        caster:AddNewModifier(caster, ability, "modifier_arkimus_r_1_buff_visible", {})
        caster:SetModifierStackCount("modifier_arkimus_r_1_buff_visible", caster, #ability.energyTable)
        caster:AddNewModifier(caster, ability, "modifier_arkimus_r_1_buff_invisible", {})
        caster:SetModifierStackCount("modifier_arkimus_r_1_buff_invisible", caster, #ability.energyTable * r_1_level)
    else
        caster:RemoveModifierByName("modifier_arkimus_r_1_buff_visible")
        caster:RemoveModifierByName("modifier_arkimus_r_1_buff_invisible")
    end
end
function reindexEnergyTable(ability)
	local newTable = {}
	for i = 1, #ability.energyTable, 1 do
		if IsValidEntity(ability.energyTable[i]) then
			table.insert(newTable, ability.energyTable[i])
		end
	end
	ability.energyTable = newTable
end

modifier_arkimus_r_1_buff_visible = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_arkimus_r_1_buff_visible", "heroes/antimage/arkimus_energy_field", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_r_1_buff_visible:IsBuff()
    return true
end
function modifier_arkimus_r_1_buff_visible:GetTexture()
    return "arkimus/arkimus_rune_r_1"
end

modifier_arkimus_r_1_buff_invisible = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_arkimus_r_1_buff_invisible", "heroes/antimage/arkimus_energy_field", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_r_1_buff_invisible:IsHidden()
    return true
end
function modifier_arkimus_r_1_buff_invisible:IsBuff()
    return true
end

function modifier_arkimus_r_1_buff_invisible:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
    }
    return funcs
end

function modifier_arkimus_r_1_buff_invisible:GetModifierBaseDamageOutgoing_Percentage()
    return self:GetStackCount() * ARKIMUS_R1_BONUS_DMG
end

function modifier_arkimus_r_1_buff_invisible:GetModifierConstantManaRegen()
    return self:GetStackCount() * ARKIMUS_R1_MANA_REGEN
end

modifier_arkimus_r_3_shield = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_arkimus_r_3_shield", "heroes/antimage/arkimus_energy_field", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_r_3_shield:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_PHYSICAL_DMG_REDUCTION,
        MODIFIER_ROSHPIT_MAGICAL_DMG_REDUCTION,
        MODIFIER_ROSHPIT_PURE_DMG_REDUCTION
    })
end
function modifier_arkimus_r_3_shield:IsBuff()
    return true
end
function modifier_arkimus_r_3_shield:GetTexture()
    return "arkimus/arkimus_rune_r_3"
end
function modifier_arkimus_r_3_shield:GetEffectName()
    return "particles/roshpit/arkimus/c_d_shield_reflect_energy.vpcf"
end
function modifier_arkimus_r_3_shield:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_arkimus_r_3_shield:GetDamageReduction()
    if IsServer() then
        return ARKIMUS_R3_DMG_RED
    end
end
function modifier_arkimus_r_3_shield:GetPhysicalDamageReduction()
    if IsServer() then
        return modifier_arkimus_r_3_shield:GetDamageReduction()
    end
end
function modifier_arkimus_r_3_shield:GetMagicalDamageReduction()
    if IsServer() then
        return modifier_arkimus_r_3_shield:GetDamageReduction()
    end
end
function modifier_arkimus_r_3_shield:GetPureDamageReduction()
    if IsServer() then
        return modifier_arkimus_r_3_shield:GetDamageReduction()
    end
end
