require("/heroes/moon_ranger/astral_ranger_constants")

function crystal_arrow_channel_start(event)
	local caster = event.caster
	local ability = event.ability
	if not caster:HasModifier("modifier_astral_glyph_5_1") then
		if not caster:HasModifier("modifier_iron_treads_of_destruction") then
			StartAnimation(caster, {duration = 2.0, activity = ACT_DOTA_ATTACK, rate = 0.75})
		end
	else
		Timers:CreateTimer(0.03, function() caster:InterruptChannel() end)
	end
	ability.liftspeed = 7.5
	ability.anim = true
	ability.arrow_spawn = true
	ability.target_point = event.target_points[1]
	if not ability.arrow_table then
		ability.arrow_table = {}
	end
	if caster:HasModifier("modifier_astral_glyph_7_1") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_astral_glyph_7_1_evasion_effect", {duration = ASTRAL_RANGER_GLYPH_7_1_EVASION_DURATION})
	end
	if caster:HasModifier("modifier_crystal_arrow_freecast") then
		local stackCount = caster:GetModifierStackCount("modifier_crystal_arrow_freecast", caster)
		if stackCount >= 10 then
			ability:EndCooldown()
			newStacks = stackCount - 10
			if newStacks > 0 then
				caster:SetModifierStackCount("modifier_crystal_arrow_freecast", caster, newStacks)
			else
				caster:RemoveModifierByName("modifier_crystal_arrow_freecast")
			end
		end
	end
	caster:RemoveModifierByName("modifier_crystal_arrow_channel_end")
	-- if ability.aoePFX then
	-- ParticleManager:DestroyParticle(ability.aoePFX, false)
	-- ability.aoePFX = false
	-- end
	-- local particleName = "particles/econ/items/underlord/underlord_ti8_immortal_weapon/underlord_ti8_immortal_pitofmalice.vpcf"
	-- ability:ApplyDataDrivenThinker(caster, GetGroundPosition(ability.target_point, caster), "modifier_cystal_arrow_ad_thinker", {duration = 7})
	StartSoundEvent("Astral.CrystalArrow.Channel", caster)
	if ability.r1_dummy then
		ability.r1_dummy:RemoveModifierByName("modifier_cystal_arrow_ad_thinker")
	end
	-- if ability.pfx then
	-- ParticleManager:DestroyParticle(ability.pfx, false)
	-- ParticleManager:ReleaseParticleIndex(ability.pfx)
	-- ability.pfx = false
	-- end
	local a_d_level = caster:GetRuneValue("r", 1)
	ability.r_1_level = a_d_level
	if a_d_level > 0 then
		ability.r1_dummy = CreateUnitByName("npc_dummy_unit", ability.target_point, false, nil, nil, caster:GetTeamNumber())
		ability.r1_dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
		ability:ApplyDataDrivenModifier(caster, ability.r1_dummy, "modifier_cystal_arrow_ad_thinker", {duration = 7})
		AddFOWViewer(caster:GetTeamNumber(), ability.target_point, 450, 3, false)
		local pfx = ParticleManager:CreateParticle("particles/roshpit/astral/crystal_arrow_a_d_area.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, ability.target_point)
		ParticleManager:SetParticleControl(pfx, 1, Vector(450, 1, 480))
		ParticleManager:SetParticleControl(pfx, 2, Vector(6, 6, 6))
		ParticleManager:SetParticleControl(pfx, 15, Vector(200, 200, 240))
		ParticleManager:SetParticleControl(pfx, 16, Vector(200, 200, 240))
		ability.pfx = pfx
	end
end

function crystal_arrow_slow_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local r_4_level = caster:GetRuneValue("r", 4)
	if r_4_level > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_crystal_arrow_chilled", {duration = -1})
		target:FindModifierByName("modifier_crystal_arrow_chilled"):SetStackCount(r_4_level)
	end
end

function crystal_arrow_slow_end(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local r_4_level = caster:GetRuneValue("r", 4)
	if not target:HasModifier("modifier_cystal_arrow_ad_thinker") then
		if r_4_level > 0 then
			local modifier = target:FindModifierByName("modifier_crystal_arrow_chilled")
			if modifier then
				modifier:SetDuration(r_4_level * ASTRAL_RANGER_ARCANA2_R4_SLOW, true)
			end
		else
			target:RemoveModifierByName("modifier_crystal_arrow_chilled")
		end
	end
end

function arrow_ad_thinker_end(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if target then
		UTIL_Remove(target)
		ability.r1_dummy = false
	end
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ParticleManager:ReleaseParticleIndex(ability.pfx)
		ability.pfx = false
	end
end

function crystal_arrow_channel_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster) < 600 and not caster:HasModifier("modifier_astral_glyph_5_1") then
		caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0, 0, ability.liftspeed))
	end
	if GameRules:GetGameTime() - ability:GetChannelStartTime() > 0.5 and ability.arrow_spawn then
		ability.arrow_spawn = false
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_crystal_arrow_buildup", {duration = 1.5})
		-- local particleName = "particles/units/heroes/hero_drow/drow_frost_arrow.vpcf"
		-- local arrow = {}
		-- arrow.velocity = 1500
		-- local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
		-- arrow.position = caster:GetAbsOrigin()
		-- ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()+Vector(0,0,20))
		-- ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin()+Vector(0,0,60))
		-- ParticleManager:SetParticleControl(pfx, 2, Vector(arrow.velocity, arrow.velocity, arrow.velocity))
		-- arrow.pending = true
		-- arrow.target_point = ability.target_point
		-- arrow.pfx = pfx
		-- arrow.startZ = 0
		-- arrow.lifting = true
		-- table.insert(ability.arrow_table, arrow)
	end
	if GameRules:GetGameTime() - ability:GetChannelStartTime() > 1.0 and ability.anim and not caster:HasModifier("modifier_astral_glyph_5_1") then
		ability.anim = false
		ability.liftspeed = 18
		StartAnimation(caster, {duration = 0.9, activity = ACT_DOTA_ATTACK, rate = 2.0})
		EmitSoundOn("Astral.CrystalArrow.VOFire", caster)
	end
	if not ability.anim then
		ability.liftspeed = ability.liftspeed - 1
	end
	-- for i = 1, #ability.arrow_table, 1 do
	-- local arrow = ability.arrow_table[i]
	-- if arrow.lifting then
	-- local pfx = arrow.pfx
	-- arrow.startZ = arrow.startZ + 5
	-- ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin()+Vector(0,0,60))
	-- arrow.position = caster:GetAbsOrigin()+Vector(0,0,60)
	-- end
	-- end
