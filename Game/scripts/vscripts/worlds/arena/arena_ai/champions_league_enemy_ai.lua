require("worlds/arena/arena_ai/basic_arena_ai")

function challenger_18_take_damage(event)
	local unit = event.unit
	if unit.noCounter then
		return
	end
	unit.noCounter = true
	local attacker = event.attacker
	local damage = event.attack_damage
	local particleName = "particles/units/heroes/hero_pugna/pugna_ward_attack_light.vpcf"
	local purePercent = 0.01
	if damage > unit:GetMaxHealth()*0.3 then
		particleName = "particles/units/heroes/hero_pugna/pugna_ward_attack_heavy.vpcf"
		purePercent = 0.1
	elseif damage > unit:GetMaxHealth()*0.12 then
		particleName = "particles/units/heroes/hero_pugna/pugna_ward_attack_medium.vpcf"
		purePercent = 0.05
	end
	local attachPointA = unit:GetAbsOrigin()
	local attachPointB = attacker:GetAbsOrigin()
	local pureDamage = attacker:GetMaxHealth()*purePercent
	ApplyDamage({ victim = attacker, attacker = unit, damage = pureDamage, damage_type = DAMAGE_TYPE_PURE })
	local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster) 
	ParticleManager:SetParticleControl(lightningBolt,0,Vector(attachPointA.x,attachPointA.y,attachPointA.z+150))   
	ParticleManager:SetParticleControl(lightningBolt,1,Vector(attachPointB.x,attachPointB.y,attachPointB.z+100))
	EmitSoundOn("Arena.ChampionsLeague.OgreZap", attacker)


	local lightningBolt2 = ParticleManager:CreateParticle("particles/econ/items/pugna/pugna_ward_ti5/pugna_ward_lightning.vpcf", PATTACH_WORLDORIGIN, Events.GameMaster) 
	ParticleManager:SetParticleControl(lightningBolt,0,Vector(attachPointA.x,attachPointA.y,attachPointA.z+150))   
	ParticleManager:SetParticleControl(lightningBolt,1,Vector(attachPointB.x,attachPointB.y,attachPointB.z+100))
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(lightningBolt, false)
		ParticleManager:DestroyParticle(lightningBolt2, false)
	end)
	
	Timers:CreateTimer(0.2, function()
		unit.noCounter = false
	end)
end

function challenger_18_attack_land(event)
	pullCrowd(true, 2)
end

function challenger_17_summon_death(event)
	local caster = event.caster
	local summoner = caster.summoner
	summoner.summonsUp = summoner.summonsUp - 1
	local pfx = ParticleManager:CreateParticle( "particles/generic_gameplay/illusion_killed.vpcf", PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, caster:GetAbsOrigin()+Vector(0,0,30) )
	Timers:CreateTimer(2.5, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	end) 
end

function drill_spike_damage_dealt(event)
	local caster = event.caster
	local ability = event.ability
	local damage = event.attack_damage
	local damageTaken = damage*20
	if Arena.BetweenBattles then
		return false
	end
	if not IsValidEntity(caster) then
		return false
	end
	local stacks = caster:GetModifierStackCount("modifier_drill_spike_self", caster)
	damageTaken = damageTaken*(1+(1*stacks)) + caster:GetMaxHealth()*0.01
	ApplyDamage({ victim = caster, attacker = Arena.ArenaMaster, damage = damageTaken, damage_type = DAMAGE_TYPE_PURE })
	if damageTaken > caster:GetMaxHealth()*0.5 then
		local luck = RandomInt(1,3)
		if luck == 1 then
			pullCrowd(false, 5)
		else
			pullCrowd(false, 4)
		end
	elseif damageTaken > caster:GetMaxHealth()*0.4 then
		local luck = RandomInt(1,4)
		if luck == 1 then
			pullCrowd(false, 4)
		else
			pullCrowd(false, 3)
		end
	elseif damageTaken > caster:GetMaxHealth()*0.3 then
		local luck = RandomInt(1,4)
		if luck == 1 then
			pullCrowd(false, 3)
		else
			pullCrowd(false, 2)
		end
	elseif damageTaken > caster:GetMaxHealth()*0.2 then
		local luck = RandomInt(1,5)
		if luck == 1 then
			pullCrowd(false, 3)
		else
			pullCrowd(false, 2)
		end
	elseif damageTaken > caster:GetMaxHealth()*0.1 then
		local luck = RandomInt(1,4)
		if luck == 1 then
			pullCrowd(false, 2)
		else
			pullCrowd(false, 1)
		end
	elseif damageTaken > caster:GetMaxHealth()*0.05 then
		local luck = RandomInt(1,4)
		if luck < 3 then
			pullCrowd(false, 1)
		end
	elseif damageTaken > caster:GetMaxHealth()*0.02 then
		local luck = RandomInt(1,4)
		if luck == 1 then
			pullCrowd(false, 1)
		end
	else
		local luck = RandomInt(1,6)
		if luck == 1 then
			pullCrowd(false, 1)
		end
	end
