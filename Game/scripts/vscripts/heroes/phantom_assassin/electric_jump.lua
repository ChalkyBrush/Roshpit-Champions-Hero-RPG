function begin_electric_jump(event)
	local caster = event.caster
	local ability = event.ability
	abilityLevel = ability:GetLevel()
	--ability.location = caster:GetOrigin() + caster:GetForwardVector()*Vector(400,400)
	ability.jump_level = 0
	EmitSoundOn("phantom_assassin_phass_pain_02", caster)
	Filters:CastSkillArguments(3, caster)
	electricLeap_rune_a_c(caster, ability)
	electricLeap_rune_c_c(caster, ability)
	caster:StartGesture(ACT_DOTA_SPAWN)
    caster.d_c_level = Runes:GetTotalRuneLevel(caster, 4, "d_c", "voltex")

    ability:ApplyDataDrivenModifier(caster, caster, "modfier_voltex_jumping", {duration = 8})
    local targetPoint = event.target_points[1]
    local distance = WallPhysics:GetDistance(targetPoint*Vector(1,1,0), caster:GetAbsOrigin()*Vector(1,1,0))
    local jumpFV = ((targetPoint-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
    print(jumpFV)
    ability.jump_velocity = distance/30 + 15
    ability.jumpFV = jumpFV
    ability.distance = distance
    ability.targetPoint = targetPoint
    ability.lifting = true
    Timers:CreateTimer(0.3, function()
    	ability.lifting = false
    end)
end

function new_jumping_think(event)
	local caster = event.caster
	local ability = event.ability
	local forwardSpeed  = ability.distance/60 + 15
	local blockSearch = caster:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,GetGroundHeight(caster:GetAbsOrigin(), caster))
    local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch+ability.jumpFV*35), caster)
	if blockUnit then
		forwardSpeed = 0
	end
	caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,ability.jump_velocity)+ability.jumpFV*forwardSpeed)
	ability.jump_velocity = ability.jump_velocity - 3.3
	print(ability.jumpFV)
	if caster:GetAbsOrigin().z < GetGroundHeight(caster:GetAbsOrigin(), caster) + 10 and not ability.lifting then
		caster:RemoveModifierByName("modfier_voltex_jumping")
	end
end

function jump_think(keys)
	
	local caster = keys.caster
	local ability = keys.ability
	local modifier = caster:FindModifierByName("modifier_electric_jump_lift")
	local origin = caster:GetAbsOrigin()
	
	if not caster.jump_velocity then
		caster.jump_velocity = 50
	end
	local forwardSpeed = 30
	local blockSearch = caster:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,GetGroundHeight(caster:GetAbsOrigin(), caster))
    local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch+ability.forwardVector*70), caster)
	if blockUnit then
		print("walls found")
		forwardSpeed = 0
	end
	local newPosition = origin+Vector(0,0,caster.jump_velocity)+ability.forwardVector*forwardSpeed
	caster.jump_velocity = math.max(caster.jump_velocity - 3, 0)
	caster:SetAbsOrigin(newPosition)
	--if origin.z - groundPosition.z > -200 then
	--	caster:SetAbsOrigin(groundPosition)
	--end
end



function begin_drop(event)
	local caster = event.caster
	local ability = event.ability
	caster.jump_velocity_velocity = 0
	--caster:SetOrigin(ability.blink_position)
	print('BEGIN DROP?')
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_electric_jump_fall", nil)
end

function falling_think(keys)
	local ability = keys.ability
	local caster = keys.caster
	local modifier = caster:FindModifierByName("modifier_electric_jump_fall")
	local origin = caster:GetAbsOrigin()
	
	if not caster.jump_velocity then
		caster.jump_velocity = 0
	end
	local forwardSpeed = 30
    local obstruction = WallPhysics:FindNearestObstruction(origin*Vector(1,1,0))
    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (origin+ability.forwardVector*90), caster)
	if blockUnit then
		print("walls found")
		forwardSpeed = 0
	end
	local newPosition = origin+Vector(0,0,-caster.jump_velocity)+ability.forwardVector*forwardSpeed
	caster.jump_velocity = math.min(caster.jump_velocity + 3, 50)
	caster:SetAbsOrigin(newPosition)
	if ability.jump_level == 0 then
		if newPosition.z - GetGroundPosition(newPosition, caster).z < 250 then
			caster:RemoveModifierByName("modifier_electric_jump_fall")
		end
	else
	local groundPos = GetGroundPosition(newPosition, caster)
	if newPosition.z - groundPos.z < 10 then
		caster:RemoveModifierByName("modifier_electric_jump_fall")
	end
		if newPosition.z - GetGroundPosition(newPosition, caster).z < 400 and ability.explosions_fired == 0 then
			--ability.explosions_fired = 1
			--begin_explosion(caster, ability, newPosition+ability.forwardVector*300)
			--EmitSoundOn("Hero_Chen.PenitenceImpact", caster)
		end
	end

end

function drop_end(keys)
	local caster = keys.caster
	local ability = keys.ability
	local location = caster:GetAbsOrigin()
	electricLeap_rune_b_c(caster, ability)
	WallPhysics:ClearSpaceForUnit(caster, location)

end

