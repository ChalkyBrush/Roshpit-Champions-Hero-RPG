function rune_q_1_strike(event)
	local ability = event.ability
	local target = event.target
	local attacker = event.attacker
	local totalLevel = ability:GetLevel() + Runes:GetTotalBonus(attacker.runeUnit, "q_1")
	local particleName = "particles/units/heroes/hero_shadowshaman/paladin_rune_q_1.vpcf"
	local radius = 25 + totalLevel*25
	if radius > 700 then
		radius = 700
	end
	local damage = 40*totalLevel

	local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, attacker)
	ParticleManager:SetParticleControl(lightningBolt,0,Vector(attacker:GetAbsOrigin().x,attacker:GetAbsOrigin().y,attacker:GetAbsOrigin().z + attacker:GetBoundingMaxs().z ))	
	ParticleManager:SetParticleControl(lightningBolt,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
	ApplyDamage({ victim = target, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
	-- EmitSoundOn("Hero_Chen.HandOfGodHealCreep", target)

	local enemies = FindUnitsInRadius( attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	local targets_shocked = 1 --Is targets=extra targets or total?
	for _,unit in pairs(enemies) do
			if unit ~= target then
				-- Particle
				local origin = unit:GetAbsOrigin()
				local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, attacker)
				ParticleManager:SetParticleControl(lightningBolt,0,Vector(attacker:GetAbsOrigin().x,attacker:GetAbsOrigin().y,attacker:GetAbsOrigin().z + attacker:GetBoundingMaxs().z ))	
				ParticleManager:SetParticleControl(lightningBolt,1,Vector(origin.x,origin.y,origin.z + unit:GetBoundingMaxs().z ))
			
				-- Damage
				ApplyDamage({ victim = unit, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

				-- Increment counter
				--targets_shocked = targets_shocked + 1
			end
	end
end

function paladin_die(event)
	local caster = event.caster
	local deathLocation = caster:GetAbsOrigin()
	print("a_c_death")
	local a_c_level = Runes:GetTotalRuneLevel(caster, 1, "e_1", "paladin")
	local runeUnit = caster.runeUnit
	local runeAbility = runeUnit:FindAbilityByName("paladin_rune_e_1")
	local reviveCooldown = 120
	if caster:HasModifier("modifier_paladin_glyph_1_1") then
		reviveCooldown = 80
	end
	if a_c_level > 0 and not caster:HasModifier("modifier_paladin_rune_e_1_revive_cooldown") then	
		caster:RemoveModifierByName("modifier_paladin_rune_e_1_revivable")
		local ability = event.ability
        Timers:CreateTimer(0.5, 
        function()
			        local dashAbility = caster:FindAbilityByName("crusader_dash")
			        dashAbility:ApplyDataDrivenModifier(caster, caster, "modifier_crusader_a_c_extension", {})
			        caster:SetModifierStackCount("modifier_crusader_a_c_extension", caster, a_c_level)
        		caster.revive = true
				caster:RespawnHero(false, false)
			        Timers:CreateTimer(0.1, 
			        function()
			        -- caster:SetHealth(1000+500*a_c_level)
			        -- caster:SetMana(500+350*a_c_level)

				      local playerID = caster:GetPlayerID()
				      PlayerResource:SetCameraTarget(playerID, caster)
				      runeAbility:ApplyDataDrivenModifier(runeUnit, caster, "modifier_paladin_rune_e_1_reviving", {duration = 4})
				      runeAbility:ApplyDataDrivenModifier(runeUnit, caster, "modifier_paladin_rune_e_1_revive_cooldown", {duration = reviveCooldown})
				      Timers:CreateTimer(2,
				      function()
				        PlayerResource:SetCameraTarget(playerID, nil)
				      end)
			        caster:SetAbsOrigin(deathLocation)	
					StartAnimation(caster, {duration=4, activity=ACT_DOTA_DISABLED, rate=0.7})
				end)
        end)
    end	
end

function rune_e_1_death(event)
	local dyingUnit = event.unit
	local deathLocation = dyingUnit:GetAbsOrigin()
	print("a_c_death")
	local a_c_level = Runes:GetTotalRuneLevel(dyingUnit, 1, "e_1", "paladin")
	if dyingUnit:HasModifier("modifier_paladin_rune_e_1_revivable") then	
		local caster = event.caster
		local ability = event.ability
		--ability.respawnTime = dyingUnit:GetRespawnTime()
        Timers:CreateTimer(0.5, 
        function()
        	
				dyingUnit:RemoveModifierByName("modifier_paladin_rune_e_1_revivable")
				dyingUnit:RespawnHero(false, false)
			        Timers:CreateTimer(0.1, 
			        function()
			        dyingUnit:SetHealth(1000+500*a_c_level)
			        dyingUnit:SetMana(500+350*a_c_level)
				      local playerID = dyingUnit:GetPlayerID()
				      PlayerResource:SetCameraTarget(playerID, dyingUnit)
				      ability:ApplyDataDrivenModifier(caster, dyingUnit, "modifier_paladin_rune_e_1_reviving", {duration = 4})
				      Timers:CreateTimer(2,
				      function()
				        PlayerResource:SetCameraTarget(playerID, nil)
				      end)
			        dyingUnit:SetAbsOrigin(deathLocation)	
					StartAnimation(dyingUnit, {duration=4, activity=ACT_DOTA_DISABLED, rate=0.7})
				end)
        end)
    end
end

function rune_e_1_reviving_end(event)
	local dyingUnit = event.target
	local caster = event.caster
	local ability = event.ability
	local cooldown = 120
	if caster:HasModifier("modifier_paladin_glyph_1_1") then
		cooldown = 80
	end
	ability:ApplyDataDrivenModifier(caster, dyingUnit, "modifier_paladin_rune_e_1_revive_cooldown", {duration = cooldown})
end

function rune_e_1_revive_cooldown_end(event)
	local unit = event.target
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, unit, "modifier_paladin_rune_e_1_revivable", {})
end

function rune_e_2_attacked(event)
	local caster = event.caster
	local ability = event.ability
	local attacker = event.attacker
	local unit = event.unit
	if not unit:HasModifier("modifier_secret_temple_refraction") and not unit:HasModifier("modifier_windsteel_effect") and not unit:HasModifier("modifier_heavens_shield") then
		if attacker:GetEntityIndex() == unit:GetEntityIndex() then
			return false
		end
		local level = ability:GetLevel()
		local bonusLevels = Runes:GetTotalBonus(unit.runeUnit2, "e_2")
		local totalLevel = level + bonusLevels
		local attack_damage = event.attack_damage
		local damage = unit:GetAverageTrueAttackDamage(unit)*2*totalLevel+100+50*totalLevel
		local origin = attacker:GetAbsOrigin()
		if not unit.retributions then
			unit.retributions = 0
		end
		Filters:TakeArgumentsAndApplyDamage(attacker, unit, damage, DAMAGE_TYPE_PHYSICAL, 0, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
		if unit.retributions < 10 then
			if attacker:GetMaxHealth()>200 then
				unit.retributions = unit.retributions + 1
				local particleName = "particles/items_fx/chain_lightning.vpcf"
				local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, unit)
				ParticleManager:SetParticleControl(lightningBolt,0,Vector(unit:GetAbsOrigin().x,unit:GetAbsOrigin().y,unit:GetAbsOrigin().z + 100 ))	
				ParticleManager:SetParticleControl(lightningBolt,1,Vector(origin.x,origin.y,origin.z + attacker:GetBoundingMaxs().z ))
				Timers:CreateTimer(1, function()
					ParticleManager:DestroyParticle(lightningBolt, false)
				end)
				Timers:CreateTimer(0.1, function()
					unit.retributions = unit.retributions - 1
				end)
			end
		end
	end
end
