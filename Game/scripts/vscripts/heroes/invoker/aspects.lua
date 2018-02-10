function begin_cast(event)
	local caster = event.caster
	local ability = event.ability
	StartAnimation(caster, {duration=0.4, activity=ACT_DOTA_CAST_SUN_STRIKE, rate=0.8})
	caster.d_a_level = Runes:GetTotalRuneLevel(caster, 4, "d_a", "conjuror")
end

function aspect_global_think(event)
	local target = event.target
	local conjuror = target.conjuror
	local distance = WallPhysics:GetDistance2d(target:GetAbsOrigin(), conjuror:GetAbsOrigin())
	if distance > 3000 then
		local position = target:GetAbsOrigin()
	    local shadowParticle = "particles/units/heroes/hero_enigma/enigma_ambient_body.vpcf"
		local pfx = ParticleManager:CreateParticle( shadowParticle, PATTACH_CUSTOMORIGIN, target )
		ParticleManager:SetParticleControl( pfx, 0, position )
		ParticleManager:SetParticleControl( pfx, 1, position )
		ParticleManager:SetParticleControl( pfx, 2, position )
		ParticleManager:SetParticleControl( pfx, 3, position )
		Timers:CreateTimer(1.5, function()
			ParticleManager:DestroyParticle( pfx, false )
		end)
		position = conjuror:GetAbsOrigin()+RandomVector(200)
		FindClearSpaceForUnit(target,position, false)
		local pfx2 = ParticleManager:CreateParticle( shadowParticle, PATTACH_CUSTOMORIGIN, target )
		ParticleManager:SetParticleControl( pfx2, 0, position )
		ParticleManager:SetParticleControl( pfx2, 1, position )
		ParticleManager:SetParticleControl( pfx2, 2, position )
		ParticleManager:SetParticleControl( pfx2, 3, position )
		Timers:CreateTimer(1.5, function()
			ParticleManager:DestroyParticle( pfx2, false )
		end)
	end
end

function earth_aspect(event)
	local caster = event.caster
	local ability = event.ability
	local summonPosition = caster:GetAbsOrigin() + caster:GetForwardVector()*340
	caster.earthAspect = CreateUnitByName("earth_aspect", summonPosition, true, caster, caster, caster:GetTeamNumber())
	ability:ApplyDataDrivenModifier(caster, caster.earthAspect, "modifier_aspect_invulnerable", {duration = 1})
	caster.earthAspect.conjuror = caster
	caster.earthAspect.owner = caster:GetPlayerOwnerID()
	caster.earthAspect:SetOwner(caster)
    caster.earthAspect:SetControllableByPlayer(caster:GetPlayerID(), true)
	local aspectAbility = caster.earthAspect:FindAbilityByName("aspect_abilities")
	aspectAbility:SetLevel(1)
	aspectAbility:ToggleAbility()
	caster.earthAspect:FindAbilityByName("earth_aspect_rune_b_a_clap"):SetLevel(1)
	caster.earthAspect.aspect = true
	-- aspectAbility:ApplyDataDrivenModifier(caster.earthAspect, caster.earthAspect, "modifier_aspect_main", {})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_earth_guardian", {})
    local earthParticle = "particles/units/heroes/hero_earth_spirit/espirit_bouldersmash_caster.vpcf"
	local pfx = ParticleManager:CreateParticle( earthParticle, PATTACH_CUSTOMORIGIN, caster.earthAspect )
	ParticleManager:SetParticleControl( pfx, 0, summonPosition )
	ParticleManager:SetParticleControl( pfx, 1, summonPosition )
	ParticleManager:SetParticleControl( pfx, 2, summonPosition )
	ParticleManager:SetParticleControl( pfx, 3, summonPosition )

	EmitSoundOn("Hero_EarthSpirit.RollingBoulder.Destroy", caster.earthAspect)
  	local earthquake = caster:FindAbilityByName("earthquake")
  	if not earthquake then
  		earthquake = caster:AddAbility("earthquake")
  		earthquake:SetAbilityIndex(0)
  	end
  	earthquake:SetLevel(ability:GetLevel())
  	if caster:HasModifier("modifier_conjuror_immortal_weapon_3") then
  		caster.earthAspect:AddAbility("fire_temple_steadfast"):SetLevel(1)
  	end
	caster:SwapAbilities("summon_earth_aspect", "earthquake", false, true)
		ability:ApplyDataDrivenModifier(caster, caster.earthAspect, "modifier_earth_aspect_health", {})
		local aspectHealth = event.aspect_health
		if caster.aspectHealthAbility then
			aspectHealth = aspectHealth + caster:GetModifierStackCount( "modifier_weapon_aspect_health", caster.aspectHealthAbility )
		end
		if caster:HasModifier("modifier_conjuror_glyph_2_1") then
			aspectHealth = aspectHealth*1.8
		end
		local a_a_level = Runes:GetTotalRuneLevel(caster, 1, "a_a", "conjuror")
		aspectHealth = aspectHealth*(1+a_a_level*0.05)
		Timers:CreateTimer(0.05, function()
			
			caster.earthAspect:SetMaxHealth(aspectHealth)
			caster.earthAspect:SetBaseMaxHealth(aspectHealth)
			caster.earthAspect:SetHealth(aspectHealth)
			caster.earthAspect:Heal(aspectHealth, caster.earthAspect)
		end)
	if has_rune_a_a(ability, caster) then
		local runeUnit = caster.runeUnit
		local runeAbility = runeUnit:FindAbilityByName("conjuror_rune_a_a")
		runeAbility:ApplyDataDrivenModifier(runeUnit, caster, "modifier_earth_guardian", {})
	end
	glyph_5_a(caster, ability, caster.earthAspect)
