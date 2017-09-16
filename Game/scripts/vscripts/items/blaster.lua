blaster_lua = class({})
LinkLuaModifier( "modifier_blaster_ice_lua", "items/modifier_blaster.lua", LUA_MODIFIER_MOTION_NONE )

function useBlaster(event)
	local caster = event.caster
	local ability = event.ability
	ability.caster = caster
	ability.damage = 200
	ability.distance = 600
	ability.startRadius = 200
	ability.endRadius = 300
	ability.cooldown = 12.0
	ability.debuff_duration = 5.0
	ability.particle, ability.sound = getSoundAndParticle(event.type)
	ability.type = event.type
	ability.fv = caster:GetForwardVector()
	setMagnitudes(ability)
	action(ability.property1name, ability.property1, caster, ability)
	if ability.property2name then
		action(ability.property2name, ability.property2, caster, ability)
	end
	if ability.property3name then
		action(ability.property3name, ability.property3, caster, ability)
	end
	if ability.property4name then
		action(ability.property4name, ability.property4, caster, ability)
	end
	if ability.property5name then
		action(ability.property5name, ability.property5, caster, ability)
	end

	createProjectile(caster, ability)
end

function setMagnitudes(ability)
	if ability.type == "fire" then
		ability.modifier_magnitude = 20
	elseif ability.type == "ice" then
		ability.modifier_magnitude = 90
	elseif ability.type == "wind" then
		ability.modifier_magnitude = 25
	end
end

function getSoundAndParticle(abilityType)
	if abilityType == "fire" then
		return "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf", "Hero_OgreMagi.Fireblast.Target"
	elseif abilityType == "ice" then
		return "particles/items/cannon/breath_of_ice.vpcf", "Hero_Crystal.CrystalNova"
	elseif abilityType == "wind" then
		return "particles/items/cannon/breath_of_wind.vpcf", "Hero_Clinkz.WindWalk"
	end
end

function action(propertyName, propertyValue, caster, ability)
	if propertyName == "damage" then
		damage(propertyValue, ability)
	elseif propertyName == "radius" then
		radius(propertyValue, ability)
	elseif propertyName == "range" then
		range(propertyValue, ability)
	elseif propertyName == "cooldown" then
		cooldown(propertyValue, ability)
	elseif propertyName == "modifier_magnitude" then
		modifier_magnitude(propertyValue, ability)
	elseif propertyName == "modifier_duration" then
		modifier_duration(propertyValue, ability)
	elseif propertyName == "root" then
		blaster_root(propertyValue, ability)
	elseif propertyName == "caster_knockback" then
		caster_knockback(propertyValue, ability)
	elseif propertyName == "movespeed" then
		caster_movespeed(propertyValue, ability)
	elseif propertyName == "extra_shots" then
		extra_shots(propertyValue, ability)
	elseif propertyName == "blink" then
		blink(propertyValue, ability)
	elseif propertyName == "health_restore" then
		heal(propertyValue, caster)
	elseif propertyName == "mana_restore" then
		restore_mana(propertyValue, caster)
	elseif propertyName == "torrent" then
		blaster_torrent(propertyValue, ability)
	elseif propertyName == "moon_shroud" then
		blaster_moon_shroud(propertyValue, ability)
	end
end

function damage(propertyValue, ability)
	ability.damage = ability.damage + propertyValue
end

function radius(propertyValue, ability)
	ability.endRadius = ability.endRadius + propertyValue
end

function range(propertyValue, ability)
	ability.distance = ability.distance + propertyValue
end

function cooldown(propertyValue, ability)
	ability.cooldown = ability.cooldown - propertyValue
	if ability.cooldown <= 3 then
		ability.cooldown = 3
	end
end

function modifier_magnitude(propertyValue, ability)
	ability.modifier_magnitude = ability.modifier_magnitude + propertyValue
end

function modifier_duration(propertyValue, ability)
	ability.debuff_duration = ability.debuff_duration + propertyValue
end

function blaster_root(propertyValue, ability)
	ability.blaster_root = true
	ability.blaster_root_duration = propertyValue
end

function caster_knockback(propertyValue, ability)
	ability.caster_knockback = true
	ability.caster_knockback_distance = propertyValue
end

function caster_movespeed(propertyValue, ability)
	ability.caster_movespeed = true
	ability.caster_movespeed_value = propertyValue
end

function extra_shots(propertyValue, ability)
	ability.extra_shots = true
end

function blink(propertyValue, ability)
	ability.caster_blink = true
	ability.caster_blink_value = propertyValue
end

function heal(amount, caster)
 	caster:Heal( amount, caster)
	PopupHealing(caster, amount)
end

function restore_mana(amount, caster)
	caster:GiveMana(amount)
	PopupMana(caster, amount)
end

function blaster_torrent(propertyValue, ability)
	ability.torrent = true
end

function blaster_moon_shroud(propertyValue, ability)
	ability.moon_shroud = true
end

