require('heroes/nightstalker/util')

chernobog_demon_morph = class(base_ability)

modifier_chernobog_demon_form = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_demon_form", "heroes/nightstalker/arcana/chernobog_demon_morph.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_arcana_r_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_arcana_r_passive", "heroes/nightstalker/arcana/chernobog_demon_morph.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_arcana_r_channel_end = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_arcana_r_channel_end", "heroes/nightstalker/arcana/chernobog_demon_morph.lua", LUA_MODIFIER_MOTION_NONE)


function chernobog_demon_morph:GetBehaviorBase()
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED
end

function chernobog_demon_morph:GetManaCostBase(level)
    return 0
end

function chernobog_demon_morph:GetAbilitySlot()
    return DOTA_R_SLOT
end

function chernobog_demon_morph:GetChannelTimeBase()
    return 1.5
end

function chernobog_demon_morph:GetIntrinsicModifierName()
    return "modifier_chernobog_arcana_r_passive"
end

function chernobog_demon_morph:GetCastAnimation()
	return ACT_DOTA_VICTORY
end

function chernobog_demon_morph:GetDuration()
	return self:GetSpecialValueFor("duration")
end

function chernobog_demon_morph:GetCooldownBase(level)
    return 70
end

function chernobog_demon_morph:OnSpellStartBase()
    local caster = self:GetCaster()
    beginChannel{ caster = caster }
    EmitSoundOn("Chernobog.NightsProcessionChannelStart", caster)
end

function chernobog_demon_morph:OnChannelFinish(interrupted)
    endChannel{ caster = self:GetCaster() }
    if IsServer() then
        if interrupted then
            self:OnChannelInterrupted()
        else
            self:OnChannelSucceeded()
        end
    end
end

function chernobog_demon_morph:OnChannelInterrupted()
    endChannel{ caster = self:GetCaster() }
end

function chernobog_demon_morph:OnChannelSucceeded()
	local caster = self:GetCaster()
	local ability = self
	local particleName = "particles/roshpit/chernobog/demon_form_transition.vpcf"
	if caster:HasModifier("modifier_demon_hunter") then
		particleName = "particles/units/heroes/hero_shadow_demon/shadow_demon_disruption.vpcf"
	end
	EmitSoundOn("Chernobog.DemonForm.Transition", caster)
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin() + Vector(0, 0, 50))
	Timers:CreateTimer(2.0, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	if caster:HasModifier("modifier_chernobog_glyph_3_1") then
        local Qability = caster:GetAbilityByIndex(DOTA_Q_SLOT)
        Qability:OnSpellStart()
    end
	ProjectileManager:ProjectileDodge(caster)
	caster:AddNoDraw()
	caster:AddNewModifier(caster, ability, "modifier_chernobog_arcana_r_channel_end", {duration = 2.0})
	local duration = ability:GetDuration()
	local morphDuration = Filters:GetAdjustedBuffDuration(caster, duration, false)
	Timers:CreateTimer(0.5, function()
		caster:RemoveNoDraw()
		caster:RemoveModifierByName("modifier_chernobog_arcana_r_channel_end")
		if caster:HasModifier("modifier_chernobog_demon_form") then
			StartAnimation(caster, {duration = 0.5, activity = ACT_DOTA_CAST_ABILITY_3, rate = 1.3})
			caster:AddNewModifier(caster, ability, "modifier_chernobog_demon_form", {})
			CustomAbilities:QuickAttachParticle("particles/roshpit/chernobog/demonform_start_start_ti7_lvl2.vpcf", caster, 3)
			EmitSoundOn("Chernobog.DemonForm.Anger", caster)
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Chernobog.DemonForm.Start", caster)
		end

		caster:AddNewModifier(caster, ability, "modifier_chernobog_demon_form", {duration = morphDuration})
		if caster:HasModifier("modifier_chernobog_arcana_e_passive") then
			if caster:GetAbilityByIndex(DOTA_E_SLOT):GetAbilityName() == "chernobog_demon_flight" then
				CustomAbilities:AddAndOrSwapSkill(caster, "chernobog_demon_flight", "chernobog_demon_walk", 2)
			end
		end
		Filters:CastSkillArguments(BASE_ABILITY_R, caster)
	end)
end

--modifiers
function modifier_chernobog_arcana_r_channel_end:IsHidden()
	return true
end

function modifier_chernobog_arcana_r_channel_end:IsDebuff()
	return false
end

function modifier_chernobog_arcana_r_channel_end:IsPurgable()
	return false
end

function modifier_chernobog_arcana_r_channel_end:OnCreated()
	if not IsServer() then	
		return
	end
end

function modifier_chernobog_arcana_r_channel_end:OnDestroy()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local modelName = "models/heroes/terrorblade/demon.vmdl"
	caster:SetModel("models/heroes/terrorblade/demon.vmdl")
	caster:SetOriginalModel("models/heroes/terrorblade/demon.vmdl")
	StartAnimation(caster, {duration = 0.5, activity = ACT_DOTA_CAST_ABILITY_3, rate = 1.3})
	CustomAbilities:QuickAttachParticle("particles/roshpit/chernobog/demonform_start_start_ti7_lvl2.vpcf", caster, 3)
	EmitSoundOn("Chernobog.DemonForm.Anger", caster)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Chernobog.DemonForm.Start", caster)

	caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
end

function modifier_chernobog_arcana_r_channel_end:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_ROOTED] = true
	}
