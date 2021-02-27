require('heroes/nightstalker/util')

chernobog_demon_flight = class(base_ability)
chernobog_demon_warp = class(base_ability)
chernobog_demon_walk = class(base_ability)

modifier_chernobog_arcana_e_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_arcana_e_passive", "heroes/nightstalker/arcana/chernobog_demon_flight.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_demon_flight = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_demon_flight", "heroes/nightstalker/arcana/chernobog_demon_flight.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_demon_walk = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_demon_walk", "heroes/nightstalker/arcana/chernobog_demon_flight.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_demon_flight_flying_thinker = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_demon_flight_flying_thinker", "heroes/nightstalker/arcana/chernobog_demon_flight.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_arcana_e1_freecast = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_arcana_e1_freecast", "heroes/nightstalker/arcana/chernobog_demon_flight.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_arcana_e2_count = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_arcana_e2_count", "heroes/nightstalker/arcana/chernobog_demon_flight.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_arcana_e2_effect = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_arcana_e2_effect", "heroes/nightstalker/arcana/chernobog_demon_flight.lua", LUA_MODIFIER_MOTION_NONE)


--DEMON FLIGHT BASE--

function chernobog_demon_flight:GetBehaviorBase()
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_AOE
end

function chernobog_demon_flight:GetAbilitySlot()
	return DOTA_E_SLOT
end

function chernobog_demon_flight:GetCastPoint()
	return 0
end

function chernobog_demon_flight:GetManaCostBase(level)
	return 60
end

function chernobog_demon_flight:GetCooldownBase(level)
	return 7.5
end

function chernobog_demon_flight:GetDuration()
	return self:GetSpecialValueFor("duration")
end

function chernobog_demon_flight:GetIntrinsicModifierName()
	return "modifier_chernobog_arcana_e_passive"
end

function chernobog_demon_flight:OnSpellStart()
	local caster = self:GetCaster()
	local duration = Filters:GetAdjustedBuffDuration(caster, self:GetDuration(), false)
	caster:AddNewModifier(caster, self, "modifier_chernobog_demon_flight", {duration = duration})
	caster:AddNewModifier(caster, self, "modifier_chernobog_demon_flight_flying_thinker", {duration = duration})
	EmitSoundOn("Chernobog.DemonFlight.Start", caster)
	EmitSoundOn("Chernobog.DemonFlight.StartVO", caster)
	caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
	Filters:CastSkillArguments(BASE_ABILITY_E, caster)
	swap_to_demon_warp(caster, ability, "chernobog_demon_flight", duration)
end

function swap_to_demon_warp(caster, ability, base_name, duration)
	local e_1_level = caster:GetRuneValue("e", 1)
	if e_1_level > 0 then
		CustomAbilities:AddAndOrSwapSkill(caster, base_name, "chernobog_demon_warp", 2)
		local procs = Runes:Procs(e_1_level, CHERNOBOG_ARCANA2_E1_CHANCE, 1)
		if procs > 0 then
			local warp_ability = caster:FindAbilityByName("chernobog_demon_warp")
			caster:AddNewModifier(caster, warp_ability, "modifier_chernobog_arcana_e1_freecast", {duration = duration}):SetStackCount(procs)
		end
	end
end

--modifiers
function modifier_chernobog_demon_flight:IsHidden()
	return false
end

function modifier_chernobog_demon_flight:IsDebuff()
	return false
end

function modifier_chernobog_demon_flight:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_MAX,
			MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
			MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
			MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
			MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS			
		}
end

