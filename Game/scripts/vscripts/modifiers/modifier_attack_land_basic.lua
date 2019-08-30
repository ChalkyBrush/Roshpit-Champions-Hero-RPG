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
