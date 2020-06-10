require('heroes/dragon_knight/flamewaker_constants')
require('heroes/base_ability')
flamewaker_cataclysm = class(base_ability)

modifier_flamewaker_r_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_flamewaker_r_passive", "heroes/dragon_knight/ability_scripts/flamewaker_cataclysm.lua", LUA_MODIFIER_MOTION_NONE)

modifier_flamewaker_r_1_mountain_strike = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_flamewaker_r_1_mountain_strike", "heroes/dragon_knight/ability_scripts/flamewaker_cataclysm.lua", LUA_MODIFIER_MOTION_NONE)

modifier_flamewaker_r_3_strength = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_flamewaker_r_3_strength", "heroes/dragon_knight/ability_scripts/flamewaker_cataclysm.lua", LUA_MODIFIER_MOTION_NONE)

function flamewaker_cataclysm:GetManaCostBase(level)
    return 0
end

function flamewaker_cataclysm:GetBehaviorBase()
	local behavior = DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_AOE
	if self:GetCaster():HasModifier("modifier_flamewaker_immortal_weapon_3") then
		behavior = DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_AOE
	end
    return behavior
end

function flamewaker_cataclysm:GetAbilitySlot()
    return DOTA_R_SLOT
end

function flamewaker_cataclysm:GetCastPoint()
    return 0
end

function flamewaker_cataclysm:GetCooldownBase(level)
    return FLAMEWAKER_R_COOLDOWN
end

function flamewaker_cataclysm:GetCastRange()
	local range = 0
	if self:GetCaster():HasModifier("modifier_flamewaker_immortal_weapon_3") then
		range = FLAMEWAKER_IMMORTAL_WEAPON_3_R_CAST_RANGE
	end
    return range
end

function flamewaker_cataclysm:GetTexture()
    return "arkimus/flamewaker_cataclysm"
end

function flamewaker_cataclysm:GetChannelTimeBase()
    return 1.0
end

function flamewaker_cataclysm:GetCastAnimation()
    return ACT_DOTA_VICTORY
end

function flamewaker_cataclysm:GetIntrinsicModifierName()
	return "modifier_flamewaker_r_passive"
end

function flamewaker_cataclysm:OnSpellStartBase()
    local caster = self:GetCaster()
    local ability = self
    if ability.channel_pfx then
    	ParticleManager:DestroyParticle(ability.channel_pfx, false)
    	ability.channel_pfx = nil
    end
    ability.channel_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_icarus_dive_char_glow.vpcf", PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(ability.channel_pfx, 0, caster:GetAbsOrigin())
    StartSoundEvent("Flamewaker.Cataclysm.Start", caster)
end

function flamewaker_cataclysm:OnChannelFinish(interrupted)
    if IsServer() then
    	local caster = self:GetCaster()
    	local ability = self
    	caster:RemoveModifierByName("modifier_channel_start")
	    if ability.channel_pfx then
	    	ParticleManager:DestroyParticle(ability.channel_pfx, false)
	    	ability.channel_pfx = nil
	    end
    	if interrupted then
    		StopSoundEvent("Flamewaker.Cataclysm.Start", caster)
    	else
		    local position = caster:GetAbsOrigin()
		    if caster:HasModifier("modifier_flamewaker_immortal_weapon_3") then
		    	position = self:GetCursorPosition()
		    end
		    local radius = ability:GetSpecialValueFor("radius")
		    local stun_duration = ability:GetSpecialValueFor("stun_duration")
		    local explosionPFX = CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_warlock/warlock_rain_of_chaos.vpcf", position, 4)
		    ParticleManager:SetParticleControl(explosionPFX, 1, Vector(radius, 0, 2))

		    EmitSoundOn("Flamewaker.Cataclysm.Explosion", caster)

		    local damage = ability:GetSpecialValueFor("damage")
		    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		    if #enemies > 0 then
		        for _, enemy in pairs(enemies) do
		        	Filters:ApplyStun(caster, stun_duration, enemy)
		            Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PURE, BASE_ABILITY_R, RPC_ELEMENT_FIRE, RPC_ELEMENT_EARTH)
		        end
		    end
		    self:FlamewakerR2()
		    self:FlamewakerR3()
		    GridNav:DestroyTreesAroundPoint(position, 240, false)
		    Filters:CastSkillArguments(BASE_ABILITY_R, caster)
		end
    end
end

function flamewaker_cataclysm:FlamewakerR2()
	local caster = self:GetCaster()
	local ability = self

	local r_2_level = caster:GetRuneValue("r", 2)
	if r_2_level > 0 then
		local fv = caster:GetForwardVector()
		ability.r_2_level = r_2_level
		if r_2_level > 0 then
			EmitSoundOn("Flamewaker.SecondHeartbeat", caster)
			local count = 25
			local delay = 0.12
			if caster:HasModifier("modifier_flamewaker_glyph_5_1") then
				count = count * FLAMEWAKER_GLYPH_5_1_ADDITIONAL_FLAMES_MULT
				delay = delay / FLAMEWAKER_GLYPH_5_1_ADDITIONAL_FLAMES_MULT
			end
			local cast_number = ability.cast_number
			for i = 0, count, 1 do
				Timers:CreateTimer(delay * i, function()
					if caster:IsAlive() and ability.cast_number == cast_number then
						if i % 2 == 0 then
							EmitSoundOn("Flamewaker.R2FlameSpiral", caster)
						end
						local rotatedVector = WallPhysics:rotateVector(fv, math.pi / 5 * i)
						self:flamewaker_r_2_create_flame(caster:GetAbsOrigin(), rotatedVector)
					end
				end)
			end
		end
	end
