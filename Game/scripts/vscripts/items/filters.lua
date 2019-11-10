if Filters == nil then
    Filters = class({})
end

require('/heroes/antimage/arkimus_constants')
local heroes = {
    venomort = require('/heroes/hero_necrolyte/scales')}

require('/heroes/dark_seer/zhonik_constants')
require('/heroes/huskar/spirit_warrior_constants')
require('items/special_item_effects')
require('/heroes/omniknight/paladin_constants')
require('/heroes/phantom_assassin/voltex_constants')
require('/heroes/juggernaut/seinaru_constants')
require('/heroes/lanaya/trapper_constants')
require('/heroes/leshrac/bahamut_constants')
require('/heroes/obsidian_destroyer/epoch_constants')
require('/heroes/spirit_breaker/duskbringer_constants')
require('/heroes/zuus/auriun_constants')
require('/heroes/legion_commander/mountain_protector_constants')
require('/heroes/faceless_void/omniro_constants')
require('/heroes/skywrath_mage/sephyr_constants')
require('heroes/slardar/hydroxis_constants')
require('/heroes/vengeful_spirit/solunia_constants')
require("/heroes/visage/ekkan_constants")
require("/heroes/winter_wyvern/dinath_constants")
require("/heroes/axe/red_general_constants")

require('/items/constants/boots')
require('/items/constants/chest')
require('/items/constants/gloves')
require('/items/constants/helm')
require('/items/constants/trinket')

LinkLuaModifier("modifier_buzuki_finger_lua", "modifiers/modifier_buzuki_finger_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pivotal_swift", "modifiers/modifier_pivotal_swift", LUA_MODIFIER_MOTION_NONE)


function Filters:ApplyItemDamage(victim, attacker, damage, damage_type, item, element1, element2)
    local damageData = attacker._damage_data or {}

    damage = Filters:AdjustItemDamage(attacker, damage, victim)

    if damageData.skipItemDamageEffectsApply then
        Filters:TakeArgumentsAndApplyDamage(victim, attacker, damage, damage_type, BASE_ITEM, element1, element2, false, item)
        return
    end
    local mult = 1
    if attacker:HasModifier('modifier_duskbringer_glyph_7_2') then
        element2 = RPC_ELEMENT_GHOST
    end
    if victim:HasModifier("modifier_item_resistance") then
        if victim.itemReduc then
            damage = damage * victim.itemReduc
        end
    end
    -- if attacker:HasModifier("modifier_solunia_arcana2") then
    --     local b_d_level = attacker:GetRuneValue("r", 2)
    --     if b_d_level > 0 then
    --         local modified_damage = Filters:ElementalDamage(victim, attacker, damage, damage_type, nil, element1, element2, true)
    --         if attacker.sunMoon == "moon" then
    --             victim.SoluniaBurnLunar = modified_damage * 0.01 * b_d_level
    --             local alphaAbility = attacker:FindAbilityByName("solunia_lunar_alpha_spark")
    --             alphaAbility:ApplyDataDrivenModifier(attacker, victim, "modifier_solunia_lunar_burn", {duration = 8})
    --         else
    --             victim.SoluniaBurnSolar = modified_damage * 0.01 * b_d_level
    --             local alphaAbility = attacker:FindAbilityByName("solunia_solar_alpha_spark")
    --             alphaAbility:ApplyDataDrivenModifier(attacker, victim, "modifier_solunia_solar_burn", {duration = 8})
    --         end
    --     end
    -- end
    damage = damage * mult

    Filters:TakeArgumentsAndApplyDamage(victim, attacker, damage, damage_type, BASE_ITEM, element1, element2, false, item)
end

function Filters:ApplyItemDamageBasedOnAbility(victim, attacker, damage, damage_type, item, element1, element2)
    local damageData = attacker._damage_data or {}

    if attacker:HasModifier("modifier_depth_demon_claw") then
        damage = damage * DEPTH_DEMON_CLAW_AUGMENT_REDUCTION
    end
    if damageData.skipItemDamageEffectsApply then
        Filters:TakeArgumentsAndApplyDamage(victim, attacker, damage, damage_type, BASE_ITEM, element1, element2)
        return
    end
    if attacker:HasModifier("modifier_solunia_arcana2") then
        local b_d_level = attacker:GetRuneValue("r", 2)
        if b_d_level > 0 then
            local modified_damage = Filters:ElementalDamage(victim, attacker, damage, damage_type, nil, element1, element2, true)
            if attacker.sunMoon == "moon" then
                victim.SoluniaBurnLunar = modified_damage * SOLUNIA_ARCANA_R2_BURN_PCT/100 * b_d_level
                local alphaAbility = attacker:FindAbilityByName("solunia_lunar_alpha_spark")
                alphaAbility:ApplyDataDrivenModifier(attacker, victim, "modifier_solunia_lunar_burn", {duration = 8})
            else
                victim.SoluniaBurnSolar = modified_damage * SOLUNIA_ARCANA_R2_BURN_PCT/100 * b_d_level
                local alphaAbility = attacker:FindAbilityByName("solunia_solar_alpha_spark")
                alphaAbility:ApplyDataDrivenModifier(attacker, victim, "modifier_solunia_solar_burn", {duration = 8})
            end
        end
    end
    Filters:TakeArgumentsAndApplyDamage(victim, attacker, damage, damage_type, BASE_ITEM, element1, element2)
end

function Filters:GetUnpurgableDebuffNames()
    local unpurgable = {"modifier_shipyard_boss_aura_effect", "modifier_hero_candy_crush", "modifier_attack_land_basic"}
    return unpurgable
end

function Filters:GetUnpurgableBuffNames()
    local unpurgable = {"modifier_ascencion_cooldown",
        "modifier_duskbringer_ghost_form_active",
    "modifier_comet_jumping"}
    return unpurgable
end

function Filters:CleanseStuns(unit)
    unit:RemoveModifierByName("modifier_stunned")
    unit:RemoveModifierByName("modifier_knockback")
    unit:RemoveModifierByName("modifier_nyx_assassin_impale")
    unit:RemoveModifierByName("modifier_lina_light_strike_array")
    unit:RemoveModifierByName("modifier_lion_impale")
    unit:RemoveModifierByName("modifier_earthshaker_fissure_stun")
    unit:RemoveModifierByName("modifier_tidehunter_ravage")
    unit:RemoveModifierByName("modifier_lightning_stun")
end

function Filters:CleanseSilences(unit)
    unit:RemoveModifierByName("modifier_blackguard_cripple")
    unit:RemoveModifierByName("modifier_challenger_bolt_blue_debuff")
    unit:RemoveModifierByName("modifier_shield_silence")
    unit:RemoveModifierByName("modifier_silence")
    unit:RemoveModifierByName("modifier_kaze_gust_blind")
end

function Filters:AdjustItemDamage(caster, damage, victim)
    -- if GameState:GetDifficultyFactor() == 2 then
    --     damage = damage*3
    -- elseif GameState:GetDifficultyFactor() == 3 then
    --     damage = damage*10
    -- end

    local casterName = caster:GetUnitName()
    local mult = 1
    if caster:HasModifier("modifier_ancient_waterstone") then
        mult = mult + ANCIENT_TANARI_WATERSTONE_ITEM_DAMAGE_AMP/100
    end
    if caster:HasModifier("modifier_neutral_glyph_2_1") then
        mult = mult + 2
    end
    if caster:HasModifier("modifier_auriun_glyph_2_1") then
        mult = mult + AURIUN_GLYPH_2_1_ITEM_DAMAGE/100
    end
    if caster:HasModifier("modifier_excavators_focus_cap") then
        mult = mult + EXCAVATOR_ITEM_AMP_PER_INT/100 * (caster:GetIntellect() / EXCAVATOR_INT_DIVISOR)
    end
    if caster:HasModifier("modifier_gem_of_eternal_frost") then
        mult = mult + ETERNAL_FROST_INT_TO_ITEM_DMG/100 * (caster:GetIntellect() / ETERNAL_FROST_INT_DIVISOR)
    end
    if caster:HasModifier("modifier_mountain_vambraces") then
        mult = mult + MOUNTAIN_VAMBRACES_ITEM_AMP_PER_STR/100 * (caster:GetStrength() / MOUNTAIN_VAMBRACES_STR_DIVISOR)
    end
    if caster:HasModifier("modifier_body_avalanche") then
        mult = mult + AVALANCHE_PLATE_ITEM_AMP_PER_STR/100 * (caster:GetStrength() / AVALANCHE_PLATE_STR_DIVISOR)
    end

    if caster:HasModifier("modifier_autumnrock_bracer") then
        mult = mult + AUTUMNROCK_BRACER_ITEM_DAMAGE_AMP_PER_HP_PCT/100 * (caster:GetHealth() / AUTUMNROCK_BRACER_ITEM_DAMAGE_HP_DIVISOR)
    end
    if caster:HasModifier("modifier_depth_crest_armor") then
        if victim and victim:IsStunned() then
            mult = mult + DEPTH_CREST_ARMOR_ITEM_AMP/100 * (caster:GetStrength() / DEPTH_CREST_ARMOR_STR_DIVISOR)
        end
    end
    if caster:HasModifier("modifier_hyper_visor") then
        mult = mult + HYPER_VISOR_AGI_TO_ITEM_AMP/100 * (caster:GetAgility() / HYPER_VISOR_AGI_DIVISOR)
    end
    if caster:HasModifier("modifier_rpc_steamboots") then
        mult = mult + STEAMBOOTS_AGI_TO_ITEM_DAMAGE/100 * (caster:GetAgility() / STEAMBOOTS_AGI_DIVISOR)
    end
    if caster:HasModifier("modifier_red_divinex_amulet") then
        mult = mult + RED_DIVINEX_STR_TO_ITEM_DMG/100 * (caster:GetStrength() / RED_DIVINEX_STR_DIVISOR)
    end
    if caster:HasModifier("modifier_green_divinex_amulet") then
        mult = mult + GREEN_DIVINEX_STR_TO_ITEM_DMG/100 * (caster:GetAgility() / GREEN_DIVINEX_AGI_DIVISOR)
    end
    if caster:HasModifier("modifier_blue_divinex_amulet") then
        mult = mult + BLUE_DIVINEX_STR_TO_ITEM_DMG/100 * (caster:GetIntellect() / BLUE_DIVINEX_INT_DIVISOR)
    end

    if caster:HasModifier("modifier_raven_idol") then
        local multIncrease = (1 - caster:GetHealth() / caster:GetMaxHealth()) * RAVEN_IDOL_ITEM_DMG_PCT_PER_MISSING_HP_PCT
        mult = mult + multIncrease
    end
    if caster:HasModifier("modifier_chernobog_immortal_weapon_2") then
		local missingHealthPercent = math.floor((1 - (caster:GetHealth() / caster:GetMaxHealth())) * 100)
		mult = mult + missingHealthPercent * CHERNOBOG_IMMORTAL_WEP2_BAD_AND_ITEM_PCT_PER_MISSING_HP_PCT / 100
	end

    if caster:IsHero() then
        mult = mult + 0.01 * (CustomAttributes:AddStatsBonusFromStacks(caster, nil, "modifier_head_item_damage", 1) + CustomAttributes:AddStatsBonusFromStacks(caster, nil, "modifier_weapon_item_damage", 1) + CustomAttributes:AddStatsBonusFromStacks(caster, nil, "modifier_hands_item_damage", 1) + CustomAttributes:AddStatsBonusFromStacks(caster, nil, "modifier_feet_item_damage", 1) + CustomAttributes:AddStatsBonusFromStacks(caster, nil, "modifier_body_item_damage", 1) + CustomAttributes:AddStatsBonusFromStacks(caster, nil, "modifier_amulet_item_damage", 1))
    end

    if casterName == "npc_dota_hero_spirit_breaker" and caster:HasAbility("whirling_flail") then
        local q_2_level = caster:GetRuneValue("q", 2)
        mult = mult + DUSKBRINGER_Q2_ITEM_PCT * q_2_level
    end
    if casterName == "npc_dota_hero_monkey_king" then
        if caster:HasModifier("modifier_bear_c_d") then
            local r_3_level = caster:GetRuneValue("r", 3)
            mult = mult + DJANGHOR_R3_BEAR_ITEM_DAMAGE_PCT/100 * r_3_level
        end
    end
    if caster:HasModifier("modifier_hood_of_the_black_mage") then
        damage = damage * (100-BLACK_MAGE_ITEM_DAMAGE_PENALTY)/100
    end
    damage = damage * mult
    return damage
end

function Filters:GetAdjustedRange(caster, baseRange)
    if caster:HasModifier("modifier_hood_of_lords_lua") then
        baseRange = baseRange + HOOD_OF_LORDS_BONUS_RANGE
    end
    if caster:HasModifier("modifier_vermillion_dream_lua") then
        baseRange = baseRange + VERMILLION_DREAM_CAST_RANGE_INCREASE
    end
    return baseRange
end

function Filters:GetAdjustedBuffDuration(caster, baseDuration, bItem)
    if caster:GetUnitName() == "npc_dota_hero_zuus" then
        local c_d_level = Runes:GetTotalRuneLevel(caster, 3, "r_3", "auriun")
        baseDuration = baseDuration + c_d_level * AURIUN_R3_BUFF_DUR_INCREASE
    end
    if caster:HasModifier("modifier_arbor_dragonfly") then
        baseDuration = baseDuration * (100+ARBOR_DRAGONFLY_BUFF_INCREASE_PCT)/100
    end
    return baseDuration
end

function Filters:GetBaseHealthRegen(target, caster)
    -- local rootedStacks = target:GetModifierStackCount("modifier_rooted_feet_regen_portion", caster)
    -- local silverspringStacks = target:GetModifierStackCount(string modifierName, handle hCaster)
end

function Filters:GetDelayWithCastSpeed(caster, delay)
    if caster:HasModifier("modifier_spellfire_gloves") then
        delay = delay * (1-SPELLFIRE_CAST_POINT_REDUCTION)
    end
    return delay
end

function Filters:RemoveStuns(unit)
    unit:RemoveModifierByName("modifier_stunned")
    unit:RemoveModifierByName("modifier_knockback")
    unit:RemoveModifierByName("modifier_nyx_assassin_impale")
    unit:RemoveModifierByName("modifier_lina_light_strike_array")
    unit:RemoveModifierByName("modifier_lion_impale")
end

function Filters:GetProc(caster, percentageChance)
    local luck = RandomInt(1, 100)
    if caster:HasModifier("modifier_boots_of_great_fortune") then
        percentageChance = percentageChance + BOOTS_OF_GREAT_FORTUNE_CHANCE_INCREASE
    end
    if caster:HasModifier("modifier_fortunes_talisman_of_truth") then
        percentageChance = math.ceil(percentageChance * (100+FORTUNES_TALISMAN_CHANCE_AMP)/100)
    end
    if caster:HasModifier("modifier_astral_rune_r_4_invisible") then
        local chanceModifier = 1 + 0.01 * caster:GetModifierStackCount("modifier_astral_rune_r_4_invisible", Events.GameMaster)
        percentageChance = math.ceil(percentageChance * chanceModifier)
    end

    if luck <= percentageChance then
        return true
    else
        return false
    end
end

function Filters:PerformAttackSpecial(caster, target, b1, b2, b3, b4, b5, b6, b7)
    local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
    if not caster:HasModifier("modifier_perform_attack_limiter") then
        gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, caster, "modifier_perform_attack_limiter", {duration = 1})
    end
    local currentStacks = caster:GetModifierStackCount("modifier_perform_attack_limiter", Events.GameMaster)
    if currentStacks < 20 then
        if not target:IsAttackImmune() then
            caster:PerformAttack(target, b1, b2, b3, b4, b5, b6, b7)
            caster:SetModifierStackCount("modifier_perform_attack_limiter", Events.GameMaster, currentStacks + 1)
        end
    else

    end
end

function Filters:GetAdjustedESpeed(caster, speed, bDelay)
    if caster:HasModifier("modifier_pegasus_boots") then
        if bDelay then
            speed = speed*0.5
        else
            speed = speed + speed*(PEGASUS_E_SPEED_PCT/100)
        end
    end
    return speed
end

function Filters:GetAdjustedMaxMovespeed(max_ms, caster)
    if caster:HasModifier("modifier_pegasus_boots") then
        max_ms = max_ms + (max_ms-550)*(PEGASUS_MAX_MS_AMP_PCT/100)
    end
    return max_ms
end

function Filters:GetMagicImmuneModifierNames()
    local magic_immunity_buffs = {"modifier_hope_of_saytaru_effect", "modifier_seinaru_gorudo_magic_immunity", "modifier_black_widow", "modifier_warlord_stone_form", "modifier_gilded_soul_immunity", "modifier_auriun_immortal_weapon_3_effect", "modifier_black_King_bar_immunity", "modifier_jex_magic_immunity", "modifier_magic_immune_breakable_ability", "modifier_auric_ring_bkb"}
    return magic_immunity_buffs
end

function Filters:MagicImmuneBreak(attacker, target)
    local magic_immunity_buffs = Filters:GetMagicImmuneModifierNames()
    local immuneBreak = false
    for i = 1, #magic_immunity_buffs, 1 do
        if target:HasModifier(magic_immunity_buffs[i]) then
            immuneBreak = true
        end
    end
    if immuneBreak then
        for i = 1, #magic_immunity_buffs, 1 do
            target:RemoveModifierByName(magic_immunity_buffs[i])
        end
        EmitSoundOn("RPC.MagicImmuneBreakAttacker", attacker)
        EmitSoundOn("RPC.MagicImmuneBreakTarget", target)
        local pfx = ParticleManager:CreateParticle("particles/econ/events/ti5/dagon_lvl2_ti5.vpcf", PATTACH_POINT_FOLLOW, attacker)
        ParticleManager:SetParticleControlEnt(pfx, 0, attacker, PATTACH_POINT, "attach_hitloc", attacker:GetAbsOrigin() + Vector(0, 0, 80), true)
        ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin() + Vector(0, 0, 80), true)
        Timers:CreateTimer(2.0, function()
            ParticleManager:DestroyParticle(pfx, false)
        end)
        CustomAbilities:QuickAttachParticle("particles/roshpit/magic_immune_break_basher_cast.vpcf", target, 3)
    end
end

function Filters:SetAttackDamage(unit, damage)
    damage = math.min(damage, (2 ^ 28) - 10)
    unit:SetBaseDamageMin(damage)
    unit:SetBaseDamageMax(damage)
end

function Filters:AbilityKills(attacker, victim, ability)

end

function Filters:ReduceCooldownAll(caster, ability, baseCD)
    local abilityCooldown = baseCD
    local CDreduce = 0
    -- if caster:HasModifier("modifier_hood_of_lords_lua") then
    --     CDreduce = CDreduce + 1
    -- end
    local abilityCooldown = abilityCooldown - CDreduce
    if abilityCooldown > 0 then
        ability:EndCooldown()
        ability:StartCooldown(abilityCooldown)
    else
        ability:EndCooldown()
    end
end

function Filters:ReduceCooldownGeneric(caster, ability, CDreduce)
    local abilityCooldown = ability:GetCooldownTimeRemaining()
    if caster:HasModifier("modifier_hood_of_lords_lua") then
        abilityCooldown = abilityCooldown + HOOD_OF_LORDS_CD_RED
    end
    local abilityCooldown = abilityCooldown - CDreduce
    if abilityCooldown > 0 then
        ability:EndCooldown()
        ability:StartCooldown(abilityCooldown)
    else
        ability:EndCooldown()
    end
end

function Filters:ReduceECooldown(caster, ability, baseCD, bIncludeFlatCD)
    local abilityCooldown = baseCD
    local CDreduce = 0

    if caster:HasModifier("modifier_sandstream_slippers_stack") then
        if baseCD > 0 then
            local currentStack = caster:GetModifierStackCount("modifier_sandstream_slippers_stack", caster.InventoryUnit)
            if currentStack > 1 then
                caster:SetModifierStackCount("modifier_sandstream_slippers_stack", caster.InventoryUnit, currentStack - 1)
            else
                caster:RemoveModifierByName("modifier_sandstream_slippers_stack")
            end
            ability:EndCooldown()
            return
        end
    end
    if caster:HasModifier("modifier_dunetread_boots") then
        CDreduce = CDreduce + DUNETREADS_CD_RED
    end
    if caster:HasModifier("modifier_neutral_glyph_3_3") then
        CDreduce = CDreduce + 1
    end
    if caster:HasModifier('modifier_venomort_glyph_3_1') then
        CDreduce = CDreduce + VENOMORT_GLYPH_3_1_E_CD_RED
    end
    if caster:HasModifier("modifier_bear_silencer") then
        CDreduce = CDreduce - 30
    end
    if bIncludeFlatCD then
        -- if caster:HasModifier("modifier_hood_of_lords_lua") then
        --     CDreduce = CDreduce + 1
        -- end
    end
    if caster:HasModifier("modifier_signus_charm") then
        CDreduce = CDreduce - baseCD
    end
    if caster:HasModifier("modifier_hood_of_lords_lua") then
        CDreduce = CDreduce - HOOD_OF_LORDS_CD_RED
    end
    local abilityCooldown = abilityCooldown - CDreduce

    if caster:HasModifier("modifier_mask_of_ahnqhir_blue") then
        abilityCooldown = abilityCooldown * (100-TWISTED_MASK_OF_AHNQHIR_BLUE_CD_RED_PCT)/100
    end
    if caster:HasModifier("modifier_bloodstone_boots") then
        if caster:GetHealth() <= caster:GetMaxHealth() * BLOODSTONE_BOOTS_HP_TRESHOLD_PCT / 100 then
            abilityCooldown = BLOODSTONE_BOOTS_E_CD
        end
    end
    if abilityCooldown < 0.1 then
        abilityCooldown = 0.1
    end
    --Hood of Lords reduces CD after all the lua code. Its internal by Dota 2
    if abilityCooldown < 1.1 and caster:HasModifier("modifier_hood_of_lords_lua") then
        abilityCooldown = 1.1
    end

    ability:EndCooldown()
    ability:StartCooldown(abilityCooldown)
end

function Filters:GetCDNoHood(caster, cd)
    if cd < 1.5 then
        if caster:HasModifier("modifier_hood_of_lords_lua") then
            cd = cd + HOOD_OF_LORDS_CD_RED
        end
    end
    return cd
end

function Filters:GetRawBaseStat(statName, caster)
    local attribute = 0
    if statName == "strength" then
        attribute = caster:GetStrength()
        if caster:HasModifier("modifier_legion_vestments_effect_str") then
            local legionStacks = caster:GetModifierStackCount("modifier_legion_vestments_effect_str", caster.InventoryUnit)
            attribute = attribute - legionStacks
        end
    elseif statName == "agility" then
        attribute = caster:GetAgility()
        if caster:HasModifier("modifier_legion_vestments_effect_agi") then
            local legionStacks = caster:GetModifierStackCount("modifier_legion_vestments_effect_agi", caster.InventoryUnit)
            attribute = attribute - legionStacks
        end
    elseif statName == "intellect" then
        attribute = caster:GetIntellect()
        if caster:HasModifier("modifier_legion_vestments_effect_int") then
            local legionStacks = caster:GetModifierStackCount("modifier_legion_vestments_effect_int", caster.InventoryUnit)
            attribute = attribute - legionStacks
        end
    end
    return attribute
end

function Filters:GetHeroAttribute(hero, attributeName)
    local attribute = 0
    if attributeName == "agility" then
        attribute = hero:GetAgility()
    elseif attributeName == "strength" then
        attribute = hero:GetStrength()
    elseif attributeName == "intellect" then
        attribute = hero:GetIntellect()
    end
    return attribute
end

function Filters:AdjustBuffDuration(isBuff, duration)
    return duration
end

function Filters:ApplyStun(caster, duration, target)
    local mult = 1
    if caster:HasModifier("modifier_knight_crusher_armor") then
        mult = mult + STAGGERING_KNIGHT_CRUSHER_STUN_DURATION_INCREASE/100
    end

    if target:IsHero() then
        mult = mult * (100-STAGGERING_KNIGHT_CRUSHER_STUN_IMMUNITY_COUNTER_DECREASE)/100
    end
    if caster:HasModifier("modifier_steelforge_passive") then
        caster.w_2_level = caster:GetRuneValue("w", 2)
    end
    if caster:HasModifier("modifier_stormcrack_helm2") then
        if caster:GetTeamNumber() == target:GetTeamNumber() then
        else
            if not caster.headItem.stormCrackParticles then
                caster.headItem.stormCrackParticles = 0
            end
            if caster.headItem.stormCrackParticles < 9 then
                caster.headItem.stormCrackParticles = caster.headItem.stormCrackParticles + 1
                -- CustomAbilities:QuickAttachParticle("particles/econ/items/sven/sven_cyclopean_marauder/sven_cyclopean_warcry.vpcf", target, 1.2)
                CustomAbilities:QuickAttachParticle("particles/econ/items/sven/sven_warcry_ti5/sven_warcry_cast_arc_lightning.vpcf", target, 1.2)
                Timers:CreateTimer(1.5, function()
                    caster.headItem.stormCrackParticles = caster.headItem.stormCrackParticles - 1
                end)
            end

            local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * STORMCRACK_ATTACK_DAMAGE_MULT * 2 + (caster:GetStrength() + caster:GetAgility() + caster:GetIntellect()) * STORMCRACK_ATTR_DAMAGE_MULT * 2
            Filters:ApplyItemDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, caster.headItem, RPC_ELEMENT_NORMAL, RPC_ELEMENT_LIGHTNING)
            mult = mult + STORMCRACK_STUN_DURATION_AMP/100
        end
    end

    duration = duration * mult
    Events.GameMasterAbility:ApplyDataDrivenModifier(caster, target, "modifier_fake_stunned", {duration = duration})
    if target:ShouldHaveStunResistance() then
        local currentResistanceStacks = target:GetModifierStackCount("modifier_stun_resistance", Events.GameMaster)
        local resistThresh = 70
        if target.mainBoss then
            resistThresh = 40
        end
        if currentResistanceStacks <= resistThresh then
            Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, target, "modifier_stun_resistance", {duration = 7 + duration})
            local resistDivisor = 1
            if caster:HasModifier("modifier_knight_crusher_armor") or caster:HasModifier("modifier_sorceress_glyph_5_2") then
                resistDivisor = resistDivisor * (1 - SORCERESS_GLYPH_5_2_STUN_IMMUNITY_COUNTER_REDUCTION)
            end
            local newResistanceStacks = currentResistanceStacks + math.ceil((duration * 10) / resistDivisor)
            target:SetModifierStackCount("modifier_stun_resistance", Events.GameMaster, newResistanceStacks)
        else
            duration = 0
        end
    end
    if target:HasModifier("modifier_stun_immune") or target:HasModifier("modifier_recently_respawned") then
        duration = 0
    end
    if caster:HasModifier("modifier_mountain_protector_glyph_1_1") then
        local glyph_ability = caster:FindModifierByName("modifier_mountain_protector_glyph_1_1"):GetAbility()
        glyph_ability:ApplyDataDrivenModifier(caster, target, "modifier_mountain_protector_glyph_1_1_cant_heal", {duration = duration})
    end
    if caster:HasModifier("modifier_steelforge_passive") then
        local ability = caster:FindModifierByName("modifier_steelforge_passive"):GetAbility()
        ability:ApplyDataDrivenModifier(caster, target, "modifier_mountain_protector_arcana1_w_2_slow", {duration = duration*MOUNTAIN_PROTECTOR_ARCANA1_W2_DURATION_MULT})
    end
    if duration > 0 then
        target:AddNewModifier(caster, nil, "modifier_stunned", {duration = duration})
    end
end

function Filters:ApplyHeal(caster, target, healAmount, bCap, doPopUp)
    if caster:GetUnitName() == "npc_dota_hero_zuus" then
        local w_2_level = caster:GetRuneValue("w", 2)
        if w_2_level > 0 then
            healAmount = healAmount + healAmount * AURIUN_W2_HEALING_AMP * w_2_level
            healAmount = OverflowProtectedMaxHealingValue(healAmount)
        end
    end

    healAmount = OverflowProtectedMaxHealingValue(healAmount)
    if bCap then
        healAmount = math.min(healAmount, target:GetMaxHealth())
    end
    healAmount = math.floor(healAmount)
    target:Heal(healAmount, caster)
    if doPopUp then
        PopupHealing(target, healAmount)
    end

    if target:HasModifier("modifier_pirate_aura_debuff") then
        local modifiers = target:FindAllModifiersByName("modifier_pirate_aura_debuff")
        for _, modifier in pairs(modifiers) do
            local pirateCaster = modifier:GetCaster()
            local finalValue = OverflowProtectedMaxHealingValue(healAmount * 100)
            Filters:ApplyHeal(pirateCaster, pirateCaster, finalValue, true)
        end
    end
    if caster:GetUnitName() == "npc_dota_hero_omniknight" then
        if caster:HasAbility("heroic_fury") then
            local ability = caster:FindAbilityByName("heroic_fury")
            local q_4_level = caster:GetRuneValue("q", 4)
            if q_4_level > 0 then
                local origHeal = healAmount
                local actualHeal = math.min(target:GetMaxHealth() - target:GetHealth(), origHeal)
                local shieldAmount = origHeal - actualHeal
                if shieldAmount < 0 then
                    return
                end
                if not target.paladin_q4_absorb then
                    target.paladin_q4_absorb = 0
                end
                if target.paladin_q4_absorb < 0 then
                    target.paladin_q4_absorb = 0
                end
                target.paladin_q4_absorb = math.min(target.paladin_q4_absorb + shieldAmount, target:GetMaxHealth() * 0.1 * q_4_level)
                local shieldDuration = Filters:GetAdjustedBuffDuration(caster, 12, false)
                target:AddNewModifier(caster, ability, "modifier_paladin_q4_shield", {duration = shieldDuration})
            end
        end
    end
    if caster:HasModifier("modifier_white_mage_hat2") then
        local overheal = healAmount - (target:GetMaxHealth() - target:GetHealth())
        if overheal > 0 then
            if not target.whiteMageShield then
                target.whiteMageShield = 0
            end
            if not target:HasModifier("modifier_white_mage_shield") then
                target.whiteMageShield = 0
            end
            local shieldValue = math.min(target.whiteMageShield + overheal, target:GetMaxHealth())
            if shieldValue < 0 then
                return
            end
            target.whiteMageShield = shieldValue
            caster.headItem:ApplyDataDrivenModifier(caster.InventoryUnit, target, "modifier_white_mage_shield", {duration = WHITE_MAGE_SHIELD_DURATION})
        end
    end
