
<template lang="html">
<div class="">
  <!-- <b-modal hide-header ref="AddSongModal"  class="transactionsModal" size="lg" centered  body-bg-variant="secondary" 
  header-bg-variant="secondary"   @ok='ClosedTransactions()' ok-only ok-title="Close">
    <Transactions  v-bind:pending='true'/>
  </b-modal > -->
    <!-- <b-container> -->

    <b-modal style="border-radius:5px;margin:0px 0px;" dismissible alert-variant="warning" variant="secondary" :visible="metaMaskUninstalled" ok-title="Understood" centered ok-only size="md" hide-header :show="metaMaskUninstalled">
    <center style="padding:40px;">  MetaMask isn't installed. You need to install metamask in order to fully  use this application. You are still able to browse all entries, but you can't create new contract. <b-link style="color:#f6851b" target="_blank" href="https://metamask.io/"> <br><br>
      <img src="../assets/metamask.png" style="height:50px;"></img>
      <br><br>Go here to install => MetaMask  </b-link>
    </center>
    </b-modal>

    <b-navbar v-if="!loggedIn && !metaMaskUninstalled" class="p-0 fixed-top bg-dark" style="width:100%;margin:0;top:70px;">
      <b-container class="text-center">

      <b-navbar-nav style="width:100%;margin:0;padding:0;">
       
        <b-nav-text   class="text-white text-uppercase" style="width:100%; height:50px;">
        <font-awesome-icon  icon="exclamation-circle" style="color:#BB0000;margin-bottom:5px; margin-left:10px;"></font-awesome-icon>
        login to Metamask 


      </b-nav-text>  
      </b-navbar-nav>
      </b-container>

    </b-navbar>
  <!-- {{windowHeight}} -->

    <b-navbar  style="height:70px;" toggleable="md"  class="fixed-top bg-dark navbar navbar-default  tunetradeMenu navbar-dark mt-0">

      <b-navbar-toggle  @click.native ="ToggledMenu()" target="nav_text_collapse"></b-navbar-toggle>
      <b-navbar-brand class="d-xl-none d-lg-none d-md-none"><img src="../assets/whitelogo.png"  style="width:60px"> </img></b-navbar-brand>

      <b-collapse ref="toggle" is-nav id="nav_text_collapse" class="bg-dark toggledMenu" >
      <b-container>
      <b-navbar-nav>
      <b-navbar-brand class="d-none d-md-block"><img src="../assets/whitelogo.png"  style="width:60px"> </img></b-navbar-brand>
   
        <b-nav-item class="menuElement" @click="toggle()">
            <router-link    class="router-link" :to="{ name: 'SongList', params: {} }">List</router-link>
        </b-nav-item>
        <b-nav-item  class="menuElement" @click="toggle()">
            <router-link  exact  class="router-link"   :to="{ name: 'NewContract', params: {} }">Create Token </router-link>
        </b-nav-item>
        <b-nav-item class="menuElement" @click="toggle()">
            <router-link   exact  class="router-link"    :to="{ name: 'TokenExchange', params: {filterProp: 'All', contractProp: ''} }">Token Exchange</router-link>
        </b-nav-item>
        <b-nav-item class="menuElement" @click="toggle()">
            <router-link   exact  class="router-link"    :to="{ name: 'Transactions', params: {pending: false} }">Transactions</router-link>
        </b-nav-item>
        
        <b-nav-item class="menuElement" @click="toggle()">
            <router-link   exact  class="router-link"    :to="{name: 'Tutorial'}">Tutorial</router-link>
        </b-nav-item>

        <b-nav-item class="menuElement" @click="toggle()">
            <router-link  exact  class="router-link"     :to="{ name: 'About', params: {} }">About</router-link>
        </b-nav-item>

       </b-navbar-nav>
      </b-container>

      </b-collapse>

    </b-navbar>



      <!-- <img src="../assets/singing.jpg" class="rounded-picture invert"> -->
      <!-- <img src="../assets/singing2.jpg" class="rounded-picture invert"> -->
      <!-- <img src="../assets/singing3.jpg" class="rounded-picture"> -->
      <!-- <img src="../assets/singing4.jpg" class="rounded-picture"> -->
          <!-- <div class="placeHolder" id="syncIcon">
{{windowHeight}}
          <font-awesome-icon  icon="spinner" class="fa-2x fa-pulse refreshIcon" v-bind:class="{refreshShow: refreshing, refreshHide: !refreshing}"/>
          <font-awesome-icon id="checkIcon" @click.stop="refreshSongs" icon="check-circle" class="fa-2x refreshIcon checkedIcon" v-bind:class="{refreshShow: songsOk, refreshHide: !songsOk}"/>
          <font-awesome-icon id="failedIcon" @click.stop="refreshSongs" icon="exclamation-circle" class="fa-2x refreshIcon failedIcon" v-bind:class="{refreshShow: songsNotOk, refreshHide: !songsNotOk}"/>
          <b-tooltip target="syncIcon" placement="left" variant="info"> Refresh data. </b-tooltip>
        </div> -->



        <!-- <div class="debug">
        {{metaMaskUninstalled}}

        {{metaMaskAccount}}
        {{contractAddress}}
        {{loggedIn}}
      </div> -->


      <!-- {{ethereumAddress}} -->
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
      metaMaskAccount: "ddd",
      windowHeight: 0,
      toggable: false
    };
  },
  methods: {
    toggle: function () {
      if (this.toggable) {
        this.$refs.toggle.toggle()
      }
    },
    ToggledMenu: function () {
      this.$store.state.toggledMenu = !this.$store.state.toggledMenu
      console.log(this.$refs.toggle)
    },
    refreshSongs: function () {
      this.$store.state.songsHash = ''
      this.$store.dispatch("GetSongs")
    },
    ClosedTransactions: function () {
      this.$store.dispatch('DoNotRefreshTransactions')
    }
  },
  mounted() {
    this.$nextTick(() => {
      window.addEventListener('resize', () => {
        this.windowHeight = window.innerWidth
        if (this.windowHeight < 765) {
          this.toggable = true
        }
        else {
          this.toggable = false
        }
      });
    })
  },
  created: function () {
    this.$store.dispatch("GetSongs")

    var that = this;
    if (typeof web3 === "undefined") {
      this.metaMaskAccount = undefined;
    } else {
      web3.currentProvider.publicConfigStore.on("update", function (err, res) {
        that.metaMaskAccount = web3.eth.defaultAccount;
        if (that.metaMaskAccount !== that.$store.state.web3account) {
          that.$store.dispatch("GetSongs")
        }
        that.$store.state.web3account = that.metaMaskAccount
      });

      web3.version.getNetwork(function (err, res) {
        that.networkId = parseInt(res);
      });

      this.metaMaskAccount = web3.eth.defaultAccount;
    }
  },
  watch: {
    soundCloudLink: function (val) {
      this.loadEmbed();
    }

  },
  computed: {

    songsNumber: function () {
      return this.$store.state.songs.length
    },
    txNumber: function () {
      return this.$store.state.positions.length
    },
    web3account: function () {
      return this.$store.state.web3account
    },
    refreshing: function () {
      return this.$store.state.refreshing
    },
    songsFailed: function () {
      return this.$store.state.songsFailed
    },
    songsOk: function () {
      return (!this.refreshing && !this.songsFailed)
    },
    songsNotOk: function () {
      return (!this.refreshing && this.songsFailed)
    },

    updatedTransactions: function () {
      return this.$store.state.updatedTransactions;
    },
    transactions: function () {
      return this.$store.state.transactions;
    },
    ethereumAddress: function () {
      return this.$store.state.contractAddress;
    },
    loggedIn: function () {
      if (typeof this.metaMaskAccount === "undefined") {
        this.$store.state.metaMaskLoggedOut = true;
        return false;
      } else {
        this.$store.state.metaMaskLoggedOut = false;
        return true;
      }
    },
    contractAddress: function () {
      return this.$store.state.web3contract.address;
    },
    metaMaskUninstalled: function () {
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
