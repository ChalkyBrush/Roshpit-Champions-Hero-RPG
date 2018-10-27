local constants = require('heroes/hero_necrolyte/constants')

function toggle_on(event)
	local caster = event.caster
	local ability = event.ability
	local damage_mult = 12
	local r4_level = caster:GetRuneValue("r", 4)
	Filters:CastSkillArguments(4, caster)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_venomort_arcana2_movespeed_set", nil)
	StartSoundEvent("Venomort.ReaperToggle", caster)
	caster:SetModifierStackCount( "modifier_venomort_arcana2_movespeed_set", ability,constants.ARCANA1_R_BASE_MOVESPEED + r4_level * constants.ARCANA1_R4_BONUS_MOVESPEED)
end

function toggle_off(event)
	local caster = event.caster
	StopSoundEvent("Venomort.ReaperToggle", caster)
	caster:RemoveModifierByName("modifier_venomort_arcana2_movespeed_set")
end

function slice_start(event)
	local caster = event.caster
	local ability = event.ability
	local damage_mult = event.damage_mult
	local radius = constants.VENOMORT_ARCANA1_R_RADIUS
	local r1_level = caster:GetRuneValue("r", 1)
	local r2_level = caster:GetRuneValue("r", 2)
	local r3_level = caster:GetRuneValue("r", 3)
	local target

	if r2_level > 0 then
		radius = radius + constants.ARCANA1_R2_RADIUS * r2_level
	end


	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
	for _,enemy in pairs(enemies) do
		if not enemy.venomort_reaper_active then
			enemy.venomort_reaper_active = true
			if not enemy.dummy then
				target = enemy
				break
			end
		end
	end
	if not target then
		return
	end

	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)*damage_mult

	if IsValidEntity(target) then
		if target:IsAlive() then
			AddFOWViewer(caster:GetTeamNumber(), target:GetAbsOrigin(), 3, 500, false)
			EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Venomort.Reaper.Scream", target)
			EmitSoundOn("Venomort.Reaper.Scream2", target)
			local particleName = "particles/econ/items/necrolyte/necro_sullen_harvest/necro_ti7_immortal_scythe_start.vpcf"
			local pfx = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, target )
			ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			for i = 1, 9, 1 do
				ParticleManager:SetParticleControlEnt(pfx, i, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			end
			Timers:CreateTimer(1.2, function()
				EmitSoundOn("Venomort.ReaperSlice.Hit", target)
				target.venomort_reaper_active = false
				Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_PURE, 4, RPC_ELEMENT_POISON, RPC_ELEMENT_UNDEAD)
				Timers:CreateTimer(0.25, function()
					if not ability.target:IsAlive() then
						local enemies = FindUnitsInRadius( caster:GetTeamNumber(), ability.target:GetAbsOrigin(), nil, 750, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false )
						if #enemies > 0 then
							ability.target = enemies[1]
						end
					end
				end)
				--DEAL DAMAGE AND SOUND
				if r1_level > 0 then
					ability.r1_damage = damage * r1_level * constants.ARCANA1_R1_DAMAGE_PERCENT/100
					if caster:HasModifier('modifier_venomort_immortal_weapon_1') then
			            if not ability.particleCount then
			                ability.particleCount = 0
			            end
			            if ability.particleCount < 10 then
			                ability.particleCount = ability.particleCount + 1
							local pfx2 = ParticleManager:CreateParticle("particles/roshpit/venomort/reapers_slice_a_d_magical.vpcf", PATTACH_CUSTOMORIGIN, caster)
							ParticleManager:SetParticleControl(pfx2, 0, target:GetAbsOrigin())
							ParticleManager:SetParticleControl(pfx2, 2, Vector(90, 255, 60))
							Timers:CreateTimer(2.7, function()
								ParticleManager:DestroyParticle(pfx2, false)
							end)
							Timers:CreateTimer(2, function()
								ability.particleCount = ability.particleCount  - 1
							end)
						end
						local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, constants.WEAPON1_AOE_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
						if #enemies > 0 then
							for _,enemy in pairs(enemies) do
								ability:ApplyDataDrivenModifier(caster, enemy, "modifier_venomort_arcana2_reaper_dot", {duration = constants.ARCANA1_R1_DURATION})
							end
						end
					else
						ability:ApplyDataDrivenModifier(caster, target, "modifier_venomort_arcana2_reaper_dot", {duration = constants.ARCANA1_R1_DURATION})
					end

				end
				if r3_level > 0 then
					local soulRipParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_soul_rip_heal.vpcf", PATTACH_POINT_FOLLOW, caster)
					ParticleManager:SetParticleControlEnt(soulRipParticle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(soulRipParticle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
					local heal = damage * r3_level * constants.ARCANA1_R3_HEAL_PERCENT/100
					local healthDefecit = caster:GetMaxHealth() - caster:GetHealth()
					local overHeal = heal - healthDefecit
					local maxOverheal = caster:GetMaxHealth() * r3_level * constants.ARCANA1_R3_SHIELD_PERCENT/100
					Filters:ApplyHeal(caster, caster, heal, true)
					if overHeal > 0 then
						if not caster.scythe_shield_absorb then
							caster.scythe_shield_absorb = 0
						end
						caster.scythe_shield_absorb = math.min(caster.scythe_shield_absorb + overHeal, maxOverheal)
						ability:ApplyDataDrivenModifier(caster, caster, "modifier_reaper_slice_shield", {duration = 30})
					end
					Timers:CreateTimer(1.5, function()
						ParticleManager:DestroyParticle(soulRipParticle, false)
					end)
				end
			end)
			Timers:CreateTimer(5, function()
				ParticleManager:DestroyParticle( pfx, false )
				ParticleManager:ReleaseParticleIndex(pfx)
			end)
		end
	end
end

function dot_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local damage = ability.r1_damage
	Filters:ApplyDotDamage(caster, ability, target, damage, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_POISON, RPC_ELEMENT_NONE)
end
--end