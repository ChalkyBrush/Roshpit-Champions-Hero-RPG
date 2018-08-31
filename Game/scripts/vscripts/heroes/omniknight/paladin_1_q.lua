require('heroes/omniknight/paladin_2_w')

function paladin_q_cast(event)
	local caster = event.caster
	local ability = event.ability
	Filters:CastSkillArguments(1, caster)
	local duration = event.duration
	local q_2_level = caster:GetRuneValue("q", 2)
	ability.q_2_level = q_2_level
	caster.w_4_level = caster:GetRuneValue("w", 4)
	if q_2_level > 0 then
		duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_paladin_q_2_radiance", {duration = duration})
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_heroic_fury", {duration = duration})
	if caster:HasModifier("modifier_paladin_immortal_weapon_1") then
		local coneAbility = caster:FindAbilityByName("justice_overwhelming")
		if caster:HasAbility("paladin_penance") then
			coneAbility = caster:FindAbilityByName("paladin_penance")
		end
		local immortalDuration = Filters:GetAdjustedBuffDuration(caster, 8, false)
		coneAbility:ApplyDataDrivenModifier(caster, caster, "modifier_paladin_rune_q_3_shield", {duration = immortalDuration})
		caster:SetModifierStackCount("modifier_paladin_rune_q_3_shield", caster, 4)
	end
end

function paladin_q_2_think(event)
	local caster = event.caster
	local ability = event.ability
	local tickDamage = caster:GetAverageTrueAttackDamage(caster)*0.8*ability.q_2_level/2
	local radius = 900
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			CustomAbilities:QuickAttachParticle("particles/items2_fx/radiance.vpcf", enemy, 1)
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, tickDamage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
		end
	end 
end

function paladin_q_attack( event )
    local caster = event.caster
    local ability = event.ability
    local targetUnit = event.target
    
    local origin = targetUnit:GetAbsOrigin()
    local radius = event.radius
    local damage = event.damage

    local q_1_level = caster:GetRuneValue("q", 1)
    damage = damage + caster:GetAverageTrueAttackDamage(caster) * q_1_level * PALADIN_Q1_AD_TO_DMG_PCT / 100

    local heal_percent = event.heal_percent/100

    if not ability.zapParticleCount then
    	ability.zapParticleCount = 0
    end
    if ability.zapParticleCount < 15 then
    	ability.zapParticleCount = ability.zapParticleCount + 1
		local dagon_particle = ParticleManager:CreateParticle("particles/econ/events/ti5/dagon_lvl2_ti5.vpcf",  PATTACH_POINT_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(dagon_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(dagon_particle, 1, targetUnit, PATTACH_POINT_FOLLOW, "attach_hitloc", targetUnit:GetAbsOrigin(), false)
		local particle_effect_intensity = 300 + (60 * ability:GetLevel())  --Control Point 2 in Dagon's particle effect takes a number between 400 and 800, depending on its level.
		ParticleManager:SetParticleControl(dagon_particle, 2, Vector(particle_effect_intensity))
		Timers:CreateTimer(2.0, function()
			ParticleManager:DestroyParticle(dagon_particle, false)
			ParticleManager:ReleaseParticleIndex(dagon_particle)
			ability.zapParticleCount = ability.zapParticleCount - 1
		end)
	end
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), origin, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false )

	amount = math.floor(caster:GetMaxHealth()*heal_percent)
	Filters:ApplyHeal(caster, caster, amount, true)

	
	if #enemies > 0 then
		caster.holyCone = caster:FindAbilityByName("justice_overwhelming")
		if caster:HasModifier("modifier_paladin_glyph_2_1") and caster.holyCone then
			caster.holyCone.w_1_level = paladin_get_w_1_level(caster,caster.holyCone)
			if caster.holyCone.w_1_level > 0 then
				applyFire = true
			else
				applyFire = false
			end
		else 
			applyFire = false
		end
		if not ability.goldParticleCount then
			ability.goldParticleCount = 0
		end
		for _,enemy in pairs(enemies) do
			if ability.goldParticleCount < 20 then
				ability.goldParticleCount = ability.goldParticleCount + 1
				CustomAbilities:QuickAttachParticle("particles/econ/items/effigies/status_fx_effigies/base_statue_destruction_gold_lvl2_a.vpcf", enemy, 1)
				Timers:CreateTimer(1.2, function()
					ability.goldParticleCount = ability.goldParticleCount - 1
				end)
			end
			if not targetUnit:HasModifier("modifier_holy_struck") then
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_heroic_fury_slow", {duration = 4})
				enemy:AddNewModifier( enemy, nil, "modifier_knockback", modifierKnockback )
			end
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_HOLY, RPC_ELEMENT_NORMAL)
			if applyFire then
				paladin_w_1_apply(caster, enemy, caster.holyCone)
			end
		end
	end 
end

function paladin_q_3_attack(event)
	local attacker = event.attacker
	local caster = attacker
	local ability = event.ability
	local q_3_level = caster:GetRuneValue("q", 3)
	if q_3_level > 0 then
		local duration = q_3_level*0.1 + 0.8		
		duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
		local currentStacks = caster:GetModifierStackCount("modifier_paladin_rune_q_3_shield", caster)
		local maxStacks = 1
		if caster:HasModifier("modifier_paladin_immortal_weapon_1") then
			maxStacks = 4
		end
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_paladin_rune_q_3_shield", {duration = duration})
		local newStacks = math.min(currentStacks+1, maxStacks)
		caster:SetModifierStackCount("modifier_paladin_rune_q_3_shield", caster, newStacks)
	end
end