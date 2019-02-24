function jex_living_bomb_cast(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	ability:ApplyDataDrivenModifier(caster, target, "modifier_jex_living_bomb", {duration = 2})
	EmitSoundOn("Jex.LivingBomb.Apply", target)
	Filters:CastSkillArguments(2, caster)
end

function jex_living_bomb_explode(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local radius = 600
	local pfx = CustomAbilities:QuickParticleAtPoint("particles/roshpit/jex/jex_explode_living_bomb.vpcf", target:GetAbsOrigin(), 3)
	for i = 1, 5, 1 do
		ParticleManager:SetParticleControl(pfx, i, Vector(radius, radius, radius))
	end
	local damage = 10000
	EmitSoundOn("Jex.LivingBomb.Explode", target)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
		end
	end 	
end