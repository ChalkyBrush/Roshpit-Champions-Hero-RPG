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
require("/heroes/invoker/conjuror_constants")
require('/items/constants/boots')
require('/items/constants/chest')
require('/items/constants/gloves')
require('/items/constants/helm')
require('/items/constants/trinket')

LinkLuaModifier("modifier_buzuki_finger_lua", "modifiers/modifier_buzuki_finger_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pivotal_swift", "modifiers/modifier_pivotal_swift", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sonic_boot_base", "modifiers/modifier_sonic_boot_base", LUA_MODIFIER_MOTION_NONE)


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

    if damageData.skipItemDamageEffectsApply then
        Filters:TakeArgumentsAndApplyDamage(victim, attacker, damage, damage_type, BASE_ITEM, element1, element2)
        return
    end

    Filters:TakeArgumentsAndApplyDamage(victim, attacker, damage, damage_type, BASE_ITEM, element1, element2)
end

function Filters:GetUnpurgableDebuffNames()
    local unpurgable = {"modifier_shipyard_boss_aura_effect", "modifier_hero_candy_crush", "modifier_attack_land_basic", "modifier_dummy_timer", "modifier_boomerang_attack_damage_visible", "modifier_boomerang_attack_damage_invisible"}
    return unpurgable
end

function Filters:GetUnpurgableBuffNames()
    local unpurgable = {"modifier_ascencion_cooldown",
        "modifier_duskbringer_ghost_form_active",
    "modifier_comet_jumping"}
    return unpurgable
end

function Filters:IsModifierAStun(modifier_name)
    if string.match(modifier_name, "modifier_stunned") or string.match(modifier_name, "modifier_knockback") or string.match(modifier_name, "modifier_nyx_assassin_impale") or string.match(modifier_name, "modifier_lina_light_strike_array") or string.match(modifier_name, "modifier_lion_impale") or string.match(modifier_name, "modifier_earthshaker_fissure_stun") or string.match(modifier_name, "modifier_tidehunter_ravage") or string.match(modifier_name, "modifier_lightning_stun") then
        return true
    else
        return false
    end   
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
    local casterName = caster:GetUnitName()
    local mult = 1
    
	Util.Modifier:SimpleEvent(caster, 'GetRoshpitItemDmgBonus', { MODIFIER_ROSHPIT_ITEM_DMG_BONUS }, { }, 
        function(result, data)
            mult = mult + result
        end
    )
    if caster:HasModifier("modifier_ocean_templest_tidal_storm_stacks") then
        local stacks = caster:FindModifierByName("modifier_ocean_templest_tidal_storm_stacks"):GetStackCount()
        mult = mult + (ITEM_RPC_OCEAN_TEMPEST_PALLIUM_BAD_PER_TIDE_STACK/100)*stacks
    end
    if caster:HasModifier("modifier_nightmare_rider_stacks") then
        local stacks = caster:GetModifierStackCount("modifier_nightmare_rider_stacks", caster.InventoryUnit)
        mult = mult + (stacks * caster.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_NIGHTMARE_RIDER_MANTLE_GEM_AMETHYST2)) / 100
    end
    if caster:HasModifier("modifier_mask_of_mugato") and caster:IsSilenced() then
        mult = mult + caster.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("amethyst", MUGATO_AMETHYST2)/100
    end
    if caster:HasModifier("modifier_gilded_soul_sapphire_bad") then
        mult = mult + caster:FindModifierByName("modifier_gilded_soul_sapphire_bad"):GetStackCount()/100
    end
    if caster:HasModifier("modifier_auriun_glyph_2_1") then
        mult = mult + AURIUN_GLYPH_2_1_ITEM_DAMAGE/100
    end
    if caster:HasModifier("modifier_crystalline_slippers") then
        mult = mult + ITEM_RPC_CRYSTALLINE_SLIPPERS_BAD_AND_ITEM_AMP/100
    end
    if caster:HasModifier("modifier_royal_wristguards_stack_effect") then
        mult = mult + (caster.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_ROYAL_WRISTGUARDS_GEM_AMETHYST)/100)*caster:GetModifierStackCount("modifier_royal_wristguards_stack_effect", caster.InventoryUnit)
    end
    if caster:HasModifier("modifier_excavators_focus_cap") then
        mult = mult + caster:GetBaseAbilityAmpForSlot("average_of_all_slots")/100
    end
    if caster:HasModifier("modifier_oceanrunner_boots") then
        mult = mult + caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_OCEANRUNNER_BOOTS_GEM_SAPPHIRE)/100 * (caster:GetAgility())
    end
    if caster:HasModifier("modifier_grand_arcanist") then
        mult = mult + (caster.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("emerald", ITEM_RPC_GRAND_ARCANIST_WRAPS_GEM_EMERALD)/100) * caster:GetIntellect()
    end
    if caster:HasModifier("modifier_ablecore_greaves_effect") then
        mult = mult + caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetFinalGemPropertyValue("emerald", ITEM_RPC_ABLECORE_GREAVES_GEM_EMERALD1)/100
    end
    if caster:HasModifier("modifier_pivotal_swiftboots_speed_decay") then
        mult = mult + caster:GetModifierStackCount("modifier_pivotal_swiftboots_speed_decay", caster.InventoryUnit)*caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_PIVOTAL_SWIFTBOOTS_GEM_AMETHYST)/10000
    end
    if caster:HasModifier("modifier_aquastone_ring") then
        mult = mult + (caster:GetRuneValue("q", 4) + caster:GetRuneValue("w", 4) + caster:GetRuneValue("e", 4) + caster:GetRuneValue("r", 4))*ITEM_RPC_AQUASTONE_RING_BAD_AND_ITEM_DMG_PER_T4_RUNE/100
    end
    if caster:HasModifier("modifier_red_divinex_amulet") then
        mult = mult + caster.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("ruby", ITEM_RPC_RED_DIVINEX_AMULET_GEM_RUBY)/100 * (caster:GetStrength())
    end
    if caster:HasModifier("modifier_green_divinex_amulet") then
        mult = mult + caster.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("emerald", ITEM_RPC_GREEN_DIVINEX_AMULET_GEM_EMERALD)/100 * (caster:GetAgility())
    end
    if caster:HasModifier("modifier_blue_divinex_amulet") then
        mult = mult + caster.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_BLUE_DIVINEX_AMULET_GEM_SAPPHIRE)/100 * (caster:GetIntellect())
    end
    if caster:HasModifier("modifier_spiritual_empowerment_stack") then
        local current_stack = caster:GetModifierStackCount("modifier_spiritual_empowerment_stack", caster.InventoryUnit)
        mult = mult + current_stack * caster.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("ruby", ITEM_RPC_SPIRITUAL_EMPOWERMENT_GLOVE_GEM_RUBY1)/100
    end

    if caster:IsHero() then
        mult = mult + 0.01 * (CustomAttributes:AddStatsBonusFromStacks(caster, nil, "modifier_head_item_damage", 1) + CustomAttributes:AddStatsBonusFromStacks(caster, nil, "modifier_weapon_item_damage", 1) + CustomAttributes:AddStatsBonusFromStacks(caster, nil, "modifier_hands_item_damage", 1) + CustomAttributes:AddStatsBonusFromStacks(caster, nil, "modifier_feet_item_damage", 1) + CustomAttributes:AddStatsBonusFromStacks(caster, nil, "modifier_body_item_damage", 1) + CustomAttributes:AddStatsBonusFromStacks(caster, nil, "modifier_amulet_item_damage", 1))
    end
    if caster:HasModifier("modifier_shadowflame_fist") then
        mult = mult + caster.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("ruby", ITEM_RPC_SHADOWFLAME_FIST_GEM_RUBY) * (((caster:GetMaxMana() - caster:GetMana()) / caster:GetMaxMana()))
    end
    if caster:HasModifier("modifier_claw_of_azinoth") then
        mult = mult + caster.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_CLAW_OF_AZINOTH_GEM_SAPPHIRE2)/100
    end
    if caster:HasModifier("modifier_space_tech_buff_invisible") then
        mult = mult + 0.01 * caster:GetModifierStackCount("modifier_space_tech_buff_invisible", caster.InventoryUnit)
    end
    if caster:HasModifier("modifier_rubilash_r_2_bad_and_item") then
        mult = mult + (caster:GetRuneValue("r", 2)*RUBILASH_RUNE_R2_BAD_AND_ITEM_WHILE_INVIS)/100
    end
    if caster:HasModifier("modifier_tranquil_boots") then
        mult = mult + ((caster:GetHealth()/caster:GetMaxHealth())*100)*caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetFinalGemPropertyValue("ruby", ITEM_RPC_TRANQUIL_BOOTS_GEM_RUBY2)/100
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
        if caster.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetGemValue("emerald") > 0 then
            mult = mult - caster.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("emerald", HOOD_OF_BLACK_MAGE_EMERALD)/100
        end
    end
    damage = damage * mult
    return damage
end

function Filters:GetAdjustedRange(caster, baseRange)
    if caster:HasModifier("modifier_vermillion_dream_lua") then
        baseRange = baseRange + ITEM_RPC_VERMILLION_DREAM_ROBES_CAST_RANGE_INCREASE
    end
	if caster:HasModifier("modifier_epoch_immortal_weapon_4") then
        baseRange = baseRange - EPOCH_IMMORTAL_WEAPON_4_RANGE_REDUCTION
    end
    return baseRange
end

function Filters:GetAdjustedBuffDuration(caster, baseDuration, bItem)
    if caster:GetUnitName() == "npc_dota_hero_zuus" then
        local r_3_level = caster:GetRuneValue("r", 3)
        baseDuration = baseDuration + r_3_level * AURIUN_R3_BUFF_DUR_INCREASE
    end
    if caster:HasModifier("modifier_arbor_dragonfly") then
        baseDuration = baseDuration * (100+ITEM_RPC_ARBOR_DRAGONFLY_BUFF_INCREASE_PCT)/100
    end
    return baseDuration
end

function Filters:GetBaseHealthRegen(target, caster)
    -- local rootedStacks = target:GetModifierStackCount("modifier_rooted_feet_regen_portion", caster)
    -- local silverspringStacks = target:GetModifierStackCount(string modifierName, handle hCaster)
end

function Filters:GetDelayWithCastSpeed(caster, delay)
    if caster:HasModifier("modifier_spellfire_gloves") then
        delay = delay * (1-ITEM_RPC_SPELLFIRE_GLOVES_CAST_POINT_REDUCTION)
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
        percentageChance = percentageChance + ITEM_RPC_BOOTS_OF_GREAT_FORTUNE_CHANCE_INCREASE + caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_BOOTS_OF_GREAT_FORTUNE_GEM_AMETHYST)
    end
    if caster:HasModifier("modifier_fortunes_talisman_of_truth") then
        percentageChance = math.ceil(percentageChance * (100+ITEM_RPC_FORTUNES_TALISMAN_OF_TRUTH_CHANCE_AMP)/100)
    end
    if caster:HasModifier("modifier_astral_rune_r_4_invisible") then
        local chanceModifier = 1 + (ASTRAL_RANGER_R4_PROC_CHANCE_INCREASE * caster:GetModifierStackCount("modifier_astral_rune_r_4_invisible", Events.GameMaster))
        percentageChance = math.ceil(percentageChance * chanceModifier)
    end
    if caster:HasModifier("modifier_boots_of_great_fortune_sapphire_effect") then
        luck = 0
        caster:RemoveModifierByName("modifier_boots_of_great_fortune_sapphire_effect")
    end

    if luck <= percentageChance then
        if caster:HasModifier("modifier_fortunes_talisman_of_truth") then
            Filters:FortunesTalismanItemProc(caster)
        end
        return true
    else
        return false
    end
end

function Filters:GetProcCount(caster, chance)
    local base_rolls = math.floor(chance/100)
    local extra_roll = 0
    if chance%100 ~= 0 then
        if Filters:GetProc(caster, chance%100) then
            extra_roll = 1
        end
    end
    return base_rolls + extra_roll
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
            speed = speed + speed*(caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetFinalGemPropertyValue("ruby", ITEM_RPC_PEGASUS_BOOTS_GEM_RUBY)/100)
        end
    end
    if caster:HasModifier("modifier_swamp_waders") then
        speed = speed * (1 - ITEM_RPC_SWAMP_WADERS_E_TRAVEL_SPEED_LOSS/100)
    end
	if caster:HasModifier("modifier_warlord_immortal_weapon_4") then
        speed = speed *(1 + WARLORD_IMMORTAL_WEAPON_4_E_SPEED_PCT/100)
    end
    return speed
end

function Filters:GetAdjustedMaxMovespeed(max_ms, caster)
    if caster:HasModifier("modifier_pegasus_boots") then
        max_ms = max_ms + (max_ms-550)*(ITEM_RPC_PEGASUS_BOOTS_MAX_MS_AMP_PCT/100)
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
        return true
    else
        return false
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
    local abilityCooldown = abilityCooldown - CDreduce
    if abilityCooldown > 0 then
        ability:EndCooldown()
        ability:StartCooldown(abilityCooldown)
    else
        ability:EndCooldown()
    end
end

function Filters:ReduceCooldownGeneric(caster, ability, CDreduce, minCD)
    local abilityCooldown = ability:GetCooldownTimeRemaining()
    local abilityCooldown = abilityCooldown - CDreduce
    if minCD then
        abilityCooldown = math.max(abilityCooldown, minCD)
    end
    if abilityCooldown > 0 then
        ability:EndCooldown()
        ability:StartCooldown(abilityCooldown)
    else
        ability:EndCooldown()
    end
end

function Filters:ReduceQCooldown(caster, ability, baseCD, bIncludeFlatCD)
    local abilityCooldown = baseCD
    local CdFlatModifier = 0
    if ability:GetCooldownTimeRemaining() == 0 then
        return
    end
    if caster:HasModifier("modifier_venomort_glyph_1_1") then
        abilityCooldown = VENOMORT_GLYPH_1_1_COOLDOWN
	end
    if not ability.BaseClass then
        Util.Modifier:SimpleEvent(caster, 'GetRoshpitQFlatCdModifier', { MODIFIER_ROSHPIT_Q_FLAT_CD_MOD }, { }, 
            function(result, data)
                CdFlatModifier = CdFlatModifier + result
            end
        )
    end
    local abilityCooldown = abilityCooldown + CdFlatModifier
    if not ability.BaseClass then
        Util.Modifier:SimpleEvent(caster, 'GetRoshpitQPctCdModifier', { MODIFIER_ROSHPIT_Q_PCT_CD_MOD }, { }, 
            function(result, data)
                abilityCooldown = abilityCooldown * (1 + result)
            end
        )
    end
    if not ability.BaseClass then
        Util.Modifier:SimpleEvent(caster, 'GetRoshpitQMaxCdModifier', { MODIFIER_ROSHPIT_Q_MAX_CD_MOD }, { }, 
            function(result, data)
                abilityCooldown = math.min(abilityCooldown, result)
            end
        )
        Util.Modifier:SimpleEvent(caster, 'GetRoshpitQMinCdModifier', { MODIFIER_ROSHPIT_Q_MIN_CD_MOD }, { }, 
            function(result, data)
                abilityCooldown = math.max(abilityCooldown, result)
            end
        )
    end
    abilityCooldown = math.min(abilityCooldown, GLOBAL_Q_MAX_CD)
    if ability.BaseClass and ability:GetCooldownBase(-1) < GLOBAL_Q_MIN_CD then
        abilityCooldown = math.max(abilityCooldown, ability:GetCooldownBase(-1))
    elseif ability:GetCooldown(-1) < GLOBAL_Q_MIN_CD then
        abilityCooldown = math.max(abilityCooldown, ability:GetCooldown(-1))
    else
        abilityCooldown = math.max(abilityCooldown, GLOBAL_Q_MIN_CD)
    end

    if abilityCooldown ~= baseCD then
        ability:EndCooldown()
        ability:StartCooldown(abilityCooldown)
    end
end
function Filters:ReduceWCooldown(caster, ability, baseCD, bIncludeFlatCD)
    local abilityCooldown = baseCD
    local CdFlatModifier = 0
    if not ability.BaseClass then
        Util.Modifier:SimpleEvent(caster, 'GetRoshpitWFlatCdModifier', { MODIFIER_ROSHPIT_W_FLAT_CD_MOD }, { }, 
            function(result, data)
                CdFlatModifier = CdFlatModifier + result
            end
        )
    end
    local abilityCooldown = abilityCooldown + CdFlatModifier

    if not ability.BaseClass then
        Util.Modifier:SimpleEvent(caster, 'GetRoshpitWPctCdModifier', { MODIFIER_ROSHPIT_W_PCT_CD_MOD }, { }, 
            function(result, data)
                abilityCooldown = abilityCooldown * (1 + result)
            end
        )
    end
    if not ability.BaseClass then
        Util.Modifier:SimpleEvent(caster, 'GetRoshpitWMaxCdModifier', { MODIFIER_ROSHPIT_W_MAX_CD_MOD }, { }, 
            function(result, data)
                abilityCooldown = math.min(abilityCooldown, result)
            end
        )
        Util.Modifier:SimpleEvent(caster, 'GetRoshpitWMinCdModifier', { MODIFIER_ROSHPIT_W_MIN_CD_MOD }, { }, 
            function(result, data)
                abilityCooldown = math.max(abilityCooldown, result)
            end
        )
    end
    abilityCooldown = math.min(abilityCooldown, GLOBAL_W_MAX_CD)
    if ability.BaseClass and ability:GetCooldownBase(-1) < GLOBAL_W_MIN_CD then
        abilityCooldown = math.max(abilityCooldown, ability:GetCooldownBase(-1))
    elseif ability:GetCooldown(-1) < GLOBAL_W_MIN_CD then
        abilityCooldown = math.max(abilityCooldown, ability:GetCooldown(-1))
    else
        abilityCooldown = math.max(abilityCooldown, GLOBAL_W_MIN_CD)
    end

    if abilityCooldown ~= baseCD then
        ability:EndCooldown()
        ability:StartCooldown(abilityCooldown)
    end
end
function Filters:ReduceECooldown(caster, ability, baseCD, bIncludeFlatCD)
    local abilityCooldown = baseCD
    local CdFlatModifier = 0

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
    if not ability.BaseClass then
        Util.Modifier:SimpleEvent(caster, 'GetRoshpitEFlatCdModifier', { MODIFIER_ROSHPIT_E_FLAT_CD_MOD }, { }, 
            function(result, data)
                CdFlatModifier = CdFlatModifier + result
            end
        )
    end
    if caster:HasModifier('modifier_venomort_glyph_3_1') then
        CdFlatModifier = CdFlatModifier - VENOMORT_GLYPH_3_1_E_CD_RED
    end
    if caster:HasModifier("modifier_bear_silencer") then
        CdFlatModifier = CdFlatModifier + 30
    end
    local abilityCooldown = abilityCooldown + CdFlatModifier

    
    if not ability.BaseClass then
        Util.Modifier:SimpleEvent(caster, 'GetRoshpitEPctCdModifier', { MODIFIER_ROSHPIT_E_PCT_CD_MOD }, { }, 
            function(result, data)
                abilityCooldown = abilityCooldown * (1 + result)
            end
        )
    end    
    if not ability.BaseClass then
        Util.Modifier:SimpleEvent(caster, 'GetRoshpitEMaxCdModifier', { MODIFIER_ROSHPIT_E_MAX_CD_MOD }, { }, 
            function(result, data)
                abilityCooldown = math.min(abilityCooldown, result)
            end
        )
        Util.Modifier:SimpleEvent(caster, 'GetRoshpitEMinCdModifier', { MODIFIER_ROSHPIT_E_MIN_CD_MOD }, { }, 
            function(result, data)
                abilityCooldown = math.max(abilityCooldown, result)
            end
        )
    end

    abilityCooldown = math.min(abilityCooldown, GLOBAL_E_MAX_CD)
    if ability.BaseClass and ability:GetCooldownBase(-1) < GLOBAL_E_MIN_CD then
        abilityCooldown = math.max(abilityCooldown, ability:GetCooldownBase(-1))
    elseif ability:GetCooldown(-1) < GLOBAL_E_MIN_CD then
        abilityCooldown = math.max(abilityCooldown, ability:GetCooldown(-1))
    else
        abilityCooldown = math.max(abilityCooldown, GLOBAL_E_MIN_CD)
    end

    --if abilityCooldown ~= baseCD then
        ability:EndCooldown()
        ability:StartCooldown(abilityCooldown)
    --end
end
function Filters:ReduceRCooldown(caster, ability, baseCD, bIncludeFlatCD)
    local abilityCooldown = baseCD
    local CdFlatModifier = 0

    if not ability.BaseClass then
        Util.Modifier:SimpleEvent(caster, 'GetRoshpitRFlatCdModifier', { MODIFIER_ROSHPIT_R_FLAT_CD_MOD }, { }, 
            function(result, data)
                CdFlatModifier = CdFlatModifier + result
            end
        )
    end
    local abilityCooldown = abilityCooldown + CdFlatModifier

    if not ability.BaseClass then
        Util.Modifier:SimpleEvent(caster, 'GetRoshpitRPctCdModifier', { MODIFIER_ROSHPIT_R_PCT_CD_MOD }, { }, 
            function(result, data)
                abilityCooldown = abilityCooldown * (1 + result)
            end
        )
    end
    if not ability.BaseClass then
        Util.Modifier:SimpleEvent(caster, 'GetRoshpitRMaxCdModifier', { MODIFIER_ROSHPIT_R_MAX_CD_MOD }, { }, 
            function(result, data)
                abilityCooldown = math.min(abilityCooldown, result)
            end
        )
        Util.Modifier:SimpleEvent(caster, 'GetRoshpitRMinCdModifier', { MODIFIER_ROSHPIT_R_MIN_CD_MOD }, { }, 
            function(result, data)
                abilityCooldown = math.max(abilityCooldown, result)
            end
        )
    end

    abilityCooldown = math.min(abilityCooldown, GLOBAL_R_MAX_CD)
    if ability.BaseClass and ability:GetCooldownBase(-1) < GLOBAL_R_MIN_CD then
        abilityCooldown = math.max(abilityCooldown, ability:GetCooldownBase(-1))
    elseif ability:GetCooldown(-1) < GLOBAL_R_MIN_CD then
        abilityCooldown = math.max(abilityCooldown, ability:GetCooldown(-1))
    else
        abilityCooldown = math.max(abilityCooldown, GLOBAL_R_MIN_CD)
    end

    if abilityCooldown ~= baseCD then
        ability:EndCooldown()
        ability:StartCooldown(abilityCooldown)
    end
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

function Filters:LinearProjectile(projectile_data)
    local projectile = ProjectileManager:CreateLinearProjectile(projectile_data)
    return projectile
end

function Filters:TrackingProjectile(projectile_data)
    local projectile = ProjectileManager:CreateTrackingProjectile(projectile_data)
    return projectile
end

function Filters:ApplyStun(caster, duration, target)
    local mult = 1
    if caster:HasModifier("modifier_knight_crusher_armor") then
        mult = mult + ITEM_RPC_STAGGERING_KNIGHT_CRUSHER_ARMOR_STUN_DURATION_INCREASE/100
    end
    Util.Modifier:SimpleEvent(caster, 'GetRoshpitStunDurationPctModifier', { MODIFIER_ROSHPIT_STUN_DURATION_PCT }, { }, 
        function(result, data)
            mult = mult + result/100
        end
    )
    if caster:HasModifier("modifier_steelforge_passive") then
        caster.w_2_level = caster:GetRuneValue("w", 2)
    end
    if caster:HasModifier("modifier_stormcrack_helm") then
        if caster:GetTeamNumber() == target:GetTeamNumber() then
        else
            local helm = caster.equipped_gear[RPC_GEAR_SLOT_HEAD]
            local limitKey = caster:GetEntityIndex().."_stormcrack"
            local max_procs_per_second = STORMCRACK_MAX_PROCS_PER_SECOND + helm:GetFinalGemPropertyValue("emerald", STORMCRACK_EMERALD)
            Util.Common:LimitPerTime(max_procs_per_second, 1, limitKey, function()
                CustomAbilities:QuickAttachParticle("particles/econ/items/sven/sven_warcry_ti5/sven_warcry_cast_arc_lightning.vpcf", target, 1.2)
                local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * (STORMCRACK_ATTACK_DAMAGE_PCT / 100) + (caster:GetStrength() + caster:GetAgility() + caster:GetIntellect() + caster:GetSpirit())*helm:GetFinalGemPropertyValue("sapphire", STORMCRACK_SAPPHIRE)
                Filters:ApplyItemDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, helm, RPC_ELEMENT_NORMAL, RPC_ELEMENT_LIGHTNING)
            end)

            mult = mult + helm:GetFinalGemPropertyValue("ruby", STORMCRACK_RUBY)/100
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
            local resist_mult = 1
            if caster:HasModifier("modifier_knight_crusher_armor") then
                resist_mult = resist_mult * (1 - ITEM_RPC_STAGGERING_KNIGHT_CRUSHER_ARMOR_STUN_IMMUNITY_COUNTER_DECREASE/100)
            end
            if caster:HasModifier("modifier_sorceress_glyph_5_2") then
                resist_mult = resist_mult * (1 - SORCERESS_GLYPH_5_2_STUN_IMMUNITY_COUNTER_REDUCTION)
            end
            local newResistanceStacks = currentResistanceStacks + math.ceil((duration * 10) * resist_mult)
            target:SetModifierStackCount("modifier_stun_resistance", Events.GameMaster, newResistanceStacks)
        else
            duration = 0
        end
    end
    if target:HasModifier("modifier_stun_immune") or target:HasModifier("modifier_recently_respawned") then
        duration = 0
    end
    if target:HasModifier("modifier_treasure_goblin_passive") then
        duration = duration * 0.1
    end
    if caster:HasModifier("modifier_mountain_protector_glyph_1_1") then
        local glyph_ability = caster:FindModifierByName("modifier_mountain_protector_glyph_1_1"):GetAbility()
        glyph_ability:ApplyDataDrivenModifier(caster, target, "modifier_mountain_protector_glyph_1_1_cant_heal", {duration = duration})
    end
    if caster:HasModifier("modifier_knight_crusher_armor") and duration > 0 then
        local crusher_armor = caster.equipped_gear[RPC_GEAR_SLOT_BODY]
        if crusher_armor:GetGemValue("ruby") > 0 then
			if caster:GetTeamNumber() ~= target:GetTeamNumber() then
				crusher_armor:ApplyDataDrivenModifier(caster.InventoryUnit, target, "modifier_knight_crusher_armor_loss", {duration = duration})
			end
        end
        if crusher_armor:GetGemValue("emerald") > 0 then
            crusher_armor:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_knight_crusher_armor_pierce", {duration = duration})
        end
    end
    Util.Modifier:SimpleEvent(caster, 'OnStun', { MODIFIER_SPECIAL_TYPE_ON_STUN }, {target = target, stunDuration = duration}, nil)
    if duration > 0 then
        target:AddNewModifier(caster, nil, "modifier_stunned", {duration = duration})
    end
end

function Filters:ApplyHeal(caster, target, healAmount, bCap, doPopUp, optional_ability)
    if caster:GetUnitName() == "npc_dota_hero_zuus" then
        local w_2_level = caster:GetRuneValue("w", 2)
        if w_2_level > 0 then
            healAmount = healAmount + healAmount * AURIUN_W2_HEALING_AMP * w_2_level
            healAmount = OverflowProtectedMaxHealingValue(healAmount)
        end
    end
    if caster:HasModifier("modifier_white_mage_hat") then
        healAmount = healAmount * (1 + caster.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("emerald", WHITE_MAGE_EMERALD)/100)
    end
    if target:HasModifier("modifier_raven_idol") then
        healAmount = healAmount * (1 - caster.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("emerald", ITEM_RPC_RAVEN_IDOL_GEM_EMERALD1)/100)
    end
    if target:HasModifier("modifier_ruptholds_helm_of_gluttony") then
        healAmount = healAmount * (1 - ITEM_RPC_RUPTHOLDS_HELM_OF_GLUTTONY_HEALING_REDUCTION_PCT/100)
        local threshold = target.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_RUPTHOLDS_HELM_OF_GLUTTONY_AMETHYST1)/100
        if target:GetHealth() < target:GetMaxHealth()*threshold then
            healAmount = healAmount * (1 + ITEM_RPC_RUPTHOLDS_HELM_OF_GLUTTONY_AMETHYST_HEALING_INCREASE/100)
        end
    end
    if target:HasModifier("modifier_rubilash_immortal_weapon_2") then
        healAmount = healAmount * (1 - RUBILASH_IMMORTAL_WEAPON_2_HEAL_REDUCTION/100)
    end
    healAmount = OverflowProtectedMaxHealingValue(healAmount)
    if bCap then
        healAmount = math.min(healAmount, target:GetMaxHealth())
    end
    healAmount = math.floor(healAmount)
    if target:HasModifier("modifier_eternal_essence_gauntlet") then
        healAmount = Filters:EternalEssenceGauntlet(target, healAmount)
    end
    if target:HasModifier("modifier_grasp_of_elder") then
        local manaRestore = (target.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_GRASP_OF_ELDER_GEM_SAPPHIRE2)/100)*healAmount
        if manaRestore > 0 then
            target:GiveMana(manaRestore)
            PopupMana(target, manaRestore)
        end
    end
    if caster:HasModifier("modifier_glove_of_the_hierophant") then
        healAmount = Filters:GloveOfTheHierophant(caster, target, healAmount)
    end
    target:Heal(healAmount, caster)
    if doPopUp and healAmount > 0 then
        PopupHealing(target, healAmount)
    end

    if target:HasModifier("modifier_pirate_aura_debuff") then
        local modifiers = target:FindAllModifiersByName("modifier_pirate_aura_debuff")
        for _, modifier in pairs(modifiers) do
            local pirateCaster = modifier:GetCaster()
            local finalValue = OverflowProtectedMaxHealingValue(healAmount)
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
                target.paladin_q4_absorb = math.min(target.paladin_q4_absorb + shieldAmount, target:GetMaxHealth() * PALADIN_Q4_MAX_SHIELD_PER_MAX_HP * q_4_level)
                local shieldDuration = Filters:GetAdjustedBuffDuration(caster, 12, false)
                target:AddNewModifier(caster, ability, "modifier_paladin_q4_shield", {duration = shieldDuration})
            end
        end
    end
    if optional_ability then
        if optional_ability:GetAbilityName() == "item_rpc_white_mage_hat" and optional_ability:GetGemValue("sapphire") > 0 then
            local overheal = healAmount - (target:GetMaxHealth() - target:GetHealth())
            if overheal > 0 then
                if not target.whiteMageShield then
                    target.whiteMageShield = 0
                end
                if not target:HasModifier("modifier_white_mage_shield") then
                    target.whiteMageShield = 0
                end
                local shieldValue = math.min(target.whiteMageShield + overheal, target:GetMaxHealth()*(optional_ability:GetFinalGemPropertyValue("sapphire", WHITE_MAGE_SAPPHIRE)/100))
                if shieldValue < 0 then
                    return
                end
                target.whiteMageShield = shieldValue
                optional_ability:ApplyDataDrivenModifier(caster.InventoryUnit, target, "modifier_white_mage_shield", {duration = WHITE_MAGE_SAPPHIRE_SHIELD_DURATION})
            end
        end
    end
end

function Filters:ApplyDotDamage(caster, ability, target, damage, damage_type, slot, element1, element2)
    heroes.venomort.onDotDamageDo(caster, target)
    local mult = 1
    mult = mult + heroes.venomort.getDotAmplify(caster, target)
    damage = damage * mult
    local damage_types = { {dot_damage_type = DAMAGE_TYPE_PHYSICAL, dot_damage = 0}, {dot_damage_type = DAMAGE_TYPE_MAGICAL, dot_damage = 0},{dot_damage_type = DAMAGE_TYPE_PURE, dot_damage = 0}  }
    damage_types[1] = {dot_damage_type = damage_type, dot_damage = damage}
    if caster:HasModifier('modifier_venomort_glyph_5_a') then
        damage_types[1] = {dot_damage_type = DAMAGE_TYPE_PHYSICAL, dot_damage = damage / 3}
        damage_types[2] = {dot_damage_type = DAMAGE_TYPE_MAGICAL, dot_damage = damage / 3}
        damage_types[3] = {dot_damage_type = DAMAGE_TYPE_PURE, dot_damage = damage / 15}
    end

    for index, dot in ipairs(damage_types) do
        if slot == BASE_NONE then
			ApplyDamage({victim = target, attacker = caster, damage = dot.dot_damage, damage_type = dot.dot_damage_type, damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR})
        elseif slot == BASE_ITEM then
            Filters:ApplyItemDamage(target, caster, dot.dot_damage, dot.dot_damage_type, ability, element1, element2)
        elseif slot == -2 then
            Filters:TakeArgumentsAndApplyDamage(target, caster, dot.dot_damage, dot.dot_damage_type, -2, element1, element2)
        else
            Filters:TakeArgumentsAndApplyDamage(target, caster, dot.dot_damage, dot.dot_damage_type, slot, element1, element2)
        end
    end
end

function Filters:SkillArgumentSlotToHeroAbility(hero, slot)
    if slot == BASE_ABILITY_Q then
        return hero:GetAbilityByIndex(DOTA_Q_SLOT)
    elseif slot == BASE_ABILITY_W then
        return hero:GetAbilityByIndex(DOTA_W_SLOT)
    elseif slot == BASE_ABILITY_E then
        return hero:GetAbilityByIndex(DOTA_E_SLOT)
    elseif slot == BASE_ABILITY_R then
        return hero:GetAbilityByIndex(DOTA_R_SLOT)
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
    if caster:HasModifier("modifier_torch_of_gengar_effect") then
        Filters:GengarCast(caster)
    end
    if caster:HasModifier("modifier_beryl_ring_of_intuiton") or caster:HasModifier("modifier_auric_ring_of_inspiration") then
        Filters:InpsirationRing(caster, slot)
    end
    if caster:HasModifier("modifier_plague_emperor_armor") then
        Filters:PlagueEmperorBombSetup(caster, slot, nil)
    end
    if caster:HasModifier("modifier_depth_demon_claw_sapphire") then
        local mana_drain = caster:GetMaxMana()*(caster.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_DEPTH_DEMON_CLAW_GEM_SAPPHIRE3))/100
        caster:ReduceMana(mana_drain)
    end
    if caster:HasModifier("modifier_mana_striders") then
        if caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetGemValue("amethyst") > 0 then
            local manaDrain = caster:GetMaxMana()*caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_MANA_STRIDERS_GEM_AMETHYST2)/100
            caster:ReduceMana(manaDrain)
        end
    end
    if caster:HasModifier("modifier_antique_mana_relic") then
        local mana_drain = ITEM_RPC_ANTIQUE_MANA_RELIC_MANA_DRAIN - caster.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_ANTIQUE_MANA_RELIC_GEM_AMETHYST)
        caster:ReduceMana(caster:GetMaxMana() * mana_drain/100)
        CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_mana_leak.vpcf", caster, 2)
    end
    Events:TutorialServerEvent(caster, "2_1", 1)
    Challenges:AbilityUsed(slot)
    if caster:HasModifier("modifier_bladestorm_vest_buff") then
        local proc = false
        if caster.equipped_gear[RPC_GEAR_SLOT_BODY]:GetGemValue("amethyst") > 0 then
            proc = Filters:GetProc(caster, caster.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_BLADESTORM_VEST_GEM_AMETHYST))
        end
        if not proc then
            local bladestormStacks = caster:GetModifierStackCount("modifier_bladestorm_vest_buff", caster.body)
            local newStacks = math.max(bladestormStacks - 1, 0)
            caster:SetModifierStackCount("modifier_bladestorm_vest_buff", caster.body, newStacks)
            Filters:ModifyBladestormVestSwordCount(caster, newStacks, caster.equipped_gear[RPC_GEAR_SLOT_BODY], caster.InventoryUnit, -1)
        end
    end
    if caster:HasModifier("modifier_mordiggus_gauntlet") then
        Filters:MordiggusEvent(caster, "cast")
    end
    if caster:HasModifier("modifier_spiritual_empowerment_stack") then
        local stack_loss = 1
        if caster.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetGemValue("amethyst") > 0 then
            local proc = Filters:GetProc(caster, caster.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_SPIRITUAL_EMPOWERMENT_GLOVE_GEM_AMETHYST2))
            if proc then
                stack_loss = 0
            end
        end
        local newStack = caster:GetModifierStackCount("modifier_spiritual_empowerment_stack", caster.InventoryUnit) - stack_loss
        if newStack == 0 then
            caster:RemoveModifierByName("modifier_spiritual_empowerment_stack")
        else
            caster:SetModifierStackCount("modifier_spiritual_empowerment_stack", caster.InventoryUnit, newStack)
        end
        Filters:SpiritualEmpowermentStackUpdate(caster)
    end
    if caster:HasModifier("modifier_crimsyth_elite_greaves") then
        caster:RemoveModifierByName("modifier_crimsyth_elite_greaves_armor")
        caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_crimsyth_elite_greaves_magic_shield", {duration = ITEM_RPC_CRIMSYTH_ELITE_GREAVES_LV1_DURATION})
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
    if caster:HasModifier("modifier_mask_of_mugato") then
        caster:AddNewModifier(caster, nil, "modifier_silence", {duration = MUGATO_SPELL_SILENCE_DUR})
    end
end

