<template lang="html">
  <div class="" style="margin:0px 0px;min-height:600px">
    <b-modal @ok.prevent="AddPosition()" hide-footer hide-header ref="NewPositionModal" size="lg" centered
        class="" >
      <NewPosition :song="contractAddress"/>
    </b-modal>
    <b-container fluid style="padding:0px;" >
      <!-- FILTER AND SEARCH NAV BAR -->
      <b-container  fluid class="navbarBox h-100">
      <b-container class="h-100">
      <b-navbar toggleable="md"  class=" navbar-dark p-0 my-2 mx-0">
              <b-container class="w-100 h-100 text-center p-0 ">
                <b-row class=" w-100">
                  <b-col cols=12 md=auto class="text-lg-left text-center" >
                    <div style="display:inline" class="">
                      <div style="display:inline-flex" class="">
                        <b-form-input id ="searchInput" class="searchBox " type="text" placeholder="Search" v-model="tablefilter">
                        </b-form-input>
                        <div class="iconBorder">
                        <font-awesome-icon icon="search" class="searchIcon" /> 
                        </div>
                      </div>
                    </div> 
                  </b-col>
                  <b-col cols=12 class="d-md-none text-lg-left text-center">
                  <b-dropdown class="d-inlilne-block" toggle-class="testToggle" menu-class="testMenu"  :text="dropdownText">
                <b-dropdown-item v-bind:class="{selectedType: type=='All','bg-dark text-white': type != 'All'}" v-on:click="filterType('All')">All </b-dropdown-item>
                <b-dropdown-item size="sm"  v-on:click="filterType('Sell')"  v-bind:class="{selectedType: type=='Sell','bg-dark text-white': type != 'Sell'}">Sell</b-dropdown-item>
                <b-dropdown-item size="sm" v-on:click="filterType('Buy')"  v-bind:class="{selectedType: type=='Buy','bg-dark text-white': type != 'Buy'}">Buy</b-dropdown-item>
                <b-dropdown-item size="sm" v-on:click="filterType('Mine')"  v-bind:class="{selectedType: type=='Mine','bg-dark text-white': type != 'Mine'}">My positions</b-dropdown-item>
              </b-dropdown>
                  </b-col>
                  <b-col cols=6 md=auto class="  p-0 text-left ">

          <b-collapse is-nav id=" w-100 p-0" >
            <b-nav-form class="filterBox  w-100 p-0">
              <b-button size="sm" v-on:click="filterType('All')" class="mx-md-1 mx-xl-2 typeButton" v-bind:class="{selectedType: type=='All'}"
                type="submit">ALL </b-button>
              <b-button size="sm" v-on:click="filterType('Sell')" class="mx-md-1 mx-xl-2   typeButton" v-bind:class="{selectedType: type=='Sell'}"
                type="submit">SELL</b-button>
              <b-button size="sm" v-on:click="filterType('Buy')" class="mx-md-1 mx-xl-2  typeButton" type="submit" v-bind:class="{selectedType: type=='Buy'}">BUY</b-button>
              <b-button size="sm" v-on:click="filterType('Mine')" class="mx-md-1 mx-xl-2  typeButton" type="submit" v-bind:class="{selectedType: type=='Mine'}">MY POSITIONS</b-button>
            </b-nav-form>
          </b-collapse>
                  </b-col>
                    <!-- {{contractProp}} {{filterBySong}}  -->
                  <b-col  cols=12 class="text-center text-md-left" v-if="contractProp">
                    <b-button @click.stop="ToggleFilterBySong()"  class="mt-2 typeButton" v-bind:class="{selectedType:filterBySong==true}">Filter by: {{songName(contractProp)}}</b-button>
                  </b-col>
                </b-row>
              </b-container>


      </b-navbar>
      </b-container>
      </b-container>


      <!-- END OF FILTER AND SEARCH NAV BAR -->
      <b-container fluid class="navbarBox mx-0 p-0">
      </b-container>
      <b-container class="mx-auto  p-0 mx-0">

        <b-table v-if="songsReady" :items="salesItems"  :fields="salesFields" tbody-tr-class="TokeExchangeTableRow" tbody-class="tableBodyClass" tbody-td-class="test"
        thead-class="headerClass" thead-tr-class="TokeExchangeTableRow" class="songsTable" :filter="filterFunction" ref="tabelka">
        <template slot="show_details" slot-scope="row">
          <b-button :disabled="refreshing" size="sm" @click.stop="row.toggleDetails" variant="info" class="detailsButton">     {{
    row.detailsShowing ? 'Hide' : 'Show'}} details </b-button>
          <br>
          <!-- {{tokensForEth(row.item.Price,row.item.Decimals)}} -->
        </template>
        <template slot="type" slot-scope="row">{{BuyOrSell(row.item.type)}}</template>
        <template slot="date" slot-scope="row">{{getLocalTime(row.item.date)}}</template>

        <template slot="name" slot-scope="row">{{songName(row.item.token)}}</template>

        <template slot="symbol" slot-scope="row">{{songSymbol(row.item.token)}}</template>
        <template slot="price" slot-scope="row">{{positionPrice(row.item.volume,row.item.cost, row.item.token)}}</template>
        <template slot="cost" slot-scope="row">{{positionCost(row.item.cost)}}</template>
        <template slot="volume" slot-scope="row">{{positionVolume(row.item.token,row.item.volume)}} {{songSymbol(row.item.token)}}</template>

        <!-- <template slot="owner" slot-scope="row">{{MeOrNot(row.item.owner)}}</template> -->
        <template slot="accept" slot-scope="row">
  <b-button
    v-if="row.item.active"
    variant="info"
    @click.stop="AcceptPosition(row)"
    class="detailsButton"
  >{{BuyOrSell(!row.item.type)}}</b-button>
