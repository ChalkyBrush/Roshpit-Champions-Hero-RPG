require('items/lua/foot/base_boot')
require('npc_abilities/base_modifier')

item_rpc_boots_of_temperance = class(BaseFoot, nil, BaseFoot)

local itemClass = item_rpc_boots_of_temperance
local itemClassName = 'item_rpc_boots_of_temperance'

modifier_boots_of_temperance = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_boots_of_temperance
local modifierName = 'modifier_boots_of_temperance'
LinkLuaModifier(modifierName, "items/lua/foot/boots_of_temperance", LUA_MODIFIER_MOTION_NONE)

modifier_temperance_disarm = class(npc_base_modifier, nil, npc_base_modifier)
local disarm_modifier = modifier_temperance_disarm
LinkLuaModifier("modifier_temperance_disarm", "items/lua/foot/boots_of_temperance", LUA_MODIFIER_MOTION_NONE)

modifier_temperance_sapphire_slow = class(npc_base_modifier, nil, npc_base_modifier)
local sapphire_slow = modifier_temperance_sapphire_slow
LinkLuaModifier("modifier_temperance_sapphire_slow", "items/lua/foot/boots_of_temperance", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'Hangman Slippers'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:HasRuneSlots()
    return true
end
function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_boots_of_temperance"
    self:SetSpecialValue("boots_of_temperance", "#86ebe4")
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

-- MODIFIER

function modifierClass:IsHidden()
	return true
end

function modifierClass:RemoveOnDeath()
	return false
end

function modifierClass:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_Q_BASE_ABILITY_MAX_OVERRIDE,
        MODIFIER_ROSHPIT_W_BASE_ABILITY_MAX_OVERRIDE,
        MODIFIER_ROSHPIT_E_BASE_ABILITY_MAX_OVERRIDE,
        MODIFIER_ROSHPIT_R_BASE_ABILITY_MAX_OVERRIDE,
        MODIFIER_ROSHPIT_PHYSICAL_DMG_REDUCTION,
        MODIFIER_ROSHPIT_MAGICAL_DMG_REDUCTION,
        MODIFIER_ROSHPIT_PURE_DMG_REDUCTION,
        MODIFIER_ROSHPIT_FLAT_HEALTH_BONUS,
        MODIFIER_ROSHPIT_FLAT_MANA_BONUS,
        MODIFIER_ROSHPIT_MASTER_GREEN_DMG,
        MODIFIER_ROSHPIT_ARMOR_BONUS,
        MODIFIER_ROSHPIT_MAGIC_ARMOR_BONUS,
        MODIFIER_ROSHPIT_ARMOR_PIERCE_BONUS,
        MODIFIER_ROSHPIT_SPELL_PIERCE_BONUS,
        MODIFIER_SPECIAL_TYPE_ORDER_FILTER
    })	
end

function modifierClass:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACKED
    }
    return funcs
end

function modifierClass:OnDestroy()
	if not IsServer() then
		return false
	end
	local ability = self:GetAbility()
end

function modifierClass:GetPhysicalDamageReduction()
	return ITEM_RPC_BOOTS_OF_TEMPERANCE_DMG_REDUCTION/100
end

function modifierClass:GetMagicalDamageReduction()
	return ITEM_RPC_BOOTS_OF_TEMPERANCE_DMG_REDUCTION/100
end

function modifierClass:GetPureDamageReduction()
	return ITEM_RPC_BOOTS_OF_TEMPERANCE_DMG_REDUCTION/100
end

function modifierClass:GetRoshpitQBADMaxOverride()
	return ITEM_RPC_BOOTS_OF_TEMPERANCE_BAD_CAP
end

function modifierClass:GetRoshpitWBADMaxOverride()
	return ITEM_RPC_BOOTS_OF_TEMPERANCE_BAD_CAP
end

function modifierClass:GetRoshpitEBADMaxOverride()
	return ITEM_RPC_BOOTS_OF_TEMPERANCE_BAD_CAP
end

function modifierClass:GetRoshpitRBADMaxOverride()
	return ITEM_RPC_BOOTS_OF_TEMPERANCE_BAD_CAP
end

function modifierClass:GetRoshpitMasterGreenDMG()
	local ability = self:GetAbility()
	return ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_BOOTS_OF_TEMPERANCE_GEM_RUBY1)
end

function modifierClass:GetFlatHealthBonus()
	local ability = self:GetAbility()
	return ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_BOOTS_OF_TEMPERANCE_GEM_RUBY2)
end

function modifierClass:GetFlatManaBonus()
	local ability = self:GetAbility()
	return ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_BOOTS_OF_TEMPERANCE_GEM_RUBY3)
end