function Filters:BeginRChannel(caster)
    local ability = caster:GetAbilityByIndex(DOTA_R_SLOT)
    if not ability then
        return false
    end
    local baseCd = ability:GetCooldownTimeRemaining()
    if not ability.BaseClass and (caster:HasModifier("modifier_iron_treads_of_destruction") or caster:HasModifier("modifier_baphomets_cursed_necklace_ruin_effect")) or caster:HasModifier("modifier_flamewaker_rune_q_4") then
        ability:OnChannelFinish(false)
        Timers:CreateTimer(0.03, function()
            ability:EndChannel(true)
            Filters:EndRChannel(caster)
        end)
    end
    if not ability.BaseClass and caster:HasModifier("modifier_spellfire_gloves") then
        if caster.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetGemValue("amethyst") > 0 then
            caster:AddNewModifier(caster.InventoryUnity, caster.equipped_gear[RPC_GEAR_SLOT_GLOVES], "modifier_spellfire_gloves_channeling_think", {duration = ability:GetChannelTime()})
        end
    end
    Util.Modifier:SimpleEvent(caster, 'OnRChannelStart', { MODIFIER_SPECIAL_TYPE_R_CHANNEL_START }, {caster = caster}, 
        function(result, data)
            
        end
    )
    local baseCd = ability:GetCooldownTimeRemaining()
    Filters:ReduceRCooldown(caster, ability, baseCd, false)
    if caster:HasModifier("modifier_galaxy_orb") then
        caster.equipped_gear[RPC_GEAR_SLOT_TRINKET].can_stick = true
        caster.equipped_gear[RPC_GEAR_SLOT_TRINKET]:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_galaxy_orb_channel", {duration = ability:GetChannelTime()})
    end
    if caster:HasModifier("modifier_water_mage_robes") then
        caster.equipped_gear[RPC_GEAR_SLOT_BODY]:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_water_mage_channeling", {duration = ability:GetChannelTime()})
    end
    if caster:HasModifier("modifier_ocean_tempest_pallium") then
        caster.equipped_gear[RPC_GEAR_SLOT_BODY].manaDrained = 0
        caster.equipped_gear[RPC_GEAR_SLOT_BODY].interval = 0
        caster.equipped_gear[RPC_GEAR_SLOT_BODY].total_mana_drained = 0
        caster.equipped_gear[RPC_GEAR_SLOT_BODY].channel_time = ability:GetChannelTime() - 0.1
        caster.equipped_gear[RPC_GEAR_SLOT_BODY].total_mana_drain_pct = ITEM_RPC_OCEAN_TEMPEST_PALLIUM_MANA_DRAIN_OF_MAX + caster.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_OCEAN_TEMPEST_PALLIUM_GEM_AMETHYST)
        caster.equipped_gear[RPC_GEAR_SLOT_BODY]:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_ocean_tempest_pallium_channeling", {})
    end
    if caster:HasModifier("modifier_space_tech_vest") then
        caster:RemoveModifierByName("modifier_space_tech_buff")
        caster.equipped_gear[RPC_GEAR_SLOT_BODY]:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_space_tech_channel", {duration = ability:GetChannelTime()})
        caster.equipped_gear[RPC_GEAR_SLOT_BODY].ruby_ticks = ability:GetChannelTime()/ITEM_RPC_SPACE_TECH_VEST_GAIN_INTERVAL
        caster.equipped_gear[RPC_GEAR_SLOT_BODY].r_cooldown = baseCd
    end
    if caster:HasModifier("modifier_druid_spirit_helm") then
        caster.equipped_gear[RPC_GEAR_SLOT_HEAD]:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_druid_channel", {duration = ability:GetChannelTime()})
    end
    if caster:HasModifier("modifier_brazen_kabuto") then
        caster:RemoveModifierByName('modifier_brazen_kabuto_shield')
        caster.equipped_gear[RPC_GEAR_SLOT_HEAD]:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_brazen_kabuto_channeling", {duration = ability:GetChannelTime()})
        local chance = caster.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("sapphire", KABUTO_SAPPHIRE)
        if Runes:ProcsByTotalChance(chance) >= 1 then
            ability:EndCooldown()
        end
    end
    if caster:HasModifier("modifier_burning_spirit_helmet") then
        StartSoundEvent("RPCItem.BurningSpiritHelm", caster)
        caster.equipped_gear[RPC_GEAR_SLOT_HEAD]:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_burning_spirit_helmet_flamethrower", {duration = ability:GetChannelTime()})
    end
    if caster:HasModifier("modifier_templar_light_seers_robe") then
        caster:RemoveModifierByName("modifier_light_seer_shield")
        caster.equipped_gear[RPC_GEAR_SLOT_BODY]:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_templar_channeling", {duration = ability:GetChannelTime()})
    end
end

function Filters:EndRChannel(caster)
    Util.Modifier:SimpleEvent(caster, 'OnRChannelEnd', { MODIFIER_SPECIAL_TYPE_R_CHANNEL_END }, {caster = caster}, 
        function(result, data)
            
        end
    )
    if caster:HasModifier("modifier_galaxy_orb") then
        caster:RemoveModifierByName("modifier_galaxy_orb_channel")
    end
    if caster:HasModifier("modifier_space_tech_vest") then
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
    local ability = caster:GetAbilityByIndex(DOTA_Q_SLOT)
    local baseCd = ability:GetCooldownTimeRemaining()
    Filters:ReduceQCooldown(caster, ability, baseCd, false)

    if caster:HasModifier("modifier_death_whisper_helm") then
        Filters:DeathWhisperSapphire(caster)
    end
    if caster:HasModifier("modifier_spellslinger_coat") then
        Filters:SpellslingerCoatQ(caster)
    end
    if caster:HasModifier("modifier_boots_of_pure_waters") then
        if caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetGemValue("amethyst") > 0 then
            Filters:PureWaters(caster, "q")
        end
    end
    if caster:HasModifier("modifier_depth_crest_armor") then
        local depth_crest = caster.equipped_gear[RPC_GEAR_SLOT_BODY]
        local chance = depth_crest:GetFinalGemPropertyValue("sapphire", ITEM_RPC_DEPTH_CREST_ARMOR_GEM_SAPPHIRE)
        Filters:DepthCrestArmor(caster, depth_crest, chance)
    end
    if caster:HasModifier("modifier_secret_temple") then
        Filters:SecretTempleQ(caster)
    end
    if caster:HasModifier("modifier_alaranas_ice_boot") then
        if caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetGemValue("emerald") > 0 then
            Filters:AlaranaInit(caster, caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetFinalGemPropertyValue("emerald", ITEM_RPC_ALARANAS_ICE_BOOT_GEM_EMERALD))
        end
    end
    
    if caster:HasModifier("modifier_terrasic_magma_break_stacks") then
        local ability = caster:GetAbilityByIndex(DOTA_Q_SLOT)
        local currentStack = caster:GetModifierStackCount("modifier_terrasic_magma_break_stacks", caster.InventoryUnit)
        if currentStack > 1 then
            caster:SetModifierStackCount("modifier_terrasic_magma_break_stacks", caster.InventoryUnit, currentStack - 1)
        else
            caster:RemoveModifierByName("modifier_terrasic_magma_break_stacks")
        end
        ability:EndCooldown()
    end
    if caster:HasModifier("modifier_djanghor_glyph_5_1") then
        if caster:GetUnitName() == "npc_dota_hero_monkey_king" then
            local qAbility = caster:GetAbilityByIndex(DOTA_Q_SLOT)
            Filters:ReduceCooldownGeneric(caster, qAbility, DJANGHOR_GLYPH_5_1_Q_CD_RED)
        end
    end
    if caster:HasModifier("modifier_guard_of_feronia") then
        Filters:ApplyFeronia(caster, BASE_ABILITY_Q, false)
    end
    if caster:HasModifier("modifier_royal_wristguards") then
        local current_stack = caster:GetModifierStackCount("modifier_royal_wristguards_stack_effect", caster.InventoryUnit)
        local stack_removal = current_stack
        if caster.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetGemValue("emerald") > 0 then
            stack_removal = current_stack * (caster.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("emerald", ITEM_RPC_ROYAL_WRISTGUARDS_GEM_EMERALD)/100)
        end
        Timers:CreateTimer(0.1, function()
            local new_stacks = caster:GetModifierStackCount("modifier_royal_wristguards_stack_effect", caster.InventoryUnit) - stack_removal
            if new_stacks > 0 then
                caster:SetModifierStackCount("modifier_royal_wristguards_stack_effect", caster.InventoryUnit, new_stacks)
            else
                caster:RemoveModifierByName("modifier_royal_wristguards_stack_effect")
            end
        end)
    end
    if caster:HasModifier("modifier_nightmare_rider") then
        Filters:NightmareRider(caster)
    end
    if caster:HasModifier("modifier_outland_stone_cuirass") then
        CustomAbilities:QuickAttachParticle("particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf", caster, 4)
        local self_stun = ITEM_RPC_OUTLAND_STONE_CUIRASS_SELF_STUN + caster.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue("ruby", ITEM_RPC_OUTLAND_STONE_CUIRASS_GEM_RUBY1)
        caster:AddNewModifier(caster, nil, "modifier_stunned", {duration = self_stun})
        EmitSoundOn("RPCItem.StoneCuirass.Trigger", caster)
    end
    if caster:HasModifier("modifier_dark_emissary_glove") then
        Filters:DarkEmissary(caster)
    end
    local ability = caster:GetAbilityByIndex(DOTA_Q_SLOT)
    if ability.castPointSave then
        ability:SetOverrideCastPoint(ability:GetKeyValue("AbilityCastPoint", false))
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
                caster.equipped_gear[RPC_GEAR_SLOT_WEAPON]:ApplyDataDrivenModifier(caster.InventoryUnit, avatar, "modifier_sorceress_immortal_ice_avatar", {})
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
                avatar:AddAbility("normal_steadfast"):SetLevel(GameState:GetDifficultyFactor())
                caster:ReduceMana(caster:GetMaxMana() * 0.5)
            end
        end
    end
end

function Filters:ApplyWskills(caster)
    local ability = caster:GetAbilityByIndex(DOTA_W_SLOT)
    local baseCd = ability:GetCooldownTimeRemaining()
    Filters:ReduceWCooldown(caster, ability, baseCd, false)

    if caster:HasModifier("modifier_bluestar_armor") then
        Filters:BluestarCast(caster)
    end
    if caster:HasModifier("modifier_crystalline_slippers") then
        Filters:CrystallineWCast(caster)
    end
    if caster:HasModifier("modifier_autumnrock_bracer") then
        Filters:AutumnRockWCast(caster)
    end
    if caster:HasModifier("modifier_pegasus_boots") then
        Filters:PegasusWCast(caster)
    end
    if caster:HasModifier("modifier_silverspring_gloves") then
        Filters:SilverspringWCast(caster)
    end
    if caster:HasModifier("modifier_neptunes_water_gliders") then
        Filters:NeptuneWCast(caster)
    end
    if caster:HasModifier("modifier_outland_stone_cuirass") then
        if caster.equipped_gear[RPC_GEAR_SLOT_BODY]:GetGemValue("sapphire") > 0 then
            CustomAbilities:QuickAttachParticle("particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf", caster, 4)
            local self_stun = caster.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_OUTLAND_STONE_CUIRASS_GEM_SAPPHIRE1)
            caster:AddNewModifier(caster, nil, "modifier_stunned", {duration = self_stun})
            EmitSoundOn("RPCItem.StoneCuirass.Trigger", caster)
        end
    end
    if caster:HasModifier("modifier_water_mage_robes") then
        if caster.equipped_gear[RPC_GEAR_SLOT_BODY]:GetGemValue("amethyst") > 0 then
            local proc = Filters:GetProc(caster, caster.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_WATER_MAGE_ROBES_GEM_AMETHYST))
            if proc then
                EmitSoundOn("Tanari.WaterTemple.RareWrathWater", caster)
                Filters:WaterMageRobeProjectile(caster.equipped_gear[RPC_GEAR_SLOT_BODY], caster, caster:GetForwardVector())
            end
        end
    end
    if caster:HasModifier("modifier_gloves_of_sweeping_wind") then
        local glove = caster.equipped_gear[RPC_GEAR_SLOT_GLOVES]
        local proc = Filters:GetProc(caster, glove:GetFinalGemPropertyValue("sapphire", ITEM_RPC_GLOVES_OF_SWEEPING_WIND_GEM_SAPPHIRE))
        if proc then
            Filters:SweepingWindsStackChange(caster, glove, 1)
        end
    end
    if caster:HasModifier("modifier_buzukis_finger") then
        Filters:BuzukisFinger(caster)
    end
    if caster:HasModifier("modifier_igneous_canine_helm") then
        Filters:IgneousCanine(caster)
    end
    if caster:HasModifier("modifier_rpc_wraith_crown") then
        Filters:WraithCrown(caster)
    end
    if caster:HasModifier("modifier_seraphic_soulvest") then
        Filters:SeraphicVest(caster, BASE_ABILITY_W)
    end
    if caster:HasModifier("modifier_spellslinger_coat") then
        Filters:SpellslingerCoat(caster)
    end
    if caster:HasModifier("modifier_white_mage_hat") then
        Filters:WhiteMageHat(caster)
    end
    if caster:HasModifier("modifier_swamp_witch_hat") then
        Filters:WitchHat(caster)
    end
    if caster:HasModifier("modifier_tricksters_mask") then
        Filters:TricksterMask(caster)
    end
    if caster:HasModifier("modifier_cerulean_high_guard") then
        Filters:CeruleanHighguard(caster)
    end
    if caster:HasModifier("tanari_water_bomb_hero") then
        Filters:BombThrow(caster)
    end
    if caster:HasModifier("modifier_carbuncles_helm_of_reflection") then
        Filters:CarbuncleApply(caster, CARBUNCLE_SHIELD_DURATION, true)
    end
    if caster:HasModifier("modifier_sacred_trials_armor") then
        Filters:SacredTrialActivate(caster)
    end
    if caster:HasModifier("modifier_cytopian_laser") then
        Filters:CytopianLaser(caster)
    end
    if caster:HasModifier("modifier_tome_of_chaos") then
        Filters:TomeOfChaos(caster)
    end
    if caster:HasModifier("modifier_auriun_immortal_weapon_3") then
        if caster:GetUnitName() == "npc_dota_hero_zuus" then
            if not caster:HasModifier("modifier_auriun_immortal_weapon_3_effect") then
                EmitSoundOn("Auriun.Immo3Activate", caster)
            end
            caster:RemoveModifierByName("modifier_auriun_immortal_weapon_3_effect")
            caster.equipped_gear[RPC_GEAR_SLOT_WEAPON]:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_auriun_immortal_weapon_3_effect", {duration = AURIUN_IMMO_WEAPON_3_DURATION})
        end
    end
    if caster:HasModifier("modifier_windsteel_armor") then
        if not caster:HasModifier("modifier_windsteel_cooldown") then
            local windsteel = caster.equipped_gear[RPC_GEAR_SLOT_BODY]
            local stackCount = caster:GetAbilityByIndex(DOTA_W_SLOT):GetLevel() + windsteel:GetFinalGemPropertyValue("ruby", ITEM_RPC_WINDSTEEL_ARMOR_GEM_RUBY)
            local cooldown = ITEM_RPC_WINDSTEEL_ARMOR_COOLDOWN - windsteel:GetFinalGemPropertyValue("sapphire", ITEM_RPC_WINDSTEEL_ARMOR_GEM_SAPPHIRE)
            windsteel:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_windsteel_effect", {duration = ITEM_RPC_WINDSTEEL_ARMOR_DURATION})
            windsteel:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_windsteel_stat_bonuses", {duration = ITEM_RPC_WINDSTEEL_ARMOR_DURATION})
            windsteel:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_windsteel_cooldown", {duration = cooldown})
            caster:SetModifierStackCount("modifier_windsteel_effect", windsteel, stackCount)
            EmitSoundOn("Item.WindSteel", caster)
        end
    end
    local ability = caster:GetAbilityByIndex(DOTA_W_SLOT)
    if ability.castPointSave then
        local abilityCastPoint = ability:GetKeyValue("AbilityCastPoint", false)
        if abilityCastPoint then
            ability:SetOverrideCastPoint(abilityCastPoint)
            ability.castPointSave = nil
        end
    end
    local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
    if caster:HasModifier("modifier_burnout") then
        local currentStacks = caster:GetModifierStackCount("modifier_burnout", Events.GameMaster) + 1
        caster:SetModifierStackCount("modifier_burnout", Events.GameMaster, currentStacks)
        if currentStacks == 7 then
            local disableAbility = caster:GetAbilityByIndex(DOTA_W_SLOT)
            if IsValidEntity(disableAbility) then
                local cd = 0.4
                disableAbility:StartCooldown(cd)
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

    if caster:HasModifier("modifier_sonic_boots") then
        Filters:SonicBoot(caster)
    end
    if caster:HasModifier("modifier_sandstream_slippers") then
        Filters:SandstreamECast(caster)
    end
    if caster:HasModifier("modifier_rpc_terrasic_lava_boots") then
        Filters:TerrasicLavaBootsECast(caster)
    end
    if caster:HasModifier("modifier_tranquil_boots") then
        Filters:TranquilBootsECast(caster)
    end
	if caster:HasModifier("modifier_centaur_horns") then
        Filters:CentaurHornsSapphireECast(caster)
    end
    if caster:HasModifier("modifier_mana_striders") then
        if caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetGemValue("sapphire") > 0 then
            CustomAbilities:QuickAttachParticle("particles/items3_fx/mango_active.vpcf", caster, 1)
            local manaRestore = math.floor(caster:GetMaxMana()*caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_MANA_STRIDERS_GEM_SAPPHIRE2)/100)
            caster:GiveMana(manaRestore)
            PopupMana(caster, manaRestore)
        end
    end
    if caster:HasModifier("modifier_neptunes_water_gliders") then
        Filters:NeptuneECast(caster)
    end
    if caster:HasModifier("modifier_falcon_boots") then
        Filters:FalconBoot(caster)
    end
    if caster:HasModifier("modifier_gravelfoot_treads") then
        if caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetGemValue("amethyst") > 0 then
            Filters:InitGravelFootEffect(caster.InventoryUnit, caster.equipped_gear[RPC_GEAR_SLOT_BOOTS], caster, caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_GRAVELFOOT_TREADS_GEM_AMETHYST))
        end
    end
    if caster:HasModifier("modifier_blue_dragon_greaves") then
        if caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetGemValue("ruby") > 0 then
            Filters:ApplyBlueDragonGreavesBuff(caster, caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetFinalGemPropertyValue("ruby", ITEM_RPC_BLUE_DRAGON_GREAVES_GEM_RUBY1))
        end
    end
    if caster:HasModifier("modifier_guardian_greaves") then
        Filters:GuardianGreavesCast(caster, caster.equipped_gear[RPC_GEAR_SLOT_BOOTS])
    end
    if caster:HasModifier("modifier_gem_of_eternal_frost") then
        Filters:EternalFrost(caster)
    end
    if caster:HasModifier("modifier_temporal_warp_boots") then
        Filters:TimeWarp(caster)
    end
    if caster:HasModifier("modifier_hurricane_vest") then
        if caster.equipped_gear[RPC_GEAR_SLOT_BODY]:GetGemValue("amethyst") > 0 then
            local tornado_count = caster.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_HURRICANE_VEST_GEM_AMETHYST)
            Filters:HurricaneVest(caster, tornado_count)
        end
    end
    if caster:HasModifier("modifier_avernus_e_nerf") then
        ability:EndCooldown()
        baseCd = baseCd + 15
        ability:StartCooldown(baseCd)
    end
    if caster:HasModifier("modifier_arcanys_slipper") then
        Timers:CreateTimer(0.45, function()
            caster:RemoveModifierByName("modifier_arcanys_slipper_buff")
            caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_arcanys_slipper_effect", {duration = ITEM_RPC_ARCANYS_SLIPPER_EXPLOSIONS_DURATION})
        end)
    end
    if caster:HasModifier("modifier_redrock_footwear") then
        Filters:RedrockFootwear(caster)
    end
    if caster:HasModifier("modifier_boots_of_pure_waters") then
        Filters:PureWaters(caster, "e")
    end
    if caster:HasModifier("modifier_gloves_of_sweeping_wind") then
        Filters:SweepingWindsStackChange(caster, caster.equipped_gear[RPC_GEAR_SLOT_GLOVES], 1)
    end
    if caster:HasModifier("modifier_moon_tech_runners") then
        Filters:MoonTechRunners(caster)
    end
    if caster:HasModifier("modifier_guard_of_feronia") then
        Filters:ApplyFeronia(caster, BASE_ABILITY_E, false)
    end
    if caster:HasModifier("modifier_spirit_glove") then
        if caster.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetGemValue("ruby") > 0 then
            Filters:SpiritGlove(caster, caster.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("ruby", ITEM_RPC_SPIRIT_GLOVE_GEM_RUBY1))
        end
    end
    if caster:HasModifier("modifier_wind_deity_crown") then
        caster:RemoveModifierByName("modifier_wind_deity_damage_buff")
    end
    if ability.castPointSave then
        ability:SetOverrideCastPoint(ability:GetKeyValue("AbilityCastPoint", false))
        ability.castPointSave = nil
    end
end

function Filters:ApplyRskills(caster)
    if caster:HasModifier("modifier_hurricane_vest") then
        local tornado_count = ITEM_RPC_HURRICANE_VEST_HURRICANE_COUNT + caster.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue("ruby", ITEM_RPC_HURRICANE_VEST_GEM_RUBY1)
        Filters:HurricaneVest(caster, tornado_count)
    end
    if caster:HasModifier("modifier_nightmare_rider") then
        local stacks = caster.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue("emerald", ITEM_RPC_NIGHTMARE_RIDER_MANTLE_GEM_EMERALD1)
        Filters:NightmareRiderStacksGain(caster, stacks)
    end
    if caster:HasModifier("modifier_robe_of_flooding") then
        Filters:FloodRobe(caster)
    end
    if caster:HasModifier("modifier_avalanche_plate") then
        Filters:AvalanchePlate(caster)
    end
    if caster:HasModifier("modifier_secret_temple") then
        Filters:SecretTemple(caster)
    end
    if caster:HasModifier("modifier_doomplate") then
        Filters:DoomplateCast(caster)
    end
    if caster:HasModifier("modifier_seraphic_soulvest") then
        Filters:SeraphicVest(caster, BASE_ABILITY_R)
    end
    if caster:HasModifier("modifier_spirit_glove") then
        Filters:SpiritGlove(caster, ITEM_RPC_SPIRIT_GLOVE_DURATION)
    end
    if caster:HasModifier("modifier_super_ascendency_mask") then
        Filters:AscensionTrigger(caster)
    end
    if caster:HasModifier("modifier_scourge_knights_helm") then
        Filters:ScourgeKnight(caster)
    end
    if caster:HasModifier("modifier_mask_of_the_desert_necromancer") then
        Filters:ReanimateThorok(caster)
    end
    if caster:HasModifier("modifier_autumn_sleeper_mask") then
        Filters:AutumnSleeperMask(caster)
    end
    if caster:HasModifier("modifier_alien_armor") then
        Filters:AlienArmor(caster)
    end
    if caster:HasModifier("modifier_guard_of_feronia") then
        Filters:ApplyFeronia(caster, BASE_ABILITY_R, false)
    end
    if caster:HasModifier("modifier_blue_rain_gauntlet") then
        Filters:BlueRainRCast(caster)
    end
    if caster:HasModifier("modifier_carbuncles_helm_of_reflection") then
        Filters:CarbuncleApply(caster, caster.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("sapphire", CARBUNCLE_SAPPHIRE), false)
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
        Filters:SilentTemplar(caster)
    end
    if caster:HasModifier("modifier_alaranas_ice_boot") then
        Filters:AlaranaInit(caster, ITEM_RPC_ALARANAS_ICE_BOOT_ICE_ENCASE_DURATION)
    end
    if caster:HasModifier("modifier_brazen_kabuto") then
        if caster.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetGemValue("amethyst") > 0 then
            local duration = caster.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("amethyst", KABUTO_AMETHYST)
            caster.equipped_gear[RPC_GEAR_SLOT_HEAD]:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_brazen_kabuto_shield", {duration = duration})
        end
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
                caster.equipped_gear[RPC_GEAR_SLOT_WEAPON]:ApplyDataDrivenModifier(caster.InventoryUnit, avatar, "modifier_sorceress_immortal_fire_avatar", {})
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
                avatar:AddAbility("normal_steadfast"):SetLevel(GameState:GetDifficultyFactor())
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
    -- ABILITY PROCS AT THE START
    if not ignore_effects then
        if attacker:HasModifier("modifier_demon_mask") and slot == BASE_ABILITY_Q then
            Filters:DemonMask(attacker, victim, damage)
        end
        if attacker:HasModifier("modifier_fire_deity_crown") and slot == BASE_ABILITY_W then
            Filters:FireDeity(attacker, victim, damage)
        end
        if attacker:HasModifier("modifier_guard_of_luma") and slot == BASE_ABILITY_Q then
            Filters:LumaGuardStrike(attacker, victim, damage)
        end
        if attacker:HasModifier("modifier_odin_helmet") and (Util.BaseType:IsAbilityBaseType(slot) or slot == BASE_ITEM) then
            Filters:OdinHelm(attacker, victim, damage)
        end
        if attacker:HasModifier("modifier_water_deity_crown") and slot == BASE_ABILITY_R then
            Filters:WaterDeity(attacker, victim, damage)
        end
        if attacker:HasModifier("modifier_frostburn_gauntlets") and slot == BASE_ABILITY_W then
            Filters:FrostburnGauntlet(attacker, victim, damage)
        end
        if attacker:HasModifier("modifier_eternal_forest_striders") and slot == BASE_ABILITY_E then
            Filters:EternalForestStriders(attacker, victim, damage)
        end
        if slot == BASE_ABILITY_Q then
            Util.Modifier:SimpleEvent(attacker, 'OnHitQAbility', { MODIFIER_SPECIAL_TYPE_ON_HIT_Q_ABILITY }, {victim = victim, attacker = attacker, damage = damage, damage_type = damage_type}, nil)
        elseif slot == BASE_ABILITY_W then
            Util.Modifier:SimpleEvent(attacker, 'OnHitWAbility', { MODIFIER_SPECIAL_TYPE_ON_HIT_W_ABILITY }, {victim = victim, attacker = attacker, damage = damage, damage_type = damage_type}, nil)
        elseif slot == BASE_ABILITY_E then
            Util.Modifier:SimpleEvent(attacker, 'OnHitEAbility', { MODIFIER_SPECIAL_TYPE_ON_HIT_E_ABILITY }, {victim = victim, attacker = attacker, damage = damage, damage_type = damage_type}, nil)
        elseif slot == BASE_ABILITY_R then
            Util.Modifier:SimpleEvent(attacker, 'OnHitRAbility', { MODIFIER_SPECIAL_TYPE_ON_HIT_R_ABILITY }, {victim = victim, attacker = attacker, damage = damage, damage_type = damage_type}, nil)
        end
    end
    -- damage = Filters:AdjustBaseAbilityDamage(victim, attacker, damage, damage_type, slot, element1, element2, ignore_effects, ability)
    local damageData = attacker._damage_data or {}

    local attackerName = attacker:GetUnitName()
    if not ignore_effects then
        -- DAMAGE ADDED TO BASE
        if slot == BASE_ABILITY_Q then
            Util.Modifier:SimpleEvent(attacker, 'GetRoshpitQBaseDmgFlat', { MODIFIER_ROSHPIT_Q_BASE_DMG_FLAT }, { }, 
                function(result, data)
                    damage = damage + result
                end
            )
        elseif slot == BASE_ABILITY_W then
            Util.Modifier:SimpleEvent(attacker, 'GetRoshpitWBaseDmgFlat', { MODIFIER_ROSHPIT_W_BASE_DMG_FLAT }, { }, 
                function(result, data)
                    damage = damage + result
                end
            )
        elseif slot == BASE_ABILITY_E then
            Util.Modifier:SimpleEvent(attacker, 'GetRoshpitEBaseDmgFlat', { MODIFIER_ROSHPIT_E_BASE_DMG_FLAT }, { }, 
                function(result, data)
                    damage = damage + result
                end
            )
        elseif slot == BASE_ABILITY_R then
            Util.Modifier:SimpleEvent(attacker, 'GetRoshpitRBaseDmgFlat', { MODIFIER_ROSHPIT_R_BASE_DMG_FLAT }, { }, 
                function(result, data)
                    damage = damage + result
                end
            )
        end
    end

    if slot == BASE_AUTO_ATTACK then
        if attacker:HasModifier("modifier_gauntlet_of_divine_purity") then
            damage = damage * (1 - ITEM_RPC_GAUNTLET_OF_DIVINE_PURITY_DMG_REDUCTION/100)
            element1 = RPC_ELEMENT_HOLY
            damage_type = DAMAGE_TYPE_PURE
        end
        if attacker:HasModifier("modifier_phoenix_gloves") then
            if attacker.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetGemValue("ruby") > 0 then
                element1 = RPC_ELEMENT_FIRE
            end
        end
        if attacker:HasModifier("modifier_kappa_pride_gloves") then
            local kappa_element = RandomInt(RPC_ELEMENT_FIRE, RPC_ELEMENT_DRAGON)
            if attacker:HasModifier("modifier_kappa_pride_special_element") then
                kappa_element = attacker.equipped_gear[RPC_GEAR_SLOT_GLOVES].force_element
                attacker:RemoveModifierByName("modifier_kappa_pride_special_element")
            end
            if attacker.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetGemValue("amethyst") > 0 then
                local proc = Filters:GetProc(attacker, attacker.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_KAPPA_PRIDE_GLOVES_GEM_AMETHYST))
                if proc then
                    local highestElement = 1
                    local highestElementAmp = 0
                    local elements = CustomAttributes:CalculatedElementBonuses(victim, attacker)
                    for i,v in ipairs(elements) do
                        if v > highestElementAmp then
                            highestElement = i
                            highestElementAmp = v
                        end
                    end
                    kappa_element = highestElement
                end
            end
            element1 = kappa_element
            element2 = RPC_ELEMENT_NONE
            damage_type = DAMAGE_TYPE_MAGICAL
        end
    else
        if attacker:HasModifier("modifier_kappa_pride_gloves") and attacker.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetGemValue("emerald") > 0 then
            local proc = Filters:GetProc(attacker, attacker.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("emerald", ITEM_RPC_KAPPA_PRIDE_GLOVES_GEM_EMERALD))
            if proc then
                attacker.equipped_gear[RPC_GEAR_SLOT_GLOVES].force_element = element1
                attacker.equipped_gear[RPC_GEAR_SLOT_GLOVES]:ApplyDataDrivenModifier(attacker.InventoryUnit, attacker, "modifier_kappa_pride_special_element", {})
            end
        end
    end

    damage, element1, element2 = Filters:ElementalDamage(victim, attacker, damage, damage_type, slot, element1, element2, not ignore_effects)
    attacker.element1 = element1
    attacker.element2 = element2
    local damageMult = 0
    --print("Damage: "..damage)
    --print("Element1: "..element1)
    --print("Element2: "..element2)
    if attacker:HasModifier("modifier_sorceress_immortal_fire_avatar") or attacker:HasModifier("modifier_sorceress_immortal_ice_avatar") then
        attacker = attacker.origCaster
    end
    if Util.BaseType:IsAbilityBaseType(slot) then

        damageMult = damageMult + heroes.venomort.getBad(attacker)
        if attacker:IsRealHero() then
            damageMult = damageMult + attacker:GetSpirit()*(CustomAttributes.BAD_PER_SPIRIT/100)
        end
        if attacker:HasModifier("modifier_fire_walkers") then
            if not ignore_effects then
                Filters:LavaWalkersBaseAbilityHitChance(attacker, victim, slot)
            end
        end
        if attacker:HasModifier("modifier_mask_of_mugato") and attacker:IsSilenced() then
            damageMult = damageMult + attacker.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("sapphire", MUGATO_SAPPHIRE2)/100
        end
        if attacker:HasModifier("modifier_ocean_templest_tidal_storm_stacks") then
            local stacks = attacker:FindModifierByName("modifier_ocean_templest_tidal_storm_stacks"):GetStackCount()
            damageMult = damageMult + (ITEM_RPC_OCEAN_TEMPEST_PALLIUM_BAD_PER_TIDE_STACK/100)*stacks
        end
        if attacker:HasModifier("modifier_bladestorm_vest_buff") then
            damageMult = damageMult + attacker:GetModifierStackCount("modifier_bladestorm_vest_buff", attacker.InventoryUnit)*attacker.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue("emerald", ITEM_RPC_BLADESTORM_VEST_GEM_EMERALD1)/100
        end
        if attacker:HasModifier("modifier_eye_of_avernus") then
            damageMult = damageMult + ITEM_RPC_EYE_OF_AVERNUS_BAD/100
        end
        if attacker:HasModifier("modifier_grand_arcanist") then
            damageMult = damageMult + (attacker.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_GRAND_ARCANIST_WRAPS_GEM_SAPPHIRE)/100) * attacker:GetIntellect()
        end
        if attacker:HasModifier("modifier_direwolf_bulwark_effect") then
            damageMult = damageMult + ITEM_RPC_DIREWOLF_BULWARK_BAD/100 * attacker:GetModifierStackCount("modifier_direwolf_bulwark_effect", attacker.InventoryUnit)
        end
        if attacker:HasModifier("modifier_oceanrunner_boots") then
            damageMult = damageMult + ITEM_RPC_OCEANRUNNER_BOOTS_AGI_TO_BAD/100 * (attacker:GetAgility())
        end
        if attacker:HasModifier("modifier_emerald_nullification_ring") then
            damageMult = damageMult + attacker.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("emerald", ITEM_RPC_EMERALD_NULLIFICATION_RING_GEM_EMERALD)/100 * (attacker:GetAgility())
        end
        if attacker:HasModifier("modifier_resonant_boots_active") then
            damageMult = damageMult + attacker.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_PATHFINDERS_RESONANT_BOOTS_GEM_SAPPHIRE)/100
        end
        if attacker:HasModifier("modifier_white_mage_hat2") then
            damageMult = damageMult + WHITE_MAGE_BAD_PER_INT/100 * (attacker:GetIntellect() / WHITE_MAGE_INT_DIVISOR)
        end
        if attacker:HasModifier("modifier_garnet_warfare_ring") then
            damageMult = damageMult + ITEM_RPC_GARNET_WARFARE_RING_STR_TO_BAD/100 * (attacker:GetStrength())
        end
        if attacker:HasModifier("modifier_boots_of_old_wisdom_active") then
            damageMult = damageMult + ITEM_RPC_BOOTS_OF_OLD_WISDOM_BAD/100
        end
        if attacker:HasModifier("modifier_ogthun_visible") then
            local current_stack = attacker:GetModifierStackCount("modifier_ogthun_visible", attacker.body)
            damageMult = damageMult + 0.02 * current_stack
        end
        if attacker:HasModifier("modifier_azure_empire_base_ability") then
            local current_stack = attacker:GetModifierStackCount("modifier_azure_empire_base_ability", attacker.InventoryUnit)
            damageMult = damageMult + ITEM_RPC_AZURE_EMPIRE_SILVER_BAD/100 * current_stack
        end
        if attacker:HasModifier("modifier_orthok_zeal") then
            local current_stack = attacker:GetModifierStackCount("modifier_orthok_zeal", attacker.InventoryUnit)
            local bad_per_stack = ORTHOK_STACK_BAD/100 + attacker.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("sapphire", ORTHOK_SAPPHIRE)/100
            damageMult = damageMult + bad_per_stack * current_stack
        end
        if attacker:HasModifier("modifier_flood_basin_a_d") then
            local current_stack = attacker:GetModifierStackCount("modifier_flood_basin_a_d", attacker)
            damageMult = damageMult + HYDROXIS_ARCANA_R1_BAD_PCT/100 * current_stack
        end
        if attacker:HasModifier("modifier_bahamut_a_b_buff") then
            local current_stack = attacker:GetModifierStackCount("modifier_bahamut_a_b_buff", attacker.runeUnit:FindAbilityByName("bahamut_rune_w_1"))
            damageMult = damageMult + BAHAMUT_W1_BONUS_DMG_AND_BAD_PCT/100 * current_stack
        end
        if attacker:HasModifier("modifier_venomort_rune_r_4") then
            local current_stack = attacker:GetModifierStackCount("modifier_venomort_rune_r_4", attacker.runeUnit4:FindAbilityByName("venomort_rune_r_4"))
            damageMult = damageMult + 0.1 * current_stack
        end
        if attacker:HasModifier("modifier_hood_of_the_black_mage") then
            if attacker.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetGemValue("emerald") > 0 then
                damageMult = damageMult + attacker.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("emerald", HOOD_OF_BLACK_MAGE_EMERALD)/100
            end
        end
        if attacker:HasAbility("mountain_protector_emberstone") then
            local e_4_level = attacker:GetRuneValue("e", 4)
            damageMult = damageMult + MOUNTAIN_PROTECTOR_E4_BAD * e_4_level
        end
        if attacker:HasModifier("modifier_infused_mageplate_stack") then
            local mageplateStacks = attacker:GetModifierStackCount("modifier_infused_mageplate_stack", attacker.body)
            damageMult = damageMult + mageplateStacks * 0.05
        end
        if attacker:HasModifier("modifier_gilded_soul_sapphire_bad") then
            damageMult = damageMult + attacker:FindModifierByName("modifier_gilded_soul_sapphire_bad"):GetStackCount()/100
        end
        if attacker:HasModifier("modifier_antique_mana_relic") then
            damageMult = damageMult + ITEM_RPC_ANTIQUE_MANA_RELIC_BAD/100
        end
        if attacker:IsHero() then
            damageMult = damageMult + 0.01 * (CustomAttributes:AddStatsBonusFromStacks(attacker, nil, "modifier_head_base_ability", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, nil, "modifier_weapon_base_ability", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, nil, "modifier_hands_base_ability", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, nil, "modifier_feet_base_ability", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, nil, "modifier_body_base_ability", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, nil, "modifier_amulet_base_ability", 1))
        end
        if attacker:HasModifier("modifier_rubilash_r_2_bad_and_item") then
            damageMult = damageMult + (attacker:GetRuneValue("r", 2)*RUBILASH_RUNE_R2_BAD_AND_ITEM_WHILE_INVIS)/100
        end
        if attacker:HasModifier("modifier_aquastone_ring") then
            damageMult = damageMult + (attacker:GetRuneValue("q", 4) + attacker:GetRuneValue("w", 4) + attacker:GetRuneValue("e", 4) + attacker:GetRuneValue("r", 4))*ITEM_RPC_AQUASTONE_RING_BAD_AND_ITEM_DMG_PER_T4_RUNE/100
        end
        if attacker:HasModifier("modifier_world_tree_effect") then
            damageMult = damageMult + ITEM_RPC_WORLD_TREES_FLOWER_CACHE_BAD/100
        end
        if attacker:HasModifier("modifier_torch_of_gengar_inactive") then
            damageMult = damageMult + attacker.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("emerald", ITEM_RPC_TORCH_OF_GENGAR_GEM_EMERALD1)/100
        end
        if attacker:HasModifier("modifier_tranquil_boots") then
            damageMult = damageMult + ((attacker:GetHealth()/attacker:GetMaxHealth())*100)*attacker.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_TRANQUIL_BOOTS_GEM_SAPPHIRE2)/100
        end
        if attacker:HasModifier("modifier_crystalline_slippers") then
            damageMult = damageMult + ITEM_RPC_CRYSTALLINE_SLIPPERS_BAD_AND_ITEM_AMP/100
        end
        if attacker:HasModifier("modifier_pivotal_swiftboots_speed_decay") then
            damageMult = damageMult + attacker:GetModifierStackCount("modifier_pivotal_swiftboots_speed_decay", attacker.InventoryUnit)*attacker.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_PIVOTAL_SWIFTBOOTS_GEM_AMETHYST)/10000
        end
        if attacker:HasModifier("modifier_shadowflame_fist") then
            damageMult = damageMult + attacker.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("ruby", ITEM_RPC_SHADOWFLAME_FIST_GEM_RUBY) * (((attacker:GetMaxMana() - attacker:GetMana()) / attacker:GetMaxMana()))
        end
        if attacker:HasModifier("modifier_ablecore_greaves_effect") then
            damageMult = damageMult + ITEM_RPC_ABLECORE_GREAVES_BAD/100
        end
        if attacker:HasModifier("modifier_scarecrow_gloves") then
            damageMult = damageMult + attacker:GetIntellect()*(attacker.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("ruby", ITEM_RPC_SCARECROW_GLOVES_GEM_RUBY)/100)
        end
        if attacker:HasModifier("modifier_claw_of_azinoth") then
            damageMult = damageMult + attacker.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_CLAW_OF_AZINOTH_GEM_SAPPHIRE2)/100
        end
        if attacker:HasModifier("modifier_angelic_gloves_of_the_judiciary_bad") then
            damageMult = damageMult + attacker:GetModifierStackCount("modifier_angelic_gloves_of_the_judiciary_bad", attacker.InventoryUnit) * (ITEM_RPC_ANGELIC_GLOVES_OF_THE_JUDICIARY_BAD_PER_ATTR/100)
        end
        if attacker:HasModifier("modifier_space_tech_buff_invisible") then
            damageMult = damageMult + 0.01 * attacker:GetModifierStackCount("modifier_space_tech_buff_invisible", attacker.InventoryUnit)
        end
        if attacker:HasModifier("modifier_nightmare_rider_stacks") then
            local stacks = attacker:GetModifierStackCount("modifier_nightmare_rider_stacks", attacker.InventoryUnit)
            damageMult = damageMult + (stacks * attacker.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_NIGHTMARE_RIDER_MANTLE_GEM_AMETHYST2)) / 100
        end
        if attacker:HasModifier("modifier_jex_orbital_flame_effect") then
            local fireAbility = attacker:FindAbilityByName("jex_fire_cosmic_w")
            damageMult = damageMult + (fireAbility:GetSpecialValueFor("base_ability_damage_per_flame_tech") / 100) * attacker:GetModifierStackCount("modifier_jex_orbital_flame_effect", attacker) * fireAbility.tech_level
        end
        if attacker:HasModifier("modifier_spiritual_empowerment_stack") then
            local current_stack = attacker:GetModifierStackCount("modifier_spiritual_empowerment_stack", attacker.InventoryUnit)
            damageMult = damageMult + current_stack * ITEM_RPC_SPIRITUAL_EMPOWERMENT_GLOVE_BAD/100
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
        if attacker:HasModifier("modifier_goldbreaker_gauntlet") then
            Filters:GoldbreakerAbilityHit(attacker, slot, victim)
        end
    end
    if slot == BASE_ABILITY_Q then
        Util.Modifier:SimpleEvent(attacker, 'GetRoshpitQBaseAbilityDmgBonus', { MODIFIER_ROSHPIT_Q_BASE_ABILITY_DMG_BONUS }, { }, 
            function(result, data)
                damageMult = damageMult + result
            end
        )

        if not ignore_effects then
            if attacker:HasModifier("modifier_cap_of_wild_nature1") or attacker:HasModifier("modifier_cap_of_wild_nature2") then
                Filters:WildNatureTwo(attacker, victim, slot)
            end
        end
        if attacker:GetUnitName() == "npc_dota_hero_templar_assassin" then
            if attacker:HasAbility("fulminating_trap") then
                damageMult = damageMult + TRAPPER_Q4_AMPLIFY_PERCENT*attacker:GetRuneValue("q", 4)
            end
        end
        if attacker:HasModifier("modifier_boreal_granite_vest") then
            damageMult = damageMult + attacker.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_BOREAL_GRANITE_VEST_GEM_AMETHYST)/100
        end
        if attacker:HasModifier("modifier_outland_stone_cuirass") then
            damageMult = damageMult + (ITEM_RPC_OUTLAND_STONE_CUIRASS_BAD + attacker.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue("ruby", ITEM_RPC_OUTLAND_STONE_CUIRASS_GEM_RUBY2))/100
        end
        if attacker:HasModifier("modifier_terrasic_stone_plate") then
            damageMult = damageMult + attacker.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_TERRASIC_STONE_PLATE_GEM_SAPPHIRE)/100
        end
        if attacker:HasModifier("modifier_rubilash_glyph_2_1") then
            damageMult = damageMult + RUBILASH_GLYPH_2_1_Q_BAD/100
        end
        if attacker:HasModifier("modifier_rubilash_immortal_weapon_1") then
            damageMult = damageMult + RUBILASH_IMMORTAL_WEAPON_1_Q_BAD/100
        end
        if attacker:HasModifier("modifier_death_whisper_helm") then
            if not ignore_effects then
                Filters:DeathWhisperApply(attacker, victim)
            end
        end

        if attacker:HasModifier("modifier_conjuror_immortal_weapon_2") then
            if attacker:GetUnitName() == "npc_dota_hero_invoker" then
                damageMult = damageMult + CONJUROR_IMMORTAL_WEAPON_2_BAD_PER_ATTRIBUTES_PCT/100 * (attacker:GetStrength())
            end
        end
        if attacker:HasModifier("modifier_shipyard_veil") then
            local shipyardStacks = attacker:GetModifierStackCount("modifier_shipyard_veil_shield", attacker.InventoryUnit)
            damageMult = damageMult + shipyardStacks*(attacker.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("ruby", SHIPYARD_VEIL_RUBY)/100)
            if not ignore_effects then
                Filters:ShipyardVeilQHit(attacker, victim)
            end
        end
        if attacker:HasModifier("modifier_spirit_warrior_immortal_weapon_1") then
            damageMult = damageMult + SPIRIT_WARRIOR_IMMORTAL_WEAPON_1_Q_DAMAGE_AMP_PCT/100
        end
        if attacker:HasModifier("modifier_royal_wristguards_stack_effect") then
            local current_stack = attacker:GetModifierStackCount("modifier_royal_wristguards_stack_effect", attacker.InventoryUnit)
            damageMult = damageMult + (ITEM_RPC_ROYAL_WRISTGUARDS_Q_BAD/100) * current_stack
        end
        Util.Modifier:SimpleEvent(attacker, 'GetRoshpitQBADMaxOverride', { MODIFIER_ROSHPIT_Q_BASE_ABILITY_MAX_OVERRIDE }, { }, 
            function(result, data)
                damageMult = math.min(damageMult, result/100)
            end
        )
        damage = damage * (1 + damageMult)
        if not ignore_effects then
            Filters:ApplyQdamage(victim, attacker, damage, damage_type)
        end
    elseif slot == BASE_ABILITY_W then
        Util.Modifier:SimpleEvent(attacker, 'GetRoshpitWBaseAbilityDmgBonus', { MODIFIER_ROSHPIT_W_BASE_ABILITY_DMG_BONUS }, { }, 
            function(result, data)
                damageMult = damageMult + result
            end
        )
        if attacker:HasModifier("modifier_magistrates_hood") then
            damageMult = damageMult + attacker.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("amethyst", MAGISTRATE_AMETHYST)/100
        end
        if attacker:HasModifier("modifier_frostburn_gauntlets") then
            damageMult = damageMult + attacker.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_FROSTBURN_GAUNTLETS_GEM_SAPPHIRE1)/100
        end
        if attacker:HasModifier("modifier_skulldigger_hellfire_stacks") then
            if attacker.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetGemValue("sapphire") > 0 then
                Filters:SkulldiggerWraithBlast(attacker.InventoryUnit, attacker.equipped_gear[RPC_GEAR_SLOT_GLOVES], attacker, victim)
            end
        end
        if attacker:HasModifier("modifier_outland_stone_cuirass") then
            damageMult = damageMult + (attacker.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_OUTLAND_STONE_CUIRASS_GEM_SAPPHIRE2))/100
        end
        if attacker:HasModifier("modifier_spellslinger_coat") then
            damageMult = damageMult + ITEM_RPC_SPELLSLINGER_COAT_BAD/100
        end
        if not ignore_effects then
            if attacker:HasModifier("modifier_cap_of_wild_nature2") then
                Filters:WildNatureTwo(attacker, victim, slot)
            end
            if attacker:HasModifier("modifier_shroud_of_eternal_night") then
                Filters:EternalNightW(attacker, victim)
            end
        end
        if attacker:HasModifier("modifier_arkimus_immortal_weapon_1") then
            damageMult = damageMult + ARKIMUS_IMMORTAL_WEAPON_1_W_MULT
        end
        if attacker:HasModifier("modifier_shadowflame_fist") then
            damageMult = damageMult + attacker.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_SHADOWFLAME_FIST_GEM_SAPPHIRE2)/100
        end
		if attacker:HasModifier("modifier_zonik_immortal_weapon_1") then
			damageMult = damageMult + ZHONIK_IMMORTAL_WEAPON_1_W_BAD/100
		end
        if attacker:HasModifier("modifier_crest_of_the_umbral_sentinel") then
            Filters:UmbralSentinel(attacker, victim)
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
        if attacker:HasModifier("modifier_claws_of_the_ethereal_revenant") then
            if not ignore_effects then
                local proc_chance = ITEM_RPC_CLAWS_OF_THE_ETHEREAL_REVENANT_CHANCE + attacker.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("ruby", ITEM_RPC_CLAWS_OF_THE_ETHEREAL_REVENANT_GEM_RUBY1)
                local proc = Filters:GetProc(attacker, proc_chance)
                if proc then
                    local link_duration = ITEM_RPC_CLAWS_OF_THE_ETHEREAL_REVENANT_DURATION + attacker.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_CLAWS_OF_THE_ETHEREAL_REVENANT_GEM_AMETHYST1)
                    Timers:CreateTimer(0.05, function()
                        attacker.equipped_gear[RPC_GEAR_SLOT_GLOVES]:ApplyDataDrivenModifier(attacker.InventoryUnit, victim, "modifier_ethereal_revenant_link", {duration = link_duration})
                    end)
                end
            end
        end

        if attacker:HasModifier("modifier_hood_of_defiler") then
            if not ignore_effects then
                Filters:DefilerHit(attacker, victim)
            end
        end
        if attacker:HasModifier("modifier_astral_glyph_1_1") then
            damage = 0
        end
        if attacker:GetUnitName() == "npc_dota_hero_templar_assassin" then
            if attacker:HasAbility("explosive_bomb") then
                damageMult = damageMult + TRAPPER_W4_AMPLIFY_PERCENT*attacker:GetRuneValue("w", 4)
            end
        end
        Util.Modifier:SimpleEvent(attacker, 'GetRoshpitWBADMaxOverride', { MODIFIER_ROSHPIT_W_BASE_ABILITY_MAX_OVERRIDE }, { }, 
            function(result, data)
                damageMult = math.min(damageMult, result/100)
            end
        )
        damage = damage * (1 + damageMult)
        if not ignore_effects then
            Filters:ApplyWdamage(victim, attacker, damage, damage_type)
        end
    elseif slot == BASE_ABILITY_E then
        Util.Modifier:SimpleEvent(attacker, 'GetRoshpitEBaseAbilityDmgBonus', { MODIFIER_ROSHPIT_E_BASE_ABILITY_DMG_BONUS }, { }, 
            function(result, data)
                damageMult = damageMult + result
            end
        )
        if attacker:HasModifier("modifier_admiral_boots") then
            damageMult = damageMult + ITEM_RPC_ADMIRAL_BOOTS_BAD_E/100
        end
		if attacker:HasModifier("modifier_zhonic_arcana_c_c_invisible") then
			local stacks = attacker:GetModifierStackCount("modifier_zhonic_arcana_c_c_invisible", attacker)
			local multIncrease = stacks * ZHONIK_E3_ARCANA_E_BAD_PCT / 100
			damageMult = damageMult + multIncrease
		end
		if attacker:HasModifier("modifier_zonik_glyph_3_2") then
		local e_3_level = attacker:GetRuneValue("e", 3)
			damageMult = damageMult + ZHONIK_GLYPH_3_2_E3_BAD_PCT*e_3_level/100
		end

        if attacker:HasModifier("modifier_wind_deity_crown") then
            if not ignore_effects then
                if attacker:IsAlive() then
                    if not victim.dummy then
                        local ability = attacker.equipped_gear[RPC_GEAR_SLOT_HEAD]
                        local max_procs_per_second = WIND_DEITY_CROWN_ATTACK_LIMIT + ability:GetFinalGemPropertyValue("sapphire", WIND_DEITY_SAPPHIRE)
                        local limitKey = attacker:GetPlayerOwnerID() .. '_wind_deity'
                        Util.Common:LimitPerTime(max_procs_per_second, WIND_DEITY_CROWN_LIMIT_INTERVAL, limitKey, function()
                            CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_ogre_magi/windstrike_weapon_buff_circle_flash.vpcf", victim, 1)
                            ability:ApplyDataDrivenModifier(attacker.InventoryUnit, attacker, "modifier_wind_deity_cannot_miss", {duration = 0.2})
                            Filters:PerformAttackSpecial(attacker, victim, true, true, true, false, true, false, false)
                            if ability:GetGemValue("amethyst") > 0 then
                                ability:ApplyDataDrivenModifier(attacker.InventoryUnit, attacker, "modifier_wind_deity_damage_buff", {duration = WIND_DEITY_AMETHYST_DURATION})
                                local currentStacks = attacker:GetModifierStackCount("modifier_wind_deity_damage_buff", attacker.InventoryUnit)
                                local newStacks = math.min(currentStacks + 1, WIND_DEITY_AMETHYST_MAX_STACKS)
                                attacker:SetModifierStackCount("modifier_wind_deity_damage_buff", attacker.InventoryUnit, newStacks)

                                ability:ApplyDataDrivenModifier(attacker.InventoryUnit, attacker, "modifier_wind_deity_damage_buff_effect", {duration = WIND_DEITY_AMETHYST_DURATION})
                                local currentStacks = attacker:GetModifierStackCount("modifier_wind_deity_damage_buff_effect", attacker.InventoryUnit)
                                local atk_power_bonus = newStacks*ability:GetFinalGemPropertyValue("amethyst", WIND_DEITY_AMETHYST)
                                attacker:SetModifierStackCount("modifier_wind_deity_damage_buff_effect", attacker.InventoryUnit, atk_power_bonus)
                            end
                        end)
                    end
                end
            end
        end
        if attacker:HasModifier("modifier_conjuror_immortal_weapon_2") then
            if attacker:GetUnitName() == "npc_dota_hero_invoker" then
                damageMult = damageMult + CONJUROR_IMMORTAL_WEAPON_2_BAD_PER_ATTRIBUTES_PCT/100 * (attacker:GetAgility())
            end
        end
        Util.Modifier:SimpleEvent(attacker, 'GetRoshpitEBADMaxOverride', { MODIFIER_ROSHPIT_E_BASE_ABILITY_MAX_OVERRIDE }, { }, 
            function(result, data)
                damageMult = math.min(damageMult, result/100)
            end
        )
        damage = damage * (1 + damageMult)
        if not ignore_effects then
            Filters:ApplyEdamage(victim, attacker, damage, damage_type)
        end
    elseif slot == BASE_ABILITY_R then
        Util.Modifier:SimpleEvent(attacker, 'GetRoshpitRBaseAbilityDmgBonus', { MODIFIER_ROSHPIT_R_BASE_ABILITY_DMG_BONUS }, { }, 
            function(result, data)
                damageMult = damageMult + result
            end
        )
        if attacker:HasModifier("modifier_master_gloves") then
            damageMult = damageMult + ITEM_RPC_MASTER_GLOVES_BAD/100
        end
		if attacker:HasModifier("modifier_mountain_protector_glyph_3_1") then
            damageMult = damageMult - (MOUNTAIN_PROTECTOR_GLYPH_3_1_BAD_R_REDUCE/100)
        end
        if attacker:HasModifier("modifier_galaxy_orb") then
            damageMult = damageMult + attacker.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_GALAXY_ORB_GEM_SAPPHIRE2)/100
        end
        if attacker:HasModifier("modifier_doomplate") then
            Filters:DoomplateApply(attacker, victim)
        end
        if attacker:HasModifier("modifier_aquasteel_bracers") then
            Filters:AquaSteelRHit(attacker, victim)
        end
        if attacker:HasModifier("modifier_axe_arcana1") then
            local r_1_level = attacker:GetRuneValue("r", 1)
            damageMult = damageMult + RED_GENERAL_ARCANA1_R1_AMPLIFY_PERCENT/100*r_1_level
        end
        if attacker:HasModifier("modifier_brazen_kabuto") then
            damageMult = damageMult + attacker.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("emerald", KABUTO_EMERALD)/100
        end
        Util.Modifier:SimpleEvent(attacker, 'GetRoshpitRBADMaxOverride', { MODIFIER_ROSHPIT_R_BASE_ABILITY_MAX_OVERRIDE }, { }, 
            function(result, data)
                damageMult = math.min(damageMult, result/100)
            end
        )
        damage = damage * (1 + damageMult)

        if not ignore_effects then
            Filters:ApplyRdamage(victim, attacker, damage, damage_type)
        end
    end

    if not ignore_effects then
        if Util.BaseType:IsAbilityBaseType(slot)
        or slot == BASE_AUTO_ATTACK then
            if attacker:HasModifier("modifier_mach_punch_passive") then
                local w_4_level = attacker:GetRuneValue("w", 4)
				local w_4_delay = ZHONIK_W4_DELAY
				if attacker:HasModifier("modifier_zonik_glyph_6_2") then
					local delay_reduction = ZHONIK_GLYPH_6_2_W4_DELAY_REDUCTION
					local luck = RandomInt(1, 100)
					if luck <= ZHONIK_GLYPH_6_2_W4_ZERO_DELAY_CHANCE then
						delay_reduction = 4
					end
					w_4_delay = w_4_delay - delay_reduction
					damage = RPCItems:GetLogarithmicVarianceValue(damage, 0, 0, 0, 0)
				end
                if w_4_level > 0 then
                    if not victim.dummy then
                        local ability = attacker:FindAbilityByName("zonik_mach_punch")
                        ability:ApplyDataDrivenModifier(attacker, victim, "modifier_zonik_echo", {duration = w_4_delay})
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
        Filters:ApplyDamageInstances(victim, attacker, damage, damage_type, ability or slot or 0)
    end
    return damage
