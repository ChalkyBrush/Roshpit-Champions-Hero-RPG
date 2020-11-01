if RequestHelper == nil then
	RequestHelper = class({})
end


DEFAULT_REQUEST_TIME_OUT = 5


-- require("libraries/json")
require("libraries/json_new")


-- usage:
-- local data = {}
-- local url = "api address"
-- local json = require("libraries/json_new")
-- RequestHelper:SendJsonHTTPRequest("POST", url, data, function(response, statusCode, body)
-- 	print("3  "..tostring(response))
-- 	print("1  "..tostring(statusCode))
-- 	print("2  "..tostring(body))
-- end, 5, true)


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


-- example
-- local url = "https://roshpit.herokuapp.com/champions/loadCharacter?steam_id=157571937&slot=5"
-- RequestHelper:RequestAndTwoPcallOnResponse("GET", url, nil, function(response, statusCode, body)
-- 	print("3  "..tostring(response))
-- 	print("1  "..tostring(statusCode))
-- 	print("2  "..tostring(body))
-- 	print("")
-- 	print("firstCallBack")
-- 	-- firstCallBack()
-- end, function()
-- 	print("")
-- 	print("secondCallBack")
-- 	-- secondCallBack()
-- end)	

function RequestHelper:RequestAndTwoPcallOnResponse(requestMethod, requestUrl, requestTimeout, callbackFunction1, callbackFunction2)
	if not requestTimeout then requestTimeout = DEFAULT_REQUEST_TIME_OUT end
	local request = CreateHTTPRequestScriptVM(requestMethod, requestUrl)
	request:SetHTTPRequestAbsoluteTimeoutMS(requestTimeout * 1000)

	request:Send(function(response)
		if response and response.StatusCode and response.Body then
			local pcallResult1, err1 = pcall(function ()
				callbackFunction1(response, response.StatusCode, response.Body)
			end)
			-- print("Callback1 result: "..tostring(pcallResult1).." exception?: "..tostring(err1))

			local pcallResult2, err2 = pcall(function ()
				callbackFunction2()
			end)
			-- print("Callback2 result: "..tostring(pcallResult2).." exception?: "..tostring(err2))
		end
	end)
end