end

function glyph_5_a(caster, ability, summon)
	if caster:HasModifier("modifier_conjuror_glyph_5_a") then
		ability:ApplyDataDrivenModifier(caster, summon, "modifier_conjuror_glyph_5_a_summon", {})
  --   	local amount = ability:GetManaCost(ability:GetLevel()-1)
  --   	caster:GiveMana(amount)
		-- PopupMana(caster, amount)
		-- CustomAbilities:QuickAttachParticle("particles/items3_fx/mango_active.vpcf", caster, 3)
	end
end

function fire_aspect(event)
	local caster = event.caster
	local ability = event.ability
	local summonPosition = caster:GetAbsOrigin() + caster:GetForwardVector()*340
	caster.fireAspect = CreateUnitByName("fire_aspect", summonPosition, true, caster, caster, caster:GetTeamNumber())
	ability:ApplyDataDrivenModifier(caster, caster.fireAspect, "modifier_aspect_invulnerable", {duration = 1})
	caster.fireAspect.conjuror = caster
	caster.fireAspect.owner = caster:GetPlayerOwnerID()
	caster.fireAspect:SetOwner(caster)
    caster.fireAspect:SetControllableByPlayer(caster:GetPlayerID(), true)
    caster.fireAspect.aspect = true
	local aspectAbility = caster.fireAspect:FindAbilityByName("aspect_abilities")
	aspectAbility:SetLevel(1)
	aspectAbility:ToggleAbility()
	local immolationAbility = caster.fireAspect:FindAbilityByName("conjuror_fire_aspect_immolation")
	immolationAbility:SetLevel(1)
	-- aspectAbility:ApplyDataDrivenModifier(caster.fireAspect, caster.fireAspect, "modifier_aspect_main", {})

    local fireParticle = "particles/econ/items/brewmaster/brewmaster_offhand_elixir/brewmaster_thunder_clap_fire_elixir.vpcf"
	local pfx = ParticleManager:CreateParticle( fireParticle, PATTACH_CUSTOMORIGIN, caster.fireAspect )
	ParticleManager:SetParticleControl( pfx, 0, summonPosition )
	ParticleManager:SetParticleControl( pfx, 1, summonPosition )
	ParticleManager:SetParticleControl( pfx, 2, summonPosition )
	ParticleManager:SetParticleControl( pfx, 3, summonPosition )

	EmitSoundOn("Hero_Nevermore.Raze_Flames", caster.fireAspect)
  	local immolation = caster:FindAbilityByName("immolation")
  	if not immolation then
  		immolation = caster:AddAbility("immolation")
  		immolation:SetAbilityIndex(1)
  	end
  	if caster:HasModifier("modifier_conjuror_glyph_1_1") then
  		ability:ApplyDataDrivenModifier(caster, caster.fireAspect, "modifier_conjuror_glyph_1_1_effect", {})
  	end
  	immolation:SetLevel(ability:GetLevel())
	caster:SwapAbilities("summon_fire_aspect", "immolation", false, true)
	ability:ApplyDataDrivenModifier(caster, caster.fireAspect, "modifier_fire_aspect", {})
		local aspectHealth = event.aspect_health
		if caster.aspectHealthAbility then
			aspectHealth = aspectHealth + caster:GetModifierStackCount( "modifier_weapon_aspect_health", caster.aspectHealthAbility )
		end
		if caster:HasModifier("modifier_conjuror_glyph_2_1") then
			aspectHealth = aspectHealth*1.8
		end
		local a_a_level = Runes:GetTotalRuneLevel(caster, 1, "a_a", "conjuror")
		aspectHealth = aspectHealth*(1+a_a_level*0.05)
		Timers:CreateTimer(0.05, function()
			caster.fireAspect:SetMaxHealth(aspectHealth)
			caster.fireAspect:SetBaseMaxHealth(aspectHealth)
			caster.fireAspect:SetHealth(aspectHealth)
			caster.fireAspect:Heal(aspectHealth, caster.fireAspect)
		end)
  	if caster:HasModifier("modifier_conjuror_immortal_weapon_3") then
  		caster.fireAspect:AddAbility("fire_temple_steadfast"):SetLevel(1)
  	end
	local a_b_level = get_a_b_level(caster)
	if a_b_level > 0 then
		immolationAbility.totalLevel = a_b_level		
		immolationAbility:ApplyDataDrivenModifier(caster.fireAspect, caster.fireAspect, "modifier_permanent_immolation", {})
	end
	local criticalStrikeRune = caster.runeUnit3:FindAbilityByName("conjuror_rune_c_b")
	criticalStrikeRune:ApplyDataDrivenModifier(caster.runeUnit3, caster, "modifier_conjuror_rune_c_b_effect", {})

    local d_a_level = Runes:GetTotalRuneLevel(caster, 4, "d_a", "conjuror")
   	caster.fireAspect.d_a_level = d_a_level
   	glyph_5_a(caster, ability, caster.fireAspect)
