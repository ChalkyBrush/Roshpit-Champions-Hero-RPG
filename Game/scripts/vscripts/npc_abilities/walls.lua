function wall_zero(event)
	local target = event.target
	local origin = target:GetAbsOrigin()
	target:SetAbsOrigin(origin+target.pushVector)
end