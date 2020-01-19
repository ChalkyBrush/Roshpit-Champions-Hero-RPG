require('heroes/antimage/arkimus_constants')
require('heroes/base_ability')

arkimus_archon_form = class(base_ability)


function arkimus_archon_form:GetBaseManaCost(level)
    return 0
end

function arkimus_archon_form:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_AOE
end

function arkimus_archon_form:GetAbilitySlot()
    return DOTA_R_SLOT
end

function arkimus_archon_form:GetCastPoint()
    return 0
end

function arkimus_archon_form:GetBaseCooldown(level)
    if level == -1 then
        level = self:GetLevel() - 1
    end
    return ARKIMUS_R_COOLDOWN[level + 1]
end

function arkimus_archon_form:GetCastRange()
    return 0
end

function arkimus_archon_form:GetTexture()
    return "arkimus/arkimus_archon_form"
end

function arkimus_archon_form:GetChannelTime()
    return ARKIMUS_ARCANA2_R_CHANNEL_TIME
end

function arkimus_archon_form:GetCastAnimation()
    return ACT_DOTA_TELEPORT
end

function arkimus_archon_form:OnSpellStart()
    local hero = self:GetCaster()
    hero:AddNewModifier(hero, self, "modifier_channel_start", {duration = 1})
	local ability = self
	EmitSoundOn("Akrimus.Channel.VO", hero)
	StartSoundEvent("Arkimus.EnergyField.Channel", hero)
end

function arkimus_archon_form:OnChannelFinish(interrupted)
    if IsServer() then
        local hero = self:GetCaster()
        if interrupted then
            StopSoundEvent("Arkimus.EnergyField.Channel", hero)
        else
            local ability = self
            local baseFV = hero:GetForwardVector()
            local duration = Filters:GetAdjustedBuffDuration(hero, ability:GetSpecialValueFor("duration"), false)
            StartAnimation(hero, {duration = 1, activity = ACT_DOTA_CAST_ABILITY_4, rate = 1})
            EmitSoundOn("Arkimus.EnergyField.VO", hero)
            StopSoundEvent("Arkimus.EnergyField.Channel", hero)
        
            if hero:HasAbility("arkimus_orbital_leap") then
                local jumpAbility = hero:FindAbilityByName("arkimus_orbital_leap")
                jumpAbility.CastByUltimate = true
                jumpAbility.CustomTarget = hero:GetAbsOrigin()
                jumpAbility:OnSpellStart()
            end
            hero:AddNewModifier(hero, ability, "modifier_arkimus_archon_form", {duration = duration})
            local r_2_level = hero:GetRuneValue("r", 2)
            if r_2_level > 0 then
                local stats = hero:GetStrength() + hero:GetAgility() + hero:GetIntellect() + hero:GetSpirit()
                local manaRegen = stats * ARKIMUS_ARCANA2_R2_MANA_REGEN_PER_ATTRIBUTE_PCT * r_2_level
                hero:AddNewModifier(hero, ability, "modifier_arkimus_arcana_r_2_dmg_buff", {duration = duration})
                hero:SetModifierStackCount("modifier_arkimus_arcana_r_2_dmg_buff", hero, r_2_level)
                hero:AddNewModifier(hero, ability, "modifier_arkimus_arcana_r_2_mana_regen_buff", {duration = duration})
                hero:SetModifierStackCount("modifier_arkimus_arcana_r_2_mana_regen_buff", hero, manaRegen)
                
            end
            local r_4_level = hero:GetRuneValue("r", 4)
            if r_4_level > 0 then
                hero:AddNewModifier(hero, ability, "modifier_arkimus_arcana_r_4_buff", {duration = duration})
                hero:SetModifierStackCount("modifier_arkimus_arcana_r_4_buff", hero, r_4_level)
            end
            EmitSoundOn("Arkimus.ArchonForm.Start", hero)
            Filters:CastSkillArguments(BASE_ABILITY_R, hero)
        end
    end
