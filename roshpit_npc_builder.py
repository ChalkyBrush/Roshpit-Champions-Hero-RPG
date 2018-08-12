from time import sleep
from time import gmtime, strftime
import os.path
settings = {}
settings['constants'] = {}
settings['parse_groups'] = [
    {
        "template": 'npc_abilities_custom_template.txt',
        "replace": 'npc_abilities_custom_replace.txt',
        "output_file": 'npc_abilities_custom.txt',
        "finish_label": 'abilities done'
    },
    {
        "template": 'npc_items_custom_template.txt',
        "replace": 'npc_items_custom_replace.txt',
        "output_file": 'npc_items_custom.txt',
        "finish_label": 'items done'
    },
    {
        "template": 'npc_units_custom_template.txt',
        "replace": 'npc_units_custom_replace.txt',
        "output_file": 'npc_units_custom.txt',
        "finish_label": 'units done'
    }
]

filesChangeTime = {}
using_files = []


def build():
    global settings
    print('---- build time ' + strftime("%Y-%m-%d %H:%M:%S", gmtime()) + ' ----')
    for parse_group in settings['parse_groups']:
        if not (os.path.isfile(parse_group["template"]) and os.path.isfile(parse_group["replace"])):
            raise Exception("File " + parse_group["template"] + " or file " + parse_group["replace"] + " does not exist")
        local_replace = parse_replaces(parse_group["replace"])
        replace_in_file(parse_group["template"], parse_group["output_file"], local_replace)
        print(parse_group["finish_label"])


def watch():
    global settings
    global using_files
    while True:
        should_rebuild = False
        already_builded = False
        for parse_group in settings['parse_groups']:
            if is_file_changed(parse_group["template"]):
                should_rebuild = True
            if is_file_changed(parse_group["replace"]):
                should_rebuild = True
        if should_rebuild:
            using_files = []
            build()
            already_builded = True
        for file in using_files:
            if is_file_changed(file):
                should_rebuild = True
        if should_rebuild and not already_builded:
            using_files = []
            build()
        sleep(1)


def is_file_changed(path):  # additionally update modification data
    global filesChangeTime
    change_time = os.path.getmtime(path)
    if path not in filesChangeTime:
        filesChangeTime[path] = change_time
        return True
    elif change_time > filesChangeTime[path]:
        filesChangeTime[path] = change_time
        return True
    else:
        return False


def parse_constants(file_path):
    constants = {}
    file = open(file_path, 'r')
    for line in file:
        if '{' in line or '}' in line or 'return ' in line:
            continue
        if 'local ' in line:
            line = line.replace('local ','').strip()
        if ',' in line:
            line = line.replace(',','')
        if '--' in line:
            line = line[:line.index('--')]
        if '=' not in line:
            continue
        temp = line.split('=')
        constants[temp[0].strip()] = temp[1].strip().replace("'", "").replace('"', '')
    return constants


def parse_settings(file_path):
    replaces = {}
    file = open(file_path, 'r')
    for line in file:
        temp = line.split(':')
        replaces[temp[0].strip()] = temp[1].strip()
    file.close()
    return replaces


def parse_replaces(file_path):
    replaces = {}
    current_constants = {}
    file = open(file_path, 'r')
    for line in file:
        if '<%' in line:
            line = line.replace('<% ','').replace(' %>', '').strip()
            using_files.insert(1, settings['base_path'] + line)
            current_constants = parse_constants(settings['base_path'] + line)
            continue
        if ':' not in line:
            continue
        temp = line.split(':')
        addition_file_path = settings['base_path'] + temp[1].strip()
        using_files.insert(1, addition_file_path)
        replaces['##' + temp[0].strip() + '##'] = prepare_file(addition_file_path, current_constants)
    file.close()
    return replaces


def replace_in_file(input_file_patch, output_file_path, replaces):
    input_file = open(input_file_patch, 'r')
    output_file = open(settings['output_path'] + output_file_path, 'w')
    for line in input_file:
        if replaces.get(line.strip()):
            output_file.write(replaces.get(line.strip()))
        else:
            output_file.write(line)
    input_file.close()
    output_file.close()


def prepare_file(file_path, constants):
    file = open(file_path, 'r')
    content = file.read()
    for constant, value in constants.items():
        content = content.replace('<% ' + constant + ' %>', value)
    if '<%' in content:
        constant_name = content[content.index("<%") + 2:content.index("%>")]
        raise Exception("Constants " + constant_name + " in " + file_path + " don't parsed. There should be space after <% and before %>")
    return content


settings.update(parse_settings('builder_settings.txt'))
watch()