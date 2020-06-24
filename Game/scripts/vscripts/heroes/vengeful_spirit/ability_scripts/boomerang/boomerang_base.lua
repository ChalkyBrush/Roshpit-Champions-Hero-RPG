require('heroes/vengeful_spirit/solunia_constants')
require('heroes/base_ability')
boomerang_base = class(base_ability)

modifier_solunia_w_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_solunia_w_passive", "heroes/vengeful_spirit/ability_scripts/boomerang/boomerang_base.lua", LUA_MODIFIER_MOTION_NONE)

modifier_boomerang_thinker = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_boomerang_thinker", "heroes/vengeful_spirit/ability_scripts/boomerang/boomerang_base.lua", LUA_MODIFIER_MOTION_NONE)

function boomerang_base:IsSoluniaState(state)
	if self:GetAbilityName() == "solonua_boomerang_solar" and state == SOLUNIA_STATE_SOLAR then
		return true
	elseif self:GetAbilityName() == "solonua_boomerang_lunar" and state == SOLUNIA_STATE_LUNAR then
		return true
	else
		return false
	end
end

function boomerang_base:GetManaCostBase(level)
    return 0
end

function boomerang_base:GetBehaviorBase()
	return DOTA_ABILITY_BEHAVIOR_DIRECTIONAL + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end

function boomerang_base:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_2
end

function boomerang_base:GetAbilitySlot()
    return DOTA_E_SLOT
end

function boomerang_base:GetCastPoint()
    return 0.36
end

function boomerang_base:GetCastRange()
    return self:GetSpecialValueFor("range")
end

function boomerang_base:GetCooldownBase(level)
    return 0
end

function boomerang_base:GetIntrinsicModifierName()
	return "modifier_solunia_w_passive"
end

function boomerang_base:OnAbilityPhaseStart()
	local ability = self
	local caster = self:GetCaster()
	StartAnimation(caster, {duration = 0.6, activity = ACT_DOTA_ATTACK, rate = 1, translate = "loadout"})
	EmitSoundOn("Selethas.Throw.VO", caster)

	return true
end

function boomerang_base:GetMaximumConcurrentBoomerangs()
	return self:GetSpecialValueFor("max_boomerangs")
end

function boomerang_base:BoomerangStart()
	local caster = self:GetCaster()
	
	local ability = self

	EmitSoundOn("Selethas.Boomerang.Throw", caster)
	local target = self:GetCastPosition()
	
	local fv = (target * Vector(1, 1, 0) - caster:GetAbsOrigin() * Vector(1, 1, 0)):Normalized()
	local boomerang = CreateUnitByName("npc_dummy_unit", caster:GetAbsOrigin() + Vector(0, 0, 100), false, caster, nil, caster:GetTeamNumber())

	if not ability.boomerangTable then
		ability.boomerangTable = {}
	end

	table.insert(ability.boomerangTable, boomerang)
	ability.boomerang = boomerang
	boomerang:SetAngles(0, 0, 0)

	boomerang.fv = fv
	boomerang.throwPosition = caster:GetAbsOrigin()
	boomerang.spinAngularVelocity = WallPhysics:rotateVector(fv, math.pi / 2)
	boomerang.rotationAngle = 0
	boomerang.interval = 0
	boomerang:SetModelScale(0)

	local modelName = self:GetBoomerangModelName()
	boomerang:SetModel(modelName)
	boomerang:SetOriginalModel(modelName)

	boomerang:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0,0,90) + fv * 58 - boomerang.spinAngularVelocity * 28)

	boomerang.throwPower = WallPhysics:GetDistance2d(target, caster:GetAbsOrigin()) / 30 + 6
	local renderColor = self:GetBoomerangRenderColor()
	boomerang:SetRenderColor(renderColor.x, renderColor.y, renderColor.z)

	boomerang:AddNewModifier(caster, ability, "modifier_boomerang_thinker", {})

	self:UpdateCasterOutgoingBoomerangCounter()
	Filters:CastSkillArguments(BASE_ABILITY_W, caster)
end

