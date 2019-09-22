import os
import re


def parse(file_path):
    result = {}
    file = open(file_path, 'r', encoding='utf-8')
    for line in file:
        if 'return ' in line:
            continue
        if ('{' in line and not '}' in line) or ('}' in line and not '{' in line):
            continue
        if ';' in line:
            line = line.replace(';', '').strip()
        if 'local ' in line:
            line = line.replace('local ', '').strip()
        if ',' in line:
            line = line.replace(',', '')
        if '--' in line:
            line = line[:line.index('--')]
        if '=' not in line:
            continue
        if '{' in line and '}' in line:
            line =  re.sub('\s*,\s*', ' ', line, 0, re.MULTILINE)
            line = line.replace('{', '')
            line = line.replace('}', '')
        temp = line.split('=')
        value = temp[1].strip().replace("'", "").replace('"', '')
        key = temp[0].strip()
        result[key] = value
    return result


def get(file_paths, base_constants, warnings_rules):
    result = base_constants.copy()
    for file_path in file_paths:
        if not os.path.isfile(file_path):
            if warnings_rules['constant_file_no_exist']:
                print('Warning: File ' + file_path + ' doesn\' exist.')
            continue
        if os.path.getsize(file_path) <= 0:
            if warnings_rules['constant_file_empty']:
                print('Warning: File ' + file_path + ' empty.')
            continue
        constants = parse(file_path)
        for constant, value in constants.items():
            if warnings_rules['constant_rewrite'] and constant in result:
                print('Warning: Constant ' + constant + ' rewrote from ' + file_path)
            result[constant] = value
    return result
