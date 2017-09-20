function begin_explosion(event)
	local caster = event.caster
	local ability = event.ability
  ability.origCaster = caster
	local abilityLevel = ability:GetLevel()
	local location = caster:GetOrigin()
	local forwardVector = caster:GetForwardVector()
  local damage = event.damage
    caster.d_c_level = Runes:GetTotalRuneLevel(caster, 4, "d_c", "astral")
    caster.d_d_level = Runes:GetTotalRuneLevel(caster, 4, "d_d", "astral")

  if caster:HasModifier("modifier_astral_glyph_7_1") then
    damage = damage*10
  end 
  print("DAMAGE!: "..damage)

	for i=-3, 3, 1 do 
		rotatedVector = rotateVector(forwardVector, i*2*math.pi/7)*Vector(200, 200, 0)
		targetPoint = rotatedVector + location*Vector(1,1,0)
		create_individual_explosion(abilityLevel, caster, targetPoint, location, "dummy_aoe_explosion", 0, damage)
	end
	local smashLevel = rune_b_d(caster, ability)
	if smashLevel > 0 then
    local b_d_damage = smashLevel*R2_DAMAGE
    -- b_d_damage = b_d_damage + 0.002*caster:GetStrength()/10*d_d_level*b_d_damage
    if caster:HasModifier("modifier_astral_glyph_7_1") then
      b_d_damage = b_d_damage*10
    end 
		local duration = event.duration
		  Timers:CreateTimer(duration + 0.2,
		  function()
		  	EmitSoundOn("Hero_Leshrac.Split_Earth", caster)
				for i=-3, 3, 1 do 
					rotatedVector = rotateVector(forwardVector, i*2*math.pi/7)*Vector(200, 200, 0)
					targetPoint = rotatedVector + location*Vector(1,1,0)
					create_individual_explosion(abilityLevel, caster, targetPoint, location, "dummy_aoe_explosion_rune_b_d", smashLevel, b_d_damage)
				end
		  end)
	end
	rune_c_d(caster, ability)
  Filters:CastSkillArguments(4, caster)
end

function ranger_aoe_explosion_damage(event)
    local target = event.target
    local ability = event.ability
    local damage = ability.damage
    local caster = ability.origCaster
    Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_PURE, 4, RPC_ELEMENT_COSMOS, RPC_ELEMENT_NONE)
end

function rune_b_d(caster, ability)
  local runeUnit = caster.runeUnit2
  local runeAbility = runeUnit:FindAbilityByName("astral_rune_b_d")
  local abilityLevel = runeAbility:GetLevel()
  local bonusLevel = Runes:GetTotalBonus(runeUnit, "b_d")
  local totalLevel = abilityLevel + bonusLevel
  return totalLevel
end

function rune_b_d_strike(event)
	local ability = event.ability
	local target = event.target
	local caster = event.caster
	local damage = ability.damage
	local duration = ability.smashLevel*R2_ADD_DURATION + R2_START_DURATION
  if duration > 3.5 then
    duration = 3.5
  end
  ability:ApplyDataDrivenModifier(caster, target, "modifier_backstab_jumping", {duration = 0.09})
  Filters:TakeArgumentsAndApplyDamage(target, ability.origCaster, damage, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_COSMOS, RPC_ELEMENT_NONE)
  Filters:ApplyStun(caster, duration, target)
end

function rune_a_d(event)
  -- local caster = event.caster
  -- local ability = event.ability
  -- local runeUnit = caster.runeUnit
  -- local runeAbility = runeUnit:FindAbilityByName("astral_rune_a_d")
  -- local abilityLevel = runeAbility:GetLevel()
  -- local bonusLevel = Runes:GetTotalBonus(runeUnit, "a_d")
  -- local totalLevel = abilityLevel + bonusLevel
  -- if totalLevel > 0 then
  --   rune_a_d_start(caster, totalLevel, ability)
  -- end
end

function rune_a_d_start(caster, level, ability)
    -- local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
    -- ability.stars_dropped = 0
    -- if #enemies > 0 then
    --   for i = level
    --     for _,enemy in pairs(enemies) do
    --     	if ability.stars_dropped > level*2 then
    --     		break
    --     	end
			 --  Timers:CreateTimer(timeInterval*ability.stars_dropped, -- Start this timer 10 game-time seconds later
			 --  function()
    --       dropStar(enemy, caster, 300+level*80, , ability)
			 --  end)
			 --  ability.stars_dropped = ability.stars_dropped + 1      		   
    --     end
    -- end 	
end

