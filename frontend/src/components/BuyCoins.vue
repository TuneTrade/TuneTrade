<template>
  <!-- <b-modal
      v-if="currentItem != null"
      @ok.prevent="BuyTokens()"
      hide-header
      ref="BuyTokensModal"
      size="lg"
      ok-title="Buy"
      :ok-disabled="cantBuyTokens"
      class="buyModal d-none d-lg-block"
  >-->
  <b-container class="my-4 px-4 w-100 mx-0">
    <b-row>
      <b-col class="mt-3">
        <img style="height:50px" src="../assets/metamask.png">
      </b-col>
      <b-col cols="12">
        <b-button
          variant="info"
          @click.stop="ShowSongDetails()"
          class="buyCoinButton mt-3"
        >Song Details</b-button>
      </b-col>
    </b-row>
    <b-row class="mt-5 pl-5 md-0">
      <b-col cols="4" sm="5" md="3" lg="2" class="text-left">Name:</b-col>
      <b-col cols="8" sm="7" md="3" lg="2" class="text-left text-sm-left p-0">{{currentItem.Name}}</b-col>
      <b-col cols="4" sm="5" md="3" lg="1" class="text-left">Rate [{{currentItem.Symbol}}/ETH]:</b-col>
      <b-col
        cols="8"
        sm="7"
        md="3"
        lg="3"
        class="text-left p-0 pl-lg-3 text-truncate"
      >{{tokensForEth(currentItem.Price, currentItem.Decimals)}}</b-col>
      <b-col cols="4" sm="5" md="3" lg="2" class="text-left">Rate [{{currentItem.Symbol}}/WEI]:</b-col>
      <b-col
        cols="8"
        sm="7"
        md="3"
        lg="2"
        class="text-left p-0"
        style
      >{{tokensForWei(currentItem.Price, currentItem.Decimals)}}</b-col>
      <b-col cols="4" sm="5" md="3" lg="2" class="text-left">Current bonus:</b-col>
      <b-col cols="8" sm="7" md="3" lg="2" class="text-left p-0">+{{currentItem.Bonus}}%</b-col>
      <b-col cols="4" sm="5" md="3" lg="1" class="text-left">Available tokens:</b-col>
      <b-col
        cols="8"
        sm="7"
        md="3"
        lg="3"
        class="text-left p-0 pl-lg-3"
      >{{availableTokens}} {{currentItem.Symbol}}</b-col>
      <b-col cols="4" sm="5" md="3" lg="2" class="text-left">Decimals:</b-col>
      <b-col
        cols="8"
        sm="7"
        md="3"
        lg="2"
        class="text-left p-0"
      >{{localNumber(currentItem.Decimals)}}</b-col>
    </b-row>
    <b-row class="mt-3 mb-5">
      <b-col cols="12" md="12" lg="6" class="mt-4">
        <b-row>
          <b-col cols="12" class="text-center">Sale Contract Address:</b-col>
          <b-col cols="12" class="p-0 text-center">{{currentItem.saleAddress}}</b-col>
        </b-row>
      </b-col>
      <b-col cols="12" md="12" lg="6" class="mt-4">
        <b-row>
          <b-col cols="12" class="text-center">Token Contract Address:</b-col>
          <b-col cols="12" class="text-center p-0">{{currentItem.address}}</b-col>
        </b-row>
      </b-col>
    </b-row>
    <b-row class="mt-4">
      <b-col cols="12" class="text-center">
        <b>Minimum amount to buy:</b>
      </b-col>
      <b-col
        cols="12"
        class="text-center p-0 mt-1"
      >{{tokensStep(currentItem.Price,currentItem.Decimals)}}</b-col>
    </b-row>

    <b-row class="mt-3">
      <b-col cols="12" class="text-center">
        <b-form>
          <b-form-input
            style="width:200px; height:2rem"
            id="tokensToBuyInput"
            type="text"
            v-model="tokensToBuy"
            required
            size="sm"
            placeholder="How many tokens ?"
            class="mx-auto mb-3"
          ></b-form-input>
          <b-form-group
            id="tokensToBuyGroup"
            label="How many tokens ?"
            label-for="tokenstoBuyInput"
          ></b-form-group>
          <span style="color:#FF634B;">
            <b>{{cantBuyTokensMsg}}</b>
          </span>
        </b-form>
      </b-col>
    </b-row>
    <b-row>
      <b-col cols="12">
        <b-button
          variant="info"
          :disabled="cantBuyTokensMsg"
          class="buyCoinButton"
          @click="BuyTokens()"
        >Buy</b-button>
      </b-col>
    </b-row>
    <b-row class="mt-4 pl-sm-4 pl-0">
      <b-col sm="4" lg="5" class>
        <b-row>
          <b-col cols="5" sm="12" class="text-right text-sm-center">Tokens (+bonus):</b-col>
          <b-col cols="7" sm="12" class="text-left text-sm-center">{{tokensAndBonus}}</b-col>
        </b-row>
      </b-col>
      <b-col sm="4" lg="2" class>
        <b-row>
          <b-col cols="5" sm="12" class="text-right text-sm-center">You will pay [ETH]:</b-col>
          <b-col cols="7" sm="12" class="text-left text-sm-center">{{tokensPriceEth()}}</b-col>
        </b-row>
      </b-col>
      <b-col sm="4" lg="5" class>
        <b-row>
          <b-col cols="5" sm="12" class="text-right text-sm-center">You will pay [WEI]:</b-col>
          <b-col
            cols="7"
            sm="12"
            class="text-left text-sm-center"
          >{{tokensPriceWei(currentItem.Price, tokensToBuy)}}</b-col>
        </b-row>
      </b-col>
    </b-row>
  </b-container>

  <!-- <b-button v-if="navigate" @click.stop="GoBack()" size="sm" variant>Back</b-button> -->
  <!-- <br><br> -->
