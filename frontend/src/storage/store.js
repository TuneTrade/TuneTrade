import Vuex from 'vuex'
import vueResource from 'vue-resource'
import Vue from 'vue'
import axios from 'axios'
import vueAxios from 'vue-axios'
Vue.use(axios);

// import vueAxios from 'vue-axios'
// import smartContract from './contractdef.js'
// import {web3} from 'web3'
var Web3 = require('web3')
// import web3 from 'web3'
require('./contractdef')
// var VueWeb3 = require('vue-web3')
// Vue.use(VueWeb3, { web3: new Web3(web3.currentProvider) })
// import web3 from 'web3'
Vue.use(Vuex)
// Vue.use(web3)
Vue.use(vueResource)
var URI = require("uri-js");

// function hex2a(hexx) {
//     var hex = hexx.toString();//force conversion
//     var str = '';
//     for (var i = 2; i < hex.length; i += 2){
//       if(parseInt(hex.substr(i, 2), 16) == 0) continue;
//         str += String.fromCharCode(parseInt(hex.substr(i, 2), 16))
//       }
//     return str
// }

function sortFunction(a,b) {
  return 0
  if (a.Name >b.Name) return 1
  else return -1
}

const API = 'https://tunetrade-backend.herokuapp.com'
// const API = 'http://127.0.0.1:5000'

