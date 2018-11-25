<template>
  <div>
    <b-card style='background-color:inheritfont-size:11px' class='detailsRowCard'>
      <b-row  class='detailsRow'>
        <b-col sm="1" class="text-sm-right">
          Name:
        </b-col>
        <b-col sm="2" class="text-sm-left detailsInformation">
          {{songName(position.token)}}
        </b-col>
        <b-col sm="1" class="text-sm-left">
          Symbol:
        </b-col>
        <b-col sm="2" class="text-sm-left detailsInformation">
          {{songSymbol(position.token)}}
        </b-col>
        <b-col sm="1" class="text-sm-left">
          Created:
        </b-col>
        <b-col sm="2" class="text-sm-left detailsInformation">
          {{getLocalTime(position.date)}}
        </b-col>
        <b-col sm="1" class="text-sm-left">
          Type:
        </b-col>
        <b-col sm="2" class="text-sm-left detailsInformation">
          {{BuyOrSell(position.type)}}
        </b-col>

      </b-row>

      <b-row  class='detailsRow'>
        <b-col sm="1" class="text-sm-right">
          Price:
        </b-col>
        <b-col sm="2" class="text-sm-left detailsInformation">
          {{positionPrice(position.volume, position.cost, position.token)}}
        </b-col>
        <b-col sm="1" class="text-sm-left">
          Volume:
        </b-col>
        <b-col sm="2" class="text-sm-left detailsInformation">
          {{positionVolume(position.token, position.volume)}}
        </b-col>
        <b-col sm="1" class="text-sm-left">
          Cost:
        </b-col>
        <b-col sm="2" class="text-sm-left detailsInformation">
          {{positionCost(position.cost)}}
        </b-col>
        <b-col sm="1" class="text-sm-left">
          Active:
        </b-col>
        <b-col sm="2" class="text-sm-left detailsInformation">
          {{YesNo(position.active)}}
        </b-col>
        </b-row>
    <b-row><b-col><br></b-col></b-row>
      <b-row  class='detailsRow'>
        <b-col sm="1" class="text-sm-right">
          ETH Deposit:
        </b-col>
        <b-col sm="2" class="text-sm-left detailsInformation">
          {{positionCost(position.weiBalance)}}
        </b-col>
        <b-col sm="1" class="text-sm-left">
          Token Deposit:
        </b-col>
        <b-col sm="2" class="text-sm-left detailsInformation">
          {{positionVolume(position.token, position.tokenBalance)}}
        </b-col>

        </b-row>
     <br>
      <b-row>
        <b-col sm="1" class="text-sm-right">
          Owner:
        </b-col>
        <b-col sm="11" class="text-sm-left detailsInformation">
          {{position.owner}}
        </b-col>
      </b-row>
      <b-row>
        <b-col sm="1" class="text-sm-right">
          Address:
        </b-col>
        <b-col sm="11" class="text-sm-left detailsInformation">
          {{position.address}}
        </b-col>
      </b-row>
      <b-row>
        <b-col sm="12" class="text-sm-center">
        <br>
        <b-button v-if="position.active" @click.stop="AcceptPosition()" variant="info"> Accept </b-button>
        <b-button v-if="!position.active && !position.type" @click.stop="DepositTokens()" variant="info"> Deposit Tokens </b-button>
        </b-col>
    </b-row>
  </b-card>
</div>

</template>

<script>
import axios from 'axios'
var BigNumber = require('bignumber.js')
// require('./saleContractdef.js')
require('./positionContract.js')
require('./songContract.js')
// SC.initialize('rZY6FYrMpGVhVDfaKEHdCaY8ALekxd8P')
import SongDetails from './SongDetails'

// SC.initialize('174155989')

var URI = require('uri-js')

var Web3 = require('web3')

