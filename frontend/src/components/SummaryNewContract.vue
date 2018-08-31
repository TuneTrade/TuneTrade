<template>
  <div class="newContractForm">

    <b-modal hide-header ref="AddSongModal"  size="lg" centered  ok-only ok-title="Close">
    <center>
      <img style="height:50px" src="../assets/metamask.png"></img><br><br>
      <p v-if='!txNumberShow&&!errMsg' style="color:black;font-family:courier;font-weight:800">PLEASE ACCEPT YOUR TRANSACTION IN METAMASK</p>
      <div v-if=errMsg>
        {{errMsg}}
      </div>
   </center>
   <div v-if=txNumberShow>
   <h5 style="border-radius:5px;background-color:#aaa;padding:10px"> Transaction details: </h5>

    Tx Number: {{txNumberShow}} <br>
    Block number: {{blockNumber}} <br>
    Gas Used: {{gasUsed}}<br>

    <p v-bind:class=statusClass>Tx Status: {{status}}</p>
  </div>
  <div v-for="transaction in transactions">
    <div style="font-family:Courier;margin:15px 0px;background-color:#ddd;border-radius:4px;padding:10px 20px;">
    Title: {{transaction.title}}<br>
    Number: {{transaction.txNumber}} <br>
    Status:<b><span v-bind:class="{errorMessage: transaction.status=='Cancelled',successfulStatus: transaction.status=='Successful', miningStatus: transaction.status=='Mining'}"> {{transaction.status}} </span></b> <br>
    <!-- Index: {{transaction.index}}<br> -->
    Block number: {{transaction.blockNumber}}<br>
    Gas Used: {{transaction.gasUsed}} <br>
    <span v-if="transaction.msg">Details: {{transaction.msg}}<br></span>
  </div>
  </div>
    </b-modal >
    <h4>Contract Summary</h4>

    <b-button :disabled="!isFormValid" type="submit" @click="onSubmit()" style="margin:10px 0px" variant="primary">Create Contract</b-button>
          <b-card no-body class="mb-1 aCard">
            <b-card-header header-tag="header" class="p-1" role="tab" style="padding:10px;">
              <b-btn block href="#" v-b-toggle.accordion1 variant="info">General</b-btn>
            </b-card-header>
            <b-collapse  id="accordion1"  accordions="my-accordion" role="tabpanel">
              <b-card-body class="summaryContainer contractTab">

                <div class="summaryElement">
                  <div class="summaryTitle">Type:</div>
                  <div class="summaryContent">{{SongOrBand(form.type)}}</div>
                </div>


                <div class="summaryElement">
                  <div class="summaryTitle">Name:</div>
                  <div class="summaryContent">{{form.name}}</div>
                </div>


                <div class="summaryElement">
                  <div class="summaryTitle">Author:</div>
                  <div class="summaryContent">{{form.author}}</div>
                </div>

                <div class="summaryElement">
                  <div class="summaryTitle">Website:</div>
                  <div class="summaryContent">{{form.website}}</div>
                </div>

                <div class="summaryElement">
                  <div class="summaryTitle">Token symbol:</div>
                  <div class="summaryContent">{{form.symbol}}</div>
                </div>

                <div class="summaryElement">
                  <div class="summaryTitle">Total supply:</div>
                  <div class="summaryContent">{{localNumber(form.totalSupply)}}</div>
                </div>

                <div class="summaryElement">
                  <div class="summaryTitle">Decimals:</div>
                  <div class="summaryContent">{{localNumber(form.decimals)}}</div>
                </div>

                <div class="summaryElement">
                  <div class="summaryTitle">Genre:</div>
                  <div class="summaryContent">{{form.genre}}</div>
                </div>

                <div class="summaryElement" style="grid-column:1/2;">
                  <div class="summaryTitle" ></div>
                  <div class="summaryContent"> <img style="width:200px;border-style:solid;border-width:2px;border-color:#555" v-bind:src="pictureHtml"></img>
                  </div>
                </div>

                <div class="summaryElement"  style="grid-column:2/4;margin-top:10px;padding:0px 10px 0px 0px;">
                  <div class="summaryTitle"></div>
                  <div style="width:100%"class="summaryContent" v-html="embedHtml"> {{embedHtml}}</div>
                  <!-- <div style="grid-column:1/4;" >{{form.soundcloud}}</div> -->
                </div>

                <div class="summaryElement" style="grid-column:1/4;margin-top:10px;padding:0px 10px 0px 0px">
                  <div class="summaryTitle">Description:</div>
                  <div class="summaryContent">s{{form.description}}</div>
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
              <b-btn  :disabled="form.bonuses=='No'" block href="#" v-b-toggle.accordion3 variant="info">Bonuses ({{form.bonuses}}) <span v-if="!isBonusValid" style="color:red"> (Invalid data) </span></b-btn>
            </b-card-header>
      <b-collapse id="accordion3"  accordions="my-accordion" role="tabpanel" :visible="form.bonuses=='Yes'">
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
Transactions length: {{transactions.length}}<br>

  </div>
