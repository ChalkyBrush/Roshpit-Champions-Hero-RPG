function shredder_disabled_attacked(event)
	local caster = event.caster
	local ability = event.ability
	if not caster.attacks then
		caster.attacks = 0
	end
	caster.attacks = caster.attacks + 1
	caster:SetRenderColor(caster.attacks*20, caster.attacks*20, caster.attacks*20)
	Redfall:ColorWearables(caster, Vector(caster.attacks*20, caster.attacks*20, caster.attacks*20))
	EmitSoundOn("Redfall.FriendlyShredder.Attacked", caster)
	if caster.attacks == 12 then
		caster.aiState = 0
		caster:RemoveModifierByName("modifier_friendly_shredder_disabled")
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_friendly_shredder_awake", {})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_friendly_shredder_lightning_effect", {duration = 2})
		
		CustomAbilities:QuickAttachParticle("particles/econ/items/shredder/timber_controlled_burn/timber_controlled_burn_tree_kill.vpcf", caster, 5)
		EmitSoundOn("Redfall.FriendlyShredder.Activate", caster)
		Timers:CreateTimer(0.06, function()
			StartAnimation(caster, {duration=1.5, activity=ACT_DOTA_SPAWN, rate=1.0})
		end)
		Timers:CreateTimer(2, function()
			EmitSoundOn("Redfall.FriendlyShredder.ActivateVO", caster)
			caster:SetHealth(caster:GetMaxHealth())
		end)
		Timers:CreateTimer(4, function()
			caster.aiState = 1
			for i = 1, #MAIN_HERO_TABLE, 1 do
				MAIN_HERO_TABLE[i].RedfallQuests[8].state = 0
				Redfall:NewQuest(MAIN_HERO_TABLE[i], 8)
			end   
		end)
	end
end

function shredder_awake_think(event)
	local caster = event.caster
	if caster.aiState == 1 then
		caster:MoveToPosition(Vector(5696, -5888))
		local distance = WallPhysics:GetDistance2d(Vector(5696, -5888), caster:GetAbsOrigin())
		if distance < 120 then
			caster.aiState = 2
			caster:MoveToPosition(caster:GetAbsOrigin()-Vector(0,30,0))

			Redfall.ShredderHandler:MoveToPosition(Vector(5568, -5952))
			Redfall.ShredderHandler.dialogueName = "farmer2_shredder"
		end
	elseif caster.aiState == 3 then
		caster:MoveToPosition(Vector(5525, -5608))
		local distance = WallPhysics:GetDistance2d(Vector(5525, -5608), caster:GetAbsOrigin())
		if distance < 50 then
			caster.aiState = 4
			caster:MoveToPosition(caster:GetAbsOrigin()+Vector(30,0,0))
			Redfall.ShredderSidequestActive = true
			Redfall.ShredderUpgradeTable = {true, false, false}
			local bladePFX = ParticleManager:CreateParticle("particles/roshpit/redfall/whirl_preview_tay.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
			ParticleManager:SetParticleControl(bladePFX, 0, Vector(5905, -5359, 58+Redfall.ZFLOAT))

			for i = 1, #MAIN_HERO_TABLE, 1 do
				MAIN_HERO_TABLE[i].RedfallQuests[8].objective = "redfall_quest_8_objective_2"
			end   
		end		
	end
end

function ShredderActiveTrigger(trigger)
	local hero = trigger.activator
	if Redfall.ShredderSidequestActive then
		if not hero:HasModifier("modifier_redfall_inside_shredder") and not hero.shredder then
			local shredder = CreateUnitByName("redfall_farmlands_friendly_harvester", hero:GetAbsOrigin(), false, hero, hero, hero:GetTeamNumber())
			Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, hero, "modifier_redfall_inside_shredder", {})
			hero:AddNoDraw()
			hero.shredder = shredder
			shredder.hero = hero
			local shredderAbility = shredder:FindAbilityByName("redfall_friendly_shredder_passive" )
			shredderAbility:ApplyDataDrivenModifier(shredder, shredder, "modifier_shredder_has_hero_inside", {})
		    shredder:SetOwner(hero)
		    shredder:SetControllableByPlayer(hero:GetPlayerID(), true)
		    FindClearSpaceForUnit(shredder, shredder:GetAbsOrigin(), false)
		end
	end
