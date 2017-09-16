function start_channel(event)
	local caster = event.caster
	StartSoundEvent("Venomort.ReaperSlice", caster)
end

function channel_interrupt(event)
	local caster = event.caster
	StopSoundEvent("Venomort.ReaperSlice", caster)
end

function slice_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	
	local a_d_level = Runes:GetTotalRuneLevelGeneric(caster, 1, 3)
	local b_d_level = Runes:GetTotalRuneLevelGeneric(caster, 2, 3)
	local c_d_level = Runes:GetTotalRuneLevelGeneric(caster, 3, 3)
	local d_d_level = Runes:GetTotalRuneLevelGeneric(caster, 4, 3)
	local damage = caster:GetAverageTrueAttackDamage(caster)*event.damage_mult
	local procs = Runes:Procs(b_d_level, 10, 1)
	Filters:CastSkillArguments(4, caster)
	ability.target = target
	for i = 0, procs, 1 do
		Timers:CreateTimer(i*1.5, function()
			local target = ability.target
			print(target:GetEntityIndex())
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
						if a_d_level > 0 then
							local pfx2 = ParticleManager:CreateParticle("particles/roshpit/venomort/reapers_slice_a_d_magical.vpcf", PATTACH_CUSTOMORIGIN, caster)
							ParticleManager:SetParticleControl(pfx2, 0, target:GetAbsOrigin())
							ParticleManager:SetParticleControl(pfx2, 2, Vector(90, 255, 60))
							Timers:CreateTimer(3.5, function()
								ParticleManager:DestroyParticle(pfx2, false)
							end)
						    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
						    if #enemies > 0 then
						    	local AOEDamage = damage*0.03*a_d_level
						        for _,enemy in pairs(enemies) do
						        	Filters:TakeArgumentsAndApplyDamage(enemy, caster, AOEDamage, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_POISON, RPC_ELEMENT_NONE)
						        end
						    end 
						end
						if c_d_level > 0 then
							-- local wraith = CreateUnitByName("npc_dummy_unit", target:GetAbsOrigin(), false, nil, nil, caster:GetTeamNumber())
							-- print("CREATE WRAITH!")
							-- wraith:SetModel("models/heroes/arc_warden/mesh/spark_wraith.vmdl")
							-- wraith:SetOriginalModel("models/heroes/arc_warden/mesh/spark_wraith.vmdl")
							-- wraith:AddAbility("dummy_unit"):SetLevel(1)
							-- wraith:SetRenderColor(0, 255, 0)
							-- ability:ApplyDataDrivenModifier(caster, wraith, "modifier_wraith_chasing", {})
							local soulRipParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_soul_rip_heal.vpcf", PATTACH_POINT_FOLLOW, caster)
							ParticleManager:SetParticleControlEnt(soulRipParticle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
							ParticleManager:SetParticleControlEnt(soulRipParticle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
							local heal = damage*0.003*c_d_level
							local healthDefecit = caster:GetMaxHealth() - caster:GetHealth()
							local overHeal = heal - healthDefecit
							local maxOverheal = 0.08*caster:GetMaxHealth()*c_d_level
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
						if d_d_level > 0 then
							ability:ApplyDataDrivenModifier(caster, target, "modifier_reaper_slice_amp_debuff", {duration = 12})
							local currentStacks = target:GetModifierStackCount("modifier_reaper_slice_amp_debuff", caster)
							local newStacks = currentStacks + d_d_level
							target:SetModifierStackCount("modifier_reaper_slice_amp_debuff", caster, newStacks)
						end
					end)
					Filters:ApplyStun(caster, 1.2, target)
					Timers:CreateTimer(5, function() 
					  ParticleManager:DestroyParticle( pfx, false )
					  ParticleManager:ReleaseParticleIndex(pfx)
					end) 

				else
				    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), ability.target:GetAbsOrigin(), nil, 750, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false )
				    if #enemies > 0 then
				    	ability.target = enemies[1]
				    end 	
				end
			else
			    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), ability.target:GetAbsOrigin(), nil, 750, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false )
			    if #enemies > 0 then
			    	ability.target = enemies[1]
			    end 
			end
		end)
	end
end

function wraith_summon_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	print("THINKING WRAITH!!")
	target:MoveToPosition(caster:GetAbsOrigin())
	local distance = WallPhysics:GetDistance2d(target:GetAbsOrigin(), caster:GetAbsOrigin())
	if distance < 80 then
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_arc_warden/arc_warden_wraith_cast.vpcf", caster, 2)
		UTIL_Remove(target)
	end
end