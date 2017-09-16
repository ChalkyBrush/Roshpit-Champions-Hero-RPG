require('/heroes/huskar/flametongue')
require('/heroes/huskar/windstrike')
require('/heroes/huskar/waterheart')
--WATER

function start_channel(event)
	local caster = event.caster
	local ability = event.ability
	local soundTable = {"SpiritWarrior.SpiritYell1", "SpiritWarrior.SpiritYell2", "SpiritWarrior.SpiritYell3"}
	EmitSoundOn(soundTable[RandomInt(1,3)], caster)
	StartSoundEvent("SpiritWarrior.AncientVigorChannel", caster)
	local c_d_level = Runes:GetTotalRuneLevelGeneric(caster, 3, 3)
	if c_d_level > 0 then
		local waterheart = caster:FindAbilityByName("spirit_warrior_waterheart_weapon")
		if not waterheart then
			waterheart = caster:AddAbility("spirit_warrior_waterheart_weapon")
		end
		waterheart:SetLevel(ability:GetLevel())
		waterheart:SetAbilityIndex(3)
		caster:SwapAbilities("spirit_warrior_ancient_rain", "spirit_warrior_waterheart_weapon", false, true)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_rain_hidden_waterheart_thinker", {})
		waterheart.c_d_level = c_d_level
	end
end

function hidden_water_heart_thinker(event)
	local caster = event.caster
	local ability = event.ability
	if ability:GetCooldownTimeRemaining() <= 0.3 then
		local waterheart = caster:FindAbilityByName("spirit_warrior_waterheart_weapon")
		ability:SetLevel(waterheart:GetLevel())
		ability:SetAbilityIndex(3)
		caster:SwapAbilities("spirit_warrior_ancient_rain", "spirit_warrior_waterheart_weapon", true, false)
		caster:RemoveModifierByName("modifier_rain_hidden_waterheart_thinker")
	end
end

function channel_interrupt(event)
	local caster = event.caster
	StopSoundEvent("SpiritWarrior.AncientVigorChannel", caster)
end

function ancient_rain_start(event)
	local caster = event.caster
	local ability = event.ability
	local duration = event.duration
	if caster:HasModifier("modifier_spirit_warrior_glyph_7_1") then
		duration = duration + 4
	end
	duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_ancient_rain", {duration = duration})
	Timers:CreateTimer(0.5, function()
		StopSoundEvent("SpiritWarrior.AncientVigorChannel", caster)
	end)
	EmitSoundOn("SpiritWarrior.AncientVigorStart", caster)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "SpiritWarrior.AncientVigorYell", caster)
	Timers:CreateTimer(0.1, function()
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "SpiritWarrior.AncientVigorStart2", caster)
	end)
	StartAnimation(caster, {duration=1, activity=ACT_DOTA_TELEPORT_END, rate=1})
	ability.a_d_level = Runes:GetTotalRuneLevelGeneric(caster, 1, 3)
	ability.b_d_level = Runes:GetTotalRuneLevelGeneric(caster, 2, 3)
	if ability.a_d_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_ancient_rain_regen", {duration = duration})
	end
	Filters:CastSkillArguments(4, caster)
end

function ancient_rain_think(event)
	local caster = event.caster
	local ability = event.ability
	if ability.b_d_level > 0 then
		local damage = ability.b_d_level*0.05*caster:GetAverageTrueAttackDamage(caster)
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false )
		if #enemies > 0 then
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "SpiritWarrior.RainLightning", caster)
			local enemy = enemies[1]
			MaelstromBeam(caster:GetAbsOrigin()+Vector(0,0,500), enemy:GetAbsOrigin())
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_WATER, RPC_ELEMENT_LIGHTNING)
		end 	
	end
	local armor_per_missing_health = event.armor_per_missing_health
	local missingHealth = caster:GetHealth()
	local armorBonus = math.floor(missingHealth*armor_per_missing_health/200)
	if armorBonus > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_ancient_rain_armor", {})
		caster:SetModifierStackCount("modifier_ancient_rain_armor", caster, armorBonus)
	else
		caster:RemoveModifierByName("modifier_ancient_rain_armor")
	end
