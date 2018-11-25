<template lang="html">
  <div class="" style="margin:0px 0px;min-height:600px">
    <b-modal v-if="currentItem != null" @ok.prevent="BuyTokens()" hide-header ref="BuyTokensModal" size="lg" centered
      ok-title="Buy" :ok-disabled="cantBuyTokens">
      <center>
        <img style="height:50px" src="../assets/metamask.png"></img><br><br>
      </center>
      <div style="font-family:Courier;margin:15px 0px;background-color:#ddd;border-radius:4px;padding:10px 20px;">
        <div style="display:grid;grid-template-columns:auto auto 1fr;grid-column-gap:10px;margin:0px 0px 2rem 0px;">
          <div><b>Name:</b></div>
          <div> {{currentItem.Name}}</div>
          <div />
          <div><b>Rate [{{currentItem.Symbol}}/ETH]: </b></div>
          <div> {{tokensForEth(currentItem.Price, currentItem.Decimals)}}</div>
          <div />
          <div><b>Rate [{{currentItem.Symbol}}/WEI]: </b></div>
          <div> {{tokensForWei(currentItem.Price, currentItem.Decimals)}}</div>
          <div />
          <div><b>Current bonus: </b></div>
          <div> +{{currentItem.Bonus}}%</div>
          <div />
          <div><b>Sale Contract Address:</b></div>
          <div> {{currentItem.saleAddress}}</div>
          <div />
          <div><b>Token Contract Address:</b></div>
          <div> {{currentItem.address}}</div>
          <div />
          <div><b>Available tokens [{{currentItem.Symbol}}]:</b></div>
          <div> {{availableTokens}}</div>
          <div />
          <div><b>Decimals: </b></div>
          <div> {{localNumber(currentItem.Decimals)}}</div>
          <div />
          <div><b>Minimum amount to buy:</b></div>
          <div> {{tokensStep(currentItem.Price,currentItem.Decimals)}}</div>
          <div />
        </div>
        <b-form style="text-align:center">
          <center>
            <b-form-input style="width:200px; height:2rem" id="tokensToBuyInput" type="text" v-model="tokensToBuy"
              required size="sm" placeholder="How many tokens ?">
            </b-form-input>
          </center>
          <b-form-group style="padding:10px 0px 0px 0px;margin:0px;" id="tokensToBuyGroup" label="How many tokens ?"
            label-for="tokenstoBuyInput">
          </b-form-group>
          <div style="height:3rem;;margin:0px;padding:0px">
            <center> <span style="color:red;font-weight:800">{{cantBuyTokensMsg}}</span> </center>
          </div>
        </b-form>
        <div style="display:grid;grid-template-columns:auto 1fr;text-align:right;grid-column-gap:10px;">
          <div><b>Including bonus: [TOKEN]: </b></div>
          <div style="text-align:left"> {{tokensAndBonus}} </div>
          <div><b>You will pay [ETH]: </b></div>
          <div style="text-align:left"> {{tokensPriceEth()}} </div>
          <div><b>[WEI]: </b></div>
          <div style="text-align:left;"> {{tokensPriceWei(currentItem.Price, tokensToBuy)}} </div>
          <div />
        </div>
      </div>
    </b-modal>
    <b-modal id="modalInfo" @hide="resetModal" ok-only show centered>
      <!-- <pre>{{ modalInfo.content }}</pre> -->
      <div v-on:load="loaded()" v-html="musicPlayerLink"> </div>
      <!-- <iframe v-on:abort="onAbort()" v-on:error="onError()" v-on:load="loaded()" width="100%" height="450" scrolling="no" frameborder="no" allow="autoplay" v-bind:src="musicPlayerLink"></iframe> -->
    </b-modal>
    <b-container style="height:0px;">
      <div class="filterText">
        <a class="filterText" v-bind:class="{filterTextUp: !showFilters || !songsReady, blockedFilter: !songsReady}"
          href="#" v-on:click="showHideFilters()">FILTERS
          <font-awesome-icon v-if="showFilters" icon="angle-up" class="arrow fa-2x" />
          <font-awesome-icon v-if="!showFilters" icon="angle-down" class="arrow fa-2x" />
        </a>
      </div>
    </b-container>
    <b-container fluid class="navbarBox" v-bind:class="{navbarBox: showFilters && songsReady
        , hiddenNavbarBox: !showFilters  || !songsReady}">
      <b-container class="">
        <div class="filterContainer">
          <!-- <div v-if="!showFilters"/> -->
          <b-navbar toggleable="md" style="padding:0px;">
            <b-nav-form class="filterBox">
              <div style="display:grid;grid-template-columns:1fr auto;padding:0px;">
                <input type="text" class="searchBox" placeholder="Search" v-model="tablefilter">
                <font-awesome-icon icon="search" class=" searchIcon" />
              </div>
              <!-- <b-form-input size="sm"  class="mr-sm-2" type="text" placeholder="Search"/> -->
              <b-button size="sm" v-on:click="filterType(3)" class="my-2 my-sm-0 typeButton" v-bind:class="{selectedType: typeDrop==3}"
                type="submit">ALL </b-button>
              <b-button size="sm" v-on:click="filterType(2)" class="my-2 my-sm-0 typeButton" v-bind:class="{selectedType: typeDrop==2}"
                type="submit">INFLUENCER</b-button>
              <b-button size="sm" v-on:click="filterType(1)" class="my-2 my-sm-0 typeButton" type="submit" v-bind:class="{selectedType: typeDrop==1}">MUSIC</b-button>
              <b-button size="sm" v-on:click="filterType(0)" class="my-2 my-sm-0 typeButton" type="submit" v-bind:class="{selectedType: typeDrop==0}">PROJECT</b-button>
              <b-button size="sm" v-on:click="filterType(4)" class="my-2 my-sm-0 typeButton" type="submit" v-bind:class="{selectedType: typeDrop==4}">CREATED TOKENS</b-button>
              <b-button size="sm" v-on:click="filterType(5)" class="my-2 my-sm-0 typeButton" type="submit" v-bind:class="{selectedType: typeDrop==5}">OWNED TOKENS</b-button>

            </b-nav-form>
          </b-navbar>
          <div />
        </div>
      </b-container>
    </b-container>
    <b-container fluid class="navbarBox">
    </b-container>
    <b-container>
      <div v-if="!songsReady"> 
        <center> <img src="static/loading.gif"></img> <br> Loading... </center>
      </div>
      <div v-if="noSongs && songsReady" class="noSongs"> SONGS LIST IS EMPTY </div>
      <b-table v-if="songsReady && !noSongs" thead-class="headerClass" thead-tr-class="headerClass" tbody-tr-class="test"
        tbody-class="test" tbody-td-class="test" sort-direction="desc" sort-by="Created" :current-page="currentPage"
        :per-page="perPage" sort-desc="true" :items="songs" :fields="fields" :filter="filterFunction" class="songsTable">
        <template slot="Buy" slot-scope="row">
          <b-button size="sm" variant="info" @click.stop="info(row.item, row.index, $event.target)">Buy</b-button>
        </template>
        <template slot="show_details" slot-scope="row">
  <b-button size="sm" @click.stop="row.toggleDetails" variant="info" class="detailsButton">
    {{
    row.detailsShowing ? 'Hide' : 'Show'}} Details
  </b-button>

  <!-- {{tokensForEth(row.item.Price,row.item.Decimals)}} -->