end

function shadow_aspect(event)
	local caster = event.caster
	local ability = event.ability
	local summonPosition = caster:GetAbsOrigin() + caster:GetForwardVector()*340
	caster.shadowAspect = CreateUnitByName("shadow_aspect", summonPosition, true, caster, caster, caster:GetTeamNumber())
	ability:ApplyDataDrivenModifier(caster, caster.shadowAspect, "modifier_aspect_invulnerable", {duration = 1})
	caster.shadowAspect.conjuror = caster
	caster.shadowAspect.owner = caster:GetPlayerOwnerID()
	caster.shadowAspect:SetOwner(caster)
    caster.shadowAspect:SetControllableByPlayer(caster:GetPlayerID(), true)
    caster.shadowAspect.aspect = true
	local aspectAbility = caster.shadowAspect:FindAbilityByName("aspect_abilities")
	aspectAbility:SetLevel(1)
	aspectAbility:ToggleAbility()
	-- aspectAbility:ApplyDataDrivenModifier(caster.shadowAspect, caster.shadowAspect, "modifier_aspect_main", {})

    local shadowParticle = "particles/units/heroes/hero_enigma/enigma_ambient_body.vpcf"
	local pfx = ParticleManager:CreateParticle( shadowParticle, PATTACH_CUSTOMORIGIN, caster.shadowAspect )
	ParticleManager:SetParticleControl( pfx, 0, summonPosition )
	ParticleManager:SetParticleControl( pfx, 1, summonPosition )
	ParticleManager:SetParticleControl( pfx, 2, summonPosition )
	ParticleManager:SetParticleControl( pfx, 3, summonPosition )
	Timers:CreateTimer(1.5, function()
		ParticleManager:DestroyParticle( pfx, false )
	end)
	EmitSoundOn("Hero_ShadowDemon.Soul_Catcher.Cast", caster.shadowAspect)
  	if caster:HasModifier("modifier_conjuror_glyph_4_1") then
  		ability:ApplyDataDrivenModifier(caster, caster.shadowAspect, "modifier_conjuror_glyph_4_1_effect", {})
  	end
  	local shadowGate = caster:FindAbilityByName("shadow_gate")
  	if not shadowGate then
  		shadowGate = caster:AddAbility("shadow_gate")
  		shadowGate:SetAbilityIndex(2)
  	end
  	if caster:HasModifier("modifier_conjuror_immortal_weapon_3") then
  		caster.shadowAspect:AddAbility("fire_temple_steadfast"):SetLevel(1)
  	end
  	shadowGate:SetLevel(ability:GetLevel())
	caster:SwapAbilities("summon_shadow_aspect", "shadow_gate", false, true)
	ability:ApplyDataDrivenModifier(caster, caster.shadowAspect, "modifier_shadow_aspect", {})
		local aspectHealth = event.aspect_health
		if caster.aspectHealthAbility then
			aspectHealth = aspectHealth + caster:GetModifierStackCount( "modifier_weapon_aspect_health", caster.aspectHealthAbility )
		end
		if caster:HasModifier("modifier_conjuror_glyph_2_1") then
			aspectHealth = aspectHealth*1.8
		end
		local a_a_level = Runes:GetTotalRuneLevel(caster, 1, "a_a", "conjuror")
		aspectHealth = aspectHealth*(1+a_a_level*0.05)
		Timers:CreateTimer(0.05, function()
			caster.shadowAspect:SetMaxHealth(aspectHealth)
			caster.shadowAspect:SetBaseMaxHealth(aspectHealth)
			caster.shadowAspect:SetHealth(aspectHealth)
			caster.shadowAspect:Heal(aspectHealth, caster.shadowAspect)
		end)
	local c_c_level = get_c_c_level(caster)
	if c_c_level > 0 then
		local totalStats = caster:GetStrength() + caster:GetAgility() + caster:GetIntellect()
		local stacks = (totalStats/10)*c_c_level*0.15
		ability:ApplyDataDrivenModifier(caster, caster.shadowAspect, "modifier_conjuror_c_c_damage", {})
		caster.shadowAspect:SetModifierStackCount( "modifier_conjuror_c_c_damage", ability, stacks )
		ability:ApplyDataDrivenModifier(caster, caster.shadowAspect, "modifier_conjuror_rune_c_c_range", {})
		caster.shadowAspect:SetModifierStackCount("modifier_conjuror_rune_c_c_range", ability, c_c_level )
	end
	local d_c_level = Runes:GetTotalRuneLevel(caster, 4, "d_c", "conjuror")
	caster.shadowAspect.d_c_level = d_c_level
	if d_c_level > 0 then
		caster.shadowAspect:SetRangedProjectileName("particles/econ/items/enigma/enigma_geodesic/conjuror_d_c_aspect_eidolon_geodesic.vpcf")
	end
	glyph_5_a(caster, ability, caster.shadowAspect)
