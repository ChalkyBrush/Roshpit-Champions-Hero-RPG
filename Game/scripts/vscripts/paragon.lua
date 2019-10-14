if Paragon == nil then
	Paragon = class({})
end

Paragon.affixModifierTable = {"modifier_paragon_fire_breathing", "modifier_paragon_lightning_enchanted", "modifier_paragon_great_wall", "modifier_paragon_gargantuan",
	"modifier_paragon_annihilator", "modifier_paragon_regen_aura", "modifier_paragon_endurance_aura", "modifier_paragon_frostbitten", "modifier_paragon_springy",
"modifier_paragon_hasty", "modifier_paragon_crippling", "modifier_paragon_light_infused", "modifier_paragon_shielding", "modifier_paragon_magic_barrier", "modifier_paragon_blinking"}

function Paragon:SpawnParagonPack(unit_name, location)
	local luck = RandomInt(1, 5)
	local packSize = 3
	if luck == 5 then
		packSize = 4
	end
	local paragonUnitTable = {}
	local affixIndexTable = Paragon:GetUniqueAffixIndexTable(GameState:GetDifficultyFactor())
	local paragonDummy = CreateUnitByName("npc_dummy_unit", location, false, nil, nil, DOTA_TEAM_NEUTRALS)
	paragonDummy:NoHealthBar()
	for i = 1, packSize, 1 do
		local unit = CreateUnitByName(unit_name, location, true, nil, nil, DOTA_TEAM_NEUTRALS)
		FindClearSpaceForUnit(unit, location, false)
		Events:AdjustDeathXP(unit)
		Paragon:AdjustParagonPower(unit)
		unit.packSize = packSize
		unit.affixes = {}
		unit.buddiesSlain = 0
		unit.bossStatus = true
		unit.solo = false
		unit.paragon = true
		unit.paragonDummy = paragonDummy
		table.insert(paragonUnitTable, unit)
	end
	paragonDummy.buddiesTable = paragonUnitTable
	paragonDummy.roshpit_attributes = paragonUnitTable[1].roshpit_attributes
	for j = 1, #paragonUnitTable, 1 do
		local paragonUnit = paragonUnitTable[j]
		local paragonAbility = paragonUnit:AddAbility("paragon_abilities")
		paragonAbility:SetLevel(1)
		Timers:CreateTimer(0.5, function()
			for i = 1, #affixIndexTable, 1 do
				paragonAbility:ApplyDataDrivenModifier(paragonUnit, paragonUnit, Paragon.affixModifierTable[affixIndexTable[i]], {})
				table.insert(paragonUnit.affixes, Paragon.affixModifierTable[affixIndexTable[i]])
			end
		end)
		paragonAbility:ApplyDataDrivenModifier(paragonUnit, paragonUnit, "modifier_paragon_pack", {})
		paragonAbility:ApplyDataDrivenModifier(paragonUnit, paragonUnit, "modifier_paragon_pack_visual", {})
	end
	return paragonDummy

end

function Paragon:GetUniqueAffixIndexTable(difficulty)
	local maxRoll = #Paragon.affixModifierTable
	local affixIndexTable = {}
	if difficulty >= 1 then
		local affixIndex = RandomInt(1, maxRoll)
		table.insert(affixIndexTable, affixIndex)
	end
	if difficulty >= 2 then
		local affixIndex = RandomInt(1, maxRoll)
		while affixIndex == affixIndexTable[1] do
			affixIndex = RandomInt(1, maxRoll)
		end
		table.insert(affixIndexTable, affixIndex)
	end
	if difficulty >= 3 then
		local affixIndex = RandomInt(1, maxRoll)
		while affixIndex == affixIndexTable[1] or affixIndex == affixIndexTable[2] do
			affixIndex = RandomInt(1, maxRoll)
		end
		table.insert(affixIndexTable, affixIndex)
	end
	--DeepPrintTable(affixIndexTable)
	return affixIndexTable
