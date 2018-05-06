function glyph_3_1_activate(event)
	local target = event.target
	target:AddNewModifier( target, nil, 'modifier_movespeed_cap_glyph', nil )
end

function glyph_3_1_deactivate(event)
	local target = event.target
	target:RemoveModifierByName('modifier_movespeed_cap_glyph')
end

function flamewaker_glyph_1_1_attacked(event)
	local target = event.target
	local attacker = event.attacker
	local luck = RandomInt(1,2)
	local stun_duration = event.ability:GetSpecialValueFor("property_two")
	if luck == 1 then
		Filters:ApplyStun(target, stun_duration, attacker)
	end
end

function voltex_glyph_4_1_trigger(event)
	local executedAbility = event.event_ability
	if executedAbility:GetAbilityName()== "ability_zap" or executedAbility:IsItem() then
	else
		local ability = event.ability
		local caster = ability.hero
		for i = 1, 9, 1 do
			local fv = RandomVector(1)
			local projectileParticle = "particles/econ/items/zeus/lightning_weapon_fx/linear_electric_immortal_lightning.vpcf"
			local projectileOrigin = caster:GetAbsOrigin() + fv*10
			local start_radius = 140
			local end_radius = 140
			local range = 800
			local speed = 400 + RandomInt(0, 250)
				local info = 
				{
						Ability = ability,
			        	EffectName = projectileParticle,
			        	vSpawnOrigin = caster:GetAbsOrigin()+Vector(0,0,60),
			        	fDistance = range,
			        	fStartRadius = start_radius,
			        	fEndRadius = end_radius,
			        	Source = caster,
			        	StartPosition = "attach_attack1",
			        	bHasFrontalCone = true,
			        	bReplaceExisting = false,
			        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			        	fExpireTime = GameRules:GetGameTime() + 4.0,
					bDeleteOnHit = false,
					vVelocity = fv * speed,
					bProvidesVision = false,
				}
				projectile = ProjectileManager:CreateLinearProjectile(info)
		end
	end
end

function voltex_glyph_4_1_strike(event)
	local target = event.target
	local caster = event.ability.hero
	local damage = caster:GetAverageTrueAttackDamage(caster)*2
	local sound = "Hero_Zuus.ArcLightning.Target" 
    EmitSoundOn(sound, target)
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
end

function venomort_glyph_5_1_attack(event)
	local attacker = event.attacker
	local target = event.target
	if attacker:IsAlive() then
		if attacker:HasModifier("modifier_venomort_glyph_5_1_immunity") then
			attacker:RemoveModifierByName("modifier_venomort_glyph_5_1_immunity")
		else
			if target:IsAlive() then
				Filters:PerformAttackSpecial(attacker, target, true, true, true, false, true, false, false)
				local caster = event.caster
				local ability = event.ability
				StartAnimation(attacker, {duration=0.2, activity=ACT_DOTA_ATTACK, rate=2.5})
				ability:ApplyDataDrivenModifier(caster, attacker, "modifier_venomort_glyph_5_1_immunity", {duration = 1})
			end
		end
	end
end

function axe_glyph_6_1_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, target, "modifier_axe_glyph_6_1_effect", {})
	target:SetModifierStackCount( "modifier_axe_glyph_6_1_effect", ability, target:GetStrength() )
end

-- function axe_glyph_7_1_take_damage(event)
-- 	local target = event.unit
-- 	local damage = event.attack_damage
-- 	local caster = event.caster
-- 	local ability = event.ability
-- 	if not ability.damagePool then
-- 		ability.damagePool = 0
-- 	end
-- 	target:Heal(damage*0.8, target)
-- 	ability.damagePool = ability.damagePool + damage*0.8
-- 	ability:ApplyDataDrivenModifier(caster, target, "modifier_axe_glyph_7_1_effect", {duration = 3})
-- end

-- function axe_glyph_7_1_damage_think(event)
-- 	local ability = event.ability
-- 	local target = event.target
-- 	local currentHealth = target:GetHealth()
-- 	target:SetHealth(currentHealth-(ability.damagePool/3))
-- 	ability.damagePool = ability.damagePool - ability.damagePool/3
-- end

-- function axe_glyph_7_1_destroy(event)
-- 	local ability = event.ability
-- 	local target = event.target
-- 	local currentHealth = target:GetHealth()
-- 	local newHealth = currentHealth-ability.damagePool
-- 	if newHealth <= 0 then

-- 		target:SetHealth(currentHealth-ability.damagePool)
-- 	else
-- 		target:Kill(ability, target)
-- 	end
-- 	ability.damagePool = 0
-- end

