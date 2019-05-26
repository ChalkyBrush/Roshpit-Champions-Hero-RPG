require('/heroes/monkey_king/constants')

function bear_roar_pre(event)
	local caster = event.caster
	EmitSoundOn("Draghor.Bear.Roar", caster)
	local pfx = CustomAbilities:QuickAttachParticle("particles/econ/items/axe/axe_helm_shoutmask/axe_beserkers_call_owner_shoutmask.vpcf", caster, 3)
	
	ParticleManager:SetParticleControl(pfx, 2, Vector(280,280,280))
end

function bear_roar(event)
	local caster = event.caster
	local ability = event.ability
	local duration = event.duration

	local pfx = CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lycan/lycan_howl_cast.vpcf", caster, 3)
	ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 2, caster:GetAbsOrigin()+caster:GetForwardVector()*200)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 380, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_bear_roar_taunt", {duration = duration})
			enemy:MoveToTargetToAttack(caster)
		end
	end
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_bear_armor_buff", {duration = duration})
	ability.q_1_level = caster:GetRuneValue("q", 1)
	if ability.q_1_level > 0 then
		caster:RemoveModifierByName("modifier_bear_regen")
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_bear_regen", {duration = 12})
		EmitSoundOn("Draghor.Bear.Regeneration", caster)
	end
	Filters:CastSkillArguments(1, caster)
end

function bear_warstomp_pre(event)
	local caster = event.caster
	EmitSoundOn("Draghor.Bear.Warstomp.Pre", caster)
	StartAnimation(caster, {duration=0.4, activity=ACT_DOTA_IDLE_RARE, rate=2.2})
	local pfx = CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_axe/axe_beserkers_call_owner.vpcf", caster, 3)
	ParticleManager:SetParticleControl(pfx, 2, Vector(260,260,260))
end

function bear_warstomp(event)
	local caster = event.caster
	local ability = event.ability
	local stun_duration = event.stun_duration
	local damage = event.damage
	local w_3_level = caster:GetRuneValue("w", 3)
	if w_3_level > 0 then
		damage = damage + OverflowProtectedGetAverageTrueAttackDamage(caster)*DJANGHOR_W3_ATTACK_PERCENT_ADDED_TO_TORNADO_AND_STOMP*w_3_level
	end
	local position = caster:GetAbsOrigin()
	local splitEarthParticle = "particles/roshpit/draghor/bear_warstomp.vpcf"
	local radius = 280
	local pfx = ParticleManager:CreateParticle( splitEarthParticle, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, position )
	ParticleManager:SetParticleControl( pfx, 1, Vector(radius, radius, radius) )
	EmitSoundOn("Draghor.Bear.Warstomp", caster)
	-- FindClearSpaceForUnit(caster, position, false)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_NATURE, RPC_ELEMENT_EARTH)
			Filters:ApplyStun(caster, stun_duration, enemy)
			if caster:HasModifier("modifier_djanghor_glyph_7_1") then
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_bear_rend_armor_loss", {duration = 20})
				local shredStacks = enemy:GetModifierStackCount("modifier_bear_rend_armor_loss", caster)
				local newStacks = math.min(2, shredStacks+1)
				local armorLoss = (enemy:GetPhysicalArmorValue(false)+enemy:GetModifierStackCount("modifier_bear_rend_armor_loss", caster))*0.5
				enemy:SetModifierStackCount("modifier_bear_rend_armor_loss", caster, armorLoss*newStacks)
			end
		end
	end 
	Filters:CastSkillArguments(2, caster)
end