end

function flamewaker_cataclysm:flamewaker_r_2_create_flame(origin, fv)
	local caster = self:GetCaster()
	local start_radius = 120
	local end_radius = 200
	local range = 540
	local speed = 800
	local info =
	{
		Ability = self,
		EffectName = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf",
		vSpawnOrigin = origin,
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

function flamewaker_cataclysm:OnProjectileHit(target, vPos)
	local caster = self:GetCaster()
	if target then
		local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)*(FLAMEWAKER_R2_DAMAGE_ATK_POWER/100)
		Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_R, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
	end
	return false
end

function flamewaker_cataclysm:FlamewakerR3()
	local caster = self:GetCaster()
	local r_3_level = caster:GetRuneValue("r", 3)
	if r_3_level > 0 then
		CustomAbilities:QuickParticleAtPoint("particles/roshpit/flamewaker/flamewaker_r3.vpcf", caster:GetAbsOrigin(), 5)
		local duration = Filters:GetAdjustedBuffDuration(caster, FLAMEWAKER_R3_STRENGTH_DURATION, false)
		caster:AddNewModifier(caster, self, "modifier_flamewaker_r_3_strength", {duration = duration})
	end
end

-- PASSIVE

function modifier_flamewaker_r_passive:IsHidden()
	return true
end

function modifier_flamewaker_r_passive:RemoveOnDeath()
	return false
end

function modifier_flamewaker_r_passive:IsPassive()
	return true
end

function modifier_flamewaker_r_passive:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({ 
        RPC_ELEMENT_FIRE,
        RPC_ELEMENT_EARTH
    })
end

function modifier_flamewaker_r_passive:GetRoshpitElementalDmgBonus()
	return self:GetCaster():GetRuneValue("r", 4)*(FLAMEWAKER_R4_FIRE_DAMAGE_AMP/100)
end

function modifier_flamewaker_r_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_START
	}
	return funcs
end

function modifier_flamewaker_r_passive:OnAttackStart(event)
	local caster = self:GetCaster()
	if caster ~= event.attacker or event.attacker ~= self:GetParent() then
		return false
	end
	local ability = self:GetAbility()
	local target = event.target
	local r_1_level = caster:GetRuneValue("r", 1)
	if r_1_level > 0 then
		local luck = RandomInt(1, 100)
		if luck <= FLAMEWAKER_R1_CHANCE and target:IsAlive() then
			if not target:IsNull() and not caster:HasModifier("modifier_flamewaker_r_1_mountain_strike") then
				StartAnimation(caster, {duration = 0.1, activity = ACT_DOTA_TELEPORT_END, rate = 2})
				EmitSoundOn("Flamewaker.QuietShield", target)

				Filters:ApplyStun(caster, 0.3, target)
				WallPhysics:Jump(caster, caster:GetForwardVector(), 0, 50, 6, 1.5)
				if target:GetModelScale() < 1.6 and not target.jumpLock then
					WallPhysics:Jump(target, target:GetForwardVector(), 0, 50, 6, 1.5)
				end
				caster:AddNewModifier(caster, ability, "modifier_flamewaker_r_1_mountain_strike", {duration = 0.21})
				Timers:CreateTimer(0.12, function()
					local particleName = "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/flamewaker_crit.vpcf"
					local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin() + Vector(0, 0, 40))
					local pfx2 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControl(pfx2, 0, target:GetAbsOrigin() + Vector(0, 0, 10))
					Timers:CreateTimer(0.4, function()
						ParticleManager:DestroyParticle(pfx, false)
						ParticleManager:DestroyParticle(pfx2, false)
					end)
					StartAnimation(caster, {duration = 0.1, activity = ACT_DOTA_ATTACK, rate = 3})
				end)
				Timers:CreateTimer(0.18, function()
					EmitSoundOn("Flamewaker.SpecialCrit", target)
					caster:PerformAttack(target, true, true, false, true, false, false, false)
					local damageApprox = math.ceil(OverflowProtectedGetAverageTrueAttackDamage(caster))
					PopupDamage(target, damageApprox)
				end)
			end
		end
	end

end

-- R1 MODIFIER

function modifier_flamewaker_r_1_mountain_strike:IsHidden()
	return true
end

function modifier_flamewaker_r_1_mountain_strike:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_MASTER_GREEN_DMG
    })
end

function modifier_flamewaker_r_1_mountain_strike:GetRoshpitMasterGreenDMG()
	return self:GetCaster():GetRuneValue("r", 1)*FLAMEWAKER_R1_BONUS_ATT_DMG_PCT
end

-- R3 MODIFIER

function modifier_flamewaker_r_3_strength:IsHidden()
	return false
end

function modifier_flamewaker_r_3_strength:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_STRENGTH_BONUS,
        MODIFIER_ROSHPIT_SPIRIT_BONUS
    })
end

function modifier_flamewaker_r_3_strength:GetRoshpitStrengthBonus()
	return FLAMEWAKER_R3_STRENGTH*self:GetCaster():GetRuneValue("r", 3)
end

function modifier_flamewaker_r_3_strength:GetRoshpitSpiritBonus()
	if self:GetCaster():HasModifier("modifier_flamewaker_glyph_6_1") then
		return self:GetRoshpitStrengthBonus()
	else
		return 0
	end
end

function modifier_flamewaker_r_3_strength:GetTexture()
	return "flamewaker/flamewaker_rune_r_3"
end