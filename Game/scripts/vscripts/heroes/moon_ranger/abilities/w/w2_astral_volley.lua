require('heroes/moon_ranger/init')
local function getVolleysCount(caster)
	local runesCount = caster.w_2_level
	local procChance = getProcChance(caster, W2_MULTIPLY_CHANCE)
	return Runes:Procs(runesCount, procChance, 1)
end
local module = {}
module.getVolleysCount = getVolleysCount
return module
