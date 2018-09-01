import json
import os
import re


def get_operator_value(operator, file_path, constants, warnings):
    operator = operator.strip()
    if not operator.isnumeric():
        if operator in constants:
            operator = constants[operator]
        else:
            if warnings['replace_invalid_constant']:
                print("Warning: constant " + operator + " in " + file_path + " don't parsed.")
            operator = "0"
    return operator


def validate_content(content, file_path, warnings):
    for invalid_replace in re.findall('(##.*?##)', content):
        print('Warning: Replace ' + invalid_replace + ' in file' + file_path + ' didn\'nt import')
    json_content = content
    json_content = re.sub('//[^\n]*\n', "\n", json_content, 0, re.MULTILINE)
    json_content = re.sub('\\\\\"', "@$#@$!", json_content, 0, re.MULTILINE)
    json_content = re.sub('(?<=\")([^\S\n]+)(".*")', r":\2,", json_content, 0, re.MULTILINE)
    json_content = re.sub('^(\s*".*")(\s+){', r"\1:\2{", json_content, 0, re.MULTILINE)
    json_content = re.sub('(\n\s*".*")(\s+){', r"\1:\2{", json_content, 0, re.MULTILINE)
    json_content = re.sub(',(\s+)}', r"\1}", json_content, 0, re.MULTILINE)
    json_content = re.sub('}(\s+")', r"},\1", json_content, 0, re.MULTILINE)
    json_content = json_content.replace('\\', "\\\\")
    json_content = re.sub("@\$#@\$!", '\\\\\\\\\\"', json_content, 0, re.MULTILINE)
    try:
        json.loads("{" + json_content + "}")
    except Exception as e:
        if warnings['syntax_invalid']:
            print('Warning: Syntax parse error in ' + file_path)
            print(str(e))


def parse(file_path, constants, settings, warnings, encoding="utf-8"):
    file = open(file_path, 'r', encoding=encoding)
    content = file.read()
    file.close()

    for statement in re.findall('(?<=' + re.escape(settings['start']) + ')(.*?)(?=' + re.escape(settings['end']) + ')', content):
        statement_parts = re.split('(' + ''.join(map(lambda x: re.escape(x), settings['expressions'].keys())) + ')', statement)
        result = settings['convert'](get_operator_value(statement_parts[0], file_path, constants, warnings))
        i = 1
        while i < len(statement_parts):
            operation = statement_parts[i]
            second_operator = settings['convert'](get_operator_value(statement_parts[i + 1], file_path, constants, warnings))
            result = settings['expressions'][operation](result, second_operator)
            i = i + 2

        result = settings['expression_result_convert'](result)
        if result == int(float(result)):
            result = int(result)
        content = content.replace(settings['start'] + statement + settings['end'], str(result))
    validate_content(content, file_path, warnings)
    return content


def get(file_paths, constants, settings, warnings_rules):
    result = {}
    for file_path in file_paths:
        if not os.path.isfile(file_path):
            if warnings_rules['replace_file_no_exist']:
                print('Warning: File ' + file_path + ' doesn\'t exist.')
            continue
        if os.path.getsize(file_path) <= 0:
            if warnings_rules['replace_file_empty']:
                print('Warning: File ' + file_path + ' empty.')
            continue
        replace = parse(file_path, constants, settings, warnings_rules)
        replace_name = '##' + os.path.splitext(os.path.basename(file_path))[0].upper() + '##'
        if warnings_rules['replace_rewrite'] and replace_name in result:
            print('Warning: Replace ' + replace_name + ' rewrote from ' + file_path)
        result[replace_name] = replace
    return result
