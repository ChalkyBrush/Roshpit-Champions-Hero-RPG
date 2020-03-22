from enum import Enum
from typing import Optional

class MsgType(Enum):
    INFO = '\033[10m'
    ERROR = '\033[91m'
    WARNING = '\033[93m'
    END = '\033[0m'


def print_msg(text: str, msgtype: MsgType, end: Optional[str] = '\n') -> None:
    prefix = f'{msgtype.value}[{msgtype.name}] ' if msgtype != MsgType.INFO else ''
    print(f'{prefix}{text}{MsgType.END.value}')

