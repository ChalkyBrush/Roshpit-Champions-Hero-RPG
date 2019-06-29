function beginChannel(event)
	local caster = event.caster
	Filters:BeginRChannel(caster)
end

function endChannel(event)
	local caster = event.caster
	Filters:EndRChannel(caster)
end
