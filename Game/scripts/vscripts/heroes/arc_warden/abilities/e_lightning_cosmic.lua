LinkLuaModifier("modifier_jex_cosmic_surge_lua", "modifiers/jex/modifier_jex_cosmic_surge_lua", LUA_MODIFIER_MOTION_NONE)

function jex_active_cosmic_surge(event)
	local caster = event.caster
	local ability = event.ability

	local duration_base = event.duration_base
	local duration_per_tech = event.duration_per_tech

	local tech_level = caster.onibi.stats_table["lightning"]["cosmic"]["E"]["level"]
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