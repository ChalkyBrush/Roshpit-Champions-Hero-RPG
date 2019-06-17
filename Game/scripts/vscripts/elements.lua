if Elements == nil then
  Elements = class({})
end

RPC_ELEMENT_COUNT = 18

RPC_ELEMENT_NONE = -1
RPC_ELEMENT_NORMAL = 1
RPC_ELEMENT_FIRE = 2
RPC_ELEMENT_EARTH = 3
RPC_ELEMENT_LIGHTNING = 4
RPC_ELEMENT_POISON = 5
RPC_ELEMENT_TIME = 6
RPC_ELEMENT_HOLY = 7
RPC_ELEMENT_COSMOS = 8
RPC_ELEMENT_ICE = 9
RPC_ELEMENT_ARCANE = 10
RPC_ELEMENT_SHADOW = 11
RPC_ELEMENT_WIND = 12
RPC_ELEMENT_GHOST = 13
RPC_ELEMENT_WATER = 14
RPC_ELEMENT_DEMON = 15
RPC_ELEMENT_NATURE = 16
RPC_ELEMENT_UNDEAD = 17
RPC_ELEMENT_DRAGON = 18

RPC_ELEMENT_NORMAL_COLOR = "#DDDDDD"
RPC_ELEMENT_FIRE_COLOR = "#EF4126"
RPC_ELEMENT_EARTH_COLOR = "#AF843D"
RPC_ELEMENT_LIGHTNING_COLOR = "#5CCDF9"
RPC_ELEMENT_POISON_COLOR = "#37DD3D"
RPC_ELEMENT_TIME_COLOR = "#B5FFB7"
RPC_ELEMENT_HOLY_COLOR = "#F6FFB5"
RPC_ELEMENT_COSMOS_COLOR = "#C25DFC"
RPC_ELEMENT_ICE_COLOR = "#87D9FF"
RPC_ELEMENT_ARCANE_COLOR = "#E1A2E8"
RPC_ELEMENT_SHADOW_COLOR = "#7F4F84"
RPC_ELEMENT_WIND_COLOR = "#7AE2A7"
RPC_ELEMENT_GHOST_COLOR = "#9ACCD1"
RPC_ELEMENT_WATER_COLOR = "#3894FF"
RPC_ELEMENT_DEMON_COLOR = "#5B648C"
RPC_ELEMENT_NATURE_COLOR = "#69BC71"
RPC_ELEMENT_UNDEAD_COLOR = "#5C776E"
RPC_ELEMENT_DRAGON_COLOR = "#3289C7"

function Elements:GetElementIndexByString(element_name)
	local element_number = 0
	if element_name == "normal" then
		element_number = RPC_ELEMENT_NORMAL
	elseif element_name == "fire" then
		element_number = RPC_ELEMENT_FIRE
	elseif element_name == "earth" then
		element_number = RPC_ELEMENT_EARTH
	elseif element_name == "lightning" then
		element_number = RPC_ELEMENT_LIGHTNING
	elseif element_name == "poison" then
		element_number = RPC_ELEMENT_POISON
	elseif element_name == "time" then
		element_number = RPC_ELEMENT_TIME
	elseif element_name == "holy" then
		element_number = RPC_ELEMENT_HOLY
	elseif element_name == "cosmic" then
		element_number = RPC_ELEMENT_COSMOS
	elseif element_name == "ice" then
		element_number = RPC_ELEMENT_ICE
	elseif element_name == "arcane" then
		element_number = RPC_ELEMENT_ARCANE
	elseif element_name == "shadow" then
		element_number = RPC_ELEMENT_SHADOW
	elseif element_name == "wind" then
		element_number = RPC_ELEMENT_WIND
	elseif element_name == "ghost" then
		element_number = RPC_ELEMENT_GHOST
	elseif element_name == "water" then
		element_number = RPC_ELEMENT_WATER
	elseif element_name == "demon" then
		element_number = RPC_ELEMENT_DEMON
	elseif element_name == "nature" then
		element_number = RPC_ELEMENT_NATURE
	elseif element_name == "undead" then
		element_number = RPC_ELEMENT_UNDEAD
	elseif element_name == "dragon" then
		element_number = RPC_ELEMENT_DRAGON
	end
	return element_number