end

function ancient_rain_regen_think(event)
	local caster = event.caster
	local ability = event.ability
	local healAmount = caster:GetMaxHealth()*0.003*ability.a_d_level
	Filters:ApplyHeal(caster, caster, healAmount, true)
end

function MaelstromBeam(attachPointA, attachPointB)
      local particleName = "particles/econ/events/ti7/maelstorm_ti7.vpcf"
      local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster) 
      ParticleManager:SetParticleControl(lightningBolt,0,Vector(attachPointA.x,attachPointA.y,attachPointA.z))   
      ParticleManager:SetParticleControl(lightningBolt,1,Vector(attachPointB.x,attachPointB.y,attachPointB.z))
      Timers:CreateTimer(2, function()
        ParticleManager:DestroyParticle(lightningBolt, false)
      end)
end

--FIRE

function blazing_javelin_precast(event)
	local caster = event.caster
	StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_ATTACK, rate=1.6})
end
function blazing_javelin_cast(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	Filters:CastSkillArguments(2, caster)
	
	local perpVector = WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi/4)
	local spellStartPoint = caster:GetAbsOrigin()+Vector(0,0,120) + perpVector*80
	local fv = ((point-spellStartPoint)*Vector(1,1,0)):Normalized()
	local solidFV = fv
	local c_b_level = Runes:GetTotalRuneLevelGeneric(caster, 3, 1)
	local procs = Runes:Procs(c_b_level, 10, 1)
	ability:SetActivated(false)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_javelin_root", {duration = 0.15*procs})
	for i = 0, procs, 1 do
		Timers:CreateTimer(i*0.15, function()
			if i > 0 then
				local newFV = WallPhysics:rotateVector(solidFV, 2*math.pi/90*RandomInt(-5, 5))
				caster:SetForwardVector(newFV)
				fv = newFV
				local perpVector = WallPhysics:rotateVector(newFV, 2*math.pi/4)
				spellStartPoint = caster:GetAbsOrigin()+Vector(0,0,120) + perpVector*80	
				StartAnimation(caster, {duration=0.15, activity=ACT_DOTA_ATTACK, rate=3})			
			end
			if i == procs then
				ability:SetActivated(true)
			end
	    	local particle = "particles/econ/items/mirana/mirana_crescent_arrow/ruins_boss_linear.vpcf"
			local start_radius = 155
			local end_radius = 155
			local range = event.cast_range
			local speed = 1200

			EmitSoundOn("Hero_TrollWarlord.PreAttack", caster)
			
			local casterOrigin = caster:GetAbsOrigin()

			local info = 
			{
					Ability = ability,
		        	EffectName = particle,
		        	vSpawnOrigin = spellStartPoint,
		        	fDistance = range,
		        	fStartRadius = start_radius,
		        	fEndRadius = end_radius,
		        	Source = caster,
		        	StartPosition = "attach_attack1",
		        	bHasFrontalCone = true,
		        	bReplaceExisting = false,
		        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		        	fExpireTime = GameRules:GetGameTime() + 5.0,
				bDeleteOnHit = false,
				vVelocity = fv*Vector(1,1,0) * speed,
				bProvidesVision = false,
			}
			projectile = ProjectileManager:CreateLinearProjectile(info)
		end)
	end
	ability.b_b_level = Runes:GetTotalRuneLevelGeneric(caster, 2, 1)
end

