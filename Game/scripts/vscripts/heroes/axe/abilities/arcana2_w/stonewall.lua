require('heroes/axe/init')
local Helix = require('heroes/axe/glyphs/t41_helix')
local WAmplify = require('heroes/axe/glyphs/t52_w_amplify')

function stonewall_start(event)
	local caster = event.caster
	local ability = event.ability
	local duration = event.duration
	StartAnimation(caster, {duration=2.0, activity=ACT_DOTA_OVERRIDE_ABILITY_2, rate=1.3})
	local fv = Vector(0,1)
	local wallTable = {}
	EmitSoundOn("RedGeneral.Stonewall.AxeStart", caster)
	EmitSoundOn("RedGeneral.Stonewall.AxeStart.VO", caster)
	CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_axe/axe_battle_hunger_start.vpcf", caster:GetAbsOrigin()+Vector(0,0,200), 2)
	local wall_thinker = CreateUnitByName("npc_dummy_unit", caster:GetAbsOrigin(), false, nil, nil, caster:GetTeamNumber())
	wall_thinker:FindAbilityByName("dummy_unit"):SetLevel(1)
	ability:ApplyDataDrivenModifier(caster, wall_thinker, "modifier_stonewall_aura_friendly", {})
	local w_1_level = caster:GetRuneValue("w", 1)
	AddFOWViewer(caster:GetTeamNumber(), caster:GetAbsOrigin(), 300, duration, false)
	local ground_pfx = nil
	if w_1_level > 0 then
		ground_pfx = ParticleManager:CreateParticle("particles/roshpit/red_general/stonewall_postmit_area.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(ground_pfx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(ground_pfx, 1, Vector(350, 350, 350))
		ability:ApplyDataDrivenModifier(caster, wall_thinker, "modifier_stonewall_aura_enemy", {})
	end
	for i = 0, 6, 1 do
		local rotatedFV = WallPhysics:rotateVector(fv, 2*math.pi*i/7)
		local wallPosition = caster:GetAbsOrigin()+rotatedFV*300
		local wall = CreateUnitByName("npc_dummy_unit", wallPosition, false, nil, nil, caster:GetTeamNumber())
		wall:SetAbsOrigin(wall:GetAbsOrigin()-Vector(0,0,200))
		wall:AddAbility("dummy_unit_with_collision"):SetLevel(1)		
		wall:SetModel("maps/journey_assets/props/walls_128/wall_jrny_radiant_128_int_1.vmdl")
		wall:SetOriginalModel("maps/journey_assets/props/walls_128/wall_jrny_radiant_128_int_1.vmdl")
		wall:SetHullRadius(110)
		local wallFacing = WallPhysics:rotateVector(rotatedFV, 2*math.pi*2.666/7)
		wall:SetForwardVector(wallFacing)
		wall:SetModelScale(1.24)
		wall:SetRenderColor(255, 100, 100)
		table.insert(wallTable, wall)
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_undying/undying_loadout.vpcf", wall, 3)
		EmitSoundOn("RedGeneral.Stonewall.Start", wall)
	end
	for i = 1, 10, 1 do
		Timers:CreateTimer(i*0.03, function()
			for i = 1, #wallTable, 1 do
				local wall = wallTable[i]
				wall:SetAbsOrigin(wall:GetAbsOrigin()+Vector(0,0,200/10))
			end
		end)
	end
	Timers:CreateTimer(duration, function()
		for i = 1, #wallTable, 1 do
			local wall = wallTable[i]
			CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_undying/undying_loadout.vpcf", wall:GetAbsOrigin(), 3)
			EmitSoundOn("RedGeneral.Stonewall.End", wall)
		end
		for i = 1, 10, 1 do
			Timers:CreateTimer(i*0.03, function()
				for i = 1, #wallTable, 1 do
					local wall = wallTable[i]
					wall:SetAbsOrigin(wall:GetAbsOrigin()-Vector(0,0,200/10))
				end
			end)
		end
		Timers:CreateTimer(0.27, function()
			UTIL_Remove(wall_thinker)
			if ground_pfx then
				ParticleManager:DestroyParticle(ground_pfx, false)
				ParticleManager:ReleaseParticleIndex(ground_pfx)
			end
		end)
		Timers:CreateTimer(0.4, function()
			for i = 1, #wallTable, 1 do
				local wall = wallTable[i]
				UTIL_Remove(wall)
			end
		end)
	end)
	Filters:CastSkillArguments(2, caster)
	local w_4_level = caster:GetRuneValue("w", 4)
	if w_4_level > 0 then
		--print("IN HERE?")
		local radius = AXE_ARCANA2_W3_RADIUS_BASE + AXE_ARCANA2_W3_RADIUS_GROWTH*w_4_level
		-- local pfx = CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_axe/axe_beserkers_call_owner.vpcf", caster, 2)
		-- ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
		local pfx = CustomAbilities:QuickAttachParticle("particles/econ/items/axe/axe_helm_shoutmask/axe_beserkers_call_owner_shoutmask.vpcf", caster, 3)
		ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 2, Vector(radius,radius,radius))
	    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	    if #enemies > 0 then
	        for _,enemy in pairs(enemies) do
	            enemy:MoveToTargetToAttack(caster)
			    if caster:HasModifier("modifier_axe_glyph_1_2") then
			        Filters:ApplyStun(caster, T12_STUN_DURATION*ability:GetLevel(), enemy)
			    end	 
			    local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), enemy:GetAbsOrigin())
			    if distance > 80 then
			    	if enemy.dummy or enemy.pushLock then
			    	else
			    		local moveVector = ((caster:GetAbsOrigin()-enemy:GetAbsOrigin())*Vector(1,1,0)):Normalized()
			    		FindClearSpaceForUnit(enemy, enemy:GetAbsOrigin() + moveVector*distance*0.8, false)
			    	end
			    end    	            
	        end
	    end 
    local effectName = "particles/roshpit/red_general/stonewall_vacuum.vpcf"
    local particle = ParticleManager:CreateParticle(effectName, PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(particle, 0, Vector(0.5,0.5,0.5))
    ParticleManager:SetParticleControl(particle, 1, Vector(radius,radius,radius))
    ParticleManager:SetParticleControl(particle, 2, Vector(0.5,0.5,0.5))
    ParticleManager:SetParticleControl(particle, 3, caster:GetOrigin())
    ParticleManager:SetParticleControl(particle, 4, Vector(0,0,0))



	end
	Helix.cast(caster,ability)
end

function stonewall_friendly_aura_create(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	if caster == target then
		local w_2_level = caster:GetRuneValue("w", 2)
		if w_2_level > 0 then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_stonewall_aura_axe_armor_strength", {duration = 7})
			caster:SetModifierStackCount("modifier_stonewall_aura_axe_armor_strength", caster, w_2_level)
		end
	end
end

function stonewall_passive_attacked(event)
	local caster = event.caster
	local attacker = event.attacker
	local w_3_level = caster:GetRuneValue("w", 3)
	if w_3_level > 0 then
		local luck = RandomInt(1, 100)
		if luck <= 15 then
			EmitSoundOn("RedGeneral.Stonewall.Helix", caster)
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_axe/axe_attack_blur_counterhelix.vpcf", caster, 4)
			StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_CAST_ABILITY_3, rate=1.1})
			local damage = (AXE_ARCANA2_W3_DMG_PCT_ATK_POWER/100)*w_3_level*OverflowProtectedGetAverageTrueAttackDamage(caster)
		    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 220, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
		    if #enemies > 0 then
		        for _,enemy in pairs(enemies) do
		            Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PURE, BASE_ABILITY_W, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
		        end
		    end 
		end
	end
end