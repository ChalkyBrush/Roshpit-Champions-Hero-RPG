require('heroes/dragon_knight/flamewaker_constants')
require('heroes/base_ability')
flamewaker_dragon_breath = class(base_ability)

modifier_flamewaker_w_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_flamewaker_w_passive", "heroes/dragon_knight/ability_scripts/flamewaker_dragon_breath.lua", LUA_MODIFIER_MOTION_NONE)

modifier_flamewaker_w_armor_sear = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_flamewaker_w_armor_sear", "heroes/dragon_knight/ability_scripts/flamewaker_dragon_breath.lua", LUA_MODIFIER_MOTION_NONE)

function flamewaker_dragon_breath:GetManaCostBase(level)
    if level == -1 then
        level = self:GetLevel() - 1
    end
    return FLAMEWAKER_DRAGON_BREATH_MANA_COST[level + 1]
end

function flamewaker_dragon_breath:GetBehaviorBase()
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end

function flamewaker_dragon_breath:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_1
end

function flamewaker_dragon_breath:GetAbilitySlot()
    return DOTA_W_SLOT
end

function flamewaker_dragon_breath:GetCastPoint()
    return 0
end

function flamewaker_dragon_breath:GetCooldownBase()
    return 0
end

function flamewaker_dragon_breath:OnSpellStart()
    local ability = self
	local caster = self:GetCaster()
	local fv = caster:GetForwardVector()

	ability.w_2_level = caster:GetRuneValue("w", 2)
	self:FireProjectile(fv)

	StartAnimation(caster, {duration = 0.8, activity = ACT_DOTA_CAST_ABILITY_1, rate = 2})

    Filters:CastSkillArguments(BASE_ABILITY_W, caster)
end

function flamewaker_dragon_breath:FireProjectile(fv)
    local ability = self
	local caster = self:GetCaster()	
    EmitSoundOn("Flamewaker.SecondHeartbeat", caster)
	local start_radius = self:GetSpecialValueFor("start_radius")
	local end_radius = self:GetSpecialValueFor("end_radius")
	local range = self:GetSpecialValueFor("range") + math.min(ability.w_2_level * FLAMEWAKER_W2_RANGE, FLAMEWAKER_W2_MAX_RANGE)
	local speed = self:GetSpecialValueFor("speed") + (ability.w_2_level * FLAMEWAKER_W2_SPEED_BONUS)
	local projectileParticle = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf"
	if caster:HasModifier("modifier_flamewaker_glyph_4_1") then
		projectileParticle = "particles/units/heroes/hero_dragon_knight/blue_flame_breath.vpcf"
	end
	local info =
	{
		Ability = ability,
		EffectName = projectileParticle,
		vSpawnOrigin = caster:GetAbsOrigin(),
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
	}
	Filters:LinearProjectile(info)
end

function flamewaker_dragon_breath:OnProjectileHit(target, vLoc)
	local damage = self:GetSpecialValueFor("damage")
	local caster = self:GetCaster()
	if target then
		Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_W, RPC_ELEMENT_FIRE, RPC_ELEMENT_DRAGON)
		self:ApplyW3(target)
	end
	return false
end

function flamewaker_dragon_breath:GetIntrinsicModifierName()
	return "modifier_flamewaker_w_passive"
end

function flamewaker_dragon_breath:ApplyW3(target)
	if self:GetCaster():GetRuneValue("w", 3) > 0 then
		target:ApplyAndIncrementStackLua(self, self:GetCaster(), "modifier_flamewaker_w_armor_sear", 1, FLAMEWAKER_W3_STACK_LIMIT, FLAMEWAKER_W3_DURATION)
		target:CalculateAndSaveRoshpitAttributes()
	end
end

-- PASSIVE

function modifier_flamewaker_w_passive:IsHidden()
	return true
end

function modifier_flamewaker_w_passive:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_EVENT_ATTACK_LAND,
        MODIFIER_ROSHPIT_W_BASE_ABILITY_DMG_BONUS,
        MODIFIER_ROSHPIT_EVENT_FINAL_TAKE_DAMAGE
    })
end

function modifier_flamewaker_w_passive:RoshpitAttackLand(event)
	local target = event.victim
	local ability = self:GetAbility()
	local caster = ability:GetCaster()
	local w_1_level = caster:GetRuneValue("w", 1)
	if w_1_level > 0 then
		local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * w_1_level * FLAMEWAKER_W1_DMG_PER_ATT
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, FLAMEWAKER_W1_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				if not enemy.dummy then
					Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_W, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
					local particleName = "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_explosion.vpcf"
					local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, enemy)
					ParticleManager:SetParticleControlEnt(pfx, 0, enemy, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin()+Vector(0,0,40), true)
					Timers:CreateTimer(0.4, function()
						ParticleManager:DestroyParticle(pfx, false)
					end)
					ability:ApplyW3(enemy)
				end
			end
		end
	end
end

function modifier_flamewaker_w_passive:GetRoshpitWBaseAbilityDmgBonus()
	return (FLAMEWAKER_W4_W_BAD/100) * self:GetCaster():GetRuneValue("w", 4)
end

function modifier_flamewaker_w_passive:RoshpitEventFinalTakeDamage(event)
	local damage = event.damage
	local caster = self:GetCaster()
	local w_4_level = caster:GetRuneValue("w", 4)
	if w_4_level > 0 then
		local luck = RandomInt(1, 1000)
		if luck <= w_4_level*FLAMEWAKER_W4_FIRE_SPIT_CHANCE*10 then
			local fv = ((event.attacker:GetAbsOrigin() - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
			local ability = self:GetAbility()
			ability:FireProjectile(fv)
		end
	end	
	return damage
end

-- ARMOR SEAR W3

function modifier_flamewaker_w_armor_sear:IsHidden()
	return false
end

function modifier_flamewaker_w_armor_sear:IsDebuff()
	return true
end

function modifier_flamewaker_w_armor_sear:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_ARMOR_BONUS
    })
    self:GetParent():CalculateAndSaveRoshpitAttributes()
end

function modifier_flamewaker_w_armor_sear:OnRemoved()
	if not IsServer() then
		return false
	end
    self:GetParent():CalculateAndSaveRoshpitAttributes()
end


function modifier_flamewaker_w_armor_sear:GetRoshpitArmorBonus()
	local armor_reduction = self:GetStackCount() * FLAMEWAKER_W3_ARMOR_SHRED_PER_STACK * self:GetCaster():GetRuneValue("w", 3)
	return armor_reduction
end