function javelin_hit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local damage = event.damage
	EmitSoundOn("SpiritWarrior.BlazingJavelin.Impact", target)
	if not ability.particleCount then
		ability.particleCount = 0
	end
	if ability.particleCount < 10 then
		ability.particleCount = ability.particleCount + 1
		local particleName = "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf"
		local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
		ParticleManager:SetParticleControl( particle1, 0, target:GetAbsOrigin() )
		Timers:CreateTimer(1.5, 
			function()
				ParticleManager:DestroyParticle( particle1, false )
				ability.particleCount = ability.particleCount - 1
			end)
	end
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_FIRE, RPC_ELEMENT_NORMAL)
	local b_b_level = ability.b_b_level
	if b_b_level > 0 then
		local mult = b_b_level*0.04
		if caster:HasModifier("modifier_flametongue") then
	  	local eventTable = {}
	  	eventTable.caster = caster
	  	eventTable.ability = caster:FindAbilityByName("spirit_warrior_flametongue")
	  	eventTable.pure_damage = eventTable.ability:GetSpecialValueFor("flat_pure_damage")
	  	eventTable.target = target
	  	eventTable.attacker = caster
	  	eventTable.mult = mult
			flametongue_attack_land(eventTable)
		end
		if caster:HasModifier("modifier_windstrike_weapon") then
	  	local eventTable = {}
	  	eventTable.caster = caster
	  	eventTable.ability = caster:FindAbilityByName("spirit_warrior_windstrike_weapon")
	  	eventTable.target = target
	  	eventTable.attacker = caster
	  	eventTable.mult = mult
			windstrike_attack_land(eventTable)
		end
		if caster:HasModifier("modifier_waterheart_weapon") then
	  	local eventTable = {}
	  	eventTable.caster = caster
	  	eventTable.ability = caster:FindAbilityByName("spirit_warrior_waterheart_weapon")
	  	eventTable.target = target
	  	eventTable.attacker = caster
	  	eventTable.mult = mult
			waterheart_attack_land(eventTable)
		end
	end
	if caster:HasModifier("modifier_flametongue") and caster:HasModifier("modifier_spirit_warrior_glyph_2_1") then
    	local flametongueAbility = caster:FindAbilityByName("spirit_warrior_flametongue")
    	flametongueAbility.a_a_level = Runes:GetTotalRuneLevel(caster, 1, "a_a", "spirit_warrior")
		if flametongueAbility.a_a_level > 0 then
			flametongueAbility:ApplyDataDrivenModifier(caster,target, "modifier_flametongue_a_a_rune", {duration = 5})
			local stacks = target:GetModifierStackCount("modifier_flametongue_a_a_rune", caster)
			local newStacks = math.min(stacks+1, 10)
			target:SetModifierStackCount("modifier_flametongue_a_a_rune", caster, newStacks)
		end
	end
		if caster:HasModifier("modifier_spirit_warrior_glyph_5_1") then
	    	local manaRestore = ability:GetManaCost(ability:GetLevel()-1)*0.15
	    	caster:GiveMana(manaRestore)
	    end 
end

function blazing_javelin_passive_think(event)
	local caster = event.caster
	local ability = event.ability
	local a_b_level = Runes:GetTotalRuneLevelGeneric(caster, 1, 1)
	local damageBonus = (caster:GetMaxHealth() - caster:GetHealth())*0.12*a_b_level
	if damageBonus > 1 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_spirit_warrior_arcana2_attack_damage", {})
		caster:SetModifierStackCount("modifier_spirit_warrior_arcana2_attack_damage", caster, damageBonus)
	else
		caster:RemoveModifierByName("modifier_spirit_warrior_arcana2_attack_damage")
	end
	if a_b_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_spirit_warrior_arcana2_health", {})
		caster:SetModifierStackCount("modifier_spirit_warrior_arcana2_health", caster, a_b_level)
	else
		caster:RemoveModifierByName("modifier_spirit_warrior_arcana2_health")
	end
end

