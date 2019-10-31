require("/heroes/skywrath_mage/sephyr_constants")

function begin_icewind_gale(event)
	local ability = event.ability
	local caster = event.caster
	if not caster.animLock then
		StartAnimation(caster, {duration = 1.0, activity = ACT_DOTA_CAST_ABILITY_1, rate = 1.8})
		caster.animLock = true
		local luck = RandomInt(1, 7)
		if luck == 1 then
			if not caster.voLock then
				caster.voLock = true
				EmitSoundOn("Sephyr.Strafe.VO", caster)
				Timers:CreateTimer(0.6, function()
					caster.voLock = false
				end)
			end
		end
		Timers:CreateTimer(0.4, function()
			caster.animLock = false
		end)
	end
	local galeParticle = "particles/roshpit/sephyr/arcana1/new_icewind_gale.vpcf"
	local critParticle = "particles/roshpit/sephyr/arcana1/icewind_gale_crit.vpcf"
	local range = SEPHYR_ARCANA_GALE_RANGE
	local speed = SEPHYR_ARCANA_GALE_SPEED
	local castAbility = ability
	if caster:HasModifier("modifier_sephyr_glyph_4_1") then
		range = SEPHYR_ARCANA_GALE_RANGE + SEPHYR_GLYPH_4_1_W_BONUS_RANGE
		speed = SEPHYR_ARCANA_GALE_SPEED + SEPHYR_GLYPH_4_1_W_BONUS_PARTICLE_SPEED
		critParticle = "particles/roshpit/sephyr/arcana1/icewind_gale_glyphed_crit.vpcf"
		galeParticle = "particles/roshpit/sephyr/arcana1/glyphed_icewind_gale.vpcf"
	end

	local procChance = SEPHYR_ARCANA_GALE_CRIT_CHANCE
	if caster:HasModifier("modifier_sephyr_immortal_weapon_1") then
		procChance = procChance + SEPHYR_IMMORTAL_WEAPON_1_CRIT_CHANCE_INCREASE
	end
	local crit = Filters:GetProc(caster, procChance)
	if crit then
		if not caster.InventoryUnit:HasAbility("icewind_gale") then
			caster.InventoryUnit:AddAbility("icewind_gale")
		end
		local altGale = caster.InventoryUnit:FindAbilityByName("icewind_gale")
		altGale:SetLevel(ability:GetLevel())
		caster.InventoryUnit:RemoveModifierByName("modifier_sephyr_gale_passive")
		castAbility = altGale
		galeParticle = critParticle
	end

	local width = 170
	local immortal1 = false
	local minJ = 0
	local maxJ = 0
	if caster:HasModifier("modifier_sephyr_immortal_weapon_1") then
		width = width * (SEPHYR_IMMORTAL_WEAPON_1_W_WIDTH_INCREASE_PCT + 100)/100
		immortal1 = true
		minJ = -1
		maxJ = 1
	end
	local perpFV = WallPhysics:rotateVector(caster:GetForwardVector(), 2 * math.pi / 4)
	-- EmitSoundOn("Sephyr.IcewindGale", caster)
	if not ability.ice_highlight_sound then
		ability.ice_highlight_sound = true
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Sephyr.IcewindGaleHighlight", caster)
		Timers:CreateTimer(0.8, function()
			ability.ice_highlight_sound = false
		end)
	end
	for i = 0, 7, 1 do

		for j = minJ, maxJ, 1 do
			Timers:CreateTimer(i * 0.1, function()
				if not caster:HasModifier("modifier_gale_sound_lock") then
					EmitSoundOn("Sephyr.PiercingGaleIce", caster)
					ability:ApplyDataDrivenModifier(caster, caster, "modifier_gale_sound_lock", {duration = 0.1})
				end	
				local start_radius = 180
				local end_radius = 280
				local speed = speed
				local info =
				{
					Ability = castAbility,
					EffectName = galeParticle,
					vSpawnOrigin = caster:GetAbsOrigin() + perpFV * 90 * j,
					fDistance = range,
					fStartRadius = start_radius,
					fEndRadius = end_radius,
					Source = caster,
					StartPosition = "attach_origin",
					bHasFrontalCone = true,
					bReplaceExisting = false,
					iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
					iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
					iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					fExpireTime = GameRules:GetGameTime() + 1.0,
					bDeleteOnHit = false,
					vVelocity = caster:GetForwardVector() * speed,
					bProvidesVision = false,
				}
				ProjectileManager:CreateLinearProjectile(info)
			end)
		end
	end
	ability.pushSpeed = 12
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_gale_speed_burst", {duration = 0.8})
	local w_3_level = caster:GetRuneValue("w", 3)
	if w_3_level > 0 then
		local shieldStacks = Runes:Procs(w_3_level, SEPHYR_ARCANA_W3_SHIELD_CHANCE, 1)
		if shieldStacks > 0 then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_icewind_shield", {duration = 7})
			caster:SetModifierStackCount("modifier_icewind_shield", caster, shieldStacks)
		end
	end
	Filters:CastSkillArguments(2, caster)
