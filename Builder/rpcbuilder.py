import re
from copy import copy
from pathlib import Path
from time import sleep, time
from typing import Match, List, Optional, Dict, NoReturn

from Builder.lua_classes import *
from Builder.settings import SettingsManager
from Builder.messages import MsgType, print_msg
from Builder.kv2json import kv2json


class RPCBuilder:
    """Class used for assembling npc/localization files"""
    operators = {
        '+': lambda x, y: x + y,
        '-': lambda x, y: x - y,
        '*': lambda x, y: x * y,
        '/': lambda x, y: x / y,
    }
    operators_regex = ''.join(re.escape(x) for x in operators.keys())
    operators_regex = f'([{operators_regex}])'
    operators_regex = re.compile(operators_regex)

    def __init__(self, file_path: str) -> None:
        """Inits RPCBuilder class with settings loaded from file (.json format)"""
        self._settings = SettingsManager(file_path)
        self._constants = {}
        self._replacement_map = {}
        self._file_stats = {}

    def build(self) -> None:
        """Assemble all files and write on disk"""
        file_stats = self._file_stats
        settings = self._settings
        file_stats.clear()
        settings.update()
        start = time()
        print_msg('Building...', MsgType.INFO)

        file_stats[settings.file] = settings.file.stat().st_mtime
        self._load_constants()
        self._load_replacements()
        for source, destination, encoding in self._settings.get_files():
            #start_file = time()
            file_stats[source] = source.stat().st_mtime
            self._build_file(source, destination, encoding)
            print_msg(f'Finished building "{destination}"', MsgType.INFO)
        end = time() - start
        print_msg(f'Done! Time elapsed {end:.3f}s\n{"-"*64}', MsgType.INFO)

    def watch(self) -> NoReturn:
        """Build and then begin monitoring source files' modification time.
        Rebuild if any of the files has changed or new file(s) found"""

        settings = self._settings
        file_stats = self._file_stats

        should_rebuild = True
        while 1:
            if should_rebuild:
                self.build()
                should_rebuild = False

            sleep(settings.get_update_interval())
            # check if file records has changed
            paths = [settings.file]
            paths += settings.get_paths('constants')
            paths += settings.get_paths('replacements')
            paths += [path for path, _, _ in settings.get_files()]
            if list(file_stats.keys()) != paths:
                should_rebuild = True
                continue
            # check if mtime of any of recorded files has changed
            for file, mtime in file_stats.items():
                if file.stat().st_mtime != mtime:
                    should_rebuild = True
                    break

    def _build_file(self, source: Path, destination: Path, encoding: str) -> None:
        # build npc/localization file
        settings = self._settings
        with source.open('r', encoding='utf-8') as src, destination.open('w', encoding=encoding) as dst:
            content = src.read()
            # replace all '##FILENAME##' with the contents of the files
            regex = settings.get_pattern('file')
            content = re.sub(regex, self._unwrap_file, content, flags=re.MULTILINE)
            # calculate and replace all <% CONST_EXPRESSION %>
            regex = settings.get_pattern('constant')
            color = settings.get_pattern_misc('constant', 'color') if 'addon' in src.name else None
            content = re.sub(regex, lambda match: self._resolve_expression(match, color), content)
            # color all strings enclosed in <RAINBOW> tag
            regex = settings.get_pattern('rainbow')
            colors = settings.get_pattern_misc('rainbow', 'colors')
            content = re.sub(regex, lambda match: self._process_colors(match, colors), content)
            # resolve color constants in <font> tags
            regex = settings.get_pattern('font')
            content = re.sub(regex, self._process_colors, content)
            dst.write(content)

    def _parse_constants(self, path: Path) -> Dict[str, LuaConstant]:
        # parses file and returns dictionary {'CONST_NAME': LuaConstant, ...}
        result = {}
        with path.open('r', encoding='utf-8') as file:
            for line in file:
                if line.startswith('--') or '=' not in line:
                    continue
                if '--' in line:
                    line = line[:line.index('--')]

                key, value = (x.strip() for x in line.split('='))
                # ignore illegal names and values
                if re.match(r'\w+$', key) and (parsed := try_parse(value)):
                    result[key] = parsed
                    self._validate_const(key, parsed)
        return result

    def _validate_const(self, name: str, const: LuaConstant) -> bool:
        try:
            if type(const) == LuaTable and type(const[0]) == LuaNumber:
                # detect typos like      ↓
                # {1000, 2000, 3000, 40000, 5000}
                cmp = None
                cmp_name = ''
                index = -1
                for i in range(len(const) - 1):
                    if not cmp:
                        if const[i] > const[i+1]:
                            cmp = lambda x, y: y <= x
                            cmp_name = 'lesser'
                        elif const[i] < const[i+1]:
                            cmp = lambda x, y: y >= x
                            cmp_name = 'greater'
                    elif not cmp(const[i], const[i+1]):
                        print_msg(f'Inconsistency detected!\n{name} = {const}\nValue at position [{i+2}] ({const[i+1]}) is expected to be {cmp_name} than or equal to the previous value ({const[i]})', MsgType.WARNING)
                        return False
            elif type(const) == LuaString:
                # check if string constant is color
                if "COLOR" in name and re.match(r"#[\dA-Fa-f]{6}", const):
                    self._constants['colors'][name] = const
                return True
        except Exception as e:
            # just in case we get IndexError or smth
            print_msg(f'Oopsie\n{e}', MsgType.ERROR)
        
        return True
    
    def _load_constants(self) -> None:
        # creates dictionary {'CONST_NAME': LuaConstant, ...}
        settings = self._settings
        paths = settings.get_paths('constants')
        overwrite = settings.get_flag('overwrite_constants')
        result = {'colors': {}}
        self._constants = result
        for path in paths:
            self._file_stats[path] = path.stat().st_mtime
            temp = self._parse_constants(path)
            for key in temp:
                if key not in result:
                    result[key] = temp[key]
                elif overwrite:
                    print_msg(f'Constant {key} was overwritten {result[key]} -> {temp[key]}\nsource:"{path}"', MsgType.WARNING)
                    result[key] = temp[key]
                else:
                    print_msg(f'Duplicate constant definition for {key}:\nsource:"{path}"', MsgType.WARNING)

    def _load_replacements(self) -> None:
        # creates dictionary {'FILE_NAME': Path, ...}
        settings = self._settings
        paths = settings.get_paths('replacements')
        overwrite = settings.get_flag('overwrite_replacements')
        result = {}
        for path in paths:
            self._file_stats[path] = path.stat().st_mtime
            key = path.stem.upper()
            if key not in result:
                result[key] = path
            elif overwrite:
                print_msg(f'File entry for {key} was overwritten:\nold:"{result[key]}"\nnew:"{path}"', MsgType.WARNING)
                result[key] = path
            else:
                print_msg(f'Duplicate file entry for {key}:\nhave:"{result[key]}"\nfound:"{path}"', MsgType.WARNING)

        self._replacement_map = result

    def _unwrap_file(self, match: Match) -> str:
        # converts 'FILE_NAME' into the contents of the respective file
        settings = self._settings
        file_name = match.group(1)
        try:
            file_path = self._replacement_map[file_name]
        except KeyError:
            print_msg(f'No file entry for {file_name}', MsgType.ERROR)
            print_msg(f'Skipping {file_name}', MsgType.WARNING)
            return ''

        if settings.get_flag('empty_warning') and file_path.stat().st_size == 0:
            print_msg(f'File "{file_path}" is empty', MsgType.WARNING)
            return ''

        with file_path.open('r', encoding='utf-8') as file:
            content = file.read()
            try:
                kv2json(content)
            except Exception as e:
                print_msg(f'Could not convert KeyValues to JSON: {file_path}\n{e}', MsgType.ERROR)
                print_msg(f'Skipping {file_name}', MsgType.WARNING)
                return ''
            return f'\n{content}'

    def _resolve_expression(self, match: Match, color: Optional[str] = None) -> str:
        # parses and calculates expression
        statement = match.group(1)
        statement_parts = [x.strip() for x in self.operators_regex.split(statement)]
        # parse strings into values assuming that
        # all parts with even index are operands
        operands = []
        for operand in statement_parts[0::2]:
            if const := self._constants.get(operand):
                operands.append(const)
            else:
                try:
                    number = float(operand)
                    operands.append(number)
                except ValueError:
                    print_msg(f'{match.group()} returned ZERO', MsgType.WARNING)
                    print_msg(f'Constant {operand} not defined', MsgType.ERROR)
                    return '0'
        # calculate result assuming that all
        # parts with odd index are operators
        result = copy(operands[0])
        for i, op in enumerate(statement_parts[1::2]):
            result = self.operators[op](result, operands[i + 1])
        # add font color if necessary
        if type(result) == LuaNumber and color:
            return f"<font color='{color}'>{result.to_string()}</font>"

        return result.to_string()

    def _process_colors(self, match: Match, colors: Optional[List[str]] = None) -> str:
        # colors text char by char or resolves constants in <font> tags
        if colors:
            text = match.group(1)
            result = []
            index = 0
            for char in text:
                result.append(f'<font color=\\"{colors[index]}\\">{char}</font>')
                index = (index + 1) % len(colors)
            return ''.join(result)
        # if colors were not specified then it's <font> tag
        result = match.group(0)
        attributes = match.group(1).strip()
        if "color" not in attributes:
            # ignore if it doesn't need coloring
            return match.group(0)
                  
        pattern = self._settings.get_pattern_misc('font', 'color_attribute')
        color_attribute = re.search(pattern, attributes)
        if not color_attribute:
            # ignore if color attribute uses literal value
            return result
        
        const = color_attribute.group(1)
        color = self._constants['colors'].get(const)
        if not color:
            # if color was not found immediately then it's partial name
            keywords = const.split('_')
            for const_name, const_value in self._constants['colors'].items():
                found = True
                for keyword in keywords:
                    start = const_name.find(keyword)
                    end = start + len(keyword)
                    if start == -1 or \
                       not (start == 0 or const_name[start-1] == '_') or \
                       not (end == len(const_name) or const_name[end] == '_'):
                        found = False
                        break
                        
                if found:
                    color = const_value
                    break
            else:
                print_msg(f'Font color {const} not found!', MsgType.ERROR)
        result = result.replace(const, f"'{color}'")
        return result
