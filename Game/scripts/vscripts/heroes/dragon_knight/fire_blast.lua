function Vacuum( keys )
    local caster = keys.caster
    local target = keys.target
    local target_location = target:GetAbsOrigin()
    local ability = keys.ability
    local ability_level = ability:GetLevel() - 1
    ability.d_a_level = Runes:GetTotalRuneLevel(caster, 4, "d_a", "flamewaker")
    ability.d_a_ability = caster.runeUnit4:FindAbilityByName("flamewaker_rune_d_a")
    caster.d_d_level = Runes:GetTotalRuneLevel(caster, 4, "d_d", "flamewaker")
    -- Ability variables
    local duration = ability:GetLevelSpecialValueFor("light_strike_array_stun_duration", ability_level)
    local radius = ability:GetLevelSpecialValueFor("light_strike_array_aoe", ability_level)
    local vacuum_modifier = keys.vacuum_modifier
    local remaining_duration = duration - (GameRules:GetGameTime() - target.vacuum_start_time)

    -- Targeting variables
    local target_teams = ability:GetAbilityTargetTeam() 
    local target_types = ability:GetAbilityTargetType() 
    local target_flags = ability:GetAbilityTargetFlags() 

    local units = FindUnitsInRadius(caster:GetTeamNumber(), target_location, nil, radius, target_teams, target_types, target_flags, FIND_CLOSEST, false)
    -- Calculate the position of each found unit
    for _,unit in ipairs(units) do
        local unit_location = unit:GetAbsOrigin()
        local vector_distance = target_location - unit_location
        local distance = (vector_distance):Length2D()
        local direction = (vector_distance):Normalized()

        -- Check if its a new vacuum cast
        -- Set the new pull speed if it is
        if unit.vacuum_caster ~= target then
            unit.vacuum_caster = target
            -- The standard speed value is for 1 second durations so we have to calculate the difference
            -- with 1/duration
            unit.vacuum_caster.pull_speed = distance * 1/duration * 1/90
        end

        -- Apply the stun and no collision modifier then set the new location
        ability:ApplyDataDrivenModifier(caster, unit, vacuum_modifier, {duration = remaining_duration})
        if not unit.jumpLock and not unit.pushLock then
            unit:SetAbsOrigin(unit_location + direction * unit.vacuum_caster.pull_speed)
        end

    end

end


function VacuumStart( keys )
    local target = keys.target

    target.vacuum_start_time = GameRules:GetGameTime()
end

function cast_fire_blast(event)
    local caster = event.caster
    local ability = event.ability
    local target_location = event.target_points[1]
    local ability_level = ability:GetLevel()
    local radius = ability:GetLevelSpecialValueFor("light_strike_array_aoe", ability_level)
    Filters:CastSkillArguments(1, caster)
    if caster:HasModifier("modifier_flamewaker_glyph_2_1") then
        ability:EndCooldown()
        ability:StartCooldown(5)
    end
    if caster:HasModifier("modifier_flamewaker_glyph_3_1") then
        Timers:CreateTimer(0.05, function()
            glyph_3_1_start(caster, ability, target_location, radius)
        end)
    end
    rune_c_a_eruption(ability, caster, target_location, radius)
    rune_b_a(caster)
end

function rune_b_a(caster)
    local runeUnit = caster.runeUnit2
    local ability = runeUnit:FindAbilityByName("flamewaker_rune_b_a")
    local abilityLevel = ability:GetLevel()
    local bonusLevel = Runes:GetTotalBonus(runeUnit, "b_a")
    local totalLevel = abilityLevel + bonusLevel
    ability.b_a_level = totalLevel
    ability.heal = 0
end

function fire_blast_damage(event)
    local target = event.target
    local caster = event.caster
    local damage = event.damage
    local stun_duration = event.stun_duration
    if caster:HasModifier("modifier_flamewaker_immortal_weapon_3") then
        stun_duration = stun_duration + stun_duration*1.5
    end
    Filters:ApplyStun(caster, stun_duration, target)
    Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_FIRE, RPC_ELEMENT_EARTH)
end

function rune_c_a_eruption(ability, caster, point, radius)
    local runeUnit = caster.runeUnit3
    local runeAbility = runeUnit:FindAbilityByName("flamewaker_rune_c_a")
    local abilityLevel = runeAbility:GetLevel()
    local bonusLevel = Runes:GetTotalBonus(runeUnit, "c_a")
    local totalLevel = abilityLevel + bonusLevel
    if totalLevel > 0 then
        ability.c_a_damage = caster:GetStrength()*totalLevel*0.5 + totalLevel*800
        ability:ApplyDataDrivenThinker(caster, point, "modifier_eruption_thinker", {})
    else
        return 0
    end