function createProjectile(caster, ability)
	local fv = ability.fv
	local origin = caster:GetAbsOrigin()
	local spellOrigin = origin+fv*80
	--A Liner Projectile must have a table with projectile info
	

	local info = 
	{
			Ability = ability,
        	EffectName = ability.particle,
        	vSpawnOrigin = spellOrigin,
        	fDistance = ability.distance,
        	fStartRadius = ability.startRadius,
        	fEndRadius = ability.endRadius,
        	Source = caster,
        	StartPosition = "attach_origin",
        	bHasFrontalCone = true,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
		vVelocity = fv * 700,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
	ability:StartCooldown(ability.cooldown)
	EmitSoundOn(ability.sound, caster)

	if ability.extra_shots then
	  Timers:CreateTimer(1, 
	    function()
			projectile = ProjectileManager:CreateLinearProjectile(info)
			EmitSoundOn(ability.sound, caster)
	    end)
	end
	if ability.caster_knockback then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_blaster_knockback", {duration = 0.6})
	end
	if ability.caster_movespeed then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_blaster_movespeed", {duration = ability.caster_movespeed_value})
	end
	if ability.caster_blink then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_blaster_blink", {duration = 0.7})
		local blink_pos = origin + fv*ability.caster_blink_value
		caster:SetAbsOrigin(blink_pos)
	end
	if ability.torrent then
		create_dummy_ability(spellOrigin, caster, "kunkka_torrent", 4)
	end
	if ability.moon_shroud then
		create_dummy_ability(spellOrigin, caster, "dummy_moon_shroud", 2)
	end
end



function targetHit(event)
local caster = event.caster
local ability = event.ability
local target = event.target
local damageTable = {
	victim = target,
	attacker = caster,
	damage = ability.damage,
	damage_type = DAMAGE_TYPE_PURE,
}
 
ApplyDamage(damageTable)
if ability.type == "fire" then
	ability:ApplyDataDrivenModifier(caster, target, "modifier_fire_blaster", {duration = ability.debuff_duration})
elseif ability.type == "ice" then
	ability:ApplyDataDrivenModifier(caster, target, "modifier_ice_blaster", {duration = ability.debuff_duration})
	target:SetModifierStackCount( "modifier_ice_blaster", ability, ability.modifier_magnitude )
elseif ability.type == "wind" then
	ability:ApplyDataDrivenModifier(caster, target, "modifier_wind_blaster", {duration = ability.debuff_duration})
	target:SetModifierStackCount( "modifier_wind_blaster", ability, ability.modifier_magnitude )
end
if ability.blaster_root then
	ability:ApplyDataDrivenModifier(caster, target, "modifier_blaster_root", {duration = ability.blaster_root_duration})
end


end

function FireBlasterBurn(event)
local target = event.target
local ability = event.ability
local damageTable = {
		victim = target,
		attacker = event.caster,
		damage = 20,
		damage_type = DAMAGE_TYPE_PURE,
	   }
		ApplyDamage(damageTable)
end

function knockback_interval(keys)
	local caster = keys.caster
	local ability = keys.ability
	local modifier = caster:FindModifierByName("modifier_blaster_knockback")
	local origin = caster:GetAbsOrigin()
	local fv = ability.fv
	local deceleration = ability.caster_knockback_distance/120
	
	if not ability.kb_velocity then
		ability.kb_velocity = ability.caster_knockback_distance/6 
	end
	local obstruction = WallPhysics:FindNearestObstruction(origin*Vector(1,1,0))
    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, origin*Vector(1,1,0))
    if blockUnit then
    	ability.kb_velocity = 0
    end
	local newPosition = origin-(fv*ability.kb_velocity)
	ability.kb_velocity = math.max(ability.kb_velocity - deceleration, 0)
	groundPosition = GetGroundPosition( newPosition, caster )
	if origin.z - groundPosition.z > -200 then
		caster:SetAbsOrigin(groundPosition)
	end
end

function modifier_knockback_on_destroy(keys)
	local caster = keys.caster
	local ability = keys.ability
	local origin = caster:GetAbsOrigin()
	FindClearSpaceForUnit(caster, origin, true)
	ability.kb_velocity = nil	
end

function create_dummy_ability(location, caster, abilityName, abilityLevel)
	print(abilityName)
  	local dummy = CreateUnitByName("npc_dummy_unit", location, true, caster, caster, caster:GetTeamNumber())
  	dummy.owner = caster:GetPlayerOwnerID()

  	dummy:AddAbility(abilityName)
  	dummy:NoHealthBar()
  	dummy:AddAbility("dummy_unit")
  	dummy:FindAbilityByName("dummy_unit"):SetLevel(1)

  	local blast = dummy:FindAbilityByName(abilityName)
  	blast:SetLevel(abilityLevel)
	local order =
	{
		UnitIndex = dummy:GetEntityIndex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = blast:GetEntityIndex(),
		Position = location,
		Queue = true
	}
	ExecuteOrderFromTable(order)
	  Timers:CreateTimer(8, -- Start this timer 10 game-time seconds later
	  function()
		dummy:RemoveSelf() 
	  end)	
end
