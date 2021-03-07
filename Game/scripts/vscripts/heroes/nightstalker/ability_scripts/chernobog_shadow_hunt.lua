require('heroes/nightstalker/util')

chernobog_shadow_hunt = class(base_ability)

modifier_shadow_hunt = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_shadow_hunt", "heroes/nightstalker/ability_scripts/chernobog_shadow_hunt.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_e2_effect = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_e2_effect", "heroes/nightstalker/ability_scripts/chernobog_shadow_hunt.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_e3_effect = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_e3_effect", "heroes/nightstalker/ability_scripts/chernobog_shadow_hunt.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_e3_cd = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_e3_cd", "heroes/nightstalker/ability_scripts/chernobog_shadow_hunt.lua", LUA_MODIFIER_MOTION_NONE)

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
		    if caster:GetRuneValue("e", 4) > 0 then
			    local duration = Filters:GetAdjustedBuffDuration(caster, CHERNOBOG_E4_BASE_DUR + CHERNOBOG_E4_DUR * caster:GetRuneValue("e", 4), false)
			    caster:FindModifierByName("modifier_shadow_hunt"):SetDuration(duration, true)
			else
			    caster:RemoveModifierByName("modifier_shadow_hunt")
			end
		end
	end
end

function modifier_shadow_hunt:IsHidden()
	return false
end

function modifier_shadow_hunt:IsDebuff()
	return false
end

function modifier_shadow_hunt:IsAura(params)
    if IsServer() and self:GetCaster():GetRuneValue("e", 2) > 0 then
        return true
    end
	return false
end

function modifier_shadow_hunt:GetModifierAura()
    return "modifier_chernobog_e2_effect"
end

function modifier_shadow_hunt:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_shadow_hunt:GetAuraSearchType()
    return DOTA_UNIT_TARGET_BASIC
end

function modifier_shadow_hunt:GetAuraRadius()
	return CalculateFinalRadius(self:GetCaster(), CHERNOBOG_E2_RADIUS, DOTA_E_SLOT)
end

function modifier_shadow_hunt:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_shadow_hunt:OnCreated()
	if not IsServer() then
		return
	end
	self:SetSpecialTypes({
	    MODIFIER_ROSHPIT_MASTER_GREEN_DMG,
		MODIFIER_SPECIAL_TYPE_ORDER_FILTER,
		MODIFIER_ROSHPIT_MAGIC_ARMOR_BONUS
	})
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
    local hp_drain = ability:GetSpecialValueFor("hp_drain_per_second")
    local mp_drain = ability:GetSpecialValueFor("mp_drain_per_second")
    local allmodifier = caster:FindAllModifiers()
	local e_2_radius = CalculateFinalRadius(self:GetCaster(), CHERNOBOG_E2_RADIUS, DOTA_E_SLOT)
	if self:IsAura() then
	    if not self.pfx then
	        self.pfx = ParticleManager:CreateParticle("particles/roshpit/chernobog/demon_form_slow_aura_spell_bloodbath_bubbles_.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		end
	else
	    if self.pfx then
		    ParticleManager:DestroyParticle(self.pfx, false)
		end
	end
    if #allmodifier > 0 then
	    for i = 1, #allmodifier, 1 do
		    if allmodifier[i].GetDisableHealing and (allmodifier[i]:GetDisableHealing() == 1) then
			    hp_drain = hp_drain * ( 100 - CHERNOBOG_E_DRAIN_REDUC_WHEN_HEALING_DISABLED) / 100
			    mp_drain = mp_drain * ( 100 - CHERNOBOG_E_DRAIN_REDUC_WHEN_HEALING_DISABLED) / 100
			    break
		    end
	    end
    end
	if not (self:GetDuration() > 0) then
        if currentHealth > minHealth then
           caster:SetHealth(math.max(currentHealth - currentHealth * CHERNOBOG_E_DRAIN_INTERVAL * hp_drain / 100, minHealth))
        end
        if currentMana > minMana then
           caster:ReduceMana(math.min(currentMana * CHERNOBOG_E_DRAIN_INTERVAL * mp_drain / 100, currentMana - minMana))
        end
	end
	if caster:HasModifier("modifier_chernobog_glyph_1_1") then
		local search_radius = CHERNOBOG_E3_RANGE_BASE + CHERNOBOG_E3_RANGE * caster:GetRuneValue("e", 3) + 500
		local enemies = SearchEnemies(caster, caster, search_radius, true)
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
	if self.pfx then
	   ParticleManager:DestroyParticle(self.pfx, false)
	end
end

function modifier_shadow_hunt:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        MODIFIER_PROPERTY_DODGE_PROJECTILE
    }
end

function modifier_shadow_hunt:GetModifierMoveSpeed_Max_Increase(params)
    if IsServer() then
	    return self:GetAbility():GetSpecialValueFor("movespeed_cap") + self:GetCaster():GetRuneValue("e", 1) * CHERNOBOG_E1_MOVESPEED
    end
end

function modifier_shadow_hunt:GetModifierMoveSpeedBonus_Constant()
    if IsServer() then
        return self:GetAbility():GetSpecialValueFor("movespeed_bonus") + self:GetCaster():GetRuneValue("e", 1) * CHERNOBOG_E1_MOVESPEED
	end
end

function modifier_shadow_hunt:GetRoshpitMasterGreenDMG()
    return self:GetCaster():GetRuneValue("e", 1) * CHERNOBOG_E1_ATK_PCT
end

