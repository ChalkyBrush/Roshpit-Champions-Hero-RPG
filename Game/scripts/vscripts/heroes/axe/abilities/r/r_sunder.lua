require('heroes/axe/init')
local Taunt = require('heroes/axe/abilities/r/r1_taunt')
local VisceralForce = require('heroes/axe/abilities/r/r3_visceral_force')
local WAmplify = require('heroes/axe/glyphs/t52_w_amplify')
local ImmortalWeapon3 = require('heroes/axe/weapons/immortal_weapon_3')

function startChannel(event)
    local caster = event.caster
    local ability = event.ability
    Helper.initializeAbilityRunes(caster, 'axe', 'd')
    VisceralForce.cast(caster, ability)
    ImmortalWeapon3.amplifyShieldsCount(caster)
end
local function createDunk(caster, damage)
    StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_CAST_ABILITY_4, rate=1.3})
    Timers:CreateTimer(0.2, function()
        local slamPoint = caster:GetAbsOrigin() + caster:GetForwardVector()*250
        EmitSoundOn("RedGeneral.Sunder", caster)

        local particleName = "particles/units/heroes/hero_earthshaker/earthshaker_echoslam_start.vpcf"
        local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
        ParticleManager:SetParticleControl( particle1, 0, slamPoint )
        Timers:CreateTimer(4,
            function()
                ParticleManager:DestroyParticle( particle1, false )
            end)

        local enemies = FindUnitsInRadius( caster:GetTeamNumber(), slamPoint, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
        if #enemies > 0 then
            for _,enemy in pairs(enemies) do
                Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
            end
        end
    end)
end
function cast(event)
    local caster = event.caster
    local ability = event.ability
    local damage = event.damage/100 * caster:GetHealth()
    WAmplify.applyBuff(caster)

    if caster:HasModifier("modifier_axe_glyph_5_a") then
        damage = damage * (1 + T5A_AMPLIFY_PERCENT/100)
    end

    Filters:CastSkillArguments(4, caster)

    local delay = Filters:GetDelayWithCastSpeed(caster, 0.35)
    local procsCount = 1
    if caster:HasModifier("modifier_axe_glyph_6_1") then
        procsCount = T61_DUNKS_COUNT
    end

    for i = 0, procsCount - 1, 1 do
        Timers:CreateTimer(i*delay,
            function()
                createDunk(caster, damage)
            end)
    end
    Timers:CreateTimer(procsCount*delay,
        function()
            Taunt.cast(caster, ability, damage)
        end)
end

local module = {}
module.createDunk = createDunk
return module