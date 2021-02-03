require('heroes/nightstalker/util')

chernobog_shadow_hunt = class(base_ability)

modifier_shadow_hunt = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_shadow_hunt", "heroes/nightstalker/ability_scripts/chernobog_shadow_hunt.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_e_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_e_passive", "heroes/nightstalker/ability_scripts/chernobog_shadow_hunt.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_e1_buff = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_e1_buff", "heroes/nightstalker/ability_scripts/chernobog_shadow_hunt.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_e2_thinker = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_e2_thinker", "heroes/nightstalker/ability_scripts/chernobog_shadow_hunt.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_e2_effect = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_e2_effect", "heroes/nightstalker/ability_scripts/chernobog_shadow_hunt.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_e3_thinker = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_e3_thinker", "heroes/nightstalker/ability_scripts/chernobog_shadow_hunt.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_e3_effect = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_e3_effect", "heroes/nightstalker/ability_scripts/chernobog_shadow_hunt.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_e3_cd = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_e3_cd", "heroes/nightstalker/ability_scripts/chernobog_shadow_hunt.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_e4_buff = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_e4_buff", "heroes/nightstalker/ability_scripts/chernobog_shadow_hunt.lua", LUA_MODIFIER_MOTION_NONE)

function chernobog_shadow_hunt:GetBehaviorBase()
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_TOGGLE + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL + DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT + DOTA_ABILITY_BEHAVIOR_AOE
end

function chernobog_shadow_hunt:GetAbilitySlot()
	return DOTA_E_SLOT
end

function chernobog_shadow_hunt:GetCastPoint()
	return 0
end

function chernobog_shadow_hunt:GetManaCostBase(level)
	return 0
end

function chernobog_shadow_hunt:GetCooldownBase(level)
    if level == -1 then
        level = self:GetLevel() - 1
    end
    return CHERNOBOG_E_COOLDOWN[level + 1]
end

function chernobog_shadow_hunt:GetIntrinsicModifierName()
	return "modifier_chernobog_e_passive"
end

function chernobog_shadow_hunt:GetAbilityTextureName()
	return 'night_stalker_hunter_in_the_night'
end

function chernobog_shadow_hunt:OnToggle()
	local caster = self:GetCaster()
	local ability = self
	if self:GetToggleState() == true then
		caster:AddNewModifier(caster, ability, "modifier_shadow_hunt", {})
	else
		if caster:HasModifier("modifier_shadow_hunt") then
			caster:RemoveModifierByName("modifier_shadow_hunt")
		end
	end
end

--modifiers

function modifier_shadow_hunt:IsHidden()
	return false
end

function modifier_shadow_hunt:IsDebuff()
	return false
end

function modifier_shadow_hunt:OnCreated()
	if not IsServer() then
		return
	end
	self:OnIntervalThink()
	self:StartIntervalThink(CHERNOBOG_E_DRAIN_INTERVAL)
end

function modifier_shadow_hunt:OnIntervalThink()
    if not IsServer() then
		return
	end
    local caster = self:GetCaster()
	local ability = self:GetAbility()
    local currentHealth = caster:GetHealth()
    local currentMana = caster:GetMana()
    local minHealth = 1
    local minMana = 0
	local hp_drain = CHERNOBOG_E_HP_DRAIN[self:GetAbility():GetLevel()]
	local mp_drain = CHERNOBOG_E_MP_DRAIN[self:GetAbility():GetLevel()]

	if currentHealth > minHealth then
       caster:SetHealth(math.max(currentHealth - currentHealth * CHERNOBOG_E_DRAIN_INTERVAL * hp_drain / 100, minHealth))
    end
    if currentMana > minMana then
       caster:ReduceMana(math.min(currentMana * CHERNOBOG_E_DRAIN_INTERVAL * mp_drain / 100, currentMana - minMana))
    end
	if caster:HasModifier("modifier_chernobog_glyph_1_1") then
		local search_radius = CHERNOBOG_E3_RANGE_BASE + CHERNOBOG_E3_RANGE * rune_level + 500
		local enemies = SearchEnemies(caster, caster, search_radius)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				AddFOWViewer(caster:GetTeamNumber(), enemy:GetAbsOrigin(), 600, 2.4, false)
			end
		end
	end
end

