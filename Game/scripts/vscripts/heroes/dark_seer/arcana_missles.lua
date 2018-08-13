require('heroes/dark_seer/mach_punch')
require('heroes/dark_seer/tachyon_shell')


function start_channel(event)
	local caster = event.caster
	local ability = event.ability
	ability.interval = 0
	ability.liftSpeed = 15
	if ability.missleTable then
		for i = 1, #ability.missleTable, 1 do
			ParticleManager:DestroyParticle(ability.missleTable[i].pfx, false)
		end
	end
	ability.missleTable = {}
	StartSoundEvent("Zonik.ArcanaMissles.Channel", caster)
	EmitSoundOn("Zonik.ArcanaMissles.StartVO", caster)

    local radius = 160
    local particleNameS = "particles/roshpit/zhonik/test/cube_explosion.vpcf"
    local particle2 = ParticleManager:CreateParticle( particleNameS, PATTACH_WORLDORIGIN, caster )
    ParticleManager:SetParticleControl( particle2, 0, caster:GetAbsOrigin() )
    ParticleManager:SetParticleControl( particle2, 1, Vector(radius,radius,radius) )
    ParticleManager:SetParticleControl( particle2, 2, Vector(1.1, 1.1, 1.1) )
    ParticleManager:SetParticleControl( particle2, 4, Vector(100, 255, 100) )
    Timers:CreateTimer(2.5, function()
    	ParticleManager:DestroyParticle(particle2, false)
    end)
    if caster:HasModifier("modifier_iron_treads_of_destruction") then
    	for i = 1, 10, 1 do
    		create_zonik_arcana_missle(caster, ability, 300)
    	end
    end
end

function arcana_missles_channel_think(event)
	local caster = event.caster
	local ability = event.ability
	
	ability.interval = ability.interval + 1
	local creationInterval = 13-ability:GetLevel()
	if ability.interval%creationInterval == 0 and ability.interval > 12 then
		create_zonik_arcana_missle(caster, ability, 0)
	end
	if ability.interval == 66 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_immunity_shield", {duration = 4.2})
		EmitSoundOn("Zonik.ArcanaMissles.ShieldApply", caster)
	end
	if ability.interval == 37 then
		StartAnimation(caster, {duration=3.1, activity=ACT_DOTA_VERSUS, rate=1})
	end
	caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,ability.liftSpeed))
	ability.liftSpeed = math.max(ability.liftSpeed - 0.3, 1)
end

