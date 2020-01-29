RUBILASH_COLORS = {"red", "yellow", "blue"}
RUBILASH_COLORS_DATA = {}
RUBILASH_COLORS_DATA["red"] = Vector(255, 0, 0)
RUBILASH_COLORS_DATA["yellow"] = Vector(255, 255, 0)
RUBILASH_COLORS_DATA["blue"] = Vector(255, 255, 255)

function rubilash_init(event)
	local caster = event.caster
	if not caster.color then
		caster.color = "blue"
	end
	for k, v in pairs(caster:GetChildren()) do
		if v:GetClassname() == "dota_item_wearable" then
			if string.match(v:GetModelName(), "weapon") then
				print(v:GetModelName())
				caster.weaponFX = v
				caster.origWeapon = v:GetModelName()
				break
			end
		end
	end

	local force_weapon_model = "models/items/grimstroke/grimstroke_ti9_immortal_weapon/grimstroke_ti9_immortal_weapon.vmdl"
	caster.weaponInit = true
	caster.weaponFX:SetModel(force_weapon_model)
	toggle_rubilash_color(caster)
end

function rubilash_w_cast(event)
	local caster = event.caster
	local ability = event.ability

	toggle_rubilash_color(caster)

end

function toggle_rubilash_color(caster)
	if caster.color == "red" then
		caster.color = "yellow"
	elseif caster.color == "yellow" then
		caster.color = "blue"
	elseif caster.color == "blue" then
		caster.color = "red"
	end
	set_rubilash_color_visual(caster)
end

function set_rubilash_color_visual(caster)
	if caster.pfx then
		ParticleManager:DestroyParticle(caster.pfx, false)
		ParticleManager:ReleaseParticleIndex(caster.pfx)
	end
	caster.pfx = ParticleManager:CreateParticle("particles/roshpit/rubilash/paintbrush_"..caster.color..".vpcf", PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(caster.pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_brush_end", caster:GetAbsOrigin(), true)
end