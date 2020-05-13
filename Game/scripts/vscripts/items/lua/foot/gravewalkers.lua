require('items/lua/foot/base_boot')
require('npc_abilities/base_modifier')

item_rpc_gravewalkers = class(BaseFoot, nil, BaseFoot)

local itemClass = item_rpc_gravewalkers
local itemClassName = 'item_rpc_gravewalkers'

modifier_gravewalkers = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_gravewalkers
local modifierName = 'modifier_gravewalkers'
LinkLuaModifier(modifierName, "items/lua/foot/gravewalkers", LUA_MODIFIER_MOTION_NONE)

modifier_gravewalker_dancing_skeleton = class(npc_base_modifier, nil, npc_base_modifier)
local dancing_skeleton_modifier = modifier_gravewalker_dancing_skeleton
LinkLuaModifier('modifier_gravewalker_dancing_skeleton', "items/lua/foot/gravewalkers", LUA_MODIFIER_MOTION_NONE)

modifier_gravewalker_sapphire_skeleton_projectile = class(npc_base_modifier, nil, npc_base_modifier)
local sapphire_skeleton_projectile_modifier = modifier_gravewalker_sapphire_skeleton_projectile
LinkLuaModifier('modifier_gravewalker_sapphire_skeleton_projectile', "items/lua/foot/gravewalkers", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'Gravewalkers'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:HasRuneSlots()
    return true
end
function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_gravewalkers"
    self:SetSpecialValue("gravewalkers", "#61fcff")
end
function itemClass:RollProperty2(item_level)
    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 40, tier2 = 80, tier3 = 100})
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, rune_type, 1.5)
end
function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 1.75)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 1.75)
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
        MODIFIER_SPECIAL_TYPE_ORDER_FILTER
    })

end

function modifierClass:OnOrderFilter(data)
    local ability = self:GetAbility()
    local parent = self:GetParent()
    local allowedOrderTypes = {
        [DOTA_UNIT_ORDER_HOLD_POSITION] = true,
        [DOTA_UNIT_ORDER_STOP] = true
    }
    if not allowedOrderTypes[data.order_type] then
        return
    end
    if ability:GetCooldownTimeRemaining() > 0 then
        return false
    end
    
    self:DancingSkeletonInit(parent)
	local cooldown = ITEM_RPC_GRAVEWALKERS_COOLDOWN - ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_GRAVEWALKERS_GEM_SAPPHIRE)
	cooldown = Filters:AdjustCooldownForDotaCooldownRate(cooldown)
	ability:StartCooldown(cooldown)
end

function modifierClass:OnRemoved()
	if not IsServer() then
		return false
	end
	local parent = self:GetParent()
	parent:RemoveModifierByName("modifier_gravewalker_dancing_skeleton")
end

function modifierClass:DancingSkeletonInit(hero)
	local ability = self:GetAbility()
	if not hero:HasModifier("modifier_gravewalker_dancing_skeleton") then
		EmitSoundOn("RPCItems.Gravewalkers.DancingSkeleton", hero)
	end
	local duration = ITEM_RPC_GRAVEWALKERS_BASE_DURATION + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_GRAVEWALKERS_GEM_RUBY1)
	hero:RemoveModifierByName("modifier_gravewalker_dancing_skeleton")
	hero:AddNewModifier(hero, ability, "modifier_gravewalker_dancing_skeleton", {duration = duration})
	local pfx = ParticleManager:CreateParticle("particles/roshpit/items/gravekeeper_revealed_dancing_skeleton.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(pfx, 0, hero, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", hero:GetAbsOrigin(), true)
	local angle = WallPhysics:vectorToAngle(hero:GetForwardVector())
	ParticleManager:SetParticleControl(pfx, 2, Vector(angle, angle, angle)/45)
	ability.pfx = pfx
	local walk_away_distance = ITEM_RPC_GRAVEWALKERS_WALKWAY_DISTANCE + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_GRAVEWALKERS_GEM_RUBY2)
	local deaggro_range = ITEM_RPC_GRAVEWALKERS_RANGE + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_GRAVEWALKERS_GEM_RUBY3)
    local enemies = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin(), nil, deaggro_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    if #enemies > 0 then
        for _, enemy in pairs(enemies) do
            if enemy.aggro then
            	Dungeons:DeaggroUnit(enemy)
            end
            local fv = ((enemy:GetAbsOrigin() - hero:GetAbsOrigin())*Vector(1,1,0)):Normalized()
            enemy:MoveToPosition(enemy:GetAbsOrigin() + fv*walk_away_distance)
        end
    end
    
end

-- DANCING SKELETON MODIFIER

function dancing_skeleton_modifier:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({
        MODIFIER_SPECIAL_TYPE_ORDER_FILTER,
        MODIFIER_ROSHPIT_PHYSICAL_DMG_REDUCTION,
        MODIFIER_ROSHPIT_MAGICAL_DMG_REDUCTION,
        MODIFIER_ROSHPIT_PURE_DMG_REDUCTION,
    })
    local parent = self:GetParent()
    parent:AddNoDraw()
    self:StartIntervalThink(0.2)
