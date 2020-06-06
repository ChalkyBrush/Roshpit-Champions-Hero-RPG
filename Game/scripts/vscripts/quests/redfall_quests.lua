if RedfallQuests == nil then
    RedfallQuests = class({})
end

function RedfallQuests:NewQuest(questIndex)
    for i = 1, #MAIN_HERO_TABLE, 1 do
        EmitSoundOnClient("Redfall.NewQuest", MAIN_HERO_TABLE[i]:GetPlayerOwner())
        EmitSoundOnLocationWithCaster(MAIN_HERO_TABLE[i]:GetAbsOrigin(), "Redfall.NewQuest", Redfall.RedfallMaster)
	end
	local questdata = nil
    if questIndex == ROSHPIT_QUEST_REDFALL_HEART_OF_THE_FOREST then
    elseif questIndex == ROSHPIT_QUEST_REDFALL_SHRINE_OF_MARU then
    elseif questIndex == ROSHPIT_QUEST_REDFALL_CLEANSING_THE_COAST then
    elseif questIndex == ROSHPIT_QUEST_REDFALL_AUTUMN_ASH then
    elseif questIndex == ROSHPIT_QUEST_REDFALL_SEEKING_ASHARA then
        questdata = {
            objectives = {
                {
                    target = "quests_seeking_ashara_objective3",
                    count = 1,
                    availableOnObjectivesCompleted = 2
                },
                {
                    target = "quests_seeking_ashara_objective4",
                    count = 1,
                    availableOnObjectivesCompleted = 3
                },
                {
                    target = "redfall_ashara",
                    count = 1,
                    availableOnObjectivesCompleted = 4
                }
            }
        }
    elseif questIndex == ROSHPIT_QUEST_REDFALL_FALLEN_KING_OF_THE_WOLVES then
        questdata = {
            questname = "fenrir",
            rewardfunction = function(playerId)
                local hero = PlayerResource:GetPlayer(playerId):GetAssignedHero()
                local item_level = math.min(RandomInt(25, 30) * GameState:GetDifficultyFactor(), hero:GetLevel())
                local fang = RPCItems:RollImmortalByName("item_rpc_fenrirs_fang", item_level)
                if IsValidEntity(fang:GetContainer()) then
                    UTIL_Remove(fang:GetContainer())
                end
                fang.pickedUp = true
                fang.expiryTime = false
                RPCItems:GiveItemToHeroWithSlotCheck(hero, fang)
            end,
            rewards = {
				{
					rewardName = "item_rpc_fenrirs_fang",
					rewardType = ROSHPIT_QUEST_REWARD_TYPE_IMMORTAL
				}
			},
            objectives = {
                {
                    target = "redfall_fenrir",
                    count = 1
                }
            }
        }
    elseif questIndex == ROSHPIT_QUEST_REDFALL_FREEING_THE_WORLD_TREE then
        questdata = {
            questname = "freeing_the_world_tree",
            rewardfunction = function(playerId)
                local hero = PlayerResource:GetPlayer(playerId):GetAssignedHero()
            end,
            rewards = {
				{
					rewardName = "item_redfall_purified_vermillion_bundle_normal",
					rewardType = ROSHPIT_QUEST_REWARD_TYPE_KEY
				},
				{
					rewardName = "tooltip_current_shards",
					rewardType = ROSHPIT_QUEST_REWARD_TYPE_MITHRIL,
					rewardAmount = RedfallQuests:GetMithrilReward(REDFALL_MITHRIL_CANYON)
				}
			},
            objectives = {
                {
                    target = "quests_freeing_the_world_tree_objective1",
					count = 1,
					ping = 
					{
						Vector(-15352, -8303)
					}
                }
            }
        }
    elseif questIndex == ROSHPIT_QUEST_REDFALL_DEATH_AND_TAXES then
    elseif questIndex == ROSHPIT_QUEST_REDFALL_HARVESTING_DUTY then
    end
    Quests:AddQuestToAllPlayers(questdata)
end

function RedfallQuests:ApplyQuestrewardBuff(hero, modifierName, duration)
    Timers:CreateTimer(0, function()
        if hero:IsAlive() then
            if duration then
                Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, hero, modifierName, {duration = duration})
            else
                Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, hero, modifierName, {})
            end
        else
            return 1
        end
    end)
end

