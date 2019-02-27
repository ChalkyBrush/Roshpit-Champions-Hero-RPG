function base_cannon_phase(event)
	local caster = event.caster
	StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_ATTACK2, rate=2})
end

function base_cannon_shoot(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local element = event.element
	local projectileModel = ""
	local sound = ""
	local speed = 1200
	if element == "nature" then
		projectileModel = "particles/units/heroes/hero_treant/treant_leech_seed_projectile.vpcf"
		sound = "Jex.NatureCannon.Shoot"
	elseif element == "lightning" then
		-- projectileModel = "particles/econ/items/razor/razor_ti6/razor_base_attack_ti6.vpcf"
		projectileModel = "particles/units/heroes/hero_razor/razor_base_attack.vpcf"
		sound = "Jex.LightningCannon.Shoot"
		speed = 5000
	elseif element == "cosmic" then
		projectileModel = "particles/units/heroes/hero_vengeful/vengeful_base_attack.vpcf"
		sound = "Jex.CosmicCannon.Shoot"
	elseif element == "fire" then
		projectileModel = "particles/units/heroes/hero_lina/lina_base_attack.vpcf"
		sound = "Jex.FireCannon.Shoot"
	end
	local info = 
	{
		Target = target,
		Source = caster,
		Ability = ability,  
		EffectName =  projectileModel,
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
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	projectile = ProjectileManager:CreateTrackingProjectile(info)
	EmitSoundOn(sound, caster)
	Filters:CastSkillArguments(1, caster)
end

function base_cannon_impact(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local element = event.element

	local sound = ""
	local damage_element = RPC_ELEMENT_NONE
	if element == "nature" then
		sound = "Jex.NatureCannon.Hit"
		damage_element = RPC_ELEMENT_NATURE
	elseif element == "lightning" then
		sound = "Jex.LightningCannon.Hit"
		damage_element = RPC_ELEMENT_LIGHTNING
	elseif element == "cosmic" then
		sound = "Jex.CosmicCannon.Hit"
		damage_element = RPC_ELEMENT_COSMOS
	elseif element == "fire" then
		sound = "Jex.FireCannon.Hit"
		damage_element = RPC_ELEMENT_FIRE
	end
	local damage = event.damage
	EmitSoundOn(sound, target)
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 1, damage_element, RPC_ELEMENT_NONE)
end