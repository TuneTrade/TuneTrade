<template lang="html">
  <div class="" style="margin:0px 0px;min-height:600px">
 
    <b-modal id="modalInfo" @hide="resetModal" ok-only show centered>
      <!-- <pre>{{ modalInfo.content }}</pre> -->
      <div v-on:load="loaded()" v-html="musicPlayerLink"> </div>
      <!-- <iframe v-on:abort="onAbort()" v-on:error="onError()" v-on:load="loaded()" width="100%" height="450" scrolling="no" frameborder="no" allow="autoplay" v-bind:src="musicPlayerLink"></iframe> -->
    </b-modal>

      <b-container  fluid class="navbarBox h-100">
      <b-container class="h-100">
      <b-navbar toggleable="xl"  class="navbar-dark p-0 my-2 mx-0 ">
              <b-container class="w-100 h-100 text-center p-0 ">
                <b-row class=" w-100 p-0 m-0">
                  <b-col cols=12 sm=12 md=auto lg=4 class=" text-center text-md-left" >
                    <div style="display:inline" class="">
                      <div style="display:inline-flex" class="">
                        <b-form-input id ="searchInput" class="searchBox w-auto" type="text" placeholder="Search" v-model="tablefilter">
                        </b-form-input>
                        <div class="iconBorder">
                          <font-awesome-icon icon="search" class="searchIcon" /> 
                        </div>
                      </div>
                    </div> 
                  </b-col>
                  <b-col cols=12 sm=12 md=6 lg=8  class=" pl-3  text-sm-center text-center text-md-left" >

              <b-dropdown class="d-xl-none d-xs-block" toggle-class="testToggle" menu-class="testMenu"  :text="filterOptions[typeDrop].text">
                <b-dropdown-item v-bind:class="{selectedType: typeDrop==3,'bg-dark text-white': typeDrop != 3}" v-on:click="filterType(3)">All </b-dropdown-item>
                <b-dropdown-item size="sm" v-on:click="filterType(2)"  v-bind:class="{selectedType: typeDrop==2,'bg-dark text-white': typeDrop != 2}"
                  type="submit">Influencer</b-dropdown-item>
                <b-dropdown-item size="sm"  v-on:click="filterType(1)"  v-bind:class="{selectedType: typeDrop==1,'bg-dark text-white': typeDrop != 1}">Music</b-dropdown-item>
                <b-dropdown-item size="sm" v-on:click="filterType(0)"  v-bind:class="{selectedType: typeDrop==0,'bg-dark text-white': typeDrop != 0}">Misc. Project</b-dropdown-item>
                <b-dropdown-item size="sm" v-on:click="filterType(4)"  v-bind:class="{selectedType: typeDrop==4,'bg-dark text-white': typeDrop != 4}">Created Tokens</b-dropdown-item>
                <b-dropdown-item size="sm" v-on:click="filterType(5)"  v-bind:class="{selectedType: typeDrop==5,'bg-dark text-white': typeDrop != 5}">My Tokens</b-dropdown-item>
              </b-dropdown>
          <b-collapse is-nav id="searchFilters" class=" p-0 m-0" >
            <b-nav-form class="filterBox w-100 text-right p-0 m-0">
              <b-button size="sm" v-on:click="filterType(3)" class="mx-lg-1 mx-xl-1 typeButton" v-bind:class="{selectedType: typeDrop==3}"
                type="submit">ALL </b-button>
              <b-button  size="sm" v-on:click="filterType(2)" class="mx-lg-1 mx-xl-1 typeButton" v-bind:class="{selectedType: typeDrop==2}"
                type="submit">INFLUENCER</b-button>
              <b-button size="sm" v-on:click="filterType(1)" class="mx-lg-1 mx-xl-1  typeButton" type="submit" v-bind:class="{selectedType: typeDrop==1}">MUSIC</b-button>
              <b-button size="sm" v-on:click="filterType(0)" class="mx-lg-1 mx-xl-1  typeButton" type="submit" v-bind:class="{selectedType: typeDrop==0}">MISC. PROJECT</b-button>
              <b-button size="sm" v-on:click="filterType(4)" class="mx-lg-1 mx-xl-1  typeButton" type="submit" v-bind:class="{selectedType: typeDrop==4}">CREATED TOKENS</b-button>
              <b-button size="sm" v-on:click="filterType(5)" class="mx-lg-1 mx-xl-1  typeButton" type="submit" v-bind:class="{selectedType: typeDrop==5}">MY TOKENS</b-button>
            </b-nav-form>
          </b-collapse>
                  </b-col>
              </b-row>
              </b-container>


      </b-navbar>
      </b-container>
      </b-container>


    <b-container fluid class="navbarBox ">
    </b-container>
    <b-container class="">
      <!-- <div v-if="!songsReady">  -->
      <div class="loadingSpin" v-if="!songsReady"> 
        <center> 
          <font-awesome-icon  icon="spinner" class="fa-2x fa-pulse refreshIcon" />
          <br> Loading... </center>
      </div>
      <div v-if="noSongs && songsReady" class="text-center text-danger" > 
          <font-awesome-icon  icon="ban" class="fa-5x  noSongIcon" /><br>
          <br>THERE ARE NO SONGS
         </div>
      <b-table  v-if="songsReady && !noSongs"  tbody-class="tableBodyClass" thead-class="headerClass" thead-tr-class="headerClass"  sort-direction="desc" sort-by="Created" :current-page="currentPage"
        :per-page="perPage" sort-desc="true" :items="songs" :fields="fields" :filter="filterFunction" class="songsTable">
        <template slot="Buy" slot-scope="row">
          <b-button size="sm" variant="info" @click.stop="info(row.item, row.index, $event.target)">Buy</b-button>
        </template>
        <template slot="show_details" slot-scope="row">
  <b-button size="sm" @click.stop="row.toggleDetails" variant="info" class="detailsButton">
    {{
    row.detailsShowing ? 'Hide' : 'Show'}} Details
  </b-button>
