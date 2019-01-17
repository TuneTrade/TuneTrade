<template lang="html">

  <b-container fluid style="padding:0px;margin:0px;" class="py-0 my-0">
    <!-- <b-button @click="addTransaction()"> Add </b-button> -->
  <b-row v-if="song">
    <b-col>
              <b-button
          variant="info"
          @click.stop="ShowSongDetails()"
          class="buyCoinButton mt-3"
        >Song Details</b-button><br><br>
    </b-col>
  </b-row>
    <!-- {{pending}} -->
  <!-- {{transactions}} -->
  <!-- <br><br> -->
        <b-container fluid class="navbarBox mx-0 p-0">
      </b-container>
      <b-container class="mx-auto  p-0 mx-0">

    <b-table     thead-class=" headerClass text-left"  tbody-class="text-left  tableBodyClass"  thead-tr-class=" text-left TokeExchangeTableRow"  sort-direction="desc" sort-by="Created" :current-page="currentPage"
        :per-page="perPage" sort-desc="true" :items="transactions" :fields="fields" :filter="filterFunction" class=" text-left songsTable">
        <template slot="blockNumber" slot-scope="row">{{localNumber(row.item.blockNumber)}}</template>
        <template slot="gasUsed" slot-scope="row">{{localNumber(row.item.gasUsed)}}</template>
        <template slot="smscreen" slot-scope="row">
  <b-link
    target="_blank"
    style="font-size:8px;"
    class="text-primary"
    v-bind:href="etherscanTx(row.item.txNumber)"
    variant="danger"
  >{{row.item.txNumber}}</b-link>
  <br>
  <span
    class="text-left"
    v-bind:class="{errorMessage: row.item.status=='Cancelled',successfulStatus: row.item.status=='Successful',successfulStatus: row.item.status=='Finished (Successful)', miningStatus: row.item.status=='Mining', failedStatus: row.item.status=='Failed'}"
  >{{row.item.status}}</span>
</template>
        <template slot="txNumber" slot-scope="row">
  <b-link
    target="_blank"
    style="font-size:11px;"
    class="text-primary"
    v-bind:href="etherscanTx(row.item.txNumber)"
    variant="danger"
  >{{row.item.txNumber}}</b-link>
</template>
        <template slot="status" slot-scope="row">
  <span
    v-bind:class="{errorMessage: row.item.status=='Cancelled',successfulStatus: row.item.status=='Successful',successfulStatus: row.item.status=='Finished (Successful)', miningStatus: row.item.status=='Mining', failedStatus: row.item.status=='Failed'}"
  >{{row.item.status}}</span>
</template>
      
        </b-table>
    </b-container>
  <!-- <div v-for="transaction in transactions">
    <div class ="transaction">
            <b-row class='detailsRow'>
              <b-col sm='1' class='text-sm-left'>Title:</b-col>
              <b-col sm='5' class='text-sm-left detailsInformation'> {{transaction.title}} </b-col>

              <b-col sm='2' class='text-sm-left'>Index:</b-col>
              <b-col sm='4' class='text-sm-left detailsInformation'> {{transaction.index}} </b-col>


            </b-row>
            <b-row class='detailsRow'>

              <b-col sm='1' class='text-sm-left'>Gas used:</b-col>
              <b-col sm='5' class='text-sm-left detailsInformation'> {{localNumber(transaction.gasUsed)}} </b-col>
            

              <b-col sm='2' class='text-sm-left'>Block number:</b-col>
              <b-col sm='4' class='text-sm-left detailsInformation'>  {{localNumber(transaction.blockNumber)}} </b-col>

    
            </b-row>

            <b-row class='detailsRow'>

              <b-col sm='1' class='text-sm-left'>Number:</b-col>
              <b-col sm='11' class='text-sm-left detailsInformation'> {{transaction.txNumber}} </b-col>

            </b-row>

            <b-row class='detailsRow'>
            
              <b-col sm='1' class='text-sm-left'>Status:</b-col>
              <b-col sm='11' class='text-sm-left detailsInformation'> <b><span v-bind:class="{errorMessage: transaction.status=='Cancelled',successfulStatus: transaction.status=='Successful', miningStatus: transaction.status=='Mining', failedStatus: transaction.status=='Failed'}"> {{transaction.status}} </span></b> </b-col>

            </b-row>

            <b-row class='detailsRow'>

              <b-col sm='12' class='text-sm-left detailsInformation'>{{transaction.msg}}</b-col>

            </b-row>

   
  </div>
  </div> -->



  </b-container>
</template>

<script>
export default {
  data() {
    return {
      index: 0,
      fields: [

        {
          key: "title",
          sortable: false,
          label: "Title",
          tdStyle: 'height:50px',
          tdClass: "d-md-table-cell d-none py-3  px-3 text-left",
          thClass: "d-md-table-cell d-none text-left "

        },
        {
          key: "status",
          sortable: false,
          label: "Status",
          tdClass: "d-md-table-cell d-none  text-left px-3 ",
          thClass: "d-md-table-cell d-none text-left  "
        },
        {
          key: 'smscreen',
          sortable: false,
          thClass: 'd-none',
          tdClass: 'd-table-cell d-md-none py-2 text-left px-2',
          label: 'Transactions'
        },
        {
          key: "txNumber",
          sortable: false,
          label: "Transaction Number",
          tdClass: "d-md-table-cell d-none  text-left px-3",
          thClass: "d-md-table-cell d-none text-left  "
        },
        {
          key: "blockNumber",
          sortable: false,
          label: "Block Number",
          tdClass: "d-lg-table-cell d-none  text-left px-3",
          thClass: "d-lg-table-cell d-none text-left  "
        },
        {
          key: "gasUsed",
          sortable: false,
          label: "Gas Used",
          tdClass: "d-lg-table-cell d-none  text-left px-3",
          thClass: "d-lg-table-cell d-none text-left  "

        }
      ]
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
    pending: Boolean,
    song: String
  },
  methods: {
    etherscanTx: function (address) {
      return 'https://ropsten.etherscan.io/tx/' + address
    },
    ShowSongDetails: function () {
      this.$store.state.showTransactions = null
      this.$store.state.showTransactions = {}
      this.$store.state.showTransactions[this.song] = false
    },
    ClosedTransactions: function () {
      this.$store.dispatch('DoNotRefreshTransactions')
    },
    displayTx: function (tx) {
      if (this.showOnlyPending) {
        return (tx.id === 1 || tx.id === 2)
      } else {
        return true
      }
    },
    addTransaction: function () {
      var payload = {}
      payload.title = 'DUPA'
      this.$store.dispatch('AddTransaction', payload)
      console.log(this.$store.getters.getTransactionIndex)
    },
    cleanTransactions: function () {
      this.$store.dispatch('CleanTransactions')
    },
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
