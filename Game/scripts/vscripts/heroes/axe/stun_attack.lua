function stun_attack_cast(event)
    local caster = event.caster
    local ability = event.ability
    local buffDuration = Filters:GetAdjustedBuffDuration(caster, event.buff_duration, false)
    Filters:CastSkillArguments(1, caster)
    if caster:HasModifier("modifier_axe_glyph_7_1") then
        ability:EndCooldown()
        ability:StartCooldown(1.5)
        buffDuration = 0
    else
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_stun_attack", {duration = buffDuration})
    end
    
end

function skull_bash_phaste_start(event)
    local caster = event.caster
    local player = caster:GetPlayerOwner()
    local ability = event.ability
    CustomGameEventManager:Send_ServerToPlayer(player, "flash_heal", {auriun = caster:GetEntityIndex()} )
end

function StunAttack( keys )
    local caster = keys.attacker
    local ability = keys.ability
    local hero = caster
    local abilityLevel = ability:GetLevel()

    local targetUnit = keys.target
    local position = targetUnit:GetAbsOrigin()
    local stun_duration = keys.duration
    local aoe_damage = keys.aoe_damage
    local q_4_level = caster:GetRuneValue("q", 4)
    if q_4_level > 0 then
        aoe_damage = aoe_damage + OverflowProtectedGetAverageTrueAttackDamage(caster)*0.06*q_4_level
    end
    if caster:HasModifier("modifier_axe_glyph_5_1") then
        aoe_damage = aoe_damage*3
        stun_duration = 0.03
    end
    local base_radius = rune_q_1(caster, keys.base_radius)

    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), targetUnit:GetAbsOrigin(), nil, base_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
    if #enemies > 0 then
        for _,enemy in pairs(enemies) do
            Filters:TakeArgumentsAndApplyDamage(enemy, caster, aoe_damage, DAMAGE_TYPE_PHYSICAL, 1, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
            Filters:ApplyStun(caster, stun_duration, enemy)
            --ability:ApplyDataDrivenModifier(caster, targetUnit, "modifier_stun_explosion", {})
        end
    end 
    EmitSoundOn("Hero_ElderTitan.EchoStomp", targetUnit)
end

function rune_q_1(caster, base_radius)
    local runeUnit = caster.runeUnit
    local ability = runeUnit:FindAbilityByName("axe_rune_q_1")
    local abilityLevel = ability:GetLevel()
    local bonusLevel = Runes:GetTotalBonus(runeUnit, "q_1")
    local totalLevel = abilityLevel + bonusLevel
    return 300 + totalLevel*20
end

function rune_q_3(event)
    local caster = event.caster
    local runeUnit = caster.runeUnit3
    local ability = runeUnit:FindAbilityByName("axe_rune_q_3")
    local abilityLevel = ability:GetLevel()
    local bonusLevel = Runes:GetTotalBonus(runeUnit, "q_3")
    local totalLevel = abilityLevel + bonusLevel
    local point = event.target_points[1]
    
        local jumpPosition = point
        local maxJumpDistance = 1200
        local jumpDistance = WallPhysics:GetDistance(jumpPosition*Vector(1,1,0),caster:GetAbsOrigin()*Vector(1,1,0))
        jumpDistance = math.min(jumpDistance, maxJumpDistance)
        local jumpFV = (jumpPosition*Vector(1,1,0)-caster:GetAbsOrigin()*Vector(1,1,0)):Normalized()
        caster:SetForwardVector(jumpFV)
        if totalLevel > 0 then
            caster.jumpEnd = "sunder"
        else
            caster.jumpEnd = ""
        end
        -- ability.duration = jumpDuration
        -- ability.q_3_level = totalLevel
        -- ability.thinks = 0
        -- ability.runeUnit = runeUnit
        -- ability.fv = caster:GetForwardVector()
        -- ability:ApplyDataDrivenModifier(runeUnit, caster, "modifier_axe_rune_q_3_jump", {duration = 10})
        print("C_A GO!")
        local zDifferential = GetGroundPosition(jumpPosition, caster).z - caster:GetAbsOrigin().z 
        local liftBonus = math.min(zDifferential/10, 10)
        liftBonus = math.max(liftBonus, 0)
        local propulsionBonus = math.max(jumpDistance/100,0)
        WallPhysics:JumpFixedDistanceWithBlocking(caster, jumpFV, jumpDistance, 10+liftBonus, 25+propulsionBonus, 1, 1.5)
        local animationTime = math.min(500/jumpDistance, 1)
        StartAnimation(caster, {duration=jumpDuration, activity=ACT_DOTA_CAST_ABILITY_4, rate=animationTime})
        EmitSoundOn("Hero_Axe.BerserkersCall.Item.Shoutmask", caster)
        EmitSoundOn("Hero_Axe.BerserkersCall.Item.Shoutmask", caster)

end

function jumpThink(event)
    local target = event.target
    local ability = event.ability
    local currentPos = target:GetAbsOrigin()
    local zFactor = 0
    local totalTicks = ability.duration/0.03
    print("IS THIS REAL LIFE??")
    if ability.thinks < (totalTicks/2) then
        zFactor = 16 - (ability.thinks*1)
        if zFactor < 3 then
            zFactor = 3
        end
    else
        zFactor = -ability.thinks*1.5/ability.duration+totalTicks/1.5/ability.duration
    end
    -- print("zFactor: "..zFactor)
    ability.thinks = ability.thinks + 1
    local newpos = currentPos + ability.fv*(15) + Vector(0,0,zFactor)
    local checkpos =  currentPos + caster:GetForwardVector()*(15)
    local obstruction = WallPhysics:FindNearestObstruction(checkpos*Vector(1,1,0))
    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, checkpos*Vector(1,1,0), target)
    if not blockUnit then
        if target:HasModifier("modifier_whirlwind") then
        else
            target:SetAbsOrigin(newpos)
            print("MOVE FORWARD")
        end
    else 
        target:SetAbsOrigin(currentPos+Vector(0,0,zFactor))
    end
    local skullBasher = target:FindAbilityByName("stun_attack")
    skullBasher:ApplyDataDrivenModifier(target, target, "modifier_stun_attack", {duration = skullBasher:GetDuration()})
    -- print("GroundPos Diff: "..newpos.z - GetGroundPosition(newpos, target).z)
    if (newpos.z - GetGroundPosition(newpos, target).z < 30) and zFactor < 0 then
        StartAnimation(target, {duration=0.3, activity=ACT_DOTA_CAST_ABILITY_4, rate=1.5})
    end
    if (newpos.z - GetGroundPosition(newpos, target).z < 18) and zFactor < 0 then
        target:RemoveModifierByName("modifier_axe_rune_q_3_jump")
        ability:ApplyDataDrivenModifier(ability.runeUnit, target, "modifier_axe_rune_q_3_jump_end", {duration = 0.3})
        FindClearSpaceForUnit(target, newpos, false)
    end
    if target:HasModifier("modifier_axe_rune_w_3_visible") then
        local runeUnit = target.runeUnit3
        local runeAbility = runeUnit:FindAbilityByName("axe_rune_w_3")
        runeAbility:ApplyDataDrivenModifier(runeUnit, target, "modifier_axe_rune_w_3_visible", {duration = 4})
        runeAbility:ApplyDataDrivenModifier(runeUnit, target, "modifier_axe_rune_w_3_invisible", {duration = 4})
    end
    if target:HasModifier("modifier_axe_rune_q_2_stacker") then
        local runeUnit = target.runeUnit2
        local runeAbility = runeUnit:FindAbilityByName("axe_rune_q_2")
        runeAbility:ApplyDataDrivenModifier(runeUnit, target, "modifier_axe_rune_q_2_stacker", {duration = 3})
    end
