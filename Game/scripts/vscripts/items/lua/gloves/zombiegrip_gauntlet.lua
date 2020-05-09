require('items/lua/gloves/base_glove')
require('npc_abilities/base_modifier')

item_rpc_zombiegrip_gauntlet = class(BaseGloves, nil, BaseGloves)
local itemClass = item_rpc_zombiegrip_gauntlet
local itemClassName = 'item_rpc_zombiegrip_gauntlet'

modifier_zombiegrip_gauntlet = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_zombiegrip_gauntlet
local modifierName = 'modifier_zombiegrip_gauntlet'
LinkLuaModifier(modifierName, "items/lua/gloves/zombiegrip_gauntlet", LUA_MODIFIER_MOTION_NONE)

modifier_zombiegrip_gauntlet_zombie_summon = class(npc_base_modifier, nil, npc_base_modifier)
local zombie_buff = modifier_zombiegrip_gauntlet_zombie_summon
LinkLuaModifier("modifier_zombiegrip_gauntlet_zombie_summon", "items/lua/gloves/zombiegrip_gauntlet", LUA_MODIFIER_MOTION_NONE)

modifier_zombiegrip_acid_pile = class(npc_base_modifier, nil, npc_base_modifier)
local acid_aura = modifier_zombiegrip_acid_pile
LinkLuaModifier("modifier_zombiegrip_acid_pile", "items/lua/gloves/zombiegrip_gauntlet", LUA_MODIFIER_MOTION_NONE)

modifier_zombiegrip_standing_in_acid_pile = class(npc_base_modifier, nil, npc_base_modifier)
local acid_aura_effect = modifier_zombiegrip_standing_in_acid_pile
LinkLuaModifier("modifier_zombiegrip_standing_in_acid_pile", "items/lua/gloves/zombiegrip_gauntlet", LUA_MODIFIER_MOTION_NONE)

modifier_zombiegrip_poison_cloud = class(npc_base_modifier, nil, npc_base_modifier)
local poison_cloud_buff = modifier_zombiegrip_poison_cloud
LinkLuaModifier("modifier_zombiegrip_poison_cloud", "items/lua/gloves/zombiegrip_gauntlet", LUA_MODIFIER_MOTION_NONE)

modifier_zombiegrip_in_poison_cloud = class(npc_base_modifier, nil, npc_base_modifier)
local inside_poison_cloud_debuff = modifier_zombiegrip_in_poison_cloud
LinkLuaModifier("modifier_zombiegrip_in_poison_cloud", "items/lua/gloves/zombiegrip_gauntlet", LUA_MODIFIER_MOTION_NONE)


function itemClass:GetClassName()
    return itemClassName
end

function itemClass:GetName()
    return 'Swiftspike Bracer'
end

function itemClass:GetModifierName()
    return modifierName
end

function itemClass:HasRuneSlots()
    return true
end

function itemClass:RollProperty1(item_level)
    self.newItemTable.property1 = 1
    self.newItemTable.property1name = "!immortal!_modifier_zombiegrip_gauntlet"
    self:SetSpecialValue("zombiegrip_gauntlet", "#AAAAAA")
end

function itemClass:RollProperty2(item_level)
    local luck = RandomInt(1, 6)
    if luck < 5 then
        local rune_type = RPCItems:RollRuneType({"q", "w", "e", "r"}, {tier1 = 50, tier2 = 100})
        RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, rune_type, 2)
    else
        RPCItems:RollBasicItemProperty(self, self:GetSlotNumber(), 2, item_level, "element_undead", 2.5)
    end
end

function itemClass:RollArmor(item_level)
    RPCItems:GrantItemBaseArmor(self, item_level, 2)
end

function itemClass:RollMagicArmor(item_level)
    RPCItems:GrantItemBaseMagicArmor(self, item_level, 1.5)
end

------------
--MODIFIER--
------------

function modifierClass:OnCreated()
    if not IsServer() then return end

    self:SetSpecialTypes({
        MODIFIER_SPECIAL_TYPE_CAST_Q_ABILITY
    })
end

function modifierClass:DeclareFunctions()
    local funcs = {

    }
    return funcs
end

function modifierClass:IsHidden()
	return true
end

function modifierClass:GetZombieHullSize()
	return 196
end

