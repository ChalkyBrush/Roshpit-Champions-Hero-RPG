require('/heroes/phantom_assassin/voltex_constants')

function voltex_azure_leap_onspellstart(event)
	local caster = event.caster
	local ability = event.ability
	abilityLevel = ability:GetLevel()
	--ability.location = caster:GetOrigin() + caster:GetForwardVector()*Vector(400,400)
	ability.jump_level = 0
	EmitSoundOn("Voltex.ElectricJump.Grunt", caster)
	Filters:CastSkillArguments(3, caster)
	voltex_rune_e_1(caster, ability)
	voltex_rune_e_3(caster, ability)

	ability.animation = false
	ability.extra_particle = false
    caster.e_4_level = Runes:GetTotalRuneLevel(caster, 4, "e_4", "voltex")

    ability:ApplyDataDrivenModifier(caster, caster, "modfier_voltex_jumping", {duration = 8})
    local targetPoint = event.target_points[1]
    local distance = WallPhysics:GetDistance(targetPoint*Vector(1,1,0), caster:GetAbsOrigin()*Vector(1,1,0))
    local jumpFV = ((targetPoint-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
    print(jumpFV)
    ability.jump_velocity = distance/30 + 15
    ability.jumpFV = jumpFV
    ability.distance = distance
    ability.targetPoint = targetPoint
    ability.lifting = true
    Timers:CreateTimer(0.3, function()
    	ability.lifting = false
    end)
    local zDiff = targetPoint.z - caster:GetAbsOrigin().z
    local animation_speed = math.min(800/(distance+zDiff), 2.5)
    animation_speed = math.max(animation_speed, 0.5)
    StartAnimation(caster, {duration=1.5, activity=ACT_DOTA_SPAWN, rate=animation_speed})
    CustomAbilities:QuickAttachParticle("particles/econ/items/zeus/lightning_weapon_fx/zuus_lb_cfx_il.vpcf", caster, 2)
    CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_stormspirit/stormspirit_static_remnant.vpcf", caster, 0.03)
end

function voltex_azure_leap_jumping_think(event)
	local caster = event.caster
	local ability = event.ability
	local forwardSpeed  = ability.distance/60 + 15
	local blockSearch = caster:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,GetGroundHeight(caster:GetAbsOrigin(), caster))
    local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch+ability.jumpFV*35), caster)
	if blockUnit then
		forwardSpeed = 0
	end
	caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,ability.jump_velocity)+ability.jumpFV*forwardSpeed)
	ability.jump_velocity = ability.jump_velocity - 3.3
	print(ability.jumpFV)
	if caster:GetAbsOrigin().z < GetGroundHeight(caster:GetAbsOrigin(), caster) + 10 and not ability.lifting then
		caster:RemoveModifierByName("modfier_voltex_jumping")
	elseif caster:GetAbsOrigin().z < GetGroundHeight(caster:GetAbsOrigin(), caster) + 200 and not ability.animation and not ability.lifting then
		ability.animation = true
		StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_1, rate=1.5, translate="assassin"})
	end
end

function voltex_azure_leap_landing(keys)
	local caster = keys.caster
	local ability = keys.ability
	local location = caster:GetAbsOrigin()
	voltex_rune_e_2(caster, ability)
	WallPhysics:ClearSpaceForUnit(caster, location)
	voltex_rune_e_1(caster, ability)
	CustomAbilities:QuickAttachParticle("particles/econ/items/zeus/lightning_weapon_fx/zuus_lb_cfx_il.vpcf", caster, 2)
	local pfx = CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_stormspirit/stormspirit_static_remnant.vpcf", caster, 0.03)
end

function voltex_azure_leap_actontargets(event)
    local target = event.target
    local caster = event.caster
    local damage = event.land_damage
    local stun_duration = event.stun_duration

    Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 3, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
    Filters:ApplyStun(caster, stun_duration, target)
end

function voltex_rune_e_1(hero, ability)
	local caster = hero
	local runeUnit = caster.runeUnit
	local ability = runeUnit:FindAbilityByName("voltex_rune_e_1")
	local abilityLevel = ability:GetLevel()
	local bonusLevel = Runes:GetTotalBonus(runeUnit, "e_1")
	local totalLevel = abilityLevel + bonusLevel
	local player = caster:GetPlayerOwner()
	if totalLevel > 0 then
		ConjureImage(caster, player, ability)
	end
end

