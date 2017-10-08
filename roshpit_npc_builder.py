import os.path
settings = {}
settings['constants'] = {}

def parse_constants(file_path):
    constants = {}
    file = open(file_path, 'r')
    for line in file:
        if '=' not in line:
            continue
        if '--' in line:
            continue
        temp = line.split('=')
        constants[temp[0].strip()] = temp[1].strip().replace("'","").replace('"', '')
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
            line = line.replace('<% ','').replace(' %>','').strip()
            current_constants = parse_constants(settings['base_path'] + line)
            continue
        temp = line.split(':')
        addition_file_path = settings['base_path'] + temp[1].strip()
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
        raise Exception("seems that some constants in " + file_path + " don't parsed. There should be space after <% and before %>")
    return content

settings = parse_settings('builder_settings.txt')

if os.path.isfile('npc_abilities_custom_template.txt') and os.path.isfile('npc_abilities_custom_replace.txt'):
    abilities_replace = parse_replaces('npc_abilities_custom_replace.txt')
    replace_in_file('npc_abilities_custom_template.txt', 'npc_abilities_custom.txt', abilities_replace)
    print('abilities done')
if os.path.isfile('npc_items_custom_template.txt') and os.path.isfile('npc_items_custom_replace.txt'):
    items_replace = parse_replaces('npc_items_custom_replace.txt')
    replace_in_file('npc_items_custom_template.txt', 'npc_items_custom.txt', items_replace)
    print('items done')
if os.path.isfile('npc_units_custom_template.txt') and os.path.isfile('npc_units_custom_replace.txt'):
    units_replace = parse_replaces('npc_units_custom_replace.txt')
    replace_in_file('npc_units_custom_template.txt', 'npc_units_custom.txt', units_replace)
    print('units done')
