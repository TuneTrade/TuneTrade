import Vue from 'vue';
import Router from 'vue-router';
// import Hello from '@/components/Hello'
// import Menu from '@/components/Menu'
import SongList from '../components/SongList';
import TokenExchange from '../components/TokenExchange';
import NewContract from '../components/NewContract';
import ICOContract from '../components/ICOContract';
import Transactions from '../components/Transactions';
import Tutorial from '../components/Tutorial';
import BuyCoins from '../components/BuyCoins';
// import SongDetails from '../components/SongDetails'
import About from '../components/About';

Vue.use(Router);

export default new Router({
  // mode: 'history',
  routes: [
    {
      path: '/',
      redirect: 'SongList'
    },
    {
      path: '/test',
      name: 'Test',
      component: BuyCoins
    },
    {
      path: '*',
      redirect: 'SongList'
    },
    {
      path: '/SongList',
      name: 'SongList',
      component: SongList
    },
    {
      path: '/about',
      name: 'About',
      component: About
    },
    {
      path: '/tutorial',
      name: 'Tutorial',
      component: Tutorial
    },
    {
      path: '/tokenexchange',
      props: true,
      name: 'TokenExchange',
      component: TokenExchange
    },
    {
      path: '/newcontract',
      name: 'NewContract',
      component: NewContract
    },
    {
      path: '/icocontracttest',
      name: 'ICOContract',
      component: ICOContract
    },
    {
      path: '/transactions/:pending',
      props: true,
      name: 'Transactions',
      component: Transactions
    }
    // {
    //   path: '/songdetails',
    //   props: true,
    //   name: 'SongDetails',
    //   component: SongDetails
    // }
  ]
});
