<template>
    <b-card style='background-color:inheritfont-size:11px' class='detailsRowCard'>
    <b-row>
      <b-col sm='2' class='text-sm-left'>
        <!-- <img v-bind:src='picLink(item.Id)' width=140px height=140px></img> -->
        <b-img blank-color='#777' v-bind:src='picLink(item.Id)' width='150'/>
      </b-col>
      <b-col sm='10'>
        <b-row>
          <b-col sm='8'>
            <b-row class='detailsRow'>
              <b-col sm='6'>
                <b-row class='detailsRow'>
                  <b-col sm='4' class='text-sm-left'>Type:</b-col>
                  <b-col
                    sm='8'
                    class='text-sm-left detailsInformation'
                  >{{ SongOrBand(item.Type) }}</b-col>
                </b-row>
                <b-row class='detailsRow'>
                  <b-col sm='4' class='text-sm-left'>Name:</b-col>
                  <b-col
                    sm='8'
                    class='text-sm-left detailsInformation'
                  >&quot{{ item.Name }}&quot</b-col>
                </b-row>
                <b-row class='detailsRow'>
                  <b-col sm='4' class='text-sm-left'>Author:</b-col>
                  <b-col sm='8' class='text-sm-left detailsInformation'>{{ item.Author }}</b-col>
                </b-row>
                <b-row class='detailsRow'>
                  <b-col sm='4' class='text-sm-left'>Price [{{item.Symbol}}/ETH]:</b-col>
                  <b-col
                    sm='8'
                    class='text-sm-left detailsInformation'
                  >{{tokensForEth(item.Price,item.Decimals)}}</b-col>
                </b-row>
                <b-row class='detailsRow'>
                  <b-col sm='4' class='text-sm-left'>Phase:</b-col>
                  <b-col sm='8' class='text-sm-left detailsInformation'>{{Phase(item.State)}}</b-col>
                </b-row>
                <b-row class='detailsRow'>
                  <b-col sm='4' class='text-sm-left'>Website:</b-col>
                  <b-col sm='8' class='text-sm-left detailsInformation'>
                    <b-link
                      class='text-primary'
                      target='_blank'
                      v-bind:href='WebsiteLink(item.Website)'
                      variant='danger'
                    >{{WebsiteLink(item.Website)}}</b-link>
                  </b-col>
                </b-row>
              </b-col>
              <b-col sm='6'>
                <b-row class='detailsRow'>
                  <b-col sm='5' class='text-sm-left'>Contribution [ETH]:</b-col>
                  <b-col
                    sm='7'
                    class='text-sm-left detailsInformation'
                  >{{ Price(item.Contribution) }}</b-col>
                </b-row>
                <b-row class='detailsRow'>
                  <b-col sm='5' class='text-sm-left'>Volume [{{item.Symbol}}]:</b-col>
                  <b-col sm='7' class='text-sm-left detailsInformation'>
                    {{BigValue(item.Volume,item.Decimals)
                    }}
                  </b-col>
                </b-row>
                <b-row class='detailsRow'>
                  <b-col sm='5' class='text-sm-left'>Total Supply [{{item.Symbol}}]:</b-col>
                  <b-col sm='7' class='text-sm-left detailsInformation'>
                    {{BigValue(item.TotalSupply,item.Decimals) }}
                  </b-col>
                </b-row>
                  <b-row class='detailsRow'>
                    <b-col sm='5' class='text-sm-left'>Decimals:</b-col>
                    <b-col sm='7' class='text-sm-left detailsInformation'>{{item.Decimals}}</b-col>
                  </b-row>
                  <b-row class='detailsRow'>
                    <b-col sm='5' class='text-sm-left'>Genre:</b-col>
                    <b-col sm='7' class='text-sm-left detailsInformation'>{{ item.Genre }}</b-col>
                  </b-row>
                  <b-row class='detailsRow'>
                    <b-col sm='5' class='text-sm-left'>Created:</b-col>
                    <b-col
                      sm='7'
                      class='text-sm-left detailsInformation'
                    >{{ getLocalTime( item.Created )}}</b-col>
                </b-row>
              </b-col>
              </b-row>
              <b-row class='detailsRow'>
                  <b-col sm='12' class='text-sm-center'>
                    <p style='font-size:14px'><br><b>Your balance:</b> {{item.ownedTokens}} 0 {{item.Symbol}}</p>
                  </b-col>
                </b-row>
                <b-row class='detailsRow'>
                  <b-col sm='12' class='text-sm-center'>
                      <b-button v-if='tokenOnSale(item.State)' @click.stop='ShowBuyModal(item)'
                        variant='info' class='buyCoinButton'>
                        BUY COIN
                      </b-button>
                      <b-button  :to='{name: 'TokenExchange', params: {filterProp: 'Sale', contractProp: item.address}}'
                        variant='info' class='buyCoinButton'>
                        Buy on the Market
                      </b-button>
                      <b-button :to='{name: 'TokenExchange', params: {filterProp: 'Purchase', contractProp: item.address}}'
                        variant='info' class='buyCoinButton'>
                        Sell on the Market
                      </b-button>
                      <br>
                  </b-col>
                </b-row>
              </b-col>
              
              <b-col sm='4'>
                <b-row class='detailsRow'>
                  <b-col sm='12' class='text-sm-left'>Owner <span v-if='isMyToken(item.Owner)' class=''> (My token)</span>:</b-col>
                </b-row>
                <b-row class='detailsRow'>
                  <b-col sm='12' class='text-sm-left detailsInformation' v-bind:class='{myTokenAddress: isMyToken(item.Owner)}'>{{item.Owner}}</b-col>
                </b-row>
                <b-row class='detailsRow'>
                  <b-col sm='12' class='text-sm-left'>
                    <b-link
                      target='_blank'
                      style='text-align:left'
                      class='text-primary'
                      v-bind:href='etherscanAddress(item.Owner)'
                      variant='danger'
                    >Etherscan</b-link>
                  </b-col>
                </b-row>
                <b-row class='detailsRow'>
                  <b-col sm='12' class='text-sm-left'>Token address:</b-col>
                </b-row>
                <b-row class='detailsRow'>
                  <b-col sm='12' class='text-sm-left detailsInformation'>{{item.address}}</b-col>
                </b-row>
                <b-row class='detailsRow'>
                  <b-col sm='12' class='text-sm-left'>
                    <b-link
                      target='_blank'
                      style='text-align:left'
                      class='text-primary'
                      v-bind:href='etherscanToken(item.address)'
                      variant='danger'
                    >Etherscan</b-link>
                  </b-col>
                </b-row>
                <b-row class='detailsRow'>
                  <b-col sm='12' class='text-sm-left'>Sale address:</b-col>
                </b-row>
                <b-row class='detailsRow'>
                  <b-col sm='12' class='text-sm-left detailsInformation'>{{item.saleAddress}}</b-col>
                </b-row>
                <b-row class='detailsRow'>
                  <b-col sm='12' class='text-sm-left'>
                    <b-link
                      target='_blank'
                      style='text-align:left'
                      class='text-primary'
                      v-bind:href='etherscanToken(item.saleAddress)'
                      variant='danger'
                    >Etherscan</b-link>
                  </b-col>
                </b-row>
              </b-col>
            </b-row>
          </b-col>
         </b-row>
  
        <b-row class='detailsRow'>
          <b-col sm='12' class='text-justify'>
            <p style=''>{{item.Description}}</p>
          </b-col>
        </b-row>
        <b-row class='detailsRow'>
          <b-col v-if='item.playable' sm='6' class='embedTD'>
            <!-- <b-link>{{item.soundcloud}}</b-link> -->
            <div v-if='item.playable' v-html='item.iFrameEmbed'>test</div>
          </b-col>
          <b-col v-if='item.playable' sm='6' class='embedTD'>
            <!-- <b-link>{{item.soundcloud}}</b-link> -->
            <div v-if='item.playable' v-html='item.iFrameEmbed'></div>
          </b-col>
        </b-row>
        <b-row class='detailsRow'>
          <b-col sm='12' class='text-sm-center'>
            <b-button
              v-if='tokenOnSale(item.State)'
              @click.stop='ShowBuyModal(item)'
              variant='info'
              class='buyCoinButton'
            >BUY COIN</b-button>
          </b-col>
        </b-row>
      </b-col>
    </b-row>
  </b-card>
