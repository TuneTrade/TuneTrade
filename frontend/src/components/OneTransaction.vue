<template lang="html">

  <b-container fluid style="padding:0px;margin:0px;" class="py-3 my-0">
    <!-- <b-button @click="addTransaction()"> Add </b-button> -->
  <b-row v-if="song">
    <b-col cols=12 class="text-center">
              <b-button
          variant="info"
          @click.stop="ShowSongDetails()"
          class="buyCoinButton mt-3"
        >Song Details</b-button><br><br>
    </b-col>
  </b-row>
    <!-- {{pending}} -->
  <!-- {{transactions}} -->
  <!-- This is my id: {{id}} -->
  <b-row>
    <b-col cols=12 class="">
    
  <b-container class="px-0" >

            <b-row class='detailsRow'>
              <b-col cols='12' class='text-center detailsInformation'> {{transaction.title}} </b-col>
            </b-row>
            <b-row class='detailsRow'>
              <b-col sm='12' class='text-center detailsInformation'> Gas used: {{localNumber(transaction.gasUsed)}} &nbsp;&nbsp; Block number: {{localNumber(transaction.blockNumber)}}  </b-col>
            </b-row>

            <b-row class='detailsRow'>

              <b-col cols=12 class='text-center detailsInformation'>   <b-link
    target="_blank"
    v-b-popover.hover="transaction.txNumber" title="Click to check transaction on Etherscan."
    style="font-size:12px; max-width: 90%;"
    class="text-primary text-truncate d-inline-block"
    v-bind:href="etherscanTx(transaction.txNumber)"
    variant="danger"
  >{{transaction.txNumber}}</b-link> </b-col>

            </b-row>

            <b-row class='detailsRow'>
            
              <b-col sm='12' class='text-center detailsInformation'> 
                  <span
    v-bind:class="{errorMessage: transaction.status=='Cancelled',successfulStatus: transaction.status=='Successful',successfulStatus: transaction.status=='Finished (Successful)', miningStatus: transaction.status=='Mining', failedStatus: transaction.status=='Failed'}"
  >{{transaction.status}}</span>
                  </b-col>

            </b-row>

            <b-row class='detailsRow px-5'>

              <b-col cols='12' style="word-break:break-all;" class='p-3  text-center  detailsInformation'>{{transaction.msg}}</b-col>

            </b-row>

   


  </b-container>
    </b-col>
  </b-row>

  </b-container>
</template>

<script>
export default {
  data() {
    return {
      index: 0,
    }
  },

  computed: {
    lastUpdate: function () {
      return this.$store.state.lastUpdate
    },
    transaction: function () {
      var that = this
      console.log(this.$store.state.transactions)
      return this.$store.state.transactions.find(function (element) {
        return element.index === that.id
      })
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
    song: String,
    id: Number
  },
  created: function () {
    console.log('Transaction id:', this.id)
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