end

function Filters:ApplyDotDamage(caster, ability, target, damage, damage_type, slot, element1, element2)
    heroes.venomort.onDotDamageDo(caster, target)
    local mult = 1
    if caster:HasModifier("modifier_glove_of_the_forgotten_ghost") then
        mult = mult + FORGOTTEN_GHOST_DOT_MULT
    end
    mult = mult + heroes.venomort.getDotAmplify(caster, target)
    damage = damage * mult
    local damage_types = {damage_type}
    if caster:HasModifier('modifier_venomort_glyph_5_a') then
        damage_types = {
            DAMAGE_TYPE_PURE,
            DAMAGE_TYPE_PHYSICAL,
            DAMAGE_TYPE_MAGICAL,
        }
        damage = damage / 3
    end

    for index, dot_damage_type in ipairs(damage_types) do
        if slot == BASE_NONE then
            Filters:ApplyItemDamage(target, caster, damage, dot_damage_type, ability, element1, element2)
        elseif slot == BASE_ITEM then
            ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = dot_damage_type, damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR})
        elseif slot == -2 then
            Filters:TakeArgumentsAndApplyDamage(target, caster, damage, dot_damage_type, -2, element1, element2)
        else
            Filters:TakeArgumentsAndApplyDamage(target, caster, damage, dot_damage_type, slot, element1, element2)
        end
    end
end

function Filters:CastSkillArguments(slot, caster)
    if caster:GetUnitName() == "npc_dota_hero_beastmaster" then
        caster.e_4_level = Runes:GetTotalRuneLevel(caster, 4, "e_4", "warlord")
    end
    if caster:GetUnitName() == "npc_dota_hero_legion_commander" then
        caster.r_4_level = caster:GetRuneValue("r", 4)
    end
    if slot == BASE_ABILITY_Q then
        Filters:ApplyQskills(caster)
        Util.Modifier:SimpleEvent(caster, 'OnCastQAbility', { MODIFIER_SPECIAL_TYPE_CAST_Q_ABILITY }, {}, nil)
    elseif slot == BASE_ABILITY_W then
        Filters:ApplyWskills(caster)
        Util.Modifier:SimpleEvent(caster, 'OnCastWAbility', { MODIFIER_SPECIAL_TYPE_CAST_W_ABILITY }, {}, nil)
    elseif slot == BASE_ABILITY_E then
        Filters:ApplyEskills(caster)
        Util.Modifier:SimpleEvent(caster, 'OnCastEAbility', { MODIFIER_SPECIAL_TYPE_CAST_E_ABILITY }, {}, nil)
    elseif slot == BASE_ABILITY_R then
        Filters:ApplyRskills(caster)
        Util.Modifier:SimpleEvent(caster, 'OnCastRAbility', { MODIFIER_SPECIAL_TYPE_CAST_R_ABILITY }, {}, nil)

    end
    if caster:HasModifier("modifier_beryl_ring_of_intuiton") or caster:HasModifier("modifier_auric_ring_of_inspiration") then
        Filters:InpsirationRing(caster, slot)
    end
    Events:TutorialServerEvent(caster, "2_1", 1)
    Challenges:AbilityUsed(slot)
    if caster:HasModifier("modifier_bladestorm_vest_buff") then
        local bladestormStacks = caster:GetModifierStackCount("modifier_bladestorm_vest_buff", caster.body)
        local newStacks = math.max(bladestormStacks - 1, 0)
        caster:SetModifierStackCount("modifier_bladestorm_vest_buff", caster.body, newStacks)
        Filters:ModifyBladestormVestSwordCount(caster, newStacks, caster.body, caster.InventoryUnit)
    end
    if caster:HasModifier("modifier_mordiggus_gauntlet") then
        local beginningHealth = caster:GetHealth()
        if beginningHealth > caster:GetMaxHealth() * MORDIGGUS_GAUNTLET_MIN_HP_PCT / 100 then
            local newHealth = math.max(caster:GetHealth() - caster:GetMaxHealth() * MORDIGGUS_GAUNTLET_HP_DRAIN_PCT_ON_SPELL / 100, caster:GetMaxHealth() * MORDIGGUS_GAUNTLET_MIN_HP_PCT / 100)
            caster:SetHealth(newHealth)
            CustomAbilities:QuickAttachParticle("particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodbath_eztzhok_ember.vpcf", caster, 0.7)
            if caster:HasModifier("modifier_wraith_hunters_steel_helm") then
                local damageTaken = math.max(beginningHealth - newHealth, 1)
                local eventTable = {}
                eventTable.unit = caster
                eventTable.attack_damage = damageTaken
                eventTable.ability = caster.headItem
                wraith_hunter_take_damage(eventTable)
            end
        end
    end
    if caster:HasModifier("modifier_spiritual_empowerment_stack") then
        local newStack = caster:GetModifierStackCount("modifier_spiritual_empowerment_stack", caster.InventoryUnit) - 1
        if newStack == 0 then
            caster:RemoveModifierByName("modifier_spiritual_empowerment_stack")
        else
            caster:SetModifierStackCount("modifier_spiritual_empowerment_stack", caster.InventoryUnit, newStack)
        end
    end
    if caster:HasModifier("modifier_crimsyth_elite_greaves") then
        caster:RemoveModifierByName("modifier_crimsyth_elite_greaves_armor")
        caster.foot:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_crimsyth_elite_greaves_magic_shield", {duration = CRIMSYTH_ELITE_DURATION})
    end
    if caster:HasModifier("modifier_grasp_of_elder") then
        local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, ELDER_GRASP_RADIUS, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false)
        for _, ally in pairs(allies) do
            local healAmount = ally:GetMaxHealth() * ELDER_GRASP_HEAL_PCT
            local shieldAmount = math.max(healAmount + ally:GetHealth() - ally:GetMaxHealth(), 0)
            CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_oracle/white_mage_healheal.vpcf", ally, 3)
            Filters:ApplyHeal(caster, ally, healAmount)
            if shieldAmount > 0 then
                caster.handItem:ApplyDataDrivenModifier(caster, ally, "modifier_grasp_of_elder_shield", {})
                if not ally.elder_grasp_shield then
                    ally.elder_grasp_shield = 0
                end
                ally.elder_grasp_shield = math.min(ally.elder_grasp_shield + shieldAmount, ELDER_GRASP_SHIELD_PER_HP * ally:GetMaxHealth())
                ally.elder_grasp_max_shield = ally.elder_grasp_shield
            end
        end
    end
    if caster:HasModifier("modifier_chains_of_orthok") then
        if slot == BASE_ABILITY_Q then
            Filters:OrthokStack(caster, ORTHOK_Q_E_CAST_STACKS)
        elseif slot == BASE_ABILITY_W then
            Filters:OrthokStack(caster, ORTHOK_W_CAST_STACKS)
        elseif slot == BASE_ABILITY_E then
            Filters:OrthokStack(caster, ORTHOK_Q_E_CAST_STACKS)
        elseif slot == BASE_ABILITY_R then
            Filters:OrthokStack(caster, ORTHOK_R_CAST_STACKS)
        end
    end
    if caster:HasModifier("modifier_jex_nature_cosmic_w") then
        Filters:JexNatureCostmicW(caster)
    end
    if caster:HasModifier("modifier_mugato") then
        caster:AddNewModifier(caster, nil, "modifier_silence", {duration = MUGATO_SPELL_SILENCE_DUR})
    end
end

function Filters:BeginRChannel(caster)
    local ability = caster:GetAbilityByIndex(DOTA_R_SLOT)
    if not ability then
        return false
    end
    local baseCd = ability:GetCooldownTimeRemaining()
    if caster:HasModifier("modifier_iron_treads_of_destruction") then
        ability:OnChannelFinish(false)
        Timers:CreateTimer(0.03, function()
            ability:EndChannel(true)
            Filters:EndRChannel(caster)
        end)
    end
    if caster:HasModifier("modifier_galaxy_orb") then
        caster.galaxy_orb:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_galaxy_orb_channel", {duration = 8.0})
    end
    if caster:HasModifier("modifier_water_mage_robes") then
        caster.body:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_water_mage_channeling", {duration = 8.0})
    end
    if caster:HasModifier("modifier_ocean_tempest_pallium") then
        caster.ocean_tempest:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_ocean_tempest_pallium_channeling", {duration = 8.0})
    end
    if caster:HasModifier("modifier_space_tech") then
        caster:RemoveModifierByName("modifier_space_tech_buff")
        caster.space_tech:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_space_tech_channel", {duration = SPACE_TECH_DURATION})
    end
    if caster:HasModifier("modifier_druid_spirit_helm") then
        caster.druid_spirit:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_druid_channel", {duration = 8.0})
    end
    if caster:HasModifier("modifier_brazen_kabuto") then
        caster:RemoveModifierByName('modifier_brazen_kabuto_shield')
        caster.kabuto:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_brazen_kabuto_channeling", {duration = 8.0})
    end
    if caster:HasModifier("modifier_signus_charm") then
        ability:EndCooldown()
        baseCd = baseCd * (100-SIGNUS_R_CD_REDUCTION)/100
        ability:StartCooldown(baseCd)
    end
    if caster:HasModifier("modifier_burning_spirit_helmet") then
        StartSoundEvent("RPCItem.BurningSpiritHelm", caster)
        caster.headItem:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_burning_spirit_helmet_flamethrower", {duration = 8.0})
    end
    if caster:HasModifier("modifier_templar_light_seers_robe") then
        caster:RemoveModifierByName("modifier_light_seer_shield")
        caster.body:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_templar_channeling", {duration = 8.0})
    end
end

function Filters:EndRChannel(caster)
    if caster:HasModifier("modifier_galaxy_orb") then
        caster:RemoveModifierByName("modifier_galaxy_orb_channel")
    end
    if caster:HasModifier("modifier_space_tech") then
        caster:RemoveModifierByName("modifier_space_tech_channel")
    end
    if caster:HasModifier("modifier_ocean_tempest_pallium") then
        caster:RemoveModifierByName("modifier_ocean_tempest_pallium_channeling")
    end
    if caster:HasModifier("modifier_brazen_kabuto") then
        caster:RemoveModifierByName("modifier_brazen_kabuto_channeling")
    end
    if caster:HasModifier("modifier_druid_spirit_helm") then
        caster:RemoveModifierByName("modifier_druid_channel")
    end
    if caster:HasModifier("modifier_burning_spirit_helmet") then
        caster:RemoveModifierByName("modifier_burning_spirit_helmet_flamethrower")
        StopSoundEvent("RPCItem.BurningSpiritHelm", caster)
    end

    caster:RemoveModifierByName("modifier_templar_channeling")

    caster:RemoveModifierByName("modifier_water_mage_channeling")
end

function Filters:ApplyQskills(caster)
    if caster:HasModifier("modifier_mask_of_ahnqhir_purple") then
        local ability = caster:GetAbilityByIndex(DOTA_Q_SLOT)
        local baseCd = ability:GetCooldownTimeRemaining()
        baseCd = baseCd * (100-TWISTED_MASK_OF_AHNQHIR_PURPLE_CD_RED_PCT)/100
        ability:EndCooldown()

        ability:StartCooldown(baseCd)
    end
    if caster:HasModifier("modifier_tattered_novice_stack") then
        local ability = caster:GetAbilityByIndex(DOTA_Q_SLOT)
        local currentStack = caster:GetModifierStackCount("modifier_tattered_novice_stack", caster.InventoryUnit)
        if currentStack > 1 then
            caster:SetModifierStackCount("modifier_tattered_novice_stack", caster.InventoryUnit, currentStack - 1)
        else
            caster:RemoveModifierByName("modifier_tattered_novice_stack")
        end
        ability:EndCooldown()
    end
    if caster:HasModifier("modifier_watcher_one") then
        Filters:WatcherOne(caster)
    end
    if caster:HasModifier("modifier_antique_mana_relic") then
        if caster:GetMana() >= caster:GetMaxMana() * ANTIQUE_MANA_RELIC_MANA_DRAIN/100 then
            caster:ReduceMana(caster:GetMaxMana() * ANTIQUE_MANA_RELIC_MANA_DRAIN/100)
            caster.amulet:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_mana_relic_damage_boost", {duration = ANTIQUE_MANA_RELIC_BUFF_DURATION})
            CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_mana_leak.vpcf", caster, ANTIQUE_MANA_RELIC_BUFF_DURATION)
        end
    end
    if caster:HasModifier("modifier_djanghor_glyph_5_1") then
        if caster:GetUnitName() == "npc_dota_hero_monkey_king" then
            local qAbility = caster:GetAbilityByIndex(DOTA_Q_SLOT)
            Filters:ReduceCooldownGeneric(caster, qAbility, DJANGHOR_GLYPH_5_1_Q_CD_RED)
        end
    end
    if caster:HasModifier("modifier_royal_wristguards") then
        local current_stack = caster:GetModifierStackCount("modifier_royal_wristguards_stack_effect", caster.handItem)
        local qAbility = caster:GetAbilityByIndex(DOTA_Q_SLOT)
        qAbility.royalStacks = current_stack
        if not caster:HasModifier("modifier_royal_wristguards_stack_effect") then
            qAbility.royalStacks = 0
        end
        caster:RemoveModifierByName("modifier_royal_wristguards_stack_effect")
    end
    if caster:HasModifier("modifier_nightmare_rider") then
        Filters:NightmareRider(caster)
    end
    if caster:HasModifier("modifier_outland_stone_cuirass") then
        CustomAbilities:QuickAttachParticle("particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf", caster, 4)
        caster:AddNewModifier(caster, nil, "modifier_stunned", {duration = OUTLAND_STONE_SELF_STUN})
    end
    if caster:HasModifier("modifier_dark_emissary_glove") then
        Filters:DarkEmissary(caster)
    end
    local ability = caster:GetAbilityByIndex(DOTA_Q_SLOT)
    if ability.castPointSave then
        ability:SetOverrideCastPoint(ability.castPointSave)
        ability.castPointSave = nil
    end
    if caster:HasModifier("modifier_sorceress_immortal_weapon_2") then
        if not caster.avatar then
            if caster:GetMana() >= caster:GetMaxMana() * 0.5 then
                local avatar = CreateUnitByName("sorceress_clone", caster:GetAbsOrigin() + RandomVector(200), false, nil, nil, caster:GetTeamNumber())
                avatar:SetOwner(caster)
                avatar:SetControllableByPlayer(caster:GetPlayerID(), true)
                caster.avatar = avatar
                avatar.runeUnit = caster.runeUnit
                avatar.runeUnit2 = caster.runeUnit2
                avatar.runeUnit3 = caster.runeUnit3
                avatar.runeUnit4 = caster.runeUnit4
                local particle = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
                local pfx = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
                local position = avatar:GetAbsOrigin()
                local radius = 140
                ParticleManager:SetParticleControl(pfx, 0, position)
                ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 2, radius * 2))
                Timers:CreateTimer(3, function()
                    ParticleManager:DestroyParticle(pfx, false)
                end)
                EmitSoundOn("Ability.FrostNova", avatar)
                caster.weapon:ApplyDataDrivenModifier(caster.InventoryUnit, avatar, "modifier_sorceress_immortal_ice_avatar", {})
                if caster:HasAbility("blizzard") then
                    local ability1 = caster:FindAbilityByName("blizzard")
                    local abilityLevel = ability1:GetLevel()
                    avatar:AddAbility(ability1:GetAbilityName()):SetLevel(abilityLevel)
                    avatar:RemoveModifierByName("modifier_sorceress_passive")
                    avatar:AddAbility("ice_lance"):SetLevel(abilityLevel)
                end
                if caster:HasAbility("sorceress_fire_arcana_q") then
                    local ability1 = caster:FindAbilityByName("sorceress_fire_arcana_q")
                    local abilityLevel = ability1:GetLevel()
                    avatar:AddAbility(ability1:GetAbilityName()):SetLevel(abilityLevel)
                    avatar:AddAbility("sorceress_sun_lance"):SetLevel(abilityLevel)
                end

                if caster:HasAbility("sorceress_blink") then
                    local ability2 = caster:FindAbilityByName("sorceress_blink")
                    local abilityLevel = ability2:GetLevel()
                    avatar:AddAbility(ability2:GetAbilityName()):SetLevel(abilityLevel)
                end
                avatar.origCaster = caster
                avatar:AddAbility("normal_steadfast"):SetLevel(1)
                caster:ReduceMana(caster:GetMaxMana() * 0.5)
            end
        end
    end
end

function Filters:ApplyWskills(caster)
    if caster:HasModifier("modifier_mask_of_ahnqhir_yellow") then
        local ability = caster:GetAbilityByIndex(DOTA_W_SLOT)
        local baseCd = ability:GetCooldownTimeRemaining()
        baseCd = math.max(baseCd - TWISTED_MASK_OF_AHNQHIR_YELLOW_CD_RED, 0)
        ability:EndCooldown()
        ability:StartCooldown(baseCd)
    end
    if caster:HasModifier("modifier_buzukis_finger") then
        Filters:BuzukisFinger(caster)
    end
    if caster:HasModifier("modifier_igneous_canine_helm") then
        Filters:IgneousCanine(caster)
    end
    if caster:HasModifier("modifier_body_seraphic") then
        Filters:SeraphicVest(caster)
    end
    if caster:HasModifier("modifier_spellslinger_coat") then
        Filters:SpellslingerCoat(caster)
    end
    if caster:HasModifier("modifier_white_mage_hat") or caster:HasModifier("modifier_white_mage_hat2") then
        Filters:WhiteMageHat(caster)
    end
    if caster:HasModifier("modifier_witch_hat") then
        Filters:WitchHat(caster)
    end
    if caster:HasModifier("modifier_trickster_mask") then
        Filters:TricksterMask(caster)
    end
    if caster:HasModifier("modifier_cerulean_high_guard") then
        Filters:CeruleanHighguard(caster)
    end
    if caster:HasModifier("tanari_water_bomb_hero") then
        Filters:BombThrow(caster)
    end
    if caster:HasModifier("modifier_sacred_trials_armor") then
        caster.body:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_sacred_trials_attack_bonus", {duration = 12})
    end
    if caster:HasModifier("modifier_phantom_sorcerer") then
        local ability = caster:GetAbilityByIndex(DOTA_W_SLOT)
        local cdRemaining = ability:GetCooldownTimeRemaining()
        local newCD = math.min(cdRemaining + PHANTOM_SORCERER_CD_INCREASE, ability:GetCooldown(ability:GetLevel() - 1) + PHANTOM_SORCERER_CD_INCREASE)
        ability:EndCooldown()
        ability:StartCooldown(newCD)
    end
    if caster:HasModifier("modifier_cytopian_laser") then
        Filters:CytopianLaser(caster)
    end
    if caster:HasModifier("modifier_tome_of_chaos") then
        Filters:TomeOfChaos(caster)
    end
    if caster:HasModifier("modifier_iron_colossus") then
        local ability = caster:GetAbilityByIndex(DOTA_W_SLOT)
        local manaCost = ability:GetManaCost(ability:GetLevel())
        caster:ReduceMana(1000)
    end
    if caster:HasModifier("modifier_auriun_immortal_weapon_3") then
        if caster:GetUnitName() == "npc_dota_hero_zuus" then
            if not caster:HasModifier("modifier_auriun_immortal_weapon_3_effect") then
                EmitSoundOn("Auriun.Immo3Activate", caster)
            end
            caster:RemoveModifierByName("modifier_auriun_immortal_weapon_3_effect")
            caster.weapon:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_auriun_immortal_weapon_3_effect", {duration = AURIUN_IMMO_WEAPON_3_DURATION})
        end
    end
    if caster:HasModifier("modifier_windsteel_armor") then
        if not caster:HasModifier("modifier_windsteel_cooldown") then
            local stackCount = caster:GetAbilityByIndex(DOTA_W_SLOT):GetLevel()
            caster.body:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_windsteel_effect", {duration = WINDSTEEL_DURATION})
            caster.body:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_windsteel_stat_bonuses", {duration = WINDSTEEL_DURATION})
            caster.body:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_windsteel_cooldown", {duration = WINDSTEEL_COOLDOWN})
            caster:SetModifierStackCount("modifier_windsteel_effect", caster.body, stackCount)
            EmitSoundOn("Item.WindSteel", caster)
        end
    end
    local ability = caster:GetAbilityByIndex(DOTA_W_SLOT)
    if ability.castPointSave then
        ability:SetOverrideCastPoint(ability.castPointSave)
        ability.castPointSave = nil
    end
    local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
    if caster:HasModifier("modifier_burnout") then
        local currentStacks = caster:GetModifierStackCount("modifier_burnout", Events.GameMaster) + 1
        caster:SetModifierStackCount("modifier_burnout", Events.GameMaster, currentStacks)
        if currentStacks == 15 then
            local disableAbility = caster:GetAbilityByIndex(DOTA_W_SLOT)
            if IsValidEntity(disableAbility) then
                disableAbility:StartCooldown(5)
                Notifications:Top(caster:GetPlayerOwnerID(), {text = "Too Fast!", duration = 2, style = {color = "red"}, continue = true})
                -- disableAbility:SetActivated(false)
                -- Timers:CreateTimer(5, function()
                --     if IsValidEntity(disableAbility) then
                --         disableAbility:SetActivated(true)
                --     end
                -- end)
            end
        end
    else
        gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, caster, "modifier_burnout", {duration = 1})
        caster:SetModifierStackCount("modifier_burnout", Events.GameMaster, 1)
    end
end

function Filters:ApplyEskills(caster)
    local ability = caster:GetAbilityByIndex(DOTA_E_SLOT)
    local baseCd = ability:GetCooldownTimeRemaining()
    Filters:ReduceECooldown(caster, ability, baseCd, false)
    if caster:HasModifier("modifier_violet_boots") then
        Filters:VioletBoot(caster)
    end
    if caster:HasModifier("modifier_sonic_boots") then
        Filters:SonicBoot(caster)
    end
    if caster:HasModifier("modifier_falcon_boots") then
        Filters:FalconBoot(caster)
    end
    if caster:HasModifier("modifier_gem_of_eternal_frost") then
        Filters:EternalFrost(caster)
    end
    if caster:HasModifier("modifier_temporal_warp_boots") then
        Filters:TimeWarp(caster)
    end
    if caster:HasModifier("modifier_avernus_e_nerf") then
        ability:EndCooldown()
        baseCd = baseCd + 15
        ability:StartCooldown(baseCd)
    end
    if caster:HasModifier("modifier_voyager_boots") then
        Filters:VoyagerBoots(caster)
    end
    if caster:HasModifier("modifier_arcanys_slipper") then
        Timers:CreateTimer(0.45, function()
            caster.arcanys:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_arcanys_slipper_effect", {duration = 1.25})
            caster:RemoveModifierByName("modifier_arcanys_slipper_buff")
        end)
    end
    if caster:HasModifier("modifier_redrock_footwear") then
        Filters:RedrockFootwear(caster)
    end
    if caster:HasModifier("modifier_carbuncles_helm_of_reflection") then
        local shieldDuration = math.max(ability:GetCooldownTimeRemaining() * CARBUNCLE_SHIELD_DUR_RELATIVE_PCT/100, CARBUNCLE_SHIELD_DUR_MIN)
        caster.headItem:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_carbuncles_helm_of_reflection_effect", {duration = shieldDuration})
    end
    if caster:HasModifier("modifier_boots_of_pure_waters") then
        Filters:PureWaters(caster)
    end
    if caster:HasModifier("modifier_gloves_of_sweeping_wind") then
        Filters:SweepingWindStack(caster)
    end
    if caster:HasModifier("modifier_moon_techs") then
        Filters:MoonTechRunners(caster)
    end
    if caster:HasModifier("modifier_guard_of_feronia") then
        caster.body:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_guard_of_feronia_shield", {duration = GUARD_OF_FERONIA_SHIELD_DURATION_E})
    end
    if caster:HasModifier("modifier_wind_deity_crown") then
        caster:RemoveModifierByName("modifier_wind_deity_damage_buff")
    end

end

function Filters:ApplyRskills(caster)

    if caster:HasModifier("modifier_hurricane_vest") then
        --print(caster.InventoryUnit:GetUnitName())
        caster.body:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_hurricane_vest_start", {duration = 0.3})
    end
    if caster:HasModifier("modifier_body_flooding") then
        Filters:FloodRobe(caster)
    elseif caster:HasModifier("modifier_body_avalanche") then
        Filters:AvalanchePlate(caster)
    end
    if caster:HasModifier("modifier_secret_temple") then
        Filters:SecretTemple(caster)
    end
    if caster:HasModifier("modifier_ruby_dragon") then
        Filters:RubyDragon(caster)
    end
    if caster:HasModifier("modifier_spirit_glove") then
        Filters:SpiritGlove(caster)
    end
    if caster:HasModifier("modifier_super_ascendency") then
        Filters:AscensionTrigger(caster)
    end
    if caster:HasModifier("modifier_scourge_knight") then
        Filters:ScourgeKnight(caster)
    end
    if caster:HasModifier("modifier_desert_necromancer") then
        Filters:ReanimateThorok(caster)
    end
    if caster:HasModifier("modifier_autumn_sleeper_mask") then
        Filters:AutumnSleeperMask(caster)
    end
    if caster:HasModifier("modifier_doomplate") then
        Filters:DoomplateSummon(caster)
    end
    if caster:HasModifier("modifier_alien_armor") then
        Filters:AlienArmor(caster)
    end
    if caster:HasModifier("modifier_guard_of_feronia") then
        caster.body:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_guard_of_feronia_shield", {duration = GUARD_OF_FERONIA_SHIELD_DURATION_R})
    end
    if caster:HasModifier("modifier_shadow_trap_passive") then
        local shadowAbility = caster:FindAbilityByName("auriun_shadow_trap")
        if IsValidEntity(shadowAbility) then
            shadowAbility.q_4_level = caster:GetRuneValue("q", 4)
            if shadowAbility.q_4_level > 0 then
                local duration = Filters:GetAdjustedBuffDuration(caster, AURIUN_ARCANA_2_Q4_DURATION, false)
                shadowAbility:ApplyDataDrivenModifier(caster, caster, "modifier_shadow_trap_d_a_buff", {duration = duration})
                caster:SetModifierStackCount("modifier_shadow_trap_d_a_buff", caster, shadowAbility.q_4_level)
            end
        end
    end
    if caster:HasModifier("modifier_helm_of_silent_templar") then
        caster.headItem:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_helm_of_silent_templar_effect", {duration = SILENT_TEMPLAR_DURATION})
        local particleName = "particles/dark_smoke_test.vpcf"
        local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
        ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())

        Timers:CreateTimer(1.5, function()
            ParticleManager:DestroyParticle(pfx, false)
        end)
    end
    if caster:HasModifier("modifier_alaranas_ice_boot") then
        EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "RPCItem.AlaranaIce", caster.InventoryUnit)
        caster.foot:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_alarana_ice_freeze", {duration = ALARANA_ICE_ENCASE_DURATION})
        caster.foot.alaranaIce = caster:GetMaxHealth() * ALARANA_DAMAGE_BLOCK_THRESHOLD_OF_MAX_HP
    end
    if caster:HasModifier("modifier_brazen_kabuto") then
        caster.kabuto:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_brazen_kabuto_shield", {duration = KABUTO_SHIELD_DUR})
    end
    if caster:HasModifier("modifier_sorceress_immortal_weapon_3") then
        if not caster.avatar then
            if caster:GetMana() >= caster:GetMaxMana() * 0.5 then
                local avatar = CreateUnitByName("sorceress_clone", caster:GetAbsOrigin() + RandomVector(200), false, nil, nil, caster:GetTeamNumber())
                avatar:SetOwner(caster)
                avatar:SetControllableByPlayer(caster:GetPlayerID(), true)
                caster.avatar = avatar
                avatar.runeUnit = caster.runeUnit
                avatar.runeUnit2 = caster.runeUnit2
                avatar.runeUnit3 = caster.runeUnit3
                avatar.runeUnit4 = caster.runeUnit4
                local particleName = "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf"
                local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
                ParticleManager:SetParticleControl(particle1, 0, avatar:GetAbsOrigin())
                Timers:CreateTimer(2, function()
                    ParticleManager:DestroyParticle(particle1, false)
                end)
                EmitSoundOn("Hero_Invoker.SunStrike.Ignite", avatar)
                caster.weapon:ApplyDataDrivenModifier(caster.InventoryUnit, avatar, "modifier_sorceress_immortal_fire_avatar", {})
                if caster:HasAbility("pyroblast") then
                    local ability1 = caster:FindAbilityByName("pyroblast")
                    local abilityLevel = ability1:GetLevel()
                    avatar:AddAbility(ability1:GetAbilityName()):SetLevel(abilityLevel)
                    avatar:AddAbility("fireball"):SetLevel(abilityLevel)
                elseif caster:HasAbility("sorceress_arcana_ice_tornado") then
                    local ability1 = caster:FindAbilityByName("sorceress_arcana_ice_tornado")
                    local abilityLevel = ability1:GetLevel()
                    avatar:AddAbility(ability1:GetAbilityName()):SetLevel(abilityLevel)
                end

                if caster:HasAbility("sorceress_blink") then
                    local ability2 = caster:FindAbilityByName("sorceress_blink")
                    local abilityLevel = ability2:GetLevel()
                    avatar:AddAbility(ability2:GetAbilityName()):SetLevel(abilityLevel)
                end
                avatar.origCaster = caster
                avatar:AddAbility("normal_steadfast"):SetLevel(1)
                caster:ReduceMana(caster:GetMaxMana() * 0.5)
            end
        end
    end
