function rune_think(event)
	local caster = event.caster
	rune_w_1(caster)
	rune_q_2(caster)
end

function rune_w_1(caster)
	if caster:HasAbility("leshrac_nuke") then
		local runeUnit = caster.runeUnit
		local runeAbility = runeUnit:FindAbilityByName("bahamut_rune_w_1")
		local w_1_level = caster:GetRuneValue("w", 1)
		if w_1_level > 0 then
			runeAbility:ApplyDataDrivenModifier(runeUnit, caster, "modifier_bahamut_a_b_buff", {})
			caster:SetModifierStackCount("modifier_bahamut_a_b_buff", runeAbility, w_1_level)
		else
			caster:RemoveModifierByName("modifier_bahamut_a_b_buff")
		end
	end
end

function rune_q_2(caster)
	local runeUnit = caster.runeUnit2
	local runeAbility = runeUnit:FindAbilityByName("bahamut_rune_q_2")
	local abilityLevel = runeAbility:GetLevel()
	local bonusLevel = Runes:GetTotalBonus(runeUnit, "q_2")
	local totalLevel = abilityLevel + bonusLevel
	if totalLevel > 0 then
		runeAbility:ApplyDataDrivenModifier(runeUnit, caster, "modifier_bahamut_b_a_buff", {})
		caster:SetModifierStackCount("modifier_bahamut_b_a_buff", runeAbility, totalLevel)
	else
		caster:RemoveModifierByName("modifier_bahamut_b_a_buff")
	end
end

