warlord_cataclysm_shaker = class({})

function warlord_cataclysm_shaker:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
	local point_of_cast = ability:GetPointOfCast()
	local fv = ability:GetDirectionVector()

	local distance = ability:GetSpecialValueFor("distance")

	local stun_duration = ability:GetSpecialValueFor("stun_duration")
	local damage = ability:GetSpecialValueFor("damage")
	local str_mult = ability:GetSpecialValueFor("str_mult")

	damage = damage + caster:GetStrength()*str_mult

	local endPoint = ability:GetTerminalPosition()

	local distance_of_cast = WallPhysics:GetDistance2d(point_of_cast, endPoint)
	if distance_of_cast > distance then
		endPoint = point_of_cast + fv*distance
	end

	local particle = "particles/econ/items/earthshaker/earthshaker_ti9/earthshaker_fissure_ti9.vpcf"
	local pfx = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, point_of_cast)
	ParticleManager:SetParticleControl(pfx, 1, endPoint)
	ParticleManager:SetParticleControl(pfx, 2, Vector(7,7,7))

	local distance_between_rocks = 128
	local num_obstructions = math.ceil(distance_of_cast/distance_between_rocks) - 1

	local blockers = {}
	for i = 0, num_obstructions, 1 do
		local pso_origin = GetGroundPosition(point_of_cast + fv*distance_between_rocks*i, caster)
		-- local blocker = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = pso_origin, Name ="wallObstruction"})
	 	local dummy = CreateUnitByName("npc_dummy_unit", pso_origin, false, nil, nil, caster:GetTeamNumber())
	 	dummy:SetAbsOrigin(pso_origin)
		dummy:RemoveAbility("dummy_unit")
		dummy:SetHullRadius(64)
		dummy:AddAbility("dummy_unit_with_collision"):SetLevel(1)
		-- "dummy_unit_with_collision"
		table.insert(blockers, dummy)
	end

	ScreenShake(point_of_cast, 260, 0.2, 0.2, 2500, 0, true)

	EmitSoundOn("Warlord.Cataclysm.Swoop", caster)
	   

	EmitSoundOnLocationWithCaster(point_of_cast, "Warlord.Cataclysm.Impact", caster) 
	EmitSoundOnLocationWithCaster(endPoint, "Warlord.Cataclysm.Highlight", caster)
	EmitSoundOn("Warlord.Cataclysm.VO", caster)
	Timers:CreateTimer(7, function()
		print("REMOVE BLOCKERS")
		for i = 1, #blockers, 1 do
			UTIL_Remove(blockers[i])
		end
		ParticleManager:DestroyParticle(pfx, false)
	end)
	local units_in_fissure = FindUnitsInLine(caster:GetTeamNumber(), point_of_cast, endPoint, nil, 260, DOTA_UNIT_TARGET_TEAM_ENEMY+DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0)
	for _, unit in pairs(units_in_fissure) do
		if unit:GetTeamNumber() ~= caster:GetTeamNumber() then
			Filters:ApplyStun(caster, stun_duration, unit)
			Filters:TakeArgumentsAndApplyDamage(unit, caster, damage, DAMAGE_TYPE_MAGICAL, RPC_ELEMENT_EARTH, RPC_ELEMENT_DRAGON, 1)
		end
		Timers:CreateTimer(0.03, function()
			FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), false)
		end)
	end
	Filters:CastSkillArguments(1, caster)
end