end

function arkimus_archon_form:GetIntrinsicModifierName()
    return "modifier_arkimus_arcana_r_3_buff"
end


modifier_channel_start = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_channel_start", "heroes/antimage/arkimus_archon_form", LUA_MODIFIER_MOTION_NONE)

function modifier_channel_start:IsHidden()
    return true
end
function modifier_channel_start:GetEffectName()
    return "particles/roshpit/arkimus/channel_energy.vpcf"
end
function modifier_channel_start:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

modifier_arkimus_archon_form = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_arkimus_archon_form", "heroes/antimage/arkimus_archon_form", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_archon_form:OnCreated()
    if not IsServer() then
        return
    end
    local hero = self:GetParent()
    hero:SetRangedProjectileName("particles/base_attacks/arkimus_archon_form.vpcf")
    Events:ColorWearablesAndBase(hero, Vector(0, 0, 0))
    hero:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_ARMOR_PIERCE_BONUS,
        MODIFIER_ROSHPIT_SPELL_PIERCE_BONUS 
    })
end
function modifier_arkimus_archon_form:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MODEL_SCALE,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
        MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
        MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_arkimus_archon_form:GetModifierModelScale(params)
    return 8
end

function modifier_arkimus_archon_form:GetModifierAttackRangeBonus(params)
    return ARKIMUS_ARCANA2_R_ATTACK_RANGE_BONUS[self:GetAbility():GetLevel()]
end

function modifier_arkimus_archon_form:GetModifierProjectileSpeedBonus(params)
    return 800
end

function modifier_arkimus_archon_form:GetModifierBaseAttackTimeConstant()
    local hero = self:GetParent()
    if hero.CurrentModifier ~= self then
        hero.CurrentModifier = self
        local currentBat = hero:GetBaseAttackTime()
        hero.CurrentModifier = nil
        local batBonus = ARKIMUS_ARCANA2_R_BAT_RED_PCT * currentBat
        local r_4_level = hero:GetModifierStackCount("modifier_arkimus_arcana_r_4_buff", hero)
        if r_4_level > 0 then
            batBonus = batBonus + currentBat * ARKIMUS_ARCANA2_R4_BAT_RED_PCT * r_4_level
        end
        local newBat = currentBat - batBonus
        return newBat
    end
    return -1
end

function modifier_arkimus_archon_form:GetModifierAttackSpeedBonus_Constant()
    return ARKIMUS_ARCANA2_R_BONUS_AS
end

function modifier_arkimus_archon_form:GetAttackSound(params)
    return "Arkimus.ArchonForm.Attack"
end

function modifier_arkimus_archon_form:IsHidden()
    return false
end

function modifier_arkimus_archon_form:IsBuff()
    return true
