require('heroes/arc_warden/abilities/onibi')

function jex_activate_nature_e(event)
	local caster = event.caster
	local ability = event.ability

	local tech_level = onibi_get_total_tech_level(caster, "nature", "nature", "E")
	ability.tech_level = tech_level

	local radius = event.radius_base + event.radius_per_tech*tech_level
	ability.radius = radius
	if ability.plantsTable then
		for i = 1, #ability.plantsTable, 1 do
			UTIL_Remove(ability.plantsTable[i])
		end
		ability.plantsTable = nil
	end
	if ability.nature_aura_dummy then
		UTIL_Remove(ability.nature_aura_dummy)
		ability.nature_aura_dummy = nil
	end
	ability.plantsTable = {}
	local plantCount = radius/10
	local bushTable = {"maps/journey_assets/props/foliage/bush_journey_00.vmdl", "maps/journey_assets/props/foliage/bush_journey_01.vmdl", "maps/summer_assets/bushes/bush_dire_summer_01.vmdl", "maps/summer_assets/bushes/bush_dire_summer_02.vmdl", "models/props_nature/bush_spring_01.vmdl"}
	for i = 0, plantCount, 1 do
		local position = caster:GetAbsOrigin()+RandomVector(RandomInt(100, radius-50))
		position = GetGroundPosition(position, caster)
		if not GridNav:IsTraversable(position) then
			position = GetGroundPosition(caster:GetAbsOrigin()+RandomVector(RandomInt(0, 200)), caster)
		end
		local plant = SpawnEntityFromTableSynchronous("prop_dynamic", {origin = position})
  		plant:SetModel(bushTable[RandomInt(1, #bushTable)])
  		plant:SetAngles(0, RandomInt(0, 360), 0)
  		table.insert(ability.plantsTable, plant)
	end
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Jex.RootsCast", caster)
	local particleName = "particles/roshpit/jex/root_weave.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 2, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 6, Vector(radius, radius, radius))
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ability.pfx = nil		
	end

	ability.pfx = ParticleManager:CreateParticle("particles/roshpit/jex/natures_path_pfx_portrait.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(ability.pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(ability.pfx, 2, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(ability.pfx, 4, Vector(radius, 2, 1000))

	ability.nature_aura_dummy = CreateUnitByName("npc_flying_dummy_vision", caster:GetAbsOrigin(), false, nil, nil, caster:GetTeamNumber())
	ability:ApplyDataDrivenModifier(caster, ability.nature_aura_dummy, "modifier_natures_path_thinker", {})
	ability.nature_aura_dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
	EmitSoundOn("Jex.Grunt", caster)
	EmitSoundOn("Jex.NaturesPath.Start", caster)
	EmitSoundOnLocationForAllies(caster:GetAbsOrigin(), "Jex.NaturesPath.Start2", caster)
	Filters:CastSkillArguments(3, caster)

	local q_4_level = caster:GetRuneValue("q", 4)
	if q_4_level > 0 then
		local cd = ability:GetCooldownTimeRemaining()
		local new_cd = cd - event.q_4_cooldown_reduce*q_4_level
		ability:EndCooldown()
		ability:StartCooldown(new_cd)
	end
end

function nature_path_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	local allies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, ability.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	for i = 1, #allies, 1 do
		if allies[i]:GetEntityIndex() == caster:GetEntityIndex() then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_natures_path_base_flying_buff", {})
		end
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_natures_path_master_buff", {})
	end
end

function path_master_buff_create(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	ability:ApplyDataDrivenModifier(caster, target, "modifier_natures_path_health_regen", {})
	target:SetModifierStackCount("modifier_natures_path_health_regen", caster, ability.tech_level)
end

function path_master_buff_destroy(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	target:RemoveModifierByName("modifier_natures_path_health_regen")
	target:SetModifierStackCount("modifier_natures_path_health_regen", caster, ability.tech_level)
	target:RemoveModifierByName("modifier_natures_path_base_flying_buff")
end

function nature_path_master_buff_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	local distance = WallPhysics:GetDistance2d(target:GetAbsOrigin(), ability.nature_aura_dummy:GetAbsOrigin())
	if ability then
		if distance > ability.radius then
			target:RemoveModifierByName("modifier_natures_path_master_buff")
		end
	else
		target:RemoveModifierByName("modifier_natures_path_master_buff")
	end
end

function path_flying_think(event)
	local caster = event.caster
	local newPos = caster:GetAbsOrigin()+caster:GetForwardVector()*70
	local obstruction = WallPhysics:FindNearestObstruction(caster:GetAbsOrigin())
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPos, caster)
	if blockUnit then
		caster:SetAbsOrigin(caster:GetAbsOrigin()-caster:GetForwardVector()*60)
		WallPhysics:ClearSpaceForUnit(caster, caster:GetAbsOrigin())
		caster:RemoveModifierByName("modifier_natures_path_base_flying_buff")
	end
end