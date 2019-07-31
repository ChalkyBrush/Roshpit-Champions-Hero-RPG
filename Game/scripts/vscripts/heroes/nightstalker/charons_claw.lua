require('/util')
require('heroes/nightstalker/chernobog_constants')
require('heroes/nightstalker/common')
local prefix = '1_q_'
local modifiers = {
	path_enemy_effect_q1 = 'modifier_chernobog_1_q_path_enemy_effect_q1',
	path_enemy_effect_q2 = 'modifier_chernobog_1_q_path_enemy_effect_q2',
	path_enemy_effect = 'modifier_chernobog_1_q_path_enemy_effect',
	path_effect = 'modifier_chernobog_1_q_path_effect',
	path_aura = 'modifier_chernobog_1_q_path_aura',
	path_ally_effect = 'modifier_chernobog_1_q_path_ally_effect',
}
for modifierPath, modifier in pairs(modifiers) do
	LinkLuaModifier(modifier, "heroes/nightstalker/modifiers/"..prefix..modifierPath, LUA_MODIFIER_MOTION_NONE)
end

function charons_init_values(caster, ability)
	ability.damage = ability:GetSpecialValueFor('damage')
	ability.damage_and_movespeed_reduction = ability:GetSpecialValueFor('move_and_attack_slow')
	ability.range = ability:GetSpecialValueFor('range') + caster.q4_level * CHERNOBOG_Q4_RANGE
	ability.width = 150 + caster.q4_level * CHERNOBOG_Q4_WIDTH
	ability.movespeed_amplify = ability:GetSpecialValueFor('move_speed_increase')
end
function charons_phase_start(event)
	local caster = event.caster
	EmitSoundOn("Chernobog.CharonsPreCast", caster)
end

function charons_claw_cast(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	charons_init_values(caster, ability)
	if not event.fake_cast then
		chenobog_make_right_cooldown(caster, ability, 'q')
	end

	EmitSoundOn("Chernobog.CharonsClaw", caster)

	local projectileParticle = "particles/roshpit/chernobog/charons_clawpectral_dagger.vpcf"
	local casterOrigin = caster:GetAbsOrigin()
	local speed = 800
	local fv = ((target - casterOrigin) * Vector(1, 1, 0)):Normalized()
	local info =
	{
		Ability = ability,
		EffectName = projectileParticle,
		vSpawnOrigin = casterOrigin - fv * 80,
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
	iVisionTeamNumber = caster:GetTeamNumber()}
	ProjectileManager:CreateLinearProjectile(info)

	local thinkers = math.floor(ability.range / 100) - 2
	local pathDuration = Filters:GetAdjustedBuffDuration(caster, 12, false)
	for i = 1, thinkers, 1 do
		Timers:CreateTimer(i * 0.12, function()
			local thinkerPos = GetGroundPosition(casterOrigin + fv * 100 * (i - 1) + fv * 80, caster)
			local obstruction = WallPhysics:FindNearestObstruction(thinkerPos)
			local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, thinkerPos, caster)

			if not blockUnit then
				Util.Ability:MakeThinker(caster, ability, modifiers.path_aura, thinkerPos, pathDuration)
			end
			if i == (thinkers - 2) then
				AddFOWViewer(caster:GetTeamNumber(), thinkerPos + fv * 200, 400, 3, false)
			end
		end)
	end

	Filters:CastSkillArguments(1, caster)
end

function claw_projectile_hit(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = ability.damage
	if caster:HasModifier("modifier_chernobog_glyph_3_1") then
		local procession = caster:GetAbilityByIndex(DOTA_R_SLOT)
		local cdRemaining = procession:GetCooldownTimeRemaining()
		if cdRemaining > 0 then
			local newCD = math.max(0, cdRemaining - CHERNOBOG_T31_CD_DEC)
			procession:EndCooldown()
			procession:StartCooldown(newCD)
		end
	end
	EmitSoundOn("Chernobog.CharonsClawImpact", target)
	-- ability:ApplyDataDrivenModifier(caster, target, "modifier_charons_claw_enemy", {duration = 8})
	Damage:Apply({
		attacker = caster,
		victim = target,
		source = ability,
		sourceType = BASE_ABILITY_Q,
		damage = damage,
		damageType = DAMAGE_TYPE_MAGICAL,
		elements = {
			RPC_ELEMENT_DEMON,
			RPC_ELEMENT_SHADOW,
		},
	})
end