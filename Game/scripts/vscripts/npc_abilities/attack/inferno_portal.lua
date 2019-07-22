    -- Name: portal to inferno
    -- Description: Create near every hero portal to inferno(total 5 portals, if less heroes create portals in random places)
    --  While hero stay in portal deal damage to him increased every second and heal boss based on hero taken damage
    --  If no hero in portal summon imp. Each next summoned imp stronger than previous. The summoner can't die while any imp alive
    --  Cast time reduce affect the damage interval and interval before summon imps
    --  Base values:
    --      Cooldown: 45
    --      Duration: 25
    --      Max imps count: 25
    --
    --      Damage per second: 1 000/15 000/90 000
    --      Damage interval: 0.33
    --      Damage increase per second: 1.5x
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

    LinkLuaModifier("modifier_inferno_portal", "npc_abilities/attack/inferno_portal", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_inferno_portal_place", "npc_abilities/attack/inferno_portal", LUA_MODIFIER_MOTION_NONE)

    local eventId

    require('/npc_abilities/base_ability')
    require('/npc_abilities/base_modifier')

    inferno_portal = setmetatable(class({}), npc_base_ability)
    modifier_inferno_portal = setmetatable(class({}), npc_base_modifier)
    modifier_inferno_portal_place = setmetatable(class({}), npc_base_modifier)


    local modifierClass = modifier_inferno_portal
    local abilityClass = inferno_portal
    local modifierPortalClass = modifier_inferno_portal_place


    function abilityClass:OnSpellStart()
        local caster = self:GetOwner()
        self.impsPowerAmplify = 1
        self.imps = {}
        self.stopSpawn = false
        caster:AddNewModifier(caster, self, 'modifier_inferno_portal', { duration = 1})
        print('Castern entity index is ' .. caster:GetEntityIndex()  )
        self.eventId = EventBus:on(caster:GetEntityIndex(), 'creature:beforeDeath', function(data, takenDamage)
            for id,imp in pairs(self.imps) do
                if imp == nil or imp:IsNull() or not imp:IsAlive() then
                    self.imps[id] = nil
                else
                    return false
                end
            end
            EventBus:unsubscribe(caster:GetEntityIndex(), 'creature:beforeDeath', EVENTBUS_PRIORITY_NORMAL, data.eventId)
            return takenDamage
        end, EVENTBUS_PRIORITY_NORMAL)
    end

    function modifierClass:OnCreated()
        self:CreatePortals()
        self:Destroy();
    end

    function modifierClass:CreatePortals()
        local ability = self:GetAbility()
        local owner = self:GetCaster()
        local portalsCount = 10--ability:GetSpecialValueFor('portals_count')
        local portalsCreated = 0

        local centerOfArena = EventBus:trigger(owner, 'ability:ghost_arena:getCenter', {}, owner:GetAbsOrigin())
        local radiusOfArena = EventBus:trigger(owner, 'ability:ghost_arena:getRadius', {}, 600)

        local enemies = FindUnitsInRadius(owner:GetTeamNumber(), centerOfArena, nil, radiusOfArena, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)

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
    function modifierClass:CreatePortal(position)
        local ability = self:GetAbility()
        local owner = self:GetCaster()
        local portalDuration = ability:GetSpecialValueFor('duration')

        local dummy = CreateUnitByName("dummy_unit_vulnerable", position, false, owner, owner, owner:GetTeam())
        dummy:AddAbility("dummy_unit"):SetLevel(1)
        local modifier = dummy:AddNewModifier(owner, ability, 'modifier_inferno_portal_place', { duration = portalDuration })
        dummy.pfx = ParticleManager:CreateParticle(particlePortal, PATTACH_CUSTOMORIGIN, owner)

        modifier.dummy = dummy
        ParticleManager:SetParticleControl(dummy.pfx, 0, position)
        ParticleManager:SetParticleControl(dummy.pfx, 1, Vector(0.45, 0.45, 0.45))
        ParticleManager:SetParticleControl(dummy.pfx, 2, Vector(0.45, 0.45, 0.45))
        ParticleManager:SetParticleControl(dummy.pfx, 3, Vector(0.45, 0.45, 0.45))
    end

    function modifierPortalClass:OnCreated()
        local ability = self:GetAbility()
        self.interval = ability:GetSpecialValueFor('interval')
        self.powerUp = ability:GetSpecialValueFor('powerup')
        self.currentPowerUp = 1
        self.damage = ability:GetSpecialValueFor('damage')
        self.timeBeforeSummonImp = ability:GetSpecialValueFor('time_before_summon_imp')
        self.intervalsWithoutPlayerInIt = 0
        self:StartIntervalThink(self.interval)
    end

    function modifierPortalClass:OnDestroy()
        local dummy = self.dummy
        ParticleManager:DestroyParticle(dummy.pfx, false)
        dummy:ForceKill(false)
    end

    function modifierPortalClass:OnIntervalThink()
        local dummy = self.dummy
        local ability = self:GetAbility()
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

    function modifierPortalClass:SummonImp()
        local owner = self.dummy
        local position = owner:GetAbsOrigin()
        local ability = self:GetAbility()

        local imp = chaos_lords__imp:Create(owner, position, 1, ability.impsPowerAmplify)
        table.insert(ability.imps, imp)
        ability.impsPowerAmplify = ability.impsPowerAmplify * self.powerUp
    end

    function modifierPortalClass:DealDamage(enemy)
        local caster = self:GetCaster()
        local damage = self.damage ^ self.currentPowerUp
        self.currentPowerUp = self.currentPowerUp * self.powerUp
        Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PURE, BASE_ITEM, RPC_ELEMENT_NONE, RPC_ELEMENT_NONE)
    end