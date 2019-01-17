from flask import Flask, request, jsonify, send_file
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.sql.functions import func
import os
from datetime import datetime
from datetime import timedelta
import requests
import threading
import time
from flask_cors import CORS
from web3 import Web3, HTTPProvider
from web3.contract import ConciseContract
from web3.auto import w3
from web3.middleware import geth_poa_middleware
from web3.gas_strategies.time_based import fast_gas_price_strategy, slow_gas_price_strategy, medium_gas_price_strategy
from eth_account import Account
import json
from flask_marshmallow import Marshmallow
import csv
from io import BytesIO
import pandas as pd
from validate_email import validate_email
import uuid
from werkzeug.security import generate_password_hash, check_password_hash
import jwt
from functools import wraps
# from Pillow import Image
# import Image
from PIL import Image, ImageFilter
from tempfile import NamedTemporaryFile
from shutil import copyfileobj
from os import remove

def isValidEmail(email):
    return validate_email(email)


app = Flask(__name__)
CORS(app)
app.config.from_object(os.environ['APP_SETTINGS'])
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)
from models import Song
ma = Marshmallow(app)


print()
print("  STARTING TUNE TRADE")
print("  ^^^^^^^^^^^^^^^^^^^^^^^^^^^")
print("  ETHEREUM PROVIDER:                     ", app.config['PROVIDER'])
print("  ETHEREUM TUNETRADER CONTRACT:          ", app.config['ETHEREUM_CONTRACT'])
print("  ETHEREUM TOKENEXCHANGE CONTRACT:       ", app.config['EXCHANGE_CONTRACT'])
print ("  DATABASE:                              ",app.config['SQLALCHEMY_DATABASE_URI'])
print()


# class EmailsSchema(ma.ModelSchema):
#     class Meta:
#         model = Emails
#

# class ClaimsSchema(ma.ModelSchema):
#     class Meta:
#         model = TokenClaims
#     email = ma.Nested(EmailsSchema)


def ConnectToContract(we3):
    file = open('contractdef.js', "r")
    abiData = json.loads(file.read())
    contract_address = we3.toChecksumAddress(app.config['ETHEREUM_CONTRACT'])
    contract_instance = we3.eth.contract(contract_address, abi=abiData)
    return contract_instance

def ConnectToExchangeContract(we3):
    file = open('exchangecontractdef.js', "r")
    abiData = json.loads(file.read())
    contract_address = we3.toChecksumAddress(app.config['EXCHANGE_CONTRACT'])
    contract_instance = we3.eth.contract(contract_address, abi=abiData)
    return contract_instance


def ConnectToSongERC20(we3, songAddress):
    file = open('songerc20def.js', "r")
    abiData = json.loads(file.read())
    contract_address = we3.toChecksumAddress(songAddress)
    contract_instance = we3.eth.contract(contract_address, abi=abiData)
    return contract_instance


def ConnectToSongSale(we3, saleAddress):
    file = open('icodef.js', "r")
    abiData = json.loads(file.read())
    contract_address = we3.toChecksumAddress(saleAddress)
    contract_instance = we3.eth.contract(contract_address, abi=abiData)
    return contract_instance

def ConnectToPositionContract(we3, positionAddress):
    file = open('positioncontractdef.js', "r")
    abiData = json.loads(file.read())
    contract_address = we3.toChecksumAddress(positionAddress)
    contract_instance = we3.eth.contract(contract_address, abi=abiData)
    return contract_instance



def GetWeb3():
    w3.eth.enable_unaudited_features()
    we3 = Web3(HTTPProvider(app.config['PROVIDER']))
    we3.eth.enable_unaudited_features()
    we3.middleware_stack.inject(geth_poa_middleware, layer=0)
    return we3


def GetFastGasPrice(we3):
    print("Checking gas price. Strategy: Fast")
    we3.eth.setGasPriceStrategy(fast_gas_price_strategy)
    gasprice = we3.eth.generateGasPrice()
    print("Gas price:", gasprice)
    return gasprice


def GetNodeGasPrice():
    APILINK = app.config['API_ADDRESS']+'/eth_gasPrice'
    try:
        res = requests.get(APILINK)
    except:
        return 0

    dictFromServer = res.json()
    hexValue = dictFromServer['result']
    weiValue = int(hexValue, 0)
    gweiValue = Web3.fromWei(int(dictFromServer['result'], 0), 'gwei')

    print('Gas price (hex):', hexValue)
    print('Gas price (wei):', weiValue)
    print('Gas price (gwei):', gweiValue)
    return weiValue


def GetMediumGasPrice(we3):
    print("Checking gas price. Strategy: Medium")
    print("Checking last block")
    block = we3.eth.getBlock('latest')
    # print(block)

    i = 10
    while True:

        try:
            we3.eth.setGasPriceStrategy(medium_gas_price_strategy)
            gasprice = we3.eth.generateGasPrice()
            break
        except:
            print(
                '*** There was a problem trying to get slow price. Retrying ', i, ' more times')
            i -= 1
            if i == 0:
                print(
                    'Could not connect to server to receive gas price. Using default value: 4 gwei')
                gasprice = we3.toWei(4, 'gwei')
                break

            continue

    # print("Gas price:",gasprice)
    nodeGasPrice = GetNodeGasPrice()
    if gasprice < nodeGasPrice:
        print("Node gas price limit is higher than returned gas price ")
        print("Node gas price: ", nodeGasPrice)
        print("Gas price: ", gasprice)
        gasprice = nodeGasPrice

    print("Gas price:", gasprice)
    print("Gas price in GWEI", we3.fromWei(gasprice, "gwei"))
    return gasprice


