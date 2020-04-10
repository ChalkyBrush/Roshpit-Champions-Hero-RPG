function diviner_think(event)
	local caster = event.caster
	local ability = event.ability
	AddFOWViewer(DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), 500, 3, false)
	if caster.phase == 0 then
		local searchPosition = Vector(11820, 14036, 1286)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), searchPosition, nil, 280, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				local player = enemy:GetPlayerOwner()
				CustomGameEventManager:Send_ServerToPlayer(player, "open_winter_castle_event", {})
			end
		end
	elseif caster.phase == 2 then
		local target_pos = Vector(11800, 13400)
		caster:MoveToPosition(target_pos)
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), target_pos)
		if distance < 80 then
			caster.phase = 3
			Timers:CreateTimer(1, function()
				CustomAbilities:QuickParticleAtPoint("particles/econ/items/necrolyte/necronub_death_pulse/necrolyte_pulse_ka_explosion_flash_glow.vpcf", caster:GetAttachmentOrigin(0), 2)
				local card_prop = caster.card_prop
				caster.card_prop = nil

				local card_index = caster.selected_card + 1

				StartAnimation(caster, {duration = 1.0, activity = ACT_DOTA_CAST_ABILITY_1, rate = 1})
				EmitSoundOn("Winterblight.Horus.CardThrow.VO", caster)
				EmitSoundOnLocationWithCaster(card_prop:GetAbsOrigin(), "Winterblight.Horus.Throw", caster)
				card_prop:SetAbsOrigin(Vector(11808, 13046, 2180))
				Events:smoothTranslate(card_prop, Vector(0,0,-40), 15, Vector(0,0), nil)
				Timers:CreateTimer(0.35, function()
					CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/castle_tarot_splash.vpcf", Vector(11808, 13046, 1767), 5)
					EmitSoundOnLocationWithCaster(card_prop:GetAbsOrigin(), "Winterblight.TarotCard.Dunk", caster)
					ScreenShake(Vector(11808, 13046, 1767), 800, 1, 1, 9000, 0, true)
				end)
				Timers:CreateTimer(1.0, function()
					EmitSoundOn("Winterblight.Tarot.Suspense", caster)
				end)
				Timers:CreateTimer(1.7, function()
					local hand1 = Entities:FindByNameNearest("castle_tarot_hands", Vector(11659, 12968, 1800), 800)
					local hand2 = Entities:FindByNameNearest("castle_tarot_hands", Vector(11916, 12968, 1800), 800)
					Events:objectShake(hand1, 80, 8, true, false, true, "Winterblight.TarotHands.Shake", 20)
					Events:objectShake(hand2, 80, 8, true, false, true, "Winterblight.TarotHands.Shake", 20)
					EmitSoundOnLocationWithCaster(Vector(11808, 13046, 2000), "Winterblight.TarotHYPE", caster)
					ScreenShake(Vector(11808, 13046, 1767), 800, 1, 1, 9000, 0, true)
				end)

				Timers:CreateTimer(6.2, function()
					CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/castle_tarot_splash.vpcf", Vector(11808, 13046, 1767), 5)
					ScreenShake(Vector(11808, 13046, 1767), 800, 1, 1, 9000, 0, true)
					EmitSoundOnLocationWithCaster(Vector(11808, 13046, 1767), "Winterblight.TarotCard.PopoutDunk", caster)
					local tarot_symbol = CreateUnitByName("npc_flying_dummy_vision", Vector(11807, 13048), true, nil, nil, DOTA_TEAM_GOODGUYS)
					ability:ApplyDataDrivenModifier(caster, tarot_symbol, "modifier_tarot_symbol_floating_thinker", {})
					tarot_symbol:SetAbsOrigin(tarot_symbol:GetAbsOrigin()+Vector(0,0,280))
					tarot_symbol:SetDayTimeVisionRange(500)
					tarot_symbol:SetNightTimeVisionRange(500)
					tarot_symbol:RemoveModifierByName("dummy_unit")
					local dummy_ability = tarot_symbol:FindAbilityByName("dummy_unit")
					dummy_ability:ApplyDataDrivenModifier(tarot_symbol, tarot_symbol, "dummy_unit", {})
					tarot_symbol:SetForwardVector(Winterblight.CastleTarot["prop_angle"])
					tarot_symbol:SetModelScale(0.1)
					local model_name = "models/winterblight/tarot/"..Winterblight.CastleTarot["index"].."-"..Winterblight.CastleTarot["name"]..".vmdl"
					print(model_name)
					tarot_symbol:SetModel(model_name)
					tarot_symbol:SetOriginalModel(model_name)
					-- Events:smoothTranslate(tarot_symbol, Vector(0,0,7), 40, Vector(0, 0), nil)
					Events:smoothSizeChange(tarot_symbol, 0.1, Winterblight.CastleTarot["prop_scale"], 40)
					Timers:CreateTimer(1.3, function()
						tarot_symbol.active = true
						if Winterblight.CastleTarot["horror"] then
							EmitSoundOnLocationWithCaster(Vector(11808, 13046, 1767), "Winterblight.Tarot.PianoSlamHorror", Events.GameMaster)
						else
							EmitSoundOnLocationWithCaster(Vector(11808, 13046, 1767), "Winterblight.Tarot.PianoSlam", Events.GameMaster)
						end
					end)
				end)
				Timers:CreateTimer(8.2, function()
					StartAnimation(caster, {duration = 1.4, activity = ACT_DOTA_ATTACK, rate = 1})
					Quests:ShowDialogueText(MAIN_HERO_TABLE, caster, "tarot_"..Winterblight.CastleTarot["name"], 4, false)
					EmitSoundOn("Winterblight.Horus.CardThrow.VO", caster)
					-- EmitSoundOn("Winterblight.DescribeTarotHaunt", caster)

				end)
				Timers:CreateTimer(12.2, function()
					StartAnimation(caster, {duration = 1.4, activity = ACT_DOTA_ATTACK, rate = 1})
					Quests:ShowDialogueText(MAIN_HERO_TABLE, caster, "tarot_"..Winterblight.CastleTarot["name"].."_description", 5, false)
					EmitSoundOn("Winterblight.DescribeTarotHaunt", caster)
				end)
				Timers:CreateTimer(16.2, function()
					caster.phase = 4
					caster:MoveToPosition(Vector(12544, 13568))
				end)
			end)
		end
	elseif caster.phase == 4 then
		local target_pos = Vector(12544, 13568)
		caster:MoveToPosition(target_pos)
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), target_pos)
		if distance < 80 then
			caster.phase = 5
			caster:MoveToPosition(caster:GetAbsOrigin() + Vector(-30, 0))
			Timers:CreateTimer(1.2, function()
				caster.phase = 6
			end)
		end
	elseif caster.phase == 6 then
		caster.phase = 7
		Timers:CreateTimer(0.3, function()
			EmitSoundOn("Winterblight.Horus.Exit.VO", caster)
			StartAnimation(caster, {duration = 1.4, activity = ACT_DOTA_CAST_ABILITY_4, rate = 1})
		end)
		Timers:CreateTimer(0.7, function()
			caster:AddNoDraw()
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_diviner_invisible", {})
			CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/blue_raze.vpcf", caster:GetAbsOrigin(), 3)
			EmitSoundOn("Winterblight.GraveGhostSpawn", caster)
		end)
		Timers:CreateTimer(3, function()
			Winterblight:OpenCastleDoorByIndex(1)
			Winterblight:CastleLobbySpawn1()
			StartSoundEvent("Winterblight.HorusHYPE", caster)
		end)
		Timers:CreateTimer(6.0, function()
			EmitSoundOn("Winterblight.Horus.Laugh.VO", caster)
		end)
		Timers:CreateTimer(7.5, function()
			StopSoundEvent("Winterblight.HorusHYPE", caster)
		end)
	end