end

function Filters:AdjustBaseAbilityDamage(victim, attacker, damage, damage_type, slot, element1, element2, ignore_effects, ability)
    if attacker:HasModifier("modifier_angelic_gloves_of_the_judiciary") then
        if not ignore_effects then
            if slot == BASE_ABILITY_W then
                if attacker.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetGemValue("emerald") > 0 then
                    damage = damage + attacker:GetHealth()
                end
            end
        end
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
    if unit:HasModifier("modifier_voltex_rune_e_3_heavens_charge_falling") or unit:HasModifier("modifier_z_flight") or unit:HasModifier("modifier_hawk_soar_visual_z") or unit:HasModifier("modifier_shapeshift_crow") or unit:HasModifier("modifier_dinath_postflight_zheight") or unit:HasModifier("modifier_thunder_blossom_teleporting") or unit:HasModifier("modifier_jex_lightning_lightning_e_movement") or unit:HasModifier("modifier_wind_temple_light_beam_effect") then
        return true
    else
        return false
    end
end

function Filters:ApplyQdamage(victim, attacker, damage, damage_type)
    if attacker:HasModifier("modifier_vampiric_breastplate") then
        Filters:VampiricBreastplate(attacker, damage, "q_ability", "modifier_vampiric_breastplate")
    end
    if attacker:HasModifier("modifier_mountain_vambraces") then
        local vambrace = attacker.equipped_gear[RPC_GEAR_SLOT_GLOVES]
        local proc = Filters:GetProc(attacker, vambrace:GetFinalGemPropertyValue("amethyst", ITEM_RPC_MOUNTAIN_VAMBRACES_GEM_AMETHYST1))
        if proc then
            Filters:MountainVambrace(attacker, victim, vambrace)
        end
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
        if type(slot) == "table" and slot:GetAbilityName() == "auto_attack_damage_ability" then
            instances = 1
        else
            instances = instances + ITEM_RPC_HEAVY_ECHO_GAUNTLET_REPEATS
            if attacker.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetGemValue("ruby") > 0 then
                local proc = Filters:GetProc(attacker, attacker.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("ruby", ITEM_RPC_HEAVY_ECHO_GAUNTLET_GEM_RUBY))
                if proc then
                    instances = instances + 1
                end
            end
            if attacker:HasModifier("modifier_heavy_echo_extra_echo") then
                instances = instances + 1
                attacker.equipped_gear[RPC_GEAR_SLOT_GLOVES]:ApplyDataDrivenModifier(attacker.InventoryUnit, attacker, "modifier_heavy_echo_remove_extra_echo", {duration = 0.03})
            end
        end
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
    if victim.dummy then
        instances = 1
    end

    ------------------------------------------------------------------------------------------------------
    -- below is ApplyDamage (aka actual damage applying), do instances calculation before the Maginot Line
    if attacker:HasModifier("modifier_magistrates_hood") then
        if damage_type == DAMAGE_TYPE_MAGICAL or damage_type == DAMAGE_TYPE_PURE then
            local stacks = attacker:GetModifierStackCount("modifier_magistrates_hood_charges", attacker.InventoryUnit)
            if stacks > 0 then
                --print("modifier_magistrates_hood stacks "..tostring(stacks))
                local amp_per_enemy = MAGISTRATE_HOOD_DAMAGE_AMP_PCT + attacker.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("emerald", MAGISTRATE_EMERALD)
                local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), victim:GetAbsOrigin(), nil, MAGISTRATE_HOOD_AOE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
                local magistrate_damage = damage*(1 + ((amp_per_enemy*0.01*#enemies)))
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
                local colorVector = Vector(0.5, 0.5, 0.5)
                if attacker.element1 then
                    colorVector = Elements:RGBVectorFromElementIndex(attacker.element1)
                end
                --print(colorVector)
                local pfx = CustomAbilities:QuickParticleAtPoint("particles/roshpit/items/magistrate_hood_gold.vpcf", victim:GetAbsOrigin(), 3)
                ParticleManager:SetParticleControl(pfx, 12, colorVector)
            end
        end
        --print("damage_type "..tostring(damage_type))
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
        require('heroes/faceless_void/omniro_common')
        mult = mult + OmniroElementalBonus(element1, element2, attacker)
    end
    if element1 == RPC_ELEMENT_NORMAL then
        if bIsRealDamage then
            if attacker:HasModifier("modifier_djanghor_glyph_5_a") then
                element2 = RPC_ELEMENT_NATURE
            end
        end
    end
    if element2 == RPC_ELEMENT_NORMAL then
        if bIsRealDamage then
            if attacker:HasModifier("modifier_djanghor_glyph_5_a") then
                element1 = RPC_ELEMENT_NATURE
            end
        end
    end
	if unitName == "npc_dota_hero_phantom_assassin" then
		if attacker:HasModifier("modifier_voltex_immortal_weapon_4") then
			if bIsRealDamage then
				if element1 == RPC_ELEMENT_LIGHTNING then
					element2 = RPC_ELEMENT_ICE
				end
				if element2 == RPC_ELEMENT_LIGHTNING and element1 ~= RPC_ELEMENT_LIGHTNING then
					element1 = RPC_ELEMENT_ICE
				end
			end
		end
	end
	if unitName == "npc_dota_hero_faceless_void" then
		if attacker:HasModifier("modifier_omniro_immortal_weapon_4") then
			if bIsRealDamage and slot ~= 0 then
				 element2 = RPC_ELEMENT_NORMAL
			end
		end
	end
    if element1 > 1 or element2 > 1 then
        if attacker:HasModifier("modifier_demonfire_stack") then
            local stacks = attacker:GetModifierStackCount("modifier_demonfire_stack", attacker.InventoryUnit)
            mult = mult + stacks * ITEM_RPC_DEMONFIRE_GAUNTLET_ELEMENTAL_AMP_PCT/100
        end
        if attacker:HasModifier("modifier_grand_arcanist") then
            mult = mult + (attacker.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_GRAND_ARCANIST_WRAPS_GEM_AMETHYST)/100) * attacker:GetIntellect()
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
            damage = damage * 0.5
        end
        mult = mult + (CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_head_all_elements", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_weapon_all_elements", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_hands_all_elements", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_feet_all_elements", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_body_all_elements", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_amulet_all_elements", 1))/100
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

    local elements = {}
    if element1 ~= RPC_ELEMENT_NONE then
        table.insert(elements, element1)
    end
    if element2 ~= RPC_ELEMENT_NONE then
        table.insert(elements, element2)
    end
    Util.Modifier:SimpleEvent(attacker, 'GetRoshpitElementalDmgBonus', elements, { }, 
        function(result, data)
            mult = mult + result
        end
    )

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



    if element1 == RPC_ELEMENT_NORMAL or element2 == RPC_ELEMENT_NORMAL then
        local normalMult = 0
        if attacker:HasModifier("modifier_trapper_arcana1") then
            local w_2_level = attacker:GetRuneValue("w", 2)
            normalMult = normalMult + w_2_level * TRAPPER_ARCANA_W_W2_NORMAL_PCT
        end
        if attacker:HasModifier('modifier_trapper_glyph_6_1') then
            normalMult = normalMult + TRAPPER_GLYPH_6_1_NORMAL_AMP
        end
        normalMult = normalMult + (CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_head_element_normal", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_weapon_element_normal", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_hands_element_normal", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_feet_element_normal", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_body_element_normal", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_amulet_element_normal", 1))/100
        mult = mult + normalMult
    end
    if element1 == RPC_ELEMENT_FIRE or element2 == RPC_ELEMENT_FIRE then
        local fireMult = 0
        if attacker:HasModifier("modifier_dinath_glyph_6_1") then
            fireMult = fireMult + DINATH_GLYPH_6_1_FIRE_ICE_LIGHTING_COSMIC_AMP/100
        end
        if unitName == "npc_dota_hero_visage" then
            if attacker:HasModifier("modifier_ekkan_arcana2c") then
                mult = mult + attacker:GetRuneValue("w", 4)*EKKAN_ARCANA_W4C_ELEMENTAL_AMP/100
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
            fireMult = fireMult + SORCERESS_R3_FIRE_AMP * runesCount
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
		if attacker:HasAbility("summon_earth_aspect") then
		   fireMult = fireMult + CONJUROR_Q4_EARTH_AND_FIRE_AMP * attacker.q_4_level
		end
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
        end
        if unitName == "npc_dota_hero_arc_warden" then
            if attacker:HasModifier("modifier_jex_arcana1") then
                if attacker.w_2_level then
                    fireMult = fireMult + attacker.w_2_level * JEX_RUNE_ROW_2_VALUE
                end
            end
        end
        fireMult = fireMult + (CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_head_element_fire", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_weapon_element_fire", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_hands_element_fire", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_feet_element_fire", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_body_element_fire", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_amulet_element_fire", 1))/100

        mult = mult + fireMult
    end
    if element1 == RPC_ELEMENT_EARTH or element2 == RPC_ELEMENT_EARTH then
        if unitName == "npc_dota_hero_beastmaster" then
            if attacker:HasModifier("modifier_warlord_earth_charge") then
                local stacks = attacker:GetModifierStackCount("modifier_warlord_earth_charge", attacker)
                mult = mult + stacks * (WARLORD_EARTH_CHARGE_ELEMENT_BONUS_PCT/100)
            end
            if attacker.e_4_level then
                mult = mult + WARLORD_E4_ICE_EARTH_FIRE_BONUS * attacker.e_4_level
            end
        elseif unitName == "npc_dota_hero_invoker" then
            if attacker:HasAbility("summon_earth_aspect") then
		local q_4_level = attacker:GetRuneValue("q", 4) 
		mult = mult + CONJUROR_Q4_EARTH_AND_FIRE_AMP * q_4_level
	    elseif attacker:HasAbility("summon_earth_deity") then
		local q_4_level = attacker:GetRuneValue("q", 4)
		mult = mult + CONJUROR_ARCANA_Q4_EARTH_AMP * attacker.q_4_level / 100
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
        if attacker:GetUnitName() == "npc_dota_hero_visage" then
            if attacker:HasModifier("modifier_ekkan_arcana2a") then
                mult = mult + attacker:GetRuneValue("w", 4)*EKKAN_ARCANA_W4A_ELEMENTAL_AMP/100
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
                mult = mult + e_4_level*(PALADIN_ARCANA2_E4_HOLY_AMP_PER_SPIRIT/100)*attacker:GetSpirit()
            end
        elseif unitName == "npc_dota_hero_leshrac" then
            if attacker.e_4_level then
                mult = mult + BAHAMUT_E4_HOLY_AMP * attacker.e_4_level
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
                mult = mult + stacks * SEPHYR_Q3_HOLY_AMP_PCT/100
            end
        elseif unitName == "npc_dota_hero_juggernaut" then
            if attacker:HasAbility("seinaru_odachi_leap") then
                if attacker.e_4_level and attacker.e_4_level > 0 then
                    local multIncrease = attacker.e_4_level * SEINARU_E4_HOLY_AMP
                    mult = mult + multIncrease
                end
            else
                if attacker.e_4_level and attacker.e_4_level > 0 then
                    local multIncrease = attacker.e_4_level * SEINARU_ARCANA2_E4_HOLY_AMP/100
                    mult = mult + multIncrease
                end
            end
        end
        if attacker:HasModifier("modifier_gilded_soul_buff") then
            local stacks = attacker:GetModifierStackCount("modifier_gilded_soul_buff", attacker.InventoryUnit)
            mult = mult + stacks * ITEM_RPC_GILDED_SOUL_CAGE_ELEMENT_HOLY_AMP/100
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
			if attacker:HasModifier("modifier_astral_glyph_7_2") then
			cosmosMult = cosmosMult + (attacker:GetRuneValue("q", 4) + attacker:GetRuneValue("w", 4) + attacker:GetRuneValue("e", 4) + attacker:GetRuneValue("r", 4))*ASTRAL_RANGER_GLYPH_7_2_COSMIC_DMG_PER_T4/100
			end
            -- if victim:HasModifier("modifier_apollo_c_b_proc_invisible") then
            --     cosmosMult = cosmosMult + 0.01 * victim:GetModifierStackCount("modifier_apollo_c_b_proc_invisible", attacker)
            -- end
        end
        if attacker:GetUnitName() == "npc_dota_hero_arc_warden" then
            if attacker.e_2_level then
                cosmosMult = cosmosMult + attacker.e_2_level * JEX_RUNE_ROW_2_VALUE
            end
            if attacker:HasModifier("modifier_jex_cosmic_surge") then
                local e_4_level = attacker:GetRuneValue("e", 4)
                cosmosMult = cosmosMult + e_4_level * JEX_LIGHTNING_COSMIC_E_COSMIC_AMP_PER_E4
            end
        end
        cosmosMult = cosmosMult + (CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_head_element_cosmic", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_weapon_element_cosmic", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_hands_element_cosmic", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_feet_element_cosmic", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_body_element_cosmic", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_amulet_element_cosmic", 1))/100

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
        elseif unitName == "npc_dota_hero_visage" then
            if attacker:HasModifier("modifier_ekkan_arcana2b") then
                mult = mult + attacker:GetRuneValue("w", 4)*EKKAN_ARCANA_W4B_ELEMENTAL_AMP/100
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
            mult = mult + (stacks * attacker.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_NIGHTMARE_RIDER_MANTLE_GEM_AMETHYST1)) / 100
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
                mult = mult + (SEINARU_W4_WIND_AMP/100) * attacker.w_4_level
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
        if attacker:HasModifier("modifier_sweeping_wind_stackable") then
            mult = mult + (attacker.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("emerald", ITEM_RPC_GLOVES_OF_SWEEPING_WIND_GEM_EMERALD)/100)*attacker:GetModifierStackCount("modifier_sweeping_wind_stackable", attacker.InventoryUnit)
        end
        mult = mult + (CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_head_element_wind", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_weapon_element_wind", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_hands_element_wind", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_feet_element_wind", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_body_element_wind", 1) + CustomAttributes:AddStatsBonusFromStacks(attacker, attacker.InventoryUnit, "modifier_amulet_element_wind", 1))/100
    end
    if element1 == RPC_ELEMENT_GHOST or element2 == RPC_ELEMENT_GHOST then
        if attacker:GetUnitName() == "npc_dota_hero_spirit_breaker" then
            local r_4_level = attacker:GetRuneValue("r", 4)
            mult = mult + DUSKBRINGER_R4_GHOST_AMP * r_4_level
        elseif unitName == "npc_dota_hero_grimstroke" then
            mult = mult + attacker:GetRuneValue("q", 4)*RUBILASH_RUNE_Q4_DEMON_AND_GHOST_AMP/100
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

        mult = mult + waterMult
    end
    if element1 == RPC_ELEMENT_DEMON or element2 == RPC_ELEMENT_DEMON then
        if unitName == "npc_dota_hero_grimstroke" then
            mult = mult + attacker:GetRuneValue("q", 4)*RUBILASH_RUNE_Q4_DEMON_AND_GHOST_AMP/100
        end
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
            if attacker:HasModifier("modifier_ekkan_arcana2a") or attacker:HasModifier("modifier_ekkan_arcana2b") or attacker:HasModifier("modifier_ekkan_arcana2c") then
                mult = mult + attacker:GetRuneValue("w", 4)*EKKAN_ARCANA_W4A_ELEMENTAL_AMP/100
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
    -- if bIsRealDamage and not damageData.ignoreMultipliers and not damageData.ignoreElements then
    --     Filters:PostElementalDamage(victim, attacker, damage * mult, damage_type, slot, element1, element2, bIsRealDamage)
    -- end
    if not damageData.ignoreMultipliers and not damageData.ignoreElements then
        damage = damage * mult/divisor
    end
    return damage, element1, element2
end

function Filters:PostElementalDamage(victim, attacker, damage, damage_type, slot, element1, element2, bIsRealDamage)

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
    -- local damage = caster:GetStrength()*60"particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf"
    -- local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
    -- if #enemies > 0 then
    --     for _,enemy in pairs(enemies) do
    --         Filters:ApplyItemDamage(enemy,caster,damage,DAMAGE_TYPE_MAGICAL,nil)
    --         Filters:ApplyStun(caster, 1.5, enemy)
    --     end
    -- end
    local avalanche_plate = caster.equipped_gear[RPC_GEAR_SLOT_BODY]
    local position = caster:GetAbsOrigin()
    EmitSoundOnLocationWithCaster(position, "RPCItem.AvalancheStart", caster)
    local avalancheParticle = "particles/units/heroes/hero_tiny/tiny_avalanche.vpcf"

    local radius = ITEM_RPC_AVALANCHE_PLATE_AVALANCHE_RADIUS
    local pfx = ParticleManager:CreateParticle(avalancheParticle, PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(pfx, 0, position)
    ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
    avalanche_plate:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_avalanche_thinker", {duration = ITEM_RPC_AVALANCHE_PLATE_DURATION})
    avalanche_plate.pfx = pfx
    avalanche_plate.strikeCount = 0
    Timers:CreateTimer(4, function()
        ParticleManager:DestroyParticle(pfx, false)
    end)
    --print("AVALANCHE TRIGGER")
end

function Filters:SeraphicVest(caster, ability_slot)
    local limitKey = caster:GetPlayerOwnerID() .. '_seraphic_soul_vest'
    Util.Common:LimitPerTime(4, 1, limitKey, function()
        local soul_vest = caster.equipped_gear[RPC_GEAR_SLOT_BODY]
        soul_vest.hero = caster
        local projectile_speed = 650 + soul_vest:GetFinalGemPropertyValue("ruby", ITEM_RPC_SERAPHIC_SOULVEST_GEM_RUBY1)
        local projectile_count = 0
        if ability_slot == BASE_ABILITY_W then
            projectile_count = 1
            local proc = Filters:GetProc(caster, soul_vest:GetFinalGemPropertyValue("emerald", ITEM_RPC_SERAPHIC_SOULVEST_GEM_EMERALD))
            if proc then
                projectile_count = 2
            end
            local mana_drain = caster:GetMaxMana() * ITEM_RPC_SERAPHIC_SOULVEST_MANA_COST_PCT/100
            caster:ReduceMana(mana_drain)
        elseif ability_slot == BASE_ABILITY_R then
            EmitSoundOn("RPCItem.Seraphic.Amethyst", caster)
            projectile_count = soul_vest:GetFinalGemPropertyValue("amethyst", ITEM_RPC_SERAPHIC_SOULVEST_GEM_AMETHYST)
        end
        --print(projectile_count)
        local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, ITEM_RPC_SERAPHIC_SOULVEST_RADIUS_OF_SEARCH, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
        if #enemies > 0 then
            local cycles = math.ceil(projectile_count/#enemies)
            for i = 1, cycles,  1 do
                Timers:CreateTimer((i-1)*0.2, function()
                    local projectiles_so_far = (i-1)*#enemies
                    for j = 1, #enemies, 1 do
                        if projectiles_so_far < projectile_count then
                            projectiles_so_far = projectiles_so_far + 1
                            local info =
                                {
                                    Target = enemies[j],
                                    Source = caster,
                                    Ability = soul_vest,
                                    EffectName = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_concussive_shot.vpcf",
                                    StartPosition = "attach_hitloc",
                                    bDrawsOnMinimap = false,
                                    bDodgeable = true,
                                    bIsAttack = false,
                                    bVisibleToEnemies = true,
                                    bReplaceExisting = false,
                                    flExpireTime = GameRules:GetGameTime() + 8,
                                    bProvidesVision = true,
                                    iVisionRadius = 0,
                                    iMoveSpeed = projectile_speed,
                                iVisionTeamNumber = caster:GetTeamNumber()}
                            projectile = ProjectileManager:CreateTrackingProjectile(info)
                        end
                    end
                end)
            end
        end
    end)
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
    local coat = caster.equipped_gear[RPC_GEAR_SLOT_BODY]
    local ability = caster:GetAbilityByIndex(DOTA_W_SLOT)
    local manaCost = ability:GetManaCost(-1)
    local manaRestore = manaCost * ITEM_RPC_SPELLSLINGER_COAT_MANA_RESTORE/100
    manaRestore = WallPhysics:round(manaRestore, 0)
    caster:GiveMana(manaRestore)
    PopupMana(caster, manaRestore)
    if coat:GetGemValue("emerald") > 0 then
        coat:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_spellslinger_emerald", {duration = ITEM_RPC_SPELLSLINGER_COAT_EMERALD_DURATION})
        local new_stacks = math.min(caster:GetModifierStackCount("modifier_spellslinger_emerald", caster.InventoryUnit) + 1, ITEM_RPC_SPELLSLINGER_COAT_EMERALD_MAX_STACKS)
        caster:SetModifierStackCount("modifier_spellslinger_emerald", caster.InventoryUnit, new_stacks)
    end
end

function Filters:SpellslingerCoatQ(caster)
	local inventoryUnit = caster.InventoryUnit
    local coat = caster.equipped_gear[RPC_GEAR_SLOT_BODY]
    if coat:GetGemValue("ruby") > 0 then
        local proc = Filters:GetProc(caster, coat:GetFinalGemPropertyValue("ruby", ITEM_RPC_SPELLSLINGER_COAT_GEM_RUBY))
        if proc then
            local q_ability = caster:GetAbilityByIndex(DOTA_Q_SLOT)
			if not caster:HasModifier("modifier_spellslinger_ruby_cooldown") then
				q_ability:EndCooldown()
				coat:ApplyDataDrivenModifier(inventoryUnit, caster, "modifier_spellslinger_ruby_cooldown", {duration = GLOBAL_Q_MIN_CD})
			end
        end
    end
end

function Filters:DoomplateCast(caster)
    local inventoryUnit = caster.InventoryUnit
    local ability = caster.equipped_gear[RPC_GEAR_SLOT_BODY]
    ability:ApplyDataDrivenModifier(inventoryUnit, caster, "modifier_doomplate_doom_self_debuff", {duration = ITEM_RPC_DOOMPLATE_SELF_DEBUFF_DURATION})   
end

function Filters:DoomplateApply(attacker, victim)
    local inventoryUnit = attacker.InventoryUnit
    local ability = attacker.equipped_gear[RPC_GEAR_SLOT_BODY]
    ability:ApplyDataDrivenModifier(inventoryUnit, victim, "modifier_doomplate_doom_enemy_debuff", {duration = ITEM_RPC_DOOMPLATE_ENEMY_DEBUFF_DURATION})
end

function Filters:WhiteMageHat(caster)
    local ability = caster.equipped_gear[RPC_GEAR_SLOT_HEAD]
    local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, WHITE_MAGE_RADIUS, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    local healAmount = caster:GetIntellect() * WHITE_MAGE_INT_TO_HEAL + caster:GetSpirit() * ability:GetFinalGemPropertyValue("amethyst", WHITE_MAGE_AMETHYST) 
    local inventoryUnit = caster.InventoryUnit
    local mana_drain = caster:GetMaxMana()*(WHITE_MAGE_EXTRA_MANA_COST_PCT_MAX/100)
    caster:ReduceMana(mana_drain)
    if #allies > 0 then
        for _, ally in pairs(allies) do
            ally:RemoveModifierByName("modifier_white_mage_hat_effect")
            ability:ApplyDataDrivenModifier(inventoryUnit, ally, "modifier_white_mage_hat_effect", {})
            Filters:ApplyHeal(caster, ally, healAmount, true, true, ability)
        end
    end
end

function Filters:DeathWhisperApply(attacker, victim)
    local inventoryUnit = attacker.InventoryUnit
    attacker.equipped_gear[RPC_GEAR_SLOT_HEAD]:ApplyDataDrivenModifier(inventoryUnit, victim, "modifier_death_whisper_debuff", {duration = DEATH_WHISPER_DURATION})
end

function Filters:DeathWhisperSapphire(caster)
    if caster.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetGemValue("sapphire") > 0 then
        local ability = caster.equipped_gear[RPC_GEAR_SLOT_HEAD]
        local duration = caster.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("sapphire", DEATH_WHISPER_SAPPHIRE)
        local pfx2 = CustomAbilities:QuickAttachParticle("particles/roshpit/conjuror/shadow_deity_cloak_of_shadows.vpcf", caster, duration)
        ParticleManager:SetParticleControl(pfx2, 1, Vector(200, 200, 200))
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_invisibility_datadriven", {duration = duration})
        caster:AddNewModifier(caster, ability, "modifier_persistent_invisibility", {duration = duration})
    end
end

function Filters:WildNatureTwo(attacker, victim, slot)
    if slot == BASE_ABILITY_W then
        local proc = Filters:GetProc(attacker, CAP_OF_WILD_NATURE_CHANCE_TWO)
        if proc then
            local inventoryUnit = attacker.InventoryUnit
            local ability = attacker.equipped_gear[RPC_GEAR_SLOT_HEAD]
            ability:ApplyDataDrivenModifier(inventoryUnit, victim, "modifier_wild_nature_entangle_effect", {duration = CAP_OF_WILD_NATURE_DURATION_TWO})
        end
    elseif slot == BASE_ABILITY_Q then
        local proc = Filters:GetProc(attacker, CAP_OF_WILD_NATURE_SAPPHIRE_PROC)
        if proc then
            local inventoryUnit = attacker.InventoryUnit
            local ability = attacker.equipped_gear[RPC_GEAR_SLOT_HEAD]
            local duration = attacker.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("sapphire", WILD_NATURE_SAPPHIRE)
            ability:ApplyDataDrivenModifier(inventoryUnit, victim, "modifier_wild_nature_entangle_effect", {duration = duration})
        end
    end
end

function Filters:LumaGuardStrike(attacker, victim, damage)
    local luma = attacker.equipped_gear[RPC_GEAR_SLOT_HEAD]
    local chance = LUMA_BEAM_CHANCE + luma:GetFinalGemPropertyValue("ruby", LUMA_RUBY)    
    local proc = Filters:GetProc(attacker, chance)
    if proc then
        local max_procs_per_second = LUMA_MAX_PROCS_PER_SECOND + luma:GetFinalGemPropertyValue("emerald", LUMA_EMERALD)  
        local limitKey = attacker:GetPlayerOwnerID() .. '_luma_guard'
        Util.Common:LimitPerTime(max_procs_per_second, 1, limitKey, function()
            local inventoryUnit = attacker.InventoryUnit
            local ability = attacker.equipped_gear[RPC_GEAR_SLOT_HEAD]
            victim:RemoveModifierByName("modifier_luma_guard_moonbeam")
            ability:ApplyDataDrivenModifier(inventoryUnit, victim, "modifier_luma_guard_moonbeam", {duration = LUMA_VISION_DURATION})
            AddFOWViewer(attacker:GetTeamNumber(), victim:GetAbsOrigin(), 500, LUMA_VISION_DURATION, false)
            local damage = damage * (LUMA_DAMAGE_AMP + luma:GetFinalGemPropertyValue("amethyst", LUMA_AMETHYST))/100
            Filters:ApplyItemDamage(victim, attacker, damage, DAMAGE_TYPE_PURE, nil, RPC_ELEMENT_COSMOS, RPC_ELEMENT_NONE)  
            EmitSoundOn("RPC.LumaGuard.Impact", victim)
        end)
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
    local cooldown = SWAMP_WITCH_COOLDOWN
    local witch_hat = caster.equipped_gear[RPC_GEAR_SLOT_HEAD]
    if witch_hat:GetGemValue("emerald") > 0 then
        cooldown = witch_hat:GetFinalGemPropertyValue("emerald", SWAMP_WITCH_EMERALD)
    end
    local limitKey = caster:GetPlayerOwnerID() .. '_witch_hat'
    Util.Common:LimitPerTime(1, cooldown, limitKey, function()
        local fv = caster:GetForwardVector()
        local ability = caster.equipped_gear[RPC_GEAR_SLOT_HEAD]
        ability.caster = caster
        local projectileParticle = "particles/econ/items/death_prophet/death_prophet_acherontia/death_prophet_acher_swarm.vpcf"
        local projectileOrigin = caster:GetAbsOrigin() + fv * 10
        local start_radius = 120
        local end_radius = 400
        local range = 1000 + witch_hat:GetFinalGemPropertyValue("sapphire", SWAMP_WITCH_SAPPHIRE2)
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
    end)
end

function Filters:TricksterMask(caster)
    local trickster_mask = caster.equipped_gear[RPC_GEAR_SLOT_HEAD]
    local randomPosition = trickster_mask.trickster:GetAbsOrigin() + RandomVector(RandomInt(60, trickster_mask.trickster.radius))
    randomPosition = WallPhysics:WallSearch(caster:GetAbsOrigin(), randomPosition, caster)
    FindClearSpaceForUnit(caster, randomPosition, false)
    caster:RemoveModifierByName("modifier_trickster_mask_effect")
    EmitSoundOn("RPCItem.TricksterMask", caster)
    trickster_mask:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_trickster_mask_effect", {duration = 0.5})
    ProjectileManager:ProjectileDodge(caster)
end

function Filters:SecretTemple(caster)
    local inventoryUnit = caster.InventoryUnit
    local armor = caster.equipped_gear[RPC_GEAR_SLOT_BODY]
    armor:ApplyDataDrivenModifier(inventoryUnit, caster, "modifier_secret_temple_refraction", {duration = ITEM_RPC_ARMOR_OF_SECRET_TEMPLE_SHIELDS_DURATION})
    caster:SetModifierStackCount("modifier_secret_temple_refraction", armor, ITEM_RPC_ARMOR_OF_SECRET_TEMPLE_SHIELDS)
    if armor:GetGemValue("sapphire") > 0 then
        armor:ApplyDataDrivenModifier(inventoryUnit, caster, "modifier_secret_temple_sapphire_damage_increase", {duration = ITEM_RPC_ARMOR_OF_SECRET_TEMPLE_SHIELDS_DURATION})
        caster:SetModifierStackCount("modifier_secret_temple_sapphire_damage_increase", armor, armor:GetFinalGemPropertyValue("sapphire", ITEM_RPC_ARMOR_OF_SECRET_TEMPLE_GEM_SAPPHIRE))
    end
end

function Filters:SecretTempleQ(caster)
    local inventoryUnit = caster.InventoryUnit
    local armor = caster.equipped_gear[RPC_GEAR_SLOT_BODY]
    if armor:GetGemValue("amethyst") > 0 and caster:HasModifier("modifier_secret_temple_refraction") then
        local proc = Filters:GetProc(caster, armor:GetFinalGemPropertyValue("amethyst", ITEM_RPC_ARMOR_OF_SECRET_TEMPLE_GEM_AMETHYST))
        if proc then
            local new_stacks = math.min(caster:GetModifierStackCount("modifier_secret_temple_refraction", armor) + 1, ITEM_RPC_ARMOR_OF_SECRET_TEMPLE_SHIELDS)
            caster:SetModifierStackCount("modifier_secret_temple_refraction", armor, new_stacks)
        end
    end
end

function Filters:VampiricBreastplate(vampire, damage, vamp_type, vamp_modifier)
    local vampiric_inventory_unit = vampire:FindModifierByName(vamp_modifier):GetCaster()
    local vampiric_owner = vampiric_inventory_unit.hero
    local vampiric_breastplate = vampiric_owner.equipped_gear[RPC_GEAR_SLOT_BODY]
    local lifesteal_percent = 0
    if vamp_type == "attack" then
        lifesteal_percent = (ITEM_RPC_VAMPIRIC_BREASTPLATE_ATTACK_HEAL_PCT + vampiric_breastplate:GetFinalGemPropertyValue("sapphire", ITEM_RPC_VAMPIRIC_BREASTPLATE_GEM_SAPPHIRE))/100
        if vampiric_owner ~= vampire then
            lifesteal_percent = lifesteal_percent*(vampiric_breastplate:GetFinalGemPropertyValue("ruby", ITEM_RPC_VAMPIRIC_BREASTPLATE_GEM_RUBY)/100)
        end
    elseif vamp_type == "q_ability" then
        if vampiric_breastplate:GetGemValue("emerald") > 0 then
            lifesteal_percent = (vampiric_breastplate:GetFinalGemPropertyValue("emerald", ITEM_RPC_VAMPIRIC_BREASTPLATE_GEM_EMERALD))/100
        else
            return false
        end
    end
    local heal = math.max(math.floor(damage * lifesteal_percent), 0)

    Filters:ApplyHeal(vampire, vampire, heal, true, true)
    local limitKey = vampire:GetEntityIndex() .. '_vampiric'
    Util.Common:LimitPerTime(2, 1, limitKey, function()      
        local particleName = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
        local pfx = ParticleManager:CreateParticle(particleName, PATTACH_POINT_FOLLOW, vampire)
        ParticleManager:SetParticleControlEnt(pfx, 0, vampire, PATTACH_POINT_FOLLOW, "attach_hitloc", vampire:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(pfx, 1, vampire, PATTACH_POINT_FOLLOW, "attach_hitloc", vampire:GetAbsOrigin(), true)
        Timers:CreateTimer(1, function()
            ParticleManager:DestroyParticle(pfx, false)
        end)
    end)
end

function Filters:SpiritGlove(caster, duration)
    local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, ITEM_RPC_SPIRIT_GLOVE_RADIUS, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    local healAmount = math.ceil(caster:GetSpirit() * ITEM_RPC_SPIRIT_GLOVE_SPR_TO_HEAL) + caster.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("ruby", ITEM_RPC_SPIRIT_GLOVE_GEM_RUBY2)
    local spiritGlove = caster.equipped_gear[RPC_GEAR_SLOT_GLOVES]
    spiritGlove.healAmount = healAmount
    if #allies > 0 then
        for _, ally in pairs(allies) do
            Filters:SpiritGloveHeal(caster, ally, spiritGlove)
            spiritGlove:ApplyDataDrivenModifier(caster.InventoryUnit, ally, "modifier_spirit_glove_effect", {duration = duration})
        end
    end
end

function Filters:SpiritGloveHeal(caster, ally, spiritGlove)
    local particleName = "particles/roshpit/items/spirit_glove_heal.vpcf"
    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, ally)
    ParticleManager:SetParticleControlEnt(pfx, 0, ally, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", ally:GetAbsOrigin(), true)
    Timers:CreateTimer(1.5, function()
        ParticleManager:DestroyParticle(pfx, false)
    end)
    local healAmount = spiritGlove.healAmount
    Filters:ApplyHeal(caster, ally, healAmount, true, true)
    if spiritGlove:GetGemValue("sapphire") > 0 then
        spiritGlove:ApplyDataDrivenModifier(caster.InventoryUnit, ally, "modifier_spirit_glove_stacking_attack_power", {duration = ITEM_RPC_SPIRIT_GLOVE_DURATION})
        local new_stacks = math.min(ally:GetModifierStackCount("modifier_spirit_glove_stacking_attack_power", caster.InventoryUnit) + 1, ITEM_RPC_SPIRIT_GLOVE_SAPPHIRE_STACKS)
        ally:SetModifierStackCount("modifier_spirit_glove_stacking_attack_power", caster.InventoryUnit, new_stacks)

        spiritGlove:ApplyDataDrivenModifier(caster.InventoryUnit, ally, "modifier_spirit_glove_stacking_attack_power_invisible", {duration = ITEM_RPC_SPIRIT_GLOVE_DURATION})
        local attack_power_stacks = new_stacks * spiritGlove:GetFinalGemPropertyValue("sapphire", ITEM_RPC_SPIRIT_GLOVE_GEM_SAPPHIRE)
        ally:SetModifierStackCount("modifier_spirit_glove_stacking_attack_power_invisible", caster.InventoryUnit, attack_power_stacks)
    end
end

function Filters:FrostburnGauntlet(attacker, victim, damage)
    local frostburn_gauntlets = attacker.equipped_gear[RPC_GEAR_SLOT_GLOVES]
    local proc_chance = ITEM_RPC_FROSTBURN_GAUNTLET_PROC_CHANCE + frostburn_gauntlets:GetFinalGemPropertyValue("emerald", ITEM_RPC_FROSTBURN_GAUNTLETS_GEM_EMERALD1)
    local proc = Filters:GetProc(attacker, proc_chance)
    local max_procs_per_second = ITEM_RPC_FROSTBURN_GAUNTLET_MAX_PROCS_PER_SECOND + frostburn_gauntlets:GetFinalGemPropertyValue("emerald", ITEM_RPC_FROSTBURN_GAUNTLETS_GEM_EMERALD2)
    local limitKey = attacker:GetPlayerOwnerID() .. '_frostburn_gauntlets'
    Util.Common:LimitPerTime(max_procs_per_second, 1, limitKey, function()
        local damage = damage*((ITEM_RPC_FROSTBURN_GAUNTLET_DAMAGE_PCT + frostburn_gauntlets:GetFinalGemPropertyValue("amethyst", ITEM_RPC_FROSTBURN_GAUNTLETS_GEM_AMETHYST1))/100) + frostburn_gauntlets:GetFinalGemPropertyValue("ruby", ITEM_RPC_FROSTBURN_GAUNTLETS_GEM_RUBY2)
        CustomAbilities:QuickAttachParticle("particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/cm_arcana_pup_flee.vpcf", victim, 3)
        if proc then
            local icePoint = victim:GetAbsOrigin()
            local radius = ITEM_RPC_FROSTBURN_GAUNTLET_AOE + frostburn_gauntlets:GetFinalGemPropertyValue("ruby", ITEM_RPC_FROSTBURN_GAUNTLETS_GEM_RUBY1)
            EmitSoundOnLocationWithCaster(icePoint, "hero_Crystal.freezingField.explosion", attacker)
            local particle = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
            local pfx = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, attacker)
            ParticleManager:SetParticleControl(pfx, 0, icePoint)
            ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 2, radius * 2))
            Timers:CreateTimer(2.5, function()
                ParticleManager:DestroyParticle(pfx, false)
            end)
            local additional_slow = frostburn_gauntlets:GetFinalGemPropertyValue("amethyst", ITEM_RPC_FROSTBURN_GAUNTLETS_GEM_AMETHYST2)
            local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), icePoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
            if #enemies > 0 then
                for _, enemy in pairs(enemies) do
                    frostburn_gauntlets:ApplyDataDrivenModifier(attacker, enemy, "modifier_frostburn_gauntlets_slow", {duration = ITEM_RPC_FROSTBURN_GAUNTLETS_MS_SLOW_DUR})
                    Filters:ApplyItemDamageBasedOnAbility(enemy, attacker, damage, DAMAGE_TYPE_MAGICAL, nil, RPC_ELEMENT_ICE, RPC_ELEMENT_NONE)
                    if additional_slow > 0 then
                        frostburn_gauntlets:ApplyDataDrivenModifier(attacker, enemy, "modifier_frostburn_additional_slow", {duration = ITEM_RPC_FROSTBURN_GAUNTLETS_MS_SLOW_DUR})
                        enemy:SetModifierStackCount("modifier_frostburn_additional_slow", attacker, additional_slow)
                    end
                end
            end
            return true
        end
    end)
