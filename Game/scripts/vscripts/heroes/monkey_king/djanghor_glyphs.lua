function cleanse(event)
	local caster = event.target
	local procs = 1
	local particle = false
	print("CLEANSE")
	local modifiers = caster:FindAllModifiers()
	for j = 1, #modifiers, 1 do
		local modifier = modifiers[j]
		local modifierMaker = modifier:GetCaster()
		if not WallPhysics:DoesTableHaveValue(Filters:GetUnpurgableDebuffNames(), modifier:GetName()) then
			if modifierMaker.regularEnemy then
				caster:RemoveModifierByName(modifier:GetName())
				particle = true
				break
			end
		end
	end				

	if particle then
		EmitSoundOn("Draghor.Cleanse", caster)
		local pfx = CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_morphling/morphling_morph_agi.vpcf", caster, 1.2)
	end
end