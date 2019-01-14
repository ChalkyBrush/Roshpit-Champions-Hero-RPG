function jex_nature_cosmic_toggled_on(event)
	local caster = event.caster
	local ability = event.ability
	ability.tech_level = caster.onibi.stats_table["nature"]["cosmic"]["W"]["level"]
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_jex_nature_cosmic_movespeed", {})
	caster:SetModifierStackCount("modifier_jex_nature_cosmic_movespeed", caster, ability.tech_level)
	EmitSoundOn("Jex.Equilibrium.Activate", caster)
	StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_OVERRIDE_ABILITY_4, rate=1.5})
end

function jex_nature_cosmic_toggled_off(event)
	local caster = event.caster
	local ability = event.ability
	caster:RemoveModifierByName("modifier_jex_nature_cosmic_movespeed")
end

function nature_cosmic_w_think(event)
	local caster = event.caster
    local ability = event.ability
    local mana_usage = event.mana_drain_per_second
    if mana_usage > caster:GetMana() then
        ability:ToggleAbility()
    end
    caster:ReduceMana(mana_usage)
end