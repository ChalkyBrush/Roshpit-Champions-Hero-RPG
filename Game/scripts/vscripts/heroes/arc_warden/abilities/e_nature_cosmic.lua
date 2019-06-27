require('heroes/arc_warden/abilities/onibi')

function jex_cast_portal(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]

	local tech_level = onibi_get_total_tech_level(caster, "nature", "cosmic", "E")
	ability.tech_level = tech_level

	point = WallPhysics:WallSearch(caster:GetAbsOrigin(), point, caster)
	if not ability.portalTable then
		ability.portalTable = {}
	end
	local particleName = "particles/roshpit/jex/earths_gate.vpcf"
	local portalPFX = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	local portalPosition = point
	ParticleManager:SetParticleControl(portalPFX, 0, portalPosition)
	-- ParticleManager:SetParticleControl(portalPFX, 1, Vector(5,5,5))
	local max_portals = event.max_portals_base + event.max_portals_per_tech * tech_level
	local portal = {}
	-- portal = CustomAbilities:QuickAttachThinker(ability, caster, point, "modifier_river_of_souls_thinker", {duration = 18000})
	portal.pfx = portalPFX
	portal.position = portalPosition
	portal.active = true
	portal.aura_dummy = CreateUnitByName("npc_flying_dummy_vision", point, false, nil, nil, caster:GetTeamNumber())
	ability:ApplyDataDrivenModifier(caster, portal.aura_dummy, "modifier_jex_portal_aura", {})
	portal.aura_dummy:FindAbilityByName("dummy_unit"):SetLevel(1)

	EmitSoundOn("Jex.Roots", caster)

	EmitSoundOnLocationWithCaster(portalPosition, "Jex.EarthsGate.Create", caster)
	GridNav:DestroyTreesAroundPoint(portalPosition, 220, false)
	local beamPFX = ParticleManager:CreateParticle("particles/roshpit/jex/portal_cast_beams_beams.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(beamPFX, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(beamPFX, 1, portalPosition)
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(beamPFX, false)
		ParticleManager:ReleaseParticleIndex(beamPFX)
	end)
	table.insert(ability.portalTable, portal)
	if #ability.portalTable > max_portals then
		local new_table = {}
		destroy_portal(ability, ability.portalTable[1])
		for i = 2, #ability.portalTable, 1 do
			table.insert(new_table, ability.portalTable[i])
		end
		ability.portalTable = new_table
	end
	ability.q_4_level = caster:GetRuneValue("q", 4)
	ability.e_4_level = caster:GetRuneValue("e", 4)
	Filters:CastSkillArguments(3, caster)

end

function jex_portal_inside(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if ability.tech_level > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_jex_portal_inside_health_regen", {})
		target:SetModifierStackCount("modifier_jex_portal_inside_health_regen", caster, ability.tech_level)
	end
	if target:GetEntityIndex() == caster:GetEntityIndex() then
		if ability.q_4_level > 0 then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_jex_portal_armor", {})
			target:SetModifierStackCount("modifier_jex_portal_armor", caster, ability.q_4_level)
		end
		if ability.e_4_level > 0 then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_jex_portal_mana_regen", {})
			target:SetModifierStackCount("modifier_jex_portal_mana_regen", caster, ability.e_4_level)
		end
	end
end

function destroy_portal(ability, portal)
	ParticleManager:DestroyParticle(portal.pfx, false)
	portal.active = false
	UTIL_Remove(portal.aura_dummy)
end

function jex_portal_teleport_effect_end(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_meepo/meepo_poof_end.vpcf", target:GetAbsOrigin(), 3)
	FindClearSpaceForUnit(target, ability.teleporting_to, false)
	CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_meepo/meepo_poof_end.vpcf", target:GetAbsOrigin(), 3)
	EmitSoundOn("Jex.ThunderBlossom.Land", target)
	StartAnimation(target, {duration = 0.6, activity = ACT_DOTA_TELEPORT_END, rate = 1.1})
end
