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
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_crusader_dash", {duration = dash_duration})
	ability.e_3_level = Runes:GetTotalRuneLevel(caster, 3, "e_3", "paladin")
	ability.projectileDamage = caster:GetAverageTrueAttackDamage(caster)*(0.25*ability.e_3_level+0.1)
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

function paladin_rune_e_3_falcon_hit(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	
	local particleName = "particles/econ/events/ti5/dagon_lvl2_ti5.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_POINT, target )
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
	local damage = caster:GetAverageTrueAttackDamage(caster)*(ability.e_3_level*0.25+0.1)
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

