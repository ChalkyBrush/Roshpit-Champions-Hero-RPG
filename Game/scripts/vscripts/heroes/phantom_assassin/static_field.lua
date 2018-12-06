function begin_static_field(event)
	local caster = event.caster
	local ability = event.ability
	local numSparks = event.num_sparks
	StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_ATTACK, rate=1.0, translate="loda"})
	EmitSoundOn("lina_lina_pain_06", caster)
	EmitSoundOn("lina_lina_pain_06", caster)
	EmitSoundOn("lina_lina_pain_06", caster)
	local fv = caster:GetForwardVector()
	for i = -(numSparks/2), numSparks/2, 1 do
		local randomNegative = RandomInt(0,1)
		local mult = 1
		if randomNegative == 1 then
			mult = -1
		end
		local randomRadian = math.pi/RandomInt(7,50)*mult
		local rotatedVector = WallPhysics:rotateVector(fv, randomRadian)
		create_spark(rotatedVector, event)
	end
	caster.e_4_level = Runes:GetTotalRuneLevel(caster, 4, "e_4", "voltex")
	Filters:CastSkillArguments(4, caster)
	d_d_set(caster, ability)
	rune_r_1(caster, ability)
	rune_r_3(caster)
end

function begin_static_channel(event)
	local caster = event.caster
	local ability = event.ability
	StartAnimation(caster, {duration=2.0, activity=ACT_DOTA_ATTACK_EVENT, rate=0.38})
	if caster:HasModifier("modifier_magnet_d_d") then
        Timers:CreateTimer(0.03, function()
            ability:EndChannel(false)
        end)
	end
end

