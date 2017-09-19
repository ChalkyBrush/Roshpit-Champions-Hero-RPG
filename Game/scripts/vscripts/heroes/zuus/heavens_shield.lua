function heavens_shield_cast(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local shieldStacks = event.stacks
	local b_a_level = Runes:GetTotalRuneLevelGeneric(caster, 2, 0)
	ability.b_a_level = b_a_level
	local duration = 9
	duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_heavens_shield", {duration = duration})
	if b_a_level > 0 then
		local procs = Runes:Procs(b_a_level, 15, 1)
		shieldStacks = shieldStacks + procs
	end
	target:SetModifierStackCount( "modifier_heavens_shield", ability, shieldStacks)
	target.heavensShieldSource = ability

	ability.a_a_level = Runes:GetTotalRuneLevelGeneric(caster, 1, 0)

	local particleName = "particles/units/heroes/hero_oracle/white_mage_healheal_core.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	Timers:CreateTimer(0.5, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	end) 
	if ability:GetAbilityName() == "heavens_shield" then
		Filters:CastSkillArguments(1, caster)
		immortal_weapon_3_effect(caster, ability)
	end

	if ability:GetAbilityName() == "heavens_shield" then
		local d_a_level = Runes:GetTotalRuneLevel(caster, 4, "d_a", "auriun")
		if d_a_level > 0 then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_auriun_rune_d_a_effect", {duration = duration})
			target:SetModifierStackCount( "modifier_auriun_rune_d_a_effect", ability, d_a_level)
			target.auriun_d_a_ability = ability
			
		end
	end
	if caster:HasModifier("modifier_auriun_glyph_6_1") then
		-- local glyph_duration = Filters:GetAdjustedBuffDuration(caster, 1.2, false)
		local glyph_duration = 2.0
		ability:ApplyDataDrivenModifier(caster, target, "modifier_auriun_glyph_6_1_effect", {duration = glyph_duration})
	end
	if caster:HasModifier("modifier_auriun_glyph_3_1") then
		local modifiers = target:FindAllModifiers()
		for j = 1, #modifiers, 1 do
			local modifier = modifiers[j]
			local modifierMaker = modifier:GetCaster()
			if modifierMaker.regularEnemy then
				target:RemoveModifierByName(modifier:GetName())
				break
			end
		end	
	end
end

function immortal_weapon_3_effect(caster, ability)
	if caster:HasModifier("modifier_auriun_immortal_weapon_2_insight") then
		local newStacks = caster:GetModifierStackCount("modifier_auriun_immortal_weapon_2_insight", caster.InventoryUnit) - 1
		if newStacks > 0 then
			caster:SetModifierStackCount("modifier_auriun_immortal_weapon_2_insight", caster.InventoryUnit, newStacks)
		else
			caster:RemoveModifierByName("modifier_auriun_immortal_weapon_2_insight")
		end
		ability:EndCooldown()
	end
end

function heavens_shield_take_damage(event)
	local caster = event.caster
	local damage = event.damage
	local target = event.unit
	local ability = event.ability
	if ability.a_a_level > 0 then
		local returnDamage = target:GetAverageTrueAttackDamage(target)*(1+0.15*ability.a_a_level)
		local victim = event.attacker
		Filters:TakeArgumentsAndApplyDamage(victim, caster, returnDamage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
		EmitSoundOn("Auriun.ShieldHit", target)
		local particleName = "particles/econ/items/antimage/antimage_weapon_basher_ti5/auriun_a_a.vpcf"
		local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, victim )
		ParticleManager:SetParticleControlEnt(pfx, 0, victim, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", victim:GetAbsOrigin(), true)
		Timers:CreateTimer(0.5, function() 
		  ParticleManager:DestroyParticle( pfx, false )
		end) 
		
	end
end

function heavens_shield_end(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	if ability:GetAbilityName() == "heavens_shield" then
		local c_a_level = Runes:GetTotalRuneLevel(caster, 3, "c_a", "auriun")
		if c_a_level > 0 then
			local secondWindDuration = 10
			secondWindDuration = Filters:GetAdjustedBuffDuration(caster, secondWindDuration, false)
			ability:ApplyDataDrivenModifier(caster, target, "modifier_auriun_rune_c_a_effect", {duration = secondWindDuration})
			target:SetModifierStackCount( "modifier_auriun_rune_c_a_effect", ability, c_a_level)
			ability.c_a_level = c_a_level
			ability:ApplyDataDrivenModifier(caster, target, "modifier_auriun_rune_c_a_thinker", {duration = secondWindDuration})
			ability:ApplyDataDrivenModifier(caster, target, "modifier_auriun_c_a_attack_power", {duration = secondWindDuration})
		end
	end
end

function rune_c_a_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	if IsValidEntity(ability) then
		local armor = target:GetPhysicalArmorValue()
		local attackPowerStacks = 0.4*ability.c_a_level*armor
		if attackPowerStacks + target:GetAttackDamage() - target:GetModifierStackCount("modifier_auriun_c_a_attack_power", caster) > 2^31 then
			attackPowerStacks = 2^31 - target:GetAttackDamage()
		end
		target:SetModifierStackCount("modifier_auriun_c_a_attack_power", caster, attackPowerStacks)
	end
end

function heavens_shield_think(event)
	-- local caster = event.caster
	-- local target = event.target
	-- if caster:HasModifier("modifier_auriun_glyph_3_1") then
	-- 	if target:IsStunned() then
	-- 		Filters:RemoveStuns(target)
	-- 		local newStacks = target:GetModifierStackCount("modifier_heavens_shield", caster) - 3
	-- 		if newStacks > 0 then
	-- 			EmitSoundOn("Auriun.GlyphedShieldBreak", target)
	-- 			target:SetModifierStackCount("modifier_heavens_shield", caster, newStacks)
	-- 		else
	-- 			target:RemoveModifierByName("modifier_heavens_shield")
	-- 			EmitSoundOn("Auriun.GlyphedShieldBreak", target)
	-- 		end
	-- 	end
	-- end
end