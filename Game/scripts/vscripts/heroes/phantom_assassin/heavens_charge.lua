function heaven_charge_start(event)
	local caster = event.caster
	local ability = event.ability
    local position = event.target_points[1]
    local maxDistance = ability.rune_e_3_level*5 + 900
    local startPosition = caster:GetAbsOrigin()
    local castedDistance = WallPhysics:GetDistance(startPosition,position)
    if castedDistance > maxDistance then
    	local displacementVector = (position - startPosition):Normalized()
    	position = startPosition + displacementVector*maxDistance
    end
    local newPosition = WallPhysics:WallSearch(startPosition, position, caster)
    caster.e_4_level = Runes:GetTotalRuneLevel(caster, 4, "e_4", "voltex")
    caster:SetOrigin(newPosition+Vector(0,0,900))
    caster:RemoveModifierByName("modfier_voltex_jumping")
	local particleName = "particles/units/heroes/hero_zuus/zeus_loadout.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	Timers:CreateTimer(2.5, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	end) 	
	Timers:CreateTimer(0.05, function()
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_heavens_charge_falling", {duration = 3})
		ProjectileManager:ProjectileDodge(caster)
	end)
	EmitSoundOn("phantom_assassin_phass_pain_13", caster)

	      particleName = "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_attack_crit.vpcf"
	      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	      ParticleManager:SetParticleControl( particle1, 0, startPosition )
	      ParticleManager:SetParticleControl( particle1, 1, startPosition )
	      ParticleManager:SetParticleControl( particle1, 3, startPosition )
	      Timers:CreateTimer(2, 
	      function()
	        ParticleManager:DestroyParticle( particle1, false )
	      end)
	if caster:HasModifier("modifier_voltex_glyph_3_1") then
		local overcharge = caster:FindAbilityByName("overcharge")
		overcharge:EndCooldown()
	end
end

function heaven_charge_fall_think(event)
	local caster = event.caster
	local ability = event.ability
	local currentPosition = caster:GetAbsOrigin()
	if (currentPosition.z - GetGroundPosition(currentPosition, caster).z) < 20 then
		caster:RemoveModifierByName("modifier_heavens_charge_falling")
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		EmitSoundOnLocationWithCaster(currentPosition, "Hero_Zuus.GodsWrath.Target", caster)
	      particleName = "particles/units/heroes/hero_disruptor/disruptor_thunder_strike_bolt.vpcf"
	      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	      ParticleManager:SetParticleControlEnt(particle1, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	      ParticleManager:SetParticleControl( particle1, 1, Vector(400, 0, 0) )
	      Timers:CreateTimer(2, 
	      function()
	        ParticleManager:DestroyParticle( particle1, false )
	      end)
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			local damage = ability.rune_e_3_level * 6000
			local stun_duration = 1.5
			if #enemies > 0 then	
				for _,enemy in pairs(enemies) do
					Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 3, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
					Filters:ApplyStun(caster, stun_duration, enemy)
				end				
			end 
			if caster:IsAlive() then
			  	local azure_leap = caster:FindAbilityByName("electric_jump")
			  	azure_leap:SetLevel(ability:GetLevel())
			  	caster:SwapAbilities("heavens_charge", "electric_jump", false, true)
			  	azure_leap:SetAbilityIndex(2)
			  	caster.chargeActive = false
			end
	else
		caster:SetAbsOrigin(currentPosition + Vector(0,0,-160))
	end
end