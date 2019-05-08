require('heroes/faceless_void/omniro_constants')
LinkLuaModifier("modifier_omniro_chrono_path_lua", "modifiers/omniro/modifier_omniro_chrono_path_lua", LUA_MODIFIER_MOTION_NONE)

function omniro_chrono_path_start(event)
	local ability = event.ability
	local caster = event.caster
	EmitSoundOn("Omniro.ChronoPath.Start", caster)

	local particleName = "particles/roshpit/omniro/chrono_path_sphere.vpcf"

	local chrono_base_radius = OMNIRO_CHRONO_PATH_RADIUS
	local chrono_duration = OMNIRO_CHRONO_PATH_DURATION
	StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_CAST_ABILITY_4, rate=1.6})
	local path_length = 5
	if caster:HasModifier("modifier_omniro_glyph_2_1") then
		path_length = path_length + OMNIRO_GLYPH_2_PATH_INCREASE
	end
	for i = 1, path_length, 1 do
		local randomColor = Vector(RandomInt(30, 255), RandomInt(30, 255), RandomInt(30, 255))/255
		local position = caster:GetAbsOrigin()+caster:GetForwardVector()*(chrono_base_radius*1.5)*i - caster:GetForwardVector()*100
		position = GetGroundPosition(position, caster)
		local dummy = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, caster:GetTeamNumber())
		dummy:SetAbsOrigin(position)
		dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
		dummy.pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(dummy.pfx, 0, position)
		ParticleManager:SetParticleControl(dummy.pfx, 1, Vector(chrono_base_radius, chrono_base_radius, chrono_base_radius))
		ParticleManager:SetParticleControl(dummy.pfx, 3, randomColor)
		ability:ApplyDataDrivenModifier(caster, dummy, "modifier_omniro_chrono_path_dummy", {duration = chrono_duration})
	end
	Filters:CastSkillArguments(3, caster)
end

function chrono_path_dummy_end(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	ParticleManager:DestroyParticle(target.pfx, false)
	UTIL_Remove(target)
end

function unit_in_chrono_path(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	if target:GetUnitName() == "npc_dota_hero_faceless_void" then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_omniro_in_chrono_path", {})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_omniro_in_chrono_path_flying_portion", {})
		caster:AddNewModifier(caster, ability, "modifier_omniro_chrono_path_lua", {})
	end
end

function unit_leave_chrono_path(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	target:RemoveModifierByName("modifier_omniro_in_chrono_path")
	target:RemoveModifierByName("modifier_omniro_chrono_path_lua")
	target:RemoveModifierByName("modifier_omniro_in_chrono_path_flying_portion")
end

function omniro_path_flying_think(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	local newPos = caster:GetAbsOrigin()+caster:GetForwardVector()*70
	local obstruction = WallPhysics:FindNearestObstruction(caster:GetAbsOrigin())
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPos, caster)
	if blockUnit then
		caster:SetAbsOrigin(caster:GetAbsOrigin()-caster:GetForwardVector()*60)
		WallPhysics:ClearSpaceForUnit(caster, caster:GetAbsOrigin())
		caster:RemoveModifierByName("modifier_omniro_in_chrono_path_flying_portion")
	end
end