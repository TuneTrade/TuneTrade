<style>

body {
/* background-color:#fafafa; */
/* background-image: url('./assets/band1.jpg'); */
background-repeat: no-repeat;
background-size: cover;
/* background-blend-mode: ; */
}

#app {
    font-family: 'Avenir', Helvetica, Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    /* text-align: center; */
    /* color: #2c3e50; */
    margin-top: 10px;
    /* background-color: #fafafa; */
    background-color:rgba(255,255,255,0.1);
}

</style>

<template>

<div id="app">
    <b-container fluid style="padding:0px;" class="test">
        <Menu/>
        <transition name="fade" mode="out-in">
        <b-container style="margin-top:120px">
        <router-view></router-view>
        </b-container>
        </transition>
        <Footer/>
    </b-container>
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
