<style>

body {
background-color:#fafafa;
/* background-image: url('./assets/band1.jpg'); */
/* background-repeat: no-repeat; */
/* background-si  ze: cover; */
/* background-blend-mode: ; */
}

#app {
    font-family: 'Avenir', Helvetica, Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    box-sizing:content-box;
    width:100%;
    background-color:#1b1b1b;
    color:white;

    /* text-align: center; */
    /* color: #2c3e50; */
    /* margin-top: 10px; */
    /* background-color: #fafafa; */
    /* background-color:rgba(255,255,255,0.1); */
}

</style>

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
    <Footer />
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
