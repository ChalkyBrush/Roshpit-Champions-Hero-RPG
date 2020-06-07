bishop_of_hades_passive = class({})

modifier_bishop_hades_passive = class(npc_base_modifier, nil, npc_base_modifier)
modifier_bishop_of_hades_shield = class(npc_base_modifier, nil, npc_base_modifier)

LinkLuaModifier("modifier_bishop_hades_passive", "worlds/winterblight/abilities/bishop_of_hades_passive.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bishop_of_hades_shield", "worlds/winterblight/abilities/bishop_of_hades_passive.lua", LUA_MODIFIER_MOTION_NONE)


function bishop_of_hades_passive:GetIntrinsicModifierName()
    return "modifier_bishop_hades_passive"
end

-- MODIFIER

function modifier_bishop_hades_passive:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
    return funcs
end

function modifier_bishop_hades_passive:OnAttackLanded(event)
	if not IsServer() then
		return false
	end
    local attacker = event.attacker
    if not self:ParentIsAttacker(event) then
        return
    end
    local target = event.target
    local ability = event.ability
	local damage = target:GetMaxHealth()*(0.2)
	Enemies:ApplyDamageToPlayer(target, attacker, damage, DAMAGE_TYPE_MAGICAL, ability)
	local healAmount = damage * (ITEM_RPC_CLOAK_OF_THE_CIMMERIAN_PRIESTHOOD_HEAL_PCT/100)
	Filters:ApplyHeal(attacker, attacker, healAmount, true, true, ability)
end

function modifier_bishop_hades_passive:IsHidden()
	return true
end

function modifier_bishop_hades_passive:OnCreated()
	if not IsServer() then
		return
	end
	local ability = self:GetAbility()
	local target = self:GetParent()
	self:StartIntervalThink(1)
	ability.shieldCapacity = target:GetMaxHealth()*0.5
	-- self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_bishop_of_hades_shield", {duration = 10})
end

function modifier_bishop_hades_passive:OnIntervalThink()
	if not IsServer() then
		return
	end
	local ability = self:GetAbility()
	if not ability.interval then
		ability.interval = 0
	end
	local caster = self:GetParent()

	ability.interval = ability.interval + 1

	if ability.interval %12 == 0 then
		ability.shieldCapacity = self:GetParent():GetMaxHealth()*0.5
		caster:AddNewModifier(self:GetParent(), ability, "modifier_bishop_of_hades_shield", {duration = 10})
	end
	if not caster.aggro then
		return false
	end
	if ability.interval%10 == 0 then
		StartAnimation(self:GetParent(), {duration = 1, activity = ACT_DOTA_CAST_ABILITY_1, rate = 1})
		self:FearCircle()
	end
	local castAbility = caster:FindAbilityByName("bishop_of_hades_dot")
	if not caster:IsAlive() then
		return false
	end
	if castAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			local castPoint = enemies[1]:GetAbsOrigin()
			local newOrder = {
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = castAbility:entindex(),
				Position = castPoint
			}

			ExecuteOrderFromTable(newOrder)
			EmitSoundOn("Winterblight.BishopOfHades.Cast", caster)
		end
	end
end

function modifier_bishop_hades_passive:FearCircle()
	local hero = self:GetParent()
	local ability = self:GetAbility()
	CustomAbilities:QuickParticleAtPoint("particles/roshpit/items/cloak_of_cimmerian_priesthood/fear_ring.vpcf", hero:GetAbsOrigin(), 2)
	local radius = 900
	local duration = ability:GetSpecialValueFor("fear_duration")
	local enemies = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			if enemy.pushLock or enemy.dummy then
			else
				local direction = ((enemy:GetAbsOrigin() - hero:GetAbsOrigin())*Vector(1,1,0)):Normalized()
				local targetPosition = enemy:GetAbsOrigin() + direction * 200 * duration
				enemy:MoveToPosition(targetPosition)
				enemy:AddNewModifier(hero, ability, "modifier_fear", {duration = duration})
				enemy:MoveToPosition(targetPosition)
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell_fear_debuff.vpcf", enemy, duration)
			end
		end
	end	
	EmitSoundOn("RPCItems.Cimmerian.Fear", hero)
end

function modifier_bishop_of_hades_shield:IsHidden()
	return false
end

function modifier_bishop_of_hades_shield:IsBuff()
	return true
end

function modifier_bishop_of_hades_shield:RemoveOnDeath()
	return true
end

function modifier_bishop_of_hades_shield:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_HP_SHIELD
    })
end

function modifier_bishop_of_hades_shield:HPShieldTakeDamage(event)
	local target = event.victim
	local damage = event.damage
	local ability = self:GetAbility()
	local damage_absorbed = math.min(ability.shieldCapacity, damage)
	ability.shieldCapacity = ability.shieldCapacity - damage_absorbed
	if ability.shieldCapacity <= 0 then
		target:RemoveModifierByName("modifier_bishop_of_hades_shield")
	end
	return damage_absorbed
end

function modifier_bishop_of_hades_shield:GetEffectName()
	return "particles/roshpit/items/cloak_of_cimmerian_priesthood/e_shield.vpcf"
end

function modifier_bishop_of_hades_shield:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end
