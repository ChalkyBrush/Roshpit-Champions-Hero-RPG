require('/heroes/monkey_king/constants')

LinkLuaModifier("modifier_draghor_shapeshift_shrink", "modifiers/draghor/modifier_draghor_shapeshift_shrink", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_draghor_shapeshift_hawk_lua", "modifiers/draghor/modifier_draghor_shapeshift_hawk_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_draghor_shapeshift_cat_lua", "modifiers/draghor/modifier_draghor_shapeshift_cat_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_draghor_shapeshift_bear_lua", "modifiers/draghor/modifier_draghor_shapeshift_bear_lua", LUA_MODIFIER_MOTION_NONE)

function start_channel(event)
	local caster = event.caster
	local ability = event.ability
	caster:AddNewModifier( caster, ability, "modifier_draghor_shapeshift_shrink", {} )

	local colorVector = Vector(0.45,0.8,0.6)
	local springParticle = "particles/econ/items/monkey_king/arcana/death/monkey_king_spring_death_base.vpcf"
	if caster:HasModifier("modifier_mark_of_the_fang") then
	elseif caster:HasModifier("modifier_mark_of_the_claw") then
		springParticle = "particles/roshpit/draghor/shapeshift_effect_red_base.vpcf"
		colorVector = Vector(0.8, 0.45, 0.45)
	elseif caster:HasModifier("modifier_mark_of_the_talon") then
		springParticle = "particles/roshpit/draghor/shapeshift_effect_blue_base.vpcf"
		colorVector = Vector(0.4, 0.55, 0.7)
	end

	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, true)
	end
	local pfx = ParticleManager:CreateParticle( "particles/roshpit/draghor/shapeshift_smoke.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()+Vector(0,0,40))
	ParticleManager:SetParticleControl(pfx, 5, colorVector)
	ParticleManager:SetParticleControl(pfx, 2, Vector(0.7,0.7,0.7))
	ability.pfx = pfx
	EmitSoundOn("Draghor.ShapeshiftCat.VO", caster)
	CustomAbilities:QuickParticleAtPoint(springParticle, caster:GetAbsOrigin(), 4)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Draghor.Shapeshifting.Start", caster)
end

function channel_end(event)
	local caster = event.caster
	local ability = event.ability
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ability.pfx = false
	end
	caster:RemoveModifierByName("modifier_draghor_shapeshift_shrink")
end

function shapeshift_start_cat(event)
	local caster = event.caster
	local ability = event.ability
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ability.pfx = false
	end
	all_shift(caster)
	CustomAbilities:QuickParticleAtPoint("particles/econ/items/monkey_king/arcana/death/monkey_king_spring_death_base.vpcf", caster:GetAbsOrigin(), 4)
	EmitSoundOn("Draghor.ShapeshiftCat.Growl", caster)
	caster:RemoveModifierByName("modifier_draghor_shapeshift_shrink")
	local wolfModel = "models/items/lycan/ultimate/alpha_trueform9/alpha_trueform9.vmdl"
	if caster:HasModifier("modifier_djanghor_immortal_weapon_1") then
		wolfModel = "models/items/lycan/ultimate/hunter_kings_trueform/hunter_kings_trueform.vmdl"
	end
	caster:SetOriginalModel(wolfModel)
	caster:SetModel(wolfModel)
	CustomAbilities:AddAndOrSwapSkill(caster, "draghor_shapeshift_cat", "draghor_monkey_form", 3)
	caster:AddNewModifier( caster, ability, "modifier_draghor_shapeshift_cat_lua", {} )
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Draghor.ShapeshiftIn.Finish", caster)
	StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_OVERRIDE_ABILITY_4, rate=1.2})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_shapeshift_cat", {})
	if caster:HasModifier("modifier_mark_of_the_fang") then
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_shapeshift_cat", "draghor_monkey_form", 3)
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_mark_of_the_claw", "djanghor_wolf_howl", 0)
	elseif caster:HasModifier("modifier_mark_of_the_claw") then
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_shapeshift_bear", "draghor_monkey_form", 3)
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_mark_of_the_talon", "djanghor_wolf_howl", 0)
	elseif caster:HasModifier("modifier_mark_of_the_talon") then
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_shapeshift_crow", "draghor_monkey_form", 3)
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_mark_of_the_fang", "djanghor_wolf_howl", 0)
	end
	if caster:HasModifier("modifier_djanghor_glyph_2_1") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_glyph_2_critical", {})
	end
	if caster:HasModifier("modifier_djanghor_glyph_3_1") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_glyph_3_evasion_wolf", {})
	end
	CustomAbilities:AddAndOrSwapSkill(caster, "draghor_jin_bo", "draghor_wolf_rend", 1)
	CustomAbilities:AddAndOrSwapSkill(caster, "draghor_monkey_leap", "djanghor_feral_sprint", 2)
	local d_d_level = Runes:GetTotalRuneLevelGeneric(caster, 4, 3)
	if d_d_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_shapeshift_cat_d_d", {})
		caster:SetModifierStackCount("modifier_shapeshift_cat_d_d", caster, d_d_level)
	end	
	all_shift_after(caster)
