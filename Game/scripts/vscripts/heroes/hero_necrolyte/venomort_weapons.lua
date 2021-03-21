require("/heroes/hero_necrolyte/venomort_constants")
require('heroes/hero_necrolyte/plague_blaster')

function venomort_immortal_weapon_4_attack_land(event)
	local attacker = event.attacker
	local target = event.target
	local w_2_level = attacker:GetRuneValue("w", 2)
	local damage = OverflowProtectedGetAverageTrueAttackDamage(attacker)*VENOMORT_IMMORTAL_WEAPON_4_SPLASH_DMG_PCT/100
	local w_ability = attacker:FindAbilityByName('nether_blaster')
	local particle = "particles/roshpit/venomort/venomort_weapon_4_splash.vpcf"
	CustomAbilities:QuickParticleAtPoint(particle, target:GetAbsOrigin(), 0.5)
	local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, VENOMORT_IMMORTAL_WEAPON_4_SPLASH_AOE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:ApplyItemDamage(enemy, attacker, damage, DAMAGE_TYPE_PHYSICAL, caster.equipped_gear[RPC_GEAR_SLOT_WEAPON], RPC_ELEMENT_POISON, RPC_ELEMENT_NONE)
			demoralize(attacker, w_ability, enemy, w_2_level*VENOMORT_W2_DURATION)
		end
	end
end