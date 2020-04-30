import os
import io
import re

localization_directories = [
	r"Game\resource\addon_english.txt",
]

npc_keyvalues_directories = [
	r"Game\scripts\npc\npc_items_custom.txt"
]


class LocalizationData:
	"""Glyph object, parsed data from localization and npc files."""
	GlyphItemName = ""
	GlyphPosition = ""
	TooltipName = ""
	TooltipLabel = ""
	TooltipFull = ""
	DescriptionKey = ""
	DescriptionValue = ""
	DescriptionFull = ""
	KeyValuesAbilitySpecialText = ""
	KeyValuesDataFull = ""

	def __init__(self, glyph_special_data_dict):
		self.keyvalues_special = glyph_special_data_dict

	def __repr__(self):
		return f"Glyph obj:\n" \
			   f"[[GlyphItemName:{self.GlyphItemName}]] \n" \
			   f"[[GlyphPosition:{self.GlyphPosition}]] \n" \
			   f"[[TooltipName:{self.TooltipName}]] \n" \
			   f"[[TooltipLabel:{self.TooltipLabel}]] \n" \
			   f"[[TooltipFull:{self.TooltipFull}]] \n" \
			   f"[[DescriptionKey:{self.DescriptionKey}]] \n" \
			   f"[[DescriptionValue:{self.DescriptionValue}]] \n" \
			   f"[[DescriptionFull:{self.DescriptionFull}]] \n" \
			   f"[[KeyValuesAbilitySpecialText:{self.KeyValuesAbilitySpecialText}]] \n" \
			   f"[[KeyValuesDataFull:{self.KeyValuesDataFull}]] \n" \
			   f"\n"

	def __str__(self):
		return f"Glyph obj:\n" \
			   f"[[GlyphItemName:{self.GlyphItemName}]] \n" \
			   f"[[GlyphPosition:{self.GlyphPosition}]] \n" \
			   f"[[TooltipName:{self.TooltipName}]] \n" \
			   f"[[TooltipLabel:{self.TooltipLabel}]] \n" \
			   f"[[TooltipFull:{self.TooltipFull}]] \n" \
			   f"[[DescriptionKey:{self.DescriptionKey}]] \n" \
			   f"[[DescriptionValue:{self.DescriptionValue}]] \n" \
			   f"[[DescriptionFull:{self.DescriptionFull}]] \n" \
			   f"[[KeyValuesAbilitySpecialText:{self.KeyValuesAbilitySpecialText}]] \n" \
			   f"[[KeyValuesDataFull:{self.KeyValuesDataFull}]] \n" \
			   f"\n"


