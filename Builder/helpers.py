import os
import re


def regex_find_all(regex, top='./'):
    result = []
    matcher = re.compile(regex)
    for root, dirs, files in os.walk(top, topdown=True):
        for filename in files:
            filename = os.path.normpath(os.path.relpath(os.path.join(root, filename))).replace('\\', '/')
            if matcher.match(filename):
                result.append(filename)
    return result
