require("/heroes/skywrath_mage/sephyr_constants")

function begin_piercing_gale(event)
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
	local galeParticle = "particles/roshpit/sephyr/piercing_gale.vpcf"
	local critParticle = "particles/roshpit/sephyr/gale/crit.vpcf"
	local range = SEPHYR_W_BASE_RANGE
	local speed = SEPHYR_W_BASE_PARTICLE_SPEED
	local w_2_level = caster:GetRuneValue("w", 2)
	local castAbility = ability
	ability.w_2_level = w_2_level
	if caster:HasModifier("modifier_sephyr_glyph_4_1") then
		range = SEPHYR_W_BASE_RANGE + SEPHYR_GLYPH_4_1_W_BONUS_RANGE 
		speed = SEPHYR_W_BASE_PARTICLE_SPEED + SEPHYR_GLYPH_4_1_W_BONUS_PARTICLE_SPEED
		galeParticle = "particles/roshpit/sephyr/glyphed_piercing_gale.vpcf"
		critParticle = "particles/roshpit/sephyr/gale/glyphed_crit.vpcf"
	end
	if ability.w_2_level > 0 then
		local procChance = 20
		if caster:HasModifier("modifier_sephyr_immortal_weapon_1") then
			procChance = procChance + SEPHYR_IMMORTAL_WEAPON_1_CRIT_CHANCE_INCREASE
		end
		local crit = Filters:GetProc(caster, procChance)
		if crit then
			if not caster.InventoryUnit:HasAbility("piercing_gale") then
				caster.InventoryUnit:AddAbility("piercing_gale")
			end
			local altGale = caster.InventoryUnit:FindAbilityByName("piercing_gale")
			altGale:SetLevel(ability:GetLevel())
			caster.InventoryUnit:RemoveModifierByName("modifier_sephyr_gale_passive")
			castAbility = altGale
			galeParticle = critParticle
		end
	end
	local width = 170
	local immortal1 = false
	if caster:HasModifier("modifier_sephyr_immortal_weapon_1") then
		width = width * (SEPHYR_IMMORTAL_WEAPON_1_W_WIDTH_INCREASE_PCT + 100)/100
		immortal1 = true
	end
	local perpFV = WallPhysics:rotateVector(caster:GetForwardVector(), 2 * math.pi / 4)
	for i = 0, 7, 1 do
		Timers:CreateTimer(i * 0.1, function()
			if not caster:HasModifier("modifier_gale_sound_lock") then
				EmitSoundOn("Sephyr.PiercingGale", caster)
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_gale_sound_lock", {duration = 0.1})
			end
			local pfx = ParticleManager:CreateParticle(galeParticle, PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin() + Vector(0, 0, 80))
			ParticleManager:SetParticleControl(pfx, 1, caster:GetForwardVector())
			ParticleManager:SetParticleControl(pfx, 3, caster:GetAbsOrigin() + caster:GetForwardVector() * 1000)
			local pfx2 = nil
			local pfx3 = nil
			if immortal1 then
				pfx2 = ParticleManager:CreateParticle(galeParticle, PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(pfx2, 0, caster:GetAbsOrigin() + perpFV * 90 + Vector(0, 0, 80))
				ParticleManager:SetParticleControl(pfx2, 1, caster:GetForwardVector())
				ParticleManager:SetParticleControl(pfx2, 3, caster:GetAbsOrigin() + perpFV * 90 + caster:GetForwardVector() * 1000)

				pfx3 = ParticleManager:CreateParticle(galeParticle, PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(pfx3, 0, caster:GetAbsOrigin() - perpFV * 90 + Vector(0, 0, 80))
				ParticleManager:SetParticleControl(pfx3, 1, caster:GetForwardVector())
				ParticleManager:SetParticleControl(pfx3, 3, caster:GetAbsOrigin() - perpFV * 90 + caster:GetForwardVector() * 1000)
			end
			Timers:CreateTimer(0.2, function()
				ParticleManager:DestroyParticle(pfx, false)
				if immortal1 then
					ParticleManager:DestroyParticle(pfx2, false)
					ParticleManager:DestroyParticle(pfx3, false)
				end
			end)
			local particleName = "particles/econ/items/mirana/mirana_crescent_arrow/ruins_boss_linear_destruction.vpcf"
			local start_radius = 170
			local end_radius = 170
			local speed = speed
			local info =
			{
				Ability = castAbility,
				EffectName = particleName,
				vSpawnOrigin = caster:GetAbsOrigin(),
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
	ability.pushSpeed = 12
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_gale_speed_burst", {duration = 0.8})
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

function gale_hit(event)
	local ability = event.ability
	local caster = event.caster
	local damage = event.damage
	local target = event.target
	local crit = false
	if caster:GetUnitName() == "npc_dota_hero_skywrath_mage" then
	else
		caster = caster.hero
		ability = caster:FindAbilityByName("piercing_gale")
		crit = true
	end
	local w_3_level = caster:GetRuneValue("w", 3)
	if w_3_level > 0 then
		damage = damage + OverflowProtectedGetAverageTrueAttackDamage(caster) * SEPHYR_W3_ATTACK_TO_DAMAGE_PCT / 100 * w_3_level
	end
	if crit then
		damage = damage + damage * SEPHYR_W2_CRIT_BONUS_PCT/100 * ability.w_2_level
	end
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_WIND, RPC_ELEMENT_NONE)
end

function sephyr_passive_think_gale(event)
	local ability = event.ability
	local caster = event.caster
	local w_1_level = caster:GetRuneValue("w", 1)
	if w_1_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_sephyr_mana_regen", {})
		local manaRegen = caster:GetIntellect() * SEPHYR_W1_INT_TO_MANA_REGEN_PCT/100 * w_1_level
		caster:SetModifierStackCount("modifier_sephyr_mana_regen", caster, manaRegen)
	else
		caster:RemoveModifierByName("modifier_sephyr_mana_regen")
	end
end
