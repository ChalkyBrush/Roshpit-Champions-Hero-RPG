function crusader_dash_start(event)
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
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_crusader_dash", {duration = dash_duration})
	ability.c_c_level = Runes:GetTotalRuneLevel(caster, 3, "c_c", "paladin")
	ability.projectileDamage = caster:GetAverageTrueAttackDamage(caster)*(0.25*ability.c_c_level+0.1)
	caster.d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "paladin")
	if ability.c_c_level > 0 then
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

function dash_think(event)
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

function dash_end(event)
	local caster = event.caster
	local ability = event.ability
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
end

function paladin_rune_c_c_falcon_hit(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	
	local particleName = "particles/econ/events/ti5/dagon_lvl2_ti5.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_POINT, target )
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
	local damage = caster:GetAverageTrueAttackDamage(caster)*(ability.c_c_level*0.25+0.1)
	-- damage = damage + 0.0004*(caster:GetIntellect()+caster:GetStrength()+caster:GetAgility())/10*ability.d_b_level*damage

	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_PURE, 3, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
	Timers:CreateTimer(1.0, function() 
	  ParticleManager:DestroyParticle( pfx, false )
	end) 
	rune_d_c(caster, ability, target)
end

function rune_c_c(caster, ability)
  if ability.c_c_level > 0 then
  	local position = caster:GetAbsOrigin()
  	local radius = 650	
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	
	if #enemies > 0 then
		local projectileCount = 0
		for _,enemy in pairs(enemies) do
			local info = 
			{
				Target = enemy,
				Source = caster,
				Ability = ability,	
				EffectName = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_arcane_bolt.vpcf",
				StartPosition = "attach_hitloc",
				bDrawsOnMinimap = false, 
			        bDodgeable = true,
			        bIsAttack = false, 
			        bVisibleToEnemies = true,
			        bReplaceExisting = false,
			        flExpireTime = GameRules:GetGameTime() + 4,
				bProvidesVision = true,
				iVisionRadius = 0,
				iMoveSpeed = 400,
				iVisionTeamNumber = caster:GetTeamNumber()
			}
			projectile = ProjectileManager:CreateTrackingProjectile(info)
		end
	end  	
  end
end

function rune_d_c(caster, ability, target)
	local d_c_level = Runes:GetTotalRuneLevel(caster, 4, "d_c", "paladin")
	if d_c_level > 0 then
		local d_c_duration = Filters:GetAdjustedBuffDuration(caster, 8, false)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_paladin_d_c", {duration = d_c_duration})
		target:SetModifierStackCount("modifier_paladin_d_c", caster, d_c_level)
	end
end

