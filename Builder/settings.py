#  Builder for Roshpit Champions
#   Settings:
#       constants - global constants:
#
#
data = {
    "constants": [
        "heroes/.*/.*constants.*\.lua"
    ],
    "replaces": [
        "heroes/.*/npc/.*\.txt",
        "heroes/.*/localizations/.*\.txt",
        "worlds/.*/.*\.txt",
        "worlds/.*/localizations/.*\.txt",
    ],
    "output_encoding": "utf-8",
    "base_destination_path": "Game/",
    "base_constants_path": "Game/scripts/vscripts/",
    "base_replaces_path": "Game/scripts/vscripts/",
    "constants_settings": {
        "start": "<%",
        "end": "%>",
        "convert_to": "float_is_possible",
        "expressions": {
            "*": lambda x, y: x * y,
            "/": lambda x, y: x / y,
            "+": lambda x, y: x + y,
            "-": lambda x, y: x - y,
        },
        "expression_result_convert": lambda result: round(result, 2) if type(result) is not str else result,
    },
    "warnings": {
        "constant_rewrite": True,
        "constant_file_empty": True,
        "constant_file_no_exist": True,
        "replace_rewrite": True,
        "replace_file_empty": True,
        "replace_file_no_exist": True,
        "replace_invalid_constant": True,
        "syntax_invalid": True,
    },
    "files": {
        "npc/abilities.txt": "scripts/npc/npc_abilities_custom.txt",
        "npc/items.txt": "scripts/npc/npc_items_custom.txt",
        "npc/units.txt": "scripts/npc/npc_units_custom.txt",
        "addon/english.txt": {
            "destination": "resource/addon_english.txt",
            "output_encoding": "utf-8-sig",
        },
        "addon/russian.txt": {
            "destination": "resource/addon_russian.txt",
            "output_encoding": "utf-8-sig",
        },
        "addon/schinese.txt": {
            "destination": "resource/addon_schinese.txt",
            "output_encoding": "utf-8-sig",
        },
    },
}


def get_files_settings():
    files_settings = {}
    for file_name, settings in data['files'].items():
        file_settings = {}
        if type(settings) == str:
            file_settings['destination'] = settings
            file_settings['output_encoding'] = data['output_encoding']
        else:
            file_settings = settings
        files_settings[file_name] = file_settings
    return files_settings


def get_base():
    return {
        "status": "ok",
        "result": data
    }