</template>

<script>
// import musicGenres from '../musicGenres'
import ICOContract from './ICOContract'
import Bonuses from './Bonuses'
var Web3 = require('web3')

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
      intervalNumber: null,
      status: '',
      errMsg: null,
      blockNumber: 0,
      gasUsed: '',
      embedHtml: null,
      txNumberShow: null,
      transactions: [],
      index: 0
    }
  },
  components: {
    ICOContract,
    Bonuses
  },
  created: function () {
    var that = this
    this.intervalNumber = setInterval(this.checkTransaction, 1000)
    this.loadEmbed()

  },
  destroyed: function () {
    console.log('Destroyed')
    clearInterval(this.intervalNumber)
  },
  watch: {
    soundCloudLink: function(val) {
        this.loadEmbed()
    }
  },
  computed: {
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
      return this.isICOValid && this.isBonusValid
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
        SC.oEmbed(this.form.soundcloud, {auto_play: false,height: 166, maxheight: 81}).then(function (embed) {
          console.log('Embed: ',embed)
          that.embedHtml = embed.html
        }).catch(function (err) {
          that.embedHtml= that.form.soundcloud + " - link is invalid"
          // console.log('Embed: ',err)
        })
      } else if (this.form.soundcloud.length > 0) {
        this.embedHtml = 'Inccorect Link s- \'' + this.form.soundcloud + '\''
      } else {
        this.embedHtml='s'
      }
    },
  localNumber: function (val) {
    if (isNaN(val)) return 0
    var entry = parseFloat(val)
    var num = entry.toLocaleString()
    return num
  },
  SongOrBand: function (val) {
    console.log('SongOrBand val: ', val)
    console.log('SongOrBand val:', this.form)
      switch (parseInt(val)) {
        case 0: return 'Song'
        case 1: return 'Band'
        case 2: return 'Influencer'
        default: return 'Error'
      }
    },
    checkTransaction () {
      console.log('Standby')
      var that = this
      for (var i in this.transactions) {
        var tx = this.transactions[i]
        if (tx.id == 2) {
          console.log(tx.title)
          console.log('Checking transaction:', tx.txNumber)
          web3.eth.getTransactionReceipt(tx.txNumber,function(err,res) {
          console.log('Checking transaction receipt err:', err)
          console.log('Checking transaction receipt res:', res)
            if (parseInt(res.status,16) === 1) {
              that.UpdateTransactionSuccessfull(res)
              console.log('Good: ', res.transactionHash)
            } else {
              console.log('Bad')
              tx.status = 'Failed'
              tx.id = 5 // 5 - failed Add New Song
              tx.blockNumber = that.localNumber(res.blockNumber)
              tx.gasUsed = that.localNumber(res.gasUsed)
              that.SortTransactions()
            }
          })
        }
      }
    },
    UpdateTransactionSuccessfull (res)
    {
      var i = this.transactions.findIndex(function(el,el1,el2){
        return (el.txNumber == res.transactionHash)
      })
      this.transactions[i].status = 'Successful'
      this.transactions[i].txNumber = res.transactionHash
      this.transactions[i].id = 4
      this.transactions[i].blockNumber = res.blockNumber
      this.transactions[i].gasUsed = res.gasUsed

      this.SortTransactions()

    },
    onSubmit () {
      // evt.preventDefault()
      // alert(JSON.stringify(this.form))
      var that = this
      var contract = this.$store.state.web3contract
      var form = this.form
      this.transactions = []
      this.errMsg = ''
      // this.status ="Confirm in Metamask"
      this.$refs.AddSongModal.show()

      for (var key in this.form) {
        console.log('form[' + key + '] = ' + this.form[key])
      }
      console.log(form.name)
      console.log(form['name'])
      console.log(form['author'])
      console.log(form['genre'])
      console.log(form['type'])
      console.log(form['website'])
      console.log(form['totalSupply'])
      console.log(form['symbol'])
      console.log(form['description'])
      console.log(form['soundcloud'])
      console.log(form['decimals'])
      console.log(form['totalSupply'])
      console.log(form['name'])

      for (var key in form) {
        console.log('form[' + key + ']=' + form[key] + ' type=' + typeof(form[key]))
      }

      var songtx = this.AddTransaction( "Adding New Song in Blockchain")
      contract.AddSongFull(form.name, form.author, form.genre, form.type, form.website, form.totalSupply, form.symbol, form.description, form.soundcloud,true, function (err, res) {
        if (res !== undefined) {
          that.UpdateTransactionMining(songtx,res)
        } else {
          console.log('Error:', err)
          that.UpdateTransactionCancelled(songtx,err.message)
        }
      })
      // function AddICO(address _wallet,uint256 _teamTokens,uint256 _minpresale, uint256 _minMainSale, uint256 _maxEth, uint256  _maxCap, uint256 _minCap, uint256 _price, uint256 _durationDays, uint _presaleduration)
      if(form.ico === 'Yes') {
        var icotx = this.AddTransaction("Adding ICO to Blockchain")
        contract.AddICO(form.wallet, form.teamtokens, form.minpresale, form.minmainsale, form.maxETH, form.maxcap, form.mincap, form.priceETH, form.campaignDuration, form.presaleDuration,function(err,res){
          if(res)
          {
            that.UpdateTransactionMining(icotx,res)
          } else
          {
            that.UpdateTransactionCancelled(icotx,err.message)
          }
        })
      }
    },
    UpdateTransactionMining (index,number)
    {
      var i = this.transactions.findIndex(function(el,el1,el2){
        return (el.index == index)
      })
      this.transactions[i].status = 'Mining'
      this.transactions[i].txNumber = number
      this.transactions[i].id = 2
      this.SortTransactions()

    },
    SortTransactions() {
      this.transactions.sort(function (a,b) {
        if(a.index > b.index) return 1
        else return -1
      })
    },
    UpdateTransactionCancelled(index,msg)
    {
      var i = this.transactions.findIndex(function(el,el1,el2){
        return (el.index == index)
      })

      this.transactions[i].msg = msg
      this.transactions[i].id = 3
      this.transactions[i].status = 'Cancelled'
      this.SortTransactions()
    },
    AddTransaction(title)
    {
      var tx = {}
      tx.title = title
      tx.status = "Waiting for user confirmation"
      tx.txNumber = 'N/A'
      tx.blockNumber = 'N/A'
      tx.gasUsed = 'N/A'
      tx.id = 1 // 1 - AddSong awaiting for confirmation for confirmation
      tx.index = this.index++
      this.transactions.push(tx)
      this.SortTransactions()

      return tx.index
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
