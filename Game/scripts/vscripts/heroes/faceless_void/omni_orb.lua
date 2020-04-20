

function omniro_ghost_orb_aura_end(event)
	local target = event.target
	ParticleManager:DestroyParticle(target.pfx, false)
	UTIL_Remove(target)
end

function omniro_ghost_orb_aura_effect_think(event)
	local caster = event.ability:GetCaster()
	local ability = event.ability
	local target = event.target
	local mace_hit_data = OmniroOmniMaceBaseElementData(RPC_ELEMENT_GHOST)
	local damage = (ability:GetSpecialValueFor("ghost_orb_a") / 100) * OverflowProtectedGetAverageTrueAttackDamage(caster) * caster.omniro_data[RPC_ELEMENT_GHOST]["level"]
	Filters:ApplyDotDamage(caster, ability, target, damage, mace_hit_data["damage_type"], 2, RPC_ELEMENT_GHOST, RPC_ELEMENT_NONE)
end

function omni_rune_undead_projectile_hit(event)
	local caster = event.caster.hero
	local ability = caster:FindAbilityByName("omniro_omni_mace")
	local orb_ability = caster:FindAbilityByName("omniro_omni_orb")
	local damage = orb_ability.undead_orb_damage
	local enemy = event.target
	local mace_hit_data = OmniroOmniMaceBaseElementData(RPC_ELEMENT_UNDEAD)
	Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, mace_hit_data["damage_type"], BASE_ABILITY_W, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_NONE)
	enemy:AddNewModifier(caster, ability, "modifier_omniro_omni_mace_undead_debuff", {duration = OMNIRO_UNDEAD_SPECIAL_DURATION})
end

function omni_rune_wind_projectile_hit(event)
	local caster = event.caster.hero
	local ability = caster:FindAbilityByName("omniro_omni_orb")
	local damage = ability.wind_orb_damage
	local enemy = event.target
	local mace_hit_data = OmniroOmniMaceBaseElementData(RPC_ELEMENT_WIND)
	Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, mace_hit_data["damage_type"], BASE_ABILITY_W, RPC_ELEMENT_WIND, RPC_ELEMENT_NONE)
	--if enemy.pushLock then
	--else
	--	ability:ApplyDataDrivenModifier(caster, enemy, "modifier_wind_orb_pushback", {duration = 1})
	--end
end

function omniro_wind_orb_push_think(event)
	local caster = event.caster
	local target = event.target
	if target.pushLock then
		return false
	end
	local fv = ((target:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), target:GetAbsOrigin())
	local pushSpeed = math.max(40 - (distance / 1400) * 40, 10)
	local newPosition = target:GetAbsOrigin() + pushSpeed * fv
	local obstruction = WallPhysics:FindNearestObstruction(newPosition)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition, target)
	if blockUnit then
	else
		WallPhysics:SetPushPositionOverGround(target, newPosition)
	end
end

function omniro_wind_orb_end(event)
	local caster = event.caster
	local target = event.target
	FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
end

function omniro_time_effect_end(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local mace_hit_data = OmniroOmniMaceBaseElementData(RPC_ELEMENT_TIME)
	local damage = (ability:GetSpecialValueFor("time_orb_a") / 100) * OverflowProtectedGetAverageTrueAttackDamage(caster) * caster.omniro_data[RPC_ELEMENT_TIME]["level"]
	CustomAbilities:QuickAttachParticle("particles/roshpit/omniro/timelock.vpcf", target, 3)
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, mace_hit_data["damage_type"], BASE_ABILITY_W, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)
	EmitSoundOn("Omniro.Orb.Time.Pop", target)
end

function omniro_poison_pool_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local mace_hit_data = OmniroOmniMaceBaseElementData(RPC_ELEMENT_POISON)
	local damage = (ability:GetSpecialValueFor("poison_orb_a") / 100) * OverflowProtectedGetAverageTrueAttackDamage(caster) * caster.omniro_data[RPC_ELEMENT_POISON]["level"]
	Filters:ApplyDotDamage(caster, ability, target, damage, mace_hit_data["damage_type"], 2, RPC_ELEMENT_POISON, RPC_ELEMENT_NONE)
end

function water_orb_torrent_stun_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	target:SetAbsOrigin(target:GetAbsOrigin() + Vector(0, 0, target.torrentLiftVelocity))
	target.torrentLiftVelocity = target.torrentLiftVelocity - 0.9
	if target.torrentLiftVelocity < 0 then
		target:RemoveModifierByName("modifier_torrent_lifting")
	end
	if not target:HasModifier("modifier_torrent_lifting") then
		if target:GetAbsOrigin().z - GetGroundHeight(target:GetAbsOrigin(), target) < 30 then
			target:RemoveModifierByName("modifier_torrent_stun")
		end
	end
end

function water_orb_torrent_stun_end(event)
	local target = event.target
	local ability = event.ability
	Timers:CreateTimer(0.06, function()
		target.torrentLiftVelocity = nil
	end)

	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_slardar/slardar_crush.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, Vector(70, 70, 70))
	Timers:CreateTimer(3.0, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)

end