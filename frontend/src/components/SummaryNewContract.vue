<template>
  <div class="newContractForm">

    <b-modal hide-header ref="AddSongModal"  size="lg" centered  ok-only ok-title="Close">
    <center>
      <img style="height:50px" src="../assets/metamask.png"></img><br><br>
      <p v-if='!txNumberShow&&!errMsg' style="color:grey"> PLEASE ACCEPT YOUR TRANSACTION IN METAMASK </p>
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
    </b-modal >
    <h4>Contract Summary</h4>

    <b-button type="submit" @click="onSubmit()" variant="primary">Create Contract</b-button>
    <b-button type="reset" variant="danger">Reset All</b-button>
          <b-card no-body class="mb-1 aCard">
            <b-card-header header-tag="header" class="p-1" role="tab" style="padding:10px;">
              <b-btn block href="#" v-b-toggle.accordion1 variant="info">General</b-btn>
            </b-card-header>
            <b-collapse id="accordion1" visible accordions="my-accordion" role="tabpanel">
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
                  <div class="summaryTitle">Price:</div>
                  <div class="summaryContent">{{localNumber(form.price)}}</div>
                </div>

                <div class="summaryElement">
                  <div class="summaryTitle">Decimals:</div>
                  <div class="summaryContent">{{localNumber(form.decimals)}}</div>
                </div>

                <div class="summaryElement">
                  <div class="summaryTitle">Image:</div>
                  <div class="summaryContent">{{pictureName}}</div>
                </div>

                <div class="summaryElement">
                  <div class="summaryTitle">Genre:</div>
                  <div class="summaryContent">{{form.genre}}</div>
                </div>

                <div class="summaryElement" style="grid-column:1/4;margin-top:10px;padding:0px 10px 0px 0px">
                  <div class="summaryTitle">Description:</div>
                  <div class="summaryContent">{{form.description}}</div>
                </div>

                <div class="summaryElement"  style="grid-column:1/4;margin-top:10px;padding:0px 10px 0px 0px;">
                  <div class="summaryTitle">Soundcloud link:</div>
                  <div style="width:100%"class="summaryContent" v-html="embedHtml"> {{embedHtml}}</div>
                  <!-- <div style="grid-column:1/4;" >{{form.soundcloud}}</div> -->
                </div>

              </b-card-body>
            </b-collapse>
          </b-card>
          <b-card no-body class="mb-1  ">
            <b-card-header header-tag="header" class="p-1" role="tab">
              <b-btn disabled block href="#" v-b-toggle.accordion2 variant="info">ICO Contract</b-btn>
            </b-card-header>
      <b-collapse id="accordion2"  accordions="my-accordion" role="tabpanel">
        <b-card-body  class="summaryContainer contractTab">


          <div class="summaryElement">
            <div class="summaryTitle">Contribution Wallet Address:</div>
            <div class="summaryContent">{{lorem}}</div>
          </div>

          <div class="summaryElement">
            <div class="summaryTitle">Tokens for a team:</div>
            <div class="summaryContent">{{lorem}}</div>
          </div>

          <div class="summaryElement">
            <div class="summaryTitle">Minimum Contribution PreSale:</div>
            <div class="summaryContent">{{lorem}}</div>
          </div>

          <div class="summaryElement">
            <div class="summaryTitle">Minimum Contribution MainSale:</div>
            <div class="summaryContent">{{lorem}}</div>
          </div>

          <div class="summaryElement">
            <div class="summaryTitle">Maximum Contribution Ether:</div>
            <div class="summaryContent">{{lorem}}</div>
          </div>

          <div class="summaryElement">
            <div class="summaryTitle">Maximum Cap:</div>
            <div class="summaryContent">{{lorem}}</div>
          </div>

          <div class="summaryElement">
            <div class="summaryTitle">Minimum Cap:</div>
            <div class="summaryContent">{{lorem}}</div>
          </div>

          <div class="summaryElement">
            <div class="summaryTitle">Token Price ETH:</div>
            <div class="summaryContent">{{lorem}}</div>
          </div>
          <div class="summaryElement">
            <div class="summaryTitle">Campaign Duration Days:</div>
            <div class="summaryContent">{{lorem}}</div>
          </div>


        </b-card-body>
      </b-collapse>
      </b-card>
          <b-card no-body class="mb-1  ">
            <b-card-header header-tag="header" class="p-1" role="tab">
              <b-btn disabled block href="#" v-b-toggle.accordion3 variant="info">Bonuses</b-btn>
            </b-card-header>
      <b-collapse id="accordion3"  accordions="my-accordion" role="tabpanel">
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

      <p>
        Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
      </p>
      {{information}}

  </div>
