require("heroes/moon_ranger/constants")

function dimension_stalker_channel_start(event)
	local caster = event.caster
	local ability = event.ability
	if not caster:HasModifier("modifier_astral_glyph_5_1") then
		StartAnimation(caster, {duration=2.0, activity=ACT_DOTA_ATTACK, rate=0.75})
	else
		Timers:CreateTimer(0.03, function() caster:InterruptChannel() end)
	end
	ability.liftspeed = 7.5
	ability.anim = true
	ability.arrow_spawn = true
	caster:RemoveModifierByName("modifier_dimension_stalker_channel_end")
	-- if ability.aoePFX then
	-- 	ParticleManager:DestroyParticle(ability.aoePFX, false)
	-- 	ability.aoePFX = false
	-- end
	-- local particleName = "particles/econ/items/underlord/underlord_ti8_immortal_weapon/underlord_ti8_immortal_pitofmalice.vpcf"
	-- ability:ApplyDataDrivenThinker(caster, GetGroundPosition(ability.target_point, caster), "modifier_cystal_arrow_ad_thinker", {duration = 7})
	StartSoundEvent("Astral.CrystalArrow.Channel", caster)
	-- if ability.pfx then
	-- 	ParticleManager:DestroyParticle(ability.pfx, false)
	-- 	ParticleManager:ReleaseParticleIndex(ability.pfx)
	-- 	ability.pfx = false
	-- end
end



function dimension_stalker_channel_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster) < 600 and not caster:HasModifier("modifier_astral_glyph_5_1") then
		caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,ability.liftspeed))
	end
	if GameRules:GetGameTime() - ability:GetChannelStartTime() > 0.5 and ability.arrow_spawn then
		ability.arrow_spawn = false
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_dimension_stalker_buildup", {duration = 1.5})
	end
	if GameRules:GetGameTime() - ability:GetChannelStartTime() > 1.0 and ability.anim and not caster:HasModifier("modifier_astral_glyph_5_1") then
		ability.anim = false
		ability.liftspeed = 18
		StartAnimation(caster, {duration=0.9, activity=ACT_DOTA_ATTACK, rate=2.0})
		EmitSoundOn("Astral.CrystalArrow.VOFire", caster)
	end
	if not ability.anim then
		ability.liftspeed = ability.liftspeed - 1
	end
end

function dimension_stalker_channel_end(event)
	local caster = event.caster
	local ability = event.ability
	ability.fallSpeed = 10
	ability.anim = true
	StopSoundEvent("Astral.CrystalArrow.Channel", caster)
	if not caster:HasModifier("modifier_astral_glyph_5_1") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_dimension_stalker_channel_end", {duration = 4})
	else
		fire_dimension_stalker({caster = caster, ability = ability})
	end
	caster:RemoveModifierByName("modifier_astral_glyph_7_1_evasion_effect")
end

function dimension_stalker_channel_end_think(event)
	local caster = event.caster
	local ability = event.ability
	ability.fallSpeed = ability.fallSpeed + 0.5
	-- caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,ability.fallSpeed))
	local landPoint = GetGroundPosition(caster:GetAbsOrigin(), caster)
	if landPoint.z + 150 < caster:GetAbsOrigin().z then
		local landEffect = ParticleManager:CreateParticle("particles/units/heroes/hero_luna/luna_lucent_beam.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(landEffect, 0, landPoint)
		ParticleManager:SetParticleControl(landEffect, 1, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(landEffect, 2, landPoint)
		EmitSoundOn("Astral.CrystalArrow.Land", caster)
		StartAnimation(caster, {duration=1.5, activity=ACT_DOTA_TELEPORT_END, rate=0.8})
		Timers:CreateTimer(3, function()
			ParticleManager:DestroyParticle(landEffect, false)
		end)
	end
	caster:SetAbsOrigin(landPoint)
	
	-- if caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster) < 150 and ability.anim then
	-- 	ability.anim = false
	-- 	if ability.fallSpeed > 12 then
	-- 		StartAnimation(caster, {duration=1.5, activity=ACT_DOTA_TELEPORT_END, rate=0.8})
	-- 	end
	-- end
	if caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster) < 10 then
		caster:RemoveModifierByName("modifier_dimension_stalker_channel_end")
		Timers:CreateTimer(0.03, function()
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		end)
	end
	caster:RemoveModifierByName("modifier_dimension_stalker_buildup")
end

function remove_modifier_channel_start(event)
	local caster = event.caster
end

function fire_dimension_stalker(event)
	local caster = event.caster
	local ability = event.ability
	local max_targets = 10
	local radius = 700
	local interval_between_strikes = 0.06
	
    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
    local duration = math.min(max_targets*interval_between_strikes, #enemies*interval_between_strikes)
    if #enemies > 0 then    
        for i = 1, #enemies, 1 do
        	local target = enemies[i]
           	Timers:CreateTimer(i*interval_between_strikes, function()
           		Filters:PerformAttackSpecial(caster, target, true, true, true, false, true, false, false)
           	end)
        end
    end	
end
