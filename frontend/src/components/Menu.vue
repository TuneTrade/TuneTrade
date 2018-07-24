<style lang="css">

a {
  color:#fafafa;
}

</style>

<template lang="html">

<div class="">
    <!-- <b-container> -->
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
    <!-- </b-container> -->
</div>

</template>

<script>

export default {
  name: 'Menu'

}

</script>
