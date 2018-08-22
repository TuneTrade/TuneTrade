<template lang="html">
  <div class="" style="margin:0px 0px;">
    <b-modal id="modalInfo" @hide="resetModal" ok-only show centered>
      <!-- <pre>{{ modalInfo.content }}</pre> -->
      <iframe v-on:abort="onAbort()" v-on:error="onError()" v-on:load="loaded()" width="100%" height="450" scrolling="no" frameborder="no" allow="autoplay" v-bind:src="musicPlayerLink"></iframe>
    </b-modal>
    <b-navbar  style="border-radius:5px;margin:30px 0px;box-shadow:2px 2px 5px black;background-color:rgba(230,210,230,0.7);" toggleable="md" type="dark" variant="secondary">
      <b-nav-form>
        <b-form-input size="sm" v-model="tablefilter" class="mr-sm-2" type="text" placeholder="Search"/>
        <b-button size="sm" class="my-2 my-sm-0" type="submit">Search</b-button>
      </b-nav-form>
      <b-nav-item-dropdown text="Type" right style="list-style:none;opacity:1;z-index:2,overflow:visible">
        <b-dropdown-item href="#">Song</b-dropdown-item>
        <b-dropdown-item href="#">Band</b-dropdown-item>
        <b-dropdown-item href="#">Influencer</b-dropdown-item>
        <b-dropdown-item href="#">All</b-dropdown-item>
      </b-nav-item-dropdown>
    </b-navbar>
  <b-table sort-direction="desc" sort-by="Created" :current-page="currentPage" :per-page="perPage" sort-desc="true" striped hover :items="songs" :fields="fields" small variant="danger" :filter="tablefilter" class="songsTable">
    <template slot="Buy" slot-scope="row">
      <b-button size="sm" variant="info"  @click.stop="info(row.item, row.index, $event.target)">Buy</b-button>
    </template>
    <template slot="show_details" slot-scope="row">
      <b-button size="sm" @click.stop="row.toggleDetails"  variant="info">
      {{ row.detailsShowing ? 'Hide' : 'Show'}}  Details
      </b-button>
    </template>
    <template slot="TotalSupply" slot-scope="row">
      {{localNumber (row.item.TotalSupply)}}
    </template>

    <template slot="Volume" slot-scope="row">
      {{localNumber (row.item.Volume)}}
    </template>

    <template slot="Price" slot-scope="row">
      {{Price(row.item.Price)}}
    </template>
    <template slot="Contribution" slot-scope="row">
      {{localNumber (row.item.Contribution)}}
    </template>

    <template slot="Type" slot-scope="row">
      {{SongOrBand (row.item.Type)}}
    </template>
    <template slot="Picture" slot-scope="row">
      <div style="display:grid;grid-template-columns:1fr 2fr;">
        <a v-if="!isLoading(row.item.OrderNum) && isPlaying(row.item.OrderNum)" v-on:click="playMusic(row.item.OrderNum)">
      <img  src="../assets/pauseplayer.png" alt="" class="player" style="width:30px;margin:5px"></a>
        <a v-if="isLoading(row.item.OrderNum)" v-on:click="playMusic(row.item.OrderNum)">
      <img  src="../assets/loadingplayer.png" alt="" class="player" style="width:30px;margin:5px"></a>

      <a v-if="!isLoading(row.item.OrderNum) && !isPlaying(row.item.OrderNum)" v-on:click="playMusic(row.item.OrderNum)">
      <img  src="../assets/player.png" alt="" class="player" style="width:30px;margin:5px"></a>
      <!-- <iframe allowtransparency="true" scrolling="no" frameborder="no" src="https://w.soundcloud.com/icon/?url=http%3A%2F%2Fsoundcloud.com%2Fflickphlack%2Fdrake-in-my-feelings-kiki-do-you-love-me-loop-1&color=orange_white&size=32" style="width: 32px; height: 32px;"></iframe>
      <iframe width="50px" height="50px" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/34019569&amp;"></iframe> -->
      <img v-bind:src="picLink(row.item.OrderNum)" alt="" style="width:50px">
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
      <b-card style="background-color:rgba(0,0,0,0.1);border-width:1px;border-style:solid;border-color:black;">
        <b-row>
          <b-col sm="4" class="text-sm-left"><img v-bind:src="picLink(row.item.OrderNum)" width=240px height=240px></img>
          </b-col>
          <b-col sm="8">
            <b-row>
            <b-col sm="6">
              <b-row class="mb-2">
                <b-col sm="5" class="text-sm-left"><b>Type:</b></b-col>
                <b-col sm="auto" class="text-sm-left">{{ SongOrBand(row.item.Type) }}</b-col>
              </b-row>
              <b-row class="mb-2">
                <b-col sm="5" class="text-sm-left"><b>Name:</b></b-col>
                <b-col sm="auto" class="text-sm-left">&quot;{{ row.item.Name }}&quot;</b-col>
              </b-row>
              <b-row class="mb-2">
                <b-col sm="5" class="text-sm-left"><b>Author:</b></b-col>
                <b-col sm="auto" class="text-sm-left">{{ row.item.Author }}</b-col>
              </b-row>
              <b-row class="mb-2">
                <b-col sm="5" class="text-sm-left"><b>Price:</b></b-col>
                <b-col sm="auto" class="text-sm-left">{{Price(row.item.Price)}}</b-col>
              </b-row>
              <b-row class="mb-2">
                <b-col sm="5" class="text-sm-left"><b>Phase:</b></b-col>
                <b-col sm="auto" class="text-sm-left">{{ PhaseToString(row.item.Phase) }}</b-col>
              </b-row>
              <b-row class="mb-2">
                <b-col sm="5" class="text-sm-left"><b>Website:</b></b-col>
                <b-col sm="auto" class="text-sm-left"><b-button target="_blank" href="https://soundcloud.com/kodak-black" size="sm" variant="info">Website</b-button></b-col>
              </b-row>

            </b-col>
            <b-col sm="6">
              <b-row class="mb-2">
                <b-col sm="5" class="text-sm-left"><b>Contribution:</b></b-col>
                <b-col sm="auto" class="text-sm-left">{{ localNumber(row.item.Contribution) }}</b-col>
              </b-row>
              <b-row class="mb-2">
                <b-col sm="5" class="text-sm-left"><b>Volume:</b></b-col>
                <b-col sm="auto" class="text-sm-left">{{ localNumber(row.item.Volume) }}</b-col>
              </b-row>
            <b-row class="mb-2">
              <b-col sm="5" class="text-sm-left"><b>Total Supply:</b></b-col>
              <b-col sm="auto" class="text-sm-left">{{ localNumber(row.item.TotalSupply) }}</b-col>
            </b-row>
            <b-row class="mb-2">
              <b-col sm="5" class="text-sm-left"><b>Genre:</b></b-col>
              <b-col sm="auto" class="text-sm-left">{{ row.item.Genre }}</b-col>
            </b-row>
            <b-row class="mb-2">
              <b-col sm="5" class="text-sm-left"><b>Created:</b></b-col>
              <b-col sm="auto" class="text-sm-left">{{ getLocalTime( row.item.Created )}}</b-col>
            </b-row>
            <b-row class="mb-2">
              <b-col>---
              </b-col>
            </b-row>
            <b-row class="mb-2">
              <b-col sm="5" class="text-sm-left"><b>Buy:</b></b-col>
              <b-col sm="auto" class="text-sm-left"><b-button disabled @click.stop="info(row.item, row.index, $event.target)" size="sm" variant="info">Buy</b-button></b-col>
            </b-row>
          </b-col>
        </b-row>
        <b-row>
          <b-col style="margin:10px 0px">
          </b-col>
        </b-row>
        <b-row class="mb-2">
          <b-col sm="3" class="text-sm-left"><b>Owner:</b></b-col>
          <b-col sm="8" class="text-sm-left"> {{row.item.Owner}}
            <b-link target="_blank" class="text-primary" v-bind:href="etherscanAddress(row.item.Owner)" variant="danger">
              Etherscan
            </b-link>
          </b-col>
        </b-row>
        <b-row class="mb-2">
          <b-col sm="3" class="text-sm-left"><b>Contract address: </b></b-col>
          <b-col sm="8" class="text-sm-left">{{row.item.address}}
            <b-link target="_blank" class="text-primary" v-bind:href="etherscanToken(row.item.address)" variant="danger">
              Etherscasn
            </b-link>
          </b-col>
        </b-row>
        </b-col>
    </b-row>

    <br>
    <b-row  class="mb-2">
      <b-col sm="6" class="text-sm-left"><b>Description:</b></b-col>
      <b-col sm="6" class="text-sm-left"><b></b></b-col>
    </b-row>
      <b-row class="mb-2">

        <b-col sm="6" class="text-sm-left" >
          <p style="text-align:justify; height:100%;word-wrap: break-word;width:100%;border-style:solid;border-width:1px;border-color:#aaa;padding:20px;border-radius:5px">  {{row.item.Description}}</p>
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
  <b-pagination style="box-shadow:2px 2px 2px; width:117px" size="sm" :per-page="perPage" :total-rows="totalRows" v-model="currentPage" variant="dark">
  </b-pagination>
  <div>We have {{songsCounter}} songs.</div>
  </div>
