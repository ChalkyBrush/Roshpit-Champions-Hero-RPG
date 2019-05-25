require('heroes/juggernaut/seinaru_constants')

function gorudo_start(event)
	local caster = event.caster
	local ability = event.ability
	local duration = event.duration
	local att_per_agi = event.att_per_agi
	duration = Filters:GetAdjustedBuffDuration(caster, duration, false)

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_seinaru_gorudo_magic_immunity", {duration = duration})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_seinaru_gorudo_att_bonus_visible", {duration = duration})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_seinaru_gorudo_att_bonus_invisible", {duration = duration})
	local bonus_att_damage = event.att_per_agi * caster:GetAgility()
	if caster:HasModifier('modifier_seinaru_glyph_7_1') then
		bonus_att_damage = event.att_per_agi * (SEINARU_GLYPH7_AGI_PART * caster:GetAgility() + SEINARU_GLYPH7_STR_PART * caster:GetStrength())
	end
	caster:SetModifierStackCount("modifier_seinaru_gorudo_att_bonus_invisible", caster, bonus_att_damage)

	EmitSoundOn("Seinaru.Gorudo", caster)
	Timers:CreateTimer(0.05, function()
		StartAnimation(caster, {duration=0.6, activity=ACT_DOTA_ATTACK_EVENT, rate=0.8})
		EmitSoundOn("Hero_Juggernaut.BladeDance", caster)
	end)
	Timers:CreateTimer(0.1, function()
		EmitSoundOn("Seinaru.GorudoGrowl", caster)
	end)
  local particleName = "particles/roshpit/seinaru/seinaru_d_b_ring.vpcf"
  local position = caster:GetAbsOrigin()
  local b_d_level = caster:GetRuneValue("r", 2)
  ability.r_4_level = caster:GetRuneValue("r", 4)
  if b_d_level > 0 then
	  	local radius = 500+b_d_level*5
	  	local ringDuration = 8+b_d_level*0.1
	  	local speed = 200
		local dummy = CreateUnitByName("dummy_unit_vulnerable", position, false, caster, caster, caster:GetTeam())
		dummy:AddAbility("dummy_unit")
		dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
		ability:ApplyDataDrivenModifier(caster, dummy, "modifier_gorudo_thinker", {})
		dummy.movementTicks = (radius/speed)*10
		dummy.duration = (radius/speed)*2*10+ringDuration*10
		dummy.thinks = 0
		dummy.shrinkThinks = 0
		dummy.position = position
		dummy.radius = radius
		dummy.speed = speed

  		local pattach = nil

	    if caster:HasModifier("modifier_seinaru_glyph_5_a") then
		    pattach = PATTACH_ABSORIGIN_FOLLOW
		else
			pattach = PATTACH_CUSTOMORIGIN
	    end
	   	dummy.pfx = ParticleManager:CreateParticle(particleName, pattach, caster)
	    ParticleManager:SetParticleControl(dummy.pfx, 0, position)
	    ParticleManager:SetParticleControl(dummy.pfx, 1, Vector(speed, radius, 600))
	    Timers:CreateTimer(ringDuration+(radius/speed), function()


	    	ParticleManager:SetParticleControl(dummy.pfx, 1, Vector(speed, -radius, 600))
	    	-- Timers:CreateTimer(radius/speed, function()

	    	-- end)
	    end)
	end
	local casterOrigin = caster:GetAbsOrigin()
	local fv = caster:GetForwardVector()
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), casterOrigin+fv*140, nil, 320, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	local modifierKnockback =
	{
		center_x = casterOrigin.x,
		center_y = casterOrigin.y,
		center_z = casterOrigin.z,
		duration = 0.28,
		knockback_duration = 0.26,
		knockback_distance = 140,
		knockback_height = 20,
	}
      
	if #enemies > 0 then
		EmitSoundOn("Hero_Juggernaut.Attack", caster)
		for _,enemy in pairs(enemies) do
			enemy:AddNewModifier( caster, nil, "modifier_knockback", modifierKnockback )	
			local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)*3
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, 4, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
			-- ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL })	
		end
	end
	Filters:CastSkillArguments(4, caster)
end

