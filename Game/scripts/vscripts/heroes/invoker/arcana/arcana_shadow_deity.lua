require('heroes/invoker/aspects')

function shadow_deity(event)
	local caster = event.caster
	local ability = event.ability
	local summonPosition = caster:GetAbsOrigin() + caster:GetForwardVector()*340
	caster.shadowAspect = CreateUnitByName("shadow_deity", summonPosition, true, caster, caster, caster:GetTeamNumber())
	ability:ApplyDataDrivenModifier(caster, caster.shadowAspect, "modifier_aspect_invulnerable", {duration = 1})
	caster.shadowAspect.conjuror = caster
	caster.shadowAspect.owner = caster:GetPlayerOwnerID()
	caster.shadowAspect:SetOwner(caster)
    caster.shadowAspect:SetControllableByPlayer(caster:GetPlayerID(), true)
    caster.shadowAspect.aspect = true
	local aspectAbility = caster.shadowAspect:FindAbilityByName("aspect_abilities")
	aspectAbility:SetLevel(1)
	if caster.bIsAIonSHADOW == true or caster.bIsAIonSHADOW == nil then
	aspectAbility:ToggleAbility()
    end
	-- aspectAbility:ApplyDataDrivenModifier(caster.shadowAspect, caster.shadowAspect, "modifier_aspect_main", {})

    local shadowParticle = "particles/units/heroes/hero_enigma/enigma_ambient_body.vpcf"
	local pfx = ParticleManager:CreateParticle( shadowParticle, PATTACH_CUSTOMORIGIN, caster.shadowAspect )
	ParticleManager:SetParticleControl( pfx, 0, summonPosition )
	ParticleManager:SetParticleControl( pfx, 1, summonPosition )
	ParticleManager:SetParticleControl( pfx, 2, summonPosition )
	ParticleManager:SetParticleControl( pfx, 3, summonPosition )
	Timers:CreateTimer(1.5, function()
		ParticleManager:DestroyParticle( pfx, false )
	end)
	EmitSoundOn("Hero_ShadowDemon.Soul_Catcher.Cast", caster.shadowAspect)
  	if caster:HasModifier("modifier_conjuror_glyph_4_1") then
  		ability:ApplyDataDrivenModifier(caster, caster.shadowAspect, "modifier_conjuror_glyph_4_1_effect", {})
  	end
  	local shadowGate = caster:FindAbilityByName("shadow_gate")
  	if not shadowGate then
  		shadowGate = caster:AddAbility("shadow_gate")
  		shadowGate:SetAbilityIndex(2)
  	end
  	if caster:HasModifier("modifier_conjuror_immortal_weapon_3") then
  		caster.shadowAspect:AddAbility("fire_temple_steadfast"):SetLevel(1)
  	end
  	shadowGate:SetLevel(ability:GetLevel())
	caster:SwapAbilities("summon_shadow_deity", "shadow_gate", false, true)
	ability:ApplyDataDrivenModifier(caster, caster.shadowAspect, "modifier_shadow_aspect", {})
	local aspectHealth = event.aspect_health
	if caster.aspectHealthAbility then
		aspectHealth = aspectHealth + caster:GetModifierStackCount( "modifier_weapon_aspect_health", caster.aspectHealthAbility )
	end
	if caster:HasModifier("modifier_conjuror_glyph_2_1") then
		aspectHealth = aspectHealth*1.8
	end
	local q_1_level = Runes:GetTotalRuneLevel(caster, 1, "q_1", "conjuror")
	aspectHealth = aspectHealth*(1+q_1_level*0.05)
	Timers:CreateTimer(0.05, function()
		caster.shadowAspect:SetMaxHealth(aspectHealth)
		caster.shadowAspect:SetBaseMaxHealth(aspectHealth)
		caster.shadowAspect:SetHealth(aspectHealth)
		caster.shadowAspect:Heal(aspectHealth, caster.shadowAspect)
		common_aspect_effects(caster, ability, caster.shadowAspect)
	end)
	local d_c_level = caster:GetRuneValue("e", 4)
	caster.shadowAspect.e_4_level = d_c_level
	if d_c_level > 0 then
		caster.shadowAspect:SetRangedProjectileName("particles/econ/items/enigma/enigma_geodesic/conjuror_d_c_aspect_eidolon_geodesic.vpcf")
	end
	glyph_5_a(caster, ability, caster.shadowAspect)
end