end

function crystal_arrow_channel_end(event)
	local caster = event.caster
	local ability = event.ability
	ability.fallSpeed = 10
	ability.anim = true
	StopSoundEvent("Astral.CrystalArrow.Channel", caster)
	if not caster:HasModifier("modifier_astral_glyph_5_1") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_crystal_arrow_channel_end", {duration = 4})
	else
		fire_crystal_arrow({caster = caster, ability = ability})
	end
	caster:RemoveModifierByName("modifier_astral_glyph_7_1_evasion_effect")
end

function crystal_arrow_channel_end_think(event)
	local caster = event.caster
	local ability = event.ability
	ability.fallSpeed = ability.fallSpeed + 0.5
	-- caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,ability.fallSpeed))
	local landPoint = GetGroundPosition(caster:GetAbsOrigin(), caster)
	if landPoint.z + 150 < caster:GetAbsOrigin().z then
		local landEffect = ParticleManager:CreateParticle("particles/units/heroes/hero_luna/luna_lucent_beam.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(landEffect, 0, landPoint)
		ParticleManager:SetParticleControl(landEffect, 1, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(landEffect, 2, landPoint)
		EmitSoundOn("Astral.CrystalArrow.Land", caster)
		StartAnimation(caster, {duration = 1.5, activity = ACT_DOTA_TELEPORT_END, rate = 0.8})
		Timers:CreateTimer(3, function()
			ParticleManager:DestroyParticle(landEffect, false)
		end)
	end
	caster:SetAbsOrigin(landPoint)

	-- if caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster) < 150 and ability.anim then
	-- ability.anim = false
	-- if ability.fallSpeed > 12 then
	-- StartAnimation(caster, {duration=1.5, activity=ACT_DOTA_TELEPORT_END, rate=0.8})
	-- end
	-- end
	if caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster) < 10 then
		caster:RemoveModifierByName("modifier_crystal_arrow_channel_end")
		Timers:CreateTimer(0.03, function()
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		end)
	end
	caster:RemoveModifierByName("modifier_crystal_arrow_buildup")
end

function remove_modifier_channel_start(event)
	local caster = event.caster
	if caster:HasModifier("modifier_iron_treads_of_destruction") then
		crystal_arrow_channel_start(event)
		StartAnimation(caster, {duration = 0.9, activity = ACT_DOTA_ATTACK, rate = 5.5})
	end
	if not caster:HasModifier("modifier_astral_glyph_5_1") then
		caster:RemoveModifierByName("modifier_channel_start")
	end
end

