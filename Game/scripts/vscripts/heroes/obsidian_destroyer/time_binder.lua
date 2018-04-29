function time_bind_cast(event)
	local caster = event.caster
	local ability = event.ability
	Filters:CastSkillArguments(1, caster)
	
	local d_a_level = Runes:GetTotalRuneLevel(caster, 4, "d_a", "epoch")
	if d_a_level > 0 then
		local manaDrain = caster:GetMaxMana()*0.5
		if caster:GetMana() < manaDrain then
			manaDrain = caster:GetMana()
		end
		caster:ReduceMana(manaDrain)
		ability.damageAmp = (manaDrain/100)*0.005*d_a_level + 1
	else
		ability.damageAmp = 1
	end
end

function time_binder_phase_start(event)
	local caster = event.caster
	StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_CAST_ABILITY_2, rate=0.94})	
end

function projectile_hit(event)
	local caster = event.caster
	local target = event.target
	local target_location = target:GetAbsOrigin()
	local ability = event.ability

	if caster.time_bound_units == nil then
		caster.time_bound_units = {}
	end
	local number_of_targets = event.number_of_targets
	--table.insert(caster.time_bound_units, target)
	target.time_bound = true
	ability.rune_a_a_level = rune_a_a_level(caster)
	local rune_b_a_level = rune_b_a_level(caster)
	-- if caster:HasModifier("modifier_epoch_glyph_5_a") then
	-- 	local particleName = "particles/roshpit/epoch/binder_bomb_epoch_5_a_immortal1.vpcf"
	-- 	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	-- 	ParticleManager:SetParticleControl(pfx, 0, target_location)
	-- 	EmitSoundOnLocationWithCaster(target_location, "Epoch.BinderBomb.Explode", target)
	-- 	Timers:CreateTimer(4, function()
	-- 		ParticleManager:DestroyParticle(pfx, false)
	-- 		ParticleManager:ReleaseParticleIndex(pfx)
	-- 	end)
	-- end
  	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target_location, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
  	local i = 2
	for _,enemy in pairs(enemies) do
		if i <= #enemies then
				-- if i > number_of_targets then
				-- 	break
				-- end
				local stacks = enemy:GetModifierStackCount( "modifier_time_bound", ability )
				ability:ApplyDataDrivenModifier(caster, enemies[i-1], "modifier_time_bound", {duration = 7})
				ability:ApplyDataDrivenModifier(caster, enemies[i], "modifier_time_bound", {duration = 7})
				-- enemy:SetModifierStackCount( "modifier_time_bound", ability, stacks+1)
				local particleName = "particles/units/heroes/hero_wisp/tether_green.vpcf"
				local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, enemy )
				ParticleManager:SetParticleControlEnt(pfx, 0, enemies[i-1], PATTACH_POINT_FOLLOW, "attach_hitloc", enemies[i-1]:GetAbsOrigin()+Vector(0,0,90), true)
				ParticleManager:SetParticleControlEnt(pfx, 1, enemies[i], PATTACH_POINT_FOLLOW, "attach_hitloc", enemies[i]:GetAbsOrigin()+Vector(0,0,90), true)
				enemy.time_pfx = pfx
				i = i + 1
		end
		if 1 == #enemies then
				-- apply dmg overtime debuff even if only one target
				local stacks = enemy:GetModifierStackCount( "modifier_time_bound", ability )
				ability:ApplyDataDrivenModifier(caster, enemies[i-1], "modifier_time_bound", {duration = 7})
				--ability:ApplyDataDrivenModifier(caster, enemies[i], "modifier_time_bound", {duration = 7})
				-- enemy:SetModifierStackCount( "modifier_time_bound", ability, stacks+1)
				local particleName = "particles/units/heroes/hero_wisp/tether_green.vpcf"
				local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, enemy )
				--ParticleManager:SetParticleControlEnt(pfx, 0, enemies[i-1], PATTACH_POINT_FOLLOW, "attach_hitloc", enemies[i-1]:GetAbsOrigin()+Vector(0,0,90), true)
				--ParticleManager:SetParticleControlEnt(pfx, 1, enemies[i], PATTACH_POINT_FOLLOW, "attach_hitloc", enemies[i]:GetAbsOrigin()+Vector(0,0,90), true)
				enemy.time_pfx = pfx
				--i = i + 1
		end
	end
	if #enemies > 0 then
		EmitSoundOn("Hero_Spirit_Breaker.EmpoweringHaste.Cast", enemies[1])
	end
	local point = target:GetAbsOrigin()
    local particleName = "particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_explosion.vpcf"
    local particleVector = point
  	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
  	ParticleManager:SetParticleControl( pfx, 0, particleVector )
  	ParticleManager:SetParticleControl( pfx, 1, particleVector )	
  	local damage = event.impact_damage
  	-- if caster:HasModifier("modifier_epoch_glyph_5_a") then
  	-- 	damage = damage + caster:GetAverageTrueAttackDamage(caster)*2
  	-- end
  	damage = damage*ability.damageAmp
  	EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_Abaddon.AphoticShield.Destroy", caster)
  	local enemies2 = FindUnitsInRadius( caster:GetTeamNumber(), point, nil, 320, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	for _,enemy in pairs(enemies2) do
		Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)
	end
	Timers:CreateTimer(4, function()
		ParticleManager:DestroyParticle( pfx, false )
	end)
	if ability.rune_a_a_level > 0 then
		ability.jump_count = 0
		a_a_search(caster, target, ability)
	end
	if rune_b_a_level > 0 then
		if caster:HasModifier("modifier_epoch_glyph_6_1") then 
			rune_b_a_level = rune_b_a_level * 10
		end
		local b_a_duration = Filters:GetAdjustedBuffDuration(caster, 7, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_eon_channel_friendly", {duration = b_a_duration})
		ability:ApplyDataDrivenModifier(caster, target, "modifier_eon_channel_enemy", {duration = b_a_duration})
		caster:SetModifierStackCount( "modifier_eon_channel_friendly", ability, rune_b_a_level)
		target:SetModifierStackCount( "modifier_eon_channel_enemy", ability, rune_b_a_level)
		local particleName = "particles/units/heroes/hero_wisp/epoch_rune_b_a.vpcf"
		local eonPfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, enemy )
		ParticleManager:SetParticleControlEnt(eonPfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin()+Vector(0,0,90), true)
		ParticleManager:SetParticleControlEnt(eonPfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin()+Vector(0,0,90), true)
		Timers:CreateTimer(7, function()
			ParticleManager:DestroyParticle(eonPfx, false)
		end)
	end
