function begin_genesis_orb(event)
	local caster = event.caster
	local ability = event.ability
	local range = event.range
	local fv = caster:GetForwardVector()
	local speed = 1500
	ability.a_b_level = Runes:GetTotalRuneLevel(caster, 1, "a_b", "epoch")
	ability.b_b_level = Runes:GetTotalRuneLevel(caster, 2, "b_b", "epoch")
	local c_b_level = Runes:GetTotalRuneLevel(caster, 3, "c_b", "epoch")
	ability.c_b_level = c_b_level
	print(c_b_level)
	if c_b_level > 0 then
		local stackIncrease = 1
		if caster:HasModifier("modifier_epoch_immortal_weapon_1") then
			stackIncrease = 3
		end
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_epoch_rune_c_b_visible", {})
		local currentStacks = caster:GetModifierStackCount("modifier_epoch_rune_c_b_visible", caster)
		local newStacks = math.min(currentStacks + stackIncrease, 10)
		caster:SetModifierStackCount("modifier_epoch_rune_c_b_visible", caster, newStacks)

		ability:ApplyDataDrivenModifier(caster, caster, "modifier_epoch_rune_c_b_invisible", {})
		caster:SetModifierStackCount("modifier_epoch_rune_c_b_invisible", caster, newStacks*c_b_level)
	end
	d_b(caster, ability)
	if caster:HasModifier("modifier_epoch_immortal_weapon_1") then
		fireGenesisOrb(event.ability, caster:GetAbsOrigin(), range, fv, speed, caster)
		local perpAngle = WallPhysics:rotateVector(fv, math.pi/2)
		fireGenesisOrb(event.ability, caster:GetAbsOrigin()+perpAngle*140, range, fv, speed, caster)
		fireGenesisOrb(event.ability, caster:GetAbsOrigin()-perpAngle*140, range, fv, speed, caster)
	else
		fireGenesisOrb(event.ability, caster:GetAbsOrigin(), range, fv, speed, caster)
	end

    EmitSoundOn("Epoch.GenesisOrb", caster)
    Filters:CastSkillArguments(2, caster)
end

function fireGenesisOrb(ability, origin, range, fv, speed, caster)
    local info = 
    {
        Ability = ability,
          EffectName = "particles/roshpit/epoch/genesis_orb.vpcf",
          vSpawnOrigin = origin,
          fDistance = range,
          fStartRadius = 180,
          fEndRadius = 180,
          Source = caster,
          StartPosition = "attach_attack1",
          bHasFrontalCone = true,
          bReplaceExisting = false,
          iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
          iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
          iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
          fExpireTime = GameRules:GetGameTime() + 5.0,
      bDeleteOnHit = false,
      vVelocity = fv*speed,
      bProvidesVision = false,
    }
    projectile = ProjectileManager:CreateLinearProjectile(info) 
end

function genesis_orb_impact(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	print("GENESIS IMPACT??")
	local damage = event.damage
	if caster:HasModifier("modifier_time_blast_buff") then
		damage = damage * 2
	end
	damage = damage*ability.damageAmp
	if caster:HasModifier("modifier_epoch_glyph_3_1") then
		damage = damage + caster:GetIntellect()*1*ability:GetLevel()
	end
	if caster:HasModifier("modifier_epoch_immortal_weapon_1") then
		damage = damage*2
	end
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)

	if ability.a_b_level > 0 then
		if not ability.pfx then
			local particleName = "particles/roshpit/epoch/epoch_a_b_effect.vpcf"
			local pfx = ParticleManager:CreateParticle( particleName, PATTACH_POINT_FOLLOW, caster )
			ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin()+Vector(0,0,80), true)
			ability.pfx = pfx
		end
		Timers:CreateTimer(1.0, function() 
			if ability.pfx then
				ParticleManager:DestroyParticle(ability.pfx, true)
				ParticleManager:ReleaseParticleIndex(ability.pfx)
				ability.pfx = false
			end
		end) 

		caster:GiveMana(ability.a_b_level*10)
		PopupMana(caster, ability.a_b_level*10)
	end
	if ability.b_b_level > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_epoch_rune_b_b_visible", {duration = 6})
		target:SetModifierStackCount("modifier_epoch_rune_b_b_visible", caster, ability.b_b_level)
	end
end

function epoch_c_b_attack_land(event)
	local target = event.target
	local caster = event.attacker
	local ability = event.ability
	local currentStacks = caster:GetModifierStackCount("modifier_epoch_rune_c_b_visible", caster)
	local newStacks = currentStacks - 1
	if newStacks > 0 then
		caster:SetModifierStackCount("modifier_epoch_rune_c_b_visible", caster, newStacks)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_epoch_rune_c_b_invisible", {})
		caster:SetModifierStackCount("modifier_epoch_rune_c_b_invisible", caster, newStacks*ability.c_b_level)
	else
		caster:RemoveModifierByName("modifier_epoch_rune_c_b_visible")
		caster:RemoveModifierByName("modifier_epoch_rune_c_b_invisible")
	end
	local healAmount = math.floor(ability.c_b_level*1000)
	caster:Heal(healAmount, caster)
	PopupHealing(caster, healAmount)
	if not ability.pfx2 then
		local particleName = "particles/items2_fx/refresher.vpcf"
		local pfx2 = ParticleManager:CreateParticle( particleName, PATTACH_POINT_FOLLOW, caster )
		ParticleManager:SetParticleControlEnt(pfx2, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin()+Vector(0,0,80), true)
		ability.pfx2 = pfx2
	end
	Timers:CreateTimer(1.0, function() 
		if ability.pfx2 then
			ParticleManager:DestroyParticle(ability.pfx2, true)
			ParticleManager:ReleaseParticleIndex(ability.pfx2)
			ability.pfx2 = false
		end
	end) 

end

function genesis_phase_start(event)
	local caster = event.caster
	StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_CAST_ABILITY_2, rate=1.4})
end

function AmplifyDamageParticle( event )
  local target = event.target
  local location = target:GetAbsOrigin()
  if target.AmpDamageParticle then
  	ParticleManager:DestroyParticle(target.AmpDamageParticle,false)
  	target.AmpDamageParticle = false
  end
  local particleName = event.particleName

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
  	target.AmpDamageParticle = false
  end
end

function d_b(caster, ability)
	local d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "epoch")
	if d_b_level > 0 then
		local manaDrain = caster:GetMaxMana()*0.05
		if caster:GetMana() < manaDrain then
			manaDrain = caster:GetMana()
		end
		caster:ReduceMana(manaDrain)
		ability.damageAmp = (manaDrain/100)*0.003*d_b_level + 1
	else
		ability.damageAmp = 1
	end
end