def parse_localization_files(file_path):
	"""
	Parsing localization files.\n
	:param file_path: Path to source file.
	:return: Dictionary with parsed objects.
	"""
	print(f'[parse_localization_files] {file_path}')

	# Glyph objects, key is glyph position, example '_glyph_6_2'
	glyph_objects = {}

	with io.open(file_path, encoding='utf-8') as resFile:
		file_lines = resFile.readlines()
		for i, line in enumerate(file_lines, 1):

			glyph_position = ""

			# Regex to search key name in dict of glyph objects.
			match = re.search('[A-Za-z]*_glyph_\w_\w', line)
			if match:
				# Setting key name and also some adjustments to the string.
				glyph_position = match[0]
			else:
				continue

			# Glyph searching pattern.
			match_tooltip = re.search('DOTA_Tooltip_ability_item_rpc_\S*_glyph_\S*_\S*"', line)
			if match_tooltip:
				result_line = match_tooltip[0].lstrip().rstrip().replace('"', '')
				print(f'Glyph tooltip found: \"{result_line}\"')

				# Glyph object
				if glyph_position in glyph_objects:
					glyph_objects[glyph_position].GlyphPosition = glyph_position
					glyph_objects[glyph_position].TooltipLabel = result_line
					glyph_objects[glyph_position].TooltipFull = line.lstrip().rstrip()
					result_obj.TooltipName = result_obj.TooltipFull.replace(result_obj.TooltipLabel, '').replace('\t', '').replace('\"', '').lstrip().rstrip()
				else:
					result_obj = LocalizationData({})
					result_obj.GlyphPosition = glyph_position
					result_obj.TooltipLabel = result_line
					result_obj.TooltipFull = line.lstrip().rstrip()
					result_obj.TooltipName = result_obj.TooltipFull.replace(result_obj.TooltipLabel, '').replace('\t', '').replace('\"', '').lstrip().rstrip()
					glyph_objects[glyph_position] = result_obj

			match_description = re.search('item_rpc_\S*_glyph_\S*_\S*_description', line)
			if match_description:
				result_line = match_description[0].lstrip().rstrip().replace('"', '')
				description_full = line.lstrip().rstrip()
				print(f'Glyph description found: \"{result_line}\"')
				item_name_found = result_line.replace('_description', '')

				# Glyph object
				if glyph_position in glyph_objects:
					glyph_objects[glyph_position].GlyphPosition = glyph_position
					glyph_objects[glyph_position].DescriptionFull = description_full
				else:
					result_obj = LocalizationData({})
					result_obj.GlyphPosition = glyph_position
					result_obj.DescriptionFull = description_full
					glyph_objects[glyph_position] = result_obj

				if glyph_objects[glyph_position].DescriptionFull:
					text0, text1 = parse_key_values(glyph_objects[glyph_position].DescriptionFull)
					glyph_objects[glyph_position].DescriptionKey = text0
					glyph_objects[glyph_position].DescriptionValue = text1
					glyph_objects[glyph_position].GlyphItemName = item_name_found
	return glyph_objects


def parse_key_values(text):
	"""Parse localization file lines to kv.\n
	:param text: Source text.
	:return: Parsed key and value.
	"""
	text_regex = re.split('\"\s*\"', text)
	if text_regex and len(text_regex) >= 2:
		text0 = text_regex[0].lstrip().rstrip()
		text0 = re.sub(r'^"|"$', '', text0)
		text1 = text_regex[1].lstrip().rstrip()
		text1 = re.sub(r'^"|"$', '', text1)
		return text0, text1


def parse_keyvalues_data(file_path):
	"""Parsing kv files.
	:param file_path: Path to source file.
	:return: Dictionary with parsed objects.
	"""
	print(f'[parse_keyvalues_data] {file_path}')

	# Glyph objects, key example 'item_rpc_omniro_glyph_1_1'
	glyph_objects = {}

	with io.open(file_path, encoding='utf-8') as resFile:
		file_lines = resFile.readlines()

		keyvalues_name = ""
		keyvalues_full_text = ""
		braces_amount = 0
		recording_data = False

		for i, line in enumerate(file_lines, 1):

			match = re.search('\"item_rpc_\S*_glyph_\S*\"', line)

			if match and not recording_data:
				# no glyph books needed
				if 'book' in match[0]:
					continue

				keyvalues_name = match[0]
				print(match[0])
				recording_data = True
				braces_amount = 0
				keyvalues_full_text += f'{line}'
				continue

			if recording_data:
				keyvalues_full_text += f'{line}'

				braces_opening_in_line = line.count('{')
				braces_ending_in_line = line.count('}')

				if braces_opening_in_line > 0:
					braces_amount += braces_opening_in_line
				if braces_ending_in_line > 0:
					braces_amount -= braces_ending_in_line

				if braces_amount == 0:
					recording_data = False
					glyph_objects[keyvalues_name] = keyvalues_full_text
					keyvalues_name = ""
					keyvalues_full_text = ""

	return glyph_objects


