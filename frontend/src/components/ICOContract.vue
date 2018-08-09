<template>
  <div>
    Name:{{form.name}}
    <b-form @submit="onSubmit" @reset="onReset" v-if="show" class="newContractForm">
      <div class="newContractFormContainer">

      <b-form-group id="nameInputGroup"
                    label="Contribution Wallet Address:"
                    label-for="wallet">
        <b-form-input id="nameInput"
                      type="text"
                      v-model="form.wallet"
                      required
                      size="sm"
                      @keydown.native = "UnSave()"
                      @change = "UnSave()"
                      placeholder="0xAb778A157dEC26bc3eF341d0De042FD2A2F38E1d">
        </b-form-input>
      </b-form-group>


      <b-form-group id="teamtokensInputGroup"
                    label="Tokens for a team:"
                    label-for="teamtokens">
        <b-form-input id="teamtokens"
                      type="number"
                      v-model="form.teamtokens"
                      @change = "UnSave()"
                      optional
                      @keydown.native = "UnSave()"
                      size="sm"
                      step="0.1"
                      placeholder="Enter name">
        </b-form-input>
      </b-form-group>

      <b-form-group id="minpresaleGroup"
                    label="Minimum Contribution PreSale:"
                    label-for="minpresale">
        <b-form-input id="minpersale"
                      type="number"
                      v-model="form.minpresale"
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
                      @keydown.native = "UnSave()"
                      optional
                      size="sm"
                      placeholder="Enter Campaign Duration Days"
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
      <b-button type="submit" variant="primary">Save</b-button>
      <b-button type="reset" variant="danger">Reset</b-button>
    </b-form>
  </div>
</template>

<script>
export default {
  data () {
    return {
      form: {
        wallet: '',
        teamtokens: '',
        minpresale: '',
        minmainsale: '',
        maxcontributioneth: '',
        maxcap: '',
        mincap: '',
        priceETH: '',
        campaignDuration: ''
      },
      show: true
    }
  },
  created: function () {
  },
  methods: {
    UnSave () {
      console.log('ICOContract Unsaved')
    },
    onSubmit (evt) {
      evt.preventDefault()
      alert(JSON.stringify(this.form))
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

<!-- b-form-1.vue -->