function gorudo_b_d_think(event)
	local caster = event.caster
	local ability = event.ability
	local dummy = event.target
	dummy.thinks = dummy.thinks + 1
	local radius = dummy.radius
	local thinks = dummy.thinks
	if dummy.thinks < dummy.movementTicks then
		radius = dummy.speed*thinks/10
	elseif dummy.thinks > dummy.duration - dummy.movementTicks then
		dummy.shrinkThinks = dummy.shrinkThinks + 1
		radius = radius - dummy.speed*(dummy.shrinkThinks/10)
	end
	local position = nil
	if caster:HasModifier("modifier_seinaru_glyph_5_a") then
		position = caster:GetAbsOrigin()
	else
		position = dummy.position
	end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
	for i = 1, #enemies, 1 do
		ability:ApplyDataDrivenModifier(caster, enemies[i], "modifier_gorudo_b_d_inside_ring", {duration = 0.12})
	end
	if dummy.thinks == dummy.duration - 2 then
		EmitSoundOn("Seinaru.BDend", dummy)
	end
	if dummy.thinks >= dummy.duration then
		ParticleManager:DestroyParticle(dummy.pfx, false)
		UTIL_Remove(dummy)
	end
end

function start_gorudo_channel(event)
	local caster = event.caster
	local ability = event.ability
	StartAnimation(caster, {duration=2.0, activity=ACT_DOTA_TAUNT, rate=1, translate="face_me"})
	-- caster:SetAnimation("idle_spin_sword")
end

function AmplifyDamageParticle( event )
  local target = event.target
  local location = target:GetAbsOrigin()
  local particleName = "particles/roshpit/seinaru/seinaru_a_d_amp_damage.vpcf"


  Timers:CreateTimer(0.01, function() 
    target.AmpDamageParticle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, target)
    ParticleManager:SetParticleControl(target.AmpDamageParticle, 0, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(target.AmpDamageParticle, 1, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(target.AmpDamageParticle, 2, target:GetAbsOrigin())

    ParticleManager:SetParticleControlEnt(target.AmpDamageParticle, 1, target, PATTACH_OVERHEAD_FOLLOW, "attach_overhead", target:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(target.AmpDamageParticle, 2, target, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
  end)
end


function EndAmplifyDamageParticle( event )
  local target = event.target
  if target.AmpDamageParticle then
  	ParticleManager:DestroyParticle(target.AmpDamageParticle,false)
  end
end

function gorudo_attack_start(event)
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	local a_d_level = attacker:GetRuneValue("r", 1)
	if a_d_level > 0 then
		Seinaru_Apply_E4(attacker, target, ability)
	end
end

function gorudo_attack_land(event)
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	if attacker:HasModifier("modifier_seinaru_gorudo_att_bonus_visible") then
		local c_d_level = attacker:GetRuneValue("r", 3)
		if c_d_level > 0 then
			local critModifier = attacker:FindModifierByName("modifier_seinaru_a_a_crit")
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_monkey_king/monkey_king_spring_cast_rays.vpcf", target, 3)
			local damage = OverflowProtectedGetAverageTrueAttackDamage(attacker)*c_d_level*SEINARU_R3_DMG_PER_ATT
			if critModifier then
				local arcanaAbility = critModifier:GetAbility()
				damage = damage * SEINARU_ARCANA_Q1_CRIT_DMG * arcanaAbility.q_1_level
			end
			if attacker:HasModifier("modifier_seinaru_glyph_3_1") then
				local enemies = FindUnitsInRadius( attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, SEINARU_GLYPH3_R3_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
				for _,enemy in pairs(enemies) do
					if not enemy.dummy then
						Filters:TakeArgumentsAndApplyDamage(enemy, attacker, damage, DAMAGE_TYPE_PURE, 4, RPC_ELEMENT_HOLY, RPC_ELEMENT_NORMAL)
					end
				end
			else
				Filters:TakeArgumentsAndApplyDamage(target, attacker, damage, DAMAGE_TYPE_PURE, 4, RPC_ELEMENT_HOLY, RPC_ELEMENT_NORMAL)
			end
		end
	end
end


function Seinaru_Apply_E4(attacker, target, ability)
	if IsValidEntity(target) then
		local currentStacks = target:GetModifierStackCount("modifier_gorudo_rune_r_1", attacker)
		local currentArmor = target:GetPhysicalArmorValue(true) + currentStacks
		local ArmorRed = 0
		local r_1_level = attacker:GetRuneValue("r", 1)
		local e_4_level = attacker:GetRuneValue("e", 4)
		if attacker:HasAbility("seinaru_odachi_leap") then
			ArmorRed = math.min(currentArmor + SEINARU_E4_MAX_NEG_ARMOR * e_4_level, r_1_level * SEINARU_R1_ARMOR_RED)
		else
			ArmorRed = math.min(currentArmor, r_1_level * SEINARU_R1_ARMOR_RED)
		end
		if ArmorRed > 0 then
			ability:ApplyDataDrivenModifier(attacker, target, "modifier_gorudo_rune_r_1", {duration = 8})
			target:SetModifierStackCount("modifier_gorudo_rune_r_1", attacker, ArmorRed)
		end
	end
end

function gorudo_passive_think(event)
	local caster = event.caster
	caster.e_4_level = caster:GetRuneValue("e", 4)
end