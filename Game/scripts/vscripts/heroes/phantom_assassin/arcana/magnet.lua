function blazing_magnet_precast(event)
	local caster = event.caster
	StartAnimation(caster, {duration=0.15, activity=ACT_DOTA_ATTACK_EVENT, rate=2.2})
	
end

function blazing_magnet_cast(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	local perpVector = WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi/4)
	local spellStartPoint = caster:GetAbsOrigin()+Vector(0,0,70) + perpVector*80
	local fv = ((point-spellStartPoint)*Vector(1,1,0)):Normalized()
	local solidFV = fv

	local range = event.cast_range
	local q_3_level = caster:GetRuneValue("q", 3)
	local procs = Runes:Procs(q_3_level, 10, 1) + 1
	EmitSoundOn("Voltex.MagnetWindUp", caster)
	local delay = 0
	for i = 1, procs, 1 do
		local magnet_start_point = spellStartPoint
		local direction = 1
		if i%2 == 0 then
			direction = -1
			magnet_start_point = spellStartPoint + solidFV*range
		end
		if i > 1 then
			delay = delay + range/(1300 + i*200)
		end

		Timers:CreateTimer(delay, function()

			send_magnet(i, magnet_start_point, direction, range, caster, fv, ability)
		end)
	end

	local buffDuration = 5
    if caster:HasModifier("modifier_voltex_glyph_1_1") then
        local ability = event.ability
        caster:RemoveModifierByName("modifier_voltex_glyph_1_1_effect")
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_voltex_glyph_1_1_effect", {duration = buffDuration})
    end
    if caster:HasModifier("modifier_voltex_glyph_2_1") then
        local ability = event.ability
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_voltex_glyph_2_1_effect_visible", {duration = buffDuration})
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_voltex_glyph_2_1_effect_invisible", {duration = buffDuration})
        Timers:CreateTimer(0.03, function()
            local agility = caster:GetBaseAgility()
            caster:SetModifierStackCount( "modifier_voltex_glyph_2_1_effect_invisible", ability, agility)
        end)
    end

	Filters:CastSkillArguments(1, caster)
end