def GetMyBalance(contract_instance, owner_address):
    # try:
    #     totalSupply = contract_instance.functions.totalSupply().call();
    # try:
    #        ownerSupply = contract_instance.functions.balanceOf(owner_address).call();
    # except:
    #        ownerSupply = -1
    ownerSupply = 7
    return ownerSupply
    # except:
    #     print ("Can't read total token supply")
    #     return -1


@app.route('/getPositionInformation', methods=['GET'])
def GetPositionInformation():
    positionAdr = request.args['position']
    we3 = GetWeb3()
    position_instance = ConnectToPositionContract(we3, positionAdr)

    position = dict() 
    positionDetails = position_instance.functions.GetPositionData().call()
    print(positionDetails)
    return jsonify(positionDetails)

@app.route('/getSongInformation', methods=['GET'])
def GetSongInformation():
    song_address = request.args['song']
    we3 = GetWeb3()
    # contract_instance = ConnectToContract(we3)
    song_contract_instance = ConnectToSongERC20(we3, song_address)
    contract_instance = ConnectToContract(we3)
    fullSong = dict()
    songDetails = song_contract_instance.functions.GetDetails().call()
    try: 
        account_address = Web3.toChecksumAddress(request.args['address'])
        userBalance = song_contract_instance.functions.balanceOf(account_address).call()
    except: 
        userBalance = 0
    print('Balance: ' + str(userBalance))
    songTokenInformation = song_contract_instance.functions.GetTokenDetails().call()
    song_address = we3.toChecksumAddress(song_address)
    obj = {}
    obj['contribution'] = 0
    obj['volume'] = 0
    obj['phase'] = 0
    obj['bonus'] = 0
    obj['balance'] = 0
    obj['state'] = ''
    try:
        songSale = contract_instance.functions.GetICO(song_address).call()
    except:
        songSale = ''

    print("Song Sale Address: " + str(songSale))
    if songSale != '':
        songSaleInstance = ConnectToSongSale(we3, songSale)
        saleInformation = songSaleInstance.functions.GetSaleInformation().call()
        saleStats = songSaleInstance.functions.GetStats().call()
        saleState = songSaleInstance.functions.CampaignState().call()
        balance = songSaleInstance.functions.GetBalance().call()
        # print("SaleInformation")
        # print(saleInformation[0])
        # obj['price'] = saleInformation[0]
        obj['price'] = saleInformation[0]

        print(saleStats)
        obj['balance'] = balance
        obj['contribution'] = saleStats[0]
        obj['volume'] = saleStats[1]
        obj['phase'] = saleStats[2]
        obj['bonus'] = saleStats[3]
        obj['state'] = saleState

    obj['author'] = songDetails[0]
    obj['genre'] = songDetails[1]
    obj['entryType'] = songDetails[2]
    obj['website'] = songDetails[3]
    obj['soundcloud'] = songDetails[4]
    obj['youtube'] = songDetails[5]
    obj['description'] = songDetails[6]
    obj['id'] = songDetails[7]
    obj['owner'] = songTokenInformation[0]
    obj['totalSupply'] = songTokenInformation[1]
    obj['name'] = songTokenInformation[2]
    obj['symbol'] = songTokenInformation[3]
    obj['decimals'] = songTokenInformation[4]
    obj['creationTime'] = songTokenInformation[5]
    obj['address'] = song_address
    obj['songSale'] = songSale
    obj['myBalance'] = userBalance

    print('Volume: ' + str(obj['volume']))
    print('Balance: ' + str(obj['balance']))
    print('Decimals: ' + str(obj['decimals']))
    print('State: ' + str(obj['state']))
    return jsonify(obj), 200


@app.route('/getSongs', methods=['GET'])
def GetSongs():

    we3 = GetWeb3()
    contract_instance = ConnectToContract(we3)
    songs = contract_instance.functions.GetSongs().call()
    # try:
    # except:
    # print('No songs.Some issues!!!!')
    # songs = []

    return jsonify(songs), 200
    # return jsonify(user.to_dict()), 201

@app.route('/getPositions', methods=['GET'])
def GetPositions():

    we3 = GetWeb3()
    contract_instance = ConnectToExchangeContract(we3)
    positions = contract_instance.functions.GetPositions().call()
    # try:
    # except:
    # print('No songs.Some issues!!!!')
    # songs = []

    return jsonify(positions), 200
    # return jsonify(user.to_dict()), 201