function boomerang_base:UpdateCasterOutgoingBoomerangCounter()
	local caster = self:GetCaster()
	local ability = self
	if #ability.boomerangTable > 0 then
		caster:AddNewModifier(caster, ability, self:GetCounterModifierName(), {})
		caster:SetModifierStackCount(self:GetCounterModifierName(), caster, #ability.boomerangTable)
		ability.weaponFX:SetModel(nil)
	else
		caster:RemoveModifierByName(self:GetCounterModifierName())
		ability.weaponFX:SetModel(ability.weaponFXname)
	end
	if #ability.boomerangTable >= self:GetMaximumConcurrentBoomerangs() then
		ability:SetActivated(false)
	else
		ability:SetActivated(true)
	end
end

function boomerang_base:ReindexBoomerangs()
	local ability = self
	local tempTable = {}
	for i = 1, #ability.boomerangTable, 1 do
		if IsValidEntity(ability.boomerangTable[i]) then
			table.insert(tempTable, ability.boomerangTable[i])
		end
	end
	ability.boomerangTable = tempTable
end

function boomerang_base:GetBoomerangBaseDamage()
	return self:GetSpecialValueFor("damage")
end

-- PASSIVE

function modifier_solunia_w_passive:IsHidden()
	return true
end

function modifier_solunia_w_passive:OnCreated()
	if not IsServer() then
		return false
	end
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	if not ability.initiated then
		for k, v in pairs(caster:GetChildren()) do
			if v:GetClassname() == "dota_item_wearable" then
				local model = v:GetModelName()
				ability.weaponFX = v
				ability.weaponFXname = model
				break
			end
		end
		ability.initiated = true
	end
end

-- BOOMERANG THINKER
function modifier_boomerang_thinker:IsHidden()
	return true
end

function modifier_boomerang_thinker:OnCreated()
	if not IsServer() then
		return false
	end
	self:StartIntervalThink(0.03)
end

function modifier_boomerang_thinker:CheckState()
	local state = {
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
	return state	
end

function modifier_boomerang_thinker:GetEffectName()
	local ability = self:GetAbility()
	return ability:GetEffectParticleName()
end

function modifier_boomerang_thinker:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_boomerang_thinker:OnIntervalThink()
	if not IsServer() then
		return false
	end
	local boomerang = self:GetParent()
	local caster = self:GetCaster()
	if boomerang.disabled then
		return false
	end
	local ability = self:GetAbility()
	local spinAngularVelocity = boomerang.spinAngularVelocity
	if not spinAngularVelocity then
		boomerang.spinAngularVelocity = WallPhysics:rotateVector(boomerang.fv, math.pi / 60)
	end
	if boomerang.interval < 25 then
		boomerang:SetModelScale(boomerang.interval * 0.04)
	end

	local targetPointFV = ((caster:GetAbsOrigin() + spinAngularVelocity * math.max((240 - boomerang.interval * 2), 0) - boomerang:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()

	boomerang.throwPower = math.max(boomerang.throwPower - 0.4, 18)
	local finalMoveVector = (boomerang.fv * boomerang.throwPower + targetPointFV * 0.2 * (boomerang.interval ^ 1.1))
	-- local enemies = FindUnitsInRadius(boomerang:GetTeamNumber(), boomerang:GetAbsOrigin(), nil, 100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

	local stickToTarget = nil
	-- if #enemies > 0 then
	-- 	stickToTarget = enemies[1]
	-- end

	if stickToTarget then
		local distance3 = CalcDistanceBetweenEntityOBB(boomerang, stickToTarget)
		if distance3 > 125 or boomerang.interval > 100 then
			boomerang:SetAbsOrigin(boomerang:GetAbsOrigin() + finalMoveVector)
		else
			boomerang:SetAbsOrigin(stickToTarget:GetAbsOrigin())
		end
	else
		boomerang:SetAbsOrigin(boomerang:GetAbsOrigin() + finalMoveVector)
	end
	
	if boomerang.interval % 7 == 0 then
		self:DamageThinker()
	end

	if boomerang.interval % 15 == 0 then
		EmitSoundOn("Selethas.Boomerang.Spinning", boomerang)
	end

	local height = GetGroundHeight(boomerang:GetAbsOrigin(), boomerang)
	if boomerang:GetAbsOrigin().z - height > 100 then
		boomerang:SetAbsOrigin(boomerang:GetAbsOrigin() - Vector(0, 0, 10))
	elseif boomerang:GetAbsOrigin().z - height < 60 then
		boomerang:SetAbsOrigin(boomerang:GetAbsOrigin() + Vector(0, 0, 10))
	end
	boomerang.rotationAngle = boomerang.rotationAngle + 45
	boomerang:SetAngles(0, boomerang.rotationAngle, 0)
	if boomerang.rotationAngle == 360 then
		boomerang.rotationAngle = 0
	end
	local origAbility = boomerang.origAbility
	boomerang.interval = boomerang.interval + 1

	if boomerang.interval > 30 then
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), boomerang:GetAbsOrigin())
		local distanceThreshold = 30
		if boomerang.interval < 70 then
			distanceThreshold = 100
		elseif boomerang.interval < 120 then
			distanceThreshold = 80
		end
		if distance < distanceThreshold then
			StartAnimation(caster, {duration = 0.5, activity = ACT_DOTA_SPAWN, rate = 2.5})
			boomerang.disabled = true
			Timers:CreateTimer(0.03, function()
				UTIL_Remove(boomerang)
				ability:ReindexBoomerangs()
				ability:UpdateCasterOutgoingBoomerangCounter()
			end)

			return false
		end
	end

end

function modifier_boomerang_thinker:DamageThinker()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local boomerang = self:GetParent()
	local crit = false
	local damage = ability:GetBoomerangBaseDamage()
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), boomerang:GetAbsOrigin(), nil, 120, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			if crit then
				EmitSoundOn("Solunia.BoomerangCrit", boomerang)
				PopupDamage(target, math.floor(damage))
				local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
				ParticleManager:SetParticleControlEnt(pfx, 0, enemy, PATTACH_ABSORIGIN_FOLLOW, "follow_origin", enemy:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(pfx, 1, enemy, PATTACH_ABSORIGIN_FOLLOW, "follow_origin", enemy:GetAbsOrigin(), true)
				Timers:CreateTimer(5, function()
					ParticleManager:DestroyParticle(pfx, false)
					ParticleManager:ReleaseParticleIndex(pfx)
				end)
			end
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, ability:GetAbilityDamageType(), BASE_ABILITY_W, ability:GetAbilityElement(1), ability:GetAbilityElement(2))
			CustomAbilities:QuickAttachParticle("particles/roshpit/solunia/boomerang_impact.vpcf", enemy, 0.3)
			EmitSoundOn("Solunia.BoomerangImpact", enemy)
		end
	end
end