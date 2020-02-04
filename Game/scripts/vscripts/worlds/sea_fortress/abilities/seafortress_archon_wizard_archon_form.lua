require('heroes/antimage/arkimus_archon_form')
ARCHON_WIZARD_R1 = 200
ARCHON_WIZARD_R2 = 200
ARCHON_WIZARD_R3 = 100
ARCHON_WIZARD_R4 = 50

seafortress_archon_wizard_archon_form = class({})


function seafortress_archon_wizard_archon_form:GetIntrinsicModifierName()
    return "modifier_seafortress_archon_wizard_archon_form"
end

function seafortress_archon_wizard_archon_form:OnOwnerDied()
    local caster = self:GetCaster()
    if IsServer() then
        Seafortress.ArchonSlain = true
        local arcanas = 1
        if caster.paragon then
            arcanas = 2
        end
        for i = 1, arcanas, 1 do
            RPCItems:RollAndDropUniqueArcana(caster, "item_rpc_arkimus_arcana2")
        end
    else
        EmitSoundOn("Seafortress.ArchonWizardDie", caster)
        Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(3104, 14272, 110 + Seafortress.ZFLOAT), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
    end
end

modifier_seafortress_archon_wizard_archon_form = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_seafortress_archon_wizard_archon_form", "worlds/sea_fortress/abilities/seafortress_archon_wizard_archon_form", LUA_MODIFIER_MOTION_NONE)

function modifier_seafortress_archon_wizard_archon_form:IsHidden()
    return true
end
function modifier_seafortress_archon_wizard_archon_form:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK,
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_PROPERTY_MODEL_SCALE,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
        MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
        MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_ROSHPIT_PHYSICAL_DMG_REDUCTION,
        MODIFIER_ROSHPIT_MAGICAL_DMG_REDUCTION,
        MODIFIER_ROSHPIT_PURE_DMG_REDUCTION 
    }

    return funcs
end
function modifier_seafortress_archon_wizard_archon_form:OnCreated()
    if not IsServer() then
        return
    end
    self:StartIntervalThink(0.2)
    self:SetSpecialTypes({ 
        RPC_ELEMENT_FIRE,
        RPC_ELEMENT_EARTH,
        RPC_ELEMENT_LIGHTNING,
        RPC_ELEMENT_POISON,
        RPC_ELEMENT_TIME,
        RPC_ELEMENT_HOLY,
        RPC_ELEMENT_COSMOS,
        RPC_ELEMENT_ICE,
        RPC_ELEMENT_ARCANE,
        RPC_ELEMENT_SHADOW,
        RPC_ELEMENT_WIND,
        RPC_ELEMENT_GHOST,
        RPC_ELEMENT_WATER,
        RPC_ELEMENT_DEMON,
        RPC_ELEMENT_NATURE,
        RPC_ELEMENT_UNDEAD,
        RPC_ELEMENT_DRAGON
    })
end
function modifier_seafortress_archon_wizard_archon_form:GetModifierAttackRangeBonus(params)
    return 800
end

function modifier_seafortress_archon_wizard_archon_form:GetModifierProjectileSpeedBonus(params)
    return 800
end
function modifier_seafortress_archon_wizard_archon_form:GetModifierAttackSpeedBonus_Constant()
    return 1000
end
function modifier_seafortress_archon_wizard_archon_form:GetPhysicalDamageReduction()
    return 0.70
end
function modifier_seafortress_archon_wizard_archon_form:GetMagicalDamageReduction()
    return 0.70
end
function modifier_seafortress_archon_wizard_archon_form:GetPureDamageReduction()
    return 0.70
end
function modifier_seafortress_archon_wizard_archon_form:GetModifierBaseAttackTimeConstant()
    local hero = self:GetParent()
    if hero.CurrentModifier ~= self then
        hero.CurrentModifier = self
        local currentBat = hero:GetBaseAttackTime()
        hero.CurrentModifier = nil
        local batBonus = ARKIMUS_ARCANA2_R_BAT_RED_PCT * currentBat
        batBonus = batBonus + currentBat * ARKIMUS_ARCANA2_R4_BAT_RED_PCT * ARCHON_WIZARD_R4
        local newBat = currentBat - batBonus
        return newBat
    end
    return -1
