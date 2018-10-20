<template>

<div id="app">
  <div class="menuContainer">
    <div/>
    <b-container>
      <Menu/>
    </b-container>
  </div>
        <!-- <transition name="fade" mode="out-in"> -->
        <router-view class="contentContainer"></router-view>
        <!-- </transition> -->
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
  }

}

</script>