</template>
     
        <template slot="sm_details" slot-scope="row">
  <div @click.stop="row.toggleDetails">
    <font-awesome-icon
      @click.stop="row.toggleDetails"
      v-if="!row.detailsShowing"
      icon="angle-up"
      class="arrow fa-2x"
    />
    <font-awesome-icon
      @click.stop="row.toggleDetails"
      v-if="row.detailsShowing"
      icon="angle-down"
      class="arrow fa-2x"
    />
  </div>
</template>
<template slot="smscreen" slot-scope="row" >
  <div
    class="text-left m-1 text-truncate d-block p-0 m-0"
    @click.stop="CloseAll(row) ;row.toggleDetails"
  >
    <b-container class="m-0">
      <b-row class="p-0 m-0">
        <b-col cols="10" class="mx-0 p-0">
          Name: {{songName(row.item.token)}}
          <br>
          Symbol: {{songSymbol(row.item.token)}}
          <br>
          Price: {{positionPrice(row.item.volume,row.item.cost, row.item.token)}} ETH
          <br>
          Cost: {{positionCost(row.item.cost)}}
          <br>
          Date: {{getLocalTime(row.item.date)}}
        </b-col>
      </b-row>
    </b-container>
  </div>
</template>
        <template slot="row-details" slot-scope="row" style="padding:0px;">
  <br>
  <b-button
    size="sm"
    @click.stop="ShowSongDetails(row.item.token, row.item.index)"
    variant="info"
    class="m-0"
  >{{showSong(row.item.token,row.item.index) ? 'Position' : 'Token'}} Details</b-button>
  <br>
  <br>
  <PositionDetails
    v-if="!showSong(row.item.token,row.item.index) && !canShowTransaction(row.item.address,row.item.index)"
    v-bind:position="row.item"
  />
  <SongDetails
    v-if="showSong(row.item.token, row.item.index) && !canShowTransaction(row.item.address,row.item.index)"
    v-bind:song="row.item.token"
    :navigate="true"
  />
  <OneTransaction
    v-if="canShowTransaction(row.item.address,row.item.index)"
    v-bind:id="canShowTransaction(row.item.address,row.item.index)"
  ></OneTransaction>
  <br>
  <br>
</template>
      </b-table>
                    <div class="loadingSpin" v-if="!songsReady"> 
        <center> 
          <font-awesome-icon  icon="spinner" class="fa-2x fa-pulse refreshIcon" />
           <br> Loading... </center>
      </div>
    </b-container>
    </b-container>
  </div>
</template>
<script>

import PositionDetails from './PositionDetails'
import SongDetails from './SongDetails'
import NewPosition from './NewPosition'
import OneTransaction from './OneTransaction'

var BigNumber = require('bignumber.js')

