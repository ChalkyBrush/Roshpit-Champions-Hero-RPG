function treasure_goblin_thinker(event)
	local goblin = event.caster
	if goblin.aggro then
		goblin:MoveToPosition(goblin:GetAbsOrigin() + RandomVector(RandomInt(300, 700)))
		local luck = RandomInt(1, 2)
		if luck == 1 then
			treasure_goblin_laugh(goblin)
		end
	end
end

function treasure_goblin_take_damage(event)
	local attacker = event.attacker
	local goblin = event.caster

	local runDirection = ((goblin:GetAbsOrigin() - attacker:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	runDirection = WallPhysics:rotateVector(runDirection, 2*math.pi*RandomInt(-2, 2)/60)

	goblin:MoveToPosition(goblin:GetAbsOrigin()+runDirection*RandomInt(400, 900))

	if goblin.item_drops > 0 then
		if goblin:GetHealth() < goblin:GetMaxHealth()*((goblin.item_drops-1)*0.14) then
			goblin.item_drops = goblin.item_drops - 1
			TreasureGoblins:TreasureGoblinItemDrop(goblin)
			local pfx = CustomAbilities:QuickAttachParticle("particles/econ/items/alchemist/alchemist_midas_knuckles/alch_knuckles_lasthit_coins.vpcf", goblin, 3)
			ParticleManager:SetParticleControl(pfx, 1, goblin:GetAbsOrigin()+Vector(0,0,80))
			EmitSoundOn("RPCItems.TreasureGoblin.ItemDrop", goblin)
		else
			local luck = RandomInt(1, 10)
			if luck == 1 then
				treasure_goblin_laugh(goblin)
			end
		end
	end

	update_treasure_goblin_speed(goblin)
end

function update_treasure_goblin_speed(goblin)
	local new_ms = 300
	local speedmult = 400
	if goblin.tier == "special" then
		speedmult = 800
	end
	new_ms = new_ms + (1 - goblin:GetHealth()/goblin:GetMaxHealth())*speedmult
	new_ms = math.min(TreasureGoblins.Stats[GameState:GetDifficultyFactor()]["max_ms"], new_ms)
	goblin.run_speed = new_ms
	print(goblin.run_speed)
end

function treasure_goblin_die(event)
	local goblin = event.caster
	TreasureGoblins:TreasureGoblinDie(goblin)
	for i = 1, 5, 1 do
		Timers:CreateTimer((i-1)*0.15, function()
			CustomAbilities:QuickAttachParticle("particles/econ/items/alchemist/alchemist_midas_knuckles/alch_knuckles_lasthit_coins.vpcf", goblin, 3)
			ParticleManager:SetParticleControl(pfx, 1, goblin:GetAbsOrigin()+Vector(0,0,80))
		end)
	end
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_bounty_hunter/bounty_hunter_jinada.vpcf", goblin, 4)
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_elder_titan/gilded_soul_cage.vpcf", goblin, 4)

	EmitSoundOn("RPCItems.TreasureGoblin.Die", goblin)
	EmitSoundOn("RPCItems.TreasureGoblin.ItemDropBig", goblin)
end

function treasure_goblin_laugh(goblin)
	if not goblin.soundLock then
		EmitSoundOn("RPCItems.TreasureGoblin.Laugh", goblin)
		goblin.soundLock = true
		Timers:CreateTimer(1, function()
			goblin.soundLock = false
		end)
	end
end