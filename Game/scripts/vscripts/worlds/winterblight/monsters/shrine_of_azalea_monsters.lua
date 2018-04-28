function maiden_armor_init(event)
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_maiden_armor", {})
	caster:SetModifierStackCount("modifier_maiden_armor", caster, event.charges)
end

function shrine_maiden_think(event)
	local caster = event.caster
	if not caster:IsAlive() then
		return false
	end
	if caster.aggro then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			local hookAbility = caster:FindAbilityByName("azalea_crystal_nova")
			if hookAbility:IsFullyCastable() then
				local targetPoint = enemies[1]:GetOrigin() + RandomVector(RandomInt(80, 320))			
				local order =
				{
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = hookAbility:entindex(),
					Position = targetPoint
				}
				ExecuteOrderFromTable(order)
				return false
			end
		end
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			local hookAbility = caster:FindAbilityByName("azalea_maiden_frostbite")
			if hookAbility:IsFullyCastable() then		
				local order = {
				 		UnitIndex = caster:entindex(), 
				 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				 		TargetIndex = enemies[1]:entindex(),
				 		AbilityIndex = hookAbility:entindex(),
			 	}
				ExecuteOrderFromTable(order)
				return false
			end
		end
	end
end

function master_crystal_think(event)
	local caster = event.caster
	if not caster.interval then
		caster.interval = 0
	end
	caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,2)*math.cos(2*math.pi*caster.interval/180))
	caster.interval = caster.interval + 1
	local rotatedFV = WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi/180)
	caster:SetForwardVector(rotatedFV)
	if caster.interval == 180 then
		caster.interval = 0 
	end
	for i = 1, #Winterblight.AzaleaCrystalTable, 1 do
		local crystal = Winterblight.AzaleaCrystalTable[i]
		crystal:SetAbsOrigin(crystal:GetAbsOrigin()+Vector(0,0,0.8)*math.cos(2*math.pi*caster.interval/180))
		local rotatedFV = WallPhysics:rotateVector(crystal:GetForwardVector(), 2*math.pi/180)
		crystal:SetForwardVector(rotatedFV)
	end
end

function reset_crystal_puzzle(event)
	local caster = event.caster
	print("HELLO?")
	if caster.locked or caster:HasModifier("modifier_crystal_finished") then
		return false
	end
	for i = 1, #Winterblight.AzaleaCrystalTable, 1 do
		local crystal = Winterblight.AzaleaCrystalTable[i]
		if crystal.pfx then
			ParticleManager:DestroyParticle(crystal.pfx, false)
		end
		UTIL_Remove(crystal)
	end
	UTIL_Remove(Winterblight.MasterCrystal)
	local crystalPosTable = {Vector(10496, -11008), Vector(10496, -11960), Vector(11776, -11960), Vector(11776, -11008)}
	Winterblight.AzaleaCrystalTable = {}
	Winterblight.tripleSwitchCount = 0
	for i = 1, 4, 1 do
		Winterblight:SpawnAzaleaCrystal(crystalPosTable[i], i)
	end
	Winterblight:SpawnMasterAzaleaCrystal()
	EmitSoundOn("Winterblight.AzaleaCrystal.PuzzleReset", Winterblight.MasterCrystal)
end

function zefnar_attack_land(event)
	local attacker = event.attacker
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local duration = 0.4
	if attacker.mainZefnar then
		duration = 0.8
	end
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 340, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
	EmitSoundOn("Winterblight.Zefnar.AttackLand", target)
	CustomAbilities:QuickAttachParticle("particles/roshpit/winterblight/zefnar_hit.vpcf", target, 3)
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			ApplyDamage({ victim = enemy, attacker = caster, damage = event.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })	
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_zefnar_root", {duration = duration})
		end
	end 
end

function zefnar_madman_go(event)
	local caster = event.caster
	local ability = event.ability
	if caster.mainZefnar and caster.aggro then
		caster.interval = 0
		if not caster.minis then
			caster.minis = 0
		end
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_disable_player", {})
		StartAnimation(caster, {duration=1.9, activity=ACT_DOTA_CAST_ABILITY_6, rate=0.9})
		EmitSoundOn("Winterblight.Zefnar.LifterVO", caster)
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.Zefnar.Lifter", caster)
		CustomAbilities:QuickAttachParticle("particles/roshpit/winterblight/zefnar_hit.vpcf", caster, 3)
	end
end