end

function hero_inside_shredder_think(event)
	local target = event.target
	local shredder = target.shredder
	target:SetAbsOrigin(shredder:GetAbsOrigin()+Vector(0,0,30))
end

function shredder_dismount(event)
	local caster = event.caster
	local shredderAbility = caster:FindAbilityByName("redfall_friendly_shredder_passive" )
	shredderAbility:ApplyDataDrivenModifier(caster, caster, "modifier_friendly_shredder_lightning_effect", {duration = 1.0})
	StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_FLAIL, rate=1.0})
	EmitSoundOn("Redfall.FriendlyShredder.Activate", caster)
	Timers:CreateTimer(1, function()
		EmitSoundOn("Redfall.FriendlyShredder.Destruct", caster)
		Timers:CreateTimer(0.1, function()
			local hero = caster.hero
			UTIL_Remove(caster)
			hero.shredder = nil
			hero:RemoveNoDraw()
			CustomAbilities:QuickAttachParticle("particles/econ/items/shredder/timber_controlled_burn/timber_controlled_burn_tree_kill.vpcf", hero, 5)
			hero:RemoveModifierByName("modifier_redfall_inside_shredder")
		end)
	end)
end

function shredder_with_hero_inside_thinking(event)
	local caster = event.caster
	if caster:GetHealth() < 500 then
		shredder_dismount(event)
	end
end

function ShredderUpgradeTrigger1(trigger)
	if Redfall.ShredderUpgradeTable[1] then
		Redfall:Dialogue(Redfall.ShredderHandler, nil, "redfall_dialogue_farmer_2_shredder_upgrade_1", 6, 5, -40, true)
		local hero = trigger.activator
		if hero:HasModifier("modifier_redfall_inside_shredder") then
			if hero.shredder:HasAbility("redfall_whirling_death_shredder_ability") then
			else
				local lumber = hero.shredder:GetModifierStackCount("modifier_shredder_lumber", hero.shredder)
				if lumber >= 100 then
					hero.shredder:AddAbility("redfall_whirling_death_shredder_ability"):SetLevel(1)
					hero.shredder:RemoveAbility("redfall_dismount_shredder_ability")
					hero.shredder:FindAbilityByName("redfall_whirling_death_shredder_ability"):SetAbilityIndex(0)
					Timers:CreateTimer(0.2, function()
						hero.shredder:AddAbility("redfall_dismount_shredder_ability"):SetLevel(1)
					end)

					hero.shredder:SetModifierStackCount("modifier_shredder_lumber", hero.shredder, lumber - 100)
					CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_loadout.vpcf", hero.shredder, 3)
					EmitSoundOn("Redfall.FriendlyShredder.Upgrade", hero.shredder)
					if not Redfall.ShredderUpgradeTable[2] then
						Redfall.ShredderUpgradeTable[2] = true
						local upgradeModel = Entities:FindByNameNearest("TurboBoost", Vector(6209, -5321, -254+Redfall.ZFLOAT), 600)
						upgradeModel:SetAbsOrigin(Vector(6209, -5321, -40+Redfall.ZFLOAT))
						hero.shredder:SetModifierStackCount("modifier_shredder_lumber", hero.shredder, lumber-100)
					end
				end
			end
		end
	end
end

