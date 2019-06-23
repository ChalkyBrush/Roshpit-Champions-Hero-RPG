LinkLuaModifier("modifier_jex_cosmic_surge_lua", "modifiers/jex/modifier_jex_cosmic_surge_lua", LUA_MODIFIER_MOTION_NONE)
require('heroes/arc_warden/abilities/onibi')
function jex_active_cosmic_surge(event)
	local caster = event.caster
	local ability = event.ability

	local duration_base = event.duration_base
	local duration_per_tech = event.duration_per_tech

	local tech_level = onibi_get_total_tech_level(caster, "lightning", "cosmic", "E")
	ability.tech_level = tech_level
	local duration = Filters:GetAdjustedBuffDuration(caster, duration_base + duration_per_tech*tech_level, false)

	EmitSoundOn("Jex.Jolt.Start", caster)
	EmitSoundOn("Jex.CosmicSurge.Start", caster)

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_jex_cosmic_surge", {duration = duration})
	caster:AddNewModifier(caster, ability, "modifier_jex_cosmic_surge_lua", {duration = duration})
	local invokePFX = CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_invoker/invoker_death_end.vpcf", caster, 4)
	ParticleManager:SetParticleControl(invokePFX, 1, Vector(60, 10, 150))
	Events:ColorWearablesAndBase(caster, Vector(20, 0, 70))

	Filters:CastSkillArguments(3, caster)

	local w_4_level = caster:GetRuneValue("w", 4)
	if w_4_level > 0 then
		local cd = ability:GetCooldownTimeRemaining()
		local new_cd = cd - event.w_4_cooldown_reduce*w_4_level
		ability:EndCooldown()
		ability:StartCooldown(new_cd)
	end
end

function cosmic_surge_end(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	Events:ColorWearablesAndBase(target, Vector(255, 255, 255))
end

function cosmic_surge_thinking(event)
	local caster = event.caster
	local ability = event.ability
	if caster:HasModifier("modifier_jex_glyph_7_1") then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, JEX_GLYPH_7_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				if not enemy.dummy then
					local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)*(JEX_GLYPH_7_DAMAGE_PCT/100)
					Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PURE, BASE_ABILITY_E, RPC_ELEMENT_COSMOS, RPC_ELEMENT_LIGHTNING)
					EmitSoundOn("Jex.Thundershroom.Lightning", enemy)
					local particleName = "particles/roshpit/jex/glyph_7_lightning.vpcf"
					local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, nil) 
					ParticleManager:SetParticleControl(lightningBolt,0,caster:GetAbsOrigin()+Vector(0,0,50))   
					ParticleManager:SetParticleControl(lightningBolt,1,enemy:GetAbsOrigin()+Vector(0,0,60+enemy:GetBoundingMaxs().z))
					Timers:CreateTimer(2, function()
						ParticleManager:DestroyParticle(lightningBolt, false)
						ParticleManager:ReleaseParticleIndex(lightningBolt)
					end)
				end
			end
		end 	
	end
end