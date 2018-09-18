<template lang="html">
  <div class="" style="margin:0px 0px;min-height:600px">
    <b-modal v-if="currentItem != null" @ok="test($event)" hide-header ref="BuyTokensModal"  size="lg" centered   ok-title="Buy">
    <center>
      <img style="height:50px" src="../assets/metamask.png"></img><br><br>
    </center>
    <div style="font-family:Courier;margin:15px 0px;background-color:#ddd;border-radius:4px;padding:10px 20px;">
  <b>Name: </b> {{currentItem.Name}} <br>
  <b>Rate [{{currentItem.Symbol}}/ETH]: </b> {{tokensForEth(currentItem.Price, currentItem.Decimals)}} <br>
  <b>Sale Contract Address:</b> {{currentItem.saleAddress}} <br>
  <b> Available tokens:</b> 10000
  <br><br>
    <b-form style="text-align:center">
      <center>      <b-form-input style=
            "width:200px; height:3rem" id="tokensToBuy"
                          type="number"
                          v-model="tokensToBuy"
                          optional
                          size="sm"
                          step="currentItem.Price"
                          placeholder="0">
            </b-form-input>
          </center>
    <b-form-group style="padding:13px 0px;"id="tokensToBuyGroup"
                  label="How many tokens ?"
                  label-for="tokenstoBuy"
                  >
    </b-form-group>
  </b-form>

  <b> Tokens price [ETH]</b>: {{tokensPriceEth(currentItem.Price, tokensToBuy)}} <br>
  <b> Tokens price [WEI]</b>: {{tokensPriceWei(currentItem.Price, tokensToBuy)}} <br>



  </div>
    </b-modal >

    <b-modal id="modalInfo" @hide="resetModal" ok-only show centered>
      <!-- <pre>{{ modalInfo.content }}</pre> -->
      <div v-on:load="loaded()" v-html="musicPlayerLink"> </div>

      <!-- <iframe v-on:abort="onAbort()" v-on:error="onError()" v-on:load="loaded()" width="100%" height="450" scrolling="no" frameborder="no" allow="autoplay" v-bind:src="musicPlayerLink"></iframe> -->
    </b-modal>
    <b-navbar  style="border-radius:1px;margin:1px 0px 0px 0px;box-shadow:0px 0px 0px black;background-color:rgba(230,210,230,0.7);" toggleable="md" type="dark" variant="secondary">
      <b-nav-form>
        <b-form-input size="sm" v-model="tablefilter" class="mr-sm-2" type="text" placeholder="Search"/>
        <b-button size="sm" class="my-2 my-sm-0" type="submit">Search</b-button>
      </b-nav-form>
      <b-nav-item-dropdown class="test" v-model="typeDrop" :text="typeDropText" right style="list-style:none;opacity:1;z-index:2,overflow:visible;">
        <b-dropdown-item v-on:click="filterType(0)"  href="#">Song</b-dropdown-item>
        <b-dropdown-item v-on:click="filterType(1)"  href="#">Band</b-dropdown-item>
        <b-dropdown-item v-on:click="filterType(2)"  href="#">Influencer</b-dropdown-item>
        <b-dropdown-item v-on:click="filterType(3)"  href="#">All</b-dropdown-item>
      </b-nav-item-dropdown>
    </b-navbar>
    <div v-if="!songsReady">