@app.before_first_request
def activate_job():
    def run_job():
        return
        we3 = GetWeb3()
        contract_instance = ConnectToContract(we3)
        owner_address = app.config['PUBLIC_ADDRESS']
        gasprice = GetMediumGasPrice(we3)
        i = 0

        while True:

            i += 1
            if i == 3600:
                i = 0
                gasprice = GetSlowGasPrice(we3)

            myBalance = GetMyBalance(contract_instance, owner_address)
            private_key = app.config['PRIVATE_KEY']
            signed_txn = we3.eth.account.signTransaction(
                txn, private_key=private_key)

            # Sending raw transaction to blockchain
            print('RawTransaction:')
            print(we3.toHex(signed_txn.rawTransaction))
            print("\t###    Gas:", gas)
            print("\t###    Gas price:", gasprice)
            tx = we3.eth.sendRawTransaction(
                we3.toHex(signed_txn.rawTransaction))
            txcost = w3.fromWei(gasprice * gas, "ether")
            print('Transaction Number:', we3.toHex(tx))

            # Updating database.
            claim.tx_number = we3.toHex(tx)
            claim.processed = True
            claim.processed_time = datetime.now()
            db.session.commit()

            print("\t###    ADDED NEW TRANSACTION")
            print("\t###    Cost:", txcost)
            print("\t###    TX Number:", tx)
            print("\t###    Address:", claim.claimed_address)
            print("\t###    Amount:", claim.amount)
            print("\t###    Nonce:", nonce)
            print("\t###    Gas:", gas)
            print("\t###    Gas price:", gasprice)

            time.sleep(1)

    thread = threading.Thread(target=run_job)
    thread.start()


def CheckTransactionsReceipts(we3):

    print("Checking transactions for receipt")
    claims = TokenClaims.query.filter(
        TokenClaims.processed == True, TokenClaims.tx_number != '', TokenClaims.tx_delivered != True).all()
    print("Transactios to check:", len(claims))

    for claim in claims:
        print(claim.tx_number, type(claim.tx_number))
        tx = we3.toBytes(hexstr=claim.tx_number)
        receipt = we3.eth.getTransactionReceipt(tx)
        transaction = we3.eth.getTransaction(tx)
        print('Transaction:', transaction)
        print("Check transaction !!!!!!!!!!!!!!:", receipt)
        if receipt != None:
            claim.tx_delivered = True
            claim.delivered_at = datetime.now()
            db.session.commit()

        print("Checking transaction:", we3.toHex(
            tx), " Delivered:", claim.tx_delivered)


def token_required(f):
    @wraps(f)
    def _verify(*args, **kwargs):

        invalid_msg = {
            'message': 'Invalid token. Registeration and / or authentication required',
            'authenticated': False
        }
        expired_msg = {
            'message': 'Expired token. Reauthentication required.',
            'authenticated': False
        }

        print(request.method)
        print('tokenn', request.args)
        if request.method == 'GET':
            print('GET METHOD')
            if 'token' in request.args:
                print('There is token:', request.args['token'])
                try:
                    token = request.args['token']
                    data = jwt.decode(token, app.config['SECRET_KEY'])
                    user = User.query.filter_by(login=data['sub']).first()
                    if not user:
                        raise RuntimeError('User not found')

                    return f(user, *args, **kwargs)
                except jwt.ExpiredSignatureError:
                    print('expired')
                    # 401 is Unauthorized HTTP status code
                    return jsonify(expired_msg), 401
                except (jwt.InvalidTokenError, Exception) as e:
                    print(e)
                    return jsonify(invalid_msg), 401

            else:
                print('No token')
                return jsonify(invalid_msg), 401

            # if not request.args['token']:
                # print('No token')
            # return 'OK'

        auth_headers = request.headers.get('Authorization', '').split()

        if len(auth_headers) != 2:
            print('Invalid message')
            print(request.headers)
            print(auth_headers)
            return jsonify(invalid_msg), 401

        try:
            token = auth_headers[1]
            print(token)
            data = jwt.decode(token, app.config['SECRET_KEY'])
            user = User.query.filter_by(login=data['sub']).first()
            if not user:
                raise RuntimeError('User not found')
            return f(user, *args, **kwargs)
        except jwt.ExpiredSignatureError:
            print('expired')
            # 401 is Unauthorized HTTP status code
            return jsonify(expired_msg), 401
        except (jwt.InvalidTokenError, Exception) as e:
            print(e)
            return jsonify(invalid_msg), 401

    return _verify


@app.route('/test', methods=['GET'])
@token_required
def test(v):
    return "Node gas price [wei]: " + str(GetNodeGasPrice())


@app.route('/', methods=['GET'])
def default():
    return "Marketing Coin Copyright 2018."


@app.route('/updatePassword', methods=['POST'])
@token_required
def updatePassword(v):

    print(v)

    newpassword = request.args['newpassword']
    repeatpassword = request.args['repeatpassword']

    data = {}
    data['login'] = login
    data['password'] = password
    user = User(**data)
    db.session.add(user)
    db.session.commit()
    return jsonify(user.to_dict()), 201


