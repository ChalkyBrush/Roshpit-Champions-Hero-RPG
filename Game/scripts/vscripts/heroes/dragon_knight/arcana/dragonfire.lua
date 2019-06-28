function turn_toggle_on(event)
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_flamewaker_dragonflame", {})
	StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_CAST_ABILITY_2, rate=0.5, translate="iron"})
	ability.flame = false
	Timers:CreateTimer(0.3, function()
		if caster:HasModifier("modifier_flamewaker_dragonflame") and ability.flame then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_dragonflame_freeze_effect", {})
		end
	end)
	Timers:CreateTimer(0.2, function()
		if caster:HasModifier("modifier_flamewaker_dragonflame") then
			StartSoundEvent("Flamewaker.Dragonfire.LP", caster)
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_red.vpcf", caster, 3)
			EmitSoundOn("Flamewaker.Dragonfire.Fire", caster)
			ability.flame = true
			Filters:CastSkillArguments(2, caster)
		end
	end)
	if not ability.soundLock then
		ability.soundLock = true
		EmitSoundOn("Flamewaker.Dragonfire.Start.Vo", caster)
		Timers:CreateTimer(2, function()
			ability.soundLock = false
		end)
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_dragonflame_shield_waiter", {duration = 1.5})
	ability.w_3_level = caster:GetRuneValue("w", 3)
end

function turn_toggle_off(event)
	local caster = event.caster
	local ability = event.ability
	if ability.flame then
		for i = 0, 2, 1 do
			Timers:CreateTimer(0.1*i, function()
				local fv = caster:GetForwardVector()
				for j = -1, 1, 1 do
					local rotatedFV = WallPhysics:rotateVector(fv, 2*math.pi*j/16)
					dragonflame_projectile(caster, ability, 1600, rotatedFV, ability.movespeed)
				end
			end)
		end
	end

	caster:RemoveModifierByName("modifier_flamewaker_dragonflame")
	caster:RemoveModifierByName("modifier_dragonflame_freeze_effect")
	ability.flame = false
	StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_CAST_ABILITY_2, rate=1.3, translate="iron"})
	Timers:CreateTimer(0.1, function()
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_red.vpcf", caster, 3)
		StopSoundEvent("Flamewaker.Dragonfire.LP", caster)
		EmitSoundOn("Flamewaker.Dragonfire.Fire", caster)
	end)
	if not ability.soundLock then
		EmitSoundOn("Flamewaker.Dragonfire.End.Vo", caster)
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_dragonflame_shield", {duration = 2})
	caster:RemoveModifierByName("modifier_dragonflame_shield_waiter")
end

function shield_waiter_end(event)
	local caster = event.caster
	local ability = event.ability
	if caster:HasModifier("modifier_flamewaker_dragonflame") then
		EmitSoundOn("Flamewaker.Dragonfire.ShieldApply", caster)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_dragonflame_shield", {})

        local w_2_level = caster:GetRuneValue("w", 2)
        if w_2_level > 0 then
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_b_b_shimmer", {})
            caster:SetModifierStackCount("modifier_b_b_shimmer", caster, w_2_level)
        end
	end
end

function dragonflame_think(event)
	local caster = event.caster
	local ability = event.ability
	local mana_drain = event.mana_drain/10
	if not ability.fv then
		ability.fv = caster:GetForwardVector()
	end
	
	if ability.flame then
		if not ability.movespeed then
			ability.movespeed = 0
			ability.lastPos = caster:GetAbsOrigin()
		end
		if not ability.interval then
			ability.interval = 0
		end
		ability.fv = WallPhysics:rotateVector(ability.fv, 2*math.pi/30)
		local fv = caster:GetForwardVector()
		-- ability.fv = WallPhysics:rotateVector(ability.fv, 2*math.pi*ability.interval/90)
		ability.interval = ability.interval + 1
		ability.movespeed = WallPhysics:GetDistance2d(ability.lastPos, caster:GetAbsOrigin())/0.5 + 120
		for i =-1, 1, 1 do
			local rotatedFV = WallPhysics:rotateVector(fv, 2*math.pi*i/16)
			dragonflame_projectile(caster, ability, 280, rotatedFV, ability.movespeed)
		end
		ability.lastPos = caster:GetAbsOrigin()
		if ability.interval%5 == 0 then
			Filters:CastSkillArguments(2, caster)
		end
		if ability.interval > 90 then
			ability.interval = 0
		end
		if caster:GetMana() > mana_drain then
			caster:ReduceMana(mana_drain)
		else
			ability:ToggleAbility()
		end
	end
end

function dragonflame_projectile(caster, ability, range, fv, pullback)
	local projectileParticle = "particles/roshpit/flamewaker/dragonfire.vpcf"
	if caster:HasModifier("modifier_flamewaker_glyph_4_1") then
		projectileParticle = "particles/roshpit/flamewaker/arcana/bluedragon.vpcf"
	end
	local projectileOrigin = caster:GetAbsOrigin()
	local start_radius = 320
	local end_radius = 320
	local speed = 1200
	local info = 
	{
			Ability = ability,
        	EffectName = projectileParticle,
        	vSpawnOrigin = projectileOrigin+Vector(0,0,20)+fv*pullback,
        	fDistance = range,
        	fStartRadius = start_radius,
        	fEndRadius = end_radius,
        	Source = caster,
        	StartPosition = "attach_attack1",
        	bHasFrontalCone = false,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 4.0,
		bDeleteOnHit = false,
		vVelocity = fv * speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
end

function flame_proj_hit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local base_damage = event.base_damage
	local attack_dmg_bonus = event.attack_dmg_bonus
	local w_3_level = caster:GetRuneValue("w", 3)
	attack_dmg_bonus = attack_dmg_bonus + w_3_level * 5
	local damage = base_damage + (attack_dmg_bonus/100)*OverflowProtectedGetAverageTrueAttackDamage(caster)
	if caster:HasModifier("modifier_flamewaker_glyph_4_1") then
		damage = damage + ((caster:GetStrength() + caster:GetAgility() + caster:GetIntellect())*5 + OverflowProtectedGetAverageTrueAttackDamage(caster)*0.2)*ability:GetLevel()
		ability:ApplyDataDrivenModifier(caster, target, "modifier_flamewaker_glyph_4_1_effect", {duration = 3})
	end
	ability:ApplyDataDrivenModifier(caster, target, "modifier_dragonflame_armor_shred", {duration = 0.5})
	local stacks = target:GetModifierStackCount("modifier_dragonflame_armor_shred", caster)
	target:SetModifierStackCount("modifier_dragonflame_armor_shred", caster, stacks + 1)
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_W, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
end

function dragon_attack(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
    local w_3_level = caster:GetRuneValue("w", 3)
    local speed = -30
    if ability.movespeed then
    	speed = ability.movespeed - 30
    end
    if w_3_level > 0 then
		local fv = ((target:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		local range = 300 + w_3_level*5
		dragonflame_projectile(caster, ability, range, fv, speed)
	end
end

function dragonfire_passive_think(event)
	local caster = event.caster
	local ability = event.ability
	local w_4_level = caster:GetRuneValue("w", 4)
	if w_4_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_d_b_attack_power", {})
		local atkPowerBonus = caster:GetAgility()*0.6*w_4_level
		local stacks =  math.floor(atkPowerBonus/10)
		caster:SetModifierStackCount("modifier_d_b_attack_power", caster, stacks)
	else
		caster:RemoveModifierByName("modifier_d_b_attack_power")
	end
end