require('heroes/moon_ranger/init')
local AstralSteal = require('heroes/moon_ranger/abilities/w/w1_astral_steal')

function begin_splitshot(event)
	-- Dungeons:Debug()
	-- local cheats = Convars:GetBool("developer")
	-- print(cheats)
	local caster = event.caster
	local ability = event.ability
	local abilityLevel = ability:GetLevel()
	local location = caster:GetOrigin() + caster:GetForwardVector()*Vector(80,80,0)
	local forwardVector = caster:GetForwardVector()
	local damage = event.damage
	local range = event.range
	local b_b_level = b_b_level(caster)

    local procChance = getProcChance(caster, 10);
	local procs = Runes:Procs(b_b_level, procChance, 1)

	ability.c_b_level = rune_c_b(caster, ability, forwardVector)
    local c_b_ability = caster.runeUnit3:FindAbilityByName("astral_rune_c_b")
    caster.d_c_level = Runes:GetTotalRuneLevel(caster, 4, "d_c", "astral")
    caster.d_d_level = Runes:GetTotalRuneLevel(caster, 4, "d_d", "astral")
	ability.damage = damage

	EmitSoundOn("Astral.AstralVolleyBig", caster)
	local projectileParticle = "particles/frostivus_herofx/drow_linear_arrow.vpcf"

	ability.d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "astral")
	-- local d_b_ability = caster.runeUnit4:FindAbilityByName("astral_rune_d_b")
	caster:RemoveModifierByName("modifier_astral_rune_d_b_visible")
	caster:RemoveModifierByName("modifier_astral_rune_d_b_invisible")

	ability.a_b_level = Runes:GetTotalRuneLevel(caster, 1, "a_b", "astral")

	local minArrows = -7
	local maxArrows = 7
    if caster:HasModifier("modifier_astral_glyph_3_1") then
    	ability.damage = ability.damage*2
    	minArrows = -2
    	maxArrows = 2
    end	
		

	ability:SetActivated(false)
	local delay = Filters:GetDelayWithCastSpeed(caster, 0.2)
  for j = 0, procs, 1 do
	  Timers:CreateTimer(j*delay,
	  function()
	  	Filters:CastSkillArguments(2, caster)
	  	-- set_d_b(caster, d_b_level, d_b_ability)
		for i=minArrows, maxArrows, 1 do 
			rotatedVector = rotateVector(caster:GetForwardVector(), math.pi/40*i)
			arrowOrigin = caster:GetOrigin() + caster:GetForwardVector()*Vector(80,80,0)
			targetPoint = rotatedVector + location*Vector(1,1,0)
			create_shot2(abilityLevel, caster, targetPoint, forwardVector, ability, arrowOrigin, rotatedVector, range, damage, projectileParticle, ability, c_b_ability)
			if j > 0 then
				StartAnimation(caster, {duration=delay, activity=ACT_DOTA_ATTACK, rate=3.6})
				EmitSoundOn("Astral.AstralVolleySmall", caster)
			end
			if j == procs then
				ability:SetActivated(true)
			end
		end
		local manaCost = ability:GetManaCost(abilityLevel)
		caster:ReduceMana(manaCost)
		local event = {}
		event.ability = caster.body
		event.event_ability = ability
		CustomAbilities:IceQuill(event)
	 end)
  end
  
	
end

function set_d_b(caster, d_b_level, d_b_ability)
	local d_b_duration = Filters:GetAdjustedBuffDuration(caster, 7, false)
	if d_b_level > 0 then
		d_b_ability:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_astral_rune_d_b_visible", {duration = d_b_duration})
		local current_stack = caster:GetModifierStackCount( "modifier_astral_rune_d_b_visible", d_b_ability )
		local newStack = current_stack + 1
		caster:SetModifierStackCount( "modifier_astral_rune_d_b_visible", d_b_ability, newStack )

		d_b_ability:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_astral_rune_d_b_invisible", {duration = d_b_duration})
		caster:SetModifierStackCount( "modifier_astral_rune_d_b_invisible", d_b_ability, newStack*d_b_level )
	end
end

function rune_c_b(caster, arrowAbility, fv)
    local runeUnit = caster.runeUnit3
    local ability = runeUnit:FindAbilityByName("astral_rune_c_b")
    local abilityLevel = ability:GetLevel()
    local bonusLevel = Runes:GetTotalBonus(runeUnit, "c_b")
    local totalLevel = abilityLevel + bonusLevel
    if totalLevel > 0 then
    	arrowAbility.fv = fv
    end
    return totalLevel
