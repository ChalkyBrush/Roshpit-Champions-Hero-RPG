function charons_phase_start(event)
	local caster = event.caster
	EmitSoundOn("Chernobog.CharonsPreCast", caster)
end

function charons_claw_cast(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	EmitSoundOn("Chernobog.CharonsClaw", caster)
	ability.rune_a_a_level = Runes:GetTotalRuneLevel(caster, 1, "a_a", "chernobog")
	ability.b_a_level = Runes:GetTotalRuneLevel(caster, 2, "b_a", "chernobog")
	ability.c_a_level = Runes:GetTotalRuneLevel(caster, 3, "c_a", "chernobog")
	ability.d_a_level = Runes:GetTotalRuneLevel(caster, 4, "d_a", "chernobog")
	local projectileParticle = "particles/roshpit/chernobog/charons_clawpectral_dagger.vpcf"
	local casterOrigin = caster:GetAbsOrigin()
	local range = event.range
	local speed = 800
	local fv = ((target - casterOrigin)*Vector(1,1,0)):Normalized()
	local info = 
	{
			Ability = ability,
        	EffectName = projectileParticle,
        	vSpawnOrigin = casterOrigin-fv*80,
        	fDistance = range,
        	fStartRadius = 180,
        	fEndRadius = 180,
        	Source = caster,
        	StartPosition = "attach_origin",
        	bHasFrontalCone = false,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = false,
		vVelocity = fv * speed,
		bProvidesVision = true,
		iVisionRadius = 500,
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)	
	ability.damage = event.damage

	local thinkers = math.floor(range/100) - 2
	local pathDuration = Filters:GetAdjustedBuffDuration(caster, 12, false)
	for i = 1, thinkers, 1 do
		Timers:CreateTimer(i*0.12, function()
			local thinkerPos = GetGroundPosition(casterOrigin + fv*100*(i-1) + fv*80, caster)
			local obstruction = WallPhysics:FindNearestObstruction(thinkerPos)
			local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, thinkerPos, caster)
			print(thinkerPos)
			if obstruction then
				print(obstruction:GetAbsOrigin())
			end
			print(blockUnit)
			print("-------")
			if not blockUnit then
				ability:ApplyDataDrivenThinker(caster, thinkerPos, "modifier_charons_claw_path", {duration = pathDuration})
			end
			if i == (thinkers - 2) then
				AddFOWViewer(caster:GetTeamNumber(), thinkerPos + fv*200, 400, 3, false)
			end
		end)
	end

	Filters:CastSkillArguments(1, caster)
end

function claw_projectile_hit(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = ability.damage
	if caster:HasModifier("modifier_chernobog_glyph_3_1") then
		local procession = caster:GetAbilityByIndex(DOTA_ULTIMATE_SLOT)
		local cdRemaining = procession:GetCooldownTimeRemaining()
		if cdRemaining > 0 then
			local newCD = math.max(0, cdRemaining - 0.5)
			procession:EndCooldown()
			procession:StartCooldown(newCD)
		end
	end
	EmitSoundOn("Chernobog.CharonsClawImpact", target)
	-- ability:ApplyDataDrivenModifier(caster, target, "modifier_charons_claw_enemy", {duration = 8})
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_DEMON, RPC_ELEMENT_SHADOW)
end

function charon_impacted_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local duration = Filters:GetAdjustedBuffDuration(caster, 12, false)
	ability:ApplyDataDrivenThinker(caster, target:GetAbsOrigin(), "modifier_charons_claw_path", {duration = duration})
end

function claw_path_apply(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if caster:GetEntityIndex() == target:GetEntityIndex() then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_charons_claw_caster", {})
		if ability.c_a_level > 0 then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_charons_claw_c_a", {})
			caster:SetModifierStackCount("modifier_charons_claw_c_a", caster, ability.c_a_level)
		end
		if ability.d_a_level > 0 then

			ability:ApplyDataDrivenModifier(caster, caster, "modifier_chernobog_rune_d_a_attack", {})
			local bonusAttack = 0.1*caster:GetAgility()*ability.d_a_level
			caster:SetModifierStackCount("modifier_chernobog_rune_d_a_attack", caster, bonusAttack)
			
		end
	end
	if caster:GetTeamNumber() == target:GetTeamNumber() then
	else
		print("CHARONS??")
		ability:ApplyDataDrivenModifier(caster, target, "modifier_charons_claw_enemy", {})
		if ability.rune_a_a_level > 0 then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_charons_claw_rune_a_a_effect", {})
			target:SetModifierStackCount("modifier_charons_claw_rune_a_a_effect", caster, ability.rune_a_a_level)
		end
		if caster:HasModifier("modifier_chernobog_glyph_4_1") then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_charons_claw_glyph_4", {})
			target:SetModifierStackCount("modifier_charons_claw_glyph_4", caster, ability.rune_a_a_level)
		end
	end
end

function claw_path_end(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	target:RemoveModifierByName("modifier_charons_claw_caster")
	target:RemoveModifierByName("modifier_charons_claw_enemy")
	target:RemoveModifierByName("modifier_charons_claw_rune_a_a_effect")
	target:RemoveModifierByName("modifier_chernobog_rune_d_a_attack")
	target:RemoveModifierByName("modifier_charons_claw_glyph_4")
	target:RemoveModifierByName("modifier_charons_claw_c_a")
end

function charons_claw_rune_a_a_stay_still_end(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if target:HasModifier("modifier_charons_claw_enemy") then
		if ability.rune_a_a_level > 0 then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_charons_claw_rune_a_a_effect", {})
			target:SetModifierStackCount("modifier_charons_claw_rune_a_a_effect", caster, ability.rune_a_a_level)
		end
	end
end

function charons_claw_a_a_move(event)
	local target = event.unit
	local ability = event.ability
	local caster = event.caster
	if caster:HasModifier("modifier_chernobog_glyph_4_1") then
	else
		target:RemoveModifierByName("modifier_charons_claw_rune_a_a_effect")
		ability:ApplyDataDrivenModifier(caster, target, "modifier_charons_claw_rune_a_a_waiting_to_stay_still", {duration = 0.2})
	end

end

function charons_claw_enemy_think(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if ability.b_a_level > 0 then
		local damage = ability.b_a_level*700
		CustomAbilities:QuickAttachParticle("particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void_hit_body_flash.vpcf", target, 2)
		Filters:ApplyDotDamage(caster, ability, target, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_DEMON, RPC_ELEMENT_SHADOW)
	end
end

function flying_charons_think(event)
	local caster = event.caster
	local newPos = caster:GetAbsOrigin()+caster:GetForwardVector()*100
	local obstruction = WallPhysics:FindNearestObstruction(caster:GetAbsOrigin())
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPos, caster)
	if blockUnit then
		caster:SetAbsOrigin(caster:GetAbsOrigin()-caster:GetForwardVector()*100)
		caster:RemoveModifierByName("modifier_charons_claw_flying_portion")
	end
end