end

function Filters:GetPrimaryAttributeMultiple(hero, multiple)
    local primeAttribute = hero:GetRoshpitPrimaryAttribute()
    local damage = 0
    if primeAttribute == ROSHPIT_ATTRIBUTE_STRENGTH then
        damage = hero:GetStrength() * multiple
    elseif primeAttribute == ROSHPIT_ATTRIBUTE_AGILITY then
        damage = hero:GetAgility() * multiple
    elseif primeAttribute == ROSHPIT_ATTRIBUTE_INTELLIGENCE then
        damage = hero:GetIntellect() * multiple
    elseif primeAttribute == ROSHPIT_ATTRIBUTE_SPIRIT then
        damage = hero:GetSpirit() * multiple
    end
    return math.ceil(damage)
end

function Filters:IsPrimaryAttribute(hero, attr)
    local primeAttribute = hero:GetRoshpitPrimaryAttribute()
    if primeAttribute == ROSHPIT_ATTRIBUTE_STRENGTH then
        if attr == "str" then
            return true
        end
    elseif primeAttribute == ROSHPIT_ATTRIBUTE_AGILITY then
        if attr == "agi" then
            return true
        end
    elseif primeAttribute == ROSHPIT_ATTRIBUTE_INTELLIGENCE then
        if attr == "int" then
            return true
        end
    elseif primeAttribute == ROSHPIT_ATTRIBUTE_SPIRIT then
        if attr == "spr" then
            return true
        end
    else
        return false
    end
end


function Filters:SonicBoot(caster)
    local inventoryUnit = caster.InventoryUnit
    local ability = caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]
    ability:ApplyDataDrivenModifier(inventoryUnit, caster, "modifier_sonic_boots_effect", {duration = ITEM_RPC_SONIC_BOOTS_DURATION})
    caster:AddNewModifier(caster, nil, "modifier_sonic_boot_base", {duration = ITEM_RPC_SONIC_BOOTS_DURATION})
    local as_stacks = ITEM_RPC_SONIC_BOOTS_ATTACK_SPEED + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_SONIC_BOOTS_GEM_RUBY)
    caster:ApplyModifierAndSetStacks(ability, caster.InventoryUnit, "modifier_sonic_boots_attack_speed", as_stacks, ITEM_RPC_SONIC_BOOTS_DURATION)
    if ability:GetGemValue("amethyst") > 0 then
        local atk_pct = ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_SONIC_BOOTS_GEM_AMETHYST)
        caster:ApplyModifierAndSetStacks(ability, caster.InventoryUnit, "modifier_property_sonic_boots_damage", atk_pct, ITEM_RPC_SONIC_BOOTS_DURATION)
    end
end

function Filters:EternalFrost(caster)
    local ability = caster.equipped_gear[RPC_GEAR_SLOT_TRINKET]

    local particle = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
    local pfx = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
    local position = caster:GetAbsOrigin()
    local radius = ITEM_RPC_GEM_OF_ETERNAL_FROST_ACTIVE_ROOT_AOE + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_GEM_OF_ETERNAL_FROST_GEM_EMERALD1)
    ParticleManager:SetParticleControl(pfx, 0, position)
    ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 2, radius * 2))
    Timers:CreateTimer(3, function()
        ParticleManager:DestroyParticle(pfx, false)
    end)
    
    EmitSoundOn("Ability.FrostNova", caster)

    local damage = caster:GetIntellect() * ITEM_RPC_GEM_OF_ETERNAL_FROST_ACTIVE_EXPLOSION_DMG_PER_INT + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_GEM_OF_ETERNAL_FROST_GEM_EMERALD2)
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    local freezeDuration = ITEM_RPC_GEM_OF_ETERNAL_FROST_ACTIVE_ROOT_DURATION
    if #enemies > 0 then
        for _, enemy in pairs(enemies) do
            Filters:ApplyItemDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, nil, RPC_ELEMENT_ICE, RPC_ELEMENT_NONE)
            ability:ApplyDataDrivenModifier(caster, enemy, "modifier_eternal_frost_nova", {duration = freezeDuration})
        end
    end
end

function Filters:AscensionTrigger(caster)
    local ability = caster.equipped_gear[RPC_GEAR_SLOT_HEAD]
    local min_cooldown = ability:GetFinalGemPropertyValue("amethyst", SUPER_ASCENDENCY_AMETHYST)
    local base_cooldown = caster:GetAbilityByIndex(DOTA_R_SLOT):GetCooldownTimeRemaining()*(SUPER_ASCENDENCY_DURATION_PCT_OF_R/100)
    local duration = math.max(base_cooldown, min_cooldown)
    ability:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_super_ascendency_trigger", {duration = duration})
    caster:AddNewModifier(caster, ability, "modifier_super_ascendency_lua", {duration = duration})

    if ability:GetGemValue("sapphire") > 0 then
        ability:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_ascendency_base_attack_damage", {duration = duration})
        caster:SetModifierStackCount("modifier_ascendency_base_attack_damage", caster, ability:GetFinalGemPropertyValue("sapphire", SUPER_ASCENDENCY_SAPPHIRE))
    end
end

function Filters:ScourgeKnight(caster)
    local scourge_helm = caster.equipped_gear[RPC_GEAR_SLOT_HEAD]
    if not scourge_helm.skeleton_table then
        scourge_helm.skeleton_table = {}
    end
    for i = 1, #scourge_helm.skeleton_table, 1 do
        if scourge_helm.skeleton_table[i] and IsValidEntity(scourge_helm.skeleton_table[i]) and scourge_helm.skeleton_table[i]:IsAlive() then
           scourge_helm.skeleton_table[i]:ForceKill(false)
        end
    end
    scourge_helm.skeleton_table = {}
    EmitSoundOn("RPCItems.ScourgeKnight.Start", caster)
    local fv = caster:GetForwardVector()
    local casterOrigin = caster:GetAbsOrigin()
    local perpFv = WallPhysics:rotateVector(fv, math.pi / 2)
    local spawnPosition = casterOrigin - fv * 180
    local distance_btwn_archers = 180
    local vectorTable = {spawnPosition - perpFv * distance_btwn_archers*2, spawnPosition - perpFv * distance_btwn_archers, spawnPosition, spawnPosition + perpFv * distance_btwn_archers, spawnPosition + perpFv * distance_btwn_archers*2}
    local elementsTable = {}
    if scourge_helm:GetGemValue("ruby") > 0 then
        table.insert(elementsTable, RPC_ELEMENT_FIRE)
    end
    if scourge_helm:GetGemValue("sapphire") > 0 then
        table.insert(elementsTable, RPC_ELEMENT_ICE)
    end
    if scourge_helm:GetGemValue("emerald") > 0 then
        table.insert(elementsTable, RPC_ELEMENT_POISON)
    end
    if scourge_helm:GetGemValue("amethyst") > 0 then
        table.insert(elementsTable, RPC_ELEMENT_ARCANE)
    end
    if #elementsTable < 2 then
        table.insert(elementsTable, RPC_ELEMENT_NONE)
    end
    for i = 1, #vectorTable, 1 do
        local archer = CreateUnitByName("scourge_knight_archer", vectorTable[i], true, nil, nil, DOTA_TEAM_GOODGUYS)
        scourge_helm:ApplyDataDrivenModifier(caster.InventoryUnit, archer, "modifier_shipyard_spawner_passive", {})
        archer.owner = caster:GetPlayerOwnerID()
        archer.summoner = caster
        archer.hero = caster
        archer:SetOwner(caster)
        archer:SetControllableByPlayer(caster:GetPlayerID(), true)
        archer.dieTime = SCOURGE_KNIGHT_ARCHER_DURATION
        archer:AddAbility("ability_die_after_time_generic"):SetLevel(1)
        archer:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
        archer:AdjustSummon(caster, true, 1, SCOURGE_KNIGHT_ATTACK_MULT, 1, 1, 1, 1)
        archer:SetMaxHPandHealToFull(SCOURGE_KNIGHT_HITS_TO_KILL)
        archer:SetModelScale(0.85)
        table.insert(scourge_helm.skeleton_table, archer)
        Timers:CreateTimer(1, function()
            EmitSoundOn("RPCItems.ScourgeKnight.Spawn", archer)
        end)
        archer.element = elementsTable[RandomInt(1, #elementsTable)]
        if archer.element == RPC_ELEMENT_FIRE then
            archer:SetRangedProjectileName("particles/roshpit/scourge_knight_fire_arrow.vpcf")
        elseif archer.element == RPC_ELEMENT_ICE then
            archer:SetRangedProjectileName("particles/units/heroes/hero_drow/drow_frost_arrow.vpcf")
        elseif archer.element == RPC_ELEMENT_POISON then
            archer:SetRangedProjectileName("particles/roshpit/scourge_knight_poison_arrow.vpcf")
        elseif archer.element == RPC_ELEMENT_ARCANE then
            archer:SetRangedProjectileName("particles/roshpit/scourge_knight_arcane_arrow.vpcf")
        end
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
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, ITEM_RPC_CYTOPIAN_LASER_GLOVE_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    local abilityLevel = caster:GetAbilityByIndex(DOTA_W_SLOT):GetLevel()
    local baseDamage = OverflowProtectedGetAverageTrueAttackDamage(caster) * (ITEM_RPC_CYTOPIAN_LASER_GLOVE_DMG_PER_ATT/100)
    if #enemies > 0 then
        local ability = caster.equipped_gear[RPC_GEAR_SLOT_GLOVES]
        EmitSoundOn("Hero_Tinker.Attack", enemies[1])
        for _, enemy in pairs(enemies) do
            local damage = baseDamage + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_CYTOPIAN_LASER_GLOVE_GEM_SAPPHIRE1)
            local currentStacks = enemy:GetModifierStackCount("modifier_cytopian_stacks", caster.InventoryUnit)
            local successive_damage = (ITEM_RPC_CYTOPIAN_LASER_GLOVE_STACK_INCREASE + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_CYTOPIAN_LASER_GLOVE_GEM_RUBY))/100
            damage = damage * (1 + successive_damage*currentStacks)

            Filters:ApplyItemDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, nil, RPC_ELEMENT_TIME, RPC_ELEMENT_LIGHTNING)
            local particleName = "particles/units/heroes/hero_tinker/tinker_laser.vpcf"
            local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, enemy)
            ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin() + Vector(0, 0, 100))
            ParticleManager:SetParticleControlEnt(pfx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin() + Vector(0, 0, 100), true)
            ParticleManager:SetParticleControlEnt(pfx, 3, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin() + Vector(0, 0, 100), true)
            ParticleManager:SetParticleControlEnt(pfx, 9, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin() + Vector(0, 0, 100), true)
            Timers:CreateTimer(0.8, function()
                ParticleManager:DestroyParticle(pfx, false)
            end)
            ability:ApplyDataDrivenModifier(caster.InventoryUnit, enemy, "modifier_cytopian_stacks", {duration = ITEM_RPC_CYTOPIAN_LASER_GLOVE_STACKING_DURATION})
            local max_stacks = ITEM_RPC_CYTOPIAN_LASER_GLOVE_MAX_STACKS + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_CYTOPIAN_LASER_GLOVE_GEM_EMERALD)
            local newStacks = math.min(currentStacks + 1, max_stacks)
            enemy:SetModifierStackCount("modifier_cytopian_stacks", caster.InventoryUnit, newStacks)
            enemy:CalculateAndSaveRoshpitAttributes()
        end
    end
end

function Filters:GetSpecialAttackRangeModifiers()
    return {"modifier_tomahawk_buffs", "modifier_chernobog_demonform_lua", "modifier_demon_flight_flying"}
end

function Filters:ReduceCDByPercentage(caster, ability, percentageReduction)
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
        local tome_of_chaos_cooldown = ITEM_RPC_TOME_OF_CHAOS_CD - caster.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_TOME_OF_CHAOS_GEM_SAPPHIRE)
        caster.equipped_gear[RPC_GEAR_SLOT_TRINKET]:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_tome_of_chaos_cooldown", {duration = tome_of_chaos_cooldown})
        local position = caster:GetAbsOrigin() + caster:GetForwardVector() * 580
        particleName = "particles/items_fx/infernal_summon_spawn_aegis_starfall.vpcf"


        EmitSoundOnLocationWithCaster(position, "Hero_Warlock.RainOfChaos_buildup", caster)
        CustomAbilities:QuickParticleAtPoint("particles/roshpit/items/tome_of_chaos_summon.vpcf", position, 3)
        Timers:CreateTimer(0.1, function()
            EmitSoundOnLocationWithCaster(position, "Hero_WarlockGolem.Attack", caster)
            local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
            ParticleManager:SetParticleControl(particle1, 0, position + Vector(0, 0, 50))
            Timers:CreateTimer(6, function()
                ParticleManager:DestroyParticle(particle1, false)
            end)
        end)

        Timers:CreateTimer(0.4, function()
            local infernal_summon_stun_radius = ITEM_RPC_TOME_OF_CHAOS_STUN_RADIUS
            local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, infernal_summon_stun_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
            if #enemies > 0 then
                for _, enemy in pairs(enemies) do
                    Filters:ApplyStun(caster, ITEM_RPC_TOME_OF_CHAOS_STUN, enemy)
                end
            end
            Timers:CreateTimer(0.2, function()
                EmitSoundOnLocationWithCaster(position, "Hero_Warlock.RainOfChaos", caster)
            end)
            local infernal = CreateUnitByName("tome_of_chaos_infernal", position, true, nil, nil, caster:GetTeamNumber())
            infernal.owner = caster:GetPlayerOwnerID()
            infernal.summoner = caster
            infernal.hero = caster
            infernal:SetOwner(caster)
            infernal:SetControllableByPlayer(caster:GetPlayerID(), true)
            infernal.dieTime = ITEM_RPC_TOME_OF_CHAOS_DURATION
            infernal:AddAbility("ability_die_after_time_generic"):SetLevel(1)
            StartAnimation(infernal, {duration = 0.8, activity = ACT_DOTA_ATTACK, rate = 1.0})
            -- infernal:SetModelScale(0.85)
            infernal:AdjustSummon(caster, true, ITEM_RPC_TOME_OF_CHAOS_HP_MULT, ITEM_RPC_TOME_OF_CHAOS_ATTACK_DAMAGE_MULT, 1, 1, 1, 1)
            Events:smoothSizeChange(infernal, 0.1, 0.85, 20)
            local reign_ability = infernal:AddAbility("infernal_reign_toggle_ai")
            reign_ability:SetLevel(1)
            reign_ability:ToggleAbility()
            if caster.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetGemValue("emerald") > 0 then
                caster.equipped_gear[RPC_GEAR_SLOT_TRINKET]:ApplyDataDrivenModifier(caster.InventoryUnit, infernal, "modifier_infernal_effect", {duration = ITEM_RPC_TOME_OF_CHAOS_DURATION})
            end
            if caster.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetGemValue("ruby") > 0 then
                local attack_power = caster.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("ruby", ITEM_RPC_TOME_OF_CHAOS_GEM_RUBY1)
                infernal:ApplyModifierAndSetStacks(caster.equipped_gear[RPC_GEAR_SLOT_TRINKET], caster, "modifier_tome_of_chaos_ruby_attack_power", attack_power, 0)    
            end
            if caster.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetGemValue("amethyst") > 0 then
                infernal:AddAbility("infernal_reign_amethyst_ability"):SetLevel(1)
            end
        end)
    end
end

function Filters:RedrockFootwear(caster)
    local ability = caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]
    local pulses = ITEM_RPC_REDROCK_FOOTWEAR_NUMBER_OF_PULSES + ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_REDROCK_FOOTWEAR_GEM_AMETHYST)
    -- "modifier_redrock_footwear_caster_visible"
    local delay_between_pulse = ITEM_RPC_REDROCK_FOOTWEAR_DURATION_OF_PULSES/ITEM_RPC_REDROCK_FOOTWEAR_NUMBER_OF_PULSES
    for i = 0, pulses-1, 1 do
        Timers:CreateTimer(0.2 + i * (delay_between_pulse), function()
            ability:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_redrock_footwear_caster_visible", {duration = ITEM_RPC_REDROCK_FOOTWEAR_TAUNT_DURATION})
            local new_stacks = math.min(caster:GetModifierStackCount("modifier_redrock_footwear_caster_visible", caster.InventoryUnit) + 1, pulses)
            caster:SetModifierStackCount("modifier_redrock_footwear_caster_visible", caster.InventoryUnit, new_stacks)
            EmitSoundOn("RPCItem.RedrockFootwear", caster)
            local position = caster:GetAbsOrigin()
            local particleName = "particles/units/heroes/hero_faceless_void/redrock_timedialate.vpcf"
            local particle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
            local radius = ITEM_RPC_REDROCK_FOOTWEAR_TAUNT_RADIUS
            ParticleManager:SetParticleControl(particle, 0, position)
            ParticleManager:SetParticleControl(particle, 1, Vector(radius, radius, radius))
            Timers:CreateTimer(2, function()
                ParticleManager:DestroyParticle(particle, false)
            end)
            local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
            if #enemies > 0 then
                for _, enemy in pairs(enemies) do
                    if enemy:GetAttackCapability() == DOTA_UNIT_CAP_NO_ATTACK then
                    elseif enemy.dummy then
                    else
                        ability:ApplyDataDrivenModifier(caster.InventoryUnit, enemy, "modifier_redrock_footwear_taunt_effect", {duration = ITEM_RPC_REDROCK_FOOTWEAR_TAUNT_DURATION})
                        enemy:MoveToTargetToAttack(caster)
                    end
                end
            end
        end)
    end
end

function Filters:ReanimateThorok(caster)
    local ability = caster.equipped_gear[RPC_GEAR_SLOT_HEAD]
    if ability.thorok and IsValidEntity(ability.thorok) and ability.thorok:IsAlive() then
        ability.thorok:ForceKill(false)
    end
    local thorok = CreateUnitByName("thorok_reborn", caster:GetAbsOrigin(), true, nil, nil, caster:GetTeamNumber())
    thorok.owner = caster:GetPlayerOwnerID()
    thorok.hero = caster
    thorok.summoner = caster
    thorok:SetOwner(caster)
    thorok:SetControllableByPlayer(caster:GetPlayerID(), true)
    thorok.dieTime = DESERT_NECROMANCER_LIFE_DURATION + ability:GetFinalGemPropertyValue("ruby", DESERT_NECROMANCER_RUBY2)
    thorok:AddAbility("ability_die_after_time_generic"):SetLevel(1)
    ability.thorok = thorok
    StartAnimation(thorok, {duration = 0.8, activity = ACT_DOTA_ATTACK, rate = 1.0})
    local target_scale = 0.9
    EmitSoundOn("RPCItems.Thorok.Spawn", thorok)
    CustomAbilities:QuickAttachParticle("particles/econ/items/lifestealer/lifestealer_immortal_backbone_gold/lifestealer_immortal_backbone_gold_rage.vpcf", thorok, 0.5)
    if caster:GetHealth() < caster:GetMaxHealth() * (THOROK_RAGE_CASTER_HP_THRESHOLD/100) then
        EmitSoundOn("RPCItems.Thorok.Rage", thorok)
        caster.equipped_gear[RPC_GEAR_SLOT_HEAD]:ApplyDataDrivenModifier(caster.InventoryUnit, thorok, "modifier_thorok_enraged", {})
        target_scale = 1
    end
    Events:smoothSizeChange(thorok, 0.1, target_scale, 40)
    thorok:AddAbility("thorok_toggle_ai"):SetLevel(1)
    thorok:FindAbilityByName("thorok_toggle_ai"):ToggleAbility()

    local health_mult = THOROK_CASTER_HP + ability:GetFinalGemPropertyValue("ruby", DESERT_NECROMANCER_RUBY1)
    thorok:AdjustSummon(caster, true, health_mult, THOROK_CASTER_ATTACK_DMG, THOROK_CASTER_ARMORS_AND_PIERCES, THOROK_CASTER_ARMORS_AND_PIERCES, THOROK_CASTER_ARMORS_AND_PIERCES, THOROK_CASTER_ARMORS_AND_PIERCES)

    if ability:GetGemValue("sapphire") > 0 then
        ability:ApplyDataDrivenModifier(caster.InventoryUnit, thorok, "modifier_thorok_sapphire", {})
        thorok:SetModifierStackCount("modifier_thorok_sapphire", caster.InventoryUnit, ability:GetFinalGemPropertyValue("sapphire", DESERT_NECROMANCER_SAPPHIRE))
    end
    if ability:GetGemValue("amethyst") > 0 then
        ability:ApplyDataDrivenModifier(caster.InventoryUnit, thorok, "modifier_thorok_amethyst", {})
        thorok:SetModifierStackCount("modifier_thorok_amethyst", caster.InventoryUnit, ability:GetFinalGemPropertyValue("amethyst", DESERT_NECROMANCER_AMETHYST))
    end
