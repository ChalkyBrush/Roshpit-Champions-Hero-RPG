LinkLuaModifier("modifier_flood_basin_lua", "modifiers/hydroxis/modifier_flood_basin_lua", LUA_MODIFIER_MOTION_NONE)

function flood_basin_start_channel(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Hydroxis.Ultimate.Voice", caster)


	if caster:HasModifier("modifier_hydroxis_glyph_6_1") then
		flood_basin_start(event)
		caster:Stop()
	else
		StartSoundEvent("Hydroxis.Arcana2.Basin.Channel", caster)
	end
end


function flood_basin_start(event)
	local caster = event.caster
	local ability = event.ability
	if not ability.basin_table then
		ability.basin_table = {}
	end
	ability.r_1_level = Runes:GetTotalRuneLevelGeneric(caster, 1, 3)
	local castLoops = 0
    if caster:HasModifier("modifier_hydroxis_glyph_1_1") then
      castLoops = 1
    end
    if event.alt_particle then
    	castLoops = 0
    end
    ability.r_3_level = Runes:GetTotalRuneLevelGeneric(caster, 3, 3)
    for i = 0, castLoops, 1 do
    	Timers:CreateTimer(i*2, function()
    		local target_position = event.target_position
			if not target_position then
				target_position = caster:GetAbsOrigin()
			end
			-- StopSoundEvent("Hydroxis.Arcana2.Basin.Channel", caster)
			local basin_dummy = CreateUnitByName("npc_dummy_unit", target_position, false, nil, nil, caster:GetTeamNumber())
			basin_dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
			local particleName = "particles/roshpit/hydroxis/arcana2/big_basin.vpcf"
			if event.alt_particle then
				particleName = "particles/roshpit/hydroxis/arcana2/flood_basin.vpcf"
			end
			local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx, 0, basin_dummy:GetAbsOrigin())
			-- ParticleManager:SetParticleControlEnt(pfx, 0, basin_dummy, PATTACH_CUSTOMORIGIN, "attach_hitloc", basin_dummy:GetAbsOrigin(), true)
			basin_dummy.pfx = pfx
			basin_dummy.radius = event.radius
			basin_dummy:SetNightTimeVisionRange(event.radius + 100)
			basin_dummy:SetDayTimeVisionRange(event.radius + 100)
			local baseDuration = 15
			local b_d_level = Runes:GetTotalRuneLevelGeneric(caster, 2, 3)
			local basin_duration = baseDuration + b_d_level*0.25
			if event.alt_particle then
				ability:ApplyDataDrivenModifier(caster, basin_dummy, "modifier_flood_basin_aura_small", {duration = basin_duration})
				ability:ApplyDataDrivenModifier(caster, basin_dummy, "modifier_flood_basin_enemy_aura_small", {duration = basin_duration})
			else
				ability:ApplyDataDrivenModifier(caster, basin_dummy, "modifier_flood_basin_aura", {duration = basin_duration})
				ability:ApplyDataDrivenModifier(caster, basin_dummy, "modifier_flood_basin_enemy_aura", {duration = basin_duration})
			end
			table.insert(ability.basin_table, basin_dummy)
			EmitSoundOnLocationWithCaster(target_position, "Hydroxis.Arcana2.BasinStart", caster)
			StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_CAST_ABILITY_2, rate=0.8})
			Filters:CastSkillArguments(4, caster)
		end)
	end
end

function flood_basin_aura_start(event)
	local caster = event.caster
	local ability = event.ability
	local a_d_level = ability.r_1_level
	print("AURA START")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_flood_basin_mana_regen", {})
	caster:AddNewModifier( caster, ability, "modifier_flood_basin_lua", {} )
	if a_d_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_flood_basin_a_d", {})
		caster:SetModifierStackCount("modifier_flood_basin_a_d", caster, a_d_level)
	end
end

function flood_basin_dummy_end(event)
	local ability = event.ability
	local target = event.target
	ParticleManager:DestroyParticle(target.pfx, false)
	UTIL_Remove(target)
	reindex_flood_basin(ability)
end

function reindex_flood_basin(ability)
	local newBasinTable = {}
	for i = 1, #ability.basin_table, 1 do
		if IsValidEntity(ability.basin_table[i]) then
			table.insert(newBasinTable, ability.basin_table[i])
		end
	end
	ability.basin_table = newBasinTable
end


function flood_basin_aura_end(event)
	local caster = event.caster
	local ability = event.ability
	if not caster:HasModifier("modifier_flood_basin_aura_effect") then
		caster:RemoveModifierByName("modifier_flood_basin_a_d")
		caster:RemoveModifierByName("modifier_flood_basin_mana_regen")
		caster:RemoveModifierByName("modifier_flood_basin_lua")
	end
end

