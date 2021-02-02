require('heroes/nightstalker/util')

chernobog_nights_procession = class(base_ability)

modifier_chernobog_r_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_r_passive", "heroes/nightstalker/ability_scripts/chernobog_nights_procession.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_r_lifting = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_r_lifting", "heroes/nightstalker/ability_scripts/chernobog_nights_procession.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_nights_procession = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_nights_procession", "heroes/nightstalker/ability_scripts/chernobog_nights_procession.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_r_effect = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_r_effect", "heroes/nightstalker/ability_scripts/chernobog_nights_procession.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_r1_effect = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_r1_effect", "heroes/nightstalker/ability_scripts/chernobog_nights_procession.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_r4_demon_amp = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_r4_demon_amp", "heroes/nightstalker/ability_scripts/chernobog_nights_procession.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_r4_shadow_amp = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_r4_shadow_amp", "heroes/nightstalker/ability_scripts/chernobog_nights_procession.lua", LUA_MODIFIER_MOTION_NONE)

function chernobog_nights_procession:GetBehaviorBase()
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_AOE
end

function chernobog_nights_procession:GetManaCostBase(level)
    return 0
end

function chernobog_nights_procession:GetAbilitySlot()
    return DOTA_R_SLOT
end

function chernobog_nights_procession:GetChannelTimeBase()
    return CHERNOBOG_R_CHANNEL_TIME
end

function chernobog_nights_procession:GetIntrinsicModifierName()
    return "modifier_chernobog_r_passive"
end

function chernobog_nights_procession:GetCooldownBase(level)
    if level == -1 then
        level = self:GetLevel() - 1
    end
    return CHERNOBOG_R_COOLDOWN[level + 1]
end

function chernobog_nights_procession:OnSpellStartBase()
    local caster = self:GetCaster()
    beginChannel{ caster = caster }
    local casterOrigin = caster:GetAbsOrigin()
    if IsServer() then
        if caster:HasModifier("modifier_chernobog_glyph_3_1") then
			local ability = caster:GetAbilityByIndex(DOTA_Q_SLOT)
			ability:OnSpellStart()
		end
        StartSoundEvent("Chernobog.NightsProcessionChannelStart", caster)
        StartSoundEvent('Chernobog.NightsProcessionChannelling', caster)
        StartAnimation(caster, {duration = 3, activity = ACT_DOTA_TELEPORT, rate = 0.8})
    end
end

function chernobog_nights_procession:OnChannelFinish(interrupted)
    endChannel{ caster = self:GetCaster() }
    if IsServer() then
        if interrupted then
            self:OnChannelInterrupted()
        else
            self:OnChannelSucceeded()
        end
        local caster = self:GetCaster()
        StopSoundEvent("Chernobog.NightsProcessionChannelStart", caster)
        StopSoundEvent('Chernobog.NightsProcessionChannelling', caster)
    end
end

function chernobog_nights_procession:OnChannelInterrupted()
    endChannel{ caster = self:GetCaster() }
end

function chernobog_nights_procession:OnChannelSucceeded()
	local caster = self:GetCaster()
	local r_3_level = caster:GetRuneValue("r", 3)
    endChannel{ caster = caster }
	self.radius = CalculateFinalRadius(caster, CHERNOBOG_R_RADIUS, DOTA_R_SLOT)
    self.lifting_up_per_tick = 0
    self.lifting_down_per_tick = 0
    self.startPoint = caster:GetAbsOrigin()
    self.endPoint = caster:GetCursorPosition()
    CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_antimage/antimage_manavoid.vpcf", caster, 4)
    EmitSoundOn("Chernobog.NightsProcessionChannelEnd", caster)
    self:Lifting()
    Filters:CastSkillArguments(BASE_ABILITY_R, caster)
end

function chernobog_nights_procession:Lifting()
    local caster = self:GetCaster()
	local modifier_name = "modifier_chernobog_r_lifting"
    local liftingIntervalThink = 0.03
    local currentLiftingInterval = 0
    local intervalIncrease = (1 + CHERNOBOG_R3_CHANNEL_TIME_REDUCTION * self:GetCaster().r3_level)
    local liftingDownStartInterval = 60
    local liftingEndInterval = 120
    Timers:CreateTimer(function()
        if currentLiftingInterval == 0 then
            self:LiftingStart(caster)
            caster:AddNewModifier(caster, self,  modifier_name, {})
        elseif currentLiftingInterval < liftingDownStartInterval then
            self:LiftingUp(caster, currentLiftingInterval, intervalIncrease)
        elseif currentLiftingInterval >= liftingDownStartInterval and currentLiftingInterval < liftingDownStartInterval + intervalIncrease then
            self:LiftingDownStart()
        elseif currentLiftingInterval < liftingEndInterval then
            self:LiftingDown(caster, currentLiftingInterval - liftingDownStartInterval, intervalIncrease)
        elseif currentLiftingInterval >= liftingEndInterval then
            self:CreateNightsProcession()
			self:ProcR3()
            self:LiftingEnd()
            caster:RemoveModifierByName(modifier_name)
            return
        end
        currentLiftingInterval = currentLiftingInterval + intervalIncrease
        return liftingIntervalThink
    end)
