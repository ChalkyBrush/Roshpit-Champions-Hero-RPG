require("heroes/axe/red_general_constants")
local Helper = require("heroes/util/helper")
local Helix = require('heroes/axe/glyphs/t41_helix')
local WAmplify = require('heroes/axe/glyphs/t52_w_amplify')

local function createProjectile(ability, caster, shotVector, casterOrigin)
	local start_radius = 110
	local end_radius = 300
	local range = 800
	local speed = ability.speed
	if not speed then
		speed = 600
	end
	--EmitSoundOn("Hero_Magnataur.ShockWave.Particle", caster)
	local info =
	{
		Ability = ability,
		EffectName = "particles/units/heroes/hero_magnataur/red_general_shockwave.vpcf",
		vSpawnOrigin = casterOrigin,
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
		vVelocity = shotVector * speed,
		bProvidesVision = false,
	}
	ProjectileManager:CreateLinearProjectile(info)
end

function red_general_ability_base_w_start(event)
	local caster = event.caster
	local ability = event.ability
	local location = caster:GetOrigin() - caster:GetForwardVector() * Vector(-100, -100, 0)
	local abilityLevel = ability:GetLevel()

	Helper.initializeAbilityRunes(caster, 'axe', 'w')

	ability.speed = event.speed
	ability.damage = event.damage * red_general_rune_base_w_4_start(caster) * WAmplify.getAmplify(caster)
	Helix.cast(caster, ability)

	local backVector = WallPhysics:rotateVector(caster:GetForwardVector(), math.pi)

	if caster:HasModifier("modifier_axe_glyph_2_1") then
		for i = -4, 4, 1 do
			local shockVector = WallPhysics:rotateVector(backVector, (math.pi / 4.5) * i)
			createProjectile(ability, caster, shockVector, location)
		end
	else
		for i = -1, 1, 1 do
			local shockVector = WallPhysics:rotateVector(backVector, (math.pi / 6) * i)
			createProjectile(ability, caster, shockVector, location)
		end
	end

	red_general_rune_base_w_3_start(caster, abilityLevel)

	Filters:CastSkillArguments(2, caster)
end

function red_general_ability_base_w_projectileHit(event)
	-- print("red_general_ability_base_w_projectileHit")
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local damage = ability.damage

	if event.amp then
		damage = damage * event.amp
	end

	red_general_rune_base_w_1_applyDebuff(target, caster, ability)
	red_general_rune_base_w_2_applyDebuff(target, caster, ability)

	if caster:HasModifier("modifier_axe_glyph_1_2") then
		Filters:ApplyStun(caster, RED_GENERAL_GLYPH_1_2_STUN_DURATION, target)
	end
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
end

function red_general_rune_base_w_1_applyDebuff(target, caster, ability)
	-- print("red_general_rune_base_w_1_applyDebuff")
	local stackCount = target:GetModifierStackCount("modifier_axe_rune_w_1_visible", caster)
	if stackCount == 0 then
		ability.stackLoseTimes = {}
		ability.tick = 0
	end
	ability:ApplyDataDrivenModifier(caster, target, "modifier_axe_rune_w_1_visible", {duration = RED_GENERAL_W1_DURATION})
	target:SetModifierStackCount("modifier_axe_rune_w_1_visible", caster, stackCount + 1)
	if ability.stackLoseTimes[ability.tick + 6] == nil then
		ability.stackLoseTimes[ability.tick + 6] = 1
	else
		ability.stackLoseTimes[ability.tick + 6] = ability.stackLoseTimes[ability.tick + 6] + 1
	end
end

function red_general_rune_base_w_1_think(event)
	local ability = event.ability
	local damage = ability.damage
	local target = event.target
	local caster = event.caster
	local stackCount = target:GetModifierStackCount("modifier_axe_rune_w_1_visible", caster)
	damage = damage * stackCount * caster.w_1_level * RED_GENERAL_W1_DAMAGE_PERCENT / 100
	Filters:ApplyDotDamage(caster, ability, target, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)

	if ability.stackLoseTimes[ability.tick] ~= nil then
		stackCount = stackCount - ability.stackLoseTimes[ability.tick]
		target:SetModifierStackCount("modifier_axe_rune_w_1_visible", caster, stackCount)
	end

	ability.tick = ability.tick + 1
end

function red_general_rune_base_w_2_applyDebuff(target, caster, ability)
	-- print("red_general_rune_base_w_2_applyDebuff")
	local runesCount = caster.w_2_level
	if runesCount <= 0 then
		return
	end
	Helper.updateStackModifier(target, caster, ability, "axe_rune_w_2", RED_GENERAL_W2_DURATION, RED_GENERAL_W2_MAX_STACKS_COUNT, runesCount)
	target:CalculateAndSaveRoshpitAttributes()
end

function red_general_rune_base_w_3_start(caster, abilityLevel)
	if caster.w_3_level > 0 then
		local healAmountFlat = caster.w_3_level * RED_GENERAL_W3_HEAL_FLAT * abilityLevel
		local healAmountPct = caster.w_3_level * RED_GENERAL_W3_HEAL_PCT / 100 * caster:GetMaxHealth() * abilityLevel
		Filters:ApplyHeal(caster, caster, healAmountFlat + healAmountPct, true)
		-- PopupHealing(caster, healAmount)
	end
end

function red_general_rune_base_w_4_start(caster)
	if caster.w_4_level <= 0 then
		return 1
	else
		return 1 + RED_GENERAL_W4_AMPLIFY_PERCENT / 100 * caster:GetStrength() * caster.w_4_level
	end
end
