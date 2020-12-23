require('heroes/nightstalker/chernobog_constants')
require('heroes/base_ability')
require("heroes/util/channeling")

chernobog_demon_morph = class(base_ability)

modifier_chernobog_demon_form = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_demon_form", "heroes/nightstalker/arcana/chernobog_demon_morph.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_arcana_r_channel_end = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_arcana_r_channel_end", "heroes/nightstalker/arcana/chernobog_demon_morph.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_arcana_r2 = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_arcana_r2", "heroes/nightstalker/arcana/chernobog_demon_morph.lua", LUA_MODIFIER_MOTION_NONE)

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
    return 1
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
    return 35
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

	caster:AddNoDraw()
	caster:AddNewModifier(caster, ability, "modifier_chernobog_arcana_r_channel_end", {duration = 2.0})
	local duration = ability:GetDuration() + caster:GetRuneValue("r", 4) * CHERNOBOG_ARCANA1_R4_BONUS_DUR
	local morphDuration = Filters:GetAdjustedBuffDuration(caster, duration, false)
	local r_2_level = caster:GetRuneValue("r", 2)
	Timers:CreateTimer(2.0, function()
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
		if r_2_level > 0 then
			caster:AddNewModifier(caster, ability, "modifier_chernobog_arcana_r2", { duration = morphDuration })
		end
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
	if caster:HasModifier("modifier_demon_hunter") then
		caster:SetRangedProjectileName("particles/units/heroes/hero_nevermore/nevermore_base_attack.vpcf")
	else
		caster:SetRangedProjectileName("particles/roshpit/chernobog/demon_form_attack.vpcf")
	end
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
	self:SetSpecialTypes({
		RPC_ELEMNT_DEMON,
		MODIFIER_ROSHPIT_MASTER_GREEN_DMG
	})
end

function modifier_chernobog_demon_form:OnAttackLanded(event)
	if not IsServer() then
		return
	end
	if event.target == self:GetParent() or event.attacker ~= self:GetParent() then
		return 
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local target = event.target
	local atk_damage = OverflowProtectedGetAverageTrueAttackDamage(caster)
	local r_1_level = caster:GetRuneValue("r", 1)
	local damage = 0
	if r_1_level > 0 then
		damage = damage + atk_damage * r_1_level * CHERNOBOG_ARCANA1_R1_DMG_ATK_PCT / 100
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, CHERNOBOG_ARCANA1_R1_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				if IsValidEntity(enemy) then
					Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PURE, BASE_ABILITY_R, RPC_ELEMENT_DEMON, RPC_ELEMENT_NONE)
				end
			end
		end
		if caster:HasModifier("modifier_demon_hunter") then
			CustomAbilities:QuickAttachParticle("particles/roshpit/chernobog/demon_form_splash_red.vpcf", target, 0.5)
		else
			CustomAbilities:QuickAttachParticle("particles/roshpit/chernobog/demon_form_splash.vpcf", target, 0.5)
		end
	end
end

function modifier_chernobog_demon_form:OnDestroy()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	caster:RemoveModifierByName("modifier_chernobog_arcana_r2")
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

function modifier_chernobog_demon_form:GetRoshpitElementalDmgBonus()
	local r_4_level = self:GetCaster():GetRuneValue("r", 4)
	local bonus = 0
	if r_4_level > 0 then
		bonus = r_4_level * CHERNOBOG_ARCANA1_R4_DEMON_AMP
	end
	return bonus
end
	
function modifier_chernobog_demon_form:GetModifierModelScale(params)
    return 50
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
	
	
	
	
	
	
	
	
	





















