local function applyBuff(caster)
    local runesCount = Runes:GetTotalRuneLevelGeneric(caster, 1, 3)
    if runesCount > 0 then
        Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, caster, "modifier_general_postmitigation", {duration = 4})
        local amp = ARCANA1_R1_AMPLIFY_PERCENT * runesCount
        caster:SetModifierStackCount("modifier_general_postmitigation", Events.GameMaster, amp)
    end
end
local function removeBuff(caster)
    caster:RemoveModifierByName("modifier_general_postmitigation")
end


local module = {}
module.applyBuff = applyBuff
module.removeBuff = removeBuff
return module