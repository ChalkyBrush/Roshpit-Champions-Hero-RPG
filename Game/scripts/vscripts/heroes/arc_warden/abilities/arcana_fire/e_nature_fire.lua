require('heroes/arc_warden/abilities/onibi')

function jex_activate_cinderbark(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]

	ability.tech_level = onibi_get_total_tech_level(caster, "fire", "nature", "Q")
	CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_treant/treant_overgrowth_vines.vpcf", point, 3)
	CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_phoenix/phoenix_fire_spirit_ground.vpcf", point, 3)
	
	ability.w_4_level = caster:GetRuneValue("w", 4)
	if ability.treant then
		if IsValidEntity(ability.treant) and ability.treant:IsAlive() then
			ability.treant:ForceKill(false)
		end
	end
	local shroom = CreateUnitByName("jex_cinderbark_treant", point, false, caster, caster, caster:GetTeamNumber())
	shroom:FindAbilityByName("hero_summon_ai"):SetLevel(1)
	shroom:FindAbilityByName("hero_summon_ai"):ToggleAbility()
	shroom:FindAbilityByName("jex_cinderbark_teleport"):SetLevel(1)
	shroom:FindAbilityByName("cinderbark_detonate"):SetLevel(1)
	shroom:SetModelScale(0.1)
	ability:ApplyDataDrivenModifier(caster, shroom, "modifier_jex_cinderbark", {})
	ability:ApplyDataDrivenModifier(caster, shroom, "modifier_jex_charged_mushroom_spawning", {duration = 0.3})

	local attack_damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * event.attack_mult_per_tech * ability.tech_level
	local armor = caster:GetPhysicalArmorValue()*event.armor_mult_per_tech * ability.tech_level
	local hp = caster:GetMaxHealth()*event.max_health_mult


	shroom:SetBaseMaxHealth(hp)
	shroom:SetMaxHealth(hp)
	shroom:SetHealth(hp)
	Events:ColorWearablesAndBase(shroom, Vector(255,190,120))
	shroom:SetPhysicalArmorBaseValue(armor)
	shroom:SetBaseDamageMin(attack_damage)
	shroom:SetBaseDamageMax(attack_damage)
	if caster:HasModifier("modifier_jex_glyph_4_1") then
		ability:ApplyDataDrivenModifier(caster, shroom, "modifier_jex_glyph_4_1_as", {})
	end
    shroom.summoner = caster
    shroom:SetOwner(caster)
    shroom:SetControllableByPlayer(caster:GetPlayerID(), true)

    ability.treant = shroom

    EmitSoundOn("Jex.Thundershroom.Spawn", shroom)
    EmitSoundOn("Jex.Cinderbark.Summon", shroom)
	Filters:CastSkillArguments(3, caster)
	local q_4_level = caster:GetRuneValue("q", 4)
	if q_4_level > 0 then
		local cd = ability:GetCooldownTimeRemaining()
		local new_cd = cd - event.q_4_cooldown_reduction*q_4_level
		Filters:ReduceECooldown(caster, ability, new_cd, true)
	end
	shroom.manaDrain = 0
end

