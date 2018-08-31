from time import gmtime, strftime, sleep

import os

import Builder.constants as b_constants
import Builder.helpers as b_helpers
import Builder.replaces as b_replaces
import Builder.settings as b_settings


def replace_in_file(input_file_patch, output_file_path, replaces, output_encoding):
    input_file = open(input_file_patch, 'r', encoding='utf-8')
    output_file = open(output_file_path, 'w', encoding=output_encoding)
    for line in input_file:
        if replaces.get(line.strip()):
            output_file.write("\n")
            output_file.write(replaces.get(line.strip()))
            output_file.write('\n')
        else:
            output_file.write(line)
    input_file.close()
    output_file.close()


def build(global_replaces_paths, global_constants_paths, base_settings):
    print('---- build start ' + strftime("%Y-%m-%d %H:%M:%S", gmtime()) + ' ----')
    global_constants = b_constants.get(global_constants_paths, {}, base_settings['warnings'])
    global_replaces = b_replaces.get(global_replaces_paths, global_constants,
                                             base_settings['constants_settings'], base_settings['warnings'])
    for file, settings in b_settings.get_files_settings().items():
        output_path = base_settings['base_destination_path'] + settings['destination']
        replace_in_file('Builder/' + file, output_path, global_replaces, settings['output_encoding'])
        content = b_replaces.parse(output_path, global_constants, base_settings['constants_settings'],
                                   base_settings['warnings'], settings['output_encoding'])
        file = open(output_path, 'w', encoding=settings['output_encoding'])
        file.write(content)
        file.close()
        b_replaces.validate_content(content, output_path, base_settings['warnings'])
    print('---- build finish ' + strftime("%Y-%m-%d %H:%M:%S", gmtime()) + ' ----')


def watch():
    counter = 0
    files_change_time = {}
    base_settings = {}
    global_constants_paths = []
    global_replaces_paths = []
    while True:
        should_rebuild = False
        if counter % 30 == 0:
            base_settings = b_settings.get_base()['result']
            # Fill global constants
            global_constants_paths = []
            for constant_regex_path in base_settings['constants']:
                constant_paths = b_helpers.regex_find_all(base_settings['base_constants_path'] + constant_regex_path)
                global_constants_paths.extend(constant_paths)
            # Fill global replaces
            global_replaces_paths = []
            for replace_regex_path in base_settings['replaces']:
                replace_paths = b_helpers.regex_find_all(base_settings['base_replaces_path'] + replace_regex_path)
                global_replaces_paths.extend(replace_paths)

        for path in global_constants_paths:
            change_time = os.path.getmtime(path)
            if path not in files_change_time:
                should_rebuild = True
            elif files_change_time[path] < change_time:
                should_rebuild = True
            if should_rebuild:
                files_change_time[path] = change_time
        for path in global_replaces_paths:
            change_time = os.path.getmtime(path)
            if path not in files_change_time:
                should_rebuild = True
            elif files_change_time[path] < change_time:
                should_rebuild = True
            if should_rebuild:
                files_change_time[path] = change_time
        for path in global_replaces_paths:
            change_time = os.path.getmtime(path)
            if path not in files_change_time:
                should_rebuild = True
            elif files_change_time[path] < change_time:
                should_rebuild = True
            if should_rebuild:
                files_change_time[path] = change_time
        for path in b_settings.get_files_settings().keys():
            path = 'Builder/' + path
            change_time = os.path.getmtime(path)
            if path not in files_change_time:
                should_rebuild = True
            elif files_change_time[path] < change_time:
                should_rebuild = True
            if should_rebuild:
                files_change_time[path] = change_time

        if should_rebuild:
            build(global_replaces_paths, global_constants_paths, base_settings)
        sleep(1)


watch()
