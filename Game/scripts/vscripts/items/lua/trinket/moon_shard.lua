require('/items/lua/trinket/base_trinket')
require('/npc_abilities/base_modifier')

item_rpc_moon_shard = class(BaseTrinket, nil, BaseTrinket)
local itemClass = item_rpc_moon_shard
local itemClassName = 'item_rpc_moon_shard'

modifier_moon_shard = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_moon_shard
local modifierName = 'modifier_moon_shard'
LinkLuaModifier(modifierName, "/items/lua/trinket/moon_shard", LUA_MODIFIER_MOTION_NONE)

modifier_moon_shard_sapphire = class(npc_base_modifier, nil, npc_base_modifier)
local sapphire_modifier_class = modifier_moon_shard_sapphire
LinkLuaModifier("modifier_moon_shard_sapphire", "/items/lua/trinket/moon_shard", LUA_MODIFIER_MOTION_NONE)

function itemClass:GetClassName()
    return itemClassName
end
function itemClass:GetName()
    return 'Moon Shard'
end
function itemClass:GetModifierName()
    return modifierName
end
function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_moon_shard"
    self:SetSpecialValue("moon_shard", "#7075ba")
end
function itemClass:RollProperty2(item_level) 
	local luck = RandomInt(1, 3)
	if luck == 1 then
    	RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "all_attributes", 1.5)  
    elseif luck == 2 then
	    local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier2 = 80, tier3 = 100})
	    RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, rune_type, 1.5)
    else
    	RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, nil, 1.5)  
    end
end
function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 0)
end
function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 2.5)
end

function modifierClass:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }

    return funcs
end

function modifierClass:OnCreated()
    self:SetSpecialTypes({
    	MODIFIER_ROSHPIT_Q_PCT_CD_MOD,
    	MODIFIER_ROSHPIT_W_PCT_CD_MOD,
        MODIFIER_ROSHPIT_E_PCT_CD_MOD,
        MODIFIER_ROSHPIT_R_PCT_CD_MOD,
        MODIFIER_ROSHPIT_MASTER_AS,
        MODIFIER_SPECIAL_TYPE_CAST_Q_ABILITY,
        MODIFIER_SPECIAL_TYPE_CAST_W_ABILITY,
        MODIFIER_SPECIAL_TYPE_CAST_E_ABILITY,
        MODIFIER_SPECIAL_TYPE_CAST_R_ABILITY
    })
    self:StartIntervalThink(0.1)
end

function modifierClass:IsHidden()
    return true
end

function modifierClass:OnRemoved()
	if not IsServer() then
		return false
	end
	local hero = self:GetParent()
	hero:RemoveModifierByName("modifier_moon_shard_sapphire")
end

function modifierClass:RemoveOnDeath()
    return false
end

function modifierClass:OnIntervalThink()
	if not IsServer() then
		return false
	end
	local hero = self:GetParent()
	local ability = self:GetAbility()
	if ability:GetGemValue("sapphire") > 0 then
		if not ability.sapphire_interval then
			ability.sapphire_interval = 0
		end
		if not hero:HasModifier("modifier_moon_shard_sapphire") then
			ability.sapphire_interval = ability.sapphire_interval + 1
		end
		if ability.sapphire_interval >= ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_MOON_SHARD_GEM_SAPPHIRE)*10 then
			ability.sapphire_interval = 0
				hero:AddNewModifier(self:GetCaster(), ability, "modifier_moon_shard_sapphire", {})
		end
		
	end
	if ability:GetGemValue("amethyst") > 0 then
		if not ability.amethyst_distance then
			ability.amethyst_distance = 0
			ability.last_pos = hero:GetAbsOrigin()
		end
		local distance = WallPhysics:GetDistance2d(ability.last_pos, hero:GetAbsOrigin())
		ability.amethyst_distance = ability.amethyst_distance + distance
		ability.last_pos = hero:GetAbsOrigin()
		if ability.amethyst_distance >= ITEM_RPC_MOON_SHARD_AMETHYST_DISTANCE_TO_TRIGGER then
			ability.amethyst_distance = 0
			ability:FireSapphireIcicles(hero)
		end
	end
end

function itemClass:FireSapphireIcicles(hero)
	local ability = self
	local enemies = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin(), nil, ITEM_RPC_MOON_SHARD_AMETHYST_SEARCH_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		local count = 0
		for _, enemy in pairs(enemies) do
			ability:FireSapphireIcicle(hero, enemy)
			count = count + 1
			if count >= ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_MOON_SHARD_GEM_AMETHYST1) then
				break
			end
		end
	end
end

function itemClass:FireSapphireIcicle(hero, enemy)
	local travel_speed = 1000
	local info =
	{
		Target = enemy,
		Source = hero,
		Ability = self,
		EffectName = "particles/units/heroes/hero_winter_wyvern/wyvern_splinter_blast.vpcf",
		StartPosition = "attach_attack1",
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,
		iVisionRadius = 0,
		iMoveSpeed = travel_speed,
		iVisionTeamNumber = hero:GetTeamNumber()
	}
	projectile = ProjectileManager:CreateTrackingProjectile(info)

	EmitSoundOn("RPCItems.MoonShard.IcicleThrow", hero)	
