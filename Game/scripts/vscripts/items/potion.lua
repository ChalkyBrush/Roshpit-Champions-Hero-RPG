function usePotion(event)
	local caster = event.caster
	local ability = event.ability

	local mult = getPotionMultipler(caster)

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

function getPotionMultipler(caster)
	local mult = 1
	if caster:HasModifier("modifier_neutral_glyph_4_3") then
		mult = mult + 0.2
	end
	-- print("getPotionMultipler "..mult)
	return mult
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

function use_web_prem_token(event)
	local caster = event.caster
	local item = event.ability

	local particleName = "particles/roshpit/web/web_premium.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, Vector(200, 200, 200))
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	EmitSoundOn("RPC.WebPremium", caster)

	local playerID = caster:GetPlayerOwnerID()
	local steamID = PlayerResource:GetSteamAccountID(playerID)
	local url = ROSHPIT_URL.."/web-premium/consumed?"
	url = url.."steam_id="..steamID
	url = url.."&prem_id="..item.property1
	url = url.."&key1="..GetDedicatedServerKey(SaveLoad.KeyVersion)
	CreateHTTPRequestScriptVM( "POST", url ):Send( function( result )
		SaveLoad:NewKey()
		print( "POST response:\n" )
		for k,v in pairs( result ) do
			print( string.format( "%s : %s\n", k, v ) )
		end
		print( "Done." )
		local resultTable = JSON:decode(result.Body)
		CustomNetTables:SetTableValue("premium_pass", "web-"..tostring(playerID), {premium = 1} )
		CustomGameEventManager:Send_ServerToAllClients("update_premium", {playerID = playerID} )
		Notifications:Top(playerID, {text="Web Premium Added", duration=8, style={color="#A2EFEF"}, continue=true})
		if IsValidEntity(item) then
			RPCItems:ItemUTIL_Remove(item)
		end
	end )

end

function use_synthesis_vessel(event)
	RPCItems:UseSynthesisVessel(event.caster, event.ability)
end

function use_arcana_cache(event)
	RPCItems:UseArcanaCache(event.caster, event.ability)
end