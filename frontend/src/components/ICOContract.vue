<template>
  <div>
    <b-form disabled @submit="onSubmit" @reset="onReset" v-if="show" class="newContractForm">
      <div class="newContractFormContainer">
<!--
        <b-form-checkbox v-model="checked"
        button-variant="warning"
        variant="warning"
        >
          Click me to see what happens
        </b-form-checkbox> -->

        <b-form-group id="ICOYesNoGroup"
                      label="Create ICO Contract ?"
                      label-for="ICOYesNoGroup"
                      >
          <b-form-radio-group id="ICOYesNoGroup"
                      button-variant="outline-info"
                      buttons
                      size="sm"
                      required
                      class="testRadio"
                      @change="UnSave()"
                      v-on:click.native.stop="SwitchRadio"
                      v-model="form.ico"
                      :options="radioOptions"
                      name="" />
        </b-form-group>
      <b-form-group id="nameInputGroup"
                    label="Contribution Wallet Ethereum Address:"
                    label-for="wallet">
        <b-form-input id="nameInput"
                      type="text"
                      v-model="form.wallet"
                      required
                      :disabled="ICODisabled"
                      size="sm"
                      @keydown.native = "UnSave()"
                      @change = "UnSave()"
                      placeholder="Wallet address">
        </b-form-input>
      </b-form-group>


      <b-form-group id="teamtokensInputGroup"
                    label="Tokens for a team [TOKEN]:"
                    label-for="teamtokens"
                    :description = "totalSupplyInfo">
        <b-form-input id="teamtokens"
                      type="number"
                      v-model="form.teamtokens"
                      @change = "UnSave()"
                      :disabled="ICODisabled"
                      optional
                      @keydown.native = "UnSave()"
                      size="sm"
                      step="0.1"
                      placeholder="Enter number of tokens for a team">
        </b-form-input>
      </b-form-group>

      <b-form-group id="saleTokensInputGroup"
                    label="Tokens assigned to Sale Contract [TOKEN]:"
                    label-for="saleTokens"
                    :description = "totalSupplyInfo">
        <b-form-input id="teamtokens"
                      type="text"
                      v-model="form.saleTokens"
                      @change = "UnSave()"
                      :disabled="ICODisabled"
                      optional
                      @keydown.native = "UnSave()"
                      size="sm"
                      step="0.1"
                      placeholder="Enter number of tokens assigned to ICO">
        </b-form-input>
      </b-form-group>

      <b-form-group id="minpresaleGroup"
                    label="Minimum Contribution PreSale [ETH]:"
                    label-for="minpresale">
        <b-form-input id="minpersale"
                      type="number"
                      v-model="form.minpresale"
                      :disabled="ICODisabled"
                      @keydown.native = "UnSave()"
                      @change = "UnSave()"
                      optional
                      size="sm"
                      placeholder="Minimum presale">
        </b-form-input>
      </b-form-group>


      <b-form-group id="minmainSaleGroup"
                    label="Minimum Contribution MainSale [ETH]:"
                    label-for="minmainsale">
        <b-form-input id="minmainsale"
                      type="number"
                      v-model="form.minmainsale"
                      :disabled="ICODisabled"
                      @keydown.native = "UnSave()"
                      @change = "UnSave()"
                      optional
                      size="sm"
                      placeholder="Minimum main sale">
        </b-form-input>
      </b-form-group>


      <b-form-group id="maxETHGroup"
                    label="Maximum ICO Contribution [ETH]: "
                    label-for="maxETH">
        <b-form-input id="maxETH"
                      type="number"
                      v-model="form.maxETH"
                      :disabled="ICODisabled"
                      @keydown.native = "UnSave()"
                      @change = "UnSave()"
                      optional
                      size="sm"
                      placeholder="Enter Maximum Contribution"
                      >
        </b-form-input>
      </b-form-group>

      <b-form-group id="maxcapgroup"
                    label="Maximum Cap [TOKEN]:"
                    label-for="maxcap">
        <b-form-input id="maxcap"
                      type="number"
                      @keydown.native = "UnSave()"
                      :disabled="ICODisabled"
                      @change = "UnSave()"
                      v-model="form.maxcap"
                      optional
                      size="sm"
                      placeholder="Maximum Cap"
                      >
        </b-form-input>
      </b-form-group>

      <b-form-group id="mincapgroup"
                    label="Minimum Cap [TOKEN]:"
                    label-for="mincap">
        <b-form-input id="mincap"
                      type="number"
                      v-model="form.mincap"
                      @keydown.native = "UnSave()"
                      :disabled="ICODisabled"
                      @change = "UnSave()"
                      optional
                      size="sm"
                      placeholder="Minimum Cap"
                      >
        </b-form-input>
      </b-form-group>


      <b-form-group id="priceETHGroup"
                    label="Rate [Mini Token/WEI]"
                    label-for="priceETH"
                    >
        <b-form-input id="priceETH"
                      type="number"
                      v-model="form.priceETH"
                      @keydown.native = "UnSave()"
                      :disabled="ICODisabled"
                      @change="UnSave()"
                      optional
                      size="sm"
                      placeholder="Enter Token Price"
                      >
        </b-form-input>
      </b-form-group>


      <b-form-group id="durationDaysGroup"
                    label="Main Campaign Duration [DAY]:"
                    label-for="campaignDuration">
        <b-form-input id="campaignDuration"
                      type="number"
                      v-model="form.campaignDuration"
                      @change="UnSave()"
                      :disabled="ICODisabled"
                      @keydown.native = "UnSave()"
                      optional
                      size="sm"
                      placeholder="Enter Campaign Duration Days"
                      >
        </b-form-input>
      </b-form-group>

      <b-form-group id="presaledurationDaysGroup"
                    label="Presale Duration [DAY]:"
                    label-for="presalecampaignDuration">
        <b-form-input id="presalecampaignDuration"
                      type="number"
                      v-model="form.presaleDuration"
                      @change="UnSave()"
                      :disabled="ICODisabled"
                      @keydown.native = "UnSave()"
                      optional
                      size="sm"
                      placeholder="Enter Pre-Sale Duration Days"
                      >
        </b-form-input>
      </b-form-group>
      </b-form-group>