end
function chernobog_nights_procession:LiftingStart()
end
function chernobog_nights_procession:LiftingUp(caster, currentLiftingInterval, intervalIncrease)
    caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, currentLiftingInterval * intervalIncrease))
    self.lifting_up_per_tick = self.lifting_up_per_tick +  currentLiftingInterval * intervalIncrease
end
function chernobog_nights_procession:LiftingDownStart()
    self.endPoint = WallPhysics:WallSearch(self.startPoint, self.endPoint, self:GetCaster())
    self.endPoint.z = self:GetCaster():GetOrigin().z
    StartAnimation(self:GetCaster(), {duration = 3.5, activity = ACT_DOTA_VERSUS, rate = 1})
end
function chernobog_nights_procession:LiftingDown(caster, currentLiftingInterval, intervalIncrease)
    caster:SetAbsOrigin(self.endPoint - Vector(0, 0, self.lifting_down_per_tick))
    self.lifting_down_per_tick = self.lifting_down_per_tick +  currentLiftingInterval * (intervalIncrease - 0.02)
end

function chernobog_nights_procession:LiftingEnd()
    local caster = self:GetCaster()
    FindClearSpaceForUnit(caster, self.endPoint, false)
    EmitSoundOn("Chernobog.NightsProcession.Land", caster)
    ScreenShake(caster:GetAbsOrigin(), 260, 0.3, 0.3, 9000, 0, true)
    local pfx = ParticleManager:CreateParticle("particles/econ/events/ti4/teleport_end_dust_ti4.vpcf", PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(pfx, 1, Vector(200, 200, 200))
    Timers:CreateTimer(2, function()
        ParticleManager:DestroyParticle(pfx, false)
        ParticleManager:ReleaseParticleIndex(pfx)
    end)
end

function chernobog_nights_procession:CreateNightsProcession()
	local caster = self:GetCaster()
	local ability = self
	local pos = ability.endPoint
	local duration = Filters:GetAdjustedBuffDuration(self:GetCaster(), CHERNOBOG_R_DURATION)
	local modifier_name = "modifier_chernobog_nights_procession"
	CreateModifierThinker(caster, ability, modifier_name, {duration = duration, radius = ability.radius, positon = pos}, pos, caster:GetTeamNumber(), false)
end

function chernobog_nights_procession:ProcR3()
	local caster = self:GetCaster()
	local r_1_level = caster:GetRuneValue("r", 1)
	if r_1_level > 0 then
		local r_1_duration = CHERNOBOG_R_DURATION + CHERNOBOG_R1_DUR_BASE + r_1_level * CHERNOBOG_R1_DUR
		ApplyModifier(caster, caster, ability, "modifier_chernobog_r1_effect", r_1_duration, nil)
	end
end

--modifiers
function modifier_chernobog_nights_procession:IsHidden()
	return true
end

function modifier_chernobog_nights_procession:IsAura()
	return true
end

function modifier_chernobog_nights_procession:GetModifierAura()
	return "modifier_chernobog_r_effect"
end

function modifier_chernobog_nights_procession:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_chernobog_nights_procession:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

function modifier_chernobog_nights_procession:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_chernobog_nights_procession:GetAuraRadius()
    return self:GetAbility().radius
end

function modifier_chernobog_nights_procession:OnCreated(event)
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local endPoint = self:GetAbility().endPoint
	local duration = event.duration
	local ability = self:GetAbility()
	local radius = ability.radius
	local pfx = ParticleManager:CreateParticle("particles/roshpit/chernobog/nights_procession_aoe.vpcf", PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(pfx, 0, GetGroundPosition(endPoint, caster))
    ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
    Timers:CreateTimer(duration, function()
        ParticleManager:DestroyParticle(pfx, false)
        ParticleManager:ReleaseParticleIndex(pfx)
    end)
end

--lifting modifier
function modifier_chernobog_r_lifting:IsHidden()
	return true
end

function modifier_chernobog_r_lifting:IsDebuff()
	return false
end

function modifier_chernobog_r_lifting:CheckState()
	return {
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
    }
end

--R effect
function modifier_chernobog_r_effect:IsHidden()
	return false
end

function modifier_chernobog_r_effect:IsDebuff()
	return true
end

function modifier_chernobog_r_effect:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_FROZEN] = true,
        [MODIFIER_STATE_STUNNED] = true,
    }
end

function modifier_chernobog_r_effect:GetStatusEffectName()
    return 'particles/status_fx/status_effect_faceless_chronosphere.vpcf'
end

--R passive
function modifier_chernobog_r_passive:IsHidden()
	return true
end

function modifier_chernobog_r_passive:IsDebuff()
	return false
end

function modifier_chernobog_r_passive:RemoveOnDeath()
	return false
end

function modifier_chernobog_r_passive:OnCreated()
	if not IsServer() then
		return
	end
	self:SetSpecialTypes({
			MODIFIER_ROSHPIT_R_FLAT_CD_MOD,
			MODIFIER_ROSHPIT_R_FLAT_CHANNELTIME_MOD,
	})
	self:StartIntervalThink(0.5)
