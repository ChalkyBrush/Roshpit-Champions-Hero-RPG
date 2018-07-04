require("heroes/legion_commander/grand_fissure")
require("heroes/legion_commander/hailstorm")

function begin_mystic_strike(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]

    local particleName = "particles/roshpit/mystic_assassin/mystic_strike.vpcf"
    if caster:HasModifier("modifier_mountain_protector_immortal_weapon_3") then
        local CD = ability:GetCooldownTimeRemaining()*0.35
        ability:EndCooldown()
        ability:StartCooldown(CD)
    end
    EmitSoundOn("MysticAssasin.MysticStrikeYell", caster)
    EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "MountainProtector.RockToss", caster)

    if caster:HasModifier("modifier_mountain_protector_immortal_weapon_3") then
        StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_1, rate=1.5})
    else
        StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_4, rate=1.1})
    end
    rock_start(caster, ability, target)
    if caster:HasModifier("modifier_mountain_protector_glyph_5_1") then
    	local luck = RandomInt(1,2)
    	if luck == 1 then
    		ability:EndCooldown()
    		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_red_coreglow.vpcf", caster, 2)
    	end
    end
    Filters:CastSkillArguments(3, caster)
end

function rock_start(caster, ability, target_location)
	local target = target_location
    local fv = (target*Vector(1,1,0)-caster:GetAbsOrigin()*Vector(1,1,0)):Normalized()
    local bomb = CreateUnitByName("lanaya_explosive_bomb", caster:GetAbsOrigin(), false, caster, nil, caster:GetTeamNumber())
    local modelTable = {"models/props_nature/campfire_rocks001.vmdl", "models/props_nature/campfire_rocks002.vmdl", "models/props_nature/chipped_rocks005.vmdl"}
    local rockIndex = RandomInt(1,3)

    
    bomb:SetRenderColor(70, 70, 30)
    bomb:AddAbility("mountain_bomb_ability"):SetLevel(1)
    bomb:FindAbilityByName("mountain_bomb_ability"):ApplyDataDrivenModifier(bomb, bomb, "mountain_bomb_motion", {duration = 10})

    if caster:HasModifier("modifier_steelforge_stance") then
        -- bomb:SetOriginalModel("models/items/meepo/diggers_divining_rod/diggers_divining_rod_gem_saphire.vmdl")
        -- bomb:SetModel("models/items/meepo/diggers_divining_rod/diggers_divining_rod_gem_saphire.vmdl")
        -- bomb:SetModelScale(1.2)
        bomb:SetOriginalModel(modelTable[rockIndex])
        bomb:SetModel(modelTable[rockIndex])
        bomb:SetModelScale(0.5)
        bomb:SetRenderColor(80, 80, 80)
        bomb:FindAbilityByName("mountain_bomb_ability"):ApplyDataDrivenModifier(bomb, bomb, "mountain_bomb_blue_fire_effect", {})
    else
        bomb:SetOriginalModel(modelTable[rockIndex])
        bomb:SetModel(modelTable[rockIndex])
        bomb:SetModelScale(0.5)
        bomb:FindAbilityByName("mountain_bomb_ability"):ApplyDataDrivenModifier(bomb, bomb, "mountain_bomb_fire_effect", {})
    end
    local casterOrigin = caster:GetAbsOrigin()
    local targetOrigin = target_location
    local fv = (targetOrigin*Vector(1,1,0)-casterOrigin*Vector(1,1,0)):Normalized()
    local distance = WallPhysics:GetDistance(casterOrigin*Vector(1,1,0), targetOrigin*Vector(1,1,0))
    caster:SetForwardVector(fv)
    local propulsion = distance/40
    local liftForce = 30
    local gravity = 1
    local liftDuration = distance/propulsion/2
    if caster:HasModifier("modifier_steelforge_stance") then
        local steelforgeAbility = caster:FindAbilityByName("mountain_protector_steelforge_stance")
        steelforgeAbility:ApplyDataDrivenModifier(caster, bomb, "modifier_steelforge_stone", {})
        propulsion = propulsion*math.sqrt(2)
        distance = distance/math.sqrt(2)
        liftForce = liftForce*math.sqrt(2)
        gravity = gravity*4

    end
    if caster:HasModifier("modifier_mountain_protector_immortal_weapon_3") then
        propulsion = propulsion*2
        liftForce = 1
        if caster:HasModifier("modifier_steelforge_stance") then
            propulsion = (propulsion/2)*1.5
            gravity = gravity*4
            distance = distance/3
        end
    end
    bomb_jump_to_position(caster, ability, bomb, fv, distance, liftForce, propulsion, gravity, gravity, liftDuration)
    local animationTime = math.min(500/distance, 1)
