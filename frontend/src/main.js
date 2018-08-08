// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import BootstrapVue from 'bootstrap-vue'
import App from './App'
import Menu from './components/Menu'
import TokenExchange from './components/TokenExchange'
import NewContract from './components/NewContract'
import ICOContract from './components/ICOContract'
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
    ICOContract
  }
})