end

function itemClass:OnProjectileHit(target, location)
	local hero = self:GetCaster()
	local ability = self
	local caster = self:GetCaster()
	EmitSoundOn("RPCItems.MoonShard.IcicleImpact", target)
	local damage = hero:GetMaxMana()*ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_MOON_SHARD_GEM_AMETHYST2)

	Filters:ApplyItemDamage(target, hero, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_COSMOS, RPC_ELEMENT_ICE)
end

function modifierClass:GetRoshpitQPctCdModifier()
	local hero = self:GetParent()
	local manaMissingPercentage = math.ceil(((hero:GetMaxMana() - hero:GetMana())/hero:GetMaxMana())*100)
	local reduce = manaMissingPercentage*ITEM_RPC_MOON_SHARD_CD_REDUCTION_PER_MANA_PCT
	if hero:HasModifier("modifier_moon_shard_sapphire") then
		reduce = 100
	end
	reduce = -reduce/100
    return reduce
end

function modifierClass:GetRoshpitWPctCdModifier()
	local hero = self:GetParent()
	local manaMissingPercentage = math.ceil(((hero:GetMaxMana() - hero:GetMana())/hero:GetMaxMana())*100)
	local reduce = manaMissingPercentage*ITEM_RPC_MOON_SHARD_CD_REDUCTION_PER_MANA_PCT
	if hero:HasModifier("modifier_moon_shard_sapphire") then
		reduce = 100
	end
	reduce = -reduce/100
    return reduce
end

function modifierClass:GetRoshpitEPctCdModifier()
	local hero = self:GetParent()
	local manaMissingPercentage = math.ceil(((hero:GetMaxMana() - hero:GetMana())/hero:GetMaxMana())*100)
	local reduce = manaMissingPercentage*ITEM_RPC_MOON_SHARD_CD_REDUCTION_PER_MANA_PCT
	if hero:HasModifier("modifier_moon_shard_sapphire") then
		reduce = 100
	end
	reduce = -reduce/100
    return reduce
end

function modifierClass:GetRoshpitRPctCdModifier()
	local hero = self:GetParent()
	local manaMissingPercentage = math.ceil(((hero:GetMaxMana() - hero:GetMana())/hero:GetMaxMana())*100)
	local reduce = manaMissingPercentage*ITEM_RPC_MOON_SHARD_CD_REDUCTION_PER_MANA_PCT
	if hero:HasModifier("modifier_moon_shard_sapphire") then
		reduce = 100
	end
	reduce = -reduce/100
    return reduce
end

function modifierClass:GetRoshpitMasterAS()
	local ability = self:GetAbility()
	if ability:GetGemValue("ruby") > 0 then
		local hero = self:GetParent()
		local manaMissingPercentage = math.ceil(((hero:GetMaxMana() - hero:GetMana())/hero:GetMaxMana())*100)
		return manaMissingPercentage*ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_MOON_SHARD_GEM_RUBY)
	else
		return 0
	end
end

function modifierClass:GetModifierMoveSpeed_Max_Increase(params)
    if not IsServer() then
        return
    end
    local ability = self:GetAbility()
    local hero = self:GetParent()
    if ability:GetGemValue("emerald") > 0 then
		local hero = self:GetParent()
		local mana_full_percent = math.ceil((hero:GetMana()/hero:GetMaxMana())*100)
		return mana_full_percent*ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_MOON_SHARD_GEM_EMERALD)
	else
		return 0
	end
end

function modifierClass:GetModifierMoveSpeedBonus_Constant(params)
    if not IsServer() then
        return
    end
    local ability = self:GetAbility()
    local hero = self:GetParent()
    if ability:GetGemValue("emerald") > 0 then
		local hero = self:GetParent()
		local mana_full_percent = math.ceil((hero:GetMana()/hero:GetMaxMana())*100)
		return mana_full_percent*ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_MOON_SHARD_GEM_EMERALD)
	else
		return 0
	end
end

function modifierClass:OnCastQAbility()
	local hero = self:GetParent()
	local ability = self:GetAbility()
	if ability:GetGemValue("sapphire") > 0 then
		hero:AddNewModifier(self:GetCaster(), ability, "modifier_moon_shard_sapphire", {duration = 0.03})
	end
end

function modifierClass:OnCastWAbility()
	local hero = self:GetParent()
	local ability = self:GetAbility()
	if ability:GetGemValue("sapphire") > 0 then
		hero:AddNewModifier(self:GetCaster(), ability, "modifier_moon_shard_sapphire", {duration = 0.03})
	end
end

function modifierClass:OnCastEAbility()
	local hero = self:GetParent()
	local ability = self:GetAbility()
	if ability:GetGemValue("sapphire") > 0 then
		hero:AddNewModifier(self:GetCaster(), ability, "modifier_moon_shard_sapphire", {duration = 0.03})
	end
end

function modifierClass:OnCastRAbility()
	local hero = self:GetParent()
	local ability = self:GetAbility()
	if ability:GetGemValue("sapphire") > 0 then
		hero:AddNewModifier(self:GetCaster(), ability, "modifier_moon_shard_sapphire", {duration = 0.03})
	end
end

function sapphire_modifier_class:IsHidden()
	return false
end