end

function modifier_chernobog_demon_form:DeclareFunctions()
	return {
			MODIFIER_EVENT_ON_ATTACK_LANDED,
			MODIFIER_EVENT_ON_ATTACK_START,
			MODIFIER_PROPERTY_MODEL_SCALE,
			MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
			MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
			MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
			MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		}
end

function modifier_chernobog_demon_form:IsHidden()
	return false
end

function modifier_chernobog_demon_form:IsDebuff()
	return false
end

function modifier_chernobog_demon_form:OnCreated()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	self:SetSpecialTypes({
		MODIFIER_ROSHPIT_MASTER_GREEN_DMG
	})
	if caster:HasModifier("modifier_demon_hunter") then
		caster:SetRangedProjectileName("particles/units/heroes/hero_nevermore/nevermore_base_attack.vpcf")
	else
		caster:SetRangedProjectileName("particles/roshpit/chernobog/demon_form_attack.vpcf")
	end
end

function modifier_chernobog_demon_form:OnAttackLanded(event)
	if not IsServer() then
		return
	end
	if event.target == self:GetParent() or event.attacker ~= self:GetParent() then
		return 
	end
	self:ProcR1(self:GetCaster(), event.target)
	self:ProcR2(self:GetCaster(), event.target)
end

function modifier_chernobog_demon_form:ProcR1(caster, target)
	local r_1_level = caster:GetRuneValue("r", 1)
	if not (r_1_level > 0) then
		return
	end
	local splash_radius = CalculateFinalRadius(caster, CHERNOBOG_ARCANA1_R1_RADIUS, DOTA_R_SLOT)
	local atk_damage = OverflowProtectedGetAverageTrueAttackDamage(caster)
	local damage = atk_damage * r_1_level * CHERNOBOG_ARCANA1_R1_DMG_ATK_PCT / 100
	local enemies = SearchEnemies(caster, target, splash_radius)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ChernobogDealDamage(caster, enemy, damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_R, RPC_ELEMENT_DEMON, RPC_ELEMENT_NONE, false, true)
		end
	end
	if caster:HasModifier("modifier_demon_hunter") then
		CustomAbilities:QuickAttachParticle("particles/roshpit/chernobog/demon_form_splash_red.vpcf", target, 0.5)
	else
		CustomAbilities:QuickAttachParticle("particles/roshpit/chernobog/demon_form_splash.vpcf", target, 0.5)
	end
end

function modifier_chernobog_demon_form:ProcR2(caster, target)
	local r_2_level = caster:GetRuneValue("r", 2)
	if not (r_2_level > 0) then
		return
	end
	local chance_base = CHERNOBOG_ARCANA_R2_CHANCE_BASE
	local chance_inc =  CHERNOBOG_ARCANA_R2_CHANCE_INC * r_2_level
	if caster:HasModifier("modifier_chernobog_glyph_4_1") then
		chance_inc = chance_inc * (1 + CHERNOBOG_GLYPH_4_1_R2_AMP / 100)
	end
	local chance = chance_base + chance_inc
	if RandomInt(1, 100) < chance then
		if self.cd == false then
			if target == caster:GetAggroTarget() then
				Filters:PerformAttackSpecial(caster, target, true, true, true, false, true, false, false)
				self.cd = true
				Timers:CreateTimer(0.09, function()
					self.cd = false
				end)
			end
		end
	end
end

