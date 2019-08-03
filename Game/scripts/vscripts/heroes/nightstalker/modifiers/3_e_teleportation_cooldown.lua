require('/npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')
modifier_chernobog_3_e_teleportation_cooldown = class(npc_base_modifier, nil, npc_base_modifier)
local class = modifier_chernobog_3_e_teleportation_cooldown


function class:IsDebuff()
    return true
end