end

function drill_spike_hit(event)
	local ability = event.ability
	local caster = event.caster
	if not IsValidEntity(caster) then
		return false
	end
	local target = event.target
	local damage = target:GetMaxHealth()*0.08
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE })
	ability:ApplyDataDrivenModifier(caster, target, "modifier_drill_spike_enemy", {duration = 10})
	local currentStacks = target:GetModifierStackCount("modifier_drill_spike_enemy", caster)
	local newStacks = currentStacks + 1
	target:SetModifierStackCount("modifier_drill_spike_enemy", caster, newStacks)

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_drill_spike_self", {duration = 10})
	local currentStacks = caster:GetModifierStackCount("modifier_drill_spike_self", caster)
	local newStacks = currentStacks + 1
	caster:SetModifierStackCount("modifier_drill_spike_self", caster, newStacks)
end

function bear_summoning_think(event)
	local ability = event.ability
	local caster = event.caster
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_challenger_13_immune", {})
	local spawnPosition = caster:GetAbsOrigin()+((((caster:GetForwardVector()*-3)+RandomVector(1))/4):Normalized())*500
	if not caster.summonInterval then
		caster.summonInterval = 0
	end
	if not caster.summonTable then
		caster.summonTable = {}
	end
	if caster.summonInterval%10 == 0 then
		pullCrowd(true, RandomInt(1,2))
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin()+RandomVector(300), "Arena.Challenger13.SummonRoar", caster)
	end
	local summonName = "champion_league_challenger_13_a"
	if caster.summonInterval%3 == 1 then
		summonName = "champion_league_challenger_13_b"
	elseif caster.summonInterval%3 == 2 then
		summonName = "champion_league_challenger_13_c"
	end

	local summonBear = CreateUnitByName(summonName, spawnPosition, true, nil, nil, caster:GetTeamNumber())
	if summonName == "champion_league_challenger_13_a" then
		summonBear.targetRadius = 360
		summonBear.autoAbilityCD = 4	
	elseif summonName == "champion_league_challenger_13_c" then
		summonBear.targetRadius = 680
		summonBear.autoAbilityCD = RandomInt(7,14)			
	end
	summonBear.dominion = true
	summonBear:SetForwardVector(caster:GetForwardVector())
	summonBear.aggro = true
	Events:AdjustDeathXP(summonBear)
	Events:AdjustBossPower(summonBear, 2, 2)
	ability:ApplyDataDrivenModifier(caster, summonBear, "modifier_arena_bear_summon_entering", {duration = 3})
	ability:ApplyDataDrivenModifier(caster, summonBear, "modifier_bear_summon", {})
	summonBear:SetAbsOrigin(summonBear:GetAbsOrigin()+Vector(0,0,200))
	local casterFV = caster:GetForwardVector()
	table.insert(caster.summonTable, summonBear)
	for i = 1, 60, 1 do
		Timers:CreateTimer(0.05*i, function()
			summonBear:SetAbsOrigin(summonBear:GetAbsOrigin()+casterFV*25-Vector(0,0,3.3))
		end)
	end
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_ursa/ursa_overpower_cast.vpcf", summonBear, 1.2)
	summonBear.caster = caster
	summonBear:SetAcquisitionRange(4000)
	caster.summonInterval = caster.summonInterval+1
	Timers:CreateTimer(2, function()
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_ursa/ursa_overpower_cast.vpcf", summonBear, 1.2)
	end)
