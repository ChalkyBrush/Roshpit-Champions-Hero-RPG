require('heroes/omniknight/paladin_constants')

function cast_wings(event)
	local caster = event.caster
	local ability = event.ability
	Filters:CastSkillArguments(1, caster)
	local duration = event.duration
	local b_a_level = Runes:GetTotalRuneLevel(caster, 2, "b_a", "paladin")
	ability.b_a_level = b_a_level
	caster.d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "paladin")
	if b_a_level > 0 then
		duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_paladin_b_a_radiance", {duration = duration})
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_holy_wings", {duration = duration})
	if caster:HasModifier("modifier_paladin_immortal_weapon_1") then
		local coneAbility = caster:FindAbilityByName("holy_cone")
		if caster:HasAbility("paladin_penance") then
			coneAbility = caster:FindAbilityByName("paladin_penance")
		end
		local immortalDuration = Filters:GetAdjustedBuffDuration(caster, 8, false)
		coneAbility:ApplyDataDrivenModifier(caster, caster, "modifier_paladin_rune_c_a_shield", {duration = immortalDuration})
		caster:SetModifierStackCount("modifier_paladin_rune_c_a_shield", caster, 4)
	end
end

function radiance_think(event)
	local caster = event.caster
	local ability = event.ability
	local tickDamage = OverflowProtectedGetAverageTrueAttackDamage(caster)*0.8*ability.b_a_level/2
	local radius = 900
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			CustomAbilities:QuickAttachParticle("particles/items2_fx/radiance.vpcf", enemy, 1)
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, tickDamage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
		end
	end 
end

function WingThink(event)
	local caster = event.caster
	local ability = event.ability
	local radius = 100
	local origin = caster:GetOrigin()

	local modifierKnockback =
	{
		center_x = origin.x,
		center_y = origin.y,
		center_z = origin.z,
		duration = 1.6,
		knockback_duration = 1.6,
		knockback_distance = 0,
		knockback_height = 2000,
	}

	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), origin, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			EmitSoundOn("Hero_Chen.HolyPersuasionEnemy", enemy)
			enemy:AddNewModifier( enemy, nil, "modifier_knockback", modifierKnockback )
		end
	end 
end

function rune_unit_2_think(event)
	local caster = event.caster
	local ability = event.ability
	local hero = caster.hero
	local totalLevel = Runes:GetTotalRuneLevel(hero, 2, "b_a", "paladin")
	ability.b_a_level = totalLevel
	if totalLevel > 0 then
		local stackCount = (hero:GetGold()/100)*totalLevel
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_paladin_rune_b_a_effect", {})
		hero:SetModifierStackCount( "modifier_paladin_rune_b_a_effect", ability, stackCount )
	end
end

function set_b_a_level(event)
	local ability = event.ability
	local caster = event.caster
	local runeUnit = caster.runeUnit2
	local runeAbility = runeUnit:FindAbilityByName("paladin_rune_b_a")
	local abilityLevel = runeAbility:GetLevel()
	local bonusLevel = Runes:GetTotalBonus(runeUnit, "b_a")
	local totalLevel = abilityLevel + bonusLevel
	ability.b_a_level = totalLevel