end

function Filters:ApplyDamageBasic(victim, attacker, damage, damage_type)
    -- if damage_type == DAMAGE_TYPE_PHYSICAL then
    --     damage = damage/(1+((attacker:GetIntellect()/16)/100))
    -- end
    -- ApplyDamage({ victim = victim, attacker = attacker, damage = damage, damage_type = damage_type })
    Filters:ApplyDamageInstances(victim, attacker, damage, damage_type, 0)
end

function Filters:TakeArgumentsAndApplyDamage(victim, attacker, damage, damage_type, slot, element1, element2, ignore_effects, ability)
    -- if damage_type == DAMAGE_TYPE_PHYSICAL then
    --     damage = damage/(1+((attacker:GetIntellect()/16)/100))
    -- end
    ----print("before bad and elem: "..damage)
    local Is_solunia_b_d = false
    if slot == -2 then
        slot = 0
        Is_solunia_b_d = true
    end

    local damageData = attacker._damage_data or {}

    local attackerName = attacker:GetUnitName()
    if not ignore_effects then
        -- if attacker:HasModifier("modifier_heavy_echo_gauntlet") then
        --     if not victim.echoLock then
        --         victim.echoLock = true
        --         Filters:TakeArgumentsAndApplyDamage(victim, attacker, damage, damage_type, slot, element1, element2, ignore_effects)
        --         Filters:TakeArgumentsAndApplyDamage(victim, attacker, damage, damage_type, slot, element1, element2, ignore_effects)
        --         victim.echoLock = false
        --     end
        -- end
    end

    if slot == BASE_AUTO_ATTACK then
        if attacker:HasModifier("modifier_divine_purity") then
            damage = damage * GAUNTLET_OF_DIVINE_PURITY_MULTIPLIER
            element2 = RPC_ELEMENT_HOLY
            damage_type = DAMAGE_TYPE_PURE
        end
        if attacker:HasModifier("modifier_hand_proud_gloves") then
            damage = Filters:AdjustItemDamage(attacker, damage, victim)
            local highestElement = 1
            local highestElementAmp = 100
            local elements = CustomAttributes:CalculatedElementBonuses(victim, attacker)
            for i,v in ipairs(elements) do
                if v > highestElementAmp then
                    highestElement = i
                    highestElementAmp = v
                end
            end
            element1 = highestElement
            element2 = RPC_ELEMENT_NONE
            damage_type = DAMAGE_TYPE_MAGICAL
        end
    end

    damage, element1, element2 = Filters:ElementalDamage(victim, attacker, damage, damage_type, slot, element1, element2, not ignore_effects)
    attacker.element1 = element1
    attacker.element2 = element2
    local damageMult = 0
    -- print("Damage: "..damage)
    -- print("Element1: "..element1)
    -- print("Element2: "..element2)
    if attacker:HasModifier("modifier_sorceress_immortal_fire_avatar") or attacker:HasModifier("modifier_sorceress_immortal_ice_avatar") then
        attacker = attacker.origCaster
    end

    if Util.BaseType:IsAbilityBaseType(slot) then
        damageMult = damageMult + heroes.venomort.getBad(attacker)
        if attacker:IsRealHero() then
            damageMult = damageMult + attacker:GetSpirit()*(CustomAttributes.BAD_PER_SPIRIT/100)
        end
        if attacker:HasModifier("modifier_watcher_two") then
            damageMult = damageMult + WATCHER_II_BAD/100
        end
        if attacker:HasModifier("modifier_eye_of_avernus") then
            damageMult = damageMult + EYE_OF_AVERNUS_BAD/100
        end
        if attacker:HasModifier("modifier_grand_arcanist") then
            damageMult = damageMult + GRAND_ARCANIST_BAD_PER_INT * attacker:GetIntellect()
        end
        if attacker:HasModifier("modifier_direwolf_bulwark_effect") then
            damageMult = damageMult + DIREWOLF_BULWARK_BAD/100 * attacker:GetModifierStackCount("modifier_direwolf_bulwark_effect", attacker.InventoryUnit)
        end
        if attacker:HasModifier("modifier_oceanrunner_boots") then
            damageMult = damageMult + OCEANRUNNER_AGI_TO_BAD/100 * (attacker:GetAgility() / OCEANRUNNER_AGI_DIVISOR)
        end
        if attacker:HasModifier("modifier_white_mage_hat2") then
            damageMult = damageMult + WHITE_MAGE_BAD_PER_INT/100 * (attacker:GetIntellect() / WHITE_MAGE_INT_DIVISOR)
        end
        if attacker:HasModifier("modifier_garnet_warfare_ring") then
            damageMult = damageMult + GARNET_WARFARE_STR_TO_BAD/100 * (attacker:GetStrength() / GARNET_WARFARE_STR_DIVISOR)
        end
        if attacker:HasModifier("modifier_torch_of_gengar_effect") then
            damageMult = damageMult + GENGAR_BAD/100
        end
        if attacker:HasModifier("modifier_enchanted_solar_cape_effect") then
            damageMult = damageMult + SOLAR_CAPE_BAD_AND_ELEMENTAL_AMP/100
        end
        if attacker:HasModifier("modifier_boots_of_old_wisdom_active") then
            damageMult = damageMult + OLD_WISDOM_BAD/100
        end
        if attacker:HasModifier("modifier_ogthun_visible") then
            local current_stack = attacker:GetModifierStackCount("modifier_ogthun_visible", attacker.body)
            damageMult = damageMult + 0.02 * current_stack
        end
        if attacker:HasModifier("modifier_azure_empire_base_ability") then
            local current_stack = attacker:GetModifierStackCount("modifier_azure_empire_base_ability", attacker.InventoryUnit)
            damageMult = damageMult + PENDANT_AZURE_EMPIRE_SILVER_BAD/100 * current_stack
        end
        if attacker:HasModifier("modifier_orthok_zeal") then
            local current_stack = attacker:GetModifierStackCount("modifier_orthok_zeal", attacker.InventoryUnit)
            damageMult = damageMult + ORTHOK_STACK_BAD/100 * current_stack
        end
        if attacker:HasModifier("modifier_flood_basin_a_d") then
            local current_stack = attacker:GetModifierStackCount("modifier_flood_basin_a_d", attacker)
            damageMult = damageMult + HYDROXIS_ARCANA_R1_BAD_PCT/100 * current_stack
        end
        if attacker:HasModifier("modifier_chernobog_immortal_weapon_2") then
            local missingHealthPercent = math.floor((1 - (attacker:GetHealth() / attacker:GetMaxHealth())) * 100)
            damageMult = damageMult + missingHealthPercent * CHERNOBOG_IMMORTAL_WEP2_BAD_AND_ITEM_PCT_PER_MISSING_HP_PCT / 100
        end
        if attacker:HasModifier("modifier_swiftspike_bad") then
            local current_stack = attacker:GetModifierStackCount("modifier_swiftspike_bad", attacker.InventoryUnit)
            damageMult = damageMult + SWIFTSPIKE_BAD_PER_MS * current_stack
        end
        if attacker:HasModifier("modifier_bahamut_a_b_buff") then
            local current_stack = attacker:GetModifierStackCount("modifier_bahamut_a_b_buff", attacker.runeUnit:FindAbilityByName("bahamut_rune_w_1"))
            damageMult = damageMult + BAHAMUT_W1_BONUS_DMG_AND_BAD_PCT/100 * current_stack
        end
        if attacker:HasModifier("modifier_venomort_rune_r_4") then
            local current_stack = attacker:GetModifierStackCount("modifier_venomort_rune_r_4", attacker.runeUnit4:FindAbilityByName("venomort_rune_r_4"))
            damageMult = damageMult + 0.1 * current_stack
        end

        if attacker:HasAbility("mountain_protector_emberstone") then
            local e_4_level = attacker:GetRuneValue("e", 4)
            damageMult = damageMult + MOUNTAIN_PROTECTOR_E4_BAD * e_4_level
        end
        if attacker:HasModifier("modifier_infused_mageplate_stack") then
            local mageplateStacks = attacker:GetModifierStackCount("modifier_infused_mageplate_stack", attacker.body)
            damageMult = damageMult + mageplateStacks * 0.05
        end
        if attacker:IsHero() then
            damageMult = damageMult + 0.01 * (CustomAttributes:AddStatsBonusFromStacks(attacker, nil, "modifier_head_base_ability", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, nil, "modifier_weapon_base_ability", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, nil, "modifier_hands_base_ability", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, nil, "modifier_feet_base_ability", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, nil, "modifier_body_base_ability", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, nil, "modifier_amulet_base_ability", 1))
        end
        if attacker:HasModifier("modifier_jex_orbital_flame_effect") then
            local fireAbility = attacker:FindAbilityByName("jex_fire_cosmic_w")
            damageMult = damageMult + (fireAbility:GetSpecialValueFor("base_ability_damage_per_flame_tech") / 100) * attacker:GetModifierStackCount("modifier_jex_orbital_flame_effect", attacker) * fireAbility.tech_level
        end
        if attacker:HasModifier("modifier_neutral_glyph_2_2") then
            damageMult = damageMult + 2.5
        end
        if attacker:HasModifier("modifier_spiritual_empowerment_stack") then
            local current_stack = attacker:GetModifierStackCount("modifier_spiritual_empowerment_stack", attacker.InventoryUnit)
            damageMult = damageMult + (current_stack + 1) * SPIRITUAL_EMPOWERMENT_BAD/100
        end
        if attacker:HasModifier("modifier_ability_potion_1") then
            damageMult = damageMult + 0.3
        elseif attacker:HasModifier("modifier_ability_potion_2") then
            damageMult = damageMult + 0.6
        elseif attacker:HasModifier("modifier_ability_potion_3") then
            damageMult = damageMult + 0.9
        end
        if attacker:HasModifier("modifier_auriun_immortal_weapon_3_effect") then
            damageMult = damageMult + AURIUN_IMMO_WEAPON_3_BAD/100
        end
        if attacker:HasModifier("modifier_hawk_c_d") then
            local current_stack = attacker:GetModifierStackCount("modifier_hawk_c_d", attacker)
            damageMult = damageMult + DJANGHOR_R3_BIRD_BAD_PCT/100 * current_stack
        end
        if attacker:GetUnitName() == "npc_dota_hero_arc_warden" then
            if slot == BASE_ABILITY_E then
                if attacker.r_1_level then
                    damageMult = damageMult + attacker.r_1_level * (JEX_RUNE_BASE_ABILITY_R1/100)
                end
            elseif slot == BASE_ABILITY_Q then
                if attacker.r_2_level then
                    damageMult = damageMult + attacker.r_2_level * (JEX_RUNE_BASE_ABILITY_R2/100)
                end
            elseif slot == BASE_ABILITY_W then
                if attacker.r_3_level then
                    damageMult = damageMult + attacker.r_3_level * (JEX_RUNE_BASE_ABILITY_R3/100)
                end
            end
        end
    end

    if slot == BASE_ABILITY_Q then
        if attacker:GetUnitName() == "npc_dota_hero_templar_assassin" then
            if attacker:HasAbility("fulminating_trap") then
                damageMult = damageMult + TRAPPER_Q4_AMPLIFY_PERCENT*attacker:GetRuneValue("q", 4)
            end
        end
        if attacker:HasModifier("modifier_body_violet_guard") then
            damageMult = damageMult + 3
        elseif attacker:HasModifier("modifier_body_violet_guard2") then
            damageMult = damageMult + VIOLET_GUARD_ARMOR_BAD/100
        end
        if attacker:HasModifier("modifier_outland_stone_cuirass") then
            damageMult = damageMult + OUTLAND_STONE_BAD/100
        end
        if attacker:HasModifier("modifier_mana_relic_damage_boost") then
            damageMult = damageMult + ANTIQUE_MANA_RELIC_Q_BAD/100
        end
        if attacker:HasModifier("modifier_death_whisper") then
            if not ignore_effects then
                Filters:DeathWhisperApply(attacker, victim)
            end
        end
        if attacker:GetUnitName() == "npc_dota_hero_antimage" then
            if attacker:HasAbility("arkimus_zonis_spark") then
                local q_4_level = attacker:GetRuneValue("q", 4)
                damageMult = damageMult + ARKIMUS_Q4_ADD_DMG_PCT/100
            end
        end
        if attacker:HasModifier("modifier_vampiric_breastplate") then
            if not ignore_effects then
                Filters:VampiricBreastplate(attacker, damage)
            end
        end
        if attacker:HasModifier("modifier_conjuror_immortal_weapon_2") then
            if attacker:GetUnitName() == "npc_dota_hero_invoker" then
                damageMult = damageMult + CONJUROR_IMMORTAL_WEAPON_2_BAD_PER_ATTRIBUTES_PCT/100 * (attacker:GetStrength())
            end
        end
        if attacker:HasModifier("modifier_shipyard_veil") then
            local shipyardStacks = attacker:GetModifierStackCount("modifier_shipyard_veil_shield", attacker.InventoryUnit)
            damageMult = damageMult + shipyardStacks*(SHIPYARD_VEIL_BAD_PER_STACK/100)
            if not ignore_effects then
                Filters:ShipyardVeilQHit(attacker, victim)
            end
        end
        if attacker:HasModifier("modifier_spirit_warrior_immortal_weapon_1") then
            damageMult = damageMult + SPIRIT_WARRIOR_IMMORTAL_WEAPON_1_Q_DAMAGE_AMP_PCT/100
        end
        if attacker:HasModifier("modifier_royal_wristguards_stack_effect") then
            local qAbility = attacker:GetAbilityByIndex(DOTA_Q_SLOT)
            local current_stack = qAbility.royalStacks
            if not qAbility.royalStacks then
                current_stack = 1
            end
            damageMult = damageMult + 0.2 * current_stack
        end
        damage = damage * (1 + damageMult)
        if attacker:HasModifier('modifier_chernobog_glyph_5_1') then
            damage = damage * CHERNOBOG_T51_BAD_MULT_EXCEPT_E
        end
        if not ignore_effects then
            local indirectProcQ = false
            if attacker:HasModifier("modifier_luma_guard") and Filters:LumaGuardStrike(attacker, victim, damage) then
                indirectProcQ = true
            end
            if attacker:HasModifier("modifier_demon_mask") and Filters:DemonMask(attacker, victim, damage) then
                indirectProcQ = true
            end
            if not indirectProcQ then
                Filters:ApplyQdamage(victim, attacker, damage, damage_type)
            else
                damageData.isAugmented = true
            end
        end
    elseif slot == BASE_ABILITY_W then
        if attacker:HasModifier("modifier_watcher_three") then
            damageMult = damageMult + 0.35
        end
        if attacker:HasModifier("modifier_spellslinger_coat") then
            damageMult = damageMult + SPELLSLINGER_BAD/100
        end
        if not ignore_effects then
            if attacker:HasModifier("modifier_wild_nature_two") then
                Filters:WildNatureTwo(attacker, victim)
            end
        end
        if attacker:HasModifier("modifier_arkimus_immortal_weapon_1") then
            damageMult = damageMult + ARKIMUS_IMMORTAL_WEAPON_1_W_MULT
        end
        if attacker:HasModifier("modifier_phantom_sorcerer") then
            damageMult = damageMult + PHANTOM_SORCERER_BAD/100
        end
        if attacker:HasModifier("modifier_shadowflame_fist") then
            damageMult = damageMult + SHADOWFLAME_FIST_W_BAD/100
        end
        if attacker:HasModifier("modifier_wraith_hunters_steel_helm") then
            damageMult = damageMult + WRAITH_HUNTER_W_BAD/100
        end
        if attacker:HasModifier("modifier_cerulean_high_guard") then
            damageMult = damageMult + CERULEAN_HIGHGUARD_BAD/100
        end
		if attacker:HasModifier("modifier_zonik_immortal_weapon_1") then
			damageMult = damageMult + ZHONIK_IMMORTAL_WEAPON_1_W_BAD/100
		end
        if attacker:HasModifier("modifier_crest_of_the_umbral_sentinel") then
            Filters:UmbralSentinel(attacker, victim)
        end
        if attacker:HasModifier("modifier_mountain_protector_glyph_3_1") then
            damageMult = damageMult - (MOUNTAIN_PROTECTOR_GLYPH_3_1_BAD_R_REDUCE/100)
        end
        if attacker:HasModifier("modifier_conjuror_immortal_weapon_2") then
            if attacker:GetUnitName() == "npc_dota_hero_invoker" then
                damageMult = damageMult + CONJUROR_IMMORTAL_WEAPON_2_BAD_PER_ATTRIBUTES_PCT/100 * (attacker:GetIntellect())
            end
        end
        if attacker:HasModifier("modifier_duskbringer_immortal_weapon_2") then
            if attacker:GetUnitName() == "npc_dota_hero_spirit_breaker" then
                Filters:ApplyStun(attacker, DUSKBRINGER_IMMORTAL_WEAPON_2_W_STUN, victim)
            end
        end
        if attacker:HasModifier("modifier_trickster_mask") then
            local randomFactor = RandomInt(TRICKSTER_MASK_W_DMG_MULT_MIN * 10, TRICKSTER_MASK_W_DMG_MULT_MAX * 10) / 10
            damage = damage * randomFactor
        end
        if attacker:HasModifier("modifier_claws_of_the_ethereal_revenant") then
            if not ignore_effects then
                local proc = Filters:GetProc(attacker, ETHEREAL_REVENANT_CHANCE)
                if proc then
                    Timers:CreateTimer(0.05, function()
                        attacker.handItem:ApplyDataDrivenModifier(attacker.InventoryUnit, victim, "modifier_ethereal_revenant_link", {duration = ETHEREAL_REVENANT_DURATION})
                    end)
                end
            end
        end

        if attacker:HasModifier("modifier_hood_of_defiler") then
            Filters:DefilerHit(attacker, victim)
        end
        if attacker:HasModifier("modifier_astral_glyph_1_1") then
            damage = 0
        end
        if attacker:GetUnitName() == "npc_dota_hero_templar_assassin" then
            if attacker:HasAbility("explosive_bomb") then
                damageMult = damageMult + TRAPPER_W4_AMPLIFY_PERCENT*attacker:GetRuneValue("w", 4)
            end
        end
        damage = damage * (1 + damageMult)
        if attacker:HasModifier('modifier_chernobog_glyph_5_1') then
            damage = damage * CHERNOBOG_T51_BAD_MULT_EXCEPT_E
        end
        if not ignore_effects then
            local indirectProcW = false
            if attacker:HasModifier("modifier_fire_deity_crown") and Filters:FireDeity(attacker, victim, damage) then
                indirectProcW = true
            end
            if attacker:HasModifier("modifier_frostburn_gauntlets") and Filters:FrostburnGauntlet(attacker, victim, damage) then
                indirectProcW = true
            end
            if not indirectProcW then
                Filters:ApplyWdamage(victim, attacker, damage, damage_type)
            else
                damageData.isAugmented = true
            end
        end

    elseif slot == BASE_ABILITY_E then
        if attacker:HasModifier("modifier_admiral_boots") then
            damageMult = damageMult + ADMIRAL_BOOTS_BAD_E/100
        end
        if attacker:HasModifier("modifier_boots_of_ashara") and attacker:GetHealth() / attacker:GetMaxHealth() <= BOOTS_OF_ASHARA_HP_THRESHOLD/100 then
            damageMult = damageMult + BOOTS_OF_ASHARA_BAD_E
        end
		if attacker:HasModifier("modifier_zhonic_arcana_c_c_invisible") then
			local stacks = attacker:GetModifierStackCount("modifier_zhonic_arcana_c_c_invisible", attacker)
			local multIncrease = stacks * ZHONIK_E3_ARCANA_E_BAD_PCT / 100
			damageMult = damageMult + multIncrease
		end

        if attacker:HasModifier("modifier_wind_deity_crown") then
            if not ignore_effects then
                if attacker:IsAlive() then
                    local ability = attacker.headItem
                    if ability.targetsHit < WIND_DEITY_CROWN_ATTACK_LIMIT then
                        ability.targetsHit = ability.targetsHit + 1
                        CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_ogre_magi/windstrike_weapon_buff_circle_flash.vpcf", victim, 1)
                        Filters:PerformAttackSpecial(attacker, victim, true, true, true, false, true, false, false)
                    end
                    ability:ApplyDataDrivenModifier(attacker.InventoryUnit, attacker, "modifier_wind_deity_damage_buff", {duration = WIND_DEITY_CROWN_BONUS_DMG_DURATION})
                    local currentStacks = attacker:GetModifierStackCount("modifier_wind_deity_damage_buff", attacker.InventoryUnit)
                    attacker:SetModifierStackCount("modifier_wind_deity_damage_buff", attacker.InventoryUnit, currentStacks + 1)
                end
            end
        end
        if attacker:HasModifier("modifier_conjuror_immortal_weapon_2") then
            if attacker:GetUnitName() == "npc_dota_hero_invoker" then
                damageMult = damageMult + CONJUROR_IMMORTAL_WEAPON_2_BAD_PER_ATTRIBUTES_PCT/100 * (attacker:GetAgility())
            end
        end
        damage = damage * (1 + damageMult)
        -- if attacker:HasModifier("modifier_red_october_boots") then
        --     local proc = true
        --     if proc then
        --         local redDamage = damage
        --         for i = 0, 2, 1 do
        --             Timers:CreateTimer(i*0.4, function()
        --                 if victim:IsAlive() and attacker:IsAlive() then
        --                     Events:CreateLightningBeamWithParticle(attacker:GetAbsOrigin()+Vector(0,0,60), victim:GetAbsOrigin()+Vector(0,0,140), "particles/econ/items/antimage/antimage_weapon_basher_ti5_gold/am_basher_lightning.vpcf", 1.5)
        --                     Filters:ApplyItemDamage(victim,attacker,redDamage,DAMAGE_TYPE_MAGICAL,attacker.foot,RPC_ELEMENT_NATURE,RPC_ELEMENT_LIGHTNING)
        --                 end
        --             end)
        --         end
        --     end
        -- end
        if not ignore_effects then
            Filters:ApplyEdamage(victim, attacker, damage, damage_type)
        end
    elseif slot == BASE_ABILITY_R then
        if attacker:HasModifier("modifier_master_gloves") then
            damageMult = damageMult + MASTER_GLOVES_BAD/100
        end
        if attacker:HasModifier("modifier_watcher_four") then
            damageMult = damageMult + 0.35
        end
        if attacker:HasModifier("modifier_doomplate") then
            Filters:DoomplateApply(attacker, victim)
        end
        if attacker:HasModifier("modifier_axe_arcana2") then
            local r_1_level = attacker:GetRuneValue("r", 1)
            damageMult = damageMult + RED_GENERAL_ARCANA1_R1_AMPLIFY_PERCENT*r_1_level
        end
        if attacker:HasModifier("modifier_ocean_tempest_pallium") and attacker.ocean_tempest and attacker.ocean_tempest.manaDrained then
            --TO DO check for bugs
            local damageIncrease = (attacker.ocean_tempest.manaDrained / OCEAN_TEMPEST_MANA_DRAIN_THRESHOLD) * OCEAN_TEMPEST_BAD_PER_MANA_THRESHOLD/100
            damageMult = damageMult + damageIncrease
        end

        damage = damage * (1 + damageMult)
        if attacker:HasModifier('modifier_chernobog_glyph_5_1') then
            damage = damage * CHERNOBOG_T51_BAD_MULT_EXCEPT_E
        end
        if not ignore_effects then
            local indirectProcR = false
            if attacker:HasModifier("modifier_water_deity_crown") then
                indirectProcR = true
                if not attacker.headItem.waterParticleCount then
                    attacker.headItem.waterParticleCount = 0
                end
                if attacker.headItem.waterParticleCount <= 9 then
                    CustomAbilities:QuickAttachParticle("particles/roshpit/water_deity.vpcf", victim, 3)
                    attacker.headItem.waterParticleCount = attacker.headItem.waterParticleCount + 1
                    Timers:CreateTimer(1, function()
                        attacker.headItem.waterParticleCount = attacker.headItem.waterParticleCount - 1
                    end)
                end
                Filters:ApplyItemDamageBasedOnAbility(victim, attacker, damage*WATER_DEITY_CROWN_DAMAGE_AMP/100, DAMAGE_TYPE_PURE, nil, RPC_ELEMENT_WATER, RPC_ELEMENT_NONE)
                attacker.headItem:ApplyDataDrivenModifier(attacker.InventoryUnit, victim, "modifier_water_deity_crown_slow", {duration = WATER_DEITY_CROWN_MOVESPEED_SLOW_DURATION})
            end
            if not indirectProcR then
                Filters:ApplyRdamage(victim, attacker, damage, damage_type)
            else
                damageData.isAugmented = true
            end
        end
    end
    if not ignore_effects then
        if Util.BaseType:IsAbilityBaseType(slot)
        or slot == BASE_AUTO_ATTACK then
            if attacker:HasModifier("modifier_mach_punch_passive") then
                local w_4_level = attacker:GetRuneValue("w", 4)
                if w_4_level > 0 then
                    if not victim.dummy then
                        local ability = attacker:FindAbilityByName("zonik_mach_punch")
                        ability:ApplyDataDrivenModifier(attacker, victim, "modifier_zonik_echo", {duration = 4})
                        if not victim.zonikEcho then
                            victim.zonikEcho = 0
                        end
                        victim.zonikEcho = victim.zonikEcho + damage * w_4_level * ZHONIK_W4_ECHO_DMG_PCT/100
                    end
                end
            end
        end
        if attacker:HasModifier("modifier_bahamut_immortal_weapon_1") then
            local proc = Filters:GetProc(attacker, BAHAMUT_IMMORTAL_WEAPON_1_CHANCE)
            if proc then
                --print("BIG IMMORTAL NUKE!")
                local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_death_end.vpcf", PATTACH_CUSTOMORIGIN, victim)
                ParticleManager:SetParticleControlEnt(pfx, 0, victim, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", victim:GetAbsOrigin(), true)
                ParticleManager:SetParticleControl(pfx, 1, Vector(255, 255, 255))
                Timers:CreateTimer(2.5, function()
                    ParticleManager:DestroyParticle(pfx, false)
                end)
                ApplyDamage({victim = victim, attacker = attacker, damage = damage * BAHAMUT_IMMORTAL_WEAPON_1_DAMAGE_AMP, damage_type = DAMAGE_TYPE_PURE})
            end
        end
    end
    if slot == BASE_ITEM 
    or slot == BASE_NONE 
    or slot == BASE_AUTO_ATTACK then
        if not Is_solunia_b_d then
            Filters:ApplyDamageInstances(victim, attacker, damage, damage_type, ability or slot or 0)
        else
            Filters:ApplyDamageInstances(victim, attacker, damage, damage_type, DOTA_R_SLOT)
        end
        -- ApplyDamage({ victim = victim, attacker = attacker, damage = damage, damage_type = damage_type, ability = attacker:GetAbilityByIndex(DOTA_Q_SLOT) })
    end
    return damage
end

function Filters:IsTouchingGround(unit)
    --print(GetGroundHeight(unit:GetAbsOrigin(), unit) - unit:GetAbsOrigin().z)
    if GetGroundHeight(unit:GetAbsOrigin(), unit) - unit:GetAbsOrigin().z < -12 or Filters:HasFlyingModifier(unit) then
        return false
    else
        return true
    end
end

function Filters:HasFlyingModifier(unit)
    if unit:HasModifier("modifier_voltex_rune_e_3_heavens_charge_falling") or unit:HasModifier("modifier_z_flight") or unit:HasModifier("modifier_hawk_soar_visual_z") or unit:HasModifier("modifier_shapeshift_crow") or unit:HasModifier("modifier_dinath_postflight_zheight") or unit:HasModifier("modifier_thunder_blossom_teleporting") or unit:HasModifier("modifier_jex_lightning_lightning_e_movement") then
        return true
    else
        return false
    end
end

function Filters:ApplyQdamage(victim, attacker, damage, damage_type)
    if attacker:HasModifier("modifier_body_violet_guard2") then
        Filters:VioletGuard2Hit(victim, attacker, damage)
    end
    Filters:ApplyDamageInstances(victim, attacker, damage, damage_type, 0)
end

function Filters:ApplyWdamage(victim, attacker, damage, damage_type)
    Filters:ApplyDamageInstances(victim, attacker, damage, damage_type, 1)
end

function Filters:ApplyEdamage(victim, attacker, damage, damage_type)
    Filters:ApplyDamageInstances(victim, attacker, damage, damage_type, 2)
end

function Filters:ApplyRdamage(victim, attacker, damage, damage_type)
    Filters:ApplyDamageInstances(victim, attacker, damage, damage_type, DOTA_R_SLOT)
end

function Filters:ApplyDamageInstances(victim, attacker, damage, damage_type, slot)
    local ability = nil
    local damageData = attacker._damage_data or {}

    if type(slot) == "number" and slot ~= -1 then
        ability = attacker:GetAbilityByIndex(slot)
    elseif damageData.source then
        ability = damageData.source
    else
        ability = slot
    end
    local instances = 1
    if attacker:HasModifier("modifier_heavy_echo_gauntlet") then
        instances = instances + HEAVY_ECHO_REPEATS
    end
    if attacker:HasModifier("shadow_deity_passive") then
        local e_2_level = attacker:GetRuneValue("e", 2)
        if e_2_level > 0 then
            local procs = Runes:Procs(e_2_level, CONJUROR_ARCANA_E2_SHADOW_DAMAGE_INSTANCES, 1)
            instances = instances + procs
        end
    end

    if damageData.skipItemDamageEffectsApply then
        instances = 1
    end

    if slot == BASE_NONE then
        instances = 1
    end

    ------------------------------------------------------------------------------------------------------
    -- below is ApplyDamage (aka actual damage applying), do instances calculation before the Maginot Line
    if attacker:HasModifier("modifier_magistrates_hood") then
        if damage_type == DAMAGE_TYPE_MAGICAL or damage_type == DAMAGE_TYPE_PURE then
            local stacks = attacker:GetModifierStackCount("modifier_magistrates_hood_charges", attacker.InventoryUnit)
            if stacks > 0 then
                -- print("modifier_magistrates_hood stacks "..tostring(stacks))
                local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), victim:GetAbsOrigin(), nil, MAGISTRATE_HOOD_AOE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
                local magistrate_damage = damage*(1 + ((MAGISTRATE_HOOD_DAMAGE_AMP_PCT*0.01*#enemies)))
                for v=1,#enemies do
                    for i = 1, instances do
                        ApplyDamage({victim = enemies[v], attacker = attacker, damage = magistrate_damage, damage_type = damage_type, ability = ability, damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR})
                    end
                end
                local new_stacks = math.max(stacks - 1, 0)
                if new_stacks == 0 then
                    attacker:RemoveModifierByName("modifier_magistrates_hood_charges")
                else
                    attacker:SetModifierStackCount("modifier_magistrates_hood_charges", attacker.InventoryUnit, new_stacks)
                end
            end
        end
        -- print("damage_type "..tostring(damage_type))
    end
    for i = 1, instances do
        ApplyDamage({victim = victim, attacker = attacker, damage = damage, damage_type = damage_type, ability = ability, damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR})
    end
end

function Filters:ElementalDamage(victim, attacker, damage, damage_type, slot, element1, element2, bIsRealDamage)
    local unitName = attacker:GetUnitName()
    local mult = 1
    local divisor = 1
    local damageData = attacker._damage_data or {}

    if bIsRealDamage then
        if attacker:HasModifier("modifier_depth_demon_claw") then
            element2 = RPC_ELEMENT_DEMON
        end
    end
    if unitName == "npc_dota_hero_faceless_void" then
        require('heroes/faceless_void/omni_mace')
        mult = mult + omniro_elemental_bonus(element1, element2, attacker)
    end
    if element1 > 1 or element2 > 1 then
        if attacker:HasModifier("modifier_neutral_glyph_2_3") then
            mult = mult + 3
        end
        if attacker:HasModifier("modifier_enchanted_solar_cape_effect") then
            mult = mult + SOLAR_CAPE_BAD_AND_ELEMENTAL_AMP/100
        end
        if attacker:HasModifier("modifier_demonfire_stack") then
            local stacks = attacker:GetModifierStackCount("modifier_demonfire_stack", attacker.InventoryUnit)
            mult = mult + stacks * DEMONFIRE_ELEMENTAL_AMP_PCT/100
        end
        if bIsRealDamage then
            if attacker:HasModifier("modifier_ice_avatar") then
                element1 = RPC_ELEMENT_ICE
                element2 = RPC_ELEMENT_NONE
            end
            if attacker:HasModifier("modifier_fire_avatar") then
                element1 = RPC_ELEMENT_FIRE
                element2 = RPC_ELEMENT_NONE
            end
            if attacker:HasModifier("modifier_fire_avatar") and attacker:HasModifier("modifier_ice_avatar") then
                element1 = RPC_ELEMENT_ICE
                element2 = RPC_ELEMENT_FIRE
            end
        end
        if victim:HasModifier("modifier_elemental_resistance") then
            damage = damage * 0.01
        end
        if attacker:HasModifier("modifier_helm_all_elements") then
            local stacks = attacker:GetModifierStackCount("modifier_helm_all_elements", attacker.InventoryUnit)
            mult = mult + stacks / 100
        end
        if attacker:HasModifier("modifier_hand_all_elements") then
            local stacks = attacker:GetModifierStackCount("modifier_hand_all_elements", attacker.InventoryUnit)
            mult = mult + stacks / 100
        end
        if attacker:HasModifier("modifier_trinket_all_elements") then
            local stacks = attacker:GetModifierStackCount("modifier_trinket_all_elements", attacker.InventoryUnit)
            mult = mult + stacks / 100
        end
        if attacker:HasAbility("arkimus_archon_form") then
            local r_3_level = attacker:GetRuneValue("r", 3)
            if r_3_level > 0 then
                mult = mult + ARKIMUS_ARCANA_R_R3_ELEMENTS_PCT * r_3_level
            end
        end
        if attacker:HasModifier("modifier_omniro_dragon_buff") then
            mult = mult + 8
        end
        if attacker:HasModifier("shadow_deity_passive") then
            if bIsRealDamage and slot ~= 0 then
                if element1 == RPC_ELEMENT_NORMAL or element1 == RPC_ELEMENT_NONE then
                    element1 = RPC_ELEMENT_SHADOW
                end
                if (element2 == RPC_ELEMENT_NORMAL or element2 == RPC_ELEMENT_NONE) and element1 ~= RPC_ELEMENT_SHADOW then
                    element2 = RPC_ELEMENT_SHADOW
                end
            end
        end
    end
    if element1 == RPC_ELEMENT_NORMAL then
        if bIsRealDamage then
            if attacker:HasModifier("modifier_djanghor_glyph_5_a") then
                element2 = RPC_ELEMENT_NATURE
            end
        end
    end

    local elements = {}
    if element1 ~= RPC_ELEMENT_NONE then
        table.insert(elements, element1)
    end
    if element2 ~= RPC_ELEMENT_NONE then
        table.insert(elements, element2)
    end

    local newDamageCalculatorData = {
        victim = victim,
        attacker = attacker,
        damage = damage,
        damageType = damage_type,
        sourceType = slot,
        source = 'none', -- TODO get real source,
        isFake = not bIsRealDamage,
        ignoreSteadfast = attacker.ignore_steadfast or false,
        elements = elements,
    }


    local attackerBuffs, attackerDebuffs = Util.Creature:GetBuffsAndDebuffs(attacker, npc_base_modifier)
    local victimBuffs, victimDebuffs = Util.Creature:GetBuffsAndDebuffs(victim, npc_base_modifier)

    newDamageCalculatorData.damage = damage
    local localMult = 0
    localMult = Damage:GetWithElement('Amplify', attackerBuffs, victimDebuffs, newDamageCalculatorData)/damage
    newDamageCalculatorData.damage = damage * localMult

    divisor = damage * localMult/Damage:GetWithElement('Reduce', attackerDebuffs, victimBuffs, newDamageCalculatorData)
    newDamageCalculatorData.damage = damage

    mult = mult + localMult - 1

    mult = mult + heroes.venomort.getElementBonus(victim, attacker, damage, damage_type, slot, element1, element2, bIsRealDamage)



    if element2 == RPC_ELEMENT_NORMAL then
        if bIsRealDamage then
            if attacker:HasModifier("modifier_djanghor_glyph_5_a") then
                element1 = RPC_ELEMENT_NATURE
            end
        end
    end
    if element1 == RPC_ELEMENT_NORMAL or element2 == RPC_ELEMENT_NORMAL then
        local normalMult = 0
        if attacker:HasModifier("modifier_neutral_glyph_6_2") then
            normalMult = normalMult + 0.5
        end
        if attacker:HasModifier("modifier_trapper_arcana1") then
            local w_2_level = attacker:GetRuneValue("w", 2)
            normalMult = normalMult + w_2_level * TRAPPER_ARCANA_W_W2_NORMAL_PCT
        end
        if attacker:HasModifier('modifier_trapper_glyph_6_1') then
            normalMult = normalMult * TRAPPER_GLYPH_6_1_NORMAL_AMP
        end
        normalMult = normalMult + (CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_head_element_nature", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_weapon_element_nature", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_hands_element_nature", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_feet_element_nature", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_body_element_nature", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_amulet_element_nature", 1))/100
        mult = mult + normalMult
    end
    if element1 == RPC_ELEMENT_FIRE or element2 == RPC_ELEMENT_FIRE then
        local fireMult = 0
        if attacker:HasModifier("modifier_dinath_glyph_6_1") then
            fireMult = fireMult + DINATH_GLYPH_6_1_FIRE_ICE_LIGHTING_COSMIC_AMP/100
        end
        if unitName == "npc_dota_hero_dragon_knight" then
            if attacker.r_4_level then
                fireMult = fireMult + attacker.r_4_level*(FLAMEWAKER_R4_FIRE_DAMAGE_AMP/100)
            end
            if attacker:HasModifier("modifier_flamewaker_arcana2_passive") then
                if victim:IsStunned() or victim:IsFakeStunned() then
                    local w_1_level = attacker:GetRuneValue("w", 1)
                    if w_1_level > 0 then
                        fireMult = fireMult + (FLAMEWAKER_ARCANA2_Q1_FIRE_AMP_AGAINST_STUNNED/100) * w_1_level
                    end
                end
            end
        end
        if unitName == "npc_dota_hero_crystal_maiden" then
            if attacker.r_4_level and not attacker:HasModifier("modifier_sorceress_arcana1") then
                fireMult = fireMult + SORCERESS_R4_FIRE_AMP * attacker.r_4_level
            end
            if attacker:HasModifier("modifier_fire_avatar") then
                local stacks = attacker:GetModifierStackCount("modifier_fire_avatar", attacker)
                fireMult = fireMult + stacks * (SORCERESS_ARCANA2_Q4_FIRE_AMP/100)
            end
        end
        if attacker:HasModifier("modifier_flametongue") then
            local flametongue = attacker:FindModifierByName("modifier_flametongue"):GetAbility()
            fireMult = fireMult + flametongue:GetLevelSpecialValueFor("fire_damage_amp", flametongue:GetLevel()) / 100
        end
        if victim:HasModifier("modifier_sorceress_rune_r_3") then
            local runesCount = victim:GetModifierStackCount("modifier_sorceress_rune_r_3", attacker)
            if attacker:HasModifier("modifier_sorceress_glyph_6_2") then
                runesCount = runesCount * SORCERESS_GLYPH_6_2_R3_MULT
            end
            fireMult = fireMult + 0.1 * runesCount
        end
        if unitName == "npc_dota_hero_huskar" then
            if attacker.q_4_level then
                fireMult = fireMult + SPIRIT_WARRIOR_Q4_FIRE_AND_WIND_AMP * attacker.q_4_level
            end
            if attacker:HasModifier("modifier_spirit_warrior_arcana2") then
                local w_4_level = attacker:GetRuneValue("w", 4)
                fireMult = fireMult + SPIRIT_WARRIOR_ARCANA_W4_FIRE_AMP * w_4_level
            end
        elseif unitName == "npc_dota_hero_beastmaster" then
            if attacker:HasModifier("modifier_warlord_fire_charge") then
                local stacks = attacker:GetModifierStackCount("modifier_warlord_fire_charge", attacker)
                fireMult = fireMult + stacks * (WARLORD_FIRE_CHARGE_ELEMENT_BONUS_PCT/100)
            end
            if attacker.e_4_level then
                fireMult = fireMult + WARLORD_E4_ICE_EARTH_FIRE_BONUS * attacker.e_4_level
            end
        elseif unitName == "npc_dota_hero_templar_assassin" then
            if attacker:HasModifier("modifier_trapper_arcana1") then
                local w_4_level = attacker:GetRuneValue("w", 4)
                fireMult = fireMult + TRAPPER_ARCANA_W_W4_ELEMENTAL_AMP * w_4_level
            end
        elseif unitName == "npc_dota_hero_invoker" then
            if attacker.q_4_level then
                fireMult = fireMult + CONJUROR_Q4_EARTH_AND_FIRE_AMP * attacker.q_4_level
            end
            if victim:HasModifier("modifier_conjuror_w_4_burn") then
                if attacker:HasAbility("summon_fire_aspect") then
                    if attacker.w_4_level then
                        fireMult = fireMult + attacker.w_4_level * (CONJUROR_W4_AMP_ON_FIRE / 100)
                    end
                end
            end
            if attacker:HasModifier("modifier_conjuror_arcana2") then
                local w_2_level = attacker:GetRuneValue("w", 2)
                if w_2_level > 0 then
                    fireMult = fireMult + (CONJUROR_ARCANA_W2_FLAT_FIRE_AMP / 100) * w_2_level
                end
            end
        elseif unitName == "npc_dota_hero_legion_commander" then
            if attacker:HasAbility("mountain_protector_aeon_fracture") then
                if attacker.r_4_level then
                    fireMult = fireMult + MOUNTAIN_PROTECTOR_R4_EARTH_FIRE_AMP * attacker.r_4_level
                end
            end
        elseif unitName == "npc_dota_hero_axe" then
            -- if attacker:HasModifier("modifier_axe_arcana_passive") then
            --     local ratio = attacker:GetHealth()/attacker:GetMaxHealth()
            --     local c_d_level = attacker:GetRuneValue("r", 3)
            --     local multIncrease = ratio * 0.5 * c_d_level
            --     mult = mult + multIncrease
            -- end
        elseif unitName == "npc_dota_hero_vengefulspirit" then
            if attacker:HasModifier("modifier_solunia_arcana2") then
                local d_d_level = attacker:GetRuneValue("r", 4)
                fireMult = fireMult + SOLUNIA_ARCANA_R4_ELEM_AMP_PCT * d_d_level
            end
        end
        if victim:HasModifier("fire_walker_aura") then
            fireMult = fireMult + 6
        end
        if unitName == "npc_dota_hero_arc_warden" then
            if attacker:HasModifier("modifier_jex_arcana1") then
                if attacker.w_2_level then
                    fireMult = fireMult + attacker.w_2_level * JEX_RUNE_ROW_2_VALUE
                end
            end
        end
        fireMult = fireMult + (CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_head_element_fire", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_weapon_element_fire", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_hands_element_fire", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_feet_element_fire", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_body_element_fire", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_amulet_element_fire", 1))/100
        if fireMult > FIRE_DEITY_CROWN_ELEMENT_CAP/100 and attacker:HasModifier("modifier_fire_deity_crown") then
            fireMult = FIRE_DEITY_CROWN_ELEMENT_CAP/100
        end

        mult = mult + fireMult
    end
    if element1 == RPC_ELEMENT_EARTH or element2 == RPC_ELEMENT_EARTH then
        if unitName == "npc_dota_hero_dragon_knight" then
            if attacker.r_4_level then
                mult = mult + (attacker.r_4_level*FLAMEWAKER_R4_FIRE_DAMAGE_AMP/100)
            end
        elseif unitName == "npc_dota_hero_beastmaster" then
            if attacker:HasModifier("modifier_warlord_earth_charge") then
                local stacks = attacker:GetModifierStackCount("modifier_warlord_earth_charge", attacker)
                mult = mult + stacks * (WARLORD_EARTH_CHARGE_ELEMENT_BONUS_PCT/100)
            end
            if attacker.e_4_level then
                mult = mult + WARLORD_E4_ICE_EARTH_FIRE_BONUS * attacker.e_4_level
            end
        elseif unitName == "npc_dota_hero_invoker" then
            if attacker.q_4_level and attacker:HasAbility("summon_earth_aspect") then
                mult = mult + CONJUROR_Q4_EARTH_AND_FIRE_AMP * attacker.q_4_level
            end
        elseif unitName == "npc_dota_hero_legion_commander" then
            if attacker:HasAbility("mountain_protector_aeon_fracture") then
                if attacker.r_4_level then
                    mult = mult + MOUNTAIN_PROTECTOR_R4_EARTH_FIRE_AMP * attacker.r_4_level
                end
            elseif attacker:HasAbility("mountain_protector_hailstorm") then
                if attacker.r_4_level then
                    mult = mult + MOUNTAIN_PROTECTOR_ARCANA2_R4_ICE_EARTH * attacker.r_4_level
                end
            end
        end
        mult = mult + (CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_head_element_earth", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_weapon_element_earth", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_hands_element_earth", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_feet_element_earth", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_body_element_earth", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_amulet_element_earth", 1))/100
    end
    if element1 == RPC_ELEMENT_LIGHTNING or element2 == RPC_ELEMENT_LIGHTNING then
        if attacker:HasModifier("modifier_dinath_glyph_6_1") then
            mult = mult + DINATH_GLYPH_6_1_FIRE_ICE_LIGHTING_COSMIC_AMP/100
        end
        if unitName == "npc_dota_hero_phantom_assassin" then
            if attacker:HasAbility("voltex_azure_leap") or attacker:HasAbility("voltex_rune_e_3_heavens_charge") then
                local e_4_level = attacker:GetRuneValue("e", 4)
                mult = mult + e_4_level * (VOLTEX_E4_LIGHTNING_AMP/100)
            elseif attacker:HasAbility("voltex_lightning_dash") then
                local e_4_level = attacker:GetRuneValue("e", 4)
                mult = mult + e_4_level * (VOLTEX_ARCANA_E4_LIGHTNING_AMP/100)
            end
        elseif unitName == "npc_dota_hero_antimage" then
            if attacker:HasModifier("modifier_arkimus_glyph_7_1") then
                mult = mult + ARKIMUS_GLYPH_7_1_LIGHTNING_AMP/100
            end
            if attacker:HasModifier("modifier_arkimus_arcana1_q4") then
                local stacks = attacker:GetModifierStackCount("modifier_arkimus_arcana1_q4", attacker)
                mult = mult + ARKIMUS_ARCANA1_Q4_LIGHTNING_AMP /100 * stacks
            end
        end
        if unitName == "npc_dota_hero_arc_warden" then
            if not attacker:HasModifier("modifier_jex_arcana1") then
                if attacker.w_2_level then
                    mult = mult + attacker.w_2_level * JEX_RUNE_ROW_2_VALUE
                end
            end
        end
        mult = mult + (CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_head_element_lightning", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_weapon_element_lightning", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_hands_element_lightning", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_feet_element_lightning", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_body_element_lightning", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_amulet_element_lightning", 1))/100
    end
    if element1 == RPC_ELEMENT_POISON or element2 == RPC_ELEMENT_POISON then
        if unitName == "npc_dota_hero_templar_assassin" then
            if attacker:HasModifier("modifier_trapper_arcana1") then
                local w_4_level = attacker:GetRuneValue("w", 4)
                mult = mult + TRAPPER_ARCANA_W_W4_ELEMENTAL_AMP * w_4_level
            end
        end
        mult = mult + (CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_head_element_poison", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_weapon_element_poison", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_hands_element_poison", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_feet_element_poison", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_body_element_poison", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_amulet_element_poison", 1))/100
    end
    if element1 == RPC_ELEMENT_TIME or element2 == RPC_ELEMENT_TIME then
        if unitName == "npc_dota_hero_dark_seer" then
            if attacker:HasModifier("modifier_zonik_glyph_7_1") and attacker:HasModifier("modifier_temporal_discharge") then
                local stacks = attacker:GetModifierStackCount("modifier_temporal_discharge", attacker)
                mult = mult + stacks * ZHONIK_GLYPH_7_1_ELEMENT_TEMPORAL / 100
            end
			if attacker:HasAbility("zonik_lightspeed") then
                local e_4_level = attacker:GetRuneValue("e", 4)
                mult = mult + ZHONIK_E4_TEMPORAL_AMP_PCT/100 * e_4_level
			elseif attacker:HasAbility("zhonik_temporal_field") then
                local e_4_level = attacker:GetRuneValue("e", 4)
                mult = mult + ZHONIK_E4_ARCANA_TEMPORAL_AMP_PCT / 100 * e_4_level
            end
        elseif unitName == "npc_dota_hero_obsidian_destroyer" then
            ----print("OD HERE")
            local d_d_level = attacker:GetRuneValue("r", 4)
            if d_d_level > 0 then
                ----print("OD HERE2 r4: "..r_4_level)
                mult = mult + d_d_level * EPOCH_R4_TIME_AMP
            end
        end
        mult = mult + (CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_head_element_time", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_weapon_element_time", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_hands_element_time", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_feet_element_time", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_body_element_time", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_amulet_element_time", 1))/100
    end
    if element1 == RPC_ELEMENT_HOLY or element2 == RPC_ELEMENT_HOLY then
        if unitName == "npc_dota_hero_omniknight" then
            if attacker:HasAbility("heroic_fury") then
                local q_4_level = attacker:GetRuneValue("q", 4)
                mult = mult + PALADIN_Q4_HOLY_AMP*q_4_level
            end
            if attacker:HasAbility("paladin_crusader_comet") then
                local e_4_level = attacker:GetRuneValue("e", 4)
                mult = mult + e_4_level*PALADIN_ARCANA2_E4_HOLY_AMP_PER_SPIRIT*attacker:GetSpirit()
            end
        elseif unitName == "npc_dota_hero_leshrac" then
            if attacker.e_4_level then
                mult = mult + BAHAMUT_E4_HOLY_AMP/100 * attacker.e_4_level
            end
        elseif unitName == "npc_dota_hero_zuus" then
            if attacker:HasModifier("modifier_holy_wrath_passive") then
                local q_3_level = attacker:GetRuneValue("q", 3)
                if q_3_level then
                    mult = mult + AURIUN_ARCANA_1_Q3_HOLY_AMP * q_3_level
                end
            end
            local w_2_level = attacker:GetRuneValue("w", 2)
            if w_2_level > 0 then
                mult = mult + AURIUN_W2_HEAL_SHADOW_HOLY_AMP * w_2_level
            end
        elseif unitName == "npc_dota_hero_skywrath_mage" then
            if attacker:HasModifier("modifier_lightbomb_freecast") then
                local stacks = attacker:GetModifierStackCount("modifier_lightbomb_freecast", caster)
                local q_3_level = attacker:GetRuneValue("q", 3)
                mult = mult + stacks * SEPHYR_Q3_HOLY_AMP_PCT/100 * q_3_level
            end
        elseif unitName == "npc_dota_hero_juggernaut" then
            if attacker:HasAbility("seinaru_odachi_leap") then
                if attacker.e_4_level and attacker.e_4_level > 0 then
                    local multIncrease = attacker.e_4_level * SEINARU_E4_HOLY_AMP
                    mult = mult + multIncrease
                end
            else
                if attacker.e_4_level and attacker.e_4_level > 0 then
                    local multIncrease = attacker.e_4_level * SEINARU_ARCANA2_E4_HOLY_AMP
                    mult = mult + multIncrease
                end
            end
        end
        if attacker:HasModifier("modifier_gilded_soul_buff") then
            local stacks = attacker:GetModifierStackCount("modifier_gilded_soul_buff", attacker.InventoryUnit)
            mult = mult + stacks * GILDED_SOUL_CAGE_ELEMENT_HOLY_AMP/100
        end

        if attacker:HasModifier("modifier_sunstrider_holy_amplify") then
            local stacks = attacker:GetModifierStackCount("modifier_sunstrider_holy_amplify", attacker)
            mult = mult + stacks * SEINARU_ARCANA_E4_HOLY_PCT
        end
        mult = mult + (CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_head_element_holy", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_weapon_element_holy", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_hands_element_holy", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_feet_element_holy", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_body_element_holy", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_amulet_element_holy", 1))/100
    end
    if element1 == RPC_ELEMENT_COSMOS or element2 == RPC_ELEMENT_COSMOS then
        local cosmosMult = 0
        if attacker:HasModifier("modifier_dinath_glyph_6_1") then
            cosmosMult = cosmosMult + DINATH_GLYPH_6_1_FIRE_ICE_LIGHTING_COSMIC_AMP/100
        end
        if unitName == "npc_dota_hero_drow_ranger" then
            if attacker:HasAbility("star_blink") then
                cosmosMult = cosmosMult + (ASTRAL_RANGER_E4_COSMIC_AMP/100)*attacker:GetRuneValue("e", 4)
            end
            -- if victim:HasModifier("modifier_apollo_c_b_proc_invisible") then
            --     cosmosMult = cosmosMult + 0.01 * victim:GetModifierStackCount("modifier_apollo_c_b_proc_invisible", attacker)
            -- end
        end
        if unitName == "npc_dota_hero_vengefulspirit" then
            local q_4_level = attacker:GetRuneValue("q", 4)
            local d_a_mult = SOLUNIA_Q4_COSMIC_AMP_PCT
            if attacker:HasModifier("modifier_solunia_arcana1") then
                d_a_mult = SOLUNIA_ARCANA_Q4_COSMIC_AMP_PCT
            end
            cosmosMult = cosmosMult + d_a_mult * q_4_level
            if attacker:HasModifier("modifier_solunia_arcana2") then
                local d_d_level = attacker:GetRuneValue("r", 4)
                cosmosMult = cosmosMult + SOLUNIA_ARCANA_R4_ELEM_AMP_PCT * d_d_level
            end
        end
        if attacker:GetUnitName() == "npc_dota_hero_arc_warden" then
            if attacker.e_2_level then
                cosmosMult = cosmosMult + attacker.e_2_level * JEX_RUNE_ROW_2_VALUE
            end
            if attacker:HasModifier("modifier_jex_cosmic_surge") then
                local e_4_level = attacker:GetRuneValue("e", 4)
                cosmosMult = cosmosMult + e_4_level * JEX_COSMIC_SURGE_E4_COSMIC_AMP
            end
        end
        cosmosMult = cosmosMult + (CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_head_element_cosmic", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_weapon_element_cosmic", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_hands_element_cosmic", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_feet_element_cosmic", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_body_element_cosmic", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_amulet_element_cosmic", 1))/100
        if cosmosMult > LUMA_ELEMENT_CAP/100 and attacker:HasModifier("modifier_luma_guard") then
            cosmosMult = LUMA_ELEMENT_CAP/100
        end

        mult = mult + cosmosMult
    end
    if element1 == RPC_ELEMENT_ICE or element2 == RPC_ELEMENT_ICE then
        if attacker:HasModifier("modifier_dinath_glyph_6_1") then
            mult = mult + DINATH_GLYPH_6_1_FIRE_ICE_LIGHTING_COSMIC_AMP/100
        end
        if unitName == "npc_dota_hero_crystal_maiden" then
            if attacker:HasAbility("blizzard") then
                local q_4_level = attacker:GetRuneValue("q", 4)
                mult = mult + (SORCERESS_Q4_ICE_AMP/100)*q_4_level
            end
            if attacker:HasModifier("modifier_ice_avatar") then
                local stacks = attacker:GetModifierStackCount("modifier_ice_avatar", attacker)
                mult = mult + stacks * 0.1
            end
            if victim:HasModifier("modifier_blizzard_ice_resist_loss") then
                local stacks = victim:GetModifierStackCount("modifier_blizzard_ice_resist_loss", attacker)
                mult = mult + stacks * 0.1
            end
        elseif unitName == "npc_dota_hero_beastmaster" then
            if attacker:HasModifier("modifier_warlord_ice_charge") then
                local stacks = attacker:GetModifierStackCount("modifier_warlord_ice_charge", attacker)
                mult = mult + stacks * (WARLORD_ICE_CHARGE_ELEMENT_BONUS_PCT/100)
            end
            if attacker.e_4_level then
                mult = mult + WARLORD_E4_ICE_EARTH_FIRE_BONUS * attacker.e_4_level
            end
        elseif unitName == "npc_dota_hero_legion_commander" then
            if attacker:HasAbility("mountain_protector_hailstorm") then
                if attacker.r_4_level then
                    mult = mult + MOUNTAIN_PROTECTOR_ARCANA2_R4_ICE_EARTH * attacker.r_4_level
                end
            end
        elseif unitName == "npc_dota_hero_vengefulspirit" then
            if attacker:HasModifier("modifier_solunia_arcana2") then
                local d_d_level = attacker:GetRuneValue("r", 4)
                mult = mult + SOLUNIA_ARCANA_R4_ELEM_AMP_PCT * d_d_level
            end
        end

        if victim:HasModifier("modifier_tornado_ice_resist_loss_invisible") then
            local modifier = victim:FindModifierByName("modifier_tornado_ice_resist_loss_invisible")
            local iceCaster = modifier:GetCaster()
            local stacks = victim:GetModifierStackCount("modifier_tornado_ice_resist_loss_invisible", iceCaster)
			if attacker:HasModifier("modifier_sorceress_glyph_6_2") then
                stacks = stacks * SORCERESS_GLYPH_6_2_R3_MULT
            end
            mult = mult + stacks * SORCERESS_ARCANA1_R3_ICE_RESIST_LOSS
        end
        mult = mult + (CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_head_element_ice", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_weapon_element_ice", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_hands_element_ice", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_feet_element_ice", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_body_element_ice", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_amulet_element_ice", 1))/100
    end
    if element1 == RPC_ELEMENT_ARCANE or element2 == RPC_ELEMENT_ARCANE then

        if victim:HasModifier("modifier_storm_weapon_b_b_invisible") then
            local modifier = victim:FindModifierByName("modifier_storm_weapon_b_b_invisible")
            local multIncrease = modifier:GetStackCount() * ARKIMUS_W2_ARCANE_BONUS_PER_STACK_PCT/100
            mult = mult + multIncrease
        end
        if unitName == "npc_dota_hero_antimage" then
            if attacker:HasAbility("arkimus_energy_field") then
                local d_d_level = attacker:GetRuneValue("r", 4)
                mult = mult + ARKIMUS_R4_ARCANE_AMP/100 * d_d_level
            end
            if attacker:HasModifier("modifier_arkimus_immortal_weapon_2") then
                if bIsRealDamage then
                    local healAmount = damage * mult * ARKIMUS_IMMORTAL_WEAPON_2_HEALING_PER_ARCANE_DMG
                    if healAmount > 0 then
                        Filters:ApplyHeal(attacker, attacker, healAmount, true)
                        local particleName = "particles/roshpit/arkimus/arkimus_immo_2_lifesteal.vpcf"
                        local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, attacker)
                        ParticleManager:SetParticleControlEnt(pfx, 0, attacker, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin(), true)
                        Timers:CreateTimer(0.2, function()
                            ParticleManager:DestroyParticle(pfx, false)
                        end)
                    end
                end
            end
        end
        mult = mult + (CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_head_element_arcane", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_weapon_element_arcane", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_hands_element_arcane", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_feet_element_arcane", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_body_element_arcane", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_amulet_element_arcane", 1))/100
    end
    if element1 == RPC_ELEMENT_SHADOW or element2 == RPC_ELEMENT_SHADOW then
        if unitName == "npc_dota_hero_zuus" then
            if attacker:HasModifier("modifier_shadow_trap_passive") then
                local q_3_level = attacker:GetRuneValue("q", 3)
                if q_3_level then
                    mult = mult + AURIUN_ARCANA_2_Q3_SHADOW_AMP * q_3_level
                end
            end
            local w_2_level = attacker:GetRuneValue("w", 2)
            if w_2_level > 0 then
                mult = mult + AURIUN_W2_HEAL_SHADOW_HOLY_AMP * w_2_level
            end
        elseif unitName == "npc_dota_hero_slark" then
            attacker.q_4_level = attacker:GetRuneValue("q", 4)
            if attacker.q_4_level then
                mult = mult + SLIPFINN_Q4_SHADOW_WATER_AMP * attacker.q_4_level
            end
        elseif unitName == "npc_dota_hero_invoker" then
            if attacker:HasAbility("summon_shadow_deity") then
                local e_3_level = attacker:GetRuneValue("e", 3)
                if e_3_level > 0 then
                    mult = mult + (CONJUROR_ARCANA_E3_SHADOW_AMP / 100)* e_3_level
                end
            end
        end
        if attacker:HasModifier("modifier_nightmare_rider_stacks") then
            local stacks = attacker:GetModifierStackCount("modifier_nightmare_rider_stacks", attacker.InventoryUnit)
            mult = mult + (stacks * NIGHTMARE_RIDER_ELEMENT_SHADOW_INCREASE) / 100
        end
        mult = mult + (CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_head_element_shadow", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_weapon_element_shadow", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_hands_element_shadow", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_feet_element_shadow", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_body_element_shadow", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_amulet_element_shadow", 1))/100
    end
    if element1 == RPC_ELEMENT_WIND or element2 == RPC_ELEMENT_WIND then
        if unitName == "npc_dota_hero_huskar" then
            local e_4_level = attacker:GetRuneValue("e", 4)
            if attacker:HasModifier("modifier_spirit_warrior_arcana3") then
                if e_4_level > 0 then
                    mult = mult + SPIRIT_WARRIOR_ARCANA_E4_WIND_AMP * e_4_level
                end
            end
            local q_4_level = attacker:GetRuneValue("q", 4)
            mult = mult + SPIRIT_WARRIOR_Q4_FIRE_AND_WIND_AMP * q_4_level
        elseif unitName == "npc_dota_hero_juggernaut" then
            if attacker.w_4_level then
                if attacker:HasModifier('modifier_seinaru_glyph_7_1') then
                    mult = mult + SEINARU_W4_WIND_PCT_PER_AGI * (SEINARU_GLYPH7_AGI_PART * attacker:GetAgility() + SEINARU_GLYPH7_STR_PART * attacker:GetStrength()) * attacker.w_4_level
                else
                    mult = mult + SEINARU_W4_WIND_AMP * attacker.w_4_level
                end
            end
        elseif unitName == "npc_dota_hero_skywrath_mage" then
            if attacker:HasModifier("modifier_sephyr_arcana1") then
                local w_4_level = attacker:GetRuneValue("w", 4)
                if w_4_level > 0 then
                    mult = mult + SEPHYR_ARCANA_W4_WIND_AMP_PCT/100 * w_4_level
                end
            else
                local w_4_level = attacker:GetRuneValue("w", 4)
                if w_4_level > 0 then
                    mult = mult + SEPHYR_W4_WIND_AMP_PCT/100 * w_4_level
                end
            end
        end
        mult = mult + (CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_head_element_wind", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_weapon_element_wind", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_hands_element_wind", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_feet_element_wind", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_body_element_wind", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_amulet_element_wind", 1))/100
    end
    if element1 == RPC_ELEMENT_GHOST or element2 == RPC_ELEMENT_GHOST then
        if attacker:GetUnitName() == "npc_dota_hero_spirit_breaker" then
            local r_4_level = attacker:GetRuneValue("r", 4)
            mult = mult + DUSKBRINGER_R4_GHOST_AMP * r_4_level
        end
        if attacker:HasModifier("modifier_hand_ghost") then
            local stacks = attacker:GetModifierStackCount("modifier_hand_ghost", attacker.InventoryUnit)
            mult = mult + stacks / 100
        end
        if attacker:HasModifier("modifier_weapon_ghost") then
            local stacks = attacker:GetModifierStackCount("modifier_weapon_ghost", attacker.InventoryUnit)
            mult = mult + stacks / 100
        end
        mult = mult + (CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_head_element_ghost", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_weapon_element_ghost", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_hands_element_ghost", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_feet_element_ghost", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_body_element_ghost", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_amulet_element_ghost", 1))/100
    end
    if element1 == RPC_ELEMENT_WATER or element2 == RPC_ELEMENT_WATER then
        local waterMult = 0
        if unitName == "npc_dota_hero_slardar" then
            if attacker.e_4_level then
                waterMult = waterMult + HYDROXIS_E4_WATER_AMP * attacker.e_4_level
            end
            if attacker:HasAbility("hydroxis_arcana_ability_1") then
                if bIsRealDamage then
                    local w_4_level = attacker:GetRuneValue("w", 4)
                    if w_4_level > 0 then
                        local duration = HYDROXIS_ARCANA_W4_MIST_DURATION_BASE + w_4_level * HYDROXIS_ARCANA_W4_MIST_DURATION
                        local mist_mod = victim:FindModifierByName("modifier_hydroxis_mist_debuff_timered")
                        if mist_mod then
                            duration = math.max(duration, mist_mod:GetRemainingTime())
                        end
                        local mistAbility = attacker:FindAbilityByName("hydroxis_arcana_ability_1")
                        mistAbility:ApplyDataDrivenModifier(attacker, victim, "modifier_hydroxis_mist_debuff_timered", {duration = duration})

                    end
                end
            end
        elseif unitName == "npc_dota_hero_templar_assassin" then
            if attacker:HasModifier("modifier_trapper_arcana1") then
                local w_4_level = attacker:GetRuneValue("w", 4)
                waterMult = waterMult + TRAPPER_ARCANA_W_W4_ELEMENTAL_AMP * w_4_level
            end
        elseif unitName == "npc_dota_hero_huskar" then
            if attacker:HasModifier("modifier_spirit_warrior_arcana1") then
                local d_d_arcana_level = attacker:GetRuneValue("r", 4)
                if d_d_arcana_level > 0 then
                    waterMult = waterMult + SPIRIT_WARRIOR_ARCANA_R4_WATER_AMP * d_d_arcana_level
                end
            end
        elseif unitName == "npc_dota_hero_slark" then
            attacker.q_4_level = attacker:GetRuneValue("q", 4)
            if attacker.q_4_level then
				waterMult = waterMult + SLIPFINN_Q4_SHADOW_WATER_AMP * attacker.q_4_level
			end
        end
        if victim:HasModifier("modifier_flood_basin_enemy_inside_water_stacks") then
            local modifier = victim:FindModifierByName("modifier_flood_basin_enemy_inside_water_stacks")
            local multIncrease = modifier:GetStackCount() * HYDROXIS_ARCANA_R3_WATER_AMP_PCT/100
            waterMult = waterMult + multIncrease
        end
        waterMult = waterMult + (CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_head_element_water", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_weapon_element_water", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_hands_element_water", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_feet_element_water", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_body_element_water", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_amulet_element_water", 1))/100
        if waterMult > WATER_DEITY_CROWN_ELEMENT_CAP/100 and attacker:HasModifier("modifier_water_deity_crown") then
            waterMult = WATER_DEITY_CROWN_ELEMENT_CAP/100
        end

        mult = mult + waterMult
    end
    if element1 == RPC_ELEMENT_DEMON or element2 == RPC_ELEMENT_DEMON then
        mult = mult + (CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_head_element_demon", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_weapon_element_demon", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_hands_element_demon", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_feet_element_demon", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_body_element_demon", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_amulet_element_demon", 1))/100
    end
    if element1 == RPC_ELEMENT_NATURE or element2 == RPC_ELEMENT_NATURE then
        if unitName == "npc_dota_hero_monkey_king" then
            local w_4_level = attacker:GetRuneValue("w", 4)
            mult = mult + DJANGHOR_W4_NATURE_AMP * w_4_level
        end
        if unitName == "npc_dota_hero_arc_warden" then
            if attacker.q_2_level then
                mult = mult + attacker.q_2_level * JEX_RUNE_ROW_2_VALUE
            end
        end
        mult = mult + (CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_head_element_nature", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_weapon_element_nature", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_hands_element_nature", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_feet_element_nature", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_body_element_nature", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_amulet_element_nature", 1))/100
    end
    if element1 == RPC_ELEMENT_UNDEAD or element2 == RPC_ELEMENT_UNDEAD then

        if attacker:GetUnitName() == "npc_dota_hero_visage" then
            if attacker:HasAbility("ekkan_summon_skeleton") then
                local w_2_level = attacker:GetRuneValue("w", 2)
                local raise_skeletons = attacker:FindAbilityByName("ekkan_summon_skeleton")
                if raise_skeletons.skeleTable then
                    mult = mult + #raise_skeletons.skeleTable * w_2_level * EKKAN_W2_UNDEAD_AMP
                end
            end
        end
        mult = mult + (CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_head_element_undead", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_weapon_element_undead", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_hands_element_undead", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_feet_element_undead", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_body_element_undead", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_amulet_element_undead", 1))/100
    end
    if element1 == RPC_ELEMENT_DRAGON or element2 == RPC_ELEMENT_DRAGON then
        if unitName == "npc_dota_hero_winter_wyvern" then
            local d_d_level = attacker:GetRuneValue("r", 4)
            mult = mult + DINATH_R4_DRAGON_AMP/100 * d_d_level
            if bIsRealDamage then
                if attacker:HasModifier("modifier_dinath_immortal_weapon_3") then
                    Filters:TakeArgumentsAndApplyDamage(victim, attacker, damage, damage_type, slot, RPC_ELEMENT_COSMOS, RPC_ELEMENT_NONE)
                end
            end
        elseif unitName == "npc_dota_hero_beastmaster" and attacker:HasModifier("modifier_warlord_arcana2") then
            local q_4_level = attacker:GetRuneValue("q", 4)
            mult = mult + WARLORD_ARCANA2_Q4_DRAGON_AMP * q_4_level        
        end
        mult = mult + (CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_head_element_dragon", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_weapon_element_dragon", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_hands_element_dragon", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_feet_element_dragon", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_body_element_dragon", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_amulet_element_dragon", 1))/100
    end
    if bIsRealDamage and not damageData.ignoreMultipliers and not damageData.ignoreElements then
        Filters:PostElementalDamage(victim, attacker, damage * mult, damage_type, slot, element1, element2, bIsRealDamage)
    end
    if not damageData.ignoreMultipliers and not damageData.ignoreElements then
        damage = damage * mult/divisor
    end
    return damage, element1, element2