end

function Filters:DemonMask(caster, target, damage)
    local chance = DEMON_MASK_CHANCE + caster.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("sapphire", DEMON_MASK_SAPPHIRE)
    local proc = Filters:GetProc(caster, chance)
    if proc then
        local demon_mask_amp = DEMON_MASK_AMP + caster.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("ruby", DEMON_MASK_RUBY)
        damage = damage * (demon_mask_amp/100)
        local limitKey = caster:GetPlayerOwnerID() .. '_demon_mask'
        Util.Common:LimitPerTime(DEMON_MASK_MAX_PROCS_PER_SEC, 1, limitKey, function()
            EmitSoundOn("RPCItem.DemonMask", target)
            local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/demon_mask_3.vpcf", PATTACH_CUSTOMORIGIN, caster)
            ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin() + Vector(0, 0, 115))
            ParticleManager:SetParticleControl(pfx, 3, Vector(2,3,4))
            Timers:CreateTimer(1.2, function()
                ParticleManager:DestroyParticle(pfx, false)
            end)
            local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, DEMON_MASK_AOE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
            Timers:CreateTimer(0.1, function()
                if #enemies > 0 then
                    for _, enemy in pairs(enemies) do
                        Filters:ApplyItemDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, nil, RPC_ELEMENT_DEMON, RPC_ELEMENT_NONE)
                    end
                end
            end)
        end)
        return true
    else
        return false
    end
end

function Filters:UmbralSentinel(attacker, victim)
    local ability = attacker.equipped_gear[RPC_GEAR_SLOT_HEAD]
    local wLevel = attacker:GetAbilityByIndex(DOTA_W_SLOT):GetLevel()
    local origStacks = victim:GetModifierStackCount("modifier_crest_of_the_umbral_sentinel_effect_visible", ability)
    local newStacks = math.min(origStacks + 1, CREST_OF_UMBRAL_SENTINEL_MAX_STACKS)
    ability:ApplyDataDrivenModifier(attacker.InventoryUnit, victim, "modifier_crest_of_the_umbral_sentinel_effect_visible", {duration = CREST_OF_UMBRAL_SENTINEL_DURATION})
    victim:SetModifierStackCount("modifier_crest_of_the_umbral_sentinel_effect_visible", ability, newStacks)

    if ability:GetGemValue("sapphire") > 0 then
        ability:ApplyDataDrivenModifier(attacker.InventoryUnit, victim, "modifier_umbral_sentinel_sapphire", {duration = CREST_OF_UMBRAL_SENTINEL_DURATION})
        victim:SetModifierStackCount("modifier_umbral_sentinel_sapphire", ability, ability:GetFinalGemPropertyValue("sapphire", UMBRAL_SENTINEL_SAPPHIRE1)*newStacks)

        ability:ApplyDataDrivenModifier(attacker.InventoryUnit, victim, "modifier_umbral_sentinel_sapphire2", {duration = CREST_OF_UMBRAL_SENTINEL_DURATION})
        victim:SetModifierStackCount("modifier_umbral_sentinel_sapphire2", ability, ability:GetFinalGemPropertyValue("sapphire", UMBRAL_SENTINEL_SAPPHIRE2)*newStacks)
    end
end

function Filters:DefilerHit(attacker, victim)
    local ability = attacker.equipped_gear[RPC_GEAR_SLOT_HEAD]

    local origStacks = victim:GetModifierStackCount("modifier_hood_of_defiler_effect_visible", ability)
    local newStacks = math.min(origStacks + 1, HOOD_OF_DEFILER_ARMOR_REDUCE_MAX_STACKS)
    ability:ApplyDataDrivenModifier(attacker.InventoryUnit, victim, "modifier_hood_of_defiler_effect_visible", {duration = HOOD_OF_DEFILER_DURATION})
    victim:SetModifierStackCount("modifier_hood_of_defiler_effect_visible", ability, newStacks)
    victim:CalculateAndSaveRoshpitAttributes()

    if ability:GetGemValue("ruby") > 0 or ability:GetGemValue("emerald") > 0 or ability:GetGemValue("amethyst") > 0 or ability:GetGemValue("sapphire") > 0 then
        local casterStacks = attacker:GetModifierStackCount("modifier_hood_of_defiler_buff", attacker.InventoryUnit)
        local newCasterStacks = math.min(casterStacks + 1, HOOD_OF_DEFILER_GEMS_MAX_STACKS)
        ability:ApplyDataDrivenModifier(attacker.InventoryUnit, attacker, "modifier_hood_of_defiler_buff", {duration = HOOD_OF_DEFILER_DURATION})
        attacker:SetModifierStackCount("modifier_hood_of_defiler_buff", attacker.InventoryUnit, newCasterStacks)

        if ability:GetGemValue("ruby") > 0 then
            ability:ApplyDataDrivenModifier(attacker.InventoryUnit, attacker, "modifier_hood_of_defiler_buff_ruby", {duration = HOOD_OF_DEFILER_DURATION})
            attacker:SetModifierStackCount("modifier_hood_of_defiler_buff_ruby", attacker.InventoryUnit, newCasterStacks*ability:GetFinalGemPropertyValue("ruby", HOOD_OF_DEFILER_RUBY))
        end
        if ability:GetGemValue("emerald") > 0 then
            ability:ApplyDataDrivenModifier(attacker.InventoryUnit, attacker, "modifier_hood_of_defiler_buff_emerald", {duration = HOOD_OF_DEFILER_DURATION})
            attacker:SetModifierStackCount("modifier_hood_of_defiler_buff_emerald", attacker.InventoryUnit, newCasterStacks*ability:GetFinalGemPropertyValue("emerald", HOOD_OF_DEFILER_EMERALD))
        end
        if ability:GetGemValue("sapphire") > 0 then
            ability:ApplyDataDrivenModifier(attacker.InventoryUnit, attacker, "modifier_hood_of_defiler_buff_sapphire", {duration = HOOD_OF_DEFILER_DURATION})
            attacker:SetModifierStackCount("modifier_hood_of_defiler_buff_sapphire", attacker.InventoryUnit, newCasterStacks*ability:GetFinalGemPropertyValue("sapphire", HOOD_OF_DEFILER_SAPPHIRE))
        end
        if ability:GetGemValue("amethyst") > 0 then
            ability:ApplyDataDrivenModifier(attacker.InventoryUnit, attacker, "modifier_hood_of_defiler_buff_amethyst", {duration = HOOD_OF_DEFILER_DURATION})
            attacker:SetModifierStackCount("modifier_hood_of_defiler_buff_amethyst", attacker.InventoryUnit, newCasterStacks*ability:GetFinalGemPropertyValue("amethyst", HOOD_OF_DEFILER_AMETHYST))
        end
    end
end

function Filters:FarSeerGloves(attacker, damage, inflictor)
    local ability = attacker.equipped_gear[RPC_GEAR_SLOT_GLOVES]
    if not ability.last_damage then
        ability.last_damage = 0
    end
    if damage > ability.last_damage then
        ability.last_damage = damage
        local duration = ITEM_RPC_FAR_SEERS_ENCHANTED_GLOVES_DURATION + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_FAR_SEERS_ENCHANTED_GLOVES_GEM_RUBY1)
        attacker.equipped_gear[RPC_GEAR_SLOT_GLOVES]:ApplyDataDrivenModifier(attacker.InventoryUnit, attacker, "modifier_far_seer_effect_visible", {duration = duration})
        attacker.equipped_gear[RPC_GEAR_SLOT_GLOVES]:ApplyDataDrivenModifier(attacker.InventoryUnit, attacker, "modifier_far_seer_attack_damage", {duration = duration})
        
        local maximum = attacker:GetIntellect()*(ITEM_RPC_FAR_SEERS_ENCHANTED_GLOVES_INT_CAP + ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_FAR_SEERS_ENCHANTED_GLOVES_GEM_AMETHYST)) + attacker:GetAgility()*ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_FAR_SEERS_ENCHANTED_GLOVES_GEM_EMERALD)
        local attack_power_bonus = math.min(math.floor(damage * ITEM_RPC_FAR_SEERS_ENCHANTED_GLOVES_MAGIC_DMG_TO_ATK_PCT/100), maximum)
        attacker:SetModifierStackCount("modifier_far_seer_attack_damage", attacker.InventoryUnit, attack_power_bonus)
    end
end

function Filters:EmeraldDouliHit(victim, damage)
    if damage > 0 then
        local dmg_absorb_per_mana = EMERALD_DOULI_DMG_ABSORB_PER_MANA + victim.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("emerald", EMERALD_DOULI_EMERALD)
        local douli_damage_absorb_pct = EMERALD_DOULI_ABSORBED_DMG_PCT + victim.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("ruby", EMERALD_DOULI_RUBY)

        local manaDamage = damage * (douli_damage_absorb_pct / 100) / dmg_absorb_per_mana
        local normalDamage = damage * (1 - douli_damage_absorb_pct / 100)
        local availableMana = victim:GetMana()
        if availableMana > manaDamage then
            victim:ReduceMana(manaDamage)
            return normalDamage
        else
            victim:ReduceMana(availableMana)
            return (manaDamage - availableMana) * dmg_absorb_per_mana + normalDamage
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
    if victim:HasModifier("modifier_secret_temple_refraction") or victim:HasModifier("modifier_windsteel_effect") or victim:HasModifier("modifier_heavens_shield") or victim:HasModifier("modifier_shipyard_veil_shield") or victim:HasModifier("modifier_arcane_shell") or victim:HasModifier("modifier_duskbringer_rune_e_2_effect") or victim:HasModifier("modifier_paladin_q3_shield") or victim:HasModifier("modifier_voltex_rune_w_3_shield") or victim:HasModifier("modifier_light_seer_shield") or victim:HasModifier("modifier_black_dominion_shield") or victim:HasModifier("modifier_grithault_shield") then
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
    local proc = false
    if target.equipped_gear then
        proc = Filters:GetProc(target, target.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue("ruby", ITEM_RPC_ARMOR_OF_SECRET_TEMPLE_GEM_RUBY))
    end
    if not proc then
        if stackCount > 1 then
            target:SetModifierStackCount("modifier_secret_temple_refraction", target.refractionItem, stackCount - 1)
        else
            target:RemoveModifierByName("modifier_secret_temple_refraction")
        end
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

function Filters:ModifyBladestormVestSwordCount(attacker, numSwords, ability, caster, iReduce)
    local blade_vest = attacker.equipped_gear[RPC_GEAR_SLOT_BODY]
    for j = 1, #blade_vest.bladeTable, 1 do
        UTIL_Remove(blade_vest.bladeTable[j])
    end
    blade_vest.bladeTable = {}
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
            sword:SetModelScale(1.6)
            table.insert(blade_vest.bladeTable, sword)
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
    if victim.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetGemValue("ruby") > 0 then
        local distance = CalcDistanceBetweenEntityOBB(attacker, victim)
        if distance <= ITEM_RPC_AERITHS_TEAR_DISTANCE then
            return true
        else
            return false
        end
    else
        return false
    end
end

function Filters:GrithaultDamage(victim, damage)
    local grithault_helm = victim.equipped_gear[RPC_GEAR_SLOT_HEAD]
    local pain_reversal_proc_chance = GRITHAULT_CHANCE + victim.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("emerald", GRITHAULT_EMERALD)
    local proc = Filters:GetProc(victim, pain_reversal_proc_chance)

    if damage > 0 then
        if victim:HasModifier("modifier_grithault_shield") then
            damage = 0
            if not proc then
                local new_stacks = victim:GetModifierStackCount("modifier_grithault_shield", victim.InventoryUnit) - 1
                if new_stacks > 0 then
                    victim:SetModifierStackCount("modifier_grithault_shield", victim.InventoryUnit, new_stacks)
                else
                    victim:RemoveModifierByName("modifier_grithault_shield")
                end
            end
        elseif grithault_helm:GetGemValue("ruby") > 0 then
            local chance = grithault_helm:GetFinalGemPropertyValue("ruby", GRITHAULT_RUBY)
            local proc2 = Filters:GetProc(victim, chance)
            if proc2 then
                grithault_helm:ApplyDataDrivenModifier(victim.InventoryUnit, victim, "modifier_grithault_shield", {})
                victim:SetModifierStackCount("modifier_grithault_shield", victim.InventoryUnit, GRITHAULT_RUBY_INSTANCE_BLOCK)
            end
        end
    end

    if proc and damage > 0 then
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
    local threshold = victim:GetMaxHealth()* (ITEM_RPC_FRACTIONAL_ENHANCEMENT_GEODE_INSTANCE_THRESHOLD + attacker.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("ruby", ITEM_RPC_FRACTIONAL_ENHANCEMENT_GEODE_GEM_RUBY))/100
    if damage < threshold then
        local limitKey = attacker:GetPlayerOwnerID() .. '_geode'
        Util.Common:LimitPerTime(6, 1, limitKey, function()
            CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_oracle/fractional_geode_effect.vpcf", victim, 0.8)
            EmitSoundOn("Items.Geode", victim)
        end)
        local damage_mult = ITEM_RPC_FRACTIONAL_ENHANCEMENT_GEODE_DAMAGE_MULT + attacker.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("emerald", ITEM_RPC_FRACTIONAL_ENHANCEMENT_GEODE_GEM_EMERALD)
        return damage * damage_mult
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

function Filters:PureWaters(caster, event_type)
    local ability = caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]
    local allow = false
    local wave_count = 1
    if event_type == "attack" then
        allow = true
    elseif event_type == "q" then
        if not caster:HasModifier("modifier_boots_of_pure_waters_cooldown") then
            allow = true
        end
        wave_count = ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_BOOTS_OF_PURE_WATERS_GEM_AMETHYST)
    elseif event_type == "e" then
        if not caster:HasModifier("modifier_boots_of_pure_waters_cooldown") then
            allow = true
        end
    end
    if allow then
        local rotation_magnitude = 0
        for i = 1, wave_count, 1 do
            if wave_count == 2 then
                if i == 1 then
                    rotation_magnitude = 2
                elseif i == 2 then
                    rotation_magnitude = -2
                end
            elseif wave_count == 3 then
                if i == 1 then
                    rotation_magnitude = 2
                elseif i == 2 then
                    rotation_magnitude = 0
                elseif i == 3 then
                    rotation_magnitude = -2
                end
            elseif wave_count == 4 then
                if i == 1 then
                    rotation_magnitude = 1
                elseif i == 2 then
                    rotation_magnitude = 3
                elseif i == 3 then
                    rotation_magnitude = -1
                elseif i == 4 then
                    rotation_magnitude = -3
                end
            elseif wave_count > 4 then
                if i == 1 then
                    rotation_magnitude = 1
                elseif i == 2 then
                    rotation_magnitude = 3
                elseif i == 3 then
                    rotation_magnitude = 0
                elseif i == 4 then
                    rotation_magnitude = 3
                elseif i == 5 then
                    rotation_magnitude = -1
                end
            end
            local fv = WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi*rotation_magnitude/24)
            if ability:GetGemValue("sapphire") > 0 then
                CustomAbilities:QuickAttachParticle("particles/items3_fx/mango_active.vpcf", caster, 3)
                caster:GiveMana(caster:GetMaxMana() * ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_BOOTS_OF_PURE_WATERS_GEM_SAPPHIRE1)/100)
            end
            if event_type == "attack" then
            else
                ability:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_boots_of_pure_waters_cooldown", {duration = ITEM_RPC_BOOTS_OF_PURE_WATERS_INTERVAL_RESTRICTION})
            end
            ability.caster = caster
            local projectileParticle = "particles/units/heroes/hero_morphling/morphling_waveform.vpcf"
            local start_radius = 190
            local end_radius = 190
            local range = 900 + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_BOOTS_OF_PURE_WATERS_GEM_SAPPHIRE2)
            local speed = 650 + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_BOOTS_OF_PURE_WATERS_GEM_EMERALD1)
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
                iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
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

function Filters:IceShellTakeDamage(unit)
    local newStacks = unit:GetModifierStackCount("modifier_warlord_ice_shell", unit) - 1
    unit:SetModifierStackCount("modifier_warlord_ice_shell", unit, newStacks)
    if newStacks <= 0 then
        unit:RemoveModifierByName("modifier_warlord_ice_shell")
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
    local shadowRadius = ITEM_RPC_NIGHTMARE_RIDER_MANTLE_RADIUS + shadowCharges * ITEM_RPC_NIGHTMARE_RIDER_MANTLE_RADIUS_INCREASE
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
    local ability = caster.equipped_gear[RPC_GEAR_SLOT_BODY]
    local damage = ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_NIGHTMARE_RIDER_MANTLE_GEM_RUBY2)
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), origin, nil, shadowRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    if #enemies > 0 then
        for _, enemy in pairs(enemies) do
            ability:ApplyDataDrivenModifier(caster.InventoryUnit, enemy, "modifier_nightmare_rider_effect_visible", {duration = ITEM_RPC_NIGHTMARE_RIDER_MANTLE_DEBUFF_DURATION})
            enemy:CalculateAndSaveRoshpitAttributes()
            if damage > 0 then
                Filters:ApplyItemDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_SHADOW, RPC_ELEMENT_NONE)
            end
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

function Filters:NightmareRiderStacksGain(hero, stacks)
    if stacks < 1 then
        return false
    end
    local ability = hero.equipped_gear[RPC_GEAR_SLOT_BODY]
    local caster = hero.InventoryUnit
    ability:ApplyDataDrivenModifier(caster, hero, "modifier_nightmare_rider_stacks", {})
    local max_stacks = ITEM_RPC_NIGHTMARE_RIDER_MANTLE_MAX_STACKS + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_NIGHTMARE_RIDER_MANTLE_GEM_EMERALD2)
    local newStacks = math.min(hero:GetModifierStackCount("modifier_nightmare_rider_stacks", caster) + stacks, max_stacks)
    hero:SetModifierStackCount("modifier_nightmare_rider_stacks", caster, newStacks)
end

function Filters:AuriunImmortalWeapon1(damage, victim)
    if not victim:HasModifier("modifier_auriun_immortal_weapon_1_cooldown") then
        damage = 0
        victim.equipped_gear[RPC_GEAR_SLOT_WEAPON]:ApplyDataDrivenModifier(victim.InventoryUnit, victim, "modifier_auriun_immortal_weapon_1_cooldown", {duration = AURIUN_IMMO_WEAPON_1_CD})
        victim.equipped_gear[RPC_GEAR_SLOT_WEAPON]:ApplyDataDrivenModifier(victim.InventoryUnit, victim, "modifier_auriun_immortal_phased", {duration = AURIUN_IMMO_WEAPON_1_DURATION})
    end
    return damage
end

function Filters:AutumnSleeperMask(caster)
    local ability = caster.equipped_gear[RPC_GEAR_SLOT_HEAD]
    if ability:GetGemValue("ruby") > 0 then
        local rootDuration = ability:GetFinalGemPropertyValue("ruby", AUTUMN_SLEEPER_RUBY)
        local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, AUTUMN_SLEEPER_RUBY_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
        if #enemies > 0 then
            for _, enemy in pairs(enemies) do
                ability:ApplyDataDrivenModifier(caster.InventoryUnit, enemy, "modifier_autumn_sleeper_root", {duration = rootDuration})
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
end

function Filters:ManawallDamageTaken(victim, damage)
    local mana_wall = victim.equipped_gear[RPC_GEAR_SLOT_BODY]
    local damage_reduction = (1 - (ITEM_RPC_MYSTIC_MANA_WALL_MAGIC_PURE_REDUCTION + mana_wall:GetFinalGemPropertyValue("sapphire", ITEM_RPC_MYSTIC_MANA_WALL_GEM_SAPPHIRE))/100)
    local reducedDamage = damage * damage_reduction
    local currentMana = victim:GetMana()
    if currentMana >= reducedDamage then
        victim:ReduceMana(reducedDamage)
        return 0
    else
        local newDamage = reducedDamage - currentMana
        victim:ReduceMana(currentMana)
        return math.floor(newDamage/damage_reduction)
    end
end

function Filters:FireDeity(attacker, victim, damage)
    local fire_crown = attacker.equipped_gear[RPC_GEAR_SLOT_HEAD]
    local chance = FIRE_DEITY_CROWN_CHANCE + fire_crown:GetFinalGemPropertyValue("ruby", FIRE_DEITY_RUBY)
    local proc = Filters:GetProc(attacker, chance)
    if proc then
        damage = damage * FIRE_DEITY_CROWN_AMP/100 + fire_crown:GetFinalGemPropertyValue("emerald", FIRE_DEITY_EMERALD)*attacker:GetAgility()
        local target = victim
        local radius = FIRE_DEITY_CROWN_AOE
        local procs_per_second = FIRE_DEITY_MAX_PROCS_PER_SECOND + fire_crown:GetFinalGemPropertyValue("amethyst", FIRE_DEITY_AMETHYST)
        local limitKey = attacker:GetPlayerOwnerID() .. '_fire_deity'
        Util.Common:LimitPerTime(procs_per_second, 1, limitKey, function()
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
            local stun_duration = FIRE_DEITY_CROWN_STUN_DURATION + fire_crown:GetFinalGemPropertyValue("sapphire", FIRE_DEITY_SAPPHIRE)
            local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
            if #enemies > 0 then
                for _, enemy in pairs(enemies) do
                    Filters:ApplyStun(attacker, stun_duration, enemy)
                    Filters:ApplyItemDamage(enemy, attacker, damage, DAMAGE_TYPE_MAGICAL, nil, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
                end
            end
        end)
        return true
    end
end

function Filters:WaterDeity(attacker, victim, damage)
    local procs_per_second = WATER_DEITY_CROWN_MAX_PROCS_PER_SECOND + attacker.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("amethyst", WATER_DEITY_AMETHYST)
    local limitKey = attacker:GetPlayerOwnerID() .. '_water_deity'
    Util.Common:LimitPerTime(procs_per_second, 1, limitKey, function()
        CustomAbilities:QuickAttachParticle("particles/roshpit/water_deity.vpcf", victim, 3)
        local water_deity_damage = damage*WATER_DEITY_CROWN_DAMAGE_AMP/100 + (attacker.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("sapphire", WATER_DEITY_SAPPHIRE)/100)*OverflowProtectedGetAverageTrueAttackDamage(attacker)
        Filters:ApplyItemDamage(victim, attacker, water_deity_damage, DAMAGE_TYPE_PURE, nil, RPC_ELEMENT_WATER, RPC_ELEMENT_NONE)
        attacker.equipped_gear[RPC_GEAR_SLOT_HEAD]:ApplyDataDrivenModifier(attacker.InventoryUnit, victim, "modifier_water_deity_crown_slow", {duration = WATER_DEITY_CROWN_MOVESPEED_SLOW_DURATION})  
        if attacker.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetGemValue("emerald") > 0 then
            attacker.equipped_gear[RPC_GEAR_SLOT_HEAD]:ApplyDataDrivenModifier(attacker.InventoryUnit, victim, "modifier_water_deity_as_loss", {duration = WATER_DEITY_CROWN_MOVESPEED_SLOW_DURATION})
            victim:SetModifierStackCount("modifier_water_deity_as_loss", attacker.InventoryUnit, attacker.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("emerald", WATER_DEITY_EMERALD))
        end
    end) 
end

function Filters:ShipyardVeilQHit(attacker, victim)
    local ability = attacker.equipped_gear[RPC_GEAR_SLOT_HEAD]
    if not ability.lock then
        ability.lock = true
        local maxStacks = SHIPYARD_VEIL_MAX_STACKS
        ability:ApplyDataDrivenModifier(attacker.InventoryUnit, attacker, "modifier_shipyard_veil_shield", {})
        local newStacks = math.min(maxStacks, attacker:GetModifierStackCount("modifier_shipyard_veil_shield", attacker.InventoryUnit) + 1)
        attacker:SetModifierStackCount("modifier_shipyard_veil_shield", attacker.InventoryUnit, newStacks)
        local cooldown = math.max(SHIPYARD_SHIELD_COOLDOWN - ability:GetFinalGemPropertyValue("sapphire", SHIPYARD_VEIL_SAPPHIRE), 0.1)
        Timers:CreateTimer(cooldown, function()
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
    local ability = caster.equipped_gear[RPC_GEAR_SLOT_HEAD]
    ability.hero = caster
    local pfx = ParticleManager:CreateParticle("particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_echoslam_start_fallback_mid_egset.vpcf", PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
    Timers:CreateTimer(2, function()
        ParticleManager:DestroyParticle(pfx, false)
    end)
    local wAbilityLevel = caster:GetAbilityByIndex(DOTA_W_SLOT):GetLevel()
    local stunDuration = IGNEOUS_CANINE_STUN_DURATION + ability:GetFinalGemPropertyValue("sapphire", IGNEOUS_CANINE_SAPPHIRE)
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
    if ability.firePools < (IGNEOUS_CANINE_MAX_LAVA_POOLS + ability:GetFinalGemPropertyValue("emerald", IGNEOUS_CANINE_EMERALD)) then
        ability.firePools = ability.firePools + 1
        --ability:ApplyDataDrivenThinker(caster, caster:GetAbsOrigin(), "modifier_igneous_canine_thinker", {})
        CustomAbilities:QuickAttachThinker(ability, caster, caster:GetAbsOrigin(), "modifier_igneous_canine_thinker", {})
        Timers:CreateTimer(IGNEOUS_CANINE_LAVA_POOL_DURATION, function()
            ability.firePools = ability.firePools - 1
        end)
    end
end

function Filters:AzureEmpire(victim, attacker)
    local birdTable = victim.birdTable
    if victim.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetGemValue("amethyst") > 0 then
        local proc = Filters:GetProc(victim, victim.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_AZURE_EMPIRE_GEM_AMETHYST))
        if proc then
            for i = 1, ITEM_RPC_AZURE_EMPIRE_NUMBER_OF_HAWKS, 1 do
                if not birdTable[i]:HasModifier("modifier_azure_hawk_dead") then
                    CustomAbilities:QuickAttachParticle("particles/roshpit/items/azure_hawk_impact.vpcf", birdTable[i], 1.5)
                    break
                end
            end        
            return 0
        end
    end
    local currentStacks = victim:GetModifierStackCount("modifier_azure_empire_visible", victim.InventoryUnit)
    if currentStacks > 1 then
        victim:SetModifierStackCount("modifier_azure_empire_visible", victim.InventoryUnit, currentStacks - 1)
    else
        victim:RemoveModifierByName("modifier_azure_empire_visible")
    end
    if birdTable then
        for i = 1, ITEM_RPC_AZURE_EMPIRE_NUMBER_OF_HAWKS, 1 do
            if not birdTable[i]:HasModifier("modifier_azure_hawk_dead") then
                CustomAbilities:QuickAttachParticle("particles/roshpit/items/azure_hawk_impact.vpcf", birdTable[i], 1.5)
                EmitSoundOn("RPCItem.AzureEmpireHit", birdTable[i])
                local respawn_time = ITEM_RPC_AZURE_EMPIRE_HAWK_CD - victim.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("ruby", ITEM_RPC_AZURE_EMPIRE_GEM_RUBY)
                victim.equipped_gear[RPC_GEAR_SLOT_TRINKET]:ApplyDataDrivenModifier(victim.InventoryUnit, birdTable[i], "modifier_azure_hawk_dead", {duration = respawn_time})
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
                    birdTable[i]:RemoveModifierByName("modifier_azure_hawk_purple")
                    birdTable[i]:AddNoDraw()
                end)
                break
            end
        end
    end
end

function Filters:PhoenixEmblem(victim)
    local caster = victim
    local ability = victim.equipped_gear[RPC_GEAR_SLOT_TRINKET]
    local inventoryUnit = victim.InventoryUnit
    if not caster:HasModifier("modifier_phoenix_emblem_cooldown") then
        local rezPosition = caster:GetAbsOrigin()
        ability.rezPosition = rezPosition
        caster:SetAbsOrigin(rezPosition)
        caster:SetHealth(1)
        caster:SetMana(0)
        caster:AddNoDraw()
        caster:SetAbsOrigin(caster:GetAbsOrigin() - Vector(0, 0, 1600))
        local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
        local cooldown = ITEM_RPC_PHOENIX_EMBLEM_COOLDOWN - ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_PHOENIX_EMBLEM_GEM_SAPPHIRE)
        Timers:CreateTimer(5.01, function()
            ability:ApplyDataDrivenModifier(inventoryUnit, caster, "modifier_phoenix_emblem_cooldown", {duration = cooldown})
        end)
        ability:ApplyDataDrivenModifier(inventoryUnit, caster, "modifier_phoenix_rebirthing", {duration = ITEM_RPC_PHOENIX_EMBLEM_RESURRECTION_DELAY})
        gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, caster, "modifier_disable_player", {duration = ITEM_RPC_PHOENIX_EMBLEM_RESURRECTION_DELAY})
        caster:SetAbsOrigin(rezPosition)
        -- local playerID = caster:GetPlayerID()
        -- if playerID then
        --     PlayerResource:SetCameraTarget(playerID, caster)
        -- end
        -- Timers:CreateTimer(2, function()
        --     caster:SetAbsOrigin(rezPosition)
        --     if playerID then
        --         PlayerResource:SetCameraTarget(playerID, nil)
        --     end
        -- end)
    
        local egg = CreateUnitByName("npc_dummy_unit", rezPosition, true, caster, caster, caster:GetTeamNumber())
        egg:FindAbilityByName("dummy_unit"):SetLevel(1)
        egg:SetModelScale(1.4)
        egg:SetOriginalModel("models/phoenix_egg_hitbox.vmdl")
        egg:SetModel("models/phoenix_egg_hitbox.vmdl")
        egg:SetAbsOrigin(egg:GetAbsOrigin()+Vector(0,0,90))
        egg.hero = caster
        CustomAbilities:QuickAttachParticle("particles/roshpit/flamewaker/flamewaker_q_arcana1.vpcf", egg, 2)
        ability:ApplyDataDrivenModifier(inventoryUnit, egg, "modifier_egg_reviving", {duration = ITEM_RPC_PHOENIX_EMBLEM_RESURRECTION_DELAY})
        AddFOWViewer(caster:GetTeamNumber(), rezPosition, 800, 8, false)
        local pfx = CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_egg.vpcf", egg, ITEM_RPC_PHOENIX_EMBLEM_RESURRECTION_DELAY)
        ParticleManager:SetParticleControlEnt(pfx, 3, egg, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", egg:GetAbsOrigin(), true)
        Events:smoothSizeChange(egg, 0.3, 1.4, 20)
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
    local radius = ITEM_RPC_ALARANAS_ICE_BOOT_EXPLOSION_RADIUS
    ParticleManager:SetParticleControl(pfx, 0, position)
    ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 2, radius * 2))
    Timers:CreateTimer(3, function()
        ParticleManager:DestroyParticle(pfx, false)
    end)

    EmitSoundOn("Ability.FrostNova", caster)
    local damage = caster:GetMaxHealth() * ITEM_RPC_ALARANAS_ICE_BOOT_EXPLOSION_DAMAGE_OF_MAX_HP
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    local freezeDuration = ITEM_RPC_ALARANAS_ICE_BOOT_ENEMY_FREEZE_DURATION
    if #enemies > 0 then
        for _, enemy in pairs(enemies) do
            Filters:ApplyItemDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, caster.foot, RPC_ELEMENT_ICE, RPC_ELEMENT_NONE)
            caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]:ApplyDataDrivenModifier(caster.InventoryUnit, enemy, "modifier_alarana_frost_nova", {duration = freezeDuration})
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
            target:HasModifier("modifier_fire_walkers_sapphire") or
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
    local emissary_glove = caster.equipped_gear[RPC_GEAR_SLOT_GLOVES]
    -- CustomAbilities:QuickAttachParticle("particles/act_2/blob_launch_impact.vpcf", caster, 4)
    local pfx2 = ParticleManager:CreateParticle("particles/roshpit/items/dark_emissary_activate_magical.vpcf", PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(pfx2, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(pfx2, 2, Vector(20, 140, 120))
    Timers:CreateTimer(3.5, function()
        ParticleManager:DestroyParticle(pfx2, false)
    end)
    EmitSoundOn("RPCItem.DarkEmissary.Activate", caster)
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, ITEM_RPC_DARK_EMISSARY_GLOVE_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * ITEM_RPC_DARK_EMISSARY_GLOVE_DAMAGE_ATK_POWER_PCT/100 + emissary_glove:GetFinalGemPropertyValue("ruby", ITEM_RPC_DARK_EMISSARY_GLOVE_GEM_RUBY1)
    if #enemies > 0 then
        for _, enemy in pairs(enemies) do
            Filters:ApplyItemDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, emissary_glove, RPC_ELEMENT_GHOST, RPC_ELEMENT_NONE)
            emissary_glove:ApplyDataDrivenModifier(caster.InventoryUnit, enemy, "modifier_dark_emissary_root", {duration = ITEM_RPC_DARK_EMISSARY_GLOVE_ROOT_DURATION})
            CustomAbilities:QuickAttachParticle("particles/roshpit/duskbringer/ghostfire_blast_e3.vpcf", enemy, 0.5)
        end
    end
    if emissary_glove:GetGemValue("amethyst") > 0 then
        if not caster:HasModifier("modifier_invisibility_datadriven") then
            local pfx2 = CustomAbilities:QuickAttachParticle("particles/roshpit/conjuror/shadow_deity_cloak_of_shadows.vpcf", caster, 2)
            ParticleManager:SetParticleControl(pfx2, 1, Vector(200, 200, 200))
        end
        local invis_duration = emissary_glove:GetFinalGemPropertyValue("amethyst", ITEM_RPC_DARK_EMISSARY_GLOVE_GEM_AMETHYST1)
        emissary_glove:ApplyDataDrivenModifier(caster, caster, "modifier_invisibility_datadriven", {duration = invis_duration})
        caster:AddNewModifier(caster, emissary_glove, "modifier_persistent_invisibility", {duration = invis_duration})
    end
    if emissary_glove:GetGemValue("emerald") > 0 then
        if emissary_glove.dummy and IsValidEntity(emissary_glove.dummy) then
            emissary_glove.dummy:RemoveModifierByName("modifier_dark_emissary_emerald_thinker")
            emissary_glove.dummy = nil
        end
        local dummy = CreateUnitByName("npc_flying_dummy_vision", caster:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_GOODGUYS)
        dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
        dummy.hero = caster
        emissary_glove.dummy = dummy
        emissary_glove.emerald_damage = damage * emissary_glove:GetFinalGemPropertyValue("emerald", ITEM_RPC_DARK_EMISSARY_GLOVE_GEM_EMERALD2)/100
        local duration = emissary_glove:GetFinalGemPropertyValue("emerald", ITEM_RPC_DARK_EMISSARY_GLOVE_GEM_EMERALD1)
        emissary_glove:ApplyDataDrivenModifier(caster.InventoryUnit, dummy, "modifier_dark_emissary_emerald_thinker", {duration = duration})
        dummy.pfx = ParticleManager:CreateParticle("particles/roshpit/items/dark_emissary_emerald_cloud.vpcf", PATTACH_CUSTOMORIGIN, nil)
        ParticleManager:SetParticleControl(dummy.pfx, 0, caster:GetAbsOrigin() + Vector(0, 0, 80))
        ParticleManager:SetParticleControl(dummy.pfx, 1, Vector(ITEM_RPC_DARK_EMISSARY_GLOVE_RADIUS+200, 1, ITEM_RPC_DARK_EMISSARY_GLOVE_RADIUS/2))
    end
end

function Filters:BuzukisFinger(caster)
    local finger = caster.equipped_gear[RPC_GEAR_SLOT_GLOVES]
    local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, ITEM_RPC_BUZUKIS_FINGER_RADIUS, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
    if #allies > 0 then
        for _, ally in pairs(allies) do
            ally:RemoveModifierByName("modifier_buzuki_powering_up")
            EmitSoundOn("RPCItems.BuzukiFinger.Powerup", ally)
            finger:ApplyDataDrivenModifier(caster.InventoryUnit, ally, "modifier_buzukis_finger_buff", {duration = ITEM_RPC_BUZUKIS_FINGER_DURATION})
            finger:ApplyDataDrivenModifier(caster, ally, "modifier_buzuki_powering_up", {duration = 2.5})
            ally:AddNewModifier(caster.InventoryUnit, finger, "modifier_buzuki_finger_lua", {duration = ITEM_RPC_BUZUKIS_FINGER_DURATION})
            if finger:GetGemValue("ruby") > 0 then
                finger:ApplyDataDrivenModifier(caster.InventoryUnit, ally, "modifier_buzuki_ms_and_as", {duration = ITEM_RPC_BUZUKIS_FINGER_DURATION})
                ally:SetModifierStackCount("modifier_buzuki_ms_and_as", caster.InventoryUnit, finger:GetFinalGemPropertyValue("ruby", ITEM_RPC_BUZUKIS_FINGER_GEM_RUBY))
            end
        end
    end
end

function Filters:OrthokStack(hero, stacks)
    local chains = hero.equipped_gear[RPC_GEAR_SLOT_HEAD]
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

    if totalStacks > 0 then
        if chains:GetGemValue("ruby") > 0 then
            local ruby_stacks = chains:GetFinalGemPropertyValue("ruby", ORTHOK_RUBY)*totalStacks
            chains:ApplyDataDrivenModifier(hero.InventoryUnit, hero, "modifier_orthok_ruby", {duration = ORTHOK_STACK_DURATION})
            hero:SetModifierStackCount("modifier_orthok_ruby", hero.InventoryUnit, ruby_stacks)
        end
        if chains:GetGemValue("amethyst") > 0 then
            local amethyst_stacks = math.ceil(chains:GetFinalGemPropertyValue("amethyst", ORTHOK_AMETHYST)*totalStacks)
            chains:ApplyDataDrivenModifier(hero.InventoryUnit, hero, "modifier_orthok_amethyst", {duration = ORTHOK_STACK_DURATION})
            hero:SetModifierStackCount("modifier_orthok_amethyst", hero.InventoryUnit, amethyst_stacks)
        end
    else
        hero:RemoveModifierByName("modifier_orthok_ruby")
        hero:RemoveModifierByName("modifier_orthok_amethyst")
    end
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

function Filters:JexCosmicNatureW(caster)
    local ability = caster:FindAbilityByName("jex_cosmic_nature_w")
    local mana_usage = ability:GetSpecialValueFor("mana_cost_per_cast")
    if mana_usage > caster:GetMana() then
        ability:ToggleAbility()
    end
    caster:ReduceMana(mana_usage)
end

function Filters:AlienArmor(caster)
    local body = caster.equipped_gear[RPC_GEAR_SLOT_BODY]
    if not body.illusion_table then
        body.illusion_table = {}
    end
    local new_body_illusion_table = {}
    for i = 1, #body.illusion_table, 1 do
        if body.illusion_table[i] and IsValidEntity(body.illusion_table[i]) and body.illusion_table[i]:IsAlive() then
            table.insert(new_body_illusion_table, body.illusion_table[i])
        end
    end
    body.illusion_table = new_body_illusion_table
    local max_illusions = ITEM_RPC_ALIEN_ARMOR_MAX_ILLUSIONS + body:GetFinalGemPropertyValue("ruby", ITEM_RPC_ALIEN_ARMOR_GEM_RUBY)
    if #body.illusion_table < max_illusions then
        local modifierKeys = {}

        modifierKeys.outgoing_damage = 0
        modifierKeys.incoming_damage = 1 - (ITEM_RPC_ALIEN_ARMOR_INCOMING_DAMAGE_REDUCTION/100)
        modifierKeys.duration = ITEM_RPC_ALIEN_ARMOR_ILLUSION_DURATION + body:GetFinalGemPropertyValue("amethyst", ITEM_RPC_ALIEN_ARMOR_GEM_AMETHYST)
        local illusions = CreateIllusions( caster, caster, modifierKeys, 1, 20, true, true)
        local illusion = illusions[1]
        illusion.owner = caster
        illusion.hero = caster
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
        illusion.spirit_custom = caster.spirit_custom
        illusion.str_bonus = caster.str_bonus
        illusion.agi_bonus = caster.agi_bonus
        illusion.int_bonus = caster.int_bonus
        illusion.spirit_bonus = caster.spirit_bonus
        local damage_mult = ITEM_RPC_ALIEN_ARMOR_OUTGOING_DAMAGE_MULT + body:GetFinalGemPropertyValue("sapphire", ITEM_RPC_ALIEN_ARMOR_GEM_SAPPHIRE)/100
        illusion:AdjustSummon(caster, true, 1, damage_mult, 1, 1, 1, 1)
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
                        --print(modifier_name)
                        if modifier_name == "modifier_shapeshift_cat" or modifier_name == "modifier_shapeshift_crow" or modifier_name == "modifier_shapeshift_year_beast" or modifier_name == "modifier_shapeshift_bear" or modifier_name == "modifier_draghor_shapeshift_bear_lua" or modifier_name == "modifier_draghor_shapeshift_hawk_lua" or modifier_name == "modifier_draghor_shapeshift_cat_lua" then
                            modifier_ability:ApplyDataDrivenModifier(modifier:GetCaster(), illusion, modifier:GetName(), {duration = duration})
                            illusion:SetModifierStackCount(modifier:GetName(), modifier:GetCaster(), modifier:GetStackCount())
                        end
                    end
                end
            end
        end
        if body:GetGemValue("emerald") > 0 then
            local as_stacks = body:GetFinalGemPropertyValue("emerald", ITEM_RPC_ALIEN_ARMOR_GEM_EMERALD)
            body:ApplyDataDrivenModifier(caster.InventoryUnit, illusion, "modifier_alien_armor_as", {})
            illusion:SetModifierStackCount("modifier_alien_armor_as", caster.InventoryUnit, as_stacks)
        end
        illusion:SetRenderColor(0, 0, 0)


        local new_body_illusion_table = {}
        for i = 1, #body.illusion_table, 1 do
            if IsValidEntity(body.illusion_table[i]) then
                table.insert(new_body_illusion_table, body.illusion_table[i])
            end
        end
        table.insert(new_body_illusion_table, illusion)
        body.illusion_table = new_body_illusion_table
    end
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
		modifier_heavy_boulder_pushback = true,
		modifier_bear_sliding = true,
		modifier_recently_teleported_portal = true,
    }
    return self.nonExtendableBuffs[modifier:GetName()] or isDebuff or false