function modifier_chernobog_demon_flight:CheckState()
	return {
			[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
			[MODIFIER_STATE_DISARMED] = true
		} 
end

function modifier_chernobog_demon_flight_flying_thinker:OnCreated()
	if not IsServer() then
		return
	end
	self:GetAbility().height = 0
	self:SetStackCount(self:GetAbility().height)
	self:StartIntervalThink(0.03)
end

function modifier_chernobog_demon_flight_flying_thinker:OnIntervalThink()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local newPos = caster:GetAbsOrigin() + caster:GetForwardVector() * 70
	local obstruction = WallPhysics:FindNearestObstruction(caster:GetAbsOrigin())
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPos, caster)
	if blockUnit then
		caster:SetAbsOrigin(caster:GetAbsOrigin() - caster:GetForwardVector() * 50)
	end
	ability.height = math.min(ability.height + 6, 380)
	self:SetStackCount(ability.height)
end	
function modifier_chernobog_demon_flight:OnCreated()
	if not IsServer() then
		return
	end
	self:SetSpecialTypes({MODIFIER_SPECIAL_TYPE_ORDER_FILTER})
	self:OnIntervalThink()
	self:StartIntervalThink(0.15)
end

function modifier_chernobog_demon_flight:OnOrderFilter(data)
	local caster = self:GetCaster()
    local allowedOrderTypes = {
        [DOTA_UNIT_ORDER_ATTACK_TARGET] = true,
    }
    if not allowedOrderTypes[data.order_type] then
        return
    end
    if not data.entindex_target then
        return
    end
    caster.flight_target = EntIndexToHScript(data.entindex_target)
end

function modifier_chernobog_demon_flight:OnIntervalThink()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	caster:SetRangedProjectileName("particles/roshpit/chernobog/boot_arcana_attack.vpcf")
	if caster.flight_target then
		if not IsValidEntity(caster.flight_target) then
			caster.flight_target = nil
			return false
		end
		if caster.flight_target:GetTeamNumber() == caster:GetTeamNumber() then
			return false
		end
		if not caster.flight_target:IsAlive() then
			local enemies = SearchEnemies(caster, caster, 550, true)
			local count = 0
			if #enemies > 0 then
				caster.flight_target = enemies[1]
			else
				caster.flight_target = nil
				return false
			end
		end
		if WallPhysics:GetDistance2d(caster.flight_target:GetAbsOrigin(), caster:GetAbsOrigin()) > 900 then
			return false
		end
		if caster:HasModifier("modifier_super_ascendency_trigger") then
			local enemies = SearchEnemies(caster, caster, 550, true)
			local count = 0
			if #enemies > 0 then
				for _, enemy in pairs(enemies) do
					Filters:PerformAttackSpecial(caster, enemy, true, true, true, false, true, false, false)
					count = count + 1
					if count == SUPER_ASCENDENCY_TARGETS then
						break
					end
				end
			end
		else
			Filters:PerformAttackSpecial(caster, caster.flight_target, true, true, true, false, true, false, false)
		end
	end
end

function modifier_chernobog_demon_flight:OnDestroy()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	caster.flight_target = nil
	if caster:HasModifier("modifier_chernobog_demon_flight_flying_thinker") then
		caster:RemoveModifierByName("modifier_chernobog_demon_flight_flying_thinker")
	end
	if not caster:HasModifier("modifier_chernobog_r_lifting") then
			WallPhysics:ClearSpaceForUnit(caster, caster:GetAbsOrigin())
		end
		if not caster:HasModifier("modifier_chernobog_demon_form") then
			if not caster:HasModifier("modifier_super_ascendency_trigger") then
				caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
			end
			Timers:CreateTimer(0.06, function()
			if not caster:HasModifier("modifier_chernobog_r_lifting") then
				StartAnimation(caster, {duration = 0.5, activity = ACT_DOTA_CAST_ABILITY_1, rate = 1.3, translate = "wraith_spin"})
			else
				StartAnimation(caster, {duration = 1.3, activity = ACT_DOTA_TELEPORT, rate = 1})
			end
		end)
	end
	if caster:GetAbilityByIndex(DOTA_E_SLOT):GetAbilityName() == "chernobog_demon_warp" then
		if caster:GetAbilityByIndex(DOTA_R_SLOT):GetAbilityName() == "chernobog_demon_morph" then
			CustomAbilities:AddAndOrSwapSkill(caster, "chernobog_demon_warp", "chernobog_demon_walk", 2)
		else
			CustomAbilities:AddAndOrSwapSkill(caster, "chernobog_demon_warp", "chernobog_demon_flight", 2)
		end
	end
	caster:RemoveModifierByName("modifier_chernobog_arcana_e1_freecast")
