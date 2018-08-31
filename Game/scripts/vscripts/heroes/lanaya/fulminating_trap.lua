require('heroes/lanaya/constants')

function trap_start(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	EmitSoundOn("Trapper.FulminatingPlacement", caster)
	Filters:CastSkillArguments(1, caster)
		if ability.total_traps == nil then
			ability.total_traps = 0
			ability.traps = {}
		end
		local max_traps = 1
		if caster:HasModifier("modifier_trapper_glyph_7_1") then
			max_traps = 2
		end
		if ability.total_traps >= max_traps then
			ability.traps[1]:RemoveModifierByName("lanaya_fulimating_passive")
			ability.traps = reindexTraps(ability)
		end
		local trap = CreateUnitByName("lanaya_trap", point, true, caster, nil, caster:GetTeam())
		trap.damage = event.damage/2
	    local q_4_level = Runes:GetTotalRuneLevel(caster, 4, "q_4", "trapper")
	    trap.damage = trap.damage + 0.0025*caster:GetIntellect()/10*q_4_level*trap.damage
	    if caster:HasModifier("modifier_trapper_glyph_5_a") then
	    	trap.damage = trap.damage * T5A_DAMAGE_AMPLIFY
	    end
		trap.origCaster = caster


		ability.total_traps = ability.total_traps + 1
		table.insert(ability.traps, trap)

		ability:ApplyDataDrivenModifier(caster, trap, "modifier_psionic_trap_datadriven", {})
		
		trap:SetOwner(caster)
		trap:SetControllableByPlayer(caster:GetPlayerID(), true)
		

		trap:RemoveAbility("templar_assassin_self_trap")
		trap.q_3_level = Runes:GetTotalRuneLevel(caster, 3, "q_3", "trapper")
        if caster:HasModifier("modifier_trapper_glyph_1_2") then
            trap.q_3_level = trap.q_3_level * T12_AMPLIFY
        end
		
		local trapAbility = trap:AddAbility("fuliminating_trap_passive")
		trapAbility:SetLevel(1)
		trapAbility:ApplyDataDrivenModifier(trap, trap, "lanaya_fulimating_passive", {})

		trap.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/fulminating_trap_portrait.vpcf", PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(trap.particle, 0, point)
		ParticleManager:SetParticleControl(trap.particle, 1, point)
		ParticleManager:SetParticleControl(trap.particle, 2, point)	

		rune_q_1(caster)
		trap_cast(caster)

end

function trap_cast(caster)
    if caster:HasModifier("modifier_trapper_arcana1") then
    	caster.w_4_arcana_level = caster:GetRuneValue("w", 4)
	end
end

function rune_q_1(caster)
	local q_1_level = Runes:GetTotalRuneLevel(caster, 1, "q_1", "trapper")
	if q_1_level > 0 then
	    local poison_trap = caster:FindAbilityByName("poison_trap")
	  	if not poison_trap then
	  		poison_trap = caster:AddAbility("poison_trap")
	  	end
	  	local fulminating_trap = caster:FindAbilityByName("fulminating_trap")
	  	poison_trap:SetLevel(fulminating_trap:GetLevel())
	  	fulminating_trap:SetAbilityIndex(0)
	  	poison_trap:SetAbilityIndex(0)
	  	caster:SwapAbilities("fulminating_trap", "poison_trap", false, true)
	  	caster.poison = true
	end
end

function trap_start_poison(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	StartSoundEvent("Trapper.PoisonTrapPlacement", caster)
	Timers:CreateTimer(3, function()
		StopSoundEvent("Trapper.PoisonTrapPlacement", caster)
	end)
		if ability.total_traps == nil then
			ability.total_traps = 0
			ability.traps = {}
		end
		local max_traps = 1
		if caster:HasModifier("modifier_trapper_glyph_7_1") then
			max_traps = 2
		end
		if ability.total_traps >= max_traps then
			ability.traps[1]:RemoveModifierByName("lanaya_poison_trap_passive")
			ability.traps = reindexTraps(ability)
		end
		local trap = CreateUnitByName("lanaya_trap", point, true, caster, nil, caster:GetTeam())
		trap.origCaster = caster

		trap.q_3_level = Runes:GetTotalRuneLevel(caster, 3, "q_3", "trapper")
        if caster:HasModifier("modifier_trapper_glyph_1_2") then
            trap.q_3_level = trap.q_3_level * T12_AMPLIFY
        end
		-- Places the trap in the list and increments the total
		ability.total_traps = ability.total_traps + 1
		table.insert(ability.traps, trap)
		-- Applies the modifier to the trap
		ability:ApplyDataDrivenModifier(caster, trap, "modifier_psionic_trap_datadriven", {})
		
		trap:SetOwner(caster)
		trap:SetControllableByPlayer(caster:GetPlayerID(), true)
		trap.root_duration = event.root_duration
		-- Removes the default trap ability and adds both new abilities
		
		-- caster:AddAbility("templar_assassin_trap_datadriven")
		-- caster:FindAbilityByName("templar_assassin_trap_datadriven"):UpgradeAbility(true)
		
		local trapAbility = trap:AddAbility("poison_trap_passive")
		trapAbility:SetLevel(1)
		trapAbility:ApplyDataDrivenModifier(trap, trap, "lanaya_poison_trap_passive", {})

		local q_1_level = Runes:GetTotalRuneLevel(caster, 1, "q_1", "trapper")
		trapAbility.poisonDamage = q_1_level*TRAPPER_Q1_DAMAGE
	    local q_4_level = Runes:GetTotalRuneLevel(caster, 4, "q_4", "trapper")
	    trapAbility.poisonDamage = trapAbility.poisonDamage + 0.0025*caster:GetIntellect()/10*q_4_level*trapAbility.poisonDamage
		print("poison damage " .. trapAbility.poisonDamage)
		if caster:HasModifier("modifier_trapper_glyph_5_a") then
	    	trapAbility.poisonDamage = trapAbility.poisonDamage * T5A_DAMAGE_AMPLIFY
	    end
		-- Plays the sounds
		-- EmitSoundOn(keys.sound, caster)
		-- EmitSoundOn(keys.sound2, trap)
		
		-- Renders the trap particle on the target position (it is not a model particle, so cannot be attached to the unit)
		point = point+Vector(0,0,10)
		trap.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/poison_trap_portrait.vpcf", PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(trap.particle, 0, point)
		ParticleManager:SetParticleControl(trap.particle, 1, point)
		ParticleManager:SetParticleControl(trap.particle, 2, point)	

		local level = ability:GetLevel()
	  	caster:FindAbilityByName("fulminating_trap"):SetLevel(level)
	  	caster:FindAbilityByName("fulminating_trap"):SetAbilityIndex(0)
	  	caster:SwapAbilities("fulminating_trap", "poison_trap", true, false)
	  	caster.poison = false
	  	trap_cast(caster)
end


function reindexTraps(ability)
	local tempTable = {}
	for i = 1, #ability.traps, 1 do
		if IsValidEntity(ability.traps[i]) then
			table.insert(tempTable, ability.traps[i])
		end
	end	
	return tempTable
end

function trap_think(event)
	local trap = event.caster
	local caster = trap.origCaster
	local ability = event.ability
	local position = trap:GetAbsOrigin()
	local radius = TRAP_RADIUS
	local damage = trap.damage
	local q_3_level = trap.q_3_level
    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
    if #enemies > 0 then    
        for _,enemy in pairs(enemies) do
        	Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
            ability:ApplyDataDrivenModifier(trap, enemy, "modifier_fulminating_burn_effect", {duration = 0.5})
            CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_leshrac/fulminating_effect.vpcf", enemy, 0.5)
            if q_3_level > 0 then
            	ability:ApplyDataDrivenModifier(trap, enemy, "modifier_fulminating_magic_resist_loss", {duration = 1.0})
            	enemy:SetModifierStackCount("modifier_fulminating_magic_resist_loss", ability, q_3_level)
            end
        end
        EmitSoundOn("Trapper.FulminatingHit", trap)
    end
end

function trap_destroy(event)
	local trap = event.caster
	ParticleManager:DestroyParticle(trap.particle, false)
	UTIL_Remove(trap)
end

function trap_start_net(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	EmitSoundOn("Trapper.NetTrapPlacement", caster)
		if ability.total_traps == nil then
			ability.total_traps = 0
			ability.traps = {}
		end
		local max_traps = 1
		if ability.total_traps >= max_traps then
			ability.traps[1]:RemoveModifierByName("lanaya_net_passive")
			ability.traps = reindexTraps(ability)
		end
		local trap = CreateUnitByName("lanaya_trap", point, true, caster, nil, caster:GetTeam())
		trap.origCaster = caster

		trap.q_3_level = Runes:GetTotalRuneLevel(caster, 3, "q_3", "trapper")
        if caster:HasModifier("modifier_trapper_glyph_1_2") then
            trap.q_3_level = trap.q_3_level * T12_AMPLIFY
        end
		Filters:CastSkillArguments(1, caster)
		-- Places the trap in the list and increments the total
		ability.total_traps = ability.total_traps + 1
		table.insert(ability.traps, trap)
		-- Applies the modifier to the trap
		ability:ApplyDataDrivenModifier(caster, trap, "modifier_psionic_trap_datadriven", {})
		
		trap:SetOwner(caster)
		trap:SetControllableByPlayer(caster:GetPlayerID(), true)
		trap.root_duration = event.root_duration
		-- Removes the default trap ability and adds both new abilities
		
		-- caster:AddAbility("templar_assassin_trap_datadriven")
		-- caster:FindAbilityByName("templar_assassin_trap_datadriven"):UpgradeAbility(true)
		
		local trapAbility = trap:AddAbility("net_trap_passive")
		trapAbility:SetLevel(1)
		trapAbility:ApplyDataDrivenModifier(trap, trap, "lanaya_net_passive", {})
		-- Plays the sounds
		-- EmitSoundOn(keys.sound, caster)
		-- EmitSoundOn(keys.sound2, trap)
		
		-- Renders the trap particle on the target position (it is not a model particle, so cannot be attached to the unit)
		point = point+Vector(0,0,10)
		trap.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/net_trap_portrait.vpcf", PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(trap.particle, 0, point)
		ParticleManager:SetParticleControl(trap.particle, 1, point)
		ParticleManager:SetParticleControl(trap.particle, 2, point)	
		rune_q_2(caster)
		trap_cast(caster)

end

function rune_q_2(caster)
	local q_2_level = Runes:GetTotalRuneLevel(caster, 2, "q_2", "trapper")
	if q_2_level > 0 then
	    local torrent_trap = caster:FindAbilityByName("torrent_trap")
	  	if not torrent_trap then
	  		torrent_trap = caster:AddAbility("torrent_trap")
	  	end
	  	local net_trap = caster:FindAbilityByName("net_trap")
	  	torrent_trap:SetLevel(net_trap:GetLevel())
	  	net_trap:SetAbilityIndex(0)
	  	torrent_trap:SetAbilityIndex(0)
	  	caster:SwapAbilities("net_trap", "torrent_trap", false, true)
	  	caster.torrent = true
	end
end

function net_trap_think(event)
	local trap = event.caster
	local caster = trap.origCaster
	local ability = event.ability
	local position = trap:GetAbsOrigin()
	local radius = TRAP_RADIUS
	local root_duration = trap.root_duration
	local damage = trap.damage
    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
    local q_3_level = trap.q_3_level
	if #enemies > 0 then
        for _,enemy in pairs(enemies) do
        	if not enemy:HasModifier("modifier_net_trap_immunity") then
	            ability:ApplyDataDrivenModifier(trap, enemy, "modifier_net_trap_building_up", {duration = 0.6})
	            local currentStacks = enemy:GetModifierStackCount( "modifier_net_trap_building_up", ability )
	            enemy:SetModifierStackCount( "modifier_net_trap_building_up", ability, currentStacks + 1 )
	            if (currentStacks + 1) == 3 then
	            	EmitSoundOn("Trapper.NetEffect", enemy)
                    ability:ApplyDataDrivenModifier(trap, enemy, "modifier_net_trap_netted_effect", {duration = root_duration})
                    if caster:HasModifier("modifier_trapper_glyph_4_2") then
                        ability:ApplyDataDrivenModifier(trap, enemy, "modifier_net_trap_silence_effect", {duration = root_duration})
                    end
	            	ability:ApplyDataDrivenModifier(trap, enemy, "modifier_net_trap_immunity", {duration = 11})
				end
				if q_3_level > 0 then
					ability:ApplyDataDrivenModifier(trap, enemy, "modifier_fulminating_magic_resist_loss", {duration = 1.0})
					enemy:SetModifierStackCount("modifier_fulminating_magic_resist_loss", ability, q_3_level)
				end
	        end
        end
        
    end
end

function poison_trap_think(event)
	local trap = event.caster
	local caster = trap.origCaster
	local ability = event.ability
	local position = trap:GetAbsOrigin()
	local radius = TRAP_RADIUS
    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
    local q_3_level = trap.q_3_level

	ability.origCaster = caster

	if #enemies > 0 then
        for _,enemy in pairs(enemies) do
            ability:ApplyDataDrivenModifier(trap, enemy, "modifier_poison_trap_effect", {duration = 6})
            local currentStacks = enemy:GetModifierStackCount( "modifier_poison_trap_effect", ability )
            local newStacks = math.min(currentStacks+1, Q1_MAX_STACKS_COUNT)
            enemy:SetModifierStackCount( "modifier_poison_trap_effect", ability, newStacks )
            CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_leshrac/poison_trap_effect.vpcf", enemy, 0.5)
            if caster:HasModifier("modifier_trapper_glyph_3_1") then
            	ability:ApplyDataDrivenModifier(trap, enemy, "modifier_poison_trap_glyph_3_1", {duration = 6})
            	enemy:SetModifierStackCount( "modifier_poison_trap_glyph_3_1", ability, newStacks )
			end
			if q_3_level > 0 then
				ability:ApplyDataDrivenModifier(trap, enemy, "modifier_fulminating_magic_resist_loss", {duration = 1.0})
				enemy:SetModifierStackCount("modifier_fulminating_magic_resist_loss", ability, q_3_level)
			end
        end
        EmitSoundOn("Trapper.PoisonTrapHit", trap)
    end
end

function poison_debuff_think(event)
	local target = event.target
	local ability = event.ability
	if IsValidEntity(event.caster) then
		local origCaster = ability.origCaster
		local stackCount = target:GetModifierStackCount( "modifier_poison_trap_effect", ability )
		local damage = ability.poisonDamage*stackCount
		Filters:ApplyDotDamage(origCaster, ability, target, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_POISON, RPC_ELEMENT_NONE)
	end
end

function trap_start_torrent(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	StartSoundEvent("Trapper.TorrentTrapPlacement", caster)
	Timers:CreateTimer(3, function()
		StopSoundEvent("Trapper.TorrentTrapPlacement", caster)
	end)
	trap_cast(caster)
		if ability.total_traps == nil then
			ability.total_traps = 0
			ability.traps = {}
		end
		local max_traps = 1
		if ability.total_traps >= max_traps then
			ability.traps[1]:RemoveModifierByName("lanaya_torrent_passive")
			ability.traps = reindexTraps(ability)
		end
		local trap = CreateUnitByName("lanaya_trap", point, true, caster, nil, caster:GetTeam())
		trap.origCaster = caster

		trap.q_3_level = Runes:GetTotalRuneLevel(caster, 3, "q_3", "trapper")
        if caster:HasModifier("modifier_trapper_glyph_1_2") then
            trap.q_3_level = trap.q_3_level * T12_AMPLIFY
        end
		-- Places the trap in the list and increments the total
		ability.total_traps = ability.total_traps + 1
		table.insert(ability.traps, trap)
		-- Applies the modifier to the trap
		ability:ApplyDataDrivenModifier(caster, trap, "modifier_psionic_trap_datadriven", {})
		
		trap:SetOwner(caster)
		trap:SetControllableByPlayer(caster:GetPlayerID(), true)
		trap.root_duration = event.root_duration
		-- Removes the default trap ability and adds both new abilities
		
		-- caster:AddAbility("templar_assassin_trap_datadriven")
		-- caster:FindAbilityByName("templar_assassin_trap_datadriven"):UpgradeAbility(true)
		
		local trapAbility = trap:AddAbility("torrent_trap_passive")
		trapAbility:SetLevel(1)
		trapAbility:ApplyDataDrivenModifier(trap, trap, "lanaya_torrent_passive", {})

		local q_2_level = Runes:GetTotalRuneLevel(caster, 2, "q_2", "trapper")
		trapAbility.q_2_level = q_2_level
		trapAbility.q_2_damage = q_2_level*Q2_DAMAGE
	    local q_4_level = Runes:GetTotalRuneLevel(caster, 4, "q_4", "trapper")
	    trapAbility.q_2_damage = trapAbility.q_2_damage + 0.0025*caster:GetIntellect()/10*q_4_level*trapAbility.q_2_damage
	    if caster:HasModifier("modifier_trapper_glyph_5_a") then
	    	trapAbility.q_2_damage = trapAbility.q_2_damage * T5A_DAMAGE_AMPLIFY
	    end
		-- Plays the sounds
		-- EmitSoundOn(keys.sound, caster)
		-- EmitSoundOn(keys.sound2, trap)
		
		-- Renders the trap particle on the target position (it is not a model particle, so cannot be attached to the unit)
		point = point+Vector(0,0,10)
		trap.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/torrent_trap_portrait.vpcf", PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(trap.particle, 0, point)
		ParticleManager:SetParticleControl(trap.particle, 1, point)
		ParticleManager:SetParticleControl(trap.particle, 2, point)	

		local level = ability:GetLevel()
	  	caster:FindAbilityByName("net_trap"):SetLevel(level)
	  	caster:FindAbilityByName("net_trap"):SetAbilityIndex(0)
	  	caster:SwapAbilities("net_trap", "torrent_trap", true, false)
	  	caster.torrent = false
end

function torrent_trap_think(event)
	local trap = event.caster
	local caster = trap.origCaster
	local ability = event.ability
	local position = trap:GetAbsOrigin()
	local radius = TRAP_RADIUS
	local damage = ability.q_2_damage
    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	local q_3_level = trap.q_3_level

    if #enemies > 0 then    
        for _,enemy in pairs(enemies) do
        	if not enemy:HasModifier("modifier_torrent_trap_immunity") then
	            ability:ApplyDataDrivenModifier(trap, enemy, "modifier_torrent_trap_building_up", {duration = 0.6})
	            local currentStacks = enemy:GetModifierStackCount( "modifier_torrent_trap_building_up", ability )
	            enemy:SetModifierStackCount( "modifier_torrent_trap_building_up", ability, currentStacks + 1 )
	            if (currentStacks + 1) == 5 then
	            	local point = enemy:GetAbsOrigin()
	            	if not enemy:HasModifier("modifier_lasso_pull") then
						local modifierKnockback =
						{
							center_x = point.x,
							center_y = point.y,
							center_z = point.z,
							duration = 2,
							knockback_duration = 2,
							knockback_distance = 0,
							knockback_height = 400
						}
						enemy:AddNewModifier( caster, nil, "modifier_knockback", modifierKnockback )
					end
	            	EmitSoundOn("Trapper.TorrentImpact", enemy)
	            	ability:ApplyDataDrivenModifier(trap, enemy, "modifier_torrent_trap_slowed_effect", {duration = 2})
	            	Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_WATER, RPC_ELEMENT_NONE)
	            	enemy:SetModifierStackCount("modifier_torrent_trap_slowed_effect", ability, ability.q_2_level)
	            	ability:ApplyDataDrivenModifier(trap, enemy, "modifier_torrent_trap_immunity", {duration = 1})
	            	-- CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_morphling/morphling_adaptive_strike.vpcf", enemy, 1)
					local particleName = "particles/units/heroes/hero_morphling/morphling_adaptive_strike.vpcf"
					local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, enemy )
					ParticleManager:SetParticleControlEnt(pfx, 0, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(pfx, 1, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
					Timers:CreateTimer(1, function() 
					  ParticleManager:DestroyParticle( pfx, false )
					end)
				end

				if q_3_level > 0 then
					ability:ApplyDataDrivenModifier(trap, enemy, "modifier_fulminating_magic_resist_loss", {duration = 1.0})
					enemy:SetModifierStackCount("modifier_fulminating_magic_resist_loss", ability, q_3_level)
				end
	        end
        end
        
    end
end