def parse_keyvalues_special_full_text(glyph_object_data):
	"""Parse full kv text for keyvalues text.\n
	:param glyph_object_data: Target objects.
	"""
	ability_special_recording = False
	ability_special_full_text = ""
	braces_amount = 0

	for key, value in glyph_object_data.items():
		if not value.KeyValuesDataFull:
			print(f'KV not found: {key}')
			continue

		kv_list = value.KeyValuesDataFull.split()
		for i, line in enumerate(kv_list, 1):
			if 'AbilitySpecial' in line and not ability_special_recording:
				ability_special_recording = True
				ability_special_full_text = ""
				braces_amount = 0
				continue
			if ability_special_recording:
				ability_special_full_text += f'{line}'

				braces_opening_in_line = line.count('{')
				braces_ending_in_line = line.count('}')

				if braces_opening_in_line > 0:
					braces_amount += braces_opening_in_line
				if braces_ending_in_line > 0:
					braces_amount -= braces_ending_in_line

				if braces_amount == 0:
					ability_special_recording = False
					value.KeyValuesAbilitySpecialText = ability_special_full_text


def find_matches_between_localization_and_keyvalues():
	"""Putting kv data in glyph obj dictionary.\n
	"""
	for key, value in glyph_keyvalues_data.items():
		if not key or not value:
			print(f'KV MISSING: {key}\n{value}')
		else:
			print(f'KV OK: {key}\n{value}')

		for keyy, valuee in glyph_object_data.items():
			if keyy in key:
				valuee.KeyValuesDataFull = glyph_keyvalues_data[key]
				continue


# Parse kv special.
def parse_keyvalues_special_to_list(glyph_object_data):
	"""Parsing kv special text to list of special kv's.\n
	:param glyph_object_data: Target objects.
	"""
	for key, value in glyph_object_data.items():
		objTarget = value

		# if 'item_rpc_jex_glyph_7_1' in objTarget.GlyphItemName:
		# 	print()

		if not hasattr(objTarget, 'KeyValuesAbilitySpecialText'):
			continue

		objKeyvaluesSpecialFullText = objTarget.KeyValuesAbilitySpecialText
		objKeyvaluesSpecialFullText = objKeyvaluesSpecialFullText.replace('\n', '').replace('\t', '').lstrip().rstrip()

		special_value_index = re.findall('"\d*"{"\w*""\w*""\w*""[\w\-+.,]*"}', objKeyvaluesSpecialFullText)
		for index_special, line_special in enumerate(special_value_index, 1):
			special_index_regex = re.search('"\d*"{', line_special)
			if not special_value_index:
				print(f'Can\'t find special index for: {key}')
				continue

			special_index_found = special_index_regex[0].replace('{', '')
			special_index_found = re.sub(r'^"|"$', '', special_index_found)
			special_index_int = int(special_index_found)

			special_keyvalues_text = re.sub('"\d*"{', '', line_special).replace('{', '').replace('}', '')
			special_keyvalues_trimmed = special_keyvalues_text.split('\"')
			special_keyvalues_trimmed = [num for num in special_keyvalues_trimmed if len(num) != 0]
			if special_keyvalues_trimmed.__len__() >= 2 and not (
					'var_type' in special_keyvalues_trimmed[0] or 'var_type' in special_keyvalues_trimmed[1]):
				if special_index_int in glyph_object_data[key].keyvalues_special:
					print(f'Key already exist! {key}')
				glyph_object_data[key].keyvalues_special[special_index_int] = {
					special_keyvalues_trimmed[0]: special_keyvalues_trimmed[1]}
			if special_keyvalues_trimmed.__len__() >= 4 and not (
					'var_type' in special_keyvalues_trimmed[2] or 'var_type' in special_keyvalues_trimmed[3]):
				if special_index_int in glyph_object_data[key].keyvalues_special:
					print(f'Key already exist! {key}')
				glyph_object_data[key].keyvalues_special[special_index_int] = {
					special_keyvalues_trimmed[2]: special_keyvalues_trimmed[3]}


def do_job(glyph_object_data):
	"""What we doing with final data.
	:param glyph_object_data: Target objects.
	"""
	for key, value in glyph_object_data.items():
		write_ruby_commands(value)