function modifier_chernobog_demon_form:OnDestroy()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	caster:RemoveModifierByName("modifier_chernobog_arcana_r2_aura")
	caster:RemoveModifierByName("modifier_chernobog_demon_form")
	CustomAbilities:QuickAttachParticle("particles/roshpit/chernobog/demonform_start_start_ti7_lvl2.vpcf", caster, 3)
	caster:SetModel("models/heroes/nightstalker/nightstalker.vmdl")
	caster:SetOriginalModel("models/heroes/nightstalker/nightstalker.vmdl")
	if caster:HasModifier("modifier_chernobog_arcana_e_passive") then
		if caster:GetAbilityByIndex(DOTA_E_SLOT):GetAbilityName() == "chernobog_demon_walk" then
			CustomAbilities:AddAndOrSwapSkill(caster, "chernobog_demon_walk", "chernobog_demon_flight", 2)
		end
	end
	caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
end

function modifier_chernobog_demon_form:GetModifierAttackRangeBonus(params)
    return 700
end

function modifier_chernobog_demon_form:GetModifierProjectileSpeedBonus(params)
    return 500
end

function modifier_chernobog_demon_form:GetModifierBaseAttackTimeConstant(params)
    return 0.9
end

function modifier_chernobog_demon_form:GetAttackSound(params)
    return "Chernobog.DemonForm.Attack"
end

function modifier_chernobog_demon_form:GetRoshpitMasterGreenDMG()
	return self:GetAbility():GetSpecialValueFor("attack_damage_percent")
end

--RUNE R3--

function modifier_chernobog_demon_form:OnAttackStart(event)
	if not IsServer() then 
		return
	end
	if event.attacker ~= self:GetCaster() or event.target == self:GetCaster() then
		return
	end
	local caster = self:GetCaster()
	local target = event.target
	local r_3_level = caster:GetRuneValue("r", 3)
	local ability = self:GetAbility()
	if r_3_level > 0 then
		local procs = Runes:Procs(r_3_level, CHERNOBOG_ARCANA1_R3_SPLIT_CHANCE, 1)
		local search_radius = CalculateFinalRadius(caster, 550, DOTA_R_SLOT)
		if not self.cd then
			local splitCount = 0
			if procs > 0 then
				local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, search_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
				if #enemies > 0 then
					for _, enemy in pairs(enemies) do
						if enemy:GetEntityIndex() == target:GetEntityIndex() then
						else
							if splitCount < procs then
								Filters:PerformAttackSpecial(caster, enemy, true, true, true, false, true, false, false)
								splitCount = splitCount + 1
							end
						end
					end
				end
			end
			self.cd = true
			Timers:CreateTimer(CHERNOBOG_ARCANA1_R3_SPLIT_CD, function()
				self.cd = false
			end)
		end
	end
end
	
function modifier_chernobog_arcana_r_passive:IsHidden()
	return true
end

function modifier_chernobog_arcana_r_passive:IsDebuff()
	return false
end

function modifier_chernobog_arcana_r_passive:RemoveOnDeath()
	return false
end

function modifier_chernobog_arcana_r_passive:OnCreated()
	if not IsServer() then
		return
	end
	self:SetSpecialTypes({
		MODIFIER_ROSHPIT_R_FLAT_CD_MOD,
		MODIFIER_ROSHPIT_R_FLAT_CHANNELTIME_MOD,
		RPC_ELEMENT_DEMON
		})
end

function modifier_chernobog_arcana_r_passive:DeclareFunctions()
	return {MODIFIER_PROPERTY_MODEL_SCALE}
end

function modifier_chernobog_arcana_r_passive:GetRoshpitRFlatCdModifier()
	return self:GetCaster():GetRuneValue("r", 4) * CHERNOBOG_ARCANA1_R4_R_CD_FLAT_REDUC
end

function modifier_chernobog_arcana_r_passive:GetRoshpitElementalDmgBonus()
	local str_and_agi = self:GetCaster():GetStrength() + self:GetCaster():GetAgility()
	return str_and_agi * self:GetCaster():GetRuneValue("r", 4) * CHERNOBOG_ARCANA1_R4_DEMON_AMP_PER_STR_AND_AGI / 100
end

function modifier_chernobog_arcana_r_passive:GetRoshpitRFlatChanneltimeModifier()
	local caster = self:GetCaster()
	return -math.min(1.5, caster:GetRuneValue("r", 4) * CHERNOBOG_ARCANA1_R4_CHANNEL_TIME_REDUC)
end

function modifier_chernobog_arcana_r_passive:GetModifierModelScale(params)
	if self:GetCaster():HasModifier("modifier_chernobog_demon_form") then
		return 50
	end
    return 0
end