function ConjureImage(caster, player, ability)
	local unit_name = caster:GetUnitName()
	local origin = caster:GetAbsOrigin() + RandomVector(100)
	local e_1_level = caster:GetRuneValue("e", 1)
	local duration = e_1_level * VOLTEX_E1_DUR + VOLTEX_E1_BASE_DUR
	local incomingDamage = VOLTEX_E1_BASE_INCOMMING_DMG_MULT
	if not ability.illusions_table then
		ability.illusions_table = {}
	else
		local new_table = {}
		for i = 1, #ability.illusions_table, 1 do
			if IsValidEntity(ability.illusions_table[i]) and ability.illusions_table[i]:IsAlive() then
				table.insert(new_table, ability.illusions_table[i])
			elseif IsValidEntity(ability.illusions_table[i]) then
				if not ability.illusions_table[i]:IsAlive() then
					UTIL_Remove(ability.illusions_table[i])
				end
			end
		end
		ability.illusions_table = new_table
	end
	if #ability.illusions_table >= 6 then
		ability.illusions_table[1]:SetHealth(10)
		ability.illusions_table[1]:ForceKill(true)
	end
	duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
	local illusion = CreateUnitByName("voltex_rune_e_1_illusion", origin, true, caster, nil, caster:GetTeamNumber())

	table.insert(ability.illusions_table, illusion)
	illusion:SetOwner(caster)
	illusion.owner = caster:GetPlayerOwnerID()
	illusion.hero = caster
	caster.illusion = illusion
	illusion:SetControllableByPlayer(illusion.owner, true)
	EmitSoundOn("Hero_Disruptor.ThunderStrike.Target", illusion)

	if not illusion:HasAbility("voltex_overcharge") then
		illusion:AddAbility("voltex_overcharge")
	end
	local overCharge = illusion:FindAbilityByName("voltex_overcharge")

	-- Set the unit as an illusion
	-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle 
	illusion:AddNewModifier(caster, ability, "modifier_illusion", { duration = duration, outgoing_damage = 1, incoming_damage = incomingDamage })

	-- Without MakeIllusion the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.
	illusion:MakeIllusion()
	overCharge:SetLevel(caster:GetAbilityByIndex(0):GetLevel())
	overCharge:ApplyDataDrivenModifier(illusion, illusion, "modifier_gods_strength_datadriven" , {duration = duration})


	local newHealth = caster:GetMaxHealth()*5
	illusion:SetMaxHealth(newHealth)
	illusion:SetBaseMaxHealth(newHealth)
	illusion:SetHealth(newHealth)
	illusion:Heal(newHealth, illusion)
	local newArmor = caster:GetPhysicalArmorValue(true)*5
	illusion:SetPhysicalArmorBaseValue(newArmor)
	local newDamage = OverflowProtectedGetAverageTrueAttackDamage(caster)*5
	Filters:SetAttackDamage(illusion, newDamage)

	if caster:HasModifier("modifier_voltex_rune_r_3_avatar") then
		local runeAbility = caster.runeUnit3:FindAbilityByName("voltex_rune_r_3")
		runeAbility:ApplyDataDrivenModifier(caster.runeUnit3, illusion, "modifier_voltex_rune_r_3_avatar", {duration = duration})
		local c_d_level = Runes:GetTotalRuneLevel(caster, 3, "r_3", "voltex")
		runeAbility:ApplyDataDrivenModifier(caster.runeUnit3, illusion, "modifier_voltex_rune_r_3_buff", {duration = duration})
		illusion:SetModifierStackCount( "modifier_voltex_rune_r_3_buff", runeAbility, c_d_level )
	end
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_electric_vortex.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, illusion:GetAbsOrigin()+Vector(0,0,200))
	ParticleManager:SetParticleControl(pfx, 1, illusion:GetAbsOrigin()-Vector(0,0,0))
	Timers:CreateTimer(0.8, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	StartAnimation(illusion, {duration=1.0, activity=ACT_DOTA_SPAWN, rate=1.2})
end


function voltex_rune_e_2(caster, ability)
	local e_2_level = caster:GetRuneValue("e", 2)
	if e_2_level > 0 then
		local duration = VOLTEX_E2_BASE_DUR + VOLTEX_E2_DUR * e_2_level
		duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_voltex_rune_e_2", {duration = duration})
	end
end

function voltex_rune_e_2_think(event)
	local caster = event.target
	local e_2_level = caster:GetRuneValue("e", 2)
	local ability = event.ability
	local damage = (e_2_level * VOLTEX_E2_DMG + VOLTEX_E2_BASE_DMG) / 2

	local glyphed = false
	if not ability.particles then
		ability.particles = 0
	end
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 220, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			ability.particles = ability.particles + 1
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 3, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE) 
			if ability.particles < 12 then
				local particleName = "particles/units/heroes/hero_lina/lina_spell_laguna_blade_impact_sparks.vpcf"
				local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
				ParticleManager:SetParticleControl( particle1, 0, enemy:GetAbsOrigin() )
				ParticleManager:SetParticleControl( particle1, 1, enemy:GetAbsOrigin() )
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_voltex_rune_e_2_slow_glyphed", {duration = 4})
				Timers:CreateTimer(0.6, function()
					ParticleManager:DestroyParticle( particle1, false )
					ability.particles = ability.particles - 1
				end)
			end
			EmitSoundOn("Item.Maelstrom.Chain_Lightning.Jump", enemy)
		end
	end 
