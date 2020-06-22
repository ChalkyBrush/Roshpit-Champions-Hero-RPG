require('heroes/vengeful_spirit/solunia_constants')
require('heroes/vengeful_spirit/ability_scripts/warp_flare/warp_flare_base')
solunia_warp_flare_solar = class(warp_flare_base)

function solunia_warp_flare_solar:OnSpellStartBase()
    self:WarpFlareStart()
end