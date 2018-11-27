function paladin_e_dash_start(event)
	local caster = event.caster
	local ability = event.ability
	Filters:CastSkillArguments(3, caster)
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
	EmitSoundOn("Hero_Omniknight.GuardianAngel", caster)
	EmitSoundOn("Hero_Omniknight.GuardianAngel", caster)
	-- WallPhysics:Jump(caster, caster:GetForwardVector(), 50, 15, 2, 0.7)
	ability.forwardVec = caster:GetForwardVector()
	-- WallPhysics:JumpFixedDistanceWithBlocking(caster, caster:GetForwardVector(), 400, 15, 50, 1, 1)
	Timers:CreateTimer(0.1, function()
		EmitSoundOn("DOTA_Item.ForceStaff.Activate", caster)
	end)
	local dash_duration = Filters:GetAdjustedBuffDuration(caster, 0.8, false)
	caster:RemoveModifierByName("modifier_crusader_dash")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_crusader_dash", {duration = dash_duration})
	ability.e_3_level = Runes:GetTotalRuneLevel(caster, 3, "e_3", "paladin")
	ability.projectileDamage = OverflowProtectedGetAverageTrueAttackDamage(caster)*(0.25*ability.e_3_level+0.1)
	caster.w_4_level = Runes:GetTotalRuneLevel(caster, 4, "w_4", "paladin")
	if ability.e_3_level > 0 then
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Paladin.FalconDash", caster)
		local info = 
		{
				Ability = ability,
		    	EffectName = "particles/roshpit/paladin/paladin_falcon.vpcf",
		    	vSpawnOrigin = caster:GetAbsOrigin()+Vector(0,0,70) - ability.forwardVec*300,
		    	fDistance = 1600,
		    	fStartRadius = 260,
		    	fEndRadius = 260,
		    	Source = caster,
		    	StartPosition = "attach_origin",
		    	bHasFrontalCone = false,
		    	bReplaceExisting = false,
		    	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		    	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		    	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		    	fExpireTime = GameRules:GetGameTime() + 5.0,
			bDeleteOnHit = false,
			vVelocity = ability.forwardVec*1600,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)	
		
	end
end

function paladin_e_dash_think(event)
  local ability = event.ability
  local caster = event.caster
  local position = caster:GetAbsOrigin()
  local obstruction = WallPhysics:FindNearestObstruction(position)
  
  local newPosition = position+ability.forwardVec*35
  local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (position+ability.forwardVec*72), caster)
  if not blockUnit then
    caster:SetOrigin(newPosition)
  end

end

function paladin_e_dash_end(event)
	local caster = event.caster
	local ability = event.ability
	WallPhysics:ClearSpaceForUnit(caster, caster:GetAbsOrigin())
end

function paladin_rune_e_1_die(event)
	local caster = event.caster
	local deathLocation = caster:GetAbsOrigin()
	print("a_c_death")
	local e_1_level = caster:GetRuneValue("e", 1)
	local runeUnit = caster.runeUnit
	local runeAbility = runeUnit:FindAbilityByName("paladin_rune_e_1")
	local reviveCooldown = PALADIN_E1_CD
	if caster:HasModifier("modifier_paladin_glyph_1_1") then
		reviveCooldown = PALADIN_GLYPH_1_1_E1_CD
	end
	if e_1_level > 0 and not caster:HasModifier("modifier_paladin_rune_e_1_revive_cooldown") then	
		caster:RemoveModifierByName("modifier_paladin_rune_e_1_revivable")
		local ability = event.ability
        Timers:CreateTimer(0.5, 
        function()
			        local dashAbility = caster:FindAbilityByName("crusader_dash")
			        dashAbility:ApplyDataDrivenModifier(caster, caster, "modifier_crusader_a_c_extension", {})
			        caster:SetModifierStackCount("modifier_crusader_a_c_extension", caster, e_1_level)
        		caster.revive = true
				caster:RespawnHero(false, false)
			        Timers:CreateTimer(0.1, 
			        function()
				      local playerID = caster:GetPlayerID()
				      PlayerResource:SetCameraTarget(playerID, caster)
				      runeAbility:ApplyDataDrivenModifier(runeUnit, caster, "modifier_paladin_rune_e_1_reviving", { duration = PALADIN_E1_REVIVE_TIME })
				      runeAbility:ApplyDataDrivenModifier(runeUnit, caster, "modifier_paladin_rune_e_1_revive_cooldown", {duration = reviveCooldown})
				      Timers:CreateTimer(2,
				      function()
				        PlayerResource:SetCameraTarget(playerID, nil)
				      end)
			        caster:SetAbsOrigin(deathLocation)	
					StartAnimation(caster, {duration=4, activity=ACT_DOTA_DISABLED, rate=0.7})
				end)
        end)
    end	
