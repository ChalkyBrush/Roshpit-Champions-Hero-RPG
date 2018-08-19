function turn_toggle_on(event)
	local caster = event.caster
	local ability = event.ability
	-- StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_TELEPORT_END, rate=1.6}) W1 COUNTER HELIX MAYBE??

	arcana1_b_b_spin(caster, ability, 1)
	CustomAbilities:QuickAttachParticle("particles/econ/courier/courier_kunkka_parrot/courier_kunkka_parrot_splash.vpcf", caster, 2)
	Filters:CastSkillArguments(2, caster)
end

function turn_toggle_off(event)
	local caster = event.caster
	local ability = event.ability
	-- StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_TELEPORT_END, rate=1.6}) W1 COUNTER HELIX MAYBE??

	-- arcana1_b_b_spin(caster, ability)
end

function mist_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	increment_d_b_stacks(caster, 1, ability)
end

function increment_d_b_stacks(caster, count, ability)
	local w_4_level = Runes:GetTotalRuneLevelGeneric(caster, 4, 1)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_hydroxis_d_b_arcana_visible", {duration = 10})
	local newStacks = math.min(caster:GetModifierStackCount("modifier_hydroxis_d_b_arcana_visible", caster) + count, 30)
	caster:SetModifierStackCount("modifier_hydroxis_d_b_arcana_visible", caster, newStacks)

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_hydroxis_d_b_arcana_invisible", {duration = 10})
	caster:SetModifierStackCount("modifier_hydroxis_d_b_arcana_invisible", caster, newStacks*w_4_level)
end

function arcana1_b_b_spin(caster, ability, amp)
	local w_2_level = Runes:GetTotalRuneLevelGeneric(caster, 2, 1)
	if w_2_level > 0 then
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hydroxis.Arcana.SpinWoosh",caster)
		StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_TELEPORT_END, rate=1.0})
		CustomAbilities:QuickAttachParticle("particles/roshpit/hydroxis/arcana_spin_blade.vpcf", caster, 2)
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 320, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		local damage = w_2_level*caster:GetAverageTrueAttackDamage(caster)*0.1*amp
		if #enemies > 0 then
			increment_d_b_stacks(caster, #enemies, ability)
			EmitSoundOn("Hydroxis.Arcana.SpinImpact", enemies[1])
			for _,enemy in pairs(enemies) do
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, 2, RPC_ELEMENT_WATER, RPC_ELEMENT_FIRE)
			end				
		end 		
	else
		StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_FORCESTAFF_END, rate=1.6})
	end
end


function drift_start(event)
	local caster = event.caster
	local ability = event.ability
	ability.moveSpeed = 30
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_hydroxis_slither", {duration = 1})
	StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_RUN, rate=1.5})
	caster:AddNewModifier(caster, nil, "modifier_animation", {translate="sprint", duration = 1})
end

function slither_think(event)
	local caster = event.caster
	local ability = event.ability
	local newPos = caster:GetAbsOrigin()+caster:GetForwardVector()*ability.moveSpeed
	local obstruction = WallPhysics:FindNearestObstruction(caster:GetAbsOrigin())
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPos, caster)
	if blockUnit then
		caster:SetAbsOrigin(caster:GetAbsOrigin()-caster:GetForwardVector()*40)
		ability:ToggleAbility()
	else
		caster:SetAbsOrigin(GetGroundPosition(newPos, caster))
	end
	ability.moveSpeed = math.max(ability.moveSpeed-1, 0)
	if ability.moveSpeed == 0 then
		caster:RemoveModifierByName("modifier_hydroxis_slither")
	end
end

function slither_start(event)
	local caster = event.caster
	local ability = event.ability
	
end

function slither_end(event)
	local caster = event.caster
	local ability = event.ability
	caster:RemoveModifierByName("modifier_animation")
end

function mist_start(event)
	local caster = event.caster
	EmitSoundOn("Hydroxis.Arcana.MistStart", caster)
end

function mist_end(event)
end

function mist_active_think(event)
	local caster = event.caster
	local ability = event.ability
	local manaDrain = event.mana_drain
	if caster:GetMana() > manaDrain then
		caster:ReduceMana(manaDrain)
	else
		ability:ToggleAbility()
	end
end

function mist_death(event)
	local caster = event.caster
	local ability = event.ability
	print(" THIS SHIZ?")
	Timers:CreateTimer(0.03, function()
		caster:RemoveModifierByName("modifier_hydroxis_mist")
	end)
end