<center>      <img src="static/loading.gif"></img> <br> Loading...
</center>

    </div>
    <div v-if="noSongs && songsReady" class="noSongs">
      SONGS LIST IS EMPTY
    </div>
  <b-table v-if="songsReady && !noSongs" sort-direction="desc" sort-by="Created" :current-page="currentPage" :per-page="perPage" sort-desc="true" striped hover :items="songs" :fields="fields" small variant="danger" :filter="filterFunction" class="songsTable">
    <template slot="Buy" slot-scope="row">
      <b-button size="sm" variant="info"  @click.stop="info(row.item, row.index, $event.target)">Buy</b-button>
    </template>
    <template slot="show_details" slot-scope="row">
      <b-button size="sm" @click.stop="row.toggleDetails"  variant="info">
      {{ row.detailsShowing ? 'Hide' : 'Show'}}  Details
      </b-button>
      <br><br>
      <b-button v-if="tokensForEth(row.item.Price, row.item.Decimals) != null" size="sm" @click.stop="ShowBuyModal(row.item)"  variant="info">
      Buy Tokens
      </b-button>
      {{tokensForEth(row.item.Price, row.item.Decimals)}}
      <!-- {{tokensForEth(row.item.Price,row.item.Decimals)}} -->
    </template>
    <template slot="TotalSupply" slot-scope="row">
      {{BigValue (row.item.TotalSupply)}}
    </template>

    <template slot="Volume" slot-scope="row">
      {{localNumber (row.item.Volume)}}
    </template>

    <template slot="Price" slot-scope="row">
      {{Price(row.item.Price)}}
    </template>
    <template slot="Contribution" slot-scope="row">
      {{Price (row.item.Contribution)}}
    </template>

    <template slot="Type" slot-scope="row">
      {{SongOrBand (row.item.Type)}}
    </template>
    <template slot="Picture" slot-scope="row">
      <div style="display:grid;grid-template-columns:1fr 2fr;">
        <a v-if="!isLoading(row.item.OrderNum) && isPlaying(row.item.OrderNum)" v-on:click="playMusic(row.item.OrderNum,row.item.soundcloud)">
      <img  src="../assets/pauseplayer.png" alt="" class="player" style="width:30px;margin:5px"></a>
        <a v-if="isLoading(row.item.OrderNum)" v-on:click="playMusic(row.item.OrderNum,row.item.soundcloud)">
      <img  src="../assets/loadingplayer.png" alt="" class="player" style="width:30px;margin:5px"></a>

      <a  v-bind:class="{unPlayable: !row.item.playable}" v-if="!isLoading(row.item.OrderNum) && !isPlaying(row.item.OrderNum)" v-on:click="playMusic(row.item.OrderNum,row.item.soundcloud)">
      <img  src="../assets/player.png" alt="" class="player" style="width:30px;margin:5px"></a>
      <!-- <iframe allowtransparency="true" scrolling="no" frameborder="no" src="https://w.soundcloud.com/icon/?url=http%3A%2F%2Fsoundcloud.com%2Fflickphlack%2Fdrake-in-my-feelings-kiki-do-you-love-me-loop-1&color=orange_white&size=32" style="width: 32px; height: 32px;"></iframe>
      <iframe width="50px" height="50px" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/34019569&amp;"></iframe> -->
      <img v-bind:src="picLink(row.item.Id)" alt="" style="width:100px;height:100px">
    </div>
      <!-- {{SongOrBand (row.item.Type)}} -->
    </template>

    <template slot="Name" slot-scope="row">
      &quot;{{row.item.Name}}&quot;
    </template>
    <template slot="Created" slot-scope="row">
      {{ getLocalTime(row.item.Created)}}
    </template>

    <template slot="row-details" slot-scope="row">
      <b-card style="border-color:black;background-color:rgba(0,0,0,0.1);border-width:1px;border-style:solid;">
        <b-row style="brder-style:solid;">
          <b-col sm="2" class="text-sm-left">
            <img v-bind:src="picLink(row.item.Id)" width=140px height=140px></img>
          </b-col>
          <b-col sm="10">
            <b-row>
            <b-col sm="6">
              <b-row >
                <b-col sm="4" class="text-sm-left"><b>Type:</b></b-col>
                <b-col sm="8" class="text-sm-left">{{ SongOrBand(row.item.Type) }}</b-col>
              </b-row>
              <b-row >
                <b-col sm="4" class="text-sm-left"><b>Name:</b></b-col>
                <b-col sm="8" class="text-sm-left">&quot;{{ row.item.Name }}&quot;</b-col>
              </b-row>
              <b-row>
                <b-col sm="4" class="text-sm-left"><b>Author:</b></b-col>
                <b-col sm="8" class="text-sm-left">{{ row.item.Author }}</b-col>
              </b-row>
              <b-row>
                <b-col sm="4" class="text-sm-left"><b>Price:</b></b-col>
                <b-col sm="8" class="text-sm-left">{{Price(row.item.Price)}}</b-col>
              </b-row>
              <b-row>
                <b-col sm="4" class="text-sm-left"><b>Phase:</b></b-col>
                <b-col sm="8" class="text-sm-left">{{ PhaseToString(row.item.Phase) }}</b-col>
              </b-row>
              <b-row >
                <b-col sm="4" class="text-sm-left"><b>Website:</b></b-col>
                <b-col sm="8" class="text-sm-left"><b-button target="_blank" v-bind:href="row.item.Website" size="sm" variant="info">Website</b-button><br>
                  {{row.item.Website}}
                </b-col>
              </b-row>

            </b-col>
            <b-col sm="6">
              <b-row>
                <b-col sm="4" class="text-sm-left"><b>Contribution:</b></b-col>
                <b-col sm="8" class="text-sm-left">{{ localNumber(row.item.Contribution) }}</b-col>
              </b-row>
              <b-row>
                <b-col sm="4" class="text-sm-left"><b>Volume:</b></b-col>
                <b-col sm="8" class="text-sm-left">{{ localNumber(row.item.Volume) }}</b-col>
              </b-row>
            <b-row >
              <b-col sm="4" class="text-sm-left"><b>Total Supply:</b></b-col>
              <b-col sm="8" class="text-sm-left">{{ localNumber(row.item.TotalSupply) }}</b-col>
            </b-row>
            <b-row>
              <b-col sm="4" class="text-sm-left"><b>Genre:</b></b-col>
              <b-col sm="8" class="text-sm-left">{{ row.item.Genre }}</b-col>
            </b-row>
            <b-row >
              <b-col sm="4" class="text-sm-left"><b>Created:</b></b-col>
              <b-col sm="8" class="text-sm-left">{{ getLocalTime( row.item.Created )}}</b-col>
            </b-row>
            <b-row >
              <b-col>---
              </b-col>
            </b-row>
            <b-row >
              <b-col sm="4" class="text-sm-left"><b>Buy:</b></b-col>
              <b-col sm="8" class="text-sm-left"><b-button disabled @click.stop="info(row.item, row.index, $event.target)" size="sm" variant="info">Buy</b-button></b-col>
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
          <b-col sm="6 " class="text-sm-left"> {{row.item.Owner}}

          </b-col>
          <b-col sm="3">
            <b-link target="_blank" class="text-primary" v-bind:href="etherscanAddress(row.item.Owner)" variant="danger">
              Etherscan
            </b-link>
          </b-col>
        </b-row>
        <b-row >
          <b-col sm="3" class="text-sm-left"><b>Token Contract address: </b></b-col>
          <b-col sm="6" class="text-sm-left">{{row.item.address}}

          </b-col>
          <b-col sm="3" class="text-sm-left">  <b-link target="_blank" class="text-primary" v-bind:href="etherscanToken(row.item.address)" variant="danger">
              Etherscan
            </b-link></b-col>
        </b-row>
        <b-row >
          <b-col sm="3" class="text-sm-left"><b>ICO Sale address: </b></b-col>
          <b-col sm="6" class="text-sm-left">{{row.item.saleAddress}}

          </b-col>
          <b-col sm="3" class="text-sm-left">  <b-link target="_blank" class="text-primary" v-bind:href="etherscanToken(row.item.saleAddress)" variant="danger">
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
          <p style="text-align:justify;padding:15px; height:100%;word-wrap: break-word;;border-style:solid;border-width:1px;border-color:#aaa;;border-radius:5px">  {{row.item.Description}}</p>
          </b-col>
          <b-col>
            <div v-html="row.item.iFrameEmbed"> </div>
            </b-col>
      </b-row>

    <br>
         <b-button size="sm" @click="row.toggleDetails">Hide Details</b-button>
      </b-card>
    </template>
  </b-table>

  <b-pagination  v-if="songsReady && !noSongs"  size="sm" :per-page="perPage" :total-rows="totalRows" v-model="currentPage" variant="primary">
  </b-pagination>
  <!-- <div style="width:100%;height:200px;border-style:solid;">
    TEST
    <b-row style="border-style:solid">
      <b-col  style="border-style:solid" sm=6>
        Row 1
        <b-row>
          <b-col  style="border-style:solid" sm=1>
            Col in Col
          </b-col>
        </b-row>
      </b-col>
      <b-col  style="border-style:solid" sm=6>
        Row 1
      </b-col>


    </b-row>
  </div> -->
  </div>
