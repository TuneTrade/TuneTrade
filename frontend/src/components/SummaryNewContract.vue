<template>
  <div class="newContractForm">


    <h4>Contract Summary</h4>

    <b-button :disabled="!isFormValid" type="submit" @click="onSubmit()" style="margin:10px 0px;background-color:#17a2b8" >Create Contract</b-button> <span style="font-size:13px;color:red;padding:0px;margin:0px" v-if="web3undefined"><br>It looks like Metamask is not installed in this browser.<br><br></span>
          <b-card no-body class="mb-1 summarySectionTitle">
            <b-card-header header-tag="header" class="p-1 summarySectionTitle" role="tab" style="">
              <div v-b-toggle.accordion1 class="summarySectionTitle" >General</div>
            </b-card-header>
            <b-collapse  id="accordion1" visible accordions="my-accordion" role="tabpanel">
              <b-card-body class="summaryContainer contractTab">

                <div class="summaryElement" style="grid-row:1/6">
                  <div class="newContractLabel" v-if="pictureValid" ></div>
                  <div class=""><img v-if="pictureValid" style="width:150px;border-style:solid;border-width:2px;border-color:#555" v-bind:src="pictureHtml"></img>
                  <span style="color:red;font-weight:600;" v-if="!pictureValid">Picture is missing</span>
                  </div>
                </div>

                <div class="summaryElement">
                  <div class="newContractLabel">Type:</div>
                  <div class="summaryValue">{{SongOrBand(form.type)}}</div>
                </div>


                <div class="summaryElement">
                  <div class="newContractLabel">Name:</div>
                  <div class="summaryValue">{{form.name}}</div>
                </div>


                <div class="summaryElement">
                  <div class="newContractLabel">Author:</div>
                  <div class="summaryValue">{{form.author}}</div>
                </div>

                <div class="summaryElement">
                  <div class="newContractLabel">Website:</div>
                  <div class="summaryValue">{{form.website}}</div>
                </div>

                <div class="summaryElement">
                  <div class="newContractLabel">Token symbol:</div>
                  <div class="summaryValue">{{form.symbol}}</div>
                </div>

                <div class="summaryElement">
                  <div class="newContractLabel">Total supply:</div>
                  <div class="summaryValue">{{localNumber(form.totalSupply)}}</div>
                </div>

                <div class="summaryElement">
                  <div class="newContractLabel">Decimals:</div>
                  <div class="summaryValue">{{localNumber(form.decimals)}}</div>
                </div>

                <div class="summaryElement">
                  <div class="newContractLabel">Genre:</div>
                  <div class="summaryValue">{{form.genre}}</div>
                </div>



                <div class="summaryElement"  style="grid-column:3/5;">
                  <div class="newContractLabel"></div>
                  <div style="width:100%"class="embedTD" v-html="embedHtml"> {{embedHtml}}</div>
                  <!-- <div style="grid-column:1/4;" >{{form.soundcloud}}</div> -->
                </div>

                <div class="summaryElement" style="grid-column:1/4;margin-top:10px;padding:0px 10px 0px 0px">
                  <div class="newContractLabel">Description:</div>
                  <div class="summaryValue">{{form.description}}</div>
                </div>


              </b-card-body>
            </b-collapse>
          </b-card>
          <b-card no-body class="mb-1  ">
            <b-card-header header-tag="header" class="p-1" role="tab">
              <b-btn :disabled="form.ico=='No'"  block href="#" v-b-toggle.accordion2 variant="info">ICO Contract ({{form.ico}}) <span v-if="!isICOValid" style="color:red"> (Invalid data) </span></b-btn>
            </b-card-header>
      <b-collapse id="accordion2"  accordions="my-accordion" role="tabpanel" :visible="form.ico=='Yes'">
        <b-card-body  class="summaryContainer contractTab">


          <div class="summaryElement" style="grid-column:1/4">
            <div class="summaryTitle" style="font-size:16px">Wallet Address:</div>
            <div class="summaryContent" style="font-size:16px">{{form.wallet}}
              <span v-if="isValidWalletAddress" style="color:green"> (Checksum correct) </span>
              <span v-if="!isValidWalletAddress" style="color:red;font-weight:600" v-b-tooltip.hover title="This is not correct ethereum account address or checksum is wrong."> (Invalid) </span> <br><br> </div>
          </div>

          <div class="summaryElement">
            <div class="summaryTitle">Tokens for a team:</div>
            <div class="summaryContent">{{form.teamtokens}}</div>
          </div>

          <div class="summaryElement">
            <div class="summaryTitle">Minimum Contribution PreSale:</div>
            <div class="summaryContent">{{form.minpresale}}</div>
          </div>

          <div class="summaryElement">
            <div class="summaryTitle">Minimum Contribution MainSale:</div>
            <div class="summaryContent">{{form.minmainsale}}</div>
          </div>

          <div class="summaryElement">
            <div class="summaryTitle">Maximum Contribution Ether:</div>
            <div class="summaryContent">{{form.maxETH}}</div>
          </div>

          <div class="summaryElement">
            <div class="summaryTitle">Maximum Cap:</div>
            <div class="summaryContent">{{form.maxcap}}</div>
          </div>

          <div class="summaryElement">
            <div class="summaryTitle">Minimum Cap:</div>
            <div class="summaryContent">{{form.mincap}}</div>
          </div>

          <div class="summaryElement">
            <div class="summaryTitle"  v-bind:class="{errorMessage: !isPriceValid}">Token Price ETH:</div>
            <div class="summaryContent">{{form.priceETH}}
            </div>
          </div>
          <div class="summaryElement">
            <div class="summaryTitle"  v-bind:class="{errorMessage: !isCampaignDurationValid}">Campaign Duration Days:</div>
            <div class="summaryContent">{{form.campaignDuration}}</div>
          </div>

          <div class="summaryElement">
            <div class="summaryTitle" v-bind:class="{errorMessage: !isPreSaleDurationValid}">Pre-sale duration Days:</div>
            <div class="summaryContent">{{form.presaleDuration}}</div>
          </div>


        </b-card-body>
      </b-collapse>
      </b-card>
          <b-card no-body class="mb-1  ">
            <b-card-header header-tag="header" class="p-1" role="tab">
              <b-btn  :disabled="bonusesYesOrNo=='No'" block href="#" v-b-toggle.accordion3 variant="info">Bonuses ({{bonusesYesOrNo}}) <span v-if="!isBonusValid" style="color:red"> (Invalid data) </span></b-btn>
            </b-card-header>
      <b-collapse id="accordion3"  accordions="my-accordion" role="tabpanel" :visible="bonusesVisible">
        <b-card-body   class="summaryContainer contractTab">
          <div class="summaryElement">
            <div class="summaryTitle">Presale Period [days]:</div>
            <div class="summaryContent">{{form.presalePeriod}}</div>
          </div>
          <div class="summaryElement">
            <div class="summaryTitle">Presale Period Bonus [%]:</div>
            <div class="summaryContent">{{form.presalePeriodBonus}}</div>
          </div>
          <div class="summaryElement">
            <div class="summaryTitle">First Period [days]:</div>
            <div class="summaryContent">{{form.firstPeriod}}</div>
          </div>
          <div class="summaryElement">
            <div class="summaryTitle">First Period Bonus [%]:</div>
            <div class="summaryContent">{{form.firstPeriodBonus}}</div>
          </div>
          <div class="summaryElement">
            <div class="summaryTitle">Second Period [days]:</div>
            <div class="summaryContent">{{form.secondPeriod}}</div>
          </div>
          <div class="summaryElement">
            <div class="summaryTitle">Second Period Bonus [%]:</div>
            <div class="summaryContent">{{form.secondPeriodBonus}}</div>
          </div>
          <div class="summaryElement">
            <div class="summaryTitle">Third Period [days]:</div>
            <div class="summaryContent">{{form.thirdPeriod}}</div>
          </div>
          <div class="summaryElement">
            <div class="summaryTitle">Third Period Bonus[%]:</div>
            <div class="summaryContent">{{form.thirdPeriodBonus}}</div>
          </div>

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
import Transactions from './Transactions'
import axios from 'axios'
import vueAxios from 'vue-axios'
var Web3 = require('web3')
var BigNumber = require('bignumber.js')
var SC = require('soundcloud')
SC.initialize('rZY6FYrMpGVhVDfaKEHdCaY8ALekxd8P')


