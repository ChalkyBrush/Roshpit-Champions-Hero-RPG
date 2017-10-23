

function init_solunia(event)
	 local caster = event.caster
	 if not caster.initiated then
		  for k, v in pairs(caster:GetChildren()) do 
		    if v:GetClassname() == "dota_item_wearable" then
		      local model = v:GetModelName()
		      caster.weaponFX = v
		      caster.weaponFXname = model
		      print(caster.weaponFX:GetModelName())
		      break
		    end 
		  end 
		  caster.baseAttackRange = caster:GetAttackRange()
		  caster.initiated = true
	else
		caster:FindAbilityByName("solunia_solar_glow"):SetActivated(true)
		if caster:HasAbility("solunia_lunar_glow") then
			caster:FindAbilityByName("solunia_lunar_glow"):SetActivated(true)
		end	
		caster:FindAbilityByName("solunia_solarang"):SetActivated(true)	
		if caster:HasAbility("solunia_lunarang") then
			caster:FindAbilityByName("solunia_lunarang"):SetActivated(true)
		end		
	end
end

function begin_sun_form(event)
	local caster = event.caster
	local ability = event.ability
	if caster.sunMoon then
		if caster.sunMoon == "moon" then
			caster:RemoveModifierByName("modifier_selethas_sun_active")
		end
	end
end

function boomerang_phase_start(event)
	local caster = event.caster
	local ability = event.ability
	StartAnimation(caster, {duration=0.6, activity=ACT_DOTA_ATTACK, rate=1, translate="loadout"})
	EmitSoundOn("Selethas.Throw.VO", caster)
end

function reapply_weapon(event)
	local caster = event.caster
	caster.weaponFX:SetModel(caster.weaponFXname)
end

