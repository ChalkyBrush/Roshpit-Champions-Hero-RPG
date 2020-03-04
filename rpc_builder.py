from Builder.rpcbuilder import RPCBuilder
from Builder.thirdparty.colorama import init

SETTINGS_PATH = 'Builder/settings.json'

if __name__ == '__main__':
    init()
    builder = RPCBuilder(SETTINGS_PATH)
    builder.watch()