end

function bear_summon_die(event)
	local target = event.unit
	local caster = target.caster
	if not caster.summonsKilled then
		caster.summonsKilled = 0
	end
	caster.summonsKilled = caster.summonsKilled + 1
	if caster.summonsKilled >= 36 then
		caster:RemoveModifierByName("modifier_challenger_13_immune")
	end
end

function challenger_12_animate_immunity(event)
	local caster = event.caster
	StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_CAST_ABILITY_4, rate=0.9})
end

function arena_radiance_effect(event)
	local target = event.target
	local damage = target:GetHealth()*0.03
	local caster = event.caster
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE })
end

function wraith_explosion_think(event)

	local caster = event.caster
	local ability = event.ability
	if not caster.aggro then
		return
	end
	if Arena.BetweenBattles then
		return
	end
	EmitSoundOn("Hero_Spectre.HauntCast", caster)
	StartAnimation(caster, {duration=1, activity=ACT_DOTA_ATTACK_EVENT, rate=0.9, translate="wraith_spin"})
	for i = -6, 6, 1 do
		local fv = WallPhysics:rotateVector(caster:GetForwardVector(), math.pi/6*i)
		create_specter_projectile(caster:GetAbsOrigin()+Vector(0,0,120), fv, caster, ability)
	end
	-- ability:ApplyDataDrivenModifier(caster, caster, "tanari_specter_temporary_root", {duration = 0.2})
end

function create_specter_projectile(spellOrigin, forward, caster, ability)
	
	local info = 
	{
		Ability = ability,
        	EffectName = "particles/units/heroes/hero_alchemist/epoch_rune_r_1_concoction_projectile.vpcf",
        	vSpawnOrigin = spellOrigin,
        	fDistance = 1650,
        	fStartRadius = 120,
        	fEndRadius = 120,
        	Source = caster,
        	StartPosition = "attach_hitloc",
        	bHasFrontalCone = true,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 7.0,
		bDeleteOnHit = false,
		vVelocity = forward * 470,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
end

function specter_projectile_hit(event)
	local target = event.target
	local caster = event.caster
	local sound = "Hero_Pugna.NetherBlast"
    local particleName =  "particles/units/heroes/hero_pugna/pugna_netherblast.vpcf"
    local particleVector = target:GetAbsOrigin()
    local radius = 200
      local pfx = ParticleManager:CreateParticle( particleName, PATTACH_POINT, caster )
      ParticleManager:SetParticleControl( pfx, 0, target:GetAbsOrigin() )
      ParticleManager:SetParticleControl( pfx, 1, Vector(radius, radius, radius) )
        Timers:CreateTimer(0.8, function() 
          ParticleManager:DestroyParticle( pfx, false )
        end)  
        EmitSoundOn(sound, target)
	local damage = Events:GetDifficultyScaledDamage(250, 22000, 95000)
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
	PopupDamage(target, damage)
end

function summon_skeleton_ally(event)
	local caster = event.caster
	if not caster.summonTable then
		caster.summonTable = {}
	end

	StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_3, rate=0.7})
	local unitTable = {"castle_skeleton_mage", "castle_skeleton_archer", "castle_skeleton_warrior"}
	if caster.summonPhase < 3 then
		unitTable = {"castle_skeleton_mage", "castle_skeleton_archer"}
	end
	for j = 1, #unitTable, 1 do
		position = caster:GetAbsOrigin()+RandomVector(400)
		local skeleton = Dungeons:SpawnDungeonUnit(unitTable[j], position, 1, 0, 0, nil, nil, true, nil)
		createSummonParticle(position, caster, skeleton)
		EmitSoundOn("Hero_Pugna.NetherWard.Attack.Wight", skeleton)	
		table.insert(caster.summonTable, skeleton)
	end	