function zefnar_madman_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.interval < 60 then
		caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,20))
	elseif caster.interval >= 60 and caster.interval < 180 then
		if caster.interval%20 == 0 then
			local explodeParticle = "particles/roshpit/solunia/lunar_flare_explosion_immortal1.vpcf"
			local castParticle ="particles/roshpit/solunia/comet_cast_moon.vpcf"

			local position = GetGroundPosition(caster:GetAbsOrigin()+RandomVector(RandomInt(0, 1000)), caster)
			local pfx = ParticleManager:CreateParticle(castParticle, PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
			Timers:CreateTimer(4, function()
				ParticleManager:DestroyParticle(pfx, false)
				ParticleManager:ReleaseParticleIndex(pfx)
			end)
			local damage = event.damage
			EmitSoundOnLocationWithCaster(position, "Winterblight.Zefnar.CometLaunch", caster)
			CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/zefnar_meteor_attack.vpcf", position, 4)
			Timers:CreateTimer(0.45, function()
				local pfx2 = ParticleManager:CreateParticle("particles/roshpit/winterblight/zefnar_hit.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(pfx2, 0, position)
				Timers:CreateTimer(4, function()
					ParticleManager:DestroyParticle(pfx2, false)
					ParticleManager:ReleaseParticleIndex(pfx2)
				end)
				local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, 260, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
				if #enemies > 0 then
					for _,enemy in pairs(enemies) do
						ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })
						Filters:ApplyStun(caster, 1.5, enemy)
					end
				end 
				if caster.minis < 12 then
					local mini = Winterblight:SpawnMiniZefnar(position, RandomVector(1))
					mini:SetDeathXP(0)
					mini:SetMaximumGoldBounty(0)
					mini:SetMinimumGoldBounty(0)
					caster.minis = caster.minis + 1
					mini.cometMini = true
					mini.mainCaster = caster
				end
			end)
		end
	else
		caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,20))
		if caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster) < 20 then
			caster:RemoveModifierByName("modifier_disable_player")
		end
	end
	caster.interval = caster.interval + 1
end

function zefnar_die(event)
	local caster = event.caster
	local ability = event.ability
	if caster.cometMini then
		caster.mainCaster.minis = caster.mainCaster.minis - 1
	end
	if caster.mainZefnar then
		EmitSoundOn("Winterblight.Zefnar.Death", caster)
		for i = 1, 50, 1 do
			Timers:CreateTimer(0.03*i, function()
				Winterblight.AzaleaSwitchMathProp:SetAbsOrigin(Winterblight.AzaleaSwitchMathProp:GetAbsOrigin()-Vector(0,0,30))
			end)
		end
		Timers:CreateTimer(1.5, function()
			CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/zefnar_hit.vpcf", Winterblight.AzaleaSwitchMathProp:GetAbsOrigin(), 3)
			EmitSoundOnLocationWithCaster(Winterblight.AzaleaSwitchMathProp:GetAbsOrigin(), "Winterblight.Zefnar.SpawnMini", Events.GameMaster)
			Winterblight.AzaleaSwitch1Dropped = true
		end)
	end
end

function syphist_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if target:IsHero() then
		local selfRegen = caster:FindModifierByNameAndCaster("modifier_syphist_regen", caster)
		local enemyRegen = target:FindModifierByNameAndCaster("modifier_syphist_regen_opponent", caster)
		if not selfRegen then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_syphist_regen", {duration = 4.5})
		else
			selfRegen:SetDuration(4.5, true)
		end
		if not enemyRegen then
			EmitSoundOn("Winterblight.SyphistSteal", target)
			ability:ApplyDataDrivenModifier(caster, target, "modifier_syphist_regen_opponent", {duration = 4.5})
			local beamPFX = ParticleManager:CreateParticle("particles/roshpit/ekkan/cast_beams_beams.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(beamPFX, 0, target:GetAbsOrigin())
			ParticleManager:SetParticleControl(beamPFX, 1, caster:GetAbsOrigin())
			Timers:CreateTimer(3, function()
				ParticleManager:DestroyParticle(beamPFX, false)
				ParticleManager:ReleaseParticleIndex(beamPFX)
			end)
		else
			enemyRegen:SetDuration(4.5, true)
		end
		local selfRegen = caster:FindModifierByNameAndCaster("modifier_syphist_regen", caster)
		local enemyRegen = target:FindModifierByNameAndCaster("modifier_syphist_regen_opponent", caster)
		if enemyRegen then
			enemyRegen:IncrementStackCount()
		end
		if selfRegen then
			selfRegen:SetStackCount(enemyRegen:GetStackCount())
		end
	end
end