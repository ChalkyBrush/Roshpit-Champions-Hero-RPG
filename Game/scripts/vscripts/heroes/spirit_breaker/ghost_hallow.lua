require('heroes/spirit_breaker/whirling_flail')
require('/heroes/spirit_breaker/constants')

function begin_ghost_hallow(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	Filters:CastSkillArguments(2, caster)
	ability.q_1_level = Runes:GetTotalRuneLevel(caster, 1, "q_1", "duskbringer")
	EmitSoundOnLocationWithCaster(target, "Duskbringer.GhostHallow", caster)
	ability:ApplyDataDrivenThinker(caster, GetGroundPosition(target, caster), "ghost_hallow", {duration = 6})
	StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_ATTACK, rate=2.1})
--	ability.w_4_level = Runes:GetTotalRuneLevel(caster, 4, "w_4", "duskbringer")
--	caster.r_4_level = Runes:GetTotalRuneLevel(caster, 4, "r_4", "duskbringer")
--	if ability.w_4_level > 0 then
--		d_b_ghost_blast(caster, ability, target)
--	end
end
--
--function d_b_ghost_blast(caster, ability, target)
--	local fv = ((target - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
--	local projectileParticle = "particles/roshpit/duskbringer/ghostfire_blast.vpcf"
--	local start_radius = 95
--	local end_radius = 95
--	local range = WallPhysics:GetDistance2d(target,caster:GetAbsOrigin())+140
--	local speed = 1200
--	local info =
--	{
--			Ability = ability,
--        	EffectName = projectileParticle,
--        	vSpawnOrigin = caster:GetAbsOrigin()+Vector(0,0,70),
--        	fDistance = range,
--        	fStartRadius = start_radius,
--        	fEndRadius = end_radius,
--        	Source = caster,
--        	StartPosition = "attach_origin",
--        	bHasFrontalCone = true,
--        	bReplaceExisting = false,
--        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
--        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
--        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
--        	fExpireTime = GameRules:GetGameTime() + 4.0,
--		bDeleteOnHit = false,
--		vVelocity = fv * speed,
--		bProvidesVision = false,
--	}
--	projectile = ProjectileManager:CreateLinearProjectile(info)
--end

--function d_b_projectile_hit(event)
--	local target = event.target
--	local caster = event.caster
--	local ability = event.ability
--	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 280, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
--	if #enemies > 0 then
--		EmitSoundOn("Duskbringer.GhostBlastImpact", target)
--		local particleName = "particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_explosion.vpcf"
--			local pfx2 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN,target )
--			ParticleManager:SetParticleControlEnt(pfx2, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin()+Vector(0,0,40), true)
--			Timers:CreateTimer(1, function()
--			  ParticleManager:DestroyParticle( pfx2, false )
--			end)
--		local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)*ability.w_4_level*0.25
--		local flailAbility = caster:FindAbilityByName("whirling_flail")
--		for _,enemy in pairs(enemies) do
--			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_GHOST, RPC_ELEMENT_FIRE)
--			increment_duskfire_stacks(caster, enemy, flailAbility, ability.w_4_level)
--		end
--	end
--end