function ShredderUpgradeTrigger2(trigger)
	if Redfall.ShredderUpgradeTable[2] then
		Redfall:Dialogue(Redfall.ShredderHandler, nil, "redfall_dialogue_farmer_2_shredder_upgrade_2", 6, 5, -40, true)
		local hero = trigger.activator
		if hero:HasModifier("modifier_redfall_inside_shredder") then
			if hero.shredder.upgraded then
			else
				local lumber = hero.shredder:GetModifierStackCount("modifier_shredder_lumber", hero.shredder)
				if lumber >= 100 then
					hero.shredder.upgraded = true
					hero.shredder:SetBaseMoveSpeed(550)
					CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_loadout.vpcf", hero.shredder, 3)
					EmitSoundOn("Redfall.FriendlyShredder.Upgrade", hero.shredder)
					if not Redfall.ShredderUpgradeTable[3] then
						Redfall.ShredderUpgradeTable[3] = true
						local upgradeModel = Entities:FindByNameNearest("HarvesterBoots", Vector(6522, -5325, -18+Redfall.ZFLOAT), 600)
						upgradeModel:SetAbsOrigin(Vector(6522, -5325, 140+Redfall.ZFLOAT))
						hero.shredder:SetModifierStackCount("modifier_shredder_lumber", hero.shredder, lumber-100)
					end
				end
			end
		end
	end
end

function ShredderUpgradeTrigger3(trigger)
	if Redfall.ShredderUpgradeTable[3] then
		Redfall:Dialogue(Redfall.ShredderHandler, nil, "redfall_dialogue_farmer_2_shredder_upgrade_3", 6, 5, -40, true)
		local hero = trigger.activator
		if hero:HasModifier("modifier_redfall_inside_shredder") then
			local lumber = hero.shredder:GetModifierStackCount("modifier_shredder_lumber", hero.shredder)
			if lumber >= 100 then
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_loadout.vpcf", hero.shredder, 3)
				EmitSoundOn("Redfall.FriendlyShredder.Upgrade", hero.shredder)
				--print("ROLL HARVESTER BOOTS")
				hero.RedfallQuests[8].active = 2
				hero.RedfallQuests[8].state = 1
				local item = RPCItems:RollHarvesterBoots(hero:GetAbsOrigin())
				item.pickedUp = true
				hero.shredder:SetModifierStackCount("modifier_shredder_lumber", hero.shredder, lumber-100)
			end
		end
	end
end

function shredder_used_ability(event)
	local caster = event.caster
	local executedAbility = event.event_ability
	if executedAbility:GetAbilityName() == "redfall_harvester_harvest" then

	end
end

function tree_harvest_cast(event)
	local caster = event.caster
	local ability = event.ability
	StartAnimation(caster, {duration=1, activity=ACT_DOTA_ATTACK, rate=1.0})
	Timers:CreateTimer(0.3, function()
		event.target:CutDown(caster:GetTeamNumber())
		EmitSoundOn("Hero_Shredder.Attack", caster)
		local shredderAbility = caster:FindAbilityByName("redfall_friendly_shredder_passive" )
		shredderAbility:ApplyDataDrivenModifier(caster, caster, "modifier_shredder_lumber", {})
		local currentStack = caster:GetModifierStackCount("modifier_shredder_lumber", caster)
		caster:SetModifierStackCount("modifier_shredder_lumber", caster, currentStack + 1)
	end)

end

function shredder_whirling_death_cast(event)
	local caster = event.caster
	local ability = event.ability
	local bladePFX = ParticleManager:CreateParticle("particles/units/heroes/hero_shredder/shredder_whirling_death.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(bladePFX, 0, caster:GetAbsOrigin()+Vector(0,0,60))
	Timers:CreateTimer(2.5, function()
		ParticleManager:DestroyParticle(bladePFX, false)
	end)
	EmitSoundOn("Redfall.FriendlyShredder.WhirlingDeath", caster)
	local treeCount = 0
	local trees = GridNav:GetAllTreesAroundPoint(caster:GetAbsOrigin(), 280, false)
	--print(#trees)
	for i = 1, #trees, 1 do
		if trees[i]:IsStanding() then
			treeCount = treeCount + 1
			trees[i]:CutDown(caster:GetTeamNumber())
		end
	end
	local shredderAbility = caster:FindAbilityByName("redfall_friendly_shredder_passive" )
	shredderAbility:ApplyDataDrivenModifier(caster, caster, "modifier_shredder_lumber", {})
	local currentStack = caster:GetModifierStackCount("modifier_shredder_lumber", caster)
	caster:SetModifierStackCount("modifier_shredder_lumber", caster, currentStack + treeCount)
end