end

function bomb_jump_to_position(caster, ability, unit, forwardVector, distance, liftForce, propulsion, gravity, fallGravity, liftDuration)
    
    local endLocation = unit:GetAbsOrigin()+forwardVector*distance
    for i = 1, liftDuration, 1 do
        Timers:CreateTimer(0.03*i, function()
            local currentPosition = unit:GetAbsOrigin()
            local liftForce = math.max(liftForce-i*gravity, 0)
            local newPosition = currentPosition+forwardVector*propulsion+Vector(0,0,liftForce)
            unit:SetOrigin(newPosition)
            print(liftForce)
        end)
    end
    local fallLoop = 0
    Timers:CreateTimer(0.03*liftDuration+0.03, function()
        Timers:CreateTimer(0.03*fallLoop, function()
        	print("FALLING?")
            fallLoop = fallLoop + 1
            local currentPosition = unit:GetAbsOrigin()
            local newPosition = currentPosition+forwardVector*propulsion-Vector(0,0,fallLoop*fallGravity)

            if unit:HasModifier("mountain_bomb_motion") then
                unit:SetOrigin(newPosition)
            end
            if GetGroundPosition(unit:GetAbsOrigin(), unit).z > unit:GetAbsOrigin().z - 30 then
                unit:SetOrigin(newPosition)
                bomb_land(unit, caster, ability)
            else
                if newPosition.x <= endLocation.x + 0 and newPosition.x >= endLocation.x-0 and newPosition.y <= endLocation.y+0 and newPosition.y >= endLocation.y-0 then
                    unit:SetOrigin(newPosition)
                    bomb_land(unit, caster, ability)
                else
                    return 0.03
                end
            end
        end)
    end)
end