function modifier_shadow_hunt:OnRemoved()
    if not IsServer() then
		return
	end
    local caster = self:GetCaster()
    local ability = self:GetAbility()
    local e_4_level = caster:GetRuneValue("e", 4)
	local duration = CHERNOBOG_E4_BASE_DUR + CHERNOBOG_E4_DUR * e_4_level
    if e_4_level > 0 then
		ApplyModifier(caster, caster, ability, "modifier_chernobog_e4_buff", duration, e_4_level)
    end
end

function modifier_shadow_hunt:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS 
    }
end

function modifier_shadow_hunt:GetModifierMoveSpeed_Max_Increase(params)
    return self:GetAbility():GetSpecialValueFor("movespeed_cap")
end

function modifier_shadow_hunt:GetModifierMoveSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("movespeed_bonus")
end

function modifier_shadow_hunt:GetActivityTranslationModifiers()
    return "haste"
end

function modifier_shadow_hunt:GetTexture()
	return 'night_stalker_hunter_in_the_night'
end

--passive thinker

function modifier_chernobog_e_passive:IsHidden()
	return true
end

function modifier_chernobog_e_passive:IsDebuff()
	return false
end

function modifier_chernobog_e_passive:IsPurgable()
	return false
end

function modifier_chernobog_e_passive:RemoveOnDeath()
	return false
end

function modifier_chernobog_e_passive:OnCreated()
	if not IsServer() then
		return
	end
	self:OnIntervalThink()
	self:StartIntervalThink(0.2)
end

function modifier_chernobog_e_passive:OnIntervalThink()
	if not IsServer() then
		return
	end
	ModifierThink(self:GetCaster(), self:GetAbility(), DOTA_E_SLOT, "e", true, false)
end

--runes
----------
--- E1 ---
----------
function modifier_chernobog_e1_buff:IsHidden()
	return false
end

function modifier_chernobog_e1_buff:IsDebuff()
	return false
end

function modifier_chernobog_e1_buff:GetTexture()
	return	"chernobog/chernobog_rune_e_1"
end

function modifier_chernobog_e1_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_MAX
	}
end

function modifier_chernobog_e1_buff:OnCreated()	
	if not IsServer() then
		return
	end
	self:SetSpecialTypes({
		MODIFIER_ROSHPIT_MASTER_GREEN_DMG
	})
end

function modifier_chernobog_e1_buff:GetRoshpitMasterGreenDMG()
	return self:GetStackCount() * CHERNOBOG_E1_ATK_PCT
end

function modifier_chernobog_e1_buff:GetModifierMoveSpeedBonus_Constant()
	return self:GetStackCount() * CHERNOBOG_E1_MOVESPEED
end

function modifier_chernobog_e1_buff:GetModifierMoveSpeed_Max_Increase()
	return self:GetStackCount() * CHERNOBOG_E1_MOVESPEED
end

----------
--- E2 ---
----------
function modifier_chernobog_e2_thinker:IsHidden()
	return true
end

function modifier_chernobog_e2_thinker:IsDebuff()
	return false
end

function modifier_chernobog_e2_thinker:IsAura()
	return true
end

function modifier_chernobog_e2_thinker:GetModifierAura()
	return "modifier_chernobog_e2_effect"
end

function modifier_chernobog_e2_thinker:RemoveOnDeath()
	return true
end

function modifier_chernobog_e2_thinker:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_chernobog_e2_thinker:GetAuraSearchType()
    return DOTA_UNIT_TARGET_BASIC
end

function modifier_chernobog_e2_thinker:GetAuraRadius()
	local radius = CalculateFinalRadius(self:GetCaster(), CHERNOBOG_E2_RADIUS, DOTA_E_SLOT)
	return radius
end

function modifier_chernobog_e2_thinker:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_chernobog_e2_thinker:OnCreated()
	if not IsServer() then
		return
	end
end

function modifier_chernobog_e2_effect:IsHidden()
	return false
end

function modifier_chernobog_e2_effect:IsDebuff()
	return true
end

function modifier_chernobog_e2_effect:OnCreated()
	if not IsServer() then
		return
	end
	self:SetSpecialTypes({
		MODIFIER_ROSHPIT_MAGIC_ARMOR_BONUS,
		MODIFIER_ROSHPIT_ARMOR_BONUS
	})
	self:OnIntervalThink()
	self:StartIntervalThink(0.5)
