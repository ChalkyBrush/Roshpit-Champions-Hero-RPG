require('heroes/crystal_maiden/init')

function start_channel(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Sorceress.Tornado.VO", caster)
	local runeCheckEntity = caster
	if caster.origCaster then
		runeCheckEntity = caster.origCaster
	end
	ability.r_1_level = runeCheckEntity:GetRuneValue("r", 1)
	ability.r_2_level = runeCheckEntity:GetRuneValue("r", 2)
	ability.r_3_level = runeCheckEntity:GetRuneValue("r", 3)
	ability.r_4_level = runeCheckEntity:GetRuneValue("r", 4)

	if caster:HasModifier("modifier_clear_cast") then
		event.noSound = true
		channel_complete(event)
		caster:Stop()
		ability:EndCooldown()
		local cooldown = Filters:GetCDNoHood(caster, 0.7)
		ability:StartCooldown(cooldown)
	end
end

function owner_die(event)
	local caster = event.caster
	local ability = event.ability
	if ability.tornadoTable then
		for i = 1, #ability.tornadoTable, 1 do
			ability.tornadoTable[i]:RemoveModifierByName("modifier_tornado_thinker")
		end
	end
end

function channel_complete(event)
	local caster = event.caster
	local ability = event.ability
	local baseFV = caster:GetForwardVector()
	local runeCheckEntity = caster
	if caster.origCaster then
		runeCheckEntity = caster.origCaster
	end
	ability.r_1_level = runeCheckEntity:GetRuneValue("r", 1)
	caster.r_2_level = runeCheckEntity:GetRuneValue("r", 2)
	ability.r_3_level = runeCheckEntity:GetRuneValue("r", 3)
	ability.r_4_level = runeCheckEntity:GetRuneValue("r", 4)

	if not ability.tornadoTable then
		ability.tornadoTable = {}
	end
	Timers:CreateTimer(0.05, function()
		StartAnimation(caster, {duration=1.1, activity=ACT_DOTA_ATTACK, rate=1.6}) 
	end)
	local startPoint = event.target_points[1]
	ability.velocity = 1000
	ability.rotationDelta = 20
	DeepPrintTable(event.target_points)
	print(startPoint)
	local distance = WallPhysics:GetDistance2d(startPoint, caster:GetAbsOrigin())
	ability.velocity = distance*1
	if event.noSound then
		local luck = RandomInt(1,3)
		if luck == 1 then
			EmitSoundOn("Sorceress.TornadoCast.VO", caster)
		end
	else
		EmitSoundOn("Sorceress.TornadoCast.VO", caster)
	end
	
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Sorceress.IceTornadoStart", caster)

	local bAvatar = false
	local casterOrigin = caster:GetAbsOrigin()
	if caster:HasModifier("modifier_sorceress_immortal_fire_avatar") then
		caster = caster.origCaster
		bAvatar = true
	end
	if ability.r_4_level > 0 then
		local avatarDuration = Filters:GetAdjustedBuffDuration(caster, 7 + 0.2*ability.r_4_level, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_ice_avatar", {duration = avatarDuration})
		caster:SetModifierStackCount("modifier_ice_avatar", caster, ability.r_4_level)
	end

		local dummy = CreateUnitByName("npc_dummy_unit", casterOrigin, false, nil, nil, caster:GetTeamNumber())
		ability:ApplyDataDrivenModifier(caster, dummy, "modifier_tornado_thinker", {duration = 14})
		local projectileFV = ((startPoint-casterOrigin)*Vector(1,1,0)):Normalized()
		local tornadoParticle = "particles/roshpit/sorceress/ice_tornado_arcana_tornado_ti6.vpcf"
		if caster:HasModifier("modifier_sorceress_glyph_7_1") then
			tornadoParticle = "particles/roshpit/sorceress/chaos_tornado_arcana_tornado_ti6.vpcf"
		end
		local pfx = ParticleManager:CreateParticle(tornadoParticle, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, casterOrigin)
		-- ParticleManager:SetParticleControl(pfx, 1, Vector(ability.velocity, ability.velocity, ability.velocity))
		-- ParticleManager:SetParticleControl(pfx, 1, startPoint)
		-- ParticleManager:SetParticleControl(pfx, 2, Vector(ability.velocity, ability.velocity, ability.velocity))

		ParticleManager:SetParticleControlEnt(pfx, 1, dummy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", dummy:GetAbsOrigin(), true)
		if caster:HasModifier("modifier_clear_cast") then
			ability.clearcast = true
			dummy.e_3_amp = caster:GetRuneValue("e", 3)
		else
			ability.clearcast = false
		end
		dummy.pfx = pfx
		dummy.interval = 0
		dummy.dummy = true
		dummy.pullPoint = casterOrigin+projectileFV*1300+Vector(0,0,80)
		dummy.baseFV = projectileFV
		dummy.hardInterval = 0
		dummy.velocity = ability.velocity
		dummy.position = casterOrigin
		dummy.targetPosition = startPoint
		dummy.newTarget = startPoint
		dummy.atPoint = false
		table.insert(ability.tornadoTable, dummy)
		local max_tornados = event.max_tornados
		if bAvatar then
			max_tornados = 3
		end
		print(max_tornados)
		if #ability.tornadoTable > max_tornados then
			ability.tornadoTable[1]:RemoveModifierByName("modifier_tornado_thinker")
		end
		Timers:CreateTimer(1, function()
			EmitSoundOn("Sorceress.TornadoLP", dummy)
		end)
	Filters:CastSkillArguments(4, caster)
end

function channel_interrupt(event)
end

function tornado_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local dummy = target
	if not IsValidEntity(ability) then
		return false
	end
	dummy.interval = dummy.interval + 1
	dummy.hardInterval = dummy.hardInterval + 1
	if dummy.hardInterval == 140 then
		EmitSoundOnLocationWithCaster(dummy:GetAbsOrigin(), "Sorceress.TornadoLP", caster)
	elseif  dummy.hardInterval == 240 then
		EmitSoundOnLocationWithCaster(dummy:GetAbsOrigin(), "Sorceress.TornadoLP", dummy)
	elseif  dummy.hardInterval == 360 then
		EmitSoundOnLocationWithCaster(dummy:GetAbsOrigin(), "Sorceress.TornadoLP", caster)
	end
	dummy:SetAbsOrigin(dummy:GetAbsOrigin()+dummy.velocity*0.03*dummy.baseFV)
	dummy:SetAbsOrigin(GetGroundPosition(dummy:GetAbsOrigin(), caster))
	local distance = WallPhysics:GetDistance2d(dummy:GetAbsOrigin(), dummy.newTarget)
	dummy.velocity = math.max(dummy.velocity - 15, 300)
	if dummy.atPoint then
		if dummy.interval%5 == 0 then
			AddFOWViewer(caster:GetTeamNumber(), dummy:GetAbsOrigin(), 400, 1, false)
			dummy.baseFV = WallPhysics:rotateVector(dummy.baseFV, 2*math.pi/10)
			dummy.newTarget = dummy.targetPosition + dummy.baseFV*500
		end
	else

		if distance < 100 then
			dummy.atPoint = true
		end
	end
	if ability.r_1_level > 0 then
		if dummy.interval%15 == 0 then
			local radius = 600 + 3*ability.r_1_level
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), dummy:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		    if #enemies > 0 then
		        local enemy = enemies[1]
				local info = 
				{
					Target = enemy,
					Source = dummy,
					Ability = ability,	
					EffectName = "particles/units/heroes/hero_winter_wyvern/wyvern_splinter_blast.vpcf",
					vSourceLoc= dummy:GetAbsOrigin()+Vector(0,0,RandomInt(80, 140)),
					bDrawsOnMinimap = false, 
				        bDodgeable = true,
				        bIsAttack = false, 
				        bVisibleToEnemies = true,
				        bReplaceExisting = false,
				        flExpireTime = GameRules:GetGameTime() + 10,
					bProvidesVision = true,
					iVisionRadius = 0,
					iMoveSpeed = 900,
					iVisionTeamNumber = caster:GetTeamNumber()
				}
				projectile = ProjectileManager:CreateTrackingProjectile(info)	   
		    end		
		end
	end
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), dummy:GetAbsOrigin(), nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
    if #enemies > 0 then
        for _,enemy in pairs(enemies) do
        	if enemy.pushLock or enemy.jumpLock then
        	else
	        	local pullVector = ((dummy:GetAbsOrigin()-enemy:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	        	local distance = WallPhysics:GetDistance2d(dummy:GetAbsOrigin(), enemy:GetAbsOrigin())
	        	local pullSpeed = math.max(3, 10 - distance/10)
	        	enemy:SetAbsOrigin(enemy:GetAbsOrigin()+pullVector*pullSpeed)
	        end
        end
    end
end

function splinter_hit(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	if caster:HasModifier("modifier_sorceress_immortal_fire_avatar") then
		caster = caster.origCaster
	end
	local damage = caster:GetIntellect()*7*ability.r_1_level
	if caster:HasModifier("modifier_sorceress_glyph_7_1") then
		damage = damage*1.5
	end
	local luck = RandomInt(1, 100)
	if ability.r_2_level > 0  and luck < ARCANA1_R2_CHANCE then
		damage = damage * (1 + ARCANA1_R2_CRIT_DAMAGE/100 * ability.r_2_level)
		local durationWithoutImmune = ARCANA1_R2_START_DURATION + ARCANA1_R2_ADD_DURATION * ability.r_2_level
		if Immune.shouldApplyImmune(caster, target, 'modifier_sorceress_arcana_b_d', durationWithoutImmune) then
			Immune.applyImmune(caster, target, ability, 'modifier_sorceress_arcana_b_d', ARCANA1_R2_IMMUNE_DURATION)
		elseif not Immune.targetHasImmune(target, 'modifier_sorceress_arcana_b_d') and not target:HasModifier('modifier_sorceress_arcana_b_d_visible') then
			Immune.addEffectDuration(caster, target, ability, 'modifier_sorceress_arcana_b_d', 1)
			ability:ApplyDataDrivenModifier(caster, target, 'modifier_sorceress_arcana_b_d_visible', {duration = 1})
			EmitSoundOn("Sorceress.IceTornadoShard.Freeze", caster)
		end
		CustomAbilities:QuickAttachParticle("particles/roshpit/sorceress/ice_lance_fracture.vpcf", target, 0.3)
	end
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_ICE, RPC_ELEMENT_NONE)
end

-- function begin_lance_from_tornado(event)
-- 	local caster = event.caster
-- 	local ability = event.ability

-- 	--Timers:CreateTimer(0.3,function()
-- 	local target = event.target
-- 	local dummy = event.dummy
-- 	EmitSoundOn("Sorceress.IceLance", dummy)
-- 	local fv = ((target-dummy:GetAbsOrigin())*Vector(1,1,0)):Normalized()
-- 	local casterOrigin = dummy:GetAbsOrigin()
-- 	local bArcane = sorceressGetArcaneDB(caster)

-- 	launch_lance(caster, fv, ability, "particles/econ/items/mirana/mirana_crescent_arrow/sorceress_ice_lance.vpcf", casterOrigin, 120)
-- 	if bArcane then
-- 		launch_lance(caster, fv, caster:FindAbilityByName("sorceress_blink"), "particles/roshpit/sorceress/arcane_enchantment.vpcf", casterOrigin+Vector(0,0,80), 90)
-- 	end
-- 	-- caster.q_4_level = Runes:GetTotalRuneLevel(caster, 4, "q_4", "sorceress")
-- 	-- Filters:CastSkillArguments(1, caster)
-- 	--end)
-- 	-- StartAnimation(caster, {duration=0.4, activity=ACT_DOTA_CAST_ABILITY_2, rate=2.0})
-- 	-- "modifier_arcane_enchantment"

-- end

function tornado_thinker_end(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local pfx = target.pfx
	Timers:CreateTimer(0.03, function()
		UTIL_Remove(target)
		reindexEnergyTable(ability)
	end)
	Timers:CreateTimer(1.5, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:ReleaseParticleIndex(pfx)
	end)
end

function tornado_damage_end(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
end

function tornado_damage_think(event)
	local caster = event.caster
	local target = event.target
	local damage = event.damage
	local ability = event.ability
	if caster:HasModifier("modifier_sorceress_glyph_7_1") then
		damage = damage*1.5
	end
	if caster:HasModifier("modifier_clear_cast") then
		if ability.e_3_amp then
			damage = damage + damage*ability.e_3_amp
		end
	elseif ability.clearcast then
		if ability.e_3_amp then
			damage = damage + damage*ability.e_3_amp
		end		
	end
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_ICE, RPC_ELEMENT_WIND)
	if ability.r_3_level > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_tornado_ice_resist_loss_visible", {duration = 3})
		local newStacks = target:GetModifierStackCount("modifier_tornado_ice_resist_loss_visible", caster) + 1
		target:SetModifierStackCount("modifier_tornado_ice_resist_loss_visible", caster, newStacks)

		ability:ApplyDataDrivenModifier(caster, target, "modifier_tornado_ice_resist_loss_invisible", {duration = 3})
		target:SetModifierStackCount("modifier_tornado_ice_resist_loss_invisible", caster, newStacks*ability.r_3_level)
	end
end

function reindexEnergyTable(ability)
	local newTable = {}
	for i = 1, #ability.tornadoTable, 1 do
		if IsValidEntity(ability.tornadoTable[i]) then
			table.insert(newTable, ability.tornadoTable[i])
		end
	end
	ability.tornadoTable = newTable
end

function ice_avatar_start(event)
	local caster = event.caster
	local ability = event.ability
	if not ability.wingsPFX then
		local avatarDuration = Filters:GetAdjustedBuffDuration(caster, 7 + 0.2*ability.r_4_level, false)
		ability.wingsPFX = ParticleManager:CreateParticle("particles/roshpit/sorceress/ice_avatar_wings_omni_omni.vpcf", PATTACH_POINT_FOLLOW, caster)
		for i = 0, 4, 1 do
			ParticleManager:SetParticleControlEnt(ability.wingsPFX, i, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		end
		ParticleManager:SetParticleControlEnt(ability.wingsPFX, 5, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(ability.wingsPFX, 7, Vector(avatarDuration, avatarDuration, avatarDuration))
	end
end

function ice_avatar_end(event)
	local caster = event.caster
	local ability = event.ability
	if ability.wingsPFX then
		ParticleManager:DestroyParticle(ability.wingsPFX, false)
		ParticleManager:ReleaseParticleIndex(ability.wingsPFX)
		ability.wingsPFX = false
	end
end