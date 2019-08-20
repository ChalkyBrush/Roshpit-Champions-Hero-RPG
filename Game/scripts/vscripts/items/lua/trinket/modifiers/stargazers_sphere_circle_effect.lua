require('/npc_abilities/base_modifier')
modifier_stargazers_sphere_circle_effect = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_stargazers_sphere_circle_effect
function modifierClass:OnAfterPreMitigationReduce(data)
    if self:GetParent() ~= data.victim then
        return
    end
    if data.source ~= self:GetAbility() and not data.isAugmented then
        self.damage = self.damage or 0
        self.damage = math.max(data.damage, self.damage)
    end
end
function modifierClass:OnCreated()
    self.damage = 0
    self:SetSpecialTypes({
        MODIFIER_SPECIAL_TYPE_PREMITIGATION,
    })
    self:StartIntervalThink(STARGAZERS_SPHERE_STARFALL_CD)
end
function modifierClass:PlayEffectsStarfall()
    local target = self:GetParent()
    local particleName = "particles/units/heroes/hero_mirana/mirana_starfall_attack.vpcf"
    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
    EmitSoundOn("RPCItems.Stargazer.Starfall", target)
    ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    Timers:CreateTimer(0.6, function()
        ParticleManager:DestroyParticle(pfx, false)
    end)
end
function modifierClass:OnIntervalThink()
    if self.damage == 0 then
        return
    end
    self:PlayEffectsStarfall()
    Timers:CreateTimer(0.45, function()
        Damage:Apply({
            attacker = self:GetCaster(),
            victim = self:GetParent(),
            damage = self.damage * STARGAZERS_SPHERE_STARFALL_DMG_AMP,
            damageType = DAMAGE_TYPE_PURE,
            maxPremitigationDamage = self.damage * STARGAZERS_SPHERE_MAX_PREMIT_DAMAGE_AMP,
            source = self:GetAbility(),
            sourceType = BASE_ITEM,
            elements = { RPC_ELEMENT_COSMOS },
            skipItemDamageEffectsApply = true,
            ignorePostmitigation = true,
            ignoreExtraPostmitigation = true,
            steadfastThresholdMult = STARGAZERS_SPHERE_STEADFAST_THRESHOLD,
            megaSteadfastThresholdMult = STARGAZERS_SPHERE_MEGASTEADFAST_THRESHOLD,
        })
    end)
end