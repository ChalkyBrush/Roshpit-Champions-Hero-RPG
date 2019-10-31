require('/npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')
modifier_chernobog_3_e_teleportation_enemy_effect_e3 = class(npc_base_modifier, nil, npc_base_modifier)
local class = modifier_chernobog_3_e_teleportation_enemy_effect_e3

function class:OnCreated()
    if IsServer() then
    	self:GetParent():CalculateAndSaveRoshpitAttributes()
    end
end

function class:OnDestroy()
	if IsServer() then
		self:GetParent():CalculateAndSaveRoshpitAttributes()
	end
end

function class:IsDebuff()
    return true
end

function class:GetTexture()
    return 'chernobog/chernobog_rune_q_1'
end