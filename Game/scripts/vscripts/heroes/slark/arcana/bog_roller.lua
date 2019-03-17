LinkLuaModifier("slipfinn_bog_roller_lua", "modifiers/slipfinn/slipfinn_bog_roller_lua", LUA_MODIFIER_MOTION_NONE)
require('heroes/slark/constants')
function turn_toggle_on(event)
	local caster = event.caster
	local ability = event.ability
	EndAnimation(caster)
	caster:StartGesture(ACT_DOTA_SLARK_POUNCE)
	-- Timers:CreateTimer(0.03, function()
	-- 	StartAnimation(caster, {duration=0.45, activity=ACT_DOTA_SLARK_POUNCE, rate=1.1})
	-- end)
	EmitSoundOn("Slipfinn.BogRoller.Start", caster)
	local soundChance = RandomInt(1, 3)
	if soundChance < 3 then
		EmitSoundOn("Slipfinn.BogRoller.Start.VO", caster)
	end
	Timers:CreateTimer(0.5, function()
		if caster:HasModifier("modifier_slipfinn_bog_roller") then
			EndAnimation(caster)

			caster:AddNewModifier( caster, ability, "slipfinn_bog_roller_lua", {} )
			StartSoundEvent("Slipfinn.BogRoller.LP", caster)
			StartSoundEvent("Slipfinn.BogRoller.LP2", caster)
			Timers:CreateTimer(0.03, function()
				StartAnimation(caster, {duration=99999, activity=ACT_DOTA_RUN, rate=1})
			end)
			Filters:CastSkillArguments(3, caster)
		end
	end)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_slipfinn_bog_roller", {})
	CustomAbilities:QuickAttachParticle("particles/econ/courier/courier_kunkka_parrot/courier_kunkka_parrot_splash.vpcf", caster, 2)
	caster:SetRenderColor(10, 150, 255)
	ability.fv = caster:GetForwardVector()
	ability.fall_speed = 0
	
	ability.rollspeed = caster.speed
	local e_2_level = caster:GetRuneValue("e", 2)
	if e_2_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_bog_roller_attack_dmg_pct", {})
		caster:SetModifierStackCount("modifier_bog_roller_attack_dmg_pct", caster, e_2_level)
	end
	local e_3_level = caster:GetRuneValue("e", 3)
	if e_3_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_slipfinn_bog_roller_e3", {})
		caster:SetModifierStackCount("modifier_slipfinn_bog_roller_e3", caster, e_3_level)
	end
end

function turn_toggle_off(event)
	local caster = event.caster
	local ability = event.ability
end

function bog_roller_think(event)
	local caster = event.caster
	local ability = event.ability

	if caster:HasModifier("modifier_slipfinn_buttstomp") then
		return false
	end
	if caster:IsChanneling() then
		return false
	end
	if caster:HasModifier("modifier_bog_roller_collision") then
		caster:SetForwardVector(ability.collisionFV)
		if not caster:HasModifier("modifier_slipfinn_basic_jump") then
			caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,ability.collisionJumpForce))
			ability.collisionJumpForce = ability.collisionJumpForce - 2.5
		else
			caster:RemoveModifierByName("modifier_bog_roller_collision")
		end
		local distance_from_ground = caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster)
		if distance_from_ground < 10 and ability.collisionJumpForce < 0 then
			caster:RemoveModifierByName("modifier_bog_roller_collision")
		end
	else
		local speedBonus = 0
		if caster:HasModifier("modifier_bog_roller_speedburst") then
			speedBonus = caster:GetModifierStackCount("modifier_bog_roller_speedburst", caster)
			local newStacks = speedBonus - ability.decay
			if newStacks > 0 then
				caster:SetModifierStackCount("modifier_bog_roller_speedburst", caster, newStacks)
			else
				caster:RemoveModifierByName("modifier_bog_roller_speedburst")
			end
			speedBonus = speedBonus/10
		end
		ability.rollspeed = math.min(ability.rollspeed + 1 + speedBonus, 25 + speedBonus)
		local rollSpeed = ability.rollspeed
		caster.speed = rollSpeed
		if caster:HasModifier("modifier_slipfinn_basic_jump") then
			rollSpeed = 0
		end
		local new_fv = (caster:GetForwardVector() + ability.fv*0.16):Normalized()
		caster:SetForwardVector(new_fv)
		local fv = caster:GetForwardVector()
		local new_position = caster:GetAbsOrigin() + fv*rollSpeed 

		local obstruction = WallPhysics:FindNearestObstruction(new_position)
		local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, new_position, caster)
		local groundClimb = false
		local ground_new_pos = GetGroundPosition(new_position, caster)
		if ground_new_pos.z - 100 > caster:GetAbsOrigin().z then
			blockUnit = true 
		elseif ground_new_pos.z - 2 > caster:GetAbsOrigin().z then
			groundClimb = true
		elseif ground_new_pos.z + 2 < caster:GetAbsOrigin().z then
			if caster:HasModifier("modifier_slipfinn_basic_jump") then
				ability.fall_speed = 3
			else
				ability.fall_speed = ability.fall_speed + 2.5
			end
			new_position = new_position - Vector(0,0,ability.fall_speed)
		else
			ability.fall_speed = 0
			local pfx = ParticleManager:CreateParticle( "particles/econ/items/lion/fish_stick/fish_stick_splash.vpcf", PATTACH_CUSTOMORIGIN, caster )
			ParticleManager:SetParticleControl( pfx, 0, caster:GetAbsOrigin() )
			ParticleManager:SetParticleControl( pfx, 1, Vector(200, 200, 200) )
			Timers:CreateTimer(2, function()
				ParticleManager:DestroyParticle(pfx, false)
				ParticleManager:ReleaseParticleIndex(pfx)
			end)
		end
		if groundClimb then
			new_position = ground_new_pos
		end
		if not blockUnit then
			caster:SetOrigin(new_position)
		else
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_bog_roller_collision", {duration = 1})
			EmitSoundOn("Slipfinn.BogRoller.Collision", caster)
			ability.collisionFV = fv*-1
			ability.collisionJumpForce = 30
			caster:RemoveModifierByName("modifier_bog_roller_speedburst")
			caster:Stop()
		end
	end
	if not ability.interval then
		ability.interval = 0
	end
	ability.interval = ability.interval + 1
	if ability.interval == 2 then
		ability.interval = 0
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 240, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		if #enemies > 0 then
			Filters:PerformAttackSpecial(caster, enemies[1], true, true, true, false, true, false, false)
			CustomAbilities:QuickAttachParticle("particles/roshpit/slipfinn/shadow_shank.vpcf", enemies[1], 0.4)
		end 
	end
