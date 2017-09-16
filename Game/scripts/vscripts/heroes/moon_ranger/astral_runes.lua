require('heroes/moon_ranger/moon_shroud')

function a_b_attack_land(event)
	local attacker = event.attacker
	local caster = attacker.runeUnit
	local damage = event.damage
	local target = event.target
	local ability = event.ability

	  local runeAbility = caster:FindAbilityByName("astral_rune_a_b")
	  local abilityLevel = runeAbility:GetLevel()
	  local bonusLevel = Runes:GetTotalBonus(caster, "a_b")
	  local totalLevel = abilityLevel + bonusLevel
	  ability.attacker = attacker
	  ability.damage = damage*0.5
	  
	  local arrowParticle = "particles/units/heroes/hero_drow/drow_base_attack.vpcf"
	  if attacker:HasModifier("modifier_astral_rune_c_a") then
	  	local arrowParticle = "particles/units/heroes/hero_drow/astral_c_a_particle_attackfrost_arrow.vpcf"
	  end
	  if totalLevel > 0 then
	      local enemies = FindUnitsInRadius( attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE+DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false )
	      if #enemies > 0 then
	      	local count = 0
	        for _,enemy in pairs(enemies) do
	        	if count > totalLevel then
	        		break
	        	end
	        	if target == enemy then
	        	elseif enemy.dummy then
	        	else
	        		create_arrow(attacker,damage,enemy, target, ability, arrowParticle)
	        		count = count+1
	        	end
	        end  	
		  end
	  end

end




function create_arrow(attacker, damage, enemy, target, ability, arrowParticle)
local info = 
{
	Target = enemy,
	Source = target,
	Ability = ability,	
	EffectName = arrowParticle,
	vSourceLoc= target:GetAbsOrigin(),
	bDrawsOnMinimap = false, 
        bDodgeable = true,
        bIsAttack = false, 
        bVisibleToEnemies = true,
        bReplaceExisting = false,
        flExpireTime = GameRules:GetGameTime() + 10,
	bProvidesVision = true,
	iVisionRadius = 0,
	iMoveSpeed = 900,
	iVisionTeamNumber = attacker:GetTeamNumber()
}
projectile = ProjectileManager:CreateTrackingProjectile(info)
end


function arrow_strike(event)
	local ability = event.ability

	local caster = event.caster

	  -- local damageTable = {
	  --   victim = event.target,
	  --   attacker = ability.attacker,
	  --   damage = ability.damage,
	  --   damage_type = DAMAGE_TYPE_PHYSICAL,
	  -- }
	       
	  -- ApplyDamage(damageTable)
	  Filters:TakeArgumentsAndApplyDamage(event.target, ability.attacker, ability.damage, DAMAGE_TYPE_PHYSICAL, 2, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
	  local eventTable = {}
	  eventTable.attacker = ability.attacker
	  eventTable.ability = ability.attacker:FindAbilityByName("moon_shroud")
	  eventTable.target = event.target
	  eventTable.attack_damage = ability.damage
	  moon_shroud_attack_land(eventTable)
end

function c_d_end(event)
 local target = event.target
 local ability = event.ability
 local caster = event.caster
 ability:ApplyDataDrivenModifier(caster, target, "modifier_rune_c_d_phoenix_leaving", {duration = 5})
 target:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
 EmitSoundOn("phoenix_phoenix_bird_denied", target)
 local origin = target:GetAbsOrigin()
 for i = 0, 30, 1 do
      Timers:CreateTimer(0.03*i,
      function()
      	if IsValidEntity(target) then
	        target:SetAbsOrigin(origin+Vector(0,0,20*i)+target:GetForwardVector()*i*10)
	        if i == 30 then
	            UTIL_Remove(target)
	        end
    	end
      end)
 end
end

function c_d_enter(event)
 	local target = event.target
 	local ability = event.ability
 	local caster = ability.origCaster

 	local damage = ability.c_d_level * 1270 + 130
    local d_c_level = Runes:GetTotalRuneLevel(caster, 4, "d_c", "astral")
    -- damage = damage + 0.001*caster:GetAgility()/10*d_c_level*damage
    print(caster:GetUnitName())
    if caster:HasModifier("modifier_astral_glyph_2_1") then
    	print("GLYPHED??")
    	damage = damage*3
    	ability.glyphed = true
    else
    	ability.glyphed = false
    end
    ability.c_d_damage = damage
	StartAnimation(target, {duration=1.5, activity=ACT_DOTA_SPAWN, rate=1.0})
	local origin = target:GetAbsOrigin()+Vector(0,0,600)
	target:SetAbsOrigin(origin)
 	for i = 0, 30, 1 do
      Timers:CreateTimer(0.03*i,
      function()
        target:SetAbsOrigin(origin+Vector(0,0,15*-i))
      end)
 	end
end

function c_d_think(event)
	local phoenix = event.target
	local caster = event.caster
	local ability = event.ability
	local orig_caster = ability.origCaster
	local radius = 2000
	local projectileParticle = "particles/base_attacks/ranged_tower_good.vpcf"
	if phoenix.glyphed then
		projectileParticle =  "particles/base_attacks/astral_glyph_2_1_projectile.vpcf"
	end
	phoenix:MoveToPosition(orig_caster:GetAbsOrigin()+RandomVector(200))
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), phoenix:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			local info = 
			{
				Target = enemy,
				Source = phoenix,
				Ability = ability,	
				EffectName = projectileParticle,
				vSourceLoc= phoenix:GetAbsOrigin(),
				bDrawsOnMinimap = false, 
			        bDodgeable = true,
			        bIsAttack = false, 
			        bVisibleToEnemies = true,
			        bReplaceExisting = false,
			        flExpireTime = GameRules:GetGameTime() + 4,
				bProvidesVision = true,
				iVisionRadius = 0,
				iMoveSpeed = 900,
				iVisionTeamNumber = phoenix:GetTeamNumber()
			}
			projectile = ProjectileManager:CreateTrackingProjectile(info)
			
		end
	end 	
end

function c_d_projectile_hit(event)
	local target = event.target
	local ability = event.ability
	local damage = ability.c_d_damage
	Filters:TakeArgumentsAndApplyDamage(target, ability.origCaster, damage, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_COSMOS, RPC_ELEMENT_NONE)
	if ability.glyphed then
		ability:ApplyDataDrivenModifier(ability.origCaster.runeUnit3, target, "modifier_astral_glyph_2_1_slow", {duration = 4})
	end
end

function astral_think(event)
	local caster = event.caster
    caster.d_c_level = Runes:GetTotalRuneLevel(caster, 4, "d_c", "astral")
    caster.d_d_level = Runes:GetTotalRuneLevel(caster, 4, "d_d", "astral")

	local d_c_level = caster.d_c_level
	local d_c_ability = caster.runeUnit4:FindAbilityByName("astral_rune_d_c")
	if d_c_level > 0 then
		d_c_ability:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_astral_rune_d_c_visible", {})
		caster:SetModifierStackCount( "modifier_astral_rune_d_c_visible", d_c_ability, d_c_level )
	else
		caster:RemoveModifierByName("modifier_astral_rune_d_c_visible")
	end

	local d_d_level = caster.d_d_level
	local d_d_ability = caster.runeUnit4:FindAbilityByName("astral_rune_d_d")
	if d_d_level > 0 then
		d_d_ability:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_astral_rune_d_d_visible", {})
		caster:SetModifierStackCount( "modifier_astral_rune_d_d_visible", d_d_ability, d_d_level )
	else
		caster:RemoveModifierByName("modifier_astral_rune_d_d_visible")
	end
end