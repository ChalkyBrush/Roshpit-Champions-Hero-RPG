require('heroes/dark_seer/mach_punch')
require('heroes/dark_seer/tachyon_shell')

LinkLuaModifier("modifier_zonik_speedball_cap", "modifiers/zonik/modifier_zonik_speedball_cap", LUA_MODIFIER_MOTION_NONE)

function start_channel(event)
	local caster = event.caster
	StartSoundEvent("Zonik.Speedball.Channel", caster)
	EmitSoundOn("Zonik.Speedball.StartChannel", caster)
end

function channel_interrupt(event)
	local caster = event.caster
	StopSoundEvent("Zonik.Speedball.Channel", caster)
end

function zonik_passive_think(event)
	local caster = event.caster
	local ability = event.ability
	local b_d_level = Runes:GetTotalRuneLevelGeneric(caster, 2, 3)
	if b_d_level > 0 then
		if caster:IsRooted() or caster:IsStunned() then
			caster:RemoveModifierByName("modifier_speedball_b_d_regen")
			caster:RemoveModifierByName("modifier_speedball_b_d_mana_regen")
		else
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_speedball_b_d_regen", {})
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_speedball_b_d_mana_regen", {})
			local movespeedBase = caster:GetBaseMoveSpeed()
			local movespeed = caster:GetMoveSpeedModifier(movespeedBase)
			local regenBonus = 0.5*movespeed*b_d_level
			caster:SetModifierStackCount("modifier_speedball_b_d_regen", caster, regenBonus)
			caster:SetModifierStackCount("modifier_speedball_b_d_mana_regen", caster, regenBonus/10)
		end
	else
		caster:RemoveModifierByName("modifier_speedball_b_d_regen")
		caster:RemoveModifierByName("modifier_speedball_b_d_mana_regen")
	end
	local d_d_level = Runes:GetTotalRuneLevelGeneric(caster, 4, 3)
	if d_d_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_speedball_d_d_strength", {})
		caster:SetModifierStackCount("modifier_speedball_d_d_strength", caster, d_d_level)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_speedball_d_d_attack_power", {})
		caster:SetModifierStackCount("modifier_speedball_d_d_attack_power", caster, d_d_level*0.3*caster:GetStrength())
	else
		caster:RemoveModifierByName("modifier_speedball_d_d_strength")
		caster:RemoveModifierByName("modifier_speedball_d_d_attack_power")
	end
	
end

function speedball_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	StopSoundEvent("Zonik.Speedball.Channel", caster)

	EmitSoundOn("Zonik.Speedball.StartVO", caster)

	ability.speedTarget = target
	local duration = Filters:GetAdjustedBuffDuration(caster, 8, false)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_zonik_speedball", {duration = duration})
	caster:AddNewModifier( caster, ability, "modifier_zonik_speedball_cap", {duration = duration} )

	local a_d_level = Runes:GetTotalRuneLevelGeneric(caster, 1, 3)
	ability.a_d_level = a_d_level

	caster:RemoveModifierByName("modifier_speedball_a_d_visible")
	caster:RemoveModifierByName("modifier_speedball_a_d_invisible")
	local particleName = "particles/roshpit/zhonik/speedball.vpcf"
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ability.pfx = false
	end
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ability.pfx = pfx
	caster:AddNewModifier(caster, nil, "modifier_animation_translate", {translate="surge"})
	-- caster:AddNoDraw()
	Filters:CastSkillArguments(4, caster)
end

