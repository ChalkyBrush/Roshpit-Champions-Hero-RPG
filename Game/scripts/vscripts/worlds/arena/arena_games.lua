function Arena:WaterGameStart(hero)
	Challenges:ModifyMithril(-100, hero, "water_game")
	hero.waterGame = true
	Arena.gameElementalTable = {}
	local basePos = Vector(-10944, -7232)
	Arena.WaterMagician.gameStart = true
	Arena.WaterMagician.validHero = hero:GetEntityIndex()
	Arena.WaterMagician.gameAbility = Arena.WaterMagician:FindAbilityByName("arena_water_magician_ability")
	print('WaterGameStart')
	Timers:CreateTimer(0.2, function()
		EmitSoundOn("Arena.MagicianLaugh", Arena.WaterMagician)
	end)
	Timers:CreateTimer(2.5, function()
		Arena:basic_dialogue(Arena.WaterMagician, {hero}, "aquatarium_start", 10, 5, -30)
		Arena.WaterMagician:MoveToPosition(Vector(-10560, -6720))
		Timers:CreateTimer(3, function()
			for i = 1, 18, 1 do
				Timers:CreateTimer(i*0.8, function()
					local randomX = RandomInt(1,1080)
					local randomY = RandomInt(1,1000)
					local elemental = CreateUnitByName("arena_game_elemental", basePos+Vector(randomX, randomY), false, nil, nil, DOTA_TEAM_BADGUYS)
					Arena.WaterMagician.gameAbility:ApplyDataDrivenModifier(Arena.WaterMagician, elemental, "modifier_elemental_moving", {})
					table.insert(Arena.gameElementalTable, elemental)
					CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_morphling/morphling_replicate.vpcf", elemental, 1)
					EmitSoundOn("Arena.WaterMagicianSummon", elemental)
					StartAnimation(Arena.WaterMagician, {duration=0.75, activity=ACT_DOTA_CAST_ABILITY_2, rate=1.0})
					Events:CreateCollectionBeam(Arena.WaterMagician:GetAbsOrigin()+Vector(0,0,200), elemental:GetAbsOrigin()+Vector(0,0,100))
				end)
			end
			Timers:CreateTimer(10, function()
				Arena:basic_dialogue(Arena.WaterMagician, {hero}, "aquatarium_working", 4, 5, -30)
			end)
			Timers:CreateTimer(0.8*19, function()
				local randomX = RandomInt(1,1080)
				local randomY = RandomInt(1,540)
				Arena.WaterMagician:MoveToPosition(basePos+Vector(randomX, randomY))
				Timers:CreateTimer(0.5, function()
					Arena:basic_dialogue(Arena.WaterMagician, {hero}, "aquatarium_ready", 4, 5, -30)
				end)
				Timers:CreateTimer(4.7, function()
					local fv = Arena.WaterMagician:GetForwardVector()
					local position = Arena.WaterMagician:GetAbsOrigin()
					Arena.WaterMagician:AddNoDraw()
					local elemental = CreateUnitByName("arena_game_elemental", position, false, nil, nil, DOTA_TEAM_BADGUYS)
					elemental:SetForwardVector(fv)
					Arena.WaterMagician.gameAbility:ApplyDataDrivenModifier(Arena.WaterMagician, elemental, "modifier_elemental_moving", {})
					table.insert(Arena.gameElementalTable, elemental)
					CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_morphling/morphling_replicate.vpcf", elemental, 1)
					EmitSoundOn("Arena.WaterMagicianSummon", elemental)
					elemental.real = true
					-- elemental:SetRenderColor(0, 0, 0)
					StartSoundEvent("Arena.WaterGameMusic", Arena.WaterMagician)

					Timers:CreateTimer(3, function()
						for i = 1, #Arena.gameElementalTable, 1 do
							Timers:CreateTimer(i*0.1, function()
								local elemental = Arena.gameElementalTable[i]
								Arena.WaterMagician.gameAbility:ApplyDataDrivenModifier(Arena.WaterMagician, elemental, "modifier_game_elemental_thinking", {})
							end)
						end
						Timers:CreateTimer(30, function()
							for i = 1, #Arena.gameElementalTable, 1 do
								local elemental = Arena.gameElementalTable[i]
								elemental.stopWaveForm = true
							end
						end)
						Timers:CreateTimer(35, function()
							EmitSoundOnLocationWithCaster(Vector(-10500, -6720), "Arena.WaterGameMusicEnd", Arena.ArenaMaster)
							Timers:CreateTimer(1.5, function()
								StopSoundEvent("Arena.WaterGameMusic", Arena.WaterMagician)
								for i = 1, #Arena.gameElementalTable, 1 do
									local elemental = Arena.gameElementalTable[i]
									elemental:RemoveModifierByName("modifier_game_elemental_thinking")
									elemental:RemoveModifierByName("modifier_elemental_moving")
									Arena.WaterMagician.gameAbility:ApplyDataDrivenModifier(Arena.WaterMagician, elemental, "modifier_elemental_ready_or_choosing", {})
								end
							end)
						end)
					end)
				end)
			end)
		end)
	end)
end

	