end

function aspect_think(event)
	local caster = event.caster
	local conjurorPosition = caster.conjuror:GetAbsOrigin()
	local aspectPosition = caster:GetAbsOrigin()
	if event.caster:GetUnitName() == "earth_aspect" then
		local position = conjurorPosition + caster.conjuror:GetForwardVector()*300 + RandomVector(RandomInt(0, 80))
		if getDistance(conjurorPosition, aspectPosition) > 750 then
			caster:MoveToPosition(position)
		else
			caster:MoveToPositionAggressive(position)
		end
		if caster:HasAbility("earth_aspect_quake_leap") then
			local leapAbility = caster:FindAbilityByName("earth_aspect_quake_leap")
			if leapAbility:IsFullyCastable() then
				local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false )	
				if #enemies > 0 then
					local castPoint = enemies[1]:GetAbsOrigin()
					local newOrder = {
							UnitIndex = caster:entindex(),
							OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
							AbilityIndex = leapAbility:entindex(),
							Position = castPoint
					 	}
					 
					ExecuteOrderFromTable(newOrder)			
				end
			end
		end
		local baseAbility = caster.conjuror:FindAbilityByName("summon_earth_aspect")
		baseAbility:ApplyDataDrivenModifier(caster, caster.conjuror, "modifier_earth_guardian", {})
	end
	if event.caster:GetUnitName() == "fire_aspect" then
		local position = conjurorPosition + rotateVector(caster.conjuror:GetForwardVector(),-math.pi/2)*300 + RandomVector(RandomInt(0, 80))
		if getDistance(conjurorPosition, aspectPosition) > 850 then
			caster:MoveToPosition(position)
		else
			caster:MoveToPositionAggressive(position)
		end
	end
	if event.caster:GetUnitName() == "shadow_aspect" then
		local position = conjurorPosition + rotateVector(caster.conjuror:GetForwardVector(),math.pi/2)*300 + RandomVector(RandomInt(0, 80))
		if getDistance(conjurorPosition, aspectPosition) > 850 then
			caster:MoveToPosition(position)
		else
			caster:MoveToPositionAggressive(position)
		end
	end
	if event.caster:GetUnitName() == "conjuror_elemental_deity_summon" then
		if event.caster:IsChanneling() then
			return false
		end
		local position = conjurorPosition + caster.conjuror:GetForwardVector()*-400 + RandomVector(RandomInt(0, 80))
		if getDistance(conjurorPosition, aspectPosition) > 1400 then
			caster:MoveToPosition(position)
		else
			caster:MoveToPositionAggressive(position)
		end
		local caster = event.caster
		if caster:HasAbility("conjuror_deity_terra_blast") then
			local blastAbility = caster:FindAbilityByName("conjuror_deity_terra_blast")
			if blastAbility:IsFullyCastable() then
				local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false )	
				if #enemies > 0 then
					local castPoint = enemies[1]:GetAbsOrigin()
					local newOrder = {
							UnitIndex = caster:entindex(),
							OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
							AbilityIndex = blastAbility:entindex(),
							Position = castPoint
					 	}
					 
					ExecuteOrderFromTable(newOrder)	
					return false
				end
			end
		end
		if caster:HasAbility("conjuror_deity_shadow_shield") then
			local shieldAbility = caster:FindAbilityByName("conjuror_deity_shadow_shield")
			if shieldAbility:IsFullyCastable() then
				local aspectTable = {caster.conjuror.shadowAspect, caster.conjuror.fireAspect, caster.conjuror.earthAspect}
				local target = false
				for i = 1, #aspectTable, 1 do
					if aspectTable[i] then
						if not aspectTable[i]:HasModifier("modifier_deity_shadow_shield") then
							target = aspectTable[i]
							break
						end
					end
				end
				if target then
					local newOrder = {
					 		UnitIndex = caster:entindex(), 
					 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					 		TargetIndex = target:entindex(),
					 		AbilityIndex = shieldAbility:entindex(),
				 	}
					 
					ExecuteOrderFromTable(newOrder)		
					return false
				end
			end
		end
		if caster:HasAbility("call_of_elements") then
			local elementsAbility = caster:FindAbilityByName("call_of_elements")
			if elementsAbility:IsFullyCastable() then
				local newOrder = {
						UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
						AbilityIndex = elementsAbility:entindex(),
				 	}
				 
				ExecuteOrderFromTable(newOrder)	
				return false
			end
		end
	end
