<template lang="html">
  <div class="">
    <b-card style="border-color:black;background-color:rgba(0,0,0,0.1);border-width:1px;border-style:solid;font-size:14px;">
      <b-row style="brder-style:solid;">
        <b-col sm="3" class="text-sm-left">
          <!-- <img v-bind:src="picLink(song.Id)" width=140px height=140px></img> -->
          <b-img   fluid    blank-color="#777" rounded v-bind:src="picLink(song.Id)" alt="" />

        </b-col>
        <b-col sm="9">
          <b-row>
          <b-col sm="6">
            <b-row >
              <b-col sm="5" class="text-sm-left"><b>Type:</b></b-col>
              <b-col sm="7" class="text-sm-left">{{ SongOrBand(song.Type) }}</b-col>
            </b-row>
            <b-row >
              <b-col sm="5" class="text-sm-left"><b>Name:</b></b-col>
              <b-col sm="7" class="text-sm-left">&quot;{{ song.Name }}&quot;</b-col>
            </b-row>
            <b-row>
              <b-col sm="5" class="text-sm-left"><b>Author:</b></b-col>
              <b-col sm="7" class="text-sm-left">{{ song.Author }}</b-col>
            </b-row>
            <b-row>
              <b-col sm="5" class="text-sm-left"><b>Price [{{song.Symbol}}/ETH]:</b></b-col>
              <b-col sm="7" class="text-sm-left">{{tokensForEth(song.Price,song.Decimals)}}</b-col>
            </b-row>
            <b-row>
              <b-col sm="5" class="text-sm-left"><b>Phase:</b></b-col>
              <b-col sm="7" class="text-sm-left">{{Phase(song.State)}}</b-col>
            </b-row>
            <b-row >
              <b-col sm="5" class="text-sm-left"><b>Website:</b></b-col>
              <b-col sm="7" class="text-sm-left"><b-link class="text-primary" target="_blank" v-bind:href="WebsiteLink(song.Website)" variant="danger">Website </b-link>
              </b-col>
            </b-row>
          </b-col>
          <b-col sm="6">
            <b-row>
              <b-col sm="5" class="text-sm-left"><b>Contribution [ETH]:</b></b-col>
              <b-col sm="7" class="text-sm-left">{{ Price(song.Contribution) }}</b-col>
            </b-row>
            <b-row>
              <b-col sm="5" class="text-sm-left"><b>Volume [{{song.Symbol}}]:</b></b-col>
              <b-col sm="7" class="text-sm-left">{{ BigValue(song.Volume,song.Decimals) }}</b-col>
            </b-row>
          <b-row >
            <b-col sm="5" class="text-sm-left"><b>Total Supply [{{song.Symbol}}]:</b></b-col>
            <b-col sm="7" class="text-sm-left">{{ BigValue(song.TotalSupply,song.Decimals) }}</b-col>
          </b-row>
          <b-row >
            <b-col sm="5" class="text-sm-left"><b>Decimals:</b></b-col>
            <b-col sm="7" class="text-sm-left">{{song.Decimals}}</b-col>
          </b-row>
          <b-row>
            <b-col sm="5" class="text-sm-left"><b>Genre:</b></b-col>
            <b-col sm="7" class="text-sm-left">{{ song.Genre }}</b-col>
          </b-row>
          <b-row >
            <b-col sm="5" class="text-sm-left"><b>Created:</b></b-col>
            <b-col sm="7" class="text-sm-left">{{ getLocalTime( song.Created )}}</b-col>
          </b-row>
          <b-row >
            <b-col>---
            </b-col>
          </b-row>
          <b-row >
            <b-col sm="5" class="text-sm-left"><b>Buy:</b></b-col>
            <b-col sm="7" class="text-sm-left"><b-button :disabled="!tokenOnSale(song.State)" @click.stop="ShowBuyModal(song)" size="sm" variant="info">Buy</b-button></b-col>
          </b-row>
        </b-col>
      </b-row>
      <b-row>
        <b-col sm="2">
        </b-col>
        <b-col sm="10" style="margin:20px 0px">
        </b-col>
      </b-row>
      <b-row >
        <b-col sm="3" class="text-sm-left"><b>Owner:</b></b-col>
        <b-col sm="6 " class="text-sm-left"> {{song.Owner}}

        </b-col>
        <b-col sm="3">
          <b-link target="_blank" class="text-primary" v-bind:href="etherscanAddress(song.Owner)" variant="danger">
            Etherscan
          </b-link>
        </b-col>
      </b-row>
      <b-row >
        <b-col sm="3" class="text-sm-left"><b>Token Contract address: </b></b-col>
        <b-col sm="6" class="text-sm-left">{{song.address}}

        </b-col>
        <b-col sm="3" class="text-sm-left">  <b-link target="_blank" class="text-primary" v-bind:href="etherscanToken(song.address)" variant="danger">
            Etherscan
          </b-link></b-col>
      </b-row>
      <b-row  >
        <b-col sm="3" class="text-sm-left"><b>ICO Sale address: </b></b-col>
        <b-col sm="6" class="text-sm-left">{{song.saleAddress}}

        </b-col>
        <b-col sm="3" class="text-sm-left">  <b-link target="_blank" class="text-primary" v-bind:href="etherscanToken(song.saleAddress)" variant="danger">
            Etherscan
          </b-link></b-col>
      </b-row>
      </b-col>
  </b-row>

  <br>
  <b-row >
    <b-col xs="2" class="text-sm-left"><b>Description:</b></b-col>
    <b-col xs="6" class="text-sm-left"><b></b></b-col>
  </b-row>
    <b-row>
      <b-col xs="6" class="text-sm-left" >
        <p style="text-align:justify;padding:15px; height:100%;word-wrap: break-word;;border-style:solid;border-width:1px;border-color:#aaa;;border-radius:5px">  {{song.Description}}</p>
        </b-col>
        <b-col>
          <!-- <b-link>{{song.soundcloud}}</b-link> -->
          <div v-html="song.iFrameEmbed"> </div>
          </b-col>
    </b-row>

  <br>
       <b-button size="sm" @click="row.toggleDetails">Hide Details</b-button>
    </b-card>


  </div>
</template>

<script>
export default {
  data () {
    return {
      index: 0
    }
  },

  computed: {

    lastUpdate: function () {
      return this.$store.state.lastUpdate
    },
    transactions: function () {
      var that = this
      return this.$store.state.transactions.filter(function (tx) {
        if (that.pending) {
          return (tx.id !== 6)
        } else {
          return true
        }
      })
    }
  },
  props: {
    song: Object
  },
  methods: {
    localNumber: function (val) {
      if (isNaN(val)) return 0
      var entry = parseFloat(val)
      var num = entry.toLocaleString()
      return num
    }
  }
}
</script>

<style lang="css">
</style>
