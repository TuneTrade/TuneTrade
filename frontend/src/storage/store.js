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
// const API = 'http://127.0.0.1:5000'

export const store = new Vuex.Store({
  state: {
    web3contract: {},
    web3account: '',
    owner: '',
    songs: [],
    formI: {},
    formB: {},
    formG: {},
    metaMaskLoggedOut: false,
    API:API,
    songsReady: false
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
    UploadPicture(store,payload)
    {
      console.log('UploadPicture', payload)
      axios.post(API+'/uploadPic',payload).then(function(res){
        console.log('SUCCESS:', res)
      }).catch(function(err) {
        console.log('ERROR:', err)
      })
    },
    GetSongs (store) {
      store.state.songsReady = false
      console.log('inside get sons')
      var totalSongs = 0
      var songsProcessed = 0
      axios.get(API+'/getSongs').then(function(res) {
        var sList = res.data
        console.log('sList:',sList)
        var songsList = []
        totalSongs = sList.length
        for(var i = 0;i<sList.length;i++) {
          var tmpSong = {}
          tmpSong.address = sList[i]
          songsList.push(tmpSong)
          console.log('Checking song')
          axios.get(API+'/getSongInformation?song='+sList[i]).then(function(res){
            var tmp = {}
            console.log('Song Information: ',res.data.address)
            tmp.address = res.data.address
            var searchAddress = tmp.address
            var index = songsList.findIndex(function(el,el1,el2){
              console.log("AddressIn:", searchAddress)
              return (el.address == searchAddress)
            })
            console.log('Index:',index)
            songsList[index].OrderNum = index + 1
            songsList[index].Name = res.data.name
            songsList[index].Author = res.data.author
            songsList[index].Genre = res.data.genre
            songsList[index].Symbol = res.data.symbol
            songsList[index].Price = res.data.price
            songsList[index].Created = res.data.creationTime
            songsList[index].Type = res.data.entryType
            songsList[index].Id = res.data.id
            songsList[index].Contribution = res.data.contribution
            songsList[index].soundcloud = res.data.soundcloud
            songsList[index].iFrameEmbed = 'Soundcloud link: \'' + songsList[index].soundcloud  + '\''
            var searcher =tmp.address
            SC.oEmbed(res.data.soundcloud, {auto_play: false,height: 166, maxheight: 166}).then(function (embed) {
              console.log('RM: ', embed, searcher)
              var indexSoundCloud = songsList.findIndex(function(el,el1,el2){
                return (el.address == searcher)
              })
              console.log('songList[' + indexSoundCloud + ']')
              songsList[indexSoundCloud].iFrameEmbed = embed.html
            })

            // songsList[index].Contribution = parseInt(res.data[7])
            songsList[index].TotalSupply = res.data.totalSupply
            // songsList[index].Phase = res.data[9]
            songsList[index].Phase = res.data.phase
            songsList[index].Owner = res.data.owner
            // songsList[index].Volume = parseInt(res.data[12])
            songsList[index].Volume = res.data.volume
            songsList[index].Description = res.data.description
            songsList[index].address = searchAddress
            if (index == sList.length -1 ) {
              songsList.sort(sortFunction)
            }
            songsProcessed++
            if (totalSongs == songsProcessed)
            {
              store.state.songsReady = true
            } else {
              store.state.songsReady = false
            }

            // console.log(res.data)
          })
        }
        store.state.songs = songsList.sort(sortFunction)



      }).catch(function(err){console.log(err)})
    },
    ConnectToContract (store) {
      var contractDefinition =  web3.eth.contract(smartContract)
      store.state.web3contract = contractDefinition.at('0xed878C0F543f9F77B81FE52F14128dF21527a52a')
      console.log('Web3Contract Data:', store.state.web3contract)
    }
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

  },
  created: function () {
    this.state.API = API
  }
})