end

function Filters:PostElementalDamage(victim, attacker, damage, damage_type, slot, element1, element2, bIsRealDamage)
    if attacker:GetUnitName() == "npc_dota_hero_obsidian_destroyer" then
        if element1 == RPC_ELEMENT_TIME or element2 == RPC_ELEMENT_TIME then
            if attacker:HasAbility("epoch_time_binder") then
                local time_binder = attacker:FindAbilityByName("epoch_time_binder")
                local q_2_level = attacker:GetRuneValue("q", 2)
                if q_2_level > 0 then
                    local q_2_damage = damage * (EPOCH_Q2_DAMAGE_SHARE / 100)
                    if time_binder.linked_enemies_base then
                        for i = 1, #time_binder.linked_enemies_base, 1 do
                            local enemy = time_binder.linked_enemies_base[i]
                            if enemy and IsValidEntity(enemy) and enemy:HasModifier("modifier_time_bound") and enemy:IsAlive() then
                                Filters:TakeArgumentsAndApplyDamage(enemy, attacker, q_2_damage, DAMAGE_TYPE_PURE, slot, RPC_ELEMENT_NONE, RPC_ELEMENT_NONE)
                            end
                        end
                    end
                    if time_binder.linked_enemies_q1 then
                        for i = 1, #time_binder.linked_enemies_q1, 1 do
                            local enemy = time_binder.linked_enemies_q1[i]
                            if enemy and IsValidEntity(enemy) and enemy:HasModifier("modifier_space_link") and enemy:IsAlive() then
                                Filters:TakeArgumentsAndApplyDamage(enemy, attacker, q_2_damage, DAMAGE_TYPE_PURE, slot, RPC_ELEMENT_NONE, RPC_ELEMENT_NONE)
                            end
                        end
                    end
                end
            end
        end
    end