function dropStar(enemy, caster, damage, ability, targetsPerInterval)
        -- ability:ApplyDataDrivenModifier(caster, enemy, "modifier_starfall", {duration = 2})
      damage = damage * targetsPerInterval
      local particleName = "particles/units/heroes/hero_mirana/mirana_starfall_attack.vpcf"
      local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, enemy )
      ParticleManager:SetParticleControlEnt(pfx, 0, enemy, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
      Timers:CreateTimer(0.6, function() 
        ParticleManager:DestroyParticle( pfx, false )
      end)  
          Timers:CreateTimer(0.45, -- Start this timer 10 game-time seconds later
          function()
            if enemy:IsAlive() then
              Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PURE, 4, RPC_ELEMENT_COSMOS, RPC_ELEMENT_NONE)
              EmitSoundOn("Ability.StarfallImpact", enemy)
              if ability.a_d_level > 0 then
                ability:ApplyDataDrivenModifier(caster, enemy, "modifier_starfall_a_d_visible", {duration = 7})
                local newStacks = enemy:GetModifierStackCount("modifier_starfall_a_d_visible", caster) + targetsPerInterval
                enemy:SetModifierStackCount("modifier_starfall_a_d_visible", caster, newStacks)

                -- ability:ApplyDataDrivenModifier(caster, enemy, "modifier_starfall_a_d_invisible", {duration = 7})
                -- enemy:SetModifierStackCount("modifier_starfall_a_d_invisible", caster, newStacks*ability.a_d_level)
              end
            end
          end)
end



function create_individual_explosion(abilityLevel, caster, targetPoint, casterOrigin, abilityName, smashLevel, damage)
  	local dummy = CreateUnitByName("npc_dummy_unit", casterOrigin, true, caster, caster, caster:GetTeamNumber())
  	dummy.owner = caster:GetPlayerOwnerID()

  	dummy:AddAbility(abilityName)
  	dummy:NoHealthBar()
  	dummy:AddAbility("dummy_unit")
  	dummy:FindAbilityByName("dummy_unit"):SetLevel(1)

  	local blast = dummy:FindAbilityByName(abilityName)
  	blast:SetLevel(abilityLevel)
  	blast.smashLevel = smashLevel
    blast.damage = damage
    blast.origCaster = caster
	local order =
	{
		UnitIndex = dummy:GetEntityIndex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = blast:GetEntityIndex(),
		Position = targetPoint,
		Queue = true
	}

	ExecuteOrderFromTable(order)
	  Timers:CreateTimer(5, -- Start this timer 10 game-time seconds later
	  function()
		UTIL_Remove(dummy)
	  end)
end

function rune_c_d(caster, mainAbility)
  local runeUnit = caster.runeUnit3
  local ability = runeUnit:FindAbilityByName("astral_rune_c_d")
  local abilityLevel = ability:GetLevel()
  local bonusLevel = Runes:GetTotalBonus(runeUnit, "c_d")
  local totalLevel = abilityLevel + bonusLevel
  ability.astral = caster
  ability.totalLevel = totalLevel
  if totalLevel > 0 then
  	ability.origCaster = caster
  	ability.c_d_level = totalLevel
    local dummy = CreateUnitByName("phoenix_summon", caster:GetAbsOrigin()-Vector(100,100,0), true, caster, caster, caster:GetTeamNumber())
    dummy:SetModelScale(1)
    EmitSoundOn("phoenix_phoenix_bird_attack", dummy)
    dummy.owner = caster:GetPlayerOwnerID()
    dummy:AddAbility("replica")
    dummy:FindAbilityByName("replica"):SetLevel(1)
    ability:ApplyDataDrivenModifier(runeUnit, dummy, "modifier_rune_c_d_phoenix", {duration = 10})
    dummy:MoveToNPC(caster)
    if caster:HasModifier("modifier_astral_glyph_2_1") then
      dummy.glyphed = true
    else
      dummy.glyphed = false
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

function starfall_initiate(event)
  local ability = event.ability
  local caster = event.caster
  if not caster.d_d_level then
    caster.d_c_level = Runes:GetTotalRuneLevel(caster, 4, "d_c", "astral")
    caster.d_d_level = Runes:GetTotalRuneLevel(caster, 4, "d_d", "astral")
  end
  ability.a_d_level = Runes:GetTotalRuneLevel(caster, 1, "a_d", "astral")
  ability.maxStars = ability.a_d_level + 20
  ability.targetsPerInterval = math.floor(ability.maxStars/20)
  ability.remainingStars = ability.maxStars%20
  ability.star_damage = 300 + ability.a_d_level*200
  if caster:HasModifier("modifier_astral_glyph_7_1") then
    ability.star_damage = ability.star_damage*10
    local glyphDuration = Filters:GetAdjustedBuffDuration(caster, 2.5, false)
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_astral_glyph_7_1_evasion_effect", {duration = glyphDuration})
  end
  ability.extraTargetsStruck = 0
end

function starfall_think(event)
  local caster = event.caster
  local ability = event.ability
  local maxStars = ability.a_d_level + 20

  if ability.a_d_level > 0 then
    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
    if #enemies > 0 then
      local targetsPerInterval = ability.targetsPerInterval
      local remainingStars = ability.remainingStars

      dropStar(enemies[RandomInt(1, #enemies)], caster, ability.star_damage, ability, targetsPerInterval)

      if ability.extraTargetsStruck < ability.remainingStars then
        Timers:CreateTimer(0.05, function()
          dropStar(enemies[RandomInt(1, #enemies)], caster, ability.star_damage, ability, 1)
          ability.extraTargetsStruck = ability.extraTargetsStruck + 1
        end)
      end
    end
  end
end