</template>
        <template slot="TotalSupply" slot-scope="row">{{BigValue (row.item.TotalSupply,row.item.Decimals)}}</template>
        <template slot="Volume" slot-scope="row">{{BigValue(row.item.Volume,row.item.Decimals)}}</template>
        <template slot="Price" slot-scope="row">{{tokensForEth(row.item.Price,row.item.Decimals)}}</template>
        <template slot="Contribution" slot-scope="row">{{Price (row.item.Contribution)}}</template>
        <template slot="Type" slot-scope="row">{{SongOrBand (row.item.Type)}}</template>
        <template slot="Picture" slot-scope="row">
  <div style="display:grid;grid-template-columns:1fr ;">
    <!-- <a v-if="!isLoading(row.item.OrderNum) && isPlaying(row.item.OrderNum)" v-on:click="playMusic(row.item.OrderNum,row.item.soundcloud)">
  
        <img  src="../assets/pauseplayer.png" alt="" class="player" style="width:30px;margin:5px"></a>
  
          <a v-if="isLoading(row.item.OrderNum)" v-on:click="playMusic(row.item.OrderNum,row.item.soundcloud)">
  
        <img  src="../assets/loadingplayer.png" alt="" class="player" style="width:30px;margin:5px"></a>
  
  
  
        <a  v-bind:class="{unPlayable: !row.item.playable}" v-if="!isLoading(row.item.OrderNum) && !isPlaying(row.item.OrderNum)" v-on:click="playMusic(row.item.OrderNum,row.item.soundcloud)">
  
    <img  src="../assets/player.png" alt="" class="player" style="width:30px;margin:5px"></a>-->
    <!-- <iframe allowtransparency="true" scrolling="no" frameborder="no" src="https://w.soundcloud.com/icon/?url=http%3A%2F%2Fsoundcloud.com%2Fflickphlack%2Fdrake-in-my-feelings-kiki-do-you-love-me-loop-1&color=orange_white&size=32" style="width: 32px; height: 32px;"></iframe>
  
    <iframe width="50px" height="50px" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/34019569&amp;"></iframe>-->

    <b-img style="padding:0px;" v-bind:src="picLink(row.item.Id)" alt="" height="52" width="52"/>
  </div>
  <!-- {{SongOrBand (row.item.Type)}} -->
