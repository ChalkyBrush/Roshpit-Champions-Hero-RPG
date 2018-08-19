modifier_apollo_outgoing_shots = class({})

LinkLuaModifier("modifier_apollo_c_b_proc_visible", "modifiers/astral/modifier_apollo_c_b_proc_visible", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_apollo_c_b_proc_invisible", "modifiers/astral/modifier_apollo_c_b_proc_invisible", LUA_MODIFIER_MOTION_NONE)

function modifier_apollo_outgoing_shots:DeclareFunctions()
	local funcs = { MODIFIER_EVENT_ON_ATTACK_LANDED,

}
	return funcs
end

function modifier_apollo_outgoing_shots:OnAttackLanded()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local target = ability.target
	local attacker = self:GetParent()
	if attacker == caster then
		if target and (not target:IsNull()) then
			if target:IsAlive() then
				local newStacks = caster:GetModifierStackCount("modifier_apollo_outgoing_shots", caster) - 1
				caster:SetModifierStackCount("modifier_apollo_outgoing_shots", caster, newStacks)
				if newStacks == 0 then
					caster:RemoveModifierByName("modifier_apollo_outgoing_shots")
				end
				ability.shots = ability.shots - 1
				if ability.w_3_level > 0 then
					local empyralArrowsProcChance
				    if caster:HasModifier("modifier_astral_glyph_3_1") then
				        empyralArrowsProcChance = getProcChance(caster, T31_PROC_CHANCE)
				    else
				        empyralArrowsProcChance = getProcChance(caster, W3_PROC_CHANCE)
				    end
				    local procChance = math.ceil(getProcChance(caster, empyralArrowsProcChance))
				    local luck = RandomInt(1, 100)
				    if luck <= procChance then
						CustomAbilities:QuickAttachParticle("particles/roshpit/astral/apollo_proc_start_ti7_lvl2.vpcf", target, 1)
						local damage = caster:GetAverageTrueAttackDamage(caster)*0.12*ability.w_3_level
						Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_COSMOS, RPC_ELEMENT_NONE)
						target:AddNewModifier(caster, ability, "modifier_apollo_c_b_proc_visible", {duration = 10})
						local newStacks = target:GetModifierStackCount("modifier_apollo_c_b_proc_visible", caster) + 1
						target:SetModifierStackCount("modifier_apollo_c_b_proc_visible", caster, newStacks)
						target:AddNewModifier(caster, ability, "modifier_apollo_c_b_proc_invisible", {duration = 10})
						target:SetModifierStackCount("modifier_apollo_c_b_proc_invisible", caster, newStacks*ability.w_3_level)
						EmitSoundOn("Astral.ApolloProc", target)
				    end
				end
			end
		else
			ability.active = true
		end
	end
end