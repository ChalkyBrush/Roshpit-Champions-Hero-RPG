function rockfall_phase(event)
	local ability = event.ability
	local caster = event.caster
	StartAnimation(caster, {duration = 0.6, activity = ACT_DOTA_SPAWN, rate = 2.1, translate = "dualwield"})
	Timers:CreateTimer(0.63, function()
		if caster:HasModifier("modifier_energy_channel_animating") then
			StartAnimation(caster, {duration = 5, activity = ACT_DOTA_TELEPORT, rate = 0.8, translate = "fallen_legion"})
		end
	end)
	EmitSoundOn("MysticAssasin.Rockfall.VO", caster)
end

function begin_rockfall(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target_points[1]
	local damage = ability:GetAbilityDamage()
	damage = damage + event.additional_str_damage * caster:GetStrength()
	local stun_duration = event.stun_duration
	local self_damage_percent = event.self_damage
	EmitSoundOnLocationWithCaster(target, "MysticAssasin.Rockfall", caster.InventoryUnit)
	for i = 0, 2, 1 do
		Timers:CreateTimer(i * 0.18, function()
			local particlePosition = target + RandomVector(RandomInt(0, 120))
			local pfx = ParticleManager:CreateParticle("particles/roshpit/mountain_protector/rockfall.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx, 0, particlePosition)
			ParticleManager:SetParticleControl(pfx, 4, Vector(190, 190, 190))
			Timers:CreateTimer(3, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
			Timers:CreateTimer(0.24, function()
				EmitSoundOnLocationWithCaster(particlePosition, "MysticAssasin.Rockfall.Impact", caster)
				local particleName = "particles/roshpit/mystic_assassin/rockfall_explosion.vpcf"
				local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(particle1, 0, particlePosition)
				Timers:CreateTimer(4, function()
					ParticleManager:DestroyParticle(particle1, false)
				end)
				GridNav:DestroyTreesAroundPoint(particlePosition, 180, false)
				local enemies = FindUnitsInRadius(caster:GetTeamNumber(), particlePosition, nil, 220, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
				if #enemies > 0 then
					for _, enemy in pairs(enemies) do
						Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_E, RPC_ELEMENT_EARTH, RPC_ELEMENT_FIRE)
						Filters:ApplyStun(caster, stun_duration, enemy)
						ability:ApplyDataDrivenModifier(caster, caster, "modifier_rockfall_min_health", {duration = 0.09})
						ability:ApplyDataDrivenModifier(caster, enemy, "modifier_rockfall_post_mit", {duration = 10})
						if enemy.dummy then
						else
							--print("SELF DAMAGE")
							local self_damage = caster:GetMaxHealth() * self_damage_percent / 100
							--print(self_damage)
							Filters:ApplyDamageBasic(caster, enemy, self_damage, DAMAGE_TYPE_PURE)
						end
					end
				end
			end)
		end)
	end
	Filters:CastSkillArguments(3, caster)
	CustomAbilities:AddAndOrSwapSkill(caster, "mountain_protector_rockfall", "mountain_protector_volcanic_glissade", 2)
	local glissadeAbility = caster:FindAbilityByName("mountain_protector_volcanic_glissade")
	local c_c_level = caster:GetRuneValue("e", 3)
	if c_c_level > 0 then
		local procs = Runes:Procs(c_c_level, 7, 1)
		if procs > 0 then
			glissadeAbility:ApplyDataDrivenModifier(caster, caster, "modifier_glissade_freecast", {})
			caster:SetModifierStackCount("modifier_glissade_freecast", caster, procs)
		end
	end
	if caster:HasModifier("modifier_mountain_protector_immortal_weapon_3") then
		local CD = ability:GetCooldownTimeRemaining() * 0.35
		ability:EndCooldown()
		ability:StartCooldown(CD)
	end
end

function volcanic_glissade(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target_points[1]

	ability.targetPoint = target

	EmitSoundOn("MysticAssasin.Glissade", caster)
	StartAnimation(caster, {duration = 1, activity = ACT_DOTA_VERSUS, rate = 2})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_volcanic_glissade", {duration = 1.6})
	CustomAbilities:QuickParticleAtPoint("particles/roshpit/mystic_assassin/mystic_strike.vpcf", caster:GetAbsOrigin() + Vector(0, 0, 30), 3)
	if ability.beamPFX then
		ParticleManager:DestroyParticle(ability.beamPFX, false)
	end
	ability.beamPFX = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/epoch_rune_b_a.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(ability.beamPFX, 0, caster:GetAbsOrigin() + Vector(0, 0, 90))
	Filters:CastSkillArguments(3, caster)
	local glyphFreeCast = false
	if caster:HasModifier("modifier_mountain_protector_glyph_5_1") then
		local luck = RandomInt(1, 2)
		if luck == 1 then
			glyphFreeCast = true
		end
	end
	if caster:HasModifier("modifier_glissade_freecast") then
		if not glyphFreeCast then
			local newStacks = caster:GetModifierStackCount("modifier_glissade_freecast", caster) - 1
			if newStacks > 0 then
				caster:SetModifierStackCount("modifier_glissade_freecast", caster, newStacks)
			else
				caster:RemoveModifierByName("modifier_glissade_freecast")
			end
		end
		ability:EndCooldown()
	else
		if not glyphFreeCast then
			if caster:HasModifier("modifier_mountain_protector_immortal_weapon_3") then
				local CD = ability:GetCooldownTimeRemaining() * 0.35
				ability:EndCooldown()
				ability:StartCooldown(CD)
			end
			CustomAbilities:AddAndOrSwapSkill(caster, "mountain_protector_volcanic_glissade", "mountain_protector_rockfall", 2)
		else
			ability:EndCooldown()
		end
	end
end

function glissade_thinking(event)
	local ability = event.ability
	local caster = event.caster

	local movementVector = ((ability.targetPoint - caster:GetAbsOrigin()) * Vector(1, 1, 1)):Normalized()
	local movespeed = 60

	local blockSearch = caster:GetAbsOrigin() * Vector(1, 1, 0) + Vector(0, 0, GetGroundHeight(caster:GetAbsOrigin(), caster))
	local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch + caster:GetForwardVector() * movespeed), caster)
	if blockUnit then
		movespeed = 0
	end
	caster:SetAbsOrigin(caster:GetAbsOrigin() + movementVector * movespeed)
	local distance = WallPhysics:GetDistance(caster:GetAbsOrigin(), ability.targetPoint)
	if ability.beamPFX then
		ParticleManager:SetParticleControl(ability.beamPFX, 1, caster:GetAbsOrigin() + Vector(0, 0, 90))
	end
	if distance <= 60 or blockUnit then
		caster:RemoveModifierByName("modifier_volcanic_glissade")
		EndAnimation(caster)
		CustomAbilities:QuickParticleAtPoint("particles/roshpit/mystic_assassin/mystic_strike.vpcf", caster:GetAbsOrigin() + Vector(0, 0, 30), 3)
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		EmitSoundOn("MountainProtector.RockLand", caster)
		Timers:CreateTimer(0.06, function()
			if caster:HasModifier("modifier_energy_channel_animating") then
				StartAnimation(caster, {duration = 5, activity = ACT_DOTA_TELEPORT, rate = 0.8, translate = "fallen_legion"})
			end
			if ability.beamPFX then
				local destroyPFX = ability.beamPFX
				ability.beamPFX = false
				Timers:CreateTimer(0.5, function()
					ParticleManager:DestroyParticle(destroyPFX, false)
				end)
			end
		end)
	end

end

function glissade_end(caster, ability)
end
