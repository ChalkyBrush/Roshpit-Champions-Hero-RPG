Helpers.Hero = class({})
function Helpers.Hero:GetAttributes(attacker)
	return attacker:GetStrength() + attacker:GetAgility() + attacker:GetIntellect();
end
