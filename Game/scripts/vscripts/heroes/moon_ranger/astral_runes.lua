require('heroes/moon_ranger/init')

function c_d_end(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	ability:ApplyDataDrivenModifier(caster, target, "modifier_rune_r_3_phoenix_leaving", {duration = 5})
	target:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
	EmitSoundOn("phoenix_phoenix_bird_denied", target)
	local origin = target:GetAbsOrigin()
	for i = 0, 30, 1 do
		Timers:CreateTimer(0.03 * i, function()
			if IsValidEntity(target) then
				target:SetAbsOrigin(origin + Vector(0, 0, 20 * i) + target:GetForwardVector() * i * 10)
				if i == 30 then
					UTIL_Remove(target)
				end
			end
		end)
	end
end

function c_d_enter(event)
	local target = event.target
	local ability = event.ability
	local caster = ability.origCaster

	local damage = ability.r_3_level * (ASTRAL_RANGER_R3_ATTACK_DAMAGE_PERCENT * OverflowProtectedGetAverageTrueAttackDamage(caster) + ASTRAL_RANGER_R3_FLAT_DAMAGE)
	--print(caster:GetUnitName())
	if caster:HasModifier("modifier_astral_glyph_2_1") then
		damage = damage * ASTRAL_RANGER_GLYPH_2_1_PHOENIX_DAMAGE_AMP
		ability.glyphed = true
	else
		ability.glyphed = false
	end
	ability.r_3_damage = damage
	StartAnimation(target, {duration = 1.5, activity = ACT_DOTA_SPAWN, rate = 1.0})
	local origin = target:GetAbsOrigin() + Vector(0, 0, 600)
	target:SetAbsOrigin(origin)
	for i = 0, 30, 1 do
		Timers:CreateTimer(0.03 * i, function()
			target:SetAbsOrigin(origin + Vector(0, 0, 15 *- i))
		end)
	end
end

function c_d_think(event)
	local phoenix = event.target
	local caster = event.caster
	local ability = event.ability
	local orig_caster = ability.origCaster
	local radius = ASTRAL_RANGER_R3_RADIUS
	local projectileParticle = "particles/base_attacks/ranged_tower_good.vpcf"
	if phoenix.glyphed then
		projectileParticle = "particles/base_attacks/astral_glyph_2_1_projectile.vpcf"
	end
	phoenix:MoveToPosition(orig_caster:GetAbsOrigin() + RandomVector(200))
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), phoenix:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			local info =
			{
				Target = enemy,
				Source = phoenix,
				Ability = ability,
				EffectName = projectileParticle,
				vSourceLoc = phoenix:GetAbsOrigin(),
				bDrawsOnMinimap = false,
				bDodgeable = true,
				bIsAttack = false,
				bVisibleToEnemies = true,
				bReplaceExisting = false,
				flExpireTime = GameRules:GetGameTime() + 4,
				bProvidesVision = true,
				iVisionRadius = 0,
				iMoveSpeed = 1500,
			iVisionTeamNumber = phoenix:GetTeamNumber()}
			ProjectileManager:CreateTrackingProjectile(info)

		end
	end
end

function c_d_projectile_hit(event)
	local target = event.target
	local ability = event.ability
	local damage = ability.r_3_damage
	Filters:TakeArgumentsAndApplyDamage(target, ability.origCaster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_R, RPC_ELEMENT_COSMOS, RPC_ELEMENT_NONE)
	if ability.glyphed then
		ability:ApplyDataDrivenModifier(ability.origCaster.runeUnit3, target, "modifier_astral_glyph_2_1_slow", {duration = 4})
	end
end

function astral_think(event)
	local caster = event.caster
	caster.e_4_level = Runes:GetTotalRuneLevel(caster, 4, "e_4", "astral")

	local d_c_level = caster.e_4_level
	local d_c_ability = caster.runeUnit4:FindAbilityByName("astral_rune_e_4")
	if d_c_level > 0 then
		d_c_ability:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_astral_d_c_visible", {})
		caster:SetModifierStackCount("modifier_astral_d_c_visible", d_c_ability, d_c_level)
	else
		caster:RemoveModifierByName("modifier_astral_d_c_visible")
	end
end
