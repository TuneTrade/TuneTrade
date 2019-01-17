import os
basedir = os.path.abspath(os.path.dirname(__file__))


class Config(object):
    DEBUG = False
    TESTING = False
    CSRF_ENABLED = True
    SECRET_KEY = 'lkjhf34iur9fjcmsdkluf9erfjskfjqjurpqjfdej'
    # PROVIDER = 'https://rinkeby.infura.io/FiZkooYHIsk3keP6qjT7'
    # PROVIDER = 'https://ropsten.infura.io/FiZkooYHIsk3keP6qjT7'
    # PROVIDER = 'http://localhost:8545'
    # ETHEREUM_CONTRACT = '0x67d8ae27b0873a96e54cd8eb9e9086a1de95094b'
    # PUBLIC_ADDRESS = '0x8B6d64e7e3427236D18f709482764452EC5C1c18'
    # PUBLIC_ADDRESS = '0x8B6d64e7e3427236D18f709482764452EC5C1c18'
    PRIVATE_KEY= '29fb21e3fedba84f0d5b8f23291c62d7477e0d5e74d91090c44af13ffa61bb52'
    # API_ADDRESS = 'https://api.infura.io/v1/jsonrpc/rinkeby'
    # SQLALCHEMY_DATABASE_URI = 'postgresql://localhost/tunetrade'
    # SQLALCHEMY_DATABASE_URI = os.environ['DATABASE_URL']


class ProductionConfig(Config):
    DEBUG = False
    ETHEREUM_CONTRACT = '0x227CB7c43BdBeD954c4CFCBc5E9b5C7F6466ABdd'
    EXCHANGE_CONTRACT = '0x31B4be1c0FaF6C87D0E83A1CC6122160de7eB06b'
    SQLALCHEMY_DATABASE_URI = os.environ['DATABASE_URL']
    PROVIDER = 'https://ropsten.infura.io/FiZkooYHIsk3keP6qjT7'

class StagingConfig(Config):
    DEVELOPMENT = True
    DEBUG = True
    SQLALCHEMY_DATABASE_URI = os.environ['DATABASE_URL']
    # SQLALCHEMY_DATABASE_URI = 'postgresql://127.0.0.1/tunetrade?user=postgres'

class DevelopmentConfig(Config):
    DEVELOPMENT = True
    DEBUG = True
    # SQLALCHEMY_DATABASE_URI = 'postgresql://127.0.0.1/tunetrade?user=postgres'
    SQLALCHEMY_DATABASE_URI = 'postgresql://127.0.0.1/tunetrade?user=postgres'
    PROVIDER = 'http://localhost:7545'
    ETHEREUM_CONTRACT = '0x7e8Ff95C7b03bFf3fE8c74271c8247689dF841C5'
    EXCHANGE_CONTRACT = '0x1e3E8629A5B2c930029D0589E037d466d48424d4'

class TestingConfig(Config):
    TESTING = True
    SQLALCHEMY_DATABASE_URI = os.environ['DATABASE_URL']
    # SQLALCHEMY_DATABASE_URI = 'postgresql://127.0.0.1/tunetrade?user=postgres'
