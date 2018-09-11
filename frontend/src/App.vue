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

    /* text-align: center; */
    /* color: #2c3e50; */
    /* margin-top: 10px; */
    /* background-color: #fafafa; */
    /* background-color:rgba(255,255,255,0.1); */
}
.cien {
  /* box-shadow: 1px 1px 10px black; */
  /* padding:20px; */
  border-right-style: solid;
  border-right-width: 1px;
  border-color:#ddd;
  border-left-style: solid;
  border-left-width: 1px;
  /* margin-left: 5%; */
  /* margin-right:5%; */

}

</style>

<template>

<div id="app">
  <Menu/>
    <b-container class="cien">
        <!-- <transition name="fade" mode="out-in"> -->
        <router-view class="contentContainer"></router-view>
        <!-- </transition> -->
    </b-container>
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
