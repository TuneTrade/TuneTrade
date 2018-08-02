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
  console.log('a.Name b.Name:',a.Name,b.Name)
  return 0
  if (a.Name >b.Name) return 1
  else return -1
}

const API = 'https://tunetrade-backend.herokuapp.com'

export const store = new Vuex.Store({
  state: {
    web3contract: {},
    web3account: '',
    owner: '',
    songs: []
  },
  getters: {
    getCountryList: state => {
      return state.countries
    },
    getCountry: (state) => (_ccode) => {
      return state.countries.find(country => country.ccode === _ccode)
    }
  },
  mutations: {
    UpdatePrice (state, payload) {
      // console.log('Update price: ' + payload.ccode + ' '+payload.price)
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
    //   console.log("contract from mutation:",state.web3contract)
    //   state.web3contract.GetSongs(function(err,res){
    //     console.log("Songs:",res)
    //     state.songs = res;
    //   })
    // }
    GetSongsList(state,payload) {
      console.log("contract from mutation:",state.web3contract)
      axios.get(API+'/getSongs').then(function(res){
        console.log(res.data)
      })
      // state.web3contract.GetSongs(function(err,res){
        // console.log("Songs:",res)
        // state.songs = res;
      // })
    }

  },
  actions: {
    updateBlockChainData (state) {
      store.state.currentStorageVersion = store.state.storageVersion
    },
    GetSongs (store) {
      console.log('inside get sons')
      axios.get(API+'/getSongs').then(function(res) {
        var sList = res.data
        console.log('sList:',sList)
        var songsList = []
        for(var i = 0;i<sList.length;i++) {
          var tmpSong = {}
          tmpSong.address = sList[i]
          songsList.push(tmpSong)
          console.log('Checking song')
          axios.get(API+'/getSongInformation?song='+sList[i]).then(function(res){
            var tmp = {}

            tmp.address = res.data[5]
            var searchAddress = tmp.address
            var index = songsList.findIndex(function(el,el1,el2){
              console.log("AddressIn:", searchAddress)
              return (el.address == searchAddress)
            })
            console.log('Index:',index)
            songsList[index].OrderNum = index + 1
            songsList[index].Name = res.data[0]
            songsList[index].Author = res.data[1]
            songsList[index].Genre = res.data[2]
            songsList[index].Price = res.data[3].toString()
            songsList[index].Created = res.data[4]
            songsList[index].Type = res.data[6]
            songsList[index].Contribution = parseInt(res.data[7])
            songsList[index].TotalSupply = res.data[8]
            songsList[index].Phase = res.data[9]
            songsList[index].Owner = res.data[10]
            songsList[index].Volume = parseInt(res.data[12])
            songsList[index].address = searchAddress
            if (index == sList.length -1 ) {
              songsList.sort(sortFunction)
            }

            console.log('Price:',res[3].toString())
            console.log('Song:',res.data)
            // console.log(res.data)
          })
        }
        store.state.songs = songsList.sort(sortFunction)


      }).catch(function(err){console.log(err)})
    },
    // ConnectToContract (store) {
    //   var contractDefinition =  web3.eth.contract(smartContract)
    //   store.state.web3contract = contractDefinition.at('0x38cb8f8995b1e811db10182b303913039ae2dacc')
    //   store.state.web3contract.GetSongs(function(err,res){
    //     var songList = []
    //     for(var i = 0;i<res.length;i++) {
    //       var tmpSong = {}
    //       tmpSong.address = res[i]
    //       songList.push(tmpSong)
    //       store.state.web3contract.GetSongDetailsPart1(res[i],function(err,res){
    //         var tmp = {}
    //
    //         tmp.address = res[5]
    //         var searchAddress = tmp.address
    //         var index = songList.findIndex(function(el,el1,el2){
    //           console.log("AddressIn:", searchAddress)
    //           return (el.address == searchAddress)
    //         })
    //         songList[index].OrderNum = index
    //         songList[index].Name = res[0]
    //         songList[index].Author = res[1]
    //         songList[index].Genre = res[2]
    //         songList[index].Price = res[3].toString()
    //         console.log('Price:',res[3].toString())
    //         songList[index].Created = res[4]
    //       })
    //
    //       store.state.web3contract.GetSongDetailsPart2(res[i],function(err,res){
    //         var tmp = {}
    //         tmp.address = res[5]
    //         var searchAddress = tmp.address
    //         var index = songList.findIndex(function(el,el1,el2){
    //           console.log("AddressIn:", searchAddress)
    //           return (el.address == searchAddress)
    //         })
    //         songList[index].Type = res[0]
    //         songList[index].Contribution = parseInt(res[1])
    //         songList[index].TotalSupply = res[2]
    //         songList[index].Phase = res[3]
    //         songList[index].Owner = res[4]
    //         songList[index].Volume = parseInt(res[6])
    //         songList[index].address = searchAddress
    //         songList.sort(sortFunction)
    //
    //     })
    //     console.log("SongList:",songList)
    //   }
    //   store.state.songs = songList.sort(sortFunction)
    //   store.state.songs.sort(sortFunction)
    //
    // })
    //   }

  }
})
