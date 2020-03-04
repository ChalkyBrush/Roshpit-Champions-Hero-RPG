import json
import re


kv2json_patterns = {
    re.compile(r'//.*$', re.MULTILINE): '',
    re.compile(r'"(\s*?){'): r'":\1{',
    re.compile(r'"([ \t]*)"'): r'":\1"',
    re.compile(r'"\s*?$', re.MULTILINE): r'",',
    re.compile(r',(\s*?)}'): r'\1}',
    re.compile(r'\\(?!")'): r'\\\\',
    re.compile(r'}'): '},',
    re.compile(r'(.+)', re.DOTALL): r'{\1}',
    re.compile(r',(\s*)}'): r'\1}',
    re.compile(r'\\(?!")'): r'\\\\',
}


def kv2json(text: str):
    content = text
    for pattern, repl in kv2json_patterns.items():
        content = pattern.sub(repl, content)

    try:
        return json.loads(content)
    except json.decoder.JSONDecodeError as e:
        new_text = _process_exception(e, content)
        raise SyntaxError(new_text) from e


def _process_exception(e, culprit):
    text = f'{e}\n'
    line_number = int(re.search('line (\d+)', text).group(1)) - 1
    char_number = int(re.search('column (\d+)', text).group(1)) - 1
    line = culprit.split('\n')[line_number]
    while '\t' in line:
        if line.index('\t') < char_number:
            char_number += 1
        line = line.replace('\t', r'\t', 1)
    text += f'{line}\n'
    text += f'{" " * (char_number)}^'
    return text