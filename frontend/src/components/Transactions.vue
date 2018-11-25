<template lang="html">
  <b-container class="transactionsModal">
    <!-- <b-button @click="addTransaction()"> Add </b-button> -->
    <br>
    <center> <b-button @click="cleanTransactions()"> Clean </b-button> </center>
    <center> <b-button @click="ClosedTransactions()"> Stop Refresh </b-button> </center>
    <br>
    <!-- {{pending}} -->
    <center>
      <img style="height:50px" src="../assets/metamask.png"></img><br><br>
      Last update: {{lastUpdate}}
      <p style="color:#fafafa;font-family:Roboto;font-weight:800">PLEASE ACCEPT YOUR TRANSACTION IN METAMASK</p>

   </center>

  <div v-for="transaction in transactions">
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
  </div>



  </b-container>
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
    pending: Boolean
  },
  methods: {
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
