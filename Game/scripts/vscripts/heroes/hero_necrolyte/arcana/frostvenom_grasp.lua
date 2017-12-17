function frostvenom_grasp_start(event)
	local caster = event.caster
	local ability = event.ability
	local explosions = event.explosions + Runes:Procs(Runes:GetTotalRuneLevelGeneric(caster, 4, 0), 5, 1)
	local radius = 500
	local counter = 0
	StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_1, rate=1.0})
	local pfx = CustomAbilities:QuickParticleAtPoint("particles/items4_fx/meteor_hammer_spell_ground_impact.vpcf", caster:GetAbsOrigin(), 5)
	ParticleManager:SetParticleControl(pfx, 3, caster:GetAbsOrigin())
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	if not event.amp then
		event.amp = 1
	end
	if caster:HasModifier("modifier_venomort_glyph_1_1") then
		ability:EndCooldown()
		ability:StartCooldown(1.5)
	end
	local damage = event.damage*event.amp
	EmitSoundOn("Venomort.FrostVenomGrasp.Cast", caster)
	local a_a_level = Runes:GetTotalRuneLevelGeneric(caster, 1, 0)
	ability.a_a_level = a_a_level
	local b_a_level = Runes:GetTotalRuneLevelGeneric(caster, 2, 0)
	if b_a_level > 0 then
		radius = radius + b_a_level*3
		ability.slideSpeed = 20 + b_a_level*0.2
		ability.fv = caster:GetForwardVector()
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_icevenom_slide", {duration = 5})
	end
	local c_a_level = Runes:GetTotalRuneLevelGeneric(caster, 3, 0)

	for i = 1, explosions, 1 do
		Timers:CreateTimer((i-1)*0.35, function()
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			if #enemies > 0 then
				local enemy = enemies[1]
				if c_a_level > 0 then
					local procs = Runes:Procs(c_a_level, 0.2, 1)
					procs = 2
					if procs > 0 then
						ozubu_transfer_debuff(caster, enemy, ability)
					end
				end
				EmitSoundOn("Venomort.FrostVenomGrasp.Impact", enemy)
				CustomAbilities:QuickAttachParticle("particles/roshpit/venomort/frostvenom_grasp.vpcf", enemy, 1)
				local enemies2 = FindUnitsInRadius( caster:GetTeamNumber(), enemy:GetAbsOrigin(), nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
				for _,enemy2 in pairs(enemies2) do
					ability:ApplyDataDrivenModifier(caster, enemy2, "modifier_chilled", {duration = 8})
					ability:ApplyDataDrivenModifier(caster, enemy2, "modifier_chilled_stacking", {duration = 8})
					if a_a_level > 0 then
						local currentStacks = enemy2:GetModifierStackCount("modifier_chilled_stacking", caster)
						enemy2:SetModifierStackCount("modifier_chilled_stacking", caster, currentStacks+1)
					end
					Filters:TakeArgumentsAndApplyDamage(enemy2, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_POISON, RPC_ELEMENT_ICE)
				end
			end 
		end)
	end
	Filters:CastSkillArguments(1, caster)
end

function frostvenom_chill_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if ability.a_a_level > 0 then
		local damage = (ability.a_a_level * 3000 + 10000)*target:GetModifierStackCount("modifier_chilled_stacking", caster)
		Filters:ApplyDotDamage(caster, ability, target, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_POISON, RPC_ELEMENT_ICE)
	end
end

function icevenom_slide_think(event)
	local caster = event.caster
	local ability = event.ability

	local newPosition = GetGroundPosition(caster:GetAbsOrigin()+ability.fv*ability.slideSpeed, caster)
	local obstruction = WallPhysics:FindNearestObstruction(newPosition)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition, caster)
	ability.slideSpeed = math.min(ability.slideSpeed - 0.5, ability.slideSpeed*0.96)
	if not blockUnit then
		caster:SetOrigin(newPosition)
	else
		caster:RemoveModifierByName("modifier_icevenom_slide")
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
	end

	if ability.slideSpeed <= 3.0 then
		caster:RemoveModifierByName("modifier_icevenom_slide")
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
	end
end

function ozubu_transfer_debuff(caster, target, ability)
	local modifiers = caster:FindAllModifiers()
	for j = 1, #modifiers, 1 do
		local modifier = modifiers[j]
		local modifierMaker = modifier:GetCaster()
		local duration = modifier:GetDuration()
		local stacks = caster:GetModifierStackCount(modifier:GetName(), modifierMaker)
		if not WallPhysics:DoesTableHaveValue(Filters:GetUnpurgableDebuffNames(), modifier:GetName()) then
			if modifierMaker:GetTeamNumber() == caster:GetTeamNumber() then
			else
				if duration > 0 then
					caster:RemoveModifierByName(modifier:GetName())
					print(modifier:GetAbility():GetClassname())
					if modifier:GetAbility():GetClassname() == "ability_datadriven" then
						if IsValidEntity(modifier:GetAbility()) then
							local abil = modifier:GetAbility()
							abil:ApplyDataDrivenModifier(modifierMaker, target, modifier:GetName(), {duration = duration})
							target:SetModifierStackCount(modifier:GetName(), modifierMaker, stacks)
						end
						particle = true
						break
					end
				end
			end
		end
	end				

	if particle then
		local pfx = CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_morphling/morphling_morph_agi.vpcf", caster, 1.2)
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_morphling/morphling_morph_str.vpcf", target, 1.2)
	end	
end