end

function getDistance(a,b)
    local x, y, z = a.x-b.x, a.y-b.y, a.z-b.z
    return math.sqrt(x*x+y*y+z*z)
end

function aspect_die(event)
	local caster = event.caster
	local ability = event.ability
	if event.caster:GetUnitName() == "earth_aspect" then
		local earthAspectSkill = caster.conjuror:FindAbilityByName("summon_earth_aspect")
		local earthquakeSkill = caster.conjuror:FindAbilityByName("earthquake")
		earthAspectSkill:SetLevel(earthquakeSkill:GetLevel())
		caster.conjuror:SwapAbilities("summon_earth_aspect", "earthquake", true, false)
		caster.conjuror.earthAspect = false
		caster.conjuror:RemoveModifierByName("modifier_earth_guardian")
		if caster.conjuror:HasModifier("modifier_conjuror_glyph_7_1") then
			if caster.conjuror:IsAlive() then
				local earthReviveEvent = {}
				earthReviveEvent.caster = caster.conjuror
				earthReviveEvent.ability = caster.conjuror:FindAbilityByName("summon_earth_aspect")
				earthReviveEvent.aspect_health = earthReviveEvent.ability:GetSpecialValueFor("aspect_health")
				earth_aspect(earthReviveEvent)
			end
		end
	elseif event.caster:GetUnitName() == "fire_aspect" then
		local fireAspectSkill = caster.conjuror:FindAbilityByName("summon_fire_aspect")
		local immolationSkill = caster.conjuror:FindAbilityByName("immolation")
		fireAspectSkill:SetLevel(immolationSkill:GetLevel())
		caster.conjuror:SwapAbilities("summon_fire_aspect", "immolation", true, false)
		caster.conjuror.fireAspect = false
		local d_b_level = Runes:GetTotalRuneLevel(caster.conjuror, 4, "d_b", "conjuror")
		if d_b_level > 0 then
			fireAspectDie(caster.conjuror, caster, d_b_level)
		end
	elseif event.caster:GetUnitName() == "shadow_aspect" then
		local shadowAspectSkill = caster.conjuror:FindAbilityByName("summon_shadow_aspect")
		local shadowGateSkill = caster.conjuror:FindAbilityByName("shadow_gate")
		shadowAspectSkill:SetLevel(shadowGateSkill:GetLevel())
		caster.conjuror:SwapAbilities("summon_shadow_aspect", "shadow_gate", true, false)
		caster.conjuror.shadowAspect = false
	elseif event.caster:GetUnitName() == "conjuror_elemental_deity_summon" then
		caster.conjuror.deity = false
	end
