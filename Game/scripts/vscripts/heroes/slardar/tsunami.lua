require('heroes/slardar/hydroxis_constants')

function start_channel(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Hydroxis.Ultimate.Voice", caster)

	ability.r_2_level = Runes:GetTotalRuneLevel(caster, 2, "r_2", "hydroxis")
	if ability.r_2_level > 0 then
		local b_d_duration = Filters:GetAdjustedBuffDuration(caster, 12, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_hydroxis_b_d", {duration = b_d_duration})
	end
	caster.e_4_level = caster:GetRuneValue("e", 4)

	if caster:HasModifier("modifier_hydroxis_glyph_6_1") then
		channel_complete(event)
		caster:Stop()
	else
		StartSoundEvent("Hydroxis.WaterChannel", caster)
	end
end



function channel_complete(event)
	local caster = event.caster
	local ability = event.ability
	-- CustomAbilities:QuickAttachParticle("particles/econ/items/monkey_king/arcana/water/monkey_king_spring_arcana_water.vpcf", caster, 7)
	local castLoops = 0
    if caster:HasModifier("modifier_hydroxis_glyph_1_1") then
      castLoops = 1
    end
	for i = 0, castLoops, 1 do
		Timers:CreateTimer(i*2, function()
			local pfx = ParticleManager:CreateParticle("particles/roshpit/hydroxis/ocean_quake.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
			ParticleManager:SetParticleControl(pfx, 1, Vector(600, 2, 2))
			StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_CAST_ABILITY_2, rate=0.8})
			EmitSoundOn("Hydroxis.Ultimate.Start", caster)
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hydroxis.HydroPump.Start", Events.GameMaster)
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hydroxis.Ultimate.Start2", caster)

			StopSoundEvent("Hydroxis.WaterChannel", caster)
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 520, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )

			local hydroxis_tsunami_ability = caster:FindAbilityByName("hydroxis_tsunami")

			local hydroxis_tsunami_ability_LVL = hydroxis_tsunami_ability:GetLevel()-1

			-- print("hydroxis / "..hydroxis_tsunami_ability:GetLevelSpecialValueFor("strength_damage", hydroxis_tsunami_ability_LVL))
			-- print("hydroxis / "..hydroxis_tsunami_ability:GetLevelSpecialValueFor("stun_duration", hydroxis_tsunami_ability_LVL))
			-- print("hydroxis / "..hydroxis_tsunami_ability:GetLevelSpecialValueFor("slow_duration", hydroxis_tsunami_ability_LVL))

			damage = hydroxis_tsunami_ability:GetLevelSpecialValueFor("strength_damage", hydroxis_tsunami_ability_LVL)*caster:GetStrength()
			stunDuration = hydroxis_tsunami_ability:GetLevelSpecialValueFor("stun_duration", hydroxis_tsunami_ability_LVL)
			slow_duration = hydroxis_tsunami_ability:GetLevelSpecialValueFor("slow_duration", hydroxis_tsunami_ability_LVL) + stunDuration

			local r_1_level = caster:GetRuneValue("r", 1)
			ability.r_1_level = r_1_level
			damage = damage * (1 + HYDROXIS_R1_BAD_PCT_PER_ARMOR * r_1_level * caster:GetPhysicalArmorValue())
			if #enemies > 0 then
				for _,enemy in pairs(enemies) do
					Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_WATER, RPC_ELEMENT_EARTH)
					Filters:ApplyStun(caster, stunDuration, enemy)
					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_ocean_quake_slowed", {duration = slow_duration})
					if r_1_level > 0 then
						ability:ApplyDataDrivenModifier(caster, enemy, "modifier_hydroxis_a_d", {duration = slow_duration})
						enemy:SetModifierStackCount("modifier_hydroxis_a_d", caster, r_1_level)
					end
				end
			end 
			
			Filters:CastSkillArguments(4, caster)
			Timers:CreateTimer(6, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)

			local c_d_level = Runes:GetTotalRuneLevel(caster, 3, "r_3", "hydroxis")

			if c_d_level > 0 then
				local baseCD = 12
				if caster:HasModifier("modifier_hydroxis_glyph_7_1") then
					baseCD = baseCD + 5
				end
				local c_d_duration = Filters:GetAdjustedBuffDuration(caster, baseCD, false)
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_hydroxis_c_d_poseidons_wrath", {duration = c_d_duration})
				caster:SetRenderColor(90, 90, 255)
			end
			if caster:HasAbility("hydroxis_water_blade") then
				local waterBombAbility = caster:FindAbilityByName("hydroxis_water_blade")
				waterBombAbility.r_3_level = c_d_level
				waterBombAbility.r_1_level = r_1_level
			else
				local arcanaAbility = caster:FindAbilityByName("hydroxis_arcana_ability_1")
				arcanaAbility.r_3_level = c_d_level
				arcanaAbility.r_1_level = r_1_level
			end
		end)
	end
	ability.r_4_level = Runes:GetTotalRuneLevel(caster, 4, "r_4", "hydroxis")
	if ability.r_4_level > 0 then
		local modelName = "models/hydroxis/hydroxis_water_pool.vmdl"
		local thinkerName = "modifier_drowning_pool_thinker"
		if caster:HasModifier("modifier_hydroxis_glyph_6_1") then
			modelName = "models/hydroxis/hydroxis_water_pool_glyphed.vmdl"
			thinkerName = "modifier_drowning_pool_thinker_glyphed"
		end
		local prop = SpawnEntityFromTableSynchronous("prop_dynamic", {origin = caster:GetAbsOrigin()+Vector(0,0,10)})
		prop:SetModel(modelName)
		local poolDuration = 9
		--ability:ApplyDataDrivenThinker(caster, GetGroundPosition(caster:GetAbsOrigin(), caster), thinkerName, {duration = poolDuration})
		CustomAbilities:QuickAttachThinker(ability, caster, GetGroundPosition(caster:GetAbsOrigin(), thinkerName, {duration = poolDuration})
		Timers:CreateTimer(poolDuration, function()
			for j = 1, 20, 1 do
				Timers:CreateTimer(j*0.03, function()
					prop:SetAbsOrigin(prop:GetAbsOrigin()-Vector(0,0,2))
				end)
			end
			Timers:CreateTimer(0.7, function()
				UTIL_Remove(prop)
			end)
		end)
	end
end

function drowning_pool_aura_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if caster:GetEntityIndex() == target:GetEntityIndex() then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_drowning_pool_actual_effect", {})
		target:SetModifierStackCount("modifier_drowning_pool_actual_effect", caster, ability.r_4_level)
	end
end

function drowning_pool_aura_end(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	target:RemoveModifierByName("modifier_drowning_pool_actual_effect")
end


function poseidons_wrath_end(event)
	local caster = event.caster
	caster:SetRenderColor(255, 255, 255)
end

function channel_interrupt(event)
	local caster = event.caster
	StopSoundEvent("Hydroxis.WaterChannel", caster)
end

function AmplifyDamageParticle( event )
  local target = event.target
  local location = target:GetAbsOrigin()
  local particleName = "particles/roshpit/hydroxis/hydroxis_a_d_amp.vpcf"
  if target.AmpDamageParticle then
  	ParticleManager:DestroyParticle(target.AmpDamageParticle, false)
  end
-- Particle. Need to wait one frame for the older particle to be destroyed
  Timers:CreateTimer(0.01, function() 
    target.AmpDamageParticle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, target)
    ParticleManager:SetParticleControl(target.AmpDamageParticle, 0, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(target.AmpDamageParticle, 1, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(target.AmpDamageParticle, 2, target:GetAbsOrigin())

    ParticleManager:SetParticleControlEnt(target.AmpDamageParticle, 1, target, PATTACH_OVERHEAD_FOLLOW, "attach_overhead", target:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(target.AmpDamageParticle, 2, target, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
  end)


end

-- Destroys the particle when the modifier is destroyed
function EndAmplifyDamageParticle( event )
  local target = event.target
  	if target.AmpDamageParticle then
	  ParticleManager:DestroyParticle(target.AmpDamageParticle,false)
	  target.AmpDamageParticle = nil
	end
end

function tsunami_think(event)
	local target = event.caster
	local caster = event.caster
	local ability = event.ability
	local fv = target:GetForwardVector()
	ability.pushFV = fv
	local perpFv = WallPhysics:rotateVector(fv,math.pi/2)
	local hurricaneStartPosition = target:GetAbsOrigin() - fv*600 + perpFv*(RandomInt(-420, 420))
	local range = 1500
	local start_radius = 300
	local end_radius = 300
	local speed = 1000
	local projectileParticle = "particles/units/heroes/hero_tidehunter/tidehunter_gush_upgrade.vpcf"
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hydroxis.BDWave", caster)
	local info = 
	{
			Ability = ability,
        	EffectName = projectileParticle,
        	vSpawnOrigin = hurricaneStartPosition,
        	fDistance = range,
        	fStartRadius = start_radius,
        	fEndRadius = end_radius,
        	Source = target,
        	StartPosition = "attach_origin",
        	bHasFrontalCone = false,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 6.0,
		bDeleteOnHit = false,
		vVelocity = fv * speed,
		bProvidesVision = true,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info) 	
end

function tsunami_impact(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local damage = 85000*ability.r_2_level * (1 + HYDROXIS_R1_BAD_PCT_PER_ARMOR * ability.r_1_level * caster:GetPhysicalArmorValue()) * HYDROXIS_R1_RUNE_MULT
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_WATER, RPC_ELEMENT_NONE)
	local slow_duration = event.slow_duration
	ability:ApplyDataDrivenModifier(caster, target, "modifier_ocean_quake_slowed", {duration = slow_duration})
end

function poseidons_wrath_attack_land(event)
	local attacker = event.attacker
	local target = event.target
	local ability = attacker:FindAbilityByName("hydroxis_water_blade")
	if attacker:HasAbility("hydroxis_arcana_ability_1") then
		ability = attacker:FindAbilityByName("hydroxis_arcana_ability_1")
	end
	EmitSoundOn("Hydroxis.CDGush", target)
	-- local fv = attacker:GetForwardVector()
	local radius = 300
	if attacker:HasModifier("modifier_hydroxis_immortal_weapon_1") then
		radius = 450
	end
	local enemies = FindUnitsInRadius( attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for i = 1, #enemies, 1 do
			if i <= 12 then
				local enemy = enemies[i]
				-- local targetAngle = ((enemy:GetAbsOrigin()-attacker:GetAbsOrigin())*Vector(1,1,0)):Normalized()
				-- local angleDifferential = math.acos(fv:Dot(targetAngle, fv))
				local source = target
				if enemy:GetEntityIndex() == attacker:GetEntityIndex() then
					source = attacker
				end
				-- if angleDifferential < math.pi/2 then
					local info = 
					{
						Target = enemy,
						Source = attacker,
						Ability = ability,	
						EffectName = "particles/roshpit/hydroxis/hydroxis_r_3_projectile.vpcf",
						StartPosition = "attach_attack1",
						bDrawsOnMinimap = false, 
					        bDodgeable = true,
					        bIsAttack = false, 
					        bVisibleToEnemies = true,
					        bReplaceExisting = false,
					        flExpireTime = GameRules:GetGameTime() + 2,
						bProvidesVision = false,
						iVisionRadius = 0,
						iMoveSpeed = 1800,
						iVisionTeamNumber = attacker:GetTeamNumber()
					}
					projectile = ProjectileManager:CreateTrackingProjectile(info)
				-- end
			end
		end
		-- ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
	end
end

function poseidon_wrath_attack_hit(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = ability.r_3_level*0.35*OverflowProtectedGetAverageTrueAttackDamage(caster) * (1 + HYDROXIS_R1_BAD_PCT_PER_ARMOR * ability.r_1_level * caster:GetPhysicalArmorValue()) * HYDROXIS_R1_RUNE_MULT
	if caster:HasModifier("modifier_hydroxis_immortal_weapon_1") then
		damage = damage*2
	end
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_PURE, 0, RPC_ELEMENT_WATER, RPC_ELEMENT_NONE)
end