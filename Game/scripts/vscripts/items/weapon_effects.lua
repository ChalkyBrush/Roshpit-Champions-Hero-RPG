function flamewaker_immortal2_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster

	ability:ApplyDataDrivenModifier(caster, target, "modifier_flamewaker_weapon_attack_power", {})
	local stacks = target:GetAgility()
	target:SetModifierStackCount("modifier_flamewaker_weapon_attack_power", caster, stacks)
end

function astral_immortal_3_think(event)
	local target = event.target
	AddFOWViewer(target:GetTeamNumber(), target:GetAbsOrigin(), 1000, 1.0, false)
end

function paladin_immortal_3_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster

	ability:ApplyDataDrivenModifier(caster, target, "modifier_paladin_immortal_weapon_3_health", {})
	local stacks = target:GetStrength()
	target:SetModifierStackCount("modifier_paladin_immortal_weapon_3_health", caster, stacks)
end

function sorceress_avatar_think(event)
	local avatar = event.target
	local caster = avatar.origCaster

	local casterBlizzAbility = caster:FindAbilityByName("blizzard")
	local casterLanceAbility = caster:FindAbilityByName("blizzard")
	if not casterBlizzAbility then
		casterBlizzAbility = caster:FindAbilityByName("sorceress_fire_arcana_q")
		casterLanceAbility = caster:FindAbilityByName("sorceress_sun_lance")
	end
	local level = casterBlizzAbility:GetLevel()
	local blizzAbility = avatar:FindAbilityByName("blizzard")
	local lanceAbility = avatar:FindAbilityByName("ice_lance")
	if not blizzAbility then
		blizzAbility = avatar:FindAbilityByName("sorceress_fire_arcana_q")
		lanceAbility = avatar:FindAbilityByName("sorceress_sun_lance")
	end
	local blinkAbility = avatar:FindAbilityByName("sorceress_blink")
	if avatar:IsChanneling() then
		return false
	end
	if avatar.lock then
		return false
	end
	if level then
		blizzAbility:SetLevel(level)
	end
	FindClearSpaceForUnit(avatar, avatar:GetAbsOrigin(), false)
	if blizzAbility:IsFullyCastable() or lanceAbility:IsFullyCastable() or blinkAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			if blizzAbility:IsFullyCastable() then
				local targetPoint = enemies[1]:GetOrigin() + RandomVector(RandomInt(0, 100))
				local order =
				{
					UnitIndex = avatar:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = blizzAbility:entindex(),
					Position = targetPoint
				}
				ExecuteOrderFromTable(order)
				avatar.lock = true
				Timers:CreateTimer(blizzAbility:GetCastPoint(), function()
					avatar.lock = false
				end)
				return false
			end
			if not avatar:HasModifier("modifier_clear_cast") then
				if blinkAbility:IsFullyCastable() then
					local targetPoint = caster:GetOrigin() + RandomVector(RandomInt(200, 500))
					local order =
					{
						UnitIndex = avatar:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
						AbilityIndex = blinkAbility:entindex(),
						Position = targetPoint
					}
					ExecuteOrderFromTable(order)
					return false
				end
			end
			if lanceAbility:IsFullyCastable() then
				--print("CAST LANCE?")
				local targetPoint = enemies[1]:GetOrigin()
				local order =
				{
					UnitIndex = avatar:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = lanceAbility:entindex(),
					Position = targetPoint
				}
				ExecuteOrderFromTable(order)
				avatar.lock = true
				Timers:CreateTimer(lanceAbility:GetCastPoint(), function()
					avatar.lock = false
				end)
				return false
			end

		end
	end
	if not avatar:HasModifier("modifier_clear_cast") then
		if blinkAbility:IsFullyCastable() then
			local targetPoint = caster:GetOrigin() + RandomVector(RandomInt(200, 500))
			local order =
			{
				UnitIndex = avatar:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = blinkAbility:entindex(),
				Position = targetPoint
			}
			ExecuteOrderFromTable(order)
			return false
		end
	end
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), avatar:GetAbsOrigin())
	if distance > 500 and distance < 1500 then
		if not avatar:IsChanneling() then
			avatar:MoveToPosition(caster:GetAbsOrigin() + RandomVector(240))
		end
	elseif distance >= 1500 then
		CustomAbilities:QuickAttachParticle("particles/econ/items/meepo/meepo_colossal_crystal_chorus/sorceress_blink.vpcf", caster, 3)
		avatar:SetAbsOrigin(caster:GetAbsOrigin() + RandomVector(240))
	end
