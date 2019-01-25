require('heroes/spirit_breaker/duskbringer_1_q')
require('/heroes/spirit_breaker/duskbringer_constants')

function begin_ghost_hallow(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	Filters:CastSkillArguments(2, caster)
	EmitSoundOnLocationWithCaster(target, "Duskbringer.GhostHallow", caster)
	--ability:ApplyDataDrivenThinker(caster, GetGroundPosition(target, caster), "ghost_hallow", {duration = 6})
	CustomAbilities:QuickAttachThinker(ability, caster, GetGroundPosition(target, caster), "ghost_hallow", {duration = 6})
	StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_ATTACK, rate=2.1})
end

function ghost_trap_enter(event)
	-- print("test duskbringer w1")
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local duration = event.duration
	if not target.ghost_hallow_think_interval then target.ghost_hallow_think_interval = 0 end
	if event.apply == 0 then
		target.ghost_hallow_think_interval = target.ghost_hallow_think_interval + 1
	end
	if not target:HasModifier("modifier_ghost_trap_immune") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_ghost_trap_immune", {duration = duration+3})
		ability:ApplyDataDrivenModifier(caster, target, "ghost_hallow_stun", {duration = duration})
		local w_2_level = caster:GetRuneValue("w", 2)
		if w_2_level > 0 then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_ghost_hallow_magic_resist_loss", {duration = duration})
			target:SetModifierStackCount("modifier_ghost_hallow_magic_resist_loss", caster, w_2_level)
		end
		if caster:HasModifier("modifier_duskbringer_glyph_4_1") then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_ghost_hallow_disarm", {duration = duration})
		end
	end
	if target.ghost_hallow_think_interval%10 == 0 or event.apply == 1 then
		local w_1_level = caster:GetRuneValue("w", 1)
		ghost_trap_a_b_thinker(event)
		if w_1_level > 0 then
			if not target.duskABparticle then
				target.duskABparticle = CustomAbilities:QuickAttachParticle("particles/roshpit/duskbringer/duskbringer_rune_a_b.vpcf", target, 10)
				ParticleManager:SetParticleControl(target.duskABparticle, 1, target:GetForwardVector()*150)
			end
		end
	end
end

function ghost_trap_end(event)
	local caster = event.caster
	local target = event.target
	if target.duskABparticle then
		ParticleManager:DestroyParticle(target.duskABparticle, true)
		target.duskABparticle = nil
		local pfx = ParticleManager:CreateParticle( "particles/roshpit/mountain_protector/unshakable_stone_dust.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin()+Vector(0,0,20))
		ParticleManager:SetParticleControl(pfx, 5, Vector(0.5, 1, 1))
		ParticleManager:SetParticleControl(pfx, 2, Vector(0.1,0.1,0.1))
		Timers:CreateTimer(1, function() 
		  ParticleManager:DestroyParticle( pfx, false )
		  ParticleManager:ReleaseParticleIndex(pfx)
		end)
	end
	target.ghost_hallow_think_interval = nil
end

function ghost_trap_a_b_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local w_1_level = caster:GetRuneValue("w", 1)
	if w_1_level > 0 then
		local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * w_1_level * DUSKBRINGER_W1_DMG_PER_ATT
		Timers:CreateTimer(0.15, function()
			if target:IsAlive() then
				CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash_flash.vpcf", target:GetAbsOrigin()+Vector(0,0,40), 0.2)
				Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_GHOST, RPC_ELEMENT_NONE)
				EmitSoundOn("Duskbringer.GhostHallowAB", target)
			end

		end)
	end
end

function ghost_hallow_think(event)
	local target = event.target
	local caster = event.caster
	local ability = caster:FindAbilityByName("whirling_flail")
	local q_1_level = caster:GetRuneValue("q", 1)
	if caster:HasModifier("modifier_duskbringer_glyph_2_1") and q_1_level > 0 then
		increment_duskfire_stacks(caster, target, ability, DUSKBRINGER_GLYPH_2_1_STACKS_PER_SEC)
	end
end

function duskbringer_rune_w_3_take_damage(event)
	local target = event.caster
	local ability = event.ability
	local w_3_level = event.caster:GetRuneValue("w", 3)
	if w_3_level > 0 then
		Timers:CreateTimer(0.06, function()
			if target:IsAlive() then
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_oracle/duskbringer_c_a_heal_heal_core.vpcf", target, 1)
				local healAmount = w_3_level * DUSKBRINGER_W3_HEAL
				Filters:ApplyHeal(target, target, healAmount, true)
			end
		end)
	end
end