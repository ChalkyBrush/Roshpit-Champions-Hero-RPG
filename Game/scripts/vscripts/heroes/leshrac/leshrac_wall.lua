function castAnimation(event)
	local caster = event.caster
	StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_CAST_ABILITY_2, rate=1.3})
		local pfx = ParticleManager:CreateParticle("particles/roshpit/bahamut/bahamut_wall_spawn.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()+Vector(0,0,60))
		ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin()+Vector(0,0,60))
		ParticleManager:SetParticleControlEnt(pfx, 3, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		Timers:CreateTimer(1.8, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
end

function createWall(event)
	local caster = event.caster
	local ability = event.ability
	ability.q_1_level = Runes:GetTotalRuneLevel(caster, 1, "q_1", "bahamut")
	ability.q_3_level = Runes:GetTotalRuneLevel(caster, 3, "q_3", "bahamut")
	caster.e_4_level = Runes:GetTotalRuneLevel(caster, 4, "e_4", "bahamut")
	if caster:HasModifier("modifier_bahamut_arcana1") then
		ability.r_1_level = 0
		ability.r_2_level = 0
	else
		ability.r_1_level = Runes:GetTotalRuneLevel(caster, 1, "r_1", "bahamut")
		ability.r_2_level = Runes:GetTotalRuneLevel(caster, 2, "r_2", "bahamut")
	end
	local soundTable = {"leshrac_lesh_deny_14", "leshrac_lesh_deny_15", "leshrac_lesh_deny_16", "leshrac_lesh_deny_12", "leshrac_lesh_deny_12", "leshrac_lesh_deny_10", "leshrac_lesh_deny_10", "leshrac_lesh_deny_06"}
	local point = event.target_points[1]
	EmitSoundOn(soundTable[RandomInt(1, #soundTable)], caster)
	local casterOrigin = caster:GetAbsOrigin()
	local fv = (point-casterOrigin):Normalized()
	local wallLength = event.wallLength
	if caster:HasModifier("modifier_bahamut_immortal_weapon_3") then
		wallLength = wallLength*2
	end
	local ninetyDegrees = WallPhysics:rotateVector(fv, math.pi/2)
	local wallPoint1 = point - ninetyDegrees*wallLength/2
	local wallPoint2 = point + ninetyDegrees*wallLength/2
	local particle = "particles/units/heroes/hero_dark_seer/leshrac_wallof_replica.vpcf"
	local pfx2 = ParticleManager:CreateParticle( particle, PATTACH_CUSTOMORIGIN, caster )
	local wallDuration = 8
	if caster:HasModifier("modifier_bahamut_glyph_4_1") then
		wallDuration = 10
	end
	wallDuration = Filters:GetAdjustedBuffDuration(caster, wallDuration, false)
	ParticleManager:SetParticleControl( pfx2, 0, wallPoint1 )
	ParticleManager:SetParticleControl( pfx2, 1, wallPoint2 )

	-- local obstructionTable = {}
	local loopCount = math.ceil(-wallLength/170)
	local reduceLoop = 0

	-- if wallLength%50 == 0 then
	-- 	reduceLoop = 1
	-- end

	EmitSoundOnLocationWithCaster(point, "Hero_Luna.Eclipse.NoTarget", caster)
	EmitSoundOnLocationWithCaster(point, "Hero_Luna.Eclipse.NoTarget", caster)
	ability.wallCenter = point
	ability.ninetyDegrees = ninetyDegrees
	ability.wallLength = wallLength
	if not ability.wallThinkerTable then
		ability.interval = 0
		ability.wallThinkerTable = {}
	end
	ability.interval = ability.interval + 1
	local intervalForFunction = ability.interval
	for i = loopCount, -loopCount-reduceLoop, 1 do
		local obstructionPoint = point+ninetyDegrees*i*100
		-- local obstruction = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = obstructionPoint, Name ="wallObstruction"})
		ability:ApplyDataDrivenThinker(caster, obstructionPoint, "modifier_leshrac_wall_thinker", {duration = wallDuration+0.03})
		local wallHandle = ability:ApplyDataDrivenThinker(caster, obstructionPoint, "modifier_leshrac_self_finder", {duration = wallDuration+0.03})
		wallHandle.position = point
		wallHandle.index = intervalForFunction
		wallHandle.ninetyDeg = ninetyDegrees
		if i == loopCount then
			table.insert(ability.wallThinkerTable, wallHandle)
		end
		AddFOWViewer(caster:GetTeamNumber(), obstructionPoint, 250, wallDuration, false)

		local pfx = ParticleManager:CreateParticle("particles/roshpit/bahamut/bahamut_wall_spawn.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, obstructionPoint)
		ParticleManager:SetParticleControl(pfx, 1, obstructionPoint)
		ParticleManager:SetParticleControlEnt(pfx, 3, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		Timers:CreateTimer(1.8, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	end
	
	Timers:CreateTimer(wallDuration, function()
		ParticleManager:DestroyParticle(pfx2, false)
		local newTable = {}
		for i = 1, #ability.wallThinkerTable, 1 do
			wallThinker = ability.wallThinkerTable[i]
			if wallThinker.index == intervalForFunction then
				print("remove one with walindex: "..wallThinker.index)
			else
				print("INSERT..."..wallThinker.index)
				table.insert(newTable, wallThinker)
			end
		end
		ability.wallThinkerTable = newTable
		-- for k,obstruction in pairs(obstructionTable) do
		-- 	UTIL_Remove(obstruction)
		-- end
	end)	
	Filters:CastSkillArguments(1, caster)
	if caster:HasModifier("modifier_bahamut_glyph_5_a") then
		if not caster:HasModifier("modifier_bahamut_5_a_cooldown") then
			ability:EndCooldown()
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_bahamut_5_a_cooldown", {duration = 4})
		end
	end
end

function WallDamageThink(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local damage = event.damage
	if caster:HasModifier("modifier_bahamut_immortal_weapon_3") then
		damage = damage*3
	end
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
	EmitSoundOn("Hero_DeathProphet.Exorcism.Damage", target)
	local particleName = "particles/econ/items/antimage/antimage_weapon_basher_ti5/leshrac_wall_burn.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	Timers:CreateTimer(0.5, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	end) 	
	if ability.q_3_level > 0 then
	  	ability:ApplyDataDrivenModifier(caster, target, "modifier_leshrac_wall_slow", {})
	  	target:SetModifierStackCount( "modifier_leshrac_wall_slow", ability, ability.q_3_level )
	end
end