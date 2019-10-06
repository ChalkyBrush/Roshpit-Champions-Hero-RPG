require('heroes/antimage/arkimus_constants')

function storm_weapon_cast(event)
	local ability = event.ability
	local caster = event.caster
	local duration = Filters:GetAdjustedBuffDuration(caster, 3, false)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_arkimus_storm_weapon", {})
	if event.drain_mana > 0 then
		if caster:GetMana() < event.drain_mana then
			ability:ToggleAbility()
			return false
		else
			caster:ReduceMana(event.drain_mana)
		end
	end
	Filters:CastSkillArguments(2, caster)
	caster:RemoveModifierByName("modifier_burnout")
	if not ability.pfx then

		ability.pfx = ParticleManager:CreateParticle("particles/roshpit/heroes/arkimus/weapon_enhance.vpcf", PATTACH_POINT_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(ability.pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_h1", caster:GetAbsOrigin(), true)
	end
	if not ability.pfx2 then
		ability.pfx2 = ParticleManager:CreateParticle("particles/roshpit/heroes/arkimus/weapon_enhance.vpcf", PATTACH_POINT_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(ability.pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_h2", caster:GetAbsOrigin(), true)
	end
	if not caster.stormWeaponSound then
		local luck = 1
		if luck == 1 then
			caster.stormWeaponSound = true
			EmitSoundOn("Akrimus.MagicWeapon", caster)
			StartAnimation(caster, {duration = 0.8, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1.6})
			Timers:CreateTimer(0.6, function()
				caster.stormWeaponSound = false
			end)
		end
	end
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Akrimus.StormWeapon", caster)
	ability.w_2_level = caster:GetRuneValue("w", 2)
	-- local w_4_level = caster:GetRuneValue("w", 4)
	-- local procs = Runes:Procs(w_4_level, 6, 1)
	-- procs = 1 + procs
	-- caster:SetModifierStackCount("modifier_arkimus_storm_weapon", caster, procs)

end

function storm_weapon_strike(event)
	local ability = event.ability
	local caster = event.caster
	local attack_damage = event.attack_damage
	local target = event.target
	CustomAbilities:QuickAttachParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5/antimage_manavoid_ti_5.vpcf", target, 3)
	local damageMult = event.damage_mult
	local damage = attack_damage * damageMult / 100
	if caster:HasModifier("modifier_arkimus_immortal_weapon_1") then
		damage = damage * ARKIMUS_IMMORTAL_WEAPON_1_W_MULT
	end
	EmitSoundOn("Akrimus.StormWeaponImpact", target)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 420, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_ARCANE, RPC_ELEMENT_NONE)
			CustomAbilities:QuickAttachParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5/antimage_manavoid_explode_b_basher_cast.vpcf", enemy, 3)
			if ability.w_2_level > 0 then
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_storm_weapon_b_b_visible", {duration = 9})
				local stackGain = 1
				if caster:HasModifier("modifier_arkimus_immortal_weapon_1") then
					stackGain = stackGain * ARKIMUS_IMMORTAL_WEAPON_1_W2_STACK_GAIN_MULT
				end
				local newStacks = math.min(enemy:GetModifierStackCount("modifier_storm_weapon_b_b_visible", caster) + stackGain, 99)
				enemy:SetModifierStackCount("modifier_storm_weapon_b_b_visible", caster, newStacks)
				if not enemy.arkimus_b_b_pfx then
					enemy.arkimus_b_b_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_shadow_demon/shadow_demon_shadow_poison_stackui.vpcf", PATTACH_OVERHEAD_FOLLOW, enemy)
				end
				ParticleManager:SetParticleControl(enemy.arkimus_b_b_pfx, 1, Vector(math.floor(newStacks / 10), newStacks % 10, newStacks))

				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_storm_weapon_b_b_invisible", {duration = 9})
				enemy:SetModifierStackCount("modifier_storm_weapon_b_b_invisible", caster, newStacks * ability.w_2_level)
			end
		end
	end
	local w_4_level = caster:GetRuneValue("w", 4)
	local procs = Runes:Procs(w_4_level, ARKIMUS_W4_SHIELD_CHANCE, 1)
	if procs > 0 then
		local duration = Filters:GetAdjustedBuffDuration(caster, 7, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_arkimus_w_4_shield", {duration = duration})
		caster:SetModifierStackCount("modifier_arkimus_w_4_shield", caster, procs)
	end
	--   local currentStacks = caster:GetModifierStackCount("modifier_arkimus_storm_weapon", caster)
	--   if currentStacks > 1 then
	-- local duration = Filters:GetAdjustedBuffDuration(caster, 3, false)
	-- ability:ApplyDataDrivenModifier(caster, caster, "modifier_arkimus_storm_weapon", {duration = duration})
	--   newStacks = currentStacks - 1
	--   caster:SetModifierStackCount("modifier_arkimus_storm_weapon", caster, newStacks)
	--   else
	--   caster:RemoveModifierByName("modifier_arkimus_storm_weapon")
	--   end
end

function storm_weapon_end(event)
	local ability = event.ability
	local caster = event.caster
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ability.pfx = false
	end
	if ability.pfx2 then
		ParticleManager:DestroyParticle(ability.pfx2, false)
		ability.pfx2 = false
	end
end

function storm_weapon_b_b_end(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	if target.arkimus_b_b_pfx then
		ParticleManager:DestroyParticle(target.arkimus_b_b_pfx, false)
		ParticleManager:ReleaseParticleIndex(target.arkimus_b_b_pfx)
		target.arkimus_b_b_pfx = false
	end
end

function c_b_attack_landed(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target

	caster:RemoveModifierByName("modifier_arkimus_c_b_sprinting")
	caster:RemoveModifierByName("modifier_arkimus_speed_dash")
end

function arkimus_sprinting_think(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target

	local pfx = ParticleManager:CreateParticle("particles/roshpit/arkimus/sprint_fade.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	Timers:CreateTimer(0.4, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
end

function arkimus_spring_end(event)
	local ability = event.ability
	local caster = event.caster
	caster:RemoveModifierByName("modifier_animation_translate")
	caster:RemoveModifierByName("modifier_arkimus_c_b_attack_power")
end
