require('heroes/invoker/aspects')

function fire_deity(event)
	local caster = event.caster
	local ability = event.ability
	local summonPosition = caster:GetAbsOrigin() + caster:GetForwardVector()*340
	caster.fireAspect = CreateUnitByName("fire_deity", summonPosition, true, caster, caster, caster:GetTeamNumber())
	ability:ApplyDataDrivenModifier(caster, caster.fireAspect, "modifier_aspect_invulnerable", {duration = 1})
	caster.fireAspect.conjuror = caster
	caster.fireAspect.owner = caster:GetPlayerOwnerID()
	caster.fireAspect:SetOwner(caster)
    caster.fireAspect:SetControllableByPlayer(caster:GetPlayerID(), true)
    caster.fireAspect.aspect = true
	local aspectAbility = caster.fireAspect:FindAbilityByName("aspect_abilities")
	aspectAbility:SetLevel(1)
	if caster.bIsAIonFIRE == true or caster.bIsAIonFIRE == nil then
	aspectAbility:ToggleAbility()
    end
    caster.fireAspect.fireDeity = true
	local immolationAbility = caster.fireAspect:FindAbilityByName("fire_deity_fire_ability")
	immolationAbility:SetLevel(1)
	-- aspectAbility:ApplyDataDrivenModifier(caster.fireAspect, caster.fireAspect, "modifier_aspect_main", {})

    local fireParticle = "particles/econ/items/brewmaster/brewmaster_offhand_elixir/brewmaster_thunder_clap_fire_elixir.vpcf"
	local pfx = ParticleManager:CreateParticle( fireParticle, PATTACH_CUSTOMORIGIN, caster.fireAspect )
	ParticleManager:SetParticleControl( pfx, 0, summonPosition )
	ParticleManager:SetParticleControl( pfx, 1, summonPosition )
	ParticleManager:SetParticleControl( pfx, 2, summonPosition )
	ParticleManager:SetParticleControl( pfx, 3, summonPosition )

	EmitSoundOn("Hero_Nevermore.Raze_Flames", caster.fireAspect)
  	local immolation = caster:FindAbilityByName("fire_arcana_ability")
  	if not immolation then
  		immolation = caster:AddAbility("fire_arcana_ability")
  		immolation:SetAbilityIndex(1)
  	end
  	if caster:HasModifier("modifier_conjuror_glyph_1_1") then
  		ability:ApplyDataDrivenModifier(caster, caster.fireAspect, "modifier_conjuror_glyph_1_1_effect", {})
  	end
  	immolation:SetLevel(ability:GetLevel())
	caster:SwapAbilities("summon_fire_deity", "fire_arcana_ability", false, true)
	ability:ApplyDataDrivenModifier(caster, caster.fireAspect, "modifier_fire_aspect", {})
		local aspectHealth = event.aspect_health
		if caster.aspectHealthAbility then
			aspectHealth = aspectHealth + caster:GetModifierStackCount( "modifier_weapon_aspect_health", caster.aspectHealthAbility )
		end
		if caster:HasModifier("modifier_conjuror_glyph_2_1") then
			aspectHealth = aspectHealth*1.8
		end
		local q_1_level = Runes:GetTotalRuneLevel(caster, 1, "q_1", "conjuror")
		aspectHealth = aspectHealth*(1+q_1_level*0.05)
		Timers:CreateTimer(0.05, function()
			caster.fireAspect:SetMaxHealth(aspectHealth)
			caster.fireAspect:SetBaseMaxHealth(aspectHealth)
			caster.fireAspect:SetHealth(aspectHealth)
			caster.fireAspect:Heal(aspectHealth, caster.fireAspect)
		end)
  	if caster:HasModifier("modifier_conjuror_immortal_weapon_3") then
  		caster.fireAspect:AddAbility("fire_temple_steadfast"):SetLevel(1)
  	end

    local q_4_level = Runes:GetTotalRuneLevel(caster, 4, "q_4", "conjuror")
   	caster.fireAspect.q_4_level = q_4_level
   	glyph_5_a(caster, ability, caster.fireAspect)
end

function fire_ability_precast(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Conjuror.FireArcana.BeamCast.VO", caster)
	-- StartAnimation(caster, {duration=1, activity=ACT_DOTA_VERSUS, rate=15.0})
end

function fire_ability_cast(event)
	local caster = event.caster
	local ability = event.ability
	EndAnimation(caster)
	Timers:CreateTimer(0.03, function()
		StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_ATTACK, rate=1.3})
	end)
	local beamLength = 1000
	local point = event.target_points[1] + Vector(0,0,90)
	local particle_name = "particles/econ/items/phoenix/phoenix_solar_forge/phoenix_sunray_solar_forge.vpcf"
	local pfx = ParticleManager:CreateParticle(particle_name, PATTACH_CUSTOMORIGIN, nil)
	-- ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_CUSTOMORIGIN, "attach_attack1", caster:GetAbsOrigin(), true)
	local particleVector = caster:GetAbsOrigin()+Vector(0,0,90) + (caster:GetForwardVector() * beamLength)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()+Vector(0,0,90))
	ParticleManager:SetParticleControl(pfx, 1, particleVector)
	ParticleManager:SetParticleControl(pfx, 3, particleVector)
	ParticleManager:SetParticleControl(pfx, 4, particleVector)
	-- Timers:CreateTimer(3, function()
	-- 	ParticleManager:DestroyParticle(pfx, false)
	-- end)
	ability.pfx = pfx
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_fire_ray_casting", {})
	ability.interval = 0