export default {
  props: {
    filterProp: String,
    contractProp: String
  },
  components: {
    PositionDetails,
    SongDetails,
    NewPosition,
    OneTransaction
  },
  data() {
    return {
      type: 'All',
      contractAddress: null,
      tablefilter: '',
      filterSong: null,
      showSongs: [],
      showTransactions: [],
      transactionId: null,
      filterBySong: false,
      filterOptions: [
        { value: 0, text: 'All' },
        { value: 1, text: 'Sell' },
        { value: 2, text: 'Buy' },
        { value: 3, text: 'Mine' }
      ],
      salesFields: [
        {
          key: 'type',
          sortable: true,
          label: 'Type:',
          thClass: 'py-2 text-left pl-2 ',
          tdClass: 'py-2 text-left pl-3 '

        },
        {          key: 'smscreen',
          sortable: false,
          thClass: 'd-table-cell d-sm-none text-left pl-2  ',
          tdClass: 'd-table-cell d-sm-none py-2 text-left pl-2 ',
          label: ''
        },
        {
          key: 'date',
          sortable: true,
          label: 'Date:',
          tdClass: 'd-lg-table-cell d-none  text-left pl-2 ',
          thClass: 'd-lg-table-cell d-none py-2 text-left pl-2 '
        },
        {
          key: 'name',
          sortable: true,
          label: 'Name:',
          tdClass: 'd-sm-table-cell d-none  text-left pl-2 ',
          thClass: 'd-sm-table-cell d-none py-2 text-left pl-2 '
        },
        {
          key: 'symbol',
          sortable: true,
          label: 'Symbol:',
          tdClass: 'd-sm-table-cell d-none  text-left pl-2 ',
          thClass: 'd-sm-table-cell d-none py-2 text-left pl-2 '
        },
        {
          key: 'price',
          sortable: true,
          label: 'Cost Per Token<br>[ETH]',
          tdClass: 'd-sm-table-cell d-none text-left pl-2 ',
          thClass: 'd-sm-table-cell d-none py-2 text-left pl-2 '
        },
        {
          key: 'volume',
          sortable: true,
          tdClass: 'd-md-table-cell d-none text-left pl-2 ',
          thClass: 'd-md-table-cell d-none py-2 text-left pl-2 ',
          label: 'Trade Amount'
        },
        {
          key: 'cost',
          sortable: true,
          label: 'Total Price<br>[ETH]',
          tdClass: 'd-sm-table-cell d-none  text-left pl-2 ',
          thClass: 'd-sm-table-cell d-none py-2 text-left pl-2 '
        },
        {
          key: 'accept',
          sortable: true,
          label: 'Buy/Sell',
          tdClass: 'd-xl-table-cell d-none text-left pl-2  ',
          thClass: 'd-xl-table-cell d-none py-2 text-left pl-2 '
        },
        {
          key: 'show_details',
          sortable: false,
          label: '',
          tdClass: 'd-lg-table-cell d-none text-left pl-2 ',
          thClass: 'd-lg-table-cell d-none py-2 text-left pl-2 '
        },
        {
          key: 'sm_details',
          sortable: false,
          label: '',
          tdClass: 'd-lg-none d-table-cell text-left pr-2  ',
          thClass: 'd-lg-none d-xl-none py-2 text-left pl-2 '
        }
      ]
    }
  },
  computed: {
    songsReady: function () {
      return this.$store.state.songsReady;
    },
    dropdownText: function () {
      if (this.type === 'Mine') return 'My positions'
      return this.type
    },
    refreshing: function () {
      return this.$store.state.refreshing
    },
    canAddPosition: function () {
      if (this.contractAddress.length > 0) return true
      else return false
    },
    salesItems: function () {
      return this.$store.state.positions
    }
  },
  created: function () {
    // this.$store.dispatch('GetPositions')
    this.type = this.filterProp
    this.contractAddress = this.contractProp
    if (typeof (this.type) === 'undefined') this.type = 'All'
    if (typeof (this.contractAddress) === 'undefined') {
      this.contractAddress = ''
      this.filterSong = null
    } else {
      this.filterSong = this.$store.getters.getSong(this.contractAddress)
    }
    if (!this.contractProp) this.filterBySong = false
    else this.filterBySong = true
  },
  watch: {
    contractAddress: function (val) {
      if (val === '') {
        this.filterSong = null
      } else {
        this.filterSong = this.$store.getters.getSong(this.contractAddress)
      }
    }
  },
  methods: {
    AcceptPosition: function (position) {
      if (!position.detailsShowing) { position.toggleDetails() }
      var that = this
      var cost = position.item.cost
      var contractDefinition = web3.eth.contract(positionDefinition)
      var positionContract = contractDefinition.at(position.item.address)

      contractDefinition = web3.eth.contract(songDefinition)
      var songContract = contractDefinition.at(position.item.token)
      // var volume = BigNumber(this.volume).shiftedBy(this.item.Decimals).toString()

      this.$store.dispatch('AddTransaction', {
        title: `Accept ${this.BuyOrSell(position.item.type)}  "${this.songName(position.item.token)}"  Position`
      })
      var txind = this.$store.getters.getTransactionIndex
      this.showTransaction(position.item.address, position.item.index, txind)

      this.transactionId = txind
      var type
      if (position.item.type) {
        var volume = position.item.volume

        songContract.transfer(position.item.address, volume,
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
        positionContract.BuyTokens({ value: valuecost },
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
    ToggleFilterBySong: function () {
      this.filterBySong = !this.filterBySong
    },
    CloseAll: function (row) {
      // this.$refs.tabelka.items[0].toggleDetails()
      // console.log(this.$refs.tabelka.$el.rows)
      console.log(row)
      // this.$refs.tabelka.$el.rows[0].toggleDetails()
    },
    MeOrNot: function (owner) {
      if (owner.toLowerCase() !== this.$store.state.web3account) {
        return owner
      } else {
        return 'Me'
      }
    },
    getLocalTime: function (val) {
      var ts = new Date(parseInt(val) * 1000)
      return ts.toLocaleString()
    },
    BuyOrSell: function (type) {
      if (type === true) return 'Buy'
      else return 'Sell'
    },
    songName: function (token) {
      var song = this.tokenSong(token)
      // console.log('Song Name token: ', token, 'Name: ')
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
      // console.log('Checking token song: ', token)
      return this.$store.getters.getSong(token)
    },
    SongOrBand: function (val) {
      switch (parseInt(val)) {
        case 0:
          return 'Song'
        case 1:
          return 'Band'
        case 2:
          return 'Influencer'
        case 3:
          return 'All'
        default:
          return 'Error'
      }
    },
    NewPosition: function () {
      this.$refs.NewPositionModal.show()
    },
    canShowTransaction(adr, index) {
      console.log('getters.showTokenExchangeTransactions(adr, index)', this.$store.getters.showTokenExchangeTransactions(adr, index))
      return (this.$store.getters.showTokenExchangeTransactions(adr, index))

    },
    hideTransaction(adr, index) {
      this.$store.dispatch('HideTokenExchangeTransaction', { address: adr, index: index })
    },
    showTransaction(adr, index, txind) {
      this.$store.dispatch('ShowTokenExchangeTransaction', { address: adr, index: index, txId: txind })
    },
    showSong: function (adr, index) {
      if (typeof (adr) === 'undefined') return false
      if (typeof (this.showSongs[adr + index]) !== 'undefined') return this.showSongs[adr + index]
      else return false
    },
    ShowSongDetails: function (address, index) {
      this.showSongs[address + index] = !this.showSongs[address + index]
      this.hideTransaction(address, index)
      console.log(this.showSongs)
      console.log(`this.showSongs[${address}] === ${this.showSongs[address]}`)
      console.log(address)
      // this.showSongs = new Array(this.showSongs)
      this.showSongs.sort()
    },
    escapeRegExp: function (string) {
      return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') // $& means the whole matched string
    },
    filterType: function (type) {
      this.type = type
      this.contractAddress = ''
    },
    filterFunction: function (item) {
      var itemStr
      // if (this.type === 'All') return true
      // if (!(this.type === 'All' || this.type === 'Mine') && this.type !== item.type) return false
      if (this.type === 'Mine' && item.owner.toLowerCase() !== this.$store.state.web3account) {
        // console.log(`${item.owner} !== ${this.$store.state.web3account}`)
        return false
      }
      if (this.type === 'Sell' && item.type !== false) return false
      if (this.type === 'Buy' && item.type !== true) return false

      // console.log('ITEM:', item)
      let token = item.token
      itemStr = this.songName(token) + ' ' + this.songSymbol(token) + ' ' + this.BuyOrSell(item.type) + ' ' + this.positionPrice(item.volume, item.cost, token) + ' ' + this.MeOrNot(item.owner) + this.positionVolume(token, item.volume) + ' ' + this.positionCost(item.cost) + ' ' + this.getLocalTime(item.date)

      // positionPrice: function (volume, cost, token) {
      // positionVolume: function (token, volume) {
      // for (var val in item) {
      //   // console.log(item[val])
      //   if (item[val] === undefined) continue
      //   if (item[val] !== undefined && typeof item[val] === 'string') {
      //     itemStr += item[val] + ' '
      //   } else {
      //     itemStr += item[val].toString() + ' '
      //   }
      // }
      console.log('Filter: ', itemStr)
      var re = new RegExp(this.escapeRegExp(this.tablefilter.toLowerCase()))
      if (this.filterBySong) {
        return (this.contractAddress === item.token && re.test(itemStr.toLowerCase()))
      }
      else {
        if (this.tablefilter.length > 0) {
          return (re.test(itemStr.toLowerCase()))
        } else return true
      }

    }
  }
}
</script>
<style lang="css">
</style>