function modifierClass:GetRoshpitArmorBonus()
	local ability = self:GetAbility()
	return ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_BOOTS_OF_TEMPERANCE_GEM_EMERALD2)
end

function modifierClass:GetRoshpitMagicArmorBonus()
	local ability = self:GetAbility()
	return ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_BOOTS_OF_TEMPERANCE_GEM_EMERALD2)
end

function modifierClass:GetRoshpitSpellPierceBonus()
	local ability = self:GetAbility()
	return ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_BOOTS_OF_TEMPERANCE_GEM_EMERALD1)
end

function modifierClass:GetRoshpitArmorPierceBonus()
	local ability = self:GetAbility()
	return ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_BOOTS_OF_TEMPERANCE_GEM_EMERALD1)
end

function modifierClass:OnOrderFilter(data)
    local ability = self:GetAbility()
    local hero = self:GetParent()
    local allowedOrderTypes = {
        [DOTA_UNIT_ORDER_ATTACK_TARGET] = true
    }
    if not allowedOrderTypes[data.order_type] then
        return
    end
    if ability:GetCooldownTimeRemaining() > 0 then
        return false
    end
    if ability:GetGemValue("sapphire") == 0 then
    	return false
    end
    local enemy = EntIndexToHScript(data.entindex_target)
    local distance = WallPhysics:GetDistance2d(enemy:GetAbsOrigin(), hero:GetAbsOrigin())
    if distance <= ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_BOOTS_OF_TEMPERANCE_GEM_SAPPHIRE1) then
    	self:SapphireSwapPosition(enemy)


	    local cooldown = ITEM_RPC_BOOTS_OF_TEMPERANCE_SAPPHIRE_CD
	    cooldown = Filters:AdjustCooldownForDotaCooldownRate(cooldown)
	    ability:StartCooldown(cooldown)
	end
end

function modifierClass:SapphireSwapPosition(enemy)
    local ability = self:GetAbility()
    local hero = self:GetParent()

	local enemyPosition = enemy:GetAbsOrigin()
	local heroPosition = hero:GetAbsOrigin()

	local pfx1 = CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_vengeful/vengeful_nether_swap.vpcf", hero, 3)
	ParticleManager:SetParticleControl(pfx1, 1, enemyPosition)

	local pfx2 = CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_vengeful/vengeful_nether_swap.vpcf", enemy, 3)
	ParticleManager:SetParticleControl(pfx2, 1, heroPosition)

	if not enemy.pushLock then
		FindClearSpaceForUnit(enemy, heroPosition, false)
	end
	FindClearSpaceForUnit(hero, enemyPosition, false)
	SpecialFX:ColoredPop(enemyPosition, Vector(80, 120, 255))
	SpecialFX:ColoredPop(heroPosition, Vector(80, 120, 255))
	EmitSoundOn("RPCItems.Temperance.Swap", hero)

	enemy:AddNewModifier(hero, ability, "modifier_temperance_sapphire_slow", {duration = ITEM_RPC_BOOTS_OF_TEMPERANCE_SAPPHIRE_SLOW_DURATION})
end

function modifierClass:OnAttacked(event)
	local attacker = event.attacker
	local hero = self:GetParent()
	if not hero == event.target then
		return false
	end
	if attacker == hero then
		return false
	end
	local ability = self:GetAbility()
	if ability:GetGemValue("amethyst") > 0 then
		local proc = Filters:GetProc(hero, ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_BOOTS_OF_TEMPERANCE_GEM_AMETHYST))
		if proc then
			attacker:AddNewModifier(hero, ability, "modifier_temperance_disarm", {duration = ITEM_RPC_BOOTS_OF_TEMPERANCE_AMETHYST_DISARM_DURATION})
		end
	end
end

-- disarm_modifier

function disarm_modifier:CheckState()
    local state = {
        [MODIFIER_STATE_DISARMED] = true
    }

    return state
end

function disarm_modifier:IsDebuff()
    return true
end

function disarm_modifier:OnCreated()
	if not IsServer() then
		return false
	end
    EmitSoundOn("RPCItems.Hangman.Disarm", self:GetParent())
end

function disarm_modifier:GetEffectName()
    return "particles/items2_fx/heavens_halberd.vpcf"
end

function disarm_modifier:GetEffectAttachType()
    return PATTACH_CUSTOMORIGIN_FOLLOW
end

-- sapphire slow

function sapphire_slow:IsDebuff()
	return true
end

function sapphire_slow:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
    return funcs
end

function sapphire_slow:GetModifierMoveSpeedBonus_Percentage()
	local ability = self:GetAbility()
	if not IsServer() then
		return -20
	else
		return ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_BOOTS_OF_TEMPERANCE_GEM_SAPPHIRE2)
	end
end