end

function fireAspectDie(caster, fireAspect, d_b_level)
	EmitSoundOn("Hero_OgreMagi.Fireblast.Target", fireAspect)
	local position = fireAspect:GetAbsOrigin()
	local particleName = "particles/units/heroes/hero_elder_titan/ring_of_fire.vpcf"
  	local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, fireAspect )
  	local origin = fireAspect:GetAbsOrigin()
  	ParticleManager:SetParticleControl( particle1, 0, position+Vector(0,0,200) )
  	ParticleManager:SetParticleControl( particle1, 1, Vector(440,440,440) )
  	ParticleManager:SetParticleControl( particle1, 2, Vector(440,440,440) )
  	ParticleManager:SetParticleControl( particle1, 3, Vector(440,440,440) )
  	ParticleManager:SetParticleControl( particle1, 4, Vector(440,440,440) )
  	ParticleManager:SetParticleControl( particle1, 5, Vector(440,440,440) )
  	ParticleManager:SetParticleControl( particle1, 6, Vector(440,440,440) )
  	ParticleManager:SetParticleControl( particle1, 7, Vector(440,440,440) )
  	ParticleManager:SetParticleControl( particle1, 8, Vector(440,440,440) )
  	ParticleManager:SetParticleControl( particle1, 9, Vector(440,440,440) )
	Timers:CreateTimer(1, function() 
	  ParticleManager:DestroyParticle( particle1, false )
	end)  
	
	local damage = fireAspect:GetMaxHealth()*1.5*d_b_level
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, 440, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
			Filters:ApplyStun(caster, 1, enemy)
		end
	end	
end