end

function sorceress_avatar_think_fire(event)
	local avatar = event.target
	local caster = avatar.origCaster

	local coreAbility = avatar:FindAbilityByName("pyroblast")
	if not coreAbility then
		coreAbility = avatar:FindAbilityByName("sorceress_arcana_ice_tornado")
	end
	local fireballAbility = avatar:FindAbilityByName("fireball")
	if not fireballAbility then
		fireballAbility = coreAbility
	end
	local blinkAbility = avatar:FindAbilityByName("sorceress_blink")
	if avatar:IsChanneling() then
		return false
	end
	if avatar.lock then
		return false
	end
	FindClearSpaceForUnit(avatar, avatar:GetAbsOrigin(), false)
	if coreAbility:IsFullyCastable() or fireballAbility:IsFullyCastable() or blinkAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			if coreAbility:IsFullyCastable() then
				local targetPoint = enemies[1]:GetOrigin() + RandomVector(RandomInt(0, 80))
				local order =
				{
					UnitIndex = avatar:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = coreAbility:entindex(),
					Position = targetPoint
				}
				ExecuteOrderFromTable(order)
				avatar.lock = true
				Timers:CreateTimer(coreAbility:GetCastPoint(), function()
					avatar.lock = false
				end)
				return false
			end
			if fireballAbility:IsFullyCastable() then
				local targetPoint = enemies[1]:GetOrigin()
				local order =
				{
					UnitIndex = avatar:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = fireballAbility:entindex(),
					Position = targetPoint
				}
				ExecuteOrderFromTable(order)
				avatar.lock = true
				Timers:CreateTimer(fireballAbility:GetCastPoint(), function()
					avatar.lock = false
				end)
				return false
			end
			if not avatar:HasModifier("modifier_clear_cast") then
				if blinkAbility:IsFullyCastable() then
					local targetPoint = caster:GetOrigin() + RandomVector(RandomInt(200, 500))
					local order =
					{
						UnitIndex = avatar:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
						AbilityIndex = blinkAbility:entindex(),
						Position = targetPoint
					}
					ExecuteOrderFromTable(order)
					return false
				end
			end
		end
	end
	if not avatar:HasModifier("modifier_clear_cast") then
		if blinkAbility:IsFullyCastable() then
			local targetPoint = caster:GetOrigin() + RandomVector(RandomInt(200, 500))
			local order =
			{
				UnitIndex = avatar:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = blinkAbility:entindex(),
				Position = targetPoint
			}
			ExecuteOrderFromTable(order)
			return false
		end
	end
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), avatar:GetAbsOrigin())
	if distance > 500 and distance < 1500 then
		if not avatar:IsChanneling() then
			avatar:MoveToPosition(caster:GetAbsOrigin() + RandomVector(240))
		end
	elseif distance >= 1500 then
		CustomAbilities:QuickAttachParticle("particles/econ/items/meepo/meepo_colossal_crystal_chorus/sorceress_blink.vpcf", caster, 3)
		avatar:SetAbsOrigin(caster:GetAbsOrigin() + RandomVector(240))
	end
end

function sorc_avatar_die(event)
	local unit = event.unit
	unit.origCaster.avatar = nil
end

function seinaru_immortal_2_start(event)
	local target = event.target
	target:AddNewModifier(target, nil, 'modifier_movespeed_cap_sonic', {})
end

