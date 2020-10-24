require('items/lua/helm/base_helm')
require('npc_abilities/base_modifier')

item_rpc_cloak_of_the_cimmerian_priesthood = class(BaseHelm, nil, BaseHelm)
local itemClass = item_rpc_cloak_of_the_cimmerian_priesthood
local itemClassName = 'item_rpc_cloak_of_the_cimmerian_priesthood'

modifier_cloak_of_the_cimmerian_priesthood = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_cloak_of_the_cimmerian_priesthood
local modifierName = 'modifier_cloak_of_the_cimmerian_priesthood'
LinkLuaModifier(modifierName, "items/lua/helm/cloak_of_the_cimmerian_priesthood", LUA_MODIFIER_MOTION_NONE)

modifier_cimmerian_priest_q_dot = class(npc_base_modifier, nil, npc_base_modifier)
local priest_q_dot = modifier_cimmerian_priest_q_dot
LinkLuaModifier("modifier_cimmerian_priest_q_dot", "items/lua/helm/cloak_of_the_cimmerian_priesthood", LUA_MODIFIER_MOTION_NONE)

modifier_cimmerian_priest_e_shield = class(npc_base_modifier, nil, npc_base_modifier)
local priest_e_shield = modifier_cimmerian_priest_e_shield
LinkLuaModifier("modifier_cimmerian_priest_e_shield", "items/lua/helm/cloak_of_the_cimmerian_priesthood", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'Mask of the Phantom Sorcerer'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:HasRuneSlots()
    return true
end
function itemClass:RollProperty1(maxFactor)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_cloak_of_the_cimmerian_priesthood"
    self:SetSpecialValue("cloak_of_the_cimmerian_priesthood", "#7024BD")
end

function itemClass:RollProperty2(item_level) 
    local luck = RandomInt(1, 8)
    if luck < 6 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, rune_type, 2)
    elseif luck == 6 then
    	RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "element_holy", 2.5)
    elseif luck == 7 then
    	RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "element_shadow", 2.5)
    else
        RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "t3_rune", 1.5)
    end
end

function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 0.5)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 3.5)
end

-- MODIFIER

function modifierClass:RemoveOnDeath()
	return false
end

function modifierClass:IsHidden()
	return true
end

function modifierClass:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({ 
        MODIFIER_SPECIAL_TYPE_ON_HIT_Q_ABILITY,
        MODIFIER_SPECIAL_TYPE_ON_HIT_W_ABILITY,
        MODIFIER_SPECIAL_TYPE_CAST_E_ABILITY,
        MODIFIER_SPECIAL_TYPE_CAST_R_ABILITY
    })
	local parent = self:GetParent()
	local ability = self:GetAbility()
	local attack_particle_save = parent:GetRangedProjectileName()
	if parent:GetAttackCapability() == DOTA_UNIT_CAP_RANGED_ATTACK then
		parent:SetRangedProjectileName("particles/roshpit/items/cloak_of_cimmerian_priesthood/attack_ovveride.vpcf")
	end
	ability.attack_particle_save = attack_particle_save
end

function modifierClass:OnDestroy()
	if not IsServer() then
		return false
	end
	local parent = self:GetParent()
	local ability = self:GetAbility()
	if parent:GetAttackCapability() == DOTA_UNIT_CAP_RANGED_ATTACK then
		parent:SetRangedProjectileName(ability.attack_particle_save)
	end
end

function modifierClass:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
    return funcs
end

function modifierClass:OnAttackLanded(event)
	if not IsServer() then
		return false
	end
    local attacker = event.attacker
    if not self:ParentIsAttacker(event) then
        return
    end
    local target = event.target
    local ability = event.ability
	local damage = Filters:GetPrimaryAttributeMultiple(attacker, ITEM_RPC_CLOAK_OF_THE_CIMMERIAN_PRIESTHOOD_DMG_MULT_PRIM_ATTRIBUTE)
	local healAmount = damage * (ITEM_RPC_CLOAK_OF_THE_CIMMERIAN_PRIESTHOOD_HEAL_PCT/100)
	Filters:ApplyItemDamage(target, attacker, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_SHADOW, RPC_ELEMENT_HOLY)
	Filters:ApplyHeal(attacker, attacker, healAmount, true, true, ability)
end

function modifierClass:OnHitQAbility(event)
	local target = event.victim
	local damage = event.damage
	local attacker = event.attacker
	local ability = self:GetAbility()
	if ability:GetGemValue("ruby") > 0 then
		local duration = ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_CLOAK_OF_THE_CIMMERIAN_PRIESTHOOD_RUBY2)
		target:AddNewModifier(attacker, ability, "modifier_cimmerian_priest_q_dot", {duration = duration})
		if not ability.dotTable then
			ability.dotTable = {}
		end
		ability.dotTable[target:GetEntityIndex()] = damage * (ITEM_RPC_CLOAK_OF_THE_CIMMERIAN_PRIESTHOOD_RUBY_DAMAGE/100)
	end
