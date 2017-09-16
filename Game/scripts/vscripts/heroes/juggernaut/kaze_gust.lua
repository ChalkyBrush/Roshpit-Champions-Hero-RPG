function begin_kaze_gust(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	local range = event.range
	if caster:HasModifier("modifier_monk_glyph_1_1") then
		range = range + 200
	end	
	local speed = range + 200

	EmitSoundOn("Seinaru.KazeYell", caster)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Seinaru.KazeGust", caster)

	local fv = ((target-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	ability.fv = fv

	caster:RemoveModifierByName("modifier_seinaru_rune_a_a")
	caster:RemoveModifierByName("modifier_seinaru_rune_a_a_invisible")
	local startPoint = caster:GetAbsOrigin()
	ability.castPosition = startPoint
	local particle = "particles/roshpit/seinaru/kaze_gust_wave.vpcf"
	local start_radius = 340
	local end_radius = 340
	ability.a_a_level = Runes:GetTotalRuneLevel(caster, 1, "a_a", "monk")
	local b_a_level = Runes:GetTotalRuneLevel(caster, 2, "b_a", "monk")
	ability.b_a_level = b_a_level
	if b_a_level > 0 then
		local b_a_duration = Filters:GetAdjustedBuffDuration(caster, 10, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_seinaru_b_a_speed", {duration = b_a_duration})
		caster:SetModifierStackCount("modifier_seinaru_b_a_speed", caster, b_a_level)
	end
	ability.c_a_level = Runes:GetTotalRuneLevel(caster, 3, "c_a", "monk")
	ability.damage = event.damage
	if ability.c_a_level > 0 then
		local c_a_duration = 0.5 + 0.15*ability.c_a_level
		c_a_duration = Filters:GetAdjustedBuffDuration(caster, c_a_duration, false)
		ability:ApplyDataDrivenModifier(caster, caster, "seinaru_rune_c_a_evasion", {duration = c_a_duration})

		ability.damage = ability.damage + caster:GetAgility()*0.1*ability.c_a_level
	end
	local d_a_level = Runes:GetTotalRuneLevel(caster, 4, "d_a", "monk")
	if d_a_level > 0 then
		ability.damage = ability.damage + caster:GetAverageTrueAttackDamage(caster)*0.1*d_a_level
	end


		-- EmitSoundOn("Hero_TrollWarlord.PreAttack", caster)
		
		local casterOrigin = caster:GetAbsOrigin()

		local info = 
		{
				Ability = ability,
	        	EffectName = particle,
	        	vSpawnOrigin = startPoint+Vector(0,0,50),
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
	        	fExpireTime = GameRules:GetGameTime() + 5.0,
			bDeleteOnHit = false,
			vVelocity = fv * speed,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)

	Filters:CastSkillArguments(1, caster)
	if caster:HasModifier("modifier_seinaru_immortal_weapon_2") then
		local CD = ability:GetCooldownTimeRemaining()
		local newCD = CD*0.4
		ability:EndCooldown()
		ability:StartCooldown(newCD)
	end
end

function gust_impact(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local stun_duration = event.stun_duration
	local blind_duration = event.blind_duration
	local damage = ability.damage
	ability:ApplyDataDrivenModifier(caster, target, "modifier_kaze_gust_flail", {duration = stun_duration})
	ability:ApplyDataDrivenModifier(caster, target, "modifier_kaze_gust_blind", {duration = blind_duration})

	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_WIND, RPC_ELEMENT_NONE)

	local particleName = "particles/econ/items/riki/riki_immortal_ti6/riki_immortal_ti6_blinkstrike_gold.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 2, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	-- for i = 3, 9, 1 do
	-- 	ParticleManager:SetParticleControl(pfx, i, Vector(200,200,200))
	-- end
	Timers:CreateTimer(0.5, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	end)
	if ability.a_a_level > 0 then
		local a_a_duration = Filters:GetAdjustedBuffDuration(caster, 10, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_seinaru_rune_a_a", {duration = a_a_duration})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_seinaru_rune_a_a_invisible", {duration = a_a_duration})

		local newStacks = caster:GetModifierStackCount("modifier_seinaru_rune_a_a", caster) + 1
		caster:SetModifierStackCount("modifier_seinaru_rune_a_a", caster, newStacks)
		caster:SetModifierStackCount("modifier_seinaru_rune_a_a_invisible", caster, newStacks*ability.a_a_level)
	end
	if ability.b_a_level > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_seinaru_rune_b_a_slow", {duration = blind_duration})
		target:SetModifierStackCount("modifier_seinaru_rune_b_a_slow", caster, ability.b_a_level)
	end
end

function kaze_pushback_think(event)
	local target = event.target
	if target.jumpLock then
		return false
	end
	local ability = event.ability
	local fv = ability.fv
	local distance = WallPhysics:GetDistance(target:GetAbsOrigin()*Vector(1,1,0), ability.castPosition)
	local pushSpeed = math.max((1500 - distance)/35, 3)
	target:SetAbsOrigin(target:GetAbsOrigin()+fv*pushSpeed)
end

function kaze_pushback_end(event)
	local target = event.target
	if target.jumpLock then
		return false
	end
	FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
end