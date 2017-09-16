function minesBossThink(event)
	local caster = event.caster
	AddFOWViewer(DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), 500, 2, false)
end

function minesBossAttacked(event)
	local caster = event.target
	local attacker = event.attacker
	Events:CreateLightningBeam(caster:GetAbsOrigin()+Vector(0,0,300), attacker:GetAbsOrigin()+Vector(0,0,80))
	local damage = Events:GetAdjustedAbilityDamage(500, 10000, 0)
	ApplyDamage({ victim = attacker, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
end

function miniMinesBossAttacked(event)
	local caster = event.target
	local attacker = event.attacker
	Events:CreateLightningBeam(caster:GetAbsOrigin()+Vector(0,0,300), attacker:GetAbsOrigin()+Vector(0,0,80))
	local damage = Events:GetAdjustedAbilityDamage(80, 2800, 0)
	ApplyDamage({ victim = attacker, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
end

function tornado(event)	
	local ability = event.ability
	local caster = event.caster
	ability.liftVelocity = 30
	ability.fallVelocity = 0
	ability.forwardVector = caster:GetForwardVector()
	local duration = 2.4
	
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_razor_sparks", {duration = duration})
	caster:SetForwardVector(Vector(ability.forwardVector.x, ability.forwardVector.y, -math.pi))
	StartAnimation(caster, {duration=duration, activity=ACT_DOTA_INTRO, rate=1.0})
	local soundTable = {"razor_raz_laugh_01", "razor_raz_laugh_02", "razor_raz_laugh_03", "razor_raz_laugh_04", "razor_raz_laugh_05", "razor_raz_laugh_06"}
	local randomInt = soundTable[RandomInt(1, 6)]
	EmitGlobalSound(randomInt)
	EmitGlobalSound("Hero_Disruptor.ThunderStrike.Cast")
	caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,80)-ability.forwardVector*60)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 6000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_razor_tornado_lifting", {duration = duration/2})
		local fv = ((enemies[1]:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		ability.forwardVector = fv	
	end 
end	

function tornado_lifting(event)
	local caster = event.caster
	local ability = event.ability
	ability.liftVelocity = math.max(ability.liftVelocity-4, 10)
	local position = caster:GetAbsOrigin() + Vector(0,0,ability.liftVelocity)
	newPosition = position+ability.forwardVector*44
	caster:SetOrigin(newPosition)
end

function tornado_falling(event)

	local caster = event.caster
	local ability = event.ability
	if ability.fallVelocity == 0 then
		caster:SetForwardVector(Vector(ability.forwardVector.x, ability.forwardVector.y, -math.pi*3/2))
	end
	ability.fallVelocity = ability.fallVelocity + 4
	local position = caster:GetAbsOrigin() - Vector(0,0,ability.fallVelocity)
	newPosition = position+ability.forwardVector*44
	caster:SetOrigin(newPosition)
	if position.z - GetGroundPosition(position, caster).z < 10 then
		caster:RemoveModifierByName("modifier_razor_tornado_falling")
	end
end

function falling_end(event)
	local caster = event.caster
	local ability = event.ability
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
	caster:SetForwardVector(Vector(ability.forwardVector.x, ability.forwardVector.y, 0))
end

function cyclone_sparks(event)
	local caster = event.caster
	local ability = event.ability

	create_spark(RandomVector(1), caster, ability)
end

function create_spark(fv, caster, ability)
	EmitSoundOn("Hero_Disruptor.ThunderStrike.Target", caster)
	local projectileParticle = "particles/econ/items/zeus/lightning_weapon_fx/voltex_ultimmortal_lightning.vpcf"
	local movementMult = 0
	if caster:HasModifier("modifier_razor_tornado_falling") or caster:HasModifier("modifier_razor_tornado_lifting") then
		movementMult = 400
	end
	local projectileOrigin = caster:GetAbsOrigin() + fv*movementMult
	local start_radius = 95
	local end_radius = 95
	local range = 2400
	local speed = 400 + RandomInt(0, 250)
		local info = 
		{
				Ability = ability,
	        	EffectName = projectileParticle,
	        	vSpawnOrigin = projectileOrigin+Vector(0,0,110),
	        	fDistance = range,
	        	fStartRadius = start_radius,
	        	fEndRadius = end_radius,
	        	Source = caster,
	        	StartPosition = "attach_attack1",
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

function spark_hit(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = Events:GetAdjustedAbilityDamage(10000, 40000, 0)
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
end

function lightning_storm_start(event)
	local caster = event.caster
	StartAnimation(caster, {duration=7, activity=ACT_DOTA_TELEPORT, rate=1.0})
	local soundTable = {"razor_raz_ability_storm_01", "razor_raz_ability_storm_02", "razor_raz_ability_storm_03", "razor_raz_ability_storm_06"}
	local randomInt = soundTable[RandomInt(1, 4)]
	EmitGlobalSound(randomInt)
end

function lightning_storm_think(event)
	local caster = event.caster
	EmitGlobalSound("Hero_Disruptor.ThunderStrike.Cast")
	local stormCloudParticle = "particles/units/heroes/hero_razor/razor_rain_storm.vpcf"
	local damage = event.damage
	local position = caster:GetAbsOrigin()+RandomVector(RandomInt(180, 3000))
	local pfx = ParticleManager:CreateParticle( stormCloudParticle, PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( pfx, 0, position )
		ParticleManager:SetParticleControl( pfx, 1, Vector(200, 200, 200) )
		for i = 2, 5, 1 do
			Timers:CreateTimer(i, function()
				lightning_storm_bolt(position, caster, damage)
			end)
		end
		Timers:CreateTimer(6, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
end

function lightning_storm_bolt(position, caster, damage)
	EmitSoundOnLocationWithCaster(position, "Ability.PlasmaFieldImpact", caster)
	local particleName = "particles/econ/items/sven/sven_warcry_ti5/sven_warcry_cast_arc_lightning.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, position )
	ParticleManager:SetParticleControl( pfx, 1, Vector(180, 0, 0) )
	ParticleManager:SetParticleControl( pfx, 3, Vector(0, 0, 0) )
	Timers:CreateTimer(0.2, function()
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, 120, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
			end			
		end 
	end)
	Timers:CreateTimer(8, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
end

function illusions_start(event)
	local caster = event.caster
	local ability = event.ability
	StartAnimation(caster, {duration=7, activity=ACT_DOTA_INTRO, rate=1.0})
	local soundTable = {"razor_raz_illus_01", "razor_raz_illus_02"}
	local randomInt = soundTable[RandomInt(1, 2)]
	EmitGlobalSound(randomInt)
	EmitGlobalSound(randomInt)
	local fv = caster:GetForwardVector()
	for i = -3, 3, 1 do
		local rotatedFv = WallPhysics:rotateVector(fv, math.pi/3.5*i)
		createIllusion(caster, caster:GetAbsOrigin(), rotatedFv, ability)
	end
	caster.illusions = 7

end

function createIllusion(caster, position, fv, ability)
	local spawnPoint = position+fv*300
	local illusion = CreateUnitByName("mini_mines_boss", spawnPoint, true, nil, nil, DOTA_TEAM_NEUTRALS)
	illusion.caster = caster
	illusion.casterAbility = ability
	FindClearSpaceForUnit(illusion, illusion:GetAbsOrigin(), false)
	Events:AdjustDeathXP(illusion)
end

function illusionDie(event)
	local caster = event.caster
	caster.caster.illusions = caster.caster.illusions - 1
	if caster.caster.illusions == 0 then
		local soundTable = {"razor_raz_pain_01", "razor_raz_anger_01", "razor_raz_anger_02", "razor_raz_anger_06"}
		local randomInt = soundTable[RandomInt(1, 4)]
		EmitGlobalSound(randomInt)
	  caster.caster:RemoveModifierByName("modifier_razor_illusions")
      caster.caster:FindAbilityByName("mines_boss_dive"):StartCooldown(10)
      caster.caster:FindAbilityByName("mines_boss_illusions"):StartCooldown(60)
      caster.caster:FindAbilityByName("mines_boss_thunder_storm"):StartCooldown(15)
	  MinimapEvent(DOTA_TEAM_GOODGUYS, caster.caster, caster.caster:GetAbsOrigin().x, caster.caster:GetAbsOrigin().y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 5)
      caster.casterAbility:ApplyDataDrivenModifier(caster.caster, caster.caster, "modifier_razor_illusions_stun", {duration = 8})
      ScreenShake(caster.caster:GetAbsOrigin(), 300, 1, 1, 9000, 0, true)
	end
end