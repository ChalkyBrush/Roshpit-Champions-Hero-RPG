function usePotion(event)
	local caster = event.caster
	local ability = event.ability
	local mult = 1
	if caster:HasModifier("modifier_neutral_glyph_4_3") then
		mult = mult + 3
	end

	action(ability.property1name, ability.property1 * mult, caster)
	if ability.property2name then
		action(ability.property2name, ability.property2 * mult, caster)
	end
	if ability.property3name then
		action(ability.property3name, ability.property3 * mult, caster)
	end
	if ability.property4name then
		action(ability.property4name, ability.property4 * mult, caster)
	end
	if ability.property5name then
		action(ability.property5name, ability.property5 * mult, caster)
	end
end

function action(propertyName, propertyValue, caster)
	if propertyName == "heal" then
		heal(propertyValue, caster)
	elseif propertyName == "strength" then
		add_strength(propertyValue, caster)
	elseif propertyName == "agility" then
		add_agility(propertyValue, caster)
	elseif propertyName == "intelligence" then
		add_intelligence(propertyValue, caster)
	elseif propertyName == "mana_heal" then
		restore_mana(propertyValue, caster)
	elseif propertyName == "exp" then
		add_exp(propertyValue, caster)
	end
end

function heal(amount, caster)
 	caster:Heal( amount, caster)
	PopupHealing(caster, amount)
end

function restore_mana(amount, caster)
	caster:GiveMana(amount)
	PopupMana(caster, amount)
end

function add_strength(amount, caster)
	caster.strength_custom = caster.strength_custom + amount
	PopupStrTome(caster, amount)
end

function add_agility(amount, caster)
	caster.agility_custom = caster.agility_custom + amount
	PopupAgiTome(caster, amount)
end

function add_intelligence(amount, caster)
	caster.intellect_custom = caster.intellect_custom + amount
	PopupIntTome(caster, amount)
end

function add_exp(amount, caster)
	caster:AddExperience(amount, 0, false, false)
	PopupExperience(caster, amount)
end

function use_reanimation_stone(event)
	local caster = event.caster
	for i = 0, 5, 1 do
		local ability = caster:GetAbilityByIndex(i)
		if ability then
			ability:SetLevel(1)
		end
	end
	--RUNE UNITS
	for t = 0, 3, 1 do
		local ability = caster.runeUnit:GetAbilityByIndex(t)
		if ability then
			ability:SetLevel(0)
		end
	end
	for t = 0, 3, 1 do
		local ability = caster.runeUnit2:GetAbilityByIndex(t)
		if ability then
			ability:SetLevel(0)
		end
	end
	for t = 0, 3, 1 do
		local ability = caster.runeUnit3:GetAbilityByIndex(t)
		if ability then
			ability:SetLevel(0)
		end
	end
	for t = 0, 3, 1 do
		local ability = caster.runeUnit4:GetAbilityByIndex(t)
		if ability then
			ability:SetLevel(0)
		end
	end
	local runePoints = (caster:GetLevel()-1)*2 + 3
	local abilityPoints = math.floor(caster:GetLevel()/5)
	CustomNetTables:SetTableValue("player_stats", tostring(caster:GetPlayerOwnerID()), {skillPoints = abilityPoints, runePoints = runePoints} )
	CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "AbilityUp", {playerId=caster:GetPlayerOwnerID()})
end

function stackable_pickup(event)
	print('stackable PICKUP')
	local ability = event.ability
	ability.stackable = true
	Events:PickUpTest(event.caster, ability, ability:GetAbilityName())
end

function use_damage_potion(event)
	local caster = event.caster
	local ability = event.ability
end