function bomb_land(bomb, caster, ability)
	bomb:RemoveModifierByName("mountain_bomb_motion")
	local pfx = ParticleManager:CreateParticle( "particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, bomb:GetAbsOrigin() )
	ParticleManager:SetParticleControl( pfx, 1, Vector(200, 200, 200) )
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	EmitSoundOn("MountainProtector.RockLand", bomb)
	Timers:CreateTimer(0.4, function()
		teleportToPosition(caster, ability, bomb:GetAbsOrigin())
		UTIL_Remove(bomb)
	end)
	local a_c_level = Runes:GetTotalRuneLevel(caster, 1, "a_c", "mountain_protector")
	if a_c_level > 0 then
        if caster:HasAbility("mountain_protector_aeon_fracture") then
    		local aeonFracture = caster:FindAbilityByName("mountain_protector_aeon_fracture")
    		aeonFracture.a_d_level = Runes:GetTotalRuneLevel(caster, 1, "a_d", "mountain_protector")
    		local damage = aeonFracture:GetSpecialValueFor("damage")
    		local amp = 1+(0.3*a_c_level)
            local stun_duration = 0.1*a_c_level
    		local explosionAOE = 300
            if not aeonFracture.a_d_level then
                aeonFracture.a_d_level = Runes:GetTotalRuneLevel(caster, 1, "a_d", "mountain_protector")
            end
            if not aeonFracture.b_d_level then
                aeonFracture.b_d_level = Runes:GetTotalRuneLevel(caster, 2, "b_d", "mountain_protector")
            end
    		aeon_fracture_explosion(caster, bomb:GetAbsOrigin(), damage, amp, explosionAOE, aeonFracture, false, stun_duration)
        elseif caster:HasAbility("mountain_protector_hailstorm") then
            local aeonFracture = caster:FindAbilityByName("mountain_protector_hailstorm")
            local damage = aeonFracture:GetSpecialValueFor("damage") + aeonFracture:GetSpecialValueFor("damage_from_strength") * caster:GetStrength()
            local amp = 1+(0.3*a_c_level)
            local stun_duration = 0.1*a_c_level
            local explosionAOE = 300
            hailstorm_explosion(caster, bomb:GetAbsOrigin(), damage, amp, explosionAOE, aeonFracture, false, stun_duration)
        end
	end
end

function rock_change_angle(event)
	local caster = event.caster
	local angles = caster:GetAngles()
	print(angles)
	caster:SetAngles(angles.x+2, angles.y+20, 0)
end

function teleportToPosition(caster, ability, target)
	local b_c_level = Runes:GetTotalRuneLevel(caster, 2, "b_c", "mountain_protector")
	if b_c_level > 0 then
        local b_c_duration = Filters:GetAdjustedBuffDuration(caster, 15, false)
		local runeAbility = caster.runeUnit2:FindAbilityByName("mountain_protector_rune_b_c")
		runeAbility:ApplyDataDrivenModifier(caster.runeUnit2, caster, "modifier_mountain_protector_rune_b_c", {duration = b_c_duration})
		caster:SetModifierStackCount("modifier_mountain_protector_rune_b_c", caster.runeUnit2, b_c_level)
	end
	local c_c_level = Runes:GetTotalRuneLevel(caster, 3, "c_c", "mountain_protector")
	if c_c_level > 0 then
        local c_c_duration = Filters:GetAdjustedBuffDuration(caster, 7, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_emberstone_wave", {duration = c_c_duration})
	end
	local particleName = "particles/roshpit/mystic_assassin/mystic_strike.vpcf"
	local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( particle1, 0, caster:GetAbsOrigin()+Vector(0,0,40) )
	Timers:CreateTimer(3, 
	function()
		ParticleManager:DestroyParticle( particle1, false )
	end)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "MysticAssasin.MysticStrike.In", caster)
    target = WallPhysics:WallSearch(caster:GetAbsOrigin(), target, caster)

    local newPosition = target
    FindClearSpaceForUnit(caster, newPosition, false)
    ProjectileManager:ProjectileDodge(caster)

   	local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( particle2, 0, caster:GetAbsOrigin()+Vector(0,0,40) )
	Timers:CreateTimer(3, 
	function()
		ParticleManager:DestroyParticle( particle2, false )
	end)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "MysticAssasin.MysticStrike.Out", caster)
end

function rune_unit_4_think(event)
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	local d_c_level = Runes:GetTotalRuneLevel(hero, 4, "d_c", "mountain_protector")
	if d_c_level > 0 then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_mountain_rune_d_c_effect", {})
		hero:SetModifierStackCount("modifier_mountain_rune_d_c_effect", caster, d_c_level)
	else
		hero:RemoveModifierByName("modifier_mountain_rune_d_c_effect")
	end
    if hero:HasModifier("modifier_rockfall_passive") and ability:GetAbilityName() == "mountain_protector_rune_d_c_arcana3" then
        local d_c_level = Runes:GetTotalRuneLevelGeneric(hero, 4, 2)
        if d_c_level > 0 then
            ability:ApplyDataDrivenModifier(caster, hero, "modifier_mountain_rune_d_c_effect", {})
            hero:SetModifierStackCount("modifier_mountain_rune_d_c_effect", caster, d_c_level)
        else
            hero:RemoveModifierByName("modifier_mountain_rune_d_c_effect")
        end
    end
end