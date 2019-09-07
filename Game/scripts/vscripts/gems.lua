if Gems == nil then
	Gems = class({})
end

function Gems:RandomlySetSocketsForItem(item)
end

function Gems:AddSocket(item)
	if not item.newItemTable.socket1 then
		item.newItemTable.socket1 = "open"
		item.newItemTable.socket1value = 0
		RPCItems:ItemUpdateCustomNetTables(item)
		return true
	elseif not item.newItemTable.socket2 then
		item.newItemTable.socket2 = "open"
		item.newItemTable.socket2value = 0
		RPCItems:ItemUpdateCustomNetTables(item)
		return true
	end
end

function Gems:SetSocket(item, socket_number, gem, value)
	if socket_number == 1 then
		item.newItemTable.socket1 = gem
		item.newItemTable.socket1value = value
		RPCItems:ItemUpdateCustomNetTables(item)
	elseif socket_number == 2 then
		item.newItemTable.socket2 = gem
		item.newItemTable.socket2value = value
		RPCItems:ItemUpdateCustomNetTables(item)
	end
end

function Gems:SpawnGemForger(position, endFV)
	-- if not Gems.GemForgerSpawned then
	 	if Gems.GemForger then
	 		UTIL_Remove(Gems.GemForger)
	 	end
		Gems.GemForgerSpawned = true
		Gems.GemForger = CreateUnitByName("gem_forger", position, true, nil, nil, DOTA_TEAM_GOODGUYS)
		Gems.GemForger:SetAbsOrigin(Gems.GemForger:GetAbsOrigin()+Vector(0,0,1000))
		Gems.GemForger.endFV = endFV
		local startFV = WallPhysics:rotateVector(endFV, 2*math.pi*1/4)
		Gems.GemForger:SetForwardVector(startFV)
		local gem_ability = Gems.GemForger:FindAbilityByName("gem_forger_ability")
		gem_ability:ApplyDataDrivenModifier(Gems.GemForger, Gems.GemForger, "modifier_gem_forger_entering", {})
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_stormspirit/stormspirit_static_remnant.vpcf", Gems.GemForger, 0.03)

		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_electric_vortex.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, Gems.GemForger:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Gems.GemForger:GetAbsOrigin())
		Gems.GemForger.entering_pfx = pfx
		StartAnimation(Gems.GemForger, {duration = 3, activity = ACT_DOTA_OVERRIDE_ABILITY_4, rate = 1})
		EmitSoundOn("NPC.Gemforger.Enter.Start", Gems.GemForger)
	-- end
end