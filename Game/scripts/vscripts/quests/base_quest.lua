base_quest = class({})

function base_quest:GetQuestName()
    --Used to find localization
    return "quest_name"
end

function base_quest:StartQuest()
    self.data = {}
    self.data.status = ROSHPIT_QUEST_STATUS_ACTIVE
    self.data.objectivesCompleted = 0
    local objectives = self:GetObjectives()
    for i = 1, #objectives, 1 do
        objectives[i].data = {}
        objectives[i].data.currentCount = 0
    end
    local rewards = self:GetRewards()
    for i = 1, #rewards, 1 do
        if rewards[i].type == ROSHPIT_QUEST_REWARD_TYPE_MITHRIL then
            rewards[i].amount = Quests:GetRealMithrilReward(rewards[i].amount)
        end
        rewards[i].claimed = {}
    end
    self.data.rewards = rewards
end

function base_quest:GetRewards()
    --The names that are used to show the reward in Quest
    --e.g. item_redfall_purified_vermillion_bundle_normal
    --And reward type to define the color in UI
    -- ROSHPIT_QUEST_REWARD_TYPE_NONE = 0
    -- ROSHPIT_QUEST_REWARD_TYPE_KEY = 1
    -- ROSHPIT_QUEST_REWARD_TYPE_BUFF = 2
    -- ROSHPIT_QUEST_REWARD_TYPE_IMMORTAL = 3
    -- ROSHPIT_QUEST_REWARD_TYPE_MITHRIL = 4
    -- ROSHPIT_QUEST_REWARD_TYPE_ARCANE_CRYSTALS = 5
    -- ROSHPIT_QUEST_REWARD_TYPE_PRISMATIC_GEMSTONES = 6
    --
    -- Example of it all:
    -- {
    --     { 
    --         name = "item_redfall_purified_vermillion_bundle_normal", 
    --         type = ROSHPIT_QUEST_REWARD_TYPE_KEY,
    --         autoReward = false
    --     },
    --     {
    --         name = "ui_mithril_shards",
    --         type = ROSHPIT_QUEST_REWARD_TYPE_MITHRIL
    --         amount = REDFALL_MITHRIL_ASHARA, --Multipliers for the world are applied automatically in quests.lua in function Quests:GetRealMithrilReward(baseReward)
    --         autoReward = true
    --     },
    --     {
    --         name = "modifier_blessing_of_ashara",
    --         type = ROSHPIT_QUEST_REWARD_TYPE_BUFF
    --         amount = 3600,
    --         autoReward = true
    --     }
    -- }
    return {}
end

function base_quest:IncrementObjective(objectiveString)
    print("Objective: "..objectiveString)
    for objectiveIndex = 1, #self:GetObjectives(), 1 do
        if self:GetObjectives()[objectiveIndex]:GetObjectiveTarget() == objectiveString then
            self:GetObjectives()[objectiveIndex]:IncrementObjective()
            print("Incremented objective: "..objectiveString)
            print("Objectives: "..self:GetObjectivesCount())
            print("Objectives Completed: "..self:GetCompletedObjectivesCount())
            if self:GetObjectivesCount() == self:GetCompletedObjectivesCount() then
                self.data.status = ROSHPIT_QUEST_STATUS_COMPLETED
                local rewards = self:GetRewards()
                for i = 1, #MAIN_HERO_TABLE, 1 do
                    local playerId = MAIN_HERO_TABLE[i]:GetPlayerOwnerID()
                    for rewardIndex = 1, #rewards, 1 do
                        if rewards[rewardIndex].autoReward then
                            print("Autorewarding: "..rewardIndex)
                            self:ClaimReward(playerId, rewardIndex)
                        else
                            self.data.rewards[rewardIndex].claimed[playerId] = false
                        end
                        Quests:UpdateQuests()
                    end
                end
            end
            return
        end
    end
end

function base_quest:GetCompletedObjectivesCount()
    local objectives = self:GetObjectives()
    local completedObjectives = 0
    for i = 1, #objectives, 1 do
        if objectives[i]:GetObjectiveCurrentCount() == objectives[i]:GetObjectiveTargetCount() then
            completedObjectives = completedObjectives + 1
        end
    end
    return completedObjectives
end

function base_quest:GetObjectivesCount()
    return #self:GetObjectives()
end

