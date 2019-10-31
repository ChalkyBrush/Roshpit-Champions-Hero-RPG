require('/npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')
modifier_3_e_teleportation_buff = class(npc_base_modifier, nil, npc_base_modifier)
local class = modifier_3_e_teleportation_buff

function class:GetTexture()
    return 'chernobog/chernobog_rune_e_3'
end