end

function modifier_chernobog_demon_flight:GetModifierMoveSpeed_Max_Increase()
    return self:GetAbility():GetSpecialValueFor("movespeed_bonus")
end

function modifier_chernobog_demon_flight:GetModifierMoveSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("movespeed_bonus")
end

function modifier_chernobog_demon_flight:GetActivityTranslationModifiers()
    return "haste"
end

function modifier_chernobog_demon_flight:GetModifierAttackRangeBonus(params)
    return 700
end

function modifier_chernobog_demon_flight:GetModifierProjectileSpeedBonus(params)
    return 500
end

function modifier_chernobog_demon_flight:GetAttackSound(params)
    return "Chernobog.DemonFlight.Attack"
end

function modifier_chernobog_demon_flight_flying_thinker:IsHidden()
	return true
end

function modifier_chernobog_demon_flight_flying_thinker:IsDebuff()
	return false
end

function modifier_chernobog_demon_flight_flying_thinker:DeclareFunctions()
	return {MODIFIER_PROPERTY_VISUAL_Z_DELTA}
end

function modifier_chernobog_demon_flight_flying_thinker:GetVisualZDelta()
	return self:GetStackCount()
end
	
function modifier_chernobog_arcana_e_passive:IsHidden()
	return true
end

function modifier_chernobog_arcana_e_passive:IsDebuff()
	return false
end

function modifier_chernobog_arcana_e_passive:IsPurgable()
	return false
end

function modifier_chernobog_arcana_e_passive:IsPermanent()
	return true
end

function modifier_chernobog_arcana_e_passive:RemoveOnDeath()
	return false
end

function modifier_chernobog_arcana_e_passive:DeclareFunctions()
	return {MODIFIER_PROPERTY_EVASION_CONSTANT}
end

function modifier_chernobog_arcana_e_passive:GetModifierEvasion_Constant()
	return 50
end

function modifier_chernobog_arcana_e_passive:OnCreated()
	if not IsServer() then
		return
	end
	self:SetSpecialTypes({
		MODIFIER_ROSHPIT_MASTER_BASE_ATTACK_DMG
	})
	self:OnIntervalThink()
end
	
function modifier_chernobog_arcana_e_passive:OnIntervalThink()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local e_4_level = caster:GetRuneValue("e", 4)
	ModifierThink(caster, ability, DOTA_E_SLOT, "e", nil, true)
	local interval = CalculateFinalRate(caster, CHERNOBOG_ARCANA2_E4_INTERVAL, DOTA_E_SLOT)
	local radius = CalculateFinalRadius(caster, CHERNOBOG_ARCANA2_E4_RADIUS + CHERNOBOG_ARCANA2_E4_RADIUS_INC * e_4_level, DOTA_E_SLOT) 
	self:StartIntervalThink(interval)
	if e_4_level > 0 then
		self:ProcE4(radius, interval)
	end
end
	
function modifier_chernobog_arcana_e_passive:GetRoshpitMasterBaseDMG()
	local caster = self:GetCaster()
	local e_3_level = caster:GetRuneValue("e", 3)
	if e_3_level > 0 then
		local damageDealt = 10000
		local damageDEMON = Filters:ElementalDamage(Events.GameMaster, caster, damageDealt * 100, DAMAGE_TYPE_PURE, 0, RPC_ELEMENT_DEMON, RPC_ELEMENT_NONE, false)
		local demonAmp = math.floor(damageDEMON / damageDealt)
		return e_3_level * CHERNOBOG_ARCANA2_E3_ATT_PER_DEMON_PCT * demonAmp
	end
	return 0