</template>

<script>
import axios from 'axios'
var BigNumber = require('bignumber.js')
var SC = require('soundcloud')
require('./saleContractdef.js')
SC.initialize('rZY6FYrMpGVhVDfaKEHdCaY8ALekxd8P')

// SC.initialize('174155989')

var URI = require('uri-js')

var Web3 = require('web3')

export default {
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
  song: Object
  },
  created: function () {
    this.$store.dispatch('GetSongs')
    this.item = this.song
  },
  methods: {
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
    BuyTokens () {
      var saleContractDef = web3.eth.contract(saleContractDefinition)
      var saleContract = saleContractDef.at(this.currentItem.saleAddress)
      var weiAmount = this.tokensPriceWeiBigNumber()
      var that = this
      console.log('Wei Amount: ', weiAmount.toString())
      console.log(this.currentItem.saleAddress)
      this.$refs.BuyTokensModal.hide()
      this.$store.dispatch('AddTransaction', {
        title:
          'Buying ' +
          this.tokensToBuy +
          ' tokens ' +
          this.currentItem.Symbol +
          ' on blockchain'
      })
      var txind = this.$store.getters.getTransactionIndex
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
      return (web3.toChecksumAddress(adr) === web3.toChecksumAddress(web3.eth.defaultAccount)) 
    },
    filterFunction: function (item) {
      var itemStr
      if (this.typeDrop < 3 && item.Type !== this.typeDrop) return false
      if (this.typeDrop == 4) {
        console.log('TEST ITEM:', item.Owner)
        console.log(`${web3.toChecksumAddress(web3.eth.defaultAccount)} == ${web3.toChecksumAddress(item.Owner)}`)
        if (!this.isMyToken(item.Owner)) return false
        // console.log(web3.eth.defaultAccount)
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
      // return 'https://source.unsplash.com/random/480x480'
    },
    isPlaying: function (rowNumber) {
      if (this.currentIndex === rowNumber) return true
      else return false
    }
  },
  computed: {
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
.player:hover {
  filter: invert(100%) hue-rotate(120deg);
}

a {
  color: #fafafa;
}

.unPlayable {
  opacity: 0;
  pointer-events: none;
}
</style>