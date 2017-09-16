function initialize_seraph_surge(event)
	local caster = event.caster
	local ability = event.ability
	local duration = event.duration
	duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
	EmitSoundOn("Auriun.HeavensShield", caster)
	
	local b_c_level = Runes:GetTotalRuneLevel(caster, 2, "b_c", "auriun")
	if caster:HasModifier("modifier_auriun_glyph_5_1") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_seraph_surge_glyphed", {duration = duration})
	else
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_seraph_surge", {duration = duration})
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_seraph_surge_flying_portion", {duration = duration})
	-- if a_c_level > 0 then
	-- 	local runeUnit = caster.runeUnit
	-- 	local runeAbility = runeUnit:FindAbilityByName("auriun_rune_a_c")
	-- 	runeAbility.a_c_level = a_c_level
	-- 	runeAbility:ApplyDataDrivenModifier(runeUnit, caster, "modifier_auriun_rune_a_c", {duration = duration})
	-- end
	if b_c_level > 0 then
		local runeUnit = caster.runeUnit2
		local runeAbility = runeUnit:FindAbilityByName("auriun_rune_b_c")
		local b_c_buffDuration = Filters:GetAdjustedBuffDuration(caster, 8, false)

		runeAbility:ApplyDataDrivenModifier(runeUnit, caster, "modifier_auriun_rune_b_c", {duration = b_c_buffDuration})
		caster:SetModifierStackCount( "modifier_auriun_rune_b_c", runeAbility, b_c_level)
		Timers:CreateTimer(b_c_buffDuration-0.06, function()
			runeAbility.manaPercent = caster:GetMana()/caster:GetMaxMana()
		end)
	end
	local d_c_level = Runes:GetTotalRuneLevel(caster, 4, "d_c", "auriun")
	if d_c_level > 0 then
		d_c(caster, d_c_level)
	end

	quickParticle("particles/roshpit/auriun/seraph_surge.vpcf", caster, 2.5)
	
	local particleName = "particles/units/heroes/hero_oracle/holy_heal_heal_core.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)

	Timers:CreateTimer(0.5, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	end) 
	StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_CAST_ABILITY_4, rate=1})
	Filters:CastSkillArguments(3, caster)
	ProjectileManager:ProjectileDodge(caster)
end

function quickParticle(particleName, target, destroyTime)
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(pfx, 2, Vector(170, 170, 150))
	Timers:CreateTimer(destroyTime, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	  ParticleManager:ReleaseParticleIndex(pfx)
	end) 	
	return pfx
end

