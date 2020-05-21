require('items/lua/helm/base_helm')
require('npc_abilities/base_modifier')

item_rpc_sun_gods_visage = class(BaseHelm, nil, BaseHelm)
local itemClass = item_rpc_sun_gods_visage
local itemClassName = 'item_rpc_sun_gods_visage'

modifier_sun_gods_visage = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_sun_gods_visage
local modifierName = 'modifier_sun_gods_visage'
LinkLuaModifier(modifierName, "items/lua/helm/sun_gods_visage", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return "Sun God's Visage"
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:HasRuneSlots()
    return true
end

function itemClass:RollProperty1(maxFactor)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_sun_gods_visage"
    self:SetSpecialValue("sun_gods_visage", "#fcc46f")
end
function itemClass:RollProperty2(item_level) 
    local luck = RandomInt(1, 8)
    if luck < 6 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, rune_type, 1.5)
    elseif luck == 6 then
    	RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "element_fire", 2)
    elseif luck == 7 then
    	RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "health_regen", 2)
    else
        RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "t3_rune", 1)
    end
end

function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 1)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 2.5)
end

------------
--MODIFIER--
------------

function modifierClass:RemoveOnDeath()
    return false
end

function modifierClass:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_SPIRIT_BONUS,
        MODIFIER_ROSHPIT_AGILITY_BONUS,
        MODIFIER_ROSHPIT_MAGIC_ARMOR_BONUS, 
        MODIFIER_ROSHPIT_SPELL_PIERCE_BONUS
    })
	self:StartIntervalThink(ITEM_RPC_SUN_GODS_VISAGE_INTERVAL)
	self:adjust_or_create_pfx()

end

function modifierClass:OnIntervalThink()
	if not IsServer() then
		return false
	end
	local hero = self:GetParent()
	local ability = self:GetAbility()
	local healthRemoval = hero:GetHealth()*(((ITEM_RPC_SUN_GODS_VISAGE_HEALTH_DRAIN+ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_SUN_GODS_VISAGE_RUBY))/100))
	local heal = (hero:GetMaxHealth() - hero:GetHealth())*(((ITEM_RPC_SUN_GODS_VISAGE_HEAL+ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_SUN_GODS_VISAGE_RUBY))/100))
	hero:SetHealth(math.max(hero:GetHealth() - healthRemoval, 1))
	Filters:ApplyHeal(hero, hero, heal, true, true, self:GetAbility())
end

function modifierClass:adjust_or_create_pfx()
	local particleName = "particles/roshpit/items/sun_gods_buff.vpcf"
	if not self:GetAbility().pfx then
		self:GetAbility().pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(self:GetAbility().pfx, 0, self:GetParent(), PATTACH_CUSTOMORIGIN_FOLLOW, "attach_origin", self:GetParent():GetAbsOrigin(), true)
	end
end

function modifierClass:OnDestroy()
	if self:GetAbility().pfx then
		ParticleManager:DestroyParticle(self:GetAbility().pfx, false)
		self:GetAbility().pfx = false
	end	
end

function modifierClass:GetRoshpitSpiritBonus()
	if not IsServer() then
		return false
	end
	if self:GetAbility():GetGemValue("emerald") > 0 then
		local hero = self:GetParent()
		local heroHealthPercent = ((hero:GetHealth()/hero:GetMaxHealth())*100)
		if heroHealthPercent >= ITEM_RPC_SUN_GODS_VISAGE_EMERALD_LOWER_BOUND and heroHealthPercent <= ITEM_RPC_SUN_GODS_VISAGE_EMERALD_UPPER_BOUND then
			return self:GetAbility():GetFinalGemPropertyValue("emerald", ITEM_RPC_SUN_GODS_VISAGE_EMERALD)
		else
			return 0
		end
	else
		return 0
	end
end

function modifierClass:GetRoshpitAgilityBonus()
	if not IsServer() then
		return false
	end
	if self:GetAbility():GetGemValue("emerald") > 0 then
		local hero = self:GetParent()
		local heroHealthPercent = ((hero:GetHealth()/hero:GetMaxHealth())*100)
		if heroHealthPercent >= ITEM_RPC_SUN_GODS_VISAGE_EMERALD_LOWER_BOUND and heroHealthPercent <= ITEM_RPC_SUN_GODS_VISAGE_EMERALD_UPPER_BOUND then
			return self:GetAbility():GetFinalGemPropertyValue("emerald", ITEM_RPC_SUN_GODS_VISAGE_EMERALD)
		else
			return 0
		end
	else
		return 0
	end
end

function modifierClass:GetRoshpitMagicArmorBonus()
    return self:GetAbility():GetFinalGemPropertyValue("sapphire", ITEM_RPC_SUN_GODS_VISAGE_SAPPHIRE1)*(self:GetParent():GetHealth())
end

function modifierClass:GetRoshpitSpellPierceBonus()
    return self:GetAbility():GetFinalGemPropertyValue("sapphire", ITEM_RPC_SUN_GODS_VISAGE_SAPPHIRE2)*(self:GetParent():GetMaxHealth() - self:GetParent():GetHealth())
end