end

function gale_speed_burst_think(event)
	local ability = event.ability
	local caster = event.caster
	ability.pushSpeed = math.max(ability.pushSpeed - 1, 0)
	if caster:HasModifier("modifier_strafe_sprinting") then
		-- ability.pushSpeed = 0
		-- caster:RemoveModifierByName("modifier_gale_speed_burst")
		-- if caster:HasAbility("sephyr_strafe") then
		-- local strafe = caster:FindAbilityByName("sephyr_strafe")
		-- strafe.
		-- end
	else
		local blockSearch = caster:GetAbsOrigin() * Vector(1, 1, 0) + Vector(0, 0, GetGroundHeight(caster:GetAbsOrigin(), caster))
		local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
		local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch + caster:GetForwardVector() * 15), caster)
		local forwardSpeed = ability.pushSpeed
		ability.pushSpeed = math.max(ability.pushSpeed - 1, 0)
		if blockUnit then
			forwardSpeed = 0
		end
		caster:SetAbsOrigin(caster:GetAbsOrigin() + caster:GetForwardVector() * forwardSpeed)
		if ability.pushSpeed <= 0 then
			caster:RemoveModifierByName("modifier_gale_speed_burst")
			if not caster:IsChanneling() then
				caster:MoveToPosition(caster:GetAbsOrigin() + caster:GetForwardVector() * 5)
				FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
			end
		end
	end
end

function ice_gale_hit(event)
	local ability = event.ability
	local caster = event.caster
	local damage = event.damage
	local target = event.target
	local crit = false
	if caster:GetUnitName() == "npc_dota_hero_skywrath_mage" then
	else
		caster = caster.hero
		ability = caster:FindAbilityByName("icewind_gale")
		crit = true
	end
	local w_2_level = caster:GetRuneValue("w", 2)
	if w_2_level > 0 then
		damage = damage + OverflowProtectedGetAverageTrueAttackDamage(caster) * SEPHYR_ARCANA_W2_ATTACK_TO_DAMAGE_PCT / 100 * w_2_level
	end
	if crit then
		damage = damage + damage * (event.crit_mult / 100)
	end
	ability:ApplyDataDrivenModifier(caster, target, "modifier_sephyr_chilled", {duration = 4})
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_ICE, RPC_ELEMENT_WIND)
end

function sephyr_passive_think_icegale(event)
	local ability = event.ability
	local caster = event.caster
	local w_1_level = caster:GetRuneValue("w", 1)
	if w_1_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_icewind_mana_regen", {})
		caster:SetModifierStackCount("modifier_icewind_mana_regen", caster, w_1_level)

		ability:ApplyDataDrivenModifier(caster, caster, "modifier_icewind_attack_power", {})
		local attackPower = caster:GetManaRegen() * w_1_level * SEPHYR_ARCANA_W1_DAMAGE_PER_MANAREGEN
		caster:SetModifierStackCount("modifier_icewind_attack_power", caster, attackPower)

	else
		caster:RemoveModifierByName("modifier_icewind_mana_regen")
		caster:RemoveModifierByName("modifier_icewind_attack_power")
	end
end

--CRIT NATIVE

--Q1
--INCREASE MANA REGEN. MANA REGEN INCREASES ATTACK POWER

--Q2 ATTACK POWER ADDED TO DAMAGE

--Q3 5% CHANCE GAIN A SHIELD STACK

--Q4 GRAND AERO ALL ATTRIBUTES INCREASE WIND DMG

