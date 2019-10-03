require("/heroes/visage/ekkan_constants")

function corpse_maker_die(event)
	local caster = event.caster
	local ability = event.ability
	local unit = event.unit
	if unit:GetUnitName() == "ekkan_corpse" then
		return false
	end
	if not unit:HasModifier("modifier_ekkan_dominion_debuff") then
		local corpses = 1
		if unit:HasModifier("modifier_swarm_effect") then
			corpses = 2
		end
		for i = 1, corpses, 1 do
			local position = unit:GetAbsOrigin()
			if i > 1 then
				position = position + RandomVector(90)
			end
			local corpse = CreateUnitByName("ekkan_corpse", position, false, nil, nil, unit:GetTeamNumber())
			ability:ApplyDataDrivenModifier(caster, corpse, "modifier_ekkan_skeleton_corpse", {duration = 30})
			corpse:SetForwardVector(RandomVector(1))
			corpse.hp = unit:GetMaxHealth()
			corpse.attackpower = OverflowProtectedGetAverageTrueAttackDamage(unit)
			corpse.dummy = true
		end
	end
end

function cast_raise_skeleton(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local point = event.target_points[1]
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, 105, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			if enemy:GetUnitName() == "ekkan_corpse" then
				local target = enemy
				local summonPosition = enemy:GetAbsOrigin()
				Timers:CreateTimer(0.2, function()
					UTIL_Remove(target)
					local unitName = "castle_skeleton_warrior"
					local attackDamage = OverflowProtectedGetAverageTrueAttackDamage(caster) * event.attack_mult
					local luck = RandomInt(1, 10)
					local applyTexture = true
					local w_3_level = 0
					local w_1_level = Runes:GetTotalRuneLevel(caster, 1, "w_1", "ekkan")
					local w_4_level = Runes:GetTotalRuneLevel(caster, 4, "w_4", "ekkan")
					if luck <= 3 then
						if w_1_level > 0 then
							unitName = "ekkan_skeleton_archer"
							attackDamage = OverflowProtectedGetAverageTrueAttackDamage(caster) * w_1_level * EKKAN_W1_ATTACK_POWER_MULTIPLE
							applyTexture = true
						end
					elseif luck <= 6 then
						w_3_level = Runes:GetTotalRuneLevel(caster, 3, "w_3", "ekkan")
						if w_3_level > 0 then
							unitName = "ekkan_skeleton_mage"
						end
					end
					local skeleton = CreateUnitByName(unitName, summonPosition, false, nil, nil, caster:GetTeamNumber())
					skeleton:SetControllableByPlayer(caster:GetPlayerOwnerID(), false)
					local skeletonDuration = event.skeleton_duration
					local w_2_level = Runes:GetTotalRuneLevel(caster, 2, "w_2", "ekkan")
					if w_2_level > 0 then
						skeletonDuration = skeletonDuration + EKKAN_W2_DURATION * w_2_level
					end
					if caster:HasModifier("modifier_ekkan_glyph_3_1") then
						skeletonDuration = skeletonDuration + skeletonDuration * EKKAN_GLYPH_3_1_SKELETON_DURATION_INCREASE_PCT/100
					end

					skeletonDuration = Filters:GetAdjustedBuffDuration(caster, skeletonDuration, false)
					ability:ApplyDataDrivenModifier(caster, skeleton, "modifier_skeleton_summon_unit", {duration = skeletonDuration})
					local skeleArmor = caster:GetPhysicalArmorValue(false) * event.armor_mult
					skeleton:SetPhysicalArmorBaseValue(skeleArmor)
					skeleton.w_1_level = w_1_level
					skeleton:SetBaseDamageMin(attackDamage)
					skeleton:SetBaseDamageMax(attackDamage)
					if not ability.skeleTable then
						ability.skeleTable = {}
					end
					local skeleton_health = event.skeleton_health
					skeleton:SetMaxHealth(skeleton_health)
					skeleton:SetBaseMaxHealth(skeleton_health)
					skeleton:SetHealth(skeleton_health)
					skeleton.ekkan_unit = true
					skeleton.hero = caster
					skeleton.w_3_level = w_3_level
					skeleton.ekkan_dominion = true
					skeleton.dominion = true
					if w_4_level > 0 then
						Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, skeleton, "modifier_general_postmitigation", {})
						skeleton:SetModifierStackCount("modifier_general_postmitigation", Events.GameMaster, w_4_level * EKKAN_W4_SKELETON_POST_MITI)
					end

					table.insert(ability.skeleTable, skeleton)
					local max_skeletons = event.max_skeletons
					if caster:HasModifier("modifier_ekkan_glyph_1_1") then
						max_skeletons = max_skeletons + EKKAN_GLYPH_1_1_ADD_UNITS
					end
					if #ability.skeleTable > max_skeletons then
						if IsValidEntity(ability.skeleTable[1]) then
							ability.skeleTable[1]:ForceKill(false)
						end
					end
					if applyTexture then
						ability:ApplyDataDrivenModifier(caster, skeleton, "modifier_skeleton_summon_texture_effect", {})
					end
					reindexSkeleTable(ability)
					StartAnimation(skeleton, {duration = 0.6, activity = ACT_DOTA_SPAWN, rate = 0.8})
					ability:ApplyDataDrivenModifier(caster, skeleton, "modifier_skeleton_spawning", {duration = 0.5})
					CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_visage/visage_stone_form.vpcf", skeleton, 3)
					EmitSoundOn("Ekkan.SkeletonSpawn", skeleton)

					if w_4_level > 0 then
						ability:ApplyDataDrivenModifier(caster, skeleton, "modifier_ekkan_d_b_magic_resist", {})
						skeleton:SetModifierStackCount("modifier_ekkan_d_b_magic_resist", caster, w_4_level)
					end
					skeleton.stance = "aggressive"
					skeleton:SetOwner(caster)
					FindClearSpaceForUnit(skeleton, skeleton:GetAbsOrigin(), false)
					ability:ApplyDataDrivenModifier(caster, caster, "modifier_summon_skeleton_counter", {})
					caster:SetModifierStackCount("modifier_summon_skeleton_counter", caster, #ability.skeleTable)
					skeleton.owner = caster:GetPlayerOwnerID()
				end)

				local beamPFX = ParticleManager:CreateParticle("particles/roshpit/ekkan/cast_beams_beams.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(beamPFX, 0, caster:GetAbsOrigin())
				ParticleManager:SetParticleControl(beamPFX, 1, summonPosition)
				Timers:CreateTimer(3, function()
					ParticleManager:DestroyParticle(beamPFX, false)
					ParticleManager:ReleaseParticleIndex(beamPFX)
				end)
			end
		end
	end
	Filters:CastSkillArguments(2, caster)
end

function reindexSkeleTable(ability)
	local newTable = {}
	for i = 1, #ability.skeleTable, 1 do
		if IsValidEntity(ability.skeleTable[i]) then
			if ability.skeleTable[i]:IsAlive() then
				table.insert(newTable, ability.skeleTable[i])
			end
		end
	end
	ability.skeleTable = newTable
end

function remove_corpse(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	target.disable = true
	for i = 1, 30, 1 do
		Timers:CreateTimer(i * 0.03, function()
			target:SetRenderColor(255 - i * 7, 255 - i * 7, 255 - i * 7)
			target:SetAbsOrigin(target:GetAbsOrigin() - Vector(0, 0, 2.5))
		end)
	end
	Timers:CreateTimer(1, function()
		UTIL_Remove(target)
	end)
end

function skeleton_die(event)
	local ability = event.ability
	local caster = event.caster
	reindexSkeleTable(ability)
	--print("SKELETON DIE")
	--print(#ability.skeleTable)
	if #ability.skeleTable > 0 then
		caster:SetModifierStackCount("modifier_summon_skeleton_counter", caster, #ability.skeleTable)
	else
		caster:RemoveModifierByName("modifier_summon_skeleton_counter")
	end
end

function skeleton_expire(event)
	local target = event.target
	target:ForceKill(false)
	local caster = event.caster
	local ability = event.ability
	reindexSkeleTable(ability)
	--print("SKELETON DIE")
	--print(#ability.skeleTable)
	if #ability.skeleTable > 0 then
		caster:SetModifierStackCount("modifier_summon_skeleton_counter", caster, #ability.skeleTable)
	else
		caster:RemoveModifierByName("modifier_summon_skeleton_counter")
	end
end

function mage_blast_target_point(event)
	local point = event.target_points[1]
	local caster = event.caster
	local hero = caster.hero
	local ability = event.ability
	local radius = 320

	local delay = 1.0
	local preParticle = ParticleManager:CreateParticle("particles/roshpit/ekkan/mage_preblast.vpcf", PATTACH_CUSTOMORIGIN, hero)
	ParticleManager:SetParticleControl(preParticle, 0, point)
	ParticleManager:SetParticleControl(preParticle, 1, Vector(radius, delay, radius))
	if not caster.w_3_level then
		caster.w_3_level = Runes:GetTotalRuneLevel(caster.hero, 3, "w_3", "ekkan")
	end
	local damage = caster.w_3_level * EKKAN_W3_BLAST_DAMAGE * OverflowProtectedGetAverageTrueAttackDamage(caster)
	EmitSoundOnLocationWithCaster(point, "Ekkan.SkeletonMage.PreBlast", caster)
	Timers:CreateTimer(delay, function()
		EmitSoundOnLocationWithCaster(point, "Ekkan.SkeletonMage.Blast", caster)
		local blastParticle = ParticleManager:CreateParticle("particles/roshpit/ekkan/mage_blast.vpcf", PATTACH_CUSTOMORIGIN, hero)
		ParticleManager:SetParticleControl(blastParticle, 0, point)
		ParticleManager:SetParticleControl(blastParticle, 1, Vector(radius, delay, radius))
		local enemies = FindUnitsInRadius(hero:GetTeamNumber(), point, nil, radius + 20, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				-- Filters:TakeArgumentsAndApplyDamage(enemy, hero, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_NONE)
				ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR, ability = ability})
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_mage_blast_slow", {duration = 5})
				enemy:SetModifierStackCount("modifier_mage_blast_slow", caster, caster.w_3_level)
			end
		end
		Timers:CreateTimer(5, function()
			ParticleManager:DestroyParticle(preParticle, false)
			ParticleManager:DestroyParticle(blastParticle, false)
		end)
	end)
end

function ekkan_think(event)
	local caster = event.caster
	local ability = event.ability

	local w_4_level = Runes:GetTotalRuneLevel(caster, 4, "w_4", "ekkan")
	if w_4_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_ekkan_d_b_magic_resist", {})
		caster:SetModifierStackCount("modifier_ekkan_d_b_magic_resist", caster, w_4_level)
	else
		caster:RemoveModifierByName("modifier_ekkan_d_b_magic_resist")
	end

end

function use_stance_modifier(event)
	local caster = event.caster
	local index = event.index
	if index == 1 then
		caster.stance = "follow"
		caster:RemoveAbility("ekkan_creep_aggressive")
		caster:AddAbility("ekkan_creep_follow"):SetLevel(1)
		caster:SetAcquisitionRange(500)
	elseif index == 2 then
		caster.stance = "passive"
		caster:RemoveAbility("ekkan_creep_follow")
		caster:AddAbility("ekkan_creep_passive"):SetLevel(1)
		caster:SetAcquisitionRange(0)
	elseif index == 3 then
		caster.stance = "aggressive"
		caster:RemoveAbility("ekkan_creep_passive")
		caster:AddAbility("ekkan_creep_aggressive"):SetLevel(1)
		caster:SetAcquisitionRange(1500)
	end
end

function ekkan_immortal_weapon_aura_start(event)
	local caster = event.caster.hero
	local target = event.target
	local ability = event.ability
	if target:GetUnitName() == "ekkan_corpse" then
		if not caster.immortalSouls then
			caster.immortalSouls = 0
		end
		if caster.immortalSouls < EKKAN_IMMORTAL_WEAPON_1_MAX_STACKS then
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Ekkan.CorpsePickup", caster)
			caster.immortalSouls = caster.immortalSouls + 1
			ability:ApplyDataDrivenModifier(event.caster, caster, "modifier_ekkan_corpse_picked_up", {duration = EKKAN_IMMORTAL_WEAPON_1_DURATION})
			UTIL_Remove(target)
			if not caster.immortalSoulsPFX then
				caster.immortalSoulsPFX = ParticleManager:CreateParticle("particles/units/heroes/hero_visage/visage_soul_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
				ParticleManager:SetParticleControlEnt(caster.immortalSoulsPFX, 0, caster, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", caster:GetAbsOrigin() + Vector(0, 0, 200), true)
			end
			for i = 1, EKKAN_IMMORTAL_WEAPON_1_MAX_STACKS, 1 do
				if caster.immortalSouls >= i then
					ParticleManager:SetParticleControl(caster.immortalSoulsPFX, i, Vector(caster.immortalSouls, caster.immortalSouls, caster.immortalSouls))
				end
			end
		end
	end
end

function ekkan_corpse_pickup_end(event)
	local caster = event.caster.hero
	local target = event.target
	local ability = event.ability
	caster.immortalSouls = caster.immortalSouls - 1
	for i = 1, 6, 1 do
		if caster.immortalSouls >= i then
			ParticleManager:SetParticleControl(caster.immortalSoulsPFX, i, Vector(caster.immortalSouls, caster.immortalSouls, caster.immortalSouls))
		else
			ParticleManager:SetParticleControl(caster.immortalSoulsPFX, i, Vector(0, 0, 0))
		end
	end
	if caster.immortalSouls == 0 then
		ParticleManager:DestroyParticle(caster.immortalSoulsPFX, true)
		caster.immortalSoulsPFX = false
	end
end