function create_zonik_arcana_missle(caster, ability, zOff)
	local missle = {}
	missle.velocity = RandomInt(200, 350)
	local baseZ = math.max(50-ability.interval, 0)
	local projectileFV = (RandomVector(1) + Vector(0,0,RandomInt(baseZ, 100)/100)):Normalized()
	missle.fv = projectileFV
	local pfx = ParticleManager:CreateParticle("particles/roshpit/zhonik/timewarp_missle.vpcf", PATTACH_CUSTOMORIGIN, caster)
	missle.position = caster:GetAbsOrigin()+Vector(0,0,80)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()+Vector(0,0,80+zOff))
	ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin()+projectileFV*1300)
	ParticleManager:SetParticleControl(pfx, 2, Vector(missle.velocity, missle.velocity, missle.velocity))

	missle.pfx = pfx
	table.insert(ability.missleTable, missle)	
	Timers:CreateTimer(3.5, function()
		missle.locked = true
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			local lockEnemy = enemies[RandomInt(1, #enemies)]
			missle.lockEnemy = lockEnemy
			AddFOWViewer(caster:GetTeamNumber(), lockEnemy:GetAbsOrigin(), 300, 5, false)
			ParticleManager:SetParticleControl(pfx, 1, lockEnemy:GetAbsOrigin()+Vector(0,0,50))
			ParticleManager:SetParticleControl(pfx, 2, Vector(1400, 1400, 1400))
			EmitSoundOnLocationWithCaster(missle.position, "Zonik.ArcanaMissles.Launch", caster)
		else
			EmitSoundOnLocationWithCaster(missle.position, "Zonik.ArcanaMissles.Fizzle", caster)
			ParticleManager:DestroyParticle(missle.pfx, false)
		end 			
	end)	
end

function missles_channel_end(event)
	local caster = event.caster
	local ability = event.ability
	ability.fallSpeed = 15
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_missle_falling", {duration = 1.2})
	local animDuration = 2
	EndAnimation(caster)
	Timers:CreateTimer(0.1, function()
		StartAnimation(caster, {duration=animDuration, activity=ACT_DOTA_VICTORY, rate=2.8})
		EmitSoundOn("Zonik.ArcanaMissles.LaunchVO", caster)
	end)
	Timers:CreateTimer(2.0, function()
		caster:RemoveModifierByName("modifier_immunity_shield")
		if not caster:HasModifier("modifier_channel_start") then
			StopSoundEvent("Zonik.ArcanaMissles.Channel", caster)
			StartSoundEvent("Zonik.ArcanaMissles.ChannelLight", caster)
		end
	end)
	Timers:CreateTimer(3.5, function()
		if not caster:HasModifier("modifier_channel_start") then
			StopSoundEvent("Zonik.ArcanaMissles.ChannelLight", caster)
		end
	end)
	Filters:CastSkillArguments(4, caster)
end

function passive_think(event)
	local caster = event.caster
	local ability = event.ability
	local damage = event.damage
	local baseMS = caster:GetBaseMoveSpeed()
	local actualMS = caster:GetMoveSpeedModifier(baseMS)
	damage = damage*actualMS
	if not ability.d_d_interval then
		ability.d_d_interval = 0
	end
	ability.d_d_interval = ability.d_d_interval + 1
	if ability.missleTable then
		for i = 1, #ability.missleTable, 1 do
			local missle = ability.missleTable[i]
			if not missle.locked then
				missle.velocity = math.max(missle.velocity - 6, 0)
				ParticleManager:SetParticleControl(missle.pfx, 2, Vector(missle.velocity, missle.velocity, missle.velocity))
				missle.position = missle.position + missle.velocity*0.03*missle.fv
			else
				if not missle.exploded then
					if missle.lockEnemy then
						ParticleManager:SetParticleControl(missle.pfx, 1, missle.lockEnemy:GetAbsOrigin()+Vector(0,0,50))
						local fv = (missle.lockEnemy:GetAbsOrigin()+Vector(0,0,50) - missle.position):Normalized()
						missle.position = missle.position + fv*1400*0.03
						local distance = WallPhysics:GetDistance(missle.position, missle.lockEnemy:GetAbsOrigin()+Vector(0,0,50))
						if distance < 40 then
							EmitSoundOnLocationWithCaster(missle.position, "Zonik.ArcanaMissles.Impact", caster)
							missle.exploded = true
							ParticleManager:DestroyParticle(missle.pfx, false)
							
							Filters:TakeArgumentsAndApplyDamage(missle.lockEnemy, caster, damage, DAMAGE_TYPE_PURE, 4, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)
							Filters:ApplyStun(caster, 0.1, missle.lockEnemy)
							local a_d_level = Runes:GetTotalRuneLevelGeneric(caster, 1, 3)
							if a_d_level > 0 then
								CustomAbilities:QuickAttachParticle("particles/econ/items/rubick/rubick_force_ambient/rubick_telekinesis_land_force.vpcf", missle.lockEnemy, 3)
								local enemies = FindUnitsInRadius( caster:GetTeamNumber(), missle.lockEnemy:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
							    if #enemies > 0 then
							    	local aoeDamage = damage*a_d_level*0.1
							        for _,enemy in pairs(enemies) do
							        	Filters:TakeArgumentsAndApplyDamage(enemy, caster, aoeDamage, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)
							        end
							    end
							end
							local b_d_level = Runes:GetTotalRuneLevelGeneric(caster, 2, 3)
							if b_d_level > 0 then
								local eventTable = {}
								eventTable.caster = caster
								eventTable.target = missle.lockEnemy
								eventTable.cancelAnim = true
								eventTable.ability = caster:FindAbilityByName("zonik_mach_punch")
								if caster:HasAbility("zonik_comet_punch") then
									eventTable.ability = caster:FindAbilityByName("zonik_comet_punch")
								end
								eventTable.damage_mult = eventTable.ability:GetLevelSpecialValueFor("damage_mult", eventTable.ability:GetLevel())
								eventTable.arcana_missle_amp = b_d_level * 0.05

								eventTable.stun_duration = eventTable.ability:GetLevelSpecialValueFor("stun_duration", eventTable.ability:GetLevel())
								mach_punch_cast(eventTable)
							end
							local c_d_level = Runes:GetTotalRuneLevelGeneric(caster, 3, 3)
							if c_d_level > 0 then
								ability:ApplyDataDrivenModifier(caster, missle.lockEnemy, "modifier_tempo_flux_visible", {duration = 14})
								local newStacks = missle.lockEnemy:GetModifierStackCount("modifier_tempo_flux_visible", caster) + 1
								missle.lockEnemy:SetModifierStackCount("modifier_tempo_flux_visible", caster, newStacks)

								ability:ApplyDataDrivenModifier(caster, missle.lockEnemy, "modifier_tempo_flux_invisible", {duration = 14})
								missle.lockEnemy:SetModifierStackCount("modifier_tempo_flux_invisible", caster, newStacks*c_d_level)								
							end
							if caster:HasModifier("modifier_zonik_immortal_weapon_3") then
								if caster:HasAbility("tachyon_shell") then
									print("HERE?")
									local eventTable = {}
									eventTable.caster = caster
									eventTable.target = missle.lockEnemy
									eventTable.ability = caster:FindAbilityByName("tachyon_shell")
									eventTable.duration = eventTable.ability:GetLevelSpecialValueFor("duration", eventTable.ability:GetLevel())
									eventTable.bNoCast = true
									if eventTable.ability then
										tachyon_shield_cast(eventTable)
									end
								end
							end
						end
					end
				end
			end
		end
	end
	if ability.d_d_interval > 20 then
		ability.d_d_interval = 0
		local d_d_level = Runes:GetTotalRuneLevelGeneric(caster, 4, 3)
		if d_d_level > 0 then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_arcana_missles_d_d_agility", {})
			caster:SetModifierStackCount("modifier_arcana_missles_d_d_agility", caster, d_d_level)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_arcana_missles_d_d_attack_power", {})
			caster:SetModifierStackCount("modifier_arcana_missles_d_d_attack_power", caster, d_d_level*0.5*caster:GetAgility())
		else
			caster:RemoveModifierByName("modifier_arcana_missles_d_d_agility")
			caster:RemoveModifierByName("modifier_arcana_missles_d_d_attack_power")
		end
	end
end

function missle_falling_start(event)
	local caster = event.caster
	local ability = event.ability
	caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,ability.fallSpeed))
	ability.fallSpeed = ability.fallSpeed + 1
	if caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster) < ability.fallSpeed then
		caster:RemoveModifierByName("modifier_missle_falling")
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		local position = caster:GetAbsOrigin()
		local pfx = ParticleManager:CreateParticle( "particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( pfx, 0, position )
		ParticleManager:SetParticleControl( pfx, 1, Vector(200, 200, 200) )
		Timers:CreateTimer(2, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	    local radius = 160
	    local particleNameS = "particles/roshpit/zhonik/test/cube_explosion.vpcf"
	    local particle2 = ParticleManager:CreateParticle( particleNameS, PATTACH_WORLDORIGIN, caster )
	    ParticleManager:SetParticleControl( particle2, 0, caster:GetAbsOrigin() )
	    ParticleManager:SetParticleControl( particle2, 1, Vector(radius,radius,radius) )
	    ParticleManager:SetParticleControl( particle2, 2, Vector(1.1, 1.1, 1.1) )
	    ParticleManager:SetParticleControl( particle2, 4, Vector(100, 255, 100) )
	    Timers:CreateTimer(2.5, function()
	    	ParticleManager:DestroyParticle(particle2, false)
	    end)
	end
end