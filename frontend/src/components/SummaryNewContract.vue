<template>
  <div class="newContractForm">
    <h4>Token Summary</h4>
    <b-container class="px-0">
      <b-row class="mb-4">
        <b-col md="auto" cols="12">
          <b-button
            :disabled="!isFormValid"
            type="submit"
            @click="onSubmit()"
            style="margin:10px 0px;background-color:#17a2b8"
          >Create My Tokens</b-button>
          <!-- IcoTX: {{icotx}} SongTx: {{songtx}} -->
        </b-col>
        <b-col cols="12" lg="4" md="6" class>
          <OneTransaction v-bind:id="songtx" style="background-color:#223749"/>
        </b-col>
        <b-col cols="12" lg="4" md="6">
          <OneTransaction v-bind:id="icotx" style="background-color:#223749"/>
        </b-col>
      </b-row>
    </b-container>
    <span style="font-size:13px;color:red;padding:0px;margin:0px" v-if="web3undefined">
      <br>It looks like Metamask is not installed in this browser.
      <br>
      <br>
    </span>
    <b-card no-body class="mb-1 summarySectionTitle m-0">
      <b-card-header header-tag="header" class="p-1 summarySectionTitle" role="tab" style>
        <div v-b-toggle.accordion1 class="summarySectionTitle">General</div>
      </b-card-header>
      <b-collapse id="accordion1" visible accordions="my-accordion" role="tabpanel" class="p-0 m-0">
        <b-card-body class="contractTab m-0">
          <b-container>
            <!-- GENERAL SUMMARY CONTAINER -->
            <b-row class="pl-sm-4">
              <b-col xl="4" md="6">
                <b-row>
                  <b-col sm="4" class="text-left">
                    <span class="summaryLabel">Type:</span>
                  </b-col>
                  <b-col class="text-left summaryValue" sm="8">{{SongOrBand(form.type)}}</b-col>
                </b-row>
              </b-col>

              <b-col xl="4" md="6">
                <b-row>
                  <b-col sm="4" class="text-left">
                    <span class="summaryLabel">Token Name:</span>
                  </b-col>
                  <b-col class="text-left summaryValue" sm="8">{{form.name}}</b-col>
                </b-row>
              </b-col>

              <b-col xl="4" md="6">
                <b-row>
                  <b-col sm="4" class="text-left">
                    <span class="summaryLabel">Author:</span>
                  </b-col>
                  <b-col class="text-left summaryValue" sm="8">{{form.author}}</b-col>
                </b-row>
              </b-col>

              <b-col xl="4" md="6">
                <b-row>
                  <b-col sm="4" class="text-left">
                    <span class="summaryLabel">Website:</span>
                  </b-col>
                  <b-col class="text-left summaryValue" sm="8">{{form.website}}</b-col>
                </b-row>
              </b-col>

              <b-col xl="4" md="6">
                <b-row>
                  <b-col sm="4" class="text-left">
                    <span class="summaryLabel">Token symbol:</span>
                  </b-col>
                  <b-col class="text-left summaryValue" sm="8">{{form.symbol}}</b-col>
                </b-row>
              </b-col>

              <b-col xl="4" md="6">
                <b-row>
                  <b-col sm="4" class="text-left">
                    <span class="summaryLabel">Total supply:</span>
                  </b-col>
                  <b-col class="text-left summaryValue" sm="8">{{localNumber(form.totalSupply)}}</b-col>
                </b-row>
              </b-col>

              <b-col xl="4" md="6">
                <b-row>
                  <b-col sm="4" class="text-left">
                    <span class="summaryLabel">Decimals:</span>
                  </b-col>
                  <b-col class="text-left summaryValue" sm="8">{{localNumber(form.decimals)}}</b-col>
                </b-row>
              </b-col>

              <b-col xl="4" md="6">
                <b-row>
                  <b-col sm="4" class="text-left">
                    <span class="summaryLabel">Category:</span>
                  </b-col>
                  <b-col class="text-left summaryValue" sm="8">{{form.genre}}</b-col>
                </b-row>
              </b-col>

              <b-col lg="12" class="mb-5">
                <b-row>
                  <b-col cols="12" class="text-left">
                    <span class="summaryLabel">Description:</span>
                  </b-col>
                  <b-col class="text-left summaryValue" cols="12">{{form.description}}</b-col>
                </b-row>
              </b-col>
            </b-row>
            <b-row class="p-0">
              <b-col cols="12" lg="3"></b-col>
              <b-col cols="12" lg="6" class="p-0 mt-3 align-middle">
                <img
                  class="img img-responsive img-thumbnail d-table-cell"
                  v-if="pictureValid"
                  v-bind:src="pictureHtml"
                >
                <font-awesome-icon icon="question" class="fa-6x" v-if="!pictureValid"/>
                <br>
                <span class="missingPicture" v-if="!pictureValid">Picture is required</span>
              </b-col>
              <b-col cols="12" lg="3"></b-col>
              <b-col cols="12" lg="2" v-if="form.soundcloud"></b-col>
              <b-col cols="12" lg="8" class="embedTD mt-3 mx-0 px-0" v-if="form.soundcloud">
                <div style class v-html="embedHtml"></div>
              </b-col>
              <b-col cols="12" lg="2" v-if="form.soundcloud"></b-col>
              <b-col cols="12" lg="2"></b-col>
              <b-col cols="12" lg="8" class="mt-3 px-0" style="height:50%">
                <center>
                  {{youtubeId}}
                  <b-embed tag="div" :src="youtubeId" class v-if="youtubeCorrect"></b-embed>
                  <span
                    class="text-center text-danger"
                    style="font-size:16px;"
                    v-if="!youtubeCorrect"
                  >
                    <br>
                    <br>YOUTUBE LINK IS INCORRECT !
                  </span>
                </center>
              </b-col>
              <b-col cols="12" lg="2"></b-col>
            </b-row>
          </b-container>
        </b-card-body>
      </b-collapse>
    </b-card>
    <b-card no-body class="mb-1 summarySectionTitle">
      <b-card-header header-tag="header" class="p-1 summarySectionTitle" role="tab">
        <div v-b-toggle.accordion2 class="summarySectionTitle">
          Token Sale ({{form.ico}})
          <span v-if="!isICOValid" style="color:red">(Invalid data)</span>
        </div>
      </b-card-header>
      <b-collapse
        id="accordion2"
        accordions="my-accordion"
        role="tabpanel"
        :visible="form.ico=='Yes'"
      >
        <b-card-body class="contractTab">
          <b-container>
            <b-row>
              <b-col lg="12" md="12">
                <b-row>
                  <b-col sm="12" md="4" xl="2" class="text-left">
                    <span class="summaryLabel">Wallet Address:</span>
                  </b-col>
                  <b-col class="text-left summaryValue" sm="12" md="8" xl="10">
                    {{form.wallet}}
                    <br>
                    <span v-if="isValidWalletAddress" style="color:green">(Checksum correct)</span>
                    <span
                      v-if="!isValidWalletAddress"
                      style="color:red;font-weight:600"
                      v-b-tooltip.hover
                      title="This is not correct ethereum account address or checksum is wrong."
                    >(Invalid)</span>
                  </b-col>
                </b-row>
              </b-col>

              <b-col xl="6" md="12">
                <b-row>
                  <b-col sm="8" md="6" class="text-left">
                    <span class="summaryLabel">Tokens for a team:</span>
                  </b-col>
                  <b-col class="text-left summaryValue" sm="4" md="6">{{form.teamtokens}}</b-col>
                </b-row>
              </b-col>

              <b-col xl="6" md="12">
                <b-row>
                  <b-col sm="8" md="6" class="text-left">
                    <span class="summaryLabel">Minimum Contribution PreSale:</span>
                  </b-col>
                  <b-col class="text-left summaryValue" sm="4" md="6">{{form.minpresale}}</b-col>
                </b-row>
              </b-col>

              <b-col xl="6" md="12">
                <b-row>
                  <b-col sm="8" md="6" class="text-left">
                    <span class="summaryLabel">Minimum Contribution MainSale:</span>
                  </b-col>
                  <b-col class="text-left summaryValue" sm="4" md="6">{{form.minmainsale}}</b-col>
                </b-row>
              </b-col>

              <b-col xl="6" md="12">
                <b-row>
                  <b-col sm="8" md="6" class="text-left">
                    <span class="summaryLabel">Maximum Contribution Ether:</span>
                  </b-col>
                  <b-col class="text-left summaryValue" sm="4" md="6">{{form.maxETH}}</b-col>
                </b-row>
              </b-col>

              <b-col xl="6" md="12">
                <b-row>
                  <b-col sm="8" md="6" class="text-left">
                    <span class="summaryLabel">Maximum Cap:</span>
                  </b-col>
                  <b-col class="text-left summaryValue" sm="4" md="6">{{form.maxcap}}</b-col>
                </b-row>
              </b-col>

              <b-col xl="6" md="12">
                <b-row>
                  <b-col sm="8" md="6" class="text-left">
                    <span class="summaryLabel">Minimum Cap:</span>
                  </b-col>
                  <b-col class="text-left summaryValue" sm="4" md="6">{{form.mincap}}</b-col>
                </b-row>
              </b-col>

              <b-col xl="6" md="12">
                <b-row>
                  <b-col sm="8" md="6" class="text-left">
                    <span
                      v-bind:class="{errorMessage: !isPriceValid}"
                      class="summaryLabel"
                    >Token Price ETH:</span>
                  </b-col>
                  <b-col class="text-left summaryValue" sm="4" md="6">{{form.priceETH}}</b-col>
                </b-row>
              </b-col>

              <b-col xl="6" md="12">
                <b-row>
                  <b-col sm="8" md="6" class="text-left">
                    <span
                      v-bind:class="{errorMessage: !isCampaignDurationValid}"
                      class="summaryLabel"
                    >Campaign Duration Days:</span>
                  </b-col>
                  <b-col class="text-left summaryValue" sm="4" md="6">{{form.campaignDuration}}</b-col>
                </b-row>
              </b-col>

              <b-col xl="6" md="12">
                <b-row>
                  <b-col sm="8" md="6" class="text-left">
                    <span
                      v-bind:class="{errorMessage: !isPreSaleDurationValid}"
                      class="summaryLabel"
                    >Pre-sale duration Days:</span>
                  </b-col>
                  <b-col class="text-left summaryValue" sm="4" md="6">{{form.presaleDuration}}</b-col>
                </b-row>
              </b-col>
            </b-row>
          </b-container>
        </b-card-body>
      </b-collapse>
    </b-card>
    <b-card no-body class="mb-1 summarySectionTitle">
      <b-card-header header-tag="header" class="p-1 summarySectionTitle" role="tab">
        <div v-b-toggle.accordion3 class="summarySectionTitle">
          Bonuses ({{bonusesYesOrNo}})
          <span v-if="!isBonusValid" style="color:red">(Invalid data)</span>
        </div>
      </b-card-header>
      <b-collapse
        id="accordion3"
        accordions="my-accordion"
        role="tabpanel"
        :visible="bonusesVisible"
        visible
      >
        <b-card-body class="summaryContainer contractTab py-1">
          <b-container class="m-0">
            <b-row class="p-0">
              <b-col md="6" lg="4" class>
                <b-row>
                  <b-col cols="8" sm="7" md="9" class="m-0 text-left">
                    <span class="summaryLabel text-right">Presale Period [days]:</span>
                  </b-col>
                  <b-col
                    cols="4"
                    sm="5"
                    md="3"
                    class="summaryValue text-left"
                  >{{form.presalePeriod}}</b-col>
                </b-row>
              </b-col>

              <b-col md="6" lg="4" class>
                <b-row>
                  <b-col cols="8" sm="7" md="9" class="m-0 text-left">
                    <span class="summaryLabel text-right">Presale Period Bonus [%]:</span>
                  </b-col>
                  <b-col
                    cols="4"
                    sm="5"
                    md="3"
                    class="summaryValue text-left"
                  >{{form.presalePeriodBonus}}</b-col>
                </b-row>
              </b-col>

              <b-col md="6" lg="4" class>
                <b-row>
                  <b-col cols="8" sm="7" md="9" class="m-0 text-left">
                    <span class="summaryLabel text-right">First Period [days]:</span>
                  </b-col>
                  <b-col cols="4" sm="5" md="3" class="summaryValue text-left">{{form.firstPeriod}}</b-col>
                </b-row>
              </b-col>

              <b-col md="6" lg="4" class>
                <b-row>
                  <b-col cols="8" sm="7" md="9" class="m-0 text-left">
                    <span class="summaryLabel text-right">First Period Bonus [%]:</span>
                  </b-col>
                  <b-col
                    cols="4"
                    sm="5"
                    md="3"
                    class="summaryValue text-left"
                  >{{form.firstPeriodBonus}}</b-col>
                </b-row>
              </b-col>

              <b-col md="6" lg="4" class>
                <b-row>
                  <b-col cols="8" sm="7" md="9" class="m-0 text-left">
                    <span class="summaryLabel text-right">Second Period [days]:</span>
                  </b-col>
                  <b-col cols="4" sm="5" md="3" class="summaryValue text-left">{{form.secondPeriod}}</b-col>
                </b-row>
              </b-col>

              <b-col md="6" lg="4" class>
                <b-row>
                  <b-col cols="8" sm="7" md="9" class="m-0 text-left">
                    <span class="summaryLabel text-right">Second Period Bonus [%]:</span>
                  </b-col>
                  <b-col
                    cols="4"
                    sm="5"
                    md="3"
                    class="summaryValue text-left"
                  >{{form.secondPeriodBonus}}</b-col>
                </b-row>
              </b-col>

              <b-col md="6" lg="4" class>
                <b-row>
                  <b-col cols="8" sm="7" md="9" class="m-0 text-left">
                    <span class="summaryLabel text-right">Third Period [days]:</span>
                  </b-col>
                  <b-col cols="4" sm="5" md="3" class="summaryValue text-left">{{form.thirdPeriod}}</b-col>
                </b-row>
              </b-col>

              <b-col md="6" lg="4" class>
                <b-row>
                  <b-col cols="8" sm="7" md="9" class="m-0 text-left">
                    <span class="summaryLabel text-right">Third Period Bonus[%]:</span>
                  </b-col>
                  <b-col
                    cols="4"
                    sm="5"
                    md="3"
                    class="summaryValue text-left"
                  >{{form.thirdPeriodBonus}}</b-col>
                </b-row>
              </b-col>
            </b-row>
          </b-container>
        </b-card-body>
      </b-collapse>
    </b-card>

    <!-- </b-card-group> -->
  </div>
