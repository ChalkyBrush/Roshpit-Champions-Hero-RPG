require('heroes/nightstalker/util')

chernobog_charons_claw = class(base_ability)

modifier_charons_claw_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_charons_claw_passive", "heroes/nightstalker/ability_scripts/chernobog_charons_claw.lua", LUA_MODIFIER_MOTION_NONE)

modifier_charons_claw_path_aura_base = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_charons_claw_path_aura_base", "heroes/nightstalker/ability_scripts/chernobog_charons_claw.lua", LUA_MODIFIER_MOTION_NONE)

modifier_charons_claw_on_path = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_charons_claw_on_path", "heroes/nightstalker/ability_scripts/chernobog_charons_claw.lua", LUA_MODIFIER_MOTION_NONE)

modifier_charons_claw_debuff = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_charons_claw_debuff", "heroes/nightstalker/ability_scripts/chernobog_charons_claw.lua", LUA_MODIFIER_MOTION_NONE)

----------------
--ABILITY BASE--
----------------
function chernobog_charons_claw:GetManaCostBase(level)
    return 0
end

function chernobog_charons_claw:GetClawPathDuration()
	return 3
end

function chernobog_charons_claw:GetBehaviorBase()
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_OPTIONAL_UNIT_TARGET
end

function chernobog_charons_claw:GetCastAnimation()
	return ACT_DOTA_ATTACK
end

function chernobog_charons_claw:GetAbilitySlot()
    return DOTA_Q_SLOT
end

function chernobog_charons_claw:GetCastPoint()
    return 0.35
end

function chernobog_charons_claw:GetCastRange()
    return self:GetSpecialValueFor("range")
end

function chernobog_charons_claw:GetCooldownBase(level)
	return CHERNOBOG_Q_CD
end

function chernobog_charons_claw:GetWidth()
	local width = CalculateFinalRadius(self:GetCaster(), 160, DOTA_Q_SLOT)
	return width
end

function chernobog_charons_claw:GetIntrinsicModifierName()
	return "modifier_charons_claw_passive"
end

function chernobog_charons_claw:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	EmitSoundOn("Chernobog.CharonsPreCast", caster)
	StartAnimation(caster, {duration = 1.2, activity = ACT_DOTA_ATTACK, rate = 1})
	return true
end

function chernobog_charons_claw:InitValues()
    local ability = self
	local caster = self:GetCaster()	
	ability.damage = ability:GetSpecialValueFor('damage')
	ability.range = ability:GetSpecialValueFor('range')
	if caster:GetRuneValue("q", 4) > 0 then
		ability.range = ability.range + caster:GetRuneValue("q", 4) * CHERNOBOG_Q4_RANGE
	end
	ability.width = self:GetWidth()
end