end

function Filters:MoonTechRunners(caster)
    local ability = caster.foot
    --print("MOOON TECH!")
    --ability:ApplyDataDrivenThinker(caster, caster:GetAbsOrigin(), "modifier_moon_tech_thinker", {})
    CustomAbilities:QuickAttachThinker(ability, caster, caster:GetAbsOrigin(), "modifier_moon_tech_thinker", {})
end

function Filters:FloodRobe(caster)
    local damageMult = ROBE_OF_FLOODING_AOE_INT_TO_DMG
    local eleName = "water_elemental_flood_3"
    local renderVector = Vector(175, 175, 255)
    local bAddAbility = true

    local elemental = CreateUnitByName(eleName, caster:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
    elemental:SetRenderColor(renderVector.x, renderVector.y, renderVector.z)
    elemental.owner = caster:GetPlayerOwnerID()
    if bAddAbility then
        elemental:AddAbility("water_flood_nuke"):SetLevel(1)
    end
    elemental.summoner = caster
    elemental:SetOwner(caster)
    elemental:SetControllableByPlayer(caster:GetPlayerID(), true)
    elemental.dieTime = ROBE_OF_FLOODING_DURATION
    elemental:AddAbility("ability_die_after_time_generic"):SetLevel(1)
    local summonAbil = elemental:AddAbility("ability_summoned_unit")

    summonAbil:SetLevel(1)
    summonAbil:ApplyDataDrivenModifier(elemental, elemental, "modifier_summoned_unit_damage_increase", {duration = 30})
    local eleDamage = Filters:AdjustItemDamage(caster, caster:GetIntellect() * damageMult, nil)

    skeleHealth = Filters:AdjustItemDamage(caster, caster:GetMaxHealth(), nil)
    elemental:SetMaxHealth(skeleHealth)
    elemental:SetBaseMaxHealth(skeleHealth)
    elemental:SetHealth(skeleHealth)

    elemental:SetPhysicalArmorBaseValue(Filters:AdjustItemDamage(caster, 100, nil))

    Filters:SetAttackDamage(elemental, eleDamage)
end

function Filters:AvalanchePlate(caster)
    -- local radius = 400
    -- local splitEarthParticle = "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf"
    -- local position = caster:GetAbsOrigin()
    -- local pfx = ParticleManager:CreateParticle( splitEarthParticle, PATTACH_CUSTOMORIGIN, caster )
    -- ParticleManager:SetParticleControl( pfx, 0, position )
    -- ParticleManager:SetParticleControl( pfx, 1, Vector(radius, radius, radius) )
    -- Timers:CreateTimer(4, function()
    --     ParticleManager:DestroyParticle(pfx, false)
    -- end)
    -- if bSound then
    --     EmitSoundOn("Hero_Leshrac.Split_Earth", caster)
    -- end
    -- local damage = caster:GetStrength()*60
    -- local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
    -- if #enemies > 0 then
    --     for _,enemy in pairs(enemies) do
    --         Filters:ApplyItemDamage(enemy,caster,damage,DAMAGE_TYPE_MAGICAL,nil)
    --         Filters:ApplyStun(caster, 1.5, enemy)
    --     end
    -- end
    local position = caster:GetAbsOrigin()
    EmitSoundOnLocationWithCaster(position, "RPCItem.AvalancheStart", caster)
    local avalancheParticle = "particles/units/heroes/hero_tiny/tiny_avalanche.vpcf"
    local pfx = ParticleManager:CreateParticle(avalancheParticle, PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(pfx, 0, position)
    ParticleManager:SetParticleControl(pfx, 1, Vector(400, 400, 400))
    caster.body:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_avalanche_thinker", {duration = 3.8})
    caster.body.pfx = pfx
    caster.body.strikeCount = 0
    Timers:CreateTimer(4, function()
        ParticleManager:DestroyParticle(pfx, false)
    end)
end

function Filters:SeraphicVest(caster)
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, SERAPHIC_SOULVEST_RADIUS_OF_SEARCH, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    if #enemies > 0 then
        local info =
        {
            Target = enemies[1],
            Source = caster,
            Ability = caster.body,
            EffectName = "particles/units/heroes/hero_visage/visage_soul_assumption_bolt2.vpcf",
            StartPosition = "attach_hitloc",
            bDrawsOnMinimap = false,
            bDodgeable = true,
            bIsAttack = false,
            bVisibleToEnemies = true,
            bReplaceExisting = false,
            flExpireTime = GameRules:GetGameTime() + 8,
            bProvidesVision = true,
            iVisionRadius = 0,
            iMoveSpeed = 650,
        iVisionTeamNumber = caster:GetTeamNumber()}
        projectile = ProjectileManager:CreateTrackingProjectile(info)
    end
end

function Filters:WatcherOne(caster)
    local proc = Filters:GetProc(caster, WATCHER_I_REFRESH_CHANCE)
    if proc then
        local ability = caster:GetAbilityByIndex(DOTA_R_SLOT)
        ability:EndCooldown()
    end
end

function Filters:SorcerersRegalia(caster)
    local particleName = "particles/items3_fx/mango_active.vpcf"
    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
    Timers:CreateTimer(1, function()
        ParticleManager:DestroyParticle(pfx, false)
    end)
    local manaRestore = caster:GetIntellect() * 0.5
    manaRestore = WallPhysics:round(manaRestore, 0)
    caster:GiveMana(manaRestore)
    PopupMana(caster, manaRestore)
end

function Filters:SpellslingerCoat(caster)
    local ability = caster:GetAbilityByIndex(DOTA_W_SLOT)
    local manaCost = ability:GetManaCost(-1)
    local manaRestore = manaCost * SPELLSLINGER_MANA_RESTORE/100
    manaRestore = WallPhysics:round(manaRestore, 0)
    caster:GiveMana(manaRestore)
    PopupMana(caster, manaRestore)
end

function Filters:DoomplateApply(attacker, victim)
    local inventoryUnit = attacker.InventoryUnit
    local ability = inventoryUnit:FindAbilityByName("body_slot")
    victim.doomplateCaster = attacker
    ability:ApplyDataDrivenModifier(inventoryUnit, victim, "modifier_doomplate_effect", {duration = 4})
end

function Filters:WhiteMageHat(caster)
    local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, WHITE_MAGE_RADIUS, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    local healAmount = caster:GetIntellect() * WHITE_MAGE_INT_TO_HEAL
    local inventoryUnit = caster.InventoryUnit
    local ability = inventoryUnit:FindAbilityByName("helm_slot")
    if #allies > 0 then
        for _, ally in pairs(allies) do
            ally:RemoveModifierByName("modifier_white_mage_hat_effect")
            ability:ApplyDataDrivenModifier(inventoryUnit, ally, "modifier_white_mage_hat_effect", {})
            Filters:ApplyHeal(caster, ally, healAmount, true)
        end
    end
end

function Filters:RubyDragon(caster)
    -- local dragon = CreateUnitByName("ruby_dragon_summon", caster:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
    -- dragon.owner = caster:GetPlayerOwnerID()
    -- dragon.summoner = caster
    -- dragon:SetOwner(caster)
    -- dragon:SetControllableByPlayer(caster:GetPlayerID(), true)
    -- dragon.dieTime = 12
    -- dragon:AddAbility("ability_die_after_time_generic"):SetLevel(1)
    -- skeleHealth = Filters:AdjustItemDamage(caster, caster:GetMaxHealth())
    -- dragon:SetMaxHealth(skeleHealth)
    -- dragon:SetBaseMaxHealth(skeleHealth)
    -- dragon:SetHealth(skeleHealth)

    -- dragon:SetPhysicalArmorBaseValue(Filters:AdjustItemDamage(caster, 100))
    -- local summonAbil = dragon:AddAbility("ability_summoned_unit")
    -- summonAbil:SetLevel(1)
    -- dragon.burnDamage = caster:GetStrength()*12
    local perpFv = WallPhysics:rotateVector(caster:GetForwardVector(), math.pi / 2)
    local dragon = CreateUnitByName("ruby_dragon_new", caster:GetAbsOrigin() - caster:GetForwardVector() * 780 + perpFv * RandomInt(-180, 180), true, nil, nil, DOTA_TEAM_GOODGUYS)
    dragon.owner = caster:GetPlayerOwnerID()
    dragon.hero = caster
    dragon:SetOwner(caster)
    dragon:SetAbsOrigin(dragon:GetAbsOrigin() + Vector(0, 0, 800))
    dragon:SetControllableByPlayer(caster:GetPlayerID(), true)
    dragon:SetRenderColor(255, 0, 0)
    dragon:SetForwardVector(caster:GetForwardVector())

    local dragonAbility = dragon:FindAbilityByName("ruby_dragon_ability")
    dragonAbility:ApplyDataDrivenModifier(dragon, dragon, "ruby_dragon_cinematic", {duration = 1.5})
    Timers:CreateTimer(0.5, function()
        EmitSoundOn("RPCItem.RubyDragonEnter", dragon)
    end)
    Timers:CreateTimer(1.5, function()
        dragon:MoveToPosition(caster:GetAbsOrigin() + RandomVector(RandomInt(50, 250)))
    end)
    dragon.entering = true
end

function Filters:DeathWhisperApply(attacker, victim)
    local inventoryUnit = attacker.InventoryUnit
    local ability = inventoryUnit:FindAbilityByName("helm_slot")
    ability:ApplyDataDrivenModifier(inventoryUnit, victim, "modifier_death_whisper_effect", {duration = DEATH_WHISPER_DURATION})
end

function Filters:WildNatureTwo(attacker, victim)
    local proc = Filters:GetProc(attacker, CAP_OF_WILD_NATURE_CHANCE_TWO)
    if proc then
        local inventoryUnit = attacker.InventoryUnit
        victim.entangler = attacker
        local ability = inventoryUnit:FindAbilityByName("helm_slot")
        ability:ApplyDataDrivenModifier(inventoryUnit, victim, "modifier_wild_nature_entangle_effect", {duration = CAP_OF_WILD_NATURE_DURATION_TWO})
    end
end

function Filters:LumaGuardStrike(attacker, victim, damage)
    local proc = Filters:GetProc(attacker, LUMA_BEAM_CHANCE)
    if proc then
        local inventoryUnit = attacker.InventoryUnit
        local ability = inventoryUnit:FindAbilityByName("helm_slot")
        ability:ApplyDataDrivenModifier(inventoryUnit, victim, "modifier_luma_guard_moonbeam", {duration = LUMA_VISION_DURATION})
        -- local moonParticle = "particles/units/heroes/hero_luna/luna_lucent_beam.vpcf"
        -- local position = victim:GetAbsOrigin()
        -- local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_luna/luna_lucent_beam.vpcf", PATTACH_CUSTOMORIGIN, victim )
        -- ParticleManager:SetParticleControl( pfx, 0, position )
        AddFOWViewer(attacker:GetTeamNumber(), victim:GetAbsOrigin(), 500, LUMA_VISION_DURATION, false)

        -- Timers:CreateTimer(4, function()
        --  ParticleManager:DestroyParticle(pfx, false)
        -- end)
        local damage = damage * LUMA_DAMAGE_AMP/100
        Filters:ApplyItemDamageBasedOnAbility(victim, attacker, damage, DAMAGE_TYPE_PURE, nil, RPC_ELEMENT_COSMOS, RPC_ELEMENT_NONE)
        ----print("MOONBEAM HAS FIRED")
        return true
    end
end

function Filters:OdinCrit(attacker, victim, damage, damage_type)
    local proc = Filters:GetProc(attacker, ODIN_HELMET_CHANCE)
    if proc then
        ApplyDamage({victim = victim, attacker = attacker, damage = damage * ODIN_HELMET_MULT, damage_type = damage_type, damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR})
        PopupDamage(victim, damage * ODIN_HELMET_MULT)
    end
end

function Filters:HasMovementModifier(caster)
    if caster:HasModifier("modifier_possession_moving_toward_target") or caster:HasModifier("modifier_jumping") or caster:HasModifier("modifier_forest_guide_pull_thinking") or caster:HasModifier("modifier_mountain_spirit_transfer") or caster:HasModifier("modifier_inside_lizard") or caster:HasModifier("modifier_boat_dummy_prepping") or caster:HasModifier("modifier_wind_temple_flailing") or caster:HasModifier("modifier_heavy_boulder_pushback") or caster:HasModifier("modifier_lava_jumping") or caster:HasModifier("modifier_wind_temple_flailing") or caster:HasModifier("modifier_sea_fortress_green_beacon") then
        return true
    else
        return false
    end
end

function Filters:GetNonPercentageAttribute(hero, attribute)
    if attribute == "agility" then
        local leonAgi = hero:GetModifierStackCount("modifier_gold_plate_of_leon_agi", hero.InventoryUnit)
        local adjustedAgi = hero:GetAgility() - leonAgi
        return adjustedAgi
    end
end

function Filters:WitchHat(caster)
    local fv = caster:GetForwardVector()
    local ability = caster.witchHat
    ability.caster = caster
    local projectileParticle = "particles/roshpit/winterblight/ellipsis_wave.vpcf"
    local projectileOrigin = caster:GetAbsOrigin() + fv * 10
    local start_radius = 120
    local end_radius = 400
    local range = 900
    local speed = 850
    local info =
    {
        Ability = ability,
        EffectName = projectileParticle,
        vSpawnOrigin = projectileOrigin + Vector(0, 0, 60),
        fDistance = range,
        fStartRadius = start_radius,
        fEndRadius = end_radius,
        Source = caster,
        StartPosition = "attach_hitloc",
        bHasFrontalCone = true,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 4.0,
        bDeleteOnHit = false,
        vVelocity = fv * speed,
        bProvidesVision = false,
    }
    projectile = ProjectileManager:CreateLinearProjectile(info)
end

function Filters:TricksterMask(caster)
    local casterOrigin = caster:GetAbsOrigin()
    local randomPosition = casterOrigin + RandomVector(TRICKSTER_MASK_RANGE)
    randomPosition = WallPhysics:WallSearch(casterOrigin, randomPosition, caster)
    FindClearSpaceForUnit(caster, randomPosition, false)
    caster:RemoveModifierByName("modifier_trickster_mask_effect")
    EmitSoundOn("RPCItem.TricksterMask", caster)
    caster.tricksterItem:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_trickster_mask_effect", {duration = 0.5})
end

function Filters:SecretTemple(caster)
    local inventoryUnit = caster.InventoryUnit
    caster.refractionItem:ApplyDataDrivenModifier(inventoryUnit, caster, "modifier_secret_temple_refraction", {duration = SECRET_TEMPLE_SHIELDS_DURATION})
    caster:SetModifierStackCount("modifier_secret_temple_refraction", caster.refractionItem, SECRET_TEMPLE_SHIELDS)
    caster.refractionItem:ApplyDataDrivenModifier(inventoryUnit, caster, "modifier_secret_temple_damage_increase", {duration = SECRET_TEMPLE_SHIELDS_DURATION})
    local damageStackCount = caster:GetModifierStackCount("modifier_secret_temple_damage_increase", caster.refractionItem)
    caster:SetModifierStackCount("modifier_secret_temple_damage_increase", caster.refractionItem, caster:GetAttackDamage() - damageStackCount)
end

function Filters:VampiricBreastplate(caster, damage)
    local heal = math.max(math.floor(damage * VAMPIRIC_BREASTPLATE_Q_LIFESTEAL/100), 0)
    Filters:ApplyHeal(caster, caster, heal, true)
    if not caster:HasModifier("modifier_vampiric_particle") then
        caster.body:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_vampiric_particle", {duration = 1})
        local particleName = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
        local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
        ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
        Timers:CreateTimer(1, function()
            ParticleManager:DestroyParticle(pfx, false)
        end)
    end
end

function Filters:SpiritGlove(caster)
    local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, SPIRIT_GLOVE_RADIUS, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    local healAmount = math.ceil(caster:GetIntellect() * SPIRIT_GLOVE_INT_TO_HEAL)
    local spiritGlove = caster.spiritGlove
    spiritGlove.healAmount = healAmount
    if #allies > 0 then
        for _, ally in pairs(allies) do
            local particleName = "particles/units/heroes/hero_oracle/white_mage_healheal.vpcf"
            local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, ally)
            ParticleManager:SetParticleControlEnt(pfx, 0, ally, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", ally:GetAbsOrigin(), true)
            Timers:CreateTimer(1.5, function()
                ParticleManager:DestroyParticle(pfx, false)
            end)
            Filters:ApplyHeal(caster, ally, healAmount, true)
            spiritGlove:ApplyDataDrivenModifier(caster.InventoryUnit, ally, "modifier_spirit_glove_effect", {duration = SPIRIT_GLOVE_DURATION})
        end
    end
end

function Filters:FrostburnGauntlet(attacker, victim, damage)--attacker, victim, damage
    local proc = Filters:GetProc(attacker, FROSTBURN_GLOVES_CHANCE)
    CustomAbilities:QuickAttachParticle("particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/cm_arcana_pup_flee.vpcf", victim, 3)
    attacker.handItem:ApplyDataDrivenModifier(attacker.InventoryUnit, victim, "modifier_frostburn_gauntlets_slow", {duration = FROSTBURN_GLOVES_MS_SLOW_DUR})
    if proc then
        local icePoint = victim:GetAbsOrigin()
        local radius = FROSTBURN_GLOVES_EXPLOSION_RADIUS
        EmitSoundOnLocationWithCaster(icePoint, "hero_Crystal.freezingField.explosion", attacker)
        local particle = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
        local pfx = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, attacker)
        ParticleManager:SetParticleControl(pfx, 0, icePoint)
        ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 2, radius * 2))
        Timers:CreateTimer(2.5, function()
            ParticleManager:DestroyParticle(pfx, false)
        end)
        local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), icePoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
        if #enemies > 0 then
            for _, enemy in pairs(enemies) do
                attacker.frostburnItem:ApplyDataDrivenModifier(attacker, enemy, "modifier_frostburn_gauntlets_slow", {duration = FROSTBURN_GLOVES_MS_SLOW_DUR})
                Filters:ApplyItemDamageBasedOnAbility(enemy, attacker, damage, DAMAGE_TYPE_PURE, nil, RPC_ELEMENT_ICE, RPC_ELEMENT_NONE)
            end
        end
        return true
    end
