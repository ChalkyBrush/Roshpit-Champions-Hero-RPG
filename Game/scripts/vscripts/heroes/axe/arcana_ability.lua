function begin_arcana_ult(event)
	local caster = event.caster
	local ability = event.ability

	local point = event.target_points[1]
	local direction = ((point - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()

	StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_4, rate=1})
	local startPoint = caster:GetAbsOrigin()+direction*200

	local stun_duration = event.stun_duration
	local amp = event.amp
	local forks = event.forks
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)*event.attack_power_mult_percent/100
	damage = damage*amp
	local max = 1
	local min = -1
	local divisor = 9
	if forks == 1 then
		min = 0
		max = 0
		divisor = 1
	end
	local a_d_level = caster:GetRuneValue("r", 1)
	local c_d_level = caster:GetRuneValue("r", 3)
	if c_d_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_axe_c_d_attack_percent", {})
		caster:SetModifierStackCount("modifier_axe_c_d_attack_percent", caster, c_d_level)
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_prevent_turning_invisible", {duration = 0.15})
	Timers:CreateTimer(0.15, function()
		direction = caster:GetForwardVector()
		startPoint = caster:GetAbsOrigin()+direction*200
		local pfx2 = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/fire/monkey_king_spring_fire_base.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx2, 0, startPoint)
		Timers:CreateTimer(1.5, function()
			ParticleManager:DestroyParticle(pfx2, false)
		end)
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), startPoint, nil, 280, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
	            Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PURE, BASE_ABILITY_R, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
	            Filters:ApplyStun(caster, stun_duration, enemy)
			end
		end 
		EmitSoundOnLocationWithCaster(startPoint, "RedGeneral.ArcanaSunder.Start", caster)
		local d_d_level = caster:GetRuneValue("r", 4)
		local procs = Runes:Procs(d_d_level, 10, 1)
		for j = 0, procs, 1 do
			Timers:CreateTimer(j*0.5, function()
				if a_d_level > 0 then
					Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, caster, "modifier_general_postmitigation", {duration = 0.3})
					local amp = 15*a_d_level
					caster:SetModifierStackCount("modifier_general_postmitigation", Events.GameMaster, amp)
				end
				for i = min, max, 1 do
					Timers:CreateTimer(0.15, function()

						local forkDirection = WallPhysics:rotateVector(direction, math.pi*i/divisor)
						if j == 0 then
							EmitSoundOnLocationWithCaster(startPoint, "RedGeneral.ArcanaSunder.Moving", caster)
						end

						local particleName = "particles/roshpit/axe/arcana_sunder.vpcf"
						local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
						--print("DOING ANYTHING?")
						ParticleManager:SetParticleControl(pfx, 0, startPoint-direction*50+forkDirection*50)
						ParticleManager:SetParticleControl(pfx, 1, startPoint+forkDirection*1500)
						ParticleManager:SetParticleControl(pfx, 3, Vector(100,3.5,100)) -- y COMPONENT = duration
						-- ParticleManager:SetParticleControl(pfx, 1, point)
						Timers:CreateTimer(3.5, function()
							ParticleManager:DestroyParticle(pfx, false)
							for i = 1, 3, 1 do
								EmitSoundOnLocationWithCaster(startPoint, "RedGeneral.ArcanaSunder.Explode"..i, caster)
							end
	
							local enemies = FindUnitsInLine(caster:GetTeamNumber(), startPoint, startPoint+forkDirection*1500, nil, 150, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0)
					        for _,enemy in pairs(enemies) do
					            Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PURE, BASE_ABILITY_R, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
					            Filters:ApplyStun(caster, stun_duration, enemy)
					            --ability:ApplyDataDrivenModifier(caster, targetUnit, "modifier_stun_explosion", {})
					        end
					        caster:RemoveModifierByName("modifier_general_postmitigation")
							if c_d_level > 0 then
								ability:ApplyDataDrivenModifier(caster, caster, "modifier_axe_c_d_attack_percent", {duration = 2})
							end
						end)
						

					end)
				end
			end)
		end
	end)
	Filters:CastSkillArguments(4, caster)
end

function axe_arcana_take_damage(event)
	local caster = event.caster
	local damage = event.damage
	local ability = event.ability
	--print(damage)
	local b_d_level = caster:GetRuneValue("r", 2)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_axe_arcana_b_d_attack_power", {duration = 4})
	local currentStacks = caster:GetModifierStackCount("modifier_axe_arcana_b_d_attack_power", caster)
	local additionalStacks = damage*0.05*b_d_level
	local newStacks = math.min(currentStacks+additionalStacks, 50000*b_d_level)
	caster:SetModifierStackCount("modifier_axe_arcana_b_d_attack_power", caster, newStacks)
end