end

function Paragon:AdjustParagonPower(unit)
	local difficulty = GameState:GetDifficultyFactor()
	local xp = unit:GetDeathXP()
	local adjustedXP = xp * 30
	unit:SetDeathXP(adjustedXP)
	local damageMult = 4.5
	if difficulty == 1 then
		damageMult = 1.15
	elseif difficulty == 3 then
		damageMult = 2.1
	end
	local damageAdjustment = unit:GetAttackDamage() * damageMult
	local minDamage = unit:GetBaseDamageMin()
	local maxDamage = unit:GetBaseDamageMax()
	unit:SetBaseDamageMin(minDamage + damageAdjustment)
	unit:SetBaseDamageMax(maxDamage + damageAdjustment)

	local armorMult = 2
	if difficulty == 2 then
		armorMult = 2
	elseif difficulty == 3 then
		armorMult = 3
	end
	local newArmor = unit:GetPhysicalArmorValue(false) * armorMult

	unit:SetPhysicalArmorBaseValue(newArmor)

	local healthMult = 15
	if difficulty == 1 then
		healthMult = 2
	elseif difficulty == 2 then
		healthMult = 6
	end
	local newHealth = unit:GetMaxHealth() * healthMult
	newHealth = math.min(newHealth, (2 ^ 30) - 10)
	unit:SetMaxHealth(newHealth)
	unit:SetBaseMaxHealth(newHealth)
	unit:SetHealth(newHealth)
	unit:Heal(newHealth, unit)

	local currentScale = unit:GetModelScale()
	unit:SetModelScale(currentScale * 1.21)
end

function Paragon:SpawnParagonUnit(unit_name, location)
	local affixIndexTable = Paragon:GetUniqueAffixIndexTable(GameState:GetDifficultyFactor())
	local unit = CreateUnitByName(unit_name, location, true, nil, nil, DOTA_TEAM_NEUTRALS)
	Events:AdjustDeathXP(unit)
	Paragon:AdjustParagonPowerSolo(unit)
	unit.bossStatus = true
	unit.solo = true
	unit.paragon = true
	unit.affixes = {}

	local paragonAbility = unit:AddAbility("paragon_abilities")
	paragonAbility:SetLevel(1)
	Timers:CreateTimer(0.5, function()
		for i = 1, #affixIndexTable, 1 do
			paragonAbility:ApplyDataDrivenModifier(unit, unit, Paragon.affixModifierTable[affixIndexTable[i]], {})
			table.insert(unit.affixes, Paragon.affixModifierTable[affixIndexTable[i]])
		end
	end)
	paragonAbility:ApplyDataDrivenModifier(unit, unit, "modifier_paragon_solo", {})
	paragonAbility:ApplyDataDrivenModifier(unit, unit, "modifier_paragon_solo_visual", {})
	return unit
end

function Paragon:AddParagonUnit(unit)
	local affixIndexTable = Paragon:GetUniqueAffixIndexTable(GameState:GetDifficultyFactor())
	-- Paragon:AdjustParagonPowerSolo(unit)
	unit.solo = true
	unit.paragon = true
	unit.affixes = {}
	local paragonAbility = unit:AddAbility("paragon_abilities")
	paragonAbility:SetLevel(1)
	Timers:CreateTimer(0.5, function()
		for i = 1, #affixIndexTable, 1 do
			--print("APPLY??")
			--print(Paragon.affixModifierTable[affixIndexTable[i]])
			paragonAbility:ApplyDataDrivenModifier(unit, unit, Paragon.affixModifierTable[affixIndexTable[i]], {})
			table.insert(unit.affixes, Paragon.affixModifierTable[affixIndexTable[i]])
		end
	end)
	paragonAbility:ApplyDataDrivenModifier(unit, unit, "modifier_paragon_solo", {})
	paragonAbility:ApplyDataDrivenModifier(unit, unit, "modifier_paragon_solo_visual", {})
	Paragon:AdjustParagonPower(unit, "gold")