function WallAllyBuff(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local q_1_level = ability.q_1_level
	local a_d_level = ability.r_1_level
	local b_d_level = ability.r_2_level
	if caster:GetEntityIndex() == target:GetEntityIndex() then
		if q_1_level then
			if q_1_level > 0 then
				local acceptable_particle_thinkers = {}
				for i = 1, #ability.wallThinkerTable, 1 do
					local wallThinker = ability.wallThinkerTable[i]
					local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), wallThinker.position)
					if distance <= 270 then
						table.insert(acceptable_particle_thinkers, wallThinker)
					end
					--print(wallThinker.index)
				end
				local wallCenter = ability.wallCenter
				local wallNinety = ability.ninetyDegrees
				if #acceptable_particle_thinkers > 0 then
					local randomIndex = RandomInt(1, #acceptable_particle_thinkers)
					wallCenter = acceptable_particle_thinkers[randomIndex].position
					wallNinety = acceptable_particle_thinkers[randomIndex].ninetyDeg
				end
				local maxBound = WallPhysics:round(ability.wallLength / 2.5, 0)
				local attachPoint = wallCenter + wallNinety * RandomInt(-maxBound, maxBound)
				EmitSoundOnLocationWithCaster(attachPoint, "Hero_VengefulSpirit.ProjectileImpact", caster)
				CreateLightningBeam(attachPoint + Vector(0, 0, 100), caster:GetAbsOrigin() + Vector(0, 0, 80))
				caster:GiveMana(q_1_level * 3)
				PopupMana(caster, q_1_level * 3)
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_bahamut_wall_max_mana", {duration = 20})
				local stacks = math.min(caster:GetModifierStackCount("modifier_bahamut_wall_max_mana", caster) + 1, 600)
				caster:SetModifierStackCount("modifier_bahamut_wall_max_mana", caster, stacks)
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_bahamut_wall_max_mana_invisible", {duration = 20})
				caster:SetModifierStackCount("modifier_bahamut_wall_max_mana_invisible", caster, stacks * q_1_level)
			end
		end
		if a_d_level then
			if a_d_level > 0 and hasChargingOrSlide(caster, event.guarantee) then
				--print("GOT IN CONDITION!")
				local hyperStateDuration = Filters:GetAdjustedBuffDuration(caster, 12, false)
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_charge_of_light_hyper_state", {duration = hyperStateDuration})
				caster:SetModifierStackCount("modifier_charge_of_light_hyper_state", ability, a_d_level)
				EmitSoundOn("DOTA_Item.AbyssalBlade.Activate", caster)
			end
		end
		if b_d_level then
			if b_d_level > 0 and hasChargingOrSlide(caster, event.guarantee) and caster:HasAbility("charge_of_light") then
				local explosionForwardDirection = caster:GetForwardVector()
				if caster:HasModifier("modifier_lightning_dash") then
					explosionForwardDirection = caster:FindAbilityByName("bahamut_arcana_orb").moveDirection
				end
				local point = caster:GetAbsOrigin() + explosionForwardDirection * 200
				local radius = 1100
				local chargeAbility = caster:FindAbilityByName("charge_of_light")
				local damage = chargeAbility:GetSpecialValueFor("damage") * (BAHAMUT_R2_BASE_DAMAGE_PCT/100 + b_d_level * BAHAMUT_R2_DAMAGE_PCT/100)
				local post_mit_duration = Filters:GetAdjustedBuffDuration(caster, 3, false)
				chargeAbility:ApplyDataDrivenModifier(caster, caster, "modifier_bahamut_charge_of_light_postmitigation", {duration = post_mit_duration})
				caster:SetModifierStackCount("modifier_bahamut_charge_of_light_postmitigation", caster, b_d_level)
				Timers:CreateTimer(0.03, function()
					local enemies = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
					if #enemies > 0 then
						for _, enemy in pairs(enemies) do
							Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_R, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
							Filters:ApplyStun(caster, 1, enemy)
							local particleName = "particles/units/heroes/hero_leshrac/bahamut_nova.vpcf"
							local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, enemy)
							ParticleManager:SetParticleControlEnt(pfx, 0, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
							Timers:CreateTimer(0.9, function()
								ParticleManager:DestroyParticle(pfx, false)
							end)
						end
					end
				end)
				EmitSoundOnLocationWithCaster(point + Vector(2, 2, 2), "Hero_Gyrocopter.HomingMissile.Destroy", caster)
				local particleName = "particles/roshpit/bahamut/charge_through_wall.vpcf"
				local particle2 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
				ParticleManager:SetParticleControl(particle2, 0, point)
				Timers:CreateTimer(4.5, function()
					ParticleManager:DestroyParticle(particle2, false)
				end)
				-- local particleName = "particles/items_fx/leshrac_blink.vpcf"
				-- local pfx2 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
				-- ParticleManager:SetParticleControlEnt(pfx2, 0, caster, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
				-- Timers:CreateTimer(0.9, function()
				--   ParticleManager:DestroyParticle( pfx2, false )
				-- end)
			end
		end
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_charge_of_light_hyper_state_cooldown", {duration = 0.1})

	end
end

function hasChargingOrSlide(caster, guarantee)
	if guarantee then
		return true
	end
	if caster:HasModifier("modifier_light_charging") or caster:HasModifier("modifier_charge_of_light_sliding") or caster:HasModifier("modifier_lightning_dash") then
		if not caster:HasModifier("modifier_charge_of_light_hyper_state_cooldown") then
			return true
		end
	else
		return false
	end
end

function CreateLightningBeam(attachPointA, attachPointB)
	local particleName = "particles/items_fx/leshrac_wall_beam.vpcf"
	local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(lightningBolt, 0, Vector(attachPointA.x, attachPointA.y, attachPointA.z))
	ParticleManager:SetParticleControl(lightningBolt, 1, Vector(attachPointB.x, attachPointB.y, attachPointB.z))
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(lightningBolt, false)
	end)
end

function leshrac_attack_start(event)
	local target = event.target
	local caster = event.attacker
	local ability = event.ability
	local radius = 700
	if ability.w_2_level and not target:IsNull() then
		if ability.w_2_level > 0 and target:HasModifier("modifier_leshrac_nuke_judged") then
			local targetPoint = target:GetAbsOrigin()
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), targetPoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				for _, enemy in pairs(enemies) do
					if enemy:HasModifier("modifier_leshrac_nuke_judged") then
						if not (enemy:GetEntityIndex() == target:GetEntityIndex()) then
							local info =
							{
								Target = enemy,
								Source = caster,
								Ability = ability,
								EffectName = "particles/roshpit/bahamut/split_attack_particle.vpcf",
								StartPosition = "attach_attack1",
								bDrawsOnMinimap = false,
								bDodgeable = true,
								bIsAttack = true,
								bVisibleToEnemies = true,
								bReplaceExisting = false,
								flExpireTime = GameRules:GetGameTime() + 5,
								bProvidesVision = false,
								iVisionRadius = 0,
								iMoveSpeed = 600,
							}
							projectile = ProjectileManager:CreateTrackingProjectile(info)
						end
					end
				end
			end
		end
	end