end

function paladin_rune_e_1_reviving_end(event)
	local target = event.target
	local e_1_level = target:GetRuneValue("e", 1)
	event.ability:ApplyDataDrivenModifier(target, target, "modifier_paladin_rune_e_1_invulnerable", {duration = PALADIN_E1_INVUL_TIME * e_1_level})
end

function paladin_rune_e_1_revive_cooldown_end(event)
	local unit = event.target
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, unit, "modifier_paladin_rune_e_1_revivable", {})
end

function paladin_rune_e_2_attacked(event)
	local caster = event.caster
	local ability = event.ability
	local attacker = event.attacker
	local unit = event.unit
	if not unit:HasModifier("modifier_secret_temple_refraction") and not unit:HasModifier("modifier_windsteel_effect") and not unit:HasModifier("modifier_heavens_shield") then
		if attacker:GetEntityIndex() == unit:GetEntityIndex() then
			return false
		end
		local e_2_level = unit:GetRuneValue("e", 2)
		local damage = OverflowProtectedGetAverageTrueAttackDamage(unit) * PALADIN_E2_DMG_PER_ATT * e_2_level + PALADIN_E2_BASE_DMG + PALADIN_E2_DMG * e_2_level
		local origin = attacker:GetAbsOrigin()
		if not unit.retributions then
			unit.retributions = 0
		end
		Filters:TakeArgumentsAndApplyDamage(attacker, unit, damage, DAMAGE_TYPE_PHYSICAL, 0, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
		if unit.retributions < 10 then
			if attacker:GetMaxHealth()>200 then
				unit.retributions = unit.retributions + 1
				local particleName = "particles/items_fx/chain_lightning.vpcf"
				local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, unit)
				ParticleManager:SetParticleControl(lightningBolt,0,Vector(unit:GetAbsOrigin().x,unit:GetAbsOrigin().y,unit:GetAbsOrigin().z + 100 ))	
				ParticleManager:SetParticleControl(lightningBolt,1,Vector(origin.x,origin.y,origin.z + attacker:GetBoundingMaxs().z ))
				Timers:CreateTimer(1, function()
					ParticleManager:DestroyParticle(lightningBolt, false)
				end)
				Timers:CreateTimer(0.1, function()
					unit.retributions = unit.retributions - 1
				end)
			end
		end
	end
end

function paladin_rune_e_3_falcon_hit(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	
	local particleName = "particles/econ/events/ti5/dagon_lvl2_ti5.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_POINT, target )
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)*(ability.e_3_level*0.25+0.1)
	-- damage = damage + 0.0004*(caster:GetIntellect()+caster:GetStrength()+caster:GetAgility())/10*ability.w_4_level*damage

	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_PURE, 3, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
	Timers:CreateTimer(1.0, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	end) 
	paladin_rune_e_4(caster, ability, target)
end

function paladin_rune_e_4(caster, ability, target)
	local d_c_level = Runes:GetTotalRuneLevel(caster, 4, "e_4", "paladin")
	if d_c_level > 0 then
		local d_c_duration = Filters:GetAdjustedBuffDuration(caster, 8, false)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_paladin_d_c", {duration = d_c_duration})
		target:SetModifierStackCount("modifier_paladin_d_c", caster, d_c_level)
	end
end

