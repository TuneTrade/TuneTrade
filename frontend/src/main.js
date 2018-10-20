// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.

import Vue from 'vue'
import BootstrapVue from 'bootstrap-vue'
import App from './App'

import { library } from '@fortawesome/fontawesome-svg-core'
import { faCoffee, faAngleUp, faAngleDown, faSearch, faQuestion } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
library.add(faCoffee)
library.add(faAngleUp)
library.add(faAngleDown)
library.add(faSearch)
library.add(faQuestion)
Vue.component('font-awesome-icon', FontAwesomeIcon)

import Menu from './components/Menu'
import TokenExchange from './components/TokenExchange'
import NewContract from './components/NewContract'
import ICOContract from './components/ICOContract'
import Transactions from './components/Transactions'
import SongDetails from './components/SongDetails'
import router from './router'
import 'bootstrap/dist/css/bootstrap.min.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'
import './style.css'
import {store} from './storage/store'
Vue.use(BootstrapVue)
Vue.config.productionTip = false

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  store: store,
  template: '<App/>',
  components: { App,
    Menu,
    TokenExchange,
    NewContract,
    ICOContract,
    Transactions,
    SongDetails
  },
  created: function () {
    store.dispatch('ConnectToContract')
    store.dispatch('StartCheckingTransactions')
    console.log('APP CREATED')
  },
  updated: function () {
    console.log('This is update')
  },
  destroyed: function () {
    console.log('APP Destroyed')
  }

})