end

function shapeshift_start_bear(event)
	local caster = event.caster
	local ability = event.ability
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ability.pfx = false
	end
	all_shift(caster)
	CustomAbilities:QuickParticleAtPoint("particles/roshpit/draghor/shapeshift_effect_red_base.vpcf", caster:GetAbsOrigin(), 4)
	EmitSoundOn("Draghor.ShapeshiftBear.Growl", caster)
	caster:RemoveModifierByName("modifier_draghor_shapeshift_shrink")
	local bearModel = "models/heroes/lone_druid/spirit_bear.vmdl"
	if caster:HasModifier("modifier_djanghor_immortal_weapon_2") then
		bearModel = "models/items/lone_druid/bear/iron_claw_spirit_bear/iron_claw_spirit_bear.vmdl"
	end
	caster:SetOriginalModel(bearModel)
	caster:SetModel(bearModel)
	CustomAbilities:AddAndOrSwapSkill(caster, "draghor_shapeshift_bear", "draghor_monkey_form", 3)
	caster:AddNewModifier( caster, ability, "modifier_draghor_shapeshift_bear_lua", {} )
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Draghor.ShapeshiftIn.Finish", caster)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_shapeshift_bear", {})
	if caster:HasModifier("modifier_mark_of_the_fang") then
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_shapeshift_cat", "draghor_monkey_form", 3)
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_mark_of_the_claw", "djanghor_bear_roar", 0)
	elseif caster:HasModifier("modifier_mark_of_the_claw") then
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_shapeshift_bear", "draghor_monkey_form", 3)
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_mark_of_the_talon", "djanghor_bear_roar", 0)
	elseif caster:HasModifier("modifier_mark_of_the_talon") then
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_shapeshift_crow", "draghor_monkey_form", 3)
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_mark_of_the_fang", "djanghor_bear_roar", 0)
	end
	if caster:HasModifier("modifier_djanghor_glyph_7_1") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_glyph_7_bash", {})
	end
	CustomAbilities:AddAndOrSwapSkill(caster,"draghor_jin_bo", "djanghor_bear_war_stomp", 1)
	CustomAbilities:AddAndOrSwapSkill(caster, "draghor_monkey_leap", "djanghor_bear_charge", 2)
	local b_d_level = Runes:GetTotalRuneLevelGeneric(caster, 2, 3)
	if b_d_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_bear_b_d", {})
		caster:SetModifierStackCount("modifier_bear_b_d", caster, b_d_level)
	end
	local d_d_level = Runes:GetTotalRuneLevelGeneric(caster, 4, 3)
	if d_d_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_shapeshift_bear_d_d", {})
		caster:SetModifierStackCount("modifier_shapeshift_bear_d_d", caster, d_d_level)
	end
	all_shift_after(caster)
end