end

function Filters:GetPrimaryAttributeMultiple(hero, multiple)
    local primeAttribute = hero:GetPrimaryAttribute()
    local damage = 0
    if primeAttribute == 0 then
        damage = hero:GetStrength() * multiple
    elseif primeAttribute == 1 then
        damage = hero:GetAgility() * multiple
    elseif primeAttribute == 2 then
        damage = hero:GetIntellect() * multiple
    end
    return math.ceil(damage)
end

function Filters:IsPrimaryAttribute(hero, attr)
    local primeAttribute = hero:GetPrimaryAttribute()
    if primeAttribute == 0 then
        if attr == "str" then
            return true
        end
    elseif primeAttribute == 1 then
        if attr == "agi" then
            return true
        end
    elseif primeAttribute == 2 then
        if attr == "int" then
            return true
        end
    else
        return false
    end
end

function Filters:VioletBoot(caster)
    if not caster:HasModifier("modifier_violet_boot_cooldown") then
        caster.violetBoot:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_violet_boot_cooldown", {duration = 1})
        local fv = caster:GetForwardVector()
        fv = WallPhysics:rotateVector(fv, math.pi)
        Filters:VioletProjectile(caster, fv)
        Filters:VioletProjectile(caster, WallPhysics:rotateVector(fv, math.pi / 9))
        Filters:VioletProjectile(caster, WallPhysics:rotateVector(fv, -math.pi / 9))
        EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hero_Tinker.LaserImpact", caster)
    end
end

function Filters:VioletProjectile(caster, fv)
    local projectileParticle = "particles/econ/items/mirana/mirana_crescent_arrow/violet_boots.vpcf"

    local projectileOrigin = caster:GetAbsOrigin()
    local start_radius = 160
    local end_radius = 160
    local range = 1200
    local speed = 850
    local info =
    {
        Ability = caster.violetBoot,
        EffectName = projectileParticle,
        vSpawnOrigin = projectileOrigin + Vector(0, 0, 200),
        fDistance = range,
        fStartRadius = start_radius,
        fEndRadius = end_radius,
        Source = caster,
        StartPosition = "attach_hitloc",
        bHasFrontalCone = true,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 4.0,
        bDeleteOnHit = false,
        vVelocity = fv * speed,
        bProvidesVision = false,
    }
    projectile = ProjectileManager:CreateLinearProjectile(info)
end

function Filters:SonicBoot(caster)
    local inventoryUnit = caster.InventoryUnit
    local ability = inventoryUnit.foot_item
    ability:ApplyDataDrivenModifier(inventoryUnit, caster, "modifier_sonic_boots_effect", {duration = 7})
    caster:AddNewModifier(caster, nil, 'modifier_movespeed_cap_sonic', {duration = 7})
end

function Filters:FalconBoot(caster)
    --print("falcon boot?")
    if not caster:HasModifier("modifier_falcon_immune") then

        local fv = caster:GetForwardVector()
        local point = caster:GetAbsOrigin() + fv * 120
        Filters:FalconProjectile(caster, fv, point)
        Filters:FalconProjectile(caster, fv, point + WallPhysics:rotateVector(fv, math.pi / 2) * 90 - fv * 80)
        Filters:FalconProjectile(caster, fv, point - WallPhysics:rotateVector(fv, math.pi / 2) * 90 - fv * 80)
        Filters:FalconProjectile(caster, fv, point + WallPhysics:rotateVector(fv, math.pi / 2) * 180 - fv * 160)
        Filters:FalconProjectile(caster, fv, point - WallPhysics:rotateVector(fv, math.pi / 2) * 180 - fv * 160)
        EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hero_SkywrathMage.ArcaneBolt.Cast", caster)
        local ability = caster.foot
        ability.liftedTargetsTable = {}
        local transportLocation = caster:GetAbsOrigin() + fv * 1400
        ability.transportLocation = transportLocation
        local targetPosition = WallPhysics:WallSearch(caster:GetAbsOrigin(), transportLocation, caster)
        ability:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_falcon_immune", {duration = 2.3})
        Timers:CreateTimer(2, function()
            if ability.liftedTargetsTable then
                for i = 1, #ability.liftedTargetsTable, 1 do
                    local target = ability.liftedTargetsTable[i]
                    FindClearSpaceForUnit(target, targetPosition + RandomVector(RandomInt(20, 100)), false)
                end
            end
        end)
        Timers:CreateTimer(2.25, function()
            --print("TIME 2.25!")
            if #ability.liftedTargetsTable > 0 then
            end
            --print(#ability.liftedTargetsTable)
            for i = 1, #ability.liftedTargetsTable, 1 do
                local target = ability.liftedTargetsTable[i]
                target:RemoveModifierByName("modifier_falcon_out")
                --print("CLEAR SPACE!!"..i)
                if not target:HasModifier("modifier_falcon_immune") then
                    Timers:CreateTimer(0.05, function()
                        ability:ApplyDataDrivenModifier(caster.InventoryUnit, target, "modifier_falcon_freeze", {duration = 4})
                    end)
                end
                ability:ApplyDataDrivenModifier(caster.InventoryUnit, target, "modifier_falcon_immune", {duration = 5})

            end

        end)
    end
end

function Filters:FalconProjectile(caster, fv, projectileOrigin)
    local projectileParticle = "particles/units/heroes/hero_skywrath_mage/falcon_boot_arcane_bolt.vpcf"

    local start_radius = 120
    local end_radius = 120
    local range = 1400
    local speed = 600
    local info =
    {
        Ability = caster.foot,
        EffectName = projectileParticle,
        vSpawnOrigin = projectileOrigin + Vector(0, 0, 75),
        fDistance = range,
        fStartRadius = start_radius,
        fEndRadius = end_radius,
        Source = caster,
        StartPosition = "attach_hitloc",
        bHasFrontalCone = true,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 4.0,
        bDeleteOnHit = false,
        vVelocity = fv * speed,
        bProvidesVision = false,
    }
    projectile = ProjectileManager:CreateLinearProjectile(info)
end

function Filters:EternalFrost(caster)
    local particle = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
    local pfx = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
    local position = caster:GetAbsOrigin()
    local radius = ETERNAL_FROST_ACTIVE_ROOT_AOE
    ParticleManager:SetParticleControl(pfx, 0, position)
    ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 2, radius * 2))
    Timers:CreateTimer(3, function()
        ParticleManager:DestroyParticle(pfx, false)
    end)
    local ability = caster.eternal_frost_gem
    EmitSoundOn("Ability.FrostNova", caster)

    local damage = caster:GetIntellect() * ETERNAL_FROST_ACTIVE_EXPLOSION_DMG_PER_INT
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    local freezeDuration = ETERNAL_FROST_ACTIVE_ROOT_DURATION
    if #enemies > 0 then
        for _, enemy in pairs(enemies) do
            Filters:ApplyItemDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, nil, RPC_ELEMENT_ICE, RPC_ELEMENT_NONE)
            ability:ApplyDataDrivenModifier(caster, enemy, "modifier_eternal_frost_nova", {duration = freezeDuration})
        end
    end
end

function Filters:CeruleanHighguard(caster)
    local ability = caster:GetAbilityByIndex(DOTA_W_SLOT)
    local manaCost = ability:GetManaCost(-1)
    caster:ReduceMana(manaCost * CERULEAN_HIGHGUARD_MANA_INCREASE/100)
end

function Filters:AscensionTrigger(caster)
    local ability = caster.headItem
    local duration = math.max(caster:GetAbilityByIndex(DOTA_R_SLOT):GetCooldownTimeRemaining(), SUPER_ASCENDENCY_MIN_DURATION)
    ability:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_super_ascendency_trigger", {duration = duration})
    caster:AddNewModifier(caster, ability, "modifier_super_ascendency_lua", {duration = duration})
end

function Filters:ScourgeKnight(caster)
    local fv = caster:GetForwardVector()
    local casterOrigin = caster:GetAbsOrigin()
    local perpFv = WallPhysics:rotateVector(fv, math.pi / 2)
    local spawnPosition = casterOrigin - fv * 180
    local vectorTable = {spawnPosition - perpFv * 240, spawnPosition - perpFv * 120, spawnPosition, spawnPosition + perpFv * 120, spawnPosition + perpFv * 240}
    for i = 1, #vectorTable, 1 do
        local archer = CreateUnitByName("skeleton_archer", vectorTable[i], true, nil, nil, DOTA_TEAM_GOODGUYS)
        archer.owner = caster:GetPlayerOwnerID()
        archer.summoner = caster
        archer:SetOwner(caster)
        archer:SetControllableByPlayer(caster:GetPlayerID(), true)
        archer.dieTime = 12
        archer:AddAbility("ability_die_after_time_generic"):SetLevel(1)
        local summonAbil = archer:AddAbility("ability_summoned_unit")
        summonAbil:SetLevel(1)
        summonAbil:ApplyDataDrivenModifier(archer, archer, "modifier_summoned_unit_damage_increase", {duration = 30})
        local skeleDamage = Filters:AdjustItemDamage(caster, caster:GetAttackDamage() / 10, nil)
        archer:SetModifierStackCount("modifier_summoned_unit_damage_increase", summonAbil, skeleDamage)
        archer:SetForwardVector(fv)
        archer:SetPhysicalArmorBaseValue(Filters:AdjustItemDamage(caster, 80, nil))
        local skeleHealth = math.floor(caster:GetMaxHealth() * 0.15)
        skeleHealth = Filters:AdjustItemDamage(caster, skeleHealth, nil)
        archer:SetMaxHealth(skeleHealth)
        archer:SetBaseMaxHealth(skeleHealth)
        archer:SetHealth(skeleHealth)
        archer:Heal(skeleHealth, archer)
        archer:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
        archer:SetModelScale(0.7)
        archer:SetPhysicalArmorBaseValue(10)
    end
end

function Filters:GetBaseBaseArmor(unit)
    local rootedArmor = 0
    local livingGauntArmor = 0
    local warlord_b_a_armor = 0
    if unit:IsHero() then
        rootedArmor = unit:GetModifierStackCount("modifier_rooted_feet_armor_portion", unit.InventoryUnit)
        livingGauntArmor = unit:GetModifierStackCount("modifier_living_gauntlet_effect_armor", unit.InventoryUnit)
        warlord_b_a_armor = unit:GetModifierStackCount("modifier_warlord_rune_q_2_invisible", unit)
    end
    local baseBaseArmor = unit:GetPhysicalArmorValue(false) - rootedArmor - livingGauntArmor - warlord_b_a_armor
    return baseBaseArmor
end

function Filters:SetupSummonUnit(caster, position, damageMult, healthMult, lifeDuration, armorMult, unit)
    unit.dieTime = lifeDuration
    unit:AddAbility("ability_die_after_time_generic"):SetLevel(1)
    local summonAbil = unit:AddAbility("ability_summoned_unit")
    summonAbil:SetLevel(1)
    local dmg = OverflowProtectedGetAverageTrueAttackDamage(caster) * damageMult
    dmg = Filters:AdjustItemDamage(caster, dmg, nil)
    Filters:SetAttackDamage(unit, dmg)
    unit:SetPhysicalArmorBaseValue(Filters:AdjustItemDamage(caster, caster:GetPhysicalArmorValue(false) * armorMult, nil))
    local wolfHealth = math.floor(caster:GetMaxHealth() * healthMult)
    wolfHealth = Filters:AdjustItemDamage(caster, wolfHealth, nil)
    unit:SetMaxHealth(wolfHealth)
    unit:SetBaseMaxHealth(wolfHealth)
    unit:SetHealth(wolfHealth)
    unit:Heal(wolfHealth, unit)
end

function Filters:CytopianLaser(caster)
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, CYTOPIAN_LASER_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    local abilityLevel = caster:GetAbilityByIndex(DOTA_W_SLOT):GetLevel()
    local baseDamage = OverflowProtectedGetAverageTrueAttackDamage(caster) * abilityLevel * CYTOPIAN_LASER_DMG_PER_ATT
    if #enemies > 0 then
        local ability = caster.handItem
        EmitSoundOn("Hero_Tinker.Attack", enemies[1])
        for _, enemy in pairs(enemies) do
            local damage = baseDamage
            local currentStacks = enemy:GetModifierStackCount("modifier_cytopian_stacks", caster.InventoryUnit)
            damage = damage + damage * currentStacks

            Filters:ApplyItemDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, nil, RPC_ELEMENT_TIME, RPC_ELEMENT_LIGHTNING)
            local particleName = "particles/units/heroes/hero_tinker/tinker_laser.vpcf"
            local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, enemy)
            ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin() + Vector(0, 0, 100))
            ParticleManager:SetParticleControlEnt(pfx, 1, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin() + Vector(0, 0, 100), true)
            ParticleManager:SetParticleControlEnt(pfx, 3, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin() + Vector(0, 0, 100), true)
            ParticleManager:SetParticleControlEnt(pfx, 9, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", caster:GetAbsOrigin() + Vector(0, 0, 100), true)
            Timers:CreateTimer(0.8, function()
                ParticleManager:DestroyParticle(pfx, false)
            end)
            ability:ApplyDataDrivenModifier(caster.InventoryUnit, enemy, "modifier_cytopian_stacks", {duration = 4})
            local newStacks = math.min(currentStacks + 1, CYTOPIAN_LASER_MAX_STACKS)
            enemy:SetModifierStackCount("modifier_cytopian_stacks", caster.InventoryUnit, newStacks)
        end
    end
end

function Filters:VoyagerBoots(caster)
    local ability1 = caster:GetAbilityByIndex(DOTA_Q_SLOT)
    Filters:ReduceCDByPercentage(ability1, VOYAGER_BOOTS_E_RED/100)
    local ability2 = caster:GetAbilityByIndex(DOTA_W_SLOT)
    Filters:ReduceCDByPercentage(ability2, VOYAGER_BOOTS_E_RED/100)
    local ability4 = caster:GetAbilityByIndex(DOTA_R_SLOT)
    Filters:ReduceCDByPercentage(ability4, VOYAGER_BOOTS_E_RED/100)
    -- local blizzard = caster:FindAbilityByName("blizzard")
    -- Filters:ReduceCDByPercentage(blizzard, 0.3)
    -- local pyroblast = caster:FindAbilityByName("pyroblast")
    -- Filters:ReduceCDByPercentage(pyroblast, 0.3)
end

function Filters:ReduceCDByPercentage(ability, percentageReduction)
    if ability then
        local CDreduce = ability:GetCooldown(ability:GetLevel()) * percentageReduction
        if ability:GetAbilityName() == "earthquake" then
            CDreduce = 12 * percentageReduction
        end
        local CDremaining = ability:GetCooldownTimeRemaining()
        local newCD = math.max(0, CDremaining - CDreduce)
        if newCD == 0 then
            ability:EndCooldown()
        else
            ability:EndCooldown()
            ability:StartCooldown(newCD)
        end
    end
end

function Filters:TomeOfChaos(caster)
    if not caster:HasModifier("modifier_tome_of_chaos_cooldown") then
        caster.tome_of_chaos:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_tome_of_chaos_cooldown", {duration = TOME_OF_CHAOS_CD})
        local position = caster:GetAbsOrigin() + caster:GetForwardVector() * 580
        particleName = "particles/items_fx/infernal_summon_spawn_aegis_starfall.vpcf"
        for i = 1, 8, 1 do
            Timers:CreateTimer(0.2 + i * 0.06, function()
                EmitSoundOnLocationWithCaster(position, "Hero_WarlockGolem.Attack", caster)
            end)
        end
        EmitSoundOnLocationWithCaster(position, "Hero_Warlock.RainOfChaos_buildup", caster)
        for i = 0, 5, 1 do
            Timers:CreateTimer(0.15 * i, function()
                local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
                ParticleManager:SetParticleControl(particle1, 0, position + Vector(0, 0, 50))
                Timers:CreateTimer(6, function()
                    ParticleManager:DestroyParticle(particle1, false)
                end)
            end)
        end
        Timers:CreateTimer(0.4, function()
            local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
            if #enemies > 0 then
                for _, enemy in pairs(enemies) do
                    Filters:ApplyStun(caster, TOME_OF_CHAOS_STUN, enemy)
                end
            end
            Timers:CreateTimer(0.2, function()
                EmitSoundOnLocationWithCaster(position, "Hero_Warlock.RainOfChaos", caster)
            end)
            local infernal = CreateUnitByName("minion_of_twilight", position, true, nil, nil, caster:GetTeamNumber())
            infernal.owner = caster:GetPlayerOwnerID()
            infernal.summoner = caster
            infernal:SetOwner(caster)
            infernal:SetControllableByPlayer(caster:GetPlayerID(), true)
            infernal.dieTime = TOME_OF_CHAOS_DURATION
            infernal:AddAbility("ability_die_after_time_generic"):SetLevel(1)
            StartAnimation(infernal, {duration = 0.8, activity = ACT_DOTA_ATTACK, rate = 1.0})
            local summonAbil = infernal:AddAbility("ability_summoned_unit")
            summonAbil:SetLevel(1)

            local infernalDamage = (caster:GetStrength() + caster:GetAgility() + caster:GetIntellect()) * TOME_OF_CHAOS_ATTACK_DAMAGE_PER_ATTRIBUTE
            infernalDamage = Filters:AdjustItemDamage(caster, infernalDamage, nil)
            infernalDamage = Filters:ElementalDamage(infernal, caster, infernalDamage, DAMAGE_TYPE_PHYSICAL, 0, RPC_ELEMENT_DEMON, RPC_ELEMENT_NONE, true)
            infernal:SetBaseDamageMin(infernalDamage)
            infernal:SetBaseDamageMax(infernalDamage)

            local minionHealth = math.floor(caster:GetMaxHealth() * TOME_OF_CHAOS_HP_MULT)
            minionHealth = Filters:AdjustItemDamage(caster, minionHealth, nil)
            infernal:SetMaxHealth(minionHealth)
            infernal:SetBaseMaxHealth(minionHealth)
            infernal:SetHealth(minionHealth)
            infernal:Heal(minionHealth, infernal)
            infernal:SetModelScale(0.9)
            infernal:SetRenderColor(140, 255, 140)
            infernal:SetPhysicalArmorBaseValue(Filters:AdjustItemDamage(caster, caster:GetPhysicalArmorValue(false) * TOME_OF_CHAOS_ARMOR_MULT, nil))
            infernal:AddAbility("sven_great_cleave"):SetLevel(1)
            infernal:SetAcquisitionRange(2800)
            caster.tome_of_chaos:ApplyDataDrivenModifier(caster.InventoryUnit, infernal, "modifier_infernal_effect", {duration = 30})

        end)
    end
end

function Filters:RedrockFootwear(caster)
    local ability = caster.redrock
    for i = 0, REDROCK_NUMBER_OF_PULSES-1, 1 do
        Timers:CreateTimer(0.2 + i * (REDROCK_DURATION_OF_PULSES/REDROCK_NUMBER_OF_PULSES), function()
            EmitSoundOn("RPCItem.RedrockFootwear", caster)
            local position = caster:GetAbsOrigin()
            local particleName = "particles/units/heroes/hero_faceless_void/redrock_timedialate.vpcf"
            local particle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
            local radius = REDROCK_TAUNT_RADIUS
            ParticleManager:SetParticleControl(particle, 0, position)
            ParticleManager:SetParticleControl(particle, 1, Vector(radius, radius, radius))
            Timers:CreateTimer(2, function()
                ParticleManager:DestroyParticle(particle, false)
            end)
            ability:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_redrock_footwear_damage_reduction", {duration = REDROCK_TAUNT_DURATION})
            local currentStacks = caster:GetModifierStackCount("modifier_redrock_footwear_health_increase", ability)
            local healthStacks = CustomAttributes:GetBaseHealth(caster, "modifier_redrock_footwear_health_increase") * REDROCK_HP_INCREASE_PCT/100 / 10
            ability:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_redrock_footwear_health_increase", {duration = REDROCK_TAUNT_DURATION})
            caster:SetModifierStackCount("modifier_redrock_footwear_health_increase", ability, healthStacks)
            local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
            if #enemies > 0 then
                for _, enemy in pairs(enemies) do
                    if enemy:GetAttackCapability() == DOTA_UNIT_CAP_NO_ATTACK then
                    else
                        ability:ApplyDataDrivenModifier(caster.InventoryUnit, enemy, "modifier_redrock_footwear_taunt_effect", {duration = REDROCK_TAUNT_DURATION})
                        enemy:MoveToTargetToAttack(caster)
                    end
                end
            end
        end)
    end
end

function Filters:ReanimateThorok(caster)
    local thorok = CreateUnitByName("thorok_reborn", caster:GetAbsOrigin(), true, nil, nil, caster:GetTeamNumber())
    thorok.owner = caster:GetPlayerOwnerID()
    thorok.summoner = caster
    thorok:SetOwner(caster)
    thorok:SetControllableByPlayer(caster:GetPlayerID(), true)
    thorok.dieTime = 10
    thorok:AddAbility("ability_die_after_time_generic"):SetLevel(1)
    StartAnimation(thorok, {duration = 0.8, activity = ACT_DOTA_ATTACK, rate = 1.0})
    local summonAbil = thorok:AddAbility("ability_summoned_unit")
    summonAbil:SetLevel(1)
    thorok:SetModelScale(1.19)
    local thorokDamage = OverflowProtectedGetAverageTrueAttackDamage(caster) * 8
    thorokDamage = Filters:AdjustItemDamage(caster, thorokDamage, nil)
    thorok:SetBaseDamageMin(thorokDamage)
    thorok:SetBaseDamageMax(thorokDamage)
    EmitSoundOn("life_stealer_lifest_ability_rage_03", thorok)
    local minionHealth = math.floor(caster:GetMaxHealth() * 4)
    minionHealth = Filters:AdjustItemDamage(caster, minionHealth, nil)
    thorok:SetMaxHealth(minionHealth)
    thorok:SetBaseMaxHealth(minionHealth)
    thorok:SetHealth(minionHealth)
    thorok:Heal(minionHealth, thorok)
    thorok:RemoveAbility("thorok_reborn_ai")
    thorok:RemoveModifierByName("modifier_thorok_reborn_ai")
    thorok:SetPhysicalArmorBaseValue(Filters:AdjustItemDamage(caster, caster:GetPhysicalArmorValue(false), nil))
    thorok:SetAcquisitionRange(2900)
    if caster:GetHealth() < caster:GetMaxHealth() * 0.4 then
        EmitSoundOn("Hero_LifeStealer.Rage", thorok)
        caster.necro_hood:ApplyDataDrivenModifier(caster.InventoryUnit, thorok, "modifier_thorok_enraged", {duration = 15})
        thorok:SetModelScale(1.55)
    end
end

function Filters:DemonMask(caster, target, damage)
    local proc = Filters:GetProc(caster, DEMON_MASK_CHANCE)
    -- proc = true
    if proc then
        --print("dmg test: "..damage)
        damage = damage * DEMON_MASK_AMP
        --print("dmg test: "..damage)
        local limitKey = caster:GetPlayerOwnerID() .. '_demon_mask'
        Util.Common:LimitPerTime(4, 1, limitKey, function()
            EmitSoundOn("RPCItem.DemonMask", target)
            local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/demon_mask_3.vpcf", PATTACH_CUSTOMORIGIN, caster)
            ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin() + Vector(0, 0, 115))
            -- ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN, "attach_hitloc", target:GetAbsOrigin()+Vector(0,0,100), true)
            -- ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_ABSORIGIN, "attach_hitloc", target:GetAbsOrigin()+Vector(0,0,100), true)
            -- ParticleManager:SetParticleControlEnt(pfx, 3, target, PATTACH_ABSORIGIN, "attach_hitloc", target:GetAbsOrigin()+Vector(0,0,100), true)
            Timers:CreateTimer(1.2, function()
                ParticleManager:DestroyParticle(pfx, false)
            end)
        end)
        local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, DEMON_MASK_AOE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
        -- local damage = highestAttribute*40
        Timers:CreateTimer(0.1, function()
            if #enemies > 0 then
                for _, enemy in pairs(enemies) do
                    Filters:ApplyItemDamageBasedOnAbility(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, nil, RPC_ELEMENT_DEMON, RPC_ELEMENT_NONE)
                end
            end
        end)
        return true
    end
end

function Filters:UmbralSentinel(attacker, victim)
    local ability = attacker.headItem
    local wLevel = attacker:GetAbilityByIndex(DOTA_W_SLOT):GetLevel()
    local origStacks = victim:GetModifierStackCount("modifier_crest_of_the_umbral_sentinel_effect_visible", ability)
    local newStacks = math.min(origStacks + 1, CREST_OF_UMBRAL_SENTINEL_MAX_STACKS)
    ability:ApplyDataDrivenModifier(attacker.InventoryUnit, victim, "modifier_crest_of_the_umbral_sentinel_effect_visible", {duration = CREST_OF_UMBRAL_SENTINEL_DURATION})
    victim:SetModifierStackCount("modifier_crest_of_the_umbral_sentinel_effect_visible", ability, newStacks)
    ability:ApplyDataDrivenModifier(attacker.InventoryUnit, victim, "modifier_crest_of_the_umbral_sentinel_effect_invisible", {duration = CREST_OF_UMBRAL_SENTINEL_DURATION})
    victim:SetModifierStackCount("modifier_crest_of_the_umbral_sentinel_effect_invisible", ability, math.floor(newStacks * CREST_OF_UMBRAL_SENTINEL_ARMOR_LOSS * wLevel))

    ability:ApplyDataDrivenModifier(attacker.InventoryUnit, victim, "modifier_umbral_sentinel_magic_amp", {duration = CREST_OF_UMBRAL_SENTINEL_DURATION})
    victim:SetModifierStackCount("modifier_umbral_sentinel_magic_amp", ability, newStacks * wLevel)
    victim.umbral = ability
end