end

function a_a_search(caster, target, ability)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	for _,enemy in pairs(enemies) do
		if ability.jump_count >= 15 then
			break
		-- apply dmg overtime debuff even if only one target
		elseif (enemy:GetEntityIndex() == target:GetEntityIndex()) then
			if not enemy:HasModifier("modifier_space_link") then
				local stacks = enemy:GetModifierStackCount( "modifier_space_link", ability )
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_space_link", {duration = 7})
				ability:ApplyDataDrivenModifier(caster, target, "modifier_space_link", {duration = 7})
				local particleName = "particles/units/heroes/hero_wisp/wisp_tether.vpcf"
				local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, enemy )
				ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_CUSTOMORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin()+Vector(0,0,90), true)
				ParticleManager:SetParticleControlEnt(pfx, 1, enemy, PATTACH_CUSTOMORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin()+Vector(0,0,90), true)
				target.space_pfx = pfx
				EmitSoundOn("Hero_Spirit_Breaker.EmpoweringHaste.Cast", target)
				Timers:CreateTimer(0.2, function()
					a_a_search(caster, enemy, ability)
				end)
				ability.jump_count = ability.jump_count + 1
				break				
			end
		end
	end
end

function spacelink_think(event)
	local damage = event.damage_per_tick
	local ability = event.ability
	damage = damage * ability.rune_a_a_level*0.02
	damage = damage*ability.damageAmp
	local dummy_binder = event.target
	local caster = event.caster
	-- local stacks = dummy_binder:GetModifierStackCount( "modifier_time_bound", ability )
	Filters:TakeArgumentsAndApplyDamage(dummy_binder, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)
	local particleName = "particles/econ/items/antimage/antimage_weapon_basher_ti5/leshrac_wall_burn.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControlEnt(pfx, 0, dummy_binder, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", dummy_binder:GetAbsOrigin(), true)
	Timers:CreateTimer(0.5, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	end) 	
end

function space_link_end(event)
	local target = event.target
	if target.space_pfx then
		ParticleManager:DestroyParticle(target.space_pfx, false)
	end
end



function time_bind_end(event)
	local target = event.target
	if target.time_pfx then
		ParticleManager:DestroyParticle(target.time_pfx, false)
	end
end

function rune_a_a_level(caster)
  local runeUnit = caster.runeUnit
  local runeAbility = runeUnit:FindAbilityByName("epoch_rune_a_a")
  local abilityLevel = runeAbility:GetLevel()
  local bonusLevel = Runes:GetTotalBonus(runeUnit, "a_a")
  local totalLevel = abilityLevel + bonusLevel
  return totalLevel
