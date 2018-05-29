function dominion_bolt_fire(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
    local info = 
    {
        Target = target,
        Source = caster,
        Ability = ability,  
        EffectName =  "particles/roshpit/ekkan/dominion_bolt_bolt3.vpcf",
        StartPosition = "attach_hitloc",
        bDrawsOnMinimap = false, 
            bDodgeable = true,
            bIsAttack = false, 
            bVisibleToEnemies = true,
            bReplaceExisting = false,
            flExpireTime = GameRules:GetGameTime() + 8,
        bProvidesVision = true,
        iVisionRadius = 0,
        iMoveSpeed = 750,
        iVisionTeamNumber = caster:GetTeamNumber()
    }
    caster.a_a_level = Runes:GetTotalRuneLevel(caster, 1, "a_a", "ekkan")
    projectile = ProjectileManager:CreateTrackingProjectile(info)
    EmitSoundOn("Ekkan.Dominion.Launch", caster)
    Filters:CastSkillArguments(1, caster)
end

function dominion_bolt_impact(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local debuff_duration = event.duration
	if target:GetTeamNumber() == caster:GetTeamNumber() then
		target:ForceKill(false)
	else
		EmitSoundOn("Ekkan.Dominion.Impact", target)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_ekkan_dominion_debuff", {duration = debuff_duration})
		ability:ApplyDataDrivenModifier(caster, target, "modifier_ekkan_dominion_overhead_effect", {duration = debuff_duration})
		-- ability.a_a_level = Runes:GetTotalRuneLevel(caster, 1, "a_a", "ekkan")
	end
end

function reindexDominionTable(ability)
	local newTable = {}
	for i = 1, #ability.dominionTable, 1 do
		if IsValidEntity(ability.dominionTable[i]) then
			if ability.dominionTable[i]:IsAlive() then
				table.insert(newTable, ability.dominionTable[i])
			end
		end
	end
	ability.dominionTable = newTable
end

function dominion_debuff_death(event)
	local unit = event.unit
	local caster = event.caster
	local ability = event.ability
	if not ability.dominionTable then
		ability.dominionTable = {}
	end
	if unit.dominion then
		local fv = unit:GetForwardVector()
		local summonPosition = unit:GetAbsOrigin()
		unit:SetAbsOrigin(summonPosition-Vector(0,0,800))
		local summon = CreateUnitByName(unit:GetUnitName(), summonPosition, false, nil, nil, caster:GetTeamNumber())
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_visage/visage_stone_form.vpcf", summon, 3)
		ability:ApplyDataDrivenModifier(caster, summon, "modifier_ekkan_dominion_unit", {})
		summon:SetAcquisitionRange(1600)
		summon:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
		summon:SetForwardVector(fv)
		local hp = unit:GetMaxHealth()
		local b_a_level = Runes:GetTotalRuneLevel(caster, 2, "b_a", "ekkan")
		if b_a_level > 0 then
			hp = hp + hp*0.06*b_a_level
			hp = math.min(hp, 2000000000)
		end
		local armor = unit:GetPhysicalArmorBaseValue()
		local movespeed = unit:GetBaseMoveSpeed()
		local attackDamage = unit:GetAttackDamage()
		if caster:HasModifier("modifier_ekkan_glyph_5_a") then
			attackDamage = attackDamage*2
		end
		summon:SetMaxHealth(hp)
		summon:SetHealth(hp)
   		summon:SetBaseMaxHealth(hp)

		summon:SetPhysicalArmorBaseValue(armor)
		summon:SetBaseMoveSpeed(movespeed)
	    summon:SetBaseDamageMin(attackDamage)
	    summon:SetBaseDamageMax(attackDamage) 
	    summon.attackDamage = attackDamage
	    summon.armor = armor
	    summon.aggro = true
	    summon.ekkan_unit = true
	    summon.ekkan_dominion = true
	    summon:SetDayTimeVisionRange(90)
	    summon:SetNightTimeVisionRange(90)
	    summon.hero = caster
	    if caster.a_a_level > 0 then
	    	summon:AddAbility("ekkan_zombie_strike"):SetLevel(1)
	    end
	    table.insert(ability.dominionTable, summon)
	    local max_summons = event.max_summons
	    if caster:HasModifier("modifier_ekkan_glyph_5_1") then
	    	max_summons = max_summons + 2
	    end
	    if #ability.dominionTable > max_summons then
	    	ability.dominionTable[1]:ForceKill(false)
	    end
	    EmitSoundOn("Ekkan.Dominion.SummonStart", summon)
	    reindexDominionTable(ability)
	    summon:SetAcquisitionRange(1200)
		summon.targetRadius = 1000
		summon.minRadius = 0
		summon.targetAbilityCD = 2
		summon.targetFindOrder = FIND_ANY_ORDER
		summon.autoAbilityCD = 2
		summon.owner = caster:GetPlayerOwnerID()
		local d_a_level = Runes:GetTotalRuneLevel(caster, 4, "d_a", "ekkan")
		if d_a_level > 0 then
			ability:ApplyDataDrivenModifier(caster, summon, "modifier_ekkan_d_a_alacrity", {})
			summon:SetModifierStackCount("modifier_ekkan_d_a_alacrity", caster, d_a_level)
		end
		if summon.aggroSound then
			EmitSoundOn(summon.aggroSound, summon)
		end
		summon.stance = "aggressive"
		summon:AddAbility("ekkan_creep_aggressive"):SetLevel(1)
		summon:SetOwner(caster)
	    for i = 0, 6, 1 do
	      local ability = summon:GetAbilityByIndex(i)
	      if ability then
	        ability:SetLevel(GameState:GetDifficultyFactor())
	      end
	    end
	    ability:ApplyDataDrivenModifier(caster, caster, "modifier_dominion_counter", {})
	    caster:SetModifierStackCount("modifier_dominion_counter", caster, #ability.dominionTable)
	end
end

function dominionUnitDie(event)
	local unit = event.unit
	local caster = event.caster
	local ability = event.ability
	reindexDominionTable(ability)
	if #ability.dominionTable > 0 then
	    ability:ApplyDataDrivenModifier(caster, caster, "modifier_dominion_counter", {})
	    caster:SetModifierStackCount("modifier_dominion_counter", caster, #ability.dominionTable)
	else
		caster:RemoveModifierByName("modifier_dominion_counter")
	end
end

function dominion_debuff_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local burnPercent = event.burn_damage/100
	local damage = target:GetAverageTrueAttackDamage(target)*burnPercent
	Filters:ApplyDotDamage(caster, ability, target, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_DEMON)
end

function dominion_unit_think(event)
	local caster = event.caster
	local target = event.target
	if caster:GetEntityIndex() == target:GetEntityIndex() then
		caster = target.hero
	end
	if target:IsAlive() then
		local leashDistance = 2000
		if caster:HasModifier("modifier_ekkan_glyph_5_a") then
			leashDistance = leashDistance + 1000
		end
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), target:GetAbsOrigin())
		if distance > leashDistance then
			FindClearSpaceForUnit(target, caster:GetAbsOrigin()+RandomVector(180), false)
			Timers:CreateTimer(0.1, function()
				CustomAbilities:QuickAttachParticle("particles/roshpit/ekkan/unit_teleport_loadout.vpcf", target, 3)
			end)
			return false
		end
		if target.stance == "passive" then
			return false
		elseif target.stance == "follow" then
			target:MoveToPosition(caster:GetAbsOrigin()+RandomVector(180))
			return false
		else
			if distance > 800 then
				local enemies = FindUnitsInRadius( target:GetTeamNumber(), target:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
				if #enemies == 0 then
					target:MoveToPosition(caster:GetAbsOrigin()+RandomVector(180))
				end
			end
			if target:HasAbility("ekkan_mage_blast") then
				local enemies = FindUnitsInRadius( target:GetTeamNumber(), target:GetAbsOrigin(), nil, 750, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false )	
				if #enemies > 0 then
					local castPoint = enemies[1]:GetAbsOrigin()
					local castAbility = target:FindAbilityByName("ekkan_mage_blast")
					if castAbility:IsFullyCastable() then
						local newOrder = {
								UnitIndex = target:entindex(),
								OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
								AbilityIndex = castAbility:entindex(),
								Position = castPoint
						 	}
						 
						ExecuteOrderFromTable(newOrder)		
					end	
				end
			end
			if target:HasAbility("ekkan_familiar_stoneform") then
				if target:GetHealth() <= target:GetMaxHealth()*0.7 then
					local enemies = FindUnitsInRadius( target:GetTeamNumber(), target:GetAbsOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false )	
					if #enemies > 0 then
						target:MoveToPosition(enemies[1]:GetAbsOrigin())
						Timers:CreateTimer(0.8, function()
							local castAbility = target:FindAbilityByName("ekkan_familiar_stoneform")
							if castAbility:IsFullyCastable() then
								local newOrder = {
										UnitIndex = target:entindex(),
										OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
										AbilityIndex = castAbility:entindex(),
								 	}
								 
								ExecuteOrderFromTable(newOrder)		
							end
						end)
					end
				end
			end
		end
	end
end

function dominion_unit_kill(event)
	local caster = event.caster
	local unit = event.unit
	local attacker = event.attacker
	local ability = event.ability
	if not unit.dominionLock then
		unit.dominionLock = true
		local c_a_level = Runes:GetTotalRuneLevel(caster, 3, "c_a", "ekkan")
		if unit:GetDeathXP() > 10 then
			if c_a_level > 0 then
				attacker.armor = attacker.armor + c_a_level*4
				local damageGainMult = 1200
				if caster:HasModifier("modifier_ekkan_glyph_5_a") then
					damageGainMult = 2400
				end
				attacker.attackDamage = math.min(attacker.attackDamage + c_a_level*damageGainMult, 2^26.5)
				attacker:SetPhysicalArmorBaseValue(attacker.armor)
			    attacker:SetBaseDamageMin(attacker.attackDamage)
			    attacker:SetBaseDamageMax(attacker.attackDamage) 
			    EmitSoundOn("Ekkan.DarkJourney", attacker)
			    CustomAbilities:QuickAttachParticle("particles/roshpit/ekkan_super_charge_buff_circle_flash.vpcf", attacker, 2)
				local beamPFX = ParticleManager:CreateParticle("particles/roshpit/ekkan/cast_beams_beams.vpcf", PATTACH_CUSTOMORIGIN, attacker)
				ParticleManager:SetParticleControl(beamPFX, 0, unit:GetAbsOrigin())
				ParticleManager:SetParticleControl(beamPFX, 1, attacker:GetAbsOrigin())
				Timers:CreateTimer(3, function()
					ParticleManager:DestroyParticle(beamPFX, false)
					ParticleManager:ReleaseParticleIndex(beamPFX)
				end)
				ability:ApplyDataDrivenModifier(caster, attacker, "modifier_ekkan_dominion_stacks", {})
				local newStacks = attacker:GetModifierStackCount("modifier_ekkan_dominion_stacks", caster) + 1
				attacker:SetModifierStackCount("modifier_ekkan_dominion_stacks", caster, newStacks)
			end
		end
	end
end

function dominion_zombie_strike_attack(event)
  local attacker = event.attacker
  local target = event.target
  local ability = event.ability
  local luck = RandomInt(1,2)
  if luck == 1 then
  		ability.attack_damage = event.attack_damage
		EmitSoundOn("Ekkan.ZombieStrike", attacker)
		local fv = ((target:GetAbsOrigin()-attacker:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		local distance = WallPhysics:GetDistance2d(target:GetAbsOrigin(), attacker:GetAbsOrigin())
		local speed = distance*2
		local info = 
		{
		Ability = ability,
		  EffectName = "particles/units/heroes/hero_vengeful/vengeful_wave_of_terror.vpcf",
		  vSpawnOrigin = attacker:GetAbsOrigin(),
		  fDistance = distance + 120,
		  fStartRadius = 210,
		  fEndRadius = 210,
		  Source = attacker,
		  StartPosition = "attach_origin",
		  bHasFrontalCone = false,
		  bReplaceExisting = false,
		  iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		  iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		  iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		  iVisionRadius = 500,
		  fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
		vVelocity = fv * speed,
		bProvidesVision = true,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
   end
end

function dominion_zombie_strike_hit(event)
	local caster = event.caster.hero
	local target = event.target
	local ability = event.ability
	local damage = caster.a_a_level*0.12*ability.attack_damage
	ability:ApplyDataDrivenModifier(event.caster, target, "modifier_hit_by_zombie_strike", {duration = 0.3})
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_NONE)
end

function zombie_strike_enemy_die(event)
	local eventTable = {}
	eventTable.unit = event.unit
	eventTable.attacker = event.caster
	eventTable.caster = event.caster.hero
	eventTable.ability = event.caster.hero:FindAbilityByName("ekkan_dominion")
	dominion_unit_kill(eventTable)
end