function fire_crystal_arrow(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Astral.CrystalArrow.Fire", caster)
	caster:RemoveModifierByName("modifier_channel_start")
	if caster:HasModifier("modifier_iron_treads_of_destruction") or caster:HasModifier("modifier_astral_glyph_5_1") then
		StartAnimation(caster, {duration = 0.9, activity = ACT_DOTA_ATTACK, rate = 4.0})
		for i = 0, 10 do
			Timers:CreateTimer(i * 0.03, function()
				caster:SetForwardVector((ability.target_point - caster:GetAbsOrigin()):Normalized())
			end)
		end
	end
	Timers:CreateTimer(0.03, function()
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_arrow_thinking", {duration = 3})
	end)
	local numArrows = 1
	for i = 1, numArrows, 1 do
		local particleName = "particles/units/heroes/hero_drow/drow_frost_arrow.vpcf"
		local arrow = {}
		arrow.velocity = 1500
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
		arrow.position = caster:GetAbsOrigin() + Vector(0, 0, 60)
		ParticleManager:SetParticleControl(pfx, 0, arrow.position)
		ParticleManager:SetParticleControl(pfx, 1, ability.target_point)
		ParticleManager:SetParticleControl(pfx, 2, Vector(arrow.velocity, arrow.velocity, arrow.velocity))
		arrow.pending = true
		arrow.target_point = ability.target_point
		arrow.pfx = pfx
		arrow.startZ = 0
		arrow.sound = true
		arrow.lifting = true
		arrow.fv = (ability.target_point - arrow.position):Normalized()
		table.insert(ability.arrow_table, arrow)
	end
	local b_d_level = caster:GetRuneValue("r", 2)
	ability.r_2_level = b_d_level
	if b_d_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_crystal_arrow_b_d", {duration = 7})
		caster:SetModifierStackCount("modifier_crystal_arrow_b_d", caster, b_d_level)
	end
	ability.r_4_level = caster:GetRuneValue("r", 4)
	Filters:CastSkillArguments(4, caster)
end

function arrows_thinking(event)
	local caster = event.caster
	local ability = event.ability
	local reindex = false
	for i = 1, #ability.arrow_table, 1 do
		local arrow = ability.arrow_table[i]
		if arrow then
			if arrow.pending then
				arrow.position = arrow.position + arrow.fv * arrow.velocity * 0.03
				local distance = WallPhysics:GetDistance(arrow.position, arrow.target_point)
				--print(distance)
				if distance < 250 and arrow.sound then
					arrow.sound = false
					EmitSoundOnLocationWithCaster(arrow.target_point, "Astral.CrystalArrow.Impact", caster)
				end
				if distance < 50 then
					arrow.pending = false
					arrow_explode(caster, ability, arrow.target_point, event.damage)
					ParticleManager:DestroyParticle(arrow.pfx, false)
					reindex = true
				end
			end
		end
	end
	if reindex then
		reindex_arrow_table(ability)
	end
end

function reindex_arrow_table(ability)
	local newTable = {}
	for i = 1, #ability.arrow_table, 1 do
		local arrow = ability.arrow_table[i]
		if arrow.pending then
			table.insert(newTable, arrow)
		end
	end
	ability.arrow_table = newTable
end

function arrow_explode(caster, ability, position, damage)
	local pfx2 = ParticleManager:CreateParticle("particles/roshpit/astral/crystal_arrow_explosion_magical.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx2, 0, position)
	ParticleManager:SetParticleControl(pfx2, 2, Vector(120, 70, 250))
	Timers:CreateTimer(3.5, function()
		ParticleManager:DestroyParticle(pfx2, false)
	end)
	damage = damage + OverflowProtectedGetAverageTrueAttackDamage(caster) * 0.05 * ability.r_2_level
	if caster:HasModifier("modifier_astral_glyph_7_1") then
		damage = damage * ASTRAL_RANGER_GLYPH_7_1_R_DAMAGE_MULT
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_backstab_jumping", {duration = 0.06})
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		local AOEDamage = damage
		for _, enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, AOEDamage, DAMAGE_TYPE_PURE, BASE_ABILITY_R, RPC_ELEMENT_ICE, RPC_ELEMENT_COSMOS)
		end
	end
end

function crystal_arrow_passive_think(event)
	local caster = event.caster
	local ability = event.ability
	local c_d_level = caster:GetRuneValue("r", 3)
	if c_d_level > 0 then
		local mult = 1 + math.floor(c_d_level / 60)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_crystal_arrow_freecast", {})
		local newStacks = math.min(caster:GetModifierStackCount("modifier_crystal_arrow_freecast", caster) + mult, c_d_level)
		caster:SetModifierStackCount("modifier_crystal_arrow_freecast", caster, newStacks)
	else
		caster:RemoveModifierByName("modifier_crystal_arrow_freecast")
	end
end