function solarang_start(event)
	local caster = event.caster
	-- Events:ColorWearablesAndBase(caster, Vector(255,255,255))

	caster.weaponFX:SetModel(nil)
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_disarm_weapon", {duration = 0.6})
	EmitSoundOn("Selethas.Boomerang.Throw", caster)
    local target = event.target_points[1]
    Filters:CastSkillArguments(2, caster)
    local fv = (target*Vector(1,1,0)-caster:GetAbsOrigin()*Vector(1,1,0)):Normalized()
    local boomerang = CreateUnitByName("selethas_boomerang", caster:GetAbsOrigin()+Vector(0,0,100), false, caster, nil, caster:GetTeamNumber())
    if not ability.boomerangTable then
    	ability.boomerangTable = {}
    end
    
    table.insert(ability.boomerangTable, boomerang)
    ability.boomerang = boomerang
    boomerang:SetAngles(0, 0, 0)

    boomerang.fv = fv
    boomerang:AddAbility("boomerang_dummy_ability"):SetLevel(1)
    local boomerangAbility = boomerang:FindAbilityByName("boomerang_dummy_ability")
    boomerangAbility:ApplyDataDrivenModifier(boomerang, boomerang, "modifier_boomerang_motion", {})
    boomerangAbility:ApplyDataDrivenModifier(boomerang, boomerang, "boomerang_passive_solar", {})
    boomerang.origCaster = caster
    boomerang.origAbility = ability
    boomerang.damage = event.damage
    boomerang.throwPosition = caster:GetAbsOrigin()
    boomerang.spinAngularVelocity = WallPhysics:rotateVector(fv, math.pi/2)
    boomerang.rotationAngle = 0
    boomerang.interval = 0
    boomerang:SetModelScale(0)
    boomerang.a_b_level = Runes:GetTotalRuneLevel(caster, 1, "a_b", "solunia")
    boomerang.b_b_level = Runes:GetTotalRuneLevel(caster, 2, "b_b", "solunia")
    boomerang.d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "solunia")
    boomerang:SetAbsOrigin(boomerang:GetAbsOrigin()+Vector(0,0,90)+fv*58-boomerang.spinAngularVelocity*28)

    boomerang.throwPower = WallPhysics:GetDistance2d(target, caster:GetAbsOrigin())/30 + 6
    boomerang:SetRenderColor(200, 200, 0)

    local damage = event.damage
    boomerang.damage = damage
    boomerangAbility:ApplyDataDrivenModifier(boomerang, boomerang, "modifier_boomerang_damage_think", {})

    a_c_prep(caster, boomerang)
    c_b_prep(caster, boomerang)
    d_b_prep(caster, boomerang, ability)

    ability:ApplyDataDrivenModifier(caster, caster, "modifier_outgoing_solarang", {})
    caster:SetModifierStackCount("modifier_outgoing_solarang", caster, #ability.boomerangTable)
    local max_boomerangs = event.max_boomerangs
    if caster:HasModifier("modifier_solunia_glyph_1_1") then
    	max_boomerangs = max_boomerangs + 2
    end
    if #ability.boomerangTable >= max_boomerangs then
    	ability:SetActivated(false)
    end
end

function a_c_prep(caster, boomerang)
    if caster:HasModifier("modifier_solunia_rune_a_c_ready") then
	    local currentStacks = caster:GetModifierStackCount("modifier_solunia_rune_a_c_ready", caster)
	    if currentStacks > 1 then
	        caster:SetModifierStackCount("modifier_solunia_rune_a_c_ready", caster, currentStacks-1)
	    else
	        caster:RemoveModifierByName("modifier_solunia_rune_a_c_ready")
	    end
	    boomerang.a_c_level = Runes:GetTotalRuneLevel(caster, 1, "a_c", "solunia")
    else
    	boomerang.a_c_level = 0
    end
end

function boomerang_thinking(event)
	local caster = event.caster
	local ability = event.ability
	local spinAngularVelocity = caster.spinAngularVelocity
	if not spinAngularVelocity then
		caster.spinAngularVelocity = WallPhysics:rotateVector(caster.fv, math.pi/60)
	end
	if caster.interval < 25 then
		caster:SetModelScale(caster.interval*0.04)
	end

	-- caster.spinAngularVelocity = WallPhysics:rotateVector(spinAngularVelocity, math.pi/60)
	local processionTorque = WallPhysics:rotateVector(spinAngularVelocity, math.pi/2)
	-- local targetPointFV = ((caster.origCaster:GetAbsOrigin() - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()

	local targetPointFV = ((caster.origCaster:GetAbsOrigin() + spinAngularVelocity*math.max((240-caster.interval*2), 0) - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()

	caster.throwPower = math.max(caster.throwPower - 0.4, 18)
	local finalMoveVector = (caster.fv*caster.throwPower + targetPointFV*0.2*(caster.interval^1.1))
	caster:SetAbsOrigin(caster:GetAbsOrigin() + finalMoveVector)
	if caster.interval%15 == 0 then
		EmitSoundOn("Selethas.Boomerang.Spinning", caster)
	end

	local height = GetGroundHeight(caster:GetAbsOrigin(), caster)
	if caster:GetAbsOrigin().z - height > 100 then
		caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,10))
	elseif caster:GetAbsOrigin().z - height < 60 then
		caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,10))
	end
	caster.rotationAngle = caster.rotationAngle + 45
	caster:SetAngles(0, caster.rotationAngle, 0)
 	if caster.rotationAngle == 360 then
		caster.rotationAngle = 0
	end
	local origAbility = caster.origAbility
	caster.interval = caster.interval + 1

	if caster.interval > 30 then
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), caster.origCaster:GetAbsOrigin())
		local distanceThreshold = 30
		if caster.interval < 70 then
			distanceThreshold = 100
		elseif caster.interval < 120 then
			distanceThreshold = 80
		end
		if distance < distanceThreshold then
			caster.origAbility.boomerang = false
			StartAnimation(caster.origCaster, {duration=0.5, activity=ACT_DOTA_SPAWN, rate=2.5})
			caster:RemoveModifierByName("modifier_boomerang_motion")
			boomerangFinishAll(caster)
			if caster.damagedEnemy then
				print("DAMAGED ENEMY REUTNR")
				if caster.origCaster:HasModifier("modifier_solunia_glyph_2_1") then
					print("IN THSI BLOCK??")
					reduceNapalmCooldown(caster.origCaster, "solunia_solar_glow")
					reduceNapalmCooldown(caster.origCaster, "solunia_lunar_glow")
				end
			end
			Timers:CreateTimer(0.03, function()
				UTIL_Remove(caster)
				reindexBoomerangs(origAbility)
			end)

			return false
		end
	end

	if caster.a_c_level > 0 then
		a_c_explosion(caster, finalMoveVector)
	end
end

function reduceNapalmCooldown(caster, napalmName)
	print(napalmName)
	if caster:HasAbility(napalmName) then
		print("REDUCE NAPALM COOLDOWN")
		local ability = caster:FindAbilityByName(napalmName)
		if ability then
			if ability:GetCooldownTimeRemaining() > 0 then
				local newCD = ability:GetCooldownTimeRemaining() - 2
				if newCD > 0 then
					ability:EndCooldown()
					ability:StartCooldown(newCD)
				else
					ability:EndCooldown()
				end
			end
		end
	end
end

