LinkLuaModifier("slipfinn_shadow_rush_lua", "modifiers/slipfinn/slipfinn_shadow_rush_lua", LUA_MODIFIER_MOTION_NONE)
require("/heroes/slark/slipfinn_constants")
function shadow_rush_pre(event)
	local caster = event.caster
	local ability = event.ability
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_slark/slark_loadout.vpcf", caster, 1.0)
	StartAnimation(caster, {duration = 0.97, activity = ACT_DOTA_RUN, rate = 2.0})
	StartSoundEvent("Slipfinn.ShadowDash.WindUp", caster)
end

function shadow_rush_pre_cancel(event)
	local caster = event.caster
	local ability = event.ability
	StopSoundEvent("Slipfinn.ShadowDash.WindUp", caster)
	EndAnimation(caster)
end

function shadow_rush_start(event)
	local caster = event.caster
	local ability = event.ability

	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_slark/slark_dark_pact_pulses.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	Timers:CreateTimer(1.8, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	EmitSoundOn("Slipfinn.ShadowDash.Go", caster)
	local duration = Filters:GetAdjustedBuffDuration(caster, event.duration, false)
	caster.baseShadowRushDuration = duration
	caster:AddNewModifier(caster, ability, "slipfinn_shadow_rush_lua", {duration = duration})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_slipfinn_shadow_rush", {duration = duration})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_slipfinn_shadow_rush_flying_portion", {duration = duration})
	GridNav:DestroyTreesAroundPoint(caster:GetAbsOrigin(), 240, false)
	local c_c_level = caster:GetRuneValue("e", 3)
	local c_c_duration = Filters:GetAdjustedBuffDuration(caster, c_c_level * SLIPFINN_E3_DURATION, false)
	if c_c_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_slipfinn_shadow_cloak", {duration = c_c_duration})
	end
	Filters:CastSkillArguments(3, caster)
end

function shadow_rush_think(event)

	local caster = event.caster
	local ability = event.ability
	if caster:FindAbilityByName("slipfinn_shadow_rush"):IsInAbilityPhase() or caster:IsChanneling() or Filters:HasMovementModifier(caster) then
	else
		if not caster.rightClickPos then
			local order =
			{
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = WallPhysics:WallSearch(caster:GetAbsOrigin(), caster:GetAbsOrigin() + caster:GetForwardVector() * 500, caster)}
			ExecuteOrderFromTable(order)
		end
	end
	caster.shadow_rush_height = caster:GetAbsOrigin().z
end

function flying_portion_end(event)
	-- local caster = event.caster
	-- local ability = event.ability
	-- caster:SetAbsOrigin(Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, caster.shadow_rush_height))
end

function flying_portion_think(event)
	local caster = event.caster
	local ability = event.ability
	local buff = caster:FindModifierByName("modifier_slipfinn_shadow_rush_flying_portion")
	if buff:GetRemainingTime() < 0.2 then
		if caster:HasModifier("modifier_slipfinn_basic_jump") or caster:HasModifier("modifier_slipfinn_buttstomp") then
			--print("FLYING PORTION")
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_slipfinn_shadow_rush_flying_portion", {duration = 0.2})
		end
	end
end

function slipfinn_attack_land(event)
	local attacker = event.attacker
	local target = event.target
	if attacker:HasAbility("slipfinn_shadow_rush") then
		if target.dummy then
			return false
		end
		local a_c_level = attacker:GetRuneValue("e", 1)
		if a_c_level > 0 then
			local damage = event.damage * SLIPFINN_E1_MULT * a_c_level
			-- Timers:CreateTimer(0.05, function()
			Filters:TakeArgumentsAndApplyDamage(target, attacker, damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_E, RPC_ELEMENT_SHADOW, RPC_ELEMENT_NONE)
			CustomAbilities:QuickAttachParticle("particles/roshpit/slipfinn/shadow_shank.vpcf", target, 0.4)
			-- end)
		end
	end
end
