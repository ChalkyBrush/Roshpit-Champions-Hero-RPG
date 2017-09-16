function start_arcana_ability(event)
	local caster = event.caster
	local ability = event.ability
	local targetPoint = event.target_points[1]
	local damage = event.strength_mult*caster:GetStrength() + event.damage
	local radius = 360
	local c_a_level = Runes:GetTotalRuneLevel(caster, 3, "c_a_arcana1", "flamewaker")
	local procs = Runes:Procs(c_a_level, 10, 1)
	for j = 0, procs, 1 do
		Timers:CreateTimer(j*0.2, function()
			if j > 0 then
				targetPoint = targetPoint + RandomVector(RandomInt(100, 200))
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
					Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
					Filters:ApplyStun(caster, stunDuration, enemy)
				end
			end 
			GridNav:DestroyTreesAroundPoint(targetPoint, radius-20, false)
		end)
	end	
	local b_a_level = Runes:GetTotalRuneLevel(caster, 2, "b_a_arcana1", "flamewaker")
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