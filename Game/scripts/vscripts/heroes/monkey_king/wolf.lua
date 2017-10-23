require('/heroes/monkey_king/constants')

LinkLuaModifier("modifier_draghor_feral_sprint", "modifiers/draghor/modifier_draghor_feral_sprint", LUA_MODIFIER_MOTION_NONE)

function wolf_howl_pre(event)
	local caster = event.caster
	EmitSoundOn("Draghor.WolfHowl", caster)

	StartAnimation(caster, {duration=2.3, activity=ACT_DOTA_CAST_ABILITY_2, rate=0.4})

end

function wolf_howl(event)
	local caster = event.caster
	local ability = event.ability
	local duration = event.duration
	local b_a_level = Runes:GetTotalRuneLevelGeneric(caster, 2, 0)
	duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
	local pfx = CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lycan/lycan_howl_cast.vpcf", caster, 3)
	ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 2, caster:GetAbsOrigin()+caster:GetForwardVector()*200)
	local allies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false )
	if #allies > 0 then
		EmitSoundOn("Draghor.WolfHowl.Activate", caster)
		for _,ally in pairs(allies) do
			local modifierName = "modifier_wolf_howl_ally"
			local b_a_multiple = 1
			if ally:GetEntityIndex() == caster:GetEntityIndex() or ally:GetOwner() == caster:GetOwner() then
				modifierName = "modifier_wolf_howl"
				b_a_multiple = DJANGHOR_Q2_SELF_MULTIPLE
			end
			ability:ApplyDataDrivenModifier(caster, ally, modifierName, {duration = duration})
			if b_a_level > 0 then
				ability:ApplyDataDrivenModifier(caster, ally, "modifier_wolf_howl_flat_b_b", {duration = duration})
				ally:SetModifierStackCount("modifier_wolf_howl_flat_b_b", caster, b_a_level*b_a_multiple)
			end
		end
	end
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_explosion_wave.vpcf", caster, 1.2)
	CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_lone_druid/hermit_roar.vpcf", caster:GetAbsOrigin()+Vector(0,0,20), 1.2)
	Filters:CastSkillArguments(1, caster)
end