<div style="grid-column:1/4;font-size:13px; font-weight:200"> Rate adjusted by number of decimals ({{decimals}}) in [TOKEN/ETH]: {{rateDescription}}</div>
      <!-- <b-form-group id="exampleGroup4"> -->
        <!-- <b-form-checkbox-group v-model="form.checked" id="exampleChecks"> -->
          <!-- <b-form-checkbox value="me">Check me out</b-form-checkbox> -->
          <!-- <b-form-checkbox value="that">Check that out</b-form-checkbox> -->
        <!-- </b-form-checkbox-group> -->
      <!-- </b-form-group> -->
    </div>
    <span style="color:red;font-size:14px;"><i>{{tokenNumberError}}</i></span>
    </b-form>
  </div>
</template>

<script>
var BigNumber = require('bignumber.js')

var radioOptions = ['No', 'Yes']
export default {
  data () {
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
    UnSave () {
      for (var key in this.form) {
        console.log('form[' + key + '] = ' + this.form[key])
        this.$store.state.formI[key] = this.form[key]
      }
      this.$store.state.formI = this.form
      console.log('Stored form: ', this.$store.state.form)
      this.unsaved = true
    },
    onSubmit (evt) {
      evt.preventDefault()
      alert(JSON.stringify(this.form))
    },
    localNumber: function (val) {
      if (isNaN(val)) return 0
      var entry = parseFloat(val)
      var num = entry.toLocaleString()
      return num
    },
    onReset (evt) {
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

</style>
<!-- b-form-1.vue -->
