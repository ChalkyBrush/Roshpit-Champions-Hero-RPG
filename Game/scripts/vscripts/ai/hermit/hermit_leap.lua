function begin_leap(event)
	local caster = event.caster
	local ability = event.ability
	ability.velocity = 96
	ability.fv = caster:GetForwardVector()
	StartAnimation(caster, {duration=1.3, activity=ACT_DOTA_SPAWN, rate=0.8})
	EmitSoundOn("bristleback_bristle_anger_02", caster)
	EmitSoundOn("bristleback_bristle_anger_02", caster)
end

function rise_think(event)
	local caster = event.caster
	local origin = caster:GetAbsOrigin()
	local ability = event.ability
	caster:SetAbsOrigin(origin+Vector(0,0,ability.velocity)+ability.fv*15)
	ability.velocity = ability.velocity - 8
end

function begin_fall(event)
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_hermit_falling", {duration = 2})
	-- StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_ATTACK, rate=0.3, translate="pyre"})
end

function fall_think(event)
	local caster = event.caster
	local origin = caster:GetAbsOrigin()
	local ability = event.ability
	local newPos = origin+Vector(0,0,ability.velocity)+ability.fv*15
	caster:SetAbsOrigin(newPos)
	ability.velocity = ability.velocity - 18
	local groundPos = GetGroundPosition(newPos, caster)
    if (newPos.z - groundPos.z < 2) then
        caster:RemoveModifierByName("modifier_hermit_falling")
        FindClearSpaceForUnit(caster, groundPos, true)
    end	
end

function final_land(event)
	local caster = event.caster
	local ability = event.ability
	local radius = 200
	EmitSoundOn("bristleback_bristle_anger_09", caster)
	EmitSoundOn("bristleback_bristle_anger_09", caster)
	EmitSoundOn("Hero_EarthShaker.EchoSlamSmall", caster)
		local particleName =  "particles/units/heroes/hero_elder_titan/doomguard_leap_effect.vpcf"
		local position = caster:GetAbsOrigin()
		local particleVector = position

		local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( pfx, 0, particleVector )
		ParticleManager:SetParticleControl( pfx, 1, particleVector )
		ParticleManager:SetParticleControl( pfx, 2, particleVector )
		Timers:CreateTimer(1, function() 
		  ParticleManager:DestroyParticle( pfx, false )
		end)  
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			local damage = Events:GetAdjustedAbilityDamage(2000, 50000, 0)
			for _,enemy in pairs(enemies) do
				ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL })
				enemy:AddNewModifier(caster, nil, "modifier_stunned", {duration = 0.4})
			end
		end
	-- StartAnimation(caster, {duration=0.4, activity=ACT_DOTA_ATTACK, rate=3, translate="pyre"})
end

function hermit_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 0
	end
	if not caster.direction then
		caster.direction = Vector(1,0)
	end
	local position = caster:GetAbsOrigin()
	AddFOWViewer(DOTA_TEAM_GOODGUYS, position, 300, 1, false)	
	if position.x < 9434 then
		caster:MoveToPositionAggressive(Vector(12525, -9728))
		caster.direction = Vector(1,0)
	end
	if position.x > 12298 then
		caster:MoveToPositionAggressive(Vector(9280, -9728))
		caster.direction = Vector(-1,0)
	end

	caster.interval = caster.interval+1
	if caster.interval % 16 == 0 and caster:IsAlive() then
		for i = 1, 4, 1 do
			Timers:CreateTimer(0.9*i, function()
				if caster and caster:IsAlive() then
					EmitSoundOn("bristleback_bristle_anger_02", caster)
					WallPhysics:Jump(caster, caster.direction, 25, 10, 20, 1)
					StartAnimation(caster, {duration=1.1, activity=ACT_DOTA_SPAWN, rate=0.85})
				end
			end)
		end
		if caster.interval == 32 then
			caster.interval = 0
		end
	end
	if caster.interval % 28 == 0 and caster:IsAlive() then
		StartAnimation(caster, {duration=0.72, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.3})
		EmitSoundOn("bristleback_bristle_failure_02", caster)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_hermit_charging_up", {duration = 1.31})
		Timers:CreateTimer(0.81, function()
			StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_CAST_ABILITY_1, rate=1})
			EmitSoundOn("bristleback_bristle_anger_09", caster)
			Timers:CreateTimer(0.18, function()
				  local particlePosition = caster:GetAbsOrigin() +caster:GetForwardVector()*290
			      particleName = "particles/units/heroes/hero_lone_druid/hermit_roar.vpcf"
			      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
			      ParticleManager:SetParticleControl( particle1, 0, particlePosition )
			      EmitSoundOn("LoneDruid_SpiritBear.ReturnStart", caster)
			      Timers:CreateTimer(0.1, function()
					local enemies = FindUnitsInRadius( caster:GetTeamNumber(), particlePosition, nil, 240, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
					ScreenShake(particlePosition, 200, 0.4, 0.8, 9000, 0, true)
					if #enemies > 0 then
						local modifierKnockback =
							{
								center_x = particlePosition.x,
								center_y = particlePosition.y,
								center_z = particlePosition.z,
								duration = 0.7,
								knockback_duration = 0.7,
								knockback_distance = 280,
								knockback_height = 210
							}
						for _,enemy in pairs(enemies) do
					      	local damage = Events:GetAdjustedAbilityDamage(1500, 25000, 0)
							ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
							PopupDamage(enemy, damage)	
							enemy:AddNewModifier( enemy, nil, "modifier_knockback", modifierKnockback )	
							EmitSoundOn("LoneDruid_SpiritBear.ReturnStart", enemy)
						end
					end 			      	
			      end)
			      Timers:CreateTimer(2, 
			      function()
			        ParticleManager:DestroyParticle( particle1, false )
			      end)
			end)
		end)
	end
end

function hermit_die(event)
	local caster = event.caster
	ParticleManager:DestroyParticle(Dungeons.wallParticle, false)
	UTIL_Remove(Dungeons.blocker1)
	UTIL_Remove(Dungeons.blocker2)
	UTIL_Remove(Dungeons.blocker3)
	UTIL_Remove(Dungeons.blocker4)
	Dungeons.blocker1 = false
	Dungeons.blocker2 = false
	Dungeons.blocker3 = false
	Dungeons.blocker4 = false
	EmitSoundOn("bristleback_bristle_death_01", caster)
	local luck = RandomInt(1, 3)
	if luck == 3 then
		RPCItems:RollHermitSpikeShell(caster:GetAbsOrigin())
	end
end