function wolf_sprint(event)
	local caster = event.caster
	local ability = event.ability
	local duration = event.duration
	local d_c_level = Runes:GetTotalRuneLevelGeneric(caster, 4, 2)
	if d_c_level > 0 then
		duration = duration + d_c_level*DJANGHOR_E4_DURATION_INCREASE
	end
	StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_CAST_ABILITY_1, rate=1.5})
	duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_wolf_sprint", {duration = duration})
	caster:AddNewModifier( caster, ability, "modifier_draghor_feral_sprint", {duration = duration} )
	EmitSoundOn("Draghor.Wolf.FeralHaste", caster)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_wolf_slide_burst", {duration = 1.0})
	caster:SetModifierStackCount("modifier_wolf_slide_burst", caster, 200)
      local pfx = ParticleManager:CreateParticle( "particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
      ParticleManager:SetParticleControl( pfx, 0, caster:GetAbsOrigin())
      ParticleManager:SetParticleControl( pfx, 1, Vector(200, 200, 200) )
      Timers:CreateTimer(2, function()
        ParticleManager:DestroyParticle(pfx, false)
      end)

      local pfx2 = ParticleManager:CreateParticle( "particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
      ParticleManager:SetParticleControl( pfx2, 0, caster:GetAbsOrigin()+caster:GetForwardVector()*80)
      ParticleManager:SetParticleControl( pfx2, 1, Vector(200, 200, 200) )
      Timers:CreateTimer(2, function()
        ParticleManager:DestroyParticle(pfx2, false)
      end)
      for i = 1, 5, 1 do
      	Timers:CreateTimer(0.25*i, function()
		  local pfxExtra = ParticleManager:CreateParticle( "particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
		  ParticleManager:SetParticleControl( pfxExtra, 0, caster:GetAbsOrigin())
		  ParticleManager:SetParticleControl( pfxExtra, 1, Vector(200, 200, 200) )
		  Timers:CreateTimer(2, function()
		    ParticleManager:DestroyParticle(pfxExtra, false)
		  end)
		end)
      end
      Filters:CastSkillArguments(3, caster)
end

function wolf_slide_think(event)
	local caster = event.caster
	local ability = event.ability
	local currentStacks = caster:GetModifierStackCount("modifier_wolf_slide_burst", caster)
	caster:SetModifierStackCount("modifier_wolf_slide_burst", caster, currentStacks - 4)
end

function rend_phase(event)
	local caster = event.caster
	local ability = event.ability

	CustomAbilities:QuickAttachParticle("particles/roshpit/draghor/wolf_rend_preb.vpcf", caster, 3)
	EmitSoundOn("Draghor.Wolf.RendSwing", caster)
	StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_ATTACK, rate=2.0})
end

function rend_start(event)
	local caster = event.caster
	local ability = event.ability

	local position = caster:GetAbsOrigin()
	local damage = caster:GetAverageTrueAttackDamage(caster)*(event.damage_mult/100)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin()+caster:GetForwardVector()*180, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
	local element1 = RPC_ELEMENT_NORMAL
	local element2 = RPC_ELEMENT_NONE
	if caster:HasModifier("modifier_djanghor_immortal_weapon_1") then
        local pfx = ParticleManager:CreateParticle( "particles/roshpit/dreghor/jinbo_heavy.vpcf", PATTACH_POINT, caster )
        ParticleManager:SetParticleControl(0, pfx, caster:GetAbsOrigin())
        -- ParticleManager:SetParticleControl(1, pfx, caster:GetAbsOrigin()+endFV*range)
        ParticleManager:SetParticleControl(2, pfx, Vector(range, 0, 0))
		Timers:CreateTimer(4, function() 
		  ParticleManager:DestroyParticle( pfx, false )
		end)
		local element1 = RPC_ELEMENT_NATURE
		local element2 = RPC_ELEMENT_NONE
		local endFV = caster:GetForwardVector()
		local range = 1200
		EmitSoundOn("Draghor.RendRange", caster)
		enemies = FindUnitsInLine(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster:GetAbsOrigin()+endFV*range, nil, 240, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)		
	end
	if #enemies > 0 then
		EmitSoundOn("Draghor.Wolf.RendHitBasic", enemies[1])
		local bBloodSound = false	
		for _,enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, 2, element1, element2)

			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_wolf_rend_stack", {duration = 8})
			local rendStacks = enemy:GetModifierStackCount("modifier_wolf_rend_stack", caster)
			local newStacks = math.min(2, rendStacks+1)
			enemy:SetModifierStackCount("modifier_wolf_rend_stack", caster, newStacks)

			local armorLoss = (enemy:GetPhysicalArmorValue()+enemy:GetModifierStackCount("modifier_wolf_rend_armor_loss", caster))*0.5
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_wolf_rend_armor_loss", {duration = 8})
			enemy:SetModifierStackCount("modifier_wolf_rend_armor_loss", caster, armorLoss*newStacks)
			if rendStacks == 2 then
				enemy.rendBleed = event.bleed_damage*damage/100
				ability.b_b_level = Runes:GetTotalRuneLevelGeneric(caster, 2, 1)
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_wolf_rend_bleed", {duration = 12})
				local particleName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
				local pfx = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, enemy )
				ParticleManager:SetParticleControlEnt(pfx, 0, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", enemy:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(pfx, 1, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", enemy:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(pfx, 2, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", enemy:GetAbsOrigin(), true)
				Timers:CreateTimer(3, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)
				bBloodSound = true
			end
		end	
		if bBloodSound then
			EmitSoundOnLocationWithCaster(enemies[1]:GetAbsOrigin(), "Draghor.Wolf.RendBleed", caster)
		end			
	end 
	Filters:CastSkillArguments(2, caster)
end

function rend_bleed_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local damage = target.rendBleed
	Filters:ApplyDotDamage(caster, ability, target, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
end