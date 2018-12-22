require('heroes/leshrac/leshrac_blink')

function begin_pulse(event)
	local caster = event.caster
	local ability = event.ability
	local damage = ability.e_3_damage
	local point = caster:GetAbsOrigin()
	local radius = 500
	if caster:HasModifier("modifier_bahamut_glyph_7_1") then
		radius = radius*1.4
	end
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_leshrac/bahamut_nova.vpcf", caster, 0.3)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	EmitSoundOnLocationWithCaster(point, "Hero_Leshrac.Diabolic_Edict", caster)
	local bStun = false
    if caster:HasModifier("modifier_bahamut_glyph_6_1") then
    	ability.strikes = ability.strikes + 1
    	if ability.strikes == 5 then
    		ability.strikes = 0
    		bStun = true
		      local particleName = "particles/roshpit/bahamut/glyphed_pulse_explosion_fallback_mid_egset.vpcf"
		      local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_WORLDORIGIN, caster )
		      ParticleManager:SetParticleControl( particle2, 0, caster:GetAbsOrigin() )
		      -- ParticleManager:SetParticleControl( particle2, 1, Vector(radius,radius,radius) )
		      -- ParticleManager:SetParticleControl( particle2, 2, Vector(1.2, 1.2, 1.2) )
		      -- ParticleManager:SetParticleControl( particle2, 4, Vector(255, 255, 255) )
		      Timers:CreateTimer(1.5, 
		      function()
		        ParticleManager:DestroyParticle( particle2, false )
		      end)
    	end
    end
	if #enemies > 0 then
		EmitSoundOnLocationWithCaster(point, "Hero_Leshrac.Diabolic_Edict", caster)
		EmitSoundOnLocationWithCaster(point, "Hero_Leshrac.Diabolic_Edict", caster)
		EmitSoundOnLocationWithCaster(point, "Hero_Leshrac.Diabolic_Edict", caster)
		for _,enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 3, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
			local particleName = "particles/units/heroes/hero_leshrac/bahamut_nova_strike.vpcf"
			local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, enemy )
			ParticleManager:SetParticleControlEnt(pfx, 0, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			Timers:CreateTimer(0.9, function() 
			  ParticleManager:DestroyParticle( pfx, false )
			end) 	
			if bStun then
				Filters:ApplyStun(caster, 1.5, enemy)
			end
		end
	end
	if not caster:HasModifier("modifier_bahamut_glyph_6_1") then
		local current_stack = caster:GetModifierStackCount( "modifier_pulse_slow", ability )
	    ability:ApplyDataDrivenModifier(caster, caster, "modifier_pulse_slow", {})
	    caster:SetModifierStackCount( "modifier_pulse_slow", ability, current_stack+1 )
	end
end

function pulse_passive_think(event)
	local caster = event.caster
	local ability = event.ability
	if ability.active then
		local blinkAbility = caster:FindAbilityByName("leshrac_blink")
		if blinkAbility:IsCooldownReady() then
			-- if ability:GetToggleState() then
			-- 	ability:ToggleAbility()
			-- end
			ability.active = false
			-- local eventTable = {}
			-- eventTable.caster = caster
			-- eventTable.ability = blinkAbility
			caster:RemoveModifierByName("modifier_ascencion_cooldown")
			-- cooldownEnd(eventTable)
		end
	end
end