<style lang="css">
a {
  color: #fafafa;
  /* font-family:'Gothic'; */
  /* font-size:32px; */
  /* font-stretch:  expanded; */
}
</style>

<template lang="html">

<div class="">
  <b-modal hide-header ref="AddSongModal"  class="transactionsModal" size="lg" centered  body-bg-variant="secondary" 
  header-bg-variant="secondary"    ok-only ok-title="Close">
    <Transactions v-bind:pending='true'/>
  </b-modal >
    <!-- <b-container> -->

    <b-modal style="border-radius:5px;margin:0px 0px;" dismissible alert-variant="warning" variant="secondary" :visible="metaMaskUninstalled" ok-title="Understood" centered ok-only size="lg" hide-header :show="metaMaskUninstalled">
    <center style="padding:40px;">  MetaMask isn't installed. You need to install metamask in order to fully  use this application. You are still able to browse all entries, but you can't create new contract. <b-link style="color:#f6851b" target="_blank" href="https://metamask.io/"> <br><br>
      <img src="../assets/metamask.png" style="height:50px;"></img>
      <br><br>Go here to install => MetaMask  </b-link>
    </center>
    </b-modal>
    <b-navbar  toggleable="sm"  class="tunetradeMenu">


      <!-- <img src="../assets/singing.jpg" class="rounded-picture invert"> -->
      <!-- <img src="../assets/singing2.jpg" class="rounded-picture invert"> -->
      <!-- <img src="../assets/singing3.jpg" class="rounded-picture"> -->
      <!-- <img src="../assets/singing4.jpg" class="rounded-picture"> -->
        <b-navbar-brand class="menuElement">
            <router-link exact class="router-link" :to="{ name: 'SongList', params: {} }">List</router-link>
        </b-navbar-brand>
        <b-navbar-brand  class="menuElement">
            <router-link  exact  class="router-link"   :to="{ name: 'NewContract', params: {} }">Create Token </router-link>
        </b-navbar-brand>
        <b-navbar-brand class="menuElement">
            <router-link   exact class="router-link"    :to="{ name: 'TokenExchange', params: {filterProp: 'All', contractProp: ''} }">Token Exchange</router-link>
        </b-navbar-brand>
        <b-navbar-brand class="menuElement">
            <router-link   exact class="router-link"    :to="{ name: 'SongDetails', params: {song: {}} }">Song Details</router-link>
        </b-navbar-brand>
        <b-navbar-brand class="menuElement">
            <router-link   exact class="router-link"    :to="{ name: 'Transactions', params: {pending: false} }">Transactions</router-link>
        </b-navbar-brand>
        <b-navbar-brand class="menuElement">
            <router-link  exact class="router-link"     :to="{ name: 'About', params: {} }">About</router-link>
        </b-navbar-brand>
        <div class ="metamaskInfo" v-if="!loggedIn && !metaMaskUninstalled"><b>Please login to Metamask</b></div>
        <div class="debug">
        {{metaMaskUninstalled}}
        {{metaMaskAccount}}
        {{contractAddress}}
        {{loggedIn}}
      </div>
      <div/>

      <!-- {{ethereumAddress}} -->
    </b-navbar>
    <!-- </b-container> -->
</div>

</template>

<script>
import Transactions from "./Transactions";

export default {
  name: "Menu",
  components: {
    Transactions
  },
  data() {
    return {
      networkId: 0,
      metaMaskAccount: "ddd"
    };
  },
  created: function() {
    var that = this;
    if (typeof web3 === "undefined") {
      this.metaMaskAccount = undefined;
    } else {
      web3.currentProvider.publicConfigStore.on("update", function(err, res) {
        that.metaMaskAccount = web3.eth.defaultAccount;
      });

      web3.version.getNetwork(function(err, res) {
        that.networkId = parseInt(res);
      });

      this.metaMaskAccount = web3.eth.defaultAccount;
    }
  },
  watch: {
    soundCloudLink: function(val) {
      this.loadEmbed();
    },
    updatedTransactions: function(val) {
      if (val === true) {
        this.$refs.AddSongModal.show();
        this.$store.dispatch("clearUpdatedTransactions");
      }
    }
  },
  computed: {
    updatedTransactions: function() {
      return this.$store.state.updatedTransactions;
    },
    transactions: function() {
      return this.$store.state.transactions;
    },
    ethereumAddress: function() {
      return this.$store.state.contractAddress;
    },
    loggedIn: function() {
      if (typeof this.metaMaskAccount === "undefined") {
        this.$store.state.metaMaskLoggedOut = true;
        return false;
      } else {
        this.$store.state.metaMaskLoggedOut = false;
        return true;
      }
    },
    contractAddress: function() {
      return this.$store.state.web3contract.address;
    },
    metaMaskUninstalled: function() {
      if (typeof web3 === "undefined") {
        return true;
      } else {
        if (web3.currentProvider.constructor.name == "MetamaskInpageProvider")
          return false;
        else return true;
      }
    }
    // return web3.version.network
  }
};
</script>
