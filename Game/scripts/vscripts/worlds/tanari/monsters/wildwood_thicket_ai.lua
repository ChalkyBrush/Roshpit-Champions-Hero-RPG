function pure_strike_attack_land(event)
	local attacker = event.attacker
	local target = event.target
	local damage = OverflowProtectedGetAverageTrueAttackDamage(attacker) * 0.03
	local ability = event.ability
	ApplyDamage({victim = target, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
	local key = target:GetEntityIndex() .. '_pure_strike_land'
    Util.Common:LimitPerTime(1, 1, key .. '_particles',function()
		CustomAbilities:QuickAttachParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5_gold/am_manaburn_basher_ti_5_gold.vpcf", target, 1)
		EmitSoundOn("Creature.PureStrikeImpact", target)
	end)
end

function ritual_healing(event)
	local target = event.target
	local caster = event.caster
	EmitSoundOn("Tanari.RitualHeal", target)
	local healMult = 0.015
	if target.paragon then
		healMult = 0.005
	end
	local healAmount = target:GetMaxHealth() * healMult
	target:Heal(healAmount, caster)
	PopupHealing(target, healAmount)
	local particleName = "particles/units/heroes/hero_oracle/duskbringer_c_a_heal_heal.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	Timers:CreateTimer(1, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_oracle/duskbringer_c_a_heal_break_heal.vpcf", caster, 1)
end

function ritual_healing_think(event)
	local ability = event.ability
	local caster = event.caster
	if IsValidEntity(ability) then
		if ability:IsFullyCastable() and caster.aggro then
			local target_teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY
			local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
			local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
			local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 940, target_teams, target_types, target_flags, FIND_ANY_ORDER, false)
			if #allies > 0 then
				for i = 1, #allies, 1 do
					if allies[i]:GetHealth() < (allies[i]:GetMaxHealth()) then
						local newOrder = {
							UnitIndex = caster:entindex(),
							OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
							TargetIndex = allies[i]:entindex(),
							AbilityIndex = ability:entindex(),
						}
						ExecuteOrderFromTable(newOrder)
						break
					end
				end
			end
		end
		if caster.aggro then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 480, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				local sumVector = Vector(0, 0)
				for i = 1, #enemies, 1 do
					sumVector = sumVector + enemies[i]:GetAbsOrigin()
				end
				local avgVector = sumVector / #enemies
				local runDirection = ((caster:GetAbsOrigin() - avgVector) * Vector(1, 1, 0)):Normalized()
				caster:MoveToPosition(caster:GetAbsOrigin() + runDirection * 300)
			end
		end
	end
end

function high_priest_think(event)
	local ability = event.ability
	local caster = event.caster
	if ability:IsFullyCastable() and caster.aggro then
		local target_teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY
		local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
		local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
		local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 940, target_teams, target_types, target_flags, FIND_ANY_ORDER, false)
		if #allies > 0 then
			for i = 1, #allies, 1 do
				if allies[i]:GetHealth() < allies[i]:GetMaxHealth() then
					local newOrder = {
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
						TargetIndex = allies[i]:entindex(),
						AbilityIndex = ability:entindex(),
					}
					ExecuteOrderFromTable(newOrder)
				end
			end
		end
	end
end

function bat_move(event)
	local caster = event.caster
	if not caster.aggro then
		local basePos = Vector(4928, 8064)
		local randomX = RandomInt(1, 500)
		local randomY = RandomInt(1, 1600)
		local moveVector = Vector(basePos.x + randomX, basePos.y + randomY)
		caster:MoveToPosition(moveVector)
	end
end

function bat_attack_land(event)
	local caster = event.attacker
	local target = event.target
	local ability = event.ability
	local manaDrainMult = event.mana_drain_percent / 100
	local manaDrain = math.min(target:GetMana(), target:GetMaxMana() * manaDrainMult)
	target:ReduceMana(manaDrain)
	ApplyDamage({victim = target, attacker = caster, damage = manaDrain, damage_type = DAMAGE_TYPE_PURE, ability = ability})
	CustomAbilities:QuickAttachParticle("particles/generic_gameplay/generic_manaburn.vpcf", target, 1)
end

