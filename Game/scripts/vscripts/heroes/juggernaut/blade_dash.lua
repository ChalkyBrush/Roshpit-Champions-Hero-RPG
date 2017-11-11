function blade_dash_start(event)
	local caster = event.caster
	local ability = event.ability
	ability.interval = 0
	local target = event.targetUnit
	DeepPrintTable(event.target_points)
	if target then
		ability.target = event.target
		ability.targetPoint = false
	else
		ability.target = false
		ability.targetPoint = event.target_points[1]
	end
	if event.target_points then
		ability.target = false
		ability.targetPoint = event.target_points[1]
	end
	print(ability.target)
	print(ability.targetPoint)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_seinaru_arcana_dashing", {duration = 4})
	caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0,0,80))
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hero_Juggernaut.PreAttack", caster)
	ability.b_a_level = Runes:GetTotalRuneLevel(caster, 2, "b_a_arcana1", "monk")
	local particleName = "particles/econ/items/riki/riki_immortal_ti6/riki_immortal_ti6_blinkstrike_gold.vpcf"
	local pfx = 0
	if ability.target then
		pfx = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, target )
		ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 2, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	else
		pfx = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(pfx, 1, ability.targetPoint)
		ParticleManager:SetParticleControl(pfx, 2, ability.targetPoint)
	end
	

	ability.damage = event.damage_attack*caster:GetAverageTrueAttackDamage(caster)/100
	ability.pfx = pfx
	caster.d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "monk")
	local c_a_level = Runes:GetTotalRuneLevel(caster, 3, "c_a_arcana1", "monk")
	if c_a_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_seinaru_arcana_agility_buff", {duration = 10})
		caster:SetModifierStackCount("modifier_seinaru_arcana_agility_buff", caster, c_a_level)
	end
	local d_a_level = Runes:GetTotalRuneLevel(caster, 4, "d_a_arcana1", "monk")
	if d_a_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_seinaru_arcana_evasion_buff", {duration = d_a_level*0.15})
	end
	Filters:CastSkillArguments(1, caster)

	if caster:HasModifier("modifier_seinaru_immortal_weapon_2") then
		local CD = ability:GetCooldownTimeRemaining()
		local newCD = CD*0.4
		ability:EndCooldown()
		ability:StartCooldown(newCD)
	end
end

