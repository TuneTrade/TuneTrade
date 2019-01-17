<template>
  <b-form disabled @submit="onSubmit" @reset="onReset" v-if="show" class="newContractForm">
    <b-container class="newContractFormContainer">
      <b-row>
        <b-col cols="12">
          <b-form-group
            id="ICOYesNoGroup"
            label="Create Token Sale ? <br>(Optional)"
            label-for="ICOYesNoGroup"
            class="newContractLabel"
          >
            <b-form-radio-group
              id="ICOYesNoGroup"
              button-variant="outline-info"
              buttons
              size="sm"
              required
              class="testRadio"
              @change="UnSave()"
              v-on:click.native.stop="SwitchRadio"
              v-model="form.ico"
              :options="radioOptions"
              name
            />
          </b-form-group>
        </b-col>
        <b-col md="6" lg="4">
          <b-form-group
            id="nameInputGroup"
            label="Contribution Wallet Ethereum Address:"
            class="newContractLabel"
            label-for="wallet"
          >
            <b-form-input
              id="nameInput"
              type="text"
              v-model="form.wallet"
              required
              class="newContractInput"
              :disabled="ICODisabled"
              size="sm"
              @keydown.native="UnSave()"
              @change="UnSave()"
              placeholder="Wallet address"
            ></b-form-input>
          </b-form-group>
        </b-col>
        <b-col md="6" lg="4">
          <b-form-group
            id="teamtokensInputGroup"
            label="Tokens for a team [TOKEN]:"
            label-for="teamtokens"
            class="newContractLabel"
            :description="totalSupplyInfo"
          >
            <b-form-input
              id="teamtokens"
              type="number"
              v-model="form.teamtokens"
              @change="UnSave()"
              :disabled="ICODisabled"
              class="newContractInput"
              optional
              @keydown.native="UnSave()"
              size="sm"
              step="0.1"
              placeholder="Enter number of tokens for a team"
            ></b-form-input>
          </b-form-group>
        </b-col>
        <b-col md="6" lg="4">
          <b-form-group
            id="saleTokensInputGroup"
            label="Tokens assigned to Sale Contract [TOKEN]:"
            label-for="saleTokens"
            class="newContractLabel text-nowrap"
            :description="totalSupplyInfo"
          >
            <b-form-input
              id="teamtokens"
              type="text"
              v-model="form.saleTokens"
              @change="UnSave()"
              :disabled="ICODisabled"
              optional
              class="newContractInput"
              @keydown.native="UnSave()"
              size="sm"
              step="0.1"
              placeholder="Enter number of tokens assigned to ICO"
            ></b-form-input>
          </b-form-group>
        </b-col>
        <b-col md="6" lg="4">
          <b-form-group
            id="minpresaleGroup"
            label="Minimum Contribution PreSale [ETH]:"
            class="newContractLabel"
            label-for="minpresale"
          >
            <b-form-input
              id="minpersale"
              type="number"
              v-model="form.minpresale"
              :disabled="ICODisabled"
              class="newContractInput"
              @keydown.native="UnSave()"
              @change="UnSave()"
              optional
              size="sm"
              placeholder="Minimum presale"
            ></b-form-input>
          </b-form-group>
        </b-col>
        <b-col md="6" lg="4">
          <b-form-group
            id="minmainSaleGroup"
            label="Minimum Contribution MainSale [ETH]:"
            class="newContractLabel"
            label-for="minmainsale"
          >
            <b-form-input
              id="minmainsale"
              type="number"
              v-model="form.minmainsale"
              :disabled="ICODisabled"
              @keydown.native="UnSave()"
              class="newContractInput"
              @change="UnSave()"
              optional
              size="sm"
              placeholder="Minimum main sale"
            ></b-form-input>
          </b-form-group>
        </b-col>
        <b-col md="6" lg="4">
          <b-form-group
            id="maxETHGroup"
            label="Maximum ICO Contribution [ETH]: "
            class="newContractLabel"
            label-for="maxETH"
          >
            <b-form-input
              id="maxETH"
              type="number"
              v-model="form.maxETH"
              :disabled="ICODisabled"
              @keydown.native="UnSave()"
              class="newContractInput"
              @change="UnSave()"
              optional
              size="sm"
              placeholder="Enter Maximum Contribution"
            ></b-form-input>
          </b-form-group>
        </b-col>
        <b-col md="6" lg="4">
          <b-form-group
            id="maxcapgroup"
            label="Maximum Cap [TOKEN]:"
            class="newContractLabel"
            label-for="maxcap"
          >
            <b-form-input
              id="maxcap"
              type="number"
              @keydown.native="UnSave()"
              class="newContractInput"
              :disabled="ICODisabled"
              @change="UnSave()"
              v-model="form.maxcap"
              optional
              size="sm"
              placeholder="Maximum Cap"
            ></b-form-input>
          </b-form-group>
        </b-col>
        <b-col md="6" lg="4">
          <b-form-group
            id="mincapgroup"
            label="Minimum Cap [TOKEN]:"
            class="newContractLabel"
            label-for="mincap"
          >
            <b-form-input
              id="mincap"
              type="number"
              v-model="form.mincap"
              @keydown.native="UnSave()"
              class="newContractInput"
              :disabled="ICODisabled"
              @change="UnSave()"
              optional
              size="sm"
              placeholder="Minimum Cap"
            ></b-form-input>
          </b-form-group>
        </b-col>
        <b-col md="6" lg="4">
          <b-form-group
            id="priceETHGroup"
            label="Rate [Mini Token/WEI]"
            class="newContractLabel"
            label-for="priceETH"
          >
            <b-form-input
              id="priceETH"
              type="number"
              v-model="form.priceETH"
              @keydown.native="UnSave()"
              class="newContractInput"
              :disabled="ICODisabled"
              @change="UnSave()"
              optional
              size="sm"
              placeholder="Enter Token Price"
            ></b-form-input>
          </b-form-group>
        </b-col>
        <b-col md="6" lg="4">
          <b-form-group
            id="durationDaysGroup"
            label="Main Campaign Duration [DAY]:"
            class="newContractLabel"
            label-for="campaignDuration"
          >
            <b-form-input
              id="campaignDuration"
              type="number"
              v-model="form.campaignDuration"
              @change="UnSave()"
              :disabled="ICODisabled"
              class="newContractInput"
              @keydown.native="UnSave()"
              optional
              size="sm"
              placeholder="Enter Campaign Duration Days"
            ></b-form-input>
          </b-form-group>
        </b-col>
        <b-col md="6" lg="4">
          <b-form-group
            id="presaledurationDaysGroup"
            label="Presale Duration [DAY]:"
            class="newContractLabel"
            label-for="presalecampaignDuration"
          >
            <b-form-input
              id="presalecampaignDuration"
              type="number"
              v-model="form.presaleDuration"
              @change="UnSave()"
              class="newContractInput"
              :disabled="ICODisabled"
              @keydown.native="UnSave()"
              optional
              size="sm"
              placeholder="Enter Pre-Sale Duration Days"
            ></b-form-input>
          </b-form-group>
        </b-col>
        <b-col xl="12">
          <div
            style="grid-column:1/4;font-size:13px; font-weight:200"
          >Rate adjusted by number of decimals ({{decimals}}) in [TOKEN/ETH]: {{rateDescription}}</div>
          <span style="color:red;font-size:14px;">
            <i>{{tokenNumberError}}</i>
          </span>
        </b-col>
      </b-row>
    </b-container>
  </b-form>