function speedball_thinking(event)
	local caster = event.caster
	local ability = event.ability
	local damage = event.damage
	local stun_duration = event.stun_duration
	if IsValidEntity(ability.speedTarget) then
		if ability.speedTarget:IsAlive() then
			local cd = ability:GetCooldownTimeRemaining()
			ability:EndCooldown()
			ability:StartCooldown(cd - 0.5)
			caster:MoveToPosition(ability.speedTarget:GetAbsOrigin() + caster:GetForwardVector()*80)
			local distance = WallPhysics:GetDistance(caster:GetAbsOrigin(), ability.speedTarget:GetAbsOrigin())
			if distance < 150 then
				speedball_explode(caster, ability, damage, stun_duration)
			end

			if ability.a_d_level > 0 then
				local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 180, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
				if #enemies > 0 then
					local stun_duration = 0.5 + ability.a_d_level*0.01
					local bSound = false
					for _,enemy in pairs(enemies) do
						if not enemy:HasModifier("modifier_speedball_stun") then
							bSound = true
							ability:ApplyDataDrivenModifier(caster, enemy, "modifier_speedball_stun", {duration = stun_duration})
							CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf", enemy, 0.8)

							ability:ApplyDataDrivenModifier(caster, caster, "modifier_speedball_a_d_visible", {})
							local newStacks = caster:GetModifierStackCount("modifier_speedball_a_d_visible", caster) + 1
							caster:SetModifierStackCount("modifier_speedball_a_d_visible", caster, newStacks)		

							ability:ApplyDataDrivenModifier(caster, caster, "modifier_speedball_a_d_invisible", {})
							caster:SetModifierStackCount("modifier_speedball_a_d_invisible", caster, newStacks*ability.a_d_level)

							caster:PerformAttack(enemy, true, true, true, false, true, false, false)
						end
					end
					if bSound then
						-- EmitSoundOn("Zonik.Speedball.RunningImpact", caster)
					end
				end 
			end
		else
			caster:RemoveModifierByName("modifier_zonik_speedball")
			caster:RemoveModifierByName("modifier_zonik_speedball_cap")
			-- caster:RemoveNoDraw()
		end
	else
		caster:RemoveModifierByName("modifier_zonik_speedball")
		caster:RemoveModifierByName("modifier_zonik_speedball_cap")
		-- caster:RemoveNoDraw()
	end
end

function speedball_end(event)
	local caster = event.caster
	local ability = event.ability
	caster:RemoveModifierByName("modifier_animation_translate")
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ability.pfx = false
	end
end

function speedball_explode(caster, ability, damage, stun_duration)
	caster:RemoveModifierByName("modifier_zonik_speedball")
	caster:RemoveModifierByName("modifier_zonik_speedball_cap")
	-- caster:RemoveNoDraw()
	CustomAbilities:QuickAttachParticle("particles/roshpit/zonik/speedball_explosion.vpcf", caster, 5)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 560, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_TIME, RPC_ELEMENT_COSMIC)
			Filters:ApplyStun(caster, stun_duration, enemy)
			local cd = ability:GetCooldownTimeRemaining()
			ability:EndCooldown()
			ability:StartCooldown(cd - 0.2)
			if caster:HasModifier("modifier_zonik_immortal_weapon_3") then
				if caster:HasAbility("tachyon_shell") then
					print("HERE?")
					local eventTable = {}
					eventTable.caster = caster
					eventTable.target = enemy
					eventTable.ability = caster:FindAbilityByName("tachyon_shell")
					eventTable.duration = eventTable.ability:GetLevelSpecialValueFor("duration", eventTable.ability:GetLevel())
					eventTable.bNoCast = true
					if eventTable.ability then
						print("CAST TACHYON")
						tachyon_shield_cast(eventTable)
					end
				end
			end
		end
	end 
	EmitSoundOn("Zonik.Speedball.Explode", caster)
	Filters:ApplyStun(caster, 2.0, caster)
	if caster:HasModifier("modifier_speedball_a_d_visible") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_speedball_a_d_visible", {duration = 8})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_speedball_a_d_invisible", {duration = 8})
	end
	local c_d_level = Runes:GetTotalRuneLevelGeneric(caster, 3, 3)
	if c_d_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_speedball_c_d_mach_ready", {duration = 4})
	end
end

function mach_ready_thinking(event)
	local caster = event.caster
	local ability = event.ability
	if caster:IsStunned() or caster:IsRooted() then
	else
		caster:RemoveModifierByName("modifier_speedball_c_d_mach_ready")
		local c_d_level = Runes:GetTotalRuneLevelGeneric(caster, 3, 3)
		local procs = Runes:Procs(c_d_level, 10, 1)
		if procs > 0 then
			for i = 0, procs-1, 1 do
				Timers:CreateTimer(i*0.2, function()
					if IsValidEntity(ability.speedTarget) then
						if ability.speedTarget:IsAlive() then
							caster:SetForwardVector(((ability.speedTarget:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized())
							StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_ATTACK, rate=2.8})
							local eventTable = {}
							eventTable.caster = caster
							eventTable.target = ability.speedTarget
							eventTable.cancelAnim = true
							eventTable.ability = caster:FindAbilityByName("zonik_mach_punch")
							if caster:HasAbility("zonik_comet_punch") then
								eventTable.ability = caster:FindAbilityByName("zonik_comet_punch")
							end
							eventTable.damage_mult = eventTable.ability:GetLevelSpecialValueFor("damage_mult", eventTable.ability:GetLevel())
							print(eventTable.damage_mult)
							eventTable.stun_duration = eventTable.ability:GetLevelSpecialValueFor("stun_duration", eventTable.ability:GetLevel())
							mach_punch_cast(eventTable)
						end
					end
				end)
			end
		end
	end
end