end

function time_bind(target, next_target, caster, time_bind_name, rune_a_a_level, enemies, rune_b_a_level, rune_c_a_level)
	if target and next_target then
		target:AddAbility(time_bind_name)
		local dummy_time_bind = target:FindAbilityByName( time_bind_name )
		dummy_time_bind:SetLevel(1)
		target.time_binder = caster
		local queue = false
		-- if time_bind_name == "dummy_time_bind_two" then
		-- 	queue = true
		-- end
	    local order =
	    {
	        UnitIndex = target:GetEntityIndex(),
	        OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
	        AbilityIndex = dummy_time_bind:GetEntityIndex(),
	        TargetIndex = next_target:GetEntityIndex(),
	        Queue = queue
	    }
	    ExecuteOrderFromTable(order)
	    if time_bind_name == "dummy_time_bind" and rune_a_a_level > 0 then
	    	local procs = Runes:Procs(rune_a_a_level, 10, 1)
	    	if procs > 0 then
	    		for i = 0, procs, 1 do
					Timers:CreateTimer(i*0.15,
					function()
	    				time_bind(target, enemies[RandomInt(1, #enemies)], caster, "dummy_time_bind_two", rune_a_a_level, enemies, rune_b_a_level)
	    			end)
	    		end
	    	end
	    end
	    if time_bind_name == "dummy_time_bind" and rune_b_a_level > 0 then
	    	local lucky = RandomInt(1,100)
	    	if lucky < rune_b_a_level*2 then
		    	Timers:CreateTimer(0.06,
		    	function()
		    		time_bind(target, caster, caster, "dummy_time_bind_three", rune_a_a_level, enemies, rune_b_a_level)
		    	end)
	    	end
	    end
	end
end

function damage_think(event)
	local damage = event.damage_per_tick
	local ability = event.ability
	damage = damage*ability.damageAmp
	local dummy_binder = event.target
	local caster = event.caster
	-- local stacks = dummy_binder:GetModifierStackCount( "modifier_time_bound", ability )
	Filters:TakeArgumentsAndApplyDamage(dummy_binder, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)
	local particleName = "particles/econ/items/antimage/antimage_weapon_basher_ti5/time_bind_damage.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControlEnt(pfx, 0, dummy_binder, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", dummy_binder:GetAbsOrigin(), true)
	Timers:CreateTimer(0.5, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	end) 	
end

function modifier_end(event)
	local unit = event.target
	unit.time_binder = nil
	unit:RemoveAbility("dummy_time_bind")
end

function rune_b_a_level(caster)
  local runeUnit = caster.runeUnit2
  local runeAbility = runeUnit:FindAbilityByName("epoch_rune_b_a")
  local abilityLevel = runeAbility:GetLevel()
  local bonusLevel = Runes:GetTotalBonus(runeUnit, "b_a")
  local totalLevel = abilityLevel + bonusLevel
  return totalLevel
end

function rune_c_a(caster, target, enemies, origLevel)
  local runeUnit = caster.runeUnit3
  local runeAbility = runeUnit:FindAbilityByName("epoch_rune_c_a")
  runeAbility.enemies = enemies
  runeAbility.origLevel = origLevel
  local abilityLevel = runeAbility:GetLevel()
  local bonusLevel = Runes:GetTotalBonus(runeUnit, "c_a")
  local totalLevel = abilityLevel + bonusLevel
	if totalLevel > 0 then
		summon_c_a_guardian(caster, target, totalLevel, runeUnit, runeAbility)
	end
end

function summon_c_a_guardian(caster, target, totalLevel, runeUnit, runeAbility)
  	runeAbility.origCaster = caster
  	runeAbility.c_a_level = totalLevel
    local dummy = CreateUnitByName("epoch_summon_two", target:GetAbsOrigin()-Vector(100,100,0), true, caster, caster, caster:GetTeamNumber())
    dummy:SetModelScale(0.9+totalLevel/80)
    dummy.owner = caster:GetPlayerOwnerID()
    dummy:AddAbility("replica")
    dummy:FindAbilityByName("replica"):SetLevel(1)
    dummy:AddAbility("dummy_time_bind_four")
    dummy:FindAbilityByName("dummy_time_bind_four"):SetLevel(runeAbility.origLevel)
    runeAbility:ApplyDataDrivenModifier(runeUnit, dummy, "modifier_rune_c_a_ghost_thinker", {duration = 10})
    --dummy:MoveToNPC(caster)
    local number_of_targets = 3 + totalLevel
    if number_of_targets > 30 then
    	number_of_targets = 36
    end
	for i = 1, number_of_targets, 1 do
		Timers:CreateTimer(i*0.2,
		function()
			time_bind_c_a(dummy, runeAbility.enemies[i])
		end)
	end
end

function time_bind_c_a(c_a_guardian, next_target)
		local dummy_time_bind = c_a_guardian:FindAbilityByName( "dummy_time_bind_four")
		local queue = true
	    local order =
	    {
	        UnitIndex = c_a_guardian:GetEntityIndex(),
	        OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
	        AbilityIndex = dummy_time_bind:GetEntityIndex(),
	        TargetIndex = next_target:GetEntityIndex(),
	        Queue = queue
	    }
	    ExecuteOrderFromTable(order)
end

function c_a_think(event)
	local guardian = event.target
	local caster = event.caster
	local ability = event.ability
	local orig_caster = ability.origCaster
	local radius = 700
	guardian:MoveToPosition(orig_caster:GetAbsOrigin()+RandomVector(200))
end

function c_a_enter(event)
 	local target = event.target
	StartAnimation(target, {duration=1.5, activity=ACT_DOTA_SPAWN, rate=1.0})
	local origin = target:GetAbsOrigin()+Vector(0,0,400)
	target:SetAbsOrigin(origin)
 	for i = 0, 30, 1 do
      Timers:CreateTimer(0.03*i,
      function()
        target:SetAbsOrigin(origin+Vector(0,0,10*-i))
      end)
 	end
end

function c_a_end(event)
 local target = event.target
 local ability = event.ability
 local caster = event.caster

target:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
local particleName =  "particles/units/heroes/hero_oracle/oracle_false_promise_cast.vpcf"
local position = target:GetAbsOrigin()+Vector(0,0,300)
local particleVector = position

local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
ParticleManager:SetParticleControl( pfx, 0, particleVector )
	Timers:CreateTimer(0.4, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	  
	end)  
	UTIL_Remove(target)
end

function binder_passive_think(event)
	local caster = event.caster
	local level = Runes:GetTotalRuneLevel(caster, 3, "c_a", "epoch")
	if level > 0 then
		local runeAbility = caster.runeUnit3:FindAbilityByName("epoch_rune_c_a")
		runeAbility:ApplyDataDrivenModifier(caster.runeUnit3, caster, "modifier_epoch_c_a", {})
		runeAbility.level = level
		caster.c_a_level = level
	else
		caster:RemoveModifierByName("modifier_epoch_c_a")
	end
end

function c_a_attack_start(event)
	local ability = event.ability
	local caster = event.caster
	local attacker = event.attacker
	local manaDrain = attacker:GetMaxMana()*0.01
	-- print("man drain before "..manaDrain)
	local d_a_level = Runes:GetTotalRuneLevel(attacker, 4, "d_a", "epoch")
 	if d_a_level > 0 then
		manaDrain = manaDrain + attacker:GetMaxMana()*d_a_level*0.001
	end		
	-- print("man drain after "..manaDrain)
	if not ability then
		return false
	end
	if manaDrain > attacker:GetMana() then
		return nil
	end
	ability.level = Runes:GetTotalRuneLevel(attacker, 3, "c_a", "epoch")
	if ability.level > 0 then
		ability.attacker = attacker
		if not attacker:HasModifier("modifier_epoch_c_a_lock") then
			ability:ApplyDataDrivenModifier(caster, attacker, "modifier_epoch_c_a_lock", {duration = 0.1})
			attacker:ReduceMana(manaDrain)
		end
		local damage = manaDrain*ability.level*50
		local projectileSpeed = attacker:GetProjectileSpeed()

		ability.damage = damage
		local info = 
		{
			Target = event.target,
			Source = attacker,
			Ability = ability,	
			EffectName = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_arcane_orb.vpcf",
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
end

function c_a_strike(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster

	if not target.dummy then
		Filters:TakeArgumentsAndApplyDamage(target, ability.attacker, ability.damage, DAMAGE_TYPE_PURE, 1, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)
	end
end

function epoch_glyph_1_1(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	if caster:HasModifier("modifier_epoch_glyph_1_1") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_epoch_glyph_1_1_effect", {duration = 7})
	end
	if caster:HasModifier("modifier_epoch_glyph_6_1") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_epoch_glyph_6_1_effect", {duration = 7})
	end
end