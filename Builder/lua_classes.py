from typing import Union, Any, Iterable, Optional
from abc import ABC, abstractmethod

LuaConstant = Union['LuaNumber', 'LuaString', 'LuaTable']


def try_parse(value: Any) -> Optional[LuaConstant]:
    types = (LuaNumber, LuaTable, LuaString)
    for t in types:
        try: return t(value)
        except (TypeError, ValueError): continue
    return None


class LuaConstant(ABC):
    @abstractmethod
    def to_string(self) -> str:
        pass


class LuaString(str, LuaConstant):
    '''Class used for Lua string constants or DOTA predefined constants
    Examples: ACT_DOTA_RUN, "#FF0000"'''

    def __new__(cls, value: str) -> 'LuaString':
        if type(value) != str:
            raise TypeError(f"LuaString() argument should be string not '{value.__class__.__name__}'")

        quotes = ('"', "'")
        for q in quotes:
            if value.startswith(q) and value.endswith(q):
                value = value.strip(q)
                break

        return str.__new__(cls, value)
    
    def __repr__(self):
        return f'<{self.__class__.__name__}:{repr(str(self))}>'

    def to_string(self) -> str:
        return str(self)


class LuaNumber(float, LuaConstant):
    '''Class used for Lua numeric constants
    Examples: 100, 22.8'''

    def __add__(self, x: Union[int, float, 'LuaNumber']):
        return LuaNumber(float(self) + x)

    def __sub__(self, x: Union[int, float, 'LuaNumber']):
        return LuaNumber(float(self) - x)

    def __mul__(self, x: Union[int, float, 'LuaNumber']):
        return LuaNumber(float(self) * x)

    def __truediv__(self, x: Union[int, float, 'LuaNumber']):
        return LuaNumber(float(self) / x)

    def _rounded(self, n: int) -> Union[int, float]:
        rounded = round(self, n)
        as_int = int(rounded)
        if as_int == rounded:
            return as_int
        return rounded

    def __str__(self):
        return str(self._rounded(8))

    def __repr__(self):
        return f'<{self.__class__.__name__}:{self._rounded(8)}>'

    def __bool__(self):
        return True

    def to_string(self) -> str:
        return str(self._rounded(2))


class LuaTable(list, LuaConstant):
    '''Class used for Lua table constants
    Example: {0.55, 0.60, 0.65, 0.70, 0.75}'''

    def __init__(self, value: Union[str, Iterable]) -> None:
        if type(value) == str:
            if len(value) < 2 or value[0] != '{' or value[-1] != '}':
                raise ValueError(f"could not convert string to LuaTable: {repr(value)}")

            table_str = value[1:-1]
            table_str = table_str.replace(' ', '')
            if table_str:
                temp = [try_parse(s) for s in table_str.split(',')]
                super().__init__(val for val in temp if val is not None)
        else:
            super().__init__(value)

    def __add__(self, y: Union[int, float, 'LuaNumber']):
        return LuaTable(x + y for x in self)

    def __sub__(self, y: Union[int, float, 'LuaNumber']):
        return LuaTable(x - y for x in self)

    def __mul__(self, y: Union[int, float, 'LuaNumber']):
        return LuaTable(x * y for x in self)

    def __truediv__(self, y: Union[int, float, 'LuaNumber']):
        return LuaTable(x / y for x in self)

    def __repr__(self):
        return f"<{self.__class__.__name__}:{{{', '.join(repr(x) for x in self)}}}>"

    def to_string(self) -> str:
        return ' '.join(x.to_string() for x in self)

