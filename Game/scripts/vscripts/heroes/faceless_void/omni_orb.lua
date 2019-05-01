function omni_orb_charge_procced(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local mace_hit_data = omni_mace_basic_element_data(caster.active_element)
	local orb_ability = caster:FindAbilityByName("omniro_omni_orb")
	if caster.active_element == RPC_ELEMENT_NORMAL then
		local damage = orb_ability:GetSpecialValueFor("normal_orb_a")*OverflowProtectedGetAverageTrueAttackDamage(caster)*caster.omniro_data[RPC_ELEMENT_NORMAL]["level"]
		local pfx = ParticleManager:CreateParticle("particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_crit_b.vpcf", PATTACH_ABSORIGIN, caster)
		-- local pull_direction = ((target:GetAbsOrigin() - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()+caster:GetForwardVector()*100)
		ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin())
	    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin()+caster:GetForwardVector()*120, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
	    if #enemies > 0 then    
	        for _,enemy in pairs(enemies) do
	            Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, mace_hit_data["damage_type"], 2, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
	        end
	    end		
	    Timers:CreateTimer(0.5, function()
	    	ParticleManager:DestroyParticle(pfx, false)
	    end)
	    EmitSoundOn("Omniro.Orb.Normal", target)
	elseif caster.active_element == RPC_ELEMENT_FIRE then
		local damage = (orb_ability:GetSpecialValueFor("fire_orb_a")/100)*OverflowProtectedGetAverageTrueAttackDamage(caster)*caster.omniro_data[RPC_ELEMENT_FIRE]["level"]


		local particleName = "particles/units/heroes/hero_elder_titan/ring_of_fire.vpcf"
	  	local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	  	local origin = target:GetAbsOrigin()
	  	ParticleManager:SetParticleControl( particle1, 0, origin+Vector(0,0,50) )
	  	for i = 1, 9, 1 do
	  		ParticleManager:SetParticleControl( particle1, i, Vector(440,440,440) )
	  	end

	    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), origin, nil, OMNIRO_ORB_FIRE_AOE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
	    if #enemies > 0 then    
	        for _,enemy in pairs(enemies) do
	            Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, mace_hit_data["damage_type"], 2, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
	        end
	    end	
		Timers:CreateTimer(1, function() 
		  ParticleManager:DestroyParticle( particle1, false )
		end)  

		EmitSoundOn("Omniro.Orb.Fire", target)
	elseif caster.active_element == RPC_ELEMENT_EARTH then
		local damage = (orb_ability:GetSpecialValueFor("earth_orb_a"))*caster:GetStrength()*caster.omniro_data[RPC_ELEMENT_EARTH]["level"]
		local radius = OMNIRO_ORB_EARTH_AOE
		local position = target:GetAbsOrigin()
		local stun_duration = (orb_ability:GetSpecialValueFor("earth_orb_b"))*caster.omniro_data[RPC_ELEMENT_EARTH]["level"]
		local splitEarthParticle = "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf"
		local pfx = ParticleManager:CreateParticle( splitEarthParticle, PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( pfx, 0, position )
		ParticleManager:SetParticleControl( pfx, 1, Vector(radius, radius, radius) )
		EmitSoundOn("Omniro.Orb.Earth", target)
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius+5, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, mace_hit_data["damage_type"], 2, RPC_ELEMENT_EARTH, RPC_ELEMENT_NONE)
				Filters:ApplyStun(caster, stun_duration, enemy)	
			end
		end 
		Timers:CreateTimer(3.5, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	elseif caster.active_element == RPC_ELEMENT_LIGHTNING then
		local damage = (orb_ability:GetSpecialValueFor("lightning_orb_a"))*caster:GetAgility()*caster.omniro_data[RPC_ELEMENT_LIGHTNING]["level"]

		local chain = {}
		chain.index_hit = 0
		chain.enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, OMNIRO_ORB_LIGHTNING_SEARCH_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false )
		local targets_to_hit = OMNIRO_ORB_LIGHTNING_BASE_BOUNCES + caster.omniro_data[RPC_ELEMENT_LIGHTNING]["max_charges"]
		for i = 1, targets_to_hit, 1 do
			Timers:CreateTimer((i-1)*0.15, function()
				local enemy = chain.enemies[i]
				if IsValidEntity(enemy) and enemy:IsAlive() then
					EmitSoundOn("Omniro.Orb.Lightning", enemy)
					Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, mace_hit_data["damage_type"], 2, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
					local particleName = "particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf"
					local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_CUSTOMORIGIN, nil)
					local attach_unit_1 = caster
					if i > 1 then
						attach_unit_1 = chain.enemies[i-1]
					end
					ParticleManager:SetParticleControl(pfx, 0, attach_unit_1:GetAbsOrigin()+Vector(0,0,attach_unit_1:GetBoundingMaxs().z+80))
					ParticleManager:SetParticleControl(pfx, 1, enemy:GetAbsOrigin()+Vector(0,0,enemy:GetBoundingMaxs().z+100))
					Timers:CreateTimer(0.3, function()
						ParticleManager:DestroyParticle(pfx, false)
					end)
				end
			end)
		end
	elseif caster.active_element == RPC_ELEMENT_POISON then
		-- local damage = (orb_ability:GetSpecialValueFor("poison_orb_a")/100)*OverflowProtectedGetAverageTrueAttackDamage(caster)*caster.omniro_data[RPC_ELEMENT_POISON]["level"]
		local thinkerDuration = OMNIRO_ORB_POISON_POOL_DURATION
		local particleName = "particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf"
		CustomAbilities:QuickAttachThinker(orb_ability, caster, target:GetAbsOrigin(), "modifier_omniro_poison_orb_pool", {duration = thinkerDuration})
		StartSoundEvent("Omniro.Orb.Poison", target)
		Timers:CreateTimer(4, function()
			if target and IsValidEntity(target) then
				StopSoundEvent("Omniro.Orb.Poison", target)
			end
		end)
		local pfx = CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf", target:GetAbsOrigin(), thinkerDuration)
		ParticleManager:SetParticleControl(pfx, 1, Vector(OMNIRO_ORB_POISON_POOL_RADIUS, OMNIRO_ORB_POISON_POOL_RADIUS, OMNIRO_ORB_POISON_POOL_RADIUS))
	elseif caster.active_element == RPC_ELEMENT_TIME then
		local debuff_duration = (orb_ability:GetSpecialValueFor("time_orb_b"))*caster.omniro_data[RPC_ELEMENT_TIME]["level"]
	    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, OMNIRO_ORB_TIME_AOE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
	    if #enemies > 0 then    
	        for _,enemy in pairs(enemies) do
	        	CustomAbilities:QuickAttachParticle("particles/roshpit/omniro/timelock.vpcf", enemy, 3)
	            orb_ability:ApplyDataDrivenModifier(caster, enemy, "modifier_omniro_time_freeze", {duration = debuff_duration})
	        end
	    end	
		EmitSoundOn("Omniro.Orb.Time.Start", target)
	elseif caster.active_element == RPC_ELEMENT_HOLY then
		local damage = (orb_ability:GetSpecialValueFor("holy_orb_a"))*caster:GetIntellect()*caster.omniro_data[RPC_ELEMENT_HOLY]["level"] + (orb_ability:GetSpecialValueFor("holy_orb_b"))*caster:GetPhysicalArmorValue()*caster.omniro_data[RPC_ELEMENT_HOLY]["level"]
  		EmitSoundOn("Omniro.Orb.Holy", caster)
  		local radius = OMNIRO_ORB_HOLY_AOE
		local particleName =  "particles/units/heroes/hero_elder_titan/paladin_holy_nova.vpcf"
		local position = caster:GetAbsOrigin()
		local particleVector = position

		local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( pfx, 0, particleVector )
		Timers:CreateTimer(1, function() 
		  ParticleManager:DestroyParticle( pfx, false )
		end) 
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
			end
		end
		local allies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		local heal = damage*(OMNIRO_ORB_HOLY_HEAL_PCT/100)
		if #allies > 0 then
			for _,ally in pairs(allies) do
				Filters:ApplyHeal(caster, ally, heal, false)
			end
		end  		
	end
	Filters:CastSkillArguments(2, caster)