function RedfallQuests:ApplyQuestrewardBuffToAllPlayers(modifierName, duration)
    for i = 1, #MAIN_HERO_TABLE, 1 do
        RedfallQuests:ApplyQuestrewardBuff(MAIN_HERO_TABLE[i], modifierName, duration)
    end
end



function RedfallQuests:GetMithrilReward(baseReward)
	local mithrilMult = REDFALL_MITHRIL_NORMAL_MULT
	if GameState:GetDifficultyFactor() == 2 then
	  mithrilMult = REDFALL_MITHRIL_ELITE_MULT
	elseif GameState:GetDifficultyFactor() == 3 then
	  mithrilMult = REDFALL_MITHRIL_LEGEND_MULT
	end
	if Events.SpiritRealm then
	  mithrilMult = mithrilMult * REDFALL_MITHRIL_EQUINOX_MULT
	end
	local mithrilReward = math.floor(baseReward * mithrilMult) * Events.ResourceBonus

	return mithrilReward
end



-- 	Timers:CreateTimer(5, function()
-- 	  local mithrilReward = 0
-- 	  local starTitle = nil
-- 	  if dungeon == "canyon" then
-- 		mithrilReward = REDFALL_MITHRIL_CANYON
-- 		starTitle = "autumnmist"
-- 	  elseif dungeon == "shipyard" then
-- 		mithrilReward = REDFALL_MITHRIL_SHIPYARD
-- 		starTitle = "shipyard"
-- 	  elseif dungeon == "castle" then
-- 		mithrilReward = REDFALL_MITHRIL_CASTLE
-- 		starTitle = "castle"
-- 	  elseif dungeon == "ancient_tree" then
-- 		mithrilReward = REDFALL_MITHRIL_WORLD_TREE
-- 	  elseif dungeon == "ashara" then
-- 		mithrilReward = REDFALL_MITHRIL_ASHARA
-- 	  end
-- 	  if starTitle then
-- 		for i = 1, #MAIN_HERO_TABLE, 1 do
-- 		  Stars:StarEventPlayer(starTitle, MAIN_HERO_TABLE[i])
-- 		end
-- 	  end
-- 	  local crystal = CreateUnitByName("arcane_crystal", position + Vector(0, 0, 1000), false, nil, nil, DOTA_TEAM_GOODGUYS)
-- 	  crystal:SetAbsOrigin(crystal:GetAbsOrigin() + Vector(0, 0, 1300))
-- 	  local crystalAbility = crystal:AddAbility("mithril_shard_ability")
-- 	  crystalAbility:SetLevel(1)
-- 	  local fv = RandomVector(1)
-- 	  crystal:SetOriginalModel("models/props_gameplay/rune_doubledamage01.vmdl")
-- 	  crystal:SetModel("models/props_gameplay/rune_doubledamage01.vmdl")
-- 	  crystal.reward = mithrilReward
-- 	  crystal.reward = math.floor(crystal.reward * (1 + GameState:GetPlayerPremiumStatusCount() * 0.1))
-- 	  crystal.distributed = 0
-- 	  local baseModelSize = math.min(2.9, 1.2 + crystal.reward / 200)
-- 	  crystal.modelScale = baseModelSize
-- 	  crystal:SetModelScale(baseModelSize)
-- 	  crystal.fallVelocity = 45
-- 	  crystal.falling = true
-- 	  crystal.winnerTable = RPCItems:GetConnectedPlayerTable()
-- 	  -- local potentialWinnerTable = RPCItems:GetConnectedPlayerTable()
-- 	  -- for i = 1, #potentialWinnerTable, 1 do
-- 	  --  local completedTable = CustomNetTables:GetTableValue("player_stats", tostring(potentialWinnerTable[i]:GetPlayerOwnerID()).."-challenge")
-- 	  --  local completed = completedTable.completed
-- 	  --  if completed == 0 then
-- 	  --    potentialWinnerTable[i].shardsPickedUp = 0
-- 	  --    table.insert(crystal.winnerTable, potentialWinnerTable[i])
-- 	  --  end
-- 	  -- end
-- 	  if #crystal.winnerTable > 0 then
-- 		-- for i = 1, #crystal.winnerTable, 1 do
-- 		--   crystal.winnerTable[i].shardsPickedUp = 0
-- 		-- end
-- 		Timers:CreateTimer(1.4, function()
-- 		  EmitSoundOn("Resource.MithrilShardEnter", crystal)
-- 		end)
-- 	  end
-- 	end)
--   end