require('/heroes/dark_seer/zhonik_constants')

function mach_punch_wind_up(event)
	local caster = event.caster
	local ability = event.ability

	local pfx1 = ParticleManager:CreateParticle("particles/econ/courier/courier_greevil_green/courier_greevil_green_ambient_1.vpcf", PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(pfx1, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
	local pfx2 = ParticleManager:CreateParticle("particles/econ/courier/courier_greevil_green/courier_greevil_green_ambient_1.vpcf", PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(pfx2, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
	ability.pfx1 = pfx1
	ability.pfx2 = pfx2

	StartAnimation(caster, {duration = 0.5, activity = ACT_DOTA_ATTACK, rate = 1.4})
end

function mach_punch_cancel(event)
	local caster = event.caster
	local ability = event.ability
	EndAnimation(caster)
	--print("punch cancel")
	if ability.pfx1 then
		ParticleManager:DestroyParticle(ability.pfx1, false)
		ParticleManager:ReleaseParticleIndex(ability.pfx1)
		ability.pfx1 = false
	end
	if ability.pfx2 then
		ParticleManager:DestroyParticle(ability.pfx2, false)
		ParticleManager:ReleaseParticleIndex(ability.pfx2)
		ability.pfx2 = false
	end
end

function mach_punch_cast(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if not event.cancelAnim then
		mach_punch_cancel(event)
	end
	EmitSoundOn("Zonik.MachPunch.Impact", target)
	Filters:ApplyStun(caster, event.stun_duration, target)
	ScreenShake(target:GetAbsOrigin(), 860, 0.2, 0.2, 2000, 0, true)
	CustomAbilities:QuickAttachParticleWithPointFollow("particles/roshpit/zonik/mach_punch_tgt.vpcf", target, 2.6, "attach_hitloc")
	local damageMult = event.damage_mult
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * damageMult / 100
	--print("MACH PUNCH GO!")
	if caster:HasModifier("modifier_temporal_discharge") then
		local stacks = caster:GetModifierStackCount("modifier_temporal_discharge", caster)
		local w_2_level = caster:GetRuneValue("w", 2)
		damage = damage + damage * stacks * w_2_level * ZHONIK_W2_MUCH_PUNCH_AMP_PCT / 100
		caster:RemoveModifierByName("modifier_temporal_discharge")
	end
	if event.arcana_missle_amp then
		damage = damage * event.arcana_missle_amp
	end
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_W, RPC_ELEMENT_NORMAL, RPC_ELEMENT_TIME)
	local w_1_level = caster:GetRuneValue("w", 1)
	if w_1_level > 0 then
		local pfx = ParticleManager:CreateParticle("particles/roshpit/zonik/sonic_boom_fallback_mid_egset.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin())
		local particleRadius = 92
		local particleRadius2 = 270
		local searchRadius = 300
		if caster:HasModifier("modifier_zonik_glyph_4_1") then
			--print('glyphed')
			particleRadius = particleRadius * (1 + ZHONIK_GLYPH_4_1_SONIC_RADIUS / 100)
			searchRadius = searchRadius * (1 + ZHONIK_GLYPH_4_1_SONIC_RADIUS / 100)
			particleRadius2 = particleRadius2 * (1 + ZHONIK_GLYPH_4_1_SONIC_RADIUS / 100)
		end
		ParticleManager:SetParticleControl(pfx, 1, Vector(3, 3, 3))
		ParticleManager:SetParticleControl(pfx, 4, Vector(particleRadius, particleRadius, particleRadius))
		ParticleManager:SetParticleControl(pfx, 5, Vector(particleRadius2, particleRadius2, particleRadius2))
		Timers:CreateTimer(0.9, function()
			ParticleManager:DestroyParticle(pfx, false)
			ParticleManager:ReleaseParticleIndex(pfx)
		end)
		local a_b_damage = damage * w_1_level * ZHONIK_W1_MUCH_PUNCH_SHOCKWAVE_PCT / 100
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, searchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, a_b_damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_NORMAL, RPC_ELEMENT_TIME)

			end
		end
	end
	Filters:CastSkillArguments(2, caster)
	if not event.cancelAnim then
		if caster:HasModifier("modifier_zonik_glyph_3_1") then
			local procs = Runes:Procs(ZHONIK_GLYPH_3_1_CHANCE_TO_PUNCH_TWICE / 10, 10, 1)
			if procs == 1 then
				Timers:CreateTimer(0.15, function()
					if IsValidEntity(target) then
						if target:IsAlive() then
							caster:SetForwardVector(((target:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized())
							StartAnimation(caster, {duration = 0.5, activity = ACT_DOTA_ATTACK, rate = 2.8})
							local eventTable = {}
							eventTable.caster = caster
							eventTable.target = target
							eventTable.cancelAnim = true
							eventTable.ability = caster:FindAbilityByName("zonik_mach_punch")
							eventTable.damage_mult = eventTable.ability:GetLevelSpecialValueFor("damage_mult", eventTable.ability:GetLevel())
							--print(eventTable.damage_mult)
							eventTable.stun_duration = eventTable.ability:GetLevelSpecialValueFor("stun_duration", eventTable.ability:GetLevel())
							Timers:CreateTimer(0.1, function()
								mach_punch_cast(eventTable)
							end)
						end
					end
				end)
			end
		end
	end
end

function mach_punch_think(event)
	local attacker = event.caster
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local w_2_level = caster:GetRuneValue("w", 2)
	if w_2_level > 0 then
		if not ability.distanceMoved then
			ability.distanceMoved = 0
		end
		if ability.lastPos then
			local distance = WallPhysics:GetDistance2d(ability.lastPos, caster:GetAbsOrigin())
			ability.distanceMoved = ability.distanceMoved + distance
			--print(ability.distanceMoved)
			ability.lastPos = caster:GetAbsOrigin()
			if ability.distanceMoved >= ZHONIK_W2_DISTANCE_THRESHOLD then
				ability.distanceMoved = ability.distanceMoved % ZHONIK_W2_DISTANCE_THRESHOLD
				ability:ApplyDataDrivenModifier(attacker, attacker, "modifier_temporal_discharge", {})
				local newStacks = math.min(attacker:GetModifierStackCount("modifier_temporal_discharge", attacker) + 1, ZHONIK_W2_MAX_STACKS)
				attacker:SetModifierStackCount("modifier_temporal_discharge", attacker, newStacks)
			end
		else
			ability.lastPos = caster:GetAbsOrigin()
		end
	end
	if caster:IsRooted() or caster:IsStunned() or caster:HasModifier("modifier_knockback") then
		local w_3_level = caster:GetRuneValue("w", 3)
		if w_3_level > 0 then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_mach_punch_whiplash", {})
			local newStacks = caster:GetModifierStackCount("modifier_mach_punch_whiplash", caster) + 1
			caster:SetModifierStackCount("modifier_mach_punch_whiplash", caster, newStacks)
		end
	else
		if caster:HasModifier("modifier_mach_punch_whiplash") then
			local w_3_level = caster:GetRuneValue("w", 3)

			local pfx = ParticleManager:CreateParticle("particles/roshpit/zonik/whiplash_choslam_start.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
			ParticleManager:SetParticleControl(pfx, 1, Vector(550, 2, 550))
			Timers:CreateTimer(2.5, function()
				ParticleManager:DestroyParticle(pfx, false)
				ParticleManager:ReleaseParticleIndex(pfx)
			end)
			local c_b_damage = caster:GetModifierStackCount("modifier_mach_punch_whiplash", caster) * w_3_level * ZHONIK_W3_DMG_PER_WHIPLASH
			local stun_duration = 0.005 * w_3_level * caster:GetModifierStackCount("modifier_mach_punch_whiplash", caster)
			caster:RemoveModifierByName("modifier_mach_punch_whiplash")
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				for _, enemy in pairs(enemies) do
					Filters:TakeArgumentsAndApplyDamage(enemy, caster, c_b_damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)
					Filters:ApplyStun(caster, stun_duration, enemy)
				end
			end
			EmitSoundOn("Zonik.Whiplash", caster)
		end
	end
end

function mach_punch_attack_land(event)
	local attacker = event.attacker
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local attack_damage = event.attack_damage
	local w_4_level = caster:GetRuneValue("w", 4)
	if w_4_level > 0 then
		if not target.dummy then
			ability:ApplyDataDrivenModifier(attacker, target, "modifier_zonik_echo", {duration = 4})
			if not target.zonikEcho then
				target.zonikEcho = 0
			end
			target.zonikEcho = target.zonikEcho + attack_damage * w_4_level * ZHONIK_W4_ECHO_DMG_PCT / 100
			--print(target.zonikEcho)
			--print(target:GetEntityIndex())
		end
	end
end

function zonik_echo_end(event)
	local caster = event.caster
	local target = event.target
	if target.dummy then
		return false
	end
	if target:IsAlive() then
		Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, caster, "modifier_backstab_jumping", {duration = 0.2})
		Filters:TakeArgumentsAndApplyDamage(target, caster, target.zonikEcho, DAMAGE_TYPE_PURE, BASE_ITEM, RPC_ELEMENT_NONE, RPC_ELEMENT_NONE)
		caster:RemoveModifierByName("modifier_backstab_jumping")
		target.zonikEcho = false
		CustomAbilities:QuickAttachParticleWithPointFollow("particles/roshpit/zonik/echo.vpcf", target, 2.6, "attach_hitloc")
		EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Zonik.Echo", caster)
	end
end

function sonar_style_equip(event)
	local caster = event.target
	local ability = caster:FindAbilityByName("zonik_mach_punch")
	local cometPunch = caster:FindAbilityByName("zonik_comet_punch")
	if not cometPunch then
		cometPunch = caster:AddAbility("zonik_comet_punch")
	end
	cometPunch:SetLevel(ability:GetLevel())
	cometPunch:SetAbilityIndex(1)
	caster:SwapAbilities("zonik_mach_punch", "zonik_comet_punch", false, true)
end

function sonar_style_remove(event)
	local caster = event.target
	local ability = caster:FindAbilityByName("zonik_comet_punch")
	local cometPunch = caster:FindAbilityByName("zonik_mach_punch")
	cometPunch:SetLevel(ability:GetLevel())
	cometPunch:SetAbilityIndex(1)
	caster:SwapAbilities("zonik_mach_punch", "zonik_comet_punch", true, false)
end

function comet_punch_cast(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if ability.pfx1 then
		ParticleManager:DestroyParticle(ability.pfx1, false)
		ParticleManager:ReleaseParticleIndex(ability.pfx1)
		ability.pfx1 = false
	end
	if ability.pfx2 then
		ParticleManager:DestroyParticle(ability.pfx2, false)
		ParticleManager:ReleaseParticleIndex(ability.pfx2)
		ability.pfx2 = false
	end
	local info =
	{
		Target = target,
		Source = caster,
		Ability = ability,
		EffectName = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_base_attack.vpcf",
		StartPosition = "attach_attack1",
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 4,
		bProvidesVision = true,
		iVisionRadius = 0,
		iMoveSpeed = 1800,
	iVisionTeamNumber = caster:GetTeamNumber()}
	projectile = ProjectileManager:CreateTrackingProjectile(info)
end
