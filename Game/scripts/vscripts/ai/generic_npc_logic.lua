function creature_acid_spray_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local thinkerDuration = 6.5
	if not caster then
		return
	end
	if not ability then
		return
	end
	CustomAbilities:QuickAttachThinker(ability, caster, caster:GetAbsOrigin(), "creature_acid_spray_thinker", {duration = thinkerDuration})
end

function modifier_henchman_ground_fire_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local thinkerDuration = 8
	if not caster then
		return
	end
	if not ability then
		return
	end
	CustomAbilities:QuickAttachThinker(ability, caster, caster:GetAbsOrigin(), "modifier_henchman_ground_fire", {duration = thinkerDuration})
end

function modifier_shadow_cloud_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local thinkerDuration = 8
	if not caster then
		return
	end
	if not ability then
		return
	end
	CustomAbilities:QuickAttachThinker(ability, caster, caster:GetAbsOrigin(), "modifier_shadow_cloud_thinker", {duration = thinkerDuration})
end
