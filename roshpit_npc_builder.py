import os.path
settings = {}

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
    file = open(file_path, 'r')
    for line in file:
        temp = line.split(':')
        temp_file = open(settings['base_path'] + temp[1].strip(), 'r')
        replaces['##' + temp[0].strip() + '##'] = temp_file.read()
        temp_file.close()
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

settings = parse_settings('builder_settings.txt')

if os.path.isfile('npc_abilities_custom_template.txt') and os.path.isfile('npc_abilities_custom_replace.txt'):
    abilities_replace = parse_replaces('npc_abilities_custom_replace.txt')
    replace_in_file('npc_abilities_custom_template.txt', 'npc_abilities_custom.txt', abilities_replace)
    print('abilities done')
if os.path.isfile('npc_items_custom_template.txt') and os.path.isfile('npc_items_custom_replace.txt'):
    items_replace = parse_replaces('npc_items_custom_replace.txt')
    replace_in_file('npc_items_custom_template.txt', 'npc_items_custom.txt', items_replace)
    print('items done')
