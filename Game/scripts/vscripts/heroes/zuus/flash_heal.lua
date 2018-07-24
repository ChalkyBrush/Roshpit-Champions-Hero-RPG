function initialize_flash_heal(event)
	local caster = event.caster
	local player = caster:GetPlayerOwner()
	local ability = event.ability
	-- CustomGameEventManager:Send_ServerToPlayer(player, "flash_heal", {auriun = caster:GetEntityIndex()} )
	EmitSoundOn("Hero_Zuus.Attack", caster)
	local particleName = "particles/units/heroes/hero_oracle/holy_heal_heal_core.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)

	Timers:CreateTimer(0.5, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	end) 
	--SHIELD SOUND: "Auriun.HeavensShield"
	--RUNE 1: SHADOW BOMB. MAKE SMALL AOE AT CURSOR POSITION
	--"Auriun.ShadowFlare"
	ability.a_b_level = Runes:GetTotalRuneLevel(caster, 1, "a_b", "auriun")
	ability.b_b_level = Runes:GetTotalRuneLevel(caster, 2, "b_b", "auriun")
	ability.d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "auriun")
	ability.d_b_ability = caster.runeUnit4:FindAbilityByName("auriun_rune_d_b")
end

function cast_flash_heal(event)
	local caster = event.caster
	local cursorPos = event.target_points[1]
	local ability = event.ability
	--SHIELD SOUND: "Auriun.HeavensShield"
	--RUNE 1: SHADOW BOMB. MAKE SMALL AOE AT CURSOR POSITION
	--"Auriun.ShadowFlare"
	ability.a_b_level = Runes:GetTotalRuneLevel(caster, 1, "a_b", "auriun")
	ability.b_b_level = Runes:GetTotalRuneLevel(caster, 2, "b_b", "auriun")
	ability.d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "auriun")
	ability.d_b_ability = caster.runeUnit4:FindAbilityByName("auriun_rune_d_b")

	if ability.casted == true or ability.casted == nil then
		ability.casted = false
		EmitSoundOn("Hero_Zuus.Attack", caster)
		local particleName = "particles/units/heroes/hero_oracle/holy_heal_heal_core.vpcf"
		local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)

		Timers:CreateTimer(0.5, function() 
		  ParticleManager:DestroyParticle( pfx, false )
		end) 
		local cursorPos = event.target_points[1]
		local allies = FindUnitsInRadius( caster:GetTeamNumber(), cursorPos, nil, 140, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		local healAmount = ability:GetSpecialValueFor("heal")
		healAmount = b_b_amp(healAmount, caster, ability)
		local distance = WallPhysics:GetDistance(caster:GetAbsOrigin(), cursorPos)
		if not ability.lastCast then
			ability.lastCast = -1
		end
		local bSound = true
		if ability.lastCast > GameRules:GetGameTime()-0.8 then
			bSound = false
		end
		if bSound then
			ability.lastCast = GameRules:GetGameTime()
		end
		local max_distance = Filters:GetAdjustedRange(caster, ability:GetSpecialValueFor("max_distance"))
		if #allies > 0 and distance <= max_distance then
			for _,ally in pairs(allies) do
				Filters:ApplyHeal(caster, ally, healAmount, true)
				flash_heal_particle(caster, ally)	
				c_b_effect(caster, ability, ally, healAmount)
			end
			if bSound then
				EmitSoundOnLocationWithCaster(cursorPos, "Grizzly.AllyHeal", caster)
			end
		else
			if ability.a_b_level > 0 and distance <= max_distance then
		      particleName = "particles/units/heroes/hero_nevermore/shadow_flare.vpcf"
		      local shadowFlarePos = GetGroundPosition(cursorPos, caster)
		      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_WORLDORIGIN, caster )
		      ParticleManager:SetParticleControl( particle1, 0, shadowFlarePos )
		      Timers:CreateTimer(2, 
		      function()
		        ParticleManager:DestroyParticle( particle1, false )
		        ParticleManager:ReleaseParticleIndex(particle1)
		      end)
				if bSound then	
					EmitSoundOnLocationWithCaster(cursorPos, "Auriun.ShadowFlare", caster)
				end
				local enemies = FindUnitsInRadius( caster:GetTeamNumber(), cursorPos, nil, 240, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
				local damage = ability.a_b_level*1920 + 400
				damage = b_b_amp(damage, caster, ability)
				for _,enemy in pairs(enemies) do
					Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_SHADOW, RPC_ELEMENT_NONE)
					d_b_apply(caster, enemy, ability.d_b_level, ability.d_b_ability)
				end			
			else
				Filters:ApplyHeal(caster, caster, healAmount, true)
				flash_heal_particle(caster, caster)
				c_b_effect(caster, ability, caster, healAmount)
				if bSound then	
					EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Grizzly.AllyHeal", caster)
				end
			end
		end 	
		Filters:CastSkillArguments(2, caster)
	end
end

