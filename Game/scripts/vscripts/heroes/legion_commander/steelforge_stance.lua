local constants = require('/heroes/legion_commander/constants')

function energy_shield_create(event)
	local caster = event.caster
	local ability = event.ability
	local regen_percent = event.regen_percent
	if not caster:HasModifier("modifier_energy_channel_no_cast_filter") then
		Filters:CastSkillArguments(2, caster)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_energy_channel_no_cast_filter", {duration = 0.5})
	end

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_protector_steelforge_regen", {})
	caster:SetModifierStackCount("modifier_protector_steelforge_regen", caster, regen_percent)

	local b_b_level = Runes:GetTotalRuneLevel(caster, 2, "b_b", "mountain_protector")
	ability.c_b_level = Runes:GetTotalRuneLevel(caster, 3, "c_b", "mountain_protector")
	if ability.c_b_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_protector_rune_c_b_aura", {})
	end

	ability.w4_level = caster:GetRuneValue("w", 4)
	if ability.w4_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_protector_rune_w4_bonus_damage", {})
	end


	caster.mountainGuardianMagic = 1+(b_b_level*0.04)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_energy_channel_animating", {duration = 6})
	Timers:CreateTimer(0.05, function()
		EmitSoundOn("MysticAssasin.ShieldYell"..RandomInt(1,2), caster)
	end)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "MountainProtector.SteelForm", caster)
	Timers:CreateTimer(0.1, function()
		StartSoundEvent("MountainProtector.SteelFormLoop", caster)

	end)
	Timers:CreateTimer(1.0, function()
		StopSoundEvent("MountainProtector.SteelFormLoop", caster)
	end)
	CustomAbilities:QuickAttachParticleWithPointFollow("particles/roshpit/mountain_protector/steelforge_start_teleport_ti7_out.vpcf", caster, 3, "attach_origin")
	StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_TELEPORT_END, rate=1.4})

	local a_b_level = Runes:GetTotalRuneLevelGeneric(caster, 1, 1)
	if a_b_level > 0 then
		local position = caster:GetAbsOrigin()
		local particleName = "particles/roshpit/mountain_protector/steelforge_explosion.vpcf"
		local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( particle1, 0, position )
		Timers:CreateTimer(4, 
		function()
			ParticleManager:DestroyParticle( particle1, false )
		end)	
		local damage = a_b_level*caster:GetAverageTrueAttackDamage(caster)*0.50 + a_b_level*caster:GetStrength()*10
		EmitSoundOnLocationWithCaster(position, "MysticAssasin.FissureExplosion", caster)
		local explosionAOE = 800
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, explosionAOE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				Filters:ApplyStun(caster, 0.5, enemy)
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PURE, 2, RPC_ELEMENT_EARTH, RPC_ELEMENT_ICE)
			end
		end 
	end
	ability.c_b_level = Runes:GetTotalRuneLevelGeneric(caster, 3, 1)
	ability.d_b_level = Runes:GetTotalRuneLevelGeneric(caster, 4, 1)
end

function energy_shield_think(event)
	local caster = event.caster
	local ability = event.ability
	local mana_drain = event.mana_drain
	Filters:CastSkillArguments(2, caster)
	caster:ReduceMana(mana_drain)
	CustomAbilities:IceQuill(event)

	if caster:GetMana() < mana_drain then
		ability:ToggleAbility()
	end

	local bonus_damage = caster:GetStrength() * constants.ARCANA1_W4_ATTACK_PER_STR * ability.w4_level
	if bonus_damage then
		caster:SetModifierStackCount("modifier_protector_rune_w4_bonus_damage", caster, bonus_damage)
	end
end

function energy_shield_end(event)
	local caster = event.caster
	StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_TELEPORT_END, rate=1.4})
	caster:RemoveModifierByName("modifier_protector_rune_c_b_aura")
	caster:RemoveModifierByName("modifier_protector_rune_w4_bonus_damage")
	caster:RemoveModifierByName("modifier_protector_steelforge_regen")


end

function steelforge_take_damage(event)
	local target = event.attacker
	local caster = event.caster
	local ability = event.ability
	if IsValidEntity(target) then
		if not target:IsAlive() then
			return false
		end
		if target == caster then
			return false
		end
		if caster:HasModifier("modifier_steelforge_stance") then
			Filters:ApplyStun(caster, constants.ARCANA1_W3_STUN_DURATION_CONST, target)
			if ability.c_b_level > 0 then
				if not ability.c_b_particles then
					ability.c_b_particles = 0
				end
				if ability.c_b_particles < 10 then
					ability.c_b_particles = ability.c_b_particles + 1
					local c_b_damage = caster:GetAverageTrueAttackDamage(caster)*constants.ARCANA1_W3_DAMAGE_PERCENT/100 * ability.c_b_level
					Filters:TakeArgumentsAndApplyDamage(target, caster, c_b_damage, DAMAGE_TYPE_PURE, 2, RPC_ELEMENT_NORMAL, RPC_ELEMENT_ICE)
					local pfx = ParticleManager:CreateParticle( "particles/roshpit/mountain_protector/blue_steel_dagon_lvl2_ti5.vpcf", PATTACH_POINT_FOLLOW, caster )
					ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT, "attach_hitloc", caster:GetAbsOrigin()+Vector(0,0,80), true)
					ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin()+Vector(0,0,80), true)
					Timers:CreateTimer(2.0, function() 
					  ParticleManager:DestroyParticle( pfx, false )
					  ability.c_b_particles = ability.c_b_particles - 1
					end) 	
				end
			end

		end	
	end
end