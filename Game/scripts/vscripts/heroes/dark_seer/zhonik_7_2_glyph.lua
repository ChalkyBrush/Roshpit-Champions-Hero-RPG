require('/heroes/dark_seer/zhonik_constants')

function zhonik_7_2_think(event)
	local ability = event.ability
	local hero = event.target
	local caster = event.caster
	local movespeed = hero:GetBaseMoveSpeed()
	local movespeedModifier = hero:GetMoveSpeedModifier(movespeed, false)
	local threshold = ZHONIK_GLYPH_7_2_MS_THRESHOLD
	if movespeedModifier <= threshold then
		event.ability:ApplyDataDrivenModifier(caster, hero, "modifier_zonik_glyph_7_2_movespeed", {duration = ZHONIK_GLYPH_7_2_BURST_DURATION})
	end	
end