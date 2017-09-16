require('heroes/lanaya/explosive_bomb')

function vanish_cast(event)
	local caster = event.caster
	local ability = event.ability
	local duration = event.duration
    duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
	EmitSoundOn("Trapper.Vanish", caster)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_trapper_vanish", {duration = duration})
	ProjectileManager:ProjectileDodge(caster)
	local a_c_level = Runes:GetTotalRuneLevel(caster, 1, "a_c", "trapper")
	local b_c_level = Runes:GetTotalRuneLevel(caster, 2, "b_c", "trapper")
	if a_c_level > 0 then
		local runeAbility = caster.runeUnit:FindAbilityByName("trapper_rune_a_c")
		runeAbility:ApplyDataDrivenModifier(caster.runeUnit, caster, "modifier_trapper_rune_a_c_effect", {duration = duration})
		caster:SetModifierStackCount( "modifier_trapper_rune_a_c_effect", runeAbility, a_c_level)
	end
	if b_c_level > 0 then
        local b_c_duration = Filters:GetAdjustedBuffDuration(caster, 1.2, false)
		local runeAbility = caster.runeUnit2:FindAbilityByName("trapper_rune_b_c")
		runeAbility:ApplyDataDrivenModifier(caster.runeUnit2, caster, "modifier_trapper_rune_b_c_effect", {duration = b_c_duration})
		runeAbility.b_c_level = b_c_level
	end
	  local particleName = "particles/items2_fx/smoke_of_deceit.vpcf"
	  local casterPos = caster:GetAbsOrigin()
      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
      ParticleManager:SetParticleControl( particle1, 0, casterPos )
      ParticleManager:SetParticleControl( particle1, 1, Vector(400, 50, 20) )
      Timers:CreateTimer(4, function()
      	ParticleManager:DestroyParticle(particle1, false)
      end)
      rune_d_c(caster, ability)
      Filters:CastSkillArguments(3, caster)
	     if caster:HasModifier("modifier_trapper_glyph_6_1") then
	     	detonateBombs(caster)
	     end
end

function rune_d_c(caster, ability)
	local d_c_level = Runes:GetTotalRuneLevel(caster, 4, "d_c", "trapper")
	if d_c_level > 0 then
		local paralyzeDuration = 0.85+d_c_level*0.15
	    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	    if #enemies > 0 then    
	        for _,enemy in pairs(enemies) do
	        	ability:ApplyDataDrivenModifier(caster, enemy, "modifier_vanish_paralyze", {duration = paralyzeDuration})
	        end
	    end		
	end
end

function vanish_apply(event)
	local target = event.target
	target:SetRenderMode(10)
end

function vanish_destroy(event)
	local target = event.target
	target:SetRenderMode(0)
end

function action_leap_cast(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
    local casterOrigin = caster:GetAbsOrigin()
    local max_distance = event.max_distance
    local targetOrigin = target
    local fv = (targetOrigin*Vector(1,1,0)-casterOrigin*Vector(1,1,0)):Normalized()
    local distance = WallPhysics:GetDistance(casterOrigin*Vector(1,1,0), targetOrigin*Vector(1,1,0))
    if caster:HasModifier("modifier_trapper_immo3_effect") then
        max_distance = max_distance + 400
    end
    distance = math.min(distance, max_distance)
    caster:SetForwardVector(fv)
    action_leap_jump(caster, fv, distance, 35, 40, 1, 1)
    local animationTime = math.min(500/distance, 1)
    EmitSoundOn("Trapper.ActionLeap"..RandomInt(1,2), caster)
    StartAnimation(caster, {duration=1, activity=ACT_DOTA_ATTACK, rate=animationTime, translate="meld"})
    Filters:CastSkillArguments(3, caster)
end

function action_leap_jump(unit, forwardVector, distance, liftForce, propulsion, gravity, fallGravity)
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

            local obstruction = WallPhysics:FindNearestObstruction(newPosition)
            local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition, unit)
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
            else
                if newPosition.x <= endLocation.x + 20 and newPosition.x >= endLocation.x-20 and newPosition.y <= endLocation.y+20 and newPosition.y >= endLocation.y-20 then
                    unit:RemoveModifierByName("modifier_jumping")
                    FindClearSpaceForUnit(unit, newPosition, false)
                else
                    return 0.03
                end
            end
        end)
    end)
end

function vanish_think(event)
	local caster = event.caster
	local runeAbility = caster.runeUnit2:FindAbilityByName("trapper_rune_b_c")
	if runeAbility:GetLevel() > 0 then
		runeAbility:ApplyDataDrivenModifier(caster.runeUnit2, caster, "modifier_trapper_rune_b_c_effect", {duration = 1.2})
	end
end

function first_aid_think(event)
	local caster = event.target
	local ability = event.ability
	local healAmount = math.ceil(250*ability.b_c_level/20)
	caster:Heal(healAmount, caster)
	-- PopupHealing(caster, healAmount)
	PopupFirstAid(caster)
end

function first_aid_move(event)
	local caster = event.caster
	caster.hero:RemoveModifierByName("modifier_trapper_rune_b_c_effect")
	print("MOVE??")
end