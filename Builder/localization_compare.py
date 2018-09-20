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


def test_files(new_file_path, old_file_path):
    with io.open(old_file_path, encoding='utf-8-sig') as old_file:
        old_content = old_file.read()
        old_json_content =  npc_to_json(old_content)["lang"]["Tokens"]
        with io.open(new_file_path, encoding='utf-8-sig') as new_file:
            new_content = new_file.read()
            new_json_content =  npc_to_json(new_content)["lang"]["Tokens"]
            for key, value  in old_json_content.items():
                if not key in new_json_content:
                    print('Warning: key ' + key + ' missing in file ' + new_file_path)
                elif new_json_content[key] != value:
                    print('Warning: key ' + key + ' has different values')
                    print('Old value: ' + value)
                    print('New value: ' + new_json_content[key])

test_files('../Game/resource/addon_english.txt', '../Game/resource/addon_english_old.txt')
test_files('../Game/resource/addon_russian.txt', '../Game/resource/addon_russian_old.txt')
test_files('../Game/resource/addon_schinese.txt', '../Game/resource/addon_schinese_old.txt')