function modifier_shadow_hunt:GetModifierDodgeProjectile(params)
    if IsServer() then
	    local chance = self:GetCaster():GetRuneValue("e", 4) * CHERNOBOG_E4_DODGE_CHANCE + CHERNOBOG_E4_DODGE_CHANCE_BASE
	    if self:GetCaster():GetHealthPercent() <= CHERNOBOG_E4_BONUS_THRESHOLD then
		    chance = chance * CHERNOBOG_E4_MULTI_WITH_THRESHOLD
	    end
	    if RandomInt(1, 100) < chance then
		    return 1
	    end
	    return 0
	end
end

function modifier_shadow_hunt:GetRoshpitMagicArmorBonus()
	local magic_armor = self:GetCaster():GetRuneValue("e", 4) * CHERNOBOG_E4_MAGIC_ARMOR_BONUS
	if self:GetCaster():GetHealthPercent() <= CHERNOBOG_E4_BONUS_THRESHOLD then
		magic_armor = magic_armor * CHERNOBOG_E4_MULTI_WITH_THRESHOLD
	end
	return magic_armor
end

function modifier_shadow_hunt:GetActivityTranslationModifiers()
    return "haste"
end

----------
--- E2 ---
----------
function modifier_chernobog_e2_effect:IsHidden()
	return false
end

function modifier_chernobog_e2_effect:IsDebuff()
	return true
end

function modifier_chernobog_e2_effect:DeclareFunctions()
	return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
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
	self:SetStackCount(self:GetCaster():GetRuneValue("e", 2))
	self:GetParent():CalculateAndSaveRoshpitAttributes()
end	

function modifier_chernobog_e2_effect:OnDestroy()
	if not IsServer() then
		return
	end
	self:GetParent():CalculateAndSaveRoshpitAttributes()
end

function modifier_chernobog_e2_effect:GetRoshpitArmorBonus()
	local base = self:GetStackCount() * CHERNOBOG_E2_ARMOR_AND_MAGIC_ARMOR_REDUC
	return CalculateFinalArmorReduction(self:GetCaster(), base, DOTA_E_SLOT)
end

function modifier_chernobog_e2_effect:GetRoshpitMagicArmorBonus()
	local base = self:GetStackCount() * CHERNOBOG_E2_ARMOR_AND_MAGIC_ARMOR_REDUC
	return CalculateFinalArmorReduction(self:GetCaster(), base, DOTA_E_SLOT)
end

function modifier_chernobog_e2_effect:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount() * CHERNOBOG_E2_AS_SLOW
end

----------
--- E3 ---
----------
function modifier_shadow_hunt:OnOrderFilter(data)
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local e_3_level = caster:GetRuneValue("e", 3)
	if not (e_3_level > 0) then
		return
	end
    local allowedOrderTypes = {}
	if caster:HasModifier("modifier_chernobog_glyph_3_2") then
		allowedOrderTypes = {
			[DOTA_UNIT_ORDER_ATTACK_TARGET] = true,
			[DOTA_UNIT_ORDER_MOVE_TO_POSITION] = true
		}
	else
	    allowedOrderTypes = {
			[DOTA_UNIT_ORDER_ATTACK_TARGET] = true,
		}
	end
    if not (allowedOrderTypes[data.order_type] and data.entindex_target) then
        return
    end
    local enemy = EntIndexToHScript(data.entindex_target)
	if caster:HasModifier("modifier_chernobog_e3_cd") then
		return
	end
	if enemy.dummy or (enemy:GetClassname() == "dota_item_drop") or (enemy:GetTeamNumber() == caster:GetTeamNumber()) or caster:IsRooted() or caster:IsStunned() or (data.entindex_target == 0) then
		return
	end
    if (data.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET) and (IsValidEntity(enemy)) then
		local distance = WallPhysics:GetDistance2d(enemy:GetAbsOrigin(), caster:GetAbsOrigin())
		if (distance <= CHERNOBOG_E3_RANGE_BASE + CHERNOBOG_E3_RANGE * e_3_level) then
			self:DoTeleport(caster, enemy, ability, enemy:GetAbsOrigin())
			caster:AddNewModifier(caster, ability, "modifier_chernobog_e3_cd", {duration = CHERNOBOG_E3_INNTER_CD})
		end
	elseif (data.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION) then
		local end_point = GetGroundPosition(Vector(data.position_x, data.position_y, 0), caster)
		local distance = WallPhysics:GetDistance2d( end_point, caster:GetAbsOrigin())
		local direction = ((end_point - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	    local maxDistance = CHERNOBOG_E3_RANGE_BASE + CHERNOBOG_E3_RANGE * e_3_level * CHERNOBOG_GLYPH_3_2_TELE_DISTANCE_LOSS / 100
	    if distance > maxDistance then
		    end_point = WallPhysics:WallSearch(caster:GetAbsOrigin(), caster:GetAbsOrigin() + direction * maxDistance, caster)
	    end
		caster:AddNewModifier(caster, ability, "modifier_chernobog_e3_cd", {duration = CHERNOBOG_GLYPH_3_2_MOVE_CD})
		self:DoTeleport(caster, nil, ability, end_point)
    end
end

function modifier_shadow_hunt:DoTeleport(caster, target, ability, end_point)
	local afterWallPosition = WallPhysics:WallSearch(caster:GetAbsOrigin(), end_point, caster)
	if afterWallPosition ~= end_point then
		return
	end
	local particle1 = ParticleManager:CreateParticle("particles/roshpit/chernobog/chernobog_rune_c_c.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(particle1, 0, caster:GetAbsOrigin())		
	FindClearSpaceForUnit(caster, afterWallPosition, false)			
	EmitSoundOn("Chernobog.TeleportMove", caster)
	local particle2 = ParticleManager:CreateParticle("particles/roshpit/chernobog/chernobog_rune_c_c.vpcf", PATTACH_CUSTOMORIGIN, caster)
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
						local enemies = SearchEnemies(caster, target, search_radius, true)
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