</template>
        <template slot="sm_details" slot-scope="row">
  <div @click.stop="row.toggleDetails">
    <font-awesome-icon
      @click.stop="row.toggleDetails"
      v-if="!row.detailsShowing"
      icon="angle-up"
      class="arrow fa-2x"
    />
    <font-awesome-icon
      @click.stop="row.toggleDetails"
      v-if="row.detailsShowing"
      icon="angle-down"
      class="arrow fa-2x"
    />
  </div>
</template>
        <template slot="TotalSupply" slot-scope="row">{{BigValue (row.item.TotalSupply,row.item.Decimals)}}</template>
        <template slot="Price" slot-scope="row">
  <span class="text-truncate px-md-1">{{tokensForEth(row.item.Price,row.item.Decimals)}}</span>
</template>
        <template slot="Volume" slot-scope="row">{{BigValue(row.item.Volume,row.item.Decimals)}} {{row.item.Symbol}}</template>
        <template slot="Type" slot-scope="row">{{SongOrBand (row.item.Type)}}</template>
        <template slot="smscreen" slot-scope="row" >
  <div class="text-left m-1 text-truncate d-block p-0 m-0" @click.stop="row.toggleDetails">
    <b-container class="m-0">
      <b-row class="p-0 m-0">
        <b-col cols="10" class="mx-0 p-0">
          Name: {{row.item.Name}}
          <br>
          Author: {{row.item.Author}}
          <br>
          Type: {{SongOrBand (row.item.Type)}}
          <br>
          Category: {{row.item.Genre}}
        </b-col>
      </b-row>
    </b-container>
  </div>
</template>
        <template slot="Picture" slot-scope="row">
  <b-img
    style
    class="responsiveTableImage"
    @click.stop="row.toggleDetails"
    v-bind:src="picLink(row.item.Id)"
    alt
  />
</template>
        <template slot="Name" slot-scope="row">&quot;{{row.item.Name}}&quot;</template>
        <template slot="Created" slot-scope="row">{{ getLocalTime(row.item.Created)}}</template>
        <template slot="row-details" slot-scope="row">
  <SongDetails
    v-if="!showBuyCoins(row.item.address) && !showTransactions(row.item.address) && !showNewPosition(row.item.address)"
    v-bind:song="row.item.address"
  />
  <BuyCoins v-if="showBuyCoins(row.item.address)" v-bind:song="row.item.address" class/>
  <NewPosition v-if="showNewPosition(row.item.address)" v-bind:song="row.item.address"/>
  <OneTransaction
    v-if="showTransactions(row.item.address)"
    v-bind:song="row.item.address"
    v-bind:id="showTransactions(row.item.address)"
    class
  />
</template>
      </b-table>
      <b-pagination v-if="songsReady && !noSongs" size="sm" :per-page="perPage" :total-rows="totalRows" v-model="currentPage"
        class="m-0 p-0">
      </b-pagination>
    </b-container>
  </div>