end

function Filters:NetergraspPalisade(hero, target)
    local ability = hero.equipped_gear[RPC_GEAR_SLOT_BODY]
    local caster = hero.InventoryUnit
    if target:HasModifier("modifier_nethergrasp_linked") then
        return false
    end
    local distance = WallPhysics:GetDistance2d(hero:GetAbsOrigin(), target:GetAbsOrigin())
    local link_range = ITEM_RPC_NETHERGRASP_PALISADE_LINK_RANGE + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_NETHERGRASP_PALISADE_GEM_RUBY1)
    if distance > link_range then
        return false
    end
    if target.dummy then
        return false
    end
    ability:ApplyDataDrivenModifier(caster, target, "modifier_nethergrasp_linked", {duration = 30})
    if ability:GetGemValue("amethyst") > 0 then
        ability:ApplyDataDrivenModifier(caster, target, "modifier_nethergrasp_attack_speed_loss", {duration = 30})
        target:SetModifierStackCount("modifier_nethergrasp_attack_speed_loss", caster, ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_NETHERGRASP_PALISADE_GEM_AMETHYST))
    end
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
    local max_links = ITEM_RPC_NETHERGRASP_PALISADE_MAX_LINKS + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_NETHERGRASP_PALISADE_GEM_RUBY2)
    if #ability.nethergrasp_table > max_links then
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
    local ring = caster.equipped_gear[RPC_GEAR_SLOT_TRINKET]
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
    --DeepPrintTable(ring.abilities_cast)
    if condition_met then
        ring.abilities_cast = {false, false, false, false}
        EmitSoundOn("Items.InspirationRing.Activate", caster)
        local pfx = ParticleManager:CreateParticle(particleName, PATTACH_POINT_FOLLOW, caster)
        ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
        -- ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true)
        ParticleManager:SetParticleControl(pfx, 5, Vector(1,1,1))


        if ring:GetAbilityName() == "item_rpc_auric_ring_of_inspiration" then
            local immunity_time = ITEM_RPC_AURIC_RING_OF_INSPIRATION_MAGIC_IMMUNITY_TIME + ring:GetFinalGemPropertyValue("sapphire", ITEM_RPC_AURIC_RING_OF_INSPIRATION_GEM_SAPPHIRE)
            ring:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_auric_ring_bkb", {duration = immunity_time})
            if ring:GetGemValue("amethyst") > 0 then
                local heal = caster:GetMaxHealth()*ring:GetFinalGemPropertyValue("amethyst", ITEM_RPC_AURIC_RING_OF_INSPIRATION_GEM_AMETHYST)/100
                Filters:ApplyHeal(caster, caster, heal, true, true)
            end
        elseif ring:GetAbilityName() == "item_rpc_beryl_ring_of_intuition" then
            for i = 0, 8, 1 do
                local ability = caster:GetAbilityByIndex(i)
                if ability and IsValidEntity(ability) then
                    local cd = ability:GetCooldownTimeRemaining()
                    ability:EndCooldown()
                    if i == DOTA_R_SLOT and cd > ITEM_RPC_BERYL_RING_OF_INTUITION_ULTIMATE_MIN_CD then
                        ability:StartCooldown(ITEM_RPC_BERYL_RING_OF_INTUITION_ULTIMATE_MIN_CD)
                    end
                end
            end
            if ring:GetGemValue("ruby") > 0 then
                local heal = caster:GetMaxHealth()*ring:GetFinalGemPropertyValue("ruby", ITEM_RPC_BERYL_RING_OF_INTUITION_GEM_RUBY)/100
                Filters:ApplyHeal(caster, caster, heal, true, true)
            end
            if ring:GetGemValue("amethyst") > 0 then
                local manaRestore = caster:GetMaxHealth()*ring:GetFinalGemPropertyValue("ruby", ITEM_RPC_BERYL_RING_OF_INTUITION_GEM_AMETHYST)/100
                caster:GiveMana(manaRestore)
                PopupMana(caster, manaRestore)
            end
            if ring:GetGemValue("emerald") > 0 then
                ring:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_beryl_ring_of_intuition_emerald_armor_pierce", {duration = ITEM_RPC_BERYL_RING_OF_INTUITION_EMERALD_DURATION})
            end
        end
        Timers:CreateTimer(2, function()
            ParticleManager:DestroyParticle(pfx, false)
        end)
    end
    CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "inspiration_ring", {abilities_cast = ring.abilities_cast, ring_name = ring:GetAbilityName(), clear = 0, caster = caster:GetEntityIndex(), border_color = ring.newItemTable.property1color})
end

function Filters:SamuraiAttackLand(damage, attacker, target)
    local luck = RandomInt(1, 100)
    local helm = attacker.equipped_gear[RPC_GEAR_SLOT_HEAD]
    local chance = ADAMANTINE_SAMURAI_CHANCE
    local sapphire_value = helm:GetGemValue("sapphire")
    if sapphire_value > 0 then
        chance = chance + ADAMANTINE_SAMURAI_HELMET_SAPPHIRE[sapphire_value]
    end
    local proc = Filters:GetProc(attacker, chance)
    if proc then
        local damage_boost = ADAMANTINE_SAMURAI_CRIT/100
        local amethyst_value = helm:GetGemValue("amethyst")
        if amethyst_value > 0 then
            damage_boost = damage_boost + ADAMANTINE_SAMURAI_HELMET_AMETHYST[amethyst_value]/100
        end
        damage = damage * (1 + damage_boost)
        PopupDamage(target, damage)
        EmitSoundOn("RPCItems.SamuraiHelm.Crit", attacker)
        CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_skeletonking/skeleton_king_ti8_weapon_blur_critical.vpcf", attacker, 2)
        if helm:GetGemValue("ruby") > 0 then
            helm:ApplyDataDrivenModifier(attacker.InventoryUnit, attacker, "modifier_samurai_helmet_ruby", {duration = ADAMANTINE_SAMURAI_RUBY_DURATION})
        end
    end
    return damage
end

function Filters:FenrirAttackLand(damage, attacker, target)
    local luck = RandomInt(1, 100)
    local fang = attacker.equipped_gear[RPC_GEAR_SLOT_TRINKET]
    if fang:GetGemValue("ruby") > 0 then
        local chance = ITEM_RPC_FENRIRS_FANG_RUBY_CHANCE
        local proc = Filters:GetProc(attacker, chance)
        if proc then
            local damage_boost = fang:GetFinalGemPropertyValue("ruby", ITEM_RPC_FENRIRS_FANG_GEM_RUBY)/100
            damage = damage * (1 + damage_boost)
            PopupDamage(target, damage)
            EmitSoundOn("RPCItems.WolfFang.Crit", attacker)
            CustomAbilities:QuickAttachParticle("particles/roshpit/items/fenrir_crit.vpcf", attacker, 2)
        end
    end
    return damage
end

function Filters:CarbuncleApply(caster, duration, bConsiderCooldown)
    if duration > 0 then
        if (not caster:HasModifier("modifier_carbuncle_cooldown") and bConsiderCooldown) or not bConsiderCooldown then
            if caster:HasModifier("modifier_carbuncles_helm_of_reflection_effect") then
                local modifier = caster:FindModifierByName("modifier_carbuncles_helm_of_reflection_effect")
                if modifier:GetRemainingTime() > duration then
                    return false
                end
            end
            caster.equipped_gear[RPC_GEAR_SLOT_HEAD]:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_carbuncles_helm_of_reflection_effect", {duration = duration})
            caster.equipped_gear[RPC_GEAR_SLOT_HEAD].carbuncle_last_duration = duration
            if bConsiderCooldown then
                caster.equipped_gear[RPC_GEAR_SLOT_HEAD]:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_carbuncle_cooldown", {duration = CARBUNCLE_SHIELD_COOLDOWN})
            end
        end
    end
end

function Filters:CarbuncleReflect(victim, attacker, damage, damagetype)
    CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_medusa/carbuncle_ruby_shell_cast.vpcf", victim, 0.8)
    EmitSoundOn("RPC.Carbuncle.Reflect", attacker)

        local info =
        {
            Target = attacker,
            Source = victim,
            Ability = victim.equipped_gear[RPC_GEAR_SLOT_HEAD],
            EffectName = "particles/roshpit/items/carbuncle_projectile.vpcf",
            StartPosition = "attach_hitloc",
            bDrawsOnMinimap = false,
            bDodgeable = true,
            bIsAttack = false,
            bVisibleToEnemies = true,
            bReplaceExisting = false,
            flExpireTime = GameRules:GetGameTime() + 8,
            bProvidesVision = true,
            iVisionRadius = 0,
            iMoveSpeed = 1050,
        iVisionTeamNumber = victim:GetTeamNumber()}

    projectile = ProjectileManager:CreateTrackingProjectile(info)

    local carbuncle_data = {}
    carbuncle_data.damage = damage
    carbuncle_data.damagetype = damagetype
    carbuncle_data.attacker = victim
    attacker.carbuncle_data = carbuncle_data


    local luck = RandomInt(1, 100)
    if luck < victim.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetFinalGemPropertyValue("emerald", CARBUNCLE_EMERALD) then
        local modifier = victim:FindModifierByName("modifier_carbuncles_helm_of_reflection_effect")
        modifier:SetDuration(victim.equipped_gear[RPC_GEAR_SLOT_HEAD].carbuncle_last_duration, true)
    else
        victim:RemoveModifierByName("modifier_carbuncles_helm_of_reflection_effect")
    end
    

    local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/items/carbuncle_reflect.vpcf", victim, 3)
    ParticleManager:SetParticleControlEnt(pfx, 1, victim, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", victim:GetAbsOrigin(), true) 
    EmitSoundOn("RPC.Carbuncle.Reflect", victim)
    local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/items/carbuncle_reflect.vpcf", attacker, 3)
    ParticleManager:SetParticleControlEnt(pfx, 1, attacker, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin(), true) 
end

function Filters:SilentTemplar(caster)
    local silent_templar_helm = caster.equipped_gear[RPC_GEAR_SLOT_HEAD]
    local duration = SILENT_TEMPLAR_DURATION + silent_templar_helm:GetFinalGemPropertyValue("ruby", SILENT_TEMPLAR_RUBY)
    silent_templar_helm:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_helm_of_silent_templar_effect", {duration = duration})
    local particleName = "particles/dark_smoke_test.vpcf"
    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
    EmitSoundOn("RPC.SilentGuard.Init", caster)
    Timers:CreateTimer(1.5, function()
        ParticleManager:DestroyParticle(pfx, false)
    end)

    if silent_templar_helm:GetGemValue("emerald") > 0 then
        silent_templar_helm:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_silent_templar_emerald_as", {duration = duration})
        caster:SetModifierStackCount("modifier_silent_templar_emerald_as", caster.InventoryUnit, silent_templar_helm:GetFinalGemPropertyValue("emerald", SILENT_TEMPLAR_EMERALD))
    end
    if silent_templar_helm:GetGemValue("sapphire") > 0 then
        caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
        caster:AddNewModifier(caster.InventoryUnit, silent_templar_helm, "modifier_silent_templar_sapphire", {duration = duration})
        silent_templar_helm:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_silent_templar_sapphire_orb", {duration = duration})

    end
    if silent_templar_helm:GetGemValue("amethyst") > 0 then
        silent_templar_helm:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_silent_templar_amethyst_hp_regen_loss", {duration = duration})
        silent_templar_helm:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_silent_templar_amethyst_attack_power", {duration = duration})
        caster:SetModifierStackCount("modifier_silent_templar_amethyst_attack_power", caster.InventoryUnit, silent_templar_helm:GetFinalGemPropertyValue("amethyst", SILENT_TEMPLAR_AMETHYST))
    end
end

function Filters:OdinHelm(caster, victim, damage)
    local ability = caster.equipped_gear[RPC_GEAR_SLOT_HEAD]
    local proc_chance = ODIN_HELMET_CHANCE + ability:GetFinalGemPropertyValue("ruby", ODIN_RUBY)
    local proc = Filters:GetProc(caster, proc_chance)
    if proc then
        if not caster:HasModifier("modifier_odin_beam_casting") then
            -- StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_ATTACK, rate=1.3})
            local particleVector = caster:GetAbsOrigin() + Vector(0, 0, 90)
            if not ability.beamTable then
                ability.beamTable = {}
            end
            local beamLength = ODIN_BEAM_LENGTH + ability:GetFinalGemPropertyValue("emerald", ODIN_EMERALD)
            local beam = {}
            local particle_name = "particles/roshpit/items/odin.vpcf"
            local pfx = ParticleManager:CreateParticle(particle_name, PATTACH_CUSTOMORIGIN, nil)
            ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin() + Vector(0, 0, 90))
            ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin() + Vector(0, 0, 90))
            ParticleManager:SetParticleControl(pfx, 3, caster:GetAbsOrigin() + Vector(0, 0, 90))
            ParticleManager:SetParticleControl(pfx, 4, caster:GetAbsOrigin() + Vector(0, 0, 90))
            local fv = ((victim:GetAbsOrigin() - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
            beam.target = caster:GetAbsOrigin()+fv*beamLength
            beam.pfx = pfx
            beam.position = caster:GetAbsOrigin()
            ability:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_odin_beam_casting", {})
            beam.interval = 0
            beam.active = true
            beam.length = WallPhysics:GetDistance2d(beam.position, beam.target)
            beam.startPoint = caster:GetAbsOrigin()
            ability.pushBack = fv*-1
            table.insert(ability.beamTable, beam)
            -- StartAnimation(caster, {duration=0.85, activity=ACT_DOTA_ATTACK, rate=1})
            EmitSoundOn("Jex.CosmicLaser", caster)
            ability:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_odin_beam_pushback", {duration = 0.3})
            EmitSoundOn("RPCItems.OdinHelmet.Proc", caster)    
            beam.damage = damage * (0 + ((ODIN_HELMET_PCT_DAMAGE + ability:GetFinalGemPropertyValue("sapphire", ODIN_SAPPHIRE))/100))
        end
    end
end

function Filters:EternalNightW(attacker, victim)
    local shroud = attacker.equipped_gear[RPC_GEAR_SLOT_HEAD]
    local proc = Filters:GetProc(attacker, shroud:GetFinalGemPropertyValue("ruby", ETERNAL_NIGHT_RUBY))
    if proc then
        Filters:EternalNightTrigger(attacker, victim, attacker.InventoryUnit, shroud)
    end
end

function Filters:EternalNightTrigger(hero, victim, caster, ability)
    if not victim:HasModifier("modifier_eternal_night_sleep_immune") then
        local sleep_duration = ETERNAL_NIGHT_SLEEP_DURATION + ability:GetFinalGemPropertyValue("emerald", ETERNAL_NIGHT_EMERALD)
        ability:ApplyDataDrivenModifier(hero, victim, "modifier_eternal_night_sleep", {duration = sleep_duration})
        local unwakeable_duration = ETERNAL_NIGHT_UNWAKEABLE_DURATION + ability:GetFinalGemPropertyValue("sapphire", ETERNAL_NIGHT_SAPPHIRE)
        ability:ApplyDataDrivenModifier(hero, victim, "modifier_eternal_night_sleep_unwakable", {duration = unwakeable_duration})
    end
end

function Filters:WraithCrown(caster)
    local wraith_crown = caster.equipped_gear[RPC_GEAR_SLOT_HEAD]
    if wraith_crown:GetGemValue("amethyst") > 0 and caster:HasModifier("modifier_wraith_crown_ethereal") then
        if not caster:HasModifier("modifier_wraith_crown_amethyst_cd") then
            ProjectileManager:ProjectileDodge(caster)
            caster:Stop()
            local amethyst_duration = wraith_crown:GetFinalGemPropertyValue("amethyst", WRAITH_CROWN_AMETHYST)
            wraith_crown:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_wraith_crown_amethyst", {duration = amethyst_duration})
            EmitSoundOn("Item.WraithCrown", caster)         
        end
    end

    if not caster:HasModifier("modifier_wraith_crown_cd") then
        local duration = WRAITH_CROWN_ETHEREAL_DURATION + wraith_crown:GetFinalGemPropertyValue("emerald", WRAITH_CROWN_EMERALD)
        wraith_crown:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_wraith_crown_ethereal", {duration = duration})
        wraith_crown:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_wraith_crown_cd", {duration = WRAITH_CROWN_ETHEREAL_COOLDOWN})

        EmitSoundOn("RPCItems.WraithCrown.EtherealStart", caster)
        CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_invoker/invoker_ghost_walk.vpcf", caster, 2)
    end

end

function Filters:BluestarCast(caster)
    local hero = caster
    local bluestar_armor = caster.equipped_gear[RPC_GEAR_SLOT_BODY]
    if bluestar_armor:GetGemValue("sapphire") > 0 then
        hero.bluestarSlideVelocity = bluestar_armor:GetFinalGemPropertyValue("sapphire", ITEM_RPC_BLUESTAR_ARMOR_GEM_SAPPHIRE)
        bluestar_armor:ApplyDataDrivenModifier(hero.InventoryUnit, hero, "modifier_bluestar_slide", {duration = 1})

        local particleName = "particles/items_fx/arcane_boots.vpcf"
        local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, hero)
        ParticleManager:SetParticleControlEnt(pfx, 0, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)
        Timers:CreateTimer(0.2, function()
            ParticleManager:DestroyParticle(pfx, false)
        end)
    end
end

function Filters:DepthCrestArmor(caster, ability, chance)
    local proc = Filters:GetProc(caster, chance)
	if caster:IsAlive() then
		if proc then
			StartAnimation(caster, {duration = 0.4, activity = ACT_DOTA_SPAWN, rate = 2.0})
			local radius = ITEM_RPC_DEPTH_CREST_ARMOR_STUN_RADIUS + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_DEPTH_CREST_ARMOR_GEM_RUBY2) + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_DEPTH_CREST_ARMOR_GEM_EMERALD2)
			local stun_duration = ITEM_RPC_DEPTH_CREST_ARMOR_STUN_DURATION + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_DEPTH_CREST_ARMOR_GEM_EMERALD1)
			EmitSoundOn("Items.DepthCrest", caster)
			local particleName = "particles/roshpit/items/depth_crest_armor.vpcf"
			local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin() + Vector(0, 0, 20))
			ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 1, 1))
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				local damage = caster:GetRoshpitArmor() * ITEM_RPC_DEPTH_CREST_ARMOR_ARMOR_TO_DMG + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_DEPTH_CREST_ARMOR_GEM_RUBY1)*caster:GetStrength()
				for _, enemy in pairs(enemies) do
					Filters:ApplyItemDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, ability, RPC_ELEMENT_WATER, RPC_ELEMENT_NORMAL)
					Filters:ApplyStun(caster, ITEM_RPC_DEPTH_CREST_ARMOR_STUN_DURATION, enemy)
				end
			end
		end
	end
end

function Filters:ApplyFeronia(caster, slot, bReapply)
    local duration = 0
    local feronia = caster.equipped_gear[RPC_GEAR_SLOT_BODY]
    if slot == BASE_ABILITY_E then
        duration = ITEM_RPC_GUARD_OF_FERONIA_SHIELD_DURATION_E
    elseif slot == BASE_ABILITY_R then
        duration = ITEM_RPC_GUARD_OF_FERONIA_SHIELD_DURATION_R
    elseif slot == BASE_ABILITY_Q then
        if feronia:GetGemValue("emerald") > 0 then
            duration = feronia:GetFinalGemPropertyValue("emerald", ITEM_RPC_GUARD_OF_FERONIA_GEM_EMERALD)
        end
    elseif slot == -10 then
        if caster:HasModifier("modifier_guard_of_feronia_shield") then
            duration = caster:FindModifierByName("modifier_guard_of_feronia_shield"):GetRemainingTime() + ITEM_RPC_GUARD_OF_FERONIA_SAPPHIRE_DURATION_ADD
        else
            duration = ITEM_RPC_GUARD_OF_FERONIA_SAPPHIRE_DURATION_ADD
        end
    end
    if duration > 0 then
        if bReapply then
            caster:RemoveModifierByName("modifier_guard_of_feronia_shield")
            feronia:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_guard_of_feronia_shield", {duration = duration})
        else
            feronia:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_guard_of_feronia_shield", {duration = duration})
        end
    end
end

function Filters:HurricaneVest(caster, tornado_count)
    local ability = caster.equipped_gear[RPC_GEAR_SLOT_BODY]
    local fv = caster:GetForwardVector()
    ability.pushFV = fv
    local hurricaneStartPosition = caster:GetAbsOrigin()
    local range = ITEM_RPC_HURRICANE_VEST_MAX_DISTANCE + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_HURRICANE_VEST_GEM_EMERALD2)
    local start_radius = 220
    local end_radius = 220
    local speed = ITEM_RPC_HURRICANE_VEST_HURRICANE_SPEED
    local projectileParticle = "particles/roshpit/items/hurricane_vest.vpcf"
    EmitSoundOn("RPCItem.HurricaneVestNew", caster)

    ability.caster = caster
    for i = 1, tornado_count do
        local shotVector = WallPhysics:rotateVector(fv, (2 * math.pi / tornado_count) * i)
        local info =
        {
            Ability = ability,
            EffectName = projectileParticle,
            vSpawnOrigin = hurricaneStartPosition,
            fDistance = range,
            fStartRadius = start_radius,
            fEndRadius = end_radius,
            Source = caster.InventoryUnit,
            StartPosition = "attach_origin",
            bHasFrontalCone = true,
            bReplaceExisting = false,
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
            iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            fExpireTime = GameRules:GetGameTime() + 5.0,
            bDeleteOnHit = false,
            vVelocity = shotVector * speed,
            bProvidesVision = false,
        }
        ProjectileManager:CreateLinearProjectile(info)
    end
end

function Filters:FloodRobe(caster)
    local robes = caster.equipped_gear[RPC_GEAR_SLOT_BODY]
    if not robes.elemental_table then
        robes.elemental_table = {}
    end
    local new_elemental_table = {}
    for i = 1, #robes.elemental_table, 1 do
        if robes.elemental_table[i] and IsValidEntity(robes.elemental_table[i]) and robes.elemental_table[i]:IsAlive() then
            table.insert(new_elemental_table, robes.elemental_table[i])
        end
    end
    robes.elemental_table = new_elemental_table
    if #robes.elemental_table < 1 then
        local eleName = "water_elemental_flood_3"
        local renderVector = Vector(175, 175, 255)

        local elemental = CreateUnitByName(eleName, caster:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
        elemental:SetRenderColor(renderVector.x, renderVector.y, renderVector.z)
        elemental.owner = caster:GetPlayerOwnerID()

        elemental.summoner = caster
        elemental:SetOwner(caster)
        elemental:SetControllableByPlayer(caster:GetPlayerID(), true)
        elemental:AdjustSummon(caster, true, ITEM_RPC_ROBE_OF_FLOODING_HEALTH_MULT, ITEM_RPC_ROBE_OF_FLOODING_ATTACK_MULT, 1, 1, 1, 1)
        elemental.hero = caster
        if robes:GetGemValue("sapphire") > 0 then
            local newHealth = elemental:GetMaxHealth() + caster:GetIntellect()*robes:GetFinalGemPropertyValue("sapphire", ITEM_RPC_ROBE_OF_FLOODING_GEM_SAPPHIRE)
            elemental:SetMaxHPandHealToFull(newHealth)

            local newDamage = elemental:GetAttackDamage() + caster:GetIntellect()*robes:GetFinalGemPropertyValue("sapphire", ITEM_RPC_ROBE_OF_FLOODING_GEM_SAPPHIRE)
            Filters:SetAttackDamage(elemental, newDamage)
        end
        elemental:AddAbility("flood_water_elemental_ai"):SetLevel(1)
        elemental:FindAbilityByName("flood_water_elemental_ai"):ToggleAbility()

        table.insert(robes.elemental_table, elemental)

        local particleName = "particles/units/heroes/hero_slardar/slardar_crush_water.vpcf"
        local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, elemental)
        local origin = elemental:GetAbsOrigin()
        ParticleManager:SetParticleControl(particle1, 0, origin)
        ParticleManager:SetParticleControl(particle1, 1, Vector(300, 2, 160))
        Timers:CreateTimer(3, function()
            ParticleManager:DestroyParticle(particle1, false)
        end)
        EmitSoundOn("RPCItems.OceanTempest.Splash", elemental)
        if robes:GetGemValue("emerald") > 0 then
            robes:ApplyDataDrivenModifier(caster.InventoryUnit, elemental, "modifier_robe_of_flooding_as", {})
            elemental:SetModifierStackCount("modifier_robe_of_flooding_as", caster.InventoryUnit, robes:GetFinalGemPropertyValue("emerald", ITEM_RPC_ROBE_OF_FLOODING_GEM_EMERALD1))
            elemental:AddAbility("water_flood_nuke"):SetLevel(1)
        end
        if robes:GetGemValue("amethyst") > 0 then
            robes:ApplyDataDrivenModifier(caster.InventoryUnit, elemental, "modifier_robe_of_flooding_ms", {})
            elemental:SetModifierStackCount("modifier_robe_of_flooding_ms", caster.InventoryUnit, robes:GetFinalGemPropertyValue("amethyst", ITEM_RPC_ROBE_OF_FLOODING_GEM_AMETHYST1))
        end
    end

end

function Filters:FloodElementalAttack(elemental, hero, flood_robe, target, damage)
    if flood_robe:GetGemValue("amethyst") > 0 then
        local particleName = "particles/items3_fx/mango_active.vpcf"
        local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, hero)
        ParticleManager:SetParticleControlEnt(pfx, 0, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)
        Timers:CreateTimer(1, function()
            ParticleManager:DestroyParticle(pfx, false)
        end)
        local manaRestore = math.floor(hero:GetMaxMana() * flood_robe:GetFinalGemPropertyValue("amethyst", ITEM_RPC_ROBE_OF_FLOODING_GEM_AMETHYST2)/100)
        hero:GiveMana(manaRestore)
        PopupMana(hero, manaRestore)
    end
    if flood_robe:GetGemValue("ruby") > 0 then
        local radius = ITEM_RPC_ROBE_OF_FLOODING_RUBY_AOE

        local particleName = "particles/units/heroes/hero_slardar/slardar_crush.vpcf"
        local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
        local origin = target:GetAbsOrigin()
        ParticleManager:SetParticleControl(particle1, 0, origin)
        ParticleManager:SetParticleControl(particle1, 1, Vector(radius, 1, 1))
        Timers:CreateTimer(3, function()
            ParticleManager:DestroyParticle(particle1, false)
        end)
        local elemental_ability = elemental:FindAbilityByName("water_elemental_ability")
        local aoe_damage = damage * flood_robe:GetFinalGemPropertyValue("ruby", ITEM_RPC_ROBE_OF_FLOODING_GEM_RUBY1)/100
        local enemies = FindUnitsInRadius(hero:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
        local slow_amount = flood_robe:GetFinalGemPropertyValue("ruby", ITEM_RPC_ROBE_OF_FLOODING_GEM_RUBY2)
        if #enemies > 0 then
            for _, enemy in pairs(enemies) do
                Filters:ApplyItemDamage(enemy, hero, aoe_damage, DAMAGE_TYPE_MAGICAL, flood_robe, RPC_ELEMENT_WATER, RPC_ELEMENT_NONE)
                elemental_ability:ApplyDataDrivenModifier(elemental, enemy, "modifier_water_elemental_slow", {duration = ITEM_RPC_ROBE_OF_FLOODING_RUBY_SLOW_DURATION})
                enemy:SetModifierStackCount("modifier_water_elemental_slow", elemental, slow_amount)
            end
        end
    end
end

function Filters:SacredTrialActivate(caster)
    local trials_armor = caster.equipped_gear[RPC_GEAR_SLOT_BODY]
    local duration = ITEM_RPC_SACRED_TRIALS_ARMOR_DURATION + trials_armor:GetFinalGemPropertyValue("ruby", ITEM_RPC_SACRED_TRIALS_ARMOR_GEM_RUBY2)
    trials_armor:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_sacred_trials_attack_bonus", {duration = duration})
    CustomAbilities:QuickAttachParticle("particles/econ/items/dazzle/dazzle_ti6_gold/dazzle_ti6_shallow_grave_gold_ground_ray.vpcf", caster, 1)
    if trials_armor:GetGemValue("emerald") > 0 then
        trials_armor:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_sacred_trials_as", {duration = duration})
        caster:SetModifierStackCount("modifier_sacred_trials_as", caster.InventoryUnit, trials_armor:GetFinalGemPropertyValue("emerald", ITEM_RPC_SACRED_TRIALS_ARMOR_GEM_EMERALD1))
    end
    if trials_armor:GetGemValue("amethyst") > 0 then
        trials_armor:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_sacred_trials_attack_power", {duration = duration})
        caster:SetModifierStackCount("modifier_sacred_trials_attack_power", caster.InventoryUnit, trials_armor:GetFinalGemPropertyValue("amethyst", ITEM_RPC_SACRED_TRIALS_ARMOR_GEM_AMETHYST))
    end
end

function Filters:TwilightVestments(hero, damage, damagetype)
    local twilight_vest = hero.equipped_gear[RPC_GEAR_SLOT_BODY]
    local threshold = (ITEM_RPC_TWILIGHT_VESTMENTS_HP_THRESHOLD - twilight_vest:GetFinalGemPropertyValue("ruby", ITEM_RPC_TWILIGHT_VESTMENTS_GEM_RUBY))/100
    if damage > hero:GetMaxHealth() * threshold then
        EmitSoundOn("RPCItems.TwilightVestments.Heal", hero)
        local heal_pct = (ITEM_RPC_TWILIGHT_VESTMENTS_HEAL_PCT + twilight_vest:GetFinalGemPropertyValue("emerald", ITEM_RPC_TWILIGHT_VESTMENTS_GEM_EMERALD))
        if damagetype == DAMAGE_TYPE_PURE then
            heal_pct = heal_pct + twilight_vest:GetFinalGemPropertyValue("sapphire", ITEM_RPC_TWILIGHT_VESTMENTS_GEM_SAPPHIRE)
        end
        local healAmount = math.ceil(damage * heal_pct/100)
        Timers:CreateTimer(ITEM_RPC_TWILIGHT_VESTMENTS_DELAY, function()
            Filters:ApplyHeal(hero, hero, healAmount, true, true)
            local particleName = "particles/roshpit/twilight_vestment_heal.vpcf"
            local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, hero)
            ParticleManager:SetParticleControlEnt(pfx, 0, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)
            Timers:CreateTimer(1, function()
                ParticleManager:DestroyParticle(pfx, false)
            end)
        end)
    end
end

function Filters:WaterMageRobeProjectile(ability, caster, fv)
    local range = 1200
    local start_radius = 320
    local end_radius = 320
    local speed = 700 + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_WATER_MAGE_ROBES_GEM_EMERALD2)
    local projectileParticle = "particles/units/heroes/hero_tidehunter/tidehunter_gush_upgrade.vpcf"
    local info =
    {
        Ability = ability,
        EffectName = projectileParticle,
        vSpawnOrigin = caster:GetAbsOrigin() + Vector(0, 0, 30),
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
        fExpireTime = GameRules:GetGameTime() + 6.0,
        bDeleteOnHit = false,
        vVelocity = fv * speed,
        bProvidesVision = false,
    }
    projectile = ProjectileManager:CreateLinearProjectile(info)
end

function Filters:AquaSteelRHit(caster, target)
    local aqua_bracers = caster.equipped_gear[RPC_GEAR_SLOT_GLOVES]
    if aqua_bracers:GetGemValue("amethyst") > 0 then
        local limitKey = "_aquasteel_amethyst"
        local max_procs_per_second = aqua_bracers:GetFinalGemPropertyValue("amethyst", ITEM_RPC_AQUASTEEL_BRACERS_GEM_AMETHYST)
        Util.Common:LimitPerTime(max_procs_per_second, 1, limitKey, function()
            Filters:AquaSteelWaterJet(caster, aqua_bracers, target)
        end)       
    end
end

function Filters:AquaSteelWaterJet(caster, ability, target)
    local dagon_particle = ParticleManager:CreateParticle("particles/econ/events/ti7/dagon_ti7.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt(dagon_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)
    ParticleManager:SetParticleControlEnt(dagon_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false)
    local particle_effect_intensity = 700
    ParticleManager:SetParticleControl(dagon_particle, 2, Vector(particle_effect_intensity, particle_effect_intensity, particle_effect_intensity))
    Timers:CreateTimer(2.0, function()
        ParticleManager:DestroyParticle(dagon_particle, false)
        ParticleManager:ReleaseParticleIndex(dagon_particle)
    end)
    local damage = (ITEM_RPC_AQUASTEEL_BRACERS_ATTACK_TO_DMG/100) * OverflowProtectedGetAverageTrueAttackDamage(caster) + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_AQUASTEEL_BRACERS_GEM_RUBY1)
    damage = damage + (ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_AQUASTEEL_BRACERS_GEM_SAPPHIRE2)/100)*caster:GetRoshpitArmor()
    local stun_duration = ITEM_RPC_AQUASTEEL_BRACERS_STUN_DUR + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_AQUASTEEL_BRACERS_GEM_RUBY2)
    EmitSoundOn("RPCItem.Aquasteel", target)
    Timers:CreateTimer(0.1, function()
        Filters:ApplyItemDamage(target, caster, damage, DAMAGE_TYPE_PHYSICAL, ability, RPC_ELEMENT_WATER, RPC_ELEMENT_NONE)
        Filters:ApplyStun(caster, stun_duration, target)
    end)
end

function Filters:AutumnRockWCast(caster)
    local bracer = caster.equipped_gear[RPC_GEAR_SLOT_GLOVES]
    if bracer:GetGemValue("amethyst") > 0 then
        local proc = Filters:GetProc(caster, bracer:GetFinalGemPropertyValue("amethyst", ITEM_RPC_AUTUMNROCK_BRACER_GEM_AMETHYST))
        if proc then
            local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, ITEM_RPC_AUTUMNROCK_BRACER_AMETHYST_SEARCH_RANGE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
            if #enemies > 0 then
                Filters:AutumnrockExplosion(caster, bracer, enemies[1]:GetAbsOrigin(), ITEM_RPC_AUTUMNROCK_BRACER_EXP_AOE)
            end
        end
    end
end

function Filters:AutumnrockExplosion(caster, ability, position, explosionAOE)
    local particleName = "particles/econ/items/centaur/centaur_ti6/centaur_ti6_warstomp.vpcf"
    local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(particle1, 0, position)
    ParticleManager:SetParticleControl(particle1, 1, Vector(explosionAOE, 5, explosionAOE * 2))
    Timers:CreateTimer(4, function()
        ParticleManager:DestroyParticle(particle1, false)
    end)
    local damage = caster:GetStrength() * ITEM_RPC_AUTUMNROCK_BRACER_DMG_PER_STR
    local stun_duration = ITEM_RPC_AUTUMNROCK_BRACER_STUN_DUR + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_AUTUMNROCK_BRACER_GEM_EMERALD2)
    EmitSoundOnLocationWithCaster(position, "Item.AutumnMage.Quake", caster)
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, explosionAOE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    if #enemies > 0 then
        for _, enemy in pairs(enemies) do
            Filters:ApplyItemDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, ability, RPC_ELEMENT_EARTH, RPC_ELEMENT_NONE)
            Filters:ApplyStun(caster, 2, enemy)
        end
    end
