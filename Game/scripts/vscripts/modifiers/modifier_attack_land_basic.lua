modifier_attack_land_basic = class({})

function modifier_attack_land_basic:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_attack_land_basic:OnAttackLanded(event)
	if not Events.GameMasterAttackAbility then return end
	local parent = self:GetParent()
	if event.attacker == parent then
		-- ApplyDamage({victim = event.target,
		-- 	attacker = parent,
		-- 	--unlike GetAverageTrueAttackDamage(), event.damage isnt limited by 2^31 for some reason
		-- 	damage = event.damage,
		-- 	damage_type = DAMAGE_TYPE_PHYSICAL,
		-- 	ability = Events.GameMasterAttackAbility,
		-- 	damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR + DOTA_DAMAGE_FLAG_HPLOSS
		-- })
		if parent:HasModifier("modifier_samurai_helmet") then
			event.damage = Filters:SamuraiAttackLand(event.damage, parent, event.target)
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
		end
		Damage:Apply({
			source = Events.GameMasterAttackAbility,
			sourceType = BASE_AUTO_ATTACK,
			attacker = parent,
			victim = event.target,
			damage = event.damage,
			damageType = DAMAGE_TYPE_PHYSICAL,
			elements = { RPC_ELEMENT_NORMAL }
		})
	end
end
