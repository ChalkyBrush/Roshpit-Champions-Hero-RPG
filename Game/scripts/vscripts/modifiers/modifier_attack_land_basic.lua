modifier_attack_land_basic = class({})

function modifier_attack_land_basic:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_attack_land_basic:OnAttackLanded(event)
	if not Events.GameMasterAttackAbility then return end
	local parent = self:GetParent()
	local elements = { RPC_ELEMENT_NORMAL }
	local damageType = DAMAGE_TYPE_PHYSICAL
	if event.attacker == parent then
		-- SPECIAL AUTO ATTACK TRANSLATES -- REFACTOR ??
		if parent:HasModifier("modifier_samurai_helmet") then
			event.damage = Filters:SamuraiAttackLand(event.damage, parent, event.target)
		end
		if parent:HasModifier("modifier_fenrirs_fang") then
			event.damage = Filters:FenrirAttackLand(event.damage, parent, event.target)
		end
		if parent:GetUnitName() == "ruby_dragon_3" then
			local damage = OverflowProtectedGetAverageTrueAttackDamage(parent)
			Filters:ApplyItemDamage(event.target, parent.hero, damage, DAMAGE_TYPE_PHYSICAL, parent.hero.equipped_gear[RPC_GEAR_SLOT_HEAD], RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
			if parent.hero.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetGemValue("amethyst") > 0 then
				local enemies = FindUnitsInRadius(parent.hero:GetTeamNumber(), event.target:GetAbsOrigin(), nil, parent.attack_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
				if #enemies > 0 then
					local splash_damage = damage*(parent.hero.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("amethyst", RUBY_DRAGON_AMETHYST)/100)
					for _, enemy in pairs(enemies) do
						Filters:ApplyItemDamage(enemy, parent.hero, splash_damage, DAMAGE_TYPE_PHYSICAL, parent.hero.equipped_gear[RPC_GEAR_SLOT_HEAD], RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
					end
				end
				local particle = ParticleManager:CreateParticle("particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf", PATTACH_WORLDORIGIN, target)
				ParticleManager:SetParticleControl(particle, 0, event.target:GetAbsOrigin())
				ParticleManager:SetParticleControl(particle, 1, Vector(parent.attack_aoe, parent.attack_aoe, parent.attack_aoe))
				ParticleManager:SetParticleControl(particle, 2, Vector(0.8, 0.8, 0.8))
				ParticleManager:SetParticleControl(particle, 4, Vector(245, 50, 120))
				Timers:CreateTimer(1.5, function()
					ParticleManager:DestroyParticle(particle, false)
				end)
			end
			return false
		elseif parent:GetUnitName() == "thorok_reborn" then
			local damage = OverflowProtectedGetAverageTrueAttackDamage(parent)
			Filters:ApplyItemDamage(event.target, parent.hero, damage, DAMAGE_TYPE_PHYSICAL, parent.hero.equipped_gear[RPC_GEAR_SLOT_HEAD], RPC_ELEMENT_UNDEAD, RPC_ELEMENT_NONE)
			if parent.hero.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetGemValue("emerald") > 0 then
				local adjusted_damage = CustomAttributes:AdjustDamageForRoshpitAttributes(parent, event.target, DAMAGE_TYPE_PHYSICAL, damage, parent.hero.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetEntityIndex())
				local lifesteal = math.floor(adjusted_damage * parent.hero.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("emerald", DESERT_NECROMANCER_EMERALD)/100)
				print(lifesteal)
				Filters:ApplyHeal(parent.hero, parent.hero, lifesteal, true, true)
				Filters:ApplyHeal(parent, parent, lifesteal, true, true)

				local particleName = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
				local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, parent)
				ParticleManager:SetParticleControlEnt(pfx, 0, parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(pfx, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin() + Vector(0, 0, 70), true)
				Timers:CreateTimer(1, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)	
				local particleName = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
				local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, parent.hero)
				ParticleManager:SetParticleControlEnt(pfx, 0, parent.hero, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", parent.hero:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(pfx, 1, parent.hero, PATTACH_POINT_FOLLOW, "attach_hitloc", parent.hero:GetAbsOrigin() + Vector(0, 0, 70), true)
				Timers:CreateTimer(1, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)			
			end
			return false
		elseif parent:GetUnitName() == "scourge_knight_archer" then
			local damage = OverflowProtectedGetAverageTrueAttackDamage(parent)
			local helm = parent.hero.equipped_gear[RPC_GEAR_SLOT_HEAD]
			if parent.element == RPC_ELEMENT_FIRE then
				local radius = helm:GetFinalGemPropertyValue("ruby", SCOURGE_KNIGHT_RUBY)
				local enemies = FindUnitsInRadius(parent.hero:GetTeamNumber(), event.target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
				if #enemies > 0 then
					for _, enemy in pairs(enemies) do
						Filters:ApplyItemDamage(enemy, parent.hero, damage, DAMAGE_TYPE_PHYSICAL, parent.hero.equipped_gear[RPC_GEAR_SLOT_HEAD], RPC_ELEMENT_UNDEAD, parent.element)	
					end
				end
				local particle = ParticleManager:CreateParticle("particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf", PATTACH_WORLDORIGIN, target)
				ParticleManager:SetParticleControl(particle, 0, event.target:GetAbsOrigin())
				ParticleManager:SetParticleControl(particle, 1, Vector(radius, radius, radius))
				ParticleManager:SetParticleControl(particle, 2, Vector(0.6, 0.6, 0.6))
				ParticleManager:SetParticleControl(particle, 4, Vector(255, 60, 0))
				Timers:CreateTimer(1.5, function()
					ParticleManager:DestroyParticle(particle, false)
				end)
			else
				if parent.element == RPC_ELEMENT_ICE then
					helm:ApplyDataDrivenModifier(parent.hero.InventoryUnit, event.target, "modifier_chilled", {duration = SCOURGE_KNIGHT_SAPPHIRE_DURATION})
					event.target:SetModifierStackCount("modifier_chilled", parent.hero.InventoryUnit, helm:GetFinalGemPropertyValue("sapphire", SCOURGE_KNIGHT_SAPPHIRE))
				elseif parent.element == RPC_ELEMENT_POISON then
					helm:ApplyDataDrivenModifier(parent.hero.InventoryUnit, event.target, "modifier_scourge_knight_poison", {duration = SCOURGE_KNIGHT_EMERALD_DURATION})
				elseif parent.element == RPC_ELEMENT_ARCANE then
					damage = damage*(1 + helm:GetFinalGemPropertyValue("amethyst", SCOURGE_KNIGHT_AMETHYST)/100)
				end
				Filters:ApplyItemDamage(event.target, parent.hero, damage, DAMAGE_TYPE_PHYSICAL, parent.hero.equipped_gear[RPC_GEAR_SLOT_HEAD], RPC_ELEMENT_UNDEAD, parent.element)	
			end
			return false	
		elseif parent:GetUnitName() == "wolf_ally" then
			local damage = OverflowProtectedGetAverageTrueAttackDamage(parent)
			Filters:ApplyItemDamage(event.target, parent.hero, damage, DAMAGE_TYPE_PHYSICAL, parent.hero.equipped_gear[RPC_GEAR_SLOT_HEAD], RPC_ELEMENT_NATURE, RPC_ELEMENT_GHOST)
			return false
		elseif parent:GetUnitName() == "terrasic_lava_boots_fireling" then
			local damage = OverflowProtectedGetAverageTrueAttackDamage(parent)
			Filters:ApplyItemDamage(event.target, parent.hero, damage, DAMAGE_TYPE_PHYSICAL, parent.hero.equipped_gear[RPC_GEAR_SLOT_BOOTS], RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
			return false
		elseif parent:HasModifier("modifier_apprentice_ai") or parent:HasModifier("modifier_alien_armor_illusion") then
			local damage = OverflowProtectedGetAverageTrueAttackDamage(parent)
			Filters:ApplyItemDamage(event.target, parent.hero, damage, DAMAGE_TYPE_PHYSICAL,parent.hero.equipped_gear[RPC_GEAR_SLOT_BODY], RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
			return false
		elseif parent:GetUnitName() == "water_elemental_flood_3" then
			local damage = event.damage
			local flood_robe = parent.hero.equipped_gear[RPC_GEAR_SLOT_BODY]
			Filters:FloodElementalAttack(parent, parent.hero, flood_robe, event.target, damage)
			local damage = OverflowProtectedGetAverageTrueAttackDamage(parent)
			Filters:ApplyItemDamage(event.target, parent.hero, damage, DAMAGE_TYPE_PHYSICAL, flood_robe, RPC_ELEMENT_WATER, RPC_ELEMENT_NONE)
			return false
		elseif parent:HasModifier("modifier_boneguard_skeleton") then
			local damage = OverflowProtectedGetAverageTrueAttackDamage(parent)
			Filters:ApplyItemDamage(event.target, parent.hero, damage, DAMAGE_TYPE_PHYSICAL, parent.hero.equipped_gear[RPC_GEAR_SLOT_GLOVES], RPC_ELEMENT_UNDEAD, RPC_ELEMENT_NONE)
			return false
		end
		if parent:HasModifier("modifier_direwolf_bulwark") then
			local direwolf = parent:FindModifierByName("modifier_direwolf_bulwark"):GetAbility()
			event.damage = event.damage + event.target:GetRoshpitArmor()*((ITEM_RPC_DIREWOLF_BULWARK_ARMOR_TO_DMG + direwolf:GetFinalGemPropertyValue("emerald", ITEM_RPC_DIREWOLF_BULWARK_GEM_EMERALD))/100)
			if parent:IsHero() and direwolf:GetGemValue("amethyst") > 0 then
				local dire_wolf_amethyst_damage = event.target:GetRoshpitMagicArmor()*(direwolf:GetFinalGemPropertyValue("amethyst", ITEM_RPC_DIREWOLF_BULWARK_GEM_AMETHYST)/100)
				Filters:ApplyItemDamage(event.target, parent, dire_wolf_amethyst_damage, DAMAGE_TYPE_MAGICAL, direwolf, RPC_ELEMENT_SHADOW, RPC_ELEMENT_DEMON)	
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lycan/lycan_howl_cast_f.vpcf", event.target, 0.3)
			end
		end
		if event.target:HasModifier("modifier_direwolf_bulwark") then
			local direwolf = event.target:FindModifierByName("modifier_direwolf_bulwark"):GetAbility()
			event.damage = math.max(event.damage - event.target:GetRoshpitArmorPierce()*(direwolf:GetFinalGemPropertyValue("ruby", ITEM_RPC_DIREWOLF_BULWARK_GEM_RUBY)/100), 1)	
		end
		if parent:HasModifier("modifier_nethergrasp_palisade") then
			if event.target:HasModifier("modifier_nethergrasp_linked") then
				elements = { RPC_ELEMENT_TIME }
				damageType = DAMAGE_TYPE_PURE
				event.damage = event.damage * parent.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue("emerald", ITEM_RPC_NETHERGRASP_PALISADE_GEM_EMERALD)/100
			end
		end

		-- BASIC APPLY AUTO ATTACK DAMAGE
		Damage:Apply({
			source = Events.GameMasterAttackAbility,
			sourceType = BASE_AUTO_ATTACK,
			attacker = parent,
			victim = event.target,
			damage = event.damage,
			damageType = damageType,
			elements = elements
		})
	end
end
