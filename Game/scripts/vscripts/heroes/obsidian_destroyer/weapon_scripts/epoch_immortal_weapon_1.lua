require('items/lua/weapon/base_weapon')
require('npc_abilities/base_modifier')

item_rpc_epoch_immortal_weapon_1 = class(BaseWeapon, nil, BaseWeapon)
local itemClass = item_rpc_epoch_immortal_weapon_1
local itemClassName = 'item_rpc_epoch_immortal_weapon_1'

modifier_epoch_immortal_weapon_1 = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_epoch_immortal_weapon_1
local modifierName = 'modifier_epoch_immortal_weapon_1'
LinkLuaModifier(modifierName, "heroes/obsidian_destroyer/weapon_scripts/epoch_immortal_weapon_1", LUA_MODIFIER_MOTION_NONE)

function itemClass:RequiredHero()
	return "epoch"
end

function itemClass:GetClassName()
    return itemClassName
end

function itemClass:GetName()
    return 'Epoch Immortal Weapon 1'
end

function itemClass:GetModifierName()
    return modifierName
end

function itemClass:RollProperty1(item_level)
	self.newItemTable.property1 = 1
	self.newItemTable.property1name = "immortal_weapon_1"
	RPCItems:SetPropertyValuesSpecial(self, "★", "#item_property_"..self:RequiredHero().."_immortal_weapon", "#42F48F", 1, "#property_"..self:RequiredHero().."_immortal_weapon_description")
end

function itemClass:RollProperty2(item_level)
    Weapons:SetLegendWeaponProperty2(self, "attack_damage", 2)
end

-- WEAPON MODIFIER
function modifierClass:OnCreated()
    if not IsServer() then
        return
    end
end

function modifierClass:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_START
    }
    return funcs
end

function modifierClass:IsHidden()
    return true
end

function modifierClass:IsBuff()
    return true
end

function modifierClass:RemoveOnDeath()
    return false
end

function modifierClass:OnAttackStart(event)
    if not IsServer() then
        return
    end
    if not self:ParentIsAttacker(event) then
        return false
    end
    local caster = self:GetParent()
    local target = event.target
    local ability = caster:GetAbilityByIndex(DOTA_Q_SLOT)
    if target:HasModifier("modifier_epoch_time_bind") then
        local attack_targets = {}
        for i = 1, #ability.link_sets, 1 do
            if ability.link_sets[i] then
                if ability.link_sets[i][target:GetEntityIndex()] then
                    local set = ability.link_sets[i]
                    for source, link in pairs(set) do
                        local unit = EntIndexToHScript(source)
                        if unit:GetEntityIndex() ~= target:GetEntityIndex() then
                            table.insert(attack_targets, unit)
                        end
                    end
                end
            end
        end
        for i = 1, #attack_targets, 1 do
            local attack_start_event = {}
            attack_start_event.attacker = caster
            attack_start_event.target = attack_targets[i]
            local passive_modifier = caster:FindModifierByName("modifier_epoch_q_passive")
            passive_modifier:OnAttackStart(attack_start_event)
            Filters:PerformAttackSpecial(caster, attack_targets[i], true, true, true, false, true, false, false)
        end   
    elseif target:HasModifier("modifier_epoch_arcana_q_root") then
        local attack_targets = {}
        for source, bool in pairs(ability.bind_table) do
            local unit = EntIndexToHScript(source)
            if unit:GetEntityIndex() ~= target:GetEntityIndex() then
                table.insert(attack_targets, unit)
            end            
        end
        for i = 1, #attack_targets, 1 do
            local attack_start_event = {}
            attack_start_event.attacker = caster
            attack_start_event.target = attack_targets[i]
            local passive_modifier = caster:FindModifierByName("modifier_epoch_arcana_q_passive")
            passive_modifier:OnAttackStart(attack_start_event)
            Filters:PerformAttackSpecial(caster, attack_targets[i], true, true, true, false, true, false, false)
        end            
    end
end