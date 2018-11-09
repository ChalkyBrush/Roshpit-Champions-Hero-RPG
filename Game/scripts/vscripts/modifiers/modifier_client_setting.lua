modifier_client_setting = class({})

function modifier_client_setting:OnCreated()
	if IsClient() then
		SendToConsole("dota_hud_healthbars 1")
	end
end

function modifier_client_setting:IsHidden()
	return true
end