require('heroes/spirit_breaker/duskbringer_1_q')
require('/heroes/spirit_breaker/duskbringer_constants')

function shadow_slam_start(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	local newPosition = WallPhysics:WallSearch(caster:GetAbsOrigin(), point, caster)

	-- caster:SetAbsOrigin(newPosition)
	if caster:HasModifier("modifier_hidden_ghost_hallow_smashing") then
		caster:GiveMana(ability:GetManaCost(ability:GetLevel()))
		return false
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_hidden_ghost_hallow_smashing", {duration = 0.3})
	caster:RemoveModifierByName("modifier_terrorize_animation")
	caster:RemoveModifierByName("modifier_terrorize_thinking")
	caster:RemoveModifierByName("modifier_name_after_terrorize_falling")
	StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_TELEPORT_END, rate=1.2})
	Filters:CastSkillArguments(2, caster)
	ability.moveVector = ((newPosition-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	EmitSoundOn("Duskbringer.Arcana1.VO", caster)
end

function shadow_slam_think(event)
	local caster = event.caster
	local ability = event.ability
	local moveSpeed = 30
	local blockSearch = caster:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,GetGroundHeight(caster:GetAbsOrigin(), caster))
    local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch+ability.moveVector*30), caster)
	if blockUnit then
		moveSpeed = 0
	end
	local newPosition = GetGroundPosition(caster:GetAbsOrigin()+ability.moveVector*moveSpeed, caster)
	-- if caster:HasModifier("modifier_terrorize_thinking") or caster:HasModifier("modifier_name_after_terrorize_falling") then
		newPosition = caster:GetAbsOrigin()+ability.moveVector*moveSpeed
		local downspeed = 40
		if caster:GetAbsOrigin().z < GetGroundHeight(caster:GetAbsOrigin(), caster) + downspeed then
			downspeed = 0
		end
		newPosition = newPosition - Vector(0,0,downspeed)
	-- end
	caster:SetAbsOrigin(newPosition)
	duskbringer_rune_e_1_think(event)
end

function shadow_slam_end(event)
	local caster = event.caster
	local ability = event.ability
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/duskbringer_a_b.vpcf", PATTACH_CUSTOMORIGIN, caster)
	local landPoint = caster:GetAbsOrigin()
	Timers:CreateTimer(0.03, function()
		FindClearSpaceForUnit(caster, landPoint, false)
	end)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	EmitSoundOn("Duskbringer.Arcana1.Smash", caster)
	local stunDuration = event.stun_duration
	local damage = event.damage
	local w_1_level = caster:GetRuneValue("w", 1)
	if w_1_level > 0 then
		damage = damage + w_1_level * OverflowProtectedGetAverageTrueAttackDamage(caster) * ability:GetLevel() * DUSKBRINGER_ARCANA_W1_ADD_DMG_PER_ATT_PER_LEVEL
	end

	local w_2_level = caster:GetRuneValue("w", 2)
	local w_3_level = caster:GetRuneValue("w", 3)
	local w_4_level = caster:GetRuneValue("w", 4)
	local flailAbility = caster:FindAbilityByName("whirling_flail")
	local stacksCount = Runes:Procs(w_3_level, DUSKBRINGER_ARCANA_W3_PROC_CHANCE, 1)
					
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )	
	if #enemies > 0 then	
		for i = 1, #enemies, 1 do
			Filters:TakeArgumentsAndApplyDamage(enemies[i], caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_GHOST, RPC_ELEMENT_SHADOW)
			Filters:ApplyStun(caster, stunDuration, enemies[i])
			if w_3_level > 0 then
				increment_duskfire_stacks(caster, enemies[i], flailAbility, stacksCount)
			end
		end
	end
	if w_2_level > 0 then
		local w_2_duration = Filters:GetAdjustedBuffDuration(caster, DUSKBRINGER_ARCANA_W2_BASE_DUR, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_duskbringer_arcana_rune_w_2", {duration = w_2_duration})
		caster:SetModifierStackCount("modifier_duskbringer_arcana_rune_w_2", caster, w_2_level)
	end	
	if w_4_level > 0 then
		if not caster:HasModifier("modifier_duskbringer_arcana_rune_w_4") then
			ability:ApplyDataDrivenModifier(caster, caster, "modifer_duskbringer_d_b_charging_up", {duration = 0.8})
			Timers:CreateTimer(0.3, function()
				EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Duskbringer.Arcana1.DB", caster)
			end)
			StartAnimation(caster, {duration=1.1, activity=ACT_DOTA_VICTORY, rate=1.2})
			Timers:CreateTimer(0.8, function()
				local w_4_duration = Filters:GetAdjustedBuffDuration(caster, DUSKBRINGER_ARCANA_W4_BASE_DUR, false)
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_duskbringer_arcana_rune_w_4", {duration = w_4_duration})
				caster:SetModifierStackCount("modifier_duskbringer_arcana_rune_w_4", caster, w_4_level)
			end)
		end
	end
	GridNav:DestroyTreesAroundPoint(caster:GetAbsOrigin(), 300, false)
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
end