end

function eruption_damage(event)
    local target = event.target
    local caster = event.caster
    local ability = event.ability
    if IsValidEntity(ability) then
        local damage = ability.c_a_damage
        Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
        local seismicFlare = caster:FindAbilityByName("fire_blast")
        CustomAbilities:QuickAttachParticle("particles/econ/courier/courier_greevil_orange/courier_greevil_orange_ambient_c.vpcf", target, 1)
        if seismicFlare.d_a_level > 0 then
            local d_a_duration = Filters:GetAdjustedBuffDuration(caster, 5, false)
            seismicFlare.d_a_ability:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_flamewaker_rune_d_a", {duration = d_a_duration})
            local current_stack = caster:GetModifierStackCount( "modifier_flamewaker_rune_d_a", seismicFlare.d_a_ability )
            local stackBonus = math.floor(damage*0.001*seismicFlare.d_a_level/10)
            caster:SetModifierStackCount("modifier_flamewaker_rune_d_a", seismicFlare.d_a_ability, current_stack+stackBonus )
        end
    end
end

function glyph_3_1_start(caster, ability, target_location, radius)
        caster.jumpEnd = true
        local casterOrigin = caster:GetAbsOrigin()
        local targetOrigin = target_location
        caster.flamewaker_d_b_target = false
        caster.flamewaker_3_1 = true
        local fv = (targetOrigin*Vector(1,1,0)-casterOrigin*Vector(1,1,0)):Normalized()
        local distance = WallPhysics:GetDistance(casterOrigin*Vector(1,1,0), targetOrigin*Vector(1,1,0))
        caster:SetForwardVector(fv)
        glyph_3_1_jump(caster, fv, distance, 35, 40, 1, 1)
        local animationTime = math.min(500/distance, 1)
        EmitSoundOn("dragon_knight_drag_anger_05", caster)
        StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_2, rate=animationTime, translate="iron"})
end

function glyph_3_1_jump(unit, forwardVector, distance, liftForce, propulsion, gravity, fallGravity)
    local gameMaster = Events.GameMaster
    local gameMasterAbil = gameMaster:FindAbilityByName("npc_abilities")
    local jumpingModifier = "modifier_jumping"
    gameMasterAbil:ApplyDataDrivenModifier(gameMaster, unit, "modifier_jumping", {duration = 5})
    local liftDuration = distance/propulsion/2
    local endLocation = unit:GetAbsOrigin()+forwardVector*distance
    for i = 1, liftDuration, 1 do
        Timers:CreateTimer(0.03*i, function()
            local currentPosition = unit:GetAbsOrigin()

            local newPosition = currentPosition+forwardVector*propulsion+Vector(0,0,liftForce-i*gravity)

            local obstruction = WallPhysics:FindNearestObstruction(newPosition*Vector(1,1,0))
            local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition*Vector(1,1,0), unit)
            if not blockUnit then
                unit:SetOrigin(newPosition)
            else 
                unit:SetOrigin(newPosition-forwardVector*propulsion)
            end
            
        end)
    end
    local fallLoop = 0
    Timers:CreateTimer(0.03*liftDuration+0.03, function()
        Timers:CreateTimer(0.03*fallLoop, function()
            fallLoop = fallLoop + 1
            local currentPosition = unit:GetAbsOrigin()
            local newPosition = currentPosition+forwardVector*propulsion-Vector(0,0,fallLoop*gravity*fallGravity)

            local obstruction = WallPhysics:FindNearestObstruction(newPosition*Vector(1,1,0))
            local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition*Vector(1,1,0), unit)
            if unit:HasModifier("modifier_jumping") then
                if not blockUnit then
                    unit:SetOrigin(newPosition)
                else 
                    unit:SetOrigin(newPosition-forwardVector*propulsion)
                end
            end
            if fallLoop > liftDuration then
                unit:RemoveModifierByName("modifier_jumping")
                FindClearSpaceForUnit(unit, newPosition, false)
                WallPhysics:UnitLand(unit)
            else
                if newPosition.x <= endLocation.x + 20 and newPosition.x >= endLocation.x-20 and newPosition.y <= endLocation.y+20 and newPosition.y >= endLocation.y-20 then
                    unit:RemoveModifierByName("modifier_jumping")
                    FindClearSpaceForUnit(unit, newPosition, false)
                    WallPhysics:UnitLand(unit)
                else
                    return 0.03
                end
            end
        end)
    end)
end