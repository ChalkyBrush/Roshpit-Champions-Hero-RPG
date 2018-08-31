local function cast(caster, ability)
  	local runesCount = caster.e_3_level
  	if runesCount > 0 then
    	local duration = Filters:GetAdjustedBuffDuration(caster, runesCount * E3_ADD_DURATION + E3_START_DURATION, false)
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