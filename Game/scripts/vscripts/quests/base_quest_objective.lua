base_quest_objective = class({})

base_quest_objective.data = {}
base_quest_objective.data.currentCount = 0

function base_quest_objective:GetObjectiveTarget()
    return ""
end

function base_quest_objective:GetObjectiveCurrentCount()
    return self.data.currentCount
end

function base_quest_objective:GetObjectiveTargetCount()
    return 1
end

function base_quest_objective:IncrementObjective()
    if self:GetObjectiveCurrentCount() < self:GetObjectiveTargetCount() then
        self.data.currentCount = self.data.currentCount + 1
        if self:GetObjectiveCurrentCount() == self:GetObjectiveTargetCount() then
            self:OnObjectiveCompleted()
        end
        Quests:UpdateQuests()
    end
end

function base_quest_objective:GetObjectivePingLocations()
    --Table of Vectors to be pinged (max of 10)
    return {}
end

function base_quest_objective:OnObjectiveCompleted()
    return
end

function base_quest_objective:GetInternalQuestObjectiveData()
    self.data.target = self:GetObjectiveTarget()
    self.data.count = self:GetObjectiveTargetCount()
    self.data.ping = #self:GetObjectivePingLocations() > 0
    return self.data
end