end

function voltex_rune_e_3(hero, ability)
	local caster = hero
	local e_3_level = caster:GetRuneValue("e", 3)
	if e_3_level > 0 then
		if caster:IsAlive() and not caster.chargeActive then
			CustomAbilities:AddAndOrSwapSkill(caster, "voltex_azure_leap", "voltex_rune_e_3_heavens_charge", 2)
			caster.chargeActive = true
		end
	end
end

function voltex_rune_e_3_heavens_charge_onspellstart(event)
	local caster = event.caster
	local ability = event.ability
	local position = event.target_points[1]
	local e_3_level = caster:GetRuneValue("e", 3)
	local maxDistance = e_3_level * VOLTEX_E3_RANGE + VOLTEX_E3_BASE_RANGE
	local startPosition = caster:GetAbsOrigin()
	local castedDistance = WallPhysics:GetDistance(startPosition,position)
	if castedDistance > maxDistance then
		local displacementVector = (position - startPosition):Normalized()
		position = startPosition + displacementVector * maxDistance
	end
	local newPosition = WallPhysics:WallSearch(startPosition, position, caster)
	caster.e_4_level = Runes:GetTotalRuneLevel(caster, 4, "e_4", "voltex")
	caster:SetOrigin(newPosition + Vector(0,0,900))
	caster:RemoveModifierByName("modfier_voltex_jumping")
	local particleName = "particles/units/heroes/hero_zuus/zeus_loadout.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	Timers:CreateTimer(2.5, function() 
		ParticleManager:DestroyParticle( pfx, false )
	end) 	
	Timers:CreateTimer(0.05, function()
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_voltex_rune_e_3_heavens_charge_falling", {duration = 3})
		ProjectileManager:ProjectileDodge(caster)
	end)
	EmitSoundOn("phantom_assassin_phass_pain_13", caster)
	particleName = "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_attack_crit.vpcf"
	local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( particle1, 0, startPosition )
	ParticleManager:SetParticleControl( particle1, 1, startPosition )
	ParticleManager:SetParticleControl( particle1, 3, startPosition )
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle( particle1, false )
	end)
	if caster:HasModifier("modifier_voltex_glyph_3_1") then
		local overcharge = caster:GetAbilityByIndex(0)
		overcharge:EndCooldown()
	end
end

function voltex_rune_e_3_heavens_charge_falling_think(event)
	local caster = event.caster
	local ability = event.ability
	local currentPosition = caster:GetAbsOrigin()
	if (currentPosition.z - GetGroundPosition(currentPosition, caster).z) < 20 then
		caster:RemoveModifierByName("modifier_voltex_rune_e_3_heavens_charge_falling")
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_stormspirit/stormspirit_static_remnant.vpcf", caster:GetAbsOrigin(), 0.03)
		EmitSoundOnLocationWithCaster(currentPosition, "Hero_Zuus.GodsWrath.Target", caster)
		particleName = "particles/units/heroes/hero_disruptor/disruptor_thunder_strike_bolt.vpcf"
		local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControlEnt(particle1, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin()+Vector(0,0,40), true)
		ParticleManager:SetParticleControl( particle1, 1, Vector(400, 0, 0) )
		Timers:CreateTimer(2, 
		function()
			ParticleManager:DestroyParticle( particle1, false )
		end)
		Timers:CreateTimer(0.03, function()
			StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_CAST_ABILITY_3, rate=1.8})
		end)
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, VOLTEX_E3_BASE_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		local e_3_level = caster:GetRuneValue("e", 3)
		local damage = e_3_level * VOLTEX_E3_DMG
		local stun_duration = VOLTEX_E3_BASE_STUN_DUR
		if #enemies > 0 then	
			for _,enemy in pairs(enemies) do
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 3, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
				Filters:ApplyStun(caster, stun_duration, enemy)
			end				
		end 
		if caster:IsAlive() and caster.chargeActive then
			CustomAbilities:AddAndOrSwapSkill(caster, "voltex_rune_e_3_heavens_charge", "voltex_azure_leap", 2)
			caster.chargeActive = false
		end
	else
		caster:SetAbsOrigin(currentPosition + Vector(0,0,-150))
	end
end