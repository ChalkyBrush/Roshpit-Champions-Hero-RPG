require('heroes/spirit_breaker/duskbringer_constants')
require('heroes/spirit_breaker/duskbringer_3_e')
require('heroes/spirit_breaker/duskbringer_glyphs')
require('heroes/spirit_breaker/duskbringer_helpers')

function whirling_flail_start(event)
	local caster = event.caster
	local ability = event.ability
	StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_TELEPORT, rate=1.8})
	q_1_level = caster:GetRuneValue("q", 1)
	q_4_level = caster:GetRuneValue("q", 4)
	ability.radius = DUSKBRINGER_Q_BASE_RADIUS + q_4_level * DUSKBRINGER_Q4_ADD_RADIUS
	ability.ticks = 0
	if q_1_level > 0 then
		local particleName = "particles/units/heroes/hero_spirit_breaker/spirit_breaker_charge_wave.vpcf"
		ability.pfx = ParticleManager:CreateParticle( particleName, PATTACH_POINT_FOLLOW, caster )
		ParticleManager:SetParticleControlEnt(ability.pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
	end
	if q_1_level > 0 then
		ability.pfxB = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/duskbringer_b_d_vertical_spell_bloodbath_bubbles_.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(ability.pfxB, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(ability.pfxB, 1, Vector(ability.radius/3, 1, 1))
	end
	if caster:HasModifier("modifier_duskbringer_glyph_6_1") then
		ability:EndCooldown()
		ability:StartCooldown(DUSKBRINGER_GLYPH_6_1_CD)
	end
	Filters:CastSkillArguments(1, caster)
end

function whirling_flail_particle_create(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.whirling_flail_particle_main then
		caster.whirling_flail_particle_main = ParticleManager:CreateParticle("particles/roshpit/duskbringer/whirling_flail_base.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(caster.whirling_flail_particle_main, 0, caster:GetAbsOrigin() + WallPhysics:rotateVector(caster:GetForwardVector(), -math.pi/2)*60)
		ParticleManager:SetParticleControl(caster.whirling_flail_particle_main, 1, Vector(ability.radius, ability.radius, ability.radius))
	else
		ParticleManager:SetParticleControl(caster.whirling_flail_particle_main, 0, caster:GetAbsOrigin() + WallPhysics:rotateVector(caster:GetForwardVector(), -math.pi/2)*60)
	end
end

function whirling_flail_particle_destroy(event)
	local caster = event.caster
	if caster.whirling_flail_particle_main then
		ParticleManager:DestroyParticle(caster.whirling_flail_particle_main, false)
		caster.whirling_flail_particle_main = nil
	end
end

function whirling_flail_think(event)
	local caster = event.caster
	local ability = event.ability
	ability.ticks = ability.ticks + 1
	local damage_multiplier = 1
	if caster:HasModifier("modifier_duskbringer_glyph_3_2") then
		damage_multiplier = (1 - DUSKBRINGER_GLYPH_3_2_DMG_DECR)
	elseif ability.ticks % 2 == 1 then
		return
	end
	local q_1_level = caster:GetRuneValue("q", 1)
	local q_3_level = caster:GetRuneValue("q", 3)
	local q_4_level = caster:GetRuneValue("q", 4)
	duskbringer_rune_e_1_refresh(caster)
	duskbringer_glyph_4_2_refresh(caster)
	EmitSoundOn("Hero_Spirit_Breaker.PreAttack", caster)
	local searchArea = caster:GetAbsOrigin() + WallPhysics:rotateVector(caster:GetForwardVector(), -math.pi/2)*60
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), searchArea, nil, ability.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	local damage = event.damage * OverflowProtectedGetAverageTrueAttackDamage(caster) / 100
	damage = damage * (1 + DUSKBRINGER_Q4_ADD_DMG_PCT * q_4_level) * damage_multiplier

	EndAnimation(caster)
	Timers:CreateTimer(0.03, function()
		StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_TELEPORT, rate=1.8})
	end)
	if ability.q_2_particle then
		ParticleManager:DestroyParticle( ability.q_2_particle, false )
		local particleName = "particles/units/heroes/hero_bloodseeker/duskbringer_b_d_vertical_spell_bloodbath_bubbles_.vpcf"
	    ability.q_2_particle = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	     ParticleManager:SetParticleControl( ability.q_2_particle, 0, caster:GetAbsOrigin()+Vector(0,0,80) )
	end

	local knockback_distance = event.knockback_distance
	local modifierKnockback =
	{
		center_x = searchArea.x,
		center_y = searchArea.y,
		center_z = searchArea.z,
		duration = 0.5,
		knockback_duration = 0.3,
		knockback_distance = knockback_distance,
		knockback_height = 40
	}
	if #enemies > 0 then
		EmitSoundOn("Hero_Spirit_Breaker.Attack", caster)
		for _,enemy in pairs(enemies) do
			local distance = WallPhysics:GetDistance(enemy:GetAbsOrigin(), caster:GetAbsOrigin())
			local damageBonusMult = math.max(1 - (distance/(ability.radius)),0)--for some reason it hist further than it should
			local distanceDamage = damage * (1 + q_3_level * DUSKBRINGER_Q3_ADD_DMG_PCT_MAX * damageBonusMult)
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, distanceDamage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_Q, RPC_ELEMENT_NORMAL, RPC_ELEMENT_GHOST)

			enemy:AddNewModifier( caster, nil, "modifier_knockback", modifierKnockback )
			local particleName = "particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf"
			local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, enemy )
			ParticleManager:SetParticleControlEnt(pfx, 0, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			Timers:CreateTimer(0.8, function() 
			  ParticleManager:DestroyParticle( pfx, false )
			end) 	
			if q_1_level > 0 then
				local eventTable = {}
				eventTable.attacker = caster
				eventTable.target = enemy
				eventTable.ability = ability
				whirling_flail_q1_on_hit(eventTable)
			end
		end
	end 	
	  
end

function whirling_flail_q1_on_hit(event)
	local caster = event.attacker
	local enemy = event.target
	local ability = event.ability
	local stack_increment = 1
	if caster:HasModifier("modifier_duskbringer_glyph_2_2") then
		stack_increment = DUSKBRINGER_GLYPH_2_2_Q1_STACKS
	end
	local q_1_level = caster:GetRuneValue("q", 1)
	if q_1_level > 0 then
		if caster:HasModifier("modifier_duskbringer_glyph_5_2") then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), enemy:GetAbsOrigin(), nil, DUSKBRINGER_GLYPH_5_2_BASE_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			if #enemies > 0 then
				for _,_enemy in pairs(enemies) do
					increment_duskfire_stacks(caster, _enemy, stack_increment)
				end
			end
		else
			increment_duskfire_stacks(caster, enemy, stack_increment)
		end
		local particleName = "particles/units/heroes/hero_spirit_breaker/spirit_breaker_nether_strike_begin_flash.vpcf"
		local pfx2 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, enemy )
		ParticleManager:SetParticleControlEnt(pfx2, 0, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
		local damage = q_1_level * (DUSKBRINGER_Q1_DMG_PER_STACK + DUSKBRINGER_Q1_DMG_PER_AGI_PER_STACK * caster:GetAgility())
		Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_Q, RPC_ELEMENT_GHOST, RPC_ELEMENT_FIRE)
		Timers:CreateTimer(0.4, function() 
		  ParticleManager:DestroyParticle( pfx2, false )
		end) 
	end	