function Filters:DefilerHit(attacker, victim)
    local ability = attacker.headItem
    if not victim.defiler then
        victim.defiler = ability
    end

    local origStacks = victim:GetModifierStackCount("modifier_hood_of_defiler_effect_visible", ability)

    local currentArmorLoss = victim:GetModifierStackCount("modifier_hood_of_defiler_armor_loss", ability)
    local additionalArmorLoss = math.ceil(victim:GetPhysicalArmorValue(false) * HOOD_OF_DEFILER_ARMOR_REDUCTION/100)
    if origStacks >= HOOD_OF_DEFILER_POST_MITI_MAX_STACKS then
        additionalArmorLoss = 0
    end
    ability:ApplyDataDrivenModifier(attacker.InventoryUnit, victim, "modifier_hood_of_defiler_armor_loss", {duration = HOOD_OF_DEFILER_DURATION})
    victim:SetModifierStackCount("modifier_hood_of_defiler_armor_loss", ability, currentArmorLoss + additionalArmorLoss)

    local origStacks = victim:GetModifierStackCount("modifier_hood_of_defiler_effect_visible", ability)
    local newStacks = math.min(origStacks + 1, HOOD_OF_DEFILER_POST_MITI_MAX_STACKS)
    ability:ApplyDataDrivenModifier(attacker.InventoryUnit, victim, "modifier_hood_of_defiler_effect_visible", {duration = HOOD_OF_DEFILER_DURATION})
    victim:SetModifierStackCount("modifier_hood_of_defiler_effect_visible", ability, newStacks)

    local casterStacks = attacker:GetModifierStackCount("modifier_hood_of_defiler_buff", attacker.InventoryUnit)
    local newCasterStacks = math.min(casterStacks + 1, HOOD_OF_DEFILER_MAX_STACKS_BONUS_DMG)
    ability:ApplyDataDrivenModifier(attacker.InventoryUnit, attacker, "modifier_hood_of_defiler_buff", {duration = 9})
    attacker:SetModifierStackCount("modifier_hood_of_defiler_buff", attacker.InventoryUnit, newCasterStacks)
end

function Filters:FarSeerGloves(attacker, damage, inflictor)
    local ability = attacker.handItem
    -- if inflictor then
    --     local abilityName = EntIndexToHScript(inflictor):GetAbilityName()
    --     if abilityName == "item_rpc_omega_ruby" or abilityName == "item_rpc_warlord_glyph_7_1" then
    --         return false
    --     end
    -- end
    attacker.handItem:ApplyDataDrivenModifier(attacker.InventoryUnit, attacker, "modifier_far_seer_effect", {duration = FARSEER_DURATION})
    local maximum = 0
    local primeAttribute = attacker:GetPrimaryAttribute()
    if primeAttribute == 0 then
        maximum = attacker:GetStrength() * FARSEER_PRIMARY_ATT_CAP
    elseif primeAttribute == 1 then
        maximum = attacker:GetAgility() * FARSEER_PRIMARY_ATT_CAP
    elseif primeAttribute == 2 then
        maximum = attacker:GetIntellect() * FARSEER_PRIMARY_ATT_CAP
    end
    local stacks = math.min(math.floor(damage * FARSEER_PRE_MITI_MAGIC_BASE), maximum)

    modifier = attacker:FindModifierByName("modifier_far_seer_effect")
    ----print("FarSeerGloves "..modifier:GetStackCount())
    local oldStacks = modifier:GetStackCount()
    stacks = math.max (stacks, oldStacks)
    attacker:SetModifierStackCount("modifier_far_seer_effect", attacker.handItem, stacks)
end

function Filters:EmeraldDouliHit(victim, damage)
    if damage > 0 then
        local manaDamage = damage * (EMERALD_DOULI_ABSORBED_DMG_PCT / 100) / EMERALD_DOULI_DMG_ABSORB_PER_MANA
        local normalDamage = damage * (1 - EMERALD_DOULI_ABSORBED_DMG_PCT / 100)
        local availableMana = victim:GetMana() - victim:GetMaxMana() * EMERALD_DOULI_MANA_THRESHOLD_PCT / 100
        if availableMana > manaDamage then
            victim:ReduceMana(manaDamage)
            return normalDamage
        else
            victim:ReduceMana(availableMana)
            return (manaDamage - availableMana) * EMERALD_DOULI_DMG_ABSORB_PER_MANA + normalDamage
        end
    else
        return 0
    end
end

function Filters:SpellShieldHit(victim, damage)
    local splicedDamage = damage * ARKIMUS_GLYPH_5_1_MANA_DAMAGE_PART_PCT/100
    local manaDamage = splicedDamage * (100-ARKIMUS_GLYPH_5_1_MANA_DAMAGE_REDUCTION)/100
    local bSplice = true
    if manaDamage > victim:GetMana() then
        manaDamage = victim:GetMana()
        bSplice = false
    end
    victim:ReduceMana(manaDamage)
    if bSplice then
        return splicedDamage
    else
        return manaDamage /(100-ARKIMUS_GLYPH_5_1_MANA_DAMAGE_REDUCTION)/100
    end
end

function Filters:HasDamageBlockShield(victim)
    if victim:HasModifier("modifier_secret_temple_refraction") or victim:HasModifier("modifier_windsteel_effect") or victim:HasModifier("modifier_heavens_shield") or victim:HasModifier("modifier_shipyard_veil_shield") or victim:HasModifier("modifier_arcane_shell") or victim:HasModifier("modifier_duskbringer_rune_e_2_effect") or victim:HasModifier("modifier_paladin_q3_shield") or victim:HasModifier("modifier_voltex_rune_w_3_shield") or victim:HasModifier("modifier_light_seer_shield") or victim:HasModifier("modifier_black_dominion_shield") then
        return true
    else
        return false
    end
end

function Filters:EarthGuardian(victim, damage)
    local caster = victim
    local particleName = "particles/items_fx/brown_lightning.vpcf"
    local splitDamage = damage * 0.5
    if caster.earthAspect then
        if not caster.earthAspect.linkParticleCount then
            caster.earthAspect.linkParticleCount = 0
        end
        local aspect = caster.earthAspect
        if caster.earthAspect.linkParticleCount < 4 then
            caster.earthAspect.linkParticleCount = caster.earthAspect.linkParticleCount + 1
            local origin = aspect:GetAbsOrigin()
            local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
            ParticleManager:SetParticleControl(lightningBolt, 0, Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z))
            ParticleManager:SetParticleControl(lightningBolt, 1, Vector(origin.x, origin.y, origin.z + aspect:GetBoundingMaxs().z))
            Timers:CreateTimer(1, function()
                if caster.earthAspect then
                    if IsValidEntity(caster.earthAspect) then
                        caster.earthAspect.linkParticleCount = caster.earthAspect.linkParticleCount - 1
                    end
                end
                ParticleManager:DestroyParticle(lightningBolt, false)
                ParticleManager:ReleaseParticleIndex(lightningBolt)
            end)
            -- Damage
        elseif caster.earthAspect.linkParticleCount > 20 then
            caster.earthAspect.linkParticleCount = 0
        end
        --print(splitDamage)
        ApplyDamage({victim = aspect, attacker = aspect, damage = splitDamage, damage_type = DAMAGE_TYPE_PURE})
    end

end

function Filters:WindSteelTakeDamage(victim, damage)
    --print("WINDSTEEL HIT")
    local stackCount = victim:GetModifierStackCount("modifier_windsteel_effect", victim.body)
    if stackCount >= 1 then
        victim:SetModifierStackCount("modifier_windsteel_effect", victim.body, stackCount - 1)
    else
        victim:RemoveModifierByName("modifier_windsteel_effect")
    end
    return 0
end

function Filters:SecretTempleTakeDamage(target, damage)
    local stackCount = target:GetModifierStackCount("modifier_secret_temple_refraction", target.refractionItem)
    if stackCount > 1 then
        target:SetModifierStackCount("modifier_secret_temple_refraction", target.refractionItem, stackCount - 1)
    else
        target:RemoveModifierByName("modifier_secret_temple_refraction")
    end
    return 0
end

function Filters:SoluniaGlyph51TakeDamage(target, damage)
    local stackCount = target:GetModifierStackCount("modifier_solunia_glyph_5_1_shield", target)
    local ability = target:FindModifierByName("modifier_solunia_glyph_5_1"):GetAbility()
    if stackCount > 1 then
        target:SetModifierStackCount("modifier_solunia_glyph_5_1_shield", ability, stackCount - 1)
    else
        target:RemoveModifierByName("modifier_solunia_glyph_5_1_shield")
    end
    return 0
end

function Filters:HeavensShieldTakeDamage(target, damage)
    local stackCount = target:GetModifierStackCount("modifier_heavens_shield", target.heavensShieldSource)
    if stackCount > 1 then
        target:SetModifierStackCount("modifier_heavens_shield", target.heavensShieldSource, stackCount - 1)
    else
        target:RemoveModifierByName("modifier_heavens_shield")
    end
    return 0
end

function Filters:ModifyBladestormVestSwordCount(attacker, numSwords, ability, caster)
    for j = 1, #attacker.bladeTable, 1 do
        UTIL_Remove(attacker.bladeTable[j])
    end
    attacker.bladeTable = {}
    if numSwords == 0 then
        attacker:RemoveModifierByName("modifier_bladestorm_vest_buff")
    else
        for i = 1, numSwords, 1 do
            local sword = CreateUnitByName("tracer_unit", attacker:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
            sword.hero = attacker
            sword.owner = attacker:GetPlayerOwnerID()
            sword.interval = 0
            sword.state = 0
            sword:SetModel("models/props_gameplay/status_disarm.vmdl")
            sword:SetOriginalModel("models/props_gameplay/status_disarm.vmdl")
            sword:SetModelScale(2.0)
            table.insert(attacker.bladeTable, sword)
            ability:ApplyDataDrivenModifier(caster, sword, "modifier_bladestorm_vest_weapon_effect", {})
            sword.index = i
            local offsetRadians = (2 * math.pi / 3) * (i - 1)
            sword.offsetVector = WallPhysics:rotateVector(Vector(1, 1), offsetRadians)
            sword:SetOwner(attacker)
            sword:SetControllableByPlayer(attacker:GetPlayerID(), true)
        end
    end
end

function Filters:AerithsTearTakeDamage(attacker, victim)
    local distance = CalcDistanceBetweenEntityOBB(attacker, victim)
    if distance <= AERITHS_TEAR_DISTANCE then
        return true
    else
        return false
    end
end

function Filters:GrithaultDamage(victim, damage)
    local proc = Filters:GetProc(victim, GRITHAULT_CHANCE)
    if proc then
        damage = math.floor(damage)
        Filters:ApplyHeal(victim, victim, damage, true)
        CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_oracle/grithault_heal.vpcf", victim, 0.9)
        return 0
    else
        return damage
    end
end

function Filters:GeodeDealDamage(victim, damage, attacker)
    if victim:GetEntityIndex() == attacker:GetEntityIndex() then
        return damage
    end
    if damage < victim:GetMaxHealth() * GEODE_INSTANCE_THRESHOLD/100 then
        local ability = attacker.amulet
        if not ability.particles then
            ability.particles = 0
        end
        if ability.particles < 6 then
            CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_oracle/fractional_geode_effect.vpcf", victim, 0.8)
            EmitSoundOn("Items.Geode", victim)
            ability.particles = ability.particles + 1
            Timers:CreateTimer(1.5, function()
                ability.particles = ability.particles - 1
            end)
        end
        return damage * GEODE_DAMAGE_MULT
    else
        return damage
    end
end

function Filters:TwigTakeDamage(damage, victim)
    if victim.manaShellAbsorb >= damage then
        victim.manaShellAbsorb = victim.manaShellAbsorb - damage
        damage = 0
    else
        damage = math.max(damage - victim.manaShellAbsorb, 0)
    end
    return damage
end

function Filters:ElderGraspTakeDamage(damage, victim)
    if victim.elder_grasp_shield >= damage then
        victim.elder_grasp_shield = victim.elder_grasp_shield - damage
        local alpha = (victim.elder_grasp_shield / victim.elder_grasp_max_shield) * 255
        ParticleManager:SetParticleControl(victim.elderShieldParticle, 1, Vector(alpha, alpha, alpha))
        damage = 0
    else
        victim.elder_grasp_shield = 0
        victim:RemoveModifierByName('modifier_grasp_of_elder_shield')
        ParticleManager:DestroyParticle(victim.elderShieldParticle, false)
        victim.elderShieldParticle = nil
        damage = math.max(damage - victim.elder_grasp_shield, 0)
    end
    return damage
end

function Filters:PureWaters(caster)
    if not caster:HasModifier("modifier_boots_of_pure_waters_cooldown") then

        local fv = caster:GetForwardVector()
        CustomAbilities:QuickAttachParticle("particles/items3_fx/mango_active.vpcf", caster, 3)
        caster:GiveMana(caster:GetMaxMana() * PURE_WATERS_MANA_RESTORE_PCT/100)
        local ability = caster.foot
        ability:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_boots_of_pure_waters_cooldown", {duration = PURE_WATERS_INTERVAL_RESTRICTION})
        ability.caster = caster
        local projectileParticle = "particles/units/heroes/hero_morphling/morphling_waveform.vpcf"
        local start_radius = 190
        local end_radius = 190
        local range = 850
        local speed = 700
        local info =
        {
            Ability = ability,
            EffectName = projectileParticle,
            vSpawnOrigin = caster:GetAbsOrigin() + Vector(0, 0, 80),
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
            fExpireTime = GameRules:GetGameTime() + 4.0,
            bDeleteOnHit = false,
            vVelocity = fv * speed,
            bProvidesVision = false,
        }
        projectile = ProjectileManager:CreateLinearProjectile(info)
        EmitSoundOn("Items.PureWaters", caster)
    end
end

function Filters:SweepingWindStack(caster)
    local particleName = "particles/items2_fx/sweeping_winds_2.vpcf"
    caster.handItem:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_sweeping_wind_stackable", {duration = 12})
    local currentStacks = caster:GetModifierStackCount("modifier_sweeping_wind_stackable", caster.InventoryUnit)
    local newStacks = math.min(currentStacks + 1, 5)
    caster:SetModifierStackCount("modifier_sweeping_wind_stackable", caster.InventoryUnit, newStacks)
    if not caster.handItem.windParticle then
        caster.handItem.windParticle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
        ParticleManager:SetParticleControlEnt(caster.handItem.windParticle, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
        StartSoundEvent("Items.SweepingWind", caster)
    end
    ParticleManager:SetParticleControl(caster.handItem.windParticle, 3, Vector(newStacks * 50, newStacks * 50, newStacks * 50))
end

function Filters:ShatterArcaneShell(victim, attacker)
    local currentStacks = victim:GetModifierStackCount("modifier_arcane_shell", victim.runeUnit)
    if currentStacks > 1 then
        victim:SetModifierStackCount("modifier_arcane_shell", victim.runeUnit, currentStacks - 1)
    else
        victim:RemoveModifierByName("modifier_arcane_shell")
        CustomAbilities:QuickAttachParticle("particles/roshpit/sorceress/shield_shatter.vpcf", victim, 1.2)
    end
    if victim:GetTeamNumber() == attacker:GetTeamNumber() then
    else
        EmitSoundOn("Sorceress.ArcaneShellZap", attacker)
        local w_1_level = Runes:GetTotalRuneLevel(victim, 1, "w_1", "sorceress")
        local damage = w_1_level * victim:GetIntellect() * SORCERESS_W1_DMG_INT_MULT
        Filters:TakeArgumentsAndApplyDamage(attacker, victim, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_ARCANE, RPC_ELEMENT_NONE)

        local particleName = "particles/roshpit/sorceress_arcane_shield_blast.vpcf"
        local pfx = ParticleManager:CreateParticle(particleName, PATTACH_POINT, victim)
        ParticleManager:SetParticleControlEnt(pfx, 0, victim, PATTACH_POINT, "attach_hitloc", victim:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(pfx, 1, attacker, PATTACH_POINT, "attach_hitloc", attacker:GetAbsOrigin(), true)
        Timers:CreateTimer(0.5, function()
            ParticleManager:DestroyParticle(pfx, false)
        end)

        local arcaneExplosionAbility = victim:FindAbilityByName("arcane_explosion")
        if not arcaneExplosionAbility then
            arcaneExplosionAbility = victim:FindAbilityByName("arcane_torrent")
        end
        if arcaneExplosionAbility then
            local ability = arcaneExplosionAbility
            local caster = victim
            local target = attacker
            local w_2_level = Runes:GetTotalRuneLevel(victim, 2, "w_2", "sorceress")
            if w_2_level > 0 then
                -- local arcane_explosion = caster:FindAbilityByName("arcane_explosion")
                ability:ApplyDataDrivenModifier(caster, target, "modifier_sorceress_rune_w_2_invisible", {duration = 9})
                ability:ApplyDataDrivenModifier(caster, target, "modifier_sorceress_rune_w_2", {duration = 9})
                local newStacks = math.min(target:GetModifierStackCount("modifier_sorceress_rune_w_2", caster) + 1, 10)
                target:SetModifierStackCount("modifier_sorceress_rune_w_2", ability, newStacks)
                target:SetModifierStackCount("modifier_sorceress_rune_w_2_invisible", ability, newStacks * w_2_level)
            end
        end
    end
end

function Filters:MysticWaterShield(victim)
    local currentStacks = victim:GetModifierStackCount("modifier_hydroxis_b_a_shield_visible", victim) + victim:GetModifierStackCount("modifier_hydroxis_b_a_shield_visible_glyphed", victim)
    if currentStacks > 1 then
        if victim:HasModifier("modifier_hydroxis_b_a_shield_visible") then
            victim:SetModifierStackCount("modifier_hydroxis_b_a_shield_visible", victim, currentStacks - 1)
        elseif victim:HasModifier("modifier_hydroxis_b_a_shield_visible_glyphed") then
            victim:SetModifierStackCount("modifier_hydroxis_b_a_shield_visible_glyphed", victim, currentStacks - 1)
        end
    else
        victim:RemoveModifierByName("modifier_hydroxis_b_a_shield_visible")
        victim:RemoveModifierByName("modifier_hydroxis_b_a_shield_visible_glyphed")
    end
end

function Filters:HitAxeCCShield(victim, attacker)
    local currentStacks = victim:GetModifierStackCount("modifier_axe_rune_r_3_shield", victim)
    if currentStacks > 1 then
        victim:SetModifierStackCount("modifier_axe_rune_r_3_shield", victim, currentStacks - 1)
    else
        victim:RemoveModifierByName("modifier_axe_rune_r_3_shield")
        CustomAbilities:QuickAttachParticle("particles/roshpit/sorceress/shield_shatter.vpcf", victim, 1.2)
    end
end

function Filters:GhostArmor(victim, attacker)
    local currentStacks = victim:GetModifierStackCount("modifier_duskbringer_rune_e_2_effect", victim)
    if currentStacks > 1 then
        victim:SetModifierStackCount("modifier_duskbringer_rune_e_2_effect", victim, currentStacks - 1)
    else
        victim:RemoveModifierByName("modifier_duskbringer_rune_e_2_effect")
    end

    EmitSoundOn("Duskbringer.GhostArmor.Impact", attacker)

end

function Filters:ShatterPaladinShell(victim, attacker)
    local currentStacks = victim:GetModifierStackCount("modifier_paladin_q3_shield", victim)
    if currentStacks > 1 then
        victim:SetModifierStackCount("modifier_paladin_q3_shield", victim, currentStacks - 1)
    else
        victim:RemoveModifierByName("modifier_paladin_q3_shield")
    end
    if victim:GetTeamNumber() == attacker:GetTeamNumber() then
    else
        EmitSoundOn("Paladin.AegisZap", attacker)
        local q_3_level = victim:GetRuneValue("q", 3)
        local damage = PALADIN_Q3_DMG_PER_STR * q_3_level * victim:GetStrength()
        Filters:TakeArgumentsAndApplyDamage(attacker, victim, damage, DAMAGE_TYPE_MAGICAL, BASE_ITEM, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)

        local particleName = "particles/roshpit/paladin_aegis_zap.vpcf"
        local pfx = ParticleManager:CreateParticle(particleName, PATTACH_POINT, victim)
        ParticleManager:SetParticleControlEnt(pfx, 0, victim, PATTACH_POINT, "attach_hitloc", victim:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(pfx, 1, attacker, PATTACH_POINT, "attach_hitloc", attacker:GetAbsOrigin(), true)
        Timers:CreateTimer(0.5, function()
            ParticleManager:DestroyParticle(pfx, false)
        end)
    end
end

function Filters:ShatterVoltexShell(victim, attacker)
    local currentStacks = victim:GetModifierStackCount("modifier_voltex_rune_w_3_shield", victim)
    if currentStacks > 1 then
        victim:SetModifierStackCount("modifier_voltex_rune_w_3_shield", victim, currentStacks - 1)
    else
        victim:RemoveModifierByName("modifier_voltex_rune_w_3_shield")
    end
    if victim:GetTeamNumber() == attacker:GetTeamNumber() then
    else
        EmitSoundOn("Voltex.IonShellZap", attacker)
        local w_3_level = victim:GetRuneValue("w", 3)
        local damage = VOLTEX_W3_DMG_PER_AGI * w_3_level * victim:GetAgility()
        Filters:TakeArgumentsAndApplyDamage(attacker, victim, damage, DAMAGE_TYPE_MAGICAL, BASE_ITEM, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)

        local particleName = "particles/roshpit/voltex_shell_zap.vpcf"
        local pfx = ParticleManager:CreateParticle(particleName, PATTACH_POINT, victim)
        ParticleManager:SetParticleControlEnt(pfx, 0, victim, PATTACH_POINT, "attach_hitloc", victim:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(pfx, 1, attacker, PATTACH_POINT, "attach_hitloc", attacker:GetAbsOrigin(), true)
        Timers:CreateTimer(0.5, function()
            ParticleManager:DestroyParticle(pfx, false)
        end)
    end
end

function Filters:WarlordTakeMagicDamage(warlord)
    local newStacks = warlord:GetModifierStackCount("modifier_warlord_ice_shell", warlord) - 1
    warlord:SetModifierStackCount("modifier_warlord_ice_shell", warlord, newStacks)
    if newStacks <= 0 then
        warlord:RemoveModifierByName("modifier_warlord_ice_shell")
    end
end

function Filters:WarlordTakePureDamage(warlord)
    local newStacks = warlord:GetModifierStackCount("modifier_warlord_ice_shell_pure", warlord) - 1
    warlord:SetModifierStackCount("modifier_warlord_ice_shell_pure", warlord, newStacks)
    if newStacks <= 0 then
        warlord:RemoveModifierByName("modifier_warlord_ice_shell_pure")
    end
end

function Filters:NightmareRider(caster)
    local shadowCharges = caster:GetModifierStackCount("modifier_nightmare_rider_stacks", caster.InventoryUnit)
    local shadowRadius = NIGHTMARE_RIDER_RADIUS + shadowCharges * NIGHTMARE_RIDER_RADIUS_INCREASE
    local origin = caster:GetAbsOrigin()
    caster:RemoveModifierByName("modifier_nightmare_rider_stacks")
    local particleName = "particles/roshpit/items/nightmare_rider_mantle_cowlofice.vpcf"
    local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
    local origin = caster:GetAbsOrigin()
    ParticleManager:SetParticleControl(particle1, 0, origin + Vector(0, 0, 20))
    ParticleManager:SetParticleControl(particle1, 1, Vector(shadowRadius, 2, shadowRadius))
    ParticleManager:SetParticleControl(particle1, 3, Vector(shadowRadius, shadowRadius, shadowRadius))
    Timers:CreateTimer(3, function()
        ParticleManager:DestroyParticle(particle1, false)
    end)
    local ability = caster.body
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), origin, nil, shadowRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    if #enemies > 0 then
        for _, enemy in pairs(enemies) do
            enemy:RemoveModifierByName("modifier_nightmare_rider_invisible")
            ability:ApplyDataDrivenModifier(caster.InventoryUnit, enemy, "modifier_nightmare_rider_effect_visible", {duration = NIGHTMARE_RIDER_DEBUFF_DURATION})
            local armorLossStacks = enemy:GetPhysicalArmorValue(false) * NIGHTMARE_RIDER_ARMOR_REDUCTION/100
            ability:ApplyDataDrivenModifier(caster.InventoryUnit, enemy, "modifier_nightmare_rider_invisible", {duration = NIGHTMARE_RIDER_DEBUFF_DURATION})
            enemy:SetModifierStackCount("modifier_nightmare_rider_invisible", caster.InventoryUnit, armorLossStacks)
        end
    end
    local iceSound = "Item.NightmareRider1"
    if shadowCharges > 13 then
        iceSound = "Item.NightmareRider3"
    elseif shadowCharges > 6 then
        iceSound = "Item.NightmareRider2"
    end
    EmitSoundOn(iceSound, caster)
end

function Filters:AuriunImmortalWeapon1(damage, victim)
    if not victim:HasModifier("modifier_auriun_immortal_weapon_1_cooldown") then
        damage = 0
        victim.weapon:ApplyDataDrivenModifier(victim.InventoryUnit, victim, "modifier_auriun_immortal_weapon_1_cooldown", {duration = AURIUN_IMMO_WEAPON_1_CD})
        victim.weapon:ApplyDataDrivenModifier(victim.InventoryUnit, victim, "modifier_auriun_immortal_phased", {duration = AURIUN_IMMO_WEAPON_1_DURATION})
    end
    return damage
end

function Filters:AutumnSleeperMask(caster)
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, AUTUMN_SLEEPER_RADIUS_R, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    if #enemies > 0 then
        for _, enemy in pairs(enemies) do
            caster.headItem:ApplyDataDrivenModifier(caster, enemy, "modifier_autumn_sleeper_root", {duration = AUTUMN_SLEEPER_ROOT_DUR_R})
        end
    end
    local particle = "particles/roshpit/items/autumn_sleeper_cast_th_cast.vpcf"
    local pfx = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(pfx, 1, Vector(1200, 2, 2400))
    Timers:CreateTimer(3.5, function()
        ParticleManager:DestroyParticle(pfx, false)
    end)
    EmitSoundOn("Item.AutumnSleeperUlt", caster)
end

function Filters:ManawallDamageTaken(victim, damage)
    local reducedDamage = damage * 0.25
    local currentMana = victim:GetMana()
    if currentMana >= reducedDamage then
        victim:ReduceMana(reducedDamage)
        return 0
    else
        local newDamage = reducedDamage - currentMana
        victim:ReduceMana(currentMana)
        return newDamage * 4
    end
end

function Filters:FireDeity(attacker, victim, damage)
    local proc = Filters:GetProc(attacker, FIRE_DEITY_CROWN_CHANCE)
    if proc then
        damage = damage * FIRE_DEITY_CROWN_AMP/100
        local target = victim
        local radius = FIRE_DEITY_CROWN_AOE

        local limitKey = attacker:GetPlayerOwnerID() .. '_fire_deity'
        Util.Common:LimitPerTime(4, 1, limitKey, function()
            local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
            local particle2 = ParticleManager:CreateParticle(particleNameS, PATTACH_WORLDORIGIN, target)
            ParticleManager:SetParticleControl(particle2, 0, target:GetAbsOrigin())
            ParticleManager:SetParticleControl(particle2, 1, Vector(radius, radius, radius))
            ParticleManager:SetParticleControl(particle2, 2, Vector(1.0, 1.0, 1.0))
            ParticleManager:SetParticleControl(particle2, 4, Vector(255, 0, 0))
            Timers:CreateTimer(1.5, function()
                ParticleManager:DestroyParticle(particle2, false)
            end)

            local particleName = "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf"
            local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
            ParticleManager:SetParticleControl(particle1, 0, target:GetAbsOrigin())
            Timers:CreateTimer(2, function()
                ParticleManager:DestroyParticle(particle1, false)
            end)
            EmitSoundOn("RoshpitItem.FireDeity", target)
        end)
        local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
        if #enemies > 0 then
            for _, enemy in pairs(enemies) do
                Filters:ApplyStun(attacker, FIRE_DEITY_CROWN_STUN_DURATION, enemy)
                Filters:ApplyItemDamageBasedOnAbility(enemy, attacker, damage, DAMAGE_TYPE_MAGICAL, nil, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
            end
        end
        return true
    end
end

function Filters:ShipyardVeilQHit(attacker, victim)
    local ability = attacker.headItem
    if not ability.lock then
        ability.lock = true
        local maxStacks = SHIPYARD_VEIL_MAX_STACKS
        ability:ApplyDataDrivenModifier(attacker.InventoryUnit, attacker, "modifier_shipyard_veil_shield", {})
        local newStacks = math.min(maxStacks, attacker:GetModifierStackCount("modifier_shipyard_veil_shield", attacker.InventoryUnit) + 1)
        attacker:SetModifierStackCount("modifier_shipyard_veil_shield", attacker.InventoryUnit, newStacks)
        Timers:CreateTimer(SHIPYARD_SHIELD_COOLDOWN, function()
            ability.lock = false
        end)
    end

end

function Filters:DoomplateSummon(caster)
    if not caster:HasModifier("modifier_doomplate_cooldown") then
        local particleName = "particles/units/heroes/hero_doom_bringer/doom_intro_ring.vpcf"
        local particleLoc = caster:GetAbsOrigin()
        local pentagramParticle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
        ParticleManager:SetParticleControl(pentagramParticle, 0, particleLoc)
        ParticleManager:SetParticleControl(pentagramParticle, 1, particleLoc)
        ParticleManager:SetParticleControl(pentagramParticle, 4, particleLoc)

        caster.body:ApplyDataDrivenModifier(caster, caster, "modifier_doomplate_cooldown", {duration = 28})
        local boss = CreateUnitByName("doomplate_doom", caster:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_NEUTRALS)
        Filters:SetupSummonUnit(caster, caster:GetAbsOrigin(), 2, 5, 30, 2, boss)

        boss:SetForwardVector(Vector(0, -1))
        boss:SetAbsOrigin(boss:GetAbsOrigin() + Vector(0, 0, 1000))
        boss.state = 0
        boss.jumpEnd = "doom_boss"
        boss.caster = caster
        WallPhysics:Jump(boss, Vector(0, 0), 0, 30, 1, 0.7)

        local bossAbil = boss:FindAbilityByName("doomplate_doom_ability")
        bossAbil:ApplyDataDrivenModifier(boss, boss, "modifier_doom_intro_cinematic", {duration = 8.3})
        Timers:CreateTimer(2.5, function()
            StartAnimation(boss, {duration = 2.5, activity = ACT_DOTA_SPAWN, rate = 0.4})
            Timers:CreateTimer(0.4, function()
                EmitSoundOn("RPCItem.Doomplate.VO1", caster)
            end)
        end)

        Timers:CreateTimer(5.1, function()
            StartAnimation(boss, {duration = 2.8, activity = ACT_DOTA_TELEPORT, rate = 1.7})
            Timers:CreateTimer(0.1, function()
                for i = 1, 5, 1 do
                    Timers:CreateTimer((2.8 / 5) * i, function()
                        ScreenShake(boss:GetAbsOrigin(), 400, 0.4, 0.8, 9000, 0, true)
                    end)
                end
                EmitSoundOn("RPCItem.Doomplate.VO2", caster)
            end)
        end)

        Timers:CreateTimer(8.9, function()
            EmitSoundOn("RPCItem.Doomplate.VO3", caster)
            boss.active = true
            ParticleManager:DestroyParticle(pentagramParticle, false)
        end)

    end
    -- "doomplate_doom"
end

function Filters:IgneousCanine(caster)
    local particleName = "particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_aftershock_egset.vpcf"
    local ability = caster.headItem
    ability.hero = caster
    local pfx = ParticleManager:CreateParticle("particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_echoslam_start_fallback_mid_egset.vpcf", PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
    Timers:CreateTimer(2, function()
        ParticleManager:DestroyParticle(pfx, false)
    end)
    local wAbilityLevel = caster:GetAbilityByIndex(DOTA_W_SLOT):GetLevel()
    local stunDuration = wAbilityLevel * IGNEOUS_CANINE_STUN_DURATION
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, IGNEOUS_CANINE_AOE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "RPCItem.IgneousCanine", caster.InventoryUnit)
    if #enemies > 0 then
        for _, enemy in pairs(enemies) do
            Filters:ApplyStun(caster, stunDuration, enemy)
        end
    end
    if not ability.firePools then
        ability.firePools = 0
    end
    if ability.firePools < 4 then
        ability.firePools = ability.firePools + 1
        --ability:ApplyDataDrivenThinker(caster, caster:GetAbsOrigin(), "modifier_igneous_canine_thinker", {})
        CustomAbilities:QuickAttachThinker(ability, caster, caster:GetAbsOrigin(), "modifier_igneous_canine_thinker", {})
        Timers:CreateTimer(6, function()
            ability.firePools = ability.firePools - 1
        end)
    end
end

function Filters:AzureEmpire(victim, attacker)
    local currentStacks = victim:GetModifierStackCount("modifier_azure_empire_visible", victim.InventoryUnit)
    if currentStacks > 1 then
        victim:SetModifierStackCount("modifier_azure_empire_visible", victim.InventoryUnit, currentStacks - 1)
    else
        victim:RemoveModifierByName("modifier_azure_empire_visible")
    end
    local birdTable = victim.birdTable
    if birdTable then
        for i = 1, PENDANT_AZURE_EMPIRE_NUMBER_OF_HAWKS, 1 do
            if not birdTable[i]:HasModifier("modifier_azure_hawk_dead") then
                CustomAbilities:QuickAttachParticle("particles/roshpit/items/azure_hawk_impact.vpcf", birdTable[i], 1.5)
                EmitSoundOn("RPCItem.AzureEmpireHit", birdTable[i])
                victim.amulet:ApplyDataDrivenModifier(victim.InventoryUnit, birdTable[i], "modifier_azure_hawk_dead", {duration = PENDANT_AZURE_EMPIRE_HAWK_CD})
                EndAnimation(birdTable[i])
                StartAnimation(birdTable[i], {duration = 0.8, activity = ACT_DOTA_DIE, rate = 1.3})
                ParticleManager:DestroyParticle(birdTable[i].pfx, false)
                ParticleManager:ReleaseParticleIndex(birdTable[i].pfx)
                for j = 1, 20, 1 do
                    Timers:CreateTimer(j * 0.03, function()
                        birdTable[i]:SetAbsOrigin(birdTable[i]:GetAbsOrigin() - Vector(0, 0, 10))
                    end)
                end
                Timers:CreateTimer(0.75, function()
                    birdTable[i]:RemoveModifierByName("modifier_azure_hawk_silver")
                    birdTable[i]:RemoveModifierByName("modifier_azure_hawk_red")
                    birdTable[i]:RemoveModifierByName("modifier_azure_hawk_blue")
                    birdTable[i]:RemoveModifierByName("modifier_azure_hawk_green")
                    birdTable[i]:AddNoDraw()
                end)
                break
            end
        end
    end
end

function Filters:PhoenixEmblem(victim)
    local caster = victim
    local ability = victim.amulet
    local inventoryUnit = victim.InventoryUnit
    if not caster:HasModifier("modifier_phoenix_emblem_cooldown") then
        local rezPosition = caster:GetAbsOrigin()
        ability.rezPosition = rezPosition
        caster:SetAbsOrigin(rezPosition)

        caster:AddNoDraw()
        caster:SetAbsOrigin(caster:GetAbsOrigin() - Vector(0, 0, 1600))
        local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
        Timers:CreateTimer(5.01, function()
            ability:ApplyDataDrivenModifier(inventoryUnit, caster, "modifier_phoenix_emblem_cooldown", {duration = 15})
        end)
        ability:ApplyDataDrivenModifier(inventoryUnit, caster, "modifier_phoenix_rebirthing", {duration = 5})
        gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, caster, "modifier_disable_player", {duration = 5})
        caster:SetAbsOrigin(rezPosition)
        local playerID = caster:GetPlayerID()
        if playerID then
            --print("WE HERE?? BREZ!!")
            PlayerResource:SetCameraTarget(playerID, caster)
        end
        Timers:CreateTimer(2, function()
            caster:SetAbsOrigin(rezPosition)
            if playerID then
                PlayerResource:SetCameraTarget(playerID, nil)
            end
        end)

        local egg = CreateUnitByName("npc_dummy_unit", rezPosition, true, caster, caster, caster:GetTeamNumber())
        egg:FindAbilityByName("dummy_unit"):SetLevel(1)
        egg:SetModelScale(1.4)
        egg:SetOriginalModel("models/phoenix_egg_hitbox.vmdl")
        egg:SetModel("models/phoenix_egg_hitbox.vmdl")
        egg:SetAbsOrigin(egg:GetAbsOrigin() - Vector(0, 0, 80))
        egg.hero = caster
        ability:ApplyDataDrivenModifier(inventoryUnit, egg, "modifier_egg_reviving", {duration = 5})
        AddFOWViewer(caster:GetTeamNumber(), rezPosition, 800, 8, false)
    end
end

function Filters:VioletGuard2Hit(victim, attacker, damage)
    attacker.body:ApplyDataDrivenModifier(attacker.InventoryUnit, victim, "modifier_violet_guard_armor_loss_visible", {duration = VIOLET_GUARD_ARMOR_DURATION})
    local oldModifier = victim:FindModifierByName("modifier_violet_guard_armor_loss_invisible")
    local armorLoss = 0
    if oldModifier then
        local oldModifierStacks = oldModifier:GetStackCount()
    end
    if oldModifierStacks then
        armorLoss = math.min(math.ceil(damage * VIOLET_GUARD_ARMOR_DAMAGE_TO_ARMOR_REDUCTION), victim:GetPhysicalArmorValue(false) + oldModifierStacks)
        armorLoss = math.max(1, armorLoss)
        armorLoss = math.max(armorLoss, oldModifierStacks)
    else
        armorLoss = math.min(math.ceil(damage * VIOLET_GUARD_ARMOR_DAMAGE_TO_ARMOR_REDUCTION), victim:GetPhysicalArmorValue(false))
        armorLoss = math.max(1, armorLoss)
    end
    attacker.body:ApplyDataDrivenModifier(attacker.InventoryUnit, victim, "modifier_violet_guard_armor_loss_invisible", {duration = VIOLET_GUARD_ARMOR_DURATION})
    victim:SetModifierStackCount("modifier_violet_guard_armor_loss_invisible", attacker.InventoryUnit, armorLoss)
end

function Filters:TimeWarp(caster)
    local ability = caster.foot
    local timeItem = ability
    if not caster:HasModifier("modifier_temporal_warp_cooldown") then
        ability:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_temporal_warp_cooldown", {duration = 3.5})
        EmitSoundOn("RPCItem.TimeWarp.Start", caster)
        CustomAbilities:QuickAttachParticle("particles/roshpit/items/temporal_warp.vpcf", caster, 3)
        Timers:CreateTimer(0.3, function()
            CustomAbilities:QuickAttachParticle("particles/roshpit/items/temporal_warp.vpcf", caster, 3)
        end)
        local dataIndex = (ability.interval + 1) % 40
        if dataIndex == 0 then
            dataIndex = 1
        end
        local timeData = timeItem.dataTable[dataIndex]
        Timers:CreateTimer(0.05, function()
            if timeData then
                caster:SetHealth(math.max(timeData[2], 1))
                caster:SetMana(timeData[1])
                caster:SetAbsOrigin(timeData[3])
                local cd1 = Filters:GetCDNoHood(caster, timeData[4])
                local cd2 = Filters:GetCDNoHood(caster, timeData[5])
                local cd4 = Filters:GetCDNoHood(caster, timeData[6])
                if cd1 > 0 then
                    caster:GetAbilityByIndex(DOTA_Q_SLOT):StartCooldown(cd1)
                else
                    caster:GetAbilityByIndex(DOTA_Q_SLOT):EndCooldown()
                end
                if cd2 > 0 then
                    caster:GetAbilityByIndex(DOTA_W_SLOT):StartCooldown(cd2)
                else
                    caster:GetAbilityByIndex(DOTA_W_SLOT):EndCooldown()
                end
                if cd4 > 0 then
                    caster:GetAbilityByIndex(DOTA_R_SLOT):StartCooldown(cd4)
                else
                    caster:GetAbilityByIndex(DOTA_R_SLOT):EndCooldown()
                end
            end
        end)
    end
end

function Filters:BombThrow(caster)
    local bomb = caster.waterBomb
    if not bomb.thrown then
        bomb.thrown = true
        bomb.jumpEnd = "basic_land"
        WallPhysics:Jump(bomb, caster:GetForwardVector(), 17, 15, 22, 1.1)
        Timers:CreateTimer(3.0, function()
            caster:RemoveModifierByName("tanari_water_bomb_hero")
        end)
    end
end

function Filters:AlaranaFrostNova(caster)
    local position = caster:GetAbsOrigin()
    local particle = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
    local pfx = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
    local radius = ALARANA_EXPLOSION_RADIUS
    ParticleManager:SetParticleControl(pfx, 0, position)
    ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 2, radius * 2))
    Timers:CreateTimer(3, function()
        ParticleManager:DestroyParticle(pfx, false)
    end)

    EmitSoundOn("Ability.FrostNova", caster)
    local damage = caster:GetMaxHealth() * ALARANA_EXPLOSION_DAMAGE_OF_MAX_HP
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    local freezeDuration = ALARANA_ENEMY_FREEZE_DURATION
    if #enemies > 0 then
        for _, enemy in pairs(enemies) do
            Filters:ApplyItemDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, caster.foot, RPC_ELEMENT_ICE, RPC_ELEMENT_NONE)
            caster.foot:ApplyDataDrivenModifier(caster.InventoryUnit, enemy, "modifier_alarana_frost_nova", {duration = freezeDuration})
        end
    end
end

function Filters:IsIceFrozen(target)
    if target:HasModifier("modifier_ice_lance_frozen") or target:HasModifier("modifier_frost_nova") or target:HasModifier("modifier_eternal_frost_nova") or target:HasModifier("modifier_ice_throw_b_b_frozen") or target:HasModifier("modifier_elemental_overload_frozen") or target:HasModifier("modifier_alarana_frost_nova") or target:HasModifier("modifier_solunia_cryoshock") or target:HasModifier("modifier_elemental_freeze") or target:HasModifier("modifier_sorceress_arcana_b_d_visible") or target:HasModifier("modifier_hyperbeam_freeze") or target:HasModifier("modifier_ice_scathe_freeze") then
        return true
    else
        return false
    end
end

function Filters:IsFireBurning(target)
    if target:HasModifier("modifier_pyroblast_ignite") or
            target:HasModifier("modifier_fulminating_burn_effect") or
            target:HasModifier("modifier_flametongue_a_a_rune") or
            target:HasModifier("modifier_solunia_solar_burn") or
            target:HasModifier("modifier_on_fire_effect") or
            target:HasModifier("ruby_dragon_burn") or
            target:HasModifier("modifier_infernal_prison_effect_from_attack") or
            target:HasModifier("modifier_infernal_prison_nearby") or
            target:HasModifier("fire_walker_aura") or
            target:HasModifier("scorched_earth_aura") or
            target:HasModifier("modifier_ring_of_fire_burn") or
            target:HasModifier("modifier_sun_lance_burn") or
            target:HasModifier("modifier_jex_cipher_bolt_burn") or
            target:HasModifier("modifier_w_fire_fire_as_slow") or
            target:HasModifier("modifier_jex_e_fire_fire_burn") or
            target:HasModifier("modifier_cinderbark_burning") then
        return true
    else
        return false
    end
end

function Filters:ArkimusGlyph5a(victim, damage)
    if victim:HasAbility("arkimus_energy_field") then
        local ability = victim:FindAbilityByName("arkimus_energy_field")
        if ability then
            if ability.energyTable then
                if #ability.energyTable > 0 then
                    ability.energyTable[1]:RemoveModifierByName("modifier_energy_field_thinker")
                    ParticleManager:DestroyParticle(ability.energyTable[1].pfx, false)
                    Timers:CreateTimer(0.05, function()
                        local newTable = {}
                        for i = 1, #ability.energyTable, 1 do
                            if IsValidEntity(ability.energyTable[i]) then
                                table.insert(newTable, ability.energyTable[i])
                            end
                        end
                        ability.energyTable = newTable
                    end)
                    return 0
                else
                    return damage
                end
            else
                return damage
            end
        end
    end
end

function Filters:DarkEmissary(caster)
    CustomAbilities:QuickAttachParticle("particles/act_2/blob_launch_impact.vpcf", caster, 4)
    EmitSoundOn("RPCItem.DarkEmissary.Activate", caster)
    if not caster:HasModifier('modifier_dark_emissary_invise_delay') then
        caster.handItem:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_dark_emissary_invis", {duration = DARK_EMISSARY_INVIS_DURATION})
        caster.handItem:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_dark_emissary_invise_delay", {duration = DARK_EMISSARY_INVIS_CD})
    end
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, DARK_EMISSARY_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * DARK_EMISSARY_DAMAGE_MULT
    if #enemies > 0 then
        for _, enemy in pairs(enemies) do
            Filters:ApplyItemDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, caster.handItem, RPC_ELEMENT_GHOST, RPC_ELEMENT_NONE)
            caster.handItem:ApplyDataDrivenModifier(caster.InventoryUnit, enemy, "modifier_dark_emissary_root", {duration = DARK_EMISSARY_ROOT_DURATION})
            CustomAbilities:QuickAttachParticle("particles/roshpit/duskbringer/ghostfire_blast_e3.vpcf", enemy, 0.5)
        end
    end
