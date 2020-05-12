require('/items/lua/trinket/base_trinket')
require('/npc_abilities/base_modifier')

item_rpc_mortuary_charm = class(BaseTrinket, nil, BaseTrinket)

local itemClass = item_rpc_mortuary_charm
local itemClassName = 'item_rpc_mortuary_charm'

modifier_mortuary_charm = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_mortuary_charm
local modifierName = 'modifier_mortuary_charm'
LinkLuaModifier(modifierName, "items/lua/trinket/mortuary_charm", LUA_MODIFIER_MOTION_NONE)

modifier_mortuary_ghost = class(npc_base_modifier, nil, npc_base_modifier)
local grave_skeleton_modifier = modifier_mortuary_ghost
LinkLuaModifier('modifier_mortuary_ghost', "items/lua/trinket/mortuary_charm", LUA_MODIFIER_MOTION_NONE)

modifier_mortuary_paralyze = class(npc_base_modifier, nil, npc_base_modifier)
local paralyze_modifier = modifier_mortuary_paralyze
LinkLuaModifier('modifier_mortuary_paralyze', "items/lua/trinket/mortuary_charm", LUA_MODIFIER_MOTION_NONE)

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
    self.newItemTable.property1name = "!immortal!_modifier_mortuary_charm"
    self:SetSpecialValue("mortuary_charm", "#a653e6")
end
function itemClass:RollProperty2(item_level)
    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 40, tier2 = 80, tier3 = 100})
    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, rune_type, 2)
end
function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 0)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 3.5)
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

    })	
    local ability = self:GetAbility()
    ability.disable = false
    local hero = self:GetParent()
    for i = 1, ability:GetSkeletonCount(), 1 do
    	Timers:CreateTimer(i*0.3, function()
    		if not ability.disable then
    			self:SummonSkeletonAlly(i)
    		end
    	end)
    end
end

function modifierClass:OnDestroy()
	if not IsServer() then
		return false
	end
	local ability = self:GetAbility()
	ability.disable = true
	for i = 1, #ability.skeleton_table, 1 do
		local skeleton = ability.skeleton_table[i]
		if skeleton:EntityExistsAndIsAlive() then
			EndAnimation(skeleton)
			skeleton:RemoveModifierByName('modifier_mortuary_ghost')
			skeleton:ForceKill(false)
		end
	end
end

function modifierClass:SummonSkeletonAlly(index)
	local hero = self:GetParent()
	local ability = self:GetAbility()
	if not ability.skeleton_table then
		ability.skeleton_table = {}
	end
	local position = ability:GetSkeletonPositionByIndex(hero, index)
	local skeleton = CreateUnitByName("item_mortuary_charm_ghost", position, false, nil, nil, hero:GetTeamNumber())
	skeleton.owner = hero:GetPlayerOwnerID()
	skeleton.summoner = hero
	skeleton:SetOwner(hero)
	skeleton:SetControllableByPlayer(hero:GetPlayerID(), true)


	skeleton:SetForwardVector(hero:GetForwardVector())
	skeleton:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
	Events:smoothSizeChange(skeleton, 0.01, 1.2, 15)
	skeleton.hero = hero
	local damageInherit = 1
	skeleton:AdjustSummon(hero, true, 1, damageInherit, 1, 1, 1, 1)
	StartAnimation(skeleton, {duration = 99999, activity = ACT_DOTA_INTRO, rate = 0.4})
	CustomAbilities:QuickParticleAtPoint("particles/roshpit/items/mortuary_spawn.vpcf", skeleton:GetAbsOrigin(), 3)
	skeleton.index = index
	skeleton.pushLock = true
	skeleton.jumpLock = true
	skeleton:SetRenderColor(226, 145, 255)
	skeleton:AddNewModifier(hero, ability, 'modifier_mortuary_ghost', {})
	table.insert(ability.skeleton_table, skeleton)
end

function itemClass:GetSkeletonPositionByIndex(hero, index)
	local basePosition = hero:GetAbsOrigin()
	local fv = hero:GetForwardVector()
	local offsetVector = -fv*220
	local rotator_index = index - math.ceil((self:GetSkeletonCount()/2))
	local finalOffset = WallPhysics:rotateVector(offsetVector, 2*math.pi*rotator_index/9)
	return hero:GetAbsOrigin() + finalOffset
end

function itemClass:GetSkeletonCount()
	local ability = self
	return ITEM_RPC_MORTUARY_CHARM_BASE_GHOSTS + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_MORTUARY_CHARM_GEM_RUBY) + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_MORTUARY_CHARM_GEM_SAPPHIRE)
end

-- GRAVE SKELETON
function grave_skeleton_modifier:MaybePlaySound(chance)
	local luck = RandomInt(1, 100)
	if luck <= chance then
		EmitSoundOn("RPCItems.MortuaryCharm.GhostVoice", self:GetParent())
	end
end

function grave_skeleton_modifier:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({
        MODIFIER_ROSHPIT_OVERRIDE_ATTACK_EVENT
    })
    self:GetParent().attackOverride = true
    self:MaybePlaySound(10)	
	self:StartIntervalThink(0.03)
end

function grave_skeleton_modifier:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_EVENT_ON_ATTACK_START
    }
    return funcs
