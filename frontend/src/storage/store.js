import Vuex from 'vuex'
import vueResource from 'vue-resource'
import Vue from 'vue'
import axios from 'axios'
import vueAxios from 'vue-axios'
Vue.use(axios)
var md5 = require('js-md5')

var Web3 = require('web3')
require('./contractdef')
require('./exchangedef.js')
Vue.use(Vuex)
Vue.use(vueResource)
var URI = require('uri-js')

// function hex2a(hexx) {
//     var hex = hexx.toString();//force conversion
//     var str = '';
//     for (var i = 2; i < hex.length; i += 2){
//       if(parseInt(hex.substr(i, 2), 16) == 0) continue;
//         str += String.fromCharCode(parseInt(hex.substr(i, 2), 16))
//       }
//     return str
// }

function sortFunction (a, b) {
  return 0
  if (a.Name > b.Name) return 1
  else return -1
}

const API = 'https://tunetrade-backend.herokuapp.com';
// const API = 'http://127.0.0.1:5000'

export const store = new Vuex.Store({
  state: {
    refreshing: false,
    toggledMenu: false,
    web3contract: {},
    web3exchangeContract: {},
    web3account: '',
    songsFailed: false,
    owner: '',
    songs: [],
    positions: [],
    formI: {},
    formB: {},
    formG: {},
    lastUpdate: null,
    contractAddress: '',
    metaMaskLoggedOut: false,
    API: API,
    songsReady: false,
    transactions: [],
    transactionIndex: 0,
    updatedTransactions: false,
    refreshTransactions: true,
    intervalNumber: 0,
    songsHash: '',
    positionsHash: '',
    showBuyCoins: {},
    showTransactions: {},
    showTokenExchangeTransactions: {},
    showNewPosition: {},
    ttContractOwner: ''
  },
  getters: {
    isWeb3Account: state => account => {
      console.log(state.web3account.toLowerCase(), '===', account.toLowerCase())
      return state.web3account.toLowerCase() === account.toLowerCase()
    },
    isContractOwner: state => () => {
      console.log(
        state.ttContractOwner.toLowerCase(),
        '===',
        state.web3account.toLowerCase()
      )
      return state.ttContractOwner.toLowerCase() === state.web3account.toLowerCase()
    },
    getCountryList: state => {
      return state.countries
    },
    getCountry: state => _ccode => {
      return state.countries.find(country => country.ccode === _ccode)
    },
    getTransactionIndex: function (state) {
      return state.transactionIndex
    },
    getSong: state => address => {
      var song = state.songs.find(song => song.address === address)
      return song
    },
    showBuyCoins: state => address => {
      return state.showBuyCoins[address]
    },
    showTransactions: state => address => {
      return state.showTransactions[address]
    },
    showTokenExchangeTransactions: state => (address, index) => {
      console.log(
        'showTokenExchangeTransactions:',
        state.showTokenExchangeTransactions,
        address,
        index
      )
      return state.showTokenExchangeTransactions[address + index]
    },
    showNewPosition: state => address => {
      return state.showNewPosition[address]
    }
  },
  mutations: {
    UpdateFormG (state, payload) {
      state.formG = payload
    },
    IncreaseTransactionIndex (state) {
      state.transactionIndex++
      return state.transactionIndex
    },
    UpdatePrice (state, payload) {
      for (var item in state.countries) {
        if (state.countries[item].ccode === payload.ccode) {
          var price = payload.price
          price = Math.ceil(price * 10000) / 10000
          state.countries[item].cprice = price
          state.refreshCountries = false
        }
      }
    },
    // GetSongs(state,payload) {
    //   state.web3contract.GetSongs(function(err,res){
    //     state.songs = res;
    //   })
    // }
    GetSongsList (state, payload) {
      axios.get(API + '/getSongs').then(function (res) {})
      // state.web3contract.GetSongs(function(err,res){
      // state.songs = res;
      // })
    }
  },
  actions: {
    StartCheckingTransactions (store) {
      let s = store
      store.state.intervalNumber = setInterval(function () {
        s.dispatch('checkTransaction')
        // console.log('Check');
      }, 5000)
    },
    clearUpdatedTransactions (store) {
      store.state.updatedTransactions = false
    },
    checkTransaction (store) {
      if (web3 === undefined) return
      var transactions = store.state.transactions
      // console.log('Checking transactions')
      // console.log(transactions)
      store.state.lastUpdate = new Date(Date.now()).toLocaleString()
      // console.log('time:', store.state.lastUpdate);
      for (var i in transactions) {
        var tx = transactions[i]
        if (tx.id === 4 || tx.id === 5 || tx.id === 3) {
          store.dispatch('CloseTransaction', tx.index)
          continue
        }
        if (tx.id == 2) {
          // console.log('Transaction pending');

          web3.eth.getTransactionReceipt(tx.txNumber, function (err, res) {
            if (res !== null) {
              if (parseInt(res.status, 16) === 1) {
                store.dispatch('UpdateTransactionSuccessfull', res)
                console.log('Refresh song list')
                store.dispatch('GetSongs')
              } else {
                store.dispatch('UpdateTransactionFailed', res)
              }
            }
          })
        }
      }
    },
    HideTokenExchangeTransaction (store, payload) {
      store.state.showTokenExchangeTransactions = null
      store.state.showTokenExchangeTransactions = {}
      store.state.showTokenExchangeTransactions[
        payload.address + payload.index
      ] = null
    },
    ShowTokenExchangeTransaction (store, payload) {
      console.log(payload)
      store.state.showTokenExchangeTransactions = null
      store.state.showTokenExchangeTransactions = {}
      store.state.showTokenExchangeTransactions[
        payload.address + payload.index
      ] = payload.txId
      console.log(store.state.showTokenExchangeTransactions)
    },
    AddTransaction (store, payload) {
      var tx = {}
      store.commit('IncreaseTransactionIndex')
      // console.log(payload);
      tx.title = payload.title
      tx.status = 'Waiting for user confirmation'
      tx.txNumber = 'N/A'
      tx.blockNumber = 'N/A'
      tx.gasUsed = 'N/A'
      tx.id = 1 // 1 - AddSong awaiting for confirmation for confirmation
      tx.index = store.getters.getTransactionIndex
      store.state.transactions.push(tx)
      store.state.refreshTransactions = true
      store.dispatch('SortTransactions')
      return tx.index
    },
    UpdateTransactionSuccessfull (store, res) {
      // console.log('Update Transaction Successfull: ', res);
      var i = store.state.transactions.findIndex(function (el, el1, el2) {
        return el.txNumber == res.transactionHash
      })
      store.state.transactions[i].status = 'Successful'
      store.state.transactions[i].txNumber = res.transactionHash
      store.state.transactions[i].id = 4
      store.state.transactions[i].blockNumber = res.blockNumber
      store.state.transactions[i].gasUsed = res.gasUsed
      store.dispatch('SortTransactions')
    },
    CloseTransaction (store, index) {
      // console.log('Close Transaction: ', index);
      var i = store.state.transactions.findIndex(function (el, el1, el2) {
        return el.index == index
      })
      store.state.transactions[i].status =
        'Finished (' + store.state.transactions[i].status + ')'
      store.state.transactions[i].id = 6
      store.dispatch('SortTransactions')
    },
    UpdateTransactionFailed (store, res) {
      var i = store.state.transactions.findIndex(function (el, el1, el2) {
        return el.txNumber == res.transactionHash
      })
      store.state.transactions[i].status = 'Failed'
      store.state.transactions[i].txNumber = res.transactionHash
      store.state.transactions[i].id = 5
      store.state.transactions[i].blockNumber = res.blockNumber
      store.state.transactions[i].gasUsed = res.gasUsed

      store.dispatch('SortTransactions')
    },
    UpdateTransactionMining (store, payload) {
      var i = store.state.transactions.findIndex(function (el, el1, el2) {
        return el.index == payload.index
      })
      store.state.transactions[i].status = 'Mining'
      store.state.transactions[i].txNumber = payload.number
      store.state.transactions[i].id = 2
      store.dispatch('SortTransactions')
    },
    UpdateTransactionCancelled (store, payload) {
      var i = store.state.transactions.findIndex(function (el, el1, el2) {
        return el.index == payload.index
      })

      store.state.transactions[i].msg = payload.msg
      store.state.transactions[i].id = 3
      store.state.transactions[i].status = 'Cancelled'

      store.dispatch('SortTransactions')
    },
    clearOldTransactions: function (store) {
      for (var i in store.state.transactions) {
        if (store.state.transactions[i].id != 1) {
          store.state.transactions.splice(i, 1)
          store.dispatch('clearOldTransactions')
          break
        }
      }
    },
    CleanTransactions (store) {
      store.state.transactions = []
    },
    SortTransactions (store) {
      store.state.transactions.sort(function (a, b) {
        if (a.index < b.index) return 1
        else return -1
      })
      if (store.state.refreshTransactions === true) {
        store.state.updatedTransactions = true
      }
    },
    updateBlockChainData (state) {
      store.state.currentStorageVersion = store.state.storageVersion
    },
    UploadPicture (store, payload) {
      axios
        .post(API + '/uploadPic', payload)
        .then(function (res) {})
        .catch(function (err) {})
    },
    DoNotRefreshTransactions (store) {
      store.state.refreshTransactions = false
    },
    GetSongs (store) {
      // console.log('Get Songs');
      store.state.refreshing = true
      if (store.state.songs.length === 0) {
        store.state.songsReady = false
        store.state.songsFailed = false
      }
      var totalSongs = 0
      var songsProcessed = 0
      axios
        .get(API + '/getSongs')
        .then(function (res) {
          var sList = res.data
          var songsList = []
          totalSongs = sList.length
          if (sList.length == 0) {
            store.state.songsReady = true
          }
          for (var i = 0; i < sList.length; i++) {
            var tmpSong = {}
            tmpSong.address = sList[i]
            songsList.push(tmpSong)
            // console.log('Get Songs...web3?');
            // console.log('web3 undefined ? ', typeof web3);
            if (typeof web3 === 'undefined') {
              var myAccount = '0x0'
            } else {
              myAccount = web3.eth.defaultAccount
            }
            axios
              .get(
                API +
                  '/getSongInformation?song=' +
                  sList[i] +
                  '&address=' +
                  myAccount
              )
              .then(function (res) {
                var tmp = {}
                tmp.address = res.data.address
                var searchAddress = tmp.address
                var index = songsList.findIndex(function (el, el1, el2) {
                  return el.address == searchAddress
                })
                songsList[index].OrderNum = index + 1
                songsList[index].Name = res.data.name
                songsList[index].Author = res.data.author
                songsList[index].Genre = res.data.genre
                songsList[index].Symbol = res.data.symbol
                songsList[index].Price = res.data.price
                songsList[index].Created = res.data.creationTime
                songsList[index].Type = res.data.entryType
                songsList[index].Id = res.data.id
                songsList[index].Decimals = res.data.decimals
                songsList[index].Contribution = res.data.contribution
                songsList[index].ownedTokens = res.data.myBalance
                songsList[index].soundcloud = res.data.soundcloud
                songsList[index].youtube = res.data.youtube
                // songsList[index].youtube =
                // 'https://www.youtube.com/watch?v=1y6smkh6c-0';
                // songsList[index].youtube = '';

                let uriParsed = URI.parse(res.data.soundcloud)
                // console.log(uriParsed);
                if (uriParsed.path.length > 0) {
                  // if (uriParsed.scheme === undefined) console.log(uriParsed);
                  // songsList[index].soundcloud = 'https://'+res.data.soundcloud
                  songsList[index].soundcloud = res.data.soundcloud
                } else {
                  songsList[index].soundcloud = ''
                }
                songsList[index].Website = res.data.website
                songsList[index].State = res.data.state
                songsList[index].FreeTokens = res.data.balance
                songsList[index].saleAddress = res.data.songSale
                songsList[index].iFrameEmbed =
                  "Soundcloud link: '" + songsList[index].soundcloud + "'"
                var searcher = tmp.address
                SC.oEmbed(songsList[index].soundcloud, {
                  auto_play: false,
                  height: 300,
                  maxheight: 300,
                  width: 200
                })
                  .then(function (embed) {
                    var indexSoundCloud = songsList.findIndex(function (
                      el,
                      el1,
                      el2
                    ) {
                      return el.address == searcher
                    })
                    songsList[indexSoundCloud].iFrameEmbed = embed.html
                    // console.log('Embed: ', embed);
                    songsList[indexSoundCloud].playable = true
                    // songsList.sort(sortFunction)
                  })
                  .catch(function (err) {
                    var indexSoundCloud = songsList.findIndex(function (
                      el,
                      el1,
                      el2
                    ) {
                      return el.address == searcher
                    })
                    songsList[indexSoundCloud].iFrameEmbed = ''
                    songsList[indexSoundCloud].playable = false
                    // console.log(
                    //   'Embed problem: ',
                    //   err,
                    //   songsList[indexSoundCloud].soundcloud
                    // );
                  })

                // songsList[index].Contribution = parseInt(res.data[7])
                songsList[index].TotalSupply = res.data.totalSupply
                // songsList[index].Phase = res.data[9]
                songsList[index].Phase = res.data.phase
                songsList[index].Owner = res.data.owner
                // songsList[index].Volume = parseInt(res.data[12])
                songsList[index].Volume = res.data.volume
                songsList[index].Bonus = res.data.bonus
                songsList[index].Description = res.data.description
                songsList[index].address = searchAddress
                // if (index == sList.length -1 ) {
                //   songsList.sort(sortFunction)
                // }
                songsProcessed++
                if (totalSongs === songsProcessed) {
                  store.state.songsReady = true

                  store.dispatch('GetPositions')
                  store.state.songsFailed = false
                  var tmpString
                  var checkSongs = songsList.sort(sortFunction)
                  for (i = 0; i < checkSongs.length; i++) {
                    tmpString = tmpString + checkSongs[i].address
                    tmpString = tmpString + checkSongs[i].ownedTokens
                    tmpString = tmpString + checkSongs[i].FreeTokens
                  }
                  // console.log('HASH: ', store.state.songsHash);
                  if (store.state.songsHash !== md5(tmpString)) {
                    store.state.songsHash = md5(tmpString)
                    store.state.songs = songsList.sort(sortFunction)
                  }
                } else {
                  if (store.state.songs.length === 0) {
                    store.state.songsReady = false
                  }
                }
              })
          }
        })
        .catch(function (err) {
          // console.log('Error: ', err);
          store.state.songsFailed = true
          store.state.refreshing = false
        })
    },
    GetPositions (store) {
      var positionsProcessed = 0
      store.state.refreshing = true
      // console.log('GetPositions');
      axios
        .get(API + '/getPositions')
        .then(function (res) {
          var positionsCount = parseInt(res.data.length)
          var positionsAdr = res.data
          var positionsList = []
          // console.log('How many positions: ', res.data.length, positionsCount);

          for (var i = 0; i < positionsCount; i++) {
            var tmpPosition = {}
            tmpPosition.index = i
            tmpPosition.address = positionsAdr[i]
            positionsList.push(tmpPosition)
            axios
              .get(API + '/getPositionInformation?position=' + positionsAdr[i])
              .then(function (res) {
                // console.log('Index i: ', i, res);
                var index = positionsList.findIndex(function (el, el1, el2) {
                  return el.address === res.data[6]
                })
                positionsList[index].token = res.data[0]
                positionsList[index].volume = res.data[1]
                positionsList[index].type = res.data[2]
                positionsList[index].date = res.data[3]
                positionsList[index].cost = res.data[4]
                positionsList[index].owner = res.data[5]
                positionsList[index].active = res.data[7]
                positionsList[index].tokenBalance = res.data[8]
                positionsList[index].weiBalance = res.data[9]
                positionsProcessed++
                if (positionsProcessed === positionsAdr.length) {
                  var tmpString
                  for (
                    i = 0;
                    i < positionsList.sort(sortFunction).length;
                    i++
                  ) {
                    for (var j in positionsList[i]) {
                      tmpString = tmpString + positionsList[i][j]
                    }
                  }
                  if (store.state.positionsHash !== md5(tmpString)) {
                    store.state.positionsHash = md5(tmpString)
                    store.state.positions = positionsList
                    store.state.positions.sort(sortFunction)
                  }
                  store.state.refreshing = false
                }
              })
              .catch(function (err) {
                // console.log('Position Information Failed ', err);
              })
          }
        })
        .catch(function (err) {
          store.state.refreshing = false
          // console.log('Get Positions Failed', err);
        })
    },
    ConnectToContract (store) {
      if (web3 === undefined) return
      var definition

      web3.currentProvider.enable()
      axios
        .get(API + '/getContract')
        .then(function (res2) {
          store.state.contractAddress = res2.data
          var contractDefinition = web3.eth.contract(smartContract)
          var exchangeContractDefinition = web3.eth.contract(
            exchangeSmartContract
          )

          store.state.web3contract = contractDefinition.at(res2.data.main)
          store.state.web3exchangeContract = exchangeContractDefinition.at(
            res2.data.exchange
          )
          store.state.ttContractOwner = res2.data.contractOwner
        })
        .catch(function (err) {})
    }
  },
  created: function () {
    this.state.API = API
    // console.log('SUPER STORE CREATED');
  }
})
