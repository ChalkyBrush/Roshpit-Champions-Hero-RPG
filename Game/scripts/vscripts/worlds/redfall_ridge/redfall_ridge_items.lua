function BurgundyFireflyOnSpellStart(event)
	local caster = event.caster
	local ability = event.ability
	local casterOrigin = caster:GetAbsOrigin()
	local distance = WallPhysics:GetDistance(casterOrigin * Vector(1, 1, 0), Vector(-15352, -8303))

	if distance < 130 then
		if not Redfall.AutumnMistCanyon then
			Dungeons.respawnPoint = Vector(-15352, -8303)
			UTIL_Remove(ability)
			local particlePosition = Vector(-15352, -8303, Redfall.ZFLOAT + 250)
			local pfx = ParticleManager:CreateParticle("particles/roshpit/redfall_indicator_allied_wind.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
			ParticleManager:SetParticleControl(pfx, 10, particlePosition)
			ParticleManager:SetParticleControl(pfx, 0, particlePosition)
			ParticleManager:SetParticleControl(pfx, 1, particlePosition)
			ParticleManager:SetParticleControl(pfx, 2, particlePosition)
			ParticleManager:SetParticleControl(pfx, 3, particlePosition)
			EmitGlobalSound("Redfall.TreeHealedMain")
			Redfall:InitializeAutumnMistCanyon()
		else
			EmitSoundOnClient("General.Cancel", caster:GetPlayerOwner())
		end
	else
		MinimapEvent(caster:GetTeamNumber(), caster, -15352, -8303, DOTA_MINIMAP_EVENT_BASE_UNDER_ATTACK, 4)
		EmitSoundOnClient("General.Cancel", caster:GetPlayerOwner())
	end
end

function GlowingRedfallLeafOnSpellStart(event)
	local caster = event.caster
	local ability = event.ability
	local shrinePosition = Vector(-11535, 5266)
	local distance = WallPhysics:GetDistance(caster:GetAbsOrigin() * Vector(1, 1, 0), shrinePosition)
	if distance <= 150 then
        Quests:IncrementQuestObjective("seeking_ashara_objective1")
		UTIL_Remove(ability)
		local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
		local radius = 350
		local particle2 = ParticleManager:CreateParticle(particleNameS, PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(particle2, 0, GetGroundPosition(shrinePosition, caster))
		ParticleManager:SetParticleControl(particle2, 1, Vector(radius, radius, radius))
		ParticleManager:SetParticleControl(particle2, 2, Vector(2.0, 2.0, 2.0))
		ParticleManager:SetParticleControl(particle2, 4, Vector(255, 40, 0))
		Timers:CreateTimer(1.5, function()
			ParticleManager:DestroyParticle(particle2, false)
		end)
		EmitSoundOnLocationWithCaster(shrinePosition, "Redfall.ActivateAsharaPortal", Redfall.RedfallMaster)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), shrinePosition, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for i = 1, #enemies, 1 do
				enemies[i]:AddNewModifier(victim, Events:GetGameMasterAbility(), "modifier_stunned", {duration = 1})
				Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, enemies[i], "modifier_redfall_pushback", {duration = 0.8})
			end
		end
		AddFOWViewer(DOTA_TEAM_GOODGUYS, shrinePosition, 200, 300, true)
		Timers:CreateTimer(1.0, function()
			Redfall.AsharaPortalActive = true
			EmitGlobalSound("ui.set_applied")
			Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(-11535, 5266, 190 + Redfall.ZFLOAT), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
		end)
		Quests:IncrementQuestObjective("quests_seeking_ashara_objective1")
		Redfall:SpawnSpiritOfAshara(Vector(-10944, 14336), Vector(0, 1))
	end
end

function AshenTwigOnSpellStart(event)
	local caster = event.caster
	local ability = event.ability
	local shrinePosition = Vector(-1856, -10240)
	local distance = WallPhysics:GetDistance(caster:GetAbsOrigin() * Vector(1, 1, 0), shrinePosition)
	if distance <= 560 then
		UTIL_Remove(ability)
        EmitSoundOn("Redfall.UseTwig", caster)
        Quests:IncrementQuestObjective("autumn_ash_objective1")
		local particle = "particles/roshpit/redfall/tree_healed.vpcf"
		local pfxA = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, caster)

		ParticleManager:SetParticleControl(pfxA, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfxA, 1, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfxA, 2, Vector(0, 1))
		Timers:CreateTimer(7.5, function()
			ParticleManager:DestroyParticle(pfxA, false)
		end)
		Timers:CreateTimer(2, function()
			EmitSoundOnLocationWithCaster(shrinePosition, "Redfall.AshTreeShake", Redfall.RedfallMaster)
			local treeStatuePieces = Entities:FindAllByNameWithin("AshTreeStatue", Vector(-1451, -10240, 105 + Redfall.ZFLOAT), 2000)
			for i = 1, 60, 1 do
				Timers:CreateTimer(0.05 * i, function()
					local movement = Vector(15, 15, 0)
					if i % 2 == 0 then
						movement = Vector(-15, -15, 0)
						ScreenShake(treeStatuePieces[1]:GetAbsOrigin(), 130, 0.9, 0.9, 9000, 0, true)
					end
					for j = 1, #treeStatuePieces, 1 do
						treeStatuePieces[j]:SetAbsOrigin(treeStatuePieces[j]:GetAbsOrigin() + movement)
						treeStatuePieces[j]:SetRenderColor(113 + (i * 2), 60, 60)
					end

				end)
			end
			Timers:CreateTimer(3.1, function()
				for j = 1, #treeStatuePieces, 1 do
					UTIL_Remove(treeStatuePieces[j])
				end
				local tree = Redfall:SpawnAshTreant(Vector(-1451, -10240, 109), Vector(-1, 0))
				CustomAbilities:QuickAttachParticle("particles/roshpit/redfall/boss_death_ntimage_manavoid_ti_5.vpcf", tree, 3)
				CustomAbilities:QuickAttachParticle("particles/world_destruction_fx/dire_tree004b_destruction.vpcf", tree, 4)
				Timers:CreateTimer(0.2, function()
					EmitSoundOn("Redfall.AutumnSpawner.Death", tree)
				end)
			end)
		end)
	end
end