end

function b_b_level(caster)
  local runeUnit = caster.runeUnit2
  local runeAbility = runeUnit:FindAbilityByName("astral_rune_b_b")
  local abilityLevel = runeAbility:GetLevel()
  local bonusLevel = Runes:GetTotalBonus(runeUnit, "b_b")
  local totalLevel = abilityLevel + bonusLevel
  return totalLevel
end

function begin_channel(event)
	local caster = event.caster
	StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_ATTACK, rate=0.8})
end

function create_shot2(abilityLevel, caster, arrowOrigin, fv, arrowAbility, arrowOrigin, rotatedVector, range, damage, projectileParticle, ability, c_b_ability)
	local shotType = 0
	if ability.c_b_level > 0 then
		local luck = RandomInt(1,100)
		local threshold = 15
		if caster:HasModifier("modifier_astral_glyph_3_1") then
			threshold = 30
        end
        threshold = getProcChance(caster, threshold)

		if luck <= threshold then
			shotType = 1
		end
	end

	local start_radius = 60
	local end_radius = 60
	local speed = 1100
	if shotType == 0 then
		local info = 
		{
				Ability = arrowAbility,
		    	EffectName = projectileParticle,
		    	vSpawnOrigin = arrowOrigin,
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
			vVelocity = rotatedVector * speed,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)	
	elseif shotType == 1 then
		arrowOrigin = arrowOrigin + fv*40
			local info = 
			{
					Ability = c_b_ability,
			    	EffectName = "particles/frostivus_gameplay/astral_rune_c_b_linear_frost_arrow.vpcf",
			    	vSpawnOrigin = arrowOrigin,
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
				vVelocity = rotatedVector * speed,
				bProvidesVision = false,
			}
			projectile = ProjectileManager:CreateLinearProjectile(info)	
	end
end

function arrow_strike(event)
	AstralSteal.start(event)

	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local damage = event.ability.damage
	if ability.d_b_level > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_astral_d_b_visible", {duration = 7})
		local newStacks = math.min(target:GetModifierStackCount("modifier_astral_d_b_visible", caster) + 1, W4_MAX_STACKS_COUNT)
		target:SetModifierStackCount("modifier_astral_d_b_visible", caster, newStacks)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_astral_d_b_invisible", {duration = 7})
		target:SetModifierStackCount("modifier_astral_d_b_invisible", caster, newStacks*ability.d_b_level)
	end
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_NORMAL, RPC_ELEMENT_COSMOS)
	-- if ability.c_b_level > 0 then
	-- 	local point = target:GetAbsOrigin()-ability.fv*100
	-- 	local knockbackDuration = ability.c_b_level*0.05
	-- 	local knockbackDistance = 100 + ability.c_b_level*10
	-- 	local modifierKnockback =
	-- 	{
	-- 		center_x = point.x,
	-- 		center_y = point.y,
	-- 		center_z = point.z,
	-- 		duration = knockbackDuration,
	-- 		knockback_duration = knockbackDuration,
	-- 		knockback_distance = knockbackDistance,
	-- 		knockback_height = 120,
	-- 	}
	-- 	if not target:HasModifier("modifier_arrow_knockback_immune") then
 --        	target:AddNewModifier( caster, nil, "modifier_knockback", modifierKnockback )
 --        	ability:ApplyDataDrivenModifier(caster, target, "modifier_arrow_knockback_immune", {duration = 2.1})
 --    	end
	-- end
end

function split_shot_crit(event)
	local target = event.target
	local caster = event.caster
	local ability = caster.hero:FindAbilityByName("split_shot")
	local damage = ability:GetSpecialValueFor("damage")*(1+ability.c_b_level*W3_MULTIPLY_PERCENT)
	Filters:TakeArgumentsAndApplyDamage(target, caster.hero, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_NONE, RPC_ELEMENT_NONE)
	PopupDamage(target, damage)
end

function rotateVector(vector, radians)
   XX = vector.x	
   YY = vector.y
   
   Xprime = math.cos(radians)*XX -math.sin(radians)*YY
   Yprime = math.sin(radians)*XX +math.cos(radians)*YY

   vectorX = Vector(1,0,0)*Xprime
   vectorY = Vector(0,1,0)*Yprime
   rotatedVector = vectorX + vectorY
   return rotatedVector
   
end