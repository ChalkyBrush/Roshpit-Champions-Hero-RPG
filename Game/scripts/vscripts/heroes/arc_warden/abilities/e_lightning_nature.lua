require('heroes/arc_warden/abilities/onibi')

function jex_activate_thunder_blossom(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	point = WallPhysics:WallSearch(caster:GetAbsOrigin(), point, caster)
	local tech_level = onibi_get_total_tech_level(caster, "lightning", "nature", "E")
	ability.tech_level = tech_level
	CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_treant/treant_overgrowth_vines.vpcf", point, 3)

	local shroom = CreateUnitByName("jex_thunder_blossom", point, false, caster, caster, caster:GetTeamNumber())
	shroom:FindAbilityByName("hero_summon_ai"):SetLevel(1)
	shroom:FindAbilityByName("hero_summon_ai"):ToggleAbility()
	shroom:FindAbilityByName("thunder_blossom_teleport"):SetLevel(1)
	shroom:SetModelScale(0.1)
	local below = 0
	shroom:SetAbsOrigin(shroom:GetAbsOrigin()+Vector(0,0,below))

	ability:ApplyDataDrivenModifier(caster, shroom, "modifier_jex_thunder_blossom", {})
	ability:ApplyDataDrivenModifier(caster, shroom, "modifier_jex_thunder_blossom_spawning", {duration = 0.3})

	local attack_damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * event.attack_mult_per_tech * tech_level
	local armor = caster:GetPhysicalArmorValue()*event.armor_mult_per_tech*tech_level
	local hp = caster:GetMaxHealth()*event.health_mult
	local life_duration = math.max((event.duration_per_tech)*tech_level, 20)
	local max_chain_targets = event.chain_target_count*tech_level

	if tech_level > 0 then
		ability:ApplyDataDrivenModifier(caster, shroom, "modifier_jex_thunder_blossom_attack_range", {})
		shroom:SetModifierStackCount("modifier_jex_thunder_blossom_attack_range", caster, tech_level)
	end
	local q_4_level = caster:GetRuneValue("q", 4)
	if q_4_level > 0 then
		ability:ApplyDataDrivenModifier(caster, shroom, "modifier_thunder_blossom_magic_resistance", {})
		shroom:SetModifierStackCount("modifier_thunder_blossom_magic_resistance", caster, q_4_level)
	end
	if caster:HasModifier("modifier_jex_glyph_4_1") then
		ability:ApplyDataDrivenModifier(caster, shroom, "modifier_jex_glyph_4_1_as", {})
	end
	shroom:SetBaseMaxHealth(hp)
	shroom:SetMaxHealth(hp)
	shroom:SetHealth(hp)
	shroom:SetPhysicalArmorBaseValue(armor)
	shroom:SetBaseDamageMin(attack_damage)
	shroom:SetBaseDamageMax(attack_damage)

    shroom.summoner = caster
    shroom:SetOwner(caster)
    shroom:SetControllableByPlayer(caster:GetPlayerID(), true)
    shroom.dieTime = life_duration
    shroom:AddAbility("ability_die_after_time_generic"):SetLevel(1)

    ability.max_chain_targets = max_chain_targets
    EmitSoundOn("Jex.Thundershroom.Spawn", shroom)
    EmitSoundOn("Jex.Thundershroom.SpawnSpark", shroom)
	Filters:CastSkillArguments(3, caster)
end

function jex_thunder_blossom_spawning(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local increase = 0.05+(ability.tech_level/1200)
	target:SetModelScale(target:GetModelScale()+increase)
end

function thunder_blossom_teleport_unit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if target:GetEntityIndex() == caster.summoner:GetEntityIndex() then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_thunder_blossom_teleporting", {duration = 0.43})
		ability.teleport_interval = 14
		CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_treant/treant_overgrowth_vines.vpcf", target:GetAbsOrigin(), 2.4)
		target:AddNewModifier( target, nil, "modifier_black_portal_shrink", {duration = 0.5} )
		StartAnimation(target, {duration=1, activity=ACT_DOTA_ATTACK, rate=1.3})
		EmitSoundOn("Jex.ThunderBlossom.Teleport.Highlight", target)
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_electric_vortex.vpcf", PATTACH_CUSTOMORIGIN, nil)
		local position = caster:GetAbsOrigin()+RandomVector(RandomInt(0, 180))
		ParticleManager:SetParticleControl(pfx, 0, position+Vector(0,0,50))
		ParticleManager:SetParticleControl(pfx, 1, target:GetAbsOrigin()+Vector(0,0,50))
		Timers:CreateTimer(2.5, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_ATTACK, rate=1.8})
		-- ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		Timers:CreateTimer(0.14, function()
			EmitSoundOn("Jex.ThunderBlossom.TeleportStart", caster)
			local groundDiff = target:GetAbsOrigin().z - GetGroundHeight(target:GetAbsOrigin(), target)
			target:SetAbsOrigin(position+Vector(0,0,groundDiff))
			CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_treant/treant_overgrowth_vines.vpcf", position, 0.6)
			StartAnimation(target, {duration=1, activity=ACT_DOTA_TELEPORT_END, rate=0.8})
		end)
	else
		ability:EndCooldown()
	end

end

function thunder_blossom_teleporting_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	ability.teleport_interval = ability.teleport_interval - 1
	if ability.teleport_interval > 6 then
		target:SetAbsOrigin(target:GetAbsOrigin()-Vector(0,0,60))
	elseif ability.teleport_interval >= 1 then
		target:SetAbsOrigin(target:GetAbsOrigin()+Vector(0,0,60))
	end
	if ability.teleport_interval == 3 then
		EmitSoundOn("Jex.ThunderBlossom.Land", target)
	end
	if ability.teleport_interval == 1 then

		target:RemoveModifierByName("modifier_thunder_blossom_teleporting")

		Timers:CreateTimer(0.06, function()
			FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
			
			-- CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_treant/treant_overgrowth_vines.vpcf", target:GetAbsOrigin(), 1)
		end)
	end
end

function jex_thunderblossom_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local attacker = event.attacker


	local damage = OverflowProtectedGetAverageTrueAttackDamage(attacker)*(event.damage_pct_atk_power/100)
	local luck = RandomInt(1, 10)
	if luck <= 3 then
		local w_4_level = caster:GetRuneValue("w", 4)
		if w_4_level > 0 then
			damage = damage + damage*(event.w_4_damage_increase_pct/100)*w_4_level
		end
		Timers:CreateTimer(0.1, function()
			local enemy = target
			if IsValidEntity(enemy) and enemy:IsAlive() then
				EmitSoundOn("Jex.LightningWrathGO", enemy)
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 3, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NATURE)
				local pfx = ParticleManager:CreateParticle( "particles/econ/items/sven/sven_warcry_ti5/hyper_visor.vpcf", PATTACH_CUSTOMORIGIN, enemy )
				ParticleManager:SetParticleControl( pfx, 0, enemy:GetAbsOrigin())
				ParticleManager:SetParticleControl( pfx, 1, Vector(100, 0, 0) )		
				ParticleManager:SetParticleControl( pfx, 3, Vector(0, 0, 0) )	
				Timers:CreateTimer(1.5, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)
			end
		end)

	end
end