function boomerangFinishAll(caster)
	if not caster.origCaster:HasModifier("modifier_solunia_flare_flying") and not caster.origCaster:HasModifier("modifier_solunia_in_between_flare") then
		caster.origAbility:SetActivated(true)
	end
	if caster.origAbility:GetAbilityName() == "solunia_solarang" then
		if #caster.origAbility.boomerangTable == 1 then
			caster.origCaster:RemoveModifierByName("modifier_outgoing_solarang")
		else
			caster.origCaster:SetModifierStackCount("modifier_outgoing_solarang", caster.origCaster, #caster.origAbility.boomerangTable-1)
		end
	else
		if #caster.origAbility.boomerangTable == 1 then
			caster.origCaster:RemoveModifierByName("modifier_outgoing_lunarang")
		else
			caster.origCaster:SetModifierStackCount("modifier_outgoing_lunarang", caster.origCaster, #caster.origAbility.boomerangTable-1)
		end
	end
end

function a_c_explosion(caster, finalMoveVector)
	local length = finalMoveVector:Length2D()
	if length < 8 then
		AddFOWViewer(caster.origCaster:GetTeamNumber(), caster:GetAbsOrigin(), 300, 5, false)
		local particleName = "particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf"
		if caster:HasModifier("boomerang_passive_lunar") then
			particleName = "particles/roshpit/solunia/eclipse.vpcf"
		end
	  	local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster.origCaster )
	  	local origin = caster:GetAbsOrigin()
	  	ParticleManager:SetParticleControl( particle1, 0, origin+Vector(0,0,-70) )
	  	ParticleManager:SetParticleControl( particle1, 1, Vector(550, 2, 1000) )
	  	ParticleManager:SetParticleControl( particle1, 3, Vector(550, 550, 550) )
	  	Timers:CreateTimer(3, function()
	  		ParticleManager:DestroyParticle(particle1, false)
	  	end)
	  	EmitSoundOn("Solunia.SolarGlow.Impact", caster)
		local damageType = DAMAGE_TYPE_MAGICAL
		if caster:HasModifier("boomerang_passive_lunar") then
			damageType = DAMAGE_TYPE_PURE
		end
		local enemies = FindUnitsInRadius( caster.origCaster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				print(caster.damage)
				Filters:TakeArgumentsAndApplyDamage(enemy, caster.origCaster, caster.damage*(1+caster.a_c_level*0.5), damageType, 2, RPC_ELEMENT_COSMOS, RPC_ELEMENT_NONE)
				Filters:ApplyStun(caster.origCaster, caster.a_c_level*0.05, enemy)
			end
		end 
		boomerangFinishAll(caster)
		caster:RemoveModifierByName("modifier_boomerang_motion")
		local origAbility = caster.origAbility
		Timers:CreateTimer(0.03, function()
			UTIL_Remove(caster)
			reindexBoomerangs(origAbility)
		end)
	end

end

function reindexBoomerangs(ability)
    local tempTable = {}
    for i = 1, #ability.boomerangTable, 1 do
        if IsValidEntity(ability.boomerangTable[i]) then
            table.insert(tempTable, ability.boomerangTable[i])
        end
    end 
    ability.boomerangTable = tempTable
end

function lunarang_start(event)
	local caster = event.caster

	caster.weaponFX:SetModel(nil)
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_disarm_weapon", {duration = 0.6})
	EmitSoundOn("Selethas.Boomerang.Throw", caster)
    local target = event.target_points[1]
    Filters:CastSkillArguments(2, caster)
    local fv = (target*Vector(1,1,0)-caster:GetAbsOrigin()*Vector(1,1,0)):Normalized()
    local boomerang = CreateUnitByName("selethas_boomerang", caster:GetAbsOrigin()+Vector(0,0,100), false, caster, nil, caster:GetTeamNumber())
    if not ability.boomerangTable then
    	ability.boomerangTable = {}
    end
    table.insert(ability.boomerangTable, boomerang)
    ability.boomerang = boomerang
    boomerang:SetAngles(0, 0, 0)
    
    boomerang.fv = fv
    boomerang:AddAbility("boomerang_dummy_ability"):SetLevel(1)
    local boomerangAbility = boomerang:FindAbilityByName("boomerang_dummy_ability")
    boomerangAbility:ApplyDataDrivenModifier(boomerang, boomerang, "modifier_boomerang_motion", {})
    boomerangAbility:ApplyDataDrivenModifier(boomerang, boomerang, "boomerang_passive_lunar", {})
    boomerang.origCaster = caster
    boomerang.origAbility = ability
    boomerang.damage = event.damage

    boomerang.throwPosition = caster:GetAbsOrigin()
    boomerang.spinAngularVelocity = WallPhysics:rotateVector(fv, math.pi/2)
    boomerang.rotationAngle = 0
    boomerang.interval = 0
    boomerang:SetModelScale(0)
    boomerang.a_b_level = Runes:GetTotalRuneLevel(caster, 1, "a_b", "solunia")
    boomerang.b_b_level = Runes:GetTotalRuneLevel(caster, 2, "b_b", "solunia")
    boomerang.d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "solunia")
    boomerang:SetAbsOrigin(boomerang:GetAbsOrigin()+Vector(0,0,90)+fv*58-boomerang.spinAngularVelocity*28)

    boomerang.throwPower = WallPhysics:GetDistance2d(target, caster:GetAbsOrigin())/30 + 6
    boomerang:SetRenderColor(0, 100, 255)

    local damage = event.damage
    boomerang.damage = damage
    boomerangAbility:ApplyDataDrivenModifier(boomerang, boomerang, "modifier_boomerang_damage_think", {})

    a_c_prep(caster, boomerang)
    c_b_prep(caster, boomerang)
    d_b_prep(caster, boomerang, ability)

    ability:ApplyDataDrivenModifier(caster, caster, "modifier_outgoing_lunarang", {})
    caster:SetModifierStackCount("modifier_outgoing_lunarang", caster, #ability.boomerangTable)
    local max_boomerangs = event.max_boomerangs
    if caster:HasModifier("modifier_solunia_glyph_1_1") then
    	max_boomerangs = max_boomerangs + 2
    end
    if #ability.boomerangTable >= max_boomerangs then
    	ability:SetActivated(false)
    end
end

function red_widow_end(event)
	local caster = event.caster
	local ability = event.ability
	caster:SetRangedProjectileName(caster.originalProjectile)
end

function boomerang_damager_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 120, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		caster.damagedEnemy = true
		for _,enemy in pairs(enemies) do
			boomerang_impact(caster, ability, enemy)
		end
	end 
end

function boomerang_impact(caster, ability, target)
	local damageType = DAMAGE_TYPE_MAGICAL
	if IsValidEntity(caster) then
		if caster:HasModifier("boomerang_passive_lunar") then
			damageType = DAMAGE_TYPE_PURE
		end
		local damage = caster.damage
		if caster.a_b_level > 0 then
			local luck = RandomInt(1,100)
			if luck <= 15 then
				EmitSoundOn("Solunia.BoomerangCrit", caster)
				damage = damage*caster.a_b_level*0.3 + damage
				local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
				ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "follow_origin", target:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "follow_origin", target:GetAbsOrigin(), true)
				Timers:CreateTimer(5, function() 
				  ParticleManager:DestroyParticle( pfx, false )
				  ParticleManager:ReleaseParticleIndex(pfx)
				end) 	
				PopupDamage(target, math.floor(damage))
				if caster.origCaster:HasModifier("modifier_solunia_immortal_weapon_2") then
					local particleName = "particles/units/heroes/hero_lich/lich_frost_nova.vpcf"
			      	local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
			      	local origin = target:GetAbsOrigin()
			      	ParticleManager:SetParticleControl( particle1, 0, origin )
			      	ParticleManager:SetParticleControl( particle1, 1, origin )
			      	Timers:CreateTimer(1, function()
			      		ParticleManager:DestroyParticle(particle1, false)
			      	end)
			      	EmitSoundOn("Solunia.Cryoshock", target)
					local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
					if #enemies > 0 then
						for _,enemy in pairs(enemies) do
							caster.origCaster.weapon:ApplyDataDrivenModifier(caster.origCaster.InventoryUnit, enemy, "modifier_solunia_cryoshock", {duration = 1.5})
						end
					end 
			      	
				end
			end
		end
		if caster.b_b_level > 0 then
			local solarang = caster.origCaster:FindAbilityByName("solunia_solarang")
			solarang:ApplyDataDrivenModifier(caster.origCaster, target, "modifier_boomerang_magic_marker", {duration = 10})
			target:SetModifierStackCount("modifier_boomerang_magic_marker", caster.origCaster, caster.b_b_level)
		end
		if caster.d_b_level > 0 then
			if not caster.origCaster:HasModifier("modifier_black_widow_stacks") then
				caster.origAbility:ApplyDataDrivenModifier(caster.origCaster, caster.origCaster, "modifier_black_widow_stacks", {})
			end
			local newStacks = math.min(caster.origCaster:GetModifierStackCount("modifier_black_widow_stacks", caster.origCaster) + 1, 50)
			caster.origCaster:SetModifierStackCount("modifier_black_widow_stacks", caster.origCaster, newStacks)
		end
		Filters:TakeArgumentsAndApplyDamage(target, caster.origCaster, damage, damageType, 2, RPC_ELEMENT_COSMOS, RPC_ELEMENT_NORMAL)
		CustomAbilities:QuickAttachParticle("particles/roshpit/solunia/boomerang_impact.vpcf", target, 0.3)
		EmitSoundOn("Solunia.BoomerangImpact", target)
	end
end

function MarkerParticle( event )
  local target = event.target
  local location = target:GetAbsOrigin()
  if target.markerParticle then
  	ParticleManager:DestroyParticle(target.markerParticle,false)
  	target.markerParticle = false
  end
  local particleName = "particles/roshpit/solunia/magic_marker_shield.vpcf"

-- Particle. Need to wait one frame for the older particle to be destroyed
  Timers:CreateTimer(0.01, function() 
    target.markerParticle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, target)
    ParticleManager:SetParticleControl(target.markerParticle, 0, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(target.markerParticle, 1, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(target.markerParticle, 2, target:GetAbsOrigin())

    ParticleManager:SetParticleControlEnt(target.markerParticle, 1, target, PATTACH_OVERHEAD_FOLLOW, "attach_overhead", target:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(target.markerParticle, 2, target, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
  end)
end

-- Destroys the particle when the modifier is destroyed
function EndMarkerParticle( event )
  local target = event.target
  if target.markerParticle then
  	ParticleManager:DestroyParticle(target.markerParticle,false)
  	target.markerParticle = false
  end
end

function c_b_prep(caster, boomerang)
	local c_b_level = Runes:GetTotalRuneLevel(caster, 3, "c_b", "solunia")
	if c_b_level > 0 then
		boomerang.damage = boomerang.damage + caster:GetAverageTrueAttackDamage(caster)*0.06*c_b_level
	end
end

function d_b_prep(caster, boomerang, ability)
	if boomerang.d_b_level > 0 then
		local stackCount = caster:GetModifierStackCount("modifier_black_widow_stacks", caster)
		if stackCount >= 50 then
			caster:RemoveModifierByName("modifier_black_widow_stacks")
			EmitSoundOn("Solunia.BlackWidow.VO", caster)
			local particleName = "particles/roshpit/solunia/solar_flare_no_ground.vpcf"
			if ability:GetAbilityName() == "solunia_lunar_warp_flare" then
				particleName = "particles/roshpit/solunia/lunar_flare_explosion_immortal1.vpcf"
			end
			local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
			EmitSoundOn("Solunia.BlackWidowStart", caster)
			Timers:CreateTimer(4, function()
				ParticleManager:DestroyParticle(pfx, false)
				ParticleManager:ReleaseParticleIndex(pfx)
			end)
			local duration = boomerang.d_b_level*0.35 + 3
			duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
			local solarangAbility = caster:FindAbilityByName("solunia_solarang")
			solarangAbility:ApplyDataDrivenModifier(caster, caster, "modifier_black_widow_invisible_damage_buff", {duration = duration})
			caster:SetModifierStackCount("modifier_black_widow_invisible_damage_buff", caster, boomerang.d_b_level)
			solarangAbility:ApplyDataDrivenModifier(caster, caster, "modifier_black_widow", {duration = duration})

			solarangAbility:ApplyDataDrivenModifier(caster, caster, "modifier_black_widow_invis_range_debuff", {duration = duration})
			caster:SetModifierStackCount("modifier_black_widow_invis_range_debuff", caster, (caster.baseAttackRange-100))
		end
	end
end

function black_widow_init(event)
	local caster = event.caster
	local ability = event.ability
	caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
	caster:SetRenderColor(0, 0, 0)
end

function black_widow_end(event)
	local caster = event.caster
	caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
	caster:SetRenderColor(255, 255, 255)
end

function black_widow_bleed(event)
	local caster = event.caster
	local target = event.target
	ApplyDamage({ victim = target, attacker = caster, damage = caster:GetAverageTrueAttackDamage(caster)*0.8, damage_type = DAMAGE_TYPE_MAGICAL })
end

function black_widow_attack_land(event)
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	ability:ApplyDataDrivenModifier(attacker, target, "modifier_black_widow_bleed", {duration = 3})
	EmitSoundOn("Solunia.BoomerangCrit", attacker)
	local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "follow_origin", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "follow_origin", target:GetAbsOrigin(), true)
	Timers:CreateTimer(5, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	  ParticleManager:ReleaseParticleIndex(pfx)
	end) 	
end