</template>
<script>
import axios from "axios";

// import vueAxios from 'vue-axios'

// Vue.use(axios)

var BigNumber = require("bignumber.js");

// var SC = require("soundcloud");

require("./saleContractdef.js");
import SongDetails from './SongDetails'
import BuyCoins from './BuyCoins'
import OneTransaction from './OneTransaction'
import NewPosition from './NewPosition'



// SC.initialize("rZY6FYrMpGVhVDfaKEHdCaY8ALekxd8P");

// SC.initialize('174155989')

var URI = require("uri-js");

var Web3 = require("web3");

export default {
  components: {
    SongDetails,
    BuyCoins,
    OneTransaction,
    NewPosition
  },
  data() {
    return {
      sortBy: "Created",

      modalInfo: {
        title: "",

        content: ""
      },
      filterOptions: [
        { value: 0, text: 'MISC. PROJECT' },
        { value: 1, text: 'MUSIC' },
        { value: 2, text: 'INFLUENCER' },
        { value: 3, text: 'ALL' },
        { value: 4, text: 'CREATED TOKENS' },
        { value: 5, text: 'MY TOKENS' }
      ],
      sortDesc: false,

      tablefilter: "",

      currentPage: 1,

      picIteration: 0,

      musicPlayerLink: "",

      perPage: 20,

      currentIndex: -1,

      loading: -1,

      changing: -1,

      currentItem: {},

      tokensToBuy: "0",

      showFilters: true,

      typeDrop: 3,

      fields: [

        {
          key: "Picture",
          sortable: false,
          label: "",
          thStyle: "width:100px;",
          tdStyle: "width:52px;",
          tdClass: ""
        },
        {
          key: "smscreen",
          sortable: false,
          thClass: "d-table-cell d-sm-none",
          tdClass: "d-table-cell d-sm-none",
          label: ''
        },
        {
          key: "Type",
          sortable: false,
          label: "Type",
          tdClass: "d-none d-sm-table-cell mx-5 pr-3",
          thClass: "d-none d-sm-table-cell"
          // thClass: "d-xs-table-cell d-none "
        },
        {
          key: "Name",
          sortable: true,
          label: 'Token Name',
          tdClass: 'm-0 p-0 ml-0',
          thStyle: 'width:auto;',
          tdClass: "d-sm-table-cell d-none pr-3",
          thClass: "d-sm-table-cell d-none "
        },
        {
          key: "Created",
          label: 'Created',
          sortable: true,
          sortDirection: "asc",
          tdClass: "d-xl-table-cell d-none pr-2",
          thClass: "d-xl-table-cell d-none "

        },

        {
          key: "Author",
          sortable: true,
          tdClass: "d-sm-table-cell d-none",
          thClass: "d-sm-table-cell d-none "
        },

        // { key: 'Phase', sortable: true },

        {
          key: "Price",

          sortable: true,

          label: "Price [TOKEN/ETH]",
          tdClass: "d-md-table-cell d-none",
          thClass: "d-md-table-cell d-none "

        },

        // { key: 'Volume', sortable: true, label: 'Volume [TOKEN]' },

        {
          key: "Volume",
          sortable: true,
          label: "Circulating supply",
          tdClass: "d-xl-table-cell d-none",
          thClass: "d-xl-table-cell d-none "


        },

        // { key: 'TotalSupply', sortable: true },

        // { key: 'Created', sortable: true },

        {
          key: "Genre",

          sortable: true,
          tdClass: "d-lg-table-cell d-none m-0 p-0",
          thClass: "d-lg-table-cell d-none m-0  ",
          label: 'Category'
        },

        // { key: 'Website', sortable: true },

        // { key: 'Buy', sortable: true },

        {
          key: "show_details",
          sortable: false,
          label: "",
          tdClass: "d-md-table-cell d-none m-4 noPadding ",
          thClass: "d-md-table-cell d-none m-3 noPadding"
        },
        {
          key: "sm_details",
          sortable: false,
          label: "",
          tdClass: "d-table-cell d-md-none m-4 noPadding ",
          thClass: "d-table-cell d-md-none m-3 noPadding"
        }
      ],

      items: []
    };
  },

  created: function () {
    // this.$store.dispatch('ConnectToContract')
    this.$store.dispatch("GetSongs");

  },

  methods: {
    showBuyCoins: function (item) {
      // console.log('Show Buy Coins', item, this.$store.getters.showBuyCoins(item))
      return this.$store.getters.showBuyCoins(item)
    },
    showTransactions: function (item) {
      console.log('Show Transactions', item, this.$store.getters.showTransactions(item))
      return this.$store.getters.showTransactions(item)
    },
    showNewPosition: function (item) {
      return this.$store.getters.showNewPosition(item)
    },
    showHideFilters: function () {
      this.showFilters = !this.showFilters;
    },

    WebsiteLink: function (address) {
      let uriParsed = URI.parse(address);

      if (uriParsed.path.length > 0) {
        // if (uriParsed.scheme === undefined) console.log(uriParsed);

        return "http://" + address;
      } else {
        return null;
      }
    },

    tokenOnSale: function (state) {
      if (state === undefined) return false;

      if (state === "Presale") return true;

      if (state === "Main Sale") return true;

      return false;
    },

    Phase: function (state) {
      if (state === undefined) return "Not on sale";

      if (state.length > 0) return state;

      return "Not on sale";
    },

    ValidateTokens: function () {
      if (this.tokensToBuy === 0) return;

      if (isNaN(this.tokensToBuy)) return;

      if (this.tokensToBuy.length === 0) return;

      let step = this.tokensStep(
        this.currentItem.Price,
        this.currentItem.Decimals
      );

      step = BigNumber(step);

      // console.log("STEP: ", step.toString());

      let numberofStep = BigNumber(this.tokensToBuy).div(step);

      let tmpTokens = numberofStep.times(step);

      if (tmpTokens.gt(this.availableTokens))
        tmpTokens = BigNumber(this.availableTokens);

      if (tmpTokens.lt(step)) this.tokensToBuy = BigNumber(step);

      this.tokensToBuy = tmpTokens.toString();
    },

    BuyTokens() {
      if (web3 === undefined) return
      var saleContractDef = web3.eth.contract(saleContractDefinition);
      var saleContract = saleContractDef.at(this.currentItem.saleAddress);
      var weiAmount = this.tokensPriceWeiBigNumber();
      var that = this;
      // console.log("Wei Amount: ", weiAmount.toString());
      // console.log(this.currentItem.saleAddress);
      this.$refs.BuyTokensModal.hide();
      this.$store.dispatch("AddTransaction", {
        title:
          "Buying " +
          this.tokensToBuy +
          " tokens " +
          this.currentItem.Symbol +
          " on blockchain"
      });

      var txind = this.$store.getters.getTransactionIndex;

      saleContract._eth.sendTransaction(
        {
          value: weiAmount.toString(),

          to: this.currentItem.saleAddress
        },
        function (err, res) {
          if (res !== undefined) {
            that.$store.dispatch("UpdateTransactionMining", {
              index: txind,

              number: res
            });
          } else {
            that.$store.dispatch("UpdateTransactionCancelled", {
              index: txind,

              msg: err.message
            });
          }
        }
      );
    },

    ShowBuyModal: function (item) {
      this.currentItem = item;

      this.$refs.BuyTokensModal.show();
    },

    tokensForEth: function (rate, decimals) {
      if (rate === undefined) return null;

      if (decimals === undefined) decimals = 0;

      var weiInEth = Web3.utils.toWei("1", "ether");

      decimals = parseInt(decimals);

      var ret = BigNumber(rate)
        .times(weiInEth)
        .shiftedBy(-decimals)
        .toFormat();

      return ret;
    },

    tokensForWei: function (rate, decimals) {
      if (rate === undefined) return null;

      if (decimals === undefined) decimals = 0;

      let dec = parseInt(decimals);

      let r = BigNumber(rate);

      return r.shiftedBy(-dec).toFormat();
    },

    tokensStep: function (rate, decimals) {
      if (rate === undefined) return null;

      if (decimals === undefined) decimals = 0;

      let r = BigNumber(rate);

      r = r.shiftedBy(-decimals);

      return r.toFormat();
    },

    tokensPriceWei: function (rateInWei, tokensAmount) {
      let decimals = parseInt(this.currentItem.Decimals);

      if (isNaN(decimals)) return 0;

      let amount = BigNumber(tokensAmount).shiftedBy(decimals);

      return amount.div(rateInWei).toFormat();
    },

    tokensPriceWeiBigNumber: function (rateInWei, tokensAmount) {
      let amount = BigNumber(this.tokensToBuy);

      let rate = BigNumber(this.currentItem.Price);

      let decimals = parseInt(this.currentItem.Decimals);

      if (isNaN(decimals)) return 0;

      return amount.shiftedBy(decimals).div(rate);
    },

    tokensPriceEth: function () {
      let amount = BigNumber(this.tokensToBuy);

      let rate = BigNumber(this.currentItem.Price);

      let decimals = parseInt(this.currentItem.Decimals);

      let weiInEth = BigNumber(Web3.utils.toWei("1", "ether"));

      if (isNaN(decimals)) return 0;

      return amount
        .shiftedBy(decimals)
        .div(rate)
        .div(weiInEth)
        .toFormat();
    },

    filterType: function (type) {
      this.typeDrop = type;
    },

    isMyToken: function (adr) {

      if (web3 === undefined) return false
      return (web3.toChecksumAddress(adr) === web3.toChecksumAddress(web3.eth.defaultAccount))
    },
    filterFunction: function (item) {
      var itemStr;

      if (this.typeDrop < 3 && item.Type !== this.typeDrop) return false;
      if (this.typeDrop == 4) {
        if (!this.isMyToken(item.Owner)) return false
      }

      if (this.typeDrop == 5) {
        if (item.ownedTokens === 0) return false
      }

      for (var val in item) {

        if (item[val] === undefined) continue;

        if (item[val] !== undefined && typeof item[val] === "string") {
          itemStr += item[val];
        } else {
          itemStr += item[val].toString();
        }
      }

      var re = new RegExp(this.tablefilter.toLowerCase());
      return re.test(itemStr.toLowerCase());
    },

    getRelated: function (link) {
      axios
        .get(
          "http://api.soundcloud.com/resolve?url=" +
          link +
          "&client_id=rZY6FYrMpGVhVDfaKEHdCaY8ALekxd8P"
        )
        .then(function (res) { });
    },

    etherscanToken: function (address) {
      if (address.length === 0) return null;

      return "https://ropsten.etherscan.io/token/" + address;
    },

    etherscanAddress: function (address) {
      return "https://ropsten.etherscan.io/address/" + address;
    },

    Price: function (priceInWei) {
      if (priceInWei === undefined) return 0;

      let value = BigNumber(priceInWei);

      if (value === null) return 0;

      if (value.isNaN()) return value.toString();

      //Convert price in Wei to ETH. 1 ETH == 10^18 Wei. So we shift it by 18 places.

      return value.shiftedBy(-18).toFormat();
    },

    info(item, index, button) {
      // this.modalInfo.title = `Row index: ${index}`

      // this.modalInfo.content = JSON.stringify(item, null, 2)

      this.$root.$emit("bv::show::modal", "modalInfo", button);
    },

    resetModal() { },

    getLocalTime: function (val) {
      var ts = new Date(parseInt(val) * 1000);

      return ts.toLocaleString();
    },

    SongOrBand: function (val) {
      switch (parseInt(val)) {
        case 0:
          return "Misc. Project";

        case 1:
          return "Music";

        case 2:
          return "Influencer";

        case 3:
          return "All";

        default:
          return "Error";
      }
    },

    // uint8 phase; // 1 - pre-sale, 2 - ico1, 3 - ico2, 4 - ico 3; 5 - post ico, 6 - finished, 0 - not running.

    PhaseToString: function (val) {
      if (isNaN(val)) return val;

      var number = parseInt(val);

      switch (number) {
        case 0:
          return "not running";

        case 1:
          return "Pre sale";

        case 2:
          return "ICO 1";

        case 3:
          return "ICO 2";

        case 4:
          return "ICO 3";

        case 5:
          return "Post ICO";

        case 6:
          return "Finished";
      }
    },

    onError: function () {
      alert("error");
    },

    onAbort: function () {
      alert("aborted");
    },

    loaded: function () {
      if (this.loading >= 0) {
        this.loading = -1;
      }
    },

    isLoading: function (index) {
      if (this.changing === index || this.loading === index) {
        return true;
      } else {
        return false;
      }
    },

    playMusic: function (index, link) {
      var that = this;

      if (index === this.currentIndex) {
        this.currentIndex = -1;

        this.musicPlayerLink = "";

        return;
      }

      this.currentIndex = index;

      this.changing = index;

      this.musicPlayerLink = "";

      setTimeout(function () {
        that.changing = -1;

        that.loading = index;

        SC.oEmbed(link, {
          auto_play: true
        })
          .then(function (em) {
            that.musicPlayerLink = em.html;

            that.loading = -1;
          })
          .catch(function (err) { });
      }, 100);
    },

    localNumber: function (val) {
      if (isNaN(val)) return val;

      var entry = parseFloat(val);

      var num = entry.toLocaleString();

      return num;
    },

    BigValue: function (val, dec) {
      if (isNaN(val)) return val;

      var num = BigNumber(val);

      let decimals = parseInt(dec);

      return num.shiftedBy(-decimals).toFormat();
    },

    picLink: function (id) {
      // console.log("Pic Link:", id);

      if (id === undefined) {
        return null;
      }

      return this.$store.state.API + "/getPicture?id=" + id;

      // return 'https://source.unsplash.com/random/480x480'
    },

    isPlaying: function (rowNumber) {
      if (this.currentIndex === rowNumber) return true;
      else return false;
    }
  },

  computed: {

    refreshing: function () {
      return this.$store.state.refreshing
    },
    tokensAndBonus: function () {
      let tokensToBuy = BigNumber(this.tokensToBuy);

      let bonus = this.currentItem.Bonus;

      return tokensToBuy
        .times(100 + bonus)
        .div(100)
        .toString();
    },

    availableTokens: function () {
      let free = BigNumber(this.currentItem.FreeTokens);

      let decimals = parseInt(this.currentItem.Decimals);

      if (isNaN(decimals)) return 0;

      return free.shiftedBy(-decimals).toFormat();
    },

    cantBuyTokens: function () {
      if (isNaN(this.tokensToBuy)) return true;

      let freeTokens = BigNumber(this.currentItem.FreeTokens);

      let tokensToBuy = BigNumber(this.tokensToBuy);

      let decimals = BigNumber(this.currentItem.Decimals);

      if (decimals.isNaN()) return true;

      // console.log("Decimals: ", decimals.sd());

      let maxValue = freeTokens.shiftedBy(-decimals.toNumber());

      // console.log("MaX:", maxValue.toFormat());

      if (freeTokens.lt(tokensToBuy)) return true;

      let step = this.tokensStep(
        this.currentItem.Price,
        this.currentItem.Decimals
      );

      let numberofStep = tokensToBuy.div(step).dp(0, 1);

      if (numberofStep === null) return true;

      // console.log("numberofStep: ", numberofStep);

      step = BigNumber(step);

      let correctValue = numberofStep.times(step);

      if (!correctValue.eq(tokensToBuy)) return true;

      if (correctValue.lt(step)) return true;

      if (correctValue.gt(maxValue)) return true;
    },

    cantBuyTokensMsg: function () {
      if (isNaN(this.tokensToBuy)) return "This is not a number";
      let freeTokens = BigNumber(this.currentItem.FreeTokens);
      let tokensToBuy = BigNumber(this.tokensToBuy);
      let decimals = BigNumber(this.currentItem.Decimals);
      let tokensAndBonus = BigNumber(this.tokensAndBonus);

      if (decimals.isNaN()) return null;
      // console.log("Decimals: ", decimals.sd());

      let maxValue = freeTokens.shiftedBy(-decimals.toNumber());

      // console.log("MaX:", maxValue.toFormat());

      let step = this.tokensStep(
        this.currentItem.Price,
        this.currentItem.Decimals
      );

      let numberofStep = tokensToBuy.div(step).dp(0, 1);

      if (numberofStep === null) return true;

      // console.log("numberofStep: ", numberofStep);

      step = BigNumber(step);

      let correctValue = numberofStep.times(step);
      if (correctValue.lt(step))
        return "You have to buy minimum " + step.toFormat() + " tokens";
      if (!correctValue.eq(tokensToBuy))
        return "You have to buy mutliplication of minimum token amount.";
      if (tokensAndBonus.gt(maxValue)) return "Not enough available tokens.";
    },

    noSongs: function () {
      return this.songs.length === 0;
    },

    typeDropText: function () {
      return "Type (" + this.SongOrBand(this.typeDrop) + ")";
    },

    songsReady: function () {
      return this.$store.state.songsReady;
    },

    songs: function () {
      return this.$store.state.songs;
    },

    totalRows: function () {
      return this.songs.length;
    },

    songsCounter: function () {
      if (this.$store.state.songs !== undefined) {
        return this.$store.state.songs.length;
      } else {
        return 0;
      }
    }
  }
};
</script>
<style lang="css">
</style>