</template>

<script>
// import musicGenres from '../musicGenres'
import ICOContract from './ICOContract'
import Bonuses from './Bonuses'
var Web3 = require('web3')

var SC = require('soundcloud')
SC.initialize('rZY6FYrMpGVhVDfaKEHdCaY8ALekxd8P')

// require('../musicGenres')
var musicGenres = [
  {value: null, text: 'Please select genre', disabled: true},
  'Alternative',
  'Ambient',
  'Anime',
  'Blues',
  'Children’s Music',
  'Classical',
  'Comedy',
  'Commercial',
  'Country',
  'Dance',
  'Disney',
  'Easy Listening',
  'Electronic',
  'Enka',
  'French Pop',
  'German Folk',
  'German Pop',
  'Fitness & Workout',
  'Hip-Hop/Rap',
  'Holiday',
  'Indie Pop',
  'Industrial',
  'Inspirational – Christian & Gospel',
  'Instrumental',
  'J-Pop',
  'Jazz',
  'K-Pop',
  'Karaoke',
  'Kayokyoku',
  'Latin',
  'New Age',
  'Opera',
  'Polish Folk',
  'Polish Rock',
  'Pop',
  'R&B/Soul',
  'Reggae',
  'Rock',
  'Soundtrack',
  'Tex-Mex',
  'Vocal',
  'World'
]

export default {
  data () {
    return {
      show: true,
      genres: musicGenres,
      lorem: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit.',
      information: '',
      txNumber: null,
      txNumberShow: null,
      intervalNumber: null,
      status: '',
      errMsg: null,
      blockNumber: 0,
      gasUsed: '',
      embedHtml: null
    }
  },
  components: {
    ICOContract,
    Bonuses
  },
  created: function () {
    /* global musicGenres */
    this.genres = musicGenres
    var that = this
    console.log('Music Genres:', this.genres)
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
      return this.$store.state.form
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
      SC.oEmbed(this.form.soundcloud, {auto_play: false,height: 166, maxheight: 81}).then(function (embed) {
        console.log('Embed: ',embed)
        that.embedHtml = embed.html
      }).catch(function (err) {
        that.embedHtml= that.form.soundcloud + " - link is invalid"
        // console.log('Embed: ',err)
      })
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
    checkTransaction () {
      console.log('Standby')
      var that = this
      if (this.txNumber !== null) {
        console.log('Checking transaction:', this.txNumber)
        web3.eth.getTransactionReceipt(this.txNumber,function(err,res) {
          console.log('Checking transaction receipt err:', err)
          console.log('Checking transaction receipt res:', res)
          if (parseInt(res.status,16) === 1) {
            console.log('Good')
            that.status="Successful"
            that.txNumber = null
            that.blockNumber = that.localNumber(res.blockNumber)
            that.gasUsed = that.localNumber(res.gasUsed)

          } else {
            console.log('Bad')
            that.status = 'Failed'
            that.txNumber = null
            that.blockNumber = that.localNumber(res.blockNumber)
            that.gasUsed = that.localNumber(res.gasUsed)
          }
        })

      }
    },
    onSubmit () {
      // evt.preventDefault()
      // alert(JSON.stringify(this.form))
      var that = this
      this.errMsg = ''
      this.status ="Confirm in Metamask"
      this.txNumberShow=null
      this.$refs.AddSongModal.show()
      for (var key in this.form) {
        console.log('form[' + key + '] = ' + this.form[key])
      }
      console.log(this.form.name)
      console.log(this.form['name'])
      console.log(this.form['symbol'])
      console.log(this.form['decimals'])
      console.log(this.form['totalSupply'])
      console.log(this.form['name'])
      var price = Web3.utils.toWei(this.form.price, 'ether')
      console.log('Price:', price)
      this.$store.state.web3contract.AddSongFull(this.form.name, this.form.author, this.form.genre, this.form.type, this.form.website, price, this.form.totalSupply,false, this.form.symbol, this.form.description, this.form.soundcloud, function (err, res) {
        if (res !== undefined) {
          that.status = 'Mining'
          that.txNumberShow = res
          that.txNumber = res
          that.errMsg = null
        } else {
          that.status = 'Cancelled'
          that.txNumberShow = null
          that.txNumber = null
          that.errMsg = err.message
        }

        console.log('Err:', err)
        console.log('Res:', res)
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
