LinkLuaModifier("slipfinn_shadow_warping", "modifiers/slipfinn/slipfinn_shadow_warping", LUA_MODIFIER_MOTION_NONE)
require('heroes/slark/constants')
require('heroes/slark/jump')


function shadow_warp_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	local origPosition = caster:GetAbsOrigin()
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_slark/slark_loadout.vpcf", caster, 0.5)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_slipfinn_shadow_warping", {duration = 0.2})
	local pfx = CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_slark/slark_shadow_dance.vpcf", origPosition, 2)
	ParticleManager:SetParticleControl(pfx, 1, origPosition)
	ability.shadowScale = 1.15
	shadow_SizeChange(caster, ability.shadowScale, 0.1, 6)
	Timers:CreateTimer(0.2, function()
		Timers:CreateTimer(0.03, function()
			caster.speed = 0
		end)
		EmitSoundOn("Slipfinn.ShadowWarp", caster)
		target = WallPhysics:WallSearch(caster:GetAbsOrigin(), target, caster)
		if caster:HasModifier("modifier_slipfinn_immortal_weapon_1") then
			target = target+Vector(0,0,SLIPFINN_IMMORTAL_WEAPON_1_HEIGHT)
			caster:SetAbsOrigin(target)
			event.guarantee = true
			event.ability = caster:FindAbilityByName("slipfinn_jump")
			if event.ability then
				slipfinn_jump_start(event)
			end

		else
			FindClearSpaceForUnit(caster, target, false)
		end
		ProjectileManager:ProjectileDodge(caster)
		local casterOrigin = caster:GetAbsOrigin()
		local pfx2 = CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_slark/slark_shadow_dance.vpcf", casterOrigin, 2)
		ParticleManager:SetParticleControl(pfx2, 1, casterOrigin)
		shadow_SizeChange(caster, 0.1, ability.shadowScale, 6)
	end)
	local c_c_level = caster:GetRuneValue("e", 3)
	local c_c_duration = Filters:GetAdjustedBuffDuration(caster, c_c_level*SLIPFINN_E3_DURATION, false)
	if c_c_level > 0 then
		local shadowRush = caster:FindAbilityByName("slipfinn_shadow_rush")
		shadowRush:ApplyDataDrivenModifier(caster, caster, "modifier_slipfinn_shadow_cloak", {duration = c_c_duration})
	end
	Filters:CastSkillArguments(3, caster)
end

function shadow_SizeChange(object, startSize, endSize, ticks)
  -- local growth = (endSize-startSize)/ticks
  -- for i = 0, ticks, 1 do
  --   Timers:CreateTimer(i*0.03, function()
  --     object:SetModelScale(startSize + growth*i)
  --   end)
  -- end
end