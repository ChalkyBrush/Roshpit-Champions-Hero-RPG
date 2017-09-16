function EnterNoArea(trigger)
	local hero = trigger.activator
	local vector = Vector(-4636, 7062)
  	hero:SetAbsOrigin(vector)
end

function wall0_n(trigger)
	print('wall0')
	local hero = trigger.activator
	hero.pushVector = Vector(0,5,0)
	hero.wall = true
	local ability = Events.GameMaster:FindAbilityByName("npc_abilities")
	ability:ApplyDataDrivenModifier(Events.GameMaster, hero, "modifier_wall_pushback_0", {duration = 0.33})
	ability:ApplyDataDrivenModifier(Events.GameMaster, hero, "modifier_walling", {duration = 0.33})
end

function wall0_2(trigger)
	print('wall02')
	local hero = trigger.activator
	local origin = hero:GetAbsOrigin()
	hero:SetAbsOrigin(origin+Vector(0,50,0))
end

function wall0_3(trigger)
	print('wall03')
	local hero = trigger.activator
	local origin = hero:GetAbsOrigin()
	hero:SetAbsOrigin(origin+Vector(0,200,0))
end

function wall90(trigger)
	local hero = trigger.activator
	local origin = hero:GetAbsOrigin()
	hero:SetAbsOrigin(origin-Vector(100,0,0))
end

function TouchingSpikes(trigger)
	print("touchingSpikes")
	local hero = trigger.activator
	local ability = Events.GameMaster:FindAbilityByName("npc_abilities")
	ability:ApplyDataDrivenModifier(Events.GameMaster, hero, "modifier_spike_damage", {duration = 0.11})
end

function SpikeTouchStart(trigger)
	local hero = trigger.activator
	local ability = Events.GameMaster:FindAbilityByName("npc_abilities")

	
		-- Timers:CreateTimer(0.2, function()
		-- 	if hero:HasModifier("modifier_spike_damage") then
		-- 		ability:ApplyDataDrivenModifier(Events.GameMaster, hero, "modifier_spike_damage", {duration = 5000})
		-- 	end
		-- end)
	

	ability:ApplyDataDrivenModifier(Events.GameMaster, hero, "modifier_spike_damage", {duration = 5000})


end

function SpikeTouchEnd(trigger)
	local hero = trigger.activator
	hero:RemoveModifierByName("modifier_spike_damage")
	Timers:CreateTimer(0.15, function()
		hero:RemoveModifierByName("modifier_spike_damage")
	end)
	Timers:CreateTimer(0.35, function()
		hero:RemoveModifierByName("modifier_spike_damage")
	end)
end