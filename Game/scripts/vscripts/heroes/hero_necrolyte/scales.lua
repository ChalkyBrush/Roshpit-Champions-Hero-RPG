require('/heroes/hero_necrolyte/constants')

local module = {
     getBad = function(caster)
         local mult = 0
        local modifier = caster:FindModifierByName("modifier_gale_nova_bad")
        if modifier then
            mult = mult + modifier:GetStackCount() * Q1_BAD_PER_ENEMY_PERCENT/100
        end
         modifier = caster:FindModifierByName("modifier_venomort_arcana2_q_4_invisible")
         if modifier then
             mult = mult + modifier:GetStackCount() * ARCANA2_Q4_BAD_PERCENT/100
         end
        return mult
    end,
    onDotDamageDo = function(caster, target)
        local heroName = caster:GetName()
        if heroName ~= "npc_dota_hero_necrolyte" then
            return
        end

        if not target:IsAlive() then
            return
        end

        local q3_level =  caster:GetRuneValue("q", 3)
        if q3_level ~= 0 then
            local duration = ARCANA2_Q3_DURATION
            local ability = caster:FindAbilityByName('venomort_frostvenom_grasp')
            if ability then
                ability:ApplyDataDrivenModifier(caster, target, "modifier_venomort_frostvenom_graps_dot_amp", {duration = duration})

                local modifier = target:FindModifierByName("modifier_venomort_frostvenom_graps_dot_amp")
                local stacks = modifier:GetStackCount()

                stacks = math.min(stacks + q3_level, q3_level * ARCANA2_Q3_MAX_STACKS_COUNT)
                modifier:SetStackCount(stacks)
            end
        end

        local e4_level =  caster:GetRuneValue("e", 4)
        if e4_level ~= 0 then
            local duration = VENOMORT_E4_DURATION

            if caster:HasModifier("modifier_venomort_glyph_4_2") then
                duration = T42_DURATION
            end

            local ability = caster:FindAbilityByName('venomort_ghost_warp')
            if not target:FindModifierByName('modifier_venomort_e4_enemy_debuff') then
                ability:ApplyDataDrivenModifier(caster, target, "modifier_venomort_e4_enemy_debuff", {duration = duration})
            end
        end

        local modifier = caster:FindModifierByName("modifier_venomort_glyph_6_1")
        if modifier then
            local glyphAbility = modifier:GetAbility()
            glyphAbility:ApplyDataDrivenModifier(caster, target, "modifier_venomort_glyph_6_1_damage_reduction", {duration = T61_DURATION})
        end
    end,
    getDotAmplify = function(caster, target)
        if IsValidEntity(target) then
            local modifier = target:FindModifierByName("modifier_venomort_frostvenom_graps_dot_amp")
            if modifier then
                return modifier:GetStackCount() * ARCANA2_Q3_DOT_AMPLIFY_PERCENT/100
            end
        end
        return 0
    end,
    getElementBonus = function(victim, attacker, damage, damage_type, slot, element1, element2, bIsRealDamage)
        local heroName = attacker:GetName()
        if heroName ~= "npc_dota_hero_necrolyte" then
            return 0
        end

        local mult = 0


        local e1_level =  attacker:GetRuneValue("e", 1)
        if e1_level ~= 0 then
            local e1_elements = {
                RPC_ELEMENT_POISON
            }
            if attacker:HasModifier("modifier_venomort_glyph_4_1") then
                table.insert(e1_elements, RPC_ELEMENT_GHOST)
                table.insert(e1_elements, RPC_ELEMENT_UNDEAD)
                table.insert(e1_elements, RPC_ELEMENT_SHADOW)
            end
            for index, e1_element in ipairs(e1_elements) do
                if element1 == e1_element or element2 == e1_element then
                    mult = mult + e1_level * E1_POISON_AMPLIFY_PERCENT/100
                end
            end
        end

        return mult
    end,
    getPostMitigation = function(caster, target)
        local heroName = caster:GetName()
        if heroName ~= "npc_dota_hero_necrolyte" then
            return 0
        end
        local mult = 0
        local w4_level = caster:GetRuneValue("w", 4)
        if w4_level ~= 0 then
            mult = mult + w4_level * W4_POSTMIT_PER_HP_PERCENT/100 * (1 - target:GetHealth()/target:GetMaxHealth()) * 100
        end

        if caster:HasModifier("modifier_venomort_glyph_7_2") then
            if target:GetHealth()/target:GetMaxHealth() >= T72_HEALTH_THRESHOLD_PERCENT/100 then
                mult = mult + T72_POSTMITIGATION_PERCENT/100
            end
        end
        return mult
    end,
    getDamageDecrease = function(victim, attacker, damagetype)
        local mult = 1;
        if attacker:GetName() == "npc_dota_hero_necrolyte" or victim:GetName() == "npc_dota_hero_necrolyte"  then
            local modifier = attacker:FindModifierByName('modifier_venomort_summon_damage_reduction')
            if modifier then
                mult = mult * (1 - R3_DAMAGE_REDUCTION_PERCENT/100)^modifier:GetStackCount();
            end
            if damagetype == DAMAGE_TYPE_PURE or damagetype == DAMAGE_TYPE_MAGICAL then
                modifier = attacker:FindModifierByName('modifier_venomort_glyph_6_1_damage_reduction')
                if modifier then
                    mult = mult * T61_MAGIC_AND_PURE_REDUCTION_PERCENT/100;
                end
            end
        end
        return mult
    end
}
return module