end

function modifier_chernobog_e2_effect:OnIntervalThink()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local e_2_level = caster:GetRuneValue("e", 2)
	self:SetStackCount(e_2_level)
	self:GetParent():CalculateAndSaveRoshpitAttributes()
end	

function modifier_chernobog_e2_effect:OnDestroy()
	if not IsServer() then
		return
	end
	self:GetParent():CalculateAndSaveRoshpitAttributes()
end

function modifier_chernobog_e2_effect:DeclareFunctions()
	return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end

function modifier_chernobog_e2_effect:GetRoshpitArmorBonus()
	local base = self:GetStackCount() * CHERNOBOG_E2_ARMOR_AND_MAGIC_ARMOR_REDUC
	local reduc = CalculateFinalArmorReduction(self:GetCaster(), base, DOTA_E_SLOT)
	return reduc
end

function modifier_chernobog_e2_effect:GetRoshpitMagicArmorBonus()
	local base = self:GetStackCount() * CHERNOBOG_E2_ARMOR_AND_MAGIC_ARMOR_REDUC
	local reduc = CalculateFinalArmorReduction(self:GetCaster(), base, DOTA_E_SLOT)
	return reduc
end

function modifier_chernobog_e2_effect:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount() * CHERNOBOG_E2_AS_SLOW
end

----------
--- E3 ---
----------
function modifier_chernobog_e3_thinker:IsHidden()
    return true
end

function modifier_chernobog_e3_thinker:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_SPECIAL_TYPE_ORDER_FILTER
    })
end
function modifier_chernobog_e3_thinker:OnOrderFilter(data)
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local e_3_level = caster:GetRuneValue("e", 3)
	if not (e_3_level > 0) then
		return
	end
    local allowedOrderTypes = {
        [DOTA_UNIT_ORDER_ATTACK_TARGET] = true,
    }
	if caster:HasModifier("modifier_chernobog_glyph_3_2") then
		allowedOrderTypes = {
			[DOTA_UNIT_ORDER_ATTACK_TARGET] = true,
			[DOTA_UNIT_ORDER_MOVE_TO_POSITION] = true
		}
	end
    if not allowedOrderTypes[data.order_type] then
        return
    end
    if not data.entindex_target then
        return
    end
    local enemy = EntIndexToHScript(data.entindex_target)
    if not IsValidEntity(enemy) then
        return
    end
	if caster:HasModifier("modifier_chernobog_e3_cd") then
		return
	end
    if (data.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET) and (IsValidEntity(enemy)) then
        if enemy.dummy or (enemy:GetClassname() == "dota_item_drop") or (enemy:GetTeamNumber() == caster:GetTeamNumber()) then
            return
        end
        if caster:IsRooted() or caster:IsStunned() then
			return 
		end
		if (data.entindex_target == 0) then
			return
		end
		local distance = WallPhysics:GetDistance2d(enemy:GetAbsOrigin(), caster:GetAbsOrigin())
		if (distance <= CHERNOBOG_E3_RANGE_BASE + CHERNOBOG_E3_RANGE * e_3_level) then
			self:DoTeleport(caster, enemy, ability, enemy:GetAbsOrigin())
			caster:AddNewModifier(caster, ability, "modifier_chernobog_e3_cd", {duration = CHERNOBOG_E3_INNTER_CD})
		end
	elseif (data.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION) then
		local end_point = GetGroundPosition(Vector(data.position_x, data.position_y, 0), caster)
		local distance = WallPhysics:GetDistance2d( end_point, caster:GetAbsOrigin())
		if (distance <= (CHERNOBOG_E3_RANGE_BASE + CHERNOBOG_E3_RANGE * e_3_level * CHERNOBOG_GLYPH_3_2_TELE_DISTANCE_LOSS / 100)) then
			caster:AddNewModifier(caster, ability, "modifier_chernobog_e3_cd", {duration = CHERNOBOG_GLYPH_3_2_MOVE_CD})
			self:DoTeleport(caster, nil, ability, end_point)
		end
    end
end