end

Paragon.PARAGON_ATTACK_MULT = 2
Paragon.PARAGON_HEALTH_MULT = 3
Paragon.ROSHPIT_ATTRIBUTES_INCREASE_MULT = 2 
Paragon.EXP_MULT = 5

function Paragon:AdjustParagonPower(unit, paragon_type)
	if paragon_type == "gold" then
		-- EXP
		unit.roshpit_attributes.deathXP = unit.roshpit_attributes.deathXP*Paragon.EXP_MULT

		-- attack damage
		local base_damage = unit:GetAverageTrueAttackDamage(unit)
		local damageDiff = unit:GetBaseDamageMax() - unit:GetBaseDamageMin()
		local newDamage = base_damage*Paragon.PARAGON_ATTACK_MULT
		unit:SetBaseDamageMin(newDamage-damageDiff)
		unit:SetBaseDamageMax(newDamage)

		-- roshpit attributes (armor, magic armor, spell pierce and armor pierce)
		local newArmor = unit.roshpit_attributes.roshpit_armor*Paragon.ROSHPIT_ATTRIBUTES_INCREASE_MULT
		unit:SetBaseRoshpitArmor(newArmor, false)
		local newMagicArmor = unit.roshpit_attributes.roshpit_magic_armor*Paragon.ROSHPIT_ATTRIBUTES_INCREASE_MULT
		unit:SetBaseRoshpitMagicArmor(newMagicArmor, false)
		local newArmorPierce = unit.roshpit_attributes.roshpit_armor_pierce*Paragon.ROSHPIT_ATTRIBUTES_INCREASE_MULT
		unit:SetBaseRoshpitArmorPierce(newArmorPierce, false)
		local newSpellPierce = unit.roshpit_attributes.roshpit_spell_pierce*Paragon.ROSHPIT_ATTRIBUTES_INCREASE_MULT
		unit:SetBaseRoshpitSpellPierce(newSpellPierce, false)

		-- HP
		local newHealth = unit:GetMaxHealth()*Paragon.PARAGON_HEALTH_MULT
		newHealth = math.min(newHealth, (2 ^ 30) - 10)
		unit:SetMaxHealth(newHealth)
		unit:SetBaseMaxHealth(newHealth)
		unit:SetHealth(newHealth)
	end
end

function Paragon:AdjustParagonPowerSolo(unit)
	local difficulty = GameState:GetDifficultyFactor()
	local xp = unit:GetDeathXP()
	local adjustedXP = xp * 50
	unit:SetDeathXP(adjustedXP)
	local damageMult = 2.5
	if difficulty == 1 then
		damageMult = 1.2
	end
	local damageAdjustment = unit:GetAttackDamage() * damageMult
	local minDamage = unit:GetBaseDamageMin()
	local maxDamage = unit:GetBaseDamageMax()
	unit:SetBaseDamageMin(minDamage + damageAdjustment)
	unit:SetBaseDamageMax(maxDamage + damageAdjustment)
	local armorMult = 1
	if difficulty == 2 then
		armorMult = 2
	elseif difficulty == 3 then
		armorMult = 3
	end
	local newArmor = unit:GetPhysicalArmorValue(false) * armorMult

	unit:SetPhysicalArmorBaseValue(newArmor)

	local healthMult = 30
	if difficulty == 1 then
		healthMult = 2
	elseif difficulty == 2 then
		healthMult = 3
	end
	local newHealth = unit:GetMaxHealth() * healthMult
	newHealth = math.min(newHealth, (2 ^ 30) - 10)
	unit:SetMaxHealth(newHealth)
	unit:SetBaseMaxHealth(newHealth)
	unit:SetHealth(newHealth)
	unit:Heal(newHealth, unit)

	local currentScale = unit:GetModelScale()
	unit:SetModelScale(currentScale * 1.32)
end
