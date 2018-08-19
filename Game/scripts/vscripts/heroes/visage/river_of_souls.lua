function river_of_souls_start(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]

	if caster.corpseExplosionIndex == 0 then
		point = WallPhysics:WallSearch(caster:GetAbsOrigin(), point, caster)
		if not ability.portalTable then
			ability.portalTable = {}
		end
		local particleName = "particles/roshpit/ekkan/ekkan_portal.vpcf"
		local portalPFX = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
		local portalPosition = point - Vector(0,0,10)
		ParticleManager:SetParticleControl(portalPFX, 0, portalPosition)
		ParticleManager:SetParticleControl(portalPFX, 1, Vector(5,5,5))
		if #ability.portalTable == 0 then
			ability.portalTable[1] = ability:ApplyDataDrivenThinker(caster, point, "modifier_river_of_souls_thinker", {})
			ability.portalTable[1].pfx = portalPFX
			ability.portalTable[1].position = portalPosition
			ability.portalTable[1].visionDummy = CreateUnitByName("npc_flying_dummy_vision", portalPosition, false, nil, nil, caster:GetTeamNumber())
			ability.portalTable[1].visionDummy:FindAbilityByName("dummy_unit"):SetLevel(1)
		elseif #ability.portalTable == 1 then
			ability.portalTable[2] = ability:ApplyDataDrivenThinker(caster, point, "modifier_river_of_souls_thinker", {})
			ability.portalTable[2].pfx = portalPFX
			ability.portalTable[2].position = portalPosition
			ability.portalTable[2].visionDummy = CreateUnitByName("npc_flying_dummy_vision", portalPosition, false, nil, nil, caster:GetTeamNumber())
			ability.portalTable[2].visionDummy:FindAbilityByName("dummy_unit"):SetLevel(1)
		elseif #ability.portalTable == 2 then
			ParticleManager:DestroyParticle(ability.portalTable[1].pfx, false)
			UTIL_Remove(ability.portalTable[1].visionDummy)
			UTIL_Remove(ability.portalTable[1])
			local newPortalTable = {}
			newPortalTable[1] = ability.portalTable[2]
			newPortalTable[2] = ability:ApplyDataDrivenThinker(caster, point, "modifier_river_of_souls_thinker", {})
			newPortalTable[2].pfx = portalPFX
			newPortalTable[2].position = portalPosition
			newPortalTable[2].visionDummy = CreateUnitByName("npc_flying_dummy_vision", portalPosition, false, nil, nil, caster:GetTeamNumber())
			newPortalTable[2].visionDummy:FindAbilityByName("dummy_unit"):SetLevel(1)
			ability.portalTable = newPortalTable
		end
		EmitSoundOnLocationWithCaster(portalPosition, "Ekkan.RiverOfSouls.Cast", caster)
		GridNav:DestroyTreesAroundPoint(portalPosition, 220, false)
		local beamPFX = ParticleManager:CreateParticle("particles/roshpit/ekkan/cast_beams_beams.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(beamPFX, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(beamPFX, 1, portalPosition)
		Timers:CreateTimer(3, function()
			ParticleManager:DestroyParticle(beamPFX, false)
			ParticleManager:ReleaseParticleIndex(beamPFX)
		end)
		local b_c_level = Runes:GetTotalRuneLevel(caster, 2, "e_2", "ekkan")
		if b_c_level > 0 then
			SummonFamiliar(caster, ability, portalPosition, b_c_level)
		end
		if caster:HasModifier("modifier_ekkan_glyph_2_1") then
			for i = 1, 5, 1 do
				local corpse = CreateUnitByName("ekkan_corpse", portalPosition, false, nil, nil, DOTA_TEAM_NEUTRALS)
				local summonSkeletonAbility = caster:FindAbilityByName("ekkan_summon_skeleton")
				summonSkeletonAbility:ApplyDataDrivenModifier(caster, corpse, "modifier_ekkan_skeleton_corpse", {duration = 30})
				corpse.jumpEnd = "basic_dust"
				corpse:SetForwardVector(RandomVector(1))
				corpse.hp = caster:GetMaxHealth()
				corpse.attackpower = caster:GetAverageTrueAttackDamage(caster)
				WallPhysics:Jump(corpse, RandomVector(1), RandomInt(8, 12), RandomInt(16,18), 32, 1)
			end
		end
	else
		EmitSoundOn("Ekkan.CorpseExplosion.Cast", caster)
		local a_c_level = Runes:GetTotalRuneLevel(caster, 1, "e_1", "ekkan")
		local targetCorpse = EntIndexToHScript(caster.corpseExplosionIndex)
		ability.corpseDamage = targetCorpse.hp*0.05*a_c_level
		local range = 700 + a_c_level*5
		local beamPFX = ParticleManager:CreateParticle("particles/roshpit/ekkan/cast_beams_beams.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(beamPFX, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(beamPFX, 1, targetCorpse:GetAbsOrigin())
		Timers:CreateTimer(3, function()
			ParticleManager:DestroyParticle(beamPFX, false)
			ParticleManager:ReleaseParticleIndex(beamPFX)
		end)
		targetCorpse.disable = true
		Timers:CreateTimer(0.2, function()
			EmitSoundOn("Ekkan.CorpseExplosion.Explosion", targetCorpse)
			EmitSoundOnLocationWithCaster(targetCorpse:GetAbsOrigin(), "Ekkan.CorpseExplosion.Blood", caster)
			local bloodPFX = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_bloody.vpcf", PATTACH_CUSTOMORIGIN, caster)

			ParticleManager:SetParticleControl(bloodPFX, 0, targetCorpse:GetAbsOrigin())
			ParticleManager:SetParticleControl(bloodPFX, 1, targetCorpse:GetAbsOrigin())
			Timers:CreateTimer(3, function()
				ParticleManager:DestroyParticle(bloodPFX, false)
				ParticleManager:ReleaseParticleIndex(bloodPFX)
			end)
			for i = -4, 4, 1 do
				local fv = WallPhysics:rotateVector(targetCorpse:GetForwardVector(), math.pi/4*i)
				create_corpse_projectile(targetCorpse:GetAbsOrigin()+Vector(0,0,60), fv, caster, ability, range)
			end
			UTIL_Remove(targetCorpse)
		end)
	end
	Filters:CastSkillArguments(3, caster)
end

function SummonFamiliar(caster, ability, portalPosition, b_c_level)
		local maxFamiliars = 2
		local familiar = CreateUnitByName("ekkan_familiar", portalPosition, false, nil, nil, caster:GetTeamNumber())
		familiar:SetControllableByPlayer(caster:GetPlayerOwnerID(), false)
		familiar:SetOwner(caster)

		local familiarArmor = caster:GetPhysicalArmorValue()*0.1*b_c_level
		familiar:SetPhysicalArmorBaseValue(familiarArmor)
		local attackDamage =  math.min(caster:GetAverageTrueAttackDamage(caster)*0.2*b_c_level, (2^31)-10)
		
		familiar:SetBaseDamageMin(attackDamage)
		familiar:SetBaseDamageMax(attackDamage)
		if not ability.familiarTable then
			ability.familiarTable = {}
		end
		local familiarHealth = math.floor(caster:GetMaxHealth()*0.5)
	    familiar:SetMaxHealth(familiarHealth)
	    familiar:SetBaseMaxHealth(familiarHealth)
	    familiar:SetHealth(familiarHealth)	
	    familiar.ekkan_unit = true
	    familiar.hero = caster
		table.insert(ability.familiarTable, familiar)
	    if caster:HasModifier("modifier_ekkan_glyph_6_1") then
	    	maxFamiliars = maxFamiliars + 1
	    end
		if #ability.familiarTable > maxFamiliars then
			if IsValidEntity(ability.familiarTable[1]) then
				ability.familiarTable[1]:ForceKill(false)
			end
		end
		reindexFamiliarTable(ability)
		StartAnimation(familiar, {duration=1.0, activity=ACT_DOTA_SPAWN, rate=0.6})
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_visage/visage_stone_form.vpcf", familiar, 3)
		
			
		familiar:SetAcquisitionRange(1500)
		familiar.e_3_level = Runes:GetTotalRuneLevel(caster, 3, "e_3", "ekkan")
		familiar.e_4_level = Runes:GetTotalRuneLevel(caster, 4, "e_4", "ekkan")

		if familiar.e_4_level > 0 then
			familiar:AddAbility("ekkan_familiar_stoneform"):SetLevel(1)
		end
		familiar.stance = "aggressive"
		familiar:AddAbility("ekkan_creep_aggressive"):SetLevel(1)
		familiar.owner = caster:GetPlayerOwnerID()
		if caster:HasModifier("modifier_ekkan_immortal_weapon_2") then
			familiar:SetOriginalModel("models/creeps/bat_spitter/bat_spitter.vmdl")
			familiar:SetModel("models/creeps/bat_spitter/bat_spitter.vmdl")
			caster.weapon:ApplyDataDrivenModifier(caster.InventoryUnit, familiar, "modifier_ekkan_immortal_weapon2_gargoyle", {})
		end
end

function reindexFamiliarTable(ability)
	local newTable = {}
	for i = 1, #ability.familiarTable, 1 do
		if IsValidEntity(ability.familiarTable[i]) then
			if ability.familiarTable[i]:IsAlive() then
				table.insert(newTable, ability.familiarTable[i])
			end
		end
	end
	ability.familiarTable = newTable
end

function river_of_souls_teleport(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	target:RemoveModifierByName("modifier_river_of_souls_teleporting")
	if #ability.portalTable > 1 then
		local distance1 = WallPhysics:GetDistance2d(target:GetAbsOrigin(), ability.portalTable[1].position)
		local distance2 = WallPhysics:GetDistance2d(target:GetAbsOrigin(), ability.portalTable[2].position)
		if distance1 > distance2 then
			FindClearSpaceForUnit(target, ability.portalTable[1].position, false)
		else
			FindClearSpaceForUnit(target, ability.portalTable[2].position, false)
		end
		PlayerResource:SetCameraTarget(target:GetPlayerOwnerID(), target)
		Timers:CreateTimer(0.5, function()
			PlayerResource:SetCameraTarget(target:GetPlayerOwnerID(), nil)
		end)
	end
	EmitSoundOn("Ekkan.RiverOfSouls.Teleport", target)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_river_of_souls_immune", {duration = 2.0})
	Timers:CreateTimer(0.1, function()
		CustomAbilities:QuickAttachParticle("particles/roshpit/ekkan/unit_teleport_loadout.vpcf", target, 3)
	end)
	teleportAllUnits(target)
end

function river_of_souls_thinker_create(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if #ability.portalTable > 1 then
		if not target:HasModifier("modifier_river_of_souls_immune") then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_river_of_souls_teleporting", {duration = 3.0})
		end
	end
end

function river_teleporting_start(event)
	local target = event.target
	local ability = event.ability
	if not target:HasModifier("modifier_river_of_souls_immune") then
		EmitSoundOn("Ekkan.RiverOfSouls.TeleportingStart", target)
	end
end

function teleportAllUnits(target)
	if target:GetUnitName() == "npc_dota_hero_visage" then
		local dominionAbility = target:FindAbilityByName("ekkan_dominion")
		if target:HasAbility("ekkan_arcana_black_dominion") then
			dominionAbility = target:FindAbilityByName("ekkan_arcana_black_dominion")
		end
		if dominionAbility.dominionTable then
			for i = 1, #dominionAbility.dominionTable, 1 do
				FindClearSpaceForUnit(dominionAbility.dominionTable[i], target:GetAbsOrigin()+RandomVector(RandomInt(60, 200)), false)
				Timers:CreateTimer(0.1, function()
					CustomAbilities:QuickAttachParticle("particles/roshpit/ekkan/unit_teleport_loadout.vpcf", dominionAbility.dominionTable[i], 3)
				end)
			end
		end
		local skeleAbility = target:FindAbilityByName("ekkan_summon_skeleton")
		if skeleAbility.skeleTable then
			for i = 1, #skeleAbility.skeleTable, 1 do
				FindClearSpaceForUnit(skeleAbility.skeleTable[i], target:GetAbsOrigin()+RandomVector(RandomInt(60, 200)), false)
				Timers:CreateTimer(0.1, function()
					CustomAbilities:QuickAttachParticle("particles/roshpit/ekkan/unit_teleport_loadout.vpcf", skeleAbility.skeleTable[i], 3)
				end)
			end
		end
		local riverAbility = target:FindAbilityByName("ekkan_river_of_souls")
		if riverAbility.familiarTable then
			for i = 1, #riverAbility.familiarTable, 1 do
				FindClearSpaceForUnit(riverAbility.familiarTable[i], target:GetAbsOrigin()+RandomVector(RandomInt(60, 200)), false)
				Timers:CreateTimer(0.1, function()
					CustomAbilities:QuickAttachParticle("particles/roshpit/ekkan/unit_teleport_loadout.vpcf", riverAbility.familiarTable[i], 3)
				end)
			end
		end
	end
end

function create_corpse_projectile(spellOrigin, forward, caster, ability, range)
	
	local info = 
	{
		Ability = ability,
        	EffectName = "particles/roshpit/ekkan/corpse_explosion.vpcf",
        	vSpawnOrigin = spellOrigin,
        	fDistance = range,
        	fStartRadius = 130,
        	fEndRadius = 130,
        	Source = caster,
        	StartPosition = "attach_hitloc",
        	bHasFrontalCone = true,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 7.0,
		bDeleteOnHit = false,
		vVelocity = forward * 1200,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
end

function corpse_projectile_hit(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability

	local blastParticle = ParticleManager:CreateParticle("particles/roshpit/ekkan/mage_blast.vpcf", PATTACH_CUSTOMORIGIN, hero)
	ParticleManager:SetParticleControl(blastParticle, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(blastParticle, 1, Vector(200, 1, 200))
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 220, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, ability.corpseDamage, DAMAGE_TYPE_MAGICAL, 3, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_NONE)
		end
	end 
	
	EmitSoundOn("Ekkan.CorpseExplosion.Impact", target)
end

function familiar_attack_land(event)
	local attacker = event.attacker
	local hero = attacker.hero
	local ability = event.ability
	local target = event.target
	if attacker.e_3_level > 0 then
		ability:ApplyDataDrivenModifier(attacker, target, "modifier_familiar_armor_break", {duration = 12})
		target:SetModifierStackCount("modifier_familiar_armor_break", attacker, attacker.e_3_level)
	end
end

function familiar_stone_form(event)
	local ability = event.ability
	local caster = event.caster
	local stun_duration = caster.e_4_level*0.25
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_familiar_stoneform_effect", {duration = 6.2})
	StartAnimation(caster, {duration=6.2, activity=ACT_DOTA_CAST_ABILITY_1, rate=1.0})
	Timers:CreateTimer(0.7, function()
		if IsValidEntity(caster) then
			if caster:IsAlive() then
				EmitSoundOn("Ekkan.Familiar.StoneForm", caster)
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_familiar_stoneform", {duration = 5.2})
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_familiar_stoneform_regen", {duration = 5.2})
				caster:SetModifierStackCount("modifier_familiar_stoneform_regen", caster, caster.e_4_level)
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_visage/visage_stone_form.vpcf", caster, 3)
				local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 240, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
				if #enemies > 0 then
					for _,enemy in pairs(enemies) do
						Filters:ApplyStun(caster.hero, stun_duration, enemy)
					end
				end 
			end
		end
	end)
end

function stone_form_end(event)
	local caster = event.caster
	caster.rising = true
	Timers:CreateTimer(0.3, function()
		if IsValidEntity(caster) then
			caster.rising = false
		end
	end)
end

function stone_form_thinking(event)
	local caster = event.caster
	if caster.rising then
		caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,6))
	else
		if caster:GetAbsOrigin().z + 120 > GetGroundHeight(caster:GetAbsOrigin(), caster) then
			caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,4))
		end
	end
end