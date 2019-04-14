require('/heroes/huskar/constants_spirit_warrior')

function start_channel(event)
	local caster = event.caster
	local soundTable = {"SpiritWarrior.SpiritYell1", "SpiritWarrior.SpiritYell2", "SpiritWarrior.SpiritYell3"}
	EmitSoundOn(soundTable[RandomInt(1,3)], caster)
	caster.e_4_level = Runes:GetTotalRuneLevel(caster, 4, "e_4", "spirit_warrior")
	caster.q_4_level = Runes:GetTotalRuneLevel(caster, 4, "q_4", "spirit_warrior")
	StartSoundEvent("SpiritWarrior.AncientVigorChannel", caster)
end

function channel_interrupt(event)
	local caster = event.caster
	StopSoundEvent("SpiritWarrior.AncientVigorChannel", caster)
end

function vigor_start(event)
	local caster = event.caster
	local ability = event.ability
	local duration = event.duration
	if caster:HasModifier("modifier_spirit_warrior_glyph_7_1") then
		duration = duration + spirit_warrior_glyph_7_1_additional_duration
	end
	duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
	Timers:CreateTimer(0.5, function()
		StopSoundEvent("SpiritWarrior.AncientVigorChannel", caster)
	end)
	Filters:CastSkillArguments(4, caster)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_ancient_vigor", {duration = duration})
	-- local a_d_level = Runes:GetTotalRuneLevel(caster, 1, "r_1", "spirit_warrior")
	-- if a_d_level > 0 then
	-- 	ability:ApplyDataDrivenModifier(caster, caster, "modifier_ancient_vigor_regen", {duration = duration})
	-- 	caster:SetModifierStackCount("modifier_ancient_vigor_regen", caster, a_d_level)
	-- end
	local b_d_level = Runes:GetTotalRuneLevel(caster, 2, "r_2", "spirit_warrior")
	if b_d_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_ancient_vigor_attack_percent", {duration = duration})
		caster:SetModifierStackCount("modifier_ancient_vigor_attack_percent", caster, b_d_level)
	end
	local c_d_level = Runes:GetTotalRuneLevel(caster, 3, "r_3", "spirit_warrior")
	if c_d_level > 0 then
		local d_d_level = Runes:GetTotalRuneLevel(caster, 4, "r_4", "spirit_warrior")
		local spiritAbility = caster:FindAbilityByName("spirit_warrior_ancient_spirit")
		if not spiritAbility then
			spiritAbility = caster:FindAbilityByName("spirit_warrior_ancient_spirit_elite")
		end
		if spiritAbility then
			local spiritTable = spiritAbility.spiritTable
			if spiritTable then
				for i = 1, #spiritTable, 1 do
					spiritTable[i]:RemoveModifierByName("modifier_ancient_spirit_disarm")
					spiritAbility:ApplyDataDrivenModifier(caster, spiritTable[i], "modifier_spirit_attacking", {duration = duration})
					spiritTable[i].r_3_level = c_d_level
					if d_d_level > 0 then
						ability:ApplyDataDrivenModifier(caster, spiritTable[i], "modifier_ancient_spirit_attackspeed", {duration = duration})
						spiritTable[i]:SetModifierStackCount("modifier_ancient_spirit_attackspeed", caster, d_d_level)
					end
				end
			end
		end
	end
	EmitSoundOn("SpiritWarrior.AncientVigorStart", caster)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "SpiritWarrior.AncientVigorYell", caster)
	Timers:CreateTimer(0.1, function()
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "SpiritWarrior.AncientVigorStart2", caster)
	end)
	StartAnimation(caster, {duration=1, activity=ACT_DOTA_TELEPORT_END, rate=1})
end

function vigor_passive_think(event)
	local caster = event.caster
	local ability = event.ability
	ability.r_1_level = Runes:GetTotalRuneLevel(caster, 1, "r_1", "spirit_warrior")
end

function vigor_deal_damage(event)
	local caster = event.caster
	local ability = event.ability
	if ability.r_1_level > 0 then
		local damage = event.damage
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 2, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		-- "particles/units/heroes/hero_legion_commander/legion_commander_courage_hit.vpcf"
		Timers:CreateTimer(0.5, function() 
		  ParticleManager:DestroyParticle( pfx, false )
		end)
		if not ability.trollBloodHeal then
			ability.trollBloodHeal = 0
		end
		local trollBloodDuration = Filters:GetAdjustedBuffDuration(caster, 5, false)
		ability.trollBloodDuration = trollBloodDuration*10
		ability.trollBloodHeal = ability.trollBloodHeal + damage*0.003*ability.r_1_level
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_ancient_vigor_troll_blood", {duration = trollBloodDuration})

	end
end

function troll_blood_start(event)
	local caster = event.caster
	local ability = event.ability
	if not ability.trollBloodDuration then
		ability.trollBloodDuration = 50
	end
	local particleName = "particles/econ/generic/generic_buff_1/charge_of_light_effect_buff.vpcf"
	ability.trollBloodPFX = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(ability.trollBloodPFX, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	local weight = 0.1
	ParticleManager:SetParticleControl(ability.trollBloodPFX, 14, Vector(1, 1*weight, weight))
	ParticleManager:SetParticleControl(ability.trollBloodPFX, 15, Vector(129, 201, 165))
end

function troll_blood_think(event)
	local caster = event.caster
	local ability = event.ability
	local weight = math.min(ability.trollBloodHeal/caster:GetMaxHealth(), 1)
	ParticleManager:SetParticleControl(ability.trollBloodPFX, 14, Vector(1, 1*weight, weight))
	local divisor = math.max(ability.trollBloodDuration + 1, 1)
	local healAmount = math.min(math.ceil(ability.trollBloodHeal/divisor), caster:GetMaxHealth())
	ability.trollBloodHeal = ability.trollBloodHeal - healAmount
	ability.trollBloodDuration = ability.trollBloodDuration - 1
	healAmount = math.ceil(healAmount + 1)
	Filters:ApplyHeal(caster, caster, healAmount, true)
end

function troll_blood_end(event)
	local caster = event.caster
	local ability = event.ability
	ParticleManager:DestroyParticle(ability.trollBloodPFX, false)
end