<template lang="html">
  <div class="" style="margin:0px 0px;min-height:600px">
    <b-container fluid style="padding:0px;" >
      Filter Type: {{type}} <br>
      Filter Prop: {{filterProp}} <br>
      Contract Address: {{contractAddress}}<br>
      Contract Prop: {{contractProp}}
      <b-container   fluid class="navbarBox" style="margin:0px;">
        <b-container  class="">
          <div class="filterContainer">
            <!-- <div v-if="!showFilters"/> -->
            <b-navbar toggleable="md" style="padding:0px;">
              <b-nav-form class="filterBox">
              <div style="display:grid;grid-template-columns:1fr auto;padding:0px;">
                <input type="text" class="searchBox" placeholder="Search" v-model="tablefilter">
                <font-awesome-icon icon="search" class=" searchIcon" />
              </div>
                <b-button size="sm" v-on:click="filterType('All')" class="my-2 my-sm-0 typeButton" v-bind:class="{selectedType: type=='All'}"
                  type="submit">ALL</b-button>
                <b-button size="sm" v-on:click="filterType('Sale')" class="my-2 my-sm-0 typeButton" v-bind:class="{selectedType: type=='Sale'}"
                  type="submit">SALE</b-button>
                <b-button size="sm" v-on:click="filterType('Purchase')" class="my-2 my-sm-0 typeButton" type="submit"
                  v-bind:class="{selectedType: type=='Purchase'}">PURCHASE</b-button>
                <b-button size="sm" v-on:click="filterType('Mine')" class="my-2 my-sm-0 typeButton" type="submit"
                  v-bind:class="{selectedType: type=='Mine'}">MY POSITIONS</b-button>
                  <div/>
                <b-button size="sm" v-on:click="filterType(0)" class="my-2 my-sm-0" variant="info" type="submit">
                  CREATE NEW POSITION
                </b-button>

                <div />
              </b-nav-form>
            </b-navbar>
            <div />
          </div>
        </b-container>
      </b-container>
      <b-container fluid class="navbarBox">
      </b-container>
      <b-container>
        <b-table :items="salesItems" :fields="salesFields" tbody-tr-class="test" tbody-class="test" tbody-td-class="test"
        thead-class="headerClass" thead-tr-class="headerClass" class="songsTable" :filter="filterFunction">
        <template slot="details" slot-scope="row">
          <b-button size="sm" @click.stop="" variant="info" class="detailsButton"> Show details </b-button>
          <br>
          <!-- {{tokensForEth(row.item.Price,row.item.Decimals)}} -->
        </template>
      </b-table>
    </b-container>
    </b-container>
  </div>