@app.route('/refreshToken', methods=['POST'])
@token_required
def refreshToken(v):
    print("Refresh token for user:", v.login)

    user = User.query.filter_by(login=v.login).first()

    if not user:
        return jsonify({'message': 'Invalid credentials', 'authenticated': False}), 401

    token = jwt.encode({
        'sub': user.login,
        'iat': datetime.utcnow(),
        'exp': datetime.utcnow() + timedelta(minutes=30)},
        app.config['SECRET_KEY'])
    print("Returning Token", token)
    return jsonify({'token': token.decode('UTF-8')})


@app.route('/login', methods=['POST'])
def login():
    # return "OK",200
    data = request.get_json()

    # login = request.args['login']
    # password = request.args['password']
    #
    # data = {}
    # data['login'] = login
    # data['password'] = password
    print(data)
    user = User.authenticate(**data)

    if not user:
        return jsonify({'message': 'Invalid credentials', 'authenticated': False}), 401

    token = jwt.encode({
        'sub': user.login,
        'iat': datetime.utcnow(),
        'exp': datetime.utcnow() + timedelta(minutes=30)},
        app.config['SECRET_KEY'])
    print("Returning Token", token)
    return jsonify({'token': token.decode('UTF-8')})


@app.route('/getPicture', methods=['GET'])
def getPicture():
    print(request)
    try:
        id = request.args['id']
    except:
        return "Parameter symbol is missing. Unable to return album picture.", 406

    print('checking picture number: ' + id)

    if (request.args['id'] != None):
        size = (400, 400)
        picture = Song.query.filter_by(id=id).first()
        if(picture != None):
            if(picture.picture != None):
                picData = BytesIO(picture.picture)
                img = Image.open(picData)
                img.thumbnail(size, Image.ANTIALIAS)
                img.save('test.png', 'PNG')
                picData = open ('test.png', 'rb')
                return send_file(picData, mimetype='image')
                # return send_file(BytesIO(country.flag_picture),mimetype='image')
            else:
                print ("No picture")
                missing = Image.open('missing.jpg')
                missing.thumbnail(size, Image.ANTIALIAS)
                missing.save('test.jpg', 'PNG')
                img = open('test.jpg', 'rb')
                return send_file(img, mimetype='image')
        else:
            print ("No song")
            missing = Image.open('missing.jpg')
            missing.thumbnail(size, Image.ANTIALIAS)
            missing.save('test.jpg', 'PNG')
            img = open('test.jpg', 'rb')

            return send_file(img, mimetype='image')
            # return "Picture doesn't exists", 404
    else:
        return "Invalid query", 406


# def ConnectToSongERC20(we3, songAddress):
#     file = open('songerc20def.js', "r")
#     abiData = json.loads(file.read())
#     contract_address = we3.toChecksumAddress(songAddress)
#     contract_instance = we3.eth.contract(contract_address, abi=abiData)
#     return contract_instance


@app.route('/getABIs', methods=['GET'])
def getABIs():
    songFile = open('songerc20def.js', "r")
    songABIData = json.loads(songFile.read())

    mainFile = open('contractdef.js', "r")
    mainABIData = json.loads(mainFile.read())

    icoFile = open('icodef.js', "r")
    ICOABIData = json.loads(icoFile.read())

    exchangeFile = open('exchangecontractdef.js', "r")
    exchangeABIData = json.loads(exchangeFile.read())

    positionFile = open('positioncontractdef.js', "r")
    positionABIData = json.loads(positionFile.read())


    return jsonify({'song': songABIData,'main': mainABIData, 'ico': ICOABIData, 'exchange': exchangeABIData, 'position': positionABIData})

@app.route('/getContract', methods=['GET'])
def getContract():
    we3 = GetWeb3()
    contract_instance = ConnectToContract(we3)
    contractOwner = contract_instance.functions.GetContractOwner().call()
    return jsonify({'main': app.config['ETHEREUM_CONTRACT'], 'exchange': app.config['EXCHANGE_CONTRACT'], 'contractOwner': contractOwner}), 200


@app.route('/uploadPic', methods=['POST'])
def uploadPic():
    id = request.form['id']
    print("Updating picture id = " + id)
    obj = Song.query.filter_by(id=id).first()
    # print (id)
    print(obj)
    if(obj != None):
        data = request.files['pic'].read()
        print(data)
        symbol = request.form['symbol']
        obj.symbol = symbol
        obj.picture = data
        db.session.commit()
        print(obj.id)
        return "OK", 200

    return "NOT OK", 500


@app.route('/getNewSongId', methods=['GET'])
def getNewSongId():
    data = None
    symbol = ''
    song = Song(data, symbol)
    db.session.add(song)
    db.session.commit()
    songjson = {}
    songjson['newid'] = song.id
    return jsonify({'song': songjson}), 200


