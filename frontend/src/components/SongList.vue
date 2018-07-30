<template lang="html">
  <div class="">
    <b-modal id="modalInfo" @hide="resetModal" ok-only show centered>
      <!-- <pre>{{ modalInfo.content }}</pre> -->
    </b-modal>
    <b-navbar toggleable="sm" type="dark" variant="secondary">
      <b-nav-form>
        <b-form-input size="sm" v-model="tablefilter" class="mr-sm-2" type="text" placeholder="Search"/>
        <b-button size="sm" class="my-2 my-sm-0" type="submit">Search</b-button>
      </b-nav-form>
      <b-nav-item-dropdown text="Type" right style="list-style:none;">
        <b-dropdown-item href="#">Song</b-dropdown-item>
        <b-dropdown-item href="#">Band</b-dropdown-item>
        <b-dropdown-item href="#">All</b-dropdown-item>
      </b-nav-item-dropdown>
    </b-navbar>
  <b-table :sort-by.sync="sortBy" :current-page="currentPage" :per-page="perPage" :sort-desc.sync="sortDesc"striped hover :items="songs" :fields="fields" small variant="danger" :filter="tablefilter">
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
    <template slot="Contribution" slot-scope="row">
      {{localNumber (row.item.Contribution)}}
    </template>

    <template slot="Type" slot-scope="row">
      {{SongOrBand (row.item.Type)}}
    </template>
    <template slot="Picture" slot-scope="row">
      <div style="display:grid;grid-template-columns:1fr 2fr;">
      <img src="../assets/player.png" alt="" class="player" style="width:30px;margin:5px">
      <iframe allowtransparency="true" scrolling="no" frameborder="no" src="https://w.soundcloud.com/icon/?url=http%3A%2F%2Fsoundcloud.com%2Fflickphlack%2Fdrake-in-my-feelings-kiki-do-you-love-me-loop-1&color=orange_white&size=32" style="width: 32px; height: 32px;"></iframe>
      <iframe width="50px" height="50px" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/34019569&amp;"></iframe>
      <img src="../assets/album.jpg" alt="" style="width:50px">
    </div>
      <!-- {{SongOrBand (row.item.Type)}} -->
    </template>

    <template slot="Name" slot-scope="row">
      &quot;{{row.item.Name}}&quot;
    </template>

    <template slot="row-details" slot-scope="row">
      <b-card style="background-color:#dadada;border-width:1px;border-style:solid;border-color:black">
        <b-row>
          <b-col sm="4">
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
      </b-col>
      <b-col sm="4">
        <b-row class="mb-2">
          <b-col sm="5" class="text-sm-left"><b>Contribution:</b></b-col>
          <b-col sm="auto" class="text-sm-left">{{ row.item.Contribution }}</b-col>
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
      </b-col>
      <b-col sm="4">
        <b-row class="mb-2">
          <b-col sm="5" class="text-sm-left"><b>Phase:</b></b-col>
          <b-col sm="auto" class="text-sm-left">{{ PhaseToString(row.item.Phase) }}</b-col>
        </b-row>
        <b-row class="mb-2">
          <b-col sm="5" class="text-sm-left"><b>Website:</b></b-col>
          <b-col sm="auto" class="text-sm-left"><b-button size="sm" variant="info">Website</b-button></b-col>
        </b-row>

        <b-row class="mb-2">
          <b-col sm="5" class="text-sm-left"><b>Buy:</b></b-col>
          <b-col sm="auto" class="text-sm-left"><b-button  @click.stop="info(row.item, row.index, $event.target)" size="sm" variant="info">Buy</b-button></b-col>
        </b-row>
      </b-col>
    </b-row>
    <br>
      <b-row class="mb-2">
        <b-col>
        <b-col sm="4" class="text-sm-left"><b>Owner:</b></b-col>
        <b-col sm="auto" class="text-sm-left">0xFb8E385876ca18d15308E8e0e2b6d026dDF6995A</b-col>
        <b-col sm="4  " class="text-sm-left"><b>Contract address:</b></b-col>
        <b-col sm="auto" class="text-sm-left">0xFb8E385876ca18d15308E8e0e2b6d026dDF6995A</b-col>
      </b-col>
        <b-col sm="4" class="text-sm-left"><img src="../assets/album.jpg"></img></b-col>
        <b-col><iframe width="100%" height="166" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/34019569&amp;color=0066cc"></iframe></b-col>
      </b-row>
      <b-row class="mb-2">
      </b-row>

    <br>
         <b-button size="sm" @click="row.toggleDetails">Hide Details</b-button>
      </b-card>
    </template>
  </b-table>
  <b-pagination size="sm" :per-page="perPage" :total-rows="totalRows" v-model="currentPage" variant="dark">
  </b-pagination>
  <div>We have {{songsCounter}} songs.</div>
  </div>
</template>

<script>
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
      sortBy: 'age',
      modalInfo: { title: '', content: '' },
      sortDesc: false,
      tablefilter: '',
      currentPage: 1,
      perPage: 10,
      totalRows: 20,
      fields: [
        { key: 'Picture', sortable: false },
        { key: 'Type', sortable: false },
        { key: 'Name', sortable: true },
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
        { key: 'show_details', sortable: false }
      ],
      items: items
    }
  },
  created: function () {
    this.$store.dispatch('ConnectToContract')
  },
  methods:
  {
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
      if (val === true) return 'Band'
      else return 'Song'
    },
    // uint8 phase; // 1 - pre-sale, 2 - ico1, 3 - ico2, 4 - ico 3; 5 - post ico, 6 - finished, 0 - not running.
    PhaseToString: function (val) {
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
    localNumber: function (val) {
      if (isNaN(val)) return 0
      var entry = parseFloat(val)
      var num = entry.toLocaleString()
      return num
    }
  },
  computed: {
    songs: function () {
      return this.$store.state.songs
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
