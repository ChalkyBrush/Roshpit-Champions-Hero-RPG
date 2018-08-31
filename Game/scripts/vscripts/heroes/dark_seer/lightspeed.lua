LinkLuaModifier("modifier_zonik_lightspeed_cap", "modifiers/zonik/modifier_zonik_lightspeed_cap", LUA_MODIFIER_MOTION_NONE)

function lightspeed_precast(event)
	local caster = event.caster
	local ability = event.ability
	ability.e_4_level = Runes:GetTotalRuneLevelGeneric(caster, 4, 2)
end

function lightspeed_cast(event)
	local caster = event.caster
	local ability = event.ability
	local duration = event.duration
	
	ability.lastPos = caster:GetAbsOrigin()
	
	duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
	EmitSoundOn("Zonik.Lightspeed", caster)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_zonik_lightspeed", {duration = duration})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_zonik_lightspeed_flying_portion", {duration = duration})
	caster:AddNewModifier( caster, ability, "modifier_zonik_lightspeed_cap", {duration = duration} )

	local a_c_level = Runes:GetTotalRuneLevelGeneric(caster, 1, 2)
	local zonik_glyph_5_1_speed = 0
	if caster:HasModifier("modifier_zonik_glyph_5_1") then
		zonik_glyph_5_1_speed = 200 
	end
	if a_c_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_lightspeed_a_c", {duration = duration})
		caster:SetModifierStackCount("modifier_lightspeed_a_c", caster, a_c_level*6+zonik_glyph_5_1_speed)
	end
	ability.e_3_level = Runes:GetTotalRuneLevelGeneric(caster, 3, 2)
	Filters:CastSkillArguments(3, caster)

	if caster:HasModifier("modifier_zonik_glyph_5_a") then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 8000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				AddFOWViewer(caster:GetTeamNumber(), enemy:GetAbsOrigin(), 300, 5, false)
				-- ability:ApplyDataDrivenModifier(caster, enemy, "modifier_sages_eyes", {})
			end
		end 
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_savage_roar.vpcf", caster, 2)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_sages_eyes", {duration = 5})
	end
end

function lightspeed_start(event)
	local caster = event.caster
	local ability = event.ability

	caster:AddNewModifier( caster, ability, "modifier_zonik_lightspeed", {} )
	caster:AddNewModifier(caster, nil, "modifier_animation_translate", {translate="surge"})


	
end

function lightspeed_end(event)
	local caster = event.caster
	local ability = event.ability

	caster:RemoveModifierByName("modifier_zonik_lightspeed")
	caster:RemoveModifierByName("modifier_animation_translate")
	caster:RemoveModifierByName("modifier_zonik_lightspeed_cap")
end

function lightspeed_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster:HasModifier("modifier_zonik_lightspeed_flying_portion") then
		local newPos = caster:GetAbsOrigin()+caster:GetForwardVector()*100
		local obstruction = WallPhysics:FindNearestObstruction(caster:GetAbsOrigin())
		local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPos, caster)
		if blockUnit then
			caster:SetAbsOrigin(caster:GetAbsOrigin()-caster:GetForwardVector()*80)
			WallPhysics:ClearSpaceForUnit(caster, caster:GetAbsOrigin())
			caster:RemoveModifierByName("modifier_zonik_lightspeed_flying_portion")
		end
	end

	if not ability.distanceMoved then
		ability.distanceMoved = 0
	end
	if ability.lastPos then
		local distance = WallPhysics:GetDistance2d(ability.lastPos, caster:GetAbsOrigin())
		ability.distanceMoved = ability.distanceMoved + distance
		print(ability.distanceMoved)
		ability.lastPos = caster:GetAbsOrigin()
		if ability.distanceMoved >= 60 then
			local DistanceMult = (ability.distanceMoved-ability.distanceMoved%60)/60
			ability.distanceMoved = ability.distanceMoved%60
			local manaDrain = 0.0075*caster:GetMaxMana()*DistanceMult
			caster:ReduceMana(manaDrain)
			if caster:GetMana() < 1 then
				caster:RemoveModifierByName("modifier_zonik_lightspeed")
			end
			if not ability.remnantPrep then
				ability.remnantPrep = 0
			end
			ability.remnantPrep = ability.remnantPrep + 1*DistanceMult
			local remnantReady = 6
			if caster:HasModifier("modifier_zonik_glyph_6_1") and caster:HasModifier("modifier_zonik_speedball") then
				remnantReady = 2
			end
			if ability.remnantPrep >= remnantReady then
				ability.remnantPrep = ability.remnantPrep - remnantReady
				local b_c_level = Runes:GetTotalRuneLevelGeneric(caster, 2, 2)
				if b_c_level > 0 then
					if not ability.remnantTable then
						ability.remnantTable = {}
					end
					local pfx = ParticleManager:CreateParticle("particles/roshpit/zonik_remant_spirit_static_remnant.vpcf", PATTACH_WORLDORIGIN, caster)
					ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
					local angle = WallPhysics:vectorToAngle(caster:GetForwardVector())*2
					print("Angle"..angle)
					ParticleManager:SetParticleControl(pfx, 1, caster:GetForwardVector()*180)
					ParticleManager:SetParticleControl(pfx, 2, Vector(0.8, 0.8, 0.8))
					-- Timers:CreateTimer(2.5, function()
					-- 	ParticleManager:DestroyParticle(pfx, false)
					-- end)
					local remnantUnit = CreateUnitByName("npc_dummy_unit", caster:GetAbsOrigin(), false, nil, nil, caster:GetTeamNumber())
					remnantUnit:FindAbilityByName("dummy_unit"):SetLevel(1)
					remnantUnit.origCaster = caster
					remnantUnit.pfx = pfx
					EmitSoundOn("Zonik.Remnant.Plant", remnantUnit)
					local delay = 1
					local thinkerDuration = 4
					if caster:HasModifier("modifier_zonik_glyph_6_1") and caster:HasModifier("modifier_zonik_speedball") then
						delay = 0.1
						thinkerDuration = 0.1
					end
					Timers:CreateTimer(delay, function()
						remnantUnit:AddAbility("lightspeed_remnant_ability"):SetLevel(1)
						local remnantAbility = remnantUnit:FindAbilityByName("lightspeed_remnant_ability")
						remnantAbility:ApplyDataDrivenModifier(remnantUnit, remnantUnit, "modifier_lightspeed_b_c_thinker", {duration = thinkerDuration})

					end)
				end
			end
		end
	else
		ability.lastPos = caster:GetAbsOrigin()
	end
end

function remnant_triggered(event)
	local caster = event.caster
	local ability = event.ability
	caster:RemoveModifierByName("modifier_lightspeed_b_c_thinker")
end

function remnant_explode(event)
	local caster = event.caster.origCaster
	local ability = event.ability
	local remnant = event.caster
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), remnant:GetAbsOrigin(), nil, 320, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	local b_c_level = Runes:GetTotalRuneLevelGeneric(caster, 2, 2)
	local damage = caster:GetMana()*b_c_level*20
	if caster:HasModifier("modifier_zonik_glyph_6_1") and caster:HasModifier("modifier_zonik_speedball") then
		damage = damage*3
	end
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 3, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)
		end
	end 
	EmitSoundOn("Zonik.Remnant.Explode", event.caster)
	ParticleManager:DestroyParticle(event.caster.pfx, false)
	ParticleManager:ReleaseParticleIndex(event.caster.pfx)
	UTIL_Remove(event.caster)
end
