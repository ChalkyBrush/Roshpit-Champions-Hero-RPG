import  codecs

import Builder.settings as b_settings
import Builder.helpers as b_helpers
import Builder.constants as b_constants
import Builder.replaces as b_replaces


def replace_in_file(input_file_patch, output_file_path, replaces, output_encoding):
    input_file = open(input_file_patch, 'r', encoding='utf-8')
    output_file = open(output_file_path, 'w', encoding=output_encoding)
    print(output_file_path)
    for line in input_file:
        if replaces.get(line.strip()):
            output_file.write("\n")
            output_file.write(replaces.get(line.strip()))
            output_file.write('\n')
        else:
            output_file.write(line)
    input_file.close()
    output_file.close()


base_settings = b_settings.get_base()['result']

# Fill global constants
global_constants_paths = []
for constant_regex_path in base_settings['constants']:
    constant_paths = b_helpers.regex_find_all(base_settings['base_constants_path'] + constant_regex_path)
    global_constants_paths.extend(constant_paths)
global_constants = b_constants.get(global_constants_paths, {}, base_settings['warnings'])

# Fill global replaces
global_replaces_paths = []

for replace_regex_path in base_settings['replaces']:
    replace_paths = b_helpers.regex_find_all(base_settings['base_replaces_path'] + replace_regex_path)
    global_replaces_paths.extend(replace_paths)

global_replaces = b_replaces.get(global_replaces_paths, global_constants, base_settings['constants_settings'], base_settings['warnings'])

for file, settings in b_settings.get_files_settings().items():
    output_path = base_settings['base_destination_path'] + settings['destination']
    replace_in_file('Builder/' + file, output_path, global_replaces, settings['output_encoding'])
    file = open(output_path, 'r', encoding= settings['output_encoding'])
    content = file.read()
    file.close()
    b_replaces.validate_content(content, output_path, base_settings['warnings'])
