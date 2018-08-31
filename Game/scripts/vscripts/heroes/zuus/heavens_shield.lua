function heavens_shield_cast(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local shieldStacks = event.stacks
	local q_2_level = Runes:GetTotalRuneLevelGeneric(caster, 2, 0)
	ability.q_2_level = q_2_level
	local duration = 9
	duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_heavens_shield", {duration = duration})
	if q_2_level > 0 then
		local procs = Runes:Procs(q_2_level, 8, 1)
		shieldStacks = shieldStacks + procs
	end
	target:SetModifierStackCount( "modifier_heavens_shield", ability, shieldStacks)
	target.heavensShieldSource = ability

	ability.q_1_level = Runes:GetTotalRuneLevelGeneric(caster, 1, 0)

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
		local q_4_level = Runes:GetTotalRuneLevel(caster, 4, "q_4", "auriun")
		if q_4_level > 0 then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_auriun_rune_q_4_effect", {duration = duration})
			target:SetModifierStackCount( "modifier_auriun_rune_q_4_effect", ability, q_4_level)
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
			if not WallPhysics:DoesTableHaveValue(Filters:GetUnpurgableDebuffNames(), modifier:GetName()) then
				if modifierMaker.regularEnemy then
					target:RemoveModifierByName(modifier:GetName())
					break
				end
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
	if ability.q_1_level > 0 then
		if event.attacker:GetEntityIndex() == target:GetEntityIndex() then
			return false
		end
		local returnDamage = target:GetAverageTrueAttackDamage(target)*(1+0.15*ability.q_1_level)
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
		local q_3_level = Runes:GetTotalRuneLevel(caster, 3, "q_3", "auriun")
		if q_3_level > 0 then
			local secondWindDuration = 10
			secondWindDuration = Filters:GetAdjustedBuffDuration(caster, secondWindDuration, false)
			ability:ApplyDataDrivenModifier(caster, target, "modifier_auriun_rune_q_3_effect", {duration = secondWindDuration})
			target:SetModifierStackCount( "modifier_auriun_rune_q_3_effect", ability, q_3_level)
			ability.q_3_level = q_3_level
			ability:ApplyDataDrivenModifier(caster, target, "modifier_auriun_rune_q_3_thinker", {duration = secondWindDuration})
			ability:ApplyDataDrivenModifier(caster, target, "modifier_auriun_c_a_attack_power", {duration = secondWindDuration})
		end
	end
end

function rune_q_3_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	if IsValidEntity(ability) then
		local armor = target:GetPhysicalArmorValue()
		local attackPowerStacks = 0.4*ability.q_3_level*armor
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