</template>
        <template slot="Name" slot-scope="row">&quot;{{row.item.Name}}&quot;</template>
        <template slot="Created" slot-scope="row">{{ getLocalTime(row.item.Created)}}</template>
        <template slot="row-details" slot-scope="row" style="padding:0px;">
          <SongDetails v-bind:song='row.item.address'/>
        </template>
      </b-table>
      <b-pagination v-if="songsReady && !noSongs" size="sm" :per-page="perPage" :total-rows="totalRows" v-model="currentPage"
        class="robert">
      </b-pagination>
      <!-- <div style="width:100%;height:200px;border-style:solid;">
    TEST
    <b-row style="border-style:solid">
      <b-col  style="border-style:solid" sm=6>
        Row 1
        <b-row>
          <b-col  style="border-style:solid" sm=1>
            Col in Col
          </b-col>
        </b-row>
      </b-col>
      <b-col  style="border-style:solid" sm=6>
        Row 1
      </b-col>

    </b-row>
  </div> -->
    </b-container>
  </div>
</template>
<script>
import axios from "axios";

// import vueAxios from 'vue-axios'

// Vue.use(axios)

var BigNumber = require("bignumber.js");

var SC = require("soundcloud");

require("./saleContractdef.js");
import SongDetails from './SongDetails'


SC.initialize("rZY6FYrMpGVhVDfaKEHdCaY8ALekxd8P");

// SC.initialize('174155989')

var URI = require("uri-js");

var Web3 = require("web3");

