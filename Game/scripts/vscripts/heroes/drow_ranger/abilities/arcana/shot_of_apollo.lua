require('heroes/moon_ranger/init')

function beginChannel(event)
	local particleName = "particles/roshpit/astral/apollo_beam.vpcf"
	local particleName2 = "particles/econ/items/lion/lion_demon_drain/lion_spell_mana_drain_demon.vpcf"
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_apollo_channel", {duration = 2})
	StartAnimation(caster, {duration=2.0, activity=ACT_DOTA_GENERIC_CHANNEL_1, rate=0.8})
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_bow_eyes", caster:GetAbsOrigin(), true)
	for i = 0, 60, 1 do
		Timers:CreateTimer(i*0.03, function()
				local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), target:GetAbsOrigin())/2
				local direction = ((target:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
			ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin()+direction*distance+Vector(0,0,(1250/40)*i))
		end)
	end
	if caster:HasModifier("modifier_apollo_channel") then
		print("WHAT??")
		local pfx2 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
		ParticleManager:SetParticleControlEnt(pfx2, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		for i = 0, 60, 1 do
			Timers:CreateTimer(i*0.03, function()
				local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), target:GetAbsOrigin())/2
				local direction = ((caster:GetAbsOrigin()-target:GetAbsOrigin())*Vector(1,1,0)):Normalized()
				ParticleManager:SetParticleControl(pfx2, 1, target:GetAbsOrigin()+direction*distance+Vector(0,0,(1250/40)*i))
			end)
		end
		ability.pfx2 = pfx2
	end
	ability.pfx = pfx
	StartSoundEvent("Astral.ApolloStart", caster)
	ability.a_b_level = Runes:GetTotalRuneLevelGeneric(caster, 1, 1)
	ability.c_b_level = Runes:GetTotalRuneLevelGeneric(caster, 3, 1)
	ability.d_b_level = Runes:GetTotalRuneLevelGeneric(caster, 4, 1)
end

function channel_interrupt(event)
	local caster = event.caster
	local ability = event.ability
	EndAnimation(caster)
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ability.pfx = false
	end
	if ability.pfx2 then
		ParticleManager:DestroyParticle(ability.pfx2, false)
		ability.pfx2 = false
	end
	StopSoundEvent("Astral.ApolloStart", caster)
end

