require('/heroes/spirit_breaker/constants')

function begin_revenant_strikes(event)
	local caster = event.caster
	local ability = event.ability
	local forwardVector = caster:GetForwardVector()
	if not ability.phase then
		ability.phase = 0
	end
	local damage = event.damage
	ability.w_1_level = Runes:GetTotalRuneLevel(caster, 1, "w_1", "duskbringer")
	if ability.phase == 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_revenant_strikes_swinging", {duration = 0.3})
		StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_SPAWN, rate=2.6, translate="loadout"})
		revenant_strike(caster, 600, damage, 0.1)
		Timers:CreateTimer(0.09, function()
			EmitSoundOn("Hero_Spirit_Breaker.PreAttack", caster)
			local forwardSpeed = 6
			for i = 1, 7, 1 do
				forwardSpeed = forwardSpeed-0.5
				Timers:CreateTimer(0.03*i, function()
					local position = caster:GetAbsOrigin()
					local obstruction = WallPhysics:FindNearestObstruction(position*Vector(1,1,0))
					local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, position*Vector(1,1,0), caster)
					newPosition = position+forwardVector*forwardSpeed
					if not blockUnit then
						caster:SetOrigin(newPosition)
					end
				end)
			end
		end)
		ability.phase = 1
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_revenant_strikes_state", {duration = 3})
	elseif ability.phase == 1 then
		StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_ATTACK, rate=2.6, translate="charge_attack"})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_revenant_strikes_swinging", {duration = 0.3})
		revenant_strike(caster, 600, damage, 0.03)
		Timers:CreateTimer(0.09, function()
			EmitSoundOn("Hero_Spirit_Breaker.PreAttack", caster)
			local forwardSpeed = 9
			for i = 1, 7, 1 do
				forwardSpeed = forwardSpeed-0.5
				Timers:CreateTimer(0.03*i, function()
					local position = caster:GetAbsOrigin()
					local obstruction = WallPhysics:FindNearestObstruction(position*Vector(1,1,0))
					local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, position*Vector(1,1,0), caster)
					newPosition = position+forwardVector*forwardSpeed
					if not blockUnit then
						caster:SetOrigin(newPosition)
					end
				end)
			end
		end)
		ability.phase = 2
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_revenant_strikes_state", {duration = 3})
	elseif ability.phase == 2 then
		revenant_strike(caster, 600, damage, 0.06)
		StartAnimation(caster, {duration=0.6, activity=ACT_DOTA_SPIRIT_BREAKER_CHARGE_END, rate=1.4, translate="dc_sb_charge_finish"})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_revenant_strikes_swinging", {duration = 0.4})
		ability:StartCooldown(0.4)
		Timers:CreateTimer(0.09, function()
			EmitSoundOn("Hero_Spirit_Breaker.PreAttack", caster)
			local forwardSpeed = 9
			for i = 1, 7, 1 do
				forwardSpeed = forwardSpeed-0.5
				Timers:CreateTimer(0.03*i, function()
					local position = caster:GetAbsOrigin()
					local obstruction = WallPhysics:FindNearestObstruction(position*Vector(1,1,0))
					local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, position*Vector(1,1,0), caster)
					newPosition = position+forwardVector*forwardSpeed
					if not blockUnit then
						caster:SetOrigin(newPosition)
					end
				end)
			end
		end)
		if ability.w_1_level > 0 then
			ability.phase = 3
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_revenant_strikes_state", {duration = 3})
		else
			caster:RemoveModifierByName("modifier_revenant_strikes_state")
			ability.phase = 0
		end
	elseif ability.phase == 3 then
			ability:StartCooldown(0.6)
			local position = caster:GetAbsOrigin()
		    local newPosition = WallPhysics:WallSearch(position, caster:GetAbsOrigin()+forwardVector*200, caster)
		    caster:SetOrigin(newPosition + Vector(0,0,400))
		    ability:ApplyDataDrivenModifier(caster, caster, "modifier_revanant_strikes_a_b_falling", {duration = 3.5})
		    ability.fallspeed = 25
			caster:RemoveModifierByName("modifier_revenant_strikes_state")
			ability.phase = 0
			EmitSoundOn("spirit_breaker_spir_anger_05", caster)
			StartAnimation(caster, {duration=1, activity=ACT_DOTA_SPAWN, rate=1.4})
	end
	Filters:CastSkillArguments(2, caster)
end

function revenant_strikes_combo_end(event)
	local ability = event.ability
	ability.phase = 0
end

function revenant_strikes_a_b_falling(event)
	local caster = event.caster
	local ability = event.ability
	caster:SetOrigin(caster:GetAbsOrigin()-Vector(0,0,ability.fallspeed))
	ability.fallspeed = ability.fallspeed+1
	if caster:GetAbsOrigin().z - GetGroundPosition(caster:GetAbsOrigin(), caster).z < 10 then
		caster:RemoveModifierByName("modifier_revanant_strikes_a_b_falling")
	end
