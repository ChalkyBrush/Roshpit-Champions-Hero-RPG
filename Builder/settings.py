import json
from pathlib import Path
from typing import Dict, List, Optional, Any
from sys import exit

from Builder.messages import MsgType, print_msg


class SettingsManager:
    '''Class used to store and give access to Builder's settings'''

    def __init__(self, file_path: str):
        self._data = {}
        self.file = Path(file_path)

    def get_pattern(self, pattern_name: str) -> Optional[str]:
        settings = self._data['patterns'][pattern_name]
        try:
            regex = f"{settings['start']}(.+?){settings['end']}"
            return regex
        except KeyError:
            print_msg(f'Pattern "{pattern_name}" should have "start" and "end" properties', MsgType.ERROR)
            exit()

    def get_pattern_misc(self, pattern_name: str, key: str) -> Optional[Any]:
        settings = self._data['patterns'][pattern_name]
        try:
            return settings[key]
        except KeyError:
            print_msg(f'Pattern "{pattern_name}" doesn\'t have "{key}" property', MsgType.ERROR)
            exit()

    def get_paths(self, key: str) -> List[Path]:
        settings = self._data['paths'][key]
        base_path = settings['base_path']
        patterns = settings['file_patterns']
        result = []
        for pattern in patterns:
            result.extend(Path(base_path).glob(pattern))
        return result

    def get_flag(self, key: str) -> bool:
        return self._data['flags'].get(key)

    def get_update_interval(self) -> float:
        return self._data['general']['update_interval']

    def get_files(self):
        settings = self._data['output']
        base_path = Path(settings['base_path'])

        for src_path, dst_path in settings['files'].items():
            source = Path('Builder') / Path(src_path)
            try:
                destination = base_path / Path(dst_path['destination'])
                encoding = dst_path['encoding']
            except TypeError:
                destination = base_path / Path(dst_path)
                encoding = settings['default_encoding']

            yield source, destination, encoding

    def update(self, path: Optional[Path] = None) -> None:
        if not path:
            path = self.file
        try:
            with path.open('r', encoding='utf-8') as file:
                data = json.load(file)
            if key_not_found := self._scan_keys(data):
                print_msg(f'Invalid settings file: missing property "{key_not_found}"', MsgType.ERROR)
            else:
                self._data = data
                self.file = path
        except FileNotFoundError:
            print_msg(f'Settings file "{Path.cwd() / path}" not found', MsgType.ERROR)
        except json.decoder.JSONDecodeError:
            print_msg(f'Unable to parse JSON "{path}"', MsgType.ERROR)


    def _scan_keys(self, data: Dict) -> Optional[str]:
        # shallow validation
        required_keys = (
            'general',
            'flags',
            'paths',
            'patterns',
            'output',
        )
        for key in required_keys:
            if key not in data:
                return key
        return None