end

function grave_skeleton_modifier:CheckState()
	local state = {
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_UNSELECTABLE] = true,
	[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}

	return state
end

function grave_skeleton_modifier:OnIntervalThink()
	local ability = self:GetAbility()
	local hero = ability:GetCaster()
	local skeleton = self:GetParent()
	local targetPosition = ability:GetSkeletonPositionByIndex(hero, skeleton.index)
	local distance = WallPhysics:GetDistance2d(skeleton:GetAbsOrigin(), targetPosition)
	local extraZ = 80
	local distanceCheck = 400

	targetPosition = GetGroundPosition(targetPosition, skeleton) + Vector(0,0,120+extraZ)
	if distance > 800 then
		skeleton:SetAbsOrigin(targetPosition)
		CustomAbilities:QuickParticleAtPoint("particles/roshpit/items/mortuary_spawn.vpcf", skeleton:GetAbsOrigin(), 3)
	elseif distance > distanceCheck then
		local moveDirection = ((targetPosition - skeleton:GetAbsOrigin())*Vector(1,1,1)):Normalized()
		local newPosition = skeleton:GetAbsOrigin() + moveDirection*16
		skeleton:SetAbsOrigin(newPosition)
	end
end

function grave_skeleton_modifier:GetModifierAttackRangeBonus()
	if not IsServer() then
		return false
	end
	local ability = self:GetAbility()
	return ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_MORTUARY_CHARM_GEM_EMERALD)
end

function grave_skeleton_modifier:OnAttackStart()
	self:MaybePlaySound(2)
	EmitSoundOn("RPCItems.MortuaryCharm.AttackPre", self:GetParent())
end

function grave_skeleton_modifier:BasicAttackOverride(event)
	local attacker = self:GetParent()
	local hero = attacker.hero
	local damage = OverflowProtectedGetAverageTrueAttackDamage(hero)*(ITEM_RPC_MORTUARY_CHARM_DMG_PCT_ATK_PWR/100)
	EmitSoundOn("RPCItems.MortuaryCharm.AttackLand", event.target)
	Filters:ApplyItemDamage(event.target, hero, damage, DAMAGE_TYPE_PHYSICAL, hero.equipped_gear[RPC_GEAR_SLOT_TRINKET], RPC_ELEMENT_GHOST, RPC_ELEMENT_ARCANE)
	local ability = self:GetAbility()
	event.target:AddNewModifier(hero, ability, "modifier_mortuary_paralyze", {duration = ITEM_RPC_MORTUARY_CHARM_PARALYZE_DURATION})
	local chance = RandomInt(1, 100)
	if chance < ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_MORTUARY_CHARM_GEM_AMETHYST) then
		ability:bounce_projectile(attacker, ability, event.target)
	end
	return 1
end

function itemClass:bounce_projectile(ghost, ability, original_target)
	local enemies = FindUnitsInRadius(ghost:GetTeamNumber(), original_target:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		local bounce_target = nil
		for i = 1, #enemies, 1 do
			if enemies[i] ~= original_target then
				bounce_target = enemies[i]
				break
			end
		end
		if bounce_target then
			local travel_speed = 900
			local info =
			{
				Target = bounce_target,
				Source = original_target,
				Ability = ability,
				EffectName = "particles/roshpit/items/mortuary_ghost_attack.vpcf",
				StartPosition = "attach_hitloc",
				bDrawsOnMinimap = false,
				bIsAttack = false,
				bVisibleToEnemies = true,
				bReplaceExisting = false,
				bProvidesVision = false,
				iMoveSpeed = travel_speed,
				iVisionTeamNumber = ghost:GetTeamNumber(),
				ExtraData = {}
			}
			ProjectileManager:CreateTrackingProjectile(info)
		end
	end
end

function itemClass:OnProjectileHit(target, loc)
	local hero = self:GetCaster()
	local damage = OverflowProtectedGetAverageTrueAttackDamage(hero)*(ITEM_RPC_MORTUARY_CHARM_DMG_PCT_ATK_PWR/100)
	EmitSoundOn("RPCItems.MortuaryCharm.AttackLand", target)
	Filters:ApplyItemDamage(target, hero, damage, DAMAGE_TYPE_PHYSICAL, hero.equipped_gear[RPC_GEAR_SLOT_TRINKET], RPC_ELEMENT_GHOST, RPC_ELEMENT_ARCANE)
	local ability = self
	target:AddNewModifier(hero, ability, "modifier_mortuary_paralyze", {duration = ITEM_RPC_MORTUARY_CHARM_PARALYZE_DURATION})
	local chance = RandomInt(1, 100)
	if chance < ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_MORTUARY_CHARM_GEM_AMETHYST) then
		self:bounce_projectile(hero, ability, target)
	end
	return 1
end

-- Paralyze Modifier

function paralyze_modifier:IsDebuff()
	return true
end

function paralyze_modifier:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
    }
    return funcs
end

function paralyze_modifier:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function paralyze_modifier:GetOverrideAnimationRate()
	return 2
end

function paralyze_modifier:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true
	}

	return state
end

function paralyze_modifier:GetStatusEffectName()
	return "particles/status_fx/status_effect_maledict.vpcf"
end

function paralyze_modifier:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end