</template>

<script>

var SC = require('soundcloud')
SC.initialize('rZY6FYrMpGVhVDfaKEHdCaY8ALekxd8P')

var Web3 = require('web3')

const items = [
  {
    Name: 'Red Hot Chilli Peppers',
    Author: 'John Green',
    Type: 'Song',
    Phase: 'Pre-Sale',
    Price: '0.001 ETH',
    Contribution: '35%',
    TotalSupply: 1200,
    Genre: 'Pop',
    Created: '12/07/2018 18:56:34',
    Website: 'Link',
    Buy: 'Buy',
    show_details: ''
  },
  {
    Name: 'Red Hot Chilli Peppers',
    Author: 'John Green',
    Type: 'Song',
    Phase: 'Pre-Sale',
    Price: '0.001 ETH',
    Contribution: '35%',
    TotalSupply: 1200,
    Genre: 'Rock',
    Created: '12/07/2018 18:56:34',
    Website: 'Link',
    Buy: 'Buy',
    show_details: ''
  },
  {
    Name: 'Red Hot Chilli Peppers',
    Author: 'John Green',
    Type: 'Song',
    Phase: 'Pre-Sale',
    Price: '0.001 ETH',
    Contribution: '35%',
    TotalSupply: 1200,
    Genre: 'Trip Hop',
    Created: '12/07/2018 18:56:34',
    Website: 'Link',
    Buy: 'Buy',
    show_details: ''
  },
  {
    Name: 'Red Hot Chilli Peppers',
    Author: 'John Green',
    Type: 'Song',
    Phase: 'Pre-Sale',
    Price: '0.001 ETH',
    Contribution: '35%',
    TotalSupply: 1200,
    Genre: 'Pop',
    Created: '12/07/2018 18:56:34',
    Website: 'Link',
    Buy: 'Buy',
    show_details: ''
  }
]
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
      items: items
    }
  },
  created: function () {
    // this.$store.dispatch('ConnectToContract')

    console.log('Calling get songs and so on')
    this.$store.dispatch('GetSongs')
  },
  methods:
  {
    etherscanToken: function (address) {
      return 'https://rinkeby.etherscan.io/token/' + address
    },
    etherscanAddress: function (address) {
      return 'https://rinkeby.etherscan.io/address/' + address
    },
    Price: function (val) {
      return Web3.utils.fromWei(val, 'ether')
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
      // alert('loaded')
    },
    isLoading: function (index) {
      if (this.changing === index || this.loading === index) {
        return true
      } else {
        return false
      }
    },
    playMusic: function (index) {
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
        that.musicPlayerLink = 'https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/playlists/232694761&color=%231f0604&auto_play=true&hide_related=false&show_comments=true&show_user=true&show_reposts=false&show_teaser=true'
        console.log(this.musicPlayerLink)
      }, 100)
    },
    localNumber: function (val) {
      if (isNaN(val)) return val
      var entry = parseFloat(val)
      var num = entry.toLocaleString()
      return num
    },
    picLink: function (index) {
      console.log('PIC LINK:', index)
      if (index === undefined) {
        return ''
      }
      var height = 240 + (index % 20)
      return 'https://source.unsplash.com/collection/1301616/' + height + 'x240'
      // return 'https://source.unsplash.com/random/480x480'
    },
    isPlaying: function (rowNumber) {
      if (this.currentIndex === rowNumber) return true
      else return false
    }
  },
  computed: {
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
</style>
