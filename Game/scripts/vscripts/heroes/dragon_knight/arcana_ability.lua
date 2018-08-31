function PhaseStartArcanaAbility(event)
	local ability = event.ability
	local caster = event.caster
	if not ability.PointTable then
		ability.PointTable = {}
	end
	local target = event.target_points[1]
	if caster:GetRuneValue("q", 3) > 0 and (ability.PointTable[1] == nil or ability.PointTable[1].Used == true) then
		table.insert(ability.PointTable, 1, {target, Used = false})
		caster:Stop()
	end
end

function start_arcana_ability(event)
	local caster = event.caster
	local ability = event.ability
	local targetPoint = Vector(1,1,1)
	local q_3_level = caster:GetRuneValue("q", 3)
	if q_3_level > 0 then
		targetPoint =  ability.PointTable[1][1]
		ability.PointTable[1].Used = true
	else
		targetPoint = event.target_points[1]
	end
	local q_2_level = caster:GetRuneValue("q", 2)
	ability.Vector2 = event.target_points[1]
	local damage = event.strength_mult*caster:GetStrength() + event.damage
	local radius = 360
	local max_dis = ability:GetSpecialValueFor("max_distance")
	local procs = Runes:Procs(q_3_level, 10, 1)
	local direction = (ability.Vector2 - targetPoint):Normalized()
	if ability.Vector2 == targetPoint then
		direction = RandomVector(1)
	end
	for j = 0, procs, 1 do
		Timers:CreateTimer(j*0.2, function()
			if j > 0 then
				targetPoint = targetPoint + direction*max_dis/procs
			end
			if j == procs and ability.Vector1 then
				ability.Vector1 = nil
			end
			local pfx = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/fire/monkey_king_spring_arcana_fire.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(pfx, 0, targetPoint+Vector(0,0,120))
			Timers:CreateTimer(6, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
			local stunDuration = 1.2
			if caster:HasModifier("modifier_flamewaker_immortal_weapon_3") then
				stunDuration = stunDuration + stunDuration*1.5
			end
			EmitSoundOnLocationWithCaster(targetPoint, "Flamewaker.ArcanaAbility", caster)
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), targetPoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			if #enemies > 0 then
				for _,enemy in pairs(enemies) do
					if q_2_level > 0 then
						local newStacks = enemy:GetModifierStackCount("modifier_flamewaker_arcana_b_a_effect_stacking_visible", caster) + 1
						ability:ApplyDataDrivenModifier(caster, enemy, "modifier_flamewaker_arcana_b_a_effect_stacking_visible", {duration = 6})
						enemy:SetModifierStackCount("modifier_flamewaker_arcana_b_a_effect_stacking_visible", caster, newStacks)
						ability:ApplyDataDrivenModifier(caster, enemy, "modifier_flamewaker_arcana_b_a_effect_stacking_invisible", {duration = 6})
						enemy:SetModifierStackCount("modifier_flamewaker_arcana_b_a_effect_stacking_invisible", caster, newStacks*q_2_level)
					end
					Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
					Filters:ApplyStun(caster, stunDuration, enemy)
				end
			end 
			GridNav:DestroyTreesAroundPoint(targetPoint, radius-20, false)
		end)
	end	
	if q_2_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_flamewaker_arcana_b_a_effect", {duration = 6})
		caster:SetModifierStackCount("modifier_flamewaker_arcana_b_a_effect", caster, q_2_level)
		local b_a_particle = CustomAbilities:QuickAttachParticle("particles/econ/items/monkey_king/arcana/fire/monkey_king_spring_arcana_fire_channel.vpcf", caster, 4)
		ParticleManager:SetParticleControlEnt(b_a_particle, 1, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	end
	Filters:CastSkillArguments(1, caster)
end

function arcana_ability_think(event)
	local caster = event.caster
	local ability = event.ability
	local q_1_level = caster:GetRuneValue("q", 1)
	if q_1_level > 0 then
		local missingHealth = caster:GetMaxHealth() - caster:GetHealth()
		local a_a_stacks = (missingHealth/200)*q_1_level
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_flamewaker_arcana_a_a_effect", {})
		caster:SetModifierStackCount("modifier_flamewaker_arcana_a_a_effect", caster, a_a_stacks)
	else
		caster:RemoveModifierByName("modifier_flamewaker_arcana_a_a_effect")
	end

	local q_4_level = caster:GetRuneValue("q", 4)
	ability.q_4_level = q_4_level
	if q_4_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_flamewaker_arcana_d_a_effect", {})
		caster:SetModifierStackCount("modifier_flamewaker_arcana_d_a_effect", caster, q_4_level)
	else
		caster:RemoveModifierByName("modifier_flamewaker_arcana_d_a_effect")
	end
end

function d_a_stun(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	if not target:HasModifier("modifier_flamewaker_arcana_d_a_immune") then
		local damage = caster:GetAverageTrueAttackDamage(caster)*0.65*ability.q_4_level
		EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Flamewaker.ArcanaDAStun", target)
		CustomAbilities:QuickAttachParticle("particles/econ/items/techies/techies_arcana/techies_suicide_flame.vpcf", target, 3)
		Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_flamewaker_arcana_d_a_immune", {duration = 0.4})
	end
	-- Filters:ApplyStun(caster, stunDuration, target)	
end