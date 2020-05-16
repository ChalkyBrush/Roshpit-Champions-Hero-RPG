require('items/lua/helm/base_helm')
require('npc_abilities/base_modifier')

item_rpc_lich_kings_gaze = class(BaseHelm, nil, BaseHelm)
local itemClass = item_rpc_lich_kings_gaze
local itemClassName = 'item_rpc_lich_kings_gaze'

modifier_lich_kings_gaze = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_lich_kings_gaze
local modifierName = 'modifier_lich_kings_gaze'
LinkLuaModifier(modifierName, "items/lua/helm/lich_kings_gaze", LUA_MODIFIER_MOTION_NONE)

modifier_lich_king_gaze_slow = class(npc_base_modifier, nil, npc_base_modifier)
local slow_modifier = modifier_lich_king_gaze_slow
LinkLuaModifier('modifier_lich_king_gaze_slow', "items/lua/helm/lich_kings_gaze", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return "Lich King's Gaze"
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:HasRuneSlots()
    return true
end

function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_lich_kings_gaze"
    self:SetSpecialValue("lich_kings_gaze", "#839ca8")
end
function itemClass:RollProperty2(item_level)
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "t4_rune", 2)
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

    })
    local ability = self:GetAbility()
    local think_interval = ITEM_RPC_LICH_KINGS_GAZE_BASE_INTERVAL - ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_LICH_KINGS_GAZE_EMERALD)
    self:StartIntervalThink(think_interval)
end

function modifierClass:DeclareFunctions()
    local funcs = {

    }

    return funcs
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

function modifierClass:OnIntervalThink()
    if not IsServer() then
        return
    end
    local ability = self:GetAbility()
    local hero = self:GetParent()
    local allowed_targets = {}
    local range = ITEM_RPC_LICH_KINGS_GAZE_CIRCLE_RANGE + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_LICH_KINGS_GAZE_RUBY1)
    local angle_range = ITEM_RPC_LICH_KINGS_GAZE_ANGLE_RANGE + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_LICH_KINGS_GAZE_RUBY2)
	local enemies = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			local positionFV = ((enemy:GetAbsOrigin() - hero:GetAbsOrigin())*Vector(1,1,0)):Normalized()
			local angle_between = WallPhysics:angle_between_vectors(positionFV, hero:GetForwardVector())
			if angle_between > -angle_range/2 and angle_between < angle_range/2 then
				table.insert(allowed_targets, enemy)
			end
		end
	end  
	local damage = OverflowProtectedGetAverageTrueAttackDamage(hero)*(ITEM_RPC_LICH_KINGS_GAZE_DAMAGE_PCT_ATK_POWER/100)  
	if #allowed_targets > 0 then
		EmitSoundOn("RPCItems.LichKingGaze.Activate", hero)
		local max_targets = ITEM_RPC_LICH_KINGS_GAZE_BASE_MAX_TARGETS + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_LICH_KINGS_GAZE_SAPPHIRE)
		local limit = math.min(max_targets, #allowed_targets)
		for i = 1, limit, 1 do 
			local target = allowed_targets[i]
		    local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/items/lich_king_ice_wrath.vpcf", hero, 3)
		    ParticleManager:SetParticleControl(pfx, 1, target:GetAbsOrigin()+target:GetBoundingMaxs().z)
		    Filters:ApplyItemDamage(target, hero, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_ICE)
		    target:AddNewModifier(hero, ability, "modifier_lich_king_gaze_slow", {duration = ITEM_RPC_LICH_KINGS_GAZE_SLOW_DURATION})			
		end
	end
	if #allowed_targets == 1 and ability:GetGemValue("amethyst") > 0 then
		local target = allowed_targets[1]
		local extra_attacks = ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_LICH_KINGS_GAZE_AMETHYST)
		local fvToTarget = ((target:GetAbsOrigin() - hero:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		for i = 1, extra_attacks, 1 do
			local positionOffsetMult = i - extra_attacks/2 + 0.5
			local offsetFV = WallPhysics:rotateVector(fvToTarget, 2*math.pi*positionOffsetMult/12)
			local offsetPosition = hero:GetAbsOrigin() + offsetFV*300
		    local pfx1 = CustomAbilities:QuickAttachParticle("particles/roshpit/items/lich_king_ice_wrath.vpcf", hero, 3)
		    ParticleManager:SetParticleControl(pfx1, 1, offsetPosition)
		    local pfx2 = CustomAbilities:QuickAttachParticle("particles/roshpit/items/lich_king_ice_wrath.vpcf", target, 3)
		    ParticleManager:SetParticleControl(pfx2, 1, offsetPosition)		 
		    Filters:ApplyItemDamage(target, hero, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_ICE)
		    target:AddNewModifier(hero, ability, "modifier_lich_king_gaze_slow", {duration = ITEM_RPC_LICH_KINGS_GAZE_SLOW_DURATION})   			
		end
	end
end

-- SLOW MODIFIER

function slow_modifier:IsDebuff()
	return true
end

function slow_modifier:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost_lich.vpcf"
end

function slow_modifier:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function slow_modifier:DeclareFunctions()
    local funcs = {
    	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return funcs
end

function slow_modifier:GetModifierMoveSpeedBonus_Percentage()
	return ITEM_RPC_LICH_KINGS_GAZE_MOVE_SLOW
end