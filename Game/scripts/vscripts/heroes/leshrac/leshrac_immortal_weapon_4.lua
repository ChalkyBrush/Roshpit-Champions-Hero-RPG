require('heroes/leshrac/leshrac_runes')
require("heroes/leshrac/bahamut_constants")

function modifier_bahamut_immortal_weapon_4_think(event)
	local caster = event.caster
	local ability = event.ability
	local hero = caster.hero
	local slot_table = {RPC_GEAR_SLOT_HEAD, RPC_GEAR_SLOT_GLOVES, RPC_GEAR_SLOT_BOOTS, RPC_GEAR_SLOT_BODY, RPC_GEAR_SLOT_TRINKET}
	local empty_slots = 0
	for i = 1, #slot_table, 1 do
		if hero.equipped_gear[slot_table[i]] == nil then
			empty_slots = empty_slots + 1
			ability:ApplyDataDrivenModifier(hero, hero, "modifier_bahamut_immortal_weapon_4_nascent_power_stack", {9999})
		end
	end
	--print(empty_slots)
	hero:SetModifierStackCount("modifier_bahamut_immortal_weapon_4_nascent_power_stack", hero, empty_slots)
	--print(hero:GetModifierStackCount("modifier_bahamut_immortal_weapon_4_nascent_power_stack", hero))
end

function modifier_bahamut_immortal_weapon_4_remove_stacks(event)
	local caster = event.caster
	local ability = event.ability
	local hero = caster.hero
	hero:SetModifierStackCount("modifier_bahamut_immortal_weapon_4_nascent_power_stack", hero, 0)
	Timers:CreateTimer(1, function()
		hero:RemoveModifierByName("modifier_bahamut_immortal_weapon_4_nascent_power_stack")
	end)
end