-- Name: memory guard
-- Description:
--      Reduce damage of elements based on last 4 instance of taken damage. Effect multiplicative. Unaffect instances of taken damage without element
-- Base values:
--      Damage reduce: 10/30/50% per attack
--      Time before expire: 2 seconds
-- Some explanation:
--      The ability make hard for split. If 4 attacks with the same element it will reduce taken damage by ~94% at 3 lvl
function getDamageReducePerAttack(ability)
end
function getDamageReduce(ability)
end
