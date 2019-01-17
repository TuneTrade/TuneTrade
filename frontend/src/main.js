// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.

import Vue from 'vue';
import BootstrapVue from 'bootstrap-vue';
import App from './App';

import { library } from '@fortawesome/fontawesome-svg-core';
import {
  faExclamationCircle,
  faCheckCircle,
  faCoffee,
  faAngleUp,
  faAngleDown,
  faSearch,
  faQuestion,
  faSpinner,
  faSync,
  faSyncAlt,
  faBan
} from '@fortawesome/free-solid-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';
library.add(faCoffee);
library.add(faAngleUp);
library.add(faSpinner);
library.add(faSync);
library.add(faExclamationCircle);
library.add(faSyncAlt);
library.add(faAngleDown);
library.add(faSearch);
library.add(faQuestion);
library.add(faCheckCircle);
library.add(faBan);
Vue.component('font-awesome-icon', FontAwesomeIcon);

import Menu from './components/Menu';
import TokenExchange from './components/TokenExchange';
import NewContract from './components/NewContract';
import ICOContract from './components/ICOContract';
import Transactions from './components/Transactions';
import Tutorial from './components/Tutorial';
import SongDetails from './components/SongDetails';
import PositionDetails from './components/PositionDetails';
import BuyCoins from './components/BuyCoins';
import NewPosition from './components/NewPosition';
import router from './router';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap-vue/dist/bootstrap-vue.css';
import './style.css';
import { store } from './storage/store';
import VueYoutube from 'vue-youtube';
Vue.use(VueYoutube);
Vue.use(BootstrapVue);
Vue.config.productionTip = false;

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  store: store,
  template: '<App/>',
  components: {
    App,
    Menu,
    TokenExchange,
    NewContract,
    ICOContract,
    Transactions,
    SongDetails,
    PositionDetails,
    NewPosition,
    BuyCoins,
    Tutorial
  },
  created: function() {
    store.dispatch('ConnectToContract');
    store.dispatch('StartCheckingTransactions');
  },
  updated: function() {
    console.log('This is update');
  },
  destroyed: function() {
    console.log('APP Destroyed');
  }
});
