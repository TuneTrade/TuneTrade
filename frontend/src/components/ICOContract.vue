<template>
  <div>
    <b-form disabled @submit="onSubmit" @reset="onReset" v-if="show" class="newContractForm">
      <div class="newContractFormContainer">
        <b-form-group id="ICOYesNoGroup"
                      label="Create ICO Contract ?"
                      label-for="ICOYesNoGroup"
                      >
          <b-form-radio-group id="ICOYesNoGroup"
                      button-variant="outline-primary"
                      buttons
                      size="sm"
                      required
                      @change="UnSave()"
                      v-model="form.ico"
                      :options="['Yes','No']"
                      name="" />
        </b-form-group>
      <b-form-group id="nameInputGroup"
                    label="Contribution Wallet Address:"
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
                    label="Tokens for a team:"
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

      <b-form-group id="minpresaleGroup"
                    label="Minimum Contribution PreSale:"
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
                    label="Minimum Contribution MainSale:"
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
                    label="Maximum Contribution Ether"
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
                    label="Maximum Cap"
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
                    label="Minimum Cap"
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
                    label="Token Price ETH"
                    label-for="priceETH">
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
                    label="Campaign Duration Days"
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
                    label="Presale Duration Days"
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
      <!-- <b-form-group id="exampleGroup4"> -->
        <!-- <b-form-checkbox-group v-model="form.checked" id="exampleChecks"> -->
          <!-- <b-form-checkbox value="me">Check me out</b-form-checkbox> -->
          <!-- <b-form-checkbox value="that">Check that out</b-form-checkbox> -->
        <!-- </b-form-checkbox-group> -->
      <!-- </b-form-group> -->
    </div>
    </b-form>
  </div>
</template>

<script>
export default {
  data () {
    return {
      form: {
        wallet: '',
        ico: 'No',
        teamtokens: 0,
        minpresale: 0,
        minmainsale: 0,
        maxcontributioneth: '',
        maxcap: '',
        mincap: 0,
        priceETH: '',
        campaignDuration: '',
        presaleDuration: ''
      },
      show: true,
      test: false
    }
  },
  created: function () {
  },
  computed: {

    totalSupplyInfo: function () {
      return 'Total supply: ' + this.localNumber(this.$store.state.form.totalSupply)
    },
    ICODisabled: function () {
      if (this.form.ico === 'Yes') return false
      else return true
    }
  },
  methods: {
    UnSave () {
      for (var key in this.form) {
        console.log('form[' + key + '] = ' + this.form[key])
        this.$store.state.form[key] = this.form[key]
      }
      this.$store.state.form = this.form
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