function astral_glyph_6_1_attack_land(event)
	local attacker = event.attacker
	local target = event.target
	if target.dummy then
		return
	end
	local extraPure = attacker:GetAverageTrueAttackDamage(attacker)*0.1
	ApplyDamage({ victim = target, attacker = attacker, damage = extraPure, damage_type = DAMAGE_TYPE_PURE})
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_drow/drow_dust_hit.vpcf", target, 0.3)
	print("EXTRAPURE"..extraPure)
end

function epoch_glyph_5_1_attack_land(event)
	local ability = event.ability
	local caster = event.caster
	local attacker = event.attacker
	local target = event.target
	local b_b_lvl = Runes:GetTotalRuneLevel(attacker, 2, "b_b", "epoch")
	if b_b_lvl > 0 then
		local runeW2ArmourDecrease = 50 --each w2 reduce armor for -50
		local maximumNegativeArmor = 1000 --w2 cap at -1000
		local finalStacksCount = b_b_lvl
		local runesToDecrease = (target:GetPhysicalArmorBaseValue() + maximumNegativeArmor)/runeW2ArmourDecrease - b_b_lvl
		if runesToDecrease < 0 then
			finalStacksCount = math.ceil ((target:GetPhysicalArmorBaseValue() + maximumNegativeArmor)/runeW2ArmourDecrease);
		end

		local abilityToApplyModifier = attacker:FindAbilityByName("time_genesis_orb")
		abilityToApplyModifier:ApplyDataDrivenModifier(attacker, target, "modifier_epoch_rune_b_b_visible", {duration = 6})
		target:SetModifierStackCount("modifier_epoch_rune_b_b_visible", attacker, finalStacksCount)

	end
end

function monk_glyph_6_1_activate(event)
	local target = event.target
	local hikari = target:FindAbilityByName("monk_heal")
	if not hikari.originalCastpoint then
		local originalCastpoint = hikari:GetCastPoint()
		hikari.originalCastpoint = originalCastpoint
	end
	print(hikari)
	print("OVERRIDE DAT CAST POINT")
	hikari:SetOverrideCastPoint(0)
end

function monk_glyph_6_1_deactivate(event)
	local target = event.target
	local hikari = target:FindAbilityByName("monk_heal")
	print("DEACTIVATE")
	hikari:SetOverrideCastPoint(hikari.originalCastpoint)
end

