require('heroes/arc_warden/abilities/onibi')

function jex_thunderleaf_phase(event)
	local caster = event.caster
	StartAnimation(caster, {duration=0.4, activity=ACT_DOTA_CAST_ABILITY_1, rate=1.8})
	EmitSoundOn("Jex.Thunderleaf.Throw", caster)
end

function jex_thunderleaf_throw(event)
	local caster = event.caster
	local ability = event.ability
	local leaf_count = event.leaf_count

	local damage_attack_power_per_tech = event.damage_attack_power_per_tech
	local agility_added_to_damage = event.agility_added_to_damage
	local range_base = event.range_base
	local range_per_tech = event.range_per_tech
	local paralyze_duration_per_tech = event.paralyze_duration_per_tech

	local tech_level = onibi_get_total_tech_level(caster, "lightning", "nature", "W")
	local base_damage = event.base_damage
	ability.damage =  base_damage + agility_added_to_damage*caster:GetAgility()+(damage_attack_power_per_tech/100)*OverflowProtectedGetAverageTrueAttackDamage(caster)*tech_level
	local w_4_level = caster:GetRuneValue("w", 4)
	if w_4_level > 0 then
		ability.damage = ability.damage + ability.damage*(event.w_4_damage_increase_pct/100)*w_4_level
	end
	ability.q_4_level = caster:GetRuneValue("q", 4)
	ability.paralyze_duration = paralyze_duration_per_tech*tech_level
	local particle = "particles/roshpit/jex/thunderleaf_concoction_projectile_linear.vpcf"
	local range = range_base + range_per_tech*tech_level
	local divisor = 15
	if leaf_count == 3 then
		divisor = 17
	elseif leaf_count == 4 then
		divisor = 18
	elseif leaf_count == 5 then
		divisor = 22
	end
	EmitSoundOn("Jex.Thunderleaf.ThrowZap", caster)
	for i = 1, leaf_count, 1 do
		local rotation_adjustment = leaf_count/2
		local fv = WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi*(i-rotation_adjustment)/divisor)
		local speed = 1500
		local info = 
		{
				Ability = ability,
	        	EffectName = particle,
	        	vSpawnOrigin = caster:GetAbsOrigin()+Vector(0,0,20),
	        	fDistance = range,
	        	fStartRadius = 170,
	        	fEndRadius = 170,
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
	end

	Filters:CastSkillArguments(2, caster)
end

function thunderleaf_impact(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local paralyze_duration = ability.paralyze_duration

	if not ability.q_4_level then
		ability.q_4_level = caster:GetRuneValue("q", 4)
	end
	local current_stacks = target:GetModifierStackCount("modifier_thunderleaf_paralyze_immunity", target)
	local paralyze_immunity = 4 - (event.q_4_immunity_duration_reduce*ability.q_4_level)
	if current_stacks <= 5 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_thunderleaf_paralyze_immunity", {duration = paralyze_immunity})
		ability:ApplyDataDrivenModifier(caster, target, "modifier_thunderleaf_paralyze", {duration = paralyze_duration})
		target:SetModifierStackCount("modifier_thunderleaf_paralyze_immunity", caster, current_stacks + 1)
	end
	StartAnimation(target, {duration=paralyze_duration, activity=ACT_DOTA_FLAIL, rate=2.2})
	EmitSoundOn("Jex.Thundershroom.Lightning", target)
	local particleName = "particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf"
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin()+Vector(0,0,target:GetBoundingMaxs().z+40))
	ParticleManager:SetParticleControl(pfx, 1, target:GetAbsOrigin()+Vector(0,0,target:GetBoundingMaxs().z+60))
	Timers:CreateTimer(0.3, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	Filters:TakeArgumentsAndApplyDamage(target, caster, ability.damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_NATURE, RPC_ELEMENT_LIGHTNING)
end