end

function dancing_skeleton_modifier:OnIntervalThink()
	if not IsServer() then
		return false
	end
	EmitSoundOn("RPCItems.Gravewalkers.DancingBonesSound", self:GetParent())
end

function dancing_skeleton_modifier:CheckState()
    local state = {
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_SILENCED] = true
    }

    return state
end

function dancing_skeleton_modifier:OnDestroy()
	if not IsServer() then
		return false
	end
	local ability = self:GetAbility()
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, true)
		ability.pfx = nil
	end
    local parent = self:GetParent()
    parent:RemoveNoDraw()
    CustomAbilities:QuickParticleAtPoint("particles/roshpit/items/musty_crypt_transform.vpcf", parent:GetAbsOrigin(), 3)
end	

function dancing_skeleton_modifier:OnOrderFilter(data)
    local ability = self:GetAbility()
    local parent = self:GetParent()
    local allowedOrderTypes = {
        [DOTA_UNIT_ORDER_MOVE_TO_TARGET] = true,
        [DOTA_UNIT_ORDER_MOVE_TO_POSITION] = true,
        [DOTA_UNIT_ORDER_HOLD_POSITION] = true,
        [DOTA_UNIT_ORDER_STOP] = true
    }
    if not allowedOrderTypes[data.order_type] then
        return
    end
    if data.order_type == DOTA_UNIT_ORDER_HOLD_POSITION or data.order_type == DOTA_UNIT_ORDER_STOP then
    	if ability:GetGemValue("emerald") > 0 then
    		parent:RemoveModifierByName("modifier_gravewalker_dancing_skeleton")
    	end
    else
	    local position = Vector(data.position_x, data.position_y)
	    if data.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
	        local target = EntIndexToHScript(data.entindex_target)
	        position = target:GetAbsOrigin()
	    end
	    if ability:GetGemValue("emerald") > 0 then
	    	self:EmeraldProjectile(position)
	    else
	    	parent:RemoveModifierByName("modifier_gravewalker_dancing_skeleton")
	    end
	end

end

function dancing_skeleton_modifier:EmeraldProjectile(position)
	local ability = self:GetAbility()
	local hero = self:GetParent()
	local fv = ((position - hero:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	local range = ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_GRAVEWALKERS_GEM_EMERALD1)
	local distance = WallPhysics:GetDistance2d(position, hero:GetAbsOrigin())
	if distance < range then
		range = distance
	end
	local speed = ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_GRAVEWALKERS_GEM_EMERALD2)
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, true)
		ability.pfx = nil
		CustomAbilities:QuickParticleAtPoint("particles/roshpit/items/musty_crypt_transform.vpcf", hero:GetAbsOrigin(), 3)
	end
	local info =
	{
		Ability = ability,
		EffectName = "particles/roshpit/items/gravewalker_projectile.vpcf",
		vSpawnOrigin = hero:GetAbsOrigin(),
		fDistance = range,
		fStartRadius = 100,
		fEndRadius = 100,
		Source = hero,
		StartPosition = "attach_origin",
		bHasFrontalCone = true,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 8.0,
		bDeleteOnHit = false,
		vVelocity = fv * speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)

	local targetPoint = hero:GetAbsOrigin() + fv*range
	local duration = range/speed
	Timers:CreateTimer(0.03, function()
		hero:AddNewModifier(hero, ability, 'modifier_gravewalker_sapphire_skeleton_projectile', {duration = duration})
	end)
	ability.sapphire_point = targetPoint
end

function itemClass:OnProjectileHit( hTarget, vLocation )
	return false
end

function dancing_skeleton_modifier:GetPhysicalDamageReduction()
	local ability = self:GetAbility()
	return ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_GRAVEWALKERS_GEM_AMETHYST)/100
end

function dancing_skeleton_modifier:GetMagicalDamageReduction()
	local ability = self:GetAbility()
	return ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_GRAVEWALKERS_GEM_AMETHYST)/100
end

function dancing_skeleton_modifier:GetPureDamageReduction()
	local ability = self:GetAbility()
	return ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_GRAVEWALKERS_GEM_AMETHYST)/100
end

-- projectile modifier

function sapphire_skeleton_projectile_modifier:IsHidden()
	return true
end

function sapphire_skeleton_projectile_modifier:CheckState()
    local state = {
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
    }

    return state
end

function sapphire_skeleton_projectile_modifier:OnDestroy()
	if not IsServer() then
		return false
	end
	local hero = self:GetParent()
	local ability = self:GetAbility()
	FindClearSpaceForUnit(hero, ability.sapphire_point, false)
	CustomAbilities:QuickParticleAtPoint("particles/roshpit/items/musty_crypt_transform.vpcf", hero:GetAbsOrigin(), 3)
	if hero:HasModifier("modifier_gravewalker_dancing_skeleton") then
		local pfx = ParticleManager:CreateParticle("particles/roshpit/items/gravekeeper_revealed_dancing_skeleton.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(pfx, 0, hero, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", hero:GetAbsOrigin(), true)
		ability.pfx = pfx
	end
end