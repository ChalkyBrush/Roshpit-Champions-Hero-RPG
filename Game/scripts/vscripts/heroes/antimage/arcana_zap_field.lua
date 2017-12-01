require('heroes/antimage/zonis_spark')

function arcana_zap_field_precast(event)
	local caster = event.caster
	local ability = event.ability

	-- StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_CAST_ABILITY_4, rate=1.4, translate="basher"})
end

function arcana_zap_field_start(event)
	local caster = event.caster
	local ability = event.ability

	StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_CAST_ABILITY_4, rate=1.4, translate="slasher_mask"})
	Timers:CreateTimer(0.25, function()
		local avatarDuration = Filters:GetAdjustedBuffDuration(caster, event.duration, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_zap_field", {duration = avatarDuration})
	end)
	ability.b_a_level = Runes:GetTotalRuneLevelGeneric(caster, 2, 0)
	local d_a_level = Runes:GetTotalRuneLevelGeneric(caster, 4, 0)
	if d_a_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_arkimus_arcana1_q4", {duration = avatarDuration})
		caster:SetModifierStackCount("modifier_arkimus_arcana1_q4", caster, d_a_level)
	end
	Filters:CastSkillArguments(1, caster)
end
function zap_field_modifier_start(event)
	local caster = event.caster
	local ability = event.ability

	if not ability.pfx then
		local pfx = ParticleManager:CreateParticle("particles/roshpit/arkimus/arcana_zap_field.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(500, 10, 500))
		ParticleManager:SetParticleControl(pfx, 2, caster:GetAbsOrigin()+Vector(0,0,160))
		ParticleManager:SetParticleControl(pfx, 5, caster:GetAbsOrigin())
		ability.pfx = pfx
	end
end

function zap_field_modifier_thinker(event)
	local caster = event.caster
	local ability = event.ability
	if not ability then
		if ability.pfx then
			ParticleManager:DestroyParticle(ability.pfx, true)
		end
		caster:RemoveModifierByName("modifier_zap_field")
		return false
	end
	if not ability.interval then
		ability.interval = 0
	end
	if not ability.particleCount then
		ability.particleCount = 0
	end
	ability.interval = ability.interval + 1
	if ability.interval == 6 then
		ability.interval = 0
		local damage = event.damage + event.int_damage * caster:GetIntellect()
		local searchRadius = 500
	    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, searchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	    if #enemies > 0 then
	    	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Arkimus.ZonisLightning", caster)
	        for _,enemy in pairs(enemies) do
	        	if ability.particleCount < 16 then
	        		ability.particleCount = ability.particleCount + 1
	        		CreateZonisBeam(caster:GetAbsOrigin()+Vector(0,0,120), enemy:GetAbsOrigin()+Vector(0,0,50))
	        		Timers:CreateTimer(0.5, function()
	        			ability.particleCount = ability.particleCount - 1
	        		end)
	        	end
	        	ability:ApplyDataDrivenModifier(caster, enemy, "modifier_zonis_stun_arcana1", {duration = 0.2})
	        	Filters:ApplyStun(caster, 0.2, enemy)
	        	Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 0, RPC_ELEMENT_ARCANE, RPC_ELEMENT_LIGHTNING)
	        end
	    end 
	end
	ParticleManager:SetParticleControl(ability.pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(ability.pfx, 2, caster:GetAbsOrigin()+Vector(0,0,160))
	ParticleManager:SetParticleControl(ability.pfx, 5, caster:GetAbsOrigin())
end

function zap_field_modifier_end(event)
	local caster = event.caster
	local ability = event.ability
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ParticleManager:ReleaseParticleIndex(ability.pfx)
		ability.pfx = false
	end
	caster:RemoveModifierByName("modifier_arkimus_arcana1_q4")
end

function damage_taken(event)
	local caster = event.caster
	local ability = event.ability
	local damage = event.damage

	local a_a_level = Runes:GetTotalRuneLevelGeneric(caster, 1, 0)
	if a_a_level > 0 then
		local manaRestore = math.ceil(damage*0.01*a_a_level/100)
    	caster:GiveMana(manaRestore)
		PopupMana(caster, manaRestore)

		CustomAbilities:QuickAttachParticle("particles/items3_fx/mango_active.vpcf", caster, 1)		
	end
	local c_a_level = Runes:GetTotalRuneLevelGeneric(caster, 3, 0)
	if c_a_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_arkimus_arcana1_q3", {duration = 3})
		local newStacks = math.min(caster:GetModifierStackCount("modifier_arkimus_arcana1_q3", caster) + 1, c_a_level * 3)
		caster:SetModifierStackCount("modifier_arkimus_arcana1_q3", caster, newStacks)
		ability.c_a_stacks = newStacks
	end
end

function q3_destroy(event)
	local caster = event.caster
	local ability = event.ability
	if ability.c_a_stacks > 0 then
		ability.c_a_stacks = ability.c_a_stacks - 1
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_arkimus_arcana1_q3", {duration = 5})
		caster:SetModifierStackCount("modifier_arkimus_arcana1_q3", caster, ability.c_a_stacks)
	end
end