end

function createSummonParticle(position, caster, target)
	local particleName = "particles/units/heroes/hero_pugna/pugna_ward_attack.vpcf"
    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(pfx,0,caster:GetAbsOrigin()+Vector(0,0,200))   
    ParticleManager:SetParticleControl(pfx,1,target:GetAbsOrigin()+Vector(0,0,822))
	Timers:CreateTimer(3.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	particleName = "particles/econ/items/pugna/pugna_ward_ti5/pugna_ward_lightning.vpcf"
	local pfx2 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(pfx2,0,caster:GetAbsOrigin()+Vector(0,0,200))   
    ParticleManager:SetParticleControl(pfx2,1,target:GetAbsOrigin()+Vector(0,0,822))
	Timers:CreateTimer(3.5, function()
		ParticleManager:DestroyParticle(pfx2, false)
	end)		
end

function arena_mana_drain_effect(event)
	local target = event.target
	local manaDrain = target:GetMaxMana()*0.02
	target:ReduceMana(manaDrain)
end

function war_rally_think(event)
	local caster = event.caster
	local ability = event.ability
	local ratio = caster:GetHealth()/caster:GetMaxHealth()
	local stacks = (1-ratio)*100
	if stacks > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_war_rally_effect", {})
		caster:SetModifierStackCount("modifier_war_rally_effect", caster, stacks)
	else
		caster:RemoveModifierByName("modifier_war_rally_effect")
	end
end

function axe_throwing_think(event)
	local caster = event.caster
	local enemy = caster.axeEnemy
	local axeAbility = caster:FindAbilityByName("arena_wild_axes")
	if axeAbility:IsFullyCastable() then
		local castDirection =  ((enemy:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		local castPoint = caster:GetAbsOrigin()+(castDirection*1250)
		local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = axeAbility:entindex(),
				Position = castPoint
		 	}
		local soundChance = RandomInt(1,6)
		if soundChance == 1 then
			EmitSoundOn("Arena.Challenger8.Growl", caster)
		end
		ExecuteOrderFromTable(newOrder)	
	end	
end

function nightmare_fiends_effect_think(event)
	local target = event.target
	if Arena.NightmareScene then
		return
	end
	GameRules:SetTimeOfDay(0.75)
	local allies = FindUnitsInRadius( target:GetTeamNumber(), target:GetAbsOrigin(), nil, 840, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )	
	if #allies > 0 then
		Arena.NightmareScene = true
		Arena:NightmareBossScene()
	end
end

function challenger_5_meteor_think(event)
	local caster = event.caster
	local ability = caster:FindAbilityByName("challenger_5_chaos_meteor")
	if Arena.BetweenBattles then
		return
	end
	if not caster:HasModifier("modifier_arena_enemy") then
		return
	end
	if ability:IsFullyCastable() then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
		local castDirection = RandomVector(1)
		if #enemies > 0 then
			castDirection = ((enemies[1]:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		end
		local castPoint = caster:GetAbsOrigin()+(castDirection*RandomInt(80, 1000))
		local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = ability:entindex(),
				Position = castPoint
		 	}
		ExecuteOrderFromTable(newOrder)	
		StartAnimation(caster, {duration=0.75, activity=ACT_DOTA_ATTACK, rate=2.0})
	end		
end

function challenger_4_blink_madness(event)
	local caster = event.caster
	if Arena.BetweenBattles then
		return
	end
	if not caster:HasModifier("modifier_arena_enemy") then
		return
	end
	if caster:HasModifier("modifier_challenger_4_shield_root") then
		return
	end
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_antimage/antimage_blink_start.vpcf", caster, 1)
	local luck = RandomInt(1,3)
	if luck == 1 then
		pullCrowd(true, 1)
	end
	StartAnimation(caster, {duration=0.27, activity=ACT_DOTA_CAST_ABILITY_2, rate=2.2})
	local blinkPosition = caster.opponent:GetAbsOrigin()+RandomVector(RandomInt(60,400))
	FindClearSpaceForUnit(caster, blinkPosition, false)
	EmitSoundOn("Arena.Challenger4.BlinkOut", caster)
	Timers:CreateTimer(0.05, function()
		EmitSoundOn("Arena.Challenger4.BlinkIn", caster)
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_antimage/antimage_blink_end.vpcf", caster, 1)
	end)
end

function challenger_4_shield_start(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Arena.Challenger4.CrazyLaugh", caster)
	StartAnimation(caster, {duration=2.5, activity=ACT_DOTA_TAUNT, rate=1.0, translate="magic_ends_here"})
	Timers:CreateTimer(0.5, function()
		pullCrowd(true, 5)
	end)
end

function challenger_shield_think(event)
	local caster = event.caster
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Item.Maelstrom.Chain_Lightning", Events.GameMaster)
	local baseLightningPos = caster:GetAbsOrigin()+RandomVector(170)+Vector(0,0,100)
	local extendedLightningDirection = ((baseLightningPos-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	local extendLightningPos = baseLightningPos + extendedLightningDirection*RandomInt(100,450)
	Events:CreateLightningBeam(baseLightningPos, extendLightningPos)

	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 450, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for i = 1, #enemies, 1 do
			Events:CreateLightningBeam(baseLightningPos, enemies[i]:GetAbsOrigin()+Vector(0,0,70))
			ApplyDamage({ victim = enemies[1], attacker = caster, damage = 5000, damage_type = DAMAGE_TYPE_MAGICAL })
			enemies[1]:AddNewModifier(caster, nil, "modifier_stunned", {duration = 0.1})		
		end
	end
end

function challenger_3_b_think(event)
	local caster = event.caster
	if not caster.interval then
		caster.interval = true
	else
		caster.interval = false
	end
	if not caster.opponent then
		return false
	end
	if not Arena.BattleScene or Arena.BetweenBattles then
		return
	end
	if not caster.bro:IsAlive() then
		ApplyDamage({ victim = caster, attacker = Arena.ArenaMaster, damage = caster:GetMaxHealth()*10, damage_type = DAMAGE_TYPE_PURE })
	end
	if caster.interval then
		local distance = WallPhysics:GetDistance(caster.bro:GetAbsOrigin()*Vector(1,1,0), caster.bro.opponent:GetAbsOrigin()*Vector(1,1,0))
		local angle = ((caster.bro.opponent:GetAbsOrigin()-caster.bro:GetAbsOrigin())*Vector(1,1,0)):Normalized()

		FindClearSpaceForUnit(caster, caster.bro.opponent:GetAbsOrigin()+(angle*distance), false)
		StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_CAST_ABILITY_5, rate=1, translate="qop_blink"})
		CustomAbilities:QuickAttachParticle("particles/econ/items/meepo/meepo_colossal_crystal_chorus/meepo_divining_rod_poof_end.vpcf", caster, 2.5)
		EmitSoundOn("Arena.Challenger3.Tone"..RandomInt(2,5), caster)
	else
		local distance = WallPhysics:GetDistance(caster:GetAbsOrigin()*Vector(1,1,0), caster.bro.opponent:GetAbsOrigin()*Vector(1,1,0))
		local angle = ((caster.bro.opponent:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()

		FindClearSpaceForUnit(caster.bro, caster.bro.opponent:GetAbsOrigin()+(angle*distance), false)
		StartAnimation(caster.bro, {duration=1.0, activity=ACT_DOTA_CAST_ABILITY_5, rate=1, translate="am_blink"})
		CustomAbilities:QuickAttachParticle("particles/econ/items/meepo/meepo_colossal_crystal_chorus/meepo_divining_rod_poof_end.vpcf", caster.bro, 2.5)
		EmitSoundOn("Arena.Challenger3.Tone"..RandomInt(2,5), caster.bro)
	end
	local boltAbility = caster:FindAbilityByName("arena_challenger_3_bolt")
	if boltAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )	
		if #enemies > 0 then
			local newOrder = {
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					AbilityIndex = boltAbility:entindex(),
					TargetIndex = enemies[1]:entindex()
			 	}
			 
			ExecuteOrderFromTable(newOrder)			
		end
		return
	end
end

function challenger_3_precast_bolt(event)
	local caster = event.caster
	local luck = RandomInt(1,2)
	if luck == 1 then
		EmitSoundOn("Arena.Challenger3.Laugh"..RandomInt(1,4), caster)
	end
	
end

function challenger_3_bolt(event)
	local caster = event.caster
	local target = event.target
	EmitSoundOn("Arena.Challenger3.FadeBoltCast", caster)
	EmitSoundOn("Arena.Challenger3.FadeBoltTarget", target)
	local damage = event.damage
	local particleName = "particles/roshpit/arena/fade_bolt_red.vpcf"
	local modifierName = "modifier_challenger_bolt_red_debuff"
	if caster:GetUnitName() == "champion_league_challenger_3_a" then
		particleName = "particles/roshpit/arena/fade_bolt_blue.vpcf"
		modifierName = "modifier_challenger_bolt_blue_debuff"
	end
	challenger_3_beam(caster:GetAbsOrigin()+Vector(0,0,100), target:GetAbsOrigin()+Vector(0,0,100), particleName)
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE })
	event.ability:ApplyDataDrivenModifier(caster, target, modifierName, {duration = 2})
end

function challenger_3_beam(attachPointA, attachPointB, particleName)
      local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster) 
      ParticleManager:SetParticleControl(lightningBolt,0,Vector(attachPointA.x,attachPointA.y,attachPointA.z))   
      ParticleManager:SetParticleControl(lightningBolt,1,Vector(attachPointB.x,attachPointB.y,attachPointB.z))
      Timers:CreateTimer(2, function()
        ParticleManager:DestroyParticle(lightningBolt, false)
      end)
end

function challenger_2_sword_dash(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_challenger_2_charging", {duration = 6})
	ability.damage = event.damage
	local moveDirection = ((target:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	local distance = WallPhysics:GetDistance(target:GetAbsOrigin()*Vector(1,1,0), caster:GetAbsOrigin()*Vector(1,1,0))
	local targetPosition = caster:GetAbsOrigin()+moveDirection*distance*2
	caster:MoveToPosition(targetPosition)
	ability.targetPosition = targetPosition
	caster.attacked = false
	caster:AddNewModifier( caster, nil, 'modifier_movespeed_cap', nil )
end

function challenger_sword_dash_think(event)
	local caster = event.caster
	if caster.attacked then
		return
	end
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 160, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )	
	if #enemies > 0 then
		local enemy = enemies[1]
		EmitSoundOn("Arena.Challenger2.AttackCrit", enemy)
		caster:PerformAttack(enemy, true, true, false, true, false, false, false)
		StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_ATTACK, rate=2.0})
		caster.attacked = true
		CustomAbilities:QuickAttachParticle("particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void_hit.vpcf", enemy, 4)
		if caster:GetUnitName() == "champion_league_challenger_2" then
			pullCrowd(true, 5)
		end
		Timers:CreateTimer(1.2, function()
			caster:RemoveModifierByName("modifier_challenger_2_charging")
		end)
		ApplyDamage({ victim = enemy, attacker = caster, damage = event.ability.damage, damage_type = DAMAGE_TYPE_PURE })
	end
	if WallPhysics:GetDistance(caster:GetAbsOrigin(), event.ability.targetPosition) < 170 then
		caster:RemoveModifierByName("modifier_challenger_2_charging")
	end
end

function challenger_1_illuminate(event)
	local target = event.target_points[1]
	local caster = event.caster
	local ability = event.ability
	local particleName = "particles/roshpit/arena/challenger_1_linear_eal_blade.vpcf"

	local projectileStartPosition = caster:GetAbsOrigin() - caster:GetForwardVector()*400 + Vector(0,0,140)
	local projectileDirection = ((target-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	local projectileTable =
	{
		EffectName = particleName,
		Ability = ability,
		vSpawnOrigin = projectileStartPosition,
		vVelocity = projectileDirection * 1000,
		fDistance = 2200,
		fStartRadius = 140,
		fEndRadius = 140,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = true,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO
	}
	ability.illuminate_projectileID = ProjectileManager:CreateLinearProjectile( projectileTable )	

	Timers:CreateTimer(0.8, function()
		local projectileStartPosition = caster:GetAbsOrigin() - caster:GetForwardVector()*400 + RandomVector(200) + Vector(0,0,140)
		local projectileDirection = caster:GetForwardVector()
		local projectileTable =
		{
			EffectName = particleName,
			Ability = ability,
			vSpawnOrigin = projectileStartPosition,
			vVelocity = projectileDirection * 1000,
			fDistance = 2200,
			fStartRadius = 140,
			fEndRadius = 140,
			Source = caster,
			bHasFrontalCone = false,
			bReplaceExisting = true,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO
		}
		ability.illuminate_projectileID = ProjectileManager:CreateLinearProjectile( projectileTable )	
		EmitSoundOn("Arena.Challenger1.Illuminate", caster)
	end)
	Timers:CreateTimer(1.7, function()
		local projectileStartPosition = caster:GetAbsOrigin() - caster:GetForwardVector()*400 + RandomVector(200) + Vector(0,0,140)
		local projectileDirection = caster:GetForwardVector()
		local projectileTable =
		{
			EffectName = particleName,
			Ability = ability,
			vSpawnOrigin = projectileStartPosition,
			vVelocity = projectileDirection * 1000,
			fDistance = 2200,
			fStartRadius = 140,
			fEndRadius = 140,
			Source = caster,
			bHasFrontalCone = false,
			bReplaceExisting = true,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO
		}
		ability.illuminate_projectileID = ProjectileManager:CreateLinearProjectile( projectileTable )	
		EmitSoundOn("Arena.Challenger1.Illuminate", caster)
	end)
	if Arena.scoreL > 1 then
		Timers:CreateTimer(2.6, function()
			local projectileStartPosition = caster:GetAbsOrigin() - caster:GetForwardVector()*400 + RandomVector(200) + Vector(0,0,140)
			local projectileDirection = caster:GetForwardVector()
			local projectileTable =
			{
				EffectName = particleName,
				Ability = ability,
				vSpawnOrigin = projectileStartPosition,
				vVelocity = projectileDirection * 1000,
				fDistance = 2200,
				fStartRadius = 140,
				fEndRadius = 140,
				Source = caster,
				bHasFrontalCone = false,
				bReplaceExisting = true,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO
			}
			ability.illuminate_projectileID = ProjectileManager:CreateLinearProjectile( projectileTable )	
			EmitSoundOn("Arena.Challenger1.Illuminate", caster)
		end)
	end
	if Arena.scoreL > 2 then
		Timers:CreateTimer(3.6, function()
			local projectileStartPosition = caster:GetAbsOrigin() - caster:GetForwardVector()*400 + RandomVector(200) + Vector(0,0,140)
			local projectileDirection = caster:GetForwardVector()
			local projectileTable =
			{
				EffectName = particleName,
				Ability = ability,
				vSpawnOrigin = projectileStartPosition,
				vVelocity = projectileDirection * 1000,
				fDistance = 2200,
				fStartRadius = 140,
				fEndRadius = 140,
				Source = caster,
				bHasFrontalCone = false,
				bReplaceExisting = true,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO
			}
			ability.illuminate_projectileID = ProjectileManager:CreateLinearProjectile( projectileTable )	
			EmitSoundOn("Arena.Challenger1.Illuminate", caster)
		end)
	end
end

function challenger_1_illuminate_hit(event)
	local target = event.target
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_illuminate_impact.vpcf", target, 3)
end

function challenger_1_buff_start(event)
	local target = event.target
	CustomAbilities:QuickAttachParticle("particles/neutral_fx/roshan_spawn.vpcf", target, 3)
	
end

function challenger_1_attack_hit(event)
	local target = event.target
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_wisp/wisp_guardian_explosion.vpcf", target, 3)
end