function modifierClass:OnCastQAbility()
	local ability = self:GetAbility()
	local hero = self:GetParent()
	self:KillAllZombies()
	ability.zombie_table = {}

	local zombie_count = ITEM_RPC_ZOMBIEGRIP_GAUNTLET_BASE_ZOMBIE_COUNT + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_ZOMBIEGRIP_GAUNTLET_GEM_SAPPHIRE1)

	local perpFV = WallPhysics:rotateVector(hero:GetForwardVector(), 2*math.pi/4)
	local forwardPosition = hero:GetAbsOrigin() + hero:GetForwardVector()*300
	local hullSize = self:GetZombieHullSize()
	for i = 1, zombie_count, 1 do
		local spawnPosition = forwardPosition + perpFV * hullSize * (i - 0.5 - zombie_count/2)
		self:SummonZombie(spawnPosition, hero:GetForwardVector())
	end
	
end

function modifierClass:KillAllZombies()
	local ability = self:GetAbility()
	if ability.zombie_table then
		for i = 1, #ability.zombie_table, 1 do
			local zombie = ability.zombie_table[i]
			if zombie:EntityExistsAndIsAlive() then
				zombie:ForceKill(false)
			end
		end
	end
end

function modifierClass:OnDestroy()
	self:KillAllZombies()
end

function modifierClass:SummonZombie(position, fv)
	local hero = self:GetParent()
	local ability = self:GetAbility()
	local zombie = CreateUnitByName("item_zombiegrip_gauntlet_zombie", position, false, nil, nil, hero:GetTeamNumber())
	zombie.owner = hero:GetPlayerOwnerID()
	zombie.summoner = hero
	zombie:SetOwner(hero)
	zombie:SetControllableByPlayer(hero:GetPlayerID(), true)
	zombie.dieTime = ITEM_RPC_ZOMBIEGRIP_GAUNTLET_DURATION + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_ZOMBIEGRIP_GAUNTLET_GEM_SAPPHIRE2)
	zombie:AddAbility("ability_die_after_time_generic"):SetLevel(1)
	zombie:SetForwardVector(fv)
	zombie:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
	Events:smoothSizeChange(zombie, 0.01, 2.4, 7)
	zombie.hero = hero
	local damageInherit = (ITEM_RPC_ZOMBIEGRIP_GAUNTLET_ATTACK_DMG_INHERIT_PCT + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_ZOMBIEGRIP_GAUNTLET_GEM_RUBY3))/100
	zombie:AdjustSummon(hero, true, 1, damageInherit, 1, 1, 1, 1)
	local hp = ITEM_RPC_ZOMBIEGRIP_GAUNTLET_ATTACKS_TO_KILL + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_ZOMBIEGRIP_GAUNTLET_GEM_SAPPHIRE3)
	zombie:SetMaxHPandHealToFull(hp)
	Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, zombie, "modifier_take_1_damage_only", {})
	local hull_radius = self:GetZombieHullSize()*(1-(1/math.pi))
	zombie:SetHullRadius(hull_radius)
	CustomAbilities:QuickParticleAtPoint("particles/roshpit/items/musty_crypt_transform.vpcf", zombie:GetAbsOrigin(), 3)
	CustomAbilities:QuickParticleAtPoint("particles/roshpit/items/zombie_gauntlet_spawn.vpcf", zombie:GetAbsOrigin(), 3)
	zombie:SetAbsOrigin(zombie:GetAbsOrigin()-Vector(0,0,130))
	zombie.pushLock = true
	zombie.jumpLock = true
	zombie:SetRenderColor(100, 180, 160)
	zombie:AddNewModifier(hero, ability, "modifier_zombiegrip_gauntlet_zombie_summon", {})
	table.insert(ability.zombie_table, zombie)
	if ability:GetGemValue("amethyst") > 0 then
		zombie:AddNewModifier(hero, ability, "modifier_zombiegrip_poison_cloud", {})
		zombie.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_rot.vpcf", PATTACH_CUSTOMORIGIN, zombie)
		ParticleManager:SetParticleControlEnt(zombie.pfx, 0, zombie, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", zombie:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(zombie.pfx, 1, Vector(ITEM_PROPERTY_ZOMBIEGRIP_GAUNTLET_AMETHYST_RADIUS, 1, 20))
	end
end
-----------
--SPECIAL--
-----------
function zombie_buff:OnCreated()
    if not IsServer() then return end

    self:SetSpecialTypes({
        MODIFIER_ROSHPIT_OVERRIDE_ATTACK_EVENT
    })
    self:GetParent().attackOverride = true
    self:MaybePlaySound(10)
end

function zombie_buff:CheckState()
	local state = {
	[MODIFIER_STATE_UNSELECTABLE] = true,
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true
	}

	return state
end

function zombie_buff:OnAttackStart(event)
	if event.attacker == self:GetParent() then
		self:MaybePlaySound(12)
	end
end

function zombie_buff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_EVENT_ON_ATTACK_START,
    }
    return funcs
