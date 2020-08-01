require('heroes/nightstalker/chernobog_constants')
require('heroes/base_ability')

chernobog_charons_claw = class(base_ability)

function chernobog_charons_claw:GetManaCostBase(level)
    return 0
end

function chernobog_charons_claw:GetClawPathDuration()
	return 10
end

function chernobog_charons_claw:GetBehaviorBase()
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_OPTIONAL_UNIT_TARGET
end

function chernobog_charons_claw:GetCastAnimation()
	return ACT_DOTA_ATTACK
end

function chernobog_charons_claw:GetAbilitySlot()
    return DOTA_Q_SLOT
end

function chernobog_charons_claw:GetCastPoint()
    return 0.35
end

function chernobog_charons_claw:GetCastRange()
    return self:GetSpecialValueFor("range")
end

function chernobog_charons_claw:GetCooldownBase(level)
    return 10
end

function chernobog_charons_claw:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	EmitSoundOn("Chernobog.CharonsPreCast", caster)
	StartAnimation(caster, {duration = 1.2, activity = ACT_DOTA_ATTACK, rate = 1})
	return true
end

function chernobog_charons_claw:InitValues()
    local ability = self
	local caster = self:GetCaster()	
	ability.damage = ability:GetSpecialValueFor('damage')
	ability.damage_and_movespeed_reduction = ability:GetSpecialValueFor('move_and_attack_slow')
	ability.range = ability:GetSpecialValueFor('range')
	ability.width = 100
	ability.movespeed_amplify = ability:GetSpecialValueFor('move_speed_increase')
end

function chernobog_charons_claw:OnSpellStart()
    local ability = self
	local caster = self:GetCaster()
    local target = self:GetCastPosition()
	self:InitValues()

	if not ability.claw_table then
		ability.claw_table = {}
	end
	if not ability.projectile_id then
		ability.projectile_id = 0
	else
		if ability.projectile_id > 1000 then
			ability.projectile_id = 0
		end
		ability.projectile_id = ability.projectile_id + 1
	end

	local speed = 800
	local fv = ((target - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()

	local new_claw = {}
	local casterOrigin = caster:GetAbsOrigin()
	new_claw.projectile_id = ability.projectile_id
	new_claw.startPosition = casterOrigin - fv * 80
	new_claw.targetPosition = new_claw.startPosition + fv*ability.range
	new_claw.creation_time = GameRules:GetGameTime()
	new_claw.interval = 0
	new_claw.thinker_table = {}
	

	EmitSoundOn("Chernobog.CharonsClaw", caster)

	local projectileParticle = "particles/roshpit/chernobog/charons_clawpectral_dagger.vpcf"
	local info =
	{
		Ability = ability,
		EffectName = projectileParticle,
		vSpawnOrigin = new_claw.startPosition,
		fDistance = ability.range,
		fStartRadius = ability.width,
		fEndRadius = ability.width,
		Source = caster,
		StartPosition = "attach_origin",
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = false,
		vVelocity = fv * speed,
		bProvidesVision = true,
		iVisionRadius = 500,
		iVisionTeamNumber = caster:GetTeamNumber(),
		ExtraData = {projectileID = new_claw.projectile_id}
	}
	local projectile = Filters:LinearProjectile(info)
	new_claw.projectile = projectile
	table.insert(ability.claw_table, new_claw)

	-- local thinkers = math.floor(ability.range / 100) - 2
	-- local pathDuration = Filters:GetAdjustedBuffDuration(caster, 12, false)
	-- for i = 1, thinkers, 1 do
	-- 	Timers:CreateTimer(i * 0.12, function()
	-- 		local thinkerPos = GetGroundPosition(casterOrigin + fv * 100 * (i - 1) + fv * 80, caster)
	-- 		local obstruction = WallPhysics:FindNearestObstruction(thinkerPos)
	-- 		local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, thinkerPos, caster)

	-- 		if not blockUnit then
	-- 			Util.Ability:MakeThinker(caster, ability, modifiers.path_aura, thinkerPos, pathDuration)
	-- 		end
	-- 		if i == (thinkers - 2) then
	-- 			AddFOWViewer(caster:GetTeamNumber(), thinkerPos + fv * 200, 400, 3, false)
	-- 		end
	-- 	end)
	-- end

	Filters:CastSkillArguments(BASE_ABILITY_Q, caster)
end

function chernobog_charons_claw:GetClawObjectFromProjectileID(projectile_id)
	local ability = self
	local projectile = nil
	for key, claw in pairs(ability.claw_table) do
		if claw.projectile_id == projectile_id then
			projectile = claw
			break
		end
	end
	return projectile
end

function chernobog_charons_claw:OnProjectileThink_ExtraData(vLoc, extraData)
	local caster = self:GetCaster()
	local ability = self
	local claw = self:GetClawObjectFromProjectileID(extraData.projectileID)
	claw.interval = claw.interval + 1
	if claw.interval%4 == 0 then
		self:CreateClawThinker(claw, vLoc)
		AddFOWViewer(caster:GetTeamNumber(), vLoc, 400, 3, false)
	end
end

function chernobog_charons_claw:CreateClawThinker(claw, vLoc)
	local thinkerPos = vLoc
	local thinker_object = {}
	thinker_object.position = thinkerPos
    thinker_object.particle = ParticleManager:CreateParticle("particles/roshpit/chernobog/charon_ground.vpcf", PATTACH_WORLDORIGIN, nil)

    --ParticleManager:SetParticleControlEnt(self.particle, 0, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(thinker_object.particle, 0, vLoc)
    ParticleManager:SetParticleControl(thinker_object.particle, 1, Vector(self.width, 1, 1))
    ParticleManager:SetParticleControl(thinker_object.particle, 15, Vector(255, 255, 255))
    ParticleManager:SetParticleControl(thinker_object.particle, 16, Vector(1, 0, 0))
	table.insert(claw.thinker_table, thinker_object)
end

function chernobog_charons_claw:OnProjectileHit_ExtraData(target, vLocation, extraData)
	local caster = self:GetCaster()
	local ability = self
	local damage = ability.damage
	if target then
		EmitSoundOn("Chernobog.CharonsClawImpact", target)
		-- ability:ApplyDataDrivenModifier(caster, target, "modifier_charons_claw_enemy", {duration = 8})
		Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_Q, RPC_ELEMENT_DEMON, RPC_ELEMENT_SHADOW)
	end
end