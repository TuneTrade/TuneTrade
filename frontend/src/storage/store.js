import Vue from 'vue'
import Vuex from 'vuex'
import vueResource from 'vue-resource'
import axios from 'axios'
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
Vue.use(axios)

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
    GetSongs(state,payload) {
      console.log("contract from mutation:",state.web3contract)
      state.web3contract.GetSongs(function(err,res){
        console.log("Songs:",res)
        state.songs = res;
      })
    }

  },
  actions: {
    updateBlockChainData (state) {
      store.state.currentStorageVersion = store.state.storageVersion
    },
    ConnectToContract (store) {
      // console.log(myweb3)
      // console.log('Definition',smartContract)
      // console.log(myweb3.eth)
      // var contractDefinition = new myweb3.eth.contract(smartContract)
      var contractDefinition =  web3.eth.contract(smartContract)
      // console.log(contractDefinition)
      store.state.web3contract = contractDefinition.at('0x4b00b36e9af06348a83ca5bee00f6b216f017ac5')
      store.state.web3contract.GetSongs(function(err,res){
        var songList = []
        for(var i = 0;i<res.length;i++) {
          var tmpSong = {}
          tmpSong.address = res[i]
          songList.push(tmpSong)
          store.state.web3contract.GetSongDetailsPart1(res[i],function(err,res){
            var tmp = {}
            /* string name;
            string author;
            string genre;
            uint price;
            uint creationTime;
            bool isBand;
            uint contribution;
            uint totalSupply;
            uint8 phase; // 1 - pre-sale, 2 - ico1, 3 - ico2, 4 - ico 3; 5 - post ico, 6 - finished, 0 - not running.
            address owner;
            address contractAddress; */
            tmp.address = res[5]
            var searchAddress = tmp.address
            var index = songList.findIndex(function(el,el1,el2){
              console.log("AddressIn:", searchAddress)
              // console.log("This address in:", el.address)
              return (el.address == searchAddress)
            })
            songList[index].Name = res[0]
            songList[index].Author = res[1]
            songList[index].Genre = res[2]
            songList[index].Price = res[3].toString()
            console.log('Price:',res[3].toString())
            songList[index].Created = res[4]
          })

          store.state.web3contract.GetSongDetailsPart2(res[i],function(err,res){
            var tmp = {}
            tmp.address = res[5]
            var searchAddress = tmp.address
            var index = songList.findIndex(function(el,el1,el2){
              console.log("AddressIn:", searchAddress)
              // console.log("This address in:", el.address)
              return (el.address == searchAddress)
            })
            songList[index].Type = res[0]
            songList[index].Contribution = parseInt(res[1])
            songList[index].TotalSupply = res[2]
            songList[index].Phase = res[3]
            songList[index].Owner = res[4]
            songList[index].Volume = parseInt(res[6])
            songList[index].address = searchAddress
            songList.sort(sortFunction)

        })
        console.log("SongList:",songList)
      }
      store.state.songs = songList.sort(sortFunction)
      store.state.songs.sort(sortFunction)

    })
      }

  }
})
