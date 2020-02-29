from Builder.rpcbuilder import RPCBuilder

SETTINGS_PATH = 'rpc_builder.json'

if __name__ == '__main__':
    builder = RPCBuilder(SETTINGS_PATH)
    builder.watch()