end

function leshrac_attack_land(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local damage = ability.w_2_level * OverflowProtectedGetAverageTrueAttackDamage(caster) * BAHAMUT_W2_DAMAGE_PCT/100
	if caster:HasModifier("modifier_bahamut_immortal_weapon_1") then
		local luck = RandomInt(1, 100/BAHAMUT_IMMORTAL_WEAPON_1_CHANCE)
		if luck == 1 then
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_death_end.vpcf", PATTACH_CUSTOMORIGIN, target)
			ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(pfx, 1, Vector(255, 255, 255))
			Timers:CreateTimer(2.5, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
			Filters:TakeArgumentsAndApplyDamage(target, caster, damage * BAHAMUT_IMMORTAL_WEAPON_1_DAMAGE_AMP, DAMAGE_TYPE_PURE, BASE_ITEM, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
		end
	end

	Filters:ApplyDamageBasic(target, caster, damage, DAMAGE_TYPE_PHYSICAL)
	-- ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL })
end

function rune_unit_4_think(event)
	local caster = event.caster
	local ability = event.ability
	local hero = caster.hero
	local totalLevel = Runes:GetTotalRuneLevel(hero, 4, "q_4", "bahamut")
	if totalLevel > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_bahamut_rune_q_4", {})
		hero:SetModifierStackCount("modifier_bahamut_rune_q_4", ability, totalLevel)
	end
end

function d_d_shell_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local d_d_level = ability.r_4_level
	local d_d_duration = Filters:GetAdjustedBuffDuration(caster, 9, false)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_bahamut_rune_r_4_buff_visible", {duration = d_d_duration})
	local current_stack = target:GetModifierStackCount("modifier_bahamut_rune_r_4_buff_visible", ability)
	local newStack = current_stack + 1
	target:SetModifierStackCount("modifier_bahamut_rune_r_4_buff_visible", ability, newStack)

	ability:ApplyDataDrivenModifier(caster, target, "modifier_bahamut_rune_r_4_buff_invisible", {duration = d_d_duration})
	target:SetModifierStackCount("modifier_bahamut_rune_r_4_buff_invisible", ability, newStack * d_d_level)
	if target:HasModifier("modifier_charge_of_light_hyper_state") then
		local wallAbility = target:FindAbilityByName("leshrac_wall")
		local hyperStateDuration = Filters:GetAdjustedBuffDuration(caster, 12, false)
		wallAbility:ApplyDataDrivenModifier(target, target, "modifier_charge_of_light_hyper_state", {duration = hyperStateDuration})
	end
	caster = target
	local modifiers = caster:FindAllModifiers()
	for i = 1, #modifiers, 1 do
		local modifier = modifiers[i]
		local modifierMaker = modifier:GetCaster()

		if modifier:GetName() == "modifier_bahamut_rune_r_4_shell" or modifier:GetName() == "modifier_charge_of_light_sliding" or modifier:GetName() == "modifier_attack_land_basic" or modifier:GetName() == "modifier_client_setting" then
		else
			if modifierMaker:GetEntityIndex() == caster:GetEntityIndex() or modifierMaker:GetEntityIndex() == caster.InventoryUnit:GetEntityIndex() then

				local durationRemaining = modifier:GetRemainingTime()
				if durationRemaining > 0 then
					--print("INCREASING:")
					--print(modifier:GetName())
					modifier:SetDuration(durationRemaining + 0.1, true)
				end
			end
		end
	end
end
