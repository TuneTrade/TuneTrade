<template lang="html">
  <div class="" style="margin:0px 0px;min-height:600px">
    <b-modal @ok.prevent="AddPosition()" hide-footer hide-header ref="NewPositionModal" size="lg" centered
        class="" >
      <NewPosition :song="contractAddress"/>
    </b-modal>
    <b-container fluid style="padding:0px;" >
      <!-- Filter Type: {{type}} <br>
      Filter Prop: {{filterProp}} <br>
      Contract Address: {{contractAddress}}<br>
      Contract Prop: {{contractProp}} -->
      <b-container   fluid class="navbarBox" style="margin:0px; height:80px;">
        <b-container  class="">
          <div class="filterContainer">
            <!-- <div v-if="!showFilters"/> -->
            <b-navbar toggleable="md" style="padding:0px;">
              <b-nav-form class="filterBox" style="">
              <div style="display:grid;grid-template-columns:1fr auto;padding:0px;">
                <input type="text" class="searchBox" placeholder="Search" v-model="tablefilter">
                <font-awesome-icon icon="search" class=" searchIcon" />
              </div>
                <b-button size="sm" v-on:click="filterType('All')" class="my-2 my-sm-0 typeButton" v-bind:class="{selectedType: type=='All'}"
                  type="submit">ALL</b-button>
                <b-button size="sm" v-on:click="filterType('Sell')" class="my-2 my-sm-0 typeButton" v-bind:class="{selectedType: type=='Sell'}"
                  type="submit">SALE</b-button>
                <b-button size="sm" v-on:click="filterType('Buy')" class="my-2 my-sm-0 typeButton" type="submit"
                  v-bind:class="{selectedType: type=='Buy'}">PURCHASE</b-button>
                <b-button size="sm" v-on:click="filterType('Mine')" class="my-2 my-sm-0 typeButton" type="submit"
                  v-bind:class="{selectedType: type=='Mine'}">MY POSITIONS</b-button>
                  <div/>
                <b-button size="sm"  v-bind:disabled="!canAddPosition" @click.stop="NewPosition()" class="my-2 my-sm-0" variant="info">
                  CREATE NEW POSITION
                </b-button>

                <div />
              </b-nav-form>
            </b-navbar>
              <div v-if="filterSong" style="font-family:Roboto;color: #eee;">
                  Open position to <b>{{BuyOrSell(type)}}</b> {{SongOrBand(filterSong.Type)}} "{{filterSong.Name}}"
              </div>
            <div />
          </div>
        </b-container>
      </b-container>
      <b-container fluid class="navbarBox">
      </b-container>
      <b-container>
        <b-table :items="salesItems" :fields="salesFields" tbody-tr-class="test" tbody-class="test" tbody-td-class="test"
        thead-class="headerClass" thead-tr-class="headerClass" class="songsTable" :filter="filterFunction">
        <template slot="show_details" slot-scope="row">
          <b-button :disabled="refreshing" size="sm" @click.stop="row.toggleDetails" variant="info" class="detailsButton"> Show details </b-button>
          <br>
          <!-- {{tokensForEth(row.item.Price,row.item.Decimals)}} -->
        </template>
        <template slot="type" slot-scope="row">
          {{BuyOrSell(row.item.type)}}
        </template>
        <template slot="date" slot-scope="row">
          {{getLocalTime(row.item.date)}}
        </template>

        <template slot="name" slot-scope="row">
          {{songName(row.item.token)}}
        </template>

        <template slot="symbol" slot-scope="row">
          {{songSymbol(row.item.token)}}
        </template>
        <template slot="price" slot-scope="row">
          {{positionPrice(row.item.volume,row.item.cost, row.item.token)}}
        </template>
        <template slot="cost" slot-scope="row">
          {{positionCost(row.item.cost)}}
        </template>
        <template slot="volume" slot-scope="row">
          {{positionVolume(row.item.token,row.item.volume)}}
        </template>

        <template slot="owner" slot-scope="row">
          {{MeOrNot(row.item.owner)}}
        </template>

        <template slot="row-details" slot-scope="row" style="padding:0px;">
  <br>
  <b-button
    size="sm"
    @click.stop="ShowSongDetails(row.item.token, row.item.index)"
    variant="info"
    class=""
  >{{showSong(row.item.token,row.item.index) ? 'Position' : 'Token'}} Details</b-button>
  <br>
  <br>
  <PositionDetails v-if="!showSong(row.item.token,row.item.index)" v-bind:position="row.item"/>
  <SongDetails v-if="showSong(row.item.token, row.item.index)" v-bind:song="row.item.token" :navigate="true"/>
  <br>
  <br>
</template>
      </b-table>
    </b-container>
    </b-container>
  </div>
</template>
<script>

import PositionDetails from './PositionDetails'
import SongDetails from './SongDetails'
import NewPosition from './NewPosition'
var BigNumber = require('bignumber.js')

export default {
  props: {
    filterProp: String,
    contractProp: String
  },
  components: {
    PositionDetails,
    SongDetails,
    NewPosition
  },
  data () {
    return {
      type: 'All',
      contractAddress: null,
      tablefilter: '',
      filterSong: null,
      showSongs: [],
      salesFields: [
        { key: 'type', sortable: true, label: 'Type:' },
        { key: 'date', sortable: true, label: 'Date:' },
        { key: 'name', sortable: true, label: 'Name:' },
        { key: 'symbol', sortable: true, label: 'Symbol:' },
        { key: 'price', sortable: true, label: 'Price [ETH/Token]' },
        { key: 'volume', sortable: true, label: 'Volume [Token]' },
        { key: 'cost', sortable: true, label: 'Cost [ETH]' },
        { key: 'owner', sortable: true, label: 'Owner' },
        { key: 'show_details', sortable: true, label: '' }
      ]
    }
  },
  computed: {
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
    showSong: function (adr, index) {
      if (typeof (adr) === 'undefined') return false
      if (typeof (this.showSongs[adr + index]) !== 'undefined') return this.showSongs[adr + index]
      else return false
    },
    ShowSongDetails: function (address, index) {
      this.showSongs[address + index] = !this.showSongs[address + index]
      console.log(this.showSongs)
      console.log(`this.showSongs[${address}] === ${this.showSongs[address]}`)
      console.log(address)
      // this.showSongs = new Array(this.showSongs)
      this.showSongs.sort()
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
        console.log(`${item.owner} !== ${this.$store.state.web3account}`)
        return false
      }
      if (this.type === 'Sell' && item.type !== false) return false
      if (this.type === 'Buy' && item.type !== true) return false

      for (var val in item) {
        // console.log(item[val])
        if (item[val] === undefined) continue
        if (item[val] !== undefined && typeof item[val] === 'string') {
          itemStr += item[val] + ' '
        } else {
          itemStr += item[val].toString() + ' '
        }
      }
      var re = new RegExp(this.tablefilter.toLowerCase())
      return (re.test(itemStr.toLowerCase()) && (this.contractAddress === '' || this.contractAddress === item.token))
    }
  }
}
</script>
<style lang="css">
</style>