function d_c(caster, d_c_level)

      local particleName = "particles/items_fx/auriun_d_c_spawn.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	Timers:CreateTimer(5, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	end) 	

      EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Auriun.OverwhelmingLight", caster)
      for i = 0, 0, 1 do
      	Timers:CreateTimer(0.1*i, function()
		      local particleName2 = "particles/units/heroes/hero_disruptor/disruptor_thunder_strike_bolt.vpcf"
		      local particle2 = ParticleManager:CreateParticle( particleName2, PATTACH_CUSTOMORIGIN, caster )
		      ParticleManager:SetParticleControl( particle2, 0, caster:GetAbsOrigin()+Vector(0,0,70) )
		      ParticleManager:SetParticleControl( particle2, 1, Vector(400, 0, 0) )
		      Timers:CreateTimer(1, 
		      function()
		        ParticleManager:DestroyParticle( particle2, false )
		      end)
	      end)
  		end
  	Timers:CreateTimer(0.05, function()
	  	local radius = 520
	  	local stunDuration = 0.5+d_c_level*0.1
	  	local damage = caster:GetIntellect()*8*d_c_level
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				Filters:ApplyStun(caster, stunDuration, enemy)
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 3, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
				local particle = ParticleManager:CreateParticle("particles/roshpit/paladin/crusader_bolt_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, enemy)
				ParticleManager:SetParticleControl(particle, 0, Vector(enemy:GetAbsOrigin().x,enemy:GetAbsOrigin().y,enemy:GetAbsOrigin().z))
				ParticleManager:SetParticleControl(particle, 1, Vector(enemy:GetAbsOrigin().x,enemy:GetAbsOrigin().y,enemy:GetAbsOrigin().z+1500))
				ParticleManager:SetParticleControl(particle, 2, Vector(enemy:GetAbsOrigin().x,enemy:GetAbsOrigin().y,enemy:GetAbsOrigin().z))
				Timers:CreateTimer(1, function()
					ParticleManager:DestroyParticle(particle, false)
				end)
			end
		end
		-- local particleName3 = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
		-- local pfx2 = ParticleManager:CreateParticle( particleName3, PATTACH_ABSORIGIN, caster )
		-- ParticleManager:SetParticleControl( pfx2, 0, caster:GetAbsOrigin() )
		-- ParticleManager:SetParticleControl( pfx2, 1, Vector(520,520,520) )
		-- ParticleManager:SetParticleControl( pfx2, 2, Vector(2,2,2) )
		-- ParticleManager:SetParticleControl( pfx2, 4, Vector(255,255,255) )
		-- Timers:CreateTimer(2, function() 
		--   ParticleManager:DestroyParticle( pfx2, false )
		-- end) 	
  	end)
end

function surging_think(event)
	local caster = event.caster
	local newPos = caster:GetAbsOrigin()+caster:GetForwardVector()*70
	local obstruction = WallPhysics:FindNearestObstruction(caster:GetAbsOrigin())
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPos, caster)
	if blockUnit then
		caster:SetAbsOrigin(caster:GetAbsOrigin()-caster:GetForwardVector()*60)
		caster:RemoveModifierByName("modifier_seraph_surge_flying_portion")
	end
end

function a_c_think(event)
	local caster = event.target
	local particleName = "particles/units/heroes/hero_oracle/auriun_a_c.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)

	Timers:CreateTimer(0.5, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	end) 	
	local totalLevel = event.ability.a_c_level
	local manaRestore = totalLevel * 30
	PopupMana(caster, manaRestore)
	caster:GiveMana(manaRestore)
end

function rune_unit_3_think(event)
	local caster = event.caster
	local ability = event.ability
	local hero = caster.hero
	local totalLevel = Runes:GetTotalRuneLevel(hero, 3, "c_c", "auriun")
	if totalLevel > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_auriun_rune_c_c_effect", {})
		hero:SetModifierStackCount( "modifier_auriun_rune_c_c_effect", ability, totalLevel )
	end
end

function auriun_b_c_end(event)
	local caster = event.caster
	local ability = event.ability
	local manaPercent = ability.manaPercent
	Timers:CreateTimer(0.05, function()
		caster:SetMana(caster:GetMaxMana()*manaPercent)
	end)
end

function shadow_flay_effect_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	local damage = caster.hero:GetIntellect()*100
	local heal = math.floor(damage/100)

	Filters:ApplyItemDamage(target,caster.hero,damage,DAMAGE_TYPE_MAGICAL,ability,RPC_ELEMENT_SHADOW,RPC_ELEMENT_NONE)

	caster.hero:Heal(heal, caster.hero)
	PopupHealing(caster.hero, heal)
end

function shadow_flay_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if not target.shadowFlayPFX then
		target.shadowFlayPFX = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/tether_purple.vpcf", PATTACH_OVERHEAD_FOLLOW, caster.hero)
		ParticleManager:SetParticleControlEnt(target.shadowFlayPFX, 0, target, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", target:GetAbsOrigin()+Vector(0,0,340), true)
		ParticleManager:SetParticleControlEnt(target.shadowFlayPFX, 1, caster.hero, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", caster.hero:GetAbsOrigin()+Vector(0,0,340), true)	
	end	
end

function shadow_flay_end(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if target.shadowFlayPFX then
	  ParticleManager:DestroyParticle( target.shadowFlayPFX, false )
	  ParticleManager:ReleaseParticleIndex(target.shadowFlayPFX)
	  target.shadowFlayPFX = false
	end
end

function auriun_passive_think(event)
	local caster = event.caster
	local ability = event.ability
	caster.a_c_level = Runes:GetTotalRuneLevel(caster, 1, "a_c", "auriun")
end

