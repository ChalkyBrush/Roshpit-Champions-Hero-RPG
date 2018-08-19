require('heroes/axe/init')
local Shockwaves = require('heroes/axe/abilities/r/r2_shockwaves')
local function createTauntWaves(caster, ability, damage)
    for i = 0, R1_BUFF_DURATION, 1 do
        Timers:CreateTimer(0.2 + i, function()
            EmitSoundOn("RedGeneral.TauntWave", caster)
            local position = caster:GetAbsOrigin()
            local particleName = "particles/roshpit/red_general/berserker_timedialate.vpcf"
            local particle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
            local radius = 600
            ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
            ParticleManager:SetParticleControl(particle, 1, Vector(radius,radius,radius))
            Timers:CreateTimer(4, function()
                ParticleManager:DestroyParticle(particle, false)
            end)

            local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
            if #enemies > 0 then
                for _,enemy in pairs(enemies) do
                    if enemy:GetAttackCapability() == DOTA_UNIT_CAP_NO_ATTACK then
                    else
                        ability:ApplyDataDrivenModifier(caster, enemy, "modifier_axe_rune_r_1_taunt", {duration = 1.5})
                        enemy:MoveToTargetToAttack(caster)
                    end
                    Shockwaves.dealDamage(caster, enemy, ability, damage)
                end
            end
        end)
    end
end
local function cast(caster, ability, damage)
    if caster.r_1_level <= 0 then
        return
    end
    createTauntWaves(caster, ability, damage)
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_axe_rune_r_2_visible", {duration = R1_BUFF_DURATION})
end

function takeDamage(event)
    local caster = event.caster
    local ability = event.ability
    local attacker = event.attacker

    local start_radius = 140
    local end_radius = 140
    local range = 1500
    local speed = 1500
    if IsValidEntity(attacker) then
        if attacker == caster then
        else
            Events:CreateLightningBeamWithParticle(attacker:GetAbsOrigin()+Vector(0,0,60), caster:GetAbsOrigin()+Vector(0,0,140), "particles/econ/items/antimage/antimage_weapon_basher_ti5_gold/am_basher_lightning.vpcf", 1.5)

            local position = attacker:GetAbsOrigin()
            local radius = 260

            local damage = math.min(event.damage, 20 * caster:GetHealth());
            print("incoming damage = " .. event.damage)
            damage = damage * caster.r_1_level*RED_GENERAL_R1_DAMAGE
            if caster:HasModifier("modifier_axe_glyph_5_a") then
                damage = damage * (1 + T5A_AMPLIFY_PERCENT/100)
            end

            print("damage from r1 = " .. damage)
            Filters:TakeArgumentsAndApplyDamage(attacker, caster, damage, DAMAGE_TYPE_PHYSICAL, 4, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
        end
    end
end


local module = {}
module.cast = cast
return module