end

function omniro_time_effect_end(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local mace_hit_data = omni_mace_basic_element_data(RPC_ELEMENT_TIME)
	local damage = (ability:GetSpecialValueFor("time_orb_a")/100)*OverflowProtectedGetAverageTrueAttackDamage(caster)*caster.omniro_data[RPC_ELEMENT_TIME]["level"]
	CustomAbilities:QuickAttachParticle("particles/roshpit/omniro/timelock.vpcf", target, 3)
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, mace_hit_data["damage_type"], 2, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)
	EmitSoundOn("Omniro.Orb.Time.Pop", target)
end

function omniro_poison_pool_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local mace_hit_data = omni_mace_basic_element_data(RPC_ELEMENT_POISON)
	local damage = (ability:GetSpecialValueFor("poison_orb_a")/100)*OverflowProtectedGetAverageTrueAttackDamage(caster)*caster.omniro_data[RPC_ELEMENT_POISON]["level"]
	Filters:ApplyDotDamage(caster, ability, target, damage, mace_hit_data["damage_type"], 2, RPC_ELEMENT_POISON, RPC_ELEMENT_NONE)
end

-- RPC_ELEMENT_NONE = -1
-- RPC_ELEMENT_NORMAL = 1
-- RPC_ELEMENT_FIRE = 2
-- RPC_ELEMENT_EARTH = 3
-- RPC_ELEMENT_LIGHTNING = 4
-- RPC_ELEMENT_POISON = 5
-- RPC_ELEMENT_TIME = 6
-- RPC_ELEMENT_HOLY = 7
-- RPC_ELEMENT_COSMOS = 8
-- RPC_ELEMENT_ICE = 9
-- RPC_ELEMENT_ARCANE = 10
-- RPC_ELEMENT_SHADOW = 11
-- RPC_ELEMENT_WIND = 12
-- RPC_ELEMENT_GHOST = 13
-- RPC_ELEMENT_WATER = 14
-- RPC_ELEMENT_DEMON = 15
-- RPC_ELEMENT_NATURE = 16
-- RPC_ELEMENT_UNDEAD = 17
-- RPC_ELEMENT_DRAGON = 18