require('heroes/omniknight/constants')
function begin_crusader_comet(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	ability.point = WallPhysics:WallSearch(caster:GetAbsOrigin(), point, caster)
	ability.jumpVelocity = 60
	ability.forwardMovement = 6
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_comet_jumping", {duration = 1})
	ability.fv = ((ability.point - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	ability.landAnimated = false
	EmitSoundOn("Paladin.CometLift.VO", caster)
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_antimage/holy_blinkend.vpcf", caster, 1.7)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Paladin.CometFlying", caster)
	local c_c_level = Runes:GetTotalRuneLevelGeneric(caster, 3, 2)
	caster:RemoveModifierByName("modifier_comet_storming")
	if c_c_level > 0 then
		local c_c_duration = 1.0 + 0.1*c_c_level
		c_c_duration = Filters:GetAdjustedBuffDuration(caster, c_c_duration, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_black_King_bar_immunity", {duration = c_c_duration})
	end
	Filters:CastSkillArguments(3, caster)
end

function jumping_think(event)
	local caster = event.caster
	local ability = event.ability
	ability.jumpVelocity = math.max(ability.jumpVelocity - 3, 20)
	ability.forwardMovement = ability.forwardMovement + 2

	local newPosition = caster:GetAbsOrigin()+Vector(0,0,ability.jumpVelocity) + ability.fv*ability.forwardMovement
	local afterWallPosition = WallPhysics:WallSearch(caster:GetAbsOrigin(), newPosition, caster)

	if afterWallPosition == newPosition then
		caster:SetAbsOrigin(newPosition)
	else
		caster:SetAbsOrigin(newPosition-ability.fv*ability.forwardMovement)
	end

	if caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster) > 500 then
		caster:RemoveModifierByName("modifier_comet_jumping")
		-- ability.fv = ((ability.point - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_comet_storming", {duration = 2})
		local distanceToDash = WallPhysics:GetDistance2d(ability.point, caster:GetAbsOrigin())
		local dashTicks = (caster:GetAbsOrigin().z-GetGroundHeight(ability.point, caster))/40
		ability.dashSpeed = math.max(distanceToDash/dashTicks, ability.forwardMovement)
		Timers:CreateTimer(0.1, function()
			EmitSoundOn("Paladin.CometDash.VO", caster)
		end)
	end
end

function comet_think(event)
	local caster = event.caster
	local ability = event.ability
	local moveVelocity = ability.dashSpeed

	local newPosition = caster:GetAbsOrigin()+ability.fv*moveVelocity-Vector(0,0,40)
	local afterWallPosition = WallPhysics:WallSearch(caster:GetAbsOrigin(), newPosition, caster)

	if afterWallPosition == newPosition then
		caster:SetAbsOrigin(newPosition)
	else
		caster:SetAbsOrigin(newPosition-ability.fv*moveVelocity)
	end

	-- caster:SetAbsOrigin(caster:GetAbsOrigin()+ability.fv*moveVelocity-Vector(0,0,40))
	if caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster) < 80 then
		caster:RemoveModifierByName("modifier_comet_storming")
	elseif caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster) < 340 then
		if not ability.landAnimated then
			print("ANIMATE")
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Paladin.CometLand", caster)
			ability.landAnimated = true
			StartAnimation(caster, {duration=0.7, activity=ACT_DOTA_ATTACK, rate=1.3})
		end
	end
end

function comet_storm_end(event)
	local caster = event.caster
	local ability = event.ability
	local landPoint = GetGroundPosition(caster:GetAbsOrigin() + ability.fv*ability.forwardMovement, caster)
	WallPhysics:ClearSpaceForUnit(caster, landPoint)
	local pfx = CustomAbilities:QuickParticleAtPoint("particles/roshpit/paladin/arcana_comet_ground_impact.vpcf", landPoint+Vector(0,0,20), 5)
	ParticleManager:SetParticleControl(pfx, 3, landPoint+Vector(0,0,20))
	EmitSoundOn("Paladin.CometLandGround", caster)

	local str_mult = event.str_mult
	local damage = event.damage + caster:GetStrength()*str_mult
    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), landPoint, nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
    if #enemies > 0 then
        for _,enemy in pairs(enemies) do
        	Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 3, RPC_ELEMENT_HOLY, RPC_ELEMENT_EARTH)
        end
    end 	
    Timers:CreateTimer(5, function()
    	ParticleManager:DestroyParticle(pfx, false)
    	ParticleManager:ReleaseParticleIndex(pfx)
    end)
end

function calculate_and_apply_b_c_attack_power(event)
	local caster = event.caster
	local ability = event.ability
	local b_c_level = Runes:GetTotalRuneLevelGeneric(caster, 2, 2)
	if b_c_level > 0 then
		local damageDealt = 1000
		local damageHOLY = Filters:ElementalDamage(Events.GameMaster, caster, damageDealt*100, DAMAGE_TYPE_PURE, 0, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE, false)
		local amp = damageHOLY/damageDealt
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_paladin_b_c_attackpower", {})
		caster:SetModifierStackCount("modifier_paladin_b_c_attackpower", caster, amp*b_c_level*0.8)
	else
		caster:RemoveModifierByName("modifier_paladin_b_c_attackpower")
	end
	local d_c_level = Runes:GetTotalRuneLevelGeneric(caster, 4, 2)
	if d_c_level > 0 then
		local damageDealt = 1000
		local damageHOLY = Filters:ElementalDamage(Events.GameMaster, caster, damageDealt*100, DAMAGE_TYPE_PURE, 0, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE, false)
		local amp = damageHOLY/damageDealt
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_paladin_d_c_postmit", {})
		caster:SetModifierStackCount("modifier_paladin_d_c_postmit", caster, amp*ARCANA2_E4_AMPLIFY*d_c_level/100)
	else
		caster:RemoveModifierByName("modifier_paladin_d_c_postmit")
	end	
	
end