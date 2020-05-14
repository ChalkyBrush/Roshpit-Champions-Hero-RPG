require('items/lua/body/base_chest')
require('npc_abilities/base_modifier')

item_rpc_cloak_of_isolation = class(BaseBody, nil, BaseBody)
modifier_cloak_of_isolation = class(npc_base_modifier, nil, npc_base_modifier)
local itemClass = item_rpc_cloak_of_isolation
local itemClassName = 'item_rpc_cloak_of_isolation'

local modifierClass = modifier_cloak_of_isolation
local modifierName = 'modifier_cloak_of_isolation'
LinkLuaModifier(modifierName, "items/lua/body/cloak_of_isolation", LUA_MODIFIER_MOTION_NONE)

modifier_cloak_of_isolation_aura_effect = class(npc_base_modifier, nil, npc_base_modifier)
local isolation_aura_effect = modifier_cloak_of_isolation_aura_effect
LinkLuaModifier("modifier_cloak_of_isolation_aura_effect", "items/lua/body/cloak_of_isolation", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'Cloak of Isolation'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:HasRuneSlots()
    return true
end
function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_cloak_of_isolation"
    self:SetSpecialValue("cloak_of_isolation", "#a26aa3")
end
function itemClass:RollProperty2(item_level)
    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, rune_type, 1.5)
end

function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 1.5)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 1.5)
end

------------
--MODIFIER--
------------

function modifierClass:IsHidden()
    return true
end

function modifierClass:IsBuff()
    return true
end

function modifierClass:RemoveOnDeath()
    return false
end

function modifierClass:OnCreated()
    if not IsServer() then return end

    self:SetSpecialTypes({ 
        MODIFIER_SPECIAL_TYPE_ORDER_FILTER,
        MODIFIER_ROSHPIT_ARMOR_BONUS,
        MODIFIER_ROSHPIT_MAGIC_ARMOR_BONUS
    })
    local ability = self:GetAbility()
    ability.hero = self:GetParent()
end

function modifierClass:IsAura()
	return true
end

function modifierClass:IsAuraActiveOnDeath()
    return false
end

function modifierClass:RemoveOnDeath()
    return false
end

function modifierClass:GetAuraRadius()
	local ability = self:GetAbility()
    return ability:GetIsolationRadius()
end

function itemClass:GetIsolationRadius()
	return ITEM_RPC_CLOAK_OF_ISOLATION_RANGE + self:GetFinalGemPropertyValue("ruby", ITEM_RPC_CLOAK_OF_ISOLATION_GEM_RUBY)
end

function modifierClass:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifierClass:GetAuraSearchType()
    return (DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC)
end

function modifierClass:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifierClass:GetModifierAura()
    return "modifier_cloak_of_isolation_aura_effect"
end

function modifierClass:GetRoshpitArmorBonus()
	local ability = self:GetAbility()
	local hero = self:GetParent()
	if ability:GetGemValue("sapphire") > 0 then
		local enemies = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin(), nil, ITEM_RPC_CLOAK_OF_ISOLATION_SAPPHIRE_RANGE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			return 0
		else
			return ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_CLOAK_OF_ISOLATION_GEM_SAPPHIRE)
		end
	end
end

function modifierClass:GetRoshpitMagicArmorBonus()
	local ability = self:GetAbility()
	local hero = self:GetParent()
	if ability:GetGemValue("sapphire") > 0 then
		local enemies = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin(), nil, ITEM_RPC_CLOAK_OF_ISOLATION_SAPPHIRE_RANGE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			return 0
		else
			return ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_CLOAK_OF_ISOLATION_GEM_SAPPHIRE)
		end
	end
end

function modifierClass:OnOrderFilter(data)
    local ability = self:GetAbility()
    local hero = self:GetParent()
    local allowedOrderTypes = {
        [DOTA_UNIT_ORDER_HOLD_POSITION] = true,
        [DOTA_UNIT_ORDER_STOP] = true
    }
    if not allowedOrderTypes[data.order_type] then
        return
    end
    if ability:GetCooldownTimeRemaining() > 0 or ability:GetGemValue("amethyst") == 0 then
        return false
    end

    local pfx2 = CustomAbilities:QuickAttachParticle("particles/roshpit/conjuror/shadow_deity_cloak_of_shadows.vpcf", hero, 2)
    ParticleManager:SetParticleControl(pfx2, 1, Vector(200, 200, 200))
    EmitSoundOn("RPC.DeathWhisper.Invis", hero)

    local invis_duration = ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_CLOAK_OF_ISOLATION_GEM_AMETHYST)
    hero:AddNewModifier(hero, ability, "modifier_persistent_invisibility", {duration = invis_duration})
    ProjectileManager:ProjectileDodge(hero)
    local cooldown = ITEM_RPC_CLOAK_OF_ISOLATION_AMETHYST_COOLDOWN
    cooldown = Filters:AdjustCooldownForDotaCooldownRate(cooldown)
    ability:StartCooldown(cooldown)
end

-- AURA EFFECT

function isolation_aura_effect:OnCreated()
    if not IsServer() then return end
    self:StartIntervalThink(0.03)
end

function isolation_aura_effect:DeclareFunctions()
    local funcs = {
    	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
    return funcs
end

function isolation_aura_effect:IsHidden()
	return false
end

function isolation_aura_effect:RemoveOnDeath()
	return true
end

function isolation_aura_effect:GetModifierMoveSpeedBonus_Percentage()
	return ITEM_RPC_CLOAK_OF_ISOLATION_MOVESPEED_REDUCE
end

function isolation_aura_effect:OnIntervalThink()
	if not IsServer() then return end

	local target = self:GetParent()
	local ability = self:GetAbility()
	local hero = ability.hero
	if target.pushLock then
		return false
	end

	local distance_from_center = WallPhysics:GetDistance2d(hero:GetAbsOrigin(), target:GetAbsOrigin())

	local base_push_force = ITEM_RPC_CLOAK_OF_ISOLATION_BASE_FORCE
	local pushForce = base_push_force * (1 - distance_from_center/ability:GetIsolationRadius())
	pushForce = pushForce * (1 + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_CLOAK_OF_ISOLATION_GEM_EMERALD)/100)
	local fv = ((target:GetAbsOrigin() - hero:GetAbsOrigin())*Vector(1,1,0)):Normalized()

	local newPosition = GetGroundPosition(target:GetAbsOrigin() + fv*pushForce, target)
	local obstruction = WallPhysics:FindNearestObstruction(newPosition)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition, target)
	if not blockUnit and pushForce > 0 then
		target:SetAbsOrigin(newPosition)
	end
end

function isolation_aura_effect:OnRemoved()
	if not IsServer() then return end
	local unit = self:GetParent()
	FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), false)

end