function begin_bear_charge(event)
	local caster = event.caster
	-- caster:Stop()
	local ability = event.ability
	local target = event.target_points[1]
	local chargeSpeed = 1000
	local distance = WallPhysics:GetDistance2d(target,caster:GetAbsOrigin())
	local duration = distance/chargeSpeed
	StartAnimation(caster, {duration=duration+0.39, activity=ACT_DOTA_RUN, rate=1.4, translate="charge"})
	ability.fv = ((target-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	caster:SetForwardVector(ability.fv)
	ability.pushTable = {}
	EmitSoundOn("Draghor.Bear.Charge", caster)
	ability.interval = 0
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_bear_charging", {duration = duration})
	if caster:HasModifier("modifier_djanghor_glyph_6_1") then
		local c_c_level = caster:GetRuneValue("e", 3)
		if c_c_level > 0 then
			local procs = Runes:Procs(c_c_level, 5, 1)
			if procs > 0 then
				local particle = false
				for i = 1, procs, 1 do
					local modifiers = caster:FindAllModifiers()
					for j = 1, #modifiers, 1 do
						local modifier = modifiers[j]
						local modifierMaker = modifier:GetCaster()
						if modifierMaker and modifierMaker.regularEnemy then
							caster:RemoveModifierByName(modifier:GetName())
							particle = true
							break
						end
					end				
				end
				if particle then
					EmitSoundOn("Draghor.Cleanse", caster)
					local pfx = CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_morphling/morphling_morph_agi.vpcf", caster, 1.2)
				end
			end
		end
	end
	Filters:CastSkillArguments(3, caster)
end

function bear_charge_thinking(event)
	local ability = event.ability
	local caster = event.caster
	local movement = 1000*0.03
	caster.EFV = ability.fv
	local newPos = GetGroundPosition(caster:GetAbsOrigin() + ability.fv*movement, caster)
	local obstruction = WallPhysics:FindNearestObstruction(caster:GetAbsOrigin()*Vector(1,1,0))
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPos*Vector(1,1,0), caster)
	if not blockUnit then
		caster:SetAbsOrigin(newPos)
	end
	for _,pushUnit in pairs(ability.pushTable) do
		if not pushUnit.dummy then
			local pushPos = GetGroundPosition(pushUnit:GetAbsOrigin() + ability.fv*movement, caster)
			pushUnit:SetAbsOrigin(pushPos)
		end
	end
	if ability.interval%9==0 then
		local casterOrigin = caster:GetAbsOrigin()
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), casterOrigin, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			EmitSoundOn("Draghor.BearCharge.Impact", caster)
			for _,enemy in pairs(enemies) do
				Filters:ApplyStun(caster, 0.5, enemy)
				ability.pushTable[tostring(enemy:GetEntityIndex())] = enemy
			      local pfx = ParticleManager:CreateParticle( "particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
			      ParticleManager:SetParticleControl( pfx, 0, enemy:GetAbsOrigin())
			      ParticleManager:SetParticleControl( pfx, 1, Vector(200, 200, 200) )
			      Timers:CreateTimer(2, function()
			        ParticleManager:DestroyParticle(pfx, false)
			      end)
			end
		end 			
	end
	ability.interval = ability.interval + 1
end

function bear_charge_end(event)
	local ability = event.ability
	local caster = event.caster
	ability.slideVelocity = 30
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_bear_sliding", {duration = 0.45})
	for _,pushUnit in pairs(ability.pushTable) do
		FindClearSpaceForUnit(pushUnit, pushUnit:GetAbsOrigin(), false)
	end
	ability.pushTable = {}
end

function charge_slide_think(event)
	local ability = event.ability
	local caster = event.caster
	local newPos = GetGroundPosition(caster:GetAbsOrigin() + ability.fv*ability.slideVelocity, caster)
	local obstruction = WallPhysics:FindNearestObstruction(caster:GetAbsOrigin()*Vector(1,1,0))
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPos*Vector(1,1,0), caster)
	if not blockUnit then
		FindClearSpaceForUnit(caster, newPos, false)
	else
		ability.slideVelocity = 0
	end	
	if ability.slideVelocity > 0 then
		ability.slideVelocity = ability.slideVelocity - 2
	end
	print("slide think")
end

function charge_slide_end(event)
	print("slide END")
	local caster = event.caster
	caster.EFV = nil
end

function bear_regen_think(event)
	local caster = event.caster
	local ability = event.ability
	local healAmount = ability.q_1_level*DJANGHOR_Q1_REGEN_FLAT + ability.q_1_level*DJANGHOR_Q1_REGEN_PCT/100 * caster:GetMaxHealth()
	Filters:ApplyHeal(caster, caster, healAmount, true)
end