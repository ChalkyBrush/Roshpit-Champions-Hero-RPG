function winter_spawner_think(event)
	local caster = event.caster
	if not caster.summonTable then
		caster.summonTable = {}
		caster.totalSummons = 0
	end
	local newTable = {}
	for i = 1, #caster.summonTable, 1 do
		if IsValidEntity(caster.summonTable[i]) then
			table.insert(newTable, caster.summonTable[i])
		end
	end
	caster.summonTable = newTable
	local maxSummons = 5
	local loops = 1
	if GameState:GetDifficultyFactor() == 2 then
		maxSummons = 8
	elseif GameState:GetDifficultyFactor() == 3 then
		maxSummons = 12
		loops = 2
	end
	if #caster.summonTable > maxSummons then
		return
	end
	caster.totalSummons = caster.totalSummons + 1
	local itemRoll = 1
	if caster.totalSummons > 12 then
		itemRoll = 0
	end
	local bAggro = false
	if caster.aggro then
		bAggro = true
	end
	StartAnimation(caster, {duration=1.9, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.9})
	EmitSoundOn("Winterblight.SpawnerSquish", caster)
	Timers:CreateTimer(1.3, function()
		for i = 1, loops, 1 do
			local position = caster.summonCenter + RandomVector(RandomInt(1, 240))
			local zombie = Winterblight:SpawnSpawnerUnit(caster:GetAbsOrigin(), RandomVector(1), itemRoll, bAggro)
			zombie:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,100)+caster:GetForwardVector()*40)
			local fv = WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi*(RandomInt(-10,10))/100)
			WallPhysics:Jump(zombie,fv, RandomInt(4, 16), RandomInt(10, 16), RandomInt(16, 24), 1)
			zombie.jumpEnd = "crab_land"
			if caster.totalSummons > 12 then
				zombie:SetDeathXP(0)
				zombie:SetMaximumGoldBounty(0)
				zombie:SetMinimumGoldBounty(0)
			end
			EmitSoundOn("Winterblight.Crab.Spawn", zombie)
			FindClearSpaceForUnit(zombie, zombie:GetAbsOrigin(), false)
			table.insert(caster.summonTable, zombie)
		end
	end)
end

function winter_spawner_die(event)
	local caster = event.caster
	CustomAbilities:QuickAttachParticle("particles/econ/items/crystal_maiden/ti7_immortal_shoulder/cm_ti7_immortal_frostbite_snow_explode.vpcf", caster, 3)
end

function ogre_armor_take_damage(event)
	local caster = event.caster
	local ability = event.ability
	local attacker = event.attacker
	if not caster.hits then
		caster.hits = 0
	end
	if not caster.pfxCount then
		caster.pfxCount = 0
	end
	if caster.pfxCount < 6 then
		caster.pfxCount = caster.pfxCount + 1
		CustomAbilities:QuickAttachParticle("particles/neutral_fx/ogre_magi_frost_armor_b.vpcf", caster, 0.5)
		Timers:CreateTimer(1, function()
			caster.pfxCount = caster.pfxCount - 1
		end)
	end
	caster.hits = caster.hits + 1
	if caster.hits == event.hits_for_counter then
		caster.hits = 0
		EmitSoundOn("Winterblight.OgreShield.Launch", caster)
		local fv = ((attacker:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		local info = 
		{
				Ability = ability,
	        	EffectName = "particles/roshpit/winterblight/ogre_retaliation.vpcf",
	        	vSpawnOrigin = caster:GetAbsOrigin()+Vector(0,0,50),
	        	fDistance = 1500,
	        	fStartRadius = 150,
	        	fEndRadius = 300,
	        	Source = caster,
	        	StartPosition = "attach_attack1",
	        	bHasFrontalCone = true,
	        	bReplaceExisting = false,
	        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
	        	iUnitTargetType = DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
	        	fExpireTime = GameRules:GetGameTime() + 5.0,
			bDeleteOnHit = false,
			vVelocity = fv * 1000,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
	end
end

function ogre_armor_impact(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local damage = event.damage
	EmitSoundOn("Winterblight.OgreArmorImpact", target)
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
	Filters:ApplyStun(caster, event.stun_duration, target)	
end