</template>

<script>
var BigNumber = require('bignumber.js')

var radioOptions = ['No', 'Yes']
export default {
  data() {
    return {
      form: {
        wallet: '0x228084F69a171C972270373d5aeb1617D6E3679c',
        ico: 'No',
        teamtokens: 0,
        saleTokens: 0,
        minpresale: 0,
        minmainsale: 0,
        maxETH: 0,
        maxcap: 0,
        mincap: 0,
        priceETH: 100,
        campaignDuration: 1,
        presaleDuration: 1
      },
      show: true,
      test: false,
      radioOptions: radioOptions,
      checked: true
    }
  },
  created: function () {
    this.UnSave()
  },
  computed: {
    rateDescription: function () {
      var rate = this.form.priceETH
      var decimals = parseInt(this.$store.state.formG.decimals)

      return BigNumber(rate).shiftedBy(18).shiftedBy(-decimals).toFormat()
    },
    decimals: function () {
      return this.$store.state.formG.decimals
    },
    tokenNumberError: function () {
      var supply = parseInt(this.$store.state.formG.totalSupply)
      var maxcap = parseInt(this.form.maxcap)
      var mincap = parseInt(this.form.mincap)
      var saleTokens = parseInt(this.form.saleTokens)
      var minmainsale = parseInt(this.form.minmainsale)
      var minpresale = parseInt(this.form.minpresale)
      var maxEth = parseInt(this.form.maxETH)
      // var freeTokens = supply - saleTokens
      var teamtokens = parseInt(this.form.teamtokens)
      console.log('Min cap: ', mincap, ' Max cap: ', maxcap)
      var withoutMaxCap = supply - maxcap
      if ((minmainsale + minpresale) > maxEth) return 'Maximum allowed contribution is smaller than minimum presale and main sale contribution.'
      if (teamtokens > saleTokens && teamtokens > 0) return 'Not enough tokens for a team. Check total supply or tokens assigned to ICO.'
      if (saleTokens > supply) return 'Tokens has not enough tokens for sale. Check token total supply.'
      if (saleTokens < maxcap) return 'ICO available tokens are smaller than max cap.'
      if (saleTokens < mincap) return 'ICO available tokens are smaller than min cap.'
      if (withoutMaxCap < 0) return 'Total Supply is smaller than maxCap.'
      if ((this.form.mincap > this.form.maxcap) && this.form.maxcap > 0) return 'Minimum cap is bigger than maximum cap.'
    },
    saleTokens: function () {
      var supply = parseInt(this.$store.state.formG.totalSupply)
      var maxcap = parseInt(this.form.maxcap)
      var withoutTeam = supply - parseInt(this.form.teamtokens)
      if (maxcap < withoutTeam) return maxcap
      else return withoutTeam
    },
    totalSupplyInfo: function () {
      return 'Total supply: ' + this.localNumber(this.$store.state.formG.totalSupply)
    },
    ICODisabled: function () {
      if (this.form.ico === 'Yes') return false
      else return true
    }
  },
  methods: {
    SwitchRadio: function (evt) {
      evt.preventDefault()
      console.log('Switch Radio Magier')
      if (this.form.ico === 'No') {
        this.radioOptions = ['No', 'Yes']
        this.form.ico = 'Yes'
      } else {
        this.form.ico = 'No'
        this.radioOptions = ['No', 'Yes']
      }
      this.UnSave()
    },
    UnSave() {
      for (var key in this.form) {
        console.log('form[' + key + '] = ' + this.form[key])
        this.$store.state.formI[key] = this.form[key]
      }
      this.$store.state.formI = this.form
      console.log('Stored form: ', this.$store.state.form)
      this.unsaved = true
    },
    onSubmit(evt) {
      evt.preventDefault()
      alert(JSON.stringify(this.form))
    },
    localNumber: function (val) {
      if (isNaN(val)) return 0
      var entry = parseFloat(val)
      var num = entry.toLocaleString()
      return num
    },
    onReset(evt) {
      evt.preventDefault()
      /* Reset our form values */
      this.form.email = ''
      this.form.name = ''
      this.form.author = ''
      this.form.symbol = ''
      this.form.genre = ''
      this.form.symbol = ''
      this.form.website = ''
      this.form.type = ''
      this.form.checked = []
      /* Trick to reset/clear native browser form validation state */
      this.show = false
      this.$nextTick(() => { this.show = true })
    }
  }
}
</script>
<style lang="css">
.form-control:disabled {
  background-color: #909090;
  opacity: 0.7;
}
.text-muted {
  color: #a0a0a0 !important;
  font-size: 12px;
}
</style>
<!-- b-form-1.vue -->
