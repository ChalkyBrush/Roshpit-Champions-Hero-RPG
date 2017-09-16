LinkLuaModifier("modifier_draghor_shapeshift_shrink", "modifiers/draghor/modifier_draghor_shapeshift_shrink", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_draghor_shapeshift_hawk_lua", "modifiers/draghor/modifier_draghor_shapeshift_hawk_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_draghor_shapeshift_cat_lua", "modifiers/draghor/modifier_draghor_shapeshift_cat_lua", LUA_MODIFIER_MOTION_NONE)

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
		colorVector = Vector(0.3, 0.45, 0.85)
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
	CustomAbilities:QuickParticleAtPoint("particles/econ/items/monkey_king/arcana/death/monkey_king_spring_death_base.vpcf", caster:GetAbsOrigin(), 4)
	EmitSoundOn("Draghor.ShapeshiftCat.Growl", caster)
	caster:RemoveModifierByName("modifier_draghor_shapeshift_shrink")
	caster:SetOriginalModel("models/items/lycan/ultimate/alpha_trueform9/alpha_trueform9.vmdl")
	caster:SetModel("models/items/lycan/ultimate/alpha_trueform9/alpha_trueform9.vmdl")
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
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_mark_of_the_fang", "djanghor_wolf_howl", 0)
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_shapeshift_crow", "draghor_monkey_form", 3)
	end
	CustomAbilities:AddAndOrSwapSkill(caster, "draghor_jin_bo", "draghor_wolf_rend", 1)
	CustomAbilities:AddAndOrSwapSkill(caster, "draghor_monkey_leap", "djanghor_feral_sprint", 2)
	
end

function shapeshift_start_bear(event)
	local caster = event.caster
	local ability = event.ability
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ability.pfx = false
	end
	CustomAbilities:QuickParticleAtPoint("particles/roshpit/draghor/shapeshift_effect_red_base.vpcf", caster:GetAbsOrigin(), 4)
	EmitSoundOn("Draghor.ShapeshiftBear.Growl", caster)
	caster:RemoveModifierByName("modifier_draghor_shapeshift_shrink")
	caster:SetOriginalModel("models/heroes/lone_druid/spirit_bear.vmdl")
	caster:SetModel("models/heroes/lone_druid/spirit_bear.vmdl")
	CustomAbilities:AddAndOrSwapSkill(caster, "draghor_shapeshift_bear", "draghor_monkey_form", 3)
	-- caster:AddNewModifier( caster, ability, "modifier_draghor_shapeshift_cat_lua", {} )
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Draghor.ShapeshiftIn.Finish", caster)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_shapeshift_bear", {})
	if caster:HasModifier("modifier_mark_of_the_fang") then
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_shapeshift_cat", "draghor_monkey_form", 3)
	elseif caster:HasModifier("modifier_mark_of_the_claw") then
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_shapeshift_bear", "draghor_monkey_form", 3)
	elseif caster:HasModifier("modifier_mark_of_the_talon") then
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_shapeshift_crow", "draghor_monkey_form", 3)
	end
end

function shapeshift_start_crow(event)
	local caster = event.caster
	local ability = event.ability
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ability.pfx = false
	end
	CustomAbilities:QuickParticleAtPoint("particles/roshpit/draghor/shapeshift_effect_blue_base.vpcf", caster:GetAbsOrigin(), 4)
	EmitSoundOn("Draghor.ShapeshiftHawk.Growl", caster)
	caster:RemoveModifierByName("modifier_draghor_shapeshift_shrink")
	caster:SetOriginalModel("models/heroes/beastmaster/beastmaster_bird.vmdl")
	caster:SetModel("models/heroes/beastmaster/beastmaster_bird.vmdl")
	CustomAbilities:AddAndOrSwapSkill(caster, "draghor_shapeshift_crow", "draghor_monkey_form", 3)
	caster:AddNewModifier( caster, ability, "modifier_draghor_shapeshift_hawk_lua", {} )
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Draghor.ShapeshiftIn.Finish", caster)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_shapeshift_crow", {})
	if caster:HasModifier("modifier_mark_of_the_fang") then
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_shapeshift_cat", "draghor_monkey_form", 3)
	elseif caster:HasModifier("modifier_mark_of_the_claw") then
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_shapeshift_bear", "draghor_monkey_form", 3)
	elseif caster:HasModifier("modifier_mark_of_the_talon") then
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_shapeshift_crow", "draghor_monkey_form", 3)
	end
end

function monkey_form(event)
	local caster = event.caster
	local ability = event.ability

	local colorVector = Vector(0.45,0.8,0.6)
	local springParticle = "particles/econ/items/monkey_king/arcana/death/monkey_king_spring_death_base.vpcf"
	if caster:HasModifier("modifier_mark_of_the_fang") then
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_monkey_form", "draghor_shapeshift_cat", 3)
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_wolf_rend", "draghor_jin_bo", 1)
		CustomAbilities:AddAndOrSwapSkill(caster, "djanghor_wolf_howl", "draghor_mark_of_the_claw", 0)
		CustomAbilities:AddAndOrSwapSkill(caster, "djanghor_feral_sprint", "draghor_monkey_leap", 2)
	elseif caster:HasModifier("modifier_mark_of_the_claw") then
		colorVector = Vector(0.8, 0.45, 0.45)
		springParticle = "particles/roshpit/draghor/shapeshift_effect_red_base.vpcf"
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_monkey_form", "draghor_shapeshift_bear", 3)
	elseif caster:HasModifier("modifier_mark_of_the_talon") then
		colorVector = Vector(0.3, 0.45, 0.85)
		springParticle = "particles/roshpit/draghor/shapeshift_effect_blue_base.vpcf"
		CustomAbilities:AddAndOrSwapSkill(caster, "draghor_monkey_form", "draghor_shapeshift_crow", 3)
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