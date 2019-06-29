if Attacks == nil then
	Attacks = class({})
end

function Attacks:FilterProjectile(filterTable)
	local attacker_index = filterTable["entindex_source_const"]
	local victim_index = filterTable["entindex_target_const"]

	if not victim_index or not attacker_index then
		return true
	end
	local victim = EntIndexToHScript(victim_index)
	local attacker = EntIndexToHScript(attacker_index)

end
