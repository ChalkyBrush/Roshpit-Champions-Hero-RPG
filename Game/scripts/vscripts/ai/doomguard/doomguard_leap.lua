function begin_leap(event)
	local caster = event.caster
	local ability = event.ability
	ability.velocity = 48
	ability.fv = caster:GetForwardVector()
	StartAnimation(caster, {duration=1.3, activity=ACT_DOTA_ATTACK, rate=0.6, translate="pyre"})
end

function rise_think(event)
	local caster = event.caster
	local origin = caster:GetAbsOrigin()
	local ability = event.ability
	caster:SetAbsOrigin(origin+Vector(0,0,ability.velocity)+ability.fv*25)
	ability.velocity = ability.velocity - 4
end

function begin_fall(event)
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_doomguard_falling", {duration = 2})
	-- StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_ATTACK, rate=0.3, translate="pyre"})
end

function fall_think(event)
	local caster = event.caster
	local origin = caster:GetAbsOrigin()
	local ability = event.ability
	local newPos = origin+Vector(0,0,ability.velocity)+ability.fv*50
	caster:SetAbsOrigin(newPos)
	ability.velocity = ability.velocity - 9
	local groundPos = GetGroundPosition(newPos, caster)
    if (newPos.z - groundPos.z < 2) then
        caster:RemoveModifierByName("modifier_doomguard_falling")
        FindClearSpaceForUnit(caster, groundPos, true)
    end	
end

function final_land(event)
	local caster = event.caster
	local ability = event.ability
	local radius = 200
	EmitSoundOn("Hero_EarthShaker.EchoSlamSmall", caster)
		local particleName =  "particles/units/heroes/hero_elder_titan/doomguard_leap_effect.vpcf"
		local position = caster:GetAbsOrigin()+ability.fv*200
		local particleVector = position

		local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( pfx, 0, particleVector )
		ParticleManager:SetParticleControl( pfx, 1, particleVector )
		ParticleManager:SetParticleControl( pfx, 2, particleVector )
		Timers:CreateTimer(1, function() 
		  ParticleManager:DestroyParticle( pfx, false )
		end)  
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			local damage = Events:GetAdjustedAbilityDamage(5000, 25000, 0)
			for _,enemy in pairs(enemies) do
				ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
				enemy:AddNewModifier(caster, nil, "modifier_stunned", {duration = 0.4})
			end
		end
	-- StartAnimation(caster, {duration=0.4, activity=ACT_DOTA_ATTACK, rate=3, translate="pyre"})
end