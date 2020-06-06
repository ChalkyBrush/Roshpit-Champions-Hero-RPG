function RespawnPointTriggerOnStartTouch(trigger)
    local triggerEntity = trigger.caller
    local hero = trigger.activator
    if hero.respawnPointIndicator then
        ParticleManager:DestroyParticle(hero.respawnPointIndicator, false)
        ParticleManager:ReleaseParticleIndex(hero.respawnPointIndicator)
        hero.respawnPointIndicator = false
    end
    hero:SetRespawnPosition(triggerEntity:GetAbsOrigin())
    --To set after Flag was used
    hero.currentActiveSpawnPoint = triggerEntity:GetAbsOrigin()
    
    local particlePosition = triggerEntity:GetAbsOrigin()
    local pfx = ParticleManager:CreateParticleForPlayer("particles/roshpit/global_respawn_point_indicator.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster, hero:GetPlayerOwner())
    ParticleManager:SetParticleControl(pfx, 0, particlePosition)
    ParticleManager:SetParticleControlForward(pfx, 0, Vector(0, -1))
    hero.respawnPointIndicator = pfx
end