require('heroes/nightstalker/util')

chernobog_charons_claw = class(base_ability)

modifier_charons_claw_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_charons_claw_passive", "heroes/nightstalker/ability_scripts/chernobog_charons_claw.lua", LUA_MODIFIER_MOTION_NONE)

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
    return 0.25
end

function chernobog_charons_claw:GetCastRange()
    return self:GetSpecialValueFor("range")
end

function chernobog_charons_claw:GetCooldownBase(level)
	return CHERNOBOG_Q_CD
end

function chernobog_charons_claw:GetWidth()
	return CalculateFinalRadius(self:GetCaster(), 160, DOTA_Q_SLOT)
end

function chernobog_charons_claw:GetLength()
	return self:GetSpecialValueFor('range') + self:GetCaster():GetRuneValue("q", 4) * CHERNOBOG_Q4_RANGE
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
	ability.range = ability:GetLength()
	ability.width = self:GetWidth()
end

function chernobog_charons_claw:OnSpellStart()
	self:InitValues()
	local target = self:GetCastPosition()
    local ability = self
	local caster = self:GetCaster()
	local speed = ability.range * 1.5
	local fv = ((target - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	local startPosition = caster:GetAbsOrigin() - fv * 80
	EmitSoundOn("Chernobog.CharonsClaw", caster)
	local end_time = ability.range / speed
	local thinkers = math.floor(ability.range / 100) - 2
	local thinker_create_interval = end_time / thinkers
	for i = 1, thinkers, 1 do
		Timers:CreateTimer(i * thinker_create_interval, function()
			local thinkerPos = GetGroundPosition(caster:GetAbsOrigin() + fv * 100 * (i - 1) + fv * 80, caster)
			ability:CreateThinkerParticle(thinkerPos, i * thinker_create_interval)
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), thinkerPos, nil, ability:GetWidth(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL,  DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			if #enemies > 0 then
			    for _, enemy in pairs(enemies) do
				    EmitSoundOn("Chernobog.CharonsClawImpact", enemy)
				    ability:DealDamage(enemy, true)
				    ApplyModifier(caster, enemy, ability, "modifier_charons_claw_debuff", 6, nil) 
				end
			end
			if i == (thinkers - 2) then
				AddFOWViewer(caster:GetTeamNumber(), thinkerPos + fv * 200, 400, 3, false)
			end
		end)
	end
	ability:StartClawThink(caster, startPosition, target, ability.width)
	Filters:CastSkillArguments(BASE_ABILITY_Q, caster)
end

function chernobog_charons_claw:StartClawThink(caster, start_point, end_point, width)
    local ability = self
	local duration = ability:GetClawPathDuration()
	local interval = 0.2
	local loops = math.floor(duration / interval)
	for i = 1, loops, 1 do
	    Timers:CreateTimer( i * interval, function()
		    local units = FindUnitsInLine(caster:GetTeamNumber(), start_point, end_point, caster, width, DOTA_UNIT_TARGET_TEAM_BOTH,  DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
		    if #units > 0 then
			    for _, unit in pairs(units) do
			        unit:AddNewModifier(caster, ability, "modifier_charons_claw_on_path", {duration = 3})
			    end
		    end
	    end)
    end
end

function chernobog_charons_claw:CreateThinkerParticle(vLoc, destroy_interval)
	local caster = self:GetCaster()
	local width = self.width
	local pfx = ParticleManager:CreateParticle("particles/roshpit/chernobog/charon_ground.vpcf", PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(pfx, 0, vLoc)
    ParticleManager:SetParticleControl(pfx, 1, Vector(width, 1, 1))
    ParticleManager:SetParticleControl(pfx, 15, Vector(255, 255, 255))
    ParticleManager:SetParticleControl(pfx, 16, Vector(1, 0, 0))
    Timers:CreateTimer(self:GetClawPathDuration() + destroy_interval * 2, function()
        ParticleManager:DestroyParticle(pfx, true)
	end)
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
end

function modifier_charons_claw_passive:GetRoshpitQFlatCdModifier()
	return -1 * self:GetCaster():GetRuneValue("q", 4) * CHERNOBOG_Q4_Q_CD_REDUC
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
	if not (self:IsDebuff() == true) then
		ability.allow_terrain_traverse = true
		self:StartIntervalThink(0.03)
	else
		self:StartIntervalThink(0.5)
	end
end

function modifier_charons_claw_on_path:CheckState()
	local ability = self:GetAbility()
	if not IsServer() then
		return false
	end
	local state = {}
	if not (self:IsDebuff() == true) then
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
	if not (self:IsDebuff() == true) then
	    if ability.allow_terrain_traverse then
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
			parent:AddNewModifier(caster, ability,"modifier_charons_claw_debuff", {duration = 6})
		end
	end
end

function modifier_charons_claw_on_path:OnDestroy()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local q_buff_duration = 6
	if self:IsDebuff() == true then
		if parent:HasModifier("modifier_charons_claw_debuff") then
			parent:FindModifierByName("modifier_charons_claw_debuff"):SetDuration(q_buff_duration, true)
		else
		    parent:AddNewModifier(caster, ability,"modifier_charons_claw_debuff", {duration = q_buff_duration})
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
			    if enemy:IsAlive() then
				   ability:DealDamage(enemy, false)
				   CustomAbilities:QuickAttachParticle("particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void_hit_body_flash.vpcf", enemy, 0.5)
				end
			end
		end
	else
	    if parent:IsAlive() then
		    ability:DealDamage(parent, false)
		    CustomAbilities:QuickAttachParticle("particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void_hit_body_flash.vpcf", parent, 0.5)
		end
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
