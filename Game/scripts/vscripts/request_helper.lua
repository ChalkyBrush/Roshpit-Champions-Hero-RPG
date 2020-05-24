if RequestHelper == nil then
	RequestHelper = class({})
end


DEFAULT_REQUEST_TIME_OUT = 5


-- require("libraries/json")
require("libraries/json_new")


function RequestHelper:SendJsonHTTPRequest(requestMethod, requestUrl, tableData, callbackFunction, requestTimeout, debugPrint)
	if tableData == nil then tableData = {} end
	if debugPrint then
		print("+++++++++++++++++++++++++++++++++++++++++++++++")
		print("+ ".."requestMethod:"..tostring(requestMethod))
		print("+ ".."requestUrl:"..tostring(requestUrl))
		print("+ ".."tableData, length:"..tostring(#tableData).." "..tostring(tableData))
		for k, v in pairs(tableData) do
			print("+ key:\""..tostring(k).."\" value:\""..tostring(v).."\"")
		end
		print("+ ".."requestTimeout:"..tostring(requestTimeout))
		print("+ ".."debugPrint:"..tostring(debugPrint))
		print("+++++++++++++++++++++++++++++++++++++++++++++++")
	end

	local request = CreateHTTPRequestScriptVM(requestMethod, requestUrl)

	request:SetHTTPRequestHeaderValue("Content-Type", "application/json;charset=uft-8")

	local jsonString = json.encode(tableData)

	request:SetHTTPRequestRawPostBody("application/json", jsonString)

	request:SetHTTPRequestAbsoluteTimeoutMS((requestTimeout or DEFAULT_REQUEST_TIME_OUT) * 1000)

	request:Send(function(response)
		if response and response.StatusCode and response.Body then
			callbackFunction(response, response.StatusCode, response.Body)
		end
	end)
end




