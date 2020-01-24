require('items/lua/helm/base')
require('npc_abilities/base_modifier')

item_rpc_twisted_blue_mask_of_ahnqhir = class(BaseHelm, nil, BaseHelm)
local itemClass = item_rpc_twisted_blue_mask_of_ahnqhir
local itemClassName = 'item_rpc_twisted_blue_mask_of_ahnqhir'

modifier_twisted_blue_mask_of_ahnqhir = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_twisted_blue_mask_of_ahnqhir
local modifierName = 'modifier_twisted_blue_mask_of_ahnqhir'
LinkLuaModifier(modifierName, "items/lua/helm/twisted_blue_mask_of_ahnqhir", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return "Twisted Blue Mask of Ahn'Qhir"
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:HasRuneSlots()
    return true
end
function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_twisted_blue_mask_of_ahnqhir"
    self:SetSpecialValue("twisted_blue_mask_of_ahnqhir", "#6BB5F9")
end
function itemClass:RollProperty2(item_level)
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "rune_e_3", 1)
end

function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 2)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 2)
end

------------
--MODIFIER--
------------

function modifierClass:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_E_PCT_CD_MOD,
    })  
    self:StartIntervalThink(1)
end
function modifierClass:OnIntervalThink()
    if not IsServer() then
        return
    end	
	local pointAbility = self:GetParent():GetAbilityByIndex(DOTA_E_SLOT)
	if pointAbility then
		if pointAbility.ahnqhirPoint then
		else
			pointAbility.ahnqhirPoint = pointAbility:GetCastPoint()
			pointAbility:SetOverrideCastPoint(0.05)
		end
	end
end
function modifierClass:OnDestroy()
    if not IsServer() then
        return
    end	
    local pointAbility = self:GetParent():GetAbilityByIndex(DOTA_E_SLOT)
	if pointAbility then
		if pointAbility.ahnqhirPoint then
			pointAbility:SetOverrideCastPoint(pointAbility.ahnqhirPoint)
			pointAbility.ahnqhirPoint = nil
		else
		end
	end
end
function modifierClass:GetRoshpitEPctCdModifier()
    return - TWISTED_MASK_OF_AHNQHIR_BLUE_CD_RED_PCT / 100
end
function modifierClass:IsHidden()
    return true
end
function modifierClass:RemoveOnDeath()
    return false
end
function modifierClass:IsBuff()
    return true
end
function modifierClass:RemoveOnDeath()
    return false
end