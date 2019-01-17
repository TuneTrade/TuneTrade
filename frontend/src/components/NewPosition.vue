<template>
  <b-container>
    <b-row>
      <b-col cols="12">
        <b-button
          variant="info"
          @click.stop="ShowSongDetails()"
          class="buyCoinButton mt-3"
        >Song Details</b-button>
      </b-col>
    </b-row>
    <b-row>
      <b-col cols="12" lg="3">
        <b-row class="px-3">
          <b-col cols="12" class="h-50 p-0 mt-3" style>
            <b-img
              v-bind:src="picLink(item.Id)"
              style="height:250px"
              class="img img-responsive img-thumbnail"
            />
          </b-col>
        </b-row>
      </b-col>
      <b-col lg="9" cols="12" class="mt-lg-3">
        <b-row>
          <b-col class="mb-4 text-center text-lg-left" cols="12">
            <b>Adding new position:
              <br>
              {{SongOrBand(item.Type)}} "{{item.Name}}"
            </b>
          </b-col>
          <b-col cols="12" lg="6" class="text-center text-lg-left">
            <b-form-group
              id="typeGroup"
              label="Type:"
              label-for="typeGroup"
              description="Buy or Sell ?"
              class
            >
              <b-form-radio-group
                id="typeGroup"
                buttons
                button-variant="outline-primary"
                size="sm"
                optional
                @change
                v-model="type"
                :options="['Buy', 'Sell']"
                name="radioBtnOutline"
                style
              />
            </b-form-group>
          </b-col>
          <b-col
            cols="12"
            lg="6"
            class="mb-2"
            v-bind:class="{invisible:!positionTx,visible:positionTx}"
          >
            <OneTransaction v-bind:id="positionTx" style="background-color:#223749"/>
          </b-col>

          <b-col cols="12" md="6" lg="6" class="text-left mt-0">
            <b-form-group id="volumeGroup" label="Volume:" label-for="volumeInput" class>
              <b-form-input
                id="volumeInput"
                type="number"
                step="1"
                min="0"
                v-model="volume"
                required
                size="sm"
                placeholder="Enter volume"
                class="newContractInput"
              ></b-form-input>
            </b-form-group>
          </b-col>
          <b-col cols="12" md="6" lg="6" class="text-left">
            <b-form-group id="costGroup" label="Cost [ETH]:" label-for="costInput" class>
              <b-form-input
                id="costInput"
                type="text"
                step="any"
                min="0"
                pattern="[0-9]+([\.][0-9]+)?"
                v-model="cost"
                required
                size="sm"
                placeholder="Enter cost"
                class="newContractInput"
              ></b-form-input>
            </b-form-group>
          </b-col>

          <b-col
            cols="12"
            style="white-space:nowrap"
            class="text-center text-lg-left mt-lg-3"
          >Your balance: {{SongBalance(item.Decimals, item.ownedTokens)}} {{item.Symbol}}</b-col>
        </b-row>
      </b-col>
      <b-col cols="12" class="mb-3 mt-4">
        <b-button
          @click.stop="AddPosition()"
          class="buyCoinButton"
          size="sm"
          variant="info"
        >Add Position</b-button>
      </b-col>
    </b-row>
  </b-container>
</template>


<script>
var BigNumber = require('bignumber.js')
import OneTransaction from './OneTransaction'



export default {
  data() {
    return {
      volume: 1,
      cost: 0.1,
      type: 'Buy',
      item: {},
      positionTx: null
    }
  },
  components: {
    OneTransaction
  },
  props: {
    song: String
  },
  created: function () {
    console.log(this.song, 'prop song')
    this.item = this.$store.getters.getSong(this.song)
  },
  methods: {
    ShowSongDetails: function () {
      this.$store.state.showBuyCoins = {}
      this.$store.state.showNewPosition = {}

    },
    SongBalance: function (decimals, volume) {
      return BigNumber(volume).shiftedBy(0 - decimals).toFormat(6)
    },
    picLink: function (id) {
      console.log('Pic Link:', id)
      if (id === undefined) {
        return null
      }
      return this.$store.state.API + '/getPicture?id=' + id
      console.log('Picture ID')
      // return 'https://source.unsplash.com/random/480x480'
    },
    SongOrBand: function (val) {
      switch (parseInt(val)) {
        case 0:
          return 'Song'
        case 1:
          return 'Band'
        case 2:
          return 'Influencer'
        case 3:
          return 'All'
        default:
          return 'Error'
      }
    },
    AddPosition: function () {
      var that = this
      var cost = web3.toWei(this.cost, "ether")
      var contract = that.$store.state.web3exchangeContract
      var volume = BigNumber(this.volume).shiftedBy(this.item.Decimals).toString()
      console.log('Add position')

      this.$store.dispatch('AddTransaction', {
        title: 'Add New Position'
      })
      var txind = this.$store.getters.getTransactionIndex
      this.positionTx = txind
      var type
      if (this.type === 'Buy') {
        type = true
        var valuecost = cost
      }
      else {
        type = false
        valuecost = 0
      }
      contract.AddPosition(this.item.address, volume, type, cost, { value: valuecost },
        function (err, res) {
          if (res !== undefined) {
            console.log(res)
            that.$store.dispatch('UpdateTransactionMining', {
              index: txind,
              number: res
            })
          } else {
            that.$store.dispatch('UpdateTransactionCancelled', {
              index: txind,
              msg: err.message
            })
          }
        }
      )
    },
  }
}

</script>