function target_effect(event)
    local target = event.target
    local caster = event.caster
    local damage = event.land_damage

    local ability = event.ability


    local stun_duration = event.stun_duration
    Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 3, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
    Filters:ApplyStun(caster, stun_duration, target)
end

function electricLeap_rune_b_c(caster, ability)
  local totalLevel = Runes:GetTotalRuneLevel(caster, 2, "b_c", "voltex")
  ability.b_c_level = totalLevel
  ability.d_c_level = Runes:GetTotalRuneLevel(caster, 4, "d_c", "voltex")
  if totalLevel > 0 then
  	local b_c_duration = Filters:GetAdjustedBuffDuration(caster, 2.5+totalLevel*0.2, false)
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_voltex_rune_b_c", {duration = b_c_duration})
  end
end

function electricLeap_rune_c_c(hero, ability)
  local caster = hero
  local runeUnit = caster.runeUnit3
  local runeAbility = runeUnit:FindAbilityByName("voltex_rune_c_c")
  local totalLevel = Runes:GetTotalRuneLevel(caster, 3, "c_c", "voltex")
  if totalLevel > 0 then
    -- runeAbility:ApplyDataDrivenModifier(runeUnit, caster, "modifier_voltex_rune_c_c", {duration = 1.05})
    -- runeAbility.c_c_level = totalLevel
    -- ability.c_c_level = totalLevel
    if caster:IsAlive() then
	  	local heavens_charge = caster:FindAbilityByName("heavens_charge")
	  	if not heavens_charge then
	  		heavens_charge = caster:AddAbility("heavens_charge")
	  	end
	  	heavens_charge:SetLevel(ability:GetLevel())
	  	heavens_charge:SetAbilityIndex(2)
	  	heavens_charge.rune_c_c_level = totalLevel
	  	caster:SwapAbilities("electric_jump", "heavens_charge", false, true)
	  	caster.chargeActive = true
	end
  end
end

function electricLeap_rune_a_c(hero, ability)
  local caster = hero
  local runeUnit = caster.runeUnit
  local ability = runeUnit:FindAbilityByName("voltex_rune_a_c")
  local abilityLevel = ability:GetLevel()
  local bonusLevel = Runes:GetTotalBonus(runeUnit, "a_c")
  local totalLevel = abilityLevel + bonusLevel
  local player = caster:GetPlayerOwner()
  if totalLevel > 0 then
    ConjureImage(caster, player, ability, totalLevel, runeUnit)
    Timers:CreateTimer(1.1,
    function()
      ConjureImage(caster, player, ability, totalLevel, runeUnit)
    end)
  end
end

function ConjureImage( caster, player, runeAbility, abilityLevel, runeUnit )
 print("Conjure Image")

 local unit_name = caster:GetUnitName()
 local origin = caster:GetAbsOrigin() + RandomVector(100)
 local duration = abilityLevel*0.2 + 0.8
 local outgoingDamage = abilityLevel*0.02+0.4
 local incomingDamage = 0.1

 duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
 local illusion = CreateUnitByName("zap_assassin_clone", origin, true, caster, nil, caster:GetTeamNumber())
 illusion.owner = caster:GetPlayerOwnerID()
 --illusion:SetPlayerID(caster:GetPlayerID())
 illusion:SetControllableByPlayer(illusion.owner, true)
 runeAbility:ApplyDataDrivenModifier(runeUnit, illusion, "modifier_voltex_rune_a_c_remnant", {duration = duration})
 EmitSoundOn("Hero_Disruptor.ThunderStrike.Target", illusion)


  local overCharge = illusion:FindAbilityByName("lightning_attack")

 -- Set the unit as an illusion
 -- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle 
 illusion:AddNewModifier(caster, ability, "modifier_illusion", { duration = duration, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage })
 -- Without MakeIllusion the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.
 illusion:MakeIllusion()
 overCharge:SetLevel(caster:FindAbilityByName("lightning_attack"):GetLevel())
 overCharge:ApplyDataDrivenModifier(illusion, illusion, "modifier_gods_strength_datadriven" , {duration = duration})


	local newHealth = caster:GetMaxHealth()*5
	illusion:SetMaxHealth(newHealth)
	illusion:SetBaseMaxHealth(newHealth)
	illusion:SetHealth(newHealth)
	illusion:Heal(newHealth, illusion)
	local newArmor = caster:GetPhysicalArmorValue()*5
	illusion:SetPhysicalArmorBaseValue(newArmor)
	local newDamage = math.min(caster:GetAverageTrueAttackDamage(caster)*5, 2^31)
    illusion:SetBaseDamageMin(newDamage)
    illusion:SetBaseDamageMax(newDamage)

    if caster:HasModifier("modifier_voltex_rune_c_d_avatar") then
    	local runeAbility = caster.runeUnit3:FindAbilityByName("voltex_rune_c_d")
    	runeAbility:ApplyDataDrivenModifier(caster.runeUnit3, illusion, "modifier_voltex_rune_c_d_avatar", {duration = duration})
    	local c_d_level = Runes:GetTotalRuneLevel(caster, 3, "c_d", "voltex")
    	runeAbility:ApplyDataDrivenModifier(caster.runeUnit3, illusion, "modifier_voltex_rune_c_d_buff", {duration = duration})
    	illusion:SetModifierStackCount( "modifier_voltex_rune_c_d_buff", runeAbility, c_d_level )
    end

end