function thicket_bat_egg_think(event)
	local egg = event.ability
	local caster = event.caster
	if not egg.hatching then
		if not egg.movement then
			egg.movement = 0
			egg.position = caster:GetAbsOrigin()
		end
		local newDistance = WallPhysics:GetDistance(egg.position * Vector(1, 1, 0), caster:GetAbsOrigin() * Vector(1, 1, 0))
		newDistance = math.min(newDistance, 500)
		egg.movement = math.floor(egg.movement + newDistance)
		egg.position = caster:GetAbsOrigin()
		if egg.movement >= 140000 then
			egg.hatching = true
			egg:ApplyDataDrivenModifier(caster, caster, "modifier_egg_hatching", {duration = 2})
			for i = 1, 60, 1 do
				Timers:CreateTimer(i * 0.03, function()
					if not caster:IsRooted() then
						caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, 2.5))
					end
				end)
			end
			Timers:CreateTimer(1.8, function()
				local batFriend = Body:SummonFollower(caster, "tanari_thicket_bat")
				batFriend:RemoveAbility("dungeon_creep")
				batFriend:RemoveAbility("tanari_thicket_bat_ai")
				batFriend:AddAbility("tanari_bat_friend_ai"):SetLevel(1)
				batFriend:RemoveModifierByName("modifier_thicket_bat_ai")
				EmitSoundOn("Tanari.BatMatriarch.Aggro", batFriend)
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_antimage/antimage_manavoid.vpcf", caster, 2)
				Timers:CreateTimer(0.5, function()
					if IsValidEntity(egg:GetContainer()) then
						UTIL_Remove(egg:GetContainer())
					end
					UTIL_Remove(egg)
				end)
			end)
		end
	end
end

function friend_bat_move(event)
	local caster = event.caster
	local hero = caster.hero
	local distance = WallPhysics:GetDistance2d(hero:GetAbsOrigin(), caster:GetAbsOrigin())
	if distance < 700 then
		caster:MoveToPositionAggressive(hero:GetAbsOrigin() + RandomVector(RandomInt(1, 340)))
	else
		caster:MoveToPosition(hero:GetAbsOrigin() + RandomVector(RandomInt(1, 340)))
	end
end

function friend_bat_attack(event)
	local attacker = event.attacker
	local target = event.target
	local hero = attacker.hero
	local damage = OverflowProtectedGetAverageTrueAttackDamage(hero) * 20
	ApplyDamage({victim = target, attacker = hero, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR})
end

function growth_detected_enemy(event)
	local caster = event.caster
	Timers:CreateTimer(0.06, function()
		caster:RemoveNoDraw()
	end)
	caster:RemoveModifierByName("modifier_thicket_growth_waiting")
	local position = caster:GetAbsOrigin()
	GridNav:DestroyTreesAroundPoint(position, 220, false)
	Dungeons:AggroUnit(caster)
	CustomAbilities:QuickAttachParticle("particles/generic_hero_status/status_invisibility_start.vpcf", caster, 2)
	EmitSoundOn("Tanari.ThicketWatcher.Aggro", caster)
	EmitSoundOnLocationWithCaster(position, "Tanari.ThicketWatcher.AggroCrash", caster)
	CustomAbilities:QuickAttachParticle("particles/world_destruction_fx/dire_tree004b_destruction.vpcf", caster, 4)
	local animationTable = {ACT_DOTA_CAST_ABILITY_1, ACT_DOTA_CAST_ABILITY_4}
	local animation = animationTable[RandomInt(1, #animationTable)]
	StartAnimation(caster, {duration = 1.5, activity = animation, rate = 1.3})
	AddFOWViewer(DOTA_TEAM_GOODGUYS, position, 300, 5, false)
end

function watcher_enemy_attack(event)
	local ability = event.ability
	if IsValidEntity(ability) then
		if ability:GetCooldownTimeRemaining() <= 0.1 then
			local attacker = event.attacker
			local target = event.target
			local stun_duration = event.stun_duration
			local damage = event.damage
			EmitSoundOn("Tanari.ThicketWatcher.Bash", target)
			ApplyDamage({victim = target, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = ability, damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR})
			Filters:ApplyStun(attacker, stun_duration, target)
			ability:StartCooldown(4.0)
		end
	end
end
