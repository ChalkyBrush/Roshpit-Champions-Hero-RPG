require('heroes/arc_warden/abilities/onibi')

function jex_fire_fire_w_start(event)
	local caster = event.caster
	local ability = event.ability
	if not ability.missleTable then
		ability.missleTable = {}
	end
	ability.point = event.target_points[1]
	local tech_level = onibi_get_total_tech_level(caster, "fire", "fire", "W")
	local missle_count = math.max(event.flames_per_tech * tech_level, 1)
	for i = 1, missle_count, 1 do
		Timers:CreateTimer((i - 1) * 0.1, function()
			create_fire_fire_w_missle(caster, ability, 0)
		end)
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_w_fire_fire_thinker", {})
	EmitSoundOn("Jex.FireJuggler.Toss", caster)
	Filters:CastSkillArguments(2, caster)
	ability.damage = event.damage + (event.attack_damage_percent_added_per_tech / 100) * OverflowProtectedGetAverageTrueAttackDamage(caster) * tech_level
	ability.w_4_level = caster:GetRuneValue("w", 4)
end

function create_fire_fire_w_missle(caster, ability, zOff)
	local missle = {}
	missle.velocity = RandomInt(600, 800)
	local baseZ = 200
	local projectileFV = (RandomVector(1) + Vector(0, 0, RandomInt(baseZ, 100) / 100)):Normalized()
	missle.fv = projectileFV
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_base_attack.vpcf", PATTACH_CUSTOMORIGIN, caster)
	missle.position = caster:GetAttachmentOrigin(3)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAttachmentOrigin(1))
	ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin() + projectileFV * 1300)
	ParticleManager:SetParticleControl(pfx, 2, Vector(missle.velocity, missle.velocity, missle.velocity))

	missle.pfx = pfx
	table.insert(ability.missleTable, missle)
	Timers:CreateTimer(0.5, function()
		missle.locked = true
		missle.lockPoint = GetGroundPosition(ability.point + RandomVector(RandomInt(1, 260)), caster)
		ParticleManager:SetParticleControl(pfx, 1, missle.lockPoint + Vector(0, 0, 50))
		ParticleManager:SetParticleControl(pfx, 2, Vector(1400, 1400, 1400))
		EmitSoundOnLocationWithCaster(missle.position, "Zonik.ArcanaMissles.Launch", caster)

	end)
end

function jex_w_fire_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local damage = event.damage
	if ability.missleTable then
		for i = 1, #ability.missleTable, 1 do
			local missle = ability.missleTable[i]
			if missle then
				if not missle.locked then
					missle.velocity = math.max(missle.velocity - 6, 0)
					ParticleManager:SetParticleControl(missle.pfx, 2, Vector(missle.velocity, missle.velocity, missle.velocity))
					missle.position = missle.position + missle.velocity * 0.03 * missle.fv
				else
					if not missle.exploded then
						if missle.lockPoint then
							ParticleManager:SetParticleControl(missle.pfx, 1, missle.lockPoint + Vector(0, 0, 50))
							local fv = (missle.lockPoint + Vector(0, 0, 50) - missle.position):Normalized()
							missle.position = missle.position + fv * 1400 * 0.03
							local distance = WallPhysics:GetDistance(missle.position, missle.lockPoint + Vector(0, 0, 50))
							if distance < 40 then
								EmitSoundOnLocationWithCaster(missle.position, "Jex.FireJuggler.Impact", caster)

								local enemies = FindUnitsInRadius(caster:GetTeamNumber(), missle.lockPoint, nil, 250, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
								if #enemies > 0 then
									for _, enemy in pairs(enemies) do
										Filters:TakeArgumentsAndApplyDamage(enemy, caster, ability.damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
										if ability.w_4_level > 0 then
											ability:ApplyDataDrivenModifier(caster, enemy, "modifier_w_fire_fire_as_slow", {duration = 4})
										end
									end
								end

								missle.exploded = true
								ParticleManager:DestroyParticle(missle.pfx, false)
								CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_phoenix/phoenix_fire_spirit_ground.vpcf", missle.lockPoint, 3)
								reindex_fire_w_missle_table(caster, ability)

							end
						end
					end
				end
			end
		end
	end
end

function reindex_fire_w_missle_table(caster, ability)
	local newTable = {}
	for i = 1, #ability.missleTable, 1 do
		if ability.missleTable[i].exploded then
		else
			table.insert(newTable, ability.missleTable[i])
		end
	end
	ability.missleTable = newTable
	if #ability.missleTable == 0 then
		caster:RemoveModifierByName("modifier_w_fire_fire_thinker")
	end
end