end

function fire_ray_casting_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local beamLength = 1000
	if ability.pfx then
		local pfx = ability.pfx
		local particleVector = caster:GetAbsOrigin()+Vector(0,0,90) + (caster:GetForwardVector() * beamLength)
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()+Vector(0,0,90))
		ParticleManager:SetParticleControl(pfx, 1, particleVector)
		ParticleManager:SetParticleControl(pfx, 3, particleVector)
		ParticleManager:SetParticleControl(pfx, 4, particleVector)		
	end
	ability.interval = ability.interval + 1
	if ability.interval%30 == 0 then
		StartAnimation(caster, {duration=0.85, activity=ACT_DOTA_ATTACK, rate=1})
	end
	-- caster:SetAbsOrigin(caster:GetAbsOrigin()+caster:GetForwardVector()*4)
end

function fire_ability_off(event)
	local caster = event.caster
	local ability = event.ability
	caster:RemoveModifierByName("modifier_fire_ray_casting")
	StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_ATTACK, rate=1.3})
end

function fire_ray_casting_end(event)
	local caster = event.caster
	local ability = event.ability
	Timers:CreateTimer(0.03, function()
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		if ability.pfx then
			ParticleManager:DestroyParticle(ability.pfx, false)
			ability.pfx = false
		end
	end)
end

function fire_ability_cast_targetted(event)
	local caster = event.caster
	local ability = event.ability
	StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_ATTACK, rate=1.3})
	local particleVector = caster:GetAbsOrigin()+Vector(0,0,90)
	if not ability.beamTable then
		ability.beamTable = {}
	end
	local beam = {}
	local particle_name = "particles/econ/items/phoenix/phoenix_solar_forge/phoenix_sunray_solar_forge.vpcf"
	local pfx = ParticleManager:CreateParticle(particle_name, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()+Vector(0,0,90))
	ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin()+Vector(0,0,90))
	ParticleManager:SetParticleControl(pfx, 3, caster:GetAbsOrigin()+Vector(0,0,90))
	ParticleManager:SetParticleControl(pfx, 4, caster:GetAbsOrigin()+Vector(0,0,90))
	beam.target = event.target
	beam.pfx = pfx
	beam.position = caster:GetAbsOrigin()
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_fire_ray_casting2", {})
	beam.interval = 0
	beam.active = true
	table.insert(ability.beamTable, beam)
	Filters:CastSkillArguments(2, caster)
	-- StartAnimation(caster, {duration=0.85, activity=ACT_DOTA_ATTACK, rate=1})
	EmitSoundOn("Conjuror.FireArcana.BeamCast", caster)
end