@app.route('/uploadEmails', methods=['POST'])
@token_required
def uploadEmails(v):

    tx_time = datetime.now()
    print(request.files)
    print(request.files['emailsFile'].filename)
    fileLength = len(request.files['emailsFile'].read())
    if(fileLength < 5):
        print("File is too short. Probably it is empty. ")
        return "Invalid CSV file", 415

    request.files['emailsFile'].seek(0)
    # if(request.files['emailsFile']==None):
    # return "No file selected",400

    csvfile = request.files['emailsFile']
    # print (csvfile.read())

    if csvfile == None:
        return "NOT OK", 500
    csvfile.save('temp.csv')

    print(os.path.getsize('temp.csv'))
    file = open('temp.csv')

    # csvfile.save('test.csv')
    # data = BytesIO(csvfile)
    # print(csvfile.read())
    # reader = csv.reader(csvfile.read())
    # reader = csv.reader(BytesIO(csvfile.read()))
    # reader = csv.reader(TextIOWrapper(BytesIO(csvfile.read())))
    try:
        reader = csv.reader(file, dialect='excel')
    except:
        print("Wrong file format")
        return "Wrong file format", 500

    try:
        emailscount = len(pd.read_csv('temp.csv'))+1
    except:
        print("Wrong file format")
        emailscount = 0
        # return "Wrong file format",500

    newemailscount = 0
    oldemailscount = 0
    invalidcount = 0
    # f = BytesIO(csvfile.read())
    for row in reader:
        if not isValidEmail(row[0]):
            invalidcount += 1
            continue

        print('.')
        print(row[0])
        print(reader.line_num)
        e = Emails.query.filter(Emails.email == row[0]).first()
        if (e):
            print('Exist')
            oldemailscount += 1

        else:
            print('Do not exist')
            email = Emails(row[0], '', '')
            db.session.add(email)
            db.session.commit()
            newemailscount += 1

    info = {}
    info['emailscount'] = emailscount
    info['newemailscount'] = newemailscount
    info['oldemailscount'] = oldemailscount
    info['invalidcount'] = invalidcount
    info['time'] = tx_time

    return jsonify(info)
    return "OK", 200


@app.route('/tokenInformation', methods=['POST'])
@token_required
def tokenInformation(v):

    try:
        we3 = GetWeb3()
        contract_instance = ConnectToContract(we3)
        decimals = contract_instance.functions.decimals().call()
        supply = contract_instance.functions.totalSupply().call()/(10**decimals)
        name = contract_instance.functions.name().call()
        symbol = contract_instance.functions.symbol().call()
        owner_address = app.config['PUBLIC_ADDRESS']
        balance = contract_instance.functions.balanceOf(
            owner_address).call()/(10**decimals)
        owner_balance = we3.eth.getBalance(owner_address)
    except:
        return "Error.Cannot connect to blockchain node.", 504

    token_holders = TokenClaims.query.with_entities(TokenClaims.claimed_address).filter(
        TokenClaims.claimed_address != '').group_by(TokenClaims.claimed_address).count()

    print(token_holders)

    transfersCount = TokenClaims.query.filter(
        TokenClaims.tx_delivered == True).count()
    print(transfersCount)

    waitingTokens = db.session.query(func.sum(TokenClaims.amount)).filter(
        TokenClaims.tx_delivered == False, TokenClaims.expiration_date >= datetime.now()).scalar()

    try:
        waitingTokens = int(waitingTokens)
    except:
        waitingTokens = 0

    expiredTokens = db.session.query(func.sum(TokenClaims.amount)).filter(
        TokenClaims.tx_delivered == False, TokenClaims.expiration_date < datetime.now()).scalar()

    try:
        expiredTokens = int(expiredTokens)
    except:
        expiredTokens = 0

    expiredTransactions = TokenClaims.query.filter(
        TokenClaims.tx_delivered == False, TokenClaims.expiration_date < datetime.now()).count()
    waitingTransactions = TokenClaims.query.filter(
        TokenClaims.tx_delivered == False, TokenClaims.expiration_date >= datetime.now()).count()

    print("Waiting Transaction:", waitingTransactions)
    print("Waiting Tokens:", waitingTokens)
    claimedTokens = db.session.query(func.sum(TokenClaims.amount)).filter(
        TokenClaims.claimed_address != '').scalar()

    try:
        claimedtokens = int(claimedTokens)
    except:
        claimedTokens = 0

    claimedTransactions = TokenClaims.query.filter(
        TokenClaims.claimed_address != '').count()

    try:
        claimedTransactions = int(claimedTransactions)
    except:
        claimedTransactions = 0

    emails_query = db.session.query(Emails.id, Emails.email, (func.count(TokenClaims.id)).label(
        'tokenAmount')).outerjoin(TokenClaims).filter(Emails.id > 0).group_by(Emails.id)
    print(emails_query)

    emptyemailsCount = emails_query.having('count(tokenclaims.id)=0').count()

    try:
        emptyemailsCount = int(emptyemailsCount)
    except:
        emptyemailsCount = 0

    fullemailsCount = emails_query.having('count(tokenclaims.id)>0').count()

    try:
        fullemailsCount = int(fullemailsCount)
    except:
        fullemailsCount = 0

    information = {}

    information['emptyEmails'] = str(emptyemailsCount)
    information['fullEmails'] = str(fullemailsCount)
    information['decimals'] = decimals
    information['totalSupply'] = supply
    information['name'] = name
    information['symbol'] = symbol
    information['ownerTokenBalance'] = balance
    information['ownerETHBalance'] = str(we3.fromWei(owner_balance, "ether"))
    information['contractAddress'] = app.config['ETHEREUM_CONTRACT']
    information['managerAddress'] = owner_address
    information['tokenHolders'] = str(token_holders)
    information['transfersCount'] = str(transfersCount)
    information['waitingTokens'] = str(waitingTokens)
    information['expiredTokens'] = str(expiredTokens)
    information['waitingTransactions'] = str(waitingTransactions)
    information['expiredTransactions'] = str(expiredTransactions)
    information['claimedTokens'] = str(claimedTokens)
    information['claimedTransactions'] = str(claimedTransactions)
    return jsonify({'information': information})