function modifier_chernobog_e3_thinker:DoTeleport(caster, target, ability, end_point)
	local afterWallPosition = WallPhysics:WallSearch(caster:GetAbsOrigin(), end_point, caster)
	if afterWallPosition ~= end_point then
		return
	end
	local particleName = "particles/roshpit/chernobog/chernobog_rune_c_c.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(particle1, 0, caster:GetAbsOrigin())
						
	FindClearSpaceForUnit(caster, afterWallPosition, false)
						
	EmitSoundOn("Chernobog.TeleportMove", caster)
	local particle2 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(particle2, 0, caster:GetAbsOrigin() + Vector(0, 0, 100))
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(particle1, false)
		ParticleManager:ReleaseParticleIndex(particle1)		
		ParticleManager:DestroyParticle(particle2, false)
		ParticleManager:ReleaseParticleIndex(particle2)
	end)
	if target ~= nil then
		Timers:CreateTimer(0.15, function()
			ApplyModifier(caster, caster, ability, "modifier_chernobog_e3_effect", -1, nil)
			StartAnimation(caster, {duration = 0.3, activity = ACT_DOTA_ATTACK, rate = 3})
			if caster:HasModifier("modifier_chernobog_glyph_5_1") then
				local search_radius = CalculateFinalRadius(caster, CHERNOBOG_GLYPH_5_1_RADIUS, DOTA_E_SLOT)
				for i = 1, CHERNOBOG_GLYPH_5_1_HIT_COUNT, 1 do
					Timers:CreateTimer(0.03, function()
						local enemies = SearchEnemies(caster, target, search_radius)
						for _, enemy in pairs(enemies) do
							Filters:PerformAttackSpecial(caster, enemy, true, true, true, true, false, false, false)				
						end
					end)
				end
			else
				Filters:PerformAttackSpecial(caster, target, true, true, true, true, false, false, false)
			end
		end)
	end
end

function modifier_chernobog_e3_effect:OnCreated()
    if not IsServer() then
        return
    end
	self:SetSpecialTypes({})
end

function modifier_chernobog_e3_effect:OnIntervalThink()
	if not IsServer() then
		return
	end
end

function modifier_chernobog_e3_effect:GetTexture()
    return "chernobog/chernobog_rune_e_3"
end

function modifier_chernobog_e3_cd:IsDebuff()
	return true
end

function modifier_chernobog_e3_cd:IsPurgable()
	return false
end

function modifier_chernobog_e3_cd:IsHidden()
	return true
end

----------
--- E4 ---
----------
function modifier_chernobog_e4_buff:IsHidden()
	return false
end

function modifier_chernobog_e4_buff:IsDebuff()
    return false
end

function modifier_chernobog_e4_buff:GetTexture()
    return "chernobog/chernobog_rune_e_4"
end

function modifier_chernobog_e4_buff:DeclareFunctions()
	return{	MODIFIER_PROPERTY_DODGE_PROJECTILE,
			MODIFIER_EVENT_ON_PROJECTILE_DODGE
			}
end

function modifier_chernobog_e4_buff:OnCreated()
	if not IsServer() then
		return 
	end
	self:SetSpecialTypes({
		MODIFIER_ROSHPIT_MAGIC_ARMOR_BONUS
	})
end

function modifier_chernobog_e4_buff:GetRoshpitMagicArmorBonus()	
	local magic_armor = self:GetStackCount() * CHERNOBOG_E4_MAGIC_ARMOR_BONUS
	if self:GetCaster():GetHealthPercent() <= CHERNOBOG_E4_BONUS_THRESHOLD then
		magic_armor = magic_armor * CHERNOBOG_E4_MULTI_WITH_THRESHOLD
	end
	return magic_armor
end

function modifier_chernobog_e4_buff:GetModifierDodgeProjectile()
	local luck = RandomFloat(1, 100)
	local chance = self:GetStackCount() * CHERNOBOG_E4_DODGE_CHANCE + CHERNOBOG_E4_DODGE_CHANCE_BASE
	if self:GetCaster():GetHealthPercent() <= CHERNOBOG_E4_BONUS_THRESHOLD then
		chance = chance * CHERNOBOG_E4_MULTI_WITH_THRESHOLD
	end
	if luck < chance then
		return 1
	end
	return 0
end

function modifier_chernobog_e4_buff:OnProjectileDodge(event)
	if not IsServer() then
		return
	end
end