function rotateVector(vector, radians)
   XX = vector.x	
   YY = vector.y
   
   Xprime = math.cos(radians)*XX -math.sin(radians)*YY
   Yprime = math.sin(radians)*XX +math.cos(radians)*YY

   vectorX = Vector(1,0,0)*Xprime
   vectorY = Vector(0,1,0)*Yprime
   rotatedVector = vectorX + vectorY
   return rotatedVector
   
end

function conjurorDie(event)
	local caster = event.caster
	local ability = event.ability
    if caster.earthAspect then
		caster.earthAspect:Kill(ability, caster)	
    end
    if caster.fireAspect then
 		caster.fireAspect:Kill(ability, caster)
    end
    if caster.shadowAspect then
 		caster.shadowAspect:Kill(ability, caster)
    end	
end

function has_rune_a_a(ability, caster)
	local runeUnit = caster.runeUnit
	local runeAbility = runeUnit:FindAbilityByName("conjuror_rune_a_a")
	local abilityLevel = runeAbility:GetLevel()
	local bonusLevel = Runes:GetTotalBonus(runeUnit, "a_a")
	local totalLevel = abilityLevel + bonusLevel
	if totalLevel > 0 then
		return true
	else
		return false
	end
end

function get_b_a_level(caster)
	local runeUnit = caster.runeUnit2
	local runeAbility = runeUnit:FindAbilityByName("conjuror_rune_b_a")
	local abilityLevel = runeAbility:GetLevel()
	local bonusLevel = Runes:GetTotalBonus(runeUnit, "b_a")
	local totalLevel = abilityLevel + bonusLevel
	return totalLevel
end

function get_a_b_level(caster)
	local runeUnit = caster.runeUnit
	local runeAbility = runeUnit:FindAbilityByName("conjuror_rune_a_b")
	local abilityLevel = runeAbility:GetLevel()
	local bonusLevel = Runes:GetTotalBonus(runeUnit, "a_b")
	local totalLevel = abilityLevel + bonusLevel
	return totalLevel
end

function get_a_c_level(caster)
	local runeUnit = caster.runeUnit
	local runeAbility = runeUnit:FindAbilityByName("conjuror_rune_a_c")
	local abilityLevel = runeAbility:GetLevel()
	local bonusLevel = Runes:GetTotalBonus(runeUnit, "a_c")
	local totalLevel = abilityLevel + bonusLevel
	return totalLevel
end