</template>
<script>
export default {
  props: {
    filterProp: String,
    contractProp: String
  },
  data () {
    return {
      type: 'All',
      contractAddress: null,
      tablefilter: '',
      salesFields: [
        { key: 'type', sortable: true, label: 'Type:' },
        { key: 'date', sortable: true, label: 'Date:' },
        { key: 'name', sortable: true, label: 'Name:' },
        { key: 'symbol', sortable: true, label: 'Symbol:' },
        { key: 'price', sortable: true, label: 'Price:' },
        { key: 'volume', sortable: true, label: 'Volume:' },
        { key: 'cost', sortable: true, label: 'Cost:' },
        { key: 'owner', sortable: true, label: 'Owner' },
        { key: 'details', sortable: true, label: '' }
      ],
      salesItems: [
        {
          address: '0x3d120Fe11d24e05a18F8E750eA949e1c00eba4dB',
          type: 'Sale',
          date: '2018-01-01 12:00',
          name: 'Song For Sale',
          symbol: 'SYM',
          price: '1 ETH/SYM',
          volume: 1123.45,
          cost: '1123.45 ETH',
          buy: 'Buy',
          owner: '0xAb778A157dEC26bc3eF341d0De042FD2A2F38E1d'
        },
        {
          address: '0x3d120Fe11d24e05a18F8E750eA949e1c00eba4dB',
          type: 'Sale',
          date: '2018-01-01 12:00',
          name: 'Song For Sale',
          symbol: 'SYM',
          price: '1 ETH/SYM',
          volume: 1123.45,
          cost: '1123.45 ETH',
          buy: 'Buy',
          owner: '0xAb778A157dEC26bc3eF341d0De042FD2A2F38E1d'
        },
        {
          address: '0xAb778A157dEC26bc3eF341d0De042FD2A2F38E1d',
          type: 'Purchase',
          date: '2018-01-01 12:00',
          name: 'Song For Sale',
          symbol: 'SYM',
          price: '1 ETH/SYM',
          volume: 1123.45,
          cost: '1123.45 ETH',
          buy: 'Buy',
          owner: '0xAb778A157dEC26bc3eF341d0De042FD2A2F38E1d'
        },
        {
          address: '0xAb778A157dEC26bc3eF341d0De042FD2A2F38E1d',
          type: 'Purchase',
          date: '2018-01-01 12:00',
          name: 'Song For Sale',
          symbol: 'SYM',
          price: '1 ETH/SYM',
          volume: 1123.45,
          cost: '1123.45 ETH',
          buy: 'Buy',
          owner: 'Me'
        },
        {
          address: '0xAb778A157dEC26bc3eF341d0De042FD2A2F38E1d',
          type: 'Sale',
          date: '2018-01-01 12:00',
          name: 'Song For Sale',
          symbol: 'SYM',
          price: '1 ETH/SYM',
          volume: 1123.45,
          cost: '1123.45 ETH',
          buy: 'Buy',
          owner: '0xAb778A157dEC26bc3eF341d0De042FD2A2F38E1d'
        },
        {
          address: '0xAb778A157dEC26bc3eF341d0De042FD2A2F38E1d',
          type: 'Sale',
          date: '2018-01-01 12:00',
          name: 'Song For Sale',
          symbol: 'SYM',
          price: '1 ETH/SYM',
          volume: 1123.45,
          cost: '1123.45 ETH',
          buy: 'Buy',
          owner: 'Me'
        },
        {
          address: '0xAb778A157dEC26bc3eF341d0De042FD2A2F38E1d',
          type: 'Sale',
          date: '2018-01-01 12:00',
          name: 'Song For Sale',
          symbol: 'SYM',
          price: '1 ETH/SYM',
          volume: 1123.45,
          cost: '1123.45 ETH',
          buy: 'Buy',
          owner: 'Me'
        },
        {
          address: '0x3d120Fe11d24e05a18F8E750eA949e1c00eba4dB',
          type: 'Purchase',
          date: '2018-01-01 14:00',
          name: 'Song To Buy',
          symbol: 'SYM2',
          price: '0.3 ETH/SYM',
          volume: 500.45,
          cost: '150.135 ETH',
          buy: 'Sell',
          owner: '0xAb778A157dEC26bc3eF341d0De042FD2A2F38E1d'
        }
      ]
    }
  },
  created: function () {
    this.type = this.filterProp
    this.contractAddress = this.contractProp
  },
  methods: {
    filterType: function (type) {
      this.type = type
      this.contractAddress = ''
    },
    filterFunction: function (item) {
      var itemStr
      // if (this.type === 'All') return true
      if (!(this.type === 'All' || this.type === 'Mine') && this.type !== item.type) return false
      if (this.type === 'Mine' && item.owner !== 'Me') return false

      for (var val in item) {
        // console.log(item[val])
        if (item[val] === undefined) continue
        if (item[val] !== undefined && typeof item[val] === 'string') {
          itemStr += item[val] + ' '
        } else {
          itemStr += item[val].toString() + ' '
        }
      }
      var re = new RegExp(this.tablefilter.toLowerCase())
      return (re.test(itemStr.toLowerCase()) && (this.contractAddress === '' || this.contractAddress === item.address))
    }
  }
}
</script>
<style lang="css">
</style>