function create_spark(fv, event)
	local ability = event.ability
	local caster = event.caster
	local projectileParticle = "particles/econ/items/zeus/lightning_weapon_fx/voltex_ultimmortal_lightning.vpcf"
	local projectileOrigin = caster:GetAbsOrigin() + fv*10
	local start_radius = 140
	local end_radius = 140
	local range = 1200
	local speed = 400 + RandomInt(0, 250)
		local info = 
		{
				Ability = ability,
	        	EffectName = projectileParticle,
	        	vSpawnOrigin = projectileOrigin+Vector(0,0,60),
	        	fDistance = range,
	        	fStartRadius = start_radius,
	        	fEndRadius = end_radius,
	        	Source = caster,
	        	StartPosition = "attach_attack1",
	        	bHasFrontalCone = true,
	        	bReplaceExisting = false,
	        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	        	fExpireTime = GameRules:GetGameTime() + 4.0,
			bDeleteOnHit = false,
			vVelocity = fv * speed,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
end

function spark_hit(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = event.damage
	if ability.r_4_level then
		damage = damage + OverflowProtectedGetAverageTrueAttackDamage(caster)*0.1*ability.r_4_level
	end
	increment_d_d(caster, ability)
	if caster:HasModifier("modifier_voltex_glyph_6_1") then
		damage = damage*10
	end
	ability:ApplyDataDrivenModifier(caster,target, "modifier_static_field_post_mitigation", {duration = 10})
	local stacks = target:GetModifierStackCount("modifier_static_field_post_mitigation", caster)
	local newStacks = math.min(stacks + 1, 50)
	target:SetModifierStackCount("modifier_static_field_post_mitigation", caster, newStacks)
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_PURE, 4, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
	if caster:HasModifier("modifier_voltex_immortal_weapon_3") then
		caster.weapon:ApplyDataDrivenModifier(caster.InventoryUnit, target, "modifier_voltex_immortal_paralysis", {duration = 4.5})
	end
end

function rune_r_3(caster)
    local runeUnit = caster.runeUnit3
    local ability = runeUnit:FindAbilityByName("voltex_rune_r_3")
    local abilityLevel = ability:GetLevel()
    local bonusLevel = Runes:GetTotalBonus(runeUnit, "r_3")
    local totalLevel = Runes:GetTotalRuneLevel(caster, 3, "r_3", "voltex")
    	if totalLevel > 0 then
    		EmitSoundOn("DOTA_Item.BlackKingBar.Activate", caster)
    		local duration = 12
    		if caster:HasModifier("modifier_voltex_glyph_5_1") then
    			duration = duration + 12
 			end
 			duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
 			if caster:HasModifier("modifier_voltex_glyph_5_1") then
    			ability:ApplyDataDrivenModifier(runeUnit, caster, "modifier_voltex_rune_r_3_buff_glyph_5_1", {duration = duration})
    		end
    		ability:ApplyDataDrivenModifier(runeUnit, caster, "modifier_voltex_rune_r_3_avatar", {duration = duration})
    		ability:ApplyDataDrivenModifier(runeUnit, caster, "modifier_voltex_rune_r_3_buff", {duration = duration})
    		caster:SetModifierStackCount( "modifier_voltex_rune_r_3_buff", ability, totalLevel )

    	end
end
function c_d_think(event)
	local target = event.target
	local ability = event.ability
	local particleName = "particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
	-- ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	-- ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	-- ParticleManager:SetParticleControlEnt(pfx, 3, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	-- ParticleManager:SetParticleControlEnt(pfx, 9, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(pfx,0,target:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx,1,target:GetAbsOrigin() +Vector(0,0,300))
		ParticleManager:SetParticleControl(pfx,2,target:GetAbsOrigin() +Vector(0,0,300))
		ParticleManager:SetParticleControl(pfx,3,target:GetAbsOrigin() +Vector(0,0,300))
		ParticleManager:SetParticleControl(pfx,4,target:GetAbsOrigin() +Vector(0,0,300))
		ParticleManager:SetParticleControl(pfx,5,target:GetAbsOrigin() +Vector(0,0,300))
		ParticleManager:SetParticleControl(pfx,6,target:GetAbsOrigin() +Vector(0,0,300))
		ParticleManager:SetParticleControl(pfx,9,target:GetAbsOrigin())  
	Timers:CreateTimer(0.5, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	end) 	
	
end
function c_d_apply(event)
	local caster = event.target
	caster:SetRangedProjectileName("particles/units/heroes/hero_arc_warden/arc_warden_base_attack.vpcf")
	caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
	print("APPLY AVATAR BROOO")
end

function c_d_end(event)
	local caster = event.target
	caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
end

function rune_r_1(caster, ability)
    local runeUnit = caster.runeUnit
    local runeAbility = runeUnit:FindAbilityByName("voltex_rune_r_1")
    local abilityLevel = runeAbility:GetLevel()
    local bonusLevel = Runes:GetTotalBonus(runeUnit, "r_1")
    local totalLevel = abilityLevel + bonusLevel
    local point = caster:GetAbsOrigin() + caster:GetForwardVector()*300
	if totalLevel > 0 then
		local damage = 1200 + 730*totalLevel
		if ability.r_4_level then
			damage = damage + OverflowProtectedGetAverageTrueAttackDamage(caster)*0.1*ability.r_4_level
		end
		if caster:HasModifier("modifier_voltex_glyph_6_1") then
			damage = damage*30
		end
		local maxLightning = totalLevel + 3
		if maxLightning > 40 then
			maxLightning = 40
		end
		for i = 1, maxLightning, 1 do
			Timers:CreateTimer(0.1*i, function()
				a_d_bolt(caster, ability, damage, point)
			end)
		end
	end
end

function a_d_bolt(caster, ability, damage, point)
		local particleName =  "particles/econ/items/sven/sven_warcry_ti5/sven_warcry_cast_arc_lightning.vpcf"
		local particleVector = blastLocation
		point = point + RandomVector(RandomInt(50, 600))

		local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( pfx, 0, point )
		ParticleManager:SetParticleControl( pfx, 1, Vector(200, 200, 200) )
		Timers:CreateTimer(2, function() 
		  ParticleManager:DestroyParticle( pfx, false )
		end)
		EmitSoundOnLocationWithCaster(point, "Hero_razor.Attack", caster)
		Timers:CreateTimer(0.3, function()
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), point, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			if #enemies > 0 then
				for _,enemy in pairs(enemies) do
					increment_d_d(caster, ability)
					Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
				end
			end 
		end)

end

function d_d_set(caster, ability)
    ability.r_4_level = Runes:GetTotalRuneLevel(caster, 4, "r_4", "voltex")
end

function increment_d_d(caster, ability)
	if ability.r_4_level > 0 then
	  local d_d_duration = Filters:GetAdjustedBuffDuration(caster, 6, false)
      local d_d_ability = caster.runeUnit4:FindAbilityByName("voltex_rune_r_4")
      d_d_ability:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_voltex_rune_r_4_visible", {duration = d_d_duration})
      local newStacks = caster:GetModifierStackCount( "modifier_voltex_rune_r_4_visible", d_d_ability ) + 1
      caster:SetModifierStackCount( "modifier_voltex_rune_r_4_visible", d_d_ability, newStacks )


      d_d_ability:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_voltex_rune_r_4_invisible", {duration = d_d_duration})
      caster:SetModifierStackCount( "modifier_voltex_rune_r_4_invisible", d_d_ability, newStacks*ability.r_4_level )
	end
end