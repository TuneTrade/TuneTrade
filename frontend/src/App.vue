<template>
  <div id="app">
    <b-modal
      hide-header
      show
      visible
      size="lg"
      centered
      body-bg-variant="secondary"
      header-bg-variant="secondary"
      ok-only
      ok-title="OK"
      class="text-center m-0"
    >
      <span class>This is TuneTrade 2018 prototype version.</span>
    </b-modal>
    <Menu/>
    <transition name="fade" mode="out-in">
      <router-view class="contentContainer" v-bind:class="{blurredBody:toggledMenu}"></router-view>
    </transition>
    <Footer/>
  </div>
</template>

<script>

import Menu from './components/Menu'
import Footer from './components/Footer'
export default {
  name: 'app',
  components: {
    Menu, Footer
  },
  computed: {
    toggledMenu: function () {
      return this.$store.state.toggledMenu
    }
  }

}

</script>