end

function winterblight_castle_dungeon_master_main_thinker(event)
	local caster = event.caster
	if not caster.think_interval then
		caster.think_interval = 0
	end
	caster.think_interval = caster.think_interval + 1

	if caster.think_interval%30 == 0 then
		CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf", Vector(14639, 12340, 1520), 3)
		CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf", Vector(15237, 9998, 2080), 3)
	end
	if caster.think_interval == 200 then
		caster.think_interval = 0
	end
	if caster.card_prop then
		local card_position = caster:GetAttachmentOrigin(0)
		caster.card_prop:SetAbsOrigin(card_position)
	end
end

function tarot_symbol_float_think(event)
	local target = event.target
	if not target.active then
		return false
	end
	if not target.interval then
		target.interval = 0
	end
	target:SetAbsOrigin(target:GetAbsOrigin() + Vector(0, 0, 3) * math.cos(2 * math.pi * target.interval / 90))
	target.interval = target.interval + 1
	-- local rotatedFV = WallPhysics:rotateVector(target:GetForwardVector(), 2 * math.pi / 90)
	-- target:SetForwardVector(rotatedFV)
	if target.interval == 90 then
		target.interval = 0
	end
end

function reincarnation_respawning_end(event)
	local caster = event.caster
	local ability = event.ability

    EmitSoundOn("Winterblight.Reincarnation.Respawn", caster)
    FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
    caster:RemoveNoDraw()
    CustomAbilities:QuickParticleAtPoint("particles/roshpit/items/ankh_of_ancients_respawn.vpcf", caster:GetAbsOrigin(), 3)
    caster:SetHealth(caster:GetMaxHealth())
    caster:SetMana(caster:GetMaxMana())
    ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
    if caster.aggroSound then
    	EmitSoundOn(caster, caster.aggroSound)
    end
end