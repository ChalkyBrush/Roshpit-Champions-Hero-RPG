require('heroes/invoker/aspects')

function begin_deity(event)
	local caster = event.caster
	local ability = event.ability

	local summonPoint = event.target_points[1]
	EmitSoundOn("invoker_invo_win_01", caster)
	EmitSoundOn("invoker_invo_win_01", caster)
	StartAnimation(caster, {duration = 0.75, activity = ACT_DOTA_CAST_TORNADO, rate = 1.0})
	ability.r_1_level = caster:GetRuneValue("r", 1)
	ability.r_2_level = caster:GetRuneValue("r", 2)
	ability.r_3_level = caster:GetRuneValue("r", 3)
	ability.r_4_level = caster:GetRuneValue("r", 4)
	if caster.deity then
		if IsValidEntity(caster.deity) then
			if caster.deity:IsAlive() then
				caster.deity:ForceKill(false)
			end
		end
	end

	local summon = CreateUnitByName("conjuror_elemental_deity_summon", summonPoint, false, caster, caster, caster:GetTeamNumber())
	Timers:CreateTimer(0.05, function()
		StartAnimation(summon, {duration = 1.45, activity = ACT_DOTA_SPAWN, rate = 0.7})
	end)
	local aspectAbility = summon:FindAbilityByName("aspect_abilities")
	aspectAbility:SetLevel(1)
	aspectAbility:ToggleAbility()
	summon:SetAcquisitionRange(1500)
	summon:SetRenderColor(180, 80, 215)
	ability:ApplyDataDrivenModifier(caster, summon, "modifier_deity_appear", {duration = 1})
	caster.deity = summon
	caster.deity.owner = caster:GetPlayerOwnerID()
	caster.deity:SetOwner(caster)
	caster.deity:SetControllableByPlayer(caster:GetPlayerID(), true)
	caster.deity.conjuror = caster
	particleName = "particles/addons_gameplay/pit_lava_blast.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(particle1, 0, summonPoint - Vector(0, 0, 220))
	ParticleManager:SetParticleControl(particle1, 1, summonPoint - Vector(0, 0, 220))
	Timers:CreateTimer(10, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
	EmitSoundOn("Conjuror.ElementalDeity.Summon", summon)
	EmitSoundOn("Conjuror.DeityCast", caster)
	if ability.r_1_level > 0 then
		summon.r_1_level = ability.r_1_level
		summon:AddAbility("conjuror_deity_a_d"):SetLevel(1)
	end
	if ability.r_2_level > 0 then
		summon.r_2_level = ability.r_2_level
		summon:AddAbility("conjuror_deity_terra_blast"):SetLevel(1)
	end
	if ability.r_3_level > 0 then
		summon.r_3_level = ability.r_3_level
		summon:AddAbility("call_of_elements"):SetLevel(ability:GetLevel())
	end
	if ability.r_4_level > 0 then
		summon.r_4_level = ability.r_4_level
		summon:AddAbility("conjuror_deity_shadow_shield"):SetLevel(ability:GetLevel())
	end

	local attack_mult = event.attack_damage_mult
	local armor_mult = event.armor_mult
	local health_mult = event.health_mult

	local dmg = OverflowProtectedGetAverageTrueAttackDamage(caster) * attack_mult
	dmg = math.max(1, dmg)
	dmg = math.min(dmg, 2000000000)

	ability:ApplyDataDrivenModifier(caster, summon, "modifier_deity_green_damage", {duration = -1})
	summon:SetModifierStackCount("modifier_deity_green_damage", ability, dmg)

	Filters:SetAttackDamage(summon, 1)
	summon.elemental_deity = true
	summon:SetPhysicalArmorBaseValue(caster:GetPhysicalArmorValue(false) * armor_mult)
	local health = math.floor(caster:GetMaxHealth() * health_mult)
	summon:SetMaxHealth(health)
	summon:SetBaseMaxHealth(health)
	summon:SetHealth(health)
	summon:Heal(health, summon)
	common_aspect_effects(caster, ability, summon)
	summon:AddAbility("fire_temple_steadfast"):SetLevel(3)
	Filters:CastSkillArguments(4, caster)
end

function deity_a_d_attack_land(event)
	local attacker = event.attacker
	local target = event.target
	local damage = event.attack_damage
	local caster = event.caster
	EmitSoundOn("Conjuror.Deity.Attack", attacker)

	local fv = ((target:GetAbsOrigin() - attacker:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	local damage = damage * 0.08 * attacker.r_1_level
	-- CustomAbilities:QuickAttachParticle("particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_weapon/kunkka_spell_tidebringer_fxset.vpcf", attacker, 2)
	local pfx = ParticleManager:CreateParticle("particle/roshpit/conjuror/deity_a_d.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin() + fv * 200, true)
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:ReleaseParticleIndex(pfx)
	end)

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			-- Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, 2)
			-- local targetAngle = ((enemy:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
			-- local angleDifferential = math.acos(fv:Dot(targetAngle, fv))
			-- if angleDifferential < math.pi/2 then
			Filters:TakeArgumentsAndApplyDamage(enemy, caster.conjuror, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_R, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
			-- ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL})
			-- end
		end
	end
end

function terra_blast_start(event)
	local ability = event.ability
	local caster = event.caster
	local point = event.target_points[1]

	local attacker = event.attacker
	local length = math.max(WallPhysics:GetDistance(caster:GetAbsOrigin() * Vector(1, 1, 0), point * Vector(1, 1, 0)) / 190, 1) + 2
	local fv = (point * Vector(1, 1, 0) - caster:GetAbsOrigin() * Vector(1, 1, 0)):Normalized()
	local startPosition = caster:GetAbsOrigin()
	local damage = caster.r_2_level * OverflowProtectedGetAverageTrueAttackDamage(caster) * 0.1
	local stun_duration = caster.r_2_level * 0.05
	for i = 1, math.floor(length), 1 do
		Timers:CreateTimer(0.1 * (i - 1), function()
			local position = startPosition + fv * i * 200
			terra_blast_explosion(caster, position, damage, 200, ability, stun_duration)
		end)
	end
end

function terra_blast_explosion(caster, position, damage, explosionAOE, ability, stun_duration)
	local particleName = "particles/roshpit/conjuror/deity_terra_blast.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(particle1, 0, position)
	ParticleManager:SetParticleControl(particle1, 1, Vector(explosionAOE, 5, explosionAOE * 2))
	Timers:CreateTimer(4, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
	EmitSoundOnLocationWithCaster(position, "Conjuror.Deity.TerraBlast", caster)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, explosionAOE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster.conjuror, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_R, RPC_ELEMENT_EARTH, RPC_ELEMENT_NONE)
			Filters:ApplyStun(caster.conjuror, stun_duration, enemy)
		end
	end
end

function shadow_shield_start(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	EmitSoundOn("Conjuror.Deity.ShadowShield", target)
	local duration = caster.r_4_level * 0.3
	ability:ApplyDataDrivenModifier(caster, target, "modifier_deity_shadow_shield", {duration = duration})
end
