<template lang="html">
  <div class="">
  <b-table :sort-by.sync="sortBy" :sort-desc.sync="sortDesc"striped hover :items="items" :fields="fields" small variant="danger">
    <template slot="Buy" slot-scope="row">
      <b-button size="sm" variant="info">Buy</b-button>
    </template>
    <template slot="show_details" slot-scope="row">
      <b-button size="sm" @click.stop="row.toggleDetails"  variant="info">
      {{ row.detailsShowing ? 'Hide' : 'Show'}}  Details
      </b-button>
    </template>
    <template slot="TotalSupply" slot-scope="row">
      {{localNumber (row.item.TotalSupply)}}
    </template>
    <template slot="row-details" slot-scope="row">
      <b-card style="background-color:#dadada;border-width:1px;border-style:solid;border-color:black">
        <b-row>
          <b-col sm="6">
        <b-row class="mb-2">
          <b-col sm="3" class="text-sm-left"><b>Type:</b></b-col>
          <b-col sm="auto" class="text-sm-left">{{ row.item.Type }}</b-col>
        </b-row>
        <b-row class="mb-2">
          <b-col sm="3" class="text-sm-left"><b>Name:</b></b-col>
          <b-col sm="auto" class="text-sm-left">{{ row.item.Name }}</b-col>
        </b-row>
        <b-row class="mb-2">
          <b-col sm="3" class="text-sm-left"><b>Author:</b></b-col>
          <b-col sm="auto" class="text-sm-left">{{ row.item.Author }}</b-col>
        </b-row>
        <b-row class="mb-2">
          <b-col sm="3" class="text-sm-left"><b>Price:</b></b-col>
          <b-col sm="auto" class="text-sm-left">{{ row.item.Price }}</b-col>
        </b-row>
        <b-row class="mb-2">
          <b-col sm="3" class="text-sm-left"><b>Contribution:</b></b-col>
          <b-col sm="auto" class="text-sm-left">{{ row.item.Contribution }}</b-col>
        </b-row>
        <b-row class="mb-2">
          <b-col sm="3" class="text-sm-left"><b>Total Supply:</b></b-col>
          <b-col sm="auto" class="text-sm-left">{{ row.item.TotalSupply }}</b-col>
        </b-row>
        <b-row class="mb-2">
          <b-col sm="3" class="text-sm-left"><b>Genre:</b></b-col>
          <b-col sm="auto" class="text-sm-left">{{ row.item.Genre }}</b-col>
        </b-row>
      </b-col>
          <b-col sm="6">
        <b-row class="mb-2">
          <b-col sm="3" class="text-sm-left"><b>Created:</b></b-col>
          <b-col sm="auto" class="text-sm-left">{{ row.item.Created }}</b-col>
        </b-row>
        <b-row class="mb-2">
          <b-col sm="3" class="text-sm-left"><b>Phase:</b></b-col>
          <b-col sm="auto" class="text-sm-left">{{ row.item.Phase }}</b-col>
        </b-row>
        <b-row class="mb-2">
          <b-col sm="3" class="text-sm-left"><b>Website:</b></b-col>
          <b-col sm="auto" class="text-sm-left"><b-button size="sm" variant="info">Website</b-button></b-col>
        </b-row>
        <b-row class="mb-2">
          <b-col sm="3" class="text-sm-left"><b>Buy:</b></b-col>
          <b-col sm="auto" class="text-sm-left"><b-button size="sm" variant="info">Buy</b-button></b-col>
        </b-row>
      </b-col>
    </b-row>
    <br>
         <b-button size="sm" @click="row.toggleDetails">Hide Details</b-button>
      </b-card>
    </template>
  </b-table>
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
      sortDesc: false,
      fields: [
        { key: 'Type', sortable: true },
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
        { key: 'show_details', sortable: true }
      ],
      items: items
    }
  },
  methods:
  {
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