end
function modifier_seafortress_archon_wizard_archon_form:GetModifierBaseAttack_BonusDamage()
    local hero = self:GetParent()
    return hero:GetMana() * ARCHON_WIZARD_R2 * ARKIMUS_ARCANA2_R2_BASE_DMG_PER_MANA_PCT
end
function modifier_seafortress_archon_wizard_archon_form:GetRoshpitElementalDmgBonus()
    return ARKIMUS_ARCANA2_R3_ELEMENTS_PCT * ARCHON_WIZARD_R3
end

function modifier_seafortress_archon_wizard_archon_form:OnAttackLanded(event)
    local attacker = event.attacker
    if attacker ~= self:GetParent() then
        return
    end
    local ability = self:GetAbility()
    local target = event.target
    if not ability.aoePosition then
        ability.aoePosition = Vector(0, 0)
    end
    if WallPhysics:GetDistance2d(attacker:GetAbsOrigin(), target:GetAbsOrigin()) <= attacker:Script_GetAttackRange() / 2 then
        attacker:AddNewModifier(attacker, ability, "modifier_arkimus_archon_form_pushback", {duration = 1})
        local pushFV = ((attacker:GetAbsOrigin() - target:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
        ability.pushFV = pushFV
        ability.pushVelocity = 20
    end
    attacker:AddNewModifier(attacker, ability, "modifier_seafortress_archon_wizard_archon_form_field_thinker", {duration = ARKIMUS_ARCANA2_R1_DURATION})
    if WallPhysics:GetDistance2d(ability.aoePosition, target:GetAbsOrigin()) > 80 then
        if ability.pfx then
            ParticleManager:DestroyParticle(ability.pfx, false)
            ability.pfx = false
        end
        ability.pfx = ParticleManager:CreateParticle("particles/roshpit/arkimus/archon_flare_ambient.vpcf", PATTACH_CUSTOMORIGIN, nil)
        ParticleManager:SetParticleControl(ability.pfx, 0, target:GetAbsOrigin())
        ParticleManager:SetParticleControl(ability.pfx, 1, Vector(ARKIMUS_ARCANA2_R1_AOE, ARKIMUS_ARCANA2_R1_AOE, ARKIMUS_ARCANA2_R1_AOE))
        ability.aoePosition = GetGroundPosition(target:GetAbsOrigin(), target)
        EmitSoundOnLocationWithCaster(ability.aoePosition, "Arkimus.ArchonFlare.Start", attacker)
        EmitSoundOn("Arkimus.ArchonFlare.Go", target)
    end
end

function modifier_seafortress_archon_wizard_archon_form:OnAttack(event)
    local attacker = event.attacker
    if attacker ~= self:GetParent() then
        return
    end
    local target = event.target
    if target.dummy then
    else
        local luck = RandomInt(1, 1000)
        if luck <= ARCHON_WIZARD_R4 * ARKIMUS_ARCANA2_R4_CHANCE_DIV_1000 then
            Filters:PerformAttackSpecial(attacker, target, true, true, true, false, true, false, false)
        end
    end
end


function modifier_seafortress_archon_wizard_archon_form:OnIntervalThink(event)
	local caster = self:GetParent()
	local ability = self:GetAbility()
	if not caster.golems then
		caster.interval = 0
		caster.golemsSpawned = 0
		caster.golems = Entities:FindAllByNameWithin("ArchonGolem", Vector(3876, 15028, 100 + Seafortress.ZFLOAT), 3800)
	end
	if (caster:GetHealth() / caster:GetMaxHealth()) * 100 < 100 - caster.golemsSpawned * 10 then
		local golemIndex = RandomInt(1, #caster.golems)
		caster.golemsSpawned = caster.golemsSpawned + 1
		local newTable = {}
		for i = 1, #caster.golems, 1 do
			if i == golemIndex then

			else
				table.insert(newTable, caster.golems[i])
			end
		end
		local golem = caster.golems[golemIndex]
		caster.golems = newTable
		-- if golem then
		CreateZonisBeamSeafort(caster:GetAbsOrigin() + Vector(0, 0, 60), golem:GetAbsOrigin() + Vector(0, 0, 60))
		Seafortress:objectShake(golem, 60, 10, true, true, false, "Seafortress.ArchonGolemShaking", 20)
		Seafortress:smoothColorTransition(golem, Vector(75, 53, 88), Vector(207, 94, 255), 60)
		Timers:CreateTimer(1.9, function()
			Seafortress:SpawnArchonGolem(golem:GetAbsOrigin(), RandomVector(1))
			Timers:CreateTimer(0.1, function()
				UTIL_Remove(golem)
			end)
		end)
		-- end
	end
	if caster.aggro then
		caster.interval = caster.interval + 1
		if caster.interval == 14 then
			caster.interval = 0
			CustomAbilities:QuickAttachParticle("particles/items_fx/blink_dagger_start.vpcf", caster, 3)
			FindClearSpaceForUnit(caster, Vector(3876, 15028, 128) + RandomVector(RandomInt(0, 1000)), false)
			ProjectileManager:ProjectileDodge(caster)
			CustomAbilities:QuickAttachParticle("particles/items_fx/blink_dagger_end.vpcf", caster, 3)
			StartAnimation(caster, {duration = 2.0, activity = ACT_DOTA_SPAWN, rate = 1.6})
			EmitSoundOn("Seafortress.MountainBeast.Blink", caster)
		end
	end
end

function CreateZonisBeamSeafort(attachPointA, attachPointB)
	for i = 0, 4, 1 do
		Timers:CreateTimer(0.2 * i, function()
			local particleName = "particles/roshpit/arkimus/zonis_lightning.vpcf"
			local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
			ParticleManager:SetParticleControl(lightningBolt, 0, Vector(attachPointA.x, attachPointA.y, attachPointA.z))
			ParticleManager:SetParticleControl(lightningBolt, 1, Vector(attachPointB.x, attachPointB.y, attachPointB.z))
			Timers:CreateTimer(2, function()
				ParticleManager:DestroyParticle(lightningBolt, false)
				ParticleManager:ReleaseParticleIndex(lightningBolt)
			end)
		end)
	end
end

modifier_seafortress_archon_wizard_archon_form_field_thinker = class ({})
LinkLuaModifier("modifier_seafortress_archon_wizard_archon_form_field_thinker", "worlds/sea_fortress/abilities/seafortress_archon_wizard_archon_form", LUA_MODIFIER_MOTION_NONE)

function modifier_seafortress_archon_wizard_archon_form_field_thinker:IsHidden()
    return true
end

function modifier_seafortress_archon_wizard_archon_form_field_thinker:OnCreated()
    self:StartIntervalThink(0.1)
end
function modifier_seafortress_archon_wizard_archon_form_field_thinker:OnIntervalThink()
    if IsServer() then
        local caster = self:GetParent()
        local ability = self:GetAbility()
        for i = 1, 2, 1 do
            local flarePos = ability.aoePosition + RandomVector(RandomInt(0, 160))
            CustomAbilities:QuickParticleAtPoint("particles/roshpit/arkimus/archon_flare_ambient_hit.vpcf", flarePos, 1)
        end
        local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * ARKIMUS_ARCANA2_R1_DMG_OF_ATTACK_POWER_PCT * ARCHON_WIZARD_R1
        local enemies = FindUnitsInRadius(caster:GetTeamNumber(), ability.aoePosition, nil, ARKIMUS_ARCANA2_R1_AOE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
        for k, v in pairs(enemies) do
            if v.dummy then table.remove(enemies, k) end
        end
        if #enemies > 0 then
            local dividedDamage = damage / #enemies
            for _, enemy in pairs(enemies) do
                Filters:TakeArgumentsAndApplyDamage(enemy, caster, dividedDamage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_R, RPC_ELEMENT_ARCANE, RPC_ELEMENT_NONE)
            end
        end
    end
end

function modifier_seafortress_archon_wizard_archon_form_field_thinker:OnDestroy()
    local caster = self:GetParent()
	local ability = self:GetAbility()
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ability.pfx = false
    end
end