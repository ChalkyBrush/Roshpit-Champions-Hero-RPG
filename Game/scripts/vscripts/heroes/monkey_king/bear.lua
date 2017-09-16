function bear_roar_pre(event)
	local caster = event.caster
	EmitSoundOn("Draghor.Bear.Roar", caster)
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_axe/axe_beserkers_call_owner.vpcf", caster, 3)
end

function bear_roar(event)
	local caster = event.caster
	local ability = event.ability
	local duration = event.duration

	local pfx = CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lycan/lycan_howl_cast.vpcf", caster, 3)
	ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 2, caster:GetAbsOrigin()+caster:GetForwardVector()*200)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 380, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_bear_roar_taunt", {duration = duration})
			enemy:MoveToTargetToAttack(caster)
		end
	end
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_bear_armor_buff", {duration = duration})
	
end

function bear_warstomp_pre(event)
	local caster = event.caster
	EmitSoundOn("Draghor.Bear.Warstomp.Pre", caster)
	StartAnimation(caster, {duration=0.4, activity=ACT_DOTA_IDLE_RARE, rate=2.5})
	CustomAbilities:QuickAttachParticle("particles/econ/items/axe/axe_helm_shoutmask/axe_beserkers_call_owner_shoutmask.vpcf", caster, 3)
end

function bear_warstomp(event)
	local caster = event.caster
	local ability = event.ability
	local stun_duration = event.stun_duration
	local damage = event.damage

	local position = caster:GetAbsOrigin()
	local splitEarthParticle = "particles/roshpit/draghor/bear_warstomp.vpcf"
	local pfx = ParticleManager:CreateParticle( splitEarthParticle, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, position )
	ParticleManager:SetParticleControl( pfx, 1, Vector(radius, radius, radius) )
	EmitSoundOn("Seafortress.Barnacle.Quake", caster)
	-- FindClearSpaceForUnit(caster, position, false)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, 280, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_NATURE, RPC_ELEMENT_EARTH)
			Filters:ApplyStun(caster, stun_duration, enemy)
		end
	end 
	
end