function base_quest:OnRewardClaimed(playerId)
    return
end

function base_quest:ClaimReward(playerId, rewardIndex)
    print("Claiming reward playerId: "..playerId.." rewardIndex: "..rewardIndex)
    DeepPrintTable(self.data.rewards[rewardIndex])
    local reward = self.data.rewards[rewardIndex]
    self:OnRewardClaimed(playerId)
    if reward.claimed[playerId] then
        return
    end
    self.data.rewards[rewardIndex].claimed[playerId] = true
    local hero = PlayerResource:GetPlayer(playerId):GetAssignedHero()
    if reward.type == ROSHPIT_QUEST_REWARD_TYPE_NONE then
		--Nothing happens
	elseif reward.type == ROSHPIT_QUEST_REWARD_TYPE_KEY then
        local item_name = reward.name
        local key = RPCItems:CreateConsumable(item_name, "rare", "redfall_key", "consumable", false, "Consumable", item_name .. "_desc")
        RPCItems:GiveItemToHeroWithSlotCheck(hero, key)
    elseif reward.type == ROSHPIT_QUEST_REWARD_TYPE_BUFF then
        Timers:CreateTimer(0, function()
            if hero:IsAlive() then
                if reward.amount and reward.amount > 0 then
                    Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, hero, reward.name, {duration = reward.amount})
                else
                    Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, hero, reward.name, {})
                end
            else
                return 1
            end
        end)
    elseif reward.type == ROSHPIT_QUEST_REWARD_TYPE_IMMORTAL then
        --120 * 5 / 6 = 100
        local item_level = math.min(RPCItems:RollItemLevelFromUnit(hero:GetLevel() * 5 / 6), GameState:GetDifficultyFactor() * 40)
        local item = RPCItems:RollImmortalByName(reward.name, item_level)
        if IsValidEntity(item:GetContainer()) then
            UTIL_Remove(item:GetContainer())
        end
        item.pickedUp = true
        item.expiryTime = false
        RPCItems:GiveItemToHeroWithSlotCheck(hero, item)
    elseif reward.type == ROSHPIT_QUEST_REWARD_TYPE_MITHRIL then
        local crystal = CreateUnitByName("arcane_crystal", reward.position + Vector(0, 0, 1000), false, nil, nil, DOTA_TEAM_GOODGUYS)
        crystal:SetAbsOrigin(crystal:GetAbsOrigin() + Vector(0, 0, 1300))
        local crystalAbility = crystal:AddAbility("mithril_shard_ability")
        crystalAbility:SetLevel(1)
        local fv = RandomVector(1)
        crystal:SetOriginalModel("models/props_gameplay/rune_doubledamage01.vmdl")
        crystal:SetModel("models/props_gameplay/rune_doubledamage01.vmdl")
        crystal.reward = reward.amount
        crystal.reward = math.floor(crystal.reward * (1 + GameState:GetPlayerPremiumStatusCount() * 0.1))
        crystal.distributed = 0
        local baseModelSize = math.min(2.9, 1.2 + crystal.reward / 200)
        crystal.modelScale = baseModelSize
        crystal:SetModelScale(baseModelSize)
        crystal.fallVelocity = 45
        crystal.falling = true
        crystal.winnerTable = RPCItems:GetConnectedPlayerTable()
        if #crystal.winnerTable > 0 then
            Timers:CreateTimer(1.4, function()
                EmitSoundOn("Resource.MithrilShardEnter", crystal)
            end)
        end
	elseif reward.type == ROSHPIT_QUEST_REWARD_TYPE_ARCANE_CRYSTALS then
	elseif reward.type == ROSHPIT_QUEST_REWARD_TYPE_PRISMATIC_GEMSTONES then
    end
    Quests:UpdateQuests()
end

function base_quest:GetObjectives()
    return {}
end

function base_quest:GetStatus()
    return self.data.status
end

function base_quest:GetInternalQuestData()
    local objectives = self:GetObjectives()
    local objectivesData = {}
    for i = 1, #objectives, 1 do 
        table.insert(objectivesData, objectives[i]:GetInternalQuestObjectiveData())
    end
    local questData = {
        questname = self:GetQuestName(),
        rewards = self.data.rewards,
        objectives = objectivesData
    }
    print("Quest Data: ")
    DeepPrintTable(questData)
    return questData
end