</template>

<script>
import axios from 'axios'
// import vueAxios from 'vue-axios'
// Vue.use(axios)
var BigNumber = require('bignumber.js')
var SC = require('soundcloud')

SC.initialize('rZY6FYrMpGVhVDfaKEHdCaY8ALekxd8P')
// SC.initialize('174155989')

var Web3 = require('web3')

export default {
  data () {
    return {
      sortBy: 'Created',
      modalInfo: { title: '', content: '' },
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
      tokensToBuy: 0,
      typeDrop: 3,
      fields: [
        { key: 'Picture', sortable: false, label: '' },
        { key: 'Type', sortable: false, label: '' },
        { key: 'Name', sortable: true },
        { key: 'Created', sortable: true, sortDirection: 'asc' },
        { key: 'Author', sortable: true },
        // { key: 'Phase', sortable: true },
        { key: 'Price', sortable: true },
        { key: 'Volume', sortable: true },
        { key: 'Contribution', sortable: true },
        { key: 'TotalSupply', sortable: true },
        // { key: 'Created', sortable: true },
        { key: 'Genre', sortable: true },
        // { key: 'Website', sortable: true },
        // { key: 'Buy', sortable: true },
        { key: 'show_details', sortable: false, label: '' }
      ],
      items: []
    }
  },
  created: function () {
    // this.$store.dispatch('ConnectToContract')

    console.log('Calling get songs and so on')
    this.$store.dispatch('GetSongs')
  },
  methods:
  {
    test (evt) {
      evt.preventDefault()
      console.log('test')
    },
    ShowBuyModal: function (item) {
      console.log(item)
      this.currentItem = item
      this.$refs.BuyTokensModal.show()
    },
    tokensForEth: function (rate, decimals) {
      if (rate === undefined) return null
      if (decimals === undefined) decimals = 0
      var weiInEth = Web3.utils.toWei('1', 'ether')
      var ret = (rate * weiInEth) / Math.pow(10, decimals)
      return ret.toLocaleString()
    },
    tokensPriceWei: function (rateInWei) {
      return this.tokensToBuy + ' ' + rateInWei
      // return tokensAmount / rateInWei
    },
    tokensPriceEth: function (rateInWei, tokensAmount) {
      var ret = (tokensAmount / rateInWei) / Web3.utils.toWei('1', 'ether')
      return BigNumber(ret).toFixed().toString()
    },
    filterType: function (type) {
      this.typeDrop = type
    },
    filterFunction: function (item) {
      var itemStr
      if (this.typeDrop !== 3 && (item.Type !== this.typeDrop)) return false
      for (var val in item) {
        // console.log(item[val])
        if (item[val] === undefined) continue
        if (item[val] !== undefined && typeof (item[val]) === 'string') {
          itemStr += item[val]
        } else {
          itemStr += item[val].toString()
        }
      }
      var re = new RegExp(this.tablefilter.toLowerCase())
      console.log('Filter: ', itemStr)
      console.log('Filter: ', item)
      return re.test(itemStr.toLowerCase())
    },
    getRelated: function (link) {
      axios.get('http://api.soundcloud.com/resolve?url=' + link + '&client_id=rZY6FYrMpGVhVDfaKEHdCaY8ALekxd8P').then(function (res) {
        console.log('RES:', res)
      })
    },
    etherscanToken: function (address) {
      return 'https://ropsten.etherscan.io/token/' + address
    },
    etherscanAddress: function (address) {
      return 'https://ropsten.etherscan.io/address/' + address
    },
    Price: function (val) {
      if (typeof (web3) === 'undefined') return val / 1000000000000000000
      if (val === undefined) return 'N/A'
      val = '' + val
      let price = Web3.utils.fromWei(val, 'ether')
      if (price < 0.001) {
        let big = BigNumber(price)
        return big.toExponential(5).toString()
      } else {
        return parseFloat(price).toFixed(6)
      }
    },
    info (item, index, button) {
      // this.modalInfo.title = `Row index: ${index}`
      // this.modalInfo.content = JSON.stringify(item, null, 2)
      this.$root.$emit('bv::show::modal', 'modalInfo', button)
    },
    resetModal () {

    },
    getLocalTime: function (val) {
      var ts = new Date(parseInt(val) * 1000)
      return ts.toLocaleString()
    },
    SongOrBand: function (val) {
      console.log('Song Or Band:', val)
      switch (parseInt(val)) {
        case 0: return 'Song'
        case 1: return 'Band'
        case 2: return 'Influencer'
        case 3: return 'All'
        default: return 'Error'
      }
    },
    // uint8 phase; // 1 - pre-sale, 2 - ico1, 3 - ico2, 4 - ico 3; 5 - post ico, 6 - finished, 0 - not running.
    PhaseToString: function (val) {
      if (isNaN(val)) return val
      var number = parseInt(val)
      switch (number) {
        case 0: return 'not running'
        case 1: return 'Pre sale'
        case 2: return 'ICO 1'
        case 3: return 'ICO 2'
        case 4: return 'ICO 3'
        case 5: return 'Post ICO'
        case 6: return 'Finished'
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
      console.log('loaded')
      alert('loaded')
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
        SC.oEmbed(link, {auto_play: true}).then(function (em) {
          that.musicPlayerLink = em.html
          that.loading = -1
          console.log(em)
        }).catch(function (err) {
          console.log(err)
        })
      }, 100)
    },
    localNumber: function (val) {
      if (isNaN(val)) return val
      var entry = parseFloat(val)
      var num = entry.toLocaleString()
      return num
    },
    BigValue: function (val) {
      if (isNaN(val)) return val
      console.log(val)
      var num = BigNumber(val)
      if (num.isGreaterThan(1000000000)) {
        return num.toExponential(5).toString()
      } else {
        // return 7
        return num.toString()
      }
    },
    picLink: function (id) {
      if (id === undefined) {
        return ''
      }
      console.log(this.$store.state.API + '/getPicture?id=' + id)
      return this.$store.state.API + '/getPicture?id=' + id
      // return 'https://source.unsplash.com/random/480x480'
    },
    isPlaying: function (rowNumber) {
      if (this.currentIndex === rowNumber) return true
      else return false
    }
  },
  computed: {
    noSongs: function () {
      return (this.songs.length === 0)
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

<style lang="css">
.player:hover
{
  filter:invert(100%) hue-rotate(120deg);

}

a{
  color:#fafafa;
}
.unPlayable {
  opacity:0.0;
  pointer-events: none;
}
</style>
