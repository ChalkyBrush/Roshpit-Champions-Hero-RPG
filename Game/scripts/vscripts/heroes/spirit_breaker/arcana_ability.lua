require('heroes/spirit_breaker/whirling_flail')

function arcana_ability_start(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	if caster:HasAbility("whirling_flail") then
		local flailAbility = caster:FindAbilityByName("whirling_flail")
		flailAbility.a_a_level = Runes:GetTotalRuneLevel(caster, 1, "a_a", "duskbringer")
	end
	local newPosition = WallPhysics:WallSearch(caster:GetAbsOrigin(), point, caster)

	-- caster:SetAbsOrigin(newPosition)
	if caster:HasModifier("modifier_hidden_ghost_hallow_smashing") then
		caster:GiveMana(ability:GetManaCost(ability:GetLevel()))
		return false
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_hidden_ghost_hallow_smashing", {duration = 0.3})

	StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_TELEPORT_END, rate=1.2})
	Filters:CastSkillArguments(2, caster)
	ability.moveVector = ((newPosition-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	EmitSoundOn("Duskbringer.Arcana1.VO", caster)
	caster.d_d_level = Runes:GetTotalRuneLevel(caster, 4, "d_d", "duskbringer")
end

function smashing_think(event)
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
	caster:SetAbsOrigin(newPosition)
end

function smashing_end(event)
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
	local a_b_level = Runes:GetTotalRuneLevel(caster, 1, "a_b_arcana1", "duskbringer")
	if a_b_level > 0 then
		damage = damage + a_b_level*caster:GetAverageTrueAttackDamage(caster)*0.1*ability:GetLevel()
	end

	local b_b_level = Runes:GetTotalRuneLevel(caster, 2, "b_b_arcana1", "duskbringer")
	local c_b_level = Runes:GetTotalRuneLevel(caster, 3, "c_b_arcana1", "duskbringer")
	local d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b_arcana1", "duskbringer")
	local flailAbility = caster:FindAbilityByName("whirling_flail")
					
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )	
	if #enemies > 0 then	
		for i = 1, #enemies, 1 do
			Filters:TakeArgumentsAndApplyDamage(enemies[i], caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_GHOST, RPC_ELEMENT_SHADOW)
			Filters:ApplyStun(caster, stunDuration, enemies[i])
			if c_b_level > 0 then
				increment_duskfire_stacks(caster, enemies[i], flailAbility, c_b_level)
			end
		end
	end

	
	if b_b_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_duskbringer_arcana_armor", {duration = 6})
		caster:SetModifierStackCount("modifier_duskbringer_arcana_armor", caster, b_b_level)
	end	
	if d_b_level > 0 then
		if not caster:HasModifier("modifier_duskbringer_arcana_damage_buff") then
			ability:ApplyDataDrivenModifier(caster, caster, "modifer_duskbringer_d_b_charging_up", {duration = 0.8})
			Timers:CreateTimer(0.3, function()
				EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Duskbringer.Arcana1.DB", caster)
			end)
			StartAnimation(caster, {duration=1.1, activity=ACT_DOTA_VICTORY, rate=1.2})
			Timers:CreateTimer(0.8, function()
				local d_b_duration = Filters:GetAdjustedBuffDuration(caster, 18, false)
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_duskbringer_arcana_damage_buff", {duration = d_b_duration})
				caster:SetModifierStackCount("modifier_duskbringer_arcana_damage_buff", caster, d_b_level)
			end)
		end
	end
	

	GridNav:DestroyTreesAroundPoint(caster:GetAbsOrigin(), 300, false)
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
end