end

function jumpEnd(event)
    local hero = event.target
    local origin = hero:GetAbsOrigin() 
    local ability = event.ability
    -- StartAnimation(hero, {duration=0.5, activity=ACT_DOTA_CAST_ABILITY_4, rate=1.2})
      Timers:CreateTimer(0.2, -- Start this timer 10 game-time seconds later
      function()
        EmitSoundOn("Hero_ElderTitan.EchoStomp", hero)
        FindClearSpaceForUnit(hero, origin, true)
      end)

      particleName = "particles/units/heroes/hero_warlock/warlock_rain_of_chaos.vpcf"
      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
      local impactPoint = origin+ability.fv*160
      ParticleManager:SetParticleControl( particle1, 0, impactPoint )
      Timers:CreateTimer(3, 
      function()
        ParticleManager:DestroyParticle( particle1, false )
      end)
      jumpDamage(impactPoint, hero, ability)
end

function jumpDamage(impactPoint, caster, ability)
    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), impactPoint, nil, 420, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false )
    local damage = ability.q_3_level*750
    for _,enemy in pairs(enemies) do
        Filters:ApplyDamageBasic(enemy,caster,damage,DAMAGE_TYPE_PHYSICAL)
        -- ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL })
        Filters:ApplyStun(caster, 1.5, enemy)
    end
end