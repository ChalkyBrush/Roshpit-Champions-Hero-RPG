local function cast(caster, ability)
  local runesCount = caster.e_3_level
  if runesCount > 0 then
    local duration = Filters:GetAdjustedBuffDuration(caster, runesCount * ASTRAL_RANGER_E3_ADD_DURATION + ASTRAL_RANGER_E3_START_DURATION, false)
    if caster:HasModifier("modifier_astral_glyph_4_1") then
      duration = duration * (1 - ASTRAL_RANGER_GLYPH_4_1_DURATION_REDUCTION_PCT / 100)
    end
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_astral_c_c_visible", {duration = duration})
  end
end

function think(event)
  local target = event.target
  Filters:CleanseStuns(target)
  Filters:CleanseSilences(target)
end

local module = {}
module.cast = cast
return module