end
	
function modifier_chernobog_arcana_e_passive:ProcE4(radius, interval)
	local caster = self:GetCaster()
	local R_ability = caster:GetAbilityByIndex(DOTA_R_SLOT)
	local e_4_level = caster:GetRuneValue("e", 4)
	local damage = (e_4_level * CHERNOBOG_ARCANA2_E4_DMG_PCT + 20) * OverflowProtectedGetAverageTrueAttackDamage(caster) / 100
	local enemies = SearchEnemies(caster, caster, radius, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			if IsValidEntity(enemy) then
				local damageDelay =  0.9 * interval
				local animationRate = 1 + 0.3 * (0.5/interval - 1)
				local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/chernobog/nights_procession_illusion.vpcf", enemy, interval)
				ParticleManager:SetParticleControl(pfx, 1, Vector(animationRate, 0, 0))
				Timers:CreateTimer(damageDelay, function()
					EmitSoundOn("Chernobog.BC.Hit", enemy)
					ChernobogDealDamage(caster, enemy, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_E, RPC_ELEMENT_DEMON, RPC_ELEMENT_SHADOW, false, true)                
					ParticleManager:DestroyParticle(pfx, false)
					ParticleManager:ReleaseParticleIndex(pfx)
				end)
			end
		end
	end
end

function modifier_chernobog_arcana_e2_count:IsHidden()
	return true
end

function modifier_chernobog_arcana_e2_count:IsDebuff()
	return false
end

function modifier_chernobog_arcana_e2_count:OnCreated()
	if not IsServer() then
		return
	end
	self:OnIntervalThink()
	self:StartIntervalThink(0.1)
end

function modifier_chernobog_arcana_e2_count:OnIntervalThink()
	if not IsServer() then
		return
	end
	local e_2_level = self:GetCaster():GetRuneValue("e", 2)
	self:SetStackCount(e_2_level)
end

function modifier_chernobog_arcana_e2_effect:IsHidden()
	if self:GetStackCount() > 0 then
		return false
	end
	return true
end
	
function modifier_chernobog_arcana_e2_effect:IsDebuff()
	return false 
end

function modifier_chernobog_arcana_e2_effect:GetTexture()
	return "chernobog/chernobog_rune_e_2_arcana2"
end

function modifier_chernobog_arcana_e2_effect:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_MOVESPEED_MAX}
end

function modifier_chernobog_arcana_e2_effect:OnCreated()
	if not IsServer() then
		return
	end
	self:SetSpecialTypes({
			MODIFIER_ROSHPIT_MASTER_GREEN_DMG
	})
	self:StartIntervalThink(0.1)
end

function modifier_chernobog_arcana_e2_effect:OnIntervalThink()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local radius = CalculateFinalRadius(caster, CHERNOBOG_ARCANA2_E2_SEARCH_RADIUS, DOTA_E_SLOT) 
	local enemies = SearchEnemies(caster, caster, radius)
	local bonus_stacks = 0
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			if IsValidEntity(enemy) then
				if enemy.mainBoss or enemy.isBossFFS then
					bonus_stacks = bonus_stacks + 6
				elseif enemy.paragon then
					bonus_stacks = bonus_stacks + 3
				else	
					bonus_stacks = bonus_stacks + 1
				end
			end
		end
	end
	self:SetStackCount(math.min(bonus_stacks, 10))
end
	
function modifier_chernobog_arcana_e2_effect:GetRoshpitMasterGreenDMG()
	local caster = self:GetCaster()
	local e_2_level = caster:GetModifierStackCount("modifier_chernobog_arcana_e2_count", caster)
	return e_2_level * CHERNOBOG_ARCANA2_E2_ATT_PCT *( self:GetStackCount() * 0.1 + 1)
end