end

function Filters:BuzukisFinger(caster)
    local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, BUZUKIS_FINGER_RADIUS, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
    if #allies > 0 then
        for _, ally in pairs(allies) do
            ally:RemoveModifierByName("modifier_buzuki_powering_up")
            EmitSoundOn("RPCItems.BuzukiFinger.Powerup", ally)
            caster.handItem:ApplyDataDrivenModifier(caster.InventoryUnit, ally, "modifier_buzukis_finger_buff", {duration = BUZUKIS_FINGER_DURATION})
            caster.handItem:ApplyDataDrivenModifier(caster, ally, "modifier_buzuki_powering_up", {duration = 2.5})
            ally:AddNewModifier(caster.InventoryUnit, caster.handItem, "modifier_buzuki_finger_lua", {duration = BUZUKIS_FINGER_DURATION})
        end
    end
end

function Filters:OrthokStack(hero, stacks)
    local chains = hero.headItem
    chains:ApplyDataDrivenModifier(hero.InventoryUnit, hero, "modifier_orthok_zeal", {duration = ORTHOK_STACK_DURATION})
    if not chains.zealData then
        chains.zealData = {}
    end
    local thisZeal = {}
    thisZeal.createdAt = GameRules:GetGameTime()
    thisZeal.value = stacks
    table.insert(chains.zealData, thisZeal)
    Filters:RecalculateOrthokStacks(hero, chains)
end

function Filters:RecalculateOrthokStacks(hero, chains)
    local newZealData = {}
    local totalStacks = 0
    if not chains.zealData then
        chains.zealData = {}
    end
    for i = 1, #chains.zealData, 1 do
        if GameRules:GetGameTime() - chains.zealData[i].createdAt >= ORTHOK_STACK_DURATION then
        else
            table.insert(newZealData, chains.zealData[i])
            totalStacks = totalStacks + chains.zealData[i].value
        end
    end
    chains.zealData = newZealData
    hero:SetModifierStackCount("modifier_orthok_zeal", hero.InventoryUnit, totalStacks)
    Filters:UpdateOrthokPFX(hero, totalStacks, chains)
end

function Filters:UpdateOrthokPFX(hero, totalStacks, chains)
    if not chains.pfx1 and totalStacks > 0 then
        local particleName = "particles/econ/generic/generic_buff_1/charge_of_light_effect_buff.vpcf"
        local pfx1 = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, hero)
        ParticleManager:SetParticleControlEnt(pfx1, 0, hero, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)
        chains.pfx1 = pfx1
        local pfx2 = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, hero)
        ParticleManager:SetParticleControlEnt(pfx2, 0, hero, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)
        chains.pfx2 = pfx2
    end
    if totalStacks > 0 then
        local weight = totalStacks / 100
        ParticleManager:SetParticleControl(chains.pfx1, 14, Vector(1, 1 * weight, weight))
        ParticleManager:SetParticleControl(chains.pfx1, 15, Vector(255, 251, 0))
        ParticleManager:SetParticleControl(chains.pfx2, 14, Vector(1, 1 * weight, weight))
        ParticleManager:SetParticleControl(chains.pfx2, 15, Vector(0, 0, 255))
    else
        if chains.pfx1 then
            ParticleManager:DestroyParticle(chains.pfx1, false)
            chains.pfx1 = false
        end
        if chains.pfx2 then
            ParticleManager:DestroyParticle(chains.pfx2, false)
            chains.pfx2 = false
        end
    end
end

function Filters:JexNatureCostmicW(caster)
    local ability = caster:FindAbilityByName("jex_nature_cosmic_w")
    local mana_usage = ability:GetSpecialValueFor("mana_cost_per_cast")
    if mana_usage > caster:GetMana() then
        ability:ToggleAbility()
    end
    caster:ReduceMana(mana_usage)
end

function Filters:AlienArmor(caster)
    local modifierKeys = {}

    modifierKeys.outgoing_damage = ALIEN_ARMOR_OUTGOING_DAMAGE_MULT*100
    modifierKeys.incoming_damage = 1 - (ALIEN_ARMOR_INCOMING_DAMAGE_REDUCTION/100)
    modifierKeys.duration = ALIEN_ARMOR_ILLUSION_DURATION
    local illusions = CreateIllusions( caster, caster, modifierKeys, 1, 20, true, true)
    local illusion = illusions[1]
    illusion.owner = caster
    local body = caster.body
    body:ApplyDataDrivenModifier(caster.InventoryUnit, illusion, "modifier_alien_armor_illusion", {})
    illusion:SetRenderColor(0, 0, 0)
    illusion.hero = caster
    StartAnimation(illusion, {duration = 2, activity = ACT_DOTA_SPAWN, rate = 1.2})
    local newPos = caster:GetAbsOrigin()+RandomVector(200)
    newPos = GetGroundPosition(newPos, illusion)
    illusion:SetAbsOrigin(newPos)
    CustomAbilities:QuickParticleAtPoint("particles/econ/items/rubick/rubick_force_gold_ambient/rubick_telekinesis_land_force_gold.vpcf", newPos+Vector(0,0,60), 4)

    illusion.strength_custom = caster.strength_custom
    illusion.agility_custom = caster.agility_custom
    illusion.intellect_custom = caster.intellect_custom
    illusion.str_bonus = caster.str_bonus
    illusion.agi_bonus = caster.agi_bonus
    illusion.int_bonus = caster.int_bonus
    illusion:SetBaseDamageMax(OverflowProtectedGetAverageTrueAttackDamage(caster))
    illusion:SetBaseDamageMin(OverflowProtectedGetAverageTrueAttackDamage(caster))
    local modifiers = illusion:FindAllModifiers()
    for j = 1, #modifiers, 1 do
        local modifier = modifiers[j]  
        local modifier_name = modifier:GetName()
        if modifier_name == "modifier_attack_land_basic" or modifier_name == "modifier_illusion" or modifier_name == "modifier_animation" or modifier_name == "modifier_alien_armor_illusion" then
        else
            illusion:RemoveModifierByName(modifier:GetName())
        end
    end  
    local modifiers = caster:FindAllModifiers()
    for j = 1, #modifiers, 1 do
        local modifier = modifiers[j]
        if modifier then
            local modifier_caster = modifier:GetCaster()
            if IsValidEntity(modifier_caster) and modifier_caster:GetTeamNumber() == caster:GetTeamNumber() then
                local modifier_ability = modifier:GetAbility()
                if IsValidEntity(modifier_ability) then
                    local duration = modifier:GetRemainingTime()
                    local modifier_name = modifier:GetName()
                    print(modifier_name)
                    if modifier_name == "modifier_shapeshift_cat" or modifier_name == "modifier_shapeshift_crow" or modifier_name == "modifier_shapeshift_year_beast" or modifier_name == "modifier_shapeshift_bear" or modifier_name == "modifier_draghor_shapeshift_bear_lua" or modifier_name == "modifier_draghor_shapeshift_hawk_lua" or modifier_name == "modifier_draghor_shapeshift_cat_lua" then
                        modifier_ability:ApplyDataDrivenModifier(modifier:GetCaster(), illusion, modifier:GetName(), {duration = duration})
                        illusion:SetModifierStackCount(modifier:GetName(), modifier:GetCaster(), modifier:GetStackCount())
                    end
                end
            end
        end
    end
    illusion:SetRenderColor(0, 0, 0)

    if not body.illusion_table then
        body.illusion_table = {}
    end
    local new_body_illusion_table = {}
    for i = 1, #body.illusion_table, 1 do
        if IsValidEntity(body.illusion_table[i]) then
            table.insert(new_body_illusion_table, body.illusion_table[i])
        end
    end
    table.insert(new_body_illusion_table, illusion)
    body.illusion_table = new_body_illusion_table
end


function Filters:ExtendBuffsDurationOnTarget(target, keyName, bonusAmplify, increase, checkFunc)
    if target:IsRooted() or target:IsStunned() then
        return
    end
    keyName = 'duration_buff_' .. keyName
    local modifiers = target:FindAllModifiers()
    for _,modifier in pairs(modifiers) do
        local isDebuff = modifier:IsStunDebuff() or (modifier['IsDebuff'] and modifier:IsDebuff()) or false
        local durationRemaining = modifier:GetRemainingTime()
        if not isDebuff
                and not self:IsNonExtendableBuff(modifier)
                and not modifier[keyName]
                and durationRemaining > 0
                and (checkFunc == nil or checkFunc(modifier))
        then
            modifier[keyName] = true
            modifier.duration_amplify = modifier.duration_amplify or 1
            modifier.duration_increase = modifier.duration_increase or 0

            modifier.old_duration_amplify = modifier.duration_amplify
            modifier.old_duration_increase = modifier.duration_increase

            modifier.duration_amplify = modifier.duration_amplify + bonusAmplify
            modifier.duration_increase = modifier.duration_increase + increase

            durationRemaining = (durationRemaining - modifier.old_duration_increase + modifier.duration_increase) * modifier.duration_amplify/modifier.old_duration_amplify
            modifier:SetDuration(durationRemaining, true)
        end
    end
end
function Filters:IsNonExtendableBuff(modifier)
    self.nonExtendableBuffs = self.nonExtendableBuffs or {
        modifier_gravelfoot_buff = true,
        modifier_animation = true,
        modifier_burnout = true,
        modifier_recently_respawned = true,
        modifier_animation_translate = true,
    }
    return self.nonExtendableBuffs[modifier:GetName()] or isDebuff or false
end

function Filters:NetergraspPalisade(hero, target)
    local ability = hero.body
    local caster = hero.InventoryUnit
    if target:HasModifier("modifier_nethergrasp_linked") then
        return false
    end
    local distance = WallPhysics:GetDistance2d(hero:GetAbsOrigin(), target:GetAbsOrigin())
    if distance > NETHERGRASP_LINK_RANGE then
        return false
    end
    if target.dummy then
        return false
    end
    ability:ApplyDataDrivenModifier(caster, target, "modifier_nethergrasp_linked", {duration = 30})

    local nethergrasp = {}
    nethergrasp.entindex = target:GetEntityIndex()
    nethergrasp.pfx = ParticleManager:CreateParticle("particles/roshpit/items/nethergrasp_electric_vortex.vpcf", PATTACH_POINT_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt(nethergrasp.pfx, 0, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetAbsOrigin() + Vector(0, 0, 80), true)
    ParticleManager:SetParticleControlEnt(nethergrasp.pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin() + Vector(0, 0, 80), true)
    table.insert(ability.pfx_table, nethergrasp.pfx)
    nethergrasp.create_time = GameRules:GetGameTime()
    table.insert(ability.nethergrasp_table, nethergrasp)
    EmitSoundOn("Items.Nethergrip.Link", target)
    nethergrasp.active = true
    if #ability.nethergrasp_table > NETHERGRASP_MAX_LINKS then
        local new_nethergrasp_table = {}
        for i = 1, #ability.nethergrasp_table, 1 do
            local nether = ability.nethergrasp_table[i]
            if i == 1 then
                target:RemoveModifierByName("modifier_nethergrasp_linked")
                ParticleManager:DestroyParticle(nether.pfx, false)
                ParticleManager:ReleaseParticleIndex(nether.pfx)
            else
                table.insert(new_nethergrasp_table, nether)
            end
        end
        ability.nethergrasp_table = new_nethergrasp_table
    end
end

function Filters:InpsirationRing(caster, skillIndex)
    local ring = caster.amulet
    if not ring.abilities_cast then
        ring.abilities_cast = {false, false, false, false}
    end
    local particleName = "particles/roshpit/items/inspiration_ring/inspiration_gold.vpcf"
    if ring:GetAbilityName() == "item_rpc_beryl_ring_of_intuition" then
        particleName = "particles/roshpit/items/inspiration_ring/inspiration_blue.vpcf"
    end
    ring.abilities_cast[skillIndex] = true
    local condition_met = true

    for i = 1, #ring.abilities_cast, 1 do
        if not ring.abilities_cast[i] then
            condition_met = false
            break
        end
    end
    DeepPrintTable(ring.abilities_cast)
    if condition_met then
        ring.abilities_cast = {false, false, false, false}
        EmitSoundOn("Items.InspirationRing.Activate", caster)
        local pfx = ParticleManager:CreateParticle(particleName, PATTACH_POINT_FOLLOW, caster)
        ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
        -- ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true)
        ParticleManager:SetParticleControl(pfx, 5, Vector(1,1,1))
        local heal = caster:GetMaxHealth()
        Filters:ApplyHeal(caster, caster, heal, true, true)

        if ring:GetAbilityName() == "item_rpc_auric_ring_of_inspiration" then
            ring:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_auric_ring_bkb", {duration = INSPIRATION_MAGIC_IMMUNITY_TIME})
        elseif ring:GetAbilityName() == "item_rpc_beryl_ring_of_intuition" then
            for i = 0, 8, 1 do
                local ability = caster:GetAbilityByIndex(i)
                if ability and IsValidEntity(ability) then
                    local cd = ability:GetCooldownTimeRemaining()
                    ability:EndCooldown()
                    if i == DOTA_R_SLOT and cd > INTUITION_ULTIMATE_MIN_CD then
                        ability:StartCooldown(INTUITION_ULTIMATE_MIN_CD)
                    end
                end
            end
        end
        Timers:CreateTimer(2, function()
            ParticleManager:DestroyParticle(pfx, false)
        end)
    end
    CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "inspiration_ring", {abilities_cast = ring.abilities_cast, ring_name = ring:GetAbilityName(), clear = 0, caster = caster:GetEntityIndex(), border_color = ring.newItemTable.property1color})
end