require('/heroes/obsidian_destroyer/epoch_constants')

function epoch_glyph_5_1_attack_start(event)
	local ability = event.ability
	local caster = event.caster
	local attacker = event.attacker
	local w_2_level = attacker:GetRuneValue("w", 2)
	if not w_2_level then
		return false
	end
	ability.attacker = attacker
	local projectileSpeed = attacker:GetProjectileSpeed()
	local info =
	{
		Target = event.target,
		Source = attacker,
		Ability = ability,
		--EffectName = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_arcane_orb.vpcf",
		StartPosition = "attach_attack1",
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = true,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 5,
		bProvidesVision = false,
		iVisionRadius = 0,
		iMoveSpeed = projectileSpeed,
	}
	projectile = ProjectileManager:CreateTrackingProjectile(info)
end

function epoch_glyph_5_1_attack_land(event)
	local attacker = event.attacker
	local target = event.target
	local ability = attacker:FindAbilityByName("time_genesis_orb")
	local w_2_level = attacker:GetRuneValue("w", 2)
	if w_2_level > 0 then
		local currentStacks = target:GetModifierStackCount("modifier_epoch_rune_w_2_visible", attacker)
		local new_stacks = math.min(currentStacks + 1, EPOCH_W2_MAX_STACKS)
		ability:ApplyDataDrivenModifier(attacker, target, "modifier_epoch_rune_w_2_visible", {duration = EPOCH_W2_DURATION})
		target:SetModifierStackCount("modifier_epoch_rune_w_2_visible", attacker, new_stacks)
		target:CalculateAndSaveRoshpitAttributes()
	end
end
