LinkLuaModifier("arkimus_archon_form_lua", "modifiers/arkimus/arkimus_archon_form_lua", LUA_MODIFIER_MOTION_NONE)
require('heroes/antimage/machinal_jump')

function start_channel(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Akrimus.Channel.VO", caster)
	StartSoundEvent("Arkimus.EnergyField.Channel", caster)
	
end

function channel_interrupt(event)
	local caster = event.caster
	StopSoundEvent("Arkimus.EnergyField.Channel", caster)
end

function channel_complete(event)
	local caster = event.caster
	local ability = event.ability
	local baseFV = caster:GetForwardVector()
	local duration = Filters:GetAdjustedBuffDuration(caster, event.duration, false)
	StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_4, rate=1})
	EmitSoundOn("Arkimus.EnergyField.VO", caster)
	StopSoundEvent("Arkimus.EnergyField.Channel", caster)

	if caster:HasAbility("ark_jump") then
		local jumpEventTable = {}
		jumpEventTable.caster = caster
		jumpEventTable.ability = caster:FindAbilityByName("ark_jump")
		jumpEventTable.target_points = {}
		jumpEventTable.target_points[1] = caster:GetAbsOrigin()
		jumpEventTable.special = true
		arkimus_jump_start(jumpEventTable)
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_arkimus_archon_form", {duration = duration})
	caster:AddNewModifier( caster, ability, "arkimus_archon_form_lua", {duration = duration} )
	caster:SetRangedProjectileName("particles/base_attacks/arkimus_archon_form.vpcf")
	Events:ColorWearablesAndBase(caster, Vector(0,0,0))
	caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
	ability.r_2_level = Runes:GetTotalRuneLevelGeneric(caster, 2, 3)
	if ability.r_2_level > 0 then
		local stats = caster:GetStrength() + caster:GetAgility() + caster:GetIntellect()
		local manaRegen = stats*0.01*ability.r_2_level
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_archone_b_d_mana_regen", {duration = duration})
		caster:SetModifierStackCount("modifier_archone_b_d_mana_regen", caster, manaRegen)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_archone_b_d_attack_power", {duration = duration})
	end
	ability.r_4_level = Runes:GetTotalRuneLevelGeneric(caster, 4, 3)
	EmitSoundOn("Arkimus.ArchonForm.Start", caster)
	Filters:CastSkillArguments(4, caster)

end

function archon_form_thinking(event)
	local caster = event.caster
	local ability = event.ability
	if ability.r_2_level > 0 then
		local atkPower = 0.05*caster:GetMana()*ability.r_2_level
		caster:SetModifierStackCount("modifier_archone_b_d_attack_power", caster, atkPower)
	end
end

function archon_form_end(event)
	local caster = event.caster
	local ability = event.ability

	caster:RemoveModifierByName("arkimus_archon_form_lua")
	Events:ColorWearablesAndBase(caster, Vector(255,255,255))
	caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
end

function archon_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if not ability.aoePosition then
		ability.aoePosition = Vector(0,0)
	end
	if WallPhysics:GetDistance2d(caster:GetAbsOrigin(), target:GetAbsOrigin()) <= caster:GetAttackRange()/2 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_archon_pushback", {duration = 1})
		local pushFV = ((caster:GetAbsOrigin()-target:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		ability.pushFV = pushFV
		ability.pushVelocity = 20
	end
	local a_d_level = Runes:GetTotalRuneLevelGeneric(caster, 1, 3)
	ability.r_1_level = a_d_level
	if caster:GetUnitName() == "seafortress_archon_wizard" then
		ability.r_1_level = 10
	end

	if ability.r_1_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_archon_a_d_field_thinker", {duration = 3})
		if WallPhysics:GetDistance2d(ability.aoePosition, target:GetAbsOrigin()) > 80 then
			if ability.pfx then
				ParticleManager:DestroyParticle(ability.pfx, false)
				ability.pfx = false
			end
			ability.pfx = ParticleManager:CreateParticle("particles/roshpit/arkimus/archon_flare_ambient.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(ability.pfx, 0, target:GetAbsOrigin())
			ParticleManager:SetParticleControl(ability.pfx, 1, Vector(220, 220, 220))
			ability.aoePosition = GetGroundPosition(target:GetAbsOrigin(), target) 
			EmitSoundOnLocationWithCaster(ability.aoePosition, "Arkimus.ArchonFlare.Start", caster)
			EmitSoundOn("Arkimus.ArchonFlare.Go", target)
		end
	end
end

function archon_slide_think(event)
	local caster = event.caster
	local ability = event.ability
	local newPosition = GetGroundPosition(caster:GetAbsOrigin()+ability.pushFV*ability.pushVelocity, caster)
	local afterWallPosition = WallPhysics:WallSearch(GetGroundPosition(caster:GetAbsOrigin(), caster), newPosition, caster)
	if afterWallPosition == newPosition then
		caster:SetAbsOrigin(newPosition)
	end
	ability.pushVelocity = ability.pushVelocity - 1
	if ability.pushVelocity <= 0 then
		caster:RemoveModifierByName("modifier_archon_pushback")
	end
end

function a_d_field_thinker_think(event)
	local caster = event.caster
	local ability = event.ability
	for i = 1, 2, 1 do 
		local flarePos = ability.aoePosition + RandomVector(RandomInt(0, 160))
		CustomAbilities:QuickParticleAtPoint("particles/roshpit/arkimus/archon_flare_ambient_hit.vpcf", flarePos, 1)
	end
	local damage = caster:GetAverageTrueAttackDamage(caster)*0.03*ability.r_1_level
    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), ability.aoePosition, nil, 220, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
    if #enemies > 0 then
    	local dividedDamage = damage/#enemies
        for _,enemy in pairs(enemies) do
        	if enemy.dummy then
        	else
        		Filters:TakeArgumentsAndApplyDamage(enemy, caster, dividedDamage, DAMAGE_TYPE_PURE, 4, RPC_ELEMENT_ARCANE, RPC_ELEMENT_NONE)
        	end
        end
    end 
end

function archon_a_d_end(event)
	local caster = event.caster
	local ability = event.ability
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ability.pfx = false
	end
end

function archon_init_seafortress(event)
	local caster = event.caster
	local ability = event.ability
	local baseFV = caster:GetForwardVector()

	StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_4, rate=1})

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_arkimus_archon_form", {})
	caster:AddNewModifier( caster, ability, "arkimus_archon_form_lua", {} )
	caster:SetRangedProjectileName("particles/base_attacks/arkimus_archon_form.vpcf")
	Events:ColorWearablesAndBase(caster, Vector(0,0,0))
	caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
	ability.r_4_level = 20
	EmitSoundOn("Arkimus.ArchonForm.Start", caster)
end