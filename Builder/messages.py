from enum import Enum
from sys import exit

class MsgType(Enum):
    INFO = '\033[10m'
    ERROR = '\033[91m'
    WARNING = '\033[93m'
    END = '\033[0m'


def print_msg(text: str, msgtype: MsgType) -> None:
    #print(f'{msgtype.value}[{msgtype.name}] {text}{MsgType.END.value}')
    print(f'[{msgtype.name}] {text}')
    if msgtype == MsgType.ERROR:
        exit()