end

function modifier_chernobog_r_passive:OnIntervalThink()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local r_1_level = caster:GetRuneValue("r", 1)
	local r_1_modifier = "modifier_chernobog_r1_effect"
	ModifierThink(caster, self:GetAbility(), DOTA_R_SLOT, "r", nil, false)
	if r_1_level > 0 then
		if caster:HasModifier("modifier_chernobog_glyph_5_2") then
			ApplyModifier(caster, caster, ability, r_1_modifier, -1, nil)
		else
			if not (caster:HasModifier(r_1_modifier) and (caster:FindModifierByName("modifier_chernobog_r1_effect"):GetDuration() > 0)) then
				caster:RemoveModifierByName(r_1_modifier)
			end
		end
	else
		caster:RemoveModifierByName(r_1_modifier)
	end
end

function modifier_chernobog_r_passive:GetRoshpitRFlatCdModifier()
	return -math.min( self:GetCaster():GetRuneValue("r", 3) * CHERNOBOG_R3_COOLDOWN_REDUCTION, CHERNOBOG_R3_MAX_COOLDOWN_REDUCTION)
end

function modifier_chernobog_r_passive:GetRoshpitRFlatChanneltimeModifier()
	local caster = self:GetCaster()
	return -math.min(CHERNOBOG_R_CHANNEL_TIME, caster:GetRuneValue("r", 3) * CHERNOBOG_R3_CHANNEL_TIME_REDUCTION)
end

function modifier_chernobog_r1_effect:IsHidden()
	return false
end

function modifier_chernobog_r1_effect:IsDebuff()
	return false
end

function modifier_chernobog_r1_effect:GetTexture()
	return "chernobog/chernobog_rune_r_1"
end

function modifier_chernobog_r1_effect:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end

function modifier_chernobog_r1_effect:OnAttackLanded(event)
    if not IsServer() then
        return
    end
    if event.target == self:GetParent() or event.attacker ~= self:GetCaster() then
        return
    end
    local caster = self:GetCaster()
    local target = event.target
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * self:GetCaster():GetRuneValue("r", 1) * CHERNOBOG_R1_DMG_PER_ATT / 100
	local radius = CalculateFinalRadius(caster, CHERNOBOG_R1_RADIUS, DOTA_R_SLOT)
    local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
    local particle2 = ParticleManager:CreateParticle(particleNameS, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(particle2, 0, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle2, 1, Vector(radius, radius, radius))
    ParticleManager:SetParticleControl(particle2, 2, Vector(2.0, 2.0, 2.0))
    ParticleManager:SetParticleControl(particle2, 4, Vector(22, 56, 148))
    Timers:CreateTimer(1.5, function()
        ParticleManager:DestroyParticle(particle2, false)
    end)
    local enemies = SearchEnemies(caster, target, radius)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			if enemy:HasModifier("modifier_chernobog_r_effect") then
				damage = damage * (1 + CHERNOBOG_GLYPH_5_2_R1_AMP_IN_R / 100)
			end
			ChernobogDealDamage(caster, enemy, damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_R, RPC_ELEMENT_DEMON, RPC_ELEMENT_NONE, false, true)
		end
	end
end



----------
--- R4 ---
----------
function modifier_chernobog_r4_demon_amp:IsHidden()
	return true
end

function modifier_chernobog_r4_demon_amp:IsDebuff()
	return false
end

function modifier_chernobog_r4_demon_amp:IsPurgable()
	return false
end

function modifier_chernobog_r4_demon_amp:RemoveOnDeath()
	return false
end

function modifier_chernobog_r4_demon_amp:OnCreated()
	if not IsServer() then
		return
	end
	self:SetSpecialTypes({
		RPC_ELEMENT_DEMON
	})
	self:StartIntervalThink(0.5)
end

function modifier_chernobog_r4_demon_amp:GetRoshpitElementalDmgBonus()
	local caster = self:GetCaster()
	local amp = caster:GetRuneValue("r", 4) * CHERNOBOG_R4_DEMON_AMP_PER_STR * caster:GetStrength() / 100
	return amp
end

function modifier_chernobog_r4_shadow_amp:IsHidden()
	return true
end

function modifier_chernobog_r4_shadow_amp:IsDebuff()
	return false
end

function modifier_chernobog_r4_shadow_amp:IsPurgable()
	return false
end

function modifier_chernobog_r4_shadow_amp:RemoveOnDeath()
	return false
end

function modifier_chernobog_r4_shadow_amp:OnCreated()
	if not IsServer() then
		return
	end
	self:SetSpecialTypes({
		RPC_ELEMENT_SHADOW
	})
	self:StartIntervalThink(0.5)
end

function modifier_chernobog_r4_shadow_amp:GetRoshpitElementalDmgBonus()
	local caster = self:GetCaster()
	local amp = caster:GetRuneValue("r", 4) * CHERNOBOG_R4_SHADOW_AMP_PER_AGI * caster:GetAgility() / 100
	return amp
end
