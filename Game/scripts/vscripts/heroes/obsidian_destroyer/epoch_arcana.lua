function ability_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	local d_a_level = Runes:GetTotalRuneLevelGeneric(caster, 4, 0)
	local procs = Runes:Procs(d_a_level, 10, 1)

	for i = 0, procs, 1 do
		Timers:CreateTimer(1.2*i, function()
			if i > 0 then
				StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_ATTACK, rate=1.2})
			end
			local pfx = ParticleManager:CreateParticle("particles/roshpit/epoch/arcana_ability_area.vpcf", PATTACH_CUSTOMORIGIN, caster)
			EmitSoundOnLocationWithCaster(target, "Epoch.ArcanaAbility.Cast", caster)
			local radius = 400 + d_a_level*5
			ParticleManager:SetParticleControl(pfx, 0, target+Vector(0,0,120))
			ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 100, radius))
			Timers:CreateTimer(3, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
			ability.c_a_level = Runes:GetTotalRuneLevelGeneric(caster, 3, 0)
			local rootDuration = event.root_duration
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			if #enemies > 0 then
				for _,enemy in pairs(enemies) do
					Filters:PerformAttackSpecial(caster, enemy, true, true, true, false, true, false, false)
					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_epoch_arcana_root", {duration = rootDuration})
					if ability.c_a_level > 0 then
						c_a_attack_start2(caster, enemy, ability, ability.c_a_level)
					end
				end
			end 
		end)
	end
	Filters:CastSkillArguments(1, caster)
end

function a_a_end(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	local a_a_level = Runes:GetTotalRuneLevelGeneric(caster, 1, 0)

	local damageMult = 2 + a_a_level*0.1
	local damage = target.epochArcanaAA*damageMult
	print(target.epochArcanaAA)
	print(damage)

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_backstab_jumping", {duration = 0.1})
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_PURE, 1, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)
	PopupDamage(target, damage)
	Timers:CreateTimer(0.03, function()
		caster:RemoveModifierByName("modifier_backstab_jumping")
	end)
	target.epochArcanaAA = false

	EmitSoundOn("Epoch.ArcanaAA.Trigger", target)
	local particleName = "particles/roshpit/epoch/arcana_a_a_xplosion.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target)
	for i = 0, 5, 1 do
		ParticleManager:SetParticleControlEnt(pfx, i, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	end
	ParticleManager:SetParticleControl(pfx, 6, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 10, target:GetAbsOrigin())
	Timers:CreateTimer(2.0, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	
end

function arcana_attack(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local c_a_level = Runes:GetTotalRuneLevelGeneric(caster, 3, 0)
	if c_a_level > 0 then
		local delay = caster:GetAttackAnimationPoint()
		Timers:CreateTimer(delay, function()
			c_a_attack_start2(caster, target, ability, c_a_level)
		end)
	end
end

function passive_think(event)
	local caster = event.caster
	local ability = event.ability
	ability.c_a_level = Runes:GetTotalRuneLevelGeneric(caster, 3, 0)
	if ability.c_a_level > 0 then
		local bonusDamage = math.floor(caster:GetMaxMana()*0.015*ability.c_a_level)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_epoch_arcana_attack_damage", {})
		caster:SetModifierStackCount("modifier_epoch_arcana_attack_damage", caster, bonusDamage)
	else
		caster:RemoveModifierByName("modifier_epoch_arcana_attack_damage")
	end
end

function c_a_attack_start2(caster, target, ability, c_a_level)
	local attacker = caster
	local manaDrain = attacker:GetMaxMana()*0.01
	if manaDrain > attacker:GetMana() then
		return nil
	end

	ability.attacker = attacker
	if not attacker:HasModifier("modifier_epoch_c_a_lock") then
		ability:ApplyDataDrivenModifier(caster, attacker, "modifier_epoch_c_a_lock", {duration = 0.1})
		attacker:ReduceMana(manaDrain)
	end
	local damage = manaDrain*c_a_level*5
	local projectileSpeed = attacker:GetProjectileSpeed()
	ability.damage = damage
	local info = 
	{
		Target = target,
		Source = caster,
		Ability = ability,	
		EffectName = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_arcane_orb.vpcf",
		StartPosition = "attach_attack1",
		bDrawsOnMinimap = false, 
	        bDodgeable = true,
	        bIsAttack = true, 
	        bVisibleToEnemies = true,
	        bReplaceExisting = false,
	        flExpireTime = GameRules:GetGameTime() + 5,
		bProvidesVision = false,
		iVisionRadius = 0,
		iMoveSpeed = projectileSpeed,
	}
	projectile = ProjectileManager:CreateTrackingProjectile(info)

end

function c_a_strike(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if not target.dummy then
		Filters:TakeArgumentsAndApplyDamage(target, caster, ability.damage, DAMAGE_TYPE_PURE, 1, RPC_ELEMENT_GHOST, RPC_ELEMENT_TIME)
	end
end