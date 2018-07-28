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

    <template slot="Name" slot-scope="row">
      &quot;{{row.item.Name}}&quot;
    </template>

    <template slot="row-details" slot-scope="row">
      <b-card style="background-color:#dadada;border-width:1px;border-style:solid;border-color:black">
        <b-row>
          <b-col sm="4">
        <b-row class="mb-2">
          <b-col sm="5" class="text-sm-left"><b>Type:</b></b-col>
          <b-col sm="auto" class="text-sm-left">{{ row.item.Type }}</b-col>
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
          <b-col sm="auto" class="text-sm-left">{{ row.item.Price }}</b-col>
        </b-row>
      </b-col>
      <b-col sm="4">
        <b-row class="mb-2">
          <b-col sm="5" class="text-sm-left"><b>Contribution:</b></b-col>
          <b-col sm="auto" class="text-sm-left">{{ row.item.Contribution }}</b-col>
        </b-row>
        <b-row class="mb-2">
          <b-col sm="5" class="text-sm-left"><b>Total Supply:</b></b-col>
          <b-col sm="auto" class="text-sm-left">{{ row.item.TotalSupply }}</b-col>
        </b-row>
            <b-row class="mb-2">
              <b-col sm="5" class="text-sm-left"><b>Genre:</b></b-col>
              <b-col sm="auto" class="text-sm-left">{{ row.item.Genre }}</b-col>
            </b-row>
        <b-row class="mb-2">
          <b-col sm="5" class="text-sm-left"><b>Created:</b></b-col>
          <b-col sm="auto" class="text-sm-left">{{ row.item.Created }}</b-col>
        </b-row>
      </b-col>
      <b-col sm="4">
        <b-row class="mb-2">
          <b-col sm="5" class="text-sm-left"><b>Phase:</b></b-col>
          <b-col sm="auto" class="text-sm-left">{{ row.item.Phase }}</b-col>
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
        <b-col sm="2" class="text-sm-left"><b>Owner:</b></b-col>
        <b-col sm="auto" class="text-sm-left">0xFb8E385876ca18d15308E8e0e2b6d026dDF6995A</b-col>
      </b-row>
      <b-row class="mb-2">
        <b-col sm="2  " class="text-sm-left"><b>Contract address:</b></b-col>
        <b-col sm="auto" class="text-sm-left">0xFb8E385876ca18d15308E8e0e2b6d026dDF6995A</b-col>
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
        { key: 'Type', sortable: false },
        { key: 'Name', sortable: true },
        { key: 'Author', sortable: true },
        // { key: 'Phase', sortable: true },
        { key: 'Price', sortable: true },
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
    info (item, index, button) {
      // this.modalInfo.title = `Row index: ${index}`
      // this.modalInfo.content = JSON.stringify(item, null, 2)
      this.$root.$emit('bv::show::modal', 'modalInfo', button)
    },
    resetModal () {

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
</style>