end

function revenant_strike(caster, radius, damage, delay)

	Timers:CreateTimer(delay, function()
		local casterOrigin = caster:GetAbsOrigin()
		local position = casterOrigin + caster:GetForwardVector()*(radius-60)
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	    local w_2_level = Runes:GetTotalRuneLevel(caster, 2, "w_2", "duskbringer")
	    local b_b_damage = 0
	    if w_2_level > 0 then
	    	local manaDrain = caster:GetMaxMana()*0.1
	    	if manaDrain > caster:GetMana() then
	    		manaDrain = caster:GetMana()
	    	end
	    	caster:ReduceMana(manaDrain)
	    	b_b_damage = w_2_level*manaDrain*0.1
			local particleName = "particles/units/heroes/hero_spirit_breaker/duskbringer_b_b_effect.vpcf"
			local pfx = ParticleManager:CreateParticle( particleName, PATTACH_POINT_FOLLOW, caster )
			ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
			Timers:CreateTimer(0.3, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
		end
	    local w_3_level = Runes:GetTotalRuneLevel(caster, 3, "w_3", "duskbringer")
	    local c_b_damage = 0
	    if w_3_level > 0 then
	    	c_b_damage = OverflowProtectedGetAverageTrueAttackDamage(caster)*0.1*w_3_level
	    end
	    damage = damage+b_b_damage+c_b_damage
		if #enemies > 0 then
			EmitSoundOn("Hero_Spirit_Breaker.Attack", caster)
			if #enemies > 2 then
				EmitSoundOn("Hero_Spirit_Breaker.Attack", caster)
			end
			if #enemies > 5 then
				EmitSoundOn("Hero_Spirit_Breaker.Attack", caster)
			end
			for _,enemy in pairs(enemies) do
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, 2)
			end
		end
	end) 		
end

function revenant_strikes_a_b_fall_end(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Hero_EarthShaker.EchoSlamSmall", caster)
	local particleName =  "particles/units/heroes/hero_elder_titan/duskbringer_a_b.vpcf"
	local position = caster:GetAbsOrigin()
	local particleVector = position

	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, particleVector )
	ParticleManager:SetParticleControl( pfx, 1, particleVector )
	ParticleManager:SetParticleControl( pfx, 2, particleVector )
	Timers:CreateTimer(1.5, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	end)  
	-- ScreenShake(position, 200, 0.4, 0.8, 9000, 0, true)
	local baseAbilityDamage = ability:GetSpecialValueFor("damage")
	local damage = ability.w_1_level*640 + 1240 + baseAbilityDamage
	local stunDuration = 0.6
	if caster:HasModifier("modifier_duskbringer_glyph_4_1") then
		damage = damage*4
		stunDuration = 1.2
	end
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, 520, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	local w_4_level = Runes:GetTotalRuneLevel(caster, 4, "w_4", "duskbringer")
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
			Filters:ApplyStun(caster, stunDuration, enemy)
			d_b_apply(caster, enemy, w_4_level, damage)
		end
	end
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
end

function d_b_apply(caster, enemy, w_4_level, damage)
  if w_4_level > 0 then
    local runeAbility = caster.runeUnit4:FindAbilityByName("duskbringer_rune_w_4")
    runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, enemy, "modifier_duskbringer_rune_w_4_visible", {duration = 7})
    local stacksToApply = (damage/100)
    enemy:SetModifierStackCount( "modifier_duskbringer_rune_w_4_visible", runeAbility, stacksToApply )

    runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, enemy, "modifier_duskbringer_rune_w_4_invisible", {duration = 7})
    enemy:SetModifierStackCount( "modifier_duskbringer_rune_w_4_invisible", runeAbility, stacksToApply*w_4_level )
  end
end

function AmplifyDamageParticle( event )
  local target = event.target
  local location = target:GetAbsOrigin()
  local particleName = "particles/units/heroes/hero_slardar/duskbringer_d_d_amp_damage.vpcf"

-- Particle. Need to wait one frame for the older particle to be destroyed
  Timers:CreateTimer(0.01, function() 
    target.AmpDamageParticleDB = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, target)
    ParticleManager:SetParticleControl(target.AmpDamageParticleDB, 0, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(target.AmpDamageParticleDB, 1, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(target.AmpDamageParticleDB, 2, target:GetAbsOrigin())

    ParticleManager:SetParticleControlEnt(target.AmpDamageParticleDB, 1, target, PATTACH_OVERHEAD_FOLLOW, "attach_overhead", target:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(target.AmpDamageParticleDB, 2, target, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
  end)
end

-- Destroys the particle when the modifier is destroyed
function EndAmplifyDamageParticle( event )
  local target = event.target
  ParticleManager:DestroyParticle(target.AmpDamageParticleDB,false)
  target.AmpDamageParticleDB = nil
end