require('heroes/nightstalker/chernobog_constants')
require('heroes/base_ability')
require("heroes/util/channeling")

chernobog_nights_procession = class(base_ability)

modifier_chernobog_r_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_r_passive", "heroes/nightstalker/ability_scripts/chernobog_nights_procession.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_r_lifting = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_r_lifting", "heroes/nightstalker/ability_scripts/chernobog_nights_procession.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_nights_procession = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_nights_procession", "heroes/nightstalker/ability_scripts/chernobog_nights_procession.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_r_effect = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_r_effect", "heroes/nightstalker/ability_scripts/chernobog_nights_procession.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_r3_effect = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_r3_effect", "heroes/nightstalker/ability_scripts/chernobog_nights_procession.lua", LUA_MODIFIER_MOTION_NONE)

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
	local r_4_level = caster:GetRuneValue("r", 4)
    endChannel{ caster = caster }
	self.radius = CHERNOBOG_R_RADIUS
	if r_4_level > 0 then
		self.radius = self.radius + CHERNOBOG_R4_RADIUS * r_4_level 
	end
	if self:GetCaster():HasModifier('modifier_chernobog_glyph_2_1') then
		self.radius = self.radius * CHERNOBOG_T21_RADIUS_AMP
    end
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
    local intervalIncrease = (1 + CHERNOBOG_R4_CHANNEL_TIME_REDUCTION * self:GetCaster().r4_level)
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

function chernobog_nights_procession:GetShadowState()
	local caster = self:GetCaster()
	local ability = self
	local e_2_level = caster:GetRuneValue("e", 2)
	local e_3_level = caster:GetRuneValue("e", 3)
	local e_4_level = caster:GetRuneValue("e", 4)
	local atk_dmg = OverflowProtectedGetAverageTrueAttackDamage(caster)
	local shadowTable = {}
	local arcanaAbility = {"chernobog_demon_flight", "chernobog_demon_walk", "chernobog_demon_warp"}
	for i = 1, #arcanaAbility, 1 do
		if caster:HasAbility(arcanaAbility[i]) then
			if e_4_level > 0 then
				shadowTable.interval = CHERNOBOG_ARCANA2_E4_INTERVAL
				shadowTable.damage = atk_dmg * e_4_level * CHERNOBOG_ARCANA2_E4_DMG_PCT / 100
				return shadowTable
			end
		end
	end
	if e_2_level > 0 then
		shadowTable.interval = CHERNOBOG_E2_INTERVAL
		shadowTable.damage = atk_dmg * e_2_level * CHERNOBOG_E2_DMG_PCT
		if e_4_level > 0 then
			shadowTable.interval = shadowTable.interval / (1 + e_4_level * CHERNOBOG_E4_SHADOWS_INTERVAL_SCALE)
		end
		return shadowTable
	end
	return shadowTable
end

function chernobog_nights_procession:ProcR2(caster, damage, pos, radius, interval)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			if IsValidEntity(enemy) then
				local damageDelay =  0.9 * interval
				local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/chernobog/nights_procession_illusion.vpcf", enemy, interval)
				ParticleManager:SetParticleControl(pfx, 1, Vector(animationRate, 0, 0))
				Timers:CreateTimer(damageDelay, function()
					EmitSoundOn("Chernobog.BC.Hit", enemy)
					Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_E, RPC_ELEMENT_DEMON, RPC_ELEMENT_SHADOW)
					ParticleManager:DestroyParticle(pfx, false)
					ParticleManager:ReleaseParticleIndex(pfx)
				end)
			end
		end
	end
end

function chernobog_nights_procession:ProcR3()
	local caster = self:GetCaster()
	local r_3_level = caster:GetRuneValue("r", 3)
	if r_3_level > 0 then
		local r_3_duration = Filters:GetAdjustedBuffDuration(caster, CHERNOBOG_R_DURATION + CHERNOBOG_R3_DUR_BASE + r_3_level * CHERNOBOG_R3_DUR)
		caster:AddNewModifier(caster, self, "modifier_chernobog_r3_effect", {duration = r_3_duration})
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
	self.radius = event.radius
	local pfx = ParticleManager:CreateParticle("particles/roshpit/chernobog/nights_procession_aoe.vpcf", PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(pfx, 0, GetGroundPosition(endPoint, caster))
    ParticleManager:SetParticleControl(pfx, 1, Vector(self.radius, self.radius, self.radius))
    Timers:CreateTimer(duration, function()
        ParticleManager:DestroyParticle(pfx, false)
        ParticleManager:ReleaseParticleIndex(pfx)
    end)
	
	local ability = self:GetAbility()
	local interval = 0.03
	local shadowInterval = ability:GetShadowState().interval
	if shadowInterval then
		interval = shadowInterval
	end
	self:StartIntervalThink(interval)
end

function modifier_chernobog_nights_procession:OnIntervalThink()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local shadowState = ability:GetShadowState()
	local shadowDamage = shadowState.damage
	local shadowInterval = shadowState.interval
	local interval = 0.03
	if shadowInterval then
		interval = shadowInterval
	end
	self:StartIntervalThink(interval)
	local r_2_level = caster:GetRuneValue("r", 2)
	if r_2_level > 0 then
		if shadowDamage and shadowDamage > 0 then
			local damage = shadowDamage * (1 + r_2_level * CHERNOBOG_R2_SHADOWS_AMP)
			self:GetAbility():ProcR2(caster, damage, ability.endPoint, ability.radius, interval)
		end
	end
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
			MODIFIER_ROSHPIT_R_PCT_CD_MOD, 
			RPC_ELEMENT_DEMON
	})
end

function modifier_chernobog_r_passive:GetRoshpitRPctCdModifier()
	return -math.min( self:GetCaster():GetRuneValue("r", 3) * CHERNOBOG_R4_COOLDOWN_REDUCTION, CHERNOBOG_R4_COOLDOWN_REDUCTION)
end

function modifier_chernobog_r_passive:GetRoshpitElementalDmgBonus()
	local caster = self:GetCaster()
	return caster:GetRuneValue("r", 1) * CHERNOBOG_R1_DEMON_AMP
end

function modifier_chernobog_r3_effect:IsHidden()
	return false
end

function modifier_chernobog_r3_effect:IsDebuff()
	return false
end

function modifier_chernobog_r3_effect:GetTexture()
	return "chernobog/chernobog_rune_r_3"
end

function modifier_chernobog_r3_effect:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end

function modifier_chernobog_r3_effect:OnAttackLanded(event)
    if not IsServer() then
        return
    end
    if event.target == self:GetParent() or event.attacker ~= self:GetCaster() then
        return
    end
    local caster = self:GetCaster()
    local target = event.target

    local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
    local particle2 = ParticleManager:CreateParticle(particleNameS, PATTACH_WORLDORIGIN, caster)
    local radius = CHERNOBOG_R3_RADIUS

    ParticleManager:SetParticleControl(particle2, 0, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle2, 1, Vector(radius, radius, radius))
    ParticleManager:SetParticleControl(particle2, 2, Vector(2.0, 2.0, 2.0))
    ParticleManager:SetParticleControl(particle2, 4, Vector(22, 56, 148))
    Timers:CreateTimer(1.5, function()
        ParticleManager:DestroyParticle(particle2, false)
    end)

    local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * CHERNOBOG_R3_DMG_PER_ATT * self:GetCaster():GetRuneValue("r", 3)
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_R, RPC_ELEMENT_DEMON, RPC_ELEMENT_NONE)
		end
	end
end