function paladin_glyph_7_1_attack(event)
	local attacker = event.attacker
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	if attacker:HasModifier("modifier_paladin_glyph_7_1_immunity") then
		attacker:RemoveModifierByName("modifier_paladin_glyph_7_1_immunity")
	else
		local luck = RandomInt(1,10)
		if luck <= 4 then
			StartAnimation(attacker, {duration=0.2, activity=ACT_DOTA_ATTACK, rate=2.5})
			local enemies = FindUnitsInRadius( attacker:GetTeamNumber(), attacker:GetAbsOrigin(), nil, attacker:GetAttackRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			if #enemies > 0 then
				local newTarget = enemies[RandomInt(1,#enemies)]
				attacker:SetForwardVector((newTarget:GetAbsOrigin()*Vector(1,1,0) - caster:GetAbsOrigin()):Normalized())
				ability:ApplyDataDrivenModifier(caster, attacker, "modifier_paladin_glyph_7_1_zeal_turn", {duration = 0.12})
				ability:ApplyDataDrivenModifier(caster, attacker, "modifier_paladin_glyph_7_1_immunity", {duration = 1})
				Timers:CreateTimer(0.1, function()
					if newTarget:IsAlive() then
						local bProjectile = false
						if attacker:GetAttackRange() > 300 then
							bProjectile = true
						end
						Filters:PerformAttackSpecial(attacker, newTarget, true, true, true, false, bProjectile, false, false)

						
					end
				end)
			end
		end
	end
end

function sorceress_glyph_5_1_initialize(event)
	local caster = event.target
  	local arcaneTorrent = caster:FindAbilityByName("arcane_torrent")
  	if not arcaneTorrent then
  		arcaneTorrent = caster:AddAbility("arcane_torrent")
  	end
  	CustomAbilities:AddAndOrSwapSkill(caster, "arcane_explosion", "arcane_torrent", 1)
end

function sorceress_glyph_5_1_end(event)
	local caster = event.target
	local level = caster:FindAbilityByName("arcane_torrent"):GetLevel()
	CustomAbilities:AddAndOrSwapSkill(caster, "arcane_torrent", "arcane_explosion", 1)
end

function glyph_5_1_kill(event)
	local attacker = event.attacker
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, attacker, "modifier_warlord_glyph_5_1_effect", {duration = 9})
    local current_stack = attacker:GetModifierStackCount( "modifier_warlord_glyph_5_1_effect", ability )
    local newStacks = math.min(current_stack+1, 50)
    ability.newStacks = newStacks
    attacker:SetModifierStackCount( "modifier_warlord_glyph_5_1_effect", ability, newStacks )
end

function warlord_glyph_5_1_end(event)
	local caster = event.caster
	local ability = event.ability
	local attacker = event.target
	ability.newStacks = math.max(ability.newStacks - 1, 0)
	if ability.newStacks > 0 then
		ability:ApplyDataDrivenModifier(caster, attacker, "modifier_warlord_glyph_5_1_effect", {duration = 9})
		attacker:SetModifierStackCount( "modifier_warlord_glyph_5_1_effect", ability, ability.newStacks )
	end
end

function warlord_glyph_7_1_attack(event)
	local damage = event.damage
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	damage = GameState:GetPostReductionPhysicalDamage(damage, target:GetPhysicalArmorValue())

	local radius = 320
	      local particleName = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
	      local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_WORLDORIGIN, target )
	      ParticleManager:SetParticleControl( particle2, 0, target:GetAbsOrigin() )
	      ParticleManager:SetParticleControl( particle2, 1, Vector(radius,radius,radius) )
	      ParticleManager:SetParticleControl( particle2, 2, Vector(1.2, 1.2, 1.2) )
	      ParticleManager:SetParticleControl( particle2, 4, Vector(255, 30, 30) )
	      Timers:CreateTimer(1.5, 
	      function()
	        ParticleManager:DestroyParticle( particle2, false )
	      end)

	local enemies = FindUnitsInRadius( attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			ApplyDamage({ victim = enemy, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })
		end
	end 
end

function duskbringer_glyph_7_1_initialize(event)
	local caster = event.target
  	local manifestation = caster:FindAbilityByName("manifestation")
  	if not manifestation then
  		manifestation = caster:AddAbility("manifestation")
  	end
  	local specterRush = caster:FindAbilityByName("specter_rush_two")
  	manifestation:SetLevel(specterRush:GetLevel())
  	manifestation:SetAbilityIndex(2)
  	caster:SwapAbilities("specter_rush_two", "manifestation", false, true)
end

function duskbringer_glyph_7_1_end(event)
	local caster = event.target
	local level = caster:FindAbilityByName("manifestation"):GetLevel()
  	caster:FindAbilityByName("specter_rush_two"):SetLevel(level)
  	caster:SwapAbilities("specter_rush_two", "manifestation", true, false)
end

function auriun_glyph_7_1_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, target, "modifier_auriun_glyph_7_1_effect", {})
	local damageBonus = (target:GetAgility() + target:GetStrength())*5
	target:SetModifierStackCount( "modifier_auriun_glyph_7_1_effect", ability, damageBonus )
end

function use_glyph_book(event)
	local caster = event.caster
	local book = event.ability
	local heroName = event.hero
	local playerID = caster:GetPlayerOwnerID()
	local steamID = PlayerResource:GetSteamAccountID(playerID)

	local class = string.gsub(book:GetAbilityName(), "item_rpc_", "")
	class = string.gsub(class, "_glyph_book", "")
	caster:TakeItem(book)
	local url = ROSHPIT_URL.."/champions/updateGlyphRecipe?"
	url = url.."steam_id="..steamID
	url = url.."&hero="..HerosCustom:ConvertRPCNameToStringHeroName(class)
	url = url.."&tier="..book.property1
	url = url.."&column="..book.property2
	print(url)
	CreateHTTPRequestScriptVM( "GET", url ):Send( function( result )
		local resultTable = {}
		print( "GET response:\n" )
		for k,v in pairs( result ) do
			print( string.format( "%s : %s\n", k, v ) )
		end
		print( "Done." )
		local resultTable = JSON:decode(result.Body)
		-- resultTable = Quests:GetQuestDataFromJSON(resultTable)
		print(resultTable)
		if resultTable == 1 then
			EmitSoundOn("RPC.Glyph.LearnRecipe", caster)
			CustomAbilities:QuickAttachParticle("particles/roshpit/learn_glyph_recipe.vpcf", caster, 5)
			Notifications:Top(caster:GetPlayerOwnerID(), {text="Recipe Learned!", duration=3, style={color="#D378ED"}, continue=true})
			UTIL_Remove(book)
		else
			Notifications:Top(caster:GetPlayerOwnerID(), {text="Already Learned", duration=3, style={color="red"}, continue=true})
			RPCItems:GiveItemToHeroWithSlotCheck(caster, book)
		end
	end )
end