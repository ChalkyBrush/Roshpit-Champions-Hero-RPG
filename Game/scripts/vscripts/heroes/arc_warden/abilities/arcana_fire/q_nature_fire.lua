require('heroes/arc_warden/abilities/onibi')
require('heroes/arc_warden/jex_constants')

function jex_activate_q_nature_fire(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]

	local tech_level = onibi_get_total_tech_level(caster, "nature", "fire", "Q")
	local tree = CreateUnitByName("jex_fever_tree", point, false, caster, caster, caster:GetTeamNumber())
	ability:ApplyDataDrivenModifier(caster, tree, "modifier_jex_fire_tree", {})
	tree.pfx = ParticleManager:CreateParticle("particles/econ/items/treant_protector/ti7_shoulder/treant_ti7_crimson_livingarmor.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(tree.pfx, 0, tree:GetAbsOrigin())
	ParticleManager:SetParticleControl(tree.pfx, 1, tree:GetAbsOrigin())
	tree:SetModelScale(0.5)
	CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_furion/furion_sprout.vpcf", tree:GetAbsOrigin(), 3)
	ability.tech_level = tech_level
	local q_4_level = caster:GetRuneValue("q", 4)
	local life_duration = event.duration + event.q_4_duration_increase*q_4_level
	local max_health = event.health_base + event.health_per_tech*tech_level
	tree:SetBaseMaxHealth(max_health)
	tree:SetMaxHealth(max_health)
	tree:SetHealth(max_health)
    tree.summoner = caster
    tree:SetOwner(caster)
    tree:SetRenderColor(125, 70, 30)
    tree:SetDayTimeVisionRange(700)
    tree:SetNightTimeVisionRange(700)
    tree:SetControllableByPlayer(caster:GetPlayerID(), true)
    tree.dieTime = life_duration
    tree:AddAbility("ability_die_after_time_generic"):SetLevel(1)
    CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_phoenix/phoenix_fire_spirit_ground.vpcf", point, 3)
    EmitSoundOn("Jex.FireTree.Summon", tree)
end

function jex_fire_tree_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
    EmitSoundOn("Jex.FireTree.TauntWave", target)
    local position = target:GetAbsOrigin()
    local particleName = "particles/units/heroes/hero_faceless_void/redrock_timedialate.vpcf"
    local particle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
    local radius = 450
    ParticleManager:SetParticleControl(particle, 0, position)
    ParticleManager:SetParticleControl(particle, 1, Vector(radius,radius,radius))
    Timers:CreateTimer(2, function()
        ParticleManager:DestroyParticle(particle, false)
    end)
    local taunt_duration = event.taunt_duration_base + event.taunt_duration_per_tech*ability.tech_level
    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
    if #enemies > 0 then
        for _,enemy in pairs(enemies) do
            if enemy:GetAttackCapability() == DOTA_UNIT_CAP_NO_ATTACK then
            else
                ability:ApplyDataDrivenModifier(caster, enemy, "modifier_jex_fire_tree_taunt", {duration = taunt_duration})
                enemy:MoveToTargetToAttack(target)
            end
        end
    end
    local w_4_level = caster:GetRuneValue("w", 4)
    if w_4_level > 0 then
	    local allies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	    if #allies > 0 then
	        for _,ally in pairs(allies) do
	        	if ally == caster then
		            ability:ApplyDataDrivenModifier(caster, ally, "modifier_jex_fire_nature_q_attack_power", {duration = taunt_duration})
		            ally:SetModifierStackCount("modifier_jex_fire_nature_q_attack_power", caster, w_4_level)
		        end
	        end
	    end  
	end
end

function jex_fire_tree_die(event)
	local tree = event.unit
	ParticleManager:DestroyParticle(tree.pfx, false)
	ParticleManager:ReleaseParticleIndex(tree.pfx)
	Timers:CreateTimer(0.03, function()
		CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_furion/furion_sprout.vpcf", tree:GetAbsOrigin(), 3)
		CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_phoenix/phoenix_fire_spirit_ground.vpcf", tree:GetAbsOrigin(), 3)
		EmitSoundOn("Jex.FireTree.Unsummon", tree)
		UTIL_Remove(tree)
	end)
end