function jex_cinderbark_base_thinking(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if target:HasModifier("modifier_jex_charged_mushroom_spawning") then
		return false
	end
	if target:IsAlive() then
		target.manaDrain = target.manaDrain + event.mana_cost_increase_per_second
		local maxScale = 1.5
		local newScale = math.min(maxScale, target:GetModelScale() + 0.03)
		target:SetModelScale(newScale)
		local attack_damage = OverflowProtectedGetAverageTrueAttackDamage(target) + event.attack_gain_per_second
		target:SetBaseDamageMin(attack_damage)
		target:SetBaseDamageMax(attack_damage)
		if caster:GetMana() < target.manaDrain then
			target:ForceKill(false)
		end
		caster:ReduceMana(target.manaDrain)
	end
end

function jex_charged_mushroom_spawning(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local increase = 0.04
	target:SetModelScale(target:GetModelScale()+increase)
end

function jex_cinderbark_death(event)
	local unit = event.unit
	local caster = event.caster
	local ability = event.ability
	local explosion_attack_damage_per_tech = event.explosion_attack_damage_per_tech
	local pfx = CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_huskar/huskar_inner_fire.vpcf", unit:GetAbsOrigin(), 4)
	ParticleManager:SetParticleControl(pfx, 3, unit:GetAbsOrigin())
	EmitSoundOn("Jex.LivingBomb.Explode", unit)
	local w_4_level = caster:GetRuneValue("w", 4)
	local radius = 600
	local damage = OverflowProtectedGetAverageTrueAttackDamage(unit)*(explosion_attack_damage_per_tech/100)*ability.tech_level
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), unit:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_FIRE, RPC_ELEMENT_NATURE)
			if w_4_level > 0 then
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_cinderbark_burning", {duration = 5})
				ability.burn_damage = damage*w_4_level*(event.w_4_burn_damage_explosion_damage/100)
			end
		end
	end 
	GridNav:DestroyTreesAroundPoint(unit:GetAbsOrigin(), radius, false)
end

function fire_aspect_detonate(event)
	event.caster:ForceKill(false)
end


function jex_cinderbark_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local attacker = event.attacker

	local particleName = "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf"
	local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, Events.GameMaster )
	ParticleManager:SetParticleControl( particle1, 0, target:GetAbsOrigin() )
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle( particle1, false )
	end)
	local explosive_attack_damage_per_tech = event.explosive_attack_damage_per_tech
	EmitSoundOn("Jex.Cinderbark.Attack", target)
	local damage = OverflowProtectedGetAverageTrueAttackDamage(attacker)*(explosive_attack_damage_per_tech/100)*ability.tech_level
	local radius = 240
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_FIRE, RPC_ELEMENT_NATURE)
		end
	end 
end

function jex_cinderbark_teleport_unit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if target:GetEntityIndex() == caster.summoner:GetEntityIndex() then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_cinderbark_teleporting", {duration = 0.43})
		ability.teleport_interval = 14
		CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_treant/treant_overgrowth_vines.vpcf", target:GetAbsOrigin(), 2.4)
		CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_phoenix/phoenix_fire_spirit_ground.vpcf", target:GetAbsOrigin(), 2.4)

		target:AddNewModifier( target, nil, "modifier_black_portal_shrink", {duration = 0.5} )
		StartAnimation(target, {duration=1, activity=ACT_DOTA_ATTACK, rate=1.3})
		EmitSoundOn("Jex.Cinderbark.Summon", target)
		-- local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_electric_vortex.vpcf", PATTACH_CUSTOMORIGIN, nil)
		local position = caster:GetAbsOrigin()+RandomVector(RandomInt(0, 180))
		-- ParticleManager:SetParticleControl(pfx, 0, position+Vector(0,0,50))
		-- ParticleManager:SetParticleControl(pfx, 1, target:GetAbsOrigin()+Vector(0,0,50))
		-- Timers:CreateTimer(2.5, function()
		-- 	ParticleManager:DestroyParticle(pfx, false)
		-- end)
		StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_ATTACK, rate=1.8})
		-- ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		Timers:CreateTimer(0.14, function()
			-- EmitSoundOn("Jex.ThunderBlossom.TeleportStart", caster)
			local groundDiff = target:GetAbsOrigin().z - GetGroundHeight(target:GetAbsOrigin(), target)
			target:SetAbsOrigin(position+Vector(0,0,groundDiff))
			CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_treant/treant_overgrowth_vines.vpcf", position, 0.6)
			CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_phoenix/phoenix_fire_spirit_ground.vpcf", position, 0.6)
			StartAnimation(target, {duration=1, activity=ACT_DOTA_TELEPORT_END, rate=0.8})
		end)
	else
		ability:EndCooldown()
	end

end

function cinderbark_teleporting_think(event)
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
		end)
	end
end

function cinderbark_burn_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = ability.burn_damage
	Filters:ApplyDotDamage(caster, ability, target, damage, DAMAGE_TYPE_MAGICAL, 3, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
end