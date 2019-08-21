warlord_cataclysm_shaker = class({})

function warlord_cataclysm_shaker:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
	local point_of_cast = ability:GetPointOfCast()
	local fv = ability:GetDirectionVector()

	local distance = ability:GetSpecialValueFor("distance")

	local stun_duration = ability:GetSpecialValueFor("stun_duration")
	local damage = ability:GetSpecialValueFor("damage")

	local endPoint = ability:GetTerminalPosition()

	local distance_of_cast = WallPhysics:GetDistance2d(point_of_cast, endPoint)
	if distance_of_cast > distance then
		endPoint = point_of_cast + fv*distance
	end

	local particle = "particles/econ/items/earthshaker/earthshaker_ti9/earthshaker_fissure_ti9.vpcf"
	local pfx = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, point_of_cast)
	ParticleManager:SetParticleControl(pfx, 1, endPoint)
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)

	local distance_between_rocks = 128
	local num_obstructions = math.ceil(distance/distance_between_rocks)

	local blockers = {}
	for i = 0, num_obstructions, 1 do
		local pso_origin = point_of_cast + fv*distance_between_rocks*i
		local blocker = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = pso_origin, Name ="wallObstruction"})
		print(blocker:GetAbsOrigin())
		table.insert(blockers, blocker)
	end

	ScreenShake(point_of_cast, 260, 0.2, 0.2, 2500, 0, true)

	EmitSoundOn("Warlord.Cataclysm.Swoop", caster)
	Filters:CastSkillArguments(1, caster)	   

	EmitSoundOnLocationWithCaster(point_of_cast, "Warlord.Cataclysm.Impact", caster) 
	EmitSoundOnLocationWithCaster(endPoint, "Warlord.Cataclysm.Highlight", caster)
	EmitSoundOn("Warlord.Cataclysm.VO", caster)
	Timers:CreateTimer(4, function()
		print("REMOVE BLOCKERS")
		for i = 1, #blockers, 1 do
			UTIL_Remove(blockers[i])
		end
	end)

	local enemies = FindUnitsInLine(caster:GetTeamNumber(), point_of_cast, endPoint, nil, 260, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0)
	for _, enemy in pairs(enemies) do
		Filters:ApplyStun(caster, stun_duration, enemy)
		Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 1)
	end
end