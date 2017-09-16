function wraithguard_think(event)
	local caster = event.caster
	local ability = event.ability
	local elite = 0
	if caster:GetUnitName() == "wraithguard_elite" then
		elite = 1
	end
	if not ability.interval then
		ability.interval = 0 
	end
	if not caster.aggro then
		return nil
	end
	if caster:IsStunned() then
		return nil
	end
	if ability.interval % 6 == 0 then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			local unit = enemies[1]
			local fv = (unit:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
			WallPhysics:Jump(caster, fv, 15+RandomInt(0,5), 22, 22, 1.4)
			StartAnimation(caster, {duration=0.56, activity=ACT_DOTA_FORCESTAFF_END, rate=0.7})
		end 
		ability.interval = 0
	end
	local luck = 1
	if elite == 0 then
		luck = RandomInt(1, 6)
	else
		luck = RandomInt(1, 5)
	end
	if luck == 1 then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			local unit = enemies[1]
			local fv = (unit:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
			local min = 1
			if elite == 1 then
				min = -1
			end
			for i = min, 1, 1 do
				local forward = WallPhysics:rotateVector(fv, math.pi/9*i)
				EmitSoundOn("Hero_SkeletonKing.Hellfire_Blast", caster)
				StartAnimation(caster, {duration=0.26, activity=ACT_DOTA_CAST_ABILITY_1, rate=1.8})
				local spellOrigin = caster:GetAbsOrigin()+Vector(0,0,80)
				local info = 
				{
					Ability = ability,
			        	EffectName = "particles/units/heroes/hero_skeletonking/hellfireblast_linear.vpcf",
			        	vSpawnOrigin = spellOrigin,
			        	fDistance = 1450,
			        	fStartRadius = 180,
			        	fEndRadius = 180,
			        	Source = caster,
			        	StartPosition = "attach_attack2",
			        	bHasFrontalCone = true,
			        	bReplaceExisting = false,
			        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			        	fExpireTime = GameRules:GetGameTime() + 7.0,
					bDeleteOnHit = false,
					vVelocity = forward * 800,
					bProvidesVision = false,
				}
				projectile = ProjectileManager:CreateLinearProjectile(info)
			end
		end 
	end
	ability.interval = ability.interval + 1
end

function wraithguard_hellfire_strike(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	EmitSoundOn("Hero_SkeletonKing.Hellfire_BlastImpact", target)
	local damage = Events:GetAdjustedAbilityDamage(14000, 15000, 0)
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
	PopupDamage(target, damage)
	target:AddNewModifier(caster, nil, "modifier_stunned", {duration = 1.2})
end

function mad_pumpkin_think(event)
	local caster = event.caster
	local point = caster.centerPoint
	local ability = event.ability
	if not caster.interval then
		caster.interval = 0
	end
	if caster.interval%10 == 0 then
		caster.betweenVector = nil
	  	local position = caster:GetAbsOrigin()
	  	local radius = 650
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			local luck = RandomInt(1, 4)
			if luck == 1 then
				EmitSoundOn("Conquest.poison.hallow_scream", caster)
			end
			for _,enemy in pairs(enemies) do
				local info = 
				{
					Target = enemy,
					Source = caster,
					Ability = ability,	
					EffectName = "particles/units/heroes/hero_lina/lina_base_attack.vpcf",
					StartPosition = "attach_hitloc",
					bDrawsOnMinimap = false, 
				        bDodgeable = true,
				        bIsAttack = false, 
				        bVisibleToEnemies = true,
				        bReplaceExisting = false,
				        flExpireTime = GameRules:GetGameTime() + 4,
					bProvidesVision = true,
					iVisionRadius = 0,
					iMoveSpeed = 600,
					iVisionTeamNumber = caster:GetTeamNumber()
				}
				projectile = ProjectileManager:CreateTrackingProjectile(info)
				
			end
			caster.betweenVector = (enemies[1]:GetAbsOrigin() - position):Normalized()
			
		end
	end
	caster.interval = caster.interval+1  
	local movePosition = point+caster.rotationVector:Normalized()*400+Vector(0,0,970)
	caster:SetOrigin(movePosition)
	caster.rotationVector = WallPhysics:rotateVector(caster.rotationVector, math.pi/90)	
	caster:SetForwardVector(WallPhysics:rotateVector(caster.rotationVector, math.pi/2))
	if caster.interval > 100 then
		caster.interval = 0
	end
	if caster.betweenVector then
		caster.centerPoint = caster.centerPoint + caster.betweenVector * 4
	end

end

function pumpkin_strike(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	EmitSoundOn("Hero_Lina.ProjectileImpact", target)
	local damage = Events:GetAdjustedAbilityDamage(1800, 4500, 0)
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
end

function groundskeeper_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.interval then
		caster.interval = 0
		caster.state = 0
	end
	if caster.interval == 2 and caster.state <=2 then
		caster:MoveToPosition(Vector(-597, 6750))
	end
	if caster.interval == 22 and caster.state <=2 then
		caster:MoveToPosition(Vector(-612, 6750))
		StartAnimation(caster, {duration=5, activity=ACT_DOTA_CHANNEL_ABILITY_3, rate=0.9})
	end
	if caster.interval == 44 and caster.state <=2 then
		caster:MoveToPosition(Vector(-650, 6342))
	elseif caster.interval == 74 and caster.state <=2 then
		caster:MoveToPosition(Vector(-665, 6342))
		StartAnimation(caster, {duration=4, activity=ACT_DOTA_CHANNEL_ABILITY_3, rate=0.9})
	end
	local point = caster:GetAbsOrigin()
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), point, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 and not caster.speechBubble and caster.state == 0 then
		Dungeons:CreateSpeechBubble(caster, 7, "#groundskeeper_dialogue_one")
		caster.speechBubble = true
	end

	
	caster.interval = caster.interval + 1

	if caster.state == 3 and caster.interval%50 == 0 then
		groundskeeper_jumpStart(caster, ability)
	end
	if caster.interval == 70 and caster.state == 3 then
		groundskeeper_strikeAll(caster)
	end
	if caster.interval >= 100 then
		caster.interval = 0
		if caster.speechBubble then
			Timers:CreateTimer(4, function()
				caster.speechBubble = false
			end)
		end
	end
end

function castle_tree_think(event)
	local tree = event.caster
	local groundskeeper = tree.groundskeeper
	local ability = event.ability
	tree:SetAbsOrigin(tree.origPosition)
	local maxHealth = tree:GetMaxHealth()
	if tree:GetHealth() < maxHealth*0.95 and groundskeeper.state == 0 then
		groundskeeper.state = 1
		Dungeons:CreateSpeechBubble(groundskeeper, 9, "#groundskeeper_dialogue_two")
	end
	if tree:GetHealth() < maxHealth*0.7 and groundskeeper.state == 1 then
		local forwardVector = (tree:GetAbsOrigin() - groundskeeper:GetAbsOrigin()):Normalized()
		groundskeeper:MoveToPosition(groundskeeper:GetAbsOrigin() + forwardVector*80)
		groundskeeper.state = 2
		Dungeons:CreateSpeechBubble(groundskeeper, 9, "#groundskeeper_dialogue_three")
		EmitSoundOn("Hero_SkeletonKing.Hellfire_Blast", groundskeeper)
		EmitSoundOn("Hero_SkeletonKing.Hellfire_Blast", tree)
		EmitSoundOnLocationWithCaster(groundskeeper:GetAbsOrigin(), "Hero_SkeletonKing.Hellfire_Blast", groundskeeper)
		Timers:CreateTimer(0.3, function()
			groundskeeper_strikeAll(groundskeeper)
		end)
	end
	if tree:GetHealth() < maxHealth*0.55 and groundskeeper.state == 2 then
		groundskeeper.state = 3
		EmitSoundOn("warlock_warl_anger_01", tree)
		Dungeons:CreateSpeechBubble(groundskeeper, 7, "#groundskeeper_dialogue_four")
		groundskeeper:SetBaseMoveSpeed(240)
		groundskeeper:MoveToPosition(Vector(-600, 6976))
		Timers:CreateTimer(4, function()
			groundskeeper:SetAcquisitionRange(7000)
			groundskeeper:RemoveModifierByName("modifier_groundskeeper_state_one")
			StartAnimation(groundskeeper, {duration=0.56, activity=ACT_DOTA_CAST_ABILITY_3, rate=0.7})
			UTIL_Remove(groundskeeper.blade)
			groundskeeper:SetBaseMoveSpeed(400)
			Dungeons:CreateSpeechBubble(groundskeeper, 7, "#groundskeeper_dialogue_five")

			local properties =  {
			    pitch = 90,
			    yaw = 90,
			    roll = 140,
			    XPos = -20,
			    YPos = 50,
			    ZPos = -80,
			  }
			Attachments:AttachProp(groundskeeper, "attach_thumb", "models/items/abaddon/weapon_ravelord/weapon_ravelord.vmdl", 0.8, properties)
			EmitSoundOn("Conquest.hallow_laughter", groundskeeper)
			EmitSoundOn("Conquest.hallow_laughter", tree)
			Timers:CreateTimer(0.5, function()
				groundskeeper_strikeAll(groundskeeper)
			end)
		end)
	end
end

function groundskeeper_strikeAll(groundskeeper)
		local groundskeeper_ability = groundskeeper:FindAbilityByName("groundskeeper_ai")
		StartAnimation(groundskeeper, {duration=0.56, activity=ACT_DOTA_CAST_ABILITY_3, rate=0.7})
		for i = 1, #MAIN_HERO_TABLE, 1 do
			local info = 
			{
				Target = MAIN_HERO_TABLE[i],
				Source = groundskeeper,
				Ability = groundskeeper_ability,	
				EffectName = "particles/units/heroes/hero_lina/lina_base_attack.vpcf",
				StartPosition = "attach_hitloc",
				bDrawsOnMinimap = false, 
			        bDodgeable = false,
			        bIsAttack = false, 
			        bVisibleToEnemies = true,
			        bReplaceExisting = false,
			        flExpireTime = GameRules:GetGameTime() + 4,
				bProvidesVision = true,
				iVisionRadius = 0,
				iMoveSpeed = 900,
				iVisionTeamNumber = groundskeeper:GetTeamNumber()
			}
			projectile = ProjectileManager:CreateTrackingProjectile(info)
		end
end

function groundskeeperMadProjectile(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	EmitSoundOn("Hero_SkeletonKing.Hellfire_BlastImpact", target)
	local damage = Events:GetAdjustedAbilityDamage(100, 1000, 0)
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
	target:AddNewModifier(caster, nil, "modifier_stunned", {duration = 4.5})
end

function groundskeeper_jumpStart(caster, ability)
	ability.liftVelocity = 50
	ability.fallVelocity = 0
	StartAnimation(caster, {duration=0.43, activity=ACT_DOTA_SPAWN, rate=2.5})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_groundskeeper_jumping", {duration = 0.4})
	EmitSoundOn("warlock_warl_deny_09", caster)
end

function groundskeeper_jumpThink(event)
	local caster = event.caster
	local ability = event.ability
	caster:SetAbsOrigin(caster:GetAbsOrigin() +Vector(0,0,ability.liftVelocity))
	ability.liftVelocity = ability.liftVelocity - 5
end

function groundskeeper_fallThink(event)
	local caster = event.caster
	local ability = event.ability
	local position = caster:GetAbsOrigin()
	caster:SetAbsOrigin(position -Vector(0,0,ability.fallVelocity))
	ability.fallVelocity = ability.fallVelocity + 8
	if ability.fallVelocity == 88 then
		StartAnimation(caster, {duration=0.2, activity=ACT_DOTA_TELEPORT_END, rate=1.5})
	end
	if position.z - GetGroundPosition(position, caster).z < 15 then
		caster:RemoveModifierByName("modifier_groundskeeper_falling")
	end
end

function groundskeeper_warlordLand(event)
	local caster = event.caster
	local ability = event.ability
	local position = caster:GetAbsOrigin()
	local stun_duration = 1
	local splitEarthParticle = "particles/units/heroes/hero_treant/treant_leech_seed.vpcf"
	local pfx = ParticleManager:CreateParticle( splitEarthParticle, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", position, true)
	ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", position, true)
	ParticleManager:SetParticleControl( pfx, 3, position)
	ParticleManager:SetParticleControl( pfx, 5, position )
	Timers:CreateTimer(2.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	print("BOOM")
	EmitSoundOn("Hero_Treant.LeechSeed.Target", caster)
	if caster.tree then
		EmitSoundOn("Hero_Leshrac.Split_Earth", caster.tree)
	end
	FindClearSpaceForUnit(caster, position, false)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_groundskeeper_entangle_effect", {duration = 4.5})	
		end
	end 
		local particleName =  "particles/units/heroes/hero_elder_titan/doomguard_leap_effect.vpcf"
		local position = caster:GetAbsOrigin()
		local particleVector = position

		local pfx2 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( pfx2, 0, particleVector )
		ParticleManager:SetParticleControl( pfx2, 1, particleVector )
		ParticleManager:SetParticleControl( pfx2, 2, particleVector )
		Timers:CreateTimer(2.5, function()
			ParticleManager:DestroyParticle(pfx2, false)
		end)
end

function groundskeeper_die(event)
	local caster = event.caster

	local tree = caster.tree
	EmitSoundOn("warlock_warl_death_12", caster)
	EmitSoundOn("warlock_warl_death_12", tree)

	tree:RemoveModifierByName("modifier_tree_invincible")
	local position = caster:GetAbsOrigin()
	local splitEarthParticle = "particles/units/heroes/hero_treant/treant_leech_seed.vpcf"
	local pfx = ParticleManager:CreateParticle( splitEarthParticle, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", position, true)
	ParticleManager:SetParticleControlEnt(pfx, 1, tree, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", position, true)
	ParticleManager:SetParticleControl( pfx, 3, position)
	ParticleManager:SetParticleControl( pfx, 5, position )
	Timers:CreateTimer(2.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	RPCItems:RollItemtype(300, position, 1, 0)
	RPCItems:RollItemtype(300, position, 1, 0)
	RPCItems:RollItemtype(300, position, 1, 0)
end

function tree_die(event)
	local caster = event.caster
	local position = caster:GetAbsOrigin()
	local splitEarthParticle = "particles/frostivus_herofx/hyper_state_intro_omnislash_ascension.vpcf"
	local pfx = ParticleManager:CreateParticle( splitEarthParticle, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", position, true)
	ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", position, true)
	Timers:CreateTimer(3.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)

	local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")

	local visionTracer = CreateUnitByName("npc_flying_dummy_vision", position, true, nil, nil, DOTA_TEAM_GOODGUYS)
	visionTracer:AddAbility("dummy_unit"):SetLevel(1)
	visionTracer:AddNewModifier( visionTracer, nil, 'modifier_movespeed_cap', nil )
	visionTracer:SetBaseMoveSpeed(900)
    Timers:CreateTimer(1.2, function()
		for i = 1, #MAIN_HERO_TABLE, 1 do
			local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
			if playerID then
				gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, MAIN_HERO_TABLE[i], "modifier_disable_player", {duration = 6})
				MAIN_HERO_TABLE[i]:Stop()
				PlayerResource:SetCameraTarget(playerID, visionTracer)
			end
		end
	end)
	Timers:CreateTimer(1.8, function()
		visionTracer:MoveToPosition(Vector(-2112, 6272))
	end)
	Timers:CreateTimer(4.2, function()
		ParticleManager:DestroyParticle(Dungeons.wallParticle, false)
		EmitGlobalSound("Conquest.Stinger.HulkCreep")
		UTIL_Remove(Dungeons.blocker1)
		UTIL_Remove(Dungeons.blocker2)
		UTIL_Remove(Dungeons.blocker3)
		UTIL_Remove(Dungeons.blocker4)
		UTIL_Remove(Dungeons.blocker5)
		Dungeons.blocker1 = nil
		Dungeons.blocker2 = nil
		Dungeons.blocker3 = nil
		Dungeons.blocker4 = nil
		Dungeons.blocker5 = nil
		Timers:CreateTimer(4.8, function()
			EmitGlobalSound("Conquest.poison.hallow_scream")
		end)
	end)
	Timers:CreateTimer(7.2, function()
		for i = 1, #MAIN_HERO_TABLE, 1 do
			local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
			if playerID then
				MAIN_HERO_TABLE[i]:RemoveModifierByName("modifier_disable_player")
				PlayerResource:SetCameraTarget(playerID, MAIN_HERO_TABLE[i])
			end
		end
	end)
	Timers:CreateTimer(7.8, function()
		for i = 1, #MAIN_HERO_TABLE, 1 do
			local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
			if playerID then
				PlayerResource:SetCameraTarget(playerID, nil)
			end
		end
		Dungeons:CastleStageTwo()
	end)

end

function animated_arms_think(event)
	local caster = event.caster
	local ability = event.ability
	local position = caster:GetAbsOrigin()
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for i = 1, #enemies, 1 do
			Timers:CreateTimer(1.5*(i-1), function()
				position = caster:GetAbsOrigin()
				local splitEarthParticle = "particles/frostivus_herofx/hyper_state_intro_omnislash_ascension.vpcf"
				local pfx = ParticleManager:CreateParticle( splitEarthParticle, PATTACH_CUSTOMORIGIN, caster )
				ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", position, true)
				ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", position, true)
				Timers:CreateTimer(3.5, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)
				EmitSoundOn("Conquest.hallow_laughter", caster)
				local teleportPosition = enemies[i]:GetAbsOrigin() +RandomVector(120)
				caster:SetAbsOrigin(teleportPosition)
				FindClearSpaceForUnit(caster, teleportPosition, false) --[[Returns:void
				Place a unit somewhere not already occupied.
				]]
				position = caster:GetAbsOrigin()

				local pfx2 = ParticleManager:CreateParticle( splitEarthParticle, PATTACH_CUSTOMORIGIN, caster )
				ParticleManager:SetParticleControlEnt(pfx2, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", position, true)
				ParticleManager:SetParticleControlEnt(pfx2, 1, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", position, true)
				Timers:CreateTimer(3.5, function()
					ParticleManager:DestroyParticle(pfx2, false)
				end)

			end)
		end
	end 




end
function ghost_init(event)
	local caster = event.caster
	caster:SetAbsOrigin(caster:GetAbsOrigin() -Vector(0,0,120))
end

function ghost_think(event)
	local caster = event.caster
	local ability = event.ability
	if not ability.interval then
		ability.interval = 0
	end
	local position = caster:GetAbsOrigin()
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
	local moveTo = Vector(0,0,0)
	if #enemies <= 0 then
		local randomPlayer = RandomInt(1, #MAIN_HERO_TABLE)
		moveTo = MAIN_HERO_TABLE[randomPlayer]:GetAbsOrigin() + RandomVector(400)
		EmitSoundOn("Conquest.poison.hallow_scream", caster)
		caster:SetAbsOrigin(moveTo)
		FindClearSpaceForUnit(caster, moveTo, false)
		caster:SetAbsOrigin(caster:GetAbsOrigin() -Vector(0,0,120))
	else
		local fv = (enemies[1]:GetAbsOrigin() - position):Normalized()*Vector(1,1,0)
		caster:SetForwardVector(fv)
		local projectileParticle = "particles/econ/items/death_prophet/death_prophet_acherontia/death_prophet_acher_swarm.vpcf"
		local projectileOrigin = caster:GetAbsOrigin() + fv*10
		local start_radius = 120
		local end_radius = 400
		local range = 900
		local speed = 850
		local info = 
		{
				Ability = ability,
		    	EffectName = projectileParticle,
		    	vSpawnOrigin = projectileOrigin+Vector(0,0,60),
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
		StartAnimation(caster, {duration=0.2, activity=ACT_DOTA_CAST_ABILITY_1, rate=1.5})	
		EmitSoundOn("Hero_DeathProphet.CarrionSwarm", caster)	
	end
	
	ability.interval = ability.interval+1

end

function ghost_projectile_hit(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local damage = Events:GetAdjustedAbilityDamage(1800, 3000, 0)
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
	PopupDamage(target, damage)
end

function chef_think(event)
	local caster = event.caster
	local pigDummy = caster.pigDummy
	if not caster.aggro then
		StartAnimation(caster, {duration=0.6, activity=ACT_DOTA_ATTACK, rate=1.1})	
		Timers:CreateTimer(0.3, function()
			EmitSoundOn("Hero_Pudge.Attack", caster)
			local particleName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
			local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, pigDummy )
			ParticleManager:SetParticleControlEnt(pfx, 0, pigDummy, PATTACH_CUSTOMORIGIN, "follow_origin", pigDummy:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx, 1, pigDummy, PATTACH_CUSTOMORIGIN, "follow_origin", pigDummy:GetAbsOrigin(), true)

			EmitSoundOn("Hero_PhantomAssassin.CoupDeGrace", pigDummy)			
		end)
	else
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			local hookAbility = caster:FindAbilityByName("chef_meat_hook")
			if hookAbility:IsFullyCastable() then
				local targetPoint = enemies[1]:GetOrigin() + enemies[1]:GetForwardVector()*100			
				local order =
				{
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = hookAbility:entindex(),
					Position = targetPoint
				}
				ExecuteOrderFromTable(order)
				local soundTable = {"pudge_pud_ability_hook_06", "pudge_pud_ability_hook_08", "pudge_pud_anger_03", "pudge_pud_anger_04"}
				local soundIndex = RandomInt(1, #soundTable)
				EmitSoundOn(soundTable[soundIndex], caster)
			end
		end
	end
end

function chef_attack_hit(event)
	local target = event.target
	local particleName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_CUSTOMORIGIN, "attach_origin", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_CUSTOMORIGIN, "attach_origin", target:GetAbsOrigin(), true)

	EmitSoundOn("Hero_PhantomAssassin.CoupDeGrace", target)	
end

function courtyard_summoner_think(event)
	local summonPointTable = {Vector(-512, 9600), Vector(57, 10352), Vector(356, 10598), Vector(1031, 9982), Vector(687, 9411)}
	local ability = event.ability
	local caster = event.caster
	if caster.aggro and caster.state == 0 then
		caster.state = 1
		EmitGlobalSound("clinkz_clinkz_laugh_08")
	end
	local soundTable = {"clinkz_clinkz_laugh_01", "clinkz_clinkz_laugh_02", "clinkz_clinkz_laugh_03", "clinkz_clinkz_laugh_04", "clinkz_clinkz_laugh_05", "clinkz_clinkz_laugh_06"}
	local currentHealth = caster:GetHealth()
	local maxHealth = caster:GetMaxHealth()
	if caster.state == 1 then
		caster.state = 2
		EmitSoundOn("Hero_Pugna.LifeDrain.Target", caster)
		EmitGlobalSound("Hero_Pugna.LifeDrain.Target")
		StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_3, rate=0.7})
		local unitTable = {"castle_skeleton_warrior", "castle_skeleton_archer"}
		for i = 1, #summonPointTable, 1 do
			for j = 1, 3, 1 do
				Timers:CreateTimer(0.9*j, function()
					position = summonPointTable[i]
					
					local skeleton = Dungeons:SpawnDungeonUnit(unitTable[RandomInt(1,#unitTable)], position, 1, 0, 0, nil, nil, true, nil)
					createSummonParticle(position, caster, skeleton)
					if j == 1 then
						EmitSoundOn("Hero_Pugna.NetherWard.Attack.Wight", skeleton)	
					end
				end)
			end		
		end
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_summoner_shield", {duration = 9})
	elseif caster.state == 2 and currentHealth < maxHealth*0.8 then
		caster.state = 3
		EmitSoundOn("Hero_Pugna.LifeDrain.Target", caster)
		EmitGlobalSound("Hero_Pugna.LifeDrain.Target")
		StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_3, rate=0.7})
		local unitTable = {"castle_skeleton_mage", "castle_skeleton_archer"}
		for i = 1, #summonPointTable, 1 do
			for j = 1, 3, 1 do
				Timers:CreateTimer(0.5*j, function()
					position = summonPointTable[i]
					
					local skeleton = Dungeons:SpawnDungeonUnit(unitTable[RandomInt(1,#unitTable)], position, 1, 0, 0, nil, nil, true, nil)
					createSummonParticle(position, caster, skeleton)
					EmitSoundOn("Hero_Pugna.NetherWard.Attack.Wight", skeleton)	
				end)
			end		
		end
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_summoner_shield", {duration = 9})
	elseif caster.state == 3 and currentHealth < maxHealth*0.6 then
		caster.state = 4
		EmitSoundOn("Hero_Pugna.LifeDrain.Target", caster)
		EmitGlobalSound("Hero_Pugna.LifeDrain.Target")
		StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_3, rate=0.7})
		local unitTable = {"castle_skeleton_mage", "castle_skeleton_archer", "castle_skeleton_warrior"}
		for i = 1, #summonPointTable, 1 do
			for j = 1, 3, 1 do
				Timers:CreateTimer(0.5*j, function()
					position = summonPointTable[i]
					
					local skeleton = Dungeons:SpawnDungeonUnit(unitTable[RandomInt(1,#unitTable)], position, 1, 0, 0, nil, nil, true, nil)
					createSummonParticle(position, caster, skeleton)
					EmitSoundOn("Hero_Pugna.NetherWard.Attack.Wight", skeleton)	
				end)
			end		
		end
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_summoner_shield", {duration = 9})
	elseif caster.state == 4 and currentHealth < maxHealth*0.4 then
		caster.state = 5
		EmitSoundOn("Hero_Pugna.LifeDrain.Target", caster)
		EmitGlobalSound("Hero_Pugna.LifeDrain.Target")
		StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_3, rate=0.7})
		local unitTable = {"castle_skeleton_mage", "castle_skeleton_archer", "castle_ghost", "castle_skeleton_warrior"}
		for i = 1, #summonPointTable, 1 do
			for j = 1, 4, 1 do
				Timers:CreateTimer(0.5*j, function()
					position = summonPointTable[i]
					
					local skeleton = Dungeons:SpawnDungeonUnit(unitTable[RandomInt(1,#unitTable)], position, 1, 0, 0, nil, nil, true, nil)
					createSummonParticle(position, caster, skeleton)
					EmitSoundOn("Hero_Pugna.NetherWard.Attack.Wight", skeleton)	
				end)
			end		
		end
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_summoner_shield", {duration = 9})
	end

	local luck = RandomInt(1, 6)
	if luck == 1 then
	EmitSoundOn(soundTable[RandomInt(1, #soundTable)], caster)
	end
	caster.interval = caster.interval + 1
	if caster.interval >= 5 and caster.aggro and caster.state <= 5 then
		EmitSoundOn("Hero_Spectre.HauntCast", caster)
		StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_3, rate=0.9})
		caster.interval = 0
		for i = -7, 7, 1 do
			local fv = WallPhysics:rotateVector(caster:GetForwardVector(), math.pi/7*i)
			createSummonerProjectile(caster:GetAbsOrigin()+Vector(0,0,120), fv, caster, ability)
		end
	end

end

function createSummonerProjectile(spellOrigin, forward, caster, ability)
	
	local info = 
	{
		Ability = ability,
        	EffectName = "particles/units/heroes/hero_alchemist/epoch_rune_a_d_concoction_projectile.vpcf",
        	vSpawnOrigin = spellOrigin,
        	fDistance = 1450,
        	fStartRadius = 120,
        	fEndRadius = 120,
        	Source = caster,
        	StartPosition = "attach_hitloc",
        	bHasFrontalCone = true,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 7.0,
		bDeleteOnHit = false,
		vVelocity = forward * 500,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
end

function summoner_projectile_hit(event)
	local target = event.target
	local caster = event.caster
	local sound = "Hero_Pugna.NetherBlast"
    local particleName =  "particles/units/heroes/hero_pugna/pugna_netherblast.vpcf"
    local particleVector = targetPoint
    local radius = 200
      local pfx = ParticleManager:CreateParticle( particleName, PATTACH_POINT, caster )
      ParticleManager:SetParticleControl( pfx, 0, target:GetAbsOrigin() )
      ParticleManager:SetParticleControl( pfx, 1, Vector(radius, radius, radius) )
        Timers:CreateTimer(0.8, function() 
          ParticleManager:DestroyParticle( pfx, false )
        end)  
        EmitSoundOn(sound, target)
	local damage = Events:GetAdjustedAbilityDamage(5000, 15000, 0)
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
	PopupDamage(target, damage)
end

function createSummonParticle(position, caster, target)
	local particleName = "particles/units/heroes/hero_pugna/pugna_ward_attack.vpcf"
    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(pfx,0,caster:GetAbsOrigin()+Vector(0,0,200))   
    ParticleManager:SetParticleControl(pfx,1,position+Vector(0,0,822))
	Timers:CreateTimer(3.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	particleName = "particles/econ/items/pugna/pugna_ward_ti5/pugna_ward_lightning.vpcf"
	local pfx2 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(pfx2,0,caster:GetAbsOrigin()+Vector(0,0,200))   
    ParticleManager:SetParticleControl(pfx2,1,position+Vector(0,0,822))
	Timers:CreateTimer(3.5, function()
		ParticleManager:DestroyParticle(pfx2, false)
	end)		
end

function undertaker_think(event)
	local caster = event.caster
	if not caster.interval then
		caster.interval = 0
	end
	if not caster.aggro and caster.interval%2 == 0 then
		StartAnimation(caster, {duration=1.5, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.7})
	end
	caster.interval = caster.interval + 1
	if caster.interval >= 4 then
		caster.interval = 0
	end
	local pulse = caster:FindAbilityByName("undertaker_death_pulse")
	if caster.aggro and pulse:IsFullyCastable() then
		local order =
		{
			UnitIndex = caster:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = pulse:entindex(),
		}
		ExecuteOrderFromTable(order)	
	end	
end

function undertaker_die(event)
	local caster = event.caster
	EmitSoundOn("necrolyte_necr_death_04", caster)
	local luck = RandomInt(1, 4)
	if luck == 1 then
		RPCItems:RollUndertakersHood(caster:GetAbsOrigin(), false)
	end
end

function summoner_trueform_think(event)
	local caster = event.caster
	local luck = RandomInt(1,9)
	if luck == 1 then
		EmitSoundOn("undying_undying_fleshgolem_15", caster)
	elseif luck == 2 then
		EmitSoundOn("undying_undying_fleshgolem_14", caster)
	end
end

function summoner_trueform_die(event)
	local caster = event.caster
	Dungeons.summonerTrueFormCount = Dungeons.summonerTrueFormCount + 1
	local position = caster:GetAbsOrigin()
	if Dungeons.summonerTrueFormCount >=16 then
		Dungeons:CastleStageFour()

		local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")

		local visionTracer = CreateUnitByName("npc_flying_dummy_vision", position, true, nil, nil, DOTA_TEAM_GOODGUYS)
		visionTracer:AddAbility("dummy_unit"):SetLevel(1)
		visionTracer:AddNewModifier( visionTracer, nil, 'modifier_movespeed_cap', nil )
		visionTracer:SetBaseMoveSpeed(900)
	    Timers:CreateTimer(1.2, function()
			for i = 1, #MAIN_HERO_TABLE, 1 do
				local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
				if playerID then
					gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, MAIN_HERO_TABLE[i], "modifier_disable_player", {duration = 6})
					MAIN_HERO_TABLE[i]:Stop()
					PlayerResource:SetCameraTarget(playerID, visionTracer)
				end
			end
		end)
		Timers:CreateTimer(1.8, function()
			visionTracer:MoveToPosition(Vector(-5312, 10752))
		end)
		Timers:CreateTimer(3.2, function()
			ParticleManager:DestroyParticle(Dungeons.wallParticle, false)
			EmitGlobalSound("Conquest.Stinger.HulkCreep")
			UTIL_Remove(Dungeons.blocker1)
			UTIL_Remove(Dungeons.blocker2)
			UTIL_Remove(Dungeons.blocker3)
			Dungeons.blocker1 = nil
			Dungeons.blocker2 = nil
			Dungeons.blocker3 = nil
			Timers:CreateTimer(4.8, function()
				EmitGlobalSound("Conquest.poison.hallow_scream")
			end)
		end)
		Timers:CreateTimer(6.2, function()
			for i = 1, #MAIN_HERO_TABLE, 1 do
				local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
				if playerID then
					MAIN_HERO_TABLE[i]:RemoveModifierByName("modifier_disable_player")
					PlayerResource:SetCameraTarget(playerID, MAIN_HERO_TABLE[i])
				end
			end
		end)
		Timers:CreateTimer(6.8, function()
			for i = 1, #MAIN_HERO_TABLE, 1 do
				local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
				if playerID then
					PlayerResource:SetCameraTarget(playerID, nil)
				end
				EmitGlobalSound("abaddon_abad_attack_09")
			end
		end)		
	end
end

function castle_boss_think(event)
	local boss = event.caster
  	local ability = event.ability
	if not boss.deathStart then
	  	boss.momentum = boss.momentum*1.01
	  	local bossPos = boss:GetAbsOrigin()
	  	if bossPos.y < 12664 and bossPos.x > Dungeons.castleCenter.x then
	  		boss.direction = 1
	  		boss.momentum = 1
	  	elseif bossPos.y < 12664 and bossPos.x < Dungeons.castleCenter.x then
	    	boss.direction = -1
	  		boss.momentum = 1
	  	end
	    boss.circlePos = (WallPhysics:rotateVector(boss.circlePos, boss.direction*(math.pi/720)*boss.momentum)):Normalized()
	  	boss:SetAbsOrigin(Dungeons.castleCenter+Dungeons.castleRadius*boss.circlePos)
	  	local bossFV = (Dungeons.castleCenter - bossPos):Normalized()
	  	boss:SetForwardVector(bossFV)
	  	boss.interval = boss.interval + 1
	  	if boss.interval % 60 == 0 then
	  		castleBossAttack(boss)
	  	end
	  	if boss.interval > 240 then
	  		boss.interval = 0
	  		boss.direction = boss.direction*-1
	  		boss.momentum = 1
	  	end
	  	local currentHealth = boss:GetHealth()
	  	local maxHealth = boss:GetMaxHealth()
	  	if currentHealth < maxHealth*0.65 then
	  		boss.slowPools = 1
	  	elseif currentHealth < maxHealth*0.35 then
	  		boss.slowPools = 2
	  	end
	  	if boss.slowPools > 0 then
	  		local modCheck = 40/boss.slowPools
	  		if boss.interval % modCheck == 0 then
	  			local position = Dungeons.castleCenter+RandomInt(80,Dungeons.castleRadius)*RandomVector(1)
	  			ability:ApplyDataDrivenThinker(boss, position, "castle_boss_slow_pool", {duration = 5})
	  		end

	  	end
 	end
end

function avernusSlow(event)
    local soundTable = {"abaddon_abad_laugh_03", "abaddon_abad_laugh_04", "abaddon_abad_laugh_05"}
	EmitGlobalSound(soundTable[RandomInt(1, #soundTable)])
end
function castleBossAttack(boss)
	-- local luck = RandomInt(1, 3)
	-- if luck == 1 then
		local soundTable = {"abaddon_abad_pain_01", "abaddon_abad_pain_02", "abaddon_abad_pain_03", "abaddon_abad_pain_04", "abaddon_abad_pain_05", "abaddon_abad_pain_06", "abaddon_abad_pain_07", "abaddon_abad_pain_08", "abaddon_abad_pain_09"}
		EmitSoundOn(soundTable[RandomInt(1, #soundTable)], Dungeons.eyeDummy)
	-- end
	Timers:CreateTimer(0.24, function()
		EmitGlobalSound("Hero_Abaddon.PreAttack")
	end)
	StartAnimation(boss, {duration=2.3, activity=ACT_DOTA_ATTACK, rate=0.5})
	Timers:CreateTimer(0.92, function()
		local enemies = FindUnitsInLine( boss:GetTeamNumber(), boss:GetAbsOrigin(),  boss:GetAbsOrigin()+boss:GetForwardVector()*400, nil, 260, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, FIND_ANY_ORDER )
		for _,enemy in pairs(enemies) do
			EmitSoundOn("Hero_Abaddon.Attack", enemy)
			local damage = Events:GetAdjustedAbilityDamage(280000, 500000, 5000000)
			ApplyDamage({ victim = enemy, attacker = boss, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL })
			PopupDamage(enemy, damage)
			local target = enemy
			local particleName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
			local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
			ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_CUSTOMORIGIN, "follow_origin", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_CUSTOMORIGIN, "follow_origin", target:GetAbsOrigin(), true)
		end	
	end)
end

function effectHit(event)
	local random_one = RandomInt(1, #Dungeons.effectDummyTable)
	local random_two = RandomInt(1, #Dungeons.effectDummyTable)
	if random_one == random_two then
		random_two = random_two + 1
		if random_two > #Dungeons.effectDummyTable then
			random_two = 1
		end
	end

end

function castleEffectThink(event)
	local luck = RandomInt(1, 6)
	local ability = event.ability
	if luck == 1 then
		local random_one = RandomInt(1, #Dungeons.effectDummyTable)
		local random_two = RandomInt(1, #Dungeons.effectDummyTable)
		if random_one == random_two then
			random_two = random_two + 1
			if random_two > #Dungeons.effectDummyTable then
				random_two = 1
			end
		end
		local unit1 = Dungeons.effectDummyTable[random_one]
		local unit2 = Dungeons.effectDummyTable[random_two]
		local forward = (unit2:GetAbsOrigin() - unit1:GetAbsOrigin()):Normalized()*Vector(1,1,0)
		local spellOrigin = unit1:GetAbsOrigin()+Vector(0,0,150)
		local info = 
		{
			Ability = ability,
	        	EffectName = "particles/units/heroes/hero_skeletonking/hellfireblast_linear.vpcf",
	        	vSpawnOrigin = spellOrigin,
	        	fDistance = 5000,
	        	fStartRadius = 10,
	        	fEndRadius = 10,
	        	Source = unit1,
	        	StartPosition = "attach_origin",
	        	bHasFrontalCone = false,
	        	bReplaceExisting = false,
	        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	        	fExpireTime = GameRules:GetGameTime() + 7.0,
			bDeleteOnHit = false,
			vVelocity = forward * 800,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)	
	end
end

function castle_eye_think(event)
	local caster = event.caster
	if caster.active == true then
		local ability = event.ability
		local position = caster:GetAbsOrigin()
		if caster.interval % 3 == 0 then
			caster.interval = 0
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, 260, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			if #enemies > 0 then
				local damage = Events:GetAdjustedAbilityDamage(1100, 4000, 0)
				for _,enemy in pairs(enemies) do
				    local particleName = "particles/items_fx/castle_boss_wall_beam.vpcf"
				    local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
				    local casterPos = enemy:GetAbsOrigin()   
			    	for i = 1, 5, 1 do
				    	Timers:CreateTimer(0.08*i, function()	
				    		ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })    	
					    	EmitSoundOn("Hero_ArcWarden.Flux.Target", caster)
					    	local unit = enemy
					    	EmitSoundOn("Hero_ArcWarden.SparkWraith.Activate", caster)
				            local origin = caster:GetAbsOrigin()
				            local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
				            ParticleManager:SetParticleControl(lightningBolt,0,Vector(casterPos.x,casterPos.y,casterPos.z+80))   
				            ParticleManager:SetParticleControl(lightningBolt,1,Vector(origin.x,origin.y,origin.z+150))
				        end)
				        PopupDamage(enemy, damage)
		        	end	
				end
			end 
		end
		caster.interval = caster.interval + 1
		if WallPhysics:GetDistance(position,Dungeons.castleCenter) > Dungeons.castleRadius then
			caster.forward = WallPhysics:rotateVector(caster.forward, math.pi/RandomInt(3, 5))
			caster.stuck = caster.stuck + 1
		else
			caster.stuck = 0
		end

		local newPos = position+caster.forward*30
		if caster.stuck >= 10 then
			newPos = Vector(-5225, 13180, 700)
		end
		caster:SetAbsOrigin(newPos) 
		ParticleManager:DestroyParticle(Dungeons.EyeParticle, false)
		ParticleManager:ReleaseParticleIndex(Dungeons.EyeParticle)
		local particleName = "particles/dire_fx/avernus_eye_ambient.vpcf"
		Dungeons.EyeParticle = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN, Dungeons.avernusBoss )
		ParticleManager:SetParticleControl( Dungeons.EyeParticle, 0, newPos-Vector(0,0,100) )
		if caster.interval > 100 then
			caster.interval = 0
		end
	end
end