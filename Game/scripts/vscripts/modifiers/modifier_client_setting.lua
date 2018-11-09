modifier_client_setting = class({})

function modifier_client_setting:OnCreated()
	self:StartIntervalThink(2)
end

function modifier_client_setting:OnIntervalThink()
	if IsClient() then
		SendToConsole("dota_hud_healthbars 1")
	end
end

function modifier_client_setting:IsHidden()
	return true
end