</template>

<script>
import axios from 'axios'
var BigNumber = require('bignumber.js')
// var SC = require('soundcloud')
require('./saleContractdef.js')

var URI = require('uri-js')
var Web3 = require('web3')

export default {
  data() {
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
      showFilters: true,
      typeDrop: 3,

    }
  },
  props: {
    song: String,
    navigate: Boolean
  },
  created: function () {
    this.item = this.$store.getters.getSong(this.song)
    this.currentItem = this.item
    console.log('Adres: ', this.song)
    console.log(this.item)

  },
  methods: {
    ShowSongDetails: function () {
      this.$store.state.showBuyCoins = null
      this.$store.state.showBuyCoins = {}
      this.$store.state.showBuyCoins[this.song] = false
    },
    GoBack: function () {
      this.$router.go(-1)
    },
    showHideFilters: function () {
      this.showFilters = !this.showFilters
    },
    WebsiteLink: function (address) {
      let uriParsed = URI.parse(address)
      if (uriParsed.path.length > 0) {
        if (uriParsed.scheme === undefined) console.log(uriParsed)
        return 'http://' + address
      } else {
        return null
      }
    },
    tokenOnSale: function (state) {
      if (state === undefined) return false
      if (state === 'Presale') return true
      if (state === 'Main Sale') return true
      return false
    },
    Phase: function (state) {
      if (state === undefined) return 'Not on sale'
      if (state.length > 0) return state
      return 'Not on sale'
    },
    ValidateTokens: function () {
      if (this.tokensToBuy === 0) return
      if (isNaN(this.tokensToBuy)) return
      if (this.tokensToBuy.length === 0) return
      let step = this.tokensStep(
        this.currentItem.Price,
        this.currentItem.Decimals
      )
      step = BigNumber(step)
      console.log('STEP: ', step.toString())
      let numberofStep = BigNumber(this.tokensToBuy).div(step)
      let tmpTokens = numberofStep.times(step)
      if (tmpTokens.gt(this.availableTokens)) {
        tmpTokens = BigNumber(this.availableTokens)
      }
      if (tmpTokens.lt(step)) {
        this.tokensToBuy = BigNumber(step)
      }
      this.tokensToBuy = tmpTokens.toString()
    },
    ShowTransactions(id) {
      this.$store.state.showTransactions = null
      this.$store.state.showTransactions = {}
      this.$store.state.showTransactions[this.currentItem.address] = id
      this.$store.state.showBuyCoins = null
      this.$store.state.showBuyCoins = {}
    },
    BuyTokens() {
      if (typeof (web3) === 'undefined') return
      var saleContractDef = web3.eth.contract(saleContractDefinition)
      var saleContract = saleContractDef.at(this.currentItem.saleAddress)
      var weiAmount = this.tokensPriceWeiBigNumber()
      var that = this
      this.$store.dispatch('AddTransaction', {
        title:
          'Buying ' +
          this.tokensToBuy + ' ' +
          this.currentItem.Symbol
      })
      var txind = this.$store.getters.getTransactionIndex
      this.ShowTransactions(txind)
      saleContract._eth.sendTransaction(
        {
          value: weiAmount.toString(),
          to: this.currentItem.saleAddress
        },
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
    ShowBuyModal: function (item) {
      this.currentItem = item
      this.$refs.BuyTokensModal.show()
    },
    tokensForEth: function (rate, decimals) {
      if (rate === undefined) return null
      if (decimals === undefined) decimals = 0
      var weiInEth = Web3.utils.toWei('1', 'ether')
      decimals = parseInt(decimals)
      var ret = BigNumber(rate)
        .times(weiInEth)
        .shiftedBy(-decimals)
        .toFormat()
      return ret
    },
    tokensForWei: function (rate, decimals) {
      if (rate === undefined) return null
      if (decimals === undefined) decimals = 0
      let dec = parseInt(decimals)
      let r = BigNumber(rate)
      return r.shiftedBy(-dec).toFormat()
    },
    tokensStep: function (rate, decimals) {
      if (rate === undefined) return null
      if (decimals === undefined) decimals = 0
      let r = BigNumber(rate)
      r = r.shiftedBy(-decimals)
      return r.toFormat()
    },
    tokensPriceWei: function (rateInWei, tokensAmount) {
      let decimals = parseInt(this.currentItem.Decimals)
      if (isNaN(decimals)) return 0
      let amount = BigNumber(tokensAmount).shiftedBy(decimals)
      return amount.div(rateInWei).toFormat()
    },
    tokensPriceWeiBigNumber: function (rateInWei, tokensAmount) {
      let amount = BigNumber(this.tokensToBuy)
      let rate = BigNumber(this.currentItem.Price)
      let decimals = parseInt(this.currentItem.Decimals)
      if (isNaN(decimals)) return 0
      return amount.shiftedBy(decimals).div(rate)
    },
    tokensPriceEth: function () {
      let amount = BigNumber(this.tokensToBuy)
      let rate = BigNumber(this.currentItem.Price)
      let decimals = parseInt(this.currentItem.Decimals)
      let weiInEth = BigNumber(Web3.utils.toWei('1', 'ether'))
      if (isNaN(decimals)) return 0
      return amount
        .shiftedBy(decimals)
        .div(rate)
        .div(weiInEth)
        .toFormat()
    },
    filterType: function (type) {
      this.typeDrop = type
    },
    isMyToken: function (adr) {
      if (typeof (web3) === 'undefined') return false
      return (web3.toChecksumAddress(adr) === web3.toChecksumAddress(web3.eth.defaultAccount))
    },
    filterFunction: function (item) {
      var itemStr
      if (this.typeDrop < 3 && item.Type !== this.typeDrop) return false
      if (this.typeDrop == 4) {
        if (!this.isMyToken(item.Owner)) return false
      }
      for (var val in item) {
        // console.log(item[val])
        if (item[val] === undefined) continue
        if (item[val] !== undefined && typeof item[val] === 'string') {
          itemStr += item[val]
        } else {
          itemStr += item[val].toString()
        }
      }
      var re = new RegExp(this.tablefilter.toLowerCase())
      return re.test(itemStr.toLowerCase())
    },
    getRelated: function (link) {
      axios
        .get(
          'http://api.soundcloud.com/resolve?url=' +
          link +
          '&client_id=rZY6FYrMpGVhVDfaKEHdCaY8ALekxd8P'
        )
        .then(function (res) { })
    },
    etherscanToken: function (address) {
      if (address.length === 0) return null
      return 'https://ropsten.etherscan.io/token/' + address
    },
    etherscanAddress: function (address) {
      return 'https://ropsten.etherscan.io/address/' + address
    },
    Price: function (priceInWei) {
      if (priceInWei === undefined) return 0
      let value = BigNumber(priceInWei)
      if (value === null) return 0
      if (value.isNaN()) return value.toString()
      //Convert price in Wei to ETH. 1 ETH == 10^18 Wei. So we shift it by 18 places.
      return value.shiftedBy(-18).toFormat()
    },
    info(item, index, button) {
      // this.modalInfo.title = `Row index: ${index}`
      // this.modalInfo.content = JSON.stringify(item, null, 2)
      this.$root.$emit('bv::show::modal', 'modalInfo', button)
    },
    resetModal() { },
    getLocalTime: function (val) {
      var ts = new Date(parseInt(val) * 1000)
      return ts.toLocaleString()
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
    // uint8 phase // 1 - pre-sale, 2 - ico1, 3 - ico2, 4 - ico 3 5 - post ico, 6 - finished, 0 - not running.
    PhaseToString: function (val) {
      if (isNaN(val)) return val
      var number = parseInt(val)
      switch (number) {
        case 0:
          return 'not running'
        case 1:
          return 'Pre sale'
        case 2:
          return 'ICO 1'
        case 3:
          return 'ICO 2'
        case 4:
          return 'ICO 3'
        case 5:
          return 'Post ICO'
        case 6:
          return 'Finished'
      }
    },
    onError: function () {
      alert('error')
    },
    onAbort: function () {
      alert('aborted')
    },
    loaded: function () {
      if (this.loading >= 0) {
        this.loading = -1
      }
    },
    isLoading: function (index) {
      if (this.changing === index || this.loading === index) {
        return true
      } else {
        return false
      }
    },
    playMusic: function (index, link) {
      var that = this
      if (index === this.currentIndex) {
        this.currentIndex = -1
        this.musicPlayerLink = ''
        return
      }
      this.currentIndex = index
      this.changing = index
      this.musicPlayerLink = ''
      setTimeout(function () {
        that.changing = -1
        that.loading = index
        SC.oEmbed(link, {
          auto_play: true
        })
          .then(function (em) {
            that.musicPlayerLink = em.html
            that.loading = -1
          })
          .catch(function (err) { })
      }, 100)
    },
    localNumber: function (val) {
      if (isNaN(val)) return val
      var entry = parseFloat(val)
      var num = entry.toLocaleString()
      return num
    },
    BigValue: function (val, dec) {
      if (isNaN(val)) return val
      var num = BigNumber(val)
      let decimals = parseInt(dec)
      return num.shiftedBy(-decimals).toFormat()
    },
    picLink: function (id) {
      console.log('Pic Link:', id)
      if (id === undefined) {
        return null
      }
      return this.$store.state.API + '/getPicture?id=' + id
      console.log('Picture ID')
      // return 'https://source.unsplash.com/random/480x480'
    },
    isPlaying: function (rowNumber) {
      if (this.currentIndex === rowNumber) return true
      else return false
    }
  },
  computed: {
    transactions: function () {
      var that = this
      return this.$store.state.transactions.filter(function (tx) {
        if (that.pending) {
          return (tx.id !== 6)
        } else {
          return true
        }
      })
    },
    tokensAndBonus: function () {
      let tokensToBuy = BigNumber(this.tokensToBuy)
      let bonus = this.currentItem.Bonus
      return tokensToBuy
        .times(100 + bonus)
        .div(100)
        .toString()
    },
    availableTokens: function () {
      let free = BigNumber(this.currentItem.FreeTokens)
      let decimals = parseInt(this.currentItem.Decimals)
      if (isNaN(decimals)) return 0
      return free.shiftedBy(-decimals).toFormat()
    },
    cantBuyTokens: function () {
      if (typeof (web3) === 'undefined') return true
      if (isNaN(this.tokensToBuy)) return true
      let freeTokens = BigNumber(this.currentItem.FreeTokens)
      let tokensToBuy = BigNumber(this.tokensToBuy)
      let decimals = BigNumber(this.currentItem.Decimals)
      if (decimals.isNaN()) return true
      console.log('Decimals: ', decimals.sd())
      let maxValue = freeTokens.shiftedBy(-decimals.toNumber())
      console.log('MaX:', maxValue.toFormat())
      if (freeTokens.lt(tokensToBuy)) return true
      let step = this.tokensStep(
        this.currentItem.Price,
        this.currentItem.Decimals
      )
      let numberofStep = tokensToBuy.div(step).dp(0, 1)
      if (numberofStep === null) return true
      console.log('numberofStep: ', numberofStep)
      step = BigNumber(step)
      let correctValue = numberofStep.times(step)
      if (!correctValue.eq(tokensToBuy)) return true
      if (correctValue.lt(step)) return true
      if (correctValue.gt(maxValue)) return true
    },
    cantBuyTokensMsg: function () {
      if (typeof (web3) === 'undefined') return 'Metamask is not installed.'
      if (isNaN(this.tokensToBuy)) return 'This is not a number'
      let freeTokens = BigNumber(this.currentItem.FreeTokens)
      let tokensToBuy = BigNumber(this.tokensToBuy)
      let decimals = BigNumber(this.currentItem.Decimals)
      let tokensAndBonus = BigNumber(this.tokensAndBonus)
      if (decimals.isNaN()) return null
      console.log('Decimals: ', decimals.sd())
      let maxValue = freeTokens.shiftedBy(-decimals.toNumber())
      console.log('MaX:', maxValue.toFormat())
      let step = this.tokensStep(
        this.currentItem.Price,
        this.currentItem.Decimals
      )
      let numberofStep = tokensToBuy.div(step).dp(0, 1)
      if (numberofStep === null) return true
      console.log('numberofStep: ', numberofStep)
      step = BigNumber(step)
      let correctValue = numberofStep.times(step)
      if (correctValue.lt(step))
        return 'You have to buy minimum ' + step.toFormat() + ' tokens'
      if (!correctValue.eq(tokensToBuy))
        return 'You have to buy mutliplication of minimum token amount.'
      if (tokensAndBonus.gt(maxValue)) return 'Not enough available tokens.'
    },

    noSongs: function () {
      return this.songs.length === 0
    },

    typeDropText: function () {
      return 'Type (' + this.SongOrBand(this.typeDrop) + ')'
    },

    songsReady: function () {
      return this.$store.state.songsReady
    },

    songs: function () {
      return this.$store.state.songs
    },

    totalRows: function () {
      return this.songs.length
    },

    songsCounter: function () {
      if (this.$store.state.songs !== undefined) {
        return this.$store.state.songs.length
      } else {
        return 0
      }
    }
  }
}
</script>
<style lang='css'>
</style>