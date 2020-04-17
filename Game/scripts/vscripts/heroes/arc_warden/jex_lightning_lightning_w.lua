require('heroes/arc_warden/jex_constants')
require('heroes/base_ability')
jex_lightning_lightning_w = class(base_ability)

function jex_lightning_lightning_w:GetManaCostBase(level)
    if level == -1 or level == nil then
        level = self:GetLevel() - 1
    end
    return JEX_LIGHTNING_LIGHTNING_W_MANA_COST[level + 1]
end

function jex_lightning_lightning_w:GetBehaviorBase()
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL + DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_TOGGLE
end

function jex_lightning_lightning_w:GetAbilitySlot()
    return DOTA_W_SLOT
end

function jex_lightning_lightning_w:GetCastPoint()
    return 0
end

function jex_lightning_lightning_w:GetCooldownBase(level)
    return 0
end

function jex_lightning_lightning_w:IsToggle()
    return true
end

function jex_lightning_lightning_w:OnToggle()
    if IsServer() then
        local ability = self
        local caster = self:GetCaster()
        if self:GetToggleState() then
            ability.tech_level = GetOnibiTotalTechLevel(caster, "lightning", "lightning", "W")
            caster:AddNewModifier(caster, ability, "modifier_jex_lightning_lightning_w", {})
            caster:AddNewModifier(caster, ability, "modifier_jex_lightning_lightning_w_damage_buff", {})
            caster:SetModifierStackCount("modifier_jex_lightning_lightning_w_damage_buff", caster, ability.tech_level)
            EmitSoundOn("Jex.VortexWeaponActivate", caster)
            StartAnimation(caster, {duration = 0.3, activity = ACT_DOTA_OVERRIDE_ABILITY_4, rate = 1.5})
        else
            caster:RemoveModifierByName("modifier_jex_lightning_lightning_w")
            caster:RemoveModifierByName("modifier_jex_lightning_lightning_w_damage_buff")
        end
    end
end

modifier_jex_lightning_lightning_w = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_jex_lightning_lightning_w", "heroes/arc_warden/jex_lightning_lightning_w", LUA_MODIFIER_MOTION_NONE)

function modifier_jex_lightning_lightning_w:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end
function modifier_jex_lightning_lightning_w:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        
    })
end

function modifier_jex_lightning_lightning_w:OnAttackLanded(event)
	local caster = self:GetParent()
	local ability = self:GetAbility()
	local target = event.target
	local drain_mana = ability:GetManaCost()
    if caster:GetMana() < ability:GetManaCost(-1) then
        ability:ToggleAbility()
        return false
    else
        ability:PayManaCost()
    end
	local max_targets = ability.tech_level * JEX_LIGHTNING_LIGHTNING_W_CHAIN_PER_TECH
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false)
	local targets_to_hit = math.min(#enemies, max_targets)
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * JEX_LIGHTNING_LIGHTNING_W_DAMAGE_PCT[ability:GetLevel()]
	local w_4_level = caster:GetRuneValue("w", 4)
	if w_4_level > 0 then
		damage = damage + caster:GetAgility() * w_4_level * JEX_LIGHTNING_LIGHTNING_W_BASE_DMG_PER_AGI_PER_W4
	end
	for i = 1, targets_to_hit, 1 do
		Timers:CreateTimer((i - 1) * 0.15, function()
			local enemy = enemies[i]
			if IsValidEntity(enemy) and enemy:IsAlive() then
				EmitSoundOn("Jex.Thundershroom.Lightning", enemy)
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
				local particleName = "particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf"
				local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_CUSTOMORIGIN, nil)
				local attach_unit_1 = target
				if i > 1 then
					attach_unit_1 = enemies[i - 1]
				end
				ParticleManager:SetParticleControl(pfx, 0, attach_unit_1:GetAbsOrigin() + Vector(0, 0, attach_unit_1:GetBoundingMaxs().z + 40))
				ParticleManager:SetParticleControl(pfx, 1, enemy:GetAbsOrigin() + Vector(0, 0, enemy:GetBoundingMaxs().z + 60))
				Timers:CreateTimer(0.3, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)
			end
		end)
	end
	Filters:CastSkillArguments(BASE_ABILITY_W, caster)
end
function modifier_jex_lightning_lightning_w:GetModifierAttackSpeedBonus_Constant()
    return JEX_LIGHTNING_LIGHTNING_W_BONUS_ATTACKSPEED[self:GetAbility():GetLevel()]
end
function modifier_jex_lightning_lightning_w:GetStatusEffectName()
    return "particles/status_fx/status_effect_electrical.vpcf"
end
function modifier_jex_lightning_lightning_w:StatusEffectPriority()
    return 100
end
function modifier_jex_lightning_lightning_w:GetEffectName()
    return "particles/roshpit/jex/thunder_flow_ambient.vpcf"
end
function modifier_jex_lightning_lightning_w:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN
end

modifier_jex_lightning_lightning_w_damage_buff = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_jex_lightning_lightning_w_damage_buff", "heroes/arc_warden/jex_lightning_lightning_w", LUA_MODIFIER_MOTION_NONE)

function modifier_jex_lightning_lightning_w_damage_buff:IsHidden()
    return false
end
function modifier_jex_lightning_lightning_w_damage_buff:IsBuff()
    return true
end
function modifier_jex_lightning_lightning_w_damage_buff:GetTexture()
    return "jex/invoked_abilities/vortex_weapon"
end
function modifier_jex_lightning_lightning_w_damage_buff:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end
function modifier_jex_lightning_lightning_w_damage_buff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
    }

    return funcs
end

function modifier_jex_lightning_lightning_w_damage_buff:GetModifierBaseDamageOutgoing_Percentage()
    return self:GetStackCount() * JEX_LIGHTNING_LIGHTNING_W_BONUS_DAMAGE_PCT_PER_TECH
end