export const store = new Vuex.Store({
  state: {

    refreshing: false,
    web3contract: {},
    web3account: '',
    owner: '',
    songs: [],
    formI: {},
    formB: {},
    formG: {},
    lastUpdate: null,
    contractAddress: '',
    metaMaskLoggedOut: false,
    API:API,
    songsReady: false,
    transactions: [],
    transactionIndex: 0,
    updatedTransactions: false,
    intervalNumber: 0
  },
  getters: {
    getCountryList: state => {
      return state.countries
    },
    getCountry: (state) => (_ccode) => {
      return state.countries.find(country => country.ccode === _ccode)
    },
    getTransactionIndex: function(state) {
      return state.transactionIndex
    }
  },
  mutations: {
    UpdateFormG(state, payload) {
      state.formG = payload
    },
    IncreaseTransactionIndex(state) {
      state.transactionIndex++
      return 7
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
    GetSongsList(state,payload) {
      axios.get(API+'/getSongs').then(function(res){
      })
      // state.web3contract.GetSongs(function(err,res){
        // state.songs = res;
      // })
    }

  },
  actions: {
    StartCheckingTransactions (store) {
      let s = store
      store.state.intervalNumber = setInterval(function() {
        s.dispatch('checkTransaction')
        console.log('Check')
      },5000)
    },
    clearUpdatedTransactions (store) {
      store.state.updatedTransactions = false
    },
    checkTransaction (store) {
      var transactions = store.state.transactions
      // console.log('Checking transactions')
      // console.log(transactions)
      store.state.lastUpdate = new Date(Date.now()).toLocaleString()
      console.log('time:', store.state.lastUpdate)
      for (var i in transactions) {
        var tx = transactions[i]
        if (tx.id === 4 || tx.id === 5 || tx.id === 3) {
          store.dispatch('CloseTransaction', tx.index)
          continue
        }
        if (tx.id == 2) {
          console.log('Transaction pending')

          web3.eth.getTransactionReceipt(tx.txNumber,function(err, res) {
            if (res !== null) {
              if (parseInt(res.status,16) === 1) {
                store.dispatch('UpdateTransactionSuccessfull', res)
                store.dispatch('GetSongs')
              } else {
                store.dispatch('UpdateTransactionFailed', res)
              }
            }
          })
        }
      }
    },
    AddTransaction (store, payload) {
      var tx = {}
      store.commit('IncreaseTransactionIndex')
      console.log(payload)
      tx.title = payload.title
      tx.status = "Waiting for user confirmation"
      tx.txNumber = 'N/A'
      tx.blockNumber = 'N/A'
      tx.gasUsed = 'N/A'
      tx.id = 1 // 1 - AddSong awaiting for confirmation for confirmation
      tx.index = store.getters.getTransactionIndex
      store.state.transactions.push(tx)
      store.dispatch('SortTransactions')
      return tx.index
    },
    UpdateTransactionSuccessfull (store, res)
    {
      console.log('Update Transaction Successfull: ', res)
      var i = store.state.transactions.findIndex(function(el,el1,el2){
        return (el.txNumber == res.transactionHash)
      })
      store.state.transactions[i].status = 'Successful'
      store.state.transactions[i].txNumber = res.transactionHash
      store.state.transactions[i].id = 4
      store.state.transactions[i].blockNumber = res.blockNumber
      store.state.transactions[i].gasUsed = res.gasUsed
      store.dispatch('SortTransactions')
    },
    CloseTransaction (store, index)
    {
      console.log('Close Transaction: ', index)
      var i = store.state.transactions.findIndex(function(el,el1,el2){
        return (el.index == index)
      })
      store.state.transactions[i].status = 'Finished (' +  store.state.transactions[i].status + ')'
      store.state.transactions[i].id = 6
      store.dispatch('SortTransactions')
    },
    UpdateTransactionFailed (store, res)
    {
      var i = store.state.transactions.findIndex(function(el,el1,el2){
        return (el.txNumber == res.transactionHash)
      })
      store.state.transactions[i].status = 'Failed'
      store.state.transactions[i].txNumber = res.transactionHash
      store.state.transactions[i].id = 5
      store.state.transactions[i].blockNumber = res.blockNumber
      store.state.transactions[i].gasUsed = res.gasUsed
      store.dispatch('SortTransactions')
    },
    UpdateTransactionMining (store, payload)
    {
      var i = store.state.transactions.findIndex(function(el,el1,el2){
        return (el.index == payload.index)
      })
      store.state.transactions[i].status = 'Mining'
      store.state.transactions[i].txNumber = payload.number
      store.state.transactions[i].id = 2
      store.dispatch('SortTransactions')
    },
    UpdateTransactionCancelled(store, payload)
    {
      var i = store.state.transactions.findIndex(function(el,el1,el2){
        return (el.index == payload.index)
      })

      store.state.transactions[i].msg = payload.msg
      store.state.transactions[i].id = 3
      store.state.transactions[i].status = 'Cancelled'
      store.dispatch('SortTransactions')

    },
    clearOldTransactions: function (store)
    {
      for (var i in store.state.transactions) {
        if (store.state.transactions[i].id != 1) {
          store.state.transactions.splice(i,1)
          store.dispatch('clearOldTransactions')
          break;
        }
      }
    },
    CleanTransactions (store) {
      store.state.transactions = []
    },
    SortTransactions(store) {
      store.state.transactions.sort(function(a,b) {
        if (a.index < b.index) return 1
        else return -1
      })
      store.state.updatedTransactions = true
    },
    updateBlockChainData (state) {
      store.state.currentStorageVersion = store.state.storageVersion
    },
    UploadPicture(store,payload)
    {
      axios.post(API+'/uploadPic',payload).then(function(res){
      }).catch(function(err) {
      })
    },
    GetSongs (store) {
      store.state.refreshing = true
      if (store.state.songs.length === 0) {
        store.state.songsReady = false
      }
      var totalSongs = 0
      var songsProcessed = 0
      axios.get(API+'/getSongs').then(function(res) {
        var sList = res.data
        var songsList = []
        totalSongs = sList.length
        if(sList.length == 0 ) store.state.songsReady = true
        for(var i = 0;i<sList.length;i++) {
          var tmpSong = {}
          tmpSong.address = sList[i]
          songsList.push(tmpSong)
          axios.get(API+'/getSongInformation?song='+sList[i]).then(function(res){
            var tmp = {}
            tmp.address = res.data.address
            var searchAddress = tmp.address
            var index = songsList.findIndex(function(el,el1,el2){
              return (el.address == searchAddress)
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
            songsList[index].soundcloud = res.data.soundcloud
            let uriParsed = URI.parse(res.data.soundcloud)
            console.log(uriParsed)
            if (uriParsed.path.length > 0) {
              if(uriParsed.scheme === undefined)
              console.log(uriParsed)
              songsList[index].soundcloud = 'https://'+res.data.soundcloud
            } else {
              songsList[index].soundcloud = ''

            }
            songsList[index].Website = res.data.website
            songsList[index].State = res.data.state
            songsList[index].FreeTokens = res.data.balance
            songsList[index].saleAddress = res.data.songSale
            songsList[index].iFrameEmbed = 'Soundcloud link: \'' + songsList[index].soundcloud  + '\''
            var searcher =tmp.address
            SC.oEmbed(songsList[index].soundcloud, {auto_play: false,height: 300, maxheight: 300, width:200}).then(function (embed) {
              var indexSoundCloud = songsList.findIndex(function(el,el1,el2){
                return (el.address == searcher)
              })
              songsList[indexSoundCloud].iFrameEmbed = embed.html
              console.log('Embed: ', embed)
              songsList[indexSoundCloud].playable = true
              songsList.sort(sortFunction)

            }).catch(function (err) {
              var indexSoundCloud = songsList.findIndex(function(el,el1,el2){
                return (el.address == searcher)
              })
              songsList[indexSoundCloud].iFrameEmbed = ''
              songsList[indexSoundCloud].playable = false
              console.log('Embed problem: ', err, songsList[indexSoundCloud].soundcloud )

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
            if (index == sList.length -1 ) {
              songsList.sort(sortFunction)
            }
            songsProcessed++
            if (totalSongs == songsProcessed)
            {
              store.state.songs = songsList.sort(sortFunction)
              store.state.songsReady = true
              store.state.refreshing = false

            } else {
              if (store.state.songs.length === 0) store.state.songsReady = false
            }
          })
        }
      }).catch(function(err){

      })
    },
    ConnectToContract (store) {
      axios.get(API+'/getContract').then(function(res) {
        store.state.contractAddress = res.data
        var contractDefinition =  web3.eth.contract(smartContract)
        store.state.web3contract = contractDefinition.at(res.data)
      }).catch(function(err) {
      })
    }
  },
  created: function () {
    this.state.API = API
    console.log('SUPER STORE CREATED')
  }
})
