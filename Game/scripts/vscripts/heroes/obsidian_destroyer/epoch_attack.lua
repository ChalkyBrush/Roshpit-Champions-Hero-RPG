require('heroes/obsidian_destroyer/epoch_1_q')
require('heroes/obsidian_destroyer/epoch_1_q_arcana')
require('heroes/obsidian_destroyer/epoch_glyphs')
require('heroes/obsidian_destroyer/epoch_constants')

function epoch_attack_start(event)
	local ability = event.ability
	local caster = event.attacker
	local q_3_level = caster:GetRuneValue("q", 3)
	local projectileEffect = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_base_attack.vpcf"
	if caster:HasAbility("epoch_time_binder") then
		ability.q_3_damage = epoch_q_3_get_damage(caster, caster.runeUnit3, false)
	elseif caster:HasAbility("epoch_arcana_ability") then
		ability.q_3_damage = epoch_arcana_q_3_get_damage(caster, caster.runeUnit3, false)
	end
	if ability.q_3_damage and ability.q_3_damage > 0 then
		projectileEffect = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_arcane_orb.vpcf"
	end
	caster:SetRangedProjectileName(projectileEffect)
end

function epoch_attack(event)
	--print("epoch_attack_start triggered")
	local caster = event.attacker
	local ability = event.ability
	local target = event.target
	ability.attacker = caster
	local projectileEffect = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_base_attack.vpcf"
	if caster:HasAbility("epoch_time_binder") then
		ability.q_3_damage = epoch_q_3_get_damage(caster, caster.runeUnit3, true)
	elseif caster:HasAbility("epoch_arcana_ability") then
		ability.q_3_damage = epoch_arcana_q_3_get_damage(caster, caster.runeUnit3, true)
	end
	if ability.q_3_damage then
		projectileEffect = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_arcane_orb.vpcf"
	end
	if caster:HasModifier("modifier_epoch_rune_e_3") then
		local radius = 600
		local e_3_level = caster:GetRuneValue("e", 3)
		local targetPoint = target:GetAbsOrigin()
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), targetPoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		local projectileCount = 0
		local projectileSpeed = caster:GetProjectileSpeed()
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				if enemy ~= event.target then
					local info =
					{
						Target = enemy,
						Source = caster,
						Ability = ability,
						EffectName = projectileEffect,
						StartPosition = "attach_attack1",
						bDrawsOnMinimap = false,
						bDodgeable = true,
						bIsAttack = true,
						bVisibleToEnemies = true,
						bReplaceExisting = false,
						flExpireTime = GameRules:GetGameTime() + 4,
						bProvidesVision = true,
						iVisionRadius = 0,
						iMoveSpeed = projectileSpeed,
					iVisionTeamNumber = caster:GetTeamNumber()}
					projectile = ProjectileManager:CreateTrackingProjectile(info)
					projectileCount = projectileCount + 1
					if projectileCount == e_3_level * EPOCH_E3_TARGETS + EPOCH_E3_TARGETS_BASE then
						break
					end
				end
			end
		end
	end
end

function epoch_attack_land(event)
	local target = event.target
	local ability = event.ability
	local caster = ability.attacker
	local damage = ability.damage
	if caster:HasModifier("modifier_epoch_glyph_5_1") then
		local eventTable = {}
		eventTable.ability = caster.runeUnit2:FindAbilityByName("epoch_rune_w_2")
		eventTable.attacker = caster
		eventTable.target = target
		eventTable.caster = caster
		epoch_glyph_5_1_attack_land(eventTable)
	end
	if caster:HasAbility("epoch_time_binder") and ability.q_3_damage then
		local eventTable = {}
		eventTable.ability = ability
		eventTable.attacker = caster
		eventTable.target = target
		eventTable.caster = caster
		epoch_q_3_strike(eventTable)
	elseif caster:HasAbility("epoch_arcana_ability") and ability.q_3_damage then
		local eventTable = {}
		eventTable.ability = ability
		eventTable.attacker = caster
		eventTable.target = target
		eventTable.caster = caster
		epoch_arcana_q_3_strike(eventTable)
	end
	Filters:ApplyDamageBasic(target, caster, damage, DAMAGE_TYPE_PHYSICAL)
end