function shapeshift_start_crow(event)
	local caster = event.caster
	local ability = event.ability
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ability.pfx = false
	end
	all_shift(caster)
	CustomAbilities:QuickParticleAtPoint("particles/roshpit/draghor/shapeshift_effect_blue_base.vpcf", caster:GetAbsOrigin(), 4)
	EmitSoundOn("Draghor.ShapeshiftHawk.Growl", caster)
	caster:RemoveModifierByName("modifier_draghor_shapeshift_shrink")
	local hawkModel = "models/heroes/beastmaster/beastmaster_bird.vmdl"
	if caster:HasModifier("modifier_djanghor_immortal_weapon_3") then
		hawkModel = "models/items/beastmaster/hawk/beast_heart_marauder_beast_heart_marauder_raven/beast_heart_marauder_beast_heart_marauder_raven.vmdl"
	end
	caster:SetOriginalModel(hawkModel)
	caster:SetModel(hawkModel)
	CustomAbilities:AddAndOrSwapSkill(caster, "draghor_shapeshift_crow", "draghor_monkey_form", 3)
	caster:AddNewModifier( caster, ability, "modifier_draghor_shapeshift_hawk_lua", {} )
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Draghor.ShapeshiftIn.Finish", caster)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_shapeshift_crow", {})
	if caster:HasModifier("modifier_mark_of_the_fang") then
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_shapeshift_cat", "draghor_monkey_form", 3)
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_mark_of_the_claw", "draghor_hawk_screech", 0)
	elseif caster:HasModifier("modifier_mark_of_the_claw") then
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_shapeshift_bear", "draghor_monkey_form", 3)
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_mark_of_the_talon", "draghor_hawk_screech", 0)
	elseif caster:HasModifier("modifier_mark_of_the_talon") then
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_shapeshift_crow", "draghor_monkey_form", 3)
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_mark_of_the_fang", "draghor_hawk_screech", 0)
	end
	CustomAbilities:AddAndOrSwapSkill(caster,"draghor_jin_bo", "draghor_hawk_tornado", 1)
	CustomAbilities:AddAndOrSwapSkill(caster, "draghor_monkey_leap", "djanghor_hawk_soar", 2)
	local c_d_level = Runes:GetTotalRuneLevelGeneric(caster, 3, 3)
	if c_d_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_hawk_c_d", {})
		caster:SetModifierStackCount("modifier_hawk_c_d", caster, c_d_level)
	end
	local d_d_level = Runes:GetTotalRuneLevelGeneric(caster, 4, 3)
	if d_d_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_shapeshift_crow_d_d", {})
		caster:SetModifierStackCount("modifier_shapeshift_crow_d_d", caster, d_d_level)
	end
	all_shift_after(caster)
end

function all_shift(caster)
	caster:RemoveModifierByName("modifier_glyph_3_evasion_monkey")
end

function all_shift_after(caster)
	if caster:HasModifier("modifier_djanghor_glyph_4_1") then
		local monkeyForm = caster:FindAbilityByName("draghor_monkey_form")
		monkeyForm:ApplyDataDrivenModifier(caster, caster, "modifier_djanghor_4_1_shield", {duration = 12})
		caster:SetModifierStackCount("modifier_djanghor_4_1_shield", caster, DJANGHOR_GLYPH_4_1_SHIELD_STACKS)
	end
	Filters:CastSkillArguments(4, caster)
end