export default {
  components: { 
    SongDetails
  },
  data() {
    return {
      sortBy: "Created",

      modalInfo: {
        title: "",

        content: ""
      },

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

          label: ""
        },

        {
          key: "Type",

          sortable: false,

          label: "Type"
        },
        {
          key: "Name",
          sortable: true
        },
        {
          key: "Created",
          sortable: true,
          sortDirection: "asc"
        },

        {
          key: "Author",

          sortable: true
        },

        // { key: 'Phase', sortable: true },

        {
          key: "Price",

          sortable: true,

          label: "Rate [TOKEN/ETH]"
        },

        // { key: 'Volume', sortable: true, label: 'Volume [TOKEN]' },

        {
          key: "Contribution",

          sortable: true,

          label: "Contribution [ETH]"
        },

        // { key: 'TotalSupply', sortable: true },

        // { key: 'Created', sortable: true },

        {
          key: "Genre",

          sortable: true
        },

        // { key: 'Website', sortable: true },

        // { key: 'Buy', sortable: true },

        {
          key: "show_details",

          sortable: false,

          label: "",

          tdClass: "noPadding"
        }
      ],

      items: []
    };
  },

  created: function () {
    // this.$store.dispatch('ConnectToContract')
    this.$store.dispatch("GetSongs");
    console.table(this.$store.state.songs);

  },

  methods: {
    showHideFilters: function () {
      this.showFilters = !this.showFilters;
    },

    WebsiteLink: function (address) {
      let uriParsed = URI.parse(address);

      if (uriParsed.path.length > 0) {
        if (uriParsed.scheme === undefined) console.log(uriParsed);

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

      console.log("STEP: ", step.toString());

      let numberofStep = BigNumber(this.tokensToBuy).div(step);

      let tmpTokens = numberofStep.times(step);

      if (tmpTokens.gt(this.availableTokens))
        tmpTokens = BigNumber(this.availableTokens);

      if (tmpTokens.lt(step)) this.tokensToBuy = BigNumber(step);

      this.tokensToBuy = tmpTokens.toString();
    },

    BuyTokens() {
      var saleContractDef = web3.eth.contract(saleContractDefinition);
      var saleContract = saleContractDef.at(this.currentItem.saleAddress);
      var weiAmount = this.tokensPriceWeiBigNumber();
      var that = this;
      console.log("Wei Amount: ", weiAmount.toString());
      console.log(this.currentItem.saleAddress);
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

      return (web3.toChecksumAddress(adr) === web3.toChecksumAddress(web3.eth.defaultAccount)) 
    },
    filterFunction: function (item) {
      var itemStr;

      if (this.typeDrop < 3 && item.Type !== this.typeDrop) return false;
      if (this.typeDrop == 4) {
        console.log('TEST ITEM:', item.Owner)
        console.log(`${web3.toChecksumAddress(web3.eth.defaultAccount)} == ${web3.toChecksumAddress(item.Owner)}`)
        if (!this.isMyToken(item.Owner)) return false
        // console.log(web3.eth.defaultAccount)
      }

      if (this.typeDrop == 5) {
        if (item.ownedTokens === 0) return false
        // console.log(web3.eth.defaultAccount)
      }

      for (var val in item) {
        // console.log(item[val])

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
          return "Song";

        case 1:
          return "Band";

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
      console.log("Pic Link:", id);

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

      console.log("Decimals: ", decimals.sd());

      let maxValue = freeTokens.shiftedBy(-decimals.toNumber());

      console.log("MaX:", maxValue.toFormat());

      if (freeTokens.lt(tokensToBuy)) return true;

      let step = this.tokensStep(
        this.currentItem.Price,
        this.currentItem.Decimals
      );

      let numberofStep = tokensToBuy.div(step).dp(0, 1);

      if (numberofStep === null) return true;

      console.log("numberofStep: ", numberofStep);

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
      console.log("Decimals: ", decimals.sd());

      let maxValue = freeTokens.shiftedBy(-decimals.toNumber());

      console.log("MaX:", maxValue.toFormat());

      let step = this.tokensStep(
        this.currentItem.Price,
        this.currentItem.Decimals
      );

      let numberofStep = tokensToBuy.div(step).dp(0, 1);

      if (numberofStep === null) return true;

      console.log("numberofStep: ", numberofStep);

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
.player:hover {
  filter: invert(100%) hue-rotate(120deg);
}

a {
  color: #fafafa;
}

.unPlayable {
  opacity: 0;
  pointer-events: none;
}
</style>