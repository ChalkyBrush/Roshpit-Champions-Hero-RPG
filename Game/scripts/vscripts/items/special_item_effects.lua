LinkLuaModifier("modifier_super_ascendency_lua", "modifiers/modifier_super_ascendency", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_knight_hawk_lua", "modifiers/modifier_knight_hawk_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_silent_templar_sapphire", "modifiers/modifier_silent_templar_sapphire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_iron_colossus_lua", "modifiers/modifier_iron_colossus_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_proud_gloves_lua", "modifiers/modifier_proud_gloves_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_swiftspike_sapphire", "modifiers/modifier_swiftspike_sapphire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodstone_boot_amethyst", "modifiers/modifier_bloodstone_boot_amethyst", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boots_of_ashara_ruby", "modifiers/modifier_boots_of_ashara_ruby", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_crystalline_slippers_emerald", "modifiers/modifier_crystalline_slippers_emerald", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sandstream_slippers_emerald", "modifiers/modifier_sandstream_slippers_emerald", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_epsilon", "modifiers/modifier_epsilon", LUA_MODIFIER_MOTION_NONE)


require('items/constants/boots')
require('items/constants/chest')
require('items/constants/gloves')
require('items/constants/helm')
require('items/constants/trinket')
require('util')

function astral_glyph_4_1_apply(event)
	local target = event.target
	local ability = target:GetAbilityByIndex(DOTA_E_SLOT)
	if not ability then return end
	if not target.saveECastPoint then
		target.saveECastPoint = ability:GetCastPoint()
	end
	ability:SetOverrideCastPoint(0)
end

function astral_glyph_4_1_remove(event)
	local target = event.target
	local ability = target:GetAbilityByIndex(DOTA_E_SLOT)
	if not ability or not target.saveECastPoint then return end
	ability:SetOverrideCastPoint(target.saveECastPoint)
end

function paladin_2_1_destroy(event)
	local caster = event.target
	local ability = caster:FindAbilityByName("heroic_fury")
	local cd = ability:GetCooldownTimeRemaining()
	if ability:GetToggleState() then
		ability:ToggleAbility()
	end
	ability:EndCooldown()
	ability:StartCooldown(cd)
	caster:RemoveModifierByName("modifier_paladin_q")
	caster:RemoveModifierByName("modifier_paladin_q2_aura")
end

function steelbark_think(event)
	local caster = event.caster
	local target = event.target
	if target:GetHealth() / target:GetMaxHealth() <= 0.4 then
		local ability = caster:FindAbilityByName("body_slot")
		ability:ApplyDataDrivenModifier(caster, target, "modifier_body_steelbark_effect", {})
	else
		target:RemoveModifierByName("modifier_body_steelbark_effect")
	end
end

function berserker_attack_landed(event)
	local attacker = event.attacker
	local caster = event.caster
	local ability = event.ability
	local luck = RandomInt(1, 10)
	if luck == 1 then
		ability:ApplyDataDrivenModifier(caster, attacker, "modifier_hand_berserker_state", {duration = 5})
	end
end

function shadow_armlet_take_damage(event)
	local ability = event.ability
	local caster = event.caster
	local attack_damage = event.attack_damage
	local target = event.unit
	local proc = Filters:GetProc(target, ITEM_RPC_SHADOW_ARMLET_HEAL_CHANCE)
	if proc then
		Filters:ApplyHeal(target, target, attack_damage, true)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_shadow_armlet_effect", {duration = 1})
	end
end

function midas_attack_land(event)
	local caster = event.attacker
	local runeUnit = event.caster
	local target = event.target
	local ability = event.ability
	local proc_chance = ITEM_RPC_HAND_OF_MIDAS_CHANCE + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_HAND_OF_MIDAS_GEM_RUBY)
	local proc = Filters:GetProc(caster, proc_chance)
	if proc then
		local position = target:GetAbsOrigin()
		local freeze_duration = ITEM_RPC_HAND_OF_MIDAS_FREEZE_DURATION + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_HAND_OF_MIDAS_GEM_EMERALD)
		local radius = ITEM_RPC_HAND_OF_MIDAS_RADIUS + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_HAND_OF_MIDAS_GEM_SAPPHIRE1)
		local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * (ITEM_RPC_HAND_OF_MIDAS_ATTACK_DAMAGE_MULT/100) + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_HAND_OF_MIDAS_GEM_SAPPHIRE2)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				Filters:ApplyItemDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
				if not enemy:HasModifier("modifier_midas_freeze_immune") then
					ability:ApplyDataDrivenModifier(runeUnit, enemy, "modifier_midas_freeze", {duration = freeze_duration})
					ability:ApplyDataDrivenModifier(runeUnit, enemy, "modifier_midas_freeze_immune", {duration = ITEM_RPC_HAND_OF_MIDAS_FREEZE_CD})
				end
			end
		end
		local particleName = "particles/econ/items/luna/luna_lucent_ti5_gold/luna_lucent_beam_impact_ti_5_gold.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 2, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 3, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 4, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 5, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)

		Timers:CreateTimer(3, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		EmitSoundOn("Items.RPCHandOfMidas", target)
	end
end

function scorch_take_damage(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	if ability:GetGemValue("amethyst") > 0 then
		local proc = Filters:GetProc(hero, ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_SCORCHED_GAUNTLETS_GEM_AMETHYST2))
		if proc then
			local eventTable = {}
			eventTable.attacker = hero
			eventTable.target = event.attacker
			eventTable.ability = ability
			eventTable.caster = caster
			eventTable.guarantee_proc = true
			scorch_attack_land(eventTable)
		end
	end
end

function scorch_attack_land(event)
	local target = event.target
	local ability = event.ability
	local attacker = event.attacker
	local caster = event.caster
	local proc_chance = ITEM_RPC_SCORCHED_GAUNTLETS_CHANCE + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_SCORCHED_GAUNTLETS_GEM_SAPPHIRE1)
	local proc = Filters:GetProc(caster, proc_chance)
	if proc or event.guarantee_proc then
		EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "RPCItem.HighFlameStart", attacker)
		ability.attacker = attacker

		CustomAbilities:QuickAttachThinker(ability, caster, target:GetAbsOrigin(), "modifier_hand_scorched_earth_thinker", {})
		if ability:GetGemValue("ruby") > 0 then
			HighFlameThrow(attacker, ability, target)
		end
	end
end

function scorched_earth_damage(event)
	local target = event.target
	local ability = event.ability
	local attacker = ability.attacker
	local damage = OverflowProtectedGetAverageTrueAttackDamage(ability.attacker) * ITEM_RPC_SCORCHED_GAUNTLETS_ATTACK_TO_DMG / 100 + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_SCORCHED_GAUNTLETS_GEM_EMERALD2)*attacker:GetRoshpitArmor() + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_SCORCHED_GAUNTLETS_GEM_SAPPHIRE2)
	Filters:ApplyItemDamage(target, attacker, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
	local pfx = CustomAbilities:QuickAttachParticle("particles/econ/items/pudge/pudge_arcana/fire/pudge_arcana_dismember_burst_fire_b.vpcf", target, 2)
	ParticleManager:SetParticleControl(pfx, 3, target:GetAbsOrigin())
end

function HighFlameThrow(caster, ability, victim)
	local target = victim:GetAbsOrigin() + RandomVector(RandomInt(80, 300))
	local zDifferential = target.z - victim:GetAbsOrigin().z
	local baseFV = (target * Vector(1, 1, 0) - victim:GetAbsOrigin() * Vector(1, 1, 0)):Normalized()
	local forwardVelocity = WallPhysics:GetDistance2d(target, victim:GetAbsOrigin()) / 32 + 1
	--print(caster:GetAttachmentOrigin(2))
	local startPosition = victim:GetAbsOrigin()
	local fvModifier = ((caster:GetAbsOrigin() - startPosition) * Vector(1, 1, 0)):Normalized()
	local fvModifierDivisor = 2.8 / forwardVelocity
	local adjustedFV = (baseFV + (fvModifier * fvModifierDivisor)):Normalized()
	local randomOffset = 0
	-- local flareAngle = WallPhysics:rotateVector(baseFV, math.pi*randomOffset/160)
	local flare = CreateUnitByName("selethas_boomerang", startPosition, false, caster, nil, caster:GetTeamNumber())
	flare:SetOriginalModel("models/props_gameplay/rune_arcane.vmdl")
	flare:SetModel("models/props_gameplay/rune_arcane.vmdl")
	flare:SetRenderColor(240, 110, 20)
	flare:SetModelScale(0.05)
	flare.fv = adjustedFV
	flare.stun_duration = ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_SCORCHED_GAUNTLETS_GEM_RUBY2)
	flare.liftVelocity = 60 + zDifferential / 20
	flare.forwardVelocity = forwardVelocity
	flare.interval = 0
	flare.damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_SCORCHED_GAUNTLETS_GEM_RUBY1)/100
	flare.origCaster = caster
	flare.origAbility = ability

	flare:AddAbility("high_flame_bomb_ability"):SetLevel(1)
	local flareSubAbility = flare:FindAbilityByName("high_flame_bomb_ability")
	flareSubAbility:ApplyDataDrivenModifier(flare, flare, "modifier_water_bomb_motion", {})
end

function high_flame_bomb_thinking(event)
	local caster = event.caster
	local ability = event.ability
	caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, caster.liftVelocity) + caster.fv * caster.forwardVelocity)
	caster.liftVelocity = caster.liftVelocity - 3
	local maxScale = 0.35
	if caster.altMaxScale then
		maxScale = caster.altMaxScale
	end
	caster:SetModelScale(0.01)
	local newFV = WallPhysics:rotateVector(caster:GetForwardVector(), math.pi / 30)
	caster:SetForwardVector(newFV)
	caster:SetAngles(caster.interval * 7, caster.interval * 7, caster.interval * 7)
	caster.interval = caster.interval + 1
	local groundHeight = GetGroundHeight(caster:GetAbsOrigin(), caster)
	if caster:GetAbsOrigin().z - groundHeight < 10 then
		EmitSoundOn("RPCItem.HighFlameImpact", caster)
		caster:RemoveModifierByName("modifier_water_bomb_motion")
		highFlameImpact(caster, ability, caster:GetAbsOrigin(), caster.damage)
		caster:SetAbsOrigin(caster:GetAbsOrigin() - Vector(0, 0, 1000))
		Timers:CreateTimer(0.1, function()
			caster:SetModelScale(0.01)
			Timers:CreateTimer(1, function()
				UTIL_Remove(caster)
			end)
		end)
	end
end

function highFlameImpact(caster, ability, position, damage)
	local radius = 320
	local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
	local particle2 = ParticleManager:CreateParticle(particleNameS, PATTACH_WORLDORIGIN, target)
	ParticleManager:SetParticleControl(particle2, 0, position)
	ParticleManager:SetParticleControl(particle2, 1, Vector(radius, radius, radius))
	ParticleManager:SetParticleControl(particle2, 2, Vector(2.0, 2.0, 2.0))
	ParticleManager:SetParticleControl(particle2, 4, Vector(255, 140, 20))
	Timers:CreateTimer(1.5, function()
		ParticleManager:DestroyParticle(particle2, false)
	end)
	--caster.origAbility:ApplyDataDrivenThinker(caster.origCaster.InventoryUnit, position, "modifier_hand_scorched_earth_thinker", {})
	CustomAbilities:QuickAttachThinker(caster.origAbility, caster.origCaster.InventoryUnit, position, "modifier_hand_scorched_earth_thinker", {})

	local particleName = "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControl(particle1, 0, position)
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
	-- EmitSoundOn("Items.LavaforgeImpact", target)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:ApplyItemDamage(enemy, caster.origCaster, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
			Filters:ApplyStun(caster.origCaster, caster.stun_duration, enemy)
		end
	end

end


function marauder_attack_land(event)
	local attacker = event.attacker
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, attacker, "modifier_hand_marauder_effect", {duration = 7})
	local current_stack = attacker:GetModifierStackCount("modifier_hand_marauder_effect", ability)
	if current_stack < 50 then
		attacker:SetModifierStackCount("modifier_hand_marauder_effect", ability, current_stack + 1)
	end
end

function BodyProjectileStrike(event)
	local ability = event.ability
	local caster = ability.caster
	local target = event.target
	local primeAttribute = caster:GetRoshpitPrimaryAttribute()
	local damage = 0
	if primeAttribute == 0 then
		damage = caster:GetStrength() * 5
	elseif primeAttribute == 1 then
		damage = caster:GetAgility() * 5
	elseif primeAttribute == 2 then
		damage = caster:GetIntellect() * 5
	end
	Filters:ApplyItemDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
end

function doomplate_damage(event)
	local target = event.target
	local caster = target.doomplateCaster
	local primeAttribute = caster:GetRoshpitPrimaryAttribute()
	local damage = 0
	if primeAttribute == 0 then
		damage = caster:GetStrength() * 15
	elseif primeAttribute == 1 then
		damage = caster:GetAgility() * 15
	elseif primeAttribute == 2 then
		damage = caster:GetIntellect() * 15
	end
	Filters:ApplyItemDamage(target, caster, damage, DAMAGE_TYPE_PURE, event.ability)
end

function hyper_visor_attack_land(event)
	local target = event.target
	local ability = event.ability
	local attacker = event.attacker
	local proc = Filters:GetProc(attacker, HYPER_VISOR_CHANCE)

	local damage = OverflowProtectedGetAverageTrueAttackDamage(attacker) * (HYPER_VISOR_ATTACK_TO_DMG/100) + (ability:GetFinalGemPropertyValue("emerald", HYPER_VISOR_EMERALD)*attacker:GetAgility())
	if proc then
		local radius = HYPER_VISOR_AOE
		local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				Filters:ApplyItemDamage(enemy, attacker, damage, DAMAGE_TYPE_PHYSICAL, event.ability, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
			end
		end
		local pfx = ParticleManager:CreateParticle("particles/econ/items/sven/sven_warcry_ti5/hyper_visor.vpcf", PATTACH_CUSTOMORIGIN, target)
		ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 0, 0))
		ParticleManager:SetParticleControl(pfx, 3, Vector(0, 0, 0))
		Timers:CreateTimer(1.5, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		EmitSoundOn("RPCItems.HyperVisor.MainProc", target)
	end
	if ability:GetGemValue("sapphire") > 0 then
		local proc2 = Filters:GetProc(attacker, HYPER_VISOR_SAPPHIRE_CHAIN_LIGHTNING_CHANCE)
		local chain_damage = damage * (ability:GetFinalGemPropertyValue("sapphire", HYPER_VISOR_SAPPHIRE)/100)
		if proc2 then
			local chain = {}
			chain.index_hit = 0
			chain.enemies = FindUnitsInRadius(attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false)
			for i = 1, HYPER_VISOR_SAPPHIRE_CHAIN_LIGHTNING_TARGET_COUNT, 1 do
				Timers:CreateTimer((i - 1) * 0.15, function()
					local enemy = chain.enemies[i]
					if IsValidEntity(enemy) and enemy:IsAlive() then
						EmitSoundOn("RPCItems.HyperVisor.ChainLightning", enemy)
						Filters:ApplyItemDamage(enemy, attacker, chain_damage, DAMAGE_TYPE_PHYSICAL, event.ability, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
						local particleName = "particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf"
						local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_CUSTOMORIGIN, nil)
						local attach_unit_1 = attacker
						if i > 1 then
							attach_unit_1 = chain.enemies[i - 1]
						end
						ParticleManager:SetParticleControl(pfx, 0, attach_unit_1:GetAbsOrigin() + Vector(0, 0, attach_unit_1:GetBoundingMaxs().z + 80))
						ParticleManager:SetParticleControl(pfx, 1, enemy:GetAbsOrigin() + Vector(0, 0, enemy:GetBoundingMaxs().z + 100))
						Timers:CreateTimer(0.3, function()
							ParticleManager:DestroyParticle(pfx, false)
						end)
					end
				end)
			end
		end
	end
end

function ruby_dragon_immolation_think(event)
	local caster = event.caster
	local ability = event.ability
	local burnDamage = caster.burnDamage
	local summoner = caster.summoner
	local radius = 180
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:ApplyItemDamage(enemy, summoner, burnDamage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_immolation_burn", {duration = 0.5})
		end
	end
end

function centaur_horn_think(event)
	local inv_unit = event.caster
	local caster = event.target
	local ability = event.ability
	if not ability.interval then
		ability.interval = 0
	end
	ability.interval = ability.interval + 1
	if ability.interval == 30 then
		ability.interval = 0
		CustomAbilities:QuickAttachParticle("particles/roshpit/centaur_horns_lifesteal.vpcf", caster, 0.9)
	end
	ApplyDamage({victim = caster, attacker = caster, damage = CENTAUR_HORNS_SELF_DMG, damage_type = DAMAGE_TYPE_PURE, ability = ability})
	if caster:IsStunned() then
		Filters:CleanseStuns(caster)
	end
	if not caster:IsAlive() then
		if caster:GetTimeUntilRespawn() == 0 then
			if not caster:GetUnitName() == "npc_dota_hero_night_stalker" then
				--print("KILL!")
				caster:SetHealth(10)
				caster:ForceKill(true)
			end
		end
	end
end

function centaur_horns_emerald_haste_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local hero = caster.hero
	ability:ApplyDataDrivenModifier(caster, hero, "modifier_centaur_horns_haste_attack_damage", {})
	local attack_damage_bonus = hero:GetActualMovespeed()*ability:GetFinalGemPropertyValue("emerald", CENTAUR_HORNS_EMERALD2)
	hero:SetModifierStackCount("modifier_centaur_horns_haste_attack_damage", caster, attack_damage_bonus)
end

function monkey_paw_think(event)
	local caster = event.target
	local ability = event.ability
	ApplyDamage({victim = caster, attacker = caster, damage = 1, damage_type = DAMAGE_TYPE_PURE})
end


function wild_nature_struck(event)
	local attacker = event.attacker
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	local proc = Filters:GetProc(target, CAP_OF_WILD_NATURE_CHANCE_ONE)
	if proc then
		ability:ApplyDataDrivenModifier(caster, attacker, "modifier_wild_nature_entangle_effect", {duration = CAP_OF_WILD_NATURE_DURATION_ONE})
	end
end

function wild_nature_entangle_think(event)
	local target = event.target
	local ability = event.ability
	local inventory_unit = target:FindModifierByName("modifier_wild_nature_entangle_effect"):GetCaster()
	local caster = inventory_unit.hero
	local primeAttribute = caster:GetRoshpitPrimaryAttribute()
	local damage = 0
	if primeAttribute == 0 then
		damage = caster:GetStrength() * CAP_OF_WILD_NATURE_DAMAGE_PER_ATTRIBUTES
	elseif primeAttribute == 1 then
		damage = caster:GetAgility() * CAP_OF_WILD_NATURE_DAMAGE_PER_ATTRIBUTES
	elseif primeAttribute == 2 then
		damage = caster:GetIntellect() * CAP_OF_WILD_NATURE_DAMAGE_PER_ATTRIBUTES
	elseif primeAttribute == 3 then
		damage = caster:GetSpirit() * CAP_OF_WILD_NATURE_DAMAGE_PER_ATTRIBUTES
	end
	damage = damage * (1 + ability:GetFinalGemPropertyValue("ruby", WILD_NATURE_RUBY)/100)
	Filters:ApplyItemDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_NATURE, RPC_ELEMENT_NONE)
end

function odin_attack(event)
	local target = event.target
	local attacker = event.attacker
	local attack_damage = event.attack_damage
	attack_damage = GameState:GetPostReductionPhysicalDamage(attack_damage, target:GetPhysicalArmorValue(false))
	local proc = Filters:GetProc(attacker, ODIN_HELMET_CHANCE)
	if proc then
		ApplyDamage({victim = target, attacker = attacker, damage = attack_damage * ODIN_HELMET_MULT, damage_type = DAMAGE_TYPE_PURE})
		PopupDamage(target, attack_damage * ODIN_HELMET_MULT)
	end
end

function witch_hat_strike(event)
	local ability = event.ability
	local caster = ability.caster
	local target = event.target
	local damage = caster:GetIntellect() * SWAMP_WITCH_HAT_INT_TO_DMG

	Filters:ApplyItemDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, event.ability, RPC_ELEMENT_SHADOW, RPC_ELEMENT_NONE)
	if ability:GetGemValue("ruby") > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_witch_hat_damage_amp", {duration = SWAMP_WITCH_RUBY_DURATION})
		local newStacks = math.min(target:GetModifierStackCount("modifier_witch_hat_damage_amp", caster) + 1, SWAMP_WITCH_RUBY_MAX_STACKS)
		target:SetModifierStackCount("modifier_witch_hat_damage_amp", caster, newStacks)	
		target:CalculateAndSaveRoshpitAttributes()
	end
	if ability:GetGemValue("sapphire") > 0 then
		local mana_restore = ability:GetFinalGemPropertyValue("sapphire", SWAMP_WITCH_SAPPHIRE)
		caster:GiveMana(mana_restore)
		PopupMana(caster, mana_restore)
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn_impact_b.vpcf", caster, 1)
	end
end

function emerald_douli_damage(event)
	local target = event.unit
	local damage = event.damage
	local manaDamage = math.floor(damage * EMERALD_DOULI_MANA_DAMAGE/100)
	if target:GetMana() > manaDamage then
		target:Heal(manaDamage, target)
		target:ReduceMana(math.floor(manaDamage / 15))
	end
end

function tyrius_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if not target:HasModifier("modifier_tyrius_mana") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_tyrius_mana", {})
	end
	if not target:HasModifier("modifier_tyrius_health") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_tyrius_health", {})
	end
	target:SetModifierStackCount("modifier_tyrius_mana", ability, target:GetStrength())
	local health_stacks = target:GetStrength()*TYRIUS_HP_PER_STR + target:GetStrength()*ability:GetFinalGemPropertyValue("ruby", TYRIUS_RUBY) + target:GetSpirit()*ability:GetFinalGemPropertyValue("sapphire", TYRIUS_SAPPHIRE)
	target:SetModifierStackCount("modifier_tyrius_health", ability, health_stacks)
	if ability:GetGemValue("emerald") > 0 or ability:GetGemValue("amethyst") > 0 then
		if not target:HasModifier("modifier_tyrius_attack_damage") then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_tyrius_attack_damage", {})
		end
		local attack_damage_stacks = target:GetStrength()*ability:GetFinalGemPropertyValue("emerald", TYRIUS_EMERALD) + target:GetSpirit()*ability:GetFinalGemPropertyValue("amethyst", TYRIUS_AMETHYST)
		target:SetModifierStackCount("modifier_tyrius_attack_damage", ability, attack_damage_stacks)
	end
end

function ice_quill_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster

	local threshold = ITEM_RPC_ICE_QUILL_CARAPACE_MANA_THRESHOLD
	if not target.ice_quill_mana_prev then
		target.ice_quill_mana_prev = target:GetMana()
		target.ice_quill_mana_loss = 0
		--print("HERE?")
	end
	local mana_lost = target.ice_quill_mana_prev - target:GetMana()
	--print(mana_lost)
	if mana_lost > 0 then
		target.ice_quill_mana_loss = target.ice_quill_mana_loss + mana_lost
		--print(target.ice_quill_mana_loss)
		if target.ice_quill_mana_loss > threshold then
			local addedStacks = math.floor(target.ice_quill_mana_loss / threshold)
			target.ice_quill_mana_loss = target.ice_quill_mana_loss % threshold
			ability:ApplyDataDrivenModifier(caster, target, "modifier_ice_quill_carapace_stack", {})
			local newstacks = target:GetModifierStackCount("modifier_ice_quill_carapace_stack", caster) + addedStacks
			newStacks = math.min(newstacks, ITEM_RPC_ICE_QUILL_CARAPACE_MAX_STACKS + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_ICE_QUILL_CARAPACE_GEM_EMERALD1))
			target:SetModifierStackCount("modifier_ice_quill_carapace_stack", caster, newstacks)
		end
	end

	target.ice_quill_mana_prev = target:GetMana()
	--print("--------")
end

function ice_quill_spell_cast(event)
	local caster = event.caster
	local hero = event.unit
	local ability = event.ability
	if not hero:HasModifier("modifier_ice_quill_unloading") then
		local minimum_stacks = ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_ICE_QUILL_CARAPACE_GEM_RUBY1)
		if hero:HasModifier("modifier_ice_quill_carapace_stack") and hero:GetModifierStackCount("modifier_ice_quill_carapace_stack", caster) > minimum_stacks then
			local stacks = hero:GetModifierStackCount("modifier_ice_quill_carapace_stack", caster)
			local unload_duration = (stacks * ITEM_RPC_ICE_QUILL_CARAPACE_INTERVAL)
			ability:ApplyDataDrivenModifier(caster, hero, "modifier_ice_quill_unloading", {duration = unload_duration})
			hero:RemoveModifierByName("modifier_ice_quill_carapace_stack")
		end
	end

	-- CustomAbilities:IceQuill(event)
end

function ice_quill_unloading_think(event)
	local caster = event.caster
	local hero = event.target
	local ability = event.ability
	CustomAbilities:QuickAttachParticle("particles/roshpit/items/ice_quill_explosion.vpcf", hero, 3)
	EmitSoundOn("RPC.IceQuill", hero)
	local radius = ITEM_RPC_ICE_QUILL_CARAPACE_RADIUS
	local damage = OverflowProtectedGetAverageTrueAttackDamage(hero) * ITEM_RPC_ICE_QUILL_CARAPACE_ATTACK_TO_DMG/100 + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_ICE_QUILL_CARAPACE_GEM_RUBY2)
	local enemies = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:ApplyItemDamage(enemy, hero, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_ICE, RPC_ELEMENT_NORMAL)
		end
	end
	if ability:GetGemValue("sapphire") > 0 then
		local manaRestore = hero:GetMaxMana() * ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_ICE_QUILL_CARAPACE_GEM_SAPPHIRE)/100
		hero:GiveMana(manaRestore)
		PopupMana(hero, manaRestore)
	end
end

function midas_think(event)
	local target = event.target

	local ability = event.ability
	local caster = event.caster
	local gold = PlayerResource:GetGold(target:GetPlayerOwnerID())
	gold = target:GetGold()
	local stacks = gold / 200
	if not target:HasModifier("modifier_hand_of_midas_effect") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_hand_of_midas_effect", {})
	end
	target:SetModifierStackCount("modifier_hand_of_midas_effect", ability, stacks)
end

function weapon_critical_attack(event)
	local proc = Filters:GetProc(event.attacker, 20)
	if proc then
		local ability = event.ability
		local attacker = event.attacker
		local target = event.target
		local damage = event.attack_damage
		local stacks = attacker:GetModifierStackCount("modifier_weapon_critical_strike", ability)
		local critBonus = OverflowProtectedGetAverageTrueAttackDamage(attacker) * stacks / 100
		-- ApplyDamage({ victim = target, attacker = attacker, damage = critBonus, damage_type = DAMAGE_TYPE_PHYSICAL })
		Filters:ApplyDamageBasic(target, attacker, critBonus, DAMAGE_TYPE_PHYSICAL)
		PopupDamage(target, math.floor(damage + critBonus))
		EmitSoundOn("Hero_PhantomAssassin.CoupDeGrace", target)
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_chaos_knight/chaos_knight_weapon_blur_critical.vpcf", target, 0.5)
	end
end

function weapon_cleave_attack(event)
	local ability = event.ability
	local attacker = event.attacker
	local target = event.target
	local damage = OverflowProtectedGetAverageTrueAttackDamage(attacker)
	local stacks = attacker:GetModifierStackCount("modifier_weapon_splash_damage", ability)
	local radius = 240
	damage = damage * stacks / 100
	local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), target:GetAbsOrigin() + attacker:GetForwardVector() * 50, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:ApplyDamageBasic(enemy, attacker, damage, DAMAGE_TYPE_PHYSICAL)
			-- ApplyDamage({ victim = enemy, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL })
		end
	end
end

function blazing_fury_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local stacks = math.floor(target:GetBaseAgility() * ITEM_RPC_BLAZING_FURY_ARMOR_AGI_TO_STR_AND_INT/100, 0)
	if not target:HasModifier("modifier_blazing_fury_effect") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_blazing_fury_effect", {})
	end
	target:SetModifierStackCount("modifier_blazing_fury_effect", ability, stacks)

	if ability:GetGemValue("ruby") > 0 then
		local as_stacks = (target:GetStrength() + target:GetIntellect())*ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_BLAZING_FURY_ARMOR_GEM_RUBY)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_blazing_fury_ruby_as", {})
		target:SetModifierStackCount("modifier_blazing_fury_ruby_as", caster, as_stacks)
	end
	if ability:GetGemValue("amethyst") > 0 then
		local spirit_stacks = math.floor(target:GetBaseAgility() * ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_BLAZING_FURY_ARMOR_GEM_AMETHYST)/100, 0)
		if not target:HasModifier("modifier_blazing_fury_spirit") then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_blazing_fury_spirit", {})
		end
		target:SetModifierStackCount("modifier_blazing_fury_spirit", ability, spirit_stacks)
	end
end

function blazing_fury_attack_land(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local attacker = event.attacker
	if ability:GetGemValue("sapphire") > 0 then
		local proc = Filters:GetProc(attacker, ITEM_RPC_BLAZING_FURY_SAPPHIRE_CHANCE)
		if proc then
			ability:ApplyDataDrivenModifier(caster, attacker, "modifier_blazing_fury_sapphire_effect", {duration = ITEM_RPC_BLAZING_FURY_SAPPHIRE_DURATION})
			local as_stacks = ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_BLAZING_FURY_ARMOR_GEM_SAPPHIRE1)
			local ap_stacks = ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_BLAZING_FURY_ARMOR_GEM_SAPPHIRE2)
			ability:ApplyDataDrivenModifier(caster, attacker, "modifier_blazing_fury_sapphire_as", {duration = ITEM_RPC_BLAZING_FURY_SAPPHIRE_DURATION})
			attacker:SetModifierStackCount("modifier_blazing_fury_sapphire_as", caster, as_stacks)
			ability:ApplyDataDrivenModifier(caster, attacker, "modifier_blazing_fury_sapphire_ap", {duration = ITEM_RPC_BLAZING_FURY_SAPPHIRE_DURATION})
			attacker:SetModifierStackCount("modifier_blazing_fury_sapphire_ap", caster, ap_stacks)
			EmitSoundOn("RPCItems.BlazingFury.SapphireActivate", attacker)
		end
	end
end

function scarecrow_gloves_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local stacks = math.floor(target:GetIntellect() * ITEM_RPC_SCARECROW_GLOVES_MPREGEN_PER_INT)
	if not target:HasModifier("modifier_scarecrow_gloves_effect") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_scarecrow_gloves_effect", {})
	end
	target:SetModifierStackCount("modifier_scarecrow_gloves_effect", ability, stacks)

	if ability:GetGemValue("emerald") > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_scarecrow_gloves_emerald", {})
		local attack_speed_stacks = ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_SCARECROW_GLOVES_GEM_EMERALD)*target:GetIntellect()
		target:SetModifierStackCount("modifier_scarecrow_gloves_emerald", caster, attack_speed_stacks)
	end
	if ability:GetGemValue("amethyst") > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_scarecrow_gloves_amethyst", {})
		local attack_damage_stacks = ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_SCARECROW_GLOVES_GEM_AMETHYST)*target:GetMana()
		target:SetModifierStackCount("modifier_scarecrow_gloves_amethyst", caster, attack_damage_stacks)
	end
end

function legion_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local strStacks = math.floor(target:GetBaseStrength() * (ITEM_RPC_LEGION_VESTMENTS_ATTRIBUTE_INCREASE + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_LEGION_VESTMENTS_GEM_RUBY)/100))
	local intStacks = math.floor(target:GetBaseIntellect() * (ITEM_RPC_LEGION_VESTMENTS_ATTRIBUTE_INCREASE + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_LEGION_VESTMENTS_GEM_SAPPHIRE)/100))
	local agiStacks = math.floor(target:GetBaseAgility() * (ITEM_RPC_LEGION_VESTMENTS_ATTRIBUTE_INCREASE + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_LEGION_VESTMENTS_GEM_EMERALD)/100))
	local sprStacks = math.floor(target:GetBaseSpirit() * (ITEM_RPC_LEGION_VESTMENTS_ATTRIBUTE_INCREASE + ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_LEGION_VESTMENTS_GEM_AMETHYST)/100))
	if not target:HasModifier("modifier_legion_vestments_effect_str") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_legion_vestments_effect_str", {})
	end
	target:SetModifierStackCount("modifier_legion_vestments_effect_str", ability, strStacks)

	if not target:HasModifier("modifier_legion_vestments_effect_int") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_legion_vestments_effect_int", {})
	end
	target:SetModifierStackCount("modifier_legion_vestments_effect_int", ability, intStacks)

	if not target:HasModifier("modifier_legion_vestments_effect_agi") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_legion_vestments_effect_agi", {})
	end
	target:SetModifierStackCount("modifier_legion_vestments_effect_agi", ability, agiStacks)

	if not target:HasModifier("modifier_legion_vestments_effect_spr") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_legion_vestments_effect_spr", {})
	end
	target:SetModifierStackCount("modifier_legion_vestments_effect_spr", ability, sprStacks)
end

function living_gauntlet_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local mana_threshold_pct = ITEM_RPC_LIVING_GAUNTLET_MANA_THRESHOLD/100 + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_LIVING_GAUNTLET_GEM_SAPPHIRE1)/100
	local health_threshold_special = false
	if ability:GetGemValue("ruby") > 0 then
		if target:GetHealth() < target:GetMaxHealth()*(ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_LIVING_GAUNTLET_GEM_RUBY)/100) then
			health_threshold_special = true
		end
	end
	if target:GetMana() <= target:GetMaxMana() * mana_threshold_pct or health_threshold_special then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_living_gauntlet_effect", {})
		local health_regen_pct_total = ITEM_RPC_LIVING_GAUNTLET_HP_REGEN_PCT + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_LIVING_GAUNTLET_GEM_EMERALD)
		local health_regen_pct_stacks = health_regen_pct_total/0.1
		ability:ApplyDataDrivenModifier(caster, target, "modifier_living_gauntlet_pct_hp_regen", {})
		target:SetModifierStackCount("modifier_living_gauntlet_pct_hp_regen", caster, health_regen_pct_stacks)
		if ability:GetGemValue("amethyst") > 0 then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_living_gauntlet_hp_regen_flat", {})
			target:SetModifierStackCount("modifier_living_gauntlet_hp_regen_flat", caster, ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_LIVING_GAUNTLET_GEM_AMETHYST2))
		end
	else
		target:RemoveModifierByName("modifier_living_gauntlet_effect")
	end
end

function phoenix_gloves_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local stacks = (target:GetMaxHealth() - target:GetHealth()) * ITEM_RPC_PHOENIX_GLOVES_HP_REGEN_PER_MISSING_HP
	if not target:HasModifier("modifier_phoenix_gloves_effect") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_phoenix_gloves_effect", {})
	end
	target:SetModifierStackCount("modifier_phoenix_gloves_effect", ability, stacks)
	if ability:GetGemValue("sapphire") > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_phoenix_gloves_attack_damage", {})
		local damageStacks = target:GetHealth() * ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_PHOENIX_GLOVES_GEM_SAPPHIRE)
		target:SetModifierStackCount("modifier_phoenix_gloves_attack_damage", ability, damageStacks)
	end
end

function guardian_greaves_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
	if ability:GetGemValue("ruby") > 0 then
		if not ability.lastPos then
			ability.lastPos = target:GetAbsOrigin()
		end
		if not ability.distanceMoved then
			ability.distanceMoved = 0
		end
		ability.newPos = target:GetAbsOrigin()
		ability.hero = target
		local distance = WallPhysics:GetDistance(ability.newPos, ability.lastPos)
		ability.distanceMoved = ability.distanceMoved + distance
		local distance_threshold = ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_GUARDIAN_GREAVES_GEM_RUBY)
		if ability.distanceMoved > distance_threshold then
			Filters:GuardianGreavesCast(hero, ability)
			ability.distanceMoved = ability.distanceMoved % distance_threshold
		end

		ability.lastPos = target:GetAbsOrigin()
	end
end





function sange_boots_think(event)
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
	if ability:GetGemValue("amethyst") > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_rpc_sange_sapphire", {})
		local atk_damage = hero:GetAgility()*ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_SANGE_BOOTS_GEM_AMETHYST) 
		hero:SetModifierStackCount("modifier_rpc_sange_sapphire", caster, atk_damage)
	end
end

function yasha_boots_think(event)
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
	if not hero:HasModifier("modifier_rpc_yasha_buff") then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_rpc_yasha_buff", {})
	end
	local as_stacks = hero:GetStrength()*ITEM_RPC_YASHA_BOOTS_ATK_SPD_PER_STR
	hero:SetModifierStackCount("modifier_rpc_yasha_buff", ability, as_stacks)
	if ability:GetGemValue("amethyst") > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_rpc_yasha_amethyst", {})
		local atk_damage = hero:GetStrength()*ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_YASHA_BOOTS_GEM_AMETHYST) 
		hero:SetModifierStackCount("modifier_rpc_yasha_amethyst", caster, atk_damage)
	end
	if ability:GetGemValue("sapphire") > 0 then
		if not hero:HasModifier("modifier_yasha_sapphire") then
			ability:ApplyDataDrivenModifier(caster, hero, "modifier_yasha_sapphire", {})
			local ms_pct_stacks = ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_YASHA_BOOTS_GEM_SAPPHIRE) 
			hero:SetModifierStackCount("modifier_yasha_sapphire", ability, ms_pct_stacks)
		end
	end
end

function mana_striders_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	if not ability.lastPos then
		ability.lastPos = target:GetAbsOrigin()
	end
	if not ability.distanceMoved then
		ability.distanceMoved = 0
	end
	ability.newPos = target:GetAbsOrigin()
	ability.hero = target
	local distance = WallPhysics:GetDistance(ability.newPos, ability.lastPos)
	ability.distanceMoved = ability.distanceMoved + distance
	if ability.distanceMoved > ITEM_RPC_MANA_STRIDERS_DISTANCE then
		if not ability.active then
			-- StartSoundEvent("Hero_Leshrac.Diabolic_Edict_lp", target)
		end
		ability.active = true
		for i = 1, ability.distanceMoved / ITEM_RPC_MANA_STRIDERS_DISTANCE, 1 do
			mana_striders_heal(target)
			if i > 3 then
				break
			end
		end
		ability.distanceMoved = ability.distanceMoved % ITEM_RPC_MANA_STRIDERS_DISTANCE
	else
		if distance < 20 then
			ability.active = false
			-- StopSoundEvent("Hero_Leshrac.Diabolic_Edict_lp", target)
		end
	end

	ability.lastPos = target:GetAbsOrigin()

	if ability:GetGemValue("emerald") > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_mana_strider_ms", {})
		local ms_bonus = math.floor((target:GetMana()/target:GetMaxMana())*100) * ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_MANA_STRIDERS_GEM_EMERALD2)
		local ms_stacks = ms_bonus/0.1
		target:SetModifierStackCount("modifier_mana_strider_ms", caster, ms_stacks)
	end
end

function mana_striders_heal(hero)
	local manaRestore = WallPhysics:round(hero:GetMaxMana() * ITEM_RPC_MANA_STRIDERS_MANA_RESTORE_PCT/100, 0)
	local particleName = "particles/units/heroes/hero_obsidian_destroyer/obsidian_death_flash.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, hero)
	ParticleManager:SetParticleControlEnt(pfx, 0, hero, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)
	Timers:CreateTimer(1, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	hero:GiveMana(manaRestore)
	PopupMana(hero, manaRestore)
end

function falcon_boot_impact(event)
	local target = event.target
	local ability = event.ability
	----print(event.target_entities[1]:GetUnitName())
	-- DeepPrintTable(event)
	if target:HasModifier("modifier_falcon_out") or target:HasModifier("modifier_falcon_lift_immune") then
		return false
	end
	if target.jumpLock or target.pushLock then
		Filters:FalconAmethystDamage(event.ability.hero, target)
		return false
	end
	local origCaster = event.ability.hero
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_beastmaster/beastmaster_call_bird_glow_base.vpcf", PATTACH_CUSTOMORIGIN, origCaster)
	ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin() + Vector(0, 0, 80))
	if not ability.liftedTargetsTable then
		ability.liftedTargetsTable = {}
	end
	ability:ApplyDataDrivenModifier(origCaster.InventoryUnit, target, "modifier_falcon_lift_immune", {duration = 3})
	table.insert(ability.liftedTargetsTable, target)
	Timers:CreateTimer(5.5, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:ReleaseParticleIndex(pfx)
	end)
	ability:ApplyDataDrivenModifier(origCaster.InventoryUnit, target, "modifier_falcon_out", {duration = ability.travel_delay + 0.25})
	target:SetAbsOrigin(target:GetAbsOrigin() - Vector(0, 0, 2000))
end

function sapphire_lotus_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if not target:HasModifier("modifier_sapphire_lotus_buff") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_sapphire_lotus_buff", {})
		ability:ApplyDataDrivenModifier(caster, target, "modifier_sapphire_lotus_buff_mana", {})
	end
	target:SetModifierStackCount("modifier_sapphire_lotus_buff", ability, target:GetIntellect())
	target:SetModifierStackCount("modifier_sapphire_lotus_buff_mana", ability, ITEM_RPC_SAPPHIRE_LOTUS_MP_PER_INT * target:GetIntellect())
end

function lifesource_vessel_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if ability:GetGemValue("emerald") > 0 then
		local stacks = math.floor(target:GetSumOfAllAttributes() * ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_LIFESOURCE_VESSEL_GEM_EMERALD))/0.1
		if not target:HasModifier("modifier_lifesource_vessel_buff") then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_lifesource_vessel_buff", {})
		end
		target:SetModifierStackCount("modifier_lifesource_vessel_buff", ability, stacks)
	end
	if ability:GetGemValue("ruby") > 0 then
		if not ability.interval then
			ability.interval = 0
		end
		ability.interval = ability.interval + 1
		if ability.interval >= ITEM_RPC_LIFESOURCE_VESSEL_RUBY_HEAL_INTERVAL/0.1 then
			ability.interval = 0
			CustomAbilities:QuickAttachParticle("particles/roshpit/draghor/mark_of_the_claw_heal.vpcf", target, 0.7)
			local healAmount = target:GetMaxHealth()*(ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_LIFESOURCE_VESSEL_GEM_RUBY)/100)
			Filters:ApplyHeal(target, target, healAmount, true, true)
		end
	end
end

function saytaru_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local threshold = (ITEM_RPC_HOPE_OF_SAYTARU_HP_THRESHOLD_PCT + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_HOPE_OF_SAYTARU_GEM_RUBY))/100
	if target:GetHealth() <= threshold * target:GetMaxHealth() then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_hope_of_saytaru_effect", {})
	else
		target:RemoveModifierByName("modifier_hope_of_saytaru_effect")
	end
end

function azure_empire_init(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	target.birdTable = {}
	for i = 1, 3, 1 do
		local bird = CreateUnitByName("tracer_unit", target:GetAbsOrigin(), true, nil, nil, target:GetTeamNumber())
		bird.hero = target
		bird.interval = 0
		bird.state = 0
		bird:SetModel("models/items/beastmaster/hawk/fotw_eagle/fotw_eagle.vmdl")
		bird:SetOriginalModel("models/items/beastmaster/hawk/fotw_eagle/fotw_eagle.vmdl")
		bird:SetModelScale(0.5)
		table.insert(target.birdTable, bird)
		ability:ApplyDataDrivenModifier(caster, bird, "modifier_azure_empire_buff", {})
		if ability.newItemTable.property2name == "!immortal!_modifier_azure_empire_hero_silver" then
			-- ability:ApplyDataDrivenModifier(caster, bird, "modifier_azure_hawk_silver", {})
			bird.pfx = ParticleManager:CreateParticle("particles/econ/generic/generic_buff_1/azure_empire.vpcf", PATTACH_ABSORIGIN_FOLLOW, bird)
			ParticleManager:SetParticleControlEnt(bird.pfx, 0, bird, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", bird:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(bird.pfx, 15, Vector(180, 190, 255))
		elseif ability.newItemTable.property2name == "!immortal!_modifier_azure_empire_hero_green" then
			bird.pfx = ParticleManager:CreateParticle("particles/econ/generic/generic_buff_1/azure_empire.vpcf", PATTACH_ABSORIGIN_FOLLOW, bird)
			ParticleManager:SetParticleControlEnt(bird.pfx, 0, bird, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", bird:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(bird.pfx, 15, Vector(80, 255, 80))
		elseif ability.newItemTable.property2name == "!immortal!_modifier_azure_empire_hero_blue" then
			bird.pfx = ParticleManager:CreateParticle("particles/econ/generic/generic_buff_1/azure_empire.vpcf", PATTACH_ABSORIGIN_FOLLOW, bird)
			ParticleManager:SetParticleControlEnt(bird.pfx, 0, bird, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", bird:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(bird.pfx, 15, Vector(80, 80, 255))
		elseif ability.newItemTable.property2name == "!immortal!_modifier_azure_empire_hero_red" then
			bird.pfx = ParticleManager:CreateParticle("particles/econ/generic/generic_buff_1/azure_empire.vpcf", PATTACH_ABSORIGIN_FOLLOW, bird)
			ParticleManager:SetParticleControlEnt(bird.pfx, 0, bird, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", bird:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(bird.pfx, 15, Vector(255, 80, 80))
		elseif ability.newItemTable.property2name == "!immortal!_modifier_azure_empire_hero_purple" then
			bird.pfx = ParticleManager:CreateParticle("particles/econ/generic/generic_buff_1/azure_empire.vpcf", PATTACH_ABSORIGIN_FOLLOW, bird)
			ParticleManager:SetParticleControlEnt(bird.pfx, 0, bird, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", bird:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(bird.pfx, 15, Vector(185, 80, 255))
		end
		bird.index = i
		StartAnimation(bird, {duration = 99999, activity = ACT_DOTA_IDLE, rate = 1.0})
	end
	ability:ApplyDataDrivenModifier(caster, target, "modifier_azure_empire_visible", {})
	target:SetModifierStackCount("modifier_azure_empire_visible", caster, 3)
end

function azure_hawk_think(event)
	local bird = event.target
	if bird:HasModifier("modifier_azure_hawk_dead") then
		return false
	end
	local hero = bird.hero
	local heroPosition = hero:GetAbsOrigin()
	local fv = hero:GetForwardVector()
	local perpFv = WallPhysics:rotateVector(fv, math.pi / 2)
	heroPosition = heroPosition - fv * 40
	if bird.state == 0 then
		if bird.index == 1 then
			bird:MoveToPosition(heroPosition + perpFv * 90)
		elseif bird.index == 2 then
			bird:MoveToPosition(heroPosition)
		elseif bird.index == 3 then
			bird:MoveToPosition(heroPosition - perpFv * 90)
		end
	end
end

function azure_empire_end(event)
	local target = event.target
	target:RemoveModifierByName("modifier_azure_empire_visible")
	target:RemoveModifierByName("modifier_azure_empire_base_ability")
	target:RemoveModifierByName("modifier_azure_empire_agility")
	target:RemoveModifierByName("modifier_azure_empire_strength")
	target:RemoveModifierByName("modifier_azure_empire_intelligence")
	target:RemoveModifierByName("modifier_azure_empire_spirit")
	for i = 1, #target.birdTable, 1 do
		UTIL_Remove(target.birdTable[i])
	end
	target.birdTable = nil
end

function azure_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local stacks = target:GetModifierStackCount("modifier_azure_empire_visible", caster)
	local heroLevel = target:GetLevel()
	if ability.newItemTable.property2name == "!immortal!_modifier_azure_empire_hero_silver" then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_azure_empire_base_ability", {})
		target:SetModifierStackCount("modifier_azure_empire_base_ability", caster, stacks)
	elseif ability.newItemTable.property2name == "!immortal!_modifier_azure_empire_hero_green" then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_azure_empire_agility", {})
		target:SetModifierStackCount("modifier_azure_empire_agility", caster, heroLevel * stacks)
	elseif ability.newItemTable.property2name == "!immortal!_modifier_azure_empire_hero_red" then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_azure_empire_strength", {})
		target:SetModifierStackCount("modifier_azure_empire_strength", caster, heroLevel * stacks)
	elseif ability.newItemTable.property2name == "!immortal!_modifier_azure_empire_hero_blue" then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_azure_empire_intelligence", {})
		target:SetModifierStackCount("modifier_azure_empire_intelligence", caster, heroLevel * stacks)
	elseif ability.newItemTable.property2name == "!immortal!_modifier_azure_empire_hero_purple" then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_azure_empire_spirit", {})
		target:SetModifierStackCount("modifier_azure_empire_spirit", caster, heroLevel * stacks)
	end
end

function azure_hawk_dead_end(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local bird = target
	StartAnimation(target, {duration = 99999, activity = ACT_DOTA_IDLE, rate = 1.0})
	Timers:CreateTimer(0.05, function()
		bird:RemoveNoDraw()
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_puck/puck_base_attack_explosion.vpcf", bird, 1.5)
	end)
	local hero = bird.hero
	local heroPosition = hero:GetAbsOrigin()
	local fv = hero:GetForwardVector()

	local perpFv = WallPhysics:rotateVector(fv, math.pi / 2)
	if bird.index == 1 then
		bird:SetAbsOrigin(heroPosition + perpFv * 90)
	elseif bird.index == 2 then
		bird:SetAbsOrigin(heroPosition)
	elseif bird.index == 3 then
		bird:SetAbsOrigin(heroPosition - perpFv * 90)
	end
	if ability.newItemTable.property2name == "!immortal!_modifier_azure_empire_hero_silver" then
		bird.pfx = ParticleManager:CreateParticle("particles/econ/generic/generic_buff_1/azure_empire.vpcf", PATTACH_ABSORIGIN_FOLLOW, bird)
		ParticleManager:SetParticleControlEnt(bird.pfx, 0, bird, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", bird:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(bird.pfx, 15, Vector(180, 190, 255))
		-- ability:ApplyDataDrivenModifier(caster, bird, "modifier_azure_hawk_silver", {})
	elseif ability.newItemTable.property2name == "!immortal!_modifier_azure_empire_hero_green" then
		bird.pfx = ParticleManager:CreateParticle("particles/econ/generic/generic_buff_1/azure_empire.vpcf", PATTACH_ABSORIGIN_FOLLOW, bird)
		ParticleManager:SetParticleControlEnt(bird.pfx, 0, bird, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", bird:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(bird.pfx, 15, Vector(80, 255, 80))
		-- ability:ApplyDataDrivenModifier(caster, bird, "modifier_azure_hawk_green", {})
	elseif ability.newItemTable.property2name == "!immortal!_modifier_azure_empire_hero_blue" then
		bird.pfx = ParticleManager:CreateParticle("particles/econ/generic/generic_buff_1/azure_empire.vpcf", PATTACH_ABSORIGIN_FOLLOW, bird)
		ParticleManager:SetParticleControlEnt(bird.pfx, 0, bird, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", bird:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(bird.pfx, 15, Vector(80, 80, 255))
		-- ability:ApplyDataDrivenModifier(caster, bird, "modifier_azure_hawk_blue", {})
	elseif ability.newItemTable.property2name == "!immortal!_modifier_azure_empire_hero_red" then
		bird.pfx = ParticleManager:CreateParticle("particles/econ/generic/generic_buff_1/azure_empire.vpcf", PATTACH_ABSORIGIN_FOLLOW, bird)
		ParticleManager:SetParticleControlEnt(bird.pfx, 0, bird, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", bird:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(bird.pfx, 15, Vector(255, 80, 80))
		-- ability:ApplyDataDrivenModifier(caster, bird, "modifier_azure_hawk_red", {})
	elseif ability.newItemTable.property2name == "!immortal!_modifier_azure_empire_hero_purple" then
		bird.pfx = ParticleManager:CreateParticle("particles/econ/generic/generic_buff_1/azure_empire.vpcf", PATTACH_ABSORIGIN_FOLLOW, bird)
		ParticleManager:SetParticleControlEnt(bird.pfx, 0, bird, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", bird:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(bird.pfx, 15, Vector(185, 80, 255))
		--print("APPLY PURPLE BUFF?")
		-- ability:ApplyDataDrivenModifier(caster, bird, "modifier_azure_hawk_red", {})
	end
	local birdStacks = 0
	for i = 1, #bird.hero.birdTable, 1 do
		local bird = bird.hero.birdTable[i]
		if not bird:HasModifier("modifier_azure_hawk_dead") then
			birdStacks = birdStacks + 1
		end
	end
	ability:ApplyDataDrivenModifier(caster, bird.hero, "modifier_azure_empire_visible", {})
	bird.hero:SetModifierStackCount("modifier_azure_empire_visible", caster, 3)
end

function super_ascension_init(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	target:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)

	local particleName = "particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	Timers:CreateTimer(1.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
end

function super_ascension_end(event)
	local caster = event.caster
	local target = event.target
	target:RemoveModifierByName("modifier_super_ascendency_lua")
	target:RemoveModifierByName("modifier_ascendency_base_attack_damage")
	if not target:HasModifier("modifier_tomahawk_buffs") and not target:HasModifier("modifier_chernobog_demonform_lua") and not target:HasModifier("modifier_arkimus_archon_form") and not target:HasModifier("modifier_demon_flight_flying") then
		--print("SET TO MELEE")
		target:SetAttackCapability(target.baseAttackCapability)
	end
	-- target:SetRangedProjectileName(target.originalProjectile)
end

function super_ascension_attack(event)
	local caster = event.caster
	local hero = event.attacker
	local ability = event.ability
	if ability:GetGemValue("emerald") > 0 then
		local cd_reduction = ability:GetFinalGemPropertyValue("emerald", SUPER_ASCENDENCY_EMERALD)
		local ulti = hero:GetAbilityByIndex(DOTA_R_SLOT)
		local currentCD = ulti:GetCooldownTimeRemaining()
		ulti:EndCooldown()
		ulti:StartCooldown(currentCD - cd_reduction)
	end
end

function super_ascension_attack_start(event)
	local caster = event.attacker
	local ability = event.ability
	local target = event.target
	if not caster:HasModifier("modifier_ascendency_dont_split") then
		local splitCount = 0
		local split_count = SUPER_ASCENDENCY_SPLIT_TARGETS_BASE + ability:GetFinalGemPropertyValue("ruby", SUPER_ASCENDENCY_RUBY)
		local procs = split_count
		if procs > 0 then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, SUPER_ASCENDENCY_SEARCH_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				for _, enemy in pairs(enemies) do
					if enemy:GetEntityIndex() == target:GetEntityIndex() or enemy.dummy then
					else
						if splitCount < procs then
							Filters:PerformAttackSpecial(caster, enemy, true, true, true, false, true, false, false)
							splitCount = splitCount + 1
						end
					end
				end
			end
			ability:ApplyDataDrivenModifier(event.caster, caster, "modifier_ascendency_dont_split", {duration = 0.15})
		end
	end
end

function lifesteal_land(event)
	local attacker = event.attacker
	local ability = event.ability
	local damage = event.attack_damage
	local helmAbility = ability
	local current_stack = attacker:GetModifierStackCount("modifier_helm_lifesteal", helmAbility)
	local lifesteal = math.floor(damage * current_stack / 100)

	Filters:ApplyHeal(attacker, attacker, lifesteal, true)

	local particleName = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, attacker)
	ParticleManager:SetParticleControlEnt(pfx, 0, attacker, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin() + Vector(0, 0, 70), true)
	Timers:CreateTimer(1, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	--print("lifesteal land")
end

function nightmare_rider_initialize(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	if ability:GetGemValue("sapphire") > 0 then
		ability.orbTable = {}
		for i = 1, 3, 1 do
			local orb = CreateUnitByName("nightmare_rider_orb", target:GetAbsOrigin(), true, nil, nil, target:GetTeamNumber())
			orb.hero = target
			orb.owner = target:GetPlayerOwnerID()
			orb.interval = 0
			orb.state = 0
			orb:SetModel("models/props_gameplay/rune_arcane.vmdl")
			orb:SetOriginalModel("models/props_gameplay/rune_arcane.vmdl")
			orb:SetModelScale(0.01)
			table.insert(ability.orbTable, orb)
			ability:ApplyDataDrivenModifier(caster, orb, "modifier_nightmare_rider_orb_buff", {})
			orb.index = i
			local offsetRadians = (2 * math.pi / 3) * (i - 1)
			orb.offsetVector = WallPhysics:rotateVector(Vector(1, 1), offsetRadians)
			orb:SetOwner(target)
			orb:SetControllableByPlayer(target:GetPlayerID(), true)
			orb:SetBaseDamageMin(0)
			orb:SetBaseDamageMax(0)
		end
	end
end

function nightmare_orb_attack_land(event)
	local hero = event.caster.hero
	local target = event.target
	local damage = OverflowProtectedGetAverageTrueAttackDamage(hero)*hero.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_NIGHTMARE_RIDER_MANTLE_GEM_SAPPHIRE)/100
	Filters:ApplyItemDamage(target, hero, damage, DAMAGE_TYPE_PHYSICAL, nil, RPC_ELEMENT_SHADOW, RPC_ELEMENT_NONE)
end

function nightmare_rider_orb_think(event)
	local orb = event.target
	local hero = orb.hero
	orb.offsetVector = WallPhysics:rotateVector(orb.offsetVector, math.pi / 40)
	orb:SetAbsOrigin(hero:GetAbsOrigin() + orb.offsetVector * 120)
end

function nightmare_rider_end(event)
	local target = event.target
	local ability = event.ability
	if ability.orbTable then
		for i = 1, #ability.orbTable, 1 do
			UTIL_Remove(ability.orbTable[i])
		end
		ability.orbTable = false
	end
end

function space_tech_channel_think(event)
	local inventory_unit = event.caster
	local hero = inventory_unit.hero
	local ability = event.ability
	local position = hero:GetAbsOrigin()
	local particleName = "particles/units/heroes/hero_faceless_void/faceless_void_timedialate.vpcf"
	local particle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, hero)
	local radius = ITEM_RPC_SPACE_TECH_VEST_RADIUS
	ParticleManager:SetParticleControl(particle, 0, position)
	ParticleManager:SetParticleControl(particle, 1, Vector(radius, radius, radius))

	if ability:GetGemValue("ruby") > 0 then
		ability:ApplyDataDrivenModifier(inventory_unit, hero, "modifier_space_tech_buff_visible", {duration = ITEM_RPC_SPACE_TECH_VEST_BUFF_DURATION})
		local stackCount = hero:GetModifierStackCount("modifier_space_tech_buff_visible", inventory_unit)
		local new_stacks = math.min(stackCount + 1, ability.ruby_ticks)
		hero:SetModifierStackCount("modifier_space_tech_buff_visible", inventory_unit, new_stacks)

		-- "modifier_space_tech_buff_invisible" - each stack represents 1 BAD and 1 item damage %
		local total_bad = ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_SPACE_TECH_VEST_GEM_RUBY)
		local bad_per_stack = total_bad/ability.ruby_ticks
		ability:ApplyDataDrivenModifier(inventory_unit, hero, "modifier_space_tech_buff_invisible", {duration = ITEM_RPC_SPACE_TECH_VEST_DURATION})
		hero:SetModifierStackCount("modifier_space_tech_buff_invisible", inventory_unit, math.ceil(bad_per_stack*new_stacks))
	end
	if ability:GetGemValue("emerald") > 0 then
		local cd_reduction_per_tick = (ability.r_cooldown * ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_SPACE_TECH_VEST_GEM_EMERALD)/100)/ability.ruby_ticks
		local ult = hero:GetAbilityByIndex(DOTA_R_SLOT)
		Filters:ReduceCooldownGeneric(hero, ult, cd_reduction_per_tick)
	end

	local enemies = FindUnitsInRadius(hero:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			ability:ApplyDataDrivenModifier(inventory_unit, enemy, "modifier_space_tech_slow", {duration = ITEM_RPC_SPACE_TECH_VEST_DURATION})
			local stacks = enemy:GetModifierStackCount("modifier_space_tech_slow", inventory_unit)
			local new_stacks = math.min(stacks + 1, ITEM_RPC_SPACE_TECH_VEST_MAX_SLOW_STACKS)
			enemy:SetModifierStackCount("modifier_space_tech_slow", inventory_unit, new_stacks)
			if ability:GetGemValue("sapphire") > 0 and new_stacks == ITEM_RPC_SPACE_TECH_VEST_MAX_SLOW_STACKS then
				if not enemy:HasModifier("modifier_space_tech_frozen") then
					local sapphire_duration = ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_SPACE_TECH_VEST_GEM_SAPPHIRE)
					ability:ApplyDataDrivenModifier(inventory_unit, enemy, "modifier_space_tech_frozen", {duration = sapphire_duration})
				end
			end

		end
	end
end

function stormshield_cloak_initialize(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	if target.shieldTable then
		return
	end
	ability.shieldTable = {}
	ability.attacks_taken = 0
	local shield_count = 3 + ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_STORMSHIELD_CLOAK_GEM_AMETHYST)
	for i = 1, shield_count, 1 do
		local shield = CreateUnitByName("tracer_unit", target:GetAbsOrigin(), true, nil, nil, target:GetTeamNumber())
		shield.hero = target
		shield.owner = target:GetPlayerOwnerID()
		shield.interval = 0
		shield.state = 0
		shield:SetModel("models/props_gameplay/status_shield.vmdl")
		shield:SetOriginalModel("models/props_gameplay/status_shield.vmdl")
		shield:SetModelScale(2.0)
		table.insert(ability.shieldTable, shield)
		ability:ApplyDataDrivenModifier(caster, shield, "modifier_stormshield_cloak_shield_buff", {})
		shield.index = i
		local offsetRadians = (2 * math.pi / shield_count) * (i - 1)
		shield.offsetVector = WallPhysics:rotateVector(Vector(1, 1), offsetRadians)
		shield:SetOwner(target)
	end
	stormshield_cloak_update_active_shield_count(target, ability)
end

function stormshield_cloak_attacked(event)
	local target = event.target
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	if hero:GetModifierStackCount("modifier_stormshield_active_shields", hero.InventoryUnit) > 0 then
		ability.attacks_taken = ability.attacks_taken + 1
		if ability.attacks_taken >= ITEM_RPC_STORMSHIELD_CLOAK_ATTACKS_TO_BREAK then
			ability.attacks_taken = 0
			local regen_time = math.max(ITEM_RPC_STORMSHIELD_CLOAK_RESTORE_TIME - ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_STORMSHIELD_CLOAK_GEM_EMERALD), 0.1)
			for i = 1, #ability.shieldTable, 1 do
				if not ability.shieldTable[i]:HasModifier("modifier_stormshield_inactive") then
					ability:ApplyDataDrivenModifier(hero.InventoryUnit, ability.shieldTable[i], "modifier_stormshield_inactive", {duration = regen_time})
					stormshield_shield_explode(ability.shieldTable[i]:GetAbsOrigin(), hero, ability)
					ability.shieldTable[i]:AddNoDraw()
					break
				end
			end
			stormshield_cloak_update_active_shield_count(target, ability)
		end
	end

end

function stormshield_shield_explode(shield_position, hero, ability)
	if ability:GetGemValue("sapphire") > 0 then
		local position = shield_position
		CustomAbilities:QuickParticleAtPoint("particles/roshpit/items/stormshield_cloak_explode.vpcf", position+Vector(0,0,60), 4)
		local damage = hero:GetRoshpitArmor()*ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_STORMSHIELD_CLOAK_GEM_SAPPHIRE1)
		local stun_duration = ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_STORMSHIELD_CLOAK_GEM_SAPPHIRE2)
	    local enemies = FindUnitsInRadius(hero:GetTeamNumber(), position, nil, ITEM_RPC_STORMSHIELD_CLOAK_SAPPHIRE_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	    if #enemies > 0 then
	        for _, enemy in pairs(enemies) do
	            Filters:ApplyItemDamage(enemy, hero, damage, DAMAGE_TYPE_PHYSICAL, ability, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
	            Filters:ApplyStun(hero, stun_duration, enemy)
			end
		end	
		EmitSoundOn("RPCItem.Stormshield.Explode", hero)
		local particle = ParticleManager:CreateParticle("particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(particle, 0, shield_position+Vector(0,0,60))
		ParticleManager:SetParticleControl(particle, 1, Vector(ITEM_RPC_STORMSHIELD_CLOAK_SAPPHIRE_RADIUS, ITEM_RPC_STORMSHIELD_CLOAK_SAPPHIRE_RADIUS, ITEM_RPC_STORMSHIELD_CLOAK_SAPPHIRE_RADIUS))
		ParticleManager:SetParticleControl(particle, 2, Vector(0.6, 0.6, 0.6))
		ParticleManager:SetParticleControl(particle, 4, Vector(90, 90, 90))
		Timers:CreateTimer(1.5, function()
			ParticleManager:DestroyParticle(particle, false)
		end)
	end
end

function stormshield_broken_shield_restore(event)
	local shield = event.target
	local hero = shield.hero
	local ability = event.ability
	local caster = event.caster
	shield:RemoveNoDraw()
	stormshield_cloak_update_active_shield_count(hero, ability)
	local particle = ParticleManager:CreateParticle("particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(particle, 0, shield:GetAbsOrigin()+Vector(0,0,100))
	ParticleManager:SetParticleControl(particle, 1, Vector(100, 100, 100))
	ParticleManager:SetParticleControl(particle, 2, Vector(0.7, 0.7, 0.7))
	ParticleManager:SetParticleControl(particle, 4, Vector(90, 90, 90))
	Timers:CreateTimer(1.5, function()
		ParticleManager:DestroyParticle(particle, false)
	end)
end

function stormshield_cloak_update_active_shield_count(hero, ability)
	local count = 0
	for i = 1, #ability.shieldTable, 1 do
		if not ability.shieldTable[i]:HasModifier("modifier_stormshield_inactive") then
			count = count + 1
		end
	end
	ability:ApplyDataDrivenModifier(hero.InventoryUnit, hero, "modifier_stormshield_active_shields", {})
	hero:SetModifierStackCount("modifier_stormshield_active_shields", hero.InventoryUnit, count)
end

function stormshield_main_think(event)

	local caster = event.target
	local position = caster:GetAbsOrigin()
	local radius = 200
	local damage = (caster:GetPhysicalArmorValue(false) * 20) / 3
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		EmitSoundOn("ui.inv_equip_metalblade", caster.shieldTable[1])
		if #enemies > 3 then
			EmitSoundOn("ui.inv_equip_metalblade", caster.shieldTable[2])
		end
		if #enemies > 6 then
			EmitSoundOn("ui.inv_equip_metalblade", caster.shieldTable[3])
		end
		for _, enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR})
		end
	end
end

function stormshield_cloak_shield_think(event)
	local shield = event.target
	if IsValidEntity(shield) then
		local hero = shield.hero
		shield.offsetVector = WallPhysics:rotateVector(shield.offsetVector, math.pi / 20)
		local heroOrigin = hero:GetAbsOrigin()
		local position = heroOrigin + shield.offsetVector * 60 - Vector(0, 0, 65)
		shield:SetAbsOrigin(position)
		local fv = (position - heroOrigin):Normalized() * Vector(1, 1, 0)
		shield:SetForwardVector(fv)
	end
end

function stormshield_cloak_end(event)
	--print("SHIELD END")
	local ability = event.ability
	local target = event.target
	for i = 1, #ability.shieldTable, 1 do
		UTIL_Remove(ability.shieldTable[i])
	end
	ability.shieldTable = false
end

function bladestorm_vest_initialize(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	ability.bladeTable = {}
end

function bladestorm_vest_end(event)
	local target = event.target
	local ability = event.ability
	for i = 1, #ability.bladeTable, 1 do
		UTIL_Remove(ability.bladeTable[i])
	end
	target:RemoveModifierByName("modifier_bladestorm_vest_buff")
	ability.bladeTable = false
end

function bladestorm_vest_attack_hit(event)
	local attacker = event.attacker
	local ability = event.ability
	local caster = event.caster
	local new_stacks = 0
	if attacker:GetModifierStackCount("modifier_bladestorm_vest_buff", caster) < ITEM_RPC_BLADESTORM_VEST_MAX_STACKS then
		ability:ApplyDataDrivenModifier(caster, attacker, "modifier_bladestorm_attack_stacking", {})
		new_stacks = attacker:GetModifierStackCount("modifier_bladestorm_attack_stacking", caster) + 1
		attacker:SetModifierStackCount("modifier_bladestorm_attack_stacking", caster, new_stacks)
	end
	local attacks_required = ITEM_RPC_BLADESTORM_VEST_NUMBER_OF_ATTACKS
	if ability:GetGemValue("ruby") > 0 then
		attacks_required = ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_BLADESTORM_VEST_GEM_RUBY)
	end
	if new_stacks >= attacks_required then
		ability:ApplyDataDrivenModifier(caster, attacker, "modifier_bladestorm_vest_buff", {})
		local currentStacks = #ability.bladeTable
		local stacks = math.min(currentStacks + 1, ITEM_RPC_BLADESTORM_VEST_MAX_STACKS)
		attacker:SetModifierStackCount("modifier_bladestorm_vest_buff", caster, stacks)
		attacker:RemoveModifierByName("modifier_bladestorm_attack_stacking")

		if currentStacks < ITEM_RPC_BLADESTORM_VEST_MAX_STACKS then
			Filters:ModifyBladestormVestSwordCount(attacker, stacks, ability, caster, 1)
		end
	end

end

function undertaker_attack(event)
	local attacker = event.attacker
	local ability = event.ability
	local target = event.target
	local caster = event.caster
	if not attacker:HasModifier("modifier_undertaker_lock") then
		local loops = 1
		local proc = Filters:GetProc(attacker, ability:GetFinalGemPropertyValue("amethyst", UNDERTAKER_AMETHYST))
		if proc then
			loops = 2
		end
		ability.caster = attacker
		for i = 1, loops, 1 do
			Timers:CreateTimer((i-1)*0.15, function()
				local travel_speed = UNDERTAKER_HAND_BASE_SPEED + ability:GetFinalGemPropertyValue("emerald", UNDERTAKER_EMERALD1)
				local info =
				{
					Target = target,
					Source = attacker,
					Ability = ability,
					EffectName = "particles/econ/items/necrolyte/necrophos_sullen/necro_sullen_pulse_enemy.vpcf",
					StartPosition = "attach_attack1",
					bDrawsOnMinimap = false,
					bDodgeable = true,
					bIsAttack = false,
					bVisibleToEnemies = true,
					bReplaceExisting = false,
					flExpireTime = GameRules:GetGameTime() + 10,
					bProvidesVision = true,
					iVisionRadius = 100,
					iMoveSpeed = travel_speed,
				iVisionTeamNumber = attacker:GetTeamNumber()}
				projectile = ProjectileManager:CreateTrackingProjectile(info)
				ability:ApplyDataDrivenModifier(caster, attacker, "modifier_undertaker_lock", {duration = 0.15})
			end)
		end
	end
end

function undertaker_think(event)
	local ability = event.ability
	local target = event.target
	local caster = event.caster
	if ability:GetGemValue("ruby") > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_undertaker_as", {})
		local as_bonus = ability:GetFinalGemPropertyValue("ruby", UNDERTAKER_RUBY)*target:GetIntellect()
		target:SetModifierStackCount("modifier_undertaker_as", caster, as_bonus)
	end
end

function undertaker_projectile_strike(event)
	local target = event.target
	local caster = event.ability.caster
	local ability = caster.equipped_gear[RPC_GEAR_SLOT_HEAD]
	local damage = caster:GetIntellect() * UNDERTAKER_DAMAGE_INT_MULT
	Filters:ApplyItemDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, event.ability, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_GHOST)
	if ability:GetGemValue("sapphire") > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_undertaker_magic_armor_loss", {duration = UNDERTAKER_SAPPHIRE_DURATION})
		local new_stacks = math.min(target:GetModifierStackCount("modifier_undertaker_magic_armor_loss", caster) + 1, UNDERTAKER_SAPPHIRE_MAX_STACKS)
		target:SetModifierStackCount("modifier_undertaker_magic_armor_loss", caster, new_stacks)
		target:CalculateAndSaveRoshpitAttributes()
	end
end

function mountain_vambrace_attack(event)
	local item = event.caster
	local caster = event.attacker
	local target = event.target
	local ability = event.ability
	local chance = ITEM_RPC_MOUNTAIN_VAMBRACES_CHANCE + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_MOUNTAIN_VAMBRACES_GEM_EMERALD2)
	local proc = Filters:GetProc(caster, chance)
	if proc then
		Filters:MountainVambrace(caster, target, ability)
	end
end

function mountain_vambrace_take_damage(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	local attacker = event.attacker
	if IsValidEntity(attacker) and attacker:IsAlive() then
		if ability:GetGemValue("sapphire") > 0 then
			if not attacker:HasModifier("modifier_mountain_vambrace_immunity") then
				Filters:MountainVambrace(hero, attacker, ability)
				ability:ApplyDataDrivenModifier(caster, attacker, "modifier_mountain_vambrace_immunity", {duration = ability:GetGemValue("sapphire", ITEM_RPC_MORDIGGUS_GAUNTLET_GEM_SAPPHIRE)})
			end
		end
	end
end

function wolfir_druid_init(event)
	local ability = event.ability
	ability.initial = true
	
	if not ability.wolf_table then
		ability.wolf_table = {}
	end
	wolfir_reindex_wolf_table(event)
end

function wolfir_reindex_wolf_table(event)
	local ability = event.ability
	local hero = event.target
	if ability:GetAbilityName() == "wolfir_druid_passive" then
		ability = hero.equipped_gear[RPC_GEAR_SLOT_HEAD]
		hero = event.unit.hero
	end
	local new_wolf_table = {}
	for i = 1, #ability.wolf_table, 1 do
		if ability.wolf_table[i] and IsValidEntity(ability.wolf_table[i]) and ability.wolf_table[i]:IsAlive() then
			table.insert(new_wolf_table, ability.wolf_table[i])
		end
	end
	ability.wolf_table = new_wolf_table
	if ability:GetGemValue("emerald") > 0 then
		local stacks = ability:GetFinalGemPropertyValue("emerald", WOLFIR_DRUID_EMERALD2)*#ability.wolf_table
		if stacks > 0 then
			ability:ApplyDataDrivenModifier(hero.InventoryUnit, hero, "modifier_wolfir_druid_attack_speed", {})
			hero:SetModifierStackCount("modifier_wolfir_druid_attack_speed", hero.InventoryUnit, stacks)
		else
			hero:RemoveModifierByName("modifier_wolfir_druid_attack_speed")
		end
	end
end

function wolfir_druid_channel(event)
	local caster = event.target
	local ability = event.ability
	local inventoryUnit = event.caster
	wolfir_reindex_wolf_table(event)
	if #ability.wolf_table < 3 then
		local fv = caster:GetForwardVector() * Vector(1, 1, 0)
		local position = caster:GetAbsOrigin() - fv * 190 + RandomVector(RandomInt(50, 200))

		local wolf = CreateUnitByName("wolf_ally", position, false, nil, nil, caster:GetTeamNumber())
		wolf:SetAbsOrigin(wolf:GetAbsOrigin() + Vector(0, 0, 120))
		wolf.owner = caster:GetPlayerOwnerID()
		wolf.summoner = caster
		wolf:SetOwner(caster)
		wolf:SetControllableByPlayer(caster:GetPlayerID(), true)
		wolf.dieTime = WOLFIR_DRUID_WOLF_LIFE_DURATION
		wolf:AddAbility("ability_die_after_time_generic"):SetLevel(1)

		wolf:AddAbility("ability_ghost_effect"):SetLevel(1)
		wolf:SetForwardVector(fv)
		wolf:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
		Events:smoothSizeChange(wolf, 0.01, 0.6, 30)
		wolf.fv = fv
		wolf.hero = caster
		wolf:SetBaseMoveSpeed(400)
		ability:ApplyDataDrivenModifier(inventoryUnit, wolf, "modifier_wolf_enter", {duration = 1.1})
		if ability.initial then
			ability.initial = false
			EmitSoundOn("RPCItems.WolfSpiritSummon", wolf)
		end
		wolf:AdjustSummon(caster, true, WOLFIR_DRUID_HEALTH_PCT/100, WOLFIR_DRUID_ATTACK_POWER_MULT, 1, 1, 1, 1)

		local splitEarthParticle = "particles/frostivus_herofx/hyper_state_intro_omnislash_ascension.vpcf"
		local pfx = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, wolf)
		local wolfPosition = wolf:GetAbsOrigin()
		ParticleManager:SetParticleControlEnt(pfx, 0, wolf, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", wolfPosition, true)
		ParticleManager:SetParticleControlEnt(pfx, 1, wolf, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", wolfPosition, true)
		Timers:CreateTimer(1.5, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		wolf.interval = 0
		wolf:AddAbility("alpha_wolf_critical_strike"):SetLevel(1)
		local wolf_ability = wolf:FindAbilityByName("wolfir_druid_passive")
		table.insert(ability.wolf_table, wolf)
		if ability:GetGemValue("ruby") > 0 then
			wolf_ability:SetLevel(ability:GetGemValue("ruby"))
			wolf_ability:ApplyDataDrivenModifier(wolf, wolf, "modifier_wolfir_druid_aura", {})
		end
		if ability:GetGemValue("emerald") > 0 then
			local stacks = ability:GetFinalGemPropertyValue("emerald", WOLFIR_DRUID_EMERALD1)
			if stacks > 0 then
				ability:ApplyDataDrivenModifier(inventoryUnit, wolf, "modifier_wolfir_druid_attack_speed", {})
				wolf:SetModifierStackCount("modifier_wolfir_druid_attack_speed", inventoryUnit, stacks)
			else
				wolf:RemoveModifierByName("modifier_wolfir_druid_attack_speed")
			end
		end
		if ability:GetGemValue("sapphire") > 0 then
			local newDamage = wolf:GetAttackDamage() + caster:GetRoshpitSpellPierce()*ability:GetFinalGemPropertyValue("sapphire", WOLFIR_DRUID_SAPPHIRE)/100
			Filters:SetAttackDamage(wolf, newDamage)
		end
		if ability:GetGemValue("amethyst") > 0 then
			local hp = wolf:GetMaxHealth() + (caster:GetStrength() + caster:GetSpirit())*ability:GetFinalGemPropertyValue("amethyst", WOLFIR_DRUID_AMETHYST)
			wolf:SetMaxHPandHealToFull(hp)
		end
	end

end

function wolfir_wolf_think(event)
	local wolf = event.caster
	local caster = wolf.summoner
	local distance = WallPhysics:GetDistance(wolf:GetAbsOrigin() * Vector(1, 1, 0), caster:GetAbsOrigin() * Vector(1, 1, 0))
	if distance > 1000 then
		wolf:MoveToPositionAggressive(caster:GetAbsOrigin() + RandomVector(240))
	end
	-- CustomAbilities:CastNoTargetIfCastable(wolf, wolf:FindAbilityByName("ursa_overpower_no_head_attachment"), 500)

end

function wolf_enter_think(event)
	local wolf = event.target
	local startPos = wolf:GetAbsOrigin()
	if wolf.interval <= 13 then
		wolf:SetAbsOrigin(startPos + wolf.fv * 17 - Vector(0, 0, 11))
	else
		startPos = GetGroundPosition(startPos, wolf)
		wolf:SetAbsOrigin(startPos + wolf.fv * 17)
	end
	wolf.interval = wolf.interval + 1
end

function wolf_enter_think_two(event)
	local wolf = event.target
	local startPos = wolf:GetAbsOrigin()
	wolf:SetAbsOrigin(startPos + wolf.fv * 15)
end

function wolf_enter_end(event)
	local wolf = event.target
	wolf:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
	FindClearSpaceForUnit(wolf, wolf:GetAbsOrigin(), false)
	wolf:MoveToPositionAggressive(wolf:GetAbsOrigin() + wolf.fv * 600)
end

function devotion_think(event)
	local hero = event.target
	local caster = event.caster
	local ability = event.ability
	local radius = ITEM_RPC_CRUSADER_BOOTS_AURA_RANGE + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_CRUSADER_BOOTS_GEM_SAPPHIRE1)
	local allies = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
	if #allies > 0 then
		for _, ally in pairs(allies) do
			ability:ApplyDataDrivenModifier(caster, ally, "modifier_devotion_aura_buff", {})
			ability:ApplyDataDrivenModifier(caster, ally, "modifier_devotion_aura_hidden_countdown", {duration = 1})
		end
	end
	if ability:GetGemValue("ruby") > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_devotion_aura_base_attack_damage", {})
		local damage_stacks = math.floor(hero:GetStrength()*ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_CRUSADER_BOOTS_GEM_RUBY2 ))
		hero:SetModifierStackCount("modifier_devotion_aura_base_attack_damage", caster, damage_stacks)
	end
end

function gilded_soul_kill(event)
	local dyingUnit = event.unit
	local hero = event.attacker
	local ability = event.ability
	local caster = event.caster
	local particlePos = dyingUnit:GetAbsOrigin()
	ability.caster = caster


	local particleName = "particles/units/heroes/hero_elder_titan/gilded_soul_cage.vpcf"
	local position = dyingUnit:GetAbsOrigin()

	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, particlePos)
	Timers:CreateTimer(1.5, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:ReleaseParticleIndex(pfx)
	end)
	local allies = FindUnitsInRadius(hero:GetTeamNumber(), particlePos, nil, ITEM_RPC_GILDED_SOUL_CAGE_HEAL_RADIUS, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
	if #allies > 0 then
		for _, ally in pairs(allies) do
			local heal = math.floor(ally:GetMaxHealth() * ITEM_RPC_GILDED_SOUL_CAGE_HEAL_PCT/100)
			Filters:ApplyHeal(hero, ally, heal, true, true)
		end
	end
end

function gilded_soul_range_death(event)
	local dyingUnit = event.unit
	local hero = event.caster.hero
	local caster = event.caster
	local ability = event.ability

	local sourceLoc = event.unit:GetAbsOrigin()
	local info =
	{
		Target = hero,
		Source = dyingUnit,
		Ability = ability,
		EffectName = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_base_attack.vpcf",
		vSourceLoc = sourceLoc,
		bDrawsOnMinimap = false,
		bDodgeable = false,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 6,
		bProvidesVision = false,
		iVisionRadius = 0,
		iMoveSpeed = 800,
	iVisionTeamNumber = hero:GetTeamNumber()}
	projectile = ProjectileManager:CreateTrackingProjectile(info)


end

function gilded_soul_projectile_hit(event)
	local target = event.target
	local ability = event.ability
	local caster = ability.caster
	ability:ApplyDataDrivenModifier(caster, target, "modifier_gilded_soul_buff", {duration = ITEM_RPC_GILDED_SOUL_CAGE_SOUL_DURATION})
	local newStacks = math.min(target:GetModifierStackCount("modifier_gilded_soul_buff", ability) + 1, ITEM_RPC_GILDED_SOUL_CAGE_MAX_SOULS)
	target:SetModifierStackCount("modifier_gilded_soul_buff", ability, newStacks)
	ability.soulStacks = newStacks
	

	if ability:GetGemValue("ruby") > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_gilded_soul_cage_atk_damage", {})
		target:SetModifierStackCount("modifier_gilded_soul_cage_atk_damage", caster, ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_GILDED_SOUL_CAGE_GEM_RUBY)*ability.soulStacks)
	end
	if ability:GetGemValue("sapphire") > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_gilded_soul_sapphire_bad", {})
		target:SetModifierStackCount("modifier_gilded_soul_sapphire_bad", caster, ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_GILDED_SOUL_CAGE_GEM_SAPPHIRE)*ability.soulStacks)	
	end
	if ability:GetGemValue("amethyst") > 0 then
		local magic_immune_duration = ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_GILDED_SOUL_CAGE_GEM_AMETHYST)
		if not target:HasModifier("modifier_gilded_soul_immunity") then
			EmitSoundOn("RPCItems.GildedSoul.MagicImmunity", target)
		end
		ability:ApplyDataDrivenModifier(caster, target, "modifier_gilded_soul_immunity", {duration = magic_immune_duration})

	end
end

function gilded_soul_buff_duration_end(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	ability.soulStacks = ability.soulStacks - 1
	if target:IsAlive() then
		if ability.soulStacks > 0 then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_gilded_soul_buff", {duration = ITEM_RPC_GILDED_SOUL_CAGE_SOUL_DURATION})
			target:SetModifierStackCount("modifier_gilded_soul_buff", ability, ability.soulStacks)
			if ability:GetGemValue("ruby") > 0 then
				ability:ApplyDataDrivenModifier(caster, target, "modifier_gilded_soul_cage_atk_damage", {})
				target:SetModifierStackCount("modifier_gilded_soul_cage_atk_damage", caster, ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_GILDED_SOUL_CAGE_GEM_RUBY)*ability.soulStacks)
			end
			if ability:GetGemValue("sapphire") > 0 then
				ability:ApplyDataDrivenModifier(caster, target, "modifier_gilded_soul_sapphire_bad", {})
				target:SetModifierStackCount("modifier_gilded_soul_sapphire_bad", caster, ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_GILDED_SOUL_CAGE_GEM_SAPPHIRE)*ability.soulStacks)	
			end
		end
	end
end

function gilded_soul_thinker(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	if ability:GetGemValue("emerald") > 0 then
		if not ability.interval then
			ability.interval = 0
		end
		ability.interval = ability.interval + 1
		if ability.interval % ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_GILDED_SOUL_CAGE_GEM_EMERALD1) == 0 then
			local enemies = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, ITEM_RPC_GILDED_SOUL_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				for _, enemy in pairs(enemies) do
					if enemy:GetEnemyTier() == ENEMY_TYPE_ELITE_CREEP then
						local eventTable = {}
						eventTable.caster = caster
						eventTable.ability = ability
						eventTable.unit = enemy
						gilded_soul_range_death(eventTable)
					end
				end
			end
		end
		if ability.interval % ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_GILDED_SOUL_CAGE_GEM_EMERALD2) == 0 then
			local enemies = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, ITEM_RPC_GILDED_SOUL_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				for _, enemy in pairs(enemies) do
					if enemy:GetEnemyTier() > ENEMY_TYPE_ELITE_CREEP then
						local eventTable = {}
						eventTable.caster = caster
						eventTable.ability = ability
						eventTable.unit = enemy
						gilded_soul_range_death(eventTable)
					end
				end
			end
		end
	end
end

function arcanys_slipper_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local particleName = "particles/econ/courier/courier_dolfrat_and_roshinante/arcanys_poof.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	Timers:CreateTimer(ITEM_RPC_ARCANYS_SLIPPER_EXPLOSIONS_DURATION, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	local manaDrain = target:GetMaxMana() * ITEM_RPC_ARCANYS_SLIPPER_MANA_DRAIN_PER_EXPLOSION_PCT/100
	if target:GetMana() <= manaDrain then
		manaDrain = target:GetMana()
	end
	local damageIncrease = manaDrain * ITEM_RPC_ARCANYS_SLIPPER_BASE_ATTACK_FOR_MANA_DRAIN/100
	target:ReduceMana(manaDrain)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_arcanys_slipper_buff", {duration = ITEM_RPC_ARCANYS_SLIPPER_BUFF_DURATION})
	local currentStacks = target:GetModifierStackCount("modifier_arcanys_slipper_buff", caster)
	target:SetModifierStackCount("modifier_arcanys_slipper_buff", caster, damageIncrease + currentStacks)
	EmitSoundOn("Item.ArcanysSlipper", target)

	if ability:GetGemValue("ruby") > 0 then
		CustomAbilities:QuickParticleAtPoint("particles/roshpit/arcanys_ruby.vpcf", target:GetAbsOrigin()+Vector(0,0,60), 1)
		local damage = OverflowProtectedGetAverageTrueAttackDamage(target) * ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_ARCANYS_SLIPPER_GEM_RUBY)/100
		local enemies = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, ITEM_RPC_ARCANYS_SLIPPER_RUBY_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				Filters:ApplyItemDamage(enemy, target, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_ARCANE, RPC_ELEMENT_NONE)
			end
		end
	end
end

function onu_attack_land(event)
	local target = event.target
	local attacker = event.attacker
	local ability = event.ability
	local caster = event.caster
	if target.dummy then
		return false
	end
	local proc_chance = GLINT_OF_ONU_CHANCE + ability:GetFinalGemPropertyValue("sapphire", GLINT_OF_ONU_SAPPHIRE)
	local proc = Filters:GetProc(attacker, proc_chance)
	if target:HasModifier("modifier_glint_no_proc") then
		local newNoProcStacks = target:GetModifierStackCount("modifier_glint_no_proc", caster) - 1
		if newNoProcStacks > 0 then
			target:SetModifierStackCount("modifier_glint_no_proc", caster, newNoProcStacks)
		else
			target:RemoveModifierByName("modifier_glint_no_proc")
		end

		return false
	end
	if proc then
		if attacker:IsAlive() then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_glint_no_proc", {duration = 1})
			target:SetModifierStackCount("modifier_glint_no_proc", caster, 2)
			local newPosition = target:GetAbsOrigin() + target:GetForwardVector() *- 120
			local position = attacker:GetAbsOrigin()
			local newPosition = WallPhysics:WallSearch(position, newPosition, target)
			FindClearSpaceForUnit(attacker, newPosition, false)
			attacker:SetForwardVector(target:GetForwardVector() * Vector(1, 1, 0))
			event.ability:ApplyDataDrivenModifier(event.caster, attacker, "modifier_blinded_glint_buff", {duration = GLINT_OF_ONU_BUFF_DUR})
			ProjectileManager:ProjectileDodge(attacker)
			if ability:GetGemValue("amethyst") > 0 then
				event.ability:ApplyDataDrivenModifier(event.caster, attacker, "modifier_blinded_glint_amethyst_attack_power", {duration = GLINT_OF_ONU_BUFF_DUR})
				attacker:SetModifierStackCount("modifier_blinded_glint_amethyst_attack_power", caster, ability:GetFinalGemPropertyValue("amethyst", GLINT_OF_ONU_AMETHYST))
			end

			local particleName = "particles/econ/items/meepo/meepo_diggers_divining_rod/meepo_divining_rod_poof_end_rays_burst.vpcf"
			local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, attacker)
			ParticleManager:SetParticleControlEnt(pfx, 0, attacker, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", position, true)
			local pfx2 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, attacker)
			ParticleManager:SetParticleControlEnt(pfx2, 0, attacker, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", newPosition, true)
			Timers:CreateTimer(1, function()
				ParticleManager:DestroyParticle(pfx, false)
				ParticleManager:DestroyParticle(pfx2, false)
			end)
			local ruby_attack_procs = Runes:ProcsByTotalChance(ability:GetFinalGemPropertyValue("ruby", GLINT_OF_ONU_RUBY))
			if ruby_attack_procs > 0 then
				for i = 1, ruby_attack_procs, 1 do
					Timers:CreateTimer((i-1)*0.1, function()
						if target:IsAlive() then
							Filters:PerformAttackSpecial(attacker, target, true, true, true, false, true, false, false)
						end
					end)
				end
			end
			EmitSoundOnLocationWithCaster(newPosition, "RPCItem.GlintOfOnu", attacker)
		end
	end

end

function roknar_think(event)
	local target = event.target
	local ability = event.ability
	if target:HasModifier("modifier_stunned") or target:HasModifier("modifier_knockback") or target:IsStunned() then
		local particleName = "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		Timers:CreateTimer(0.2, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		local heal = target:GetMaxHealth() * (ROKNAR_EMPEROR_HP_PCT/100 + ability:GetFinalGemPropertyValue("emerald", ROKNAR_EMERALD)/100)
		Filters:ApplyHeal(target, target, heal, true, true)
	end
end

function bluestar_thinker(event)
	local hero = event.target
	local ability = event.ability
	local caster = event.caster
	if not ability.last_mana then
		ability.last_mana = hero:GetMana()
	end
	local mana_diff = ability.last_mana - hero:GetMana()
	if mana_diff > 0 then
		local healAmount = mana_diff * (ITEM_RPC_BLUESTAR_ARMOR_HEAL_PCT_OF_MANA_LOST + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_BLUESTAR_ARMOR_GEM_EMERALD ))/100
		Filters:ApplyHeal(hero, hero, healAmount, true, true)
	end
	ability.last_mana = hero:GetMana()
end

function bluestar_slide(event)
	local target = event.target
	local position = target:GetAbsOrigin()
	position = GetGroundPosition(position, target)

	local newPosition = position + target:GetForwardVector() * target.bluestarSlideVelocity
	local afterWallPosition = WallPhysics:WallSearch(target:GetAbsOrigin(), newPosition, target)

	if afterWallPosition == newPosition then
		target:SetOrigin(newPosition)
	end
	target.bluestarSlideVelocity = target.bluestarSlideVelocity - 1.25
	if target.bluestarSlideVelocity <= 1 then
		target:RemoveModifierByName("modifier_bluestar_slide")
	end
end

function findClearSpace(event)
	local target = event.target
	FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
end

function lifesteal_land_hand(event)
	local attacker = event.attacker
	local ability = attacker.InventoryUnit:FindAbilityByName("hand_slot")
	local damage = event.attack_damage
	local current_stack = attacker:GetModifierStackCount("modifier_hand_lifesteal", ability)
	local lifesteal = math.floor(damage * current_stack / 100)

	Filters:ApplyHeal(attacker, attacker, lifesteal, true)
	local particleName = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, attacker)
	ParticleManager:SetParticleControlEnt(pfx, 0, attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin() + Vector(0, 0, 70), true)
	Timers:CreateTimer(1, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
end

function eternal_essence_kill(event)
	local dyingUnit = event.unit
	local hero = event.attacker
	local ability = event.ability
	local caster = event.caster
	if ability:GetGemValue("ruby") > 0 then
		local heal = dyingUnit:GetMaxHealth() * (ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_ETERNAL_ESSENCE_GAUNTLET_GEM_RUBY)/100)
		local particleName = "particles/units/heroes/hero_oracle/eternal_gauntlet_heal.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_POINT_FOLLOW, hero)
		ParticleManager:SetParticleControlEnt(pfx, 0, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)

		Timers:CreateTimer(1.0, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)

		Filters:ApplyHeal(hero, hero, heal, true, true)
	end

end

function eternal_essence_end(event)
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
	ability.last_heal = 0
end

function hermit_spike_damage_taken(event)
	local ability = event.ability
	local caster = event.caster
	local attack_damage = event.damage
	local target = event.unit
	if not ability.spineDamage then
		ability.spineDamage = 0
	end
	local spineThreshold = target:GetMaxHealth() * ITEM_RPC_HERMITS_SPIKE_SHELL_THRESHOLD/100
	ability.spineDamage = ability.spineDamage + attack_damage
	if ability.spineDamage > spineThreshold then
		EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "RPCItems.HermitSpikeShell", target)
		local spineShots = math.min(math.floor(ability.spineDamage / spineThreshold), ITEM_RPC_HERMITS_SPIKE_SHELL_MAX_TRIGGERS_PER_DMG)
		for i = 1, spineShots, 1 do
			Timers:CreateTimer((i - 1) * 0.2, function()
				local spikeParticle = "particles/units/heroes/hero_bristleback/bristleback_quill_spray_quills.vpcf"
				local position = target:GetAbsOrigin()
				local pfx = ParticleManager:CreateParticle(spikeParticle, PATTACH_OVERHEAD_FOLLOW, target)
				ParticleManager:SetParticleControl(pfx, 0, position + Vector(0, 0, -100))
				Timers:CreateTimer(2, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)
				local radius = ITEM_RPC_HERMITS_SPIKE_SHELL_RADIUS
				local damage = OverflowProtectedGetAverageTrueAttackDamage(target)*(ITEM_RPC_HERMITS_SPIKE_SHELL_DAMAGE_PCT_ATTACK_POWER/100) + (ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_HERMITS_SPIKE_SHELL_GEM_RUBY)*target:GetMaxHealth()/100)
				local enemies = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
				if #enemies > 0 then
					for _, enemy in pairs(enemies) do
						Filters:ApplyItemDamage(enemy, target, damage, DAMAGE_TYPE_PHYSICAL, event.ability, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
						if ability:GetGemValue("amethyst") > 0 then
							ability:ApplyDataDrivenModifier(caster, enemy, "modifier_hermit_spike_shell_quills", {duration = ITEM_RPC_HERMITS_SPIKE_SHELL_AMETHYST_DURATION})
							local current_stacks = enemy:GetModifierStackCount("modifier_hermit_spike_shell_quills", caster)
							local new_stacks = math.min(current_stacks + 1, ITEM_RPC_HERMITS_SPIKE_SHELL_AMETHYST_MAX_STACKS)
							enemy:SetModifierStackCount("modifier_hermit_spike_shell_quills", caster, new_stacks)
							enemy:CalculateAndSaveRoshpitAttributes()
						end
					end
				end

			end)
			if ability:GetGemValue("emerald") > 0 then
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", target, 1)
				local heal = target:GetMaxHealth()*(ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_HERMITS_SPIKE_SHELL_GEM_EMERALD)/100)
				Filters:ApplyHeal(target, target, heal, true, true)
			end
		end
		ability.spineDamage = 0
	end
end

function redrock_end(event)
	local target = event.target
	target:Stop()
end

function pathfinder_think(event)
	local target = event.target
	local animation = false
	if not target:HasModifier("modifier_pathfinder_resonant_cooldown") then
		if target:GetHealth() < target:GetMaxHealth() then
			local heal = math.ceil(target:GetMaxHealth() * ITEM_RPC_PATHFINDERS_RESONANT_BOOTS_HP_RESTORE_PCT/100)
			Filters:ApplyHeal(target, target, heal, true)
			animation = true
		end
		if target:GetMana() < target:GetMaxMana() then
			local manaRestore = math.ceil(target:GetMaxMana() * ITEM_RPC_PATHFINDERS_RESONANT_BOOTS_MANA_RESTORE_PCT/100)
			target:GiveMana(manaRestore)
			Timers:CreateTimer(0.1, function()
				PopupMana(target, manaRestore)
			end)
			animation = true
		end
		if animation then
			local particleName = "particles/frostivus_gameplay/wraith_king_heal.vpcf"
			local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx, 3, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			Timers:CreateTimer(1.5, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
		end
	end
end

function pathfinder_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	local hero = caster.hero
	local cd = ITEM_RPC_PATHFINDERS_RESONANT_BOOTS_DELAY - ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_PATHFINDERS_RESONANT_BOOTS_GEM_RUBY)
	ability:ApplyDataDrivenModifier(caster, hero, "modifier_pathfinder_resonant_cooldown", {duration = cd})
	hero:RemoveModifierByName("modifier_resonant_boots_active")
end

function resonant_pathfinder_on(event)
	local caster = event.caster
	local ability = event.ability
	local hero = caster.hero
	if ability:GetGemValue("amethyst") > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_resonant_boots_atk_power", {})
		hero:SetModifierStackCount("modifier_resonant_boots_atk_power", caster, ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_PATHFINDERS_RESONANT_BOOTS_GEM_AMETHYST))
	end
end

function neptune_think(event)
	local target = event.target
	local ability = event.ability
	if not ability.lastPos then
		ability.lastPos = target:GetAbsOrigin()
	end
	if Filters:HasMovementModifier(target) then
		return false
	end
	local onGround = math.abs(caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster)) < 10
	if onGround then
	else
		return false
	end
	if not ability.distanceMoved then
		ability.distanceMoved = 0
		ability.slideVelocity = 0
		ability.forward = target:GetForwardVector()
	end
	ability.newPos = target:GetAbsOrigin()
	ability.hero = target
	local distance = WallPhysics:GetDistance(ability.newPos * Vector(1, 1, 0), ability.lastPos * Vector(1, 1, 0))
	ability.distanceMoved = ability.distanceMoved + distance - ability.slideVelocity
	if ability.slideVelocity < 2 then
		-- ability.forward = Vector(0,0)
		target:RemoveModifierByName("modifier_neptune_gliding")
	end
	if ability.distanceMoved > 100 then
		ability.active = true
		ability:ApplyDataDrivenModifier(event.caster, target, "modifier_neptune_gliding", {duration = 5})
		if ability.distanceMoved < 2000 then
			for i = 1, ability.distanceMoved / 100, 1 do
				ability.foward = (ability.forward * (ability.slideVelocity / 1.5) + target:GetForwardVector()):Normalized()
				ability.slideVelocity = math.min(ability.slideVelocity + 2.5, 16)
			end
		end
		ability.distanceMoved = ability.distanceMoved % 100
		ability.forward = (target:GetAbsOrigin() - ability.lastPos):Normalized()
	else
		if distance < 20 then
			ability.active = false
			target:RemoveModifierByName("modifier_neptune_gliding")
			ability.slideVelocity = 0
			-- ability.forward = Vector(0,0)
		end
	end
	if ability.active then
		local particleName = "particles/econ/items/pets/pet_frondillo/pet_swim_puddle_frondillo.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_WORLDORIGIN, "attach_hitloc", target:GetAbsOrigin(), true)
		Timers:CreateTimer(2.0, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	end
	if ability.forward == Vector(0, 0) then
		ability.forward = target:GetForwardVector()
	else
		-- ability.forward = (ability.forward*ability.slideVelocity + target:GetForwardVector()):Normalized()
	end
	-- local dot = dot
	-- if angle > math.pi/2 then
	-- -- ability.slideVelocity = 0
	-- target:Stop()
	-- end
	ability.lastPos = target:GetAbsOrigin()
	if ability:GetGemValue("ruby") > 0 then
		local speed_stacks = ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_NEPTUNES_WATER_GLIDERS_GEM_RUBY)*target:GetIntellect()
		ability:ApplyDataDrivenModifier(event.caster, target, "modifier_neptune_ruby_speed", {})
		target:SetModifierStackCount("modifier_neptune_ruby_speed", event.caster, speed_stacks)
	end
end

function neptune_gliding(event)
	local target = event.target
	local ability = event.ability
	local position = target:GetAbsOrigin()
	if target:IsStunned() or target:IsRooted() or target:IsFrozen() then
		return false
	end
	local obstruction = WallPhysics:FindNearestObstruction(position * Vector(1, 1, 0))

	local newPosition = target:GetAbsOrigin() + ability.forward * ability.slideVelocity
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition * Vector(1, 1, 0), target)
	newPosition = GetGroundPosition(newPosition, target)
	if not blockUnit and (math.abs(position.z - newPosition.z) < 3) then
		-- newPosition = GetGroundPosition(newPosition, target)
		target:SetAbsOrigin(newPosition)
	end
	ability.slideVelocity = math.max(ability.slideVelocity - 1.2, 0)
end

function neptune_gliding_think_new(event)
	local target = event.target
	local ability = event.ability
	local position = target:GetAbsOrigin()
	if target:HasModifier("modifier_jumping") then
		return false
	end
	if not ability.interval then
		ability.interval = 0
	end
	ability.interval = ability.interval + 1
	if ability.interval == 8 then
		--print("SHOW PARTICLE!")
		local particleName = "particles/roshpit/hydroxis/slipstream_puddle.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
		ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin())
		Timers:CreateTimer(3, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		ability.interval = 0
	end

	local obstruction = WallPhysics:FindNearestObstruction(position * Vector(1, 1, 0))

	local moveForward = target:GetForwardVector()
	if WallPhysics:GetDistance2d(ability.movementPosition, target:GetAbsOrigin()) < 150 then
		moveForward = ability.movementForward

	end
	local newPosition = target:GetAbsOrigin() + moveForward * ability.slideSpeed
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition * Vector(1, 1, 0), target)
	-- newPosition = GetGroundPosition(newPosition, target)

	-- newPosition = GetGroundPosition(newPosition, target)
	if math.abs(target:GetAbsOrigin().z - GetGroundHeight(newPosition, target)) < 0.01 then
		if math.abs(target:GetAbsOrigin().z - GetGroundHeight(target:GetAbsOrigin(), target)) < 0.01 then
			if not blockUnit then
				target:SetAbsOrigin(GetGroundPosition(newPosition, target))
			end
		else
			target:RemoveModifierByName("modifier_neptune_gliding_new")
		end
	else
		target:RemoveModifierByName("modifier_neptune_gliding_new")
	end

	ability.slideSpeed = math.max(ability.slideSpeed - 0.1, 0)
	if ability.slideSpeed < 1 then
		target:RemoveModifierByName("modifier_neptune_gliding_new")
	end
	if ability.lastPos then
		local distance2d = WallPhysics:GetDistance2d(ability.lastPos, target:GetAbsOrigin())
		if distance2d < (ability.slideSpeed - 0.5) then

			if not ability.blockCheck then
				ability.blockCheck = 0
			end
			ability.blockCheck = ability.blockCheck + 1
			--print(ability.blockCheck)
			if ability.blockCheck >= 3 then
				target:RemoveModifierByName("modifier_neptune_gliding_new")
				ability.blockCheck = 0
			end
		else
			ability.blockCheck = 0
		end
	end
	ability.lastPos = target:GetAbsOrigin()
	ability.lastForward = target:GetForwardVector()
	local distance2d = WallPhysics:GetDistance2d(ability.movementPosition, target:GetAbsOrigin())
	if distance2d < 70 then
		if not target:IsChanneling() then
			if target.lastOrder then
				if target.lastOrder == DOTA_UNIT_ORDER_MOVE_TO_POSITION then
					target:Stop()
				end
			end
		end
	end
end

function neptunes_base_thinker(event)
	local hero = event.caster.hero
	local caster = event.caster
	local ability = event.ability
	if ability:GetGemValue("ruby") > 0 then
		local speed_stacks = ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_NEPTUNES_WATER_GLIDERS_GEM_RUBY)*hero:GetIntellect()
		ability:ApplyDataDrivenModifier(event.caster, hero, "modifier_neptune_ruby_speed", {})
		hero:SetModifierStackCount("modifier_neptune_ruby_speed", event.caster, speed_stacks)
	end
end

function gliding_end(event)
	local target = event.target
	local ability = event.ability
	ability.lastPos = false
	ability.blockCheck = 0
	FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)

	ability.slideSpeed = 0
end

function ruinfall_skull_think(event)
	local target = event.target
	if not target:HasModifier("modifier_ruinfall_skull_token_cooldown") and target:GetHealth() < target:GetMaxHealth() * 0.25 and target:IsAlive() then
		event.ability:ApplyDataDrivenModifier(event.caster, target, "modifier_skull_sand_storm", {duration = 5})
		event.ability:ApplyDataDrivenModifier(event.caster, target, "modifier_ruinfall_skull_token_cooldown", {duration = 40})
		StartSoundEvent("Ability.SandKing_SandStorm.loop", target)
	end
end

function ruinfall_skull_heal_think(event)
	local target = event.target
	local healAmount = math.floor(target:GetMaxHealth() * 0.2)
	Filters:ApplyHeal(target, target, healAmount, true)
end

function ruinfall_skull_sandstorm_end(event)
	local target = event.target

	StopSoundEvent("Ability.SandKing_SandStorm.loop", target)
	target:RemoveModifierByName("modifier_invisible")
end

function spirit_glove_wearer_think(event)
	local caster = event.caster
	local ability = event.ability
	local hero = caster.hero
	if ability:GetGemValue("amethyst") > 0 then
		local attack_damage = hero:GetSpirit()*ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_SPIRIT_GLOVE_GEM_AMETHYST2)
		hero:ApplyModifierAndSetStacks(ability, caster, "modifier_spirit_glove_amethyst_attack_damage", attack_damage, 0)
	end
end

function spirit_glove_think(event)
	local spiritGlove = event.ability
	local caster = event.caster
	local ally = event.target
	Filters:SpiritGloveHeal(caster.hero, ally, spiritGlove)
end

function ruby_attack(event)
	
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	local damage = OverflowProtectedGetAverageTrueAttackDamage(attacker)*ITEM_RPC_OMEGA_RUBY_ATTACK_TO_DMG/100 + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_OMEGA_RUBY_GEM_RUBY2)

	EmitSoundOn("RPCItems.OmegaRuby.AttackLand", target)
	local radius = ITEM_RPC_OMEGA_RUBY_AOE_RADIUS + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_OMEGA_RUBY_GEM_RUBY1)
	local particleName = "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControl(particle1, 0, target:GetAbsOrigin())
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)

	local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:ApplyItemDamage(enemy, attacker, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
		end
	end

end

function blue_dragon_greaves_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if not ability.lastPos then
		ability.lastPos = target:GetAbsOrigin()
	end
	if not ability.distanceMoved then
		ability.distanceMoved = 0
	end
	ability.newPos = target:GetAbsOrigin()
	ability.hero = target
	local distance = WallPhysics:GetDistance(ability.newPos, ability.lastPos)
	ability.distanceMoved = ability.distanceMoved + distance
	if ability.distanceMoved > ITEM_RPC_BLUE_DRAGON_GREAVES_DISTANCE then
		Filters:ApplyBlueDragonGreavesBuff(target, ITEM_RPC_BLUE_DRAGON_GREAVES_DURATION)
		ability.distanceMoved = ability.distanceMoved % ITEM_RPC_BLUE_DRAGON_GREAVES_DISTANCE
	end

	ability.lastPos = target:GetAbsOrigin()
end

function ocean_tempest_initialize(event)
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
	hero:RemoveModifierByName("modifier_ocean_templest_tidal_storm_stacks")
	StartSoundEvent("RPCItems.OceanTempest.Event", hero)
	-- ability.manaDrained = 0
	-- ability.interval = 0
end

function ocean_tempest_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster

    local total_ticks = ability.channel_time/0.1
	if ability.interval >= total_ticks then
		target:RemoveModifierByName("modifier_ocean_tempest_pallium_channeling")
		return
	end
	local manaDrain = math.min(target:GetMaxMana() * (ability.total_mana_drain_pct/total_ticks)/100, target:GetMana())
	manaDrain = math.floor(manaDrain)
	target:ReduceMana(manaDrain)
	PopupLoseMana(target, manaDrain)
	ability.total_mana_drained = ability.total_mana_drained + manaDrain

	local new_stacks = math.ceil(ability.total_mana_drained/ITEM_RPC_OCEAN_TEMPEST_PALLIUM_DIVISOR)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_ocean_templest_tidal_storm_stacks", {duration = ITEM_RPC_OCEAN_TEMPEST_PALLIUM_TIDAL_STORM_STACK_DURATION})
	target:SetModifierStackCount("modifier_ocean_templest_tidal_storm_stacks", caster, new_stacks)

	if ability:GetGemValue("ruby") > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_ocean_tempest_ruby_attack_power", {duration = ITEM_RPC_OCEAN_TEMPEST_PALLIUM_TIDAL_STORM_STACK_DURATION})
		local attack_power_stacks = new_stacks*ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_OCEAN_TEMPEST_PALLIUM_GEM_RUBY)/0.01
		target:SetModifierStackCount("modifier_ocean_tempest_ruby_attack_power", caster, attack_power_stacks)
	end
	if ability:GetGemValue("emerald") > 0 then
		local remaining_duration = (total_ticks - ability.interval) * 0.1
		local enemies = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, ITEM_RPC_OCEAN_TEMPEST_PALLIUM_EMERALD_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				if not enemy:HasModifier("modifier_ocean_tempest_typhoon") then
					if not enemy.jumpLock then
						local proc = Filters:GetProc(target, ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_OCEAN_TEMPEST_PALLIUM_GEM_EMERALD1))
						if proc then
							ability:ApplyDataDrivenModifier(caster, enemy, "modifier_ocean_tempest_typhoon", {duration = remaining_duration})
							if enemy.ocean_tempest_pfx then
								ParticleManager:DestroyParticle(enemy.ocean_tempest_pfx, false)
							end
							enemy.ocean_tempest_pfx = ParticleManager:CreateParticle("particles/econ/events/ti7/cyclone_ti7.vpcf", PATTACH_ABSORIGIN, enemy)
							ParticleManager:SetParticleControl(enemy.ocean_tempest_pfx, 0, enemy:GetAbsOrigin())
						end
					end
				end
			end
		end
	end
	ability.interval = ability.interval + 1
	if ability.interval % 3 == 0 then
		local position = target:GetAbsOrigin() + RandomVector(RandomInt(0, 160))
		local particleName = "particles/units/heroes/hero_slardar/slardar_crush.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
		ParticleManager:SetParticleControl(pfx, 0, position)
		ParticleManager:SetParticleControl(pfx, 1, Vector(300, 1, 1))
		Timers:CreateTimer(0.5, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		EmitSoundOn("RPCItems.OceanTempest.Splash", target)
	end
end

function ocean_tempest_typhoon_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster

	local newFV = WallPhysics:rotateVector(target:GetForwardVector(), 2*math.pi/20)
	target:SetForwardVector(newFV)
	if not target.ocean_tempest_lift_speed then
		target.ocean_tempest_lift_speed = 3
	end
	local distanceFromGround = target:GetAbsOrigin().z - GetGroundHeight(target:GetAbsOrigin(), target)
	if not target.jumpLock then
		if distanceFromGround < 240 then
			target.ocean_tempest_lift_speed = target.ocean_tempest_lift_speed + 0.4
			target:SetAbsOrigin(target:GetAbsOrigin() + Vector(0,0,target.ocean_tempest_lift_speed))
		else
			target.ocean_tempest_lift_speed = target.ocean_tempest_lift_speed - 0.4
			target:SetAbsOrigin(target:GetAbsOrigin() + Vector(0,0,target.ocean_tempest_lift_speed))		
		end
	end
end

function ocean_tempest_typhoon_end(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
	target.ocean_tempest_lift_speed = nil
	ability:ApplyDataDrivenModifier(caster, target, "modifier_ocean_tempest_falling", {duration = 3})
	ParticleManager:DestroyParticle(target.ocean_tempest_pfx, false)
	target.ocean_tempest_pfx = nil
end

function ocean_tempest_falling_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster

	local newFV = WallPhysics:rotateVector(target:GetForwardVector(), 2*math.pi/20)
	target:SetForwardVector(newFV)
	local distanceFromGround = target:GetAbsOrigin().z - GetGroundHeight(target:GetAbsOrigin(), target)
	if distanceFromGround > 10 then
		target:SetAbsOrigin(target:GetAbsOrigin() - Vector(0,0,30))
	else
		target:RemoveModifierByName("modifier_ocean_tempest_falling")
	end
end

function ocean_tempest_falling_end(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
	FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
	local damage = hero:GetModifierStackCount("modifier_ocean_templest_tidal_storm_stacks", caster)*(ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_OCEAN_TEMPEST_PALLIUM_GEM_EMERALD2))
	Filters:ApplyItemDamage(target, hero, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_WATER, RPC_ELEMENT_WIND)
end

function ocean_tempest_channel_end(event)
	local hero = event.caster.hero
	StopSoundEvent("RPCItems.OceanTempest.Event", hero)
end

function raven_idol_think(event)
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
	local threshold_pct = ITEM_RPC_RAVEN_IDOL_HP_THRESHOLD_PCT - ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_RAVEN_IDOL_GEM_RUBY1)
	if hero:GetHealth() > hero:GetMaxHealth() * threshold_pct / 100 then
		hero:SetHealth(hero:GetMaxHealth() * threshold_pct / 100)
	end
end

function raven_idol_health_gained(event)
	-- local hero = event.unit
	-- local ability = event.ability
	-- if hero:GetHealth() > hero:GetMaxHealth() * threshold_pct / 100 then
	-- 	hero:SetHealth(hero:GetMaxHealth() * threshold_pct / 100)
	-- end
end

function twilight_damage_taken(event)
	local target = event.unit
	local damageTaken = event.damage_taken

end

function blackfeather_init(event)
	local hero = event.target
	local ability = event.ability
	if not ability.crow then
		local summonPos = hero:GetAbsOrigin()
		local crow = CreateUnitByName("twilight_crow_summon", summonPos, true, nil, nil, hero:GetTeamNumber())
		crow.owner = hero:GetPlayerOwnerID()
		crow:SetOwner(hero)
		crow:FindAbilityByName("twilight_crow_summon_ai"):SetLevel(1)
		ability.crow = crow
		crow.hero = hero
		crow:SetModelScale(0.01)
		crow:FindAbilityByName("twilight_crow_summon_ai"):ApplyDataDrivenModifier(crow, crow, "modifier_cant_attack", {})

	end
end

function blackfeather_attack_land(event)
	local hero = event.attacker
	local ability = event.ability
	local target = event.target
	if target.dummy then
		return false
	end
	if ability.crow then
		ability.crow:SetAbsOrigin(hero:GetAbsOrigin()+Vector(0,0,200))
		ability.crow:SetForwardVector(hero:GetForwardVector())
		if not ability.crow:HasModifier("modifier_crow_attacking") then
			Events:smoothSizeChange(ability.crow, 0.01, 1, 10)
		end
		ability.crow:RemoveNoDraw()
		StartAnimation(ability.crow, {duration = 0.3, activity = ACT_DOTA_SPAWN, rate = 1.5})
		if not ability.crow:HasModifier("modifier_crow_attacking") then
			CustomAbilities:QuickParticleAtPoint("particles/roshpit/solunia/warp_core_lunar_flash_c.vpcf", ability.crow:GetAbsOrigin()+Vector(0,0,120), 3)
		end
		local crow_ability = ability.crow:FindAbilityByName("twilight_crow_summon_ai")
		crow_ability:ApplyDataDrivenModifier(ability.crow, ability.crow, "modifier_crow_attacking", {duration = 0.4})
		Timers:CreateTimer(0.1, function()
			Filters:PerformAttackSpecial(ability.crow, target, true, true, true, false, true, false, false)
			EmitSoundOn("RPCItems.Blackfeather.Stormcrow", ability.crow)
		end)
		if ability:GetGemValue("amethyst") > 0 then
			ability:ApplyDataDrivenModifier(event.caster, hero, "modifier_blackfeather_amethyst_attack_power", {duration = 0.75})
			hero:SetModifierStackCount("modifier_blackfeather_amethyst_attack_power", event.caster, ability:GetFinalGemPropertyValue("amethyst", BLACKFEATHER_AMETHYST2))
		end
		Timers:CreateTimer(0.45, function()
			if not ability.crow:HasModifier("modifier_crow_attacking") then
				Events:smoothSizeChange(ability.crow, 1, 0.01, 10)
				Timers:CreateTimer(0.15, function()
					if not ability.crow:HasModifier("modifier_crow_attacking") then
						if ability.crow:GetModelScale() < 0.8 then
							CustomAbilities:QuickParticleAtPoint("particles/roshpit/items/blackfeather_spawn.vpcf", ability.crow:GetAbsOrigin()+Vector(0,0,140), 3)
						end
					end
				end)
				Timers:CreateTimer(0.3, function()
					if not ability.crow:HasModifier("modifier_crow_attacking") then
						if ability.crow:GetModelScale() < 0.2 then
							hero:RemoveModifierByName("modifier_blackfeather_amethyst_attack_power")
							ability.crow:AddNoDraw()
						end
					end
				end)
			end
		end)
	end
end

function blackfeather_ruby(hero, crow, target, damage, ability)
	local proc_chance = ability:GetFinalGemPropertyValue("ruby", BLACKFEATHER_RUBY1)
	local proc = Filters:GetProc(hero, proc_chance)
	if proc then
		local chain = {}
		chain.index_hit = 0
		chain.enemies = FindUnitsInRadius(hero:GetTeamNumber(), target:GetAbsOrigin(), nil, BLACKFEATHER_RUBY_CHAIN_SEARCH_RANGE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false)
		if #chain.enemies > 1 then
			for i = 2, ability:GetFinalGemPropertyValue("ruby", BLACKFEATHER_RUBY2)+1, 1 do
				Timers:CreateTimer((i - 2) * 0.15, function()
					local enemy = chain.enemies[i]
					if IsValidEntity(enemy) and enemy:IsAlive() then
						EmitSoundOn("RPCItems.HyperVisor.ChainLightning", enemy)
						Filters:ApplyItemDamage(enemy, hero, damage, DAMAGE_TYPE_PHYSICAL, ability, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_SHADOW)
						local particleName = "particles/units/heroes/hero_zuus/z_w.vpcf"
						local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/z_w.vpcf", PATTACH_CUSTOMORIGIN, nil)
						local attach_unit_1 = attacker
						if i > 1 then
							attach_unit_1 = chain.enemies[i - 1]
						end
						ParticleManager:SetParticleControl(pfx, 0, attach_unit_1:GetAbsOrigin() + Vector(0, 0, attach_unit_1:GetBoundingMaxs().z + 80))
						ParticleManager:SetParticleControl(pfx, 1, enemy:GetAbsOrigin() + Vector(0, 0, enemy:GetBoundingMaxs().z + 100))
						Timers:CreateTimer(0.3, function()
							ParticleManager:DestroyParticle(pfx, false)
						end)
					end
				end)
			end
		end
	end
end

function blackfeather_attacked(event)
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	if ability:GetGemValue("emerald") > 0 then
		local proc_luck = RandomInt(1, 100)
		if proc_luck <= ability:GetFinalGemPropertyValue("emerald", BLACKFEATHER_EMERALD) then
			local eventTable = {}
			eventTable.attacker = target
			eventTable.target = attacker
			eventTable.ability = ability
			blackfeather_attack_land(eventTable)
		end
	end
end

function crow_summon_attack_land(event)
	local target = event.target
	local attacker = event.attacker
	local caster = event.caster
	local ability = attacker.hero.equipped_gear[RPC_GEAR_SLOT_HEAD]
	local damage = BLACKFEATHER_ATTACK_DAMAGE_MULT*OverflowProtectedGetAverageTrueAttackDamage(attacker.hero)
	Filters:ApplyItemDamage(target, attacker.hero, damage, DAMAGE_TYPE_PHYSICAL, ability, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_SHADOW)
	if ability:GetGemValue("sapphire") > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_blackfeather_armor_reduce", {duration = BLACKFEATHER_SAPPHIRE_ARMOR_REDUCE_DURATION})
	end
	if ability:GetGemValue("ruby") > 0 then
		blackfeather_ruby(attacker.hero, attacker, target, damage, ability)
	end
end

function blackfeather_unequip(event)
	local hero = event.target
	local ability = event.ability
	if ability.crow then
		UTIL_Remove(ability.crow)
		ability.crow = nil
	end
end

function wraith_phase(event)
	local caster = event.target
	caster:AddNoDraw()
	ProjectileManager:ProjectileDodge(caster)
end

function wraith_phase_back(event)
	local caster = event.target
	caster:RemoveNoDraw()
end

function april_fools_cast(event)
	local target = event.caster
	EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_Gyrocopter.ART_Barrage.Launch", target)
end

function egg_start(event)
	local target = event.target
	EmitSoundOn("RPCItems.PhoenixEmblem.Start", target)
end

function egg_think(event)
	local target = event.target
	target:SetAbsOrigin(target:GetAbsOrigin() + Vector(0, 0, 2.5))
	local fv = target:GetForwardVector()
	target:SetForwardVector(WallPhysics:rotateVector(fv, math.pi / 66))
end

function egg_end(event)
	local target = event.target
	local hero = target.hero
	local ability = event.ability
	hero:RemoveNoDraw()
	hero:SetAbsOrigin(ability.rezPosition)
	EmitSoundOn("RPCItems.PhoenixEmblem.Explode", hero)
	local particleName = "particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf"
	local particleVector = target:GetAbsOrigin() - Vector(0,0,220)
	-- CustomGameEventManager:Send_ServerToAllClients("special_event_close", {} )
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControl(pfx, 0, particleVector)
	ParticleManager:SetParticleControl(pfx, 1, particleVector)
	ParticleManager:SetParticleControl(pfx, 2, particleVector)
	Timers:CreateTimer(ITEM_RPC_PHOENIX_EMBLEM_RESURRECTION_DELAY, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	local damage = hero:GetMaxHealth()*ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_PHOENIX_EMBLEM_GEM_RUBY2)/100
	local stun_duration = ITEM_RPC_PHOENIX_EMBLEM_STUN_DUR + ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_PHOENIX_EMBLEM_GEM_AMETHYST2)
	ScreenShake(particleVector, 500, 0.4, 0.8, 9000, 0, true)
	local radius = ITEM_RPC_PHOENIX_EMBLEM_STUN_RADIUS + ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_PHOENIX_EMBLEM_GEM_AMETHYST1)
	local enemies = FindUnitsInRadius(hero:GetTeamNumber(), particleVector, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			if damage > 0 then
				Filters:ApplyItemDamage(enemy, hero, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_FIRE, RPC_ELEMENT_HOLY)
			end
			Filters:ApplyStun(hero, stun_duration, enemy)
		end
	end
	local starting_health_and_mana_pct = ITEM_RPC_PHOENIX_EMBLEM_REVIVE_HEALTH_AND_MANA_PCT + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_PHOENIX_EMBLEM_GEM_EMERALD2)
	hero:SetHealth(hero:GetMaxHealth()*(starting_health_and_mana_pct/100))
	hero:SetMana(hero:GetMaxMana()*(starting_health_and_mana_pct/100))
	UTIL_Remove(target)
end

function silverspring_think(event)
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero

	local ruby_regen_stacks = hero:GetActualMovespeed()*ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_SILVERSPRING_GLOVES_GEM_RUBY)
	local emerald_regen_stacks = math.floor(hero:GetAttackSpeed()*100)*ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_SILVERSPRING_GLOVES_GEM_EMERALD)
	local gem_stacks = ruby_regen_stacks + emerald_regen_stacks
	if gem_stacks > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_silverspring_gem_health_regen", {})
		hero:SetModifierStackCount("modifier_silverspring_gem_health_regen", caster, gem_stacks)
	end


	local currentStacks = hero:GetModifierStackCount("modifier_silverspring_effect", ability)
	local stacks = hero:GetHealthRegen() - currentStacks
	if not hero:HasModifier("modifier_silverspring_effect") then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_silverspring_effect", {})
	end
	hero:SetModifierStackCount("modifier_silverspring_effect", ability, stacks)
end

function silverspring_puddle_start(event)
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
	local target = event.target
	local stacks = ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_SILVERSPRING_GLOVES_GEM_SAPPHIRE)/0.1
	target:ApplyModifierAndSetStacks(ability, caster, "modifier_silverspring_in_puddle_health_regen", stacks, 0)
end

function silverspring_puddle_thinker_end(event)
	local ability = event.ability
	ParticleManager:DestroyParticle(event.target.pfx, false)
	ParticleManager:ReleaseParticleIndex(event.target.pfx)
	UTIL_Remove(event.target)
end

function cascade_hat_think(event)
	local caster = event.target
	local ability = event.ability
	ability.caster = caster
	local manaDrain = caster:GetMaxMana() * (ARCANE_CASCADE_MANA_DRAIN + ability:GetFinalGemPropertyValue("sapphire", ARCANE_CASCADE_SAPPHIRE)/100)
	if manaDrain > caster:GetMana() then
		manaDrain = caster:GetMana()
	end
	ability.damage = manaDrain * ARCANE_CASCADE_DAMAGE
	caster:ReduceMana(manaDrain)
end

function cascade_aura(event)
	local target = event.target
	local ability = event.ability
	if ability.damage then
		local damage = event.ability.damage
		Filters:ApplyItemDamage(target, event.ability.caster, damage, DAMAGE_TYPE_MAGICAL, event.ability, RPC_ELEMENT_ARCANE, RPC_ELEMENT_NONE)
	end
end

function royal_wristguard_take_damage(event)
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
end

function royal_wristguard_attack_land(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	local hero = caster.hero
	if ability:GetGemValue("sapphire") > 0 then
        local new_stacks = hero:GetModifierStackCount("modifier_royal_wristguards_stack_effect", hero.InventoryUnit) - ITEM_RPC_ROYAL_WRISTGUARDS_SAPPHIRE_STACK_LOSS
        if new_stacks > 0 then
            hero:SetModifierStackCount("modifier_royal_wristguards_stack_effect", hero.InventoryUnit, new_stacks)
        else
            hero:RemoveModifierByName("modifier_royal_wristguards_stack_effect")
        end		
	end
end

function old_wisdom_spell_cast(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.unit
	local executedAbility = event.event_ability
	--print(executedAbility:GetAbilityName())
	--print(ability.lastUsedAbilityName)
	if executedAbility:GetAbilityName() == ability.lastUsedAbilityName then
		local old_wisdom_cooldown = ITEM_RPC_BOOTS_OF_OLD_WISDOM_COOLDOWN - ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_BOOTS_OF_OLD_WISDOM_GEM_RUBY)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_boots_of_old_wisdom_cooldown", {duration = old_wisdom_cooldown})
		target:RemoveModifierByName("modifier_boots_of_old_wisdom_active")
	end
	ability.lastUsedAbilityName = executedAbility:GetAbilityName()
end

function old_wisdom_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if not target:HasModifier("modifier_boots_of_old_wisdom_cooldown") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_boots_of_old_wisdom_active", {})
	else
		target:RemoveModifierByName("modifier_boots_of_old_wisdom_active")
	end
	if ability:GetGemValue("sapphire") > 0 then
		if not target:HasModifier("modifier_old_wisdom_sapphire_thinker") then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_old_wisdom_sapphire_thinker", {})
		end
	end
end

function wisdom_sapphire_thinker(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	local current_stacks = hero:GetModifierStackCount("modifier_old_wisdom_sapphire_stacks", caster)
	local new_stacks = current_stacks + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_BOOTS_OF_OLD_WISDOM_GEM_SAPPHIRE1)
	ability:ApplyDataDrivenModifier(caster, hero, "modifier_old_wisdom_sapphire_stacks", {})
	hero:SetModifierStackCount("modifier_old_wisdom_sapphire_stacks", caster, new_stacks)
	if new_stacks >= ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_BOOTS_OF_OLD_WISDOM_GEM_SAPPHIRE2) then
		hero:RemoveModifierByName("modifier_old_wisdom_sapphire_stacks")
	end
end

function old_wisdom_active_particle(event)
	local target = event.target
	CustomAbilities:QuickAttachParticle("particles/econ/items/doom/doom_f2p_death_effect/boots_of_old_wisdom.vpcf", target, 0.9)
end

function active_old_wisdom_destroy(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	if ability:GetGemValue("amethyst") > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_old_wisdom_amethyst_inactive", {})
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_old_wisdom_amethyst_inactive_mana_regen", {})
		hero:SetModifierStackCount("modifier_old_wisdom_amethyst_inactive_mana_regen", caster, ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_BOOTS_OF_OLD_WISDOM_GEM_AMETHYST2))
	end
end

function mageplate_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	if ability:GetGemValue("emerald") > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_infused_mageplate_shield", {})
		local newStacks = math.min(target:GetModifierStackCount("modifier_infused_mageplate_shield", caster) + 1, ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_INFUSED_MAGEPLATE_GEM_EMERALD))
		target:SetModifierStackCount("modifier_infused_mageplate_shield", caster, newStacks)
	end
end

function mageplate_take_damage(event)
	local target = event.unit
	local ability = event.ability
	local caster = event.caster
	local damage = event.damage

	local manaRestore = target:GetMaxMana()*(ITEM_RPC_INFUSED_MAGEPLATE_MANA_RESTORE_PCT/100)
	target:GiveMana(manaRestore)
	local limitKey = target:GetPlayerOwnerID() .. '_mageplate_particles'
	Util.Common:LimitPerTime(6, 1, limitKey, function()
		CustomAbilities:QuickAttachParticle("particles/items3_fx/mango_active.vpcf", target, 1)
		PopupMana(target, manaRestore)
	end)
end

function mageplate_buff_end(event)
	local caster = event.caster
	local target = event.target
end

function mageplate_buff_end_int(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
end

function nobility_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, target, "modifier_ring_of_nobility_buff", {})
	target:SetModifierStackCount("modifier_ring_of_nobility_buff", ability, target:GetLevel())
end

function nobility_think_augmented(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, target, "modifier_ring_of_nobility_buff_augmented", {})
	target:SetModifierStackCount("modifier_ring_of_nobility_buff_augmented", ability, target:GetLevel())
end

function nobility_kill(event)
	local attacker = event.attacker
	local ability = event.ability
	if type(ability.newItemTable.property1) == "string" then
		ability.newItemTable.property1 = 0
	end
	local nextValue = ability.newItemTable.property1 + 1
	local upgradeThreshold = 10000
	if nextValue >= upgradeThreshold then
		RPCItems:CreateAugmentedRingOfNobility(attacker, ability)
		Notifications:Top(attacker:GetPlayerOwnerID(), {text = "Ring of Nobility Upgraded", duration = 5, style = {color = "white"}, continue = true})
		CustomAbilities:QuickAttachParticle("particles/econ/items/legion/legion_weapon_voth_domosh/legion_duel_start_endcap_arcana.vpcf", attacker, 3)
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_legion_commander/legion_commander_duel_winner_rays.vpcf", attacker, 3)

		EmitSoundOn("Items.NobilityUpgrade", attacker)
	else
		ability.newItemTable.property1 = nextValue
		RPCItems:SetPropertyValuesSpecial(ability, ability.newItemTable.property1, "#item_property_nobility", "#FFFFFF", 1, "#property_nobility_description")
		RPCItems:ItemUpdateCustomNetTables(ability)
	end
end

function ironbound_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, target, "modifier_ironbound_effect", {})
	local atk_dmg_stacks = target:GetRoshpitArmor()*ITEM_RPC_IRONBOUND_GLOVES_ATTACK_PER_ARMOR
	target:SetModifierStackCount("modifier_ironbound_effect", ability, atk_dmg_stacks)
end

function mordiggus_attack(event)
	local attacker = event.attacker
	Filters:MordiggusEvent(attacker, "attack")
end

-- function wraith_hunter_think(event)
-- 	local caster = event.caster
-- 	local target = event.target
-- 	local ability = event.ability
-- 	if not ability.wraith_mana then
-- 		ability.wraith_mana = 0
-- 	end
-- 	if target:HasModifier("modifier_bahamut_sphere_of_divinity") then
-- 		local divinityAbility = target:FindAbilityByName("bahamut_arcana_orb")
-- 		local manaDrainPerSecond = divinityAbility:GetLevelSpecialValueFor("mana_drain_per_second", divinityAbility:GetLevel())
-- 		ability.wraith_mana = math.max(ability.wraith_mana - target:GetMaxMana() * manaDrainPerSecond * WRAITH_HUNTER_DAMAGE_CONVERSION_PCT/10000, 0)
-- 	end
-- 	target:SetMana(ability.wraith_mana)
-- 	ability:ApplyDataDrivenModifier(caster, target, "modifier_wraith_hunter_attack_increase", {})
-- 	target:SetModifierStackCount("modifier_wraith_hunter_attack_increase", ability, target:GetMana())
-- end

-- function wraith_hunter_take_damage(event)
-- 	local target = event.unit
-- 	local damage = event.attack_damage
-- 	local ability = event.ability
-- 	local manaRestore = math.max(math.floor(damage * WRAITH_HUNTER_DAMAGE_CONVERSION_PCT/100), 1)
-- 	ability.wraith_mana = math.min(ability.wraith_mana + manaRestore, target:GetMaxMana())
-- 	CustomAbilities:QuickAttachParticle("particles/items3_fx/mango_active_bubbles.vpcf", target, 1)
-- end

-- function wraith_hunter_attack(event)
-- 	local attacker = event.attacker
-- 	local ability = event.ability
-- 	local manaSpent = math.min(attacker:GetMaxMana() * WRAITH_HUNTER_MANA_DRAIN_PCT/100, attacker:GetMana())
-- 	ability.wraith_mana = math.max(ability.wraith_mana - manaSpent, 0)
-- 	if attacker:HasModifier("modifier_bluestar_armor") then
-- 		local target = attacker
-- 		target.bluestarSlideVelocity = 25
-- 		local heal = manaSpent
-- 		Filters:ApplyHeal(target, target, heal, true)

-- 		target.body:ApplyDataDrivenModifier(target.InventoryUnit, target, "modifier_bluestar_slide", {duration = 0.6})

-- 		local particleName = "particles/items_fx/arcane_boots.vpcf"
-- 		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target)
-- 		ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
-- 		Timers:CreateTimer(0.2, function()
-- 			ParticleManager:DestroyParticle(pfx, false)
-- 		end)
-- 	end
-- end

-- function wraith_hunter_spell_cast(event)
-- 	local target = event.unit
-- 	local ability = event.ability
-- 	local executedAbility = event.event_ability
-- 	local manaSpent = executedAbility:GetManaCost(executedAbility:GetLevel() - 1)
-- 	ability.wraith_mana = math.max(ability.wraith_mana - manaSpent, 0)
-- end

function twig_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	if not target:IsAlive() then
		return false
	end
	if target:HasModifier("modifier_recently_respawned") then
		return false
	end
	if not ability.twigPFX then
		local particleName = "particles/items3_fx/twig_of_enlightened_shield.vpcf"
		ability.twigPFX = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(ability.twigPFX, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(ability.twigPFX, 1, Vector(1, 1, 1))
	end
	if not target.manaShellAbsorb then
		target.manaShellAbsorb = 0
		target.manaShellMana = target:GetMana()
	end
	local max_capacity = ITEM_RPC_TWIG_OF_THE_ENLIGHTENED_SHIELD_MAX_CAPACITY + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_TWIG_OF_THE_ENLIGHTENED_GEM_SAPPHIRE)
	if target:GetMana() > target.manaShellMana then
		local manaGained = target:GetMana() - target.manaShellMana
		target.manaShellAbsorb = math.min(target.manaShellAbsorb + manaGained * (ITEM_RPC_TWIG_OF_THE_ENLIGHTENED_MANA_GAIN_TO_SHIELD + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_TWIG_OF_THE_ENLIGHTENED_GEM_RUBY)), target:GetMaxMana() * max_capacity)
		CustomAbilities:QuickAttachParticle("particles/econ/items/luna/luna_lucent_ti5/luna_eclipse_cast_flash_ti_5.vpcf", target, 1)
	end
	if ability.twigPFX then
		local ratio = math.min((target.manaShellAbsorb / (target:GetMaxMana() * max_capacity)) * 255, 255)
		ParticleManager:SetParticleControl(ability.twigPFX, 1, Vector(ratio, ratio, ratio))
	end
	if target.manaShellAbsorb > 0 then
		if not target:HasModifier("modifier_twig_of_the_enlightened_shield") then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_twig_of_the_enlightened_shield", {})
		end
	else
		target:RemoveModifierByName("modifier_twig_of_the_enlightened_shield")
	end
	target.manaShellMana = target:GetMana()

end

function twig_shield_create(event)
	local target = event.target
	local ability = event.ability
	-- local particleName = "particles/items3_fx/twig_of_enlightened_shield.vpcf"
	-- if not ability.twigPFX then
	-- ability.twigPFX = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target)
	-- ParticleManager:SetParticleControlEnt(ability.twigPFX, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	-- ParticleManager:SetParticleControl(ability.twigPFX, 1, Vector(1, 1, 1))
	-- end
end

function twig_shield_destroy(event)
	local target = event.target
	local ability = event.ability
	if ability.twigPFX then
		ParticleManager:DestroyParticle(ability.twigPFX, true)
		ability.twigPFX = false
	end
end

function twig_shield_death(event)
	local target = event.unit
	local ability = event.ability
	if ability.twigPFX then
		ParticleManager:DestroyParticle(ability.twigPFX, true)
		ability.twigPFX = false
	end
end

function twig_take_damage(event)
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
	local damage = event.damage
	if damage > 2 and ability:GetGemValue("emerald") > 0 then
		local manaRestore = hero:GetMaxMana()*ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_TWIG_OF_THE_ENLIGHTENED_GEM_EMERALD)/100
		hero:GiveMana(manaRestore)
	end
end

function pure_waters_attack_land(event)
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
	--print("PURE WATER ATTACK")
	if ability:GetGemValue("ruby") > 0 then
		--print("RUBY")
		local proc_chance = ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_BOOTS_OF_PURE_WATERS_GEM_RUBY2)
		local proc = Filters:GetProc(hero, proc_chance)
		if proc then
			Filters:PureWaters(hero, "attack")
		end
	end
end

function pure_waters_impact(event)
	local ability = event.ability
	local caster = event.ability.caster
	local damage = caster:GetIntellect() * ITEM_RPC_BOOTS_OF_PURE_WATERS_INT_TO_DMG + OverflowProtectedGetAverageTrueAttackDamage(caster)*(ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_BOOTS_OF_PURE_WATERS_GEM_RUBY1)/100) + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_BOOTS_OF_PURE_WATERS_GEM_EMERALD2)
	Filters:ApplyItemDamage(event.target, caster, damage, DAMAGE_TYPE_PURE, event.ability, RPC_ELEMENT_WATER, RPC_ELEMENT_NONE)
end

function sweeping_winds_attack(event)
	local attacker = event.attacker
	local caster = event.caster
	local ability = event.ability
	local stack_reduction = -1
	local ruby_dont_lose_stack_proc = Filters:GetProc(attacker, ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_GLOVES_OF_SWEEPING_WIND_GEM_RUBY))
	if ruby_dont_lose_stack_proc then
		stack_reduction = 0
	end
	if stack_reduction ~= 0 then
		Filters:SweepingWindsStackChange(attacker, ability, stack_reduction)
	end
end

function sweeping_winds_glove_end(event)
	local attacker = event.target
	local ability = event.ability
	StopSoundEvent("Items.SweepingWind", attacker)
	if ability then
		if ability.windParticle then
			ParticleManager:DestroyParticle(ability.windParticle, false)
		end
		ability.windParticle = false
	end
end

function sweeping_winds_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local enemies = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, ITEM_RPC_GLOVES_OF_SWEEPING_WIND_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		local currentStacks = target:GetModifierStackCount("modifier_sweeping_wind_stackable", caster)
		local damage = OverflowProtectedGetAverageTrueAttackDamage(target) * ITEM_RPC_GLOVES_OF_SWEEPING_WIND_ATT_POWER_TO_DAMAGE_PCT/100 * currentStacks + ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_GLOVES_OF_SWEEPING_WIND_GEM_AMETHYST1)
		for _, enemy in pairs(enemies) do
			CustomAbilities:QuickAttachParticle("particles/econ/items/elder_titan/elder_titan_fissured_soul/elder_titan_fissured_soul_spirit_buff_endcap.vpcf", enemy, 0.8)
			Filters:ApplyItemDamage(enemy, target, damage, DAMAGE_TYPE_MAGICAL, event.ability, RPC_ELEMENT_WIND, RPC_ELEMENT_NONE)
		end
	end
end

function depth_crest_hit(event)
	local target = event.target
	local ability = event.ability
	Filters:DepthCrestArmor(target, ability, ITEM_RPC_DEPTH_CREST_ARMOR_CHANCE)
end

function lava_forge_take_damage(event)
	local ability = event.ability
	local target = event.unit
	local attacker = event.attacker
	if target == event.attacker then
		return false
	end
	if not ability.fireballs then
		ability.fireballs = 0
		ability.caster = target
	end
	if ability.fireballs >= LAVA_FORGE_MAX_FIREBALLS then
		return false
	end
	local proc_chance = LAVA_FORGE_BASE_PROC_CHANCE + ability:GetFinalGemPropertyValue("ruby", LAVA_FORGE_RUBY)
	local proc = Filters:GetProc(target, proc_chance)
	if proc then
		local fv = (attacker:GetAbsOrigin() * Vector(1, 1, 0) - target:GetAbsOrigin() * Vector(1, 1, 0)):Normalized()

		local projectileParticle = "particles/units/heroes/hero_jakiro/fireball.vpcf"
		EmitSoundOn("Items.LavaforgeFire", target)
		local start_radius = 150
		local end_radius = 150
		local range = 1300
		local speed = 1100
		local casterOrigin = target:GetAbsOrigin()
		local info =
		{
			Ability = ability,
			EffectName = projectileParticle,
			vSpawnOrigin = casterOrigin + Vector(0, 0, 50),
			fDistance = range,
			fStartRadius = start_radius,
			fEndRadius = end_radius,
			Source = target,
			StartPosition = "attach_hitloc",
			bHasFrontalCone = true,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 5.0,
			bDeleteOnHit = true,
			vVelocity = fv * speed,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
		Timers:CreateTimer(3, function()
			ability.fireballs = ability.fireballs - 1
		end)
	end
end

function lava_forge_fireball_hit(event)
	local ability = event.ability
	local caster = ability.caster
	local target = event.target

	--print("IMPACT?")
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * (LAVA_FORGE_DMG_PER_ATT/100) + caster:GetAgility()*(ability:GetFinalGemPropertyValue("emerald", LAVA_FORGE_EMERALD)/100)

	local radius = LAVA_FORGE_RADIUS
	local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
	local particle2 = ParticleManager:CreateParticle(particleNameS, PATTACH_WORLDORIGIN, target)
	ParticleManager:SetParticleControl(particle2, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle2, 1, Vector(radius, radius, radius))
	ParticleManager:SetParticleControl(particle2, 2, Vector(2.0, 2.0, 2.0))
	ParticleManager:SetParticleControl(particle2, 4, Vector(255, 90, 20))
	Timers:CreateTimer(1.5, function()
		ParticleManager:DestroyParticle(particle2, false)
	end)

	local particleName = "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControl(particle1, 0, target:GetAbsOrigin())
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
	EmitSoundOn("Items.LavaforgeImpact", target)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:ApplyItemDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, event.ability, RPC_ELEMENT_FIRE, RPC_ELEMENT_WIND)
		end
	end
end

function water_mage_robes_channel_init(event)
	local hero = event.caster.hero
	local ability = event.ability
	CustomAbilities:QuickAttachParticle("particles/econ/items/monkey_king/arcana/water/mk_arcana_spring_cast_ring_outer_pnt.vpcf", hero, 4)
end

function water_mage_robes_channel_think(event)
	local caster = event.target
	local ability = event.ability
	ability.hero = caster
	EmitSoundOn("Tanari.WaterTemple.RareWrathWater", caster)

	local baseFV = caster:GetForwardVector()

	
	for i = 1, 6, 1 do
		local fv = WallPhysics:rotateVector(baseFV, 2 * math.pi * i / 6)
		Filters:WaterMageRobeProjectile(ability, caster, fv)
	end
end

function water_mage_robes_projectile_hit(event)
	local hero = event.ability.hero
	local target = event.target
	local ability = event.ability
	local damage = hero:GetIntellect() * ITEM_RPC_WATER_MAGE_ROBES_INT_TO_DMG + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_WATER_MAGE_ROBES_GEM_EMERALD1)
	Filters:ApplyItemDamage(target, hero, damage, DAMAGE_TYPE_MAGICAL, event.ability, RPC_ELEMENT_WATER, RPC_ELEMENT_NONE)
	ability:ApplyDataDrivenModifier(event.caster, target, "modifier_water_mage_slow", {duration = ITEM_RPC_WATER_MAGE_ROBES_SLOW_DURATION})
end

function halcyon_glove_think(event)
	local caster = event.caster
	local target = event.target
	local hero = caster.hero
	local ability = event.ability
	if ability:GetGemValue("ruby") > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_halcyon_soul_glove_effect", {})
		local multiple = ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_HALCYON_SOUL_GLOVE_GEM_RUBY)
		local stacks = Filters:GetPrimaryAttributeMultiple(hero, multiple)
		hero:SetModifierStackCount("modifier_halcyon_soul_glove_effect", caster, stacks)
	end
end

function nightmare_rider_attackland(event)
	local caster = event.caster
	local attacker = event.attacker
	local ability = event.ability
	Filters:NightmareRiderStacksGain(attacker, 1)

end

function leon_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster

	local primeAttribute = target:GetRoshpitPrimaryAttribute()
	local prime_mult = ITEM_RPC_GOLD_PLATE_OF_LEON_PRIMARY_ATTRIBUTE_INCREASE/100 + ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_GOLD_PLATE_OF_LEON_GEM_AMETHYST)/100
	if primeAttribute == ROSHPIT_ATTRIBUTE_STRENGTH then
		local strStacks = math.floor(target:GetBaseStrength() * prime_mult, 0)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_gold_plate_of_leon_str", {})
		target:SetModifierStackCount("modifier_gold_plate_of_leon_str", ability, strStacks)
		target:RemoveModifierByName("modifier_gold_plate_of_leon_agi")
		target:RemoveModifierByName("modifier_gold_plate_of_leon_int")
		target:RemoveModifierByName("modifier_gold_plate_of_leon_spr")
	elseif primeAttribute == ROSHPIT_ATTRIBUTE_AGILITY then
		local agiStacks = math.floor(target:GetBaseAgility() * prime_mult, 0)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_gold_plate_of_leon_agi", {})
		target:SetModifierStackCount("modifier_gold_plate_of_leon_agi", ability, agiStacks)
		target:RemoveModifierByName("modifier_gold_plate_of_leon_str")
		target:RemoveModifierByName("modifier_gold_plate_of_leon_int")
		target:RemoveModifierByName("modifier_gold_plate_of_leon_spr")
	elseif primeAttribute == ROSHPIT_ATTRIBUTE_INTELLIGENCE then
		local intStacks = math.floor(target:GetBaseIntellect() * prime_mult, 0)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_gold_plate_of_leon_int", {})
		target:SetModifierStackCount("modifier_gold_plate_of_leon_int", ability, intStacks)
		target:RemoveModifierByName("modifier_gold_plate_of_leon_agi")
		target:RemoveModifierByName("modifier_gold_plate_of_leon_str")
		target:RemoveModifierByName("modifier_gold_plate_of_leon_spr")
	elseif primeAttribute == ROSHPIT_ATTRIBUTE_SPIRIT then
		local sprStacks = math.floor(target:GetBaseSpirit() * prime_mult, 0)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_gold_plate_of_leon_spr", {})
		target:SetModifierStackCount("modifier_gold_plate_of_leon_spr", ability, sprStacks)
		target:RemoveModifierByName("modifier_gold_plate_of_leon_agi")
		target:RemoveModifierByName("modifier_gold_plate_of_leon_str")
		target:RemoveModifierByName("modifier_gold_plate_of_leon_int")
	end
	if ability:GetGemValue("sapphire") > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_leon_extra_atk", {})
		local stacks = Filters:GetPrimaryAttributeMultiple(target, ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_GOLD_PLATE_OF_LEON_GEM_SAPPHIRE))
		target:SetModifierStackCount("modifier_leon_extra_atk", caster, stacks)
	end
end



function ablecore_greaves_think(event)
	local hero = event.target
	local ability = event.ability
	local caster = event.caster
	local movespeed = hero:GetActualMovespeed()
	local threshold = ITEM_RPC_ABLECORE_GREAVES_MS_REQ + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_ABLECORE_GREAVES_GEM_SAPPHIRE)

	--slow move speed
	if movespeed <= threshold then
		event.ability:ApplyDataDrivenModifier(caster, hero, "modifier_ablecore_greaves_effect", {})
		--print("apply")
		if ability:GetGemValue("amethyst") > 0 then
			ability:ApplyDataDrivenModifier(caster, hero, "modifier_ablecore_attack_power", {})
			hero:SetModifierStackCount("modifier_ablecore_attack_power", castear, ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_ABLECORE_GREAVES_GEM_AMETHYST))
		end
	else
		--fast move speed
		if hero:HasModifier("modifier_ablecore_greaves_effect") and hero:FindModifierByName("modifier_ablecore_greaves_effect"):GetDuration() == -1 then
			if ability:GetGemValue("ruby") > 0  then
				event.ability:ApplyDataDrivenModifier(caster, hero, "modifier_ablecore_greaves_effect", {duration = ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_ABLECORE_GREAVES_GEM_RUBY2)})
			else
				hero:RemoveModifierByName("modifier_ablecore_greaves_effect")
			end
		end
	end
end

function dragon_scale_armor_think(event)
	local target = event.target
	local ability = event.ability
	local gem = event.gem
	local attack_damage = 0
	if gem == "sapphire" then
		attack_damage = (ITEM_RPC_SAPPHIRE_DRAGON_SCALE_ARMOR_ATTACK_PER_INT + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_RUBY_DRAGON_SCALE_ARMOR_GEM_SAPPHIRE))*target:GetIntellect()
	elseif gem == "ruby" then
		attack_damage = (ITEM_RPC_RUBY_DRAGON_SCALE_ARMOR_ATTACK_PER_STR + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_RUBY_DRAGON_SCALE_ARMOR_GEM_RUBY))*target:GetStrength()
	elseif gem == "topaz" then
		attack_damage = (ITEM_RPC_TOPAZ_DRAGON_SCALE_ARMOR_ATTACK_PER_AGI + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_RUBY_DRAGON_SCALE_ARMOR_GEM_EMERALD))*target:GetAgility()
	end
	local ability = event.ability
	local caster = event.caster
	local modifier_name = "modifier_"..gem.."_dragon_scale_effect"
	ability:ApplyDataDrivenModifier(caster, target, modifier_name, {})
	target:SetModifierStackCount(modifier_name, caster, attack_damage)
end

function giant_hunter_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	if target:IsRooted() and ability:GetGemValue("ruby") > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_giant_hunters_immunity", {duration = ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_GIANT_HUNTERS_BOOTS_OF_RESILIENCE_GEM_RUBY)})
	end
	if target:IsStunned() then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_giant_hunters_immunity", {duration = ITEM_RPC_GIANT_HUNTERS_BOOTS_OF_RESILIENCE_IMMUNITY_DURATION})
	end
	if not ability.interval then
		ability.interval = 0
	end
	ability.interval = ability.interval + 1
	if ability.interval >= 5 then
		ability.interval = 0
		if ability:GetGemValue("emerald") > 0 or ability:GetGemValue("sapphire") > 0 or ability:GetGemValue("amethyst") > 0 then
			local big_boy_nearby = false
			local enemies = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, ITEM_RPC_GIANT_HUNTERS_BOOTS_OF_RESILIENCE_ENEMY_SEARCH_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				for _, enemy in pairs(enemies) do
					if enemy.paragon then
						big_boy_nearby = true
						break
					end
					if enemy:GetEnemyTier() >= ENEMY_TYPE_MINI_BOSS then
						big_boy_nearby = true
						break
					end
				end
			end
			if big_boy_nearby then
				ability:ApplyDataDrivenModifier(caster, target, "modifier_giant_hunter_boss_nearby", {duration = 1})
			end
		end
	end
end

function spiritual_empowerment_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, target, "modifier_spiritual_empowerment_stack", {})
	local newStack = target:GetModifierStackCount("modifier_spiritual_empowerment_stack", caster) + 1
	local max_stacks = ITEM_RPC_SPIRITUAL_EMPOWERMENT_GLOVE_MAX_STACKS + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_SPIRITUAL_EMPOWERMENT_GLOVE_GEM_EMERALD)
	if newStack <= max_stacks then
		CustomAbilities:QuickAttachParticle("particles/econ/items/monkey_king/arcana/base/monkey_king_arcana_spring_cast_spiral.vpcf", target, 2)
	end
	newStack = math.min(newStack, max_stacks)
	target:SetModifierStackCount("modifier_spiritual_empowerment_stack", caster, newStack)
	Filters:SpiritualEmpowermentStackUpdate(target)
end

function trials_attack(event)
	local damage = event.damage
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	damage = OverflowProtectedGetAverageTrueAttackDamage(attacker)*(ITEM_RPC_SACRED_TRIALS_ARMOR_ATTACK_TO_DMG + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_SACRED_TRIALS_ARMOR_GEM_SAPPHIRE2))/100
	damage = CustomAttributes:AdjustDamageForRoshpitAttributes(attacker, target, DAMAGE_TYPE_PHYSICAL, damage, ability:GetEntityIndex())
	EmitSoundOn("Item.SacredTrial", target)
	local radius = ITEM_RPC_SACRED_TRIALS_ARMOR_AOE_RADIUS + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_SACRED_TRIALS_ARMOR_GEM_EMERALD2)
	local particleName = "particles/roshpit/items/sacred_trial.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControl(particle1, 0, target:GetAbsOrigin())
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)

	local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:ApplyItemDamage(enemy, attacker, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
		end
	end

	local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
	local particle2 = ParticleManager:CreateParticle(particleNameS, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particle2, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle2, 1, Vector(radius, radius, radius))
	ParticleManager:SetParticleControl(particle2, 2, Vector(1.0, 1.0, 1.0))
	ParticleManager:SetParticleControl(particle2, 4, Vector(255, 160, 50))
	Timers:CreateTimer(1.5, function()
		ParticleManager:DestroyParticle(particle2, false)
	end)
	attacker:RemoveModifierByName("modifier_sacred_trials_attack_bonus")
end

function sacred_trials_think(event)
	local hero = event.caster.hero
	local caster = event.caster
	local ability = event.ability
	if ability:GetGemValue("ruby") > 0 then
		local proc = Filters:GetProc(hero, ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_SACRED_TRIALS_ARMOR_GEM_RUBY1))
		if proc then
	        Filters:SacredTrialActivate(hero)
		end
	end
end

function sacred_trials_attack_land(event)
	local hero = event.caster.hero
	local caster = event.caster
	local ability = event.ability
	if ability:GetGemValue("ruby") > 0 then
		local proc = Filters:GetProc(hero, ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_SACRED_TRIALS_ARMOR_GEM_SAPPHIRE1))
		if proc then
	        Filters:SacredTrialActivate(hero)
		end
	end
end

function gravekeeper_attack(event)
	local caster = event.caster
	local ability = event.ability
	local attacker = event.attacker
	local target = event.target
	if not ability.targetIndex then
		ability.targetIndex = target:GetEntityIndex()
		EmitSoundOn("Item.GraveKeeper", target)
	end
	local duration = ITEM_RPC_GRAVEKEEPERS_GAUNTLET_DEBUFF_DURATION
	if target:GetEnemyTier() >= ENEMY_TYPE_BOSS then
		duration = ITEM_RPC_GRAVEKEEPERS_GAUNTLET_DEBUFF_DURATION_BOSS
	end
	local stack_gain = 1
	if ability:GetGemValue("sapphire") > 0 then
		local proc = Filters:GetProc(attacker, ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_GRAVEKEEPERS_GAUNTLET_GEM_SAPPHIRE))
		if proc then
			stack_gain = stack_gain + 1
		end
	end
	if ability.targetIndex == target:GetEntityIndex() then
		local max_stacks_per_sec = ITEM_RPC_GRAVEKEEPERS_GAUNTLET_MAX_STACKS_PER_SEC + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_GRAVEKEEPERS_GAUNTLET_GEM_EMERALD)
		local limitKey = caster:GetPlayerOwnerID() .. '_gravekeeper_gauntlet'
		Util.Common:LimitPerTime(max_stacks_per_sec, 1, limitKey, function()
			ability:ApplyDataDrivenModifier(caster, target, "modifier_gravekeeper_gauntlet_target", {duration = duration})
			ability:ApplyDataDrivenModifier(caster, attacker, "modifier_gravekeeper_gauntlet_buff", {duration = duration})
			local newTargetStacks = math.min(target:GetModifierStackCount("modifier_gravekeeper_gauntlet_target", caster) + stack_gain, ITEM_RPC_GRAVEKEEPERS_GAUNTLET_MAX_STACKS_TOTAL)
			target:SetModifierStackCount("modifier_gravekeeper_gauntlet_target", caster, newTargetStacks)
			local newAttackerStacks = math.min(attacker:GetModifierStackCount("modifier_gravekeeper_gauntlet_buff", caster) + stack_gain, ITEM_RPC_GRAVEKEEPERS_GAUNTLET_MAX_STACKS_TOTAL)
			attacker:SetModifierStackCount("modifier_gravekeeper_gauntlet_buff", caster, newAttackerStacks)
			ability.gravekeeper_stacks = newAttackerStacks
			gravekeeper_update_amethyst(attacker, target, ability, ability.gravekeeper_stacks, duration)
		end)
	else
		local transfer_stacks = math.max(ability.gravekeeper_stacks*(ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_GRAVEKEEPERS_GAUNTLET_GEM_RUBY)/100), stack_gain)
		local oldTarget = EntIndexToHScript(ability.targetIndex)
		if oldTarget and IsValidEntity(oldTarget) then
			oldTarget:RemoveModifierByName("modifier_gravekeeper_gauntlet_target")
		end
		attacker:RemoveModifierByName("modifier_gravekeeper_gauntlet_buff")
		ability:ApplyDataDrivenModifier(caster, target, "modifier_gravekeeper_gauntlet_target", {duration = duration})
		ability:ApplyDataDrivenModifier(caster, attacker, "modifier_gravekeeper_gauntlet_buff", {duration = duration})
		target:SetModifierStackCount("modifier_gravekeeper_gauntlet_target", caster, transfer_stacks)
		attacker:SetModifierStackCount("modifier_gravekeeper_gauntlet_buff", caster, transfer_stacks)
		EmitSoundOn("Item.GraveKeeper", target)
		ability.targetIndex = target:GetEntityIndex()
		ability.gravekeeper_stacks = transfer_stacks
		gravekeeper_update_amethyst(attacker, target, ability, ability.gravekeeper_stacks, duration)
	end
	target:CalculateAndSaveRoshpitAttributes()
end

function gravekeeper_update_amethyst(hero, target, ability, stacks, duration)
	if ability:GetGemValue("amethyst") > 0 then
		local speed_stacks = stacks*ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_GRAVEKEEPERS_GAUNTLET_GEM_AMETHYST)
		ability:ApplyDataDrivenModifier(hero.InventoryUnit, hero, "modifier_gravekeeper_self_amethyst", {duration = duration})
		ability:ApplyDataDrivenModifier(hero.InventoryUnit, target, "modifier_gravekeeper_target_amethyst", {duration = duration})
		hero:SetModifierStackCount("modifier_gravekeeper_self_amethyst", hero.InventoryUnit, speed_stacks)
		target:SetModifierStackCount("modifier_gravekeeper_target_amethyst", hero.InventoryUnit, speed_stacks)
	end
end

function eyeglass_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if target:GetAttackCapability() == DOTA_UNIT_CAP_RANGED_ATTACK then
		local attack_range = ITEM_RPC_EPSILONS_EYEGLASS_ATTACK_RANGE + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_EPSILONS_EYEGLASS_GEM_EMERALD)
		local projectile_speed = ITEM_RPC_EPSILONS_EYEGLASS_PROJECTILE_SPEED + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_EPSILONS_EYEGLASS_GEM_SAPPHIRE1)
		-- ability:ApplyDataDrivenModifier(caster, target,"modifier_epsilons_eyeglass_range_effect_attack_range", {})
		ability:ApplyDataDrivenModifier(caster, target,"modifier_epsilons_eyeglass_range_effect_projectile_speed", {})
		-- target:SetModifierStackCount("modifier_epsilons_eyeglass_range_effect_attack_range", caster, attack_range)
		target:SetModifierStackCount("modifier_epsilons_eyeglass_range_effect_projectile_speed", caster, projectile_speed)
		if ability:GetGemValue("sapphire") > 0 then
			local atk_power_stacks = ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_EPSILONS_EYEGLASS_GEM_SAPPHIRE2)
			ability:ApplyDataDrivenModifier(caster, target, "modifier_epsilons_eyeglass_attack_power", {})
			target:SetModifierStackCount("modifier_epsilons_eyeglass_attack_power", caster, atk_power_stacks)
		end
	else
		-- target:RemoveModifierByName("modifier_epsilons_eyeglass_range_effect_attack_range")
		target:RemoveModifierByName("modifier_epsilons_eyeglass_range_effect_projectile_speed")
	end
end

function autumn_sleeper_root_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	if not target:HasModifier("modifier_autumn_sleeper_root_immunity") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_autumn_sleeper_root", {duration = AUTUMN_SLEEPER_ROOT_DUR})
		ability:ApplyDataDrivenModifier(caster, target, "modifier_autumn_sleeper_root_immunity", {duration = AUTUMN_SLEEPER_ROOT_DUR_IMMUNITY})
	end

end

function autumn_sleeper_main_root_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	if ability:GetGemValue("emerald") > 0 then
		local damage = OverflowProtectedGetAverageTrueAttackDamage(caster.hero)*ability:GetFinalGemPropertyValue("emerald", AUTUMN_SLEEPER_EMERALD)/100
		Filters:ApplyItemDamage(target, caster.hero, damage, DAMAGE_TYPE_PHYSICAL, ability, RPC_ELEMENT_NATURE, RPC_ELEMENT_NONE)
	end
end

function autumn_sleeper_main_root_end(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	if ability:GetGemValue("sapphire") > 0 then
		local slow_duration = ability:GetFinalGemPropertyValue("sapphire", AUTUMN_SLEEPER_SAPPHIRE)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_autumn_sleeper_sapphire_slow", {duration = slow_duration})
	end
end

function eye_of_seasons_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability

	local stats = math.floor(target:GetBaseIntellect() * EYE_OF_SEASONS_INT_TO_STR_AGI)
	if ability:GetGemValue("ruby") > 0 then
		stats = stats + math.floor(target:GetBaseSpirit() * ability:GetFinalGemPropertyValue("ruby", EYE_OF_SEASONS_RUBY)/100)
	end
	ability:ApplyDataDrivenModifier(caster, target, "modifier_eye_of_seasons_stats", {})
	target:SetModifierStackCount("modifier_eye_of_seasons_stats", caster, stats)
end

function autumn_mage_boss_explosion(caster, position, damage, explosionAOE, ability)
	local particleName = "particles/econ/items/centaur/centaur_ti6/centaur_ti6_warstomp.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(particle1, 0, position)
	ParticleManager:SetParticleControl(particle1, 1, Vector(explosionAOE, 5, explosionAOE * 2))
	Timers:CreateTimer(4, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
	local damage = caster:GetStrength() * ITEM_RPC_AUTUMNROCK_BRACER_DMG_PER_STR
	EmitSoundOnLocationWithCaster(position, "Item.AutumnMage.Quake", caster)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, explosionAOE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:ApplyItemDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_EARTH, RPC_ELEMENT_NONE)
			Filters:ApplyStun(caster, 2, enemy)
		end
	end
end

function fuchsia_ring_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	if ability:GetGemValue("emerald") > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_fuschia_ring_emerald_health_regen", {})
		local regen_stacks = ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_FUCHSIA_RING_GEM_EMERALD)/0.1
		target:SetModifierStackCount("modifier_fuschia_ring_emerald_health_regen", caster, regen_stacks)
	end
end

function silent_templar_attack_land(event)
	local target = event.target
	if not target.dummy then
		local ability = event.ability
		local attacker = event.attacker
		local damage = OverflowProtectedGetAverageTrueAttackDamage(attacker) * SILENT_TEMPLAR_ATTACK_TO_DAMAGE/100
		Filters:ApplyItemDamage(target, attacker, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_ARCANE, RPC_ELEMENT_DEMON)
		CustomAbilities:QuickAttachParticle("particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void_hit.vpcf", target, 2.5)
		EmitSoundOn("Item.SilentWatch.Hit", target)
	end
end

function mana_wall_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local currentmana = target:GetMana()
	if currentmana > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_mystic_mana_wall_armor", {})
		target:SetModifierStackCount("modifier_mystic_mana_wall_armor", caster, currentmana * ITEM_RPC_MYSTIC_MANA_WALL_ARMOR_PER_MANA)
	else
		target:RemoveModifierByName("modifier_mystic_mana_wall_armor")
	end
	local max_mana_stacks = 0
	max_mana_stacks = max_mana_stacks + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_MYSTIC_MANA_WALL_GEM_RUBY)*target:GetStrength()
	max_mana_stacks = max_mana_stacks + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_MYSTIC_MANA_WALL_GEM_EMERALD)*target:GetAgility()
	max_mana_stacks = max_mana_stacks + ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_MYSTIC_MANA_WALL_GEM_AMETHYST)*target:GetSpirit()
	if max_mana_stacks > 0 then
		if not target:HasModifier("modifier_mystic_mana_wall_max_mana") then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_mystic_mana_wall_max_mana", {})
		end
		target:SetModifierStackCount("modifier_mystic_mana_wall_max_mana", caster, max_mana_stacks)
	else
	end
end

function malachite_shade_bracer_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	local regenStacks = math.ceil(target:GetAgility() * ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_MALACHITE_SHADE_BRACER_GEM_EMERALD)) + math.ceil(target:GetSpirit() * ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_MALACHITE_SHADE_BRACER_GEM_AMETHYST))
	local damageStacks = (target:GetHealthRegen() + target:GetBaseManaRegen() + target:GetBonusManaRegen())*(ITEM_RPC_MALACHITE_SHADE_BRACER_BASE_ATTACK_FROM_HEALTH_AND_MANA_REGEN/100)
	if regenStacks > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_malachite_shade_regen", {})
		target:SetModifierStackCount("modifier_malachite_shade_regen", caster, regenStacks)
	end

	ability:ApplyDataDrivenModifier(caster, target, "modifier_malachite_shade_damage", {})
	target:SetModifierStackCount("modifier_malachite_shade_damage", caster, damageStacks)
end

function wind_deity_think(event)
	local ability = event.ability
	ability.targetsHit = 0
end

function init_wind_deity(event)
	local ability = event.ability
	ability.targetsHit = 0
end

function infernal_prison_dot_think(event)
	local ability = event.ability
	local target = event.target
	local hero = event.caster.hero
	local damage = OverflowProtectedGetAverageTrueAttackDamage(hero)*(ITEM_RPC_THE_INFERNAL_PRISON_DAMAGE_ATK_PWR_PCT/100) + ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_THE_INFERNAL_PRISON_GEM_AMETHYST)
	Filters:ApplyItemDamage(target, hero, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
end

function infernal_prison_nearby_start(event)
	local ability = event.ability
	local target = event.target
	local caster = event.caster.hero
	if ability:GetGemValue("emerald") > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_infernal_prison_emerald", {})
		target:SetModifierStackCount("modifier_infernal_prison_emerald", caster, ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_THE_INFERNAL_PRISON_GEM_EMERALD))
	end
end

function infernal_prison_attacked(event)
	local ability = event.ability
	local target = event.target
	local caster = event.caster
	local attacker = event.attacker
	if ability:GetGemValue("ruby") > 0 then
		local duration = ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_THE_INFERNAL_PRISON_GEM_RUBY)
		ability:ApplyDataDrivenModifier(caster, attacker, "modifier_infernal_prison_ruby", {duration = duration})
		if ability:GetGemValue("emerald") > 0 then
			ability:ApplyDataDrivenModifier(caster, attacker, "modifier_infernal_prison_emerald_ruby", {duration = duration})
			attacker:SetModifierStackCount("modifier_infernal_prison_emerald_ruby", caster, ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_THE_INFERNAL_PRISON_GEM_EMERALD))
		end
	end
end

function skulldigger_think(event)
	local ability = event.ability
	local hero = event.target
	local caster = event.caster
	ability.hero = hero
	Filters:IncrementSkullDiggerStacks(caster, ability, hero)
end

function skulldigger_attack_land(event)
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
	if ability:GetGemValue("amethyst") > 0 then
		local proc = Filters:GetProc(hero, ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_SKULLDIGGER_GAUNTLET_GEM_AMETHYST1))
		if proc then
			Filters:IncrementSkullDiggerStacks(caster, ability, hero)
		end
	end
end

function hellfire_stack_take_damage(event)
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
	local attacker = event.attacker
	if hero == attacker then
		return false
	end
	Filters:SkulldiggerWraithBlast(caster, ability, hero, attacker)
end

function skulldigger_hellfire_hit(event)
	local target = event.target

	local ability = event.ability
	local caster = ability.hero
	local stun_duration = ITEM_RPC_SKULLDIGGER_GAUNTLET_STUN_DURATION + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_SKULLDIGGER_GAUNTLET_GEM_EMERALD2)
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * (ITEM_RPC_SKULLDIGGER_GAUNTLET_ATTACK_POWER_TO_DAMAGE/100) + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_SKULLDIGGER_GAUNTLET_GEM_RUBY2)

	EmitSoundOn("RoshpitItem.SkulldiggerImpact", target)

	local radius = ITEM_RPC_SKULLDIGGER_GAUNTLET_STUN_RADIUS
	local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
	local particle2 = ParticleManager:CreateParticle(particleNameS, PATTACH_WORLDORIGIN, target)
	ParticleManager:SetParticleControl(particle2, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle2, 1, Vector(radius, radius, radius))
	ParticleManager:SetParticleControl(particle2, 2, Vector(2.0, 2.0, 2.0))
	ParticleManager:SetParticleControl(particle2, 4, Vector(0, 220, 100))
	Timers:CreateTimer(1.5, function()
		ParticleManager:DestroyParticle(particle2, false)
	end)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:ApplyStun(caster, stun_duration, enemy)
			Filters:ApplyItemDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_GHOST)
		end
	end
end

function shipyard_shield_lvl3_take_damage(event)

end

function shipyard_veil_lvl_3_hit(event)
	local ability = event.ability
	local target = event.target
	local caster = ability.hero
	if not caster then
		return false
	end
	local damage = ability:GetFinalGemPropertyValue("emerald", SHIPYARD_VEIL_EMERALD)
	Filters:ApplyItemDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_GHOST)
end

function crimsyth_elite_greaves_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability

	if target:HasModifier("modifier_crimsyth_elite_greaves_magic_shield") then
		target:RemoveModifierByName("modifier_crimsyth_elite_greaves_armor")
	else
		ability:ApplyDataDrivenModifier(caster, target, "modifier_crimsyth_elite_greaves_armor", {})
	end
end

function berserker_gloves_attack_land(event)

	local attacker = event.attacker
	local ability = event.ability
	local target = event.target
	local caster = event.caster
	if not ability.targetIndex then
		ability.targetIndex = target:GetEntityIndex()
	end
	local heroLevel = attacker:GetLevel()
	local multiplier = 1

	if target:GetEntityIndex() == ability.targetIndex then
	else
		local stack_penalty = ITEM_RPC_BERSERKER_GLOVES_STACKS_PENALTY
		if ability:GetGemValue("ruby") > 0 then
			stack_penalty = ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_BERSERKER_GLOVES_GEM_RUBY)
		end
		multiplier = (100-ITEM_RPC_BERSERKER_GLOVES_STACKS_PENALTY)/100
	end

	ability:ApplyDataDrivenModifier(caster, attacker, "modifier_berserker_gloves_buff_visible", {duration = ITEM_RPC_BERSERKER_GLOVES_DURATION})
	local max_stacks = ITEM_RPC_BERSERKER_GLOVES_MAX_STACKS + ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_BERSERKER_GLOVES_GEM_AMETHYST)
	local newStacks = math.min(math.floor((attacker:GetModifierStackCount("modifier_berserker_gloves_buff_visible", caster) + 1) * multiplier), max_stacks)
	attacker:SetModifierStackCount("modifier_berserker_gloves_buff_visible", caster, newStacks)

	if ability:GetGemValue("sapphire") > 0 then
		ability:ApplyDataDrivenModifier(caster, attacker, "modifier_berserker_gloves_buff_attack_damage", {duration = ITEM_RPC_BERSERKER_GLOVES_DURATION})
		local attack_damage_bonus = newStacks * ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_BERSERKER_GLOVES_GEM_SAPPHIRE)
		attacker:SetModifierStackCount("modifier_berserker_gloves_buff_attack_damage", caster, attack_damage_bonus)
	end

	ability.targetIndex = target:GetEntityIndex()

end

function basilisk_plague_petrify(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	if not target:HasModifier("modifier_basilisk_plague_petrify") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_basilisk_petrify_stacks", {duration = 1})
		local newStacks = target:GetModifierStackCount("modifier_basilisk_petrify_stacks", caster) + 1
		target:SetModifierStackCount("modifier_basilisk_petrify_stacks", caster, newStacks)
		if newStacks >= BASILISK_PLAGUE_TIME_BEFORE_STONE_FORM / BASILISK_PLAGUE_THINK_INTERVAL then
			target:RemoveModifierByName("modifier_basilisk_petrify_stacks")
			local stone_form_duration = BASILISK_PLAGUE_STONE_FORM_DUR + ability:GetFinalGemPropertyValue("sapphire", BASILISK_PLAGUE_SAPPHIRE1)
			ability:ApplyDataDrivenModifier(caster, target, "modifier_basilisk_plague_petrify", {duration = stone_form_duration})
			local pfx = CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_earth_spirit/espirit_magnetize_target.vpcf", target, 3)
			EmitSoundOn("RPC.BasiliskHelm.Petrify", target)
			if ability:GetGemValue("sapphire") > 0 then
				ability:ApplyDataDrivenModifier(caster, caster.hero, "modifier_basilisk_plague_sapphire", {duration = BASILISK_PLAGUE_SAPPHIRE_DURATION})
			end
		end
	end
	if ability:GetGemValue("emerald") > 0 then
		local stacks = target:GetModifierStackCount("modifier_basilisk_plague_emerald_stacks", caster)
		local damage = ability:GetFinalGemPropertyValue("emerald", BASILISK_PLAGUE_EMERALD) * (stacks + 1)
		Filters:ApplyItemDamage(target, caster.hero, damage, DAMAGE_TYPE_PHYSICAL, ability, RPC_ELEMENT_POISON, RPC_ELEMENT_DEMON)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_basilisk_plague_emerald_stacks", {duration = BASILISK_PLAGUE_EMERALD_STACK_DURATION})
		local new_stacks = math.min(stacks + 1, BASILISK_PLAGUE_EMERALD_MAX_STACKS)
		target:SetModifierStackCount("modifier_basilisk_plague_emerald_stacks", caster, new_stacks)
	end
end

function basilisk_plague_poison_start(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	if ability:GetGemValue("ruby") > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_basilisk_plague_ruby_as_loss", {})
		target:SetModifierStackCount("modifier_basilisk_plague_ruby_as_loss", caster, ability:GetFinalGemPropertyValue("ruby", BASILISK_PLAGUE_RUBY))
	end
end

function doom_summon_think(event)
	local caster = event.caster
	local doomAbility = caster:FindAbilityByName("doomplate_castable_doom")
	--print("IS DOOM THINKING?")
	-- if not caster.caster:HasModifier("modifier_doomplate_doom_debuff") then

	-- end
	if doomAbility:IsFullyCastable() then
		--print("IS FULLY CASTABLE?")
		local newOrder = {
			UnitIndex = caster:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			TargetIndex = caster.caster:entindex(),
			AbilityIndex = doomAbility:entindex(),
		}

		ExecuteOrderFromTable(newOrder)
	end

	if doomAbility:GetCooldownTimeRemaining() > 0 then
		local dmg = caster.OverflowProtectedGetAverageTrueAttackDamage(caster) * 2
		dmg = Filters:AdjustItemDamage(caster.caster, dmg, nil)
		Filters:SetAttackDamage(caster, dmg)
		caster:SetTeam(caster.caster:GetTeamNumber())
		caster:SetAcquisitionRange(0)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local fv = ((enemies[1]:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
			doomplate_pyroblast_fire(caster, event.ability, fv)
		else
			local blinkAbility = caster:FindAbilityByName("doomplate_blink_ability")
			if blinkAbility:IsFullyCastable() then
				local enemiesBlink = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 690, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
				if #enemiesBlink > 0 then
					local castPoint = enemiesBlink[1]:GetAbsOrigin() + RandomVector(200)
					local newOrder = {
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
						AbilityIndex = blinkAbility:entindex(),
						Position = castPoint
					}
					ExecuteOrderFromTable(newOrder)
					return
				end
			end
			caster:SetAcquisitionRange(2000)
			local enemies2 = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			if #enemies2 == 0 then
				caster:MoveToPosition(caster.caster:GetAbsOrigin() + RandomVector(400))
			else
			end
		end
	else
		caster:SetTeam(DOTA_TEAM_NEUTRALS)
		caster:SetAcquisitionRange(2000)
	end
end

function doomplate_pyroblast_fire(caster, ability, fv)
	local casterOrigin = caster:GetAbsOrigin()
	-- StartSoundEvent("RPCItem.Doomplate.PyroFrenzyLP", caster)
	--   Timers:CreateTimer(1.5,
	--   function()
	-- StopSoundEvent("RPCItem.Doomplate.PyroFrenzyLP", caster)
	--   end)
	local start_radius = 180
	local end_radius = 180
	local range = 2400
	local speed = 750
	local info =
	{
		Ability = ability,
		EffectName = "particles/econ/items/puck/puck_alliance_set/pyroblast_aproset.vpcf",
		vSpawnOrigin = casterOrigin,
		fDistance = range,
		fStartRadius = start_radius,
		fEndRadius = end_radius,
		Source = caster,
		StartPosition = "attach_origin",
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = true,
		vVelocity = fv * speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
end

function doomplate_pyroblast_impact(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)
	Filters:ApplyItemDamage(target, caster, damage, DAMAGE_TYPE_PURE, ability, RPC_ELEMENT_FIRE, RPC_ELEMENT_DEMON)
end

function doomplate_pyroblast_impact_main(event)
	local ability = event.ability
	local caster = event.caster.caster
	local target = event.target
	EmitSoundOn("RPCItem.Doomplate.PyroImpact", target)
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 280, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:ApplyItemDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_FIRE, RPC_ELEMENT_DEMON)
		end
	end
end

function doom_blink(event)
	local caster = event.caster
	local point = event.target_points[1]

	EmitSoundOn("RPCItem.Doomplate.Blink", caster)

	StartAnimation(caster, {duration = 1, activity = ACT_DOTA_TELEPORT_END, rate = 1.0})
	local particleName = "particles/econ/events/ti6/blink_dagger_start_ti6_lvl2.vpcf"
	local pfx1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx1, 0, caster:GetAbsOrigin())
	local newPosition = point
	FindClearSpaceForUnit(caster, newPosition, false)
	local pfx2 = ParticleManager:CreateParticle("particles/econ/events/ti6/blink_dagger_end_ti6.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx2, 0, newPosition)
	Timers:CreateTimer(4, function()
		ParticleManager:DestroyParticle(pfx1, false)
		ParticleManager:DestroyParticle(pfx2, false)
	end)
end

function doomplate_doom_die(event)
	local caster = event.caster
	local ability = event.ability
	local target = caster.caster
	target:RemoveModifierByName("modifier_doom_bringer_doom")
	target:RemoveModifierByName("modifier_doomplate_cooldown")
end

function cobalt_serenity_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	ability:ApplyDataDrivenModifier(caster, target, "modifier_cobalt_serenity_health_regen", {})
	local healthRegenStacks = target:GetIntellect() * ITEM_RPC_COBALT_SERENITY_RING_INT_TO_HP_REGEN
	target:SetModifierStackCount("modifier_cobalt_serenity_health_regen", caster, healthRegenStacks)
	if ability:GetGemValue("amethyst") > 0 then
		local mana_regen_stacks = target:GetIntellect()*ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_COBALT_SERENITY_RING_GEM_AMETHYST)/0.1
		ability:ApplyDataDrivenModifier(caster, target, "modifier_cobalt_serenity_amethyst_mana_regen", {})
		target:SetModifierStackCount("modifier_cobalt_serenity_amethyst_mana_regen", caster, mana_regen_stacks)
	end
end

function revenant_claw_start(event)
	local ability = event.ability
	if not ability.pfxTable then
		ability.pfxTable = {}
	end
end

function revenant_claw_end(event)
	local ability = event.ability
	for i = 1, #ability.pfxTable, 1 do
		if not IsValidEntity(ability.pfxTable[i][3]) then
			ParticleManager:DestroyParticle(ability.pfxTable[i][2], false)
		else
			if ability.pfxTable[i][3]:HasModifier("modifier_ethereal_revenant_link") then
				ability.pfxTable[i][3]:RemoveModifierByName("modifier_ethereal_revenant_link")
				ParticleManager:DestroyParticle(ability.pfxTable[i][2], false)
			else
				ParticleManager:DestroyParticle(ability.pfxTable[i][2], false)
			end
		end
	end
end

function ethereal_revenant_attack_land(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	local hero = caster.hero
	if ability:GetGemValue("sapphire") > 0 then
		local proc = Filters:GetProc(caster, ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_CLAWS_OF_THE_ETHEREAL_REVENANT_GEM_SAPPHIRE))
		if proc then
			local link_duration = ITEM_RPC_CLAWS_OF_THE_ETHEREAL_REVENANT_DURATION + ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_CLAWS_OF_THE_ETHEREAL_REVENANT_GEM_AMETHYST1)
			ability:ApplyDataDrivenModifier(caster, target, "modifier_ethereal_revenant_link", {duration = link_duration})
		end
	end
	ethereal_update_atk_power(hero, ability)
end

function ethereal_revenant_start(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
	EmitSoundOn("RPCItem.EtherealRevenant.Start", target)
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_static_link.vpcf", PATTACH_CUSTOMORIGIN, hero)
	ParticleManager:SetParticleControlEnt(pfx, 0, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	target.revenantData = {hero:GetEntityIndex(), pfx, target}
	if not ability.pfxTable then
		ability.pfxTable = {}
	end
	table.insert(ability.pfxTable, target.revenantData)
	ethereal_update_atk_power(hero, ability)
end

function ethereal_revenant_think(event)
	local target = event.target
	local ability = event.ability
	if not ability.pfxTable then
		return false
	end
	local caster = event.caster
	local hero = caster.hero
	local newpfxTable = {}
	for i = 1, #ability.pfxTable, 1 do
		if not IsValidEntity(ability.pfxTable[i][3]) then
			ParticleManager:DestroyParticle(ability.pfxTable[i][2], false)
		else
			if ability.pfxTable[i][3]:HasModifier("modifier_ethereal_revenant_link") then
				table.insert(newpfxTable, ability.pfxTable[i])
			else
				ParticleManager:DestroyParticle(ability.pfxTable[i][2], false)
			end
		end
	end
	ability.pfxTable = newpfxTable
	ethereal_update_atk_power(hero, ability)
end

function ethereal_revenant_end(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
	EmitSoundOn("RPCItem.EtherealRevenant.End", target)

	ParticleManager:DestroyParticle(target.revenantData[2], false)
	target.revenantData = nil
	ethereal_update_atk_power(hero, ability)
end

function ethereal_update_atk_power(caster, ability)
	if ability:GetGemValue("ruby") > 0 then
		if #ability.pfxTable > 0 then
			ability:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_ethereal_revenant_link_attack_power", {})
			caster:SetModifierStackCount("modifier_ethereal_revenant_link_attack_power", caster.InventoryUnit, ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_CLAWS_OF_THE_ETHEREAL_REVENANT_GEM_RUBY2)*#ability.pfxTable)
		else
			caster:RemoveModifierByName("modifier_ethereal_revenant_link_attack_power")
		end
	end
end

function crimson_skull_cap_kill(event)
	local caster = event.caster.hero
	local target = event.unit
	local ability = event.ability
	local damage = target:GetMaxHealth() * (CRIMSON_SKULL_CAP_HP_PCT_TO_DAMAGE/100 + ability:GetFinalGemPropertyValue("ruby", CRIMSON_SKULL_CAP_RUBY)/100)
	local position = GetGroundPosition(target:GetAbsOrigin(), caster)
	skull_cap_explode(caster, ability, target, position, damage)
end

function skull_cap_explode(caster, ability, target, position, damage)
	local radius = CRIMSON_SKULL_CAP_RADIUS + ability:GetFinalGemPropertyValue("emerald", CRIMSON_SKULL_CAP_EMERALD)
	local particleName = "particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particle1, 0, position)
	Timers:CreateTimer(1.2, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
	particleName = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
	local particle2 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particle2, 0, position)
	ParticleManager:SetParticleControl(particle2, 1, Vector(radius, radius, radius))
	ParticleManager:SetParticleControl(particle2, 2, Vector(1.6, 1.6, 1.6))
	ParticleManager:SetParticleControl(particle2, 4, Vector(200, 20, 20))
	Timers:CreateTimer(1.5, function()
		ParticleManager:DestroyParticle(particle2, false)
	end)
	local key = 'skull_cap_explode_sound'
	Util.Common:LimitPerTimeAndPlace(1, 2, target:GetAbsOrigin(), 700, key, function()
		EmitSoundOn("RPCItem.CrimsonSkullCap.Explode", target)
	end)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:ApplyItemDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_NONE)
		end
	end
end

function skull_cap_take_damage(event)
	local ability = event.ability
	local caster = event.caster
	if ability:GetGemValue("sapphire") > 0 then
		local hero = event.unit
		if not hero:HasModifier("modifier_crimson_skull_cap_sapphire_countdown") then
			ability:ApplyDataDrivenModifier(caster, hero, "modifier_crimson_skull_cap_sapphire_countdown", {duration = CRIMSON_SKULL_CAP_SAPPHIRE_COUNTDOWN_TIMER})
		end
	end
end

function skull_cap_sapphire_expire(event)
	local caster = event.caster.hero
	local target = event.unit
	local ability = event.ability
	local damage = caster:GetMaxHealth() * (ability:GetFinalGemPropertyValue("sapphire", CRIMSON_SKULL_CAP_SAPPHIRE)/100)
	local position = GetGroundPosition(caster:GetAbsOrigin(), caster)
	skull_cap_explode(caster, ability, caster, position, damage)
end

function igneous_canine_damage(event)
	local target = event.target
	local caster = event.ability.hero
	local ability = event.ability
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * (IGNEOUS_CANINE_ATTACK_TO_DMG/100) + ability:GetFinalGemPropertyValue("ruby", IGNEOUS_CANINE_RUBY1)*caster:GetStrength()
	Filters:ApplyItemDamage(target, caster, damage, DAMAGE_TYPE_PHYSICAL, ability, RPC_ELEMENT_FIRE, RPC_ELEMENT_EARTH)
end



function hurricane_vest_hit(event)
	local target = event.target
	local ability = event.ability
	local hero = ability.caster
	local caster = hero.InventoryUnit

	local atk_damage_mult = (ITEM_RPC_HURRICANE_VEST_DAMAGE_ATTACK_PWR_PCT + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_HURRICANE_VEST_RUBY2))/100
	local damage = atk_damage_mult*OverflowProtectedGetAverageTrueAttackDamage(hero) + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_HURRICANE_VEST_GEM_EMERALD1)*hero:GetAgility() + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_HURRICANE_VEST_GEM_SAPPHIRE2)
	Filters:ApplyItemDamage(target, hero, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_WIND, RPC_ELEMENT_NONE)

	if ability:GetGemValue("sapphire") > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_hurricane_vest_slow", {duration = ITEM_RPC_HURRICANE_VEST_SAPPHIRE_SLOW_DURATION})
		target:SetModifierStackCount("modifier_hurricane_vest_slow", caster, ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_HURRICANE_VEST_GEM_SAPPHIRE1))
	end


end

function new_ruby_dragon_think(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	if not ability.interval then
		ability.interval = 0
	end
	ability.interval = ability.interval + 1
	if caster:HasModifier("ruby_dragon_cinematic") then
		return false
	end
	if ability.interval % 2 == 1 then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), hero:GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			caster:MoveToPosition(enemies[1]:GetAbsOrigin() + RandomVector(120))
		else
			caster:MoveToPosition(hero:GetAbsOrigin() + RandomVector(420))
		end
	end
	if ability.interval % 2 == 0 then
		local fv = caster:GetForwardVector()
		StartAnimation(caster, {duration = 1, activity = ACT_DOTA_ATTACK, rate = 1.2})
		local projectileParticle = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf"
		local info =
		{
			Ability = ability,
			EffectName = projectileParticle,
			vSpawnOrigin = caster:GetAbsOrigin() + Vector(0, 0, 120),
			fDistance = RUBY_DRAGON_DISTANCE,
			fStartRadius = 180,
			fEndRadius = 350,
			Source = caster,
			StartPosition = "attach_origin",
			bHasFrontalCone = true,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 5.0,
			bDeleteOnHit = false,
			vVelocity = fv * RUBY_DRAGON_DISTANCE,
			bProvidesVision = false,
		}
		EmitSoundOn("Creature.FireBreath.Cast", caster)
		projectile = ProjectileManager:CreateLinearProjectile(info)
	end
	if ability.interval == RUBY_DRAGON_DURATION then
		ability:ApplyDataDrivenModifier(caster, caster, "ruby_dragon_cinematic", {duration = 1.5})
		caster.entering = false
		Timers:CreateTimer(1.5, function()
			caster:RemoveModifierByName("ruby_dragon_cinematic")
			UTIL_Remove(caster)
		end)
	end
end

function ruby_dragon_flame_impact(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	local damage = hero:GetStrength() * RUBY_DRAGON_IMPACT_DMG_PER_STR
	local target = event.target
	Damage:Apply({
		attacker = hero,
		victim = target,
		source = ability,
		sourceType = BASE_ITEM,
		damage = damage,
		damageType = DAMAGE_TYPE_MAGICAL,
		elements = {
			RPC_ELEMENT_FIRE
		}
	})
	hero.headItem:ApplyDataDrivenModifier(hero.InventoryUnit, target, "ruby_dragon_burn", {duration = RUBY_DRAGON_TICK_DURATION})
	local modifier = target:FindModifierByName('ruby_dragon_burn')
	Util.Modifier:SetIndependentlyStacks(hero, target, modifier, 1, RUBY_DRAGON_TICK_DURATION)
end

function ruby_dragon_flame_think(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	local target = event.target
	local burnDamage = hero:GetStrength() * RUBY_DRAGON_TICK_DMG_PER_STR
	local stacksCount = target:FindModifierByName('ruby_dragon_burn'):GetStackCount()
	for i = 1, stacksCount do
		Damage:Apply({
			attacker = hero,
			victim = target,
			source = ability,
			sourceType = BASE_ITEM,
			damage = burnDamage,
			damageType = DAMAGE_TYPE_MAGICAL,
			elements = {
				RPC_ELEMENT_FIRE
			},
			dot = true
		})
	end
end

function tiny_avalanche_think(event)
	local target = event.target
	local ability = event.ability
	ParticleManager:SetParticleControl(ability.pfx, 0, target:GetAbsOrigin())
	local radius = ITEM_RPC_AVALANCHE_PLATE_AVALANCHE_RADIUS + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_AVALANCHE_PLATE_GEM_SAPPHIRE1)
	local enemies = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		local mult = ITEM_RPC_AVALANCHE_PLATE_AVALANCHE_STR_TO_DMG
		local damage = target:GetStrength() * mult + ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_AVALANCHE_PLATE_GEM_AMETHYST)
		for _, enemy in pairs(enemies) do
			Filters:ApplyItemDamage(enemy, target, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_EARTH, RPC_ELEMENT_NONE)
			Filters:ApplyStun(target, ITEM_RPC_AVALANCHE_PLATE_STUN_DUR, enemy)
		end
	end
end

function avalanche_end(event)
	local caster = event.caster.hero
	local ability = event.ability
	if ability:GetGemValue("ruby") > 0 then
		local radius = (ITEM_RPC_AVALANCHE_PLATE_AVALANCHE_RADIUS + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_AVALANCHE_PLATE_GEM_SAPPHIRE1))*ITEM_RPC_AVALANCHE_PLATE_RUBY_EARTHQUAKE_RADIUS_MULT

		local splitEarthParticle = "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf"
		local position = caster:GetAbsOrigin()
		local pfx = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, position)
		ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
		Timers:CreateTimer(4, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "RPCItem.Avalanche2Quake", caster)
		local damage = caster:GetStrength() * ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_AVALANCHE_PLATE_GEM_RUBY1)
		local stun_duration = ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_AVALANCHE_PLATE_GEM_RUBY2)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				Filters:ApplyItemDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, nil, RPC_ELEMENT_EARTH, RPC_ELEMENT_NONE)
				Filters:ApplyStun(caster, stun_duration, enemy)
			end
		end
	end

end



function seraphic_soul_hit(event)
	local ability = event.ability

	local hero = ability.hero

	local target = event.target

	local damage = (hero:GetStrength() + hero:GetAgility() + hero:GetIntellect() + hero:GetSpirit()) * ITEM_RPC_SERAPHIC_SOULVEST_ALL_ATTRS_PCT/100
	if target:IsAlive() then
		EmitSoundOn("RPCItem.SoulVestImpact", target)
		Filters:ApplyItemDamage(target, hero, damage, DAMAGE_TYPE_PURE, ability, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
	end
	if ability:GetGemValue("sapphire") > 0 then
		local aoe_damage = damage * (ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_SERAPHIC_SOULVEST_GEM_SAPPHIRE1)/100)
		local radius = ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_SERAPHIC_SOULVEST_GEM_SAPPHIRE2)
		local enemies = FindUnitsInRadius(hero:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				Filters:ApplyItemDamage(enemy, hero, aoe_damage, DAMAGE_TYPE_PURE, ability, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
			end
		end
		local particle = ParticleManager:CreateParticle("particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf", PATTACH_WORLDORIGIN, target)
		ParticleManager:SetParticleControl(particle, 0, event.target:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 1, Vector(radius, radius, radius))
		ParticleManager:SetParticleControl(particle, 2, Vector(1.2, 1.2, 1.2))
		ParticleManager:SetParticleControl(particle, 4, Vector(215, 215, 215))
		Timers:CreateTimer(1.5, function()
			ParticleManager:DestroyParticle(particle, false)
		end)
	end
end

function doomplate_doom_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	StartSoundEvent("RPCItem.DoomPlate.Doom", target)
end

function doomplate_doom_end(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	StopSoundEvent("RPCItem.DoomPlate.Doom", target)
end

function baron_storm_take_damage(event)
	local caster = event.caster.hero
	local ability = event.ability
	local attacker = event.attacker
	local proc_chance = ITEM_RPC_BARONS_STORM_ARMOR_CHANCE + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_BARONS_STORM_ARMOR_GEM_RUBY)/100
	local proc = Filters:GetProc(caster, proc_chance)
	if proc then
        local limitKey = "_barons_storm"
        local max_procs_per_second = ITEM_RPC_BARONS_STORM_ARMOR_MAX_PROCS_PER_SECOND + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_BARONS_STORM_ARMOR_GEM_EMERALD1)
        local max_bounces = ITEM_RPC_BARONS_STORM_ARMOR_MAX_TARGETS + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_BARONS_STORM_ARMOR_GEM_EMERALD2)
        Util.Common:LimitPerTime(max_procs_per_second, 1, limitKey, function()
			local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * ITEM_RPC_BARONS_STORM_ARMOR_DMG_PER_ATT/100 + ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_BARONS_STORM_ARMOR_GEM_AMETHYST)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_baron_storm_cooldown", {duration = 0.2})
			baron_storm_arc(attacker, caster, ability, damage, 0, max_bounces)
        end)

	end
end

function baron_storm_arc(target, caster, ability, damage, targetNumber, maxTargets)
	if IsValidEntity(target) then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, ITEM_RPC_BARONS_STORM_ARMOR_SEARCH_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false)
		if #enemies > 0 then
			local newTarget = enemies[1]
			if targetNumber ~= 0 then
				if newTarget == target then
					newTarget = enemies[2]
				end
			else
				newTarget = target
				target = caster
			end
			if newTarget then
				if ability:GetGemValue("sapphire") > 0 then
					local paralyze_duration = ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_BARONS_STORM_ARMOR_GEM_SAPPHIRE)
					ability:ApplyDataDrivenModifier(caster, newTarget, "modifier_baron_storm_link", {duration = paralyze_duration})
				end
				Filters:ApplyItemDamage(newTarget, caster, damage, DAMAGE_TYPE_PHYSICAL, ability, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
				EmitSoundOn("Hero_Zuus.ArcLightning.Target", target)
				local particleName = "particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf"
				local targetPos = target:GetAbsOrigin()
				local newTargetPos = newTarget:GetAbsOrigin()
				local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, target)
				ParticleManager:SetParticleControl(lightningBolt, 0, Vector(targetPos.x, targetPos.y, targetPos.z + target:GetBoundingMaxs().z))
				ParticleManager:SetParticleControl(lightningBolt, 1, Vector(newTargetPos.x, newTargetPos.y, newTargetPos.z + newTarget:GetBoundingMaxs().z))
				targetNumber = targetNumber + 1
				if targetNumber <= maxTargets then
					Timers:CreateTimer(0.2, function()
						baron_storm_arc(newTarget, caster, ability, damage, targetNumber, maxTargets)
					end)
				end
			end
		end
	end
end

function samurai_helmet_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, target, "modifier_samurai_damage", {})
	target:SetModifierStackCount("modifier_samurai_damage", caster, target:GetLevel())
end

function temporal_warp_boots_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	if ability:GetGemValue("ruby") > 0 then
		local important_interval = ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_TEMPORAL_WARP_BOOTS_GEM_RUBY)*10
		if not ability.interval then
			ability.interval = 0
			ability.dataTable = {}
		end
		ability.interval = ability.interval + 1
		local timeData = {target:GetMana(), target:GetHealth(), target:GetAbsOrigin(), target:GetAbilityByIndex(DOTA_Q_SLOT):GetCooldownTimeRemaining(), target:GetAbilityByIndex(DOTA_W_SLOT):GetCooldownTimeRemaining(), target:GetAbilityByIndex(DOTA_R_SLOT):GetCooldownTimeRemaining()}
		if #ability.dataTable <= important_interval then
			table.insert(ability.dataTable, timeData)
		else
			ability.dataTable[ability.interval] = timeData
		end
		-- ability.mana = target:GetMana()
		-- ability.health = target:GetHealth()
		-- ability.position = target:GetAbsOrigin()
		-- ability.cooldownA = target:GetAbilityByIndex(DOTA_Q_SLOT):GetCooldownTimeRemaining()
		-- ability.cooldownB = target:GetAbilityByIndex(DOTA_W_SLOT):GetCooldownTimeRemaining()
		-- ability.cooldownD = target:GetAbilityByIndex(DOTA_D_SLOT):GetCooldownTimeRemaining()
		if ability.interval == important_interval then
			ability.interval = 0
		end
	end
end

function wind_orchid_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local base_agi_bonus = target:GetRuneValue("e", 4)*ITEM_RPC_WIND_ORCHID_AGI_PER_E4
	local agi_bonus_from_gems = target:GetRuneValue("e", 1)*ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_WIND_ORCHID_GEM_RUBY) + target:GetRuneValue("e", 2)*ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_WIND_ORCHID_GEM_SAPPHIRE) + target:GetRuneValue("e", 3)*ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_AQUA_LILY_GEM_AMETHYST)
	local total_agi = base_agi_bonus + agi_bonus_from_gems
	if total_agi > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_wind_orchid_agility_bonus", {})
		target:SetModifierStackCount("modifier_wind_orchid_agility_bonus", caster, total_agi)
	else
		target:RemoveModifierByName("modifier_wind_orchid_agility_bonus")
	end
end

function aqua_lily_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local base_int_bonus = target:GetRuneValue("r", 4)*ITEM_RPC_AQUA_LILY_INT_PER_R4
	local int_bonus_from_gems = target:GetRuneValue("r", 1)*ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_AQUA_LILY_GEM_RUBY) + target:GetRuneValue("r", 2)*ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_AQUA_LILY_GEM_EMERALD) + target:GetRuneValue("r", 3)*ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_AQUA_LILY_GEM_AMETHYST)
	local total_int = base_int_bonus + int_bonus_from_gems
	if total_int > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_aqua_lily_intelligence_bonus", {})
		target:SetModifierStackCount("modifier_aqua_lily_intelligence_bonus", caster, total_int)
	else
		target:RemoveModifierByName("modifier_aqua_lily_intelligence_bonus")
	end
end

function fire_blossom_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster

	local base_str_bonus = target:GetRuneValue("w", 4)*ITEM_RPC_FIRE_BLOSSOM_STR_PER_W4
	local str_bonus_from_gems = target:GetRuneValue("w", 1)*ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_FIRE_BLOSSOM_GEM_SAPPHIRE) + target:GetRuneValue("w", 2)*ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_FIRE_BLOSSOM_GEM_EMERALD) + target:GetRuneValue("w", 3)*ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_FIRE_BLOSSOM_GEM_AMETHYST)
	local total_str = base_str_bonus + str_bonus_from_gems
	if total_str > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_fire_blossom_strength_bonus", {})
		target:SetModifierStackCount("modifier_fire_blossom_strength_bonus", caster, total_str)
	else
		target:RemoveModifierByName("modifier_fire_blossom_strength_bonus")
	end
end

function blue_rain_attack_land(event)
	local attacker = event.attacker
	local ability = event.ability
	local caster = attacker
	local target = event.target

	local proc_chance = ITEM_RPC_BLUE_RAIN_GAUNTLET_CHANCE + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_BLUE_RAIN_GAUNTLET_GEM_EMERALD1)
	local max_procs_per_second = ITEM_RPC_BLUE_RAIN_GAUNTLET_MAX_PROCS_PER_SEC + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_BLUE_RAIN_GAUNTLET_GEM_EMERALD2)
	local limitKey = caster:GetPlayerOwnerID() .. '_blue_rain_procs'
	
	local proc = Filters:GetProc(caster, proc_chance)
	if proc then
		Util.Common:LimitPerTime(max_procs_per_second, 1, limitKey, function()
			local endFV = ((target:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
			EmitSoundOn("RPCItem.BlueRain", target)
			Filters:BlueRainLance(caster, ability, endFV, 1)
		end)
	end
end

function shadowflame_fist_think(event)	
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	if ability:GetGemValue("emerald") > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_shadowflame_fist_base_attack", {})
		local attack_damage = (hero:GetMaxMana() - hero:GetMana()) * ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_SHADOWFLAME_FIST_GEM_EMERALD)
		hero:SetModifierStackCount("modifier_shadowflame_fist_base_attack", caster, attack_damage)
	end
	if ability:GetGemValue("sapphire") > 0 then
		local cap_percentage = ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_SHADOWFLAME_FIST_GEM_SAPPHIRE1)
		if hero:GetMana() > hero:GetMaxMana() * cap_percentage/100 then
			hero:SetMana(hero:GetMaxMana() * cap_percentage/100)
		end
	end
end

function shadowflame_fist_attack_land(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	if not ability.flames_table then
		ability.flames_table = {}
	end
	local target = event.target

	local max_flames = ITEM_RPC_SHADOWFLAME_FIST_MAX_FLAMES + ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_SHADOWFLAME_FIST_GEM_AMETHYST1)
	
	local create_flame = true
	local allies = FindUnitsInRadius(hero:GetTeamNumber(), target:GetAbsOrigin(), nil, 120, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #allies > 0 then
		for _, ally in pairs(allies) do
			if ally:HasModifier("modifier_shadowflame_thinker") then
				create_flame = false
			end
		end
	end
	if create_flame then
		local fireThinker = CreateUnitByName("npc_dummy_unit", target:GetAbsOrigin(), false, nil, nil, caster:GetTeamNumber())
		fireThinker:FindAbilityByName("dummy_unit"):SetLevel(1)

		fireThinker:SetDayTimeVisionRange(100)
		fireThinker:SetNightTimeVisionRange(100)

		local pfx = ParticleManager:CreateParticle("particles/roshpit/items/shadowflame_fist.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, fireThinker:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 11, Vector(0.3, 0.3, 0.3))
		fireThinker.pfx = pfx
		table.insert(ability.flames_table, fireThinker)	

		ability:ApplyDataDrivenModifier(caster, fireThinker, "modifier_shadowflame_thinker", {duration = ITEM_RPC_SHADOWFLAME_FIST_ROOT_DURATION})
		if #ability.flames_table > max_flames then
			ability.flames_table[1]:RemoveModifierByName("modifier_shadowflame_thinker")
		end
		reindex_shadowflame_table(ability)
	end
end

function reindex_shadowflame_table(ability)
	local new_flame_table = {}
	for i = 1, #ability.flames_table, 1 do
		if ability.flames_table[i] and IsValidEntity(ability.flames_table[i]) and ability.flames_table[i]:HasModifier("modifier_shadowflame_thinker") then
			table.insert(new_flame_table, ability.flames_table[i])
		end
	end
	ability.flames_table = new_flame_table
end

function shadowflame_thinker_end(event)
	local ability = event.ability
	ParticleManager:DestroyParticle(event.target.pfx, false)
	ParticleManager:ReleaseParticleIndex(event.target.pfx)
	UTIL_Remove(event.target)
	reindex_shadowflame_table(ability)
end

function inside_shadowflame_think(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	local target = event.target
	local damage = OverflowProtectedGetAverageTrueAttackDamage(hero)*(ITEM_RPC_SHADOWFLAME_FIST_ATK_DMG_PCT/100) + ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_SHADOWFLAME_FIST_GEM_AMETHYST2)
	Filters:ApplyItemDamage(target, hero, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_SHADOW, RPC_ELEMENT_FIRE)
end

function flamethrower_init(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	ability.interval = -4
	ability.rising = true
	ability.damage = OverflowProtectedGetAverageTrueAttackDamage(target) * (BURNING_SPIRIT_ATTACK_TO_DAMAGE + ability:GetFinalGemPropertyValue("emerald", BURNING_SPIRIT_EMERALD1))/100
	ability.origCaster = target
	flamethrower_thinking(event)
end

function flamethrower_thinking(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local fv = target:GetForwardVector()
	local rotatedFV = WallPhysics:rotateVector(fv, 2 * math.pi * ability.interval / 40)
	if ability.rising then
		ability.interval = ability.interval + 1
		if ability.interval == 4 then
			ability.rising = false
		end
	else
		ability.interval = ability.interval - 1
		if ability.interval == -4 then
			ability.rising = true
		end
	end

	local start_radius = 120
	local end_radius = 200
	local range = 900
	local speed = 1000

	local projectileParticle = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf"

	local info =
	{
		Ability = ability,
		EffectName = projectileParticle,
		vSpawnOrigin = target:GetAbsOrigin() + rotatedFV * 30 + Vector(0, 0, 80),
		fDistance = range,
		fStartRadius = start_radius,
		fEndRadius = end_radius,
		Source = caster,
		StartPosition = "attach_origin",
		bHasFrontalCone = true,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
		vVelocity = rotatedFV * speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)

end

function burning_spirit_helmet_attack_land(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local hero = event.attacker
	if ability:GetGemValue("sapphire") > 0 then
		local proc = Filters:GetProc(hero, ability:GetFinalGemPropertyValue("sapphire", BURNING_SPIRIT_SAPPHIRE1))
		if proc then
			ability.origCaster = hero
			if not ability.damage then 
				ability.damage = OverflowProtectedGetAverageTrueAttackDamage(hero) * (BURNING_SPIRIT_ATTACK_TO_DAMAGE + ability:GetFinalGemPropertyValue("emerald", BURNING_SPIRIT_EMERALD1))/100	
			end
			local start_radius = 120
			local end_radius = 200
			local range = WallPhysics:GetDistance2d(hero:GetAbsOrigin(), target:GetAbsOrigin()) + ability:GetFinalGemPropertyValue("sapphire", BURNING_SPIRIT_SAPPHIRE2)
			local speed = 1000
			local fv = ((target:GetAbsOrigin() - hero:GetAbsOrigin())*Vector(1,1,0)):Normalized()
			local projectileParticle = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf"

			local info =
			{
				Ability = ability,
				EffectName = projectileParticle,
				vSpawnOrigin = target:GetAbsOrigin() + Vector(0, 0, 80),
				fDistance = range,
				fStartRadius = start_radius,
				fEndRadius = end_radius,
				Source = caster,
				StartPosition = "attach_origin",
				bHasFrontalCone = true,
				bReplaceExisting = false,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				fExpireTime = GameRules:GetGameTime() + 5.0,
				bDeleteOnHit = false,
				vVelocity = fv * speed,
				bProvidesVision = false,
			}
			projectile = ProjectileManager:CreateLinearProjectile(info)
		end
	end
end

function flamethrower_impact(event)
	local target = event.target
	local ability = event.ability

	local cdReduction = ability:GetFinalGemPropertyValue("amethyst", BURNING_SPIRIT_AMETHYST)

	Filters:ApplyItemDamage(target, ability.origCaster, ability.damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
	if cdReduction > 0 then
		local ulti = ability.origCaster:GetAbilityByIndex(DOTA_R_SLOT)
		local currentCD = ulti:GetCooldownTimeRemaining()
		ulti:EndCooldown()
		ulti:StartCooldown(currentCD - cdReduction)
	end
end

function demonfire_attack_land(event)
	local caster = event.caster
	local hero = event.attacker
	local ability = event.ability

	ability:ApplyDataDrivenModifier(caster, hero, "modifier_demonfire_stack", {duration = ITEM_RPC_DEMONFIRE_GAUNTLET_STACK_DURATION})
	local max_stacks = ITEM_RPC_DEMONFIRE_GAUNTLET_STACKS + ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_DEMONFIRE_GAUNTLET_GEM_AMETHYST)
	local newStacks = math.min(hero:GetModifierStackCount("modifier_demonfire_stack", caster) + 1, max_stacks)
	hero:SetModifierStackCount("modifier_demonfire_stack", caster, newStacks)
	ability.stacks = newStacks
	if ability:GetGemValue("ruby") > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_demonfire_ruby_attack_damage", {duration = ITEM_RPC_DEMONFIRE_GAUNTLET_STACK_DURATION})
		local damage_stacks = ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_DEMONFIRE_GAUNTLET_GEM_RUBY1)*ability.stacks
		hero:SetModifierStackCount("modifier_demonfire_ruby_attack_damage", caster, damage_stacks)
	end
	if ability:GetGemValue("sapphire") > 0 and ability.stacks > 0 then
		local proc = Filters:GetProc(hero, ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_DEMONFIRE_GAUNTLET_GEM_SAPPHIRE))
		if proc then
			EmitSoundOnLocationWithCaster(hero:GetAbsOrigin(), "RPCItem.Demonfire", hero)
			demonfire_beam(event.target, hero, ability)
		end
	end
end

function demonfire_end(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local enemies = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, ITEM_RPC_DEMONFIRE_GAUNTLET_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false)
	local maxTargets = ITEM_RPC_DEMONFIRE_GAUNTLET_NUMBER_ENEMIES + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_DEMONFIRE_GAUNTLET_GEM_EMERALD1)
	local currentTargets = 0
	local damage = ability.stacks * OverflowProtectedGetAverageTrueAttackDamage(target) * (ITEM_RPC_DEMONFIRE_GAUNTLET_DAMAGE_PER_ATTACK_PER_STACK/100) + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_DEMONFIRE_GAUNTLET_GEM_EMERALD2)*ability.stacks
	if #enemies > 0 then
		EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "RPCItem.Demonfire", target)
		for _, enemy in pairs(enemies) do
			demonfire_beam(enemy, target, ability)
			currentTargets = currentTargets + 1
			if currentTargets == maxTargets then
				break
			end
		end
	end
	ability.stacks = 0
end

function demonfire_beam(enemy, hero, ability)
	local damage = ability.stacks * OverflowProtectedGetAverageTrueAttackDamage(hero) * (ITEM_RPC_DEMONFIRE_GAUNTLET_DAMAGE_PER_ATTACK_PER_STACK/100) + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_DEMONFIRE_GAUNTLET_GEM_EMERALD2)*ability.stacks
	Filters:ApplyItemDamage(enemy, hero, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_DEMON, RPC_ELEMENT_FIRE)

	local dagon_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lion/lion_spell_finger_of_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
	ParticleManager:SetParticleControlEnt(dagon_particle, 0, hero, PATTACH_POINT_FOLLOW, "attach_attack1", hero:GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(dagon_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), false)
	local particle_effect_intensity = 700
	ParticleManager:SetParticleControl(dagon_particle, 2, Vector(particle_effect_intensity, particle_effect_intensity, particle_effect_intensity))
	Timers:CreateTimer(2.0, function()
		ParticleManager:DestroyParticle(dagon_particle, false)
		ParticleManager:ReleaseParticleIndex(dagon_particle)
	end)
end

function lobster_claw_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	local max_stacks = ITEM_RPC_CHITINOUS_LOBSTER_CLAW_MAX_STACKS + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_CHITINOUS_LOBSTER_CLAW_GEM_RUBY)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_chitinous_skin_stack", {})
	local newStacks = math.min(target:GetModifierStackCount("modifier_chitinous_skin_stack", caster) + 1, max_stacks)
	target:SetModifierStackCount("modifier_chitinous_skin_stack", caster, newStacks)
end

function shark_helmet_attack_land(event)
	local caster = event.caster
	local attacker = event.attacker
	local ability = event.ability

	if not attacker:HasModifier("modifier_dark_reef_shark_effect") then
		ability:ApplyDataDrivenModifier(caster, attacker, "modifier_dark_reef_shark_stacks", {duration = DARK_REEF_SHARK_HELMET_PASSIVE_DURATION})
	end
	local extra_stack = 0
	if ability:GetGemValue("emerald") > 0 then
		local proc = Filters:GetProc(attacker, ability:GetFinalGemPropertyValue("emerald", DARK_REEF_SHARK_EMERALD))
		if proc then
			extra_stack = extra_stack + 1
		end
	end
	local newStacks = attacker:GetModifierStackCount("modifier_dark_reef_shark_stacks", caster) + 1 + extra_stack
	if newStacks >= DARK_REEF_SHARK_HELMET_NUMBER_OF_ATTACKS then
		attacker:RemoveModifierByName("modifier_dark_reef_shark_stacks")
		local buff_duration = DARK_REEF_SHARK_HELMET_ACTIVE_DURATION + ability:GetFinalGemPropertyValue("amethyst", DARK_REEF_SHARK_AMETHYST)
		ability:ApplyDataDrivenModifier(caster, attacker, "modifier_dark_reef_shark_effect", {duration = buff_duration})
		CustomAbilities:QuickAttachParticle("particles/roshpit/items/shark_helmet.vpcf", attacker, 1)
		EmitSoundOn("RPCItem.SharkHelmet.Activate", attacker)
	else
		attacker:SetModifierStackCount("modifier_dark_reef_shark_stacks", caster, newStacks)
	end
end

function sunrise_robe_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	local heroStr = target:GetBaseStrength()
	local heroAgi = target:GetBaseAgility()
	local heroInt = target:GetBaseIntellect()
	local heroSpr = target:GetBaseSpirit()

	if heroStr <= heroAgi and heroStr <= heroInt and heroStr <= heroSpr then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_empyreal_str", {})
		target:SetModifierStackCount("modifier_empyreal_str", caster, heroStr * ITEM_RPC_EMPYREAL_SUNRISE_ROBE_LOWEST_ATT_AMP + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_EMPYREAL_SUNRISE_ROBE_GEM_RUBY))
		target:RemoveModifierByName("modifier_empyreal_agi")
		target:RemoveModifierByName("modifier_empyreal_int")
		target:RemoveModifierByName("modifier_empyreal_spr")
		if ability:GetGemValue("emerald") then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_empyreal_bad", {})
			target:SetModifierStackCount("modifier_empyreal_bad", caster, ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_EMPYREAL_SUNRISE_ROBE_GEM_EMERALD)*target:GetStrength())
		end
		if ability:GetGemValue("sapphire") then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_empyreal_spell_pierce", {})
			target:SetModifierStackCount("modifier_empyreal_spell_pierce", caster, ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_EMPYREAL_SUNRISE_ROBE_GEM_SAPPHIRE)*target:GetStrength())
		end
		if ability:GetGemValue("amethyst") then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_empyreal_magic_armor", {})
			target:SetModifierStackCount("modifier_empyreal_magic_armor", caster, ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_EMPYREAL_SUNRISE_ROBE_GEM_AMETHYST)*target:GetStrength())
		end
	elseif heroAgi <= heroStr and heroAgi <= heroInt and heroAgi <= heroSpr then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_empyreal_agi", {})
		target:SetModifierStackCount("modifier_empyreal_agi", caster, heroAgi * ITEM_RPC_EMPYREAL_SUNRISE_ROBE_LOWEST_ATT_AMP + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_EMPYREAL_SUNRISE_ROBE_GEM_RUBY))
		target:RemoveModifierByName("modifier_empyreal_str")
		target:RemoveModifierByName("modifier_empyreal_int")
		target:RemoveModifierByName("modifier_empyreal_spr")
		if ability:GetGemValue("emerald") then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_empyreal_bad", {})
			target:SetModifierStackCount("modifier_empyreal_bad", caster, ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_EMPYREAL_SUNRISE_ROBE_GEM_EMERALD)*target:GetAgility())
		end
		if ability:GetGemValue("sapphire") then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_empyreal_spell_pierce", {})
			target:SetModifierStackCount("modifier_empyreal_spell_pierce", caster, ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_EMPYREAL_SUNRISE_ROBE_GEM_SAPPHIRE)*target:GetAgility())
		end
		if ability:GetGemValue("amethyst") then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_empyreal_magic_armor", {})
			target:SetModifierStackCount("modifier_empyreal_magic_armor", caster, ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_EMPYREAL_SUNRISE_ROBE_GEM_AMETHYST)*target:GetAgility())
		end
	elseif heroInt <= heroStr and heroInt <= heroAgi and heroInt <= heroSpr then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_empyreal_int", {})
		target:SetModifierStackCount("modifier_empyreal_int", caster, heroInt * ITEM_RPC_EMPYREAL_SUNRISE_ROBE_LOWEST_ATT_AMP + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_EMPYREAL_SUNRISE_ROBE_GEM_RUBY))
		target:RemoveModifierByName("modifier_empyreal_str")
		target:RemoveModifierByName("modifier_empyreal_agi")
		target:RemoveModifierByName("modifier_empyreal_spr")
		if ability:GetGemValue("emerald") then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_empyreal_bad", {})
			target:SetModifierStackCount("modifier_empyreal_bad", caster, ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_EMPYREAL_SUNRISE_ROBE_GEM_EMERALD)*target:GetIntellect())
		end
		if ability:GetGemValue("sapphire") then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_empyreal_spell_pierce", {})
			target:SetModifierStackCount("modifier_empyreal_spell_pierce", caster, ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_EMPYREAL_SUNRISE_ROBE_GEM_SAPPHIRE)*target:GetIntellect())
		end
		if ability:GetGemValue("amethyst") then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_empyreal_magic_armor", {})
			target:SetModifierStackCount("modifier_empyreal_magic_armor", caster, ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_EMPYREAL_SUNRISE_ROBE_GEM_AMETHYST)*target:GetIntellect())
		end
	elseif heroSpr <= heroAgi and heroSpr <= heroStr and heroSpr <= heroInt then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_empyreal_spr", {})
		target:SetModifierStackCount("modifier_empyreal_spr", caster, heroSpr * ITEM_RPC_EMPYREAL_SUNRISE_ROBE_LOWEST_ATT_AMP + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_EMPYREAL_SUNRISE_ROBE_GEM_RUBY))
		target:RemoveModifierByName("modifier_empyreal_str")
		target:RemoveModifierByName("modifier_empyreal_agi")
		target:RemoveModifierByName("modifier_empyreal_int")
		if ability:GetGemValue("emerald") then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_empyreal_bad", {})
			target:SetModifierStackCount("modifier_empyreal_bad", caster, ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_EMPYREAL_SUNRISE_ROBE_GEM_EMERALD)*target:GetSpirit())
		end
		if ability:GetGemValue("sapphire") then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_empyreal_spell_pierce", {})
			target:SetModifierStackCount("modifier_empyreal_spell_pierce", caster, ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_EMPYREAL_SUNRISE_ROBE_GEM_SAPPHIRE)*target:GetSpirit())
		end
		if ability:GetGemValue("amethyst") then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_empyreal_magic_armor", {})
			target:SetModifierStackCount("modifier_empyreal_magic_armor", caster, ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_EMPYREAL_SUNRISE_ROBE_GEM_AMETHYST)*target:GetSpirit())
		end
	end
end

function sea_oracle_attack_land(event)
	local caster = event.caster
	local attacker = event.attacker
	local ability = event.ability
	local target = event.target

	local stacks_gained = 1
	local proc = Filters:GetProc(attacker, ability:GetFinalGemPropertyValue("amethyst", SEA_ORACLE_AMETHYST))
	if proc then
		stacks_gained = stacks_gained + 1
	end

	ability:ApplyDataDrivenModifier(caster, target, "modifier_sea_oracle_stacker", {duration = HOOD_OF_SEA_ORACLE_DURATION})
	local currentMainStacks = target:GetModifierStackCount("modifier_sea_oracle_stacker", caster)
	stacks_gained = math.min(stacks_gained, HOOD_OF_SEA_ORACLE_MAX_STACKS - currentMainStacks)
	local newStacks = math.min(target:GetModifierStackCount("modifier_sea_oracle_stacker", caster) + stacks_gained, HOOD_OF_SEA_ORACLE_MAX_STACKS)
	target:SetModifierStackCount("modifier_sea_oracle_stacker", caster, newStacks)

	ability:ApplyDataDrivenModifier(caster, target, "modifier_sea_oracle_attack_loss", {duration = HOOD_OF_SEA_ORACLE_DURATION})

	if stacks_gained > 0 then
		local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/seafortress/sea_oracle_impact_d.vpcf", target, 2)
		ParticleManager:SetParticleControl(pfx, 1, target:GetAbsOrigin())
		local attackerReduce = target:GetAttackDamage() * (HOOD_OF_SEA_ORACLE_DMG_DEBUFF_PCT/100)*stacks_gained
		local currentStacks = target:GetModifierStackCount("modifier_sea_oracle_attack_loss", caster)
		local newStacks = currentStacks + attackerReduce
		target:SetModifierStackCount("modifier_sea_oracle_attack_loss", caster, newStacks)
	end
	if not ability.tideworn_table then
		ability.tideworn_table = {}
	end
	table.insert(ability.tideworn_table, target)
	target:CalculateAndSaveRoshpitAttributes()
end

function sea_oracle_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if not ability.tideworn_table then
		ability.tideworn_table = {}
	end
	if not ability.interval then
		ability.interval = 0
	end
	local has_mega_buff = false

	local new_table = {}
	local largest_stack = 0
	for i = 1, #ability.tideworn_table, 1 do
		if IsValidEntity(ability.tideworn_table[i]) and ability.tideworn_table[i]:IsAlive() and ability.tideworn_table[i]:HasModifier("modifier_sea_oracle_stacker") then
			table.insert(new_table, ability.tideworn_table[i])
			if ability.tideworn_table[i]:GetModifierStackCount("modifier_sea_oracle_stacker", caster) == HOOD_OF_SEA_ORACLE_MAX_STACKS then
				has_mega_buff = true
			end
			largest_stack = math.min(largest_stack, ability.tideworn_table[i]:GetModifierStackCount("modifier_sea_oracle_stacker", caster))
		end
	end
	ability.tideworn_table = new_table
	ability.interval = math.min(ability.interval + 1, 7)
	if has_mega_buff then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_sea_oracle_mega_buff", {})
		if ability.interval >= 7 then
			local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/seafortress/sea_oracle_impact.vpcf", target, 1)
			ParticleManager:SetParticleControl(pfx, 1, target:GetAbsOrigin())
			ability.interval = 0
			EmitSoundOn("RPCItem.OceanOracle.SelfBuff", target)
		end
	else
		target:RemoveModifierByName("modifier_sea_oracle_mega_buff")
	end
	if ability:GetGemValue("sapphire") > 0 and largest_stack > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_sea_oracle_attack_power", {})
		local attack_power = largest_stack*ability:GetFinalGemPropertyValue("sapphire", SEA_ORACLE_SAPPHIRE)
		target:SetModifierStackCount("modifier_sea_oracle_attack_power", caster, attack_power)
	else
		target:RemoveModifierByName("modifier_sea_oracle_attack_power")
	end
end

function light_seer_channeling(event)
	local caster = event.caster
	local attacker = event.attacker
	local ability = event.ability
	local target = event.target

	local healAmount = target:GetMaxHealth() * ITEM_RPC_TEMPLAR_LIGHT_SEERS_ROBE_HP_PCT_PER_TICK/100 + ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_TEMPLAR_LIGHT_SEERS_ROBE_GEM_AMETHYST)*target:GetSpirit()
	local max_stacks = ITEM_RPC_TEMPLAR_LIGHT_SEERS_ROBE_MAX_STACKS + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_TEMPLAR_LIGHT_SEERS_ROBE_GEM_EMERALD)

	local targets_to_apply = {target}
	if ability:GetGemValue("sapphire") > 0 then
		local radius = ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_TEMPLAR_LIGHT_SEERS_ROBE_GEM_SAPPHIRE)
		local allies = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		if #allies > 0 then
			for _, ally in pairs(allies) do
				if ally ~= target then
					table.insert(targets_to_apply, ally)
				end
			end
		end
	end
	for _, ally in pairs(targets_to_apply) do
		Filters:ApplyHeal(target, ally, healAmount, true)
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_oracle/flash_healheal.vpcf", ally, 1)

		ability:ApplyDataDrivenModifier(caster, ally, "modifier_light_seer_shield", {duration = 60})

		
		local stacks = ally:GetModifierStackCount("modifier_light_seer_shield", caster) + 1
		stacks = math.min(stacks, max_stacks)
		ally:SetModifierStackCount("modifier_light_seer_shield", caster, stacks)
	end
end

function templar_light_seer_shield_think(event)
	local caster = event.caster
	local attacker = event.attacker
	local ability = event.ability
	local target = event.target

	if not target:HasModifier("modifier_templar_channeling") then
		local stacks = target:GetModifierStackCount("modifier_light_seer_shield", caster) - 1
		if stacks > 0 then
			target:SetModifierStackCount("modifier_light_seer_shield", caster, stacks)
		else
			target:RemoveModifierByName("modifier_light_seer_shield")
		end

	end
end

function ahnqhir_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	local index = event.index
	local pointAbility = target:GetAbilityByIndex(index)
	if pointAbility then
		if pointAbility.ahnqhirPoint then
		else
			pointAbility.ahnqhirPoint = pointAbility:GetCastPoint()
			pointAbility:SetOverrideCastPoint(0.05)
		end
	end
end

function ahnqhir_mask_off_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	local index = event.index
	local pointAbility = target:GetAbilityByIndex(index)
	local pointAbility = target:GetAbilityByIndex(index)
	if pointAbility then
		if pointAbility.ahnqhirPoint then
			pointAbility:SetOverrideCastPoint(pointAbility.ahnqhirPoint)
			pointAbility.ahnqhirPoint = nil
		else
		end
	end
end

function direwolf_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	local stacks = Filters:GetPrimaryAttributeMultiple(target, ITEM_RPC_DIREWOLF_BULWARK_PRIMARY_ATT_DIVISOR/100)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_direwolf_bulwark_effect", {})
	target:SetModifierStackCount("modifier_direwolf_bulwark_effect", caster, math.ceil(stacks))
end

function eyeglass_attack(event)
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	if target.dummy then
		return false
	end
	if ability:GetGemValue("ruby") > 0 then
		local distance = math.min(WallPhysics:GetDistance2d(attacker:GetAbsOrigin(), target:GetAbsOrigin()), ITEM_RPC_EPSILONS_EYEGLASS_MAX_RANGE_FOR_DAMAGE)
		--print(distance)
		local damage = distance * ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_EPSILONS_EYEGLASS_GEM_RUBY)
		Filters:ApplyItemDamage(target, attacker, damage, DAMAGE_TYPE_PHYSICAL, event.ability, RPC_ELEMENT_HOLY, RPC_ELEMENT_COSMOS)
		CustomAbilities:QuickAttachParticle("particles/roshpit/items/epsilon_impact.vpcf", target, 0.5)
	end
end

function eyeglass_equip(event)
	local target = event.target
	local ability = event.ability
	target:AddNewModifier(target, ability, "modifier_epsilon", {})
	if event.target:GetUnitName() == "npc_dota_hero_drow_ranger" then
		event.target:SetRangedProjectileName("particles/units/heroes/hero_drow/astral_c_a_particle_attackfrost_arrow.vpcf")
	end
end

function monkey_paw_unit_die(event)
	local unit = event.unit
	local caster = event.caster
	local hero = caster.hero
	local victim = unit
	if unit.paragon then
		local gold = hero:GetGold();
		local bossLocation = victim:GetAbsOrigin()
		local divisor = ITEM_RPC_MONKEY_PAW_GOLD_DIVISOR * GameState:GetDifficultyFactor()
		local itemsCount = math.floor(gold / divisor)
		if itemsCount >= 1 then
			hero:SpendGold(gold * ITEM_RPC_MONKEY_PAW_GOLD_COST_PCT/100, DOTA_ModifyGold_PurchaseItem)
			for i = 1, itemsCount, 1 do
				Timers:CreateTimer((i - 1) * 0.3, function()
					RPCItems.LevelRoll = ITEM_RPC_MONKEY_PAW_ITEM_LVL_MULTIPLIER_PER_DIFF * GameState:GetDifficultyFactor()
					EmitSoundOnLocationWithCaster(bossLocation, "RPC.MonkeyPaw.Bounty", caster)
					CustomAbilities:QuickParticleAtPoint("particles/roshpit/items/monkey_paw_bounty.vpcf", GetGroundPosition(bossLocation, Events.GameMaster), 1.2)
					CustomAbilities:QuickAttachParticle("particles/roshpit/items/monkey_paw_bounty.vpcf", hero, 0.5)
					local luck = RandomInt(200, 500)
					if luck >= 200 and luck < 265 then
						RPCItems:RollHood(0, bossLocation, "immortal", false, 0, nil, 0)
					elseif luck >= 265 and luck < 330 then
						RPCItems:RollHand(0, bossLocation, "immortal", false, 0, nil, 0)
					elseif luck >= 330 and luck < 395 then
						RPCItems:RollFoot(0, bossLocation, "immortal", false, 0, nil, 0)
					elseif luck >= 395 and luck < 460 then
						RPCItems:RollBody(0, bossLocation, "immortal", false, 0, nil, 0)
					elseif luck <= 500 then
						RPCItems:RollAmulet(0, bossLocation, "immortal", false, 0, nil, 0)
					end
					RPCItems.LevelRoll = nil
				end)
			end
		end
	end
end

function arcane_charm_start(event)
	local heroEntity = event.target
	heroEntity:RemoveModifierByName("modifier_hero_thinker")
end

function arcane_charm_end(event)
	local heroEntity = event.target
	Events:GetGameMasterAbility():ApplyDataDrivenModifier(Events.GameMaster, heroEntity, "modifier_hero_thinker", {})
end

function skull_ring_init(event)
	--print("[skull_ring_init]")
	local heroEntity = event.target
	local item = event.ability
	local caster = event.caster
	local propertyTable = CustomNetTables:GetTableValue("item_basics", tostring(item:GetEntityIndex()))
	local tooltipGlyph = propertyTable.property1tooltip
	local glyphName = string.gsub(tooltipGlyph, "#DOTA_Tooltip_ability_item_rpc_", "")
	local glyphNameWithItem = string.gsub(tooltipGlyph, "#DOTA_Tooltip_ability_", "")
	--print("skull_ring_init:"..glyphNameWithItem)
	caster.skullGlyph = Glyphs:RollGlyphAll(glyphNameWithItem, Vector(0, 0), 0)
	UTIL_Remove(caster.skullGlyph:GetContainer())
	local modifierName = "modifier_"..glyphName
	caster.skyllGlyphModifier = modifierName
	caster.skullGlyph:ApplyDataDrivenModifier(caster, heroEntity, modifierName, {})
end

function skull_ring_end(event)
	local heroEntity = event.target
	local item = event.ability
	local caster = event.caster
	heroEntity:RemoveModifierByName(caster.skyllGlyphModifier)
	UTIL_Remove(caster.skullGlyph)
end

function init_blacksmith_tablet(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local hero = caster.hero
	-- if hero.equipped_gear[RPC_GEAR_SLOT_WEAPON] then
	-- 	hero:EquipItem(hero.equipped_gear[RPC_GEAR_SLOT_WEAPON], false)
	-- end
end

function end_blacksmith_tablet(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local hero = caster.hero
	-- if hero.equipped_gear[RPC_GEAR_SLOT_WEAPON] then
	-- 	hero:EquipItem(hero.equipped_gear[RPC_GEAR_SLOT_WEAPON], false)
	-- end
end

function frostmaw_kill(event)
	local unit = event.unit
	local caster = event.attacker
	local ability = event.ability
	if not unit.dominion then
		return
	end
	if not ability.frostmaw_minion_table then
		ability.frostmaw_minion_table = {}
	end
	local max_minions = 1 + ability:GetFinalGemPropertyValue("sapphire", FROSTMAW_SAPPHIRE)
	if #ability.frostmaw_minion_table < max_minions then
		local fv = unit:GetForwardVector()
		local summonPosition = unit:GetAbsOrigin()
		unit:SetAbsOrigin(summonPosition - Vector(0, 0, 800))
		local summon = CreateUnitByName(unit:GetUnitName(), summonPosition, false, nil, nil, caster:GetTeamNumber())
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_savage_roar.vpcf", summon, 3)
		ability:ApplyDataDrivenModifier(caster, summon, "modifier_frostmaw_dominated_unit", {})
		summon:SetAcquisitionRange(1600)
		summon:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
		summon:SetForwardVector(fv)
		Enemies:InitializeEnemy(summon)

		local hp = unit:GetMaxHealth() + ability:GetFinalGemPropertyValue("ruby", FROSTMAW_RUBY)
		local attackDamage = unit:GetAttackDamage()
		summon:SetMaxHealth(hp)
		summon:SetHealth(hp)
		summon:SetBaseMaxHealth(hp)

		local armor = unit.roshpit_attributes.roshpit_armor + ability:GetFinalGemPropertyValue("amethyst", FROSTMAW_AMETHYST)
		local armor_pierce = unit.roshpit_attributes.roshpit_armor_pierce + ability:GetFinalGemPropertyValue("emerald", FROSTMAW_EMERALD)
		local magic_armor = unit.roshpit_attributes.roshpit_magic_armor + ability:GetFinalGemPropertyValue("amethyst", FROSTMAW_AMETHYST)
		local spell_pierce = unit.roshpit_attributes.roshpit_spell_pierce + ability:GetFinalGemPropertyValue("emerald", FROSTMAW_EMERALD)

		summon.roshpit_attributes.roshpit_armor = armor
		summon.roshpit_attributes.roshpit_magic_armor = magic_armor
		summon.roshpit_attributes.roshpit_armor_pierce = armor_pierce
		summon.roshpit_attributes.roshpit_spell_pierce = spell_pierce
		summon:CalculateAndSaveRoshpitAttributes()

		summon:SetBaseDamageMin(attackDamage)
		summon:SetBaseDamageMax(attackDamage)
		summon.aggro = true
		summon.frostmaw = true
		summon:SetDayTimeVisionRange(90)
		summon:SetNightTimeVisionRange(90)
		summon.hero = caster

		table.insert(ability.frostmaw_minion_table, summon)

		EmitSoundOn("RPCItem.FrostmawDominate", summon)

		local newTable = {}
		for i = 1, #ability.frostmaw_minion_table, 1 do
			if IsValidEntity(ability.frostmaw_minion_table[i]) then
				if ability.frostmaw_minion_table[i]:IsAlive() then
					table.insert(newTable, ability.frostmaw_minion_table[i])
				end
			end
		end
		ability.frostmaw_minion_table = newTable
		summon:SetAcquisitionRange(1200)
		summon.targetRadius = 1000
		summon.minRadius = 0
		summon.targetAbilityCD = 2
		summon.targetFindOrder = FIND_ANY_ORDER
		summon.autoAbilityCD = 2
		summon.owner = caster:GetPlayerOwnerID()
		if summon.aggroSound then
			EmitSoundOn(summon.aggroSound, summon)
		end
		summon.stance = "aggressive"
		summon:AddAbility("ekkan_creep_aggressive"):SetLevel(1)
		summon:SetOwner(caster)
		for i = 0, 6, 1 do
			local ability = summon:GetAbilityByIndex(i)
			if ability then
				ability:SetLevel(GameState:GetDifficultyFactor())
			end
		end
	end
	caster.frostmaw_minion_table = ability.frostmaw_minion_table
end

function frostmaw_unequip(event)
	local ability = event.ability
	local caster = event.target
	if caster.frostmaw_minion_table then
		for i = 1, #caster.frostmaw_minion_table, 1 do
			if IsValidEntity(caster.frostmaw_minion_table[i]) then
				caster.frostmaw_minion_table[i]:SetHealth(1)
				caster.frostmaw_minion_table[i]:ForceKill(false)
			end
		end
	end
end

function frostmaw_dominated_think(event)
	local caster = event.caster
	local target = event.target
	if caster:GetEntityIndex() == target:GetEntityIndex() then
		caster = target.hero
	end
	if target:IsAlive() then
		local leashDistance = 2000
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), target:GetAbsOrigin())
		if distance > leashDistance then
			FindClearSpaceForUnit(target, caster:GetAbsOrigin() + RandomVector(180), false)
			Timers:CreateTimer(0.1, function()
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_savage_roar.vpcf", target, 3)
			end)
			return false
		end
		if target.stance == "passive" then
			return false
		elseif target.stance == "follow" then
			target:MoveToPosition(caster:GetAbsOrigin() + RandomVector(180))
			return false
		else
			if distance > 800 then
				local enemies = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
				if #enemies == 0 then
					target:MoveToPosition(caster:GetAbsOrigin() + RandomVector(180))
				end
			end
		end
	end
end

function frostmaw_dominated_die(event)
	local unit = event.unit
	local caster = event.caster
	local ability = event.ability
	local newTable = {}
	if IsValidEntity(ability) then
		for i = 1, #ability.frostmaw_minion_table, 1 do
			if IsValidEntity(ability.frostmaw_minion_table[i]) then
				if ability.frostmaw_minion_table[i]:IsAlive() then
					table.insert(newTable, ability.frostmaw_minion_table[i])
				end
			end
		end
		ability.frostmaw_minion_table = newTable
	end
end

function frozen_heart_think(event)
	local unit = event.unit
	local caster = event.caster
	local ability = event.ability
	local hero = event.target
	-- local maxHealth = math.floor(hero:GetMaxHealth() + hero:GetModifierStackCount("modifier_frozen_heart_negative_health", caster))
	----print("MAXHEALTH----")
	----print(maxHealth)
	----print("-----")
	-- if hero:GetMaxHealth() > 101 or hero:GetMaxHealth() < 99 then
	-- local stacksToBeApplied = hero:GetMaxHealth() - 99
	-- if not hero:HasModifier("modifier_frozen_heart_negative_health") then
	-- ability:ApplyDataDrivenModifier(caster, hero, "modifier_frozen_heart_negative_health", {})
	-- end
	-- if hero:GetMaxHealth() - stacksToBeApplied > 10 then
	-- Timers:CreateTimer(0.03, function()
	-- hero:SetModifierStackCount("modifier_frozen_heart_negative_health", caster, stacksToBeApplied)
	-- end)
	-- end
	-- end
	-- if not ability.interval then
	-- ability.interval = 0
	-- end
	-- if ability.interval == 75 then
	-- ability:ApplyDataDrivenModifier(caster, hero, "modifier_frozen_heart_regen", {})
	-- else
	-- ability.interval = ability.interval + 1
	-- end
	local base_hero_health = 100
	local iceblood_max_health = ITEM_RPC_FROZEN_HEART_NEW_HP_CAP + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_FROZEN_HEART_GEM_RUBY)
	local health_removal_stacks = base_hero_health - iceblood_max_health
	if health_removal_stacks > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_frozen_heart_negative_health", {})
		hero:SetModifierStackCount("modifier_frozen_heart_negative_health", caster, health_removal_stacks)
	else
		hero:RemoveModifierByName("modifier_frozen_heart_negative_health")
	end
	if not hero:HasModifier("modifier_frozen_heart_regen") then
		if not hero:HasModifier("modifier_frozen_heart_regen_prep") then
			local heal_delay = ITEM_RPC_FROZEN_HEART_HP_REGEN_DELAY - ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_FROZEN_HEART_GEM_EMERALD)
			ability:ApplyDataDrivenModifier(caster, hero, "modifier_frozen_heart_regen_prep", {duration = heal_delay})
		end
	end
	-- if hero:GetHealth() <= 0 then
	-- caster:SetHealth(10)
	-- hero:RemoveModifierByName("modifier_frozen_heart_negative_health")
	-- hero:ForceKill(false)
	-- end
end

function frozen_heart_die(event)
	local hero = event.unit
	local caster = event.caster
	local ability = event.ability
	AddFOWViewer(hero:GetTeamNumber(), hero:GetAbsOrigin(), 500, 6, false)
	ability:ApplyDataDrivenModifier(caster, hero, "modifier_frozen_heart_dead", {})
	Timers:CreateTimer(3, function()
		hero:RemoveModifierByName("modifier_frozen_heart_dead")
		local position = hero:GetAbsOrigin()
		for i = 0, 3, 1 do
			Timers:CreateTimer(0.1 * i, function()
				local particleName = "particles/roshpit/winterblight/snow_impact.vpcf"
				local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, nil)
				ParticleManager:SetParticleControl(particle1, 0, caster:GetAbsOrigin())
				Timers:CreateTimer(1, function()
					ParticleManager:DestroyParticle(particle1, false)
				end)
			end)
		end
		EmitSoundOn("RPCItems.FrozenHeart.Shatter", hero)
		local particleName = "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf"
		local radius = 500
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(particle1, 0, position)
		ParticleManager:SetParticleControl(particle1, 1, Vector(radius, 1, 800))
		ParticleManager:SetParticleControl(particle1, 3, Vector(radius, radius, radius))
		Timers:CreateTimer(3, function()
			ParticleManager:DestroyParticle(particle1, false)
		end)
		hero:SetAbsOrigin(hero:GetAbsOrigin() - Vector(0, 0, 500))
	end)
end

function frozen_heart_regen_thinker(event)
	local caster = event.caster
	local hero = event.target
	local ability = event.ability
	local iceblood_max_health = ITEM_RPC_FROZEN_HEART_NEW_HP_CAP + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_FROZEN_HEART_GEM_RUBY)
	local newHealth = math.min(hero:GetHealth() + ITEM_RPC_FROZEN_HEART_HP_REGEN, iceblood_max_health)
	hero:SetHealth(newHealth)
end

function frozen_heart_take_damage(event)
	local unit = event.unit
	local ability = event.ability
	local caster = event.caster
	ability.interval = 0
	--print("take damage")
	local heal_delay = ITEM_RPC_FROZEN_HEART_HP_REGEN_DELAY - ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_FROZEN_HEART_GEM_EMERALD)
	ability:ApplyDataDrivenModifier(caster, hero, "modifier_frozen_heart_regen_prep", {duration = heal_delay})
	local modifier = unit:FindModifierByName("modifier_frozen_heart_regen_prep")
	if modifier then
		modifier:SetDuration(heal_delay, true)
	end
	Timers:CreateTimer(0.03, function()
		ability.interval = 0
		unit:RemoveModifierByName("modifier_frozen_heart_regen")
	end)
end

function energy_whip_glove_attack_land(event)
	local attacker = event.attacker
	local target = event.target
	local ability = attacker:GetAbilityByIndex(DOTA_W_SLOT)
	if attacker.Attacking_a_Cup then
		return
	end
	if ability:GetCooldownTimeRemaining() <= 0 then
		--print("B2")
		local manaRestore = ability:GetManaCost(ability:GetLevel())
		attacker:GiveMana(manaRestore)
		local castPointSave = ability:GetCastPoint()
		ability.castPointSave = attacker.castPointW
		ability:SetOverrideCastPoint(0)
		local behavior = ability:GetBehavior()
		--print(bit.band(behavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET))
		if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET) == DOTA_ABILITY_BEHAVIOR_NO_TARGET then
			local order =
			{
				UnitIndex = attacker:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = ability:entindex(),
				Queue = true
			}
			attacker:Stop()
			ExecuteOrderFromTable(order)
			--print("IN HERE")
		elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
			local order = {
				UnitIndex = attacker:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				TargetIndex = target:entindex(),
				AbilityIndex = ability:entindex(),
				Queue = true
			}
			attacker:Stop()
			--print("HERE?")
			ExecuteOrderFromTable(order)
		elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_POINT) == DOTA_ABILITY_BEHAVIOR_POINT then
			local order =
			{
				UnitIndex = attacker:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = ability:entindex(),
				Position = target:GetAbsOrigin(),
				Queue = true
			}
			attacker:Stop()
			ExecuteOrderFromTable(order)
		end
		-- ability:StartCooldown(0)
	end
end

function boreal_granite_vest_take_damage(event)
	local target = event.attacker
	local hero = event.unit
	if hero:GetEntityIndex() == target:GetEntityIndex() then
		return false
	end
	local boreal_vest = event.ability
	local ability = hero:GetAbilityByIndex(DOTA_Q_SLOT)
	local proc_chance = ITEM_RPC_BOREAL_GRANITE_VEST_CHANCE + boreal_vest:GetFinalGemPropertyValue("ruby", ITEM_RPC_BOREAL_GRANITE_VEST_GEM_RUBY)*hero:GetModifierStackCount("modifier_boreal_granite_stack", hero.InventoryUnit)
	local proc = Filters:GetProc(hero, proc_chance)
	local cd = ability:GetCooldownTimeRemaining()
	local distance = WallPhysics:GetDistance(hero:GetAbsOrigin(), target:GetAbsOrigin())
	local behavior = ability:GetBehavior()
	if proc then
		if distance <= ability:GetCastRange() or (bit.band(behavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET) == DOTA_ABILITY_BEHAVIOR_NO_TARGET and distance < 2000) then
			hero:RemoveModifierByName("modifier_boreal_granite_stack")
			ability:EndCooldown()
			local manaRestore = ability:GetManaCost(ability:GetLevel())
			if manaRestore > 0 then
				attacker:GiveMana(manaRestore)
			end
			local castPointSave = hero.castPointQ
			ability.boreal_cast_point = castPointSave
			ability:SetOverrideCastPoint(0)
			if ability:GetAbilityName() == "warlord_cataclysm_shaker" then
				ability:OnSpellStart()
			elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET) == DOTA_ABILITY_BEHAVIOR_NO_TARGET then
				local order =
				{
					UnitIndex = hero:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = ability:entindex(),
					Queue = true
				}
				hero:Stop()
				ExecuteOrderFromTable(order)
			elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_POINT) == DOTA_ABILITY_BEHAVIOR_POINT then
				local order =
				{
					UnitIndex = hero:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = ability:entindex(),
					Position = target:GetAbsOrigin(),
					Queue = true
				}
				hero:Stop()
				ExecuteOrderFromTable(order)
			elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
				local order = {
					UnitIndex = hero:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					TargetIndex = target:entindex(),
					AbilityIndex = ability:entindex(),
					Queue = true
				}
				hero:Stop()
				ExecuteOrderFromTable(order)
			end
		end
	end
end

function boreal_granite_think(event)
	local hero = event.target
	local caster = event.caster
	local ability = event.ability
	if ability:GetGemValue("ruby") > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_boreal_granite_stack", {})
		local new_stacks = math.min(hero:GetModifierStackCount("modifier_boreal_granite_stack", caster) + 1, 5)
		hero:SetModifierStackCount("modifier_boreal_granite_stack", caster, new_stacks)
	end
end

function captains_vest_think(event)
	local hero = event.target
	local caster = event.caster
	local ability = event.ability
	local q_1_level = hero:GetRuneValue("q", 1)
	local q_2_level = hero:GetRuneValue("q", 2)
	local q_3_level = hero:GetRuneValue("q", 3)
	local q_4_level = hero:GetRuneValue("q", 4)
	local w_1_level = hero:GetRuneValue("w", 1)
	local w_2_level = hero:GetRuneValue("w", 2)
	local w_3_level = hero:GetRuneValue("w", 3)
	local w_4_level = hero:GetRuneValue("w", 4)
	local e_1_level = hero:GetRuneValue("e", 1)
	local e_2_level = hero:GetRuneValue("e", 2)
	local e_3_level = hero:GetRuneValue("e", 3)
	local e_4_level = hero:GetRuneValue("e", 4)
	local r_1_level = hero:GetRuneValue("r", 1)
	local r_2_level = hero:GetRuneValue("r", 2)
	local r_3_level = hero:GetRuneValue("r", 3)
	local r_4_level = hero:GetRuneValue("r", 4)
	local strength = q_1_level * ITEM_RPC_CAPTAINS_VEST_Q1 + q_2_level * ITEM_RPC_CAPTAINS_VEST_Q2 + q_3_level * ITEM_RPC_CAPTAINS_VEST_Q3 + q_4_level * ITEM_RPC_CAPTAINS_VEST_Q4
	local agility = e_1_level * ITEM_RPC_CAPTAINS_VEST_E1 + e_2_level * ITEM_RPC_CAPTAINS_VEST_E2 + e_3_level * ITEM_RPC_CAPTAINS_VEST_E3 + e_4_level * ITEM_RPC_CAPTAINS_VEST_E4
	local intelligence = w_1_level * ITEM_RPC_CAPTAINS_VEST_W1 + w_2_level * ITEM_RPC_CAPTAINS_VEST_W2 + w_3_level * ITEM_RPC_CAPTAINS_VEST_W3 + w_4_level * ITEM_RPC_CAPTAINS_VEST_W4
	local spirit = r_1_level * ITEM_RPC_CAPTAINS_VEST_R1 + r_2_level * ITEM_RPC_CAPTAINS_VEST_R2 + r_3_level * ITEM_RPC_CAPTAINS_VEST_R3 + r_4_level * ITEM_RPC_CAPTAINS_VEST_R4

	strength = strength * (1 + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_CAPTAINS_VEST_GEM_RUBY)/100)
	agility = agility * (1 + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_CAPTAINS_VEST_GEM_EMERALD)/100)
	intelligence = intelligence * (1 + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_CAPTAINS_VEST_GEM_SAPPHIRE)/100)
	spirit = spirit * (1 + ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_CAPTAINS_VEST_GEM_AMETHYST)/100)
	if strength > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_captains_vest_str", {})
		hero:SetModifierStackCount("modifier_captains_vest_str", caster, strength)
	else
		hero:RemoveModifierByName("modifier_captains_vest_str")
	end
	if agility > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_captains_vest_agi", {})
		hero:SetModifierStackCount("modifier_captains_vest_agi", caster, agility)
	else
		hero:RemoveModifierByName("modifier_captains_vest_agi")
	end
	if intelligence > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_captains_vest_int", {})
		hero:SetModifierStackCount("modifier_captains_vest_int", caster, intelligence)
	else
		hero:RemoveModifierByName("modifier_captains_vest_int")
	end
	if spirit > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_captains_vest_spr", {})
		hero:SetModifierStackCount("modifier_captains_vest_spr", caster, spirit)
	else
		hero:RemoveModifierByName("modifier_captains_vest_spr")
	end
end

function gravelfoot_think(event)
	local hero = event.target
	local caster = event.caster
	local ability = event.ability
	-- "RPCItems.Gravelfoot.Dispel"
	-- "RPCItems.Gravelfoot.Activate"
	local caster = event.target
	local procced = false
	local modifiers = hero:FindAllModifiers()
	for j = 1, #modifiers, 1 do
		local modifier = modifiers[j]
		local modifierMaker = modifier:GetCaster()
		if WallPhysics:DoesTableHaveValue(Filters:GetUnpurgableDebuffNames(), modifier:GetName()) then
		else
			if modifierMaker and modifierMaker:IsRegularEnemy(hero) then
				hero:RemoveModifierByName(modifier:GetName())
				procced = true
				break
			elseif not modifierMaker then
				hero:RemoveModifierByName(modifier:GetName())
				procced = true
				break
			end
		end
	end

	if procced then
		Filters:InitGravelFootEffect(caster, ability, hero, ITEM_RPC_GRAVELFOOT_TREADS_SELF_SLOW_DURATION)
	end
end

function gravelfoot_start(event)
	local hero = event.target
	local caster = event.caster
	local ability = event.ability
	EmitSoundOnLocationWithCaster(hero:GetAbsOrigin(), "RPCItems.Gravelfoot.Activate", caster)
	local earthParticle = "particles/units/heroes/hero_earth_spirit/espirit_bouldersmash_caster.vpcf"
	local pfx = ParticleManager:CreateParticle(earthParticle, PATTACH_CUSTOMORIGIN, hero)
	ParticleManager:SetParticleControl(pfx, 0, hero:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, hero:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 2, hero:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 3, hero:GetAbsOrigin())
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
end

function ice_floe_think(event)
	local caster = event.caster
	local hero = event.target
	local ability = event.ability
	local targetPoint = hero.ice_floe_table.last_position
	local fv = (targetPoint - hero:GetAbsOrigin()):Normalized()
	hero.ice_floe_table.speed = math.max(hero.ice_floe_table.speed - 0.3, 25)
	local newPosition = hero:GetAbsOrigin() + fv * hero.ice_floe_table.speed
	local obstruction = WallPhysics:FindNearestObstruction(newPosition)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition * Vector(1, 1, 0), hero)
	newPosition = GetGroundPosition(newPosition, hero)
	if blockUnit then
	else
		hero:SetAbsOrigin(newPosition)
	end
	local distance = WallPhysics:GetDistance2d(hero:GetAbsOrigin(), targetPoint)
	if distance < 50 then
		hero:RemoveModifierByName("modifier_ice_floe_sliding")
	end
end

function terrasic_stone_plate_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	if not ability.interval then
		ability.interval = 0
	end
	local max_stacks = ITEM_RPC_TERRASIC_STONE_PLATE_MAX_STACKS + ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_TERRASIC_STONE_PLATE_GEM_AMETHYST)
	ability.interval = ability.interval + 1
	if target:GetModifierStackCount("modifier_terrasic_magma_break_stacks", caster) == max_stacks then
		ability.interval = 0
	end
	local stack_generation_interval = math.max(ITEM_RPC_TERRASIC_STONE_PLATE_STACK_INTERVAL - ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_TERRASIC_STONE_PLATE_GEM_EMERALD), 1)
	if ability.interval >= stack_generation_interval then
		
		if target:HasModifier("modifier_terrasic_magma_break_stacks") then
			local newStacks = math.min(target:GetModifierStackCount("modifier_terrasic_magma_break_stacks", caster) + 1, max_stacks)
			target:SetModifierStackCount("modifier_terrasic_magma_break_stacks", caster, newStacks)
		else
			ability:ApplyDataDrivenModifier(caster, target, "modifier_terrasic_magma_break_stacks", {})
			target:SetModifierStackCount("modifier_terrasic_magma_break_stacks", caster, 1)
		end
		ability.interval = 0
	end
end

function buzuki_buff_attack_land(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local hero = caster.hero
	EmitSoundOn("RPCItems.BuzukiFinger.BeamHit", target)

	local damage = OverflowProtectedGetAverageTrueAttackDamage(event.attacker)*ITEM_RPC_BUZUKIS_FINGER_MODIFIER_ATTACK_PCT/100
	if event.attacker == hero then
		if ability:GetGemValue("amethyst") > 0 then
			damage = OverflowProtectedGetAverageTrueAttackDamage(hero)*(ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_BUZUKIS_FINGER_GEM_AMETHYST)/100)
		else
			return false
		end
	end
	damage = damage * (1 + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_BUZUKIS_FINGER_GEM_EMERALD)/100)
	Filters:ApplyItemDamage(target, hero, damage, DAMAGE_TYPE_PURE, ability, RPC_ELEMENT_ICE, RPC_ELEMENT_DEMON)

	local particle1 = ParticleManager:CreateParticle("particles/roshpit/winterblight/blue_finger.vpcf", PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControlEnt(particle1, 0, event.attacker, PATTACH_POINT, "attach_attack1", event.attacker:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle1, 1, target:GetAbsOrigin() + Vector(0, 0, 80))
	Timers:CreateTimer(1, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
end

function orthok_attack_land(event)
	local attacker = event.attacker
	Filters:OrthokStack(attacker, 1)
end

function orthok_think(event)
	local hero = event.target
	local chains = event.ability
	Filters:RecalculateOrthokStacks(hero, chains)
end

function mugato_attack(event)
	local attacker = event.attacker

	attacker:AddNewModifier(caster, nil, "modifier_silence", {duration = MUGATO_ATTACK_SILENCE_DUR})
end

function mugato_think(event)
	local hero = event.target
	local ability = event.ability
	if hero:IsSilenced() then
		local mana_drain = 0
		mana_drain = mana_drain + ability:GetFinalGemPropertyValue("sapphire", MUGATO_SAPPHIRE1) + ability:GetFinalGemPropertyValue("amethyst", MUGATO_AMETHYST1)
		if mana_drain > 0 then
			hero:ReduceMana(mana_drain)
		end
	end
end

function stormcloth_think(event)
	local hero = event.target
	local ability = event.ability
	local caster = event.caster
	if not ability.fall_speed then
		ability.sound = false
		ability.fall_speed = 50
		Timers:CreateTimer(0.1, function()
			local pfx = ParticleManager:CreateParticle("particles/roshpit/items/stormcloth_bolt.vpcf", PATTACH_CUSTOMORIGIN, hero)
			ParticleManager:SetParticleControl(pfx, 0, GetGroundPosition(hero:GetAbsOrigin(), hero))
			ParticleManager:SetParticleControl(pfx, 1, Vector(200, 200, 200))
			Timers:CreateTimer(2, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
		end)
	end
	ability.fall_speed = math.min(ability.fall_speed + 0.5, 60)
	hero:SetAbsOrigin(hero:GetAbsOrigin() - Vector(0, 0, ability.fall_speed))
	if not ability.sound then
		if hero:GetAbsOrigin().z < GetGroundHeight(hero:GetAbsOrigin(), hero) + 330 then
			EmitSoundOn("RPCItems.Stormcloth.Impact", hero)
			ability.sound = true
		end
	end
	local damage = OverflowProtectedGetAverageTrueAttackDamage(hero)*(ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_STORMCLOTH_BRACER_GEM_EMERALD)/100)
	if hero:GetAbsOrigin().z < GetGroundHeight(hero:GetAbsOrigin(), hero) + ability.fall_speed then
		hero:RemoveModifierByName("modifier_stormcloth_falling")
		StartAnimation(hero, {duration = 1, activity = ACT_DOTA_TELEPORT_END, rate = 1.2})
		Timers:CreateTimer(0.06, function()
			ability.fall_speed = nil
			for i = 1, 6, 1 do
				CustomAbilities:QuickAttachParticle("particles/roshpit/stormbolt_aoe.vpcf", hero, 4)
			end
			FindClearSpaceForUnit(hero, hero:GetAbsOrigin(), false)
			CustomAbilities:QuickParticleAtPoint("particles/roshpit/items/stormcloth_start.vpcf", hero:GetAbsOrigin(), 3)
			local enemies = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin(), nil, ITEM_RPC_STORMCLOTH_BRACER_STUN_AOE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				for _, enemy in pairs(enemies) do
					Filters:ApplyStun(hero, ITEM_RPC_STORMCLOTH_BRACER_STUN_DUR, enemy)
					if damage > 0 then
						Filters:ApplyItemDamage(enemy, hero, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_WIND)
					end
				end
			end
		end)
		if ability:GetGemValue("sapphire") > 0 then
			ability:ApplyDataDrivenModifier(caster, hero, "modifier_stormcloth_sapphire_visible", {duration = ITEM_RPC_STORMCLOTH_BRACER_SAPPHIRE_DURATION})
			ability:ApplyDataDrivenModifier(caster, hero, "modifier_stormcloth_sapphire_invisible", {duration = ITEM_RPC_STORMCLOTH_BRACER_SAPPHIRE_DURATION})
			hero:SetModifierStackCount("modifier_stormcloth_sapphire_invisible", caster, ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_STORMCLOTH_BRACER_GEM_SAPPHIRE))
		end
	end
end

function elder_shield_particle_init(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if not target.elderShieldParticle then
		target.elderShieldParticle = ParticleManager:CreateParticle("particles/roshpit/items/elders_shield.vpcf", PATTACH_CUSTOMORIGIN, target)
		ParticleManager:SetParticleControlEnt(target.elderShieldParticle, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(target.elderShieldParticle, 1, Vector(255, 255, 255))
	end
end

function puzzlers_locket_recalculate(event)
	-- local ability = event.ability
	-- if not ability.recalculated then
	-- 	ability.recalculated = true
	-- 	Timers:CreateTimer(5, function()
	-- 		local hero = event.target
	-- 		RPCItems:RecalculateStatsBasic(hero)
	-- 		Timers:CreateTimer(12, function()
	-- 			ability.recalculated = false
	-- 		end)
	-- 	end)
	-- end
end

function tiamat_claw_initialize(event)
end

function tiamat_claw_initialize(event)
end

function razor_band_take_damage(event)
	local target = event.unit
	local ability = event.ability
	local caster = event.caster
	local attacker = event.attacker
	if target == attacker or event.damage < 1 then
		return false
	end
	if not ability.buff_table then
		ability.buff_table = {}
	end
	local stack_gain = 1
	local proc = Filters:GetProc(target, ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_GALVANIZED_RAZOR_BAND_GEM_EMERALD2))
	if proc then
		stack_gain = stack_gain + 1
	end
	for i = 1, stack_gain, 1 do
		local new_buff = GameRules:GetGameTime()
		local max_stacks = ITEM_RPC_GALVANIZED_RAZOR_BAND_MAX_STACKS + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_GALVANIZED_RAZOR_BAND_GEM_SAPPHIRE1)
		if #ability.buff_table < max_stacks then
			table.insert(ability.buff_table, new_buff)
		end
		ability:ApplyDataDrivenModifier(caster, target, "modfier_razor_band_stacks", {duration = ITEM_RPC_GALVANIZED_RAZOR_BAND_STACK_DURATION})
		local stacks = #ability.buff_table
		target:SetModifierStackCount("modfier_razor_band_stacks", caster, stacks)
	end
	Timers:CreateTimer(0.03, function()
		if target:IsAlive() then
			local self_removal_rate = ITEM_RPC_GALVANIZED_RAZOR_BAND_MAX_HEALTH_REMOVAL - ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_GALVANIZED_RAZOR_BAND_GEM_EMERALD1)
			local self_health_removal = target:GetMaxHealth()*(self_removal_rate/100)
			local newHealth = math.max(target:GetHealth() - self_health_removal, 1)
			target:SetHealth(newHealth)
		end
	end)
end

function razor_band_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster

	local new_buff_table = {}

	local stack_duration = ITEM_RPC_GALVANIZED_RAZOR_BAND_STACK_DURATION + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_GALVANIZED_RAZOR_BAND_GEM_SAPPHIRE2)
	for i = 1, #ability.buff_table, 1 do
		if GameRules:GetGameTime() - ability.buff_table[i] >stack_duration then
		else
			table.insert(new_buff_table, ability.buff_table[i])
		end
	end
	ability.buff_table = new_buff_table

	local stacks = #ability.buff_table
	target:SetModifierStackCount("modfier_razor_band_stacks", caster, stacks)
	if ability:GetGemValue("amethyst") > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_razor_band_amethyst_attack_stacks", {})
		target:SetModifierStackCount("modifier_razor_band_amethyst_attack_stacks", caster, stacks)
	end
	razor_band_update_pfx(ability, target)
	if not ability.particles then
		ability.particles = 0
	end
	if #ability.buff_table > 0 and ability:GetGemValue("ruby") > 0 then
		local damage = OverflowProtectedGetAverageTrueAttackDamage(target)*(stacks*ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_GALVANIZED_RAZOR_BAND_GEM_RUBY)/100)
		local stacks = #ability.buff_table
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, ITEM_RPC_GALVANIZED_RAZOR_BAND_RUBY_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				Filters:ApplyItemDamage(enemy, target, damage, DAMAGE_TYPE_PHYSICAL, ability, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NORMAL)
				if ability.particles < 10 then
					ability.particles = ability.particles + 1
					local particleName = "particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf"
					local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_CUSTOMORIGIN, nil)
					local attach_unit_1 = target
					ParticleManager:SetParticleControl(pfx, 0, attach_unit_1:GetAbsOrigin() + Vector(0, 0, attach_unit_1:GetBoundingMaxs().z + 80))
					ParticleManager:SetParticleControl(pfx, 1, enemy:GetAbsOrigin() + Vector(0, 0, enemy:GetBoundingMaxs().z + 100))
					Timers:CreateTimer(0.3, function()
						ParticleManager:DestroyParticle(pfx, false)
					end)
				end
			end
			if #enemies > 5 then
				EmitSoundOn("Items.RazorBandHit", enemies[1])
				EmitSoundOn("Items.RazorBandHit", enemies[2])
				EmitSoundOn("Items.RazorBandHit", enemies[3])
			elseif #enemies > 3 then
				EmitSoundOn("Items.RazorBandHit", enemies[1])
				EmitSoundOn("Items.RazorBandHit", enemies[2])
			else
				EmitSoundOn("Items.RazorBandHit", enemies[1])
			end
		end
	end
	ability.particles = math.max(ability.particles - 1, 0)
end

function razor_band_update_pfx(ability, hero)
	if not ability.razor_pfx and #ability.buff_table > 0 then
		ability.razor_pfx = ParticleManager:CreateParticle("particles/roshpit/items/galvanized_razor_band.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
		ParticleManager:SetParticleControlEnt(ability.razor_pfx, 0, hero, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)
	end
	if #ability.buff_table == 0 then
		if ability.razor_pfx then
			ParticleManager:DestroyParticle(ability.razor_pfx, false)
			ParticleManager:ReleaseParticleIndex(ability.razor_pfx)
			ability.razor_pfx = nil
		end
	end
	local max_pfx_stacks = math.max(ITEM_RPC_GALVANIZED_RAZOR_BAND_MAX_STACKS + 25, ITEM_RPC_GALVANIZED_RAZOR_BAND_MAX_STACKS + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_GALVANIZED_RAZOR_BAND_GEM_SAPPHIRE1))
	if ability.razor_pfx then
		local stacks = #ability.buff_table
		ParticleManager:SetParticleControl(ability.razor_pfx, 1, Vector(stacks/max_pfx_stacks, stacks/max_pfx_stacks, stacks/max_pfx_stacks))
		ParticleManager:SetParticleControl(ability.razor_pfx, 9, Vector(stacks/max_pfx_stacks, stacks/max_pfx_stacks, stacks/max_pfx_stacks))
	end
end

function razor_band_start(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if not ability.buff_table then
		ability.buff_table = {}
	end
	razor_band_update_pfx(ability, target)
end

function razor_band_end(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	ability.buff_table = {}
	EmitSoundOn("Items.RazorBandEnd", target)
	target:RemoveModifierByName("modfier_razor_band_stacks")
	target:RemoveModifierByName("modifier_razor_band_amethyst_attack_stacks")
	razor_band_update_pfx(ability, target)
end

function goldbreaker_attack_land(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	local attacker = event.attacker
	local magic_break = Filters:MagicImmuneBreak(attacker, target)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_goldbreaker_effect", {duration = ITEM_RPC_GOLDBREAKER_GAUNTLET_DEBUFF_DURATION})
	if magic_break then
		Filters:GoldbreakerMagicImmuneBreak(attacker, target)
	end
	if ability:GetGemValue("ruby") > 0 then
		local proc = Filters:GetProc(attacker, ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_GOLDBREAKER_GAUNTLET_GEM_RUBY1))
		if proc then
			local immune_duration = ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_GOLDBREAKER_GAUNTLET_GEM_RUBY2)
			ability:ApplyDataDrivenModifier(caster, target, "modifier_black_King_bar_immunity", {duration = immune_duration})
		end
	end
end

function goldbreaker_thinker(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	local hero = caster.hero
	if ability:GetGemValue("amethyst") > 0 then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), hero:GetAbsOrigin(), nil, ITEM_RPC_GOLDBREAKER_GAUNTLET_AMETHYST_RANGE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				local proc_chance = ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_GOLDBREAKER_GAUNTLET_GEM_AMETHYST1)
				local proc = Filters:GetProc(hero, proc_chance)
				if proc then
					local magic_immune_duration = ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_GOLDBREAKER_GAUNTLET_GEM_AMETHYST2)
					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_black_King_bar_immunity", {duration = magic_immune_duration})
				end
			end
		end
	end	
end

function knight_hawk_think(event)
	local ability = event.ability
	local caster = event.caster
	local hero = event.target
	local movespeed = hero:GetBaseMoveSpeed()
	local movespeedModifier = hero:GetMoveSpeedModifier(movespeed, false)
	local threshold = KNIGHT_HAWK_MS_THRESHOLD_FOR_SPEED_BURST + ability:GetFinalGemPropertyValue("sapphire", KNIGHT_HAWK_SAPPHIRE)
	if movespeedModifier <= threshold then
		event.ability:ApplyDataDrivenModifier(event.caster, hero, "modifier_knight_hawk_helm_speed", {duration = KNIGHT_HAWK_MS_BUFF_DURATION})
		if ability:GetRuneValue("amethyst") > 0 then
			event.ability:ApplyDataDrivenModifier(event.caster, hero, "modifier_knight_hawk_amethyst_burst_bonus", {duration = KNIGHT_HAWK_MS_BUFF_DURATION})
			hero:SetModifierStackCount("modifier_knight_hawk_amethyst_burst_bonus", caster, ability:GetFinalGemPropertyValue("amethyst", KNIGHT_HAWK_AMETHYST))
		end
	end	
end

function knight_hawk_bonus_speed_init(event)
	local target = event.target
	local pfx = CustomAbilities:QuickAttachParticle("particles/econ/items/rubick/rubick_arcana/rbck_arc_skywrath_mage_mystic_flare_ambient_hit.vpcf", target, 3)
	ParticleManager:SetParticleControl(pfx, 1, Vector(140, 140, 140))
end

function knight_hawk_base_init(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	-- target:AddNewModifier( caster, ability, "modifier_knight_hawk_lua", {} )
end

function knight_hawk_base_end(event)
	local target = event.target
	target:RemoveModifierByName("modifier_knight_hawk_lua")
end

function erudite_teacher_start(event)
	local ability = event.ability
	local caster = event.caster
	local hero = event.target
	if not ability.rubick_apprentice then
		local spawnPos = hero:GetAbsOrigin() + RandomVector(160)
		ability.rubick_apprentice = CreateUnitByName("rubick_apprentice", spawnPos, true, nil, nil, hero:GetTeamNumber())
		ability.rubick_apprentice.summoner = hero
		ability.rubick_apprentice:SetOwner(hero)
		ability.rubick_apprentice:SetControllableByPlayer(hero:GetPlayerID(), true)
	    ability.rubick_apprentice.hero = hero


		ability.rubick_apprentice.robes = ability

		ability.rubick_apprentice:AdjustSummon(hero, true, ITEM_RPC_ROBE_OF_THE_ERUDITE_TEACHER_HEALTH_MULT, ITEM_RPC_ROBE_OF_THE_ERUDITE_TEACHER_ATTACK_MULT, 1, 1, 1, 1)

        if ability:GetGemValue("ruby") > 0 then
            local newHealth = ability.rubick_apprentice:GetMaxHealth() + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_ROBE_OF_THE_ERUDITE_TEACHER_GEM_RUBY)
            ability.rubick_apprentice:SetMaxHPandHealToFull(newHealth)
        end
        if ability:GetGemValue("sapphire") > 0 then
            local newDamage = ability.rubick_apprentice:GetAttackDamage() + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_ROBE_OF_THE_ERUDITE_TEACHER_GEM_SAPPHIRE)
            Filters:SetAttackDamage(ability.rubick_apprentice, newDamage)
        end

		ability:ApplyDataDrivenModifier(caster, ability.rubick_apprentice, "modifier_apprentice_ai", {})
		local pfx = CustomAbilities:QuickAttachParticle("particles/econ/items/rubick/rubick_force_ambient/rubick_telekinesis_force.vpcf", ability.rubick_apprentice, 3)
		ParticleManager:SetParticleControl(pfx, 1, ability.rubick_apprentice:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 2, Vector(3,3,3))
		ParticleManager:SetParticleControl(pfx, 3, ability.rubick_apprentice:GetAbsOrigin())
		EmitSoundOn("Items.RubickApprentice.Spawn", ability.rubick_apprentice)

		local apprentice = ability.rubick_apprentice

		Timers:CreateTimer(0.5, function()
			EmitSoundOn("Items.RubickApprentice.Spawn.VO", apprentice)
		end)
		Timers:CreateTimer(0.03, function()
			Events:smoothSizeChange(apprentice, 0.1, 1, 33)
			StartAnimation(apprentice, {duration = 1.3, activity = ACT_DOTA_ATTACK, rate = 1.0})
		end)
		if ability.apprentice_abilities_table then
			Timers:CreateTimer(0.03, function()
				--DeepPrintTable(ability.apprentice_abilities_table)
				for i = 1, #ability.apprentice_abilities_table, 1 do
					local ability_check_name = ability.apprentice_abilities_table[i]
					local steal_index = i - 1
					if not string.match(ability_check_name, "apprentice_spell_steal_") then
						CustomAbilities:AddAndOrSwapSkill(apprentice, "apprentice_spell_steal_"..i, ability_check_name, steal_index)
						local new_ability = apprentice:FindAbilityByName(ability_check_name)
						new_ability:SetLevel(GameState:GetDifficultyFactor())
					end
				end
			end)
		end
		apprentice:FindAbilityByName("hero_summon_ai"):ToggleAbility()
	end
end

function erudite_teacher_end(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	if ability.rubick_apprentice and IsValidEntity(ability.rubick_apprentice) then
		ability.rubick_apprentice:ForceKill(false)
		local rubick = ability.rubick_apprentice
		ability.rubick_apprentice = false
		Timers:CreateTimer(5, function()
			if IsValidEntity(rubick) then
				UTIL_Remove(rubick)
			end
		end)
	end
end

function apprentice_spell_steal_phase(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	EmitSoundOn("Items.RubickApprentice.Spellsteal.Phase", caster)
	local pfx = CustomAbilities:QuickAttachParticle("particles/econ/items/rubick/rubick_force_ambient/rubick_telekinesis_force.vpcf", caster, 1)
	ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 2, Vector(3,3,3))
	ParticleManager:SetParticleControl(pfx, 3, caster:GetAbsOrigin())
	CustomAbilities:QuickAttachParticle("particles/econ/items/rubick/rubick_force_ambient/rubick_telekinesis_land_force.vpcf", caster, 3)
end

function apprentice_spell_steal_cast(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	local index = event.index
	local steal_index = index - 1
	local success = true
	if not target.dominion then
		Notifications:Top(caster:GetPlayerOwnerID(), {text = "notification_no_dominion", duration = 5, style = {color = "#FF1111"}, continue = true})
		success = false
	end
	local abilitiesTable = {}
	--print(target:GetAbilityCount())
	for i = 0, 12, 1 do
		local abilityCheck = target:GetAbilityByIndex(i)
		if abilityCheck then
			if abilityCheck:IsHidden() then
			else
				table.insert(abilitiesTable, abilityCheck)
			end
		end
	end
	local new_ability = nil
	local new_ability_name = nil
	if #abilitiesTable > 0 then
		new_ability = abilitiesTable[RandomInt(1, #abilitiesTable)]
		new_ability_name = new_ability:GetAbilityName()
		if caster:HasAbility(new_ability_name) then
			success = false
		end
	else
		success = false
	end
	if success then
		CustomAbilities:AddAndOrSwapSkill(caster, ability:GetAbilityName(), new_ability_name, steal_index)
		local new_ability = caster:FindAbilityByName(new_ability_name)
		new_ability:SetLevel(GameState:GetDifficultyFactor())
		local pfx = CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_rubick/rubick_spell_steal.vpcf", target, 3)
		ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin()+Vector(0,0,60))
		EmitSoundOn("Items.RubickApprentice.Spellsteal.Success", caster)
		local apprentice_abilities_table = {}
		for i = 0, 2, 1 do
			local ability_check = caster:GetAbilityByIndex(i)
			local ability_name = ability_check:GetAbilityName()
			table.insert(apprentice_abilities_table, ability_name)
		end
		local robe = caster.summoner.body
		robe.apprentice_abilities_table = apprentice_abilities_table
	else
		CustomAbilities:QuickParticleAtPoint("particles/roshpit/axe/red_general_ulti_cast_assassin_trap_explode_beam.vpcf", caster:GetAbsOrigin(), 1.5)
		EmitSoundOn("Items.RubickApprentice.Spellsteal.Fail", caster)
	end
end

function rubick_apprentice_reset_phase(event)
	local caster = event.caster
	CustomAbilities:QuickParticleAtPoint("particles/roshpit/axe/red_general_ulti_cast_assassin_trap_explode_beam.vpcf", caster:GetAbsOrigin(), 1.5)
	EmitSoundOn("Items.RubickApprentice.Reset.VO", caster)
end


function rubick_apprentice_reset(event)
	local caster = event.caster

	local modifiers = caster:FindAllModifiers()
	for i = 0, 2, 1 do
		for j = 1, #modifiers, 1 do
			local modifier = modifiers[j]
			if modifier:GetRemainingTime() < 5 then
				if modifier:GetAbility() == caster:GetAbilityByIndex(i) then
					caster:RemoveModifierByName(modifier:GetName())
				end
			end
		end
	end


	for i = 0, 2, 1 do
		local stolen_ability = caster:GetAbilityByIndex(i)
		local spell_steal_index = i + 1
		local stolen_ability_name = stolen_ability:GetAbilityName()
		--print(stolen_ability_name)
		if not string.match(stolen_ability_name, "apprentice_spell_steal_") then
			CustomAbilities:AddAndOrSwapSkill(caster, stolen_ability:GetAbilityName(), "apprentice_spell_steal_"..spell_steal_index, i)
			if IsValidEntity(stolen_ability) then
				UTIL_Remove(stolen_ability)
			end
		end
	end
	CustomAbilities:QuickParticleAtPoint("particles/roshpit/axe/red_general_ulti_cast_assassin_trap_explode_beam.vpcf", caster:GetAbsOrigin(), 1.5)
	EmitSoundOn("Items.RubickApprentice.Die.VO", caster)
	EmitSoundOn("Items.RubickApprentice.Spellsteal.Reset", caster)
	CustomAbilities:QuickAttachParticle("particles/econ/items/rubick/rubick_force_ambient/rubick_telekinesis_land_force.vpcf", caster, 3)
	StartAnimation(caster, {duration = 1.3, activity = ACT_DOTA_ATTACK, rate = 1.3})
end

function dead_apprentice(event)
	local apprentice = event.unit
	local hero = apprentice.hero
	local ability = event.ability
	local apprentice_abilities_table = {}
	for i = 0, 2, 1 do
		local ability_check = apprentice:GetAbilityByIndex(i)
		local ability_name = ability_check:GetAbilityName()
		table.insert(apprentice_abilities_table, ability_name)
	end
	CustomAbilities:QuickParticleAtPoint("particles/econ/items/rubick/rubick_force_ambient/rubick_telekinesis_land_force.vpcf", apprentice:GetAbsOrigin(), 3)
	EmitSoundOn("Items.RubickApprentice.Die.VO", apprentice)
	ability.rubick_apprentice = nil
	ability.apprentice_abilities_table = apprentice_abilities_table
	ability.apprentice_death_time = GameRules:GetGameTime()
end

function erudite_teacher_robes_think(event)
	local ability = event.ability
	local caster = event.caster
	local hero = event.target
	if ability.apprentice_abilities_table and ability.apprentice_death_time then
		local respawn_time = math.max(10 - ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_ROBE_OF_THE_ERUDITE_TEACHER_GEM_EMERALD), 1)
		if GameRules:GetGameTime() - ability.apprentice_death_time > respawn_time then
			local abilities_table = ability.apprentice_abilities_table

			local eventTable = {}
			eventTable.ability = ability
			eventTable.caster = caster
			eventTable.target = hero
			eventTable.abilities_table = ability.apprentice_abilities_table
			erudite_teacher_start(eventTable)

		end
	end
end

function pivotal_swift_think(event)
	local ability = event.ability
	local caster = event.caster
	local hero = event.target

	if hero:HasModifier("modifier_pivotal_swiftboots_speed_decay") then
		local speed_duration =  ITEM_RPC_PIVOTAL_SWIFTBOOTS_BURST_DURATION + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_PIVOTAL_SWIFTBOOTS_GEM_RUBY2)
		local current_stacks = hero:GetModifierStackCount("modifier_pivotal_swiftboots_speed_decay", caster)
		local movespeed_bonus = ITEM_RPC_PIVOTAL_SWIFTBOOTS_MS + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_PIVOTAL_SWIFTBOOTS_GEM_RUBY1)
		local new_stacks = current_stacks - (movespeed_bonus/(speed_duration*10))
		hero:SetModifierStackCount("modifier_pivotal_swiftboots_speed_decay", caster, new_stacks)
		--print(current_stacks)
	end
		
end

function magistrates_hood_thinker(event)
	-- --print("magistrates_hood_thinker")
	local ability = event.ability
	local caster = event.caster
	local hero = event.target
	local current_stacks = hero:GetModifierStackCount("modifier_magistrates_hood_charges", caster)
	if current_stacks and type(current_stacks) == "number" then
		local max_charges = MAGISTRATE_HOOD_MAX_CHARGES + ability:GetFinalGemPropertyValue("ruby", MAGISTRATE_RUBY)
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_magistrates_hood_charges", {})
		hero:SetModifierStackCount("modifier_magistrates_hood_charges", caster, math.min(max_charges, current_stacks + 1))
	end
end

function nethergrasp_thinker(event)
	local ability = event.ability
	local caster = event.caster
	local hero = event.target

	if not ability.nethergrasp_table then
		ability.nethergrasp_table = {}
		ability.pfx_table = {}
	end
	if not ability.interval then
		ability.interval = 0
	end
	local grasp_break_table = {}
	local new_grasp_table = {}
	if #ability.nethergrasp_table > 0 then
	    for i = 1, #ability.nethergrasp_table, 1 do
	        local nether = ability.nethergrasp_table[i]
	        if nether then
		        local target = EntIndexToHScript(nether.entindex)
		        if IsValidEntity(target) and target:IsAlive() and nether.active then
			        local distance = WallPhysics:GetDistance2d(target:GetAbsOrigin(), hero:GetAbsOrigin())
			        nether.distance = distance
			       	if i%#ability.nethergrasp_table == ability.interval then
			       		if hero:Script_GetAttackRange() + 100 >= distance then
			       			Filters:PerformAttackSpecial(hero, target, true, true, true, false, true, false, false)
			       			StartAnimation(hero, {duration = 0.2, activity = ACT_DOTA_ATTACK, rate = 2.0})
			       		end
			       	end
			       	local break_distance = ITEM_RPC_NETHERGRASP_PALISADE_BREAK_DISTANCE + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_NETHERGRASP_PALISADE_GEM_RUBY1)
			        if distance > break_distance then
			        	table.insert(grasp_break_table, nether.entindex)
			        end
			        if not target:IsAlive() then
			        	table.insert(grasp_break_table, nether.entindex)
			        end
			        table.insert(new_grasp_table, nether)
			    else	
		            ParticleManager:DestroyParticle(nether.pfx, false)
		            ParticleManager:ReleaseParticleIndex(nether.pfx)	    	
			    end
		    end
	    end
	end
	ability.nethergrasp_table = new_grasp_table
    for i = 1, #grasp_break_table, 1 do
    	local target = EntIndexToHScript(grasp_break_table[i])
    	target:RemoveModifierByName("modifier_nethergrasp_linked")
    end
	ability.interval = ability.interval + 1
	if ability.interval >= #ability.nethergrasp_table then
		ability.interval = 0
	end
end

function nethergrasp_owner_die(event)
	local ability = event.ability
	local caster = event.caster
	local hero = event.unit
	for i = 1, #ability.pfx_table, 1 do
		ParticleManager:DestroyParticle(ability.pfx_table[i], false)
	end
	ability.nethergrasp_table = {}	
end

function nethergrasp_grip_end(event)
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
	local target = event.target

    -- local new_nethergrasp_table = {}
    for i = 1, #ability.nethergrasp_table, 1 do
        local nether = ability.nethergrasp_table[i]
        if nether.entindex == target:GetEntityIndex() then
            nether.active = false
        else
            -- table.insert(new_nethergrasp_table, nether)
        end
    end

    -- ability.nethergrasp_table = new_nethergrasp_table
    Timers:CreateTimer(0.03, function()
    	FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
    end)
end

function nethergrasp_owner_end2(event)
	event.target = event.unit
	-- nethergrasp_grip_end(event)
end

function nethergrasp_grip_thinker(event)
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
	local target = event.target
	local nether = nil
    for i = 1, #ability.nethergrasp_table, 1 do
        if ability.nethergrasp_table[i].entindex == target:GetEntityIndex() then
            nether = ability.nethergrasp_table[i]
            break
        end
    end
	if nether and nether.distance then
		if target.pushLock then
			return false
		end
		if target.jumpLock then
			return false
		end
		local range = hero:Script_GetAttackRange()
		local pullSpeedBonus = ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_NETHERGRASP_PALISADE_GEM_SAPPHIRE2)
		if nether.distance > range then
			local pullSpeed = math.min(18 + pullSpeedBonus, GameRules:GetGameTime() - nether.create_time + 5 + pullSpeedBonus)
			pullSpeed = math.max(pullSpeed, 5 + pullSpeedBonus)
			if target:GetEnemyTier() == ENEMY_TYPE_MINI_BOSS then
				pullSpeed = pullSpeed*0.6
			elseif target:GetEnemyTier() == ENEMY_TYPE_BOSS then
				pullSpeed = pullSpeed*0.3
			end
			local pullDirection = (hero:GetAbsOrigin() - target:GetAbsOrigin()):Normalized()
			target:SetAbsOrigin(target:GetAbsOrigin()+pullDirection*pullSpeed)
			--print(pullSpeed)
		end
	end
end

function unequip_inspiration_ring(event)
	local target = event.target
	local ability = event.ability
	CustomGameEventManager:Send_ServerToPlayer(target:GetPlayerOwner(), "inspiration_ring", {abilities_cast = {false, false, false, false}, ring_name = ability:GetAbilityName(), clear = 1, color = "none"})
end

function alien_armor_die(event)
	local hero = event.unit
	local caster = event.caster
	local ability = event.ability
	local particle = "particles/econ/items/enigma/enigma_absolute_armour/enigma_absolute_armour_body_ambient.vpcf"

    if not ability.illusion_table then
        ability.illusion_table = {}
    end
    local new_body_illusion_table = {}
    for i = 1, #ability.illusion_table, 1 do
        if IsValidEntity(ability.illusion_table[i]) and ability.illusion_table[i]:IsAlive() then
        	local modifier = ability.illusion_table[i]:FindModifierByName("modifier_illusion")
        	-- if modifier:GetRemainingTime() > 3 then
            	table.insert(new_body_illusion_table, ability.illusion_table[i])
            -- end
        end
    end
    table.insert(new_body_illusion_table, illusion)
    ability.illusion_table = new_body_illusion_table

    local randomIllusion = ability.illusion_table[RandomInt(1, #ability.illusion_table)]
    if IsValidEntity(randomIllusion) then
    	ability:ApplyDataDrivenModifier(caster, randomIllusion, "modifier_alien_illusion_respawning_effect", {})
	    local modifier = randomIllusion:FindModifierByName("modifier_illusion")
	    modifier:SetDuration(ITEM_RPC_ALIEN_ARMOR_RESPAWN_DELAY+0.1, true)
	    CustomAbilities:QuickAttachParticle("particles/econ/items/enigma/enigma_absolute_armour/enigma_absolute_armour_body_ambient.vpcf", randomIllusion, ITEM_RPC_ALIEN_ARMOR_RESPAWN_DELAY)
	    Timers:CreateTimer(ITEM_RPC_ALIEN_ARMOR_RESPAWN_DELAY, function()
	    	if not hero:IsAlive() and randomIllusion:IsAlive() then
	    		local respawnPoint = randomIllusion:GetAbsOrigin()
	    		local fv = randomIllusion:GetForwardVector()
				hero:RespawnHero(false, false)
				hero:SetAbsOrigin(respawnPoint)
				hero:SetForwardVector(fv)
				local pfx = CustomAbilities:QuickAttachParticle("particles/econ/items/riki/riki_immortal_ti6/riki_immortal_ti6_blinkstrike.vpcf", hero, 3)
				ParticleManager:SetParticleControl(pfx, 1, hero:GetAbsOrigin())
				EmitSoundOn("Items.AlienArmor.Respawn", hero)
	    	end
	    end)
	end
end

function carbuncle_hit(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local carbuncle_data = target.carbuncle_data

    local damage = math.ceil(carbuncle_data.damage)*(1 + ability:GetFinalGemPropertyValue("ruby", CARBUNCLE_RUBY)/10)

    Filters:ApplyItemDamage(carbuncle_data.attacker, target, damage, carbuncle_data.damagetype, ability, RPC_ELEMENT_FIRE, RPC_ELEMENT_ARCANE)
    EmitSoundOn("RPC.Carbuncle.ReflectImpact", target)
    CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_medusa/carbuncle_ruby_shell_cast.vpcf", target, 0.8)

    local stun_duration = ability:GetFinalGemPropertyValue("amethyst", CARBUNCLE_AMETHYST)
    if stun_duration > 0 then
    	Filters:ApplyStun(carbuncle_data.attacker, stun_duration, target)
    end
end

function ruby_dragon_init(event)
	local ability = event.ability
	local caster = event.caster
	local hero = event.target
	if not ability.dragon then
		local spawnPos = hero:GetAbsOrigin() - hero:GetForwardVector()*440
		local dragon = CreateUnitByName("ruby_dragon_3", spawnPos, true, nil, nil, hero:GetTeamNumber())
		dragon.summoner = hero
		dragon:SetOwner(hero)
		dragon:SetControllableByPlayer(hero:GetPlayerID(), true)
	    dragon.hero = hero
	    dragon.entering = true
	    dragon:SetSkin(1)
	    dragon:SetModelScale(0.4)
	    dragon:SetForwardVector(hero:GetForwardVector())
	    dragon:SetAbsOrigin(dragon:GetAbsOrigin() + Vector(0, 0, 800))
	    local dragonAbility = dragon:FindAbilityByName("ruby_dragon3_ability")
	    dragonAbility:ApplyDataDrivenModifier(dragon, dragon, "ruby_dragon_cinematic", {duration = 1.5})
	    Timers:CreateTimer(0.5, function()
	        EmitSoundOn("RPCItem.RubyDragonEnter", dragon)
	    end)
	    ability.dragon = dragon
	    dragon:AddAbility("ruby_dragon_toggle_ai"):SetLevel(1)
	    dragon:FindAbilityByName("ruby_dragon_toggle_ai"):ToggleAbility()
	    dragon:AddAbility("ruby_dragon_flame_breath"):SetLevel(1)
	    dragon.attack_aoe = RUBY_DRAGON_AMETHYST_ATTACK_SPLASH_AOE

	    dragon:SetRoshpitLevel(hero:GetLevel())
		dragon:SetMaxHPandHealToFull(RUBY_DRAGON_HP_PER_HERO_LEVEL*hero:GetLevel())
		dragon:SetBaseDamageMax(hero:GetLevel()*RUBY_DRAGON_ATK_POWER_PER_HERO_LEVEL+hero.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("ruby", RUBY_DRAGON_RUBY))
		dragon:SetBaseDamageMin(hero:GetLevel()*RUBY_DRAGON_ATK_POWER_PER_HERO_LEVEL+hero.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("ruby", RUBY_DRAGON_RUBY))

		dragon:SetBaseRoshpitArmor(hero:GetRoshpitArmor())
		dragon:SetBaseRoshpitMagicArmor(hero:GetRoshpitMagicArmor())
		dragon:SetBaseRoshpitArmorPierce(hero:GetRoshpitArmorPierce())
		dragon:SetBaseRoshpitSpellPierce(hero:GetRoshpitSpellPierce())

		if hero.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetGemValue("sapphire") > 0 then
			ability:ApplyDataDrivenModifier(caster, dragon, "modifier_ruby_dragon_sapphire_speed", {})
			dragon:SetModifierStackCount("modifier_ruby_dragon_sapphire_speed", caster, hero.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("sapphire", RUBY_DRAGON_SAPPHIRE))
		end
		hero.ruby_dragon = dragon
		Timers:CreateTimer(1.6, function()
			FindClearSpaceForUnit(dragon, dragon:GetAbsOrigin(), false)
		end)
	end
end

function ruby_dragon_unequip(event)
	local ability = event.ability
	local caster = event.caster
	local hero = event.target
	local dragon = ability.dragon
    local dragonAbility = dragon:FindAbilityByName("ruby_dragon3_ability")
    dragon:RemoveModifierByName("ruby_dragon_regenerating")
    ability.dragon = nil
    dragonAbility:ApplyDataDrivenModifier(dragon, dragon, "ruby_dragon_cinematic", {duration = 1.5})
	dragon.entering = false
	
	EmitSoundOn("RPCItem.RubyDragonEnter", dragon)
	Timers:CreateTimer(1.5, function()
		dragon:RemoveModifierByName("ruby_dragon_cinematic")
		UTIL_Remove(dragon)
	end)
end

function ruby_dragon_entering_think(event)
	local caster = event.caster
	local ability = event.ability
	local dragon = caster
	if dragon.entering then
		dragon:SetAbsOrigin(dragon:GetAbsOrigin() + Vector(0, 0, -16) + dragon:GetForwardVector() * 20)
	else
		dragon:SetAbsOrigin(dragon:GetAbsOrigin() + Vector(0, 0, 13) + dragon:GetForwardVector() * 20)
	end
end

function ruby_dragon_constant_think(event)
	local caster = event.caster
	local ability = event.ability
	local hero = caster.hero
	if caster.roshpit_attributes.roshpit_level ~= hero:GetLevel() then
		caster:SetRoshpitLevel(hero:GetLevel())
		caster:SetMaxHPandHealToFull(RUBY_DRAGON_HP_PER_HERO_LEVEL*hero:GetLevel())
	end
	if not caster.ruby_dragon_gem_bonus_damage_applied then
		caster.ruby_dragon_gem_bonus_damage_applied = true
		local damageBuff = hero:GetLevel()*(RUBY_DRAGON_ATK_POWER_PER_HERO_LEVEL+hero.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("ruby", RUBY_DRAGON_RUBY))
		print("[ruby_dragon_constant_think] damageBuff "..tostring(damageBuff))
		caster:SetBaseDamageMax(damageBuff)
		caster:SetBaseDamageMin(damageBuff)
	end
	caster:SetBaseRoshpitArmor(hero:GetRoshpitArmor())
	caster:SetBaseRoshpitMagicArmor(hero:GetRoshpitMagicArmor())
	caster:SetBaseRoshpitArmorPierce(hero:GetRoshpitArmorPierce())
	caster:SetBaseRoshpitSpellPierce(hero:GetRoshpitSpellPierce())
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), caster.hero:GetAbsOrigin())
	if distance > 2500 then
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_red.vpcf", caster, 3)
		EmitSoundOn("RPC.RubyDragon.Teleport", caster)
		FindClearSpaceForUnit(caster, hero:GetAbsOrigin()+RandomVector(240), false)
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_red.vpcf", caster, 3)
		EmitSoundOn("RPC.RubyDragon.Teleport", caster)
	end
	if caster:GetHealth() < 10 then
		if not caster:HasModifier("ruby_dragon_regenerating") then
			caster.regen_interval = 0
			caster.regen_total_ticks = math.floor(RUBY_DRAGON_REGEN_TIME/0.03)
			EmitSoundOn("RPCItem.RubyDragonEnter", caster)
			ability:ApplyDataDrivenModifier(caster, caster, "ruby_dragon_regenerating", {})
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_red.vpcf", caster, 3)
			caster:SetModel("models/items/phoenix/ultimate/blazing_wing_blazing_egg/blazing_wing_blazing_egg.vmdl")
			caster:SetOriginalModel("models/items/phoenix/ultimate/blazing_wing_blazing_egg/blazing_wing_blazing_egg.vmdl")
		end
	end
end

function ruby_dragon_ai_on(event)
	local caster = event.caster
	caster:SetAcquisitionRange(900)
end

function ruby_dragon_ai_off(event)
	local caster = event.caster
	caster:SetAcquisitionRange(0)
end

function ruby_dragon_ai_think(event)
	local caster = event.caster
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), caster.hero:GetAbsOrigin())
	if not caster.moveLock then
		if distance > 1200 then
			caster:MoveToPosition(caster.hero:GetAbsOrigin()+RandomVector(240))
			caster.moveLock = true
			Timers:CreateTimer(4, function()
				caster.moveLock = false
			end)
		elseif distance > 300 then
			caster:MoveToPositionAggressive(caster.hero:GetAbsOrigin()+RandomVector(240))
			caster.moveLock = true
			Timers:CreateTimer(4, function()
				caster.moveLock = false
			end)
		end
	end
	local fire_breath_ability = caster:FindAbilityByName("ruby_dragon_flame_breath")
	if fire_breath_ability:IsFullyCastable() then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin()+caster:GetForwardVector()*500, nil, 650, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = fire_breath_ability:entindex(),
			}
			ExecuteOrderFromTable(newOrder)
			return			
		end
	end
end

function ruby_dragon_regenerating_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster:GetAbsOrigin().z - GetGroundPosition(caster:GetAbsOrigin(), caster).z > -200 then
		caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,3))
	end
	caster.regen_interval = caster.regen_interval + 1
	caster:SetHealth(caster:GetMaxHealth()*caster.regen_interval*(1/caster.regen_total_ticks))
	if caster.regen_total_ticks == caster.regen_interval then
		caster:RemoveModifierByName("ruby_dragon_regenerating")
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		EmitSoundOn("RPCItem.RubyDragonEnter", caster)
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_red.vpcf", caster, 3)
		caster:SetOriginalModel("models/items/dragon_knight/fireborn_dragon/fireborn_dragon.vmdl")
		caster:SetModel("models/items/dragon_knight/fireborn_dragon/fireborn_dragon.vmdl")
		caster:SetSkin(1)
	end
end

function ruby_dragon_fire_breath(event)
	local caster = event.caster
	local ability = event.ability
	local location = caster:GetOrigin()
	local abilityLevel = ability:GetLevel()
	local forwardVector = caster:GetForwardVector()
	local fv = forwardVector
	local start_radius = 200
	local end_radius = 340
	local range = 800
	local speed = 1000
	local projectileParticle = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf"
	local projectile_origin = caster:GetAbsOrigin() + caster:GetForwardVector()*60
	local info =
	{
		Ability = ability,
		EffectName = projectileParticle,
		vSpawnOrigin = projectile_origin,
		fDistance = range,
		fStartRadius = start_radius,
		fEndRadius = end_radius,
		Source = caster,
		StartPosition = "attach_attack1",
		bHasFrontalCone = true,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
		vVelocity = fv * speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
end

function ruby_dragon_fire_breath_hit(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)*event.attack_mult

	Filters:ApplyItemDamage(target, caster.hero, damage, DAMAGE_TYPE_MAGICAL, caster.hero.equipped_gear[RPC_GEAR_SLOT_HEAD], RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
	if caster.hero.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetGemValue("emerald") > 0 then
		ability.burn_damage = damage*(caster.hero.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("emerald", RUBY_DRAGON_EMERALD)/100)
		ability:ApplyDataDrivenModifier(caster, target, "ruby_dragon_burn", {duration = RUBY_DRAGON_EMERALD_BURN_DURATION})
	end
end

function ruby_dragon_fire_breath_burn(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	--print("BURN THINK?")
	--print(ability.burn_damage)
	Filters:ApplyItemDamage(target, caster.hero, ability.burn_damage, DAMAGE_TYPE_MAGICAL, caster.hero.equipped_gear[RPC_GEAR_SLOT_HEAD], RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
end

function emerald_douli_thinker(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability

	if target:GetMana() > target:GetMaxMana()*0.03 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_douli_mana_up", {})
	else
		target:RemoveModifierByName("modifier_douli_mana_up")
	end
end

function luma_thinker(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	if ability:GetGemValue("sapphire") > 0 then
		local vision_radius = ability:GetFinalGemPropertyValue("sapphire", LUMA_SAPPHIRE1)
		AddFOWViewer(target:GetTeamNumber(), target:GetAbsOrigin(), vision_radius, 2, false)
	end
end

function thorok_on(event)
	local caster = event.caster
	caster:SetAcquisitionRange(900)
end

function thorok_off(event)
	local caster = event.caster
	caster:SetAcquisitionRange(0)
end

function thorok_think(event)
	local caster = event.caster
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), caster.hero:GetAbsOrigin())
	if not caster.moveLock then
		if distance > 1200 then
			caster:MoveToPosition(caster.hero:GetAbsOrigin()+RandomVector(240))
			caster.moveLock = true
			Timers:CreateTimer(4, function()
				caster.moveLock = false
			end)
		elseif distance > 300 then
			caster:MoveToPositionAggressive(caster.hero:GetAbsOrigin()+RandomVector(240))
			caster.moveLock = true
			Timers:CreateTimer(4, function()
				caster.moveLock = false
			end)
		end
	end
end

function scourge_knight_poison_think(event)
	local caster = event.caster.hero
	local target = event.target
	local ability = event.ability
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)*(ability:GetFinalGemPropertyValue("emerald", SCOURGE_KNIGHT_EMERALD)/100)
	Filters:ApplyItemDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_POISON)	
end


function odin_beam_casting_thinker(event)
	local caster = event.target
	local ability = event.ability
	local beamLength = ODIN_BEAM_LENGTH + ability:GetFinalGemPropertyValue("emerald", ODIN_EMERALD)

	for i = 1, #ability.beamTable, 1 do
		local beam = ability.beamTable[i]
		local damage = beam.damage
		if beam and beam.target then
			if not beam.distance_moved then
				beam.distance_moved = 0
			end
			local moveDirection = ((beam.target - beam.position) * Vector(1, 1, 0)):Normalized()
			beam.distance_moved = beam.distance_moved + 100
			beam.position = beam.startPoint + beam.distance_moved * moveDirection

			if beam.pfx then
				local pfx = beam.pfx
				local particleVector = beam.position
				ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin() + Vector(0, 0, 90))
				ParticleManager:SetParticleControl(pfx, 1, particleVector + Vector(0, 0, 90))
				ParticleManager:SetParticleControl(pfx, 3, particleVector + Vector(0, 0, 90))
				ParticleManager:SetParticleControl(pfx, 4, particleVector + Vector(0, 0, 90))
			end
			if beam.interval % 3 == 0 then
				-- local enemies = FindUnitsInRadius( caster:GetTeamNumber(), beam.position, nil, 80, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
				local vStartPos = beam.startPoint
				local vEndPos = beam.position
				--print("HERE?")
				local width = 140
				local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
				local types = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
				local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
				local enemies = FindUnitsInLine(caster:GetTeamNumber(), vStartPos, vEndPos, nil, 120, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
				if #enemies > 0 then
					for _, enemy in pairs(enemies) do
						--print("DAMAGE SOMEONE")
						Filters:ApplyItemDamage(enemy, caster, damage, DAMAGE_TYPE_PURE, ability, RPC_ELEMENT_DRAGON, RPC_ELEMENT_NONE)	
					end
				end
			end
			local distance = WallPhysics:GetDistance2d(beam.position, caster:GetAbsOrigin())
			if beam.distance_moved >= beamLength then
				-- beam.position = beam.target
				beam.active = false
			end
			beam.interval = beam.interval + 1
		end
	end
	reindex_odin_beam_table(caster, ability)
end

function reindex_odin_beam_table(caster, ability)
	local newBeamTable = {}
	for i = 1, #ability.beamTable, 1 do
		local beam = ability.beamTable[i]
		if beam.active then
			table.insert(newBeamTable, beam)
		else
			Timers:CreateTimer(1, function()
				ParticleManager:DestroyParticle(beam.pfx, false)
			end)
		end
	end
	ability.beamTable = newBeamTable
	if #ability.beamTable == 0 then
		caster:RemoveModifierByName("modifier_odin_beam_casting")
	end
end

function odin_beam_pushback(event)
	local hero = event.target
	local caster = event.caster
	local ability = event.ability
	local obstruction = WallPhysics:FindNearestObstruction(hero:GetAbsOrigin())
	local newPosition = hero:GetAbsOrigin()+ability.pushBack*50
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition, hero)
	if not blockUnit then
		caster:SetOrigin(newPosition)
	end
	StartAnimation(hero, {duration = 0.25, activity = ACT_DOTA_FLAIL, rate = 1.6, translate="forcestaff_friendly"})
end

function odin_beam_pushback_end(event)
	FindClearSpaceForUnit(event.target, event.target:GetAbsOrigin(), false)
end

function eternal_night_take_damage(event)
	local hero = event.target
	local ability = event.ability
	local attacker = event.attacker
	local caster = event.caster
	local proc = Filters:GetProc(hero, ETERNAL_NIGHT_SLEEP_CHANCE)
	if proc then
		Filters:EternalNightTrigger(hero, attacker, caster, ability)
	end
end

function eternal_night_sleeping_take_damage(event)
	local target = event.unit
	if not target:HasModifier("modifier_eternal_night_sleep_unwakable") then
		target:RemoveModifierByName("modifier_eternal_night_sleep")
	end
end

function eternal_night_sleeping_take_damage(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability

	local immunity_duration = ETERNAL_NIGHT_SLEEP_IMMUNITY_DURATION
	ability:ApplyDataDrivenModifier(caster, target, "modifier_eternal_night_sleep_immune", {duration = immunity_duration})	
end

function eternal_night_thinker(event)
	local hero = event.target
	local ability = event.ability
	local caster = event.caster
    if ability:GetGemValue("amethyst") > 0 then
    	local sleep_count = 0
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), hero:GetAbsOrigin(), nil, ETERNAL_NIGHT_AMETHYST_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				if enemy:HasModifier("modifier_eternal_night_sleep") then
					sleep_count = sleep_count + 1
				end
			end
		end
		if sleep_count >= ability:GetFinalGemPropertyValue("amethyst", ETERNAL_NIGHT_AMETHYST) then
			if not hero:HasModifier("modifier_invisibility_datadriven") then
		        local pfx2 = CustomAbilities:QuickAttachParticle("particles/roshpit/conjuror/shadow_deity_cloak_of_shadows.vpcf", hero, 2)
		        ParticleManager:SetParticleControl(pfx2, 1, Vector(200, 200, 200))
		    end
	        ability:ApplyDataDrivenModifier(caster, hero, "modifier_invisibility_datadriven", {})
	        hero:AddNewModifier(hero, ability, "modifier_persistent_invisibility", {})
	    else
	    	hero:RemoveModifierByName("modifier_invisibility_datadriven")
	    	hero:RemoveModifierByName("modifier_persistent_invisibility")
	    end
    end

end

function swamp_doctor_think(event)
	local caster = event.target
	local ability = event.ability
	local radius = SWAMP_DOCTOR_BASE_RADIUS + ability:GetFinalGemPropertyValue("emerald", SWAMP_DOCTOR_EMERALD)
	local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
	local healBonus = (caster:GetIntellect() + caster:GetSpirit())*ability:GetFinalGemPropertyValue("amethyst", SWAMP_DOCTOR_AMETHYST)
	if #allies > 0 then
		for _, ally in pairs(allies) do
			local healAmount = ally:GetMaxHealth()*(SWAMP_DOCTOR_HEAL_PCT/100) + healBonus
			healAmount = math.min(ally:GetMaxHealth() - ally:GetHealth(), healAmount)
			Filters:ApplyHeal(caster, ally, healAmount, true, true)
			ability:ApplyDataDrivenModifier(caster, ally, "modifier_inside_swamp_doctor", {duration = SWAMP_DOCTOR_TICK_RATE + 0.25})
			if ability:GetGemValue("sapphire") > 0 then
				ability:ApplyDataDrivenModifier(caster, ally, "modifier_swamp_doctor_sapphire", {duration = SWAMP_DOCTOR_SAPPHIRE_STICKY_DURATION})
				local newStacks = math.min(ally:GetModifierStackCount("modifier_swamp_doctor_sapphire", caster) + 1, SWAMP_DOCTOR_SAPPHIRE_MAX_STACKS)
				ally:SetModifierStackCount("modifier_swamp_doctor_sapphire", caster, newStacks)
			end
		end
	end
end

function swamp_doctor_start(event)
	local hero = event.target
	local ability = event.ability
	local caster = event.caster
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
	end
	local radius = SWAMP_DOCTOR_BASE_RADIUS + ability:GetFinalGemPropertyValue("emerald", SWAMP_DOCTOR_EMERALD)
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_witchdoctor/witchdoctor_voodoo_restoration.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(pfx, 0, hero, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", hero:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 1, 1))
	ParticleManager:SetParticleControl(pfx, 2, Vector(1, 1, 1))
	ability.pfx = pfx
	EmitSoundOn("RPCItems.SwampDoctor.Start", hero)
end

function swamp_doctor_end(event)
	local hero = event.target
	local ability = event.ability
	local caster = event.caster

	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
	end
end

function trickster_init(event)
	local hero = event.target
	local ability = event.ability
	local caster = event.caster
	if not ability.trickster then
		local trickster = CreateUnitByName("trickster_mask_scoundrel", hero:GetAbsOrigin()+RandomVector(300), true, nil, nil, hero:GetTeamNumber())
		CustomAbilities:QuickAttachParticle("particles/econ/events/ti5/blink_dagger_start_smoke_ti5.vpcf", trickster, 3)
		trickster:SetOwner(hero)
		trickster:SetControllableByPlayer(hero:GetPlayerID(), true)
		trickster:SetRenderColor(90, 70, 10)
		trickster.hero = hero
		local scoundrel_ai_ability = trickster:AddAbility("trickster_scoundrel_toggle_ai")
		scoundrel_ai_ability:SetLevel(1)
		scoundrel_ai_ability:ToggleAbility()
		trickster.radius = TRICKSTER_BASE_RADIUS + ability:GetFinalGemPropertyValue("ruby", TRICKSTER_RUBY)
		trickster.pfx = ParticleManager:CreateParticle("particles/roshpit/items/trickster_scoundrel_ring.vpcf", PATTACH_ABSORIGIN_FOLLOW, trickster)
		ParticleManager:SetParticleControlEnt(trickster.pfx, 0, trickster, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", trickster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(trickster.pfx, 2, Vector(trickster.radius, 1, 0))
		trickster:AddNewModifier(trickster, ability, "modifier_persistent_invisibility", {})
		ability.trickster = trickster
		EmitSoundOn("RPCItem.TricksterMask.Loud", trickster)
		ability.trickster:AddNewModifier(caster, nil, 'modifier_movespeed_cap_sonic', {})
		if ability:GetGemValue("sapphire") > 0 then
			scoundrel_ai_ability:ApplyDataDrivenModifier(trickster, trickster, "modifier_scoundrel_ms", {})
			trickster:SetModifierStackCount("modifier_scoundrel_ms", trickster, ability:GetFinalGemPropertyValue("sapphire", TRICKSTER_SAPPHIRE))
		end
	end
end

function trickster_end(event)
	local hero = event.target
	local ability = event.ability
	local caster = event.caster
	if ability.trickster and IsValidEntity(ability.trickster) then
		if ability.trickster.pfx then
			ParticleManager:DestroyParticle(ability.trickster.pfx, false)
		end
		EmitSoundOn("RPCItem.TricksterMask.Loud", ability.trickster)
		CustomAbilities:QuickAttachParticle("particles/econ/events/ti5/blink_dagger_start_smoke_ti5.vpcf", ability.trickster, 3)
		UTIL_Remove(ability.trickster)
		ability.trickster = nil
	end
	hero:RemoveModifierByName("modifier_scoundrel_invis")
	hero:RemoveModifierByName("modifier_invisible")
	hero:RemoveModifierByName("modifier_scoundrel_agility")
end

function trickster_scoundrel_think(event)
	local ability = event.ability
	local caster = event.caster
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), caster.hero:GetAbsOrigin())
	ability.radius = TRICKSTER_BASE_RADIUS + caster.hero.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("ruby", TRICKSTER_RUBY)
	if not ability.hero_position then
		ability.hero_position = caster.hero:GetAbsOrigin()
	end
	if distance > 2500 then
		CustomAbilities:QuickAttachParticle("particles/econ/events/ti5/blink_dagger_start_smoke_ti5.vpcf", caster, 3)
		local target_move_position = caster.hero:GetAbsOrigin() - caster.hero:GetForwardVector()*400
		FindClearSpaceForUnit(caster, target_move_position, false)
		CustomAbilities:QuickAttachParticle("particles/econ/events/ti5/blink_dagger_start_smoke_ti5.vpcf", caster, 3)
		EmitSoundOn("RPCItem.TricksterMask.Loud", caster)
	elseif distance > 900 then
		local target_move_position = caster.hero:GetAbsOrigin() - caster.hero:GetForwardVector()*500
		caster:MoveToPosition(target_move_position)
	end
	if distance <= ability.radius and caster.hero.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetGemValue("emerald") > 0 then
		ability:ApplyDataDrivenModifier(caster, caster.hero, "modifier_scoundrel_agility", {})
	else
		caster.hero:RemoveModifierByName("modifier_scoundrel_agility")
	end
	if distance <= ability.radius and caster.hero.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetGemValue("amethyst") > 0 then
		if caster.hero:HasModifier("modifier_scoundrel_invis_countdown") then
			if ability.hero_position ~= caster.hero:GetAbsOrigin() then
				local countdown_duration = caster.hero.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("amethyst", TRICKSTER_AMETHYST)
				ability:ApplyDataDrivenModifier(caster, caster.hero, "modifier_scoundrel_invis_countdown", {duration = countdown_duration})
			end
		else
			if not caster.hero:HasModifier("modifier_invisible") then
				local countdown_duration = caster.hero.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("amethyst", TRICKSTER_AMETHYST)
				ability:ApplyDataDrivenModifier(caster, caster.hero, "modifier_scoundrel_invis_countdown", {duration = countdown_duration})
			end
		end
	else
		caster.hero:RemoveModifierByName("modifier_scoundrel_invis_countdown")
	end
	if distance > ability.radius then
		caster.hero:RemoveModifierByName("modifier_scoundrel_invis")
		caster.hero:RemoveModifierByName("modifier_invisible")
		caster.hero:RemoveModifierByName("modifier_scoundrel_agility")
	end

	if ability.radius ~= caster.radius then
		local trickster = caster
		caster.radius = ability.radius
		ParticleManager:DestroyParticle(caster.pfx, false)
		trickster.pfx = ParticleManager:CreateParticle("particles/roshpit/items/trickster_scoundrel_ring.vpcf", PATTACH_ABSORIGIN_FOLLOW, trickster)
		ParticleManager:SetParticleControlEnt(trickster.pfx, 0, trickster, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", trickster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(trickster.pfx, 2, Vector(trickster.radius, 1, 0))
	end
	if ability.hero_position ~= caster.hero:GetAbsOrigin() then
		caster.hero:RemoveModifierByName("modifier_scoundrel_invis")
		caster.hero:RemoveModifierByName("modifier_invisible")
	end
	ability.hero_position = caster.hero:GetAbsOrigin()
end

function trickster_scoundrel_on(event)
	local ability = event.ability
	local caster = event.caster
end

function trickster_scoundrel_off(event)
	local ability = event.ability
	local caster = event.caster
end

function scoundrel_invis_countdown_end(event)
	local caster = event.caster
	local ability = event.ability
	if IsValidEntity(caster) then
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), caster.hero:GetAbsOrigin())
		--print("COUNTDOWN END")
		if distance <= ability.radius then
			local hero = caster.hero
			if not hero:HasModifier("modifier_invisible") then
				hero:AddNewModifier(caster, ability, "modifier_invisible", {})
				ability:ApplyDataDrivenModifier(caster, hero, "modifier_scoundrel_invis", {})
				EmitSoundOn("RPCItem.TricksterMask.Invis", hero)
				EmitSoundOn("RPCItem.TricksterMask.Invis.Highlight", hero)
				CustomAbilities:QuickAttachParticle("particles/econ/events/ti5/blink_dagger_start_smoke_ti5.vpcf", hero, 3)
			end
		end
	end
end

function white_mage_init(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target

	if ability:GetGemValue("ruby") > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_white_mage_ruby_regen", {})
		local stacks = ability:GetFinalGemPropertyValue("ruby", WHITE_MAGE_RUBY)*10
		target:SetModifierStackCount("modifier_white_mage_ruby_regen", caster, stacks)
	end
end

function wraith_crown_think(event)
	local caster = event.caster
	local ability = event.ability
	local hero = event.target

	local mana_drain_pct = math.max(WRAITH_CROWN_ETHEREAL_MANA_DRAIN_PCT - ability:GetFinalGemPropertyValue("ruby", WRAITH_CROWN_RUBY), 0)
	local mana_drain = hero:GetMaxMana()*(mana_drain_pct/100)
	hero:ReduceMana(mana_drain)
end

function wraith_crown_amethyst_start(event)
	local target = event.target
	target:AddNoDraw()
end

function wraith_crown_amethyst_end(event)
	local target = event.target
	target:RemoveNoDraw()
end

function wraith_crown_invuln_think(event)
	local target = event.target
	local modifier = target:FindModifierByName("modifier_wraith_crown_cd")
	if modifier then
		local new_duration = modifier:GetRemainingTime() + 0.1
		modifier:SetDuration(new_duration, true)
	end
end

function tanari_wind_armor_inside_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local hero = caster.hero
	if ability:GetGemValue("ruby") > 0 then
		local damage = (hero:GetAgility() + hero:GetIntellect())*ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_ANCIENT_TANARI_WIND_ARMOR_GEM_RUBY)
		Filters:ApplyItemDamage(target, hero, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_WIND, RPC_ELEMENT_NONE)
	end
end

function tanari_wind_armor_aura_create(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if ability:GetGemValue("sapphire") > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_wind_aura_slow_dynamic_as", {})
		target:SetModifierStackCount("modifier_wind_aura_slow_dynamic_as", caster, ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_ANCIENT_TANARI_WIND_ARMOR_GEM_SAPPHIRE))
	end
	if ability:GetGemValue("amethyst") > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_wind_aura_slow_dynamic_blind", {})
		target:SetModifierStackCount("modifier_wind_aura_slow_dynamic_blind", caster, ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_ANCIENT_TANARI_WIND_ARMOR_GEM_AMETHYST))
	end
end

function doomplate_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if ability and IsValidEntity(ability) then
		local hero = caster.hero

		local damage = (hero:GetStrength() + hero:GetAgility() + hero:GetIntellect() + hero:GetSpirit())*ITEM_RPC_DOOMPLATE_DAMAGE_PER_ATTRIBUTES + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_DOOMPLATE_GEM_RUBY)
		Filters:ApplyItemDamage(target, hero, damage, DAMAGE_TYPE_PURE, ability, RPC_ELEMENT_DEMON, RPC_ELEMENT_FIRE)

		local proc = Filters:GetProc(hero, ITEM_RPC_DOOMPLATE_SAPPHIRE_DISARM_CHANCE)
		if proc then
			local duration = ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_DOOMPLATE_GEM_SAPPHIRE)
			ability:ApplyDataDrivenModifier(caster, target, "modifier_doomplate_disarm", {duration = duration})
		end
	else
		target:RemoveModifierByName("modifier_doomplate_doom_enemy_debuff")
	end
end

function dragon_ceremony_init(event)
	local caster = event.caster
	local hero = event.target
	local ability = event.ability
	local player = hero:GetPlayerOwnerID()
	ability.dragon_table = {}
	if ability:GetGemValue("ruby") > 0 then
		local modelScale = 0.35 + ability:GetGemValue("ruby")*0.01
		local dragon = CreateUnitByName("beast_of_ceremony", hero:GetAbsOrigin(), true, nil, nil, hero:GetTeamNumber())
		dragon.owner = hero:GetPlayerOwnerID()
		dragon:SetOwner(hero)
		dragon:SetControllableByPlayer(player, true)
		dragon:AddAbility("dragon_ceremony_ability"):SetLevel(1)
		table.insert(ability.dragon_table, dragon)
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_red_spotlight.vpcf", dragon, 3)
		dragon:SetModel("models/items/dragon_knight/ti9_cache_dk_scorching_amber_dragoon_form/ti9_cache_dk_scorching_amber_dragoon_form.vmdl")
		dragon:SetOriginalModel("models/items/dragon_knight/ti9_cache_dk_scorching_amber_dragoon_form/ti9_cache_dk_scorching_amber_dragoon_form.vmdl")
		dragon:SetModelScale(modelScale)
		dragon:SetSkin(1)
		dragon.type = "ruby"
		dragon.hero = hero
		StartAnimation(hero, {duration = 1, activity = ACT_DOTA_CAST_ABILITY_4, rate = 1.0})
	end
	if ability:GetGemValue("emerald") > 0 then
		local modelScale = 0.35 + ability:GetGemValue("emerald")*0.01
		local dragon = CreateUnitByName("beast_of_ceremony", hero:GetAbsOrigin(), true, nil, nil, hero:GetTeamNumber())
		dragon.owner = hero:GetPlayerOwnerID()
		dragon:SetOwner(hero)
		dragon:SetControllableByPlayer(player, true)
		dragon:AddAbility("dragon_ceremony_ability"):SetLevel(1)
		table.insert(ability.dragon_table, dragon)
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_red_spotlight.vpcf", dragon, 3)
		dragon:SetModel("models/items/dragon_knight/ti9_cache_dk_scorching_amber_dragoon_form/ti9_cache_dk_scorching_amber_dragoon_form.vmdl")
		dragon:SetOriginalModel("models/items/dragon_knight/ti9_cache_dk_scorching_amber_dragoon_form/ti9_cache_dk_scorching_amber_dragoon_form.vmdl")
		dragon:SetModelScale(modelScale)
		dragon:SetSkin(0)
		dragon.type = "emerald"
		dragon.hero = hero
		StartAnimation(hero, {duration = 1, activity = ACT_DOTA_CAST_ABILITY_4, rate = 1.0})
	end
	if ability:GetGemValue("sapphire") > 0 then
		local modelScale = 0.35 + ability:GetGemValue("sapphire")*0.01
		local dragon = CreateUnitByName("beast_of_ceremony", hero:GetAbsOrigin(), true, nil, nil, hero:GetTeamNumber())
		dragon.owner = hero:GetPlayerOwnerID()
		dragon:SetOwner(hero)
		dragon:SetControllableByPlayer(player, true)
		dragon:AddAbility("dragon_ceremony_ability"):SetLevel(1)
		table.insert(ability.dragon_table, dragon)
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_red_spotlight.vpcf", dragon, 3)
		dragon:SetModel("models/items/dragon_knight/ti9_cache_dk_scorching_amber_dragoon_form/ti9_cache_dk_scorching_amber_dragoon_form.vmdl")
		dragon:SetOriginalModel("models/items/dragon_knight/ti9_cache_dk_scorching_amber_dragoon_form/ti9_cache_dk_scorching_amber_dragoon_form.vmdl")
		dragon:SetModelScale(modelScale)
		dragon:SetSkin(2)
		dragon.type = "sapphire"
		dragon.hero = hero
		StartAnimation(hero, {duration = 1, activity = ACT_DOTA_CAST_ABILITY_4, rate = 1.0})
	end
	if ability:GetGemValue("amethyst") > 0 then
		local modelScale = 0.35 + ability:GetGemValue("amethyst")*0.01
		local dragon = CreateUnitByName("beast_of_ceremony", hero:GetAbsOrigin(), true, nil, nil, hero:GetTeamNumber())
		dragon.owner = hero:GetPlayerOwnerID()
		dragon:SetOwner(hero)
		dragon:SetControllableByPlayer(player, true)
		dragon:AddAbility("dragon_ceremony_ability"):SetLevel(1)
		table.insert(ability.dragon_table, dragon)
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_red_spotlight.vpcf", dragon, 3)
		dragon:SetModel("models/items/dragon_knight/ti9_cache_dk_scorching_amber_dragoon_form/ti9_cache_dk_scorching_amber_dragoon_form.vmdl")
		dragon:SetOriginalModel("models/items/dragon_knight/ti9_cache_dk_scorching_amber_dragoon_form/ti9_cache_dk_scorching_amber_dragoon_form.vmdl")
		dragon:SetModelScale(modelScale)
		dragon:SetSkin(3)
		dragon.type = "amethyst"
		dragon.hero = hero
		StartAnimation(hero, {duration = 1, activity = ACT_DOTA_CAST_ABILITY_4, rate = 1.0})
	end
end

function dragon_ceremony_end(event)
	local caster = event.caster
	local hero = event.target
	local ability = event.ability
	for i = 1, #ability.dragon_table, 1 do
		local dragon = ability.dragon_table[i]
		dragon:RemoveModifierByName("modifier_ceremony_beast")
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_red_spotlight.vpcf", dragon, 3)
		Events:smoothSizeChange(dragon, 0.35, 0.01, 10)
		Timers:CreateTimer(0.4, function()
			UTIL_Remove(dragon)
		end)
	end
end

function ceremony_dragon_think(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	caster:MoveToPosition(hero:GetAbsOrigin() + RandomVector(RandomInt(50, 200)))
	local position = caster:GetAbsOrigin()
	local radius = ITEM_RPC_DRAGON_CEREMONY_VESTMENTS_ATTACK_RADIUS
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	local count = 0
	local max_targets = 6
	StartAnimation(caster, {duration = 1, activity = ACT_DOTA_ATTACK, rate = 1.2})
	local particle_name = "particles/units/heroes/hero_lina/lina_base_attack.vpcf"
	if caster.type == "ruby" then
		particle_name = "particles/units/heroes/hero_lina/lina_base_attack.vpcf"
		max_targets = hero.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue(caster.type, ITEM_RPC_DRAGON_CEREMONY_VESTMENTS_GEM_RUBY1)
	elseif caster.type == "emerald" then
		particle_name = "particles/roshpit/items/dragon_ceremony/dragon_ceremony_emerald.vpcf"
		max_targets = hero.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue(caster.type, ITEM_RPC_DRAGON_CEREMONY_VESTMENTS_GEM_EMERALD1)
	elseif caster.type == "sapphire" then
		particle_name = "particles/roshpit/items/dragon_ceremony/dragon_ceremony_sapphire.vpcf"
		max_targets = hero.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue(caster.type, ITEM_RPC_DRAGON_CEREMONY_VESTMENTS_GEM_SAPPHIRE1)
	elseif caster.type == "amethyst" then
		particle_name = "particles/roshpit/items/dragon_ceremony/dragon_ceremony_amethyst.vpcf"
		max_targets = hero.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue(caster.type, ITEM_RPC_DRAGON_CEREMONY_VESTMENTS_GEM_AMETHYST1)
	end
	if hero:IsAlive() then
		if #enemies > 0 then
			EmitSoundOn("RPCItems.DragonCeremony.AttackSound", caster)
			for _, enemy in pairs(enemies) do
				local info =
				{
					Target = enemy,
					Source = caster,
					Ability = ability,
					EffectName = particle_name,
					StartPosition = "attach_hitloc",
					bDrawsOnMinimap = false,
					bDodgeable = true,
					bIsAttack = false,
					bVisibleToEnemies = true,
					bReplaceExisting = false,
					flExpireTime = GameRules:GetGameTime() + 4,
					bProvidesVision = true,
					iVisionRadius = 0,
					iMoveSpeed = 600,
				iVisionTeamNumber = caster:GetTeamNumber()}
				projectile = ProjectileManager:CreateTrackingProjectile(info)
				count = count + 1
				if count > max_targets then
					break
				end
			end
		end
	end
end

function ceremony_dragon_projectile_strike(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero

	local damage = 1
	if caster.type == "ruby" then
		damage = hero:GetStrength()*hero.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue(caster.type, ITEM_RPC_DRAGON_CEREMONY_VESTMENTS_GEM_RUBY2)
	elseif caster.type == "emerald" then
		damage = hero:GetAgility()*hero.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue(caster.type, ITEM_RPC_DRAGON_CEREMONY_VESTMENTS_GEM_EMERALD2)
	elseif caster.type == "sapphire" then
		damage = hero:GetIntellect()*hero.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue(caster.type, ITEM_RPC_DRAGON_CEREMONY_VESTMENTS_GEM_SAPPHIRE2)
	elseif caster.type == "amethyst" then
		damage = hero:GetSpirit()*hero.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue(caster.type, ITEM_RPC_DRAGON_CEREMONY_VESTMENTS_GEM_AMETHYST2)
	end
	Filters:ApplyItemDamage(target, hero, damage, DAMAGE_TYPE_MAGICAL, event.ability, RPC_ELEMENT_FIRE, RPC_ELEMENT_DRAGON)
end

function dragon_ceremony_take_damage(event)
	local hero = event.caster.hero
	local ability = event.ability
	local attacker = event.attacker
	for i = 1, #ability.dragon_table, 1 do
		if not ability.dragon_table[i].moveLock then
			local dragon = ability.dragon_table[i]
			dragon:MoveToPosition(attacker:GetAbsOrigin() + RandomVector(RandomInt(0, 200)))
			dragon.moveLock = true
			Timers:CreateTimer(1, function()
				dragon.moveLock = false
			end)
		end
	end
end

function ivory_griffin_init(event)
	local hero = event.caster.hero
	local caster = event.caster
	local ability = event.ability
	local summon = CreateUnitByName("ivory_gryffin", hero:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
	summon.owner = hero:GetPlayerOwnerID()
	summon.summoner = hero
	summon:SetOwner(hero)
	summon:SetControllableByPlayer(hero:GetPlayerID(), true)
	summon.hero = hero
	ability.gryphon = summon
	summon.aoe = ITEM_RPC_FEATHERWHITE_ARMOR_RADIUS + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_FEATHERWHITE_ARMOR_GEM_EMERALD)
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_witchdoctor/ivory_gryffin_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, summon)
	ParticleManager:SetParticleControlEnt(pfx, 0, summon, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", summon:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(pfx, 1, Vector(summon.aoe, summon.aoe, summon.aoe))
	ParticleManager:SetParticleControl(pfx, 2, Vector(1, 1, 1))
	summon.pfx = pfx
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_skywrath_mage/skywrath_mage_mystic_flare.vpcf", summon, 2)
	EmitSoundOn("RPCItems.Featherwhite.Init", summon)
	summon:SetDayTimeVisionRange(summon.aoe)
	summon:SetNightTimeVisionRange(summon.aoe)
end

function ivory_griffin_end(event)
	local hero = event.caster.hero
	local caster = event.caster
	local ability = event.ability
	ability.gryphon.disable = true
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_skywrath_mage/skywrath_mage_mystic_flare.vpcf", ability.gryphon, 2)
	local unit_to_remove = ability.gryphon
	ParticleManager:DestroyParticle(ability.gryphon.pfx, false)
	Timers:CreateTimer(0.4, function()
		UTIL_Remove(unit_to_remove)
	end)
	EmitSoundOn("RPCItems.Featherwhite.Init", unit_to_remove)
end

function gryffin_think(event)
	local caster = event.caster
	if caster.disable then
		return false
	end
	local hero = caster.hero
	local ability = event.ability
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), hero:GetAbsOrigin())
	if distance > 3400 then
		caster:SetAbsOrigin(hero:GetAbsOrigin() + RandomVector(RandomInt(50, 200)))
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_skywrath_mage/skywrath_mage_mystic_flare.vpcf", caster, 2)
		EmitSoundOn("RPCItems.Featherwhite.Init", caster)
	elseif distance > 240 then
		caster:MoveToPosition(hero:GetAbsOrigin() + RandomVector(RandomInt(50, 200)))
	end
	local total_heal = 0
	local spirit_heal = math.floor(hero.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_FEATHERWHITE_ARMOR_GEM_AMETHYST)*hero:GetSpirit())
	local allies = FindUnitsInRadius(hero:GetTeamNumber(), caster:GetAbsOrigin(), nil, caster.aoe, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #allies > 0 then
		for _, ally in pairs(allies) do
			local healAmount = math.floor(ally:GetMaxHealth() * ITEM_RPC_FEATHERWHITE_ARMOR_HEAL_OF_MAX_HP/100) + spirit_heal
			Filters:ApplyHeal(hero, ally, healAmount, true, true)
			total_heal = total_heal + healAmount
			ability:ApplyDataDrivenModifier(caster, ally, "modifier_ivory_gryffin_aura_effect", {})
		end
	end
	if hero.equipped_gear[RPC_GEAR_SLOT_BODY]:GetGemValue("sapphire") > 0 then
		local damage = total_heal*hero.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_FEATHERWHITE_ARMOR_GEM_SAPPHIRE)/100
		local enemies = FindUnitsInRadius(hero:GetTeamNumber(), caster:GetAbsOrigin(), nil, caster.aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				Filters:ApplyItemDamage(enemy, hero, damage, DAMAGE_TYPE_PURE, hero.equipped_gear[RPC_GEAR_SLOT_BODY], RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
			end
		end
	end
end

function gryffin_aura_think(event)
	local caster = event.caster
	local target = event.target
	if not IsValidEntity(caster) then
		target:RemoveModifierByName("modifier_ivory_gryffin_aura_effect")
		return false
	end
	if not caster then
		target:RemoveModifierByName("modifier_ivory_gryffin_aura_effect")
		return false
	end
	if caster.disable then
		target:RemoveModifierByName("modifier_ivory_gryffin_aura_effect")
	end
	local hero = caster.hero
	
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), target:GetAbsOrigin())
	if distance > caster.aoe then
		target:RemoveModifierByName("modifier_ivory_gryffin_aura_effect")
	end
end

function feronia_attack_land(event)
	local hero = event.attacker
	local caster = event.caster
	local ability = event.ability
	if ability:GetGemValue("sapphire") > 0 then
		local proc = Filters:GetProc(hero, ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_GUARD_OF_FERONIA_GEM_SAPPHIRE))
		local limitKey = caster:GetPlayerOwnerID() .. '_guard_of_feronia'
		if proc then
			Util.Common:LimitPerTime(ITEM_RPC_GUARD_OF_FERONIA_SAPPHIRE_MAX_PROCS_PER_SECOND, 1, limitKey, function()
				Filters:ApplyFeronia(hero, -10, true)
			end)
		end
	end
end

function feronia_shield_expire(event)
	local caster = event.caster
	local ability = event.ability
	local hero = caster.hero

	if ability:GetGemValue("amethyst") > 0 then
		local damage = OverflowProtectedGetAverageTrueAttackDamage(hero)*ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_GUARD_OF_FERONIA_GEM_AMETHYST)/100
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), hero:GetAbsOrigin(), nil, ITEM_RPC_GUARD_OF_FERONIA_AMETHYST_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			EmitSoundOn("RPCItems.Feronia.StarfallStart", hero)
		end
		if #enemies > 1 then
			for i = 1, #enemies, 1 do
				local enemy = enemies[i]
				Timers:CreateTimer((i-1)*0.05, function()
					CustomAbilities:QuickAttachParticle("particles/roshpit/redfall/autumn_mage_starfall_attack.vpcf", enemy, 1)
					Timers:CreateTimer(0.5, function()
						Filters:ApplyItemDamage(enemy, hero, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_COSMOS, RPC_ELEMENT_NONE)
						EmitSoundOn("RPCItems.Feronia.StarfallHit", enemy)
					end)
				end)
			end
		elseif #enemies == 1 then
			for i = 1, ITEM_RPC_GUARD_OF_FERONIA_SINGLE_TARGET_STARS, 1 do
				local enemy = enemies[1]
				Timers:CreateTimer((i-1)*0.2, function()
					CustomAbilities:QuickAttachParticle("particles/roshpit/redfall/autumn_mage_starfall_attack.vpcf", enemy, 1)
					Timers:CreateTimer(0.5, function()
						Filters:ApplyItemDamage(enemy, hero, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_COSMOS, RPC_ELEMENT_NONE)
						EmitSoundOn("RPCItems.Feronia.StarfallHit", enemy)
					end)
				end)
			end
		end	
	end
end

function outland_cuirass_thinker(event)
	local hero = event.caster.hero
	local caster = event.caster
	local ability = event.ability
	if ability:GetGemValue("emerald") > 0 then
		if hero:IsStunned() then
			ability:ApplyDataDrivenModifier(caster, hero, "modifier_outland_stone_cuirass_emerald", {})
		else
			hero:RemoveModifierByName("modifier_outland_stone_cuirass_emerald")
		end
	end
end

function ruins_leather_init(event)
	local hero = event.caster.hero
	local caster = event.caster
	local ability = event.ability
	if ability:GetGemValue("sapphire") > 0 then
		local as_stacks = ITEM_RPC_RADIANT_RUINS_LEATHER_AS*ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_RADIANT_RUINS_LEATHER_GEM_SAPPHIRE)/100
		local ms_stacks = ITEM_RPC_RADIANT_RUINS_LEATHER_MS*ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_RADIANT_RUINS_LEATHER_GEM_SAPPHIRE)/100

		ability:ApplyDataDrivenModifier(caster, hero, "modifier_radiant_leather_sapphire_as", {})
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_radiant_leather_sapphire_ms", {})
		hero:SetModifierStackCount("modifier_radiant_leather_sapphire_as", caster, as_stacks)
		hero:SetModifierStackCount("modifier_radiant_leather_sapphire_ms", caster, ms_stacks)
	end
end


function flood_robe_ai_on(event)
	local caster = event.caster
	caster:SetAcquisitionRange(900)
end

function flood_robe_ai_off(event)
	local caster = event.caster
	caster:SetAcquisitionRange(0)
end

function flood_robe_ai_think(event)
	local caster = event.caster
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), caster.hero:GetAbsOrigin())
	if not caster.moveLock then
		if distance > 1200 then
			caster:MoveToPosition(caster.hero:GetAbsOrigin()+RandomVector(240))
			caster.moveLock = true
			Timers:CreateTimer(4, function()
				caster.moveLock = false
			end)
		elseif distance > 300 then
			caster:MoveToPositionAggressive(caster.hero:GetAbsOrigin()+RandomVector(240))
			caster.moveLock = true
			Timers:CreateTimer(4, function()
				caster.moveLock = false
			end)
		end
	end
	local fire_breath_ability = caster:FindAbilityByName("ruby_dragon_flame_breath")
	if fire_breath_ability:IsFullyCastable() then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin()+caster:GetForwardVector()*500, nil, 650, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = fire_breath_ability:entindex(),
			}
			ExecuteOrderFromTable(newOrder)
			return			
		end
	end
end

function flood_water_elemental_think(event)
	local caster = event.caster
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), caster.hero:GetAbsOrigin())
	if not caster.moveLock then
		if distance > 1200 then
			caster:MoveToPosition(caster.hero:GetAbsOrigin()+RandomVector(240))
			caster.moveLock = true
			Timers:CreateTimer(4, function()
				caster.moveLock = false
			end)
		elseif distance > 300 then
			caster:MoveToPositionAggressive(caster.hero:GetAbsOrigin()+RandomVector(240))
			caster.moveLock = true
			Timers:CreateTimer(4, function()
				caster.moveLock = false
			end)
		end
	end
	if caster:HasAbility("water_flood_nuke") then
		local nukeAbility = caster:FindAbilityByName("water_flood_nuke")
		if nukeAbility:IsFullyCastable() then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				local castPoint = enemies[1]:GetAbsOrigin()
				local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = nukeAbility:entindex(),
					Position = castPoint
				}
				ExecuteOrderFromTable(newOrder)
				return
			end
		end
	end
end

function flood_elemental_wave_hit(event)
	local target = event.target
	local caster = event.caster
	local hero = caster.hero
	if IsValidEntity(hero) then
		local ability = caster.hero.equipped_gear[RPC_GEAR_SLOT_BODY]
		local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)*ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_ROBE_OF_FLOODING_GEM_EMERALD2)/100
		Filters:ApplyItemDamage(target, hero, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_WATER, RPC_ELEMENT_NONE)
	end
end

function flood_robe_end(event)
	local ability = event.ability
	if ability.elemental_table then
		for i = 1, #ability.elemental_table, 1 do
			if ability.elemental_table[i] and IsValidEntity(ability.elemental_table[i]) then
		        local particleName = "particles/units/heroes/hero_slardar/slardar_crush_water.vpcf"
		        local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, ability.elemental_table[i])
		        local origin = ability.elemental_table[i]:GetAbsOrigin()
		        ParticleManager:SetParticleControl(particle1, 0, origin)
		        ParticleManager:SetParticleControl(particle1, 1, Vector(300, 2, 160))
		        Timers:CreateTimer(3, function()
		            ParticleManager:DestroyParticle(particle1, false)
		        end)
		        EmitSoundOn("RPCItems.OceanTempest.Splash", ability.elemental_table[i])
				UTIL_Remove(ability.elemental_table[i])
			end
		end
	end
end

function flood_water_elemental_always_think(event)
	local caster = event.caster
	local hero = caster.hero
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), hero:GetAbsOrigin())
	if distance > 2500 then
        local particleName = "particles/units/heroes/hero_slardar/slardar_crush_water.vpcf"
        local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
        local origin = caster:GetAbsOrigin()
        ParticleManager:SetParticleControl(particle1, 0, origin)
        ParticleManager:SetParticleControl(particle1, 1, Vector(300, 2, 160))
        Timers:CreateTimer(3, function()
            ParticleManager:DestroyParticle(particle1, false)
        end)
        EmitSoundOn("RPCItems.OceanTempest.Splash", caster)
		FindClearSpaceForUnit(caster, hero:GetAbsOrigin()+RandomVector(200), false)
        local particleName = "particles/units/heroes/hero_slardar/slardar_crush_water.vpcf"
        local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
        local origin = caster:GetAbsOrigin()
        ParticleManager:SetParticleControl(particle1, 0, origin)
        ParticleManager:SetParticleControl(particle1, 1, Vector(300, 2, 160))
        Timers:CreateTimer(3, function()
            ParticleManager:DestroyParticle(particle1, false)
        end)
        EmitSoundOn("RPCItems.OceanTempest.Splash", caster)
	end
end

function savage_ogthun_kill(event)
	local dyingUnit = event.unit
	local hero = event.caster.hero
	local ability = event.ability
	local caster = event.caster

	local heal = hero:GetMaxHealth()*(ITEM_RPC_SAVAGE_PLATE_OF_OGTHUN_HEALTH_RESTORE_PCT/100)
	Filters:ApplyHeal(hero, hero, heal, true)

	local limitKey = hero:GetPlayerOwnerID() .. '_ogthun_particles'
	Util.Common:LimitPerTime(8, 1, limitKey, function()
		local particleName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, dyingUnit)
		ParticleManager:SetParticleControlEnt(pfx, 0, dyingUnit, PATTACH_ABSORIGIN_FOLLOW, "follow_origin", dyingUnit:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, dyingUnit, PATTACH_ABSORIGIN_FOLLOW, "follow_origin", dyingUnit:GetForwardVector(), true)
		EmitSoundOn("RPCItem.Ogthun.Kill", dyingUnit)
	end)
end

function savage_ogthun_attacked(event)
	local hero = event.caster.hero
	local ability = event.ability
	local caster = event.caster
	local attacker = event.attacker
	if ability:GetGemValue("ruby") > 0 then
		local proc = Filters:GetProc(hero, ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_SAVAGE_PLATE_OF_OGTHUN_GEM_RUBY))
		if proc then
			local distance = WallPhysics:GetDistance2d(attacker:GetAbsOrigin(), hero:GetAbsOrigin())
			if distance <= hero:Script_GetAttackRange() then
				local fv = ((attacker:GetAbsOrigin() - hero:GetAbsOrigin())*Vector(1,1,0)):Normalized()
				hero:SetForwardVector(fv)
				Filters:PerformAttackSpecial(hero, attacker, true, true, true, false, true, false, false)
				StartAnimation(hero, {duration = 0.5, activity = ACT_DOTA_ATTACK, rate = 2.2})
			end
		end
	end
end

function savage_ogthun_attack_land(event)
	local hero = event.caster.hero
	local ability = event.ability
	local caster = event.caster
	local attacker = event.attacker
	if ability:GetGemValue("sapphire") > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_ogthun_sapphire_buff", {duration = ITEM_RPC_SAVAGE_PLATE_OF_OGTHUN_SAPPHIRE_DURATION})
		local attack_power = ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_SAVAGE_PLATE_OF_OGTHUN_GEM_SAPPHIRE1)
		hero:SetModifierStackCount("modifier_ogthun_sapphire_buff", caster, attack_power)
	end
end

function sea_giant_think(event)
	local hero = event.caster.hero
	local ability = event.ability
	local caster = event.caster
	if ability:GetGemValue("ruby") > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_sea_giant_health_bonus", {})
		local health_bonus = hero:GetStrength()*ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_SEA_GIANTS_PLATE_GEM_RUBY)
		hero:SetModifierStackCount("modifier_sea_giant_health_bonus", caster, health_bonus)
	end
	if ability:GetGemValue("emerald") > 0 then
		if not hero:HasModifier("modifier_sea_giant_str_bonus_minus_agi") then
			ability:ApplyDataDrivenModifier(caster, hero, "modifier_sea_giant_str_bonus_minus_agi", {})
		end
	end
	if ability:GetGemValue("amethyst") > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_sea_giant_spirit", {})
		local spirit_bonus = hero:GetBaseStrength()*ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_SEA_GIANTS_PLATE_GEM_AMETHYST)/100
		hero:SetModifierStackCount("modifier_sea_giant_spirit", caster, spirit_bonus)
	end
end

function sea_giant_attack_land(event)
	local hero = event.caster.hero
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	if ability:GetGemValue("sapphire") > 0 then
		local proc = Filters:GetProc(hero, ITEM_RPC_SEA_GIANTS_PLATE_SAPPHIRE_CHANCE)
		if proc then
			local damage = hero:GetStrength()*ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_SEA_GIANTS_PLATE_GEM_SAPPHIRE2)
			local stun_duration = ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_SEA_GIANTS_PLATE_GEM_SAPPHIRE1)
			local position = target:GetAbsOrigin()
			local radius = ITEM_RPC_SEA_GIANTS_PLATE_SAPPHIRE_RADIUS
			local splitEarthParticle = "particles/units/heroes/hero_leshrac/astral_rune_b_d.vpcf"
			local pfx = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(pfx, 0, position)
			ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
			EmitSoundOn("RPCItem.SeaGiantPlate.Quake", target)
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				for _, enemy in pairs(enemies) do
					Filters:ApplyItemDamage(enemy, hero, damage, DAMAGE_TYPE_PHYSICAL, ability, RPC_ELEMENT_EARTH, RPC_ELEMENT_WATER)
					Filters:ApplyStun(hero, stun_duration, enemy)
				end
			end
		end
	end
end

function skyforge_think(event)
	local hero = event.caster.hero
	local ability = event.ability
	local caster = event.caster
	local target = event.target

	ability:ApplyDataDrivenModifier(caster, target, "modifier_skyforge_flurry_shield", {})

	if ability:GetGemValue("emerald") > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_skyforge_agility", {})
		local agi_stacks = hero:GetStrength()*ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_SKYFORGE_FLURRY_PLATE_GEM_EMERALD)/100
		hero:SetModifierStackCount("modifier_skyforge_agility", caster, agi_stacks)
	end
	if ability:GetGemValue("sapphire") > 0 then
		if not hero:HasModifier("modifier_skyforge_flurry_plate_sapphire_aura") then
			ability:ApplyDataDrivenModifier(caster, hero, "modifier_skyforge_flurry_plate_sapphire_aura", {})
		end
	end
	if ability:GetGemValue("amethyst") > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_skyforge_speed", {})
		local speed_stacks = hero:GetSpirit()*ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_SKYFORGE_FLURRY_PLATE_GEM_AMETHYST)
		hero:SetModifierStackCount("modifier_skyforge_speed", caster, speed_stacks)		
	end
end

function sorceres_regalia_think(event)
	local hero = event.caster.hero
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	if ability:GetGemValue("amethyst") > 0 then
		-- --print("entity name hero: "..tostring(hero:GetName()))
		-- --print("entity name caster: "..tostring(caster:GetName()))
		-- --print("entity name target: "..tostring(target:GetName()))
		ability:ApplyDataDrivenModifier(hero, hero, "modifier_sorcerers_regalia_spirit", {})
		local spr_stacks = hero:GetIntellect()*ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_SORCERERS_REGALIA_GEM_AMETHYST)/100
		hero:SetModifierStackCount("modifier_sorcerers_regalia_spirit", hero, spr_stacks)
	end	
end

function spellslinger_take_damage(event)
	local hero = event.caster.hero
	local ability = event.ability
	local caster = event.caster
	local attacker = event.attacker
	if ability:GetGemValue("amethyst") > 0 then
		local proc = Filters:GetProc(hero, ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_SPELLSLINGER_COAT_GEM_AMETHYST))
		if proc then
			local limitKey = hero:GetPlayerOwnerID() .. '_spellslinger_amethyst'
			Util.Common:LimitPerTime(ITEM_RPC_SPELLSLINGER_COAT_MAX_AMETHYST_PROCS_PER_SECOND, 1, limitKey, function()
				local event_table = {}
				event_table.attacker = hero
				event_table.target = attacker
				energy_whip_glove_attack_land(event_table)
			end)			
		end
	end
end

function ArmorBreakParticle(event)
	local target = event.target
	local location = target:GetAbsOrigin()
	local particleName = event.particle_name
	if target.AmpDamageParticle then
		ParticleManager:DestroyParticle(target.AmpDamageParticle, false)
	end
	-- Particle. Need to wait one frame for the older particle to be destroyed
	Timers:CreateTimer(0.01, function()
		target.AmpDamageParticle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, target)
		ParticleManager:SetParticleControl(target.AmpDamageParticle, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(target.AmpDamageParticle, 1, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(target.AmpDamageParticle, 2, target:GetAbsOrigin())

		ParticleManager:SetParticleControlEnt(target.AmpDamageParticle, 1, target, PATTACH_OVERHEAD_FOLLOW, "attach_overhead", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(target.AmpDamageParticle, 2, target, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	end)

end

-- Destroys the particle when the modifier is destroyed
function EndArmorBreakParticle(event)
	local target = event.target
	if target.AmpDamageParticle then
		ParticleManager:DestroyParticle(target.AmpDamageParticle, false)
		target.AmpDamageParticle = nil
	end
	target:CalculateAndSaveRoshpitAttributes()
end

function knight_crusher_attacked(event)
	local caster = event.caster
	local ability = event.ability
	local attacker = event.attacker
	local hero = caster.hero
	if ability:GetGemValue("sapphire") > 0 then
		local proc = Filters:GetProc(hero, ITEM_RPC_STAGGERING_KNIGHT_CRUSHER_ARMOR_SAPPHIRE_CHANCE)
		if proc then
			local stun_duration = ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_STAGGERING_KNIGHT_CRUSHER_ARMOR_GEM_SAPPHIRE1)
			Filters:ApplyStun(hero, stun_duration, attacker)
		end
	end
end

function cast_spell_near_knight_crusher(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.unit
	local hero = caster.hero
	if ability:GetGemValue("amethyst") > 0 then
		local stun_duration = ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_STAGGERING_KNIGHT_CRUSHER_ARMOR_GEM_AMETHYST)
		Filters:ApplyStun(hero, stun_duration, target)		
	end
end

function tattered_novice_init(event)
	local caster = event.caster
	local hero = caster.hero
	Runes:UpdateHeroSkillAndRunePoints(hero, true)
	hero:SetStatsForLevel()
	-- if hero.equipped_gear[RPC_GEAR_SLOT_HEAD] then
	-- 	hero:EquipItem(hero.equipped_gear[RPC_GEAR_SLOT_HEAD], false)
	-- end
	-- if hero.equipped_gear[RPC_GEAR_SLOT_WEAPON] then
	-- 	hero:EquipItem(hero.equipped_gear[RPC_GEAR_SLOT_WEAPON], false)
	-- end
	-- if hero.equipped_gear[RPC_GEAR_SLOT_GLOVES] then
	-- 	hero:EquipItem(hero.equipped_gear[RPC_GEAR_SLOT_GLOVES], false)
	-- end
	-- if hero.equipped_gear[RPC_GEAR_SLOT_BOOTS] then
	-- 	hero:EquipItem(hero.equipped_gear[RPC_GEAR_SLOT_BOOTS], false)
	-- end
	-- if hero.equipped_gear[RPC_GEAR_SLOT_TRINKET] then
	-- 	hero:EquipItem(hero.equipped_gear[RPC_GEAR_SLOT_TRINKET], false)
	-- end
end

function tattered_novice_end(event)
	local caster = event.caster
	local hero = caster.hero
	Runes:UpdateHeroSkillAndRunePoints(hero, true)
	hero:SetStatsForLevel()

	-- if hero.equipped_gear[RPC_GEAR_SLOT_HEAD] then
	-- 	hero:EquipItem(hero.equipped_gear[RPC_GEAR_SLOT_HEAD], false)
	-- end
	-- if hero.equipped_gear[RPC_GEAR_SLOT_WEAPON] then
	-- 	hero:EquipItem(hero.equipped_gear[RPC_GEAR_SLOT_WEAPON], false)
	-- end
	-- if hero.equipped_gear[RPC_GEAR_SLOT_GLOVES] then
	-- 	hero:EquipItem(hero.equipped_gear[RPC_GEAR_SLOT_GLOVES], false)
	-- end
	-- if hero.equipped_gear[RPC_GEAR_SLOT_BOOTS] then
	-- 	hero:EquipItem(hero.equipped_gear[RPC_GEAR_SLOT_BOOTS], false)
	-- end
	-- if hero.equipped_gear[RPC_GEAR_SLOT_TRINKET] then
	-- 	hero:EquipItem(hero.equipped_gear[RPC_GEAR_SLOT_TRINKET], false)
	-- end
end

function tattered_novice_enemy_death(event)
	local caster = event.caster
	local hero = caster.hero
	local unit = event.unit
	local ability = event.ability
	if ability:GetGemValue("ruby") > 0 then
		local proc = Filters:GetProc(hero, ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_TATTERED_NOVICE_ARMOR_GEM_RUBY))
		if proc then
			local potion = RPCItems:RollRandomPotion(unit:GetRoshpitLevel())
			if potion then
				RPCItems:BasicDropItem(unit:GetAbsOrigin(), potion)
			end
		end
	end
end

function vampiric_breastplate_init(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability

	ability:ApplyDataDrivenModifier(caster, hero, "modifier_vampiric_breastplate_aura", {})
end

function vermillion_dream_init(event)
	local caster = event.caster
	local hero = caster.hero
	hero:AddNewModifier(caster, nil, 'modifier_vermillion_dream_lua', nil)
	-- if hero.equipped_gear[RPC_GEAR_SLOT_HEAD] then
	-- 	hero:EquipItem(hero.equipped_gear[RPC_GEAR_SLOT_HEAD], false)
	-- end
	-- if hero.equipped_gear[RPC_GEAR_SLOT_WEAPON] then
	-- 	hero:EquipItem(hero.equipped_gear[RPC_GEAR_SLOT_WEAPON], false)
	-- end
	-- if hero.equipped_gear[RPC_GEAR_SLOT_GLOVES] then
	-- 	hero:EquipItem(hero.equipped_gear[RPC_GEAR_SLOT_GLOVES], false)
	-- end
	-- if hero.equipped_gear[RPC_GEAR_SLOT_BOOTS] then
	-- 	hero:EquipItem(hero.equipped_gear[RPC_GEAR_SLOT_BOOTS], false)
	-- end
	-- if hero.equipped_gear[RPC_GEAR_SLOT_TRINKET] then
	-- 	hero:EquipItem(hero.equipped_gear[RPC_GEAR_SLOT_TRINKET], false)
	-- end
end

function vermillion_dream_end(event)
	local caster = event.caster
	local hero = caster.hero
	hero:RemoveModifierByName('modifier_vermillion_dream_lua')
	-- if hero.equipped_gear[RPC_GEAR_SLOT_HEAD] then
	-- 	hero:EquipItem(hero.equipped_gear[RPC_GEAR_SLOT_HEAD], false)
	-- end
	-- if hero.equipped_gear[RPC_GEAR_SLOT_WEAPON] then
	-- 	hero:EquipItem(hero.equipped_gear[RPC_GEAR_SLOT_WEAPON], false)
	-- end
	-- if hero.equipped_gear[RPC_GEAR_SLOT_GLOVES] then
	-- 	hero:EquipItem(hero.equipped_gear[RPC_GEAR_SLOT_GLOVES], false)
	-- end
	-- if hero.equipped_gear[RPC_GEAR_SLOT_BOOTS] then
	-- 	hero:EquipItem(hero.equipped_gear[RPC_GEAR_SLOT_BOOTS], false)
	-- end
	-- if hero.equipped_gear[RPC_GEAR_SLOT_TRINKET] then
	-- 	hero:EquipItem(hero.equipped_gear[RPC_GEAR_SLOT_TRINKET], false)
	-- end
	hero:RemoveModifierByName("modifier_vermillion_dream_amethyst")
end

function vermillion_dream_robe_think(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	if ability:GetGemValue("sapphire") > 0 then
		local distance = ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_VERMILLION_DREAM_ROBES_GEM_SAPPHIRE2)
		local vision_node_radius = 400
		local node_count = distance / (vision_node_radius/2)
		for i = 1, node_count, 1 do
			local vision_position = hero:GetAbsOrigin() + hero:GetForwardVector() * i * (vision_node_radius/2)
			AddFOWViewer(hero:GetTeamNumber(), vision_position, vision_node_radius, 1, true)
		end
	end
	if ability:GetGemValue("amethyst") > 0 then
		local enemies = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin(), nil, ITEM_RPC_VERMILLION_DREAM_ROBES_AMETHYST_ENEMY_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		local enemies_nearby = false
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				if not enemy.dummy then
					enemies_nearby = true
					break
				end
			end
		end
		if not enemies_nearby then
			ability:ApplyDataDrivenModifier(caster, hero, "modifier_vermillion_dream_amethyst", {})
		else
			hero:RemoveModifierByName("modifier_vermillion_dream_amethyst")
		end
	end
end

function windsteel_shield_end(event)
	local caster = event.caster
	local ability = event.ability
	local hero = caster.hero
	if ability:GetGemValue("amethyst") > 0 then
		local fv = hero:GetForwardVector()
		local speed = 1300
		local wind_range = ITEM_RPC_WINDSTEEL_ARMOR_AMETHYST_RADIUS
		EmitSoundOn("RPCItems.Windsteel.AmethystWind", hero)
		for i = 1, 8, 1 do
			local wind_fv = WallPhysics:rotateVector(fv, 2 * math.pi * i / 8)
			local info =
			{
				Ability = ability,
				EffectName = "particles/items/hurricane_vest_projectile.vpcf",
				vSpawnOrigin = hero:GetAbsOrigin() + Vector(0, 0, 60),
				fDistance = wind_range,
				fStartRadius = 130,
				fEndRadius = 130,
				Source = caster,
				StartPosition = "attach_attack1",
				bHasFrontalCone = true,
				bReplaceExisting = false,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				fExpireTime = GameRules:GetGameTime() + 5.0,
				bDeleteOnHit = false,
				vVelocity = wind_fv * Vector(1, 1, 0) * speed,
				bProvidesVision = false,
			}
			projectile = ProjectileManager:CreateLinearProjectile(info)
		end	
	end
end

function windsteel_amethyst_projectile_hit(event)
	local caster = event.caster
	local ability = event.ability
	local hero = caster.hero
	local target = event.target
	local tornado_duration = ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_WINDSTEEL_ARMOR_GEM_AMETHYST)

	ability:ApplyDataDrivenModifier(caster, target, "modifier_windsteel_amethyst_tornado", {duration = tornado_duration})
	if target.windsteel_tornado_pfx then
		ParticleManager:DestroyParticle(target.windsteel_tornado_pfx, false)
	end
	target.windsteel_tornado_pfx = ParticleManager:CreateParticle("particles/items_fx/cyclone.vpcf", PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(target.windsteel_tornado_pfx, 0, target:GetAbsOrigin())
end

function windsteel_amethyst_tornado_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster

	local newFV = WallPhysics:rotateVector(target:GetForwardVector(), 2*math.pi/20)
	target:SetForwardVector(newFV)
	if not target.ocean_tempest_lift_speed then
		target.ocean_tempest_lift_speed = 3
	end
	local distanceFromGround = target:GetAbsOrigin().z - GetGroundHeight(target:GetAbsOrigin(), target)
	if not target.jumpLock then
		if distanceFromGround < 240 then
			target.ocean_tempest_lift_speed = target.ocean_tempest_lift_speed + 0.4
			target:SetAbsOrigin(target:GetAbsOrigin() + Vector(0,0,target.ocean_tempest_lift_speed))
		else
			target.ocean_tempest_lift_speed = target.ocean_tempest_lift_speed - 0.4
			target:SetAbsOrigin(target:GetAbsOrigin() + Vector(0,0,target.ocean_tempest_lift_speed))		
		end
	end
end

function windsteel_amethyst_tornado_end(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
	target.ocean_tempest_lift_speed = nil
	ability:ApplyDataDrivenModifier(caster, target, "modifier_windsteel_amethyst_falling", {duration = 3})
	ParticleManager:DestroyParticle(target.windsteel_tornado_pfx, false)
	target.windsteel_tornado_pfx = nil
end

function windsteel_amethyst_falling_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster

	local newFV = WallPhysics:rotateVector(target:GetForwardVector(), 2*math.pi/20)
	target:SetForwardVector(newFV)
	local distanceFromGround = target:GetAbsOrigin().z - GetGroundHeight(target:GetAbsOrigin(), target)
	if distanceFromGround > 10 then
		target:SetAbsOrigin(target:GetAbsOrigin() - Vector(0,0,30))
	else
		target:RemoveModifierByName("modifier_windsteel_amethyst_falling")
	end
end

function windsteel_amethyst_falling_end(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
	FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
end

function aquasteel_take_damage(event)
	local unit = event.unit
	local attacker = event.attacker
	local caster = event.unit
	local ability = event.ability
	local proc = Filters:GetProc(caster, ITEM_RPC_AQUASTEEL_BRACERS_CHANCE)
	if unit:GetEntityIndex() == attacker:GetEntityIndex() then
	else
		if proc then
			Filters:AquaSteelWaterJet(caster, ability, attacker)
		end
	end
end

function aquasteel_think(event)
	local caster = event.caster
	local ability = event.ability
	local hero = caster.hero
	if not ability.interval then
		ability.interval = 0
	end
	if ability:GetGemValue("emerald") > 0 then
		ability.interval = ability.interval + 1
		if ability.interval >= ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_AQUASTEEL_BRACERS_GEM_EMERALD)/0.5 then
			local enemies = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin(), nil, ITEM_RPC_AQUASTEEL_BRACERS_EMERALD_RANGE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				Filters:AquaSteelWaterJet(hero, ability, enemies[1])
			end
			ability.interval = 0		
		end
	end
end

function autumnrock_bracer_take_damage(event)
	local hero = event.unit
	local ability = event.ability
	if target == event.attacker then
		return false
	end
	local chance = ITEM_RPC_AUTUMNROCK_BRACER_CHANCE + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_AUTUMNROCK_BRACER_GEM_RUBY2)
	local proc = Filters:GetProc(hero, chance)
	if proc then
		local limitKey = hero:GetPlayerOwnerID() .. '_autumnrock_procs'
		Util.Common:LimitPerTime(ITEM_RPC_AUTUMNROCK_BRACER_MAX_PROCS_PER_SEC, 1, limitKey, function()
			local delay = math.max(ITEM_RPC_AUTUMNROCK_BRACER_TRAVEL_DELAY - ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_AUTUMNROCK_BRACER_GEM_SAPPHIRE1), 0.1)
			local attacker = event.attacker
			local length = math.max(WallPhysics:GetDistance(hero:GetAbsOrigin() * Vector(1, 1, 0), attacker:GetAbsOrigin() * Vector(1, 1, 0)) / 250, 1)
			local fv = (attacker:GetAbsOrigin() * Vector(1, 1, 0) - hero:GetAbsOrigin() * Vector(1, 1, 0)):Normalized()
			local startPosition = hero:GetAbsOrigin()
			for i = 1, math.floor(length), 1 do
				Timers:CreateTimer(delay * (i - 1), function()
					local position = startPosition + fv * i * 260
					Filters:AutumnrockExplosion(hero, ability, position, ITEM_RPC_AUTUMNROCK_BRACER_EXP_AOE)
				end)
			end
		end)
	end
end

function bladeforge_attack_land(event)
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if ability:GetGemValue("ruby") > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_bladeforge_armor_debuff", {duration = ITEM_RPC_BLADEFORGE_GAUNTLET_RUBY_DURATION})
		local current_stack = target:GetModifierStackCount("modifier_bladeforge_armor_debuff", ability)
		local new_stacks = math.min(current_stack + 1, ITEM_RPC_BLADEFORGE_GAUNTLET_RUBY_MAX_STACKS)
		target:SetModifierStackCount("modifier_bladeforge_armor_debuff", ability, new_stacks)
		target:CalculateAndSaveRoshpitAttributes()
	end
	local proc_chance = ITEM_RPC_BLADEFORGE_GAUNTLET_PROC_CHANCE + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_BLADEFORGE_GAUNTLET_GEM_SAPPHIRE1)
	local proc = Filters:GetProc(attacker, proc_chance)
	if proc then
		local particleName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "follow_origin", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "follow_origin", target:GetForwardVector(), true)
		EmitSoundOn("Hero_PhantomAssassin.CoupDeGrace", target)
		local bleed_duration = ITEM_RPC_BLADEFORGE_BLEED_DURATION + ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_BLADEFORGE_GAUNTLET_GEM_AMETHYST2)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_bladeforge_bleed", {duration = bleed_duration})
		Timers:CreateTimer(3, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		if ability:GetGemValue("amethyst") > 0 then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_bladeforge_health_regen_loss", {duration = bleed_duration})
			local health_regen_loss_amount = ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_BLADEFORGE_GAUNTLET_GEM_AMETHYST1)
			target:SetModifierStackCount("modifier_bladeforge_health_regen_loss", caster, health_regen_loss_amount)
		end
	end
end

function bladeforge_bleed_think(event)
	local target = event.target
	local hero = event.caster.hero
	local ability = event.ability
	local damage = OverflowProtectedGetAverageTrueAttackDamage(hero)*((ITEM_RPC_BLADEFORGE_GAUNTLET_BLEED_DMG_ATK_PWR_PCT + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_BLADEFORGE_GAUNTLET_GEM_SAPPHIRE2))/100)
	local ability = event.ability
	Filters:ApplyItemDamage(target, hero, damage, DAMAGE_TYPE_PHYSICAL, ability, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
end

function bladeforge_bleed_end(event)
	local target = target
end

function boneguard_attack_land(event)
	local target = event.target
	local ability = event.ability
	local attacker = event.attacker
	local caster = event.caster
	local proc_chance = ITEM_RPC_BONEGUARD_GAUNTLETS_SPAWN_CHANCE + ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_BONEGUARD_GAUNTLETS_GEM_AMETHYST1)
	local proc = Filters:GetProc(attacker, proc_chance)
	if not ability.skeleton_table then
		ability.skeleton_table = {}
	end
	local new_skele_table = {}
	for i = 1, #ability.skeleton_table, 1 do
		if ability.skeleton_table[i] and IsValidEntity(ability.skeleton_table[i]) and ability.skeleton_table[i]:IsAlive() then
			table.insert(new_skele_table, ability.skeleton_table[i])
		end
	end
	local max_skeletons = ITEM_RPC_BONEGUARD_GAUNTLETS_MAX_SKELETONS + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_BONEGUARD_GAUNTLETS_GEM_EMERALD)
	ability.skeleton_table = new_skele_table
	if proc then
		if #ability.skeleton_table < max_skeletons then
			local skeleton = CreateUnitByName("basic_skeleton", target:GetAbsOrigin(), true, nil, nil, attacker:GetTeamNumber())
			skeleton.owner = attacker:GetPlayerOwnerID()
			skeleton:SetOwner(attacker)
			skeleton.hero = attacker
			skeleton:SetControllableByPlayer(attacker:GetPlayerOwnerID(), true)
			local ai_ability = skeleton:AddAbility("bone_claw_skeleton_toggle_ai")
			ai_ability:SetLevel(1)
			ai_ability:ToggleAbility()

	        skeleton.dieTime = ITEM_RPC_BONEGUARD_GAUNTLETS_SKELETON_LIFE_TIMER + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_BONEGUARD_GAUNTLETS_GEM_SAPPHIRE1)
	        skeleton:AddAbility("ability_die_after_time_generic"):SetLevel(1)
	        local damage_mult = ITEM_RPC_BONEGUARD_GAUNTLETS_ATTACK_POWER + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_BONEGUARD_GAUNTLETS_GEM_RUBY)
	        skeleton:AdjustSummon(attacker, true, ITEM_RPC_BONEGUARD_GAUNTLETS_HEALTH_MULT, ITEM_RPC_BONEGUARD_GAUNTLETS_ATTACK_POWER, 1, 1, 1, 1)
	        if ability:GetGemValue("sapphire") > 0 then
	        	local new_max_health = skeleton:GetMaxHealth() + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_BONEGUARD_GAUNTLETS_GEM_SAPPHIRE2)
	        	skeleton:SetMaxHPandHealToFull(new_max_health)
	        end
	        skeleton:SetModelScale(0.85)
	        skeleton:SetOriginalModel("models/items/wraith_king/wk_ti8_creep/wk_ti8_creep.vmdl")
	        skeleton:SetModel("models/items/wraith_king/wk_ti8_creep/wk_ti8_creep.vmdl")
	        table.insert(ability.skeleton_table, skeleton)
	        Timers:CreateTimer(0.1, function()
	        	StartAnimation(skeleton, {duration = 1, activity = ACT_DOTA_SPAWN, rate = 0.8})
	            EmitSoundOn("RPCItems.Boneguard.Spawn", skeleton)
	        end)
	        CustomAbilities:QuickAttachParticle("particles/roshpit/items/scourge_knight_ambient.vpcf", skeleton, 1)
	        ability:ApplyDataDrivenModifier(caster, skeleton, "modifier_boneguard_skeleton", {})
	        if ability:GetGemValue("amethyst") > 0 then
	        	ability:ApplyDataDrivenModifier(caster, skeleton, "modifier_boneguard_attack_speed", {})
	        	skeleton:SetModifierStackCount("modifier_boneguard_attack_speed", caster, ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_BONEGUARD_GAUNTLETS_GEM_AMETHYST2))
	        end
		end
	end
end

function bone_claw_skeleton_on(event)
	local caster = event.caster
	caster:SetAcquisitionRange(900)
end

function bone_claw_skeleton_off(event)
	local caster = event.caster
	caster:SetAcquisitionRange(0)
end

function bone_claw_skeleton_think(event)
	local caster = event.caster
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), caster.hero:GetAbsOrigin())
	if not caster.moveLock then
		if distance > 1200 then
			caster:MoveToPosition(caster.hero:GetAbsOrigin()+RandomVector(240))
			caster.moveLock = true
			Timers:CreateTimer(4, function()
				caster.moveLock = false
			end)
		elseif distance > 300 then
			caster:MoveToPositionAggressive(caster.hero:GetAbsOrigin()+RandomVector(240))
			caster.moveLock = true
			Timers:CreateTimer(4, function()
				caster.moveLock = false
			end)
		end
	end
end

function dark_emissary_emerald_end(event)
	local target = event.target
	local ability = event.ability
	ParticleManager:DestroyParticle(target.pfx, false)
	ParticleManager:ReleaseParticleIndex(target.pfx)
	UTIL_Remove(target)
	ability.dummy = nil
end

function dark_emissary_emerald_damage(event)
	local target = event.target
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	Filters:ApplyItemDamage(target, hero, ability.emerald_damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_GHOST, RPC_ELEMENT_NONE)
end

function depth_demon_claw_init(event)
	local target = event.target
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability

	if ability:GetGemValue("ruby") > 0 then
		local attack_power_boost = ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_DEPTH_DEMON_CLAW_GEM_RUBY1)
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_depth_demon_claw_ruby", {})
		hero:SetModifierStackCount("modifier_depth_demon_claw_ruby", caster, attack_power_boost)
	end
	if ability:GetGemValue("emerald") > 0 then
		local regen_stacks = ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_DEPTH_DEMON_CLAW_GEM_EMERALD1)
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_depth_demon_claw_emerald_health_regen", {})
		hero:SetModifierStackCount("modifier_depth_demon_claw_emerald_health_regen", caster, regen_stacks)

		local mana_regen_stacks = ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_DEPTH_DEMON_CLAW_GEM_EMERALD2)
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_depth_demon_claw_emerald_mana_regen", {})
		hero:SetModifierStackCount("modifier_depth_demon_claw_emerald_mana_regen", caster, mana_regen_stacks)
	end
	if ability:GetGemValue("sapphire") > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_depth_demon_claw_sapphire", {})
	end
	if ability:GetGemValue("amethyst") > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_depth_demon_claw_amethyst", {})
	end
end

function depth_demon_ruby_attack_land(event)
	local target = event.target
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability

	local health_drain = hero:GetMaxHealth()*(ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_DEPTH_DEMON_CLAW_GEM_RUBY2)/100)
	local new_health = math.max(hero:GetHealth() - health_drain, 1)
	hero:SetHealth(new_health)
end

function depth_demon_claw_sapphire_think(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	local base_damage_bonus = hero:GetMana()*(ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_DEPTH_DEMON_CLAW_GEM_SAPPHIRE1))
	if base_damage_bonus > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_sapphire_base_attack_damage", {})
		hero:SetModifierStackCount("modifier_sapphire_base_attack_damage", caster, base_damage_bonus)
	else
		hero:RemoveModifierByName("modifier_sapphire_base_attack_damage")
	end
end

function depth_demon_sapphire_attack_land(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	local mana_drain = hero:GetMaxMana()*(ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_DEPTH_DEMON_CLAW_GEM_SAPPHIRE2))/100
	hero:ReduceMana(mana_drain)
end

function depth_demon_amethyst_take_damage(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	local attacker = event.attacker
	if attacker ~= hero then
		if not hero:HasModifier("modifier_depth_demon_claw_amethyst_shield") then
			local proc = Filters:GetProc(hero, ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_DEPTH_DEMON_CLAW_GEM_AMETHYST))
			if proc then
				local stacks = ITEM_RPC_DEPTH_DEMON_CLAW_AMETHYST_SHIELD_STACKS
				ability:ApplyDataDrivenModifier(caster, hero, "modifier_depth_demon_claw_amethyst_shield", {duration = 60})
				hero:SetModifierStackCount("modifier_depth_demon_claw_amethyst_shield", caster, stacks)
			end
		end
	end
end

function far_seer_effect_end(event)
	local ability = event.ability
	ability.last_damage = 0
end

function divine_purity_attack_land(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	if ability:GetGemValue("amethyst") > 0 then
		local healAmount = hero:GetMaxHealth()*(ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_GAUNTLET_OF_DIVINE_PURITY_GEM_AMETHYST)/100)
		Filters:ApplyHeal(hero, hero, healAmount, true, true)
	end
end

function grasp_of_elder_think(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	local radius = ITEM_RPC_GRASP_OF_ELDER_SEARCH_RANGE
	local enemies = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies == 0 then
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_oracle/white_mage_healheal.vpcf", hero, 3)
		local healAmount = hero:GetMaxHealth()*(ITEM_RPC_GRASP_OF_ELDER_HEAL_PCT/100)
		Filters:ApplyHeal(hero, hero, healAmount, true, true)
	end
end

function greensand_init(event)
	local caster = event.caster
	local hero = caster.hero
	-- if hero.equipped_gear[RPC_GEAR_SLOT_HEAD] then
	-- 	hero:EquipItem(hero.equipped_gear[RPC_GEAR_SLOT_HEAD], false)
	-- end
	-- if hero.equipped_gear[RPC_GEAR_SLOT_WEAPON] then
	-- 	hero:EquipItem(hero.equipped_gear[RPC_GEAR_SLOT_WEAPON], false)
	-- end
	-- if hero.equipped_gear[RPC_GEAR_SLOT_BODY] then
	-- 	hero:EquipItem(hero.equipped_gear[RPC_GEAR_SLOT_BODY], false)
	-- end
	-- if hero.equipped_gear[RPC_GEAR_SLOT_BOOTS] then
	-- 	hero:EquipItem(hero.equipped_gear[RPC_GEAR_SLOT_BOOTS], false)
	-- end
	-- if hero.equipped_gear[RPC_GEAR_SLOT_TRINKET] then
	-- 	hero:EquipItem(hero.equipped_gear[RPC_GEAR_SLOT_TRINKET], false)
	-- end
end

function greensand_end(event)
	local caster = event.caster
	local hero = caster.hero
	-- if hero.equipped_gear[RPC_GEAR_SLOT_HEAD] then
	-- 	hero:EquipItem(hero.equipped_gear[RPC_GEAR_SLOT_HEAD], false)
	-- end
	-- if hero.equipped_gear[RPC_GEAR_SLOT_WEAPON] then
	-- 	hero:EquipItem(hero.equipped_gear[RPC_GEAR_SLOT_WEAPON], false)
	-- end
	-- if hero.equipped_gear[RPC_GEAR_SLOT_BODY] then
	-- 	hero:EquipItem(hero.equipped_gear[RPC_GEAR_SLOT_BODY], false)
	-- end
	-- if hero.equipped_gear[RPC_GEAR_SLOT_BOOTS] then
	-- 	hero:EquipItem(hero.equipped_gear[RPC_GEAR_SLOT_BOOTS], false)
	-- end
	-- if hero.equipped_gear[RPC_GEAR_SLOT_TRINKET] then
	-- 	hero:EquipItem(hero.equipped_gear[RPC_GEAR_SLOT_TRINKET], false)
	-- end
end

function heavy_echo_think(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	if ability:GetGemValue("amethyst") > 0 then
		if not ability.interval then
			ability.interval = 0
		end
		ability.interval = ability.interval + 1
		if ability.interval*0.1 >= ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_HEAVY_ECHO_GAUNTLET_GEM_AMETHYST) then
			ability:ApplyDataDrivenModifier(caster, hero, "modifier_heavy_echo_extra_echo", {})
			ability.interval = 0
		end
	end
end

function heavy_echo_attack_land(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	local target = event.target
	if ability:GetGemValue("sapphire") > 0 then
		if not hero:HasModifier("modifier_heavy_echo_sapphire_cooldown") then
			local cooldown = ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_HEAVY_ECHO_GAUNTLET_GEM_SAPPHIRE)
			ability:ApplyDataDrivenModifier(caster, hero, "modifier_heavy_echo_sapphire_cooldown", {duration = cooldown})
			Timers:CreateTimer(0.1, function()
				StartAnimation(hero, {duration = 0.5, activity = ACT_DOTA_ATTACK, rate = 3.2})
				Filters:PerformAttackSpecial(hero, target, true, true, true, false, true, false, false)
			end)
		end
	end
end

function kappa_pride_attack_land(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	local target = event.target
	if ability:GetGemValue("sapphire") > 0 then
		local proc = Filters:GetProc(hero, ITEM_RPC_KAPPA_PRIDE_GLOVES_SAPPHIRE_CHANCE)
		if proc then
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_leshrac/leshrac_disco_tnt.vpcf", hero, 5)
			ability:ApplyDataDrivenModifier(caster, hero, "modifier_kappa_pride_sapphire", {duration = ITEM_RPC_KAPPA_PRIDE_GLOVES_SAPPHIRE_DURATION})
			ability:ApplyDataDrivenModifier(caster, hero, "modifier_kappa_pride_sapphire_as", {duration = ITEM_RPC_KAPPA_PRIDE_GLOVES_SAPPHIRE_DURATION})
			ability:ApplyDataDrivenModifier(caster, hero, "modifier_kappa_pride_sapphire_atk_dmg_pct", {duration = ITEM_RPC_KAPPA_PRIDE_GLOVES_SAPPHIRE_DURATION})
			hero:SetModifierStackCount("modifier_kappa_pride_sapphire_as", caster, ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_KAPPA_PRIDE_GLOVES_GEM_SAPPHIRE1))
			hero:SetModifierStackCount("modifier_kappa_pride_sapphire_atk_dmg_pct", caster, ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_KAPPA_PRIDE_GLOVES_GEM_SAPPHIRE2))
		end
	end
end

function kappa_pride_init(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	hero:AddNewModifier(hero, ability, "modifier_proud_gloves_lua", {})
end

function spellfire_channeling_think(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	local ulti = hero:GetAbilityByIndex(DOTA_R_SLOT)
	local remaining_time_to_trigger = ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_SPELLFIRE_GLOVES_GEM_AMETHYST)
	local channel_time_remaining = (ulti:GetChannelTime() + (ulti:GetChannelStartTime() - GameRules:GetGameTime()))
	if (ulti:IsChanneling()) and (channel_time_remaining <= remaining_time_to_trigger) then
        ulti:OnChannelFinish(false)
        Timers:CreateTimer(0.03, function()
            ulti:EndChannel(true)
            Filters:EndRChannel(hero)
        end)
        hero:RemoveModifierByName("modifier_spellfire_gloves_channeling_think")
	end
end

function hero_town_portal_channeling_think(event)
	local hero = event.caster
	if hero:HasModifier("modifier_stormcloth_bracer") then
		local ability = hero.equipped_gear[RPC_GEAR_SLOT_GLOVES]
		if ability:GetGemValue("amethyst") > 0 then
			for i = 1, 2, 1 do
				local fv = RandomVector(1)
				local projectileParticle = "particles/econ/items/zeus/lightning_weapon_fx/linear_electric_immortal_lightning.vpcf"
				local projectileOrigin = hero:GetAbsOrigin() + fv * 10
				local start_radius = 90
				local end_radius = 90
				local range = 1000
				local speed = 400 + RandomInt(0, 250)
				local info =
				{
					Ability = ability,
					EffectName = projectileParticle,
					vSpawnOrigin = projectileOrigin + Vector(0, 0, 60),
					fDistance = range,
					fStartRadius = start_radius,
					fEndRadius = end_radius,
					Source = hero,
					StartPosition = "attach_attack1",
					bHasFrontalCone = true,
					bReplaceExisting = false,
					iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
					iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
					iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					fExpireTime = GameRules:GetGameTime() + 5.0,
					bDeleteOnHit = false,
					vVelocity = fv * speed,
					bProvidesVision = false,
				}
				projectile = ProjectileManager:CreateLinearProjectile(info)
			end		
		end
	end
end

function stormcloth_amethyst_projectile_hit(event)
	local ability = event.ability
	local caster = event.caster
	local hero = caster
	local target = event.target
	EmitSoundOn("Paragon.LightningHit", target)
	local damage = OverflowProtectedGetAverageTrueAttackDamage(hero) * ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_STORMCLOTH_BRACER_GEM_AMETHYST)/100
	Filters:ApplyItemDamage(target, hero, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_WIND)
end

function boots_of_great_fortune_init(event)
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
	if ability:GetGemValue("sapphire") > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_boots_of_great_fortune_sapphire_thinker", {})
	end
end

function boots_of_great_fortune_think(event)
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
	if ability:GetGemValue("emerald") > 0 then
		local proc = Filters:GetProc(hero, ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_BOOTS_OF_GREAT_FORTUNE_GEM_EMERALD))
		if proc then
			ability:ApplyDataDrivenModifier(caster, hero, "modifier_black_King_bar_immunity", {duration = ITEM_RPC_BOOTS_OF_GREAT_FORTUNE_EMERALD_DURATION})
		end
	end
end

function boots_of_great_fortune_sapphire_thinker(event)
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
	if ability:GetGemValue("sapphire") == 0 then
		return false
	end
	if not ability.sapphire_interval then
		ability.sapphire_interval = 0
	end
	if not hero:HasModifier("modifier_boots_of_great_fortune_sapphire_effect") then
		ability.sapphire_interval = ability.sapphire_interval + 1
	end
	if ability.sapphire_interval >= ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_BOOTS_OF_GREAT_FORTUNE_GEM_SAPPHIRE) then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_boots_of_great_fortune_sapphire_effect", {})
		ability.sapphire_interval = 0
	end
end

function crystalline_slippers_think(event)
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
	if ability:GetGemValue("emerald") > 0 then
		if not hero:HasModifier("modifier_crystalline_slippers_emerald") then
			hero:AddNewModifier(caster, ability, "modifier_crystalline_slippers_emerald", {})
		end
		if not ability.lastPos then
			ability.lastPos = hero:GetAbsOrigin()
		end
		local distance = WallPhysics:GetDistance2d(ability.lastPos, hero:GetAbsOrigin())
		if distance < 3 then
			ability.immobile = true
			ability:ApplyDataDrivenModifier(caster, hero, "modifier_crystalline_emerald_immobile", {})
			hero:SetModifierStackCount("modifier_crystalline_emerald_immobile", caster, ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_CRYSTALLINE_SLIPPERS_GEM_EMERALD2))
			hero:RemoveModifierByName("modifier_crystalline_emerald_in_motion")
		else
			ability.immobile = false
			ability:ApplyDataDrivenModifier(caster, hero, "modifier_crystalline_emerald_in_motion", {})
			hero:RemoveModifierByName("modifier_crystalline_emerald_immobile")
		end
		ability.lastPos = hero:GetAbsOrigin()
	end
end

function emerald_speedrunners_think(event)
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
	if ability:GetGemValue("amethyst") > 0 then
		local e_ability = hero:GetAbilityByIndex(DOTA_E_SLOT)
		local max_cooldown = ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_EMERALD_SPEED_RUNNERS_GEM_AMETHYST)
		if e_ability:GetCooldownTimeRemaining() > max_cooldown then
			e_ability:EndCooldown()
			e_ability:StartCooldown(max_cooldown)
		end
	end

end

function falcon_boots_self_thinker(event)
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
	if ability:GetGemValue("ruby") > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_falcon_ruby", {})
		local dmg_stacks = hero:GetActualMovespeed()*ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_FALCON_BOOTS_GEM_RUBY)
		hero:SetModifierStackCount("modifier_falcon_ruby", caster, dmg_stacks)
	end
end

function fire_walkers_base_think(event)	
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability

	if not ability.lava_table then
		ability.lava_table = {}
	end
	Filters:FireWalkersCreateLavaAtPoint(caster, ability, hero, hero:GetAbsOrigin())

end



function fire_walkers_attack_land(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	local target = event.target
	if ability:GetGemValue("ruby") > 0 then
		local proc = ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_FIRE_WALKERS_GEM_RUBY1)
		if proc then
			Filters:FireWalkersCreateLavaAtPoint(caster, ability, hero, target:GetAbsOrigin())
		end
	end
end

function reindex_fire_walkers_table(ability)
	-- local new_flame_table = {}
	-- for i = 1, #ability.lava_table, 1 do
	-- 	if ability.lava_table[i] and IsValidEntity(ability.lava_table[i]) and ability.lava_table[i]:HasModifier("modifier_fire_walkers_thinker") then
	-- 		table.insert(new_flame_table, ability.lava_table[i])
	-- 	end
	-- end
	-- ability.lava_table = new_flame_table
end

function fire_walkers_thinker_end(event)
	local ability = event.ability
	ParticleManager:DestroyParticle(event.target.pfx, false)
	ParticleManager:ReleaseParticleIndex(event.target.pfx)
	UTIL_Remove(event.target)
	-- reindex_fire_walkers_table(ability)
end

function inside_fire_walkers_think(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	local target = event.target
	local damage = hero:GetSumOfAllAttributes()*ITEM_RPC_FIRE_WALKERS_DAMAGE_X_SUM_ATTRIBUTES + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_FIRE_WALKERS_GEM_EMERALD2)
	if event.sapphire == 0 and ability:GetGemValue("sapphire") > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_fire_walkers_sapphire", {duration = ITEM_RPC_FIRE_WALKERS_SAPPHIRE_BURN_DURATION})
	elseif event.sapphire == 1 then
		damage = damage * ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_FIRE_WALKERS_GEM_SAPPHIRE)/100
	end
	Filters:ApplyItemDamage(target, hero, damage, DAMAGE_TYPE_PHYSICAL, ability, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
end

function moon_tech_thinker_end(event)
	local ability = event.ability
	-- ParticleManager:DestroyParticle(event.target.pfx, false)
	-- ParticleManager:ReleaseParticleIndex(event.target.pfx)
	UTIL_Remove(event.target)
	Filters:ReindexMoonTechThinkerTable(ability)
end

function enter_moon_tech_cloud(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	local target = event.target

	if ability:GetGemValue("ruby") > 0 then
		local as_loss = ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_MOON_TECH_RUNNERS_GEM_RUBY1)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_moon_tech_attackspeed_reduce", {})
		target:SetModifierStackCount("modifier_moon_tech_attackspeed_reduce", caster, as_loss)
	end
	if ability:GetGemValue("sapphire") > 0 then
		local miss_Chance = ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_MOON_TECH_RUNNERS_GEM_SAPPHIRE2)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_moon_tech_sapphire_chance_to_miss", {})
		target:SetModifierStackCount("modifier_moon_tech_sapphire_chance_to_miss", caster, miss_Chance)
		
	end
end

function inside_moontech_cloud(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	local target = event.target
	if ability:GetGemValue("ruby") > 0 then
		local damage = OverflowProtectedGetAverageTrueAttackDamage(hero)*(ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_MOON_TECH_RUNNERS_GEM_RUBY2)/100)
		Filters:ApplyItemDamage(target, hero, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_COSMOS, RPC_ELEMENT_NONE)
	end
end

function neptune_puddle_start(event)
	local ability = event.ability
	local target = event.target
	if not ability then
		return false
	end
	local caster = event.caster
	local hero = caster.hero

	if hero == ability.wearer then
		local stacks = ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_NEPTUNES_WATER_GLIDERS_GEM_EMERALD1)
		target:ApplyModifierAndSetStacks(ability, caster, "modifier_neptune_in_puddle_mana_regen", stacks, 0)
	end
end

function neptune_puddle_thinker_end(event)
	local ability = event.ability
	ParticleManager:DestroyParticle(event.target.pfx, false)
	ParticleManager:ReleaseParticleIndex(event.target.pfx)
	UTIL_Remove(event.target)
end

function neptune_blasting_think(event)
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero

	local newPos = hero:GetAbsOrigin() + ability.blast_direction*ability.forward_force + Vector(0,0,ability.blast_force)
	local newPosition = WallPhysics:WallSearch(hero:GetAbsOrigin(), newPos, hero)
	ability.blast_force = ability.blast_force - 1.5
	hero:SetAbsOrigin(newPosition)

	if hero:GetAbsOrigin().z - GetGroundHeight(hero:GetAbsOrigin(), hero) < 10 then
		hero:RemoveModifierByName("modifier_neptune_sapphire_blasting")
		FindClearSpaceForUnit(hero, hero:GetAbsOrigin(), false)
		local radius = ITEM_RPC_NEPTUNES_WATER_GLIDERS_SAPPHIRE_RADIUS
        EmitSoundOn("RPCItems.Neptunes.SapphireImpact", hero)
        local particleName = "particles/roshpit/items/depth_crest_armor.vpcf"
        local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, hero)
        ParticleManager:SetParticleControl(pfx, 0, hero:GetAbsOrigin() + Vector(0, 0, 20))
        ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 1, 1))
 		Timers:CreateTimer(1.5, function()
 			ParticleManager:DestroyParticle(pfx, false)
 		end)
 		local damage = OverflowProtectedGetAverageTrueAttackDamage(hero)*ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_NEPTUNES_WATER_GLIDERS_GEM_SAPPHIRE3)/100
		local stun_duration = ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_NEPTUNES_WATER_GLIDERS_GEM_SAPPHIRE2)
		local enemies = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				Filters:ApplyItemDamage(enemy, hero, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_WATER, RPC_ELEMENT_NONE)
				Filters:ApplyStun(hero, stun_duration, enemy)
			end
		end
	end
end

function oceanrunner_think(event)
	
	local caster = event.caster
	local ability = event.ability
	local hero = caster.hero

	if not ability.lastPos then
		ability.lastPos = hero:GetAbsOrigin()
	end
	if ability:GetGemValue("ruby") > 0 then

		if not ability.distanceMoved then
			ability.distanceMoved = 0
		end
		ability.newPos = hero:GetAbsOrigin()
		ability.hero = target
		local distance = WallPhysics:GetDistance(ability.newPos, ability.lastPos)
		ability.distanceMoved = ability.distanceMoved + distance
		if ability.distanceMoved > ITEM_RPC_OCEANRUNNER_BOOTS_RUBY_TRAVEL_DISTANCE then
			if not ability.active then
				-- StartSoundEvent("Hero_Leshrac.Diabolic_Edict_lp", target)
			end
			ability.active = true
			for i = 1, ability.distanceMoved / ITEM_RPC_OCEANRUNNER_BOOTS_RUBY_TRAVEL_DISTANCE, 1 do
				ocean_runner_ruby_squall(caster, ability, hero)
			end
			ability.distanceMoved = ability.distanceMoved % ITEM_RPC_OCEANRUNNER_BOOTS_RUBY_TRAVEL_DISTANCE
		else
			if distance < 20 then
				ability.active = false
			end
		end
	end
	if ability:GetGemValue("amethyst") > 0 then
		local distance = WallPhysics:GetDistance(hero:GetAbsOrigin(), ability.lastPos)
		if distance > 5 then
			ability:ApplyDataDrivenModifier(caster, hero, "modifier_oceanrunner_atk_power", {})
			hero:SetModifierStackCount("modifier_oceanrunner_atk_power", caster, ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_OCEANRUNNER_BOOTS_GEM_AMETHYST))
		else
			hero:RemoveModifierByName("modifier_oceanrunner_atk_power")
		end
	end


	ability.lastPos = hero:GetAbsOrigin()
end

function ocean_runner_ruby_squall(caster, ability, hero)
	local radius = ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_OCEANRUNNER_BOOTS_GEM_RUBY3)
    EmitSoundOn("RPCItems.Oceanrunners.Ruby", hero)
    local particleName = "particles/roshpit/items/ocean_runner_squall.vpcf"
    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, hero)
    ParticleManager:SetParticleControl(pfx, 0, hero:GetAbsOrigin() + Vector(0, 0, 20))
    ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 1, 1))
	Timers:CreateTimer(1.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	local damage = OverflowProtectedGetAverageTrueAttackDamage(hero)*ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_OCEANRUNNER_BOOTS_GEM_RUBY2)/100
	local stun_duration = ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_OCEANRUNNER_BOOTS_GEM_RUBY1)
	local enemies = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:ApplyItemDamage(enemy, hero, damage, DAMAGE_TYPE_PHYSICAL, ability, RPC_ELEMENT_WIND, RPC_ELEMENT_WATER)
			Filters:ApplyStun(hero, stun_duration, enemy)
		end
	end
end

function pegasus_init(event)
	local caster = event.caster
	local ability = event.ability
	local hero = caster.hero
	if ability:GetGemValue("emerald") > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_pegasus_boots_emerald_ms_pct", {})
		hero:SetModifierStackCount("modifier_pegasus_boots_emerald_ms_pct", caster, ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_PEGASUS_BOOTS_GEM_EMERALD))
	end
end

function pegasus_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local hero = caster.hero
	if ability:GetGemValue("amethyst") > 0 then
		if not ability.lastPos then
			ability.lastPos = hero:GetAbsOrigin()
		end
		local distance = WallPhysics:GetDistance2d(ability.lastPos, hero:GetAbsOrigin())
		if distance > 1 then
			local atk_power_stacks = distance*(ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_PEGASUS_BOOTS_GEM_AMETHYST1)/100)/0.1
			atk_power_stacks = math.min(atk_power_stacks, ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_PEGASUS_BOOTS_GEM_AMETHYST2)/0.1)
			ability:ApplyDataDrivenModifier(caster, hero, "modifier_pegasus_boots_amethyst_atk_power", {})
			hero:SetModifierStackCount("modifier_pegasus_boots_amethyst_atk_power", caster, atk_power_stacks)
		else
			hero:RemoveModifierByName("modifier_pegasus_boots_amethyst_atk_power")
		end
		ability.lastPos = hero:GetAbsOrigin()
	end
end

function pegasus_dash_think(event)
	local ability = event.ability
	local caster = event.caster
	local position = caster:GetAbsOrigin()
	local obstruction = WallPhysics:FindNearestObstruction(position)
	local pushSpeed = 55
	-- pushSpeed = Filters:GetAdjustedESpeed(caster, pushSpeed, false)
	local newPosition = position + ability.forwardVec * pushSpeed
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (position + ability.forwardVec * 72), caster)
	if not blockUnit then
		caster:SetOrigin(newPosition)
	end
end

function pegasus_dash_end(event)
	local caster = event.caster
	local ability = event.ability
	WallPhysics:ClearSpaceForUnit(caster, caster:GetAbsOrigin())
end

function rooted_feet_think(event)
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
	if not ability.lastPos then
		ability.lastPos = hero:GetAbsOrigin()
	end
	local distance = WallPhysics:GetDistance2d(ability.lastPos, hero:GetAbsOrigin())
	if distance < 1 then
		rooted_feet_deep_grip_apply(ability, caster, hero, 0)
	else
		local earth_grip_modifier = hero:FindModifierByName("modifier_rooted_feet_regen_portion")
		if earth_grip_modifier then
			if earth_grip_modifier:GetRemainingTime() < 0 and ability:GetGemValue("ruby") > 0 then
				rooted_feet_deep_grip_apply(ability, caster, hero, ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_ROOTED_FEET_GEM_RUBY))
			elseif earth_grip_modifier:GetRemainingTime() < 0 then
				hero:RemoveModifierByName("modifier_rooted_feet_immobile_active")
			end
		end
	end
	ability.lastPos = hero:GetAbsOrigin()
end

function rooted_feet_deep_grip_apply(ability, caster, hero, duration)
	if duration > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_rooted_feet_immobile_active", {duration = duration})
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_rooted_feet_regen_portion", {duration = duration})
	else
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_rooted_feet_immobile_active", {})
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_rooted_feet_regen_portion", {})
	end
	local health_regen_stacks = (ITEM_RPC_ROOTED_FEET_HP_REGEN_PCT + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_ROOTED_FEET_GEM_EMERALD))/0.1
	hero:SetModifierStackCount("modifier_rooted_feet_regen_portion", caster, health_regen_stacks)
end

function sandstream_think(event)
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
	if ability:GetGemValue("sapphire") > 0 then
		if not ability.interval then
			ability.interval = 0
		end
		local current_stacks = hero:GetModifierStackCount("modifier_sandstream_slippers_stack", caster)
		if current_stacks < ITEM_RPC_SANDSTREAM_SLIPPERS_SAPPHIRE_MAX_STACKS then
			ability.interval = ability.interval + 1
		end
		if ability.interval >= ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_SANDSTREAM_SLIPPERS_GEM_SAPPHIRE) then
			if hero:HasModifier("modifier_sandstream_slippers_stack") then
				local newStacks = math.min(hero:GetModifierStackCount("modifier_sandstream_slippers_stack", caster) + 1, ITEM_RPC_SANDSTREAM_SLIPPERS_SAPPHIRE_MAX_STACKS)
				hero:SetModifierStackCount("modifier_sandstream_slippers_stack", caster, newStacks)
			else
				ability:ApplyDataDrivenModifier(caster, hero, "modifier_sandstream_slippers_stack", {})
				hero:SetModifierStackCount("modifier_sandstream_slippers_stack", caster, 1)
			end
			ability.interval = 0
		end
	end
end

function sandstorm_thinker_think(event)
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
	local target = event.target

	local damage = OverflowProtectedGetAverageTrueAttackDamage(hero)*ITEM_RPC_SANDSTREAM_DMG_PCT_ATK_POWER/100
	local enemies = FindUnitsInRadius(hero:GetTeamNumber(), target:GetAbsOrigin(), nil, target.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	local ms_loss = 0
	local as_loss = 0
	if ability:GetGemValue("ruby") > 0 then
		ms_loss = ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_SANDSTREAM_SLIPPERS_GEM_RUBY1)
		as_loss = ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_SANDSTREAM_SLIPPERS_GEM_RUBY2)
	end
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:ApplyItemDamage(enemy, hero, damage, DAMAGE_TYPE_PHYSICAL, ability, RPC_ELEMENT_EARTH, RPC_ELEMENT_NONE)
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_sandstream_in_sandstorm", {})
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_sandstream_in_sandstorm_checker", {duration = ITEM_RPC_SANDSTREAM_DAMAGE_INTERVAL + 0.1})
			if ms_loss > 0 then
				enemy:ApplyModifierAndSetStacks(ability, caster, "modifier_sandstream_ms_loss", ms_loss, 0)
				enemy:ApplyModifierAndSetStacks(ability, caster, "modifier_sandstream_as_loss", as_loss, 0)
			end
		end
	end

	if ability:GetGemValue("emerald") > 0 then
		local allies = FindUnitsInRadius(hero:GetTeamNumber(), target:GetAbsOrigin(), nil, target.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		if #allies > 0 then
			for _, ally in pairs(allies) do
				if ally == hero then
					hero:AddNewModifier(caster, ability, "modifier_sandstream_slippers_emerald", {duration = ITEM_RPC_SANDSTREAM_DAMAGE_INTERVAL + 0.1})
				end
			end
		end
	end
end

function sandstorm_thinker_end(event)
	local ability = event.ability
	local target = event.target
	Filters:ReindexSandstreamsTable(ability)
	ParticleManager:DestroyParticle(target.pfx, false)
	ParticleManager:ReleaseParticleIndex(target.pfx)
	StopSoundEvent("RPCItems.Sandstream.SandstormLP", target)
	UTIL_Remove(target)
end

function sandstream_unequip(event)
	local ability = event.ability
	if ability.sandstorm_table then
		for i = 1, #ability.sandstorm_table, 1 do
			ability.sandstorm_table[i]:RemoveModifierByName("modifier_sandstream_sandstorm")
		end
	end
end

function gunslinger_think(event)
	local target = event.target
	local ability = event.ability
	if not ability.lastPos then
		ability.lastPos = target:GetAbsOrigin()
	end
	if not ability.distanceMoved then
		ability.distanceMoved = 0
	end
	ability.newPos = target:GetAbsOrigin()
	local distance = WallPhysics:GetDistance2d(ability.newPos, ability.lastPos)
	ability.distanceMoved = ability.distanceMoved + distance
	if ability.distanceMoved > ITEM_RPC_SLINGER_BOOTS_DISTANCE_TO_TRIGGER then
		bladeslinger_trigger(event.caster, ability, target)
		ability.distanceMoved = ability.distanceMoved % ITEM_RPC_SLINGER_BOOTS_DISTANCE_TO_TRIGGER
	end

	ability.lastPos = target:GetAbsOrigin()
end

function bladeslinger_trigger(caster, ability, hero)


	local vorpal_particle = "particles/units/heroes/hero_bounty_hunter/bounty_hunter_suriken_toss_bounce.vpcf"

	local baseFV = hero:GetForwardVector()
	local search_area = hero:GetAbsOrigin()
	local search_radius = ITEM_RPC_SLINGERS_BOOTS_SEARCH_RANGE
	local enemies = FindUnitsInRadius(hero:GetTeamNumber(), search_area, nil, search_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

	ability:ApplyDataDrivenModifier(caster, hero, "modifier_bladeslinker_projectile_thinker", {})

	if not ability.vorpals then
		ability.vorpals = {}
	end
	local extra_ruby_throws = Filters:GetProcCount(caster, ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_SLINGER_BOOTS_GEM_RUBY))
	local total_max_blades = ITEM_RPC_SLINGER_BOOTS_MAX_ACTIVE_BLADES
	local blades_this_throw = ITEM_RPC_SLINGER_BOOTS_BLADES_THROWN + extra_ruby_throws
	local vorpals_for_this_throw = math.min(blades_this_throw, total_max_blades-#ability.vorpals)

	for i = 1, vorpals_for_this_throw do
		local vorpal = {}
		local vorpal_distance = 400
		local vorpal_fv = WallPhysics:rotateVector(baseFV, 2*math.pi*i/vorpals_for_this_throw)
		local vorpal_target = hero:GetAbsOrigin()+vorpal_fv*vorpal_distance + Vector(0,0,160)
		local vorpal_speed = 1000
		local vorpal_origin = hero:GetAbsOrigin() + Vector(0,0,460)

		local bounces = ITEM_RPC_SLINGER_BOOTS_BOUNCE_COUNT + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_SLINGER_BOOTS_GEM_EMERALD1)

		vorpal.active = true
		vorpal.speed = vorpal_speed
		vorpal.position = vorpal_origin
		vorpal.target = vorpal_target
		vorpal.interval = 0
		vorpal.damage = damage
		vorpal.mana_restore = mana_restore

		local pfx = ParticleManager:CreateParticle(vorpal_particle, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, hero:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, vorpal_target)
		ParticleManager:SetParticleControl(pfx, 2, Vector(vorpal_speed, vorpal_speed, vorpal_speed))

		-- ParticleManager:SetParticleControl(pfx, 5, Vector(300, 300, 300))
		vorpal.pfx = pfx
		vorpal.targets_hit = 0
		vorpal.bounces = bounces
		if #enemies > 0 then
			local lock_target = enemies[RandomInt(1, #enemies)]
			vorpal.lock_entity = lock_target
		else
			vorpal.lock_entity = nil
		end
		table.insert(ability.vorpals, vorpal)
	end
	if vorpals_for_this_throw > 0 then
		EmitSoundOn("RPCItems.SlingerBoot.Throw", hero)
	end
	local counter_modifier_name = "modifier_active_bladeslinger_blades"
	ability:ApplyDataDrivenModifier(caster, hero, counter_modifier_name, {})
	hero:SetModifierStackCount(counter_modifier_name, caster, #ability.vorpals)
end

function bladeslinger_unequip(event)
	local ability = event.ability
	if not ability.vorpals then
		return
	end
	for i = 1, #ability.vorpals, 1 do
		ParticleManager:DestroyParticle(ability.vorpals[i].pfx, false)
		ParticleManager:ReleaseParticleIndex(ability.vorpals[i].pfx)	
	end
end

function bladeslinger_projectile_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local hero = caster.hero
	local new_vorpal_table = {}
	local think_interval = 0.1
	if not ability then

		return false
	end
	if not IsValidEntity(ability) then

		return false
	end
	local damage = OverflowProtectedGetAverageTrueAttackDamage(hero)*(ITEM_RPC_SLINGER_BOOTS_DAMAGE_BLADE_PCT_ATK_POWER+ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_SLINGER_BOOTS_GEM_SAPPHIRE2))/100 + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_SLINGER_BOOTS_GEM_EMERALD2)
	local element2 = RPC_ELEMENT_NORMAL
	local damagetype = DAMAGE_TYPE_PHYSICAL
	for i = 1, #ability.vorpals, 1 do
		local vorpal = ability.vorpals[i]
		if vorpal.active then
			vorpal.speed = math.min(vorpal.speed + 70, 1300)
			local direction = (vorpal.target - vorpal.position):Normalized()
			vorpal.position = vorpal.position + vorpal.speed*think_interval*direction
			vorpal.interval = vorpal.interval + 1

			if vorpal.interval >= 4 then
				if IsValidEntity(vorpal.lock_entity) and vorpal.lock_entity:IsAlive() then
					vorpal.target = vorpal.lock_entity:GetAbsOrigin() + Vector(0,0,30)
				end
			end
			if vorpal.interval >= 120 then
				vorpal.active = false
			end

			local distance = WallPhysics:GetDistance2d(vorpal.position, vorpal.target)
			
			if distance <= (vorpal.speed*think_interval) then
				-- CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf", vorpal.position, 3)
				if vorpal.targets_hit < (vorpal.bounces - 1) then
					vorpal.targets_hit = vorpal.targets_hit + 1
					local nearby_enemies = FindUnitsInRadius(hero:GetTeamNumber(), vorpal.position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
					local new_target = nil
					if #nearby_enemies > 0 then
						if IsValidEntity(vorpal.lock_entity) then
							for _, enemy in pairs(nearby_enemies) do
								if enemy:GetEntityIndex() ~= vorpal.lock_entity:GetEntityIndex() then
									new_target = enemy
									break
								end
								-- Filters:TakeArgumentsAndApplyDamage(enemy, hero, damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_R, RPC_ELEMENT_EARTH, RPC_ELEMENT_NONE)
							end
						else
							new_target = nearby_enemies[1]
						end
					end
					if IsValidEntity(vorpal.lock_entity) then
						EmitSoundOn("RPCItems.SlingerBoot.Impact", vorpal.lock_entity)
						if not vorpal.lock_entity.dummy then
							Filters:ApplyItemDamage(vorpal.lock_entity, hero, damage, DAMAGE_TYPE_PHYSICAL, ability, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
						end
					end
					if IsValidEntity(new_target) then
						vorpal.lock_entity = new_target
						vorpal.target = vorpal.lock_entity:GetAbsOrigin()
					else
						vorpal.active = false
					end

				else
					vorpal.active = false
				end
			end
			if vorpal.active then
				ParticleManager:SetParticleControl(vorpal.pfx, 1, vorpal.target)
				ParticleManager:SetParticleControl(vorpal.pfx, 2, Vector(vorpal.speed, vorpal.speed, vorpal.speed))
				table.insert(new_vorpal_table, vorpal)
			else
				ParticleManager:DestroyParticle(vorpal.pfx, false)
				ParticleManager:ReleaseParticleIndex(vorpal.pfx)	
			end			
		end
	end
	ability.vorpals = new_vorpal_table

	local counter_modifier_name = "modifier_active_bladeslinger_blades"
	if #ability.vorpals > 0 then
		hero:SetModifierStackCount(counter_modifier_name, caster, #ability.vorpals)
	else
		hero:RemoveModifierByName(counter_modifier_name)
	end
end

function blade_slinger_sapphire_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local hero = target
	if ability:GetGemValue("amethyst") > 0 then
		if not ability.amethyst_interval then
			ability.amethyst_interval = 0
		end
		ability.amethyst_interval = ability.amethyst_interval + 1
		if ability.amethyst_interval >= ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_SLINGER_BOOTS_GEM_AMETHYST2)/0.2 then
			if hero:IsAlive() then
				local lookupPoint = hero:GetAbsOrigin() - hero:GetForwardVector() * 120
				local enemies_initial = FindUnitsInRadius(hero:GetTeamNumber(), lookupPoint, nil, 280, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
				local enemies = {}
				for i = 1, #enemies_initial, 1 do
					local check_enemy = enemies_initial[i]
					if not check_enemy:HasModifier("modifier_possession_enemy_lock") then
						if not check_enemy.dummy then
							table.insert(enemies, check_enemy)
						end
					end
				end
				if #enemies > 0 then
					local facingVector = ((enemies[1]:GetAbsOrigin() - hero:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
					local angle = WallPhysics:vectorToAngle(facingVector)
					hero:SetAngles(0, angle, 0)
					Timers:CreateTimer(0.42, function()
						hero:SetAngles(0, 0, 0)
					end)
					StartAnimation(hero, {duration = 0.5, activity = ACT_DOTA_ATTACK, rate = 3.2})
					if not hero:IsStunned() and not hero:IsDisarmed() then
						for _, enemy in pairs(enemies) do
							Filters:PerformAttackSpecial(hero, enemy, true, true, true, false, true, false, false)
						end
					end
				end
			end
			ability.amethyst_interval = 0
		end
	end
end

function temporal_warp_boots_channeling_end(event)
	local caster = event.caster
	local ability = event.ability
	local hero = caster.hero
	ParticleManager:DestroyParticle(hero.temporal_warp_boots.pfx, false)
	hero.temporal_warp_boots.pfx = false

	local checker = hero:FindModifierByName("modifier_temporal_warp_boots_hidden_channel_checker")
	if checker and checker:GetRemainingTime() <= 0.12 then
		if hero:IsStunned() or hero:IsFrozen() or hero:IsRooted() then
			EmitSoundOn("RPCItems.TemporalWarpBoots.TeleportFail", hero)
		else
			Events:LockCamera(hero)
			FindClearSpaceForUnit(hero, hero.temporal_warp_boots.teleportPosition, false)
			EmitSoundOn("RPCItems.TemporalWarpBoots.TeleportEnd", hero)
			StartAnimation(hero, {duration = 1, activity = ACT_DOTA_SPAWN, rate = 1})
			EmitSoundOn("RPCItems.TemporalWarpBoots.TeleportFail", hero)
		end
	else
		EmitSoundOn("RPCItems.TemporalWarpBoots.TeleportFail", hero)
	end
	hero:RemoveModifierByName("modifier_temporal_warp_boots_hidden_channel_checker")
	StopSoundEvent("RPCItems.TemporalWarpBoots.TeleportLP", hero)

end

function temporal_warp_boots_channeling_take_damage(event)
	local hero = event.caster.hero
	local damage = event.damage
	local attacker = event.attacker
	if damage >= 10 and attacker:GetTeamNumber() ~= hero:GetTeamNumber() then
		hero:RemoveModifierByName("modifier_temporal_warp_boots_channeling")
	end
end

function terrasic_lava_boots_think(event)
	local caster = event.caster
	local ability = event.ability
	local hero = caster.hero
	if ability:GetGemValue("sapphire") > 0 then
		local ability = event.ability
		if not ability.lastPos then
			ability.lastPos = hero:GetAbsOrigin()
		end
		if not ability.distanceMoved then
			ability.distanceMoved = 0
		end
		ability.newPos = hero:GetAbsOrigin()
		local distance = WallPhysics:GetDistance2d(ability.newPos, ability.lastPos)
		ability.distanceMoved = ability.distanceMoved + distance
		if ability.distanceMoved > ITEM_RPC_TERRASIC_LAVA_BOOTS_SAPPHIRE_DISTANCE then
			terrasic_lava_boots_fireling(caster, ability, hero)
			ability.distanceMoved = ability.distanceMoved % ITEM_RPC_TERRASIC_LAVA_BOOTS_SAPPHIRE_DISTANCE
		end

		ability.lastPos = hero:GetAbsOrigin()
	end
end

function terrasic_lava_boots_emerald_flame_impact(event)
	local caster = event.caster
	local ability = event.ability
	local hero = ability.wearer
	local target = event.target
	local damage = OverflowProtectedGetAverageTrueAttackDamage(hero)*ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_TERRASIC_LAVA_BOOTS_GEM_EMERALD2)/100
	Filters:ApplyItemDamage(target, hero, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
end

function terrasic_lava_boots_fireling(caster, ability, hero)
	local position = hero:GetAbsOrigin() + RandomVector(150)
	local fireling = CreateUnitByName("terrasic_lava_boots_fireling", position, false, nil, nil, caster:GetTeamNumber())
	fireling.owner = caster:GetPlayerOwnerID()
	fireling.summoner = caster
	fireling:SetOwner(caster)
	fireling:SetControllableByPlayer(hero:GetPlayerID(), true)
	fireling.dieTime = ITEM_RPC_TERRASIC_LAVA_BOOTS_SAPPHIRE_DURATION
	fireling:AddAbility("ability_die_after_time_generic"):SetLevel(1)
	fireling.hero = hero
	Events:smoothSizeChange(fireling, 0.01, 0.8, 30)
	fireling:SetBaseMoveSpeed(400)
	fireling:SetAcquisitionRange(3000)
	local health_mult = ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_TERRASIC_LAVA_BOOTS_GEM_SAPPHIRE1)/100
	local attack_mult = ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_TERRASIC_LAVA_BOOTS_GEM_SAPPHIRE2)/100
	fireling:AdjustSummon(hero, true, health_mult, attack_mult, 1, 1, 1, 1)
	ability:ApplyDataDrivenModifier(caster, fireling, "modifier_rpc_terrasic_lava_boot_effect", {})
	CustomAbilities:QuickAttachParticle("particles/econ/items/invoker/glorious_inspiration/invoker_forge_spirit_ambient_esl.vpcf", fireling, 3)
	EmitSoundOn("RPCItems.TerrasicLavaBoots.SapphireSummon", fireling)
	local armor_break_level = math.min(3, ability:GetGemValue("sapphire"))
	fireling:FindAbilityByName("armor_break"):SetLevel(armor_break_level)
end

function tranquil_boots_think(event)
	local target = event.target
	local ability = event.ability
	if not ability.lastPos then
		ability.lastPos = target:GetAbsOrigin()
	end
	if not ability.distanceMoved then
		ability.distanceMoved = 0
	end
	ability.newPos = target:GetAbsOrigin()
	ability.hero = target
	local distance = WallPhysics:GetDistance(ability.newPos, ability.lastPos)
	ability.distanceMoved = ability.distanceMoved + distance
	if ability.distanceMoved > ITEM_RPC_TRANQUIL_BOOTS_DISTANCE then
		if not ability.active then
			-- StartSoundEvent("RPCItems.TranquilBoots.LP", target)
		end
		ability.active = true
		tranquil_boots_heal(target)
		ability.distanceMoved = ability.distanceMoved % ITEM_RPC_TRANQUIL_BOOTS_DISTANCE
	else
		if distance < 20 then
			ability.active = false
			-- StopSoundEvent("RPCItems.TranquilBoots.LP", target)
		end
	end
	-- if distance > 20 then
		-- if not ability.pfx then
		-- 	ability.pfx = CustomAbilities:QuickAttachParticle("particles/items_fx/healing_flask.vpcf", target, 0)
		-- end
	-- else
		-- if ability.pfx then
		-- 	ParticleManager:DestroyParticle(ability.pfx, false)
		-- 	ability.pfx = nil
		-- end
	-- end
	ability.lastPos = target:GetAbsOrigin()
end

function tranquil_boots_heal(hero)
	local healthRestore = math.floor(hero:GetMaxHealth() * ITEM_RPC_TRANQUIL_BOOTS_HP_HEAL_PCT/100)
	local particleName = "particles/items2_fx/tranquil_boots.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, hero)
	ParticleManager:SetParticleControlEnt(pfx, 0, hero, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)
	Timers:CreateTimer(1, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	Filters:ApplyHeal(hero, hero, healthRestore, true, true)
end

function tranquil_boots_amethyst_think(event)
	local ability = event.ability
	local hero = event.caster.hero

	local healthRestore = math.floor(hero:GetMaxHealth() * ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_TRANQUIL_BOOTS_GEM_AMETHYST)/100)
	Filters:ApplyHeal(hero, hero, healthRestore, true, true)
end

function tranquil_boots_amethyst_end(event)
	local ability = event.ability
	if ability.pfx_table then
		for i = 1, #ability.pfx_table, 1 do
			ParticleManager:DestroyParticle(ability.pfx_table[i], false)
		end
		ability.pfx_table = false
	end
end


function aeriths_tear_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local hero = caster.hero

	if hero:GetHealth() < hero:GetMaxHealth()*(ITEM_RPC_AERITHS_TEAR_HP_THRESHOLD/100) then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_aeriths_tear_active_effect", {})
	else
		hero:RemoveModifierByName("modifier_aeriths_tear_active_effect")
	end
	if ability:GetGemValue("emerald") > 0 or ability:GetGemValue("sapphire") > 0 then
		local enemies = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin(), nil, ITEM_RPC_AERITHS_TEAR_DISTANCE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		ability.nearby_enemies = #enemies
	end
	if not hero:HasModifier("modifier_aeriths_range_indicator") then
		if ability:GetGemValue("ruby") > 0 or ability:GetGemValue("emerald") > 0 or ability:GetGemValue("sapphire") > 0 then
			ability:ApplyDataDrivenModifier(caster, hero, "modifier_aeriths_range_indicator", {})
		end
	end
end

function ankh_of_ancients_shield_think(event)
	local caster = event.target
	local ability = event.ability
	local hero = caster
	if GameRules:GetGameTime() - ability.ankh_apply_time > ITEM_RPC_ANKH_OF_THE_ANCIENTS_DURATION_MAX then
		caster:RemoveModifierByName("modifier_ankh_of_ancients_shield")
	end
	if ability:GetGemValue("emerald") > 0 then
		local healthRestore = math.ceil(hero:GetMaxHealth() * ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_ANKH_OF_THE_ANCIENTS_GEM_EMERALD)/100)
		Filters:ApplyHeal(hero, hero, healthRestore, true, true)
	end
end
function ankh_of_ancients_end(event)
	local caster = event.target
	local ability = event.ability
	-- local ankh_duration = GameRules:GetGameTime() - caster.amulet.ankh_apply_time
	-- caster.amulet:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_ankh_of_ancients_cooldown", {duration = ankh_duration * ITEM_RPC_ANKH_OF_THE_ANCIENTS_COOLDOWN})
end

function ankh_of_ancients_respawning_end(event)
	local caster = event.caster
	local ability = event.ability
	local hero = caster.hero
	local ankh = ability
	StopSoundEvent("AnkhOfAncients.Death", hero)
    ability.ankh_apply_time = GameRules:GetGameTime()
    local shield_duration = ITEM_RPC_ANKH_OF_THE_ANCIENTS_SHIELD_DURATION + ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_ANKH_OF_THE_ANCIENTS_GEM_AMETHYST)
    local shield_cooldown = ITEM_RPC_ANKH_OF_THE_ANCIENTS_COOLDOWN - ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_ANKH_OF_THE_ANCIENTS_GEM_SAPPHIRE)
    ability:ApplyDataDrivenModifier(caster, hero, "modifier_ankh_of_ancients_shield", {duration = shield_duration})
    ankh:ApplyDataDrivenModifier(caster, hero, "modifier_ankh_of_ancients_cooldown", {duration = shield_cooldown})
    hero:RemoveNoDraw()
    if ankh:GetGemValue("emerald") > 0 then
    	ability:ApplyDataDrivenModifier(caster, hero, "modifier_ankh_of_ancients_emerald_visual", {duration = shield_duration})
    end
    EmitSoundOn("AnkhOfAncients.Respawn", hero)
    FindClearSpaceForUnit(hero, hero:GetAbsOrigin(), false)
    CustomAbilities:QuickParticleAtPoint("particles/roshpit/items/ankh_of_ancients_respawn.vpcf", hero:GetAbsOrigin(), 3)
end

function mana_relic_attack(event)
	local attacker = event.attacker
	local ability = event.ability
	local caster = event.caster
	if ability:GetGemValue("ruby") > 0 then
		CustomAbilities:QuickAttachParticle("particles/roshpit/items/antique_mana_relic_restore.vpcf", attacker, 1.5)
		local manaRestore = attacker:GetMaxMana() * ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_ANTIQUE_MANA_RELIC_GEM_RUBY)/100
		attacker:GiveMana(manaRestore)
		PopupMana(attacker, manaRestore)
	end
end

function mana_relic_think(event)
	local caster = event.caster
	local ability = event.ability
	local hero = caster.hero

	local threshold = ITEM_RPC_ANTIQUE_MANA_RELIC_MANA_DRAIN - ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_ANTIQUE_MANA_RELIC_GEM_AMETHYST)

	if hero:GetMana() < hero:GetMaxMana()*(threshold/100) then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_mana_relic_silence", {})
	else
		hero:RemoveModifierByName("modifier_mana_relic_silence")
	end

	if ability:GetGemValue("emerald") > 0 then
		local damageBoost = hero:GetMana() * ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_ANTIQUE_MANA_RELIC_GEM_EMERALD)
		if damageBoost > 0 then
			if not hero:HasModifier("modifier_mana_relic_attack_damage") then
				ability:ApplyDataDrivenModifier(caster, hero, "modifier_mana_relic_attack_damage", {})
			end
			hero:SetModifierStackCount("modifier_mana_relic_attack_damage", caster, damageBoost)
		else
			hero:RemoveModifierByName("modifier_mana_relic_attack_damage")
		end
	end
end

function divinex_init(event)
	local hero = event.caster.hero
	hero:SetStatsForLevel()
end

function divinex_end(event)
	local hero = event.caster.hero
	hero:SetStatsForLevel()
end

function fenrir_fang_attack_land(event)
	local attacker = event.attacker
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	if ability:GetGemValue("sapphire") > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_fenrir_fang_sapphire", {duration = ITEM_RPC_FENRIRS_FANG_ARMOR_LOSS_DURATION})
	end
end

function firelock_think(event)
	local caster = event.caster
	local ability = event.ability
	local hero = caster.hero
	if ability:GetGemValue("sapphire") > 0 then
		local as_bonus = (hero:GetStrength() + hero:GetAgility())*ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_FIRELOCK_PENDANT_GEM_SAPPHIRE)
		--print("AS BONUS: "..as_bonus)
		hero:ApplyModifierAndSetStacks(ability, caster, "modifier_firelock_sapphire_attackspeed", as_bonus, 0)
	end
	if ability:GetGemValue("amethyst") > 0 then
		local atk_dmg_bonus = (hero:GetSpirit())*ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_FIRELOCK_PENDANT_GEM_AMETHYST)
		hero:ApplyModifierAndSetStacks(ability, caster, "modifier_firelock_amethyst_attack_damage", atk_dmg_bonus, 0)
	end
end

function galaxy_orb_channel_begin(event)
	local caster = event.target
	local ability = event.ability
	local particleName = "particles/units/heroes/hero_enigma/enigma_midnight_pulse.vpcf"
	ability.pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)

	local position = caster:GetAbsOrigin()
	local radius = ITEM_RPC_GALAXY_ORB_RADIUS + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_GALAXY_ORB_GEM_RUBY1)
	ability.radius = radius
	ability.vacuum_speed = ITEM_RPC_GALAXY_ORB_BASE_VACUUM_SPEED + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_GALAXY_ORB_GEM_RUBY2)
	ability.emerald_level = ability:GetGemValue("emerald")
	ability.emerald_freeze_duration = ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_GALAXY_ORB_GEM_EMERALD2)
	ParticleManager:SetParticleControl(ability.pfx, 0, position)
	ParticleManager:SetParticleControl(ability.pfx, 1, Vector(radius, 2, radius * 2))

	ability.suction_units_table = {}
	ability.position = position
end

function galaxy_orb_suction(event)
	local caster = event.target
	local ability = event.ability
	local position = ability.position
	local radius = ability.radius
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			if enemy.jumpLock or enemy.pushlock then
			else
				local enemyPosition = enemy:GetAbsOrigin()
				local movementVector = (position - enemyPosition):Normalized()
				local distance = WallPhysics:GetDistance2d(enemyPosition, position)
				if distance > ability.vacuum_speed*4 then
					local newPosition = GetGroundPosition(enemyPosition + movementVector * ability.vacuum_speed, enemy)
					enemy:SetOrigin(newPosition)
				end
			end
			if not ability.suction_units_table[enemy:GetEntityIndex()] then
				ability.suction_units_table[enemy:GetEntityIndex()] = 0
			end
			if ability.emerald_level > 0 then
				if not enemy:HasModifier("modifier_galaxy_orb_emerald_freeze_effect") then
					ability.suction_units_table[enemy:GetEntityIndex()] = ability.suction_units_table[enemy:GetEntityIndex()] + 1
					if ability.suction_units_table[enemy:GetEntityIndex()] >= (ITEM_RPC_GALAXY_ORB_EMERALD_TIME_TO_FREEZE/0.033 - 5) then
						ability:ApplyDataDrivenModifier(event.caster, enemy, "modifier_galaxy_orb_emerald_freeze_effect", {duration = ability.emerald_freeze_duration})
					end
				end
			end
		end
	end
end

function galaxy_orb_channel_end(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	ParticleManager:DestroyParticle(ability.pfx, false)
	if ability.can_stick and ability:GetGemValue("sapphire") > 0 then
		ability.can_stick = false
		ability:ApplyDataDrivenModifier(caster, target, "modifier_galaxy_orb_channel", {duration = ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_GALAXY_ORB_GEM_SAPPHIRE1)})
	else
		for key, value in pairs(ability.suction_units_table) do
			local entity = EntIndexToHScript(key)
			if entity and IsValidEntity(entity) and entity:IsAlive() then
				FindClearSpaceForUnit(entity, entity:GetAbsOrigin(), false)
			end
		end
	end
end

function garnet_warfare_think(event)
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
	if ability:GetGemValue("sapphire") > 0 then
		local attack_power = ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_GARNET_WARFARE_RING_GEM_SAPPHIRE)
		hero:ApplyModifierAndSetStacks(ability, caster, "modifier_garnet_warfare_ring_sapphire_attack_power", attack_power, 0)
	end
	if ability:GetGemValue("amethyst") > 0 then
		local attack_damage = (hero:GetSpirit()+hero:GetStrength())*ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_GARNET_WARFARE_RING_GEM_AMETHYST)
		hero:ApplyModifierAndSetStacks(ability, caster, "modifier_garnet_warfare_ring_amethyst_base_attack", attack_damage, 0)
	end
end

function eternal_frost_slowing(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster

	if ability:GetGemValue("amethyst") > 0 then
		if not target:HasModifier("modifier_eternal_frost_nova") then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_eternal_frost_slowing_effect", {duration = 3})
			local newStacks = target:GetModifierStackCount("modifier_eternal_frost_slowing_effect", caster) + 1
			target:SetModifierStackCount("modifier_eternal_frost_slowing_effect", caster, newStacks)

			local actual_ms_loss = newStacks*ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_GEM_OF_ETERNAL_FROST_GEM_AMETHYST1)
			ability:ApplyDataDrivenModifier(caster, target, "modifier_eternal_frost_slowing_effect_movespeed_portion", {duration = 3})
			target:SetModifierStackCount("modifier_eternal_frost_slowing_effect_movespeed_portion", caster, actual_ms_loss)
			local movespeed = target:GetBaseMoveSpeed()
			local movespeedModifier = target:GetMoveSpeedModifier(movespeed, false)
			if movespeedModifier <= ITEM_RPC_GEM_OF_ETERNAL_FROST_AMETHYST_MS_THRESHOLD then
				local root_duration = ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_GEM_OF_ETERNAL_FROST_GEM_AMETHYST2)
				ability:ApplyDataDrivenModifier(caster, target, "modifier_eternal_frost_nova", {duration = root_duration})
				target:RemoveModifierByName("modifier_eternal_frost_slowing_effect")
				EmitSoundOn("RPCItem.EternalFrostFreeze", target)
			else
			end
		end
	end
end

function oceanis_think(event)
	local caster = event.caster
	local ability = event.ability
	local hero = caster.hero
	if hero:GetHealth() < hero:GetMaxHealth() then
		local healAmount = hero:GetMaxHealth()*ITEM_RPC_SPARKLING_TOKEN_OF_OCEANIS_HEALTH_RESTORE/100
		Filters:ApplyHeal(hero, hero, healAmount, true, true)
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_oceanis_visual", {})
	else
		hero:RemoveModifierByName("modifier_oceanis_visual")
	end
	if ability:GetGemValue("sapphire") > 0 and hero:GetMana() < hero:GetMaxMana() then
		local mana_restore = hero:GetMaxMana()*ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_SPARKLING_TOKEN_OF_OCEANIS_GEM_SAPPHIRE)/100
		caster:GiveMana(mana_restore)
		PopupMana(hero, mana_restore)
	end
end

function stargazer_take_damage(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	local target = event.unit
	local damage = OverflowProtectedGetAverageTrueAttackDamage(hero)*(ITEM_RPC_STARGAZERS_SPHERE_STARFALL_DMG_PCT_ATK_POWER/100)
	if target:HasModifier("modifier_stargazer_immunity") then
		return false
	end
	local star_cd = ITEM_RPC_STARGAZERS_SPHERE_STARFALL_CD - ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_STARGAZERS_SPHERE_GEM_SAPPHIRE1)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_stargazer_immunity", {duration = star_cd})
      local particleName = "particles/units/heroes/hero_mirana/mirana_starfall_attack.vpcf"
      local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
      ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
      Timers:CreateTimer(0.6, function() 
        ParticleManager:DestroyParticle( pfx, false )
      end)  
          Timers:CreateTimer(0.45, -- Start this timer 10 game-time seconds later
          function()
            if target:IsAlive() then
              Filters:ApplyItemDamage(target,hero,damage,DAMAGE_TYPE_PURE,ability,RPC_ELEMENT_COSMOS,RPC_ELEMENT_NONE)
              EmitSoundOn("RPCItems.Stargazer.Starfall", target)
            end
          end)
	
end

function stargazer_end(event)
	local ability = event.ability
    if ability.sphereTable and ability.sphereTable.pfx then  
        ParticleManager:DestroyParticle(ability.sphereTable.pfx, false)  
        ability.sphereTable.pfx = false  
    end 
end

function falcon_ring_attack_land(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	if ability:GetGemValue("sapphire") > 0 then
		hero:RemoveModifierByName("modifier_tempest_falcon_sapphire_attack_power")
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_tempest_falcon_sapphire_armors", {})
	end
end

function falcon_ring_take_damage(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	if ability:GetGemValue("sapphire") > 0 then
		hero:RemoveModifierByName("modifier_tempest_falcon_sapphire_armors")
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_tempest_falcon_sapphire_attack_power", {})
		local stacks = ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_TEMPEST_FALCON_RING_GEM_SAPPHIRE2)
		hero:SetModifierStackCount("modifier_tempest_falcon_sapphire_attack_power", caster, stacks)
	end
end

function infernal_reign_ai_on(event)
	local caster = event.caster
	caster:SetAcquisitionRange(1200)
end

function infernal_reign_ai_off(event)
	local caster = event.caster
	caster:SetAcquisitionRange(0)
end

function infernal_reign_ai_think(event)
	local caster = event.caster
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), caster.hero:GetAbsOrigin())
	if not caster.moveLock then
		if distance > 1200 then
			caster:MoveToPosition(caster.hero:GetAbsOrigin()+RandomVector(240))
			caster.moveLock = true
			Timers:CreateTimer(4, function()
				caster.moveLock = false
			end)
		elseif distance > 300 then
			caster:MoveToPositionAggressive(caster.hero:GetAbsOrigin()+RandomVector(240))
			caster.moveLock = true
			Timers:CreateTimer(4, function()
				caster.moveLock = false
			end)
		end
	end
	local fire_ability = caster:FindAbilityByName("infernal_reign_amethyst_ability")
	if fire_ability and fire_ability:IsFullyCastable() then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = fire_ability:entindex(),
			}
			ExecuteOrderFromTable(newOrder)
			return			
		end
	end
end

function tome_of_chaos_emerald_thinker(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	local infernal = event.target
	if not ability then
		return false
	end
	local damage = OverflowProtectedGetAverageTrueAttackDamage(infernal)*ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_TOME_OF_CHAOS_GEM_EMERALD)/100
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), infernal:GetAbsOrigin(), nil, ITEM_RPC_TOME_OF_CHAOS_EMERALD_BURN_RANGE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:ApplyItemDamage(enemy, hero, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_DEMON, RPC_ELEMENT_FIRE)
			hero.equipped_gear[RPC_GEAR_SLOT_TRINKET]:ApplyDataDrivenModifier(hero.InventoryUnit, enemy, "modifier_infernal_emerald_pfx", {duration = 0.5})
		end
	end
end

function infernal_reign_amethyst_ability_activate(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	local tome = hero.equipped_gear[RPC_GEAR_SLOT_TRINKET]
	StartAnimation(caster, {duration = 1, activity = ACT_DOTA_ATTACK, rate = 1.0})
	local flame_count = 9
	EmitSoundOn("RPCItems.TomeOfChaos.FlameSpiral", caster)
	for i = 1, flame_count, 1 do
		local fv = WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi*i/flame_count)
		local start_radius = 200
		local end_radius = 340
		local range = 600 + tome:GetGemValue("amethyst") * 50
		local speed = 1000
		local projectileParticle = "particles/roshpit/items/tome_of_chaos_flame.vpcf"
		local projectile_origin = caster:GetAbsOrigin() + caster:GetForwardVector()*60
		local info =
		{
			Ability = ability,
			EffectName = projectileParticle,
			vSpawnOrigin = projectile_origin,
			fDistance = range,
			fStartRadius = start_radius,
			fEndRadius = end_radius,
			Source = caster,
			StartPosition = "attach_attack1",
			bHasFrontalCone = true,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 5.0,
			bDeleteOnHit = false,
			vVelocity = fv * speed,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
	end
end

function infernal_reign_amethyst_impact(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	local target = event.target
	hero.equipped_gear[RPC_GEAR_SLOT_TRINKET]:ApplyDataDrivenModifier(hero.InventoryUnit, target, "modifier_infernal_reign_amethyst_armor_loss", {duration = ITEM_RPC_TOME_OF_CHAOS_AMETHYST_ARMOR_LOSS_DURATION})
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)*hero.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_TOME_OF_CHAOS_GEM_AMETHYST1)/100
	Filters:ApplyItemDamage(target, hero, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_DEMON, RPC_ELEMENT_FIRE)
end

function torch_of_gengar_think(event)
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
	if not hero:HasModifier("modifier_torch_of_gengar_inactive") then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_torch_of_gengar_effect", {})
		local atk_penalty = ITEM_RPC_TORCH_OF_GENGAR_REDUCED_ATTACK_DAMAGE - ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_TORCH_OF_GENGAR_GEM_SAPPHIRE)
		if atk_penalty > 0 then
			ability:ApplyDataDrivenModifier(caster, hero, "modifier_torch_of_gengar_attack_penalty", {})
			hero:SetModifierStackCount("modifier_torch_of_gengar_attack_penalty", caster, atk_penalty)
		end
	end
end

function rupthold_think(event)
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero

	local health_regen_loss_per_stack = 0.1
	hero:RemoveModifierByName("modifier_rupthold_regen_reduction")
	local health_regen_loss = hero:GetHealthRegen()
	if ability:GetGemValue("emerald") > 0 then
		health_regen_loss = health_regen_loss - (hero:GetMaxHealth()*(ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_RUPTHOLDS_HELM_OF_GLUTTONY_EMERALD))/100)
	end
	ability:ApplyDataDrivenModifier(caster, hero, "modifier_rupthold_regen_reduction", {})
	
	hero:SetModifierStackCount("modifier_rupthold_regen_reduction", caster, health_regen_loss/health_regen_loss_per_stack)

	if hero:HasModifier("modifier_rupthold_borrowed_time") then
		if ability.apply_time + ITEM_RPC_RUPTHOLDS_HELM_OF_GLUTTONY_SAPPHIRE_MAX_DURATION < GameRules:GetGameTime() then
			hero:RemoveModifierByName("modifier_rupthold_borrowed_time")
		end
	end
end

function adamantine_samurai_think(event)
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero

	if ability:GetGemValue("emerald") > 0 then
		local attack_damage_bonus = hero:GetRoshpitArmor()*ability:GetFinalGemPropertyValue("emerald", ADAMANTINE_SAMURAI_HELMET_EMERALD)
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_samurai_helmet_emerald", {})
		hero:SetModifierStackCount("modifier_samurai_helmet_emerald", caster, attack_damage_bonus)
	end
end

function umbral_sentinel_init(event)
	local ability = event.ability
	local caster = event.caster
	local hero = caster.hero
	if ability:GetGemValue("ruby") > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_umbral_sentinel_aura", {})
	end
end