end

function zombie_buff:GetModifierTurnRate_Percentage()
	return -20000
end

function zombie_buff:BasicAttackOverride(event)
	local attacker = self:GetParent()
	local hero = attacker.hero
	local damage = OverflowProtectedGetAverageTrueAttackDamage(attacker)
	EmitSoundOn("RPCItems.ZombieGrimGauntlet.Attack", event.target)
	Filters:ApplyItemDamage(event.target, hero, damage, DAMAGE_TYPE_PHYSICAL, hero.equipped_gear[RPC_GEAR_SLOT_GLOVES], RPC_ELEMENT_UNDEAD, RPC_ELEMENT_NONE)
	return 1
end

function zombie_buff:MaybePlaySound(chance)
	local luck = RandomInt(1, 100)
	if luck <= chance then
		EmitSoundOn("RPCItems.ZombieGrimGauntlet.VO", self:GetParent())
	end
end

function zombie_buff:OnDeath(event)
	local zombie = self:GetParent()
	if event.unit == zombie then
		self:MaybePlaySound(20)
		local groundPos = GetGroundPosition(zombie:GetAbsOrigin(), zombie)
		CustomAbilities:QuickParticleAtPoint("particles/roshpit/items/zombie_gauntlet_spawn.vpcf", groundPos, 3)
		Events:smoothTranslate(zombie, Vector(0,0,-2), 100, Vector(0,0), nil)
		if zombie.pfx then
			ParticleManager:DestroyParticle(zombie.pfx, false)
		end
		local ability = self:GetAbility()
		local hero = ability:GetCaster()
		if ability:GetGemValue("emerald") > 0 then
			local radius = ITEM_RPC_ZOMBIEGRIP_GAUNTLET_EMERALD_RADIUS
			local groundPos = GetGroundPosition(zombie:GetAbsOrigin(), zombie)
			local particle = ParticleManager:CreateParticle("particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf", PATTACH_WORLDORIGIN, target)
			ParticleManager:SetParticleControl(particle, 0, groundPos)
			ParticleManager:SetParticleControl(particle, 1, Vector(radius, radius, radius))
			ParticleManager:SetParticleControl(particle, 2, Vector(1, 1, 1))
			ParticleManager:SetParticleControl(particle, 4, Vector(60, 245, 40))
			Timers:CreateTimer(1.5, function()
				ParticleManager:DestroyParticle(particle, false)
			end)
			local enemies = FindUnitsInRadius(hero:GetTeamNumber(), zombie:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			local damage = OverflowProtectedGetAverageTrueAttackDamage(hero)*(ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_ZOMBIEGRIP_GAUNTLET_GEM_EMERALD1)/100)
			if #enemies > 0 then
				for _, enemy in pairs(enemies) do
					Filters:ApplyItemDamage(enemy, hero, damage, DAMAGE_TYPE_PHYSICAL, ability, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_POISON)
				end
			end	
			self:CreatePoisonGooThinker(groundPos, hero, ability, radius)
			EmitSoundOn("RPCItems.Zombiegrip.ZombieEmeraldExplode", zombie)
		end			
	end

end

function zombie_buff:CreatePoisonGooThinker(position, hero, ability, radius)
	if not ability.goo_table then
		ability.goo_table = {}
	end
	local exit = false
	print(#ability.goo_table)
	for i = 1, #ability.goo_table, 1 do
		local acid_puddle = ability.goo_table[i]
		local distance = WallPhysics:GetDistance2d(position, acid_puddle:GetAbsOrigin())
		if distance < radius*(1-(1/math.pi)) then
			if acid_puddle:HasModifier("modifier_zombiegrip_acid_pile") then
				exit = true
				break
			end
		end
	end
	if exit then
		return false
	end
    local poison_goo_thinker = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, hero:GetTeamNumber())
    poison_goo_thinker:FindAbilityByName("dummy_unit"):SetLevel(1)
    poison_goo_thinker:SetAbsOrigin(position)

    local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(pfx, 0, poison_goo_thinker:GetAbsOrigin())
    ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 1, 1))
    ParticleManager:SetParticleControl(pfx, 15, Vector(10, 85, 10))
    ParticleManager:SetParticleControl(pfx, 16, Vector(0.6, 0.6, 0.6))
    poison_goo_thinker.pfx = pfx

    poison_goo_thinker:AddNewModifier(hero, ability, "modifier_zombiegrip_acid_pile", {duration = ITEM_RPC_ZOMBIEGRIP_GAUNTLET_EMERALD_DURATION})

    table.insert(ability.goo_table, poison_goo_thinker)
