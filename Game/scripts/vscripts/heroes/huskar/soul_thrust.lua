function soul_thrust_start(event)
	local caster = event.caster
	local soundTable = {"SpiritWarrior.SpiritYell1", "SpiritWarrior.SpiritYell2", "SpiritWarrior.SpiritYell3"}
	EmitSoundOn(soundTable[RandomInt(1,3)], caster)
	StartSoundEvent("SpiritWarrior.SoulThrustImpact", caster)
	Timers:CreateTimer(0.33, function()
		if not caster.soulthrustcomplete then
			StopSoundEvent("SpiritWarrior.SoulThrustImpact", caster)
		end
		caster.soulthrustcomplete = false
	end)
	caster.e_4_level = Runes:GetTotalRuneLevel(caster, 4, "e_4", "spirit_warrior")
	caster.q_4_level = Runes:GetTotalRuneLevel(caster, 4, "q_4", "spirit_warrior")
end

function cast_soul_thrust(event)
	local caster = event.caster
	local ability = event.ability
	local centerPoint = caster:GetAbsOrigin()+caster:GetForwardVector()*90
	local damage = event.damage
	if caster:HasModifier("modifier_flametongue") then
		local flametongue = caster:FindAbilityByName("spirit_warrior_flametongue")
		local extraFlametongueDamage = flametongue:GetSpecialValueFor("flat_pure_damage")
		damage = damage + extraFlametongueDamage
	end
	local w_3_level = Runes:GetTotalRuneLevel(caster, 3, "w_3", "spirit_warrior")
	if w_3_level > 0 then
		damage = damage + OverflowProtectedGetAverageTrueAttackDamage(caster)*0.005*w_3_level*ability:GetLevel()
	end

	if caster:HasModifier("modifier_spirit_warrior_d_b") then
		caster:RemoveModifierByName("modifier_spirit_warrior_d_b")
		local runeLevel = caster.runeUnit4:FindAbilityByName("spirit_warrior_rune_w_4").level
		damage = damage*(1+(1.05*runeLevel))
	    local pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/spirit_warrior_d_b_pop.vpcf", PATTACH_CUSTOMORIGIN, caster)
	    ParticleManager:SetParticleControl(pfx2, 0, centerPoint)
	    ParticleManager:SetParticleControl(pfx2, 1, centerPoint)
	    ParticleManager:SetParticleControl(pfx2, 2, centerPoint)
	    ParticleManager:SetParticleControl(pfx2, 3, centerPoint)
	    Timers:CreateTimer(2, function()
	    	ParticleManager:DestroyParticle(pfx2, false)
	    end)
	    EmitSoundOnLocationWithCaster(centerPoint, "SpiritWarrior.DBExplosion", caster)
	end
	caster.soulthrustcomplete = true
	Filters:CastSkillArguments(2, caster)
	local glyphEffect = false
	if caster:HasModifier("modifier_flametongue") and caster:HasModifier("modifier_spirit_warrior_glyph_2_1") then
		glyphEffect = true
	end
	    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), centerPoint, nil, 340, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	    if #enemies > 0 then
	        for _,enemy in pairs(enemies) do
	            Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_FIRE, RPC_ELEMENT_WIND)
	            ability:ApplyDataDrivenModifier(caster, enemy, "modifier_soul_thrust_effect", {duration = 7})
	            if glyphEffect then
	            	local flametongueAbility = caster:FindAbilityByName("spirit_warrior_flametongue")
	            	flametongueAbility.q_1_level = Runes:GetTotalRuneLevel(caster, 1, "q_1", "spirit_warrior")
					if flametongueAbility.q_1_level > 0 then
						flametongueAbility:ApplyDataDrivenModifier(caster,enemy, "modifier_flametongue_a_a_rune", {duration = 5})
						local stacks = enemy:GetModifierStackCount("modifier_flametongue_a_a_rune", caster)
						local newStacks = math.min(stacks+1, 10)
						enemy:SetModifierStackCount("modifier_flametongue_a_a_rune", caster, newStacks)
					end
	            end
	        end
	    end
		if caster:HasModifier("modifier_spirit_warrior_glyph_5_1") then
	    	local manaRestore = ability:GetManaCost(ability:GetLevel()-1)*0.15*#enemies
	    	caster:GiveMana(manaRestore)
	    end 
	    local particleName = "particles/units/heroes/hero_batrider/soul_thrust.vpcf"
	    local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/soul_thrust.vpcf", PATTACH_CUSTOMORIGIN, caster)
	    ParticleManager:SetParticleControl(pfx, 0, centerPoint)
	    ParticleManager:SetParticleControl(pfx, 1, centerPoint)
	    ParticleManager:SetParticleControl(pfx, 2, centerPoint)
	    ParticleManager:SetParticleControl(pfx, 3, centerPoint)
	    Timers:CreateTimer(2, function()
	    	ParticleManager:DestroyParticle(pfx, false)
	    end)
	local w_2_level = Runes:GetTotalRuneLevel(caster, 2, "w_2", "spirit_warrior")
	if w_2_level > 0 then
		local runeAbility = caster.runeUnit2:FindAbilityByName("spirit_warrior_rune_w_2")
		local duration = Filters:GetAdjustedBuffDuration(caster, 5, false)
		runeAbility:ApplyDataDrivenModifier(caster.runeUnit2, caster,"modifier_spirit_warrior_rune_w_2_visible", {duration = duration})
		runeAbility:ApplyDataDrivenModifier(caster.runeUnit2, caster,"modifier_spirit_warrior_rune_w_2_invisible", {duration = duration})
		local currentStacks = caster:GetModifierStackCount("modifier_spirit_warrior_rune_w_2_visible", caster.runeUnit2)
		local newStacks = math.min(currentStacks + 1, 3)
		caster:SetModifierStackCount("modifier_spirit_warrior_rune_w_2_visible", caster.runeUnit2, newStacks)
		caster:SetModifierStackCount("modifier_spirit_warrior_rune_w_2_invisible", caster.runeUnit2, newStacks*w_2_level*ability:GetLevel())
		local particleName = "particles/econ/items/outworld_devourer/od_shards_exile/spirit_warrior_b_b.vpcf"
		if not runeAbility.pfx then
			runeAbility.pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
		end
		ParticleManager:SetParticleControl(runeAbility.pfx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(runeAbility.pfx, 1, Vector(80*newStacks, 80*newStacks, 80*newStacks))
	end
end

function spirit_warrior_thinking(event)
	local caster = event.caster
	local manaDifferential = caster:GetMaxMana() - caster:GetMana()
	if manaDifferential > 33 then
		local w_1_level = Runes:GetTotalRuneLevel(caster, 1, "w_1", "spirit_warrior")
		if w_1_level > 0 then
			local runeAbility = caster.runeUnit:FindAbilityByName("spirit_warrior_rune_w_1")
			runeAbility:ApplyDataDrivenModifier(caster.runeUnit, caster, "modifier_spirit_warrior_rune_w_1", {})
			local damageStacks = math.floor(manaDifferential*0.08*w_1_level)
			caster:SetModifierStackCount("modifier_spirit_warrior_rune_w_1", caster.runeUnit, damageStacks)
		end
	else
		caster:RemoveModifierByName("modifier_spirit_warrior_rune_w_1")
	end
end

function b_b_end(event)
	local ability = event.ability
	ParticleManager:DestroyParticle(ability.pfx, false)
	ability.pfx = false
end