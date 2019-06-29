function ApplyAura(event)
	-- Variables
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability

	if target.GetInvulnCount == nil and not target:IsMechanical() then
		ability:ApplyDataDrivenModifier(attacker, attacker, "modifier_champion_movespeed", {duration = 0.03})
	end
end
