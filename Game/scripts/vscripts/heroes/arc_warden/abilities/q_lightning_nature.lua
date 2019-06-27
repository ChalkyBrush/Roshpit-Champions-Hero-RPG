require('heroes/arc_warden/abilities/onibi')

function jex_activate_charged_mushroom(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]

	local tech_level = onibi_get_total_tech_level(caster, "lightning", "nature", "Q")
	ability.tech_level = tech_level
	CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_treant/treant_overgrowth_vines.vpcf", point, 3)

	ability.w_4_level = caster:GetRuneValue("w", 4)

	local shroom = CreateUnitByName("jex_charged_mushroom", point, false, caster, caster, caster:GetTeamNumber())
	shroom:FindAbilityByName("hero_summon_ai"):SetLevel(1)
	shroom:FindAbilityByName("hero_summon_ai"):ToggleAbility()
	shroom:SetModelScale(0.1)
	ability:ApplyDataDrivenModifier(caster, shroom, "modifier_jex_charged_mushroom", {})
	ability:ApplyDataDrivenModifier(caster, shroom, "modifier_jex_charged_mushroom_spawning", {duration = 0.3})

	local attack_damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * event.attack_mult_per_tech * tech_level
	local armor = caster:GetPhysicalArmorValue(false) * event.armor_mult_per_tech * tech_level
	local hp = caster:GetMaxHealth() * event.health_mult
	local life_duration = event.duration
	local q_4_level = caster:GetRuneValue("q", 4)
	life_duration = life_duration + event.q_4_additional_duration * q_4_level
	local max_chain_targets = event.chain_target_count * tech_level
	shroom:SetBaseMaxHealth(hp)
	shroom:SetMaxHealth(hp)
	shroom:SetHealth(hp)
	shroom:SetPhysicalArmorBaseValue(armor)
	shroom:SetBaseDamageMin(attack_damage)
	shroom:SetBaseDamageMax(attack_damage)
	if caster:HasModifier("modifier_jex_glyph_4_1") then
		ability:ApplyDataDrivenModifier(caster, shroom, "modifier_jex_glyph_4_1_as", {})
	end
	shroom.summoner = caster
	shroom:SetOwner(caster)
	shroom:SetControllableByPlayer(caster:GetPlayerID(), true)
	shroom.dieTime = life_duration
	shroom:AddAbility("ability_die_after_time_generic"):SetLevel(1)

	ability.max_chain_targets = max_chain_targets
	EmitSoundOn("Jex.Thundershroom.Spawn", shroom)
	EmitSoundOn("Jex.Thundershroom.SpawnSpark", shroom)
	Filters:CastSkillArguments(1, caster)
end

function jex_charged_mushroom_spawning(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local increase = 0.05 + (ability.tech_level / 1200)
	target:SetModelScale(target:GetModelScale() + increase)
end

function jex_thundershroom_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local attacker = event.attacker

	if not ability.chain_lightning_table then
		ability.chain_lightning_table = {}
	end
	local max_targets = ability.max_chain_targets
	local luck = RandomInt(1, 10)
	local chain = {}
	chain.index_hit = 0
	chain.enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false)
	local targets_to_hit = math.min(#chain.enemies, max_targets)
	local damage = OverflowProtectedGetAverageTrueAttackDamage(attacker)
	if ability.w_4_level then
		damage = damage + damage * (event.w_4_lightning_damage_increase / 100) * ability.w_4_level
	end
	--print("HELLO?")
	if luck <= 3 then
		for i = 1, targets_to_hit, 1 do
			Timers:CreateTimer((i - 1) * 0.15, function()
				local enemy = chain.enemies[i]
				if IsValidEntity(enemy) and enemy:IsAlive() then
					EmitSoundOn("Jex.Thundershroom.Lightning", enemy)
					Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_Q, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NATURE)
					local particleName = "particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf"
					local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_CUSTOMORIGIN, nil)
					local attach_unit_1 = attacker
					if i > 1 then
						attach_unit_1 = chain.enemies[i - 1]
					end
					ParticleManager:SetParticleControl(pfx, 0, attach_unit_1:GetAbsOrigin() + Vector(0, 0, attach_unit_1:GetBoundingMaxs().z + 80))
					ParticleManager:SetParticleControl(pfx, 1, enemy:GetAbsOrigin() + Vector(0, 0, enemy:GetBoundingMaxs().z + 100))
					Timers:CreateTimer(0.3, function()
						ParticleManager:DestroyParticle(pfx, false)
					end)
				end
			end)
		end
	end
end
