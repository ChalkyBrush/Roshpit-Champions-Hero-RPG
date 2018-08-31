--[[
	Author: Noya
	Date: 25.01.2015.
	Creates a dummy unit to apply the Blizzard thinker modifier which does the waves
]]
function BlizzardStart( event )
	-- Variables
	local caster = event.caster
	local point = event.target_points[1]
	local ability = event.ability
	if caster:HasModifier("modifier_sorceress_immortal_ice_avatar") then
		StartSoundEvent("hero_Crystal.freezingField.wind", caster)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_blizzard_channelling", {})
		caster = caster.origCaster
	else
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_blizzard_channelling", {})
		StartSoundEvent("hero_Crystal.freezingField.wind", caster)
		rune_q_1(caster, event.ability)
	end
	
	if not ability.blizzard_dummy_table then
		ability.blizzard_dummy_table = {}
	end
	
	local dummy = CreateUnitByName("dummy_unit_vulnerable", point, false, caster, caster, caster:GetTeam())
  	dummy:AddAbility("dummy_unit")
  	dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
  	dummy.active = true
  	dummy.thinks = 0
	event.ability:ApplyDataDrivenModifier(caster, dummy, "modifier_blizzard_thinker", {duration = 5})
	table.insert(ability.blizzard_dummy_table, dummy)
	
	-- rune_q_3(caster, event.ability)
    caster.q_4_level = Runes:GetTotalRuneLevel(caster, 4, "q_4", "sorceress")
    
	Filters:CastSkillArguments(1, caster)
	if caster:HasModifier("modifier_sorceress_glyph_6_1") then
		caster:Stop()
		StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_ATTACK, rate=1.4})
		EmitSoundOn("Sorceress.Blizzard61Cast", caster)
	end
	dummy.windParticle = ParticleManager:CreateParticle("particles/econ/items/warlock/warlock_staff_hellborn/sorceress_blizzard.vpcf", PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( dummy.windParticle, 0, point )
end

function rune_q_1(caster, ability)
  local runeUnit = caster.runeUnit
  local runeAbility = runeUnit:FindAbilityByName("sorceress_rune_q_1")
  local abilityLevel = runeAbility:GetLevel()
  local bonusLevel = Runes:GetTotalBonus(runeUnit, "q_1")
  local totalLevel = abilityLevel + bonusLevel
  if totalLevel > 0 then
  	local iceLance = caster:FindAbilityByName("ice_lance")
  	if not iceLance then
  		iceLance = caster:AddAbility("ice_lance")
  	end
  	ability:ApplyDataDrivenModifier(caster, caster, "modifier_blizzard_cooldown", {duration = 15})
  	iceLance:SetLevel(ability:GetLevel())
  	iceLance:SetAbilityIndex(0)
  	iceLance.rune_q_1_level = totalLevel
  	ability.rune_q_1_level = totalLevel
  	caster:SwapAbilities("blizzard", "ice_lance", false, true)
  end
end

function cooldownEnd(event)
	local ability = event.ability
	local caster = event.caster
	local level = caster:FindAbilityByName("ice_lance"):GetLevel()
  	ability:SetLevel(level)
  	caster:SwapAbilities("blizzard", "ice_lance", true, false)	
end

function rune_q_3(caster, ability)
  local runeUnit = caster.runeUnit3
  local runeAbility = runeUnit:FindAbilityByName("sorceress_rune_q_3")
  local abilityLevel = runeAbility:GetLevel()
  local bonusLevel = Runes:GetTotalBonus(runeUnit, "q_3")
  local totalLevel = abilityLevel + bonusLevel
  if totalLevel > 0 then
  	ability:ApplyDataDrivenModifier(caster, caster, "modifier_ice_block", {duration = 5})
  	caster:SetModifierStackCount( "modifier_ice_block", ability, totalLevel )
  end
end


-- -- Create the particles with small delays between each other
function BlizzardWave( event )
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if event.target.active then
		target.thinks = target.thinks + 1
		local target_position = event.target:GetAbsOrigin() --event.target_points[1]
	    local particleName = "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_explosion.vpcf"
	    local distance = 100

	    -- Center explosion
	    target.particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( target.particle1, 0, target_position+Vector(0,0,100) )



		local fv = caster:GetForwardVector()
	    local distance = 100

	    Timers:CreateTimer(0.03,function()
	    target.particle2 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		 ParticleManager:SetParticleControl( target.particle2, 0, target_position+RandomVector(400) ) 
	    target.particle3 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		 ParticleManager:SetParticleControl( target.particle3, 0, target_position+RandomVector(400) ) 
		 end)

	    Timers:CreateTimer(0.06,function()
		target.particle4 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		 ParticleManager:SetParticleControl( target.particle4, 0, target_position-RandomVector(400) ) 
		target.particle5 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		 ParticleManager:SetParticleControl( target.particle5, 0, target_position-RandomVector(400) ) 
		 end)

	    Timers:CreateTimer(0.09,function()
		target.particle6 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		 ParticleManager:SetParticleControl( target.particle6, 0, target_position+RandomVector(RandomInt(50,400)) ) 
		target.particle7 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		 ParticleManager:SetParticleControl( target.particle7, 0, target_position+RandomVector(RandomInt(50,400)) ) 
		 end)

	    Timers:CreateTimer(0.12,function()
		target.particle8 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		 ParticleManager:SetParticleControl( target.particle8, 0, target_position-RandomVector(RandomInt(100,300)) ) 
		target.particle9 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		 ParticleManager:SetParticleControl( target.particle9, 0, target_position-RandomVector(RandomInt(100,300)) )
		 end)

	    Timers:CreateTimer(0.15,function()
		target.particle10 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		 ParticleManager:SetParticleControl( target.particle10, 0, target_position-RandomVector(RandomInt(70,270)) ) 
		target.particle11 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		 ParticleManager:SetParticleControl( target.particle11, 0, target_position-RandomVector(RandomInt(70,270)) ) 
		 end)

	    EmitSoundOn("hero_Crystal.freezingField.explosion", caster)
		local radius = event.radius
		local damage = event.damage
		-- damage = damage + 0.0002*(caster:GetStrength()+caster:GetAgility()+caster:GetIntellect())/10*ability.q_4_level*damage
		if caster:HasModifier("modifier_sorceress_glyph_1_1") then
			damage = damage*2
		end
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target_position, nil, radius+60, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		Timers:CreateTimer(0.35,function()
			if #enemies > 0 then
				for _,enemy in pairs(enemies) do
					Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_ICE, RPC_ELEMENT_NONE)
					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_blizzard_slow", {duration = event.slow_duration})
					if caster:HasModifier("modifier_sorceress_glyph_1_1") then
						ability:ApplyDataDrivenModifier(caster, enemy, "modifier_sorceress_glyph_1_1_effect", {duration = event.slow_duration})
					end
					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_blizzard_ice_resist_loss", {duration = 8})
					local newStacks = enemy:GetModifierStackCount("modifier_blizzard_ice_resist_loss", caster) + (event.ice_resist_loss)/10
					enemy:SetModifierStackCount("modifier_blizzard_ice_resist_loss", caster, newStacks)
				end
			end 
		end)
		Timers:CreateTimer(0.75, function()
			ParticleManager:DestroyParticle(target.particle1, false)
			ParticleManager:DestroyParticle(target.particle2, false)
			ParticleManager:DestroyParticle(target.particle3, false)
			ParticleManager:DestroyParticle(target.particle4, false)
			ParticleManager:DestroyParticle(target.particle5, false)
			ParticleManager:DestroyParticle(target.particle6, false)
			ParticleManager:DestroyParticle(target.particle7, false)
			ParticleManager:DestroyParticle(target.particle8, false)
			ParticleManager:DestroyParticle(target.particle9, false)
			ParticleManager:DestroyParticle(target.particle10, false)
			ParticleManager:DestroyParticle(target.particle11, false)

		end)

		if caster:HasModifier("modifier_sorceress_glyph_6_1") and target.thinks >= 5 then
			local dummy = target
			if IsValidEntity(dummy) then
				ParticleManager:DestroyParticle(dummy.windParticle, false)
				dummy.active = false
				-- caster.blizzard_dummy:RemoveModifierByName("modifier_blizzard_thinker")
				if #ability.blizzard_dummy_table <= 1 then
					StopSoundEvent("hero_Crystal.freezingField.wind", caster)
				end
				Timers:CreateTimer(3,function()
					UTIL_Remove(dummy)
					local newTable = {}
					for i = 1, #ability.blizzard_dummy_table, 1 do
						if IsValidEntity(ability.blizzard_dummy_table[i]) then
							table.insert(newTable, dummy)
						end
					end
					print("---#NEWTABLE----")
					print(#newTable)
					if #newTable == 0 then
						StopSoundEvent("hero_Crystal.freezingField.wind", caster)
					end
					ability.blizzard_dummy_table = newTable

				end)
			end			
		end
    end
end

function BlizzardEnd( event )
	local caster = event.caster
	local ability = event.ability
	if caster:HasModifier("modifier_sorceress_glyph_6_1") then
		-- Timers:CreateTimer(5, function()
		-- 	StopSoundEvent("hero_Crystal.freezingField.wind", caster)
		-- 	ParticleManager:DestroyParticle(ability.particleMain, false)
		-- 	if caster.blizzard_dummy then
		-- 		caster.blizzard_dummy.active = false
		-- 		-- caster.blizzard_dummy:RemoveModifierByName("modifier_blizzard_thinker")
		-- 		Timers:CreateTimer(3,function()
		-- 			UTIL_Remove(caster.blizzard_dummy)
		-- 		end)
		-- 	end
		-- end)
	else
		StopSoundEvent("hero_Crystal.freezingField.wind", caster)
		for i = 1, #ability.blizzard_dummy_table, 1 do
			local dummy = ability.blizzard_dummy_table[i]
			if IsValidEntity(dummy) then
				ParticleManager:DestroyParticle(dummy.windParticle, false)
				dummy.active = false
				-- caster.blizzard_dummy:RemoveModifierByName("modifier_blizzard_thinker")
				Timers:CreateTimer(3,function()
					UTIL_Remove(dummy)
				end)
			end
		end
		ability.blizzard_dummy_table = {}
	end
end

function sorceress_passive_think(event)
	local caster = event.caster
	local ability = event.ability
	local q_3_level = Runes:GetTotalRuneLevel(caster, 3, "q_3", "sorceress")
	if q_3_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_sorceress_spell_damage_amp", {})
		caster:SetModifierStackCount("modifier_sorceress_spell_damage_amp", caster, q_3_level)
	else
		caster:RemoveModifierByName("modifier_sorceress_spell_damage_amp")
	end
end

function channel_finish(event)
	local caster = event.caster
	local ability = event.ability
	caster:RemoveModifierByName("modifier_blizzard_channelling")
end