function slippery_tail_arcana(caster, target, e_ability)
	local ability = caster:FindAbilityByName("hydroxis_spellbound_flood_basin")
	if ability.basin_table and #ability.basin_table > 0 then
		print("BASIN?")
		local closest_basin = ability.basin_table[1]
		for i = 1, #ability.basin_table, 1 do
			local distance = WallPhysics:GetDistance2d(ability.basin_table[i]:GetAbsOrigin(), target)
			local distance_closest = WallPhysics:GetDistance2d(closest_basin:GetAbsOrigin(), target)
			if distance < distance_closest and distance <= ability.basin_table[i].radius then
				closest_basin = ability.basin_table[i]
			end
		end
		if closest_basin and closest_basin.radius >= WallPhysics:GetDistance2d(closest_basin:GetAbsOrigin(), target) then
			e_ability:EndCooldown()
			e_ability:StartCooldown(0.3)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_flood_basin_transport", {duration = 0.4})
			caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin(), caster))
			StartAnimation(caster, {duration=0.15, activity=ACT_DOTA_VERSUS, rate=1.1})
			local pfx = ParticleManager:CreateParticle("particles/roshpit/hydroxis/water_bomb_water_explosion_splash_fxset.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()-Vector(0,0,200))
			Timers:CreateTimer(2, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
			for i = 1, 6, 1 do
				Timers:CreateTimer(i*0.03, function()
					caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,60))
				end)
			end
			EmitSoundOnLocationWithCaster(target, "Hydroxis.Arcana2.Basin.Splash2", caster)
			Timers:CreateTimer(0.03, function()
				EmitSoundOn("Hydroxis.Arcana2.Basin.Splash", caster)
			end)
			Timers:CreateTimer(0.2, function()
				StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_TELEPORT_END, rate=1.5})
				target = WallPhysics:WallSearch(target, caster:GetAbsOrigin(), caster)
				FindClearSpaceForUnit(caster, target, false)
				Filters:CastSkillArguments(3, caster)
				local pfx = ParticleManager:CreateParticle("particles/roshpit/hydroxis/water_bomb_water_explosion_splash_fxset.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()-Vector(0,0,200))
				Timers:CreateTimer(2, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)
			end)
			return true
		else
			return false
		end
	else
		return false
	end
end

function flood_basin_enemy_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if ability.r_3_level > 0 then
		EmitSoundOn("Hydroxis.Arcana2.Basin.Root", target)
		local root_duration = 1 + 0.15*ability.r_3_level
		ability:ApplyDataDrivenModifier(caster, target, "modifier_flood_basin_enemy_root", {duration = root_duration})
		ability:ApplyDataDrivenModifier(caster, target, "modifier_flood_basin_enemy_inside_water_stacks", {})
		target:SetModifierStackCount("modifier_flood_basin_enemy_inside_water_stacks", caster, ability.r_3_level)
	end
end

function flood_basin_enemy_end(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if not target:HasModifier("modifier_flood_basin_aura_effect_enemy") then
		target:RemoveModifierByName("modifier_flood_basin_enemy_root")
		target:RemoveModifierByName("modifier_flood_basin_enemy_inside_water_stacks")
	end
end

function basin_passive_think(event)
	local caster = event.caster
	local ability = event.ability
	local d_d_level = Runes:GetTotalRuneLevelGeneric(caster, 4, 3)
	if d_d_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_hydroxis_basin_d_d", {})
		caster:SetModifierStackCount("modifier_hydroxis_basin_d_d", caster, d_d_level)
	else
		caster:RemoveModifierByName("modifier_hydroxis_basin_d_d")
	end
end

function flood_root_init(event)
	local target = event.target
	local ability = event.ability
	if ability.basin_table and #ability.basin_table > 0 then
		print("BASIN?")
		local closest_basin = ability.basin_table[1]
		for i = 1, #ability.basin_table, 1 do
			local distance = WallPhysics:GetDistance2d(ability.basin_table[i]:GetAbsOrigin(), target:GetAbsOrigin())
			local distance_closest = WallPhysics:GetDistance2d(closest_basin:GetAbsOrigin(), target:GetAbsOrigin())
			if distance < distance_closest then
				closest_basin = ability.basin_table[i]
			end
		end
		if closest_basin then
			target.flood_basin = closest_basin
		end
	end
end

function floot_root_think(event)
	local target = event.target
	local ability = event.ability
	if target.flood_basin and IsValidEntity(target.flood_basin) then
		local fv = ((target.flood_basin:GetAbsOrigin() - target:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		fv = WallPhysics:rotateVector(fv, 2*math.pi/6)
		target:SetAbsOrigin(target:GetAbsOrigin()+fv*6)
	end
end

function flood_root_end(event)
	local target =event.target
	Timers:CreateTimer(0.03, function()
		FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
	end)
end