end

function Filters:BlueRainRCast(caster)
    local ability = caster.equipped_gear[RPC_GEAR_SLOT_GLOVES]
    if ability:GetGemValue("amethyst") > 0 then
        local damage_mult = ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_BLUE_RAIN_GAUNTLET_GEM_AMETHYST)/100
        local fv = caster:GetForwardVector()
        EmitSoundOn("RPCItem.BlueRain", caster)
        for i = 1, ITEM_RPC_BLUE_RAIN_GAUNTLET_AMETHYST_COUNT, 1 do
            local endFV = WallPhysics:rotateVector(fv, 2*math.pi*i/ITEM_RPC_BLUE_RAIN_GAUNTLET_AMETHYST_COUNT)
            Filters:BlueRainLance(caster, ability, endFV, damage_mult)
        end
    end
end

function Filters:BlueRainLance(caster, ability, endFV, damage_mult)
    local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * ((ITEM_RPC_BLUE_RAIN_GAUNTLET_DMG_PER_ATT + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_BLUE_RAIN_GAUNTLET_GEM_SAPPHIRE))/100)
    damage = damage*damage_mult
    local range = ITEM_RPC_BLUE_RAIN_GAUNTLET_RANGE
    local enemies = FindUnitsInLine(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster:GetAbsOrigin() + endFV * range, caster, 240, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
    if #enemies > 0 then
        --print("ENEMIES??")
        for _, enemy in pairs(enemies) do
            if not enemy.dummy then
                Filters:ApplyItemDamage(enemy, caster, damage, DAMAGE_TYPE_PURE, ability, RPC_ELEMENT_WATER, RPC_ELEMENT_NONE)
            end
        end
    end
    local bluerain_dummy = CreateUnitByName("npc_flying_dummy_vision", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
    bluerain_dummy:AddAbility("dummy_unit")
    bluerain_dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
    bluerain_dummy:SetForwardVector(endFV)
    local particleName = "particles/roshpit/items/blue_rain_gauntlet.vpcf"
    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN, bluerain_dummy)
    ParticleManager:SetParticleControl(0, pfx, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(1, pfx, caster:GetAbsOrigin() + endFV * range)
    ParticleManager:SetParticleControl(2, pfx, caster:GetAbsOrigin() + endFV * range)
    Timers:CreateTimer(2, function()
        UTIL_Remove(bluerain_dummy)
        ParticleManager:DestroyParticle(pfx, false)
    end)
end

function Filters:EternalEssenceGauntlet(hero, healAmount)
    local eternal_essence_gauntlet = hero.equipped_gear[RPC_GEAR_SLOT_GLOVES]
    healAmount = healAmount * (1 + eternal_essence_gauntlet:GetFinalGemPropertyValue("emerald", ITEM_RPC_ETERNAL_ESSENCE_GAUNTLET_GEM_EMERALD)/100)


    if not eternal_essence_gauntlet.last_heal then
        eternal_essence_gauntlet.last_heal = 0
    end
    local heal_to_consider_for_eternal_essence_gauntlet = math.min(healAmount, hero:GetMaxHealth() - hero:GetHealth())
    --print(eternal_essence_gauntlet.last_heal)
    if heal_to_consider_for_eternal_essence_gauntlet > eternal_essence_gauntlet.last_heal then
        eternal_essence_gauntlet.last_heal = heal_to_consider_for_eternal_essence_gauntlet
        local attack_power_cap = hero:GetSpirit()*(ITEM_RPC_ETERNAL_ESSENCE_GAUNTLET_SPIRIT_CAP + eternal_essence_gauntlet:GetFinalGemPropertyValue("sapphire", ITEM_RPC_ETERNAL_ESSENCE_GAUNTLET_GEM_SAPPHIRE))
        local attack_power_bonus = math.min(heal_to_consider_for_eternal_essence_gauntlet*(ITEM_RPC_ETERNAL_ESSENCE_GAUNTLET_HEAL_TO_DMG_PCT/100), attack_power_cap)
        eternal_essence_gauntlet:ApplyDataDrivenModifier(hero.InventoryUnit, hero, "modifier_eternal_essence_gauntlet_buff", {duration = ITEM_RPC_ETERNAL_ESSENCE_GAUNTLET_DMG_DURATION})
        eternal_essence_gauntlet:ApplyDataDrivenModifier(hero.InventoryUnit, hero, "modifier_eternal_essence_attack_power", {duration = ITEM_RPC_ETERNAL_ESSENCE_GAUNTLET_DMG_DURATION})
        hero:SetModifierStackCount("modifier_eternal_essence_attack_power", hero.InventoryUnit, attack_power_bonus)
        CustomAbilities:QuickAttachParticle("particles/roshpit/items/eternal_essence_buff_apply_heal.vpcf", hero, 3)
    end
    return healAmount
end

function Filters:SweepingWindsStackChange(caster, ability, stack_change)
    local currentStacks = caster:GetModifierStackCount("modifier_sweeping_wind_stackable", caster.InventoryUnit)
    local newStacks = math.min(currentStacks + stack_change, ITEM_RPC_GLOVES_OF_SWEEPING_WIND_MAX_STACKS)
    if newStacks == 0 then
        caster:RemoveModifierByName("modifier_sweeping_wind_stackable")
    else
        local particleName = "particles/items2_fx/sweeping_winds_2.vpcf"
        ability:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_sweeping_wind_stackable", {duration = ITEM_RPC_GLOVES_OF_SWEEPING_WIND_DURATION})
        caster:SetModifierStackCount("modifier_sweeping_wind_stackable", caster.InventoryUnit, newStacks)
        if not ability.windParticle then
            ability.windParticle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
            ParticleManager:SetParticleControlEnt(ability.windParticle, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
            StartSoundEvent("Items.SweepingWind", caster)
        end
        ParticleManager:SetParticleControl(ability.windParticle, 3, Vector(newStacks * 50, newStacks * 50, newStacks * 50))
        if ability:GetGemValue("amethyst") > 0 then
            ability:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_sweeping_wind_stack_base_attack_damage", {duration = ITEM_RPC_GLOVES_OF_SWEEPING_WIND_DURATION})
            local damage_stacks = ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_GLOVES_OF_SWEEPING_WIND_GEM_AMETHYST2)*newStacks
            caster:SetModifierStackCount("modifier_sweeping_wind_stack_base_attack_damage", caster.InventoryUnit, damage_stacks)
        end
    end
end

function Filters:GoldbreakerMagicImmuneBreak(hero, target)
    local gauntlet = hero.equipped_gear[RPC_GEAR_SLOT_GLOVES]
    local damage = OverflowProtectedGetAverageTrueAttackDamage(hero) * (ITEM_RPC_GOLDBREAKER_GAUNTLET_DMG_ATTACK_PCT/100) + gauntlet:GetFinalGemPropertyValue("emerald", ITEM_RPC_GOLDBREAKER_GAUNTLET_GEM_EMERALD2)
    Filters:ApplyItemDamage(target, hero, damage, DAMAGE_TYPE_PURE, gauntlet, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
end

function Filters:GoldbreakerAbilityHit(caster, slot, target)
    if slot == BASE_ABILITY_W then
        if caster.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetGemValue("sapphire") > 0 then
            local proc = Filters:GetProc(caster, caster.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_GOLDBREAKER_GAUNTLET_GEM_SAPPHIRE2))
            if proc then
                caster.equipped_gear[RPC_GEAR_SLOT_GLOVES]:ApplyDataDrivenModifier(caster.InventoryUnit, target, "modifier_goldbreaker_effect", {duration = ITEM_RPC_GOLDBREAKER_GAUNTLET_DEBUFF_DURATION})
            end
        end
    elseif slot == BASE_ABILITY_R then
        if caster.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetGemValue("emerald") > 0 then
            local emerald_duration = caster.equipped_gear[RPC_GEAR_SLOT_GLOVES]:GetFinalGemPropertyValue("emerald", ITEM_RPC_GOLDBREAKER_GAUNTLET_GEM_EMERALD1)
            caster.equipped_gear[RPC_GEAR_SLOT_GLOVES]:ApplyDataDrivenModifier(caster.InventoryUnit, target, "modifier_goldbreaker_effect", {duration = emerald_duration})
        end
    end
end

function Filters:MordiggusEvent(hero, event_type)
    local mordiggus = hero.equipped_gear[RPC_GEAR_SLOT_GLOVES]
    local beginningHealth = hero:GetHealth()
    local minHealth = 1
    local drain = 0
    if event_type == "attack" then
        drain = hero:GetMaxHealth() * ITEM_RPC_MORDIGGUS_GAUNTLET_HP_DRAIN_PCT_ON_ATTACK / 100
    elseif event_type == "cast" then
        drain = hero:GetMaxHealth() * ITEM_RPC_MORDIGGUS_GAUNTLET_HP_DRAIN_PCT_ON_SPELL / 100
    end
    if mordiggus:GetGemValue("emerald") > 0 then
        drain = drain * (1 - mordiggus:GetFinalGemPropertyValue("emerald", ITEM_RPC_MORDIGGUS_GAUNTLET_GEM_EMERALD)/100)
    end

    if mordiggus:GetGemValue("amethyst") > 0 then
        minHealth = hero:GetMaxHealth() * (mordiggus:GetFinalGemPropertyValue("amethyst", ITEM_RPC_MORDIGGUS_GAUNTLET_GEM_AMETHYST)/100)
    end

    local newHealth = math.max(hero:GetHealth() - drain, minHealth)
    local actual_amount_drained = hero:GetHealth() - newHealth
    if newHealth < hero:GetHealth() then
        hero:SetHealth(newHealth)
        CustomAbilities:QuickAttachParticle("particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodbath_eztzhok_ember.vpcf", hero, 0.7)
    else
        actual_amount_drained = 0
    end
    if mordiggus:GetGemValue("sapphire") > 0 then
        local manaRestore = math.ceil(actual_amount_drained*(mordiggus:GetFinalGemPropertyValue("sapphire", ITEM_RPC_MORDIGGUS_GAUNTLET_GEM_SAPPHIRE)/100))
        if manaRestore > 0 then
            hero:GiveMana(manaRestore)
            PopupMana(hero, manaRestore)        
        end
    end
end

function Filters:MountainVambrace(hero, target, ability)
    EmitSoundOn("Hero_Sven.StormBoltImpact", target)
    local radius = ITEM_RPC_MOUNTAIN_VAMBRACES_STUN_RADIUS
    local damage = hero:GetStrength() * ITEM_RPC_MOUNTAIN_VAMBRACES_DAMAGE_PER_STR + ability:GetGemValue("emerald", ITEM_RPC_MOUNTAIN_VAMBRACES_GEM_EMERALD1) + ability:GetGemValue("amethyst", ITEM_RPC_MOUNTAIN_VAMBRACES_GEM_AMETHYST2)*hero:GetSpirit()
    local enemies = FindUnitsInRadius(hero:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    if #enemies > 0 then
        for _, enemy in pairs(enemies) do
            Filters:ApplyItemDamage(enemy, hero, damage, DAMAGE_TYPE_PHYSICAL, ability, RPC_ELEMENT_NORMAL, RPC_ELEMENT_EARTH)
            Filters:ApplyStun(hero, ITEM_RPC_MOUNTAIN_VAMBRACES_STUN_DURATION, enemy)
        end
    end
    local particleName = "particles/units/heroes/hero_sven/mountain_vambraces_storm_bolt_projectile_explosion.vpcf"
    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
    ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(pfx, 2, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(pfx, 3, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    Timers:CreateTimer(1.5, function()
        ParticleManager:DestroyParticle(pfx, false)
    end)
end

function Filters:RoyalWristguardTakeDamage(caster, hero, ability, damage)
    if damage >= 1 then
        ability:ApplyDataDrivenModifier(caster, hero, "modifier_royal_wristguards_stack_effect", {duration = ITEM_RPC_ROYAL_WRISTGUARDS_STACK_DURATION})
        local current_stack = hero:GetModifierStackCount("modifier_royal_wristguards_stack_effect", hero.InventoryUnit)
        local newStack = math.min(current_stack + 1, ITEM_RPC_ROYAL_WRISTGUARDS_CHARGE_CAP + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_ROYAL_WRISTGUARDS_GEM_RUBY))
        hero:SetModifierStackCount("modifier_royal_wristguards_stack_effect", hero.InventoryUnit, newStack)

        if ability:GetGemValue("sapphire") > 0 then
            local damage_stacks = newStack * ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_ROYAL_WRISTGUARDS_GEM_SAPPHIRE)
            ability:ApplyDataDrivenModifier(caster, hero, "modifier_royal_wristguards_sapphire", {duration = ITEM_RPC_ROYAL_WRISTGUARDS_STACK_DURATION})
            hero:SetModifierStackCount("modifier_royal_wristguards_sapphire", caster, damage_stacks)
        end
    end
end

function Filters:ShadowArmletTakeDamage(hero, damage)
    local caster = hero.InventoryUnit
    local ability = hero.equipped_gear[RPC_GEAR_SLOT_GLOVES]
    local proc = Filters:GetProc(hero, ITEM_RPC_SHADOW_ARMLET_INVIS_CHANCE)
    if proc then
        if not hero:HasModifier("modifier_invisibility_datadriven") then
			if not hero:HasModifier("modifier_shadowstep_invis_cooldown") then
				local invis_duration = ITEM_RPC_SHADOW_ARMLET_INVIS_DURATION + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_SHADOW_ARMLET_GEM_SAPPHIRE2)
				local pfx2 = CustomAbilities:QuickAttachParticle("particles/roshpit/conjuror/shadow_deity_cloak_of_shadows.vpcf", hero, 2)
				ParticleManager:SetParticleControl(pfx2, 1, Vector(200, 200, 200))
				ability:ApplyDataDrivenModifier(caster, hero, "modifier_invisibility_datadriven", {duration = invis_duration})
				hero:AddNewModifier(hero, ability, "modifier_persistent_invisibility", {duration = invis_duration})
				ability:ApplyDataDrivenModifier(caster, hero, "modifier_shadowstep_invis_cooldown", {duration = invis_duration+ITEM_RPC_SHADOW_ARMLET_INVIS_DURATION_CD})
			end
            if ability:GetGemValue("sapphire") > 0 then
                ability:ApplyDataDrivenModifier(caster, hero, "modifier_shadow_armlet_sapphire", {duration = invis_duration})
                local health_regen_stacks = ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_SHADOW_ARMLET_GEM_SAPPHIRE1)/0.1
                hero:SetModifierStackCount("modifier_shadow_armlet_sapphire", caster, health_regen_stacks)
            end
            if ability:GetGemValue("amethyst") > 0 then
                ability:ApplyDataDrivenModifier(caster, hero, "modifier_shadowstep_invis", {duration = invis_duration})
            end
        end
    end
    if ability:GetGemValue("ruby") > 0 then
        local proc = Filters:GetProc(hero, ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_SHADOW_ARMLET_GEM_RUBY))
        if proc then
            local heal = math.ceil(damage)
            Filters:ApplyHeal(hero, hero, heal, true, true)
            CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_huskar/call_of_shadow.vpcf", hero, 0.5)
        end
    end
end

function Filters:SilverspringWCast(caster)
    local silverspring_gloves = caster.equipped_gear[RPC_GEAR_SLOT_GLOVES]
    if silverspring_gloves:GetGemValue("sapphire") > 0 then
        if silverspring_gloves.puddle and IsValidEntity(silverspring_gloves.puddle) then
            silverspring_gloves.puddle:RemoveModifierByName("modifier_silverspring_puddle")
        end
        local puddle_thinker = CreateUnitByName("npc_dummy_unit", caster:GetAbsOrigin(), false, nil, nil, caster:GetTeamNumber())
        puddle_thinker:FindAbilityByName("dummy_unit"):SetLevel(1)

        puddle_thinker:SetDayTimeVisionRange(500)
        puddle_thinker:SetNightTimeVisionRange(500)

        local pfx = ParticleManager:CreateParticle("particles/roshpit/items/silverspring_puddle.vpcf", PATTACH_CUSTOMORIGIN, nil)
        ParticleManager:SetParticleControl(pfx, 0, puddle_thinker:GetAbsOrigin())
        puddle_thinker.pfx = pfx

        silverspring_gloves:ApplyDataDrivenModifier(caster, puddle_thinker, "modifier_silverspring_puddle", {duration = ITEM_RPC_SILVERSPRING_GLOVES_SAPPHIRE_DURATION})
        silverspring_gloves.puddle = puddle_thinker
    end
end

function Filters:SkulldiggerWraithBlast(caster, ability, hero, target)
    if not hero then
        return false
    end
    if not hero:HasModifier("modifier_skulldigger_hellfire_stacks") then
        return false
    end
    local currentStacks = hero:GetModifierStackCount("modifier_skulldigger_hellfire_stacks", caster)
    local stack_loss = 1
    if ability:GetGemValue("emerald") > 0 then
        local proc = Filters:GetProc(hero, ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_SKULLDIGGER_GAUNTLET_GEM_EMERALD1))
        if proc then
            stack_loss = 0
        end
    end
    local newStacks = currentStacks - stack_loss
    if newStacks == 0 then
        hero:RemoveModifierByName("modifier_skulldigger_hellfire_stacks")
    else
        hero:SetModifierStackCount("modifier_skulldigger_hellfire_stacks", caster, newStacks)
    end
    EmitSoundOn("RoshpitItem.SkulldiggerLaunch", hero)
    local info =
    {
        Target = target,
        Source = hero,
        Ability = ability,
        EffectName = "particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast.vpcf",
        StartPosition = "attach_hitloc",
        bDrawsOnMinimap = false,
        bDodgeable = false,
        bIsAttack = false,
        bVisibleToEnemies = true,
        bReplaceExisting = false,
        flExpireTime = GameRules:GetGameTime() + 4,
        bProvidesVision = true,
        iVisionRadius = 0,
        iMoveSpeed = 1000,
    iVisionTeamNumber = caster:GetTeamNumber()}
    projectile = ProjectileManager:CreateTrackingProjectile(info)

    if ability:GetGemValue("amethyst") > 0 then
        local damage_stacks = hero:GetModifierStackCount("modifier_skulldigger_hellfire_stacks", caster)*ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_SKULLDIGGER_GAUNTLET_GEM_AMETHYST2)
        if damage_stacks > 0 then
            hero:ApplyModifierAndSetStacks(ability, caster, "modifier_skulldigger_amethyst_damage", damage_stacks, 0)
        end
    end
end

function Filters:IncrementSkullDiggerStacks(caster, ability, hero)
    local currentStacks = hero:GetModifierStackCount("modifier_skulldigger_hellfire_stacks", caster)
    if currentStacks == 0 then
        ability:ApplyDataDrivenModifier(caster, hero, "modifier_skulldigger_hellfire_stacks", {})
    end
    local maxStacks = ITEM_RPC_SKULLDIGGER_GAUNTLET_MAX_STACKS + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_SKULLDIGGER_GAUNTLET_GEM_SAPPHIRE)
    local newStacks = math.min(currentStacks + 1, maxStacks)
    hero:SetModifierStackCount("modifier_skulldigger_hellfire_stacks", caster, newStacks)

    if ability:GetGemValue("amethyst") > 0 then
        local damage_stacks = hero:GetModifierStackCount("modifier_skulldigger_hellfire_stacks", caster)*ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_SKULLDIGGER_GAUNTLET_GEM_AMETHYST2)
        hero:ApplyModifierAndSetStacks(ability, caster, "modifier_skulldigger_amethyst_damage", damage_stacks, 0)
    end
end

function Filters:SpiritualEmpowermentStackUpdate(hero)
    local caster = hero.InventoryUnit
    local ability = hero.equipped_gear[RPC_GEAR_SLOT_GLOVES]
    local stacks = hero:GetModifierStackCount("modifier_spiritual_empowerment_stack", caster)
    if ability:GetGemValue("ruby") > 0 then
        local attack_power_stacks = (ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_SPIRITUAL_EMPOWERMENT_GLOVE_GEM_RUBY2)/0.1)*stacks
        ability:ApplyDataDrivenModifier(caster, hero, "modifier_spiritual_empowerment_ruby_attack_power", {})
        hero:SetModifierStackCount("modifier_spiritual_empowerment_ruby_attack_power", caster, attack_power_stacks)
    end
end

function Filters:AlaranaInit(caster, duration)
    EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "RPCItem.AlaranaIce", caster.InventoryUnit)
    caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_alarana_ice_freeze", {duration = duration})
    caster.equipped_gear[RPC_GEAR_SLOT_BOOTS].alaranaIce = caster:GetMaxHealth() * (ITEM_RPC_ALARANAS_ICE_BOOT_DAMAGE_BLOCK_THRESHOLD_OF_MAX_HP/100)
    if caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetGemValue("amethyst") > 0 then
        caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_alarana_ice_freeze_amethyst_hp_regen", {duration = duration})
        local health_regen_stacks = caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_ALARANAS_ICE_BOOT_GEM_AMETHYST)/0.1
        caster:SetModifierStackCount("modifier_alarana_ice_freeze_amethyst_hp_regen", caster.InventoryUnit, health_regen_stacks)
    end
end

function Filters:ApplyBlueDragonGreavesBuff(caster, base_duration)
    --print("BLUE DRAGON")
    local dragon_effect = caster:FindModifierByName("modifier_blue_dragon_greaves_effect")
    if dragon_effect and dragon_effect:GetRemainingTime() > base_duration then
        return false
    end
    local dragon_greaves = caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]
    local buff_duration = base_duration * (1 + dragon_greaves:GetFinalGemPropertyValue("sapphire", ITEM_RPC_BLUE_DRAGON_GREAVES_GEM_SAPPHIRE1)/100)
    
    dragon_greaves:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_blue_dragon_greaves_effect", {duration = buff_duration})
    EmitSoundOn("Items.BlueDragonGreaves", caster)
    if dragon_greaves:GetGemValue("ruby") > 0 then
        dragon_greaves:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_blue_dragon_greaves_base_attack", {duration = buff_duration})
        local atk_dmg_stacks = dragon_greaves:GetFinalGemPropertyValue("ruby", ITEM_RPC_BLUE_DRAGON_GREAVES_GEM_RUBY2)
        caster:SetModifierStackCount("modifier_blue_dragon_greaves_base_attack", caster.InventoryUnit, atk_dmg_stacks)
    end
    if dragon_greaves:GetGemValue("sapphire") > 0 then
        dragon_greaves:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_blue_dragon_greaves_as", {duration = buff_duration})
        local as_stacks = dragon_greaves:GetFinalGemPropertyValue("sapphire", ITEM_RPC_BLUE_DRAGON_GREAVES_GEM_SAPPHIRE2)
        caster:SetModifierStackCount("modifier_blue_dragon_greaves_as", caster.InventoryUnit, as_stacks)
    end
end

function Filters:CrystallineWCast(caster)
    local slippers = caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]
    if slippers:GetGemValue("sapphire") > 0 then
        slippers:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_crystalline_sapphire_root", {duration = ITEM_RPC_CRYSTALLINE_SLIPPERS_SAPPHIRE_ROOT_DURATION})
    end
end

function Filters:FalconBoot(caster)
    --print("falcon boot?")
    if not caster:HasModifier("modifier_falcon_immune") then
        local ability = caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]
        ability.hero = caster
        local fv = caster:GetForwardVector()
        local point = caster:GetAbsOrigin() + fv * 120
        local speed = 600 + ability:GetFinalGemPropertyValue("amethyst", ITEM_RPC_FALCON_BOOTS_GEM_AMETHYST1)
        Filters:FalconProjectile(caster, fv, point, speed)
        Filters:FalconProjectile(caster, fv, point + WallPhysics:rotateVector(fv, math.pi / 2) * 90 - fv * 80, speed)
        Filters:FalconProjectile(caster, fv, point - WallPhysics:rotateVector(fv, math.pi / 2) * 90 - fv * 80, speed)
        Filters:FalconProjectile(caster, fv, point + WallPhysics:rotateVector(fv, math.pi / 2) * 180 - fv * 160, speed)
        Filters:FalconProjectile(caster, fv, point - WallPhysics:rotateVector(fv, math.pi / 2) * 180 - fv * 160, speed)
        EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hero_SkywrathMage.ArcaneBolt.Cast", caster)
        
        ability.liftedTargetsTable = {}
        local transportLocation = caster:GetAbsOrigin() + fv * 1400
        ability.transportLocation = transportLocation
        local travel_duration = 2.25
        travel_duration = travel_duration * (1 - ability:GetGemValue("amethyst")/10)
        ability.travel_delay = travel_duration
        local targetPosition = WallPhysics:WallSearch(caster:GetAbsOrigin(), transportLocation, caster)
        ability:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_falcon_immune", {duration = travel_duration + 0.05})
        Timers:CreateTimer(travel_duration - 0.25, function()
            if ability.liftedTargetsTable then
                for i = 1, #ability.liftedTargetsTable, 1 do
                    local target = ability.liftedTargetsTable[i]
                    FindClearSpaceForUnit(target, targetPosition + RandomVector(RandomInt(20, 100)), false)
                    Filters:FalconAmethystDamage(caster, target)
                end
            end
        end)
        Timers:CreateTimer(travel_duration, function()
            --print("TIME 2.25!")
            if #ability.liftedTargetsTable > 0 then
            end
            --print(#ability.liftedTargetsTable)
            for i = 1, #ability.liftedTargetsTable, 1 do
                local target = ability.liftedTargetsTable[i]
                target:RemoveModifierByName("modifier_falcon_out")
                --print("CLEAR SPACE!!"..i)
                if not target:HasModifier("modifier_falcon_immune") then
                    local freeze_duration = ITEM_RPC_FALCON_BOOTS_FREEZE_DURATION + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_FALCON_BOOTS_GEM_SAPPHIRE2)
                    Timers:CreateTimer(0.05, function()
                        ability:ApplyDataDrivenModifier(caster.InventoryUnit, target, "modifier_falcon_freeze", {duration = freeze_duration})
                    end)
                end
                ability:ApplyDataDrivenModifier(caster.InventoryUnit, target, "modifier_falcon_immune", {duration = 5})
                
            end

        end)
    end
end

function Filters:FalconAmethystDamage(caster, target)
    local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_FALCON_BOOTS_GEM_AMETHYST2)/100
    Filters:ApplyItemDamage(target, caster, damage, DAMAGE_TYPE_PURE, caster.equipped_gear[RPC_GEAR_SLOT_BOOTS], RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
end

function Filters:FalconProjectile(caster, fv, projectileOrigin, speed)
    local projectileParticle = "particles/units/heroes/hero_skywrath_mage/falcon_boot_arcane_bolt.vpcf"

    local start_radius = 120
    local end_radius = 120
    local range = 1400
    local info =
    {
        Ability = caster.equipped_gear[RPC_GEAR_SLOT_BOOTS],
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

function Filters:LavaWalkersBaseAbilityHitChance(caster, victim, slot)
    if slot == BASE_ABILITY_Q or slot == BASE_ABILITY_E or slot == BASE_ABILITY_R then
        local proc = Filters:GetProc(caster, caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_FIRE_WALKERS_GEM_AMETHYST))
        if proc then
            Filters:FireWalkersCreateLavaAtPoint(caster.InventoryUnit, caster.equipped_gear[RPC_GEAR_SLOT_BOOTS], caster, victim:GetAbsOrigin())
        end
    end
end

function Filters:FireWalkersCreateLavaAtPoint(caster, ability, hero, position)
    local create_lava = true
    local allies = Entities:FindAllByClassnameWithin("npc_dota_base_additive", position, 40)
    if #allies > 0 then
        for _, ally in pairs(allies) do
            if ally:HasModifier("modifier_fire_walkers_thinker") then
                create_lava = false
            end
        end
    end
    if create_lava then
        local lava_thinker = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, hero:GetTeamNumber())
        lava_thinker:FindAbilityByName("dummy_unit"):SetLevel(1)

        lava_thinker:SetDayTimeVisionRange(0)
        lava_thinker:SetNightTimeVisionRange(0)

        local pfx = ParticleManager:CreateParticle("particles/econ/courier/courier_roshan_lava/courier_roshan_lava.vpcf", PATTACH_CUSTOMORIGIN, nil)
        ParticleManager:SetParticleControl(pfx, 0, lava_thinker:GetAbsOrigin())
        ParticleManager:SetParticleControl(pfx, 1, Vector(110, 1, 1))
        ParticleManager:SetParticleControl(pfx, 15, Vector(255, 160, 160))
        ParticleManager:SetParticleControl(pfx, 16, Vector(1, 0, 0))
        lava_thinker.pfx = pfx

        local puddle_duration = ITEM_RPC_FIRE_WALKERS_DURATION + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_FIRE_WALKERS_GEM_EMERALD1)
        ability:ApplyDataDrivenModifier(caster, lava_thinker, "modifier_fire_walkers_thinker", {duration = puddle_duration})
        -- if #ability.lava_table > max_flames then
        --  ability.lava_table[1]:RemoveModifierByName("modifier_fire_walkers_thinker")
        -- end
        -- reindex_fire_walkers_table(ability)
    end
end

function Filters:InitGravelFootEffect(caster, ability, hero, duration)
    EmitSoundOn("RPCItems.Gravelfoot.Dispel", hero)
    local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/winterblight/gravelfoot_dispel.vpcf", hero, 1.2)
    ability:ApplyDataDrivenModifier(caster, hero, "modifier_gravelfoot_buff", {duration = duration})
    local ms_loss = ITEM_RPC_GRAVELFOOT_TREADS_SELF_SLOW - ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_GRAVELFOOT_TREADS_GEM_EMERALD)
    --print(ms_loss)
    ability:ApplyDataDrivenModifier(caster, hero, "modifier_gravelfoot_slow", {duration = duration})
    hero:SetModifierStackCount("modifier_gravelfoot_slow", caster, ms_loss)
end

function Filters:GuardianGreavesCast(hero, ability)
    if not hero:HasModifier("modifier_guardian_greaves_cooldown") then
        local healthRestore = hero:GetStrength() * ITEM_RPC_GUARDIAN_GREAVES_HEAL_X_STRENGTH
        local manaRestore = hero:GetIntellect() * ITEM_RPC_GUARDIAN_GREAVES_HEAL_X_INTELLIGENCE
        local particleName = "particles/items3_fx/warmage.vpcf"
        local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, hero)
        ParticleManager:SetParticleControlEnt(pfx, 0, hero, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)
        Timers:CreateTimer(3, function()
            ParticleManager:DestroyParticle(pfx, false)
        end)
        EmitSoundOn("RoshpitItem.GuardianGreaves", hero)
        local allies = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin(), nil, ITEM_RPC_GUARDIAN_GREAVES_RADIUS , DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
        if #allies > 0 then
            for _, ally in pairs(allies) do
                guardian_heal_ally(ally, healthRestore, manaRestore, ability, hero)
            end
        end
        ability:ApplyDataDrivenModifier(hero.InventoryUnit, hero, "modifier_guardian_greaves_cooldown", {duration = ITEM_RPC_GUARDIAN_GREAVES_COOLDOWN})
    end

end

function guardian_heal_ally(ally, healthRestore, manaRestore, ability, hero)
    local particleName = "particles/items3_fx/warmage_recipient.vpcf"
    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, ally)
    ParticleManager:SetParticleControlEnt(pfx, 0, ally, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", ally:GetAbsOrigin(), true)
    Timers:CreateTimer(3, function()
        ParticleManager:DestroyParticle(pfx, false)
    end)
    -- EmitSoundOn("Item.GuardianGreaves", ally)
    Filters:ApplyHeal(hero, ally, healthRestore, true, true)
    Timers:CreateTimer(0.1, function()
        PopupMana(ally, manaRestore)
    end)
    ally:GiveMana(manaRestore)
    if ability:GetGemValue("emerald") > 0 or ability:GetGemValue("amethyst") > 0 then
        ability:ApplyDataDrivenModifier(hero.InventoryUnit, ally, "modifier_guardian_greaves_shield", {duration = ITEM_RPC_GUARDIAN_GREAVES_GEM_BUFF_DURATION})
    end
end

function Filters:MoonTechRunners(caster)
    local ability = caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]
    local hero = caster
    local caster = hero.InventoryUnit
    local position = hero:GetAbsOrigin()
    local moon_tech_thinker = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, hero:GetTeamNumber())
    moon_tech_thinker:FindAbilityByName("dummy_unit"):SetLevel(1)

    moon_tech_thinker:SetDayTimeVisionRange(ITEM_RPC_MOON_TECH_RUNNERS_RADIUS)
    moon_tech_thinker:SetNightTimeVisionRange(ITEM_RPC_MOON_TECH_RUNNERS_RADIUS)

    local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_riki/moon_techs.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(pfx, 0, moon_tech_thinker:GetAbsOrigin())
    ParticleManager:SetParticleControl(pfx, 1, Vector(500, 500, 500))
    ParticleManager:SetParticleControl(pfx, 15, Vector(255, 160, 160))
    ParticleManager:SetParticleControl(pfx, 16, Vector(1, 0, 0))
    moon_tech_thinker.pfx = pfx

    local moon_tech_duration = ITEM_RPC_MOON_TECH_RUNNERS_DURATION
    ability:ApplyDataDrivenModifier(caster, moon_tech_thinker, "modifier_moon_tech_thinker", {duration = moon_tech_duration})
    if not ability.moon_tech_thinker_table then
        ability.moon_tech_thinker_table = {}
    end
    table.insert(ability.moon_tech_thinker_table, moon_tech_thinker)
    Filters:ReindexMoonTechThinkerTable(ability)
end

function Filters:ReindexMoonTechThinkerTable(ability)
    local new_moon_thinker_table = {}
    for i = 1, #ability.moon_tech_thinker_table, 1 do
        if ability.moon_tech_thinker_table[i] and IsValidEntity(ability.moon_tech_thinker_table[i]) and ability.moon_tech_thinker_table[i]:HasModifier("modifier_moon_tech_thinker") then
            table.insert(new_moon_thinker_table, ability.moon_tech_thinker_table[i])
        end
    end
    ability.moon_tech_thinker_table = new_moon_thinker_table
end

function Filters:NeptuneECast(caster)
    local neptunes = caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]
    if neptunes:GetGemValue("emerald") > 0 then
        if neptunes.puddle and IsValidEntity(neptunes.puddle) then
            neptunes.puddle:RemoveModifierByName("modifier_neptune_puddle")
        end
        local puddle_thinker = CreateUnitByName("npc_dummy_unit", caster:GetAbsOrigin(), false, nil, nil, caster:GetTeamNumber())
        puddle_thinker:FindAbilityByName("dummy_unit"):SetLevel(1)

        puddle_thinker:SetDayTimeVisionRange(500)
        puddle_thinker:SetNightTimeVisionRange(500)

        local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_slardar/slardar_water_puddle.vpcf", PATTACH_CUSTOMORIGIN, nil)
        ParticleManager:SetParticleControl(pfx, 0, puddle_thinker:GetAbsOrigin())
        puddle_thinker.pfx = pfx

        neptunes:ApplyDataDrivenModifier(caster.InventoryUnit, puddle_thinker, "modifier_neptune_puddle", {duration = ITEM_RPC_NEPTUNES_WATER_GLIDERS_EMERALD_DURATION})
        neptunes.puddle = puddle_thinker
    end
end

function Filters:NeptuneWCast(caster)
    local neptunes = caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]
    if neptunes:GetGemValue("sapphire") > 0 and Filters:IsTouchingGround(caster) then
        if not caster:HasModifier("modifier_neptune_sapphire_blast_cd") then
            local pfx = ParticleManager:CreateParticle("particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf", PATTACH_CUSTOMORIGIN, caster)
            ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
            Timers:CreateTimer(2, function()
                ParticleManager:DestroyParticle(pfx, false)
            end)
            local cooldown = neptunes:GetFinalGemPropertyValue("sapphire", ITEM_RPC_NEPTUNES_WATER_GLIDERS_GEM_SAPPHIRE1)
            if cooldown > 0 then
                neptunes:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_neptune_sapphire_blast_cd", {duration = cooldown})
            end
            neptunes:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_neptune_sapphire_blasting", {duration = 5})
            neptunes.blast_force = ITEM_RPC_NEPTUNES_WATER_GLIDERS_SAPPHIRE_JUMP_HEIGHT
            neptunes.forward_force = neptunes.slideSpeed*4
            neptunes.blast_direction = caster:GetForwardVector()
            EmitSoundOn("RPCItems.Neptunes.SapphireBlast", caster)
        end
    end
end

function Filters:PegasusWCast(caster)
    local pegasus_boots = caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]
    if pegasus_boots:GetGemValue("sapphire") > 0 then
        if not caster:HasModifier("modifier_pegasus_wing_dash_cd") then
            StartAnimation(caster, {duration = 0.8, activity = ACT_DOTA_FLAIL, rate = 1.0, translate="forcestaff_friendly"})
            pegasus_boots.forwardVec = caster:GetForwardVector()

            Timers:CreateTimer(0.1, function()
                EmitSoundOn("RPCItems.PegasusBoots.SapphireDash", caster)
            end)
            local dash_duration = 0.35
            caster:RemoveModifierByName("modifier_pegasus_wing_dash")
            pegasus_boots:ApplyDataDrivenModifier(caster, caster, "modifier_pegasus_wing_dash", {duration = dash_duration})

            pegasus_boots:ApplyDataDrivenModifier(caster, caster, "modifier_pegasus_wing_dash_cd", {duration = pegasus_boots:GetFinalGemPropertyValue("sapphire", ITEM_RPC_PEGASUS_BOOTS_GEM_SAPPHIRE)})
        end
    end
end

