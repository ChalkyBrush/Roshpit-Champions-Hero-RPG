require('heroes/arc_warden/abilities/onibi')

function jex_ion_cannon_phase(event)
	local caster = event.caster
	StartAnimation(caster, {duration = 0.4, activity = ACT_DOTA_CAST_ABILITY_1, rate = 1.8})
	EmitSoundOn("Jex.Thunderleaf.Throw", caster)
end

function jex_ion_cannon_throw(event)
	local caster = event.caster
	local ability = event.ability
	if not ability.projectiles_table then
		ability.projectiles_table = {}
	end
	local target = event.target
	ability.tech_level = onibi_get_total_tech_level(caster, "lightning", "cosmic", "W")
	ability.damage = event.base_damage + (event.damage_attack_power_per_tech / 100) * ability.tech_level * OverflowProtectedGetAverageTrueAttackDamage(caster) + event.strength_added_to_damage * caster:GetStrength()
	local w_4_level = caster:GetRuneValue("w", 4)
	if w_4_level > 0 then
		ability.damage = ability.damage + ability.damage * (event.w_4_damage_increase_pct / 100) * w_4_level
	end
	ability.e_4_level = caster:GetRuneValue("e", 4)
	local splits = Runes:Procs(ability.tech_level, event.split_chance_per_tech, 1)
	new_ion_cannon_projectile(caster, ability, caster, target, splits)

	Filters:CastSkillArguments(2, caster)
end

function new_ion_cannon_projectile(caster, ability, target1, target2, splits)
	if splits <= -1 then
		return false
	end
	local projectileName = "particles/roshpit/jex/ion_cannon.vpcf"
	local newProjectile = {}
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_lightning_cosmic_w_main_thinker", {})
	if target1 == caster then
		newProjectile.position = caster:GetAttachmentOrigin(3)
	else
		newProjectile.position = target1:GetAbsOrigin() + Vector(0, 0, 80)
	end
	newProjectile.speed = 1500
	newProjectile.active = true
	newProjectile.target_position = target2:GetAbsOrigin() + Vector(0, 0, 80)
	newProjectile.target = target2
	local pfx = ParticleManager:CreateParticle(projectileName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, newProjectile.position)
	ParticleManager:SetParticleControl(pfx, 1, newProjectile.target_position)
	ParticleManager:SetParticleControl(pfx, 2, Vector(newProjectile.speed, newProjectile.speed, newProjectile.speed))

	newProjectile.pfx = pfx
	table.insert(ability.projectiles_table, newProjectile)
	newProjectile.splits = splits
	EmitSoundOn("Jex.IonCannon.Init", target1)

	-- EmitSoundOnLocationWithCaster(newProjectile.position, "Jex.IonCannon.Init", caster)
end

function ion_cannon_main_think(event)
	local caster = event.caster
	local ability = event.ability
	for i = 1, #ability.projectiles_table, 1 do
		local projectile = ability.projectiles_table[i]
		if projectile then
			if IsValidEntity(projectile.target) and projectile.target:IsAlive() and projectile.active then
				projectile.target_position = projectile.target:GetAbsOrigin() + Vector(0, 0, 80)
				local movement_vector = ((projectile.target_position - projectile.position):Normalized()) * (projectile.speed * FrameTime())
				projectile.position = projectile.position + movement_vector
				local distance = WallPhysics:GetDistance2d(projectile.target_position, projectile.position)
				if distance < projectile.speed * FrameTime() * 1.5 then
					ion_cannon_impact(caster, ability, projectile, projectile.target, event.e_4_split_search_radius)
				elseif distance > 4000 then
					disable_projectile(caster, ability, projectile)
				end
			else
				disable_projectile(caster, ability, projectile)
			end
		end
	end
	reindex_cannon_table(ability)
end

function disable_projectile(caster, ability, projectile)
	projectile.active = false
	ParticleManager:DestroyParticle(projectile.pfx, false)
	-- reindex_cannon_table(ability)
end

function reindex_cannon_table(ability)
	local new_projectiles_table = {}
	for i = 1, #ability.projectiles_table, 1 do
		if ability.projectiles_table[i].active then
			table.insert(new_projectiles_table, ability.projectiles_table[i])
		end
	end
	ability.projectiles_table = new_projectiles_table
end

function ion_cannon_impact(caster, ability, projectile, target, e_4_split_search_radius)
	local search_radius = 600
	if ability.e_4_level then
		search_radius = search_radius + ability.e_4_level * e_4_split_search_radius
	end
	if projectile.splits > 0 then
		projectile.splits = projectile.splits - 1
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, search_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		local new_split_count = math.min(#enemies, 2)
		if #enemies > 0 then
			for i = 1, new_split_count, 1 do
				local enemy = enemies[i]
				if not enemy.dummy then
					new_ion_cannon_projectile(caster, ability, target, enemy, projectile.splits)
				end

			end
		end

	end
	Filters:TakeArgumentsAndApplyDamage(target, caster, ability.damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_COSMOS, RPC_ELEMENT_LIGHTNING)
	disable_projectile(caster, ability, projectile)
end
