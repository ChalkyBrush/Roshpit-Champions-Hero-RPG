function tachyon_shield_cast(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	ability.a_a_level = Runes:GetTotalRuneLevelGeneric(caster, 1, 0)
	ability.c_a_level = Runes:GetTotalRuneLevelGeneric(caster, 3, 0)
	ability.d_a_level = Runes:GetTotalRuneLevelGeneric(caster, 4, 0)

	local modifierDuration = Filters:GetAdjustedBuffDuration(caster, event.duration, false)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_tachyon_shell", {duration = modifierDuration})
	if not ability.bNoCast then
		Filters:CastSkillArguments(1, caster)
	end
end

function tachyon_create(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	if target.tachyonPFX then
		ParticleManager:DestroyParticle(target.tachyonPFX, false)
		ParticleManager:ReleaseParticleIndex(target.tachyonPFX)
		target.tachyonPFX = false
	end
	local pfx = ParticleManager:CreateParticle("particles/roshpit/zonik/tachyon_shell.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	local radius = 55
	if caster:HasModifier("modifier_zonik_glyph_1_1") then
		if caster:GetEntityIndex() == target:GetEntityIndex() then
			radius = math.floor(radius*1.6)
		end
	end
	print(radius)
	ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
	target.tachyonPFX = pfx
end

function tachyon_end(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	if target.tachyonPFX then
		ParticleManager:DestroyParticle(target.tachyonPFX, false)
		ParticleManager:ReleaseParticleIndex(target.tachyonPFX)
		target.tachyonPFX = false
	end
end

function tachyon_shield_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	local damage = event.damage
	if ability.a_a_level > 0 then
		if caster:GetEntityIndex() == target:GetEntityIndex() then
			damage = damage + damage*0.15*ability.a_a_level
		end
	end
	local radius = 220
	if caster:HasModifier("modifier_zonik_glyph_1_1") then
		if caster:GetEntityIndex() == target:GetEntityIndex() then
			radius = math.floor(radius*1.6)
		end
	end
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			if enemy:GetEntityIndex() == target:GetEntityIndex() then
				if caster:HasModifier("modifier_zonik_glyph_2_1") then
					local glyphDamage = damage*3
					Filters:TakeArgumentsAndApplyDamage(enemy, caster, glyphDamage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)
					if ability.c_a_level > 0 then
						ability:ApplyDataDrivenModifier(caster, enemy, "modifier_tachyon_amp", {duration = 0.4})
						enemy:SetModifierStackCount("modifier_tachyon_amp", caster, ability.c_a_level)
					end

					ability:ApplyDataDrivenModifier(caster, target, "modifier_tachyon_slow", {duration = 0.25})
				end
			else
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)
				local pfx = ParticleManager:CreateParticle("particles/roshpit/zonik/tachyon_damage.vpcf", PATTACH_POINT_FOLLOW, caster )
				ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(pfx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
				Timers:CreateTimer(0.5, function()
					ParticleManager:DestroyParticle(pfx, false)
					ParticleManager:ReleaseParticleIndex(pfx)
				end)
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_tachyon_slow", {duration = 0.25})
				if ability.c_a_level > 0 then
					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_tachyon_amp", {duration = 0.4})
					enemy:SetModifierStackCount("modifier_tachyon_amp", caster, ability.c_a_level)
				end
			end
		end
	end 	
end

function die_under_tachyon(event)
	local caster = event.caster
	local target = event.unit
	local ability = event.ability

	local b_a_level = Runes:GetTotalRuneLevelGeneric(caster, 2, 0)
	if b_a_level > 0 then
		local radius = 200 + b_a_level*5
		local duration = 6 + b_a_level*0.1
		local units = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY+DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		if #units > 0 then
			local modifierDuration = Filters:GetAdjustedBuffDuration(caster, duration, false)
			ability:ApplyDataDrivenModifier(caster, units[1], "modifier_tachyon_shell", {duration = modifierDuration})			
		end 
	end
end