function Filters:EternalForestStriders(attacker, victim, damage)
    local striders = attacker.equipped_gear[RPC_GEAR_SLOT_BOOTS]
    local chance = ITEM_RPC_RED_OCTOBER_BOOTS_PROC_CHANCE + striders:GetFinalGemPropertyValue("ruby", ITEM_RPC_RED_OCTOBER_BOOTS_GEM_RUBY1)
    local proc = Filters:GetProc(attacker, chance)
    if proc then
        damage = damage * ITEM_RPC_RED_OCTOBER_BOOTS_PROC_DAMAGE/100 + striders:GetFinalGemPropertyValue("sapphire", ITEM_RPC_RED_OCTOBER_BOOTS_GEM_SAPPHIRE1)
        local target = victim
        local radius = ITEM_RPC_RED_OCTOBER_BOOTS_RADIUS + striders:GetFinalGemPropertyValue("sapphire", ITEM_RPC_RED_OCTOBER_BOOTS_GEM_SAPPHIRE2)
        local procs_per_second = ITEM_RPC_RED_OCTOBER_BOOTS_MAX_PROCS_PER_SECOND + striders:GetFinalGemPropertyValue("ruby", ITEM_RPC_RED_OCTOBER_BOOTS_GEM_RUBY2)
        local limitKey = attacker:GetPlayerOwnerID() .. '_eternal_forest_striders'
        Util.Common:LimitPerTime(procs_per_second, 1, limitKey, function()
            local particleNameS = "particles/roshpit/items/eternal_forest_striders.vpcf"
            local particle2 = ParticleManager:CreateParticle(particleNameS, PATTACH_WORLDORIGIN, target)
            ParticleManager:SetParticleControl(particle2, 0, target:GetAbsOrigin())
            ParticleManager:SetParticleControl(particle2, 1, Vector(radius, 0, 0))
            -- ParticleManager:SetParticleControl(particle2, 5, target:GetAbsOrigin())
            Timers:CreateTimer(1.5, function()
                ParticleManager:DestroyParticle(particle2, false)
            end)

            EmitSoundOn("RPCItems.EternalForest.Trigger", target)
            local root_duration = striders:GetFinalGemPropertyValue("amethyst", ITEM_RPC_RED_OCTOBER_BOOTS_GEM_AMETHYST1)
            local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
            if #enemies > 0 then
                for _, enemy in pairs(enemies) do
                    if root_duration > 0 then
                        striders:ApplyDataDrivenModifier(attacker.InventoryUnit, enemy, "modifier_eternal_forest_strider_root", {duration = root_duration})
                    end
                    Filters:ApplyItemDamage(enemy, attacker, damage, DAMAGE_TYPE_MAGICAL, nil, RPC_ELEMENT_NATURE, RPC_ELEMENT_TIME)
                end
            end
        end)
        return true
    end
end

function Filters:SandstreamECast(caster)
    local sandstreams = caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]
    if not sandstreams.sandstorm_table then
        sandstreams.sandstorm_table = {}
    end
    local max_sandstreams = 1 + sandstreams:GetFinalGemPropertyValue("amethyst", ITEM_RPC_SANDSTREAM_SLIPPERS_GEM_AMETHYST1)
    if #sandstreams.sandstorm_table >= max_sandstreams then
        sandstreams.sandstorm_table[1]:RemoveModifierByName("modifier_sandstream_sandstorm_thinker")
    end
    local radius = ITEM_RPC_SANDSTREAM_RADIUS + sandstreams:GetFinalGemPropertyValue("amethyst", ITEM_RPC_SANDSTREAM_SLIPPERS_GEM_AMETHYST3)
    local allies = Entities:FindAllByClassnameWithin("npc_dota_base_additive", caster:GetAbsOrigin(), radius)
    if #allies > 0 then
        for _, ally in pairs(allies) do
            if ally:HasModifier("modifier_sandstream_sandstorm_thinker") then
                ally:RemoveModifierByName("modifier_sandstream_sandstorm_thinker")
            end
        end
    end
    local sandstorm_thinker = CreateUnitByName("npc_dummy_unit", caster:GetAbsOrigin(), false, nil, nil, caster:GetTeamNumber())
    sandstorm_thinker:FindAbilityByName("dummy_unit"):SetLevel(1)
    
    sandstorm_thinker:SetDayTimeVisionRange(radius)
    sandstorm_thinker:SetNightTimeVisionRange(radius)

    sandstorm_thinker.radius = radius
    local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_sandstorm.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(pfx, 0, sandstorm_thinker:GetAbsOrigin())
    ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
    EmitSoundOn("RPCItems.Sandstream.SandstormStart", sandstorm_thinker)
    StartSoundEvent("RPCItems.Sandstream.SandstormLP", sandstorm_thinker)
    sandstorm_thinker.pfx = pfx

    local sandstorm_duration = ITEM_RPC_SANDSTREAM_SANDSTREAM_DURATION + sandstreams:GetFinalGemPropertyValue("amethyst", ITEM_RPC_SANDSTREAM_SLIPPERS_GEM_AMETHYST2)
    sandstreams:ApplyDataDrivenModifier(caster.InventoryUnit, sandstorm_thinker, "modifier_sandstream_sandstorm_thinker", {duration = sandstorm_duration})
    table.insert(sandstreams.sandstorm_table, sandstorm_thinker)

end

function Filters:ReindexSandstreamsTable(ability)
    local new_sandstorm_table = {}
    for i = 1, #ability.sandstorm_table, 1 do
        if ability.sandstorm_table[i] and IsValidEntity(ability.sandstorm_table[i]) and ability.sandstorm_table[i]:IsAlive() and ability.sandstorm_table[i]:HasModifier("modifier_sandstream_sandstorm_thinker") then
            table.insert(new_sandstorm_table, ability.sandstorm_table[i])
        end
    end
    ability.sandstorm_table = new_sandstorm_table
end

function Filters:TimeWarp(caster)
    local ability = caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]
        if ability:GetGemValue("ruby") > 0 then
        local timeItem = ability
        if not caster:HasModifier("modifier_temporal_warp_cooldown") then
            ability:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_temporal_warp_cooldown", {duration = ITEM_RPC_TEMPORAL_WARP_BOOTS_RUBY_COOLDOWN})
            EmitSoundOn("RPCItem.TimeWarp.Start", caster)
            CustomAbilities:QuickAttachParticle("particles/roshpit/items/temporal_warp.vpcf", caster, 3)
            Timers:CreateTimer(0.3, function()
                CustomAbilities:QuickAttachParticle("particles/roshpit/items/temporal_warp.vpcf", caster, 3)
            end)
            local dataIndex = (ability.interval + 1) % ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_TEMPORAL_WARP_BOOTS_GEM_RUBY)*10
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
end


function Filters:HandleTemporalWarpBootsOrder(orderTable, unit)
    if unit:HasModifier("modifier_temporal_warp_boots_channeling") then
        unit:RemoveModifierByName("modifier_temporal_warp_boots_channeling")
        return false
    end
    if not unit.temporal_warp_boots then
        unit.temporal_warp_boots = {}
    end
    if orderTable.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION then
        if unit.temporal_warp_boots.last_clicked then
            if unit:IsStunned() or unit:IsFrozen() or unit:IsRooted() then
            else
                if (GameRules:GetGameTime() - unit.temporal_warp_boots.last_clicked < 0.3) and (WallPhysics:GetDistance2d(unit.temporal_warp_boots.last_position, Vector(orderTable.position_x, orderTable.position_y)) < 30) then
                    local fow_checker = CreateUnitByName("dummy_unit_vulnerable", Vector(orderTable.position_x, orderTable.position_y), true, nil, nil, DOTA_TEAM_NEUTRALS)
                    fow_checker:AddAbility("dummy_unit"):SetLevel(1)
                    local enemies = FindUnitsInRadius(unit:GetTeamNumber(), Vector(orderTable.position_x, orderTable.position_y), nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE+DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
                    local fow_visible = false
                    if #enemies > 0 then
                        fow_visible = true
                    end
                    UTIL_Remove(fow_checker)   
                    if fow_visible then                
                        unit:Stop()
                        if unit.temporal_warp_boots.pfx then
                            ParticleManager:DestroyParticle(unit.temporal_warp_boots.pfx, false)
                        end

                        unit.temporal_warp_boots.last_clicked = GameRules:GetGameTime()
                        unit.temporal_warp_boots.last_position = Vector(orderTable.position_x, orderTable.position_y)
                        
                        local channel_duration = ITEM_RPC_TEMPORAL_WARP_BOOTS_TELEPORT_TIME - unit.equipped_gear[RPC_GEAR_SLOT_BOOTS]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_TEMPORAL_WARP_BOOTS_GEM_SAPPHIRE)
                        unit.equipped_gear[RPC_GEAR_SLOT_BOOTS]:ApplyDataDrivenModifier(unit.InventoryUnit, unit, "modifier_temporal_warp_boots_channeling", {duration = channel_duration})
                        unit.equipped_gear[RPC_GEAR_SLOT_BOOTS]:ApplyDataDrivenModifier(unit.InventoryUnit, unit, "modifier_temporal_warp_boots_hidden_channel_checker", {duration = channel_duration + 0.1})

                        local teleportPosition = GetGroundPosition(unit.temporal_warp_boots.last_position, unit)
                        unit.temporal_warp_boots.pfx = ParticleManager:CreateParticle("particles/econ/items/tinker/boots_of_travel/teleport_end_bots.vpcf", PATTACH_CUSTOMORIGIN, unit)
                        ParticleManager:SetParticleControl(unit.temporal_warp_boots.pfx, 0, teleportPosition)
                        ParticleManager:SetParticleControl(unit.temporal_warp_boots.pfx, 4, Vector(1,1,1))
                        -- ParticleManager:SetParticleControl(unit.temporal_warp_boots.pfx, 5, teleportPosition)
                        unit.temporal_warp_boots.teleportPosition = teleportPosition
                        StartAnimation(unit, {duration = channel_duration, activity = ACT_DOTA_TELEPORT, rate = 1})   
                        StartSoundEvent("RPCItems.TemporalWarpBoots.TeleportLP", unit)
                    end
                end
            end
        end
        if unit:IsStunned() or unit:IsFrozen() or unit:IsRooted() then
        else
            unit.temporal_warp_boots.last_clicked = GameRules:GetGameTime()
            unit.temporal_warp_boots.last_position = Vector(orderTable.position_x, orderTable.position_y)
        end
    end
end

function Filters:TerrasicLavaBootsTouchLava(hero)
    hero.equipped_gear[RPC_GEAR_SLOT_BOOTS]:ApplyDataDrivenModifier(hero.InventoryUnit, hero, "modifier_rpc_terrasic_lava_boot_effect", {duration = ITEM_RPC_TERRASIC_LAVA_BOOTS_DURATION})
end

function Filters:TerrasicLavaBootsECast(caster)
    local terrasic_boots = caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]
    if terrasic_boots:GetGemValue("emerald") > 0 then
        EmitSoundOn("RPCItems.TerrasicLavaBoots.EmeraldFire", caster)
        local flame_count = terrasic_boots:GetFinalGemPropertyValue("emerald", ITEM_RPC_TERRASIC_LAVA_BOOTS_GEM_EMERALD1)
        for i = 1, flame_count, 1 do
            local rotation_mult = 0
            if flame_count == 2 then
                if i == 1 then 
                    rotation_mult = -2
                elseif i == 2 then
                    rotation_mult = 2
                end
            elseif flame_count == 3 then
                if i == 1 then 
                    rotation_mult = -2
                elseif i == 3 then
                    rotation_mult = 2
                end
            end
            local start_radius = 160
            local end_radius = 280
            local range = ITEM_RPC_TERRASIC_LAVA_BOOTS_EMERALD_FLAME_RANGE
            local speed = 1000
            local fv = WallPhysics:rotateVector(caster:GetForwardVector()*-1, 2*math.pi*rotation_mult/20)
            local projectileParticle = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf"
            local info =
            {
                Ability = terrasic_boots,
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
            projectile = ProjectileManager:CreateLinearProjectile(info)
        end
    end
    if terrasic_boots:GetGemValue("amethyst") > 0 then
        terrasic_boots:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_rpc_terrasic_lava_boot_effect", {duration = terrasic_boots:GetFinalGemPropertyValue("amethyst", ITEM_RPC_TERRASIC_LAVA_BOOTS_GEM_AMETHYST)})
    end
end

function Filters:TranquilBootsECast(caster)
    local tranquils = caster.equipped_gear[RPC_GEAR_SLOT_BOOTS]
    if tranquils:GetGemValue("amethyst") > 0 then
        tranquils:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_tranquil_boots_amethyst", {duration = ITEM_RPC_TRANQUIL_BOOTS_AMETHYST_DURATION})
        if not tranquils.pfx_table then
            tranquils.pfx_table = {}
            for i = 1, tranquils:GetGemValue("amethyst"), 1 do
                local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_enchantress/enchantress_natures_attendants_lvl2.vpcf", PATTACH_POINT_FOLLOW, caster)
                ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin() + Vector(0, 0, 40), true)
                ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin() + Vector(0, 0, 40), true)
                ParticleManager:SetParticleControlEnt(pfx, 3, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin() + Vector(0, 0, 40), true)
                ParticleManager:SetParticleControlEnt(pfx, 2, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin() + Vector(0, 0, 40), true)
                table.insert(tranquils.pfx_table, pfx)
            end
        end
    end
end

function Filters:CentaurHornsSapphireECast(caster)
	if caster.equipped_gear[RPC_GEAR_SLOT_HEAD]:GetGemValue("sapphire") > 0 then
		Filters:ApplyStun(caster, 0.1, caster)
	end
end

function Filters:GetNumberOfSkillsOnCooldownVoyager(hero)
    local count = 0
    for i = 1, 4, 1 do
        local cd_ability = Filters:SkillArgumentSlotToHeroAbility(hero, i)
        if cd_ability:GetCooldownTimeRemaining() > 0 then
            count = count + 1
        end
    end
    return count
end

function Filters:GetNumberOfSkillsNotOnCooldownVoyager(hero)
    local count = 0
    for i = 1, 4, 1 do
        local cd_ability = Filters:SkillArgumentSlotToHeroAbility(hero, i)
        if cd_ability:GetCooldownTimeRemaining() <= 0 then
            count = count + 1
        end
    end
    return count
end

function Filters:AnkhOfAncientsValidDeath(hero)
    local ankh = hero.equipped_gear[RPC_GEAR_SLOT_TRINKET]

    -- for i = 0, 3, 1 do
    --     local abilityIndex = i
    --     if i == 3 then
    --         abilityIndex = DOTA_R_SLOT
    --     end
    --     victim:GetAbilityByIndex(abilityIndex):EndCooldown()
    -- end
    
    local respawn_delay = ITEM_RPC_ANKH_OF_ANCIENTS_RESPAWN_DELAY - ankh:GetFinalGemPropertyValue("ruby", ITEM_RPC_ANKH_OF_THE_ANCIENTS_GEM_RUBY)
    ankh:ApplyDataDrivenModifier(hero.InventoryUnit, hero, "modifier_ankh_of_ancients_respawning", {duration = respawn_delay})
    hero:AddNoDraw()
    FindClearSpaceForUnit(hero, hero:GetAbsOrigin(), false)
    local particlePosition = hero:GetAbsOrigin()
    local pfx = CustomAbilities:QuickParticleAtPoint("particles/roshpit/items/ankh_of_ancients_respawn_timer.vpcf", particlePosition, respawn_delay)
    ParticleManager:SetParticleControl(pfx, 1, Vector(respawn_delay, respawn_delay, respawn_delay))
    ParticleManager:SetParticleControl(pfx, 12, Vector(10, 10, 10))
    ParticleManager:SetParticleControl(pfx, 15, Vector(1, 1, 1))
    StartSoundEvent("AnkhOfAncients.Death", hero)
end

function Filters:FortunesTalismanItemProc(caster)
    local talisman = caster.equipped_gear[RPC_GEAR_SLOT_TRINKET]
    if talisman:GetGemValue("ruby") > 0 then
        talisman:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_fortunes_talisman_ruby_buff", {duration = ITEM_RPC_FORTUNES_TALISMAN_OF_TRUTH_GEM_BUFF_DURATIONS})
    end
    if talisman:GetGemValue("emerald") > 0 then
        talisman:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_fortunes_talisman_emerald_buff", {duration = ITEM_RPC_FORTUNES_TALISMAN_OF_TRUTH_GEM_BUFF_DURATIONS})
    end
    if talisman:GetGemValue("sapphire") > 0 then
        talisman:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_fortunes_talisman_sapphire_buff", {duration = ITEM_RPC_FORTUNES_TALISMAN_OF_TRUTH_GEM_BUFF_DURATIONS})
    end
    if talisman:GetGemValue("amethyst") > 0 then
        talisman:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_fortunes_talisman_amethyst_buff", {duration = ITEM_RPC_FORTUNES_TALISMAN_OF_TRUTH_GEM_BUFF_DURATIONS})
    end
end

function Filters:StargazerSphere(unit, orderTable)
    if orderTable.order_type == DOTA_UNIT_ORDER_ATTACK_MOVE then  
        local targetVector = Vector(0, 0)   
        local isItem = false    
        if orderTable.order_type == DOTA_UNIT_ORDER_ATTACK_MOVE then    
            targetVector = Vector(orderTable.position_x, orderTable.position_y) 
        elseif orderTable.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then  
            targetVector = Vector(EntIndexToHScript(orderTable.entindex_target):GetAbsOrigin().x, EntIndexToHScript(orderTable.entindex_target):GetAbsOrigin().y)   
            if EntIndexToHScript(orderTable.entindex_target):GetClassname() == "dota_item_drop" then    
                isItem = true   
            end 
        end 
        local distance = WallPhysics:GetDistance2d(targetVector, unit:GetAbsOrigin())
        local max_distance = ITEM_RPC_STARGAZERS_SPHERE_MAX_CREATION_RANGE + unit.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("emerald", ITEM_RPC_STARGAZERS_SPHERE_GEM_EMERALD2)
        if distance >= max_distance then
            return false
        end
        if not isItem then  
            local sphere = unit.equipped_gear[RPC_GEAR_SLOT_TRINKET]
            if not sphere.cd then   
                sphere.cd = false   
            end 
            local cdCondition = not sphere.cd   
            if not sphere.sphereTable then  
                sphere.sphereTable = {} 
            end 
            if sphere.sphereTable.pfx and cdCondition then  
                ParticleManager:DestroyParticle(sphere.sphereTable.pfx, false)  
                sphere.sphereTable.pfx = false  
            end 
            if sphere.sphereTable.dummy then    
                --print(WallPhysics:GetDistance2d(sphere.sphereTable.dummy:GetAbsOrigin(), targetVector))   
                if WallPhysics:GetDistance2d(sphere.sphereTable.dummy:GetAbsOrigin(), targetVector) < 300 then  
                    if sphere:GetGemValue("ruby") > 0 then
                        if sphere.sphereTable.pfx then  
                            ParticleManager:DestroyParticle(sphere.sphereTable.pfx, false)  
                            sphere.sphereTable.pfx = false  
                        end 
                        EmitSoundOn("RPCItems.Stargazer.MeteorStart", sphere.sphereTable.dummy) 
                        local faceVector = ((sphere.sphereTable.position - unit:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized() 
                        unit:MoveToPosition(unit:GetAbsOrigin() + faceVector * 5)   
                        Timers:CreateTimer(0.03, function() unit:SetAbsOrigin(unit:GetAbsOrigin() - faceVector * 7) end)    
                        local pfx = ParticleManager:CreateParticle("particles/roshpit/items/stargazer_comet.vpcf", PATTACH_CUSTOMORIGIN, nil)   
                        ParticleManager:SetParticleControl(pfx, 0, sphere.sphereTable.dummy:GetAbsOrigin() + Vector(0, 0, 700)) 
                        ParticleManager:SetParticleControl(pfx, 1, sphere.sphereTable.dummy:GetAbsOrigin()) 
                        ParticleManager:SetParticleControl(pfx, 2, Vector(0.5, 0.5, 0.5))   
                        local meteorPosition = sphere.sphereTable.dummy:GetAbsOrigin()  
                        Timers:CreateTimer(0.5, function()  
                            EmitSoundOnLocationWithCaster(meteorPosition, "RPCItems.Stargazer.MeteorImpact", unit)  
                            local damage = OverflowProtectedGetAverageTrueAttackDamage(unit) * sphere:GetFinalGemPropertyValue("ruby", ITEM_RPC_STARGAZERS_SPHERE_GEM_RUBY1)/100 + sphere:GetFinalGemPropertyValue("sapphire", ITEM_RPC_STARGAZERS_SPHERE_GEM_SAPPHIRE2)
                            local stun_duration = sphere:GetFinalGemPropertyValue("ruby", ITEM_RPC_STARGAZERS_SPHERE_GEM_RUBY2)   
                            local enemies = FindUnitsInRadius(unit:GetTeamNumber(), meteorPosition, nil, 320, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)  
                            if #enemies > 0 then    
                                for _, enemy in pairs(enemies) do   
                                    Filters:ApplyStun(unit, stun_duration, enemy) 
                                    Filters:ApplyItemDamage(enemy, unit, damage, DAMAGE_TYPE_PURE, sphere, RPC_ELEMENT_COSMOS, RPC_ELEMENT_NONE)    
                                end 
                            end 
                        end)    
                        sphere.sphereTable.position = false 
                        UTIL_Remove(sphere.sphereTable.dummy)   
                        sphere.sphereTable.dummy = false    
                        return "meteor"  
                    end
                end 
                if cdCondition then 
                    UTIL_Remove(sphere.sphereTable.dummy)   
                    sphere.sphereTable.dummy = false    
                end 
            end 
            local creation_cd = ITEM_RPC_STARGAZERS_SPHERE_RING_CREATION_CD - sphere:GetFinalGemPropertyValue("emerald", ITEM_RPC_STARGAZERS_SPHERE_GEM_EMERALD1)
            if cdCondition then 
                sphere.sphereTable.position = GetGroundPosition(targetVector, unit) 
                local pfx = ParticleManager:CreateParticle("particles/roshpit/items/stargazer_ring_ring.vpcf", PATTACH_CUSTOMORIGIN, nil)   
                ParticleManager:SetParticleControl(pfx, 0, sphere.sphereTable.position) 
                sphere.sphereTable.pfx = pfx    
                local dummy = CreateUnitByName("npc_flying_dummy_vision", sphere.sphereTable.position, false, nil, nil, unit:GetTeamNumber())   
                dummy:FindAbilityByName("dummy_unit"):SetLevel(1)   
                sphere:ApplyDataDrivenModifier(unit.InventoryUnit, dummy, "modifier_stargazer_dummy_aura", {})  
                EmitSoundOn("RPCItems.Stargazer.Start", dummy)  
                dummy:SetNightTimeVisionRange(300)  
                dummy:SetDayTimeVisionRange(300)    
                sphere.sphereTable.dummy = dummy    
                sphere.cd = true    
                Timers:CreateTimer(creation_cd, function()    
                    sphere.cd = false   
                end)    
                local faceVector = ((sphere.sphereTable.position - unit:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized() 
                unit:MoveToPosition(unit:GetAbsOrigin() + faceVector * 5)   
                Timers:CreateTimer(0.03, function() unit:SetAbsOrigin(unit:GetAbsOrigin() - faceVector * 7) end)    
                return false    
            end 
        end 
    end 
end

function Filters:GengarCast(caster)
    if caster:HasModifier("modifier_torch_of_gengar_effect") then
        caster:RemoveModifierByName("modifier_torch_of_gengar_effect")
        local inactive_duration = ITEM_RPC_TORCH_OF_GENGAR_REMOVE_DURATION - caster.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("ruby", ITEM_RPC_TORCH_OF_GENGAR_GEM_RUBY)
        caster.equipped_gear[RPC_GEAR_SLOT_TRINKET]:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_torch_of_gengar_inactive", {duration = inactive_duration})
    end
end

function Filters:WorldTreeFlowerCacheTrigger(victim)
    CustomAbilities:QuickAttachParticle("particles/roshpit/draghor/mark_of_the_claw_heal.vpcf", victim, 3)
    victim:AddNoDraw()
    victim.equipped_gear[RPC_GEAR_SLOT_TRINKET]:ApplyDataDrivenModifier(victim.InventoryUnit, victim, "modifier_ankh_of_ancients_shield", {duration = ITEM_RPC_WORLD_TREES_FLOWER_CACHE_RESURRECTION_DELAY})
    local pfx = ParticleManager:CreateParticle("particles/econ/items/natures_prophet/natures_prophet_weapon_sufferwood/furion_teleport_end_sufferwood.vpcf", PATTACH_ABSORIGIN_FOLLOW, victim)
    ParticleManager:SetParticleControl(pfx, 0, victim:GetAbsOrigin())
    ParticleManager:SetParticleControl(pfx, 4, Vector(300, 0, 0))
    for i = 0, 12, 1 do
        ParticleManager:SetParticleControlEnt(pfx, i, victim, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", victim:GetAbsOrigin(), true)
    end
    EmitSoundOn("RPCItem.WorldTreeCache.Start", victim)
    Timers:CreateTimer(ITEM_RPC_WORLD_TREES_FLOWER_CACHE_RESURRECTION_DELAY, function()
        victim:RemoveNoDraw()
        EmitSoundOn("RPCItem.WorldTreeCache.End", victim)
        victim:SetHealth(victim:GetMaxHealth())
        ParticleManager:DestroyParticle(pfx, false)
        local cooldown = ITEM_RPC_WORLD_TREES_FLOWER_CACHE_COOLDOWN - victim.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("emerald", ITEM_RPC_WORLD_TREES_FLOWER_CACHE_GEM_EMERALD)
        local buff_duration = ITEM_RPC_WORLD_TREES_FLOWER_CACHE_BUFF_DURATION + victim.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_WORLD_TREES_FLOWER_CACHE_GEM_SAPPHIRE)
        victim.equipped_gear[RPC_GEAR_SLOT_TRINKET]:ApplyDataDrivenModifier(victim.InventoryUnit, victim, "modifier_world_tree_cache_cooldown", {duration = cooldown})
        victim.equipped_gear[RPC_GEAR_SLOT_TRINKET]:ApplyDataDrivenModifier(victim.InventoryUnit, victim, "modifier_world_tree_effect", {duration = buff_duration})
        CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf", victim, 1.2)
        local enemies = FindUnitsInRadius(victim:GetTeamNumber(), victim:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
        if #enemies > 0 then
            for _, enemy in pairs(enemies) do
                Filters:ApplyStun(victim, 0.6, enemy)
            end
        end
    end)
end

function Filters:RuptholdsTrigger(hero)
    local rupthold_helm = hero.equipped_gear[RPC_GEAR_SLOT_HEAD]
    local buff_duration = rupthold_helm:GetFinalGemPropertyValue("sapphire", ITEM_RPC_RUPTHOLDS_HELM_OF_GLUTTONY_SAPPHIRE)
    rupthold_helm:ApplyDataDrivenModifier(hero.InventoryUnit, hero, "modifier_rupthold_borrowed_time", {duration = buff_duration})
    rupthold_helm:ApplyDataDrivenModifier(hero.InventoryUnit, hero, "modifier_rupthold_borrowed_time_cooldown", {duration = ITEM_RPC_RUPTHOLDS_HELM_OF_GLUTTONY_SAPPHIRE_COOLDOWN})
    EmitSoundOn("RPCItems.Rupthold.SapphireBorrowedTime", hero)
    rupthold_helm.apply_time = GameRules:GetGameTime()
end

function Filters:CalculateTotalCastRangeBonus(hero)
    local range_bonus = 0
    if hero:HasModifier("modifier_vermillion_dream_robes") then
        range_bonus = range_bonus + ITEM_RPC_VERMILLION_DREAM_ROBES_CAST_RANGE_INCREASE
        range_bonus = range_bonus + hero.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue("ruby", ITEM_RPC_VERMILLION_DREAM_ROBES_GEM_RUBY)
    end
    if hero:GetUnitName() == "npc_dota_hero_grimstroke" then
        range_bonus = range_bonus + hero:GetRuneValue("q", 1)*RUBILASH_RUNE_Q1_CAST_RANGE
    end
	if caster:HasModifier("modifier_epoch_immortal_weapon_4") then
        range_bonus = range_bonus - EPOCH_IMMORTAL_WEAPON_4_RANGE_REDUCTION
    end
    return range_bonus
end

function Filters:WinterblightReincarnationDeath(hero, ability) 
    local respawn_delay = ability:GetSpecialValueFor("respawn_delay")
    ability:ApplyDataDrivenModifier(hero, hero, "modifier_winterblight_reincarnation_respawning", {duration = respawn_delay})
    hero:AddNoDraw()
    FindClearSpaceForUnit(hero, hero:GetAbsOrigin(), false)
    local particlePosition = hero:GetAbsOrigin()
    local pfx = CustomAbilities:QuickParticleAtPoint("particles/roshpit/items/ankh_of_ancients_respawn_timer.vpcf", particlePosition, respawn_delay)
    ParticleManager:SetParticleControl(pfx, 1, Vector(respawn_delay, respawn_delay, respawn_delay))
    ParticleManager:SetParticleControl(pfx, 12, Vector(10, 10, 10))
    ParticleManager:SetParticleControl(pfx, 15, Vector(1, 1, 1))
    StartSoundEvent("Winterblight.Reincarnation.Death", hero)
end

function Filters:PlagueEmperorBombSetup(hero, cast_type, optionalAbility)
    print(cast_type)
    if cast_type == "standard" then
        local range = ITEM_RPC_PLAGUE_EMPEROR_ARMOR_RANGE
        local enemies = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
        if #enemies > 0 then
            local target = enemies[1]
            local position = GetGroundPosition(target:GetAbsOrigin(), target)
            EmitSoundOn("RPCItems.PlagueEmperor.Throw", hero)
            Filters:PlagueEmperorBomb(hero, position)
        end
    elseif cast_type == BASE_ABILITY_Q then
        local limitKey = hero:GetEntityIndex().."_plague_emperor_q"
        Util.Common:LimitPerTime(ITEM_RPC_PLAGUE_EMPEROR_ARMOR_SAPPHIRE_MAX_TRIGGERS_PER_SECOND, 1, limitKey, function()
            EmitSoundOn("RPCItems.PlagueEmperor.Throw", hero)
            local range = ITEM_RPC_PLAGUE_EMPEROR_ARMOR_SAPPHIRE_DEFAULT_DISTANCE
            local enemies = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin(), nil, ITEM_RPC_PLAGUE_EMPEROR_ARMOR_RANGE*1.5, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
            if #enemies > 0 then
                range = math.max(ITEM_RPC_PLAGUE_EMPEROR_ARMOR_SAPPHIRE_MIN_THROW_DISTANCE, WallPhysics:GetDistance2d(enemies[1]:GetAbsOrigin(), hero:GetAbsOrigin()))
            end
            local projectile_count = hero.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_PLAGUE_EMPEROR_ARMOR_GEM_SAPPHIRE1)
            for i = 1, projectile_count, 1 do
                local bomb_fv = hero:GetForwardVector()
                if i == 2 then
                    bomb_fv = WallPhysics:rotateVector(hero:GetForwardVector(), 2*math.pi/12)
                elseif i == 3 then
                    bomb_fv = WallPhysics:rotateVector(hero:GetForwardVector(), -2*math.pi/12)
                end
                local bomb_position = hero:GetAbsOrigin() + bomb_fv*range
                Filters:PlagueEmperorBomb(hero, bomb_position)
            end
        end)
    elseif cast_type == BASE_ABILITY_R then
        local limitKey = hero:GetEntityIndex().."_plague_emperor_r"
        Util.Common:LimitPerTime(ITEM_RPC_PLAGUE_EMPEROR_ARMOR_SAPPHIRE_MAX_TRIGGERS_PER_SECOND, 1, limitKey, function()
            EmitSoundOn("RPCItems.PlagueEmperor.Throw", hero)
            local range = ITEM_RPC_PLAGUE_EMPEROR_ARMOR_SAPPHIRE_DEFAULT_DISTANCE
            local enemies = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin(), nil, ITEM_RPC_PLAGUE_EMPEROR_ARMOR_RANGE*1.5, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
            if #enemies > 0 then
                range = math.max(ITEM_RPC_PLAGUE_EMPEROR_ARMOR_SAPPHIRE_MIN_THROW_DISTANCE, WallPhysics:GetDistance2d(enemies[1]:GetAbsOrigin(), hero:GetAbsOrigin()))
            end        
            local projectile_count = hero.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_PLAGUE_EMPEROR_ARMOR_GEM_SAPPHIRE2)
            for i = 1, projectile_count, 1 do
                local bomb_fv = WallPhysics:rotateVector(hero:GetForwardVector(), 2*math.pi*i/projectile_count)
                local bomb_position = hero:GetAbsOrigin() + bomb_fv*range
                Filters:PlagueEmperorBomb(hero, bomb_position)
            end
        end)
    end
end

function Filters:PlagueEmperorBomb(hero, position)
    local ability = hero.equipped_gear[RPC_GEAR_SLOT_BODY]
    local projectile_speed = ITEM_RPC_PLAGUE_EMPEROR_ARMOR_PROJECTILE_SPEED + ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_PLAGUE_EMPEROR_ARMOR_GEM_RUBY2)
    local pfx = ParticleManager:CreateParticle("particles/roshpit/items/plague_emperor/plague_emperor_projectile.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(pfx, 0, hero:GetAbsOrigin()+Vector(0,0,70))
    ParticleManager:SetParticleControl(pfx, 1, position)
    ParticleManager:SetParticleControl(pfx, 2, Vector(projectile_speed, projectile_speed, projectile_speed))

    local travel_distance = WallPhysics:GetDistance2d(position, hero:GetAbsOrigin())
    local delay = travel_distance/projectile_speed
    local damage = OverflowProtectedGetAverageTrueAttackDamage(hero)*(ITEM_RPC_PLAGUE_EMPEROR_ARMOR_DMG_ATK_POWER/100)
    local radius = ITEM_RPC_PLAGUE_EMPEROR_ARMOR_DAMAGE_RADIUS
    Timers:CreateTimer(delay, function()
        ParticleManager:DestroyParticle(pfx, false)
        local pfx2 = CustomAbilities:QuickParticleAtPoint("particles/roshpit/items/plague_emperor/plague_emperor_impact_aoe.vpcf", position, 3)
        for i = 1, 5, 1 do
            ParticleManager:SetParticleControl(pfx2, i, Vector(radius, radius, radius))
        end
        local emerald_value = ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_PLAGUE_EMPEROR_ARMOR_GEM_EMERALD1)
        EmitSoundOnLocationWithCaster(position, "RPCItems.PlagueEmperor.Impact", hero)
        local impact_enemies = FindUnitsInRadius(hero:GetTeamNumber(), position, nil, ITEM_RPC_PLAGUE_EMPEROR_ARMOR_DAMAGE_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
        if #impact_enemies > 0 then
            for _, enemy in pairs(impact_enemies) do
                Filters:ApplyItemDamage(enemy, hero, damage, DAMAGE_TYPE_PHYSICAL, ability, RPC_ELEMENT_POISON, RPC_ELEMENT_NONE)
                if emerald_value > 0 then
                    ability:ApplyDataDrivenModifier(hero.InventoryUnit, enemy, "modifier_plague_emperor_armor_emerald", {duration = ITEM_RPC_PLAGUE_EMPEROR_ARMOR_EMERALD_DURATION})
                    ability:ApplyDataDrivenModifier(hero.InventoryUnit, enemy, "modifier_plague_emperor_emerald_attackspeed_loss", {})
                    enemy:SetModifierStackCount("modifier_plague_emperor_emerald_attackspeed_loss", hero.InventoryUnit, emerald_value)
                end
            end
        end
        if ability:GetGemValue("amethyst") > 0 then
            local poison_goo_thinker = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, hero:GetTeamNumber())
            poison_goo_thinker:FindAbilityByName("dummy_unit"):SetLevel(1)
            poison_goo_thinker:SetAbsOrigin(position)

            local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf", PATTACH_CUSTOMORIGIN, nil)
            ParticleManager:SetParticleControl(pfx, 0, poison_goo_thinker:GetAbsOrigin())
            ParticleManager:SetParticleControl(pfx, 1, Vector(EKKAN_ARCANA_W3A_RADIUS, 1, 1))
            ParticleManager:SetParticleControl(pfx, 15, Vector(40, 205, 40))
            ParticleManager:SetParticleControl(pfx, 16, Vector(1, 1, 1))
            poison_goo_thinker.pfx = pfx

            local goo_pile_duration = ITEM_RPC_PLAGUE_EMPEROR_ARMOR_AMETHYST_DURATION
            ability:ApplyDataDrivenModifier(hero.InventoryUnit, poison_goo_thinker, "modifier_plague_emperor_amethyst_aura", {duration = goo_pile_duration})
        end
    end)
end

function Filters:GloveOfTheHierophant(caster, target, healAmount)
    local ability = caster.equipped_gear[RPC_GEAR_SLOT_GLOVES]


    if ability:GetGemValue("ruby") > 0 then
        healAmount = healAmount * (1 + (ability:GetFinalGemPropertyValue("ruby", ITEM_RPC_GLOVE_OF_THE_HIEROPHANT_GEM_RUBY)/100))
    end
    local limitKey = caster:GetEntityIndex() .. '_hierophant_glove'
    Util.Common:LimitPerTime(ITEM_RPC_GLOVE_OF_THE_HIEROPHANT_TRIGGERS_PER_SECOND, 1, limitKey, function()
        local damage = healAmount * (ITEM_RPC_GLOVE_OF_THE_HIEROPHANT_HEAL_TO_DMG_PCT/100) + ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_GLOVE_OF_THE_HIEROPHANT_GEM_SAPPHIRE2)*caster:GetSpirit()
        local radius = ITEM_RPC_GLOVE_OF_THE_HIEROPHANT_DMG_RADIUS + ability:GetFinalGemPropertyValue("emerald", ITEM_RPC_GLOVE_OF_THE_HIEROPHANT_GEM_EMERALD)

        local pfx = CustomAbilities:QuickParticleAtPoint("particles/roshpit/items/glove_of_hierophant_aoe.vpcf", target:GetAbsOrigin(), 1)
        ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 2, radius/1.5))

        local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
        if #enemies > 0 then
            for _,enemy in pairs(enemies) do
                Filters:ApplyItemDamage(enemy, caster, damage, DAMAGE_TYPE_PURE, ability, RPC_ELEMENT_HOLY, RPC_ELEMENT_GHOST)
                if ability:GetGemValue("sapphire") > 0 then
                    ability:ApplyDataDrivenModifier(caster.InventoryUnit, enemy, "modifier_glove_of_the_hierophant_sapphire_blind", {duration = ITEM_RPC_GLOVE_OF_THE_HIEROPHANT_SAPPHIRE_DURATION})
                    enemy:SetModifierStackCount("modifier_glove_of_the_hierophant_sapphire_blind", enemy, ability:GetFinalGemPropertyValue("sapphire", ITEM_RPC_GLOVE_OF_THE_HIEROPHANT_GEM_SAPPHIRE1))
                end
            end
        end

    end)
    if ability:GetGemValue("amethyst") > 0 and target:IsHero() then
        ability:ApplyDataDrivenModifier(caster.InventoryUnit, target, "modifier_glove_of_the_hierophant_spirit_buff", {duration = ITEM_RPC_GLOVE_OF_THE_HIEROPHANT_AMETHYST_DURATION})
    end
    return healAmount
end

function Filters:AdjustCooldownForDotaCooldownRate(cooldown)
    return cooldown * DOTA_COOLDOWN_RATE_OUTSIDE_INVENTORY
end
