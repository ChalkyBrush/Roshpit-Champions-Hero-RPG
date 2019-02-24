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
	ability.point = event.target_points[1]
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
    		create_fire_fire_w_missle(caster, ability, 300)
    	end
    end
end

function jex_fire_fire_w_start(event)
	local caster = event.caster
	local ability = event.ability
	if not ability.missleTable then
		ability.missleTable = {}
	end
	ability.point = event.target_points[1]
	local missle_count = 4
	for i = 1, missle_count, 1 do
		Timers:CreateTimer((i-1)*0.1, function()
			create_fire_fire_w_missle(caster, ability, 0)
		end)
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_w_fire_fire_thinker", {})
	Filters:CastSkillArguments(2, caster)
end

function create_fire_fire_w_missle(caster, ability, zOff)
	local missle = {}
	missle.velocity = RandomInt(600, 800)
	local baseZ = 200
	local projectileFV = (RandomVector(1) + Vector(0,0,RandomInt(baseZ, 100)/100)):Normalized()
	missle.fv = projectileFV
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_base_attack.vpcf", PATTACH_CUSTOMORIGIN, caster)
	missle.position = caster:GetAttachmentOrigin(3)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAttachmentOrigin(1))
	ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin()+projectileFV*1300)
	ParticleManager:SetParticleControl(pfx, 2, Vector(missle.velocity, missle.velocity, missle.velocity))

	missle.pfx = pfx
	table.insert(ability.missleTable, missle)	
	Timers:CreateTimer(0.5, function()
		missle.locked = true
		missle.lockPoint = ability.point + RandomVector(RandomInt(1, 260))
		ParticleManager:SetParticleControl(pfx, 1, missle.lockPoint+Vector(0,0,50))
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
					missle.position = missle.position + missle.velocity*0.03*missle.fv
				else
					if not missle.exploded then
						if missle.lockPoint then
							ParticleManager:SetParticleControl(missle.pfx, 1, missle.lockPoint+Vector(0,0,50))
							local fv = (missle.lockPoint+Vector(0,0,50) - missle.position):Normalized()
							missle.position = missle.position + fv*1400*0.03
							local distance = WallPhysics:GetDistance(missle.position, missle.lockPoint+Vector(0,0,50))
							if distance < 40 then
								EmitSoundOnLocationWithCaster(missle.position, "Zonik.ArcanaMissles.Impact", caster)
								missle.exploded = true
								ParticleManager:DestroyParticle(missle.pfx, false)
								CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_phoenix/phoenix_fire_spirit_ground.vpcf", missle.position, 3)
								reindex_fire_w_missle_table(caster, ability)
								-- Filters:TakeArgumentsAndApplyDamage(missleTablesle.lockPoint, caster, damage, DAMAGE_TYPE_PURE, 4, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)
								-- Filters:ApplyStun(caster, 0.1, missle.lockPoint)
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