function seinaru_immo_3_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster

	ability:ApplyDataDrivenModifier(caster, target, "modifier_seinaru_immo_weapon_3_strength", {})

	local movespeedBase = target:GetBaseMoveSpeed()
	local movespeedActual = target:GetMoveSpeedModifier(movespeedBase, false)
	target:SetModifierStackCount("modifier_seinaru_immo_weapon_3_strength", caster, movespeedActual)
end

function auriun_immortal_2_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster

	ability:ApplyDataDrivenModifier(caster, target, "modifier_auriun_immortal_weapon_2_insight", {})
	local newStacks = math.min(target:GetModifierStackCount("modifier_auriun_immortal_weapon_2_insight", caster) + 1, AURIUN_IMMO_WEAPON_2_MAX_STACKS)
	target:SetModifierStackCount("modifier_auriun_immortal_weapon_2_insight", caster, newStacks)
end

function trapper_immortal_3_start(event)
	local target = event.target
	local caster = event.caster
	target:AddNewModifier(caster, nil, 'modifier_trapper_immo3_effect', nil)
end

function trapper_immortal_3_end(event)
	local target = event.target
	local caster = event.caster
	target:RemoveModifierByName("modifier_trapper_immo3_effect")
end

function spirit_warrior_immo3_attack_start(event)
	local attacker = event.attacker
	local target = event.target
	if not attacker:HasModifier("modifier_attack_split_lock") then
		local attackTime = attacker:GetAttackAnimationPoint()
		event.ability:ApplyDataDrivenModifier(event.caster, attacker, "modifier_attack_split_lock", {duration = attackTime})
		Timers:CreateTimer(attackTime, function()
			local radius = attacker:Script_GetAttackRange()
			local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
			local max = SPIRIT_WARRIOR_IMMORTAL_WEAPON_3_SPLITSHOT_ENEMIES
			local counter = 0
			if #enemies > 0 then
				--print(#enemies)
				for _, enemy in pairs(enemies) do
					if enemy:GetEntityIndex() == target:GetEntityIndex() then
					else
						if counter < max then
							counter = counter + 1
							--print("PERFORM ATTACK")
							Filters:PerformAttackSpecial(attacker, enemy, true, true, true, false, true, false, false)
						end
					end
				end
			end
		end)
	end
end

function mountain_protector_immo2_kill(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local attacker = event.attacker
	if event.unit:GetDeathXP() > 0 then
		ability:ApplyDataDrivenModifier(caster, attacker, "modifier_immortal_weapon_2_stacks", {})
		local newStacks = attacker:GetModifierStackCount("modifier_immortal_weapon_2_stacks", caster) + 1
		attacker:SetModifierStackCount("modifier_immortal_weapon_2_stacks", caster, newStacks)
	end
end

function cherno_immo3_attack_land(event)
	local attacker = event.attacker

	local heal = attacker:GetMaxHealth() * CHERNOBOG_IMMORTAL_WEAPON_3_HP_HEAL_PCT/100
	attacker:SetHealth(attacker:GetHealth() + heal)

	local particleName = "particles/roshpit/chernobog/cherno_immo3_lifesteal.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, attacker)
	ParticleManager:SetParticleControlEnt(pfx, 0, attacker, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, attacker, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 2, attacker, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 3, attacker, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin(), true)
	Timers:CreateTimer(1, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
end

function ekkan_immo2_gargoyle_attack_land(event)
	local target = event.target
	local attacker = event.attacker
	local damage = OverflowProtectedGetAverageTrueAttackDamage(attacker)*EKKAN_IMMORTAL_WEAPON_2_FAMILIAR_PURE_UNDEAD_ATTACK_PCT/100
	local source = attacker.hero
	CustomAbilities:QuickAttachParticle("particles/roshpit/ekkan/immo2_gargoyle_hit.vpcf", target, 1.2)
	Filters:ApplyItemDamage(target, source, damage, DAMAGE_TYPE_PURE, event.ability, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_NONE)
end
