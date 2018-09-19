import io
import re
import json
import os.path

import helpers as b_helper

def npc_to_json(data):
    json_content = data
    json_content = re.sub('//[^\n]*\n', "\n", json_content, 0, re.MULTILINE)
    json_content = re.sub('\\\\\"', "@$#@$!", json_content, 0, re.MULTILINE)
    json_content = re.sub('(?<=\")([^\S\n]+)(".*")', r":\2,", json_content, 0, re.MULTILINE)
    json_content = re.sub('^(\s*".*")(\s+){', r"\1:\2{", json_content, 0, re.MULTILINE)
    json_content = re.sub('(\n\s*".*")(\s+){', r"\1:\2{", json_content, 0, re.MULTILINE)
    json_content = re.sub(',(\s+)}', r"\1}", json_content, 0, re.MULTILINE)
    json_content = re.sub('}(\s+")', r"},\1", json_content, 0, re.MULTILINE)
    json_content = json_content.replace('\\', "\\\\")
    json_content = re.sub("@\$#@\$!", '\\\\\\\\\\"', json_content, 0, re.MULTILINE)
    json_content = "{ " + json_content + " }"
    json_content = re.sub(',(\s+)}', r"\1}", json_content, 0, re.MULTILINE)
    return json.loads(json_content)


def json_to_npc(data):
    npc_content = json.dumps(data, indent=0, ensure_ascii=False)
    npc_content = npc_content[1:-2]
    npc_content = re.sub(',\n', '\n', npc_content, 0, re.MULTILINE)
    npc_content = re.sub('(?<!\\\\)\":[\s]*"', '"\t\t"', npc_content, 0, re.MULTILINE)
    return npc_content

def separate_as_main_lang(lang_suffix_with_extension):
    regex_files_paths = [
        "heroes/.*/localizations/.*english\.txt",
        "items/localizations/.*english\.txt",
        "worlds/.*/localizations/.*english\.txt",
    ]

    other_lang_main_path = "addon/" + lang_suffix_with_extension
    other_lang_addon_content = ''
    other_lang_addon_json_content = {}
    other_lang_excluded = []
    with io.open(other_lang_main_path, encoding='utf-8') as file:
        content = file.read()
        other_lang_addon_content = content
        content = re.sub('##.*?##\n', '', content, 0, re.MULTILINE)
        other_lang_addon_json_content = npc_to_json(content)["lang"]["Tokens"]

    for regex_files_path in regex_files_paths:
        file_paths = b_helper.regex_find_all(regex_files_path, '../Game/scripts/vscripts/')
        for file_path in file_paths:
            with io.open(file_path, encoding='utf-8') as file:
                english_content = file.read()
                english_json_content = npc_to_json(english_content)
                other_lang_file_path = file_path.replace('english.txt', lang_suffix_with_extension)
                other_lang_json_content = {}
                if os.path.exists(other_lang_file_path):
                    with io.open(other_lang_file_path, encoding='utf-8') as other_lang_file:
                        other_lang_content = other_lang_file.read()
                        other_lang_json_content = npc_to_json(other_lang_content)
                for json_key, json_value in english_json_content.items():
                    if json_key in other_lang_json_content and json_key in other_lang_addon_json_content:
                        other_lang_json_content[json_key] = other_lang_addon_json_content[json_key]
                        other_lang_excluded.append(json_key)
                    elif json_key not in other_lang_json_content and json_key in other_lang_addon_json_content:
                        other_lang_json_content[json_key] = other_lang_addon_json_content[json_key]
                        other_lang_excluded.append(json_key)
                    # elif json_key not in other_lang_json_content and json_key not in other_lang_addon_json_content:
                    # print('Warning: key ' + json_key + ' is not translated')
                other_lang_content = english_content
                for json_key, json_value in other_lang_json_content.items():
                    other_lang_content = re.sub('(\"' + json_key + '\"[\s]+\").*\"', r'\g<1>' + json_value + '"', other_lang_content)
                for json_key, json_value in english_json_content.items():
                    if json_key not in other_lang_json_content:
                        other_lang_content = re.sub('[\s]*\"' + json_key + '".*', '', other_lang_content)
                with io.open(other_lang_file_path, 'w', encoding='utf-8') as other_lang_file:
                    other_lang_file.write(other_lang_content)
    with io.open(other_lang_main_path, 'w', encoding='utf-8') as file:
        content = other_lang_addon_content
        for other_lang_exclude_key in other_lang_excluded:
            content = re.sub('[\s]*\"' + other_lang_exclude_key + '".*', '', content, 0)
        file.write(content)


separate_as_main_lang('russian.txt')
separate_as_main_lang('schinese.txt')