end

function Elements:GetElementNameAndColorByCode(elementCode)
	local name = ""
	local color = "#000000"
	if elementCode == RPC_ELEMENT_NORMAL then
		name = "normal"
		color = RPC_ELEMENT_NORMAL_COLOR
	elseif elementCode == RPC_ELEMENT_FIRE then
		name = "fire"
		color = RPC_ELEMENT_FIRE_COLOR
	elseif elementCode == RPC_ELEMENT_EARTH then
		name = "earth"
		color = RPC_ELEMENT_EARTH_COLOR
	elseif elementCode == RPC_ELEMENT_LIGHTNING then
		name = "lightning"
		color = RPC_ELEMENT_LIGHTNING_COLOR
	elseif elementCode == RPC_ELEMENT_POISON then
		name = "poison"
		color = RPC_ELEMENT_POISON_COLOR
	elseif elementCode == RPC_ELEMENT_TIME then
		name = "time"
		color = RPC_ELEMENT_TIME_COLOR
	elseif elementCode == RPC_ELEMENT_HOLY then
		name = "holy"
		color = RPC_ELEMENT_HOLY_COLOR
	elseif elementCode == RPC_ELEMENT_COSMOS then
		name = "cosmos"
		color = RPC_ELEMENT_COSMOS_COLOR
	elseif elementCode == RPC_ELEMENT_ICE then
		name = "ice"
		color = RPC_ELEMENT_ICE_COLOR
	elseif elementCode == RPC_ELEMENT_ARCANE then
		name = "arcane"
		color = RPC_ELEMENT_ARCANE_COLOR
	elseif elementCode == RPC_ELEMENT_SHADOW then
		name = "shadow"
		color = RPC_ELEMENT_SHADOW_COLOR
	elseif elementCode == RPC_ELEMENT_WIND then
		name = "wind"
		color = RPC_ELEMENT_WIND_COLOR
	elseif elementCode == RPC_ELEMENT_GHOST then
		name = "ghost"
		color = RPC_ELEMENT_GHOST_COLOR
	elseif elementCode == RPC_ELEMENT_WATER then
		name = "water"
		color = RPC_ELEMENT_WATER_COLOR
	elseif elementCode == RPC_ELEMENT_DEMON then
		name = "demon"
		color = RPC_ELEMENT_DEMON_COLOR
	elseif elementCode == RPC_ELEMENT_NATURE then
		name = "nature"
		color = RPC_ELEMENT_NATURE_COLOR
	elseif elementCode == RPC_ELEMENT_UNDEAD then
		name = "undead"
		color = RPC_ELEMENT_UNDEAD_COLOR
	elseif elementCode == RPC_ELEMENT_DRAGON then
		name = "dragon"
		color = RPC_ELEMENT_DRAGON_COLOR
	end
	return name, color
end

function Elements:hex2rgb(hex)
    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end

function Elements:RollElementAttribute(item, element_code, rollMult, minRoll, maxRoll, attributeSlot)
	local luck = RandomInt(0,110)
	local maxFactor = RPCItems:GetMaxFactor()
	local value = 0
	local prefixLevel = 1
	local maxRoll = math.ceil(rollMult*1.5)
	local name, color = Elements:GetElementNameAndColorByCode(element_code)
	value, prefixLevel = RPCItems:RollAttribute(100, minRoll, maxRoll, 0, 0, item.rarity, false, maxFactor*rollMult)
	value = math.floor(value)
	print("[Elements:RollElementAttribute] "..name)
	if attributeSlot == 1 then
		item.newItemTable.property1name = name
		RPCItems:SetPropertyValues(item, value, "#rpc_item_element"..element_code, color,  1)
	elseif attributeSlot == 2 then
		item.newItemTable.property2name = name
		RPCItems:SetPropertyValues(item, value, "#rpc_item_element"..element_code, color,  2)
	elseif attributeSlot == 3 then
		item.newItemTable.property3name = name
		RPCItems:SetPropertyValues(item, value, "#rpc_item_element"..element_code, color,  3)
	elseif attributeSlot == 4 then
		item.newItemTable.property4name = name
		RPCItems:SetPropertyValues(item, value, "#rpc_item_element"..element_code, color,  4)
	end
end