</template>

<script>
// import musicGenres from '../musicGenres'
import ICOContract from './ICOContract'
import Bonuses from './Bonuses'
import OneTransaction from './OneTransaction'
import axios from 'axios'
import vueAxios from 'vue-axios'
var Web3 = require('web3')
var BigNumber = require('bignumber.js')
// var SC = require('soundcloud')
// SC.initialize('rZY6FYrMpGVhVDfaKEHdCaY8ALekxd8P')


export default {
  data() {
    return {
      show: true,
      playerVars: {
        autoplay: 0
      },
      youtubeId: '',
      lorem: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit.',
      information: '',
      txNumber: null,
      txNumberShow: null,
      status: '',
      errMsg: null,
      blockNumber: 0,
      youtubeCorrect: false,
      gasUsed: '',
      embedHtml: null,
      txNumberShow: null,
      index: 0,
      bonuses: [],
      API: '',
      icotx: 0,
      songtx: 0
    }
  },
  components: {
    ICOContract,
    Bonuses,
    OneTransaction
  },
  errorCaptured(err, vm, info) {
    console.log('Some error')
  },
  watch: {
    form: function (val) {
      // console.log('New Form:', val)
      this.loadEmbed()
      console.log('MAGIER:', this.$refs.youtube)
      if (this.$youtube.getIdFromUrl(val.youtube)) {
        this.youtubeId = 'https://youtube.com/embed/' + this.$youtube.getIdFromUrl(val.youtube)
        this.youtubeCorrect = true
      } else {
        this.youtubeId = null
        this.youtubeCorrect = false
      }
      this.$refs.youtube.updatePlayer()


    }
  },
  created: function () {
    this.loadEmbed()
    this.API = this.$store.state.API
  },
  destroyed: function () {
    console.log('Destroyed')
  },

  computed: {
    videoId: function () {

      return this.$youtube.getIdFromUrl(this.form.youtube)

    },
    bonusesVisible: function () {
      return (this.form.bonuses == 'Yes' && this.form.ico == 'Yes')
    },
    bonusesYesOrNo: function () {
      if (this.bonusesVisible) return 'Yes'
      else return 'No'
    },
    pictureHtml: function () {
      // return 'https://source.unsplash.com/qX9Ie7ieb1E/200x200'
      return this.form['picSrc']
    },
    isPreSaleDurationValid: function () {
      if (isNaN(parseInt(this.form.presaleDuration))) {
        return false
      }
      if (this.form.presaleDuration <= 0) return false
      return true
    },

    isCampaignDurationValid: function () {
      if (isNaN(parseInt(this.form.campaignDuration))) {
        return false
      }
      if (this.form.campaignDuration <= 0) return false
      return true
    },

    isValidWalletAddress: function () {
      return Web3.utils.isAddress(this.form.wallet)
    },

    isPriceValid: function () {
      if (isNaN(parseInt(this.form.priceETH))) return false
      if (this.form.priceETH <= 0) return false
      return true
    },
    isICOValid: function () {
      if (this.form.ico == 'No') return true
      if (!this.isValidWalletAddress) return false
      if (this.form.teamtokens < 0) return false
      if (!this.isPriceValid) return false
      if (this.form.campaignDuration <= 0) return false
      if (!this.isPreSaleDurationValid) return false
      return true;
    },
    isFormValid: function () {
      return this.isICOValid && this.isBonusValid && !this.web3undefined && this.form.picture != null
    },
    pictureValid: function () {
      if (this.form.picture != null) {
        return true
      } else {
        return false
      }
    },
    web3undefined: function () {
      var web3undefined = (typeof (web3) === 'undefined')
      return web3undefined
    },
    isBonusValid: function () {
      if (this.form.bonuses == 'No') return true
      if (isNaN(parseInt(this.form.presalePeriod))) return false
      if (isNaN(parseInt(this.form.presalePeriodBonus))) return false
      if (isNaN(parseInt(this.form.firstPeriod))) return false
      if (isNaN(parseInt(this.form.firstPeriodBonus))) return false
      if (isNaN(parseInt(this.form.secondPeriod))) return false
      if (isNaN(parseInt(this.form.secondPeriodBonus))) return false
      if (isNaN(parseInt(this.form.thirdPeriod))) return false
      if (isNaN(parseInt(this.form.thirdPeriodBonus))) return false

      return true
    },
    soundCloudLink: function () {
      return this.form.soundcloud
    },
    statusClass: function () {
      if (this.status === 'Successful') return 'successfulStatus'
      if (this.status === 'Failed') return 'failedStatus'
      return 'neutralStatus'
    },
    formLocal: function () {
      return this.$store.state.form.type
    },
    form: function () {
      var lForm = {}
      for (var key in this.$store.state.formI) {
        lForm[key] = this.$store.state.formI[key]
      }

      for (var key in this.$store.state.formG) {
        lForm[key] = this.$store.state.formG[key]
        console.log(this.$store.state.formG[key])
      }
      for (var key in this.$store.state.formB) {
        lForm[key] = this.$store.state.formB[key]
      }
      console.log("New Form 1", lForm)
      return lForm
    },
    pictureName: function () {
      // return 'dupa'
      if (this.form.picture !== null && this.form.picture !== undefined) {
        return this.form.picture.name
      } else return '---'
    }
  },
  methods: {
    loadEmbed: function () {
      var that = this
      this.embedHtml = 'Checking...'
      var exp = /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/
      // var exp = '/test/'
      var match = this.form.soundcloud.match(exp)
      if (match !== null && match[0] === this.form.soundcloud) {
        SC.oEmbed(this.form.soundcloud, { auto_play: false, maxheight: 200 }).then(function (embed) {
          that.embedHtml = embed.html
        }).catch(function (err) {
          that.embedHtml = that.form.soundcloud + " - link is invalid"
          // console.log('Embed: ',err)
        })
      } else if (this.form.soundcloud.length > 0) {
        this.embedHtml = 'Inccorect Link s- \'' + this.form.soundcloud + '\''
      } else {
        this.embedHtml = '<br><br>No soundcloud link was provided...' + this.form.soundcloud
      }
    },
    localNumber: function (val) {
      if (isNaN(val)) return 0
      var entry = parseFloat(val)
      var num = entry.toLocaleString()
      return num
    },
    SongOrBand: function (val) {
      switch (parseInt(val)) {
        case 0: return 'Song'
        case 1: return 'Band'
        case 2: return 'Influencer'
        default: return 'Error'
      }
    },
    GetNewSongId(store) {
      axios.get(this.API + '/getNewSongId').then(function (res) {
        return res.data.song.newid
      }).catch(function (err) {
        console.log('get new song id err:', err)
        return -1
      })
    },
    onSubmit() {
      // evt.preventDefault()
      // alert(JSON.stringify(this.form))
      var that = this

      axios.get(this.API + '/getNewSongId').then(function (res) {
        console.log('Submit')
        var newid = res.data.song.newid
        var sendForm = new FormData()
        sendForm.append('pic', new Blob([that.form.picture], { type: that.form.picture.type }))
        sendForm.append('symbol', that.form.symbol)
        sendForm.append('id', newid)
        that.$store.dispatch('UploadPicture', sendForm)
        var contract = that.$store.state.web3contract
        console.log('Contract object:', contract)

        var form = that.form
        //Adjust some values by decimals
        let decimals = parseInt(form.decimals)
        let totalSupply = BigNumber(form.totalSupply).shiftedBy(decimals).toNumber()
        let teamTokens = BigNumber(form.teamTokens).shiftedBy(decimals).toNumber()
        let saleTokens = BigNumber(form.saleTokens).shiftedBy(decimals).toNumber()
        let dec = BigNumber(decimals).toNumber

        console.log('sale Tokens: ', saleTokens)

        // this.transactions = []
        // that.$store.dispatch('clearOldTransactions')
        var bonuses = []

        bonuses[0] = parseInt(form.presalePeriod)
        bonuses[1] = parseInt(form.presalePeriodBonus)
        bonuses[2] = parseInt(form.firstPeriod)
        bonuses[3] = parseInt(form.firstPeriodBonus)
        bonuses[4] = parseInt(form.secondPeriod)
        bonuses[5] = parseInt(form.secondPeriodBonus)
        bonuses[6] = parseInt(form.thirdPeriod)
        bonuses[7] = parseInt(form.thirdPeriodBonus)


        var constraints = []

        //convert from ETH to WEI
        constraints[0] = BigNumber(parseInt(form.minpresale)).shiftedBy(18).toString()
        constraints[1] = BigNumber(parseInt(form.minmainsale)).shiftedBy(18).toString()
        constraints[2] = BigNumber(parseInt(form.maxETH)).shiftedBy(18).toString()
        constraints[3] = BigNumber(parseInt(form.maxcap)).shiftedBy(decimals).toString()
        constraints[4] = BigNumber(parseInt(form.mincap)).shiftedBy(decimals).toString()

        that.bonuses = bonuses

        that.errMsg = ''
        // this.status ="Confirm in Metamask"


        // function AddICO(address _wallet,uint256 _teamTokens,uint256 _minpresale, uint256 _minMainSale, uint256 _maxEth, uint256  _maxCap, uint256 _minCap, uint256 _price, uint256 _durationDays, uint _presaleduration)
        that.icotx = null
        that.songtx = null
        if (form.ico === 'Yes') {
          var title = 'Adding ICO to Blockchain'
          if (form.bonuses === 'Yes') title = 'Adding ICO and Bonuses to Blockchain'
          that.$store.dispatch('AddTransaction', { title: title })
          var icotx = that.$store.getters.getTransactionIndex
          that.icotx = icotx
          contract.AddICO(form.wallet, teamTokens, constraints, form.priceETH, form.campaignDuration, form.presaleDuration, bonuses, saleTokens, function (err, res) {
            console.log('In ADDICO')
            if (res) {
              that.$store.dispatch('UpdateTransactionMining', { index: icotx, number: res })
            } else {
              that.$store.dispatch('UpdateTransactionCancelled', { index: icotx, msg: err.message })
            }
          })
        }
        that.$store.dispatch('AddTransaction', { title: 'Adding New Song in Blockchain' })
        var songtx = that.$store.getters.getTransactionIndex
        that.songtx = songtx
        console.log(totalSupply, decimals, form.name, form.author)
        console.log('Contract: ', contract.address)
        console.log('Form:', form)
        contract.AddSong(form.name, form.author, form.genre, form.type, form.website, totalSupply, form.symbol, form.description, form.soundcloud, form.youtube, true, decimals, newid
          , function (err, res) {
            console.log('Error from Add Song: ', err)
            if (res !== undefined) {
              that.$store.dispatch('UpdateTransactionMining', { index: songtx, number: res })
            } else {
              that.$store.dispatch('UpdateTransactionCancelled', { index: songtx, msg: err.message })
            }
          })


      }).catch(function (err2) {
        console.log('Problem with connection to backend: ', err2)
      })

    },
    localNumber: function (val) {
      if (isNaN(val)) return 0
      var entry = parseFloat(val)
      var num = entry.toLocaleString()
      return num
    },
    onReset(evt) {
      evt.preventDefault()
      /* Reset our form values */
      this.form.email = ''
      this.form.name = ''
      this.form.author = ''
      this.form.symbol = ''
      this.form.genre = ''
      this.form.symbol = ''
      this.form.website = ''
      this.form.type = ''
      this.form.checked = []
      /* Trick to reset/clear native browser form validation state */
      this.show = false
      this.$nextTick(() => { this.show = true })
    }
  }
}
</script>
<style lang="css">
.aCard {
  opacity: 1;
  border-style: solid;
}
</style>
<!-- b-form-1.vue -->
