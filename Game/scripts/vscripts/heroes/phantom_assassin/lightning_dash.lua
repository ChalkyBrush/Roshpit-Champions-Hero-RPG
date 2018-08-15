function begin_lightning_dash(event)
	local caster = event.caster
	local ability = event.ability
	local particleName = "particles/units/heroes/hero_stormspirit/stormspirit_ball_lightning.vpcf"
	ability.point = event.target_points[1]
	ability.moveDirection = (ability.point-caster:GetAbsOrigin()):Normalized()
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_lightning_dash", {duration = 3})
	StartSoundEvent("Voltex.LightningDashStart.LP", caster)
	EmitSoundOn("Voltex.LightningDashStart", caster)

	local particleName = "particles/roshpit/voltex/lightning_dash_trail.vpcf"
	local pfx = 0
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ability.pfx = false
	end
	pfx = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	-- ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin())
	-- ParticleManager:SetParticleControl(pfx, 2, caster:GetAbsOrigin())

	ability.pfx = pfx

	ability.a_c_level = Runes:GetTotalRuneLevelGeneric(caster, 1, 2)
	ability.interval = 0
	if not ability.particles then
		ability.particles = 0
	end
	Filters:CastSkillArguments(3, caster)
	if caster:HasModifier("modifier_lightning_dash_freecast") then
		ability:EndCooldown()
		local newStacks = caster:GetModifierStackCount("modifier_lightning_dash_freecast", caster) - 1
		if newStacks > 0 then
			caster:SetModifierStackCount("modifier_lightning_dash_freecast", caster, newStacks)
		else
			caster:RemoveModifierByName("modifier_lightning_dash_freecast")
		end
	end
	ability.previous_position = nil
end

function add_free_casts(event)
	local caster = event.caster
	local ability = event.ability
	local stackCount = caster:GetModifierStackCount("modifier_lightning_dash_freecast", caster)
	local maxStacks = 7
	if stackCount < maxStacks then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_lightning_dash_freecast", {})
		local newStacks = math.min(stackCount + 1, maxStacks)
		caster:SetModifierStackCount("modifier_lightning_dash_freecast", caster, newStacks)
	end
end

function dash_think(event)
	local caster = event.caster
	local ability = event.ability
	
	ability.moveDirection = (ability.point-caster:GetAbsOrigin()):Normalized()

	if not ability.previous_position then
		ability.previous_position = caster:GetAbsOrigin()
	end
	local forwardSpeed = 100
	local newPosition = ability.previous_position+ ability.moveDirection*forwardSpeed
	local afterWallPosition = WallPhysics:WallSearch(ability.previous_position, newPosition, caster)
	if afterWallPosition == newPosition then
	else
		newPosition = ability.previous_position
		caster:RemoveModifierByName("modifier_lightning_dash")
	end
	caster:SetAbsOrigin(Vector(newPosition.x, newPosition.y, 70) + Vector(0,0,GetGroundHeight(newPosition, caster)))
	ability.previous_position = newPosition
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.point)
	if distance < forwardSpeed*1.5 then
		caster:RemoveModifierByName("modifier_lightning_dash")
	end
	if ability.a_c_level > 0 then
		if ability.interval%3 == 0 then
			local damage = ability.a_c_level*0.15*caster:GetAverageTrueAttackDamage(caster)
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			if #enemies > 0 then
				for _,enemy in pairs(enemies) do
					Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 3, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
				      if ability.particles < 12 then
				        local particleName = "particles/units/heroes/hero_lina/lina_spell_laguna_blade_impact_sparks.vpcf"
				        local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
				        ParticleManager:SetParticleControl( particle1, 0, enemy:GetAbsOrigin() )
				        ParticleManager:SetParticleControl( particle1, 1, enemy:GetAbsOrigin() )
				        Timers:CreateTimer(0.6, 
				        function()
				          ParticleManager:DestroyParticle( particle1, false )
				          ability.particles = ability.particles - 1
				        end)
				      end
				end
			end 
		end
	end
	ability.interval = ability.interval + 1
	-- if ability.pfx then
	-- local pfx = ability.pfx
	-- 	ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin())
	-- 	ParticleManager:SetParticleControl(pfx, 2, caster:GetAbsOrigin())
	-- end
end

function dash_end(event)
	local caster = event.caster
	local ability = event.ability
	Timers:CreateTimer(0.03, function()
		StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_ATTACK_EVENT, rate=1.5}) 
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		StopSoundEvent("Voltex.LightningDashStart.LP", caster)
	end)
	ParticleManager:DestroyParticle(ability.pfx, false)
	ability.pfx = false
	local b_c_level = Runes:GetTotalRuneLevelGeneric(caster, 2, 2)
	if b_c_level > 0 then
		local particleName = "particles/roshpit/voltex/lightning_dash_end.vpcf"
		local pfxB = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfxB, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfxB, 1, Vector(200, 2, 200))
		Timers:CreateTimer(0.8, function()
			ParticleManager:DestroyParticle(pfxB, false)
		end)
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		local damage = caster:GetAverageTrueAttackDamage(caster)*0.15*b_c_level
		local stun_duration = b_c_level*0.01
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 3, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
				Filters:ApplyStun(caster, stun_duration, enemy)
			end
		end 
	end
end

function arcana_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	local damage = event.damage
	-- local c_c_level = Runes:GetTotalRuneLevelGeneric(caster, 3, 2)
	-- if c_c_level > 0 then
	-- 	if not ability.regen then
	-- 		ability.regen = 0
	-- 	end
	-- 	local addedRegen = math.ceil(damage*0.01*c_c_level)
	-- 	ability.regen = ability.regen + addedRegen
	-- 	ability:ApplyDataDrivenModifier(caster, caster, "modifier_voltex_lightning_dash_regen", {duration = 3})
	-- 	ability:ApplyDataDrivenModifier(caster, caster, "modifier_voltex_lightning_dash_regen_hidden", {duration = 3})
	-- 	caster:SetModifierStackCount("modifier_voltex_lightning_dash_regen_hidden", caster, ability.regen)

	-- end
end

function regen_think(event)
	local caster = event.caster
	local ability = event.ability
	local modifier = caster:FindModifierByName("modifier_voltex_lightning_dash_regen")
	local timeLeft = modifier:GetRemainingTime()
	-- print(timeLeft)
	local portion = timeLeft/3
	ability.regen = math.ceil(ability.regen*portion)
end

function regen_end(event)
	local caster = event.caster
	local ability = event.ability
	ability.regen = 0
end
--33888750