function send_magnet(index, startPoint, direction, range, caster, fv, ability)
	local particle = "particles/econ/items/zeus/lightning_weapon_fx/voltex_ultimmortal_lightning.vpcf"
	local start_radius = 155
	local end_radius = 155
	local speed = 1300 + index*200
	
	local casterOrigin = caster:GetAbsOrigin()
	if index == 1 then
		EmitSoundOn("Voltex.MagnetLaunch", caster)
	else
		EmitSoundOnLocationWithCaster(startPoint, "Voltex.MagnetLaunch2", caster)
	end
	local info = 
	{
			Ability = ability,
        	EffectName = particle,
        	vSpawnOrigin = startPoint,
        	fDistance = range,
        	fStartRadius = start_radius,
        	fEndRadius = end_radius,
        	Source = caster,
        	StartPosition = "attach_hand_l",
        	bHasFrontalCone = true,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
		vVelocity = fv*Vector(1,1,0)*direction * speed,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
	if not ability.target_table then
		ability.target_table = {}
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_voltex_magnet", {})
	local travelDuration = range/speed + 0.05
	if caster:HasModifier("modifier_magnet_travelling") then
		travelDuration = math.max(travelDuration, caster:FindModifierByName("modifier_magnet_travelling"):GetDuration())
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_magnet_travelling", {duration = range/speed + 0.05})
end

function magnet_hit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local damage = event.damage
	EmitSoundOn("Voltex.MagnetImpact", target)
	local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/mountain_protector/blue_steel_dagon_tgt_sparks_lvl2_ti5.vpcf", target, 3)
	ParticleManager:SetParticleControl(pfx, 1, target:GetAbsOrigin()+Vector(0,0,50))
	local freeze_duration = event.freeze_duration
	if not target.dummy then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_magnet_freeze", {duration = freeze_duration})
		if ability.target_table then
			table.insert(ability.target_table, target)
		end
		local q_4_level = caster:GetRuneValue("q", 4)
		local d_a_duration = Filters:GetAdjustedBuffDuration(caster, q_4_level*0.1, false)
		if q_4_level > 0 then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_magnet_d_d", {duration = d_a_duration})
		end
	end
end

function magnet_thinker(event)
	local caster = event.caster
	local ability = event.ability
	if ability.target_table then
		if not caster:IsAlive() then
			ability.target_table = {}
		end
		if #ability.target_table > 0 then
			local target = ability.target_table[1]
			table.remove(ability.target_table, 1)
			if IsValidEntity(target) and target:IsAlive() then
				local q_2_level = caster:GetRuneValue("q", 2)
				local procs = Runes:Procs(q_2_level, 1, 1)
				if procs > 0 then
					Filters:CleanseStuns(caster)
					Filters:CleanseSilences(caster)
				end
				local ogPosition = caster:GetAbsOrigin()
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_disable_player", {duration = 0.12})
				local tpRange = math.min(caster:Script_GetAttackRange(), 320)
				local targetPosition = target:GetAbsOrigin()+RandomVector(1)*tpRange
				caster:SetAbsOrigin(GetGroundPosition(targetPosition, caster))
				local fv = ((target:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
				caster:SetForwardVector(fv)
				EmitSoundOn("Voltex.MagnetTeleport", caster)
				Events:CreateLightningBeam(ogPosition+Vector(0,0,50), caster:GetAbsOrigin()+Vector(0,0,50))
				Timers:CreateTimer(0.05, function()
					StartAnimation(caster, {duration=0.1, activity=ACT_DOTA_ATTACK, rate=2.1})
					Filters:PerformAttackSpecial(caster, target, true, true, true, false, true, false, false)
					if not caster:HasModifier("modifier_voltex_rune_r_3_avatar") then
						EmitSoundOn("Voltex.MagnetAttack", target)
					end
				end)
			end
		else
			if not caster:HasModifier("modifier_magnet_travelling") then
				ability.target_table = false
			end
		end
	else
		if not caster:HasModifier("modifier_magnet_travelling") then
			caster:RemoveModifierByName("modifier_voltex_magnet")
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
			local q_4_level = caster:GetRuneValue("q", 4)
			local d_a_duration = Filters:GetAdjustedBuffDuration(caster, q_4_level*0.1, false)
			if q_4_level > 0 then
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_magnet_d_d", {duration = d_a_duration})
			end
			caster:RemoveModifierByName("modifier_voltex_glyph_1_1_effect")
			caster:RemoveModifierByName("modifier_voltex_glyph_2_1_effect_visible")
			caster:RemoveModifierByName("modifier_voltex_glyph_2_1_effect_invisible")
		end
	end
end

function magnet_attack_land(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local attacker = event.attacker
	local q_1_level = caster:GetRuneValue("q", 1)
	if not ability.particleCount then
		ability.particleCount = 0
	end
	if q_1_level > 0 then
		magnet_bolt(attacker, attacker, ability, target, q_1_level)
		local procs = Runes:Procs(q_1_level, 10, 1)
		local enemyCount = 0 + procs
		if enemyCount > 0 then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			enemyCount = math.min(enemyCount, #enemies)
			if #enemies > 0 then	
				for i = 1, enemyCount, 1 do
					if i == 1 then
						magnet_bolt(attacker, target, ability, enemies[1], q_1_level)
					else
						magnet_bolt(attacker, enemies[i-1], ability, enemies[i], q_1_level)
					end
				end				
			end 
		end
	end
end

function magnet_bolt(attacker, bolt_origin, ability, target, q_1_level)
	if IsValidEntity(target) and target:IsAlive() then
		if ability.particleCount < 14 then
		    local lightningBolt = ParticleManager:CreateParticle("particles/roshpit/voltex/overcharge_lightning_attack.vpcf", PATTACH_WORLDORIGIN, attacker)
		    ParticleManager:SetParticleControl(lightningBolt,0,Vector(bolt_origin:GetAbsOrigin().x,bolt_origin:GetAbsOrigin().y,bolt_origin:GetAbsOrigin().z + bolt_origin:GetBoundingMaxs().z ))   
		    ParticleManager:SetParticleControl(lightningBolt,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
		    -- ApplyDamage({ victim = target, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
		    Timers:CreateTimer(2, function()
		        ParticleManager:DestroyParticle(lightningBolt, true)
		    end)
		    ability.particleCount = ability.particleCount + 1
		    Timers:CreateTimer(0.5, function()
		    	ability.particleCount = ability.particleCount - 1
		    end)
		end
	    local damage = q_1_level*OverflowProtectedGetAverageTrueAttackDamage(attacker)*0.15
	    Filters:TakeArgumentsAndApplyDamage(target, attacker, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
	end
end

function magnet_slide_think(event)
	local caster = event.caster
	local ability = event.ability
	local position = caster:GetAbsOrigin()
	position = GetGroundPosition( position, caster )

	local newPosition = position+caster:GetForwardVector()*ability.pushSpeed
	local afterWallPosition = WallPhysics:WallSearch(caster:GetAbsOrigin(), newPosition, caster)

	if afterWallPosition == newPosition then
		if not caster:HasModifier("modifier_disable_player") then
			caster:SetOrigin(newPosition)
		end
	end
	ability.pushSpeed = ability.pushSpeed - 1.25
	if ability.pushSpeed <= 1 then
		caster:RemoveModifierByName("modifier_arcana2_dash")
	end
end

function magnet_slide_end(event)
	local caster = event.caster
	local ability = event.ability
	Timers:CreateTimer(0.03, function()
		if not caster:HasModifier("modifier_disable_player") then
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		end
	end)	
end