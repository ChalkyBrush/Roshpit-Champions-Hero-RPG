require('heroes/arc_warden/abilities/onibi')

function cipher_bolt_start(event)
	local caster = event.caster
	local ability = event.ability
	caster:AddNoDraw()

	if ability.lockPoint then
	else
		ability.point = event.target_points[1]
		ability.point = WallPhysics:WallSearch(caster:GetAbsOrigin(), ability.point, caster)
	end
	local tech_level = onibi_get_total_tech_level(caster, "fire", "cosmic", "E")
	local clamp_distance = event.clamp_distance_base + event.clamp_distance_per_tech*tech_level
	local moveDirection = ((ability.point - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()

	local distance = WallPhysics:GetDistance2d(ability.point, caster:GetAbsOrigin())
	if distance > clamp_distance then
		ability.point = caster:GetAbsOrigin()+moveDirection*clamp_distance
	end
	ability.moveDirection = (ability.point-caster:GetAbsOrigin()):Normalized()
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_jex_cipher_bolt", {duration = 7})
	StartSoundEvent("Jex.ShootingStar.LP", caster)
	EmitSoundOn("Jex.Cinderbark.Attack", caster)
	
	caster:RemoveModifierByName("modifier_leshrac_wall_self_aura")

	local arcanaUlti = caster:FindAbilityByName("bahamut_arcana_ulti")
	if arcanaUlti then
		arcanaUlti.r_1_level = caster:GetRuneValue("r", 1)
	end

	ability.pfx = pfx
	ability.interval = 0
	if not ability.particles then
		ability.particles = 0
	end
	local range = WallPhysics:GetDistance2d(ability.point, caster:GetAbsOrigin())

   	CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_phoenix/phoenix_fire_spirit_ground.vpcf", caster:GetAbsOrigin(), 3)
	Filters:CastSkillArguments(3, caster)
	Filters:ReduceCooldownGeneric(caster, ability, event.cooldown_reduction_per_tech * tech_level)
	ability.w_4_level = caster:GetRuneValue("w", 4)

end

function cipher_bolt_dash_think(event)
	local caster = event.caster
	local ability = event.ability
	local w_4_level = 0
	
	ability.moveDirection = (ability.point-caster:GetAbsOrigin()):Normalized()

	local blockSearch = caster:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,GetGroundHeight(caster:GetAbsOrigin(), caster))
    local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch+ability.moveDirection*35), caster)
    local distance_for_slowing = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.point)
    local forwardSpeed = 2300/33


    if distance_for_slowing < 200 then
    	forwardSpeed = 30
    elseif distance_for_slowing < 400 then
    	forwardSpeed = 34
    elseif distance_for_slowing < 600 then
    	forwardSpeed = 38
    end


	if blockUnit then
		forwardSpeed = 0
		caster:RemoveModifierByName("modifier_jex_cipher_bolt")
	end
	local newPosition = caster:GetAbsOrigin() + ability.moveDirection*forwardSpeed
	caster:SetAbsOrigin(Vector(newPosition.x, newPosition.y, 200) + Vector(0,0,GetGroundHeight(newPosition, caster)))
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.point)
	if distance < forwardSpeed*1.5 then
		caster:RemoveModifierByName("modifier_jex_cipher_bolt")
	end
	ability.interval = ability.interval + 1
	if ability.w_4_level > 0 then
		if ability.interval % 5 == 0 then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 260, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			if #enemies > 0 then
				for _,enemy in pairs(enemies) do
					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_jex_cipher_bolt_burn", {duration = 5})
				end
			end 			
		end
	end

end

function cipher_bolt_dash_end(event)
	local caster = event.caster
	local ability = event.ability
	local e_4_level = caster:GetRuneValue("e", 4)
	if e_4_level > 0 then
		local manaRestore = event.e_4_mana_restore_on_land*e_4_level
		caster:GiveMana(manaRestore)
		Timers:CreateTimer(0.1, function()
			PopupMana(caster, manaRestore)
		end)
	end
	Timers:CreateTimer(0.03, function()
		StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_TELEPORT_END, rate=1.1}) 
		WallPhysics:ClearSpaceForUnit(caster, caster:GetAbsOrigin())
		StopSoundEvent("Jex.ShootingStar.LP", caster)

	   	local particle = "particles/roshpit/jex/fire_cosmic_land.vpcf"
		local pfx2 = ParticleManager:CreateParticle( particle, PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( pfx2, 0, caster:GetAbsOrigin() )
		Timers:CreateTimer(3, function()
			ParticleManager:DestroyParticle(pfx2, false)
		end)
	end)
	EmitSoundOn("Jex.ShootingStar.Start", caster)
	if not caster:HasModifier("modifier_sorceress_blink_datadriven") then
		caster:RemoveNoDraw()
	end

end

function cipher_bolt_burn_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local damage = (event.w_4_burn_damage_attack_power*ability.w_4_level/100)*OverflowProtectedGetAverageTrueAttackDamage(caster)
	Filters:ApplyDotDamage(caster, ability, target, damage, DAMAGE_TYPE_MAGICAL, 3, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
end