function chernobog_charons_claw:OnSpellStart()
    local ability = self
	local caster = self:GetCaster()
    local target = self:GetCastPosition()
	self:InitValues()

	if not ability.claw_table then
		ability.claw_table = {}
	end
	if not ability.projectile_id then
		ability.projectile_id = 0
	else
		if ability.projectile_id > 1000 then
			ability.projectile_id = 0
		end
		ability.projectile_id = ability.projectile_id + 1
	end

	local speed = 800
	local fv = ((target - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()

	local new_claw = {}
	local casterOrigin = caster:GetAbsOrigin()
	new_claw.projectile_id = ability.projectile_id
	new_claw.startPosition = casterOrigin - fv * 80
	new_claw.targetPosition = new_claw.startPosition + fv*ability.range
	new_claw.destroy_time = GameRules:GetGameTime() + self:GetClawPathDuration()
	new_claw.interval = 0
	new_claw.thinker_table = {}
	

	EmitSoundOn("Chernobog.CharonsClaw", caster)

	local projectileParticle = "particles/roshpit/chernobog/charons_clawpectral_dagger.vpcf"
	local info =
	{
		Ability = ability,
		EffectName = projectileParticle,
		vSpawnOrigin = new_claw.startPosition,
		fDistance = ability.range,
		fStartRadius = ability.width,
		fEndRadius = ability.width,
		Source = caster,
		StartPosition = "attach_origin",
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + self:GetClawPathDuration(),
		bDeleteOnHit = false,
		vVelocity = fv * speed,
		bProvidesVision = true,
		iVisionRadius = 500,
		iVisionTeamNumber = caster:GetTeamNumber(),
		ExtraData = {projectileID = new_claw.projectile_id}
	}
	local projectile = Filters:LinearProjectile(info)
	new_claw.projectile = projectile
	table.insert(ability.claw_table, new_claw)

	Filters:CastSkillArguments(BASE_ABILITY_Q, caster)
end

function chernobog_charons_claw:GetClawObjectFromProjectileID(projectile_id)
	local ability = self
	local projectile = nil
	for key, claw in pairs(ability.claw_table) do
		if claw.projectile_id == projectile_id then
			projectile = claw
			break
		end
	end
	return projectile
end

function chernobog_charons_claw:OnProjectileThink_ExtraData(vLoc, extraData)
	local caster = self:GetCaster()
	local ability = self
	local claw = self:GetClawObjectFromProjectileID(extraData.projectileID)
	claw.interval = claw.interval + 1
	if claw.interval%4 == 0 then
		self:CreateClawThinker(claw, vLoc)
		AddFOWViewer(caster:GetTeamNumber(), vLoc, 400, 3, false)
	end
end

function chernobog_charons_claw:CreateClawThinker(claw, vLoc)
	local caster = self:GetCaster()
	local thinkerPos = vLoc
	local thinker_object = CreateUnitByName("npc_dummy_unit", vLoc, true, caster, caster, caster:GetTeamNumber())
    thinker_object:FindAbilityByName("dummy_unit"):SetLevel(1)
    thinker_object.particle = ParticleManager:CreateParticle("particles/roshpit/chernobog/charon_ground.vpcf", PATTACH_WORLDORIGIN, nil)
    thinker_object:AddNewModifier(caster, self, "modifier_charons_claw_path_aura_base", {})
    --ParticleManager:SetParticleControlEnt(self.particle, 0, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(thinker_object.particle, 0, vLoc)
    ParticleManager:SetParticleControl(thinker_object.particle, 1, Vector(self.width, 1, 1))
    ParticleManager:SetParticleControl(thinker_object.particle, 15, Vector(255, 255, 255))
    ParticleManager:SetParticleControl(thinker_object.particle, 16, Vector(1, 0, 0))
	table.insert(claw.thinker_table, thinker_object)
end

function chernobog_charons_claw:OnProjectileHit_ExtraData(target, vLocation, extraData)
	local caster = self:GetCaster()
	local ability = self
	local R_ability = caster:GetAbilityByIndex(DOTA_R_SLOT)	
	if target then
		EmitSoundOn("Chernobog.CharonsClawImpact", target)
		self:DealDamage(target, true)
		target:AddNewModifier(caster, self, "modifier_charons_claw_debuff", {})
		if R_ability then
			if caster:HasModifier("modifier_chernobog_glyph_3_1") then
				local cdRemaining = R_ability:GetCooldownTimeRemaining()
				if cdRemaining > 0 then
				local newCD = math.max(0, cdRemaining - CHERNOBOG_GLYPH_3_1_CD_DEC)
				R_ability:EndCooldown()
				R_ability:StartCooldown(newCD)
				end
			end
		end
	end
end

function chernobog_charons_claw:DealDamage(hTarget, bInitHit)
	if not hTarget then
		return
	end
	local caster = self:GetCaster()
	local target = hTarget
	local damage = self:GetSpecialValueFor("damage")
	local q_2_level = caster:GetRuneValue("q", 2)
	local dotScale = (CHERNOBOG_Q_DOT_PERC + CHERNOBOG_Q3_Q_DOT_PERC_INC * caster:GetRuneValue("q", 3)) / 100
	if q_2_level > 0 then
		damage = damage + q_2_level * CHERNOBOG_Q2_DMG_PER_AGI_AND_STR * (caster:GetStrength() + caster:GetAgility()) / 100
	end
	if bInitHit == true	then
		ChernobogDealDamage(caster, target, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_Q, RPC_ELEMENT_DEMON, RPC_ELEMENT_SHADOW, false, false)
	else
		damage = damage * dotScale
		ChernobogDealDamage(caster, target, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_Q, RPC_ELEMENT_DEMON, RPC_ELEMENT_SHADOW, true, false)
	end
end

function chernobog_charons_claw:ReindexClawTable()
	local ability = self
	if ability.claw_table then
		local new_claw_table = {}
		for i = 1, #ability.claw_table, 1 do
			local claw = ability.claw_table[i]
			if claw.destroy_time <= GameRules:GetGameTime() then
				self:DestroyClaw(claw)
				claw = nil
			else
				table.insert(new_claw_table, claw)
			end
		end
		ability.claw_table = new_claw_table
	end
end

function chernobog_charons_claw:DestroyClaw(claw)
	for i = 1, #claw.thinker_table, 1 do
		local sub_claw = claw.thinker_table[i]
		ParticleManager:DestroyParticle(sub_claw.particle, true)
		UTIL_Remove(sub_claw)
	end
end

-- CHARONS CLAW PASSIVE

function modifier_charons_claw_passive:IsHidden()
	return true
end

function modifier_charons_claw_passive:RemoveOnDeath()
	return false
end

function modifier_charons_claw_passive:OnCreated()
	if not IsServer() then
		return false
	end
	self:SetSpecialTypes({MODIFIER_ROSHPIT_Q_FLAT_CD_MOD})
	self:StartIntervalThink(0.2)
end

function modifier_charons_claw_passive:OnIntervalThink()
	if not IsServer() then
		return false
	end
	self:GetAbility():ReindexClawTable()
end

function modifier_charons_claw_passive:GetRoshpitQFlatCdModifier()
	return -math.min(self:GetCaster():GetRuneValue("q", 4) * CHERNOBOG_Q4_Q_CD_REDUC, CHERNOBOG_Q_CD - 0.5)
end
-- PATH AURA

function modifier_charons_claw_path_aura_base:IsHidden()
	return true
end

function modifier_charons_claw_path_aura_base:IsAura()
    return true
end

function modifier_charons_claw_path_aura_base:IsAuraActiveOnDeath()
    return false
end

function modifier_charons_claw_path_aura_base:GetAuraRadius()
    return self:GetAbility():GetWidth()
end

function modifier_charons_claw_path_aura_base:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY + DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_charons_claw_path_aura_base:GetAuraSearchType()
    return (DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC)
end

function modifier_charons_claw_path_aura_base:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_charons_claw_path_aura_base:RemoveOnDeath()
    return false
end

function modifier_charons_claw_path_aura_base:GetModifierAura()
    return "modifier_charons_claw_on_path"
end

-- ON CLAW EFFECT

function modifier_charons_claw_on_path:IsDebuff()
	if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		return false
	else
		return true
	end
end

function modifier_charons_claw_on_path:OnCreated()
	local ability = self:GetAbility()
	if not IsServer() then
		return false
	end
	if ability:GetCaster() == self:GetParent() then
		ability.allow_terrain_traverse = true
		self:StartIntervalThink(0.03)
	elseif self:GetParent():GetTeamNumber() ~= ability:GetCaster():GetTeamNumber() then
		self:StartIntervalThink(0.5)
	end
end

function modifier_charons_claw_on_path:CheckState()
	local ability = self:GetAbility()
	if not IsServer() then
		return false
	end
	local state = {}
	if ability:GetCaster() == self:GetParent() then
		state = {
			[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = ability.allow_terrain_traverse,
		}
	end
	return state
end

function modifier_charons_claw_on_path:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
	}
end

function modifier_charons_claw_on_path:GetModifierBaseDamageOutgoing_Percentage()
	if self:IsDebuff() then 
		return self:GetAbility():GetSpecialValueFor("move_and_attack_slow")
	end
end

function modifier_charons_claw_on_path:GetModifierMoveSpeedBonus_Percentage(params)
	if self:IsDebuff() then
		return self:GetAbility():GetSpecialValueFor("move_and_attack_slow")
	else
		return self:GetAbility():GetSpecialValueFor("move_speed_increase")
	end
end

function modifier_charons_claw_on_path:OnIntervalThink()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local ability = self:GetAbility()
	if caster:GetTeamNumber() == parent:GetTeamNumber() then
	    if (ability.allow_terrain_traverse) and (caster == parent) then
	        local newPos = caster:GetAbsOrigin() + caster:GetForwardVector() * 62
	        local obstruction = WallPhysics:FindNearestObstruction(caster:GetAbsOrigin() * Vector(1, 1, 0))
	        local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPos * Vector(1, 1, 0), caster)
	        if blockUnit then
	            caster:SetAbsOrigin(caster:GetAbsOrigin() - caster:GetForwardVector() * 60)
	            WallPhysics:ClearSpaceForUnit(caster, caster:GetAbsOrigin())
	            ability.allow_terrain_traverse = false
	        end
	    end
	else
		if not parent:HasModifier("modifier_charons_claw_debuff") then
			parent:AddNewModifier(caster, ability,"modifier_charons_claw_debuff", {})
		end
	end
end

function modifier_charons_claw_on_path:OnDestroy()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local q_buff_duration = Filters:GetAdjustedBuffDuration(caster, CHERNOBOG_Q_LINGER_DURATION, false)
	if (caster:GetTeamNumber() ~= parent:GetTeamNumber()) then
		if parent:HasModifier("modifier_charons_claw_debuff") then
			parent:FindModifierByName("modifier_charons_claw_debuff"):SetDuration(q_buff_duration, true)
		end
	end
end

function modifier_charons_claw_debuff:IsHidden()
	return false
end

function modifier_charons_claw_debuff:IsDebuff()
	return true
end

function modifier_charons_claw_debuff:OnCreated()
	if not IsServer() then
		return
	end
	self:OnIntervalThink()
end

function modifier_charons_claw_debuff:DeclareFunctions()
	return {MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
			MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_charons_claw_debuff:OnIntervalThink()
	if not IsServer() then
		return
	end
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local q_4_level = caster:GetRuneValue("q", 4)
	local interval = CalculateFinalRate(caster, CHERNOBOG_Q_TICK_INTERVAL, DOTA_Q_SLOT)
	local radius = CalculateFinalRadius(caster, CHERNOBOG_GLYPH_2_2_Q_RADIUS, DOTA_Q_SLOT)
	if caster:HasModifier("modifier_chernobog_glyph_2_2") then
		local enemies = SearchEnemies(caster, parent, radius, false)			
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				ability:DealDamage(enemy, false)
				CustomAbilities:QuickAttachParticle("particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void_hit_body_flash.vpcf", enemy, 0.5)
			end
		end
	else
		ability:DealDamage(parent, false)
		CustomAbilities:QuickAttachParticle("particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void_hit_body_flash.vpcf", parent, 0.5)
	end
	self:StartIntervalThink(interval)	
end

function modifier_charons_claw_debuff:GetModifierBaseDamageOutgoing_Percentage()
	if self:GetCaster():HasModifier("modifier_chernobog_glyph_4_2") then
		return self:GetAbility():GetSpecialValueFor("move_and_attack_slow")
	end
	return 0
end

function modifier_charons_claw_debuff:GetModifierMoveSpeedBonus_Percentage()
	if self:GetCaster():HasModifier("modifier_chernobog_glyph_4_2") then
		return self:GetAbility():GetSpecialValueFor("move_and_attack_slow")
	end
	return 0
end
