function PhaseStartArcanaAbility(event)
	local ability = event.ability
	local caster = event.caster
	if not ability.PointTable then
		ability.PointTable = {}
	end
	local target = event.target_points[1]
	if Runes:GetTotalRuneLevel(caster, 3, "c_a_arcana1", "flamewaker") > 0 and (ability.PointTable[1] == nil or ability.PointTable[1].Used == true) then
		table.insert(ability.PointTable, 1, {target, Used = false})
		caster:Stop()
	end
end

function start_arcana_ability(event)
	local caster = event.caster
	local ability = event.ability
	local targetPoint =  ability.PointTable[1][1]
	ability.PointTable[1].Used = true
	local b_a_level = Runes:GetTotalRuneLevel(caster, 2, "b_a_arcana1", "flamewaker")
	ability.Vector2 = event.target_points[1]
	local damage = event.strength_mult*caster:GetStrength() + event.damage
	local radius = 360
	local max_dis = ability:GetSpecialValueFor("max_distance")
	local c_a_level = Runes:GetTotalRuneLevel(caster, 3, "c_a_arcana1", "flamewaker")
	if c_a_level < 1 then
		targetPoint = event.target_points[1]
	end
	local procs = Runes:Procs(c_a_level, 10, 1)
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
					if b_a_level > 0 then
						local newStacks = enemy:GetModifierStackCount("modifier_flamewaker_arcana_b_a_effect_stacking_visible", caster) + 1
						ability:ApplyDataDrivenModifier(caster, enemy, "modifier_flamewaker_arcana_b_a_effect_stacking_visible", {duration = 6})
						enemy:SetModifierStackCount("modifier_flamewaker_arcana_b_a_effect_stacking_visible", caster, newStacks)
						ability:ApplyDataDrivenModifier(caster, enemy, "modifier_flamewaker_arcana_b_a_effect_stacking_invisible", {duration = 6})
						enemy:SetModifierStackCount("modifier_flamewaker_arcana_b_a_effect_stacking_invisible", caster, newStacks*b_a_level)
					end
					Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
					Filters:ApplyStun(caster, stunDuration, enemy)
				end
			end 
			GridNav:DestroyTreesAroundPoint(targetPoint, radius-20, false)
		end)
	end	
	if b_a_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_flamewaker_arcana_b_a_effect", {duration = 6})
		caster:SetModifierStackCount("modifier_flamewaker_arcana_b_a_effect", caster, b_a_level)
		local b_a_particle = CustomAbilities:QuickAttachParticle("particles/econ/items/monkey_king/arcana/fire/monkey_king_spring_arcana_fire_channel.vpcf", caster, 4)
		ParticleManager:SetParticleControlEnt(b_a_particle, 1, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	end
	Filters:CastSkillArguments(1, caster)
end

function arcana_ability_think(event)
	local caster = event.caster
	local ability = event.ability
	local a_a_level = Runes:GetTotalRuneLevel(caster, 1, "a_a_arcana1", "flamewaker")
	if a_a_level > 0 then
		local missingHealth = caster:GetMaxHealth() - caster:GetHealth()
		local a_a_stacks = (missingHealth/200)*a_a_level
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_flamewaker_arcana_a_a_effect", {})
		caster:SetModifierStackCount("modifier_flamewaker_arcana_a_a_effect", caster, a_a_stacks)
	else
		caster:RemoveModifierByName("modifier_flamewaker_arcana_a_a_effect")
	end

	local d_a_level = Runes:GetTotalRuneLevel(caster, 4, "d_a_arcana1", "flamewaker")
	ability.d_a_level = d_a_level
	if d_a_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_flamewaker_arcana_d_a_effect", {})
		caster:SetModifierStackCount("modifier_flamewaker_arcana_d_a_effect", caster, d_a_level)
	else
		caster:RemoveModifierByName("modifier_flamewaker_arcana_d_a_effect")
	end
end

function d_a_stun(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	if not target:HasModifier("modifier_flamewaker_arcana_d_a_immune") then
		local damage = caster:GetAverageTrueAttackDamage(caster)*0.65*ability.d_a_level
		EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Flamewaker.ArcanaDAStun", target)
		CustomAbilities:QuickAttachParticle("particles/econ/items/techies/techies_arcana/techies_suicide_flame.vpcf", target, 3)
		Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_flamewaker_arcana_d_a_immune", {duration = 0.4})
	end
	-- Filters:ApplyStun(caster, stunDuration, target)	
end