require('/npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')
require('/wallPhysics')
modifier_chernobog_1_q_path_ally_flying_effect = class(npc_base_modifier, nil, npc_base_modifier)
local class = modifier_chernobog_1_q_path_ally_flying_effect


function class:CheckState()
    return {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
    }
end
function class:OnCreated()
    if not IsServer() then
        return
    end
    self.previousPosition = self:GetParent():GetAbsOrigin()
    self:StartIntervalThink(0.03)
end
function class:OnIntervalThink()
    local parent = self:GetParent()
    local currentPosition = parent:GetAbsOrigin()

    local afterWallPosition = WallPhysics:WallSearch(self.previousPosition, currentPosition, parent)
    if afterWallPosition ~= currentPosition then
        parent:RemoveModifierByName(self:GetName())
    else
        self.previousPosition = currentPosition
    end
end