function cast_flash_heal(event)
	local ability = event.ability
	local allies = FindUnitsInRadius( caster:GetTeamNumber(), cursorPos, nil, 140, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	local healAmount = event.heal
	healAmount = b_b_amp(healAmount, caster, ability)
	local distance = WallPhysics:GetDistance(caster:GetAbsOrigin(), cursorPos)
	if not ability.lastCast then
		ability.lastCast = -1
	end
	local bSound = true
	if ability.lastCast > GameRules:GetGameTime()-0.8 then
		bSound = false
	end
	if bSound then
		ability.lastCast = GameRules:GetGameTime()
	end
	print(distance)
	local max_distance = Filters:GetAdjustedRange(caster, event.max_distance)
	if #allies > 0 and distance <= max_distance then
		for _,ally in pairs(allies) do
			Filters:ApplyHeal(caster, ally, healAmount, true)
			flash_heal_particle(caster, ally)	
			c_b_effect(caster, ability, ally, healAmount)
		end
		if bSound then
			EmitSoundOnLocationWithCaster(cursorPos, "Grizzly.AllyHeal", caster)
		end
	else
		if ability.a_b_level > 0 and distance <= max_distance then
	      particleName = "particles/units/heroes/hero_nevermore/shadow_flare.vpcf"
	      local shadowFlarePos = GetGroundPosition(cursorPos, caster)
	      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_WORLDORIGIN, caster )
	      ParticleManager:SetParticleControl( particle1, 0, shadowFlarePos )
	      Timers:CreateTimer(2, 
	      function()
	        ParticleManager:DestroyParticle( particle1, false )
	        ParticleManager:ReleaseParticleIndex(particle1)
	      end)
			if bSound then	
				EmitSoundOnLocationWithCaster(cursorPos, "Auriun.ShadowFlare", caster)
			end
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), cursorPos, nil, 240, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			local damage = ability.a_b_level*1920 + 400
			damage = b_b_amp(damage, caster, ability)
			for _,enemy in pairs(enemies) do
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_SHADOW, RPC_ELEMENT_NONE)
				d_b_apply(caster, enemy, ability.d_b_level, ability.d_b_ability)
			end			
		else
			Filters:ApplyHeal(caster, caster, healAmount, true)
			flash_heal_particle(caster, caster)
			c_b_effect(caster, ability, caster, healAmount)
			if bSound then	
				EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Grizzly.AllyHeal", caster)
			end
		end
	end 	
	Filters:CastSkillArguments(2, caster)
end

function d_b_apply(caster, enemy, d_b_level, d_b_ability)
	if d_b_level > 0 then
	    d_b_ability:ApplyDataDrivenModifier(caster.runeUnit4, enemy, "modifier_auriun_rune_d_b_effect_visible", {duration = 7})
	    local current_stacks = enemy:GetModifierStackCount( "modifier_auriun_rune_d_b_effect_visible", d_b_ability )
	    local new_stacks = math.min(current_stacks + 1, 5)
	    enemy:SetModifierStackCount( "modifier_auriun_rune_d_b_effect_visible", d_b_ability, new_stacks )

	    d_b_ability:ApplyDataDrivenModifier(caster.runeUnit4, enemy, "modifier_auriun_rune_d_b_effect_invisible", {duration = 7})
	    enemy:SetModifierStackCount( "modifier_auriun_rune_d_b_effect_invisible", d_b_ability, new_stacks*d_b_level )
	end
	--"modifier_auriun_rune_d_b_effect_visible"
end

function b_b_amp(amount, caster, ability)
	local ampPerTenInt = 0.0006
	local adjustment = (caster:GetIntellect()/10)*ampPerTenInt*ability.b_b_level
	local adjustedAmount = amount*(1+adjustment)
	return math.ceil(adjustedAmount)
end

function c_b_effect(caster, ability, target, healAmount)
	local runeUnit = caster.runeUnit3
	local runeAbility = runeUnit:FindAbilityByName("auriun_rune_c_b")
	local c_b_level = Runes:GetTotalRuneLevel(caster, 3, "c_b", "auriun")
	if c_b_level > 0 then 
		ability.auriun_c_b_heal = c_b_level*0.005*healAmount
		local duration = Filters:GetAdjustedBuffDuration(caster, 3, false)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_auriun_c_b_heal", {duration = duration})
	end
	-- local manaSpent = ability:GetManaCost(ability:GetLevel())
	-- if caster:HasModifier("modifier_cerulean_high_guard") then
	-- 	manaSpent = manaSpent + ability:GetManaCost(ability:GetLevel())*4
	-- end
	-- if caster:HasModifier("modifier_iron_colossus") then
	-- 	manaSpent = manaSpent + 2000
	-- end
	-- local c_b_percentage = 0.02
	-- local damageBuff = manaSpent*c_b_percentage*c_b_level

	-- local currentStacks = target:GetModifierStackCount( "modifier_auriun_rune_c_b_visible", ability )
	-- currentStacks = math.min(currentStacks+1, 5)

	-- local c_b_duration = Filters:GetAdjustedBuffDuration(caster, 7, false)
	-- runeAbility:ApplyDataDrivenModifier(runeUnit, target, "modifier_auriun_rune_c_b_visible", {duration = c_b_duration})
	-- runeAbility:ApplyDataDrivenModifier(runeUnit, target, "modifier_auriun_rune_c_b_effect", {duration = c_b_duration})

	-- target:SetModifierStackCount( "modifier_auriun_rune_c_b_visible", runeAbility, currentStacks)
	-- target:SetModifierStackCount( "modifier_auriun_rune_c_b_effect", runeAbility, math.floor(currentStacks*damageBuff))

	--"modifier_auriun_rune_c_b_visible"
	--"modifier_auriun_rune_c_b_effect"
end

function c_b_heal_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local healAmount = ability.auriun_c_b_heal
	Filters:ApplyHeal(caster, target, healAmount, true)
end

function flash_heal_particle(caster,target)
	local particleName = "particles/units/heroes/hero_oracle/flash_healheal.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	Timers:CreateTimer(0.7, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	end) 

	
end