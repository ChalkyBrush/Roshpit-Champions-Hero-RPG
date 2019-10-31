require("/heroes/winter_wyvern/dinath_constants")
function drake_ring_cast(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]

	StartAnimation(caster, {duration = 1.2, activity = ACT_DOTA_CAST_ABILITY_1, rate = 1.0})
	EmitSoundOn("Dinath.DrakeRing.CastVO", caster)
	local flight_stacks = math.max(caster:GetModifierStackCount("modifier_dinath_postflight_zheight", caster) + 50, 96)
	local pfx = ParticleManager:CreateParticle("particles/roshpit/dinath/ring_cast.vpcf", PATTACH_CUSTOMORIGIN, nil)
	local startPoint = caster:GetAbsOrigin() + Vector(0, 0, flight_stacks)
	if caster:HasModifier("modifier_dinath_diving") then
		startPoint = caster:GetAbsOrigin() + Vector(0, 0, flight_stacks) + caster:GetForwardVector() * 300
	end
	ParticleManager:SetParticleControl(pfx, 1, point)
	ParticleManager:SetParticleControl(pfx, 0, startPoint)
	Timers:CreateTimer(1, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	if ability.ring then
		ParticleManager:DestroyParticle(ability.ring.pfx, false)
		UTIL_Remove(ability.ring)
		ability.ring = false
	end
	EmitSoundOn("Dinath.DrakeRing.Puff", caster)
	Timers:CreateTimer(0.75, function()
		EmitSoundOnLocationWithCaster(point, "Dinath.DrakeRing.Create", caster)
	end)
	Filters:CastSkillArguments(2, caster)
	Timers:CreateTimer(1, function()
		if ability.ring then
			ParticleManager:DestroyParticle(ability.ring.pfx, false)
			UTIL_Remove(ability.ring)
			ability.ring = false
		end
		caster:RemoveModifierByName("modifier_drake_ring_a_b")
		local drake_ring = CreateUnitByName("npc_dummy_unit", point, false, nil, nil, caster:GetTeamNumber())
		local radius = event.radius
		local w_4_level = caster:GetRuneValue("w", 4)
		radius = radius + w_4_level * DINATH_W4_RADUIS
		local ring_duration = 30
		drake_ring:SetDayTimeVisionRange(radius)
		drake_ring:SetNightTimeVisionRange(radius)
		drake_ring:FindAbilityByName("dummy_unit"):SetLevel(1)
		drake_ring.radius = radius
		local pfx = ParticleManager:CreateParticle("particles/roshpit/dinath/drake_ring_ring.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, drake_ring:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 3, Vector(1, 0, radius * 2 + 10))
		drake_ring.pfx = pfx
		drake_ring.interval = 0
		ability.ring = drake_ring
		ability:ApplyDataDrivenModifier(caster, drake_ring, "modifier_dinath_drake_ring", {duration = ring_duration})
		local w_3_level = caster:GetRuneValue("w", 3)
		if w_3_level > 0 then
			local rootDuration = DINATH_W3_ROOT_BASE + DINATH_W3_ROOT * w_3_level
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), drake_ring:GetAbsOrigin(), nil, drake_ring.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			for _, enemy in pairs(enemies) do
				if not enemy:HasModifier("modifier_drake_ring_root_immune") then
					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_drake_ring_root_immune", {duration = rootDuration + 2})
					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_drake_ring_root", {duration = rootDuration})
				end
			end
		end
	end)
end

function drake_ring_thinker(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local drake_ring = target
	drake_ring.interval = drake_ring.interval + 1
	local modulos = math.ceil((1 / caster:GetAttacksPerSecond()) / 0.03)
	if drake_ring.interval % modulos == 0 then
		if WallPhysics:GetDistance2d(caster:GetAbsOrigin(), drake_ring:GetAbsOrigin()) <= (caster:Script_GetAttackRange() + drake_ring.radius / 2) then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), drake_ring:GetAbsOrigin(), nil, drake_ring.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				EmitSoundOn("Dinath.DrakeRing.AutoAttack", caster)
				StartAnimation(caster, {duration = 1.2, activity = ACT_DOTA_ATTACK, rate = 1.0})
				for _, enemy in pairs(enemies) do
					if enemy.dummy then
					else
						Filters:PerformAttackSpecial(caster, enemy, true, true, true, false, true, false, false)
					end
				end
			end
		end
	end
	if drake_ring.interval % 15 == 1 then
		local w_2_level = caster:GetRuneValue("w", 2)
		if w_2_level > 0 then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), drake_ring:GetAbsOrigin(), nil, drake_ring.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			for _, enemy in pairs(enemies) do
				if w_2_level > 0 then
					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_drake_ring_armor_reduction", {duration = 0.5})
					enemy:SetModifierStackCount("modifier_drake_ring_armor_reduction", caster, w_2_level)
				end
			end
		end
	end
	if drake_ring.interval == 100 then
		local w_1_level = caster:GetRuneValue("w", 1)
		if w_1_level > 0 then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_drake_ring_a_b", {duration = 27})
			caster:SetModifierStackCount("modifier_drake_ring_a_b", caster, w_1_level)
		end
	end
end

function drake_ring_end(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if IsValidEntity(target) then
		if ability.ring then
			ParticleManager:DestroyParticle(ability.ring.pfx, false)
			UTIL_Remove(ability.ring)
			ability.ring = false
		end
	end
end

function glyph_5_attack_land(event)
	local caster = event.attacker
	for i = 0, 8, 1 do
		local baseAbility = caster:GetAbilityByIndex(i)
		if baseAbility then
			if baseAbility:GetCooldownTimeRemaining() > 0 then
				local newCD = baseAbility:GetCooldownTimeRemaining() - DINATH_GLYPH_5_1_CD_REDUCTION_PER_ATTACK
				baseAbility:EndCooldown()
				baseAbility:StartCooldown(newCD)
			end
		end
	end
end