function modifier_chernobog_arcana_e2_effect:GetModifierMoveSpeedBonus_Constant()
	local caster = self:GetCaster()
	local e_2_level = caster:GetModifierStackCount("modifier_chernobog_arcana_e2_count", caster)
	return e_2_level * CHERNOBOG_ARCANA2_E2_MS_AND_CAP_BONUS *( self:GetStackCount() * 0.1 + 1)
end

function modifier_chernobog_arcana_e2_effect:GetModifierMoveSpeed_Max_Increase()
	local caster = self:GetCaster()
	local e_2_level = caster:GetModifierStackCount("modifier_chernobog_arcana_e2_count", caster)
	return e_2_level * CHERNOBOG_ARCANA2_E2_MS_AND_CAP_BONUS *( self:GetStackCount() * 0.1 + 1)
end

----------DEMON FLIGHT BASE END------------
--DEMON WARP
function chernobog_demon_warp:GetBehaviorBase()
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end

function chernobog_demon_warp:GetAbilitySlot()
	return DOTA_E_SLOT
end

function chernobog_demon_warp:GetCastPoint()
	return 0.15
end

function chernobog_demon_warp:GetManaCostBase(level)
	return 0
end

function chernobog_demon_warp:GetCooldownBase(level)
	return 0.5
end

function chernobog_demon_warp:OnSpellStart()
	EmitSoundOn("Chernobog.DemonWarp", caster)
	local caster = self:GetCaster()
	local target = self:GetCursorPosition()
	local casterOrigin = caster:GetAbsOrigin()
	local heightStacks = caster:GetModifierStackCount("modifier_chernobog_demon_flight_flying_thinker", caster)
	CustomAbilities:QuickParticleAtPoint("particles/items_fx/blink_dagger_start.vpcf", caster:GetAbsOrigin() + Vector(0, 0, heightStacks), 3)
	CustomAbilities:QuickAttachParticle("particles/econ/items/spectre/spectre_transversant_soul/spectre_transversant_spectral_dagger_path_owner_impact.vpcf", caster, 3)
	target = WallPhysics:WallSearch(casterOrigin, target, caster)
	local newPosition = target
	local direction = ((newPosition - casterOrigin) * Vector(1, 1, 0)):Normalized()
	local distance = WallPhysics:GetDistance2d(casterOrigin, newPosition)
	local e_1_level = caster:GetRuneValue("e", 1)
	local maxDistance = CHERNOBOG_ARCANA2_E1_RANGE_BASE + e_1_level * CHERNOBOG_ARCANA2_E1_RANGE
	if distance > maxDistance then
		newPosition = WallPhysics:WallSearch(casterOrigin, casterOrigin + direction * maxDistance, caster)
	end
	FindClearSpaceForUnit(caster, newPosition, false)
	Filters:CastSkillArguments(BASE_ABILITY_E, caster)
	ProjectileManager:ProjectileDodge(caster)
	CustomAbilities:QuickParticleAtPoint("particles/econ/items/spectre/spectre_transversant_soul/spectre_transversant_spectral_dagger_path_owner_impact.vpcf", caster:GetAbsOrigin(), 3)
	CustomAbilities:QuickParticleAtPoint("particles/items_fx/blink_dagger_start.vpcf", caster:GetAbsOrigin() + Vector(0, 0, heightStacks), 3)

	StartAnimation(caster, {duration = 0.9, activity = ACT_DOTA_CAST_ABILITY_3, rate = 1, translate = "hunter_night"})
	if caster:HasModifier("modifier_chernobog_arcana_e1_freecast") then
		local newStacks = caster:GetModifierStackCount("modifier_chernobog_arcana_e1_freecast", caster) - 1
		print(newStacks)
		if newStacks > 0 then
			caster:SetModifierStackCount("modifier_chernobog_arcana_e1_freecast", caster, newStacks)
		else
			caster:RemoveModifierByName("modifier_chernobog_arcana_e1_freecast")
		end
	else
		if caster:HasModifier("modifier_chernobog_arcana_e_passive") then
			if caster:HasModifier("modifier_chernobog_demon_form") then
				CustomAbilities:AddAndOrSwapSkill(caster, "chernobog_demon_warp", "chernobog_demon_walk", 2)
			else
				CustomAbilities:AddAndOrSwapSkill(caster, "chernobog_demon_warp", "chernobog_demon_flight", 2)
			end
		end
	end
