require('heroes/obsidian_destroyer/epoch_constants')
require('heroes/base_ability')
epoch_distortion_orb = class(base_ability)

modifier_epoch_e_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_epoch_e_passive", "heroes/obsidian_destroyer/ability_scripts/epoch_distortion_orb.lua", LUA_MODIFIER_MOTION_NONE)

modifier_epoch_e_in_motion = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_epoch_e_in_motion", "heroes/obsidian_destroyer/ability_scripts/epoch_distortion_orb.lua", LUA_MODIFIER_MOTION_NONE)

function epoch_distortion_orb:GetManaCostBase(level)
    return 0
end

function epoch_distortion_orb:GetBehaviorBase()
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_epoch_e_in_motion") then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
	else
    	return DOTA_ABILITY_BEHAVIOR_DIRECTIONAL + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
    end
end

function epoch_distortion_orb:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_2
end

function epoch_distortion_orb:GetAbilityTextureName()
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_epoch_e_in_motion") then
		return "epoch/epoch_distortion_orb_alt"
	else
		return "epoch/epoch_distortion_orb"
	end
end

function epoch_distortion_orb:GetAbilitySlot()
    return DOTA_Q_SLOT
end

function epoch_distortion_orb:GetCastPoint()
    return 0
end

function epoch_distortion_orb:GetCastRange()
    return self:GetSpecialValueFor("range")
end

function epoch_distortion_orb:GetCooldownBase(level)
    if level == -1 then
        level = self:GetLevel() - 1
    end
    return EPOCH_E_COOLDOWN[level + 1]
end

function epoch_distortion_orb:GetIntrinsicModifierName()
	return "modifier_epoch_e_passive"
end

function epoch_distortion_orb:GetProjectileSpeed()
	return self:GetSpecialValueFor("speed") + self:GetCaster():GetRuneValue("e", 2)*EPOCH_E2_SPEED
end

function epoch_distortion_orb:GetProjectileRange()
	return self:GetSpecialValueFor("range") + self:GetCaster():GetRuneValue("e", 2)*EPOCH_E2_RANGE
end

function epoch_distortion_orb:OnSpellStart()
    local ability = self
	local caster = self:GetCaster()
    local target_position = self:GetCastPosition()
    if caster:HasModifier("modifier_epoch_e_in_motion") then
    	CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_oracle/oracle_false_promise_cast.vpcf", caster:GetAbsOrigin()+Vector(0,0,90), 3)
    	local newPos = WallPhysics:WallSearch(caster:GetAbsOrigin(), ability.projectilePosition, caster)
    	FindClearSpaceForUnit(caster, newPos, false)
    	ProjectileManager:ProjectileDodge(caster)
    	EmitSoundOn("Epoch.DistortionOrb.Jaunt", caster)
    	caster:RemoveModifierByName("modifier_epoch_e_in_motion")
    	CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_oracle/oracle_false_promise_cast.vpcf", caster:GetAbsOrigin()+Vector(0,0,90), 3)
    	ProjectileManager:DestroyLinearProjectile(ability.projectile)
    else
	    StartAnimation(caster, {duration = 0.7, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1.64})
		local start_radius = 210
		local end_radius = 210
		local range = self:GetProjectileRange()
		local speed = self:GetProjectileSpeed()

		local projectileParticle = "particles/units/heroes/hero_puck/time_warp.vpcf"

		local projectileOrigin = caster:GetAbsOrigin()
		local fv = ((target_position - projectileOrigin)*Vector(1,1,0)):Normalized()
		local info =
		{
			Ability = ability,
			EffectName = projectileParticle,
			vSpawnOrigin = projectileOrigin,
			fDistance = range,
			fStartRadius = start_radius,
			fEndRadius = end_radius,
			Source = caster,
			StartPosition = "attach_origin",
			bHasFrontalCone = true,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 5.0,
			bDeleteOnHit = false,
			vVelocity = fv * speed,
			bProvidesVision = true,
			iVisionRadius = 600,
			iMoveSpeed = speed,
			iVisionTeamNumber = caster:GetTeamNumber(),
			ExtraData = {projectileType = 1}
		}
		ability.projectile = Filters:LinearProjectile(info)
		EmitSoundOn("Epoch.DistortionOrb", caster)
		caster:AddNewModifier(caster, ability, "modifier_epoch_e_in_motion", {})
	    Filters:CastSkillArguments(BASE_ABILITY_E, caster)
	    ability:EndCooldown()
	    self:E4(projectileOrigin, fv)
	    if caster:HasModifier("modifier_epoch_glyph_7_1") then
	    	ability.glyph_7_1 = true
	    end
	    if caster:HasModifier("modifier_epoch_glyph_5_a") then
	    	ability.glyph_5_a_interval = 0
	    end
	end
end

function epoch_distortion_orb:OnProjectileHit_ExtraData(target, vLocation, extraData)
	local caster = self:GetCaster()
	local ability = self
	if extraData.projectileType == 1 then
		if not target then
			if not caster:HasModifier('modifier_epoch_immortal_weapon_3') then
				ability:StartCooldown(ability:GetCooldownBase(-1))
			end
			caster:RemoveModifierByName("modifier_epoch_e_in_motion")
			return true
		else
			local damage = self:GetSpecialValueFor("damage")
			Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_E, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)
			if ability.glyph_7_1 then
				ability.glyph_7_1 = false
			    local r_ability = caster:GetAbilityByIndex(DOTA_R_SLOT)
			    r_ability.cast_position_override = vLocation
			    r_ability:OnChannelFinish(false)			
			end
		end
	elseif extraData.projectileType == 2 then
		if target then
			local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)*caster:GetRuneValue("e", 4)*(EPOCH_E4_DMG_ATK_PWR_PCT/100)
			Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_E, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)
		end
	end
