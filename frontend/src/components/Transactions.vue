<template lang="html">
  <div class="">
    <!-- <b-button @click="addTransaction()"> Add </b-button> -->
    <b-button @click="cleanTransactions()"> Clean </b-button>
    <!-- {{pending}} -->
    <center>
      <img style="height:50px" src="../assets/metamask.png"></img><br><br>
      Last update: {{lastUpdate}}
      <p style="color:black;font-family:courier;font-weight:800">PLEASE ACCEPT YOUR TRANSACTION IN METAMASK</p>

   </center>

  <div v-for="transaction in transactions">
    <div style="font-family:Courier;margin:15px 0px;background-color:#ddd;border-radius:4px;padding:10px 20px;">
    Title: {{transaction.title}}<br>
    Number: {{transaction.txNumber}} <br>
    Index: {{transaction.index}} <br>
    Status:<b><span v-bind:class="{errorMessage: transaction.status=='Cancelled',successfulStatus: transaction.status=='Successful', miningStatus: transaction.status=='Mining', failedStatus: transaction.status=='Failed'}"> {{transaction.status}} </span></b> <br>
    <!-- Index: {{transaction.index}}<br> -->
    Block number: {{localNumber(transaction.blockNumber)}}<br>
    Gas Used: {{localNumber(transaction.gasUsed)}} <br>
    <span v-if="transaction.msg">Details: {{transaction.msg}}<br></span>
  </div>
  </div>



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
    pending: Boolean
  },
  methods: {
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
