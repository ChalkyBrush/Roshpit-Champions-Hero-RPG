function start_channel(event)
	local caster = event.caster
	StartSoundEvent("Ekkan.SuperCharge.ChannelLP", caster)
end

function supercharge_start(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	Timers:CreateTimer(1, function()
		StopSoundEvent("Ekkan.SuperCharge.ChannelLP", caster)
	end)
	if target:GetTeamNumber() == caster:GetTeamNumber() then
		local buffDuration = Filters:GetAdjustedBuffDuration(caster, event.duration, false)
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Ekkan.SuperCharge.Buff", caster)
		EmitSoundOn("Ekkan.SuperCharge.VO", caster)
		Timers:CreateTimer(0.25, function()
			EmitSoundOn("Ekkan.SuperCharge.BuffTarget", target)
			
			ability:ApplyDataDrivenModifier(caster, target, "modifier_ekkan_supercharge", {duration = buffDuration})
		end)
		Timers:CreateTimer(0.1, function()
			StartAnimation(caster, {duration=0.85, activity=ACT_DOTA_CAST_ABILITY_2, rate=1.1})
		end)
		local beamPFX = ParticleManager:CreateParticle("particles/roshpit/ekkan/cast_beams_beams.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(beamPFX, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(beamPFX, 1, target:GetAbsOrigin()+Vector(0,0,30))
		Timers:CreateTimer(3, function()
			ParticleManager:DestroyParticle(beamPFX, false)
			ParticleManager:ReleaseParticleIndex(beamPFX)
		end)
		ability.r_1_level = Runes:GetTotalRuneLevel(caster, 1, "r_1", "ekkan")
		local d_d_level = Runes:GetTotalRuneLevel(caster, 4, "r_4", "ekkan")
		local procs = Runes:Procs(d_d_level, 10, 1)
		if procs > 0 then
			ability.origChain = target
			for i = 1, procs, 1 do
				Timers:CreateTimer(0.3*i, function()
					superchargeChain(caster, ability, event)
				end)
			end
		end
	else
		if target:GetUnitName() == "ekkan_corpse" then
			local beamPFX = ParticleManager:CreateParticle("particles/roshpit/ekkan/cast_beams_beams.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(beamPFX, 0, caster:GetAbsOrigin())
			ParticleManager:SetParticleControl(beamPFX, 1, target:GetAbsOrigin()+Vector(0,0,30))
			Timers:CreateTimer(3, function()
				ParticleManager:DestroyParticle(beamPFX, false)
				ParticleManager:ReleaseParticleIndex(beamPFX)
			end)
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Ekkan.SuperCharge.Buff", caster)
			EmitSoundOn("Ekkan.SuperCharge.VO", caster)
			Timers:CreateTimer(0.25, function()
				local c_d_level = Runes:GetTotalRuneLevel(caster, 3, "r_3", "ekkan")
				EmitSoundOn("Ekkan.SuperCharge.BuffTarget", target)
				local superSkeleton = CreateUnitByName("ekkan_supercharged_skeleton", target:GetAbsOrigin(), false, nil, nil, caster:GetTeamNumber())
				superSkeleton.hero = caster
				superSkeleton.damage = target.attackpower*0.08*c_d_level
				superSkeleton.numTargets = 1
			    if caster:HasModifier("modifier_ekkan_glyph_7_1") then
			    	superSkeleton.numTargets = 3
			    end
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_visage/visage_stone_form.vpcf", superSkeleton, 3)
				EmitSoundOn("Ekkan.SkeletonSpawn", superSkeleton)
				UTIL_Remove(target)
			end)
			Timers:CreateTimer(0.1, function()
				StartAnimation(caster, {duration=0.85, activity=ACT_DOTA_CAST_ABILITY_2, rate=1.1})
			end)	
		else
			supercharge_enemy(caster, target, ability)
		end
	end
	Filters:CastSkillArguments(4, caster)
end

function supercharge_buff_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if caster:HasModifier("modifier_ekkan_glyph_4_1") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_supercharge_glyphed", {duration = 15})
	end
end

function superchargeChain(caster, ability, event)
	local buffDuration = Filters:GetAdjustedBuffDuration(caster, event.duration, false)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Ekkan.SuperCharge.Buff", caster)

	local allies = FindUnitsInRadius( caster:GetTeamNumber(), ability.origChain:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	local newTarget = false
	if #allies > 0 then
		for i = 1, #allies, 1 do
			if allies[i].ekkan_unit then
				if not allies[i]:HasModifier("modifier_ekkan_supercharge") then
					newTarget = allies[i]
					break
				end
			end
		end
	end 
	if newTarget then
		Timers:CreateTimer(0.25, function()
			EmitSoundOn("Ekkan.SuperCharge.BuffTarget", newTarget)
			ability:ApplyDataDrivenModifier(caster, newTarget, "modifier_ekkan_supercharge", {duration = buffDuration})
		end)
		local beamPFX = ParticleManager:CreateParticle("particles/roshpit/ekkan/cast_beams_beams.vpcf", PATTACH_CUSTOMORIGIN, ability.origChain)
		ParticleManager:SetParticleControl(beamPFX, 0, ability.origChain:GetAbsOrigin())
		ParticleManager:SetParticleControl(beamPFX, 1, newTarget:GetAbsOrigin()+Vector(0,0,30))
		Timers:CreateTimer(3, function()
			ParticleManager:DestroyParticle(beamPFX, false)
			ParticleManager:ReleaseParticleIndex(beamPFX)
		end)
		ability.origChain = newTarget
	end
end

function channel_interrupt(event)
	local caster = event.caster
	StopSoundEvent("Ekkan.SuperCharge.ChannelLP", caster)
end

function supercharge_attack_land(event)
	local ability = event.ability
	local attacker = event.attacker
	local target = event.target
	local caster = event.caster
	if ability.r_1_level > 0 then
		attacker:RemoveModifierByName("modifier_supercharge_lifesteal_particle")
		caster:RemoveModifierByName("modifier_supercharge_lifesteal_particle")
		ability:ApplyDataDrivenModifier(caster, attacker, "modifier_supercharge_lifesteal_particle", {duration = 0.7})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_supercharge_lifesteal_particle", {duration = 0.7})
		local healAmount = math.max(event.attack_damage*0.005*ability.r_1_level, 1)
		local casterHeal = math.min(caster:GetMaxHealth(), healAmount)
		local creepHeal = math.min(attacker:GetMaxHealth(), healAmount)
		Filters:ApplyHeal(caster, caster, casterHeal, true)
		-- PopupHealing(caster, healAmount)	
		Filters:ApplyHeal(caster, attacker, creepHeal, true)	
		-- PopupHealing(attacker, healAmount)	
	end
end

function supercharge_enemy(caster, target, ability)
	local unitTable = {}
	local dominionAbility = caster:FindAbilityByName("ekkan_dominion")
	if caster:HasAbility("ekkan_arcana_black_dominion") then
		dominionAbility = caster:FindAbilityByName("ekkan_arcana_black_dominion")
	end
	if dominionAbility.dominionTable then
		for i = 1, #dominionAbility.dominionTable, 1 do
			if IsValidEntity(dominionAbility.dominionTable[i]) then
				table.insert(unitTable, dominionAbility.dominionTable[i])
			end
		end
	end
	local skeleAbility = caster:FindAbilityByName("ekkan_summon_skeleton")
	if skeleAbility.skeleTable then
		for i = 1, #skeleAbility.skeleTable, 1 do
			if IsValidEntity(skeleAbility.skeleTable[i]) then
				table.insert(unitTable, skeleAbility.skeleTable[i])
			end
		end
	end
	local riverAbility = caster:FindAbilityByName("ekkan_river_of_souls")
	if riverAbility.familiarTable then
		for i = 1, #riverAbility.familiarTable, 1 do
			if IsValidEntity(riverAbility.familiarTable[i]) then
				table.insert(unitTable, riverAbility.familiarTable[i])
			end
		end
	end
	local b_d_level = Runes:GetTotalRuneLevel(caster, 2, "r_2", "ekkan")
	local swarmDamage = 0
	for i = 1, #unitTable, 1 do
		local beamPFX = ParticleManager:CreateParticle("particles/roshpit/ekkan/cast_beams_beams.vpcf", PATTACH_CUSTOMORIGIN, unitTable[i])
		ParticleManager:SetParticleControl(beamPFX, 0, unitTable[i]:GetAbsOrigin())
		ParticleManager:SetParticleControl(beamPFX, 1, target:GetAbsOrigin()+Vector(0,0,30))
		Timers:CreateTimer(3, function()
			ParticleManager:DestroyParticle(beamPFX, false)
			ParticleManager:ReleaseParticleIndex(beamPFX)
		end)
		swarmDamage = swarmDamage + unitTable[i]:GetAverageTrueAttackDamage(unitTable[i])
	end
	EmitSoundOn("Ekkan.SuperCharge.VO", caster)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Ekkan.Dominion.Launch", caster)
	Timers:CreateTimer(0.2, function()
		local finalSwarmDamage = swarmDamage*0.01*b_d_level
		Filters:TakeArgumentsAndApplyDamage(target, caster, finalSwarmDamage, DAMAGE_TYPE_PURE, 4, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_DEMON)
		EmitSoundOn("Ekkan.ScourgeSwarm", target)
		CustomAbilities:QuickAttachParticle("particles/roshpit/ekkan/scourge_swarm.vpcf", target, 5)
	end)
end

function super_skeleton_think(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	local damage = caster.damage
	if not caster.interval then
		caster.interval = 0
	end
	if caster.interval <= 40 then
		local enemies = FindUnitsInRadius( hero:GetTeamNumber(), caster:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			for i = 1, caster.numTargets, 1 do
				Filters:TakeArgumentsAndApplyDamage(enemies[i], hero, damage, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_LIGHTNING)
				Events:CreateLightningBeam(caster:GetAbsOrigin()+Vector(0,0,180), enemies[i]:GetAbsOrigin()+Vector(0,0,90))
			end
			EmitSoundOn("Ekkan.SuperchargeSkeleton.Beam", caster)
		end 
	end
	caster.interval = caster.interval + 1
	if caster.interval == 40 then
		caster:ForceKill(false)
	end
end

function super_skeleton_start(event)
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_super_skeleton_idle", {duration = 8.2})
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Ekkan.Dominion.Launch", caster)
end

function super_skeleton_idle_end(event)
	local caster = event.caster
	StartAnimation(caster, {duration=10, activity=ACT_DOTA_DIE, rate=1.0})
end