end

function epoch_distortion_orb:OnProjectileThink_ExtraData(vLoc, extraData)
	local caster = self:GetCaster()
	local ability = self
	if extraData.projectileType == 1 then
		local ability = self
		ability.projectilePosition = vLoc
		if caster:HasModifier("modifier_epoch_glyph_5_a") then
			ability.glyph_5_a_interval = ability.glyph_5_a_interval + 1
			if ability.glyph_5_a_interval%(EPOCH_GLYPH_5_A_INTERVAL/0.03) == 0 then
				local enemies = FindUnitsInRadius(caster:GetTeamNumber(), vLoc, nil, EPOCH_GLYPH_5_A_ENEMY_SEARCH_RANGE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false)
				if #enemies > 0 then
					local w_ability = caster:GetAbilityByIndex(DOTA_W_SLOT)
					w_ability:MainProjectile(caster, enemies[1], nil, vLoc)
				end
			end
		end
		return true
	end
end

function epoch_distortion_orb:E4(position, fv)
	local caster = self:GetCaster()
	local e_4_level = caster:GetRuneValue("e", 4)
	if e_4_level > 0 then
		local numOrbs = math.min(e_4_level, EPOCH_E4_ORBS_MAX)
		for i = 0, numOrbs-1, 1 do
			if (i % 2 == 0) then
				local rotatedVector = WallPhysics:rotateVector(fv, (math.pi / 80) * i)
				self:E4Projectile(position, rotatedVector)
			else
				local rotatedVector = WallPhysics:rotateVector(fv, (math.pi / 80) * i *- 1)
				self:E4Projectile(position, rotatedVector)
			end
		end
	end
end

function epoch_distortion_orb:E4Projectile(position, fv)
	local caster = self:GetCaster()
	local start_radius = 130
	local end_radius = 130
	local speed = self:GetProjectileSpeed()
	local range = self:GetProjectileRange()
	local info =
	{
		Ability = self,
		EffectName = "particles/units/heroes/hero_alchemist/epoch_rune_a_d_concoction_projectile.vpcf",
		vSpawnOrigin = position + Vector(0, 0, 100),
		fDistance = range,
		fStartRadius = start_radius,
		fEndRadius = end_radius,
		Source = caster,
		StartPosition = "attach_origin",
		bHasFrontalCone = true,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
		vVelocity = fv * speed,
		bProvidesVision = false,
		ExtraData = {projectileType = 2}
	}
	Filters:LinearProjectile(info)
end

-- PASSIVE

function modifier_epoch_e_passive:IsHidden()
    return true
end

function modifier_epoch_e_passive:RemoveOnDeath()
    return false
end

function modifier_epoch_e_passive:OnCreated()
    if not IsServer() then
        return false
    end
    self:SetSpecialTypes({ 
    	MODIFIER_ROSHPIT_BASE_MAGIC_ARMOR_BONUS,
    	MODIFIER_ROSHPIT_BASE_ARMOR_BONUS,
    	MODIFIER_ROSHPIT_FLAT_HEALTH_BONUS,
    	MODIFIER_ROSHPIT_FLAT_MANA_BONUS
    })

end

function modifier_epoch_e_passive:GetRoshpitBaseMagicArmorBonus()
	local caster = self:GetCaster()
	return caster:GetRuneValue("e", 1)*caster:GetSumOfAllAttributes()*EPOCH_E1_ARMOR_AND_MAGIC_ARMOR_PER_ATTR
end

function modifier_epoch_e_passive:GetRoshpitBaseArmorBonus()
	local caster = self:GetCaster()
	return caster:GetRuneValue("e", 1)*caster:GetSumOfAllAttributes()*EPOCH_E1_ARMOR_AND_MAGIC_ARMOR_PER_ATTR
end

function modifier_epoch_e_passive:GetFlatHealthBonus()
	local caster = self:GetCaster()
	return caster:GetRuneValue("e", 3)*EPOCH_E3_MAX_HEALTH
end

function modifier_epoch_e_passive:GetFlatManaBonus()
	local caster = self:GetCaster()
	return caster:GetRuneValue("e", 3)*EPOCH_E3_MAX_MANA
end

-- E IN MOTION MODIFIER

function modifier_epoch_e_in_motion:IsHidden()
	return true
end

function modifier_epoch_e_in_motion:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EVASION_CONSTANT
	}
	return funcs
end

function modifier_epoch_e_in_motion:GetModifierEvasion_Constant()
	local caster = self:GetParent()
	if caster:HasModifier("modifier_epoch_glyph_2_2") then
		return 100
	else
		return 0
	end
end

function modifier_epoch_e_in_motion:GetEffectName()
	local caster = self:GetParent()
	if caster:HasModifier("modifier_epoch_glyph_2_2") then
		return "particles/units/heroes/hero_phantom_assassin/epoch_rune_a_c.vpcf"
	else
		return nil
	end
end

function modifier_epoch_e_in_motion:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN
end