@app.route("/NewClaim", methods=['POST'])
@token_required
def NewClaim(v):
    dataIn = request.form

    securityText = str(uuid.uuid4())
    # securityText = dataIn['securityText']
    # email = dataIn['email']
    amount = dataIn['amount']
    days = dataIn['days']

    # Check owner balance to see if there is enough tokens.
    we3 = GetWeb3()
    contract_instance = ConnectToContract(we3)
    owner_address = app.config['PUBLIC_ADDRESS']
    mySupply = GetMyBalance(contract_instance, owner_address)

    waitingTokens = db.session.query(func.sum(TokenClaims.amount)).filter(
        TokenClaims.tx_delivered == False, TokenClaims.expiration_date >= datetime.now()).scalar()

    try:
        waitingTokens = int(waitingTokens)*(10**18)
    except:
        waitingTokens = 0

    freeTokens = mySupply - waitingTokens
    if freeTokens < 0:
        freeTokens = 0

    print("MySupply:", mySupply)
    print("Amount:", amount)
    print("FreeTokens:", freeTokens)

    if((int(amount) * 10 ** 18) > freeTokens):
        return 'Not enough tokens', 400

    if int(amount) == 0:
        return "Amount can't be zero", 400

    if int(days) == 0:
        return "Days can't be zero", 400

    creation_date = datetime.now()
    daysDelta = timedelta(days=int(days))
    expiration_date = creation_date + daysDelta
    if(len(dataIn['email']) > 0):
        email = Emails.query.filter(Emails.email == dataIn['email']).first()
        if(email == None):
            newemail = Emails(dataIn['email'], '', '')
            claim = TokenClaims(securityText, amount, newemail,
                                creation_date, expiration_date, False, '', None)
        else:
            claim = TokenClaims(securityText, amount, email,
                                creation_date, expiration_date, False, '', None)
    else:
        email = None
        claim = TokenClaims(securityText, amount, email,
                            creation_date, expiration_date, False, '', None)

    try:
        db.session.add(claim)
        db.session.commit()
    except:
        print("!!!! Internal server error when trying to add new claim to databse")
        return "Internal server error", 500

    print(dataIn)
    return jsonify({'security_text': securityText})


@app.route("/LastTransaction", methods=['POST'])
@token_required
def LastTransaction(v):
    claim = TokenClaims.query.with_entities(TokenClaims.id, 'amount', 'delivered_at', 'claimed_address', TokenClaims.email).filter(
        TokenClaims.tx_delivered == True).order_by(TokenClaims.delivered_at.desc()).first()
    print(claim)
    if (claim == None):
        return 'failed', 400

    claims_schema = ClaimsSchema()
    output = claims_schema.dump(claim).data
    return jsonify({'claim': output})


@app.route("/ReadClaim", methods=['POST'])
# No token is required. Authentication is based on security hash.
def ReadClaim():
    dataIn = request.form
    securityText = dataIn['securityText']
    print(securityText)
    claim = TokenClaims.query.filter(
        TokenClaims.security_text == securityText).first()
    print(claim)
    if (claim == None):
        return 'failed', 400

    claims_schema = ClaimsSchema()
    output = claims_schema.dump(claim).data
    return jsonify({'claim': output})
    # res = db.session.query(TokenClaims).all();
    # print(res)
    # q = json.dumps(res)
    # return q
    # return json.dumps([dict(r) for r in res])
    # # return "It is ok",200


@app.route("/ClaimToken", methods=['POST'])
def ClaimToken():
    dataIn = request.form
    print(dataIn)
    securityText = dataIn['securityText']
    address = dataIn['address']
    claimed_time = datetime.now()
    claim = TokenClaims.query.filter(
        TokenClaims.security_text == securityText and TokenClaims.claimed_address != '').first()
    if (claim == None):
        return 'failed', 400

    if(datetime.now() > claim.expiration_date):
        return "Token " + securityText + "  expired.", 410

    claim.claimed_address = address
    claim.claimed_time = claimed_time
    claim.claimed = True
    claim.processed = False

    email = dataIn['email']
    if(len(dataIn['email']) > 0):
        email = Emails.query.filter(Emails.email == dataIn['email']).first()
        if(email == None):
            newemail = Emails(dataIn['email'], '', '')
            claim.email = newemail

    db.session.commit()
    claims_schema = ClaimsSchema()
    output = claims_schema.dump(claim).data
    return jsonify({'claim': output})


