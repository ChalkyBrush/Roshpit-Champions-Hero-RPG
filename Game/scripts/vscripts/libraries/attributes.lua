if not Attributes then
    Attributes = class({})
end

function Attributes:Init()
    local v = LoadKeyValues("scripts/kv/attributes.kv")
    LinkLuaModifier("modifier_movespeed_cap", "libraries/modifiers/modifier_movespeed_cap", LUA_MODIFIER_MOTION_NONE)

    -- Default Dota Values
    local DEFAULT_HP_PER_STR = 20
    local DEFAULT_HP_REGEN_PER_STR = 0.06
    local DEFAULT_MANA_PER_INT = 12
    local DEFAULT_MANA_REGEN_PER_INT = 0.04
    local DEFAULT_ARMOR_PER_AGI = 0.16
    local DEFAULT_ATKSPD_PER_AGI = 1
    local DEFAULT_SPELLDMG_PER_INT = 1 / 11

    Attributes.hp_adjustment = v.HP_PER_STR - DEFAULT_HP_PER_STR
    Attributes.hp_regen_adjustment = v.HP_REGEN_PER_STR - DEFAULT_HP_REGEN_PER_STR
    Attributes.mana_adjustment = v.MANA_PER_INT - DEFAULT_MANA_PER_INT
    Attributes.mana_regen_adjustment = v.MANA_REGEN_PER_INT - DEFAULT_MANA_REGEN_PER_INT
    Attributes.armor_adjustment = v.ARMOR_PER_AGI - DEFAULT_ARMOR_PER_AGI
    Attributes.attackspeed_adjustment = v.ATKSPD_PER_AGI - DEFAULT_ATKSPD_PER_AGI
    Attributes.spellpower_adjustment = v.SP_INT - DEFAULT_SPELLDMG_PER_INT

    Attributes.v = v

    Attributes.applier = RPCItems:CreateItem("item_stat_modifier", nil, nil)
end

function Attributes:ModifyBonuses(hero)

    --print("Modifying Stats Bonus of hero "..hero:GetUnitName())

    -- hero:AddNewModifier(hero, nil, "modifier_movespeed_cap", {})
    Timers:CreateTimer(function()

        if not IsValidEntity(hero) then
            return
        end

        -- Initialize value tracking
        if not hero.custom_stats then
            hero.custom_stats = true
            hero.strength = 0
            hero.agility = 0
            hero.intellect = 0
        end

        -- Get player attribute values
        local strength = hero:GetStrength()
        local agility = hero:GetAgility()
        local intellect = hero:GetIntellect()

        -- Base Armor Bonus
        local armor = agility * Attributes.armor_adjustment
        if hero:HasModifier("modifier_halcyon_soul_glove") then
            armor = armor + agility * Attributes.v.ARMOR_PER_AGI * HALCYON_SOUL_GLOVE_BONUS
        end
        hero:SetPhysicalArmorBaseValue(armor)

        -- STR
        if strength ~= hero.strength then

            -- HP Bonus
            if not hero:HasModifier("modifier_health_bonus") then
                Attributes.applier:ApplyDataDrivenModifier(hero, hero, "modifier_health_bonus", {})
            end

            local health_stacks = math.abs(strength * Attributes.hp_adjustment)
            if hero:HasModifier("modifier_halcyon_soul_glove") then
                health_stacks = health_stacks + strength * Attributes.v.HP_PER_STR * HALCYON_SOUL_GLOVE_BONUS
            end
            if hero:GetMaxHealth() - health_stacks > 1000 then
                hero:SetModifierStackCount("modifier_health_bonus", Attributes.applier, health_stacks)
            end

            -- HP Regen Bonus
            if not hero:HasModifier("modifier_health_regen_constant") then
                Attributes.applier:ApplyDataDrivenModifier(hero, hero, "modifier_health_regen_constant", {})
            end

            local health_regen_stacks = math.abs(strength * Attributes.hp_regen_adjustment * 100)
            if hero:HasModifier("modifier_halcyon_soul_glove") then
                health_regen_stacks = health_regen_stacks + strength * Attributes.v.HP_REGEN_PER_STR * HALCYON_SOUL_GLOVE_BONUS
            end
            hero:SetModifierStackCount("modifier_health_regen_constant", Attributes.applier, health_regen_stacks)
        end

        -- AGI
        -- if agility ~= hero.agility then

        --     -- Attack Speed Bonus
        --     if not hero:HasModifier("modifier_attackspeed_bonus_constant") then
        --         Attributes.applier:ApplyDataDrivenModifier(hero, hero, "modifier_attackspeed_bonus_constant", {})
        --     end

        --     local attackspeed_stacks = math.abs(agility * Attributes.attackspeed_adjustment)
        --     hero:SetModifierStackCount("modifier_attackspeed_bonus_constant", Attributes.applier, attackspeed_stacks)
        -- end

        -- INT
        if intellect ~= hero.intellect then

            -- Mana Bonus
            if not hero:HasModifier("modifier_mana_bonus") then
                Attributes.applier:ApplyDataDrivenModifier(hero, hero, "modifier_mana_bonus", {})
            end

            local mana_stacks = math.abs(intellect * Attributes.mana_adjustment)
            --print("MANA STACKS A:")
            --print(mana_stacks)
            if hero:HasModifier("modifier_halcyon_soul_glove") then
                mana_stacks = mana_stacks - intellect * Attributes.v.MANA_PER_INT * HALCYON_SOUL_GLOVE_BONUS
            end
            --print("MANA STACKS B:")
            --print(mana_stacks)
            if hero:GetMaxMana() - mana_stacks > 300 then
                hero:SetModifierStackCount("modifier_mana_bonus", Attributes.applier, mana_stacks)
            end

            -- Mana Regen Bonus
            if not hero:HasModifier("modifier_base_mana_regen") then
                Attributes.applier:ApplyDataDrivenModifier(hero, hero, "modifier_base_mana_regen", {})
            end

            local mana_regen_stacks = math.abs(intellect * Attributes.mana_regen_adjustment * 100)
            if hero:HasModifier("modifier_halcyon_soul_glove") then
                mana_regen_stacks = mana_regen_stacks + intellect * Attributes.v.MANA_REGEN_PER_INT * HALCYON_SOUL_GLOVE_BONUS
            end
            hero:SetModifierStackCount("modifier_base_mana_regen", Attributes.applier, mana_regen_stacks)

            --SPELL DAMAGE STACKS
            -- if not hero:HasModifier("modifier_spell_damage_constant") then
            --     Attributes.applier:ApplyDataDrivenModifier(hero, hero, "modifier_spell_damage_constant", {})
            -- end

            -- local spellpower_stacks = intellect
            --print(spellpower_stacks)
            -- hero:SetModifierStackCount("modifier_spell_damage_constant", Attributes.applier, spellpower_stacks)

        end

        -- Update the stored values for next timer cycle
        hero.strength = strength
        hero.agility = agility
        hero.intellect = intellect

        hero:CalculateStatBonus()
        if hero:GetMaxMana() < intellect * 5 then
            --print("REMOVE MANA MOD")
            hero:RemoveModifierByName("modifier_mana_bonus")
        end
        return 0.03
    end)
end

-- if not Attributes.applier then Attributes:Init() end