function ghost_trap_enter(event)
	-- print("test duskbringer w1")
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local duration = event.duration
	if not target.ghost_hallow_think_interval then target.ghost_hallow_think_interval = 0 end
	if event.apply == 0 then
		target.ghost_hallow_think_interval = target.ghost_hallow_think_interval + 1
	end
	if not target:HasModifier("modifier_ghost_trap_immune") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_ghost_trap_immune", {duration = duration+3})
		ability:ApplyDataDrivenModifier(caster, target, "ghost_hallow_stun", {duration = duration})
		local w_2_level = Runes:GetTotalRuneLevel(caster, 2, "w_2", "duskbringer")
		if w_2_level > 0 then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_ghost_hallow_magic_resist_loss", {duration = duration})
			target:SetModifierStackCount("modifier_ghost_hallow_magic_resist_loss", caster, w_2_level)
		end
		if caster:HasModifier("modifier_duskbringer_glyph_4_1") then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_ghost_hallow_disarm", {duration = duration})
		end
		-- local w_4_level = Runes:GetTotalRuneLevel(caster, 4, "w_4", "duskbringer")
		-- if w_4_level > 0 then
		-- 	local runeAbility = caster.runeUnit4:FindAbilityByName("duskbringer_rune_w_4")
		-- 	runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, target, "modifier_duskbringer_rune_w_4_visible", {duration = duration})
		-- 	runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, target, "modifier_duskbringer_rune_w_4_invisible", {duration = duration})
		-- 	target:SetModifierStackCount("modifier_duskbringer_rune_w_4_invisible", caster.runeUnit4, w_3_level)
		-- end
	end
	-- print("test duskbringer w1 2")
	if target.ghost_hallow_think_interval%10 == 0 or event.apply == 1 then
		ability.w_1_level = Runes:GetTotalRuneLevel(caster, 1, "w_1", "duskbringer")
		ghost_trap_a_b_thinker(event)
		if ability.w_1_level > 0 then
			if not target.duskABparticle then
				target.duskABparticle = CustomAbilities:QuickAttachParticle("particles/roshpit/duskbringer/duskbringer_rune_w_1_2.vpcf", target, 10)
				ParticleManager:SetParticleControl(target.duskABparticle, 1, target:GetForwardVector()*150)
			end
		end
	end
end

function ghost_trap_end(event)
	local caster = event.caster
	local target = event.target
	if target.duskABparticle then
		ParticleManager:DestroyParticle(target.duskABparticle, true)
		target.duskABparticle = nil
		local pfx = ParticleManager:CreateParticle( "particles/roshpit/mountain_protector/unshakable_stone_dust.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin()+Vector(0,0,20))
		ParticleManager:SetParticleControl(pfx, 5, Vector(0.5, 1, 1))
		ParticleManager:SetParticleControl(pfx, 2, Vector(0.1,0.1,0.1))
		Timers:CreateTimer(1, function() 
		  ParticleManager:DestroyParticle( pfx, false )
		  ParticleManager:ReleaseParticleIndex(pfx)
		end)
	end
	target.ghost_hallow_think_interval = nil
end

function ghost_trap_a_b_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	ability.w_1_level = Runes:GetTotalRuneLevel(caster, 1, "w_1", "duskbringer")
	if ability.w_1_level > 0 then
		
		local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)*ability.w_1_level*0.4
		Timers:CreateTimer(0.15, function()
			if target:IsAlive() then
				CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash_flash.vpcf", target:GetAbsOrigin()+Vector(0,0,40), 0.2)
				Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_GHOST, RPC_ELEMENT_NONE)
				EmitSoundOn("Duskbringer.GhostHallowAB", target)
			end

		end)
	end
end

function ghost_hallow_think(event)
	local target = event.target
	local caster = event.caster
	local ability = caster:FindAbilityByName("whirling_flail")
	if caster:HasModifier("modifier_duskbringer_glyph_2_1") and event.ability.q_1_level > 0 then
		if not ability.q_1_level then
			ability.q_1_level = Runes:GetTotalRuneLevel(caster, 1, "q_1", "duskbringer")
			ability.q_4_level = Runes:GetTotalRuneLevel(caster, 4, "q_4", "duskbringer")
		end
		increment_duskfire_stacks(caster, target, ability, 3)
	end

end

function update_w_3_level(event)
	local ability = event.ability
	local caster = event.caster
	ability.w_3_level = Runes:GetTotalRuneLevel(caster, 3, "w_3", "duskbringer")
end

function duskbringer_take_damage(event)
	local target = event.caster
	local ability = event.ability
	if ability.w_3_level > 0 then
		Timers:CreateTimer(0.06, function()
			if target:IsAlive() then
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_oracle/duskbringer_c_a_heal_heal_core.vpcf", target, 1)
				local healAmount = ability.w_3_level*200
				Filters:ApplyHeal(target, target, healAmount, true)
			end
		end)
	end
end

function duskbringer_passive_think(event)
	local caster = event.caster
	caster.w_4_level = Runes:GetTotalRuneLevel(caster, 4, "w_4", "duskbringer")
end