end

function zombie_buff:GetModifierAttackSpeedBonus_Constant()
	if IsServer() then
		return self:GetAbility():GetFinalGemPropertyValue("ruby", ITEM_RPC_ZOMBIEGRIP_GAUNTLET_GEM_RUBY2)
	end
end

function acid_aura:ReindexAcidTable()
	local ability = self:GetAbility()
	local newTable = {}
	for i = 1, #ability.goo_table, 1 do
		local acid_puddle = ability.goo_table[i]
		if acid_puddle:HasModifier("modifier_zombiegrip_acid_pile") then
			table.insert(newTable, acid_puddle)
		else
			ParticleManager:DestroyParticle(acid_puddle.pfx, false)
			UTIL_Remove(acid_puddle)
		end
	end
	ability.goo_table = newTable
end

-- ACID AURA

function acid_aura:IsHidden()
	return true
end

function acid_aura:IsAura()
    return true
end

function acid_aura:IsAuraActiveOnDeath()
    return false
end

function acid_aura:GetAuraRadius()
    return ITEM_RPC_ZOMBIEGRIP_GAUNTLET_EMERALD_RADIUS
end

function acid_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function acid_aura:GetAuraSearchType()
    return (DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC)
end

function acid_aura:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function acid_aura:RemoveOnDeath()
    return true
end

function acid_aura:GetModifierAura()
    return "modifier_zombiegrip_standing_in_acid_pile"
end

function acid_aura:OnDestroy()
	self:ReindexAcidTable()
end

function acid_aura_effect:IsHidden()
	return false
end

function acid_aura_effect:IsDebuff()
	return true
end

function acid_aura_effect:OnCreated()
    if not IsServer() then return end

    self:SetSpecialTypes({
        MODIFIER_ROSHPIT_ARMOR_BONUS
    })
	self:StartIntervalThink(0.5)
	self:GetParent():CalculateAndSaveRoshpitAttributes()
end

function acid_aura_effect:OnIntervalThink()
	local target = self:GetParent()
	local ability = self:GetAbility()
	local hero = self:GetCaster()
	local damage = OverflowProtectedGetAverageTrueAttackDamage(hero)*(ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_ZOMBIEGRIP_GAUNTLET_GEM_EMERALD2)/100)
	Filters:ApplyItemDamage(target, hero, damage, DAMAGE_TYPE_PHYSICAL, ability, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_POISON)	
end

function acid_aura_effect:GetRoshpitArmorBonus()
	local ability = self:GetAbility()
	return ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_ZOMBIEGRIP_GAUNTLET_GEM_EMERALD3)
end

function acid_aura_effect:OnDestroy()
	if not IsServer() then return end
	self:GetParent():CalculateAndSaveRoshpitAttributes()
end

-- POISON CLOUD

function poison_cloud_buff:IsHidden()
	return true
end

function poison_cloud_buff:IsAura()
    return true
end

function poison_cloud_buff:IsAuraActiveOnDeath()
    return false
end

function poison_cloud_buff:GetAuraRadius()
    return ITEM_PROPERTY_ZOMBIEGRIP_GAUNTLET_AMETHYST_RADIUS
end

function poison_cloud_buff:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function poison_cloud_buff:GetAuraSearchType()
    return (DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC)
end

function poison_cloud_buff:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function poison_cloud_buff:RemoveOnDeath()
    return true
end

function poison_cloud_buff:GetModifierAura()
    return "modifier_zombiegrip_in_poison_cloud"
end

function inside_poison_cloud_debuff:IsHidden()
	return false
end

function inside_poison_cloud_debuff:IsDebuff()
	return true
end

function inside_poison_cloud_debuff:GetTexture()
	return "pudge_rot"
end

function inside_poison_cloud_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
    return funcs
end

function inside_poison_cloud_debuff:GetModifierMoveSpeedBonus_Constant()
	local ability = self:GetAbility()
	return ability:GetGemValue("amethyst", ITEM_RPC_ZOMBIEGRIP_GAUNTLET_GEM_AMETHYST2)
end


function inside_poison_cloud_debuff:GetModifierAttackSpeedBonus_Constant()
	local ability = self:GetAbility()
	return ability:GetGemValue("amethyst", ITEM_RPC_ZOMBIEGRIP_GAUNTLET_GEM_AMETHYST1)
end

