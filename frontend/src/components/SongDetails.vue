<template>
  <b-card style="background-color:inheritfont-size:11px;" class="detailsRowCard">
    <!-- <b-button v-if="navigate" @click.stop="GoBack()" size="sm" variant>Back</b-button> -->
    <!-- <br><br> -->
    <b-container class="m-0 p-0">
      <!-- Details Information Row -->
      <b-row>
        <!-- Picture Column -->
        <b-col cols="12" md="12" sm="12" lg="3" class="text-sm-center text-lg-left">
          <b-img
            blank-color="#777"
            v-bind:src="picLink(item.Id)"
            class="img-thumbnail img-responsive img"
          />
        </b-col>
        <b-col md="12" lg="9">
          <b-row>
            <!-- First Details Column -->
            <b-col cols="12" sm="12" md="6" lg="6">
              <b-row class="detailsRow p-3">
                <b-col cols="5" sm="4" class="text-large-sm text-sm-left text-right">Type:</b-col>
                <b-col
                  cols="7"
                  sm="8"
                  class="text-large-sm text-sm-left text-left detailsInformation"
                >{{ SongOrBand(item.Type) }}</b-col>

                <b-col cols="5" sm="4" class="text-large-sm text-right text-sm-left">Name:</b-col>
                <b-col
                  cols="7"
                  sm="8"
                  class="text-large-sm text-left text-sm-left detailsInformation"
                >&quot{{ item.Name }}&quot</b-col>
                <b-col cols="5" sm="4" class="text-sm-left text-right text-large-sm">Author:</b-col>
                <b-col
                  cols="7"
                  sm="8"
                  class="text-sm-left text-left text-large-sm detailsInformation"
                >{{ item.Author }}</b-col>
                <b-col cols="5" sm="4" class="text-large-sm text-right text-sm-left">
                  Price
                  <small>[{{item.Symbol}}/ETH]:</small>
                </b-col>
                <b-col
                  cols="7"
                  sm="8"
                  class="text-large-sm text-left detailsInformation"
                >{{tokensForEth(item.Price,item.Decimals)}}</b-col>
                <b-col cols="5" sm="4" class="text-large-sm text-right text-sm-left">Phase:</b-col>
                <b-col
                  cols="7"
                  sm="8"
                  class="text-left text-large-sm detailsInformation"
                >{{Phase(item.State)}}</b-col>
                <b-col cols="5" sm="4" class="mt-2 text-large-sm text-right text-sm-left">Website:</b-col>
                <b-col
                  cols="12"
                  sm="8"
                  class="mt-2 d-inline-block text-truncate text-sm-left text-center pt-2 pt-sm-0 detailsInformation"
                  style="max-width: 250px;"
                >
                  <b-link
                    class="text-primary"
                    target="_blank"
                    v-bind:href="WebsiteLink(item.Website)"
                  >{{WebsiteLink(item.Website)}}</b-link>
                </b-col>
              </b-row>
            </b-col>
            <!-- Second details column  -->
            <b-col class cols="12" md="6" sm="12" lg="6">
              <b-row class="detailsRow p-3">
                <b-col
                  cols="5"
                  sm="5"
                  class="text-sm-left text-right text-large-sm"
                >Contribution [ETH]:</b-col>
                <b-col
                  cols="7"
                  sm="7"
                  class="text-sm-left text-left text-large-sm detailsInformation"
                >{{ Price(item.Contribution) }}</b-col>
                <b-col
                  cols="5"
                  sm="5"
                  class="text-sm-left text-right text-large-sm"
                >Volume [{{item.Symbol}}]:</b-col>
                <b-col
                  cols="7"
                  sm="7"
                  class="text-sm-left text-left text-large-sm detailsInformation"
                >
                  {{BigValue(item.Volume,item.Decimals)
                  }}
                </b-col>
                <b-col cols="5" sm="5" class="text-sm-left text-right text-large-sm">
                  Total Supply
                  [{{item.Symbol}}]:
                </b-col>
                <b-col
                  sm="7"
                  cols="7"
                  class="text-large-sm text-left text-sm-left detailsInformation"
                >{{BigValue(item.TotalSupply,item.Decimals) }}</b-col>
                <b-col sm="5" cols="5" class="text-large-sm text-right text-sm-left">Decimals:</b-col>
                <b-col
                  sm="7"
                  cols="7"
                  class="text-large-sm text-left text-sm-left detailsInformation"
                >{{item.Decimals}}</b-col>
                <b-col sm="5" cols="5" class="text-large-sm text-right text-sm-left">Genre:</b-col>
                <b-col
                  sm="7"
                  cols="7"
                  class="text-large-sm text-left text-sm-left detailsInformation"
                >{{ item.Genre }}</b-col>
                <b-col sm="5" cols="5" class="text-large-sm text-right text-sm-left">Created:</b-col>
                <b-col
                  sm="7"
                  cols="7"
                  class="text-large-sm text-sm-left text-left detailsInformation"
                >{{ getLocalTime( item.Created )}}</b-col>
              </b-row>
            </b-col>
          </b-row>
          <b-row class="pl-4">
            <!-- Action buttons -->
            <b-col cols="12">
              <!-- Action Buttons Row -->
              <b-row class="mt-3">
                <b-col cols="12" md="auto" lg="auto" class="text-sm-center p-0">
                  <b-button
                    v-if="tokenOnSale(item.State) && !navigate"
                    @click.stop="ShowBuyModal(item)"
                    variant="info"
                    class="buyCoinButton mr-3"
                  >BUY COIN</b-button>
                </b-col>
                <b-col cols="12" sm="12" md="auto" lg="auto" class="text-sm-center p-0">
                  <b-button
                    v-if="!navigate"
                    :to="{name: 'TokenExchange', params: {filterProp: 'Sale', contractProp: item.address}}"
                    variant="info"
                    class="buyCoinButton mr-3"
                  >Buy/Sell on the Market</b-button>
                </b-col>
                <b-col cols="12" sm="12" md="auto" lg="auto" class="text-sm-center p-0">
                  <b-button
                    v-if="!navigate"
                    @click.stop="ShowNewPosition(item)"
                    variant="info"
                    class="buyCoinButton mr-3"
                  >Create New Position</b-button>
                </b-col>
                <b-col cols="12" sm="12" md="auto" lg="auto" class="text-sm-center p-0">
                  <b-button
                    v-if="!navigate && canDeleteToken"
                    @click.stop="DeleteToken(item)"
                    variant="danger"
                    class="buyCoinButton mr-3"
                  >Delete Token Contract</b-button>
                </b-col>
              </b-row>
            </b-col>
            <b-col sm="12" class="text-center text-md-left p-0">
              <p style="font-size:14px">
                <br>Your Balance:
                <b>{{BigValue(item.ownedTokens, item.Decimals)}} {{item.Symbol}}</b>
              </p>
            </b-col>
          </b-row>
        </b-col>
      </b-row>
      <b-row class="mt-3 pl-0 pl-sm-4">
        <!-- Third Details Column - Smart Contract Addresses  -->
        <b-col xl="4" lg="6" md="6" class="text-sm-left mx-0 p-0">
          Owner
          <span v-if="isMyToken(item.Owner)" class>(My token)</span>:
          <br>
          <b-link
            target="_blank"
            style="font-size:13px;"
            class="text-primary"
            v-bind:href="etherscanAddress(item.Owner)"
            variant="danger"
          >{{item.Owner}}</b-link>
        </b-col>

        <b-col xl="4" lg="6" md="6" class="text-sm-left m-0 p-0">Token address:
          <br>
          <b-link
            target="_blank"
            style="font-size:13px"
            class="text-primary m-0"
            v-bind:href="etherscanToken(item.address)"
            variant="danger"
          >{{item.address}}</b-link>
        </b-col>

        <b-col xl="4" lg="6" md="12" class="text-sm-left m-0 p-0">Sale address:
          <br>
          <b-link
            target="_blank"
            style="font-size:13px;"
            class="text-primary m-0"
            v-bind:href="etherscanToken(item.saleAddress)"
            variant="danger"
          >{{item.saleAddress}}</b-link>
        </b-col>
      </b-row>

      <!-- Embeded players row -->
      <b-row class="p-0">
        <b-col cols="12" :lg="youtubeGroupCol" v-if="videoId" class>
          <b-row>
            <b-col cols="0" sm="0" :lg="youtubeSideCol"></b-col>
            <b-col cols="12" sm="12" :lg="youtubeMainCol" class="m-0 pt-xl-2 pt-lg-4 px-lg-0">
              <b-embed tag="div" :src="videoId" class></b-embed>
            </b-col>
            <b-col cols="0" sm="0" :lg="youtubeSideCol"></b-col>
          </b-row>
        </b-col>
        <b-col cols="12" :lg="soundCloudGroupCol" v-if="item.playable">
          <b-row>
            <b-col cols="0" :lg="soundCloudSideCol" class></b-col>
            <b-col
              cols="12"
              v-if="item.playable"
              sm="12"
              :lg="soundCloudMainCol"
              class="embedTD py-2"
            >
              <div style="width:100%" class v-if="item.playable" v-html="item.iFrameEmbed"></div>
            </b-col>
            <b-col cols="0" :lg="soundCloudSideCol" class></b-col>
          </b-row>
        </b-col>
      </b-row>
      <!-- Description Row -->
      <b-row class="mt-3">
        <b-col cols="12" class="text-left">
          <p style="white-space: none" class>{{item.Description}}</p>
        </b-col>
      </b-row>
      <!-- End of Description Row -->
    </b-container>
  </b-card>
