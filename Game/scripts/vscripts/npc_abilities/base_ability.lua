require('/event_bus')
npc_base_ability = class({
    element1 = RPC_ELEMENT_NONE,
    element2 = RPC_ELEMENT_NONE,
})

-- TODO: add some params for abilities for allow make
function npc_base_ability:getRadius(baseRadius)
    return EventBus:trigger('ability:getRadius', {}, baseRadius)
end

function npc_base_ability:setElements(element1, element2)
    if (element1 == nil) then
        element1 = RPC_ELEMENT_NONE
    end
    if (element2 == nil) then
        element2 = RPC_ELEMENT_NONE
    end

    self.element1, self.element2 = element1, element2
end

function npc_base_ability:getElements()
    return self.element1, self.element2
end
function npc_base_ability:getTakenDamage(takenDamage)

end