export default {
  components: { 
    SongDetails
  },
  data () {
    return {
      item: {},
      sortBy: 'Created',
      modalInfo: {
        title: '',
        content: ''
      },
      sortDesc: false,
      tablefilter: '',
      currentPage: 1,
      picIteration: 0,
      musicPlayerLink: '',
      perPage: 20,
      currentIndex: -1,
      loading: -1,
      changing: -1,
      currentItem: {},
      tokensToBuy: '0',
      song: {},
      showFilters: true,
      typeDrop: 3,
      fields: [
        {
          key: 'Picture',
          sortable: false,
          label: ''
        },
        {
          key: 'Type',
          sortable: false,
          label: 'Type'
        },
        {
          key: 'Name',
          sortable: true
        },
        {
          key: 'Created',
          sortable: true,
          sortDirection: 'asc'
        },
        {
          key: 'Author',
          sortable: true
        },
        {
          key: 'Price',
          sortable: true,
          label: 'Rate [TOKEN/ETH]'
        },
        {
          key: 'Contribution',
          sortable: true,
          label: 'Contribution [ETH]'
        },
        {
          key: 'Genre',
          sortable: true
        },
        {
          key: 'show_details',
          sortable: false,
          label: '',
          tdClass: 'noPadding'
        }
      ],
      items: []
    }
  },
  props: {
  position: Object
  },
  created: function () {
 
   
  },
  methods: {
    AcceptPosition: function() {
          var that = this
          var cost = this.position.cost
          var contractDefinition =  web3.eth.contract(positionDefinition)
          var positionContract = contractDefinition.at(this.position.address)

          contractDefinition =  web3.eth.contract(songDefinition)
          var songContract = contractDefinition.at(this.position.token)

            // var volume = BigNumber(this.volume).shiftedBy(this.item.Decimals).toString()
            
            this.$store.dispatch('AddTransaction', {
                title: `Accept ${this.type} Position`
            })
            var txind = this.$store.getters.getTransactionIndex
            var type
            if (this.type === 'Buy') {
              var volume = this.position.volume

              songContract.transfer(this.position.address,volume, 
                  function (err, res) {
                  if (res !== undefined) {
                      that.$store.dispatch('UpdateTransactionMining', {
                      index: txind,
                      number: res
                      })
                  } else {
                      that.$store.dispatch('UpdateTransactionCancelled', {
                      index: txind,
                      msg: err.message
                      })
                  }
                  }
              )
                
            }
            else {
                type = false
                var valuecost = cost
              positionContract.BuyTokens({value: valuecost}, 
                  function (err, res) {
                  if (res !== undefined) {
                      that.$store.dispatch('UpdateTransactionMining', {
                      index: txind,
                      number: res
                      })
                  } else {
                      that.$store.dispatch('UpdateTransactionCancelled', {
                      index: txind,
                      msg: err.message
                      })
                  }
                  }
              )

            }

    },
    DepositTokens: function() {
      if(this.position.type == true) return

          var that = this
          var cost = this.position.cost
          var contractDefinition =  web3.eth.contract(positionDefinition)
          var positionContract = contractDefinition.at(this.position.address)

          contractDefinition =  web3.eth.contract(songDefinition)
          var songContract = contractDefinition.at(this.position.token)

            // var volume = BigNumber(this.volume).shiftedBy(this.item.Decimals).toString()
            
              var volume = this.position.volume
            this.$store.dispatch('AddTransaction', {
                title: `Activating Position. Transfering ${volume} tokens`
            })
            var txind = this.$store.getters.getTransactionIndex

              songContract.transfer(this.position.address,volume, 
                  function (err, res) {
                  if (res !== undefined) {
                      that.$store.dispatch('UpdateTransactionMining', {
                      index: txind,
                      number: res
                      })
                  } else {
                      that.$store.dispatch('UpdateTransactionCancelled', {
                      index: txind,
                      msg: err.message
                      })
                  }
                  }
              )
    },
    YesNo: function(val) {
      if(val == true) return 'Yes'
      else return 'No'
    },
    getLocalTime: function (val) {
      var ts = new Date(parseInt(val) * 1000)
      return ts.toLocaleString()
    },
    ShowSongDetails: function () {
      console.log(this.position.address)
      this.$router.push({name: 'SongDetails', params: {song: this.position.address, navigate: true}})
    },
        BuyOrSell: function (type) {
      if (type === true) return 'Buy'
      else return 'Sell'
    },
    songName: function (token) {
      var song = this.tokenSong(token)
      console.log('Song Name token: ', token, 'Name: ')
      if (song !== undefined) return song.Name
      else return 'undfined song'
    },
    songSymbol: function (token) {
      var song = this.tokenSong(token)
      if (song !== undefined) return song.Symbol
      else return 'undfined song'
    },
    positionPrice: function (volume, cost, token) {
      var song = this.tokenSong(token)
      var decimals = song.Decimals
      return BigNumber(cost).div(volume).shiftedBy(decimals - 18).toFormat(6)
    },
    positionCost: function (cost) {
      return BigNumber(cost).shiftedBy(-18).toFormat(6)
    },
    positionVolume: function (token, volume) {
      var song = this.tokenSong(token)
      var decimals = 0 - song.Decimals
      return BigNumber(volume).shiftedBy(decimals).toFormat(6)
    },
    tokenSong: function (token) {
      console.log('Checking token song: ', token)
      return this.$store.getters.getSong(token)
    },
  }
  
}
</script>
<style lang='css'>
</style>