function cast_ancient_spirit_elite(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	local cooldown = event.cooldown
	if not ability.spiritTable then
		ability.spiritTable = {}
	end
	-- local allies = FindUnitsInRadius(caster:GetTeamNumber(), target, nil, 180, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	-- local targetedSpirit = false
	-- for i = 1, #allies, 1 do
	-- 	if allies[i]:GetUnitName() == "spirit_warrior_spirit" then
	-- 		targetedSpirit = allies[i]
	-- 		break
	-- 	end
	-- end
		ability.target = target
		Filters:CastSkillArguments(3, caster)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_spirit_dashing", {duration = 3.4})
		caster:RemoveModifierByName("modifier_spirit_warrior_glyph_effect")
		ability.targetedSpirit = targetedSpirit
		local soundTable = {"SpiritWarrior.SpiritYell1", "SpiritWarrior.SpiritYell2", "SpiritWarrior.SpiritYell3"}
		EmitSoundOn(soundTable[RandomInt(1,3)], caster)
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "SpiritWarrior.AncientSpiritJumping", caster)
end

function spirit_dashing_think(event)
	local caster = event.caster
	local ability = event.ability
	local spirit = ability.targetedSpirit

	local spiritOrigin = ability.target
	local casterOrigin = caster:GetAbsOrigin()
	local moveVector = ((spiritOrigin-casterOrigin)*Vector(1,1,0)):Normalized()
	local dashSpeed = 34
	if caster:HasModifier("modifier_spirit_warrior_glyph_1_1") then
		dashSpeed = math.floor(dashSpeed*1.5)
	end
	local newPosition = casterOrigin+moveVector*dashSpeed
	local obstruction = WallPhysics:FindNearestObstruction(newPosition)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition, caster)
	if not blockUnit then
		caster:SetAbsOrigin(newPosition)
		local distance = WallPhysics:GetDistance(spiritOrigin*Vector(1,1,0), caster:GetAbsOrigin()*Vector(1,1,0))
		if distance < 50 then
			if not ability.lock then
				ability.lock = true
				caster:RemoveModifierByName("modifier_spirit_dashing")
				FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
				create_spirit_elite(caster, ability, spiritOrigin)
				Timers:CreateTimer(0.5, function()
					ability.lock = false
				end)
			end
			-- reachSpirit(caster, ability, spirit:GetAbsOrigin())
			-- removeSpirit(spirit, ability, caster)
		end
	else
		if not ability.lock then
			ability.lock = true
			create_spirit_elite(caster, ability, spiritOrigin)
			caster:RemoveModifierByName("modifier_spirit_dashing")
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
			Timers:CreateTimer(0.5, function()
				ability.lock = false
			end)
		end


		-- reachSpirit(caster, ability, spirit:GetAbsOrigin())
		-- removeSpirit(spirit, ability, caster)
	end
end