function beginCast(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local shots = event.shots
	if caster:HasModifier("modifier_astral_glyph_3_1") then
		shots = 9
	end
	local b_b_level = Runes:GetTotalRuneLevelGeneric(caster, 2, 1)
	shots = shots + Runes:Procs(b_b_level, 2*ability:GetLevel(), 1)
	ability.shots = shots
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ability.pfx = false
	end
	if ability.pfx2 then
		ParticleManager:DestroyParticle(ability.pfx2, false)
		ability.pfx2 = false
	end
	local pfx = ParticleManager:CreateParticle("particles/roshpit/astral/apollo_beam.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_bow_eyes", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	local pfx2 = ParticleManager:CreateParticle("particles/roshpit/astral/apollo_beam.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(pfx2, 1, caster, PATTACH_POINT_FOLLOW, "attach_bow_eyes", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx2, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	Timers:CreateTimer(0.4, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:DestroyParticle(pfx2, false)
	end)
	EmitSoundOn("Astral.ApolloLink", target)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_apollo_strikes", {})
	target:SetModifierStackCount("modifier_apollo_strikes", caster, shots)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_apollo_outgoing_shots", {})
	caster:SetModifierStackCount("modifier_apollo_outgoing_shots", caster, shots)
	ability:SetActivated(false)
	Filters:CastSkillArguments(2, caster)
end

function apollo_end(event)
	local caster = event.caster
	local ability = event.ability
	ability:SetActivated(true)
end

function apollo_debuff_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if IsValidEntity(ability) then
		if target:IsAlive() then
			Filters:PerformAttackSpecial(caster, target, true, true, true, false, true, false, false)
			local manaCost = ability:GetManaCost(ability:GetLevel())
			caster:ReduceMana(manaCost)
			local newStacks = target:GetModifierStackCount("modifier_apollo_strikes", caster) - 1
			if newStacks == 0 then
				target:RemoveModifierByName("modifier_apollo_strikes")
			else
				target:SetModifierStackCount("modifier_apollo_strikes", caster, newStacks)
			end
			StartAnimation(caster, {duration=0.1, activity=ACT_DOTA_ATTACK, rate=4})
			if ability.a_b_level > 0 then
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_apollo_stats_visible", {duration = 8})
				local newStacks = math.min(100, caster:GetModifierStackCount("modifier_apollo_stats_visible", caster) + 1)
				caster:SetModifierStackCount("modifier_apollo_stats_visible", caster, newStacks)
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_apollo_stats_invisible", {duration = 8})
				caster:SetModifierStackCount("modifier_apollo_stats_invisible", caster, newStacks*ability.a_b_level)
			end
			if ability.d_b_level > 0 then
				if not ability.d_b_target then
					ability.d_b_target = target
				end
				if ability.d_b_target == target then
					ability:ApplyDataDrivenModifier(caster, caster, "modifier_apollo_post_mit_visible", {duration = 8})
					local newStacks = math.min(50, caster:GetModifierStackCount("modifier_apollo_post_mit_visible", caster) + 1)
					caster:SetModifierStackCount("modifier_apollo_post_mit_visible", caster, newStacks)
					ability:ApplyDataDrivenModifier(caster, caster, "modifier_apollo_post_mit_invisible", {duration = 8})
					caster:SetModifierStackCount("modifier_apollo_post_mit_invisible", caster, newStacks*ability.d_b_level)
				else
					ability.d_b_target = target
					caster:RemoveModifierByName("modifier_apollo_post_mit_visible")
					caster:RemoveModifierByName("modifier_apollo_post_mit_invisible")
				end
			end
		else

		end
	else
		target:RemoveModifierByName("modifier_apollo_strikes")
	end
end

function apollo_target_die(event)
	local target = event.unit
	local ability = event.ability
	local caster = event.caster
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	if #enemies > 0 then
		local newTarget = enemies[1]
		local stacks = ability.shots
		target:RemoveModifierByName("modifier_apollo_strikes")
		ability:ApplyDataDrivenModifier(caster, newTarget, "modifier_apollo_strikes", {})
		newTarget:SetModifierStackCount("modifier_apollo_strikes", caster, stacks)
	end 
end

function apollo_attack_landed(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local attacker = event.attacker
	if attacker == caster then
		if target:IsAlive() then
			local newStacks = caster:GetModifierStackCount("modifier_apollo_outgoing_shots", caster) - 1
			caster:SetModifierStackCount("modifier_apollo_outgoing_shots", caster, newStacks)
			if newStacks == 0 then
				caster:RemoveModifierByName("modifier_apollo_outgoing_shots")
			end
			ability.shots = ability.shots - 1
			if ability.c_b_level > 0 then
			    if caster:HasModifier("modifier_astral_glyph_3_1") then
			        empyralArrowsProcChance = getProcChance(caster, T31_PROC_CHANCE)
			    else
			        empyralArrowsProcChance = getProcChance(caster, W3_PROC_CHANCE)
			    end
			    local procChance = getProcChance(caster, empyralArrowsProcChance)
			    local luck = RandomInt(1, 100)
			    if luck <= procChance then
					CustomAbilities:QuickAttachParticle("particles/roshpit/astral/apollo_proc_start_ti7_lvl2.vpcf", target, 1)
					local damage = caster:GetAverageTrueAttackDamage(caster)*0.12*ability.c_b_level
					Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_COSMOS, RPC_ELEMENT_NONE)
					ability:ApplyDataDrivenModifier(caster, target, "modifier_apollo_c_b_proc_visible", {duration = 10})
					local newStacks = target:GetModifierStackCount("modifier_apollo_c_b_proc_visible", caster) + 1
					target:SetModifierStackCount("modifier_apollo_c_b_proc_visible", caster, newStacks)
					ability:ApplyDataDrivenModifier(caster, target, "modifier_apollo_c_b_proc_invisible", {duration = 10})
					target:SetModifierStackCount("modifier_apollo_c_b_proc_invisible", caster, newStacks*ability.c_b_level)
					EmitSoundOn("Astral.ApolloProc", target)
			    end
			end
		end
	end
end