</template>

<script>
import axios from "axios";
var BigNumber = require("bignumber.js");
// var SC = require('soundcloud')
require("./saleContractdef.js");
SC.initialize("rZY6FYrMpGVhVDfaKEHdCaY8ALekxd8P");

// SC.initialize('174155989')

var URI = require("uri-js");

var Web3 = require("web3");

export default {
  data() {
    return {
      item: {},
      sortBy: "Created",
      playerVars: {
        autoplay: 0
      },
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
      typeDrop: 3
    };
  },
  props: {
    song: String,
    navigate: Boolean
  },
  created: function() {
    this.item = this.$store.getters.getSong(this.song);
    console.log("Adres: ", this.song);
    console.log(this.item);
  },
  methods: {
    playing: function() {
      // alert('playing')
    },
    GoBack: function() {
      this.$router.go(-1);
    },
    showHideFilters: function() {
      this.showFilters = !this.showFilters;
    },
    WebsiteLink: function(address) {
      let uriParsed = URI.parse(address);
      if (uriParsed.path.length > 0) {
        if (uriParsed.scheme === undefined) console.log(uriParsed);
        return "http://" + address;
      } else {
        return null;
      }
    },
    tokenOnSale: function(state) {
      if (state === undefined) return false;
      if (state === "Presale") return true;
      if (state === "Main Sale") return true;
      return false;
    },
    Phase: function(state) {
      if (state === undefined) return "Not on sale";
      if (state.length > 0) return state;
      return "Not on sale";
    },
    ValidateTokens: function() {
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
      if (tmpTokens.gt(this.availableTokens)) {
        tmpTokens = BigNumber(this.availableTokens);
      }
      if (tmpTokens.lt(step)) {
        this.tokensToBuy = BigNumber(step);
      }
      this.tokensToBuy = tmpTokens.toString();
    },
    ShowTransactions(id) {
      this.$store.state.showTransactions = null
      this.$store.state.showTransactions = {}
      this.$store.state.showTransactions[this.item.address] = id
      this.$store.state.showBuyCoins = null
      this.$store.state.showBuyCoins = {}
    },
    DeleteToken() {
      if (typeof web3 === "undefined") return;
      var that = this
      var contract = that.$store.state.web3contract;
      this.$store.dispatch("AddTransaction", {
        title: "Delete " + this.item.Name + " from blockchain"
      });

      var txind = this.$store.getters.getTransactionIndex;
      this.ShowTransactions(txind)
      console.log('Song address:', this.item )
      contract.RemoveSong(this.item.address, function(err, res) {
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
      });
    },
    BuyTokens() {
      if (typeof web3 === "undefined") return;
      var saleContractDef = web3.eth.contract(saleContractDefinition);
      var saleContract = saleContractDef.at(this.currentItem.saleAddress);
      var weiAmount = this.tokensPriceWeiBigNumber();
      var that = this;
      console.log("Wei Amount: ", weiAmount.toString());
      console.log(this.currentItem.saleAddress);
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
        function(err, res) {
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
    ShowBuyModal: function(item) {
      this.$store.state.showBuyCoins = null;
      this.$store.state.showBuyCoins = {};
      this.$store.state.showBuyCoins[item.address] = true;
      this.$store.state.showNewPosition = {};
      this.$store.state.showTransactions = {};
    },
    ShowNewPosition: function(item) {
      console.log("show new position");
      this.$store.state.showNewPosition = null;
      this.$store.state.showNewPosition = {};
      this.$store.state.showNewPosition[item.address] = true;
      this.$store.state.showBuyCoins = {};
      this.$store.state.showTransactions = {};
    },
    tokensForEth: function(rate, decimals) {
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
    tokensForWei: function(rate, decimals) {
      if (rate === undefined) return null;
      if (decimals === undefined) decimals = 0;
      let dec = parseInt(decimals);
      let r = BigNumber(rate);
      return r.shiftedBy(-dec).toFormat();
    },
    tokensStep: function(rate, decimals) {
      if (rate === undefined) return null;
      if (decimals === undefined) decimals = 0;
      let r = BigNumber(rate);
      r = r.shiftedBy(-decimals);
      return r.toFormat();
    },
    tokensPriceWei: function(rateInWei, tokensAmount) {
      let decimals = parseInt(this.currentItem.Decimals);
      if (isNaN(decimals)) return 0;
      let amount = BigNumber(tokensAmount).shiftedBy(decimals);
      return amount.div(rateInWei).toFormat();
    },
    tokensPriceWeiBigNumber: function(rateInWei, tokensAmount) {
      let amount = BigNumber(this.tokensToBuy);
      let rate = BigNumber(this.currentItem.Price);
      let decimals = parseInt(this.currentItem.Decimals);
      if (isNaN(decimals)) return 0;
      return amount.shiftedBy(decimals).div(rate);
    },
    tokensPriceEth: function() {
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
    filterType: function(type) {
      this.typeDrop = type;
    },
    isMyToken: function(adr) {
      if (typeof web3 === "undefined") return false;
      return (
        web3.toChecksumAddress(adr) ===
        web3.toChecksumAddress(web3.eth.defaultAccount)
      );
    },
    filterFunction: function(item) {
      var itemStr;
      if (this.typeDrop < 3 && item.Type !== this.typeDrop) return false;
      if (this.typeDrop == 4) {
        if (!this.isMyToken(item.Owner)) return false;
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
    getRelated: function(link) {
      axios
        .get(
          "http://api.soundcloud.com/resolve?url=" +
            link +
            "&client_id=rZY6FYrMpGVhVDfaKEHdCaY8ALekxd8P"
        )
        .then(function(res) {});
    },
    etherscanToken: function(address) {
      if (address.length === 0) return null;
      return "https://ropsten.etherscan.io/token/" + address;
    },
    etherscanAddress: function(address) {
      return "https://ropsten.etherscan.io/address/" + address;
    },
    Price: function(priceInWei) {
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
    resetModal() {},
    getLocalTime: function(val) {
      var ts = new Date(parseInt(val) * 1000);
      return ts.toLocaleString();
    },
    SongOrBand: function(val) {
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
    // uint8 phase // 1 - pre-sale, 2 - ico1, 3 - ico2, 4 - ico 3 5 - post ico, 6 - finished, 0 - not running.
    PhaseToString: function(val) {
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
    onError: function() {
      alert("error");
    },
    onAbort: function() {
      alert("aborted");
    },
    loaded: function() {
      if (this.loading >= 0) {
        this.loading = -1;
      }
    },
    isLoading: function(index) {
      if (this.changing === index || this.loading === index) {
        return true;
      } else {
        return false;
      }
    },
    playMusic: function(index, link) {
      var that = this;
      if (index === this.currentIndex) {
        this.currentIndex = -1;
        this.musicPlayerLink = "";
        return;
      }
      this.currentIndex = index;
      this.changing = index;
      this.musicPlayerLink = "";
      setTimeout(function() {
        that.changing = -1;
        that.loading = index;
        SC.oEmbed(link, {
          auto_play: true
        })
          .then(function(em) {
            that.musicPlayerLink = em.html;
            that.loading = -1;
          })
          .catch(function(err) {});
      }, 100);
    },
    localNumber: function(val) {
      if (isNaN(val)) return val;
      var entry = parseFloat(val);
      var num = entry.toLocaleString();
      return num;
    },
    BigValue: function(val, dec) {
      if (isNaN(val)) return val;
      var num = BigNumber(val);
      let decimals = parseInt(dec);
      return num.shiftedBy(-decimals).toFormat();
    },
    picLink: function(id) {
      console.log("Pic Link:", id);
      if (id === undefined) {
        return null;
      }
      return this.$store.state.API + "/getPicture?id=" + id;
      console.log("Picture ID");
      // return 'https://source.unsplash.com/random/480x480'
    },
    isPlaying: function(rowNumber) {
      if (this.currentIndex === rowNumber) return true;
      else return false;
    }
  },
  computed: {
    canDeleteToken: function() {
      let isOwner = this.$store.getters.isWeb3Account(this.item.Owner)
      let isContractOwner = this.$store.getters.isContractOwner();
      
      return (isOwner || isContractOwner)
    },
    soundCloudSideCol: function() {
      if (this.videoId === null) return 3;
      else return 0;
    },
    soundCloudMainCol: function() {
      if (this.videoId === null) return 6;
      else return 12;
    },

    soundCloudGroupCol: function() {
      if (this.videoId === null) return 12;
      else return 6;
    },
    youtubeSideCol: function() {
      if (this.item.playable) return 0;
      else return 2;
    },
    youtubeMainCol: function() {
      if (this.item.playable) return 12;
      else return 8;
    },
    youtubeGroupCol: function() {
      if (this.item.playable) return 6;
      else return 12;
    },

    videoId: function() {
      if (this.item.youtube === "") return null;
      return (
        "https://youtube.com/embed/" +
        this.$youtube.getIdFromUrl(this.item.youtube)
      );
      // this.youtubeId = 'https://youtube.com/embed/' + this.$youtube.getIdFromUrl(val.youtube)
    },

    tokensAndBonus: function() {
      let tokensToBuy = BigNumber(this.tokensToBuy);
      let bonus = this.currentItem.Bonus;
      return tokensToBuy
        .times(100 + bonus)
        .div(100)
        .toString();
    },
    availableTokens: function() {
      let free = BigNumber(this.currentItem.FreeTokens);
      let decimals = parseInt(this.currentItem.Decimals);
      if (isNaN(decimals)) return 0;
      return free.shiftedBy(-decimals).toFormat();
    },
    cantBuyTokens: function() {
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
    cantBuyTokensMsg: function() {
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

    noSongs: function() {
      return this.songs.length === 0;
    },

    typeDropText: function() {
      return "Type (" + this.SongOrBand(this.typeDrop) + ")";
    },

    songsReady: function() {
      return this.$store.state.songsReady;
    },

    songs: function() {
      return this.$store.state.songs;
    },

    totalRows: function() {
      return this.songs.length;
    },

    songsCounter: function() {
      if (this.$store.state.songs !== undefined) {
        return this.$store.state.songs.length;
      } else {
        return 0;
      }
    }
  }
};
</script>
<style lang='css'>
</style>