function create_spirit_elite(caster, ability, target)
		EmitSoundOn("SpiritWarrior.AncientSpiritCast", caster)
		local spirit = CreateUnitByName("spirit_warrior_spirit_elite", caster:GetAbsOrigin(), false, nil, nil, caster:GetTeamNumber())
		spirit:SetOwner(caster)
	    spirit:SetControllableByPlayer(caster:GetPlayerID(), true)
		ancient_spirit_particle(spirit:GetAbsOrigin(), caster)
		local fv = ((target-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		spirit:SetForwardVector(fv)
		ability:ApplyDataDrivenModifier(caster, spirit, "modifier_ancient_spirit_spirit", {})
		if not caster:HasModifier("modifier_ancient_vigor") then
			ability:ApplyDataDrivenModifier(caster, spirit, "modifier_ancient_spirit_disarm", {})
		else
			ability:ApplyDataDrivenModifier(caster, spirit, "modifier_spirit_attacking", {})
			local c_d_level = Runes:GetTotalRuneLevel(caster, 3, "c_d", "spirit_warrior")
			spirit.c_d_level = c_d_level
		end
		-- spirit:AddNewModifier( spirit, nil, 'modifier_movespeed_cap', nil )

		-- ability:ApplyDataDrivenModifier(caster, spirit, "modifier_spirit_moving_out", {})
		spirit.targetPoint = target
		spirit.origCaster = caster
		for i = 1, 20, 1 do
			Timers:CreateTimer(i*0.03, function()
				spirit:SetModelScale(0.3+(i*0.02))
			end)
		end

		table.insert(ability.spiritTable, spirit)

		local b_c_level = Runes:GetTotalRuneLevelGeneric(caster, 2, 2)
		if b_c_level > 0 then
			local spiritAbility = spirit:AddAbility("spirit_warrior_b_c_special_arcana3")
			spiritAbility.level = b_c_level
			spiritAbility:SetLevel(1)
		end

		local maxSpirits = 3
		if caster:HasModifier("modifier_spirit_warrior_glyph_3_1") then
			maxSpirits = 5
		end
		if #ability.spiritTable > maxSpirits then
			removeSpirit(ability.spiritTable[1], ability, caster)
		end
		reachSpirit(caster, ability, caster:GetAbsOrigin())
end

function ancient_spirit_particle(position, caster)
	position = position-Vector(0,0,30)
    local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/spirit_warrior_spirit_pop.vpcf", PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(pfx, 0, position)
    ParticleManager:SetParticleControl(pfx, 1, position)
    ParticleManager:SetParticleControl(pfx, 2, position)
    ParticleManager:SetParticleControl(pfx, 3, position)
    Timers:CreateTimer(2, function()
    	ParticleManager:DestroyParticle(pfx, false)
    end)
end

function reindexSpiritTable(ability)
	local newTable = {}
	for i = 1, #ability.spiritTable, 1 do
		if IsValidEntity(ability.spiritTable[i]) then
			table.insert(newTable, ability.spiritTable[i])
		end
	end
	ability.spiritTable = newTable
end

function removeSpirit(spirit, ability, caster)
	ancient_spirit_particle(spirit:GetAbsOrigin(), caster)
	EmitSoundOn("SpiritWarrior.AncientSpiritDestroy", spirit)
	UTIL_Remove(spirit)
	reindexSpiritTable(ability)
end

function reachSpirit(caster, ability, spiritPosition)
	local d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "spirit_warrior")
	if d_b_level > 0 then
		local runeAbility = caster.runeUnit4:FindAbilityByName("spirit_warrior_rune_d_b")
		local duration = Filters:GetAdjustedBuffDuration(caster, 30, false)
		runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_spirit_warrior_d_b", {duration = duration})
		runeAbility.level = d_b_level
	end
	local a_c_level = Runes:GetTotalRuneLevelGeneric(caster, 1, 2)
	caster.d_c_level = Runes:GetTotalRuneLevel(caster, 4, "d_c", "spirit_warrior")
	if a_c_level > 0 then
		local loops = 1
		if caster:HasModifier("modifier_spirit_warrior_glyph_4_1") then
			loops = 5
		end
		for i = 0, loops-1, 1 do
			Timers:CreateTimer(i*0.75, function()
				EmitSoundOnLocationWithCaster(spiritPosition, "SpiritWarrior.ACExplosion", caster)
				local particleName = "particles/units/heroes/hero_ember_spirit/spirit_warrior_c_a_wind_edict.vpcf"
			    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
			    ParticleManager:SetParticleControl(pfx, 0, spiritPosition)
			    ParticleManager:SetParticleControl(pfx, 1, spiritPosition)
			    ParticleManager:SetParticleControl(pfx, 2, spiritPosition)
			    ParticleManager:SetParticleControl(pfx, 3, spiritPosition)
			    Timers:CreateTimer(2, function()
			    	ParticleManager:DestroyParticle(pfx, false)
			    end)
			    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), spiritPosition, nil, 410, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			    if #enemies > 0 then
			    	local damage = 8800*a_c_level
			        for _,enemy in pairs(enemies) do
			        	Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 3, RPC_ELEMENT_WIND, RPC_ELEMENT_NONE)
			        end
			    end 
			end)
		end
	end
	local c_c_level = Runes:GetTotalRuneLevelGeneric(caster, 3, 2)
	if c_c_level > 0 then
		EmitSoundOnLocationWithCaster(spiritPosition, "SpiritWarrior.TempestHaze", caster)
		local duration = 3 + c_c_level*0.12
		local stormParticle = ParticleManager:CreateParticle("particles/roshpit/spirit_warrior/tempest_haze_storm.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(stormParticle, 0, spiritPosition)
		ParticleManager:SetParticleControl(stormParticle, 1, Vector(800, 2, 2))
		ParticleManager:SetParticleControl(stormParticle, 2, Vector(duration, duration, duration))
		ability:ApplyDataDrivenThinker(caster, spiritPosition, "modifier_tempest_haze_aura_thinker_enemy", {duration = duration})
		ability:ApplyDataDrivenThinker(caster, spiritPosition, "modifier_tempest_haze_aura_thinker_friendly", {duration = duration})
		
		ability.c_c_damage_tick = 12000*c_c_level*0.5
	end
	-- "particles/roshpit/spirit_warrior/tempest_haze_storm.vpcf"

end