@app.route('/getWaitingListCSV', methods=['GET'])
@token_required
def getWaitingListCSV(v):
    claims = TokenClaims.query.join(Emails, aliased=True).filter(
        TokenClaims.claimed_address == '').all()
    out = ''
    file = open('output.csv', 'w', newline='')
    writer = csv.DictWriter(file, delimiter=',', fieldnames=[
                            'security text', 'amount', 'email', 'expiration date'])
    writer.writeheader()
    for row in claims:
        # print (row.security_text,row.email.email)
        writer.writerow({'security text': row.security_text, 'amount': row.amount,
                         'email': row.email.email, 'expiration date': row.expiration_date})
        # writer.writerow([row.security_text,row.amount,row.email.email,row.expiration_date])
        out = out + row.security_text + ','+row.email.email + '<br>'
    file.close()
    # file = open('output.csv','r')
    ts = datetime.now().strftime("%Y%m%d_%H%M")
    # print (ts)
    filename = "WaitingList_"+ts+".csv"
    return send_file('output.csv', attachment_filename=filename, as_attachment=True, mimetype='text/csv', cache_timeout=0)
    # return out


@app.route('/getClaimedListCSV', methods=['GET'])
@token_required
def getClaimedListCSV(v):
    claims = TokenClaims.query.join(Emails, aliased=True).filter(
        TokenClaims.claimed_address != '').all()
    file = open('output.csv', 'w', newline='')
    fieldnames = ['security text', 'amount', 'email', 'claimed time',
                  'processed time', 'delivery time', 'failed', 'failed reason']
    writer = csv.DictWriter(file, delimiter=',', fieldnames=fieldnames)
    writer.writeheader()
    for row in claims:
        print(row.security_text, row.email.email)
        writer.writerow(
            {
                'security text': row.security_text,
                'amount': row.amount,
                'email': row.email.email,
                'claimed time': row.claimed_time,
                'processed time': row.processed_time,
                'delivery time': row.delivered_at,
                'failed': row.failed,
                'failed reason': row.failed_msg

            })
        # writer.writerow([row.security_text,row.amount,row.email.email,row.expiration_date])
    file.close()
    ts = datetime.now().strftime("%Y%m%d_%H%M")
    filename = "ClaimedList_"+ts+".csv"
    return send_file('output.csv', attachment_filename=filename, as_attachment=True, mimetype='text/csv', cache_timeout=0)


@app.route('/getCSV', methods=['GET'])
@token_required
def getCSV(v):
    type = request.args['type']
    print(type)
    claims = TokenClaims.query.join(Emails).filter(
        TokenClaims.claimed_address == '').all()
    out = ''
    file = open('output.csv', 'w', newline='')
    writer = csv.writer(file, delimiter=',')
    for row in claims:
        if type == 'emailonly' and row.email_id == 0:
            continue
        print(row.security_text, row.email.email)
        writer.writerow([row.email.email, row.security_text, row.amount])
        out = out + row.security_text + ','+row.email.email + '<br>'
    file.close()
    file = open('output.csv', 'r')
    ts = datetime.now().strftime("%Y%m%d_%H%M")

    filename = "CSV_"+type+"_"+ts+".csv"
    return send_file('output.csv', attachment_filename=filename, as_attachment=True, mimetype='text/csv', cache_timeout=0)
    # return out


@app.route('/generateClaims', methods=['POST'])
@token_required
def generateClaims(v):

    skipped = 0
    generated = 0
    dataIn = request.form
    type = dataIn['type']
    # amount = 1
    print(dataIn)
    amount = dataIn['amount']
    days = dataIn['days']
    if amount == '0':
        print("quitting")
        return "Amount can't be zero", 401
    if days == '0':
        print("quitting")
        return "Days can't be zero", 401

    # print (amount)
    if not (type == 'all' or type == 'emptyemail'):
        return "Error: Type must be either all or emptyemail.", 401

    # emails_query = db.session.query(Emails.id,Emails.email,(func.count(TokenClaims.email_id).label('tokensAmount'))).filter(('tokenclaims.email_id = emails.id'), Emails.id > 0).group_by(Emails.id)
    emails_query = db.session.query(Emails.id, Emails.email, (func.count(TokenClaims.id)).label(
        'tokenAmount')).outerjoin(TokenClaims).filter(Emails.id > 0).group_by(Emails.id)
    print(emails_query)

    if type == 'emptyemail':
        emails = emails_query.having('count(tokenclaims.id)=0').all()
        emailsCount = emails_query.having('count(tokenclaims.id)=0').count()
    else:
        emails = emails_query.all()
        emailsCount = emails_query.count()

    print(emails, emailsCount)

    # Getting my supply. Total amount of free tokens.
    we3 = GetWeb3()
    contract_instance = ConnectToContract(we3)
    owner_address = app.config['PUBLIC_ADDRESS']
    mySupply = GetMyBalance(contract_instance, owner_address)
    mySupply = mySupply//(10**18)

    # Checking amount of tokens waiting to be claimed
    waitingTokens = db.session.query(func.sum(TokenClaims.amount)).filter(
        TokenClaims.tx_delivered == False).scalar()
    freeTokens = mySupply - waitingTokens

    print('*** Total token balance:', mySupply)
    print('*** Waiting Tokens:', waitingTokens)
    print('*** Tokens available for delivery:', freeTokens)
    print('*** Amount to deliver per email:', amount)
    availableEmails = freeTokens//int(amount)
    print('*** Emails which can be served:', availableEmails)
    print('*** Emails to deliver to:', emailsCount)

    if availableEmails > emailsCount:
        print('*** Can serve all emails')

    servedEmails = 0
    for row in emails:
        servedEmails = servedEmails + 1
        if servedEmails > availableEmails:
            output = {}
            output['generated'] = generated
            output['error'] = 'Not enough tokens to generate links for all emails.'
            print('Not enough tokens. Quitting')
            return jsonify(output)
            break

        securityText = str(uuid.uuid4())
        creation_date = datetime.now()
        daysDelta = timedelta(hours=24*int(days))
        expiration_date = creation_date + daysDelta

        email = Emails.query.filter(Emails.id == row.id).first()

        claim = TokenClaims(securityText, amount, email,
                            creation_date, expiration_date, False, '', None)
        db.session.add(claim)
        db.session.commit()
        generated += 1

    output = {}
    output['generated'] = generated
    return jsonify(output)


