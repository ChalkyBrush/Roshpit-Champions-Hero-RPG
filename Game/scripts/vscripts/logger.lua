if Logger == nil then
	Logger = {}
end

-- there's no table.unpack
local function unpack(t, i)
	i = i or 1
	if t[i] ~= nil then
		return t[i], unpack(t, i+1)
	end
end


function Logger:Watch(func, ...)
	local result = {pcall(func, ...)}
	if result[1] then
		table.remove(result, 1)
		return unpack(result)
	else
		CustomGameEventManager:Send_ServerToAllClients("error_logger_line", {text = result[2]})
		error("Caught an error")
	end
end