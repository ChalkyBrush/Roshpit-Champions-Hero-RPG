function die_after_time(event)
	local caster = event.target
	if caster.dieTime then
		caster:AddNewModifier(caster, nil, "modifier_kill", {duration = caster.dieTime+0.1})
		Timers:CreateTimer(caster.dieTime, function()
			if not caster:IsNull() then
				if caster:IsAlive() then
					caster:RemoveModifierByName("modifier_kill")
					ApplyDamage({ victim = caster, attacker = caster, damage = caster:GetMaxHealth()*1000000000, damage_type = DAMAGE_TYPE_PURE })
				end
			end
		end)
	end
end

function die_after_time_died(event)
	local caster = event.caster
	if caster.summonAbility then
		caster.summonAbility.skeletonLimit = caster.summonAbility.skeletonLimit - 1
	end
	Timers:CreateTimer(5, function()
		if IsValidEntity(caster) then
			UTIL_Remove(caster)
		end
	end)	
end