end

function modifier_chernobog_arcana_e1_freecast:IsHidden()
	return false
end

function modifier_chernobog_arcana_e1_freecast:IsDebuff()
	return false
end

function modifier_chernobog_arcana_e1_freecast:GetTexture()
	return "chernobog/flash_of_orias"
end

--DEMON WARP END--

--DEMON WALK
function chernobog_demon_walk:GetBehaviorBase()
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end

function chernobog_demon_walk:GetAbilitySlot()
	return DOTA_E_SLOT
end

function chernobog_demon_walk:GetCastPoint()
	return 0
end

function chernobog_demon_walk:GetManaCostBase(level)
	return 60
end

function chernobog_demon_walk:GetCooldownBase(level)
	return 13
end

function chernobog_demon_walk:GetIntrinsicModifierName()
	return "modifier_chernobog_arcana_e_passive"
end

function chernobog_demon_walk:GetDuration()
	return self:GetSpecialValueFor("duration")
end

function chernobog_demon_walk:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self
	local duration = Filters:GetAdjustedBuffDuration(caster, self:GetDuration(), false)
	caster:AddNewModifier(caster, self, "modifier_chernobog_demon_walk", {duration = duration})
	caster:AddNewModifier(caster, nil, "modifier_persistent_invisibility", {duration = duration})
	Filters:CastSkillArguments(BASE_ABILITY_E, caster)
	swap_to_demon_warp(caster, ability, "chernobog_demon_walk")
	EmitSoundOn("Chernobog.DemonWalkStart", caster)
	CustomAbilities:QuickAttachParticle("particles/roshpit/chernobog/shadow_walk.vpcf", caster, 1.5)
	StartAnimation(caster, {duration = 0.9, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1})
end

function modifier_chernobog_demon_walk:IsHidden()
	return false
end

function modifier_chernobog_demon_walk:IsDebuff()
	return false
end

function modifier_chernobog_demon_walk:CheckState()
	return {[MODIFIER_STATE_INVISIBLE] = true }
end

function modifier_chernobog_demon_walk:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_START,
			MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_MOVESPEED_MAX}
end

function modifier_chernobog_demon_walk:OnCreated()
	if not IsServer() then
		return
	end
end

function modifier_chernobog_demon_walk:OnAttackStart(event)
	if not IsServer() then
		return
	end
	if event.attacker ~= self:GetParent() or event.unit == self:GetParent() then
		return
	end
	local caster = self:GetCaster()
	CustomAbilities:QuickAttachParticle("particles/econ/items/spectre/spectre_transversant_soul/spectre_transversant_spectral_dagger_path_owner_impact.vpcf", caster, 0.4)
end	
	
function modifier_chernobog_demon_walk:OnDestroy()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if caster:HasModifier("modifier_chernobog_arcana_e_passive") then
		if caster:GetAbilityByIndex(DOTA_E_SLOT):GetAbilityName() == "chernobog_demon_warp" then
			if caster:HasModifier("modifier_chernobog_demon_form") then
				CustomAbilities:AddAndOrSwapSkill(caster, "chernobog_demon_warp", "chernobog_demon_walk", 2)
			else
				CustomAbilities:AddAndOrSwapSkill(caster, "chernobog_demon_warp", "chernobog_demon_flight", 2)
			end
		end
	end
	caster:RemoveModifierByName("modifier_chernobog_arcana_e1_freecast")
end

function modifier_chernobog_demon_walk:GetModifierMoveSpeed_Max_Increase()
    return self:GetAbility():GetSpecialValueFor("movespeed_bonus")
end

function modifier_chernobog_demon_walk:GetModifierMoveSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("movespeed_bonus")
end