function fire_ray_casting_thinker2(event)
	local caster = event.caster
	local ability = event.ability
	local beamLength = 1000
	local damage = event.damage
	local w_2_level = caster:GetRuneValue("w", 2)
	if w_2_level > 0 then
		damage = damage + (CONJUROR_ARCANA_W2_DAMAGE_BONUS_W_PCT/100)*caster:GetAgility()*w_2_level
	end
	local heal_pct = event.heal_pct
	for i = 1, #ability.beamTable, 1 do
		local beam = ability.beamTable[i]
		if beam then
			local moveDirection = ((beam.target:GetAbsOrigin()-beam.position)*Vector(1,1,0)):Normalized()
			beam.position = beam.position + moveDirection*100

			if beam.pfx then
				local pfx = beam.pfx
				local particleVector = beam.position
				ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()+Vector(0,0,90))
				ParticleManager:SetParticleControl(pfx, 1, particleVector+Vector(0,0,90))
				ParticleManager:SetParticleControl(pfx, 3, particleVector+Vector(0,0,90))
				ParticleManager:SetParticleControl(pfx, 4, particleVector+Vector(0,0,90))		
			end
			if beam.interval%1 == 0 then
				local enemies = FindUnitsInRadius( caster:GetTeamNumber(), beam.position, nil, 80, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
				if #enemies > 0 then
					for _,enemy in pairs(enemies) do
						Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PURE, 2, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
					end
				end	
				local allies = FindUnitsInRadius( caster:GetTeamNumber(), beam.position, nil, 80, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
				if #allies > 0 then
					for _,ally in pairs(allies) do
						ally_beam_hit(heal_pct, caster, ability, ally)
					end
				end	
			end
			local distance = WallPhysics:GetDistance2d(beam.position, beam.target:GetAbsOrigin())
			if distance <= 100 then
				beam.position = beam.target:GetAbsOrigin()
				beam.active = false
				if beam.target:GetTeamNumber() == caster:GetTeamNumber() then
					ally_beam_hit(heal_pct, caster, ability, beam.target)
				else
					Filters:TakeArgumentsAndApplyDamage(beam.target, caster, damage, DAMAGE_TYPE_PURE, 2, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
				end			
			end
			beam.interval = beam.interval + 1
		end
	end
	reindex_beam_table(caster, ability)
	-- caster:SetAbsOrigin(caster:GetAbsOrigin()+caster:GetForwardVector()*4)
end

function ally_beam_hit(heal_pct, caster, ability, ally)
	local healAmount = ally:GetMaxHealth()*(heal_pct/100)
	Filters:ApplyHeal(caster, ally, healAmount, true)
	local buffDuration = Filters:GetAdjustedBuffDuration(caster, 7, false)
	ability:ApplyDataDrivenModifier(caster, ally, "modifier_fire_ray_buff", {duration = buffDuration})	
	local w_1_level = caster:GetRuneValue("w", 1)
	if w_1_level > 0 then
		ability:ApplyDataDrivenModifier(caster, ally, "modifier_w1_attack_buff", {duration = buffDuration})
		ally:SetModifierStackCount("modifier_w1_attack_buff", caster, w_1_level)
	end
end

function reindex_beam_table(caster, ability)
	local newBeamTable = {}
	for i = 1, #ability.beamTable, 1 do
		local beam = ability.beamTable[i]
		if beam.active then
			table.insert(newBeamTable, beam)
		else
			ParticleManager:DestroyParticle(beam.pfx, false)
		end
	end
	ability.beamTable = newBeamTable
	if #ability.beamTable == 0 then
		caster:RemoveModifierByName("modifier_fire_ray_casting2")
	end
end

function fire_ray_casting_end2(event)
	local caster = event.caster
	local ability = event.ability
	Timers:CreateTimer(0.03, function()
		-- if ability.pfx then
		-- 	ParticleManager:DestroyParticle(ability.pfx, false)
		-- 	ability.pfx = false
		-- end
	end)	
end

function fire_buff_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local attacker = event.attacker
	local target = event.target
	local mult = caster:GetAbilityByIndex(1):GetLevel()
	local damage = OverflowProtectedGetAverageTrueAttackDamage(attacker) * mult
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_PURE, 2, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_doom_bringer/doom_infernal_blade_impact_d.vpcf", target, 0.5)
end

function fire_deity_spellcast(event)
	local caster = event.caster
	local ability = event.ability
	StartAnimation(caster, {duration=1, activity=ACT_DOTA_ATTACK, rate=1.2})
	local point = event.target_points[1]
	local fv = ((point - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	local start_radius = 200
	local end_radius = 300
	local range = 1200
	local speed = 1200
	local damage = 1000
	EmitSoundOn("Conjuror.FireDeity.Cast", caster)
	local casterOrigin = caster:GetAbsOrigin()
	local projectileParticle = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire_.vpcf"
	local info = 
	{
			Ability = ability,
        	EffectName = projectileParticle,
        	vSpawnOrigin = casterOrigin,
        	fDistance = range,
        	fStartRadius = start_radius,
        	fEndRadius = end_radius,
        	Source = caster,
        	StartPosition = "attach_origin",
        	bHasFrontalCone = true,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
		vVelocity = fv * speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
end

function fire_deity_spell_impact(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local mult = caster.conjuror:GetAbilityByIndex(1):GetLevel()
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster.conjuror)*mult
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
end

function conjuror_arcana2_passive_thinker(event)
	local caster = event.target
	local ability = caster:FindAbilityByName("summon_fire_deity")
	local w_1_level = caster:GetRuneValue("w", 1)
	if w_1_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_deity_attack_pct_w1", {})
		local stacks = w_1_level*((caster:GetIntellect()/10)*CONJUROR_W1_ARCANA_ATTACK_PCT_FROM_INT)
		caster:SetModifierStackCount("modifier_deity_attack_pct_w1", caster, stacks)
	else
		caster:RemoveModifierByName("modifier_deity_attack_pct_w1")
	end
	local w_4_level = caster:GetRuneValue("w", 4)
	if w_4_level > 0 then
		local str_stacks = caster:GetBaseStrength()*((CONJUROR_ARCANA_W4_STR_PCT*w_4_level)/100)*-1
		local agi_stacks = caster:GetBaseAgility()*((CONJUROR_ARCANA_W4_AGI_AND_INT_PCT*w_4_level)/100)
		local int_stacks = caster:GetBaseIntellect()*((CONJUROR_ARCANA_W4_AGI_AND_INT_PCT*w_4_level)/100)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_w_4_agi_increase", {})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_w_4_int_increase", {})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_w_4_str_decrease", {})
		caster:SetModifierStackCount("modifier_w_4_agi_increase", caster, agi_stacks)
		caster:SetModifierStackCount("modifier_w_4_int_increase", caster, int_stacks)
		caster:SetModifierStackCount("modifier_w_4_str_decrease", caster, str_stacks)
	else
		caster:RemoveModifierByName("modifier_w_4_agi_increase")
		caster:RemoveModifierByName("modifier_w_4_str_increase")
		caster:RemoveModifierByName("modifier_w_4_str_decrease")
	end
end