end

function bog_roller_start(event)
	local caster = event.caster
	EmitSoundOn("Hydroxis.Arcana.MistStart", caster)
end

function bog_roller_end(event)
	local caster = event.caster
	local ability = event.ability
	caster:SetRenderColor(255, 255, 255)
	caster:RemoveModifierByName("slipfinn_bog_roller_lua")
	EmitSoundOn("Slipfinn.BogRoller.End", caster)
	EndAnimation(caster)
	Timers:CreateTimer(0.03, function()
		StartAnimation(caster, {duration=1, activity=ACT_DOTA_SLARK_POUNCE, rate=1})
	end)
	caster:RemoveModifierByName("modifier_bog_roller_attack_dmg_pct")
	caster:RemoveModifierByName("modifier_slipfinn_bog_roller_e3")
	StopSoundEvent("Slipfinn.BogRoller.LP", caster)
	StopSoundEvent("Slipfinn.BogRoller.LP2", caster)
end

function bog_roller_death(event)
	local caster = event.caster
	local ability = event.ability
	if ability:GetToggleState() then
		ability:ToggleAbility()
	end
	Timers:CreateTimer(0.03, function()
		caster:RemoveModifierByName("modifier_slipfinn_bog_roller")
	end)
end

function bog_roller_passive_attack_land(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local armor_break_percent = event.armor_break_percent
	local current_stacks = target:GetModifierStackCount("modifier_slipfinn_bog_roller_armor_break", caster)
	local stacks = (target:GetPhysicalArmorValue()+current_stacks)*(armor_break_percent/100)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_slipfinn_bog_roller_armor_break", {duration = 10})
	target:SetModifierStackCount("modifier_slipfinn_bog_roller_armor_break", caster, stacks)
	if target.dummy then
		return false
	end
	if not ability.particle_count then
		ability.particle_count = 0
	end
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)*(event.shadow_damage_on_attack/100)
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_PURE, 3, RPC_ELEMENT_SHADOW, RPC_ELEMENT_NONE)
	if ability.particle_count <= 10 then
		CustomAbilities:QuickAttachParticle("particles/roshpit/slipfinn/shadow_shank.vpcf", target, 0.4)
		ability.particle_count = ability.particle_count + 1
	end
	local e_2_level = caster:GetRuneValue("e", 2)
	
	if e_2_level > 0 then
		if ability.particle_count <= 15 then
			ability.particle_count = ability.particle_count + 1
			CustomAbilities:QuickAttachParticle("particles/roshpit/slipfinn/bog_mystic_dagger.vpcf", target, 2)
		end
		local e_2_damage = OverflowProtectedGetAverageTrueAttackDamage(caster)*(SLIPFINN_E2_WATER_DAMAGE_ATK_POWER_PCT/100)
		Filters:TakeArgumentsAndApplyDamage(target, caster, e_2_damage, DAMAGE_TYPE_MAGICAL, 3, RPC_ELEMENT_WATER, RPC_ELEMENT_NONE)
	end
	Timers:CreateTimer(1, function()
		ability.particle_count = ability.particle_count - 1
	end)
end

function bog_roller_razor(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local radius = 300
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)*(SLIPFINN_E1_RAZOR/100)*ability.e_1_level
	for _,enemy in pairs(enemies) do
		Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PURE, 3, RPC_ELEMENT_SHADOW, RPC_ELEMENT_WATER)
	end
end

function bog_roller_razor_end(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	StopSoundEvent("Slipfinn.BogRoller.RazorLP", caster)
	EmitSoundOn("Slipfinn.BogRoller.RazorEnd", caster)
end