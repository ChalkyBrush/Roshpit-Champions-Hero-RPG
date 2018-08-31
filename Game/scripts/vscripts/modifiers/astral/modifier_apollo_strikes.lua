modifier_apollo_strikes = class({})

LinkLuaModifier("modifier_apollo_stats_visible", "modifiers/astral/modifier_apollo_stats_visible", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_apollo_stats_invisible", "modifiers/astral/modifier_apollo_stats_invisible", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_apollo_post_mit_visible", "modifiers/astral/modifier_apollo_post_mit_visible", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_apollo_post_mit_invisible", "modifiers/astral/modifier_apollo_post_mit_invisible", LUA_MODIFIER_MOTION_NONE)

function modifier_apollo_strikes:DeclareFunctions()
	local funcs = { MODIFIER_EVENT_ON_DEATH,

}
	return funcs
end

function modifier_apollo_strikes:OnCreated( table )
	self:StartIntervalThink(0.03)
end

function modifier_apollo_strikes:OnIntervalThink()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local target = ability.target
	if IsValidEntity(ability) then
		if (not target:IsNull()) and target and target:IsAlive() then
			caster:PerformAttack(target, true, true, true, false, true, false, false)
			local manaCost = ability:GetManaCost(ability:GetLevel())
			caster:ReduceMana(manaCost)
			local newStacks = target:GetModifierStackCount("modifier_apollo_strikes", caster) - 1
			if newStacks == 0 then
				target:RemoveModifierByName("modifier_apollo_strikes")
			else
				target:SetModifierStackCount("modifier_apollo_strikes", caster, newStacks)
			end
			StartAnimation(caster, {duration=0.1, activity=ACT_DOTA_ATTACK, rate=4})
			if ability.w_1_level > 0 then
				caster:AddNewModifier(caster, ability, "modifier_apollo_stats_visible", {duration = 8})
				local newStacks = math.min(100, caster:GetModifierStackCount("modifier_apollo_stats_visible", caster) + 1)
				caster:SetModifierStackCount("modifier_apollo_stats_visible", caster, newStacks)
				caster:AddNewModifier(caster, ability, "modifier_apollo_stats_invisible", {duration = 8})
				caster:SetModifierStackCount("modifier_apollo_stats_invisible", caster, newStacks*ability.w_1_level)
			end
			if ability.w_4_level > 0 then
				if not ability.w_4_target then
					ability.w_4_target = target
				end
				if ability.w_4_target == target then
					caster:AddNewModifier(caster, ability, "modifier_apollo_post_mit_visible", {duration = 8})
					local newStacks = math.min(50, caster:GetModifierStackCount("modifier_apollo_post_mit_visible", caster) + 1)
					caster:SetModifierStackCount("modifier_apollo_post_mit_visible", caster, newStacks)
					caster:AddNewModifier(caster, ability, "modifier_apollo_post_mit_invisible", {duration = 8})
					caster:SetModifierStackCount("modifier_apollo_post_mit_invisible", caster, newStacks*ability.w_4_level)
				else
					ability.w_4_target = target
					caster:RemoveModifierByName("modifier_apollo_post_mit_visible")
					caster:RemoveModifierByName("modifier_apollo_post_mit_invisible")
				end
			end
		else

		end
	else
		target:RemoveModifierByName("modifier_apollo_strikes")
	end
end

function modifier_apollo_strikes:OnDestroy()
	-- self:GetAbility():SetActivated(true)
	self:GetAbility().active = true
end

function modifier_apollo_strikes:OnDeath()
	local ability = self:GetAbility()
	local target = ability.target
	local caster = self:GetCaster()
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	if #enemies > 0 then
		local newTarget = enemies[1]
		local stacks = ability.shots
		target:RemoveModifierByName("modifier_apollo_strikes")
		newTarget:AddNewModifier(caster, ability, "modifier_apollo_strikes", {})
		newTarget:SetModifierStackCount("modifier_apollo_strikes", caster, stacks)
		ability.target = newTarget
	else
		caster:RemoveModifierByName("modifier_apollo_outgoing_shots")
	end 
end

function modifier_apollo_strikes:IsDebuff()
	return true
end

function modifier_apollo_strikes:IsHidden()
	return false
end