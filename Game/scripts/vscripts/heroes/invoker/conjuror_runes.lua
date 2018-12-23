function rune_q_1(event)
	local damageTaken = event.damageTaken
	local caster = event.unit

    local particleName = "particles/items_fx/brown_lightning.vpcf"
    local splitDamage = damageTaken*0.5
    if caster.earthAspect then
    	local aspect = caster.earthAspect
	    caster:Heal(splitDamage, caster)
	    local origin = aspect:GetAbsOrigin()
	    local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
	    ParticleManager:SetParticleControl(lightningBolt,0,Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))   
	    ParticleManager:SetParticleControl(lightningBolt,1,Vector(origin.x,origin.y,origin.z + aspect:GetBoundingMaxs().z ))

	    -- Damage
	    ApplyDamage({ victim = aspect, attacker = caster, damage = splitDamage, damage_type = DAMAGE_TYPE_PURE})
    end


end

function get_q_1_level(runeAbility, runeUnit)
  local abilityLevel = runeAbility:GetLevel()
  local bonusLevel = Runes:GetTotalBonus(runeUnit, "q_1")
  local totalLevel = abilityLevel + bonusLevel
  return totalLevel	
end

function rune_q_2_damage(event)
	local target = event.target
	local caster = event.caster
	local totalLevel = get_q_2_level(caster.conjuror)
	local damage = caster:GetHealth()*0.08*totalLevel
	Filters:TakeArgumentsAndApplyDamage(target, caster.conjuror, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_EARTH, RPC_ELEMENT_NONE)
end

function get_q_2_level(caster)
	local runeUnit = caster.runeUnit2
	local runeAbility = runeUnit:FindAbilityByName("conjuror_rune_q_2")
	local abilityLevel = runeAbility:GetLevel()
	local bonusLevel = Runes:GetTotalBonus(runeUnit, "q_2")
	local totalLevel = abilityLevel + bonusLevel
	return totalLevel
end

function earth_aspect_thunder_clap(event)
	local target = event.target
	if target.conjuror then
		local q_2_level = get_q_2_level(target.conjuror)
		if q_2_level > 0 then
			local clap = target:FindAbilityByName("rune_q_2_clap")
			if not clap then
				clap = target:AddAbility("rune_q_2_clap")
			end
			clap:SetLevel(1)
			order =
			{
				UnitIndex = target:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = clap:entindex(),
			}
			ExecuteOrderFromTable(order)
		end
	end
end

function rune_q_2_clap_start(event)
	local caster = event.caster
	local ability = event.ability
	StartAnimation(caster, {duration=1, activity=ACT_DOTA_SPAWN, rate=0.8})
	EmitSoundOn("Conjuror.ThunderClap", caster)
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap.vpcf", caster, 3)
	local damage = caster:GetHealth()*0.05*event.rune_q_2_level
	local point = caster:GetAbsOrigin()
	local radius = 380
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false )	
	if #enemies > 0 then	
		for i = 1, #enemies, 1 do
			local target = enemies[i]
			ability:ApplyDataDrivenModifier(caster, target, "modifier_thunder_clap", {duration = 3})
			Filters:TakeArgumentsAndApplyDamage(target, caster.conjuror, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_EARTH, RPC_ELEMENT_NONE)
		end
	end
end

function earth_aspect_take_damage(event)
	local luck = RandomInt(1,20)
	if luck <= 3 then
		local caster = event.caster
		local ability = event.ability
		local target = event.target
		local attacker = event.attacker
		local rune_q_2_level = Runes:GetTotalRuneLevel(caster.conjuror, 2, "q_2", "conjuror")
		if rune_q_2_level > 0 then
			local eventTable = {}
			eventTable.caster = caster
			eventTable.ability = ability
			eventTable.rune_q_2_level = rune_q_2_level
			rune_q_2_clap_start(eventTable)
		end
	end
	local caster = event.caster
	local q_3_level = Runes:GetTotalRuneLevel(caster.conjuror, 3, "q_3", "conjuror")
	if q_3_level > 0 then
		local c_a_duration = Filters:GetAdjustedBuffDuration(caster.conjuror, 1.5, false)
		local ability = caster.conjuror:FindAbilityByName("summon_earth_aspect")
		ability:ApplyDataDrivenModifier(caster.conjuror, caster.conjuror, "modifier_aspect_earth_well", {duration = c_a_duration})
		caster.conjuror:SetModifierStackCount("modifier_aspect_earth_well", caster.conjuror, q_3_level)
	end
	
end

function immolation_think(event)
	
	local target = event.target
	local caster = target.conjuror
	local ability = event.ability
	local radius = 300
	local damage = ability.totalLevel*2510 + 600
	local healthGain = 0
	local enemies = FindUnitsInRadius( target:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
			ability:ApplyDataDrivenModifier(target, enemy, "modifier_immolation_burn", {})
			healthGain = healthGain + damage
		end
	end
	local w_1_level = caster:GetRuneValue("w", 1)
	healthGain = healthGain*w_1_level*(CONJUROR_W1_HEALTH_GAIN_PCT/100)
	local newHealth = math.min(target:GetMaxHealth() + healthGain, 200000000)
	target:SetBaseMaxHealth(newHealth)
	target:SetMaxHealth(newHealth) 	
end

function immolation_global_think(event)
	local caster = event.caster
	local w_1_level = Runes:GetTotalRuneLevel(caster.conjuror, 1, "w_1", "conjuror")
	local immolationAbility = event.ability
	if w_1_level > 0 then
		immolationAbility.totalLevel = w_1_level		
		immolationAbility:ApplyDataDrivenModifier(caster, caster, "modifier_permanent_immolation", {})
	end
end