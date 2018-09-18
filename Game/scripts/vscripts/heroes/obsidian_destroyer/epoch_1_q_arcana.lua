require('/heroes/obsidian_destroyer/epoch_constants')

function epoch_arcana_q_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	local q_4_level = caster:GetRuneValue("q", 4)
	local procs = Runes:Procs(q_4_level, EPOCH_ARCANA_Q4_PROCS_PCT, 1)
	for i = 0, procs, 1 do
		Timers:CreateTimer(0.2*i, function()
			if i > 0 then
				StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_ATTACK, rate=1.2})
			end
			local pfx = ParticleManager:CreateParticle("particles/roshpit/epoch/arcana_ability_area.vpcf", PATTACH_CUSTOMORIGIN, caster)
			EmitSoundOnLocationWithCaster(target, "Epoch.ArcanaAbility.Cast", caster)
			local radius = 400 + q_4_level*5
			ParticleManager:SetParticleControl(pfx, 0, target+Vector(0,0,120))
			ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 100, radius))
			Timers:CreateTimer(3, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
			ability.q_3_level = caster:GetRuneValue("q", 3)
			local rootDuration = event.root_duration
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
			if #enemies > 0 then
				for _,enemy in pairs(enemies) do
					Filters:PerformAttackSpecial(caster, enemy, true, true, true, false, true, false, false)
					local alreadyHave = enemy:FindModifierByName("modifier_epoch_arcana_root")
					if not alreadyHave then 
						ability:ApplyDataDrivenModifier(caster, enemy, "modifier_epoch_arcana_root", {duration = rootDuration})
					end
				end
			end 
			Filters:CastSkillArguments(1, caster)
		end)
	end
end

function epoch_arcana_q_1_end(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local q_1_level = caster:GetRuneValue("q", 1)
	local damageMult = q_1_level*EPOCH_ARCANA_Q1_DMG_MULTI_PCT/100 + 0.05
	local typeCheck = type(target.epochArcanaAA)
	if typeCheck == "number" then
		local damage = target.epochArcanaAA*damageMult
		-- print("target.epochArcanaAA "..target.epochArcanaAA)

		ability:ApplyDataDrivenModifier(caster, caster, "modifier_backstab_jumping", {duration = 0.1})
		Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_PURE, 0, RPC_ELEMENT_NONE, RPC_ELEMENT_NONE)
		PopupDamage(target, damage)
		Timers:CreateTimer(0.03, function()
			caster:RemoveModifierByName("modifier_backstab_jumping")
		end)
		target.epochArcanaAA = false

		EmitSoundOn("Epoch.ArcanaAA.Trigger", target)
		local particleName = "particles/roshpit/epoch/arcana_a_a_xplosion.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target)
		for i = 0, 5, 1 do
			ParticleManager:SetParticleControlEnt(pfx, i, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		end
		ParticleManager:SetParticleControl(pfx, 6, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 10, target:GetAbsOrigin())
		Timers:CreateTimer(2.0, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	end
end

function epoch_arcana_q_3_damage_think(event)
	local caster = event.caster
	local ability = event.ability
	ability.q_3_level = caster:GetRuneValue("q", 3)
	if ability.q_3_level > 0 then
		local bonusDamage = math.floor(caster:GetMaxMana()*ability.q_3_level*EPOCH_ARCANA_Q3_EXTRA_BASE_ATT_DMG_PCT/100)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_epoch_arcana_attack_damage", {})
		caster:SetModifierStackCount("modifier_epoch_arcana_attack_damage", caster, bonusDamage)
	else
		caster:RemoveModifierByName("modifier_epoch_arcana_attack_damage")
	end
end

function epoch_arcana_q_3_get_damage(attacker, caster, reduceMana)
	local ability = caster:FindAbilityByName("epoch_rune_q_3_arcana1")
	local manaDrain = attacker:GetMaxMana() * EPOCH_ARCANA_Q3_BASE_MANA_DRAIN_PCT / 100
	local damage = 0
	if not ability then
		return false
	end
	if manaDrain > attacker:GetMana() then
		return nil
	end
	local q_3_level = attacker:GetRuneValue("q", 3)
	print("q_3_level: "..q_3_level)
	if q_3_level > 0 then
		if not attacker:HasModifier("modifier_epoch_q_3_lock") and reduceMana then
			ability:ApplyDataDrivenModifier(caster, attacker, "modifier_epoch_q_3_lock", {duration = 0.1})
			attacker:ReduceMana(manaDrain)
		end
		damage = manaDrain * q_3_level * EPOCH_ARCANA_Q3_DMG_MULTI_PCT
	end
	print("q_3_damage: "..damage)
	return damage
end

function epoch_arcana_q_3_strike(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if not target.dummy then
		Filters:TakeArgumentsAndApplyDamage(target, caster, ability.q_3_damage, DAMAGE_TYPE_PURE, 1, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)
	end
end