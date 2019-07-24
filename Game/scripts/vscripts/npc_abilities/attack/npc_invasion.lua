    -- Name: invasion
    -- Description: Create near every hero portal to inferno(total 5 portals, if less heroes create portals in random places)
    --  While hero stay in portal deal damage to him increased every second and heal boss based on hero taken damage
    --  If no hero in portal summon imp. Each next summoned imp stronger than previous. The summoner can't die while any imp alive
    --  Cast time reduce affect the damage interval and interval before summon imps
    --  Base values:
    --      Cooldown: 45
    --      Duration: 25
    --      Max imps count: 25
    --
    --      Damage per tick: 1 000/15 000/90 000
    --      Damage interval: 0.33
    --      Damage increase per tick: 1.5x
    --      Imp stat multiply: 1.5x
    --      Spell Lifesteal: 10/1 000/10 000x(10k/15m/900m initial)
    -- Imp:
    --      Effective hp: 4 000/600 000/5T{multiply}
    --      Movespeed: 450
    --      Attack range: 600
    --      Damage: 1
    --      Attack speed: 100{multiply}
    --      Abilities:
    --          Durable(30%/5s)
    --          Fireball(multiply count and damage)
    --          Explode(multiply radius(only 1/30 of multiply) and damage)
    --          Memory guard

    require('/npc_units/chaos_lords/summons/imp')

    local particlePortal = 'particles/portals/green_portal.vpcf'
    local portalRadius = 100

    LinkLuaModifier("modifier_invasion_passive", "npc_abilities/attack/invasion", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_invasion_portal", "npc_abilities/attack/invasion", LUA_MODIFIER_MOTION_NONE)

    local eventId

    require('/npc_abilities/base_ability')
    require('/npc_abilities/base_modifier')

    invasion = class({}, nil, npc_base_ability)
    modifier_invasion_passive = class(npc_base_modifier, nil, npc_base_modifier)
    modifier_invasion_portal = class(npc_base_modifier, nil, npc_base_modifier)


    local passive = modifier_invasion_passive
    local abilityClass = invasion
    local portal = modifier_invasion_portal

    function passive:OnCreated()
        self.imps = {}
    end
    function passive:IsBuff()
        return true
    end
    function passive:GetLethalCheck(data)
        local ability = self:GetAbility()
        for id, imp in pairs(ability.imps) do
            if imp == nil or imp:IsNull() or not imp:IsAlive() then
                self.imps[id] = nil
            else
                return 0
            end
        end
        return data.damage
    end

    function passive:OnLethal()
        local ability = self:GetAbility()
        ability.stopSpawn = true
    end

    function abilityClass:OnSpellStart()
        if not self:Initialized() then
            print('ability ' .. self:GetName() .. ' not initialized')
            return
        end

        self.impsPowerAmplify = 1
        self.imps = {}
        self.stopSpawn = false
    end

    function abilityClass:Init(arenaRadius, arenaCenter)
        self.initialized = true
        self.arenaRadius = arenaRadius
        self.arenaCenter = arenaCenter
    end

    function abilityClass:GetIntrinsicModifierName()
        return 'modifier_invasion_passive'
    end

    function abilityClass:CreatePortals()
        local owner = self:GetCaster()
        local portalsCount = self:GetSpecialValueFor('portals_count')
        local portalsCreated = 0

        local enemies = FindUnitsInRadius(owner:GetTeamNumber(), self.arenaCenter, nil, self.arenaRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)

        for _,enemy in pairs(enemies) do
            local enemyOrigin = enemy:GetAbsOrigin()
            self:CreatePortal(enemyOrigin)
        end
        portalsCreated = #enemies

        for portalsCreated = portalsCreated + 1, portalsCount do
            -- it has not equal probability for create portals in any point of arena, but much faster
            local locationX = RandomInt(-radiusOfArena, radiusOfArena)
            local maximumForLocationY = math.sqrt(radiusOfArena ^ 2 - locationX ^ 2)
            local locationY = RandomInt(-maximumForLocationY, maximumForLocationY)
            self:CreatePortal(Vector(centerOfArena.x + locationX, centerOfArena.y + locationY))
        end
    end

    -- TODO: make great animation for portal
    function abilityClass:CreatePortal(position)
        local owner = self:GetCaster()
        local portalDuration = self:GetSpecialValueFor('duration')

        local dummy = CreateUnitByName("dummy_unit_vulnerable", position, false, owner, owner, owner:GetTeam())
        dummy:AddAbility("dummy_unit"):SetLevel(1)
        local modifier = dummy:AddNewModifier(owner, self, 'modifier_invasion_portal', { duration = portalDuration })
        dummy.pfx = ParticleManager:CreateParticle(particlePortal, PATTACH_CUSTOMORIGIN, owner)

        modifier.dummy = dummy
        ParticleManager:SetParticleControl(dummy.pfx, 0, position)
        ParticleManager:SetParticleControl(dummy.pfx, 1, Vector(0.45, 0.45, 0.45))
        ParticleManager:SetParticleControl(dummy.pfx, 2, Vector(0.45, 0.45, 0.45))
        ParticleManager:SetParticleControl(dummy.pfx, 3, Vector(0.45, 0.45, 0.45))
    end

    function portal:OnCreated()
        local ability = self:GetAbility()
        self.interval = ability:GetSpecialValueFor('interval')
        self.powerUp = ability:GetSpecialValueFor('powerup')
        self.currentPowerUp = 1
        self.damage = ability:GetSpecialValueFor('damage')
        self.timeBeforeSummonImp = ability:GetSpecialValueFor('time_before_summon_imp')
        self.intervalsWithoutPlayerInIt = 0
        self:StartIntervalThink(self.interval)
    end

    function portal:OnDestroy()
        local dummy = self.dummy
        ParticleManager:DestroyParticle(dummy.pfx, false)
        dummy:ForceKill(false)
    end

    function portal:OnIntervalThink()
        local dummy = self.dummy
        local enemies = FindUnitsInRadius(dummy:GetTeamNumber(), dummy:GetAbsOrigin(), nil, portalRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
        if #enemies > 0 then
            self.intervalsWithoutPlayerInIt = 0
            for _,enemy in pairs(enemies) do
                self:DealDamage(enemy)
            end
        else
            self.intervalsWithoutPlayerInIt = self.intervalsWithoutPlayerInIt + 1
            self.currentPowerUp = 1
            if self.interval * self.intervalsWithoutPlayerInIt > self.timeBeforeSummonImp and not self.stopSpawn then
                self.intervalsWithoutPlayerInIt = 0
                self:SummonImp()
            end
        end

    end

    function portal:SummonImp()
        local owner = self.dummy
        local position = owner:GetAbsOrigin()
        local ability = self:GetAbility()

        local imp = chaos_lords__imp:Create(owner, position, 1, ability.impsPowerAmplify)
        table.insert(ability.imps, imp)
        ability.impsPowerAmplify = ability.impsPowerAmplify * self.powerUp
    end

    function portal:DealDamage(enemy)
        local caster = self:GetCaster()
        local damage = self.damage ^ self.currentPowerUp
        self.currentPowerUp = self.currentPowerUp * self.powerUp
        Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PURE, BASE_ITEM, RPC_ELEMENT_NONE, RPC_ELEMENT_NONE)
    end