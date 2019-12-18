function base_cannon_phase(event)
	local caster = event.caster
	StartAnimation(caster, {duration = 0.3, activity = ACT_DOTA_ATTACK2, rate = 2})
end

function base_cannon_shoot(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local element = event.element
	local projectileModel = ""
	local sound = ""
	local speed = 1200
	local ability_number = 1
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if element == "nature" then
		projectileModel = "particles/units/heroes/hero_treant/treant_leech_seed_projectile.vpcf"
		sound = "Jex.NatureCannon.Shoot"
		ability_number = 1
	elseif element == "lightning" then
		-- projectileModel = "particles/econ/items/razor/razor_ti6/razor_base_attack_ti6.vpcf"
		projectileModel = "particles/units/heroes/hero_razor/razor_base_attack.vpcf"
		sound = "Jex.LightningCannon.Shoot"
		speed = 5000
		ability_number = 2
	elseif element == "cosmic" then
		projectileModel = "particles/units/heroes/hero_vengeful/vengeful_base_attack.vpcf"
		sound = "Jex.CosmicCannon.Shoot"
		ability_number = 3
	elseif element == "fire" then
		projectileModel = "particles/units/heroes/hero_lina/lina_base_attack.vpcf"
		sound = "Jex.FireCannon.Shoot"
		ability_number = 2
	end
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			local info =
	{
		Target = enemy,
		Source = caster,
		Ability = ability,
		EffectName = projectileModel,
		StartPosition = "attach_attack2",
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 8,
		bProvidesVision = true,
		iVisionRadius = 0,
		iMoveSpeed = speed,
	iVisionTeamNumber = caster:GetTeamNumber()}
			projectile = ProjectileManager:CreateTrackingProjectile(info)		
		end
	end
	Filters:CastSkillArguments(ability_number, caster)
	EmitSoundOn(sound, caster)
end

function base_cannon_impact(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local element = event.element

	local sound = ""
	local ability_letter = BASE_ABILITY_Q
	local damage_element = RPC_ELEMENT_NONE
	if element == "nature" then
		sound = "Jex.NatureCannon.Hit"
		damage_element = RPC_ELEMENT_NATURE
		ability_letter = BASE_ABILITY_Q
	elseif element == "lightning" then
		sound = "Jex.LightningCannon.Hit"
		damage_element = RPC_ELEMENT_LIGHTNING
		ability_letter = BASE_ABILITY_W
	elseif element == "cosmic" then
		sound = "Jex.CosmicCannon.Hit"
		damage_element = RPC_ELEMENT_COSMOS
		ability_letter = BASE_ABILITY_E
	elseif element == "fire" then
		sound = "Jex.FireCannon.Hit"
		damage_element = RPC_ELEMENT_FIRE
		ability_letter = BASE_ABILITY_W
	end
	local damage = event.damage
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, ability_letter, damage_element, RPC_ELEMENT_NONE)
	local key = 'jex_base_cannon_sound'
	Util.Common:LimitPerTimeAndPlace(2, 2, target:GetAbsOrigin(), 400, key, function()
		EmitSoundOn(sound, target)
	end)
end
