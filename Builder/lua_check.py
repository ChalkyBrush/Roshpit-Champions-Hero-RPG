import os
import re

def get_used_constants_in_file(file_path):
    result = {}
    file = open(file_path, 'r', encoding='utf-8')
    data = file.read()
    data = re.sub('--[^\n]*\n', "\n", data, 0, re.MULTILINE)
    data = re.sub('\".*\"', "", data, 0, re.MULTILINE)
    used_constants = re.findall(r'(?<![a-zA-Z_0-9\.])(([A-Z]+[_0-9]*)+)(?![a-zA-Z_0-9\.])', data)
    for constant in used_constants:
        result[constant[0]] = constant[0]
    return result
def check(file_paths, base_constants,dota_constants, warnings_rules):
    result = base_constants.copy()
    for file_path in file_paths:
        if not os.path.isfile(file_path):
            continue
        constants = get_used_constants_in_file(file_path)
        for constant, value in constants.items():
            if warnings_rules['lua_constant_no_exist'] and constant not in result:
                print('Warning: Constant ' + constant + ' used in ' + file_path + ' but not defined')
            result[constant] = value
    return result