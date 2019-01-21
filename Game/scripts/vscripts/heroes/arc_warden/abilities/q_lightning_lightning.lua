require('heroes/arc_warden/abilities/onibi')

function jex_activate_q_lightning_lightning(event)
	local caster = event.caster
	local ability = event.ability

	local attack_damage_per_tech = event.attack_damage_per_tech
	local radius = event.radius
	local radius_per_tech = event.radius_per_tech
	local base_damage = event.base_damage
	local agility_added_to_base_damage = event.agility_added_to_base_damage

	local tech_level = onibi_get_total_tech_level(caster, "lightning", "lightning", "Q")
	local total_radius = radius + radius_per_tech*tech_level
	local damage = base_damage + agility_added_to_base_damage*caster:GetAgility() + (attack_damage_per_tech/100)*OverflowProtectedGetAverageTrueAttackDamage(caster)

	local q_4_level = caster:GetRuneValue("q", 4)
	if q_4_level > 0 then
		damage = damage + damage*(event.q_4_damage_increase_pct/100)*q_4_level
	end
	ability.damage = damage

    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, total_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
    if #enemies > 0 then
        
    end 
    ability.enemies = enemies
    ability.enemy_index = 1
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_jex_thunder_wrath_thinker", {duration = 0.6})
    EmitSoundOn("Jex.Grunt", caster)
    Filters:CastSkillArguments(1, caster)

	local aoePFX = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zeus_cloud.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(aoePFX, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(aoePFX, 1, Vector(total_radius, 10, total_radius))
	ParticleManager:SetParticleControl(aoePFX, 2, caster:GetAbsOrigin()+Vector(0,0,160))
	ParticleManager:SetParticleControl(aoePFX, 5, caster:GetAbsOrigin())
	Timers:CreateTimer(0.6, function()
		ParticleManager:DestroyParticle(aoePFX, false)
	end)
	EmitSoundOn("Jex.LightningWrath.Start", caster)
	StartAnimation(caster, {duration=0.6, activity=ACT_DOTA_OVERRIDE_ABILITY_4, rate=1.1})
	local pfx2 = CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_zeus/zeus_cloud_death.vpcf", caster, 3)
	ParticleManager:SetParticleControl(pfx2, 1, Vector(total_radius, 10, total_radius))
	ParticleManager:SetParticleControl(pfx2, 2, caster:GetAbsOrigin()+Vector(0,0,160))
	ParticleManager:SetParticleControl(pfx2, 5, caster:GetAbsOrigin())
end

function jex_lightning_lightning_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local enemies_to_hit = math.ceil(#ability.enemies/20)
	local hit = false
	for i = ability.enemy_index, ability.enemy_index + enemies_to_hit, 1 do
		local enemy = ability.enemies[i]
		if IsValidEntity(enemy) and enemy:IsAlive() then
			local pfx = ParticleManager:CreateParticle( "particles/econ/items/sven/sven_warcry_ti5/hyper_visor.vpcf", PATTACH_CUSTOMORIGIN, enemy )
			ParticleManager:SetParticleControl( pfx, 0, enemy:GetAbsOrigin())
			ParticleManager:SetParticleControl( pfx, 1, Vector(radius, 0, 0) )		
			ParticleManager:SetParticleControl( pfx, 3, Vector(0, 0, 0) )	
			Timers:CreateTimer(1.5, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
			
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, ability.damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
			hit = true
		end
	end
	if hit then
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Jex.LightningWrathGO", caster)
	end
	ability.enemy_index = ability.enemy_index + enemies_to_hit + 1
end

