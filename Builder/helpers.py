import os
import re


def regex_find_all(regex, top='./'):
    result = []
    regexes = regex.split('/', 1)
    matcher = re.compile(regexes[0])
    for file in os.listdir(top):
        if matcher.match(file):
            filename = os.path.normpath(os.path.relpath(os.path.join(top, file))).replace('\\', '/')
            if len(regexes) > 1 and os.path.isdir(filename):
                result += regex_find_all(regexes[1], filename + '/')
            elif len(regexes)== 1 and os.path.isfile(filename):
                result.append(filename)
    return result
