function start_channel(event)
	local caster = event.caster
	local ability = event.ability
	if caster:HasAbility("bahamut_arcana_ulti") then
		ability.a_d_level = Runes:GetTotalRuneLevel(caster, 1, "a_d_arcana1", "bahamut")
		ability.c_d_level = Runes:GetTotalRuneLevel(caster, 3, "c_d_arcana1", "bahamut")
		ability.d_d_level = Runes:GetTotalRuneLevel(caster, 4, "d_d_arcana1", "bahamut")
	end
	caster.d_c_level = Runes:GetTotalRuneLevel(caster, 4, "d_c", "bahamut")
	-- StartAnimation(caster, {duration=2, activity=ACT_DOTA_TAUNT, rate=1.5, translate="disco_gesture"})
end

function begin_bahamut_arcana_ult(event)
	local caster = event.caster
	local ability = event.ability
	local duration = Filters:GetAdjustedBuffDuration(caster, event.duration, false)
	ability.interval = 0
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_leshrac_arcana_effect", {duration = duration})
	local b_d_level = Runes:GetTotalRuneLevel(caster, 2, "b_d_arcana1", "bahamut")
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Bahamut.ArcanaUltActivate", caster)
	EmitSoundOn("Bahamut.ArcanaUltActivateVO", caster)
	if b_d_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_leshrac_arcana_b_d_effect", {duration = duration})
		caster:SetModifierStackCount("modifier_leshrac_arcana_b_d_effect", caster, b_d_level)
	end
	CustomAbilities:QuickAttachParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_start.vpcf", caster, 5)
	Filters:CastSkillArguments(4, caster)
end

function break_channel(event)
	local caster = event.caster
	local ability = event.ability
	-- EndAnimation(caster)
end

function leshrac_arcana_ult_effect_think(event)
	local caster = event.caster
	local ability = event.ability
	local damage = event.damage

	ability.interval = ability.interval + 1

	if ability.interval%5 == 0 then
		CustomAbilities:QuickAttachParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_start.vpcf", caster, 5)
	end

	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	local maxTargets = 1
	if ability.d_d_level > 0 then
		local procs = Runes:Procs(ability.d_d_level, 10, 1)
		maxTargets = maxTargets + procs
		maxTargets = math.min(maxTargets, #enemies)
	end
	if #enemies > 0 then
		for i = 1, maxTargets, 1 do
			CustomAbilities:QuickAttachParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_end.vpcf", enemies[i], 5)
			Timers:CreateTimer(0.3, function()
				leshrac_ult_go(ability, caster, damage, false, enemies[i])
			end)
		end
	end 
end

function leshrac_ult_go(ability, caster, damage, amp, enemy)
	if not ability.a_d_level then
		ability.a_d_level = Runes:GetTotalRuneLevel(caster, 1, "a_d_arcana1", "bahamut")
	end
	if not ability.c_d_level then
		ability.c_d_level = Runes:GetTotalRuneLevel(caster, 3, "c_d_arcana1", "bahamut")
	end
	if ability.c_d_level > 0 then
		damage = damage + ability.c_d_level*caster:GetAverageTrueAttackDamage(caster)*0.02
	end
	if amp then
		damage = damage*ability.a_d_level*0.05
	end
	Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PURE, 4, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
	ability:ApplyDataDrivenModifier(caster, enemy, "modifier_leshrac_arcana_slow", {duration = 0.2})
	EmitSoundOn("Bahamut.ArcanaUlt", enemy)

end