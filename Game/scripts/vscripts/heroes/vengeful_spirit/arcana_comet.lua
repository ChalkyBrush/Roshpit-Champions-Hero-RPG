
function arcana_comet_phase(event)
end

function begin_arcana_comet(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	local damage = event.damage

	ability.q_2_level = q_2_level
	ability.q_3_level = Runes:GetTotalRuneLevelGeneric(caster, 3, 0)
	if ability.q_3_level > 0 then
		damage = damage + OverflowProtectedGetAverageTrueAttackDamage(caster)*0.02*ability.q_3_level
	end
	StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_CAST_ABILITY_1, rate=1.8})
	local starParticle = "particles/roshpit/solunia/comet_sun_attack.vpcf"
	local explodeParticle = "particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf"
	local castParticle = "particles/roshpit/solunia/comet_cast_sun.vpcf"
	local element2 = RPC_ELEMENT_FIRE
	local damageType = DAMAGE_TYPE_MAGICAL
	if event.sun_moon == "moon" then
		element2 = RPC_ELEMENT_ICE
		damageType = DAMAGE_TYPE_PURE
		castParticle = "particles/roshpit/solunia/comet_cast_moon.vpcf"
		explodeParticle = "particles/roshpit/solunia/lunar_flare_explosion_immortal1.vpcf"
		starParticle = "particles/roshpit/solunia/comet_moon_attack_attack.vpcf"
	end
	local cast_direction = ((target - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	local pfx = ParticleManager:CreateParticle(castParticle, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	Timers:CreateTimer(4, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:ReleaseParticleIndex(pfx)
	end)
	EmitSoundOn("Solunia.Arcana1.Cast", caster)
	EmitSoundOnLocationWithCaster(target, "Solunia.Arcana1.Comet", caster)
	CustomAbilities:QuickParticleAtPoint(starParticle, target, 4)
	Timers:CreateTimer(0.45, function()
		flareParticle(target, caster, explodeParticle)
		EmitSoundOnLocationWithCaster(target, "Solunia.SolarGlow.Impact", caster)
		flareImpact(caster, ability, damage, element2, damageType, target, event.stun_duration, event.sun_moon)
	end)
	Filters:CastSkillArguments(1, caster)
	if event.sun_moon == "sun" then
		local freeCastStacks = caster:GetModifierStackCount("modifier_solar_comet_free_cast", caster)
		local stackReduce = 1
		if caster:HasModifier("modifier_solunia_glyph_6_1_ready") then
			stackReduce = 0
			caster:RemoveModifierByName("modifier_solunia_glyph_6_1_ready")
		end
		caster:SetModifierStackCount("modifier_solar_comet_free_cast", caster, freeCastStacks - stackReduce)
		if freeCastStacks - stackReduce == 0 then
			caster:RemoveModifierByName("modifier_solar_comet_free_cast")
			ability:SetActivated(false)
		end
	else
		local freeCastStacks = caster:GetModifierStackCount("modifier_lunar_comet_free_cast", caster)
		local stackReduce = 1
		if caster:HasModifier("modifier_solunia_glyph_6_1_ready") then
			stackReduce = 0
			caster:RemoveModifierByName("modifier_solunia_glyph_6_1_ready")
		end
		caster:SetModifierStackCount("modifier_lunar_comet_free_cast", caster, freeCastStacks - stackReduce)
		if freeCastStacks - stackReduce == 0 then
			caster:RemoveModifierByName("modifier_lunar_comet_free_cast")
			ability:SetActivated(false)
		end
	end

end

function flareImpact(caster, ability, damage, element2, damageType, position, stun_duration, sun_moon)
	local damageType = DAMAGE_TYPE_MAGICAL
	if sun_moon == "moon" then
		damageType = DAMAGE_TYPE_PURE
		element2 = RPC_ELEMENT_ICE
	end
    if caster:HasModifier("modifier_solunia_glyph_3_1") then
    	stun_duration = stun_duration + 1
    end
    local adjustedBuffDuration = Filters:GetAdjustedBuffDuration(caster, 60, false)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, 260, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			if enemy:HasModifier("modifier_boomerang_magic_marker") then
				local stacks = enemy:GetModifierStackCount("modifier_boomerang_magic_marker", caster)
				damage = damage + stacks*0.2*damage
			end
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, damageType, 1, RPC_ELEMENT_COSMOS, element2)
			Filters:ApplyStun(caster, stun_duration, enemy)
			if ability.q_3_level > 0 then
				if sun_moon == "sun" then
					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_solar_compression_visible", {duration = adjustedBuffDuration})
					local newStacks = math.min(enemy:GetModifierStackCount("modifier_solar_compression_visible", caster) + 1, 10)
					enemy:SetModifierStackCount("modifier_solar_compression_visible", caster, newStacks)

					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_solar_compression_invisible", {duration = adjustedBuffDuration})
					enemy:SetModifierStackCount("modifier_solar_compression_invisible", caster, newStacks*ability.q_3_level)
				elseif sun_moon == "moon" then
					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_lunar_compression_visible", {duration = adjustedBuffDuration})
					local newStacks = math.min(enemy:GetModifierStackCount("modifier_lunar_compression_visible", caster) + 1, 10)
					enemy:SetModifierStackCount("modifier_lunar_compression_visible", caster, newStacks)

					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_lunar_compression_invisible", {duration = adjustedBuffDuration})
					enemy:SetModifierStackCount("modifier_lunar_compression_invisible", caster, newStacks*ability.q_3_level)
				end
			end
		end
	end 
end

function flareParticle(position, caster, particleName)
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, position)
	Timers:CreateTimer(4, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:ReleaseParticleIndex(pfx)
	end)
end

function deal_damage_with_arcana_equipped(event)
	local attacker = event.attacker
	local ability = event.ability
	local q_1_level = Runes:GetTotalRuneLevelGeneric(attacker, 1, 0)
	if q_1_level > 0 then
		local duration = Filters:GetAdjustedBuffDuration(attacker, 0.5, false)
		ability:ApplyDataDrivenModifier(attacker, attacker, "modifier_solunia_ultraviolet", {duration = duration})
		attacker:SetModifierStackCount("modifier_solunia_ultraviolet", attacker, q_1_level)
	end
end

function arcana_passive_think(event)
	local caster = event.caster
	local ability = event.ability
	if not ability.interval then
		ability.interval = 0
	end
	ability.interval = ability.interval + 1

	if ability.interval == 10 then
		local q_1_level = Runes:GetTotalRuneLevelGeneric(caster, 1, 0)
		if q_1_level > 0 then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_solunia_ultraviolet_damage", {duration = 5})
			caster:SetModifierStackCount("modifier_solunia_ultraviolet_damage", caster, q_1_level)
		end
	end
	if ability.interval >= 20 then
		ability.interval = 0
		ability.q_2_level = Runes:GetTotalRuneLevelGeneric(caster, 2, 0)
	end
	if not ability.q_2_level then
		ability.q_2_level = Runes:GetTotalRuneLevelGeneric(caster, 2, 0)
	end
	if ability.q_2_level > 0 then
		if not caster:HasModifier("modifier_polythea_damage") then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_polythea_damage", {})
		end
		local damageStacks = ability.q_2_level*0.05*caster:GetHealth()
		caster:SetModifierStackCount("modifier_polythea_damage", caster, damageStacks)
	else
		caster:RemoveModifierByName("modifier_polythea_damage")
	end
	
end

function apply_arcana_comet_stacks(event)
	local caster = event.caster
	local ability = event.ability
	local max_charges = event.max_charges
	if ability:GetAbilityName() == "solunia_arcana_solar_comet" then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_solar_comet_free_cast", {})
		caster:SetModifierStackCount("modifier_solar_comet_free_cast", caster, max_charges)
		caster:RemoveModifierByName("modifier_lunar_comet_free_cast")
	else
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_lunar_comet_free_cast", {})
		caster:SetModifierStackCount("modifier_lunar_comet_free_cast", caster, max_charges)
		caster:RemoveModifierByName("modifier_solar_comet_free_cast")
	end
	ability:SetActivated(true)

end