end
function modifier_arkimus_archon_form:OnAttackLanded(event)
    local attacker = event.attacker
    if attacker ~= self:GetParent() then
        return
    end
    local ability = self:GetAbility()
    local target = event.target
    if not ability.aoePosition then
        ability.aoePosition = Vector(0, 0)
    end
    if WallPhysics:GetDistance2d(attacker:GetAbsOrigin(), target:GetAbsOrigin()) <= attacker:Script_GetAttackRange() / 2 then
        attacker:AddNewModifier(attacker, ability, "modifier_arkimus_archon_form_pushback", {duration = 1})
        local pushFV = ((attacker:GetAbsOrigin() - target:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
        ability.pushFV = pushFV
        ability.pushVelocity = 20
    end
    local r_1_level = attacker:GetRuneValue("r", 1)
    if attacker:GetUnitName() == "seafortress_archon_wizard" then
        r_1_level = 10
    end

    if r_1_level > 0 then
        attacker:AddNewModifier(attacker, ability, "modifier_arkimus_arcana_r_1_field_thinker", {duration = ARKIMUS_ARCANA2_R1_DURATION})
        if WallPhysics:GetDistance2d(ability.aoePosition, target:GetAbsOrigin()) > 80 then
            if ability.pfx then
                ParticleManager:DestroyParticle(ability.pfx, false)
                ability.pfx = false
            end
            ability.pfx = ParticleManager:CreateParticle("particles/roshpit/arkimus/archon_flare_ambient.vpcf", PATTACH_CUSTOMORIGIN, nil)
            ParticleManager:SetParticleControl(ability.pfx, 0, target:GetAbsOrigin())
            ParticleManager:SetParticleControl(ability.pfx, 1, Vector(ARKIMUS_ARCANA2_R1_AOE, ARKIMUS_ARCANA2_R1_AOE, ARKIMUS_ARCANA2_R1_AOE))
            ability.aoePosition = GetGroundPosition(target:GetAbsOrigin(), target)
            EmitSoundOnLocationWithCaster(ability.aoePosition, "Arkimus.ArchonFlare.Start", attacker)
            EmitSoundOn("Arkimus.ArchonFlare.Go", target)
        end
    end
end

function modifier_arkimus_archon_form:OnRemoved()
    if IsServer() then
        local hero = self:GetCaster()
        Events:ColorWearablesAndBase(hero, Vector(255, 255, 255))
        hero:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
    end
end

modifier_arkimus_archon_form_pushback = class ({})
LinkLuaModifier("modifier_arkimus_archon_form_pushback", "heroes/antimage/arkimus_archon_form", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_archon_form_pushback:OnCreated()
    self:StartIntervalThink(0.03)
end

function modifier_arkimus_archon_form_pushback:OnIntervalThink()
    if IsServer() then
        local hero = self:GetParent()
        local ability = self:GetAbility()
        local newPosition = GetGroundPosition(hero:GetAbsOrigin() + ability.pushFV * ability.pushVelocity, hero)
        local afterWallPosition = WallPhysics:WallSearch(GetGroundPosition(hero:GetAbsOrigin(), hero), newPosition, hero)
        if afterWallPosition == newPosition then
            hero:SetAbsOrigin(newPosition)
        end
        ability.pushVelocity = ability.pushVelocity - 1
        if ability.pushVelocity <= 0 then
            hero:RemoveModifierByName("modifier_arkimus_archon_form_pushback")
        end
    end
end

modifier_arkimus_arcana_r_1_field_thinker = class ({})
LinkLuaModifier("modifier_arkimus_arcana_r_1_field_thinker", "heroes/antimage/arkimus_archon_form", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_arcana_r_1_field_thinker:IsHidden()
    return true
end

function modifier_arkimus_arcana_r_1_field_thinker:OnCreated()
    self:StartIntervalThink(0.1)
end
function modifier_arkimus_arcana_r_1_field_thinker:OnIntervalThink()
    if IsServer() then
        local caster = self:GetParent()
        local ability = self:GetAbility()
        for i = 1, 2, 1 do
            local flarePos = ability.aoePosition + RandomVector(RandomInt(0, 160))
            CustomAbilities:QuickParticleAtPoint("particles/roshpit/arkimus/archon_flare_ambient_hit.vpcf", flarePos, 1)
        end
        local r_1_level = caster:GetRuneValue("r", 1)
        local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * ARKIMUS_ARCANA2_R1_DMG_OF_ATTACK_POWER_PCT * r_1_level
        local enemies = FindUnitsInRadius(caster:GetTeamNumber(), ability.aoePosition, nil, ARKIMUS_ARCANA2_R1_AOE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
        for k, v in pairs(enemies) do
            if v.dummy then table.remove(enemies, k) end
        end
        if #enemies > 0 then
            local dividedDamage = damage / #enemies
            for _, enemy in pairs(enemies) do
                Filters:TakeArgumentsAndApplyDamage(enemy, caster, dividedDamage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_R, RPC_ELEMENT_ARCANE, RPC_ELEMENT_NONE)
            end
        end
    end
end

function modifier_arkimus_arcana_r_1_field_thinker:OnDestroy()
    local caster = self:GetParent()
	local ability = self:GetAbility()
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ability.pfx = false
    end
end

modifier_arkimus_arcana_r_2_dmg_buff = class ({})
LinkLuaModifier("modifier_arkimus_arcana_r_2_dmg_buff", "heroes/antimage/arkimus_archon_form", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_arcana_r_2_dmg_buff:IsHidden()
    return true
end
function modifier_arkimus_arcana_r_2_dmg_buff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
    }

    return funcs
end

function modifier_arkimus_arcana_r_2_dmg_buff:GetModifierBaseAttack_BonusDamage()
    local hero = self:GetParent()
    return hero:GetMana() * self:GetStackCount() * ARKIMUS_ARCANA2_R2_BASE_DMG_PER_MANA_PCT
end

modifier_arkimus_arcana_r_2_mana_regen_buff = class ({})
LinkLuaModifier("modifier_arkimus_arcana_r_2_mana_regen_buff", "heroes/antimage/arkimus_archon_form", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_arcana_r_2_mana_regen_buff:IsHidden()
    return true
end
function modifier_arkimus_arcana_r_2_mana_regen_buff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
    }

    return funcs
end

function modifier_arkimus_arcana_r_2_mana_regen_buff:GetModifierConstantManaRegen()
    return self:GetStackCount()
end


modifier_arkimus_arcana_r_3_buff = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_arkimus_arcana_r_3_buff", "heroes/antimage/arkimus_archon_form", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_arcana_r_3_buff:IsHidden()
    return true
end
function modifier_arkimus_arcana_r_3_buff:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        RPC_ELEMENT_FIRE,
        RPC_ELEMENT_EARTH,
        RPC_ELEMENT_LIGHTNING,
        RPC_ELEMENT_POISON,
        RPC_ELEMENT_TIME,
        RPC_ELEMENT_HOLY,
        RPC_ELEMENT_COSMOS,
        RPC_ELEMENT_ICE,
        RPC_ELEMENT_ARCANE,
        RPC_ELEMENT_SHADOW,
        RPC_ELEMENT_WIND,
        RPC_ELEMENT_GHOST,
        RPC_ELEMENT_WATER,
        RPC_ELEMENT_DEMON,
        RPC_ELEMENT_NATURE,
        RPC_ELEMENT_UNDEAD,
        RPC_ELEMENT_DRAGON
    })
end

function modifier_arkimus_arcana_r_3_buff:GetRoshpitElementalDmgBonus()
    local hero = self:GetParent()
    return ARKIMUS_ARCANA2_R3_ELEMENTS_PCT * hero:GetRuneValue("r", 3)
end

modifier_arkimus_arcana_r_4_buff = class ({})
LinkLuaModifier("modifier_arkimus_arcana_r_4_buff", "heroes/antimage/arkimus_archon_form", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_arcana_r_4_buff:IsHidden()
    return true
end

function modifier_arkimus_arcana_r_4_buff:IsBuff()
    return true
end
function modifier_arkimus_arcana_r_4_buff:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK
    }

    return funcs
end
function modifier_arkimus_arcana_r_4_buff:OnAttack(event)
    local attacker = event.attacker
    if attacker ~= self:GetParent() then
        return
    end
	local ability = event.ability
    local target = event.target
    local r_4_level = attacker:GetRuneValue("r", 4)
	if r_4_level > 0 then
		if target.dummy then
		else
			local luck = RandomInt(1, 1000)
			if luck <= r_4_level * ARKIMUS_ARCANA2_R4_CHANCE_DIV_1000 then
				Filters:PerformAttackSpecial(attacker, target, true, true, true, false, true, false, false)
			end
		end
    end
end