end

function whirling_flail_end(event)
	local caster = event.caster
	local ability = event.ability
	if ability.pfx then
		ParticleManager:DestroyParticle( ability.pfx, false )
		ParticleManager:ReleaseParticleIndex(ability.pfx)
		ability.pfx = false
	end
	if ability.pfxB then
		ParticleManager:DestroyParticle( ability.pfxB, false )
		ParticleManager:ReleaseParticleIndex(ability.pfxB)
		ability.pfxB = false
	end
	if ability.q_2_particle then
		ParticleManager:DestroyParticle( ability.q_2_particle, false )
		ability.q_2_particle = false		
	end
	caster:RemoveModifierByName("modifier_whirling_flail_imbue_shade")
	if ability.r_2_particle then
		ParticleManager:DestroyParticle(ability.r_2_particle, false)
		ability.r_2_particle = false		
	end
end

function duskbringer_rune_q_1_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local q_1_level = caster:GetRuneValue("q", 1)
	local q_4_level = caster:GetRuneValue("q", 4)
	if q_1_level <= 0 then
		return
	end
	if caster:HasModifier("modifier_duskbringer_arcana2") then
		q_4_level = 0
	end
	if target.dummy then
		return false
	end
	local fireStacks = target:GetModifierStackCount("modifier_duskbringer_rune_q_1", caster)
	local damage = q_1_level * (DUSKBRINGER_Q1_DMG_PER_STACK + DUSKBRINGER_Q1_DMG_PER_AGI_PER_STACK * caster:GetAgility()) * fireStacks
	if caster:HasModifier("modifier_duskbringer_arcana2") then
		damage = q_1_level * (DUSKBRINGER_Q1_ARCANA2_DMG_PER_STACK + DUSKBRINGER_Q1_ARCANA2_DMG_PER_STR_PER_STACK * caster:GetStrength()) * fireStacks
	end
	damage = damage + damage * q_4_level * DUSKBRINGER_Q4_ADD_DMG_PCT
	Filters:ApplyDotDamage(caster, ability, target, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_GHOST, RPC_ELEMENT_FIRE)
end

