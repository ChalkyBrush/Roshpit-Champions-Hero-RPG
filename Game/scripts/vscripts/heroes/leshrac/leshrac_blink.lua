
function HideCaster( event )
    event.caster:AddNoDraw()
    event.caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
    local position = event.caster:GetAbsOrigin()
    local range = event.range
    local caster = event.caster
    local fv = event.caster:GetForwardVector()
    local ability = event.ability
    if caster:HasModifier("modifier_bahamut_immortal_weapon_2") then
    	ability:EndCooldown()
    	ability:StartCooldown(4.5)
    end
    if caster:HasModifier("modifier_bahamut_glyph_6_1") then
    	local cd = ability:GetCooldownTimeRemaining()
    	ability:EndCooldown()
    	ability:StartCooldown(cd*2)
    end
	caster.d_c_level = Runes:GetTotalRuneLevel(caster, 4, "d_c", "bahamut")
    event.caster.newPosition =  event.target_points[1]
    -- local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_undying/undying_loadout.vpcf", PATTACH_ABSORIGIN, event.caster )
    --     ParticleManager:SetParticleControl( pfx, 0, position )
    local newPosition = WallPhysics:WallSearch(position, event.caster.newPosition, caster)
    AddFOWViewer(caster:GetTeamNumber(), newPosition, 250, 1.8, false)
    Filters:CastSkillArguments(3, event.caster)


	local particle = "particles/econ/items/sven/sven_cyclopean_marauder/leshrac_grow_effect.vpcf"
	local pfx = ParticleManager:CreateParticle( particle, PATTACH_CUSTOMORIGIN, event.caster)
	ParticleManager:SetParticleControlEnt( pfx, 0, event.caster, PATTACH_POINT_FOLLOW, "attach_origin", event.caster:GetAbsOrigin(), true )
	local pfxRune = ParticleManager:CreateParticle("particles/items_fx/leshrac_blink.vpcf", PATTACH_POINT_FOLLOW, event.caster)
	ParticleManager:SetParticleControlEnt( pfxRune, 0, event.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", event.caster:GetAbsOrigin(), true )
	Timers:CreateTimer(3.4, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:DestroyParticle(pfxRune, false)
	end)	

	-- local particle = "particles/econ/items/sven/sven_cyclopean_marauder/leshrac_grow_effect.vpcf"
	-- local pfx = ParticleManager:CreateParticle( particle, PATTACH_CUSTOMORIGIN, caster )
	-- caster:SetAbsOrigin(caster:GetAbsOrigin() -Vector(0,0,140) )
	-- ParticleManager:SetParticleControlEnt( pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
	-- Timers:CreateTimer(1.5, function()
	-- 	ParticleManager:DestroyParticle(pfx, false)
	-- end)

	local dummy = CreateUnitByName("npc_dummy_unit", newPosition, false, nil, nil, DOTA_TEAM_NEUTRALS)
	dummy:AddAbility("dummy_unit"):SetLevel(1)
	dummy:NoHealthBar()
	dummy:SetForwardVector(fv)
	local particle = "particles/econ/items/sven/sven_cyclopean_marauder/leshrac_shrink_effect.vpcf"
	local pfx2 = ParticleManager:CreateParticle( particle, PATTACH_CUSTOMORIGIN, dummy )
	ParticleManager:SetParticleControlEnt( pfx2, 0, dummy, PATTACH_POINT_FOLLOW, "attach_hitloc", newPosition, true )
	Timers:CreateTimer(1.5, function()
		ParticleManager:DestroyParticle(pfx2, false)
		UTIL_Remove(dummy)
	end)	
	EmitSoundOn("leshrac_lesh_pain_05", caster)

	Timers:CreateTimer(1.4, function()
		FindClearSpaceForUnit(event.caster, newPosition, false)
	end)
	Timers:CreateTimer(0.25, function()
		EmitSoundOn("Hero_Terrorblade.Reflection", caster)
	end)
	-- StartAnimation(caster, {duration=2, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.9})
	ability.b_c_level = Runes:GetTotalRuneLevel(caster, 2, "b_c", "bahamut")
	if ability.b_c_level > 0 then
		ability.b_c_damage = ability.b_c_level*4200 + 6000
		ability.b_c_duration = ability.b_c_level*0.05
		b_c_sequence(caster, position, fv, ability)
	end
	caster:RemoveModifierByName("modifier_pulse_slow")
	caster:RemoveModifierByName("modifier_bahamut_pulse_on")
	ProjectileManager:ProjectileDodge(caster)

end

function b_c_sequence(caster, position, fv, ability)
	local modifyVectorTable = {Vector(0,0,100)}
	local targetPoint = position+fv*200
	local radius = 720
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), targetPoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			local info = 
			{
				Target = enemy,
				Source = caster,
				Ability = ability,	
				EffectName = "particles/units/heroes/hero_skywrath_mage/leshrac_rune_b_c_arcane_bolt.vpcf",
				StartPosition = "attach_attack1",
				bDrawsOnMinimap = false, 
			        bDodgeable = true,
			        bIsAttack = false, 
			        bVisibleToEnemies = true,
			        bReplaceExisting = false,
			        flExpireTime = GameRules:GetGameTime() + 5,
				bProvidesVision = true,
				iVisionRadius = 0,
				iMoveSpeed = 400,
				iVisionTeamNumber = caster:GetTeamNumber()
			}
			local projectile = ProjectileManager:CreateTrackingProjectile(info)
		end
	end
end

function b_c_strike(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local damage = ability.b_c_damage
	EmitSoundOn("Bahamut.Purity.Hit", target)
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 3, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
	if not target:HasModifier("modifier_purity_freeze") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_purity_freeze", {duration = ability.b_c_duration})
	end
end

function ShowCaster( event )
	local caster = event.caster
	local position = caster:GetAbsOrigin()
	local ability = event.ability
	EmitSoundOn("leshrac_lesh_anger_05", event.caster)
	EmitSoundOn("Hero_Terrorblade.Reflection", caster)
	if not caster:HasModifier("modifier_lightning_dash") then
    	caster:RemoveNoDraw()
    end
    event.caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
    StartAnimation(event.caster, {duration=0.2, activity=ACT_DOTA_TELEPORT_END, rate=3})

   	local particle = "particles/units/heroes/hero_chen/chen_teleport_flash.vpcf"
	local pfx2 = ParticleManager:CreateParticle( particle, PATTACH_CUSTOMORIGIN, caster )
	FindClearSpaceForUnit(caster, position, false)
	ParticleManager:SetParticleControl( pfx2, 0, position )
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(pfx2, false)
	end)
	-- local a_c_level = Runes:GetTotalRuneLevel(caster, 1, "a_c", "bahamut")
	-- if a_c_level > 0 then
	-- 	local healAmount = a_c_level*550
	-- 	healAmount = math.floor(healAmount + 0.0005*(caster:GetStrength()+caster:GetAgility()+caster:GetIntellect())/10*ability.d_c_level*healAmount)
	-- 	Filters:ApplyHeal(caster, caster, healAmount, true)
	-- end
	rune_c_c(caster, event.ability)

end

function leshrac_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	local damage = event.damage
	local luck = RandomInt(1, 10)
	if luck > 1 then
		local a_c_level = Runes:GetTotalRuneLevel(caster, 1, "a_c", "bahamut")
		if a_c_level > 0 then
			local healAmount = math.ceil(damage*0.01*a_c_level)
			Filters:ApplyHeal(caster, caster, healAmount, true)
			ability.healParticle = true
			CustomAbilities:QuickAttachParticle("particles/econ/items/tinker/boots_of_travel/teleport_end_bots_ground_glow.vpcf", caster, 2)
		end
	end
end

function rune_c_c(caster, ability)
  local runeUnit = caster.runeUnit3
  local runeAbility = runeUnit:FindAbilityByName("bahamut_rune_c_c")
  local abilityLevel = runeAbility:GetLevel()
  local bonusLevel = Runes:GetTotalBonus(runeUnit, "c_c")
  local totalLevel = abilityLevel + bonusLevel
  if totalLevel > 0 then
  	local bahamut_pulse = caster:FindAbilityByName("bahamut_pulse")
  	if not bahamut_pulse then
  		bahamut_pulse = caster:AddAbility("bahamut_pulse")
  	end
  	bahamut_pulse.active = true
  	ability:ApplyDataDrivenModifier(caster, caster, "modifier_ascencion_cooldown", {duration = ability:GetCooldownTimeRemaining()})
  	bahamut_pulse:SetLevel(ability:GetLevel())
  	bahamut_pulse:SetAbilityIndex(2)
  	bahamut_pulse.strikes = 0
  	bahamut_pulse.c_c_damage = totalLevel*2440 + 3000
  	caster:SwapAbilities("leshrac_blink", "bahamut_pulse", false, true)
  	caster.pulse = true
  end
end

function cooldownEnd(event)
	local ability = event.ability
	local caster = event.caster
	local level = caster:FindAbilityByName("bahamut_pulse"):GetLevel()
  	ability:SetLevel(level)
  	local pulse = caster:FindAbilityByName("bahamut_pulse")
  	if pulse:GetToggleState() then
  		pulse:ToggleAbility()
  	end
  	caster.pulse = false
  	caster:SwapAbilities("leshrac_blink", "bahamut_pulse", true, false)	
end

function ascension_thinking(event)
	local ability = event.ability
	local caster = event.caster
	if ability:GetCooldownTimeRemaining() <= 0 and caster:HasAbility("bahamut_pulse") and caster.pulse then
		cooldownEnd(event)
	end
end