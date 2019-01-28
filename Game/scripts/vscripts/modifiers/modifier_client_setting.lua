modifier_client_setting = class({})

local function settings()
	SendToConsole("dota_hud_healthbars 1")-- too much health causes lags
	SendToConsole("dota_hud_disable_damage_numbers true")-- isnt affected by damage filter, and thus useless
end

function modifier_client_setting:OnCreated()
	if IsClient() then
		settings()
	end
end

function modifier_client_setting:OnRefresh()
	if IsClient() then
		settings()
	end
end

function modifier_client_setting:IsHidden()
	return true
end