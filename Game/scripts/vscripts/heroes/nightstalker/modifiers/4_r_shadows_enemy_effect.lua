require('/npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')
require('heroes/nightstalker/modifiers/shadows_enemy_effect')
modifier_chernobog_4_r_shadows_enemy_effect = class(modifier_chernobog_shadows_enemy_effect, nil, modifier_chernobog_shadows_enemy_effect)

local class = modifier_chernobog_4_r_shadows_enemy_effect

function class:CanAttack()
    return true
end