end

function modifierClass:OnHitWAbility(event)
	local target = event.victim
	local damage = event.damage
	local attacker = event.attacker
	local ability = self:GetAbility()
	if ability:GetGemValue("emerald") > 0 then
		local healAmount = damage * (ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_CLOAK_OF_THE_CIMMERIAN_PRIESTHOOD_EMERALD)/100)
		local allies = FindUnitsInRadius(attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, ITEM_RPC_CLOAK_OF_THE_CIMMERIAN_PRIESTHOOD_EMERALD_RANGE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
		if #allies > 0 then
			for _, ally in pairs(allies) do
				Filters:ApplyHeal(attacker, ally, healAmount, true, true, ability)
			end
		end	
	end
end

function modifierClass:OnCastEAbility()
	local ability = self:GetAbility()
	local hero = self:GetParent()
	ability.shieldCapacity = (ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_CLOAK_OF_THE_CIMMERIAN_PRIESTHOOD_SAPPHIRE)/100)*hero:GetMaxHealth()
	hero:AddNewModifier(hero, ability, "modifier_cimmerian_priest_e_shield", {duration = ITEM_RPC_CLOAK_OF_THE_CIMMERIAN_PRIESTHOOD_SAPPHIRE_DURATION})
end

function modifierClass:OnCastRAbility()
	local hero = self:GetParent()
	local ability = self:GetAbility()
	local radius = ITEM_RPC_CLOAK_OF_THE_CIMMERIAN_PRIESTHOOD_AMETHYST_RADIUS
	local duration = ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_CLOAK_OF_THE_CIMMERIAN_PRIESTHOOD_AMETHYST)
	local enemies = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if ability:GetGemValue("amethyst") > 0 then
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				if enemy.pushLock or enemy.dummy then
				else
					local direction = ((enemy:GetAbsOrigin() - hero:GetAbsOrigin())*Vector(1,1,0)):Normalized()
					local targetPosition = enemy:GetAbsOrigin() + direction * 200 * duration
					enemy:MoveToPosition(targetPosition)
					enemy:AddNewModifier(hero, ability, "modifier_fear", {duration = duration})
					enemy:MoveToPosition(targetPosition)
					CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell_fear_debuff.vpcf", enemy, duration)
				end
			end
		end	
		EmitSoundOn("RPCItems.Cimmerian.Fear", hero)
		CustomAbilities:QuickParticleAtPoint("particles/roshpit/items/cloak_of_cimmerian_priesthood/fear_ring.vpcf", hero:GetAbsOrigin(), 2)
	end
end

-- RUBY Q DOT

function priest_q_dot:IsDebuff()
	return true
end

function priest_q_dot:GetEffectName()
	return "particles/roshpit/items/cloak_of_cimmerian_priesthood/q_dot.vpcf"
end

function priest_q_dot:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end

function priest_q_dot:OnCreated()
	if not IsServer() then
		return false
	end
	
	local ability = self:GetAbility()
	self:StartIntervalThink(ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_CLOAK_OF_THE_CIMMERIAN_PRIESTHOOD_RUBY1))
end

function priest_q_dot:OnRemoved()
	if not IsServer() then
		return false
	end
	-- clean up dotadata
	local parent = self:GetParent()
	local ability = self:GetAbility()
	if ability then
		ability.dotTable[parent:GetEntityIndex()] = nil
	end
end

function priest_q_dot:OnIntervalThink()
	if not IsServer() then
		return false
	end
	local ability = self:GetAbility()	
	local target = self:GetParent()
	local hero = ability:GetCaster()
	local damage = ability.dotTable[target:GetEntityIndex()]
	Filters:ApplyItemDamage(target, hero, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_SHADOW, RPC_ELEMENT_HOLY)
end

function priest_q_dot:RemoveOnDeath()
	return true
end

-- SAPPHIRE SHIELD

function priest_e_shield:IsHidden()
	return false
end

function priest_e_shield:IsBuff()
	return true
end

function priest_e_shield:RemoveOnDeath()
	return true
end

function priest_e_shield:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_HP_SHIELD
    })
end

function priest_e_shield:HPShieldTakeDamage(event)
	local target = event.victim
	local damage = event.damage
	local ability = self:GetAbility()
	local damage_absorbed = math.min(ability.shieldCapacity, damage)
	ability.shieldCapacity = ability.shieldCapacity - damage_absorbed
	if ability.shieldCapacity <= 0 then
		target:RemoveModifierByName("modifier_cimmerian_priest_e_shield")
	end
	return damage_absorbed
end

function priest_e_shield:GetEffectName()
	return "particles/roshpit/items/cloak_of_cimmerian_priesthood/e_shield.vpcf"
end

function priest_e_shield:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end