@app.route("/GetEmails", methods=['POST'])
@token_required
def GetEmails(v):
    emails = Emails.query.join(TokenClaims).all()
    emails_schema = EmailsSchema(many=True)
    output = emails_schema.dump(emails).data

    for row in emails:
        print(len(row.claims))

    return jsonify({'emails': output})


@app.route("/GetClaims", methods=['POST'])
@token_required
def GetClaims(v):
    request.stream.read()
    claims = TokenClaims.query.join(Emails, aliased=True).filter(
        TokenClaims.claimed_address == '', TokenClaims.expiration_date > datetime.now()).all()
    # claims = db.session.query(TokenClaims).all()
    claims_schema = ClaimsSchema(many=True)
    # print(claims_schema.dump(claims).data[1])
    output = claims_schema.dump(claims).data
    # print(output)
    return jsonify({'claims': output})
    # res = db.session.query(TokenClaims).all();
    # print(res)
    # q = json.dumps(res)
    # return q
    # return json.dumps([dict(r) for r in res])
    # # return "It is ok",200


@app.route("/GetClaimedTokens", methods=['POST'])
@token_required
def GetClaimedTokens(v):
    claims = TokenClaims.query.join(Emails, aliased=True).filter(
        TokenClaims.claimed_address != '').all()
    # claims = db.session.query(TokenClaims).all()
    claims_schema = ClaimsSchema(many=True)
    # print(claims_schema.dump(claims).data[1])
    output = claims_schema.dump(claims).data
    print(output)
    return jsonify({'claims': output})
    # res = db.session.query(TokenClaims).all();
    # print(res)
    # q = json.dumps(res)
    # return q
    # return json.dumps([dict(r) for r in res])
    # # return "It is ok",200


@app.route("/getStats", methods=['POST'])
@token_required
def getStats(v):
    emails = Emails.query.filter(Emails.id > 0).all()
    countemail = len(emails)
    emailsWithToken = 0
    emailsNoToken = 0
    countclaims = 0
    claimedClaims = 0
    waitingClaims = 0

    for row in emails:
        # print(row.email)
        emailClaims = TokenClaims.query.filter(
            TokenClaims.email_id == row.id).count()
        if(emailClaims > 0):
            emailsWithToken += 1
        else:
            emailsNoToken += 1

    tokens = TokenClaims.query.all()
    countclaims = len(tokens)
    for row in tokens:
        # print(row)
        if row.claimed_address != '':
            claimedClaims += 1
            # print ("None")
        else:
            waitingClaims += 1

    output = {}
    # claimsCount:0,
    # claimsClaimed:0,
    # claimsWaiting:0,
    # emailsCount:0,
    # emailsNoToken:0,
    # emailsWithToken:0

    output['emailsCount'] = countemail
    output['emailsWithToken'] = emailsWithToken
    output['emailsNoToken'] = emailsNoToken
    output['claimsCount'] = countclaims
    output['claimsClaimed'] = claimedClaims
    output['claimsWaiting'] = waitingClaims

    return jsonify({'stats': output})


@app.route("/GetClaimsCSV", methods=['POST'])
def GetClaimsCSV(v):
    claims = TokenClaims.query.all()
    claims_schema = ClaimsSchema(many=True)
    output = claims_schema.dump(claims).data
    wyjscie = jsonify({'claims': output})
    for i in range(len(output)):
        for k in output[i]:
            print(output[i][k])

    return wyjscie
    # res = db.session.query(TokenClaims).all();
    # print(res)
    # q = json.dumps(res)
    # return q
    # return json.dumps([dict(r) for r in res])
    # # return "It is ok",200

    def start_runner():
        def start_loop():
            not_started = True
            r = ""
            while not_started:
                try:
                    r = requests.get('http://127.0.0.1/')
                    if r.status_code == 200:
                        print('Server started, quiting start_loop')
                        not_started = False
                    print(r.status_code)
                except:
                    print(r.status_code)
                    print('Server not yet started')
                time.sleep(2)

        print('Started runner')


if __name__ == '__main__':
    start_runner()
    app.run()
