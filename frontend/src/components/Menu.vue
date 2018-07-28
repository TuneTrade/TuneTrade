<style lang="css">

a {
  color:#fafafa;
}

</style>

<template lang="html">

<div class="">
    <!-- <b-container> -->
    <b-alert alert-variant="danger" variant="danger" style="background-color:#d11;color:#f0f0f0" show v-if="metaMaskUninstalled"> MetaMask isn't installed. You need to install metamask in order to be able to use this application. <b-link style="color:#f6851b" target="_blank" href="https://metamask.io/"> Go here => MetaMask </b-link></b-alert>
    <b-alert style="background-color:#d11;color:#f0f0f0"  show v-if="!loggedIn && !metaMaskUninstalled">Please login to MetaMask </b-alert>
    <b-navbar toggleable="sm" type="dark" variant="info">
        <b-navbar-brand>
            <router-link :to="{ name: 'SongList', params: {} }">List</router-link>
        </b-navbar-brand>
        <b-navbar-brand>
            <router-link :to="{ name: 'NewContract', params: {} }">Create Contract</router-link>
        </b-navbar-brand>
        <b-navbar-brand>
            <router-link :to="{ name: 'TokenExchange', params: {} }">Token Exchange</router-link>
        </b-navbar-brand>
    </b-navbar>
    <div>{{networkId}} {{metaMaskAccount}}</div>
    <!-- </b-container> -->
</div>

</template>

<script>

export default {
  name: 'Menu',
  data () {
    return {
      networkId: 0,
      metaMaskAccount: 'ddd'
    }
  },
  created: function () {
    web3.currentProvider.network
    var that = this
    web3.currentProvider.publicConfigStore.on('update', function(err,res){
      console.log('web3 metmask updated')
      that.metaMaskAccount = web3.eth.defaultAccount
    });

    web3.version.getNetwork(function(err,res){
      that.networkId = parseInt(res);
    })

    this.metaMaskAccount = web3.eth.defaultAccount

  },
  computed:
  {
    loggedIn: function () {
      console.log(this.metaMaskAccount)
      if(typeof this.metaMaskAccount=== 'undefined') return false
      else return true
    },
    metaMaskUninstalled: function () {
      if (typeof web3 === 'undefined')
      {
        return true
      } else {
        console.log('web3:', web3.currentProvider.constructor.name)
        if (web3.currentProvider.constructor.name == 'MetamaskInpageProvider') return false
        else return true
      }
    },
      // return web3.version.network
  }

}

</script>
