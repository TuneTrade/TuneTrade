<style>

body {
background-color:#fafafa;
}

#app {
    font-family: 'Avenir', Helvetica, Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    /* text-align: center; */
    color: #2c3e50;
    margin-top: 10px;
    background-color: #fafafa;
}

</style>

<template>

<div id="app">
    <b-container >
        <Menu/>
        <router-view></router-view>
        </Footer>
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