export default {
  data () {
    return {
      show: true,
      lorem: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit.',
      information: '',
      txNumber: null,
      txNumberShow: null,
      status: '',
      errMsg: null,
      blockNumber: 0,
      gasUsed: '',
      embedHtml: null,
      txNumberShow: null,
      index: 0,
      bonuses: [],
      API: ''
    }
  },
  components: {
    ICOContract,
    Bonuses,
    Transactions
  },
  created: function () {
    this.loadEmbed()
    this.API = this.$store.state.API
  },
  destroyed: function () {
    console.log('Destroyed')
  },

  computed: {
    bonusesVisible: function () {
      return (this.form.bonuses=='Yes' && this.form.ico=='Yes')
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
      if (this.form.presaleDuration <=0) return false
      return true
    },

    isCampaignDurationValid: function () {
      if (isNaN(parseInt(this.form.campaignDuration))) {
        return false
      }
      if (this.form.campaignDuration <=0) return false
      return true
    },

    isValidWalletAddress: function () {
      return Web3.utils.isAddress(this.form.wallet)
    },

    isPriceValid: function () {
      if (isNaN(parseInt(this.form.priceETH))) return false
      if (this.form.priceETH <=0) return false
      return true
    },
    isICOValid: function () {
      if (this.form.ico == 'No') return true
      if (!this.isValidWalletAddress) return false
      if (this.form.teamtokens < 0 ) return false
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
    web3undefined: function ()
    {
      var web3undefined = (typeof(web3) === 'undefined')
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
      }
      for (var key in this.$store.state.formB) {
        lForm[key] = this.$store.state.formB[key]
      }
      console.log(lForm)
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
      if (match !==null && match[0] === this.form.soundcloud){
        SC.oEmbed(this.form.soundcloud, {auto_play: false,height: 300, maxheight: 300}).then(function (embed) {
          that.embedHtml = embed.html
        }).catch(function (err) {
          that.embedHtml= that.form.soundcloud + " - link is invalid"
          // console.log('Embed: ',err)
        })
      } else if (this.form.soundcloud.length > 0) {
        this.embedHtml = 'Inccorect Link s- \'' + this.form.soundcloud + '\''
      } else {
        this.embedHtml='No soundcloud link was provided...' + this.form.soundcloud
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
    GetNewSongId(store)
    {
      axios.get(this.API+'/getNewSongId').then(function(res){
        return res.data.song.newid
      }).catch (function(err){
        return -1
      })
    },
    onSubmit () {
      // evt.preventDefault()
      // alert(JSON.stringify(this.form))
      var that = this

      axios.get(this.API+'/getNewSongId').then(function(res){
        console.log('Submit')
        var newid =  res.data.song.newid
        var sendForm = new FormData()
        sendForm.append('pic',new Blob([that.form.picture],{type:that.form.picture.type}))
        sendForm.append('symbol',that.form.symbol)
        sendForm.append('id',newid)
        that.$store.dispatch('UploadPicture',sendForm)
        var contract = that.$store.state.web3contract

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
        if(form.ico === 'Yes') {
          var title = 'Adding ICO to Blockchain'
          if (form.bonuses === 'Yes') title = 'Adding ICO and Bonuses to Blockchain'
          that.$store.dispatch('AddTransaction', {title: title})
          var icotx = that.$store.getters.getTransactionIndex
          contract.AddICO(form.wallet, teamTokens, constraints, form.priceETH, form.campaignDuration, form.presaleDuration,bonuses, saleTokens, function(err,res){
            if(res)
            {
              that.$store.dispatch('UpdateTransactionMining',{index: icotx, number: res})
            } else
            {
              that.$store.dispatch('UpdateTransactionCancelled',{index: icotx, msg: err.message})
            }
          })
        }
        that.$store.dispatch('AddTransaction',{title: 'Adding New Song in Blockchain'})
        var songtx = that.$store.getters.getTransactionIndex
        console.log(totalSupply, decimals,form.name, form.author )
        contract.AddSong(form.name, form.author, form.genre, form.type, form.website, totalSupply, form.symbol, form.description, form.soundcloud, true, decimals, newid, function (err, res) {
          if (res !== undefined) {
            that.$store.dispatch('UpdateTransactionMining', {index: songtx, number: res})
          } else {
            that.$store.dispatch('UpdateTransactionCancelled',{index: songtx, msg: err.message})
          }
        })


      }).catch (function(err){
        console.log('Problem with connection to backend: ', err)
      })

    },
    localNumber: function (val) {
      if (isNaN(val)) return 0
      var entry = parseFloat(val)
      var num = entry.toLocaleString()
      return num
    },
    onReset (evt) {
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
  opacity:1;
  border-style:solid;
}

</style>
<!-- b-form-1.vue -->