end


	
function wing_attack( keys )
    local caster = keys.caster
    local ability = keys.ability
    local abilityLevel = ability:GetLevel()
    local targetUnit = keys.target
    
    local origin = targetUnit:GetAbsOrigin()
    local radius = keys.radius
    local damage = keys.damage

    local q_1_level = caster:GetRuneValue("q", 1)
    damage = damage + OverflowProtectedGetAverageTrueAttackDamage(caster) * PALADIN_Q1_ADD_DMG_PER_ATT * q_1_level

    local knockback_duration = 1.6
    local heal_percent = keys.heal_percent/100


    if not ability.zapParticleCount then
    	ability.zapParticleCount = 0
    end
    if ability.zapParticleCount < 15 then
    	ability.zapParticleCount = ability.zapParticleCount + 1
		local dagon_particle = ParticleManager:CreateParticle("particles/econ/events/ti5/dagon_lvl2_ti5.vpcf",  PATTACH_POINT_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(dagon_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(dagon_particle, 1, targetUnit, PATTACH_POINT_FOLLOW, "attach_hitloc", targetUnit:GetAbsOrigin(), false)
		local particle_effect_intensity = 300 + (60 * ability:GetLevel())  --Control Point 2 in Dagon's particle effect takes a number between 400 and 800, depending on its level.
		ParticleManager:SetParticleControl(dagon_particle, 2, Vector(particle_effect_intensity))
		Timers:CreateTimer(2.0, function()
			ParticleManager:DestroyParticle(dagon_particle, false)
			ParticleManager:ReleaseParticleIndex(dagon_particle)
			ability.zapParticleCount = ability.zapParticleCount - 1
		end)
	end
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), origin, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false )

	amount = math.floor(caster:GetMaxHealth()*heal_percent)
	Filters:ApplyHeal(caster, caster, amount, true)

	
	if #enemies > 0 then
		caster.holyCone = caster:FindAbilityByName("holy_cone")
		if caster:HasModifier("modifier_paladin_glyph_2_1") and caster.holyCone then
			caster.holyCone.a_b_level = a_b_level(caster,caster.holyCone)
			if caster.holyCone.a_b_level > 0 then
				applyFire = true
			else
				applyFire = false
			end
		else 
			applyFire = false
		end
		if not ability.goldParticleCount then
			ability.goldParticleCount = 0
		end
		for _,enemy in pairs(enemies) do
			if ability.goldParticleCount < 20 then
				ability.goldParticleCount = ability.goldParticleCount + 1
				CustomAbilities:QuickAttachParticle("particles/econ/items/effigies/status_fx_effigies/base_statue_destruction_gold_lvl2_a.vpcf", enemy, 1)
				Timers:CreateTimer(1.2, function()
					ability.goldParticleCount = ability.goldParticleCount - 1
				end)
			end
			if not targetUnit:HasModifier("modifier_holy_struck") then
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_heroic_fury_slow", {duration = 4})
				enemy:AddNewModifier( enemy, nil, "modifier_knockback", modifierKnockback )
			end
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_HOLY, RPC_ELEMENT_NORMAL)
			if applyFire then
				apply_holy_fire(caster, enemy, caster.holyCone)
			end
		end
	end 

 --    particleName = "particles/units/heroes/hero_omniknight/omniknight_loadout.vpcf"
 --    particleName2 = "particles/units/heroes/hero_omniknight/omniknight_purification.vpcf"
 --    local particleVector = origin
 --    local pfx = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, caster )
 --    local pfx2 = ParticleManager:CreateParticle( particleName2, PATTACH_ABSORIGIN_FOLLOW, caster )
 --    ParticleManager:SetParticleControlEnt( pfx, 0, targetUnit, PATTACH_POINT_FOLLOW, "attach_hitloc", particleVector, true )
 --    ParticleManager:SetParticleControlEnt( pfx, 0, targetUnit, PATTACH_POINT_FOLLOW, "attach_hitloc", particleVector, true )

	-- Timers:CreateTimer(5, function() 
	-- 	ParticleManager:DestroyParticle( pfx, false )
	-- 	ParticleManager:DestroyParticle( pfx2, false )
	-- end)	
end

function rune_b_a(target, abilityLevel, caster)
		-- local item = RPCItems:CreateItem("item_bag_of_gold", nil, nil)
		-- local location = target:GetAbsOrigin()
  --   	local drop = CreateItemOnPositionSync( location, item )
  --   	local position = location + RandomVector(RandomInt(200, 1100))
  --   	item.rarity = "common"
		-- table.insert(GLOBAL_ITEM_TABLE, item)
		-- item.expiryTime = Time() + 30
  --   	item.gold_amount = RandomInt(10+abilityLevel*10, (10+abilityLevel*10)+Events.WaveNumber*5)
  --   	item:LaunchLoot(true, RandomInt(100,400), 0.75, position)
end

function paladin_rune_c_a_hit(event)
	local ability = event.ability
	local unit = event.unit
	local damageTaken = event.Damage
	if not ability.AbsorbtionLeft then
		ability.AbsorbtionLeft = 800
	end
	
	if damageTaken > ability.AbsorbtionLeft then
		unit:Heal(ability.AbsorbtionLeft, unit)
	else
		unit:Heal(damageTaken, unit)
	end
	ability.AbsorbtionLeft = ability.AbsorbtionLeft - damageTaken
	if ability.AbsorbtionLeft < 0 then
		unit:RemoveModifierByName("modifier_paladin_rune_c_a")
		EmitSoundOn("Hero_Huskar.Life_Break.Impact", event.attacker)
	end
	local particleName = "particles/units/heroes/hero_medusa/divine_aegis_impact.vpcf"
	local particle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle, 0, unit:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 1, Vector(damageTaken,0,0))
end

function rune_c_a_shield_break(event)
	local target = event.target
	local ability = event.ability
	local cooldown = 12
	if target:HasModifier("modifier_paladin_glyph_5_1") then
		cooldown = 8
	end
	ability:ApplyDataDrivenModifier(target, target, "modifier_paladin_rune_c_a_cooling_down", {duration = 12})
end

function rune_c_a_reapply_shield(event)
  local target = event.target
  local ability = event.ability
  local runeUnit = target.runeUnit3
  if runeUnit then

	  local totalLevel =  Runes:GetTotalRuneLevel(target, 3, "c_a", "paladin")
	  ability.AbsorbtionLeft = 800 + totalLevel*500	

	  local d_a_level = Runes:GetTotalRuneLevel(target, 4, "d_a", "paladin")
	  ability.AbsorbtionLeft = ability.AbsorbtionLeft + 0.0007*target:GetStrength()/10*d_a_level*ability.AbsorbtionLeft

	  ability:ApplyDataDrivenModifier(runeUnit, target, "modifier_paladin_rune_c_a", {})
  end
end

function paladin_2_1_destroy(event)
	local target = event.target
	local wings = target:GetAbilityByIndex(0)
	print(wings:GetToggleState())
	if wings:GetToggleState() == true then
		wings:ToggleAbility()
	end
end