function arcana_dashing_think(event)
	local caster = event.caster
	local ability = event.ability
	casterOrigin = caster:GetAbsOrigin()
	local target = ability.target
	if ability.interval < 10 then
		caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,10))
	end
	ability.interval = ability.interval + 1
	local dashSpeed = 48
	local dashVector = Vector(1,0)
	if ability.target then
		dashVector = ((ability.target:GetAbsOrigin()+Vector(0,0,100))-caster:GetAbsOrigin()):Normalized()
	else
		dashVector = ((ability.targetPoint+Vector(0,0,100))-caster:GetAbsOrigin()):Normalized()
	end
	local newPosition = casterOrigin+dashVector*dashSpeed
	local obstruction = WallPhysics:FindNearestObstruction(newPosition)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition, caster)
	if ability.interval%1 == 0 then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 120, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			EmitSoundOn("juggernaut_jug_ability_omnislash_1"..RandomInt(5,7), enemies[1])
			for _,enemy in pairs(enemies) do
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, ability.damage, DAMAGE_TYPE_PHYSICAL, 1, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_seinaru_dashing_stun", {duration = 0.2})
			end		
		end		
	end
	caster:SetForwardVector(caster:GetForwardVector()+Vector(0,0,-1))
	if caster:IsStunned() then
		blade_dash_end(caster, ability)
	end
	if not blockUnit then
		caster:SetAbsOrigin(newPosition)
		local distance = 200
		if ability.target then
			distance = WallPhysics:GetDistance(target:GetAbsOrigin()*Vector(1,1,0), caster:GetAbsOrigin()*Vector(1,1,0))
		else
			distance = WallPhysics:GetDistance(ability.targetPoint*Vector(1,1,0), caster:GetAbsOrigin()*Vector(1,1,0))
		end
		if distance < 85 then
			if not caster.bladeTableArcana then
				caster.bladeTableArcana = {}
			end
			if ability.targetPoint then
				local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 150, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false )
				if #enemies > 0 then
					target = enemies[1]
				end
			end
			caster:RemoveModifierByName("modifier_seinaru_arcana_dashing")
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
			caster:SetForwardVector(caster:GetForwardVector()*Vector(1,1,0))
			if target then
				caster:PerformAttack(target, true, true, true, false, true, false, false)
			end
			StartAnimation(caster, {duration=0.6, activity=ACT_DOTA_ATTACK, rate=2.0})
			ParticleManager:DestroyParticle(ability.pfx, false)
			if ability.b_a_level > 0 then
				if #caster.bladeTableArcana < 3 then
					local sword = CreateUnitByName("selethas_boomerang", caster:GetAbsOrigin()+Vector(0,0,100), false, caster, nil, caster:GetTeamNumber())
					ability:ApplyDataDrivenModifier(caster, sword, "modifier_seinaru_flying_sword_modifier", {})
					sword:SetOriginalModel("models/props_gameplay/disarm.vmdl")
					sword:SetModel("models/props_gameplay/disarm.vmdl")
					sword:SetModelScale(8)
					sword.interval = 0
					sword:SetRenderColor(255, 255, 0)
					sword.fv = caster:GetForwardVector()
					sword.zFV = Vector(1,1)
					table.insert(caster.bladeTableArcana, sword)
					ability:ApplyDataDrivenModifier(caster, caster, "modifier_seinaru_flying_sword_buff_visible", {})
					caster:SetModifierStackCount("modifier_seinaru_flying_sword_buff_visible", caster, #caster.bladeTableArcana)
					ability:ApplyDataDrivenModifier(caster, caster, "modifier_seinaru_flying_sword_buff_invisible", {})
					caster:SetModifierStackCount("modifier_seinaru_flying_sword_buff_invisible", caster, #caster.bladeTableArcana*ability.b_a_level)
					sword.index = #caster.bladeTableArcana
				end
			end
		end
	else
		blade_dash_end(caster, ability)
	end
end

function blade_dash_end(caster, ability)
	caster:RemoveModifierByName("modifier_seinaru_arcana_dashing")
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
	caster:SetForwardVector(caster:GetForwardVector()*Vector(1,1,0))
	ParticleManager:DestroyParticle(ability.pfx, false)
end

function arcana_attack_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	-- local a_a_level = Runes:GetTotalRuneLevel(caster, 1, "a_a_arcana1", "monk")
	local a_a_level = Runes:GetTotalRuneLevel(caster, 1, "a_a_arcana1", "monk")
	ability.a_a_level = a_a_level
	if a_a_level > 0 then
		local luck = RandomInt(1, 5)
		if luck == 1 then
			CustomAbilities:QuickAttachParticle("particles/econ/items/phantom_assassin/phantom_assassin_weapon_runed_scythe/phantom_assassin_attack_blur_crit_runed_scythe.vpcf", caster, 2.5)
			CustomAbilities:QuickAttachParticle("particles/econ/items/phantom_assassin/phantom_assassin_weapon_runed_scythe/phantom_assassin_attack_blur_crit_runed_scythe.vpcf", target, 2.5)
			EmitSoundOn("Seinaru.ArcanaCritVO", caster)
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Seinaru.ArcanaCrit", caster)
			local speed = caster:GetAttackAnimationPoint()
			print(speed)
			print(caster:GetAttackSpeed())
			local rate = 2.6-(caster:GetAttackSpeed()/20)
			local duration = 1/caster:GetAttackSpeed() + speed
			print(rate)
			StartAnimation(caster, {duration=duration, activity=ACT_DOTA_ATTACK_EVENT, rate=rate, translate="favor"})
			if not caster:HasModifier("modifier_jumping") and not caster:HasModifier("modifier_sunstrider_in_air") then
				WallPhysics:Jump(caster, caster:GetForwardVector(), 0, 30, 8, 2)
			end
			if not target:HasModifier("modifier_jumping") and not caster:HasModifier("modifier_sunstrider_in_air") then
				WallPhysics:Jump(target, target:GetForwardVector(), 0, 30, 8, 2)
			end
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_seinaru_a_a_crit", {duration = 1.5})
			-- local damageBonus = caster:GetAverageTrueAttackDamage(caster)*0.3*a_a_level
			-- caster:SetModifierStackCount("modifier_seinaru_a_a_crit", caster, damageBonus)
		end
	end
end

function arcana_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if caster:HasModifier("modifier_seinaru_a_a_crit") then
		local critDamage = caster:GetAverageTrueAttackDamage(caster)*1.5*ability.a_a_level
		ApplyDamage({ victim = target, attacker = caster, damage = critDamage, damage_type = DAMAGE_TYPE_PHYSICAL })
		PopupDamage(target, critDamage)
		Timers:CreateTimer(0.03, function()
			caster:RemoveModifierByName("modifier_seinaru_a_a_crit")
		end)
	end
	

	if not caster.bladeTableArcana then
		caster.bladeTableArcana = {}
	end
	if #caster.bladeTableArcana > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_flying_sword_destroy_stacks", {})
		local newStacks = caster:GetModifierStackCount("modifier_flying_sword_destroy_stacks", caster) + 1
		caster:SetModifierStackCount("modifier_flying_sword_destroy_stacks", caster, newStacks)
		if newStacks == 15 then
			caster:RemoveModifierByName("modifier_flying_sword_destroy_stacks")
			UTIL_Remove(caster.bladeTableArcana[1])
			local newTable = {}
			for i = 1, #caster.bladeTableArcana, 1 do
				if IsValidEntity(caster.bladeTableArcana[i]) then
					table.insert(newTable, caster.bladeTableArcana[i])
				end
			end
			caster.bladeTableArcana = newTable
			for i = 1, #caster.bladeTableArcana, 1 do
				caster.bladeTableArcana[i].index = i
			end
			if #caster.bladeTableArcana > 0 then
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_seinaru_flying_sword_buff_visible", {})
				caster:SetModifierStackCount("modifier_seinaru_flying_sword_buff_visible", caster, #caster.bladeTableArcana)
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_seinaru_flying_sword_buff_invisible", {})
				caster:SetModifierStackCount("modifier_seinaru_flying_sword_buff_invisible", caster, #caster.bladeTableArcana*ability.b_a_level)
			else
				caster:RemoveModifierByName("modifier_seinaru_flying_sword_buff_visible")
				caster:RemoveModifierByName("modifier_seinaru_flying_sword_buff_invisible")
			end
		end
	end

end

function flying_sword_think(event)
	local caster = event.caster
	local sword = event.target
	local ability = event.ability
	sword.fv = WallPhysics:rotateVector(sword.fv, math.pi*2/36)
	if sword.index == 1 then
		ability.swordFV = sword.fv
	else
		sword.fv = WallPhysics:rotateVector(ability.swordFV, 2*math.pi*(sword.index-1)/3)
	end
	-- sword.zFV = WallPhysics:rotateVector(sword.zFV, math.pi*2/90)
	-- local zFV = Vector(0, sword.zFV.x, sword.zFV.y)
	-- sword:SetAbsOrigin(caster:GetAbsOrigin()+sword.fv*140+Vector(0,0,90)+zFV*40)
	sword:SetAbsOrigin(caster:GetAbsOrigin()+sword.fv*120+Vector(0,0,100))
	sword.interval = sword.interval + 1
	sword:SetForwardVector(sword.fv)
	-- sword:SetAngles(160,(sword.interval*6)%360, 0)
end

function arcana_passive_remove(event)
	local caster = event.caster
	local ability = event.ability
	if caster.bladeTableArcana then
		for i = 1, #caster.bladeTableArcana, 1 do
			if IsValidEntity(caster.bladeTableArcana[i]) then
				UTIL_Remove(caster.bladeTableArcana[i])
			end
		end
	end
	caster:RemoveModifierByName("modifier_seinaru_flying_sword_buff_visible")
	caster:RemoveModifierByName("modifier_seinaru_flying_sword_buff_invisible")
end