function raging_shaman_think(event)
	local caster = event.caster
	local ability = event.ability
	local maxHealth = caster:GetMaxHealth()
	local currentHealth = caster:GetHealth()
	if currentHealth < maxHealth*0.1 then
		caster:SetModelScale(2.0)
		caster:SetModifierStackCount( "modifier_raging_shaman_passive", ability, 10 )
	elseif currentHealth < maxHealth*0.2 then
		caster:SetModelScale(1.9)
		caster:SetModifierStackCount( "modifier_raging_shaman_passive", ability, 9 )
	elseif currentHealth < maxHealth*0.3 then
		caster:SetModelScale(1.75)
		caster:SetModifierStackCount( "modifier_raging_shaman_passive", ability, 8 )
	elseif currentHealth < maxHealth*0.4 then
		caster:SetModelScale(1.6)
		caster:SetModifierStackCount( "modifier_raging_shaman_passive", ability, 7 )
	elseif currentHealth < maxHealth*0.5 then
		caster:SetModelScale(1.45)
		caster:SetModifierStackCount( "modifier_raging_shaman_passive", ability, 6 )
	elseif currentHealth < maxHealth*0.6 then
		caster:SetModelScale(1.3)
		caster:SetModifierStackCount( "modifier_raging_shaman_passive", ability, 5 )
	elseif currentHealth < maxHealth*0.7 then
		caster:SetModelScale(1.15)
		caster:SetModifierStackCount( "modifier_raging_shaman_passive", ability, 4 )
	elseif currentHealth < maxHealth*0.8 then
		caster:SetModelScale(1.0)
		caster:SetModifierStackCount( "modifier_raging_shaman_passive", ability, 3 )
	elseif currentHealth < maxHealth*0.9 then
		caster:SetModelScale(0.85)
		caster:SetModifierStackCount( "modifier_raging_shaman_passive", ability, 2 )
	end
end