function monkey_form(event)
	local caster = event.caster
	local ability = event.ability

	caster:RemoveModifierByName("modifier_glyph_3_evasion_wolf")
	if caster:HasModifier("modifier_bear_b_d") then
		local bearShiftAbility = caster:FindAbilityByName("draghor_shapeshift_bear")
		bearShiftAbility:ApplyDataDrivenModifier(caster, caster, "modifier_bear_b_d", {duration = 7})
	end
	if caster:HasModifier("modifier_hawk_c_d") then
		local hawkShiftAbility = caster:FindAbilityByName("draghor_shapeshift_crow")
		hawkShiftAbility:ApplyDataDrivenModifier(caster, caster, "modifier_hawk_c_d", {duration = 7})
	end
	if caster:HasModifier("modifier_glyph_2_critical") then
		local wolfShiftAbility = caster:FindAbilityByName("draghor_shapeshift_cat")
		wolfShiftAbility:ApplyDataDrivenModifier(caster, caster, "modifier_glyph_2_critical", {duration = 7})
	end
	if caster:HasModifier("modifier_djanghor_glyph_3_1") then
		local wolfShiftAbility = caster:FindAbilityByName("draghor_shapeshift_cat")
		wolfShiftAbility:ApplyDataDrivenModifier(caster, caster, "modifier_glyph_3_evasion_monkey", {})
	end
	if caster:HasModifier("modifier_glyph_7_bash") then
		local bearShiftAbility = caster:FindAbilityByName("draghor_shapeshift_bear")
		bearShiftAbility:ApplyDataDrivenModifier(caster, caster, "modifier_glyph_7_bash", {duration = 10})
	end
	local colorVector = Vector(0.45,0.8,0.6)
	local springParticle = "particles/econ/items/monkey_king/arcana/death/monkey_king_spring_death_base.vpcf"

	if caster:HasModifier("modifier_mark_of_the_fang") then
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_monkey_form", "draghor_shapeshift_cat", 3)
		CustomAbilities:AddAndOrSwapSkill(caster, "djanghor_wolf_howl", "draghor_mark_of_the_claw", 0)
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_wolf_rend", "draghor_jin_bo", 1)
		CustomAbilities:AddAndOrSwapSkill(caster, "djanghor_feral_sprint", "draghor_monkey_leap", 2)
	elseif caster:HasModifier("modifier_mark_of_the_claw") then
		colorVector = Vector(0.8, 0.45, 0.45)
		springParticle = "particles/roshpit/draghor/shapeshift_effect_red_base.vpcf"
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_monkey_form", "draghor_shapeshift_bear", 3)
		CustomAbilities:AddAndOrSwapSkill(caster, "djanghor_bear_roar", "draghor_mark_of_the_talon", 0)
		CustomAbilities:AddAndOrSwapSkill(caster, "djanghor_bear_war_stomp", "draghor_jin_bo", 1)
		CustomAbilities:AddAndOrSwapSkill(caster, "djanghor_bear_charge", "draghor_monkey_leap", 2)
	elseif caster:HasModifier("modifier_mark_of_the_talon") then
		colorVector = Vector(0.4, 0.55, 0.7)
		springParticle = "particles/roshpit/draghor/shapeshift_effect_blue_base.vpcf"
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_monkey_form", "draghor_shapeshift_crow", 3)
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_hawk_screech", "draghor_mark_of_the_fang", 0)
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_hawk_tornado", "draghor_jin_bo", 1)
		CustomAbilities:AddAndOrSwapSkill(caster, "djanghor_hawk_soar", "draghor_monkey_leap", 2)
	end

	CustomAbilities:QuickParticleAtPoint(springParticle, caster:GetAbsOrigin(), 4)
	local pfx = ParticleManager:CreateParticle(  "particles/roshpit/draghor/shapeshift_smoke.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()+Vector(0,0,40))
	ParticleManager:SetParticleControl(pfx, 5, colorVector)
	ParticleManager:SetParticleControl(pfx, 2, Vector(0.5,0.5,0.5))	
	Timers:CreateTimer(0.8, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)

	EmitSoundOn("Draghor.ShapeshiftOut.VO", caster)
	caster:SetOriginalModel("models/heroes/monkey_king/monkey_king.vmdl")
	caster:SetModel("models/heroes/monkey_king/monkey_king.vmdl")
	caster:RemoveModifierByName("modifier_shapeshift_crow")
	caster:RemoveModifierByName("modifier_shapeshift_cat")
	caster:RemoveModifierByName("modifier_shapeshift_bear")
	if caster:HasModifier("modifier_draghor_shapeshift_hawk_lua") then
		caster:AddNewModifier( caster, ability, "modifier_draghor_shapeshift_shrink", {duration = 0.5} )
	end
	caster:RemoveModifierByName("modifier_draghor_shapeshift_hawk_lua")
	caster:RemoveModifierByName("modifier_draghor_shapeshift_cat_lua")
	caster:RemoveModifierByName("modifier_draghor_shapeshift_bear_lua")
	caster:RemoveModifierByName("modifier_hawk_soar")
	caster:RemoveModifierByName("modifier_hawk_soar_visual_z")
	caster:RemoveModifierByName("modifier_shapeshift_attack_power_a_d")
	caster:RemoveModifierByName("modifier_shapeshift_cat_d_d")
	caster:RemoveModifierByName("modifier_shapeshift_bear_d_d")
	caster:RemoveModifierByName("modifier_shapeshift_crow_d_d")
	Timers:CreateTimer(0.03, function()
		caster:RemoveModifierByName("modifier_shapeshift_attack_power_a_d")
		caster:RemoveModifierByName("modifier_hawk_soar_visual_z_down")
	end)
	StartAnimation(caster, {duration=1.2, activity=ACT_DOTA_MK_SPRING_END, rate=0.8})
	Timers:CreateTimer(0.24, function()
		local pfx2 = ParticleManager:CreateParticle(  "particles/roshpit/mountain_protector/unshakable_stone_dust.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx2, 0, caster:GetAbsOrigin()+Vector(0,0,30)+caster:GetForwardVector()*90)
		ParticleManager:SetParticleControl(pfx2, 5, colorVector)
		ParticleManager:SetParticleControl(pfx2, 2, Vector(0.2,0.2,0.2))	
		Timers:CreateTimer(0.8, function()
			ParticleManager:DestroyParticle(pfx2, false)
		end)

	end)

	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Draghor.ShapeshiftOut.Sound", caster)

end

function crow_think(event)
	local caster = event.caster
	local newPos = caster:GetAbsOrigin()+caster:GetForwardVector()*70
	local obstruction = WallPhysics:FindNearestObstruction(caster:GetAbsOrigin())
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPos, caster)
	if blockUnit then
		caster:SetAbsOrigin(caster:GetAbsOrigin()-caster:GetForwardVector()*60)
		monkey_form(event)
	end
	if not caster:HasModifier("modifier_djanghor_immortal_weapon_3") then
		local manaDrain = math.ceil(caster:GetMaxMana()*0.003)
		if caster:GetMana() < manaDrain then
			monkey_form(event)
		else
			caster:ReduceMana(manaDrain)
		end
	end

end

function shapeshifting_think(event)
	local caster = event.caster
	if caster:HasModifier("modifier_draghor_feral_sprint") then
		local modifier = caster:FindModifierByName("modifier_draghor_feral_sprint")
		local modifier2 = caster:FindModifierByName("modifier_wolf_sprint")
		local time = modifier:GetRemainingTime()
		print(time)
		modifier:SetDuration(time+0.1, true)
		modifier2:SetDuration(time+0.1, true)
	end
end

function general_shapeshift_think(event)
	local caster = event.caster
	local ability = event.ability
	local a_d_level = Runes:GetTotalRuneLevelGeneric(caster, 1, 3)
	if a_d_level > 0 then
		if not caster:HasModifier("modifier_shapeshift_attack_power_a_d") then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_shapeshift_attack_power_a_d", {})
		end
		local attribute = 0
		if event.index == 1 then
			attribute = caster:GetAgility()
		elseif event.index == 2 then
			attribute = caster:GetStrength()
		elseif event.index == 3 then
			attribute = caster:GetIntellect()
		end
		local attackBonus = attribute*a_d_level*DJANGHOR_R1_ATTACK_POWER_PER_STAT
		if caster:HasModifier("modifier_djanghor_immortal_weapon_1") then
			attackBonus = attackBonus + attribute*5
		end
		caster:SetModifierStackCount("modifier_shapeshift_attack_power_a_d", caster, attackBonus)
	else
		caster:RemoveModifierByName("modifier_shapeshift_attack_power_a_d")
	end
end

function wolf_pre_attack(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local luck = RandomInt(1,5)
	if luck == 1 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_glyph_2_critical_effect", {duration = 1.5})
		
		EmitSoundOn("Draghor.Crit.Pre", target)
		CustomAbilities:QuickAttachParticle("particles/roshpit/draghor/wolf_crit.vpcf", caster, 0.5)
	end
end

function wolf_crit_land(event)
	local caster = event.caster
	local target = event.target
	local damage = event.damage
	PopupDamage(target, math.floor(damage))
	caster:RemoveModifierByName("modifier_glyph_2_critical_effect")
end

function bear_pre_attack(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local luck = RandomInt(1,5)
	if luck == 1 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_glyph_7_bash_effect", {duration = 1.5})
		CustomAbilities:QuickAttachParticle("particles/roshpit/draghor/bear_bash.vpcf", caster, 0.5)
	end
end

function bear_crit_land(event)
	local caster = event.caster
	local target = event.target
	local damage = event.damage
	Filters:ApplyStun(caster, 1.5, target)
	EmitSoundOn("Draghor.Bear.Bash", target)
	caster:RemoveModifierByName("modifier_glyph_7_bash_effect")
end