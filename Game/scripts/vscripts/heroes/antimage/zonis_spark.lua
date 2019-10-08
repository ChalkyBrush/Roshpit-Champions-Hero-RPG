require('heroes/antimage/arkimus_constants')

function zonis_precast(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Arkimus.ZonisStart", caster)
	-- CreateZonisBeam(caster:GetAbsOrigin()+Vector(0,0,60), event.target_points[1]+Vector(0,0,60))
	local target = event.target_points[1]
	local moveDirection = ((target - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), target)
	for i = 1, 7, 1 do
		Timers:CreateTimer(i * 0.06, function()
			local pfx = ParticleManager:CreateParticle("particles/roshpit/arkimus/jump_fade.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin() + moveDirection * (distance / 7) * i)
			Timers:CreateTimer(0.4, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
		end)
	end
end

function spark_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	local origPosition = caster:GetAbsOrigin()
	CustomAbilities:QuickAttachParticle("particles/arkimus/zonis_start.vpcf", caster, 3)
	target = WallPhysics:WallSearch(caster:GetAbsOrigin(), target, caster)
	FindClearSpaceForUnit(caster, target, false)
	ProjectileManager:ProjectileDodge(caster)
	local casterOrigin = caster:GetAbsOrigin()

	local damage = event.damage
	ability.q_1_level = caster:GetRuneValue("q", 1)
	ability.q_2_level = caster:GetRuneValue("q", 2)
	ability.q_3_level = caster:GetRuneValue("q", 3)
	ability.q_4_level = caster:GetRuneValue("q", 4)
	local duration = 7 + ability.q_4_level * 0.15
	local loops = math.floor(duration * 10)
	Timers:CreateTimer(0.1, function()
		CustomAbilities:QuickAttachParticle("particles/roshpit/arkimus/zonis_end.vpcf", caster, 3)
		if ability.q_2_level > 0 then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_zonis_buff", {duration = 1})
		end
		for i = 1, loops, 1 do
			Timers:CreateTimer(i * 0.1, function()
				CreateZonisBeam(origPosition + Vector(0, 0, 60), target + Vector(0, 0, 60))
				local enemies = FindUnitsInLine(caster:GetTeamNumber(), origPosition, target, nil, 80, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0)
				if #enemies > 0 then
					if i % 2 == 0 then
						EmitSoundOnLocationWithCaster(enemies[1]:GetAbsOrigin(), "Arkimus.ZonisLightning", caster)
					end
					for _, enemy in pairs(enemies) do
						zonis_damage(enemy, caster, damage, ability)
					end
				end
			end)
		end
	end)
	EmitSoundOn("Arkimus.ZonisEnd", caster)
	if caster:HasModifier("modifier_zonis_freecast") then
		ability:EndCooldown()
		local newStacks = caster:GetModifierStackCount("modifier_zonis_freecast", caster) - 1
		if newStacks > 0 then
			caster:SetModifierStackCount("modifier_zonis_freecast", caster, newStacks)
		else
			caster:RemoveModifierByName("modifier_zonis_freecast")
		end
	end
	if caster:HasAbility("arkimus_energy_field") then
		local energyField = caster:FindAbilityByName("arkimus_energy_field")
		if energyField.rotationDelta then
			energyField.rotationDelta = math.min(50, energyField.rotationDelta + 6)
		end
	end
	Filters:CastSkillArguments(1, caster)
end

function zonis_damage(enemy, caster, damage, ability)
	damage = damage + damage * ARKIMUS_Q4_ADD_DMG_PCT * ability.q_4_level
	ability:ApplyDataDrivenModifier(caster, enemy, "modifier_zonis_stun", {duration = 0.2})
	Filters:ApplyStun(caster, 0.2, enemy)
	Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_Q, RPC_ELEMENT_ARCANE, RPC_ELEMENT_LIGHTNING)
	if ability.q_1_level > 0 then
		if enemy.dummy then
		else
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_zonis_a_a_armor_loss", {duration = 8})
			enemy:SetModifierStackCount("modifier_zonis_a_a_armor_loss", caster, ability.q_1_level)
		end
	end
	if ability.q_3_level > 0 then
		ability:ApplyDataDrivenModifier(caster, enemy, "modifier_zonis_c_a_magic_resist", {duration = 8})
		enemy:SetModifierStackCount("modifier_zonis_c_a_magic_resist", caster, ability.q_3_level)
	end
end

function zonis_think(event)
	local caster = event.caster
	local ability = event.ability
	local radius = ARKIMUS_Q2_RADIUS_BASE + ability.q_2_level * ARKIMUS_Q2_RADIUS
	local damage = ability.q_2_level * ARKIMUS_Q2_DAMAGE
	local edges = 2 + math.ceil((ability.q_2_level + 1) * 0.05)
	casterOrigin = caster:GetAbsOrigin()
	local endPointTable = {}
	local midPointTable = {}
	local baseFV = caster:GetForwardVector()
	for i = 1, edges, 1 do
		local rotatedVector = WallPhysics:rotateVector(baseFV, 2 * math.pi * i / edges)
		local endPoint = casterOrigin + rotatedVector * radius + Vector(0, 0, 60)
		CreateZonisBeam(casterOrigin + Vector(0, 0, 60), endPoint)
		table.insert(endPointTable, endPoint)
		table.insert(midPointTable, casterOrigin + rotatedVector * (radius / 2) + Vector(0, 0, 60))
	end
	for j = 1, #endPointTable, 1 do
		if j < #endPointTable then
			CreateZonisBeam(endPointTable[j], endPointTable[j + 1])
			CreateZonisBeam(midPointTable[j], midPointTable[j + 1])
		else
			CreateZonisBeam(endPointTable[j], endPointTable[1])
			CreateZonisBeam(midPointTable[j], midPointTable[1])
		end
	end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), casterOrigin, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			zonis_damage(enemy, caster, damage, ability)
		end
	end
	EmitSoundOnLocationWithCaster(casterOrigin, "Arkimus.ZonisLightning", caster)
end

function CreateZonisBeam(attachPointA, attachPointB)
	local particleName = "particles/roshpit/arkimus/zonis_lightning.vpcf"
	local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(lightningBolt, 0, Vector(attachPointA.x, attachPointA.y, attachPointA.z))
	ParticleManager:SetParticleControl(lightningBolt, 1, Vector(attachPointB.x, attachPointB.y, attachPointB.z))
	Timers:CreateTimer(2, function()
		ParticleManager:DestroyParticle(lightningBolt, false)
		ParticleManager:ReleaseParticleIndex(lightningBolt)
	end)
end

function zonis_passive_think(event)
	local caster = event.caster
	local ability = event.ability
	local stackCount = caster:GetModifierStackCount("modifier_zonis_freecast", caster)
	local maxStacks = 2
	if caster:HasModifier("modifier_arkimus_glyph_6_1") then
		maxStacks = maxStacks + ARKIMUS_GLYPH_6_1_Q_FREE_CAST
	end
	if stackCount <= maxStacks then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_zonis_freecast", {})
		local newStacks = math.min(stackCount + 1, maxStacks)
		caster:SetModifierStackCount("modifier_zonis_freecast", caster, newStacks)
	end
end

function AmplifyDamageParticle(event)
	local target = event.target
	local location = target:GetAbsOrigin()
	if target.dummy then
		return false
	end
	local particleName = "particles/roshpit/heroes/arkimus/a_a_amp_damage.vpcf"
	if target.AmpDamageParticle then
		ParticleManager:DestroyParticle(target.AmpDamageParticle, false)
	end
	-- Particle. Need to wait one frame for the older particle to be destroyed
	Timers:CreateTimer(0.01, function()
		target.AmpDamageParticle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, target)
		ParticleManager:SetParticleControl(target.AmpDamageParticle, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(target.AmpDamageParticle, 1, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(target.AmpDamageParticle, 2, target:GetAbsOrigin())

		ParticleManager:SetParticleControlEnt(target.AmpDamageParticle, 1, target, PATTACH_OVERHEAD_FOLLOW, "attach_overhead", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(target.AmpDamageParticle, 2, target, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	end)

end

-- Destroys the particle when the modifier is destroyed
function EndAmplifyDamageParticle(event)
	local target = event.target
	if target.AmpDamageParticle then
		ParticleManager:DestroyParticle(target.AmpDamageParticle, false)
		target.AmpDamageParticle = nil
	end
end
