require('heroes/vengeful_spirit/supernova')

function begin_alpha_spark(event)
	local ability = event.ability
	local caster = event.caster
	local point = WallPhysics:WallSearch(caster:GetAbsOrigin(), event.target_points[1], caster)

	ability.fallVelocity = 1
	CustomAbilities:QuickAttachParticle("particles/roshpit/solunia/alpha_spark.vpcf", caster, 0.5)

	if point.z < caster:GetAbsOrigin().z then
		caster:SetAbsOrigin(Vector(point.x, point.y, caster:GetAbsOrigin().z))
	else
		caster:SetAbsOrigin(point)
	end
	StartAnimation(caster, {duration = 0.5, activity = ACT_DOTA_CHANNEL_END_ABILITY_4, rate = 1.3})
	if event.type == "moon" then
		begin_eclipse(event)
	else
		begin_supernova(event)
	end
	local c_d_level = caster:GetRuneValue("r", 3)
	if c_d_level > 0 then
		local buffDuration = Filters:GetAdjustedBuffDuration(caster, c_d_level * SOLUNIA_ARCANA_R3_DURATION, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_solunia_c_d_arcana_shell", {duration = buffDuration})
	end
end

function alpha_spark_think(event)
	local caster = event.caster.hero
	local ability = event.ability
	local d_d_level = caster:GetRuneValue("r", 4)
	if d_d_level > 0 then
		ability:ApplyDataDrivenModifier(event.caster, caster, "modifier_solunia_d_d_stats", {})
		caster:SetModifierStackCount("modifier_solunia_d_d_stats", event.caster, d_d_level)
	else
		caster:RemoveModifierByName("modifier_solunia_d_d_stats")
	end
end