def fix_describtion(glyph_obj):
	"""We have hardcoded describtions translators in js, getting rid of it.\n
	:param glyph_obj: Target objects.
	:return:Fixed item string.
	"""
	fixed_descr = glyph_obj.DescriptionValue[:]
	for key, value in glyph_obj.keyvalues_special.items():
		for keyy, valuee in value.items():
			searching_key = keyy[:]
			# if '@' in fixed_descr:
			# 	print(f"Item has property in description. {glyph_obj.GlyphItemName}")
			if searching_key == "property_one":
				searching_key = "@glyph_property1"
			if searching_key == "property_two":
				searching_key = "@glyph_property2"
			if searching_key == "property_three":
				searching_key = "@glyph_property3"
			if searching_key == "property_four":
				searching_key = "@glyph_property4"
			if searching_key in fixed_descr:
				fixed_descr = fixed_descr.replace(f'{searching_key}', f'{valuee}')
			if 'item_rpc_jex_glyph_7_1' in glyph_obj.GlyphItemName:
				print()
	fixed_descr = fixed_descr.replace('@Ability1', '[Q]').replace('@Ability2', '[W]').replace('@Ability3', '[E]').replace('@Ability4', '[R]')
	return fixed_descr


def write_ruby_commands(glyph_obj):
	"""Writing ruby commands in template.\n
	:param glyph_obj: Target object.
	:return: Command ready to execute in ruby console.
	"""
	result.append(f'glyph = nil')

	one_glyph_name = glyph_obj.GlyphItemName
	result.append(f'glyph = Roshpititem.where(roshpit_item_name: \"{one_glyph_name}\").first')

	two_glyph_name = glyph_obj.TooltipName
	result.append(f'glyph.item_name_en = \"{two_glyph_name}\"')

	fixed_describtion = fix_describtion(glyph_obj)
	three_glyph_name = fixed_describtion
	result.append(f'glyph.description_en = \"{three_glyph_name}\"')

	result.append(f'glyph.save!')


def check_for_errors(glyph_object_data):
	print(f'[check_for_errors] Start!')
	for key, value in glyph_object_data.items():
		if not value.GlyphItemName:
			print(f'{key} Error GlyphItemName')
		if not value.GlyphPosition:
			print(f'{key} Error GlyphPosition')
		if not value.TooltipName:
			print(f'{key} Error TooltipName')
		if not value.TooltipLabel:
			print(f'{key} Error TooltipLabel')
		if not value.TooltipFull:
			print(f'{key} Error TooltipFull')
		if not value.DescriptionKey:
			print(f'{key} Error DescriptionKey')
		if not value.DescriptionValue:
			print(f'{key} Error DescriptionValue')
		if not value.DescriptionFull:
			print(f'{key} Error DescriptionFull')
		if not value.KeyValuesAbilitySpecialText and 'AbilitySpecial' in value.KeyValuesDataFull:
			print(f'{key} Error KeyValuesAbilitySpecialText')
		if not value.KeyValuesDataFull:
			print(f'{key} Error KeyValuesDataFull')
	print(f'[check_for_errors] End!')




# Parse localization files.
glyph_object_data = parse_localization_files(localization_directories[0])

# Parse kv files.
glyph_keyvalues_data = parse_keyvalues_data(npc_keyvalues_directories[0])

# KV data comes into correct glyph object.
find_matches_between_localization_and_keyvalues()

# Parsing kv for ability special block.
parse_keyvalues_special_full_text(glyph_object_data)

# Parsing kv special text to list of kv's
parse_keyvalues_special_to_list(glyph_object_data)

# Preparing array to write.
result = []

# Findal stage, writing ruby templates.
do_job(glyph_object_data)

file_name = 'rpc_glyph_parse_result.rb'
f = open(file_name, "a+")
for i in range(result.__len__()):
	f.write(f'{result[i]}\n')

check_for_errors(glyph_object_data)

print("Done!")