function shadow_aspect_attack(event)
	
	local attacker = event.attacker
	local damage = attacker:GetAverageTrueAttackDamage(attacker)
	local target = event.target
	local ability = event.ability
	ability.damage = damage
	ability.pureDamage = damage*0.12*attacker.d_c_level
	ability.attacker = attacker
	local projectileParticle = "particles/econ/items/enigma/enigma_geodesic/enigma_base_attack_eidolon_geodesic.vpcf"
	if attacker.d_c_level > 0 then
		projectileParticle = "particles/econ/items/enigma/enigma_geodesic/conjuror_d_c_aspect_eidolon_geodesic.vpcf"
	end

	local enemies = FindUnitsInRadius( attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, 420, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		local count = 0
		for _,enemy in pairs(enemies) do
			if count > event.aspect_attack_splits then
				break
			end
			if not enemy.dummy then
				create_extra_attack(attacker,damage,enemy, target, ability, projectileParticle)
			end
			count = count+1
		end  	
	end
	local a_c_level = Runes:GetTotalRuneLevel(attacker.conjuror, 1, "a_c", "conjuror")
	if a_c_level > 0 then
		local conjuror = attacker.conjuror
		local unitsToBuffTable = {attacker}
		if conjuror:IsAlive() then
			table.insert(unitsToBuffTable, conjuror)
		end
		if conjuror.fireAspect then
			table.insert(unitsToBuffTable, conjuror.fireAspect)
		end
		for i = 1, #unitsToBuffTable, 1 do
			local unit = unitsToBuffTable[i]
			local duration = Filters:GetAdjustedBuffDuration(conjuror, 16, false)
			ability:ApplyDataDrivenModifier(attacker, unit, "modifier_conjuror_a_c_buff_visible", {duration = duration})
			ability:ApplyDataDrivenModifier(attacker, unit, "modifier_conjuror_a_c_buff_invisible", {duration = duration})
			local currentStacks = unit:GetModifierStackCount("modifier_conjuror_a_c_buff_visible", attacker)
			local newStacks = math.min(currentStacks + 1, 20)
			unit:SetModifierStackCount("modifier_conjuror_a_c_buff_visible", attacker, newStacks)
			unit:SetModifierStackCount("modifier_conjuror_a_c_buff_invisible", attacker, newStacks*a_c_level)
			CustomAbilities:QuickAttachParticle("particles/roshpit/shadow_aspect_soul_of_shadow.vpcf", unit, 1)
		end
	end
	if attacker:HasModifier("modifier_shadow_aspect_c_d_slow_attack") then
		apply_c_d_slow(attacker, target, ability)
	end
end

function apply_c_d_slow(attacker, target, ability)
	ability:ApplyDataDrivenModifier(attacker, target, "modifier_conjuror_c_d_slow_effect", {duration = 6})
	target:SetModifierStackCount("modifier_conjuror_c_d_slow_effect", attacker, ability.c_d_level)
end

function create_extra_attack(attacker, damage, enemy, target, ability, projectileParticle)
local info = 
{
	Target = enemy,
	Source = target,
	Ability = ability,	
	EffectName = projectileParticle,
	vSourceLoc= target:GetAbsOrigin()+Vector(0,0,90),
	bDrawsOnMinimap = false, 
        bDodgeable = true,
        bIsAttack = false, 
        bVisibleToEnemies = true,
        bReplaceExisting = false,
        flExpireTime = GameRules:GetGameTime() + 4,
	bProvidesVision = true,
	iVisionRadius = 0,
	iMoveSpeed = 660,
	iVisionTeamNumber = attacker:GetTeamNumber()
}
projectile = ProjectileManager:CreateTrackingProjectile(info)
end


function shadow_attack_strike(event)
	local ability = event.ability

	local caster = event.caster
	  local damageTable = {
	    victim = event.target,
	    attacker = ability.attacker,
	    damage = ability.damage,
	    damage_type = DAMAGE_TYPE_PHYSICAL,
	  }
	  if ability.attacker:HasModifier("modifier_shadow_aspect_c_d_slow_attack") then
	  	apply_c_d_slow(ability.attacker, event.target, ability) 
	  end   
	  ApplyDamage(damageTable)
	  ApplyDamage({ victim = event.target, attacker = ability.attacker, damage = ability.pureDamage, damage_type = DAMAGE_TYPE_PURE})
end

function shadow_aspect_kill(event)
	local caster = event.attacker
end

function get_c_c_level(caster)
	local runeUnit = caster.runeUnit3
	local runeAbility = runeUnit:FindAbilityByName("conjuror_rune_c_c")
	local abilityLevel = runeAbility:GetLevel()
	local bonusLevel = Runes:GetTotalBonus(runeUnit, "c_c")
	local totalLevel = abilityLevel + bonusLevel
	return totalLevel
end

function earth_aspect_a_a_think(event)
	local caster = event.caster
	local ability = event.ability
	ability.a_a_ability_level = Runes:GetTotalRuneLevel(caster.conjuror, 1, "a_a", "conjuror")
	if ability.a_a_ability_level > 0 then
		local a_a_duration = Filters:GetAdjustedBuffDuration(caster.conjuror, 2, false)
	  	local allies = FindUnitsInRadius( caster.conjuror:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	  	if #allies > 0 then
		    for _,ally in pairs(allies) do
		    	ability:ApplyDataDrivenModifier(caster, ally, "modifier_conjuror_a_a_buff", {duration = a_a_duration}) 
		    	ally:SetModifierStackCount( "modifier_conjuror_a_a_buff", ability, ability.a_a_ability_level )
		    end 
	    end 	
	    ability:ApplyDataDrivenModifier(caster, caster, "modifier_earth_aspect_a_a_effect", {duration = a_a_duration})
  	end	
end