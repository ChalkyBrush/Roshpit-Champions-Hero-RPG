require('heroes/juggernaut/seinaru_constants')
require('heroes/base_ability')
require('heroes/juggernaut/seinaru_4_r')
require('heroes/juggernaut/seinaru_1_q_arcana')

seinaru_sunstrider = class(base_ability)

modifier_seinaru_arcana_e_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_seinaru_arcana_e_passive", "heroes/juggernaut/arcana/seinaru_sunstrider", LUA_MODIFIER_MOTION_NONE)

modifier_seinaru_sunstrider_dash = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_seinaru_sunstrider_dash", "heroes/juggernaut/arcana/seinaru_sunstrider", LUA_MODIFIER_MOTION_NONE)

modifier_seinaru_arcana_e1_effect = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_seinaru_arcana_e1_effect", "heroes/juggernaut/arcana/seinaru_sunstrider", LUA_MODIFIER_MOTION_NONE)

modifier_seinaru_arcana_e2_effect = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_seinaru_arcana_e2_effect", "heroes/juggernaut/arcana/seinaru_sunstrider", LUA_MODIFIER_MOTION_NONE)

modifier_seinaru_arcana_e4_effect = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_seinaru_arcana_e4_effect", "heroes/juggernaut/arcana/seinaru_sunstrider", LUA_MODIFIER_MOTION_NONE)

function seinaru_sunstrider:GetBehaviorBase()
    return DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT
end

function seinaru_sunstrider:GetAbilitySlot()
    return DOTA_E_SLOT
end

function seinaru_sunstrider:GetCastPoint()
    return 0
end

function seinaru_sunstrider:GetCooldownBase(level)
    return 5
end

function seinaru_sunstrider:GetManaCostBase(level)
    return 0
end

function seinaru_sunstrider:GetIntrinsicModifierName()
	return "modifier_seinaru_arcana_e_passive"
end

function seinaru_sunstrider:GetCastAnimation()
	return ACT_DOTA_ATTACK
end

function seinaru_sunstrider:GetCastRange()
	return self:GetSpecialValueFor("cast_range")
end

function seinaru_sunstrider:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self
	local point = ability:GetCastPosition()
	local target = WallPhysics:WallSearch(caster:GetAbsOrigin(), point, caster)
	local speed = WallPhysics:GetDistance(caster:GetAbsOrigin(), point) / 0.5
	local e_4_level = caster:GetRuneValue("e", 4)
	local e_4_chance = e_4_level * SEINARU_ARCANA2_E4_R_FREE_CAST_CHANCE + 10
	caster:AddNewModifier(caster, ability, "modifier_seinaru_sunstrider_dash", {duration = 0.5}):SetStackCount(speed)
	if e_4_level > 0 and e_4_chance > RandomInt(1, 100) then
	    caster:AddNewModifier(caster, ability, "modifier_seinaru_arcana_e4_effect", {})
	end
	ability:CreateTravelProjectile(point)
	EmitSoundOn("Seinaru.Sunstrider.Yell", caster)
	EmitSoundOnLocationWithCaster(target, "Seinaru.Sunstrider.Cast", caster)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Seinaru.Sunstrider.Launch", caster)
	ability.point = target
	Filters:CastSkillArguments(BASE_ABILITY_E, caster)
	if caster:HasModifier("modifier_seinaru_arcana_e_passive") then
		local stacks = caster:GetModifierStackCount("modifier_seinaru_arcana_e_passive", caster)
		if stacks > 0 then
			caster:FindModifierByName("modifier_seinaru_arcana_e_passive"):DecrementStackCount()
			ability:EndCooldown()
		end
	end
end

function seinaru_sunstrider:TriggerEffect(caster, ability, point)
    local e_1_level = caster:GetRuneValue("e", 1)
	local e_2_level = caster:GetRuneValue("e", 2)
    local radius = e_1_level * SEINARU_ARCANA_E1_E_RADIUS_BONUS + 300
	local targets_count = ability:GetSpecialValueFor("targets_count")
	local maxTargets = targets_count + math.ceil(SEINARU_ARCANA_E2_TARGETS * e_2_level)
	local targetsCounter = 0
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for i = 1, #enemies, 1 do
			if targetsCounter < maxTargets then
				targetsCounter = targetsCounter + 1
				Timers:CreateTimer((i - 1) * 0.03, function()
					local enemy = enemies[i]
					CustomAbilities:QuickAttachParticle("particles/roshpit/seinaru/sunblade.vpcf", enemy, 0.6)
					ability:Vengeance(caster, enemy)
					Timers:CreateTimer(0.2, function()
						CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_legion_commander/legion_commander_courage_hit.vpcf", enemy, 0.5)
						if caster:HasAbility("seinaru_blade_dash") then
							local eventTable = {}
							eventTable.caster = caster
							eventTable.target = enemy
							eventTable.ability = caster:FindAbilityByName("seinaru_blade_dash")
							arcana_attack_start(eventTable)
						end
						Filters:PerformAttackSpecial(caster, enemy, true, true, true, false, true, false, false)
					end)
					if caster:HasAbility("seinaru_gorudo") then
						Seinaru_Apply_E4(caster, enemy, caster:FindAbilityByName("seinaru_gorudo"))
					end
				end)
			end
		end
		if e_1_level > 0 then
		    caster:AddNewModifier(caster, ability, "modifier_seinaru_arcana_e1_effect", {duration = 3})
		end
	end
