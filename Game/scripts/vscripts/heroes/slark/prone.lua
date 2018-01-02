require('heroes/slark/constants')

function prone_start(event)
	local caster = event.caster
	local ability = event.ability
	local duration = 3
	ability.a_a_level = Runes:GetTotalRuneLevelGeneric(caster, 1, 0)
	if caster:HasModifier("modifier_slipfinn_basic_jump") and caster:GetAbsOrigin().z > GetGroundHeight(caster:GetAbsOrigin(), caster) + 90 then
		caster.speed = 0
		caster:RemoveModifierByName("modifier_slipfinn_basic_jump")
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_slipfinn_buttstomp", {duration = 3})
		caster.fallSpeed = 0
		
		EmitSoundOn("Slipfinn.GroundPound.Start.VO", caster)
		EmitSoundOn("Slipfinn.PoundWoosh", caster)
		local height = caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster)
		if height > 320 then
			EmitSoundOn("Slipfinn.PoundWooshStart2", caster)
		else
			EmitSoundOn("Slipfinn.PoundWooshStart1", caster)
		end
		ability:StartCooldown(1.5)
		Filters:CastSkillArguments(1, caster)
		local delay = 0.4
		local animDur = 0.37
		local animRate = 1.6
		if caster:HasModifier("modifier_slipfinn_glyph_4_1") then
			delay = delay*SLIPFINN_GLYPH_4_1_POUND_DELAY_MULT
			animDur = animDur*SLIPFINN_GLYPH_4_1_POUND_DELAY_MULT
			animRate = animRate/SLIPFINN_GLYPH_4_1_POUND_DELAY_MULT
		end
		StartAnimation(caster, {duration=animDur, activity=ACT_DOTA_SLARK_POUNCE, rate=animRate})
		Timers:CreateTimer(delay, function()
			caster.fallSpeed = 35
			StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_DIE, rate=1.3})
			ability.stompSound = true
			ability.magnitude = 1
			
			if height > 640 then
				ability.magnitude = 3
			elseif height > 320 then
				ability.magnitude = 2
			end
			ability.height = height
			print(height)
		end)
	else
		if not caster:HasModifier("modifier_slipfinn_prone") then
			if caster:FindAbilityByName("slipfinn_shadow_rush"):IsInAbilityPhase() or caster:IsChanneling() then
			else
				local order =
				{
					UnitIndex = caster:entindex(),
					OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
					Position = caster:GetAbsOrigin()
				}
				ExecuteOrderFromTable(order)
				caster.rightClickPos = nil
			end
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_slipfinn_prone", {duration = duration})
			EmitSoundOn("Slipfinn.Prone", caster)
			CustomAbilities:AddAndOrSwapSkill(caster, "slipfinn_shadow_rush", "slipfinn_shadow_warp", 2)
			print("APPLY PRONE")
			local b_a_level = Runes:GetTotalRuneLevelGeneric(caster, 2, 0)
			if b_a_level > 0 then
				caster:RemoveModifierByName("modifier_shimmer_cape")
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_shimmer_cape", {duration})
				caster:SetModifierStackCount("modifier_shimmer_cape", caster, b_a_level)
			end
		end
	end
end

function buttstomp_think(event)
	local caster = event.caster
	local ability = event.ability
	if caster.fallSpeed > 0 then
		caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,caster.fallSpeed))
		caster.fallSpeed = math.min(caster.fallSpeed + 1, 60)
		if caster:GetAbsOrigin().z <= GetGroundHeight(caster:GetAbsOrigin(), caster)+math.abs(caster.fallSpeed) then
			caster:RemoveModifierByName("modifier_slipfinn_buttstomp")
			stomp(caster, ability, event.damage)
		elseif ability.stompSound then
			if caster:GetAbsOrigin().z <= GetGroundHeight(caster:GetAbsOrigin(), caster)+math.abs(caster.fallSpeed*4) then
				EmitSoundOn("Slipfinn.Watersmash"..ability.magnitude, caster)
			end
		end
	end
end

function stomp(caster, ability, damage)
	local position = caster:GetAbsOrigin()
	local pfx = ParticleManager:CreateParticle( "particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, position )
	ParticleManager:SetParticleControl( pfx, 1, Vector(200, 200, 200) )
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)

	local radius = math.min(math.max(ability.height, 120), 1500)
	local splitEarthParticle = "particles/roshpit/slipfinn_pound.vpcf"
	local pfx = ParticleManager:CreateParticle( splitEarthParticle, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, position )
	ParticleManager:SetParticleControl( pfx, 1, Vector(radius, radius, radius) )
	
	local damageBonus = ability.a_a_level*SLIPFINN_Q1_DISTANCE_BONUS
	local heightBonus = 0
	local c_a_level = Runes:GetTotalRuneLevelGeneric(caster, 3, 0)
	if c_a_level > 0 then
		heightBonus = SLIPFINN_Q3_HEIGHT_SQ_MULT*c_a_level*(ability.height^2)
	end
	local stun_duration = 0.3
	if caster:HasModifier("modifier_slipfinn_glyph_5_1") then
		stun_duration = SLIPFINN_GLYPH_5_1_STUN_DURATION
	end
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius+5, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			local distancePercentage = 1 - (WallPhysics:GetDistance2d(enemy:GetAbsOrigin(), position)/radius)
			damage2 = (damage + heightBonus)*(1 + damageBonus*distancePercentage)
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage2, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_WATER, RPC_ELEMENT_NORMAL)
			Filters:ApplyStun(caster, stun_duration, enemy)	
		end
	end 
	if ability.magnitude == 2 then
		ScreenShake(caster:GetAbsOrigin(), 300, 0.3, 0.3, 9000, 0, true)	
	elseif ability.magnitude == 3 then
		ScreenShake(caster:GetAbsOrigin(), 600, 1, 1, 9000, 0, true)
	end
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
end

function prone_end(event)
	local caster = event.caster
	local ability = event.ability
	CustomAbilities:AddAndOrSwapSkill(caster, "slipfinn_shadow_warp", "slipfinn_shadow_rush", 2)
	if caster:HasModifier("modifier_shimmer_cape") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_shimmer_cape", {duration = 4})
	end
end