end

function seinaru_sunstrider:Vengeance(caster, target)
	local ability = self
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * ability:GetSpecialValueFor("att_to_dmg")
	local particleName = "particles/roshpit/seinaru/sunwarrior_vengeance_cowlofice.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
	local origin = target:GetAbsOrigin()
	ParticleManager:SetParticleControl(particle1, 0, origin + Vector(0, 0, 20))
	ParticleManager:SetParticleControl(particle1, 1, Vector(480, 2, 1000))
	ParticleManager:SetParticleControl(particle1, 3, Vector(480, 480, 480))
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
	EmitSoundOn("Seinaru.Sunstrider.Vengeance", target)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, caster:GetRuneValue("e", 1) * SEINARU_ARCANA_E1_E_RADIUS_BONUS + 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for i = 1, #enemies, 1 do
			local enemy = enemies[i]
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PURE, BASE_ABILITY_E, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
		end
	end
end

function seinaru_sunstrider:CreateTravelProjectile(point)
    local caster = self:GetCaster()
    local ability = self
	local range = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), point) * 0.95
	local speed = 3000--range / 0.5
	local casterOrigin = caster:GetAbsOrigin()
	local fv = ((point - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	local info =
	{
		Ability = ability,
		EffectName = "particles/roshpit/seinaru/sunstrider_movement.vpcf",
		vSpawnOrigin = caster:GetAbsOrigin(),
		fDistance = range,
		fStartRadius = 0,
		fEndRadius = 0,
		Source = caster,
		StartPosition = "attach_origin",
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 0.5,
		bDeleteOnHit = false,
		vVelocity = fv * speed,
		bProvidesVision = true,
		iVisionTeamNumber = caster:GetTeamNumber()

	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
end
-----------------
--- MODIFIERS ---
-----------------
function modifier_seinaru_sunstrider_dash:IsHidden()
	return true
end

function modifier_seinaru_sunstrider_dash:IsDebuff()
	return false
end

function modifier_seinaru_sunstrider_dash:OnCreated()	
	if not IsServer() then
		return
	end
	self:GetCaster():AddNoDraw()
	self:StartIntervalThink(0.05)
	self.proc = true
end

function modifier_seinaru_sunstrider_dash:OnIntervalThink()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local fv = (ability.point - caster:GetAbsOrigin()):Normalized()
	local position = GetGroundPosition(caster:GetAbsOrigin(), caster)
	local newPosition = position + fv * 150
	local obstruction = WallPhysics:FindNearestObstruction(newPosition)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition, caster)
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.point)
	if distance < 220 then
		if self.proc == true then
		    self.proc = false
	        self:GetAbility():TriggerEffect(caster, self:GetAbility(), caster:GetAbsOrigin())
		end
	elseif distance < 150 then
		caster:RemoveModifierByName("modifier_seinaru_sunstrider_dash")		
	end
	if not blockUnit then
		caster:SetOrigin(newPosition)
	end
end

function modifier_seinaru_sunstrider_dash:OnDestroy()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local e_1_level = caster:GetRuneValue("e", 1)
	local e_2_level = caster:GetRuneValue("e", 2)
	local e_1_duration = Filters:GetAdjustedBuffDuration(caster, 3, false)
	local e_2_duration = Filters:GetAdjustedBuffDuration(caster, SEINARU_ARCANA_E2_DUR * e_2_level, false)
	Timers:CreateTimer( 0.03, function()
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		caster:RemoveNoDraw()
	end)
	if not caster:HasModifier("modifier_seinaru_arcana_e1_effect") and e_1_level > 0 then
		caster:AddNewModifier(caster, ability, "modifier_seinaru_arcana_e1_effect", {duration = e_1_duration})
	end
	if e_2_level > 0 then
		caster:AddNewModifier(caster, ability, "modifier_seinaru_arcana_e2_effect", {duration = e_2_duration})
	end
end

function modifier_seinaru_arcana_e_passive:IsHidden()
    if self:GetStackCount() > 0 then
	    return false
	end
	return true
end

function modifier_seinaru_arcana_e_passive:IsDebuff()
	return false
end

function modifier_seinaru_arcana_e_passive:OnCreated()
	if not IsServer() then
		return
	end
	self:SetSpecialTypes({
	    RPC_ELEMENT_HOLY,
		MODIFIER_ROSHPIT_Q_BASE_ABILITY_DMG_BONUS,
        MODIFIER_ROSHPIT_W_BASE_ABILITY_DMG_BONUS,
        MODIFIER_ROSHPIT_E_BASE_ABILITY_DMG_BONUS,
        MODIFIER_ROSHPIT_R_BASE_ABILITY_DMG_BONUS,
	})
	self:StartIntervalThink(1.5)
end

function modifier_seinaru_arcana_e_passive:GetRoshpitQBaseAbilityDmgBonus()
    return self:GetCaster():GetRuneValue("e", 3) * SEINARU_ARCANA2_E3_BAD / 100
end

function modifier_seinaru_arcana_e_passive:GetRoshpitWBaseAbilityDmgBonus()
    return self:GetCaster():GetRuneValue("e", 3) * SEINARU_ARCANA2_E3_BAD / 100
end

function modifier_seinaru_arcana_e_passive:GetRoshpitEBaseAbilityDmgBonus()
    return self:GetCaster():GetRuneValue("e", 3) * SEINARU_ARCANA2_E3_BAD / 100
end

function modifier_seinaru_arcana_e_passive:GetRoshpitRBaseAbilityDmgBonus()
    return self:GetCaster():GetRuneValue("e", 3) * SEINARU_ARCANA2_E3_BAD / 100
end

function modifier_seinaru_arcana_e_passive:GetRoshpitElementalDmgBonus()
	return self:GetCaster():GetRuneValue("e", 4) * SEINARU_ARCANA2_E4_HOLY_AMP_PER_AGI / 100 * self:GetCaster():GetAgility()
end

function modifier_seinaru_arcana_e_passive:OnIntervalThink()
	if not IsServer() then
		return
	end
	local ability = self:GetAbility()
	local max_stacks = ability:GetSpecialValueFor("max_stacks")
	self:SetStackCount(math.min(self:GetStackCount() + 1, max_stacks))
end

----------
--- E1 ---
----------
function modifier_seinaru_arcana_e1_effect:IsDebuff()
	return false
end

function modifier_seinaru_arcana_e1_effect:IsHidden()
	return false
end

function modifier_seinaru_arcana_e1_effect:GetTexture()
	return "seinaru/seinaru_rune_e_1_arcana2"
end

function modifier_seinaru_arcana_e1_effect:OnCreated()
	if not IsServer() then
		return
	end
	self:SetSpecialTypes({MODIFIER_ROSHPIT_MASTER_GREEN_DMG})
end

function modifier_seinaru_arcana_e1_effect:GetRoshpitMasterGreenDMG()
	return self:GetCaster():GetRuneValue("e", 1) * SEINARU_ARCANA_E1_ATT_PCT
end

----------
--- E2 ---
----------
function modifier_seinaru_arcana_e2_effect:IsDebuff()
	return false
end

function modifier_seinaru_arcana_e2_effect:IsHidden()
	return false
end

function modifier_seinaru_arcana_e2_effect:GetTexture()
	return "seinaru/seinaru_rune_e_2_arcana2"
end

function modifier_seinaru_arcana_e2_effect:GetEffectName()
	return "particles/roshpit/seinaru/lightsword_omni.vpcf"
end

function modifier_seinaru_arcana_e2_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_seinaru_arcana_e2_effect:OnCreated()
	if not IsServer() then
		return
	end
	self:SetSpecialTypes({MODIFIER_ROSHPIT_PHYSICAL_DMG_REDUCTION})
end

function modifier_seinaru_arcana_e2_effect:GetPhysicalDamageReduction()
    return 0.75
end

----------
--- E4 ---
----------
function modifier_seinaru_arcana_e4_effect:IsHidden()
    return false
end

function modifier_seinaru_arcana_e4_effect:IsDebuff()
    return false
end

function modifier_seinaru_arcana_e4_effect:GetTexture()
    return "seinaru/seinaru_rune_e_4_arcana2"
end

function modifier_seinaru_arcana_e4_effect:OnCreated()
    if not IsServer() then
	    return
	end
    self:SetSpecialTypes({
	    MODIFIER_SPECIAL_TYPE_CAST_R_ABILITY,
	})	
end

function modifier_seinaru_arcana_e4_effect:OnCastRAbility()
    self:Destroy()
end

